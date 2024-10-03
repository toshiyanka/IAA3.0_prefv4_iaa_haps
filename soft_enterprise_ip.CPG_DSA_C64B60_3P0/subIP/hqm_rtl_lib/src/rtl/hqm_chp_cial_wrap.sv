//-----------------------------------------------------------------------------------------------------
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// hqm_credit_hist_pipe
//
// TKM 0.3
//
//-----------------------------------------------------------------------------------------------------

module hqm_chp_cial_wrap
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
#(
   parameter HQM_NUM_DIR_CQ = 64
  ,parameter HQM_NUM_LDB_CQ = 64
  ,parameter HQM_CQ_TIM_WIDTH_INTERVAL = 8
  ,parameter HQM_CQ_TIM_WIDTH_THRESHOLD = 14
  ,parameter HQM_CQ_TIM_TYPE = 0 // 0-int timer
  // derived
  ,parameter HQM_NUM_DIR_CQ_B2 = (AW_logb2 ( HQM_NUM_DIR_CQ -1 ) + 1)
  ,parameter HQM_NUM_LDB_CQ_B2 = (AW_logb2 ( HQM_NUM_LDB_CQ -1 ) + 1)

 ) (
   input  logic                                      hqm_gated_clk
 , input  logic                                      hqm_gated_rst_n

 , input  logic                                      rst_prep
                                                     
 , input  cq_int_info_t                              enq_dir_excep
 , input  cq_int_info_t                              sch_dir_excep

 , input  logic  [ HQM_NUM_DIR_CQ-1 : 0 ]            cfg_dir_cq_int_mask
 , input  logic  [ HQM_NUM_LDB_CQ-1 : 0 ]            cfg_ldb_cq_int_mask       
                                                     
 , input  logic  [ HQM_NUM_DIR_CQ-1 : 0 ]            cfg_hqm_chp_int_armed_dir
 , input  logic  [ HQM_NUM_DIR_CQ-1: 0 ]             cfg_int_en_depth_dir
 , input  logic  [ HQM_NUM_DIR_CQ-1: 0 ]             cfg_int_en_tim_dir
                                                     
 , output logic [ HQM_NUM_DIR_CQ-1 : 0 ]             hqm_chp_int_armed_dir
                                                     
 , output logic [ HQM_NUM_DIR_CQ-1 : 0 ]             hqm_chp_int_urgent_dir
 , output logic [ HQM_NUM_DIR_CQ-1 : 0 ]             hqm_chp_int_expired_dir

 , output logic [ HQM_NUM_DIR_CQ-1 : 0 ]             hqm_chp_int_run_dir
 , output logic [ HQM_NUM_DIR_CQ-1 : 0 ]             hqm_chp_int_irq_dir 
                                                     
 , input  cq_int_info_t                              enq_ldb_excep
 , input  cq_int_info_t                              sch_ldb_excep


 , input  logic  [ HQM_NUM_LDB_CQ-1 : 0 ]            cfg_hqm_chp_int_armed_ldb
 , input  logic  [ HQM_NUM_LDB_CQ-1: 0 ]             cfg_int_en_depth_ldb
 , input  logic  [ HQM_NUM_LDB_CQ-1: 0 ]             cfg_int_en_tim_ldb
                                                     
 , output logic [ HQM_NUM_LDB_CQ-1 : 0 ]             hqm_chp_int_urgent_ldb
 , output logic [ HQM_NUM_LDB_CQ-1 : 0 ]             hqm_chp_int_expired_ldb
 , output logic [ HQM_NUM_LDB_CQ-1 : 0 ]             hqm_chp_int_armed_ldb
 , output logic [ HQM_NUM_LDB_CQ-1 : 0 ]             hqm_chp_int_run_ldb
 , output logic [ HQM_NUM_LDB_CQ-1 : 0 ]             hqm_chp_int_irq_ldb 
                                                     
 , input  logic                                      idle_cial_timer_report_control
                                                     
 , output logic                                      smon_thresh_irq_dir
 , output logic                                      smon_thresh_irq_ldb
 , output logic                                      smon_timer_irq_dir
 , output logic                                      smon_timer_irq_ldb
                                                     
 , output logic                                      load_cg_dir
 , output logic                                      load_cg_ldb
                                                     
 , input  logic                                      cfg_cial_clock_gate_control
 , input  logic                                      hqm_chp_int_dir_cg_f
 , input  logic                                      hqm_chp_int_ldb_cg_f
                                                     
, output interrupt_w_req_t                           interrupt_w_req
, output logic                                       interrupt_w_req_valid
, input  logic                                       interrupt_w_req_ready

 // dir timer connections
 , output logic                                      func_count_rmw_pipe_dir_mem_we
 , output logic [HQM_NUM_DIR_CQ_B2-1:0]              func_count_rmw_pipe_dir_mem_waddr
 , output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_dir_mem_wdata
 , output logic                                      func_count_rmw_pipe_dir_mem_re
 , output logic [HQM_NUM_DIR_CQ_B2-1:0]              func_count_rmw_pipe_dir_mem_raddr
 , input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_dir_mem_rdata

 , output logic                                      func_threshold_r_pipe_dir_mem_we
 , output logic                                      func_threshold_r_pipe_dir_mem_re
 , output logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     func_threshold_r_pipe_dir_mem_wdata
 , output logic [HQM_NUM_DIR_CQ_B2-1:0]              func_threshold_r_pipe_dir_mem_addr
 , input  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     func_threshold_r_pipe_dir_mem_rdata

 , output  logic [31:0]                              hqm_chp_int_tim_pipe_status_dir_pnc 
 , input   logic [31:0]                              hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f 
 , input   logic                                     cfg_access_idle_req_dir
 , output  logic                                     hqm_chp_tim_pipe_idle_dir

 // ldb timer connections
 , output logic                                      func_count_rmw_pipe_ldb_mem_we
 , output logic [HQM_NUM_LDB_CQ_B2-1:0]              func_count_rmw_pipe_ldb_mem_waddr
 , output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_ldb_mem_wdata
 , output logic                                      func_count_rmw_pipe_ldb_mem_re
 , output logic [HQM_NUM_LDB_CQ_B2-1:0]              func_count_rmw_pipe_ldb_mem_raddr
 , input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_ldb_mem_rdata

 , output logic                                      func_threshold_r_pipe_ldb_mem_we
 , output logic                                      func_threshold_r_pipe_ldb_mem_re
 , output logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     func_threshold_r_pipe_ldb_mem_wdata
 , output logic [HQM_NUM_LDB_CQ_B2-1:0]              func_threshold_r_pipe_ldb_mem_addr
 , input  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     func_threshold_r_pipe_ldb_mem_rdata

 , output  logic [31:0]                              hqm_chp_int_tim_pipe_status_ldb_pnc 
 , input   logic [31:0]                              hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f 
 , input   logic                                     cfg_access_idle_req_ldb
 , output  logic                                     hqm_chp_tim_pipe_idle_ldb

 , input   logic                                     cfg_hqm_chp_int_armed_dir_cg_f
 , input   logic                                     cfg_hqm_chp_int_armed_ldb_cg_f

 , output  logic                                      hqm_chp_int_idle

 , output  logic                                      cial_tx_sync_idle 

 , output  logic [6:0]                                cial_tx_sync_status_pnc

 , output  logic                                      cq_timer_threshold_parity_err_dir
 , output  logic                                      cq_timer_threshold_parity_err_ldb

 , output  logic                                      sch_excep_parity_check_err_dir
 , output  logic                                      sch_excep_parity_check_err_ldb

);

