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
// hqm_cfg_master
//
// This module is a subBlock of hqm_master.  It is responsible for managing CFG access, aggregating 
// reset done and idle indications, maintaing the CHP timestamp, and managing the service availablitiy
//  counters and pm state registers. hqm core config and status aggregator logic.
//
//-----------------------------------------------------------------------------------------------------
module hqm_cfg_master

        import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
      input  logic                                        prim_gated_clk
    , input  logic                                        prim_freerun_clk
    , input  logic                                        prim_gated_rst_b

    , input  logic                                        pgcb_clk
    , input  logic                                        wd_clkreq
    , input  logic                                        flr_clkreq_b
    , output logic                                        hqm_proc_clkreq_b
    , output logic                                        hqm_cfg_master_clkreq_b   // proc_clkreq w/out the wd contribution (for visa)

    , input  logic                                        hqm_cdc_clk
    , input  logic                                        hqm_inp_gated_clk
    , input  logic                                        hqm_gated_rst_b

    , input  logic                                        pgcb_force_rst_b

    , output logic                                        cfg_prochot_disable

    , input  logic                                        prochot
    , output logic                                        prochot_deglitch_sync
    
    , input  logic                                        hqm_shields_up
    , input  logic                                        hqm_flr_prep

    , input   logic                                       flr_triggered
 
    // CHP TIMESTAMP INTF 
    , output  logic   [ ( 16 ) - 1 : 0]                   master_chp_timestamp
    
    , output  cfg_hqm_cdc_ctl_t                           cfg_hqm_cdc_ctl
    , output  logic                                       cfg_hqm_cdc_ctl_v

    , output  cfg_hqm_pgcb_ctl_t                          cfg_hqm_pgcb_ctl
    , output  logic                                       cfg_hqm_pgcb_ctl_v

    , output  cfg_pm_override_t                           cfg_pm_override

    , output  cfg_pm_pmcsr_disable_t                      cfg_pm_pmcsr_disable

    , input   cfg_pm_status_t                             cfg_pm_status
    , input   logic                                       cfg_d3tod0_event_cnt_inc 
    , input   logic                                       pm_fsm_in_run 
    , output  logic                                       pm_allow_ing_drop 

    // IOSF APB INTF
    , input  cfg_user_t                                   puser 
    , input  logic                                        psel
    , input  logic                                        pwrite
    , input  logic                                        penable
    , input  logic    [( 32 )-1:0]                        paddr
    , input  logic    [( 32 )-1:0]                        pwdata
 
    , output  logic                                       pready
    , output  logic                                       pslverr
    , output  logic   [( 32 )-1:0]                        prdata
    , output  logic                                       prdata_par

    // HQM_PROC_MASTER CFG INTF
    , output  logic                                       cfg_req_down_write
    , output  logic                                       cfg_req_down_read
    , output  cfg_req_t                                   cfg_req_down

    , input   logic                                       cfg_rsp_up_ack 
    , input   cfg_rsp_t                                   cfg_rsp_up

    , input   logic                                       cfg_req_up_write 
    , input   logic                                       cfg_req_up_read 
    , input   cfg_req_t                                   cfg_req_up

    // STATUS INTF
    , input   flrsm_t                                     flrsm_state

    , input   logic                                       hqm_proc_master_unit_idle
    , input   logic                                       hqm_proc_master_reset_done

    , output  logic                                       hqm_proc_reset_done
    , output  logic                                       hqm_proc_reset_done_sync_hqm

    // CFG REGS
    , input   mstr_proc_reset_status_t                    mstr_proc_reset_status
    , input   mstr_proc_idle_status_t                     mstr_proc_idle_status                          
    , input   mstr_proc_lcb_status_t                      mstr_proc_lcb_status
    , input   logic [63:0]                                cfg_flr_count 

    // 	VISA
    , output  logic                                       visa_str_hqm_proc_idle

    // FSCAN RST INTF
    , input   logic                                       fscan_rstbypen 
    , input   logic                                       fscan_byprst_b
    , input   logic                                       pm_fsm_active

);

//-----------------------------------------------------------------------------------------------------
//Check for invalid paramter configation
genvar GEN0 ;
generate
  if ( ~( HQM_PROC_CFG_NUM_UNITS == 10 ) ) begin : invalid_check_HQM_PROC_CFG_NUM_UNITS
    for ( GEN0 = HQM_PROC_CFG_NUM_UNITS ; GEN0 <= HQM_PROC_CFG_NUM_UNITS ; GEN0 = GEN0+1 ) begin : invalid_HQM_PROC_CFG_NUM_UNITS
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end

  if ( ~( HQM_MSTR_CFG_UNIT_ID <= 15 ) ) begin : invalid_check_HQM_MSTR_CFG_UNIT_ID_WIDTH
    for ( GEN0 = HQM_MSTR_CFG_UNIT_ID ; GEN0 <= HQM_MSTR_CFG_UNIT_ID ; GEN0 = GEN0+1 ) begin : invalid_HQM_MSTR_CFG_UNIT_ID_WIDTH
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end

  if ( ~( HQM_MSTR_CFG_NODE_ID <= 15 ) ) begin : invalid_check_HQM_MSTR_CFG_NODE_ID_WIDTH
    for ( GEN0 = HQM_MSTR_CFG_NODE_ID ; GEN0 <= HQM_MSTR_CFG_NODE_ID ; GEN0 = GEN0+1 ) begin : invalid_HQM_MSTR_CFG_NODE_ID_WIDTH
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end
endgenerate
//-----------------------------------------------------------------------------------------------------

localparam HQM_MSTR_ENCWIDTH           = (AW_logb2(HQM_MSTR_ALARM_NUM_INF-1)+1);
localparam HQM_MSTR_ZERO_PAD = 14 - HQM_PROC_CFG_NUM_UNITS;
localparam NUM_CFG_ACCESSIBLE_RAM = 1 ;

//------------------------------------------------------------------------------------------------------------------

logic                            prim_freerun_prim_gated_rst_b_sync;
logic                            prim_freerun_hqm_gated_rst_b_sync ;
logic                            hqm_cdc_hqm_gated_rst_b_sync ;

logic                            cfg_req_ring_active;
logic                            cfg_req_mstr_active;
logic                            cfg_req_idlepipe_nc ;
logic                            cfg_req_ready ;
logic                            prim_cfg_req_4phase_write_nc ;

logic                            cfg_hqm_cdc_ctl_v_f, cfg_hqm_cdc_ctl_v_nxt;
logic                            cfg_hqm_pgcb_ctl_v_f, cfg_hqm_pgcb_ctl_v_nxt;
logic [63:0]                     hqm_mstr_target_cfg_d3tod0_event_cnt_nc;
logic [63:0]                     hqm_mstr_target_cfg_prochot_event_cnt_nc;
logic [63:0]                     hqm_mstr_target_cfg_prochot_cnt_nc;
logic [63:0]                     hqm_mstr_target_cfg_proc_on_cnt_nc;
logic [63:0]                     hqm_mstr_target_cfg_clk_on_cnt_nc;
logic [31:0]                     hqm_mstr_target_cfg_flr_count_l_reg_f_nc, hqm_mstr_target_cfg_flr_count_h_reg_f_nc ;
logic [15:0]                     cfg_ts_div;
logic [15:0]                     cfg_ts_nc;
logic                            prochot_f, prochot_nxt;

cfg_mstr_internal_timeout_t      cfg_mstr_internal_timeout;
cfg_clk_cnt_disable_t            cfg_clk_cnt_disable;

logic                            hqm_proc_master_unit_idle_sync_prim;
logic                            hqm_proc_master_reset_done_sync_prim ;
logic                            hqm_cfg_master_unit_idle ;
logic                            hqm_func_unit_idle ;
logic                            hqm_func_idle ;
logic                            hqm_proc_idle_f_sync_hqm ;
// ALARMS
logic                            err_timeout ;
logic                            err_cfg_reqrsp_unsol ;
logic                            err_cfg_protocol ;
logic                            err_cfg_req_up_miss ;
logic                            err_slv_access ;
logic                            err_slv_timeout ;
logic                            err_slv_par ;
logic                            err_cfg_decode ;
logic                            err_cfg_decode_par ;
logic [ ( HQM_MSTR_ALARM_NUM_INF ) -1 : 0] enc_err_v;
logic                            err_cfg_req_drop ;

// CONFIG
logic [ ( 1 ) - 1 : 0 ]   cfg_req_internal_write ;
logic [ ( 1 ) - 1 : 0 ]   cfg_req_internal_read ;
cfg_req_t                 cfg_req_internal ;
logic [ ( 1 ) - 1 : 0 ]   cfg_rsp_internal_ack ;
cfg_rsp_t                 cfg_rsp_internal ;
 
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ]      unit_cfg_req_write ;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ]      unit_cfg_req_read ;
cfg_req_t                                             unit_cfg_req ;
logic                                                 unit_cfg_rsp_ack ;
logic                                                 unit_cfg_rsp_err ;
logic [ ($bits ( cfg_rsp_internal.rdata ) ) - 1 : 0 ] unit_cfg_rsp_rdata ;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ]      prim_cfg_req_write_pre_lock;
logic                                                 prim_cfg_rsp_ack_post_lock;
logic                                                 prim_cfg_rsp_err_post_lock;
logic [ ( 32 ) - 1 : 0 ]                              prim_cfg_rsp_rdata_post_lock; 


logic                     cfg_idle, cfg_cfg2cfg_idle, cfg_mstr_idle, cfg_ring_idle;
logic                     hqm_proc_idle_f, hqm_proc_idle_nxt;
logic                     hqm_proc_reset_done_f, hqm_proc_reset_done_nxt;
logic                     hqm_proc_reset_done_f_sync_hqm;

logic                     syndrome_capture_v;
mstr_syndrome_t           syndrome_capture_data;
logic [31:0]              syndrome_data_nc;

logic                     cfg_enable_inj_par_err_rdata;
logic                     cfg_enable_inj_par_err_wdata;
logic                     cfg_enable_inj_par_err_addr;
logic                     cfg_enable_hqm_proc_idle;
logic                     inj_par_err_req_clr;
logic                     inj_par_err_rsp_clr;

logic [ ( 1*32 ) -1 : 0 ] cfg_diagnostic_status_1_f_pnc, cfg_diagnostic_status_1_nxt;
logic                     load_sticky ;
logic [ ( 1*32 ) -1 : 0 ] cfg_control_general_f , cfg_control_general_nxt ;
logic [ ( 16 ) -1 : 0 ]   cfg_idle_dly ; 
logic                     cfg_ignore_pipe_busy ;
logic                     cfg_enable_alarms ;
logic                     cfg_disable_ring_par_ck ;
logic                     cfg_disable_pslverr_timeout ;
logic                     cfg_pm_allow_ing_drop ;
logic [ ( 1*6 ) -1 : 0 ]  cfg_control_general_f_pnc ;

