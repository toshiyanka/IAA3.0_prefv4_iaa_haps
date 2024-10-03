//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
// hqm_lsp_cq_cos_arb
//
// COS-aware CQ arbiter.
// - Each COS performs a RR to determine the next winner for that COS
// - Based on configured weights, "randomly" (based on cos_bw_count) choose a COS or nothing
// - If a configured COS is chosen:
//   - If the chosen COS has a valid request, the RR winner for that COS is the overall winner
//   - Else the COS with the smallest (cfg minus count = delta ) value and a valid request is chosen as the potential
//     winner; if the count=0 and cfg_no_extra_credit=1, the delta is modified to be > MAX (lowest priority):
//     - If there is no other COS with a valid request and the same delta value, that is the overall winner
//     - Else a fair sequencer imparts an order on all the COS with valid requests and that same tied value to break
//       the tie and select the overall winner
//   - The result of this backup count arbiter may be overridden by the starv_avoid arbiter if a COS has been deprived of
//     sharing in the excess bandwidth for a while
// - If an unconfigured COS is chosen, the fair sequencer imparts an order on all the COS with valid requests
//   to select the overall winner
//------------------------------------------------------------------------------------------
// Note:
//  - possibly add cfg count (4 x 64-bit) for schedule due to unconfigured bandwidth
//------------------------------------------------------------------------------------------

module hqm_lsp_cq_cos_arb
  import hqm_AW_pkg::*;
#(
  parameter NUM_REQS            = 64
, parameter NUM_COS             = 4
, parameter NUM_VAL             = 1             // Replication factor for output v
, parameter CNT_WIDTH           = 16
, parameter WEIGHT_WIDTH        = 8
, parameter STARV_AVOID_THRESH_WIDTH    = 10
//..........................................................................................
, parameter NUM_REQSB2          = ( AW_logb2 ( NUM_REQS - 1 ) + 1 )             // 6
, parameter NUM_REQS_PER_COS    = ( NUM_REQS / NUM_COS )                        // 16
, parameter NUM_REQS_PER_COSB2  = ( AW_logb2 ( NUM_REQS_PER_COS - 1 ) + 1 )     // 4
, parameter MAX_COS             = ( NUM_COS - 1 )                               // 3
, parameter MAX_COSB2           = ( AW_logb2 ( MAX_COS - 1 ) + 1 )              // 2
, parameter NUM_COSB2           = ( AW_logb2 ( NUM_COS - 1 ) + 1 )              // 2
, parameter STARV_AVOID_CNT_WIDTH       = ( STARV_AVOID_THRESH_WIDTH + 1 )
) (
  input logic clk
, input logic rst_n

, input  logic [(NUM_COS*(WEIGHT_WIDTH+1))-1:0] cfg_range
, input  logic                                  cfg_range_reconfig
, input  logic [(NUM_COS*CNT_WIDTH)-1:0]        cfg_credit_sat
, input  logic [NUM_COS-1:0]                    cfg_no_extra_credit
, input  logic                                  cfg_starv_avoid_enable
, input  logic [STARV_AVOID_THRESH_WIDTH-1:0]   cfg_starv_avoid_thresh_min
, input  logic [STARV_AVOID_THRESH_WIDTH-1:0]   cfg_starv_avoid_thresh_max
, output logic [(NUM_COS*CNT_WIDTH)-1:0]        cfg_credit_cnt
, output logic [(NUM_COS*STARV_AVOID_CNT_WIDTH)-1:0]    cfg_starv_avoid_cnt
, output logic [NUM_COS-1:0]                    cfg_schd_cos
, output logic [NUM_COS-1:0]                    cfg_rdy_cos
, output logic [NUM_COS-1:0]                    cfg_rnd_loss_cos
, output logic [NUM_COS-1:0]                    cfg_cnt_win_cos

, input  logic [NUM_REQS-1:0]                   reqs
, input  logic                                  update
, output logic [NUM_VAL-1:0]                    winner_v
, output logic [NUM_REQSB2-1:0]                 winner
, output logic                                  arb_error_f
, output logic [3:0]                            arb_status
) ;

//------------------------------------------------------------------------------------------
generate
  // NUM_COS > 4 not supported because:
  //   - NUM_COS other than power of 2 is not likely to be useful 
  //   - NUM_COS = 2 is trivial and would never be used
  //   - NUM_COS = 4 requires sequencer ( cos_seq_f ) 4! = 24; NUM_COS = 8 would require sequencer 8! = 40320
  if ( NUM_COS != 4 ) begin : invalid
    for ( genvar gi = NUM_COS ; gi <= NUM_COS ; gi = gi + 1 ) begin : NUM_COS
      hqm_lsp_cq_cos_arb__INVALID_NUM_COS_PARAM i_bad ( .clk() );
    end
  end
endgenerate
//------------------------------------------------------------------------------------------

localparam SUB_WIDTH            = CNT_WIDTH + 1 ;               // Extra bit for borrow
localparam DELTA_WIDTH          = CNT_WIDTH + 1 ;               // Extra bit for forced "max" value for cfg_no_extra_credit feature

logic [NUM_REQS-1:0]                            p0_reqs_nxt ;
logic [NUM_REQS-1:0]                            p0_reqs_f ;
logic [(NUM_COS*NUM_VAL)-1:0]                   p0_winner_v_nxt ;
logic [(NUM_COS*NUM_VAL)-1:0]                   p0_winner_v_f ;

logic                                           arb_error_nxt ;

logic [NUM_COS-1:0]                             cos_arb_update ;
logic [NUM_COS-1:0]                             cos_winner_v ;
logic [(NUM_COS*NUM_REQS_PER_COSB2)-1:0]        cos_winner ;

logic [WEIGHT_WIDTH:0]                          cfg_range_ar [NUM_COS-1:0] ;
logic [WEIGHT_WIDTH-1:0]                        cos_bw_count_nxt [NUM_COS-1:0] ;
logic [WEIGHT_WIDTH-1:0]                        cos_bw_count_f [NUM_COS-1:0] ;
logic [WEIGHT_WIDTH-1:0]                        cos_bw_count_upd [NUM_COS-1:0] ;
logic [NUM_COS-1:0]                             cos_bw_count_carry ;

logic [NUM_COS-1:0]                             cos_bw_req_count_inc ;
logic [NUM_COS-1:0]                             cos_bw_req_count_dec ;
logic [NUM_COSB2:0]                             cos_bw_req_count_nxt [NUM_COS-1:0] ;
logic [NUM_COSB2:0]                             cos_bw_req_count_f [NUM_COS-1:0] ;

