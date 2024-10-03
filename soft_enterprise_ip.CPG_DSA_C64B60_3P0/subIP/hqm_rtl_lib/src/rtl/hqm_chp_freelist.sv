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
//
//
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_chp_freelist
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
#(
  parameter NUM_FIDS       = NUM_CREDITS
, parameter NUM_BANKS      = NUM_CREDITS_BANKS 
, parameter BDEPTH         = NUM_CREDITS_PBANK
//...............................................................................................................................................
, parameter BANKS_WIDTH                           = ( AW_logb2 ( NUM_CREDITS_BANKS - 1 ) + 1 )
, parameter FIDS_WIDTH                            = ( AW_logb2 ( NUM_FIDS - 1) + 1 )
, parameter BDWIDTH                               = (FIDS_WIDTH - BANKS_WIDTH)                              // BANK FID WIDTH
, parameter ECCWIDTH                              = ((BDWIDTH>11) ? ((BDWIDTH>26) ? 7 : 6) : 5)
, parameter LDWIDTH                               = ( BDWIDTH + ECCWIDTH )
, parameter BDEPTHB2                               = ( AW_logb2 ( BDEPTH - 1 ) + 1 )
, parameter BDEPTHB2P1                             = ( ( ( 2 ** BDEPTHB2) == BDEPTH ) ? ( BDEPTHB2 + 1 ) : BDEPTHB2)
) (
  input  logic                                   clk 
, input  logic                                   rst_n 
                                                          
, input  logic                                   freelist_pf_push_v
, input  chp_flid_t                              freelist_pf_push_data
, input  logic                                   freelist_push_v
, input  chp_flid_t                              freelist_push_data

, input  logic                                   freelist_pop_v
, output chp_flid_t                              freelist_pop_data
                                                 
, output logic [ ( 15 ) - 1 : 0 ]                freelist_size
, output logic                                   freelist_empty
, output logic                                   freelist_full
, output logic                                   freelist_of
, output logic                                   freelist_uf
, output logic                                   freelist_eccerr_mb
, output logic                                   freelist_eccerr_sb
, output logic                                   freelist_pop_error // got pop but all banks are empty

, output logic                                   freelist_push_parity_chk_error

, output logic                                   freelist_status_idle 

, output logic                                   func_freelist_0_we
, output logic                                   func_freelist_0_re
, output logic [BDEPTHB2-1:0]                     func_freelist_0_addr
, output logic [LDWIDTH-1:0]                     func_freelist_0_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_0_rdata

, output logic                                   func_freelist_1_we
, output logic                                   func_freelist_1_re
, output logic [BDEPTHB2-1:0]                     func_freelist_1_addr
, output logic [LDWIDTH-1:0]                     func_freelist_1_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_1_rdata

, output logic                                   func_freelist_2_we
, output logic                                   func_freelist_2_re
, output logic [BDEPTHB2-1:0]                     func_freelist_2_addr
, output logic [LDWIDTH-1:0]                     func_freelist_2_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_2_rdata

, output logic                                   func_freelist_3_we
, output logic                                   func_freelist_3_re
, output logic [BDEPTHB2-1:0]                     func_freelist_3_addr
, output logic [LDWIDTH-1:0]                     func_freelist_3_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_3_rdata

, output logic                                   func_freelist_4_we
, output logic                                   func_freelist_4_re
, output logic [BDEPTHB2-1:0]                     func_freelist_4_addr
, output logic [LDWIDTH-1:0]                     func_freelist_4_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_4_rdata

, output logic                                   func_freelist_5_we
, output logic                                   func_freelist_5_re
, output logic [BDEPTHB2-1:0]                     func_freelist_5_addr
, output logic [LDWIDTH-1:0]                     func_freelist_5_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_5_rdata

, output logic                                   func_freelist_6_we
, output logic                                   func_freelist_6_re
, output logic [BDEPTHB2-1:0]                     func_freelist_6_addr
, output logic [LDWIDTH-1:0]                     func_freelist_6_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_6_rdata

, output logic                                   func_freelist_7_we
, output logic                                   func_freelist_7_re
, output logic [BDEPTHB2-1:0]                     func_freelist_7_addr
, output logic [LDWIDTH-1:0]                     func_freelist_7_wdata
, input  logic [LDWIDTH-1:0]                     func_freelist_7_rdata

) ;

logic                              lifo_select_winner_v;
logic [BANKS_WIDTH-1:0]            lifo_select_winner;
logic [NUM_BANKS-1:0]              lifo_error_uf;
logic [NUM_BANKS-1:0]              lifo_error_of;
logic [NUM_BANKS-1:0]              lifo_status_idle;
logic [(NUM_BANKS*BDEPTHB2P1)-1:0] lifo_size;