logic [ HQM_NUM_DIR_CQ-1 : 0 ]                        clear_cq_timer_ack_dir ;
logic [ HQM_NUM_DIR_CQ-1 : 0 ]                        clear_cq_timer_dir ;
logic [ HQM_NUM_DIR_CQ-1 : 0 ]                        hqm_chp_tim_expiry_dir ;
logic                                                 hqm_chp_tim_expiry_v_dir ;
                                                      
logic [ HQM_NUM_LDB_CQ-1 : 0 ]                        clear_cq_timer_ack_ldb ;
logic [ HQM_NUM_LDB_CQ-1 : 0 ]                        clear_cq_timer_ldb ;
logic [ HQM_NUM_LDB_CQ-1 : 0 ]                        hqm_chp_tim_expiry_ldb ;
logic                                                 hqm_chp_tim_expiry_v_ldb ;
                                                      
logic [HQM_NUM_DIR_CQ_B2-1:0]                         irq_winner_dir ;
logic [HQM_NUM_LDB_CQ_B2-1:0]                         irq_winner_ldb ;
logic                                                 irq_winner_v_dir ;
logic                                                 irq_winner_v_ldb ;
logic                                                 irq_winner_v ;
logic                                                 irq_winner ;

logic [ HQM_NUM_DIR_CQ-1 : 0 ]                        hqm_chp_int_irq_dir_arb_reqs ;
logic [ HQM_NUM_LDB_CQ-1 : 0 ]                        hqm_chp_int_irq_ldb_arb_reqs ;
 