logic [ ( 24 ) -1 : 0 ]   cfg_syndrome_addr_nxt , cfg_syndrome_addr_f;
logic [ $bits(cfg_rsp_up.uid) -1 : 0 ] cfg_syndrome_rsp_uid_nxt, cfg_syndrome_rsp_uid_f; 
logic                     cfg_syndrome_err_any;
logic [ ( HQM_MSTR_ENCWIDTH ) -1 : 0 ] cfg_syndrome_err_enc; 
logic                      hqm_proc_hqm_clkreq_wd_b_pre, hqm_proc_hqm_clkreq_wd_b;
logic                      hqm_proc_hqm_clkreq_hqm_b_pre, hqm_proc_hqm_clkreq_hqm_b;


mstr_proc_reset_status_t                    mstr_proc_reset_status_sync_prim,mstr_proc_reset_status_post_prep;
mstr_proc_idle_status_t                     mstr_proc_idle_status_sync_prim,mstr_proc_idle_status_post_prep;
mstr_proc_lcb_status_t                      mstr_proc_lcb_status_sync_prim,mstr_proc_lcb_status_post_prep;
mstr_cfg_reset_status_reg_t                 cfg_diagnostic_reset_status;
mstr_cfg_idle_status_reg_t                  cfg_diagnostic_idle_status;
mstr_cfg_lcb_status_reg_t                   cfg_diagnostic_lcb_status;

logic [15:0] ts_cnt_f, ts_cnt_nxt ;
logic [15:0] timestamp_f, timestamp_nxt ;
logic [15:0] tsgray_f, tsgray_nxt ;
logic [15:0] tsgray_sync_hqm ;

logic    hqm_proc_master_unit_idle_post_prep ;
logic    hqm_proc_master_reset_done_post_prep ;

// STATUS AGGREGATION
logic                   clr_idle_clk_cnt, idle_clk_cnt_eq_max ;
logic [ ( 16 ) -1 : 0 ] idle_clk_cnt_f, idle_clk_cnt_nxt ;

logic                   clr_func_idle_clk_cnt, func_idle_clk_cnt_eq_max ;
logic [ ( 6 ) -1 : 0 ] func_idle_clk_cnt_f, func_idle_clk_cnt_nxt ;


logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write_nc;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read_nc;
logic        cfg_mem_re_nc;
logic [19:0] cfg_mem_addr_nc;
logic [11:0] cfg_mem_minbit_nc;
logic [11:0] cfg_mem_maxbit_nc;
logic        cfg_mem_we_nc;
logic [31:0] cfg_mem_wdata_nc;
logic [31:0] cfg_mem_rdata_nc;
logic        cfg_mem_ack_nc;

logic        cfg_prochot_disable_sync_0_f, cfg_prochot_disable_sync_1_f ;
logic        cfg_prochot_disable_sync_prim ;
logic        prochot_sync_0_f, prochot_sync_1_f ;
logic        prochot_sync_prim ;
flrsm_t      flrsm_state_sync_prim;

//-----------------------------------------------------------------------------------------------------
// Tieoffs and NC's
assign cfg_mem_ack_nc   = '0 ;
assign cfg_mem_rdata_nc = '0 ;

assign cfg_req_ready = 1'b1 ;

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
// Use hqm_shields_up (hqm_flr_prep prim version) to protect against RDCs from PROC domain
//
always_comb begin
  if ( hqm_shields_up ) begin 
    hqm_proc_master_unit_idle_post_prep      = '0 ;
    hqm_proc_master_reset_done_post_prep     = '0 ; 
    mstr_proc_reset_status_post_prep         = '0 ;
    mstr_proc_idle_status_post_prep          = '0 ; 
    mstr_proc_lcb_status_post_prep           = '0 ;
  end else begin 
    hqm_proc_master_unit_idle_post_prep      = hqm_proc_master_unit_idle_sync_prim ;
    hqm_proc_master_reset_done_post_prep     = hqm_proc_master_reset_done_sync_prim ;
    mstr_proc_reset_status_post_prep         = mstr_proc_reset_status_sync_prim ;
    mstr_proc_idle_status_post_prep          = mstr_proc_idle_status_sync_prim ;
    mstr_proc_lcb_status_post_prep           = mstr_proc_lcb_status_sync_prim ;
  end
end
//------------------------------------------------------------------------------------------------------------------
// VISA
assign visa_str_hqm_proc_idle = hqm_proc_idle_f_sync_hqm ;

//------------------------------------------------------------------------------------------------------------------
// Reset Syncs
hqm_AW_reset_sync_scan i_hqm_prim_freerun_prim_gated_rst_b_sync (

   .clk                     ( prim_freerun_clk )
  ,.rst_n                   ( prim_gated_rst_b )
  ,.fscan_rstbypen          ( fscan_rstbypen )
  ,.fscan_byprst_b          ( fscan_byprst_b )
  ,.rst_n_sync              ( prim_freerun_prim_gated_rst_b_sync )
);

hqm_AW_reset_sync_scan i_hqm_cdc_hqm_gated_rst_b_sync (

   .clk                     ( hqm_cdc_clk )
  ,.rst_n                   ( hqm_gated_rst_b )
  ,.fscan_rstbypen          ( fscan_rstbypen )
  ,.fscan_byprst_b          ( fscan_byprst_b )
  ,.rst_n_sync              ( hqm_cdc_hqm_gated_rst_b_sync )
);

//------------------------------------------------------------------------------------------------------------------
// Data Syncs 
// Following Master convention, inputs are synced to local clk before use 

// Sync flrsm_state for status reg
hqm_AW_sync_rst0  #(
   .WIDTH                   ( 6 )
) i_flrsm_sync_prim_b6_1 (

   .clk                     ( prim_gated_clk )
  ,.rst_n                   ( prim_freerun_prim_gated_rst_b_sync )
  ,.data                    ( flrsm_state[6:1] )
  ,.data_sync               ( flrsm_state_sync_prim[6:1] )
);

hqm_AW_sync_rst1  #(
   .WIDTH                   ( 1 )
) i_flrsm_sync_prim_b0 (

   .clk                     ( prim_gated_clk )
  ,.rst_n                   ( prim_freerun_prim_gated_rst_b_sync )
  ,.data                    ( flrsm_state[0] )
  ,.data_sync               ( flrsm_state_sync_prim[0] )
);

// Sync prochot
hqm_AW_sync_rst0  #(
   .WIDTH                   ( 1 )
) i_cfg_prochot_disable_sync_prim (

   .clk                     ( prim_freerun_clk )
  ,.rst_n                   ( prim_freerun_prim_gated_rst_b_sync )
  ,.data                    ( cfg_prochot_disable )
  ,.data_sync               ( cfg_prochot_disable_sync_prim )
);

hqm_AW_sync_rst0  #(
   .WIDTH                   ( 1 )
) i_prochot_sync (

   .clk                     ( prim_freerun_clk )
  ,.rst_n                   ( prim_freerun_prim_gated_rst_b_sync )
  ,.data                    ( prochot )
  ,.data_sync               ( prochot_sync_prim )
);

always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    cfg_prochot_disable_sync_0_f         <= '0;
    cfg_prochot_disable_sync_1_f         <= '0;
    prochot_sync_0_f         <= '0;
    prochot_sync_1_f         <= '0;
  end else begin
    cfg_prochot_disable_sync_0_f         <= cfg_prochot_disable_sync_prim ;
    cfg_prochot_disable_sync_1_f         <= cfg_prochot_disable_sync_0_f ;
    prochot_sync_0_f         <= prochot_sync_prim ;
    prochot_sync_1_f         <= prochot_sync_0_f ;
  end
end

assign prochot_deglitch_sync = ( prochot_sync_0_f & prochot_sync_1_f ) &
                               ~( cfg_prochot_disable_sync_0_f & cfg_prochot_disable_sync_1_f ) ;

//------------------------------------------------------------------------------------------------------------------
// Create CFG idle signal 
assign cfg_idle      = { ~cfg_req_ring_active
                       & ~cfg_req_mstr_active
                       &  cfg_cfg2cfg_idle
                       } ;

assign cfg_ring_idle = ~cfg_req_ring_active ;
assign cfg_mstr_idle = ( ~cfg_req_mstr_active & cfg_cfg2cfg_idle );
//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
// Hqm Cfg Master Idle Aggregation - Final level of aggreagtion
// Following master convention, sync the input signal to local clk domain
//
// Master provides a down counter, starting once all idle conditions are reported.
// The purpose is to cover any "gaps" that may be in unit coverage for their unit_idle,
// or between FLR start and propagation ot the reset_dones in the cores.
//
// CFG_CONTROL_GENERAL.CFG_IDLE_CLK_DLY provides hysteresis ivalue, enforced via a counter.
// Once the count reaches the configurable value, the hqm_proc_idle is reported to the IOSF for inclusion in the clk_req signal.
// Overall hqm_proc_idle hysteresis value is set for 128 clks. 
// Partitions locally enforce a hysteresis of 64 clks in their idle signals..
//
hqm_AW_sync_rst1  #(
   .WIDTH                     ( 1 )
) i_hqm_proc_master_unit_idle_sync (

   .clk                       ( prim_freerun_clk )
  ,.rst_n                     ( prim_freerun_prim_gated_rst_b_sync )
  ,.data                      ( hqm_proc_master_unit_idle )
  ,.data_sync                 ( hqm_proc_master_unit_idle_sync_prim )
);

hqm_AW_reset_sync_scan  
 i_hqm_gated_rst_b_sync_prim (
   .clk                       ( prim_freerun_clk )
  ,.rst_n                     ( hqm_gated_rst_b )
  ,.fscan_rstbypen            ( fscan_rstbypen )
  ,.fscan_byprst_b            ( fscan_byprst_b )
  ,.rst_n_sync                ( prim_freerun_hqm_gated_rst_b_sync )
);

// FLR triggers and s.m. are idle
// No active CFG requests in Master or on CFG Ring
// Ppower-gated "proc status" must be masked when power gating
// as well as the rst, which will be asserted (0) when pg
assign hqm_cfg_master_unit_idle = ( flr_clkreq_b 
                                  & cfg_idle
                                  & (( prim_freerun_hqm_gated_rst_b_sync & hqm_proc_master_unit_idle_post_prep) | ~pm_fsm_in_run )
                                  & ~pm_fsm_active 
                                  ) ;

// Any non-idle status sets the count at MAX
// Once all status bits are idle, the count starts
// essentially, hqm_proc_idle = &aggregated_idles after configured hysteresis value 
assign clr_idle_clk_cnt       = ( (~hqm_cfg_master_unit_idle) ) ;
assign idle_clk_cnt_eq_max    = ( idle_clk_cnt_f == cfg_idle_dly ) ;