logic [ECCWIDTH-1:0]               freelist_push_data_flid_ecc;
                                   
logic                              chp_flid_pipe_0_v_nxt; 
logic                              chp_flid_pipe_0_v_f; 
logic [BANKS_WIDTH-1:0]            chp_flid_pipe_0_bank_f; 
logic [BANKS_WIDTH-1:0]            chp_flid_pipe_0_bank_nxt; 

logic                              chp_flid_pipe_1_v_nxt; 
logic                              chp_flid_pipe_1_v_f; 
logic [BANKS_WIDTH-1:0]            chp_flid_pipe_1_bank_nxt; 
logic [BANKS_WIDTH-1:0]            chp_flid_pipe_1_bank_f; 

logic                              chp_flid_pipe_2_v_nxt; 
logic                              chp_flid_pipe_2_v_f; 
logic [BANKS_WIDTH-1:0]            chp_flid_pipe_2_bank_nxt; 
logic [BANKS_WIDTH-1:0]            chp_flid_pipe_2_bank_f; 
                                   
logic [BDWIDTH-1:0]                freelist_pop_data_flid;
logic [BDWIDTH-1:0]                freelist_pop_data_flid_ecc_check;
logic [ECCWIDTH-1:0]               freelist_pop_data_ecc;

logic [NUM_BANKS-1:0]              lifo_push ;
logic [NUM_BANKS-1:0]              lifo_push_bindec ;
logic [NUM_BANKS-1:0]              lifo_push_bindec_parity_mask ;
logic [(NUM_BANKS*LDWIDTH)-1:0]    lifo_push_data;
logic [NUM_BANKS-1:0]              lifo_pop ;
logic [NUM_BANKS-1:0]              lifo_pop_bindec ;
logic [(NUM_BANKS*LDWIDTH)-1:0]    lifo_pop_data;
logic [NUM_BANKS-1:0]              lifo_full;
logic [NUM_BANKS-1:0]              lifo_afull_nc;
logic [NUM_BANKS-1:0]              lifo_empty;

logic [NUM_BANKS-1:0]              mem_re;
logic [NUM_BANKS-1:0]              mem_we;
logic [(NUM_BANKS*BDEPTHB2)-1:0]   mem_addr;
logic [(NUM_BANKS*LDWIDTH)-1:0]    mem_wdata;
logic [(NUM_BANKS*LDWIDTH)-1:0]    mem_rdata;
logic [FIDS_WIDTH-1:0]             freelist_push_data_flid;
logic                              freelist_push_data_flid_parity;

assign freelist_push_data_flid        = freelist_pf_push_v ? freelist_pf_push_data.flid        : freelist_push_data.flid;
assign freelist_push_data_flid_parity = freelist_pf_push_v ? freelist_pf_push_data.flid_parity : freelist_push_data.flid_parity;

// check parity, report it but keep moving forward
hqm_AW_parity_check # (
    .WIDTH                              ( FIDS_WIDTH )
) i_freelist_push_parity_check ( 
     .p                                 ( freelist_push_data_flid_parity )
   , .d                                 ( freelist_push_data_flid )
   , .e                                 ( (freelist_push_v || freelist_pf_push_v) )
   , .odd                               ( 1'b1 ) // odd
   , .err                               ( freelist_push_parity_chk_error )
) ;

// generate ecc
hqm_AW_ecc_gen # (
   .DATA_WIDTH                          ( BDWIDTH )
 , .ECC_WIDTH                           ( ECCWIDTH )
) i_ecc_gen_l (
   .d                                   ( freelist_push_data_flid [BDWIDTH-1:0] )
 , .ecc                                 ( freelist_push_data_flid_ecc )
) ;

always_ff @(posedge clk or negedge rst_n ) begin
  if (~rst_n) begin

    chp_flid_pipe_0_v_f <= 1'b0; 
    chp_flid_pipe_0_bank_f <= '0;

    chp_flid_pipe_1_v_f <= 1'b0;
    chp_flid_pipe_1_bank_f <= '0;

    chp_flid_pipe_2_v_f <= 1'b0;
    chp_flid_pipe_2_bank_f <= '0;

  end else begin

    chp_flid_pipe_0_v_f <= chp_flid_pipe_0_v_nxt; 
    chp_flid_pipe_0_bank_f <=  chp_flid_pipe_0_bank_nxt;

    chp_flid_pipe_1_v_f <= chp_flid_pipe_1_v_nxt;
    chp_flid_pipe_1_bank_f <= chp_flid_pipe_1_bank_nxt;


    chp_flid_pipe_2_v_f <= chp_flid_pipe_2_v_nxt;
    chp_flid_pipe_2_bank_f <= chp_flid_pipe_2_bank_nxt;

  end