logic                                                 hqm_chp_int_irq_active_dir ;
logic                                                 hqm_chp_int_irq_active_ldb ;
logic                                                 irq_update_dir;
logic                                                 irq_update_ldb;
logic                                                 irq_update;
                                                      
logic                                                 cial_tx_sync_in_valid;
interrupt_w_req_t                                     cial_tx_sync_in_data;
logic                                                 cial_tx_sync_in_ready;

logic [ HQM_NUM_DIR_CQ-1 : 0 ]                        hqm_chp_int_arm_timer_dir;
logic [ HQM_NUM_LDB_CQ-1 : 0 ]                        hqm_chp_int_arm_timer_ldb;
logic                                                 global_hqm_chp_tim_dir_enable;
logic                                                 global_hqm_chp_tim_ldb_enable;

logic                                                 interrupt_w_req_parity;

assign global_hqm_chp_tim_dir_enable = hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f[HQM_CQ_TIM_WIDTH_INTERVAL];
assign global_hqm_chp_tim_ldb_enable = hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f[HQM_CQ_TIM_WIDTH_INTERVAL];

hqm_chp_int # (
  .HQM_CQ_INT_NUM_CQ ( HQM_NUM_DIR_CQ )
) i_hqm_chp_int_dir (
  .clk                       (hqm_gated_clk)
, .rst_n                     (hqm_gated_rst_n)

, .enq_excep                 (enq_dir_excep)
, .sch_excep                 (sch_dir_excep)

, .irq                       (hqm_chp_int_irq_dir)
, .irq_update                (irq_update_dir)
, .irq_cq                    (irq_winner_dir) 

, .expiry                    (hqm_chp_tim_expiry_dir)
, .expiry_v                  (hqm_chp_tim_expiry_v_dir)

, .armed                     (hqm_chp_int_armed_dir)
, .arm_timer                 (hqm_chp_int_arm_timer_dir)
, .cfg_arm                   (cfg_hqm_chp_int_armed_dir)
, .cfg_arm_cg                (cfg_hqm_chp_int_armed_dir_cg_f)
, .run                       (hqm_chp_int_run_dir)
, .expired                   (hqm_chp_int_expired_dir)
, .urgent                    (hqm_chp_int_urgent_dir)

, .cfg_int_en_tim            (cfg_int_en_tim_dir )
, .cfg_int_en_depth          (cfg_int_en_depth_dir ) 

, .irq_active                (hqm_chp_int_irq_active_dir )

, .smon_timer_irq            (smon_timer_irq_dir )
, .smon_thresh_irq           (smon_thresh_irq_dir )

, .idle_timer_report_control (idle_cial_timer_report_control ) // 1'b1 - impacts unit idle due to active timer, 1'b0-does not impact unit idle

, .load_cg                   (load_cg_dir )

, .clear_cq_timer            (clear_cq_timer_dir )
, .clear_cq_timer_ack        (clear_cq_timer_ack_dir )

, .cfg_cial_clock_gate_control ( cfg_cial_clock_gate_control )

, .cfg_load_cg               (hqm_chp_int_dir_cg_f )

, .sch_excep_parity_check_err (sch_excep_parity_check_err_dir)

, .global_hqm_chp_tim_enable  (global_hqm_chp_tim_dir_enable)
) ;