always_comb begin

  idle_clk_cnt_nxt = idle_clk_cnt_f ;

  case ( {clr_idle_clk_cnt, ~idle_clk_cnt_eq_max} )
     2'b01 : idle_clk_cnt_nxt = ( idle_clk_cnt_f + 16'd1 );
     2'b10 : idle_clk_cnt_nxt = '0 ;
     2'b11 : idle_clk_cnt_nxt = '0 ;
    default: idle_clk_cnt_nxt = idle_clk_cnt_f ;
  endcase

  // Only report idle once the count reaches configured value
  hqm_proc_idle_nxt           = ( idle_clk_cnt_eq_max & cfg_enable_hqm_proc_idle ) ; 

end

always_ff @(posedge prim_gated_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    idle_clk_cnt_f            <= HQM_MSTR_CFG_CONTROL_GENERAL_DEFAULT[15:0] ;

    hqm_proc_idle_f           <= 1'b1;
  end else begin
    idle_clk_cnt_f            <= idle_clk_cnt_nxt ;

    hqm_proc_idle_f           <= hqm_proc_idle_nxt ;
  end
end

//Sync proc_idle to hqm_clk for VISA
hqm_AW_sync_rst1  #(          
   .WIDTH                     ( 1 )
) i_hqm_proc_idle_sync_hqm (
   
   .clk                       ( hqm_inp_gated_clk )
  ,.rst_n                     ( hqm_cdc_hqm_gated_rst_b_sync )
  ,.data                      ( hqm_proc_idle_f )
  ,.data_sync                 ( hqm_proc_idle_f_sync_hqm )
);

// clk request from chp wd
assign hqm_proc_hqm_clkreq_wd_b_pre = ~wd_clkreq; 

// clk request from hqm_proc other than wd
assign hqm_proc_hqm_clkreq_hqm_b_pre = hqm_proc_idle_f &
                                          flr_clkreq_b &
                                        ~pm_fsm_active ;  

// this AW used as way to asynchronously assert the request for clocks by deasert the request synchronously
hqm_AW_reset_sync_scan i_hqm_chp_hqm_clk_rptr_rst_sync_n
      ( .clk             (prim_freerun_clk)
       ,.rst_n           (hqm_proc_hqm_clkreq_wd_b_pre)
       ,.fscan_rstbypen  (fscan_rstbypen)
       ,.fscan_byprst_b  (fscan_byprst_b)
       ,.rst_n_sync       (hqm_proc_hqm_clkreq_wd_b));

// this AW used as way to asynchronously assert the request for clocks by deasert the request synchronously
hqm_AW_reset_sync_scan i_hqm_proc_hqm_clkreq_hqm_b_sync 
      ( .clk            (prim_freerun_clk)
       ,.rst_n          (hqm_proc_hqm_clkreq_hqm_b_pre)
       ,.fscan_rstbypen (fscan_rstbypen)
       ,.fscan_byprst_b (fscan_byprst_b)
       ,.rst_n_sync     (hqm_proc_hqm_clkreq_hqm_b));

assign hqm_proc_clkreq_b     = hqm_proc_hqm_clkreq_wd_b & hqm_proc_hqm_clkreq_hqm_b; 

logic hqm_cfg_master_clkreq_b_f ;
always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    hqm_cfg_master_clkreq_b_f <= 1'b1 ;
  end else begin
    hqm_cfg_master_clkreq_b_f <= hqm_proc_hqm_clkreq_hqm_b_pre ;
  end
end
assign hqm_cfg_master_clkreq_b = hqm_cfg_master_clkreq_b_f ; //For master visa block only

//------------------------------------------------------------------------------------------------------------------
// Create hqm_func_idle that S/W can poll for power sequencing
// Must Not include any local Master Idles that polling can disrupt
// Apply 64 clk hysteresis 

assign hqm_func_unit_idle        = ( cfg_ring_idle
                                   & prim_freerun_hqm_gated_rst_b_sync
                                   & hqm_proc_master_unit_idle_post_prep
                                   ) ;

assign clr_func_idle_clk_cnt       = ( (~hqm_func_unit_idle) ) ;
assign func_idle_clk_cnt_eq_max    = ( func_idle_clk_cnt_f == 6'h3f ) ; 

always_comb begin

  func_idle_clk_cnt_nxt = func_idle_clk_cnt_f ;

  case ( {clr_func_idle_clk_cnt, ~func_idle_clk_cnt_eq_max} )
     2'b01 : func_idle_clk_cnt_nxt = ( func_idle_clk_cnt_f + 6'd1 );
     2'b10 : func_idle_clk_cnt_nxt = '0 ;
     2'b11 : func_idle_clk_cnt_nxt = '0 ;
    default: func_idle_clk_cnt_nxt = func_idle_clk_cnt_f ;
  endcase

  hqm_func_idle = func_idle_clk_cnt_eq_max ;
end

always_ff @(posedge prim_gated_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    func_idle_clk_cnt_f            <= '0 ;
  end else begin
    func_idle_clk_cnt_f            <= func_idle_clk_cnt_nxt ;
  end
end

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
// Reset Done Aggregation synchronous to prim clk domain
// sync the input signal to local clk domain
// Use pre-synced version of hqm_proc_reset_done for IOSF   
// Use hqm clk synced version for the hqm_proc partitions (SYS & CHP)
// Include flrsm state in reset done 
//
hqm_AW_sync_rst0 #(
   .WIDTH                     ( 1 )
) i_hqm_proc_master_reset_done_sync (

   .clk                       ( prim_gated_clk )
  ,.rst_n                     ( prim_freerun_prim_gated_rst_b_sync )
  ,.data                      ( hqm_proc_master_reset_done )
  ,.data_sync                 ( hqm_proc_master_reset_done_sync_prim )
);

// The true reset_done represents ALL hqm_proc PARs and Master logic
// It used to gate interfaces in IOSF,HP,SYS and must not be gated with pmsm_in_run
// This version of reset_done does not factor into the Idle signal
assign hqm_proc_reset_done_nxt = ( flr_clkreq_b & hqm_proc_master_reset_done_post_prep ) ;

always_ff @(posedge prim_gated_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
  if (~prim_freerun_prim_gated_rst_b_sync) begin
    hqm_proc_reset_done_f      <= '0 ;
  end else begin
    hqm_proc_reset_done_f      <= hqm_proc_reset_done_nxt ;
  end
end

hqm_AW_sync_rst0  #(
   .WIDTH                     ( 1 )
) i_hqm_proc_reset_done_sync (

   .clk                       ( hqm_inp_gated_clk )
  ,.rst_n                     ( hqm_cdc_hqm_gated_rst_b_sync )
  ,.data                      ( hqm_proc_reset_done_f )
  ,.data_sync                 ( hqm_proc_reset_done_f_sync_hqm )
);

