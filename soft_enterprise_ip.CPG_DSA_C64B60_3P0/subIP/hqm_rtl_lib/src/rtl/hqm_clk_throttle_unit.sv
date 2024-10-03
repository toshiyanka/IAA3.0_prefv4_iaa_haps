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
// hqm_clk_throttle_unit
//
// This module is responsible for throttling hqm_clk frequency between 1 and 1/8 that of prim_clk 
// based on the value of PROCHOT.
//
//-----------------------------------------------------------------------------------------------------

module hqm_clk_throttle_unit
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
      input  logic                                     hqm_cdc_clk
    , input  logic                                     hqm_fullrate_clk
    , input  logic                                     hqm_clk_enable_int
    , input  logic                                     gclock_enable_final

    , input  logic                                     pgcb_force_rst_b

    , input  logic                                     pm_ip_clk_halt_b_2_rpt_0_iosf 
    
    , input  logic                                     prim_clk_enable 
    , input  logic                                     cfg_prochot_disable
    , input  logic                                     prochot

    , input  logic                                     side_rst_b
    , input  logic                                     master_ctl_load
    , input  logic [31:0]                              master_ctl 

    , input  logic                                     fscan_rstbypen
    , input  logic                                     fscan_byprst_b 

    , input  logic                                     hqm_clk_ungate_presync 
    , output logic                                     hqm_clk_ungate

    , output logic                                     hqm_clk_rptr_rst_b
    , output logic                                     hqm_clk_enable
    , output logic                                     hqm_clk_throttle
    , output logic                                     hqm_gclock_enable

    , output logic                                     visa_str_prim_clk_enable_sync
    , output logic                                     visa_str_pm_ip_clk_halt_b_2_rpt_0_iosf_sync
);

// collage-pragma translate_off

//-----------------------------------------------------------------------------------------------------
logic       hqm_clk_throttle_en;
logic       hqm_clk_throttle_f;

logic       cfg_prochot_disable_sync_0_f, cfg_prochot_disable_sync_1_f ;
logic       cfg_prochot_disable_sync ;

logic       prochot_sync_0_f, prochot_sync_1_f ;
logic       prochot_sync ;
logic       prochot_deglitch_sync ;

logic       hqm_cdc_pgcb_force_rst_b_sync ;
logic       hqm_fullrate_side_rst_b_sync ;
logic       hqm_fullrate_pgcb_force_rst_b_sync ;

logic       prim_clk_enable_sync ;
logic       pm_ip_clk_halt_b_2_rpt_0_iosf_sync ;

logic [1:0] clk_switch_sel ;

logic [31:0] master_ctl_pnc ;
master_ctl_reg_t master_ctl_clk_switch;
master_ctl_clk_switch_t master_ctl_clk_switch_nxt, master_ctl_clk_switch_f ;

logic       master_ctl_load_sync_hqm;

logic       sel1p0 ;
logic       sel0p125 ;

logic       clk_div_0_f, clk_div_0_nxt ;
logic       clk_div_1_f, clk_div_1_nxt ;
logic       clk_div_2_f, clk_div_2_nxt ;
logic       clk_div_3_f, clk_div_3_nxt ;
logic       hqm_cdc_clk_div8_f, hqm_cdc_clk_div8_nxt ;

logic       hqm_clk_enable_f, hqm_clk_enable_nxt ;
logic       hqm_gclock_enable_f, hqm_gclock_enable_nxt ;

localparam SEL1P0 = 0 ;
localparam SEL0P125 = 1 ;

localparam HQM_CLK_OFF     = 2'b00;
localparam HQM_CLK_1P0     = 2'b01;
localparam HQM_CLK_0P125   = 2'b10;
localparam HQM_CLK_ILLEGAL = 2'b11;

// Catch NC's and reassign input bus to the struct 
assign master_ctl_pnc = master_ctl ;
assign master_ctl_clk_switch = master_ctl ;