logic                                           rnd_arb_update ;
logic [NUM_COS-1:0]                             rnd_arb_reqs ;
logic                                           rnd_winner_raw_v ;
logic                                           rnd_winner_v ;
logic                                           rnd_winner_configured ;
logic [NUM_COSB2-1:0]                           rnd_cosnum ;
logic                                           rnd_winner_lost_opp ;

logic [(NUM_COS*CNT_WIDTH)-1:0]                 cos_count_nxt ;
logic [(NUM_COS*CNT_WIDTH)-1:0]                 cos_count_f ;
logic [(NUM_COS*SUB_WIDTH)-1:0]                 cos_count_sub ;
logic [(NUM_COS*DELTA_WIDTH)-1:0]               cos_count_delta ;
logic [NUM_COS-1:0]                             cos_count_gt_0 ;
logic [NUM_COS-1:0]                             cos_count_lt_cfg ;

                                                                                                                // Dimensions shown below are for NUM_COS=4
logic [MAX_COS-1:0]                             cos_countd_lt_cos_countdx_pnc [MAX_COS-1:0] ;                   // 3 x 3
logic [MAX_COS-1:0]                             cos_countd_eq_cos_countdx_pnc [MAX_COS-1:0] ;                   // 3 x 3
logic [MAX_COS-1:0]                             cos_countd_le_cos_countdx_pnc [MAX_COS-1:0] ;                   // 3 x 3
logic [NUM_COS-1:0]                             cos_countd_eq_all_cos_countdx [NUM_COS-1:0] ;                   // 4 x 4
logic [MAX_COS-1:0]                             cos_count_compare_vec [NUM_COS-1:0] ;                           // 4 x 3        Assert, no two vectors have same nonzero # of ones

logic [MAX_COSB2-1:0]                           cos_count_num_winners [NUM_COS-1:0] ;                           // 4 x 2        Assert, no two COS have same encoding and != 0
logic [NUM_COSB2-1:0]                           cos_count_num_winners_cosnum [NUM_COS-1:0] [NUM_COS-1:0] ;      // 4 x 4 x 2    { sel position, count for COS n, cosnum }
                                                                                                                //              Assert, for each sel no more than one cosnum > 0
logic [(NUM_COS*NUM_COSB2)-1:0]                 cos_sel_nxt ;                                                   // 4 x 2        { sel position, cosnum }
logic [(NUM_COS*NUM_COSB2)-1:0]                 cos_sel_f ;                                                     // 4 x 2        { sel position, cosnum }
                                                                                                                //              Assert, each sel must have unique number

// The "neqcount" arbiter is the building block which chooses a winner without considering ties.  If the neqcount winner
// is tied the neqcount arbiter results are ignored.
logic [NUM_COS-1:0]                             neqcount_arb_reqs ;
logic [NUM_COSB2-1:0]                           neqcount_winner ;
logic                                           neqcount_winner_v ;             // Without considering ties
logic [NUM_COSB2-1:0]                           neqcount_cosnum ;
logic [NUM_COS-1:0]                             neqcount_eq_any ;
logic [NUM_COS-1:0]                             neqcount_tied ;
logic [NUM_COS-1:0]                             neqcount_tied_vec ;
logic                                           neqcount_winner_tied ;

// The "bkup" arbiter is the composite of the neqcount arbiter and the seq arbiter (if there is a tie)
logic                                           bkup_winner_v ;
logic [NUM_COSB2-1:0]                           bkup_cosnum_pre_ovr ;           // Before possible high-priority override
logic [NUM_COSB2-1:0]                           bkup_cosnum ;
logic                                           bkup_cosnum_from_seqarb ;

logic [4:0]                                     cos_seq_nxt ;                   // Only supported for NUM_COS=4
logic [4:0]                                     cos_seq_f ;
logic [NUM_COSB2-1:0]                           cos_seq_sel [NUM_COS-1:0] ;     // backup cos_sel values chosen by sequencer

logic [(NUM_COS*NUM_COS)-1:0]                   cos_eq_nxt ;
logic [(NUM_COS*NUM_COS)-1:0]                   cos_eq_f ;
logic [(NUM_COS*NUM_COS)-1:0]                   cos_eq_v ;

// The starv_avoid arbiter allows a COS to override the bkup arbiter if a COS is being starved from sharing in excess bandwidth
logic [STARV_AVOID_CNT_WIDTH-1:0]               starv_avoid_count_nxt [NUM_COS-1:0] ;
logic [STARV_AVOID_CNT_WIDTH-1:0]               starv_avoid_count_f [NUM_COS-1:0] ;

logic                                           starv_avoid_count_update_cond ;
logic                                           starv_avoid_high_pri_override_cond ;
logic [NUM_COS-1:0]                             starv_avoid_count_inc ;
logic [NUM_COS-1:0]                             starv_avoid_count_dec ;
logic [NUM_COS-1:0]                             starv_avoid_count_clr ;

logic [NUM_COS-1:0]                             starv_avoid_arb_reqs ;
logic                                           starv_avoid_arb_update ;
logic                                           starv_avoid_arb_winner_v ;
logic [NUM_COSB2-1:0]                           starv_avoid_arb_winner ;
logic [NUM_COSB2:0]                             starv_avoid_arb_reqs_tot ;

// The "seq" arbiter is used to break ties between bkup arb requests, and to fairly select a COS when the rnd-selected value is not in a configured range
logic [NUM_COS-1:0]                             seq_arb_eligible ;
logic                                           seq_arb_used ;
logic [NUM_COS-1:0]                             seq_arb_reqs ;
logic                                           seq_arb_winner_v ;
logic [NUM_COSB2-1:0]                           seq_arb_winner ;
logic [NUM_COSB2-1:0]                           seq_arb_cosnum ;

logic                                           winner_v_int ;
logic [NUM_COSB2-1:0]                           winner_cosnum ;
logic [NUM_REQS_PER_COSB2-1:0]                  winner_cq ;

logic                                           update_prev_nxt ;
logic                                           update_prev_f ;

assign p0_reqs_nxt                              = reqs ;

