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
// hqm_aqed_pipe
//
//-----------------------------------------------------------------------------------------------------

module hqm_aqed_pipe
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
  input  logic hqm_gated_clk
, input  logic hqm_inp_gated_clk
, input  logic hqm_ungated_clk
, input  logic hqm_rst_prep_aqed
, input  logic hqm_gated_rst_b_aqed
, input  logic hqm_inp_gated_rst_b_aqed

, input  logic hqm_gated_rst_b_start_aqed
, input  logic hqm_gated_rst_b_active_aqed
, output logic hqm_gated_rst_b_done_aqed

, output logic aqed_clk_idle
, input logic aqed_clk_enable

, input  logic                  hqm_fullrate_clk
, input  logic                  hqm_clk_rptr_rst_sync_b
, input  logic                  hqm_gatedclk_enable_and
, input  logic                  hqm_clk_ungate

, output logic                  aqed_unit_idle
, output logic                  aqed_unit_pipeidle
, output logic                  aqed_reset_done

// CFG interface
, input  logic                  aqed_cfg_req_up_read
, input  logic                  aqed_cfg_req_up_write
, input  logic [BITS_CFG_REQ_T-1:0] aqed_cfg_req_up
, input  logic                  aqed_cfg_rsp_up_ack
, input  logic [BITS_CFG_RSP_T-1:0] aqed_cfg_rsp_up
, output logic                  aqed_cfg_req_down_read
, output logic                  aqed_cfg_req_down_write
, output logic [BITS_CFG_REQ_T-1:0] aqed_cfg_req_down
, output logic                  aqed_cfg_rsp_down_ack
, output logic [BITS_CFG_RSP_T-1:0] aqed_cfg_rsp_down

// interrupt interface
, input  logic                  aqed_alarm_up_v
, output logic                  aqed_alarm_up_ready
, input  logic [BITS_AW_ALARM_T-1:0] aqed_alarm_up_data

, output logic                  aqed_alarm_down_v
, input  logic                  aqed_alarm_down_ready
, output logic [BITS_AW_ALARM_T-1:0] aqed_alarm_down_data


, input  logic                           lsp_aqed_cmp_v
, output logic                           lsp_aqed_cmp_ready
, input  logic [BITS_LSP_AQED_CMP_T-1:0] lsp_aqed_cmp_data
, output logic                           aqed_lsp_dec_fid_cnt_v
, output logic                            aqed_lsp_fid_cnt_upd_v 
, output logic                            aqed_lsp_fid_cnt_upd_val 
, output logic                           [ ( 7 ) -1 : 0 ] aqed_lsp_fid_cnt_upd_qid 
, output logic                           aqed_lsp_stop_atqatm

// aqed_lsp_deq interface
, output  logic                            aqed_lsp_deq_v
, output  logic [BITS_AQED_LSP_DEQ_T-1:0]  aqed_lsp_deq_data

// ap_aqed interface
, input  logic                  ap_aqed_v
, output logic                  ap_aqed_ready
, input  logic [BITS_AP_AQED_T-1:0] ap_aqed_data

// qed_aqed_enq interface
, input  logic                  qed_aqed_enq_v
, output logic                  qed_aqed_enq_ready
, input  logic [BITS_QED_AQED_ENQ_T-1:0] qed_aqed_enq_data

// aqed_ap_enq interface
, output logic                  aqed_ap_enq_v
, input  logic                  aqed_ap_enq_ready
, output logic [BITS_AQED_AP_ENQ_T-1:0] aqed_ap_enq_data

// aqed_chp_sch interface
, output logic                  aqed_chp_sch_v
, input  logic                  aqed_chp_sch_ready
, output logic [BITS_AQED_CHP_SCH_T-1:0] aqed_chp_sch_data

// aqed_lsp_sch interface
, output logic                  aqed_lsp_sch_v
, input  logic                  aqed_lsp_sch_ready
, output logic [BITS_AQED_LSP_SCH_T-1:0] aqed_lsp_sch_data