logic [14:0]  cfg_tim_threshold_unused;
assign cfg_tim_threshold_unused = '0;

hqm_chp_tim # (
   .HQM_NUM_TIM_CQ ( HQM_NUM_DIR_CQ )
 , .HQM_CQ_TIM_WIDTH_INTERVAL ( 8 )
 , .HQM_CQ_TIM_WIDTH_THRESHOLD ( 14 )
 , .HQM_CQ_TIM_TYPE ( HQM_CQ_TIM_TYPE ) // 0-int timer, 1-wd timer (wd timer has only 1 threshold
) i_hqm_chp_tim_dir (
    .clk                             (hqm_gated_clk)
  , .rst_n                           (hqm_gated_rst_n)
  , .enb                             (hqm_chp_int_arm_timer_dir)
  , .run                             (hqm_chp_int_run_dir)
  , .clr                             (clear_cq_timer_dir)
  , .expiry                          (hqm_chp_tim_expiry_dir)
  , .expiry_v                        (hqm_chp_tim_expiry_v_dir)
  , .ack                             (clear_cq_timer_ack_dir)

  , .func_count_rmw_pipe_mem_we      (func_count_rmw_pipe_dir_mem_we)
  , .func_count_rmw_pipe_mem_waddr   (func_count_rmw_pipe_dir_mem_waddr)
  , .func_count_rmw_pipe_mem_wdata   (func_count_rmw_pipe_dir_mem_wdata)
  , .func_count_rmw_pipe_mem_re      (func_count_rmw_pipe_dir_mem_re)
  , .func_count_rmw_pipe_mem_raddr   (func_count_rmw_pipe_dir_mem_raddr)
  , .func_count_rmw_pipe_mem_rdata   (func_count_rmw_pipe_dir_mem_rdata)

  , .func_threshold_r_pipe_mem_we    (func_threshold_r_pipe_dir_mem_we)
  , .func_threshold_r_pipe_mem_addr  (func_threshold_r_pipe_dir_mem_addr)
  , .func_threshold_r_pipe_mem_wdata (func_threshold_r_pipe_dir_mem_wdata)
  , .func_threshold_r_pipe_mem_re    (func_threshold_r_pipe_dir_mem_re)
  , .func_threshold_r_pipe_mem_rdata (func_threshold_r_pipe_dir_mem_rdata)

  , .pipe_status                     (hqm_chp_int_tim_pipe_status_dir_pnc)

  , .cfg_tim_threshold               (cfg_tim_threshold_unused) // I
  , .cfg_tim                         (hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f) // I
  , .cfg_access_idle_req             (cfg_access_idle_req_dir) //
  , .hqm_chp_tim_pipe_idle           (hqm_chp_tim_pipe_idle_dir) // O
  , .cq_timer_threshold_parity_err   (cq_timer_threshold_parity_err_dir)

) ;