always_comb begin
  winner_v                                      = { NUM_VAL { 1'b0 } } ;
  arb_status                                    = 4'h0 ;

  for ( int i = 0 ; i < NUM_COS ; i = i + 1 ) begin
    p0_winner_v_nxt [ (i*NUM_VAL) +: NUM_VAL ]  = { NUM_VAL { ( ( | reqs [ (i*NUM_REQS_PER_COS) +: NUM_REQS_PER_COS ] ) & ~ update ) } } ;

    winner_v                                    = winner_v | p0_winner_v_f [ (i*NUM_VAL) +: NUM_VAL ] ;         // Can use this since work-conserving, checked with assertion

    arb_status [i]                              = ( | p0_reqs_f [ (i*NUM_REQS_PER_COS) +: NUM_REQS_PER_COS ] ) ;
  end // for i

end // always

assign update_prev_nxt                          = update ;

assign arb_error_nxt                            = ( update & ~ winner_v_int ) |         // Error in parent logic - arb state should never update if no current winner
                                                  ( update & update_prev_f ) ;          // Error in parent logic - should never get back-to-back

//------------------------------------------------------------------------------------------
// COS random arbiter - called "random" for legacy reasons but based on configured bandwidth
// "Randomly" pick one of the COS RR arbiter outputs based on config weights.
// Not work-conserving, that COS may not have a valid request, or rnd arbiter may not have any
// COS due for a slice of bandwidth if all bandwith is not configured.
generate
  for ( genvar gi = 0 ; gi < NUM_COS ; gi = gi + 1 ) begin: gen_cq_cos_arb_cos_arb
    assign cos_arb_update [ gi ]        = update & winner_v_int & ( winner_cosnum == gi ) ;

    hqm_AW_rr_arb # ( .NUM_REQS ( NUM_REQS_PER_COS ) ) i_hqm_AW_rr_arb_cos (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .reqs                 ( p0_reqs_f [ ( gi * NUM_REQS_PER_COS ) +: NUM_REQS_PER_COS ] )
        , .update               ( cos_arb_update [ gi ] )
        , .winner_v             ( cos_winner_v [ gi ] )
        , .winner               ( cos_winner [ ( gi * NUM_REQS_PER_COSB2 ) +: NUM_REQS_PER_COSB2 ] )
    ) ;

    assign { cos_bw_count_carry [gi] , cos_bw_count_upd [gi] }  = { 1'b0 , cos_bw_count_f [gi] } + cfg_range_ar [gi] ;  // mod WEIGHT_WIDTH, can't carry into bit n+2

    assign cos_bw_req_count_inc [gi]    = update & cos_bw_count_carry [gi] ;
    assign cos_bw_req_count_dec [gi]    = rnd_arb_update & ( rnd_cosnum == gi ) ;

    always_comb begin
      cfg_range_ar [gi]         = cfg_range [ ( gi * (WEIGHT_WIDTH+1) ) +: (WEIGHT_WIDTH+1)] ;

      cos_bw_count_nxt [gi]     = cos_bw_count_f [gi] ;
      cos_bw_req_count_nxt [gi] = cos_bw_req_count_f [gi] ;

      if ( cfg_range_reconfig ) begin   // Ensure good starting point after reconfigure
        cos_bw_count_nxt [gi]           = { WEIGHT_WIDTH { 1'b0 } } ;
        cos_bw_req_count_nxt [gi]       = { (NUM_COSB2+1) { 1'b0 } } ;
      end
      else begin
        if ( update ) begin                                             // Advance bw-calculation counts on every schedule, regardless of chosen
          cos_bw_count_nxt [gi]         = cos_bw_count_upd [gi] ;       // Possibly wrapping, OK
        end

        case ( { cos_bw_req_count_inc [gi] , cos_bw_req_count_dec [gi] } )
          2'b01 : cos_bw_req_count_nxt [gi]   = cos_bw_req_count_f [gi] - { { NUM_COSB2 { 1'b0 } } , 1'b1 } ;    // Borrow not possible
          2'b10 : cos_bw_req_count_nxt [gi]   = cos_bw_req_count_f [gi] + { { NUM_COSB2 { 1'b0 } } , 1'b1 } ;    // Carry not possible
          default : cos_bw_req_count_nxt [gi] = cos_bw_req_count_f [gi] ;
        endcase
      end
    end // always


    assign rnd_arb_reqs [gi]    = ( | cos_bw_req_count_f [gi] ) ;
  end // for
endgenerate

assign rnd_arb_update           = update & rnd_winner_configured ;      // Only advance selector if a configured COS was chosen

// Not immediately obvious, but winner_v will always be true if all bandwidth is configured.
hqm_AW_rr_arb # ( .NUM_REQS ( NUM_COS ) ) i_hqm_AW_rr_arb_rnd (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .reqs                 ( rnd_arb_reqs )
        , .update               ( rnd_arb_update )
        , .winner_v             ( rnd_winner_configured )
        , .winner               ( rnd_cosnum )
) ;

assign rnd_winner_raw_v         = cos_winner_v [ rnd_cosnum ] ;         // Valid req from COS which rnd arbiter chose; might be 0 if not all configured

assign rnd_winner_v             =   rnd_winner_raw_v & rnd_winner_configured ;
assign rnd_winner_lost_opp      = ~ rnd_winner_raw_v & rnd_winner_configured & ( | cos_winner_v ) ;     // Lost opportunity to schedule via configured bandwidth

//------------------------------------------------------------------------------------------
// Non-equal count backup arbiter
// Select the COS with the smallest delta (cfg minus count) that has a valid request.  If there is no
// other COS with a valid request and the same (cfg minus count), that is the winner, otherwise rely
// on the equal arbiter.  If the neq arbiter wins, decrement the count for this neq COS (saturating at 0)
// and increment the count for the "losing" COS (the one which random selected but did not have a request,
// saturating at the config value).
// Due to dynamic configuration changes, it's possible that cos_count > cfg_credit_sat ; treat such a case as having a delta of 0.

always_comb begin
  for ( int i = 0 ; i < NUM_COS ; i = i + 1 ) begin

    cos_count_gt_0 [ i ]                                = ( | cos_count_f [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] ) ;
    cos_count_lt_cfg [ i ]                              = ( cos_count_f [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] < cfg_credit_sat [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] ) ;
    cos_count_nxt [ ( i * CNT_WIDTH ) +: CNT_WIDTH ]    =   cos_count_f [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] ;

    if ( update & bkup_winner_v ) begin                                 // If updating via bkup arbiter due to lost opportunity, rnd_cosnum will not equal bkup_cosnum
      if ( ( bkup_cosnum == i ) & cos_count_gt_0 [ i ] ) begin          // bkup winner is stealing a cycle so charge it credit, don't underflow
        cos_count_nxt [ ( i * CNT_WIDTH ) +: CNT_WIDTH ]        = ( cos_count_f [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] - { { (CNT_WIDTH-1) { 1'b0 } } , 1'b1 } ) ;
      end
      if ( ( rnd_cosnum == i ) & cos_count_lt_cfg [ i ] ) begin         // rnd winner lost a cycle so return a credit to it, don't exceed cfg value
        cos_count_nxt [ ( i * CNT_WIDTH ) +: CNT_WIDTH ]        = ( cos_count_f [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] + { { (CNT_WIDTH-1) { 1'b0 } } , 1'b1 } ) ;
      end
    end

    cos_count_sub [ ( i * SUB_WIDTH ) +: SUB_WIDTH ]            = ( { 1'b0 , cfg_credit_sat [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] } - { 1'b0 , cos_count_f [ ( i * CNT_WIDTH ) +: CNT_WIDTH ] } ) ;
    if ( ( ~ cos_count_gt_0 [ i ] ) & cfg_no_extra_credit [ i ] ) begin
      cos_count_delta [ ( i * DELTA_WIDTH ) +: DELTA_WIDTH ]    = { 1'b1 , { CNT_WIDTH { 1'b0 } } } ;                           // Force to same large delta, lowest priority
    end
    else if ( cos_count_sub [ ( ( i * SUB_WIDTH ) + CNT_WIDTH ) +: 1 ] ) begin                                                  // Borrow, could only happen after dynamic cfg change
      cos_count_delta [ ( i * DELTA_WIDTH ) +: DELTA_WIDTH ]    = { 1'b0 , { CNT_WIDTH { 1'b0 } } } ;                           // If underflow force delta to 0, highest priority
    end
    else begin
      cos_count_delta [ ( i * DELTA_WIDTH ) +: DELTA_WIDTH ]    = { 1'b0 , cos_count_sub [ ( i * SUB_WIDTH ) +: CNT_WIDTH ] } ; // No underflow
    end
  end // for i
end // always

//----------------------------------------------------------------------------------------------------------
// For each COS, create bit vector of "<=" comparisons of its count delta with the count deltas for each of the other COS.
// Number of ones in the vector indicates how many COS this COS wins over.  Include "=" in the comparison to
// guarantee there is a unique number of winners for each COS, strictly favoring smaller-numbered COS.
// Compress out bit "i" for vector "i".  No two vectors will have the same number of bits = 1.
// cos_countd_lt_cos_countdx_pnc is only partially used: [0,1...n-1], [1,2...n-1] etc., because don't need comparison with
// self, and only need a <= b or it's opposite (b < a) between a given pair.
always_comb begin
  for ( int i=0; i<MAX_COS ; i++ ) begin
    cos_countd_lt_cos_countdx_pnc [ i ]         = { MAX_COS { 1'b0 } } ;
    cos_countd_eq_cos_countdx_pnc [ i ]         = { MAX_COS { 1'b0 } } ;
    cos_countd_le_cos_countdx_pnc [ i ]         = { MAX_COS { 1'b0 } } ;
    for ( int j=i; j<MAX_COS ; j++ ) begin
      cos_countd_lt_cos_countdx_pnc [ i ] [ j ] = ( cos_count_delta [ ( i * DELTA_WIDTH ) +: DELTA_WIDTH ] <  cos_count_delta [ ( (j+1) * DELTA_WIDTH ) +: DELTA_WIDTH ] ) ;
      cos_countd_eq_cos_countdx_pnc [ i ] [ j ] = ( cos_count_delta [ ( i * DELTA_WIDTH ) +: DELTA_WIDTH ] == cos_count_delta [ ( (j+1) * DELTA_WIDTH ) +: DELTA_WIDTH ] ) ;
      cos_countd_le_cos_countdx_pnc [ i ] [ j ] = cos_countd_lt_cos_countdx_pnc [ i ] [ j ] | cos_countd_eq_cos_countdx_pnc [ i ] [ j ] ;
    end // for j
  end // for i

  for ( int i=0; i<NUM_COS ; i++ ) begin
    cos_count_compare_vec [ i ]                 = { MAX_COS { 1'b0 } } ;
    for ( int j=0; j<MAX_COS ; j++ ) begin
      if ( j >= i )
        cos_count_compare_vec [ i ] [ j ]       =   cos_countd_le_cos_countdx_pnc [ i ] [ j ] ;
      else
        cos_count_compare_vec [ i ] [ j ]       = ~ cos_countd_le_cos_countdx_pnc [ j ] [ (i-1) ] ;
    end // for j
  end // for i

  // Create fully populated "equal" vectors to simplify downstream tiebreaker
  for ( int i=0; i<NUM_COS ; i++ ) begin
    cos_countd_eq_all_cos_countdx [i]           = { NUM_COS { 1'b0 } } ;                        // Zeroes the i==j bits
    for ( int j=0; j<NUM_COS ; j++ ) begin
      if ( i < j ) begin
        cos_countd_eq_all_cos_countdx [i] [j]   = cos_countd_eq_cos_countdx_pnc [i] [(j-1)] ;
      end
      else if ( i > j ) begin
        cos_countd_eq_all_cos_countdx [i] [j]   = cos_countd_eq_cos_countdx_pnc [j] [(i-1)] ;   // Get from other populated half, symmetric
      end
    end // for j
  end // for i
end // always

//----------------------------------------------------------------------------------------------------------
// For each COS, count number of bits = 1 in compare vector to determine its spot in the requestor order, where requestor 0
// has the highest priority.  Max number of ones = NUM_COS-1.
generate
  for ( genvar gi=0; gi<NUM_COS ; gi++ ) begin : gen_cos_count_sel
    hqm_AW_count_ones #( .WIDTH ( MAX_COS )) i_hqm_AW_count_ones (
          .a                            ( cos_count_compare_vec [ gi ] )
        , .z                            ( cos_count_num_winners [ gi ] )
    ) ;
  end // for gi
endgenerate

//----------------------------------------------------------------------------------------------------------
// For each COS, create it's contribution towards the select value for each COS position; if it is the COS with that
// position, provide the COS number, otherwise provide 0 since these are then bitwise ORed together.  Select 0 has highest
// priority: if all ones (winner over all), go to select 0.  Next highest (n minus 1 ones) goes to 1, etc.
always_comb begin
  cos_sel_nxt                                           = { (NUM_COS*NUM_COSB2) { 1'b0 } } ;
  cos_eq_nxt                                            = { (NUM_COS*NUM_COS) { 1'b0 } } ;

  for ( int sel=0; sel<NUM_COS ; sel++ ) begin                                  // select term
    for ( int coss=0; coss<NUM_COS ; coss++ ) begin                             // contribution from each COS
      if ( cos_count_num_winners [coss] == ( MAX_COS [MAX_COSB2-1:0] - sel [MAX_COSB2-1:0] ) ) begin    // More ones = higher priority = lower select value
        cos_count_num_winners_cosnum [sel] [coss]       = coss [MAX_COSB2-1:0] ;
      end
      else begin
        cos_count_num_winners_cosnum [sel] [coss]       = { NUM_COSB2 { 1'b0 } } ;      // No contribution to this select term by this COS
      end
      cos_sel_nxt [ ( sel * NUM_COSB2 ) +: NUM_COSB2 ]  = cos_sel_nxt [ ( sel * NUM_COSB2 ) +: NUM_COSB2 ] | cos_count_num_winners_cosnum [sel] [coss] ;
    end // for coss
  end // for sel

  // Create "equal" vector used by neqcount/eqcount tiebreaking 
  // Bits for COS = self will be optimized out
  for ( int i=0; i<NUM_COS ; i++ ) begin
    for ( int j=0; j<NUM_COS ; j++ ) begin
      cos_eq_nxt [ ( i * NUM_COS ) + j ]                = cos_countd_eq_all_cos_countdx [i] [j] ;
    end // for j
  end // for i
end

//----------------------------------------------------------------------------------------------------------
// Using the cos numbers ordered according to magnitude, select the highest priority COS which
// has a valid request, if any.  If no valid requests, output is a don't care - no update.  Don't yet factor
// in the possibility of there being a tie.
always_comb begin
  for ( int i=0; i<NUM_COS ; i++ ) begin
    cos_eq_v [ ( i * NUM_COS ) +: NUM_COS ]     = cos_eq_f [ ( i * NUM_COS ) +: NUM_COS ] & cos_winner_v ;
  end // for i
end // always

always_comb begin
  for ( int i=0; i<NUM_COS ; i++ ) begin
    neqcount_arb_reqs [ i ]     = cos_winner_v [ cos_sel_f [ ( i * NUM_COSB2 ) +: NUM_COSB2 ] ] ;

    neqcount_eq_any [ i ]       = | cos_eq_v [ ( i * NUM_COS ) +: NUM_COS ] ;
  end // for i
end // always

always_comb begin
  for ( int i=0; i<NUM_COS ; i++ ) begin
    neqcount_tied [ i ]         = neqcount_eq_any [ cos_sel_f [ ( i * NUM_COSB2 ) +: NUM_COSB2 ] ] ;
  end // for i
end // always

hqm_AW_binenc # ( .WIDTH ( NUM_COS ) ) i_hqm_AW_binenc_neqcount (
          .a                            ( neqcount_arb_reqs )
        , .enc                          ( neqcount_winner )             // The shuffled COS with the smallest (cfg minus count) delta and a valid request
        , .any                          ( neqcount_winner_v )
);

assign neqcount_winner_tied     = neqcount_tied [ neqcount_winner ] ;
assign neqcount_cosnum          = cos_sel_f [ ( neqcount_winner * NUM_COSB2 ) +: NUM_COSB2 ] ;  

// Force the original winner to appear eligible
assign neqcount_tied_vec        = cos_eq_v [ ( neqcount_cosnum * NUM_COS ) +: NUM_COS ] |       
                                  ( { { (NUM_COS-1) { 1'b0 }  } , 1'b1 } << neqcount_cosnum ) ;
always_comb begin
  bkup_winner_v                 = rnd_winner_lost_opp ;
  bkup_cosnum_from_seqarb       = 1'b0 ;
  if ( neqcount_winner_tied ) begin
    bkup_cosnum_pre_ovr         = seq_arb_cosnum ;
    bkup_cosnum_from_seqarb     = 1'b1 ;
  end
  else begin
    bkup_cosnum_pre_ovr         = cos_sel_f [ ( neqcount_winner * NUM_COSB2 ) +: NUM_COSB2 ] ;          
  end

  bkup_cosnum                   = bkup_cosnum_pre_ovr ;
  if ( starv_avoid_high_pri_override_cond ) begin       // See below
    bkup_cosnum                 = starv_avoid_arb_winner ;
    bkup_cosnum_from_seqarb     = 1'b0 ;
  end
end // always

//----------------------------------------------------------------------------------------------------------
// Random miss override
// Avoid case where a COS gets starved out of participation in excess bandwidth sharing.  Temporarily boost
// it's priority in the backup arbitration if it reaches its config threshold.  Config threshold width
// is "n" bits wide, count is n+1 to allow for 2x +/- range, "clear" operation set to middle value.
assign starv_avoid_count_update_cond    = cfg_starv_avoid_enable & rnd_winner_lost_opp ;

always_comb begin
  starv_avoid_arb_reqs_tot      = { (NUM_COSB2+1) { 1'b0 } } ;
  for ( int i=0; i<NUM_COS ; i++ ) begin
    starv_avoid_count_inc [i]   = starv_avoid_count_update_cond & update & ( bkup_cosnum_pre_ovr != i ) & cos_winner_v [i] &
                                        ( starv_avoid_count_f [i] < { 1'b1 , cfg_starv_avoid_thresh_max } ) ;           // Sat. inc at config max
    starv_avoid_count_dec [i]   = starv_avoid_count_update_cond & update & ( bkup_cosnum_pre_ovr == i ) &
                                        ( starv_avoid_count_f [i] > { 1'b0 , cfg_starv_avoid_thresh_min } ) ;           // Sat. dec at config min
    starv_avoid_count_clr [i]   = starv_avoid_high_pri_override_cond & update & ( starv_avoid_arb_winner == i ) ;       // This COS winning because of the starv_avoid arb

    starv_avoid_count_nxt [i]   = starv_avoid_count_f [i] ;
    if ( starv_avoid_count_clr [i] ) begin
      starv_avoid_count_nxt [i] = { 1'b1 , { (STARV_AVOID_CNT_WIDTH-1) { 1'b0 } } } ;           // "clear" to midpoint
    end
    else if ( starv_avoid_count_inc [i] ) begin                                                 // inc and dec are mutually exclusive
      starv_avoid_count_nxt [i] = starv_avoid_count_f[i] + { { (STARV_AVOID_CNT_WIDTH-1) { 1'b0 } } , 1'b1 } ;  // inc is disabled if count = cfg max, will not overflow/wrap
    end
    else if ( starv_avoid_count_dec [i] ) begin
      starv_avoid_count_nxt [i] = starv_avoid_count_f[i] - { { (STARV_AVOID_CNT_WIDTH-1) { 1'b0 } } , 1'b1 } ;  // dec is disabled if count = cfg min, will not underflow/wrap
    end

    starv_avoid_arb_reqs [i]    = ( starv_avoid_count_f [i] >= { 1'b1 , cfg_starv_avoid_thresh_max } ) & cos_winner_v [i] ;
    starv_avoid_arb_reqs_tot    = starv_avoid_arb_reqs_tot + { { NUM_COSB2 { 1'b0 } } , starv_avoid_arb_reqs [i] } ;

    cfg_starv_avoid_cnt [ ( i * STARV_AVOID_CNT_WIDTH ) +: STARV_AVOID_CNT_WIDTH ]      = starv_avoid_count_f [i] ;
  end // for i

end // always

hqm_AW_rr_arb # ( .NUM_REQS ( NUM_COS ) ) i_hqm_AW_rr_arb_cos_starv_avoid (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .reqs                 ( starv_avoid_arb_reqs )
        , .update               ( starv_avoid_arb_update )
        , .winner_v             ( starv_avoid_arb_winner_v )
        , .winner               ( starv_avoid_arb_winner )
) ;

// Backup arbiter is needed, one or more COS is in need of a high-priority override, and the COS selected by the starv_avoid
// arbiter is different from the COS that would have otherwise been selected by the backup arbiter.
assign starv_avoid_high_pri_override_cond       = starv_avoid_count_update_cond & starv_avoid_arb_winner_v & ( starv_avoid_arb_winner != bkup_cosnum_pre_ovr ) ;

// Only update arbiter if actually used to break a tie
assign starv_avoid_arb_update           = starv_avoid_high_pri_override_cond & update & ( starv_avoid_arb_reqs_tot > { { NUM_COSB2 { 1'b0 } } , 1'b1 } ) ;

//----------------------------------------------------------------------------------------------------------
// equal arbiter.  Used for two reasons:
// - the neq arbiter is selected to choose a winner, but there are other COS with requests and the same countd as the chosen winner
//   Arbitrate among COS with requests that have that same countd.
// - the rnd arbiter failed to choose a configured COS.  Choose from among all COS with requests

assign seq_arb_eligible         = cos_winner_v &
                                    ( { NUM_COS { ~ rnd_winner_configured } } |                         // All are eligible
                                      ( { NUM_COS {  neqcount_winner_v } } & neqcount_tied_vec ) ) ;    // Tied COS are eligible

// For the eqcount arbiter look at the arb eligible bits as ordered by the sequencer
always_comb begin
  for ( int i=0; i<NUM_COS ; i++ ) begin
    seq_arb_reqs [ i ]          = seq_arb_eligible [ cos_seq_sel [ i ] ] ;
  end // for i
end // always

hqm_AW_binenc # ( .WIDTH ( NUM_COS ) ) i_hqm_AW_binenc_eqcount (
          .a                            ( seq_arb_reqs )
        , .enc                          ( seq_arb_winner )
        , .any                          ( seq_arb_winner_v )
);

assign seq_arb_cosnum           = cos_seq_sel [ seq_arb_winner ] ;

assign seq_arb_used             = update & winner_v_int & ( ~ rnd_winner_configured | ( ~ rnd_winner_v & neqcount_winner_v & bkup_cosnum_from_seqarb ) ) ;

//----------------
// Sequencer used to impart fair order among 2, 3 or 4 requestors, requires 2x3x4=24 possible sequences
always_comb begin
  cos_seq_nxt           = cos_seq_f ;
  if ( seq_arb_used ) begin
    if ( cos_seq_f >= 5'h17 ) begin     // Should never be >
      cos_seq_nxt       = 5'h0 ;
    end
    else begin
      cos_seq_nxt       = ( cos_seq_f + 5'h1 ) ;
    end
  end
end // always

generate
  if ( NUM_COS == 4 ) begin : gen_cos_seq_sel_eq_4
    always_comb begin
      // Default to strict, lower-numbered cos_seq_sel wins tie
      cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h0 ;
      case ( cos_seq_f )
        5'h00 : begin cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h1 ; cos_seq_sel[2] = 2'h2 ; cos_seq_sel[3] = 2'h3 ; end
        5'h01 : begin cos_seq_sel[0] = 2'h1 ; cos_seq_sel[1] = 2'h2 ; cos_seq_sel[2] = 2'h3 ; cos_seq_sel[3] = 2'h0 ; end
        5'h02 : begin cos_seq_sel[0] = 2'h2 ; cos_seq_sel[1] = 2'h3 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h1 ; end
        5'h03 : begin cos_seq_sel[0] = 2'h3 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h1 ; cos_seq_sel[3] = 2'h2 ; end

        5'h04 : begin cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h1 ; cos_seq_sel[2] = 2'h3 ; cos_seq_sel[3] = 2'h2 ; end
        5'h05 : begin cos_seq_sel[0] = 2'h1 ; cos_seq_sel[1] = 2'h3 ; cos_seq_sel[2] = 2'h2 ; cos_seq_sel[3] = 2'h0 ; end
        5'h06 : begin cos_seq_sel[0] = 2'h3 ; cos_seq_sel[1] = 2'h2 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h1 ; end
        5'h07 : begin cos_seq_sel[0] = 2'h2 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h1 ; cos_seq_sel[3] = 2'h3 ; end

        5'h08 : begin cos_seq_sel[0] = 2'h1 ; cos_seq_sel[1] = 2'h3 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h2 ; end
        5'h09 : begin cos_seq_sel[0] = 2'h3 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h2 ; cos_seq_sel[3] = 2'h1 ; end
        5'h0a : begin cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h2 ; cos_seq_sel[2] = 2'h1 ; cos_seq_sel[3] = 2'h3 ; end
        5'h0b : begin cos_seq_sel[0] = 2'h2 ; cos_seq_sel[1] = 2'h1 ; cos_seq_sel[2] = 2'h3 ; cos_seq_sel[3] = 2'h0 ; end

        5'h0c : begin cos_seq_sel[0] = 2'h1 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h3 ; cos_seq_sel[3] = 2'h2 ; end
        5'h0d : begin cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h3 ; cos_seq_sel[2] = 2'h2 ; cos_seq_sel[3] = 2'h1 ; end
        5'h0e : begin cos_seq_sel[0] = 2'h3 ; cos_seq_sel[1] = 2'h2 ; cos_seq_sel[2] = 2'h1 ; cos_seq_sel[3] = 2'h0 ; end
        5'h0f : begin cos_seq_sel[0] = 2'h2 ; cos_seq_sel[1] = 2'h1 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h3 ; end

        5'h10 : begin cos_seq_sel[0] = 2'h1 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h2 ; cos_seq_sel[3] = 2'h3 ; end
        5'h11 : begin cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h2 ; cos_seq_sel[2] = 2'h3 ; cos_seq_sel[3] = 2'h1 ; end
        5'h12 : begin cos_seq_sel[0] = 2'h2 ; cos_seq_sel[1] = 2'h3 ; cos_seq_sel[2] = 2'h1 ; cos_seq_sel[3] = 2'h0 ; end
        5'h13 : begin cos_seq_sel[0] = 2'h3 ; cos_seq_sel[1] = 2'h1 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h2 ; end

        5'h14 : begin cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h3 ; cos_seq_sel[2] = 2'h1 ; cos_seq_sel[3] = 2'h2 ; end
        5'h15 : begin cos_seq_sel[0] = 2'h3 ; cos_seq_sel[1] = 2'h1 ; cos_seq_sel[2] = 2'h2 ; cos_seq_sel[3] = 2'h0 ; end
        5'h16 : begin cos_seq_sel[0] = 2'h1 ; cos_seq_sel[1] = 2'h2 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h3 ; end
        5'h17 : begin cos_seq_sel[0] = 2'h2 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h3 ; cos_seq_sel[3] = 2'h1 ; end

        // Same as default assigns above
        default : begin cos_seq_sel[0] = 2'h0 ; cos_seq_sel[1] = 2'h0 ; cos_seq_sel[2] = 2'h0 ; cos_seq_sel[3] = 2'h0 ; end
      endcase
    end // always
  end // if NUM_COS
  else begin : gen_cos_seq_sel_neq_4
    for ( genvar gi = 0 ; gi < NUM_COS ; gi = gi + 1 ) begin: gen_cos_seq_sel_0_init
      assign cos_seq_sel [gi]            = { NUM_COSB2 { 1'b0 } } ;            // Excess bandwidth fairness not supported, revert to strict
    end // for gi
  end // else NUM_COS
endgenerate

//------------------------------------------------------------------------------------------
// Final selection - work-conserving

assign winner_v_int             = rnd_winner_v | bkup_winner_v | seq_arb_winner_v ;                             // derive internally to avoid loading winner_v output

always_comb begin
  if ( rnd_winner_v ) begin
    winner_cosnum               = rnd_cosnum ;
    winner_cq                   = cos_winner [ ( rnd_cosnum * NUM_REQS_PER_COSB2 ) +: NUM_REQS_PER_COSB2 ] ;            
  end
  else if ( bkup_winner_v ) begin
    winner_cosnum               = bkup_cosnum ;
    winner_cq                   = cos_winner [ ( bkup_cosnum * NUM_REQS_PER_COSB2 ) +: NUM_REQS_PER_COSB2 ] ;           
  end
  else begin    // only matters if seq_arb_winner_v
    winner_cosnum               = seq_arb_cosnum ;
    winner_cq                   = cos_winner [ ( seq_arb_cosnum * NUM_REQS_PER_COSB2 ) +: NUM_REQS_PER_COSB2 ] ;        
  end
end // always

assign winner                   = { winner_cosnum , winner_cq } ;

//------------------------------------------------------------------------------------------
always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    p0_reqs_f                   <= { NUM_REQS { 1'b0 } } ;
    p0_winner_v_f               <= { (NUM_COS*NUM_VAL) { 1'b0 } } ;
    update_prev_f               <= 1'b0 ;
    arb_error_f                 <= 1'b0 ;

    for ( int i=0; i<NUM_COS ; i++ ) begin
      cos_bw_count_f [i]        <= { WEIGHT_WIDTH { 1'b0 } } ;
      cos_bw_req_count_f [i]    <= { (NUM_COSB2+1) { 1'b0 } } ;
      starv_avoid_count_f [i]   <= { 1'b1 , { (STARV_AVOID_CNT_WIDTH-1) { 1'b0 } } } ;  // reset to midpoint
    end // for i

    cos_count_f                 <= { (NUM_COS*CNT_WIDTH) { 1'b0 } } ;
    cos_sel_f                   <= { (NUM_COS*NUM_COSB2) { 1'b0 } } ;
    cos_eq_f                    <= { (NUM_COS*NUM_COS) { 1'b0 } } ;
    cos_seq_f                   <= 5'h0 ;
  end
  else begin
    p0_reqs_f                   <= p0_reqs_nxt ;
    p0_winner_v_f               <= p0_winner_v_nxt ;
    update_prev_f               <= update_prev_nxt ;
    arb_error_f                 <= arb_error_nxt ;


    for ( int i=0; i<NUM_COS ; i++ ) begin
      cos_bw_count_f [i]        <= cos_bw_count_nxt [i] ;
      cos_bw_req_count_f [i]    <= cos_bw_req_count_nxt [i] ;
      starv_avoid_count_f [i]   <= starv_avoid_count_nxt [i] ;
    end // for i

    cos_count_f                 <= cos_count_nxt ;
    cos_sel_f                   <= cos_sel_nxt ;
    cos_eq_f                    <= cos_eq_nxt ;
    cos_seq_f                   <= cos_seq_nxt ;
  end
end // always

assign cfg_credit_cnt           = cos_count_f ;

//-----------------------------------------------------------------------------------------------------
// Config monitoring

always_comb begin
  for ( int i=0; i<NUM_COS ; i++ ) begin
    cfg_schd_cos [ i ]          = update & ( winner_cosnum == i ) ;
    cfg_rdy_cos [ i ]           = update & ( | ( p0_reqs_f [  ( i * NUM_REQS_PER_COS ) +: NUM_REQS_PER_COS ] ) ) ;
    cfg_rnd_loss_cos [ i ]      = update & rnd_winner_lost_opp & ( rnd_cosnum == i ) ;
    cfg_cnt_win_cos [ i ]       = update & rnd_winner_lost_opp & ( bkup_cosnum == i ) ;
  end // for i
end // always

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------
// Assertions - may want to move to separate file eventually
`ifndef INTEL_SVA_OFF

//----
// Detect configuration error - overlapping ranges and a valid request is present (live)
logic [NUM_COSB2+WEIGHT_WIDTH:0]        range_total_nnc ;               // Tool bug, signal is not a no-connect
logic dbg_cfg_overlap_err ;

always_comb begin
  range_total_nnc               = '0 ;
  for ( int i = 0 ; i < NUM_COS ; i = i + 1 ) begin
    range_total_nnc             = range_total_nnc + { { NUM_COSB2 { 1'b0 } } , cfg_range_ar [i] } ;
  end // for
end // always

assign dbg_cfg_overlap_err      = ( range_total_nnc > { { NUM_COSB2 { 1'b0 } } , 1'b1 , { (WEIGHT_WIDTH) { 1'b0 } } } ) & ( | reqs ) ;

//----
// Should never have more total pending requests than number of COS.  Note, jg is not able to prove this never fails.
logic dbg_cos_bw_req_err ;
logic [NUM_COSB2:0]     dbg_cos_bw_req_tot ;

always_comb begin
  dbg_cos_bw_req_err            = 1'b0 ;
  dbg_cos_bw_req_tot            = '0 ;

  for ( int i = 0 ; i < NUM_COS ; i = i + 1 ) begin
    dbg_cos_bw_req_tot          = dbg_cos_bw_req_tot + cos_bw_req_count_f[i] ;
  end // for i
  dbg_cos_bw_req_err            = ( dbg_cos_bw_req_tot > NUM_COS ) ;
end // always

//----
// Dynamic update of sat value no longer supported, should not be possible to get underflow
logic dbg_cos_count_uflow ;

always_comb begin
  dbg_cos_count_uflow           = 1'b0 ;

  for ( int i = 0 ; i < NUM_COS ; i = i + 1 ) begin
    dbg_cos_count_uflow         = dbg_cos_count_uflow | ( update & ( cos_count_sub [ ( ( i * SUB_WIDTH ) + CNT_WIDTH ) +: 1 ] ) ) ;
  end // for i
end // always

//----
// Each cos_count_compare_vec must have a unique number of ones; all values from 0 through NUM_COS-1.
// Each dbg_cos_count_num_winners value must be unique; all values from 0 through NUM_COS-1.
// For each COS, there must be no more than one cos_count_num_winners_cosnum [COS] value among all of its COSs
// Each cos_sel have a unique value ; all values from 0 through NUM_COS-1.

logic [NUM_COSB2-1:0]                           dbg_cos_count_compare_vec_num_ones ;
logic [NUM_COS-1:0]                             dbg_cos_count_compare_vec_num_ones_vec ;
logic                                           dbg_cos_count_compare_vec_error ;

logic [NUM_COS-1:0]                             dbg_cos_count_num_winners_vec ;
logic                                           dbg_cos_count_num_winners_vec_error ;

logic                                           dbg_cos_count_num_winners_cosnum_nonzero ;
logic                                           dbg_cos_count_num_winners_cosnum_error ;

logic                                           dbg_cos_sel_v_f ;
logic [NUM_COS-1:0]                             dbg_cos_sel_vec ;
logic                                           dbg_cos_sel_error ;

logic                                           dbg_winner_v_error ;
logic                                           dbg_winner_v_chk_v_f ;

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    dbg_cos_sel_v_f             <= 1'b0 ;
    dbg_winner_v_chk_v_f        <= 1'b0 ;
  end
  else begin
    dbg_cos_sel_v_f             <= 1'b1 ;
    dbg_winner_v_chk_v_f        <= ~ update ;
  end
end // always

always_comb begin
  dbg_cos_count_compare_vec_num_ones_vec                = '0 ;
  dbg_cos_count_num_winners_vec                         = '0 ;
  dbg_cos_sel_vec                                       = '0 ;
  dbg_cos_count_num_winners_cosnum_error                = 1'b0 ;

  for ( int i = 0 ; i < NUM_COS ; i = i + 1 ) begin
    dbg_cos_count_compare_vec_num_ones          = 0 ;
    dbg_cos_count_num_winners_cosnum_nonzero    = 1'b0 ;

    for ( int j = 0 ; j < MAX_COS ; j++ ) begin
      if (cos_count_compare_vec [i] [j] == 1'b1) dbg_cos_count_compare_vec_num_ones = dbg_cos_count_compare_vec_num_ones + 1;
    end // for j

    for ( int j = 0 ; j < NUM_COS ; j++ ) begin
      if ( ( cos_count_num_winners_cosnum [ i ] [ j ] > 0 ) && dbg_cos_count_num_winners_cosnum_nonzero ) begin
        dbg_cos_count_num_winners_cosnum_error  = 1'b1 ;
        dbg_cos_count_num_winners_cosnum_nonzero |= ( cos_count_num_winners_cosnum [ i ] [ j ] > 0 ) ;
      end
    end // for j

    dbg_cos_count_compare_vec_num_ones_vec [ dbg_cos_count_compare_vec_num_ones ]       = 1'b1 ;
    dbg_cos_count_num_winners_vec [ cos_count_num_winners [ i ] ]                       = 1'b1 ;
    dbg_cos_sel_vec [ cos_sel_f [ (i*NUM_COSB2) +: NUM_COSB2 ] ]                        = 1'b1 ;
  end // for i
end // always

assign dbg_cos_count_compare_vec_error          = ( dbg_cos_count_compare_vec_num_ones_vec != { NUM_COS { 1'b1 } } ) ;
assign dbg_cos_count_num_winners_vec_error      = ( dbg_cos_count_num_winners_vec != { NUM_COS { 1'b1 } } ) ;
assign dbg_cos_sel_error                        = dbg_cos_sel_v_f & ( dbg_cos_sel_vec != { NUM_COS { 1'b1 } } ) ;
assign dbg_winner_v_error                       = ( winner_v_int != winner_v [0] ) & dbg_winner_v_chk_v_f ;

hqm_lsp_cq_cos_arb_assert i_hqm_lsp_cq_cos_arb_assert (.*) ;

//----------------
// To simplify sim debug
logic [NUM_COS-1:0]             cfg_sch_uncfg_cos ;
logic [15:0]                    cfg_sch_uncfg_cos_count_f [NUM_COS-1:0] ;

always_comb begin
  for ( int i=0; i<NUM_COS ; i++ ) begin
    cfg_sch_uncfg_cos [ i ]     = update & ~ rnd_winner_configured & ( winner_cosnum == i ) ;
  end // for i
end // always

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    for ( int i=0; i<NUM_COS ; i++ ) begin
      cfg_sch_uncfg_cos_count_f [i]     <= '0 ;
    end
  end
  else begin
    for ( int i=0; i<NUM_COS ; i++ ) begin
      if ( cfg_sch_uncfg_cos [i] )
        cfg_sch_uncfg_cos_count_f [i]   <= cfg_sch_uncfg_cos_count_f [i] + 1 ;
    end
  end
end // always
//----------------


`endif  // INTEL_SVA_OFF

endmodule // hqm_lsp_cq_cos_arb

`ifndef INTEL_SVA_OFF

module hqm_lsp_cq_cos_arb_assert import hqm_AW_pkg::*; (
          input logic clk
        , input logic rst_n
        , input logic dbg_cfg_overlap_err
        , input logic dbg_cos_bw_req_err
        , input logic dbg_cos_count_uflow
        , input logic dbg_cos_count_compare_vec_error
        , input logic dbg_cos_count_num_winners_vec_error
        , input logic dbg_cos_count_num_winners_cosnum_error
        , input logic dbg_cos_sel_error
        , input logic dbg_winner_v_error
);

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_cfg_overlap_err
                      , ( dbg_cfg_overlap_err )
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_cfg_overlap_err: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_cos_bw_req_err
                      , ( dbg_cos_bw_req_err )
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_cos_bw_req_err: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_cos_count_uflow
                      , ( dbg_cos_count_uflow )
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_cos_count_uflow: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_cos_count_compare_vec_error
                      , dbg_cos_count_compare_vec_error
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_cos_count_compare_vec_error: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_cos_count_num_winners_vec_error
                      , dbg_cos_count_num_winners_vec_error
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_cos_count_num_winners_vec_error: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_cos_count_num_winners_cosnum_error
                      , dbg_cos_count_num_winners_cosnum_error
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_cos_count_num_winners_cosnum_error: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_cos_sel_error
                      , dbg_cos_sel_error
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_cos_sel_error: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_dbg_winner_v_error
                      , dbg_winner_v_error
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_dbg_winner_v_error: ")
                        , SDG_SVA_SOC_SIM
                      ) ;

endmodule // hqm_lsp_cq_cos_arb_assert
`endif  // INTEL_SVA_OFF