//-----------------------------------------------------------------------------------------------------
// Reset Syncs
//
hqm_AW_reset_sync_scan i_hqm_cdc_pgcb_force_rst_b_sync (

   .clk              ( hqm_cdc_clk )
  ,.rst_n            ( pgcb_force_rst_b )
  ,.fscan_rstbypen   ( fscan_rstbypen )
  ,.fscan_byprst_b   ( fscan_byprst_b )
  ,.rst_n_sync       ( hqm_cdc_pgcb_force_rst_b_sync )
);

hqm_AW_reset_sync_scan i_hqm_fullrate_side_rst_b_sync (

   .clk              ( hqm_fullrate_clk )
  ,.rst_n            ( side_rst_b )
  ,.fscan_rstbypen   ( fscan_rstbypen )
  ,.fscan_byprst_b   ( fscan_byprst_b )
  ,.rst_n_sync       ( hqm_fullrate_side_rst_b_sync )
);

hqm_AW_reset_sync_scan i_hqm_fullrate_pgcb_force_rst_b_sync (

   .clk              ( hqm_fullrate_clk )
  ,.rst_n            ( pgcb_force_rst_b )
  ,.fscan_rstbypen   ( fscan_rstbypen )
  ,.fscan_byprst_b   ( fscan_byprst_b )
  ,.rst_n_sync       ( hqm_fullrate_pgcb_force_rst_b_sync )
);

//-----------------------------------------------------------------------------------------------------
// Sync hqm_clk_ungate to hqm_cdc_clk
// Flopped in PM Unit, where prim_freerun_clk is available
//
hqm_AW_sync_rst0  #(        
   .WIDTH                   ( 1 )
) i_hqm_clk_ungate_sync (
   
   .clk                     ( hqm_cdc_clk )
  ,.rst_n                   ( hqm_cdc_pgcb_force_rst_b_sync )
  ,.data                    ( hqm_clk_ungate_presync )
  ,.data_sync               ( hqm_clk_ungate )
);

// Sync pm_ip_clk_halt
hqm_AW_sync_rst1  #(
   .WIDTH            ( 1 )
) i_pm_ip_clk_halt_b_2_rpt_0_iosf_sync (

   .clk              ( hqm_fullrate_clk )
  ,.rst_n            ( hqm_fullrate_pgcb_force_rst_b_sync )
  ,.data             ( pm_ip_clk_halt_b_2_rpt_0_iosf)
  ,.data_sync        ( pm_ip_clk_halt_b_2_rpt_0_iosf_sync)
);

assign visa_str_pm_ip_clk_halt_b_2_rpt_0_iosf_sync = pm_ip_clk_halt_b_2_rpt_0_iosf_sync ;
//------------------------------------------------------------------------------------------------------------------
// prochot sync and debounce 
hqm_AW_sync_rst0  #(
   .WIDTH                   ( 1 )
) i_cfg_prochot_disable_sync (

   .clk                     ( hqm_cdc_clk )
  ,.rst_n                   ( hqm_cdc_pgcb_force_rst_b_sync )
  ,.data                    ( cfg_prochot_disable )
  ,.data_sync               ( cfg_prochot_disable_sync )
);

hqm_AW_sync_rst0  #(
   .WIDTH                   ( 1 )
) i_prochot_sync (

   .clk                     ( hqm_cdc_clk )
  ,.rst_n                   ( hqm_cdc_pgcb_force_rst_b_sync )
  ,.data                    ( prochot )
  ,.data_sync               ( prochot_sync )
);

always_ff @(posedge hqm_cdc_clk or negedge hqm_cdc_pgcb_force_rst_b_sync) begin
  if (~hqm_cdc_pgcb_force_rst_b_sync) begin
    cfg_prochot_disable_sync_0_f         <= '0;
    cfg_prochot_disable_sync_1_f         <= '0;
    prochot_sync_0_f         <= '0;
    prochot_sync_1_f         <= '0;
  end else begin
    cfg_prochot_disable_sync_0_f         <= cfg_prochot_disable_sync ;
    cfg_prochot_disable_sync_1_f         <= cfg_prochot_disable_sync_0_f ;
    prochot_sync_0_f         <= prochot_sync ;
    prochot_sync_1_f         <= prochot_sync_0_f ;
  end