assign hqm_proc_reset_done          = hqm_proc_reset_done_f ;
assign hqm_proc_reset_done_sync_hqm = hqm_proc_reset_done_f_sync_hqm ;

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
// Config Access to Internal Master Registers
//
// The following must be kept in-sync with generated code
//------------------------------------------------------------------------------------------------------------------
// BEGIN HQM_CFG_ACCESS
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] prim_cfg_req_write ; //I CFG
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] prim_cfg_req_read ; //I CFG
cfg_req_t prim_cfg_req ; //I CFG
logic prim_cfg_rsp_ack ; //O CFG
logic prim_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] prim_cfg_rsp_rdata ; //O CFG
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_clk_cnt_disable_reg_nxt ; //I HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_clk_cnt_disable_reg_f ; //O HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE
logic hqm_mstr_target_cfg_clk_on_cnt_en ; //I HQM_MSTR_TARGET_CFG_CLK_ON_CNT
logic hqm_mstr_target_cfg_clk_on_cnt_clr ; //I HQM_MSTR_TARGET_CFG_CLK_ON_CNT
logic hqm_mstr_target_cfg_clk_on_cnt_clrv ; //I HQM_MSTR_TARGET_CFG_CLK_ON_CNT
logic hqm_mstr_target_cfg_clk_on_cnt_inc ; //I HQM_MSTR_TARGET_CFG_CLK_ON_CNT
logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_clk_on_cnt_count ; //O HQM_MSTR_TARGET_CFG_CLK_ON_CNT
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_control_general_reg_nxt ; //I HQM_MSTR_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_control_general_reg_f ; //O HQM_MSTR_TARGET_CFG_CONTROL_GENERAL
logic hqm_mstr_target_cfg_d3tod0_event_cnt_en ; //I HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT
logic hqm_mstr_target_cfg_d3tod0_event_cnt_clr ; //I HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT
logic hqm_mstr_target_cfg_d3tod0_event_cnt_clrv ; //I HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT
logic hqm_mstr_target_cfg_d3tod0_event_cnt_inc ; //I HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT
logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_d3tod0_event_cnt_count ; //O HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_heartbeat_status ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_idle_status_status ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_reset_status_status ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_status_1_reg_nxt ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_status_1_reg_f ; //O HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1
logic hqm_mstr_target_cfg_diagnostic_status_1_reg_load ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1
logic hqm_mstr_target_cfg_diagnostic_syndrome_capture_v ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME
logic [ ( 31 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_syndrome_capture_data ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_syndrome_syndrome_data ; //I HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_h_reg_nxt ; //I HQM_MSTR_TARGET_CFG_FLR_COUNT_H
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_h_reg_f ; //O HQM_MSTR_TARGET_CFG_FLR_COUNT_H
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_l_reg_nxt ; //I HQM_MSTR_TARGET_CFG_FLR_COUNT_L
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_l_reg_f ; //O HQM_MSTR_TARGET_CFG_FLR_COUNT_L
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_cdc_control_reg_nxt ; //I HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_cdc_control_reg_f ; //O HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_pgcb_control_reg_nxt ; //I HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_pgcb_control_reg_f ; //O HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_mstr_internal_timeout_reg_nxt ; //I HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_mstr_internal_timeout_reg_f ; //O HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_override_reg_nxt ; //I HQM_MSTR_TARGET_CFG_PM_OVERRIDE
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_override_reg_f ; //O HQM_MSTR_TARGET_CFG_PM_OVERRIDE
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_pmcsr_disable_reg_nxt ; //I HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_pmcsr_disable_reg_f ; //O HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_status_status ; //I HQM_MSTR_TARGET_CFG_PM_STATUS
logic hqm_mstr_target_cfg_prochot_cnt_en ; //I HQM_MSTR_TARGET_CFG_PROCHOT_CNT
logic hqm_mstr_target_cfg_prochot_cnt_clr ; //I HQM_MSTR_TARGET_CFG_PROCHOT_CNT
logic hqm_mstr_target_cfg_prochot_cnt_clrv ; //I HQM_MSTR_TARGET_CFG_PROCHOT_CNT
logic hqm_mstr_target_cfg_prochot_cnt_inc ; //I HQM_MSTR_TARGET_CFG_PROCHOT_CNT
logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_prochot_cnt_count ; //O HQM_MSTR_TARGET_CFG_PROCHOT_CNT
logic hqm_mstr_target_cfg_prochot_event_cnt_en ; //I HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT
logic hqm_mstr_target_cfg_prochot_event_cnt_clr ; //I HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT
logic hqm_mstr_target_cfg_prochot_event_cnt_clrv ; //I HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT
logic hqm_mstr_target_cfg_prochot_event_cnt_inc ; //I HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT
logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_prochot_event_cnt_count ; //O HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT
logic hqm_mstr_target_cfg_proc_on_cnt_en ; //I HQM_MSTR_TARGET_CFG_PROC_ON_CNT
logic hqm_mstr_target_cfg_proc_on_cnt_clr ; //I HQM_MSTR_TARGET_CFG_PROC_ON_CNT
logic hqm_mstr_target_cfg_proc_on_cnt_clrv ; //I HQM_MSTR_TARGET_CFG_PROC_ON_CNT
logic hqm_mstr_target_cfg_proc_on_cnt_inc ; //I HQM_MSTR_TARGET_CFG_PROC_ON_CNT
logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_proc_on_cnt_count ; //O HQM_MSTR_TARGET_CFG_PROC_ON_CNT
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_ts_control_reg_nxt ; //I HQM_MSTR_TARGET_CFG_TS_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_ts_control_reg_f ; //O HQM_MSTR_TARGET_CFG_TS_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_unit_version_status ; //I HQM_MSTR_TARGET_CFG_UNIT_VERSION
hqm_cfg_master_register_prim i_hqm_cfg_master_register_prim (
  .prim_gated_clk ( prim_gated_clk ) 
, .prim_freerun_prim_gated_rst_b_sync ( prim_freerun_prim_gated_rst_b_sync ) 
, .rst_prep ( '0 )
, .cfg_req_write ( prim_cfg_req_write )
, .cfg_req_read ( prim_cfg_req_read )
, .cfg_req ( prim_cfg_req )
, .cfg_rsp_ack ( prim_cfg_rsp_ack )
, .cfg_rsp_err ( prim_cfg_rsp_err )
, .cfg_rsp_rdata ( prim_cfg_rsp_rdata )
, .hqm_mstr_target_cfg_clk_cnt_disable_reg_nxt ( hqm_mstr_target_cfg_clk_cnt_disable_reg_nxt )
, .hqm_mstr_target_cfg_clk_cnt_disable_reg_f ( hqm_mstr_target_cfg_clk_cnt_disable_reg_f )
, .hqm_mstr_target_cfg_clk_on_cnt_en ( hqm_mstr_target_cfg_clk_on_cnt_en )
, .hqm_mstr_target_cfg_clk_on_cnt_clr ( hqm_mstr_target_cfg_clk_on_cnt_clr )
, .hqm_mstr_target_cfg_clk_on_cnt_clrv ( hqm_mstr_target_cfg_clk_on_cnt_clrv )
, .hqm_mstr_target_cfg_clk_on_cnt_inc ( hqm_mstr_target_cfg_clk_on_cnt_inc )
, .hqm_mstr_target_cfg_clk_on_cnt_count ( hqm_mstr_target_cfg_clk_on_cnt_count )
, .hqm_mstr_target_cfg_control_general_reg_nxt ( hqm_mstr_target_cfg_control_general_reg_nxt )
, .hqm_mstr_target_cfg_control_general_reg_f ( hqm_mstr_target_cfg_control_general_reg_f )
, .hqm_mstr_target_cfg_d3tod0_event_cnt_en ( hqm_mstr_target_cfg_d3tod0_event_cnt_en )
, .hqm_mstr_target_cfg_d3tod0_event_cnt_clr ( hqm_mstr_target_cfg_d3tod0_event_cnt_clr )
, .hqm_mstr_target_cfg_d3tod0_event_cnt_clrv ( hqm_mstr_target_cfg_d3tod0_event_cnt_clrv )
, .hqm_mstr_target_cfg_d3tod0_event_cnt_inc ( hqm_mstr_target_cfg_d3tod0_event_cnt_inc )
, .hqm_mstr_target_cfg_d3tod0_event_cnt_count ( hqm_mstr_target_cfg_d3tod0_event_cnt_count )
, .hqm_mstr_target_cfg_diagnostic_heartbeat_status ( hqm_mstr_target_cfg_diagnostic_heartbeat_status )
, .hqm_mstr_target_cfg_diagnostic_idle_status_status ( hqm_mstr_target_cfg_diagnostic_idle_status_status )
, .hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status ( hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status )
, .hqm_mstr_target_cfg_diagnostic_reset_status_status ( hqm_mstr_target_cfg_diagnostic_reset_status_status )
, .hqm_mstr_target_cfg_diagnostic_status_1_reg_nxt ( hqm_mstr_target_cfg_diagnostic_status_1_reg_nxt )
, .hqm_mstr_target_cfg_diagnostic_status_1_reg_f ( hqm_mstr_target_cfg_diagnostic_status_1_reg_f )
, .hqm_mstr_target_cfg_diagnostic_status_1_reg_load (  hqm_mstr_target_cfg_diagnostic_status_1_reg_load )
, .hqm_mstr_target_cfg_diagnostic_syndrome_capture_v ( hqm_mstr_target_cfg_diagnostic_syndrome_capture_v )
, .hqm_mstr_target_cfg_diagnostic_syndrome_capture_data ( hqm_mstr_target_cfg_diagnostic_syndrome_capture_data )
, .hqm_mstr_target_cfg_diagnostic_syndrome_syndrome_data ( hqm_mstr_target_cfg_diagnostic_syndrome_syndrome_data )
, .hqm_mstr_target_cfg_flr_count_h_reg_nxt ( hqm_mstr_target_cfg_flr_count_h_reg_nxt )
, .hqm_mstr_target_cfg_flr_count_h_reg_f ( hqm_mstr_target_cfg_flr_count_h_reg_f )
, .hqm_mstr_target_cfg_flr_count_l_reg_nxt ( hqm_mstr_target_cfg_flr_count_l_reg_nxt )
, .hqm_mstr_target_cfg_flr_count_l_reg_f ( hqm_mstr_target_cfg_flr_count_l_reg_f )
, .hqm_mstr_target_cfg_hqm_cdc_control_reg_nxt ( hqm_mstr_target_cfg_hqm_cdc_control_reg_nxt )
, .hqm_mstr_target_cfg_hqm_cdc_control_reg_f ( hqm_mstr_target_cfg_hqm_cdc_control_reg_f )
, .hqm_mstr_target_cfg_hqm_pgcb_control_reg_nxt ( hqm_mstr_target_cfg_hqm_pgcb_control_reg_nxt )
, .hqm_mstr_target_cfg_hqm_pgcb_control_reg_f ( hqm_mstr_target_cfg_hqm_pgcb_control_reg_f )
, .hqm_mstr_target_cfg_mstr_internal_timeout_reg_nxt ( hqm_mstr_target_cfg_mstr_internal_timeout_reg_nxt )
, .hqm_mstr_target_cfg_mstr_internal_timeout_reg_f ( hqm_mstr_target_cfg_mstr_internal_timeout_reg_f )
, .hqm_mstr_target_cfg_pm_override_reg_nxt ( hqm_mstr_target_cfg_pm_override_reg_nxt )
, .hqm_mstr_target_cfg_pm_override_reg_f ( hqm_mstr_target_cfg_pm_override_reg_f )
, .hqm_mstr_target_cfg_pm_pmcsr_disable_reg_nxt ( hqm_mstr_target_cfg_pm_pmcsr_disable_reg_nxt )
, .hqm_mstr_target_cfg_pm_pmcsr_disable_reg_f ( hqm_mstr_target_cfg_pm_pmcsr_disable_reg_f )
, .hqm_mstr_target_cfg_pm_status_status ( hqm_mstr_target_cfg_pm_status_status )
, .hqm_mstr_target_cfg_prochot_cnt_en ( hqm_mstr_target_cfg_prochot_cnt_en )
, .hqm_mstr_target_cfg_prochot_cnt_clr ( hqm_mstr_target_cfg_prochot_cnt_clr )
, .hqm_mstr_target_cfg_prochot_cnt_clrv ( hqm_mstr_target_cfg_prochot_cnt_clrv )
, .hqm_mstr_target_cfg_prochot_cnt_inc ( hqm_mstr_target_cfg_prochot_cnt_inc )
, .hqm_mstr_target_cfg_prochot_cnt_count ( hqm_mstr_target_cfg_prochot_cnt_count )
, .hqm_mstr_target_cfg_prochot_event_cnt_en ( hqm_mstr_target_cfg_prochot_event_cnt_en )
, .hqm_mstr_target_cfg_prochot_event_cnt_clr ( hqm_mstr_target_cfg_prochot_event_cnt_clr )
, .hqm_mstr_target_cfg_prochot_event_cnt_clrv ( hqm_mstr_target_cfg_prochot_event_cnt_clrv )
, .hqm_mstr_target_cfg_prochot_event_cnt_inc ( hqm_mstr_target_cfg_prochot_event_cnt_inc )
, .hqm_mstr_target_cfg_prochot_event_cnt_count ( hqm_mstr_target_cfg_prochot_event_cnt_count )
, .hqm_mstr_target_cfg_proc_on_cnt_en ( hqm_mstr_target_cfg_proc_on_cnt_en )
, .hqm_mstr_target_cfg_proc_on_cnt_clr ( hqm_mstr_target_cfg_proc_on_cnt_clr )
, .hqm_mstr_target_cfg_proc_on_cnt_clrv ( hqm_mstr_target_cfg_proc_on_cnt_clrv )
, .hqm_mstr_target_cfg_proc_on_cnt_inc ( hqm_mstr_target_cfg_proc_on_cnt_inc )
, .hqm_mstr_target_cfg_proc_on_cnt_count ( hqm_mstr_target_cfg_proc_on_cnt_count )
, .hqm_mstr_target_cfg_ts_control_reg_nxt ( hqm_mstr_target_cfg_ts_control_reg_nxt )
, .hqm_mstr_target_cfg_ts_control_reg_f ( hqm_mstr_target_cfg_ts_control_reg_f )
, .hqm_mstr_target_cfg_unit_version_status ( hqm_mstr_target_cfg_unit_version_status )
) ;
// END HQM_CFG_ACCESS
//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
 
//APB 2 CFG 
hqm_cfg_master_sys2cfg i_hqm_cfg_master_sys2cfg (

  .prim_gated_clk              ( prim_gated_clk )
, .prim_gated_rst_b_sync       ( prim_freerun_prim_gated_rst_b_sync )
, .hqm_flr_prep                ( hqm_shields_up )
, .pm_fsm_in_run               ( pm_fsm_in_run )
, .core_reset_done             ( hqm_proc_reset_done ) // Used to hold an APB access received until the proc confirms reset done

, .inj_par_err_rdata           ( cfg_enable_inj_par_err_rdata ) 
, .inj_par_err_wdata           ( cfg_enable_inj_par_err_wdata )
, .inj_par_err_addr            ( cfg_enable_inj_par_err_addr )
, .inj_par_err_req_clr         ( inj_par_err_req_clr )
, .inj_par_err_rsp_clr         ( inj_par_err_rsp_clr )
, .cfg_ignore_pipe_busy        ( cfg_ignore_pipe_busy )
, .cfg_disable_ring_par_ck     ( cfg_disable_ring_par_ck )
, .cfg_disable_pslverr_timeout ( cfg_disable_pslverr_timeout )

, .cfg_req_ring_active         ( cfg_req_ring_active ) // flopped signal (holds unil req completes)
, .cfg_req_mstr_active         ( cfg_req_mstr_active ) //flopped signal (holds until req completes)

, .err_timeout                 ( err_timeout )
, .err_cfg_reqrsp_unsol        ( err_cfg_reqrsp_unsol )
, .err_cfg_protocol            ( err_cfg_protocol )
, .err_cfg_req_up_miss         ( err_cfg_req_up_miss )
, .err_slv_access              ( err_slv_access )
, .err_slv_timeout             ( err_slv_timeout )
, .err_slv_par                 ( err_slv_par )
, .err_cfg_decode              ( err_cfg_decode )
, .err_cfg_decode_par          ( err_cfg_decode_par )
, .err_cfg_req_drop            ( err_cfg_req_drop )

, .puser                       ( puser )
, .psel                        ( psel )
, .pwrite                      ( pwrite )
, .penable                     ( penable )
, .paddr                       ( paddr ) 
, .pwdata                      ( pwdata )

, .pready                      ( pready )
, .pslverr                     ( pslverr )
, .prdata                      ( prdata )
, .prdata_par                  ( prdata_par )

, .cfg_req_internal_write      ( cfg_req_internal_write )
, .cfg_req_internal_read       ( cfg_req_internal_read )
, .cfg_req_internal            ( cfg_req_internal )

, .cfg_rsp_internal_ack        ( cfg_rsp_internal_ack )
, .cfg_rsp_internal            ( cfg_rsp_internal )

, .cfg_req_down_write          ( cfg_req_down_write )
, .cfg_req_down_read           ( cfg_req_down_read )
, .cfg_req_down                ( cfg_req_down )

, .cfg_req_up_write            ( cfg_req_up_write )
, .cfg_req_up_read             ( cfg_req_up_read )
, .cfg_req_up                  ( cfg_req_up )

, .cfg_rsp_up_ack              ( cfg_rsp_up_ack )
, .cfg_rsp_up                  ( cfg_rsp_up )
);

// Master skips the CFG ring portion.  Only uses cfg2cfg to decode the target
hqm_AW_cfg2cfg #(
    .UNIT_ID                 ( HQM_MSTR_CFG_UNIT_ID )
  , .NUM_TGTS                ( HQM_MSTR_CFG_UNIT_NUM_TGTS )
  , .TGT_MAP                 ( HQM_MSTR_CFG_UNIT_TGT_MAP )
) i_hqm_AW_cfg2cfg (
    .clk                     ( prim_gated_clk )
  , .rst_n                   ( prim_freerun_prim_gated_rst_b_sync )
  , .rst_prep                ( '0  )   // Do not let hqm_flr_prep gate Master's internal cfg requests 
                                                  // Need CFG Access to kickoff the PMSM 
  , .cfg_idle                ( cfg_cfg2cfg_idle )

  , .up_cfg_req_write        ( cfg_req_internal_write )
  , .up_cfg_req_read         ( cfg_req_internal_read )
  , .up_cfg_req              ( cfg_req_internal )
  , .up_cfg_rsp_ack          ( cfg_rsp_internal_ack )
  , .up_cfg_rsp              ( cfg_rsp_internal )
 
  , .down_cfg_req_write      ( unit_cfg_req_write )
  , .down_cfg_req_read       ( unit_cfg_req_read )
  , .down_cfg_req            ( unit_cfg_req )
  , .down_cfg_rsp_ack        ( unit_cfg_rsp_ack )
  , .down_cfg_rsp_err        ( unit_cfg_rsp_err )
  , .down_cfg_rsp_rdata      ( unit_cfg_rsp_rdata )
);

hqm_AW_cfg_sc # (
    .MODULE                  ( HQM_MSTR_CFG_NODE_ID )
  , .NUM_CFG_TARGETS         ( HQM_MSTR_CFG_UNIT_NUM_TGTS )
  , .NUM_CFG_ACCESSIBLE_RAM  ( NUM_CFG_ACCESSIBLE_RAM )
) i_hqm_AW_cfg_sc (
    .hqm_gated_clk           ( prim_gated_clk )
  , .hqm_gated_rst_n         ( prim_freerun_prim_gated_rst_b_sync )

  , .unit_cfg_req_write      ( unit_cfg_req_write )
  , .unit_cfg_req_read       ( unit_cfg_req_read )
  , .unit_cfg_req            ( unit_cfg_req )
  , .unit_cfg_rsp_ack        ( unit_cfg_rsp_ack )
  , .unit_cfg_rsp_rdata      ( unit_cfg_rsp_rdata )
  , .unit_cfg_rsp_err        ( unit_cfg_rsp_err )

  , .pfcsr_cfg_req_write     ( prim_cfg_req_write_pre_lock )
  , .pfcsr_cfg_req_read      ( prim_cfg_req_read )
  , .pfcsr_cfg_req           ( prim_cfg_req )
  , .pfcsr_cfg_rsp_ack       ( prim_cfg_rsp_ack_post_lock )
  , .pfcsr_cfg_rsp_err       ( prim_cfg_rsp_err_post_lock )
  , .pfcsr_cfg_rsp_rdata     ( prim_cfg_rsp_rdata_post_lock )

  , .cfg_req_write           ( cfg_req_write_nc )
  , .cfg_req_read            ( cfg_req_read_nc )
  , .cfg_mem_re              ( cfg_mem_re_nc )
  , .cfg_mem_addr            ( cfg_mem_addr_nc )
  , .cfg_mem_minbit          ( cfg_mem_minbit_nc )
  , .cfg_mem_maxbit          ( cfg_mem_maxbit_nc )
  , .cfg_mem_we              ( cfg_mem_we_nc )
  , .cfg_mem_wdata           ( cfg_mem_wdata_nc )
  , .cfg_mem_rdata           ( cfg_mem_rdata_nc )
  , .cfg_mem_ack             ( cfg_mem_ack_nc )
  , .cfg_req_idlepipe        ( cfg_req_idlepipe_nc )
  , .cfg_req_ready           ( cfg_req_ready )

  , .cfg_timout_enable       ( cfg_mstr_internal_timeout.CFG_TIMEOUT_ENABLE )  
  , .cfg_timout_threshold    ( cfg_mstr_internal_timeout.CFG_TIMEOUT_THRESHOLD ) 
) ;
//------------------------------------------------------------------------------------------------------------------
// Locking Mechanism for Subsequent Writes to the pm_pmcsr_disable bit
always_comb begin

  //Default 
  prim_cfg_req_write = prim_cfg_req_write_pre_lock;

  // CFG_PM_PMCSR.DISABLE may be cleared once, and then must remain  cleared until a power-up reset 
  prim_cfg_req_write[HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE]    = ( prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE]    &  cfg_pm_pmcsr_disable.DISABLE ) ;

  // Create the ack response when the writes are blocked
  prim_cfg_rsp_ack_post_lock = ( prim_cfg_rsp_ack  
                               | ( prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE]    & ~cfg_pm_pmcsr_disable.DISABLE ) 
                               ) ;

  //Modification for V25, zero out the rdata 
  prim_cfg_rsp_err_post_lock     = prim_cfg_rsp_err;
  prim_cfg_rsp_rdata_post_lock   = prim_cfg_rsp_rdata;
  if ( prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE]    & ~cfg_pm_pmcsr_disable.DISABLE ) begin
    prim_cfg_rsp_err_post_lock   = 1'b0;
    prim_cfg_rsp_rdata_post_lock = 32'h0000_0000;
  end

  // Create update signals to signal changes in control register values
  // Destination units are responsible for synchronizing the data to their clk-domian (where applicable)
  cfg_hqm_cdc_ctl_v_nxt         = prim_cfg_req_write[HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL] ;
  cfg_hqm_pgcb_ctl_v_nxt        = prim_cfg_req_write[HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL] ;

  prim_cfg_req_4phase_write_nc  = ( cfg_hqm_cdc_ctl_v_nxt
                                  | cfg_hqm_pgcb_ctl_v_nxt
                                  ) ; //debug signal
