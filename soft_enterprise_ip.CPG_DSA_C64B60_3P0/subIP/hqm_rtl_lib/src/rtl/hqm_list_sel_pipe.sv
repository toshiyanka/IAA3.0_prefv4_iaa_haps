//-----------------------------------------------------------------------------------------------------
//
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
// hqm_list_sel_pipe
//
// The list select pipe consists of 5 essentially independent pipelines:
// - LBARB      : Load-balanced arbitration/scheduling, including CQ selection, for Unordered, Ordered
//                and ATM requests.  ATM scheduling splits off earlier in the pipe for performance,
//                and works off sched/ready list status provided by AP rather than seeing enqueues directly.
// - ATQ        : ATQ -> ATM requests
// - DIRENQ     : Directed scheduling based on Directed enqueue requests
// - LBRPL      : Load-balanced reorder -> replay requests
// - DIRRPL     : Directed reorder -> replay requests
//
// 
// The overall flow is:
//                                       +----------+
//                               +-+     |          |
// chp_lsp_cmp         --------->|A|---->|          |
// rop_lsp_reordercmp  --------->|R|     |          |
//                               |B|     |          |-------------------------------> lsp_nalb_sch_unoord
//                               +-+     |  LBARB   |
// chp_lsp_token       --+-------------->|          |
//                       |               |          |
// +----+                |       +-+     |          |
// |    |  rlst_*      --|------>|A|---->|          |
// | AP |  slst_*      --|------>|R|     +--+-------+                      +----+
// +----+                |       |B|        |                              |    |
// nalb_lsp_enq_lb     --|---+-->| |        +-------------- lsp_ap_atm --> | AP |
//                       |   |   +-+                                       +----+
//                       |   |           +----------+
//                       |   +---------->| ATQ      |-------------------------------> lsp_nalb_sch_atq
// aqed_lsp_sch        --|-------------->|          |
//                       |               +----------+
//                       |        
//                       |               +----------+
// nalb_lsp_enq_rorply --|-------------->| LBRPL    |-------------------------------> lsp_nalb_sch_rorply
//                       |               +----------+
//                       |
//                       |               +----------+
//                       +-------------->| DIRENQ   |-------------------------------> lsp_dp_sch_dir
// dp_lsp_enq_dir      ----------------->|          |
//                                       +----------+
//                                
//                                       +----------+
// dp_lsp_enq_rorply   ----------------->| DIRRPL   |-------------------------------> lsp_dp_sch_rorply
//                                       +----------+
//
// rtl organization is:
//   LBARB
//   ATQ
//   DIRENQ
//   LBRPL
//   DIRRPL
//-----------------------------------------------------------------------------------------------------

