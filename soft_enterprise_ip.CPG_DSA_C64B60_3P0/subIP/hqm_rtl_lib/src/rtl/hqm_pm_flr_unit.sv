//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//-----------------------------------------------------------------------------------------------------
// hqm_pm_flr_unit
//
// This unit is a subBlock of the hqm_pm_unit within hqm_master.  It is responsible for FLR sequencing
// when based on trigger signals and power gating settings.  It also manages the hqm_flr_prep signal, 
// which is an early indication to force par-crossing signals to their passive values.
//
//-----------------------------------------------------------------------------------------------------

module hqm_pm_flr_unit
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
    input  logic                     hqm_freerun_clk 
  , input  logic                     hqm_cdc_clk
  , input  logic                     prim_gated_rst_b
  , input  logic                     pgcb_force_rst_b

  , input  logic                     prim_freerun_clk 
  , input  logic                     prim_freerun_prim_gated_rst_b_sync  //Synchronizer exists @ PM Unit level

  , input  logic                     fscan_rstbypen
  , input  logic                     fscan_byprst_b

  , output logic                     hqm_rst_b
  
  , output logic                     flr_clkreq_b 

  , input  logic                     flr_triggered   
  , input  logic                     pmsm_shields_up   

  , output logic                     hqm_shields_up
  , output logic                     hqm_flr_prep
  , output logic                     hqm_flr_clk_en
  , output logic                     hqm_pwrgood_rst_b
  , output logic                     hqm_gated_local_override

  , output flrsm_t                   flrsm_state
  , output logic [63:0]              cfg_flr_count

  , input  logic                     hqm_pm_unit_flr_req_edge 
  , input  pmsm_t                    pmsm_state_nxt
  , input  pmsm_t                    pmsm_state_f
  , input  cfg_pm_pmcsr_disable_t    cfg_pm_pmcsr_disable
);

//-----------------------------------------------------------------------------------------------------
logic                                hqm_cdc_prim_gated_rst_b_sync ;
logic                                hqm_cdc_pgcb_force_rst_b_sync ;

flrsm_t                              flrsm_state_f, flrsm_state_nxt ;
logic [15:0]                         flrsm_clk_cnt_f, flrsm_clk_cnt_nxt ;
logic                                flrsm_clk_cnt_eq_max ;

logic                                flr_triggered_f, flr_triggered_nxt ;
logic                                flr_pmfsm_req_f, flr_pmfsm_req_nxt ;
logic                                flr_triggers_active ;

logic                                start_flr ;

logic                                flrsm_idle ;
logic                                flrsm_idle_sync ;
logic                                flrsm_idle_sync_f ;
logic                                flr_req_ack_sync ;
logic                                flr_req_ack_f, flr_req_ack_nxt ;

logic                                iosf_start_flr, pmfsm_start_flr;

logic                                pwrgood_rst_done ;
logic                                pwrgood_rst_en_f, pwrgood_rst_en_nxt ;

logic                                pmsm_shields_up_f ;
logic                                pmsm_shields_up_sync_hqm ; 

logic                                cfg_flr_count_inc ;
logic [63:0]                         cfg_flr_count_f, cfg_flr_count_nxt ;

logic                                hqm_gated_local_override_f, hqm_gated_local_override_nxt ;
logic                                hqm_pwrgood_rst_b_f, hqm_pwrgood_rst_b_nxt ;
logic                                hqm_flr_prep_f, hqm_flr_prep_nxt ;
logic                                hqm_flr_prep_sync_prim ;
logic                                hqm_flr_clk_en_f, hqm_flr_clk_en_nxt ;
logic                                hqm_flr_rst_b_f, hqm_flr_rst_b_nxt ;
logic                                flr_triggered_edge_detect ;
logic                                flr_pmfsm_triggered_edge_detect ;