end

//------------------------------------------------------------------------------------------------------------------
assign cfg_ignore_pipe_busy         = cfg_control_general_f[31];
assign cfg_enable_hqm_proc_idle     = cfg_control_general_f[30]; 
assign cfg_pm_allow_ing_drop        = cfg_control_general_f[29]; 
assign cfg_enable_alarms            = cfg_control_general_f[28];
assign cfg_disable_ring_par_ck      = cfg_control_general_f[27];
assign cfg_enable_inj_par_err_wdata = cfg_control_general_f[26];
assign cfg_enable_inj_par_err_addr  = cfg_control_general_f[25];
assign cfg_enable_inj_par_err_rdata = cfg_control_general_f[24];
assign cfg_disable_pslverr_timeout  = cfg_control_general_f[23];
assign cfg_prochot_disable          = cfg_control_general_f[16];
assign cfg_control_general_f_pnc    = cfg_control_general_f[22:17];
assign cfg_idle_dly                 = cfg_control_general_f[15:0];

assign cfg_control_general_nxt      = { cfg_ignore_pipe_busy
                                      , cfg_enable_hqm_proc_idle
                                      , cfg_pm_allow_ing_drop
                                      , cfg_enable_alarms
                                      , cfg_disable_ring_par_ck
                                      , (cfg_enable_inj_par_err_wdata & ~inj_par_err_req_clr)
                                      , (cfg_enable_inj_par_err_addr  & ~inj_par_err_req_clr)
                                      , (cfg_enable_inj_par_err_rdata & ~inj_par_err_rsp_clr)
                                      , cfg_disable_pslverr_timeout 
                                      , cfg_control_general_f[22:16]
                                      , cfg_idle_dly
                                      };
assign pm_allow_ing_drop            = cfg_pm_allow_ing_drop ;

// H/W and S/W Err Sticky Reg
assign cfg_diagnostic_status_1_nxt  = {  11'd0  
                                       , err_slv_timeout 
                                       , err_slv_access 
                                       , err_cfg_decode
                                       , err_cfg_req_up_miss 
                                       , err_cfg_req_drop 
                                       , 8'd0                 
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_RESERVED7]
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_RESERVED6]
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_RESERVED5]
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_DECODE_PAR]
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_SLV_PAR]
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_CFG_PROTOCOL]
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_CFG_REQRSP_UNSOL]
                                       , enc_err_v[HQM_MSTR_ALARM_ERR_TIMEOUT]     
                                      } ;