end

assign prochot_deglitch_sync = ( prochot_sync_0_f & prochot_sync_1_f ) & 
                               ~( cfg_prochot_disable_sync_0_f & cfg_prochot_disable_sync_1_f ) ;

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
// Clock Switch PROCHOT Decode 
// prim_clk_enable muxsel for selecting hqm_clk enabled/disabled
//

hqm_AW_sync_rst0  #(
   .WIDTH            ( 1 )
) i_prim_clk_enable_sync (

   .clk              ( hqm_cdc_clk )
  ,.rst_n            ( hqm_cdc_pgcb_force_rst_b_sync )
  ,.data             ( prim_clk_enable )
  ,.data_sync        ( prim_clk_enable_sync )
);

assign visa_str_prim_clk_enable_sync = prim_clk_enable_sync ;

// Mux determines hqm_clk enabled/disabled 
always_comb begin

  // Muxsel default is 0 (OFF) 
  clk_switch_sel[SEL1P0]            = '0 ;
  clk_switch_sel[SEL0P125]          = '0 ;

  if ( prim_clk_enable_sync ) begin
    clk_switch_sel[SEL1P0]          = (~prochot_deglitch_sync) |  hqm_clk_ungate;
    clk_switch_sel[SEL0P125]        =   prochot_deglitch_sync  & ~hqm_clk_ungate ;
  end
end

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
// Sideband register Survivability profile
// Sync the master_ctl sideband register to hqm_cdc_clk
// Override [sel0p125,sel1p0] 
//

hqm_AW_sync_rst0  #(
   .WIDTH            ( 1 )
) i_master_ctl_load_sync_hqm (
   .clk              ( hqm_fullrate_clk )
  ,.rst_n            ( hqm_fullrate_side_rst_b_sync )
  ,.data             ( master_ctl_load )
  ,.data_sync        ( master_ctl_load_sync_hqm )
);

assign master_ctl_clk_switch_nxt = ( master_ctl_load_sync_hqm ) ? master_ctl_clk_switch.OVERRIDE_CLK_SWITCH_CONTROL : master_ctl_clk_switch_f ;

always_ff  @(posedge hqm_fullrate_clk or negedge hqm_fullrate_side_rst_b_sync) begin
  if (~hqm_fullrate_side_rst_b_sync) begin
    master_ctl_clk_switch_f <= '0 ;
  end else begin
    master_ctl_clk_switch_f <= master_ctl_clk_switch_nxt ;
  end
end

always_comb begin

  sel1p0     = clk_switch_sel[SEL1P0] ;
  sel0p125   = clk_switch_sel[SEL0P125] ;

  if ( master_ctl_clk_switch_f.OVERRIDE_CLK_SWITCH_CONTROL[0] ) begin
   sel1p0    = master_ctl_clk_switch_f.OVERRIDE_CLK_SWITCH_CONTROL[1];
   sel0p125  = ( (~master_ctl_clk_switch_f.OVERRIDE_CLK_SWITCH_CONTROL[1]) & master_ctl_clk_switch_f.OVERRIDE_CLK_SWITCH_CONTROL[2] );
  end

end

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
// 1/8 Clock Div by pulse knockout
//
assign clk_div_0_nxt = ~clk_div_3_f ;
assign clk_div_1_nxt =  clk_div_0_f ;
assign clk_div_2_nxt =  clk_div_1_f ;
assign clk_div_3_nxt =  clk_div_2_f ;

assign hqm_cdc_clk_div8_nxt = &{clk_div_0_f,clk_div_1_f,clk_div_2_f,clk_div_3_f} ;