hqm_chp_int # (
  .HQM_CQ_INT_NUM_CQ ( HQM_NUM_LDB_CQ )
) i_hqm_chp_int_ldb (
  .clk                       (hqm_gated_clk)
, .rst_n                     (hqm_gated_rst_n)

, .enq_excep                 (enq_ldb_excep)
, .sch_excep                 (sch_ldb_excep)

, .irq                       (hqm_chp_int_irq_ldb)
, .irq_update                (irq_update_ldb )
, .irq_cq                    (irq_winner_ldb )

, .expiry                    (hqm_chp_tim_expiry_ldb)
, .expiry_v                  (hqm_chp_tim_expiry_v_ldb)

, .armed                     (hqm_chp_int_armed_ldb)
, .arm_timer                 (hqm_chp_int_arm_timer_ldb)
, .cfg_arm                   (cfg_hqm_chp_int_armed_ldb)
, .cfg_arm_cg                (cfg_hqm_chp_int_armed_ldb_cg_f)
, .run                       (hqm_chp_int_run_ldb)
, .expired                   (hqm_chp_int_expired_ldb)
, .urgent                    (hqm_chp_int_urgent_ldb)

, .cfg_int_en_tim            (cfg_int_en_tim_ldb)
, .cfg_int_en_depth          (cfg_int_en_depth_ldb)

, .irq_active                (hqm_chp_int_irq_active_ldb)

, .smon_timer_irq            (smon_timer_irq_ldb)
, .smon_thresh_irq           (smon_thresh_irq_ldb)

, .idle_timer_report_control (idle_cial_timer_report_control) // 1'b1 - impacts unit idle due to active timer, 1'b0-does not impact unit idle

, .load_cg                   (load_cg_ldb)      

, .clear_cq_timer            (clear_cq_timer_ldb)
, .clear_cq_timer_ack        (clear_cq_timer_ack_ldb)

, .cfg_cial_clock_gate_control (cfg_cial_clock_gate_control)

, .cfg_load_cg               (hqm_chp_int_ldb_cg_f)

, .sch_excep_parity_check_err (sch_excep_parity_check_err_ldb)

, .global_hqm_chp_tim_enable  (global_hqm_chp_tim_ldb_enable)

) ;


hqm_chp_tim # (
   .HQM_NUM_TIM_CQ ( HQM_NUM_LDB_CQ )
 , .HQM_CQ_TIM_WIDTH_INTERVAL ( 8 )
 , .HQM_CQ_TIM_WIDTH_THRESHOLD ( 14 )
 , .HQM_CQ_TIM_TYPE ( HQM_CQ_TIM_TYPE ) // 0-int timer, 1-wd timer (wd timer has only 1 threshold
) i_hqm_chp_tim_ldb (
    .clk                             (hqm_gated_clk)
  , .rst_n                           (hqm_gated_rst_n)
  , .enb                             (hqm_chp_int_arm_timer_ldb)
  , .run                             (hqm_chp_int_run_ldb)
  , .clr                             (clear_cq_timer_ldb)
  , .expiry                          (hqm_chp_tim_expiry_ldb)
  , .expiry_v                        (hqm_chp_tim_expiry_v_ldb)
  , .ack                             (clear_cq_timer_ack_ldb)

  , .func_count_rmw_pipe_mem_we      (func_count_rmw_pipe_ldb_mem_we)
  , .func_count_rmw_pipe_mem_waddr   (func_count_rmw_pipe_ldb_mem_waddr)
  , .func_count_rmw_pipe_mem_wdata   (func_count_rmw_pipe_ldb_mem_wdata)
  , .func_count_rmw_pipe_mem_re      (func_count_rmw_pipe_ldb_mem_re)
  , .func_count_rmw_pipe_mem_raddr   (func_count_rmw_pipe_ldb_mem_raddr)
  , .func_count_rmw_pipe_mem_rdata   (func_count_rmw_pipe_ldb_mem_rdata)

  , .func_threshold_r_pipe_mem_we    (func_threshold_r_pipe_ldb_mem_we)
  , .func_threshold_r_pipe_mem_addr  (func_threshold_r_pipe_ldb_mem_addr)
  , .func_threshold_r_pipe_mem_wdata (func_threshold_r_pipe_ldb_mem_wdata)
  , .func_threshold_r_pipe_mem_re    (func_threshold_r_pipe_ldb_mem_re)
  , .func_threshold_r_pipe_mem_rdata (func_threshold_r_pipe_ldb_mem_rdata)

  , .pipe_status                     (hqm_chp_int_tim_pipe_status_ldb_pnc)

  , .cfg_tim_threshold               (cfg_tim_threshold_unused) // I
  , .cfg_tim                         (hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f) // I
  , .cfg_access_idle_req             (cfg_access_idle_req_ldb) //
  , .hqm_chp_tim_pipe_idle           (hqm_chp_tim_pipe_idle_ldb) // O

  , .cq_timer_threshold_parity_err   (cq_timer_threshold_parity_err_ldb)

) ;

