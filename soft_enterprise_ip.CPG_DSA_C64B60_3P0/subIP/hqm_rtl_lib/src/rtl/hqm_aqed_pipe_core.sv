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

module hqm_aqed_pipe_core
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
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
, input  cfg_req_t              aqed_cfg_req_up
, input  logic                  aqed_cfg_rsp_up_ack
, input  cfg_rsp_t              aqed_cfg_rsp_up
, output logic                  aqed_cfg_req_down_read
, output logic                  aqed_cfg_req_down_write
, output cfg_req_t              aqed_cfg_req_down
, output logic                  aqed_cfg_rsp_down_ack
, output cfg_rsp_t              aqed_cfg_rsp_down

// interrupt interface
, input  logic                  aqed_alarm_up_v
, output logic                  aqed_alarm_up_ready
, input  aw_alarm_t             aqed_alarm_up_data

, output logic                  aqed_alarm_down_v
, input  logic                  aqed_alarm_down_ready
, output aw_alarm_t             aqed_alarm_down_data


, input  logic                           lsp_aqed_cmp_v
, output logic                           lsp_aqed_cmp_ready
, input  lsp_aqed_cmp_t                  lsp_aqed_cmp_data
, output logic                           aqed_lsp_dec_fid_cnt_v
, output logic                            aqed_lsp_fid_cnt_upd_v
, output logic                            aqed_lsp_fid_cnt_upd_val
, output logic                           [ ( 7 ) - 1 : 0 ] aqed_lsp_fid_cnt_upd_qid
, output logic                           aqed_lsp_stop_atqatm

// aqed_lsp_deq interface
, output  logic                  aqed_lsp_deq_v
, output  aqed_lsp_deq_t         aqed_lsp_deq_data

// ap_aqed interface
, input  logic                  ap_aqed_v
, output logic                  ap_aqed_ready
, input  ap_aqed_t              ap_aqed_data

// qed_aqed_enq interface
, input  logic                  qed_aqed_enq_v
, output logic                  qed_aqed_enq_ready
, input  qed_aqed_enq_t         qed_aqed_enq_data

// aqed_ap_enq interface
, output logic                  aqed_ap_enq_v
, input  logic                  aqed_ap_enq_ready
, output aqed_ap_enq_t          aqed_ap_enq_data

// aqed_chp_sch interface
, output logic                  aqed_chp_sch_v
, input  logic                  aqed_chp_sch_ready
, output aqed_chp_sch_t         aqed_chp_sch_data

// aqed_lsp_sch interface
, output logic                  aqed_lsp_sch_v
, input  logic                  aqed_lsp_sch_ready
, output aqed_lsp_sch_t         aqed_lsp_sch_data

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

) ;
localparam HQM_AQED_ADDR_WIDTH = 11 ; //HQM_AQED_DEPTHB2
localparam HQM_AQED_ATOMIC_DST_ADDR_WIDTH = 11 ; //HQM_AQED_DEPTHB2
localparam HQM_AQED_ATOMIC_SRC_ADDR_WIDTH = 13 ; //HQM_AQED_DEPTHB2*4
localparam HQM_AQED_CFG_INT_DIS = 0 ;
localparam HQM_AQED_CFG_INT_DIS_MBE = 2 ;
localparam HQM_AQED_CFG_INT_DIS_SBE = 1 ;
localparam HQM_AQED_CFG_INT_DIS_SYND = 31 ;
localparam HQM_AQED_CFG_RST_PFMAX = 2048 ;
localparam HQM_AQED_CFG_VASR_DIS = 30 ;
localparam HQM_AQED_CHICKEN_33 = 2 ;
localparam HQM_AQED_CHICKEN_50 = 1 ;
localparam HQM_AQED_CHICKEN_ALLPRI = 31 ;
localparam HQM_AQED_CHICKEN_CFGRETURN = 24 ;
localparam HQM_AQED_CHICKEN_FIDCNT_THRESH = 8 ; //21:8
localparam HQM_AQED_CHICKEN_FID_DECREMENT = 4 ;
localparam HQM_AQED_CHICKEN_FID_SIM = 5 ;
localparam HQM_AQED_CHICKEN_ONEPRI = 30 ;
localparam HQM_AQED_CHICKEN_SIM = 0 ;
localparam HQM_AQED_CMD_DEQ = 2 ;
localparam HQM_AQED_CMD_ENQ = 1 ;
localparam HQM_AQED_CMD_NOOP = 0 ;
localparam HQM_AQED_CMD_READ = 3 ;
localparam HQM_AQED_CNTB2 = 12 ; // 2k entries gives counter width 12
localparam HQM_AQED_CNTB2WR = 14 ; // 2k entries gives counter width 12
localparam HQM_AQED_DATA = 11 ;
localparam HQM_AQED_DWIDTH = 144 ;
localparam HQM_AQED_ECC = 5 ;
localparam HQM_AQED_FID_CNT_DEPTH = 4096 ;
localparam HQM_AQED_FID_CNT_DEPTHB2 = AW_logb2 ( HQM_AQED_FID_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FID_CNT_DWIDTH = 15 ;
localparam HQM_AQED_FIFO_AP_AQED_DEPTH = 16 ;
localparam HQM_AQED_FIFO_AP_AQED_DEPTHB2 = AW_logb2 ( HQM_AQED_FIFO_AP_AQED_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FIFO_AP_AQED_DWIDTH = 45 ;
localparam HQM_AQED_FIFO_AP_AQED_WMWIDTH = AW_logb2 ( HQM_AQED_FIFO_AP_AQED_DEPTH + 1 ) + 1 ;
localparam HQM_AQED_FIFO_AQED_AP_ENQ_DEPTH = 16 ;
localparam HQM_AQED_FIFO_AQED_AP_ENQ_DEPTHB2 = AW_logb2 ( HQM_AQED_FIFO_AQED_AP_ENQ_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FIFO_AQED_AP_ENQ_DWIDTH = 24 ;
localparam HQM_AQED_FIFO_AQED_AP_ENQ_WMWIDTH = AW_logb2 ( HQM_AQED_FIFO_AQED_AP_ENQ_DEPTH + 1 ) + 1 ;
localparam HQM_AQED_FIFO_AQED_CHP_SCH_DEPTH = 16 ;
localparam HQM_AQED_FIFO_AQED_CHP_SCH_DEPTHB2 = AW_logb2 ( HQM_AQED_FIFO_AQED_CHP_SCH_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FIFO_AQED_CHP_SCH_DWIDTH = 187 ;
localparam HQM_AQED_FIFO_AQED_CHP_SCH_WMWIDTH = AW_logb2 ( HQM_AQED_FIFO_AQED_CHP_SCH_DEPTH + 1 ) + 1 ;
localparam HQM_AQED_FIFO_FREELIST_RETURN_DEPTH = 16 ;
localparam HQM_AQED_FIFO_FREELIST_RETURN_DEPTHB2 = AW_logb2 ( HQM_AQED_FIFO_FREELIST_RETURN_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FIFO_FREELIST_RETURN_DWIDTH = 32 ;
localparam HQM_AQED_FIFO_FREELIST_RETURN_WMWIDTH = AW_logb2 ( HQM_AQED_FIFO_FREELIST_RETURN_DEPTH + 1 ) + 1 ;
localparam HQM_AQED_FIFO_LSP_AQED_CMP_DEPTH = 16 ;
localparam HQM_AQED_FIFO_LSP_AQED_CMP_DEPTHB2 = AW_logb2 ( HQM_AQED_FIFO_LSP_AQED_CMP_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FIFO_LSP_AQED_CMP_DWIDTH = 35 ;
localparam HQM_AQED_FIFO_LSP_AQED_CMP_WMWIDTH = AW_logb2 ( HQM_AQED_FIFO_LSP_AQED_CMP_DEPTH + 1 ) + 1 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_DEPTH = 4 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_DEPTHB2 = AW_logb2 ( HQM_AQED_FIFO_QED_AQED_ENQ_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_DWIDTH = 144 + 16 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_FID_DEPTH = 8 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_FID_DEPTHB2 = AW_logb2 ( HQM_AQED_FIFO_QED_AQED_ENQ_FID_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_FID_DWIDTH = 160 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_FID_WMWIDTH = AW_logb2 ( HQM_AQED_FIFO_QED_AQED_ENQ_FID_DEPTH + 1 ) + 1 ;
localparam HQM_AQED_FIFO_QED_AQED_ENQ_WMWIDTH = AW_logb2 ( HQM_AQED_FIFO_QED_AQED_ENQ_DEPTH + 1 ) + 1 ;
localparam HQM_AQED_FLIDB2 = 11 ; // 2k entries gives freelist width 11
localparam HQM_AQED_FREELIST_DEPTH = 2048 ;
localparam HQM_AQED_FREELIST_DEPTHB2 = AW_logb2 ( HQM_AQED_FREELIST_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FREELIST_DWIDTH = 11 + 1 + 5 ;
localparam HQM_AQED_FREELIST_MINMAX_DEPTH = 128 ;
localparam HQM_AQED_FREELIST_MINMAX_DEPTHB2 = AW_logb2 ( HQM_AQED_FREELIST_MINMAX_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FREELIST_MINMAX_DWIDTH = 2 * ( 11 + 2 ) ;
localparam HQM_AQED_FREELIST_PTR_DEPTH = 128 ;
localparam HQM_AQED_FREELIST_PTR_DEPTHB2 = AW_logb2 ( HQM_AQED_FREELIST_PTR_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_FREELIST_PTR_DWIDTH = 2 * ( 11 + 3 ) ;
localparam HQM_AQED_LL_CNT_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI0_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI0_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI0_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI0_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI0_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI1_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI1_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI1_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI1_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI2_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI2_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI2_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI2_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI3_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI3_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI3_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI3_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI4_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI4_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI4_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI4_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI5_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI5_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI5_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI5_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI6_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI6_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI6_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI6_DWIDTH = 14 ;
localparam HQM_AQED_LL_CNT_PRI7_DEPTH = 4096 ;
localparam HQM_AQED_LL_CNT_PRI7_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_CNT_PRI7_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_CNT_PRI7_DWIDTH = 14 ;
localparam HQM_AQED_LL_QE_HPNXT_DEPTH = 2048 ;
localparam HQM_AQED_LL_QE_HPNXT_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HPNXT_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HPNXT_DWIDTH = 11 + 1 + 5 ;
localparam HQM_AQED_LL_QE_HP_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI0_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI0_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI0_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI0_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI0_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI1_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI1_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI1_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI1_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI2_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI2_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI2_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI2_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI3_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI3_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI3_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI3_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI4_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI4_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI4_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI4_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI5_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI5_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI5_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI5_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI6_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI6_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI6_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI6_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_HP_PRI7_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_HP_PRI7_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_HP_PRI7_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_HP_PRI7_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI0_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI0_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI0_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI0_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI0_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI1_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI1_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI1_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI1_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI2_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI2_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI2_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI2_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI3_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI3_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI3_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI3_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI4_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI4_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI4_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI4_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI5_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI5_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI5_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI5_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI6_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI6_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI6_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI6_DWIDTH = 12 ;
localparam HQM_AQED_LL_QE_TP_PRI7_DEPTH = 4096 ;
localparam HQM_AQED_LL_QE_TP_PRI7_DEPTHB2 = AW_logb2 ( HQM_AQED_LL_QE_TP_PRI7_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_LL_QE_TP_PRI7_DWIDTH = 12 ;
localparam HQM_AQED_MF_DEPTH = 2048 ;
localparam HQM_AQED_MF_AWIDTH = AW_logb2 ( HQM_AQED_MF_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_MF_DWIDTH = 11 + 5 ;
localparam HQM_AQED_MF_NUM_FIFOS = 128 ;
localparam HQM_AQED_MF_NFWIDTH = AW_logb2 ( HQM_AQED_MF_NUM_FIFOS - 1 ) + 1 ;
localparam HQM_AQED_NXTHP_LL = 0 ;
localparam HQM_AQED_PARITY = 1 ;
localparam HQM_AQED_QID_CNT_DEPTH = 128 ;
localparam HQM_AQED_QID_CNT_DEPTHB2 = AW_logb2 ( HQM_AQED_QID_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_QID_CNT_DWIDTH = 15 ;
localparam HQM_AQED_QID_FID_LIMIT_DEPTH = 128 ;
localparam HQM_AQED_QID_FID_LIMIT_DEPTHB2 = AW_logb2 ( HQM_AQED_QID_FID_LIMIT_DEPTH - 1 ) + 1 ;
localparam HQM_AQED_QID_FID_LIMIT_DWIDTH = 14 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_0 = 20'd1 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_1 = 20'd2 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_2 = 20'd3 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_3 = 20'd4 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_4 = 20'd5 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_5 = 20'd6 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_6 = 20'd7 ;
localparam HQM_AQED_VF_RESET_CMD_CQ_WRITE_CNT_7 = 20'd8 ;
localparam HQM_AQED_VF_RESET_CMD_DONE = 20'd13 ;
localparam HQM_AQED_VF_RESET_CMD_INVALID = 20'd14 ;
localparam HQM_AQED_VF_RESET_CMD_QID_READ_CNT_0 = 20'd9 ;
localparam HQM_AQED_VF_RESET_CMD_QID_READ_CNT_X = 20'd11 ;
localparam HQM_AQED_VF_RESET_CMD_QID_WRITE_CNT_X = 20'd12 ;
localparam HQM_AQED_VF_RESET_CMD_START = 20'd0 ;
typedef struct packed {  
  logic  hold ;  
  logic  bypsel ;  
  logic  enable ;
} hqm_ll_ctrl_t ;
typedef struct packed {  
  logic [ ( 2 ) - 1 : 0 ] cmd ;
  logic pcm ;
  logic [ ( 8 ) - 1 : 0 ] cq ;
  logic [ ( 7 ) - 1 : 0 ] qid ;
  logic [ ( 3 ) - 1 : 0 ] qidix ;
  logic  parity ;
  logic [ ( 3 ) - 1 : 0 ] qpri ;
  logic  empty ;
  logic [ ( 11 ) - 1 : 0 ] hp ;
  logic [ ( 11 ) - 1 : 0 ] tp ;
  logic [ ( 11 ) - 1 : 0 ] new_flid ;
  logic  new_flid_parity ;
  logic [ ( 5 ) - 1 : 0 ] new_flid_ecc ;
  logic [ ( 12 ) - 1 : 0 ] fid ;
  logic  fid_parity ;
  logic  hp_parity ;
  logic  tp_parity ;
  logic  error ;
  logic  freelist_push ;
  hqm_pkg::cq_hcw_t cq_hcw ;
  logic [ ( 16 ) - 1 : 0 ] cq_hcw_ecc ;
  hqm_core_flags_t hqm_core_flags ;
} hqm_ll_data_t ;
typedef struct packed {
  logic [ ( 7 ) - 1 : 0 ] qid ;
  logic [ ( 12 ) - 1 : 0 ] fid ;
  logic [ ( 16 ) - 1 : 0 ] hid ;
} fifo_lsp_aqed_cmp_t ;
typedef struct packed {
  logic [ ( 8 ) - 1 : 0 ] cq ;
  logic [ ( 3 ) - 1 : 0 ] qidix ;
  logic parity ;  logic [ ( 7 ) - 1 : 0 ] qid ;
  logic [ ( 11 ) - 1 : 0 ] hp ;
  logic  hp_parity ;
  logic spare ;
} freelist_return_t ;
typedef struct packed {
  hqm_pkg::cq_hcw_t cq_hcw ;
  logic [ ( 16 ) - 1 : 0 ] cq_hcw_ecc ;
} enq_data_t ;
typedef struct packed {
  logic [ ( 3 ) - 1 : 0 ] spare ;
  logic [ ( 11 ) - 1 : 0 ] fid ;
  hqm_pkg::cq_hcw_t cq_hcw ;
  logic [ ( 16 ) - 1 : 0 ] cq_hcw_ecc ;
} qed_aqed_enq_fid_t ;
aw_alarm_syn_t [ ( HQM_AQED_ALARM_NUM_COR ) - 1 : 0 ] int_cor_data ;
aw_alarm_syn_t [ ( HQM_AQED_ALARM_NUM_INF ) - 1 : 0 ] int_inf_data ;
aw_alarm_syn_t [ ( HQM_AQED_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_data ;
aw_multi_fifo_cmd_t mf_cmd ;
aw_rmwpipe_cmd_t rmw_ll_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_ll_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_ll_tp_p0_rw_nxt ;
aw_rwpipe_cmd_t rw_aqed_p0_byp_rw_nxt ;
aw_rwpipe_cmd_t rw_aqed_p0_rw_f_nc ;
aw_rwpipe_cmd_t rw_aqed_p0_rw_nxt ;
aw_rwpipe_cmd_t rw_aqed_p1_rw_f_nc ;
aw_rwpipe_cmd_t rw_aqed_p2_rw_f_nc ;
aw_rwpipe_cmd_t rw_aqed_p3_rw_f_nc ;
aw_rwpipe_cmd_t rw_ll_qe_hpnxt_p0_byp_rw_nxt ;
aw_rwpipe_cmd_t rw_ll_qe_hpnxt_p0_rw_f_nc ;
aw_rwpipe_cmd_t rw_ll_qe_hpnxt_p0_rw_nxt ;
aw_rwpipe_cmd_t rw_ll_qe_hpnxt_p1_rw_f_nc ;
aw_rwpipe_cmd_t rw_ll_qe_hpnxt_p2_rw_f_nc ;
aw_rwpipe_cmd_t rw_ll_qe_hpnxt_p3_rw_f_nc ;
cfg_req_t mf_cfg_req ;
idle_status_t cfg_unit_idle_f , cfg_unit_idle_nxt ;
hqm_ll_data_t p0_ll_data_f , p0_ll_data_nxt , p1_ll_data_f , p1_ll_data_nxt , p2_ll_data_f , p2_ll_data_nxt , p3_ll_data_f , p3_ll_data_nxt , p4_ll_data_f , p4_ll_data_nxt , p5_ll_data_f , p5_ll_data_nxt , p6_ll_data_f , p6_ll_data_nxt , p7_ll_data_f , p7_ll_data_nxt , p8_ll_data_f , p8_ll_data_nxt , p9_ll_data_f , p9_ll_data_nxt , p10_ll_data_f , p10_ll_data_nxt , p11_ll_data_f , p11_ll_data_nxt , p12_ll_data_f , p12_ll_data_nxt , p13_ll_data_f , p13_ll_data_nxt ;
hqm_ll_ctrl_t p0_ll_ctrl , p1_ll_ctrl , p2_ll_ctrl , p3_ll_ctrl , p4_ll_ctrl , p5_ll_ctrl , p6_ll_ctrl , p7_ll_ctrl , p8_ll_ctrl , p9_ll_ctrl , p10_ll_ctrl , p11_ll_ctrl , p12_ll_ctrl , p13_ll_ctrl ;
logic                  disable_smon ;
assign disable_smon = 1'b0 ;
logic pf_reset_active_0 ;
logic pf_reset_active_1 ;
logic rx_sync_qed_aqed_enq_idle ;
logic cfg_rx_idle ;
logic cfg_idle ;
logic int_idle ;
logic unit_idle_hqm_clk_gated ;
logic unit_idle_hqm_clk_inp_gated ;
logic db_lsp_aqed_cmp_ready ;
logic db_lsp_aqed_cmp_v ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_winner ;
logic arb_ll_cnt_winner_v ;
logic arb_ll_update ;
logic arb_ll_winner_v ;
logic cfgsc_parity_gen_qid_fid_limit_p ;
logic db_ap_aqed_ready ;
logic db_ap_aqed_valid ;
logic db_aqed_ap_enq_ready ;
logic db_aqed_ap_enq_valid ;
logic db_aqed_chp_sch_ready ;
logic db_aqed_chp_sch_valid ;
logic db_aqed_lsp_sch_ready ;
logic db_aqed_lsp_sch_valid ;
logic error_ll_nopri ;
logic error_ll_of ;
logic fifo_ap_aqed_afull ;
logic fifo_ap_aqed_empty ;
logic fifo_ap_aqed_error_of ;
logic fifo_ap_aqed_error_uf ;
logic fifo_ap_aqed_full_nc ;
logic fifo_ap_aqed_pop ;
logic fifo_ap_aqed_push ;
logic fifo_aqed_ap_enq_afull ;
logic fifo_aqed_ap_enq_empty ;
logic fifo_aqed_ap_enq_error_of ;
logic fifo_aqed_ap_enq_error_uf ;
logic fifo_aqed_ap_enq_full_nc ;
logic fifo_aqed_ap_enq_pop ;
logic fifo_aqed_ap_enq_push ;
logic fifo_aqed_chp_sch_afull ;
logic fifo_aqed_chp_sch_empty ;
logic fifo_aqed_chp_sch_error_of ;
logic fifo_aqed_chp_sch_error_uf ;
logic fifo_aqed_chp_sch_full_nc ;
logic fifo_aqed_chp_sch_pop ;
logic fifo_aqed_chp_sch_push ;
logic fifo_freelist_return_afull ;
logic fifo_freelist_return_empty ;
logic fifo_freelist_return_error_of ;
logic fifo_freelist_return_error_uf ;
logic fifo_freelist_return_full_nc ;
logic fifo_freelist_return_pop ;
logic fifo_freelist_return_push ;
logic fifo_lsp_aqed_cmp_afull ;
logic fifo_lsp_aqed_cmp_empty ;
logic fifo_lsp_aqed_cmp_error_of ;
logic fifo_lsp_aqed_cmp_error_uf ;
logic fifo_lsp_aqed_cmp_full_nc ;
logic fifo_lsp_aqed_cmp_pop ;
logic fifo_lsp_aqed_cmp_push ;
logic fifo_qed_aqed_enq_afull_nc ;
logic fifo_qed_aqed_enq_error_of ;
logic fifo_qed_aqed_enq_error_uf ;
logic fifo_qed_aqed_enq_fid_afull_nc ;
logic fifo_qed_aqed_enq_fid_empty ;
logic fifo_qed_aqed_enq_fid_error_of ;
logic fifo_qed_aqed_enq_fid_error_uf ;
logic fifo_qed_aqed_enq_fid_full_nc ;
logic fifo_qed_aqed_enq_fid_pop ;
logic fifo_qed_aqed_enq_fid_push ;
logic fifo_qed_aqed_enq_full ;
logic fifo_qed_aqed_enq_pop ;
logic fifo_qed_aqed_enq_pop_data_v ;
logic fifo_qed_aqed_enq_push ;
logic fifo_qed_aqed_enq_push_f , fifo_qed_aqed_enq_push_nxt ;
logic p0_ll_v_f , p0_ll_v_nxt , p1_ll_v_f , p1_ll_v_nxt , p2_ll_v_f , p2_ll_v_nxt , p3_ll_v_f , p3_ll_v_nxt , p4_ll_v_f , p4_ll_v_nxt , p5_ll_v_f , p5_ll_v_nxt , p6_ll_v_f , p6_ll_v_nxt , p7_ll_v_f , p7_ll_v_nxt , p8_ll_v_f , p8_ll_v_nxt , p9_ll_v_f , p9_ll_v_nxt , p10_ll_v_f , p10_ll_v_nxt , p11_ll_v_f , p11_ll_v_nxt , p12_ll_v_f , p12_ll_v_nxt , p13_ll_v_f , p13_ll_v_nxt ;
logic parity_check_db_ap_aqed_e ;
logic parity_check_db_ap_aqed_error ;
logic parity_check_db_ap_aqed_fid_e ;
logic parity_check_db_ap_aqed_fid_error ;
logic parity_check_db_ap_aqed_fid_p ;
logic parity_check_db_ap_aqed_p ;
logic parity_check_fid_e ;
logic parity_check_fid_error ;
logic parity_check_fid_p ;
logic parity_check_hid_e ;
logic parity_check_hid_error ;
logic parity_check_hid_p ;
logic parity_check_ll_rmw_hp_p2_e ;
logic parity_check_ll_rmw_hp_p2_error ;
logic parity_check_ll_rmw_hp_p2_p ;
logic parity_check_ll_rmw_tp_p2_e ;
logic parity_check_ll_rmw_tp_p2_error ;
logic parity_check_ll_rmw_tp_p2_p ;
logic parity_check_ll_rw_ll_qe_hpnxt_p2_data_e ;
logic parity_check_ll_rw_ll_qe_hpnxt_p2_data_error ;
logic parity_check_ll_rw_ll_qe_hpnxt_p2_data_p ;
logic parity_gen_aqed_ap_p ;
logic parity_gen_fid_p ;
logic residue_check_ll_cnt_e_nxt , residue_check_ll_cnt_e_f ;
logic residue_check_ll_cnt_err ;
logic rw_aqed_p0_byp_v_nxt ;
logic rw_aqed_p0_hold ;
logic rw_aqed_p0_v_f ;
logic rw_aqed_p0_v_nxt ;
logic rw_aqed_p1_hold ;
logic rw_aqed_p1_v_f ;
logic rw_aqed_p2_hold ;
logic rw_aqed_p2_v_f ;
logic rw_aqed_p3_hold ;
logic rw_aqed_p3_v_f ;
logic rw_aqed_status ;
logic rw_ll_qe_hpnxt_p0_byp_v_nxt ;
logic rw_ll_qe_hpnxt_p0_hold ;
logic rw_ll_qe_hpnxt_p0_v_f ;
logic rw_ll_qe_hpnxt_p0_v_nxt ;
logic rw_ll_qe_hpnxt_p1_hold ;
logic rw_ll_qe_hpnxt_p1_v_f ;
logic rw_ll_qe_hpnxt_p2_hold ;
logic rw_ll_qe_hpnxt_p2_v_f ;
logic rw_ll_qe_hpnxt_p3_hold ;
logic rw_ll_qe_hpnxt_p3_v_f ;
logic rw_ll_qe_hpnxt_status ;
logic rx_sync_qed_aqed_enq_ready ;
logic rx_sync_qed_aqed_enq_valid ;
logic smon_interrupt_nc ;
logic [ ( $bits ( aqed_alarm_up_data.unit ) - 1 ) : 0 ] int_uid ;
logic [ ( ( 8 * 2 ) + 2 + 6 ) - 1 : 0 ] fid_bcam_error ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_active_0_nxt , reset_pf_active_0_f ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_active_1_nxt , reset_pf_active_1_f ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_done_0_nxt , reset_pf_done_0_f ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_done_1_nxt , reset_pf_done_1_f ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control0_f , cfg_control0_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control1_f , cfg_control1_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control2_f , cfg_control2_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control3_f , cfg_control3_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control4_f , cfg_control4_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_csr_control_f , cfg_csr_control_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_error_inj_f , cfg_error_inj_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_interface_f , cfg_interface_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_hold_f , cfg_pipe_health_hold_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_valid_f_nc , cfg_pipe_health_valid_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status0 ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status1 ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status2 ;
logic [ ( 10 ) - 1 : 0 ] parity_gen_aqed_ap_d ;
logic [ ( 11 ) - 1 : 0 ] in_cmp_fid ;
logic [ ( 11 ) - 1 : 0 ] out_enq_fid ;
logic [ ( 12 ) - 1 : 0 ] parity_check_db_ap_aqed_fid_d ;
logic [ ( 12 ) - 1 : 0 ] parity_check_fid_d ;
logic [ ( 12 ) - 1 : 0 ] parity_gen_fid_d ;
logic [ ( 13 ) - 1 : 0 ] cfgsc_parity_gen_qid_fid_limit_d ;
logic [ ( 139 ) - 1 : 0 ] rw_aqed_p0_byp_write_data_nxt_nc ;
logic [ ( 139 ) - 1 : 0 ] rw_aqed_p0_data_f_nc ;
logic [ ( 139 ) - 1 : 0 ] rw_aqed_p0_write_data_nxt ;
logic [ ( 139 ) - 1 : 0 ] rw_aqed_p1_data_f_nc ;
logic [ ( 139 ) - 1 : 0 ] rw_aqed_p2_data_f ;
logic [ ( 139 ) - 1 : 0 ] rw_aqed_p3_data_f_nc ;
logic [ ( 16 ) - 1 : 0 ] complockid_in_lockid ;
logic [ ( 16 ) - 1 : 0 ] complockid_in_lockid_completion ;
logic [ ( 16 ) - 1 : 0 ] complockid_out_lockid ;
logic [ ( 16 ) - 1 : 0 ] complockid_out_lockid_completion ;
logic [ ( 16 ) - 1 : 0 ] in_cmp_hid ;
logic [ ( 16 ) - 1 : 0 ] in_enq_hid ;
logic [ ( 16 ) - 1 : 0 ] parity_check_hid_d ;
logic [ ( 16 * 1 ) - 1 : 0 ] smon_v_f , smon_v_nxt ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_comp_f , smon_comp_nxt ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_val_f , smon_val_nxt ;
logic [ ( 18 ) - 1 : 0 ] parity_check_db_ap_aqed_d ;
logic [ ( 2 ) - 1 : 0 ] error_ll_headroom ;
logic [ ( 2 ) - 1 : 0 ] residue_add_ll_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_ll_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_ll_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_cnt_r_nxt , residue_check_ll_cnt_r_f ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_ll_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_ll_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_ll_cnt_r ;
logic [ ( 3 ) - 1 : 0 ] arb_ll_cnt_winner ;
logic [ ( 3 ) - 1 : 0 ] arb_ll_reqs ;
logic [ ( 3 ) - 1 : 0 ] fifo_qed_aqed_enq_push_credits_f , fifo_qed_aqed_enq_push_credits_nxt ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_control_nxt , cfg_agitate_control_f ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_select_f ;
logic [ ( 32 ) - 1 : 0 ] int_status ;
logic [ ( 32 ) - 1 : 0 ] reset_pf_counter_0_nxt , reset_pf_counter_0_f ;
logic [ ( 32 ) - 1 : 0 ] reset_pf_counter_1_nxt , reset_pf_counter_1_f ;
logic [ ( 4 ) - 1 : 0 ] fifo_qed_aqed_enq_fid_credits_f ;
logic [ ( 4 ) - 1 : 0 ] fifo_qed_aqed_enq_fid_credits_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_aqed_ap_enq_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_aqed_ap_enq_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_aqed_chp_sch_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_aqed_chp_sch_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_freelist_return_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_freelist_return_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] mf_cfg_req_read ;
logic [ ( 5 ) - 1 : 0 ] mf_cfg_req_write ;
logic [ ( 59 ) - 1 : 0 ] ecc_check_hcw_h_din ;
logic [ ( 59 ) - 1 : 0 ] ecc_check_hcw_h_dout ;
logic [ ( 64 ) - 1 : 0 ] ecc_check_hcw_l_din ;
logic [ ( 64 ) - 1 : 0 ] ecc_check_hcw_l_dout ;
logic [ ( 59 ) - 1 : 0 ] ecc_gen_hcw_h_d_nc ;
logic [ ( 64 ) - 1 : 0 ] ecc_gen_hcw_l_d_nc ;
logic [ ( 7 ) - 1 : 0 ] complockid_in_qid ;
logic [ ( 7 ) - 1 : 0 ] complockid_in_qid_completion ;
logic [ ( 7 ) - 1 : 0 ] db_ap_aqed_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] db_aqed_ap_enq_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] db_aqed_chp_sch_status_pnc ;
logic db_aqed_chp_sch_idle ;
logic [ ( 7 ) - 1 : 0 ] db_aqed_lsp_sch_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] db_lsp_aqed_cmp_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] in_cmp_qid ;
logic [ ( 7 ) - 1 : 0 ] in_enq_qid ;
aw_fifo_status_t rx_sync_qed_aqed_enq_status_pnc ;
logic [ ( 8 ) - 1 : 0 ] arb_ll_cnt_reqs ;
logic [ ( 8 ) - 1 : 0 ] ecc_check_hcw_h_ecc ;
logic [ ( 8 ) - 1 : 0 ] ecc_check_hcw_l_ecc ;
logic [ ( 8 ) - 1 : 0 ] ecc_gen_hcw_h_ecc ;
logic [ ( 8 ) - 1 : 0 ] ecc_gen_hcw_l_ecc ;
logic [ ( 9 ) - 1 : 0 ] fid_bcam_pipe_health ;
logic [ ( HQM_AQED_ADDR_WIDTH ) - 1 : 0 ] rw_aqed_p0_addr_f_nc ;
logic [ ( HQM_AQED_ADDR_WIDTH ) - 1 : 0 ] rw_aqed_p0_addr_nxt ;
logic [ ( HQM_AQED_ADDR_WIDTH ) - 1 : 0 ] rw_aqed_p0_byp_addr_nxt ;
logic [ ( HQM_AQED_ADDR_WIDTH ) - 1 : 0 ] rw_aqed_p1_addr_f_nc ;
logic [ ( HQM_AQED_ADDR_WIDTH ) - 1 : 0 ] rw_aqed_p2_addr_f_nc ;
logic [ ( HQM_AQED_ADDR_WIDTH ) - 1 : 0 ] rw_aqed_p3_addr_f_nc ;
logic [ ( HQM_AQED_ALARM_NUM_COR ) - 1 : 0 ] int_cor_v ;
logic [ ( HQM_AQED_ALARM_NUM_INF ) - 1 : 0 ] int_inf_v ;
logic [ ( HQM_AQED_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_v ;
logic [ ( HQM_AQED_CNTB2 ) - 1 : 0 ] residue_check_ll_cnt_d_nxt , residue_check_ll_cnt_d_f ;
logic [ ( HQM_AQED_CNTB2 ) - 1 : 0 ] rmw_ll_cnt_p3_bypdata_cnt_nnc ;
logic [ ( HQM_AQED_CNTB2 + 1 + 1 ) - 1 : 0 ] fid_bcam_total_fid ;
logic [ ( HQM_AQED_CNTB2 + 1 + 1 ) - 1 : 0 ] fid_bcam_total_qid ;
logic [ ( HQM_AQED_DATA ) - 1 : 0 ] ecc_check_din ;
logic [ ( HQM_AQED_DATA ) - 1 : 0 ] ecc_check_dout ;
logic [ ( HQM_AQED_DATA ) - 1 : 0 ] ecc_d_default2 ;
logic [ ( HQM_AQED_DATA ) - 1 : 0 ] ecc_gen_d ;
logic [ ( HQM_AQED_DATA ) - 1 : 0 ] parity_check_d ;
logic [ ( HQM_AQED_DATA ) - 1 : 0 ] parity_gen_d ;
logic [ ( HQM_AQED_ECC ) - 1 : 0 ] ecc_check_ecc ;
logic [ ( HQM_AQED_ECC ) - 1 : 0 ] ecc_gen_default ;
logic [ ( HQM_AQED_ECC ) - 1 : 0 ] ecc_gen_default2 ;
logic [ ( HQM_AQED_ECC ) - 1 : 0 ] ecc_gen_ecc ;
logic [ ( HQM_AQED_FLIDB2 ) - 1 : 0 ] parity_check_ll_rmw_hp_p2_d ;
logic [ ( HQM_AQED_FLIDB2 ) - 1 : 0 ] parity_check_ll_rmw_tp_p2_d ;
logic [ ( HQM_AQED_FLIDB2 ) - 1 : 0 ] parity_check_ll_rw_ll_qe_hpnxt_p2_data_d ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DEPTHB2 ) - 1 : 0 ] rw_ll_qe_hpnxt_p0_addr_f_nc ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DEPTHB2 ) - 1 : 0 ] rw_ll_qe_hpnxt_p0_addr_nxt ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DEPTHB2 ) - 1 : 0 ] rw_ll_qe_hpnxt_p0_byp_addr_nxt ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DEPTHB2 ) - 1 : 0 ] rw_ll_qe_hpnxt_p1_addr_f_nc ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DEPTHB2 ) - 1 : 0 ] rw_ll_qe_hpnxt_p2_addr_f_nc ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DEPTHB2 ) - 1 : 0 ] rw_ll_qe_hpnxt_p3_addr_f_nc ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DWIDTH ) - 1 : 0 ] rw_ll_qe_hpnxt_p0_byp_write_data_nxt ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DWIDTH ) - 1 : 0 ] rw_ll_qe_hpnxt_p0_data_f_nc ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DWIDTH ) - 1 : 0 ] rw_ll_qe_hpnxt_p0_write_data_nxt ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DWIDTH ) - 1 : 0 ] rw_ll_qe_hpnxt_p1_data_f_nc ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DWIDTH ) - 1 : 0 ] rw_ll_qe_hpnxt_p2_data_f ;
logic [ ( HQM_AQED_LL_QE_HPNXT_DWIDTH ) - 1 : 0 ] rw_ll_qe_hpnxt_p3_data_f_nc ;
logic [ ( HQM_AQED_MF_DWIDTH ) - 1 : 0 ] mf_pop_data ;
logic [ ( HQM_AQED_MF_DWIDTH ) - 1 : 0 ] mf_push_data ;
logic [ ( HQM_AQED_MF_NFWIDTH ) - 1 : 0 ] mf_err_rid_nc ;
logic [ ( HQM_AQED_MF_NFWIDTH ) - 1 : 0 ] mf_fifo_num_nc ;

localparam HQM_AQED_NUM_PRI = 8 ;  //TOP HQM_AQED_NUM_PRI

logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] func_aqed_ll_cnt_we ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_PRI0_DEPTHB2 ) - 1 : 0 ] func_aqed_ll_cnt_waddr ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_PRI0_DWIDTH ) - 1 : 0 ] func_aqed_ll_cnt_wdata ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] func_aqed_ll_cnt_re ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_PRI0_DEPTHB2 ) - 1 : 0 ] func_aqed_ll_cnt_raddr ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_PRI0_DWIDTH ) - 1 : 0 ] func_aqed_ll_cnt_rdata ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] func_aqed_ll_qe_hp_we ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_PRI4_DEPTHB2 ) - 1 : 0 ] func_aqed_ll_qe_hp_waddr ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_PRI4_DWIDTH ) - 1 : 0 ] func_aqed_ll_qe_hp_wdata ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] func_aqed_ll_qe_hp_re ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_PRI4_DEPTHB2 ) - 1 : 0 ] func_aqed_ll_qe_hp_raddr ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_PRI4_DWIDTH ) - 1 : 0 ] func_aqed_ll_qe_hp_rdata ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] func_aqed_ll_qe_tp_we ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_PRI4_DEPTHB2 ) - 1 : 0 ] func_aqed_ll_qe_tp_waddr ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_PRI4_DWIDTH ) - 1 : 0 ] func_aqed_ll_qe_tp_wdata ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] func_aqed_ll_qe_tp_re ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_PRI4_DEPTHB2 ) - 1 : 0 ] func_aqed_ll_qe_tp_raddr ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_PRI4_DWIDTH ) - 1 : 0 ] func_aqed_ll_qe_tp_rdata ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p0_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p0_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p0_v_nxt ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p1_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p1_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p2_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p2_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p3_bypsel_nxt ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p3_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_p3_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_cnt_status ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p0_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p0_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p0_v_nxt ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p1_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p1_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p2_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p2_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p3_bypsel_nxt ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p3_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_p3_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_hp_status ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p0_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p0_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p0_v_nxt ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p1_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p1_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p2_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p2_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p3_bypsel_nxt ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p3_hold ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_p3_v_f ;
logic [ ( HQM_AQED_NUM_PRI * 1 ) - 1 : 0 ] rmw_ll_tp_status ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_cnt_p0_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_cnt_p1_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_cnt_p2_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_cnt_p3_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_hp_p0_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_hp_p1_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_hp_p2_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_hp_p3_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_tp_p0_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_tp_p1_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_tp_p2_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * 2 ) - 1 : 0 ] rmw_ll_tp_p3_rw_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_cnt_p0_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_cnt_p0_addr_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_cnt_p1_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_cnt_p2_addr_f ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_cnt_p3_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_cnt_p3_bypaddr_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_cnt_p0_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_cnt_p0_write_data_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_cnt_p1_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_cnt_p2_data_f ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_cnt_p3_bypdata_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_cnt_p3_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DEPTHB2 ) - 1 : 0 ] rmw_ll_hp_p0_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DEPTHB2 ) - 1 : 0 ] rmw_ll_hp_p0_addr_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DEPTHB2 ) - 1 : 0 ] rmw_ll_hp_p1_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DEPTHB2 ) - 1 : 0 ] rmw_ll_hp_p2_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DEPTHB2 ) - 1 : 0 ] rmw_ll_hp_p3_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DEPTHB2 ) - 1 : 0 ] rmw_ll_hp_p3_bypaddr_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DWIDTH ) - 1 : 0 ] rmw_ll_hp_p0_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DWIDTH ) - 1 : 0 ] rmw_ll_hp_p0_write_data_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DWIDTH ) - 1 : 0 ] rmw_ll_hp_p1_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DWIDTH ) - 1 : 0 ] rmw_ll_hp_p2_data_f ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DWIDTH ) - 1 : 0 ] rmw_ll_hp_p3_bypdata_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_HP_DWIDTH ) - 1 : 0 ] rmw_ll_hp_p3_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DEPTHB2 ) - 1 : 0 ] rmw_ll_tp_p0_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DEPTHB2 ) - 1 : 0 ] rmw_ll_tp_p0_addr_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DEPTHB2 ) - 1 : 0 ] rmw_ll_tp_p1_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DEPTHB2 ) - 1 : 0 ] rmw_ll_tp_p2_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DEPTHB2 ) - 1 : 0 ] rmw_ll_tp_p3_addr_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DEPTHB2 ) - 1 : 0 ] rmw_ll_tp_p3_bypaddr_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DWIDTH ) - 1 : 0 ] rmw_ll_tp_p0_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DWIDTH ) - 1 : 0 ] rmw_ll_tp_p0_write_data_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DWIDTH ) - 1 : 0 ] rmw_ll_tp_p1_data_f_nc ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DWIDTH ) - 1 : 0 ] rmw_ll_tp_p2_data_f ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DWIDTH ) - 1 : 0 ] rmw_ll_tp_p3_bypdata_nxt ;
logic [ ( HQM_AQED_NUM_PRI * HQM_AQED_LL_QE_TP_DWIDTH ) - 1 : 0 ] rmw_ll_tp_p3_data_f_nc ;
logic [ 5 : 0 ] p10_stall_nxt , p10_stall_f ;
logic [ HQM_AQED_FIFO_AP_AQED_WMWIDTH - 1 : 0 ] fifo_ap_aqed_cfg_high_wm ;
logic [ HQM_AQED_FIFO_AQED_AP_ENQ_WMWIDTH - 1 : 0 ] fifo_aqed_ap_enq_cfg_high_wm ;
logic [ HQM_AQED_FIFO_AQED_CHP_SCH_WMWIDTH - 1 : 0 ] fifo_aqed_chp_sch_cfg_high_wm ;
logic [ HQM_AQED_FIFO_FREELIST_RETURN_WMWIDTH - 1 : 0 ] fifo_freelist_return_cfg_high_wm ;
logic [ HQM_AQED_FIFO_LSP_AQED_CMP_WMWIDTH - 1 : 0 ] fifo_lsp_aqed_cmp_cfg_high_wm ;
logic [ HQM_AQED_FIFO_QED_AQED_ENQ_FID_WMWIDTH - 1 : 0 ] fifo_qed_aqed_enq_fid_cfg_high_wm ;
logic [ HQM_AQED_FIFO_QED_AQED_ENQ_WMWIDTH - 1 : 0 ] fifo_qed_aqed_enq_cfg_high_wm ;
logic aqed_lsp_stop_atqatm_nxt , aqed_lsp_stop_atqatm_f ;
logic debug_collide0 ;
logic debug_collide1 ;
logic debug_fidcnt_of ;
logic debug_fidcnt_uf ;
logic debug_hit ;
logic debug_qidcnt_of ;
logic debug_qidcnt_uf ;
logic ecc_check_dinv_v ;
logic ecc_check_error_mb ;
logic ecc_check_error_sb ;
logic ecc_check_hcw_h_correct ;
logic ecc_check_hcw_h_din_v ;
logic ecc_check_hcw_h_enable ;
logic ecc_check_hcw_h_error_mb ;
logic ecc_check_hcw_h_error_sb ;
logic ecc_check_hcw_l_correct ;
logic ecc_check_hcw_l_din_v ;
logic ecc_check_hcw_l_enable ;
logic ecc_check_hcw_l_error_mb ;
logic ecc_check_hcw_l_error_sb ;
logic error_vfreset_cfg ;
logic fid_bcam_init_active_nc ; //not used with ramaccess initialze
logic fid_bcam_notempty ;
logic fifo_aqed_ap_enq_dec ;
logic fifo_aqed_ap_enq_inc ;
logic fifo_aqed_chp_sch_dec ;
logic fifo_aqed_chp_sch_inc ;
logic fifo_freelist_return_dec ;
logic fifo_freelist_return_inc ;
logic fifo_lsp_aqed_cmp_pop_data_v ;
logic fifo_qed_aqed_enq_fid_dec ;
logic fifo_qed_aqed_enq_fid_inc ;
logic hw_init_done_0_nxt , hw_init_done_0_f ;
logic hw_init_done_1_nxt , hw_init_done_1_f ;
logic in_cmp_ack ;
logic in_cmp_v ;
logic in_enq_ack ;
logic in_enq_v ;
logic mf_cmd_v ;
logic mf_err_oflow ;
logic mf_err_residue ;
logic mf_err_residue_cfg ;
logic mf_err_uflow ;
logic mf_p0_hold ;
logic mf_p0_v_f_nc ;
logic mf_p1_hold ;
logic mf_p1_v_f_nc ;
logic mf_p2_hold ;
logic mf_p2_v_f_nc ;
logic mf_p3_hold ;
logic mf_p3_v_f_nc ;
logic mf_pop_data_last_nc ;
logic mf_pop_data_v_nc ;
logic mf_status ;
logic out_enq_v ;
logic p10_stall_nc ;
logic parity_check_e ;
logic parity_check_error ;
logic parity_check_p ;
logic parity_gen_p ;
logic rw_ll_qe_hpnxt_err_parity ;
logic rw_ll_qe_hpnxt_error_mb ;
logic rw_ll_qe_hpnxt_error_sb ;
logic wire_sr_aqed_ll_qe_hpnxt_we ;
logic wire_sr_aqed_we ;
logic [ ( 7 + 12 + 16 - 1 ) - 1 : 0 ] parity_gen_fifo_lsp_aqed_cmp_d ;
logic parity_gen_fifo_lsp_aqed_cmp_p ;
logic  parity_check_fifo_lsp_aqed_cmp_p ;
logic [ ( 7 + 12 + 16 - 1 ) - 1 : 0 ] parity_check_fifo_lsp_aqed_cmp_d ;
logic  parity_check_fifo_lsp_aqed_cmp_e ;
logic  parity_check_fifo_lsp_aqed_cmp_error ;
qed_aqed_enq_t fifo_qed_aqed_enq_push_data_f , fifo_qed_aqed_enq_push_data_nxt ;
qed_aqed_enq_t rx_sync_qed_aqed_enq_data ;
ap_aqed_t db_ap_aqed_data ;
aqed_ap_enq_t db_aqed_ap_enq_data ;
aqed_chp_sch_t db_aqed_chp_sch_data ;
aqed_lsp_sch_t db_aqed_lsp_sch_data ;
fifo_qed_aqed_enq_t fifo_qed_aqed_enq_push_data ;
fifo_qed_aqed_enq_t fifo_qed_aqed_enq_pop_data ;
qed_aqed_enq_fid_t fifo_qed_aqed_enq_fid_push_data ;
qed_aqed_enq_fid_t fifo_qed_aqed_enq_fid_pop_data_pnc ;
fifo_lsp_aqed_cmp_t fifo_lsp_aqed_cmp_push_data ;
fifo_lsp_aqed_cmp_t fifo_lsp_aqed_cmp_pop_data_pnc ;
aqed_ap_enq_t fifo_aqed_ap_enq_push_data ;
aqed_ap_enq_t fifo_aqed_ap_enq_pop_data ;
ap_aqed_t fifo_ap_aqed_push_data ;
ap_aqed_t fifo_ap_aqed_pop_data_pnc ;
aqed_chp_sch_t fifo_aqed_chp_sch_push_data ;
aqed_chp_sch_t fifo_aqed_chp_sch_pop_data_pnc ;
freelist_return_t fifo_freelist_return_push_data ;
freelist_return_t fifo_freelist_return_pop_data_pnc ;
enq_data_t in_enq_data ;
enq_data_t out_enq_data ;
lsp_aqed_cmp_t db_lsp_aqed_cmp_data ;
aw_fifo_status_t fifo_ap_aqed_status ;
aw_fifo_status_t fifo_qed_aqed_enq_status ;
aw_fifo_status_t fifo_qed_aqed_enq_fid_status ;
aw_fifo_status_t fifo_lsp_aqed_cmp_status ;
aw_fifo_status_t fifo_aqed_ap_enq_status ;
aw_fifo_status_t fifo_freelist_return_status ;
aw_fifo_status_t fifo_aqed_chp_sch_status ;


//------------------------------------------------------------------------------------------------------------------------------------------------
// Check for invalid paramter configation : This will produce a build error if a unsupported paramter value is used
generate
  if ( ~ ( HQM_AQED_DEPTH == ( 2 * 1024 ) ) ) begin : invalid_HQM_AQED_DEPTH_0
    for ( genvar g = HQM_AQED_DEPTH ; g <= HQM_AQED_DEPTH ; g = g + 1 ) begin : invalid_HQM_AQED_DEPTH_1
      INVALID_PARAM_COMBINATION u_invalid ( .invalid ( ) ) ;
    end
  end
endgenerate


//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: BEGIN common core interfaces
//*****************************************************************************************************
//*****************************************************************************************************

//---------------------------------------------------------------------------------------------------------
// common core - Reset
logic hqm_gated_rst_n_done;
assign hqm_gated_rst_n_done = reset_pf_done_0_f & reset_pf_done_1_f ;

logic rst_prep;
logic hqm_gated_rst_n;
logic hqm_inp_gated_rst_n;
assign rst_prep             = hqm_rst_prep_aqed;
assign hqm_gated_rst_n      = hqm_gated_rst_b_aqed;
assign hqm_inp_gated_rst_n  = hqm_inp_gated_rst_b_aqed;

logic hqm_gated_rst_n_start;
logic hqm_gated_rst_n_active;
assign hqm_gated_rst_n_start     = hqm_gated_rst_b_start_aqed;
assign hqm_gated_rst_n_active    = hqm_gated_rst_b_active_aqed;
assign hqm_gated_rst_b_done_aqed = hqm_gated_rst_n_done;
//---------------------------------------------------------------------------------------------------------
// common core - CFG accessible patch & proc registers 
// common core - RFW/SRW RAM gasket
// common core - RAM wrapper for all single PORT SR RAMs
// common core - RAM wrapper for all 2 port RF RAMs
// The following must be kept in-sync with generated code
// BEGIN HQM_CFG_ACCESS
logic [ ( HQM_AQED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write ; //I CFG
logic [ ( HQM_AQED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read ; //I CFG
cfg_req_t pfcsr_cfg_req ; //I CFG
logic pfcsr_cfg_rsp_ack ; //O CFG
logic pfcsr_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata ; //O CFG
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_aqed_csr_control_reg_nxt ; //I HQM_AQED_TARGET_CFG_AQED_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_aqed_csr_control_reg_f ; //O HQM_AQED_TARGET_CFG_AQED_CSR_CONTROL
logic hqm_aqed_target_cfg_aqed_csr_control_reg_v ; //I HQM_AQED_TARGET_CFG_AQED_CSR_CONTROL
logic hqm_aqed_target_cfg_aqed_qid_hid_width_reg_load ; //I HQM_AQED_TARGET_CFG_AQED_QID_HID_WIDTH
logic [ ( 1 * 3 * 32 ) - 1 : 0] hqm_aqed_target_cfg_aqed_qid_hid_width_reg_nxt ; //I HQM_AQED_TARGET_CFG_AQED_QID_HID_WIDTH
logic [ ( 1 * 3 * 32 ) - 1 : 0] hqm_aqed_target_cfg_aqed_qid_hid_width_reg_f ; //O HQM_AQED_TARGET_CFG_AQED_QID_HID_WIDTH
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_nxt ; //I HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_f ; //O HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0
logic hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_v ; //I HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_1_status ; //I HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_1
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_control_general_reg_nxt ; //I HQM_AQED_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_control_general_reg_f ; //O HQM_AQED_TARGET_CFG_CONTROL_GENERAL
logic hqm_aqed_target_cfg_control_general_reg_v ; //I HQM_AQED_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_control_pipeline_credits_reg_nxt ; //I HQM_AQED_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_control_pipeline_credits_reg_f ; //O HQM_AQED_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_detect_feature_operation_00_reg_nxt ; //I HQM_AQED_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_detect_feature_operation_00_reg_f ; //O HQM_AQED_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_diagnostic_aw_status_status ; //I HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_diagnostic_aw_status_01_status ; //I HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_diagnostic_aw_status_02_status ; //I HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_error_inject_reg_nxt ; //I HQM_AQED_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_error_inject_reg_f ; //O HQM_AQED_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt ; //I HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_f ; //O HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt ; //I HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f ; //O HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_nxt ; //I HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_f ; //O HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_nxt ; //I HQM_AQED_TARGET_CFG_FIFO_WMSTAT_FREELIST_RETURN
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_f ; //O HQM_AQED_TARGET_CFG_FIFO_WMSTAT_FREELIST_RETURN
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_nxt ; //I HQM_AQED_TARGET_CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_f ; //O HQM_AQED_TARGET_CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_nxt ; //I HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_f ; //O HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_nxt ; //I HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_f ; //O HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_hw_agitate_control_reg_nxt ; //I HQM_AQED_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_hw_agitate_control_reg_f ; //O HQM_AQED_TARGET_CFG_HW_AGITATE_CONTROL
logic hqm_aqed_target_cfg_hw_agitate_control_reg_v ; //I HQM_AQED_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_hw_agitate_select_reg_nxt ; //I HQM_AQED_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_hw_agitate_select_reg_f ; //O HQM_AQED_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_aqed_target_cfg_hw_agitate_select_reg_v ; //I HQM_AQED_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_interface_status_reg_nxt ; //I HQM_AQED_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_interface_status_reg_f ; //O HQM_AQED_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_patch_control_reg_nxt ; //I HQM_AQED_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_patch_control_reg_f ; //O HQM_AQED_TARGET_CFG_PATCH_CONTROL
logic hqm_aqed_target_cfg_patch_control_reg_v ; //I HQM_AQED_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_pipe_health_hold_reg_nxt ; //I HQM_AQED_TARGET_CFG_PIPE_HEALTH_HOLD
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_pipe_health_hold_reg_f ; //O HQM_AQED_TARGET_CFG_PIPE_HEALTH_HOLD
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_pipe_health_valid_reg_nxt ; //I HQM_AQED_TARGET_CFG_PIPE_HEALTH_VALID
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_pipe_health_valid_reg_f ; //O HQM_AQED_TARGET_CFG_PIPE_HEALTH_VALID
logic hqm_aqed_target_cfg_smon_disable_smon ; //I HQM_AQED_TARGET_CFG_SMON
logic [ 16 - 1 : 0 ] hqm_aqed_target_cfg_smon_smon_v ; //I HQM_AQED_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_aqed_target_cfg_smon_smon_comp ; //I HQM_AQED_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_aqed_target_cfg_smon_smon_val ; //I HQM_AQED_TARGET_CFG_SMON
logic hqm_aqed_target_cfg_smon_smon_enabled ; //O HQM_AQED_TARGET_CFG_SMON
logic hqm_aqed_target_cfg_smon_smon_interrupt ; //O HQM_AQED_TARGET_CFG_SMON
logic hqm_aqed_target_cfg_syndrome_00_capture_v ; //I HQM_AQED_TARGET_CFG_SYNDROME_00
logic [ ( 31 ) - 1 : 0] hqm_aqed_target_cfg_syndrome_00_capture_data ; //I HQM_AQED_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_syndrome_00_syndrome_data ; //I HQM_AQED_TARGET_CFG_SYNDROME_00
logic hqm_aqed_target_cfg_syndrome_01_capture_v ; //I HQM_AQED_TARGET_CFG_SYNDROME_01
logic [ ( 31 ) - 1 : 0] hqm_aqed_target_cfg_syndrome_01_capture_data ; //I HQM_AQED_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_syndrome_01_syndrome_data ; //I HQM_AQED_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_unit_idle_reg_nxt ; //I HQM_AQED_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_unit_idle_reg_f ; //O HQM_AQED_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_unit_timeout_reg_nxt ; //I HQM_AQED_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_unit_timeout_reg_f ; //O HQM_AQED_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_aqed_target_cfg_unit_version_status ; //I HQM_AQED_TARGET_CFG_UNIT_VERSION
hqm_aqed_pipe_register_pfcsr i_hqm_aqed_pipe_register_pfcsr (
  .hqm_gated_clk ( hqm_gated_clk ) 
, .hqm_gated_rst_n ( hqm_gated_rst_n ) 
, .rst_prep ( '0 )
, .cfg_req_write ( pfcsr_cfg_req_write )
, .cfg_req_read ( pfcsr_cfg_req_read )
, .cfg_req ( pfcsr_cfg_req )
, .cfg_rsp_ack ( pfcsr_cfg_rsp_ack )
, .cfg_rsp_err ( pfcsr_cfg_rsp_err )
, .cfg_rsp_rdata ( pfcsr_cfg_rsp_rdata )
, .hqm_aqed_target_cfg_aqed_csr_control_reg_nxt ( hqm_aqed_target_cfg_aqed_csr_control_reg_nxt )
, .hqm_aqed_target_cfg_aqed_csr_control_reg_f ( hqm_aqed_target_cfg_aqed_csr_control_reg_f )
, .hqm_aqed_target_cfg_aqed_csr_control_reg_v (  hqm_aqed_target_cfg_aqed_csr_control_reg_v )
, .hqm_aqed_target_cfg_aqed_qid_hid_width_reg_load ( hqm_aqed_target_cfg_aqed_qid_hid_width_reg_load )
, .hqm_aqed_target_cfg_aqed_qid_hid_width_reg_nxt ( hqm_aqed_target_cfg_aqed_qid_hid_width_reg_nxt )
, .hqm_aqed_target_cfg_aqed_qid_hid_width_reg_f ( hqm_aqed_target_cfg_aqed_qid_hid_width_reg_f )
, .hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_nxt ( hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_nxt )
, .hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_f ( hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_f )
, .hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_v (  hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_v )
, .hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_1_status ( hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_1_status )
, .hqm_aqed_target_cfg_control_general_reg_nxt ( hqm_aqed_target_cfg_control_general_reg_nxt )
, .hqm_aqed_target_cfg_control_general_reg_f ( hqm_aqed_target_cfg_control_general_reg_f )
, .hqm_aqed_target_cfg_control_general_reg_v (  hqm_aqed_target_cfg_control_general_reg_v )
, .hqm_aqed_target_cfg_control_pipeline_credits_reg_nxt ( hqm_aqed_target_cfg_control_pipeline_credits_reg_nxt )
, .hqm_aqed_target_cfg_control_pipeline_credits_reg_f ( hqm_aqed_target_cfg_control_pipeline_credits_reg_f )
, .hqm_aqed_target_cfg_detect_feature_operation_00_reg_nxt ( hqm_aqed_target_cfg_detect_feature_operation_00_reg_nxt )
, .hqm_aqed_target_cfg_detect_feature_operation_00_reg_f ( hqm_aqed_target_cfg_detect_feature_operation_00_reg_f )
, .hqm_aqed_target_cfg_diagnostic_aw_status_status ( hqm_aqed_target_cfg_diagnostic_aw_status_status )
, .hqm_aqed_target_cfg_diagnostic_aw_status_01_status ( hqm_aqed_target_cfg_diagnostic_aw_status_01_status )
, .hqm_aqed_target_cfg_diagnostic_aw_status_02_status ( hqm_aqed_target_cfg_diagnostic_aw_status_02_status )
, .hqm_aqed_target_cfg_error_inject_reg_nxt ( hqm_aqed_target_cfg_error_inject_reg_nxt )
, .hqm_aqed_target_cfg_error_inject_reg_f ( hqm_aqed_target_cfg_error_inject_reg_f )
, .hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt ( hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt )
, .hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_f ( hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_f )
, .hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt ( hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt )
, .hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f ( hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f )
, .hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_nxt ( hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_nxt )
, .hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_f ( hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_f )
, .hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_nxt ( hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_nxt )
, .hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_f ( hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_f )
, .hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_nxt ( hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_nxt )
, .hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_f ( hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_f )
, .hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_nxt ( hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_nxt )
, .hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_f ( hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_f )
, .hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_nxt ( hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_nxt )
, .hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_f ( hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_f )
, .hqm_aqed_target_cfg_hw_agitate_control_reg_nxt ( hqm_aqed_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_aqed_target_cfg_hw_agitate_control_reg_f ( hqm_aqed_target_cfg_hw_agitate_control_reg_f )
, .hqm_aqed_target_cfg_hw_agitate_control_reg_v (  hqm_aqed_target_cfg_hw_agitate_control_reg_v )
, .hqm_aqed_target_cfg_hw_agitate_select_reg_nxt ( hqm_aqed_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_aqed_target_cfg_hw_agitate_select_reg_f ( hqm_aqed_target_cfg_hw_agitate_select_reg_f )
, .hqm_aqed_target_cfg_hw_agitate_select_reg_v (  hqm_aqed_target_cfg_hw_agitate_select_reg_v )
, .hqm_aqed_target_cfg_interface_status_reg_nxt ( hqm_aqed_target_cfg_interface_status_reg_nxt )
, .hqm_aqed_target_cfg_interface_status_reg_f ( hqm_aqed_target_cfg_interface_status_reg_f )
, .hqm_aqed_target_cfg_patch_control_reg_nxt ( hqm_aqed_target_cfg_patch_control_reg_nxt )
, .hqm_aqed_target_cfg_patch_control_reg_f ( hqm_aqed_target_cfg_patch_control_reg_f )
, .hqm_aqed_target_cfg_patch_control_reg_v (  hqm_aqed_target_cfg_patch_control_reg_v )
, .hqm_aqed_target_cfg_pipe_health_hold_reg_nxt ( hqm_aqed_target_cfg_pipe_health_hold_reg_nxt )
, .hqm_aqed_target_cfg_pipe_health_hold_reg_f ( hqm_aqed_target_cfg_pipe_health_hold_reg_f )
, .hqm_aqed_target_cfg_pipe_health_valid_reg_nxt ( hqm_aqed_target_cfg_pipe_health_valid_reg_nxt )
, .hqm_aqed_target_cfg_pipe_health_valid_reg_f ( hqm_aqed_target_cfg_pipe_health_valid_reg_f )
, .hqm_aqed_target_cfg_smon_disable_smon ( hqm_aqed_target_cfg_smon_disable_smon )
, .hqm_aqed_target_cfg_smon_smon_v ( hqm_aqed_target_cfg_smon_smon_v )
, .hqm_aqed_target_cfg_smon_smon_comp ( hqm_aqed_target_cfg_smon_smon_comp )
, .hqm_aqed_target_cfg_smon_smon_val ( hqm_aqed_target_cfg_smon_smon_val )
, .hqm_aqed_target_cfg_smon_smon_enabled ( hqm_aqed_target_cfg_smon_smon_enabled )
, .hqm_aqed_target_cfg_smon_smon_interrupt ( hqm_aqed_target_cfg_smon_smon_interrupt )
, .hqm_aqed_target_cfg_syndrome_00_capture_v ( hqm_aqed_target_cfg_syndrome_00_capture_v )
, .hqm_aqed_target_cfg_syndrome_00_capture_data ( hqm_aqed_target_cfg_syndrome_00_capture_data )
, .hqm_aqed_target_cfg_syndrome_00_syndrome_data ( hqm_aqed_target_cfg_syndrome_00_syndrome_data )
, .hqm_aqed_target_cfg_syndrome_01_capture_v ( hqm_aqed_target_cfg_syndrome_01_capture_v )
, .hqm_aqed_target_cfg_syndrome_01_capture_data ( hqm_aqed_target_cfg_syndrome_01_capture_data )
, .hqm_aqed_target_cfg_syndrome_01_syndrome_data ( hqm_aqed_target_cfg_syndrome_01_syndrome_data )
, .hqm_aqed_target_cfg_unit_idle_reg_nxt ( hqm_aqed_target_cfg_unit_idle_reg_nxt )
, .hqm_aqed_target_cfg_unit_idle_reg_f ( hqm_aqed_target_cfg_unit_idle_reg_f )
, .hqm_aqed_target_cfg_unit_timeout_reg_nxt ( hqm_aqed_target_cfg_unit_timeout_reg_nxt )
, .hqm_aqed_target_cfg_unit_timeout_reg_f ( hqm_aqed_target_cfg_unit_timeout_reg_f )
, .hqm_aqed_target_cfg_unit_version_status ( hqm_aqed_target_cfg_unit_version_status )
) ;
// END HQM_CFG_ACCESS

logic clk_pre_rcb_lcb;
assign clk_pre_rcb_lcb = hqm_ungated_clk ;

// BEGIN HQM_RAM_ACCESS
localparam NUM_CFG_ACCESSIBLE_RAM = 3;
localparam CFG_ACCESSIBLE_RAM_AQED = 0; // HQM_AQED_TARGET_CFG_AQED_WRD0 HQM_AQED_TARGET_CFG_AQED_WRD1 HQM_AQED_TARGET_CFG_AQED_WRD2 HQM_AQED_TARGET_CFG_AQED_WRD3
localparam CFG_ACCESSIBLE_RAM_AQED_QID_FID_LIMIT = 1; // HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT
localparam CFG_ACCESSIBLE_RAM_AW_BCAM_2048X26 = 2; // HQM_AQED_TARGET_CFG_AQED_BCAM
logic [(  3 *  1)-1:0] cfg_mem_re;
logic [(  3 *  1)-1:0] cfg_mem_we;
logic [(      20)-1:0] cfg_mem_addr;
logic [(      12)-1:0] cfg_mem_minbit;
logic [(      12)-1:0] cfg_mem_maxbit;
logic [(      32)-1:0] cfg_mem_wdata;
logic [(  3 * 32)-1:0] cfg_mem_rdata;
logic [(  3 *  1)-1:0] cfg_mem_ack;
logic                  cfg_mem_cc_v;
logic [(       8)-1:0] cfg_mem_cc_value;
logic [(       4)-1:0] cfg_mem_cc_width;
logic [(      12)-1:0] cfg_mem_cc_position;


logic                  hqm_aqed_pipe_rfw_top_ipar_error;

logic [(       8)-1:0] func_FUNC_WEN_RF_IN_P0; //
logic [( 8 *   8)-1:0] func_FUNC_WR_ADDR_RF_IN_P0; //
logic [( 8 *  26)-1:0] func_FUNC_WR_DATA_RF_IN_P0; //
logic [(       8)-1:0] func_FUNC_CEN_RF_IN_P0; //
logic [( 8 *  26)-1:0] func_FUNC_CM_DATA_RF_IN_P0; //
logic [( 8 * 256)-1:0] func_CM_MATCH_RF_OUT_P0; //O
logic                   func_FUNC_REN_RF_IN_P0; //
logic [(       8)-1:0] func_FUNC_RD_ADDR_RF_IN_P0; //
logic [( 8 *  26)-1:0] func_DATA_RF_OUT_P0; //O
logic [(       8)-1:0] pf_FUNC_WEN_RF_IN_P0; //
logic [( 8 *   8)-1:0] pf_FUNC_WR_ADDR_RF_IN_P0; //
logic [( 8 *  26)-1:0] pf_FUNC_WR_DATA_RF_IN_P0; //
logic [(       8)-1:0] pf_FUNC_CEN_RF_IN_P0; //
logic [( 8 *  26)-1:0] pf_FUNC_CM_DATA_RF_IN_P0; //
logic [( 8 * 256)-1:0] pf_CM_MATCH_RF_OUT_P0; //O
logic                  pf_FUNC_REN_RF_IN_P0; //
logic [(       8)-1:0] pf_FUNC_RD_ADDR_RF_IN_P0; //
logic [( 8 *  26)-1:0] pf_DATA_RF_OUT_P0; //O
logic                  AW_bcam_2048x26_error; //O
logic                  func_aqed_fid_cnt_re; //I
logic [(      12)-1:0] func_aqed_fid_cnt_raddr; //I
logic [(      12)-1:0] func_aqed_fid_cnt_waddr; //I
logic                  func_aqed_fid_cnt_we;    //I
logic [(      15)-1:0] func_aqed_fid_cnt_wdata; //I
logic [(      15)-1:0] func_aqed_fid_cnt_rdata;

logic                pf_aqed_fid_cnt_re;    //I
logic [(      12)-1:0] pf_aqed_fid_cnt_raddr; //I
logic [(      12)-1:0] pf_aqed_fid_cnt_waddr; //I
logic                  pf_aqed_fid_cnt_we;    //I
logic [(      15)-1:0] pf_aqed_fid_cnt_wdata; //I
logic [(      15)-1:0] pf_aqed_fid_cnt_rdata;

logic                  rf_aqed_fid_cnt_error;

logic                  func_aqed_fifo_ap_aqed_re; //I
logic [(       4)-1:0] func_aqed_fifo_ap_aqed_raddr; //I
logic [(       4)-1:0] func_aqed_fifo_ap_aqed_waddr; //I
logic                  func_aqed_fifo_ap_aqed_we;    //I
logic [(      45)-1:0] func_aqed_fifo_ap_aqed_wdata; //I
logic [(      45)-1:0] func_aqed_fifo_ap_aqed_rdata;

logic                pf_aqed_fifo_ap_aqed_re;    //I
logic [(       4)-1:0] pf_aqed_fifo_ap_aqed_raddr; //I
logic [(       4)-1:0] pf_aqed_fifo_ap_aqed_waddr; //I
logic                  pf_aqed_fifo_ap_aqed_we;    //I
logic [(      45)-1:0] pf_aqed_fifo_ap_aqed_wdata; //I
logic [(      45)-1:0] pf_aqed_fifo_ap_aqed_rdata;

logic                  rf_aqed_fifo_ap_aqed_error;

logic                  func_aqed_fifo_aqed_ap_enq_re; //I
logic [(       4)-1:0] func_aqed_fifo_aqed_ap_enq_raddr; //I
logic [(       4)-1:0] func_aqed_fifo_aqed_ap_enq_waddr; //I
logic                  func_aqed_fifo_aqed_ap_enq_we;    //I
logic [(      24)-1:0] func_aqed_fifo_aqed_ap_enq_wdata; //I
logic [(      24)-1:0] func_aqed_fifo_aqed_ap_enq_rdata;

logic                pf_aqed_fifo_aqed_ap_enq_re;    //I
logic [(       4)-1:0] pf_aqed_fifo_aqed_ap_enq_raddr; //I
logic [(       4)-1:0] pf_aqed_fifo_aqed_ap_enq_waddr; //I
logic                  pf_aqed_fifo_aqed_ap_enq_we;    //I
logic [(      24)-1:0] pf_aqed_fifo_aqed_ap_enq_wdata; //I
logic [(      24)-1:0] pf_aqed_fifo_aqed_ap_enq_rdata;

logic                  rf_aqed_fifo_aqed_ap_enq_error;

logic                  func_aqed_fifo_aqed_chp_sch_re; //I
logic [(       4)-1:0] func_aqed_fifo_aqed_chp_sch_raddr; //I
logic [(       4)-1:0] func_aqed_fifo_aqed_chp_sch_waddr; //I
logic                  func_aqed_fifo_aqed_chp_sch_we;    //I
logic [(     180)-1:0] func_aqed_fifo_aqed_chp_sch_wdata; //I
logic [(     180)-1:0] func_aqed_fifo_aqed_chp_sch_rdata;

logic                pf_aqed_fifo_aqed_chp_sch_re;    //I
logic [(       4)-1:0] pf_aqed_fifo_aqed_chp_sch_raddr; //I
logic [(       4)-1:0] pf_aqed_fifo_aqed_chp_sch_waddr; //I
logic                  pf_aqed_fifo_aqed_chp_sch_we;    //I
logic [(     180)-1:0] pf_aqed_fifo_aqed_chp_sch_wdata; //I
logic [(     180)-1:0] pf_aqed_fifo_aqed_chp_sch_rdata;

logic                  rf_aqed_fifo_aqed_chp_sch_error;

logic                  func_aqed_fifo_freelist_return_re; //I
logic [(       4)-1:0] func_aqed_fifo_freelist_return_raddr; //I
logic [(       4)-1:0] func_aqed_fifo_freelist_return_waddr; //I
logic                  func_aqed_fifo_freelist_return_we;    //I
logic [(      32)-1:0] func_aqed_fifo_freelist_return_wdata; //I
logic [(      32)-1:0] func_aqed_fifo_freelist_return_rdata;

logic                pf_aqed_fifo_freelist_return_re;    //I
logic [(       4)-1:0] pf_aqed_fifo_freelist_return_raddr; //I
logic [(       4)-1:0] pf_aqed_fifo_freelist_return_waddr; //I
logic                  pf_aqed_fifo_freelist_return_we;    //I
logic [(      32)-1:0] pf_aqed_fifo_freelist_return_wdata; //I
logic [(      32)-1:0] pf_aqed_fifo_freelist_return_rdata;

logic                  rf_aqed_fifo_freelist_return_error;

logic                  func_aqed_fifo_lsp_aqed_cmp_re; //I
logic [(       4)-1:0] func_aqed_fifo_lsp_aqed_cmp_raddr; //I
logic [(       4)-1:0] func_aqed_fifo_lsp_aqed_cmp_waddr; //I
logic                  func_aqed_fifo_lsp_aqed_cmp_we;    //I
logic [(      35)-1:0] func_aqed_fifo_lsp_aqed_cmp_wdata; //I
logic [(      35)-1:0] func_aqed_fifo_lsp_aqed_cmp_rdata;

logic                pf_aqed_fifo_lsp_aqed_cmp_re;    //I
logic [(       4)-1:0] pf_aqed_fifo_lsp_aqed_cmp_raddr; //I
logic [(       4)-1:0] pf_aqed_fifo_lsp_aqed_cmp_waddr; //I
logic                  pf_aqed_fifo_lsp_aqed_cmp_we;    //I
logic [(      35)-1:0] pf_aqed_fifo_lsp_aqed_cmp_wdata; //I
logic [(      35)-1:0] pf_aqed_fifo_lsp_aqed_cmp_rdata;

logic                  rf_aqed_fifo_lsp_aqed_cmp_error;

logic                  func_aqed_fifo_qed_aqed_enq_re; //I
logic [(       2)-1:0] func_aqed_fifo_qed_aqed_enq_raddr; //I
logic [(       2)-1:0] func_aqed_fifo_qed_aqed_enq_waddr; //I
logic                  func_aqed_fifo_qed_aqed_enq_we;    //I
logic [(     155)-1:0] func_aqed_fifo_qed_aqed_enq_wdata; //I
logic [(     155)-1:0] func_aqed_fifo_qed_aqed_enq_rdata;

logic                pf_aqed_fifo_qed_aqed_enq_re;    //I
logic [(       2)-1:0] pf_aqed_fifo_qed_aqed_enq_raddr; //I
logic [(       2)-1:0] pf_aqed_fifo_qed_aqed_enq_waddr; //I
logic                  pf_aqed_fifo_qed_aqed_enq_we;    //I
logic [(     155)-1:0] pf_aqed_fifo_qed_aqed_enq_wdata; //I
logic [(     155)-1:0] pf_aqed_fifo_qed_aqed_enq_rdata;

logic                  rf_aqed_fifo_qed_aqed_enq_error;

logic                  func_aqed_fifo_qed_aqed_enq_fid_re; //I
logic [(       3)-1:0] func_aqed_fifo_qed_aqed_enq_fid_raddr; //I
logic [(       3)-1:0] func_aqed_fifo_qed_aqed_enq_fid_waddr; //I
logic                  func_aqed_fifo_qed_aqed_enq_fid_we;    //I
logic [(     153)-1:0] func_aqed_fifo_qed_aqed_enq_fid_wdata; //I
logic [(     153)-1:0] func_aqed_fifo_qed_aqed_enq_fid_rdata;

logic                pf_aqed_fifo_qed_aqed_enq_fid_re;    //I
logic [(       3)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_raddr; //I
logic [(       3)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_waddr; //I
logic                  pf_aqed_fifo_qed_aqed_enq_fid_we;    //I
logic [(     153)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_wdata; //I
logic [(     153)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_rdata;

logic                  rf_aqed_fifo_qed_aqed_enq_fid_error;

logic                  func_aqed_ll_cnt_pri0_re; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri0_raddr; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri0_waddr; //I
logic                  func_aqed_ll_cnt_pri0_we;    //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri0_wdata; //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri0_rdata;

logic                pf_aqed_ll_cnt_pri0_re;    //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri0_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri0_waddr; //I
logic                  pf_aqed_ll_cnt_pri0_we;    //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri0_wdata; //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri0_rdata;

logic                  rf_aqed_ll_cnt_pri0_error;

logic                  func_aqed_ll_cnt_pri1_re; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri1_raddr; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri1_waddr; //I
logic                  func_aqed_ll_cnt_pri1_we;    //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri1_wdata; //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri1_rdata;

logic                pf_aqed_ll_cnt_pri1_re;    //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri1_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri1_waddr; //I
logic                  pf_aqed_ll_cnt_pri1_we;    //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri1_wdata; //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri1_rdata;

logic                  rf_aqed_ll_cnt_pri1_error;

logic                  func_aqed_ll_cnt_pri2_re; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri2_raddr; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri2_waddr; //I
logic                  func_aqed_ll_cnt_pri2_we;    //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri2_wdata; //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri2_rdata;

logic                pf_aqed_ll_cnt_pri2_re;    //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri2_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri2_waddr; //I
logic                  pf_aqed_ll_cnt_pri2_we;    //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri2_wdata; //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri2_rdata;

logic                  rf_aqed_ll_cnt_pri2_error;

logic                  func_aqed_ll_cnt_pri3_re; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri3_raddr; //I
logic [(      12)-1:0] func_aqed_ll_cnt_pri3_waddr; //I
logic                  func_aqed_ll_cnt_pri3_we;    //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri3_wdata; //I
logic [(      14)-1:0] func_aqed_ll_cnt_pri3_rdata;

logic                pf_aqed_ll_cnt_pri3_re;    //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri3_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_cnt_pri3_waddr; //I
logic                  pf_aqed_ll_cnt_pri3_we;    //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri3_wdata; //I
logic [(      14)-1:0] pf_aqed_ll_cnt_pri3_rdata;

logic                  rf_aqed_ll_cnt_pri3_error;

logic                  func_aqed_ll_qe_hp_pri0_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_waddr; //I
logic                  func_aqed_ll_qe_hp_pri0_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_rdata;

logic                pf_aqed_ll_qe_hp_pri0_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_waddr; //I
logic                  pf_aqed_ll_qe_hp_pri0_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_rdata;

logic                  rf_aqed_ll_qe_hp_pri0_error;

logic                  func_aqed_ll_qe_hp_pri1_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_waddr; //I
logic                  func_aqed_ll_qe_hp_pri1_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_rdata;

logic                pf_aqed_ll_qe_hp_pri1_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_waddr; //I
logic                  pf_aqed_ll_qe_hp_pri1_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_rdata;

logic                  rf_aqed_ll_qe_hp_pri1_error;

logic                  func_aqed_ll_qe_hp_pri2_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_waddr; //I
logic                  func_aqed_ll_qe_hp_pri2_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_rdata;

logic                pf_aqed_ll_qe_hp_pri2_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_waddr; //I
logic                  pf_aqed_ll_qe_hp_pri2_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_rdata;

logic                  rf_aqed_ll_qe_hp_pri2_error;

logic                  func_aqed_ll_qe_hp_pri3_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_waddr; //I
logic                  func_aqed_ll_qe_hp_pri3_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_rdata;

logic                pf_aqed_ll_qe_hp_pri3_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_waddr; //I
logic                  pf_aqed_ll_qe_hp_pri3_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_rdata;

logic                  rf_aqed_ll_qe_hp_pri3_error;

logic                  func_aqed_ll_qe_tp_pri0_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_waddr; //I
logic                  func_aqed_ll_qe_tp_pri0_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_rdata;

logic                pf_aqed_ll_qe_tp_pri0_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_waddr; //I
logic                  pf_aqed_ll_qe_tp_pri0_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_rdata;

logic                  rf_aqed_ll_qe_tp_pri0_error;

logic                  func_aqed_ll_qe_tp_pri1_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_waddr; //I
logic                  func_aqed_ll_qe_tp_pri1_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_rdata;

logic                pf_aqed_ll_qe_tp_pri1_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_waddr; //I
logic                  pf_aqed_ll_qe_tp_pri1_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_rdata;

logic                  rf_aqed_ll_qe_tp_pri1_error;

logic                  func_aqed_ll_qe_tp_pri2_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_waddr; //I
logic                  func_aqed_ll_qe_tp_pri2_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_rdata;

logic                pf_aqed_ll_qe_tp_pri2_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_waddr; //I
logic                  pf_aqed_ll_qe_tp_pri2_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_rdata;

logic                  rf_aqed_ll_qe_tp_pri2_error;

logic                  func_aqed_ll_qe_tp_pri3_re; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_raddr; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_waddr; //I
logic                  func_aqed_ll_qe_tp_pri3_we;    //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_wdata; //I
logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_rdata;

logic                pf_aqed_ll_qe_tp_pri3_re;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_raddr; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_waddr; //I
logic                  pf_aqed_ll_qe_tp_pri3_we;    //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_wdata; //I
logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_rdata;

logic                  rf_aqed_ll_qe_tp_pri3_error;

logic                  func_aqed_qid_cnt_re; //I
logic [(       7)-1:0] func_aqed_qid_cnt_raddr; //I
logic [(       7)-1:0] func_aqed_qid_cnt_waddr; //I
logic                  func_aqed_qid_cnt_we;    //I
logic [(      15)-1:0] func_aqed_qid_cnt_wdata; //I
logic [(      15)-1:0] func_aqed_qid_cnt_rdata;

logic                pf_aqed_qid_cnt_re;    //I
logic [(       7)-1:0] pf_aqed_qid_cnt_raddr; //I
logic [(       7)-1:0] pf_aqed_qid_cnt_waddr; //I
logic                  pf_aqed_qid_cnt_we;    //I
logic [(      15)-1:0] pf_aqed_qid_cnt_wdata; //I
logic [(      15)-1:0] pf_aqed_qid_cnt_rdata;

logic                  rf_aqed_qid_cnt_error;

logic                  func_aqed_qid_fid_limit_re; //I
logic [(       7)-1:0] func_aqed_qid_fid_limit_addr; //I
logic                  func_aqed_qid_fid_limit_we;    //I
logic [(      14)-1:0] func_aqed_qid_fid_limit_wdata; //I
logic [(      14)-1:0] func_aqed_qid_fid_limit_rdata;

logic                pf_aqed_qid_fid_limit_re;    //I
logic [(       7)-1:0] pf_aqed_qid_fid_limit_addr;  //I
logic                  pf_aqed_qid_fid_limit_we;    //I
logic [(      14)-1:0] pf_aqed_qid_fid_limit_wdata; //I
logic [(      14)-1:0] pf_aqed_qid_fid_limit_rdata;

logic                  rf_aqed_qid_fid_limit_error;

logic                  func_rx_sync_qed_aqed_enq_re; //I
logic [(       2)-1:0] func_rx_sync_qed_aqed_enq_raddr; //I
logic [(       2)-1:0] func_rx_sync_qed_aqed_enq_waddr; //I
logic                  func_rx_sync_qed_aqed_enq_we;    //I
logic [(     139)-1:0] func_rx_sync_qed_aqed_enq_wdata; //I
logic [(     139)-1:0] func_rx_sync_qed_aqed_enq_rdata;

logic                pf_rx_sync_qed_aqed_enq_re;    //I
logic [(       2)-1:0] pf_rx_sync_qed_aqed_enq_raddr; //I
logic [(       2)-1:0] pf_rx_sync_qed_aqed_enq_waddr; //I
logic                  pf_rx_sync_qed_aqed_enq_we;    //I
logic [(     139)-1:0] pf_rx_sync_qed_aqed_enq_wdata; //I
logic [(     139)-1:0] pf_rx_sync_qed_aqed_enq_rdata;

logic                  rf_rx_sync_qed_aqed_enq_error;

logic                  func_aqed_re;    //I
logic [(      11)-1:0] func_aqed_addr;  //I
logic                  func_aqed_we;    //I
logic [(     139)-1:0] func_aqed_wdata; //I
logic [(     139)-1:0] func_aqed_rdata;

logic                  pf_aqed_re;   //I
logic [(      11)-1:0] pf_aqed_addr; //I
logic                  pf_aqed_we;   //I
logic [(     139)-1:0] pf_aqed_wdata; //I
logic [(     139)-1:0] pf_aqed_rdata;

logic                  sr_aqed_error;

logic                  func_aqed_freelist_re;    //I
logic [(      11)-1:0] func_aqed_freelist_addr;  //I
logic                  func_aqed_freelist_we;    //I
logic [(      16)-1:0] func_aqed_freelist_wdata; //I
logic [(      16)-1:0] func_aqed_freelist_rdata;

logic                  pf_aqed_freelist_re;   //I
logic [(      11)-1:0] pf_aqed_freelist_addr; //I
logic                  pf_aqed_freelist_we;   //I
logic [(      16)-1:0] pf_aqed_freelist_wdata; //I
logic [(      16)-1:0] pf_aqed_freelist_rdata;

logic                  sr_aqed_freelist_error;

logic                  func_aqed_ll_qe_hpnxt_re;    //I
logic [(      11)-1:0] func_aqed_ll_qe_hpnxt_addr;  //I
logic                  func_aqed_ll_qe_hpnxt_we;    //I
logic [(      16)-1:0] func_aqed_ll_qe_hpnxt_wdata; //I
logic [(      16)-1:0] func_aqed_ll_qe_hpnxt_rdata;

logic                  pf_aqed_ll_qe_hpnxt_re;   //I
logic [(      11)-1:0] pf_aqed_ll_qe_hpnxt_addr; //I
logic                  pf_aqed_ll_qe_hpnxt_we;   //I
logic [(      16)-1:0] pf_aqed_ll_qe_hpnxt_wdata; //I
logic [(      16)-1:0] pf_aqed_ll_qe_hpnxt_rdata;

logic                  sr_aqed_ll_qe_hpnxt_error;

hqm_aqed_pipe_ram_access i_hqm_aqed_pipe_ram_access (
  .clk_pre_rcb_lcb (clk_pre_rcb_lcb)
, .hqm_gated_clk (hqm_gated_clk)
, .hqm_inp_gated_clk (hqm_inp_gated_clk)
, .hqm_clk_rptr_rst_sync_b (hqm_clk_rptr_rst_sync_b)
, .hqm_clk_ungate (hqm_clk_ungate)
, .hqm_fullrate_clk (hqm_fullrate_clk)
, .hqm_gated_rst_n (hqm_gated_rst_n)
, .hqm_gatedclk_enable_and (hqm_gatedclk_enable_and)
, .hqm_inp_gated_rst_n (hqm_inp_gated_rst_n)
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

,.hqm_aqed_pipe_rfw_top_ipar_error (hqm_aqed_pipe_rfw_top_ipar_error)

,.func_FUNC_WEN_RF_IN_P0 (func_FUNC_WEN_RF_IN_P0)
,.func_FUNC_WR_ADDR_RF_IN_P0 (func_FUNC_WR_ADDR_RF_IN_P0)
,.func_FUNC_WR_DATA_RF_IN_P0 (func_FUNC_WR_DATA_RF_IN_P0)
,.func_FUNC_CEN_RF_IN_P0 (func_FUNC_CEN_RF_IN_P0)
,.func_FUNC_CM_DATA_RF_IN_P0 (func_FUNC_CM_DATA_RF_IN_P0)
,.func_CM_MATCH_RF_OUT_P0 (func_CM_MATCH_RF_OUT_P0)
,.func_FUNC_REN_RF_IN_P0 (func_FUNC_REN_RF_IN_P0)
,.func_FUNC_RD_ADDR_RF_IN_P0 (func_FUNC_RD_ADDR_RF_IN_P0)
,.func_DATA_RF_OUT_P0 (func_DATA_RF_OUT_P0)
,.pf_FUNC_WEN_RF_IN_P0 (pf_FUNC_WEN_RF_IN_P0)
,.pf_FUNC_WR_ADDR_RF_IN_P0 (pf_FUNC_WR_ADDR_RF_IN_P0)
,.pf_FUNC_WR_DATA_RF_IN_P0 (pf_FUNC_WR_DATA_RF_IN_P0)
,.pf_FUNC_CEN_RF_IN_P0 (pf_FUNC_CEN_RF_IN_P0)
,.pf_FUNC_CM_DATA_RF_IN_P0 (pf_FUNC_CM_DATA_RF_IN_P0)
,.pf_CM_MATCH_RF_OUT_P0 (pf_CM_MATCH_RF_OUT_P0)
,.pf_FUNC_REN_RF_IN_P0 (pf_FUNC_REN_RF_IN_P0)
,.pf_FUNC_RD_ADDR_RF_IN_P0 (pf_FUNC_RD_ADDR_RF_IN_P0)
,.pf_DATA_RF_OUT_P0 (pf_DATA_RF_OUT_P0)
,.bcam_AW_bcam_2048x26_wclk (bcam_AW_bcam_2048x26_wclk)
,.bcam_AW_bcam_2048x26_rclk (bcam_AW_bcam_2048x26_rclk)
,.bcam_AW_bcam_2048x26_cclk (bcam_AW_bcam_2048x26_cclk)
,.bcam_AW_bcam_2048x26_dfx_clk (bcam_AW_bcam_2048x26_dfx_clk)
,.bcam_AW_bcam_2048x26_we (bcam_AW_bcam_2048x26_we)
,.bcam_AW_bcam_2048x26_waddr (bcam_AW_bcam_2048x26_waddr)
,.bcam_AW_bcam_2048x26_wdata (bcam_AW_bcam_2048x26_wdata)
,.bcam_AW_bcam_2048x26_ce (bcam_AW_bcam_2048x26_ce)
,.bcam_AW_bcam_2048x26_cdata (bcam_AW_bcam_2048x26_cdata)
,.bcam_AW_bcam_2048x26_cmatch (bcam_AW_bcam_2048x26_cmatch)
,.bcam_AW_bcam_2048x26_re (bcam_AW_bcam_2048x26_re)
,.bcam_AW_bcam_2048x26_raddr (bcam_AW_bcam_2048x26_raddr)
,.bcam_AW_bcam_2048x26_rdata (bcam_AW_bcam_2048x26_rdata)
,.AW_bcam_2048x26_error (AW_bcam_2048x26_error)
,.func_aqed_fid_cnt_re    (func_aqed_fid_cnt_re)
,.func_aqed_fid_cnt_raddr (func_aqed_fid_cnt_raddr)
,.func_aqed_fid_cnt_waddr (func_aqed_fid_cnt_waddr)
,.func_aqed_fid_cnt_we    (func_aqed_fid_cnt_we)
,.func_aqed_fid_cnt_wdata (func_aqed_fid_cnt_wdata)
,.func_aqed_fid_cnt_rdata (func_aqed_fid_cnt_rdata)

,.pf_aqed_fid_cnt_re      (pf_aqed_fid_cnt_re)
,.pf_aqed_fid_cnt_raddr (pf_aqed_fid_cnt_raddr)
,.pf_aqed_fid_cnt_waddr (pf_aqed_fid_cnt_waddr)
,.pf_aqed_fid_cnt_we    (pf_aqed_fid_cnt_we)
,.pf_aqed_fid_cnt_wdata (pf_aqed_fid_cnt_wdata)
,.pf_aqed_fid_cnt_rdata (pf_aqed_fid_cnt_rdata)

,.rf_aqed_fid_cnt_rclk (rf_aqed_fid_cnt_rclk)
,.rf_aqed_fid_cnt_rclk_rst_n (rf_aqed_fid_cnt_rclk_rst_n)
,.rf_aqed_fid_cnt_re    (rf_aqed_fid_cnt_re)
,.rf_aqed_fid_cnt_raddr (rf_aqed_fid_cnt_raddr)
,.rf_aqed_fid_cnt_waddr (rf_aqed_fid_cnt_waddr)
,.rf_aqed_fid_cnt_wclk (rf_aqed_fid_cnt_wclk)
,.rf_aqed_fid_cnt_wclk_rst_n (rf_aqed_fid_cnt_wclk_rst_n)
,.rf_aqed_fid_cnt_we    (rf_aqed_fid_cnt_we)
,.rf_aqed_fid_cnt_wdata (rf_aqed_fid_cnt_wdata)
,.rf_aqed_fid_cnt_rdata (rf_aqed_fid_cnt_rdata)

,.rf_aqed_fid_cnt_error (rf_aqed_fid_cnt_error)

,.func_aqed_fifo_ap_aqed_re    (func_aqed_fifo_ap_aqed_re)
,.func_aqed_fifo_ap_aqed_raddr (func_aqed_fifo_ap_aqed_raddr)
,.func_aqed_fifo_ap_aqed_waddr (func_aqed_fifo_ap_aqed_waddr)
,.func_aqed_fifo_ap_aqed_we    (func_aqed_fifo_ap_aqed_we)
,.func_aqed_fifo_ap_aqed_wdata (func_aqed_fifo_ap_aqed_wdata)
,.func_aqed_fifo_ap_aqed_rdata (func_aqed_fifo_ap_aqed_rdata)

,.pf_aqed_fifo_ap_aqed_re      (pf_aqed_fifo_ap_aqed_re)
,.pf_aqed_fifo_ap_aqed_raddr (pf_aqed_fifo_ap_aqed_raddr)
,.pf_aqed_fifo_ap_aqed_waddr (pf_aqed_fifo_ap_aqed_waddr)
,.pf_aqed_fifo_ap_aqed_we    (pf_aqed_fifo_ap_aqed_we)
,.pf_aqed_fifo_ap_aqed_wdata (pf_aqed_fifo_ap_aqed_wdata)
,.pf_aqed_fifo_ap_aqed_rdata (pf_aqed_fifo_ap_aqed_rdata)

,.rf_aqed_fifo_ap_aqed_rclk (rf_aqed_fifo_ap_aqed_rclk)
,.rf_aqed_fifo_ap_aqed_rclk_rst_n (rf_aqed_fifo_ap_aqed_rclk_rst_n)
,.rf_aqed_fifo_ap_aqed_re    (rf_aqed_fifo_ap_aqed_re)
,.rf_aqed_fifo_ap_aqed_raddr (rf_aqed_fifo_ap_aqed_raddr)
,.rf_aqed_fifo_ap_aqed_waddr (rf_aqed_fifo_ap_aqed_waddr)
,.rf_aqed_fifo_ap_aqed_wclk (rf_aqed_fifo_ap_aqed_wclk)
,.rf_aqed_fifo_ap_aqed_wclk_rst_n (rf_aqed_fifo_ap_aqed_wclk_rst_n)
,.rf_aqed_fifo_ap_aqed_we    (rf_aqed_fifo_ap_aqed_we)
,.rf_aqed_fifo_ap_aqed_wdata (rf_aqed_fifo_ap_aqed_wdata)
,.rf_aqed_fifo_ap_aqed_rdata (rf_aqed_fifo_ap_aqed_rdata)

,.rf_aqed_fifo_ap_aqed_error (rf_aqed_fifo_ap_aqed_error)

,.func_aqed_fifo_aqed_ap_enq_re    (func_aqed_fifo_aqed_ap_enq_re)
,.func_aqed_fifo_aqed_ap_enq_raddr (func_aqed_fifo_aqed_ap_enq_raddr)
,.func_aqed_fifo_aqed_ap_enq_waddr (func_aqed_fifo_aqed_ap_enq_waddr)
,.func_aqed_fifo_aqed_ap_enq_we    (func_aqed_fifo_aqed_ap_enq_we)
,.func_aqed_fifo_aqed_ap_enq_wdata (func_aqed_fifo_aqed_ap_enq_wdata)
,.func_aqed_fifo_aqed_ap_enq_rdata (func_aqed_fifo_aqed_ap_enq_rdata)

,.pf_aqed_fifo_aqed_ap_enq_re      (pf_aqed_fifo_aqed_ap_enq_re)
,.pf_aqed_fifo_aqed_ap_enq_raddr (pf_aqed_fifo_aqed_ap_enq_raddr)
,.pf_aqed_fifo_aqed_ap_enq_waddr (pf_aqed_fifo_aqed_ap_enq_waddr)
,.pf_aqed_fifo_aqed_ap_enq_we    (pf_aqed_fifo_aqed_ap_enq_we)
,.pf_aqed_fifo_aqed_ap_enq_wdata (pf_aqed_fifo_aqed_ap_enq_wdata)
,.pf_aqed_fifo_aqed_ap_enq_rdata (pf_aqed_fifo_aqed_ap_enq_rdata)

,.rf_aqed_fifo_aqed_ap_enq_rclk (rf_aqed_fifo_aqed_ap_enq_rclk)
,.rf_aqed_fifo_aqed_ap_enq_rclk_rst_n (rf_aqed_fifo_aqed_ap_enq_rclk_rst_n)
,.rf_aqed_fifo_aqed_ap_enq_re    (rf_aqed_fifo_aqed_ap_enq_re)
,.rf_aqed_fifo_aqed_ap_enq_raddr (rf_aqed_fifo_aqed_ap_enq_raddr)
,.rf_aqed_fifo_aqed_ap_enq_waddr (rf_aqed_fifo_aqed_ap_enq_waddr)
,.rf_aqed_fifo_aqed_ap_enq_wclk (rf_aqed_fifo_aqed_ap_enq_wclk)
,.rf_aqed_fifo_aqed_ap_enq_wclk_rst_n (rf_aqed_fifo_aqed_ap_enq_wclk_rst_n)
,.rf_aqed_fifo_aqed_ap_enq_we    (rf_aqed_fifo_aqed_ap_enq_we)
,.rf_aqed_fifo_aqed_ap_enq_wdata (rf_aqed_fifo_aqed_ap_enq_wdata)
,.rf_aqed_fifo_aqed_ap_enq_rdata (rf_aqed_fifo_aqed_ap_enq_rdata)

,.rf_aqed_fifo_aqed_ap_enq_error (rf_aqed_fifo_aqed_ap_enq_error)

,.func_aqed_fifo_aqed_chp_sch_re    (func_aqed_fifo_aqed_chp_sch_re)
,.func_aqed_fifo_aqed_chp_sch_raddr (func_aqed_fifo_aqed_chp_sch_raddr)
,.func_aqed_fifo_aqed_chp_sch_waddr (func_aqed_fifo_aqed_chp_sch_waddr)
,.func_aqed_fifo_aqed_chp_sch_we    (func_aqed_fifo_aqed_chp_sch_we)
,.func_aqed_fifo_aqed_chp_sch_wdata (func_aqed_fifo_aqed_chp_sch_wdata)
,.func_aqed_fifo_aqed_chp_sch_rdata (func_aqed_fifo_aqed_chp_sch_rdata)

,.pf_aqed_fifo_aqed_chp_sch_re      (pf_aqed_fifo_aqed_chp_sch_re)
,.pf_aqed_fifo_aqed_chp_sch_raddr (pf_aqed_fifo_aqed_chp_sch_raddr)
,.pf_aqed_fifo_aqed_chp_sch_waddr (pf_aqed_fifo_aqed_chp_sch_waddr)
,.pf_aqed_fifo_aqed_chp_sch_we    (pf_aqed_fifo_aqed_chp_sch_we)
,.pf_aqed_fifo_aqed_chp_sch_wdata (pf_aqed_fifo_aqed_chp_sch_wdata)
,.pf_aqed_fifo_aqed_chp_sch_rdata (pf_aqed_fifo_aqed_chp_sch_rdata)

,.rf_aqed_fifo_aqed_chp_sch_rclk (rf_aqed_fifo_aqed_chp_sch_rclk)
,.rf_aqed_fifo_aqed_chp_sch_rclk_rst_n (rf_aqed_fifo_aqed_chp_sch_rclk_rst_n)
,.rf_aqed_fifo_aqed_chp_sch_re    (rf_aqed_fifo_aqed_chp_sch_re)
,.rf_aqed_fifo_aqed_chp_sch_raddr (rf_aqed_fifo_aqed_chp_sch_raddr)
,.rf_aqed_fifo_aqed_chp_sch_waddr (rf_aqed_fifo_aqed_chp_sch_waddr)
,.rf_aqed_fifo_aqed_chp_sch_wclk (rf_aqed_fifo_aqed_chp_sch_wclk)
,.rf_aqed_fifo_aqed_chp_sch_wclk_rst_n (rf_aqed_fifo_aqed_chp_sch_wclk_rst_n)
,.rf_aqed_fifo_aqed_chp_sch_we    (rf_aqed_fifo_aqed_chp_sch_we)
,.rf_aqed_fifo_aqed_chp_sch_wdata (rf_aqed_fifo_aqed_chp_sch_wdata)
,.rf_aqed_fifo_aqed_chp_sch_rdata (rf_aqed_fifo_aqed_chp_sch_rdata)

,.rf_aqed_fifo_aqed_chp_sch_error (rf_aqed_fifo_aqed_chp_sch_error)

,.func_aqed_fifo_freelist_return_re    (func_aqed_fifo_freelist_return_re)
,.func_aqed_fifo_freelist_return_raddr (func_aqed_fifo_freelist_return_raddr)
,.func_aqed_fifo_freelist_return_waddr (func_aqed_fifo_freelist_return_waddr)
,.func_aqed_fifo_freelist_return_we    (func_aqed_fifo_freelist_return_we)
,.func_aqed_fifo_freelist_return_wdata (func_aqed_fifo_freelist_return_wdata)
,.func_aqed_fifo_freelist_return_rdata (func_aqed_fifo_freelist_return_rdata)

,.pf_aqed_fifo_freelist_return_re      (pf_aqed_fifo_freelist_return_re)
,.pf_aqed_fifo_freelist_return_raddr (pf_aqed_fifo_freelist_return_raddr)
,.pf_aqed_fifo_freelist_return_waddr (pf_aqed_fifo_freelist_return_waddr)
,.pf_aqed_fifo_freelist_return_we    (pf_aqed_fifo_freelist_return_we)
,.pf_aqed_fifo_freelist_return_wdata (pf_aqed_fifo_freelist_return_wdata)
,.pf_aqed_fifo_freelist_return_rdata (pf_aqed_fifo_freelist_return_rdata)

,.rf_aqed_fifo_freelist_return_rclk (rf_aqed_fifo_freelist_return_rclk)
,.rf_aqed_fifo_freelist_return_rclk_rst_n (rf_aqed_fifo_freelist_return_rclk_rst_n)
,.rf_aqed_fifo_freelist_return_re    (rf_aqed_fifo_freelist_return_re)
,.rf_aqed_fifo_freelist_return_raddr (rf_aqed_fifo_freelist_return_raddr)
,.rf_aqed_fifo_freelist_return_waddr (rf_aqed_fifo_freelist_return_waddr)
,.rf_aqed_fifo_freelist_return_wclk (rf_aqed_fifo_freelist_return_wclk)
,.rf_aqed_fifo_freelist_return_wclk_rst_n (rf_aqed_fifo_freelist_return_wclk_rst_n)
,.rf_aqed_fifo_freelist_return_we    (rf_aqed_fifo_freelist_return_we)
,.rf_aqed_fifo_freelist_return_wdata (rf_aqed_fifo_freelist_return_wdata)
,.rf_aqed_fifo_freelist_return_rdata (rf_aqed_fifo_freelist_return_rdata)

,.rf_aqed_fifo_freelist_return_error (rf_aqed_fifo_freelist_return_error)

,.func_aqed_fifo_lsp_aqed_cmp_re    (func_aqed_fifo_lsp_aqed_cmp_re)
,.func_aqed_fifo_lsp_aqed_cmp_raddr (func_aqed_fifo_lsp_aqed_cmp_raddr)
,.func_aqed_fifo_lsp_aqed_cmp_waddr (func_aqed_fifo_lsp_aqed_cmp_waddr)
,.func_aqed_fifo_lsp_aqed_cmp_we    (func_aqed_fifo_lsp_aqed_cmp_we)
,.func_aqed_fifo_lsp_aqed_cmp_wdata (func_aqed_fifo_lsp_aqed_cmp_wdata)
,.func_aqed_fifo_lsp_aqed_cmp_rdata (func_aqed_fifo_lsp_aqed_cmp_rdata)

,.pf_aqed_fifo_lsp_aqed_cmp_re      (pf_aqed_fifo_lsp_aqed_cmp_re)
,.pf_aqed_fifo_lsp_aqed_cmp_raddr (pf_aqed_fifo_lsp_aqed_cmp_raddr)
,.pf_aqed_fifo_lsp_aqed_cmp_waddr (pf_aqed_fifo_lsp_aqed_cmp_waddr)
,.pf_aqed_fifo_lsp_aqed_cmp_we    (pf_aqed_fifo_lsp_aqed_cmp_we)
,.pf_aqed_fifo_lsp_aqed_cmp_wdata (pf_aqed_fifo_lsp_aqed_cmp_wdata)
,.pf_aqed_fifo_lsp_aqed_cmp_rdata (pf_aqed_fifo_lsp_aqed_cmp_rdata)

,.rf_aqed_fifo_lsp_aqed_cmp_rclk (rf_aqed_fifo_lsp_aqed_cmp_rclk)
,.rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n (rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n)
,.rf_aqed_fifo_lsp_aqed_cmp_re    (rf_aqed_fifo_lsp_aqed_cmp_re)
,.rf_aqed_fifo_lsp_aqed_cmp_raddr (rf_aqed_fifo_lsp_aqed_cmp_raddr)
,.rf_aqed_fifo_lsp_aqed_cmp_waddr (rf_aqed_fifo_lsp_aqed_cmp_waddr)
,.rf_aqed_fifo_lsp_aqed_cmp_wclk (rf_aqed_fifo_lsp_aqed_cmp_wclk)
,.rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n (rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n)
,.rf_aqed_fifo_lsp_aqed_cmp_we    (rf_aqed_fifo_lsp_aqed_cmp_we)
,.rf_aqed_fifo_lsp_aqed_cmp_wdata (rf_aqed_fifo_lsp_aqed_cmp_wdata)
,.rf_aqed_fifo_lsp_aqed_cmp_rdata (rf_aqed_fifo_lsp_aqed_cmp_rdata)

,.rf_aqed_fifo_lsp_aqed_cmp_error (rf_aqed_fifo_lsp_aqed_cmp_error)

,.func_aqed_fifo_qed_aqed_enq_re    (func_aqed_fifo_qed_aqed_enq_re)
,.func_aqed_fifo_qed_aqed_enq_raddr (func_aqed_fifo_qed_aqed_enq_raddr)
,.func_aqed_fifo_qed_aqed_enq_waddr (func_aqed_fifo_qed_aqed_enq_waddr)
,.func_aqed_fifo_qed_aqed_enq_we    (func_aqed_fifo_qed_aqed_enq_we)
,.func_aqed_fifo_qed_aqed_enq_wdata (func_aqed_fifo_qed_aqed_enq_wdata)
,.func_aqed_fifo_qed_aqed_enq_rdata (func_aqed_fifo_qed_aqed_enq_rdata)

,.pf_aqed_fifo_qed_aqed_enq_re      (pf_aqed_fifo_qed_aqed_enq_re)
,.pf_aqed_fifo_qed_aqed_enq_raddr (pf_aqed_fifo_qed_aqed_enq_raddr)
,.pf_aqed_fifo_qed_aqed_enq_waddr (pf_aqed_fifo_qed_aqed_enq_waddr)
,.pf_aqed_fifo_qed_aqed_enq_we    (pf_aqed_fifo_qed_aqed_enq_we)
,.pf_aqed_fifo_qed_aqed_enq_wdata (pf_aqed_fifo_qed_aqed_enq_wdata)
,.pf_aqed_fifo_qed_aqed_enq_rdata (pf_aqed_fifo_qed_aqed_enq_rdata)

,.rf_aqed_fifo_qed_aqed_enq_rclk (rf_aqed_fifo_qed_aqed_enq_rclk)
,.rf_aqed_fifo_qed_aqed_enq_rclk_rst_n (rf_aqed_fifo_qed_aqed_enq_rclk_rst_n)
,.rf_aqed_fifo_qed_aqed_enq_re    (rf_aqed_fifo_qed_aqed_enq_re)
,.rf_aqed_fifo_qed_aqed_enq_raddr (rf_aqed_fifo_qed_aqed_enq_raddr)
,.rf_aqed_fifo_qed_aqed_enq_waddr (rf_aqed_fifo_qed_aqed_enq_waddr)
,.rf_aqed_fifo_qed_aqed_enq_wclk (rf_aqed_fifo_qed_aqed_enq_wclk)
,.rf_aqed_fifo_qed_aqed_enq_wclk_rst_n (rf_aqed_fifo_qed_aqed_enq_wclk_rst_n)
,.rf_aqed_fifo_qed_aqed_enq_we    (rf_aqed_fifo_qed_aqed_enq_we)
,.rf_aqed_fifo_qed_aqed_enq_wdata (rf_aqed_fifo_qed_aqed_enq_wdata)
,.rf_aqed_fifo_qed_aqed_enq_rdata (rf_aqed_fifo_qed_aqed_enq_rdata)

,.rf_aqed_fifo_qed_aqed_enq_error (rf_aqed_fifo_qed_aqed_enq_error)

,.func_aqed_fifo_qed_aqed_enq_fid_re    (func_aqed_fifo_qed_aqed_enq_fid_re)
,.func_aqed_fifo_qed_aqed_enq_fid_raddr (func_aqed_fifo_qed_aqed_enq_fid_raddr)
,.func_aqed_fifo_qed_aqed_enq_fid_waddr (func_aqed_fifo_qed_aqed_enq_fid_waddr)
,.func_aqed_fifo_qed_aqed_enq_fid_we    (func_aqed_fifo_qed_aqed_enq_fid_we)
,.func_aqed_fifo_qed_aqed_enq_fid_wdata (func_aqed_fifo_qed_aqed_enq_fid_wdata)
,.func_aqed_fifo_qed_aqed_enq_fid_rdata (func_aqed_fifo_qed_aqed_enq_fid_rdata)

,.pf_aqed_fifo_qed_aqed_enq_fid_re      (pf_aqed_fifo_qed_aqed_enq_fid_re)
,.pf_aqed_fifo_qed_aqed_enq_fid_raddr (pf_aqed_fifo_qed_aqed_enq_fid_raddr)
,.pf_aqed_fifo_qed_aqed_enq_fid_waddr (pf_aqed_fifo_qed_aqed_enq_fid_waddr)
,.pf_aqed_fifo_qed_aqed_enq_fid_we    (pf_aqed_fifo_qed_aqed_enq_fid_we)
,.pf_aqed_fifo_qed_aqed_enq_fid_wdata (pf_aqed_fifo_qed_aqed_enq_fid_wdata)
,.pf_aqed_fifo_qed_aqed_enq_fid_rdata (pf_aqed_fifo_qed_aqed_enq_fid_rdata)

,.rf_aqed_fifo_qed_aqed_enq_fid_rclk (rf_aqed_fifo_qed_aqed_enq_fid_rclk)
,.rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n (rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n)
,.rf_aqed_fifo_qed_aqed_enq_fid_re    (rf_aqed_fifo_qed_aqed_enq_fid_re)
,.rf_aqed_fifo_qed_aqed_enq_fid_raddr (rf_aqed_fifo_qed_aqed_enq_fid_raddr)
,.rf_aqed_fifo_qed_aqed_enq_fid_waddr (rf_aqed_fifo_qed_aqed_enq_fid_waddr)
,.rf_aqed_fifo_qed_aqed_enq_fid_wclk (rf_aqed_fifo_qed_aqed_enq_fid_wclk)
,.rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n (rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n)
,.rf_aqed_fifo_qed_aqed_enq_fid_we    (rf_aqed_fifo_qed_aqed_enq_fid_we)
,.rf_aqed_fifo_qed_aqed_enq_fid_wdata (rf_aqed_fifo_qed_aqed_enq_fid_wdata)
,.rf_aqed_fifo_qed_aqed_enq_fid_rdata (rf_aqed_fifo_qed_aqed_enq_fid_rdata)

,.rf_aqed_fifo_qed_aqed_enq_fid_error (rf_aqed_fifo_qed_aqed_enq_fid_error)

,.func_aqed_ll_cnt_pri0_re    (func_aqed_ll_cnt_pri0_re)
,.func_aqed_ll_cnt_pri0_raddr (func_aqed_ll_cnt_pri0_raddr)
,.func_aqed_ll_cnt_pri0_waddr (func_aqed_ll_cnt_pri0_waddr)
,.func_aqed_ll_cnt_pri0_we    (func_aqed_ll_cnt_pri0_we)
,.func_aqed_ll_cnt_pri0_wdata (func_aqed_ll_cnt_pri0_wdata)
,.func_aqed_ll_cnt_pri0_rdata (func_aqed_ll_cnt_pri0_rdata)

,.pf_aqed_ll_cnt_pri0_re      (pf_aqed_ll_cnt_pri0_re)
,.pf_aqed_ll_cnt_pri0_raddr (pf_aqed_ll_cnt_pri0_raddr)
,.pf_aqed_ll_cnt_pri0_waddr (pf_aqed_ll_cnt_pri0_waddr)
,.pf_aqed_ll_cnt_pri0_we    (pf_aqed_ll_cnt_pri0_we)
,.pf_aqed_ll_cnt_pri0_wdata (pf_aqed_ll_cnt_pri0_wdata)
,.pf_aqed_ll_cnt_pri0_rdata (pf_aqed_ll_cnt_pri0_rdata)

,.rf_aqed_ll_cnt_pri0_rclk (rf_aqed_ll_cnt_pri0_rclk)
,.rf_aqed_ll_cnt_pri0_rclk_rst_n (rf_aqed_ll_cnt_pri0_rclk_rst_n)
,.rf_aqed_ll_cnt_pri0_re    (rf_aqed_ll_cnt_pri0_re)
,.rf_aqed_ll_cnt_pri0_raddr (rf_aqed_ll_cnt_pri0_raddr)
,.rf_aqed_ll_cnt_pri0_waddr (rf_aqed_ll_cnt_pri0_waddr)
,.rf_aqed_ll_cnt_pri0_wclk (rf_aqed_ll_cnt_pri0_wclk)
,.rf_aqed_ll_cnt_pri0_wclk_rst_n (rf_aqed_ll_cnt_pri0_wclk_rst_n)
,.rf_aqed_ll_cnt_pri0_we    (rf_aqed_ll_cnt_pri0_we)
,.rf_aqed_ll_cnt_pri0_wdata (rf_aqed_ll_cnt_pri0_wdata)
,.rf_aqed_ll_cnt_pri0_rdata (rf_aqed_ll_cnt_pri0_rdata)

,.rf_aqed_ll_cnt_pri0_error (rf_aqed_ll_cnt_pri0_error)

,.func_aqed_ll_cnt_pri1_re    (func_aqed_ll_cnt_pri1_re)
,.func_aqed_ll_cnt_pri1_raddr (func_aqed_ll_cnt_pri1_raddr)
,.func_aqed_ll_cnt_pri1_waddr (func_aqed_ll_cnt_pri1_waddr)
,.func_aqed_ll_cnt_pri1_we    (func_aqed_ll_cnt_pri1_we)
,.func_aqed_ll_cnt_pri1_wdata (func_aqed_ll_cnt_pri1_wdata)
,.func_aqed_ll_cnt_pri1_rdata (func_aqed_ll_cnt_pri1_rdata)

,.pf_aqed_ll_cnt_pri1_re      (pf_aqed_ll_cnt_pri1_re)
,.pf_aqed_ll_cnt_pri1_raddr (pf_aqed_ll_cnt_pri1_raddr)
,.pf_aqed_ll_cnt_pri1_waddr (pf_aqed_ll_cnt_pri1_waddr)
,.pf_aqed_ll_cnt_pri1_we    (pf_aqed_ll_cnt_pri1_we)
,.pf_aqed_ll_cnt_pri1_wdata (pf_aqed_ll_cnt_pri1_wdata)
,.pf_aqed_ll_cnt_pri1_rdata (pf_aqed_ll_cnt_pri1_rdata)

,.rf_aqed_ll_cnt_pri1_rclk (rf_aqed_ll_cnt_pri1_rclk)
,.rf_aqed_ll_cnt_pri1_rclk_rst_n (rf_aqed_ll_cnt_pri1_rclk_rst_n)
,.rf_aqed_ll_cnt_pri1_re    (rf_aqed_ll_cnt_pri1_re)
,.rf_aqed_ll_cnt_pri1_raddr (rf_aqed_ll_cnt_pri1_raddr)
,.rf_aqed_ll_cnt_pri1_waddr (rf_aqed_ll_cnt_pri1_waddr)
,.rf_aqed_ll_cnt_pri1_wclk (rf_aqed_ll_cnt_pri1_wclk)
,.rf_aqed_ll_cnt_pri1_wclk_rst_n (rf_aqed_ll_cnt_pri1_wclk_rst_n)
,.rf_aqed_ll_cnt_pri1_we    (rf_aqed_ll_cnt_pri1_we)
,.rf_aqed_ll_cnt_pri1_wdata (rf_aqed_ll_cnt_pri1_wdata)
,.rf_aqed_ll_cnt_pri1_rdata (rf_aqed_ll_cnt_pri1_rdata)

,.rf_aqed_ll_cnt_pri1_error (rf_aqed_ll_cnt_pri1_error)

,.func_aqed_ll_cnt_pri2_re    (func_aqed_ll_cnt_pri2_re)
,.func_aqed_ll_cnt_pri2_raddr (func_aqed_ll_cnt_pri2_raddr)
,.func_aqed_ll_cnt_pri2_waddr (func_aqed_ll_cnt_pri2_waddr)
,.func_aqed_ll_cnt_pri2_we    (func_aqed_ll_cnt_pri2_we)
,.func_aqed_ll_cnt_pri2_wdata (func_aqed_ll_cnt_pri2_wdata)
,.func_aqed_ll_cnt_pri2_rdata (func_aqed_ll_cnt_pri2_rdata)

,.pf_aqed_ll_cnt_pri2_re      (pf_aqed_ll_cnt_pri2_re)
,.pf_aqed_ll_cnt_pri2_raddr (pf_aqed_ll_cnt_pri2_raddr)
,.pf_aqed_ll_cnt_pri2_waddr (pf_aqed_ll_cnt_pri2_waddr)
,.pf_aqed_ll_cnt_pri2_we    (pf_aqed_ll_cnt_pri2_we)
,.pf_aqed_ll_cnt_pri2_wdata (pf_aqed_ll_cnt_pri2_wdata)
,.pf_aqed_ll_cnt_pri2_rdata (pf_aqed_ll_cnt_pri2_rdata)

,.rf_aqed_ll_cnt_pri2_rclk (rf_aqed_ll_cnt_pri2_rclk)
,.rf_aqed_ll_cnt_pri2_rclk_rst_n (rf_aqed_ll_cnt_pri2_rclk_rst_n)
,.rf_aqed_ll_cnt_pri2_re    (rf_aqed_ll_cnt_pri2_re)
,.rf_aqed_ll_cnt_pri2_raddr (rf_aqed_ll_cnt_pri2_raddr)
,.rf_aqed_ll_cnt_pri2_waddr (rf_aqed_ll_cnt_pri2_waddr)
,.rf_aqed_ll_cnt_pri2_wclk (rf_aqed_ll_cnt_pri2_wclk)
,.rf_aqed_ll_cnt_pri2_wclk_rst_n (rf_aqed_ll_cnt_pri2_wclk_rst_n)
,.rf_aqed_ll_cnt_pri2_we    (rf_aqed_ll_cnt_pri2_we)
,.rf_aqed_ll_cnt_pri2_wdata (rf_aqed_ll_cnt_pri2_wdata)
,.rf_aqed_ll_cnt_pri2_rdata (rf_aqed_ll_cnt_pri2_rdata)

,.rf_aqed_ll_cnt_pri2_error (rf_aqed_ll_cnt_pri2_error)

,.func_aqed_ll_cnt_pri3_re    (func_aqed_ll_cnt_pri3_re)
,.func_aqed_ll_cnt_pri3_raddr (func_aqed_ll_cnt_pri3_raddr)
,.func_aqed_ll_cnt_pri3_waddr (func_aqed_ll_cnt_pri3_waddr)
,.func_aqed_ll_cnt_pri3_we    (func_aqed_ll_cnt_pri3_we)
,.func_aqed_ll_cnt_pri3_wdata (func_aqed_ll_cnt_pri3_wdata)
,.func_aqed_ll_cnt_pri3_rdata (func_aqed_ll_cnt_pri3_rdata)

,.pf_aqed_ll_cnt_pri3_re      (pf_aqed_ll_cnt_pri3_re)
,.pf_aqed_ll_cnt_pri3_raddr (pf_aqed_ll_cnt_pri3_raddr)
,.pf_aqed_ll_cnt_pri3_waddr (pf_aqed_ll_cnt_pri3_waddr)
,.pf_aqed_ll_cnt_pri3_we    (pf_aqed_ll_cnt_pri3_we)
,.pf_aqed_ll_cnt_pri3_wdata (pf_aqed_ll_cnt_pri3_wdata)
,.pf_aqed_ll_cnt_pri3_rdata (pf_aqed_ll_cnt_pri3_rdata)

,.rf_aqed_ll_cnt_pri3_rclk (rf_aqed_ll_cnt_pri3_rclk)
,.rf_aqed_ll_cnt_pri3_rclk_rst_n (rf_aqed_ll_cnt_pri3_rclk_rst_n)
,.rf_aqed_ll_cnt_pri3_re    (rf_aqed_ll_cnt_pri3_re)
,.rf_aqed_ll_cnt_pri3_raddr (rf_aqed_ll_cnt_pri3_raddr)
,.rf_aqed_ll_cnt_pri3_waddr (rf_aqed_ll_cnt_pri3_waddr)
,.rf_aqed_ll_cnt_pri3_wclk (rf_aqed_ll_cnt_pri3_wclk)
,.rf_aqed_ll_cnt_pri3_wclk_rst_n (rf_aqed_ll_cnt_pri3_wclk_rst_n)
,.rf_aqed_ll_cnt_pri3_we    (rf_aqed_ll_cnt_pri3_we)
,.rf_aqed_ll_cnt_pri3_wdata (rf_aqed_ll_cnt_pri3_wdata)
,.rf_aqed_ll_cnt_pri3_rdata (rf_aqed_ll_cnt_pri3_rdata)

,.rf_aqed_ll_cnt_pri3_error (rf_aqed_ll_cnt_pri3_error)

,.func_aqed_ll_qe_hp_pri0_re    (func_aqed_ll_qe_hp_pri0_re)
,.func_aqed_ll_qe_hp_pri0_raddr (func_aqed_ll_qe_hp_pri0_raddr)
,.func_aqed_ll_qe_hp_pri0_waddr (func_aqed_ll_qe_hp_pri0_waddr)
,.func_aqed_ll_qe_hp_pri0_we    (func_aqed_ll_qe_hp_pri0_we)
,.func_aqed_ll_qe_hp_pri0_wdata (func_aqed_ll_qe_hp_pri0_wdata)
,.func_aqed_ll_qe_hp_pri0_rdata (func_aqed_ll_qe_hp_pri0_rdata)

,.pf_aqed_ll_qe_hp_pri0_re      (pf_aqed_ll_qe_hp_pri0_re)
,.pf_aqed_ll_qe_hp_pri0_raddr (pf_aqed_ll_qe_hp_pri0_raddr)
,.pf_aqed_ll_qe_hp_pri0_waddr (pf_aqed_ll_qe_hp_pri0_waddr)
,.pf_aqed_ll_qe_hp_pri0_we    (pf_aqed_ll_qe_hp_pri0_we)
,.pf_aqed_ll_qe_hp_pri0_wdata (pf_aqed_ll_qe_hp_pri0_wdata)
,.pf_aqed_ll_qe_hp_pri0_rdata (pf_aqed_ll_qe_hp_pri0_rdata)

,.rf_aqed_ll_qe_hp_pri0_rclk (rf_aqed_ll_qe_hp_pri0_rclk)
,.rf_aqed_ll_qe_hp_pri0_rclk_rst_n (rf_aqed_ll_qe_hp_pri0_rclk_rst_n)
,.rf_aqed_ll_qe_hp_pri0_re    (rf_aqed_ll_qe_hp_pri0_re)
,.rf_aqed_ll_qe_hp_pri0_raddr (rf_aqed_ll_qe_hp_pri0_raddr)
,.rf_aqed_ll_qe_hp_pri0_waddr (rf_aqed_ll_qe_hp_pri0_waddr)
,.rf_aqed_ll_qe_hp_pri0_wclk (rf_aqed_ll_qe_hp_pri0_wclk)
,.rf_aqed_ll_qe_hp_pri0_wclk_rst_n (rf_aqed_ll_qe_hp_pri0_wclk_rst_n)
,.rf_aqed_ll_qe_hp_pri0_we    (rf_aqed_ll_qe_hp_pri0_we)
,.rf_aqed_ll_qe_hp_pri0_wdata (rf_aqed_ll_qe_hp_pri0_wdata)
,.rf_aqed_ll_qe_hp_pri0_rdata (rf_aqed_ll_qe_hp_pri0_rdata)

,.rf_aqed_ll_qe_hp_pri0_error (rf_aqed_ll_qe_hp_pri0_error)

,.func_aqed_ll_qe_hp_pri1_re    (func_aqed_ll_qe_hp_pri1_re)
,.func_aqed_ll_qe_hp_pri1_raddr (func_aqed_ll_qe_hp_pri1_raddr)
,.func_aqed_ll_qe_hp_pri1_waddr (func_aqed_ll_qe_hp_pri1_waddr)
,.func_aqed_ll_qe_hp_pri1_we    (func_aqed_ll_qe_hp_pri1_we)
,.func_aqed_ll_qe_hp_pri1_wdata (func_aqed_ll_qe_hp_pri1_wdata)
,.func_aqed_ll_qe_hp_pri1_rdata (func_aqed_ll_qe_hp_pri1_rdata)

,.pf_aqed_ll_qe_hp_pri1_re      (pf_aqed_ll_qe_hp_pri1_re)
,.pf_aqed_ll_qe_hp_pri1_raddr (pf_aqed_ll_qe_hp_pri1_raddr)
,.pf_aqed_ll_qe_hp_pri1_waddr (pf_aqed_ll_qe_hp_pri1_waddr)
,.pf_aqed_ll_qe_hp_pri1_we    (pf_aqed_ll_qe_hp_pri1_we)
,.pf_aqed_ll_qe_hp_pri1_wdata (pf_aqed_ll_qe_hp_pri1_wdata)
,.pf_aqed_ll_qe_hp_pri1_rdata (pf_aqed_ll_qe_hp_pri1_rdata)

,.rf_aqed_ll_qe_hp_pri1_rclk (rf_aqed_ll_qe_hp_pri1_rclk)
,.rf_aqed_ll_qe_hp_pri1_rclk_rst_n (rf_aqed_ll_qe_hp_pri1_rclk_rst_n)
,.rf_aqed_ll_qe_hp_pri1_re    (rf_aqed_ll_qe_hp_pri1_re)
,.rf_aqed_ll_qe_hp_pri1_raddr (rf_aqed_ll_qe_hp_pri1_raddr)
,.rf_aqed_ll_qe_hp_pri1_waddr (rf_aqed_ll_qe_hp_pri1_waddr)
,.rf_aqed_ll_qe_hp_pri1_wclk (rf_aqed_ll_qe_hp_pri1_wclk)
,.rf_aqed_ll_qe_hp_pri1_wclk_rst_n (rf_aqed_ll_qe_hp_pri1_wclk_rst_n)
,.rf_aqed_ll_qe_hp_pri1_we    (rf_aqed_ll_qe_hp_pri1_we)
,.rf_aqed_ll_qe_hp_pri1_wdata (rf_aqed_ll_qe_hp_pri1_wdata)
,.rf_aqed_ll_qe_hp_pri1_rdata (rf_aqed_ll_qe_hp_pri1_rdata)

,.rf_aqed_ll_qe_hp_pri1_error (rf_aqed_ll_qe_hp_pri1_error)

,.func_aqed_ll_qe_hp_pri2_re    (func_aqed_ll_qe_hp_pri2_re)
,.func_aqed_ll_qe_hp_pri2_raddr (func_aqed_ll_qe_hp_pri2_raddr)
,.func_aqed_ll_qe_hp_pri2_waddr (func_aqed_ll_qe_hp_pri2_waddr)
,.func_aqed_ll_qe_hp_pri2_we    (func_aqed_ll_qe_hp_pri2_we)
,.func_aqed_ll_qe_hp_pri2_wdata (func_aqed_ll_qe_hp_pri2_wdata)
,.func_aqed_ll_qe_hp_pri2_rdata (func_aqed_ll_qe_hp_pri2_rdata)

,.pf_aqed_ll_qe_hp_pri2_re      (pf_aqed_ll_qe_hp_pri2_re)
,.pf_aqed_ll_qe_hp_pri2_raddr (pf_aqed_ll_qe_hp_pri2_raddr)
,.pf_aqed_ll_qe_hp_pri2_waddr (pf_aqed_ll_qe_hp_pri2_waddr)
,.pf_aqed_ll_qe_hp_pri2_we    (pf_aqed_ll_qe_hp_pri2_we)
,.pf_aqed_ll_qe_hp_pri2_wdata (pf_aqed_ll_qe_hp_pri2_wdata)
,.pf_aqed_ll_qe_hp_pri2_rdata (pf_aqed_ll_qe_hp_pri2_rdata)

,.rf_aqed_ll_qe_hp_pri2_rclk (rf_aqed_ll_qe_hp_pri2_rclk)
,.rf_aqed_ll_qe_hp_pri2_rclk_rst_n (rf_aqed_ll_qe_hp_pri2_rclk_rst_n)
,.rf_aqed_ll_qe_hp_pri2_re    (rf_aqed_ll_qe_hp_pri2_re)
,.rf_aqed_ll_qe_hp_pri2_raddr (rf_aqed_ll_qe_hp_pri2_raddr)
,.rf_aqed_ll_qe_hp_pri2_waddr (rf_aqed_ll_qe_hp_pri2_waddr)
,.rf_aqed_ll_qe_hp_pri2_wclk (rf_aqed_ll_qe_hp_pri2_wclk)
,.rf_aqed_ll_qe_hp_pri2_wclk_rst_n (rf_aqed_ll_qe_hp_pri2_wclk_rst_n)
,.rf_aqed_ll_qe_hp_pri2_we    (rf_aqed_ll_qe_hp_pri2_we)
,.rf_aqed_ll_qe_hp_pri2_wdata (rf_aqed_ll_qe_hp_pri2_wdata)
,.rf_aqed_ll_qe_hp_pri2_rdata (rf_aqed_ll_qe_hp_pri2_rdata)

,.rf_aqed_ll_qe_hp_pri2_error (rf_aqed_ll_qe_hp_pri2_error)

,.func_aqed_ll_qe_hp_pri3_re    (func_aqed_ll_qe_hp_pri3_re)
,.func_aqed_ll_qe_hp_pri3_raddr (func_aqed_ll_qe_hp_pri3_raddr)
,.func_aqed_ll_qe_hp_pri3_waddr (func_aqed_ll_qe_hp_pri3_waddr)
,.func_aqed_ll_qe_hp_pri3_we    (func_aqed_ll_qe_hp_pri3_we)
,.func_aqed_ll_qe_hp_pri3_wdata (func_aqed_ll_qe_hp_pri3_wdata)
,.func_aqed_ll_qe_hp_pri3_rdata (func_aqed_ll_qe_hp_pri3_rdata)

,.pf_aqed_ll_qe_hp_pri3_re      (pf_aqed_ll_qe_hp_pri3_re)
,.pf_aqed_ll_qe_hp_pri3_raddr (pf_aqed_ll_qe_hp_pri3_raddr)
,.pf_aqed_ll_qe_hp_pri3_waddr (pf_aqed_ll_qe_hp_pri3_waddr)
,.pf_aqed_ll_qe_hp_pri3_we    (pf_aqed_ll_qe_hp_pri3_we)
,.pf_aqed_ll_qe_hp_pri3_wdata (pf_aqed_ll_qe_hp_pri3_wdata)
,.pf_aqed_ll_qe_hp_pri3_rdata (pf_aqed_ll_qe_hp_pri3_rdata)

,.rf_aqed_ll_qe_hp_pri3_rclk (rf_aqed_ll_qe_hp_pri3_rclk)
,.rf_aqed_ll_qe_hp_pri3_rclk_rst_n (rf_aqed_ll_qe_hp_pri3_rclk_rst_n)
,.rf_aqed_ll_qe_hp_pri3_re    (rf_aqed_ll_qe_hp_pri3_re)
,.rf_aqed_ll_qe_hp_pri3_raddr (rf_aqed_ll_qe_hp_pri3_raddr)
,.rf_aqed_ll_qe_hp_pri3_waddr (rf_aqed_ll_qe_hp_pri3_waddr)
,.rf_aqed_ll_qe_hp_pri3_wclk (rf_aqed_ll_qe_hp_pri3_wclk)
,.rf_aqed_ll_qe_hp_pri3_wclk_rst_n (rf_aqed_ll_qe_hp_pri3_wclk_rst_n)
,.rf_aqed_ll_qe_hp_pri3_we    (rf_aqed_ll_qe_hp_pri3_we)
,.rf_aqed_ll_qe_hp_pri3_wdata (rf_aqed_ll_qe_hp_pri3_wdata)
,.rf_aqed_ll_qe_hp_pri3_rdata (rf_aqed_ll_qe_hp_pri3_rdata)

,.rf_aqed_ll_qe_hp_pri3_error (rf_aqed_ll_qe_hp_pri3_error)

,.func_aqed_ll_qe_tp_pri0_re    (func_aqed_ll_qe_tp_pri0_re)
,.func_aqed_ll_qe_tp_pri0_raddr (func_aqed_ll_qe_tp_pri0_raddr)
,.func_aqed_ll_qe_tp_pri0_waddr (func_aqed_ll_qe_tp_pri0_waddr)
,.func_aqed_ll_qe_tp_pri0_we    (func_aqed_ll_qe_tp_pri0_we)
,.func_aqed_ll_qe_tp_pri0_wdata (func_aqed_ll_qe_tp_pri0_wdata)
,.func_aqed_ll_qe_tp_pri0_rdata (func_aqed_ll_qe_tp_pri0_rdata)

,.pf_aqed_ll_qe_tp_pri0_re      (pf_aqed_ll_qe_tp_pri0_re)
,.pf_aqed_ll_qe_tp_pri0_raddr (pf_aqed_ll_qe_tp_pri0_raddr)
,.pf_aqed_ll_qe_tp_pri0_waddr (pf_aqed_ll_qe_tp_pri0_waddr)
,.pf_aqed_ll_qe_tp_pri0_we    (pf_aqed_ll_qe_tp_pri0_we)
,.pf_aqed_ll_qe_tp_pri0_wdata (pf_aqed_ll_qe_tp_pri0_wdata)
,.pf_aqed_ll_qe_tp_pri0_rdata (pf_aqed_ll_qe_tp_pri0_rdata)

,.rf_aqed_ll_qe_tp_pri0_rclk (rf_aqed_ll_qe_tp_pri0_rclk)
,.rf_aqed_ll_qe_tp_pri0_rclk_rst_n (rf_aqed_ll_qe_tp_pri0_rclk_rst_n)
,.rf_aqed_ll_qe_tp_pri0_re    (rf_aqed_ll_qe_tp_pri0_re)
,.rf_aqed_ll_qe_tp_pri0_raddr (rf_aqed_ll_qe_tp_pri0_raddr)
,.rf_aqed_ll_qe_tp_pri0_waddr (rf_aqed_ll_qe_tp_pri0_waddr)
,.rf_aqed_ll_qe_tp_pri0_wclk (rf_aqed_ll_qe_tp_pri0_wclk)
,.rf_aqed_ll_qe_tp_pri0_wclk_rst_n (rf_aqed_ll_qe_tp_pri0_wclk_rst_n)
,.rf_aqed_ll_qe_tp_pri0_we    (rf_aqed_ll_qe_tp_pri0_we)
,.rf_aqed_ll_qe_tp_pri0_wdata (rf_aqed_ll_qe_tp_pri0_wdata)
,.rf_aqed_ll_qe_tp_pri0_rdata (rf_aqed_ll_qe_tp_pri0_rdata)

,.rf_aqed_ll_qe_tp_pri0_error (rf_aqed_ll_qe_tp_pri0_error)

,.func_aqed_ll_qe_tp_pri1_re    (func_aqed_ll_qe_tp_pri1_re)
,.func_aqed_ll_qe_tp_pri1_raddr (func_aqed_ll_qe_tp_pri1_raddr)
,.func_aqed_ll_qe_tp_pri1_waddr (func_aqed_ll_qe_tp_pri1_waddr)
,.func_aqed_ll_qe_tp_pri1_we    (func_aqed_ll_qe_tp_pri1_we)
,.func_aqed_ll_qe_tp_pri1_wdata (func_aqed_ll_qe_tp_pri1_wdata)
,.func_aqed_ll_qe_tp_pri1_rdata (func_aqed_ll_qe_tp_pri1_rdata)

,.pf_aqed_ll_qe_tp_pri1_re      (pf_aqed_ll_qe_tp_pri1_re)
,.pf_aqed_ll_qe_tp_pri1_raddr (pf_aqed_ll_qe_tp_pri1_raddr)
,.pf_aqed_ll_qe_tp_pri1_waddr (pf_aqed_ll_qe_tp_pri1_waddr)
,.pf_aqed_ll_qe_tp_pri1_we    (pf_aqed_ll_qe_tp_pri1_we)
,.pf_aqed_ll_qe_tp_pri1_wdata (pf_aqed_ll_qe_tp_pri1_wdata)
,.pf_aqed_ll_qe_tp_pri1_rdata (pf_aqed_ll_qe_tp_pri1_rdata)

,.rf_aqed_ll_qe_tp_pri1_rclk (rf_aqed_ll_qe_tp_pri1_rclk)
,.rf_aqed_ll_qe_tp_pri1_rclk_rst_n (rf_aqed_ll_qe_tp_pri1_rclk_rst_n)
,.rf_aqed_ll_qe_tp_pri1_re    (rf_aqed_ll_qe_tp_pri1_re)
,.rf_aqed_ll_qe_tp_pri1_raddr (rf_aqed_ll_qe_tp_pri1_raddr)
,.rf_aqed_ll_qe_tp_pri1_waddr (rf_aqed_ll_qe_tp_pri1_waddr)
,.rf_aqed_ll_qe_tp_pri1_wclk (rf_aqed_ll_qe_tp_pri1_wclk)
,.rf_aqed_ll_qe_tp_pri1_wclk_rst_n (rf_aqed_ll_qe_tp_pri1_wclk_rst_n)
,.rf_aqed_ll_qe_tp_pri1_we    (rf_aqed_ll_qe_tp_pri1_we)
,.rf_aqed_ll_qe_tp_pri1_wdata (rf_aqed_ll_qe_tp_pri1_wdata)
,.rf_aqed_ll_qe_tp_pri1_rdata (rf_aqed_ll_qe_tp_pri1_rdata)

,.rf_aqed_ll_qe_tp_pri1_error (rf_aqed_ll_qe_tp_pri1_error)

,.func_aqed_ll_qe_tp_pri2_re    (func_aqed_ll_qe_tp_pri2_re)
,.func_aqed_ll_qe_tp_pri2_raddr (func_aqed_ll_qe_tp_pri2_raddr)
,.func_aqed_ll_qe_tp_pri2_waddr (func_aqed_ll_qe_tp_pri2_waddr)
,.func_aqed_ll_qe_tp_pri2_we    (func_aqed_ll_qe_tp_pri2_we)
,.func_aqed_ll_qe_tp_pri2_wdata (func_aqed_ll_qe_tp_pri2_wdata)
,.func_aqed_ll_qe_tp_pri2_rdata (func_aqed_ll_qe_tp_pri2_rdata)

,.pf_aqed_ll_qe_tp_pri2_re      (pf_aqed_ll_qe_tp_pri2_re)
,.pf_aqed_ll_qe_tp_pri2_raddr (pf_aqed_ll_qe_tp_pri2_raddr)
,.pf_aqed_ll_qe_tp_pri2_waddr (pf_aqed_ll_qe_tp_pri2_waddr)
,.pf_aqed_ll_qe_tp_pri2_we    (pf_aqed_ll_qe_tp_pri2_we)
,.pf_aqed_ll_qe_tp_pri2_wdata (pf_aqed_ll_qe_tp_pri2_wdata)
,.pf_aqed_ll_qe_tp_pri2_rdata (pf_aqed_ll_qe_tp_pri2_rdata)

,.rf_aqed_ll_qe_tp_pri2_rclk (rf_aqed_ll_qe_tp_pri2_rclk)
,.rf_aqed_ll_qe_tp_pri2_rclk_rst_n (rf_aqed_ll_qe_tp_pri2_rclk_rst_n)
,.rf_aqed_ll_qe_tp_pri2_re    (rf_aqed_ll_qe_tp_pri2_re)
,.rf_aqed_ll_qe_tp_pri2_raddr (rf_aqed_ll_qe_tp_pri2_raddr)
,.rf_aqed_ll_qe_tp_pri2_waddr (rf_aqed_ll_qe_tp_pri2_waddr)
,.rf_aqed_ll_qe_tp_pri2_wclk (rf_aqed_ll_qe_tp_pri2_wclk)
,.rf_aqed_ll_qe_tp_pri2_wclk_rst_n (rf_aqed_ll_qe_tp_pri2_wclk_rst_n)
,.rf_aqed_ll_qe_tp_pri2_we    (rf_aqed_ll_qe_tp_pri2_we)
,.rf_aqed_ll_qe_tp_pri2_wdata (rf_aqed_ll_qe_tp_pri2_wdata)
,.rf_aqed_ll_qe_tp_pri2_rdata (rf_aqed_ll_qe_tp_pri2_rdata)

,.rf_aqed_ll_qe_tp_pri2_error (rf_aqed_ll_qe_tp_pri2_error)

,.func_aqed_ll_qe_tp_pri3_re    (func_aqed_ll_qe_tp_pri3_re)
,.func_aqed_ll_qe_tp_pri3_raddr (func_aqed_ll_qe_tp_pri3_raddr)
,.func_aqed_ll_qe_tp_pri3_waddr (func_aqed_ll_qe_tp_pri3_waddr)
,.func_aqed_ll_qe_tp_pri3_we    (func_aqed_ll_qe_tp_pri3_we)
,.func_aqed_ll_qe_tp_pri3_wdata (func_aqed_ll_qe_tp_pri3_wdata)
,.func_aqed_ll_qe_tp_pri3_rdata (func_aqed_ll_qe_tp_pri3_rdata)

,.pf_aqed_ll_qe_tp_pri3_re      (pf_aqed_ll_qe_tp_pri3_re)
,.pf_aqed_ll_qe_tp_pri3_raddr (pf_aqed_ll_qe_tp_pri3_raddr)
,.pf_aqed_ll_qe_tp_pri3_waddr (pf_aqed_ll_qe_tp_pri3_waddr)
,.pf_aqed_ll_qe_tp_pri3_we    (pf_aqed_ll_qe_tp_pri3_we)
,.pf_aqed_ll_qe_tp_pri3_wdata (pf_aqed_ll_qe_tp_pri3_wdata)
,.pf_aqed_ll_qe_tp_pri3_rdata (pf_aqed_ll_qe_tp_pri3_rdata)

,.rf_aqed_ll_qe_tp_pri3_rclk (rf_aqed_ll_qe_tp_pri3_rclk)
,.rf_aqed_ll_qe_tp_pri3_rclk_rst_n (rf_aqed_ll_qe_tp_pri3_rclk_rst_n)
,.rf_aqed_ll_qe_tp_pri3_re    (rf_aqed_ll_qe_tp_pri3_re)
,.rf_aqed_ll_qe_tp_pri3_raddr (rf_aqed_ll_qe_tp_pri3_raddr)
,.rf_aqed_ll_qe_tp_pri3_waddr (rf_aqed_ll_qe_tp_pri3_waddr)
,.rf_aqed_ll_qe_tp_pri3_wclk (rf_aqed_ll_qe_tp_pri3_wclk)
,.rf_aqed_ll_qe_tp_pri3_wclk_rst_n (rf_aqed_ll_qe_tp_pri3_wclk_rst_n)
,.rf_aqed_ll_qe_tp_pri3_we    (rf_aqed_ll_qe_tp_pri3_we)
,.rf_aqed_ll_qe_tp_pri3_wdata (rf_aqed_ll_qe_tp_pri3_wdata)
,.rf_aqed_ll_qe_tp_pri3_rdata (rf_aqed_ll_qe_tp_pri3_rdata)

,.rf_aqed_ll_qe_tp_pri3_error (rf_aqed_ll_qe_tp_pri3_error)

,.func_aqed_qid_cnt_re    (func_aqed_qid_cnt_re)
,.func_aqed_qid_cnt_raddr (func_aqed_qid_cnt_raddr)
,.func_aqed_qid_cnt_waddr (func_aqed_qid_cnt_waddr)
,.func_aqed_qid_cnt_we    (func_aqed_qid_cnt_we)
,.func_aqed_qid_cnt_wdata (func_aqed_qid_cnt_wdata)
,.func_aqed_qid_cnt_rdata (func_aqed_qid_cnt_rdata)

,.pf_aqed_qid_cnt_re      (pf_aqed_qid_cnt_re)
,.pf_aqed_qid_cnt_raddr (pf_aqed_qid_cnt_raddr)
,.pf_aqed_qid_cnt_waddr (pf_aqed_qid_cnt_waddr)
,.pf_aqed_qid_cnt_we    (pf_aqed_qid_cnt_we)
,.pf_aqed_qid_cnt_wdata (pf_aqed_qid_cnt_wdata)
,.pf_aqed_qid_cnt_rdata (pf_aqed_qid_cnt_rdata)

,.rf_aqed_qid_cnt_rclk (rf_aqed_qid_cnt_rclk)
,.rf_aqed_qid_cnt_rclk_rst_n (rf_aqed_qid_cnt_rclk_rst_n)
,.rf_aqed_qid_cnt_re    (rf_aqed_qid_cnt_re)
,.rf_aqed_qid_cnt_raddr (rf_aqed_qid_cnt_raddr)
,.rf_aqed_qid_cnt_waddr (rf_aqed_qid_cnt_waddr)
,.rf_aqed_qid_cnt_wclk (rf_aqed_qid_cnt_wclk)
,.rf_aqed_qid_cnt_wclk_rst_n (rf_aqed_qid_cnt_wclk_rst_n)
,.rf_aqed_qid_cnt_we    (rf_aqed_qid_cnt_we)
,.rf_aqed_qid_cnt_wdata (rf_aqed_qid_cnt_wdata)
,.rf_aqed_qid_cnt_rdata (rf_aqed_qid_cnt_rdata)

,.rf_aqed_qid_cnt_error (rf_aqed_qid_cnt_error)

,.func_aqed_qid_fid_limit_re    (func_aqed_qid_fid_limit_re)
,.func_aqed_qid_fid_limit_addr  (func_aqed_qid_fid_limit_addr)
,.func_aqed_qid_fid_limit_we    (func_aqed_qid_fid_limit_we)
,.func_aqed_qid_fid_limit_wdata (func_aqed_qid_fid_limit_wdata)
,.func_aqed_qid_fid_limit_rdata (func_aqed_qid_fid_limit_rdata)

,.pf_aqed_qid_fid_limit_re      (pf_aqed_qid_fid_limit_re)
,.pf_aqed_qid_fid_limit_addr  (pf_aqed_qid_fid_limit_addr)
,.pf_aqed_qid_fid_limit_we    (pf_aqed_qid_fid_limit_we)
,.pf_aqed_qid_fid_limit_wdata (pf_aqed_qid_fid_limit_wdata)
,.pf_aqed_qid_fid_limit_rdata (pf_aqed_qid_fid_limit_rdata)

,.rf_aqed_qid_fid_limit_rclk (rf_aqed_qid_fid_limit_rclk)
,.rf_aqed_qid_fid_limit_rclk_rst_n (rf_aqed_qid_fid_limit_rclk_rst_n)
,.rf_aqed_qid_fid_limit_re    (rf_aqed_qid_fid_limit_re)
,.rf_aqed_qid_fid_limit_raddr (rf_aqed_qid_fid_limit_raddr)
,.rf_aqed_qid_fid_limit_waddr (rf_aqed_qid_fid_limit_waddr)
,.rf_aqed_qid_fid_limit_wclk (rf_aqed_qid_fid_limit_wclk)
,.rf_aqed_qid_fid_limit_wclk_rst_n (rf_aqed_qid_fid_limit_wclk_rst_n)
,.rf_aqed_qid_fid_limit_we    (rf_aqed_qid_fid_limit_we)
,.rf_aqed_qid_fid_limit_wdata (rf_aqed_qid_fid_limit_wdata)
,.rf_aqed_qid_fid_limit_rdata (rf_aqed_qid_fid_limit_rdata)

,.rf_aqed_qid_fid_limit_error (rf_aqed_qid_fid_limit_error)

,.func_rx_sync_qed_aqed_enq_re    (func_rx_sync_qed_aqed_enq_re)
,.func_rx_sync_qed_aqed_enq_raddr (func_rx_sync_qed_aqed_enq_raddr)
,.func_rx_sync_qed_aqed_enq_waddr (func_rx_sync_qed_aqed_enq_waddr)
,.func_rx_sync_qed_aqed_enq_we    (func_rx_sync_qed_aqed_enq_we)
,.func_rx_sync_qed_aqed_enq_wdata (func_rx_sync_qed_aqed_enq_wdata)
,.func_rx_sync_qed_aqed_enq_rdata (func_rx_sync_qed_aqed_enq_rdata)

,.pf_rx_sync_qed_aqed_enq_re      (pf_rx_sync_qed_aqed_enq_re)
,.pf_rx_sync_qed_aqed_enq_raddr (pf_rx_sync_qed_aqed_enq_raddr)
,.pf_rx_sync_qed_aqed_enq_waddr (pf_rx_sync_qed_aqed_enq_waddr)
,.pf_rx_sync_qed_aqed_enq_we    (pf_rx_sync_qed_aqed_enq_we)
,.pf_rx_sync_qed_aqed_enq_wdata (pf_rx_sync_qed_aqed_enq_wdata)
,.pf_rx_sync_qed_aqed_enq_rdata (pf_rx_sync_qed_aqed_enq_rdata)

,.rf_rx_sync_qed_aqed_enq_rclk (rf_rx_sync_qed_aqed_enq_rclk)
,.rf_rx_sync_qed_aqed_enq_rclk_rst_n (rf_rx_sync_qed_aqed_enq_rclk_rst_n)
,.rf_rx_sync_qed_aqed_enq_re    (rf_rx_sync_qed_aqed_enq_re)
,.rf_rx_sync_qed_aqed_enq_raddr (rf_rx_sync_qed_aqed_enq_raddr)
,.rf_rx_sync_qed_aqed_enq_waddr (rf_rx_sync_qed_aqed_enq_waddr)
,.rf_rx_sync_qed_aqed_enq_wclk (rf_rx_sync_qed_aqed_enq_wclk)
,.rf_rx_sync_qed_aqed_enq_wclk_rst_n (rf_rx_sync_qed_aqed_enq_wclk_rst_n)
,.rf_rx_sync_qed_aqed_enq_we    (rf_rx_sync_qed_aqed_enq_we)
,.rf_rx_sync_qed_aqed_enq_wdata (rf_rx_sync_qed_aqed_enq_wdata)
,.rf_rx_sync_qed_aqed_enq_rdata (rf_rx_sync_qed_aqed_enq_rdata)

,.rf_rx_sync_qed_aqed_enq_error (rf_rx_sync_qed_aqed_enq_error)

,.func_aqed_re    (func_aqed_re)
,.func_aqed_addr  (func_aqed_addr)
,.func_aqed_we    (func_aqed_we)
,.func_aqed_wdata (func_aqed_wdata)
,.func_aqed_rdata (func_aqed_rdata)

,.pf_aqed_re      (pf_aqed_re)
,.pf_aqed_addr    (pf_aqed_addr)
,.pf_aqed_we      (pf_aqed_we)
,.pf_aqed_wdata   (pf_aqed_wdata)
,.pf_aqed_rdata   (pf_aqed_rdata)

,.sr_aqed_clk (sr_aqed_clk)
,.sr_aqed_clk_rst_n (sr_aqed_clk_rst_n)
,.sr_aqed_re    (sr_aqed_re)
,.sr_aqed_addr  (sr_aqed_addr)
,.sr_aqed_we    (sr_aqed_we)
,.sr_aqed_wdata (sr_aqed_wdata)
,.sr_aqed_rdata (sr_aqed_rdata)

,.sr_aqed_error (sr_aqed_error)

,.func_aqed_freelist_re    (func_aqed_freelist_re)
,.func_aqed_freelist_addr  (func_aqed_freelist_addr)
,.func_aqed_freelist_we    (func_aqed_freelist_we)
,.func_aqed_freelist_wdata (func_aqed_freelist_wdata)
,.func_aqed_freelist_rdata (func_aqed_freelist_rdata)

,.pf_aqed_freelist_re      (pf_aqed_freelist_re)
,.pf_aqed_freelist_addr    (pf_aqed_freelist_addr)
,.pf_aqed_freelist_we      (pf_aqed_freelist_we)
,.pf_aqed_freelist_wdata   (pf_aqed_freelist_wdata)
,.pf_aqed_freelist_rdata   (pf_aqed_freelist_rdata)

,.sr_aqed_freelist_clk (sr_aqed_freelist_clk)
,.sr_aqed_freelist_clk_rst_n (sr_aqed_freelist_clk_rst_n)
,.sr_aqed_freelist_re    (sr_aqed_freelist_re)
,.sr_aqed_freelist_addr  (sr_aqed_freelist_addr)
,.sr_aqed_freelist_we    (sr_aqed_freelist_we)
,.sr_aqed_freelist_wdata (sr_aqed_freelist_wdata)
,.sr_aqed_freelist_rdata (sr_aqed_freelist_rdata)

,.sr_aqed_freelist_error (sr_aqed_freelist_error)

,.func_aqed_ll_qe_hpnxt_re    (func_aqed_ll_qe_hpnxt_re)
,.func_aqed_ll_qe_hpnxt_addr  (func_aqed_ll_qe_hpnxt_addr)
,.func_aqed_ll_qe_hpnxt_we    (func_aqed_ll_qe_hpnxt_we)
,.func_aqed_ll_qe_hpnxt_wdata (func_aqed_ll_qe_hpnxt_wdata)
,.func_aqed_ll_qe_hpnxt_rdata (func_aqed_ll_qe_hpnxt_rdata)

,.pf_aqed_ll_qe_hpnxt_re      (pf_aqed_ll_qe_hpnxt_re)
,.pf_aqed_ll_qe_hpnxt_addr    (pf_aqed_ll_qe_hpnxt_addr)
,.pf_aqed_ll_qe_hpnxt_we      (pf_aqed_ll_qe_hpnxt_we)
,.pf_aqed_ll_qe_hpnxt_wdata   (pf_aqed_ll_qe_hpnxt_wdata)
,.pf_aqed_ll_qe_hpnxt_rdata   (pf_aqed_ll_qe_hpnxt_rdata)

,.sr_aqed_ll_qe_hpnxt_clk (sr_aqed_ll_qe_hpnxt_clk)
,.sr_aqed_ll_qe_hpnxt_clk_rst_n (sr_aqed_ll_qe_hpnxt_clk_rst_n)
,.sr_aqed_ll_qe_hpnxt_re    (sr_aqed_ll_qe_hpnxt_re)
,.sr_aqed_ll_qe_hpnxt_addr  (sr_aqed_ll_qe_hpnxt_addr)
,.sr_aqed_ll_qe_hpnxt_we    (sr_aqed_ll_qe_hpnxt_we)
,.sr_aqed_ll_qe_hpnxt_wdata (sr_aqed_ll_qe_hpnxt_wdata)
,.sr_aqed_ll_qe_hpnxt_rdata (sr_aqed_ll_qe_hpnxt_rdata)

,.sr_aqed_ll_qe_hpnxt_error (sr_aqed_ll_qe_hpnxt_error)

);
// END HQM_RAM_ACCESS

//---------------------------------------------------------------------------------------------------------
// common core - Interface & clock control

//NOTE: no hqm_AW_module_clock_control. Use hqm_list_sel_pipe clock control since BCAM interface must be insync

hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_ap_aqed_data ) )
) i_db_ap_aqed_data (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_ap_aqed_status_pnc )
  , .in_valid                           ( ap_aqed_v )
  , .in_ready                           ( ap_aqed_ready )
  , .in_data                            ( ap_aqed_data )
  , .out_valid                          ( db_ap_aqed_valid )
  , .out_ready                          ( db_ap_aqed_ready )
  , .out_data                           ( db_ap_aqed_data )
) ;

hqm_AW_rx_sync_wagitate # (
    .SEED                               ( 32'h0f )
  , .WIDTH                              ( $bits ( rx_sync_qed_aqed_enq_data ) )
) i_rx_sync_qed_aqed_enq (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_qed_aqed_enq_status_pnc )
  , .enable                             ( aqed_clk_enable )
  , .idle                               ( rx_sync_qed_aqed_enq_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( qed_aqed_enq_v )
  , .in_ready                           ( qed_aqed_enq_ready )
  , .in_data                            ( qed_aqed_enq_data )
  , .out_valid                          ( rx_sync_qed_aqed_enq_valid )
  , .out_ready                          ( rx_sync_qed_aqed_enq_ready )
  , .out_data                           ( rx_sync_qed_aqed_enq_data )
  , .mem_we                             ( func_rx_sync_qed_aqed_enq_we )
  , .mem_waddr                          ( func_rx_sync_qed_aqed_enq_waddr )
  , .mem_wdata                          ( func_rx_sync_qed_aqed_enq_wdata )
  , .mem_re                             ( func_rx_sync_qed_aqed_enq_re )
  , .mem_raddr                          ( func_rx_sync_qed_aqed_enq_raddr )
  , .mem_rdata                          ( func_rx_sync_qed_aqed_enq_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [0] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_aqed_ap_enq_data ) )
) i_db_aqed_ap_enq (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_aqed_ap_enq_status_pnc )
  , .in_valid                           ( db_aqed_ap_enq_valid )
  , .in_ready                           ( db_aqed_ap_enq_ready )
  , .in_data                            ( db_aqed_ap_enq_data )
  , .out_valid                          ( aqed_ap_enq_v )
  , .out_ready                          ( aqed_ap_enq_ready )
  , .out_data                           ( aqed_ap_enq_data )
) ;

hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( db_aqed_chp_sch_data ) )
) i_db_aqed_chp_sch (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_n )
  , .status                             ( db_aqed_chp_sch_status_pnc )
  , .idle                               ( db_aqed_chp_sch_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( db_aqed_chp_sch_valid )
  , .in_ready                           ( db_aqed_chp_sch_ready )
  , .in_data                            ( db_aqed_chp_sch_data )
  , .out_valid                          ( aqed_chp_sch_v )
  , .out_ready                          ( aqed_chp_sch_ready )
  , .out_data                           ( aqed_chp_sch_data )
) ;

hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_aqed_lsp_sch_data ) )
) i_db_aqed_lsp_sch (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_aqed_lsp_sch_status_pnc )
  , .in_valid                           ( db_aqed_lsp_sch_valid )
  , .in_ready                           ( db_aqed_lsp_sch_ready )
  , .in_data                            ( db_aqed_lsp_sch_data )
  , .out_valid                          ( aqed_lsp_sch_v )
  , .out_ready                          ( aqed_lsp_sch_ready )
  , .out_data                           ( aqed_lsp_sch_data )
) ;

//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar

cfg_req_t unit_cfg_req ;
logic [ ( HQM_AQED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write ;
logic [ ( HQM_AQED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read ;
logic unit_cfg_rsp_ack ;
logic unit_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ] unit_cfg_rsp_rdata ;
aw_fifo_status_t cfg_rx_fifo_status ;
hqm_AW_cfg_ring_top # (
          .NODE_ID                     ( HQM_AQED_CFG_NODE_ID )
        , .UNIT_ID                     ( HQM_AQED_CFG_UNIT_ID )
        , .UNIT_TGT_MAP                ( HQM_AQED_CFG_UNIT_TGT_MAP )
        , .UNIT_NUM_TGTS               ( HQM_AQED_CFG_UNIT_NUM_TGTS )
) i_hqm_aw_cfg_ring_top (
          .hqm_inp_gated_clk           ( hqm_inp_gated_clk )
        , .hqm_inp_gated_rst_n         ( hqm_inp_gated_rst_n )
        , .hqm_gated_clk               ( hqm_gated_clk )
        , .hqm_gated_rst_n             ( hqm_gated_rst_n )
        , .rst_prep                    ( rst_prep )

        , .cfg_rx_enable               ( aqed_clk_enable )
        , .cfg_rx_idle                 ( cfg_rx_idle ) 
        , .cfg_rx_fifo_status          ( cfg_rx_fifo_status )
        , .cfg_idle                    ( cfg_idle )

        , .up_cfg_req_write            ( aqed_cfg_req_up_write )
        , .up_cfg_req_read             ( aqed_cfg_req_up_read )
        , .up_cfg_req                  ( aqed_cfg_req_up )
        , .up_cfg_rsp_ack              ( aqed_cfg_rsp_up_ack )
        , .up_cfg_rsp                  ( aqed_cfg_rsp_up )

        , .down_cfg_req_write          ( aqed_cfg_req_down_write )
        , .down_cfg_req_read           ( aqed_cfg_req_down_read )
        , .down_cfg_req                ( aqed_cfg_req_down )
        , .down_cfg_rsp_ack            ( aqed_cfg_rsp_down_ack )
        , .down_cfg_rsp                ( aqed_cfg_rsp_down )

        , .unit_cfg_req_write          ( unit_cfg_req_write )
        , .unit_cfg_req_read           ( unit_cfg_req_read )
        , .unit_cfg_req                ( unit_cfg_req )
        , .unit_cfg_rsp_ack            ( unit_cfg_rsp_ack )
        , .unit_cfg_rsp_rdata          ( unit_cfg_rsp_rdata )
        , .unit_cfg_rsp_err            ( unit_cfg_rsp_err )
) ;
//------------------------------------------------------------------------------------------------------------------
// Common BCAST/VF Reset logic
logic [4:0] timeout_nc;
cfg_unit_timeout_t  cfg_unit_timeout;
assign hqm_aqed_target_cfg_unit_timeout_reg_nxt = {hqm_aqed_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign cfg_unit_timeout = {hqm_aqed_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_aqed_target_cfg_unit_timeout_reg_f[4:0];

localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_aqed_target_cfg_unit_version_status = cfg_unit_version;

//------------------------------------------------------------------------------------------------------------------

logic cfg_req_idlepipe ;
logic cfg_req_ready ;
logic [ ( HQM_AQED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write ;
logic [ ( HQM_AQED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read ;

hqm_AW_cfg_sc # (
          .MODULE                      ( HQM_AQED_CFG_NODE_ID )
        , .NUM_CFG_TARGETS             ( HQM_AQED_CFG_UNIT_NUM_TGTS )
        , .NUM_CFG_ACCESSIBLE_RAM      ( NUM_CFG_ACCESSIBLE_RAM )
) i_hqm_AW_cfg_sc (
          .hqm_gated_clk               ( hqm_gated_clk )
        , .hqm_gated_rst_n             ( hqm_gated_rst_n )

        , .unit_cfg_req_write          ( unit_cfg_req_write )
        , .unit_cfg_req_read           ( unit_cfg_req_read )
        , .unit_cfg_req                ( unit_cfg_req )
        , .unit_cfg_rsp_ack            ( unit_cfg_rsp_ack )
        , .unit_cfg_rsp_rdata          ( unit_cfg_rsp_rdata )
        , .unit_cfg_rsp_err            ( unit_cfg_rsp_err )

        , .pfcsr_cfg_req_write          ( pfcsr_cfg_req_write )
        , .pfcsr_cfg_req_read           ( pfcsr_cfg_req_read )
        , .pfcsr_cfg_req                ( pfcsr_cfg_req )
        , .pfcsr_cfg_rsp_ack            ( pfcsr_cfg_rsp_ack )
        , .pfcsr_cfg_rsp_err            ( pfcsr_cfg_rsp_err )
        , .pfcsr_cfg_rsp_rdata          ( pfcsr_cfg_rsp_rdata )

        , .cfg_req_write               ( cfg_req_write )
        , .cfg_req_read                ( cfg_req_read )
        , .cfg_mem_re                  ( cfg_mem_re )
        , .cfg_mem_addr                ( cfg_mem_addr )
        , .cfg_mem_minbit              ( cfg_mem_minbit )
        , .cfg_mem_maxbit              ( cfg_mem_maxbit )
        , .cfg_mem_we                  ( cfg_mem_we )
        , .cfg_mem_wdata               ( cfg_mem_wdata )
        , .cfg_mem_rdata               ( cfg_mem_rdata )
        , .cfg_mem_ack                 ( cfg_mem_ack )
        , .cfg_req_idlepipe            ( cfg_req_idlepipe )
        , .cfg_req_ready               ( cfg_req_ready )

        , .cfg_timout_enable           ( cfg_unit_timeout.ENABLE )
        , .cfg_timout_threshold        ( cfg_unit_timeout.THRESHOLD )
) ;

// common core - (cfgsc) configuration sc logic ( do custom CFG access like inject correction code or split logical config request to physical implentation

always_comb begin

  //CFG correction code logic
  cfg_mem_cc_v = '0 ;
  cfg_mem_cc_value = '0 ;
  cfg_mem_cc_width = '0 ;
  cfg_mem_cc_position = '0 ;

  cfgsc_parity_gen_qid_fid_limit_d = '0 ;

  if ( cfg_req_write [ HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT * 1 +: 1 ]  ) begin
    cfgsc_parity_gen_qid_fid_limit_d = cfg_mem_wdata  [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH - 1 ) - 1 : 0 ] ;
    cfg_mem_cc_v = 1'b1 ;
    cfg_mem_cc_value = { 7'd0 , cfgsc_parity_gen_qid_fid_limit_p } ;
    cfg_mem_cc_width = 4'd1 ;
    cfg_mem_cc_position = HQM_AQED_QID_FID_LIMIT_DWIDTH - 1 ;
  end

end


hqm_AW_parity_gen # (
    .WIDTH                              ( 13 )
) i_parity_gen_qid_fid_limit (
     .d                                 ( cfgsc_parity_gen_qid_fid_limit_d )
   , .odd                               ( 1'b1 )
   , .p                                 ( cfgsc_parity_gen_qid_fid_limit_p )
) ;



//---------------------------------------------------------------------------------------------------------
// common core - Interrupt serializer. Capture all interrutps from unit and send on interrupt ring

hqm_AW_int_serializer # (
    .NUM_INF                            ( HQM_AQED_ALARM_NUM_INF )
  , .NUM_COR                            ( HQM_AQED_ALARM_NUM_COR )
  , .NUM_UNC                            ( HQM_AQED_ALARM_NUM_UNC )
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

  , .int_up_v                           ( aqed_alarm_up_v )
  , .int_up_ready                       ( aqed_alarm_up_ready )
  , .int_up_data                        ( aqed_alarm_up_data )

  , .int_down_v                         ( aqed_alarm_down_v )
  , .int_down_ready                     ( aqed_alarm_down_ready )
  , .int_down_data                      ( aqed_alarm_down_data )

  , .status                             ( int_status )

  , .int_idle                           ( int_idle )
) ;

logic err_hw_class_01_v_nxt , err_hw_class_01_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_01_nxt , err_hw_class_01_f ;
logic err_hw_class_02_v_nxt , err_hw_class_02_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_02_nxt , err_hw_class_02_f ;
logic err_hw_class_03_v_nxt , err_hw_class_03_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_03_nxt , err_hw_class_03_f ;

logic ecc_check_hcw_l_error_mb_f ;
logic ecc_check_hcw_h_error_mb_f ;
logic rw_ll_qe_hpnxt_error_mb_f ;
logic ecc_check_error_mb_f ;
logic ecc_check_hcw_l_error_sb_f ;
logic ecc_check_hcw_h_error_sb_f ;
logic rw_ll_qe_hpnxt_error_sb_f ;
logic ecc_check_error_sb_f ;

assign err_hw_class_01_nxt [ 0 ]  = error_ll_nopri ;
assign err_hw_class_01_nxt [ 1 ]  = error_ll_of ;
assign err_hw_class_01_nxt [ 2 ]  = mf_err_uflow ;
assign err_hw_class_01_nxt [ 3 ]  = mf_err_oflow ;
assign err_hw_class_01_nxt [ 4 ]  = out_enq_v & ( fid_bcam_total_qid > 14'd2048 ) ;
assign err_hw_class_01_nxt [ 5 ]  = error_ll_headroom [ 1 ] ;
assign err_hw_class_01_nxt [ 6 ]  = error_ll_headroom [ 0 ] ;
assign err_hw_class_01_nxt [ 7 ]  = ( | rmw_ll_cnt_status ) ;
assign err_hw_class_01_nxt [ 8 ]  = ( | rmw_ll_hp_status ) ;
assign err_hw_class_01_nxt [ 9 ]  = ( | rmw_ll_tp_status ) ;
assign err_hw_class_01_nxt [ 10 ] = rw_ll_qe_hpnxt_status ;
assign err_hw_class_01_nxt [ 11 ] = rw_aqed_status ;
assign err_hw_class_01_nxt [ 12 ] = residue_check_ll_cnt_err ;
assign err_hw_class_01_nxt [ 13 ] = mf_err_residue ;
assign err_hw_class_01_nxt [ 14 ] = mf_err_residue_cfg ;
assign err_hw_class_01_nxt [ 15 ] = parity_check_ll_rmw_hp_p2_error ;
assign err_hw_class_01_nxt [ 16 ] = parity_check_ll_rmw_tp_p2_error ;
assign err_hw_class_01_nxt [ 17 ] = parity_check_ll_rw_ll_qe_hpnxt_p2_data_error ;
assign err_hw_class_01_nxt [ 18 ] = parity_check_db_ap_aqed_error ;
assign err_hw_class_01_nxt [ 19 ] = parity_check_db_ap_aqed_fid_error ;
assign err_hw_class_01_nxt [ 20 ] = parity_check_fid_error ;
assign err_hw_class_01_nxt [ 21 ] = parity_check_hid_error ;
assign err_hw_class_01_nxt [ 22 ] = rw_ll_qe_hpnxt_err_parity ;
assign err_hw_class_01_nxt [ 23 ] = parity_check_error ;
assign err_hw_class_01_nxt [ 24 ] = 1'b0 ;
assign err_hw_class_01_nxt [ 25 ] = 1'b0 ;
assign err_hw_class_01_nxt [ 26 ] = 1'b0 ;
assign err_hw_class_01_nxt [ 27 ] = ( AW_bcam_2048x26_error
                             | rf_aqed_fid_cnt_error
                             | rf_aqed_fifo_ap_aqed_error
                             | rf_aqed_fifo_aqed_ap_enq_error
                             | rf_aqed_fifo_aqed_chp_sch_error
                             | rf_aqed_fifo_freelist_return_error
                             | rf_aqed_fifo_lsp_aqed_cmp_error
                             | rf_aqed_fifo_qed_aqed_enq_error
                             | rf_aqed_fifo_qed_aqed_enq_fid_error
                             | rf_aqed_ll_cnt_pri0_error
                             | rf_aqed_ll_cnt_pri1_error
                             | rf_aqed_ll_cnt_pri2_error
                             | rf_aqed_ll_cnt_pri3_error




                             | rf_aqed_ll_qe_hp_pri0_error
                             | rf_aqed_ll_qe_hp_pri1_error
                             | rf_aqed_ll_qe_hp_pri2_error
                             | rf_aqed_ll_qe_hp_pri3_error




                             | rf_aqed_ll_qe_tp_pri0_error
                             | rf_aqed_ll_qe_tp_pri1_error
                             | rf_aqed_ll_qe_tp_pri2_error
                             | rf_aqed_ll_qe_tp_pri3_error




                             | rf_aqed_qid_cnt_error
                             | rf_aqed_qid_fid_limit_error
                             | rf_rx_sync_qed_aqed_enq_error
                             | sr_aqed_error
                             | sr_aqed_freelist_error
                             | sr_aqed_ll_qe_hpnxt_error
                                 ) ;
assign err_hw_class_01_nxt [ 30 : 28 ] = 3'd1 ;
assign err_hw_class_01_v_nxt = ( | err_hw_class_01_nxt [ 27 : 0 ] ) ;

assign err_hw_class_02_nxt [ 0 ]  = fid_bcam_error [ 0 ] ;
assign err_hw_class_02_nxt [ 1 ]  = fid_bcam_error [ 1 ] ;
assign err_hw_class_02_nxt [ 2 ]  = fid_bcam_error [ 2 ] ;
assign err_hw_class_02_nxt [ 3 ]  = fid_bcam_error [ 3 ] ;
assign err_hw_class_02_nxt [ 4 ]  = fid_bcam_error [ 4 ] ;
assign err_hw_class_02_nxt [ 5 ]  = fid_bcam_error [ 5 ] ;
assign err_hw_class_02_nxt [ 6 ]  = fid_bcam_error [ 6 ] ;
assign err_hw_class_02_nxt [ 7 ]  = fid_bcam_error [ 7 ] ;
assign err_hw_class_02_nxt [ 8 ]  = fid_bcam_error [ 8 ] ;
assign err_hw_class_02_nxt [ 9 ]  = fid_bcam_error [ 9 ] ;
assign err_hw_class_02_nxt [ 10 ] = fid_bcam_error [ 10 ] ;
assign err_hw_class_02_nxt [ 11 ] = fid_bcam_error [ 11 ] ;
assign err_hw_class_02_nxt [ 12 ] = fid_bcam_error [ 12 ] ;
assign err_hw_class_02_nxt [ 13 ] = fid_bcam_error [ 13 ] ;
assign err_hw_class_02_nxt [ 14 ] = fid_bcam_error [ 14 ] ;
assign err_hw_class_02_nxt [ 15 ] = fid_bcam_error [ 15 ] ;
assign err_hw_class_02_nxt [ 16 ] = fid_bcam_error [ 16 ] ;
assign err_hw_class_02_nxt [ 17 ] = fid_bcam_error [ 17 ] ;
assign err_hw_class_02_nxt [ 18 ] = fid_bcam_error [ 18 ] ;
assign err_hw_class_02_nxt [ 19 ] = fid_bcam_error [ 19 ] ;
assign err_hw_class_02_nxt [ 20 ] = fid_bcam_error [ 20 ] ;
assign err_hw_class_02_nxt [ 21 ] = fid_bcam_error [ 21 ] ;
assign err_hw_class_02_nxt [ 22 ] = fid_bcam_error [ 22 ] ;
assign err_hw_class_02_nxt [ 23 ] = fid_bcam_error [ 23 ] ;
assign err_hw_class_02_nxt [ 24 ] = debug_fidcnt_uf ;
assign err_hw_class_02_nxt [ 25 ] = debug_fidcnt_of ;
assign err_hw_class_02_nxt [ 26 ] = debug_qidcnt_uf ;
assign err_hw_class_02_nxt [ 27 ] = debug_qidcnt_of ;
assign err_hw_class_02_nxt [ 30 : 28 ] = 3'd2 ;
assign err_hw_class_02_v_nxt = ( | err_hw_class_02_nxt [ 27 : 0 ] ) ;

assign err_hw_class_03_nxt [ 0 ]  = cfg_rx_fifo_status.overflow ;
assign err_hw_class_03_nxt [ 1 ]  = cfg_rx_fifo_status.underflow ;
assign err_hw_class_03_nxt [ 2 ]  = rx_sync_qed_aqed_enq_status_pnc.overflow ;
assign err_hw_class_03_nxt [ 3 ]  = rx_sync_qed_aqed_enq_status_pnc.underflow ;
assign err_hw_class_03_nxt [ 4 ]  = fifo_ap_aqed_error_of ;
assign err_hw_class_03_nxt [ 5 ]  = fifo_ap_aqed_error_uf ;
assign err_hw_class_03_nxt [ 6 ]  = fifo_freelist_return_error_of ;
assign err_hw_class_03_nxt [ 7 ]  = fifo_freelist_return_error_uf ;
assign err_hw_class_03_nxt [ 8 ]  = fifo_qed_aqed_enq_error_of ;
assign err_hw_class_03_nxt [ 9 ]  = fifo_qed_aqed_enq_error_uf ;
assign err_hw_class_03_nxt [ 10 ] = fifo_aqed_ap_enq_error_of ;
assign err_hw_class_03_nxt [ 11 ] = fifo_aqed_ap_enq_error_uf ;
assign err_hw_class_03_nxt [ 12 ] = fifo_aqed_chp_sch_error_of ;
assign err_hw_class_03_nxt [ 13 ] = fifo_aqed_chp_sch_error_uf ;
assign err_hw_class_03_nxt [ 14 ] = fifo_qed_aqed_enq_fid_error_of ;
assign err_hw_class_03_nxt [ 15 ] = fifo_qed_aqed_enq_fid_error_uf ;
assign err_hw_class_03_nxt [ 16 ] = fifo_lsp_aqed_cmp_error_of ;
assign err_hw_class_03_nxt [ 17 ] = fifo_lsp_aqed_cmp_error_uf ;
assign err_hw_class_03_nxt [ 18 ] = parity_check_fifo_lsp_aqed_cmp_error ;
assign err_hw_class_03_nxt [ 19 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 20 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 21 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 22 ] = hqm_aqed_pipe_rfw_top_ipar_error ;
assign err_hw_class_03_nxt [ 23 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 24 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 25 ] =  1'b0 ;
assign err_hw_class_03_nxt [ 26 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 27 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 30 : 28 ] = 3'd3 ;
assign err_hw_class_03_v_nxt = ( | err_hw_class_03_nxt [ 27 : 0 ] ) ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    err_hw_class_01_f <= '0 ;
    err_hw_class_01_v_f <= '0 ;
    err_hw_class_02_f <= '0 ;
    err_hw_class_02_v_f <= '0 ;
    err_hw_class_03_f <= '0 ;
    err_hw_class_03_v_f <= '0 ;

    ecc_check_hcw_l_error_mb_f <= '0 ;
    ecc_check_hcw_h_error_mb_f <= '0 ;
    rw_ll_qe_hpnxt_error_mb_f <= '0 ;
    ecc_check_error_mb_f <= '0 ;
    ecc_check_hcw_l_error_sb_f <= '0 ;
    ecc_check_hcw_h_error_sb_f <= '0 ;
    rw_ll_qe_hpnxt_error_sb_f <= '0 ;
    ecc_check_error_sb_f <= '0 ;
  end
  else begin
    err_hw_class_01_f <= err_hw_class_01_nxt ;
    err_hw_class_01_v_f <= err_hw_class_01_v_nxt ;
    err_hw_class_02_f <= err_hw_class_02_nxt ;
    err_hw_class_02_v_f <= err_hw_class_02_v_nxt ;
    err_hw_class_03_f <= err_hw_class_03_nxt ;
    err_hw_class_03_v_f <= err_hw_class_03_v_nxt ;

    ecc_check_hcw_l_error_mb_f <= ecc_check_hcw_l_error_mb ;
    ecc_check_hcw_h_error_mb_f <= ecc_check_hcw_h_error_mb ;
    rw_ll_qe_hpnxt_error_mb_f <= rw_ll_qe_hpnxt_error_mb ;
    ecc_check_error_mb_f <= ecc_check_error_mb ;
    ecc_check_hcw_l_error_sb_f <= ecc_check_hcw_l_error_sb ;
    ecc_check_hcw_h_error_sb_f <= ecc_check_hcw_h_error_sb ;
    rw_ll_qe_hpnxt_error_sb_f <= rw_ll_qe_hpnxt_error_sb ;
    ecc_check_error_sb_f <= ecc_check_error_sb ;
  end
end


always_comb begin
  int_uid                                          = HQM_AQED_CFG_UNIT_ID ;
  int_unc_v                                        = '0 ;
  int_unc_data                                     = '0 ;
  int_cor_v                                        = '0 ;
  int_cor_data                                     = '0 ;
  int_inf_v                                        = '0 ;
  int_inf_data                                     = '0 ;
  hqm_aqed_target_cfg_syndrome_00_capture_v        = '0 ;
  hqm_aqed_target_cfg_syndrome_00_capture_data     = '0 ;
  hqm_aqed_target_cfg_syndrome_01_capture_v        = '0 ;
  hqm_aqed_target_cfg_syndrome_01_capture_data     = '0 ;

  //  ecc_check_hcw_l_error_mb_f "SB ECC Error" correctable ECC error on AQED ATQ->ATM HCW
  if ( ecc_check_hcw_l_error_mb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[1] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000001 ;
  end
  //  ecc_check_hcw_l_error_sb_f "MB ECC Error" uncorrectable ECC error on AQED ATQ->ATM HCW
  if ( ecc_check_hcw_l_error_sb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[3] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000002 ;
  end
  //  ecc_check_hcw_h_error_mb_f "SB ECC Error" correctable ECC error on AQED ATQ->ATM HCW
  if ( ecc_check_hcw_h_error_mb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[1] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000004 ;
  end
  //  ecc_check_hcw_h_error_sb_f "MB ECC Error" uncorrectable ECC error on AQED ATQ->ATM HCW
  if ( ecc_check_hcw_h_error_sb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[3] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000008 ;
  end
  //  rw_ll_qe_hpnxt_error_mb_f "SB ECC Error" correctable ECC error on AQED nxthp storage
  if ( rw_ll_qe_hpnxt_error_mb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[1] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000010 ;
  end
  //  rw_ll_qe_hpnxt_error_sb_f "MB ECC Error" uncorrectable ECC error on AQED nxthp storage
  if ( rw_ll_qe_hpnxt_error_sb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[3] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000020 ;
  end
  //  ecc_check_error_mb_f "SB ECC Error" correctable ECC error on AQED CREDIT storage
  if ( ecc_check_error_mb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[1] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000040 ;
  end
  //  ecc_check_error_sb_f "MB ECC Error" uncorrectable ECC error on AQED CREDIT storage
  if ( ecc_check_error_sb_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_01_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[3] ;
    hqm_aqed_target_cfg_syndrome_01_capture_data   = 31'h00000080 ;
  end
  //  err_hw_class_01_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_01_v_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_00_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[5] ;
    hqm_aqed_target_cfg_syndrome_00_capture_data   = err_hw_class_01_f ;
  end
  //  err_hw_class_02_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_02_v_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_00_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[5] ;
    hqm_aqed_target_cfg_syndrome_00_capture_data   = err_hw_class_02_f ;
  end
  //  err_hw_class_03_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_03_v_f & ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_aqed_target_cfg_syndrome_00_capture_v      = ~hqm_aqed_target_cfg_aqed_csr_control_reg_f[5] ;
    hqm_aqed_target_cfg_syndrome_00_capture_data   = err_hw_class_03_f ;
  end

end


//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: END common core interfaces 
//*****************************************************************************************************
//*****************************************************************************************************





























////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------------------------------------------------------------------------
// flops


always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L0299
  if ( ! hqm_gated_rst_n ) begin
    fifo_qed_aqed_enq_push_credits_f <= '0 ;
    fifo_qed_aqed_enq_push_f <= '0 ;
    fifo_qed_aqed_enq_push_data_f <= '0 ;
  end
  else begin
    fifo_qed_aqed_enq_push_credits_f <= fifo_qed_aqed_enq_push_credits_nxt ;
    fifo_qed_aqed_enq_push_f <= fifo_qed_aqed_enq_push_nxt ;
    fifo_qed_aqed_enq_push_data_f <= fifo_qed_aqed_enq_push_data_nxt ;
  end
end



hqm_aqed_pipe_complockid # (
  .HQM_AQED_NUM_QID ( 32 )
) i_hqm_aqed_pipe_complockid (
 .cfg ( hqm_aqed_target_cfg_aqed_qid_hid_width_reg_f )
, .in_lockid ( complockid_in_lockid )
, .in_qid ( complockid_in_qid )
, .out_lockid ( complockid_out_lockid )
) ;


hqm_aqed_pipe_complockid # (
  .HQM_AQED_NUM_QID ( 32 )
) i_hqm_aqed_pipe_complockid_completion (
 .cfg ( hqm_aqed_target_cfg_aqed_qid_hid_width_reg_f )
, .in_lockid ( complockid_in_lockid_completion )
, .in_qid ( complockid_in_qid_completion )
, .out_lockid ( complockid_out_lockid_completion )
) ;





always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L02
  if ( ! hqm_gated_rst_n ) begin


    p0_ll_v_f <= '0 ;
    p1_ll_v_f <= '0 ;
    p2_ll_v_f <= '0 ;
    p3_ll_v_f <= '0 ;
    p4_ll_v_f <= '0 ;
    p5_ll_v_f <= '0 ;
    p6_ll_v_f <= '0 ;
    p7_ll_v_f <= '0 ;
    p8_ll_v_f <= '0 ;
    p9_ll_v_f <= '0 ;
    p10_ll_v_f <= '0 ;
    p11_ll_v_f <= '0 ;
    p12_ll_v_f <= '0 ;
    p13_ll_v_f <= '0 ;

    smon_v_f <= '0 ;
    smon_comp_f <= '0 ;
    smon_val_f <= '0 ;

    aqed_lsp_stop_atqatm_f <= '0 ;
  end
  else begin


    p0_ll_v_f <= p0_ll_v_nxt ;
    p1_ll_v_f <= p1_ll_v_nxt ;
    p2_ll_v_f <= p2_ll_v_nxt ;
    p3_ll_v_f <= p3_ll_v_nxt ;
    p4_ll_v_f <= p4_ll_v_nxt ;
    p5_ll_v_f <= p5_ll_v_nxt ;
    p6_ll_v_f <= p6_ll_v_nxt ;
    p7_ll_v_f <= p7_ll_v_nxt ;
    p8_ll_v_f <= p8_ll_v_nxt ;
    p9_ll_v_f <= p9_ll_v_nxt ;
    p10_ll_v_f <= p10_ll_v_nxt ;
    p11_ll_v_f <= p11_ll_v_nxt ;
    p12_ll_v_f <= p12_ll_v_nxt ;
    p13_ll_v_f <= p13_ll_v_nxt ;

    smon_v_f <= smon_v_nxt ;
    smon_comp_f <= smon_comp_nxt ;
    smon_val_f <= smon_val_nxt ;

    aqed_lsp_stop_atqatm_f <= aqed_lsp_stop_atqatm_nxt ;
  end
end
always_ff @ ( posedge hqm_gated_clk ) begin : L03


    p0_ll_data_f <= p0_ll_data_nxt ;
    p1_ll_data_f <= p1_ll_data_nxt ;
    p2_ll_data_f <= p2_ll_data_nxt ;
    p3_ll_data_f <= p3_ll_data_nxt ;
    p4_ll_data_f <= p4_ll_data_nxt ;
    p5_ll_data_f <= p5_ll_data_nxt ;
    p6_ll_data_f <= p6_ll_data_nxt ;
    p7_ll_data_f <= p7_ll_data_nxt ;
    p8_ll_data_f <= p8_ll_data_nxt ;
    p9_ll_data_f <= p9_ll_data_nxt ;
    p10_ll_data_f <= p10_ll_data_nxt ;
    p11_ll_data_f <= p11_ll_data_nxt ;
    p12_ll_data_f <= p12_ll_data_nxt ;
    p13_ll_data_f <= p13_ll_data_nxt ;
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    reset_pf_counter_0_f <= '0 ;
    reset_pf_counter_1_f <= '0 ;
    reset_pf_active_0_f <= 1'b1 ;
    reset_pf_active_1_f <= 1'b1 ;
    reset_pf_done_0_f <= '0 ;
    reset_pf_done_1_f <= '0 ;
    hw_init_done_0_f <= '0 ;
    hw_init_done_1_f <= '0 ;
  end
  else begin
    reset_pf_counter_0_f <= reset_pf_counter_0_nxt ;
    reset_pf_counter_1_f <= reset_pf_counter_1_nxt ;
    reset_pf_active_0_f <= reset_pf_active_0_nxt ;
    reset_pf_active_1_f <= reset_pf_active_1_nxt ;
    reset_pf_done_0_f <= reset_pf_done_0_nxt ;
    reset_pf_done_1_f <= reset_pf_done_1_nxt ;
    hw_init_done_0_f <= hw_init_done_0_nxt ;
    hw_init_done_1_f <= hw_init_done_1_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L04
  if ( ! hqm_gated_rst_n ) begin
    fifo_qed_aqed_enq_fid_credits_f <= '0 ;
  end
  else begin
    fifo_qed_aqed_enq_fid_credits_f <= fifo_qed_aqed_enq_fid_credits_nxt ;
  end
end
always_comb begin : L05
  fifo_qed_aqed_enq_fid_credits_nxt = fifo_qed_aqed_enq_fid_credits_f + { 3'd0 , fifo_qed_aqed_enq_fid_inc } - { 3'd0 , fifo_qed_aqed_enq_fid_dec } ;
end
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L08
  if ( ! hqm_gated_rst_n ) begin
    residue_check_ll_cnt_r_f <= '0 ;
    residue_check_ll_cnt_d_f <= '0 ;
    residue_check_ll_cnt_e_f <= '0 ;
  end
  else begin
    residue_check_ll_cnt_r_f <= residue_check_ll_cnt_r_nxt ;
    residue_check_ll_cnt_d_f <= residue_check_ll_cnt_d_nxt ;
    residue_check_ll_cnt_e_f <= residue_check_ll_cnt_e_nxt ;
  end
end




always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L09
  if ( ! hqm_gated_rst_n ) begin
    fifo_aqed_ap_enq_cnt_f <= '0 ;
    fifo_aqed_chp_sch_cnt_f <= '0 ;
    fifo_freelist_return_cnt_f <= '0 ;
  end
  else begin
    fifo_aqed_ap_enq_cnt_f <= fifo_aqed_ap_enq_cnt_nxt ;
    fifo_aqed_chp_sch_cnt_f <= fifo_aqed_chp_sch_cnt_nxt ;
    fifo_freelist_return_cnt_f <= fifo_freelist_return_cnt_nxt ;
  end
end
always_comb begin : L10
  fifo_aqed_ap_enq_cnt_nxt = fifo_aqed_ap_enq_cnt_f + { 4'd0 , fifo_aqed_ap_enq_inc } - { 4'd0 , fifo_aqed_ap_enq_dec } ;
  fifo_aqed_chp_sch_cnt_nxt = fifo_aqed_chp_sch_cnt_f + { 4'd0 , fifo_aqed_chp_sch_inc } - { 4'd0 , fifo_aqed_chp_sch_dec } ;
  fifo_freelist_return_cnt_nxt = fifo_freelist_return_cnt_f + { 4'd0 , fifo_freelist_return_inc } - { 4'd0 , fifo_freelist_return_dec } ;
end

// duplicate for fanout violation
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L13
  if ( ! hqm_gated_rst_n ) begin
    p10_stall_f <= '0 ;
  end
  else begin
    p10_stall_f <= p10_stall_nxt ;
  end
end

//------------------------------------------------------------------------------------------------------------------------------------------------
// Instances








hqm_AW_ecc_gen # (
   .DATA_WIDTH                        ( HQM_AQED_DATA )
 , .ECC_WIDTH                         ( HQM_AQED_ECC )
) i_ecc_gen_default (
   .d                                 ( 11'd0 )
 , .ecc                               ( ecc_gen_default )
) ;

hqm_AW_ecc_gen # (
   .DATA_WIDTH                        ( HQM_AQED_DATA )
 , .ECC_WIDTH                         ( HQM_AQED_ECC )
) i_ecc_gen_default2 (
   .d                                 ( ecc_d_default2 )
 , .ecc                               ( ecc_gen_default2 )
) ;

hqm_AW_ecc_gen # (
   .DATA_WIDTH                        ( HQM_AQED_DATA )
 , .ECC_WIDTH                         ( HQM_AQED_ECC )
) i_ecc_gen (
   .d                                 ( ecc_gen_d )
 , .ecc                               ( ecc_gen_ecc )
) ;

hqm_AW_ecc_check # (
   .DATA_WIDTH                        ( HQM_AQED_DATA )
 , .ECC_WIDTH                         ( HQM_AQED_ECC )
) i_ecc_check (
   .din_v                             ( ecc_check_dinv_v )
 , .din                               ( ecc_check_din )
 , .ecc                               ( ecc_check_ecc )
 , .enable                            ( 1'b1 )
 , .correct                           ( 1'b1 )
 , .dout                              ( ecc_check_dout )
 , .error_sb                          ( ecc_check_error_sb )
 , .error_mb                          ( ecc_check_error_mb )
) ;

hqm_AW_parity_gen # (
   .WIDTH                             ( HQM_AQED_DATA )
) i_parity_gen (
   .d                                 ( parity_gen_d )
 , .odd                               ( 1'b1 )
 , .p                                 ( parity_gen_p )
) ;

hqm_AW_parity_check # (
   .WIDTH                             ( HQM_AQED_DATA )
) i_parity_check (
   .p                                 ( parity_check_p )
 , .d                                 ( parity_check_d )
 , .e                                 ( parity_check_e )
 , .odd                               ( 1'b1 )
 , .err                               ( parity_check_error )
) ;


assign func_FUNC_REN_RF_IN_P0 = '0 ; //NO functional read access to BCAM
assign func_FUNC_RD_ADDR_RF_IN_P0 = '0 ; //NO functional read access to BCAM

hqm_fid_bcam # (
  .HQM_AQED_FID_CNT_DWIDTH ( HQM_AQED_FID_CNT_DWIDTH )
, .HQM_AQED_FID_CNT_DEPTH ( HQM_AQED_FID_CNT_DEPTH )
, .HQM_AQED_FID_CNT_DEPTHB2 ( HQM_AQED_FID_CNT_DEPTHB2 )
, .HQM_AQED_QID_CNT_DWIDTH ( HQM_AQED_QID_CNT_DWIDTH )
, .HQM_AQED_QID_CNT_DEPTH ( HQM_AQED_QID_CNT_DEPTH )
, .HQM_AQED_QID_CNT_DEPTHB2 ( HQM_AQED_QID_CNT_DEPTHB2 )
, .HQM_AQED_QID_FID_LIMIT_DWIDTH ( HQM_AQED_QID_FID_LIMIT_DWIDTH )
, .HQM_AQED_QID_FID_LIMIT_DEPTH ( HQM_AQED_QID_FID_LIMIT_DEPTH )
, .HQM_AQED_QID_FID_LIMIT_DEPTHB2 ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 )
) i_hqm_fid_bcam (
   .clk ( hqm_gated_clk )
 , .rst_n ( hqm_gated_rst_n )

, .debug_hit ( debug_hit )
, .debug_collide0 ( debug_collide0 )
, .debug_collide1 ( debug_collide1 )
, .debug_fidcnt_uf ( debug_fidcnt_uf )
, .debug_fidcnt_of ( debug_fidcnt_of )
, .debug_qidcnt_uf ( debug_qidcnt_uf )
, .debug_qidcnt_of ( debug_qidcnt_of )

 , .init_active ( fid_bcam_init_active_nc )
 , .notempty ( fid_bcam_notempty )
 , .total_fid ( fid_bcam_total_fid )
 , .total_qid ( fid_bcam_total_qid )
 , .pipe_health ( fid_bcam_pipe_health )

 , .cfg_fid_decrement ( cfg_control0_f [ HQM_AQED_CHICKEN_FID_DECREMENT ] )
 , .cfg_fid_sim ( cfg_control0_f [ HQM_AQED_CHICKEN_FID_DECREMENT ] )

 , .in_enq_ack ( in_enq_ack )
 , .in_enq_v ( in_enq_v )
 , .in_enq_qid ( in_enq_qid )
 , .in_enq_hid ( in_enq_hid )
 , .in_enq_data ( in_enq_data )

 , .in_cmp_ack ( in_cmp_ack )
 , .in_cmp_v ( in_cmp_v )
 , .in_cmp_fid ( in_cmp_fid )
 , .in_cmp_qid ( in_cmp_qid )
 , .in_cmp_hid ( in_cmp_hid )

 , .out_enq_v ( out_enq_v )
 , .out_enq_fid ( out_enq_fid )
 , .out_enq_data ( out_enq_data )

 , .aqed_lsp_dec_fid_cnt_v ( aqed_lsp_dec_fid_cnt_v )

 , .aqed_lsp_fid_cnt_upd_v ( aqed_lsp_fid_cnt_upd_v )
 , .aqed_lsp_fid_cnt_upd_val ( aqed_lsp_fid_cnt_upd_val )
 , .aqed_lsp_fid_cnt_upd_qid ( aqed_lsp_fid_cnt_upd_qid )

 , .FUNC_WEN_RF_IN_P0 ( func_FUNC_WEN_RF_IN_P0 )
 , .FUNC_WR_ADDR_RF_IN_P0 ( func_FUNC_WR_ADDR_RF_IN_P0 )
 , .FUNC_WR_DATA_RF_IN_P0 ( func_FUNC_WR_DATA_RF_IN_P0 )

 , .FUNC_CEN_RF_IN_P0 ( func_FUNC_CEN_RF_IN_P0 )
 , .FUNC_CM_DATA_RF_IN_P0 ( func_FUNC_CM_DATA_RF_IN_P0 )
 , .CM_MATCH_RF_OUT_P0 ( func_CM_MATCH_RF_OUT_P0 )

 , .rf_aqed_fid_cnt_re ( func_aqed_fid_cnt_re )
 , .rf_aqed_fid_cnt_we ( func_aqed_fid_cnt_we )
 , .rf_aqed_fid_cnt_waddr ( func_aqed_fid_cnt_waddr )
 , .rf_aqed_fid_cnt_raddr ( func_aqed_fid_cnt_raddr )
 , .rf_aqed_fid_cnt_wdata ( func_aqed_fid_cnt_wdata )
 , .rf_aqed_fid_cnt_rdata ( func_aqed_fid_cnt_rdata )

 , .rf_aqed_qid_cnt_re ( func_aqed_qid_cnt_re )
 , .rf_aqed_qid_cnt_we ( func_aqed_qid_cnt_we )
 , .rf_aqed_qid_cnt_waddr ( func_aqed_qid_cnt_waddr )
 , .rf_aqed_qid_cnt_raddr ( func_aqed_qid_cnt_raddr )
 , .rf_aqed_qid_cnt_wdata ( func_aqed_qid_cnt_wdata )
 , .rf_aqed_qid_cnt_rdata ( func_aqed_qid_cnt_rdata )

 , .rf_aqed_qid_fid_limit_re ( func_aqed_qid_fid_limit_re )
 , .rf_aqed_qid_fid_limit_we ( func_aqed_qid_fid_limit_we )
 , .rf_aqed_qid_fid_limit_addr ( func_aqed_qid_fid_limit_addr )
 , .rf_aqed_qid_fid_limit_wdata ( func_aqed_qid_fid_limit_wdata )
 , .rf_aqed_qid_fid_limit_rdata ( func_aqed_qid_fid_limit_rdata )

 , .error ( fid_bcam_error )
) ;



hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_lsp_aqed_cmp_data ) )
) i_db_lsp_aqed_cmp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_lsp_aqed_cmp_status_pnc )
  , .in_valid                           ( lsp_aqed_cmp_v )
  , .in_ready                           ( lsp_aqed_cmp_ready )
  , .in_data                            ( lsp_aqed_cmp_data )
  , .out_valid                          ( db_lsp_aqed_cmp_v )
  , .out_ready                          ( db_lsp_aqed_cmp_ready )
  , .out_data                           ( db_lsp_aqed_cmp_data )
) ;


hqm_AW_parity_check # (
    .WIDTH                              ( 12 )
) i_parity_check_fid (
     .p                                 ( parity_check_fid_p )
   , .d                                 ( parity_check_fid_d )
   , .e                                 ( parity_check_fid_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_fid_error )
) ;


hqm_AW_parity_check # (
    .WIDTH                              ( 16 )
) i_parity_check_hid (
     .p                                 ( parity_check_hid_p )
   , .d                                 ( parity_check_hid_d )
   , .e                                 ( parity_check_hid_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_hid_error )
) ;

hqm_AW_parity_gen # (                   
    .WIDTH                              ( 7 + 12 + 16 - 1 )
) i_parity_gen_fifo_lsp_aqed_cmp (          
     .d                                 ( parity_gen_fifo_lsp_aqed_cmp_d )
   , .odd                               ( 1'b1 )
   , .p                                 ( parity_gen_fifo_lsp_aqed_cmp_p )
) ;

hqm_AW_parity_check #(
    .WIDTH                              (  7 + 12 + 16 - 1  )
) i_parity_check_fifo_lsp_aqed_cmp (    
     .p                                 ( parity_check_fifo_lsp_aqed_cmp_p )
   , .d                                 ( parity_check_fifo_lsp_aqed_cmp_d )
   , .e                                 ( parity_check_fifo_lsp_aqed_cmp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_fifo_lsp_aqed_cmp_error )
);

always_comb begin : L06
  in_enq_v = '0 ;
  in_enq_qid = '0 ;
  in_enq_hid = '0 ;
  in_enq_data = '0 ;
  in_cmp_v = '0 ;
  in_cmp_fid = '0 ;
  in_cmp_qid = '0 ;
  in_cmp_hid = '0 ;

  fifo_qed_aqed_enq_pop = '0 ;
  fifo_qed_aqed_enq_fid_push = '0 ;
  fifo_qed_aqed_enq_fid_push_data = '0 ;

  fifo_lsp_aqed_cmp_push = '0 ;
  fifo_lsp_aqed_cmp_push_data = '0 ;
  fifo_lsp_aqed_cmp_pop = '0 ;

parity_check_hid_e = '0 ;
parity_check_hid_p = '0 ;
parity_check_hid_d = '0 ;

parity_check_fid_e = '0 ;
parity_check_fid_p = '0 ;
parity_check_fid_d = '0 ;

parity_gen_fifo_lsp_aqed_cmp_d = '0 ;
parity_check_fifo_lsp_aqed_cmp_p = '0 ;
parity_check_fifo_lsp_aqed_cmp_d = '0 ;
parity_check_fifo_lsp_aqed_cmp_e = '0 ;

  fifo_qed_aqed_enq_fid_inc = '0 ;

  if ( fifo_qed_aqed_enq_pop_data_v
     & ( fifo_qed_aqed_enq_fid_credits_f < ( cfg_control4_f [ 11 ] ? 4'd1 : 4'd8 ) )
     & ( ~ cfg_req_idlepipe )
     ) begin
    in_enq_v = 1'b1 ;
    in_enq_qid = fifo_qed_aqed_enq_pop_data.cq_hcw.msg_info.qid ;
    in_enq_hid = fifo_qed_aqed_enq_pop_data.newlockid ;
    in_enq_data.cq_hcw = fifo_qed_aqed_enq_pop_data.cq_hcw ;
    in_enq_data.cq_hcw_ecc = fifo_qed_aqed_enq_pop_data.cq_hcw_ecc ;
    if ( in_enq_ack ) begin
      fifo_qed_aqed_enq_pop = 1'b1 ;
      fifo_qed_aqed_enq_fid_inc = 1'b1 ;
    end
  end

  if ( out_enq_v ) begin
    fifo_qed_aqed_enq_fid_push = 1'b1 ;
    fifo_qed_aqed_enq_fid_push_data.cq_hcw_ecc = out_enq_data.cq_hcw_ecc ;
    fifo_qed_aqed_enq_fid_push_data.cq_hcw = out_enq_data.cq_hcw ;
    fifo_qed_aqed_enq_fid_push_data.fid = out_enq_fid ;
  end

  db_lsp_aqed_cmp_ready = ~ fifo_lsp_aqed_cmp_afull ;

complockid_in_qid_completion = db_lsp_aqed_cmp_data.qid ;
complockid_in_lockid_completion = db_lsp_aqed_cmp_data.hid ;
  if ( db_lsp_aqed_cmp_v & db_lsp_aqed_cmp_ready ) begin
    fifo_lsp_aqed_cmp_push = 1'b1 ;

    fifo_lsp_aqed_cmp_push_data.fid = { parity_gen_fifo_lsp_aqed_cmp_p , db_lsp_aqed_cmp_data.fid [ 10 : 0 ] } ; //take MSB bit for parity on drain FIFO
    fifo_lsp_aqed_cmp_push_data.qid = db_lsp_aqed_cmp_data.qid ;
    fifo_lsp_aqed_cmp_push_data.hid = complockid_out_lockid_completion ;

parity_check_hid_e = 1'b1 ;
parity_check_hid_p = db_lsp_aqed_cmp_data.hid_parity ;
parity_check_hid_d = db_lsp_aqed_cmp_data.hid ;

parity_check_fid_e  = 1'b1 ;
parity_check_fid_p = db_lsp_aqed_cmp_data.fid_parity ;
parity_check_fid_d = db_lsp_aqed_cmp_data.fid ;

parity_gen_fifo_lsp_aqed_cmp_d = { fifo_lsp_aqed_cmp_push_data.qid , fifo_lsp_aqed_cmp_push_data.fid [ 10 : 0 ] , fifo_lsp_aqed_cmp_push_data.hid } ;
  end

  if ( ~ fifo_lsp_aqed_cmp_empty
     & ( ~ cfg_req_idlepipe )
     ) begin
    in_cmp_v = 1'b1 ;
    in_cmp_fid = fifo_lsp_aqed_cmp_pop_data_pnc.fid [ 10 : 0 ] ;
    in_cmp_qid = fifo_lsp_aqed_cmp_pop_data_pnc.qid ;
    in_cmp_hid = fifo_lsp_aqed_cmp_pop_data_pnc.hid ;
    if ( in_cmp_ack ) begin
      fifo_lsp_aqed_cmp_pop = 1'b1 ;
parity_check_fifo_lsp_aqed_cmp_p = fifo_lsp_aqed_cmp_pop_data_pnc.fid [ 11 ] ;
parity_check_fifo_lsp_aqed_cmp_d = { fifo_lsp_aqed_cmp_pop_data_pnc.qid , fifo_lsp_aqed_cmp_pop_data_pnc.fid [ 10 : 0 ] , fifo_lsp_aqed_cmp_pop_data_pnc.hid } ;
parity_check_fifo_lsp_aqed_cmp_e = 1'b1 ;
    end
  end



end



//....................................................................................................
//HW AGITATE
assign hqm_aqed_target_cfg_hw_agitate_control_reg_v   = 1'b0 ;
assign hqm_aqed_target_cfg_hw_agitate_control_reg_nxt = cfg_agitate_control_nxt ;
assign cfg_agitate_control_f = hqm_aqed_target_cfg_hw_agitate_control_reg_f ;
assign cfg_agitate_control_nxt = cfg_agitate_control_f ;

assign cfg_agitate_select_f = hqm_aqed_target_cfg_hw_agitate_select_reg_f ;

//....................................................................................................
// SMON logic
assign hqm_aqed_target_cfg_smon_disable_smon = disable_smon ;
assign hqm_aqed_target_cfg_smon_smon_v = smon_v_f ;
assign hqm_aqed_target_cfg_smon_smon_comp = smon_comp_f ;
assign hqm_aqed_target_cfg_smon_smon_val = smon_val_f ;
assign smon_interrupt_nc = hqm_aqed_target_cfg_smon_smon_interrupt ;

//....................................................................................................
// SYNDROME logic

//....................................................................................................
// ECC logic

hqm_AW_ecc_gen # (
   .DATA_WIDTH                          ( 64 )
 , .ECC_WIDTH                           ( 8 )
) i_ecc_gen_hcw_l (
   .d                                   ( ecc_gen_hcw_l_d_nc )
 , .ecc                                 ( ecc_gen_hcw_l_ecc )
) ;
hqm_AW_ecc_gen # (
   .DATA_WIDTH                          ( 59 )
 , .ECC_WIDTH                           ( 8 )
) i_ecc_gen_hcw_h (
   .d                                   ( ecc_gen_hcw_h_d_nc )
 , .ecc                                 ( ecc_gen_hcw_h_ecc )
) ;

hqm_AW_ecc_check # (
   .DATA_WIDTH                        ( 64 )
 , .ECC_WIDTH                         ( 8 )
) i_cq_hcw_ecc_check_h (
   .din_v                             ( ecc_check_hcw_l_din_v )
 , .din                               ( ecc_check_hcw_l_din )
 , .ecc                               ( ecc_check_hcw_l_ecc )
 , .enable                            ( ecc_check_hcw_l_enable )
 , .correct                           ( ecc_check_hcw_l_correct )
 , .dout                              ( ecc_check_hcw_l_dout )
 , .error_sb                          ( ecc_check_hcw_l_error_sb )
 , .error_mb                          ( ecc_check_hcw_l_error_mb )
) ;
hqm_AW_ecc_check # (
   .DATA_WIDTH                        ( 59 )
 , .ECC_WIDTH                         ( 8 )
) i_cq_hcw_ecc_check_l (
   .din_v                             ( ecc_check_hcw_h_din_v )
 , .din                               ( ecc_check_hcw_h_din )
 , .ecc                               ( ecc_check_hcw_h_ecc )
 , .enable                            ( ecc_check_hcw_h_enable )
 , .correct                           ( ecc_check_hcw_h_correct )
 , .dout                              ( ecc_check_hcw_h_dout )
 , .error_sb                          ( ecc_check_hcw_h_error_sb )
 , .error_mb                          ( ecc_check_hcw_h_error_mb )
) ;

//....................................................................................................
// PARITY logic


hqm_AW_parity_check # (
    .WIDTH                              ( HQM_AQED_FLIDB2 )
) i_parity_check_ll_rmw_hp_p2 (
     .p                                 ( parity_check_ll_rmw_hp_p2_p )
   , .d                                 ( parity_check_ll_rmw_hp_p2_d )
   , .e                                 ( parity_check_ll_rmw_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rmw_hp_p2_error )
) ;



hqm_AW_parity_check # (
    .WIDTH                              ( HQM_AQED_FLIDB2 )
) i_parity_check_ll_rmw_tp_p2 (
     .p                                 ( parity_check_ll_rmw_tp_p2_p )
   , .d                                 ( parity_check_ll_rmw_tp_p2_d )
   , .e                                 ( parity_check_ll_rmw_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rmw_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_AQED_FLIDB2 )
) i_parity_check_ll_rw_ll_qe_hpnxt_p2 (
     .p                                 ( parity_check_ll_rw_ll_qe_hpnxt_p2_data_p )
   , .d                                 ( parity_check_ll_rw_ll_qe_hpnxt_p2_data_d )
   , .e                                 ( parity_check_ll_rw_ll_qe_hpnxt_p2_data_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rw_ll_qe_hpnxt_p2_data_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 18 )
) i_parity_check_db_ap_aqed (
     .p                                 ( parity_check_db_ap_aqed_p )
   , .d                                 ( parity_check_db_ap_aqed_d )
   , .e                                 ( parity_check_db_ap_aqed_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_db_ap_aqed_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 12 )
) i_parity_check_db_ap_aqed_fid (
     .p                                 ( parity_check_db_ap_aqed_fid_p )
   , .d                                 ( parity_check_db_ap_aqed_fid_d )
   , .e                                 ( parity_check_db_ap_aqed_fid_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_db_ap_aqed_fid_error )
) ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 10 )
) i_parity_gen_aqed_ap (
     .d                                 ( parity_gen_aqed_ap_d )
   , .odd                               ( 1'b1 )
   , .p                                 ( parity_gen_aqed_ap_p )
) ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 12 )
) i_parity_gen_fid (
     .d                                 ( parity_gen_fid_d )
   , .odd                               ( 1'b1 )
   , .p                                 ( parity_gen_fid_p )
) ;



//....................................................................................................
// RESIDUE

hqm_AW_residue_add i_residue_add_ll_cnt (
   .a                                 ( residue_add_ll_cnt_a )
 , .b                                 ( residue_add_ll_cnt_b )
 , .r                                 ( residue_add_ll_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_ll_cnt (
   .a                                 ( residue_sub_ll_cnt_a )
 , .b                                 ( residue_sub_ll_cnt_b )
 , .r                                 ( residue_sub_ll_cnt_r )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_AQED_CNTB2 )
) i_residue_check_ll_cnt (
   .r                                 ( residue_check_ll_cnt_r_f )
 , .d                                 ( residue_check_ll_cnt_d_f )
 , .e                                 ( residue_check_ll_cnt_e_f )
 , .err                               ( residue_check_ll_cnt_err )
) ;

//....................................................................................................
// FIFO

assign fifo_ap_aqed_error_of = fifo_ap_aqed_status [ 1 ] ;
assign fifo_ap_aqed_error_uf = fifo_ap_aqed_status [ 0 ] ;
assign fifo_ap_aqed_cfg_high_wm = hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_f [ HQM_AQED_FIFO_AP_AQED_WMWIDTH - 1 : 0 ] ;
assign hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt = { fifo_ap_aqed_status [ 23 : 0 ] , hqm_aqed_target_cfg_fifo_wmstat_ap_aqed_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_AQED_FIFO_AP_AQED_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_ap_aqed_push_data ) )
) i_fifo_ap_aqed (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_ap_aqed_cfg_high_wm )
  , .fifo_status                        ( fifo_ap_aqed_status )
  , .push                               ( fifo_ap_aqed_push )
  , .push_data                          ( { fifo_ap_aqed_push_data } )
  , .pop                                ( fifo_ap_aqed_pop )
  , .pop_data                           ( { fifo_ap_aqed_pop_data_pnc } )
  , .fifo_full                          ( fifo_ap_aqed_full_nc )
  , .fifo_afull                         ( fifo_ap_aqed_afull )
  , .fifo_empty                         ( fifo_ap_aqed_empty )
  , .mem_we                             ( func_aqed_fifo_ap_aqed_we )
  , .mem_waddr                          ( func_aqed_fifo_ap_aqed_waddr )
  , .mem_wdata                          ( func_aqed_fifo_ap_aqed_wdata )
  , .mem_re                             ( func_aqed_fifo_ap_aqed_re )
  , .mem_raddr                          ( func_aqed_fifo_ap_aqed_raddr )
  , .mem_rdata                          ( func_aqed_fifo_ap_aqed_rdata )
) ;

// FIFO for 
assign fifo_qed_aqed_enq_error_of = fifo_qed_aqed_enq_status [ 1 ] ;
assign fifo_qed_aqed_enq_error_uf = fifo_qed_aqed_enq_status [ 0 ] ;
assign fifo_qed_aqed_enq_cfg_high_wm = hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_f [ HQM_AQED_FIFO_QED_AQED_ENQ_WMWIDTH - 1 : 0 ] ;
assign hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_nxt = { fifo_qed_aqed_enq_status [ 23 : 0 ] , hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control_wreg # (
    .DEPTH                              ( HQM_AQED_FIFO_QED_AQED_ENQ_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_qed_aqed_enq_push_data ) )
) i_fifo_qed_aqed_enq (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_qed_aqed_enq_cfg_high_wm )
  , .fifo_status                        ( fifo_qed_aqed_enq_status )
  , .push                               ( fifo_qed_aqed_enq_push )
  , .push_data                          ( { fifo_qed_aqed_enq_push_data } )
  , .pop                                ( fifo_qed_aqed_enq_pop )
  , .pop_data                           ( { fifo_qed_aqed_enq_pop_data } )
  , .fifo_full                          ( fifo_qed_aqed_enq_full )
  , .fifo_afull                         ( fifo_qed_aqed_enq_afull_nc )
  , .pop_data_v                         ( fifo_qed_aqed_enq_pop_data_v )
  , .mem_we                             ( func_aqed_fifo_qed_aqed_enq_we )
  , .mem_waddr                          ( func_aqed_fifo_qed_aqed_enq_waddr )
  , .mem_wdata                          ( func_aqed_fifo_qed_aqed_enq_wdata )
  , .mem_re                             ( func_aqed_fifo_qed_aqed_enq_re )
  , .mem_raddr                          ( func_aqed_fifo_qed_aqed_enq_raddr )
  , .mem_rdata                          ( func_aqed_fifo_qed_aqed_enq_rdata )
) ;

assign fifo_qed_aqed_enq_fid_error_of = fifo_qed_aqed_enq_fid_status [ 1 ] ;
assign fifo_qed_aqed_enq_fid_error_uf = fifo_qed_aqed_enq_fid_status [ 0 ] ;
assign fifo_qed_aqed_enq_fid_cfg_high_wm = hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_f [ HQM_AQED_FIFO_QED_AQED_ENQ_FID_WMWIDTH - 1 : 0 ] ;
assign hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_nxt = { fifo_qed_aqed_enq_fid_status [ 23 : 0 ] , hqm_aqed_target_cfg_fifo_wmstat_qed_aqed_enq_fid_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_AQED_FIFO_QED_AQED_ENQ_FID_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_qed_aqed_enq_fid_push_data ) )
) i_fifo_qed_aqed_enq_fid (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_qed_aqed_enq_fid_cfg_high_wm )
  , .fifo_status                        ( fifo_qed_aqed_enq_fid_status )
  , .push                               ( fifo_qed_aqed_enq_fid_push )
  , .push_data                          ( { fifo_qed_aqed_enq_fid_push_data } )
  , .pop                                ( fifo_qed_aqed_enq_fid_pop )
  , .pop_data                           ( { fifo_qed_aqed_enq_fid_pop_data_pnc } )
  , .fifo_full                          ( fifo_qed_aqed_enq_fid_full_nc )
  , .fifo_afull                         ( fifo_qed_aqed_enq_fid_afull_nc )
  , .fifo_empty                         ( fifo_qed_aqed_enq_fid_empty )
  , .mem_we                             ( func_aqed_fifo_qed_aqed_enq_fid_we )
  , .mem_waddr                          ( func_aqed_fifo_qed_aqed_enq_fid_waddr )
  , .mem_wdata                          ( func_aqed_fifo_qed_aqed_enq_fid_wdata )
  , .mem_re                             ( func_aqed_fifo_qed_aqed_enq_fid_re )
  , .mem_raddr                          ( func_aqed_fifo_qed_aqed_enq_fid_raddr )
  , .mem_rdata                          ( func_aqed_fifo_qed_aqed_enq_fid_rdata )
) ;

assign fifo_lsp_aqed_cmp_empty = ~ fifo_lsp_aqed_cmp_pop_data_v ;
assign fifo_lsp_aqed_cmp_error_of = fifo_lsp_aqed_cmp_status [ 0 ] ;
assign fifo_lsp_aqed_cmp_error_uf = fifo_lsp_aqed_cmp_status [ 1 ] ;
assign fifo_lsp_aqed_cmp_cfg_high_wm = hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_f [ HQM_AQED_FIFO_LSP_AQED_CMP_WMWIDTH - 1 : 0 ] ;
assign hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_nxt = { fifo_lsp_aqed_cmp_status [ 23 : 0 ] , hqm_aqed_target_cfg_fifo_wmstat_lsp_aqed_cmp_fid_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control_wreg # (
    .DEPTH                              ( HQM_AQED_FIFO_LSP_AQED_CMP_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_lsp_aqed_cmp_push_data ) )
) i_fifo_lsp_aqed_cmp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_lsp_aqed_cmp_cfg_high_wm )
  , .fifo_status                        ( fifo_lsp_aqed_cmp_status )
  , .push                               ( fifo_lsp_aqed_cmp_push )
  , .push_data                          ( { fifo_lsp_aqed_cmp_push_data } )
  , .pop                                ( fifo_lsp_aqed_cmp_pop )
  , .pop_data                           ( { fifo_lsp_aqed_cmp_pop_data_pnc } )
  , .fifo_full                          ( fifo_lsp_aqed_cmp_full_nc )
  , .fifo_afull                         ( fifo_lsp_aqed_cmp_afull )
  , .pop_data_v                         ( fifo_lsp_aqed_cmp_pop_data_v )
  , .mem_we                             ( func_aqed_fifo_lsp_aqed_cmp_we )
  , .mem_waddr                          ( func_aqed_fifo_lsp_aqed_cmp_waddr )
  , .mem_wdata                          ( func_aqed_fifo_lsp_aqed_cmp_wdata )
  , .mem_re                             ( func_aqed_fifo_lsp_aqed_cmp_re )
  , .mem_raddr                          ( func_aqed_fifo_lsp_aqed_cmp_raddr )
  , .mem_rdata                          ( func_aqed_fifo_lsp_aqed_cmp_rdata )
) ;

// FIFO for 
assign fifo_aqed_ap_enq_error_of = fifo_aqed_ap_enq_status [ 1 ] ;
assign fifo_aqed_ap_enq_error_uf = fifo_aqed_ap_enq_status [ 0 ] ;
assign fifo_aqed_ap_enq_cfg_high_wm = hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f [ HQM_AQED_FIFO_AQED_AP_ENQ_WMWIDTH - 1 : 0 ] ;
assign hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt = { fifo_aqed_ap_enq_status [ 23 : 0 ] , hqm_aqed_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_AQED_FIFO_AQED_AP_ENQ_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_aqed_ap_enq_push_data ) )
) i_fifo_aqed_ap_enq (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_aqed_ap_enq_cfg_high_wm )
  , .fifo_status                        ( fifo_aqed_ap_enq_status )
  , .push                               ( fifo_aqed_ap_enq_push )
  , .push_data                          ( { fifo_aqed_ap_enq_push_data } )
  , .pop                                ( fifo_aqed_ap_enq_pop )
  , .pop_data                           ( { fifo_aqed_ap_enq_pop_data } )
  , .fifo_full                          ( fifo_aqed_ap_enq_full_nc )
  , .fifo_afull                         ( fifo_aqed_ap_enq_afull )
  , .fifo_empty                         ( fifo_aqed_ap_enq_empty )
  , .mem_we                             ( func_aqed_fifo_aqed_ap_enq_we )
  , .mem_waddr                          ( func_aqed_fifo_aqed_ap_enq_waddr )
  , .mem_wdata                          ( func_aqed_fifo_aqed_ap_enq_wdata )
  , .mem_re                             ( func_aqed_fifo_aqed_ap_enq_re )
  , .mem_raddr                          ( func_aqed_fifo_aqed_ap_enq_raddr )
  , .mem_rdata                          ( func_aqed_fifo_aqed_ap_enq_rdata )
) ;


// FIFO for 
assign fifo_freelist_return_error_of = fifo_freelist_return_status [ 1 ] ;
assign fifo_freelist_return_error_uf = fifo_freelist_return_status [ 0 ] ;
assign fifo_freelist_return_cfg_high_wm = hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_f [ HQM_AQED_FIFO_FREELIST_RETURN_WMWIDTH - 1 : 0 ] ;
assign hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_nxt = { fifo_freelist_return_status [ 23 : 0 ] , hqm_aqed_target_cfg_fifo_wmstat_freelist_return_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_AQED_FIFO_FREELIST_RETURN_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_freelist_return_push_data ) )
) i_fifo_freelist_return (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_freelist_return_cfg_high_wm )
  , .fifo_status                        ( fifo_freelist_return_status )
  , .push                               ( fifo_freelist_return_push )
  , .push_data                          ( { fifo_freelist_return_push_data } )
  , .pop                                ( fifo_freelist_return_pop )
  , .pop_data                           ( { fifo_freelist_return_pop_data_pnc } )
  , .fifo_full                          ( fifo_freelist_return_full_nc )
  , .fifo_afull                         ( fifo_freelist_return_afull )
  , .fifo_empty                         ( fifo_freelist_return_empty )
  , .mem_we                             ( func_aqed_fifo_freelist_return_we )
  , .mem_waddr                          ( func_aqed_fifo_freelist_return_waddr )
  , .mem_wdata                          ( func_aqed_fifo_freelist_return_wdata )
  , .mem_re                             ( func_aqed_fifo_freelist_return_re )
  , .mem_raddr                          ( func_aqed_fifo_freelist_return_raddr )
  , .mem_rdata                          ( func_aqed_fifo_freelist_return_rdata )
) ;

assign fifo_aqed_chp_sch_error_of = fifo_aqed_chp_sch_status [ 1 ] ;
assign fifo_aqed_chp_sch_error_uf = fifo_aqed_chp_sch_status [ 0 ] ;
assign fifo_aqed_chp_sch_cfg_high_wm = hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_f [ HQM_AQED_FIFO_AQED_CHP_SCH_WMWIDTH - 1 : 0 ] ;
assign hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_nxt = { fifo_aqed_chp_sch_status [ 23 : 0 ] , hqm_aqed_target_cfg_fifo_wmstat_aqed_chp_sch_if_reg_f [ 7 : 0 ] } ;
logic [ ( 1 ) - 1 : 0 ] fifo_aqed_chp_sch_pop_data_spare_nc ;
hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_AQED_FIFO_AQED_CHP_SCH_DEPTH )
  , .DWIDTH                             ( 180 )
) i_fifo_aqed_chp_sch (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_aqed_chp_sch_cfg_high_wm )
  , .fifo_status                        ( fifo_aqed_chp_sch_status )
  , .push                               ( fifo_aqed_chp_sch_push )
  , .push_data                          ( { 1'd0 , fifo_aqed_chp_sch_push_data } )
  , .pop                                ( fifo_aqed_chp_sch_pop )
  , .pop_data                           ( { fifo_aqed_chp_sch_pop_data_spare_nc , fifo_aqed_chp_sch_pop_data_pnc } )
  , .fifo_full                          ( fifo_aqed_chp_sch_full_nc )
  , .fifo_afull                         ( fifo_aqed_chp_sch_afull )
  , .fifo_empty                         ( fifo_aqed_chp_sch_empty )
  , .mem_we                             ( func_aqed_fifo_aqed_chp_sch_we )
  , .mem_waddr                          ( func_aqed_fifo_aqed_chp_sch_waddr )
  , .mem_wdata                          ( func_aqed_fifo_aqed_chp_sch_wdata )
  , .mem_re                             ( func_aqed_fifo_aqed_chp_sch_re )
  , .mem_raddr                          ( func_aqed_fifo_aqed_chp_sch_raddr )
  , .mem_rdata                          ( func_aqed_fifo_aqed_chp_sch_rdata )
) ;

//....................................................................................................
// ARB

hqm_AW_rr_arb # (
    .NUM_REQS ( 3 )
) i_arb_ll (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .reqs                               ( arb_ll_reqs )
  , .update                             ( arb_ll_update )
  , .winner_v                           ( arb_ll_winner_v )
  , .winner                             ( arb_ll_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 8 )
) i_arb_ll_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control3_f [ 31 : 24 ] , cfg_control3_f [ 23 : 16 ] , cfg_control3_f [ 15 : 8 ] , cfg_control3_f [ 7 : 0 ] , cfg_control2_f [ 31 : 24 ] , cfg_control2_f [ 23 : 16 ] , cfg_control2_f [ 15 : 8 ] , cfg_control2_f [ 7 : 0 ] } )
  , .reqs                               ( arb_ll_cnt_reqs )
  , .winner_v                           ( arb_ll_cnt_winner_v )
  , .winner                             ( arb_ll_cnt_winner )
) ;

//....................................................................................................
// RAM RW or RMW PIPELINE
generate
for ( genvar g = 0 ; g < HQM_AQED_NUM_PRI ; g = g + 1 ) begin : i_rmw

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_AQED_LL_CNT_DEPTH )
  , .WIDTH                              ( $bits ( func_aqed_ll_cnt_wdata ) / HQM_AQED_NUM_PRI )
) i_rmw_ll_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_cnt_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_cnt_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_ll_cnt_p0_addr_nxt [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_cnt_p0_write_data_nxt [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_cnt_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_cnt_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_cnt_p0_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p0_addr_f                          ( rmw_ll_cnt_p0_addr_f_nc [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_cnt_p0_data_f_nc [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_cnt_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_cnt_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_cnt_p1_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p1_addr_f                          ( rmw_ll_cnt_p1_addr_f_nc [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_cnt_p1_data_f_nc [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_cnt_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_cnt_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_cnt_p2_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p2_addr_f                          ( rmw_ll_cnt_p2_addr_f [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_cnt_p2_data_f [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_cnt_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_cnt_p3_bypsel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_cnt_p3_bypsel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_cnt_p3_bypaddr_nxt [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_cnt_p3_bypdata_nxt [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )
  , .p3_v_f                             ( rmw_ll_cnt_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_cnt_p3_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p3_addr_f                          ( rmw_ll_cnt_p3_addr_f_nc [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_cnt_p3_data_f_nc [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )

  , .mem_write                          ( func_aqed_ll_cnt_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_aqed_ll_cnt_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_aqed_ll_cnt_waddr [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .mem_read_addr                      ( func_aqed_ll_cnt_raddr [ ( g * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] )
  , .mem_write_data                     ( func_aqed_ll_cnt_wdata [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )
  , .mem_read_data                      ( func_aqed_ll_cnt_rdata [ ( g * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] )
) ;

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_AQED_LL_QE_HP_DEPTH )
  , .WIDTH                              ( $bits ( func_aqed_ll_qe_hp_wdata ) / HQM_AQED_NUM_PRI )
) i_rmw_ll_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_hp_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_hp_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_hp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_ll_hp_p0_addr_nxt [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_hp_p0_write_data_nxt [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_hp_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_hp_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_hp_p0_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p0_addr_f                          ( rmw_ll_hp_p0_addr_f_nc [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_hp_p0_data_f_nc [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_hp_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_hp_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_hp_p1_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p1_addr_f                          ( rmw_ll_hp_p1_addr_f_nc [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_hp_p1_data_f_nc [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_hp_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_hp_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_hp_p2_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p2_addr_f                          ( rmw_ll_hp_p2_addr_f_nc [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_hp_p2_data_f [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_hp_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_hp_p3_bypsel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_hp_p3_bypsel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_hp_p3_bypaddr_nxt [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_hp_p3_bypdata_nxt [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )
  , .p3_v_f                             ( rmw_ll_hp_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_hp_p3_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p3_addr_f                          ( rmw_ll_hp_p3_addr_f_nc [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_hp_p3_data_f_nc [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )

  , .mem_write                          ( func_aqed_ll_qe_hp_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_aqed_ll_qe_hp_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_aqed_ll_qe_hp_waddr [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .mem_read_addr                      ( func_aqed_ll_qe_hp_raddr [ ( g * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] )
  , .mem_write_data                     ( func_aqed_ll_qe_hp_wdata [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )
  , .mem_read_data                      ( func_aqed_ll_qe_hp_rdata [ ( g * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] )
) ;

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_AQED_LL_QE_TP_DEPTH )
  , .WIDTH                              ( $bits ( func_aqed_ll_qe_tp_wdata ) / HQM_AQED_NUM_PRI )
) i_rmw_ll_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_tp_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_tp_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_tp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_ll_tp_p0_addr_nxt [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_tp_p0_write_data_nxt [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_tp_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_tp_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_tp_p0_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p0_addr_f                          ( rmw_ll_tp_p0_addr_f_nc [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_tp_p0_data_f_nc [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_tp_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_tp_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_tp_p1_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p1_addr_f                          ( rmw_ll_tp_p1_addr_f_nc [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_tp_p1_data_f_nc [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_tp_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_tp_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_tp_p2_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p2_addr_f                          ( rmw_ll_tp_p2_addr_f_nc [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_tp_p2_data_f [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_tp_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_tp_p3_bypsel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_tp_p3_bypsel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_tp_p3_bypaddr_nxt [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_tp_p3_bypdata_nxt [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )
  , .p3_v_f                             ( rmw_ll_tp_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_tp_p3_rw_f_nc [ ( g * 2 ) +: 2 ] )
  , .p3_addr_f                          ( rmw_ll_tp_p3_addr_f_nc [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_tp_p3_data_f_nc [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )

  , .mem_write                          ( func_aqed_ll_qe_tp_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_aqed_ll_qe_tp_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_aqed_ll_qe_tp_waddr [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .mem_read_addr                      ( func_aqed_ll_qe_tp_raddr [ ( g * HQM_AQED_LL_QE_TP_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_DEPTHB2 ] )
  , .mem_write_data                     ( func_aqed_ll_qe_tp_wdata [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )
  , .mem_read_data                      ( func_aqed_ll_qe_tp_rdata [ ( g * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH ] )
) ;
end
endgenerate

assign func_aqed_ll_qe_hpnxt_we = wire_sr_aqed_ll_qe_hpnxt_we & ~ p10_stall_f [ 0 ] ;
hqm_aqed_pipe_nxthp_rw_mem_4pipe_core # (
    .DEPTH                              ( HQM_AQED_LL_QE_HPNXT_DEPTH )
  , .WIDTH                              ( HQM_AQED_LL_QE_HPNXT_DWIDTH )
  , .BLOCK_WRITE_ON_P0_HOLD ( 1 )
) i_rw_ll_qe_hpnxt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rw_ll_qe_hpnxt_status )

, .error_sb ( rw_ll_qe_hpnxt_error_sb )
, .error_mb ( rw_ll_qe_hpnxt_error_mb )
, .err_parity ( rw_ll_qe_hpnxt_err_parity )

  , .p0_v_nxt                           ( rw_ll_qe_hpnxt_p0_v_nxt )
  , .p0_rw_nxt                          ( rw_ll_qe_hpnxt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rw_ll_qe_hpnxt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rw_ll_qe_hpnxt_p0_write_data_nxt )
  , .p0_byp_v_nxt                           ( rw_ll_qe_hpnxt_p0_byp_v_nxt )
  , .p0_byp_rw_nxt                          ( rw_ll_qe_hpnxt_p0_byp_rw_nxt )
  , .p0_byp_addr_nxt                        ( rw_ll_qe_hpnxt_p0_byp_addr_nxt )
  , .p0_byp_write_data_nxt                  ( rw_ll_qe_hpnxt_p0_byp_write_data_nxt )
  , .p0_hold                            ( rw_ll_qe_hpnxt_p0_hold )
  , .p0_v_f                             ( rw_ll_qe_hpnxt_p0_v_f )
  , .p0_rw_f                            ( rw_ll_qe_hpnxt_p0_rw_f_nc )
  , .p0_addr_f                          ( rw_ll_qe_hpnxt_p0_addr_f_nc )
  , .p0_data_f                          ( rw_ll_qe_hpnxt_p0_data_f_nc )

  , .p1_hold                            ( rw_ll_qe_hpnxt_p1_hold )
  , .p1_v_f                             ( rw_ll_qe_hpnxt_p1_v_f )
  , .p1_rw_f                            ( rw_ll_qe_hpnxt_p1_rw_f_nc )
  , .p1_addr_f                          ( rw_ll_qe_hpnxt_p1_addr_f_nc )
  , .p1_data_f                          ( rw_ll_qe_hpnxt_p1_data_f_nc )

  , .p2_hold                            ( rw_ll_qe_hpnxt_p2_hold )
  , .p2_v_f                             ( rw_ll_qe_hpnxt_p2_v_f )
  , .p2_rw_f                            ( rw_ll_qe_hpnxt_p2_rw_f_nc )
  , .p2_addr_f                          ( rw_ll_qe_hpnxt_p2_addr_f_nc )
  , .p2_data_f                          ( rw_ll_qe_hpnxt_p2_data_f )

  , .p3_hold                            ( rw_ll_qe_hpnxt_p3_hold )
  , .p3_v_f                             ( rw_ll_qe_hpnxt_p3_v_f )
  , .p3_rw_f                            ( rw_ll_qe_hpnxt_p3_rw_f_nc )
  , .p3_addr_f                          ( rw_ll_qe_hpnxt_p3_addr_f_nc )
  , .p3_data_f                          ( rw_ll_qe_hpnxt_p3_data_f_nc )

  , .mem_write                          ( wire_sr_aqed_ll_qe_hpnxt_we )
  , .mem_read                           ( func_aqed_ll_qe_hpnxt_re )
  , .mem_addr                           ( func_aqed_ll_qe_hpnxt_addr )
  , .mem_write_data                     ( func_aqed_ll_qe_hpnxt_wdata )
  , .mem_read_data                      ( func_aqed_ll_qe_hpnxt_rdata )
) ;

assign func_aqed_we = wire_sr_aqed_we & ~ p10_stall_f [ 1 ] ;
hqm_AW_rw_mem_4pipe_core # (
    .DEPTH                              ( HQM_AQED_DEPTH )
  , .WIDTH                              ( $bits ( func_aqed_wdata ) )
  , .BLOCK_WRITE_ON_P0_HOLD ( 1 )
) i_rw_aqed (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rw_aqed_status )

  , .p0_v_nxt                           ( rw_aqed_p0_v_nxt )
  , .p0_rw_nxt                          ( rw_aqed_p0_rw_nxt )
  , .p0_addr_nxt                        ( rw_aqed_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rw_aqed_p0_write_data_nxt )
  , .p0_byp_v_nxt                           ( rw_aqed_p0_byp_v_nxt )
  , .p0_byp_rw_nxt                          ( rw_aqed_p0_byp_rw_nxt )
  , .p0_byp_addr_nxt                        ( rw_aqed_p0_byp_addr_nxt )
  , .p0_byp_write_data_nxt                  ( rw_aqed_p0_byp_write_data_nxt_nc )
  , .p0_hold                            ( rw_aqed_p0_hold )
  , .p0_v_f                             ( rw_aqed_p0_v_f )
  , .p0_rw_f                            ( rw_aqed_p0_rw_f_nc )
  , .p0_addr_f                          ( rw_aqed_p0_addr_f_nc )
  , .p0_data_f                          ( rw_aqed_p0_data_f_nc )

  , .p1_hold                            ( rw_aqed_p1_hold )
  , .p1_v_f                             ( rw_aqed_p1_v_f )
  , .p1_rw_f                            ( rw_aqed_p1_rw_f_nc )
  , .p1_addr_f                          ( rw_aqed_p1_addr_f_nc )
  , .p1_data_f                          ( rw_aqed_p1_data_f_nc )

  , .p2_hold                            ( rw_aqed_p2_hold )
  , .p2_v_f                             ( rw_aqed_p2_v_f )
  , .p2_rw_f                            ( rw_aqed_p2_rw_f_nc )
  , .p2_addr_f                          ( rw_aqed_p2_addr_f_nc )
  , .p2_data_f                          ( rw_aqed_p2_data_f )

  , .p3_hold                            ( rw_aqed_p3_hold )
  , .p3_v_f                             ( rw_aqed_p3_v_f )
  , .p3_rw_f                            ( rw_aqed_p3_rw_f_nc )
  , .p3_addr_f                          ( rw_aqed_p3_addr_f_nc )
  , .p3_data_f                          ( rw_aqed_p3_data_f_nc )

  , .mem_write                          ( wire_sr_aqed_we )
  , .mem_read                           ( func_aqed_re )
  , .mem_addr                           ( func_aqed_addr )
  , .mem_write_data                     ( func_aqed_wdata )
  , .mem_read_data                      ( func_aqed_rdata )
) ;

assign func_aqed_ll_cnt_pri0_we =  func_aqed_ll_cnt_we [ ( 0 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri0_re =  func_aqed_ll_cnt_re [ ( 0 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri0_waddr =  func_aqed_ll_cnt_waddr [ ( 0 * HQM_AQED_LL_CNT_PRI0_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI0_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri0_raddr =  func_aqed_ll_cnt_raddr [ ( 0 * HQM_AQED_LL_CNT_PRI0_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI0_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri0_wdata =  func_aqed_ll_cnt_wdata [ ( 0 * HQM_AQED_LL_CNT_PRI0_DWIDTH ) +: HQM_AQED_LL_CNT_PRI0_DWIDTH ] ;
assign  func_aqed_ll_cnt_rdata [ ( 0 * HQM_AQED_LL_CNT_PRI0_DWIDTH ) +: HQM_AQED_LL_CNT_PRI0_DWIDTH ] = func_aqed_ll_cnt_pri0_rdata ;

assign func_aqed_ll_cnt_pri1_we =  func_aqed_ll_cnt_we [ ( 1 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri1_re =  func_aqed_ll_cnt_re [ ( 1 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri1_waddr =  func_aqed_ll_cnt_waddr [ ( 1 * HQM_AQED_LL_CNT_PRI1_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI1_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri1_raddr =  func_aqed_ll_cnt_raddr [ ( 1 * HQM_AQED_LL_CNT_PRI1_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI1_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri1_wdata =  func_aqed_ll_cnt_wdata [ ( 1 * HQM_AQED_LL_CNT_PRI1_DWIDTH ) +: HQM_AQED_LL_CNT_PRI1_DWIDTH ] ;
assign  func_aqed_ll_cnt_rdata [ ( 1 * HQM_AQED_LL_CNT_PRI1_DWIDTH ) +: HQM_AQED_LL_CNT_PRI1_DWIDTH ] = func_aqed_ll_cnt_pri1_rdata ;

assign func_aqed_ll_cnt_pri2_we =  func_aqed_ll_cnt_we [ ( 2 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri2_re =  func_aqed_ll_cnt_re [ ( 2 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri2_waddr =  func_aqed_ll_cnt_waddr [ ( 2 * HQM_AQED_LL_CNT_PRI2_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI2_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri2_raddr =  func_aqed_ll_cnt_raddr [ ( 2 * HQM_AQED_LL_CNT_PRI2_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI2_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri2_wdata =  func_aqed_ll_cnt_wdata [ ( 2 * HQM_AQED_LL_CNT_PRI2_DWIDTH ) +: HQM_AQED_LL_CNT_PRI2_DWIDTH ] ;
assign  func_aqed_ll_cnt_rdata [ ( 2 * HQM_AQED_LL_CNT_PRI2_DWIDTH ) +: HQM_AQED_LL_CNT_PRI2_DWIDTH ] = func_aqed_ll_cnt_pri2_rdata ;

assign func_aqed_ll_cnt_pri3_we =  func_aqed_ll_cnt_we [ ( 3 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri3_re =  func_aqed_ll_cnt_re [ ( 3 * 1 ) +: 1 ] ;
assign func_aqed_ll_cnt_pri3_waddr =  func_aqed_ll_cnt_waddr [ ( 3 * HQM_AQED_LL_CNT_PRI3_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI3_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri3_raddr =  func_aqed_ll_cnt_raddr [ ( 3 * HQM_AQED_LL_CNT_PRI3_DEPTHB2 ) +: HQM_AQED_LL_CNT_PRI3_DEPTHB2 ] ;
assign func_aqed_ll_cnt_pri3_wdata =  func_aqed_ll_cnt_wdata [ ( 3 * HQM_AQED_LL_CNT_PRI3_DWIDTH ) +: HQM_AQED_LL_CNT_PRI3_DWIDTH ] ;
assign  func_aqed_ll_cnt_rdata [ ( 3 * HQM_AQED_LL_CNT_PRI3_DWIDTH ) +: HQM_AQED_LL_CNT_PRI3_DWIDTH ] = func_aqed_ll_cnt_pri3_rdata ;






assign  func_aqed_ll_cnt_rdata [ ( 4 * HQM_AQED_LL_CNT_PRI4_DWIDTH ) +: HQM_AQED_LL_CNT_PRI4_DWIDTH ] = '0 ;






assign  func_aqed_ll_cnt_rdata [ ( 5 * HQM_AQED_LL_CNT_PRI5_DWIDTH ) +: HQM_AQED_LL_CNT_PRI5_DWIDTH ] = '0 ;






assign  func_aqed_ll_cnt_rdata [ ( 6 * HQM_AQED_LL_CNT_PRI6_DWIDTH ) +: HQM_AQED_LL_CNT_PRI6_DWIDTH ] = '0 ;






assign  func_aqed_ll_cnt_rdata [ ( 7 * HQM_AQED_LL_CNT_PRI7_DWIDTH ) +: HQM_AQED_LL_CNT_PRI7_DWIDTH ] = '0 ;


assign func_aqed_ll_qe_hp_pri0_we =  func_aqed_ll_qe_hp_we [ ( 0 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri0_re =  func_aqed_ll_qe_hp_re [ ( 0 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri0_waddr =  func_aqed_ll_qe_hp_waddr [ ( 0 * HQM_AQED_LL_QE_HP_PRI0_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI0_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri0_raddr =  func_aqed_ll_qe_hp_raddr [ ( 0 * HQM_AQED_LL_QE_HP_PRI0_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI0_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri0_wdata =  func_aqed_ll_qe_hp_wdata [ ( 0 * HQM_AQED_LL_QE_HP_PRI0_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI0_DWIDTH ] ;
assign  func_aqed_ll_qe_hp_rdata [ ( 0 * HQM_AQED_LL_QE_HP_PRI0_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI0_DWIDTH ] = func_aqed_ll_qe_hp_pri0_rdata ;

assign func_aqed_ll_qe_hp_pri1_we =  func_aqed_ll_qe_hp_we [ ( 1 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri1_re =  func_aqed_ll_qe_hp_re [ ( 1 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri1_waddr =  func_aqed_ll_qe_hp_waddr [ ( 1 * HQM_AQED_LL_QE_HP_PRI1_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI1_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri1_raddr =  func_aqed_ll_qe_hp_raddr [ ( 1 * HQM_AQED_LL_QE_HP_PRI1_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI1_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri1_wdata =  func_aqed_ll_qe_hp_wdata [ ( 1 * HQM_AQED_LL_QE_HP_PRI1_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI1_DWIDTH ] ;
assign  func_aqed_ll_qe_hp_rdata [ ( 1 * HQM_AQED_LL_QE_HP_PRI1_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI1_DWIDTH ] = func_aqed_ll_qe_hp_pri1_rdata ;

assign func_aqed_ll_qe_hp_pri2_we =  func_aqed_ll_qe_hp_we [ ( 2 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri2_re =  func_aqed_ll_qe_hp_re [ ( 2 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri2_waddr =  func_aqed_ll_qe_hp_waddr [ ( 2 * HQM_AQED_LL_QE_HP_PRI2_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI2_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri2_raddr =  func_aqed_ll_qe_hp_raddr [ ( 2 * HQM_AQED_LL_QE_HP_PRI2_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI2_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri2_wdata =  func_aqed_ll_qe_hp_wdata [ ( 2 * HQM_AQED_LL_QE_HP_PRI2_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI2_DWIDTH ] ;
assign  func_aqed_ll_qe_hp_rdata [ ( 2 * HQM_AQED_LL_QE_HP_PRI2_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI2_DWIDTH ] = func_aqed_ll_qe_hp_pri2_rdata ;

assign func_aqed_ll_qe_hp_pri3_we =  func_aqed_ll_qe_hp_we [ ( 3 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri3_re =  func_aqed_ll_qe_hp_re [ ( 3 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_hp_pri3_waddr =  func_aqed_ll_qe_hp_waddr [ ( 3 * HQM_AQED_LL_QE_HP_PRI3_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI3_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri3_raddr =  func_aqed_ll_qe_hp_raddr [ ( 3 * HQM_AQED_LL_QE_HP_PRI3_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_PRI3_DEPTHB2 ] ;
assign func_aqed_ll_qe_hp_pri3_wdata =  func_aqed_ll_qe_hp_wdata [ ( 3 * HQM_AQED_LL_QE_HP_PRI3_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI3_DWIDTH ] ;
assign  func_aqed_ll_qe_hp_rdata [ ( 3 * HQM_AQED_LL_QE_HP_PRI3_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI3_DWIDTH ] = func_aqed_ll_qe_hp_pri3_rdata ;






assign  func_aqed_ll_qe_hp_rdata [ ( 4 * HQM_AQED_LL_QE_HP_PRI4_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI4_DWIDTH ] = '0 ;






assign  func_aqed_ll_qe_hp_rdata [ ( 5 * HQM_AQED_LL_QE_HP_PRI5_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI5_DWIDTH ] = '0 ;






assign  func_aqed_ll_qe_hp_rdata [ ( 6 * HQM_AQED_LL_QE_HP_PRI6_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI6_DWIDTH ] = '0 ;






assign  func_aqed_ll_qe_hp_rdata [ ( 7 * HQM_AQED_LL_QE_HP_PRI7_DWIDTH ) +: HQM_AQED_LL_QE_HP_PRI7_DWIDTH ] = '0 ;

assign func_aqed_ll_qe_tp_pri0_we =  func_aqed_ll_qe_tp_we [ ( 0 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri0_re =  func_aqed_ll_qe_tp_re [ ( 0 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri0_waddr =  func_aqed_ll_qe_tp_waddr [ ( 0 * HQM_AQED_LL_QE_TP_PRI0_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI0_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri0_raddr =  func_aqed_ll_qe_tp_raddr [ ( 0 * HQM_AQED_LL_QE_TP_PRI0_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI0_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri0_wdata =  func_aqed_ll_qe_tp_wdata [ ( 0 * HQM_AQED_LL_QE_TP_PRI0_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI0_DWIDTH ] ;
assign  func_aqed_ll_qe_tp_rdata [ ( 0 * HQM_AQED_LL_QE_TP_PRI0_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI0_DWIDTH ] = func_aqed_ll_qe_tp_pri0_rdata ;

assign func_aqed_ll_qe_tp_pri1_we =  func_aqed_ll_qe_tp_we [ ( 1 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri1_re =  func_aqed_ll_qe_tp_re [ ( 1 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri1_waddr =  func_aqed_ll_qe_tp_waddr [ ( 1 * HQM_AQED_LL_QE_TP_PRI1_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI1_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri1_raddr =  func_aqed_ll_qe_tp_raddr [ ( 1 * HQM_AQED_LL_QE_TP_PRI1_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI1_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri1_wdata =  func_aqed_ll_qe_tp_wdata [ ( 1 * HQM_AQED_LL_QE_TP_PRI1_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI1_DWIDTH ] ;
assign  func_aqed_ll_qe_tp_rdata [ ( 1 * HQM_AQED_LL_QE_TP_PRI1_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI1_DWIDTH ] = func_aqed_ll_qe_tp_pri1_rdata ;

assign func_aqed_ll_qe_tp_pri2_we =  func_aqed_ll_qe_tp_we [ ( 2 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri2_re =  func_aqed_ll_qe_tp_re [ ( 2 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri2_waddr =  func_aqed_ll_qe_tp_waddr [ ( 2 * HQM_AQED_LL_QE_TP_PRI2_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI2_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri2_raddr =  func_aqed_ll_qe_tp_raddr [ ( 2 * HQM_AQED_LL_QE_TP_PRI2_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI2_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri2_wdata =  func_aqed_ll_qe_tp_wdata [ ( 2 * HQM_AQED_LL_QE_TP_PRI2_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI2_DWIDTH ] ;
assign  func_aqed_ll_qe_tp_rdata [ ( 2 * HQM_AQED_LL_QE_TP_PRI2_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI2_DWIDTH ] = func_aqed_ll_qe_tp_pri2_rdata ;

assign func_aqed_ll_qe_tp_pri3_we =  func_aqed_ll_qe_tp_we [ ( 3 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri3_re =  func_aqed_ll_qe_tp_re [ ( 3 * 1 ) +: 1 ] ;
assign func_aqed_ll_qe_tp_pri3_waddr =  func_aqed_ll_qe_tp_waddr [ ( 3 * HQM_AQED_LL_QE_TP_PRI3_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI3_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri3_raddr =  func_aqed_ll_qe_tp_raddr [ ( 3 * HQM_AQED_LL_QE_TP_PRI3_DEPTHB2 ) +: HQM_AQED_LL_QE_TP_PRI3_DEPTHB2 ] ;
assign func_aqed_ll_qe_tp_pri3_wdata =  func_aqed_ll_qe_tp_wdata [ ( 3 * HQM_AQED_LL_QE_TP_PRI3_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI3_DWIDTH ] ;
assign  func_aqed_ll_qe_tp_rdata [ ( 3 * HQM_AQED_LL_QE_TP_PRI3_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI3_DWIDTH ] = func_aqed_ll_qe_tp_pri3_rdata ;






assign  func_aqed_ll_qe_tp_rdata [ ( 4 * HQM_AQED_LL_QE_TP_PRI4_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI4_DWIDTH ] = '0 ;






assign  func_aqed_ll_qe_tp_rdata [ ( 5 * HQM_AQED_LL_QE_TP_PRI5_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI5_DWIDTH ] = '0 ;






assign  func_aqed_ll_qe_tp_rdata [ ( 6 * HQM_AQED_LL_QE_TP_PRI6_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI6_DWIDTH ] = '0 ;






assign  func_aqed_ll_qe_tp_rdata [ ( 7 * HQM_AQED_LL_QE_TP_PRI7_DWIDTH ) +: HQM_AQED_LL_QE_TP_PRI7_DWIDTH ] = '0 ;


//....................................................................................................
// MULTIFIFO 
logic ptr_mem_we ;
logic [ ( 28 ) - 1 : 0 ] ptr_mem_wdata ;
logic [ ( 28 ) - 1 : 0 ] ptr_mem_rdata ;
logic [ ( 28 ) - 1 : 0 ] ptr_mem_data_f2 , ptr_mem_data_f , ptr_mem_data_nxt ;
logic minmax_mem_we ;
logic [ ( 26 ) - 1 : 0 ] minmax_mem_wdata ;
logic [ ( 26 ) - 1 : 0 ] minmax_mem_rdata ;
logic [ ( 26 ) - 1 : 0 ] minmax_mem_data_f2 , minmax_mem_data_f , minmax_mem_data_nxt ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L2888
  if ( ! hqm_gated_rst_n ) begin
    ptr_mem_data_f <= 28'ha000000;     // { r=2 , 1 , 11'h000 } , { r=0 , 0 , 11'h000 }
    ptr_mem_data_f2 <= 28'ha000000;
    minmax_mem_data_f <= 26'h1ffe000 ; // { r=1 , 11'h7ff } , { r=0 , 11'h000 }
    minmax_mem_data_f2 <= 26'h1ffe000 ;
  end
  else begin
    ptr_mem_data_f <= ptr_mem_data_nxt ;
    ptr_mem_data_f2 <= ptr_mem_data_f ;
    minmax_mem_data_f <= minmax_mem_data_nxt ;
    minmax_mem_data_f2 <= minmax_mem_data_f ;
  end
end
assign ptr_mem_data_nxt = ptr_mem_we ? ptr_mem_wdata : ptr_mem_data_f ;
assign minmax_mem_data_nxt = minmax_mem_we ? minmax_mem_wdata : minmax_mem_data_f ;

assign ptr_mem_rdata = ptr_mem_data_f2 ;
assign minmax_mem_rdata = minmax_mem_data_f2 ;
logic [ ( HQM_AQED_MF_NFWIDTH ) - 1 : 0 ] wire_mf_fifo_num ;
assign wire_mf_fifo_num = '0 ;

logic  rf_aqed_freelist_ptr_re_nc ;
logic [ ( HQM_AQED_FREELIST_PTR_DEPTHB2 ) - 1 : 0 ] rf_aqed_freelist_ptr_raddr_nc ;
logic [ ( HQM_AQED_FREELIST_PTR_DEPTHB2 ) - 1 : 0 ] rf_aqed_freelist_ptr_waddr_nc ;
logic  rf_aqed_freelist_minmax_re_nc ;
logic [ ( HQM_AQED_FREELIST_MINMAX_DEPTHB2 ) - 1 : 0 ] rf_aqed_freelist_minmax_addr_nc ;






hqm_AW_multi_fifo # (
   .NUM_FIFOS                         ( HQM_AQED_MF_NUM_FIFOS )
 , .DEPTH                             ( HQM_AQED_MF_DEPTH )
 , .DWIDTH                            ( HQM_AQED_MF_DWIDTH )
) i_freelist (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .status                            ( mf_status )
 , .cmd_v                             ( mf_cmd_v )
 , .cmd                               ( mf_cmd )
 , .fifo_num                          ( wire_mf_fifo_num )
 , .push_data                         ( mf_push_data )
 , .push_offset                       ( '0 )
 , .pop_data                          ( mf_pop_data )
 , .pop_data_v                        ( mf_pop_data_v_nc )
 , .pop_data_last                     ( mf_pop_data_last_nc )
 , .p0_v_f                            ( mf_p0_v_f_nc )
 , .p0_hold                           ( mf_p0_hold )
 , .p1_v_f                            ( mf_p1_v_f_nc )
 , .p1_hold                           ( mf_p1_hold )
 , .p2_v_f                            ( mf_p2_v_f_nc )
 , .p2_hold                           ( mf_p2_hold )
 , .p3_v_f                            ( mf_p3_v_f_nc )
 , .p3_hold                           ( mf_p3_hold )
 , .err_rid                           ( mf_err_rid_nc )
 , .err_uflow                         ( mf_err_uflow )
 , .err_oflow                         ( mf_err_oflow )
 , .err_residue                       ( mf_err_residue )
 , .err_residue_cfg                   ( mf_err_residue_cfg )
 , .ptr_mem_re                        ( rf_aqed_freelist_ptr_re_nc )
 , .ptr_mem_raddr                     ( rf_aqed_freelist_ptr_raddr_nc )
 , .ptr_mem_we                        ( ptr_mem_we )
 , .ptr_mem_waddr                     ( rf_aqed_freelist_ptr_waddr_nc )
 , .ptr_mem_wdata                     ( ptr_mem_wdata )
 , .ptr_mem_rdata                     ( ptr_mem_rdata )
 , .minmax_mem_re                     ( rf_aqed_freelist_minmax_re_nc )
 , .minmax_mem_addr                   ( rf_aqed_freelist_minmax_addr_nc )
 , .minmax_mem_we                     ( minmax_mem_we )
 , .minmax_mem_wdata                  ( minmax_mem_wdata )
 , .minmax_mem_rdata                  ( minmax_mem_rdata )
 , .fifo_mem_re                       ( func_aqed_freelist_re )
 , .fifo_mem_addr                     ( func_aqed_freelist_addr )
 , .fifo_mem_we                       ( func_aqed_freelist_we )
 , .fifo_mem_wdata                    ( func_aqed_freelist_wdata )
 , .fifo_mem_rdata                    ( func_aqed_freelist_rdata )
) ;
//....................................................................................................
// CFG REGISTER

// General CONTROL

assign hqm_aqed_target_cfg_aqed_qid_hid_width_reg_load = 1'b0 ;
assign hqm_aqed_target_cfg_aqed_qid_hid_width_reg_nxt = hqm_aqed_target_cfg_aqed_qid_hid_width_reg_f ;

assign hqm_aqed_target_cfg_patch_control_reg_v   = 1'b0 ;
assign hqm_aqed_target_cfg_patch_control_reg_nxt = hqm_aqed_target_cfg_patch_control_reg_f ;

assign hqm_aqed_target_cfg_hw_agitate_select_reg_v   = 1'b0 ;
assign hqm_aqed_target_cfg_hw_agitate_select_reg_nxt = hqm_aqed_target_cfg_hw_agitate_select_reg_f ;



assign hqm_aqed_target_cfg_aqed_csr_control_reg_v   = 1'b0 ;
assign hqm_aqed_target_cfg_aqed_csr_control_reg_nxt = cfg_csr_control_nxt ;
assign cfg_csr_control_f = hqm_aqed_target_cfg_aqed_csr_control_reg_f ;

assign hqm_aqed_target_cfg_control_general_reg_v   = 1'b0 ;
assign hqm_aqed_target_cfg_control_general_reg_nxt = cfg_control0_nxt ;
assign cfg_control0_f = hqm_aqed_target_cfg_control_general_reg_f ;

assign hqm_aqed_target_cfg_detect_feature_operation_00_reg_nxt = cfg_control1_nxt ;
assign cfg_control1_f = hqm_aqed_target_cfg_detect_feature_operation_00_reg_f ;

assign hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_v   = 1'b0 ;
assign hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_nxt = cfg_control2_nxt ;
assign cfg_control2_f = hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_0_reg_f ;

assign hqm_aqed_target_cfg_control_arb_weights_tqpri_atm_1_status = 32'd0 ;
assign cfg_control3_f = 32'd0 ;

assign hqm_aqed_target_cfg_control_pipeline_credits_reg_nxt = cfg_control4_nxt ;
assign cfg_control4_f = hqm_aqed_target_cfg_control_pipeline_credits_reg_f ;

assign hqm_aqed_target_cfg_unit_idle_reg_nxt = cfg_unit_idle_nxt ;
assign cfg_unit_idle_f = hqm_aqed_target_cfg_unit_idle_reg_f ;

assign hqm_aqed_target_cfg_pipe_health_valid_reg_nxt = cfg_pipe_health_valid_nxt ;
assign cfg_pipe_health_valid_f_nc = hqm_aqed_target_cfg_pipe_health_valid_reg_f ;

assign hqm_aqed_target_cfg_pipe_health_hold_reg_nxt = cfg_pipe_health_hold_nxt ;
assign cfg_pipe_health_hold_f = hqm_aqed_target_cfg_pipe_health_hold_reg_f ;

assign hqm_aqed_target_cfg_interface_status_reg_nxt = cfg_interface_nxt ;
assign cfg_interface_f = hqm_aqed_target_cfg_interface_status_reg_f ;

assign hqm_aqed_target_cfg_error_inject_reg_nxt = cfg_error_inj_nxt ;
assign cfg_error_inj_f = hqm_aqed_target_cfg_error_inject_reg_f ;


//....................................................................................................
// CFG STATUS

assign hqm_aqed_target_cfg_diagnostic_aw_status_status = cfg_status0 ;

assign hqm_aqed_target_cfg_diagnostic_aw_status_01_status = cfg_status1 ;

assign hqm_aqed_target_cfg_diagnostic_aw_status_02_status = cfg_status2 ;



//------------------------------------------------------------------------------------------------------------------------------------------------
//counters 

//------------------------------------------------------------------------------------------------------------------------------------------------
// Functional
always_comb begin : L12
  //....................................................................................................
  // elastic FIFO storage

  parity_check_db_ap_aqed_p = '0 ;
  parity_check_db_ap_aqed_d = '0 ;
  parity_check_db_ap_aqed_e = '0 ;

  parity_check_db_ap_aqed_fid_p = '0 ;
  parity_check_db_ap_aqed_fid_d = '0 ;
  parity_check_db_ap_aqed_fid_e = '0 ;

  ecc_check_hcw_l_din_v = '0 ;
  ecc_check_hcw_l_din = '0 ;
  ecc_check_hcw_l_ecc = '0 ;
  ecc_check_hcw_l_enable = '0 ;
  ecc_check_hcw_l_correct = '0 ;

  ecc_check_hcw_h_din_v = '0 ;
  ecc_check_hcw_h_din = '0 ;
  ecc_check_hcw_h_ecc = '0 ;
  ecc_check_hcw_h_enable = '0 ;
  ecc_check_hcw_h_correct = '0 ;

  fifo_ap_aqed_push = '0 ;
  fifo_ap_aqed_push_data = '0 ;

  fifo_qed_aqed_enq_push = '0 ;
  fifo_qed_aqed_enq_push_data = '0 ;

  fifo_qed_aqed_enq_push_nxt = '0 ;
  fifo_qed_aqed_enq_push_data_nxt = fifo_qed_aqed_enq_push_data_f ;
  fifo_qed_aqed_enq_push_credits_nxt = fifo_qed_aqed_enq_push_credits_f ;
  complockid_in_qid = '0 ;
  complockid_in_lockid = '0 ;

  db_ap_aqed_ready = '0 ;
  rx_sync_qed_aqed_enq_ready = '0 ;

  //AP_AQED interface
  db_ap_aqed_ready 	                        = ~ ( fifo_ap_aqed_afull ) ;
  if ( db_ap_aqed_valid
     & db_ap_aqed_ready
     ) begin
    parity_check_db_ap_aqed_p                   = db_ap_aqed_data.parity ^ cfg_error_inj_f [ 2 ] ;
    parity_check_db_ap_aqed_d                   = { db_ap_aqed_data.cq
                                                  , db_ap_aqed_data.qid
                                                  , db_ap_aqed_data.qidix
                                                  } ;
    parity_check_db_ap_aqed_e                   = 1'b1 ;

    parity_check_db_ap_aqed_fid_p              = db_ap_aqed_data.flid_parity ;
    parity_check_db_ap_aqed_fid_d              = db_ap_aqed_data.flid ;
    parity_check_db_ap_aqed_fid_e              = 1'b1 ;

    fifo_ap_aqed_push                           = 1'b1 ;
    fifo_ap_aqed_push_data                      = db_ap_aqed_data ;
  end


  //QED_AQED interface
  rx_sync_qed_aqed_enq_ready                         = ( fifo_qed_aqed_enq_push_credits_f < ( cfg_control4_f [ 10 ] ? 3'd1 : 3'd4 ) ) & ~ fifo_qed_aqed_enq_afull_nc ;
  if ( rx_sync_qed_aqed_enq_valid
     & rx_sync_qed_aqed_enq_ready
     ) begin
    ecc_check_hcw_l_din_v                      = 1'b1 ;
    ecc_check_hcw_l_din                        = rx_sync_qed_aqed_enq_data.cq_hcw [ 63 : 0 ] ;
    ecc_check_hcw_l_ecc                        = rx_sync_qed_aqed_enq_data.cq_hcw_ecc [ 7 : 0 ] ;
    ecc_check_hcw_l_enable                     = 1'b1 ;
    ecc_check_hcw_l_correct                    = 1'b1 ;

    ecc_check_hcw_h_din_v                      = 1'b1 ;
    ecc_check_hcw_h_din                        = rx_sync_qed_aqed_enq_data.cq_hcw [ 122 : 64 ] ;
    ecc_check_hcw_h_ecc                        = rx_sync_qed_aqed_enq_data.cq_hcw_ecc [ 15 : 8 ] ;
    ecc_check_hcw_h_enable                     = 1'b1 ;
    ecc_check_hcw_h_correct                    = 1'b1 ;

    fifo_qed_aqed_enq_push_nxt                      = 1'b1 ;
    fifo_qed_aqed_enq_push_data_nxt.cq_hcw          = { ecc_check_hcw_h_dout , ecc_check_hcw_l_dout } ;
    fifo_qed_aqed_enq_push_data_nxt.cq_hcw_ecc      = { rx_sync_qed_aqed_enq_data.cq_hcw_ecc } ;

    fifo_qed_aqed_enq_push_credits_nxt              = fifo_qed_aqed_enq_push_credits_nxt + 3'b1 ;
  end
  if ( fifo_qed_aqed_enq_pop ) begin
    fifo_qed_aqed_enq_push_credits_nxt              = fifo_qed_aqed_enq_push_credits_nxt - 3'b1 ;
  end

  if ( fifo_qed_aqed_enq_push_f ) begin
    fifo_qed_aqed_enq_push                          = 1'b1 ;
    fifo_qed_aqed_enq_push_data.cq_hcw              = fifo_qed_aqed_enq_push_data_f.cq_hcw ;
    fifo_qed_aqed_enq_push_data.cq_hcw_ecc          =  fifo_qed_aqed_enq_push_data_f.cq_hcw_ecc ;

    complockid_in_qid                               = fifo_qed_aqed_enq_push_data_f.cq_hcw.msg_info.qid ;
    complockid_in_lockid                            = fifo_qed_aqed_enq_push_data_f.cq_hcw.lockid_dir_info_tokens.tokens ;
    fifo_qed_aqed_enq_push_data.newlockid = complockid_out_lockid ;
  end

end


always_comb begin : L14
  p10_stall_nxt = { 6 { ( p10_ll_v_nxt
                      & ( ( p11_ll_v_nxt & ( p11_ll_data_nxt.fid == p10_ll_data_nxt.fid ) )
                        | ( p12_ll_v_nxt & ( p12_ll_data_nxt.fid == p10_ll_data_nxt.fid ) )
                        )
                      )
                  } } ;
end


always_comb begin : L15
  cfg_error_inj_nxt = cfg_error_inj_f ;
  //....................................................................................................
  // p0 ll pipeline
  //  fl-0
  p0_ll_ctrl = '0 ;
  p0_ll_v_nxt = '0 ;
  p0_ll_data_nxt = p0_ll_data_f ;

  mf_p0_hold = '0 ;

  fifo_ap_aqed_pop = '0 ;
  fifo_qed_aqed_enq_fid_pop = '0 ;
  fifo_qed_aqed_enq_fid_dec = '0 ;
  fifo_aqed_ap_enq_inc  = '0 ;
  fifo_aqed_chp_sch_inc = '0 ;
  fifo_freelist_return_inc = '0 ;
  fifo_freelist_return_dec = '0 ;

  mf_cmd_v = '0 ;
  mf_cmd = HQM_AW_MF_NOOP ;
  mf_fifo_num_nc = '0 ;
  mf_push_data = '0 ;

  arb_ll_reqs = '0 ;
  arb_ll_update = '0 ;

  parity_gen_aqed_ap_d = '0 ;
  parity_gen_fid_d = '0 ;

  fifo_freelist_return_pop = '0 ;

  db_aqed_lsp_sch_valid = '0 ;
  db_aqed_lsp_sch_data = '0 ;

parity_check_p = '0 ;
parity_check_d = '0 ;
parity_check_e = '0 ;

  p0_ll_ctrl.hold                               = ( p0_ll_v_f & p1_ll_ctrl.hold ) ;
  p0_ll_ctrl.enable                             = ( arb_ll_winner_v ) ;
  mf_p0_hold                                   = p0_ll_ctrl.hold ;


  arb_ll_reqs [ 0 ]                                = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_ll_ctrl.hold )
                                                  & ( ~ fifo_qed_aqed_enq_fid_empty )
                                                  & ( fifo_aqed_ap_enq_cnt_f < cfg_control4_f [ 4 : 0 ] )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_SIM ] ? ( ~ ( | cfg_pipe_health_valid_f_nc [ 13 : 0 ] ) ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_50 ] ? ( ~ p0_ll_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_33 ] ? ( ~ p0_ll_v_f & ~ p1_ll_v_f ) : 1'b1 )
                                                  ) ;
  arb_ll_reqs [ 1 ]                                = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_ll_ctrl.hold )
                                                  & ( ~ fifo_ap_aqed_empty )
                                                  & ( fifo_aqed_chp_sch_cnt_f < cfg_control4_f [ 9 : 5 ] )
                                                  & ( fifo_freelist_return_cnt_f < cfg_control4_f [ 9 : 5 ] )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_SIM ] ? ( ~ ( | cfg_pipe_health_valid_f_nc [ 13 : 0 ] ) ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_50 ] ? ( ~ p0_ll_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_33 ] ? ( ~ p0_ll_v_f & ~ p1_ll_v_f ) : 1'b1 )
                                                  ) ;
  arb_ll_reqs [ 2 ]                                = ( ( ~ p0_ll_ctrl.hold )
                                                  & db_aqed_lsp_sch_ready
                                                  & ( ~ fifo_freelist_return_empty )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_SIM ] ? ( ~ ( | cfg_pipe_health_valid_f_nc [ 13 : 0 ] ) ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_50 ] ? ( ~ p0_ll_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_AQED_CHICKEN_33 ] ? ( ~ p0_ll_v_f & ~ p1_ll_v_f ) : 1'b1 )
                                                  ) ;

ecc_gen_d = '0 ;


  if ( p0_ll_ctrl.enable | p0_ll_ctrl.hold ) begin
    p0_ll_v_nxt                                = 1'b1 ;
  end
  if ( p0_ll_ctrl.enable ) begin

    if ( ( arb_ll_winner_v  ) & ( arb_ll_winner == 2'd0 ) ) begin
      arb_ll_update = 1'b1 ;
      fifo_aqed_ap_enq_inc                     = 1'b1 ;

      p0_ll_data_nxt.cmd                       = HQM_AQED_CMD_ENQ ;
      p0_ll_data_nxt.pcm                       = 1'b0 ;
      p0_ll_data_nxt.cq                        = '0 ;
      p0_ll_data_nxt.qid                       = fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw.msg_info.qid ;
      p0_ll_data_nxt.qidix                     = '0 ;
      parity_gen_aqed_ap_d                     = { fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw.msg_info.qid , fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw.msg_info.qpri } ;
      p0_ll_data_nxt.parity                    = parity_gen_aqed_ap_p ^ cfg_error_inj_f [ 3 ] ^ fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw.msg_info.qpri [ 0 ] ;
      p0_ll_data_nxt.qpri                      = { 1'b0 , fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw.msg_info.qpri [ 2 : 1 ] } ;
if ( cfg_control0_f [ HQM_AQED_CHICKEN_ONEPRI ] ) begin
      parity_gen_aqed_ap_d                     = { fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw.msg_info.qid , 3'd0 } ;
      p0_ll_data_nxt.parity                    = parity_gen_aqed_ap_p ;
      p0_ll_data_nxt.qpri                      = '0 ;
end
      p0_ll_data_nxt.empty                     = '0 ;
      p0_ll_data_nxt.hp                        = '0 ;
      p0_ll_data_nxt.tp                        = '0 ;
      p0_ll_data_nxt.fid                       = { 1'b0 , fifo_qed_aqed_enq_fid_pop_data_pnc.fid } ;
      parity_gen_fid_d                         = { 1'b0 , fifo_qed_aqed_enq_fid_pop_data_pnc.fid } ;
      p0_ll_data_nxt.fid_parity                = parity_gen_fid_p ;
      p0_ll_data_nxt.hp_parity                 = '0 ;
      p0_ll_data_nxt.tp_parity                 = '0 ;
      p0_ll_data_nxt.error                     = '0 ;
      p0_ll_data_nxt.freelist_push                  = '0 ;
      p0_ll_data_nxt.cq_hcw                    = fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw ;
      p0_ll_data_nxt.cq_hcw_ecc                = fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw_ecc ;
      p0_ll_data_nxt.hqm_core_flags            = '0 ;

      p0_ll_data_nxt.new_flid                   = 11'd0 ;
      p0_ll_data_nxt.new_flid_parity            = 1'b1 ;
      p0_ll_data_nxt.new_flid_ecc               = 5'h0c ;

      mf_cmd_v                                 = 1'b1 ;
      mf_cmd                                   = HQM_AW_MF_POP ;
      mf_fifo_num_nc                              = fifo_qed_aqed_enq_fid_pop_data_pnc.cq_hcw.msg_info.qid ;
      mf_push_data                             = '0 ;

      fifo_qed_aqed_enq_fid_pop                    = 1'b1 ;
      fifo_qed_aqed_enq_fid_dec                    = 1'b1 ;
    end

    if ( ( arb_ll_winner_v  ) & ( arb_ll_winner == 2'd1 ) ) begin
      arb_ll_update = 1'b1 ;
      fifo_aqed_chp_sch_inc                    = 1'b1 ;
      fifo_freelist_return_inc                 = 1'b1 ;

      p0_ll_data_nxt.cmd                       = HQM_AQED_CMD_DEQ ;
      p0_ll_data_nxt.pcm                       = fifo_ap_aqed_pop_data_pnc.pcm ;
      p0_ll_data_nxt.cq                        = fifo_ap_aqed_pop_data_pnc.cq ;
      p0_ll_data_nxt.qid                       = fifo_ap_aqed_pop_data_pnc.qid [ 6 : 0 ] ;
      p0_ll_data_nxt.qidix                     = fifo_ap_aqed_pop_data_pnc.qidix ;
      p0_ll_data_nxt.parity                    = fifo_ap_aqed_pop_data_pnc.parity ^ cfg_error_inj_f [ 4 ] ;
      p0_ll_data_nxt.qpri                      = { 1'b0 , fifo_ap_aqed_pop_data_pnc.bin } ;
      p0_ll_data_nxt.empty                     = '0 ;
      p0_ll_data_nxt.hp                        = '0 ;
      p0_ll_data_nxt.tp                        = '0 ;
      p0_ll_data_nxt.fid                       = fifo_ap_aqed_pop_data_pnc.flid ;
      p0_ll_data_nxt.fid_parity                = fifo_ap_aqed_pop_data_pnc.flid_parity ;
      p0_ll_data_nxt.hp_parity                 = '0 ;
      p0_ll_data_nxt.tp_parity                 = '0 ;
      p0_ll_data_nxt.error                     = '0 ;
      p0_ll_data_nxt.freelist_push                  = '0 ;
      p0_ll_data_nxt.cq_hcw                    = '0 ;
      p0_ll_data_nxt.cq_hcw_ecc                = '0 ;
      p0_ll_data_nxt.hqm_core_flags            = fifo_ap_aqed_pop_data_pnc.hqm_core_flags ;

      p0_ll_data_nxt.new_flid                   = 11'd0 ;
      p0_ll_data_nxt.new_flid_parity            = 1'b1 ;
      p0_ll_data_nxt.new_flid_ecc               = 5'h0c ;

      fifo_ap_aqed_pop                         = 1'b1 ;

      if ( db_aqed_lsp_sch_ready
         & ( ~ fifo_freelist_return_empty )
         )  begin

        p0_ll_data_nxt.freelist_push                  = 1'b1 ;

        fifo_freelist_return_pop                 = 1'b1 ;
        fifo_freelist_return_dec                 = 1'b1 ;

        mf_cmd_v                                 = ~ parity_check_error ;
        mf_cmd                                   = HQM_AW_MF_PUSH ;
        mf_fifo_num_nc                              = fifo_freelist_return_pop_data_pnc.qid ;
        mf_push_data                             = { ecc_gen_ecc , fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] } ;
ecc_gen_d = fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] ;
parity_check_p = fifo_freelist_return_pop_data_pnc.hp_parity ^ cfg_error_inj_f[0];
parity_check_d = fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] ;
parity_check_e = 1'b1 ;  cfg_error_inj_nxt[0] = 1'b0 ;


    db_aqed_lsp_sch_valid                       = ~ parity_check_error ;
    db_aqed_lsp_sch_data.cq                     = fifo_freelist_return_pop_data_pnc.cq ;
    db_aqed_lsp_sch_data.qid                    = fifo_freelist_return_pop_data_pnc.qid ;
    db_aqed_lsp_sch_data.qidix                  = fifo_freelist_return_pop_data_pnc.qidix ;
    db_aqed_lsp_sch_data.parity                 = fifo_freelist_return_pop_data_pnc.parity ;
    db_aqed_lsp_sch_data.flid                   = { 4'd0 , fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] } ;
    db_aqed_lsp_sch_data.flid_parity            = fifo_freelist_return_pop_data_pnc.hp_parity ;

      end
      else begin
        mf_cmd_v                                 = 1'b1 ;
        mf_cmd                                   = HQM_AW_MF_NOOP ;
        mf_fifo_num_nc                              = '0 ;
        mf_push_data                             = '0 ;
      end
    end

    if ( ( arb_ll_winner_v  ) & ( arb_ll_winner == 2'd2 ) ) begin
      arb_ll_update = 1'b1 ;

      p0_ll_data_nxt.cmd                       = HQM_AQED_CMD_NOOP ;
      p0_ll_data_nxt.freelist_push                  = 1'b1 ;

      fifo_freelist_return_pop                 = 1'b1 ;
      fifo_freelist_return_dec                 = 1'b1 ;

      mf_cmd_v                                 = ~ parity_check_error ;
      mf_cmd                                   = HQM_AW_MF_PUSH ;
      mf_fifo_num_nc                              = fifo_freelist_return_pop_data_pnc.qid ;
      mf_push_data                             = { ecc_gen_ecc , fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] } ;
ecc_gen_d = fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] ;
parity_check_p = fifo_freelist_return_pop_data_pnc.hp_parity ^ cfg_error_inj_f[1];
parity_check_d = fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] ;
parity_check_e = 1'b1 ; cfg_error_inj_nxt[1] = 1'b0 ;

    db_aqed_lsp_sch_valid                       = ~ parity_check_error ;
    db_aqed_lsp_sch_data.cq                     = fifo_freelist_return_pop_data_pnc.cq ;
    db_aqed_lsp_sch_data.qid                    = fifo_freelist_return_pop_data_pnc.qid ;
    db_aqed_lsp_sch_data.qidix                  = fifo_freelist_return_pop_data_pnc.qidix ;
    db_aqed_lsp_sch_data.parity                 = fifo_freelist_return_pop_data_pnc.parity ;
    db_aqed_lsp_sch_data.flid                   = { 4'd0 , fifo_freelist_return_pop_data_pnc.hp [ 10 : 0 ] } ;
    db_aqed_lsp_sch_data.flid_parity            = fifo_freelist_return_pop_data_pnc.hp_parity ;

    end

  end
end

always_comb begin : L16
  //....................................................................................................
  // p1 ll pipeline
  //  fl-1
  p1_ll_ctrl = '0 ;
  p1_ll_v_nxt = '0 ;
  p1_ll_data_nxt = p1_ll_data_f ;

  mf_p1_hold = '0 ;

  p1_ll_ctrl.hold                               = ( p1_ll_v_f & p2_ll_ctrl.hold ) ;
  p1_ll_ctrl.enable                             = ( p0_ll_v_f & ~ p1_ll_ctrl.hold ) ;
  mf_p1_hold                                   = p1_ll_ctrl.hold ;
  if ( p1_ll_ctrl.enable | p1_ll_ctrl.hold ) begin
    p1_ll_v_nxt                                = 1'b1 ;
  end
  if ( p1_ll_ctrl.enable ) begin
    p1_ll_data_nxt                             = p0_ll_data_f ;
  end

end

always_comb begin : L17
  //....................................................................................................
  // p2 ll pipeline
  //  fl-2
  p2_ll_ctrl = '0 ;
  p2_ll_v_nxt = '0 ;
  p2_ll_data_nxt = p2_ll_data_f ;

  mf_p2_hold = '0 ;

  p2_ll_ctrl.hold                               = ( p2_ll_v_f & p3_ll_ctrl.hold ) ;
  p2_ll_ctrl.enable                             = ( p1_ll_v_f & ~ p2_ll_ctrl.hold ) ;

  if ( p2_ll_ctrl.enable | p2_ll_ctrl.hold ) begin
    p2_ll_v_nxt                                = 1'b1 ;
  end
  if ( p2_ll_ctrl.enable ) begin
    p2_ll_data_nxt                             = p1_ll_data_f ;
  end

  mf_p2_hold                                   = p2_ll_ctrl.hold ;
end

always_comb begin : L18
  //....................................................................................................
  // p3 ll pipeline
  //  fl-3
  p3_ll_ctrl = '0 ;
  p3_ll_v_nxt = '0 ;
  p3_ll_data_nxt = p3_ll_data_f ;

  mf_p3_hold = '0 ;

  p3_ll_ctrl.hold                               = ( p3_ll_v_f & ( p4_ll_ctrl.hold ) ) ;
  p3_ll_ctrl.enable                             = ( p2_ll_v_f & ~ p3_ll_ctrl.hold ) ;

  if ( p3_ll_ctrl.enable | p3_ll_ctrl.hold ) begin
    p3_ll_v_nxt                                = 1'b1 ;
  end
  if ( p3_ll_ctrl.enable ) begin
    p3_ll_data_nxt                             = p2_ll_data_f ;
  end

  mf_p3_hold                                   = p3_ll_ctrl.hold ;

end

always_comb begin : L19
  //....................................................................................................
  // p4 ll pipeline
  //  counter-0
  p4_ll_ctrl = '0 ;
  p4_ll_v_nxt = '0 ;
  p4_ll_data_nxt = p4_ll_data_f ;

  rmw_ll_cnt_p0_v_nxt = '0 ;
  rmw_ll_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_ll_cnt_p0_addr_nxt = '0 ;
  rmw_ll_cnt_p0_write_data_nxt = '0 ;
  rmw_ll_cnt_p0_hold = '0 ;


  p4_ll_ctrl.hold                               = ( p4_ll_v_f & p5_ll_ctrl.hold ) ;
  p4_ll_ctrl.enable                             = ( p3_ll_v_f & ~ ( p3_ll_data_f.cmd == HQM_AQED_CMD_NOOP ) & ~ p4_ll_ctrl.hold ) ;
  rmw_ll_cnt_p0_hold                            = { HQM_AQED_NUM_PRI { p4_ll_ctrl.hold } } ;
  if ( p4_ll_ctrl.enable | p4_ll_ctrl.hold ) begin
    p4_ll_v_nxt                                 = 1'b1 ;
  end
  if ( p4_ll_ctrl.enable ) begin
    p4_ll_data_nxt                              = p3_ll_data_f ;

    for ( int i = 0 ; i < HQM_AQED_NUM_PRI ; i = i + 1 ) begin
      rmw_ll_cnt_p0_v_nxt [ i ]                    = { 1'b1 } ;
      rmw_ll_cnt_p0_rw_nxt                      = HQM_AW_RMWPIPE_RMW ;
      rmw_ll_cnt_p0_addr_nxt [ ( i * HQM_AQED_LL_CNT_DEPTHB2 ) +: HQM_AQED_LL_CNT_DEPTHB2 ] = { p4_ll_data_nxt.fid } ;
      rmw_ll_cnt_p0_write_data_nxt [ ( i * HQM_AQED_LL_CNT_DWIDTH ) +: HQM_AQED_LL_CNT_DWIDTH ] = '0 ;
    end

    if ( p4_ll_data_nxt.cmd == HQM_AQED_CMD_ENQ ) begin
      p4_ll_data_nxt.new_flid                   = mf_pop_data [ ( HQM_AQED_DATA ) - 1 : 0 ] ;
      p4_ll_data_nxt.new_flid_parity            = 1'b0 ;
      p4_ll_data_nxt.new_flid_ecc               = mf_pop_data [ ( HQM_AQED_DATA + HQM_AQED_ECC ) - 1 : HQM_AQED_DATA ] ;
    end

  end
end

always_comb begin : L20
  //....................................................................................................
  // p5 ll pipeline
  //  counter-1
  p5_ll_ctrl = '0 ;
  p5_ll_v_nxt = '0 ;
  p5_ll_data_nxt = p5_ll_data_f ;

  rmw_ll_cnt_p1_hold = '0 ;

ecc_check_dinv_v = '0 ;
ecc_check_din = p4_ll_data_f.new_flid ;
ecc_check_ecc = p4_ll_data_f.new_flid_ecc ;
parity_gen_d = ecc_check_dout ;

  p5_ll_ctrl.hold                               = ( p5_ll_v_f & p6_ll_ctrl.hold ) ;
  p5_ll_ctrl.enable                             = ( p4_ll_v_f & ~ p5_ll_ctrl.hold ) ;
  rmw_ll_cnt_p1_hold                           = { HQM_AQED_NUM_PRI { p5_ll_ctrl.hold } } ;
  if ( p5_ll_ctrl.enable | p5_ll_ctrl.hold ) begin
    p5_ll_v_nxt                                = 1'b1 ;
  end
  if ( p5_ll_ctrl.enable ) begin
    p5_ll_data_nxt                             = p4_ll_data_f ;

    if ( p5_ll_data_nxt.cmd == HQM_AQED_CMD_ENQ ) begin
ecc_check_dinv_v = 1'b1 ;
    end

p5_ll_data_nxt.new_flid = ecc_check_dout ;
p5_ll_data_nxt.new_flid_parity = parity_gen_p ;
  end

end

always_comb begin : L30
  //....................................................................................................
  // p6 ll pipeline
  //  counter-2
  p6_ll_ctrl = '0 ;
  p6_ll_v_nxt = '0 ;
  p6_ll_data_nxt = p6_ll_data_f ;

  rmw_ll_cnt_p2_hold = '0 ;

  p6_ll_ctrl.hold                               = ( p6_ll_v_f & p7_ll_ctrl.hold ) ;
  p6_ll_ctrl.enable                             = ( p5_ll_v_f & ~ p6_ll_ctrl.hold ) ;
  rmw_ll_cnt_p2_hold                           = { HQM_AQED_NUM_PRI { p6_ll_ctrl.hold } } ;
  if ( p6_ll_ctrl.enable | p6_ll_ctrl.hold ) begin
    p6_ll_v_nxt                                = 1'b1 ;
  end
  if ( p6_ll_ctrl.enable ) begin
    p6_ll_data_nxt                             = p5_ll_data_f ;
  end

end

always_comb begin : L31
  //....................................................................................................
  // p7 ll pipeline
  //  ll-0

  p7_ll_ctrl = '0 ;
  p7_ll_v_nxt = '0 ;
  p7_ll_data_nxt = p7_ll_data_f ;

  rmw_ll_cnt_p3_hold = '0 ;

  rmw_ll_hp_p0_hold = '0 ;
  rmw_ll_tp_p0_hold = '0 ;

  residue_add_ll_cnt_a = '0 ;
  residue_add_ll_cnt_b = '0 ;
  residue_sub_ll_cnt_a = '0 ;
  residue_sub_ll_cnt_b = '0 ;
  residue_check_ll_cnt_r_nxt = residue_check_ll_cnt_r_f ;
  residue_check_ll_cnt_d_nxt = residue_check_ll_cnt_d_f ;
  residue_check_ll_cnt_e_nxt = '0 ;

  rmw_ll_cnt_p3_bypsel_nxt = '0 ;
  rmw_ll_cnt_p3_bypaddr_nxt = '0 ;
  rmw_ll_cnt_p3_bypaddr_nxt               = rmw_ll_cnt_p2_addr_f ;
  rmw_ll_cnt_p3_bypdata_cnt_nnc = '0 ;
  rmw_ll_cnt_p3_bypdata_nxt = '0 ;

  rmw_ll_hp_p0_v_nxt = '0 ;
  rmw_ll_hp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_ll_hp_p0_addr_nxt = '0 ;
  rmw_ll_hp_p0_write_data_nxt = '0 ;

  rmw_ll_tp_p0_v_nxt = '0 ;
  rmw_ll_tp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_ll_tp_p0_addr_nxt = '0 ;
  rmw_ll_tp_p0_write_data_nxt = '0 ;

  arb_ll_cnt_reqs = '0 ;

  error_ll_nopri = '0 ;
  error_ll_of = '0 ;

  p7_ll_ctrl.hold                               = ( p7_ll_v_f & p8_ll_ctrl.hold ) ;
  p7_ll_ctrl.enable                             = ( p6_ll_v_f & ~ p7_ll_ctrl.hold ) ;
  rmw_ll_hp_p0_hold                            = { HQM_AQED_NUM_PRI { p7_ll_ctrl.hold } } ;
  rmw_ll_tp_p0_hold                            = { HQM_AQED_NUM_PRI { p7_ll_ctrl.hold } } ;
  if ( p7_ll_ctrl.enable | p7_ll_ctrl.hold ) begin
    p7_ll_v_nxt                                 = 1'b1 ;
  end



if ( p6_ll_data_f.qpri == 3'd0 ) begin
        arb_ll_cnt_reqs                         = { 7'd0 , ( | rmw_ll_cnt_p2_data_f [ ( 0 * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] )        } ;
end
if ( p6_ll_data_f.qpri == 3'd1 ) begin
        arb_ll_cnt_reqs                         = { 6'd0 , ( | rmw_ll_cnt_p2_data_f [ ( 1 * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] ) , 1'd0 } ;
end
if ( p6_ll_data_f.qpri == 3'd2 ) begin
        arb_ll_cnt_reqs                         = { 5'd0 , ( | rmw_ll_cnt_p2_data_f [ ( 2 * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] ) , 2'd0 } ;
end
if ( p6_ll_data_f.qpri == 3'd3 ) begin
        arb_ll_cnt_reqs                         = { 4'd0 , ( | rmw_ll_cnt_p2_data_f [ ( 3 * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] ) , 3'd0 } ;
end
if ( cfg_control0_f [ HQM_AQED_CHICKEN_ALLPRI ]  ) begin
      for ( int i = 0 ; i < HQM_AQED_NUM_PRI ; i = i + 1 ) begin
        arb_ll_cnt_reqs [ i ]                      = ( | rmw_ll_cnt_p2_data_f [ ( i * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] ) ;
      end
end



  if ( p7_ll_ctrl.enable ) begin
    p7_ll_data_nxt                              = p6_ll_data_f ;

    //.........................
    if ( p7_ll_data_nxt.cmd == HQM_AQED_CMD_ENQ ) begin

      if ( rmw_ll_cnt_p2_data_f [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] == { HQM_AQED_CNTB2 { 1'b1 } } ) begin 
        error_ll_of                             = 1'b1 ;
        p7_ll_data_nxt.error                    = 1'b1 ;
      end
      else begin
        residue_check_ll_cnt_r_nxt              = rmw_ll_cnt_p2_data_f [ ( ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) + HQM_AQED_CNTB2 ) +: 2 ] ; 
        residue_check_ll_cnt_d_nxt              = rmw_ll_cnt_p2_data_f [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] ; 
        residue_check_ll_cnt_e_nxt              = 1'b1 ;

        residue_add_ll_cnt_a                    = rmw_ll_cnt_p2_data_f [ ( ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) + HQM_AQED_CNTB2 ) +: 2 ] ; 
        residue_add_ll_cnt_b                    = 2'd1 ;

        rmw_ll_cnt_p3_bypsel_nxt [ p7_ll_data_nxt.qpri ] = 1'b1 ;

        rmw_ll_cnt_p3_bypdata_cnt_nnc               = rmw_ll_cnt_p2_data_f [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] + { { ( HQM_AQED_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 
        rmw_ll_cnt_p3_bypdata_nxt [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2WR ] 
                                                = { residue_add_ll_cnt_r
                                                  , rmw_ll_cnt_p3_bypdata_cnt_nnc
                                                  } ;
        p7_ll_data_nxt.empty                    = ( rmw_ll_cnt_p2_data_f [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] == { { ( HQM_AQED_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ; 
      end
    end

    //.........................
    if ( p7_ll_data_nxt.cmd == HQM_AQED_CMD_DEQ ) begin



      if ( ~ arb_ll_cnt_winner_v ) begin
        error_ll_nopri                          = 1'b1 ;
        p7_ll_data_nxt.error                    = 1'b1 ;
      end
      else begin
//need to use p6_ll_data_f.qpri for the source pritority used to 
        p7_ll_data_nxt.qpri                     = arb_ll_cnt_winner ;

        residue_check_ll_cnt_r_nxt              = rmw_ll_cnt_p2_data_f [ ( ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) + HQM_AQED_CNTB2 ) +: 2 ] ; 
        residue_check_ll_cnt_d_nxt              = rmw_ll_cnt_p2_data_f [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] ; 
        residue_check_ll_cnt_e_nxt              = 1'b1 ;

        residue_sub_ll_cnt_a                    = 2'd1 ;
        residue_sub_ll_cnt_b                    = rmw_ll_cnt_p2_data_f [ ( ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) + HQM_AQED_CNTB2 ) +: 2 ] ; 

        rmw_ll_cnt_p3_bypsel_nxt [ p7_ll_data_nxt.qpri ] = 1'b1 ;

        rmw_ll_cnt_p3_bypdata_cnt_nnc               = rmw_ll_cnt_p2_data_f [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] - { { ( HQM_AQED_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 
        rmw_ll_cnt_p3_bypdata_nxt [ (  p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2WR ] 
                                                = { residue_sub_ll_cnt_r
                                                  , rmw_ll_cnt_p3_bypdata_cnt_nnc
                                                  } ;
        p7_ll_data_nxt.empty                    = ( rmw_ll_cnt_p2_data_f [ ( p7_ll_data_nxt.qpri * HQM_AQED_CNTB2WR ) +: HQM_AQED_CNTB2 ] == { { ( HQM_AQED_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ) ; 
      end
    end

   if ( p7_ll_data_nxt.cmd != HQM_AQED_CMD_NOOP ) begin
      rmw_ll_hp_p0_v_nxt                        = { HQM_AQED_NUM_PRI { 1'b1 } } ;
      rmw_ll_hp_p0_rw_nxt                       = HQM_AW_RMWPIPE_RMW ;
      rmw_ll_hp_p0_addr_nxt                     = { HQM_AQED_NUM_PRI { p7_ll_data_nxt.fid } } ;

      rmw_ll_tp_p0_v_nxt                        = { HQM_AQED_NUM_PRI { 1'b1 } } ;
      rmw_ll_tp_p0_rw_nxt                       = HQM_AW_RMWPIPE_RMW ;
      rmw_ll_tp_p0_addr_nxt                     = { HQM_AQED_NUM_PRI { p7_ll_data_nxt.fid } } ;
    end
  end

end

always_comb begin : L21
  //....................................................................................................
  // p8 ll pipeline
  //  ll-1
  p8_ll_ctrl = '0 ;
  p8_ll_v_nxt = '0 ;
  p8_ll_data_nxt = p8_ll_data_f ;

  rmw_ll_hp_p1_hold = '0 ;
  rmw_ll_tp_p1_hold = '0 ;

  p8_ll_ctrl.hold                               = ( p8_ll_v_f & p9_ll_ctrl.hold ) ;
  p8_ll_ctrl.enable                             = ( p7_ll_v_f & ~ p8_ll_ctrl.hold ) ;
  rmw_ll_hp_p1_hold                            = { HQM_AQED_NUM_PRI { p8_ll_ctrl.hold } } ;
  rmw_ll_tp_p1_hold                            = { HQM_AQED_NUM_PRI { p8_ll_ctrl.hold } } ;
  if ( p8_ll_ctrl.enable | p8_ll_ctrl.hold ) begin
    p8_ll_v_nxt                                = 1'b1 ;
  end
  if ( p8_ll_ctrl.enable ) begin
    p8_ll_data_nxt                             = p7_ll_data_f ;
  end

end

always_comb begin : L22
  //....................................................................................................
  // p9 ll pipeline
  //  ll-2
  p9_ll_ctrl = '0 ;
  p9_ll_v_nxt = '0 ;
  p9_ll_data_nxt = p9_ll_data_f ;

  rmw_ll_hp_p2_hold = '0 ;
  rmw_ll_tp_p2_hold = '0 ;

  p9_ll_ctrl.hold                               = ( p9_ll_v_f & ( p10_ll_ctrl.hold
                                                  ) ) ;
  p9_ll_ctrl.enable                             = ( p8_ll_v_f & ~ p9_ll_ctrl.hold ) ;
  p9_ll_ctrl.bypsel                             = '0 ;

  rmw_ll_hp_p2_hold                             = { HQM_AQED_NUM_PRI { p9_ll_ctrl.hold } } ;
  rmw_ll_tp_p2_hold                             = { HQM_AQED_NUM_PRI { p9_ll_ctrl.hold } } ;
  if ( p9_ll_ctrl.enable | p9_ll_ctrl.hold ) begin
    p9_ll_v_nxt                                 = 1'b1 ;
  end
  if ( p9_ll_ctrl.enable ) begin
    p9_ll_data_nxt                              = p8_ll_data_f ;
  end

end

always_comb begin : L23
  //....................................................................................................
  // p10 ll pipeline
  //  nxt-0
  p10_ll_ctrl = '0 ;
  p10_ll_v_nxt = '0 ;
  p10_ll_data_nxt = p10_ll_data_f ;

  rw_ll_qe_hpnxt_p0_v_nxt = '0 ;
  rw_ll_qe_hpnxt_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_ll_qe_hpnxt_p0_addr_nxt = '0 ;
  rw_ll_qe_hpnxt_p0_write_data_nxt = '0 ;

  rw_ll_qe_hpnxt_p0_byp_v_nxt = '0 ;
  rw_ll_qe_hpnxt_p0_byp_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_ll_qe_hpnxt_p0_byp_addr_nxt = '0 ;
  rw_ll_qe_hpnxt_p0_byp_write_data_nxt = '0 ;

  rw_aqed_p0_v_nxt = '0 ;
  rw_aqed_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_aqed_p0_addr_nxt = '0 ;
  rw_aqed_p0_write_data_nxt = '0 ;

  rw_aqed_p0_byp_v_nxt = '0 ;
  rw_aqed_p0_byp_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_aqed_p0_byp_addr_nxt = '0 ;
  rw_aqed_p0_byp_write_data_nxt_nc = '0 ;

  rmw_ll_hp_p3_hold = '0 ;
  rmw_ll_tp_p3_hold = '0 ;

  parity_check_ll_rmw_hp_p2_p = '0 ;
  parity_check_ll_rmw_hp_p2_d = '0 ;
  parity_check_ll_rmw_hp_p2_e = '0 ;
  parity_check_ll_rmw_tp_p2_p = '0 ;
  parity_check_ll_rmw_tp_p2_d = '0 ;
  parity_check_ll_rmw_tp_p2_e = '0 ;

  rw_ll_qe_hpnxt_p0_hold = '0 ;
  rw_aqed_p0_hold = '0 ;

  p10_stall_nc = ( p10_ll_v_f
          & ( ( p11_ll_v_f & ( p11_ll_data_f.fid == p10_ll_data_f.fid ) )
            | ( p12_ll_v_f & ( p12_ll_data_f.fid == p10_ll_data_f.fid ) )
            )
          ) ;

  p10_ll_ctrl.hold                              = ( p10_ll_v_f & ( p11_ll_ctrl.hold | p10_stall_f [ 2 ] ) ) ;
  p10_ll_ctrl.enable                            = ( p9_ll_v_f & ~ p10_ll_ctrl.hold
                                                  ) ;
  p10_ll_ctrl.bypsel                            = ( p10_stall_f [ 3 ] ) ;


  if ( p10_ll_ctrl.enable | p10_ll_ctrl.hold ) begin
    p10_ll_v_nxt                                = 1'b1 ;
  end
  if ( p10_ll_ctrl.enable ) begin
    p10_ll_data_nxt                           = p9_ll_data_f ;

    if ( p10_ll_data_nxt.cmd != HQM_AQED_CMD_NOOP ) begin
      p10_ll_data_nxt.hp                        = rmw_ll_hp_p2_data_f [ ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH - 1 ] ; 
      p10_ll_data_nxt.hp_parity                 = rmw_ll_hp_p2_data_f [ ( ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) + HQM_AQED_LL_QE_HP_DWIDTH - 1 )  +: 1 ] ; 
      p10_ll_data_nxt.tp                        = rmw_ll_tp_p2_data_f [ ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH - 1 ] ; 
      p10_ll_data_nxt.tp_parity                 = rmw_ll_tp_p2_data_f [ ( ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_TP_DWIDTH ) + HQM_AQED_LL_QE_TP_DWIDTH - 1 )  +: 1 ] ; 

      parity_check_ll_rmw_hp_p2_p               = p10_ll_data_nxt.hp_parity ;
      parity_check_ll_rmw_hp_p2_d               = p10_ll_data_nxt.hp ;
      parity_check_ll_rmw_hp_p2_e               = 1'b1 ;

      parity_check_ll_rmw_tp_p2_p               = p10_ll_data_nxt.tp_parity ;
      parity_check_ll_rmw_tp_p2_d               = p10_ll_data_nxt.tp ;
      parity_check_ll_rmw_tp_p2_e               = 1'b1 ;
    end

    //bypass directly into pipeline storage (RMW does not have this bypass)
    if ( ( rmw_ll_hp_p3_bypsel_nxt [ p10_ll_data_nxt.qpri ]  )
       & ( p10_ll_data_nxt.fid == p13_ll_data_nxt.fid )
       )  begin
      p10_ll_data_nxt.hp                        = rmw_ll_hp_p3_bypdata_nxt [ ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH - 1 ] ; 
      p10_ll_data_nxt.hp_parity                 = rmw_ll_hp_p3_bypdata_nxt [ ( ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) + HQM_AQED_LL_QE_HP_DWIDTH - 1 )  +: 1 ] ; 
    end
    if ( ( rmw_ll_tp_p3_bypsel_nxt [ p10_ll_data_nxt.qpri ]  )
       & ( p10_ll_data_nxt.fid == p13_ll_data_nxt.fid )
       )  begin
      p10_ll_data_nxt.tp                        = rmw_ll_tp_p3_bypdata_nxt [ ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH - 1 ] ; 
      p10_ll_data_nxt.tp_parity                 = rmw_ll_tp_p3_bypdata_nxt [ ( ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_TP_DWIDTH ) + HQM_AQED_LL_QE_TP_DWIDTH - 1 )  +: 1 ] ; 
    end


    if ( p10_ll_data_nxt.cmd == HQM_AQED_CMD_ENQ ) begin
      if ( ~ p10_ll_data_nxt.empty ) begin
        rw_ll_qe_hpnxt_p0_v_nxt                 = 1'b1 ;
        rw_ll_qe_hpnxt_p0_rw_nxt                = HQM_AW_RWPIPE_WRITE ;
        rw_ll_qe_hpnxt_p0_addr_nxt              = p10_ll_data_nxt.tp ;
        rw_ll_qe_hpnxt_p0_write_data_nxt        = { 5'd0 , p10_ll_data_nxt.new_flid_parity , p10_ll_data_nxt.new_flid [ ( HQM_AQED_FLIDB2 ) - 1 : 0 ] } ;
      end
      else begin
        rw_ll_qe_hpnxt_p0_v_nxt                 = 1'b1 ;
        rw_ll_qe_hpnxt_p0_rw_nxt                = HQM_AW_RWPIPE_NOOP ;
      end

        rw_aqed_p0_v_nxt                        = 1'b1 ;
        rw_aqed_p0_rw_nxt                       = HQM_AW_RWPIPE_WRITE ;
        rw_aqed_p0_addr_nxt                     = p10_ll_data_nxt.new_flid ;
        rw_aqed_p0_write_data_nxt               = { p10_ll_data_nxt.cq_hcw_ecc , p10_ll_data_nxt.cq_hcw } ;
    end
    if ( p10_ll_data_nxt.cmd == HQM_AQED_CMD_DEQ ) begin
        rw_ll_qe_hpnxt_p0_v_nxt                 = 1'b1 ;
        rw_ll_qe_hpnxt_p0_rw_nxt                = HQM_AW_RWPIPE_READ ;
        rw_ll_qe_hpnxt_p0_addr_nxt              = p10_ll_data_nxt.hp ;
        rw_ll_qe_hpnxt_p0_write_data_nxt        = '0 ;

        rw_aqed_p0_v_nxt                        = 1'b1 ;
        rw_aqed_p0_rw_nxt                       = HQM_AW_RWPIPE_READ ;
        rw_aqed_p0_addr_nxt                     = p10_ll_data_nxt.hp ;
        rw_aqed_p0_write_data_nxt               = '0 ;
    end
  end
  if ( p10_ll_ctrl.bypsel  ) begin
    if ( ( rmw_ll_hp_p3_bypsel_nxt [ p10_ll_data_nxt.qpri ]  )
       & ( p10_ll_data_nxt.fid == p13_ll_data_nxt.fid )
       )  begin
      p10_ll_data_nxt.hp                        = rmw_ll_hp_p3_bypdata_nxt [ ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH - 1 ] ; 
      p10_ll_data_nxt.hp_parity                 = rmw_ll_hp_p3_bypdata_nxt [ ( ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) + HQM_AQED_LL_QE_HP_DWIDTH - 1 )  +: 1 ] ; 

    if ( p10_ll_data_nxt.cmd == HQM_AQED_CMD_DEQ ) begin
        rw_ll_qe_hpnxt_p0_byp_v_nxt                 = 1'b1 ;
        rw_ll_qe_hpnxt_p0_byp_rw_nxt                = HQM_AW_RWPIPE_READ ;
        rw_ll_qe_hpnxt_p0_byp_addr_nxt              = p10_ll_data_nxt.hp ;
        rw_ll_qe_hpnxt_p0_byp_write_data_nxt        = '0 ;

        rw_aqed_p0_byp_v_nxt                        = 1'b1 ;
        rw_aqed_p0_byp_rw_nxt                       = HQM_AW_RWPIPE_READ ;
        rw_aqed_p0_byp_addr_nxt                     = p10_ll_data_nxt.hp ;
        rw_aqed_p0_byp_write_data_nxt_nc               = '0 ;
    end

    end
    if ( ( rmw_ll_tp_p3_bypsel_nxt [ p10_ll_data_nxt.qpri ]  )
       & ( p10_ll_data_nxt.fid == p13_ll_data_nxt.fid )
       )  begin
      p10_ll_data_nxt.tp                        = rmw_ll_tp_p3_bypdata_nxt [ ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_TP_DWIDTH ) +: HQM_AQED_LL_QE_TP_DWIDTH - 1 ] ; 
      p10_ll_data_nxt.tp_parity                 = rmw_ll_tp_p3_bypdata_nxt [ ( ( p10_ll_data_nxt.qpri * HQM_AQED_LL_QE_TP_DWIDTH ) + HQM_AQED_LL_QE_TP_DWIDTH - 1 )  +: 1 ] ; 
    end

    if ( p10_ll_data_nxt.cmd == HQM_AQED_CMD_ENQ ) begin
      if ( ~ p10_ll_data_nxt.empty ) begin
        rw_ll_qe_hpnxt_p0_byp_v_nxt                 = 1'b1 ;
        rw_ll_qe_hpnxt_p0_byp_rw_nxt                = HQM_AW_RWPIPE_WRITE ;
        rw_ll_qe_hpnxt_p0_byp_addr_nxt              = p10_ll_data_nxt.tp ;
        rw_ll_qe_hpnxt_p0_byp_write_data_nxt        = { 5'd0 , p10_ll_data_nxt.new_flid_parity , p10_ll_data_nxt.new_flid [ ( HQM_AQED_FLIDB2 ) - 1 : 0 ] } ;
      end
    end

  end

  rw_ll_qe_hpnxt_p0_hold                        = p10_ll_ctrl.hold ;
  rw_aqed_p0_hold                               = p10_ll_ctrl.hold ;

end

always_comb begin : L24
  //....................................................................................................
  // p11 ll pipeline
  //  nxt-1
  p11_ll_ctrl = '0 ;
  p11_ll_v_nxt = '0 ;
  p11_ll_data_nxt = p11_ll_data_f ;

  rw_ll_qe_hpnxt_p1_hold = '0 ;
  rw_aqed_p1_hold = '0 ;

  p11_ll_ctrl.hold                              = ( p11_ll_v_f & p12_ll_ctrl.hold ) ;
  p11_ll_ctrl.enable                            = ( p10_ll_v_f & ~ p10_stall_f [ 4 ] & ~ p11_ll_ctrl.hold ) ;

  if ( p11_ll_ctrl.enable | p11_ll_ctrl.hold ) begin
    p11_ll_v_nxt                                = 1'b1 ;
  end
  if ( p11_ll_ctrl.enable ) begin
    p11_ll_data_nxt                             = p10_ll_data_f ;
  end

  rw_ll_qe_hpnxt_p1_hold                        = p11_ll_ctrl.hold ;
  rw_aqed_p1_hold                               = p11_ll_ctrl.hold ;
end


always_comb begin : L25
  //....................................................................................................
  // p12 ll pipeline
  //  nxt-2
  p12_ll_ctrl = '0 ;
  p12_ll_v_nxt = '0 ;
  p12_ll_data_nxt = p12_ll_data_f ;

  rw_ll_qe_hpnxt_p2_hold = '0 ;

  rw_aqed_p2_hold = '0 ;

  p12_ll_ctrl.hold                              = ( p12_ll_v_f & p13_ll_ctrl.hold ) ;
  p12_ll_ctrl.enable                            = ( p11_ll_v_f & ~ p12_ll_ctrl.hold ) ;

  if ( p12_ll_ctrl.enable | p12_ll_ctrl.hold ) begin
    p12_ll_v_nxt                                = 1'b1 ;
  end
  if ( p12_ll_ctrl.enable ) begin
    p12_ll_data_nxt                             = p11_ll_data_f ;
  end

  rw_ll_qe_hpnxt_p2_hold                        = p12_ll_ctrl.hold ;
  rw_aqed_p2_hold                              = p12_ll_ctrl.hold ;

end


always_comb begin : L26
  //....................................................................................................
  // p13 ll pipeline
  //  nxt-2
  p13_ll_ctrl = '0 ;
  p13_ll_v_nxt = '0 ;
  p13_ll_data_nxt = p13_ll_data_f ;


  rw_ll_qe_hpnxt_p3_hold = '0 ;

  rw_aqed_p3_hold = '0 ;

  parity_check_ll_rw_ll_qe_hpnxt_p2_data_p = '0 ;
  parity_check_ll_rw_ll_qe_hpnxt_p2_data_d = '0 ;
  parity_check_ll_rw_ll_qe_hpnxt_p2_data_e = '0 ;

  rmw_ll_hp_p3_bypsel_nxt = '0 ;
  rmw_ll_hp_p3_bypaddr_nxt = '0 ;
  rmw_ll_hp_p3_bypdata_nxt = '0 ;

  rmw_ll_tp_p3_bypsel_nxt = '0 ;
  rmw_ll_tp_p3_bypaddr_nxt = '0 ;
  rmw_ll_tp_p3_bypdata_nxt = '0 ;

  fifo_aqed_ap_enq_push = '0 ;
  fifo_aqed_ap_enq_push_data = '0 ;

  fifo_aqed_chp_sch_push = '0 ;
  fifo_aqed_chp_sch_push_data = '0 ;

  fifo_freelist_return_push = '0 ;
  fifo_freelist_return_push_data = '0 ;

  error_ll_headroom = '0 ;


//CHANGE from full to afull
  p13_ll_ctrl.hold                              = ( p12_ll_v_f
                                                  & ( ( p12_ll_data_f.cmd == HQM_AQED_CMD_ENQ ) ? fifo_aqed_ap_enq_afull : 1'b0 )
                                                  & ( ( p12_ll_data_f.cmd == HQM_AQED_CMD_DEQ ) ? fifo_aqed_chp_sch_afull : 1'b0 )
                                                  & ( ( p12_ll_data_f.cmd == HQM_AQED_CMD_DEQ ) ? fifo_freelist_return_afull : 1'b0 )
                                                  ) ;
  p13_ll_ctrl.enable                            = ( p12_ll_v_f & ~ p13_ll_ctrl.hold ) ;

  error_ll_headroom [ 0 ]                          = ( p12_ll_v_f
                                                  & ( ( p12_ll_data_f.cmd == HQM_AQED_CMD_ENQ ) ? fifo_aqed_ap_enq_afull : 1'b0 )
                                                  ) ;
  error_ll_headroom [ 1 ]                          = ( p12_ll_v_f
                                                  & ( ( p12_ll_data_f.cmd == HQM_AQED_CMD_DEQ ) ? fifo_aqed_chp_sch_afull : 1'b0 )
                                                  ) ;
  error_ll_headroom [ 1 ]                          = ( p12_ll_v_f
                                                  & ( ( p12_ll_data_f.cmd == HQM_AQED_CMD_DEQ ) ? fifo_freelist_return_afull : 1'b0 )
                                                  ) ;

  if ( p13_ll_ctrl.enable | p13_ll_ctrl.hold ) begin
    p13_ll_v_nxt                                = 1'b1 ;
  end
  if ( p13_ll_ctrl.enable ) begin
    p13_ll_data_nxt                             = p12_ll_data_f ;

    if ( p13_ll_data_nxt.cmd == HQM_AQED_CMD_ENQ ) begin

      fifo_aqed_ap_enq_push                     = 1'b1 ;
      fifo_aqed_ap_enq_push_data.qid            = p13_ll_data_nxt.qid ;
      fifo_aqed_ap_enq_push_data.qpri           = { p13_ll_data_nxt.qpri [ 1 : 0 ] , 1'b0 } ; //Need to make pri 3b again for AP
      fifo_aqed_ap_enq_push_data.parity         = p13_ll_data_nxt.parity ;
      fifo_aqed_ap_enq_push_data.flid           = p13_ll_data_nxt.fid ;
      fifo_aqed_ap_enq_push_data.flid_parity    = p13_ll_data_nxt.fid_parity ;

      if ( p13_ll_data_nxt.empty  ) begin
        rmw_ll_hp_p3_bypsel_nxt [ p13_ll_data_nxt.qpri ] = 1'b1 ;
        rmw_ll_hp_p3_bypaddr_nxt [ ( p13_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] = { p13_ll_data_nxt.fid } ; 
        rmw_ll_hp_p3_bypdata_nxt [ ( p13_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] = { p13_ll_data_nxt.new_flid_parity , p13_ll_data_nxt.new_flid [ ( HQM_AQED_FLIDB2 ) - 1 : 0 ] } ; 
      end
      rmw_ll_tp_p3_bypsel_nxt [ p13_ll_data_nxt.qpri ] = 1'b1 ;
      rmw_ll_tp_p3_bypaddr_nxt [ ( p13_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] = { p13_ll_data_nxt.fid } ; 
      rmw_ll_tp_p3_bypdata_nxt [ ( p13_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] = { p13_ll_data_nxt.new_flid_parity , p13_ll_data_nxt.new_flid [ ( HQM_AQED_FLIDB2 ) - 1 : 0 ] } ; 

    end
    if ( p13_ll_data_nxt.cmd == HQM_AQED_CMD_DEQ ) begin

      fifo_aqed_chp_sch_push                    = 1'b1 ;
      fifo_aqed_chp_sch_push_data.cq            = p13_ll_data_nxt.pcm ? { p13_ll_data_nxt.cq [ 7 : 1 ] , 1'b0 } : p13_ll_data_nxt.cq ;
      fifo_aqed_chp_sch_push_data.qid           = p13_ll_data_nxt.qid ;
      fifo_aqed_chp_sch_push_data.qidix         = p13_ll_data_nxt.qidix ;
      fifo_aqed_chp_sch_push_data.parity        = p13_ll_data_nxt.pcm ? p13_ll_data_nxt.cq [ 0 ] ^ p13_ll_data_nxt.parity  : p13_ll_data_nxt.parity ;
      fifo_aqed_chp_sch_push_data.fid          = { p13_ll_data_nxt.fid } ;
      fifo_aqed_chp_sch_push_data.fid_parity   = p13_ll_data_nxt.fid_parity ;
      fifo_aqed_chp_sch_push_data.hqm_core_flags = p13_ll_data_nxt.hqm_core_flags ;
      fifo_aqed_chp_sch_push_data.cq_hcw        = rw_aqed_p2_data_f [ ( 123 ) - 1 : 0 ] ;
      fifo_aqed_chp_sch_push_data.cq_hcw_ecc    = rw_aqed_p2_data_f [ ( 139 ) - 1 : 123 ] ;


      fifo_freelist_return_push                 = 1'b1 ;
      fifo_freelist_return_push_data.cq         = p13_ll_data_nxt.cq ;
      fifo_freelist_return_push_data.qidix      = p13_ll_data_nxt.qidix ;
      fifo_freelist_return_push_data.parity     = p13_ll_data_nxt.parity ;
      fifo_freelist_return_push_data.hp         = p13_ll_data_nxt.hp ;
      fifo_freelist_return_push_data.hp_parity  = p13_ll_data_nxt.hp_parity ;
      fifo_freelist_return_push_data.qid        = p13_ll_data_nxt.qid ;

      if ( ~ p13_ll_data_nxt.empty ) begin
        parity_check_ll_rw_ll_qe_hpnxt_p2_data_p  = rw_ll_qe_hpnxt_p2_data_f [ ( HQM_AQED_DATA ) ] ;
        parity_check_ll_rw_ll_qe_hpnxt_p2_data_d  = rw_ll_qe_hpnxt_p2_data_f [ ( HQM_AQED_DATA ) - 1 : 0 ] ;
        parity_check_ll_rw_ll_qe_hpnxt_p2_data_e  = 1'b1 ;

        rmw_ll_hp_p3_bypsel_nxt [ p13_ll_data_nxt.qpri ] = 1'b1 ;
        rmw_ll_hp_p3_bypaddr_nxt [ ( p13_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DEPTHB2 ) +: HQM_AQED_LL_QE_HP_DEPTHB2 ] = { p13_ll_data_nxt.fid } ; 
        rmw_ll_hp_p3_bypdata_nxt [ ( p13_ll_data_nxt.qpri * HQM_AQED_LL_QE_HP_DWIDTH ) +: HQM_AQED_LL_QE_HP_DWIDTH ] = { rw_ll_qe_hpnxt_p2_data_f [ ( HQM_AQED_DATA + HQM_AQED_PARITY ) - 1 : 0 ] } ; 
      end
    end

  end

  //send dequeue to LSP
  aqed_lsp_deq_v           = fifo_aqed_chp_sch_push ;
  aqed_lsp_deq_data.cq     = fifo_aqed_chp_sch_push_data.cq [ 5 : 0 ] ;
  aqed_lsp_deq_data.qe_wt  = fifo_aqed_chp_sch_push_data.cq_hcw.qe_wt ;
  aqed_lsp_deq_data.parity =  ^ { 1'b1 , aqed_lsp_deq_data.cq , aqed_lsp_deq_data.qe_wt } ;


  //....................................................................................................
  // drive FIFO output to ports
  fifo_aqed_ap_enq_pop = '0 ;

  db_aqed_ap_enq_valid = '0 ;
  db_aqed_ap_enq_data = '0 ;

  fifo_aqed_chp_sch_pop = '0 ;

  db_aqed_chp_sch_valid = '0 ;
  db_aqed_chp_sch_data = '0 ;

  fifo_aqed_ap_enq_dec = '0 ;
  fifo_aqed_chp_sch_dec = '0 ;

  if ( ~ fifo_aqed_ap_enq_empty & db_aqed_ap_enq_ready ) begin
    db_aqed_ap_enq_valid                        = 1'b1 ;
    db_aqed_ap_enq_data                         = fifo_aqed_ap_enq_pop_data ;

    fifo_aqed_ap_enq_pop                        = 1'b1 ;
    fifo_aqed_ap_enq_dec                        = fifo_aqed_ap_enq_pop ;
  end

  if ( ~ fifo_aqed_chp_sch_empty & db_aqed_chp_sch_ready
     ) begin
    db_aqed_chp_sch_valid                       = 1'b1 ;
    db_aqed_chp_sch_data.cq                     = fifo_aqed_chp_sch_pop_data_pnc.cq ;
    db_aqed_chp_sch_data.qid                    = fifo_aqed_chp_sch_pop_data_pnc.qid ;
    db_aqed_chp_sch_data.qidix                  = fifo_aqed_chp_sch_pop_data_pnc.qidix ;
    db_aqed_chp_sch_data.parity                 = fifo_aqed_chp_sch_pop_data_pnc.parity ;
    db_aqed_chp_sch_data.fid                   = fifo_aqed_chp_sch_pop_data_pnc.fid ;
    db_aqed_chp_sch_data.fid_parity            = fifo_aqed_chp_sch_pop_data_pnc.fid_parity ;
    db_aqed_chp_sch_data.hqm_core_flags         = fifo_aqed_chp_sch_pop_data_pnc.hqm_core_flags ;
    db_aqed_chp_sch_data.cq_hcw                 = fifo_aqed_chp_sch_pop_data_pnc.cq_hcw ;
    db_aqed_chp_sch_data.cq_hcw_ecc             = fifo_aqed_chp_sch_pop_data_pnc.cq_hcw_ecc ;

    fifo_aqed_chp_sch_pop                       = 1'b1 ;
    fifo_aqed_chp_sch_dec                       = fifo_aqed_chp_sch_pop ;
  end


end









always_comb begin : L27
  //....................................................................................................
  // sidecar CFG
  //   control unit CFG registers
  //     reset status register (cfg accesible)
  //     default to init RAM
  //     check for pipe idle & stop processing

  //....................................................................................................
  // initial values


  //AW modules
  smon_v_nxt = '0 ;
  smon_comp_nxt = smon_comp_f ;
  smon_val_nxt = smon_val_f ;

  // CFG registers defaults (prevent inferred latch )
  cfg_unit_idle_nxt = cfg_unit_idle_f ;
  cfg_csr_control_nxt = cfg_csr_control_f ;
  cfg_control0_nxt = cfg_control0_f ;
  cfg_control1_nxt = cfg_control1_f ;

//Features
cfg_control1_nxt [ 0 ] = cfg_control1_f [ 0 ] | ( aqed_lsp_fid_cnt_upd_v & ~ aqed_lsp_fid_cnt_upd_val ) ;
cfg_control1_nxt [ 1 ] = cfg_control1_f [ 1 ] | ( fid_bcam_notempty ) ;
cfg_control1_nxt [ 2 ] = cfg_control1_f [ 2 ] | ( fid_bcam_total_qid == 14'd2048 ) ;
cfg_control1_nxt [ 3 ] = cfg_control1_f [ 3 ] | ( fid_bcam_total_fid == 14'd4096 ) ;


cfg_control1_nxt [ 4 ] = cfg_control1_f [ 4 ] | fid_bcam_error [ 0 ] ;
cfg_control1_nxt [ 5 ] = cfg_control1_f [ 5 ] | fid_bcam_error [ 1 ] ;
cfg_control1_nxt [ 6 ] = cfg_control1_f [ 6 ] | fid_bcam_error [ 2 ] ;
cfg_control1_nxt [ 7 ] = cfg_control1_f [ 7 ] | fid_bcam_error [ 3 ] ;
cfg_control1_nxt [ 8 ] = cfg_control1_f [ 8 ] | fid_bcam_error [ 4 ] ;
cfg_control1_nxt [ 9 ] = cfg_control1_f [ 9 ] | fid_bcam_error [ 5 ] ;
cfg_control1_nxt [ 10 ] = cfg_control1_f [ 10 ] | fid_bcam_error [ 6 ] ;
cfg_control1_nxt [ 11 ] = cfg_control1_f [ 11 ] | fid_bcam_error [ 7 ] ;
cfg_control1_nxt [ 12 ] = cfg_control1_f [ 12 ] | fid_bcam_error [ 8 ] ;
cfg_control1_nxt [ 13 ] = cfg_control1_f [ 13 ] | fid_bcam_error [ 9 ] ;
cfg_control1_nxt [ 14 ] = cfg_control1_f [ 14 ] | fid_bcam_error [ 10 ] ;
cfg_control1_nxt [ 15 ] = cfg_control1_f [ 15 ] | fid_bcam_error [ 11 ] ;
cfg_control1_nxt [ 16 ] = cfg_control1_f [ 16 ] | fid_bcam_error [ 12 ] ;
cfg_control1_nxt [ 17 ] = cfg_control1_f [ 17 ] | fid_bcam_error [ 13 ] ;
cfg_control1_nxt [ 18 ] = cfg_control1_f [ 18 ] | fid_bcam_error [ 14 ] ;
cfg_control1_nxt [ 19 ] = cfg_control1_f [ 19 ] | fid_bcam_error [ 15 ] ;
cfg_control1_nxt [ 20 ] = cfg_control1_f [ 20 ] | fid_bcam_error [ 16 ] ;
cfg_control1_nxt [ 21 ] = cfg_control1_f [ 21 ] | fid_bcam_error [ 17 ] ;
cfg_control1_nxt [ 22 ] = cfg_control1_f [ 22 ] | fid_bcam_error [ 18 ] ;
cfg_control1_nxt [ 23 ] = cfg_control1_f [ 23 ] | fid_bcam_error [ 19 ] ;
cfg_control1_nxt [ 24 ] = cfg_control1_f [ 24 ] | fid_bcam_error [ 20 ] ;
cfg_control1_nxt [ 25 ] = cfg_control1_f [ 25 ] | fid_bcam_error [ 21 ] ;
cfg_control1_nxt [ 26 ] = cfg_control1_f [ 26 ] | fid_bcam_error [ 22 ] ;
cfg_control1_nxt [ 27 ] = cfg_control1_f [ 27 ] | fid_bcam_error [ 23 ] ;

cfg_control1_nxt [ 31 ] = cfg_control1_f [ 31 ] | aqed_lsp_stop_atqatm_f ;

  cfg_control2_nxt = cfg_control2_f ;
  cfg_control3_nxt = cfg_control3_f ;
  cfg_control4_nxt = cfg_control4_f ;
cfg_control4_nxt [ 16 ] = cfg_control4_f [ 16 ] | debug_fidcnt_uf ;
cfg_control4_nxt [ 17 ] = cfg_control4_f [ 17 ] | debug_collide0 ;
cfg_control4_nxt [ 18 ] = cfg_control4_f [ 18 ] | debug_collide1 ;
cfg_control4_nxt [ 19 ] = cfg_control4_f [ 19 ] | debug_hit ;
cfg_control4_nxt [ 20 ] = cfg_control4_f [ 20 ] | parity_check_error ;
cfg_control4_nxt [ 21 ] = cfg_control4_f [ 21 ] | ( fid_bcam_total_qid > 14'd2046 ) ;
cfg_control4_nxt [ 22 ] = cfg_control4_f [ 22 ] | ( fid_bcam_total_qid > 14'd2047 ) ;
cfg_control4_nxt [ 23 ] = cfg_control4_f [ 23 ] | ( fid_bcam_total_qid > 14'd2048 ) ;
cfg_control4_nxt [ 24 ] = cfg_control4_f [ 24 ] | ( fid_bcam_total_fid > 14'd4094 ) ;
cfg_control4_nxt [ 25 ] = cfg_control4_f [ 25 ] | ( fid_bcam_total_fid > 14'd4095 ) ;
cfg_control4_nxt [ 26 ] = cfg_control4_f [ 26 ] | ( fid_bcam_total_fid > 14'd4096 ) ;
cfg_control4_nxt [ 27 ] = cfg_control4_f [ 27 ] | ( fid_bcam_total_fid > 14'd4097 ) ;

cfg_control4_nxt [ 28 ] = cfg_control4_f [ 28 ] | ( debug_fidcnt_uf ) ;
cfg_control4_nxt [ 29 ] = cfg_control4_f [ 29 ] | ( debug_fidcnt_of ) ;
cfg_control4_nxt [ 30 ] = cfg_control4_f [ 30 ] | ( debug_qidcnt_uf ) ;
cfg_control4_nxt [ 31 ] = cfg_control4_f [ 31 ] | ( debug_qidcnt_of ) ;

  cfg_pipe_health_valid_nxt = cfg_pipe_health_valid_f_nc ;
  cfg_pipe_health_hold_nxt = cfg_pipe_health_hold_f ;
  cfg_interface_nxt = cfg_interface_f ;

  // PF reset state
reset_pf_counter_0_nxt = reset_pf_counter_0_f ;
reset_pf_counter_1_nxt = reset_pf_counter_1_f ;
reset_pf_active_0_nxt = reset_pf_active_0_f ;
reset_pf_active_1_nxt = reset_pf_active_1_f ;
reset_pf_done_0_nxt =  reset_pf_done_0_f ;
reset_pf_done_1_nxt =  reset_pf_done_1_f ;
hw_init_done_0_nxt = hw_init_done_0_f ;
hw_init_done_1_nxt = hw_init_done_1_f ;








  // Parity gen 
  ecc_d_default2 = '0 ;

  //RAM generate ECC to RAM
  ecc_gen_hcw_l_d_nc = '0 ;
  ecc_gen_hcw_h_d_nc = '0 ;

  error_vfreset_cfg = 1'b0 ;

  //....................................................................................................
  // CFG register update values
  cfg_pipe_health_valid_nxt                     = { 8'd0
                                                  , fid_bcam_pipe_health
                                                  , ~ fifo_freelist_return_empty
                                                  , p13_ll_v_f
                                                  , p12_ll_v_f
                                                  , p11_ll_v_f
                                                  , p10_ll_v_f
                                                  , p9_ll_v_f
                                                  , p8_ll_v_f
                                                  , p7_ll_v_f
                                                  , p6_ll_v_f
                                                  , p5_ll_v_f
                                                  , p4_ll_v_f
                                                  , p3_ll_v_f
                                                  , p2_ll_v_f
                                                  , p1_ll_v_f
                                                  , p0_ll_v_f
                                                  } ;

  cfg_pipe_health_hold_nxt                      = { 18'd0
                                                  , p13_ll_ctrl.hold
                                                  , p12_ll_ctrl.hold
                                                  , p11_ll_ctrl.hold
                                                  , p10_ll_ctrl.hold
                                                  , p9_ll_ctrl.hold
                                                  , p8_ll_ctrl.hold
                                                  , p7_ll_ctrl.hold
                                                  , p6_ll_ctrl.hold
                                                  , p5_ll_ctrl.hold
                                                  , p4_ll_ctrl.hold
                                                  , p3_ll_ctrl.hold
                                                  , p2_ll_ctrl.hold
                                                  , p1_ll_ctrl.hold
                                                  , p0_ll_ctrl.hold
                                                  } ;

  cfg_status0                                   = { 1'd0
                                                  , ( ( ptr_mem_data_f [ 25 ] != ptr_mem_data_f [ 11 ] ) & ( ptr_mem_data_f [ 24 : 14 ] == ptr_mem_data_f [ 10 : 0 ] ) ) // MF full
                                                  , ( ( ptr_mem_data_f [ 25 ] == ptr_mem_data_f [ 11 ] ) & ( ptr_mem_data_f [ 24 : 14 ] == ptr_mem_data_f [ 10 : 0 ] ) ) // MF empty
                                                  , fid_bcam_notempty
                                                  , ( | rmw_ll_cnt_p3_v_f )
                                                  , ( | rmw_ll_cnt_p2_v_f )
                                                  , ( | rmw_ll_cnt_p1_v_f )
                                                  , ( | rmw_ll_cnt_p0_v_f )
                                                  , ( | rmw_ll_cnt_p3_hold )
                                                  , ( | rmw_ll_cnt_p2_hold )
                                                  , ( | rmw_ll_cnt_p1_hold )
                                                  , ( | rmw_ll_hp_p3_v_f )
                                                  , ( | rmw_ll_hp_p2_v_f )
                                                  , ( | rmw_ll_hp_p1_v_f )
                                                  , ( | rmw_ll_hp_p0_v_f )
                                                  , ( | rmw_ll_hp_p3_hold )
                                                  , ( | rmw_ll_hp_p2_hold )
                                                  , ( | rmw_ll_hp_p1_hold )
                                                  , ( | rmw_ll_tp_p0_v_f )
                                                  , ( | rmw_ll_tp_p1_v_f )
                                                  , ( | rmw_ll_tp_p2_v_f )
                                                  , ( | rmw_ll_tp_p3_v_f )
                                                  , ( | rmw_ll_tp_p1_hold )
                                                  , ( | rmw_ll_tp_p2_hold )
                                                  , ( | rmw_ll_tp_p3_hold )
                                                  , rw_ll_qe_hpnxt_p0_v_f
                                                  , rw_ll_qe_hpnxt_p1_v_f
                                                  , rw_ll_qe_hpnxt_p2_v_f
                                                  , rw_ll_qe_hpnxt_p3_v_f
                                                  , rw_ll_qe_hpnxt_p1_hold
                                                  , rw_ll_qe_hpnxt_p2_hold
                                                  , rw_ll_qe_hpnxt_p3_hold
                                                  } ;

  cfg_status1                                   = { ( | cfg_pipe_health_hold_f )
                                                  , ( | cfg_interface_f )
                                                  , mf_status
                                                  , fifo_freelist_return_afull
                                                  , fifo_aqed_chp_sch_afull
                                                  , fifo_aqed_ap_enq_afull
                                                  , fifo_qed_aqed_enq_full
                                                  , hqm_aqed_target_cfg_smon_smon_enabled
                                                  , rw_aqed_p0_v_f
                                                  , rw_aqed_p1_v_f
                                                  , rw_aqed_p2_v_f
                                                  , rw_aqed_p3_v_f
                                                  , rw_aqed_p1_hold
                                                  , rw_aqed_p2_hold
                                                  , rw_aqed_p3_hold
                                                  , ( | int_status [ 31 : 16 ] )
                                                  , int_status [ 15 : 0 ]
                                                  } ;

  cfg_status2                                   = { fifo_qed_aqed_enq_fid_credits_f , fid_bcam_total_qid , fid_bcam_total_fid } ;


  cfg_unit_idle_nxt.pipe_idle                   = ~ ( | cfg_pipe_health_valid_nxt ) ;


  unit_idle_hqm_clk_gated                       = ( ( cfg_unit_idle_nxt.pipe_idle  )

                                                  & ~ fifo_qed_aqed_enq_push_f

                                                  & ( fifo_freelist_return_empty  )
                                                  & ( ~ fifo_qed_aqed_enq_pop_data_v  )
                                                  & ( fifo_aqed_ap_enq_empty  )
                                                  & ( fifo_ap_aqed_empty  )
                                                  & ( fifo_aqed_chp_sch_empty  )
                                                  & ( fifo_qed_aqed_enq_fid_empty  )
                                                  & ( fifo_lsp_aqed_cmp_empty  )

                                                  & ( db_aqed_chp_sch_idle )

                                                  & ( db_ap_aqed_status_pnc [ 1 : 0 ] == 2'd0 )
                                                  & ( db_aqed_ap_enq_status_pnc [ 1 : 0 ] == 2'd0 )
                                                  & ( db_aqed_chp_sch_status_pnc [ 1 : 0 ] == 2'd0 )
                                                  & ( db_aqed_lsp_sch_status_pnc [ 1 : 0 ] == 2'd0 )
                                                  & ( db_lsp_aqed_cmp_status_pnc [ 1 : 0 ] == 2'd0 )

//reset_control                                                    & ~ cfg_reset_status_f.reset_active
//reset_control                                                    & ~ cfg_reset_status_f.vf_reset_active
                                                  ) ;

  unit_idle_hqm_clk_inp_gated                   = ( 
                                                    ( cfg_idle )
                                                  & ( int_idle )
                                                  & ( rx_sync_qed_aqed_enq_idle )
                                                  ) ;


  cfg_unit_idle_nxt.unit_idle                   =  ( unit_idle_hqm_clk_gated ) & ( ~ hqm_gated_rst_n_active ) ;








  //....................................................................................................
  // PF reset

pf_aqed_re = '0 ;
pf_aqed_addr = '0 ;
pf_aqed_we = '0 ;
pf_aqed_wdata = '0 ;
pf_aqed_ll_qe_hpnxt_re = '0 ;
pf_aqed_ll_qe_hpnxt_addr = '0 ;
pf_aqed_ll_qe_hpnxt_we = '0 ;
pf_aqed_ll_qe_hpnxt_wdata = '0 ;
pf_aqed_freelist_re = '0 ;
pf_aqed_freelist_addr = '0 ;
pf_aqed_freelist_we = '0 ;
pf_aqed_freelist_wdata = '0 ;
pf_aqed_fifo_freelist_return_re = '0 ;
pf_aqed_fifo_freelist_return_raddr = '0 ;
pf_aqed_fifo_freelist_return_waddr = '0 ;
pf_aqed_fifo_freelist_return_we = '0 ;
pf_aqed_fifo_freelist_return_wdata = '0 ;





pf_rx_sync_qed_aqed_enq_re = '0 ;
pf_rx_sync_qed_aqed_enq_raddr = '0 ;
pf_rx_sync_qed_aqed_enq_waddr = '0 ;
pf_rx_sync_qed_aqed_enq_we = '0 ;
pf_rx_sync_qed_aqed_enq_wdata = '0 ;
pf_aqed_ll_qe_hp_pri0_re = '0 ;
pf_aqed_ll_qe_hp_pri0_raddr = '0 ;
pf_aqed_ll_qe_hp_pri0_waddr = '0 ;
pf_aqed_ll_qe_hp_pri0_we = '0 ;
pf_aqed_ll_qe_hp_pri0_wdata = '0 ;
pf_aqed_fifo_qed_aqed_enq_re = '0 ;
pf_aqed_fifo_qed_aqed_enq_raddr = '0 ;
pf_aqed_fifo_qed_aqed_enq_waddr = '0 ;
pf_aqed_fifo_qed_aqed_enq_we = '0 ;
pf_aqed_fifo_qed_aqed_enq_wdata = '0 ;





pf_aqed_ll_cnt_pri0_re = '0 ;
pf_aqed_ll_cnt_pri0_raddr = '0 ;
pf_aqed_ll_cnt_pri0_waddr = '0 ;
pf_aqed_ll_cnt_pri0_we = '0 ;
pf_aqed_ll_cnt_pri0_wdata = '0 ;
pf_aqed_fifo_aqed_ap_enq_re = '0 ;
pf_aqed_fifo_aqed_ap_enq_raddr = '0 ;
pf_aqed_fifo_aqed_ap_enq_waddr = '0 ;
pf_aqed_fifo_aqed_ap_enq_we = '0 ;
pf_aqed_fifo_aqed_ap_enq_wdata = '0 ;
pf_aqed_ll_qe_tp_pri2_re = '0 ;
pf_aqed_ll_qe_tp_pri2_raddr = '0 ;
pf_aqed_ll_qe_tp_pri2_waddr = '0 ;
pf_aqed_ll_qe_tp_pri2_we = '0 ;
pf_aqed_ll_qe_tp_pri2_wdata = '0 ;
pf_aqed_ll_qe_hp_pri1_re = '0 ;
pf_aqed_ll_qe_hp_pri1_raddr = '0 ;
pf_aqed_ll_qe_hp_pri1_waddr = '0 ;
pf_aqed_ll_qe_hp_pri1_we = '0 ;
pf_aqed_ll_qe_hp_pri1_wdata = '0 ;
pf_aqed_ll_cnt_pri2_re = '0 ;
pf_aqed_ll_cnt_pri2_raddr = '0 ;
pf_aqed_ll_cnt_pri2_waddr = '0 ;
pf_aqed_ll_cnt_pri2_we = '0 ;
pf_aqed_ll_cnt_pri2_wdata = '0 ;
pf_aqed_qid_cnt_re = '0 ;
pf_aqed_qid_cnt_raddr = '0 ;
pf_aqed_qid_cnt_waddr = '0 ;
pf_aqed_qid_cnt_we = '0 ;
pf_aqed_qid_cnt_wdata = '0 ;





pf_aqed_fifo_aqed_chp_sch_re = '0 ;
pf_aqed_fifo_aqed_chp_sch_raddr = '0 ;
pf_aqed_fifo_aqed_chp_sch_waddr = '0 ;
pf_aqed_fifo_aqed_chp_sch_we = '0 ;
pf_aqed_fifo_aqed_chp_sch_wdata = '0 ;
pf_aqed_fifo_lsp_aqed_cmp_re = '0 ;
pf_aqed_fifo_lsp_aqed_cmp_raddr = '0 ;
pf_aqed_fifo_lsp_aqed_cmp_waddr = '0 ;
pf_aqed_fifo_lsp_aqed_cmp_we = '0 ;
pf_aqed_fifo_lsp_aqed_cmp_wdata = '0 ;
pf_aqed_ll_qe_tp_pri0_re = '0 ;
pf_aqed_ll_qe_tp_pri0_raddr = '0 ;
pf_aqed_ll_qe_tp_pri0_waddr = '0 ;
pf_aqed_ll_qe_tp_pri0_we = '0 ;
pf_aqed_ll_qe_tp_pri0_wdata = '0 ;
pf_aqed_ll_qe_hp_pri3_re = '0 ;
pf_aqed_ll_qe_hp_pri3_raddr = '0 ;
pf_aqed_ll_qe_hp_pri3_waddr = '0 ;
pf_aqed_ll_qe_hp_pri3_we = '0 ;
pf_aqed_ll_qe_hp_pri3_wdata = '0 ;
pf_aqed_ll_cnt_pri3_re = '0 ;
pf_aqed_ll_cnt_pri3_raddr = '0 ;
pf_aqed_ll_cnt_pri3_waddr = '0 ;
pf_aqed_ll_cnt_pri3_we = '0 ;
pf_aqed_ll_cnt_pri3_wdata = '0 ;















pf_aqed_qid_fid_limit_re = '0 ;
pf_aqed_qid_fid_limit_addr = '0 ;
pf_aqed_qid_fid_limit_we = '0 ;
pf_aqed_qid_fid_limit_wdata = '0 ;
pf_aqed_fifo_ap_aqed_re = '0 ;
pf_aqed_fifo_ap_aqed_raddr = '0 ;
pf_aqed_fifo_ap_aqed_waddr = '0 ;
pf_aqed_fifo_ap_aqed_we = '0 ;
pf_aqed_fifo_ap_aqed_wdata = '0 ;
pf_aqed_ll_cnt_pri1_re = '0 ;
pf_aqed_ll_cnt_pri1_raddr = '0 ;
pf_aqed_ll_cnt_pri1_waddr = '0 ;
pf_aqed_ll_cnt_pri1_we = '0 ;
pf_aqed_ll_cnt_pri1_wdata = '0 ;
pf_aqed_ll_qe_tp_pri1_re = '0 ;
pf_aqed_ll_qe_tp_pri1_raddr = '0 ;
pf_aqed_ll_qe_tp_pri1_waddr = '0 ;
pf_aqed_ll_qe_tp_pri1_we = '0 ;
pf_aqed_ll_qe_tp_pri1_wdata = '0 ;















pf_aqed_ll_qe_tp_pri3_re = '0 ;
pf_aqed_ll_qe_tp_pri3_raddr = '0 ;
pf_aqed_ll_qe_tp_pri3_waddr = '0 ;
pf_aqed_ll_qe_tp_pri3_we = '0 ;
pf_aqed_ll_qe_tp_pri3_wdata = '0 ;










pf_aqed_fifo_qed_aqed_enq_fid_re = '0 ;
pf_aqed_fifo_qed_aqed_enq_fid_raddr = '0 ;
pf_aqed_fifo_qed_aqed_enq_fid_waddr = '0 ;
pf_aqed_fifo_qed_aqed_enq_fid_we = '0 ;
pf_aqed_fifo_qed_aqed_enq_fid_wdata = '0 ;





pf_aqed_fid_cnt_re = '0 ;
pf_aqed_fid_cnt_raddr = '0 ;
pf_aqed_fid_cnt_waddr = '0 ;
pf_aqed_fid_cnt_we = '0 ;
pf_aqed_fid_cnt_wdata = '0 ;
pf_aqed_ll_qe_hp_pri2_re = '0 ;
pf_aqed_ll_qe_hp_pri2_raddr = '0 ;
pf_aqed_ll_qe_hp_pri2_waddr = '0 ;
pf_aqed_ll_qe_hp_pri2_we = '0 ;
pf_aqed_ll_qe_hp_pri2_wdata = '0 ;
pf_FUNC_WEN_RF_IN_P0 = '0 ;
pf_FUNC_WR_ADDR_RF_IN_P0 = '0 ;
pf_FUNC_WR_DATA_RF_IN_P0 = '0 ;
pf_FUNC_CEN_RF_IN_P0 = '0 ;
pf_FUNC_CM_DATA_RF_IN_P0 = '0 ;
pf_FUNC_REN_RF_IN_P0 = '0 ;
pf_FUNC_RD_ADDR_RF_IN_P0 = '0 ;

pf_reset_active_0 = '0 ;
pf_reset_active_1 = '0 ;
  if ( hqm_gated_rst_n_start & reset_pf_active_0_f & ~ hw_init_done_0_f ) begin
    reset_pf_counter_0_nxt                        = reset_pf_counter_0_f + 32'b1 ;

    if ( reset_pf_counter_0_f < HQM_AQED_CFG_RST_PFMAX ) begin
      pf_reset_active_0 = 1'b1 ;
      if ( reset_pf_counter_0_f < 32'd256 ) begin
        pf_FUNC_WEN_RF_IN_P0 = { 8 { 1'b1 } } ;
        pf_FUNC_WR_ADDR_RF_IN_P0 = { 8 { reset_pf_counter_0_f [ 7 : 0 ] } } ;
        pf_FUNC_WR_DATA_RF_IN_P0 = { 8 { { 1'b1 , 1'b0 , 1'b0 , 16'd1 , 7'd1 } } } ;
      end

      pf_aqed_ll_cnt_pri0_we                = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_cnt_pri0_waddr             = reset_pf_counter_0_f [ ( HQM_AQED_LL_CNT_PRI0_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_cnt_pri0_wdata             = { 2'b00 , { ( HQM_AQED_LL_CNT_PRI0_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_aqed_ll_cnt_pri1_we                = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_cnt_pri1_waddr             = reset_pf_counter_0_f [ ( HQM_AQED_LL_CNT_PRI1_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_cnt_pri1_wdata             = { 2'b00 , { ( HQM_AQED_LL_CNT_PRI1_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_aqed_ll_cnt_pri2_we                = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_cnt_pri2_waddr             = reset_pf_counter_0_f [ ( HQM_AQED_LL_CNT_PRI2_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_cnt_pri2_wdata             = { 2'b00 , { ( HQM_AQED_LL_CNT_PRI2_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_aqed_ll_cnt_pri3_we                = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_cnt_pri3_waddr             = reset_pf_counter_0_f [ ( HQM_AQED_LL_CNT_PRI3_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_cnt_pri3_wdata             = { 2'b00 , { ( HQM_AQED_LL_CNT_PRI3_DWIDTH - 2 ) { 1'b0 } } } ;

















      pf_aqed_ll_qe_hp_pri0_we              = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_qe_hp_pri0_waddr           = reset_pf_counter_0_f [ ( HQM_AQED_LL_QE_HP_PRI0_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_hp_pri0_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_HP_PRI0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_aqed_ll_qe_hp_pri1_we              = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_qe_hp_pri1_waddr           = reset_pf_counter_0_f [ ( HQM_AQED_LL_QE_HP_PRI1_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_hp_pri1_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_HP_PRI1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_aqed_ll_qe_hp_pri2_we              = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_qe_hp_pri2_waddr           = reset_pf_counter_0_f [ ( HQM_AQED_LL_QE_HP_PRI2_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_hp_pri2_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_HP_PRI2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_aqed_ll_qe_hp_pri3_we              = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_ll_qe_hp_pri3_waddr           = reset_pf_counter_0_f [ ( HQM_AQED_LL_QE_HP_PRI3_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_hp_pri3_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_HP_PRI3_DWIDTH - 1 ) { 1'b0 } } } ;









      pf_aqed_fid_cnt_we                    = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_aqed_fid_cnt_waddr                 = reset_pf_counter_0_f [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_fid_cnt_wdata                 = { 2'd0 , { ( HQM_AQED_FID_CNT_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_aqed_qid_cnt_we                    = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_aqed_qid_cnt_waddr                 = reset_pf_counter_0_f [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_qid_cnt_wdata                 = { 2'd0 , { ( HQM_AQED_QID_CNT_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_aqed_qid_fid_limit_we              = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_aqed_qid_fid_limit_addr            = reset_pf_counter_0_f [ ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_qid_fid_limit_wdata           = { 1'b0 , 13'b0011111111111 } ;
    end
    else begin
      reset_pf_counter_0_nxt                    = reset_pf_counter_0_f ;
      hw_init_done_0_nxt                          = 1'b1 ;
    end
  end

  if ( hqm_gated_rst_n_start & reset_pf_active_1_f & ~ hw_init_done_1_f ) begin
    reset_pf_counter_1_nxt                        = reset_pf_counter_1_f + 32'b1 ;

    if ( reset_pf_counter_1_f < HQM_AQED_CFG_RST_PFMAX ) begin
      pf_reset_active_1 = 1'b1 ;








      pf_aqed_ll_qe_tp_pri0_we              = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_aqed_ll_qe_tp_pri0_waddr           = reset_pf_counter_1_f [ ( HQM_AQED_LL_QE_TP_PRI0_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_tp_pri0_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_TP_PRI0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_aqed_ll_qe_tp_pri1_we              = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_aqed_ll_qe_tp_pri1_waddr           = reset_pf_counter_1_f [ ( HQM_AQED_LL_QE_TP_PRI1_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_tp_pri1_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_TP_PRI1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_aqed_ll_qe_tp_pri2_we              = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_aqed_ll_qe_tp_pri2_waddr           = reset_pf_counter_1_f [ ( HQM_AQED_LL_QE_TP_PRI2_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_tp_pri2_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_TP_PRI2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_aqed_ll_qe_tp_pri3_we              = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_aqed_ll_qe_tp_pri3_waddr           = reset_pf_counter_1_f [ ( HQM_AQED_LL_QE_TP_PRI3_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_tp_pri3_wdata           = { 1'b1 , { ( HQM_AQED_LL_QE_TP_PRI3_DWIDTH - 1 ) { 1'b0 } } } ;

















      pf_aqed_freelist_we                   = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_aqed_freelist_addr                 = reset_pf_counter_1_f [ ( HQM_AQED_FREELIST_DEPTHB2 ) - 1 : 0 ] ;
      ecc_d_default2 = reset_pf_counter_1_f [ ( HQM_AQED_FREELIST_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_freelist_wdata                = { ecc_gen_default2 , reset_pf_counter_1_f [ ( HQM_AQED_FREELIST_DEPTHB2 ) - 1 : 0 ] } ;

      ecc_gen_hcw_l_d_nc                           = 64'd0 ;
      ecc_gen_hcw_h_d_nc                           = 64'd0 ;
      pf_aqed_we                            = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_aqed_addr                          = reset_pf_counter_1_f [ ( HQM_AQED_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_wdata                         = { ecc_gen_hcw_h_ecc , ecc_gen_hcw_l_ecc , 59'd0 , 64'd0 } ;

      pf_aqed_ll_qe_hpnxt_we                = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_aqed_ll_qe_hpnxt_addr              = reset_pf_counter_1_f [ ( HQM_AQED_LL_QE_HPNXT_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_ll_qe_hpnxt_wdata             = { ecc_gen_default , { ( HQM_AQED_DATA ) { 1'b0 } } } ;

    end
    else begin
      reset_pf_counter_1_nxt                    = reset_pf_counter_1_f ;
      hw_init_done_1_nxt                          = 1'b1 ;
    end
  end

   // reset_active is set on reset.
   // reset_active is cleared when hw_init_done_f is set

   if ( reset_pf_active_0_f ) begin
       if ( hw_init_done_0_f ) begin
           reset_pf_counter_0_nxt = 32'd0 ;
           reset_pf_active_0_nxt = 1'b0 ;
           reset_pf_done_0_nxt = 1'b1 ;
           hw_init_done_0_nxt = 1'b0 ;
       end
   end

   if ( reset_pf_active_1_f ) begin
       if ( hw_init_done_1_f ) begin
           reset_pf_counter_1_nxt = 32'd0 ;
           reset_pf_active_1_nxt = 1'b0 ;
           reset_pf_done_1_nxt = 1'b1 ;
           hw_init_done_1_nxt = 1'b0 ;
       end
   end



  aqed_lsp_stop_atqatm_nxt = ( fid_bcam_total_fid > cfg_control0_f [ 21 : 8 ] ) ;
  aqed_lsp_stop_atqatm = aqed_lsp_stop_atqatm_f ;



  //....................................................................................................
  // SMON
  //NOTE: smon_v 0-15 are functional, performance & stall
  //NOTE: smon_v 16+ are FPGA ONLY
if ( hqm_aqed_target_cfg_smon_smon_enabled ) begin
  smon_v_nxt [ 0 * 1 +: 1 ]                          = fifo_qed_aqed_enq_push ;
  smon_comp_nxt [ 0 * 32 +: 32 ]                     = { 25'd0 , fifo_qed_aqed_enq_push_data.cq_hcw.msg_info.qid } ;
  smon_val_nxt [ 0 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 1 * 1 +: 1 ]                          = fifo_aqed_ap_enq_push ;
  smon_comp_nxt [ 1 * 32 +: 32 ]                     = { 25'd0 , fifo_aqed_ap_enq_push_data.qid } ;
  smon_val_nxt [ 1 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 2 * 1 +: 1 ]                          = fifo_ap_aqed_push ;
  smon_comp_nxt [ 2 * 32 +: 32 ]                     = { 25'd0 , fifo_ap_aqed_push_data.qid } ;
  smon_val_nxt [ 2 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 3 * 1 +: 1 ]                          = fifo_aqed_chp_sch_push ;
  smon_comp_nxt [ 3 * 32 +: 32 ]                     = { 25'd0 , fifo_aqed_chp_sch_push_data.qid } ;
  smon_val_nxt [ 3 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 4 * 1 +: 1 ]                          = db_aqed_lsp_sch_valid & ~ db_aqed_lsp_sch_ready ;
  smon_comp_nxt [ 4 * 32 +: 32 ]                     = { 32'd0 } ;
  smon_val_nxt [ 4 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 5 * 1 +: 1 ]                          = db_lsp_aqed_cmp_v & ~ db_lsp_aqed_cmp_ready ;
  smon_comp_nxt [ 5 * 32 +: 32 ]                     = { 32'd0 } ;
  smon_val_nxt [ 5 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 6 * 1 +: 1 ]                          = 1'b1 ;
  smon_comp_nxt [ 6 * 32 +: 32 ]                     = { 32'd0 } ;
  smon_val_nxt [ 6 * 32 +: 32 ]                      = { 18'd0 , fid_bcam_total_qid } ;

  smon_v_nxt [ 7 * 1 +: 1 ]                          = in_cmp_v & in_cmp_ack ;
  smon_comp_nxt [ 7 * 32 +: 32 ]                     = { 32'd0 } ;
  smon_val_nxt [ 7 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 8 * 1 +: 1 ]                          = in_enq_v & in_enq_ack ;
  smon_comp_nxt [ 8 * 32 +: 32 ]                     = { 32'd0 } ;
  smon_val_nxt [ 8 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 9 * 1 +: 1 ]                          = debug_hit ;
  smon_comp_nxt [ 9 * 32 +: 32 ]                     = { 32'd0 } ;
  smon_val_nxt [ 9 * 32 +: 32 ]                      = 32'd1 ;

  smon_v_nxt [ 10 * 1 +: 1 ]                         = db_ap_aqed_valid & ~ db_ap_aqed_ready ;
  smon_comp_nxt [ 10 * 32 +: 32 ]                    = { 32'd0 } ;
  smon_val_nxt [ 10 * 32 +: 32 ]                     = 32'd1 ;

  smon_v_nxt [ 11 * 1 +: 1 ]                         = rx_sync_qed_aqed_enq_valid & ~ rx_sync_qed_aqed_enq_ready ;
  smon_comp_nxt [ 11 * 32 +: 32 ]                    = { 32'd0 } ;
  smon_val_nxt [ 11 * 32 +: 32 ]                     = 32'd1 ;

  smon_v_nxt [ 12 * 1 +: 1 ]                         = db_aqed_ap_enq_valid & ~ db_aqed_ap_enq_ready ;
  smon_comp_nxt [ 12 * 32 +: 32 ]                    = { 32'd0 } ;
  smon_val_nxt [ 12 * 32 +: 32 ]                     = 32'd1 ;

  smon_v_nxt [ 13 * 1 +: 1 ]                         = db_aqed_chp_sch_valid & ~ db_aqed_chp_sch_ready ;
  smon_comp_nxt [ 13 * 32 +: 32 ]                    = { 32'd0 } ;
  smon_val_nxt [ 13 * 32 +: 32 ]                     = 32'd1 ;

  smon_v_nxt [ 14 * 1 +: 1 ]                         = db_aqed_lsp_sch_valid & ~ db_aqed_lsp_sch_ready ;
  smon_comp_nxt [ 14 * 32 +: 32 ]                    = { 32'd0 } ;
  smon_val_nxt [ 14 * 32 +: 32 ]                     = 32'd1 ;

  smon_v_nxt [ 15 * 1 +: 1 ]                         = p10_stall_f [ 5 ] ;
  smon_comp_nxt [ 15 * 32 +: 32 ]                    = { 32'd0 } ;
  smon_val_nxt [ 15 * 32 +: 32 ]                     = 32'd1 ;
end

  //control CFG access. Queue the CFG access until the pipe is idle then issue the reqeust and keep the pipe idle until complete
  cfg_req_ready = cfg_unit_idle_f.cfg_ready ;
  cfg_unit_idle_nxt.cfg_ready                   = ( ( cfg_unit_idle_nxt.pipe_idle  )
                                                  )  ;


  // top level ports , NOTE: dont use 'hqm_gated_rst_n_active' in "local" aqed_unit_idle since LSP turns clocks on, only send indication that PF reset is running
  // hqm_gated_rst_n_active is included into cfg_unit_idle_f.unit_idle to cover gap after hqm_gated_clk is on (from lsp) until PF reset SM starts
  aqed_reset_done = ~ ( hqm_gated_rst_n_active ) ;
  aqed_unit_idle = cfg_unit_idle_f.unit_idle &  ~ ( pf_reset_active_0 | pf_reset_active_1 ) & unit_idle_hqm_clk_inp_gated ;
  aqed_unit_pipeidle = cfg_unit_idle_f.pipe_idle ;

  //LSP controls clock for ap & aqed
  // send aqed_clk_idle to indicate that hqm_gated_clk pipeline is active or need to turn on clocks for CFG access or RX_SYNC
  aqed_clk_idle = cfg_unit_idle_f.unit_idle & ( cfg_rx_idle & rx_sync_qed_aqed_enq_idle ) ;





  cfg_interface_nxt                             = { aqed_clk_idle
                                                   , fifo_freelist_return_empty
                                                   , ~ fifo_qed_aqed_enq_pop_data_v
                                                   , fifo_aqed_ap_enq_empty
                                                   , fifo_ap_aqed_empty
                                                   , fifo_aqed_chp_sch_empty
                                                   , fifo_qed_aqed_enq_fid_empty
                                                   , fifo_lsp_aqed_cmp_empty

                                                  , 1'b0 , db_lsp_aqed_cmp_status_pnc [ 2 : 0 ] 
                                                  , 1'b0 , db_ap_aqed_status_pnc [ 2 : 0 ]
                                                  , 1'b0 , ~ rx_sync_qed_aqed_enq_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_qed_aqed_enq_idle
                                                  , 1'b0 , db_aqed_ap_enq_status_pnc [ 2 : 0 ]
                                                  , 1'b0 , db_aqed_chp_sch_status_pnc [ 2 : 0 ] 
                                                  , 1'b0 , db_aqed_lsp_sch_status_pnc [ 2 : 0 ]
                                                  } ;

end

always_comb begin : L9928
  mf_cfg_req = '0 ;
  mf_cfg_req_write = '0 ;
  mf_cfg_req_read = '0 ;

end


//tieoff machine inserted code 
logic tieoff_nc ;
assign tieoff_nc = (
  ( | func_DATA_RF_OUT_P0 )
// only partially used with 4 bins
| ( | func_aqed_ll_cnt_we )
| ( | func_aqed_ll_cnt_waddr )
| ( | func_aqed_ll_cnt_wdata )
| ( | func_aqed_ll_cnt_re )
| ( | func_aqed_ll_cnt_raddr )
| ( | func_aqed_ll_qe_hp_we )
| ( | func_aqed_ll_qe_hp_waddr )
| ( | func_aqed_ll_qe_hp_wdata )
| ( | func_aqed_ll_qe_hp_re )
| ( | func_aqed_ll_qe_hp_raddr )
| ( | func_aqed_ll_qe_tp_we )
| ( | func_aqed_ll_qe_tp_waddr )
| ( | func_aqed_ll_qe_tp_wdata )
| ( | func_aqed_ll_qe_tp_re )
| ( | func_aqed_ll_qe_tp_raddr )
//reuse modules inserted by script cannot include _nc
| ( | hqm_aqed_target_cfg_syndrome_00_syndrome_data )
| ( | hqm_aqed_target_cfg_syndrome_01_syndrome_data )
| ( | pf_aqed_rdata )
| ( | pf_aqed_ll_qe_hpnxt_rdata )
| ( | pf_aqed_freelist_rdata )
| ( | pf_aqed_fifo_freelist_return_rdata )
| ( | pf_aqed_qid_fid_limit_rdata )
| ( | pf_rx_sync_qed_aqed_enq_rdata )
| ( | pf_aqed_fifo_qed_aqed_enq_rdata )
| ( | pf_aqed_ll_qe_hp_pri0_rdata )
| ( | pf_aqed_fifo_ap_aqed_rdata )
| ( | pf_aqed_ll_cnt_pri1_rdata )
| ( | pf_aqed_ll_qe_tp_pri1_rdata )
| ( | pf_aqed_ll_cnt_pri0_rdata )
| ( | pf_aqed_ll_qe_tp_pri3_rdata )
| ( | pf_aqed_fifo_aqed_ap_enq_rdata )
| ( | pf_aqed_ll_qe_tp_pri2_rdata )
| ( | pf_aqed_ll_qe_hp_pri1_rdata )
| ( | pf_aqed_ll_cnt_pri2_rdata )
| ( | pf_aqed_qid_cnt_rdata )
| ( | pf_aqed_fifo_aqed_chp_sch_rdata )
| ( | pf_aqed_fifo_lsp_aqed_cmp_rdata )
| ( | pf_aqed_fifo_qed_aqed_enq_fid_rdata )
| ( | pf_aqed_fid_cnt_rdata )
| ( | pf_aqed_ll_qe_hp_pri2_rdata )
| ( | pf_aqed_ll_qe_tp_pri0_rdata )
| ( | pf_aqed_ll_qe_hp_pri3_rdata )
| ( | pf_aqed_ll_cnt_pri3_rdata )
| ( | pf_CM_MATCH_RF_OUT_P0 )
| ( | pf_DATA_RF_OUT_P0 )
| ( | cfg_req_read )
| ( | cfg_req_write )
//cannot mark part of struct with _nc for pipe levels it is not used
| ( p12_ll_ctrl [1] )
| ( p0_ll_ctrl [1] )
| ( p11_ll_ctrl [1] )
| ( p6_ll_ctrl [1] )
| ( p4_ll_ctrl [1] )
| ( p8_ll_ctrl [1] )
| ( p2_ll_ctrl [1] )
| ( p9_ll_ctrl [1] )
| ( p13_ll_ctrl [1] )
| ( p7_ll_ctrl [1] )
| ( p5_ll_ctrl [1] )
| ( p3_ll_ctrl [1] )
| ( p1_ll_ctrl [1] )
) ;




endmodule // hqm_aqed_pipe_core