// BEGIN HQM_MEMPORT_DECL hqm_aqed_pipe_core
,output logic                  bcam_AW_bcam_2048x26_wclk
,output logic                  bcam_AW_bcam_2048x26_rclk
,output logic                  bcam_AW_bcam_2048x26_cclk
,output logic                  bcam_AW_bcam_2048x26_dfx_clk
,output logic [(       8)-1:0] bcam_AW_bcam_2048x26_we
,output logic [( 8 *   8)-1:0] bcam_AW_bcam_2048x26_waddr
,output logic [( 8 *  26)-1:0] bcam_AW_bcam_2048x26_wdata
,output logic [(       8)-1:0] bcam_AW_bcam_2048x26_ce
,output logic [( 8 *  26)-1:0] bcam_AW_bcam_2048x26_cdata
,input  logic [( 8 * 256)-1:0] bcam_AW_bcam_2048x26_cmatch
,output logic                  bcam_AW_bcam_2048x26_re
,output logic [(       8)-1:0] bcam_AW_bcam_2048x26_raddr
,input  logic [( 8 *  26)-1:0] bcam_AW_bcam_2048x26_rdata
    ,output logic                  rf_aqed_fid_cnt_re
    ,output logic                  rf_aqed_fid_cnt_rclk
    ,output logic                  rf_aqed_fid_cnt_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_fid_cnt_raddr
    ,output logic [(      11)-1:0] rf_aqed_fid_cnt_waddr
    ,output logic                  rf_aqed_fid_cnt_we
    ,output logic                  rf_aqed_fid_cnt_wclk
    ,output logic                  rf_aqed_fid_cnt_wclk_rst_n
    ,output logic [(      17)-1:0] rf_aqed_fid_cnt_wdata
    ,input  logic [(      17)-1:0] rf_aqed_fid_cnt_rdata

    ,output logic                  rf_aqed_fifo_ap_aqed_re
    ,output logic                  rf_aqed_fifo_ap_aqed_rclk
    ,output logic                  rf_aqed_fifo_ap_aqed_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_ap_aqed_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_ap_aqed_waddr
    ,output logic                  rf_aqed_fifo_ap_aqed_we
    ,output logic                  rf_aqed_fifo_ap_aqed_wclk
    ,output logic                  rf_aqed_fifo_ap_aqed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_aqed_fifo_ap_aqed_wdata
    ,input  logic [(      45)-1:0] rf_aqed_fifo_ap_aqed_rdata

    ,output logic                  rf_aqed_fifo_aqed_ap_enq_re
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_rclk
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_ap_enq_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_ap_enq_waddr
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_we
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_wclk
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_wclk_rst_n
    ,output logic [(      24)-1:0] rf_aqed_fifo_aqed_ap_enq_wdata
    ,input  logic [(      24)-1:0] rf_aqed_fifo_aqed_ap_enq_rdata

    ,output logic                  rf_aqed_fifo_aqed_chp_sch_re
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_rclk
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_chp_sch_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_chp_sch_waddr
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_we
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_wclk
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_wclk_rst_n
    ,output logic [(     180)-1:0] rf_aqed_fifo_aqed_chp_sch_wdata
    ,input  logic [(     180)-1:0] rf_aqed_fifo_aqed_chp_sch_rdata

    ,output logic                  rf_aqed_fifo_freelist_return_re
    ,output logic                  rf_aqed_fifo_freelist_return_rclk
    ,output logic                  rf_aqed_fifo_freelist_return_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_freelist_return_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_freelist_return_waddr
    ,output logic                  rf_aqed_fifo_freelist_return_we
    ,output logic                  rf_aqed_fifo_freelist_return_wclk
    ,output logic                  rf_aqed_fifo_freelist_return_wclk_rst_n
    ,output logic [(      32)-1:0] rf_aqed_fifo_freelist_return_wdata
    ,input  logic [(      32)-1:0] rf_aqed_fifo_freelist_return_rdata

    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_re
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_rclk
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_lsp_aqed_cmp_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_lsp_aqed_cmp_waddr
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_we
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_wclk
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n
    ,output logic [(      35)-1:0] rf_aqed_fifo_lsp_aqed_cmp_wdata
    ,input  logic [(      35)-1:0] rf_aqed_fifo_lsp_aqed_cmp_rdata

    ,output logic                  rf_aqed_fifo_qed_aqed_enq_re
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_rclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_aqed_fifo_qed_aqed_enq_raddr
    ,output logic [(       2)-1:0] rf_aqed_fifo_qed_aqed_enq_waddr
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_we
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_wclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_wclk_rst_n
    ,output logic [(     155)-1:0] rf_aqed_fifo_qed_aqed_enq_wdata
    ,input  logic [(     155)-1:0] rf_aqed_fifo_qed_aqed_enq_rdata

    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_re
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_rclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n
    ,output logic [(       3)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_raddr
    ,output logic [(       3)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_waddr
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_we
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_wclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n
    ,output logic [(     153)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_wdata
    ,input  logic [(     153)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_rdata

    ,output logic                  rf_aqed_ll_cnt_pri0_re
    ,output logic                  rf_aqed_ll_cnt_pri0_rclk
    ,output logic                  rf_aqed_ll_cnt_pri0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri0_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri0_waddr
    ,output logic                  rf_aqed_ll_cnt_pri0_we
    ,output logic                  rf_aqed_ll_cnt_pri0_wclk
    ,output logic                  rf_aqed_ll_cnt_pri0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri0_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri0_rdata

    ,output logic                  rf_aqed_ll_cnt_pri1_re
    ,output logic                  rf_aqed_ll_cnt_pri1_rclk
    ,output logic                  rf_aqed_ll_cnt_pri1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri1_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri1_waddr
    ,output logic                  rf_aqed_ll_cnt_pri1_we
    ,output logic                  rf_aqed_ll_cnt_pri1_wclk
    ,output logic                  rf_aqed_ll_cnt_pri1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri1_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri1_rdata

    ,output logic                  rf_aqed_ll_cnt_pri2_re
    ,output logic                  rf_aqed_ll_cnt_pri2_rclk
    ,output logic                  rf_aqed_ll_cnt_pri2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri2_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri2_waddr
    ,output logic                  rf_aqed_ll_cnt_pri2_we
    ,output logic                  rf_aqed_ll_cnt_pri2_wclk
    ,output logic                  rf_aqed_ll_cnt_pri2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri2_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri2_rdata

    ,output logic                  rf_aqed_ll_cnt_pri3_re
    ,output logic                  rf_aqed_ll_cnt_pri3_rclk
    ,output logic                  rf_aqed_ll_cnt_pri3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri3_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri3_waddr
    ,output logic                  rf_aqed_ll_cnt_pri3_we
    ,output logic                  rf_aqed_ll_cnt_pri3_wclk
    ,output logic                  rf_aqed_ll_cnt_pri3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri3_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri3_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri0_re
    ,output logic                  rf_aqed_ll_qe_hp_pri0_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri0_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri0_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri0_we
    ,output logic                  rf_aqed_ll_qe_hp_pri0_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri0_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri0_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri1_re
    ,output logic                  rf_aqed_ll_qe_hp_pri1_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri1_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri1_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri1_we
    ,output logic                  rf_aqed_ll_qe_hp_pri1_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri1_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri1_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri2_re
    ,output logic                  rf_aqed_ll_qe_hp_pri2_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri2_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri2_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri2_we
    ,output logic                  rf_aqed_ll_qe_hp_pri2_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri2_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri2_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri3_re
    ,output logic                  rf_aqed_ll_qe_hp_pri3_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri3_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri3_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri3_we
    ,output logic                  rf_aqed_ll_qe_hp_pri3_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri3_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri3_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri0_re
    ,output logic                  rf_aqed_ll_qe_tp_pri0_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri0_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri0_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri0_we
    ,output logic                  rf_aqed_ll_qe_tp_pri0_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri0_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri0_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri1_re
    ,output logic                  rf_aqed_ll_qe_tp_pri1_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri1_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri1_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri1_we
    ,output logic                  rf_aqed_ll_qe_tp_pri1_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri1_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri1_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri2_re
    ,output logic                  rf_aqed_ll_qe_tp_pri2_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri2_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri2_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri2_we
    ,output logic                  rf_aqed_ll_qe_tp_pri2_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri2_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri2_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri3_re
    ,output logic                  rf_aqed_ll_qe_tp_pri3_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri3_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri3_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri3_we
    ,output logic                  rf_aqed_ll_qe_tp_pri3_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri3_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri3_rdata

    ,output logic                  rf_aqed_qid_cnt_re
    ,output logic                  rf_aqed_qid_cnt_rclk
    ,output logic                  rf_aqed_qid_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_qid_cnt_raddr
    ,output logic [(       5)-1:0] rf_aqed_qid_cnt_waddr
    ,output logic                  rf_aqed_qid_cnt_we
    ,output logic                  rf_aqed_qid_cnt_wclk
    ,output logic                  rf_aqed_qid_cnt_wclk_rst_n
    ,output logic [(      15)-1:0] rf_aqed_qid_cnt_wdata
    ,input  logic [(      15)-1:0] rf_aqed_qid_cnt_rdata

    ,output logic                  rf_aqed_qid_fid_limit_re
    ,output logic                  rf_aqed_qid_fid_limit_rclk
    ,output logic                  rf_aqed_qid_fid_limit_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_qid_fid_limit_raddr
    ,output logic [(       5)-1:0] rf_aqed_qid_fid_limit_waddr
    ,output logic                  rf_aqed_qid_fid_limit_we
    ,output logic                  rf_aqed_qid_fid_limit_wclk
    ,output logic                  rf_aqed_qid_fid_limit_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_qid_fid_limit_wdata
    ,input  logic [(      14)-1:0] rf_aqed_qid_fid_limit_rdata

    ,output logic                  rf_rx_sync_qed_aqed_enq_re
    ,output logic                  rf_rx_sync_qed_aqed_enq_rclk
    ,output logic                  rf_rx_sync_qed_aqed_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_qed_aqed_enq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_qed_aqed_enq_waddr
    ,output logic                  rf_rx_sync_qed_aqed_enq_we
    ,output logic                  rf_rx_sync_qed_aqed_enq_wclk
    ,output logic                  rf_rx_sync_qed_aqed_enq_wclk_rst_n
    ,output logic [(     139)-1:0] rf_rx_sync_qed_aqed_enq_wdata
    ,input  logic [(     139)-1:0] rf_rx_sync_qed_aqed_enq_rdata

    ,output logic                  sr_aqed_re
    ,output logic                  sr_aqed_clk
    ,output logic                  sr_aqed_clk_rst_n
    ,output logic [(      11)-1:0] sr_aqed_addr
    ,output logic                  sr_aqed_we
    ,output logic [(     139)-1:0] sr_aqed_wdata
    ,input  logic [(     139)-1:0] sr_aqed_rdata

    ,output logic                  sr_aqed_freelist_re
    ,output logic                  sr_aqed_freelist_clk
    ,output logic                  sr_aqed_freelist_clk_rst_n
    ,output logic [(      11)-1:0] sr_aqed_freelist_addr
    ,output logic                  sr_aqed_freelist_we
    ,output logic [(      16)-1:0] sr_aqed_freelist_wdata
    ,input  logic [(      16)-1:0] sr_aqed_freelist_rdata

    ,output logic                  sr_aqed_ll_qe_hpnxt_re
    ,output logic                  sr_aqed_ll_qe_hpnxt_clk
    ,output logic                  sr_aqed_ll_qe_hpnxt_clk_rst_n
    ,output logic [(      11)-1:0] sr_aqed_ll_qe_hpnxt_addr
    ,output logic                  sr_aqed_ll_qe_hpnxt_we
    ,output logic [(      16)-1:0] sr_aqed_ll_qe_hpnxt_wdata
    ,input  logic [(      16)-1:0] sr_aqed_ll_qe_hpnxt_rdata

// END HQM_MEMPORT_DECL hqm_aqed_pipe_core
);

`ifndef HQM_VISA_ELABORATE

// collage-pragma translate_off

hqm_aqed_pipe_core i_hqm_aqed_pipe_core (.*);

// collage-pragma translate_on

`endif

endmodule // hqm_aqed_pipe
