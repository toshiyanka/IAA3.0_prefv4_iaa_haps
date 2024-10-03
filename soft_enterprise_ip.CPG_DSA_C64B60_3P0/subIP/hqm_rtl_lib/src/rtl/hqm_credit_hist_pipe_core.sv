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
//
//-----------------------------------------------------------------------------------------------------
// 
module hqm_credit_hist_pipe_core
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
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
, input  cfg_req_t                      chp_cfg_req_up
, input  logic                          chp_cfg_rsp_up_ack
, input  cfg_rsp_t                      chp_cfg_rsp_up
, output logic                          chp_cfg_req_down_read
, output logic                          chp_cfg_req_down_write
, output cfg_req_t                      chp_cfg_req_down
, output logic                          chp_cfg_rsp_down_ack
, output cfg_rsp_t                      chp_cfg_rsp_down

// interrupt interface
, input  logic                          chp_alarm_up_v
, output logic                          chp_alarm_up_ready
, input  aw_alarm_t                     chp_alarm_up_data

, output logic                          chp_alarm_down_v
, input  logic                          chp_alarm_down_ready
, output aw_alarm_t                     chp_alarm_down_data

// HCW Enqueue in AXI interface
, input  hcw_enq_w_req_t                hcw_enq_w_req
, input  logic                          hcw_enq_w_req_valid
, output logic                          hcw_enq_w_req_ready

// HCW Scheudle out AXI interface
, output hcw_sched_w_req_t              hcw_sched_w_req
, output logic                          hcw_sched_w_req_valid
, input  logic                          hcw_sched_w_req_ready

// Interrupt write AXI interface
, output interrupt_w_req_t              interrupt_w_req
, output logic                          interrupt_w_req_valid
, input  logic                          interrupt_w_req_ready

, output logic                          cwdi_interrupt_w_req_valid
, input  logic                          cwdi_interrupt_w_req_ready

// chp_rop_hcw interface
, output logic                          chp_rop_hcw_v
, input  logic                          chp_rop_hcw_ready
, output chp_rop_hcw_t                  chp_rop_hcw_data

// chp lsp PALB (Power Aware Load Balancing) interface
, output logic [ HQM_NUM_LB_CQ - 1 : 0 ] chp_lsp_ldb_cq_off

// chp_lsp_cmp interface
, output logic                          chp_lsp_cmp_v
, input  logic                          chp_lsp_cmp_ready
, output chp_lsp_cmp_t                  chp_lsp_cmp_data

// chp_lsp_token interface
, output logic                          chp_lsp_token_v
, input  logic                          chp_lsp_token_ready
, output chp_lsp_token_t                chp_lsp_token_data

// qed_chp_sch interface
, input  logic                          qed_chp_sch_v
, output logic                          qed_chp_sch_ready
, input  qed_chp_sch_t                  qed_chp_sch_data

// aqed_chp_sch interface
, input  logic                          aqed_chp_sch_v
, output logic                          aqed_chp_sch_ready
, input  aqed_chp_sch_t                 aqed_chp_sch_data

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
) ;

////////////////////////////////////////////////////////////////////////////////////////////////////

localparam HQM_CHP_RST_LOOP_PFMAX = 2048;
localparam HQM_VF_RESET_CMD_START = 4'h1 ;
localparam HQM_VF_RESET_CMD_DONE = 4'h2 ;
localparam HQM_VF_RESET_CMD_UNSUPPORTED = 4'h4 ;

////////////////////////////////////////////////////////////////////////////////////////////////////
//sidecar & top level AW wires
logic                  disable_smon ;
assign disable_smon = 1'b0 ;

logic wire_chp_unit_idle ;
logic chp_unit_idle_local ;
logic [ ( $bits ( chp_alarm_up_data.unit ) - 1 ) : 0 ] int_uid ;

logic [ ( HQM_CHP_ALARM_NUM_INF ) -1 : 0]          int_inf_v ;
aw_alarm_syn_t [ ( HQM_CHP_ALARM_NUM_INF ) -1 : 0] int_inf_data ;
logic [ ( HQM_CHP_ALARM_NUM_COR) -1 : 0]           int_cor_v ;
aw_alarm_syn_t [ ( HQM_CHP_ALARM_NUM_COR) -1 : 0]  int_cor_data ;
logic [ ( HQM_CHP_ALARM_NUM_UNC ) -1 : 0]          int_unc_v ;
aw_alarm_syn_t [ ( HQM_CHP_ALARM_NUM_UNC ) -1 : 0] int_unc_data ;

logic [ ( 32 ) - 1 : 0 ] int_status ;
aw_fifo_status_t cfg_rx_fifo_status ;
logic cfg_rx_fifo_status_underflow ;
logic cfg_rx_fifo_status_overflow ;

logic wd_clkreq_sync2inp , wd_clkreq_sync2inp_nc , wd_clkreq_sync2inp_inv ;

logic ram_access_error ;

logic [ 3 : 0 ] sr_freelist_we_nxt , sr_freelist_we_f ; 

idle_status_t cfg_unit_idle_reg_f , cfg_unit_idle_reg_nxt ;
logic [ ( 32 ) - 1 : 0 ] reset_pf_counter_nxt , reset_pf_counter_f ;
logic reset_pf_active_f , reset_pf_active_nxt ;
logic reset_pf_done_f , reset_pf_done_nxt ;
logic hw_init_done_f , hw_init_done_nxt ;
logic [ ( 16 ) - 1 : 0] master_chp_timestamp_f , master_chp_timestamp_g2b , master_chp_timestamp_g2b_f ;

logic cfg_rx_idle ;
logic cfg_rx_enable ;
logic cfg_idle ;
logic int_idle ;
logic hist_list_residue_error ;
logic hist_list_a_residue_error ;


logic ldb_hw_pgcb_init_done ;
logic dir_hw_pgcb_init_done ;

logic [ 6 : 0 ] chp_rop_hcw_tx_sync_status ;
logic chp_rop_hcw_tx_sync_idle ;
logic chp_rop_hcw_tx_sync_in_ready ;
logic chp_rop_hcw_tx_sync_in_valid ;
chp_rop_hcw_t chp_rop_hcw_tx_sync_in_data ;

logic [ 6 : 0 ] chp_lsp_token_tx_sync_status ;
logic chp_lsp_token_tx_sync_idle ;
logic chp_lsp_token_tx_sync_in_ready ;
logic chp_lsp_token_tx_sync_in_valid ;
chp_lsp_token_t chp_lsp_token_tx_sync_in_data ;

logic [ 6 : 0 ] chp_lsp_cmp_tx_sync_status ;
logic chp_lsp_cmp_tx_sync_idle ;
logic chp_lsp_cmp_tx_sync_in_ready ;
logic chp_lsp_cmp_tx_sync_in_valid ;
chp_lsp_cmp_t chp_lsp_cmp_tx_sync_in_data ;

logic freelist_pf_push_v_nxt ;
logic freelist_pf_push_v_f ;
logic freelist_pf_push_v ;
logic freelist_push_v ;
logic freelist_pop_v ;

logic [ ( 15 ) - 1 : 0 ] freelist_size ; 
logic freelist_full ;
logic freelist_empty ;
logic freelist_uf ;
logic freelist_of ;
logic freelist_eccerr_mb ;
logic freelist_eccerr_sb ;
logic freelist_pop_error ;
logic freelist_push_parity_chk_error;
logic freelist_status_idle ;

chp_flid_t freelist_pf_push_data_nxt ;
chp_flid_t freelist_pf_push_data_f ;
chp_flid_t freelist_push_data , freelist_pf_push_data ;

logic hist_list_status_nc ;
logic hist_list_cmd_v ;
aw_multi_fifo_cmd_t hist_list_cmd ;
logic [ HQM_CHP_HIST_LIST_PTR_MEM_ADDR_WIDTH - 1 : 0 ] hist_list_fifo_num ;
hist_list_mf_t hist_list_push_data ;
hist_list_mf_t hist_list_pop_data ;
logic [ HQM_CHP_HIST_LIST_PTR_MEM_ADDR_WIDTH - 1 : 0 ] hist_list_error_rid_nc ;
logic hist_list_uf ;
logic hist_list_of ;
logic hist_list_residue_error_cfg ;

logic hist_list_a_status_nc ;
logic hist_list_a_cmd_v ;
aw_multi_fifo_cmd_t hist_list_a_cmd ;
logic [ HQM_CHP_HIST_LIST_PTR_MEM_ADDR_WIDTH - 1 : 0 ] hist_list_a_fifo_num ;
hist_list_mf_t hist_list_a_push_data ;
hist_list_mf_t hist_list_a_pop_data ;
logic [ HQM_CHP_HIST_LIST_PTR_MEM_ADDR_WIDTH - 1 : 0 ] hist_list_a_error_rid_nc ;
logic hist_list_a_uf ;
logic hist_list_a_of ;
logic hist_list_a_residue_error_cfg ;

aw_fifo_status_t fifo_chp_sys_tx_fifo_mem_status ;
logic fifo_chp_sys_tx_fifo_mem_afull_nc ;
logic fifo_chp_sys_tx_fifo_mem_full_nc ;
logic fifo_chp_sys_tx_fifo_mem_pop ;
logic fifo_chp_sys_tx_fifo_mem_push ;
logic fifo_chp_sys_tx_fifo_mem_pop_data_v ;
fifo_chp_sys_tx_fifo_mem_data_t fifo_chp_sys_tx_fifo_mem_push_data ;
fifo_chp_sys_tx_fifo_mem_data_t fifo_chp_sys_tx_fifo_mem_pop_data ;
logic fifo_chp_sys_tx_fifo_mem_uf ;
logic fifo_chp_sys_tx_fifo_mem_of ;

logic rw_ldb_cq_depth_mem_pipe_status_nc ;
logic rw_ldb_cq_depth_p0_v_nxt ;
aw_rmwpipe_cmd_t rw_ldb_cq_depth_p0_rmw_nxt ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_depth_p0_addr_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_ldb_cq_depth_p2_data_f ;
logic rw_ldb_cq_depth_p3_bypsel_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_ldb_cq_depth_p3_bypdata_nxt ;

logic rw_dir_cq_depth_mem_pipe_status_nc ;
logic rw_dir_cq_depth_p0_v_nxt ;
aw_rmwpipe_cmd_t rw_dir_cq_depth_p0_rmw_nxt ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_depth_p0_addr_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_dir_cq_depth_p2_data_f ;
logic rw_dir_cq_depth_p3_bypsel_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_dir_cq_depth_p3_bypdata_nxt ;

logic rw_ldb_cq_wptr_mem_pipe_status_nc ;
logic rw_ldb_cq_wptr_p0_v_nxt ;
aw_rmwpipe_cmd_t rw_ldb_cq_wptr_p0_rmw_nxt ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_wptr_p0_addr_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_ldb_cq_wptr_p2_data_f ;
logic rw_ldb_cq_wptr_p3_bypsel_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_ldb_cq_wptr_p3_bypdata_nxt ;

logic rw_dir_cq_wptr_mem_pipe_status_nc ;
logic rw_dir_cq_wptr_p0_v_nxt ;
aw_rmwpipe_cmd_t rw_dir_cq_wptr_p0_rmw_nxt ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_wptr_p0_addr_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_dir_cq_wptr_p2_data_f ;
logic rw_dir_cq_wptr_p3_bypsel_nxt ;
logic [ ( 13 ) - 1 : 0 ] rw_dir_cq_wptr_p3_bypdata_nxt ;

logic rw_ldb_cq_token_depth_select_status_nc ;
logic rw_ldb_cq_token_depth_select_p0_v_nxt ;
aw_rwpipe_cmd_t rw_ldb_cq_token_depth_select_p0_rw_nxt ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_token_depth_select_p0_addr_nxt ;
chp_cq_token_depth_select_t rw_ldb_cq_token_depth_select_p2_data_f ;

logic rw_dir_cq_token_depth_select_status_nc ;
logic rw_dir_cq_token_depth_select_p0_v_nxt ;
aw_rwpipe_cmd_t rw_dir_cq_token_depth_select_p0_rw_nxt ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_token_depth_select_p0_addr_nxt ;
chp_cq_token_depth_select_t rw_dir_cq_token_depth_select_p2_data_f ;

logic rw_ldb_cq_intr_thresh_status_nc ;
logic rw_ldb_cq_intr_thresh_p0_v_nxt ;
aw_rwpipe_cmd_t rw_ldb_cq_intr_thresh_p0_rw_nxt ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_intr_thresh_p0_addr_nxt ;
cfg_ldb_cq_intcfg_t rw_ldb_cq_intr_thresh_p2_data_f ;

logic rw_dir_cq_intr_thresh_status_nc ;
logic rw_dir_cq_intr_thresh_p0_v_nxt ;
aw_rwpipe_cmd_t rw_dir_cq_intr_thresh_p0_rw_nxt ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_intr_thresh_p0_addr_nxt ;
cfg_dir_cq_intcfg_t rw_dir_cq_intr_thresh_p2_data_f ;

logic qed_sch_sn_mem_pipe_status_nc ;







logic qed_sch_sn_map_mem_pipe_status_nc ;





logic dir_cq_wp_mem_pipe_status_nc ;
logic rw_cmp_id_chk_enbl_mem_p0_v_nxt ;
aw_rwpipe_cmd_t rw_cmp_id_chk_enbl_mem_p0_rw_nxt ;
logic [ ( 6 ) - 1 : 0 ] rw_cmp_id_chk_enbl_mem_p0_addr_nxt ;
logic [1:0] rw_cmp_id_chk_enbl_mem_p2_data_f ;



logic fifo_chp_rop_hcw_afull_nc ;
logic fifo_chp_rop_hcw_pop_data_v ;
logic fifo_chp_rop_hcw_full_nc ;
logic fifo_chp_rop_hcw_of ;
logic fifo_chp_rop_hcw_pop ;
chp_rop_hcw_t fifo_chp_rop_hcw_pop_data ;
logic fifo_chp_rop_hcw_push ;
chp_rop_hcw_t fifo_chp_rop_hcw_push_data ;
logic fifo_chp_rop_hcw_uf ;
aw_fifo_status_t fifo_chp_rop_hcw_status ;

logic fifo_chp_lsp_tok_afull_nc ;
logic fifo_chp_lsp_tok_pop_data_v ;
logic fifo_chp_lsp_tok_full_nc ;
logic fifo_chp_lsp_tok_of ;
logic fifo_chp_lsp_tok_pop ;
chp_lsp_token_t fifo_chp_lsp_tok_pop_data ;
logic fifo_chp_lsp_tok_push ;
chp_lsp_token_t fifo_chp_lsp_tok_push_data ;
logic fifo_chp_lsp_tok_uf ;
aw_fifo_status_t fifo_chp_lsp_tok_status ;

logic fifo_chp_lsp_ap_cmp_afull_nc ;
logic fifo_chp_lsp_ap_cmp_pop_data_v ;
logic fifo_chp_lsp_ap_cmp_full_nc ;
logic fifo_chp_lsp_ap_cmp_of ;
logic fifo_chp_lsp_ap_cmp_pop ;
fifo_chp_lsp_ap_cmp_t fifo_chp_lsp_ap_cmp_pop_data ;
logic fifo_chp_lsp_ap_cmp_push ;
fifo_chp_lsp_ap_cmp_t fifo_chp_lsp_ap_cmp_push_data ;

logic fifo_chp_lsp_ap_cmp_uf ;
aw_fifo_status_t fifo_chp_lsp_ap_cmp_status ;

aw_fifo_status_t fifo_outbound_hcw_status ;
logic fifo_outbound_hcw_afull_nc ;
logic fifo_outbound_hcw_pop_data_v ;
logic fifo_outbound_hcw_full_nc ;
logic fifo_outbound_hcw_of ;
logic fifo_outbound_hcw_pop ;
outbound_hcw_fifo_t fifo_outbound_hcw_pop_data ;
logic fifo_outbound_hcw_push ;
outbound_hcw_fifo_t fifo_outbound_hcw_push_data ;
logic fifo_outbound_hcw_uf ;

aw_fifo_status_t fifo_qed_to_cq_status_nc ;

logic [ ( 1 * 1 * HQM_NUM_DIR_CQ ) - 1 : 0] hqm_chp_target_cfg_dir_cq_irq_pending_reg_f_nc ;
logic [ ( 1 * 1 * HQM_NUM_LB_CQ ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f_nc ;

logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] hqm_chp_int_armed_ldb;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] hqm_chp_int_armed_dir;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] cfg_hqm_chp_int_armed_ldb ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] cfg_hqm_chp_int_armed_dir;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] ldb_wd_irq ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] dir_wd_irq ;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] hqm_chp_int_run_ldb ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] hqm_chp_int_run_dir ;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] hqm_chp_int_expired_ldb ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] hqm_chp_int_expired_dir ;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] hqm_chp_int_urgent_ldb ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] hqm_chp_int_urgent_dir ;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] hqm_chp_int_irq_ldb ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] hqm_chp_int_irq_dir ;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] ldb_wdto_nxt ;
logic ldb_wdto_v ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] dir_wdto_nxt ;
logic dir_wdto_v;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] ldb_wdrt_status ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] dir_wdrt_status ;
logic hqm_chp_int_idle ;
logic wd_irq_idle ;
logic cial_tx_sync_idle;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] hqm_chp_target_cfg_ldb_wd_disable_reg_f ;
logic [ ( HQM_NUM_LB_CQ - 1 ) : 0 ] hqm_chp_target_cfg_ldb_wd_disable_reg_nxt ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] hqm_chp_target_cfg_dir_wd_disable_reg_f ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] hqm_chp_target_cfg_dir_wd_disable_reg_nxt ;
logic [ 6 : 0 ] wd_tx_sync_status ;
logic           wd_tx_sync_idle;
logic dir_cfg_wd_load_cg_f , dir_cfg_wd_load_cg_nxt ;
logic ldb_cfg_wd_load_cg_f , ldb_cfg_wd_load_cg_nxt ;
logic hqm_chp_int_dir_cg_f , hqm_chp_int_dir_cg_nxt ;
logic hqm_chp_int_ldb_cg_f , hqm_chp_int_ldb_cg_nxt ;
logic cfg_hqm_chp_int_armed_ldb_cg_f , cfg_hqm_chp_int_armed_ldb_cg_nxt ;
logic cfg_hqm_chp_int_armed_dir_cg_f , cfg_hqm_chp_int_armed_dir_cg_nxt ;
logic [ 63 : 0 ] cfg_int_en_tim_ldb ;
logic [ 63 : 0 ] cfg_int_en_depth_ldb ;
logic load_cg_ldb ;
logic load_cg_dir ;
logic [ 63 : 0 ] ldb_wdto_f_nc ;
logic [ ( HQM_NUM_DIR_CQ - 1 ) : 0 ] dir_wdto_f_nc ;
cq_int_info_t sch_ldb_excep ;
cq_int_info_t enq_ldb_excep ;
cq_int_info_t sch_dir_excep ;
cq_int_info_t enq_dir_excep ;
logic [31:0] hqm_chp_int_tim_pipe_status_dir_pnc;
logic [31:0] hqm_chp_int_tim_pipe_status_ldb_pnc;
logic [6:0] cial_tx_sync_status_pnc; 
logic cfg_access_idle_req_cial_ldb ;
logic cfg_access_idle_req_cial_dir ;
logic hqm_chp_tim_pipe_idle_cial_ldb ;
logic hqm_chp_tim_pipe_idle_cial_dir ;
logic [ ( 32 ) - 1 : 0 ] hqm_chp_wd_dir_pipe_status_pnc ;
logic [ ( 32 ) - 1 : 0 ] hqm_chp_wd_ldb_pipe_status_pnc ;
logic [ HQM_NUM_DIR_CQ - 1 : 0 ] cfg_int_en_depth_dir ;
logic [ HQM_NUM_DIR_CQ - 1 : 0 ] cfg_int_en_tim_dir ;
logic idle_cial_timer_report_control ;
logic cfg_cial_clock_gate_control ;
logic idle_cwdi_timer_report_control ;
logic hqm_chp_target_cfg_ldb_wd_enb_interval_update_v_f ;
logic hqm_chp_target_cfg_dir_wd_enb_interval_update_v_f ;
logic hqm_chp_target_cfg_dir_wd_threshold_update_v_f ;
logic hqm_chp_target_cfg_ldb_wd_threshold_update_v_f ;
logic smon_thresh_irq_dir ;
logic smon_thresh_irq_ldb ;
logic smon_timer_irq_dir ;
logic smon_timer_irq_ldb ;
//Interconnect

//ingress
logic ing_pipe_idle ;
logic ing_unit_idle ;
logic hcw_enq_w_rx_sync_idle ;
logic qed_chp_sch_rx_sync_idle ;
logic qed_chp_sch_flid_ret_rx_sync_idle ;
logic aqed_chp_sch_rx_sync_idle ;
logic hcw_enq_w_rx_sync_enable ;
logic qed_chp_sch_rx_sync_enable ;
logic qed_chp_sch_flid_ret_rx_sync_enable ;
logic aqed_chp_sch_rx_sync_enable ;
aw_fifo_status_t hcw_enq_w_rx_sync_status ;
aw_fifo_status_t qed_chp_sch_rx_sync_status ;
aw_fifo_status_t qed_chp_sch_flid_ret_rx_sync_status ;
aw_fifo_status_t aqed_chp_sch_rx_sync_status ;
logic [ 6 : 0 ] atm_ord_db_status ;
logic [ 6 : 0 ] hcw_replay_db_status ;
logic hcw_enq_pop ;
logic hcw_enq_valid ;
chp_pp_info_t hcw_enq_info ;
chp_pp_data_t hcw_enq_data ;
logic hcw_replay_pop ;
logic hcw_replay_valid ;
chp_hcw_replay_data_t hcw_replay_data ;
logic qed_sch_pop ;
logic qed_sch_valid ;
chp_qed_to_cq_t qed_sch_data ;
logic aqed_sch_pop ;
logic aqed_sch_valid ;
aqed_chp_sch_t aqed_sch_data ;
logic [ HQM_CHP_QED_TO_CQ_PIPE_CREDIT_STATUS_WIDTH - 1 : 0 ] qed_to_cq_pipe_credit_status ;
logic [ HQM_CHP_QED_TO_CQ_FIFO_WMWIDTH - 1 : 0 ] cfg_qed_to_cq_pipe_credit_hwm ;
logic ing_err_hcw_enq_invalid_hcw_cmd ;
logic ing_err_hcw_enq_user_parity_error ;
logic ing_err_hcw_enq_data_parity_error ;
logic ing_err_qed_chp_sch_rx_sync_out_cmd_error ;
logic fifo_qed_to_cq_of ;
logic fifo_qed_to_cq_uf ;
logic cmp_id_chk_enbl_parity_err;
logic ing_err_qed_chp_sch_flid_ret_flid_parity_error ;
logic ing_err_qed_chp_sch_cq_parity_error ;
logic ing_err_aqed_chp_sch_cq_parity_error ;
logic ing_err_qed_chp_sch_vas_parity_error ;
logic ing_err_aqed_chp_sch_vas_parity_error ;
logic ing_err_enq_vas_credit_count_residue_error ;
logic ing_err_sch_vas_credit_count_residue_error ;

logic cq_timer_threshold_parity_err_dir_cial;
logic cq_timer_threshold_parity_err_ldb_cial;
logic cq_timer_threshold_parity_err_dir_cwdi;
logic cq_timer_threshold_parity_err_ldb_cwdi;
logic sch_excep_parity_check_err_dir_cial;
logic sch_excep_parity_check_err_ldb_cial;
logic sch_excep_parity_check_err_dir_cwdi;
logic sch_excep_parity_check_err_ldb_cwdi;
logic hqm_chp_partial_outbound_hcw_fifo_parity_err;

//egress
logic egress_pipe_idle ;
logic egress_unit_idle ;
logic [ ( 8 ) - 1 : 0 ] egress_credit_status ;
logic [ ( 7 ) - 1 : 0 ] egress_lsp_token_credit_status ;
logic [ ( 7 ) - 1 : 0 ] egress_tx_sync_status ;
logic [ ( 4 ) - 1 : 0 ] cfg_egress_pipecredits ;
logic [ ( 3 ) - 1 : 0 ] cfg_egress_lsp_token_pipecredits ;
logic egress_err_pipe_credit_error ;
logic egress_err_parity_ldb_cq_token_depth_select ;
logic egress_err_parity_dir_cq_token_depth_select ;
logic egress_err_parity_ldb_cq_intr_thresh ;
logic egress_err_parity_dir_cq_intr_thresh ;
logic egress_err_residue_ldb_cq_wptr ;
logic egress_err_residue_dir_cq_wptr ;
logic egress_err_residue_ldb_cq_depth ;
logic egress_err_residue_dir_cq_depth ;
logic [ ( 8 ) - 1 : 0 ] egress_err_ldb_rid ;
logic [ ( 8 ) - 1 : 0 ] egress_err_dir_rid ;
logic egress_err_hcw_ecc_sb ;
logic egress_err_hcw_ecc_mb ;
logic egress_err_ldb_cq_depth_underflow ;
logic egress_err_ldb_cq_depth_overflow ;
logic egress_err_dir_cq_depth_underflow ;
logic egress_err_dir_cq_depth_overflow ;

// schpipe
logic schpipe_pipe_idle ;
logic schpipe_unit_idle ;
logic schpipe_err_pipeline_parity_err ;
logic schpipe_err_ldb_cq_hcw_h_ecc_sb ;
logic schpipe_err_ldb_cq_hcw_h_ecc_mb ;
logic [ HQM_NUM_LB_CQ - 1 : 0] schpipe_hqm_chp_target_cfg_hist_list_mode ;

//enqpipe
logic enqpipe_pipe_idle ;
logic enqpipe_unit_idle ;
logic enqpipe_err_frag_count_residue_error ;
logic enqpipe_err_hist_list_data_error_sb ;
logic enqpipe_err_hist_list_data_error_mb ;
logic enqpipe_err_enq_to_rop_out_of_credit_drop ;
logic enqpipe_err_enq_to_rop_excess_frag_drop ;
logic enqpipe_err_enq_to_rop_freelist_uf_drop ;
logic enqpipe_err_enq_to_lsp_cmp_error_drop ;
logic enqpipe_err_release_qtype_error_drop ;
logic [ 7 : 0] enqpipe_err_rid ;
logic [ 7 : 0] enqpipe_err_rid_f ;
logic [ HQM_NUM_LB_CQ - 1 : 0] enqpipe_hqm_chp_target_cfg_hist_list_mode ;

//arb
logic arb_pipe_idle ;
logic arb_unit_idle ;
logic cfg_pad_first_write_ldb ;
logic cfg_pad_first_write_dir ;
logic cfg_pad_write_ldb ;
logic cfg_pad_write_dir ;
logic cfg_chp_blk_dual_issue ;
logic [ HQM_CHP_ROP_HCW_FIFO_WMWIDTH - 1 : 0 ] cfg_chp_rop_pipe_credit_hwm ;
logic chp_rop_pipe_credit_dealloc ;
logic enq_to_rop_error_credit_dealloc ;
logic enq_to_rop_cmp_credit_dealloc ;
logic enq_to_lsp_cmp_error_credit_dealloc ;
logic [ HQM_CHP_ROP_PIPE_CREDIT_STATUS_WIDTH - 1 : 0 ] chp_rop_pipe_credit_status ;
logic [ HQM_CHP_LSP_TOK_FIFO_WMWIDTH - 1 : 0 ] cfg_chp_lsp_tok_pipe_credit_hwm ;
logic chp_lsp_tok_pipe_credit_dealloc ;
logic [ HQM_CHP_LSP_TOK_PIPE_CREDIT_STATUS_WIDTH - 1 : 0 ] chp_lsp_tok_pipe_credit_status ;
logic [ HQM_CHP_LSP_AP_CMP_FIFO_WMWIDTH - 1 : 0 ] cfg_chp_lsp_ap_cmp_pipe_credit_hwm ;
logic chp_lsp_ap_cmp_pipe_credit_dealloc ;
logic [ HQM_CHP_LSP_AP_CMP_PIPE_CREDIT_STATUS_WIDTH - 1 : 0 ] chp_lsp_ap_cmp_pipe_credit_status ;
logic [ HQM_CHP_OUTBOUND_HCW_FIFO_WMWIDTH - 1 : 0 ] cfg_chp_outbound_hcw_pipe_credit_hwm ;
logic arb_err_chp_pipe_credit_error ;
logic chp_outbound_hcw_pipe_credit_dealloc ;
logic [ HQM_CHP_OUTBOUND_HCW_PIPE_CREDIT_STATUS_WIDTH - 1 : 0 ] chp_outbound_hcw_pipe_credit_status ;
logic arb_err_illegal_cmd_error ;

//shared pipe
chp_credit_count_t ing_enq_vas_credit_count_rdata ;
logic ing_enq_vas_credit_count_we ;
logic [ 4 : 0 ] ing_enq_vas_credit_count_addr ;
chp_credit_count_t ing_enq_vas_credit_count_wdata ;
logic enq_hist_list_cmd_v ;
aw_multi_fifo_cmd_t enq_hist_list_cmd ;
logic [ 5 : 0 ] enq_hist_list_fifo_num ;
hist_list_mf_t enq_hist_list_pop_data ;
logic enq_hist_list_uf ;
logic sch_hist_list_of ;
logic enq_hist_list_residue_error ;
logic enq_hist_list_a_cmd_v ;
aw_multi_fifo_cmd_t enq_hist_list_a_cmd ;
logic [ 5 : 0 ] enq_hist_list_a_fifo_num ;
logic sch_hist_list_a_of ;
logic enq_freelist_pop_v ;
chp_flid_t enq_freelist_pop_data, freelist_pop_data ;
logic enq_freelist_pop_error ;
logic enq_freelist_error_mb ;
logic enq_freelist_uf ;
chp_credit_count_t ing_sch_vas_credit_count_rdata ;
logic ing_sch_vas_credit_count_we ;
logic [ 4 : 0 ] ing_sch_vas_credit_count_addr ;
chp_credit_count_t ing_sch_vas_credit_count_wdata ;
logic sch_hist_list_cmd_v ;
aw_multi_fifo_cmd_t sch_hist_list_cmd ;
logic [ 5 : 0 ] sch_hist_list_fifo_num ;
hist_list_mf_t sch_hist_list_push_data ;
logic sch_hist_list_a_cmd_v ;
aw_multi_fifo_cmd_t sch_hist_list_a_cmd ;
logic [ 5 : 0 ] sch_hist_list_a_fifo_num ;
hist_list_mf_t sch_hist_list_a_push_data ;
logic ing_freelist_push_v ;
chp_flid_t ing_freelist_push_data ;
logic sharepipe_error ;

//smon
logic [ ( 3 * 1 ) - 1 : 0 ] egress_hqm_chp_target_cfg_chp_smon_smon_v ;
logic [ ( 3 * 32 ) - 1 : 0 ] egress_hqm_chp_target_cfg_chp_smon_smon_comp ;
logic [ ( 3 * 32 ) - 1 : 0 ] egress_hqm_chp_target_cfg_chp_smon_smon_val ;

logic [ ( 1 * 1 ) - 1 : 0 ] schpipe_hqm_chp_target_cfg_chp_smon_smon_v ;
logic [ ( 1 * 32 ) - 1 : 0 ] schpipe_hqm_chp_target_cfg_chp_smon_smon_comp ;
logic [ ( 1 * 32 ) - 1 : 0 ] schpipe_hqm_chp_target_cfg_chp_smon_smon_val ;

logic [ ( 1 * 1 ) - 1 : 0 ] enqpipe_hqm_chp_target_cfg_chp_smon_smon_v ;
logic [ ( 1 * 32 ) - 1 : 0 ] enqpipe_hqm_chp_target_cfg_chp_smon_smon_comp ;
logic [ ( 1 * 32 ) - 1 : 0 ] enqpipe_hqm_chp_target_cfg_chp_smon_smon_val ;

logic [ ( 3 * 1 ) - 1 : 0 ] arb_hqm_chp_target_cfg_chp_smon_smon_v ;
logic [ ( 3 * 32 ) - 1 : 0 ] arb_hqm_chp_target_cfg_chp_smon_smon_comp ;
logic [ ( 3 * 32 ) - 1 : 0 ] arb_hqm_chp_target_cfg_chp_smon_smon_val ;

logic [ ( 4 * 1 ) - 1 : 0 ] ing_hqm_chp_target_cfg_chp_smon_smon_v ;
logic [ ( 4 * 32 ) - 1 : 0 ] ing_hqm_chp_target_cfg_chp_smon_smon_comp ;
logic [ ( 4 * 32 ) - 1 : 0 ] ing_hqm_chp_target_cfg_chp_smon_smon_val ;

logic chp_alarm_down_v_pre ;
logic chp_alarm_down_ready_post ;

logic egress_wbo_error_inject_0 ;
logic egress_wbo_error_inject_1 ;
logic egress_wbo_error_inject_2 ;
logic egress_wbo_error_inject_3 ;
logic enqpipe_flid_parity_error_inject ;
logic ingress_flid_parity_error_inject_0 ;
logic ingress_flid_parity_error_inject_1 ;
logic ingress_error_inject_h0 , ingress_error_inject_l0 ;
logic ingress_error_inject_h1 , ingress_error_inject_l1 ;
logic egress_error_inject_h0 , egress_error_inject_l0 ;
logic egress_error_inject_h1 , egress_error_inject_l1 ;
logic schpipe_error_inject_h0 , schpipe_error_inject_l0 ;
logic schpipe_error_inject_h1 , schpipe_error_inject_l1 ;
logic enqpipe_error_inject_h0 , enqpipe_error_inject_l0 ;
logic enqpipe_error_inject_h1 , enqpipe_error_inject_l1 ;

logic egress_wbo_error_inject_0_done_set ;
logic egress_wbo_error_inject_1_done_set ;
logic egress_wbo_error_inject_2_done_set ;
logic egress_wbo_error_inject_3_done_set ;
logic enqpipe_flid_parity_error_inject_done_set ;
logic ingress_flid_parity_error_inject_0_done_set ;
logic ingress_flid_parity_error_inject_1_done_set ;
logic ingress_error_inject_h0_done_set ;
logic ingress_error_inject_h1_done_set ;
logic ingress_error_inject_l0_done_set ;
logic ingress_error_inject_l1_done_set ;
logic egress_error_inject_h0_done_set ;
logic egress_error_inject_h1_done_set ;
logic egress_error_inject_l0_done_set ;
logic egress_error_inject_l1_done_set ;
logic schpipe_error_inject_h0_done_set ;
logic schpipe_error_inject_h1_done_set ;
logic schpipe_error_inject_l0_done_set ;
logic schpipe_error_inject_l1_done_set ;
logic enqpipe_error_inject_h0_done_set ;
logic enqpipe_error_inject_h1_done_set ;
logic enqpipe_error_inject_l0_done_set ;
logic enqpipe_error_inject_l1_done_set ;

logic egress_wbo_error_inject_0_done_nxt , egress_wbo_error_inject_0_done_f ;
logic egress_wbo_error_inject_1_done_nxt , egress_wbo_error_inject_1_done_f ;
logic egress_wbo_error_inject_2_done_nxt , egress_wbo_error_inject_2_done_f ;
logic egress_wbo_error_inject_3_done_nxt , egress_wbo_error_inject_3_done_f ;
logic enqpipe_flid_parity_error_inject_done_nxt , enqpipe_flid_parity_error_inject_done_f ;
logic ingress_flid_parity_error_inject_0_done_nxt , ingress_flid_parity_error_inject_0_done_f ;
logic ingress_flid_parity_error_inject_1_done_nxt , ingress_flid_parity_error_inject_1_done_f ;
logic ingress_error_inject_h0_done_nxt , ingress_error_inject_h0_done_f ;
logic ingress_error_inject_h1_done_nxt , ingress_error_inject_h1_done_f ;
logic ingress_error_inject_l0_done_nxt , ingress_error_inject_l0_done_f ;
logic ingress_error_inject_l1_done_nxt , ingress_error_inject_l1_done_f ;
logic egress_error_inject_h0_done_nxt , egress_error_inject_h0_done_f ;
logic egress_error_inject_h1_done_nxt , egress_error_inject_h1_done_f ;
logic egress_error_inject_l0_done_nxt , egress_error_inject_l0_done_f ;
logic egress_error_inject_l1_done_nxt , egress_error_inject_l1_done_f ;
logic schpipe_error_inject_h0_done_nxt , schpipe_error_inject_h0_done_f ;
logic schpipe_error_inject_h1_done_nxt , schpipe_error_inject_h1_done_f ;
logic schpipe_error_inject_l0_done_nxt , schpipe_error_inject_l0_done_f ;
logic schpipe_error_inject_l1_done_nxt , schpipe_error_inject_l1_done_f ;
logic enqpipe_error_inject_h0_done_nxt , enqpipe_error_inject_h0_done_f ;
logic enqpipe_error_inject_h1_done_nxt , enqpipe_error_inject_h1_done_f ;
logic enqpipe_error_inject_l0_done_nxt , enqpipe_error_inject_l0_done_f ;
logic enqpipe_error_inject_l1_done_nxt , enqpipe_error_inject_l1_done_f ;

hcw_enq_w_req_t hcw_enq_w_rx_sync_mem_wdata ; 
hcw_enq_w_req_t hcw_enq_w_rx_sync_mem_rdata ;

////////////////////////////////////////////////////////////////////////////////////////////////////

//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: BEGIN common core interfaces

//*****************************************************************************************************
//*****************************************************************************************************

//---------------------------------------------------------------------------------------------------------
// common core - Reset
logic rst_prep;
logic hqm_gated_rst_n;
logic hqm_inp_gated_rst_n;
assign rst_prep             = hqm_rst_prep_chp;
assign hqm_gated_rst_n      = hqm_gated_rst_b_chp;
assign hqm_inp_gated_rst_n  = hqm_inp_gated_rst_b_chp;

logic hqm_gated_rst_n_start;
logic hqm_gated_rst_n_active;
logic hqm_gated_rst_n_done;
assign hqm_gated_rst_n_start    = hqm_gated_rst_b_start_chp;
assign hqm_gated_rst_n_active   = hqm_gated_rst_b_active_chp;
assign hqm_gated_rst_n_done = reset_pf_done_f ;
assign hqm_gated_rst_b_done_chp = hqm_gated_rst_n_done;

logic hqm_pgcb_rst_n;
logic hqm_pgcb_rst_n_start;
assign hqm_pgcb_rst_n       = hqm_pgcb_rst_b_chp;
assign hqm_pgcb_rst_n_start = hqm_pgcb_rst_b_start_chp;

//---------------------------------------------------------------------------------------------------------
// common core - CFG accessible patch & proc registers
// common core - RFW/SRW RAM gasket
// common core - RAM wrapper for all single PORT SR RAMs
// common core - RAM wrapper for all 2 port RF RAMs
// The following must be kept in-sync with generated code
// BEGIN HQM_CFG_ACCESS
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write ; //I CFG
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read ; //I CFG
cfg_req_t pfcsr_cfg_req ; //I CFG
logic pfcsr_cfg_rsp_ack ; //O CFG
logic pfcsr_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata ; //O CFG
logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_en ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clr ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_inc ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count ; //O HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_en ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM
logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_clr ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM
logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM
logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc ; //I HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_atq_to_atm_count ; //O HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM
logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_en ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clr ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_inc ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count ; //O HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_en ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clr ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_inc ; //I HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count ; //O HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_frag_replayed_en ; //I HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED
logic hqm_chp_target_cfg_chp_cnt_frag_replayed_clr ; //I HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED
logic hqm_chp_target_cfg_chp_cnt_frag_replayed_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED
logic hqm_chp_target_cfg_chp_cnt_frag_replayed_inc ; //I HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_frag_replayed_count ; //O HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED
logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_en ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clr ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_inc ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count ; //O HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ
logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_en ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clr ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH
logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_inc ; //I HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count ; //O HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH
logic hqm_chp_target_cfg_chp_correctible_count_en ; //I HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT
logic hqm_chp_target_cfg_chp_correctible_count_clr ; //I HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT
logic hqm_chp_target_cfg_chp_correctible_count_clrv ; //I HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT
logic hqm_chp_target_cfg_chp_correctible_count_inc ; //I HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_correctible_count_count ; //O HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_csr_control_reg_nxt ; //I HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_csr_control_reg_f ; //O HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL
logic hqm_chp_target_cfg_chp_csr_control_reg_v ; //I HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL
logic hqm_chp_target_cfg_chp_frag_count_reg_load ; //I HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT
logic [ ( 1 * 7 * 64 ) - 1 : 0] hqm_chp_target_cfg_chp_frag_count_reg_nxt ; //I HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT
logic [ ( 1 * 7 * 64 ) - 1 : 0] hqm_chp_target_cfg_chp_frag_count_reg_f ; //O HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_palb_control_reg_nxt ; //I HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_palb_control_reg_f ; //O HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL
logic hqm_chp_target_cfg_chp_palb_control_reg_v ; //I HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL
logic hqm_chp_target_cfg_chp_smon_disable_smon ; //I HQM_CHP_TARGET_CFG_CHP_SMON
logic [ 16 - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_v ; //I HQM_CHP_TARGET_CFG_CHP_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_comp ; //I HQM_CHP_TARGET_CFG_CHP_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_val ; //I HQM_CHP_TARGET_CFG_CHP_SMON
logic hqm_chp_target_cfg_chp_smon_smon_enabled ; //O HQM_CHP_TARGET_CFG_CHP_SMON
logic hqm_chp_target_cfg_chp_smon_smon_interrupt ; //O HQM_CHP_TARGET_CFG_CHP_SMON
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_00_reg_nxt ; //I HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_00_reg_f ; //O HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_01_reg_nxt ; //I HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_01_reg_f ; //O HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_02_reg_nxt ; //I HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_02_reg_f ; //O HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_00_reg_nxt ; //I HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_00_reg_f ; //O HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00
logic hqm_chp_target_cfg_control_general_00_reg_v ; //I HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_01_reg_nxt ; //I HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_01_reg_f ; //O HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01
logic hqm_chp_target_cfg_control_general_01_reg_v ; //I HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_02_reg_nxt ; //I HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_02_reg_f ; //O HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02
logic hqm_chp_target_cfg_control_general_02_reg_v ; //I HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02
logic hqm_chp_target_cfg_counter_chp_error_drop_en ; //I HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP
logic hqm_chp_target_cfg_counter_chp_error_drop_clr ; //I HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP
logic hqm_chp_target_cfg_counter_chp_error_drop_clrv ; //I HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP
logic hqm_chp_target_cfg_counter_chp_error_drop_inc ; //I HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_counter_chp_error_drop_count ; //O HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_0_status ; //I HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_1_status ; //I HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_2_status ; //I HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_3_status ; //I HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_diagnostic_aw_status_0_status ; //I HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0
logic hqm_chp_target_cfg_dir_cq2vas_reg_load ; //I HQM_CHP_TARGET_CFG_DIR_CQ2VAS
logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq2vas_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ2VAS
logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq2vas_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ2VAS
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed0_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed0_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0
logic hqm_chp_target_cfg_dir_cq_intr_armed0_reg_v ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed1_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed1_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1
logic hqm_chp_target_cfg_dir_cq_intr_armed1_reg_v ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_expired0_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_expired1_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_irq0_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_irq1_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_run_timer0_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_run_timer1_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_urgent0_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_urgent1_status ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1
logic hqm_chp_target_cfg_dir_cq_int_enb_reg_load ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB
logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_enb_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB
logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_enb_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB
logic hqm_chp_target_cfg_dir_cq_int_mask_reg_load ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_mask_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_mask_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK
logic hqm_chp_target_cfg_dir_cq_irq_pending_reg_load ; //I HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_irq_pending_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_irq_pending_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_timer_ctl_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL
logic hqm_chp_target_cfg_dir_cq_timer_ctl_reg_v ; //I HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL
logic hqm_chp_target_cfg_dir_cq_wd_enb_reg_load ; //I HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_wd_enb_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdrt_0_status ; //I HQM_CHP_TARGET_CFG_DIR_WDRT_0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdrt_1_status ; //I HQM_CHP_TARGET_CFG_DIR_WDRT_1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_0_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_WDTO_0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_0_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_WDTO_0
logic hqm_chp_target_cfg_dir_wdto_0_reg_load ; //I HQM_CHP_TARGET_CFG_DIR_WDTO_0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_1_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_WDTO_1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_1_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_WDTO_1
logic hqm_chp_target_cfg_dir_wdto_1_reg_load ; //I HQM_CHP_TARGET_CFG_DIR_WDTO_1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable0_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable0_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable1_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable1_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_enb_interval_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_enb_interval_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL
logic hqm_chp_target_cfg_dir_wd_enb_interval_reg_v ; //I HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_irq0_status ; //I HQM_CHP_TARGET_CFG_DIR_WD_IRQ0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_irq1_status ; //I HQM_CHP_TARGET_CFG_DIR_WD_IRQ1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_threshold_reg_nxt ; //I HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_threshold_reg_f ; //O HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD
logic hqm_chp_target_cfg_dir_wd_threshold_reg_v ; //I HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD
logic hqm_chp_target_cfg_hist_list_mode_reg_load ; //I HQM_CHP_TARGET_CFG_HIST_LIST_MODE
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_hist_list_mode_reg_nxt ; //I HQM_CHP_TARGET_CFG_HIST_LIST_MODE
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_hist_list_mode_reg_f ; //O HQM_CHP_TARGET_CFG_HIST_LIST_MODE
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_control_reg_nxt ; //I HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_control_reg_f ; //O HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL
logic hqm_chp_target_cfg_hw_agitate_control_reg_v ; //I HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_select_reg_nxt ; //I HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_select_reg_f ; //O HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_chp_target_cfg_hw_agitate_select_reg_v ; //I HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_chp_target_cfg_ldb_cq2vas_reg_load ; //I HQM_CHP_TARGET_CFG_LDB_CQ2VAS
logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq2vas_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ2VAS
logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq2vas_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ2VAS
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0
logic hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_v ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1
logic hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_v ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_expired0_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_expired1_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_irq0_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_irq1_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_run_timer0_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_run_timer1_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_urgent0_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_urgent1_status ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1
logic hqm_chp_target_cfg_ldb_cq_int_enb_reg_load ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB
logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_enb_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB
logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_enb_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB
logic hqm_chp_target_cfg_ldb_cq_int_mask_reg_load ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_mask_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_mask_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK
logic hqm_chp_target_cfg_ldb_cq_irq_pending_reg_load ; //I HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_irq_pending_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL
logic hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_v ; //I HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL
logic hqm_chp_target_cfg_ldb_cq_wd_enb_reg_load ; //I HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB
logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdrt_0_status ; //I HQM_CHP_TARGET_CFG_LDB_WDRT_0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdrt_1_status ; //I HQM_CHP_TARGET_CFG_LDB_WDRT_1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_0_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_WDTO_0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_0_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_WDTO_0
logic hqm_chp_target_cfg_ldb_wdto_0_reg_load ; //I HQM_CHP_TARGET_CFG_LDB_WDTO_0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_1_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_WDTO_1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_1_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_WDTO_1
logic hqm_chp_target_cfg_ldb_wdto_1_reg_load ; //I HQM_CHP_TARGET_CFG_LDB_WDTO_1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable0_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable0_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable1_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable1_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_enb_interval_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL
logic hqm_chp_target_cfg_ldb_wd_enb_interval_reg_v ; //I HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_irq0_status ; //I HQM_CHP_TARGET_CFG_LDB_WD_IRQ0
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_irq1_status ; //I HQM_CHP_TARGET_CFG_LDB_WD_IRQ1
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_threshold_reg_nxt ; //I HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_threshold_reg_f ; //O HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD
logic hqm_chp_target_cfg_ldb_wd_threshold_reg_v ; //I HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_patch_control_reg_nxt ; //I HQM_CHP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_patch_control_reg_f ; //O HQM_CHP_TARGET_CFG_PATCH_CONTROL
logic hqm_chp_target_cfg_patch_control_reg_v ; //I HQM_CHP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_pipe_health_hold_status ; //I HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_pipe_health_valid_status ; //I HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_retn_zero_status ; //I HQM_CHP_TARGET_CFG_RETN_ZERO
logic hqm_chp_target_cfg_syndrome_00_capture_v ; //I HQM_CHP_TARGET_CFG_SYNDROME_00
logic [ ( 31 ) - 1 : 0] hqm_chp_target_cfg_syndrome_00_capture_data ; //I HQM_CHP_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_syndrome_00_syndrome_data ; //I HQM_CHP_TARGET_CFG_SYNDROME_00
logic hqm_chp_target_cfg_syndrome_01_capture_v ; //I HQM_CHP_TARGET_CFG_SYNDROME_01
logic [ ( 31 ) - 1 : 0] hqm_chp_target_cfg_syndrome_01_capture_data ; //I HQM_CHP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_syndrome_01_syndrome_data ; //I HQM_CHP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_idle_reg_nxt ; //I HQM_CHP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_idle_reg_f ; //O HQM_CHP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_timeout_reg_nxt ; //I HQM_CHP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_timeout_reg_f ; //O HQM_CHP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_version_status ; //I HQM_CHP_TARGET_CFG_UNIT_VERSION
logic hqm_chp_target_cfg_vas_credit_count_reg_load ; //I HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT
logic [ ( 1 * 17 * 32 ) - 1 : 0] hqm_chp_target_cfg_vas_credit_count_reg_nxt ; //I HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT
logic [ ( 1 * 17 * 32 ) - 1 : 0] hqm_chp_target_cfg_vas_credit_count_reg_f ; //O HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT
hqm_credit_hist_pipe_register_pfcsr i_hqm_credit_hist_pipe_register_pfcsr (
  .hqm_gated_clk ( hqm_gated_clk ) 
, .hqm_gated_rst_n ( hqm_gated_rst_n ) 
, .rst_prep ( '0 )
, .cfg_req_write ( pfcsr_cfg_req_write )
, .cfg_req_read ( pfcsr_cfg_req_read )
, .cfg_req ( pfcsr_cfg_req )
, .cfg_rsp_ack ( pfcsr_cfg_rsp_ack )
, .cfg_rsp_err ( pfcsr_cfg_rsp_err )
, .cfg_rsp_rdata ( pfcsr_cfg_rsp_rdata )
, .hqm_chp_target_cfg_chp_cnt_atm_qe_sch_en ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_en )
, .hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clr ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clr )
, .hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clrv ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clrv )
, .hqm_chp_target_cfg_chp_cnt_atm_qe_sch_inc ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_inc )
, .hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count )
, .hqm_chp_target_cfg_chp_cnt_atq_to_atm_en ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_en )
, .hqm_chp_target_cfg_chp_cnt_atq_to_atm_clr ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_clr )
, .hqm_chp_target_cfg_chp_cnt_atq_to_atm_clrv ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_clrv )
, .hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc )
, .hqm_chp_target_cfg_chp_cnt_atq_to_atm_count ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_count )
, .hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_en ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_en )
, .hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clr ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clr )
, .hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clrv ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clrv )
, .hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_inc ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_inc )
, .hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count )
, .hqm_chp_target_cfg_chp_cnt_dir_qe_sch_en ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_en )
, .hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clr ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clr )
, .hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clrv ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clrv )
, .hqm_chp_target_cfg_chp_cnt_dir_qe_sch_inc ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_inc )
, .hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count )
, .hqm_chp_target_cfg_chp_cnt_frag_replayed_en ( hqm_chp_target_cfg_chp_cnt_frag_replayed_en )
, .hqm_chp_target_cfg_chp_cnt_frag_replayed_clr ( hqm_chp_target_cfg_chp_cnt_frag_replayed_clr )
, .hqm_chp_target_cfg_chp_cnt_frag_replayed_clrv ( hqm_chp_target_cfg_chp_cnt_frag_replayed_clrv )
, .hqm_chp_target_cfg_chp_cnt_frag_replayed_inc ( hqm_chp_target_cfg_chp_cnt_frag_replayed_inc )
, .hqm_chp_target_cfg_chp_cnt_frag_replayed_count ( hqm_chp_target_cfg_chp_cnt_frag_replayed_count )
, .hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_en ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_en )
, .hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clr ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clr )
, .hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clrv ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clrv )
, .hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_inc ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_inc )
, .hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count )
, .hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_en ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_en )
, .hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clr ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clr )
, .hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clrv ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clrv )
, .hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_inc ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_inc )
, .hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count )
, .hqm_chp_target_cfg_chp_correctible_count_en ( hqm_chp_target_cfg_chp_correctible_count_en )
, .hqm_chp_target_cfg_chp_correctible_count_clr ( hqm_chp_target_cfg_chp_correctible_count_clr )
, .hqm_chp_target_cfg_chp_correctible_count_clrv ( hqm_chp_target_cfg_chp_correctible_count_clrv )
, .hqm_chp_target_cfg_chp_correctible_count_inc ( hqm_chp_target_cfg_chp_correctible_count_inc )
, .hqm_chp_target_cfg_chp_correctible_count_count ( hqm_chp_target_cfg_chp_correctible_count_count )
, .hqm_chp_target_cfg_chp_csr_control_reg_nxt ( hqm_chp_target_cfg_chp_csr_control_reg_nxt )
, .hqm_chp_target_cfg_chp_csr_control_reg_f ( hqm_chp_target_cfg_chp_csr_control_reg_f )
, .hqm_chp_target_cfg_chp_csr_control_reg_v (  hqm_chp_target_cfg_chp_csr_control_reg_v )
, .hqm_chp_target_cfg_chp_frag_count_reg_load ( hqm_chp_target_cfg_chp_frag_count_reg_load )
, .hqm_chp_target_cfg_chp_frag_count_reg_nxt ( hqm_chp_target_cfg_chp_frag_count_reg_nxt )
, .hqm_chp_target_cfg_chp_frag_count_reg_f ( hqm_chp_target_cfg_chp_frag_count_reg_f )
, .hqm_chp_target_cfg_chp_palb_control_reg_nxt ( hqm_chp_target_cfg_chp_palb_control_reg_nxt )
, .hqm_chp_target_cfg_chp_palb_control_reg_f ( hqm_chp_target_cfg_chp_palb_control_reg_f )
, .hqm_chp_target_cfg_chp_palb_control_reg_v (  hqm_chp_target_cfg_chp_palb_control_reg_v )
, .hqm_chp_target_cfg_chp_smon_disable_smon ( hqm_chp_target_cfg_chp_smon_disable_smon )
, .hqm_chp_target_cfg_chp_smon_smon_v ( hqm_chp_target_cfg_chp_smon_smon_v )
, .hqm_chp_target_cfg_chp_smon_smon_comp ( hqm_chp_target_cfg_chp_smon_smon_comp )
, .hqm_chp_target_cfg_chp_smon_smon_val ( hqm_chp_target_cfg_chp_smon_smon_val )
, .hqm_chp_target_cfg_chp_smon_smon_enabled ( hqm_chp_target_cfg_chp_smon_smon_enabled )
, .hqm_chp_target_cfg_chp_smon_smon_interrupt ( hqm_chp_target_cfg_chp_smon_smon_interrupt )
, .hqm_chp_target_cfg_control_diagnostic_00_reg_nxt ( hqm_chp_target_cfg_control_diagnostic_00_reg_nxt )
, .hqm_chp_target_cfg_control_diagnostic_00_reg_f ( hqm_chp_target_cfg_control_diagnostic_00_reg_f )
, .hqm_chp_target_cfg_control_diagnostic_01_reg_nxt ( hqm_chp_target_cfg_control_diagnostic_01_reg_nxt )
, .hqm_chp_target_cfg_control_diagnostic_01_reg_f ( hqm_chp_target_cfg_control_diagnostic_01_reg_f )
, .hqm_chp_target_cfg_control_diagnostic_02_reg_nxt ( hqm_chp_target_cfg_control_diagnostic_02_reg_nxt )
, .hqm_chp_target_cfg_control_diagnostic_02_reg_f ( hqm_chp_target_cfg_control_diagnostic_02_reg_f )
, .hqm_chp_target_cfg_control_general_00_reg_nxt ( hqm_chp_target_cfg_control_general_00_reg_nxt )
, .hqm_chp_target_cfg_control_general_00_reg_f ( hqm_chp_target_cfg_control_general_00_reg_f )
, .hqm_chp_target_cfg_control_general_00_reg_v (  hqm_chp_target_cfg_control_general_00_reg_v )
, .hqm_chp_target_cfg_control_general_01_reg_nxt ( hqm_chp_target_cfg_control_general_01_reg_nxt )
, .hqm_chp_target_cfg_control_general_01_reg_f ( hqm_chp_target_cfg_control_general_01_reg_f )
, .hqm_chp_target_cfg_control_general_01_reg_v (  hqm_chp_target_cfg_control_general_01_reg_v )
, .hqm_chp_target_cfg_control_general_02_reg_nxt ( hqm_chp_target_cfg_control_general_02_reg_nxt )
, .hqm_chp_target_cfg_control_general_02_reg_f ( hqm_chp_target_cfg_control_general_02_reg_f )
, .hqm_chp_target_cfg_control_general_02_reg_v (  hqm_chp_target_cfg_control_general_02_reg_v )
, .hqm_chp_target_cfg_counter_chp_error_drop_en ( hqm_chp_target_cfg_counter_chp_error_drop_en )
, .hqm_chp_target_cfg_counter_chp_error_drop_clr ( hqm_chp_target_cfg_counter_chp_error_drop_clr )
, .hqm_chp_target_cfg_counter_chp_error_drop_clrv ( hqm_chp_target_cfg_counter_chp_error_drop_clrv )
, .hqm_chp_target_cfg_counter_chp_error_drop_inc ( hqm_chp_target_cfg_counter_chp_error_drop_inc )
, .hqm_chp_target_cfg_counter_chp_error_drop_count ( hqm_chp_target_cfg_counter_chp_error_drop_count )
, .hqm_chp_target_cfg_db_fifo_status_0_status ( hqm_chp_target_cfg_db_fifo_status_0_status )
, .hqm_chp_target_cfg_db_fifo_status_1_status ( hqm_chp_target_cfg_db_fifo_status_1_status )
, .hqm_chp_target_cfg_db_fifo_status_2_status ( hqm_chp_target_cfg_db_fifo_status_2_status )
, .hqm_chp_target_cfg_db_fifo_status_3_status ( hqm_chp_target_cfg_db_fifo_status_3_status )
, .hqm_chp_target_cfg_diagnostic_aw_status_0_status ( hqm_chp_target_cfg_diagnostic_aw_status_0_status )
, .hqm_chp_target_cfg_dir_cq2vas_reg_load ( hqm_chp_target_cfg_dir_cq2vas_reg_load )
, .hqm_chp_target_cfg_dir_cq2vas_reg_nxt ( hqm_chp_target_cfg_dir_cq2vas_reg_nxt )
, .hqm_chp_target_cfg_dir_cq2vas_reg_f ( hqm_chp_target_cfg_dir_cq2vas_reg_f )
, .hqm_chp_target_cfg_dir_cq_intr_armed0_reg_nxt ( hqm_chp_target_cfg_dir_cq_intr_armed0_reg_nxt )
, .hqm_chp_target_cfg_dir_cq_intr_armed0_reg_f ( hqm_chp_target_cfg_dir_cq_intr_armed0_reg_f )
, .hqm_chp_target_cfg_dir_cq_intr_armed0_reg_v (  hqm_chp_target_cfg_dir_cq_intr_armed0_reg_v )
, .hqm_chp_target_cfg_dir_cq_intr_armed1_reg_nxt ( hqm_chp_target_cfg_dir_cq_intr_armed1_reg_nxt )
, .hqm_chp_target_cfg_dir_cq_intr_armed1_reg_f ( hqm_chp_target_cfg_dir_cq_intr_armed1_reg_f )
, .hqm_chp_target_cfg_dir_cq_intr_armed1_reg_v (  hqm_chp_target_cfg_dir_cq_intr_armed1_reg_v )
, .hqm_chp_target_cfg_dir_cq_intr_expired0_status ( hqm_chp_target_cfg_dir_cq_intr_expired0_status )
, .hqm_chp_target_cfg_dir_cq_intr_expired1_status ( hqm_chp_target_cfg_dir_cq_intr_expired1_status )
, .hqm_chp_target_cfg_dir_cq_intr_irq0_status ( hqm_chp_target_cfg_dir_cq_intr_irq0_status )
, .hqm_chp_target_cfg_dir_cq_intr_irq1_status ( hqm_chp_target_cfg_dir_cq_intr_irq1_status )
, .hqm_chp_target_cfg_dir_cq_intr_run_timer0_status ( hqm_chp_target_cfg_dir_cq_intr_run_timer0_status )
, .hqm_chp_target_cfg_dir_cq_intr_run_timer1_status ( hqm_chp_target_cfg_dir_cq_intr_run_timer1_status )
, .hqm_chp_target_cfg_dir_cq_intr_urgent0_status ( hqm_chp_target_cfg_dir_cq_intr_urgent0_status )
, .hqm_chp_target_cfg_dir_cq_intr_urgent1_status ( hqm_chp_target_cfg_dir_cq_intr_urgent1_status )
, .hqm_chp_target_cfg_dir_cq_int_enb_reg_load ( hqm_chp_target_cfg_dir_cq_int_enb_reg_load )
, .hqm_chp_target_cfg_dir_cq_int_enb_reg_nxt ( hqm_chp_target_cfg_dir_cq_int_enb_reg_nxt )
, .hqm_chp_target_cfg_dir_cq_int_enb_reg_f ( hqm_chp_target_cfg_dir_cq_int_enb_reg_f )
, .hqm_chp_target_cfg_dir_cq_int_mask_reg_load ( hqm_chp_target_cfg_dir_cq_int_mask_reg_load )
, .hqm_chp_target_cfg_dir_cq_int_mask_reg_nxt ( hqm_chp_target_cfg_dir_cq_int_mask_reg_nxt )
, .hqm_chp_target_cfg_dir_cq_int_mask_reg_f ( hqm_chp_target_cfg_dir_cq_int_mask_reg_f )
, .hqm_chp_target_cfg_dir_cq_irq_pending_reg_load ( hqm_chp_target_cfg_dir_cq_irq_pending_reg_load )
, .hqm_chp_target_cfg_dir_cq_irq_pending_reg_nxt ( hqm_chp_target_cfg_dir_cq_irq_pending_reg_nxt )
, .hqm_chp_target_cfg_dir_cq_irq_pending_reg_f ( hqm_chp_target_cfg_dir_cq_irq_pending_reg_f )
, .hqm_chp_target_cfg_dir_cq_timer_ctl_reg_nxt ( hqm_chp_target_cfg_dir_cq_timer_ctl_reg_nxt )
, .hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f ( hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f )
, .hqm_chp_target_cfg_dir_cq_timer_ctl_reg_v (  hqm_chp_target_cfg_dir_cq_timer_ctl_reg_v )
, .hqm_chp_target_cfg_dir_cq_wd_enb_reg_load ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_load )
, .hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt )
, .hqm_chp_target_cfg_dir_cq_wd_enb_reg_f ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_f )
, .hqm_chp_target_cfg_dir_wdrt_0_status ( hqm_chp_target_cfg_dir_wdrt_0_status )
, .hqm_chp_target_cfg_dir_wdrt_1_status ( hqm_chp_target_cfg_dir_wdrt_1_status )
, .hqm_chp_target_cfg_dir_wdto_0_reg_nxt ( hqm_chp_target_cfg_dir_wdto_0_reg_nxt )
, .hqm_chp_target_cfg_dir_wdto_0_reg_f ( hqm_chp_target_cfg_dir_wdto_0_reg_f )
, .hqm_chp_target_cfg_dir_wdto_0_reg_load (  hqm_chp_target_cfg_dir_wdto_0_reg_load )
, .hqm_chp_target_cfg_dir_wdto_1_reg_nxt ( hqm_chp_target_cfg_dir_wdto_1_reg_nxt )
, .hqm_chp_target_cfg_dir_wdto_1_reg_f ( hqm_chp_target_cfg_dir_wdto_1_reg_f )
, .hqm_chp_target_cfg_dir_wdto_1_reg_load (  hqm_chp_target_cfg_dir_wdto_1_reg_load )
, .hqm_chp_target_cfg_dir_wd_disable0_reg_nxt ( hqm_chp_target_cfg_dir_wd_disable0_reg_nxt )
, .hqm_chp_target_cfg_dir_wd_disable0_reg_f ( hqm_chp_target_cfg_dir_wd_disable0_reg_f )
, .hqm_chp_target_cfg_dir_wd_disable1_reg_nxt ( hqm_chp_target_cfg_dir_wd_disable1_reg_nxt )
, .hqm_chp_target_cfg_dir_wd_disable1_reg_f ( hqm_chp_target_cfg_dir_wd_disable1_reg_f )
, .hqm_chp_target_cfg_dir_wd_enb_interval_reg_nxt ( hqm_chp_target_cfg_dir_wd_enb_interval_reg_nxt )
, .hqm_chp_target_cfg_dir_wd_enb_interval_reg_f ( hqm_chp_target_cfg_dir_wd_enb_interval_reg_f )
, .hqm_chp_target_cfg_dir_wd_enb_interval_reg_v (  hqm_chp_target_cfg_dir_wd_enb_interval_reg_v )
, .hqm_chp_target_cfg_dir_wd_irq0_status ( hqm_chp_target_cfg_dir_wd_irq0_status )
, .hqm_chp_target_cfg_dir_wd_irq1_status ( hqm_chp_target_cfg_dir_wd_irq1_status )
, .hqm_chp_target_cfg_dir_wd_threshold_reg_nxt ( hqm_chp_target_cfg_dir_wd_threshold_reg_nxt )
, .hqm_chp_target_cfg_dir_wd_threshold_reg_f ( hqm_chp_target_cfg_dir_wd_threshold_reg_f )
, .hqm_chp_target_cfg_dir_wd_threshold_reg_v (  hqm_chp_target_cfg_dir_wd_threshold_reg_v )
, .hqm_chp_target_cfg_hist_list_mode_reg_load ( hqm_chp_target_cfg_hist_list_mode_reg_load )
, .hqm_chp_target_cfg_hist_list_mode_reg_nxt ( hqm_chp_target_cfg_hist_list_mode_reg_nxt )
, .hqm_chp_target_cfg_hist_list_mode_reg_f ( hqm_chp_target_cfg_hist_list_mode_reg_f )
, .hqm_chp_target_cfg_hw_agitate_control_reg_nxt ( hqm_chp_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_chp_target_cfg_hw_agitate_control_reg_f ( hqm_chp_target_cfg_hw_agitate_control_reg_f )
, .hqm_chp_target_cfg_hw_agitate_control_reg_v (  hqm_chp_target_cfg_hw_agitate_control_reg_v )
, .hqm_chp_target_cfg_hw_agitate_select_reg_nxt ( hqm_chp_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_chp_target_cfg_hw_agitate_select_reg_f ( hqm_chp_target_cfg_hw_agitate_select_reg_f )
, .hqm_chp_target_cfg_hw_agitate_select_reg_v (  hqm_chp_target_cfg_hw_agitate_select_reg_v )
, .hqm_chp_target_cfg_ldb_cq2vas_reg_load ( hqm_chp_target_cfg_ldb_cq2vas_reg_load )
, .hqm_chp_target_cfg_ldb_cq2vas_reg_nxt ( hqm_chp_target_cfg_ldb_cq2vas_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq2vas_reg_f ( hqm_chp_target_cfg_ldb_cq2vas_reg_f )
, .hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_nxt ( hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_f ( hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_f )
, .hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_v (  hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_v )
, .hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_nxt ( hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_f ( hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_f )
, .hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_v (  hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_v )
, .hqm_chp_target_cfg_ldb_cq_intr_expired0_status ( hqm_chp_target_cfg_ldb_cq_intr_expired0_status )
, .hqm_chp_target_cfg_ldb_cq_intr_expired1_status ( hqm_chp_target_cfg_ldb_cq_intr_expired1_status )
, .hqm_chp_target_cfg_ldb_cq_intr_irq0_status ( hqm_chp_target_cfg_ldb_cq_intr_irq0_status )
, .hqm_chp_target_cfg_ldb_cq_intr_irq1_status ( hqm_chp_target_cfg_ldb_cq_intr_irq1_status )
, .hqm_chp_target_cfg_ldb_cq_intr_run_timer0_status ( hqm_chp_target_cfg_ldb_cq_intr_run_timer0_status )
, .hqm_chp_target_cfg_ldb_cq_intr_run_timer1_status ( hqm_chp_target_cfg_ldb_cq_intr_run_timer1_status )
, .hqm_chp_target_cfg_ldb_cq_intr_urgent0_status ( hqm_chp_target_cfg_ldb_cq_intr_urgent0_status )
, .hqm_chp_target_cfg_ldb_cq_intr_urgent1_status ( hqm_chp_target_cfg_ldb_cq_intr_urgent1_status )
, .hqm_chp_target_cfg_ldb_cq_int_enb_reg_load ( hqm_chp_target_cfg_ldb_cq_int_enb_reg_load )
, .hqm_chp_target_cfg_ldb_cq_int_enb_reg_nxt ( hqm_chp_target_cfg_ldb_cq_int_enb_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq_int_enb_reg_f ( hqm_chp_target_cfg_ldb_cq_int_enb_reg_f )
, .hqm_chp_target_cfg_ldb_cq_int_mask_reg_load ( hqm_chp_target_cfg_ldb_cq_int_mask_reg_load )
, .hqm_chp_target_cfg_ldb_cq_int_mask_reg_nxt ( hqm_chp_target_cfg_ldb_cq_int_mask_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq_int_mask_reg_f ( hqm_chp_target_cfg_ldb_cq_int_mask_reg_f )
, .hqm_chp_target_cfg_ldb_cq_irq_pending_reg_load ( hqm_chp_target_cfg_ldb_cq_irq_pending_reg_load )
, .hqm_chp_target_cfg_ldb_cq_irq_pending_reg_nxt ( hqm_chp_target_cfg_ldb_cq_irq_pending_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f ( hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f )
, .hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_nxt ( hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f ( hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f )
, .hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_v (  hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_v )
, .hqm_chp_target_cfg_ldb_cq_wd_enb_reg_load ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_load )
, .hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt )
, .hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f )
, .hqm_chp_target_cfg_ldb_wdrt_0_status ( hqm_chp_target_cfg_ldb_wdrt_0_status )
, .hqm_chp_target_cfg_ldb_wdrt_1_status ( hqm_chp_target_cfg_ldb_wdrt_1_status )
, .hqm_chp_target_cfg_ldb_wdto_0_reg_nxt ( hqm_chp_target_cfg_ldb_wdto_0_reg_nxt )
, .hqm_chp_target_cfg_ldb_wdto_0_reg_f ( hqm_chp_target_cfg_ldb_wdto_0_reg_f )
, .hqm_chp_target_cfg_ldb_wdto_0_reg_load (  hqm_chp_target_cfg_ldb_wdto_0_reg_load )
, .hqm_chp_target_cfg_ldb_wdto_1_reg_nxt ( hqm_chp_target_cfg_ldb_wdto_1_reg_nxt )
, .hqm_chp_target_cfg_ldb_wdto_1_reg_f ( hqm_chp_target_cfg_ldb_wdto_1_reg_f )
, .hqm_chp_target_cfg_ldb_wdto_1_reg_load (  hqm_chp_target_cfg_ldb_wdto_1_reg_load )
, .hqm_chp_target_cfg_ldb_wd_disable0_reg_nxt ( hqm_chp_target_cfg_ldb_wd_disable0_reg_nxt )
, .hqm_chp_target_cfg_ldb_wd_disable0_reg_f ( hqm_chp_target_cfg_ldb_wd_disable0_reg_f )
, .hqm_chp_target_cfg_ldb_wd_disable1_reg_nxt ( hqm_chp_target_cfg_ldb_wd_disable1_reg_nxt )
, .hqm_chp_target_cfg_ldb_wd_disable1_reg_f ( hqm_chp_target_cfg_ldb_wd_disable1_reg_f )
, .hqm_chp_target_cfg_ldb_wd_enb_interval_reg_nxt ( hqm_chp_target_cfg_ldb_wd_enb_interval_reg_nxt )
, .hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f ( hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f )
, .hqm_chp_target_cfg_ldb_wd_enb_interval_reg_v (  hqm_chp_target_cfg_ldb_wd_enb_interval_reg_v )
, .hqm_chp_target_cfg_ldb_wd_irq0_status ( hqm_chp_target_cfg_ldb_wd_irq0_status )
, .hqm_chp_target_cfg_ldb_wd_irq1_status ( hqm_chp_target_cfg_ldb_wd_irq1_status )
, .hqm_chp_target_cfg_ldb_wd_threshold_reg_nxt ( hqm_chp_target_cfg_ldb_wd_threshold_reg_nxt )
, .hqm_chp_target_cfg_ldb_wd_threshold_reg_f ( hqm_chp_target_cfg_ldb_wd_threshold_reg_f )
, .hqm_chp_target_cfg_ldb_wd_threshold_reg_v (  hqm_chp_target_cfg_ldb_wd_threshold_reg_v )
, .hqm_chp_target_cfg_patch_control_reg_nxt ( hqm_chp_target_cfg_patch_control_reg_nxt )
, .hqm_chp_target_cfg_patch_control_reg_f ( hqm_chp_target_cfg_patch_control_reg_f )
, .hqm_chp_target_cfg_patch_control_reg_v (  hqm_chp_target_cfg_patch_control_reg_v )
, .hqm_chp_target_cfg_pipe_health_hold_status ( hqm_chp_target_cfg_pipe_health_hold_status )
, .hqm_chp_target_cfg_pipe_health_valid_status ( hqm_chp_target_cfg_pipe_health_valid_status )
, .hqm_chp_target_cfg_retn_zero_status ( hqm_chp_target_cfg_retn_zero_status )
, .hqm_chp_target_cfg_syndrome_00_capture_v ( hqm_chp_target_cfg_syndrome_00_capture_v )
, .hqm_chp_target_cfg_syndrome_00_capture_data ( hqm_chp_target_cfg_syndrome_00_capture_data )
, .hqm_chp_target_cfg_syndrome_00_syndrome_data ( hqm_chp_target_cfg_syndrome_00_syndrome_data )
, .hqm_chp_target_cfg_syndrome_01_capture_v ( hqm_chp_target_cfg_syndrome_01_capture_v )
, .hqm_chp_target_cfg_syndrome_01_capture_data ( hqm_chp_target_cfg_syndrome_01_capture_data )
, .hqm_chp_target_cfg_syndrome_01_syndrome_data ( hqm_chp_target_cfg_syndrome_01_syndrome_data )
, .hqm_chp_target_cfg_unit_idle_reg_nxt ( hqm_chp_target_cfg_unit_idle_reg_nxt )
, .hqm_chp_target_cfg_unit_idle_reg_f ( hqm_chp_target_cfg_unit_idle_reg_f )
, .hqm_chp_target_cfg_unit_timeout_reg_nxt ( hqm_chp_target_cfg_unit_timeout_reg_nxt )
, .hqm_chp_target_cfg_unit_timeout_reg_f ( hqm_chp_target_cfg_unit_timeout_reg_f )
, .hqm_chp_target_cfg_unit_version_status ( hqm_chp_target_cfg_unit_version_status )
, .hqm_chp_target_cfg_vas_credit_count_reg_load ( hqm_chp_target_cfg_vas_credit_count_reg_load )
, .hqm_chp_target_cfg_vas_credit_count_reg_nxt ( hqm_chp_target_cfg_vas_credit_count_reg_nxt )
, .hqm_chp_target_cfg_vas_credit_count_reg_f ( hqm_chp_target_cfg_vas_credit_count_reg_f )
) ;
// END HQM_CFG_ACCESS
// BEGIN HQM_RAM_ACCESS
localparam NUM_CFG_ACCESSIBLE_RAM = 30;
localparam CFG_ACCESSIBLE_RAM_FREELIST_0 = 0; // HQM_CHP_TARGET_CFG_FREELIST_0
localparam CFG_ACCESSIBLE_RAM_FREELIST_1 = 1; // HQM_CHP_TARGET_CFG_FREELIST_1
localparam CFG_ACCESSIBLE_RAM_CMP_ID_CHK_ENBL_MEM = 10; // HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL
localparam CFG_ACCESSIBLE_RAM_COUNT_RMW_PIPE_DIR_MEM = 11; // HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT
localparam CFG_ACCESSIBLE_RAM_COUNT_RMW_PIPE_LDB_MEM = 12; // HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT
localparam CFG_ACCESSIBLE_RAM_DIR_CQ_DEPTH = 13; // HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH
localparam CFG_ACCESSIBLE_RAM_DIR_CQ_INTR_THRESH = 14; // HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH
localparam CFG_ACCESSIBLE_RAM_DIR_CQ_TOKEN_DEPTH_SELECT = 15; // HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT
localparam CFG_ACCESSIBLE_RAM_DIR_CQ_WPTR = 16; // HQM_CHP_TARGET_CFG_DIR_CQ_WPTR
localparam CFG_ACCESSIBLE_RAM_HIST_LIST_A_MINMAX = 17; // HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT
localparam CFG_ACCESSIBLE_RAM_HIST_LIST_A_PTR = 18; // HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR
localparam CFG_ACCESSIBLE_RAM_HIST_LIST_MINMAX = 19; // HQM_CHP_TARGET_CFG_HIST_LIST_BASE HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT
localparam CFG_ACCESSIBLE_RAM_FREELIST_2 = 2; // HQM_CHP_TARGET_CFG_FREELIST_2
localparam CFG_ACCESSIBLE_RAM_HIST_LIST_PTR = 20; // HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR
localparam CFG_ACCESSIBLE_RAM_LDB_CQ_DEPTH = 21; // HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH
localparam CFG_ACCESSIBLE_RAM_LDB_CQ_INTR_THRESH = 22; // HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH
localparam CFG_ACCESSIBLE_RAM_LDB_CQ_ON_OFF_THRESHOLD = 23; // HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD
localparam CFG_ACCESSIBLE_RAM_LDB_CQ_TOKEN_DEPTH_SELECT = 24; // HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT
localparam CFG_ACCESSIBLE_RAM_LDB_CQ_WPTR = 25; // HQM_CHP_TARGET_CFG_LDB_CQ_WPTR
localparam CFG_ACCESSIBLE_RAM_ORD_QID_SN = 26; // HQM_CHP_TARGET_CFG_ORD_QID_SN
localparam CFG_ACCESSIBLE_RAM_ORD_QID_SN_MAP = 27; // HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP
localparam CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_DIR_MEM = 28; // HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD
localparam CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_LDB_MEM = 29; // HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD
localparam CFG_ACCESSIBLE_RAM_FREELIST_3 = 3; // HQM_CHP_TARGET_CFG_FREELIST_3
localparam CFG_ACCESSIBLE_RAM_FREELIST_4 = 4; // HQM_CHP_TARGET_CFG_FREELIST_4
localparam CFG_ACCESSIBLE_RAM_FREELIST_5 = 5; // HQM_CHP_TARGET_CFG_FREELIST_5
localparam CFG_ACCESSIBLE_RAM_FREELIST_6 = 6; // HQM_CHP_TARGET_CFG_FREELIST_6
localparam CFG_ACCESSIBLE_RAM_FREELIST_7 = 7; // HQM_CHP_TARGET_CFG_FREELIST_7
localparam CFG_ACCESSIBLE_RAM_HIST_LIST = 8; // HQM_CHP_TARGET_CFG_HIST_LIST_0 HQM_CHP_TARGET_CFG_HIST_LIST_1
localparam CFG_ACCESSIBLE_RAM_HIST_LIST_A = 9; // HQM_CHP_TARGET_CFG_HIST_LIST_A_0 HQM_CHP_TARGET_CFG_HIST_LIST_A_1
logic [( 30 *  1)-1:0] cfg_mem_re;
logic [( 30 *  1)-1:0] cfg_mem_we;
logic [(      20)-1:0] cfg_mem_addr;
logic [(      12)-1:0] cfg_mem_minbit;
logic [(      12)-1:0] cfg_mem_maxbit;
logic [(      32)-1:0] cfg_mem_wdata;
logic [( 30 * 32)-1:0] cfg_mem_rdata;
logic [( 30 *  1)-1:0] cfg_mem_ack;
logic                  cfg_mem_cc_v;
logic [(       8)-1:0] cfg_mem_cc_value;
logic [(       4)-1:0] cfg_mem_cc_width;
logic [(      12)-1:0] cfg_mem_cc_position;


logic                  hqm_credit_hist_pipe_rfw_top_ipar_error;

logic                  func_aqed_chp_sch_rx_sync_mem_re; //I
logic [(       2)-1:0] func_aqed_chp_sch_rx_sync_mem_raddr; //I
logic [(       2)-1:0] func_aqed_chp_sch_rx_sync_mem_waddr; //I
logic                  func_aqed_chp_sch_rx_sync_mem_we;    //I
logic [(     179)-1:0] func_aqed_chp_sch_rx_sync_mem_wdata; //I
logic [(     179)-1:0] func_aqed_chp_sch_rx_sync_mem_rdata;

logic                pf_aqed_chp_sch_rx_sync_mem_re;    //I
logic [(       2)-1:0] pf_aqed_chp_sch_rx_sync_mem_raddr; //I
logic [(       2)-1:0] pf_aqed_chp_sch_rx_sync_mem_waddr; //I
logic                  pf_aqed_chp_sch_rx_sync_mem_we;    //I
logic [(     179)-1:0] pf_aqed_chp_sch_rx_sync_mem_wdata; //I
logic [(     179)-1:0] pf_aqed_chp_sch_rx_sync_mem_rdata;

logic                  rf_aqed_chp_sch_rx_sync_mem_error;

logic                  func_chp_chp_rop_hcw_fifo_mem_re; //I
logic [(       4)-1:0] func_chp_chp_rop_hcw_fifo_mem_raddr; //I
logic [(       4)-1:0] func_chp_chp_rop_hcw_fifo_mem_waddr; //I
logic                  func_chp_chp_rop_hcw_fifo_mem_we;    //I
logic [(     201)-1:0] func_chp_chp_rop_hcw_fifo_mem_wdata; //I
logic [(     201)-1:0] func_chp_chp_rop_hcw_fifo_mem_rdata;

logic                pf_chp_chp_rop_hcw_fifo_mem_re;    //I
logic [(       4)-1:0] pf_chp_chp_rop_hcw_fifo_mem_raddr; //I
logic [(       4)-1:0] pf_chp_chp_rop_hcw_fifo_mem_waddr; //I
logic                  pf_chp_chp_rop_hcw_fifo_mem_we;    //I
logic [(     201)-1:0] pf_chp_chp_rop_hcw_fifo_mem_wdata; //I
logic [(     201)-1:0] pf_chp_chp_rop_hcw_fifo_mem_rdata;

logic                  rf_chp_chp_rop_hcw_fifo_mem_error;

logic                  func_chp_lsp_ap_cmp_fifo_mem_re; //I
logic [(       4)-1:0] func_chp_lsp_ap_cmp_fifo_mem_raddr; //I
logic [(       4)-1:0] func_chp_lsp_ap_cmp_fifo_mem_waddr; //I
logic                  func_chp_lsp_ap_cmp_fifo_mem_we;    //I
logic [(      74)-1:0] func_chp_lsp_ap_cmp_fifo_mem_wdata; //I
logic [(      74)-1:0] func_chp_lsp_ap_cmp_fifo_mem_rdata;

logic                pf_chp_lsp_ap_cmp_fifo_mem_re;    //I
logic [(       4)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_raddr; //I
logic [(       4)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_waddr; //I
logic                  pf_chp_lsp_ap_cmp_fifo_mem_we;    //I
logic [(      74)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_wdata; //I
logic [(      74)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_rdata;

logic                  rf_chp_lsp_ap_cmp_fifo_mem_error;

logic                  func_chp_lsp_tok_fifo_mem_re; //I
logic [(       4)-1:0] func_chp_lsp_tok_fifo_mem_raddr; //I
logic [(       4)-1:0] func_chp_lsp_tok_fifo_mem_waddr; //I
logic                  func_chp_lsp_tok_fifo_mem_we;    //I
logic [(      29)-1:0] func_chp_lsp_tok_fifo_mem_wdata; //I
logic [(      29)-1:0] func_chp_lsp_tok_fifo_mem_rdata;

logic                pf_chp_lsp_tok_fifo_mem_re;    //I
logic [(       4)-1:0] pf_chp_lsp_tok_fifo_mem_raddr; //I
logic [(       4)-1:0] pf_chp_lsp_tok_fifo_mem_waddr; //I
logic                  pf_chp_lsp_tok_fifo_mem_we;    //I
logic [(      29)-1:0] pf_chp_lsp_tok_fifo_mem_wdata; //I
logic [(      29)-1:0] pf_chp_lsp_tok_fifo_mem_rdata;

logic                  rf_chp_lsp_tok_fifo_mem_error;

logic                  func_chp_sys_tx_fifo_mem_re; //I
logic [(       3)-1:0] func_chp_sys_tx_fifo_mem_raddr; //I
logic [(       3)-1:0] func_chp_sys_tx_fifo_mem_waddr; //I
logic                  func_chp_sys_tx_fifo_mem_we;    //I
logic [(     200)-1:0] func_chp_sys_tx_fifo_mem_wdata; //I
logic [(     200)-1:0] func_chp_sys_tx_fifo_mem_rdata;

logic                pf_chp_sys_tx_fifo_mem_re;    //I
logic [(       3)-1:0] pf_chp_sys_tx_fifo_mem_raddr; //I
logic [(       3)-1:0] pf_chp_sys_tx_fifo_mem_waddr; //I
logic                  pf_chp_sys_tx_fifo_mem_we;    //I
logic [(     200)-1:0] pf_chp_sys_tx_fifo_mem_wdata; //I
logic [(     200)-1:0] pf_chp_sys_tx_fifo_mem_rdata;

logic                  rf_chp_sys_tx_fifo_mem_error;

logic                  func_cmp_id_chk_enbl_mem_re; //I
logic [(       6)-1:0] func_cmp_id_chk_enbl_mem_raddr; //I
logic [(       6)-1:0] func_cmp_id_chk_enbl_mem_waddr; //I
logic                  func_cmp_id_chk_enbl_mem_we;    //I
logic [(       2)-1:0] func_cmp_id_chk_enbl_mem_wdata; //I
logic [(       2)-1:0] func_cmp_id_chk_enbl_mem_rdata;

logic                pf_cmp_id_chk_enbl_mem_re;    //I
logic [(       6)-1:0] pf_cmp_id_chk_enbl_mem_raddr; //I
logic [(       6)-1:0] pf_cmp_id_chk_enbl_mem_waddr; //I
logic                  pf_cmp_id_chk_enbl_mem_we;    //I
logic [(       2)-1:0] pf_cmp_id_chk_enbl_mem_wdata; //I
logic [(       2)-1:0] pf_cmp_id_chk_enbl_mem_rdata;

logic                  rf_cmp_id_chk_enbl_mem_error;

logic                  func_count_rmw_pipe_dir_mem_re; //I
logic [(       6)-1:0] func_count_rmw_pipe_dir_mem_raddr; //I
logic [(       6)-1:0] func_count_rmw_pipe_dir_mem_waddr; //I
logic                  func_count_rmw_pipe_dir_mem_we;    //I
logic [(      16)-1:0] func_count_rmw_pipe_dir_mem_wdata; //I
logic [(      16)-1:0] func_count_rmw_pipe_dir_mem_rdata;

logic                pf_count_rmw_pipe_dir_mem_re;    //I
logic [(       6)-1:0] pf_count_rmw_pipe_dir_mem_raddr; //I
logic [(       6)-1:0] pf_count_rmw_pipe_dir_mem_waddr; //I
logic                  pf_count_rmw_pipe_dir_mem_we;    //I
logic [(      16)-1:0] pf_count_rmw_pipe_dir_mem_wdata; //I
logic [(      16)-1:0] pf_count_rmw_pipe_dir_mem_rdata;

logic                  rf_count_rmw_pipe_dir_mem_error;

logic                  func_count_rmw_pipe_ldb_mem_re; //I
logic [(       6)-1:0] func_count_rmw_pipe_ldb_mem_raddr; //I
logic [(       6)-1:0] func_count_rmw_pipe_ldb_mem_waddr; //I
logic                  func_count_rmw_pipe_ldb_mem_we;    //I
logic [(      16)-1:0] func_count_rmw_pipe_ldb_mem_wdata; //I
logic [(      16)-1:0] func_count_rmw_pipe_ldb_mem_rdata;

logic                pf_count_rmw_pipe_ldb_mem_re;    //I
logic [(       6)-1:0] pf_count_rmw_pipe_ldb_mem_raddr; //I
logic [(       6)-1:0] pf_count_rmw_pipe_ldb_mem_waddr; //I
logic                  pf_count_rmw_pipe_ldb_mem_we;    //I
logic [(      16)-1:0] pf_count_rmw_pipe_ldb_mem_wdata; //I
logic [(      16)-1:0] pf_count_rmw_pipe_ldb_mem_rdata;

logic                  rf_count_rmw_pipe_ldb_mem_error;

logic                  func_count_rmw_pipe_wd_dir_mem_re; //I
logic [(       6)-1:0] func_count_rmw_pipe_wd_dir_mem_raddr; //I
logic [(       6)-1:0] func_count_rmw_pipe_wd_dir_mem_waddr; //I
logic                  func_count_rmw_pipe_wd_dir_mem_we;    //I
logic [(      10)-1:0] func_count_rmw_pipe_wd_dir_mem_wdata; //I
logic [(      10)-1:0] func_count_rmw_pipe_wd_dir_mem_rdata;

logic                pf_count_rmw_pipe_wd_dir_mem_re;    //I
logic [(       6)-1:0] pf_count_rmw_pipe_wd_dir_mem_raddr; //I
logic [(       6)-1:0] pf_count_rmw_pipe_wd_dir_mem_waddr; //I
logic                  pf_count_rmw_pipe_wd_dir_mem_we;    //I
logic [(      10)-1:0] pf_count_rmw_pipe_wd_dir_mem_wdata; //I
logic [(      10)-1:0] pf_count_rmw_pipe_wd_dir_mem_rdata;

logic                  rf_count_rmw_pipe_wd_dir_mem_error;

logic                  func_count_rmw_pipe_wd_ldb_mem_re; //I
logic [(       6)-1:0] func_count_rmw_pipe_wd_ldb_mem_raddr; //I
logic [(       6)-1:0] func_count_rmw_pipe_wd_ldb_mem_waddr; //I
logic                  func_count_rmw_pipe_wd_ldb_mem_we;    //I
logic [(      10)-1:0] func_count_rmw_pipe_wd_ldb_mem_wdata; //I
logic [(      10)-1:0] func_count_rmw_pipe_wd_ldb_mem_rdata;

logic                pf_count_rmw_pipe_wd_ldb_mem_re;    //I
logic [(       6)-1:0] pf_count_rmw_pipe_wd_ldb_mem_raddr; //I
logic [(       6)-1:0] pf_count_rmw_pipe_wd_ldb_mem_waddr; //I
logic                  pf_count_rmw_pipe_wd_ldb_mem_we;    //I
logic [(      10)-1:0] pf_count_rmw_pipe_wd_ldb_mem_wdata; //I
logic [(      10)-1:0] pf_count_rmw_pipe_wd_ldb_mem_rdata;

logic                  rf_count_rmw_pipe_wd_ldb_mem_error;

logic                  func_dir_cq_depth_re; //I
logic [(       6)-1:0] func_dir_cq_depth_raddr; //I
logic [(       6)-1:0] func_dir_cq_depth_waddr; //I
logic                  func_dir_cq_depth_we;    //I
chp_dir_cq_depth_t     func_dir_cq_depth_wdata; //I
chp_dir_cq_depth_t     func_dir_cq_depth_rdata;

logic                pf_dir_cq_depth_re;    //I
logic [(       6)-1:0] pf_dir_cq_depth_raddr; //I
logic [(       6)-1:0] pf_dir_cq_depth_waddr; //I
logic                  pf_dir_cq_depth_we;    //I
chp_dir_cq_depth_t     pf_dir_cq_depth_wdata; //I
chp_dir_cq_depth_t     pf_dir_cq_depth_rdata;

chp_dir_cq_depth_t            rf_dir_cq_depth_wdata_struct;
chp_dir_cq_depth_t            rf_dir_cq_depth_rdata_struct;
logic                  rf_dir_cq_depth_error;

logic                  func_dir_cq_intr_thresh_re; //I
logic [(       6)-1:0] func_dir_cq_intr_thresh_raddr; //I
logic [(       6)-1:0] func_dir_cq_intr_thresh_waddr; //I
logic                  func_dir_cq_intr_thresh_we;    //I
cfg_dir_cq_intcfg_t    func_dir_cq_intr_thresh_wdata; //I
cfg_dir_cq_intcfg_t    func_dir_cq_intr_thresh_rdata;

logic                pf_dir_cq_intr_thresh_re;    //I
logic [(       6)-1:0] pf_dir_cq_intr_thresh_raddr; //I
logic [(       6)-1:0] pf_dir_cq_intr_thresh_waddr; //I
logic                  pf_dir_cq_intr_thresh_we;    //I
cfg_dir_cq_intcfg_t    pf_dir_cq_intr_thresh_wdata; //I
cfg_dir_cq_intcfg_t    pf_dir_cq_intr_thresh_rdata;

cfg_dir_cq_intcfg_t           rf_dir_cq_intr_thresh_wdata_struct;
cfg_dir_cq_intcfg_t           rf_dir_cq_intr_thresh_rdata_struct;
logic                  rf_dir_cq_intr_thresh_error;

logic                  func_dir_cq_token_depth_select_re; //I
logic [(       6)-1:0] func_dir_cq_token_depth_select_raddr; //I
logic [(       6)-1:0] func_dir_cq_token_depth_select_waddr; //I
logic                  func_dir_cq_token_depth_select_we;    //I
chp_cq_token_depth_select_t func_dir_cq_token_depth_select_wdata; //I
chp_cq_token_depth_select_t func_dir_cq_token_depth_select_rdata;

logic                pf_dir_cq_token_depth_select_re;    //I
logic [(       6)-1:0] pf_dir_cq_token_depth_select_raddr; //I
logic [(       6)-1:0] pf_dir_cq_token_depth_select_waddr; //I
logic                  pf_dir_cq_token_depth_select_we;    //I
chp_cq_token_depth_select_t pf_dir_cq_token_depth_select_wdata; //I
chp_cq_token_depth_select_t pf_dir_cq_token_depth_select_rdata;

chp_cq_token_depth_select_t   rf_dir_cq_token_depth_select_wdata_struct;
chp_cq_token_depth_select_t   rf_dir_cq_token_depth_select_rdata_struct;
logic                  rf_dir_cq_token_depth_select_error;

logic                  func_dir_cq_wptr_re; //I
logic [(       6)-1:0] func_dir_cq_wptr_raddr; //I
logic [(       6)-1:0] func_dir_cq_wptr_waddr; //I
logic                  func_dir_cq_wptr_we;    //I
chp_dir_cq_wp_t        func_dir_cq_wptr_wdata; //I
chp_dir_cq_wp_t        func_dir_cq_wptr_rdata;

logic                pf_dir_cq_wptr_re;    //I
logic [(       6)-1:0] pf_dir_cq_wptr_raddr; //I
logic [(       6)-1:0] pf_dir_cq_wptr_waddr; //I
logic                  pf_dir_cq_wptr_we;    //I
chp_dir_cq_wp_t        pf_dir_cq_wptr_wdata; //I
chp_dir_cq_wp_t        pf_dir_cq_wptr_rdata;

chp_dir_cq_wp_t               rf_dir_cq_wptr_wdata_struct;
chp_dir_cq_wp_t               rf_dir_cq_wptr_rdata_struct;
logic                  rf_dir_cq_wptr_error;

logic                  func_hcw_enq_w_rx_sync_mem_re; //I
logic [(       4)-1:0] func_hcw_enq_w_rx_sync_mem_raddr; //I
logic [(       4)-1:0] func_hcw_enq_w_rx_sync_mem_waddr; //I
logic                  func_hcw_enq_w_rx_sync_mem_we;    //I
logic [(     160)-1:0] func_hcw_enq_w_rx_sync_mem_wdata; //I
logic [(     160)-1:0] func_hcw_enq_w_rx_sync_mem_rdata;

logic                pf_hcw_enq_w_rx_sync_mem_re;    //I
logic [(       4)-1:0] pf_hcw_enq_w_rx_sync_mem_raddr; //I
logic [(       4)-1:0] pf_hcw_enq_w_rx_sync_mem_waddr; //I
logic                  pf_hcw_enq_w_rx_sync_mem_we;    //I
logic [(     160)-1:0] pf_hcw_enq_w_rx_sync_mem_wdata; //I
logic [(     160)-1:0] pf_hcw_enq_w_rx_sync_mem_rdata;

logic                  rf_hcw_enq_w_rx_sync_mem_error;

logic                  func_hist_list_a_minmax_re; //I
logic [(       6)-1:0] func_hist_list_a_minmax_addr; //I
logic                  func_hist_list_a_minmax_we;    //I
chp_hist_list_minmax_mem_t func_hist_list_a_minmax_wdata; //I
chp_hist_list_minmax_mem_t func_hist_list_a_minmax_rdata;

logic                pf_hist_list_a_minmax_re;    //I
logic [(       6)-1:0] pf_hist_list_a_minmax_addr;  //I
logic                  pf_hist_list_a_minmax_we;    //I
chp_hist_list_minmax_mem_t pf_hist_list_a_minmax_wdata; //I
chp_hist_list_minmax_mem_t pf_hist_list_a_minmax_rdata;

chp_hist_list_minmax_mem_t    rf_hist_list_a_minmax_wdata_struct;
chp_hist_list_minmax_mem_t    rf_hist_list_a_minmax_rdata_struct;
logic                  rf_hist_list_a_minmax_error;

logic                  func_hist_list_a_ptr_re; //I
logic [(       6)-1:0] func_hist_list_a_ptr_raddr; //I
logic [(       6)-1:0] func_hist_list_a_ptr_waddr; //I
logic                  func_hist_list_a_ptr_we;    //I
chp_hist_list_ptr_mem_t func_hist_list_a_ptr_wdata; //I
chp_hist_list_ptr_mem_t func_hist_list_a_ptr_rdata;

logic                pf_hist_list_a_ptr_re;    //I
logic [(       6)-1:0] pf_hist_list_a_ptr_raddr; //I
logic [(       6)-1:0] pf_hist_list_a_ptr_waddr; //I
logic                  pf_hist_list_a_ptr_we;    //I
chp_hist_list_ptr_mem_t pf_hist_list_a_ptr_wdata; //I
chp_hist_list_ptr_mem_t pf_hist_list_a_ptr_rdata;

chp_hist_list_ptr_mem_t       rf_hist_list_a_ptr_wdata_struct;
chp_hist_list_ptr_mem_t       rf_hist_list_a_ptr_rdata_struct;
logic                  rf_hist_list_a_ptr_error;

logic                  func_hist_list_minmax_re; //I
logic [(       6)-1:0] func_hist_list_minmax_addr; //I
logic                  func_hist_list_minmax_we;    //I
chp_hist_list_minmax_mem_t func_hist_list_minmax_wdata; //I
chp_hist_list_minmax_mem_t func_hist_list_minmax_rdata;

logic                pf_hist_list_minmax_re;    //I
logic [(       6)-1:0] pf_hist_list_minmax_addr;  //I
logic                  pf_hist_list_minmax_we;    //I
chp_hist_list_minmax_mem_t pf_hist_list_minmax_wdata; //I
chp_hist_list_minmax_mem_t pf_hist_list_minmax_rdata;

chp_hist_list_minmax_mem_t    rf_hist_list_minmax_wdata_struct;
chp_hist_list_minmax_mem_t    rf_hist_list_minmax_rdata_struct;
logic                  rf_hist_list_minmax_error;

logic                  func_hist_list_ptr_re; //I
logic [(       6)-1:0] func_hist_list_ptr_raddr; //I
logic [(       6)-1:0] func_hist_list_ptr_waddr; //I
logic                  func_hist_list_ptr_we;    //I
chp_hist_list_ptr_mem_t func_hist_list_ptr_wdata; //I
chp_hist_list_ptr_mem_t func_hist_list_ptr_rdata;

logic                pf_hist_list_ptr_re;    //I
logic [(       6)-1:0] pf_hist_list_ptr_raddr; //I
logic [(       6)-1:0] pf_hist_list_ptr_waddr; //I
logic                  pf_hist_list_ptr_we;    //I
chp_hist_list_ptr_mem_t pf_hist_list_ptr_wdata; //I
chp_hist_list_ptr_mem_t pf_hist_list_ptr_rdata;

chp_hist_list_ptr_mem_t       rf_hist_list_ptr_wdata_struct;
chp_hist_list_ptr_mem_t       rf_hist_list_ptr_rdata_struct;
logic                  rf_hist_list_ptr_error;

logic                  func_ldb_cq_depth_re; //I
logic [(       6)-1:0] func_ldb_cq_depth_raddr; //I
logic [(       6)-1:0] func_ldb_cq_depth_waddr; //I
logic                  func_ldb_cq_depth_we;    //I
chp_ldb_cq_depth_t     func_ldb_cq_depth_wdata; //I
chp_ldb_cq_depth_t     func_ldb_cq_depth_rdata;

logic                pf_ldb_cq_depth_re;    //I
logic [(       6)-1:0] pf_ldb_cq_depth_raddr; //I
logic [(       6)-1:0] pf_ldb_cq_depth_waddr; //I
logic                  pf_ldb_cq_depth_we;    //I
chp_ldb_cq_depth_t     pf_ldb_cq_depth_wdata; //I
chp_ldb_cq_depth_t     pf_ldb_cq_depth_rdata;

chp_ldb_cq_depth_t            rf_ldb_cq_depth_wdata_struct;
chp_ldb_cq_depth_t            rf_ldb_cq_depth_rdata_struct;
logic                  rf_ldb_cq_depth_error;

logic                  func_ldb_cq_intr_thresh_re; //I
logic [(       6)-1:0] func_ldb_cq_intr_thresh_raddr; //I
logic [(       6)-1:0] func_ldb_cq_intr_thresh_waddr; //I
logic                  func_ldb_cq_intr_thresh_we;    //I
cfg_ldb_cq_intcfg_t    func_ldb_cq_intr_thresh_wdata; //I
cfg_ldb_cq_intcfg_t    func_ldb_cq_intr_thresh_rdata;

logic                pf_ldb_cq_intr_thresh_re;    //I
logic [(       6)-1:0] pf_ldb_cq_intr_thresh_raddr; //I
logic [(       6)-1:0] pf_ldb_cq_intr_thresh_waddr; //I
logic                  pf_ldb_cq_intr_thresh_we;    //I
cfg_ldb_cq_intcfg_t    pf_ldb_cq_intr_thresh_wdata; //I
cfg_ldb_cq_intcfg_t    pf_ldb_cq_intr_thresh_rdata;

cfg_ldb_cq_intcfg_t           rf_ldb_cq_intr_thresh_wdata_struct;
cfg_ldb_cq_intcfg_t           rf_ldb_cq_intr_thresh_rdata_struct;
logic                  rf_ldb_cq_intr_thresh_error;

logic                  func_ldb_cq_on_off_threshold_re; //I
logic [(       6)-1:0] func_ldb_cq_on_off_threshold_raddr; //I
logic [(       6)-1:0] func_ldb_cq_on_off_threshold_waddr; //I
logic                  func_ldb_cq_on_off_threshold_we;    //I
ldb_cq_on_off_threshold_t func_ldb_cq_on_off_threshold_wdata; //I
ldb_cq_on_off_threshold_t func_ldb_cq_on_off_threshold_rdata;

logic                pf_ldb_cq_on_off_threshold_re;    //I
logic [(       6)-1:0] pf_ldb_cq_on_off_threshold_raddr; //I
logic [(       6)-1:0] pf_ldb_cq_on_off_threshold_waddr; //I
logic                  pf_ldb_cq_on_off_threshold_we;    //I
ldb_cq_on_off_threshold_t pf_ldb_cq_on_off_threshold_wdata; //I
ldb_cq_on_off_threshold_t pf_ldb_cq_on_off_threshold_rdata;

ldb_cq_on_off_threshold_t     rf_ldb_cq_on_off_threshold_wdata_struct;
ldb_cq_on_off_threshold_t     rf_ldb_cq_on_off_threshold_rdata_struct;
logic                  rf_ldb_cq_on_off_threshold_error;

logic                  func_ldb_cq_token_depth_select_re; //I
logic [(       6)-1:0] func_ldb_cq_token_depth_select_raddr; //I
logic [(       6)-1:0] func_ldb_cq_token_depth_select_waddr; //I
logic                  func_ldb_cq_token_depth_select_we;    //I
chp_cq_token_depth_select_t func_ldb_cq_token_depth_select_wdata; //I
chp_cq_token_depth_select_t func_ldb_cq_token_depth_select_rdata;

logic                pf_ldb_cq_token_depth_select_re;    //I
logic [(       6)-1:0] pf_ldb_cq_token_depth_select_raddr; //I
logic [(       6)-1:0] pf_ldb_cq_token_depth_select_waddr; //I
logic                  pf_ldb_cq_token_depth_select_we;    //I
chp_cq_token_depth_select_t pf_ldb_cq_token_depth_select_wdata; //I
chp_cq_token_depth_select_t pf_ldb_cq_token_depth_select_rdata;

chp_cq_token_depth_select_t   rf_ldb_cq_token_depth_select_wdata_struct;
chp_cq_token_depth_select_t   rf_ldb_cq_token_depth_select_rdata_struct;
logic                  rf_ldb_cq_token_depth_select_error;

logic                  func_ldb_cq_wptr_re; //I
logic [(       6)-1:0] func_ldb_cq_wptr_raddr; //I
logic [(       6)-1:0] func_ldb_cq_wptr_waddr; //I
logic                  func_ldb_cq_wptr_we;    //I
chp_ldb_cq_wp_t        func_ldb_cq_wptr_wdata; //I
chp_ldb_cq_wp_t        func_ldb_cq_wptr_rdata;

logic                pf_ldb_cq_wptr_re;    //I
logic [(       6)-1:0] pf_ldb_cq_wptr_raddr; //I
logic [(       6)-1:0] pf_ldb_cq_wptr_waddr; //I
logic                  pf_ldb_cq_wptr_we;    //I
chp_ldb_cq_wp_t        pf_ldb_cq_wptr_wdata; //I
chp_ldb_cq_wp_t        pf_ldb_cq_wptr_rdata;

chp_ldb_cq_wp_t               rf_ldb_cq_wptr_wdata_struct;
chp_ldb_cq_wp_t               rf_ldb_cq_wptr_rdata_struct;
logic                  rf_ldb_cq_wptr_error;

logic                  func_ord_qid_sn_re; //I
logic [(       5)-1:0] func_ord_qid_sn_raddr; //I
logic [(       5)-1:0] func_ord_qid_sn_waddr; //I
logic                  func_ord_qid_sn_we;    //I
chp_ord_qid_sn_t       func_ord_qid_sn_wdata; //I
chp_ord_qid_sn_t       func_ord_qid_sn_rdata;

logic                pf_ord_qid_sn_re;    //I
logic [(       5)-1:0] pf_ord_qid_sn_raddr; //I
logic [(       5)-1:0] pf_ord_qid_sn_waddr; //I
logic                  pf_ord_qid_sn_we;    //I
chp_ord_qid_sn_t       pf_ord_qid_sn_wdata; //I
chp_ord_qid_sn_t       pf_ord_qid_sn_rdata;

chp_ord_qid_sn_t              rf_ord_qid_sn_wdata_struct;
chp_ord_qid_sn_t              rf_ord_qid_sn_rdata_struct;
logic                  rf_ord_qid_sn_error;

logic                  func_ord_qid_sn_map_re; //I
logic [(       5)-1:0] func_ord_qid_sn_map_raddr; //I
logic [(       5)-1:0] func_ord_qid_sn_map_waddr; //I
logic                  func_ord_qid_sn_map_we;    //I
chp_ord_qid_sn_map_t   func_ord_qid_sn_map_wdata; //I
chp_ord_qid_sn_map_t   func_ord_qid_sn_map_rdata;

logic                pf_ord_qid_sn_map_re;    //I
logic [(       5)-1:0] pf_ord_qid_sn_map_raddr; //I
logic [(       5)-1:0] pf_ord_qid_sn_map_waddr; //I
logic                  pf_ord_qid_sn_map_we;    //I
chp_ord_qid_sn_map_t   pf_ord_qid_sn_map_wdata; //I
chp_ord_qid_sn_map_t   pf_ord_qid_sn_map_rdata;

chp_ord_qid_sn_map_t          rf_ord_qid_sn_map_wdata_struct;
chp_ord_qid_sn_map_t          rf_ord_qid_sn_map_rdata_struct;
logic                  rf_ord_qid_sn_map_error;

logic                  func_outbound_hcw_fifo_mem_re; //I
logic [(       4)-1:0] func_outbound_hcw_fifo_mem_raddr; //I
logic [(       4)-1:0] func_outbound_hcw_fifo_mem_waddr; //I
logic                  func_outbound_hcw_fifo_mem_we;    //I
outbound_hcw_fifo_t    func_outbound_hcw_fifo_mem_wdata; //I
outbound_hcw_fifo_t    func_outbound_hcw_fifo_mem_rdata;

logic                pf_outbound_hcw_fifo_mem_re;    //I
logic [(       4)-1:0] pf_outbound_hcw_fifo_mem_raddr; //I
logic [(       4)-1:0] pf_outbound_hcw_fifo_mem_waddr; //I
logic                  pf_outbound_hcw_fifo_mem_we;    //I
outbound_hcw_fifo_t    pf_outbound_hcw_fifo_mem_wdata; //I
outbound_hcw_fifo_t    pf_outbound_hcw_fifo_mem_rdata;

outbound_hcw_fifo_t           rf_outbound_hcw_fifo_mem_wdata_struct;
outbound_hcw_fifo_t           rf_outbound_hcw_fifo_mem_rdata_struct;
logic                  rf_outbound_hcw_fifo_mem_error;

logic                  func_qed_chp_sch_flid_ret_rx_sync_mem_re; //I
logic [(       2)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_raddr; //I
logic [(       2)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_waddr; //I
logic                  func_qed_chp_sch_flid_ret_rx_sync_mem_we;    //I
logic [(      26)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_wdata; //I
logic [(      26)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_rdata;

logic                pf_qed_chp_sch_flid_ret_rx_sync_mem_re;    //I
logic [(       2)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_raddr; //I
logic [(       2)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_waddr; //I
logic                  pf_qed_chp_sch_flid_ret_rx_sync_mem_we;    //I
logic [(      26)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_wdata; //I
logic [(      26)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata;

logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_error;

logic                  func_qed_chp_sch_rx_sync_mem_re; //I
logic [(       3)-1:0] func_qed_chp_sch_rx_sync_mem_raddr; //I
logic [(       3)-1:0] func_qed_chp_sch_rx_sync_mem_waddr; //I
logic                  func_qed_chp_sch_rx_sync_mem_we;    //I
logic [(     177)-1:0] func_qed_chp_sch_rx_sync_mem_wdata; //I
logic [(     177)-1:0] func_qed_chp_sch_rx_sync_mem_rdata;

logic                pf_qed_chp_sch_rx_sync_mem_re;    //I
logic [(       3)-1:0] pf_qed_chp_sch_rx_sync_mem_raddr; //I
logic [(       3)-1:0] pf_qed_chp_sch_rx_sync_mem_waddr; //I
logic                  pf_qed_chp_sch_rx_sync_mem_we;    //I
logic [(     177)-1:0] pf_qed_chp_sch_rx_sync_mem_wdata; //I
logic [(     177)-1:0] pf_qed_chp_sch_rx_sync_mem_rdata;

logic                  rf_qed_chp_sch_rx_sync_mem_error;

logic                  func_qed_to_cq_fifo_mem_re; //I
logic [(       3)-1:0] func_qed_to_cq_fifo_mem_raddr; //I
logic [(       3)-1:0] func_qed_to_cq_fifo_mem_waddr; //I
logic                  func_qed_to_cq_fifo_mem_we;    //I
logic [(     197)-1:0] func_qed_to_cq_fifo_mem_wdata; //I
logic [(     197)-1:0] func_qed_to_cq_fifo_mem_rdata;

logic                pf_qed_to_cq_fifo_mem_re;    //I
logic [(       3)-1:0] pf_qed_to_cq_fifo_mem_raddr; //I
logic [(       3)-1:0] pf_qed_to_cq_fifo_mem_waddr; //I
logic                  pf_qed_to_cq_fifo_mem_we;    //I
logic [(     197)-1:0] pf_qed_to_cq_fifo_mem_wdata; //I
logic [(     197)-1:0] pf_qed_to_cq_fifo_mem_rdata;

logic                  rf_qed_to_cq_fifo_mem_error;

logic                  func_threshold_r_pipe_dir_mem_re; //I
logic [(       6)-1:0] func_threshold_r_pipe_dir_mem_addr; //I
logic                  func_threshold_r_pipe_dir_mem_we;    //I
logic [(      14)-1:0] func_threshold_r_pipe_dir_mem_wdata; //I
logic [(      14)-1:0] func_threshold_r_pipe_dir_mem_rdata;

logic                pf_threshold_r_pipe_dir_mem_re;    //I
logic [(       6)-1:0] pf_threshold_r_pipe_dir_mem_addr;  //I
logic                  pf_threshold_r_pipe_dir_mem_we;    //I
logic [(      14)-1:0] pf_threshold_r_pipe_dir_mem_wdata; //I
logic [(      14)-1:0] pf_threshold_r_pipe_dir_mem_rdata;

logic                  rf_threshold_r_pipe_dir_mem_error;

logic                  func_threshold_r_pipe_ldb_mem_re; //I
logic [(       6)-1:0] func_threshold_r_pipe_ldb_mem_addr; //I
logic                  func_threshold_r_pipe_ldb_mem_we;    //I
logic [(      14)-1:0] func_threshold_r_pipe_ldb_mem_wdata; //I
logic [(      14)-1:0] func_threshold_r_pipe_ldb_mem_rdata;

logic                pf_threshold_r_pipe_ldb_mem_re;    //I
logic [(       6)-1:0] pf_threshold_r_pipe_ldb_mem_addr;  //I
logic                  pf_threshold_r_pipe_ldb_mem_we;    //I
logic [(      14)-1:0] pf_threshold_r_pipe_ldb_mem_wdata; //I
logic [(      14)-1:0] pf_threshold_r_pipe_ldb_mem_rdata;

logic                  rf_threshold_r_pipe_ldb_mem_error;

logic                  func_freelist_0_re;    //I
logic [(      11)-1:0] func_freelist_0_addr;  //I
logic                  func_freelist_0_we;    //I
chp_freelist_t         func_freelist_0_wdata; //I
chp_freelist_t         func_freelist_0_rdata;

logic                  pf_freelist_0_re;   //I
logic [(      11)-1:0] pf_freelist_0_addr; //I
logic                  pf_freelist_0_we;   //I
chp_freelist_t         pf_freelist_0_wdata; //I
chp_freelist_t         pf_freelist_0_rdata;

chp_freelist_t                sr_freelist_0_wdata_struct;
chp_freelist_t                sr_freelist_0_rdata_struct;
logic                  sr_freelist_0_error;

logic                  func_freelist_1_re;    //I
logic [(      11)-1:0] func_freelist_1_addr;  //I
logic                  func_freelist_1_we;    //I
chp_freelist_t         func_freelist_1_wdata; //I
chp_freelist_t         func_freelist_1_rdata;

logic                  pf_freelist_1_re;   //I
logic [(      11)-1:0] pf_freelist_1_addr; //I
logic                  pf_freelist_1_we;   //I
chp_freelist_t         pf_freelist_1_wdata; //I
chp_freelist_t         pf_freelist_1_rdata;

chp_freelist_t                sr_freelist_1_wdata_struct;
chp_freelist_t                sr_freelist_1_rdata_struct;
logic                  sr_freelist_1_error;

logic                  func_freelist_2_re;    //I
logic [(      11)-1:0] func_freelist_2_addr;  //I
logic                  func_freelist_2_we;    //I
chp_freelist_t         func_freelist_2_wdata; //I
chp_freelist_t         func_freelist_2_rdata;

logic                  pf_freelist_2_re;   //I
logic [(      11)-1:0] pf_freelist_2_addr; //I
logic                  pf_freelist_2_we;   //I
chp_freelist_t         pf_freelist_2_wdata; //I
chp_freelist_t         pf_freelist_2_rdata;

chp_freelist_t                sr_freelist_2_wdata_struct;
chp_freelist_t                sr_freelist_2_rdata_struct;
logic                  sr_freelist_2_error;

logic                  func_freelist_3_re;    //I
logic [(      11)-1:0] func_freelist_3_addr;  //I
logic                  func_freelist_3_we;    //I
chp_freelist_t         func_freelist_3_wdata; //I
chp_freelist_t         func_freelist_3_rdata;

logic                  pf_freelist_3_re;   //I
logic [(      11)-1:0] pf_freelist_3_addr; //I
logic                  pf_freelist_3_we;   //I
chp_freelist_t         pf_freelist_3_wdata; //I
chp_freelist_t         pf_freelist_3_rdata;

chp_freelist_t                sr_freelist_3_wdata_struct;
chp_freelist_t                sr_freelist_3_rdata_struct;
logic                  sr_freelist_3_error;

logic                  func_freelist_4_re;    //I
logic [(      11)-1:0] func_freelist_4_addr;  //I
logic                  func_freelist_4_we;    //I
chp_freelist_t         func_freelist_4_wdata; //I
chp_freelist_t         func_freelist_4_rdata;

logic                  pf_freelist_4_re;   //I
logic [(      11)-1:0] pf_freelist_4_addr; //I
logic                  pf_freelist_4_we;   //I
chp_freelist_t         pf_freelist_4_wdata; //I
chp_freelist_t         pf_freelist_4_rdata;

chp_freelist_t                sr_freelist_4_wdata_struct;
chp_freelist_t                sr_freelist_4_rdata_struct;
logic                  sr_freelist_4_error;

logic                  func_freelist_5_re;    //I
logic [(      11)-1:0] func_freelist_5_addr;  //I
logic                  func_freelist_5_we;    //I
chp_freelist_t         func_freelist_5_wdata; //I
chp_freelist_t         func_freelist_5_rdata;

logic                  pf_freelist_5_re;   //I
logic [(      11)-1:0] pf_freelist_5_addr; //I
logic                  pf_freelist_5_we;   //I
chp_freelist_t         pf_freelist_5_wdata; //I
chp_freelist_t         pf_freelist_5_rdata;

chp_freelist_t                sr_freelist_5_wdata_struct;
chp_freelist_t                sr_freelist_5_rdata_struct;
logic                  sr_freelist_5_error;

logic                  func_freelist_6_re;    //I
logic [(      11)-1:0] func_freelist_6_addr;  //I
logic                  func_freelist_6_we;    //I
chp_freelist_t         func_freelist_6_wdata; //I
chp_freelist_t         func_freelist_6_rdata;

logic                  pf_freelist_6_re;   //I
logic [(      11)-1:0] pf_freelist_6_addr; //I
logic                  pf_freelist_6_we;   //I
chp_freelist_t         pf_freelist_6_wdata; //I
chp_freelist_t         pf_freelist_6_rdata;

chp_freelist_t                sr_freelist_6_wdata_struct;
chp_freelist_t                sr_freelist_6_rdata_struct;
logic                  sr_freelist_6_error;

logic                  func_freelist_7_re;    //I
logic [(      11)-1:0] func_freelist_7_addr;  //I
logic                  func_freelist_7_we;    //I
chp_freelist_t         func_freelist_7_wdata; //I
chp_freelist_t         func_freelist_7_rdata;

logic                  pf_freelist_7_re;   //I
logic [(      11)-1:0] pf_freelist_7_addr; //I
logic                  pf_freelist_7_we;   //I
chp_freelist_t         pf_freelist_7_wdata; //I
chp_freelist_t         pf_freelist_7_rdata;

chp_freelist_t                sr_freelist_7_wdata_struct;
chp_freelist_t                sr_freelist_7_rdata_struct;
logic                  sr_freelist_7_error;

logic                  func_hist_list_re;    //I
logic [(      13)-1:0] func_hist_list_addr;  //I
logic                  func_hist_list_we;    //I
hist_list_mf_t         func_hist_list_wdata; //I
hist_list_mf_t         func_hist_list_rdata;

logic                  pf_hist_list_re;   //I
logic [(      13)-1:0] pf_hist_list_addr; //I
logic                  pf_hist_list_we;   //I
hist_list_mf_t         pf_hist_list_wdata; //I
hist_list_mf_t         pf_hist_list_rdata;

hist_list_mf_t                sr_hist_list_wdata_struct;
hist_list_mf_t                sr_hist_list_rdata_struct;
logic                  sr_hist_list_error;

logic                  func_hist_list_a_re;    //I
logic [(      13)-1:0] func_hist_list_a_addr;  //I
logic                  func_hist_list_a_we;    //I
hist_list_mf_t         func_hist_list_a_wdata; //I
hist_list_mf_t         func_hist_list_a_rdata;

logic                  pf_hist_list_a_re;   //I
logic [(      13)-1:0] pf_hist_list_a_addr; //I
logic                  pf_hist_list_a_we;   //I
hist_list_mf_t         pf_hist_list_a_wdata; //I
hist_list_mf_t         pf_hist_list_a_rdata;

hist_list_mf_t                sr_hist_list_a_wdata_struct;
hist_list_mf_t                sr_hist_list_a_rdata_struct;
logic                  sr_hist_list_a_error;

assign rf_dir_cq_depth_wdata           = rf_dir_cq_depth_wdata_struct ;
assign rf_dir_cq_depth_rdata_struct    = rf_dir_cq_depth_rdata ;

assign rf_dir_cq_intr_thresh_wdata           = rf_dir_cq_intr_thresh_wdata_struct ;
assign rf_dir_cq_intr_thresh_rdata_struct    = rf_dir_cq_intr_thresh_rdata ;

assign rf_dir_cq_token_depth_select_wdata           = rf_dir_cq_token_depth_select_wdata_struct ;
assign rf_dir_cq_token_depth_select_rdata_struct    = rf_dir_cq_token_depth_select_rdata ;

assign rf_dir_cq_wptr_wdata           = rf_dir_cq_wptr_wdata_struct ;
assign rf_dir_cq_wptr_rdata_struct    = rf_dir_cq_wptr_rdata ;

assign rf_hist_list_a_minmax_wdata           = rf_hist_list_a_minmax_wdata_struct ;
assign rf_hist_list_a_minmax_rdata_struct    = rf_hist_list_a_minmax_rdata ;

assign rf_hist_list_a_ptr_wdata           = rf_hist_list_a_ptr_wdata_struct ;
assign rf_hist_list_a_ptr_rdata_struct    = rf_hist_list_a_ptr_rdata ;

assign rf_hist_list_minmax_wdata           = rf_hist_list_minmax_wdata_struct ;
assign rf_hist_list_minmax_rdata_struct    = rf_hist_list_minmax_rdata ;

assign rf_hist_list_ptr_wdata           = rf_hist_list_ptr_wdata_struct ;
assign rf_hist_list_ptr_rdata_struct    = rf_hist_list_ptr_rdata ;

assign rf_ldb_cq_depth_wdata           = rf_ldb_cq_depth_wdata_struct ;
assign rf_ldb_cq_depth_rdata_struct    = rf_ldb_cq_depth_rdata ;

assign rf_ldb_cq_intr_thresh_wdata           = rf_ldb_cq_intr_thresh_wdata_struct ;
assign rf_ldb_cq_intr_thresh_rdata_struct    = rf_ldb_cq_intr_thresh_rdata ;

assign rf_ldb_cq_on_off_threshold_wdata           = rf_ldb_cq_on_off_threshold_wdata_struct ;
assign rf_ldb_cq_on_off_threshold_rdata_struct    = rf_ldb_cq_on_off_threshold_rdata ;

assign rf_ldb_cq_token_depth_select_wdata           = rf_ldb_cq_token_depth_select_wdata_struct ;
assign rf_ldb_cq_token_depth_select_rdata_struct    = rf_ldb_cq_token_depth_select_rdata ;

assign rf_ldb_cq_wptr_wdata           = rf_ldb_cq_wptr_wdata_struct ;
assign rf_ldb_cq_wptr_rdata_struct    = rf_ldb_cq_wptr_rdata ;

assign rf_ord_qid_sn_wdata           = rf_ord_qid_sn_wdata_struct ;
assign rf_ord_qid_sn_rdata_struct    = rf_ord_qid_sn_rdata ;

assign rf_ord_qid_sn_map_wdata           = rf_ord_qid_sn_map_wdata_struct ;
assign rf_ord_qid_sn_map_rdata_struct    = rf_ord_qid_sn_map_rdata ;

assign rf_outbound_hcw_fifo_mem_wdata           = rf_outbound_hcw_fifo_mem_wdata_struct ;
assign rf_outbound_hcw_fifo_mem_rdata_struct    = rf_outbound_hcw_fifo_mem_rdata ;

assign sr_freelist_0_wdata           = sr_freelist_0_wdata_struct ;
assign sr_freelist_0_rdata_struct    = sr_freelist_0_rdata ;

assign sr_freelist_1_wdata           = sr_freelist_1_wdata_struct ;
assign sr_freelist_1_rdata_struct    = sr_freelist_1_rdata ;

assign sr_freelist_2_wdata           = sr_freelist_2_wdata_struct ;
assign sr_freelist_2_rdata_struct    = sr_freelist_2_rdata ;

assign sr_freelist_3_wdata           = sr_freelist_3_wdata_struct ;
assign sr_freelist_3_rdata_struct    = sr_freelist_3_rdata ;

assign sr_freelist_4_wdata           = sr_freelist_4_wdata_struct ;
assign sr_freelist_4_rdata_struct    = sr_freelist_4_rdata ;

assign sr_freelist_5_wdata           = sr_freelist_5_wdata_struct ;
assign sr_freelist_5_rdata_struct    = sr_freelist_5_rdata ;

assign sr_freelist_6_wdata           = sr_freelist_6_wdata_struct ;
assign sr_freelist_6_rdata_struct    = sr_freelist_6_rdata ;

assign sr_freelist_7_wdata           = sr_freelist_7_wdata_struct ;
assign sr_freelist_7_rdata_struct    = sr_freelist_7_rdata ;

assign sr_hist_list_wdata           = sr_hist_list_wdata_struct ;
assign sr_hist_list_rdata_struct    = sr_hist_list_rdata ;

assign sr_hist_list_a_wdata           = sr_hist_list_a_wdata_struct ;
assign sr_hist_list_a_rdata_struct    = sr_hist_list_a_rdata ;

hqm_credit_hist_pipe_ram_access i_hqm_credit_hist_pipe_ram_access (
  .hqm_gated_clk (hqm_gated_clk)
, .hqm_inp_gated_clk (hqm_inp_gated_clk)
, .hqm_pgcb_clk (hqm_pgcb_clk)
, .hqm_gated_rst_n (hqm_gated_rst_n)
, .hqm_inp_gated_rst_n (hqm_inp_gated_rst_n)
, .hqm_pgcb_rst_n (hqm_pgcb_rst_n)
,.cfg_mem_re          (cfg_mem_re)
,.cfg_mem_we          (cfg_mem_we)
,.cfg_mem_addr        (cfg_mem_addr)
,.cfg_mem_minbit      (cfg_mem_minbit)
,.cfg_mem_maxbit      (cfg_mem_maxbit)
,.cfg_mem_wdata       (cfg_mem_wdata)
,.cfg_mem_rdata       (cfg_mem_rdata)
,.cfg_mem_ack         (cfg_mem_ack)
,.cfg_mem_cc_v        (cfg_mem_cc_v)
,.cfg_mem_cc_value    (cfg_mem_cc_value)
,.cfg_mem_cc_width    (cfg_mem_cc_width)
,.cfg_mem_cc_position (cfg_mem_cc_position)

,.hqm_credit_hist_pipe_rfw_top_ipar_error (hqm_credit_hist_pipe_rfw_top_ipar_error)

,.func_aqed_chp_sch_rx_sync_mem_re    (func_aqed_chp_sch_rx_sync_mem_re)
,.func_aqed_chp_sch_rx_sync_mem_raddr (func_aqed_chp_sch_rx_sync_mem_raddr)
,.func_aqed_chp_sch_rx_sync_mem_waddr (func_aqed_chp_sch_rx_sync_mem_waddr)
,.func_aqed_chp_sch_rx_sync_mem_we    (func_aqed_chp_sch_rx_sync_mem_we)
,.func_aqed_chp_sch_rx_sync_mem_wdata (func_aqed_chp_sch_rx_sync_mem_wdata)
,.func_aqed_chp_sch_rx_sync_mem_rdata (func_aqed_chp_sch_rx_sync_mem_rdata)

,.pf_aqed_chp_sch_rx_sync_mem_re      (pf_aqed_chp_sch_rx_sync_mem_re)
,.pf_aqed_chp_sch_rx_sync_mem_raddr (pf_aqed_chp_sch_rx_sync_mem_raddr)
,.pf_aqed_chp_sch_rx_sync_mem_waddr (pf_aqed_chp_sch_rx_sync_mem_waddr)
,.pf_aqed_chp_sch_rx_sync_mem_we    (pf_aqed_chp_sch_rx_sync_mem_we)
,.pf_aqed_chp_sch_rx_sync_mem_wdata (pf_aqed_chp_sch_rx_sync_mem_wdata)
,.pf_aqed_chp_sch_rx_sync_mem_rdata (pf_aqed_chp_sch_rx_sync_mem_rdata)

,.rf_aqed_chp_sch_rx_sync_mem_rclk (rf_aqed_chp_sch_rx_sync_mem_rclk)
,.rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n (rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n)
,.rf_aqed_chp_sch_rx_sync_mem_re    (rf_aqed_chp_sch_rx_sync_mem_re)
,.rf_aqed_chp_sch_rx_sync_mem_raddr (rf_aqed_chp_sch_rx_sync_mem_raddr)
,.rf_aqed_chp_sch_rx_sync_mem_waddr (rf_aqed_chp_sch_rx_sync_mem_waddr)
,.rf_aqed_chp_sch_rx_sync_mem_wclk (rf_aqed_chp_sch_rx_sync_mem_wclk)
,.rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n (rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n)
,.rf_aqed_chp_sch_rx_sync_mem_we    (rf_aqed_chp_sch_rx_sync_mem_we)
,.rf_aqed_chp_sch_rx_sync_mem_wdata (rf_aqed_chp_sch_rx_sync_mem_wdata)
,.rf_aqed_chp_sch_rx_sync_mem_rdata (rf_aqed_chp_sch_rx_sync_mem_rdata)

,.rf_aqed_chp_sch_rx_sync_mem_error (rf_aqed_chp_sch_rx_sync_mem_error)

,.func_chp_chp_rop_hcw_fifo_mem_re    (func_chp_chp_rop_hcw_fifo_mem_re)
,.func_chp_chp_rop_hcw_fifo_mem_raddr (func_chp_chp_rop_hcw_fifo_mem_raddr)
,.func_chp_chp_rop_hcw_fifo_mem_waddr (func_chp_chp_rop_hcw_fifo_mem_waddr)
,.func_chp_chp_rop_hcw_fifo_mem_we    (func_chp_chp_rop_hcw_fifo_mem_we)
,.func_chp_chp_rop_hcw_fifo_mem_wdata (func_chp_chp_rop_hcw_fifo_mem_wdata)
,.func_chp_chp_rop_hcw_fifo_mem_rdata (func_chp_chp_rop_hcw_fifo_mem_rdata)

,.pf_chp_chp_rop_hcw_fifo_mem_re      (pf_chp_chp_rop_hcw_fifo_mem_re)
,.pf_chp_chp_rop_hcw_fifo_mem_raddr (pf_chp_chp_rop_hcw_fifo_mem_raddr)
,.pf_chp_chp_rop_hcw_fifo_mem_waddr (pf_chp_chp_rop_hcw_fifo_mem_waddr)
,.pf_chp_chp_rop_hcw_fifo_mem_we    (pf_chp_chp_rop_hcw_fifo_mem_we)
,.pf_chp_chp_rop_hcw_fifo_mem_wdata (pf_chp_chp_rop_hcw_fifo_mem_wdata)
,.pf_chp_chp_rop_hcw_fifo_mem_rdata (pf_chp_chp_rop_hcw_fifo_mem_rdata)

,.rf_chp_chp_rop_hcw_fifo_mem_rclk (rf_chp_chp_rop_hcw_fifo_mem_rclk)
,.rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n (rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n)
,.rf_chp_chp_rop_hcw_fifo_mem_re    (rf_chp_chp_rop_hcw_fifo_mem_re)
,.rf_chp_chp_rop_hcw_fifo_mem_raddr (rf_chp_chp_rop_hcw_fifo_mem_raddr)
,.rf_chp_chp_rop_hcw_fifo_mem_waddr (rf_chp_chp_rop_hcw_fifo_mem_waddr)
,.rf_chp_chp_rop_hcw_fifo_mem_wclk (rf_chp_chp_rop_hcw_fifo_mem_wclk)
,.rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n (rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n)
,.rf_chp_chp_rop_hcw_fifo_mem_we    (rf_chp_chp_rop_hcw_fifo_mem_we)
,.rf_chp_chp_rop_hcw_fifo_mem_wdata (rf_chp_chp_rop_hcw_fifo_mem_wdata)
,.rf_chp_chp_rop_hcw_fifo_mem_rdata (rf_chp_chp_rop_hcw_fifo_mem_rdata)

,.rf_chp_chp_rop_hcw_fifo_mem_error (rf_chp_chp_rop_hcw_fifo_mem_error)

,.func_chp_lsp_ap_cmp_fifo_mem_re    (func_chp_lsp_ap_cmp_fifo_mem_re)
,.func_chp_lsp_ap_cmp_fifo_mem_raddr (func_chp_lsp_ap_cmp_fifo_mem_raddr)
,.func_chp_lsp_ap_cmp_fifo_mem_waddr (func_chp_lsp_ap_cmp_fifo_mem_waddr)
,.func_chp_lsp_ap_cmp_fifo_mem_we    (func_chp_lsp_ap_cmp_fifo_mem_we)
,.func_chp_lsp_ap_cmp_fifo_mem_wdata (func_chp_lsp_ap_cmp_fifo_mem_wdata)
,.func_chp_lsp_ap_cmp_fifo_mem_rdata (func_chp_lsp_ap_cmp_fifo_mem_rdata)

,.pf_chp_lsp_ap_cmp_fifo_mem_re      (pf_chp_lsp_ap_cmp_fifo_mem_re)
,.pf_chp_lsp_ap_cmp_fifo_mem_raddr (pf_chp_lsp_ap_cmp_fifo_mem_raddr)
,.pf_chp_lsp_ap_cmp_fifo_mem_waddr (pf_chp_lsp_ap_cmp_fifo_mem_waddr)
,.pf_chp_lsp_ap_cmp_fifo_mem_we    (pf_chp_lsp_ap_cmp_fifo_mem_we)
,.pf_chp_lsp_ap_cmp_fifo_mem_wdata (pf_chp_lsp_ap_cmp_fifo_mem_wdata)
,.pf_chp_lsp_ap_cmp_fifo_mem_rdata (pf_chp_lsp_ap_cmp_fifo_mem_rdata)

,.rf_chp_lsp_ap_cmp_fifo_mem_rclk (rf_chp_lsp_ap_cmp_fifo_mem_rclk)
,.rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n (rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n)
,.rf_chp_lsp_ap_cmp_fifo_mem_re    (rf_chp_lsp_ap_cmp_fifo_mem_re)
,.rf_chp_lsp_ap_cmp_fifo_mem_raddr (rf_chp_lsp_ap_cmp_fifo_mem_raddr)
,.rf_chp_lsp_ap_cmp_fifo_mem_waddr (rf_chp_lsp_ap_cmp_fifo_mem_waddr)
,.rf_chp_lsp_ap_cmp_fifo_mem_wclk (rf_chp_lsp_ap_cmp_fifo_mem_wclk)
,.rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n (rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n)
,.rf_chp_lsp_ap_cmp_fifo_mem_we    (rf_chp_lsp_ap_cmp_fifo_mem_we)
,.rf_chp_lsp_ap_cmp_fifo_mem_wdata (rf_chp_lsp_ap_cmp_fifo_mem_wdata)
,.rf_chp_lsp_ap_cmp_fifo_mem_rdata (rf_chp_lsp_ap_cmp_fifo_mem_rdata)

,.rf_chp_lsp_ap_cmp_fifo_mem_error (rf_chp_lsp_ap_cmp_fifo_mem_error)

,.func_chp_lsp_tok_fifo_mem_re    (func_chp_lsp_tok_fifo_mem_re)
,.func_chp_lsp_tok_fifo_mem_raddr (func_chp_lsp_tok_fifo_mem_raddr)
,.func_chp_lsp_tok_fifo_mem_waddr (func_chp_lsp_tok_fifo_mem_waddr)
,.func_chp_lsp_tok_fifo_mem_we    (func_chp_lsp_tok_fifo_mem_we)
,.func_chp_lsp_tok_fifo_mem_wdata (func_chp_lsp_tok_fifo_mem_wdata)
,.func_chp_lsp_tok_fifo_mem_rdata (func_chp_lsp_tok_fifo_mem_rdata)

,.pf_chp_lsp_tok_fifo_mem_re      (pf_chp_lsp_tok_fifo_mem_re)
,.pf_chp_lsp_tok_fifo_mem_raddr (pf_chp_lsp_tok_fifo_mem_raddr)
,.pf_chp_lsp_tok_fifo_mem_waddr (pf_chp_lsp_tok_fifo_mem_waddr)
,.pf_chp_lsp_tok_fifo_mem_we    (pf_chp_lsp_tok_fifo_mem_we)
,.pf_chp_lsp_tok_fifo_mem_wdata (pf_chp_lsp_tok_fifo_mem_wdata)
,.pf_chp_lsp_tok_fifo_mem_rdata (pf_chp_lsp_tok_fifo_mem_rdata)

,.rf_chp_lsp_tok_fifo_mem_rclk (rf_chp_lsp_tok_fifo_mem_rclk)
,.rf_chp_lsp_tok_fifo_mem_rclk_rst_n (rf_chp_lsp_tok_fifo_mem_rclk_rst_n)
,.rf_chp_lsp_tok_fifo_mem_re    (rf_chp_lsp_tok_fifo_mem_re)
,.rf_chp_lsp_tok_fifo_mem_raddr (rf_chp_lsp_tok_fifo_mem_raddr)
,.rf_chp_lsp_tok_fifo_mem_waddr (rf_chp_lsp_tok_fifo_mem_waddr)
,.rf_chp_lsp_tok_fifo_mem_wclk (rf_chp_lsp_tok_fifo_mem_wclk)
,.rf_chp_lsp_tok_fifo_mem_wclk_rst_n (rf_chp_lsp_tok_fifo_mem_wclk_rst_n)
,.rf_chp_lsp_tok_fifo_mem_we    (rf_chp_lsp_tok_fifo_mem_we)
,.rf_chp_lsp_tok_fifo_mem_wdata (rf_chp_lsp_tok_fifo_mem_wdata)
,.rf_chp_lsp_tok_fifo_mem_rdata (rf_chp_lsp_tok_fifo_mem_rdata)

,.rf_chp_lsp_tok_fifo_mem_error (rf_chp_lsp_tok_fifo_mem_error)

,.func_chp_sys_tx_fifo_mem_re    (func_chp_sys_tx_fifo_mem_re)
,.func_chp_sys_tx_fifo_mem_raddr (func_chp_sys_tx_fifo_mem_raddr)
,.func_chp_sys_tx_fifo_mem_waddr (func_chp_sys_tx_fifo_mem_waddr)
,.func_chp_sys_tx_fifo_mem_we    (func_chp_sys_tx_fifo_mem_we)
,.func_chp_sys_tx_fifo_mem_wdata (func_chp_sys_tx_fifo_mem_wdata)
,.func_chp_sys_tx_fifo_mem_rdata (func_chp_sys_tx_fifo_mem_rdata)

,.pf_chp_sys_tx_fifo_mem_re      (pf_chp_sys_tx_fifo_mem_re)
,.pf_chp_sys_tx_fifo_mem_raddr (pf_chp_sys_tx_fifo_mem_raddr)
,.pf_chp_sys_tx_fifo_mem_waddr (pf_chp_sys_tx_fifo_mem_waddr)
,.pf_chp_sys_tx_fifo_mem_we    (pf_chp_sys_tx_fifo_mem_we)
,.pf_chp_sys_tx_fifo_mem_wdata (pf_chp_sys_tx_fifo_mem_wdata)
,.pf_chp_sys_tx_fifo_mem_rdata (pf_chp_sys_tx_fifo_mem_rdata)

,.rf_chp_sys_tx_fifo_mem_rclk (rf_chp_sys_tx_fifo_mem_rclk)
,.rf_chp_sys_tx_fifo_mem_rclk_rst_n (rf_chp_sys_tx_fifo_mem_rclk_rst_n)
,.rf_chp_sys_tx_fifo_mem_re    (rf_chp_sys_tx_fifo_mem_re)
,.rf_chp_sys_tx_fifo_mem_raddr (rf_chp_sys_tx_fifo_mem_raddr)
,.rf_chp_sys_tx_fifo_mem_waddr (rf_chp_sys_tx_fifo_mem_waddr)
,.rf_chp_sys_tx_fifo_mem_wclk (rf_chp_sys_tx_fifo_mem_wclk)
,.rf_chp_sys_tx_fifo_mem_wclk_rst_n (rf_chp_sys_tx_fifo_mem_wclk_rst_n)
,.rf_chp_sys_tx_fifo_mem_we    (rf_chp_sys_tx_fifo_mem_we)
,.rf_chp_sys_tx_fifo_mem_wdata (rf_chp_sys_tx_fifo_mem_wdata)
,.rf_chp_sys_tx_fifo_mem_rdata (rf_chp_sys_tx_fifo_mem_rdata)

,.rf_chp_sys_tx_fifo_mem_error (rf_chp_sys_tx_fifo_mem_error)

,.func_cmp_id_chk_enbl_mem_re    (func_cmp_id_chk_enbl_mem_re)
,.func_cmp_id_chk_enbl_mem_raddr (func_cmp_id_chk_enbl_mem_raddr)
,.func_cmp_id_chk_enbl_mem_waddr (func_cmp_id_chk_enbl_mem_waddr)
,.func_cmp_id_chk_enbl_mem_we    (func_cmp_id_chk_enbl_mem_we)
,.func_cmp_id_chk_enbl_mem_wdata (func_cmp_id_chk_enbl_mem_wdata)
,.func_cmp_id_chk_enbl_mem_rdata (func_cmp_id_chk_enbl_mem_rdata)

,.pf_cmp_id_chk_enbl_mem_re      (pf_cmp_id_chk_enbl_mem_re)
,.pf_cmp_id_chk_enbl_mem_raddr (pf_cmp_id_chk_enbl_mem_raddr)
,.pf_cmp_id_chk_enbl_mem_waddr (pf_cmp_id_chk_enbl_mem_waddr)
,.pf_cmp_id_chk_enbl_mem_we    (pf_cmp_id_chk_enbl_mem_we)
,.pf_cmp_id_chk_enbl_mem_wdata (pf_cmp_id_chk_enbl_mem_wdata)
,.pf_cmp_id_chk_enbl_mem_rdata (pf_cmp_id_chk_enbl_mem_rdata)

,.rf_cmp_id_chk_enbl_mem_rclk (rf_cmp_id_chk_enbl_mem_rclk)
,.rf_cmp_id_chk_enbl_mem_rclk_rst_n (rf_cmp_id_chk_enbl_mem_rclk_rst_n)
,.rf_cmp_id_chk_enbl_mem_re    (rf_cmp_id_chk_enbl_mem_re)
,.rf_cmp_id_chk_enbl_mem_raddr (rf_cmp_id_chk_enbl_mem_raddr)
,.rf_cmp_id_chk_enbl_mem_waddr (rf_cmp_id_chk_enbl_mem_waddr)
,.rf_cmp_id_chk_enbl_mem_wclk (rf_cmp_id_chk_enbl_mem_wclk)
,.rf_cmp_id_chk_enbl_mem_wclk_rst_n (rf_cmp_id_chk_enbl_mem_wclk_rst_n)
,.rf_cmp_id_chk_enbl_mem_we    (rf_cmp_id_chk_enbl_mem_we)
,.rf_cmp_id_chk_enbl_mem_wdata (rf_cmp_id_chk_enbl_mem_wdata)
,.rf_cmp_id_chk_enbl_mem_rdata (rf_cmp_id_chk_enbl_mem_rdata)

,.rf_cmp_id_chk_enbl_mem_error (rf_cmp_id_chk_enbl_mem_error)

,.func_count_rmw_pipe_dir_mem_re    (func_count_rmw_pipe_dir_mem_re)
,.func_count_rmw_pipe_dir_mem_raddr (func_count_rmw_pipe_dir_mem_raddr)
,.func_count_rmw_pipe_dir_mem_waddr (func_count_rmw_pipe_dir_mem_waddr)
,.func_count_rmw_pipe_dir_mem_we    (func_count_rmw_pipe_dir_mem_we)
,.func_count_rmw_pipe_dir_mem_wdata (func_count_rmw_pipe_dir_mem_wdata)
,.func_count_rmw_pipe_dir_mem_rdata (func_count_rmw_pipe_dir_mem_rdata)

,.pf_count_rmw_pipe_dir_mem_re      (pf_count_rmw_pipe_dir_mem_re)
,.pf_count_rmw_pipe_dir_mem_raddr (pf_count_rmw_pipe_dir_mem_raddr)
,.pf_count_rmw_pipe_dir_mem_waddr (pf_count_rmw_pipe_dir_mem_waddr)
,.pf_count_rmw_pipe_dir_mem_we    (pf_count_rmw_pipe_dir_mem_we)
,.pf_count_rmw_pipe_dir_mem_wdata (pf_count_rmw_pipe_dir_mem_wdata)
,.pf_count_rmw_pipe_dir_mem_rdata (pf_count_rmw_pipe_dir_mem_rdata)

,.rf_count_rmw_pipe_dir_mem_rclk (rf_count_rmw_pipe_dir_mem_rclk)
,.rf_count_rmw_pipe_dir_mem_rclk_rst_n (rf_count_rmw_pipe_dir_mem_rclk_rst_n)
,.rf_count_rmw_pipe_dir_mem_re    (rf_count_rmw_pipe_dir_mem_re)
,.rf_count_rmw_pipe_dir_mem_raddr (rf_count_rmw_pipe_dir_mem_raddr)
,.rf_count_rmw_pipe_dir_mem_waddr (rf_count_rmw_pipe_dir_mem_waddr)
,.rf_count_rmw_pipe_dir_mem_wclk (rf_count_rmw_pipe_dir_mem_wclk)
,.rf_count_rmw_pipe_dir_mem_wclk_rst_n (rf_count_rmw_pipe_dir_mem_wclk_rst_n)
,.rf_count_rmw_pipe_dir_mem_we    (rf_count_rmw_pipe_dir_mem_we)
,.rf_count_rmw_pipe_dir_mem_wdata (rf_count_rmw_pipe_dir_mem_wdata)
,.rf_count_rmw_pipe_dir_mem_rdata (rf_count_rmw_pipe_dir_mem_rdata)

,.rf_count_rmw_pipe_dir_mem_error (rf_count_rmw_pipe_dir_mem_error)

,.func_count_rmw_pipe_ldb_mem_re    (func_count_rmw_pipe_ldb_mem_re)
,.func_count_rmw_pipe_ldb_mem_raddr (func_count_rmw_pipe_ldb_mem_raddr)
,.func_count_rmw_pipe_ldb_mem_waddr (func_count_rmw_pipe_ldb_mem_waddr)
,.func_count_rmw_pipe_ldb_mem_we    (func_count_rmw_pipe_ldb_mem_we)
,.func_count_rmw_pipe_ldb_mem_wdata (func_count_rmw_pipe_ldb_mem_wdata)
,.func_count_rmw_pipe_ldb_mem_rdata (func_count_rmw_pipe_ldb_mem_rdata)

,.pf_count_rmw_pipe_ldb_mem_re      (pf_count_rmw_pipe_ldb_mem_re)
,.pf_count_rmw_pipe_ldb_mem_raddr (pf_count_rmw_pipe_ldb_mem_raddr)
,.pf_count_rmw_pipe_ldb_mem_waddr (pf_count_rmw_pipe_ldb_mem_waddr)
,.pf_count_rmw_pipe_ldb_mem_we    (pf_count_rmw_pipe_ldb_mem_we)
,.pf_count_rmw_pipe_ldb_mem_wdata (pf_count_rmw_pipe_ldb_mem_wdata)
,.pf_count_rmw_pipe_ldb_mem_rdata (pf_count_rmw_pipe_ldb_mem_rdata)

,.rf_count_rmw_pipe_ldb_mem_rclk (rf_count_rmw_pipe_ldb_mem_rclk)
,.rf_count_rmw_pipe_ldb_mem_rclk_rst_n (rf_count_rmw_pipe_ldb_mem_rclk_rst_n)
,.rf_count_rmw_pipe_ldb_mem_re    (rf_count_rmw_pipe_ldb_mem_re)
,.rf_count_rmw_pipe_ldb_mem_raddr (rf_count_rmw_pipe_ldb_mem_raddr)
,.rf_count_rmw_pipe_ldb_mem_waddr (rf_count_rmw_pipe_ldb_mem_waddr)
,.rf_count_rmw_pipe_ldb_mem_wclk (rf_count_rmw_pipe_ldb_mem_wclk)
,.rf_count_rmw_pipe_ldb_mem_wclk_rst_n (rf_count_rmw_pipe_ldb_mem_wclk_rst_n)
,.rf_count_rmw_pipe_ldb_mem_we    (rf_count_rmw_pipe_ldb_mem_we)
,.rf_count_rmw_pipe_ldb_mem_wdata (rf_count_rmw_pipe_ldb_mem_wdata)
,.rf_count_rmw_pipe_ldb_mem_rdata (rf_count_rmw_pipe_ldb_mem_rdata)

,.rf_count_rmw_pipe_ldb_mem_error (rf_count_rmw_pipe_ldb_mem_error)

,.func_count_rmw_pipe_wd_dir_mem_re    (func_count_rmw_pipe_wd_dir_mem_re)
,.func_count_rmw_pipe_wd_dir_mem_raddr (func_count_rmw_pipe_wd_dir_mem_raddr)
,.func_count_rmw_pipe_wd_dir_mem_waddr (func_count_rmw_pipe_wd_dir_mem_waddr)
,.func_count_rmw_pipe_wd_dir_mem_we    (func_count_rmw_pipe_wd_dir_mem_we)
,.func_count_rmw_pipe_wd_dir_mem_wdata (func_count_rmw_pipe_wd_dir_mem_wdata)
,.func_count_rmw_pipe_wd_dir_mem_rdata (func_count_rmw_pipe_wd_dir_mem_rdata)

,.pf_count_rmw_pipe_wd_dir_mem_re      (pf_count_rmw_pipe_wd_dir_mem_re)
,.pf_count_rmw_pipe_wd_dir_mem_raddr (pf_count_rmw_pipe_wd_dir_mem_raddr)
,.pf_count_rmw_pipe_wd_dir_mem_waddr (pf_count_rmw_pipe_wd_dir_mem_waddr)
,.pf_count_rmw_pipe_wd_dir_mem_we    (pf_count_rmw_pipe_wd_dir_mem_we)
,.pf_count_rmw_pipe_wd_dir_mem_wdata (pf_count_rmw_pipe_wd_dir_mem_wdata)
,.pf_count_rmw_pipe_wd_dir_mem_rdata (pf_count_rmw_pipe_wd_dir_mem_rdata)

,.rf_count_rmw_pipe_wd_dir_mem_rclk (rf_count_rmw_pipe_wd_dir_mem_rclk)
,.rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n (rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n)
,.rf_count_rmw_pipe_wd_dir_mem_re    (rf_count_rmw_pipe_wd_dir_mem_re)
,.rf_count_rmw_pipe_wd_dir_mem_raddr (rf_count_rmw_pipe_wd_dir_mem_raddr)
,.rf_count_rmw_pipe_wd_dir_mem_waddr (rf_count_rmw_pipe_wd_dir_mem_waddr)
,.rf_count_rmw_pipe_wd_dir_mem_wclk (rf_count_rmw_pipe_wd_dir_mem_wclk)
,.rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n (rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n)
,.rf_count_rmw_pipe_wd_dir_mem_we    (rf_count_rmw_pipe_wd_dir_mem_we)
,.rf_count_rmw_pipe_wd_dir_mem_wdata (rf_count_rmw_pipe_wd_dir_mem_wdata)
,.rf_count_rmw_pipe_wd_dir_mem_rdata (rf_count_rmw_pipe_wd_dir_mem_rdata)

,.rf_count_rmw_pipe_wd_dir_mem_error (rf_count_rmw_pipe_wd_dir_mem_error)

,.func_count_rmw_pipe_wd_ldb_mem_re    (func_count_rmw_pipe_wd_ldb_mem_re)
,.func_count_rmw_pipe_wd_ldb_mem_raddr (func_count_rmw_pipe_wd_ldb_mem_raddr)
,.func_count_rmw_pipe_wd_ldb_mem_waddr (func_count_rmw_pipe_wd_ldb_mem_waddr)
,.func_count_rmw_pipe_wd_ldb_mem_we    (func_count_rmw_pipe_wd_ldb_mem_we)
,.func_count_rmw_pipe_wd_ldb_mem_wdata (func_count_rmw_pipe_wd_ldb_mem_wdata)
,.func_count_rmw_pipe_wd_ldb_mem_rdata (func_count_rmw_pipe_wd_ldb_mem_rdata)

,.pf_count_rmw_pipe_wd_ldb_mem_re      (pf_count_rmw_pipe_wd_ldb_mem_re)
,.pf_count_rmw_pipe_wd_ldb_mem_raddr (pf_count_rmw_pipe_wd_ldb_mem_raddr)
,.pf_count_rmw_pipe_wd_ldb_mem_waddr (pf_count_rmw_pipe_wd_ldb_mem_waddr)
,.pf_count_rmw_pipe_wd_ldb_mem_we    (pf_count_rmw_pipe_wd_ldb_mem_we)
,.pf_count_rmw_pipe_wd_ldb_mem_wdata (pf_count_rmw_pipe_wd_ldb_mem_wdata)
,.pf_count_rmw_pipe_wd_ldb_mem_rdata (pf_count_rmw_pipe_wd_ldb_mem_rdata)

,.rf_count_rmw_pipe_wd_ldb_mem_rclk (rf_count_rmw_pipe_wd_ldb_mem_rclk)
,.rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n (rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n)
,.rf_count_rmw_pipe_wd_ldb_mem_re    (rf_count_rmw_pipe_wd_ldb_mem_re)
,.rf_count_rmw_pipe_wd_ldb_mem_raddr (rf_count_rmw_pipe_wd_ldb_mem_raddr)
,.rf_count_rmw_pipe_wd_ldb_mem_waddr (rf_count_rmw_pipe_wd_ldb_mem_waddr)
,.rf_count_rmw_pipe_wd_ldb_mem_wclk (rf_count_rmw_pipe_wd_ldb_mem_wclk)
,.rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n (rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n)
,.rf_count_rmw_pipe_wd_ldb_mem_we    (rf_count_rmw_pipe_wd_ldb_mem_we)
,.rf_count_rmw_pipe_wd_ldb_mem_wdata (rf_count_rmw_pipe_wd_ldb_mem_wdata)
,.rf_count_rmw_pipe_wd_ldb_mem_rdata (rf_count_rmw_pipe_wd_ldb_mem_rdata)

,.rf_count_rmw_pipe_wd_ldb_mem_error (rf_count_rmw_pipe_wd_ldb_mem_error)

,.func_dir_cq_depth_re    (func_dir_cq_depth_re)
,.func_dir_cq_depth_raddr (func_dir_cq_depth_raddr)
,.func_dir_cq_depth_waddr (func_dir_cq_depth_waddr)
,.func_dir_cq_depth_we    (func_dir_cq_depth_we)
,.func_dir_cq_depth_wdata (func_dir_cq_depth_wdata)
,.func_dir_cq_depth_rdata (func_dir_cq_depth_rdata)

,.pf_dir_cq_depth_re      (pf_dir_cq_depth_re)
,.pf_dir_cq_depth_raddr (pf_dir_cq_depth_raddr)
,.pf_dir_cq_depth_waddr (pf_dir_cq_depth_waddr)
,.pf_dir_cq_depth_we    (pf_dir_cq_depth_we)
,.pf_dir_cq_depth_wdata (pf_dir_cq_depth_wdata)
,.pf_dir_cq_depth_rdata (pf_dir_cq_depth_rdata)

,.rf_dir_cq_depth_rclk (rf_dir_cq_depth_rclk)
,.rf_dir_cq_depth_rclk_rst_n (rf_dir_cq_depth_rclk_rst_n)
,.rf_dir_cq_depth_re    (rf_dir_cq_depth_re)
,.rf_dir_cq_depth_raddr (rf_dir_cq_depth_raddr)
,.rf_dir_cq_depth_waddr (rf_dir_cq_depth_waddr)
,.rf_dir_cq_depth_wclk (rf_dir_cq_depth_wclk)
,.rf_dir_cq_depth_wclk_rst_n (rf_dir_cq_depth_wclk_rst_n)
,.rf_dir_cq_depth_we    (rf_dir_cq_depth_we)
,.rf_dir_cq_depth_wdata (rf_dir_cq_depth_wdata_struct)
,.rf_dir_cq_depth_rdata (rf_dir_cq_depth_rdata_struct)
,.rf_dir_cq_depth_error (rf_dir_cq_depth_error)

,.func_dir_cq_intr_thresh_re    (func_dir_cq_intr_thresh_re)
,.func_dir_cq_intr_thresh_raddr (func_dir_cq_intr_thresh_raddr)
,.func_dir_cq_intr_thresh_waddr (func_dir_cq_intr_thresh_waddr)
,.func_dir_cq_intr_thresh_we    (func_dir_cq_intr_thresh_we)
,.func_dir_cq_intr_thresh_wdata (func_dir_cq_intr_thresh_wdata)
,.func_dir_cq_intr_thresh_rdata (func_dir_cq_intr_thresh_rdata)

,.pf_dir_cq_intr_thresh_re      (pf_dir_cq_intr_thresh_re)
,.pf_dir_cq_intr_thresh_raddr (pf_dir_cq_intr_thresh_raddr)
,.pf_dir_cq_intr_thresh_waddr (pf_dir_cq_intr_thresh_waddr)
,.pf_dir_cq_intr_thresh_we    (pf_dir_cq_intr_thresh_we)
,.pf_dir_cq_intr_thresh_wdata (pf_dir_cq_intr_thresh_wdata)
,.pf_dir_cq_intr_thresh_rdata (pf_dir_cq_intr_thresh_rdata)

,.rf_dir_cq_intr_thresh_rclk (rf_dir_cq_intr_thresh_rclk)
,.rf_dir_cq_intr_thresh_rclk_rst_n (rf_dir_cq_intr_thresh_rclk_rst_n)
,.rf_dir_cq_intr_thresh_re    (rf_dir_cq_intr_thresh_re)
,.rf_dir_cq_intr_thresh_raddr (rf_dir_cq_intr_thresh_raddr)
,.rf_dir_cq_intr_thresh_waddr (rf_dir_cq_intr_thresh_waddr)
,.rf_dir_cq_intr_thresh_wclk (rf_dir_cq_intr_thresh_wclk)
,.rf_dir_cq_intr_thresh_wclk_rst_n (rf_dir_cq_intr_thresh_wclk_rst_n)
,.rf_dir_cq_intr_thresh_we    (rf_dir_cq_intr_thresh_we)
,.rf_dir_cq_intr_thresh_wdata (rf_dir_cq_intr_thresh_wdata_struct)
,.rf_dir_cq_intr_thresh_rdata (rf_dir_cq_intr_thresh_rdata_struct)
,.rf_dir_cq_intr_thresh_error (rf_dir_cq_intr_thresh_error)

,.func_dir_cq_token_depth_select_re    (func_dir_cq_token_depth_select_re)
,.func_dir_cq_token_depth_select_raddr (func_dir_cq_token_depth_select_raddr)
,.func_dir_cq_token_depth_select_waddr (func_dir_cq_token_depth_select_waddr)
,.func_dir_cq_token_depth_select_we    (func_dir_cq_token_depth_select_we)
,.func_dir_cq_token_depth_select_wdata (func_dir_cq_token_depth_select_wdata)
,.func_dir_cq_token_depth_select_rdata (func_dir_cq_token_depth_select_rdata)

,.pf_dir_cq_token_depth_select_re      (pf_dir_cq_token_depth_select_re)
,.pf_dir_cq_token_depth_select_raddr (pf_dir_cq_token_depth_select_raddr)
,.pf_dir_cq_token_depth_select_waddr (pf_dir_cq_token_depth_select_waddr)
,.pf_dir_cq_token_depth_select_we    (pf_dir_cq_token_depth_select_we)
,.pf_dir_cq_token_depth_select_wdata (pf_dir_cq_token_depth_select_wdata)
,.pf_dir_cq_token_depth_select_rdata (pf_dir_cq_token_depth_select_rdata)

,.rf_dir_cq_token_depth_select_rclk (rf_dir_cq_token_depth_select_rclk)
,.rf_dir_cq_token_depth_select_rclk_rst_n (rf_dir_cq_token_depth_select_rclk_rst_n)
,.rf_dir_cq_token_depth_select_re    (rf_dir_cq_token_depth_select_re)
,.rf_dir_cq_token_depth_select_raddr (rf_dir_cq_token_depth_select_raddr)
,.rf_dir_cq_token_depth_select_waddr (rf_dir_cq_token_depth_select_waddr)
,.rf_dir_cq_token_depth_select_wclk (rf_dir_cq_token_depth_select_wclk)
,.rf_dir_cq_token_depth_select_wclk_rst_n (rf_dir_cq_token_depth_select_wclk_rst_n)
,.rf_dir_cq_token_depth_select_we    (rf_dir_cq_token_depth_select_we)
,.rf_dir_cq_token_depth_select_wdata (rf_dir_cq_token_depth_select_wdata_struct)
,.rf_dir_cq_token_depth_select_rdata (rf_dir_cq_token_depth_select_rdata_struct)
,.rf_dir_cq_token_depth_select_error (rf_dir_cq_token_depth_select_error)

,.func_dir_cq_wptr_re    (func_dir_cq_wptr_re)
,.func_dir_cq_wptr_raddr (func_dir_cq_wptr_raddr)
,.func_dir_cq_wptr_waddr (func_dir_cq_wptr_waddr)
,.func_dir_cq_wptr_we    (func_dir_cq_wptr_we)
,.func_dir_cq_wptr_wdata (func_dir_cq_wptr_wdata)
,.func_dir_cq_wptr_rdata (func_dir_cq_wptr_rdata)

,.pf_dir_cq_wptr_re      (pf_dir_cq_wptr_re)
,.pf_dir_cq_wptr_raddr (pf_dir_cq_wptr_raddr)
,.pf_dir_cq_wptr_waddr (pf_dir_cq_wptr_waddr)
,.pf_dir_cq_wptr_we    (pf_dir_cq_wptr_we)
,.pf_dir_cq_wptr_wdata (pf_dir_cq_wptr_wdata)
,.pf_dir_cq_wptr_rdata (pf_dir_cq_wptr_rdata)

,.rf_dir_cq_wptr_rclk (rf_dir_cq_wptr_rclk)
,.rf_dir_cq_wptr_rclk_rst_n (rf_dir_cq_wptr_rclk_rst_n)
,.rf_dir_cq_wptr_re    (rf_dir_cq_wptr_re)
,.rf_dir_cq_wptr_raddr (rf_dir_cq_wptr_raddr)
,.rf_dir_cq_wptr_waddr (rf_dir_cq_wptr_waddr)
,.rf_dir_cq_wptr_wclk (rf_dir_cq_wptr_wclk)
,.rf_dir_cq_wptr_wclk_rst_n (rf_dir_cq_wptr_wclk_rst_n)
,.rf_dir_cq_wptr_we    (rf_dir_cq_wptr_we)
,.rf_dir_cq_wptr_wdata (rf_dir_cq_wptr_wdata_struct)
,.rf_dir_cq_wptr_rdata (rf_dir_cq_wptr_rdata_struct)
,.rf_dir_cq_wptr_error (rf_dir_cq_wptr_error)

,.func_hcw_enq_w_rx_sync_mem_re    (func_hcw_enq_w_rx_sync_mem_re)
,.func_hcw_enq_w_rx_sync_mem_raddr (func_hcw_enq_w_rx_sync_mem_raddr)
,.func_hcw_enq_w_rx_sync_mem_waddr (func_hcw_enq_w_rx_sync_mem_waddr)
,.func_hcw_enq_w_rx_sync_mem_we    (func_hcw_enq_w_rx_sync_mem_we)
,.func_hcw_enq_w_rx_sync_mem_wdata (func_hcw_enq_w_rx_sync_mem_wdata)
,.func_hcw_enq_w_rx_sync_mem_rdata (func_hcw_enq_w_rx_sync_mem_rdata)

,.pf_hcw_enq_w_rx_sync_mem_re      (pf_hcw_enq_w_rx_sync_mem_re)
,.pf_hcw_enq_w_rx_sync_mem_raddr (pf_hcw_enq_w_rx_sync_mem_raddr)
,.pf_hcw_enq_w_rx_sync_mem_waddr (pf_hcw_enq_w_rx_sync_mem_waddr)
,.pf_hcw_enq_w_rx_sync_mem_we    (pf_hcw_enq_w_rx_sync_mem_we)
,.pf_hcw_enq_w_rx_sync_mem_wdata (pf_hcw_enq_w_rx_sync_mem_wdata)
,.pf_hcw_enq_w_rx_sync_mem_rdata (pf_hcw_enq_w_rx_sync_mem_rdata)

,.rf_hcw_enq_w_rx_sync_mem_rclk (rf_hcw_enq_w_rx_sync_mem_rclk)
,.rf_hcw_enq_w_rx_sync_mem_rclk_rst_n (rf_hcw_enq_w_rx_sync_mem_rclk_rst_n)
,.rf_hcw_enq_w_rx_sync_mem_re    (rf_hcw_enq_w_rx_sync_mem_re)
,.rf_hcw_enq_w_rx_sync_mem_raddr (rf_hcw_enq_w_rx_sync_mem_raddr)
,.rf_hcw_enq_w_rx_sync_mem_waddr (rf_hcw_enq_w_rx_sync_mem_waddr)
,.rf_hcw_enq_w_rx_sync_mem_wclk (rf_hcw_enq_w_rx_sync_mem_wclk)
,.rf_hcw_enq_w_rx_sync_mem_wclk_rst_n (rf_hcw_enq_w_rx_sync_mem_wclk_rst_n)
,.rf_hcw_enq_w_rx_sync_mem_we    (rf_hcw_enq_w_rx_sync_mem_we)
,.rf_hcw_enq_w_rx_sync_mem_wdata (rf_hcw_enq_w_rx_sync_mem_wdata)
,.rf_hcw_enq_w_rx_sync_mem_rdata (rf_hcw_enq_w_rx_sync_mem_rdata)

,.rf_hcw_enq_w_rx_sync_mem_error (rf_hcw_enq_w_rx_sync_mem_error)

,.func_hist_list_a_minmax_re    (func_hist_list_a_minmax_re)
,.func_hist_list_a_minmax_addr  (func_hist_list_a_minmax_addr)
,.func_hist_list_a_minmax_we    (func_hist_list_a_minmax_we)
,.func_hist_list_a_minmax_wdata (func_hist_list_a_minmax_wdata)
,.func_hist_list_a_minmax_rdata (func_hist_list_a_minmax_rdata)

,.pf_hist_list_a_minmax_re      (pf_hist_list_a_minmax_re)
,.pf_hist_list_a_minmax_addr  (pf_hist_list_a_minmax_addr)
,.pf_hist_list_a_minmax_we    (pf_hist_list_a_minmax_we)
,.pf_hist_list_a_minmax_wdata (pf_hist_list_a_minmax_wdata)
,.pf_hist_list_a_minmax_rdata (pf_hist_list_a_minmax_rdata)

,.rf_hist_list_a_minmax_rclk (rf_hist_list_a_minmax_rclk)
,.rf_hist_list_a_minmax_rclk_rst_n (rf_hist_list_a_minmax_rclk_rst_n)
,.rf_hist_list_a_minmax_re    (rf_hist_list_a_minmax_re)
,.rf_hist_list_a_minmax_raddr (rf_hist_list_a_minmax_raddr)
,.rf_hist_list_a_minmax_waddr (rf_hist_list_a_minmax_waddr)
,.rf_hist_list_a_minmax_wclk (rf_hist_list_a_minmax_wclk)
,.rf_hist_list_a_minmax_wclk_rst_n (rf_hist_list_a_minmax_wclk_rst_n)
,.rf_hist_list_a_minmax_we    (rf_hist_list_a_minmax_we)
,.rf_hist_list_a_minmax_wdata (rf_hist_list_a_minmax_wdata_struct)
,.rf_hist_list_a_minmax_rdata (rf_hist_list_a_minmax_rdata_struct)
,.rf_hist_list_a_minmax_error (rf_hist_list_a_minmax_error)

,.func_hist_list_a_ptr_re    (func_hist_list_a_ptr_re)
,.func_hist_list_a_ptr_raddr (func_hist_list_a_ptr_raddr)
,.func_hist_list_a_ptr_waddr (func_hist_list_a_ptr_waddr)
,.func_hist_list_a_ptr_we    (func_hist_list_a_ptr_we)
,.func_hist_list_a_ptr_wdata (func_hist_list_a_ptr_wdata)
,.func_hist_list_a_ptr_rdata (func_hist_list_a_ptr_rdata)

,.pf_hist_list_a_ptr_re      (pf_hist_list_a_ptr_re)
,.pf_hist_list_a_ptr_raddr (pf_hist_list_a_ptr_raddr)
,.pf_hist_list_a_ptr_waddr (pf_hist_list_a_ptr_waddr)
,.pf_hist_list_a_ptr_we    (pf_hist_list_a_ptr_we)
,.pf_hist_list_a_ptr_wdata (pf_hist_list_a_ptr_wdata)
,.pf_hist_list_a_ptr_rdata (pf_hist_list_a_ptr_rdata)

,.rf_hist_list_a_ptr_rclk (rf_hist_list_a_ptr_rclk)
,.rf_hist_list_a_ptr_rclk_rst_n (rf_hist_list_a_ptr_rclk_rst_n)
,.rf_hist_list_a_ptr_re    (rf_hist_list_a_ptr_re)
,.rf_hist_list_a_ptr_raddr (rf_hist_list_a_ptr_raddr)
,.rf_hist_list_a_ptr_waddr (rf_hist_list_a_ptr_waddr)
,.rf_hist_list_a_ptr_wclk (rf_hist_list_a_ptr_wclk)
,.rf_hist_list_a_ptr_wclk_rst_n (rf_hist_list_a_ptr_wclk_rst_n)
,.rf_hist_list_a_ptr_we    (rf_hist_list_a_ptr_we)
,.rf_hist_list_a_ptr_wdata (rf_hist_list_a_ptr_wdata_struct)
,.rf_hist_list_a_ptr_rdata (rf_hist_list_a_ptr_rdata_struct)
,.rf_hist_list_a_ptr_error (rf_hist_list_a_ptr_error)

,.func_hist_list_minmax_re    (func_hist_list_minmax_re)
,.func_hist_list_minmax_addr  (func_hist_list_minmax_addr)
,.func_hist_list_minmax_we    (func_hist_list_minmax_we)
,.func_hist_list_minmax_wdata (func_hist_list_minmax_wdata)
,.func_hist_list_minmax_rdata (func_hist_list_minmax_rdata)

,.pf_hist_list_minmax_re      (pf_hist_list_minmax_re)
,.pf_hist_list_minmax_addr  (pf_hist_list_minmax_addr)
,.pf_hist_list_minmax_we    (pf_hist_list_minmax_we)
,.pf_hist_list_minmax_wdata (pf_hist_list_minmax_wdata)
,.pf_hist_list_minmax_rdata (pf_hist_list_minmax_rdata)

,.rf_hist_list_minmax_rclk (rf_hist_list_minmax_rclk)
,.rf_hist_list_minmax_rclk_rst_n (rf_hist_list_minmax_rclk_rst_n)
,.rf_hist_list_minmax_re    (rf_hist_list_minmax_re)
,.rf_hist_list_minmax_raddr (rf_hist_list_minmax_raddr)
,.rf_hist_list_minmax_waddr (rf_hist_list_minmax_waddr)
,.rf_hist_list_minmax_wclk (rf_hist_list_minmax_wclk)
,.rf_hist_list_minmax_wclk_rst_n (rf_hist_list_minmax_wclk_rst_n)
,.rf_hist_list_minmax_we    (rf_hist_list_minmax_we)
,.rf_hist_list_minmax_wdata (rf_hist_list_minmax_wdata_struct)
,.rf_hist_list_minmax_rdata (rf_hist_list_minmax_rdata_struct)
,.rf_hist_list_minmax_error (rf_hist_list_minmax_error)

,.func_hist_list_ptr_re    (func_hist_list_ptr_re)
,.func_hist_list_ptr_raddr (func_hist_list_ptr_raddr)
,.func_hist_list_ptr_waddr (func_hist_list_ptr_waddr)
,.func_hist_list_ptr_we    (func_hist_list_ptr_we)
,.func_hist_list_ptr_wdata (func_hist_list_ptr_wdata)
,.func_hist_list_ptr_rdata (func_hist_list_ptr_rdata)

,.pf_hist_list_ptr_re      (pf_hist_list_ptr_re)
,.pf_hist_list_ptr_raddr (pf_hist_list_ptr_raddr)
,.pf_hist_list_ptr_waddr (pf_hist_list_ptr_waddr)
,.pf_hist_list_ptr_we    (pf_hist_list_ptr_we)
,.pf_hist_list_ptr_wdata (pf_hist_list_ptr_wdata)
,.pf_hist_list_ptr_rdata (pf_hist_list_ptr_rdata)

,.rf_hist_list_ptr_rclk (rf_hist_list_ptr_rclk)
,.rf_hist_list_ptr_rclk_rst_n (rf_hist_list_ptr_rclk_rst_n)
,.rf_hist_list_ptr_re    (rf_hist_list_ptr_re)
,.rf_hist_list_ptr_raddr (rf_hist_list_ptr_raddr)
,.rf_hist_list_ptr_waddr (rf_hist_list_ptr_waddr)
,.rf_hist_list_ptr_wclk (rf_hist_list_ptr_wclk)
,.rf_hist_list_ptr_wclk_rst_n (rf_hist_list_ptr_wclk_rst_n)
,.rf_hist_list_ptr_we    (rf_hist_list_ptr_we)
,.rf_hist_list_ptr_wdata (rf_hist_list_ptr_wdata_struct)
,.rf_hist_list_ptr_rdata (rf_hist_list_ptr_rdata_struct)
,.rf_hist_list_ptr_error (rf_hist_list_ptr_error)

,.func_ldb_cq_depth_re    (func_ldb_cq_depth_re)
,.func_ldb_cq_depth_raddr (func_ldb_cq_depth_raddr)
,.func_ldb_cq_depth_waddr (func_ldb_cq_depth_waddr)
,.func_ldb_cq_depth_we    (func_ldb_cq_depth_we)
,.func_ldb_cq_depth_wdata (func_ldb_cq_depth_wdata)
,.func_ldb_cq_depth_rdata (func_ldb_cq_depth_rdata)

,.pf_ldb_cq_depth_re      (pf_ldb_cq_depth_re)
,.pf_ldb_cq_depth_raddr (pf_ldb_cq_depth_raddr)
,.pf_ldb_cq_depth_waddr (pf_ldb_cq_depth_waddr)
,.pf_ldb_cq_depth_we    (pf_ldb_cq_depth_we)
,.pf_ldb_cq_depth_wdata (pf_ldb_cq_depth_wdata)
,.pf_ldb_cq_depth_rdata (pf_ldb_cq_depth_rdata)

,.rf_ldb_cq_depth_rclk (rf_ldb_cq_depth_rclk)
,.rf_ldb_cq_depth_rclk_rst_n (rf_ldb_cq_depth_rclk_rst_n)
,.rf_ldb_cq_depth_re    (rf_ldb_cq_depth_re)
,.rf_ldb_cq_depth_raddr (rf_ldb_cq_depth_raddr)
,.rf_ldb_cq_depth_waddr (rf_ldb_cq_depth_waddr)
,.rf_ldb_cq_depth_wclk (rf_ldb_cq_depth_wclk)
,.rf_ldb_cq_depth_wclk_rst_n (rf_ldb_cq_depth_wclk_rst_n)
,.rf_ldb_cq_depth_we    (rf_ldb_cq_depth_we)
,.rf_ldb_cq_depth_wdata (rf_ldb_cq_depth_wdata_struct)
,.rf_ldb_cq_depth_rdata (rf_ldb_cq_depth_rdata_struct)
,.rf_ldb_cq_depth_error (rf_ldb_cq_depth_error)

,.func_ldb_cq_intr_thresh_re    (func_ldb_cq_intr_thresh_re)
,.func_ldb_cq_intr_thresh_raddr (func_ldb_cq_intr_thresh_raddr)
,.func_ldb_cq_intr_thresh_waddr (func_ldb_cq_intr_thresh_waddr)
,.func_ldb_cq_intr_thresh_we    (func_ldb_cq_intr_thresh_we)
,.func_ldb_cq_intr_thresh_wdata (func_ldb_cq_intr_thresh_wdata)
,.func_ldb_cq_intr_thresh_rdata (func_ldb_cq_intr_thresh_rdata)

,.pf_ldb_cq_intr_thresh_re      (pf_ldb_cq_intr_thresh_re)
,.pf_ldb_cq_intr_thresh_raddr (pf_ldb_cq_intr_thresh_raddr)
,.pf_ldb_cq_intr_thresh_waddr (pf_ldb_cq_intr_thresh_waddr)
,.pf_ldb_cq_intr_thresh_we    (pf_ldb_cq_intr_thresh_we)
,.pf_ldb_cq_intr_thresh_wdata (pf_ldb_cq_intr_thresh_wdata)
,.pf_ldb_cq_intr_thresh_rdata (pf_ldb_cq_intr_thresh_rdata)

,.rf_ldb_cq_intr_thresh_rclk (rf_ldb_cq_intr_thresh_rclk)
,.rf_ldb_cq_intr_thresh_rclk_rst_n (rf_ldb_cq_intr_thresh_rclk_rst_n)
,.rf_ldb_cq_intr_thresh_re    (rf_ldb_cq_intr_thresh_re)
,.rf_ldb_cq_intr_thresh_raddr (rf_ldb_cq_intr_thresh_raddr)
,.rf_ldb_cq_intr_thresh_waddr (rf_ldb_cq_intr_thresh_waddr)
,.rf_ldb_cq_intr_thresh_wclk (rf_ldb_cq_intr_thresh_wclk)
,.rf_ldb_cq_intr_thresh_wclk_rst_n (rf_ldb_cq_intr_thresh_wclk_rst_n)
,.rf_ldb_cq_intr_thresh_we    (rf_ldb_cq_intr_thresh_we)
,.rf_ldb_cq_intr_thresh_wdata (rf_ldb_cq_intr_thresh_wdata_struct)
,.rf_ldb_cq_intr_thresh_rdata (rf_ldb_cq_intr_thresh_rdata_struct)
,.rf_ldb_cq_intr_thresh_error (rf_ldb_cq_intr_thresh_error)

,.func_ldb_cq_on_off_threshold_re    (func_ldb_cq_on_off_threshold_re)
,.func_ldb_cq_on_off_threshold_raddr (func_ldb_cq_on_off_threshold_raddr)
,.func_ldb_cq_on_off_threshold_waddr (func_ldb_cq_on_off_threshold_waddr)
,.func_ldb_cq_on_off_threshold_we    (func_ldb_cq_on_off_threshold_we)
,.func_ldb_cq_on_off_threshold_wdata (func_ldb_cq_on_off_threshold_wdata)
,.func_ldb_cq_on_off_threshold_rdata (func_ldb_cq_on_off_threshold_rdata)

,.pf_ldb_cq_on_off_threshold_re      (pf_ldb_cq_on_off_threshold_re)
,.pf_ldb_cq_on_off_threshold_raddr (pf_ldb_cq_on_off_threshold_raddr)
,.pf_ldb_cq_on_off_threshold_waddr (pf_ldb_cq_on_off_threshold_waddr)
,.pf_ldb_cq_on_off_threshold_we    (pf_ldb_cq_on_off_threshold_we)
,.pf_ldb_cq_on_off_threshold_wdata (pf_ldb_cq_on_off_threshold_wdata)
,.pf_ldb_cq_on_off_threshold_rdata (pf_ldb_cq_on_off_threshold_rdata)

,.rf_ldb_cq_on_off_threshold_rclk (rf_ldb_cq_on_off_threshold_rclk)
,.rf_ldb_cq_on_off_threshold_rclk_rst_n (rf_ldb_cq_on_off_threshold_rclk_rst_n)
,.rf_ldb_cq_on_off_threshold_re    (rf_ldb_cq_on_off_threshold_re)
,.rf_ldb_cq_on_off_threshold_raddr (rf_ldb_cq_on_off_threshold_raddr)
,.rf_ldb_cq_on_off_threshold_waddr (rf_ldb_cq_on_off_threshold_waddr)
,.rf_ldb_cq_on_off_threshold_wclk (rf_ldb_cq_on_off_threshold_wclk)
,.rf_ldb_cq_on_off_threshold_wclk_rst_n (rf_ldb_cq_on_off_threshold_wclk_rst_n)
,.rf_ldb_cq_on_off_threshold_we    (rf_ldb_cq_on_off_threshold_we)
,.rf_ldb_cq_on_off_threshold_wdata (rf_ldb_cq_on_off_threshold_wdata_struct)
,.rf_ldb_cq_on_off_threshold_rdata (rf_ldb_cq_on_off_threshold_rdata_struct)
,.rf_ldb_cq_on_off_threshold_error (rf_ldb_cq_on_off_threshold_error)

,.func_ldb_cq_token_depth_select_re    (func_ldb_cq_token_depth_select_re)
,.func_ldb_cq_token_depth_select_raddr (func_ldb_cq_token_depth_select_raddr)
,.func_ldb_cq_token_depth_select_waddr (func_ldb_cq_token_depth_select_waddr)
,.func_ldb_cq_token_depth_select_we    (func_ldb_cq_token_depth_select_we)
,.func_ldb_cq_token_depth_select_wdata (func_ldb_cq_token_depth_select_wdata)
,.func_ldb_cq_token_depth_select_rdata (func_ldb_cq_token_depth_select_rdata)

,.pf_ldb_cq_token_depth_select_re      (pf_ldb_cq_token_depth_select_re)
,.pf_ldb_cq_token_depth_select_raddr (pf_ldb_cq_token_depth_select_raddr)
,.pf_ldb_cq_token_depth_select_waddr (pf_ldb_cq_token_depth_select_waddr)
,.pf_ldb_cq_token_depth_select_we    (pf_ldb_cq_token_depth_select_we)
,.pf_ldb_cq_token_depth_select_wdata (pf_ldb_cq_token_depth_select_wdata)
,.pf_ldb_cq_token_depth_select_rdata (pf_ldb_cq_token_depth_select_rdata)

,.rf_ldb_cq_token_depth_select_rclk (rf_ldb_cq_token_depth_select_rclk)
,.rf_ldb_cq_token_depth_select_rclk_rst_n (rf_ldb_cq_token_depth_select_rclk_rst_n)
,.rf_ldb_cq_token_depth_select_re    (rf_ldb_cq_token_depth_select_re)
,.rf_ldb_cq_token_depth_select_raddr (rf_ldb_cq_token_depth_select_raddr)
,.rf_ldb_cq_token_depth_select_waddr (rf_ldb_cq_token_depth_select_waddr)
,.rf_ldb_cq_token_depth_select_wclk (rf_ldb_cq_token_depth_select_wclk)
,.rf_ldb_cq_token_depth_select_wclk_rst_n (rf_ldb_cq_token_depth_select_wclk_rst_n)
,.rf_ldb_cq_token_depth_select_we    (rf_ldb_cq_token_depth_select_we)
,.rf_ldb_cq_token_depth_select_wdata (rf_ldb_cq_token_depth_select_wdata_struct)
,.rf_ldb_cq_token_depth_select_rdata (rf_ldb_cq_token_depth_select_rdata_struct)
,.rf_ldb_cq_token_depth_select_error (rf_ldb_cq_token_depth_select_error)

,.func_ldb_cq_wptr_re    (func_ldb_cq_wptr_re)
,.func_ldb_cq_wptr_raddr (func_ldb_cq_wptr_raddr)
,.func_ldb_cq_wptr_waddr (func_ldb_cq_wptr_waddr)
,.func_ldb_cq_wptr_we    (func_ldb_cq_wptr_we)
,.func_ldb_cq_wptr_wdata (func_ldb_cq_wptr_wdata)
,.func_ldb_cq_wptr_rdata (func_ldb_cq_wptr_rdata)

,.pf_ldb_cq_wptr_re      (pf_ldb_cq_wptr_re)
,.pf_ldb_cq_wptr_raddr (pf_ldb_cq_wptr_raddr)
,.pf_ldb_cq_wptr_waddr (pf_ldb_cq_wptr_waddr)
,.pf_ldb_cq_wptr_we    (pf_ldb_cq_wptr_we)
,.pf_ldb_cq_wptr_wdata (pf_ldb_cq_wptr_wdata)
,.pf_ldb_cq_wptr_rdata (pf_ldb_cq_wptr_rdata)

,.rf_ldb_cq_wptr_rclk (rf_ldb_cq_wptr_rclk)
,.rf_ldb_cq_wptr_rclk_rst_n (rf_ldb_cq_wptr_rclk_rst_n)
,.rf_ldb_cq_wptr_re    (rf_ldb_cq_wptr_re)
,.rf_ldb_cq_wptr_raddr (rf_ldb_cq_wptr_raddr)
,.rf_ldb_cq_wptr_waddr (rf_ldb_cq_wptr_waddr)
,.rf_ldb_cq_wptr_wclk (rf_ldb_cq_wptr_wclk)
,.rf_ldb_cq_wptr_wclk_rst_n (rf_ldb_cq_wptr_wclk_rst_n)
,.rf_ldb_cq_wptr_we    (rf_ldb_cq_wptr_we)
,.rf_ldb_cq_wptr_wdata (rf_ldb_cq_wptr_wdata_struct)
,.rf_ldb_cq_wptr_rdata (rf_ldb_cq_wptr_rdata_struct)
,.rf_ldb_cq_wptr_error (rf_ldb_cq_wptr_error)

,.func_ord_qid_sn_re    (func_ord_qid_sn_re)
,.func_ord_qid_sn_raddr (func_ord_qid_sn_raddr)
,.func_ord_qid_sn_waddr (func_ord_qid_sn_waddr)
,.func_ord_qid_sn_we    (func_ord_qid_sn_we)
,.func_ord_qid_sn_wdata (func_ord_qid_sn_wdata)
,.func_ord_qid_sn_rdata (func_ord_qid_sn_rdata)

,.pf_ord_qid_sn_re      (pf_ord_qid_sn_re)
,.pf_ord_qid_sn_raddr (pf_ord_qid_sn_raddr)
,.pf_ord_qid_sn_waddr (pf_ord_qid_sn_waddr)
,.pf_ord_qid_sn_we    (pf_ord_qid_sn_we)
,.pf_ord_qid_sn_wdata (pf_ord_qid_sn_wdata)
,.pf_ord_qid_sn_rdata (pf_ord_qid_sn_rdata)

,.rf_ord_qid_sn_rclk (rf_ord_qid_sn_rclk)
,.rf_ord_qid_sn_rclk_rst_n (rf_ord_qid_sn_rclk_rst_n)
,.rf_ord_qid_sn_re    (rf_ord_qid_sn_re)
,.rf_ord_qid_sn_raddr (rf_ord_qid_sn_raddr)
,.rf_ord_qid_sn_waddr (rf_ord_qid_sn_waddr)
,.rf_ord_qid_sn_wclk (rf_ord_qid_sn_wclk)
,.rf_ord_qid_sn_wclk_rst_n (rf_ord_qid_sn_wclk_rst_n)
,.rf_ord_qid_sn_we    (rf_ord_qid_sn_we)
,.rf_ord_qid_sn_wdata (rf_ord_qid_sn_wdata_struct)
,.rf_ord_qid_sn_rdata (rf_ord_qid_sn_rdata_struct)
,.rf_ord_qid_sn_error (rf_ord_qid_sn_error)

,.func_ord_qid_sn_map_re    (func_ord_qid_sn_map_re)
,.func_ord_qid_sn_map_raddr (func_ord_qid_sn_map_raddr)
,.func_ord_qid_sn_map_waddr (func_ord_qid_sn_map_waddr)
,.func_ord_qid_sn_map_we    (func_ord_qid_sn_map_we)
,.func_ord_qid_sn_map_wdata (func_ord_qid_sn_map_wdata)
,.func_ord_qid_sn_map_rdata (func_ord_qid_sn_map_rdata)

,.pf_ord_qid_sn_map_re      (pf_ord_qid_sn_map_re)
,.pf_ord_qid_sn_map_raddr (pf_ord_qid_sn_map_raddr)
,.pf_ord_qid_sn_map_waddr (pf_ord_qid_sn_map_waddr)
,.pf_ord_qid_sn_map_we    (pf_ord_qid_sn_map_we)
,.pf_ord_qid_sn_map_wdata (pf_ord_qid_sn_map_wdata)
,.pf_ord_qid_sn_map_rdata (pf_ord_qid_sn_map_rdata)

,.rf_ord_qid_sn_map_rclk (rf_ord_qid_sn_map_rclk)
,.rf_ord_qid_sn_map_rclk_rst_n (rf_ord_qid_sn_map_rclk_rst_n)
,.rf_ord_qid_sn_map_re    (rf_ord_qid_sn_map_re)
,.rf_ord_qid_sn_map_raddr (rf_ord_qid_sn_map_raddr)
,.rf_ord_qid_sn_map_waddr (rf_ord_qid_sn_map_waddr)
,.rf_ord_qid_sn_map_wclk (rf_ord_qid_sn_map_wclk)
,.rf_ord_qid_sn_map_wclk_rst_n (rf_ord_qid_sn_map_wclk_rst_n)
,.rf_ord_qid_sn_map_we    (rf_ord_qid_sn_map_we)
,.rf_ord_qid_sn_map_wdata (rf_ord_qid_sn_map_wdata_struct)
,.rf_ord_qid_sn_map_rdata (rf_ord_qid_sn_map_rdata_struct)
,.rf_ord_qid_sn_map_error (rf_ord_qid_sn_map_error)

,.func_outbound_hcw_fifo_mem_re    (func_outbound_hcw_fifo_mem_re)
,.func_outbound_hcw_fifo_mem_raddr (func_outbound_hcw_fifo_mem_raddr)
,.func_outbound_hcw_fifo_mem_waddr (func_outbound_hcw_fifo_mem_waddr)
,.func_outbound_hcw_fifo_mem_we    (func_outbound_hcw_fifo_mem_we)
,.func_outbound_hcw_fifo_mem_wdata (func_outbound_hcw_fifo_mem_wdata)
,.func_outbound_hcw_fifo_mem_rdata (func_outbound_hcw_fifo_mem_rdata)

,.pf_outbound_hcw_fifo_mem_re      (pf_outbound_hcw_fifo_mem_re)
,.pf_outbound_hcw_fifo_mem_raddr (pf_outbound_hcw_fifo_mem_raddr)
,.pf_outbound_hcw_fifo_mem_waddr (pf_outbound_hcw_fifo_mem_waddr)
,.pf_outbound_hcw_fifo_mem_we    (pf_outbound_hcw_fifo_mem_we)
,.pf_outbound_hcw_fifo_mem_wdata (pf_outbound_hcw_fifo_mem_wdata)
,.pf_outbound_hcw_fifo_mem_rdata (pf_outbound_hcw_fifo_mem_rdata)

,.rf_outbound_hcw_fifo_mem_rclk (rf_outbound_hcw_fifo_mem_rclk)
,.rf_outbound_hcw_fifo_mem_rclk_rst_n (rf_outbound_hcw_fifo_mem_rclk_rst_n)
,.rf_outbound_hcw_fifo_mem_re    (rf_outbound_hcw_fifo_mem_re)
,.rf_outbound_hcw_fifo_mem_raddr (rf_outbound_hcw_fifo_mem_raddr)
,.rf_outbound_hcw_fifo_mem_waddr (rf_outbound_hcw_fifo_mem_waddr)
,.rf_outbound_hcw_fifo_mem_wclk (rf_outbound_hcw_fifo_mem_wclk)
,.rf_outbound_hcw_fifo_mem_wclk_rst_n (rf_outbound_hcw_fifo_mem_wclk_rst_n)
,.rf_outbound_hcw_fifo_mem_we    (rf_outbound_hcw_fifo_mem_we)
,.rf_outbound_hcw_fifo_mem_wdata (rf_outbound_hcw_fifo_mem_wdata_struct)
,.rf_outbound_hcw_fifo_mem_rdata (rf_outbound_hcw_fifo_mem_rdata_struct)
,.rf_outbound_hcw_fifo_mem_error (rf_outbound_hcw_fifo_mem_error)

,.func_qed_chp_sch_flid_ret_rx_sync_mem_re    (func_qed_chp_sch_flid_ret_rx_sync_mem_re)
,.func_qed_chp_sch_flid_ret_rx_sync_mem_raddr (func_qed_chp_sch_flid_ret_rx_sync_mem_raddr)
,.func_qed_chp_sch_flid_ret_rx_sync_mem_waddr (func_qed_chp_sch_flid_ret_rx_sync_mem_waddr)
,.func_qed_chp_sch_flid_ret_rx_sync_mem_we    (func_qed_chp_sch_flid_ret_rx_sync_mem_we)
,.func_qed_chp_sch_flid_ret_rx_sync_mem_wdata (func_qed_chp_sch_flid_ret_rx_sync_mem_wdata)
,.func_qed_chp_sch_flid_ret_rx_sync_mem_rdata (func_qed_chp_sch_flid_ret_rx_sync_mem_rdata)

,.pf_qed_chp_sch_flid_ret_rx_sync_mem_re      (pf_qed_chp_sch_flid_ret_rx_sync_mem_re)
,.pf_qed_chp_sch_flid_ret_rx_sync_mem_raddr (pf_qed_chp_sch_flid_ret_rx_sync_mem_raddr)
,.pf_qed_chp_sch_flid_ret_rx_sync_mem_waddr (pf_qed_chp_sch_flid_ret_rx_sync_mem_waddr)
,.pf_qed_chp_sch_flid_ret_rx_sync_mem_we    (pf_qed_chp_sch_flid_ret_rx_sync_mem_we)
,.pf_qed_chp_sch_flid_ret_rx_sync_mem_wdata (pf_qed_chp_sch_flid_ret_rx_sync_mem_wdata)
,.pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata (pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata)

,.rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk (rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n (rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_re    (rf_qed_chp_sch_flid_ret_rx_sync_mem_re)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr (rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr (rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk (rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n (rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_we    (rf_qed_chp_sch_flid_ret_rx_sync_mem_we)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata (rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata)
,.rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata (rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata)

,.rf_qed_chp_sch_flid_ret_rx_sync_mem_error (rf_qed_chp_sch_flid_ret_rx_sync_mem_error)

,.func_qed_chp_sch_rx_sync_mem_re    (func_qed_chp_sch_rx_sync_mem_re)
,.func_qed_chp_sch_rx_sync_mem_raddr (func_qed_chp_sch_rx_sync_mem_raddr)
,.func_qed_chp_sch_rx_sync_mem_waddr (func_qed_chp_sch_rx_sync_mem_waddr)
,.func_qed_chp_sch_rx_sync_mem_we    (func_qed_chp_sch_rx_sync_mem_we)
,.func_qed_chp_sch_rx_sync_mem_wdata (func_qed_chp_sch_rx_sync_mem_wdata)
,.func_qed_chp_sch_rx_sync_mem_rdata (func_qed_chp_sch_rx_sync_mem_rdata)

,.pf_qed_chp_sch_rx_sync_mem_re      (pf_qed_chp_sch_rx_sync_mem_re)
,.pf_qed_chp_sch_rx_sync_mem_raddr (pf_qed_chp_sch_rx_sync_mem_raddr)
,.pf_qed_chp_sch_rx_sync_mem_waddr (pf_qed_chp_sch_rx_sync_mem_waddr)
,.pf_qed_chp_sch_rx_sync_mem_we    (pf_qed_chp_sch_rx_sync_mem_we)
,.pf_qed_chp_sch_rx_sync_mem_wdata (pf_qed_chp_sch_rx_sync_mem_wdata)
,.pf_qed_chp_sch_rx_sync_mem_rdata (pf_qed_chp_sch_rx_sync_mem_rdata)

,.rf_qed_chp_sch_rx_sync_mem_rclk (rf_qed_chp_sch_rx_sync_mem_rclk)
,.rf_qed_chp_sch_rx_sync_mem_rclk_rst_n (rf_qed_chp_sch_rx_sync_mem_rclk_rst_n)
,.rf_qed_chp_sch_rx_sync_mem_re    (rf_qed_chp_sch_rx_sync_mem_re)
,.rf_qed_chp_sch_rx_sync_mem_raddr (rf_qed_chp_sch_rx_sync_mem_raddr)
,.rf_qed_chp_sch_rx_sync_mem_waddr (rf_qed_chp_sch_rx_sync_mem_waddr)
,.rf_qed_chp_sch_rx_sync_mem_wclk (rf_qed_chp_sch_rx_sync_mem_wclk)
,.rf_qed_chp_sch_rx_sync_mem_wclk_rst_n (rf_qed_chp_sch_rx_sync_mem_wclk_rst_n)
,.rf_qed_chp_sch_rx_sync_mem_we    (rf_qed_chp_sch_rx_sync_mem_we)
,.rf_qed_chp_sch_rx_sync_mem_wdata (rf_qed_chp_sch_rx_sync_mem_wdata)
,.rf_qed_chp_sch_rx_sync_mem_rdata (rf_qed_chp_sch_rx_sync_mem_rdata)

,.rf_qed_chp_sch_rx_sync_mem_error (rf_qed_chp_sch_rx_sync_mem_error)

,.func_qed_to_cq_fifo_mem_re    (func_qed_to_cq_fifo_mem_re)
,.func_qed_to_cq_fifo_mem_raddr (func_qed_to_cq_fifo_mem_raddr)
,.func_qed_to_cq_fifo_mem_waddr (func_qed_to_cq_fifo_mem_waddr)
,.func_qed_to_cq_fifo_mem_we    (func_qed_to_cq_fifo_mem_we)
,.func_qed_to_cq_fifo_mem_wdata (func_qed_to_cq_fifo_mem_wdata)
,.func_qed_to_cq_fifo_mem_rdata (func_qed_to_cq_fifo_mem_rdata)

,.pf_qed_to_cq_fifo_mem_re      (pf_qed_to_cq_fifo_mem_re)
,.pf_qed_to_cq_fifo_mem_raddr (pf_qed_to_cq_fifo_mem_raddr)
,.pf_qed_to_cq_fifo_mem_waddr (pf_qed_to_cq_fifo_mem_waddr)
,.pf_qed_to_cq_fifo_mem_we    (pf_qed_to_cq_fifo_mem_we)
,.pf_qed_to_cq_fifo_mem_wdata (pf_qed_to_cq_fifo_mem_wdata)
,.pf_qed_to_cq_fifo_mem_rdata (pf_qed_to_cq_fifo_mem_rdata)

,.rf_qed_to_cq_fifo_mem_rclk (rf_qed_to_cq_fifo_mem_rclk)
,.rf_qed_to_cq_fifo_mem_rclk_rst_n (rf_qed_to_cq_fifo_mem_rclk_rst_n)
,.rf_qed_to_cq_fifo_mem_re    (rf_qed_to_cq_fifo_mem_re)
,.rf_qed_to_cq_fifo_mem_raddr (rf_qed_to_cq_fifo_mem_raddr)
,.rf_qed_to_cq_fifo_mem_waddr (rf_qed_to_cq_fifo_mem_waddr)
,.rf_qed_to_cq_fifo_mem_wclk (rf_qed_to_cq_fifo_mem_wclk)
,.rf_qed_to_cq_fifo_mem_wclk_rst_n (rf_qed_to_cq_fifo_mem_wclk_rst_n)
,.rf_qed_to_cq_fifo_mem_we    (rf_qed_to_cq_fifo_mem_we)
,.rf_qed_to_cq_fifo_mem_wdata (rf_qed_to_cq_fifo_mem_wdata)
,.rf_qed_to_cq_fifo_mem_rdata (rf_qed_to_cq_fifo_mem_rdata)

,.rf_qed_to_cq_fifo_mem_error (rf_qed_to_cq_fifo_mem_error)

,.func_threshold_r_pipe_dir_mem_re    (func_threshold_r_pipe_dir_mem_re)
,.func_threshold_r_pipe_dir_mem_addr  (func_threshold_r_pipe_dir_mem_addr)
,.func_threshold_r_pipe_dir_mem_we    (func_threshold_r_pipe_dir_mem_we)
,.func_threshold_r_pipe_dir_mem_wdata (func_threshold_r_pipe_dir_mem_wdata)
,.func_threshold_r_pipe_dir_mem_rdata (func_threshold_r_pipe_dir_mem_rdata)

,.pf_threshold_r_pipe_dir_mem_re      (pf_threshold_r_pipe_dir_mem_re)
,.pf_threshold_r_pipe_dir_mem_addr  (pf_threshold_r_pipe_dir_mem_addr)
,.pf_threshold_r_pipe_dir_mem_we    (pf_threshold_r_pipe_dir_mem_we)
,.pf_threshold_r_pipe_dir_mem_wdata (pf_threshold_r_pipe_dir_mem_wdata)
,.pf_threshold_r_pipe_dir_mem_rdata (pf_threshold_r_pipe_dir_mem_rdata)

,.rf_threshold_r_pipe_dir_mem_rclk (rf_threshold_r_pipe_dir_mem_rclk)
,.rf_threshold_r_pipe_dir_mem_rclk_rst_n (rf_threshold_r_pipe_dir_mem_rclk_rst_n)
,.rf_threshold_r_pipe_dir_mem_re    (rf_threshold_r_pipe_dir_mem_re)
,.rf_threshold_r_pipe_dir_mem_raddr (rf_threshold_r_pipe_dir_mem_raddr)
,.rf_threshold_r_pipe_dir_mem_waddr (rf_threshold_r_pipe_dir_mem_waddr)
,.rf_threshold_r_pipe_dir_mem_wclk (rf_threshold_r_pipe_dir_mem_wclk)
,.rf_threshold_r_pipe_dir_mem_wclk_rst_n (rf_threshold_r_pipe_dir_mem_wclk_rst_n)
,.rf_threshold_r_pipe_dir_mem_we    (rf_threshold_r_pipe_dir_mem_we)
,.rf_threshold_r_pipe_dir_mem_wdata (rf_threshold_r_pipe_dir_mem_wdata)
,.rf_threshold_r_pipe_dir_mem_rdata (rf_threshold_r_pipe_dir_mem_rdata)

,.rf_threshold_r_pipe_dir_mem_error (rf_threshold_r_pipe_dir_mem_error)

,.func_threshold_r_pipe_ldb_mem_re    (func_threshold_r_pipe_ldb_mem_re)
,.func_threshold_r_pipe_ldb_mem_addr  (func_threshold_r_pipe_ldb_mem_addr)
,.func_threshold_r_pipe_ldb_mem_we    (func_threshold_r_pipe_ldb_mem_we)
,.func_threshold_r_pipe_ldb_mem_wdata (func_threshold_r_pipe_ldb_mem_wdata)
,.func_threshold_r_pipe_ldb_mem_rdata (func_threshold_r_pipe_ldb_mem_rdata)

,.pf_threshold_r_pipe_ldb_mem_re      (pf_threshold_r_pipe_ldb_mem_re)
,.pf_threshold_r_pipe_ldb_mem_addr  (pf_threshold_r_pipe_ldb_mem_addr)
,.pf_threshold_r_pipe_ldb_mem_we    (pf_threshold_r_pipe_ldb_mem_we)
,.pf_threshold_r_pipe_ldb_mem_wdata (pf_threshold_r_pipe_ldb_mem_wdata)
,.pf_threshold_r_pipe_ldb_mem_rdata (pf_threshold_r_pipe_ldb_mem_rdata)

,.rf_threshold_r_pipe_ldb_mem_rclk (rf_threshold_r_pipe_ldb_mem_rclk)
,.rf_threshold_r_pipe_ldb_mem_rclk_rst_n (rf_threshold_r_pipe_ldb_mem_rclk_rst_n)
,.rf_threshold_r_pipe_ldb_mem_re    (rf_threshold_r_pipe_ldb_mem_re)
,.rf_threshold_r_pipe_ldb_mem_raddr (rf_threshold_r_pipe_ldb_mem_raddr)
,.rf_threshold_r_pipe_ldb_mem_waddr (rf_threshold_r_pipe_ldb_mem_waddr)
,.rf_threshold_r_pipe_ldb_mem_wclk (rf_threshold_r_pipe_ldb_mem_wclk)
,.rf_threshold_r_pipe_ldb_mem_wclk_rst_n (rf_threshold_r_pipe_ldb_mem_wclk_rst_n)
,.rf_threshold_r_pipe_ldb_mem_we    (rf_threshold_r_pipe_ldb_mem_we)
,.rf_threshold_r_pipe_ldb_mem_wdata (rf_threshold_r_pipe_ldb_mem_wdata)
,.rf_threshold_r_pipe_ldb_mem_rdata (rf_threshold_r_pipe_ldb_mem_rdata)

,.rf_threshold_r_pipe_ldb_mem_error (rf_threshold_r_pipe_ldb_mem_error)

,.func_freelist_0_re    (func_freelist_0_re)
,.func_freelist_0_addr  (func_freelist_0_addr)
,.func_freelist_0_we    (func_freelist_0_we)
,.func_freelist_0_wdata (func_freelist_0_wdata)
,.func_freelist_0_rdata (func_freelist_0_rdata)

,.pf_freelist_0_re      (pf_freelist_0_re)
,.pf_freelist_0_addr    (pf_freelist_0_addr)
,.pf_freelist_0_we      (pf_freelist_0_we)
,.pf_freelist_0_wdata   (pf_freelist_0_wdata)
,.pf_freelist_0_rdata   (pf_freelist_0_rdata)

,.sr_freelist_0_clk (sr_freelist_0_clk)
,.sr_freelist_0_clk_rst_n (sr_freelist_0_clk_rst_n)
,.sr_freelist_0_re    (sr_freelist_0_re)
,.sr_freelist_0_addr  (sr_freelist_0_addr)
,.sr_freelist_0_we    (sr_freelist_0_we)
,.sr_freelist_0_wdata (sr_freelist_0_wdata_struct)
,.sr_freelist_0_rdata (sr_freelist_0_rdata_struct)
,.sr_freelist_0_error (sr_freelist_0_error)

,.func_freelist_1_re    (func_freelist_1_re)
,.func_freelist_1_addr  (func_freelist_1_addr)
,.func_freelist_1_we    (func_freelist_1_we)
,.func_freelist_1_wdata (func_freelist_1_wdata)
,.func_freelist_1_rdata (func_freelist_1_rdata)

,.pf_freelist_1_re      (pf_freelist_1_re)
,.pf_freelist_1_addr    (pf_freelist_1_addr)
,.pf_freelist_1_we      (pf_freelist_1_we)
,.pf_freelist_1_wdata   (pf_freelist_1_wdata)
,.pf_freelist_1_rdata   (pf_freelist_1_rdata)

,.sr_freelist_1_clk (sr_freelist_1_clk)
,.sr_freelist_1_clk_rst_n (sr_freelist_1_clk_rst_n)
,.sr_freelist_1_re    (sr_freelist_1_re)
,.sr_freelist_1_addr  (sr_freelist_1_addr)
,.sr_freelist_1_we    (sr_freelist_1_we)
,.sr_freelist_1_wdata (sr_freelist_1_wdata_struct)
,.sr_freelist_1_rdata (sr_freelist_1_rdata_struct)
,.sr_freelist_1_error (sr_freelist_1_error)

,.func_freelist_2_re    (func_freelist_2_re)
,.func_freelist_2_addr  (func_freelist_2_addr)
,.func_freelist_2_we    (func_freelist_2_we)
,.func_freelist_2_wdata (func_freelist_2_wdata)
,.func_freelist_2_rdata (func_freelist_2_rdata)

,.pf_freelist_2_re      (pf_freelist_2_re)
,.pf_freelist_2_addr    (pf_freelist_2_addr)
,.pf_freelist_2_we      (pf_freelist_2_we)
,.pf_freelist_2_wdata   (pf_freelist_2_wdata)
,.pf_freelist_2_rdata   (pf_freelist_2_rdata)

,.sr_freelist_2_clk (sr_freelist_2_clk)
,.sr_freelist_2_clk_rst_n (sr_freelist_2_clk_rst_n)
,.sr_freelist_2_re    (sr_freelist_2_re)
,.sr_freelist_2_addr  (sr_freelist_2_addr)
,.sr_freelist_2_we    (sr_freelist_2_we)
,.sr_freelist_2_wdata (sr_freelist_2_wdata_struct)
,.sr_freelist_2_rdata (sr_freelist_2_rdata_struct)
,.sr_freelist_2_error (sr_freelist_2_error)

,.func_freelist_3_re    (func_freelist_3_re)
,.func_freelist_3_addr  (func_freelist_3_addr)
,.func_freelist_3_we    (func_freelist_3_we)
,.func_freelist_3_wdata (func_freelist_3_wdata)
,.func_freelist_3_rdata (func_freelist_3_rdata)

,.pf_freelist_3_re      (pf_freelist_3_re)
,.pf_freelist_3_addr    (pf_freelist_3_addr)
,.pf_freelist_3_we      (pf_freelist_3_we)
,.pf_freelist_3_wdata   (pf_freelist_3_wdata)
,.pf_freelist_3_rdata   (pf_freelist_3_rdata)

,.sr_freelist_3_clk (sr_freelist_3_clk)
,.sr_freelist_3_clk_rst_n (sr_freelist_3_clk_rst_n)
,.sr_freelist_3_re    (sr_freelist_3_re)
,.sr_freelist_3_addr  (sr_freelist_3_addr)
,.sr_freelist_3_we    (sr_freelist_3_we)
,.sr_freelist_3_wdata (sr_freelist_3_wdata_struct)
,.sr_freelist_3_rdata (sr_freelist_3_rdata_struct)
,.sr_freelist_3_error (sr_freelist_3_error)

,.func_freelist_4_re    (func_freelist_4_re)
,.func_freelist_4_addr  (func_freelist_4_addr)
,.func_freelist_4_we    (func_freelist_4_we)
,.func_freelist_4_wdata (func_freelist_4_wdata)
,.func_freelist_4_rdata (func_freelist_4_rdata)

,.pf_freelist_4_re      (pf_freelist_4_re)
,.pf_freelist_4_addr    (pf_freelist_4_addr)
,.pf_freelist_4_we      (pf_freelist_4_we)
,.pf_freelist_4_wdata   (pf_freelist_4_wdata)
,.pf_freelist_4_rdata   (pf_freelist_4_rdata)

,.sr_freelist_4_clk (sr_freelist_4_clk)
,.sr_freelist_4_clk_rst_n (sr_freelist_4_clk_rst_n)
,.sr_freelist_4_re    (sr_freelist_4_re)
,.sr_freelist_4_addr  (sr_freelist_4_addr)
,.sr_freelist_4_we    (sr_freelist_4_we)
,.sr_freelist_4_wdata (sr_freelist_4_wdata_struct)
,.sr_freelist_4_rdata (sr_freelist_4_rdata_struct)
,.sr_freelist_4_error (sr_freelist_4_error)

,.func_freelist_5_re    (func_freelist_5_re)
,.func_freelist_5_addr  (func_freelist_5_addr)
,.func_freelist_5_we    (func_freelist_5_we)
,.func_freelist_5_wdata (func_freelist_5_wdata)
,.func_freelist_5_rdata (func_freelist_5_rdata)

,.pf_freelist_5_re      (pf_freelist_5_re)
,.pf_freelist_5_addr    (pf_freelist_5_addr)
,.pf_freelist_5_we      (pf_freelist_5_we)
,.pf_freelist_5_wdata   (pf_freelist_5_wdata)
,.pf_freelist_5_rdata   (pf_freelist_5_rdata)

,.sr_freelist_5_clk (sr_freelist_5_clk)
,.sr_freelist_5_clk_rst_n (sr_freelist_5_clk_rst_n)
,.sr_freelist_5_re    (sr_freelist_5_re)
,.sr_freelist_5_addr  (sr_freelist_5_addr)
,.sr_freelist_5_we    (sr_freelist_5_we)
,.sr_freelist_5_wdata (sr_freelist_5_wdata_struct)
,.sr_freelist_5_rdata (sr_freelist_5_rdata_struct)
,.sr_freelist_5_error (sr_freelist_5_error)

,.func_freelist_6_re    (func_freelist_6_re)
,.func_freelist_6_addr  (func_freelist_6_addr)
,.func_freelist_6_we    (func_freelist_6_we)
,.func_freelist_6_wdata (func_freelist_6_wdata)
,.func_freelist_6_rdata (func_freelist_6_rdata)

,.pf_freelist_6_re      (pf_freelist_6_re)
,.pf_freelist_6_addr    (pf_freelist_6_addr)
,.pf_freelist_6_we      (pf_freelist_6_we)
,.pf_freelist_6_wdata   (pf_freelist_6_wdata)
,.pf_freelist_6_rdata   (pf_freelist_6_rdata)

,.sr_freelist_6_clk (sr_freelist_6_clk)
,.sr_freelist_6_clk_rst_n (sr_freelist_6_clk_rst_n)
,.sr_freelist_6_re    (sr_freelist_6_re)
,.sr_freelist_6_addr  (sr_freelist_6_addr)
,.sr_freelist_6_we    (sr_freelist_6_we)
,.sr_freelist_6_wdata (sr_freelist_6_wdata_struct)
,.sr_freelist_6_rdata (sr_freelist_6_rdata_struct)
,.sr_freelist_6_error (sr_freelist_6_error)

,.func_freelist_7_re    (func_freelist_7_re)
,.func_freelist_7_addr  (func_freelist_7_addr)
,.func_freelist_7_we    (func_freelist_7_we)
,.func_freelist_7_wdata (func_freelist_7_wdata)
,.func_freelist_7_rdata (func_freelist_7_rdata)

,.pf_freelist_7_re      (pf_freelist_7_re)
,.pf_freelist_7_addr    (pf_freelist_7_addr)
,.pf_freelist_7_we      (pf_freelist_7_we)
,.pf_freelist_7_wdata   (pf_freelist_7_wdata)
,.pf_freelist_7_rdata   (pf_freelist_7_rdata)

,.sr_freelist_7_clk (sr_freelist_7_clk)
,.sr_freelist_7_clk_rst_n (sr_freelist_7_clk_rst_n)
,.sr_freelist_7_re    (sr_freelist_7_re)
,.sr_freelist_7_addr  (sr_freelist_7_addr)
,.sr_freelist_7_we    (sr_freelist_7_we)
,.sr_freelist_7_wdata (sr_freelist_7_wdata_struct)
,.sr_freelist_7_rdata (sr_freelist_7_rdata_struct)
,.sr_freelist_7_error (sr_freelist_7_error)

,.func_hist_list_re    (func_hist_list_re)
,.func_hist_list_addr  (func_hist_list_addr)
,.func_hist_list_we    (func_hist_list_we)
,.func_hist_list_wdata (func_hist_list_wdata)
,.func_hist_list_rdata (func_hist_list_rdata)

,.pf_hist_list_re      (pf_hist_list_re)
,.pf_hist_list_addr    (pf_hist_list_addr)
,.pf_hist_list_we      (pf_hist_list_we)
,.pf_hist_list_wdata   (pf_hist_list_wdata)
,.pf_hist_list_rdata   (pf_hist_list_rdata)

,.sr_hist_list_clk (sr_hist_list_clk)
,.sr_hist_list_clk_rst_n (sr_hist_list_clk_rst_n)
,.sr_hist_list_re    (sr_hist_list_re)
,.sr_hist_list_addr  (sr_hist_list_addr)
,.sr_hist_list_we    (sr_hist_list_we)
,.sr_hist_list_wdata (sr_hist_list_wdata_struct)
,.sr_hist_list_rdata (sr_hist_list_rdata_struct)
,.sr_hist_list_error (sr_hist_list_error)

,.func_hist_list_a_re    (func_hist_list_a_re)
,.func_hist_list_a_addr  (func_hist_list_a_addr)
,.func_hist_list_a_we    (func_hist_list_a_we)
,.func_hist_list_a_wdata (func_hist_list_a_wdata)
,.func_hist_list_a_rdata (func_hist_list_a_rdata)

,.pf_hist_list_a_re      (pf_hist_list_a_re)
,.pf_hist_list_a_addr    (pf_hist_list_a_addr)
,.pf_hist_list_a_we      (pf_hist_list_a_we)
,.pf_hist_list_a_wdata   (pf_hist_list_a_wdata)
,.pf_hist_list_a_rdata   (pf_hist_list_a_rdata)

,.sr_hist_list_a_clk (sr_hist_list_a_clk)
,.sr_hist_list_a_clk_rst_n (sr_hist_list_a_clk_rst_n)
,.sr_hist_list_a_re    (sr_hist_list_a_re)
,.sr_hist_list_a_addr  (sr_hist_list_a_addr)
,.sr_hist_list_a_we    (sr_hist_list_a_we)
,.sr_hist_list_a_wdata (sr_hist_list_a_wdata_struct)
,.sr_hist_list_a_rdata (sr_hist_list_a_rdata_struct)
,.sr_hist_list_a_error (sr_hist_list_a_error)

);
// END HQM_RAM_ACCESS

ldb_cq_on_off_threshold_t cfg_mem_wdata_ldb_cq_on_off_threshold_struct ;

assign cfg_mem_wdata_ldb_cq_on_off_threshold_struct = cfg_mem_wdata ; 

assign func_hcw_enq_w_rx_sync_mem_wdata = { 4'd0 , hcw_enq_w_rx_sync_mem_wdata } ;
assign hcw_enq_w_rx_sync_mem_rdata = func_hcw_enq_w_rx_sync_mem_rdata [ $bits(hcw_enq_w_rx_sync_mem_rdata) - 1 : 0 ] ;

assign sr_freelist_we_nxt = { ( sr_freelist_0_we 
                              | sr_freelist_1_we
                              | sr_freelist_2_we
                              | sr_freelist_3_we
                              | sr_freelist_4_we
                              | sr_freelist_5_we
                              | sr_freelist_6_we
                              | sr_freelist_7_we 
                              )
                            , sr_freelist_we_f [ 3 : 1] } ;     

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    hqm_chp_target_cfg_ldb_wd_enb_interval_update_v_f <= 'd0 ; 
    hqm_chp_target_cfg_dir_wd_enb_interval_update_v_f <= 'd0 ;
    hqm_chp_target_cfg_dir_wd_threshold_update_v_f <= 'd0 ;
    hqm_chp_target_cfg_ldb_wd_threshold_update_v_f <= 'd0 ;
    sr_freelist_we_f <= 4'h0 ;
  end 
  else begin
    hqm_chp_target_cfg_ldb_wd_enb_interval_update_v_f <= pfcsr_cfg_req_write[HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL];
    hqm_chp_target_cfg_dir_wd_enb_interval_update_v_f <= pfcsr_cfg_req_write[HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL];
    hqm_chp_target_cfg_dir_wd_threshold_update_v_f <= pfcsr_cfg_req_write[HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD];
    hqm_chp_target_cfg_ldb_wd_threshold_update_v_f <= pfcsr_cfg_req_write[HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD];
    sr_freelist_we_f <= sr_freelist_we_nxt ;
  end
end


assign hqm_chp_target_cfg_dir_wd_threshold_reg_v = 1'b0 ; 
assign hqm_chp_target_cfg_dir_wd_threshold_reg_nxt = hqm_chp_target_cfg_dir_wd_threshold_reg_f;
assign hqm_chp_target_cfg_ldb_wd_threshold_reg_v = 1'b0 ; 
assign hqm_chp_target_cfg_ldb_wd_threshold_reg_nxt = hqm_chp_target_cfg_ldb_wd_threshold_reg_f;
assign hqm_chp_target_cfg_ldb_wd_enb_interval_reg_v = 1'b0 ; 
assign hqm_chp_target_cfg_ldb_wd_enb_interval_reg_nxt = hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f;
assign hqm_chp_target_cfg_dir_wd_enb_interval_reg_v = 1'b0 ; 
assign hqm_chp_target_cfg_dir_wd_enb_interval_reg_nxt = hqm_chp_target_cfg_dir_wd_enb_interval_reg_f;


//---------------------------------------------------------------------------------------------------------
// common core - Interface & clock control

hqm_AW_module_clock_control # (
  .REQS ( 7 )
) i_hqm_credit_hist_pipe_core_clock_control (
  .hqm_inp_gated_clk				 ( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n				 ( hqm_inp_gated_rst_n )
, .hqm_gated_clk				 ( hqm_gated_clk )
, .hqm_gated_rst_n				 ( hqm_gated_rst_n )
, .cfg_co_dly                                    ( { 2'd0 , hqm_chp_target_cfg_patch_control_reg_f [ 13 : 0 ] } )
, .cfg_co_disable                                ( hqm_chp_target_cfg_patch_control_reg_f [ 31 ] )
, .hqm_proc_clk_en				 ( hqm_proc_clk_en_chp )
, .unit_idle_local				 ( chp_unit_idle_local )
, .unit_idle					 ( wire_chp_unit_idle )

, .inp_fifo_empty				 ( { rop_clk_idle 
                                                  , cfg_rx_idle
						  , hcw_enq_w_rx_sync_idle
						  , qed_chp_sch_rx_sync_idle
						  , qed_chp_sch_flid_ret_rx_sync_idle
						  , aqed_chp_sch_rx_sync_idle
                                                  , wd_clkreq_sync2inp_inv
						  } )
, .inp_fifo_en					 ( { rop_clk_enable 
                                                  , cfg_rx_enable
						  , hcw_enq_w_rx_sync_enable
						  , qed_chp_sch_rx_sync_enable
						  , qed_chp_sch_flid_ret_rx_sync_enable
						  , aqed_chp_sch_rx_sync_enable
                                                  , wd_clkreq_sync2inp_nc
						  } )
, .cfg_idle                                  ( cfg_idle )
, .int_idle                                  ( int_idle )
, .rst_prep                             ( rst_prep )
, .reset_active                         ( hqm_gated_rst_n_active )
) ;

//-----------------------------------------------------------------------------------------------------
// TX & RX modules instantiated in sub-modules


assign chp_outbound_hcw_pipe_credit_dealloc     = fifo_outbound_hcw_pop ;
assign chp_rop_hcw_tx_sync_in_valid             = fifo_chp_rop_hcw_pop_data_v ;
assign chp_rop_hcw_tx_sync_in_data              = fifo_chp_rop_hcw_pop_data ;
assign fifo_chp_rop_hcw_pop                     = chp_rop_hcw_tx_sync_in_ready & chp_rop_hcw_tx_sync_in_valid ;
assign chp_rop_pipe_credit_dealloc              = fifo_chp_rop_hcw_pop ;
hqm_AW_tx_nobuf_sync # (
  .WIDTH ( $bits ( chp_rop_hcw_t ) )
) i_chp_rop_hcw_tx_nobuf_sync (
  .hqm_gated_clk                                ( hqm_gated_clk )
, .hqm_gated_rst_n                              ( hqm_gated_rst_n )
, .status                                       ( chp_rop_hcw_tx_sync_status )
, .idle                                         ( chp_rop_hcw_tx_sync_idle )
, .rst_prep                                     ( rst_prep )
, .in_ready                                     ( chp_rop_hcw_tx_sync_in_ready )
, .in_valid                                     ( chp_rop_hcw_tx_sync_in_valid )
, .in_data                                      ( chp_rop_hcw_tx_sync_in_data )
, .out_ready                                    ( chp_rop_hcw_ready )
, .out_valid                                    ( chp_rop_hcw_v )
, .out_data                                     ( chp_rop_hcw_data )
) ;

logic [ 7 : 0 ] 				chp_lsp_token_qb_status ;
logic						chp_lsp_token_qb_in_ready ;
logic 						chp_lsp_token_qb_in_valid ;
chp_lsp_token_t					chp_lsp_token_qb_in_data ;
logic						chp_lsp_token_qb_out_ready ;
logic						chp_lsp_token_qb_out_valid ;
chp_lsp_token_t					chp_lsp_token_qb_out_data ;
logic						egress_lsp_token_credit_dealloc ;

hqm_AW_quad_buffer # (
  .WIDTH                                        ( $bits ( chp_lsp_token_t ) )
) i_chp_lsp_token_qb (
  .clk                                          ( hqm_gated_clk )
, .rst_n                                        ( hqm_gated_rst_n )
, .status                                       ( chp_lsp_token_qb_status )
, .in_ready                                     ( chp_lsp_token_qb_in_ready )
, .in_valid                                     ( chp_lsp_token_qb_in_valid )
, .in_data                                      ( chp_lsp_token_qb_in_data )
, .out_ready                                    ( chp_lsp_token_qb_out_ready )
, .out_valid                                    ( chp_lsp_token_qb_out_valid )
, .out_data                                     ( chp_lsp_token_qb_out_data )
) ;

assign chp_lsp_token_qb_out_ready = chp_lsp_token_tx_sync_in_ready ;
assign egress_lsp_token_credit_dealloc = chp_lsp_token_qb_out_valid & chp_lsp_token_qb_out_ready ;

// data from this FIFO is delviered to both the hqm_credit_hist_pipe_egress sub-module & to chp_lsp_token interface.  
// hqm_credit_hist_pipe_egress arbitrates and when wins will pop this FIFO
// do not send HQM_CMD_ARM command to LSP
assign chp_lsp_tok_pipe_credit_dealloc          = fifo_chp_lsp_tok_pop ;
assign chp_lsp_token_tx_sync_in_valid           = chp_lsp_token_qb_out_valid ;
assign chp_lsp_token_tx_sync_in_data            = chp_lsp_token_qb_out_data ;
hqm_AW_tx_sync # (
  .WIDTH ( $bits ( chp_lsp_token_t ) )
) i_chp_lsp_token_tx_sync (
  .hqm_gated_clk                                ( hqm_gated_clk )
, .hqm_gated_rst_n                              ( hqm_gated_rst_n )
, .status                                       ( chp_lsp_token_tx_sync_status )
, .idle                                         ( chp_lsp_token_tx_sync_idle )
, .rst_prep                                     ( rst_prep )
, .in_ready                                     ( chp_lsp_token_tx_sync_in_ready )
, .in_valid                                     ( chp_lsp_token_tx_sync_in_valid )
, .in_data                                      ( chp_lsp_token_tx_sync_in_data )
, .out_ready                                    ( chp_lsp_token_ready )
, .out_valid                                    ( chp_lsp_token_v )
, .out_data                                     ( chp_lsp_token_data )
) ;


assign chp_lsp_ap_cmp_pipe_credit_dealloc       = chp_lsp_cmp_tx_sync_in_valid & chp_lsp_cmp_tx_sync_in_ready ;
assign chp_lsp_cmp_tx_sync_in_valid             = fifo_chp_lsp_ap_cmp_pop_data_v ;
assign chp_lsp_cmp_tx_sync_in_data.qe_wt          = fifo_chp_lsp_ap_cmp_pop_data.qe_wt ;
assign chp_lsp_cmp_tx_sync_in_data.user           = fifo_chp_lsp_ap_cmp_pop_data.user ;
assign chp_lsp_cmp_tx_sync_in_data.pp             = fifo_chp_lsp_ap_cmp_pop_data.pp ;
assign chp_lsp_cmp_tx_sync_in_data.qid            = fifo_chp_lsp_ap_cmp_pop_data.qid ;
assign chp_lsp_cmp_tx_sync_in_data.parity         = ^ { 1'b1 
                                                      , fifo_chp_lsp_ap_cmp_pop_data.qe_wt
                                                      , fifo_chp_lsp_ap_cmp_pop_data.qid_parity 
                                                      , fifo_chp_lsp_ap_cmp_pop_data.pp_parity 
                                                      } ;
assign chp_lsp_cmp_tx_sync_in_data.hist_list_info = fifo_chp_lsp_ap_cmp_pop_data.hist_list_info ;
assign chp_lsp_cmp_tx_sync_in_data.hid_parity     = fifo_chp_lsp_ap_cmp_pop_data.hid_parity ;
assign chp_lsp_cmp_tx_sync_in_data.hid            = fifo_chp_lsp_ap_cmp_pop_data.hid ;
assign fifo_chp_lsp_ap_cmp_pop                  = chp_lsp_cmp_tx_sync_in_ready & chp_lsp_cmp_tx_sync_in_valid ;
hqm_AW_tx_nobuf_sync # (
  .WIDTH ( $bits ( chp_lsp_cmp_t ) )
) i_chp_lsp_cmp_tx_sync (
  .hqm_gated_clk                                ( hqm_gated_clk )
, .hqm_gated_rst_n                              ( hqm_gated_rst_n )
, .status                                       ( chp_lsp_cmp_tx_sync_status )
, .idle                                         ( chp_lsp_cmp_tx_sync_idle )
, .rst_prep                                     ( rst_prep )
, .in_ready                                     ( chp_lsp_cmp_tx_sync_in_ready )
, .in_valid                                     ( chp_lsp_cmp_tx_sync_in_valid )
, .in_data                                      ( chp_lsp_cmp_tx_sync_in_data )
, .out_ready                                    ( chp_lsp_cmp_ready )
, .out_valid                                    ( chp_lsp_cmp_v )
, .out_data                                     ( chp_lsp_cmp_data )
) ;

//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar

cfg_req_t unit_cfg_req ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read ;

logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read ;
logic unit_cfg_rsp_ack ;
logic unit_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ] unit_cfg_rsp_rdata ;
hqm_AW_cfg_ring_top # (
          .NODE_ID                     ( HQM_CHP_CFG_NODE_ID )
        , .UNIT_ID                     ( HQM_CHP_CFG_UNIT_ID )
        , .UNIT_TGT_MAP                ( HQM_CHP_CFG_UNIT_TGT_MAP )
        , .UNIT_NUM_TGTS               ( HQM_CHP_CFG_UNIT_NUM_TGTS )
) i_hqm_aw_cfg_ring_top (
          .hqm_inp_gated_clk           ( hqm_inp_gated_clk )
        , .hqm_inp_gated_rst_n         ( hqm_inp_gated_rst_n )
        , .hqm_gated_clk               ( hqm_gated_clk )
        , .hqm_gated_rst_n             ( hqm_gated_rst_n )
        , .rst_prep                    ( rst_prep )

        , .cfg_rx_enable               ( cfg_rx_enable )
        , .cfg_rx_idle                 ( cfg_rx_idle )
        , .cfg_rx_fifo_status          ( cfg_rx_fifo_status )
        , .cfg_idle                    ( cfg_idle )

        , .up_cfg_req_write            ( chp_cfg_req_up_write )
        , .up_cfg_req_read             ( chp_cfg_req_up_read )
        , .up_cfg_req                  ( chp_cfg_req_up )
        , .up_cfg_rsp_ack              ( chp_cfg_rsp_up_ack )
        , .up_cfg_rsp                  ( chp_cfg_rsp_up )

        , .down_cfg_req_write          ( chp_cfg_req_down_write )
        , .down_cfg_req_read           ( chp_cfg_req_down_read )
        , .down_cfg_req                ( chp_cfg_req_down )
        , .down_cfg_rsp_ack            ( chp_cfg_rsp_down_ack )
        , .down_cfg_rsp                ( chp_cfg_rsp_down )

        , .unit_cfg_req_write          ( unit_cfg_req_write )
        , .unit_cfg_req_read           ( unit_cfg_req_read )
        , .unit_cfg_req                ( unit_cfg_req )
        , .unit_cfg_rsp_ack            ( unit_cfg_rsp_ack )
        , .unit_cfg_rsp_rdata          ( unit_cfg_rsp_rdata )
        , .unit_cfg_rsp_err            ( unit_cfg_rsp_err )
) ;
assign cfg_rx_fifo_status_underflow = cfg_rx_fifo_status [ 0 ] ;
assign cfg_rx_fifo_status_overflow = cfg_rx_fifo_status [ 1 ] ;
//------------------------------------------------------------------------------------------------------------------
// Common BCAST/VF Reset logic
logic [4:0] timeout_nc;
cfg_unit_timeout_t  cfg_unit_timeout;
assign hqm_chp_target_cfg_unit_timeout_reg_nxt = {hqm_chp_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign cfg_unit_timeout = {hqm_chp_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_chp_target_cfg_unit_timeout_reg_f[4:0] ;

localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_chp_target_cfg_unit_version_status = cfg_unit_version;

//------------------------------------------------------------------------------------------------------------------

cfg_req_t pfcsr_cfg_req_pre ;
logic cfg_req_idlepipe ;
logic cfg_req_ready ;
assign cfg_req_ready = ( 
                          (cfg_unit_idle_reg_f.pipe_idle )
                        & (hqm_chp_tim_pipe_idle_cial_dir)
                        & (hqm_chp_tim_pipe_idle_cial_ldb)
                       );

logic [ ( NUM_CFG_ACCESSIBLE_RAM * 32 ) - 1 : 0 ] cfgsc_cfg_mem_rdata ;
logic [ ( NUM_CFG_ACCESSIBLE_RAM * 1 ) - 1 : 0 ] cfgsc_cfg_mem_ack ;

hqm_AW_cfg_sc # (
          .MODULE                      ( HQM_CHP_CFG_NODE_ID )
        , .NUM_CFG_TARGETS             ( HQM_CHP_CFG_UNIT_NUM_TGTS )
        , .NUM_CFG_ACCESSIBLE_RAM      ( NUM_CFG_ACCESSIBLE_RAM )
) i_hqm_AW_cfg_sc (
          .hqm_gated_clk               ( hqm_gated_clk )
        , .hqm_gated_rst_n             ( hqm_gated_rst_n )

        , .unit_cfg_req                ( unit_cfg_req )
        , .unit_cfg_req_write          ( unit_cfg_req_write )
        , .unit_cfg_req_read           ( unit_cfg_req_read )
        , .unit_cfg_rsp_ack            ( unit_cfg_rsp_ack )
        , .unit_cfg_rsp_err            ( unit_cfg_rsp_err )
        , .unit_cfg_rsp_rdata          ( unit_cfg_rsp_rdata )

        , .pfcsr_cfg_req                ( pfcsr_cfg_req_pre )
        , .pfcsr_cfg_req_write          ( pfcsr_cfg_req_write )
        , .pfcsr_cfg_req_read           ( pfcsr_cfg_req_read )
        , .pfcsr_cfg_rsp_ack            ( pfcsr_cfg_rsp_ack )
        , .pfcsr_cfg_rsp_err            ( pfcsr_cfg_rsp_err )
        , .pfcsr_cfg_rsp_rdata          ( pfcsr_cfg_rsp_rdata )

        , .cfg_req_write               ( cfg_req_write )
        , .cfg_req_read                ( cfg_req_read )
        , .cfg_mem_re                  ( cfg_mem_re )
        , .cfg_mem_we                  ( cfg_mem_we )
        , .cfg_mem_addr                ( cfg_mem_addr )
        , .cfg_mem_minbit              ( cfg_mem_minbit )
        , .cfg_mem_maxbit              ( cfg_mem_maxbit )
        , .cfg_mem_wdata               ( cfg_mem_wdata )
        , .cfg_mem_rdata               ( cfgsc_cfg_mem_rdata )
        , .cfg_mem_ack                 ( cfgsc_cfg_mem_ack )

        , .cfg_req_idlepipe            ( cfg_req_idlepipe )
        , .cfg_req_ready               ( cfg_req_ready )

        ,.cfg_timout_enable            ( cfg_unit_timeout.ENABLE )
        ,.cfg_timout_threshold         ( cfg_unit_timeout.THRESHOLD )
) ;

// common core - (cfgsc) configuration sc logic ( do custom CFG access like inject correction code or split logical config request to physical implentation

logic [ ( 32 ) - 1 : 0 ] cfgsc_residue_gen_a ;
logic [ ( 2 ) - 1 : 0 ] cfgsc_residue_gen_r ;
logic [ ( 32 ) - 1 : 0 ] cfgsc_parity_gen_d ;
logic [ ( 32 ) - 1 : 0 ] cfgsc_parity_gen_d1 ;
logic cfgsc_parity_gen_p ;
logic cfgsc_parity_gen_p1 ;
always_comb begin

  cfgsc_cfg_mem_rdata = cfg_mem_rdata ;
  cfgsc_cfg_mem_ack = cfg_mem_ack;

  pfcsr_cfg_req = pfcsr_cfg_req_pre ;

  //CFG correction code logic
  cfg_mem_cc_v = '0 ;
  cfg_mem_cc_value = '0 ;
  cfg_mem_cc_width = '0 ;
  cfg_mem_cc_position = '0 ;

  cfgsc_residue_gen_a = '0 ;
  cfgsc_parity_gen_d = '0 ;
  cfgsc_parity_gen_d1 = '0 ;


  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits ( rf_hist_list_minmax_wdata_struct.max_addr ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_minmax_wdata_struct.max_addr ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_minmax_wdata_struct.max_addr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_minmax_wdata_struct.max_addr ) +
                          $bits ( rf_hist_list_minmax_wdata_struct.min_addr_residue ) +
                          $bits ( rf_hist_list_minmax_wdata_struct.min_addr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_BASE * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits( rf_hist_list_minmax_wdata_struct.min_addr ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_minmax_wdata_struct.min_addr ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_minmax_wdata_struct.min_addr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_minmax_wdata_struct.min_addr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - ( $bits ( rf_hist_list_ptr_wdata_struct.push_ptr ) + 1 ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_ptr_wdata_struct.push_ptr ) + 1 ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_ptr_wdata_struct.push_ptr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_ptr_wdata_struct.push_ptr_gen) +
                          $bits ( rf_hist_list_ptr_wdata_struct.push_ptr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - ( $bits ( rf_hist_list_ptr_wdata_struct.pop_ptr ) + 1 ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_ptr_wdata_struct.pop_ptr ) + 1 ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_ptr_wdata_struct.pop_ptr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_ptr_wdata_struct.pop_ptr_gen ) +
                          $bits ( rf_hist_list_ptr_wdata_struct.pop_ptr ) +
                          $bits ( rf_hist_list_ptr_wdata_struct.push_ptr_residue ) +
                          $bits ( rf_hist_list_ptr_wdata_struct.push_ptr_gen ) +
                          $bits ( rf_hist_list_ptr_wdata_struct.push_ptr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits ( rf_hist_list_a_minmax_wdata_struct.max_addr ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_a_minmax_wdata_struct.max_addr ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_a_minmax_wdata_struct.max_addr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_a_minmax_wdata_struct.max_addr ) +
                          $bits ( rf_hist_list_a_minmax_wdata_struct.min_addr_residue ) +
                          $bits ( rf_hist_list_a_minmax_wdata_struct.min_addr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits( rf_hist_list_a_minmax_wdata_struct.min_addr ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_a_minmax_wdata_struct.min_addr ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_a_minmax_wdata_struct.min_addr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_a_minmax_wdata_struct.min_addr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - ( $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr ) + 1 ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr ) + 1 ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr_gen) +
                          $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - ( $bits ( rf_hist_list_a_ptr_wdata_struct.pop_ptr ) + 1 ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_hist_list_a_ptr_wdata_struct.pop_ptr ) + 1 ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_hist_list_a_ptr_wdata_struct.pop_ptr_residue ) ;
    cfg_mem_cc_position = $bits ( rf_hist_list_a_ptr_wdata_struct.pop_ptr_gen ) +
                          $bits ( rf_hist_list_a_ptr_wdata_struct.pop_ptr ) +
                          $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr_residue ) +
                          $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr_gen ) +
                          $bits ( rf_hist_list_a_ptr_wdata_struct.push_ptr ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_dir_cq_token_depth_select_wdata_struct.depth_select ) ) { 1'b0 } }
                         , cfg_mem_wdata [ ( $bits ( rf_dir_cq_token_depth_select_wdata_struct.depth_select ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = $bits ( rf_dir_cq_token_depth_select_wdata_struct.parity ) ;
    cfg_mem_cc_position = $bits ( rf_dir_cq_token_depth_select_wdata_struct.depth_select ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits ( rf_dir_cq_depth_wdata_struct.depth ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_dir_cq_depth_wdata_struct.depth ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_dir_cq_depth_wdata_struct.residue ) ;
    cfg_mem_cc_position = $bits ( rf_dir_cq_depth_wdata_struct.depth ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_WPTR * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits ( rf_dir_cq_wptr_wdata_struct.wp ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_dir_cq_wptr_wdata_struct.wp ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_dir_cq_wptr_wdata_struct.residue ) ;
    cfg_mem_cc_position = $bits ( rf_dir_cq_wptr_wdata_struct.wp ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_ldb_cq_token_depth_select_wdata_struct.depth_select ) ) { 1'b0 } }
                         , cfg_mem_wdata [ ( $bits ( rf_ldb_cq_token_depth_select_wdata_struct.depth_select ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = $bits ( rf_ldb_cq_token_depth_select_wdata_struct.parity ) ;
    cfg_mem_cc_position = $bits ( rf_ldb_cq_token_depth_select_wdata_struct.depth_select ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( cfg_mem_wdata_ldb_cq_on_off_threshold_struct.off_thrsh ) ) { 1'b0 } }
                         , cfg_mem_wdata_ldb_cq_on_off_threshold_struct.on_thrsh } ;
    cfgsc_parity_gen_d1 = { { ( 32 - $bits ( cfg_mem_wdata_ldb_cq_on_off_threshold_struct.on_thrsh ) ) { 1'b0 } }
                         , cfg_mem_wdata_ldb_cq_on_off_threshold_struct.off_thrsh } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_parity_gen_p1 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = $bits ( cfg_mem_wdata_ldb_cq_on_off_threshold_struct.parity ) ;
    cfg_mem_cc_position = $bits ( cfg_mem_wdata_ldb_cq_on_off_threshold_struct.off_thrsh ) + $bits ( cfg_mem_wdata_ldb_cq_on_off_threshold_struct.on_thrsh ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits ( rf_ldb_cq_depth_wdata_struct.depth ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_ldb_cq_depth_wdata_struct.depth ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_ldb_cq_depth_wdata_struct.residue ) ;
    cfg_mem_cc_position = $bits ( rf_ldb_cq_depth_wdata_struct.depth ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_WPTR * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits ( rf_ldb_cq_wptr_wdata_struct.wp ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_ldb_cq_wptr_wdata_struct.wp ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_ldb_cq_wptr_wdata_struct.residue ) ;
    cfg_mem_cc_position = $bits ( rf_ldb_cq_wptr_wdata_struct.wp ) ;
  end

  if ( pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { 27'd0 , pfcsr_cfg_req.wdata [ 4 : 0 ] } ;
    pfcsr_cfg_req.wdata [ 5 ] = cfgsc_parity_gen_p ;
  end 

  if ( pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { 27'd0 , pfcsr_cfg_req.wdata [ 4 : 0 ] } ;
    pfcsr_cfg_req.wdata [ 5 ] = cfgsc_parity_gen_p ;
  end 

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_ord_qid_sn_map_wdata_struct.map ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_ord_qid_sn_map_wdata_struct.map ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = $bits ( rf_ord_qid_sn_map_wdata_struct.parity ) ;
    cfg_mem_cc_position = $bits ( rf_ord_qid_sn_map_wdata_struct.map ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_ORD_QID_SN * 1 +: 1 ]  ) begin
    cfgsc_residue_gen_a = { { ( 32 - $bits ( rf_ord_qid_sn_wdata_struct.sn ) ) { 1'b0 } }
                          , cfg_mem_wdata [ ( $bits ( rf_ord_qid_sn_wdata_struct.sn ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 6'd0 , cfgsc_residue_gen_r } ;
    cfg_mem_cc_width = $bits ( rf_ord_qid_sn_wdata_struct.residue ) ;
    cfg_mem_cc_position = $bits ( rf_ord_qid_sn_wdata_struct.sn ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_dir_cq_intr_thresh_wdata_struct.threshold ) ) { 1'b0 } }
                         , cfg_mem_wdata [ ( $bits ( rf_dir_cq_intr_thresh_wdata_struct.threshold ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = $bits ( rf_dir_cq_intr_thresh_wdata_struct.parity ) ;
    cfg_mem_cc_position = $bits ( rf_dir_cq_intr_thresh_wdata_struct.threshold ) ;
  end

  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_ldb_cq_intr_thresh_wdata_struct.threshold ) ) { 1'b0 } }
                         , cfg_mem_wdata [ ( $bits ( rf_ldb_cq_intr_thresh_wdata_struct.threshold ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = $bits ( rf_ldb_cq_intr_thresh_wdata_struct.parity ) ;
    cfg_mem_cc_position = $bits ( rf_ldb_cq_intr_thresh_wdata_struct.threshold ) ;
  end

  //https://hsdes.intel.com/appstore/article/#/1407239306
  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL* 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_cmp_id_chk_enbl_mem_wdata[0:0] ) ) { 1'b0 } }
                         , cfg_mem_wdata [ ( $bits ( rf_cmp_id_chk_enbl_mem_wdata[0:0] ) ) - 1 : 0 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = 1 ;
    cfg_mem_cc_position = 1 ;
  end

  // https://hsdes.intel.com/resource/2204058480 - use bit 0 as parity
  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD* 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_threshold_r_pipe_ldb_mem_wdata[13:1] ) ) { 1'b0 } }
                         , cfg_mem_wdata [ ( $bits ( rf_threshold_r_pipe_ldb_mem_wdata[13:0] ) ) - 1 : 1 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = 1 ;
    cfg_mem_cc_position = 0 ;
  end

  // https://hsdes.intel.com/resource/2204058480 - use bit 0 as parity
  if ( cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD* 1 +: 1 ]  ) begin
    cfgsc_parity_gen_d = { { ( 32 - $bits ( rf_threshold_r_pipe_dir_mem_wdata[13:1] ) ) { 1'b0 } }
                         , cfg_mem_wdata [ ( $bits ( rf_threshold_r_pipe_dir_mem_wdata[13:0] ) ) - 1 : 1 ] } ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_p } ;
    cfg_mem_cc_width = 1 ;
    cfg_mem_cc_position = 0 ;
  end

  // https://hsdes.intel.com/resource/2204058480 - use bit 0 as parity
  if ( cfg_mem_ack [ CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_DIR_MEM ] ) begin
    cfgsc_cfg_mem_rdata [ ( CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_DIR_MEM * 32 ) +: 32 ] = { cfg_mem_rdata[(( CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_DIR_MEM * 32) + 1) +: 31] , 1'b1 } ;
  end

  // https://hsdes.intel.com/resource/2204058480 - use bit 0 as parity
  if ( cfg_mem_ack [ CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_LDB_MEM ] ) begin
    cfgsc_cfg_mem_rdata [ ( CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_LDB_MEM * 32 ) +: 32 ] = { cfg_mem_rdata[(( CFG_ACCESSIBLE_RAM_THRESHOLD_R_PIPE_LDB_MEM * 32) + 1) +: 31] , 1'b1 } ;
  end

end
hqm_AW_residue_gen # (
   .WIDTH                               ( 32 )
) i_residue_gen_freelist (
   .a                                   ( cfgsc_residue_gen_a )
 , .r                                   ( cfgsc_residue_gen_r )
) ;
hqm_AW_parity_gen # (
    .WIDTH                              ( 32 )
) i_parity_gen_cfgsc (
     .d                                 ( cfgsc_parity_gen_d )
   , .odd                               ( 1'b1 )
   , .p                                 ( cfgsc_parity_gen_p )
) ;
hqm_AW_parity_gen # (
    .WIDTH                              ( 32 )
) i_parity_gen_cfgsc_1 (
     .d                                 ( cfgsc_parity_gen_d1 )
   , .odd                               ( 1'b1 )
   , .p                                 ( cfgsc_parity_gen_p1 )
) ;

//---------------------------------------------------------------------------------------------------------
// common core - Interrupt serializer. Capture all interrutps from unit and send on interrupt ring
hqm_AW_int_serializer # (
    .NUM_INF                            ( HQM_CHP_ALARM_NUM_INF )
  , .NUM_COR                            ( HQM_CHP_ALARM_NUM_COR )
  , .NUM_UNC                            ( HQM_CHP_ALARM_NUM_UNC )
) i_int_serializer (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .rst_prep                           ( rst_prep )

  , .unit                               ( int_uid )

  , .inf_v                              ( int_inf_v )
  , .inf_data                           ( int_inf_data )
  , .cor_v                              ( int_cor_v )
  , .cor_data                           ( int_cor_data )
  , .unc_v                              ( int_unc_v )
  , .unc_data                           ( int_unc_data )

  , .int_up_v                           ( chp_alarm_up_v )
  , .int_up_ready                       ( chp_alarm_up_ready )
  , .int_up_data                        ( chp_alarm_up_data )

  , .int_down_v                         ( chp_alarm_down_v_pre )
  , .int_down_ready                     ( chp_alarm_down_ready_post )
  , .int_down_data                      ( chp_alarm_down_data )

  , .status                             ( int_status )

  , .int_idle                           ( int_idle )
) ;

logic [ ( 31 ) - 1 : 0 ] err_sw_class ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_00 ;

logic err_hw_class_01_v_nxt , err_hw_class_01_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_01_nxt , err_hw_class_01_f ;
logic err_hw_class_02_v_nxt , err_hw_class_02_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_02_nxt , err_hw_class_02_f ;

logic egress_err_hcw_ecc_sb_f ;
logic egress_err_hcw_ecc_mb_f ;
logic egress_err_ldb_cq_depth_underflow_f ;
logic egress_err_ldb_cq_depth_overflow_f ;
logic egress_err_dir_cq_depth_underflow_f ;
logic egress_err_dir_cq_depth_overflow_f ;
logic [ ( 8 ) - 1 : 0 ] egress_err_ldb_rid_f ;
logic [ ( 8 ) - 1 : 0 ] egress_err_dir_rid_f ;

assign egress_err_pipe_credit_error = egress_credit_status [ 0 ] | //error 
                                      egress_lsp_token_credit_status [ 0 ] ; //error
logic ing_err_hcw_enq_invalid_hcw_cmd_f ;

logic enqpipe_err_hist_list_data_error_sb_f ;
logic enqpipe_err_hist_list_data_error_mb_f ;
logic enqpipe_err_freelist_data_error_sb_f ;
logic enqpipe_err_freelist_data_error_mb_f ;
logic enqpipe_err_enq_to_rop_out_of_credit_drop_f ;
logic enqpipe_err_enq_to_rop_excess_frag_drop_f ;
logic enqpipe_err_enq_to_lsp_cmp_error_drop_f ;
logic enqpipe_err_release_qtype_error_drop_f ;

logic schpipe_err_ldb_cq_hcw_h_ecc_sb_f ;
logic schpipe_err_ldb_cq_hcw_h_ecc_mb_f ;

assign arb_err_chp_pipe_credit_error = chp_rop_pipe_credit_status [ 0 ] | //error
                                       chp_lsp_tok_pipe_credit_status [ 0 ] | //error
                                       chp_lsp_ap_cmp_pipe_credit_status [ 0 ] | //error
                                       chp_outbound_hcw_pipe_credit_status [ 0 ] ; //error

assign cfg_pad_first_write_dir = hqm_chp_target_cfg_chp_csr_control_reg_f [ 22 ] ;
assign cfg_pad_first_write_ldb = hqm_chp_target_cfg_chp_csr_control_reg_f [ 21 ] ;
assign cfg_pad_write_dir = hqm_chp_target_cfg_chp_csr_control_reg_f [ 20 ] ;
assign cfg_pad_write_ldb = hqm_chp_target_cfg_chp_csr_control_reg_f [ 19 ] ;

logic cfg_64bytes_qe_dir_cq_mode ;
logic cfg_64bytes_qe_ldb_cq_mode ;
assign cfg_64bytes_qe_dir_cq_mode = hqm_chp_target_cfg_chp_csr_control_reg_f [ 18 ] ;
assign cfg_64bytes_qe_ldb_cq_mode = hqm_chp_target_cfg_chp_csr_control_reg_f [ 17 ] ;

assign err_sw_class [ 0 ]      = ing_err_hcw_enq_invalid_hcw_cmd_f ;
assign err_sw_class [ 1 ]      = enqpipe_err_enq_to_rop_out_of_credit_drop_f ; 
assign err_sw_class [ 2 ]      = enqpipe_err_enq_to_rop_excess_frag_drop_f ; 
assign err_sw_class [ 3 ]      = enqpipe_err_enq_to_lsp_cmp_error_drop_f ; 
assign err_sw_class [ 4 ]      = enqpipe_err_release_qtype_error_drop_f ; 
assign err_sw_class [ 5 ]      = egress_err_ldb_cq_depth_underflow_f ; 
assign err_sw_class [ 6 ]      = egress_err_ldb_cq_depth_overflow_f ; 
assign err_sw_class [ 7 ]      = egress_err_dir_cq_depth_underflow_f ; 
assign err_sw_class [ 8 ]      = egress_err_dir_cq_depth_overflow_f ; 
assign err_sw_class [ 9 ]      = '0 ; 
assign err_sw_class [ 10 ]     = '0 ; 
assign err_sw_class [ 11 ]     = '0 ; 
assign err_sw_class [ 12 ]     = '0 ; 
assign err_sw_class [ 13 ]     = '0 ; 
assign err_sw_class [ 14 ]     = '0 ; 
assign err_sw_class [ 15 ]     = '0 ; 
assign err_sw_class [ 16 ]     = '0 ; 
assign err_sw_class [ 17 ]     = '0 ; 
assign err_sw_class [ 18 ]     = '0 ; 
assign err_sw_class [ 19 ]     = '0 ; 
assign err_sw_class [ 20 ]     = '0 ; 
assign err_sw_class [ 21 ]     = '0 ; 
assign err_sw_class [ 22 ]     = '0 ; 
assign err_sw_class [ 23 ]     = '0 ; 
assign err_sw_class [ 24 ]     = '0 ; 
assign err_sw_class [ 25 ]     = '0 ; 
assign err_sw_class [ 26 ]     = '0 ; 
assign err_sw_class [ 27 ]     = '0 ; 
assign err_sw_class [ 30 : 28 ] = 3'd7 ; 

assign err_hw_class_00 [ 0 ]      = enqpipe_err_hist_list_data_error_sb_f ; 
assign err_hw_class_00 [ 1 ]      = enqpipe_err_hist_list_data_error_mb_f ; 
assign err_hw_class_00 [ 2 ]      = enqpipe_err_freelist_data_error_sb_f ; 
assign err_hw_class_00 [ 3 ]      = enqpipe_err_freelist_data_error_mb_f ; 
assign err_hw_class_00 [ 4 ]      = egress_err_hcw_ecc_sb_f ; 
assign err_hw_class_00 [ 5 ]      = egress_err_hcw_ecc_mb_f ; 
assign err_hw_class_00 [ 6 ]      = schpipe_err_ldb_cq_hcw_h_ecc_sb_f ; 
assign err_hw_class_00 [ 7 ]      = schpipe_err_ldb_cq_hcw_h_ecc_mb_f ; 
assign err_hw_class_00 [ 8 ]      = '0 ; 
assign err_hw_class_00 [ 9 ]      = '0 ; 
assign err_hw_class_00 [ 10 ]     = '0 ; 
assign err_hw_class_00 [ 11 ]     = '0 ; 
assign err_hw_class_00 [ 12 ]     = '0 ; 
assign err_hw_class_00 [ 13 ]     = '0 ; 
assign err_hw_class_00 [ 14 ]     = '0 ; 
assign err_hw_class_00 [ 15 ]     = '0 ; 
assign err_hw_class_00 [ 16 ]     = '0 ; 
assign err_hw_class_00 [ 17 ]     = '0 ; 
assign err_hw_class_00 [ 18 ]     = '0 ; 
assign err_hw_class_00 [ 19 ]     = '0 ; 
assign err_hw_class_00 [ 20 ]     = '0 ; 
assign err_hw_class_00 [ 21 ]     = '0 ; 
assign err_hw_class_00 [ 22 ]     = '0 ; 
assign err_hw_class_00 [ 23 ]     = '0 ; 
assign err_hw_class_00 [ 24 ]     = '0 ; 
assign err_hw_class_00 [ 25 ]     = '0 ; 
assign err_hw_class_00 [ 26 ]     = '0 ; 
assign err_hw_class_00 [ 27 ]     = '0 ; 
assign err_hw_class_00 [ 30 : 28 ] = 3'd0 ; 

assign err_hw_class_01_nxt [ 0 ]  = egress_err_pipe_credit_error ;
assign err_hw_class_01_nxt [ 1 ]  = egress_err_parity_ldb_cq_token_depth_select ;
assign err_hw_class_01_nxt [ 2 ]  = egress_err_parity_dir_cq_token_depth_select ;
assign err_hw_class_01_nxt [ 3 ]  = egress_err_parity_ldb_cq_intr_thresh ;
assign err_hw_class_01_nxt [ 4 ]  = egress_err_parity_dir_cq_intr_thresh ;
assign err_hw_class_01_nxt [ 5 ]  = egress_err_residue_ldb_cq_wptr ;
assign err_hw_class_01_nxt [ 6 ]  = egress_err_residue_dir_cq_wptr ;
assign err_hw_class_01_nxt [ 7 ]  = egress_err_residue_ldb_cq_depth ;
assign err_hw_class_01_nxt [ 8 ]  = egress_err_residue_dir_cq_depth ;
assign err_hw_class_01_nxt [ 9 ]  = arb_err_chp_pipe_credit_error ;
assign err_hw_class_01_nxt [ 10 ] = arb_err_illegal_cmd_error ;
assign err_hw_class_01_nxt [ 11 ] = ing_err_hcw_enq_user_parity_error ;
assign err_hw_class_01_nxt [ 12 ] = ing_err_hcw_enq_data_parity_error ;
assign err_hw_class_01_nxt [ 13 ] = enqpipe_err_enq_to_rop_freelist_uf_drop ;
assign err_hw_class_01_nxt [ 14 ] = qed_to_cq_pipe_credit_status [ 0 ] ; //error
assign err_hw_class_01_nxt [ 15 ] = ing_err_qed_chp_sch_flid_ret_flid_parity_error | freelist_push_parity_chk_error ;
assign err_hw_class_01_nxt [ 16 ] = ing_err_qed_chp_sch_cq_parity_error | ing_err_aqed_chp_sch_cq_parity_error ;
assign err_hw_class_01_nxt [ 17 ] = ing_err_qed_chp_sch_vas_parity_error | ing_err_aqed_chp_sch_vas_parity_error ;
assign err_hw_class_01_nxt [ 18 ] = ing_err_enq_vas_credit_count_residue_error ;
assign err_hw_class_01_nxt [ 19 ] = ing_err_sch_vas_credit_count_residue_error ;
assign err_hw_class_01_nxt [ 20 ] = schpipe_err_pipeline_parity_err ;
assign err_hw_class_01_nxt [ 21 ] = enqpipe_err_frag_count_residue_error ;
assign err_hw_class_01_nxt [ 22 ] = sharepipe_error ;
assign err_hw_class_01_nxt [ 23 ] = ram_access_error ;
assign err_hw_class_01_nxt [ 24 ] = hist_list_of ;
assign err_hw_class_01_nxt [ 25 ] = freelist_of ;
assign err_hw_class_01_nxt [ 26 ] = freelist_pop_error ;
assign err_hw_class_01_nxt [ 27 ] = fifo_chp_rop_hcw_of ;
assign err_hw_class_01_nxt [ 30 : 28 ] = 3'd1 ;
assign err_hw_class_01_v_nxt = ( | err_hw_class_01_nxt [ 27 : 0 ] ) ;

assign err_hw_class_02_nxt [ 0 ]  = fifo_chp_rop_hcw_uf ;
assign err_hw_class_02_nxt [ 1 ]  = fifo_chp_lsp_tok_of ;
assign err_hw_class_02_nxt [ 2 ]  = fifo_chp_lsp_tok_uf ;
assign err_hw_class_02_nxt [ 3 ]  = fifo_chp_lsp_ap_cmp_of ;
assign err_hw_class_02_nxt [ 4 ]  = fifo_chp_lsp_ap_cmp_uf ;
assign err_hw_class_02_nxt [ 5 ]  = fifo_outbound_hcw_of ;
assign err_hw_class_02_nxt [ 6 ]  = fifo_outbound_hcw_uf ;
assign err_hw_class_02_nxt [ 7 ]  = fifo_qed_to_cq_of ;
assign err_hw_class_02_nxt [ 8 ]  = fifo_qed_to_cq_uf ;
assign err_hw_class_02_nxt [ 9 ]  = hist_list_residue_error_cfg | hist_list_a_residue_error_cfg ;
assign err_hw_class_02_nxt [ 10 ] = cfg_rx_fifo_status_underflow ;
assign err_hw_class_02_nxt [ 11 ] = cfg_rx_fifo_status_overflow ;
assign err_hw_class_02_nxt [ 12 ] = fifo_chp_sys_tx_fifo_mem_of ;
assign err_hw_class_02_nxt [ 13 ] = fifo_chp_sys_tx_fifo_mem_uf ;
assign err_hw_class_02_nxt [ 14 ] = 1'd0 ;
assign err_hw_class_02_nxt [ 15 ] = ing_err_qed_chp_sch_rx_sync_out_cmd_error ;
assign err_hw_class_02_nxt [ 16 ] = cq_timer_threshold_parity_err_dir_cial ;
assign err_hw_class_02_nxt [ 17 ] = cq_timer_threshold_parity_err_ldb_cial ;
assign err_hw_class_02_nxt [ 18 ] = cq_timer_threshold_parity_err_dir_cwdi ;
assign err_hw_class_02_nxt [ 19 ] = cq_timer_threshold_parity_err_ldb_cwdi ;
assign err_hw_class_02_nxt [ 20 ] = sch_excep_parity_check_err_dir_cial ;
assign err_hw_class_02_nxt [ 21 ] = sch_excep_parity_check_err_ldb_cial ;
assign err_hw_class_02_nxt [ 22 ] = sch_excep_parity_check_err_dir_cwdi ;
assign err_hw_class_02_nxt [ 23 ] = sch_excep_parity_check_err_ldb_cwdi ;
assign err_hw_class_02_nxt [ 24 ] = hqm_chp_partial_outbound_hcw_fifo_parity_err ;
assign err_hw_class_02_nxt [ 25 ] = chp_lsp_token_qb_in_valid & ~ chp_lsp_token_qb_in_ready ;
assign err_hw_class_02_nxt [ 26 ] = cmp_id_chk_enbl_parity_err ;
assign err_hw_class_02_nxt [ 27 ] = hqm_credit_hist_pipe_rfw_top_ipar_error ;
assign err_hw_class_02_nxt [ 30 : 28 ] = 3'd2 ;
assign err_hw_class_02_v_nxt = ( | err_hw_class_02_nxt [ 27 : 0 ] ) ;


always_ff @ ( posedge hqm_gated_clk ) begin
    egress_err_ldb_rid_f <= egress_err_ldb_rid ;
    egress_err_dir_rid_f <= egress_err_dir_rid ;
    enqpipe_err_rid_f <= enqpipe_err_rid ;
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    err_hw_class_01_f <= '0 ;
    err_hw_class_01_v_f <= '0 ;
    err_hw_class_02_f <= '0 ;
    err_hw_class_02_v_f <= '0 ;

    egress_err_hcw_ecc_sb_f <= '0 ;
    egress_err_hcw_ecc_mb_f <= '0 ;
    egress_err_ldb_cq_depth_underflow_f <= '0 ;
    egress_err_ldb_cq_depth_overflow_f <= '0 ;
    egress_err_dir_cq_depth_underflow_f <= '0 ;
    egress_err_dir_cq_depth_overflow_f <= '0 ;

    ing_err_hcw_enq_invalid_hcw_cmd_f <= '0 ;

    enqpipe_err_hist_list_data_error_sb_f <= '0 ;
    enqpipe_err_hist_list_data_error_mb_f <= '0 ;
    enqpipe_err_freelist_data_error_sb_f <= '0 ;
    enqpipe_err_freelist_data_error_mb_f <= '0 ;
    enqpipe_err_enq_to_rop_out_of_credit_drop_f <= '0 ;
    enqpipe_err_enq_to_rop_excess_frag_drop_f <= '0 ;
    enqpipe_err_enq_to_lsp_cmp_error_drop_f <= '0 ;
    enqpipe_err_release_qtype_error_drop_f <= '0 ;

    schpipe_err_ldb_cq_hcw_h_ecc_sb_f <= '0 ;
    schpipe_err_ldb_cq_hcw_h_ecc_mb_f <= '0 ;
  end
  else begin
    err_hw_class_01_f <= err_hw_class_01_nxt ;
    err_hw_class_01_v_f <= err_hw_class_01_v_nxt ;
    err_hw_class_02_f <= err_hw_class_02_nxt ;
    err_hw_class_02_v_f <= err_hw_class_02_v_nxt ;

    egress_err_hcw_ecc_sb_f <= egress_err_hcw_ecc_sb ;
    egress_err_hcw_ecc_mb_f <= egress_err_hcw_ecc_mb ;
    egress_err_ldb_cq_depth_underflow_f <= egress_err_ldb_cq_depth_underflow ;
    egress_err_ldb_cq_depth_overflow_f <= egress_err_ldb_cq_depth_overflow ;
    egress_err_dir_cq_depth_underflow_f <= egress_err_dir_cq_depth_underflow ;
    egress_err_dir_cq_depth_overflow_f <= egress_err_dir_cq_depth_overflow ;

    ing_err_hcw_enq_invalid_hcw_cmd_f <= ing_err_hcw_enq_invalid_hcw_cmd ;

    enqpipe_err_hist_list_data_error_sb_f <= enqpipe_err_hist_list_data_error_sb ;
    enqpipe_err_hist_list_data_error_mb_f <= enqpipe_err_hist_list_data_error_mb ;
    enqpipe_err_freelist_data_error_sb_f <= freelist_eccerr_sb ;
    enqpipe_err_freelist_data_error_mb_f <= enq_freelist_error_mb ;
    enqpipe_err_enq_to_rop_out_of_credit_drop_f <= enqpipe_err_enq_to_rop_out_of_credit_drop ;
    enqpipe_err_enq_to_rop_excess_frag_drop_f <= enqpipe_err_enq_to_rop_excess_frag_drop ;
    enqpipe_err_enq_to_lsp_cmp_error_drop_f <= enqpipe_err_enq_to_lsp_cmp_error_drop ;
    enqpipe_err_release_qtype_error_drop_f <= enqpipe_err_release_qtype_error_drop ;

    schpipe_err_ldb_cq_hcw_h_ecc_sb_f <= schpipe_err_ldb_cq_hcw_h_ecc_sb ;
    schpipe_err_ldb_cq_hcw_h_ecc_mb_f <= schpipe_err_ldb_cq_hcw_h_ecc_mb ;
  end
end

always_comb begin
  int_uid                                                  = HQM_CHP_CFG_UNIT_ID ;
  int_unc_v                                                = '0 ;
  int_unc_data                                             = '0 ;
  int_cor_v                                                = '0 ;
  int_cor_data                                             = '0 ;
  int_inf_v                                                = '0 ;
  int_inf_data                                             = '0 ;
  hqm_chp_target_cfg_syndrome_01_capture_v                 = '0 ;
  hqm_chp_target_cfg_syndrome_01_capture_data              = '0 ;
  hqm_chp_target_cfg_syndrome_00_capture_v                 = '0 ;
  hqm_chp_target_cfg_syndrome_00_capture_data              = '0 ;

  //  ing_err_hcw_enq_invalid_hcw_cmd_f "SW Error" invalid HCW drop condition
  if ( ing_err_hcw_enq_invalid_hcw_cmd_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[6]  ) begin
    int_inf_v [ 1 ]                                = 1'b1 ;
    int_inf_data [ 1 ].rtype                       = 2'd0 ;
    int_inf_data [ 1 ].rid                         = 8'h0 ;
    int_inf_data [ 1 ].msix_map                    = INGRESS_ERROR ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[7] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  enqpipe_err_enq_to_rop_out_of_credit_drop_f "SW Error" credit hist pipe drop conditions HCW
  if ( enqpipe_err_enq_to_rop_out_of_credit_drop_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[6]  ) begin
    int_inf_v [ 1 ]                                = 1'b1 ;
    int_inf_data [ 1 ].rtype                       = 2'd1 ;
    int_inf_data [ 1 ].rid                         = enqpipe_err_rid_f ;
    int_inf_data [ 1 ].msix_map                    = INGRESS_ERROR ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[7] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  enqpipe_err_enq_to_rop_excess_frag_drop_f "SW Error" credit hist pipe drop conditions HCW
  if ( enqpipe_err_enq_to_rop_excess_frag_drop_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[6]  ) begin
    int_inf_v [ 1 ]                                = 1'b1 ;
    int_inf_data [ 1 ].rtype                       = 2'd1 ;
    int_inf_data [ 1 ].rid                         = enqpipe_err_rid_f ;
    int_inf_data [ 1 ].msix_map                    = INGRESS_ERROR ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[7] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  enqpipe_err_enq_to_lsp_cmp_error_drop_f "SW Error" credit hist pipe drop conditions HCW
  if ( enqpipe_err_enq_to_lsp_cmp_error_drop_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[6]  ) begin
    int_inf_v [ 1 ]                                = 1'b1 ;
    int_inf_data [ 1 ].rtype                       = 2'd1 ;
    int_inf_data [ 1 ].rid                         = enqpipe_err_rid_f ;
    int_inf_data [ 1 ].msix_map                    = INGRESS_ERROR ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[7] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  enqpipe_err_release_qtype_error_drop_f "SW Error" credit hist pipe drop conditions HCW
  if ( enqpipe_err_release_qtype_error_drop_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[6]  ) begin
    int_inf_v [ 1 ]                                = 1'b1 ;
    int_inf_data [ 1 ].rtype                       = 2'd1 ;
    int_inf_data [ 1 ].rid                         = enqpipe_err_rid_f ;
    int_inf_data [ 1 ].msix_map                    = INGRESS_ERROR ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[7] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  egress_err_ldb_cq_depth_underflow_f "SW Error" too many tokens returned
  if ( egress_err_ldb_cq_depth_underflow_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[10]  ) begin
    int_inf_v [ 2 ]                                = 1'b1 ;
    int_inf_data [ 2 ].rtype                       = 2'd1 ;
    int_inf_data [ 2 ].rid                         = egress_err_ldb_rid_f ;
    int_inf_data [ 2 ].msix_map                    = INGRESS_ERROR ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[11] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  egress_err_dir_cq_depth_underflow_f "SW Error" too many tokens returned
  if ( egress_err_dir_cq_depth_underflow_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[10]  ) begin
    int_inf_v [ 2 ]                                = 1'b1 ;
    int_inf_data [ 2 ].rtype                       = 2'd1 ;
    int_inf_data [ 2 ].rid                         = egress_err_dir_rid_f ;
    int_inf_data [ 2 ].msix_map                    = INGRESS_ERROR ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[11] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  egress_err_ldb_cq_depth_overflow_f "SW Error" cq depth overflow
  if ( egress_err_ldb_cq_depth_overflow_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[8]  ) begin
    int_inf_v [ 2 ]                                = 1'b1 ;
    int_inf_data [ 2 ].rtype                       = 2'd1 ;
    int_inf_data [ 2 ].rid                         = egress_err_ldb_rid_f ;
    int_inf_data [ 2 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[9] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  egress_err_dir_cq_depth_overflow_f "SW Error" cq depth overflow
  if ( egress_err_dir_cq_depth_overflow_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[8]  ) begin
    int_inf_v [ 2 ]                                = 1'b1 ;
    int_inf_data [ 2 ].rtype                       = 2'd1 ;
    int_inf_data [ 2 ].rid                         = egress_err_dir_rid_f ;
    int_inf_data [ 2 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_00_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[9] ;
    hqm_chp_target_cfg_syndrome_00_capture_data    = err_sw_class ;
  end
  //  enqpipe_err_hist_list_data_error_sb_f "ECC Error" correctable ECC error
  if ( enqpipe_err_hist_list_data_error_sb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[1] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  enqpipe_err_freelist_data_error_sb_f "ECC Error" correctable ECC error
  if ( enqpipe_err_freelist_data_error_sb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[1] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  egress_err_hcw_ecc_sb_f "ECC Error" correctable ECC error
  if ( egress_err_hcw_ecc_sb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[1] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  schpipe_err_ldb_cq_hcw_h_ecc_sb_f "ECC Error" correctable ECC error
  if ( schpipe_err_ldb_cq_hcw_h_ecc_sb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[1] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  enqpipe_err_hist_list_data_error_mb_f "ECC Error" uncorrectable ECC error
  if ( enqpipe_err_hist_list_data_error_mb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[3] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  enqpipe_err_freelist_data_error_mb_f "ECC Error" uncorrectable ECC error
  if ( enqpipe_err_freelist_data_error_mb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[3] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  egress_err_hcw_ecc_mb_f "ECC Error" uncorrectable ECC error
  if ( egress_err_hcw_ecc_mb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[3] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  schpipe_err_ldb_cq_hcw_h_ecc_mb_f "ECC Error" uncorrectable ECC error
  if ( schpipe_err_ldb_cq_hcw_h_ecc_mb_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[3] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_00 ;
  end
  //  err_hw_class_01_v_f "HW Error" "Hardware error
  if ( err_hw_class_01_v_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[5] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_01_f ;
  end
  //  err_hw_class_02_v_f "HW Error" "Hardware error
  if ( err_hw_class_02_v_f & ~hqm_chp_target_cfg_chp_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_chp_target_cfg_syndrome_01_capture_v       = ~hqm_chp_target_cfg_chp_csr_control_reg_f[5] ;
    hqm_chp_target_cfg_syndrome_01_capture_data    = err_hw_class_02_f ;
  end
end



//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: END common core interfaces
//*****************************************************************************************************
//*****************************************************************************************************

////////////////////////////////////////////////////////////////////////////////////////////////////
// attach generated code to strucutres

assign   cfg_unit_idle_reg_f = hqm_chp_target_cfg_unit_idle_reg_f ;
assign   hqm_chp_target_cfg_unit_idle_reg_nxt = cfg_unit_idle_reg_nxt ;

////////////////////////////////////////////////////////////////////////////////////////////////////
//flops

// PF reset
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    reset_pf_counter_f <= '0 ;
    reset_pf_active_f <= 1'b1 ;
    reset_pf_done_f <= '0 ;
    hw_init_done_f <= '0 ;
    freelist_pf_push_v_f <= 1'b0 ;
  end
  else begin
    reset_pf_counter_f <= reset_pf_counter_nxt ;
    reset_pf_active_f <= reset_pf_active_nxt ;
    reset_pf_done_f <= reset_pf_done_nxt ;
    hw_init_done_f <= hw_init_done_nxt ;
    freelist_pf_push_v_f <= freelist_pf_push_v_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk ) begin
  freelist_pf_push_data_f <= freelist_pf_push_data_nxt ;
end


//Capture master generated timestamp and convert to binary
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
   if ( ~ hqm_gated_rst_n ) begin
      master_chp_timestamp_f <= '0 ;
      master_chp_timestamp_g2b_f <= '0 ;
   end
   else begin
      master_chp_timestamp_f <= master_chp_timestamp ;
      master_chp_timestamp_g2b_f <= master_chp_timestamp_g2b ;
   end
end
hqm_AW_gray2bin # (
   .WIDTH                             ( 16 )
) i_gray2bin (
   .gray                              ( master_chp_timestamp_f )
 , .binary                            ( master_chp_timestamp_g2b )
) ;

//flop SMON input for STA
logic [ 16 - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_v_nxt , hqm_chp_target_cfg_chp_smon_smon_v_f ;
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_comp_nxt , hqm_chp_target_cfg_chp_smon_smon_comp_f ;
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_val_nxt , hqm_chp_target_cfg_chp_smon_smon_val_f ;
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
   if ( ~ hqm_gated_rst_n ) begin
     hqm_chp_target_cfg_chp_smon_smon_v_f <= '0 ;
   end
   else begin
     hqm_chp_target_cfg_chp_smon_smon_v_f <= hqm_chp_target_cfg_chp_smon_smon_enabled ? hqm_chp_target_cfg_chp_smon_smon_v_nxt : hqm_chp_target_cfg_chp_smon_smon_v_f ;
   end
end
always_ff @ ( posedge hqm_gated_clk ) begin
     hqm_chp_target_cfg_chp_smon_smon_comp_f <= hqm_chp_target_cfg_chp_smon_smon_enabled ? hqm_chp_target_cfg_chp_smon_smon_comp_nxt : hqm_chp_target_cfg_chp_smon_smon_comp_f ;
     hqm_chp_target_cfg_chp_smon_smon_val_f <= hqm_chp_target_cfg_chp_smon_smon_enabled ? hqm_chp_target_cfg_chp_smon_smon_val_nxt : hqm_chp_target_cfg_chp_smon_smon_val_f ;
end



////////////////////////////////////////////////////////////////////////////////////////////////////
// visa connection
assign visa_str_chp_lsp_cmp_data = | chp_lsp_cmp_data ;


////////////////////////////////////////////////////////////////////////////////////////////////////
// top level shared AW
logic hist_list_pop_data_v_nc ;
logic hist_list_pop_data_last_nc ;
logic hist_list_p0_v_f_nc ;
logic hist_list_p1_v_f_nc ;
logic hist_list_p2_v_f_nc ;
logic hist_list_p3_v_f_nc ;

hqm_AW_multi_fifo # (
   .NUM_FIFOS                         ( HQM_NUM_LB_CQ )
 , .DEPTH                             ( HQM_CHP_HIST_LIST_DEPTH )
 , .DWIDTH                            ( $bits ( hist_list_push_data ) )
) i_mf_hist_list (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( hist_list_status_nc )
 , .cmd_v                             ( hist_list_cmd_v )
 , .cmd                               ( hist_list_cmd )
 , .fifo_num                          ( hist_list_fifo_num )
 , .push_data                         ( hist_list_push_data )
 , .push_offset                       ( '0 )
 , .pop_data                          ( hist_list_pop_data )
 , .pop_data_v                        ( hist_list_pop_data_v_nc )
 , .pop_data_last                     ( hist_list_pop_data_last_nc )
 , .p0_v_f                            ( hist_list_p0_v_f_nc )
 , .p0_hold                           ( '0 )
 , .p1_v_f                            ( hist_list_p1_v_f_nc )
 , .p1_hold                           ( '0 )
 , .p2_v_f                            ( hist_list_p2_v_f_nc )
 , .p2_hold                           ( '0 )
 , .p3_v_f                            ( hist_list_p3_v_f_nc )
 , .p3_hold                           ( '0 )
 , .err_rid                           ( hist_list_error_rid_nc )
 , .err_uflow                         ( hist_list_uf )
 , .err_oflow                         ( hist_list_of )
 , .err_residue                       ( hist_list_residue_error )
 , .err_residue_cfg                   ( hist_list_residue_error_cfg )
 , .ptr_mem_re                        ( func_hist_list_ptr_re )
 , .ptr_mem_raddr                     ( func_hist_list_ptr_raddr )
 , .ptr_mem_we                        ( func_hist_list_ptr_we )
 , .ptr_mem_waddr                     ( func_hist_list_ptr_waddr )
 , .ptr_mem_wdata                     ( func_hist_list_ptr_wdata )
 , .ptr_mem_rdata                     ( func_hist_list_ptr_rdata )
 , .minmax_mem_re                     ( func_hist_list_minmax_re )
 , .minmax_mem_addr                   ( func_hist_list_minmax_addr )
 , .minmax_mem_we                     ( func_hist_list_minmax_we )
 , .minmax_mem_wdata                  ( func_hist_list_minmax_wdata )
 , .minmax_mem_rdata                  ( func_hist_list_minmax_rdata )
 , .fifo_mem_re                       ( func_hist_list_re )
 , .fifo_mem_addr                     ( func_hist_list_addr )
 , .fifo_mem_we                       ( func_hist_list_we )
 , .fifo_mem_wdata                    ( func_hist_list_wdata )
 , .fifo_mem_rdata                    ( func_hist_list_rdata )
) ; // i_hist_list

logic hist_list_a_pop_data_v ;
logic hist_list_a_pop_data_last_nc ;
logic hist_list_a_p0_v_f_nc ;
logic hist_list_a_p1_v_f_nc ;
logic hist_list_a_p2_v_f_nc ;
logic hist_list_a_p3_v_f_nc ;

hqm_AW_multi_fifo # (
   .NUM_FIFOS                         ( HQM_NUM_LB_CQ )
 , .DEPTH                             ( HQM_CHP_HIST_LIST_DEPTH )
 , .DWIDTH                            ( $bits ( hist_list_a_push_data ) )
) i_mf_hist_list_a (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( hist_list_a_status_nc )
 , .cmd_v                             ( hist_list_a_cmd_v )
 , .cmd                               ( hist_list_a_cmd )
 , .fifo_num                          ( hist_list_a_fifo_num )
 , .push_data                         ( hist_list_a_push_data )
 , .push_offset                       ( '0 )
 , .pop_data                          ( hist_list_a_pop_data )
 , .pop_data_v                        ( hist_list_a_pop_data_v )
 , .pop_data_last                     ( hist_list_a_pop_data_last_nc )
 , .p0_v_f                            ( hist_list_a_p0_v_f_nc )
 , .p0_hold                           ( '0 )
 , .p1_v_f                            ( hist_list_a_p1_v_f_nc )
 , .p1_hold                           ( '0 )
 , .p2_v_f                            ( hist_list_a_p2_v_f_nc )
 , .p2_hold                           ( '0 )
 , .p3_v_f                            ( hist_list_a_p3_v_f_nc )
 , .p3_hold                           ( '0 )
 , .err_rid                           ( hist_list_a_error_rid_nc )
 , .err_uflow                         ( hist_list_a_uf )
 , .err_oflow                         ( hist_list_a_of )
 , .err_residue                       ( hist_list_a_residue_error )
 , .err_residue_cfg                   ( hist_list_a_residue_error_cfg )
 , .ptr_mem_re                        ( func_hist_list_a_ptr_re )
 , .ptr_mem_raddr                     ( func_hist_list_a_ptr_raddr )
 , .ptr_mem_we                        ( func_hist_list_a_ptr_we )
 , .ptr_mem_waddr                     ( func_hist_list_a_ptr_waddr )
 , .ptr_mem_wdata                     ( func_hist_list_a_ptr_wdata )
 , .ptr_mem_rdata                     ( func_hist_list_a_ptr_rdata )
 , .minmax_mem_re                     ( func_hist_list_a_minmax_re )
 , .minmax_mem_addr                   ( func_hist_list_a_minmax_addr )
 , .minmax_mem_we                     ( func_hist_list_a_minmax_we )
 , .minmax_mem_wdata                  ( func_hist_list_a_minmax_wdata )
 , .minmax_mem_rdata                  ( func_hist_list_a_minmax_rdata )
 , .fifo_mem_re                       ( func_hist_list_a_re )
 , .fifo_mem_addr                     ( func_hist_list_a_addr )
 , .fifo_mem_we                       ( func_hist_list_a_we )
 , .fifo_mem_wdata                    ( func_hist_list_a_wdata )
 , .fifo_mem_rdata                    ( func_hist_list_a_rdata )
) ; // i_hist_list_a

//------------------------------------------------------------------------------------------------------------------------------------------------
hqm_chp_freelist #(
   .NUM_FIDS  ( NUM_CREDITS )
  ,.NUM_BANKS ( NUM_CREDITS_BANKS )
  ,.BDEPTH    ( NUM_CREDITS_PBANK )
) i_chp_freelist (
  .clk                                ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )

 , .freelist_pf_push_v                ( freelist_pf_push_v )
 , .freelist_pf_push_data             ( freelist_pf_push_data )
 , .freelist_push_v                   ( freelist_push_v )
 , .freelist_push_data                ( freelist_push_data )

 , .freelist_pop_v                    ( freelist_pop_v )
 , .freelist_pop_data                 ( freelist_pop_data )

 , .freelist_size                     ( freelist_size ) // O
 , .freelist_empty                    ( freelist_empty ) // O
 , .freelist_full                     ( freelist_full ) // O
 , .freelist_of                       ( freelist_of ) // O
 , .freelist_uf                       ( freelist_uf ) // O
 , .freelist_eccerr_mb                ( freelist_eccerr_mb ) // O
 , .freelist_eccerr_sb                ( freelist_eccerr_sb ) // O
 , .freelist_pop_error                ( freelist_pop_error ) // O 

 , .freelist_push_parity_chk_error    ( freelist_push_parity_chk_error ) // O

 , .freelist_status_idle              ( freelist_status_idle ) // O 

 , .func_freelist_0_we                ( func_freelist_0_we   )
 , .func_freelist_0_re                ( func_freelist_0_re   )
 , .func_freelist_0_addr              ( func_freelist_0_addr )
 , .func_freelist_0_wdata             ( func_freelist_0_wdata)
 , .func_freelist_0_rdata             ( func_freelist_0_rdata)
 , .func_freelist_1_we                ( func_freelist_1_we   )
 , .func_freelist_1_re                ( func_freelist_1_re   )
 , .func_freelist_1_addr              ( func_freelist_1_addr )
 , .func_freelist_1_wdata             ( func_freelist_1_wdata)
 , .func_freelist_1_rdata             ( func_freelist_1_rdata)
 , .func_freelist_2_we                ( func_freelist_2_we   )
 , .func_freelist_2_re                ( func_freelist_2_re   )
 , .func_freelist_2_addr              ( func_freelist_2_addr )
 , .func_freelist_2_wdata             ( func_freelist_2_wdata)
 , .func_freelist_2_rdata             ( func_freelist_2_rdata)
 , .func_freelist_3_we                ( func_freelist_3_we   )
 , .func_freelist_3_re                ( func_freelist_3_re   )
 , .func_freelist_3_addr              ( func_freelist_3_addr )
 , .func_freelist_3_wdata             ( func_freelist_3_wdata)
 , .func_freelist_3_rdata             ( func_freelist_3_rdata)
 , .func_freelist_4_we                ( func_freelist_4_we   )
 , .func_freelist_4_re                ( func_freelist_4_re   )
 , .func_freelist_4_addr              ( func_freelist_4_addr )
 , .func_freelist_4_wdata             ( func_freelist_4_wdata)
 , .func_freelist_4_rdata             ( func_freelist_4_rdata)
 , .func_freelist_5_we                ( func_freelist_5_we   )
 , .func_freelist_5_re                ( func_freelist_5_re )
 , .func_freelist_5_addr              ( func_freelist_5_addr  )
 , .func_freelist_5_wdata             ( func_freelist_5_wdata )
 , .func_freelist_5_rdata             ( func_freelist_5_rdata )
 , .func_freelist_6_we                ( func_freelist_6_we    )
 , .func_freelist_6_re                ( func_freelist_6_re    )
 , .func_freelist_6_addr              ( func_freelist_6_addr  )
 , .func_freelist_6_wdata             ( func_freelist_6_wdata )
 , .func_freelist_6_rdata             ( func_freelist_6_rdata )
 , .func_freelist_7_we                ( func_freelist_7_we    )
 , .func_freelist_7_re                ( func_freelist_7_re    )
 , .func_freelist_7_addr              ( func_freelist_7_addr  )
 , .func_freelist_7_wdata             ( func_freelist_7_wdata )
 , .func_freelist_7_rdata             ( func_freelist_7_rdata )
);

logic rw_ldb_cq_depth_p0_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_depth_p0_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_depth_p0_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ] rw_ldb_cq_depth_p0_data_f_nc ;
logic rw_ldb_cq_depth_p1_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_depth_p1_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_depth_p1_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_ldb_cq_depth_p1_data_f_nc ;
logic rw_ldb_cq_depth_p2_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_depth_p2_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_depth_p2_addr_f_nc ;
logic rw_ldb_cq_depth_p3_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_depth_p3_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_depth_p3_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_ldb_cq_depth_p3_data_f_nc ;

hqm_AW_rmw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_LB_CQ )
 , .WIDTH                             ( $bits ( rw_ldb_cq_depth_p2_data_f ) )
) i_rw_ldb_cq_depth_mem_pipe (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_ldb_cq_depth_mem_pipe_status_nc )
 , .p0_v_nxt                          ( rw_ldb_cq_depth_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_ldb_cq_depth_p0_rmw_nxt )
 , .p0_addr_nxt                       ( rw_ldb_cq_depth_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_ldb_cq_depth_p0_v_f_nc )
 , .p0_rw_f                           ( rw_ldb_cq_depth_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_ldb_cq_depth_p0_addr_f_nc )
 , .p0_data_f                         ( rw_ldb_cq_depth_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_ldb_cq_depth_p1_v_f_nc )
 , .p1_rw_f                           ( rw_ldb_cq_depth_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_ldb_cq_depth_p1_addr_f_nc )
 , .p1_data_f                         ( rw_ldb_cq_depth_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_ldb_cq_depth_p2_v_f_nc )
 , .p2_rw_f                           ( rw_ldb_cq_depth_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_ldb_cq_depth_p2_addr_f_nc )
 , .p2_data_f                         ( rw_ldb_cq_depth_p2_data_f )
 , .p3_bypsel_nxt                     ( rw_ldb_cq_depth_p3_bypsel_nxt )
 , .p3_bypdata_nxt                    ( rw_ldb_cq_depth_p3_bypdata_nxt )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_ldb_cq_depth_p3_v_f_nc )
 , .p3_rw_f                           ( rw_ldb_cq_depth_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_ldb_cq_depth_p3_addr_f_nc )
 , .p3_data_f                         ( rw_ldb_cq_depth_p3_data_f_nc )
 , .mem_write                         ( func_ldb_cq_depth_we )
 , .mem_write_addr                    ( func_ldb_cq_depth_waddr )
 , .mem_write_data                    ( func_ldb_cq_depth_wdata )
 , .mem_read                          ( func_ldb_cq_depth_re )
 , .mem_read_addr                     ( func_ldb_cq_depth_raddr )
 , .mem_read_data                     ( func_ldb_cq_depth_rdata )
) ;

logic rw_dir_cq_depth_p0_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_depth_p0_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_depth_p0_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ] rw_dir_cq_depth_p0_data_f_nc ;
logic rw_dir_cq_depth_p1_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_depth_p1_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_depth_p1_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_dir_cq_depth_p1_data_f_nc ;
logic rw_dir_cq_depth_p2_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_depth_p2_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_depth_p2_addr_f_nc ;
logic rw_dir_cq_depth_p3_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_depth_p3_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_depth_p3_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_dir_cq_depth_p3_data_f_nc ;

hqm_AW_rmw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_DIR_CQ )
 , .WIDTH                             ( $bits ( rw_dir_cq_depth_p2_data_f ) )
) i_rw_dir_cq_depth_mem_pipe (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_dir_cq_depth_mem_pipe_status_nc )
 , .p0_v_nxt                          ( rw_dir_cq_depth_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_dir_cq_depth_p0_rmw_nxt )
 , .p0_addr_nxt                       ( rw_dir_cq_depth_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_dir_cq_depth_p0_v_f_nc )
 , .p0_rw_f                           ( rw_dir_cq_depth_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_dir_cq_depth_p0_addr_f_nc )
 , .p0_data_f                         ( rw_dir_cq_depth_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_dir_cq_depth_p1_v_f_nc )
 , .p1_rw_f                           ( rw_dir_cq_depth_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_dir_cq_depth_p1_addr_f_nc )
 , .p1_data_f                         ( rw_dir_cq_depth_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_dir_cq_depth_p2_v_f_nc )
 , .p2_rw_f                           ( rw_dir_cq_depth_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_dir_cq_depth_p2_addr_f_nc )
 , .p2_data_f                         ( rw_dir_cq_depth_p2_data_f )
 , .p3_bypsel_nxt                     ( rw_dir_cq_depth_p3_bypsel_nxt )
 , .p3_bypdata_nxt                    ( rw_dir_cq_depth_p3_bypdata_nxt )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_dir_cq_depth_p3_v_f_nc )
 , .p3_rw_f                           ( rw_dir_cq_depth_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_dir_cq_depth_p3_addr_f_nc )
 , .p3_data_f                         ( rw_dir_cq_depth_p3_data_f_nc )
 , .mem_write                         ( func_dir_cq_depth_we )
 , .mem_write_addr                    ( func_dir_cq_depth_waddr )
 , .mem_write_data                    ( func_dir_cq_depth_wdata )
 , .mem_read                          ( func_dir_cq_depth_re )
 , .mem_read_addr                     ( func_dir_cq_depth_raddr )
 , .mem_read_data                     ( func_dir_cq_depth_rdata )
) ;

logic rw_ldb_cq_wptr_p0_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_wptr_p0_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_wptr_p0_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ] rw_ldb_cq_wptr_p0_data_f_nc ;
logic rw_ldb_cq_wptr_p1_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_wptr_p1_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_wptr_p1_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_ldb_cq_wptr_p1_data_f_nc ;
logic rw_ldb_cq_wptr_p2_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_wptr_p2_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_wptr_p2_addr_f_nc ;
logic rw_ldb_cq_wptr_p3_v_f_nc ;
aw_rmwpipe_cmd_t rw_ldb_cq_wptr_p3_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_wptr_p3_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_ldb_cq_wptr_p3_data_f_nc ;

hqm_AW_rmw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_LB_CQ )
 , .WIDTH                             ( $bits ( rw_ldb_cq_wptr_p2_data_f ) )
) i_rw_ldb_cq_wp_mem_pipe (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_ldb_cq_wptr_mem_pipe_status_nc )
 , .p0_v_nxt                          ( rw_ldb_cq_wptr_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_ldb_cq_wptr_p0_rmw_nxt )
 , .p0_addr_nxt                       ( rw_ldb_cq_wptr_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_ldb_cq_wptr_p0_v_f_nc )
 , .p0_rw_f                           ( rw_ldb_cq_wptr_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_ldb_cq_wptr_p0_addr_f_nc )
 , .p0_data_f                         ( rw_ldb_cq_wptr_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_ldb_cq_wptr_p1_v_f_nc )
 , .p1_rw_f                           ( rw_ldb_cq_wptr_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_ldb_cq_wptr_p1_addr_f_nc )
 , .p1_data_f                         ( rw_ldb_cq_wptr_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_ldb_cq_wptr_p2_v_f_nc )
 , .p2_rw_f                           ( rw_ldb_cq_wptr_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_ldb_cq_wptr_p2_addr_f_nc )
 , .p2_data_f                         ( rw_ldb_cq_wptr_p2_data_f )
 , .p3_bypsel_nxt                     ( rw_ldb_cq_wptr_p3_bypsel_nxt )
 , .p3_bypdata_nxt                    ( rw_ldb_cq_wptr_p3_bypdata_nxt )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_ldb_cq_wptr_p3_v_f_nc )
 , .p3_rw_f                           ( rw_ldb_cq_wptr_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_ldb_cq_wptr_p3_addr_f_nc )
 , .p3_data_f                         ( rw_ldb_cq_wptr_p3_data_f_nc )
 , .mem_write                         ( func_ldb_cq_wptr_we )
 , .mem_write_addr                    ( func_ldb_cq_wptr_waddr )
 , .mem_write_data                    ( func_ldb_cq_wptr_wdata )
 , .mem_read                          ( func_ldb_cq_wptr_re )
 , .mem_read_addr                     ( func_ldb_cq_wptr_raddr )
 , .mem_read_data                     ( func_ldb_cq_wptr_rdata )
) ;

logic rw_dir_cq_wptr_p0_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_wptr_p0_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_wptr_p0_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ] rw_dir_cq_wptr_p0_data_f_nc ;
logic rw_dir_cq_wptr_p1_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_wptr_p1_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_wptr_p1_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_dir_cq_wptr_p1_data_f_nc ;
logic rw_dir_cq_wptr_p2_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_wptr_p2_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_wptr_p2_addr_f_nc ;
logic rw_dir_cq_wptr_p3_v_f_nc ;
aw_rmwpipe_cmd_t rw_dir_cq_wptr_p3_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_wptr_p3_addr_f_nc ;
logic [ ( 13 ) - 1 : 0 ]  rw_dir_cq_wptr_p3_data_f_nc ;

hqm_AW_rmw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_DIR_CQ )
 , .WIDTH                             ( $bits ( rw_dir_cq_wptr_p2_data_f ) )
) i_rw_dir_cq_wp_mem_pipe (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_dir_cq_wptr_mem_pipe_status_nc )
 , .p0_v_nxt                          ( rw_dir_cq_wptr_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_dir_cq_wptr_p0_rmw_nxt )
 , .p0_addr_nxt                       ( rw_dir_cq_wptr_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_dir_cq_wptr_p0_v_f_nc )
 , .p0_rw_f                           ( rw_dir_cq_wptr_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_dir_cq_wptr_p0_addr_f_nc )
 , .p0_data_f                         ( rw_dir_cq_wptr_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_dir_cq_wptr_p1_v_f_nc )
 , .p1_rw_f                           ( rw_dir_cq_wptr_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_dir_cq_wptr_p1_addr_f_nc )
 , .p1_data_f                         ( rw_dir_cq_wptr_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_dir_cq_wptr_p2_v_f_nc )
 , .p2_rw_f                           ( rw_dir_cq_wptr_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_dir_cq_wptr_p2_addr_f_nc )
 , .p2_data_f                         ( rw_dir_cq_wptr_p2_data_f )
 , .p3_bypsel_nxt                     ( rw_dir_cq_wptr_p3_bypsel_nxt )
 , .p3_bypdata_nxt                    ( rw_dir_cq_wptr_p3_bypdata_nxt )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_dir_cq_wptr_p3_v_f_nc )
 , .p3_rw_f                           ( rw_dir_cq_wptr_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_dir_cq_wptr_p3_addr_f_nc )
 , .p3_data_f                         ( rw_dir_cq_wptr_p3_data_f_nc )
 , .mem_write                         ( func_dir_cq_wptr_we )
 , .mem_write_addr                    ( func_dir_cq_wptr_waddr )
 , .mem_write_data                    ( func_dir_cq_wptr_wdata )
 , .mem_read                          ( func_dir_cq_wptr_re )
 , .mem_read_addr                     ( func_dir_cq_wptr_raddr )
 , .mem_read_data                     ( func_dir_cq_wptr_rdata )
) ;

logic rw_ldb_cq_token_depth_select_p0_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_token_depth_select_p0_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_token_depth_select_p0_addr_f_nc ;
chp_cq_token_depth_select_t rw_ldb_cq_token_depth_select_p0_data_f_nc ;
logic rw_ldb_cq_token_depth_select_p1_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_token_depth_select_p1_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_token_depth_select_p1_addr_f_nc ;
chp_cq_token_depth_select_t rw_ldb_cq_token_depth_select_p1_data_f_nc ;
logic rw_ldb_cq_token_depth_select_p2_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_token_depth_select_p2_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_token_depth_select_p2_addr_f_nc ;
logic rw_ldb_cq_token_depth_select_p3_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_token_depth_select_p3_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_token_depth_select_p3_addr_f_nc ;
chp_cq_token_depth_select_t rw_ldb_cq_token_depth_select_p3_data_f_nc ;

logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] func_ldb_cq_token_depth_select_addr ;
assign func_ldb_cq_token_depth_select_raddr = func_ldb_cq_token_depth_select_addr ;
assign func_ldb_cq_token_depth_select_waddr = func_ldb_cq_token_depth_select_addr ;
hqm_AW_rw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_LB_CQ )
 , .WIDTH                             ( $bits ( func_ldb_cq_token_depth_select_wdata ) )
) i_rw_ldb_cq_token_delpth_select (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_ldb_cq_token_depth_select_status_nc )
 , .p0_v_nxt                          ( rw_ldb_cq_token_depth_select_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_ldb_cq_token_depth_select_p0_rw_nxt )
 , .p0_addr_nxt                       ( rw_ldb_cq_token_depth_select_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_ldb_cq_token_depth_select_p0_v_f_nc )
 , .p0_rw_f                           ( rw_ldb_cq_token_depth_select_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_ldb_cq_token_depth_select_p0_addr_f_nc )
 , .p0_data_f                         ( rw_ldb_cq_token_depth_select_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_ldb_cq_token_depth_select_p1_v_f_nc )
 , .p1_rw_f                           ( rw_ldb_cq_token_depth_select_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_ldb_cq_token_depth_select_p1_addr_f_nc )
 , .p1_data_f                         ( rw_ldb_cq_token_depth_select_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_ldb_cq_token_depth_select_p2_v_f_nc )
 , .p2_rw_f                           ( rw_ldb_cq_token_depth_select_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_ldb_cq_token_depth_select_p2_addr_f_nc )
 , .p2_data_f                         ( rw_ldb_cq_token_depth_select_p2_data_f )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_ldb_cq_token_depth_select_p3_v_f_nc )
 , .p3_rw_f                           ( rw_ldb_cq_token_depth_select_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_ldb_cq_token_depth_select_p3_addr_f_nc )
 , .p3_data_f                         ( rw_ldb_cq_token_depth_select_p3_data_f_nc )
 , .mem_write                         ( func_ldb_cq_token_depth_select_we )
 , .mem_read                          ( func_ldb_cq_token_depth_select_re )
 , .mem_addr                          ( func_ldb_cq_token_depth_select_addr )
 , .mem_write_data                    ( func_ldb_cq_token_depth_select_wdata )
 , .mem_read_data                     ( func_ldb_cq_token_depth_select_rdata )
) ;

logic rw_dir_cq_token_depth_select_p0_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_token_depth_select_p0_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_token_depth_select_p0_addr_f_nc ;
chp_cq_token_depth_select_t rw_dir_cq_token_depth_select_p0_data_f_nc ;
logic rw_dir_cq_token_depth_select_p1_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_token_depth_select_p1_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_token_depth_select_p1_addr_f_nc ;
chp_cq_token_depth_select_t rw_dir_cq_token_depth_select_p1_data_f_nc ;
logic rw_dir_cq_token_depth_select_p2_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_token_depth_select_p2_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_token_depth_select_p2_addr_f_nc ;
logic rw_dir_cq_token_depth_select_p3_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_token_depth_select_p3_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_token_depth_select_p3_addr_f_nc ;
chp_cq_token_depth_select_t rw_dir_cq_token_depth_select_p3_data_f_nc ;

logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] func_dir_cq_token_depth_select_addr ;
assign func_dir_cq_token_depth_select_raddr = func_dir_cq_token_depth_select_addr ;
assign func_dir_cq_token_depth_select_waddr = func_dir_cq_token_depth_select_addr ;
hqm_AW_rw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_DIR_CQ )
 , .WIDTH                             ( $bits ( func_dir_cq_token_depth_select_wdata ) )
) i_rw_dir_cq_token_delpth_select (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_dir_cq_token_depth_select_status_nc )
 , .p0_v_nxt                          ( rw_dir_cq_token_depth_select_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_dir_cq_token_depth_select_p0_rw_nxt )
 , .p0_addr_nxt                       ( rw_dir_cq_token_depth_select_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_dir_cq_token_depth_select_p0_v_f_nc )
 , .p0_rw_f                           ( rw_dir_cq_token_depth_select_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_dir_cq_token_depth_select_p0_addr_f_nc )
 , .p0_data_f                         ( rw_dir_cq_token_depth_select_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_dir_cq_token_depth_select_p1_v_f_nc )
 , .p1_rw_f                           ( rw_dir_cq_token_depth_select_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_dir_cq_token_depth_select_p1_addr_f_nc )
 , .p1_data_f                         ( rw_dir_cq_token_depth_select_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_dir_cq_token_depth_select_p2_v_f_nc )
 , .p2_rw_f                           ( rw_dir_cq_token_depth_select_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_dir_cq_token_depth_select_p2_addr_f_nc )
 , .p2_data_f                         ( rw_dir_cq_token_depth_select_p2_data_f )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_dir_cq_token_depth_select_p3_v_f_nc )
 , .p3_rw_f                           ( rw_dir_cq_token_depth_select_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_dir_cq_token_depth_select_p3_addr_f_nc )
 , .p3_data_f                         ( rw_dir_cq_token_depth_select_p3_data_f_nc )
 , .mem_write                         ( func_dir_cq_token_depth_select_we )
 , .mem_read                          ( func_dir_cq_token_depth_select_re )
 , .mem_addr                          ( func_dir_cq_token_depth_select_addr )
 , .mem_write_data                    ( func_dir_cq_token_depth_select_wdata )
 , .mem_read_data                     ( func_dir_cq_token_depth_select_rdata )
) ;

logic rw_ldb_cq_intr_thresh_p0_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_intr_thresh_p0_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_intr_thresh_p0_addr_f_nc ;
cfg_ldb_cq_intcfg_t rw_ldb_cq_intr_thresh_p0_data_f_nc ;
logic rw_ldb_cq_intr_thresh_p1_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_intr_thresh_p1_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_intr_thresh_p1_addr_f_nc ;
cfg_ldb_cq_intcfg_t rw_ldb_cq_intr_thresh_p1_data_f_nc ;
logic rw_ldb_cq_intr_thresh_p2_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_intr_thresh_p2_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_intr_thresh_p2_addr_f_nc ;
logic rw_ldb_cq_intr_thresh_p3_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_intr_thresh_p3_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_intr_thresh_p3_addr_f_nc ;
cfg_ldb_cq_intcfg_t rw_ldb_cq_intr_thresh_p3_data_f_nc ;

logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] func_ldb_cq_intr_thresh_addr ;
assign func_ldb_cq_intr_thresh_raddr = func_ldb_cq_intr_thresh_addr ;
assign func_ldb_cq_intr_thresh_waddr = func_ldb_cq_intr_thresh_addr ;
hqm_AW_rw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_LB_CQ )
 , .WIDTH                             ( $bits ( func_ldb_cq_intr_thresh_wdata ) )
) i_rw_ldb_cq_intr_thresh (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_ldb_cq_intr_thresh_status_nc )
 , .p0_v_nxt                          ( rw_ldb_cq_intr_thresh_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_ldb_cq_intr_thresh_p0_rw_nxt )
 , .p0_addr_nxt                       ( rw_ldb_cq_intr_thresh_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_ldb_cq_intr_thresh_p0_v_f_nc )
 , .p0_rw_f                           ( rw_ldb_cq_intr_thresh_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_ldb_cq_intr_thresh_p0_addr_f_nc )
 , .p0_data_f                         ( rw_ldb_cq_intr_thresh_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_ldb_cq_intr_thresh_p1_v_f_nc )
 , .p1_rw_f                           ( rw_ldb_cq_intr_thresh_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_ldb_cq_intr_thresh_p1_addr_f_nc )
 , .p1_data_f                         ( rw_ldb_cq_intr_thresh_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_ldb_cq_intr_thresh_p2_v_f_nc )
 , .p2_rw_f                           ( rw_ldb_cq_intr_thresh_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_ldb_cq_intr_thresh_p2_addr_f_nc )
 , .p2_data_f                         ( rw_ldb_cq_intr_thresh_p2_data_f )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_ldb_cq_intr_thresh_p3_v_f_nc )
 , .p3_rw_f                           ( rw_ldb_cq_intr_thresh_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_ldb_cq_intr_thresh_p3_addr_f_nc )
 , .p3_data_f                         ( rw_ldb_cq_intr_thresh_p3_data_f_nc )
 , .mem_write                         ( func_ldb_cq_intr_thresh_we )
 , .mem_read                          ( func_ldb_cq_intr_thresh_re )
 , .mem_addr                          ( func_ldb_cq_intr_thresh_addr )
 , .mem_write_data                    ( func_ldb_cq_intr_thresh_wdata )
 , .mem_read_data                     ( func_ldb_cq_intr_thresh_rdata )
) ;

logic rw_dir_cq_intr_thresh_p0_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_intr_thresh_p0_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_intr_thresh_p0_addr_f_nc ;
cfg_dir_cq_intcfg_t rw_dir_cq_intr_thresh_p0_data_f_nc ;
logic rw_dir_cq_intr_thresh_p1_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_intr_thresh_p1_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_intr_thresh_p1_addr_f_nc ;
cfg_dir_cq_intcfg_t rw_dir_cq_intr_thresh_p1_data_f_nc ;
logic rw_dir_cq_intr_thresh_p2_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_intr_thresh_p2_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_intr_thresh_p2_addr_f_nc ;
logic rw_dir_cq_intr_thresh_p3_v_f_nc ;
aw_rwpipe_cmd_t rw_dir_cq_intr_thresh_p3_rw_f_nc ;
logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] rw_dir_cq_intr_thresh_p3_addr_f_nc ;
cfg_dir_cq_intcfg_t rw_dir_cq_intr_thresh_p3_data_f_nc ;

logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] func_dir_cq_intr_thresh_addr ;
assign func_dir_cq_intr_thresh_raddr = func_dir_cq_intr_thresh_addr ;
assign func_dir_cq_intr_thresh_waddr = func_dir_cq_intr_thresh_addr ;
hqm_AW_rw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_DIR_CQ )
 , .WIDTH                             ( $bits ( func_dir_cq_intr_thresh_wdata ) )
) i_rw_dir_cq_int_thresh (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( rw_dir_cq_intr_thresh_status_nc )
 , .p0_v_nxt                          ( rw_dir_cq_intr_thresh_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_dir_cq_intr_thresh_p0_rw_nxt )
 , .p0_addr_nxt                       ( rw_dir_cq_intr_thresh_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_dir_cq_intr_thresh_p0_v_f_nc )
 , .p0_rw_f                           ( rw_dir_cq_intr_thresh_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_dir_cq_intr_thresh_p0_addr_f_nc )
 , .p0_data_f                         ( rw_dir_cq_intr_thresh_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_dir_cq_intr_thresh_p1_v_f_nc )
 , .p1_rw_f                           ( rw_dir_cq_intr_thresh_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_dir_cq_intr_thresh_p1_addr_f_nc )
 , .p1_data_f                         ( rw_dir_cq_intr_thresh_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_dir_cq_intr_thresh_p2_v_f_nc )
 , .p2_rw_f                           ( rw_dir_cq_intr_thresh_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_dir_cq_intr_thresh_p2_addr_f_nc )
 , .p2_data_f                         ( rw_dir_cq_intr_thresh_p2_data_f )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_dir_cq_intr_thresh_p3_v_f_nc )
 , .p3_rw_f                           ( rw_dir_cq_intr_thresh_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_dir_cq_intr_thresh_p3_addr_f_nc )
 , .p3_data_f                         ( rw_dir_cq_intr_thresh_p3_data_f_nc )
 , .mem_write                         ( func_dir_cq_intr_thresh_we )
 , .mem_read                          ( func_dir_cq_intr_thresh_re )
 , .mem_addr                          ( func_dir_cq_intr_thresh_addr )
 , .mem_write_data                    ( func_dir_cq_intr_thresh_wdata )
 , .mem_read_data                     ( func_dir_cq_intr_thresh_rdata )
) ;

logic rw_cmp_id_chk_enbl_mem_p0_v_f_nc ;
aw_rwpipe_cmd_t rw_cmp_id_chk_enbl_mem_p0_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_cmp_id_chk_enbl_mem_p0_addr_f_nc ;
logic [1:0]rw_cmp_id_chk_enbl_mem_p0_data_f_nc ;
logic rw_cmp_id_chk_enbl_mem_p1_v_f_nc ;
aw_rwpipe_cmd_t rw_cmp_id_chk_enbl_mem_p1_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_cmp_id_chk_enbl_mem_p1_addr_f_nc ;
logic [1:0] rw_cmp_id_chk_enbl_mem_p1_data_f_nc ;
logic rw_cmp_id_chk_enbl_mem_p2_v_f_nc ;
aw_rwpipe_cmd_t rw_cmp_id_chk_enbl_mem_p2_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_cmp_id_chk_enbl_mem_p2_addr_f_nc ;
logic rw_cmp_id_chk_enbl_mem_p3_v_f_nc ;
aw_rwpipe_cmd_t rw_cmp_id_chk_enbl_mem_p3_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_cmp_id_chk_enbl_mem_p3_addr_f_nc ;
logic [1:0] rw_cmp_id_chk_enbl_mem_p3_data_f_nc ;

logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] func_cmp_id_chk_enbl_mem_addr ;
assign func_cmp_id_chk_enbl_mem_raddr = func_cmp_id_chk_enbl_mem_addr ;
assign func_cmp_id_chk_enbl_mem_waddr = func_cmp_id_chk_enbl_mem_addr ;
hqm_AW_rw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_LB_CQ )
 , .WIDTH                             ( $bits ( rw_cmp_id_chk_enbl_mem_p2_data_f ) )
) i_rw_cmp_id_chk_enbl_mem (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( dir_cq_wp_mem_pipe_status_nc )
 , .p0_v_nxt                          ( rw_cmp_id_chk_enbl_mem_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_cmp_id_chk_enbl_mem_p0_rw_nxt )
 , .p0_addr_nxt                       ( rw_cmp_id_chk_enbl_mem_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_cmp_id_chk_enbl_mem_p0_v_f_nc )
 , .p0_rw_f                           ( rw_cmp_id_chk_enbl_mem_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_cmp_id_chk_enbl_mem_p0_addr_f_nc )
 , .p0_data_f                         ( rw_cmp_id_chk_enbl_mem_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_cmp_id_chk_enbl_mem_p1_v_f_nc )
 , .p1_rw_f                           ( rw_cmp_id_chk_enbl_mem_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_cmp_id_chk_enbl_mem_p1_addr_f_nc )
 , .p1_data_f                         ( rw_cmp_id_chk_enbl_mem_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_cmp_id_chk_enbl_mem_p2_v_f_nc )
 , .p2_rw_f                           ( rw_cmp_id_chk_enbl_mem_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_cmp_id_chk_enbl_mem_p2_addr_f_nc )
 , .p2_data_f                         ( rw_cmp_id_chk_enbl_mem_p2_data_f )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_cmp_id_chk_enbl_mem_p3_v_f_nc )
 , .p3_rw_f                           ( rw_cmp_id_chk_enbl_mem_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_cmp_id_chk_enbl_mem_p3_addr_f_nc )
 , .p3_data_f                         ( rw_cmp_id_chk_enbl_mem_p3_data_f_nc )
 , .mem_write                         ( func_cmp_id_chk_enbl_mem_we )
 , .mem_addr                          ( func_cmp_id_chk_enbl_mem_addr )
 , .mem_write_data                    ( func_cmp_id_chk_enbl_mem_wdata )
 , .mem_read                          ( func_cmp_id_chk_enbl_mem_re )
 , .mem_read_data                     ( func_cmp_id_chk_enbl_mem_rdata )
) ;

assign fifo_chp_rop_hcw_of = fifo_chp_rop_hcw_status [ 1 ] ;
assign fifo_chp_rop_hcw_uf = fifo_chp_rop_hcw_status [ 0 ] ;
hqm_AW_fifo_control_wreg # (
    .DEPTH       ( HQM_CHP_ROP_HCW_FIFO_DEPTH )
  , .DWIDTH      ( $bits ( chp_rop_hcw_t ) )
  ) i_chp_rop_hcw_req_fifo (
    .clk                              ( hqm_gated_clk )
  , .rst_n                            ( hqm_gated_rst_n )
  , .cfg_high_wm                      ( HQM_CHP_ROP_HCW_FIFO_DEPTH [ 4 : 0 ] )
  , .fifo_status                      ( fifo_chp_rop_hcw_status )
  , .push                             ( fifo_chp_rop_hcw_push )
  , .push_data                        ( fifo_chp_rop_hcw_push_data )
  , .pop                              ( fifo_chp_rop_hcw_pop )
  , .pop_data                         ( fifo_chp_rop_hcw_pop_data )
  , .fifo_full                        ( fifo_chp_rop_hcw_full_nc )
  , .fifo_afull                       ( fifo_chp_rop_hcw_afull_nc )
  , .pop_data_v                       ( fifo_chp_rop_hcw_pop_data_v )
  , .mem_we                           ( func_chp_chp_rop_hcw_fifo_mem_we )
  , .mem_waddr                        ( func_chp_chp_rop_hcw_fifo_mem_waddr )
  , .mem_wdata                        ( func_chp_chp_rop_hcw_fifo_mem_wdata )
  , .mem_re                           ( func_chp_chp_rop_hcw_fifo_mem_re )
  , .mem_raddr                        ( func_chp_chp_rop_hcw_fifo_mem_raddr )
  , .mem_rdata                        ( func_chp_chp_rop_hcw_fifo_mem_rdata )
) ;

assign fifo_chp_lsp_tok_of = fifo_chp_lsp_tok_status [ 1 ] ;
assign fifo_chp_lsp_tok_uf = fifo_chp_lsp_tok_status [ 0 ] ;
hqm_AW_fifo_control_wreg # (
    .DEPTH       ( HQM_CHP_LSP_TOK_FIFO_DEPTH )
  , .DWIDTH      ( $bits ( chp_lsp_token_t ) )
  ) i_fifo_chp_lsp_tok (
    .clk                              ( hqm_gated_clk )
  , .rst_n                            ( hqm_gated_rst_n )
  , .cfg_high_wm                      ( HQM_CHP_LSP_TOK_FIFO_DEPTH [ 4 : 0 ] )
  , .fifo_status                      ( fifo_chp_lsp_tok_status )
  , .push                             ( fifo_chp_lsp_tok_push )
  , .push_data                        ( fifo_chp_lsp_tok_push_data )
  , .pop                              ( fifo_chp_lsp_tok_pop )
  , .pop_data                         ( fifo_chp_lsp_tok_pop_data )
  , .fifo_full                        ( fifo_chp_lsp_tok_full_nc )
  , .fifo_afull                       ( fifo_chp_lsp_tok_afull_nc )
  , .pop_data_v                       ( fifo_chp_lsp_tok_pop_data_v )
  , .mem_we                           ( func_chp_lsp_tok_fifo_mem_we )
  , .mem_waddr                        ( func_chp_lsp_tok_fifo_mem_waddr )
  , .mem_wdata                        ( func_chp_lsp_tok_fifo_mem_wdata )
  , .mem_re                           ( func_chp_lsp_tok_fifo_mem_re )
  , .mem_raddr                        ( func_chp_lsp_tok_fifo_mem_raddr )
  , .mem_rdata                        ( func_chp_lsp_tok_fifo_mem_rdata )
) ;

assign fifo_chp_lsp_ap_cmp_of = fifo_chp_lsp_ap_cmp_status [ 1 ] ;
assign fifo_chp_lsp_ap_cmp_uf = fifo_chp_lsp_ap_cmp_status [ 0 ] ;
hqm_AW_fifo_control_wreg # (
    .DEPTH       ( HQM_CHP_LSP_AP_CMP_FIFO_DEPTH )
  , .DWIDTH      ( $bits ( fifo_chp_lsp_ap_cmp_t ) )
  ) i_fifo_chp_lsp_ap_cmp (
    .clk                              ( hqm_gated_clk )
  , .rst_n                            ( hqm_gated_rst_n )
  , .cfg_high_wm                      ( HQM_CHP_LSP_AP_CMP_FIFO_DEPTH [ 4 : 0 ] )
  , .fifo_status                      ( fifo_chp_lsp_ap_cmp_status )
  , .push                             ( fifo_chp_lsp_ap_cmp_push )
  , .push_data                        ( fifo_chp_lsp_ap_cmp_push_data )
  , .pop                              ( fifo_chp_lsp_ap_cmp_pop )
  , .pop_data                         ( fifo_chp_lsp_ap_cmp_pop_data )
  , .fifo_full                        ( fifo_chp_lsp_ap_cmp_full_nc )
  , .fifo_afull                       ( fifo_chp_lsp_ap_cmp_afull_nc )
  , .pop_data_v                       ( fifo_chp_lsp_ap_cmp_pop_data_v )
  , .mem_we                           ( func_chp_lsp_ap_cmp_fifo_mem_we )
  , .mem_waddr                        ( func_chp_lsp_ap_cmp_fifo_mem_waddr )
  , .mem_wdata                        ( func_chp_lsp_ap_cmp_fifo_mem_wdata )
  , .mem_re                           ( func_chp_lsp_ap_cmp_fifo_mem_re )
  , .mem_raddr                        ( func_chp_lsp_ap_cmp_fifo_mem_raddr )
  , .mem_rdata                        ( func_chp_lsp_ap_cmp_fifo_mem_rdata )
) ;

assign fifo_outbound_hcw_of = fifo_outbound_hcw_status [ 1 ] ;
assign fifo_outbound_hcw_uf = fifo_outbound_hcw_status [ 0 ] ;
hqm_AW_fifo_control_wreg # (
    .DEPTH       ( HQM_CHP_OUTBOUND_HCW_FIFO_DEPTH )
  , .DWIDTH      ( $bits ( outbound_hcw_fifo_t ) )
  ) i_fifo_outbound_hcw (
    .clk                              ( hqm_gated_clk )
  , .rst_n                            ( hqm_gated_rst_n )
  , .cfg_high_wm                      ( HQM_CHP_OUTBOUND_HCW_FIFO_DEPTH [ 4 : 0 ] )
  , .fifo_status                      ( fifo_outbound_hcw_status )
  , .push                             ( fifo_outbound_hcw_push )
  , .push_data                        ( fifo_outbound_hcw_push_data )
  , .pop                              ( fifo_outbound_hcw_pop )
  , .pop_data                         ( fifo_outbound_hcw_pop_data )
  , .fifo_full                        ( fifo_outbound_hcw_full_nc )
  , .fifo_afull                       ( fifo_outbound_hcw_afull_nc )
  , .pop_data_v                       ( fifo_outbound_hcw_pop_data_v )
  , .mem_we                           ( func_outbound_hcw_fifo_mem_we )
  , .mem_waddr                        ( func_outbound_hcw_fifo_mem_waddr )
  , .mem_wdata                        ( func_outbound_hcw_fifo_mem_wdata )
  , .mem_re                           ( func_outbound_hcw_fifo_mem_re )
  , .mem_raddr                        ( func_outbound_hcw_fifo_mem_raddr )
  , .mem_rdata                        ( func_outbound_hcw_fifo_mem_rdata )
) ;

assign fifo_chp_sys_tx_fifo_mem_of = fifo_chp_sys_tx_fifo_mem_status [ 1 ] ;
assign fifo_chp_sys_tx_fifo_mem_uf = fifo_chp_sys_tx_fifo_mem_status [ 0 ] ;
hqm_AW_fifo_control_wreg # (
    .DEPTH       ( 8 )
  , .DWIDTH      ( 200 )
  ) i_chp_sys_tx_fifo_mem (
    .clk                              ( hqm_gated_clk )
  , .rst_n                            ( hqm_gated_rst_n )
  , .cfg_high_wm                      ( 4'd8 )
  , .fifo_status                      ( fifo_chp_sys_tx_fifo_mem_status )
  , .push                             ( fifo_chp_sys_tx_fifo_mem_push )
  , .push_data                        ( fifo_chp_sys_tx_fifo_mem_push_data )
  , .pop                              ( fifo_chp_sys_tx_fifo_mem_pop )
  , .pop_data                         ( fifo_chp_sys_tx_fifo_mem_pop_data )
  , .fifo_full                        ( fifo_chp_sys_tx_fifo_mem_full_nc )
  , .fifo_afull                       ( fifo_chp_sys_tx_fifo_mem_afull_nc )
  , .pop_data_v                       ( fifo_chp_sys_tx_fifo_mem_pop_data_v )
  , .mem_we                           ( func_chp_sys_tx_fifo_mem_we )
  , .mem_waddr                        ( func_chp_sys_tx_fifo_mem_waddr )
  , .mem_wdata                        ( func_chp_sys_tx_fifo_mem_wdata )
  , .mem_re                           ( func_chp_sys_tx_fifo_mem_re )
  , .mem_raddr                        ( func_chp_sys_tx_fifo_mem_raddr )
  , .mem_rdata                        ( func_chp_sys_tx_fifo_mem_rdata )
) ;

//for PF reset

hqm_AW_sync_rst0 i_hqm_AW_sync_rst0_enb (
  .clk                                ( hqm_inp_gated_clk )
, .rst_n                              ( hqm_inp_gated_rst_n )
, .data                               ( wd_clkreq )
, .data_sync                          ( wd_clkreq_sync2inp )
);
assign wd_clkreq_sync2inp_inv = ~ wd_clkreq_sync2inp ;
////////////////////////////////////////////////////////////////////////////////////////////////////
always_comb begin

  //....................................................................................................
  // sidecar CFG
  //   control unit CFG registers
  //     reset status register (cfg accesible)
  //     default to init RAM
  //     check for pipe idle & stop processing


   //aggregate errors into common functions as needed
   ram_access_error = sr_hist_list_error 
| rf_qed_chp_sch_flid_ret_rx_sync_mem_error
| rf_count_rmw_pipe_wd_ldb_mem_error 
| rf_ldb_cq_token_depth_select_error 
| rf_dir_cq_intr_thresh_error 
| rf_threshold_r_pipe_ldb_mem_error 
| rf_ldb_cq_depth_error 
| rf_outbound_hcw_fifo_mem_error 
| rf_threshold_r_pipe_dir_mem_error 
| rf_count_rmw_pipe_wd_dir_mem_error 
| rf_dir_cq_depth_error 
| rf_hist_list_ptr_error 
| rf_dir_cq_wptr_error 
| rf_chp_chp_rop_hcw_fifo_mem_error 
| rf_qed_chp_sch_rx_sync_mem_error 
| rf_cmp_id_chk_enbl_mem_error 
| rf_qed_to_cq_fifo_mem_error 
| rf_chp_lsp_tok_fifo_mem_error 
| rf_hist_list_minmax_error 
| rf_count_rmw_pipe_dir_mem_error 
| rf_dir_cq_token_depth_select_error 
| rf_ord_qid_sn_map_error 
| rf_chp_lsp_ap_cmp_fifo_mem_error 
| rf_ldb_cq_wptr_error 
| rf_ldb_cq_intr_thresh_error 
| rf_count_rmw_pipe_ldb_mem_error 
| rf_aqed_chp_sch_rx_sync_mem_error 
| rf_ord_qid_sn_error
| rf_chp_sys_tx_fifo_mem_error
| rf_hcw_enq_w_rx_sync_mem_error ;




   //--------------------------------------------------------------------------------------------------
   //control registers
   hqm_chp_target_cfg_chp_csr_control_reg_v                = 1'b0 ; 
   hqm_chp_target_cfg_chp_csr_control_reg_nxt              = hqm_chp_target_cfg_chp_csr_control_reg_f ; // used for syndrome & interrupt
   hqm_chp_target_cfg_patch_control_reg_v                  = 1'b0 ;
   hqm_chp_target_cfg_patch_control_reg_nxt                = hqm_chp_target_cfg_patch_control_reg_f ; // used for clock control

   hqm_chp_target_cfg_dir_cq_int_mask_reg_load = 1'b0 ;
   hqm_chp_target_cfg_dir_cq_int_mask_reg_nxt = hqm_chp_target_cfg_dir_cq_int_mask_reg_f ;
   hqm_chp_target_cfg_ldb_cq_int_mask_reg_load = 1'b0 ;
   hqm_chp_target_cfg_ldb_cq_int_mask_reg_nxt = hqm_chp_target_cfg_ldb_cq_int_mask_reg_f ;

   hqm_chp_target_cfg_dir_cq_irq_pending_reg_load = 1'b1 ;
   hqm_chp_target_cfg_dir_cq_irq_pending_reg_nxt = 'h0 ; 
   hqm_chp_target_cfg_dir_cq_irq_pending_reg_f_nc = hqm_chp_target_cfg_dir_cq_irq_pending_reg_f ;
   hqm_chp_target_cfg_ldb_cq_irq_pending_reg_load = 1'b1 ;
   hqm_chp_target_cfg_ldb_cq_irq_pending_reg_nxt = 'h0 ;
   hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f_nc = hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f ;

   hqm_chp_target_cfg_dir_cq_int_enb_reg_load = 1'b0 ;
   hqm_chp_target_cfg_dir_cq_wd_enb_reg_load = 1'b0 ;
   hqm_chp_target_cfg_ldb_cq_int_enb_reg_load = 1'b0 ;
   hqm_chp_target_cfg_ldb_cq_wd_enb_reg_load = 1'b0 ;
   hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_v               = 1'b0 ; 
   hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_nxt             = hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f ; //for CIAL
   hqm_chp_target_cfg_dir_cq_timer_ctl_reg_v               = 1'b0 ;
   hqm_chp_target_cfg_dir_cq_timer_ctl_reg_nxt             = hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f ; //for CIAL
   hqm_chp_target_cfg_dir_cq_int_enb_reg_nxt               = hqm_chp_target_cfg_dir_cq_int_enb_reg_f ; //for CIAL
   hqm_chp_target_cfg_ldb_cq_int_enb_reg_nxt               = hqm_chp_target_cfg_ldb_cq_int_enb_reg_f ; //for CIAL

   hqm_chp_target_cfg_hw_agitate_control_reg_v             = 1'b0 ; 
   hqm_chp_target_cfg_hw_agitate_control_reg_nxt           = hqm_chp_target_cfg_hw_agitate_control_reg_f ; // for agitate
   hqm_chp_target_cfg_hw_agitate_select_reg_v              = 1'b0 ; 
   hqm_chp_target_cfg_hw_agitate_select_reg_nxt            = hqm_chp_target_cfg_hw_agitate_select_reg_f; // for agitate

   hqm_chp_target_cfg_control_general_00_reg_v             = 1'b0 ;
   hqm_chp_target_cfg_control_general_00_reg_nxt           = hqm_chp_target_cfg_control_general_00_reg_f ; // credits 0x08884210
   hqm_chp_target_cfg_control_general_01_reg_v             = 1'b0 ;
   hqm_chp_target_cfg_control_general_01_reg_nxt           = hqm_chp_target_cfg_control_general_01_reg_f ; // control 0x0000001a
   hqm_chp_target_cfg_control_general_02_reg_v             = 1'b0 ;
   hqm_chp_target_cfg_control_general_02_reg_nxt           = hqm_chp_target_cfg_control_general_02_reg_f ;

   hqm_chp_target_cfg_dir_cq2vas_reg_load = 1'b0 ;
   hqm_chp_target_cfg_ldb_cq2vas_reg_load = 1'b0 ;
   hqm_chp_target_cfg_dir_cq2vas_reg_nxt                   = hqm_chp_target_cfg_dir_cq2vas_reg_f ; // for register RAM
   hqm_chp_target_cfg_ldb_cq2vas_reg_nxt                   = hqm_chp_target_cfg_ldb_cq2vas_reg_f ; // for register RAM

   hqm_chp_target_cfg_hist_list_mode_reg_load = 1'b0 ;
   hqm_chp_target_cfg_hist_list_mode_reg_nxt = hqm_chp_target_cfg_hist_list_mode_reg_f ;

   hqm_chp_target_cfg_chp_palb_control_reg_v = 1'b0 ;
   hqm_chp_target_cfg_chp_palb_control_reg_nxt = hqm_chp_target_cfg_chp_palb_control_reg_f ;

   //sub-module control bit assignment
   egress_wbo_error_inject_3                = hqm_chp_target_cfg_control_general_02_reg_f [ 22 ] & ~ egress_wbo_error_inject_3_done_f ;
   egress_wbo_error_inject_2                = hqm_chp_target_cfg_control_general_02_reg_f [ 21 ] & ~ egress_wbo_error_inject_2_done_f ;
   egress_wbo_error_inject_1                = hqm_chp_target_cfg_control_general_02_reg_f [ 20 ] & ~ egress_wbo_error_inject_1_done_f ;
   egress_wbo_error_inject_0                = hqm_chp_target_cfg_control_general_02_reg_f [ 19 ] & ~ egress_wbo_error_inject_0_done_f ;
   enqpipe_flid_parity_error_inject         = hqm_chp_target_cfg_control_general_02_reg_f [ 18 ] & ~ enqpipe_flid_parity_error_inject_done_f ;
   ingress_flid_parity_error_inject_1       = hqm_chp_target_cfg_control_general_02_reg_f [ 17 ] & ~ ingress_flid_parity_error_inject_1_done_f ;
   ingress_flid_parity_error_inject_0       = hqm_chp_target_cfg_control_general_02_reg_f [ 16 ] & ~ ingress_flid_parity_error_inject_0_done_f ;
   ingress_error_inject_h1                  = hqm_chp_target_cfg_control_general_02_reg_f [ 15 ] & ~ ingress_error_inject_h1_done_f ;
   ingress_error_inject_l1                  = hqm_chp_target_cfg_control_general_02_reg_f [ 14 ] & ~ ingress_error_inject_l1_done_f ;
   ingress_error_inject_h0                  = hqm_chp_target_cfg_control_general_02_reg_f [ 13 ] & ~ ingress_error_inject_h0_done_f ;
   ingress_error_inject_l0                  = hqm_chp_target_cfg_control_general_02_reg_f [ 12 ] & ~ ingress_error_inject_l0_done_f ;
   egress_error_inject_h1                   = hqm_chp_target_cfg_control_general_02_reg_f [ 11 ] & ~ egress_error_inject_h1_done_f ;
   egress_error_inject_l1                   = hqm_chp_target_cfg_control_general_02_reg_f [ 10 ] & ~ egress_error_inject_l1_done_f ;
   egress_error_inject_h0                   = hqm_chp_target_cfg_control_general_02_reg_f [ 9 ] & ~ egress_error_inject_h0_done_f ;
   egress_error_inject_l0                   = hqm_chp_target_cfg_control_general_02_reg_f [ 8 ] & ~ egress_error_inject_l0_done_f ;
   schpipe_error_inject_h1                  = hqm_chp_target_cfg_control_general_02_reg_f [ 7 ] & ~ schpipe_error_inject_h1_done_f ;
   schpipe_error_inject_l1                  = hqm_chp_target_cfg_control_general_02_reg_f [ 6 ] & ~ schpipe_error_inject_l1_done_f ;
   schpipe_error_inject_h0                  = hqm_chp_target_cfg_control_general_02_reg_f [ 5 ] & ~ schpipe_error_inject_h0_done_f ;
   schpipe_error_inject_l0                  = hqm_chp_target_cfg_control_general_02_reg_f [ 4 ] & ~ schpipe_error_inject_l0_done_f ;
   enqpipe_error_inject_h1                  = hqm_chp_target_cfg_control_general_02_reg_f [ 3 ] & ~ enqpipe_error_inject_h1_done_f ;
   enqpipe_error_inject_l1                  = hqm_chp_target_cfg_control_general_02_reg_f [ 2 ] & ~ enqpipe_error_inject_l1_done_f ;
   enqpipe_error_inject_h0                  = hqm_chp_target_cfg_control_general_02_reg_f [ 1 ] & ~ enqpipe_error_inject_h0_done_f ;
   enqpipe_error_inject_l0                  = hqm_chp_target_cfg_control_general_02_reg_f [ 0 ] & ~ enqpipe_error_inject_l0_done_f ;

   cfg_cial_clock_gate_control              = hqm_chp_target_cfg_control_general_01_reg_f [ 3 ] ;
   idle_cial_timer_report_control           = 1'b1 ;
   idle_cwdi_timer_report_control           = hqm_chp_target_cfg_control_general_01_reg_f [ 1 ] ;
   cfg_chp_blk_dual_issue                   = hqm_chp_target_cfg_control_general_01_reg_f [ 0 ] ;       //Arb   : def = { 1'b0 }

   cfg_egress_lsp_token_pipecredits         = hqm_chp_target_cfg_control_general_00_reg_f [ 30 : 28 ] ; //Egress : def = { 3'd4 }
   cfg_qed_to_cq_pipe_credit_hwm            = hqm_chp_target_cfg_control_general_00_reg_f [ 27 : 24 ] ; //Ingress: def = { 4'd8 }
   cfg_egress_pipecredits                   = hqm_chp_target_cfg_control_general_00_reg_f [ 23 : 20 ] ; //Egress : def = { 4'd8 }
   cfg_chp_rop_pipe_credit_hwm              = hqm_chp_target_cfg_control_general_00_reg_f [ 19 : 15 ] ; //Arb    : def = { 5'd16 }
   cfg_chp_lsp_tok_pipe_credit_hwm          = hqm_chp_target_cfg_control_general_00_reg_f [ 14 : 10 ] ; //Arb    : def = { 5'd16 }
   cfg_chp_lsp_ap_cmp_pipe_credit_hwm       = hqm_chp_target_cfg_control_general_00_reg_f [ 9 : 5 ] ;   //Arb    : def = { 5'd16 }
   cfg_chp_outbound_hcw_pipe_credit_hwm     = hqm_chp_target_cfg_control_general_00_reg_f [ 4 : 0 ] ;   //Arb    : def = { 5'd16 }

   schpipe_hqm_chp_target_cfg_hist_list_mode    = hqm_chp_target_cfg_hist_list_mode_reg_f ;
   enqpipe_hqm_chp_target_cfg_hist_list_mode    = hqm_chp_target_cfg_hist_list_mode_reg_f ;


   //--------------------------------------------------------------------------------------------------
   //unit idle register
   cfg_unit_idle_reg_nxt                    = cfg_unit_idle_reg_f ;
   chp_reset_done                           = ~ ( hqm_gated_rst_n_active ) & ldb_hw_pgcb_init_done & dir_hw_pgcb_init_done ;
   chp_unit_pipeidle                        = cfg_unit_idle_reg_f.pipe_idle ;
   cfg_unit_idle_reg_nxt.pipe_idle          = (
                                                ( ing_pipe_idle )
                                              & ( egress_pipe_idle )
                                              & ( arb_pipe_idle )
                                              & ( enqpipe_pipe_idle )
                                              & ( schpipe_pipe_idle )
                                              & ( freelist_status_idle )
                                              & ( sr_freelist_we_nxt == 4'h0 )
                                              ) ;
   cfg_unit_idle_reg_nxt.unit_idle          = ( ( cfg_unit_idle_reg_nxt.pipe_idle )

                                                // submodule unit idle
                                              & ( ing_unit_idle )
                                              & ( egress_unit_idle )
                                              & ( arb_unit_idle )
                                              & ( enqpipe_unit_idle )
                                              & ( schpipe_unit_idle )
                                              & ( chp_lsp_token_qb_status [ 2 : 0 ] == 3'd0 )

                                                // TX & RX idle
                                              & ( chp_rop_hcw_tx_sync_idle )
                                              & ( chp_lsp_token_tx_sync_idle )
                                              & ( chp_lsp_cmp_tx_sync_idle )
                                              & ( cial_tx_sync_idle )
                                              & ( wd_tx_sync_idle )
                                              & ( hcw_enq_w_rx_sync_idle )
                                              & ( qed_chp_sch_rx_sync_idle )
                                              & ( qed_chp_sch_flid_ret_rx_sync_idle )
                                              & ( aqed_chp_sch_rx_sync_idle )

                                                // WD & CIAL idle
                                              & ( hqm_chp_int_idle )
                                              & ( wd_irq_idle )

                                                // FIFO empty
                                              & ( ~ fifo_chp_lsp_ap_cmp_pop_data_v )
                                              & ( ~ fifo_chp_lsp_tok_pop_data_v )
                                              & ( ~ fifo_chp_rop_hcw_pop_data_v )
                                              & ( ~ fifo_chp_sys_tx_fifo_mem_pop_data_v )
                                              & ( ~ fifo_outbound_hcw_pop_data_v )

                                              ) ;

   chp_unit_idle_local                      = ( ( ~ hqm_gated_rst_n_active )
                                              & ( cfg_unit_idle_reg_nxt.unit_idle )
                                              ) ;

   chp_unit_idle                            = ( wire_chp_unit_idle
                                              & rop_unit_idle
                                              ) ;

   //--------------------------------------------------------------------------------------------------
   //status
   hqm_chp_target_cfg_pipe_health_valid_status             = { 27'd0
                                                             , ~ ing_pipe_idle
                                                             , ~ egress_pipe_idle
                                                             , ~ arb_pipe_idle
                                                             , ~ enqpipe_pipe_idle
                                                             , ~ schpipe_pipe_idle
                                                             } ;
   hqm_chp_target_cfg_pipe_health_hold_status              = { 31'd0
                                                             , ( fifo_outbound_hcw_pop_data_v & ~ fifo_outbound_hcw_pop )
                                                             } ;

   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 31 : 26 ]      = '0 ;
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 25 ]           = freelist_full ;
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 24 ]           = freelist_empty ;
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 23 ]           = fifo_chp_sys_tx_fifo_mem_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 22 ]           = fifo_chp_sys_tx_fifo_mem_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 21 ]           = fifo_chp_rop_hcw_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 20 ]           = fifo_chp_rop_hcw_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 19 ]           = fifo_chp_lsp_tok_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 18 ]           = fifo_chp_lsp_tok_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 17 ]           = fifo_chp_lsp_ap_cmp_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 16 ]           = fifo_chp_lsp_ap_cmp_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 15 ]           = fifo_outbound_hcw_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 14 ]           = fifo_outbound_hcw_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 13 ]           = hcw_enq_w_rx_sync_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 12 ]           = hcw_enq_w_rx_sync_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 11 ]           = 1'd0 ; 
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 10 ]           = 1'd0 ;
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 9 ]            = qed_chp_sch_flid_ret_rx_sync_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 8 ]            = qed_chp_sch_flid_ret_rx_sync_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 7 ]            = qed_chp_sch_rx_sync_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 6 ]            = qed_chp_sch_rx_sync_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 5 ]            = 1'd0 ;
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 4 ]            = 1'd0 ;
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 3 ]            = aqed_chp_sch_rx_sync_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 2 ]            = aqed_chp_sch_rx_sync_status [ 4 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 1 ]            = cfg_rx_fifo_status [ 6 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_00_reg_nxt [ 0 ]            = cfg_rx_fifo_status [ 4 ] ; //empty

   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 31 : 31 ]      =  ~ int_idle ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 30 : 30 ]      = 1'b0 ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 29 : 28 ]      = cial_tx_sync_status_pnc [ 1 : 0 ] ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 27 : 27 ]      = ~ rop_clk_idle ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 26 : 26 ]      = ~ hcw_enq_w_rx_sync_idle ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 25 : 25 ]      = 1'b0 ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 24 : 24 ]      = 1'b0 ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 23 : 23 ]      = ~ qed_chp_sch_rx_sync_idle ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 22 : 22 ]      = ~ qed_chp_sch_flid_ret_rx_sync_idle ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 21 : 21 ]      = ~ aqed_chp_sch_rx_sync_idle ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 20 : 20 ]      = ~ wd_clkreq_sync2inp_inv ;
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 19 : 18 ]      = chp_rop_hcw_tx_sync_status [ 1 : 0 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 17 : 16 ]      = chp_lsp_token_tx_sync_status [ 1 : 0 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 15 : 14 ]      = chp_lsp_cmp_tx_sync_status [ 1 : 0 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 13 : 12 ]      = egress_tx_sync_status [ 1 : 0 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 11 : 10 ]      = wd_tx_sync_status [ 1 : 0 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 9 : 8 ]        = atm_ord_db_status [ 1 : 0 ] ; //size 
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 7 : 6 ]        = hcw_replay_db_status [ 1 : 0 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 5 : 4 ]        = 2'd0 ; 
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 3 : 2 ]        = int_status [ 8 : 7 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_01_reg_nxt [ 1 : 0 ]        = int_status [ 1 : 0 ] ; //size

   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 31 : 17 ]      = freelist_size ;
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 16 : 14 ]      = chp_lsp_token_qb_status [ 2 : 0 ] ; //size
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 13 ]           = egress_lsp_token_credit_status [ 1 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 12 ]           = egress_lsp_token_credit_status [ 3 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 11 ]           = qed_to_cq_pipe_credit_status [ 1 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 10 ]           = qed_to_cq_pipe_credit_status [ 3 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 9 ]            = chp_rop_pipe_credit_status [ 1 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 8 ]            = chp_rop_pipe_credit_status [ 3 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 7 ]            = chp_lsp_tok_pipe_credit_status [ 1 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 6 ]            = chp_lsp_tok_pipe_credit_status [ 3 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 5 ]            = chp_lsp_ap_cmp_pipe_credit_status [ 1 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 4 ]            = chp_lsp_ap_cmp_pipe_credit_status [ 3 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 3 ]            = chp_outbound_hcw_pipe_credit_status [ 1 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 2 ]            = chp_outbound_hcw_pipe_credit_status [ 3 ] ; //empty
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 1 ]            = egress_credit_status [ 1 ] ; //afull
   hqm_chp_target_cfg_control_diagnostic_02_reg_nxt [ 0 ]            = egress_credit_status [ 3 ] ; //empty

   hqm_chp_target_cfg_diagnostic_aw_status_0_status        = '0 ;
//No reason to read RMW hold status since pipe cannot hold?
//logic hist_list_status ;
//logic ldb_vas_credit_count_mem_pipe_status ;
//logic dir_vas_credit_count_mem_pipe_status ;
//logic rw_ldb_cq_depth_mem_pipe_status ;
//logic rw_dir_cq_depth_mem_pipe_status ;
//logic rw_ldb_cq_wptr_mem_pipe_status ;
//logic rw_dir_cq_wptr_mem_pipe_status ;
//logic rw_ldb_cq_token_depth_select_status ;
//logic rw_dir_cq_token_depth_select_status ;
//logic rw_ldb_cq_intr_thresh_status ;
//logic rw_dir_cq_intr_thresh_status ;
//logic qed_sch_sn_mem_pipe_status ;
//logic qed_sch_sn_map_mem_pipe_status ;
//logic dir_cq_wp_mem_pipe_status ;

   hqm_chp_target_cfg_db_fifo_status_3_status                        = hqm_chp_int_tim_pipe_status_dir_pnc ;
   hqm_chp_target_cfg_db_fifo_status_2_status                        = hqm_chp_int_tim_pipe_status_ldb_pnc ;
   hqm_chp_target_cfg_db_fifo_status_1_status                        = hqm_chp_wd_dir_pipe_status_pnc ;
   hqm_chp_target_cfg_db_fifo_status_0_status                        = hqm_chp_wd_ldb_pipe_status_pnc ;

   //--------------------------------------------------------------------------------------------------
   //smon
   hqm_chp_target_cfg_chp_smon_disable_smon                = disable_smon ;
   hqm_chp_target_cfg_chp_smon_smon_v_nxt                  = { smon_thresh_irq_dir                        //CIAL     - 4 targets
                                                             , smon_thresh_irq_ldb
                                                             , smon_timer_irq_dir
                                                             , smon_timer_irq_ldb
                                                             , egress_hqm_chp_target_cfg_chp_smon_smon_v  //EGRESS   - 3 targets
                                                             , schpipe_hqm_chp_target_cfg_chp_smon_smon_v //SCHPIPE  - 1 target
                                                             , enqpipe_hqm_chp_target_cfg_chp_smon_smon_v //ENQPIPE  - 1 target
                                                             , arb_hqm_chp_target_cfg_chp_smon_smon_v     //ARB      - 3 targets
                                                             , ing_hqm_chp_target_cfg_chp_smon_smon_v     //INGRTESS - 4 targets
                                                             } ;
   hqm_chp_target_cfg_chp_smon_smon_comp_nxt               = { 32'd0
                                                             , 32'd0
                                                             , 32'd0
                                                             , 32'd0
                                                             , egress_hqm_chp_target_cfg_chp_smon_smon_comp
                                                             , schpipe_hqm_chp_target_cfg_chp_smon_smon_comp
                                                             , enqpipe_hqm_chp_target_cfg_chp_smon_smon_comp
                                                             , arb_hqm_chp_target_cfg_chp_smon_smon_comp
                                                             , ing_hqm_chp_target_cfg_chp_smon_smon_comp
                                                             } ;
   hqm_chp_target_cfg_chp_smon_smon_val_nxt                = { 32'd1
                                                             , 32'd1
                                                             , 32'd1
                                                             , 32'd1
                                                             , egress_hqm_chp_target_cfg_chp_smon_smon_val
                                                             , schpipe_hqm_chp_target_cfg_chp_smon_smon_val
                                                             , enqpipe_hqm_chp_target_cfg_chp_smon_smon_val
                                                             , arb_hqm_chp_target_cfg_chp_smon_smon_val
                                                             , ing_hqm_chp_target_cfg_chp_smon_smon_val
                                                             } ;
  hqm_chp_target_cfg_chp_smon_smon_v                       = hqm_chp_target_cfg_chp_smon_smon_v_f ;
  hqm_chp_target_cfg_chp_smon_smon_comp                    = hqm_chp_target_cfg_chp_smon_smon_comp_f ;
  hqm_chp_target_cfg_chp_smon_smon_val                     = hqm_chp_target_cfg_chp_smon_smon_val_f ;

   //--------------------------------------------------------------------------------------------------
   hqm_chp_target_cfg_retn_zero_status                     = '0 ; //CFG target to return zero status

   //--------------------------------------------------------------------------------------------------
   //64b counter control, all are enabled by default & cannot be cleared
   hqm_chp_target_cfg_chp_correctible_count_en           = 1'b1 ;
   hqm_chp_target_cfg_chp_correctible_count_clr          = '0 ;
   hqm_chp_target_cfg_chp_correctible_count_clrv         = '0 ;
   hqm_chp_target_cfg_counter_chp_error_drop_en            = 1'b1 ;
   hqm_chp_target_cfg_counter_chp_error_drop_clr           = '0 ;
   hqm_chp_target_cfg_counter_chp_error_drop_clrv          = '0 ;
   hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_en                  = 1'b1 ;
   hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clr                 = '0 ;
   hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clrv                = '0 ;
   hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_en                  = 1'b1 ;
   hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clr                 = '0 ;
   hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clrv                = '0 ;
   hqm_chp_target_cfg_chp_cnt_frag_replayed_en                  = 1'b1 ;
   hqm_chp_target_cfg_chp_cnt_frag_replayed_clr                 = '0 ;
   hqm_chp_target_cfg_chp_cnt_frag_replayed_clrv                = '0 ;
   hqm_chp_target_cfg_chp_cnt_dir_qe_sch_en                  = 1'b1 ;
   hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clr                 = '0 ;
   hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clrv                = '0 ;
   hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_en                  = 1'b1 ;
   hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clr                 = '0 ;
   hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clrv                = '0 ;
   hqm_chp_target_cfg_chp_cnt_atm_qe_sch_en                  = 1'b1 ;
   hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clr                 = '0 ;
   hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clrv                = '0 ;
   hqm_chp_target_cfg_chp_cnt_atq_to_atm_en                  = 1'b1 ;
   hqm_chp_target_cfg_chp_cnt_atq_to_atm_clr                 = '0 ;
   hqm_chp_target_cfg_chp_cnt_atq_to_atm_clrv                = '0 ;

   // connect vtune counters to measure efficiency of arbiter
   hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_inc                 = ( ( hcw_enq_pop & ~ hcw_enq_info.pp_is_ldb & ~ hcw_enq_info.qe_is_ldb & 
                                                                    ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ) |
                                                                  ( hcw_enq_pop & hcw_enq_info.pp_is_ldb & ~ hcw_enq_info.qe_is_ldb &
                                                                    ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ) 
                                                                ) ;
   hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_inc                 = ( ( hcw_enq_pop & ~ hcw_enq_info.pp_is_ldb & hcw_enq_info.qe_is_ldb & 
                                                                    ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ) |
                                                                  ( hcw_enq_pop & hcw_enq_info.pp_is_ldb & hcw_enq_info.qe_is_ldb &
                                                                    ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) | 
                                                                      ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ) 
                                                                ) ;
   hqm_chp_target_cfg_chp_cnt_frag_replayed_inc              = hcw_replay_pop ;
   hqm_chp_target_cfg_chp_cnt_dir_qe_sch_inc                 = ( qed_sch_pop & 
                                                                 ~ qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb &
                                                                 ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) ) ;
   hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_inc                 = ( qed_sch_pop & 
                                                                 qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb &
                                                                 ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) ) ;
   hqm_chp_target_cfg_chp_cnt_atm_qe_sch_inc                 = aqed_sch_pop ; 
   //--------------------------------------------------------------------------------------------------
   // PF reset
   reset_pf_counter_nxt = reset_pf_counter_f ;
   reset_pf_active_nxt = reset_pf_active_f ;
   reset_pf_done_nxt = reset_pf_done_f ;
   hw_init_done_nxt = hw_init_done_f ;

   pf_hist_list_re = '0 ;
   pf_hist_list_addr = '0 ;
   pf_hist_list_we = '0 ;
   pf_hist_list_wdata = '0 ;
   pf_hist_list_a_re = '0 ;
   pf_hist_list_a_addr = '0 ;
   pf_hist_list_a_we = '0 ;
   pf_hist_list_a_wdata = '0 ;
   //pf_count_rmw_pipe_wd_ldb_mem_re = '0 ;
   //pf_count_rmw_pipe_wd_ldb_mem_raddr = '0 ;
   //pf_count_rmw_pipe_wd_ldb_mem_waddr = '0 ;
   //pf_count_rmw_pipe_wd_ldb_mem_we = '0 ;
   //pf_count_rmw_pipe_wd_ldb_mem_wdata = '0 ;
   pf_ldb_cq_token_depth_select_re = '0 ;
   pf_ldb_cq_token_depth_select_raddr = '0 ;
   pf_ldb_cq_token_depth_select_waddr = '0 ;
   pf_ldb_cq_token_depth_select_we = '0 ;
   pf_ldb_cq_token_depth_select_wdata = '0 ;
   pf_dir_cq_intr_thresh_re = '0 ;
   pf_dir_cq_intr_thresh_raddr = '0 ;
   pf_dir_cq_intr_thresh_waddr = '0 ;
   pf_dir_cq_intr_thresh_we = '0 ;
   pf_dir_cq_intr_thresh_wdata = '0 ;
   pf_threshold_r_pipe_ldb_mem_re = '0 ;
   pf_threshold_r_pipe_ldb_mem_addr = '0 ;
   pf_threshold_r_pipe_ldb_mem_we = '0 ;
   pf_threshold_r_pipe_ldb_mem_wdata = '0 ;
   pf_ldb_cq_depth_re = '0 ;
   pf_ldb_cq_depth_raddr = '0 ;
   pf_ldb_cq_depth_waddr = '0 ;
   pf_ldb_cq_depth_we = '0 ;
   pf_ldb_cq_depth_wdata = '0 ;
   pf_outbound_hcw_fifo_mem_re = '0 ;
   pf_outbound_hcw_fifo_mem_raddr = '0 ;
   pf_outbound_hcw_fifo_mem_waddr = '0 ;
   pf_outbound_hcw_fifo_mem_we = '0 ;
   pf_outbound_hcw_fifo_mem_wdata = '0 ;
   pf_threshold_r_pipe_dir_mem_re = '0 ;
   pf_threshold_r_pipe_dir_mem_addr = '0 ;
   pf_threshold_r_pipe_dir_mem_we = '0 ;
   pf_threshold_r_pipe_dir_mem_wdata = '0 ;
   //pf_count_rmw_pipe_wd_dir_mem_re = '0 ;
   //pf_count_rmw_pipe_wd_dir_mem_raddr = '0 ;
   //pf_count_rmw_pipe_wd_dir_mem_waddr = '0 ;
   //pf_count_rmw_pipe_wd_dir_mem_we = '0 ;
   //pf_count_rmw_pipe_wd_dir_mem_wdata = '0 ;
   pf_dir_cq_depth_re = '0 ;
   pf_dir_cq_depth_raddr = '0 ;
   pf_dir_cq_depth_waddr = '0 ;
   pf_dir_cq_depth_we = '0 ;
   pf_dir_cq_depth_wdata = '0 ;
   pf_hist_list_ptr_re = '0 ;
   pf_hist_list_ptr_raddr = '0 ;
   pf_hist_list_ptr_waddr = '0 ;
   pf_hist_list_ptr_we = '0 ;
   pf_hist_list_ptr_wdata = '0 ;
   pf_hist_list_a_ptr_re = '0 ;
   pf_hist_list_a_ptr_raddr = '0 ;
   pf_hist_list_a_ptr_waddr = '0 ;
   pf_hist_list_a_ptr_we = '0 ;
   pf_hist_list_a_ptr_wdata = '0 ;
   pf_dir_cq_wptr_re = '0 ;
   pf_dir_cq_wptr_raddr = '0 ;
   pf_dir_cq_wptr_waddr = '0 ;
   pf_dir_cq_wptr_we = '0 ;
   pf_dir_cq_wptr_wdata = '0 ;
   pf_chp_chp_rop_hcw_fifo_mem_re = '0 ;
   pf_chp_chp_rop_hcw_fifo_mem_raddr = '0 ;
   pf_chp_chp_rop_hcw_fifo_mem_waddr = '0 ;
   pf_chp_chp_rop_hcw_fifo_mem_we = '0 ;
   pf_chp_chp_rop_hcw_fifo_mem_wdata = '0 ;
   pf_qed_chp_sch_rx_sync_mem_re = '0 ;
   pf_qed_chp_sch_rx_sync_mem_raddr = '0 ;
   pf_qed_chp_sch_rx_sync_mem_waddr = '0 ;
   pf_qed_chp_sch_rx_sync_mem_we = '0 ;
   pf_qed_chp_sch_rx_sync_mem_wdata = '0 ;
   pf_qed_chp_sch_flid_ret_rx_sync_mem_re = '0 ;
   pf_qed_chp_sch_flid_ret_rx_sync_mem_raddr = '0 ;
   pf_qed_chp_sch_flid_ret_rx_sync_mem_waddr = '0 ;
   pf_qed_chp_sch_flid_ret_rx_sync_mem_we = '0 ;
   pf_qed_chp_sch_flid_ret_rx_sync_mem_wdata = '0 ;
   pf_cmp_id_chk_enbl_mem_re = '0 ;
   pf_cmp_id_chk_enbl_mem_raddr = '0 ;
   pf_cmp_id_chk_enbl_mem_waddr = '0 ;
   pf_cmp_id_chk_enbl_mem_we = '0 ;
   pf_cmp_id_chk_enbl_mem_wdata = '0 ;
   pf_qed_to_cq_fifo_mem_re = '0 ;
   pf_qed_to_cq_fifo_mem_raddr = '0 ;
   pf_qed_to_cq_fifo_mem_waddr = '0 ;
   pf_qed_to_cq_fifo_mem_we = '0 ;
   pf_qed_to_cq_fifo_mem_wdata = '0 ;
   pf_hist_list_minmax_re = '0 ;
   pf_hist_list_minmax_addr = '0 ;
   pf_hist_list_minmax_we = '0 ;
   pf_hist_list_minmax_wdata = '0 ;
   pf_hist_list_a_minmax_re = '0 ;
   pf_hist_list_a_minmax_addr = '0 ;
   pf_hist_list_a_minmax_we = '0 ;
   pf_hist_list_a_minmax_wdata = '0 ;
   pf_count_rmw_pipe_dir_mem_re = '0 ;
   pf_count_rmw_pipe_dir_mem_raddr = '0 ;
   pf_count_rmw_pipe_dir_mem_waddr = '0 ;
   pf_count_rmw_pipe_dir_mem_we = '0 ;
   pf_count_rmw_pipe_dir_mem_wdata = '0 ;
   pf_dir_cq_token_depth_select_re = '0 ;
   pf_dir_cq_token_depth_select_raddr = '0 ;
   pf_dir_cq_token_depth_select_waddr = '0 ;
   pf_dir_cq_token_depth_select_we = '0 ;
   pf_dir_cq_token_depth_select_wdata = '0 ;
   pf_ord_qid_sn_map_re = '0 ;
   pf_ord_qid_sn_map_raddr = '0 ;
   pf_ord_qid_sn_map_waddr = '0 ;
   pf_ord_qid_sn_map_we = '0 ;
   pf_ord_qid_sn_map_wdata = '0 ;
   pf_chp_lsp_ap_cmp_fifo_mem_re = '0 ;
   pf_chp_lsp_ap_cmp_fifo_mem_raddr = '0 ;
   pf_chp_lsp_ap_cmp_fifo_mem_waddr = '0 ;
   pf_chp_lsp_ap_cmp_fifo_mem_we = '0 ;
   pf_chp_lsp_ap_cmp_fifo_mem_wdata = '0 ;
   pf_ldb_cq_wptr_re = '0 ;
   pf_ldb_cq_wptr_raddr = '0 ;
   pf_ldb_cq_wptr_waddr = '0 ;
   pf_ldb_cq_wptr_we = '0 ;
   pf_ldb_cq_wptr_wdata = '0 ;
   pf_ldb_cq_intr_thresh_re = '0 ;
   pf_ldb_cq_intr_thresh_raddr = '0 ;
   pf_ldb_cq_intr_thresh_waddr = '0 ;
   pf_ldb_cq_intr_thresh_we = '0 ;
   pf_ldb_cq_intr_thresh_wdata = '0 ;
   pf_count_rmw_pipe_ldb_mem_re = '0 ;
   pf_count_rmw_pipe_ldb_mem_raddr = '0 ;
   pf_count_rmw_pipe_ldb_mem_waddr = '0 ;
   pf_count_rmw_pipe_ldb_mem_we = '0 ;
   pf_count_rmw_pipe_ldb_mem_wdata = '0 ;
   pf_aqed_chp_sch_rx_sync_mem_re = '0 ;
   pf_aqed_chp_sch_rx_sync_mem_raddr = '0 ;
   pf_aqed_chp_sch_rx_sync_mem_waddr = '0 ;
   pf_aqed_chp_sch_rx_sync_mem_we = '0 ;
   pf_aqed_chp_sch_rx_sync_mem_wdata = '0 ;
   pf_ord_qid_sn_re = '0 ;
   pf_ord_qid_sn_raddr = '0 ;
   pf_ord_qid_sn_waddr = '0 ;
   pf_ord_qid_sn_we = '0 ;
   pf_ord_qid_sn_wdata = '0 ;
   pf_hcw_enq_w_rx_sync_mem_re = '0 ;
   pf_hcw_enq_w_rx_sync_mem_raddr = '0 ;
   pf_hcw_enq_w_rx_sync_mem_waddr = '0 ;
   pf_hcw_enq_w_rx_sync_mem_we = '0 ;
   pf_hcw_enq_w_rx_sync_mem_wdata = '0 ;
   pf_chp_lsp_tok_fifo_mem_re = '0 ;
   pf_chp_lsp_tok_fifo_mem_raddr = '0 ;
   pf_chp_lsp_tok_fifo_mem_waddr = '0 ;
   pf_chp_lsp_tok_fifo_mem_we = '0 ;
   pf_chp_lsp_tok_fifo_mem_wdata = '0 ;
   pf_chp_sys_tx_fifo_mem_re = '0 ;
   pf_chp_sys_tx_fifo_mem_raddr = '0 ;
   pf_chp_sys_tx_fifo_mem_waddr = '0 ;
   pf_chp_sys_tx_fifo_mem_we = '0 ;
   pf_chp_sys_tx_fifo_mem_wdata = '0 ;

   pf_freelist_0_re = '0 ;
   pf_freelist_0_addr = '0 ;
   pf_freelist_0_we = '0 ;
   pf_freelist_0_wdata = '0 ;

   pf_freelist_1_re = '0 ;
   pf_freelist_1_addr = '0 ;
   pf_freelist_1_we = '0 ;
   pf_freelist_1_wdata = '0 ;

   pf_freelist_2_re = '0 ;
   pf_freelist_2_addr = '0 ;
   pf_freelist_2_we = '0 ;
   pf_freelist_2_wdata = '0 ;

   pf_freelist_3_re = '0 ;
   pf_freelist_3_addr = '0 ;
   pf_freelist_3_we = '0 ;
   pf_freelist_3_wdata = '0 ;

   pf_freelist_4_re = '0 ;
   pf_freelist_4_addr = '0 ;
   pf_freelist_4_we = '0 ;
   pf_freelist_4_wdata = '0 ;

   pf_freelist_5_re = '0 ;
   pf_freelist_5_addr = '0 ;
   pf_freelist_5_we = '0 ;
   pf_freelist_5_wdata = '0 ;

   pf_freelist_6_re = '0 ;
   pf_freelist_6_addr = '0 ;
   pf_freelist_6_we = '0 ;
   pf_freelist_6_wdata = '0 ;

   pf_freelist_7_re = '0 ;
   pf_freelist_7_addr = '0 ;
   pf_freelist_7_we = '0 ;
   pf_freelist_7_wdata = '0 ;

   freelist_pf_push_v = freelist_pf_push_v_f ;
   freelist_pf_push_data = freelist_pf_push_data_f ;

   freelist_pf_push_v_nxt = 1'd0 ;
   freelist_pf_push_data_nxt = '0 ;

   pf_dir_cq_intr_thresh_re = '0 ;

   pf_ldb_cq_on_off_threshold_re = '0 ;
   pf_ldb_cq_on_off_threshold_raddr = '0 ;
   pf_ldb_cq_on_off_threshold_waddr = '0 ;
   pf_ldb_cq_on_off_threshold_we = '0 ;
   pf_ldb_cq_on_off_threshold_wdata = '0 ;

   if ( hqm_gated_rst_n_start & reset_pf_active_f & ~ hw_init_done_f ) begin
       reset_pf_counter_nxt                                = reset_pf_counter_f + 32'd1 ;
       if ( reset_pf_counter_f < HQM_CHP_RST_LOOP_PFMAX ) begin
            if ( reset_pf_counter_f < 2048 ) begin
            freelist_pf_push_v_nxt                         = ( reset_pf_counter_f < 2048 ) ;
            freelist_pf_push_data_nxt.flid                 = reset_pf_counter_f [ ( 14 ) - 1 : 0 ] ;
            freelist_pf_push_data_nxt.flid_parity          = ^ { 1'b1 , freelist_pf_push_data_nxt.flid } ;

            pf_ldb_cq_wptr_we                              = 1'd1 ;
            pf_ldb_cq_wptr_waddr                           = reset_pf_counter_f [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] ;
            pf_ldb_cq_wptr_wdata.residue                   = 2'd0 ;
            pf_ldb_cq_wptr_wdata.wp                        = '0 ;

            pf_dir_cq_wptr_we                              = ( reset_pf_counter_f < HQM_NUM_DIR_CQ ) ;
            pf_dir_cq_wptr_waddr                           = reset_pf_counter_f [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] ;
            pf_dir_cq_wptr_wdata.residue                   = 2'd0 ;
            pf_dir_cq_wptr_wdata.wp                        = '0 ;

            pf_ord_qid_sn_map_we                           = 1'd1 ;
            pf_ord_qid_sn_map_waddr                        = reset_pf_counter_f [ ( 5 ) - 1 : 0 ] ;
            pf_ord_qid_sn_map_wdata.parity                 = 1'b1 ;
            pf_ord_qid_sn_map_wdata.map                    = '0 ;

            pf_ord_qid_sn_we                               = 1'd1 ;
            pf_ord_qid_sn_waddr                            = reset_pf_counter_f [ ( 5 ) - 1 : 0 ] ;
            pf_ord_qid_sn_wdata.residue                    = 2'd0 ;
            pf_ord_qid_sn_wdata.sn                         = '0 ;

            pf_hist_list_ptr_we                            = 1'd1 ;
            pf_hist_list_ptr_waddr                         = reset_pf_counter_f [ ( 6 ) - 1 : 0 ] ;
            pf_hist_list_ptr_wdata.push_ptr_residue        = 2'd0 ;
            pf_hist_list_ptr_wdata.push_ptr_gen            = 1'd0 ;
            pf_hist_list_ptr_wdata.push_ptr                = '0 ;
            pf_hist_list_ptr_wdata.pop_ptr_residue         = 2'd0 ;
            pf_hist_list_ptr_wdata.pop_ptr_gen             = 1'd0 ;
            pf_hist_list_ptr_wdata.pop_ptr                 = '0 ;

            pf_hist_list_minmax_we                         = 1'd1 ;
            pf_hist_list_minmax_addr                       = reset_pf_counter_f [ ( 6 ) - 1 : 0 ] ;
            pf_hist_list_minmax_wdata.max_addr_residue     = 2'd0 ;
            pf_hist_list_minmax_wdata.max_addr             = '0 ;
            pf_hist_list_minmax_wdata.min_addr_residue     = 2'd0 ;
            pf_hist_list_minmax_wdata.min_addr             = '0 ;

            pf_hist_list_we                                = ( reset_pf_counter_f < 2048 ) ;
            pf_hist_list_addr                              = reset_pf_counter_f [ ( 13 ) - 1 : 0 ] ;
            pf_hist_list_wdata.ecc                         = 8'h60 ;
            pf_hist_list_wdata.hid                         = 16'h0000 ;
            pf_hist_list_wdata.cmp_id                      = 4'h0 ;
            pf_hist_list_wdata.hist_list_info.qtype        = ATOMIC ;
            pf_hist_list_wdata.hist_list_info.qpri         = 3'h0 ;
            pf_hist_list_wdata.hist_list_info.qid          = 6'h00 ;
            pf_hist_list_wdata.hist_list_info.qidix_msb    = 1'b0 ;
            pf_hist_list_wdata.hist_list_info.qidix        = 3'h0 ;
            pf_hist_list_wdata.hist_list_info.reord_mode   = 3'h0 ;
            pf_hist_list_wdata.hist_list_info.reord_slot   = 5'h00 ;
            pf_hist_list_wdata.hist_list_info.sn_fid       = 12'h000 ;

            pf_hist_list_a_ptr_we                            = 1'd1 ;
            pf_hist_list_a_ptr_waddr                         = reset_pf_counter_f [ ( 6 ) - 1 : 0 ] ;
            pf_hist_list_a_ptr_wdata.push_ptr_residue        = 2'd0 ;
            pf_hist_list_a_ptr_wdata.push_ptr_gen            = 1'd0 ;
            pf_hist_list_a_ptr_wdata.push_ptr                = '0 ;
            pf_hist_list_a_ptr_wdata.pop_ptr_residue         = 2'd0 ;
            pf_hist_list_a_ptr_wdata.pop_ptr_gen             = 1'd0 ;
            pf_hist_list_a_ptr_wdata.pop_ptr                 = '0 ;

            pf_hist_list_a_minmax_we                         = 1'd1 ;
            pf_hist_list_a_minmax_addr                       = reset_pf_counter_f [ ( 6 ) - 1 : 0 ] ;
            pf_hist_list_a_minmax_wdata.max_addr_residue     = 2'd0 ;
            pf_hist_list_a_minmax_wdata.max_addr             = '0 ;
            pf_hist_list_a_minmax_wdata.min_addr_residue     = 2'd0 ;
            pf_hist_list_a_minmax_wdata.min_addr             = '0 ;

            pf_hist_list_a_we                                = ( reset_pf_counter_f < 2048 ) ;
            pf_hist_list_a_addr                              = reset_pf_counter_f [ ( 13 ) - 1 : 0 ] ;
            pf_hist_list_a_wdata.ecc                         = 8'h60 ;
            pf_hist_list_a_wdata.hid                         = 16'h0000 ;
            pf_hist_list_a_wdata.cmp_id                      = 4'h0 ;
            pf_hist_list_a_wdata.hist_list_info.qtype        = ATOMIC ;
            pf_hist_list_a_wdata.hist_list_info.qpri         = 3'h0 ;
            pf_hist_list_a_wdata.hist_list_info.qid          = 6'h00 ;
            pf_hist_list_a_wdata.hist_list_info.qidix_msb    = 1'b0 ;
            pf_hist_list_a_wdata.hist_list_info.qidix        = 3'h0 ;
            pf_hist_list_a_wdata.hist_list_info.reord_mode   = 3'h0 ;
            pf_hist_list_a_wdata.hist_list_info.reord_slot   = 5'h00 ;
            pf_hist_list_a_wdata.hist_list_info.sn_fid       = 12'h000 ;

            pf_ldb_cq_depth_we                             = ( reset_pf_counter_f < HQM_NUM_LB_CQ ) ; 
            pf_ldb_cq_depth_waddr                          = reset_pf_counter_f [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] ;
            pf_ldb_cq_depth_wdata.residue                  = 2'd0 ;
            pf_ldb_cq_depth_wdata.depth                    = '0 ;

            pf_dir_cq_depth_we                             = ( reset_pf_counter_f < HQM_NUM_DIR_CQ ) ;
            pf_dir_cq_depth_waddr                          = reset_pf_counter_f [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] ;
            pf_dir_cq_depth_wdata.residue                  = 2'd0 ;
            pf_dir_cq_depth_wdata.depth                    = '0 ;

            pf_ldb_cq_intr_thresh_we                       = ( reset_pf_counter_f < HQM_NUM_LB_CQ ) ; 
            pf_ldb_cq_intr_thresh_waddr                    = reset_pf_counter_f [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] ;
            pf_ldb_cq_intr_thresh_wdata.parity             = 1'b1 ;
            pf_ldb_cq_intr_thresh_wdata.threshold          = '0 ;

            pf_dir_cq_intr_thresh_we                       = ( reset_pf_counter_f < HQM_NUM_DIR_CQ ) ;
            pf_dir_cq_intr_thresh_waddr                    = reset_pf_counter_f [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] ;
            pf_dir_cq_intr_thresh_wdata.parity             = 1'b1 ;
            pf_dir_cq_intr_thresh_wdata.threshold          = '0 ;

            pf_ldb_cq_token_depth_select_we                = ( reset_pf_counter_f < HQM_NUM_LB_CQ ) ;
            pf_ldb_cq_token_depth_select_waddr             = reset_pf_counter_f [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] ;
            pf_ldb_cq_token_depth_select_wdata.parity      = 1'b1 ;
            pf_ldb_cq_token_depth_select_wdata.depth_select = '0 ;

            pf_dir_cq_token_depth_select_we                = ( reset_pf_counter_f < HQM_NUM_DIR_CQ ) ;
            pf_dir_cq_token_depth_select_waddr             = reset_pf_counter_f [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] ;
            pf_dir_cq_token_depth_select_wdata.parity      = 1'b1 ;
            pf_dir_cq_token_depth_select_wdata.depth_select = '0 ;

            pf_cmp_id_chk_enbl_mem_we                      = 1'd1 ;
            pf_cmp_id_chk_enbl_mem_waddr                   = reset_pf_counter_f [ ( 6 ) - 1 : 0 ] ;
            pf_cmp_id_chk_enbl_mem_wdata                   = 2'h2 ;

            pf_count_rmw_pipe_dir_mem_we                   = ( reset_pf_counter_f < HQM_NUM_DIR_CQ ) ;
            pf_count_rmw_pipe_dir_mem_waddr                = reset_pf_counter_f [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] ;
            pf_count_rmw_pipe_dir_mem_wdata                = '0 ;

            pf_threshold_r_pipe_dir_mem_we                 = ( reset_pf_counter_f < HQM_NUM_DIR_CQ ) ;
            pf_threshold_r_pipe_dir_mem_addr               = reset_pf_counter_f [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ] ;
            pf_threshold_r_pipe_dir_mem_wdata              = 1 ;

            pf_count_rmw_pipe_ldb_mem_we                   = ( reset_pf_counter_f < HQM_NUM_LB_CQ ) ;
            pf_count_rmw_pipe_ldb_mem_waddr                = reset_pf_counter_f [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] ;
            pf_count_rmw_pipe_ldb_mem_wdata                = '0 ;

            pf_threshold_r_pipe_ldb_mem_we                 = ( reset_pf_counter_f < HQM_NUM_LB_CQ ) ; 
            pf_threshold_r_pipe_ldb_mem_addr               = reset_pf_counter_f [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] ;
            pf_threshold_r_pipe_ldb_mem_wdata              = 1 ;

            pf_ldb_cq_on_off_threshold_we                  = ( reset_pf_counter_f < HQM_NUM_LB_CQ ) ;
            pf_ldb_cq_on_off_threshold_waddr               = reset_pf_counter_f [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] ;
            pf_ldb_cq_on_off_threshold_wdata.parity        = 2'b11 ;
            pf_ldb_cq_on_off_threshold_wdata.off_thrsh     = '0 ;
            pf_ldb_cq_on_off_threshold_wdata.on_thrsh      = '0 ;

           end
       end
       else begin
            reset_pf_counter_nxt                           = reset_pf_counter_f ;
            hw_init_done_nxt                               = 1'b1 ;
       end
   end
   if ( reset_pf_active_f ) begin
       if ( hw_init_done_f ) begin
         reset_pf_counter_nxt = 32'd0 ;
         reset_pf_active_nxt = 1'b0 ;
         reset_pf_done_nxt = 1'b1 ;
         hw_init_done_nxt = 1'b0 ;
       end
   end

end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

hqm_credit_hist_pipe_ingress i_hqm_credit_hist_pipe_ingress (
  .hqm_inp_gated_clk ( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_b ( hqm_inp_gated_rst_n )
, .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_b ( hqm_gated_rst_n )
, .hqm_proc_reset_done ( hqm_proc_reset_done )
, .ingress_flid_parity_error_inject_1 ( ingress_flid_parity_error_inject_1 )
, .ingress_flid_parity_error_inject_0 ( ingress_flid_parity_error_inject_0 )
, .ingress_error_inject_h0 ( ingress_error_inject_h0 )
, .ingress_error_inject_l0 ( ingress_error_inject_l0 )
, .ingress_error_inject_h1 ( ingress_error_inject_h1 )
, .ingress_error_inject_l1 ( ingress_error_inject_l1 )
, .master_chp_timestamp ( master_chp_timestamp_g2b_f )
, .rst_prep ( rst_prep )
, .hqm_chp_target_cfg_dir_cq2vas_reg_f ( hqm_chp_target_cfg_dir_cq2vas_reg_f )
, .hqm_chp_target_cfg_ldb_cq2vas_reg_f ( hqm_chp_target_cfg_ldb_cq2vas_reg_f )
, .hqm_chp_target_cfg_hw_agitate_control_reg_f ( hqm_chp_target_cfg_hw_agitate_control_reg_f )
, .hqm_chp_target_cfg_hw_agitate_select_reg_f ( hqm_chp_target_cfg_hw_agitate_select_reg_f )
, .cfg_req_idlepipe ( cfg_req_idlepipe )
, .cfg_qed_to_cq_pipe_credit_hwm ( cfg_qed_to_cq_pipe_credit_hwm )	
, .ing_err_hcw_enq_invalid_hcw_cmd ( ing_err_hcw_enq_invalid_hcw_cmd )
, .ing_err_hcw_enq_user_parity_error ( ing_err_hcw_enq_user_parity_error )
, .ing_err_hcw_enq_data_parity_error ( ing_err_hcw_enq_data_parity_error )
, .ing_err_qed_chp_sch_rx_sync_out_cmd_error ( ing_err_qed_chp_sch_rx_sync_out_cmd_error )
, .ing_err_qed_chp_sch_flid_ret_flid_parity_error ( ing_err_qed_chp_sch_flid_ret_flid_parity_error )
, .ing_err_qed_chp_sch_cq_parity_error ( ing_err_qed_chp_sch_cq_parity_error )
, .ing_err_aqed_chp_sch_cq_parity_error ( ing_err_aqed_chp_sch_cq_parity_error )
, .ing_err_qed_chp_sch_vas_parity_error ( ing_err_qed_chp_sch_vas_parity_error )
, .ing_err_aqed_chp_sch_vas_parity_error ( ing_err_aqed_chp_sch_vas_parity_error )
, .ing_err_enq_vas_credit_count_residue_error ( ing_err_enq_vas_credit_count_residue_error )
, .ing_err_sch_vas_credit_count_residue_error ( ing_err_sch_vas_credit_count_residue_error )
, .ing_hqm_chp_target_cfg_chp_smon_smon_v ( ing_hqm_chp_target_cfg_chp_smon_smon_v )
, .ing_hqm_chp_target_cfg_chp_smon_smon_comp ( ing_hqm_chp_target_cfg_chp_smon_smon_comp )
, .ing_hqm_chp_target_cfg_chp_smon_smon_val ( ing_hqm_chp_target_cfg_chp_smon_smon_val )
, .hcw_enq_w_rx_sync_status ( hcw_enq_w_rx_sync_status )
, .atm_ord_db_status ( atm_ord_db_status )
, .hcw_replay_db_status ( hcw_replay_db_status )
, .qed_chp_sch_rx_sync_status ( qed_chp_sch_rx_sync_status )
, .qed_chp_sch_flid_ret_rx_sync_status ( qed_chp_sch_flid_ret_rx_sync_status )
, .aqed_chp_sch_rx_sync_status ( aqed_chp_sch_rx_sync_status )
, .qed_sch_sn_map_mem_pipe_status ( qed_sch_sn_map_mem_pipe_status_nc )
, .qed_sch_sn_mem_pipe_status ( qed_sch_sn_mem_pipe_status_nc )
, .fifo_qed_to_cq_status ( fifo_qed_to_cq_status_nc )
, .hcw_enq_w_rx_sync_enable ( hcw_enq_w_rx_sync_enable )
, .hcw_enq_w_rx_sync_idle ( hcw_enq_w_rx_sync_idle )
, .qed_chp_sch_rx_sync_enable ( qed_chp_sch_rx_sync_enable )
, .qed_chp_sch_rx_sync_idle ( qed_chp_sch_rx_sync_idle )
, .qed_chp_sch_flid_ret_rx_sync_enable ( qed_chp_sch_flid_ret_rx_sync_enable )
, .qed_chp_sch_flid_ret_rx_sync_idle ( qed_chp_sch_flid_ret_rx_sync_idle )
, .aqed_chp_sch_rx_sync_enable ( aqed_chp_sch_rx_sync_enable )
, .aqed_chp_sch_rx_sync_idle ( aqed_chp_sch_rx_sync_idle )
, .ing_pipe_idle ( ing_pipe_idle )
, .ing_unit_idle ( ing_unit_idle )
, .hcw_enq_w_rx_sync_mem_we ( func_hcw_enq_w_rx_sync_mem_we )
, .hcw_enq_w_rx_sync_mem_waddr ( func_hcw_enq_w_rx_sync_mem_waddr )
, .hcw_enq_w_rx_sync_mem_wdata ( hcw_enq_w_rx_sync_mem_wdata )
, .hcw_enq_w_rx_sync_mem_re ( func_hcw_enq_w_rx_sync_mem_re )
, .hcw_enq_w_rx_sync_mem_raddr ( func_hcw_enq_w_rx_sync_mem_raddr )
, .hcw_enq_w_rx_sync_mem_rdata ( hcw_enq_w_rx_sync_mem_rdata )
, .qed_chp_sch_rx_sync_mem_we ( func_qed_chp_sch_rx_sync_mem_we )
, .qed_chp_sch_rx_sync_mem_waddr ( func_qed_chp_sch_rx_sync_mem_waddr )
, .qed_chp_sch_rx_sync_mem_wdata ( func_qed_chp_sch_rx_sync_mem_wdata )
, .qed_chp_sch_rx_sync_mem_re ( func_qed_chp_sch_rx_sync_mem_re )
, .qed_chp_sch_rx_sync_mem_raddr ( func_qed_chp_sch_rx_sync_mem_raddr )
, .qed_chp_sch_rx_sync_mem_rdata ( func_qed_chp_sch_rx_sync_mem_rdata )
, .qed_chp_sch_flid_ret_rx_sync_mem_we ( func_qed_chp_sch_flid_ret_rx_sync_mem_we )
, .qed_chp_sch_flid_ret_rx_sync_mem_waddr ( func_qed_chp_sch_flid_ret_rx_sync_mem_waddr )
, .qed_chp_sch_flid_ret_rx_sync_mem_wdata ( func_qed_chp_sch_flid_ret_rx_sync_mem_wdata )
, .qed_chp_sch_flid_ret_rx_sync_mem_re ( func_qed_chp_sch_flid_ret_rx_sync_mem_re )
, .qed_chp_sch_flid_ret_rx_sync_mem_raddr ( func_qed_chp_sch_flid_ret_rx_sync_mem_raddr )
, .qed_chp_sch_flid_ret_rx_sync_mem_rdata ( func_qed_chp_sch_flid_ret_rx_sync_mem_rdata )
, .fifo_qed_to_cq_of ( fifo_qed_to_cq_of )
, .fifo_qed_to_cq_uf ( fifo_qed_to_cq_uf )
, .aqed_chp_sch_rx_sync_mem_we ( func_aqed_chp_sch_rx_sync_mem_we )
, .aqed_chp_sch_rx_sync_mem_waddr ( func_aqed_chp_sch_rx_sync_mem_waddr )
, .aqed_chp_sch_rx_sync_mem_wdata ( func_aqed_chp_sch_rx_sync_mem_wdata )
, .aqed_chp_sch_rx_sync_mem_re ( func_aqed_chp_sch_rx_sync_mem_re )
, .aqed_chp_sch_rx_sync_mem_raddr ( func_aqed_chp_sch_rx_sync_mem_raddr )
, .aqed_chp_sch_rx_sync_mem_rdata ( func_aqed_chp_sch_rx_sync_mem_rdata )
, .func_ord_qid_sn_map_we ( func_ord_qid_sn_map_we )
, .func_ord_qid_sn_map_wdata ( func_ord_qid_sn_map_wdata )
, .func_ord_qid_sn_map_waddr ( func_ord_qid_sn_map_waddr )
, .func_ord_qid_sn_map_re ( func_ord_qid_sn_map_re )
, .func_ord_qid_sn_map_raddr ( func_ord_qid_sn_map_raddr )
, .func_ord_qid_sn_map_rdata ( func_ord_qid_sn_map_rdata )
, .func_ord_qid_sn_we ( func_ord_qid_sn_we )
, .func_ord_qid_sn_wdata ( func_ord_qid_sn_wdata )
, .func_ord_qid_sn_waddr ( func_ord_qid_sn_waddr )
, .func_ord_qid_sn_re ( func_ord_qid_sn_re )
, .func_ord_qid_sn_raddr ( func_ord_qid_sn_raddr )
, .func_ord_qid_sn_rdata ( func_ord_qid_sn_rdata )
, .func_qed_to_cq_fifo_mem_we ( func_qed_to_cq_fifo_mem_we )
, .func_qed_to_cq_fifo_mem_waddr ( func_qed_to_cq_fifo_mem_waddr )
, .func_qed_to_cq_fifo_mem_wdata ( func_qed_to_cq_fifo_mem_wdata )
, .func_qed_to_cq_fifo_mem_re ( func_qed_to_cq_fifo_mem_re )
, .func_qed_to_cq_fifo_mem_raddr ( func_qed_to_cq_fifo_mem_raddr )
, .func_qed_to_cq_fifo_mem_rdata ( func_qed_to_cq_fifo_mem_rdata )
, .hcw_enq_w_req_ready ( hcw_enq_w_req_ready )
, .hcw_enq_w_req_valid ( hcw_enq_w_req_valid )
, .hcw_enq_w_req ( hcw_enq_w_req )
, .qed_chp_sch_ready ( qed_chp_sch_ready )
, .qed_chp_sch_v ( qed_chp_sch_v )
, .qed_chp_sch_data ( qed_chp_sch_data )
, .aqed_chp_sch_ready ( aqed_chp_sch_ready )
, .aqed_chp_sch_v ( aqed_chp_sch_v )
, .aqed_chp_sch_data ( aqed_chp_sch_data )
, .hcw_enq_pop ( hcw_enq_pop )
, .hcw_enq_valid ( hcw_enq_valid )
, .hcw_enq_info ( hcw_enq_info )
, .hcw_enq_data ( hcw_enq_data )
, .hcw_replay_pop ( hcw_replay_pop )
, .hcw_replay_valid ( hcw_replay_valid )
, .hcw_replay_data ( hcw_replay_data )
, .qed_sch_pop ( qed_sch_pop )
, .qed_sch_valid ( qed_sch_valid )
, .qed_sch_data ( qed_sch_data )
, .aqed_sch_pop ( aqed_sch_pop )
, .aqed_sch_valid ( aqed_sch_valid )
, .aqed_sch_data ( aqed_sch_data )
, .qed_to_cq_pipe_credit_status ( qed_to_cq_pipe_credit_status )
, .ing_enq_vas_credit_count_rdata ( ing_enq_vas_credit_count_rdata )
, .ing_enq_vas_credit_count_we ( ing_enq_vas_credit_count_we )
, .ing_enq_vas_credit_count_addr ( ing_enq_vas_credit_count_addr )
, .ing_enq_vas_credit_count_wdata ( ing_enq_vas_credit_count_wdata )
, .ing_sch_vas_credit_count_rdata ( ing_sch_vas_credit_count_rdata )
, .ing_sch_vas_credit_count_we ( ing_sch_vas_credit_count_we )
, .ing_sch_vas_credit_count_addr ( ing_sch_vas_credit_count_addr )
, .ing_sch_vas_credit_count_wdata ( ing_sch_vas_credit_count_wdata )
, .ing_freelist_push_v ( ing_freelist_push_v )
, .ing_freelist_push_data ( ing_freelist_push_data )
, .ingress_flid_parity_error_inject_1_done_set ( ingress_flid_parity_error_inject_1_done_set )
, .ingress_flid_parity_error_inject_0_done_set ( ingress_flid_parity_error_inject_0_done_set )
, .ingress_error_inject_h0_done_set ( ingress_error_inject_h0_done_set )
, .ingress_error_inject_l0_done_set ( ingress_error_inject_l0_done_set )
, .ingress_error_inject_h1_done_set ( ingress_error_inject_h1_done_set )
, .ingress_error_inject_l1_done_set ( ingress_error_inject_l1_done_set )
, .hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc )
) ;

hqm_credit_hist_pipe_arbiter i_hqm_credit_hist_pipe_arbiter (
  .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_b ( hqm_gated_rst_n )
, .cfg_req_idlepipe ( cfg_req_idlepipe )
, .cfg_chp_blk_dual_issue ( cfg_chp_blk_dual_issue )
, .cfg_chp_rop_pipe_credit_hwm ( cfg_chp_rop_pipe_credit_hwm )
, .cfg_chp_lsp_tok_pipe_credit_hwm ( cfg_chp_lsp_tok_pipe_credit_hwm )
, .cfg_chp_lsp_ap_cmp_pipe_credit_hwm ( cfg_chp_lsp_ap_cmp_pipe_credit_hwm )
, .cfg_chp_outbound_hcw_pipe_credit_hwm ( cfg_chp_outbound_hcw_pipe_credit_hwm )
, .arb_hqm_chp_target_cfg_chp_smon_smon_v ( arb_hqm_chp_target_cfg_chp_smon_smon_v )
, .arb_hqm_chp_target_cfg_chp_smon_smon_comp ( arb_hqm_chp_target_cfg_chp_smon_smon_comp )
, .arb_hqm_chp_target_cfg_chp_smon_smon_val ( arb_hqm_chp_target_cfg_chp_smon_smon_val )
, .chp_rop_pipe_credit_status ( chp_rop_pipe_credit_status )
, .chp_lsp_tok_pipe_credit_status ( chp_lsp_tok_pipe_credit_status )
, .chp_lsp_ap_cmp_pipe_credit_status ( chp_lsp_ap_cmp_pipe_credit_status )
, .chp_outbound_hcw_pipe_credit_status ( chp_outbound_hcw_pipe_credit_status )
, .arb_pipe_idle ( arb_pipe_idle )
, .arb_unit_idle ( arb_unit_idle )
, .chp_rop_pipe_credit_dealloc ( chp_rop_pipe_credit_dealloc )
, .enq_to_rop_error_credit_dealloc ( enq_to_rop_error_credit_dealloc )
, .enq_to_rop_cmp_credit_dealloc ( enq_to_rop_cmp_credit_dealloc )
, .enq_to_lsp_cmp_error_credit_dealloc ( enq_to_lsp_cmp_error_credit_dealloc )
, .chp_lsp_tok_pipe_credit_dealloc ( chp_lsp_tok_pipe_credit_dealloc )
, .chp_lsp_ap_cmp_pipe_credit_dealloc ( chp_lsp_ap_cmp_pipe_credit_dealloc )
, .chp_outbound_hcw_pipe_credit_dealloc ( chp_outbound_hcw_pipe_credit_dealloc )
, .hcw_enq_pop ( hcw_enq_pop )
, .hcw_enq_valid ( hcw_enq_valid )
, .hcw_enq_info ( hcw_enq_info )
, .hcw_replay_pop ( hcw_replay_pop )
, .hcw_replay_valid ( hcw_replay_valid )
, .qed_sch_pop ( qed_sch_pop )
, .qed_sch_valid ( qed_sch_valid )
, .qed_sch_data ( qed_sch_data )
, .aqed_sch_pop ( aqed_sch_pop )
, .aqed_sch_valid ( aqed_sch_valid )
, .arb_err_illegal_cmd_error ( arb_err_illegal_cmd_error )
) ;

hqm_credit_hist_pipe_enqpipe i_hqm_credit_hist_pipe_enqpipe (
  .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_b ( hqm_gated_rst_n )
, .enqpipe_flid_parity_error_inject ( enqpipe_flid_parity_error_inject )
, .enqpipe_error_inject_h0 ( enqpipe_error_inject_h0 )
, .enqpipe_error_inject_l0 ( enqpipe_error_inject_l0 )
, .enqpipe_error_inject_h1 ( enqpipe_error_inject_h1 )
, .enqpipe_error_inject_l1 ( enqpipe_error_inject_l1 )
, .enqpipe_err_rid ( enqpipe_err_rid )
, .enqpipe_err_frag_count_residue_error ( enqpipe_err_frag_count_residue_error )
, .enqpipe_err_hist_list_data_error_sb ( enqpipe_err_hist_list_data_error_sb )
, .enqpipe_err_hist_list_data_error_mb ( enqpipe_err_hist_list_data_error_mb )
, .enqpipe_err_enq_to_rop_out_of_credit_drop ( enqpipe_err_enq_to_rop_out_of_credit_drop )
, .enqpipe_err_enq_to_rop_excess_frag_drop ( enqpipe_err_enq_to_rop_excess_frag_drop )
, .enqpipe_err_enq_to_rop_freelist_uf_drop ( enqpipe_err_enq_to_rop_freelist_uf_drop )
, .enqpipe_err_enq_to_lsp_cmp_error_drop ( enqpipe_err_enq_to_lsp_cmp_error_drop )
, .enqpipe_err_release_qtype_error_drop ( enqpipe_err_release_qtype_error_drop )
, .hqm_chp_target_cfg_counter_chp_error_drop_inc ( hqm_chp_target_cfg_counter_chp_error_drop_inc )
, .enqpipe_hqm_chp_target_cfg_chp_smon_smon_v ( enqpipe_hqm_chp_target_cfg_chp_smon_smon_v )
, .enqpipe_hqm_chp_target_cfg_chp_smon_smon_comp ( enqpipe_hqm_chp_target_cfg_chp_smon_smon_comp )
, .enqpipe_hqm_chp_target_cfg_chp_smon_smon_val ( enqpipe_hqm_chp_target_cfg_chp_smon_smon_val )
, .enqpipe_pipe_idle ( enqpipe_pipe_idle )
, .enqpipe_unit_idle ( enqpipe_unit_idle )
, .rw_cmp_id_chk_enbl_mem_p0_v_nxt ( rw_cmp_id_chk_enbl_mem_p0_v_nxt )
, .enq_to_rop_error_credit_dealloc ( enq_to_rop_error_credit_dealloc )
, .enq_to_rop_cmp_credit_dealloc ( enq_to_rop_cmp_credit_dealloc )
, .enq_to_lsp_cmp_error_credit_dealloc ( enq_to_lsp_cmp_error_credit_dealloc )
, .rw_cmp_id_chk_enbl_mem_p0_rw_nxt ( rw_cmp_id_chk_enbl_mem_p0_rw_nxt )
, .rw_cmp_id_chk_enbl_mem_p0_addr_nxt ( rw_cmp_id_chk_enbl_mem_p0_addr_nxt )
, .rw_cmp_id_chk_enbl_mem_p2_data_f ( rw_cmp_id_chk_enbl_mem_p2_data_f )
, .enq_hist_list_cmd_v ( enq_hist_list_cmd_v )
, .enq_hist_list_cmd ( enq_hist_list_cmd )
, .enq_hist_list_fifo_num ( enq_hist_list_fifo_num )
, .enq_hist_list_pop_data ( enq_hist_list_pop_data )
, .enqpipe_hqm_chp_target_cfg_hist_list_mode ( enqpipe_hqm_chp_target_cfg_hist_list_mode )
, .enq_hist_list_uf ( enq_hist_list_uf )
, .enq_hist_list_residue_error ( enq_hist_list_residue_error )
, .enq_hist_list_a_cmd_v ( enq_hist_list_a_cmd_v )
, .enq_hist_list_a_cmd ( enq_hist_list_a_cmd )
, .enq_hist_list_a_fifo_num ( enq_hist_list_a_fifo_num )
, .enq_freelist_pop_v ( enq_freelist_pop_v )
, .enq_freelist_pop_data ( enq_freelist_pop_data )
, .enq_freelist_pop_error ( enq_freelist_pop_error )
, .enq_freelist_error_mb ( enq_freelist_error_mb )
, .enq_freelist_uf ( enq_freelist_uf )
, .hcw_replay_pop ( hcw_replay_pop )
, .hcw_replay_data ( hcw_replay_data )
, .hcw_enq_pop ( hcw_enq_pop )
, .hcw_enq_info ( hcw_enq_info )
, .hcw_enq_data ( hcw_enq_data )
, .fifo_chp_rop_hcw_push ( fifo_chp_rop_hcw_push )
, .fifo_chp_rop_hcw_push_data ( fifo_chp_rop_hcw_push_data )
, .fifo_chp_lsp_tok_push ( fifo_chp_lsp_tok_push )
, .fifo_chp_lsp_tok_push_data ( fifo_chp_lsp_tok_push_data )
, .fifo_chp_lsp_ap_cmp_push ( fifo_chp_lsp_ap_cmp_push )
, .fifo_chp_lsp_ap_cmp_push_data ( fifo_chp_lsp_ap_cmp_push_data )
, .cmp_id_chk_enbl_parity_err ( cmp_id_chk_enbl_parity_err )
, .enqpipe_flid_parity_error_inject_done_set ( enqpipe_flid_parity_error_inject_done_set )
, .enqpipe_error_inject_h0_done_set ( enqpipe_error_inject_h0_done_set )
, .enqpipe_error_inject_l0_done_set ( enqpipe_error_inject_l0_done_set )
, .enqpipe_error_inject_h1_done_set ( enqpipe_error_inject_h1_done_set )
, .enqpipe_error_inject_l1_done_set ( enqpipe_error_inject_l1_done_set )
, .hqm_chp_target_cfg_chp_frag_count_reg_load ( hqm_chp_target_cfg_chp_frag_count_reg_load ) 
, .hqm_chp_target_cfg_chp_frag_count_reg_nxt ( hqm_chp_target_cfg_chp_frag_count_reg_nxt ) 
, .hqm_chp_target_cfg_chp_frag_count_reg_f ( hqm_chp_target_cfg_chp_frag_count_reg_f ) 
) ;

hqm_credit_hist_pipe_schpipe i_hqm_credit_hist_pipe_schpipe (
  .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_b ( hqm_gated_rst_n )
, .schpipe_error_inject_h0 ( schpipe_error_inject_h0 )
, .schpipe_error_inject_l0 ( schpipe_error_inject_l0 )
, .schpipe_error_inject_h1 ( schpipe_error_inject_h1 )
, .schpipe_error_inject_l1 ( schpipe_error_inject_l1 )
, .schpipe_err_pipeline_parity_err ( schpipe_err_pipeline_parity_err )
, .schpipe_err_ldb_cq_hcw_h_ecc_sb ( schpipe_err_ldb_cq_hcw_h_ecc_sb )
, .schpipe_err_ldb_cq_hcw_h_ecc_mb ( schpipe_err_ldb_cq_hcw_h_ecc_mb )
, .schpipe_hqm_chp_target_cfg_chp_smon_smon_v ( schpipe_hqm_chp_target_cfg_chp_smon_smon_v )
, .schpipe_hqm_chp_target_cfg_chp_smon_smon_comp ( schpipe_hqm_chp_target_cfg_chp_smon_smon_comp )
, .schpipe_hqm_chp_target_cfg_chp_smon_smon_val ( schpipe_hqm_chp_target_cfg_chp_smon_smon_val )
, .schpipe_pipe_idle ( schpipe_pipe_idle )
, .schpipe_unit_idle ( schpipe_unit_idle )
, .sch_hist_list_cmd_v ( sch_hist_list_cmd_v )
, .sch_hist_list_cmd ( sch_hist_list_cmd )
, .sch_hist_list_fifo_num ( sch_hist_list_fifo_num )
, .sch_hist_list_push_data ( sch_hist_list_push_data )
, .sch_hist_list_of ( sch_hist_list_of )
, .schpipe_hqm_chp_target_cfg_hist_list_mode ( schpipe_hqm_chp_target_cfg_hist_list_mode )
, .sch_hist_list_a_cmd_v ( sch_hist_list_a_cmd_v )
, .sch_hist_list_a_cmd ( sch_hist_list_a_cmd )
, .sch_hist_list_a_fifo_num ( sch_hist_list_a_fifo_num )
, .sch_hist_list_a_push_data ( sch_hist_list_a_push_data )
, .sch_hist_list_a_of ( sch_hist_list_a_of )
, .qed_sch_pop ( qed_sch_pop )
, .qed_sch_data ( qed_sch_data )
, .aqed_sch_pop ( aqed_sch_pop )
, .aqed_sch_data ( aqed_sch_data )
, .fifo_outbound_hcw_push ( fifo_outbound_hcw_push )
, .fifo_outbound_hcw_push_data ( fifo_outbound_hcw_push_data )
, .schpipe_error_inject_h0_done_set ( schpipe_error_inject_h0_done_set )
, .schpipe_error_inject_l0_done_set ( schpipe_error_inject_l0_done_set )
, .schpipe_error_inject_h1_done_set ( schpipe_error_inject_h1_done_set )
, .schpipe_error_inject_l1_done_set ( schpipe_error_inject_l1_done_set )
) ;

hqm_credit_hist_pipe_shared_pipe i_hqm_credit_hist_pipe_shared_pipe (
  .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_b ( hqm_gated_rst_n )
, .hqm_proc_reset_done ( hqm_proc_reset_done )
, .sharepipe_error ( sharepipe_error )
, .hqm_chp_target_cfg_chp_palb_control_reg_f ( hqm_chp_target_cfg_chp_palb_control_reg_f )
, .hqm_chp_target_cfg_ldb_cq2vas_reg_f ( hqm_chp_target_cfg_ldb_cq2vas_reg_f )
, .chp_lsp_ldb_cq_off ( chp_lsp_ldb_cq_off )
, .hqm_chp_target_cfg_vas_credit_count_reg_load ( hqm_chp_target_cfg_vas_credit_count_reg_load )
, .hqm_chp_target_cfg_vas_credit_count_reg_nxt ( hqm_chp_target_cfg_vas_credit_count_reg_nxt )
, .hqm_chp_target_cfg_vas_credit_count_reg_f ( hqm_chp_target_cfg_vas_credit_count_reg_f )
, .hist_list_cmd_v ( hist_list_cmd_v )
, .hist_list_cmd ( hist_list_cmd )
, .hist_list_fifo_num ( hist_list_fifo_num )
, .hist_list_push_data ( hist_list_push_data )
, .hist_list_pop_data ( hist_list_pop_data )
, .hist_list_uf ( hist_list_uf )
, .hist_list_of ( hist_list_of )
, .hist_list_residue_error ( hist_list_residue_error )
, .hist_list_a_cmd_v ( hist_list_a_cmd_v )
, .hist_list_a_cmd ( hist_list_a_cmd )
, .hist_list_a_fifo_num ( hist_list_a_fifo_num )
, .hist_list_a_push_data ( hist_list_a_push_data )
, .hist_list_a_pop_data_v ( hist_list_a_pop_data_v )
, .hist_list_a_pop_data ( hist_list_a_pop_data )
, .hist_list_a_uf ( hist_list_a_uf )
, .hist_list_a_of ( hist_list_a_of )
, .hist_list_a_residue_error ( hist_list_a_residue_error )
, .freelist_pf_push_v ( freelist_pf_push_v )
, .freelist_push_v ( freelist_push_v )
, .freelist_push_data ( freelist_push_data )
, .freelist_pop_v ( freelist_pop_v )
, .freelist_pop_data ( freelist_pop_data )
, .freelist_pop_error ( freelist_pop_error )
, .freelist_eccerr_mb ( freelist_eccerr_mb )
, .freelist_uf ( freelist_uf )
, .ing_enq_vas_credit_count_rdata ( ing_enq_vas_credit_count_rdata )
, .ing_enq_vas_credit_count_we ( ing_enq_vas_credit_count_we )
, .ing_enq_vas_credit_count_addr ( ing_enq_vas_credit_count_addr )
, .ing_enq_vas_credit_count_wdata ( ing_enq_vas_credit_count_wdata )
, .enq_hist_list_cmd_v ( enq_hist_list_cmd_v )
, .enq_hist_list_cmd ( enq_hist_list_cmd )
, .enq_hist_list_fifo_num ( enq_hist_list_fifo_num )
, .enq_hist_list_pop_data ( enq_hist_list_pop_data )
, .enq_hist_list_uf ( enq_hist_list_uf )
, .enq_hist_list_residue_error ( enq_hist_list_residue_error )
, .enq_hist_list_a_cmd_v ( enq_hist_list_a_cmd_v )
, .enq_hist_list_a_cmd ( enq_hist_list_a_cmd )
, .enq_hist_list_a_fifo_num ( enq_hist_list_a_fifo_num )
, .enq_freelist_pop_v ( enq_freelist_pop_v )
, .enq_freelist_pop_data ( enq_freelist_pop_data )
, .enq_freelist_pop_error ( enq_freelist_pop_error )
, .enq_freelist_error_mb ( enq_freelist_error_mb )
, .enq_freelist_uf ( enq_freelist_uf )
, .ing_sch_vas_credit_count_rdata ( ing_sch_vas_credit_count_rdata )
, .ing_sch_vas_credit_count_we ( ing_sch_vas_credit_count_we )
, .ing_sch_vas_credit_count_addr ( ing_sch_vas_credit_count_addr )
, .ing_sch_vas_credit_count_wdata ( ing_sch_vas_credit_count_wdata )
, .sch_hist_list_cmd_v ( sch_hist_list_cmd_v )
, .sch_hist_list_cmd ( sch_hist_list_cmd )
, .sch_hist_list_fifo_num ( sch_hist_list_fifo_num )
, .sch_hist_list_push_data ( sch_hist_list_push_data )
, .sch_hist_list_of ( sch_hist_list_of )
, .sch_hist_list_a_cmd_v ( sch_hist_list_a_cmd_v )
, .sch_hist_list_a_cmd ( sch_hist_list_a_cmd )
, .sch_hist_list_a_fifo_num ( sch_hist_list_a_fifo_num )
, .sch_hist_list_a_push_data ( sch_hist_list_a_push_data )
, .sch_hist_list_a_of ( sch_hist_list_a_of )
, .ing_freelist_push_v ( ing_freelist_push_v )
, .ing_freelist_push_data ( ing_freelist_push_data )
, .func_ldb_cq_on_off_threshold_re (func_ldb_cq_on_off_threshold_re)
, .func_ldb_cq_on_off_threshold_raddr (func_ldb_cq_on_off_threshold_raddr)
, .func_ldb_cq_on_off_threshold_waddr (func_ldb_cq_on_off_threshold_waddr)
, .func_ldb_cq_on_off_threshold_we (func_ldb_cq_on_off_threshold_we)
, .func_ldb_cq_on_off_threshold_wdata (func_ldb_cq_on_off_threshold_wdata)
, .func_ldb_cq_on_off_threshold_rdata (func_ldb_cq_on_off_threshold_rdata)
) ;

hqm_credit_hist_pipe_egress i_hqm_credit_hist_pipe_egress (
  .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_b ( hqm_gated_rst_n )
, .hqm_flr_prep ( rst_prep )
, .master_chp_timestamp ( master_chp_timestamp_g2b_f )
, .cfg_req_idlepipe ( cfg_req_idlepipe )
, .cfg_pad_first_write_ldb ( cfg_pad_first_write_ldb )
, .cfg_pad_first_write_dir ( cfg_pad_first_write_dir )
, .cfg_pad_write_ldb ( cfg_pad_write_ldb )
, .cfg_pad_write_dir ( cfg_pad_write_dir )
, .cfg_64bytes_qe_dir_cq_mode ( cfg_64bytes_qe_dir_cq_mode )
, .cfg_64bytes_qe_ldb_cq_mode ( cfg_64bytes_qe_ldb_cq_mode )
, .egress_wbo_error_inject_3 ( egress_wbo_error_inject_3 )
, .egress_wbo_error_inject_2 ( egress_wbo_error_inject_2 )
, .egress_wbo_error_inject_1 ( egress_wbo_error_inject_1 )
, .egress_wbo_error_inject_0 ( egress_wbo_error_inject_0 )
, .egress_error_inject_h0 ( egress_error_inject_h0 )
, .egress_error_inject_l0 ( egress_error_inject_l0 )
, .egress_error_inject_h1 ( egress_error_inject_h1 )
, .egress_error_inject_l1 ( egress_error_inject_l1 )
, .cfg_egress_pipecredits ( cfg_egress_pipecredits )
, .cfg_egress_lsp_token_pipecredits ( cfg_egress_lsp_token_pipecredits )
, .egress_err_parity_ldb_cq_token_depth_select ( egress_err_parity_ldb_cq_token_depth_select )
, .egress_err_parity_dir_cq_token_depth_select ( egress_err_parity_dir_cq_token_depth_select )
, .egress_err_parity_ldb_cq_intr_thresh ( egress_err_parity_ldb_cq_intr_thresh )
, .egress_err_parity_dir_cq_intr_thresh ( egress_err_parity_dir_cq_intr_thresh )
, .egress_err_residue_ldb_cq_wptr ( egress_err_residue_ldb_cq_wptr )
, .egress_err_residue_dir_cq_wptr ( egress_err_residue_dir_cq_wptr )
, .egress_err_residue_ldb_cq_depth ( egress_err_residue_ldb_cq_depth )
, .egress_err_residue_dir_cq_depth ( egress_err_residue_dir_cq_depth )
, .egress_err_ldb_rid ( egress_err_ldb_rid )
, .egress_err_dir_rid ( egress_err_dir_rid )
, .egress_err_hcw_ecc_sb ( egress_err_hcw_ecc_sb )
, .egress_err_hcw_ecc_mb ( egress_err_hcw_ecc_mb )
, .egress_err_ldb_cq_depth_underflow ( egress_err_ldb_cq_depth_underflow )
, .egress_err_ldb_cq_depth_overflow ( egress_err_ldb_cq_depth_overflow )
, .egress_err_dir_cq_depth_underflow ( egress_err_dir_cq_depth_underflow )
, .egress_err_dir_cq_depth_overflow ( egress_err_dir_cq_depth_overflow )
, .egress_hqm_chp_target_cfg_chp_smon_smon_v ( egress_hqm_chp_target_cfg_chp_smon_smon_v )
, .egress_hqm_chp_target_cfg_chp_smon_smon_comp ( egress_hqm_chp_target_cfg_chp_smon_smon_comp )
, .egress_hqm_chp_target_cfg_chp_smon_smon_val ( egress_hqm_chp_target_cfg_chp_smon_smon_val )
, .egress_credit_status ( egress_credit_status )
, .egress_lsp_token_credit_status ( egress_lsp_token_credit_status )
, .egress_tx_sync_status ( egress_tx_sync_status )
, .egress_pipe_idle ( egress_pipe_idle )
, .egress_unit_idle ( egress_unit_idle )
, .rw_ldb_cq_wptr_p0_v_nxt ( rw_ldb_cq_wptr_p0_v_nxt )
, .rw_ldb_cq_wptr_p0_rmw_nxt ( rw_ldb_cq_wptr_p0_rmw_nxt )
, .rw_ldb_cq_wptr_p0_addr_nxt ( rw_ldb_cq_wptr_p0_addr_nxt )
, .rw_ldb_cq_wptr_p2_data_f ( rw_ldb_cq_wptr_p2_data_f )
, .rw_ldb_cq_wptr_p3_bypsel_nxt ( rw_ldb_cq_wptr_p3_bypsel_nxt )
, .rw_ldb_cq_wptr_p3_bypdata_nxt ( rw_ldb_cq_wptr_p3_bypdata_nxt )
, .rw_ldb_cq_token_depth_select_p0_v_nxt ( rw_ldb_cq_token_depth_select_p0_v_nxt )
, .rw_ldb_cq_token_depth_select_p0_rw_nxt ( rw_ldb_cq_token_depth_select_p0_rw_nxt )
, .rw_ldb_cq_token_depth_select_p0_addr_nxt ( rw_ldb_cq_token_depth_select_p0_addr_nxt )
, .rw_ldb_cq_token_depth_select_p2_data_f ( rw_ldb_cq_token_depth_select_p2_data_f )
, .rw_ldb_cq_intr_thresh_p0_v_nxt ( rw_ldb_cq_intr_thresh_p0_v_nxt )
, .rw_ldb_cq_intr_thresh_p0_rw_nxt ( rw_ldb_cq_intr_thresh_p0_rw_nxt )
, .rw_ldb_cq_intr_thresh_p0_addr_nxt ( rw_ldb_cq_intr_thresh_p0_addr_nxt )
, .rw_ldb_cq_intr_thresh_p2_data_f ( rw_ldb_cq_intr_thresh_p2_data_f )
, .rw_ldb_cq_depth_p0_v_nxt ( rw_ldb_cq_depth_p0_v_nxt )
, .rw_ldb_cq_depth_p0_rmw_nxt ( rw_ldb_cq_depth_p0_rmw_nxt )
, .rw_ldb_cq_depth_p0_addr_nxt ( rw_ldb_cq_depth_p0_addr_nxt )
, .rw_ldb_cq_depth_p2_data_f ( rw_ldb_cq_depth_p2_data_f )
, .rw_ldb_cq_depth_p3_bypsel_nxt ( rw_ldb_cq_depth_p3_bypsel_nxt )
, .rw_ldb_cq_depth_p3_bypdata_nxt ( rw_ldb_cq_depth_p3_bypdata_nxt )
, .rw_dir_cq_wptr_p0_v_nxt ( rw_dir_cq_wptr_p0_v_nxt )
, .rw_dir_cq_wptr_p0_rmw_nxt ( rw_dir_cq_wptr_p0_rmw_nxt )
, .rw_dir_cq_wptr_p0_addr_nxt ( rw_dir_cq_wptr_p0_addr_nxt )
, .rw_dir_cq_wptr_p2_data_f ( rw_dir_cq_wptr_p2_data_f )
, .rw_dir_cq_wptr_p3_bypsel_nxt ( rw_dir_cq_wptr_p3_bypsel_nxt )
, .rw_dir_cq_wptr_p3_bypdata_nxt ( rw_dir_cq_wptr_p3_bypdata_nxt )
, .rw_dir_cq_token_depth_select_p0_v_nxt ( rw_dir_cq_token_depth_select_p0_v_nxt )
, .rw_dir_cq_token_depth_select_p0_rw_nxt ( rw_dir_cq_token_depth_select_p0_rw_nxt )
, .rw_dir_cq_token_depth_select_p0_addr_nxt ( rw_dir_cq_token_depth_select_p0_addr_nxt )
, .rw_dir_cq_token_depth_select_p2_data_f ( rw_dir_cq_token_depth_select_p2_data_f )
, .rw_dir_cq_intr_thresh_p0_v_nxt ( rw_dir_cq_intr_thresh_p0_v_nxt )
, .rw_dir_cq_intr_thresh_p0_rw_nxt ( rw_dir_cq_intr_thresh_p0_rw_nxt )
, .rw_dir_cq_intr_thresh_p0_addr_nxt ( rw_dir_cq_intr_thresh_p0_addr_nxt )
, .rw_dir_cq_intr_thresh_p2_data_f ( rw_dir_cq_intr_thresh_p2_data_f )
, .rw_dir_cq_depth_p0_v_nxt ( rw_dir_cq_depth_p0_v_nxt )
, .rw_dir_cq_depth_p0_rmw_nxt ( rw_dir_cq_depth_p0_rmw_nxt )
, .rw_dir_cq_depth_p0_addr_nxt ( rw_dir_cq_depth_p0_addr_nxt )
, .rw_dir_cq_depth_p2_data_f ( rw_dir_cq_depth_p2_data_f )
, .rw_dir_cq_depth_p3_bypsel_nxt ( rw_dir_cq_depth_p3_bypsel_nxt )
, .rw_dir_cq_depth_p3_bypdata_nxt ( rw_dir_cq_depth_p3_bypdata_nxt )
, .fifo_chp_sys_tx_fifo_mem_push ( fifo_chp_sys_tx_fifo_mem_push )
, .fifo_chp_sys_tx_fifo_mem_pop ( fifo_chp_sys_tx_fifo_mem_pop )
, .fifo_chp_sys_tx_fifo_mem_pop_data_v ( fifo_chp_sys_tx_fifo_mem_pop_data_v )
, .fifo_chp_sys_tx_fifo_mem_push_data ( fifo_chp_sys_tx_fifo_mem_push_data )
, .fifo_chp_sys_tx_fifo_mem_pop_data ( fifo_chp_sys_tx_fifo_mem_pop_data )
, .fifo_outbound_hcw_pop_data_v ( fifo_outbound_hcw_pop_data_v )
, .fifo_outbound_hcw_pop ( fifo_outbound_hcw_pop )
, .fifo_outbound_hcw_pop_data ( fifo_outbound_hcw_pop_data )
, .fifo_chp_lsp_tok_pop_data_v ( fifo_chp_lsp_tok_pop_data_v )
, .fifo_chp_lsp_tok_pop ( fifo_chp_lsp_tok_pop )
, .fifo_chp_lsp_tok_pop_data ( fifo_chp_lsp_tok_pop_data )
, .hcw_sched_w_req ( hcw_sched_w_req )
, .hcw_sched_w_req_valid ( hcw_sched_w_req_valid )
, .hcw_sched_w_req_ready ( hcw_sched_w_req_ready )
, .sch_ldb_excep ( sch_ldb_excep )
, .enq_ldb_excep ( enq_ldb_excep )
, .sch_dir_excep ( sch_dir_excep )
, .enq_dir_excep ( enq_dir_excep )
, .chp_lsp_token_qb_in_valid ( chp_lsp_token_qb_in_valid )
, .chp_lsp_token_qb_in_data ( chp_lsp_token_qb_in_data )
, .egress_lsp_token_credit_dealloc ( egress_lsp_token_credit_dealloc )
, .hqm_chp_partial_outbound_hcw_fifo_parity_err (hqm_chp_partial_outbound_hcw_fifo_parity_err)
, .egress_wbo_error_inject_3_done_set ( egress_wbo_error_inject_3_done_set )
, .egress_wbo_error_inject_2_done_set ( egress_wbo_error_inject_2_done_set )
, .egress_wbo_error_inject_1_done_set ( egress_wbo_error_inject_1_done_set )
, .egress_wbo_error_inject_0_done_set ( egress_wbo_error_inject_0_done_set )
, .egress_error_inject_h0_done_set ( egress_error_inject_h0_done_set )
, .egress_error_inject_l0_done_set ( egress_error_inject_l0_done_set )
, .egress_error_inject_h1_done_set ( egress_error_inject_h1_done_set )
, .egress_error_inject_l1_done_set ( egress_error_inject_l1_done_set )
) ;

////////////////////////////////////////////////////////////////////////////////////////////////////
//top level for CIAL & WD logic
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ~ hqm_gated_rst_n ) begin
      dir_cfg_wd_load_cg_f <=  '0 ;
      ldb_cfg_wd_load_cg_f <= '0 ;
      hqm_chp_int_dir_cg_f <= '0 ;
      hqm_chp_int_ldb_cg_f <= '0 ;
      cfg_hqm_chp_int_armed_ldb_cg_f <= '0;
      cfg_hqm_chp_int_armed_dir_cg_f <= '0;
  end else begin
      dir_cfg_wd_load_cg_f <= dir_cfg_wd_load_cg_nxt ;
      ldb_cfg_wd_load_cg_f <= ldb_cfg_wd_load_cg_nxt ;
      hqm_chp_int_dir_cg_f <= hqm_chp_int_dir_cg_nxt ;
      hqm_chp_int_ldb_cg_f <= hqm_chp_int_ldb_cg_nxt ;
      cfg_hqm_chp_int_armed_ldb_cg_f <= cfg_hqm_chp_int_armed_ldb_cg_nxt ;
      cfg_hqm_chp_int_armed_dir_cg_f <= cfg_hqm_chp_int_armed_dir_cg_nxt ;
  end
end

always_comb begin
  for ( int i_cq = 0 ; i_cq < HQM_NUM_LB_CQ ; i_cq = i_cq + 1 ) begin
    cfg_int_en_tim_ldb [ i_cq ] = hqm_chp_target_cfg_ldb_cq_int_enb_reg_f [   ( i_cq * 2 )      +: 1 ] ;
    cfg_int_en_depth_ldb [ i_cq ] = hqm_chp_target_cfg_ldb_cq_int_enb_reg_f [ ( ( i_cq * 2 ) + 1 ) +: 1 ] ;
  end
  for ( int i_cq = 0 ; i_cq < HQM_NUM_DIR_CQ ; i_cq = i_cq + 1 ) begin
      cfg_int_en_tim_dir [ i_cq ] = hqm_chp_target_cfg_dir_cq_int_enb_reg_f [   ( i_cq * 2 )      +: 1 ] ;
      cfg_int_en_depth_dir [ i_cq ] = hqm_chp_target_cfg_dir_cq_int_enb_reg_f [ ( ( i_cq * 2 ) + 1 ) +: 1 ] ;
  end
end
// power clock gate
assign cfg_hqm_chp_int_armed_ldb_cg_nxt = ( pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] ||
                                     pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ]
                                   ) ;

assign cfg_hqm_chp_int_armed_dir_cg_nxt = ( 
                                     pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] ||
                                     pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ]
                                   ) ;

// create 1 clock delayed version of write signal to cial regs. It is delayed because this signal is used for clock gating and we want the
// updated data

assign hqm_chp_int_ldb_cg_nxt = pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] ;

assign hqm_chp_int_dir_cg_nxt = pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] ;

assign dir_cfg_wd_load_cg_nxt = pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] |
                                                                                             
                                pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] ;

assign ldb_cfg_wd_load_cg_nxt = pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] |
                                pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] |
                                pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] ;

assign hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_nxt = hqm_chp_int_armed_ldb[ 63 : 32 ] ;
assign cfg_hqm_chp_int_armed_ldb[ 63 : 32 ] = hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_f ;
assign hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_v = load_cg_ldb ;
assign hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_nxt = hqm_chp_int_armed_ldb[ 31 : 0 ] ;
assign cfg_hqm_chp_int_armed_ldb[ 31 : 0 ] = hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_f ;
assign hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_v = load_cg_ldb ;






assign hqm_chp_target_cfg_dir_cq_intr_armed0_reg_nxt = hqm_chp_int_armed_dir[ 31 : 0 ] ;
assign cfg_hqm_chp_int_armed_dir[ 31 : 0 ] = hqm_chp_target_cfg_dir_cq_intr_armed0_reg_f ;
assign hqm_chp_target_cfg_dir_cq_intr_armed0_reg_v = load_cg_dir ;
assign hqm_chp_target_cfg_ldb_wd_disable_reg_f [ 63 : 32 ] = hqm_chp_target_cfg_ldb_wd_disable1_reg_f ;
assign hqm_chp_target_cfg_ldb_wd_disable_reg_f [ 31 : 0 ] = hqm_chp_target_cfg_ldb_wd_disable0_reg_f ;
assign hqm_chp_target_cfg_ldb_wd_disable1_reg_nxt = hqm_chp_target_cfg_ldb_wd_disable_reg_nxt [ 63 : 32 ] ;
assign hqm_chp_target_cfg_ldb_wd_disable0_reg_nxt = hqm_chp_target_cfg_ldb_wd_disable_reg_nxt [ 31 : 0 ] ;
assign hqm_chp_target_cfg_ldb_wdrt_0_status = ldb_wdrt_status [ 31 : 0 ] ;
assign hqm_chp_target_cfg_ldb_wdrt_1_status = ldb_wdrt_status [ 63 : 32 ] ;
assign hqm_chp_target_cfg_dir_wdrt_0_status = dir_wdrt_status [ 31 : 0 ] ;

// START comment out this code section for NUM_DIR_CQ 32
/* */ 
assign hqm_chp_target_cfg_dir_cq_intr_armed1_reg_nxt = hqm_chp_int_armed_dir[ 63 : 32 ] ;
assign cfg_hqm_chp_int_armed_dir[ 63 : 32 ] = hqm_chp_target_cfg_dir_cq_intr_armed1_reg_f ;
assign hqm_chp_target_cfg_dir_cq_intr_armed1_reg_v = load_cg_dir ;
assign hqm_chp_target_cfg_dir_wd_irq1_status = dir_wd_irq [ 63 : 32 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_run_timer1_status = hqm_chp_int_run_dir [ 63 : 32 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_expired1_status = hqm_chp_int_expired_dir [ 63 : 32 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_urgent1_status = hqm_chp_int_urgent_dir [ 63 : 32 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_irq1_status = hqm_chp_int_irq_dir [ 63 : 32 ] ;
assign hqm_chp_target_cfg_dir_wdto_1_reg_nxt = dir_wdto_nxt [ 63 : 32 ] ;
assign dir_wdto_f_nc [ 63 : 32 ] = hqm_chp_target_cfg_dir_wdto_1_reg_f ;
assign hqm_chp_target_cfg_dir_wdto_1_reg_load = dir_wdto_v ;
assign hqm_chp_target_cfg_dir_wd_disable_reg_f [ 63 : 32 ] = hqm_chp_target_cfg_dir_wd_disable1_reg_f ;
assign hqm_chp_target_cfg_dir_wd_disable1_reg_nxt = hqm_chp_target_cfg_dir_wd_disable_reg_nxt [ 63 : 32 ] ;
assign hqm_chp_target_cfg_dir_wdrt_1_status = dir_wdrt_status [ 63 : 32 ] ;
/* */
// END comment out this code section for NUM_DIR_CQ 32

// START comment out this code section for NUM_DIR_CQ 32 or 64
/* 
assign hqm_chp_target_cfg_dir_cq_intr_armed2_reg_nxt = hqm_chp_int_armed_dir[ 95 : 64 ] ;
assign cfg_hqm_chp_int_armed_dir[ 95 : 64 ] = hqm_chp_target_cfg_dir_cq_intr_armed2_reg_f ;
assign hqm_chp_target_cfg_dir_cq_intr_armed2_reg_v = load_cg_dir ;
assign hqm_chp_target_cfg_dir_wd_irq2_status = dir_wd_irq [ 95 : 64 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_run_timer2_status = hqm_chp_int_run_dir [ 95 : 64 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_expired2_status = hqm_chp_int_expired_dir [ 95 : 64 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_urgent2_status = hqm_chp_int_urgent_dir [ 95 : 64 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_irq2_status = hqm_chp_int_irq_dir [ 95 : 64 ] ;
assign hqm_chp_target_cfg_dir_wdto_2_reg_nxt = dir_wdto_nxt [ 95 : 64 ] ;
assign dir_wdto_f_nc [ 95 : 64 ] = hqm_chp_target_cfg_dir_wdto_2_reg_f ;
assign hqm_chp_target_cfg_dir_wdto_2_reg_load = dir_wdto_v ;
assign hqm_chp_target_cfg_dir_wd_disable_reg_f [ 95 : 64 ] = hqm_chp_target_cfg_dir_wd_disable2_reg_f ;
assign hqm_chp_target_cfg_dir_wd_disable2_reg_nxt = hqm_chp_target_cfg_dir_wd_disable_reg_nxt [ 95 : 64 ] ;
assign hqm_chp_target_cfg_dir_wdrt_2_status = dir_wdrt_status [ 95 : 64 ] ;
*/
// END comment out this code section for NUM_DIR_CQ 32 or 64

assign hqm_chp_target_cfg_ldb_wd_irq1_status = ldb_wd_irq [ 63 : 32 ] ;
assign hqm_chp_target_cfg_ldb_wd_irq0_status = ldb_wd_irq [ 31 : 0 ] ;
assign hqm_chp_target_cfg_dir_wd_irq0_status = dir_wd_irq [ 31 : 0 ] ;

assign hqm_chp_target_cfg_ldb_cq_intr_run_timer1_status = hqm_chp_int_run_ldb [ 63 : 32 ] ;
assign hqm_chp_target_cfg_ldb_cq_intr_run_timer0_status = hqm_chp_int_run_ldb [ 31 : 0 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_run_timer0_status = hqm_chp_int_run_dir [ 31 : 0 ] ;

assign hqm_chp_target_cfg_ldb_cq_intr_expired1_status = hqm_chp_int_expired_ldb [ 63 : 32 ] ;
assign hqm_chp_target_cfg_ldb_cq_intr_expired0_status = hqm_chp_int_expired_ldb [ 31 : 0 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_expired0_status = hqm_chp_int_expired_dir [ 31 : 0 ] ;

assign hqm_chp_target_cfg_ldb_cq_intr_urgent1_status = hqm_chp_int_urgent_ldb [ 63 : 32 ] ;
assign hqm_chp_target_cfg_ldb_cq_intr_urgent0_status = hqm_chp_int_urgent_ldb [ 31 : 0 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_urgent0_status = hqm_chp_int_urgent_dir [ 31 : 0 ] ;

assign hqm_chp_target_cfg_ldb_cq_intr_irq1_status = hqm_chp_int_irq_ldb [ 63 : 32 ] ;
assign hqm_chp_target_cfg_ldb_cq_intr_irq0_status = hqm_chp_int_irq_ldb [ 31 : 0 ] ;
assign hqm_chp_target_cfg_dir_cq_intr_irq0_status = hqm_chp_int_irq_dir [ 31 : 0 ] ;

assign hqm_chp_target_cfg_ldb_wdto_1_reg_nxt = ldb_wdto_nxt [ 63 : 32 ] ;
assign ldb_wdto_f_nc [ 63 : 32 ] = hqm_chp_target_cfg_ldb_wdto_1_reg_f ;
assign hqm_chp_target_cfg_ldb_wdto_1_reg_load = ldb_wdto_v ;
assign hqm_chp_target_cfg_ldb_wdto_0_reg_nxt = ldb_wdto_nxt [ 31 : 0 ] ;
assign ldb_wdto_f_nc [ 31 : 0 ] = hqm_chp_target_cfg_ldb_wdto_0_reg_f ;
assign hqm_chp_target_cfg_ldb_wdto_0_reg_load = ldb_wdto_v ;
                                                                                  
assign hqm_chp_target_cfg_dir_wdto_0_reg_nxt = dir_wdto_nxt [ 31 : 0 ] ;
assign dir_wdto_f_nc [ 31 : 0 ] = hqm_chp_target_cfg_dir_wdto_0_reg_f ;
assign hqm_chp_target_cfg_dir_wdto_0_reg_load = dir_wdto_v ;

assign hqm_chp_target_cfg_dir_wd_disable_reg_f [ 31 : 0 ] = hqm_chp_target_cfg_dir_wd_disable0_reg_f ;
assign hqm_chp_target_cfg_dir_wd_disable0_reg_nxt = hqm_chp_target_cfg_dir_wd_disable_reg_nxt [ 31 : 0 ] ;

assign cfg_access_idle_req_cial_dir = cfg_req_idlepipe;
assign cfg_access_idle_req_cial_ldb = cfg_req_idlepipe;

logic [ ( 1 * 1 * HQM_NUM_DIR_CQ ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_mask_tie_low ;
logic [ ( 1 * 1 * HQM_NUM_LB_CQ ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_mask_tie_low ;

assign hqm_chp_target_cfg_dir_cq_int_mask_tie_low = 'h0 ;
assign hqm_chp_target_cfg_ldb_cq_int_mask_tie_low = 'h0 ;

hqm_chp_cial_wrap # (
   .HQM_NUM_DIR_CQ ( HQM_NUM_DIR_CQ )
 , .HQM_NUM_LDB_CQ ( HQM_NUM_LB_CQ )
 , .HQM_CQ_TIM_WIDTH_INTERVAL ( 8 )
 , .HQM_CQ_TIM_WIDTH_THRESHOLD ( 14 )
 , .HQM_CQ_TIM_TYPE  ( 0 )// 0-int timer

) i_hqm_chp_cial_wrap (
   .hqm_gated_clk                             ( hqm_gated_clk)
 , .hqm_gated_rst_n                           ( hqm_gated_rst_n)

 , .rst_prep                                  ( rst_prep)

 , .enq_dir_excep                             ( enq_dir_excep)
 , .sch_dir_excep                             ( sch_dir_excep)
 , .enq_ldb_excep                             ( enq_ldb_excep)
 , .sch_ldb_excep                             ( sch_ldb_excep)
 , .hqm_chp_int_tim_pipe_status_dir_pnc       ( hqm_chp_int_tim_pipe_status_dir_pnc)
 , .hqm_chp_int_tim_pipe_status_ldb_pnc       ( hqm_chp_int_tim_pipe_status_ldb_pnc)
 , .hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f ( hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f)
 , .hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f ( hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f)

 , .cfg_dir_cq_int_mask                       ( hqm_chp_target_cfg_dir_cq_int_mask_tie_low )
 , .cfg_ldb_cq_int_mask                       ( hqm_chp_target_cfg_ldb_cq_int_mask_tie_low )

 , .cfg_hqm_chp_int_armed_dir                 ( cfg_hqm_chp_int_armed_dir)
 , .cfg_int_en_depth_dir                      ( cfg_int_en_depth_dir )
 , .cfg_int_en_tim_dir                        ( cfg_int_en_tim_dir )

 , .hqm_chp_int_urgent_dir                    ( hqm_chp_int_urgent_dir )
 , .hqm_chp_int_expired_dir                   ( hqm_chp_int_expired_dir )
 , .hqm_chp_int_armed_dir                     ( hqm_chp_int_armed_dir)
 , .hqm_chp_int_run_dir                       ( hqm_chp_int_run_dir )
 , .hqm_chp_int_irq_dir                                ( hqm_chp_int_irq_dir)

 , .cfg_hqm_chp_int_armed_ldb                 ( cfg_hqm_chp_int_armed_ldb)
 , .cfg_int_en_depth_ldb                      ( cfg_int_en_depth_ldb )
 , .cfg_int_en_tim_ldb                        ( cfg_int_en_tim_ldb )

 , .hqm_chp_int_urgent_ldb                             ( hqm_chp_int_urgent_ldb )
 , .hqm_chp_int_expired_ldb                            ( hqm_chp_int_expired_ldb )
 , .hqm_chp_int_armed_ldb                     ( hqm_chp_int_armed_ldb)
 , .hqm_chp_int_run_ldb                       ( hqm_chp_int_run_ldb )
 , .hqm_chp_int_irq_ldb                                ( hqm_chp_int_irq_ldb)

 , .idle_cial_timer_report_control            ( idle_cial_timer_report_control )

 , .smon_thresh_irq_dir                       ( smon_thresh_irq_dir)
 , .smon_thresh_irq_ldb                       ( smon_thresh_irq_ldb)
 , .smon_timer_irq_dir                        ( smon_timer_irq_dir )
 , .smon_timer_irq_ldb                        ( smon_timer_irq_ldb )

 , .load_cg_dir                               ( load_cg_dir)
 , .load_cg_ldb                               ( load_cg_ldb)

 , .cfg_cial_clock_gate_control               ( cfg_cial_clock_gate_control)
 , .hqm_chp_int_dir_cg_f                      ( hqm_chp_int_dir_cg_f)
 , .hqm_chp_int_ldb_cg_f                      ( hqm_chp_int_ldb_cg_f)

 , .interrupt_w_req_valid                     ( interrupt_w_req_valid)
 , .interrupt_w_req                           ( interrupt_w_req)
 , .interrupt_w_req_ready                     ( interrupt_w_req_ready)

 , .cfg_hqm_chp_int_armed_ldb_cg_f            ( cfg_hqm_chp_int_armed_ldb_cg_f)
 , .cfg_hqm_chp_int_armed_dir_cg_f            ( cfg_hqm_chp_int_armed_dir_cg_f)

 , .func_count_rmw_pipe_dir_mem_we            ( func_count_rmw_pipe_dir_mem_we)
 , .func_count_rmw_pipe_dir_mem_waddr         ( func_count_rmw_pipe_dir_mem_waddr)
 , .func_count_rmw_pipe_dir_mem_wdata         ( func_count_rmw_pipe_dir_mem_wdata)
 , .func_count_rmw_pipe_dir_mem_re            ( func_count_rmw_pipe_dir_mem_re)
 , .func_count_rmw_pipe_dir_mem_raddr         ( func_count_rmw_pipe_dir_mem_raddr)
 , .func_count_rmw_pipe_dir_mem_rdata         ( func_count_rmw_pipe_dir_mem_rdata)

 , .func_threshold_r_pipe_dir_mem_we          ( func_threshold_r_pipe_dir_mem_we)
 , .func_threshold_r_pipe_dir_mem_addr        ( func_threshold_r_pipe_dir_mem_addr)
 , .func_threshold_r_pipe_dir_mem_wdata       ( func_threshold_r_pipe_dir_mem_wdata)
 , .func_threshold_r_pipe_dir_mem_re          ( func_threshold_r_pipe_dir_mem_re)
 , .func_threshold_r_pipe_dir_mem_rdata       ( func_threshold_r_pipe_dir_mem_rdata)

 , .cfg_access_idle_req_dir                   ( cfg_access_idle_req_cial_dir)             //
 , .hqm_chp_tim_pipe_idle_dir                 ( hqm_chp_tim_pipe_idle_cial_dir)           // O

 , .func_count_rmw_pipe_ldb_mem_we            ( func_count_rmw_pipe_ldb_mem_we)
 , .func_count_rmw_pipe_ldb_mem_waddr         ( func_count_rmw_pipe_ldb_mem_waddr)
 , .func_count_rmw_pipe_ldb_mem_wdata         ( func_count_rmw_pipe_ldb_mem_wdata)
 , .func_count_rmw_pipe_ldb_mem_re            ( func_count_rmw_pipe_ldb_mem_re)
 , .func_count_rmw_pipe_ldb_mem_raddr         ( func_count_rmw_pipe_ldb_mem_raddr)
 , .func_count_rmw_pipe_ldb_mem_rdata         ( func_count_rmw_pipe_ldb_mem_rdata)

 , .func_threshold_r_pipe_ldb_mem_we          ( func_threshold_r_pipe_ldb_mem_we)
 , .func_threshold_r_pipe_ldb_mem_addr        ( func_threshold_r_pipe_ldb_mem_addr)
 , .func_threshold_r_pipe_ldb_mem_wdata       ( func_threshold_r_pipe_ldb_mem_wdata)
 , .func_threshold_r_pipe_ldb_mem_re          ( func_threshold_r_pipe_ldb_mem_re)
 , .func_threshold_r_pipe_ldb_mem_rdata       ( func_threshold_r_pipe_ldb_mem_rdata)

 , .cfg_access_idle_req_ldb                   ( cfg_access_idle_req_cial_ldb)
 , .hqm_chp_tim_pipe_idle_ldb                 ( hqm_chp_tim_pipe_idle_cial_ldb)           // O

 , .hqm_chp_int_idle                          ( hqm_chp_int_idle)

 , .cial_tx_sync_idle                         ( cial_tx_sync_idle)

 , .cial_tx_sync_status_pnc                   ( cial_tx_sync_status_pnc)

 , .cq_timer_threshold_parity_err_dir         ( cq_timer_threshold_parity_err_dir_cial )
 , .cq_timer_threshold_parity_err_ldb         ( cq_timer_threshold_parity_err_ldb_cial )

 , .sch_excep_parity_check_err_dir            ( sch_excep_parity_check_err_dir_cial )
 , .sch_excep_parity_check_err_ldb            ( sch_excep_parity_check_err_ldb_cial )

) ;

hqm_chp_cwdi_wrap # (
   .HQM_NUM_DIR_CQ ( HQM_NUM_DIR_CQ )
 , .HQM_NUM_LDB_CQ ( HQM_NUM_LB_CQ )
 , .HQM_CQ_TIM_WIDTH_INTERVAL ( 28 )
 , .HQM_CQ_TIM_WIDTH_THRESHOLD ( 8 )
 , .HQM_CQ_TIM_TYPE ( 1 ) ) i_hqm_chp_cwdi_wrap (

    .hqm_gated_clk                                  ( hqm_gated_clk)
   ,.hqm_gated_rst_n                                ( hqm_gated_rst_n)

   ,.rst_prep                                       ( rst_prep )

   ,.enq_ldb_excep                                  ( enq_ldb_excep)
   ,.sch_ldb_excep                                  ( sch_ldb_excep)
   ,.enq_dir_excep                                  ( enq_dir_excep)
   ,.sch_dir_excep                                  ( sch_dir_excep)

  ,.hqm_pgcb_clk                                    ( hqm_pgcb_clk)
  ,.hqm_pgcb_rst_n                                  ( hqm_pgcb_rst_n)

  ,.ldb_cfg_wd_load_cg_f                            ( ldb_cfg_wd_load_cg_f)
  ,.dir_cfg_wd_load_cg_f                            ( dir_cfg_wd_load_cg_f)

  ,.hqm_pgcb_rst_n_done                             ( hqm_pgcb_rst_n_start)
  ,.idle_cwdi_timer_report_control                  ( idle_cwdi_timer_report_control)


  // - begin
  // ldb
  ,.ldb_hw_pgcb_init_done                           ( ldb_hw_pgcb_init_done)

  ,.ldb_wd_irq                                      ( ldb_wd_irq)

  ,.ldb_cfg_wd_disable_reg_f                        ( hqm_chp_target_cfg_ldb_wd_disable_reg_f )
  ,.ldb_cfg_wd_disable_reg_nxt                      ( hqm_chp_target_cfg_ldb_wd_disable_reg_nxt )

  ,.hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f          ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f)
  ,.hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt        ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt)

  ,.func_count_rmw_pipe_wd_ldb_mem_we               ( func_count_rmw_pipe_wd_ldb_mem_we)
  ,.func_count_rmw_pipe_wd_ldb_mem_waddr            ( func_count_rmw_pipe_wd_ldb_mem_waddr)
  ,.func_count_rmw_pipe_wd_ldb_mem_wdata            ( func_count_rmw_pipe_wd_ldb_mem_wdata)
  ,.func_count_rmw_pipe_wd_ldb_mem_re               ( func_count_rmw_pipe_wd_ldb_mem_re)
  ,.func_count_rmw_pipe_wd_ldb_mem_raddr            ( func_count_rmw_pipe_wd_ldb_mem_raddr)
  ,.func_count_rmw_pipe_wd_ldb_mem_rdata            ( func_count_rmw_pipe_wd_ldb_mem_rdata)

  ,.pf_count_rmw_pipe_wd_ldb_mem_re                 ( pf_count_rmw_pipe_wd_ldb_mem_re)
  ,.pf_count_rmw_pipe_wd_ldb_mem_raddr              ( pf_count_rmw_pipe_wd_ldb_mem_raddr)
  ,.pf_count_rmw_pipe_wd_ldb_mem_waddr              ( pf_count_rmw_pipe_wd_ldb_mem_waddr)
  ,.pf_count_rmw_pipe_wd_ldb_mem_wdata              ( pf_count_rmw_pipe_wd_ldb_mem_wdata)
  ,.pf_count_rmw_pipe_wd_ldb_mem_we                 ( pf_count_rmw_pipe_wd_ldb_mem_we)
  ,.pf_count_rmw_pipe_wd_ldb_mem_rdata              ( pf_count_rmw_pipe_wd_ldb_mem_rdata)

  ,.hqm_chp_wd_ldb_pipe_status_pnc                  ( hqm_chp_wd_ldb_pipe_status_pnc)

  ,.hqm_chp_target_cfg_ldb_wd_enb_interval_update_v ( hqm_chp_target_cfg_ldb_wd_enb_interval_update_v_f)
  ,.hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f    ( hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f)

  ,.hqm_chp_target_cfg_ldb_wd_threshold_update_v    ( hqm_chp_target_cfg_ldb_wd_threshold_update_v_f)
  ,.hqm_chp_target_cfg_ldb_wd_threshold_reg_f       ( hqm_chp_target_cfg_ldb_wd_threshold_reg_f[7:0])

  // dir
  ,.dir_hw_pgcb_init_done                           ( dir_hw_pgcb_init_done)

  ,.dir_wd_irq                                      ( dir_wd_irq)

  ,.dir_cfg_wd_disable_reg_f                        ( hqm_chp_target_cfg_dir_wd_disable_reg_f )
  ,.dir_cfg_wd_disable_reg_nxt                      ( hqm_chp_target_cfg_dir_wd_disable_reg_nxt )

  ,.hqm_chp_target_cfg_dir_cq_wd_enb_reg_f          ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_f )
  ,.hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt        ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt )

  ,.func_count_rmw_pipe_wd_dir_mem_we               ( func_count_rmw_pipe_wd_dir_mem_we)
  ,.func_count_rmw_pipe_wd_dir_mem_waddr            ( func_count_rmw_pipe_wd_dir_mem_waddr)
  ,.func_count_rmw_pipe_wd_dir_mem_wdata            ( func_count_rmw_pipe_wd_dir_mem_wdata)
  ,.func_count_rmw_pipe_wd_dir_mem_re               ( func_count_rmw_pipe_wd_dir_mem_re)
  ,.func_count_rmw_pipe_wd_dir_mem_raddr            ( func_count_rmw_pipe_wd_dir_mem_raddr)
  ,.func_count_rmw_pipe_wd_dir_mem_rdata            ( func_count_rmw_pipe_wd_dir_mem_rdata)

  ,.pf_count_rmw_pipe_wd_dir_mem_re                 ( pf_count_rmw_pipe_wd_dir_mem_re)
  ,.pf_count_rmw_pipe_wd_dir_mem_raddr              ( pf_count_rmw_pipe_wd_dir_mem_raddr)
  ,.pf_count_rmw_pipe_wd_dir_mem_waddr              ( pf_count_rmw_pipe_wd_dir_mem_waddr)
  ,.pf_count_rmw_pipe_wd_dir_mem_wdata              ( pf_count_rmw_pipe_wd_dir_mem_wdata)
  ,.pf_count_rmw_pipe_wd_dir_mem_we                 ( pf_count_rmw_pipe_wd_dir_mem_we)
  ,.pf_count_rmw_pipe_wd_dir_mem_rdata              ( pf_count_rmw_pipe_wd_dir_mem_rdata)

  ,.hqm_chp_wd_dir_pipe_status_pnc                  ( hqm_chp_wd_dir_pipe_status_pnc)

  ,.hqm_chp_target_cfg_dir_wd_enb_interval_update_v ( hqm_chp_target_cfg_dir_wd_enb_interval_update_v_f)
  ,.hqm_chp_target_cfg_dir_wd_enb_interval_reg_f    ( hqm_chp_target_cfg_dir_wd_enb_interval_reg_f)

  ,.hqm_chp_target_cfg_dir_wd_threshold_update_v    ( hqm_chp_target_cfg_dir_wd_threshold_update_v_f)
  ,.hqm_chp_target_cfg_dir_wd_threshold_reg_f       ( hqm_chp_target_cfg_dir_wd_threshold_reg_f[7:0])

  // - end
  ,.hqm_flr_prep                                    ( rst_prep )
  ,.wd_clkreq                                       ( wd_clkreq )

  ,.cwdi_interrupt_w_req_valid                      ( cwdi_interrupt_w_req_valid)
  ,.cwdi_interrupt_w_req_ready                      ( cwdi_interrupt_w_req_ready)

  ,.dir_wdto_nxt                                    ( dir_wdto_nxt)
  ,.dir_wdto_v                                      ( dir_wdto_v)
  ,.ldb_wdto_nxt                                    ( ldb_wdto_nxt)
  ,.ldb_wdto_v                                      ( ldb_wdto_v)

  ,.wd_irq_idle                                     ( wd_irq_idle)
  ,.wd_tx_sync_status                               ( wd_tx_sync_status)
  ,.wd_tx_sync_idle                                 ( wd_tx_sync_idle)

  ,.cq_timer_threshold_parity_err_dir               ( cq_timer_threshold_parity_err_dir_cwdi )
  ,.cq_timer_threshold_parity_err_ldb               ( cq_timer_threshold_parity_err_ldb_cwdi )

  ,.sch_excep_parity_check_err_dir                  ( sch_excep_parity_check_err_dir_cwdi )
  ,.sch_excep_parity_check_err_ldb                  ( sch_excep_parity_check_err_ldb_cwdi )

  ,.hqm_chp_target_cfg_dir_wdrt_status              ( dir_wdrt_status ) 
  ,.hqm_chp_target_cfg_ldb_wdrt_status              ( ldb_wdrt_status ) 

) ;


always_comb begin
  chp_alarm_down_v = chp_alarm_down_v_pre ;
  chp_alarm_down_ready_post = chp_alarm_down_ready ;
  if ( chp_alarm_down_v_pre & ( chp_alarm_down_data.cls == 2'd1 ) & ~hqm_chp_target_cfg_chp_csr_control_reg_f[16] ) begin
    chp_alarm_down_v = 1'b0 ;
    chp_alarm_down_ready_post = 1'b1 ;
  end

  hqm_chp_target_cfg_chp_correctible_count_inc = chp_alarm_down_v_pre & chp_alarm_down_ready_post & ( chp_alarm_down_data.cls == 2'd1 ) ;

  egress_wbo_error_inject_3_done_nxt = egress_wbo_error_inject_3_done_set | egress_wbo_error_inject_3_done_f ;
  egress_wbo_error_inject_2_done_nxt = egress_wbo_error_inject_2_done_set | egress_wbo_error_inject_2_done_f ;
  egress_wbo_error_inject_1_done_nxt = egress_wbo_error_inject_1_done_set | egress_wbo_error_inject_1_done_f ;
  egress_wbo_error_inject_0_done_nxt = egress_wbo_error_inject_0_done_set | egress_wbo_error_inject_0_done_f ;
  enqpipe_flid_parity_error_inject_done_nxt = enqpipe_flid_parity_error_inject_done_set | enqpipe_flid_parity_error_inject_done_f ;
  ingress_flid_parity_error_inject_0_done_nxt = ingress_flid_parity_error_inject_0_done_set | ingress_flid_parity_error_inject_0_done_f ;
  ingress_flid_parity_error_inject_1_done_nxt = ingress_flid_parity_error_inject_1_done_set | ingress_flid_parity_error_inject_1_done_f ;
  ingress_error_inject_h0_done_nxt = ingress_error_inject_h0_done_set | ingress_error_inject_h0_done_f ;
  ingress_error_inject_l0_done_nxt = ingress_error_inject_l0_done_set | ingress_error_inject_l0_done_f ;
  ingress_error_inject_h1_done_nxt = ingress_error_inject_h1_done_set | ingress_error_inject_h1_done_f ;
  ingress_error_inject_l1_done_nxt = ingress_error_inject_l1_done_set | ingress_error_inject_l1_done_f ;
  egress_error_inject_h0_done_nxt = egress_error_inject_h0_done_set | egress_error_inject_h0_done_f ;
  egress_error_inject_l0_done_nxt = egress_error_inject_l0_done_set | egress_error_inject_l0_done_f ;
  egress_error_inject_h1_done_nxt = egress_error_inject_h1_done_set | egress_error_inject_h1_done_f ;
  egress_error_inject_l1_done_nxt = egress_error_inject_l1_done_set | egress_error_inject_l1_done_f ;
  schpipe_error_inject_h0_done_nxt = schpipe_error_inject_h0_done_set | schpipe_error_inject_h0_done_f ;
  schpipe_error_inject_l0_done_nxt = schpipe_error_inject_l0_done_set | schpipe_error_inject_l0_done_f ;
  schpipe_error_inject_h1_done_nxt = schpipe_error_inject_h1_done_set | schpipe_error_inject_h1_done_f ;
  schpipe_error_inject_l1_done_nxt = schpipe_error_inject_l1_done_set | schpipe_error_inject_l1_done_f ;
  enqpipe_error_inject_h0_done_nxt = enqpipe_error_inject_h0_done_set | enqpipe_error_inject_h0_done_f ;
  enqpipe_error_inject_l0_done_nxt = enqpipe_error_inject_l0_done_set | enqpipe_error_inject_l0_done_f ;
  enqpipe_error_inject_h1_done_nxt = enqpipe_error_inject_h1_done_set | enqpipe_error_inject_h1_done_f ;
  enqpipe_error_inject_l1_done_nxt = enqpipe_error_inject_l1_done_set | enqpipe_error_inject_l1_done_f ;
  
  if ( pfcsr_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] ) begin
    if ( pfcsr_cfg_req.wdata [ 22 ] ) begin
      egress_wbo_error_inject_3_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 21 ] ) begin
      egress_wbo_error_inject_2_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 20 ] ) begin
      egress_wbo_error_inject_1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 19 ] ) begin
      egress_wbo_error_inject_0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 18 ] ) begin
      enqpipe_flid_parity_error_inject_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 17 ] ) begin
      ingress_flid_parity_error_inject_1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 16 ] ) begin
      ingress_flid_parity_error_inject_0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 15 ] ) begin
      ingress_error_inject_h1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 14 ] ) begin
      ingress_error_inject_l1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 13 ] ) begin
      ingress_error_inject_h0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 12 ] ) begin
      ingress_error_inject_l0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 11 ] ) begin
      egress_error_inject_h1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 10 ] ) begin
      egress_error_inject_l1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 9 ] ) begin
      egress_error_inject_h0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 8 ] ) begin
      egress_error_inject_l0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 7 ] ) begin
      schpipe_error_inject_h1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 6 ] ) begin
      schpipe_error_inject_l1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 5 ] ) begin
      schpipe_error_inject_h0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 4 ] ) begin
      schpipe_error_inject_l0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 3 ] ) begin
      enqpipe_error_inject_h1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 2 ] ) begin
      enqpipe_error_inject_l1_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 1 ] ) begin
      enqpipe_error_inject_h0_done_nxt = 1'd0 ;
    end
    if ( pfcsr_cfg_req.wdata [ 0 ] ) begin
      enqpipe_error_inject_l0_done_nxt = 1'd0 ;
    end
  end
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    egress_wbo_error_inject_3_done_f <= 1'd0 ;
    egress_wbo_error_inject_2_done_f <= 1'd0 ;
    egress_wbo_error_inject_1_done_f <= 1'd0 ;
    egress_wbo_error_inject_0_done_f <= 1'd0 ;
    enqpipe_flid_parity_error_inject_done_f <= 1'd0 ;
    ingress_flid_parity_error_inject_1_done_f <= 1'd0 ;
    ingress_flid_parity_error_inject_0_done_f <= 1'd0 ;
    ingress_error_inject_h1_done_f <= 1'd0 ;
    ingress_error_inject_l1_done_f <= 1'd0 ;
    ingress_error_inject_h0_done_f <= 1'd0 ;
    ingress_error_inject_l0_done_f <= 1'd0 ;
    egress_error_inject_h0_done_f <= 1'd0 ;
    egress_error_inject_l0_done_f <= 1'd0 ;
    egress_error_inject_h1_done_f <= 1'd0 ;
    egress_error_inject_l1_done_f <= 1'd0 ;
    schpipe_error_inject_h0_done_f <= 1'd0 ;
    schpipe_error_inject_l0_done_f <= 1'd0 ;
    schpipe_error_inject_h1_done_f <= 1'd0 ;
    schpipe_error_inject_l1_done_f <= 1'd0 ;
    enqpipe_error_inject_h0_done_f <= 1'd0 ;
    enqpipe_error_inject_l0_done_f <= 1'd0 ;
    enqpipe_error_inject_h1_done_f <= 1'd0 ;
    enqpipe_error_inject_l1_done_f <= 1'd0 ;
  end
  else begin
    egress_wbo_error_inject_3_done_f <= egress_wbo_error_inject_3_done_nxt ;
    egress_wbo_error_inject_2_done_f <= egress_wbo_error_inject_2_done_nxt ;
    egress_wbo_error_inject_1_done_f <= egress_wbo_error_inject_1_done_nxt ;
    egress_wbo_error_inject_0_done_f <= egress_wbo_error_inject_0_done_nxt ;
    enqpipe_flid_parity_error_inject_done_f <= enqpipe_flid_parity_error_inject_done_nxt ;
    ingress_flid_parity_error_inject_1_done_f <= ingress_flid_parity_error_inject_1_done_nxt ;
    ingress_flid_parity_error_inject_0_done_f <= ingress_flid_parity_error_inject_0_done_nxt ;
    ingress_error_inject_h1_done_f <= ingress_error_inject_h1_done_nxt ;
    ingress_error_inject_l1_done_f <= ingress_error_inject_l1_done_nxt ;
    ingress_error_inject_h0_done_f <= ingress_error_inject_h0_done_nxt ;
    ingress_error_inject_l0_done_f <= ingress_error_inject_l0_done_nxt ;
    egress_error_inject_h0_done_f <= egress_error_inject_h0_done_nxt ;
    egress_error_inject_l0_done_f <= egress_error_inject_l0_done_nxt ;
    egress_error_inject_h1_done_f <= egress_error_inject_h1_done_nxt ;
    egress_error_inject_l1_done_f <= egress_error_inject_l1_done_nxt ;
    schpipe_error_inject_h0_done_f <= schpipe_error_inject_h0_done_nxt ;
    schpipe_error_inject_l0_done_f <= schpipe_error_inject_l0_done_nxt ;
    schpipe_error_inject_h1_done_f <= schpipe_error_inject_h1_done_nxt ;
    schpipe_error_inject_l1_done_f <= schpipe_error_inject_l1_done_nxt ;
    enqpipe_error_inject_h0_done_f <= enqpipe_error_inject_h0_done_nxt ;
    enqpipe_error_inject_l0_done_f <= enqpipe_error_inject_l0_done_nxt ;
    enqpipe_error_inject_h1_done_f <= enqpipe_error_inject_h1_done_nxt ;
    enqpipe_error_inject_l1_done_f <= enqpipe_error_inject_l1_done_nxt ;
  end
end

// LINTRA 70036 

chp_freelist_t pf_freelist_0_rdata_nc ;
chp_freelist_t pf_freelist_1_rdata_nc ;
chp_freelist_t pf_freelist_2_rdata_nc ;
chp_freelist_t pf_freelist_3_rdata_nc ;
chp_freelist_t pf_freelist_4_rdata_nc ;
chp_freelist_t pf_freelist_5_rdata_nc ;
chp_freelist_t pf_freelist_6_rdata_nc ;
chp_freelist_t pf_freelist_7_rdata_nc ;
logic sr_freelist_0_error_nc ;
logic sr_freelist_1_error_nc ;
logic sr_freelist_2_error_nc ;
logic sr_freelist_3_error_nc ;
logic sr_freelist_4_error_nc ;
logic sr_freelist_5_error_nc ;
logic sr_freelist_6_error_nc ;
logic sr_freelist_7_error_nc ;

hist_list_mf_t pf_hist_list_rdata_nc ;
chp_hist_list_minmax_mem_t pf_hist_list_minmax_rdata_nc ;
chp_cq_token_depth_select_t pf_ldb_cq_token_depth_select_rdata_nc ;
cfg_dir_cq_intcfg_t pf_dir_cq_intr_thresh_rdata_nc ;
logic [ ( 14 ) - 1 : 0 ] pf_threshold_r_pipe_ldb_mem_rdata_nc ;
chp_ldb_cq_depth_t pf_ldb_cq_depth_rdata_nc ;
outbound_hcw_fifo_t pf_outbound_hcw_fifo_mem_rdata_nc ;
logic [ ( 14 ) - 1 : 0 ] pf_threshold_r_pipe_dir_mem_rdata_nc ;
chp_dir_cq_depth_t pf_dir_cq_depth_rdata_nc ;
logic [ ( 200 ) - 1 : 0 ] pf_chp_sys_tx_fifo_mem_rdata_nc ;
logic [ ( 16 ) - 1 : 0 ] pf_count_rmw_pipe_dir_mem_rdata_nc ;
chp_hist_list_ptr_mem_t pf_hist_list_ptr_rdata_nc ;
chp_ord_qid_sn_map_t pf_ord_qid_sn_map_rdata_nc ;
chp_cq_token_depth_select_t pf_dir_cq_token_depth_select_rdata_nc ;
chp_dir_cq_wp_t pf_dir_cq_wptr_rdata_nc ;
logic [ ( 74 ) - 1 : 0 ] pf_chp_lsp_ap_cmp_fifo_mem_rdata_nc ;
logic [ ( 201 ) - 1 : 0 ] pf_chp_chp_rop_hcw_fifo_mem_rdata_nc ;
chp_ldb_cq_wp_t pf_ldb_cq_wptr_rdata_nc ;
logic [ ( 160 ) - 1 : 0 ] pf_hcw_enq_w_rx_sync_mem_rdata_nc ;
logic [ ( 177 ) - 1 : 0 ] pf_qed_chp_sch_rx_sync_mem_rdata_nc ;
logic [ ( 16 ) - 1 : 0 ] pf_count_rmw_pipe_ldb_mem_rdata_nc ;
cfg_ldb_cq_intcfg_t pf_ldb_cq_intr_thresh_rdata_nc ;
logic [ ( 26 ) - 1 : 0 ] pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata_nc ;
logic [ ( 2 ) - 1 : 0 ] pf_cmp_id_chk_enbl_mem_rdata_nc ;
logic [ ( 179 ) - 1 : 0 ] pf_aqed_chp_sch_rx_sync_mem_rdata_nc ;
logic [ ( 197 ) - 1 : 0 ] pf_qed_to_cq_fifo_mem_rdata_nc ;
logic [ ( 29 ) - 1 : 0 ] pf_chp_lsp_tok_fifo_mem_rdata_nc ;
chp_ord_qid_sn_t pf_ord_qid_sn_rdata_nc ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_atq_to_atm_count_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_frag_replayed_count_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_correctible_count_count_nc ;
logic hqm_chp_target_cfg_chp_smon_smon_interrupt_nc ;
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_00_reg_f_nc ;
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_01_reg_f_nc ;
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_02_reg_f_nc ;
logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_counter_chp_error_drop_count_nc ;
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_syndrome_00_syndrome_data_nc ;
logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_syndrome_01_syndrome_data_nc ;

assign pf_freelist_0_rdata_nc = pf_freelist_0_rdata ;
assign pf_freelist_1_rdata_nc = pf_freelist_1_rdata ;
assign pf_freelist_2_rdata_nc = pf_freelist_2_rdata ;
assign pf_freelist_3_rdata_nc = pf_freelist_3_rdata ;
assign pf_freelist_4_rdata_nc = pf_freelist_4_rdata ;
assign pf_freelist_5_rdata_nc = pf_freelist_5_rdata ;
assign pf_freelist_6_rdata_nc = pf_freelist_6_rdata ;
assign pf_freelist_7_rdata_nc = pf_freelist_7_rdata ;

assign sr_freelist_0_error_nc = sr_freelist_0_error ;
assign sr_freelist_1_error_nc = sr_freelist_1_error ;
assign sr_freelist_2_error_nc = sr_freelist_2_error ;
assign sr_freelist_3_error_nc = sr_freelist_3_error ;
assign sr_freelist_4_error_nc = sr_freelist_4_error ;
assign sr_freelist_5_error_nc = sr_freelist_5_error ;
assign sr_freelist_6_error_nc = sr_freelist_6_error ;
assign sr_freelist_7_error_nc = sr_freelist_7_error ;

assign pf_hist_list_rdata_nc = pf_hist_list_rdata ;
assign pf_hist_list_minmax_rdata_nc = pf_hist_list_minmax_rdata ;
assign pf_ldb_cq_token_depth_select_rdata_nc = pf_ldb_cq_token_depth_select_rdata ;
assign pf_dir_cq_intr_thresh_rdata_nc = pf_dir_cq_intr_thresh_rdata ;
assign pf_threshold_r_pipe_ldb_mem_rdata_nc = pf_threshold_r_pipe_ldb_mem_rdata ;
assign pf_ldb_cq_depth_rdata_nc = pf_ldb_cq_depth_rdata ;
assign pf_outbound_hcw_fifo_mem_rdata_nc = pf_outbound_hcw_fifo_mem_rdata ;
assign pf_threshold_r_pipe_dir_mem_rdata_nc = pf_threshold_r_pipe_dir_mem_rdata ;
assign pf_dir_cq_depth_rdata_nc = pf_dir_cq_depth_rdata ;
assign pf_chp_sys_tx_fifo_mem_rdata_nc = pf_chp_sys_tx_fifo_mem_rdata ;
assign pf_count_rmw_pipe_dir_mem_rdata_nc = pf_count_rmw_pipe_dir_mem_rdata ;
assign pf_hist_list_ptr_rdata_nc = pf_hist_list_ptr_rdata ;
assign pf_ord_qid_sn_map_rdata_nc = pf_ord_qid_sn_map_rdata ;
assign pf_dir_cq_token_depth_select_rdata_nc = pf_dir_cq_token_depth_select_rdata ;
assign pf_dir_cq_wptr_rdata_nc = pf_dir_cq_wptr_rdata ;
assign pf_chp_lsp_ap_cmp_fifo_mem_rdata_nc = pf_chp_lsp_ap_cmp_fifo_mem_rdata ;
assign pf_chp_chp_rop_hcw_fifo_mem_rdata_nc = pf_chp_chp_rop_hcw_fifo_mem_rdata ;
assign pf_ldb_cq_wptr_rdata_nc = pf_ldb_cq_wptr_rdata ;
assign pf_hcw_enq_w_rx_sync_mem_rdata_nc = pf_hcw_enq_w_rx_sync_mem_rdata ;
assign pf_qed_chp_sch_rx_sync_mem_rdata_nc = pf_qed_chp_sch_rx_sync_mem_rdata ;
assign pf_count_rmw_pipe_ldb_mem_rdata_nc = pf_count_rmw_pipe_ldb_mem_rdata ;
assign pf_ldb_cq_intr_thresh_rdata_nc = pf_ldb_cq_intr_thresh_rdata ;
assign pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata_nc = pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata ;
assign pf_cmp_id_chk_enbl_mem_rdata_nc = pf_cmp_id_chk_enbl_mem_rdata ;
assign pf_aqed_chp_sch_rx_sync_mem_rdata_nc = pf_aqed_chp_sch_rx_sync_mem_rdata ;
assign pf_qed_to_cq_fifo_mem_rdata_nc = pf_qed_to_cq_fifo_mem_rdata ;
assign pf_chp_lsp_tok_fifo_mem_rdata_nc = pf_chp_lsp_tok_fifo_mem_rdata ;
assign pf_ord_qid_sn_rdata_nc = pf_ord_qid_sn_rdata ;
assign cfg_req_read_nc = cfg_req_read ;
assign hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count_nc = hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count ;
assign hqm_chp_target_cfg_chp_cnt_atq_to_atm_count_nc = hqm_chp_target_cfg_chp_cnt_atq_to_atm_count ;
assign hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count_nc = hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count ;
assign hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count_nc = hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count ;
assign hqm_chp_target_cfg_chp_cnt_frag_replayed_count_nc = hqm_chp_target_cfg_chp_cnt_frag_replayed_count ;
assign hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count_nc = hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count ;
assign hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count_nc = hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count ;
assign hqm_chp_target_cfg_chp_correctible_count_count_nc = hqm_chp_target_cfg_chp_correctible_count_count ;
assign hqm_chp_target_cfg_chp_smon_smon_interrupt_nc = hqm_chp_target_cfg_chp_smon_smon_interrupt ;
assign hqm_chp_target_cfg_control_diagnostic_00_reg_f_nc = hqm_chp_target_cfg_control_diagnostic_00_reg_f ;
assign hqm_chp_target_cfg_control_diagnostic_01_reg_f_nc = hqm_chp_target_cfg_control_diagnostic_01_reg_f ;
assign hqm_chp_target_cfg_control_diagnostic_02_reg_f_nc = hqm_chp_target_cfg_control_diagnostic_02_reg_f ;
assign hqm_chp_target_cfg_counter_chp_error_drop_count_nc = hqm_chp_target_cfg_counter_chp_error_drop_count ;
assign hqm_chp_target_cfg_syndrome_00_syndrome_data_nc = hqm_chp_target_cfg_syndrome_00_syndrome_data ;
assign hqm_chp_target_cfg_syndrome_01_syndrome_data_nc = hqm_chp_target_cfg_syndrome_01_syndrome_data ;

endmodule // hqm_credit_hist_pipe_core
// 