assign load_sticky                  = (|cfg_diagnostic_status_1_nxt);

assign cfg_diagnostic_idle_status.HQM_FUNC_IDLE         = hqm_func_idle ;
assign cfg_diagnostic_idle_status.RSVD1                 = '0 ;
assign cfg_diagnostic_idle_status.MSTR_PROC_IDLE_MASKED = ( hqm_proc_master_unit_idle_post_prep | (~pm_fsm_in_run) ) ;
assign cfg_diagnostic_idle_status.MSTR_PROC_IDLE        = hqm_proc_master_unit_idle_post_prep ;
assign cfg_diagnostic_idle_status.MSTR_FLR_CLKREQ_B     = flr_clkreq_b ;
assign cfg_diagnostic_idle_status.MSTR_CFG_MSTR_IDLE    = cfg_mstr_idle ;
assign cfg_diagnostic_idle_status.MSTR_CFG_RING_IDLE    = cfg_ring_idle ;
assign cfg_diagnostic_idle_status.RSVD0                 = '0 ;
assign cfg_diagnostic_idle_status.SYS_UNIT_IDLE         = mstr_proc_idle_status_post_prep.SYS_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.AQED_UNIT_IDLE        = mstr_proc_idle_status_post_prep.AQED_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.DQED_UNIT_IDLE        = mstr_proc_idle_status_post_prep.DQED_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.QED_UNIT_IDLE         = mstr_proc_idle_status_post_prep.QED_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.DP_UNIT_IDLE          = mstr_proc_idle_status_post_prep.DP_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.AP_UNIT_IDLE          = mstr_proc_idle_status_post_prep.AP_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.NALB_UNIT_IDLE        = mstr_proc_idle_status_post_prep.NALB_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.LSP_UNIT_IDLE         = mstr_proc_idle_status_post_prep.LSP_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.ROP_UNIT_IDLE         = mstr_proc_idle_status_post_prep.ROP_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.CHP_UNIT_IDLE         = mstr_proc_idle_status_post_prep.CHP_UNIT_IDLE ;
assign cfg_diagnostic_idle_status.SYS_UNIT_PIPEIDLE     = mstr_proc_idle_status_post_prep.SYS_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.AQED_UNIT_PIPEIDLE    = mstr_proc_idle_status_post_prep.AQED_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.DQED_UNIT_PIPEIDLE    = mstr_proc_idle_status_post_prep.DQED_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.QED_UNIT_PIPEIDLE     = mstr_proc_idle_status_post_prep.QED_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.DP_UNIT_PIPEIDLE      = mstr_proc_idle_status_post_prep.DP_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.AP_UNIT_PIPEIDLE      = mstr_proc_idle_status_post_prep.AP_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.NALB_UNIT_PIPEIDLE    = mstr_proc_idle_status_post_prep.NALB_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.LSP_UNIT_PIPEIDLE     = mstr_proc_idle_status_post_prep.LSP_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.ROP_UNIT_PIPEIDLE     = mstr_proc_idle_status_post_prep.ROP_UNIT_PIPEIDLE ;
assign cfg_diagnostic_idle_status.CHP_UNIT_PIPEIDLE     = mstr_proc_idle_status_post_prep.CHP_UNIT_PIPEIDLE ;

assign cfg_diagnostic_reset_status.HQM_PROC_RESET_DONE  = hqm_proc_reset_done ;
assign cfg_diagnostic_reset_status.RSVD0                = '0 ;
assign cfg_diagnostic_reset_status.FLRSM_STATE          = flrsm_state_sync_prim ;
assign cfg_diagnostic_reset_status.PF_RESET_ACTIVE      = mstr_proc_reset_status_post_prep.PF_RESET_ACTIVE ;
assign cfg_diagnostic_reset_status.SYS_PF_RESET_DONE    = mstr_proc_reset_status_post_prep.SYS_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.AQED_PF_RESET_DONE   = mstr_proc_reset_status_post_prep.AQED_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.DQED_PF_RESET_DONE   = mstr_proc_reset_status_post_prep.DQED_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.QED_PF_RESET_DONE    = mstr_proc_reset_status_post_prep.QED_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.DP_PF_RESET_DONE     = mstr_proc_reset_status_post_prep.DP_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.AP_PF_RESET_DONE     = mstr_proc_reset_status_post_prep.AP_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.NALB_PF_RESET_DONE   = mstr_proc_reset_status_post_prep.NALB_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.LSP_PF_RESET_DONE    = mstr_proc_reset_status_post_prep.LSP_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.ROP_PF_RESET_DONE    = mstr_proc_reset_status_post_prep.ROP_PF_RESET_DONE ;
assign cfg_diagnostic_reset_status.CHP_PF_RESET_DONE    = mstr_proc_reset_status_post_prep.CHP_PF_RESET_DONE ;

assign cfg_diagnostic_lcb_status.RSVD0             = '0 ;
assign cfg_diagnostic_lcb_status.SYS_LCB_ENABLE    = mstr_proc_lcb_status_post_prep.SYS_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.AQED_LCB_ENABLE   = mstr_proc_lcb_status_post_prep.AQED_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.DQED_LCB_ENABLE   = mstr_proc_lcb_status_post_prep.DQED_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.QED_LCB_ENABLE    = mstr_proc_lcb_status_post_prep.QED_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.DP_LCB_ENABLE     = mstr_proc_lcb_status_post_prep.DP_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.AP_LCB_ENABLE     = mstr_proc_lcb_status_post_prep.AP_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.NALB_LCB_ENABLE   = mstr_proc_lcb_status_post_prep.NALB_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.LSP_LCB_ENABLE    = mstr_proc_lcb_status_post_prep.LSP_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.ROP_LCB_ENABLE    = mstr_proc_lcb_status_post_prep.ROP_LCB_ENABLE ;
assign cfg_diagnostic_lcb_status.CHP_LCB_ENABLE    = mstr_proc_lcb_status_post_prep.CHP_LCB_ENABLE ;

assign hqm_mstr_target_cfg_flr_count_l_reg_nxt  = cfg_flr_count[31:0] ; 
assign hqm_mstr_target_cfg_flr_count_h_reg_nxt  = cfg_flr_count[63:32] ; 
assign hqm_mstr_target_cfg_flr_count_l_reg_f_nc = hqm_mstr_target_cfg_flr_count_l_reg_f ;
assign hqm_mstr_target_cfg_flr_count_h_reg_f_nc = hqm_mstr_target_cfg_flr_count_h_reg_f ;

assign hqm_mstr_target_cfg_control_general_reg_nxt = cfg_control_general_nxt ;
assign cfg_control_general_f = hqm_mstr_target_cfg_control_general_reg_f ;

assign cfg_ts_div = hqm_mstr_target_cfg_ts_control_reg_f[15:0] ;
assign cfg_ts_nc  = hqm_mstr_target_cfg_ts_control_reg_f[31:16] ;
assign hqm_mstr_target_cfg_ts_control_reg_nxt = hqm_mstr_target_cfg_ts_control_reg_f ;

assign hqm_mstr_target_cfg_hqm_cdc_control_reg_nxt = hqm_mstr_target_cfg_hqm_cdc_control_reg_f;

assign hqm_mstr_target_cfg_hqm_pgcb_control_reg_nxt = hqm_mstr_target_cfg_hqm_pgcb_control_reg_f;

