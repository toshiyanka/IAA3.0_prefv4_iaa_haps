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
// hqm_credit_hist_pipe performs the following 3 major functions:
//
//  1. Maintains credit count per producer port (pp) and pool and validate input request (qid and credit check). 
//     An input request needs at least 1 credit, otherwise it is an error. If the qid and credit check are ok, 
//     the credit manager grabs a free list address (from a 32k load balance or 8k direct type) and sends the 
//     request to the history list module for further processing. As requests are being processed by the hqm, 
//     credits are returned: 1 at a time for either direct and/or load balance type to the credit pool. 
//     From the credit pool, credit manager replenish the pp when the pp needs more credit.
//  2. Producer port (pp) Credit replenishment. When an input request uses a credit, the new credit count is 
//     compared against a low WM. If it falls below the low WM, the credit manager sets a bit for that pp to 
//     indicate that it needs credit service. Credit manager does round robin arbitration to select a pp for 
//     credit service among all the pp. A quanta of credit is given to a pp from a credit pool which the pp 
//     belongs to and credit service is done when a new push pointer is sent to the hqm_system.  
//  3. Credit manager receives cq requests from qeD, dqeD and aqeD and sends outbound hcw to hqm_system. 
//     Credit manager maintains set of cq write pointers and cq depth counts. Credit manager is responsible for 
//     insertion of the generation (toggle when cq pointer wrap) and qid depth bit in the outbound hcw. 
//     From the cq depth count state, credit manager sends interrupt to the hqm_system.
//
//
//-----------------------------------------------------------------------------------------------------
module hqm_credit_hist_pipe
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(

    input  logic hqm_gated_clk
  , input  logic hqm_inp_gated_clk
  , output logic hqm_proc_clk_en_chp
  , input  logic hqm_rst_prep_chp
  , input  logic hqm_gated_rst_b_chp
  , input  logic hqm_inp_gated_rst_b_chp

  , input  logic hqm_pgcb_clk 
  , input  logic hqm_pgcb_rst_b_chp
  , input  logic hqm_pgcb_rst_b_start_chp 

  , input  logic hqm_gated_rst_b_start_chp
  , input  logic hqm_gated_rst_b_active_chp
  , output logic hqm_gated_rst_b_done_chp

, input logic rop_unit_idle
, input logic rop_clk_idle
, output logic rop_clk_enable


, input  logic [ ( 16 ) - 1 : 0]        master_chp_timestamp

, input  logic                          hqm_proc_reset_done
                                        
, output logic                          chp_unit_idle
, output logic                          chp_unit_pipeidle
, output logic                          chp_reset_done
                                        
// CFG interface                        
, input  logic                          chp_cfg_req_up_read
, input  logic                          chp_cfg_req_up_write
, input  logic [BITS_CFG_REQ_T-1:0]     chp_cfg_req_up
, input  logic                          chp_cfg_rsp_up_ack
, input  logic [BITS_CFG_RSP_T-1:0]     chp_cfg_rsp_up
, output logic                          chp_cfg_req_down_read
, output logic                          chp_cfg_req_down_write
, output logic [BITS_CFG_REQ_T-1:0]     chp_cfg_req_down
, output logic                          chp_cfg_rsp_down_ack
, output logic [BITS_CFG_RSP_T-1:0]     chp_cfg_rsp_down
                                        
// interrupt interface                  
, input  logic                          chp_alarm_up_v
, output logic                          chp_alarm_up_ready
, input  logic [BITS_AW_ALARM_T-1:0]    chp_alarm_up_data
                                        
, output logic                          chp_alarm_down_v
, input  logic                          chp_alarm_down_ready
, output logic [BITS_AW_ALARM_T-1:0]    chp_alarm_down_data
                                        
// HCW Enqueue in AXI interface        
, input  logic [BITS_HCW_ENQ_W_REQ_T-1:0]  hcw_enq_w_req
, input  logic                          hcw_enq_w_req_valid
, output logic                          hcw_enq_w_req_ready

// HCW Scheudle out AXI interface
, output logic [BITS_HCW_SCHED_W_REQ_T-1:0]    hcw_sched_w_req
, output logic                          hcw_sched_w_req_valid
, input  logic                          hcw_sched_w_req_ready

// Interrupt write AXI interface
, output logic [BITS_INTERRUPT_W_REQ_T-1:0]    interrupt_w_req
, output logic                          interrupt_w_req_valid
, input  logic                          interrupt_w_req_ready

, output logic                          cwdi_interrupt_w_req_valid
, input  logic                          cwdi_interrupt_w_req_ready

// chp_rop_hcw interface
, output logic                          chp_rop_hcw_v
, input  logic                          chp_rop_hcw_ready
, output logic [BITS_CHP_ROP_HCW_T-1:0]    chp_rop_hcw_data
                                        
// chp lsp PALB (Power Aware Load Balancing) interface                
, output logic [HQM_NUM_LB_CQ-1:0]      chp_lsp_ldb_cq_off

// chp_lsp_cmp interface                
, output logic                          chp_lsp_cmp_v
, input  logic                          chp_lsp_cmp_ready
, output logic [BITS_CHP_LSP_CMP_T-1:0]    chp_lsp_cmp_data
                                        
// chp_lsp_token interface              
, output logic                          chp_lsp_token_v
, input  logic                          chp_lsp_token_ready
, output logic [BITS_CHP_LSP_TOKEN_T-1:0]  chp_lsp_token_data
                                        
// qed_chp_sch interface                
, input  logic                          qed_chp_sch_v
, output logic                          qed_chp_sch_ready
, input  logic [BITS_QED_CHP_SCH_T-1:0]    qed_chp_sch_data
                                        
// aqed_chp_sch interface               
, input  logic                          aqed_chp_sch_v
, output logic                          aqed_chp_sch_ready
, input  logic [BITS_AQED_CHP_SCH_T-1:0]   aqed_chp_sch_data

// visa interface
, output logic                          visa_str_chp_lsp_cmp_data

, output logic                          wd_clkreq

// BEGIN HQM_MEMPORT_DECL hqm_credit_hist_pipe_core
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_re
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_rclk
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_aqed_chp_sch_rx_sync_mem_raddr
    ,output logic [(       2)-1:0] rf_aqed_chp_sch_rx_sync_mem_waddr
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_we
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_wclk
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n
    ,output logic [(     179)-1:0] rf_aqed_chp_sch_rx_sync_mem_wdata
    ,input  logic [(     179)-1:0] rf_aqed_chp_sch_rx_sync_mem_rdata

    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_re
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_rclk
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_chp_chp_rop_hcw_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_chp_chp_rop_hcw_fifo_mem_waddr
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_we
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_wclk
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,output logic [(     201)-1:0] rf_chp_chp_rop_hcw_fifo_mem_wdata
    ,input  logic [(     201)-1:0] rf_chp_chp_rop_hcw_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_re
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_we
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      74)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_wdata
    ,input  logic [(      74)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_tok_fifo_mem_re
    ,output logic                  rf_chp_lsp_tok_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_tok_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_chp_lsp_tok_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_chp_lsp_tok_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_tok_fifo_mem_we
    ,output logic                  rf_chp_lsp_tok_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_tok_fifo_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_chp_lsp_tok_fifo_mem_wdata
    ,input  logic [(      29)-1:0] rf_chp_lsp_tok_fifo_mem_rdata

    ,output logic                  rf_chp_sys_tx_fifo_mem_re
    ,output logic                  rf_chp_sys_tx_fifo_mem_rclk
    ,output logic                  rf_chp_sys_tx_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_chp_sys_tx_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_chp_sys_tx_fifo_mem_waddr
    ,output logic                  rf_chp_sys_tx_fifo_mem_we
    ,output logic                  rf_chp_sys_tx_fifo_mem_wclk
    ,output logic                  rf_chp_sys_tx_fifo_mem_wclk_rst_n
    ,output logic [(     200)-1:0] rf_chp_sys_tx_fifo_mem_wdata
    ,input  logic [(     200)-1:0] rf_chp_sys_tx_fifo_mem_rdata

    ,output logic                  rf_cmp_id_chk_enbl_mem_re
    ,output logic                  rf_cmp_id_chk_enbl_mem_rclk
    ,output logic                  rf_cmp_id_chk_enbl_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cmp_id_chk_enbl_mem_raddr
    ,output logic [(       6)-1:0] rf_cmp_id_chk_enbl_mem_waddr
    ,output logic                  rf_cmp_id_chk_enbl_mem_we
    ,output logic                  rf_cmp_id_chk_enbl_mem_wclk
    ,output logic                  rf_cmp_id_chk_enbl_mem_wclk_rst_n
    ,output logic [(       2)-1:0] rf_cmp_id_chk_enbl_mem_wdata
    ,input  logic [(       2)-1:0] rf_cmp_id_chk_enbl_mem_rdata

    ,output logic                  rf_count_rmw_pipe_dir_mem_re
    ,output logic                  rf_count_rmw_pipe_dir_mem_rclk
    ,output logic                  rf_count_rmw_pipe_dir_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_dir_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_dir_mem_waddr
    ,output logic                  rf_count_rmw_pipe_dir_mem_we
    ,output logic                  rf_count_rmw_pipe_dir_mem_wclk
    ,output logic                  rf_count_rmw_pipe_dir_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_count_rmw_pipe_dir_mem_wdata
    ,input  logic [(      16)-1:0] rf_count_rmw_pipe_dir_mem_rdata

    ,output logic                  rf_count_rmw_pipe_ldb_mem_re
    ,output logic                  rf_count_rmw_pipe_ldb_mem_rclk
    ,output logic                  rf_count_rmw_pipe_ldb_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_ldb_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_ldb_mem_waddr
    ,output logic                  rf_count_rmw_pipe_ldb_mem_we
    ,output logic                  rf_count_rmw_pipe_ldb_mem_wclk
    ,output logic                  rf_count_rmw_pipe_ldb_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_count_rmw_pipe_ldb_mem_wdata
    ,input  logic [(      16)-1:0] rf_count_rmw_pipe_ldb_mem_rdata

    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_re
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_rclk
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_dir_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_dir_mem_waddr
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_we
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_wclk
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_count_rmw_pipe_wd_dir_mem_wdata
    ,input  logic [(      10)-1:0] rf_count_rmw_pipe_wd_dir_mem_rdata

    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_re
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_rclk
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_ldb_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_ldb_mem_waddr
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_we
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_wclk
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_count_rmw_pipe_wd_ldb_mem_wdata
    ,input  logic [(      10)-1:0] rf_count_rmw_pipe_wd_ldb_mem_rdata

    ,output logic                  rf_dir_cq_depth_re
    ,output logic                  rf_dir_cq_depth_rclk
    ,output logic                  rf_dir_cq_depth_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_depth_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_depth_waddr
    ,output logic                  rf_dir_cq_depth_we
    ,output logic                  rf_dir_cq_depth_wclk
    ,output logic                  rf_dir_cq_depth_wclk_rst_n
    ,output logic [(      13)-1:0] rf_dir_cq_depth_wdata
    ,input  logic [(      13)-1:0] rf_dir_cq_depth_rdata

    ,output logic                  rf_dir_cq_intr_thresh_re
    ,output logic                  rf_dir_cq_intr_thresh_rclk
    ,output logic                  rf_dir_cq_intr_thresh_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_intr_thresh_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_intr_thresh_waddr
    ,output logic                  rf_dir_cq_intr_thresh_we
    ,output logic                  rf_dir_cq_intr_thresh_wclk
    ,output logic                  rf_dir_cq_intr_thresh_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_cq_intr_thresh_wdata
    ,input  logic [(      15)-1:0] rf_dir_cq_intr_thresh_rdata

    ,output logic                  rf_dir_cq_token_depth_select_re
    ,output logic                  rf_dir_cq_token_depth_select_rclk
    ,output logic                  rf_dir_cq_token_depth_select_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_token_depth_select_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_token_depth_select_waddr
    ,output logic                  rf_dir_cq_token_depth_select_we
    ,output logic                  rf_dir_cq_token_depth_select_wclk
    ,output logic                  rf_dir_cq_token_depth_select_wclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_token_depth_select_wdata
    ,input  logic [(       6)-1:0] rf_dir_cq_token_depth_select_rdata

    ,output logic                  rf_dir_cq_wptr_re
    ,output logic                  rf_dir_cq_wptr_rclk
    ,output logic                  rf_dir_cq_wptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_wptr_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_wptr_waddr
    ,output logic                  rf_dir_cq_wptr_we
    ,output logic                  rf_dir_cq_wptr_wclk
    ,output logic                  rf_dir_cq_wptr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_dir_cq_wptr_wdata
    ,input  logic [(      13)-1:0] rf_dir_cq_wptr_rdata

    ,output logic                  rf_hcw_enq_w_rx_sync_mem_re
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_rclk
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_hcw_enq_w_rx_sync_mem_raddr
    ,output logic [(       4)-1:0] rf_hcw_enq_w_rx_sync_mem_waddr
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_we
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_wclk
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_wclk_rst_n
    ,output logic [(     160)-1:0] rf_hcw_enq_w_rx_sync_mem_wdata
    ,input  logic [(     160)-1:0] rf_hcw_enq_w_rx_sync_mem_rdata

    ,output logic                  rf_hist_list_a_minmax_re
    ,output logic                  rf_hist_list_a_minmax_rclk
    ,output logic                  rf_hist_list_a_minmax_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_a_minmax_raddr
    ,output logic [(       6)-1:0] rf_hist_list_a_minmax_waddr
    ,output logic                  rf_hist_list_a_minmax_we
    ,output logic                  rf_hist_list_a_minmax_wclk
    ,output logic                  rf_hist_list_a_minmax_wclk_rst_n
    ,output logic [(      30)-1:0] rf_hist_list_a_minmax_wdata
    ,input  logic [(      30)-1:0] rf_hist_list_a_minmax_rdata

    ,output logic                  rf_hist_list_a_ptr_re
    ,output logic                  rf_hist_list_a_ptr_rclk
    ,output logic                  rf_hist_list_a_ptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_a_ptr_raddr
    ,output logic [(       6)-1:0] rf_hist_list_a_ptr_waddr
    ,output logic                  rf_hist_list_a_ptr_we
    ,output logic                  rf_hist_list_a_ptr_wclk
    ,output logic                  rf_hist_list_a_ptr_wclk_rst_n
    ,output logic [(      32)-1:0] rf_hist_list_a_ptr_wdata
    ,input  logic [(      32)-1:0] rf_hist_list_a_ptr_rdata

    ,output logic                  rf_hist_list_minmax_re
    ,output logic                  rf_hist_list_minmax_rclk
    ,output logic                  rf_hist_list_minmax_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_minmax_raddr
    ,output logic [(       6)-1:0] rf_hist_list_minmax_waddr
    ,output logic                  rf_hist_list_minmax_we
    ,output logic                  rf_hist_list_minmax_wclk
    ,output logic                  rf_hist_list_minmax_wclk_rst_n
    ,output logic [(      30)-1:0] rf_hist_list_minmax_wdata
    ,input  logic [(      30)-1:0] rf_hist_list_minmax_rdata

    ,output logic                  rf_hist_list_ptr_re
    ,output logic                  rf_hist_list_ptr_rclk
    ,output logic                  rf_hist_list_ptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_ptr_raddr
    ,output logic [(       6)-1:0] rf_hist_list_ptr_waddr
    ,output logic                  rf_hist_list_ptr_we
    ,output logic                  rf_hist_list_ptr_wclk
    ,output logic                  rf_hist_list_ptr_wclk_rst_n
    ,output logic [(      32)-1:0] rf_hist_list_ptr_wdata
    ,input  logic [(      32)-1:0] rf_hist_list_ptr_rdata

    ,output logic                  rf_ldb_cq_depth_re
    ,output logic                  rf_ldb_cq_depth_rclk
    ,output logic                  rf_ldb_cq_depth_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_depth_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_depth_waddr
    ,output logic                  rf_ldb_cq_depth_we
    ,output logic                  rf_ldb_cq_depth_wclk
    ,output logic                  rf_ldb_cq_depth_wclk_rst_n
    ,output logic [(      13)-1:0] rf_ldb_cq_depth_wdata
    ,input  logic [(      13)-1:0] rf_ldb_cq_depth_rdata

    ,output logic                  rf_ldb_cq_intr_thresh_re
    ,output logic                  rf_ldb_cq_intr_thresh_rclk
    ,output logic                  rf_ldb_cq_intr_thresh_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_intr_thresh_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_intr_thresh_waddr
    ,output logic                  rf_ldb_cq_intr_thresh_we
    ,output logic                  rf_ldb_cq_intr_thresh_wclk
    ,output logic                  rf_ldb_cq_intr_thresh_wclk_rst_n
    ,output logic [(      13)-1:0] rf_ldb_cq_intr_thresh_wdata
    ,input  logic [(      13)-1:0] rf_ldb_cq_intr_thresh_rdata

    ,output logic                  rf_ldb_cq_on_off_threshold_re
    ,output logic                  rf_ldb_cq_on_off_threshold_rclk
    ,output logic                  rf_ldb_cq_on_off_threshold_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_on_off_threshold_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_on_off_threshold_waddr
    ,output logic                  rf_ldb_cq_on_off_threshold_we
    ,output logic                  rf_ldb_cq_on_off_threshold_wclk
    ,output logic                  rf_ldb_cq_on_off_threshold_wclk_rst_n
    ,output logic [(      32)-1:0] rf_ldb_cq_on_off_threshold_wdata
    ,input  logic [(      32)-1:0] rf_ldb_cq_on_off_threshold_rdata

    ,output logic                  rf_ldb_cq_token_depth_select_re
    ,output logic                  rf_ldb_cq_token_depth_select_rclk
    ,output logic                  rf_ldb_cq_token_depth_select_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_token_depth_select_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_token_depth_select_waddr
    ,output logic                  rf_ldb_cq_token_depth_select_we
    ,output logic                  rf_ldb_cq_token_depth_select_wclk
    ,output logic                  rf_ldb_cq_token_depth_select_wclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_token_depth_select_wdata
    ,input  logic [(       6)-1:0] rf_ldb_cq_token_depth_select_rdata

    ,output logic                  rf_ldb_cq_wptr_re
    ,output logic                  rf_ldb_cq_wptr_rclk
    ,output logic                  rf_ldb_cq_wptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_wptr_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_wptr_waddr
    ,output logic                  rf_ldb_cq_wptr_we
    ,output logic                  rf_ldb_cq_wptr_wclk
    ,output logic                  rf_ldb_cq_wptr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_ldb_cq_wptr_wdata
    ,input  logic [(      13)-1:0] rf_ldb_cq_wptr_rdata

    ,output logic                  rf_ord_qid_sn_re
    ,output logic                  rf_ord_qid_sn_rclk
    ,output logic                  rf_ord_qid_sn_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ord_qid_sn_raddr
    ,output logic [(       5)-1:0] rf_ord_qid_sn_waddr
    ,output logic                  rf_ord_qid_sn_we
    ,output logic                  rf_ord_qid_sn_wclk
    ,output logic                  rf_ord_qid_sn_wclk_rst_n
    ,output logic [(      12)-1:0] rf_ord_qid_sn_wdata
    ,input  logic [(      12)-1:0] rf_ord_qid_sn_rdata

    ,output logic                  rf_ord_qid_sn_map_re
    ,output logic                  rf_ord_qid_sn_map_rclk
    ,output logic                  rf_ord_qid_sn_map_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ord_qid_sn_map_raddr
    ,output logic [(       5)-1:0] rf_ord_qid_sn_map_waddr
    ,output logic                  rf_ord_qid_sn_map_we
    ,output logic                  rf_ord_qid_sn_map_wclk
    ,output logic                  rf_ord_qid_sn_map_wclk_rst_n
    ,output logic [(      12)-1:0] rf_ord_qid_sn_map_wdata
    ,input  logic [(      12)-1:0] rf_ord_qid_sn_map_rdata

    ,output logic                  rf_outbound_hcw_fifo_mem_re
    ,output logic                  rf_outbound_hcw_fifo_mem_rclk
    ,output logic                  rf_outbound_hcw_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_outbound_hcw_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_outbound_hcw_fifo_mem_waddr
    ,output logic                  rf_outbound_hcw_fifo_mem_we
    ,output logic                  rf_outbound_hcw_fifo_mem_wclk
    ,output logic                  rf_outbound_hcw_fifo_mem_wclk_rst_n
    ,output logic [(     160)-1:0] rf_outbound_hcw_fifo_mem_wdata
    ,input  logic [(     160)-1:0] rf_outbound_hcw_fifo_mem_rdata

    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_re
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr
    ,output logic [(       2)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_we
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n
    ,output logic [(      26)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata
    ,input  logic [(      26)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata

    ,output logic                  rf_qed_chp_sch_rx_sync_mem_re
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_rclk
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_qed_chp_sch_rx_sync_mem_raddr
    ,output logic [(       3)-1:0] rf_qed_chp_sch_rx_sync_mem_waddr
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_we
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_wclk
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_wclk_rst_n
    ,output logic [(     177)-1:0] rf_qed_chp_sch_rx_sync_mem_wdata
    ,input  logic [(     177)-1:0] rf_qed_chp_sch_rx_sync_mem_rdata

    ,output logic                  rf_qed_to_cq_fifo_mem_re
    ,output logic                  rf_qed_to_cq_fifo_mem_rclk
    ,output logic                  rf_qed_to_cq_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_qed_to_cq_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_qed_to_cq_fifo_mem_waddr
    ,output logic                  rf_qed_to_cq_fifo_mem_we
    ,output logic                  rf_qed_to_cq_fifo_mem_wclk
    ,output logic                  rf_qed_to_cq_fifo_mem_wclk_rst_n
    ,output logic [(     197)-1:0] rf_qed_to_cq_fifo_mem_wdata
    ,input  logic [(     197)-1:0] rf_qed_to_cq_fifo_mem_rdata

    ,output logic                  rf_threshold_r_pipe_dir_mem_re
    ,output logic                  rf_threshold_r_pipe_dir_mem_rclk
    ,output logic                  rf_threshold_r_pipe_dir_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_dir_mem_raddr
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_dir_mem_waddr
    ,output logic                  rf_threshold_r_pipe_dir_mem_we
    ,output logic                  rf_threshold_r_pipe_dir_mem_wclk
    ,output logic                  rf_threshold_r_pipe_dir_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_threshold_r_pipe_dir_mem_wdata
    ,input  logic [(      14)-1:0] rf_threshold_r_pipe_dir_mem_rdata

    ,output logic                  rf_threshold_r_pipe_ldb_mem_re
    ,output logic                  rf_threshold_r_pipe_ldb_mem_rclk
    ,output logic                  rf_threshold_r_pipe_ldb_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_ldb_mem_raddr
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_ldb_mem_waddr
    ,output logic                  rf_threshold_r_pipe_ldb_mem_we
    ,output logic                  rf_threshold_r_pipe_ldb_mem_wclk
    ,output logic                  rf_threshold_r_pipe_ldb_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_threshold_r_pipe_ldb_mem_wdata
    ,input  logic [(      14)-1:0] rf_threshold_r_pipe_ldb_mem_rdata

    ,output logic                  sr_freelist_0_re
    ,output logic                  sr_freelist_0_clk
    ,output logic                  sr_freelist_0_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_0_addr
    ,output logic                  sr_freelist_0_we
    ,output logic [(      16)-1:0] sr_freelist_0_wdata
    ,input  logic [(      16)-1:0] sr_freelist_0_rdata

    ,output logic                  sr_freelist_1_re
    ,output logic                  sr_freelist_1_clk
    ,output logic                  sr_freelist_1_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_1_addr
    ,output logic                  sr_freelist_1_we
    ,output logic [(      16)-1:0] sr_freelist_1_wdata
    ,input  logic [(      16)-1:0] sr_freelist_1_rdata

    ,output logic                  sr_freelist_2_re
    ,output logic                  sr_freelist_2_clk
    ,output logic                  sr_freelist_2_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_2_addr
    ,output logic                  sr_freelist_2_we
    ,output logic [(      16)-1:0] sr_freelist_2_wdata
    ,input  logic [(      16)-1:0] sr_freelist_2_rdata

    ,output logic                  sr_freelist_3_re
    ,output logic                  sr_freelist_3_clk
    ,output logic                  sr_freelist_3_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_3_addr
    ,output logic                  sr_freelist_3_we
    ,output logic [(      16)-1:0] sr_freelist_3_wdata
    ,input  logic [(      16)-1:0] sr_freelist_3_rdata

    ,output logic                  sr_freelist_4_re
    ,output logic                  sr_freelist_4_clk
    ,output logic                  sr_freelist_4_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_4_addr
    ,output logic                  sr_freelist_4_we
    ,output logic [(      16)-1:0] sr_freelist_4_wdata
    ,input  logic [(      16)-1:0] sr_freelist_4_rdata

    ,output logic                  sr_freelist_5_re
    ,output logic                  sr_freelist_5_clk
    ,output logic                  sr_freelist_5_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_5_addr
    ,output logic                  sr_freelist_5_we
    ,output logic [(      16)-1:0] sr_freelist_5_wdata
    ,input  logic [(      16)-1:0] sr_freelist_5_rdata

    ,output logic                  sr_freelist_6_re
    ,output logic                  sr_freelist_6_clk
    ,output logic                  sr_freelist_6_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_6_addr
    ,output logic                  sr_freelist_6_we
    ,output logic [(      16)-1:0] sr_freelist_6_wdata
    ,input  logic [(      16)-1:0] sr_freelist_6_rdata

    ,output logic                  sr_freelist_7_re
    ,output logic                  sr_freelist_7_clk
    ,output logic                  sr_freelist_7_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_7_addr
    ,output logic                  sr_freelist_7_we
    ,output logic [(      16)-1:0] sr_freelist_7_wdata
    ,input  logic [(      16)-1:0] sr_freelist_7_rdata

    ,output logic                  sr_hist_list_re
    ,output logic                  sr_hist_list_clk
    ,output logic                  sr_hist_list_clk_rst_n
    ,output logic [(      11)-1:0] sr_hist_list_addr
    ,output logic                  sr_hist_list_we
    ,output logic [(      66)-1:0] sr_hist_list_wdata
    ,input  logic [(      66)-1:0] sr_hist_list_rdata

    ,output logic                  sr_hist_list_a_re
    ,output logic                  sr_hist_list_a_clk
    ,output logic                  sr_hist_list_a_clk_rst_n
    ,output logic [(      11)-1:0] sr_hist_list_a_addr
    ,output logic                  sr_hist_list_a_we
    ,output logic [(      66)-1:0] sr_hist_list_a_wdata
    ,input  logic [(      66)-1:0] sr_hist_list_a_rdata

// END HQM_MEMPORT_DECL hqm_credit_hist_pipe_core
);

`ifndef HQM_VISA_ELABORATE

// collage-pragma translate_off

hqm_credit_hist_pipe_core i_hqm_credit_hist_pipe_core (.*);

// collage-pragma translate_on

`endif



endmodule // hqm_credit_hist_pipe