end

// Not Used hqm_AW_rr_arbiter #(
// Not Used   .NUM_REQS ( NUM_BANKS )
// Not Used ) hqm_chp_lifo_rrarb (

// Not Used          .clk        ( clk )
// Not Used         ,.rst_n      ( rst_n )

// Not Used         ,.mode       ( 2'b10 ) // I 0:strict_priority, 1:rotating_priority, 2:round_robin
// Not Used         ,.update     ( lifo_rrarb_update )     // I Update index

// Not Used         ,.reqs       ( lifo_rrarb_reqs )       // I Vector of requests

// Not Used         ,.winner_v   ( lifo_rrarb_winner_v )    // O
// Not Used         ,.winner     ( lifo_rrarb_winner )     // O Winner of the arbitration
// Not Used );


logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_7_size_scaled ;
logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_6_size_scaled ;
logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_5_size_scaled ;
logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_4_size_scaled ;
logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_3_size_scaled ;
logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_2_size_scaled ;
logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_1_size_scaled ;
logic [ ( $bits ( freelist_size ) - 1 ) : 0 ] lifo_0_size_scaled ;

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_7_size_scaled (
  .a     ( lifo_size[7*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_7_size_scaled )
);

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_6_size_scaled (
  .a     ( lifo_size[6*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_6_size_scaled )
);

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_5_size_scaled (
  .a     ( lifo_size[5*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_5_size_scaled )
);

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_4_size_scaled (
  .a     ( lifo_size[4*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_4_size_scaled )
);

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_3_size_scaled (
  .a     ( lifo_size[3*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_3_size_scaled )
);

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_2_size_scaled (
  .a     ( lifo_size[2*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_2_size_scaled )
);

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_1_size_scaled (
  .a     ( lifo_size[1*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_1_size_scaled )
);

hqm_AW_width_scale 
#(
  .A_WIDTH ( BDEPTHB2P1 )
, .Z_WIDTH ( $bits ( freelist_size ) ) 
) i_lifo_0_size_scaled (
  .a     ( lifo_size[0*BDEPTHB2P1 +: BDEPTHB2P1] )
, .z     ( lifo_0_size_scaled )
);

assign freelist_size = lifo_7_size_scaled 
                     + lifo_6_size_scaled
                     + lifo_5_size_scaled
                     + lifo_4_size_scaled
                     + lifo_3_size_scaled
                     + lifo_2_size_scaled
                     + lifo_1_size_scaled
                     + lifo_0_size_scaled
                     ;

hqm_credit_hist_pipe_freelist_select
#(
  .NUM_REQS ( NUM_BANKS )
 ,.CNT_WIDTH  ( BDEPTHB2P1 )
) hqm_chp_lifo_select (
  .clk       ( clk )
, .rst_n     ( rst_n )
, .reqs      ( {
                 lifo_size[7*BDEPTHB2P1 +: BDEPTHB2P1]
                 ,lifo_size[6*BDEPTHB2P1 +: BDEPTHB2P1]
                 ,lifo_size[5*BDEPTHB2P1 +: BDEPTHB2P1]
                 ,lifo_size[4*BDEPTHB2P1 +: BDEPTHB2P1]
                 ,lifo_size[3*BDEPTHB2P1 +: BDEPTHB2P1]
                 ,lifo_size[2*BDEPTHB2P1 +: BDEPTHB2P1]
                 ,lifo_size[1*BDEPTHB2P1 +: BDEPTHB2P1]
                 ,lifo_size[0*BDEPTHB2P1 +: BDEPTHB2P1]
              } )
, .winner_v  ( lifo_select_winner_v )
, .winner    ( lifo_select_winner )
) ;


hqm_AW_bindec #(
   .WIDTH( BANKS_WIDTH )
  ,.DWIDTH ( NUM_BANKS )
) i_lifo_pop_bindec (
   .a      ( lifo_select_winner )
  ,.enable ( lifo_select_winner_v )
  ,.dec    ( lifo_pop_bindec )
);

hqm_AW_bindec #(
   .WIDTH( BANKS_WIDTH )
  ,.DWIDTH ( NUM_BANKS )
) i_lifo_push_bindec (
   .a      ( freelist_push_data.flid[BDWIDTH +: 3] )
  ,.enable ( freelist_push_v )
  ,.dec    ( lifo_push_bindec )
);

// don't do the push if parity error detected
assign lifo_push_bindec_parity_mask = lifo_push_bindec & {NUM_BANKS{~freelist_push_parity_chk_error}};

always_comb begin

    lifo_push = '0;
    lifo_pop = '0;
    lifo_push_data = {NUM_BANKS{freelist_push_data_flid_ecc,freelist_push_data.flid[BDWIDTH-1:0]}};

    chp_flid_pipe_0_v_nxt = 1'b0;
    chp_flid_pipe_0_bank_nxt = freelist_push_data.flid[BDWIDTH +: 3];
    chp_flid_pipe_1_v_nxt = chp_flid_pipe_0_v_f;
    chp_flid_pipe_1_bank_nxt = chp_flid_pipe_0_v_f ? chp_flid_pipe_0_bank_f : chp_flid_pipe_1_bank_f;
    chp_flid_pipe_2_v_nxt = chp_flid_pipe_1_v_f;
    chp_flid_pipe_2_bank_nxt = chp_flid_pipe_1_v_f ? chp_flid_pipe_1_bank_f : chp_flid_pipe_2_bank_f;

    freelist_pop_error = 1'b0;

    // freelist_pf_push_v and freelist_push_v are mutually exclusive
    if ( freelist_pf_push_v ) begin
          lifo_push = {NUM_BANKS{1'b1}} & {NUM_BANKS{~freelist_push_parity_chk_error}};
          lifo_push_data = {NUM_BANKS{freelist_push_data_flid_ecc,freelist_pf_push_data.flid[BDWIDTH-1:0]}};
    end

    // we can only get freelist_pop_v knowing that one of the lifo's has available entry, otherwise set freelist_pop_error 
    if ( freelist_pop_v ) begin

      if ( lifo_select_winner_v ) begin

        lifo_pop = lifo_pop_bindec ;
        chp_flid_pipe_0_v_nxt = 1'b1;
        chp_flid_pipe_0_bank_nxt = lifo_select_winner;
        
        if ( freelist_push_v ) begin

           lifo_push = lifo_push_bindec_parity_mask;

        end

      end else begin

           // there should never be freelist_pop_v and no flid available in any of the lifos
           freelist_pop_error = 1'b1;

      end

    end else if ( freelist_push_v ) begin 

        lifo_push = lifo_push_bindec_parity_mask;

    end

end

generate

    for ( genvar gi = 0; gi < NUM_BANKS; gi = gi + 1 ) begin : gi_NUM_BANKS 

                hqm_AW_lifo_control #( 
                  .DEPTH  ( BDEPTH )
                 ,.DWIDTH ( LDWIDTH )
                ) hqm_chp_freelist_lifo (
                 .clk             ( clk )                                      // I
                ,.rst_n           ( rst_n )                                    // I
                                                                                             
                ,.cfg_high_wm     ( '0 )                                       // I afull not used so this can be anything
                                                                                       
                ,.mem_re          ( mem_re[gi] )                               // O
                ,.mem_we          ( mem_we[gi] )                               // O
                ,.mem_addr        ( mem_addr[gi*BDEPTHB2 +: BDEPTHB2] )        // O
                ,.mem_wdata       ( mem_wdata[gi*LDWIDTH +: LDWIDTH] )         // O
                ,.mem_rdata       ( mem_rdata[gi*LDWIDTH +: LDWIDTH] )         // I
                                                                                           
                ,.lifo_push       ( lifo_push[gi] )                            // I
                ,.lifo_push_data  ( lifo_push_data[gi*LDWIDTH +: LDWIDTH] )    // I
                ,.lifo_pop        ( lifo_pop[gi] )                             // I
                ,.lifo_pop_data   ( lifo_pop_data[gi*LDWIDTH +: LDWIDTH] )     // O
                ,.lifo_full       ( lifo_full[gi] )                            // O
                ,.lifo_afull      ( lifo_afull_nc[gi] )                           // O
                ,.lifo_empty      ( lifo_empty[gi] )                           // O
                                                                                        
                ,.status_idle     ( lifo_status_idle[gi] )                     // O
                ,.status_size     ( lifo_size[(gi*BDEPTHB2P1) +: BDEPTHB2P1] ) // O
                ,.error_uf        ( lifo_error_uf[gi] )                        // O
                ,.error_of        ( lifo_error_of[gi] )                        // O
                ) ;

      end

endgenerate

assign freelist_status_idle = (|lifo_status_idle) & (~chp_flid_pipe_2_v_f) & (~chp_flid_pipe_1_v_f) & (~chp_flid_pipe_0_v_f);

// lifo status
assign freelist_empty = &lifo_empty;
assign freelist_full = &lifo_full;
assign freelist_uf = |lifo_error_uf;
assign freelist_of = |lifo_error_of;

always_comb begin

       freelist_pop_data_flid = lifo_pop_data[(chp_flid_pipe_2_bank_f * LDWIDTH) +: BDWIDTH ];
       freelist_pop_data_ecc = lifo_pop_data[((chp_flid_pipe_2_bank_f * LDWIDTH)+BDWIDTH) +: ECCWIDTH];

end

// flic ecc check for flid from freelist_pop_v request
hqm_AW_ecc_check #(
         .DATA_WIDTH                          ( BDWIDTH )
        ,.ECC_WIDTH                           ( ECCWIDTH  )
) i_lifo_pop_data_ecc_check (
         .din_v                               ( chp_flid_pipe_2_v_f )              // I
        ,.din                                 ( freelist_pop_data_flid )           // I
        ,.ecc                                 ( freelist_pop_data_ecc )            // I
        ,.enable                              ( 1'b1 )                             // I
        ,.correct                             ( 1'b1 )                             // I
        ,.dout                                ( freelist_pop_data_flid_ecc_check ) // O
        ,.error_sb                            ( freelist_eccerr_sb )               // O
        ,.error_mb                            ( freelist_eccerr_mb )               // O
) ;

assign freelist_pop_data.flid = {chp_flid_pipe_2_bank_f,freelist_pop_data_flid_ecc_check};

hqm_AW_parity_gen # (
    .WIDTH                              ( CREDITS_WIDTH )
) i_freelist_pop_parity_gen (
     .d                                 ( freelist_pop_data.flid )
   , .odd                               ( 1'b1 )
   , .p                                 ( freelist_pop_data.flid_parity)
) ;

assign func_freelist_0_we = mem_we[0];
assign func_freelist_0_re = mem_re[0];
assign func_freelist_0_addr = mem_addr[(0*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_0_wdata = mem_wdata[(0*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(0*LDWIDTH) +: LDWIDTH] = func_freelist_0_rdata;

assign func_freelist_1_we = mem_we[1];
assign func_freelist_1_re = mem_re[1];
assign func_freelist_1_addr = mem_addr[(1*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_1_wdata = mem_wdata[(1*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(1*LDWIDTH) +: LDWIDTH] = func_freelist_1_rdata;

assign func_freelist_2_we = mem_we[2];
assign func_freelist_2_re = mem_re[2];
assign func_freelist_2_addr = mem_addr[(2*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_2_wdata = mem_wdata[(2*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(2*LDWIDTH) +: LDWIDTH] = func_freelist_2_rdata;

assign func_freelist_3_we = mem_we[3];
assign func_freelist_3_re = mem_re[3];
assign func_freelist_3_addr = mem_addr[(3*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_3_wdata = mem_wdata[(3*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(3*LDWIDTH) +: LDWIDTH] = func_freelist_3_rdata;

assign func_freelist_4_we = mem_we[4];
assign func_freelist_4_re = mem_re[4];
assign func_freelist_4_addr = mem_addr[(4*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_4_wdata = mem_wdata[(4*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(4*LDWIDTH) +: LDWIDTH] = func_freelist_4_rdata;

assign func_freelist_5_we = mem_we[5];
assign func_freelist_5_re = mem_re[5];
assign func_freelist_5_addr = mem_addr[(5*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_5_wdata = mem_wdata[(5*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(5*LDWIDTH) +: LDWIDTH] = func_freelist_5_rdata;

assign func_freelist_6_we = mem_we[6];
assign func_freelist_6_re = mem_re[6];
assign func_freelist_6_addr = mem_addr[(6*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_6_wdata = mem_wdata[(6*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(6*LDWIDTH) +: LDWIDTH] = func_freelist_6_rdata;

assign func_freelist_7_we = mem_we[7];
assign func_freelist_7_re = mem_re[7];
assign func_freelist_7_addr = mem_addr[(7*BDEPTHB2) +: BDEPTHB2];
assign func_freelist_7_wdata = mem_wdata[(7*LDWIDTH) +: LDWIDTH];
assign mem_rdata[(7*LDWIDTH) +: LDWIDTH] = func_freelist_7_rdata;

endmodule // hqm_chp_freelist