assign hqm_mstr_target_cfg_pm_override_reg_nxt = {31'd0,hqm_mstr_target_cfg_pm_override_reg_f[0]};

assign hqm_mstr_target_cfg_pm_pmcsr_disable_reg_nxt = {31'd0, hqm_mstr_target_cfg_pm_pmcsr_disable_reg_f[0]};

logic [4:0] timeout_nc;
assign hqm_mstr_target_cfg_mstr_internal_timeout_reg_nxt = {hqm_mstr_target_cfg_mstr_internal_timeout_reg_f[31:5],5'd31};
assign cfg_mstr_internal_timeout = {hqm_mstr_target_cfg_mstr_internal_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_mstr_target_cfg_mstr_internal_timeout_reg_f[4:0];


localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_mstr_target_cfg_unit_version_status = cfg_unit_version;

// Following Master convention, inputs are synced to local clk before use 
// PM Status does not follow convention.  PGCB clk sources are synced to prim internally, then sent over as one bus
assign hqm_mstr_target_cfg_pm_status_status = cfg_pm_status;  

hqm_AW_sync #(
  .WIDTH     ( ($bits(mstr_proc_reset_status_t)) )
) i_cfg_reset_status_sync (
  .clk       ( prim_gated_clk )
 ,.data      ( mstr_proc_reset_status )
 ,.data_sync ( mstr_proc_reset_status_sync_prim )
);
assign hqm_mstr_target_cfg_diagnostic_reset_status_status = cfg_diagnostic_reset_status ;

hqm_AW_sync #(
  .WIDTH     ( ($bits(mstr_proc_idle_status_t)) )
) i_cfg_idle_status_sync (
  .clk       ( prim_gated_clk )
 ,.data      ( mstr_proc_idle_status )
 ,.data_sync ( mstr_proc_idle_status_sync_prim )
);
assign hqm_mstr_target_cfg_diagnostic_idle_status_status  = cfg_diagnostic_idle_status ;


hqm_AW_sync #(
  .WIDTH     ( ($bits(mstr_proc_lcb_status_t)) )
) i_cfg_lcb_status_sync (
  .clk       ( prim_gated_clk )
 ,.data      ( mstr_proc_lcb_status )
 ,.data_sync ( mstr_proc_lcb_status_sync_prim )
);
assign hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status = cfg_diagnostic_lcb_status;

assign hqm_mstr_target_cfg_diagnostic_syndrome_capture_v    = syndrome_capture_v ;
assign hqm_mstr_target_cfg_diagnostic_syndrome_capture_data = syndrome_capture_data ;
assign syndrome_data_nc = hqm_mstr_target_cfg_diagnostic_syndrome_syndrome_data ;

assign hqm_mstr_target_cfg_diagnostic_status_1_reg_nxt   = cfg_diagnostic_status_1_nxt ;
assign cfg_diagnostic_status_1_f_pnc                     = hqm_mstr_target_cfg_diagnostic_status_1_reg_f ;
assign hqm_mstr_target_cfg_diagnostic_status_1_reg_load  = load_sticky ;

// Service Availability Counters
assign hqm_mstr_target_cfg_clk_cnt_disable_reg_nxt  = hqm_mstr_target_cfg_clk_cnt_disable_reg_f ;
assign cfg_clk_cnt_disable = hqm_mstr_target_cfg_clk_cnt_disable_reg_f;

assign prochot_nxt                                  = prochot_deglitch_sync ;
assign hqm_mstr_target_cfg_prochot_cnt_inc          = prochot_f;
assign hqm_mstr_target_cfg_prochot_cnt_en           = ~cfg_clk_cnt_disable.DISABLE ;
assign hqm_mstr_target_cfg_prochot_cnt_clr          = 1'b0 ;
assign hqm_mstr_target_cfg_prochot_cnt_clrv         = 1'b0 ;
assign hqm_mstr_target_cfg_prochot_cnt_nc           = hqm_mstr_target_cfg_prochot_cnt_count ;

assign hqm_mstr_target_cfg_d3tod0_event_cnt_inc     = cfg_d3tod0_event_cnt_inc;
assign hqm_mstr_target_cfg_d3tod0_event_cnt_en      = ~cfg_clk_cnt_disable.DISABLE ;
assign hqm_mstr_target_cfg_d3tod0_event_cnt_clr     = 1'b0 ;
assign hqm_mstr_target_cfg_d3tod0_event_cnt_clrv    = 1'b0 ;
assign hqm_mstr_target_cfg_d3tod0_event_cnt_nc      = hqm_mstr_target_cfg_d3tod0_event_cnt_count ;

assign hqm_mstr_target_cfg_prochot_event_cnt_inc    = ( prochot_nxt & ~prochot_f ) ;
assign hqm_mstr_target_cfg_prochot_event_cnt_en     = ~cfg_clk_cnt_disable.DISABLE ;
assign hqm_mstr_target_cfg_prochot_event_cnt_clr    = 1'b0 ;
assign hqm_mstr_target_cfg_prochot_event_cnt_clrv   = 1'b0 ;
assign hqm_mstr_target_cfg_prochot_event_cnt_nc     = hqm_mstr_target_cfg_prochot_event_cnt_count ;

assign hqm_mstr_target_cfg_proc_on_cnt_inc          = pm_fsm_in_run ;
assign hqm_mstr_target_cfg_proc_on_cnt_en           = ~cfg_clk_cnt_disable.DISABLE ;
assign hqm_mstr_target_cfg_proc_on_cnt_clr          = 1'b0 ;
assign hqm_mstr_target_cfg_proc_on_cnt_clrv         = 1'b0 ;
assign hqm_mstr_target_cfg_proc_on_cnt_nc           = hqm_mstr_target_cfg_proc_on_cnt_count ;

assign hqm_mstr_target_cfg_clk_on_cnt_inc           = 1'b1 ; 
assign hqm_mstr_target_cfg_clk_on_cnt_en            = ~cfg_clk_cnt_disable.DISABLE ;
assign hqm_mstr_target_cfg_clk_on_cnt_clr           = 1'b0 ;
assign hqm_mstr_target_cfg_clk_on_cnt_clrv          = 1'b0 ;
assign hqm_mstr_target_cfg_clk_on_cnt_nc            = hqm_mstr_target_cfg_clk_on_cnt_count ;

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
// Heartbeat Status logic

mstr_heartbeat_status_reg_t mstr_heartbeat_status;

// hqm_cdc_clk
// hqm_gated_rst_b
logic hqm_cdc_pgcb_force_rst_b_sync;
logic [3:0] hqm_cdc_clk_cnt_f,hqm_cdc_clk_cnt_nxt;
logic [3:0] hqm_cdc_clk_cnt_f_sync;
logic [3:0] hqm_cdc_clk_cnt_f_sync_post_prot;
logic hqm_gated_rst_b_f;
logic [3:0] hqm_gated_rst_b_cnt_f, hqm_gated_rst_b_cnt_nxt;
logic [3:0] hqm_gated_rst_b_cnt_f_sync;
logic [3:0] hqm_gated_rst_b_cnt_f_sync_post_prot;

hqm_AW_reset_sync_scan i_hqm_cdc_pgcb_force_rst_b_sync (

   .clk                     ( hqm_cdc_clk )
  ,.rst_n                   ( pgcb_force_rst_b )
  ,.fscan_rstbypen          ( fscan_rstbypen )
  ,.fscan_byprst_b          ( fscan_byprst_b )
  ,.rst_n_sync              ( hqm_cdc_pgcb_force_rst_b_sync )
); 

assign hqm_cdc_clk_cnt_nxt[0]     = ~hqm_cdc_clk_cnt_f[3] ;
assign hqm_cdc_clk_cnt_nxt[1]     =  hqm_cdc_clk_cnt_f[0] ;
assign hqm_cdc_clk_cnt_nxt[2]     =  hqm_cdc_clk_cnt_f[1] ;
assign hqm_cdc_clk_cnt_nxt[3]     =  hqm_cdc_clk_cnt_f[2] ;
 
assign hqm_gated_rst_b_cnt_nxt[0] = ~hqm_gated_rst_b_cnt_f[3] ;
assign hqm_gated_rst_b_cnt_nxt[1] =  hqm_gated_rst_b_cnt_f[0] ;
assign hqm_gated_rst_b_cnt_nxt[2] =  hqm_gated_rst_b_cnt_f[1] ;
assign hqm_gated_rst_b_cnt_nxt[3] =  hqm_gated_rst_b_cnt_f[2] ;


always_ff @(posedge hqm_cdc_clk or negedge hqm_cdc_pgcb_force_rst_b_sync) begin
 if (~hqm_cdc_pgcb_force_rst_b_sync) begin
   hqm_cdc_clk_cnt_f          <= '0;
   hqm_gated_rst_b_f          <= '0;
   hqm_gated_rst_b_cnt_f      <= '0;
 end else begin 
   hqm_cdc_clk_cnt_f[0]       <= hqm_cdc_clk_cnt_nxt[0] ;
   hqm_cdc_clk_cnt_f[1]       <= hqm_cdc_clk_cnt_nxt[1] ;
   hqm_cdc_clk_cnt_f[2]       <= hqm_cdc_clk_cnt_nxt[2] ;
   hqm_cdc_clk_cnt_f[3]       <= hqm_cdc_clk_cnt_nxt[3] ;

   hqm_gated_rst_b_f          <= hqm_cdc_hqm_gated_rst_b_sync | hqm_flr_prep ;

   if ( (hqm_cdc_hqm_gated_rst_b_sync | hqm_flr_prep) & (~hqm_gated_rst_b_f) ) begin
     hqm_gated_rst_b_cnt_f[0] <= hqm_gated_rst_b_cnt_nxt[0] ;
     hqm_gated_rst_b_cnt_f[1] <= hqm_gated_rst_b_cnt_nxt[1] ;
     hqm_gated_rst_b_cnt_f[2] <= hqm_gated_rst_b_cnt_nxt[2] ;
     hqm_gated_rst_b_cnt_f[3] <= hqm_gated_rst_b_cnt_nxt[3] ;
   end

 end
end

hqm_AW_sync #( 
  .WIDTH     ( 4 )
) i_hqm_cdc_clk_cnt_f_sync (
  .clk       ( prim_gated_clk )
 ,.data      ( hqm_cdc_clk_cnt_f )
 ,.data_sync ( hqm_cdc_clk_cnt_f_sync )
);

assign hqm_cdc_clk_cnt_f_sync_post_prot = (hqm_shields_up) ? 4'hf : hqm_cdc_clk_cnt_f_sync ;

hqm_AW_sync #( 
  .WIDTH     ( 4 )
) i_hqm_gated_rst_b_cnt_f_sync (
  .clk       ( prim_gated_clk )
 ,.data      ( hqm_gated_rst_b_cnt_f )
 ,.data_sync ( hqm_gated_rst_b_cnt_f_sync )
);

assign hqm_gated_rst_b_cnt_f_sync_post_prot = (hqm_shields_up) ? 4'hf : hqm_gated_rst_b_cnt_f_sync ;

// hqm_inp_gated_clk
logic [3:0] hqm_inp_gated_clk_cnt_f,hqm_inp_gated_clk_cnt_nxt;
logic [3:0] hqm_inp_gated_clk_cnt_f_sync;
logic [3:0] hqm_inp_gated_clk_cnt_f_sync_post_prot;

assign hqm_inp_gated_clk_cnt_nxt[0] = ~hqm_inp_gated_clk_cnt_f[3] ;
assign hqm_inp_gated_clk_cnt_nxt[1] =  hqm_inp_gated_clk_cnt_f[0] ;
assign hqm_inp_gated_clk_cnt_nxt[2] =  hqm_inp_gated_clk_cnt_f[1] ;
assign hqm_inp_gated_clk_cnt_nxt[3] =  hqm_inp_gated_clk_cnt_f[2] ;

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_cdc_pgcb_force_rst_b_sync) begin
 if (~hqm_cdc_pgcb_force_rst_b_sync) begin
   hqm_inp_gated_clk_cnt_f <= '0;
 end else begin
   hqm_inp_gated_clk_cnt_f[0] <= hqm_inp_gated_clk_cnt_nxt[0] ;
   hqm_inp_gated_clk_cnt_f[1] <= hqm_inp_gated_clk_cnt_nxt[1] ;
   hqm_inp_gated_clk_cnt_f[2] <= hqm_inp_gated_clk_cnt_nxt[2] ;
   hqm_inp_gated_clk_cnt_f[3] <= hqm_inp_gated_clk_cnt_nxt[3] ;
 end
end

hqm_AW_sync #(
  .WIDTH     ( 4 )
) i_hqm_inp_gated_clk_cnt_f_sync (
  .clk       ( prim_gated_clk )
 ,.data      ( hqm_inp_gated_clk_cnt_f )
 ,.data_sync ( hqm_inp_gated_clk_cnt_f_sync )
);

assign hqm_inp_gated_clk_cnt_f_sync_post_prot = (hqm_shields_up) ? 4'hf : hqm_inp_gated_clk_cnt_f_sync ;

// pgcb_clk
logic pgcb_prim_gated_rst_b_sync;
logic [3:0] pgcb_clk_cnt_f;
logic [3:0] pgcb_clk_cnt_f_sync;

hqm_AW_reset_sync_scan i_pgcb_prim_gated_rst_b_sync (
   
   .clk                     ( pgcb_clk )
  ,.rst_n                   ( prim_gated_rst_b )
  ,.fscan_rstbypen          ( fscan_rstbypen )
  ,.fscan_byprst_b          ( fscan_byprst_b )
  ,.rst_n_sync              ( pgcb_prim_gated_rst_b_sync )
);

always_ff @(posedge pgcb_clk or negedge pgcb_prim_gated_rst_b_sync) begin
 if (~pgcb_prim_gated_rst_b_sync) begin
   pgcb_clk_cnt_f <= '0;
 end else begin
   pgcb_clk_cnt_f[0] <= ~pgcb_clk_cnt_f[3] ;
   pgcb_clk_cnt_f[1] <=  pgcb_clk_cnt_f[0] ;
   pgcb_clk_cnt_f[2] <=  pgcb_clk_cnt_f[1] ;
   pgcb_clk_cnt_f[3] <=  pgcb_clk_cnt_f[2] ;
 end
