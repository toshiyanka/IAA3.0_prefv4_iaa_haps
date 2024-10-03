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
// hqm_proc_master
//
// This unit is responsible for interfacing with the other hqm_proc partitions.
// It aggregates reset status & idle status from each par and passes information to the IOSF partition.
// It is also responsible for synchronizing the CFG Requests from the prim_gated_clk to 
// the hqm_inp_gated_clk domain, and likewise for the CFG Responses.
// 
//
//-----------------------------------------------------------------------------------------------------
module hqm_proc_master

        import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
      input   logic                                       hqm_inp_gated_clk
    , input   logic                                       hqm_gated_rst_b 
   
    , input   logic                                       prim_gated_clk   // Required for clk-crossing 
    , input   logic                                       prim_freerun_clk    // Required for clk-crossing 
    , input   logic                                       prim_gated_rst_b // Required for clk-crossing 

    , input   logic                                       hqm_cdc_clk 
    , input   logic                                       hqm_flr_prep 
    , input   logic                                       hqm_shields_up 

    // HQM_PROC_MASTER INTF
    , input   logic                                       cfg_req_down_write
    , input   logic                                       cfg_req_down_read
    , input   cfg_req_t                                   cfg_req_down

    , output  logic                                       cfg_rsp_up_ack
    , output  cfg_rsp_t                                   cfg_rsp_up

    , output  logic                                       cfg_req_up_write
    , output  logic                                       cfg_req_up_read
    , output  cfg_req_t                                   cfg_req_up

    // HQM_PROC - CFG RING INTF
    , output  logic                                       mstr_cfg_req_down_write
    , output  logic                                       mstr_cfg_req_down_read
    , output  cfg_req_t                                   mstr_cfg_req_down

    , input   logic                                       mstr_cfg_rsp_up_ack
    , input   cfg_rsp_t                                   mstr_cfg_rsp_up

    , input   logic                                       mstr_cfg_req_up_write
    , input   logic                                       mstr_cfg_req_up_read
    , input   cfg_req_t                                   mstr_cfg_req_up

    // STATUS INTF
    , input   logic   [( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_hqm_reset_done
    , input   logic   [( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_unit_idle
    , input   logic   [( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_lcb_enable
    , input   logic   [( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_unit_pipeidle

    , output  logic                                       hqm_proc_master_reset_done
    , output  logic                                       hqm_proc_master_unit_idle 

    // CFG STATUS REG
    , output  mstr_proc_reset_status_t                    mstr_proc_reset_status  
    , output  mstr_proc_idle_status_t                     mstr_proc_idle_status  
    , output  mstr_proc_lcb_status_t                      mstr_proc_lcb_status  

    // VISA INTF
    , output  logic                                       visa_str_hqm_proc_pipeidle

    // FSCAN RST INTF
    , input   logic                                       fscan_rstbypen 
    , input   logic                                       fscan_byprst_b 
);
//-----------------------------------------------------------------------------------------------------
localparam CFG_REQ_WCTL_DWIDTH = ( $bits(cfg_req_wctrl_t) ) ;
localparam CFG_REQ_DWIDTH      = ( $bits(cfg_req_t) ) ;
localparam CFG_RSP_DWIDTH      = ( $bits(cfg_rsp_t) ) ;

//-----------------------------------------------------------------------------------------------------
logic hqm_cdc_hqm_gated_rst_b_sync ;
logic prim_freerun_prim_gated_rst_b_sync ;
logic prim_freerun_hqm_gated_rst_b_sync ;

mstr_proc_idle_status_t mstr_proc_idle_status_f, mstr_proc_idle_status_nxt ;
mstr_proc_lcb_status_t  mstr_proc_lcb_status_f, mstr_proc_lcb_status_nxt ;
// STATUS AGGREGATION
logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] hqm_reset_done_f, hqm_reset_done_nxt;
logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] core_reset_done_f, core_reset_done_nxt;
logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] reset_done_edge_detect;
logic                                      hqm_reset_active_f, hqm_reset_active_nxt;       // Not available per-unit (output to SYS)


logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_unit_pipeidle_f;
logic mstr_pf_rst_active_f, mstr_pf_rst_active_nxt ;

logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_unit_idle_post_prot ;
logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_unit_pipeidle_post_prot ;
logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_hqm_reset_done_post_prot ;
logic [ ( HQM_PROC_CFG_NUM_UNITS ) -1 : 0] mstr_lcb_enable_post_prot ;
logic cfg_req_up_pulse_pre_prot ;
logic cfg_rsp_up_ack_pre_prot ;
logic mstr_cfg_req_down_write_pre_prot ;
logic mstr_cfg_req_down_read_pre_prot ;

logic hqm_proc_master_unit_idle_f, hqm_proc_master_unit_idle_nxt ;
logic hqm_proc_master_reset_done0_f, hqm_proc_master_reset_done0_nxt ;
logic hqm_proc_master_reset_done1_f, hqm_proc_master_reset_done2_f, hqm_proc_master_reset_done3_f ;

logic cfg_req_down_pulse, mstr_cfg_req_down_pulse;
cfg_req_wctrl_t cfg_req_down_data_wctrl, mstr_cfg_req_down_data_wctrl;

logic cfg_req_up_pulse, mstr_cfg_req_up_pulse;
cfg_req_wctrl_t cfg_req_up_data_wctrl, mstr_cfg_req_up_data_wctrl;

//-----------------------------------------------------------------------------------------------------
// visa connection

assign visa_str_hqm_proc_pipeidle      = &mstr_unit_pipeidle_f ;

//-----------------------------------------------------------------------------------------------------
// Reset Syncs
hqm_AW_reset_sync_scan i_hqm_cdc_hqm_gated_rst_b_sync (

         .clk                    ( hqm_cdc_clk )
        ,.rst_n                  ( hqm_gated_rst_b )
        ,.fscan_rstbypen         ( fscan_rstbypen )
        ,.fscan_byprst_b         ( fscan_byprst_b )
        ,.rst_n_sync             ( hqm_cdc_hqm_gated_rst_b_sync )
);

hqm_AW_reset_sync_scan i_hqm_prim_freerun_prim_gated_rst_b_sync (

         .clk                    ( prim_freerun_clk )
        ,.rst_n                  ( prim_gated_rst_b )
        ,.fscan_rstbypen         ( fscan_rstbypen )
        ,.fscan_byprst_b         ( fscan_byprst_b )
        ,.rst_n_sync             ( prim_freerun_prim_gated_rst_b_sync )
) ;

hqm_AW_reset_sync_scan i_hqm_prim_freerun_hqm_gated_rst_b_sync (

         .clk                    ( prim_freerun_clk )
        ,.rst_n                  ( hqm_gated_rst_b )
        ,.fscan_rstbypen         ( fscan_rstbypen )
        ,.fscan_byprst_b         ( fscan_byprst_b )
        ,.rst_n_sync             ( prim_freerun_hqm_gated_rst_b_sync )
) ;

//-----------------------------------------------------------------------------------------------------
// CFG CLOCK CROSSINGS
//-----------------------------------------------------------------------------------------------------
// CFG Requests (DOWN) originate from hqm_cfg_master(prim_gated_clk)
// Destination will be CFG RING (hqm_inp_gated_clk)

assign cfg_req_down_pulse          = ( cfg_req_down_write | cfg_req_down_read ) ;
assign cfg_req_down_data_wctrl.wr  = cfg_req_down_write ; 
assign cfg_req_down_data_wctrl.rd  = cfg_req_down_read ; 
assign cfg_req_down_data_wctrl.req = cfg_req_down ; 

// iosf protects from FLR being started while a CFG request is active within the master/ring
// for robustness, the the src_rst_n is tied to dst_rst_n to ensure the AW would never lock up
// if a destination side reset ocurred before the AW's internal handshake completed.a
logic cfg_req_down_active_nc;
hqm_AW_async_one_pulse_reg #(
  .WIDTH                         ( CFG_REQ_WCTL_DWIDTH )
) i_async_one_pulse_reg_cfg_req_down (
   .src_clk                      ( prim_gated_clk )
 , .src_rst_n                    ( prim_freerun_hqm_gated_rst_b_sync )
 , .dst_clk                      ( hqm_inp_gated_clk )
 , .dst_rst_n                    ( hqm_cdc_hqm_gated_rst_b_sync )
    
 , .in_v                         ( cfg_req_down_pulse )
 , .in_data                      ( cfg_req_down_data_wctrl )
 , .out_v                        ( mstr_cfg_req_down_pulse )
 , .out_data                     ( mstr_cfg_req_down_data_wctrl )

 , .req_active                   ( cfg_req_down_active_nc )
) ;

assign mstr_cfg_req_down_write_pre_prot = ( mstr_cfg_req_down_pulse & mstr_cfg_req_down_data_wctrl.wr ) ;
assign mstr_cfg_req_down_read_pre_prot  = ( mstr_cfg_req_down_pulse & mstr_cfg_req_down_data_wctrl.rd ) ;
assign mstr_cfg_req_down                = ( mstr_cfg_req_down_data_wctrl.req ) ;
//-----------------------------------------------------------------------------------------------------
// CFG Responses (UP) originate from CFG RING (hqm_inp_gated_clk)
// Destination will be hqm_cfg_master(prim_gated_clk)
logic cfg_rsp_up_active_nc;
hqm_AW_async_one_pulse_reg #(      
  .WIDTH                         ( CFG_RSP_DWIDTH )
) i_async_one_pulse_reg_cfg_rsp_up (
   .src_clk                      ( hqm_inp_gated_clk ) 
 , .src_rst_n                    ( hqm_cdc_hqm_gated_rst_b_sync )
 , .dst_clk                      ( prim_gated_clk )
 , .dst_rst_n                    ( prim_freerun_prim_gated_rst_b_sync )
    
 , .in_v                         ( mstr_cfg_rsp_up_ack )
 , .in_data                      ( mstr_cfg_rsp_up )
 , .out_v                        ( cfg_rsp_up_ack_pre_prot )
 , .out_data                     ( cfg_rsp_up )

 , .req_active                   ( cfg_rsp_up_active_nc )
) ;
//-----------------------------------------------------------------------------------------------------
// CFG Requests (UP) originate from CFG RING (hqm_inp_gated_clk)
// Destination will be hqm_cfg_master(prim_gated_clk)
// Used for error detection within the hqm_cfg_master (e.g., cfg_req_miss)

assign mstr_cfg_req_up_data_wctrl.wr   = ( mstr_cfg_req_up_write ) ;
assign mstr_cfg_req_up_data_wctrl.rd   = ( mstr_cfg_req_up_read  ) ;
assign mstr_cfg_req_up_data_wctrl.req  = ( mstr_cfg_req_up       ) ;
assign mstr_cfg_req_up_pulse           = ( mstr_cfg_req_up_data_wctrl.wr | mstr_cfg_req_up_data_wctrl.rd ) ;
logic cfg_req_up_active_nc;
hqm_AW_async_one_pulse_reg #(
  .WIDTH                         ( CFG_REQ_WCTL_DWIDTH )
) i_async_one_pulse_reg_cfg_req_up (
   .src_clk                      ( hqm_inp_gated_clk )
 , .src_rst_n                    ( hqm_cdc_hqm_gated_rst_b_sync )
 , .dst_clk                      ( prim_gated_clk )
 , .dst_rst_n                    ( prim_freerun_prim_gated_rst_b_sync )
    
 , .in_v                         ( mstr_cfg_req_up_pulse )
 , .in_data                      ( mstr_cfg_req_up_data_wctrl )
 , .out_v                        ( cfg_req_up_pulse_pre_prot )
 , .out_data                     ( cfg_req_up_data_wctrl )

 , .req_active                   ( cfg_req_up_active_nc )
) ;

assign cfg_req_up_write          = ( cfg_req_up_pulse & cfg_req_up_data_wctrl.wr ) ;
assign cfg_req_up_read           = ( cfg_req_up_pulse & cfg_req_up_data_wctrl.rd ) ;
assign cfg_req_up                = ( cfg_req_up_data_wctrl.req ) ;
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------




//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
// HQM CORE RESET STATUS AGGREGATION
// The done signals from each unit are levels.  The rising edges are detected and then done value is held.
// The done flops are cleared by issuing a new reset start.  
//
// Diagnostic Reset Status must be RO/V
// cleared by the triggereing of the next reset issued via cfg 
//
assign core_reset_done_nxt = mstr_hqm_reset_done_post_prot ;

always_comb begin

 
  // PF Reset Active  is  cleared once ALL units have reported DONE   
  hqm_reset_active_nxt = hqm_reset_active_f ;
  if ( &hqm_reset_done_f ) begin
    hqm_reset_active_nxt = 1'b0 ;
  end

  // PF reset done : per-unit levels sent to hqm_master and flopped for rising edge detect
  // Source is hqm_inp_gated_clk and hqm_gated_rst_b 
  reset_done_edge_detect  = (~core_reset_done_f & core_reset_done_nxt ) ;  

  hqm_reset_done_nxt      = ( hqm_reset_done_f | reset_done_edge_detect ) ;
end

//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
// Hqm Proc Master Unit Idle & Reset Done Aggregation
//
// Aggregates all "hqm_proc" idle status that is on hqm_inp_gated_clk
// Flopped and sent to hqm_cfg_master, where it will be synced to prim_gated_clk
// and used to create the hqm_proc_idle signal.
//
assign hqm_proc_master_unit_idle_nxt  = (  (&mstr_unit_idle_post_prot)
                                        &  (&hqm_reset_done_f)
                                        ) ;

assign hqm_proc_master_unit_idle      = hqm_proc_master_unit_idle_f ;

assign mstr_pf_rst_active_nxt = ( ~(&hqm_reset_done_f) ) ;

// Create hqm_proc_master's Reset Done
// Flopped and sent to hqm_cfg_master, where it will be synced (and final version is presented to IOSF)
assign hqm_proc_master_reset_done0_nxt = ( &hqm_reset_done_f ) ;
assign hqm_proc_master_reset_done      = hqm_proc_master_reset_done3_f ;

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_cdc_hqm_gated_rst_b_sync) begin
 if (~hqm_cdc_hqm_gated_rst_b_sync) begin
   hqm_reset_active_f              <= 1'b1;
   hqm_reset_done_f                <= {HQM_PROC_CFG_NUM_UNITS{1'd0}};
   core_reset_done_f               <= {HQM_PROC_CFG_NUM_UNITS{1'd0}};
   mstr_unit_pipeidle_f            <= {HQM_PROC_CFG_NUM_UNITS{1'd1}};
   mstr_pf_rst_active_f            <= 1'b1 ;

   hqm_proc_master_unit_idle_f     <= 1'b0;
   hqm_proc_master_reset_done0_f   <= 1'b0;
   hqm_proc_master_reset_done1_f   <= 1'b0;
   hqm_proc_master_reset_done2_f   <= 1'b0;
   hqm_proc_master_reset_done3_f   <= 1'b0;

   mstr_proc_idle_status_f         <= 20'hfffff ;
   mstr_proc_lcb_status_f          <= '0 ;
 end else begin
   hqm_reset_active_f              <= hqm_reset_active_nxt;
   hqm_reset_done_f                <= hqm_reset_done_nxt;
   core_reset_done_f               <= core_reset_done_nxt;
   mstr_unit_pipeidle_f            <= mstr_unit_pipeidle_post_prot;
   mstr_pf_rst_active_f            <= mstr_pf_rst_active_nxt ;

   hqm_proc_master_unit_idle_f     <= hqm_proc_master_unit_idle_nxt;
   hqm_proc_master_reset_done0_f   <= hqm_proc_master_reset_done0_nxt;
   hqm_proc_master_reset_done1_f   <= hqm_proc_master_reset_done0_f;
   hqm_proc_master_reset_done2_f   <= hqm_proc_master_reset_done1_f;
   hqm_proc_master_reset_done3_f   <= hqm_proc_master_reset_done2_f;

   mstr_proc_idle_status_f         <= mstr_proc_idle_status_nxt ;
   mstr_proc_lcb_status_f          <= mstr_proc_lcb_status_nxt ;
 end
end

assign mstr_proc_idle_status_nxt.SYS_UNIT_IDLE         = mstr_unit_idle_post_prot[9] ;
assign mstr_proc_idle_status_nxt.AQED_UNIT_IDLE        = mstr_unit_idle_post_prot[8] ;
assign mstr_proc_idle_status_nxt.DQED_UNIT_IDLE        = mstr_unit_idle_post_prot[7] ;
assign mstr_proc_idle_status_nxt.QED_UNIT_IDLE         = mstr_unit_idle_post_prot[6] ;
assign mstr_proc_idle_status_nxt.DP_UNIT_IDLE          = mstr_unit_idle_post_prot[5] ;
assign mstr_proc_idle_status_nxt.AP_UNIT_IDLE          = mstr_unit_idle_post_prot[4] ;
assign mstr_proc_idle_status_nxt.NALB_UNIT_IDLE        = mstr_unit_idle_post_prot[3] ;
assign mstr_proc_idle_status_nxt.LSP_UNIT_IDLE         = mstr_unit_idle_post_prot[2] ;
assign mstr_proc_idle_status_nxt.ROP_UNIT_IDLE         = mstr_unit_idle_post_prot[1] ;
assign mstr_proc_idle_status_nxt.CHP_UNIT_IDLE         = mstr_unit_idle_post_prot[0] ;
assign mstr_proc_idle_status_nxt.SYS_UNIT_PIPEIDLE     = mstr_unit_pipeidle_post_prot[9] ;
assign mstr_proc_idle_status_nxt.AQED_UNIT_PIPEIDLE    = mstr_unit_pipeidle_post_prot[8] ;
assign mstr_proc_idle_status_nxt.DQED_UNIT_PIPEIDLE    = mstr_unit_pipeidle_post_prot[7] ;
assign mstr_proc_idle_status_nxt.QED_UNIT_PIPEIDLE     = mstr_unit_pipeidle_post_prot[6] ;
assign mstr_proc_idle_status_nxt.DP_UNIT_PIPEIDLE      = mstr_unit_pipeidle_post_prot[5] ;
assign mstr_proc_idle_status_nxt.AP_UNIT_PIPEIDLE      = mstr_unit_pipeidle_post_prot[4] ;
assign mstr_proc_idle_status_nxt.NALB_UNIT_PIPEIDLE    = mstr_unit_pipeidle_post_prot[3] ;
assign mstr_proc_idle_status_nxt.LSP_UNIT_PIPEIDLE     = mstr_unit_pipeidle_post_prot[2] ;
assign mstr_proc_idle_status_nxt.ROP_UNIT_PIPEIDLE     = mstr_unit_pipeidle_post_prot[1] ;
assign mstr_proc_idle_status_nxt.CHP_UNIT_PIPEIDLE     = mstr_unit_pipeidle_post_prot[0] ;
assign mstr_proc_idle_status                           = mstr_proc_idle_status_f;

assign mstr_proc_reset_status.PF_RESET_ACTIVE      = mstr_pf_rst_active_f ;
assign mstr_proc_reset_status.SYS_PF_RESET_DONE    = hqm_reset_done_f[9] ;
assign mstr_proc_reset_status.AQED_PF_RESET_DONE   = hqm_reset_done_f[8] ;
assign mstr_proc_reset_status.DQED_PF_RESET_DONE   = hqm_reset_done_f[7] ;
assign mstr_proc_reset_status.QED_PF_RESET_DONE    = hqm_reset_done_f[6] ;
assign mstr_proc_reset_status.DP_PF_RESET_DONE     = hqm_reset_done_f[5] ;
assign mstr_proc_reset_status.AP_PF_RESET_DONE     = hqm_reset_done_f[4] ;
assign mstr_proc_reset_status.NALB_PF_RESET_DONE   = hqm_reset_done_f[3] ;
assign mstr_proc_reset_status.LSP_PF_RESET_DONE    = hqm_reset_done_f[2] ;
assign mstr_proc_reset_status.ROP_PF_RESET_DONE    = hqm_reset_done_f[1] ;
assign mstr_proc_reset_status.CHP_PF_RESET_DONE    = hqm_reset_done_f[0] ;

assign mstr_proc_lcb_status_nxt.SYS_LCB_ENABLE    = mstr_lcb_enable_post_prot[9] ;
assign mstr_proc_lcb_status_nxt.AQED_LCB_ENABLE   = mstr_lcb_enable_post_prot[8] ;
assign mstr_proc_lcb_status_nxt.DQED_LCB_ENABLE   = mstr_lcb_enable_post_prot[7] ;
assign mstr_proc_lcb_status_nxt.QED_LCB_ENABLE    = mstr_lcb_enable_post_prot[6] ;
assign mstr_proc_lcb_status_nxt.DP_LCB_ENABLE     = mstr_lcb_enable_post_prot[5] ;
assign mstr_proc_lcb_status_nxt.AP_LCB_ENABLE     = mstr_lcb_enable_post_prot[4] ;
assign mstr_proc_lcb_status_nxt.NALB_LCB_ENABLE   = mstr_lcb_enable_post_prot[3] ;
assign mstr_proc_lcb_status_nxt.LSP_LCB_ENABLE    = mstr_lcb_enable_post_prot[2] ;
assign mstr_proc_lcb_status_nxt.ROP_LCB_ENABLE    = mstr_lcb_enable_post_prot[1] ;
assign mstr_proc_lcb_status_nxt.CHP_LCB_ENABLE    = mstr_lcb_enable_post_prot[0] ;
assign mstr_proc_lcb_status                       = mstr_proc_lcb_status_f;

//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
// Interface Protection
//
genvar g;
generate
  for (g = 0 ; g < (HQM_PROC_CFG_NUM_UNITS) ; g = g + 1 ) begin : g_if_prot
    hqm_AW_if_prot_h
    i_unit_idle_if_prot_h (
      .flr_prep      ( hqm_flr_prep )
     ,.in_data       ( mstr_unit_idle[g] )
     ,.out_data      ( mstr_unit_idle_post_prot[g] )
    );

    hqm_AW_if_prot_h
    i_unit_pipeidle_if_prot_h (
      .flr_prep      ( hqm_flr_prep )
     ,.in_data       ( mstr_unit_pipeidle[g] )
     ,.out_data      ( mstr_unit_pipeidle_post_prot[g] )
    );

    hqm_AW_if_prot_l
    i_reset_done_if_prot_l (
      .flr_prep      ( hqm_flr_prep )
     ,.in_data       ( mstr_hqm_reset_done[g] )
     ,.out_data      ( mstr_hqm_reset_done_post_prot[g] )
    );

    hqm_AW_if_prot_l
    i_lcb_enable_if_prot_l (
      .flr_prep      ( hqm_flr_prep )
     ,.in_data       ( mstr_lcb_enable[g] )
     ,.out_data      ( mstr_lcb_enable_post_prot[g] )
    );
  end
endgenerate

hqm_AW_if_prot_l
i_cfg_req_up_pulse_if_prot_l (
  .flr_prep      ( hqm_shields_up )
 ,.in_data       ( cfg_req_up_pulse_pre_prot )
 ,.out_data      ( cfg_req_up_pulse )
);

hqm_AW_if_prot_l
i_mstr_cfg_rsp_up_ack_if_prot_l (
  .flr_prep      ( hqm_shields_up )
 ,.in_data       ( cfg_rsp_up_ack_pre_prot )
 ,.out_data      ( cfg_rsp_up_ack )
);

hqm_AW_if_prot_l
i_mstr_cfg_req_down_write_if_prot_l (
  .flr_prep      ( hqm_flr_prep )
 ,.in_data       ( mstr_cfg_req_down_write_pre_prot )
 ,.out_data      ( mstr_cfg_req_down_write )
);

hqm_AW_if_prot_l
i_mstr_cfg_req_down_read_if_prot_l (
  .flr_prep      ( hqm_flr_prep )
 ,.in_data       ( mstr_cfg_req_down_read_pre_prot )
 ,.out_data      ( mstr_cfg_req_down_read )
);

//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
endmodule //hqm_proc_master