logic                                flr_clkreq_b_f, flr_clkreq_b_nxt ;
logic                                flr_clkreq_f, flr_clkreq_nxt ;
logic [1:0]                          flr_req_f, flr_req_nxt ;
logic [1:0]                          flr_req_sync ;
logic [1:0]                          flr_req_sync_f ;
logic                                flr_req_sync_fe ;
localparam IOSF_START_FLR  = 0;
localparam PMFSM_START_FLR = 1;
//-----------------------------------------------------------------------------------------------------
hqm_AW_reset_sync_scan i_hqm_cdc_prim_gated_rst_b_sync (

         .clk               (hqm_cdc_clk)
        ,.rst_n             (prim_gated_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (hqm_cdc_prim_gated_rst_b_sync)
);

hqm_AW_reset_sync_scan i_hqm_cdc_pgcb_force_rst_b_sync (

         .clk               (hqm_cdc_clk)
        ,.rst_n             (pgcb_force_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (hqm_cdc_pgcb_force_rst_b_sync)
);

//-----------------------------------------------------------------------------------------------------
// flr_triggered source in IOSF is the FLR start bit
// hqm_pm_unit_flr_req_edge is pmsm transition for HQM_PMSM_PWR_ON to HQM_PMSM_RUN
//
// Triggered sources are on a version of prim clk balanced with prim_freerun_clk
// if power gating is disabled, allow the pmfsm d3tod0 transition start an FLR
//
assign flr_pmfsm_req_nxt = hqm_pm_unit_flr_req_edge & ~cfg_pm_pmcsr_disable.DISABLE;

assign flr_triggered_nxt = flr_triggered & (pmsm_state_nxt==HQM_PMSM_RUN) & ~cfg_pm_pmcsr_disable.DISABLE; 

assign flr_triggered_edge_detect       = ( flr_triggered_f & ~flr_triggered_nxt ) ;
assign flr_pmfsm_triggered_edge_detect = flr_pmfsm_req_f & (pmsm_state_f==HQM_PMSM_RUN) & ~cfg_pm_pmcsr_disable.DISABLE;

assign flr_triggers_active             = ( (flr_triggered_nxt | flr_pmfsm_req_nxt | flr_triggered_f | flr_pmfsm_req_f)
                                         )  & ~cfg_pm_pmcsr_disable.DISABLE;

//-----------------------------------------------------------------------------------------------------
// Synchronize  Requests to hqm_freerun_clk 
// Turn on hqm_freerun_clk to process the FLR Req
assign flr_clkreq_nxt  = ( (|flr_req_nxt) | flr_req_ack_sync | ~flrsm_idle_sync ) ;

// pmfsm has priority if both were to occur on same clk cycle
assign iosf_start_flr  = ( ~cfg_pm_pmcsr_disable.DISABLE & flr_triggered_edge_detect & ~flr_pmfsm_triggered_edge_detect );
assign pmfsm_start_flr = ( ~cfg_pm_pmcsr_disable.DISABLE & flr_pmfsm_triggered_edge_detect );   

// Source side holds FLR requests, and clears once FLR SM ~idle is seen
assign flr_req_nxt[IOSF_START_FLR]  = ( (iosf_start_flr  | (flr_req_f[IOSF_START_FLR] ) ) & ~flr_req_ack_sync) ;
assign flr_req_nxt[PMFSM_START_FLR] = ( (pmfsm_start_flr | (flr_req_f[PMFSM_START_FLR]) ) & ~flr_req_ack_sync) ;

// Synchronize the flr request to the destination clock
hqm_AW_sync_rst0 #(
   .WIDTH          ( 2 )
) i_flr_req_sync ( 
   .clk            ( hqm_cdc_clk ),
   .rst_n          ( hqm_cdc_pgcb_force_rst_b_sync ),
   .data           ( flr_req_f ), 
   .data_sync      ( flr_req_sync )
);

// The FLR Req bit determines if hqm_pwrgood_rst_b is generated
assign start_flr          =  |flr_req_sync ;
assign pwrgood_rst_en_nxt = ( flr_req_sync[PMFSM_START_FLR] | pwrgood_rst_en_f ) & ~pwrgood_rst_done;

//-----------------------------------------------------------------------------------------------------
// Synchronize the S.M. Idle to the source clk domain
assign flrsm_idle  = flrsm_state_f[0] ;

hqm_AW_sync_rst1 #(
   .WIDTH          ( 1 )
) i_flrsm_idle_sync (
   .clk            ( prim_freerun_clk ),
   .rst_n          ( prim_freerun_prim_gated_rst_b_sync ),
   .data           ( flrsm_idle ),
   .data_sync      ( flrsm_idle_sync )
);

//-----------------------------------------------------------------------------------------------------
// Create the FLR Req's Ack pulse to clear the FLR Req
// Hold until the Req is dropped in the source domain
assign flr_req_sync_fe    = |(flr_req_sync_f &~flr_req_sync);
assign flr_req_ack_nxt    = (((flrsm_state_f == HQM_FLRSM_INACTIVE) & (flrsm_state_nxt == HQM_FLRSM_PREP_ON)) | flr_req_ack_f) & ~(|flr_req_sync_fe) ;