module hqm_list_sel_pipe
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(

  input  logic hqm_gated_clk
, input  logic hqm_inp_gated_clk
, output logic hqm_proc_clk_en_lsp
, input  logic hqm_rst_prep_lsp
, input  logic hqm_gated_rst_b_lsp
, input  logic hqm_inp_gated_rst_b_lsp

, input  logic hqm_rst_prep_atm
, input  logic hqm_gated_rst_b_atm
, input  logic hqm_inp_gated_rst_b_atm

, input  logic hqm_gated_rst_b_start_lsp
, input  logic hqm_gated_rst_b_active_lsp
, output logic hqm_gated_rst_b_done_lsp

, input  logic hqm_gated_rst_b_start_atm
, input  logic hqm_gated_rst_b_active_atm
, output logic hqm_gated_rst_b_done_atm

, input logic aqed_clk_idle
, input logic aqed_unit_idle
, output logic aqed_clk_enable

, output logic                  lsp_unit_idle
, output logic                  lsp_unit_pipeidle
, output logic                  lsp_reset_done

, output logic                  ap_unit_idle
, output logic                  ap_unit_pipeidle
, output logic                  ap_reset_done

// CFG interface
, input  logic                  lsp_cfg_req_up_read
, input  logic                  lsp_cfg_req_up_write
, input  logic [BITS_CFG_REQ_T-1:0]     lsp_cfg_req_up
, input  logic                  lsp_cfg_rsp_up_ack
, input  logic [BITS_CFG_RSP_T-1:0]     lsp_cfg_rsp_up
, output logic                  lsp_cfg_req_down_read
, output logic                  lsp_cfg_req_down_write
, output logic [BITS_CFG_REQ_T-1:0]     lsp_cfg_req_down
, output logic                  lsp_cfg_rsp_down_ack
, output logic [BITS_CFG_RSP_T-1:0]     lsp_cfg_rsp_down

, input  logic                  ap_cfg_req_up_read
, input  logic                  ap_cfg_req_up_write
, input  logic [BITS_CFG_REQ_T-1:0]     ap_cfg_req_up
, input  logic                  ap_cfg_rsp_up_ack
, input  logic [BITS_CFG_RSP_T-1:0]     ap_cfg_rsp_up
, output logic                  ap_cfg_req_down_read
, output logic                  ap_cfg_req_down_write
, output logic [BITS_CFG_REQ_T-1:0]     ap_cfg_req_down
, output logic                  ap_cfg_rsp_down_ack
, output logic [BITS_CFG_RSP_T-1:0]     ap_cfg_rsp_down

// interrupt interface
, input  logic                  lsp_alarm_up_v
, output logic                  lsp_alarm_up_ready
, input  logic [BITS_AW_ALARM_T-1:0]    lsp_alarm_up_data

, output logic                  lsp_alarm_down_v
, input  logic                  lsp_alarm_down_ready
, output logic [BITS_AW_ALARM_T-1:0]    lsp_alarm_down_data

, input  logic                  ap_alarm_up_v
, output logic                  ap_alarm_up_ready
, input  logic [BITS_AW_ALARM_T-1:0]    ap_alarm_up_data

, output logic                  ap_alarm_down_v
, input  logic                  ap_alarm_down_ready
, output logic [BITS_AW_ALARM_T-1:0]    ap_alarm_down_data


, output logic                           lsp_aqed_cmp_v
, input  logic                           lsp_aqed_cmp_ready
, output logic [BITS_LSP_AQED_CMP_T-1:0]    lsp_aqed_cmp_data

, input  logic                           aqed_lsp_dec_fid_cnt_v

// chp lsp PALB (Power Aware Load Balancing) interface
, input  logic [ HQM_NUM_LB_CQ - 1 : 0 ] chp_lsp_ldb_cq_off

// chp_lsp_cmp interface
, input  logic                  chp_lsp_cmp_v
, output logic                  chp_lsp_cmp_ready
, input  logic [BITS_CHP_LSP_CMP_T-1:0]     chp_lsp_cmp_data

// qed_lsp_deq interface
, input  logic                  qed_lsp_deq_v
, input  logic [BITS_QED_LSP_DEQ_T-1:0]     qed_lsp_deq_data

// aqed_lsp_deq interface
, input  logic                  aqed_lsp_deq_v
, input  logic [BITS_AQED_LSP_DEQ_T-1:0]     aqed_lsp_deq_data

// chp_lsp_token interface
, input  logic                  chp_lsp_token_v
, output logic                  chp_lsp_token_ready
, input  logic [BITS_CHP_LSP_TOKEN_T-1:0]   chp_lsp_token_data

// lsp_nalb_sch_unoord interface
, output logic                  lsp_nalb_sch_unoord_v
, input  logic                  lsp_nalb_sch_unoord_ready
, output logic [BITS_LSP_NALB_SCH_UNOORD_T-1:0]     lsp_nalb_sch_unoord_data

// lsp_dp_sch_dir interface
, output logic                  lsp_dp_sch_dir_v
, input  logic                  lsp_dp_sch_dir_ready
, output logic [BITS_LSP_DP_SCH_DIR_T-1:0]  lsp_dp_sch_dir_data

// lsp_nalb_sch_rorply interface
, output logic                  lsp_nalb_sch_rorply_v
, input  logic                  lsp_nalb_sch_rorply_ready
, output logic [BITS_LSP_NALB_SCH_RORPLY_T-1:0]     lsp_nalb_sch_rorply_data

// lsp_dp_sch_rorply interface
, output logic                  lsp_dp_sch_rorply_v
, input  logic                  lsp_dp_sch_rorply_ready
, output logic [BITS_LSP_DP_SCH_RORPLY_T-1:0]   lsp_dp_sch_rorply_data

// lsp_nalb_sch_atq interface
, output logic                  lsp_nalb_sch_atq_v
, input  logic                  lsp_nalb_sch_atq_ready
, output logic [BITS_LSP_NALB_SCH_ATQ_T-1:0]    lsp_nalb_sch_atq_data

// nalb_lsp_enq_lb interface
, input  logic                  nalb_lsp_enq_lb_v
, output logic                  nalb_lsp_enq_lb_ready
, input  logic [BITS_NALB_LSP_ENQ_LB_T-1:0]     nalb_lsp_enq_lb_data

// nalb_lsp_enq_rorpl interface
, input  logic                  nalb_lsp_enq_rorply_v
, output logic                  nalb_lsp_enq_rorply_ready
, input  logic [BITS_NALB_LSP_ENQ_RORPLY_T-1:0]     nalb_lsp_enq_rorply_data

// dp_lsp_enq_dir interface
, input  logic                  dp_lsp_enq_dir_v
, output logic                  dp_lsp_enq_dir_ready
, input  logic [BITS_DP_LSP_ENQ_DIR_T-1:0]  dp_lsp_enq_dir_data

// dp_lsp_enq_rorply interface
, input  logic                  dp_lsp_enq_rorply_v
, output logic                  dp_lsp_enq_rorply_ready
, input  logic [BITS_DP_LSP_ENQ_RORPLY_T-1:0]   dp_lsp_enq_rorply_data

// rop_lsp_reordercmp interface
, input  logic                  rop_lsp_reordercmp_v
, output logic                  rop_lsp_reordercmp_ready
, input  logic [BITS_ROP_LSP_REORDERCMP_T-1:0]  rop_lsp_reordercmp_data

// aqed_lsp_sch interface
, input  logic                  aqed_lsp_sch_v
, output logic                  aqed_lsp_sch_ready
, input  logic [BITS_AQED_LSP_SCH_T-1:0]    aqed_lsp_sch_data

// ap_aqed interface
, output logic                  ap_aqed_v
, input  logic                  ap_aqed_ready
, output logic [BITS_AP_AQED_T-1:0]     ap_aqed_data

// aqed_ap_enq interface
, input  logic                  aqed_ap_enq_v
, output logic                  aqed_ap_enq_ready
, input  logic [BITS_AQED_AP_ENQ_T-1:0]     aqed_ap_enq_data

// aqed_lsp_fid_cnt_upd interface
, input logic                   aqed_lsp_fid_cnt_upd_v
, input logic                   aqed_lsp_fid_cnt_upd_val
, input logic [6:0]             aqed_lsp_fid_cnt_upd_qid
, input logic                           aqed_lsp_stop_atqatm

// Spares

, input  logic [1:0]            spare_qed_lsp
, input  logic [1:0]            spare_sys_lsp
    
, output logic [1:0]            spare_lsp_qed
, output logic [1:0]            spare_lsp_sys

// No SRAMs

// BEGIN HQM_MEMPORT_DECL hqm_list_sel_pipe_core
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_re
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_rclk
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_lsp_deq_fifo_mem_raddr
    ,output logic [(       5)-1:0] rf_aqed_lsp_deq_fifo_mem_waddr
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_we
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_wclk
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_wclk_rst_n
    ,output logic [(       9)-1:0] rf_aqed_lsp_deq_fifo_mem_wdata
    ,input  logic [(       9)-1:0] rf_aqed_lsp_deq_fifo_mem_rdata

    ,output logic                  rf_atm_cmp_fifo_mem_re
    ,output logic                  rf_atm_cmp_fifo_mem_rclk
    ,output logic                  rf_atm_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_atm_cmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_atm_cmp_fifo_mem_waddr
    ,output logic                  rf_atm_cmp_fifo_mem_we
    ,output logic                  rf_atm_cmp_fifo_mem_wclk
    ,output logic                  rf_atm_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      55)-1:0] rf_atm_cmp_fifo_mem_wdata
    ,input  logic [(      55)-1:0] rf_atm_cmp_fifo_mem_rdata

    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_re
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_rclk
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_waddr
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_we
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_wclk
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_wdata
    ,input  logic [(      16)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_cq2priov_mem_re
    ,output logic                  rf_cfg_cq2priov_mem_rclk
    ,output logic                  rf_cfg_cq2priov_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_mem_waddr
    ,output logic                  rf_cfg_cq2priov_mem_we
    ,output logic                  rf_cfg_cq2priov_mem_wclk
    ,output logic                  rf_cfg_cq2priov_mem_wclk_rst_n
    ,output logic [(      33)-1:0] rf_cfg_cq2priov_mem_wdata
    ,input  logic [(      33)-1:0] rf_cfg_cq2priov_mem_rdata

    ,output logic                  rf_cfg_cq2priov_odd_mem_re
    ,output logic                  rf_cfg_cq2priov_odd_mem_rclk
    ,output logic                  rf_cfg_cq2priov_odd_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_odd_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_odd_mem_waddr
    ,output logic                  rf_cfg_cq2priov_odd_mem_we
    ,output logic                  rf_cfg_cq2priov_odd_mem_wclk
    ,output logic                  rf_cfg_cq2priov_odd_mem_wclk_rst_n
    ,output logic [(      33)-1:0] rf_cfg_cq2priov_odd_mem_wdata
    ,input  logic [(      33)-1:0] rf_cfg_cq2priov_odd_mem_rdata

    ,output logic                  rf_cfg_cq2qid_0_mem_re
    ,output logic                  rf_cfg_cq2qid_0_mem_rclk
    ,output logic                  rf_cfg_cq2qid_0_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_mem_waddr
    ,output logic                  rf_cfg_cq2qid_0_mem_we
    ,output logic                  rf_cfg_cq2qid_0_mem_wclk
    ,output logic                  rf_cfg_cq2qid_0_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_0_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_0_mem_rdata

    ,output logic                  rf_cfg_cq2qid_0_odd_mem_re
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_rclk
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_odd_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_odd_mem_waddr
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_we
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_wclk
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_0_odd_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_0_odd_mem_rdata

    ,output logic                  rf_cfg_cq2qid_1_mem_re
    ,output logic                  rf_cfg_cq2qid_1_mem_rclk
    ,output logic                  rf_cfg_cq2qid_1_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_mem_waddr
    ,output logic                  rf_cfg_cq2qid_1_mem_we
    ,output logic                  rf_cfg_cq2qid_1_mem_wclk
    ,output logic                  rf_cfg_cq2qid_1_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_1_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_1_mem_rdata

    ,output logic                  rf_cfg_cq2qid_1_odd_mem_re
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_rclk
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_odd_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_odd_mem_waddr
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_we
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_wclk
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_1_odd_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_1_odd_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_re
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_we
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_wdata
    ,input  logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_re
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_we
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_wdata
    ,input  logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_re
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_we
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_wdata
    ,input  logic [(       5)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_re
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_wu_limit_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_wu_limit_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_we
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_cfg_cq_ldb_wu_limit_mem_wdata
    ,input  logic [(      17)-1:0] rf_cfg_cq_ldb_wu_limit_mem_rdata

    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_re
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_rclk
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_waddr
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_we
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_wclk
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_wdata
    ,input  logic [(      16)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_re
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_rclk
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_waddr
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_we
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_wclk
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_wdata
    ,input  logic [(      16)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_re
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_rclk
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_aqed_active_limit_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_aqed_active_limit_mem_waddr
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_we
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_wclk
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_cfg_qid_aqed_active_limit_mem_wdata
    ,input  logic [(      13)-1:0] rf_cfg_qid_aqed_active_limit_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_re
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_rclk
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_waddr
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_we
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_wclk
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_wdata
    ,input  logic [(      13)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_re
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_rclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_waddr
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_we
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_wclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n
    ,output logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_wdata
    ,input  logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_re
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_rclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_waddr
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_we
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_wclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n
    ,output logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_wdata
    ,input  logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_rdata

    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_re
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_we
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      73)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata
    ,input  logic [(      73)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_re
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_we
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      25)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_wdata
    ,input  logic [(      25)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_rdata

    ,output logic                  rf_cq_atm_pri_arbindex_mem_re
    ,output logic                  rf_cq_atm_pri_arbindex_mem_rclk
    ,output logic                  rf_cq_atm_pri_arbindex_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cq_atm_pri_arbindex_mem_raddr
    ,output logic [(       5)-1:0] rf_cq_atm_pri_arbindex_mem_waddr
    ,output logic                  rf_cq_atm_pri_arbindex_mem_we
    ,output logic                  rf_cq_atm_pri_arbindex_mem_wclk
    ,output logic                  rf_cq_atm_pri_arbindex_mem_wclk_rst_n
    ,output logic [(      96)-1:0] rf_cq_atm_pri_arbindex_mem_wdata
    ,input  logic [(      96)-1:0] rf_cq_atm_pri_arbindex_mem_rdata

    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_re
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_rclk
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_dir_tot_sch_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_dir_tot_sch_cnt_mem_waddr
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_we
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_wclk
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_cq_dir_tot_sch_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_cq_dir_tot_sch_cnt_mem_rdata

    ,output logic                  rf_cq_ldb_inflight_count_mem_re
    ,output logic                  rf_cq_ldb_inflight_count_mem_rclk
    ,output logic                  rf_cq_ldb_inflight_count_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_inflight_count_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_inflight_count_mem_waddr
    ,output logic                  rf_cq_ldb_inflight_count_mem_we
    ,output logic                  rf_cq_ldb_inflight_count_mem_wclk
    ,output logic                  rf_cq_ldb_inflight_count_mem_wclk_rst_n
    ,output logic [(      15)-1:0] rf_cq_ldb_inflight_count_mem_wdata
    ,input  logic [(      15)-1:0] rf_cq_ldb_inflight_count_mem_rdata

    ,output logic                  rf_cq_ldb_token_count_mem_re
    ,output logic                  rf_cq_ldb_token_count_mem_rclk
    ,output logic                  rf_cq_ldb_token_count_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_token_count_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_token_count_mem_waddr
    ,output logic                  rf_cq_ldb_token_count_mem_we
    ,output logic                  rf_cq_ldb_token_count_mem_wclk
    ,output logic                  rf_cq_ldb_token_count_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_cq_ldb_token_count_mem_wdata
    ,input  logic [(      13)-1:0] rf_cq_ldb_token_count_mem_rdata

    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_re
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_rclk
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_tot_sch_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_tot_sch_cnt_mem_waddr
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_we
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_wclk
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_cq_ldb_tot_sch_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_cq_ldb_tot_sch_cnt_mem_rdata

    ,output logic                  rf_cq_ldb_wu_count_mem_re
    ,output logic                  rf_cq_ldb_wu_count_mem_rclk
    ,output logic                  rf_cq_ldb_wu_count_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_wu_count_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_wu_count_mem_waddr
    ,output logic                  rf_cq_ldb_wu_count_mem_we
    ,output logic                  rf_cq_ldb_wu_count_mem_wclk
    ,output logic                  rf_cq_ldb_wu_count_mem_wclk_rst_n
    ,output logic [(      19)-1:0] rf_cq_ldb_wu_count_mem_wdata
    ,input  logic [(      19)-1:0] rf_cq_ldb_wu_count_mem_rdata

    ,output logic                  rf_cq_nalb_pri_arbindex_mem_re
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_rclk
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cq_nalb_pri_arbindex_mem_raddr
    ,output logic [(       5)-1:0] rf_cq_nalb_pri_arbindex_mem_waddr
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_we
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_wclk
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_wclk_rst_n
    ,output logic [(      96)-1:0] rf_cq_nalb_pri_arbindex_mem_wdata
    ,input  logic [(      96)-1:0] rf_cq_nalb_pri_arbindex_mem_rdata

    ,output logic                  rf_dir_enq_cnt_mem_re
    ,output logic                  rf_dir_enq_cnt_mem_rclk
    ,output logic                  rf_dir_enq_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_enq_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_dir_enq_cnt_mem_waddr
    ,output logic                  rf_dir_enq_cnt_mem_we
    ,output logic                  rf_dir_enq_cnt_mem_wclk
    ,output logic                  rf_dir_enq_cnt_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_dir_enq_cnt_mem_wdata
    ,input  logic [(      17)-1:0] rf_dir_enq_cnt_mem_rdata

    ,output logic                  rf_dir_tok_cnt_mem_re
    ,output logic                  rf_dir_tok_cnt_mem_rclk
    ,output logic                  rf_dir_tok_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_tok_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_dir_tok_cnt_mem_waddr
    ,output logic                  rf_dir_tok_cnt_mem_we
    ,output logic                  rf_dir_tok_cnt_mem_wclk
    ,output logic                  rf_dir_tok_cnt_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_dir_tok_cnt_mem_wdata
    ,input  logic [(      13)-1:0] rf_dir_tok_cnt_mem_rdata

    ,output logic                  rf_dir_tok_lim_mem_re
    ,output logic                  rf_dir_tok_lim_mem_rclk
    ,output logic                  rf_dir_tok_lim_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_tok_lim_mem_raddr
    ,output logic [(       6)-1:0] rf_dir_tok_lim_mem_waddr
    ,output logic                  rf_dir_tok_lim_mem_we
    ,output logic                  rf_dir_tok_lim_mem_wclk
    ,output logic                  rf_dir_tok_lim_mem_wclk_rst_n
    ,output logic [(       8)-1:0] rf_dir_tok_lim_mem_wdata
    ,input  logic [(       8)-1:0] rf_dir_tok_lim_mem_rdata

    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(       8)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata
    ,input  logic [(       8)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata

    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      23)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic [(      23)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,output logic                  rf_enq_nalb_fifo_mem_re
    ,output logic                  rf_enq_nalb_fifo_mem_rclk
    ,output logic                  rf_enq_nalb_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_enq_nalb_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_enq_nalb_fifo_mem_waddr
    ,output logic                  rf_enq_nalb_fifo_mem_we
    ,output logic                  rf_enq_nalb_fifo_mem_wclk
    ,output logic                  rf_enq_nalb_fifo_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_enq_nalb_fifo_mem_wdata
    ,input  logic [(      10)-1:0] rf_enq_nalb_fifo_mem_rdata

    ,output logic                  rf_ldb_token_rtn_fifo_mem_re
    ,output logic                  rf_ldb_token_rtn_fifo_mem_rclk
    ,output logic                  rf_ldb_token_rtn_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ldb_token_rtn_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_ldb_token_rtn_fifo_mem_waddr
    ,output logic                  rf_ldb_token_rtn_fifo_mem_we
    ,output logic                  rf_ldb_token_rtn_fifo_mem_wclk
    ,output logic                  rf_ldb_token_rtn_fifo_mem_wclk_rst_n
    ,output logic [(      25)-1:0] rf_ldb_token_rtn_fifo_mem_wdata
    ,input  logic [(      25)-1:0] rf_ldb_token_rtn_fifo_mem_rdata

    ,output logic                  rf_nalb_cmp_fifo_mem_re
    ,output logic                  rf_nalb_cmp_fifo_mem_rclk
    ,output logic                  rf_nalb_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_nalb_cmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_nalb_cmp_fifo_mem_waddr
    ,output logic                  rf_nalb_cmp_fifo_mem_we
    ,output logic                  rf_nalb_cmp_fifo_mem_wclk
    ,output logic                  rf_nalb_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      18)-1:0] rf_nalb_cmp_fifo_mem_wdata
    ,input  logic [(      18)-1:0] rf_nalb_cmp_fifo_mem_rdata

    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata
    ,input  logic [(      10)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata

    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      27)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic [(      27)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,output logic                  rf_nalb_sel_nalb_fifo_mem_re
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_rclk
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_nalb_sel_nalb_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_nalb_sel_nalb_fifo_mem_waddr
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_we
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_wclk
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_wclk_rst_n
    ,output logic [(      27)-1:0] rf_nalb_sel_nalb_fifo_mem_wdata
    ,input  logic [(      27)-1:0] rf_nalb_sel_nalb_fifo_mem_rdata

    ,output logic                  rf_qed_lsp_deq_fifo_mem_re
    ,output logic                  rf_qed_lsp_deq_fifo_mem_rclk
    ,output logic                  rf_qed_lsp_deq_fifo_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qed_lsp_deq_fifo_mem_raddr
    ,output logic [(       5)-1:0] rf_qed_lsp_deq_fifo_mem_waddr
    ,output logic                  rf_qed_lsp_deq_fifo_mem_we
    ,output logic                  rf_qed_lsp_deq_fifo_mem_wclk
    ,output logic                  rf_qed_lsp_deq_fifo_mem_wclk_rst_n
    ,output logic [(       9)-1:0] rf_qed_lsp_deq_fifo_mem_wdata
    ,input  logic [(       9)-1:0] rf_qed_lsp_deq_fifo_mem_rdata

    ,output logic                  rf_qid_aqed_active_count_mem_re
    ,output logic                  rf_qid_aqed_active_count_mem_rclk
    ,output logic                  rf_qid_aqed_active_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_aqed_active_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_aqed_active_count_mem_waddr
    ,output logic                  rf_qid_aqed_active_count_mem_we
    ,output logic                  rf_qid_aqed_active_count_mem_wclk
    ,output logic                  rf_qid_aqed_active_count_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_qid_aqed_active_count_mem_wdata
    ,input  logic [(      14)-1:0] rf_qid_aqed_active_count_mem_rdata

    ,output logic                  rf_qid_atm_active_mem_re
    ,output logic                  rf_qid_atm_active_mem_rclk
    ,output logic                  rf_qid_atm_active_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_atm_active_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_atm_active_mem_waddr
    ,output logic                  rf_qid_atm_active_mem_we
    ,output logic                  rf_qid_atm_active_mem_wclk
    ,output logic                  rf_qid_atm_active_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_atm_active_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_atm_active_mem_rdata

    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_re
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_rclk
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_atm_tot_enq_cnt_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_atm_tot_enq_cnt_mem_waddr
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_we
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_wclk
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_qid_atm_tot_enq_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_qid_atm_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_atq_enqueue_count_mem_re
    ,output logic                  rf_qid_atq_enqueue_count_mem_rclk
    ,output logic                  rf_qid_atq_enqueue_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_atq_enqueue_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_atq_enqueue_count_mem_waddr
    ,output logic                  rf_qid_atq_enqueue_count_mem_we
    ,output logic                  rf_qid_atq_enqueue_count_mem_wclk
    ,output logic                  rf_qid_atq_enqueue_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_atq_enqueue_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_atq_enqueue_count_mem_rdata

    ,output logic                  rf_qid_dir_max_depth_mem_re
    ,output logic                  rf_qid_dir_max_depth_mem_rclk
    ,output logic                  rf_qid_dir_max_depth_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_qid_dir_max_depth_mem_raddr
    ,output logic [(       6)-1:0] rf_qid_dir_max_depth_mem_waddr
    ,output logic                  rf_qid_dir_max_depth_mem_we
    ,output logic                  rf_qid_dir_max_depth_mem_wclk
    ,output logic                  rf_qid_dir_max_depth_mem_wclk_rst_n
    ,output logic [(      15)-1:0] rf_qid_dir_max_depth_mem_wdata
    ,input  logic [(      15)-1:0] rf_qid_dir_max_depth_mem_rdata

    ,output logic                  rf_qid_dir_replay_count_mem_re
    ,output logic                  rf_qid_dir_replay_count_mem_rclk
    ,output logic                  rf_qid_dir_replay_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_dir_replay_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_dir_replay_count_mem_waddr
    ,output logic                  rf_qid_dir_replay_count_mem_we
    ,output logic                  rf_qid_dir_replay_count_mem_wclk
    ,output logic                  rf_qid_dir_replay_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_dir_replay_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_dir_replay_count_mem_rdata

    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_re
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_rclk
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_qid_dir_tot_enq_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_qid_dir_tot_enq_cnt_mem_waddr
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_we
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_wclk
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_qid_dir_tot_enq_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_qid_dir_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_ldb_enqueue_count_mem_re
    ,output logic                  rf_qid_ldb_enqueue_count_mem_rclk
    ,output logic                  rf_qid_ldb_enqueue_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_ldb_enqueue_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_ldb_enqueue_count_mem_waddr
    ,output logic                  rf_qid_ldb_enqueue_count_mem_we
    ,output logic                  rf_qid_ldb_enqueue_count_mem_wclk
    ,output logic                  rf_qid_ldb_enqueue_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_ldb_enqueue_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_ldb_enqueue_count_mem_rdata

    ,output logic                  rf_qid_ldb_inflight_count_mem_re
    ,output logic                  rf_qid_ldb_inflight_count_mem_rclk
    ,output logic                  rf_qid_ldb_inflight_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_ldb_inflight_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_ldb_inflight_count_mem_waddr
    ,output logic                  rf_qid_ldb_inflight_count_mem_we
    ,output logic                  rf_qid_ldb_inflight_count_mem_wclk
    ,output logic                  rf_qid_ldb_inflight_count_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_qid_ldb_inflight_count_mem_wdata
    ,input  logic [(      14)-1:0] rf_qid_ldb_inflight_count_mem_rdata

    ,output logic                  rf_qid_ldb_replay_count_mem_re
    ,output logic                  rf_qid_ldb_replay_count_mem_rclk
    ,output logic                  rf_qid_ldb_replay_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_ldb_replay_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_ldb_replay_count_mem_waddr
    ,output logic                  rf_qid_ldb_replay_count_mem_we
    ,output logic                  rf_qid_ldb_replay_count_mem_wclk
    ,output logic                  rf_qid_ldb_replay_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_ldb_replay_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_ldb_replay_count_mem_rdata

    ,output logic                  rf_qid_naldb_max_depth_mem_re
    ,output logic                  rf_qid_naldb_max_depth_mem_rclk
    ,output logic                  rf_qid_naldb_max_depth_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_naldb_max_depth_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_naldb_max_depth_mem_waddr
    ,output logic                  rf_qid_naldb_max_depth_mem_we
    ,output logic                  rf_qid_naldb_max_depth_mem_wclk
    ,output logic                  rf_qid_naldb_max_depth_mem_wclk_rst_n
    ,output logic [(      15)-1:0] rf_qid_naldb_max_depth_mem_wdata
    ,input  logic [(      15)-1:0] rf_qid_naldb_max_depth_mem_rdata

    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_re
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_rclk
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_naldb_tot_enq_cnt_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_naldb_tot_enq_cnt_mem_waddr
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_we
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_wclk
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_qid_naldb_tot_enq_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_qid_naldb_tot_enq_cnt_mem_rdata

    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata
    ,input  logic [(      17)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata

    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_re
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_rclk
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_waddr
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_we
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_wclk
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      35)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_wdata
    ,input  logic [(      35)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_rdata

    ,output logic                  rf_uno_atm_cmp_fifo_mem_re
    ,output logic                  rf_uno_atm_cmp_fifo_mem_rclk
    ,output logic                  rf_uno_atm_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_uno_atm_cmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_uno_atm_cmp_fifo_mem_waddr
    ,output logic                  rf_uno_atm_cmp_fifo_mem_we
    ,output logic                  rf_uno_atm_cmp_fifo_mem_wclk
    ,output logic                  rf_uno_atm_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      20)-1:0] rf_uno_atm_cmp_fifo_mem_wdata
    ,input  logic [(      20)-1:0] rf_uno_atm_cmp_fifo_mem_rdata

// END HQM_MEMPORT_DECL hqm_list_sel_pipe_core
// BEGIN HQM_MEMPORT_DECL hqm_lsp_atm_pipe
    ,output logic                  rf_aqed_qid2cqidix_re
    ,output logic                  rf_aqed_qid2cqidix_rclk
    ,output logic                  rf_aqed_qid2cqidix_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_qid2cqidix_raddr
    ,output logic [(       5)-1:0] rf_aqed_qid2cqidix_waddr
    ,output logic                  rf_aqed_qid2cqidix_we
    ,output logic                  rf_aqed_qid2cqidix_wclk
    ,output logic                  rf_aqed_qid2cqidix_wclk_rst_n
    ,output logic [(     528)-1:0] rf_aqed_qid2cqidix_wdata
    ,input  logic [(     528)-1:0] rf_aqed_qid2cqidix_rdata

    ,output logic                  rf_atm_fifo_ap_aqed_re
    ,output logic                  rf_atm_fifo_ap_aqed_rclk
    ,output logic                  rf_atm_fifo_ap_aqed_rclk_rst_n
    ,output logic [(       4)-1:0] rf_atm_fifo_ap_aqed_raddr
    ,output logic [(       4)-1:0] rf_atm_fifo_ap_aqed_waddr
    ,output logic                  rf_atm_fifo_ap_aqed_we
    ,output logic                  rf_atm_fifo_ap_aqed_wclk
    ,output logic                  rf_atm_fifo_ap_aqed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_atm_fifo_ap_aqed_wdata
    ,input  logic [(      45)-1:0] rf_atm_fifo_ap_aqed_rdata

    ,output logic                  rf_atm_fifo_aqed_ap_enq_re
    ,output logic                  rf_atm_fifo_aqed_ap_enq_rclk
    ,output logic                  rf_atm_fifo_aqed_ap_enq_rclk_rst_n
    ,output logic [(       5)-1:0] rf_atm_fifo_aqed_ap_enq_raddr
    ,output logic [(       5)-1:0] rf_atm_fifo_aqed_ap_enq_waddr
    ,output logic                  rf_atm_fifo_aqed_ap_enq_we
    ,output logic                  rf_atm_fifo_aqed_ap_enq_wclk
    ,output logic                  rf_atm_fifo_aqed_ap_enq_wclk_rst_n
    ,output logic [(      24)-1:0] rf_atm_fifo_aqed_ap_enq_wdata
    ,input  logic [(      24)-1:0] rf_atm_fifo_aqed_ap_enq_rdata

    ,output logic                  rf_fid2cqqidix_re
    ,output logic                  rf_fid2cqqidix_rclk
    ,output logic                  rf_fid2cqqidix_rclk_rst_n
    ,output logic [(      11)-1:0] rf_fid2cqqidix_raddr
    ,output logic [(      11)-1:0] rf_fid2cqqidix_waddr
    ,output logic                  rf_fid2cqqidix_we
    ,output logic                  rf_fid2cqqidix_wclk
    ,output logic                  rf_fid2cqqidix_wclk_rst_n
    ,output logic [(      12)-1:0] rf_fid2cqqidix_wdata
    ,input  logic [(      12)-1:0] rf_fid2cqqidix_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin0_re
    ,output logic                  rf_ll_enq_cnt_s_bin0_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin0_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin0_we
    ,output logic                  rf_ll_enq_cnt_s_bin0_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin0_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin1_re
    ,output logic                  rf_ll_enq_cnt_s_bin1_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin1_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin1_we
    ,output logic                  rf_ll_enq_cnt_s_bin1_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin1_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin2_re
    ,output logic                  rf_ll_enq_cnt_s_bin2_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin2_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin2_we
    ,output logic                  rf_ll_enq_cnt_s_bin2_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin2_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin3_re
    ,output logic                  rf_ll_enq_cnt_s_bin3_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin3_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin3_we
    ,output logic                  rf_ll_enq_cnt_s_bin3_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin3_rdata

    ,output logic                  rf_ll_rdylst_hp_bin0_re
    ,output logic                  rf_ll_rdylst_hp_bin0_rclk
    ,output logic                  rf_ll_rdylst_hp_bin0_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin0_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin0_waddr
    ,output logic                  rf_ll_rdylst_hp_bin0_we
    ,output logic                  rf_ll_rdylst_hp_bin0_wclk
    ,output logic                  rf_ll_rdylst_hp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin0_rdata

    ,output logic                  rf_ll_rdylst_hp_bin1_re
    ,output logic                  rf_ll_rdylst_hp_bin1_rclk
    ,output logic                  rf_ll_rdylst_hp_bin1_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin1_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin1_waddr
    ,output logic                  rf_ll_rdylst_hp_bin1_we
    ,output logic                  rf_ll_rdylst_hp_bin1_wclk
    ,output logic                  rf_ll_rdylst_hp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin1_rdata

    ,output logic                  rf_ll_rdylst_hp_bin2_re
    ,output logic                  rf_ll_rdylst_hp_bin2_rclk
    ,output logic                  rf_ll_rdylst_hp_bin2_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin2_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin2_waddr
    ,output logic                  rf_ll_rdylst_hp_bin2_we
    ,output logic                  rf_ll_rdylst_hp_bin2_wclk
    ,output logic                  rf_ll_rdylst_hp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin2_rdata

    ,output logic                  rf_ll_rdylst_hp_bin3_re
    ,output logic                  rf_ll_rdylst_hp_bin3_rclk
    ,output logic                  rf_ll_rdylst_hp_bin3_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin3_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin3_waddr
    ,output logic                  rf_ll_rdylst_hp_bin3_we
    ,output logic                  rf_ll_rdylst_hp_bin3_wclk
    ,output logic                  rf_ll_rdylst_hp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin3_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin0_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin0_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin1_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin1_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin2_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin2_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin3_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin3_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_rdylst_tp_bin0_re
    ,output logic                  rf_ll_rdylst_tp_bin0_rclk
    ,output logic                  rf_ll_rdylst_tp_bin0_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin0_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin0_waddr
    ,output logic                  rf_ll_rdylst_tp_bin0_we
    ,output logic                  rf_ll_rdylst_tp_bin0_wclk
    ,output logic                  rf_ll_rdylst_tp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin0_rdata

    ,output logic                  rf_ll_rdylst_tp_bin1_re
    ,output logic                  rf_ll_rdylst_tp_bin1_rclk
    ,output logic                  rf_ll_rdylst_tp_bin1_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin1_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin1_waddr
    ,output logic                  rf_ll_rdylst_tp_bin1_we
    ,output logic                  rf_ll_rdylst_tp_bin1_wclk
    ,output logic                  rf_ll_rdylst_tp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin1_rdata

    ,output logic                  rf_ll_rdylst_tp_bin2_re
    ,output logic                  rf_ll_rdylst_tp_bin2_rclk
    ,output logic                  rf_ll_rdylst_tp_bin2_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin2_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin2_waddr
    ,output logic                  rf_ll_rdylst_tp_bin2_we
    ,output logic                  rf_ll_rdylst_tp_bin2_wclk
    ,output logic                  rf_ll_rdylst_tp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin2_rdata

    ,output logic                  rf_ll_rdylst_tp_bin3_re
    ,output logic                  rf_ll_rdylst_tp_bin3_rclk
    ,output logic                  rf_ll_rdylst_tp_bin3_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin3_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin3_waddr
    ,output logic                  rf_ll_rdylst_tp_bin3_we
    ,output logic                  rf_ll_rdylst_tp_bin3_wclk
    ,output logic                  rf_ll_rdylst_tp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin3_rdata

    ,output logic                  rf_ll_rlst_cnt_re
    ,output logic                  rf_ll_rlst_cnt_rclk
    ,output logic                  rf_ll_rlst_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rlst_cnt_raddr
    ,output logic [(       5)-1:0] rf_ll_rlst_cnt_waddr
    ,output logic                  rf_ll_rlst_cnt_we
    ,output logic                  rf_ll_rlst_cnt_wclk
    ,output logic                  rf_ll_rlst_cnt_wclk_rst_n
    ,output logic [(      56)-1:0] rf_ll_rlst_cnt_wdata
    ,input  logic [(      56)-1:0] rf_ll_rlst_cnt_rdata

    ,output logic                  rf_ll_sch_cnt_dup0_re
    ,output logic                  rf_ll_sch_cnt_dup0_rclk
    ,output logic                  rf_ll_sch_cnt_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup0_waddr
    ,output logic                  rf_ll_sch_cnt_dup0_we
    ,output logic                  rf_ll_sch_cnt_dup0_wclk
    ,output logic                  rf_ll_sch_cnt_dup0_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup0_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup0_rdata

    ,output logic                  rf_ll_sch_cnt_dup1_re
    ,output logic                  rf_ll_sch_cnt_dup1_rclk
    ,output logic                  rf_ll_sch_cnt_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup1_waddr
    ,output logic                  rf_ll_sch_cnt_dup1_we
    ,output logic                  rf_ll_sch_cnt_dup1_wclk
    ,output logic                  rf_ll_sch_cnt_dup1_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup1_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup1_rdata

    ,output logic                  rf_ll_sch_cnt_dup2_re
    ,output logic                  rf_ll_sch_cnt_dup2_rclk
    ,output logic                  rf_ll_sch_cnt_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup2_waddr
    ,output logic                  rf_ll_sch_cnt_dup2_we
    ,output logic                  rf_ll_sch_cnt_dup2_wclk
    ,output logic                  rf_ll_sch_cnt_dup2_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup2_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup2_rdata

    ,output logic                  rf_ll_sch_cnt_dup3_re
    ,output logic                  rf_ll_sch_cnt_dup3_rclk
    ,output logic                  rf_ll_sch_cnt_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup3_waddr
    ,output logic                  rf_ll_sch_cnt_dup3_we
    ,output logic                  rf_ll_sch_cnt_dup3_wclk
    ,output logic                  rf_ll_sch_cnt_dup3_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup3_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup3_rdata

    ,output logic                  rf_ll_schlst_hp_bin0_re
    ,output logic                  rf_ll_schlst_hp_bin0_rclk
    ,output logic                  rf_ll_schlst_hp_bin0_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin0_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin0_waddr
    ,output logic                  rf_ll_schlst_hp_bin0_we
    ,output logic                  rf_ll_schlst_hp_bin0_wclk
    ,output logic                  rf_ll_schlst_hp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin0_rdata

    ,output logic                  rf_ll_schlst_hp_bin1_re
    ,output logic                  rf_ll_schlst_hp_bin1_rclk
    ,output logic                  rf_ll_schlst_hp_bin1_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin1_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin1_waddr
    ,output logic                  rf_ll_schlst_hp_bin1_we
    ,output logic                  rf_ll_schlst_hp_bin1_wclk
    ,output logic                  rf_ll_schlst_hp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin1_rdata

    ,output logic                  rf_ll_schlst_hp_bin2_re
    ,output logic                  rf_ll_schlst_hp_bin2_rclk
    ,output logic                  rf_ll_schlst_hp_bin2_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin2_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin2_waddr
    ,output logic                  rf_ll_schlst_hp_bin2_we
    ,output logic                  rf_ll_schlst_hp_bin2_wclk
    ,output logic                  rf_ll_schlst_hp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin2_rdata

    ,output logic                  rf_ll_schlst_hp_bin3_re
    ,output logic                  rf_ll_schlst_hp_bin3_rclk
    ,output logic                  rf_ll_schlst_hp_bin3_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin3_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin3_waddr
    ,output logic                  rf_ll_schlst_hp_bin3_we
    ,output logic                  rf_ll_schlst_hp_bin3_wclk
    ,output logic                  rf_ll_schlst_hp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin3_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin0_re
    ,output logic                  rf_ll_schlst_hpnxt_bin0_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin0_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin0_we
    ,output logic                  rf_ll_schlst_hpnxt_bin0_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin1_re
    ,output logic                  rf_ll_schlst_hpnxt_bin1_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin1_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin1_we
    ,output logic                  rf_ll_schlst_hpnxt_bin1_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin2_re
    ,output logic                  rf_ll_schlst_hpnxt_bin2_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin2_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin2_we
    ,output logic                  rf_ll_schlst_hpnxt_bin2_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin3_re
    ,output logic                  rf_ll_schlst_hpnxt_bin3_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin3_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin3_we
    ,output logic                  rf_ll_schlst_hpnxt_bin3_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_schlst_tp_bin0_re
    ,output logic                  rf_ll_schlst_tp_bin0_rclk
    ,output logic                  rf_ll_schlst_tp_bin0_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin0_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin0_waddr
    ,output logic                  rf_ll_schlst_tp_bin0_we
    ,output logic                  rf_ll_schlst_tp_bin0_wclk
    ,output logic                  rf_ll_schlst_tp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin0_rdata

    ,output logic                  rf_ll_schlst_tp_bin1_re
    ,output logic                  rf_ll_schlst_tp_bin1_rclk
    ,output logic                  rf_ll_schlst_tp_bin1_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin1_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin1_waddr
    ,output logic                  rf_ll_schlst_tp_bin1_we
    ,output logic                  rf_ll_schlst_tp_bin1_wclk
    ,output logic                  rf_ll_schlst_tp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin1_rdata

    ,output logic                  rf_ll_schlst_tp_bin2_re
    ,output logic                  rf_ll_schlst_tp_bin2_rclk
    ,output logic                  rf_ll_schlst_tp_bin2_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin2_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin2_waddr
    ,output logic                  rf_ll_schlst_tp_bin2_we
    ,output logic                  rf_ll_schlst_tp_bin2_wclk
    ,output logic                  rf_ll_schlst_tp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin2_rdata

    ,output logic                  rf_ll_schlst_tp_bin3_re
    ,output logic                  rf_ll_schlst_tp_bin3_rclk
    ,output logic                  rf_ll_schlst_tp_bin3_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin3_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin3_waddr
    ,output logic                  rf_ll_schlst_tp_bin3_we
    ,output logic                  rf_ll_schlst_tp_bin3_wclk
    ,output logic                  rf_ll_schlst_tp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin3_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin0_re
    ,output logic                  rf_ll_schlst_tpprv_bin0_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin0_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin0_we
    ,output logic                  rf_ll_schlst_tpprv_bin0_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin0_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin1_re
    ,output logic                  rf_ll_schlst_tpprv_bin1_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin1_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin1_we
    ,output logic                  rf_ll_schlst_tpprv_bin1_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin1_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin2_re
    ,output logic                  rf_ll_schlst_tpprv_bin2_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin2_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin2_we
    ,output logic                  rf_ll_schlst_tpprv_bin2_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin2_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin3_re
    ,output logic                  rf_ll_schlst_tpprv_bin3_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin3_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin3_we
    ,output logic                  rf_ll_schlst_tpprv_bin3_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin3_rdata

    ,output logic                  rf_ll_slst_cnt_re
    ,output logic                  rf_ll_slst_cnt_rclk
    ,output logic                  rf_ll_slst_cnt_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_slst_cnt_raddr
    ,output logic [(       9)-1:0] rf_ll_slst_cnt_waddr
    ,output logic                  rf_ll_slst_cnt_we
    ,output logic                  rf_ll_slst_cnt_wclk
    ,output logic                  rf_ll_slst_cnt_wclk_rst_n
    ,output logic [(      60)-1:0] rf_ll_slst_cnt_wdata
    ,input  logic [(      60)-1:0] rf_ll_slst_cnt_rdata

    ,output logic                  rf_qid_rdylst_clamp_re
    ,output logic                  rf_qid_rdylst_clamp_rclk
    ,output logic                  rf_qid_rdylst_clamp_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_rdylst_clamp_raddr
    ,output logic [(       5)-1:0] rf_qid_rdylst_clamp_waddr
    ,output logic                  rf_qid_rdylst_clamp_we
    ,output logic                  rf_qid_rdylst_clamp_wclk
    ,output logic                  rf_qid_rdylst_clamp_wclk_rst_n
    ,output logic [(       6)-1:0] rf_qid_rdylst_clamp_wdata
    ,input  logic [(       6)-1:0] rf_qid_rdylst_clamp_rdata

// END HQM_MEMPORT_DECL hqm_lsp_atm_pipe

) ;

`ifndef HQM_VISA_ELABORATE

// collage-pragma translate_off

hqm_list_sel_pipe_core i_hqm_list_sel_pipe_core (.*);

// collage-pragma translate_on

`endif

endmodule // hqm_list_sel_pipe