end

hqm_AW_sync #(
  .WIDTH     ( 4 )
) i_pgcb_clk_cnt_f_sync (
  .clk       ( prim_gated_clk )
 ,.data      ( pgcb_clk_cnt_f )
 ,.data_sync ( pgcb_clk_cnt_f_sync )
);

// flr_triggered
// flr_prep
logic flr_triggered_f; 
logic [3:0] flr_triggered_cnt_f; 
logic flr_prep_f;
logic [3:0] flr_prep_cnt_f;
 
always_ff @(posedge prim_gated_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
 if (~prim_freerun_prim_gated_rst_b_sync) begin
   flr_triggered_f                <= '0;
   flr_prep_f                     <= '0;
   
   flr_triggered_cnt_f            <= '0;
   flr_prep_cnt_f                 <= '0;

 end else begin
   flr_triggered_f                <= flr_triggered;
   flr_prep_f                     <= hqm_shields_up;

   if ( flr_triggered & (~flr_triggered_f) ) begin 
     flr_triggered_cnt_f[0]       <= ~flr_triggered_cnt_f[3];
     flr_triggered_cnt_f[1]       <=  flr_triggered_cnt_f[0];
     flr_triggered_cnt_f[2]       <=  flr_triggered_cnt_f[1];
     flr_triggered_cnt_f[3]       <=  flr_triggered_cnt_f[2];
   end


  if ( hqm_shields_up & (~flr_prep_f) ) begin
     flr_prep_cnt_f[0]            <= ~flr_prep_cnt_f[3];
     flr_prep_cnt_f[1]            <=  flr_prep_cnt_f[0];
     flr_prep_cnt_f[2]            <=  flr_prep_cnt_f[1];
     flr_prep_cnt_f[3]            <=  flr_prep_cnt_f[2];
  end

 end
end


assign mstr_heartbeat_status.CONSTANT            = 4'b1100 ;
assign mstr_heartbeat_status.PGCB_CLK            = pgcb_clk_cnt_f_sync ;
assign mstr_heartbeat_status.HQM_CDC_CLK         = hqm_cdc_clk_cnt_f_sync_post_prot ;
assign mstr_heartbeat_status.HQM_INP_GATED_CLK   = hqm_inp_gated_clk_cnt_f_sync_post_prot ;
assign mstr_heartbeat_status.FLR_TRIGGERED       = flr_triggered_cnt_f ;
assign mstr_heartbeat_status.RSVD0               = '0 ;
assign mstr_heartbeat_status.HQM_FLR_PREP        = flr_prep_cnt_f ;
assign mstr_heartbeat_status.HQM_GATED_RST_B     = hqm_gated_rst_b_cnt_f_sync_post_prot ;

assign hqm_mstr_target_cfg_diagnostic_heartbeat_status = mstr_heartbeat_status;

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------

// Drive outputs to master sub-modules for clk domain crossng sync
assign cfg_hqm_cdc_ctl            = hqm_mstr_target_cfg_hqm_cdc_control_reg_f ;
assign cfg_hqm_cdc_ctl_v          = cfg_hqm_cdc_ctl_v_f;
assign cfg_hqm_pgcb_ctl           = hqm_mstr_target_cfg_hqm_pgcb_control_reg_f ; 
assign cfg_hqm_pgcb_ctl_v         = cfg_hqm_pgcb_ctl_v_f;
assign cfg_pm_override            = hqm_mstr_target_cfg_pm_override_reg_f ;
assign cfg_pm_pmcsr_disable       = hqm_mstr_target_cfg_pm_pmcsr_disable_reg_f ;

// Flop the valids to align with the data being sent over
always_ff @(posedge prim_gated_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
 if (~prim_freerun_prim_gated_rst_b_sync) begin
   cfg_hqm_cdc_ctl_v_f            <= '0; 
   cfg_hqm_pgcb_ctl_v_f           <= '0; 

   prochot_f                      <= '0;
 end else begin  
   cfg_hqm_cdc_ctl_v_f            <= cfg_hqm_cdc_ctl_v_nxt;           
   cfg_hqm_pgcb_ctl_v_f           <= cfg_hqm_pgcb_ctl_v_nxt;

   prochot_f                      <= prochot_nxt;
 end
end

//------------------------------------------------------------------------------------------------------------------
// Syndrome Registers
// map the INFO ALARM Bus based on parameterizable location
//
logic  [ ( HQM_MSTR_ALARM_NUM_INF-3 ) -1:0] cfg_err_v ;
assign cfg_err_v[HQM_MSTR_ALARM_ERR_TIMEOUT]          = (cfg_enable_alarms & err_timeout) ;
assign cfg_err_v[HQM_MSTR_ALARM_ERR_CFG_REQRSP_UNSOL] = (cfg_enable_alarms & err_cfg_reqrsp_unsol) ;
assign cfg_err_v[HQM_MSTR_ALARM_ERR_CFG_PROTOCOL]     = (cfg_enable_alarms & err_cfg_protocol) ;
assign cfg_err_v[HQM_MSTR_ALARM_ERR_SLV_PAR]          = (cfg_enable_alarms & err_slv_par) ;
assign cfg_err_v[HQM_MSTR_ALARM_ERR_DECODE_PAR]       = (cfg_enable_alarms & err_cfg_decode_par) ;

assign enc_err_v[HQM_MSTR_ALARM_ERR_TIMEOUT]          = cfg_err_v[HQM_MSTR_ALARM_ERR_TIMEOUT] ;
assign enc_err_v[HQM_MSTR_ALARM_ERR_CFG_REQRSP_UNSOL] = cfg_err_v[HQM_MSTR_ALARM_ERR_CFG_REQRSP_UNSOL] ;
assign enc_err_v[HQM_MSTR_ALARM_ERR_CFG_PROTOCOL]     = cfg_err_v[HQM_MSTR_ALARM_ERR_CFG_PROTOCOL] ;
assign enc_err_v[HQM_MSTR_ALARM_ERR_SLV_PAR]          = cfg_err_v[HQM_MSTR_ALARM_ERR_SLV_PAR] ;
assign enc_err_v[HQM_MSTR_ALARM_ERR_DECODE_PAR]       = cfg_err_v[HQM_MSTR_ALARM_ERR_DECODE_PAR] ;
assign enc_err_v[HQM_MSTR_ALARM_ERR_RESERVED5]        = '0 ;
assign enc_err_v[HQM_MSTR_ALARM_ERR_RESERVED6]        = '0 ;
assign enc_err_v[HQM_MSTR_ALARM_ERR_RESERVED7]        = '0 ;

hqm_AW_binenc #(
 .WIDTH(HQM_MSTR_ALARM_NUM_INF)
) i_aw_binenc (
         .a             (enc_err_v)
        ,.enc           (cfg_syndrome_err_enc)
        ,.any           (cfg_syndrome_err_any)
); 

always_comb begin
  
  syndrome_capture_v = '0;
  syndrome_capture_data = '0; 
  cfg_syndrome_rsp_uid_nxt = cfg_syndrome_rsp_uid_f;
  cfg_syndrome_addr_nxt = cfg_syndrome_addr_f;

  if ( cfg_req_down_write | cfg_req_down_read ) begin 
    
    cfg_syndrome_addr_nxt = {cfg_req_down.addr.node,cfg_req_down.addr.target,2'd0,cfg_req_down.addr.mode};
    
  end
  if ( cfg_req_internal_write | cfg_req_internal_read ) begin 
    
    cfg_syndrome_addr_nxt = {cfg_req_internal.addr.node,cfg_req_internal.addr.target,2'd0,cfg_req_internal.addr.mode};
    
  end

  if ( cfg_rsp_up_ack ) begin
    cfg_syndrome_rsp_uid_nxt = cfg_rsp_up.uid;
  end
  if ( cfg_req_up_write & ~(err_cfg_reqrsp_unsol | err_cfg_req_up_miss)) begin 
    cfg_syndrome_rsp_uid_nxt = HQM_MSTR_CFG_UNIT_ID[$bits(cfg_rsp_up.uid)-1:0];
  end

  if ( cfg_syndrome_err_any ) begin
    syndrome_capture_v                                  = 1'b1 ;
    syndrome_capture_data                               = { cfg_syndrome_rsp_uid_f[3:0]
                                                          , cfg_syndrome_err_enc[2:0]
                                                          , cfg_syndrome_addr_f[23:0]
                                                          } ;
  end
end // always_comb

always_ff @(posedge prim_gated_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
 if (~prim_freerun_prim_gated_rst_b_sync) begin
   cfg_syndrome_addr_f <= 24'b0;
   cfg_syndrome_rsp_uid_f <= 4'b0;
 end else begin
   cfg_syndrome_addr_f <= cfg_syndrome_addr_nxt;
   cfg_syndrome_rsp_uid_f <= cfg_syndrome_rsp_uid_nxt;
 end
end

//--------------------------------------------------------------------------------------------
// Master - CHP Timestamp
// cfg_ts_div provided by TS_CONTROL register
// 
// Divided count is binary timestamp. Converted to gray code. Flopped on prim_gated_clk
// Gray code is synchronized hqm_inp_gated_clk and passed to hqm_credit_hist_pipe.
// CHP will synchronously capture, convert to binary and use for QE timestamping

always_comb begin

  timestamp_nxt             = timestamp_f ;
  ts_cnt_nxt                = ( ts_cnt_f + 16'd1 ) ; 

  if ( ts_cnt_f == cfg_ts_div ) begin
    ts_cnt_nxt              = '0 ;
    timestamp_nxt           = ( timestamp_f + 16'd1 ) ;
  end
 
end

always_ff @(posedge prim_gated_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
 if (~prim_freerun_prim_gated_rst_b_sync) begin
   timestamp_f              <= '0 ;
   ts_cnt_f                 <= '0 ;

   tsgray_f                 <= '0 ;
 end else begin
   timestamp_f              <= timestamp_nxt ;
   ts_cnt_f                 <= ts_cnt_nxt ;

   tsgray_f                 <= tsgray_nxt ;
 end
end

hqm_AW_bin2gray #(
   .WIDTH                   ( 16 )
) i_bin2gray_mstr_chp_timestamp (

   .binary                  ( timestamp_f )
  ,.gray                    ( tsgray_nxt )

);

hqm_AW_sync  #(
   .WIDTH                   ( 16 )
) i_tsgray_sync (
   
   .clk                     ( hqm_inp_gated_clk )
  ,.data                    ( tsgray_f )
 
  ,.data_sync               ( tsgray_sync_hqm )
);

assign master_chp_timestamp = tsgray_sync_hqm ;

//--------------------------------------------------------------------------------------------
endmodule //hqm_cfg_master