// Synchronize the FLR Req Ack to the source clk domain
hqm_AW_sync_rst0 #(
   .WIDTH          ( 1 )
) i_flr_req_ack_sync (
   .clk            ( prim_freerun_clk ),
   .rst_n          ( prim_freerun_prim_gated_rst_b_sync ),
   .data           ( flr_req_ack_f ),
   .data_sync      ( flr_req_ack_sync )
);

//-----------------------------------------------------------------------------------------------------
// Create the local clk gating override during FLR postamble
assign hqm_gated_local_override_nxt = ( (flrsm_state_f==HQM_FLRSM_CLK_EN_ON) | (flrsm_state_f==HQM_FLRSM_PREP_OFF) ) ;

//-----------------------------------------------------------------------------------------------------
// Increment count for status reg at end of FLR sequence
assign cfg_flr_count_inc  = (~flrsm_idle_sync_f & flrsm_idle_sync) ;
assign cfg_flr_count_nxt  = (cfg_flr_count_inc) ? (cfg_flr_count_f + 64'd1) : cfg_flr_count_f ; 

//-----------------------------------------------------------------------------------------------------
// Flops
always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin : flrsm_state_seq
  if(~prim_freerun_prim_gated_rst_b_sync) begin
    flr_triggered_f             <= '0 ;
    flr_pmfsm_req_f             <= '0 ;

    pmsm_shields_up_f           <= 1'b1 ;
    cfg_flr_count_f             <= '0 ;

    flr_req_f                   <= '0 ;
    flr_clkreq_f                <= '0 ;
    flr_clkreq_b_f              <= '1 ;
    flrsm_idle_sync_f           <= '1 ;
  end else begin
    flr_triggered_f             <= flr_triggered_nxt ;
    flr_pmfsm_req_f             <= flr_pmfsm_req_nxt;

    pmsm_shields_up_f           <= pmsm_shields_up ; 
    cfg_flr_count_f             <= cfg_flr_count_nxt ;

    flr_req_f                   <= flr_req_nxt ;
    flr_clkreq_f                <= flr_clkreq_nxt ;
    flr_clkreq_b_f              <= flr_clkreq_b_nxt ;
    flrsm_idle_sync_f           <= flrsm_idle_sync ;
  end
end // always_ff

// hqm_freeurn_clk is a throttled hqm_clk, for synchronizing into the hqm_proc
// hqm_cdc_clk is a non-throttled hqm_clk, used in pm_flr for sync'ing resets/reqs as early as possible
always_ff @(posedge hqm_freerun_clk or negedge hqm_cdc_pgcb_force_rst_b_sync) begin : flrsm_state_seq_hqm
  if(~hqm_cdc_pgcb_force_rst_b_sync) begin
    flrsm_state_f               <= HQM_FLRSM_INACTIVE ;
    flrsm_clk_cnt_f             <= '0 ;

    flr_req_sync_f              <= '0;
    flr_req_ack_f               <= '0;
    pwrgood_rst_en_f            <= '0;

    hqm_flr_prep_f              <= 1'b1 ;
    hqm_flr_clk_en_f            <= 1'b1 ;
    hqm_flr_rst_b_f             <= 1'b1 ;
    hqm_pwrgood_rst_b_f         <= 1'b1 ;
    hqm_gated_local_override_f  <= 1'b0 ;
  end else begin
    flrsm_state_f               <= flrsm_state_nxt ;
    flrsm_clk_cnt_f             <= flrsm_clk_cnt_nxt ;

    flr_req_sync_f              <= flr_req_sync ;
    flr_req_ack_f               <= flr_req_ack_nxt ;
    pwrgood_rst_en_f            <= pwrgood_rst_en_nxt;

    hqm_flr_prep_f              <= hqm_flr_prep_nxt ;
    hqm_flr_clk_en_f            <= hqm_flr_clk_en_nxt ; 
    hqm_flr_rst_b_f             <= hqm_flr_rst_b_nxt ;  
    hqm_pwrgood_rst_b_f         <= hqm_pwrgood_rst_b_nxt ;
    hqm_gated_local_override_f  <= hqm_gated_local_override_nxt ;
  end
end // always_ff
 
//-----------------------------------------------------------------------------------------------------
// FLR Sequencer SM
always_comb begin 

  if ( flrsm_clk_cnt_f == HQM_FLRSM_MAXCNT[15:0] ) begin
    flrsm_clk_cnt_eq_max        = 1'b1 ;
  end else begin
    flrsm_clk_cnt_eq_max        = 1'b0 ;
  end

  // Defaults
  hqm_flr_prep_nxt              = 1'b0 ;
  hqm_flr_clk_en_nxt            = 1'b1 ;
  hqm_flr_rst_b_nxt             = 1'b1 ;
  hqm_pwrgood_rst_b_nxt         = 1'b1 ;
  pwrgood_rst_done              = 1'b0 ; 
  
  flrsm_clk_cnt_nxt             = flrsm_clk_cnt_f;
  flrsm_state_nxt               = flrsm_state_f;

  case(flrsm_state_f) // : Case statement with an enum variable in a condition is not detected as full despite the fact that all enumerate values are checked, since the enum variable may have a value outside of the list of valid enumerate values
      HQM_FLRSM_INACTIVE:
      begin
        
        hqm_flr_prep_nxt        = 1'b0 ;
        hqm_flr_clk_en_nxt      = 1'b1 ;
        hqm_flr_rst_b_nxt       = 1'b1 ;
        hqm_pwrgood_rst_b_nxt   = 1'b1 ;

        if ( start_flr ) begin
          flrsm_state_nxt       = HQM_FLRSM_PREP_ON ;
        end 
      end // HQM_FLRSM_INACTIVE

      HQM_FLRSM_PREP_ON:
      begin

        hqm_flr_prep_nxt        = 1'b1 ;
        hqm_flr_clk_en_nxt      = 1'b1 ; 
        hqm_flr_rst_b_nxt       = 1'b1 ;
        hqm_pwrgood_rst_b_nxt   = 1'b1 ;
        
        flrsm_clk_cnt_nxt     = ( flrsm_clk_cnt_f + 16'd1 );

        if ( flrsm_clk_cnt_eq_max ) begin
          flrsm_state_nxt     = HQM_FLRSM_CLK_EN_OFF ;
          flrsm_clk_cnt_nxt   = '0 ;
        end
      end // HQM_FLRSM_PREP_ON

      HQM_FLRSM_CLK_EN_OFF:
      begin

        hqm_flr_prep_nxt        = 1'b1 ;
        hqm_flr_clk_en_nxt      = 1'b0 ;
        hqm_flr_rst_b_nxt       = 1'b1 ;
        hqm_pwrgood_rst_b_nxt   = 1'b1 ;

        flrsm_clk_cnt_nxt       = ( flrsm_clk_cnt_f + 16'd1 );

        if ( flrsm_clk_cnt_eq_max ) begin
  
          if ( pwrgood_rst_en_f) begin
            flrsm_state_nxt     = HQM_FLRSM_PWRGOOD_RST_ACTIVE ;
            pwrgood_rst_done    = 1'b1 ;
          end else begin
            flrsm_state_nxt     = HQM_FLRSM_ACTIVE ;
          end  

          flrsm_clk_cnt_nxt     = '0 ;
        end

      end // HQM_FLRSM_CLK_EN_OFF

      // Conditional State
      HQM_FLRSM_PWRGOOD_RST_ACTIVE:
      begin

        hqm_flr_prep_nxt        = 1'b1 ;
        hqm_flr_clk_en_nxt      = 1'b0 ;
        hqm_flr_rst_b_nxt       = 1'b0 ;
        hqm_pwrgood_rst_b_nxt   = 1'b0 ;

        flrsm_clk_cnt_nxt       = ( flrsm_clk_cnt_f + 16'd1 );

        if ( flrsm_clk_cnt_eq_max ) begin
          flrsm_state_nxt       = HQM_FLRSM_ACTIVE ;
          flrsm_clk_cnt_nxt     = '0 ;
        end

      end // HQM_FLRSM_ACTIVE

      HQM_FLRSM_ACTIVE:
      begin

        hqm_flr_prep_nxt        = 1'b1 ;
        hqm_flr_clk_en_nxt      = 1'b0 ;
        hqm_flr_rst_b_nxt       = 1'b0 ;
        hqm_pwrgood_rst_b_nxt   = 1'b1 ;

        flrsm_clk_cnt_nxt       = ( flrsm_clk_cnt_f + 16'd1 );

        if ( flrsm_clk_cnt_eq_max ) begin
          flrsm_state_nxt       = HQM_FLRSM_CLK_EN_ON ;
          flrsm_clk_cnt_nxt     = '0 ;
        end

      end // HQM_FLRSM_ACTIVE

      HQM_FLRSM_CLK_EN_ON:
      begin

        hqm_flr_prep_nxt        = 1'b1 ;
        hqm_flr_clk_en_nxt      = 1'b1 ;
        hqm_flr_rst_b_nxt       = 1'b0 ;
        hqm_pwrgood_rst_b_nxt   = 1'b1 ;

        flrsm_clk_cnt_nxt       = ( flrsm_clk_cnt_f + 16'd1 );

        if ( flrsm_clk_cnt_eq_max ) begin
          flrsm_state_nxt       = HQM_FLRSM_PREP_OFF ;
          flrsm_clk_cnt_nxt     = '0 ;
        end
     
      end // HQM_FLRSM_CLK_EN_ON

      HQM_FLRSM_PREP_OFF:
      begin

        hqm_flr_prep_nxt        = 1'b0 ;
        hqm_flr_clk_en_nxt      = 1'b1 ;
        hqm_flr_rst_b_nxt       = 1'b0 ; 
        hqm_pwrgood_rst_b_nxt   = 1'b1 ;

        flrsm_clk_cnt_nxt       = ( flrsm_clk_cnt_f + 16'd1 );

        if ( flrsm_clk_cnt_eq_max ) begin
          flrsm_state_nxt       = HQM_FLRSM_INACTIVE ;
          flrsm_clk_cnt_nxt     = '0 ;
        end
        
      end // HQM_FLRSM_PREP_OFF

      default:
      begin
          flrsm_state_nxt       = HQM_FLRSM_INACTIVE ;
      end // default 

  endcase

end // always_comb

//-------------------------------------------------------------------------------------------------------------
// Synchronizers for output signals
//
hqm_AW_sync_rst1 #(
   .WIDTH          ( 1 )
) i_pmsm_shields_up_sync_hqm (
   .clk            ( hqm_cdc_clk ),
   .rst_n          ( hqm_cdc_pgcb_force_rst_b_sync ),
   .data           ( pmsm_shields_up_f ),
   .data_sync      ( pmsm_shields_up_sync_hqm )
);


hqm_AW_sync_rst0 #(
   .WIDTH          ( 1 )
) i_hqm_flr_prep_sync_prim (
   .clk            ( prim_freerun_clk ),
   .rst_n          ( prim_freerun_prim_gated_rst_b_sync ),
   .data           ( hqm_flr_prep_f ),
   .data_sync      ( hqm_flr_prep_sync_prim )
);

//-------------------------------------------------------------------------------------------------------------
// Drive Outputs 
// hqm_rst_b is the reset_b input of hqm_clk's CDC
logic hqm_rst_b_pre ;
assign hqm_rst_b_pre                = ( hqm_cdc_prim_gated_rst_b_sync & hqm_flr_rst_b_f ) ;
hqm_AW_reset_mux i_hqm_rst_b (
  .rst_in_n          ( hqm_rst_b_pre )
, .fscan_rstbypen    ( fscan_rstbypen )
, .fscan_byprst_b    ( fscan_byprst_b )
, .rst_out_n         ( hqm_rst_b )
);

logic hqm_pwrgood_rst_b_pre ;
assign hqm_pwrgood_rst_b_pre        = ( hqm_pwrgood_rst_b_f & pgcb_force_rst_b) ;
hqm_AW_reset_mux i_hqm_pwrgood_rst_b (
  .rst_in_n          ( hqm_pwrgood_rst_b_pre )
, .fscan_rstbypen    ( fscan_rstbypen )
, .fscan_byprst_b    ( fscan_byprst_b )
, .rst_out_n         ( hqm_pwrgood_rst_b )
);

assign hqm_flr_prep             = ( pmsm_shields_up_sync_hqm | hqm_flr_prep_f ) ;   // To PROC PAR repeaters
assign hqm_shields_up           = ( pmsm_shields_up_f | hqm_flr_prep_sync_prim ) ;  // To PAR IOSF only

assign hqm_gated_local_override = hqm_gated_local_override_f ;

assign hqm_flr_clk_en           = hqm_flr_clk_en_f ;

assign cfg_flr_count            = cfg_flr_count_f ; 
assign flrsm_state              = flrsm_state_f ;

assign flr_clkreq_b_nxt         = ( ~flr_clkreq_f & ~flr_triggers_active ) ;
assign flr_clkreq_b             = flr_clkreq_b_f ;
//-------------------------------------------------------------------------------------------------------------

endmodule //hqm_pm_flr_unit