hqm_AW_rr_arb # (
  .NUM_REQS  ( HQM_NUM_LDB_CQ )
) i_irq_rr_arb_ldb (
  .clk           (hqm_gated_clk)
, .rst_n         (hqm_gated_rst_n)
, .reqs          (hqm_chp_int_irq_ldb_arb_reqs)
, .update        (irq_update_ldb)
, .winner_v      (irq_winner_v_ldb)
, .winner        (irq_winner_ldb)
) ;


hqm_AW_rr_arb # (
  .NUM_REQS  ( HQM_NUM_DIR_CQ )
) i_irq_rr_arb_dir (
  .clk           (hqm_gated_clk)
, .rst_n         (hqm_gated_rst_n)
, .reqs          (hqm_chp_int_irq_dir_arb_reqs)
, .update        (irq_update_dir)
, .winner_v      (irq_winner_v_dir)
, .winner        (irq_winner_dir)
) ;

hqm_AW_rr_arb # (
  .NUM_REQS  ( 2 )
) i_irq_rr_arb_dir_ldb (
  .clk           (hqm_gated_clk)
, .rst_n         (hqm_gated_rst_n)
, .reqs          ({irq_winner_v_dir,irq_winner_v_ldb})
, .update        (irq_update)
, .winner_v      (irq_winner_v)
, .winner        (irq_winner)
) ;

assign irq_update_ldb = (irq_update & irq_winner_v & ~irq_winner) ; // ldb
assign irq_update_dir = (irq_update & irq_winner_v &  irq_winner) ; // dir

always_comb begin

      irq_update = 1'b0 ;
      cial_tx_sync_in_valid = '0;
      cial_tx_sync_in_data.cq_occ_cq = irq_update_ldb ? {1'b0,irq_winner_ldb} : irq_winner_dir;
      cial_tx_sync_in_data.is_ldb = irq_update_ldb ;
      cial_tx_sync_in_data.parity = interrupt_w_req_parity;

      if (cial_tx_sync_in_ready & irq_winner_v) begin
        irq_update = 1'b1 ;
        cial_tx_sync_in_valid = 1'b1;  
      end

end

hqm_AW_parity_gen # (
  .WIDTH ( $bits(cial_tx_sync_in_data.is_ldb) + $bits(cial_tx_sync_in_data.cq_occ_cq) )
) i_interrupt_w_req_parity_gen (
  .d								( {cial_tx_sync_in_data.is_ldb, cial_tx_sync_in_data.cq_occ_cq} )
, .odd								( 1'b1 )
, .p								( interrupt_w_req_parity )
) ;

hqm_AW_tx_sync # (
    .WIDTH                              ( $bits (cial_tx_sync_in_data) )
  ) i_tx_sync_cial (
    .hqm_gated_clk                      (hqm_gated_clk)
  , .hqm_gated_rst_n                    (hqm_gated_rst_n)
  , .status                             (cial_tx_sync_status_pnc)
  , .idle                               (cial_tx_sync_idle)
  , .rst_prep                           (rst_prep)
  , .in_valid                           (cial_tx_sync_in_valid)
  , .in_ready                           (cial_tx_sync_in_ready)
  , .in_data                            (cial_tx_sync_in_data)
  , .out_valid                          (interrupt_w_req_valid)
  , .out_ready                          (interrupt_w_req_ready)
  , .out_data                           (interrupt_w_req)
) ;

assign hqm_chp_int_irq_ldb_arb_reqs = hqm_chp_int_irq_ldb & ( ~ cfg_ldb_cq_int_mask ) ;
assign hqm_chp_int_irq_dir_arb_reqs = hqm_chp_int_irq_dir & ( ~ cfg_dir_cq_int_mask ) ;

assign hqm_chp_int_idle = (~ ((|hqm_chp_int_irq_ldb ) | (|hqm_chp_int_irq_dir ) | hqm_chp_int_irq_active_dir | hqm_chp_int_irq_active_ldb)) & cial_tx_sync_idle ;

endmodule // hqm_credit_hist_pipe_core