always_ff  @(posedge hqm_cdc_clk or negedge hqm_cdc_pgcb_force_rst_b_sync) begin
  if (~hqm_cdc_pgcb_force_rst_b_sync) begin
    clk_div_0_f           <= 1'b0 ;
    clk_div_1_f           <= 1'b0 ;
    clk_div_2_f           <= 1'b0 ;
    clk_div_3_f           <= 1'b1 ;

    hqm_cdc_clk_div8_f <= 1'b1 ;
  end else begin
    clk_div_0_f           <= clk_div_0_nxt ;
    clk_div_1_f           <= clk_div_1_nxt ;
    clk_div_2_f           <= clk_div_2_nxt ;
    clk_div_3_f           <= clk_div_3_nxt ;

    hqm_cdc_clk_div8_f <= hqm_cdc_clk_div8_nxt ;
  end
end

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
// Prim Clk Enable determines ON/OFF
// When ON, PROCHOT determines 1p0/0p125
// For simplicity, do not gate hqm_cdc_clk with hqm_prim_clk_enable. 
// The power savings of this gating would be very small and not affect the critical D3 or D0UNINIT
// power case case where the hqm_clk network is powered off.
// hqm freerun clk is gated with hqm_prim_clk_enable.
//
// hqm_clk_throttle_en   - For controlling OFF / 1x / 1/8x modes of hqm_inp_gated_clk, hqm_gated_clk 
//
// hqm_gclock_enable     - Gates hqm_freerun_clk at the RCB input (combined)  - hqm_freerun_clk is a throttled hqm_clk used in Master Only.
//
// hqm_cdc_clk_enable    - Gates hqm_cdc_clk (output from pm_unit). Non-throttled hqm_clk. Not present in this module.
//
// hqm_clk_enable        - Regional hqm_clk enable.  Combined with local clk enables in PARs for hqm_gated_clk
//
// hqm_clk_throttle      - Throttle without including the hqm_clk_enable_int, used for throttling hqm_freeurn_clk
always_comb begin

  hqm_clk_throttle_en       = '0 ;

  case ( {sel0p125,sel1p0} )
    HQM_CLK_OFF : begin
      hqm_clk_throttle_en   = '0 ;
    end
    HQM_CLK_1P0 : begin
      hqm_clk_throttle_en   = pm_ip_clk_halt_b_2_rpt_0_iosf_sync ;
    end
    HQM_CLK_0P125 : begin
      hqm_clk_throttle_en   = ( hqm_cdc_clk_div8_f & pm_ip_clk_halt_b_2_rpt_0_iosf_sync ) ;
    end
    HQM_CLK_ILLEGAL : begin
      hqm_clk_throttle_en   = '0 ;
    end
    default : begin
      hqm_clk_throttle_en   = '0 ;
    end 
  endcase
end

assign hqm_clk_enable_nxt    = hqm_clk_throttle_en & hqm_clk_enable_int ;
assign hqm_gclock_enable_nxt = gclock_enable_final & pm_ip_clk_halt_b_2_rpt_0_iosf_sync ;

always_ff  @(posedge hqm_fullrate_clk or negedge hqm_fullrate_pgcb_force_rst_b_sync) begin
  if (~hqm_fullrate_pgcb_force_rst_b_sync) begin
    hqm_clk_enable_f        <= '0 ;
    hqm_clk_throttle_f      <= '0 ;
    hqm_gclock_enable_f     <= '0 ;
  end else begin
    hqm_clk_enable_f        <= hqm_clk_enable_nxt ;
    hqm_clk_throttle_f      <= hqm_clk_throttle_en ;
    hqm_gclock_enable_f     <= hqm_gclock_enable_nxt ;
  end
end

assign hqm_clk_enable     = hqm_clk_enable_f ;
assign hqm_clk_throttle   = hqm_clk_throttle_f ;
assign hqm_gclock_enable  = hqm_gclock_enable_f ;
assign hqm_clk_rptr_rst_b = pgcb_force_rst_b ;
// collage-pragma translate_on

//-----------------------------------------------------------------------------------------------------
endmodule //hqm_clk_throttle_unit

