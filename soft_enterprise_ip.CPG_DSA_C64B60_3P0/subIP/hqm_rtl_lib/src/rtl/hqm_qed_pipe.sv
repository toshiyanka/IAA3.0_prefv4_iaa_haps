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
// hqm_qed_pipe
//
//
// Interface requirement
//
//
//-----------------------------------------------------------------------------------------------------

module hqm_qed_pipe
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(

    input  logic hqm_gated_clk_qed
  , output logic hqm_proc_clk_en_qed
  , input  logic hqm_rst_prep_qed
  , input  logic hqm_gated_rst_b_qed
  , input  logic hqm_inp_gated_rst_b_qed

  , input  logic hqm_gated_clk_nalb
  , output logic hqm_proc_clk_en_nalb
  , input  logic hqm_rst_prep_nalb
  , input  logic hqm_gated_rst_b_nalb
  , input  logic hqm_inp_gated_rst_b_nalb

  , input  logic hqm_gated_clk_dir
  , output logic hqm_proc_clk_en_dir
  , input  logic hqm_rst_prep_dir
  , input  logic hqm_gated_rst_b_dir
  , input  logic hqm_inp_gated_rst_b_dir

  , input  logic hqm_inp_gated_clk

  , input  logic hqm_gated_rst_b_start_qed
  , input  logic hqm_gated_rst_b_active_qed
  , output logic hqm_gated_rst_b_done_qed

  , input  logic hqm_gated_rst_b_start_nalb
  , input  logic hqm_gated_rst_b_active_nalb
  , output logic hqm_gated_rst_b_done_nalb

  , input  logic hqm_gated_rst_b_start_dir
  , input  logic hqm_gated_rst_b_active_dir
  , output logic hqm_gated_rst_b_done_dir

  , input  logic rop_qed_force_clockon

  , output  logic                           qed_lsp_deq_v
  , output  logic [BITS_QED_LSP_DEQ_T-1:0]  qed_lsp_deq_data

  , output logic                        qed_unit_idle
  , output logic                        qed_unit_pipeidle
  , output logic                        qed_reset_done

  , output logic                        nalb_unit_idle
  , output logic                        nalb_unit_pipeidle
  , output logic                        nalb_reset_done

  , output logic                        dp_unit_idle
  , output logic                        dp_unit_pipeidle
  , output logic                        dp_reset_done

  // CFG interface
  , input  logic                        qed_cfg_req_up_read
  , input  logic                        qed_cfg_req_up_write
  , input  logic [BITS_CFG_REQ_T-1:0]   qed_cfg_req_up
  , input  logic                        qed_cfg_rsp_up_ack
  , input  logic [BITS_CFG_RSP_T-1:0]   qed_cfg_rsp_up
  , output logic                        qed_cfg_req_down_read
  , output logic                        qed_cfg_req_down_write
  , output logic [BITS_CFG_REQ_T-1:0]   qed_cfg_req_down
  , output logic                        qed_cfg_rsp_down_ack
  , output logic [BITS_CFG_RSP_T-1:0]   qed_cfg_rsp_down

  // interrupt interface
  , input  logic                        qed_alarm_up_v
  , output logic                        qed_alarm_up_ready
  , input  logic [BITS_AW_ALARM_T-1:0]  qed_alarm_up_data

  , output logic                        qed_alarm_down_v
  , input  logic                        qed_alarm_down_ready
  , output logic [BITS_AW_ALARM_T-1:0]  qed_alarm_down_data

  // rop_qed_dqed_enq interface
  , input  logic                        rop_qed_dqed_enq_v
  , output logic                        rop_qed_enq_ready
  , output logic                        rop_dqed_enq_ready
  , input  logic [BITS_ROP_QED_DQED_ENQ_T-1:0]  rop_qed_dqed_enq_data

  // qed_chp_sch interface
  , output logic                        qed_chp_sch_v
  , input  logic                        qed_chp_sch_ready
  , output logic [BITS_QED_CHP_SCH_T-1:0]   qed_chp_sch_data

  // qed_aqed_enq interface
  , output logic                        qed_aqed_enq_v
  , input  logic                        qed_aqed_enq_ready
  , output logic [BITS_QED_AQED_ENQ_T-1:0]  qed_aqed_enq_data

  // rop_dp_enq interface
  , input  logic                        rop_dp_enq_v
  , output logic                        rop_dp_enq_ready
  , input  logic [BITS_ROP_DP_ENQ_T-1:0]   rop_dp_enq_data

  // lsp_dp_sch_dir interface
  , input  logic                        lsp_dp_sch_dir_v
  , output logic                        lsp_dp_sch_dir_ready
  , input  logic [BITS_LSP_DP_SCH_DIR_T-1:0]   lsp_dp_sch_dir_data

  // lsp_dp_sch_rorply interface
  , input  logic                        lsp_dp_sch_rorply_v
  , output logic                        lsp_dp_sch_rorply_ready
  , input  logic [BITS_LSP_DP_SCH_RORPLY_T-1:0]    lsp_dp_sch_rorply_data

  // dp_lsp_enq interface
  , output logic                        dp_lsp_enq_dir_v
  , input  logic                        dp_lsp_enq_dir_ready
  , output logic [BITS_DP_LSP_ENQ_DIR_T-1:0]   dp_lsp_enq_dir_data

  // dp_lsp_enq interface
  , output logic                        dp_lsp_enq_rorply_v
  , input  logic                        dp_lsp_enq_rorply_ready
  , output logic [BITS_DP_LSP_ENQ_RORPLY_T-1:0]    dp_lsp_enq_rorply_data

  // rop_nalb_enq interface
  , input  logic                        rop_nalb_enq_v
  , output logic                        rop_nalb_enq_ready
  , input  logic [BITS_ROP_NALB_ENQ_T-1:0]  rop_nalb_enq_data

  // lsp_nalb_sch_unoord interface
  , input  logic                        lsp_nalb_sch_unoord_v
  , output logic                        lsp_nalb_sch_unoord_ready
  , input  logic [BITS_LSP_NALB_SCH_UNOORD_T-1:0]   lsp_nalb_sch_unoord_data

  // lsp_nalb_sch_rorply interface
  , input  logic                        lsp_nalb_sch_rorply_v
  , output logic                        lsp_nalb_sch_rorply_ready
  , input  logic [BITS_LSP_NALB_SCH_RORPLY_T-1:0]   lsp_nalb_sch_rorply_data

  // lsp_nalb_sch_atq interface
  , input  logic                        lsp_nalb_sch_atq_v
  , output logic                        lsp_nalb_sch_atq_ready
  , input  logic [BITS_LSP_NALB_SCH_ATQ_T-1:0]  lsp_nalb_sch_atq_data

  // nalb_lsp_enq interface
  , output logic                        nalb_lsp_enq_lb_v
  , input  logic                        nalb_lsp_enq_lb_ready
  , output logic [BITS_NALB_LSP_ENQ_LB_T-1:0]   nalb_lsp_enq_lb_data

  // nalb_lsp_enq interface
  , output logic                        nalb_lsp_enq_rorply_v
  , input  logic                        nalb_lsp_enq_rorply_ready
  , output logic [BITS_NALB_LSP_ENQ_RORPLY_T-1:0]   nalb_lsp_enq_rorply_data

  // Spares

  , input  logic [1:0]                  spare_lsp_qed
  , input  logic [1:0]                  spare_sys_qed

  , output logic [1:0]                  spare_qed_lsp
  , output logic [1:0]                  spare_qed_sys

// BEGIN HQM_MEMPORT_DECL hqm_qed_pipe_core
    ,output logic                  rf_qed_chp_sch_data_re
    ,output logic                  rf_qed_chp_sch_data_rclk
    ,output logic                  rf_qed_chp_sch_data_rclk_rst_n
    ,output logic [(       3)-1:0] rf_qed_chp_sch_data_raddr
    ,output logic [(       3)-1:0] rf_qed_chp_sch_data_waddr
    ,output logic                  rf_qed_chp_sch_data_we
    ,output logic                  rf_qed_chp_sch_data_wclk
    ,output logic                  rf_qed_chp_sch_data_wclk_rst_n
    ,output logic [(     177)-1:0] rf_qed_chp_sch_data_wdata
    ,input  logic [(     177)-1:0] rf_qed_chp_sch_data_rdata

    ,output logic                  rf_rx_sync_dp_dqed_data_re
    ,output logic                  rf_rx_sync_dp_dqed_data_rclk
    ,output logic                  rf_rx_sync_dp_dqed_data_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_dp_dqed_data_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_dp_dqed_data_waddr
    ,output logic                  rf_rx_sync_dp_dqed_data_we
    ,output logic                  rf_rx_sync_dp_dqed_data_wclk
    ,output logic                  rf_rx_sync_dp_dqed_data_wclk_rst_n
    ,output logic [(      45)-1:0] rf_rx_sync_dp_dqed_data_wdata
    ,input  logic [(      45)-1:0] rf_rx_sync_dp_dqed_data_rdata

    ,output logic                  rf_rx_sync_nalb_qed_data_re
    ,output logic                  rf_rx_sync_nalb_qed_data_rclk
    ,output logic                  rf_rx_sync_nalb_qed_data_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_nalb_qed_data_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_nalb_qed_data_waddr
    ,output logic                  rf_rx_sync_nalb_qed_data_we
    ,output logic                  rf_rx_sync_nalb_qed_data_wclk
    ,output logic                  rf_rx_sync_nalb_qed_data_wclk_rst_n
    ,output logic [(      45)-1:0] rf_rx_sync_nalb_qed_data_wdata
    ,input  logic [(      45)-1:0] rf_rx_sync_nalb_qed_data_rdata

    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_re
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_rclk
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_rop_qed_dqed_enq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_rop_qed_dqed_enq_waddr
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_we
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_wclk
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n
    ,output logic [(     157)-1:0] rf_rx_sync_rop_qed_dqed_enq_wdata
    ,input  logic [(     157)-1:0] rf_rx_sync_rop_qed_dqed_enq_rdata

    ,output logic                  sr_qed_0_re
    ,output logic                  sr_qed_0_clk
    ,output logic                  sr_qed_0_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_0_addr
    ,output logic                  sr_qed_0_we
    ,output logic [(     139)-1:0] sr_qed_0_wdata
    ,input  logic [(     139)-1:0] sr_qed_0_rdata

    ,output logic                  sr_qed_1_re
    ,output logic                  sr_qed_1_clk
    ,output logic                  sr_qed_1_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_1_addr
    ,output logic                  sr_qed_1_we
    ,output logic [(     139)-1:0] sr_qed_1_wdata
    ,input  logic [(     139)-1:0] sr_qed_1_rdata

    ,output logic                  sr_qed_2_re
    ,output logic                  sr_qed_2_clk
    ,output logic                  sr_qed_2_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_2_addr
    ,output logic                  sr_qed_2_we
    ,output logic [(     139)-1:0] sr_qed_2_wdata
    ,input  logic [(     139)-1:0] sr_qed_2_rdata

    ,output logic                  sr_qed_3_re
    ,output logic                  sr_qed_3_clk
    ,output logic                  sr_qed_3_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_3_addr
    ,output logic                  sr_qed_3_we
    ,output logic [(     139)-1:0] sr_qed_3_wdata
    ,input  logic [(     139)-1:0] sr_qed_3_rdata

    ,output logic                  sr_qed_4_re
    ,output logic                  sr_qed_4_clk
    ,output logic                  sr_qed_4_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_4_addr
    ,output logic                  sr_qed_4_we
    ,output logic [(     139)-1:0] sr_qed_4_wdata
    ,input  logic [(     139)-1:0] sr_qed_4_rdata

    ,output logic                  sr_qed_5_re
    ,output logic                  sr_qed_5_clk
    ,output logic                  sr_qed_5_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_5_addr
    ,output logic                  sr_qed_5_we
    ,output logic [(     139)-1:0] sr_qed_5_wdata
    ,input  logic [(     139)-1:0] sr_qed_5_rdata

    ,output logic                  sr_qed_6_re
    ,output logic                  sr_qed_6_clk
    ,output logic                  sr_qed_6_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_6_addr
    ,output logic                  sr_qed_6_we
    ,output logic [(     139)-1:0] sr_qed_6_wdata
    ,input  logic [(     139)-1:0] sr_qed_6_rdata

    ,output logic                  sr_qed_7_re
    ,output logic                  sr_qed_7_clk
    ,output logic                  sr_qed_7_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_7_addr
    ,output logic                  sr_qed_7_we
    ,output logic [(     139)-1:0] sr_qed_7_wdata
    ,input  logic [(     139)-1:0] sr_qed_7_rdata

// END HQM_MEMPORT_DECL hqm_qed_pipe_core
// BEGIN HQM_MEMPORT_DECL hqm_nalb_pipe_core
    ,output logic                  rf_atq_cnt_re
    ,output logic                  rf_atq_cnt_rclk
    ,output logic                  rf_atq_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_atq_cnt_raddr
    ,output logic [(       5)-1:0] rf_atq_cnt_waddr
    ,output logic                  rf_atq_cnt_we
    ,output logic                  rf_atq_cnt_wclk
    ,output logic                  rf_atq_cnt_wclk_rst_n
    ,output logic [(      68)-1:0] rf_atq_cnt_wdata
    ,input  logic [(      68)-1:0] rf_atq_cnt_rdata

    ,output logic                  rf_atq_hp_re
    ,output logic                  rf_atq_hp_rclk
    ,output logic                  rf_atq_hp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_atq_hp_raddr
    ,output logic [(       7)-1:0] rf_atq_hp_waddr
    ,output logic                  rf_atq_hp_we
    ,output logic                  rf_atq_hp_wclk
    ,output logic                  rf_atq_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_atq_hp_wdata
    ,input  logic [(      15)-1:0] rf_atq_hp_rdata

    ,output logic                  rf_atq_tp_re
    ,output logic                  rf_atq_tp_rclk
    ,output logic                  rf_atq_tp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_atq_tp_raddr
    ,output logic [(       7)-1:0] rf_atq_tp_waddr
    ,output logic                  rf_atq_tp_we
    ,output logic                  rf_atq_tp_wclk
    ,output logic                  rf_atq_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_atq_tp_wdata
    ,input  logic [(      15)-1:0] rf_atq_tp_rdata

    ,output logic                  rf_lsp_nalb_sch_atq_re
    ,output logic                  rf_lsp_nalb_sch_atq_rclk
    ,output logic                  rf_lsp_nalb_sch_atq_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lsp_nalb_sch_atq_raddr
    ,output logic [(       5)-1:0] rf_lsp_nalb_sch_atq_waddr
    ,output logic                  rf_lsp_nalb_sch_atq_we
    ,output logic                  rf_lsp_nalb_sch_atq_wclk
    ,output logic                  rf_lsp_nalb_sch_atq_wclk_rst_n
    ,output logic [(       8)-1:0] rf_lsp_nalb_sch_atq_wdata
    ,input  logic [(       8)-1:0] rf_lsp_nalb_sch_atq_rdata

    ,output logic                  rf_lsp_nalb_sch_rorply_re
    ,output logic                  rf_lsp_nalb_sch_rorply_rclk
    ,output logic                  rf_lsp_nalb_sch_rorply_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lsp_nalb_sch_rorply_raddr
    ,output logic [(       2)-1:0] rf_lsp_nalb_sch_rorply_waddr
    ,output logic                  rf_lsp_nalb_sch_rorply_we
    ,output logic                  rf_lsp_nalb_sch_rorply_wclk
    ,output logic                  rf_lsp_nalb_sch_rorply_wclk_rst_n
    ,output logic [(       8)-1:0] rf_lsp_nalb_sch_rorply_wdata
    ,input  logic [(       8)-1:0] rf_lsp_nalb_sch_rorply_rdata

    ,output logic                  rf_lsp_nalb_sch_unoord_re
    ,output logic                  rf_lsp_nalb_sch_unoord_rclk
    ,output logic                  rf_lsp_nalb_sch_unoord_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lsp_nalb_sch_unoord_raddr
    ,output logic [(       2)-1:0] rf_lsp_nalb_sch_unoord_waddr
    ,output logic                  rf_lsp_nalb_sch_unoord_we
    ,output logic                  rf_lsp_nalb_sch_unoord_wclk
    ,output logic                  rf_lsp_nalb_sch_unoord_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lsp_nalb_sch_unoord_wdata
    ,input  logic [(      27)-1:0] rf_lsp_nalb_sch_unoord_rdata

    ,output logic                  rf_nalb_cnt_re
    ,output logic                  rf_nalb_cnt_rclk
    ,output logic                  rf_nalb_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_nalb_cnt_raddr
    ,output logic [(       5)-1:0] rf_nalb_cnt_waddr
    ,output logic                  rf_nalb_cnt_we
    ,output logic                  rf_nalb_cnt_wclk
    ,output logic                  rf_nalb_cnt_wclk_rst_n
    ,output logic [(      68)-1:0] rf_nalb_cnt_wdata
    ,input  logic [(      68)-1:0] rf_nalb_cnt_rdata

    ,output logic                  rf_nalb_hp_re
    ,output logic                  rf_nalb_hp_rclk
    ,output logic                  rf_nalb_hp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_nalb_hp_raddr
    ,output logic [(       7)-1:0] rf_nalb_hp_waddr
    ,output logic                  rf_nalb_hp_we
    ,output logic                  rf_nalb_hp_wclk
    ,output logic                  rf_nalb_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_nalb_hp_wdata
    ,input  logic [(      15)-1:0] rf_nalb_hp_rdata

    ,output logic                  rf_nalb_lsp_enq_rorply_re
    ,output logic                  rf_nalb_lsp_enq_rorply_rclk
    ,output logic                  rf_nalb_lsp_enq_rorply_rclk_rst_n
    ,output logic [(       5)-1:0] rf_nalb_lsp_enq_rorply_raddr
    ,output logic [(       5)-1:0] rf_nalb_lsp_enq_rorply_waddr
    ,output logic                  rf_nalb_lsp_enq_rorply_we
    ,output logic                  rf_nalb_lsp_enq_rorply_wclk
    ,output logic                  rf_nalb_lsp_enq_rorply_wclk_rst_n
    ,output logic [(      27)-1:0] rf_nalb_lsp_enq_rorply_wdata
    ,input  logic [(      27)-1:0] rf_nalb_lsp_enq_rorply_rdata

    ,output logic                  rf_nalb_lsp_enq_unoord_re
    ,output logic                  rf_nalb_lsp_enq_unoord_rclk
    ,output logic                  rf_nalb_lsp_enq_unoord_rclk_rst_n
    ,output logic [(       5)-1:0] rf_nalb_lsp_enq_unoord_raddr
    ,output logic [(       5)-1:0] rf_nalb_lsp_enq_unoord_waddr
    ,output logic                  rf_nalb_lsp_enq_unoord_we
    ,output logic                  rf_nalb_lsp_enq_unoord_wclk
    ,output logic                  rf_nalb_lsp_enq_unoord_wclk_rst_n
    ,output logic [(      10)-1:0] rf_nalb_lsp_enq_unoord_wdata
    ,input  logic [(      10)-1:0] rf_nalb_lsp_enq_unoord_rdata

    ,output logic                  rf_nalb_qed_re
    ,output logic                  rf_nalb_qed_rclk
    ,output logic                  rf_nalb_qed_rclk_rst_n
    ,output logic [(       5)-1:0] rf_nalb_qed_raddr
    ,output logic [(       5)-1:0] rf_nalb_qed_waddr
    ,output logic                  rf_nalb_qed_we
    ,output logic                  rf_nalb_qed_wclk
    ,output logic                  rf_nalb_qed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_nalb_qed_wdata
    ,input  logic [(      45)-1:0] rf_nalb_qed_rdata

    ,output logic                  rf_nalb_replay_cnt_re
    ,output logic                  rf_nalb_replay_cnt_rclk
    ,output logic                  rf_nalb_replay_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_nalb_replay_cnt_raddr
    ,output logic [(       5)-1:0] rf_nalb_replay_cnt_waddr
    ,output logic                  rf_nalb_replay_cnt_we
    ,output logic                  rf_nalb_replay_cnt_wclk
    ,output logic                  rf_nalb_replay_cnt_wclk_rst_n
    ,output logic [(      68)-1:0] rf_nalb_replay_cnt_wdata
    ,input  logic [(      68)-1:0] rf_nalb_replay_cnt_rdata

    ,output logic                  rf_nalb_replay_hp_re
    ,output logic                  rf_nalb_replay_hp_rclk
    ,output logic                  rf_nalb_replay_hp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_nalb_replay_hp_raddr
    ,output logic [(       7)-1:0] rf_nalb_replay_hp_waddr
    ,output logic                  rf_nalb_replay_hp_we
    ,output logic                  rf_nalb_replay_hp_wclk
    ,output logic                  rf_nalb_replay_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_nalb_replay_hp_wdata
    ,input  logic [(      15)-1:0] rf_nalb_replay_hp_rdata

    ,output logic                  rf_nalb_replay_tp_re
    ,output logic                  rf_nalb_replay_tp_rclk
    ,output logic                  rf_nalb_replay_tp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_nalb_replay_tp_raddr
    ,output logic [(       7)-1:0] rf_nalb_replay_tp_waddr
    ,output logic                  rf_nalb_replay_tp_we
    ,output logic                  rf_nalb_replay_tp_wclk
    ,output logic                  rf_nalb_replay_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_nalb_replay_tp_wdata
    ,input  logic [(      15)-1:0] rf_nalb_replay_tp_rdata

    ,output logic                  rf_nalb_rofrag_cnt_re
    ,output logic                  rf_nalb_rofrag_cnt_rclk
    ,output logic                  rf_nalb_rofrag_cnt_rclk_rst_n
    ,output logic [(       9)-1:0] rf_nalb_rofrag_cnt_raddr
    ,output logic [(       9)-1:0] rf_nalb_rofrag_cnt_waddr
    ,output logic                  rf_nalb_rofrag_cnt_we
    ,output logic                  rf_nalb_rofrag_cnt_wclk
    ,output logic                  rf_nalb_rofrag_cnt_wclk_rst_n
    ,output logic [(      17)-1:0] rf_nalb_rofrag_cnt_wdata
    ,input  logic [(      17)-1:0] rf_nalb_rofrag_cnt_rdata

    ,output logic                  rf_nalb_rofrag_hp_re
    ,output logic                  rf_nalb_rofrag_hp_rclk
    ,output logic                  rf_nalb_rofrag_hp_rclk_rst_n
    ,output logic [(       9)-1:0] rf_nalb_rofrag_hp_raddr
    ,output logic [(       9)-1:0] rf_nalb_rofrag_hp_waddr
    ,output logic                  rf_nalb_rofrag_hp_we
    ,output logic                  rf_nalb_rofrag_hp_wclk
    ,output logic                  rf_nalb_rofrag_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_nalb_rofrag_hp_wdata
    ,input  logic [(      15)-1:0] rf_nalb_rofrag_hp_rdata

    ,output logic                  rf_nalb_rofrag_tp_re
    ,output logic                  rf_nalb_rofrag_tp_rclk
    ,output logic                  rf_nalb_rofrag_tp_rclk_rst_n
    ,output logic [(       9)-1:0] rf_nalb_rofrag_tp_raddr
    ,output logic [(       9)-1:0] rf_nalb_rofrag_tp_waddr
    ,output logic                  rf_nalb_rofrag_tp_we
    ,output logic                  rf_nalb_rofrag_tp_wclk
    ,output logic                  rf_nalb_rofrag_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_nalb_rofrag_tp_wdata
    ,input  logic [(      15)-1:0] rf_nalb_rofrag_tp_rdata

    ,output logic                  rf_nalb_tp_re
    ,output logic                  rf_nalb_tp_rclk
    ,output logic                  rf_nalb_tp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_nalb_tp_raddr
    ,output logic [(       7)-1:0] rf_nalb_tp_waddr
    ,output logic                  rf_nalb_tp_we
    ,output logic                  rf_nalb_tp_wclk
    ,output logic                  rf_nalb_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_nalb_tp_wdata
    ,input  logic [(      15)-1:0] rf_nalb_tp_rdata

    ,output logic                  rf_rop_nalb_enq_ro_re
    ,output logic                  rf_rop_nalb_enq_ro_rclk
    ,output logic                  rf_rop_nalb_enq_ro_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_nalb_enq_ro_raddr
    ,output logic [(       2)-1:0] rf_rop_nalb_enq_ro_waddr
    ,output logic                  rf_rop_nalb_enq_ro_we
    ,output logic                  rf_rop_nalb_enq_ro_wclk
    ,output logic                  rf_rop_nalb_enq_ro_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rop_nalb_enq_ro_wdata
    ,input  logic [(     100)-1:0] rf_rop_nalb_enq_ro_rdata

    ,output logic                  rf_rop_nalb_enq_unoord_re
    ,output logic                  rf_rop_nalb_enq_unoord_rclk
    ,output logic                  rf_rop_nalb_enq_unoord_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_nalb_enq_unoord_raddr
    ,output logic [(       2)-1:0] rf_rop_nalb_enq_unoord_waddr
    ,output logic                  rf_rop_nalb_enq_unoord_we
    ,output logic                  rf_rop_nalb_enq_unoord_wclk
    ,output logic                  rf_rop_nalb_enq_unoord_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rop_nalb_enq_unoord_wdata
    ,input  logic [(     100)-1:0] rf_rop_nalb_enq_unoord_rdata

    ,output logic                  rf_rx_sync_lsp_nalb_sch_atq_re
    ,output logic                  rf_rx_sync_lsp_nalb_sch_atq_rclk
    ,output logic                  rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_nalb_sch_atq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_nalb_sch_atq_waddr
    ,output logic                  rf_rx_sync_lsp_nalb_sch_atq_we
    ,output logic                  rf_rx_sync_lsp_nalb_sch_atq_wclk
    ,output logic                  rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n
    ,output logic [(       8)-1:0] rf_rx_sync_lsp_nalb_sch_atq_wdata
    ,input  logic [(       8)-1:0] rf_rx_sync_lsp_nalb_sch_atq_rdata

    ,output logic                  rf_rx_sync_lsp_nalb_sch_rorply_re
    ,output logic                  rf_rx_sync_lsp_nalb_sch_rorply_rclk
    ,output logic                  rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_nalb_sch_rorply_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_nalb_sch_rorply_waddr
    ,output logic                  rf_rx_sync_lsp_nalb_sch_rorply_we
    ,output logic                  rf_rx_sync_lsp_nalb_sch_rorply_wclk
    ,output logic                  rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n
    ,output logic [(       8)-1:0] rf_rx_sync_lsp_nalb_sch_rorply_wdata
    ,input  logic [(       8)-1:0] rf_rx_sync_lsp_nalb_sch_rorply_rdata

    ,output logic                  rf_rx_sync_lsp_nalb_sch_unoord_re
    ,output logic                  rf_rx_sync_lsp_nalb_sch_unoord_rclk
    ,output logic                  rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_nalb_sch_unoord_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_nalb_sch_unoord_waddr
    ,output logic                  rf_rx_sync_lsp_nalb_sch_unoord_we
    ,output logic                  rf_rx_sync_lsp_nalb_sch_unoord_wclk
    ,output logic                  rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n
    ,output logic [(      27)-1:0] rf_rx_sync_lsp_nalb_sch_unoord_wdata
    ,input  logic [(      27)-1:0] rf_rx_sync_lsp_nalb_sch_unoord_rdata

    ,output logic                  rf_rx_sync_rop_nalb_enq_re
    ,output logic                  rf_rx_sync_rop_nalb_enq_rclk
    ,output logic                  rf_rx_sync_rop_nalb_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_rop_nalb_enq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_rop_nalb_enq_waddr
    ,output logic                  rf_rx_sync_rop_nalb_enq_we
    ,output logic                  rf_rx_sync_rop_nalb_enq_wclk
    ,output logic                  rf_rx_sync_rop_nalb_enq_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rx_sync_rop_nalb_enq_wdata
    ,input  logic [(     100)-1:0] rf_rx_sync_rop_nalb_enq_rdata

    ,output logic                  sr_nalb_nxthp_re
    ,output logic                  sr_nalb_nxthp_clk
    ,output logic                  sr_nalb_nxthp_clk_rst_n
    ,output logic [(      14)-1:0] sr_nalb_nxthp_addr
    ,output logic                  sr_nalb_nxthp_we
    ,output logic [(      21)-1:0] sr_nalb_nxthp_wdata
    ,input  logic [(      21)-1:0] sr_nalb_nxthp_rdata

// END HQM_MEMPORT_DECL hqm_nalb_pipe_core
// BEGIN HQM_MEMPORT_DECL hqm_dir_pipe_core
    ,output logic                  rf_dir_cnt_re
    ,output logic                  rf_dir_cnt_rclk
    ,output logic                  rf_dir_cnt_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cnt_raddr
    ,output logic [(       6)-1:0] rf_dir_cnt_waddr
    ,output logic                  rf_dir_cnt_we
    ,output logic                  rf_dir_cnt_wclk
    ,output logic                  rf_dir_cnt_wclk_rst_n
    ,output logic [(      68)-1:0] rf_dir_cnt_wdata
    ,input  logic [(      68)-1:0] rf_dir_cnt_rdata

    ,output logic                  rf_dir_hp_re
    ,output logic                  rf_dir_hp_rclk
    ,output logic                  rf_dir_hp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_dir_hp_raddr
    ,output logic [(       8)-1:0] rf_dir_hp_waddr
    ,output logic                  rf_dir_hp_we
    ,output logic                  rf_dir_hp_wclk
    ,output logic                  rf_dir_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_hp_wdata
    ,input  logic [(      15)-1:0] rf_dir_hp_rdata

    ,output logic                  rf_dir_replay_cnt_re
    ,output logic                  rf_dir_replay_cnt_rclk
    ,output logic                  rf_dir_replay_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_dir_replay_cnt_raddr
    ,output logic [(       5)-1:0] rf_dir_replay_cnt_waddr
    ,output logic                  rf_dir_replay_cnt_we
    ,output logic                  rf_dir_replay_cnt_wclk
    ,output logic                  rf_dir_replay_cnt_wclk_rst_n
    ,output logic [(      68)-1:0] rf_dir_replay_cnt_wdata
    ,input  logic [(      68)-1:0] rf_dir_replay_cnt_rdata

    ,output logic                  rf_dir_replay_hp_re
    ,output logic                  rf_dir_replay_hp_rclk
    ,output logic                  rf_dir_replay_hp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_dir_replay_hp_raddr
    ,output logic [(       7)-1:0] rf_dir_replay_hp_waddr
    ,output logic                  rf_dir_replay_hp_we
    ,output logic                  rf_dir_replay_hp_wclk
    ,output logic                  rf_dir_replay_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_replay_hp_wdata
    ,input  logic [(      15)-1:0] rf_dir_replay_hp_rdata

    ,output logic                  rf_dir_replay_tp_re
    ,output logic                  rf_dir_replay_tp_rclk
    ,output logic                  rf_dir_replay_tp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_dir_replay_tp_raddr
    ,output logic [(       7)-1:0] rf_dir_replay_tp_waddr
    ,output logic                  rf_dir_replay_tp_we
    ,output logic                  rf_dir_replay_tp_wclk
    ,output logic                  rf_dir_replay_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_replay_tp_wdata
    ,input  logic [(      15)-1:0] rf_dir_replay_tp_rdata

    ,output logic                  rf_dir_rofrag_cnt_re
    ,output logic                  rf_dir_rofrag_cnt_rclk
    ,output logic                  rf_dir_rofrag_cnt_rclk_rst_n
    ,output logic [(       9)-1:0] rf_dir_rofrag_cnt_raddr
    ,output logic [(       9)-1:0] rf_dir_rofrag_cnt_waddr
    ,output logic                  rf_dir_rofrag_cnt_we
    ,output logic                  rf_dir_rofrag_cnt_wclk
    ,output logic                  rf_dir_rofrag_cnt_wclk_rst_n
    ,output logic [(      17)-1:0] rf_dir_rofrag_cnt_wdata
    ,input  logic [(      17)-1:0] rf_dir_rofrag_cnt_rdata

    ,output logic                  rf_dir_rofrag_hp_re
    ,output logic                  rf_dir_rofrag_hp_rclk
    ,output logic                  rf_dir_rofrag_hp_rclk_rst_n
    ,output logic [(       9)-1:0] rf_dir_rofrag_hp_raddr
    ,output logic [(       9)-1:0] rf_dir_rofrag_hp_waddr
    ,output logic                  rf_dir_rofrag_hp_we
    ,output logic                  rf_dir_rofrag_hp_wclk
    ,output logic                  rf_dir_rofrag_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_rofrag_hp_wdata
    ,input  logic [(      15)-1:0] rf_dir_rofrag_hp_rdata

    ,output logic                  rf_dir_rofrag_tp_re
    ,output logic                  rf_dir_rofrag_tp_rclk
    ,output logic                  rf_dir_rofrag_tp_rclk_rst_n
    ,output logic [(       9)-1:0] rf_dir_rofrag_tp_raddr
    ,output logic [(       9)-1:0] rf_dir_rofrag_tp_waddr
    ,output logic                  rf_dir_rofrag_tp_we
    ,output logic                  rf_dir_rofrag_tp_wclk
    ,output logic                  rf_dir_rofrag_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_rofrag_tp_wdata
    ,input  logic [(      15)-1:0] rf_dir_rofrag_tp_rdata

    ,output logic                  rf_dir_tp_re
    ,output logic                  rf_dir_tp_rclk
    ,output logic                  rf_dir_tp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_dir_tp_raddr
    ,output logic [(       8)-1:0] rf_dir_tp_waddr
    ,output logic                  rf_dir_tp_we
    ,output logic                  rf_dir_tp_wclk
    ,output logic                  rf_dir_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_tp_wdata
    ,input  logic [(      15)-1:0] rf_dir_tp_rdata

    ,output logic                  rf_dp_dqed_re
    ,output logic                  rf_dp_dqed_rclk
    ,output logic                  rf_dp_dqed_rclk_rst_n
    ,output logic [(       5)-1:0] rf_dp_dqed_raddr
    ,output logic [(       5)-1:0] rf_dp_dqed_waddr
    ,output logic                  rf_dp_dqed_we
    ,output logic                  rf_dp_dqed_wclk
    ,output logic                  rf_dp_dqed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_dp_dqed_wdata
    ,input  logic [(      45)-1:0] rf_dp_dqed_rdata

    ,output logic                  rf_dp_lsp_enq_dir_re
    ,output logic                  rf_dp_lsp_enq_dir_rclk
    ,output logic                  rf_dp_lsp_enq_dir_rclk_rst_n
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_dir_raddr
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_dir_waddr
    ,output logic                  rf_dp_lsp_enq_dir_we
    ,output logic                  rf_dp_lsp_enq_dir_wclk
    ,output logic                  rf_dp_lsp_enq_dir_wclk_rst_n
    ,output logic [(       8)-1:0] rf_dp_lsp_enq_dir_wdata
    ,input  logic [(       8)-1:0] rf_dp_lsp_enq_dir_rdata

    ,output logic                  rf_dp_lsp_enq_rorply_re
    ,output logic                  rf_dp_lsp_enq_rorply_rclk
    ,output logic                  rf_dp_lsp_enq_rorply_rclk_rst_n
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_rorply_raddr
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_rorply_waddr
    ,output logic                  rf_dp_lsp_enq_rorply_we
    ,output logic                  rf_dp_lsp_enq_rorply_wclk
    ,output logic                  rf_dp_lsp_enq_rorply_wclk_rst_n
    ,output logic [(      23)-1:0] rf_dp_lsp_enq_rorply_wdata
    ,input  logic [(      23)-1:0] rf_dp_lsp_enq_rorply_rdata

    ,output logic                  rf_lsp_dp_sch_dir_re
    ,output logic                  rf_lsp_dp_sch_dir_rclk
    ,output logic                  rf_lsp_dp_sch_dir_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_dir_raddr
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_dir_waddr
    ,output logic                  rf_lsp_dp_sch_dir_we
    ,output logic                  rf_lsp_dp_sch_dir_wclk
    ,output logic                  rf_lsp_dp_sch_dir_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lsp_dp_sch_dir_wdata
    ,input  logic [(      27)-1:0] rf_lsp_dp_sch_dir_rdata

    ,output logic                  rf_lsp_dp_sch_rorply_re
    ,output logic                  rf_lsp_dp_sch_rorply_rclk
    ,output logic                  rf_lsp_dp_sch_rorply_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_rorply_raddr
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_rorply_waddr
    ,output logic                  rf_lsp_dp_sch_rorply_we
    ,output logic                  rf_lsp_dp_sch_rorply_wclk
    ,output logic                  rf_lsp_dp_sch_rorply_wclk_rst_n
    ,output logic [(       8)-1:0] rf_lsp_dp_sch_rorply_wdata
    ,input  logic [(       8)-1:0] rf_lsp_dp_sch_rorply_rdata

    ,output logic                  rf_rop_dp_enq_dir_re
    ,output logic                  rf_rop_dp_enq_dir_rclk
    ,output logic                  rf_rop_dp_enq_dir_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_dp_enq_dir_raddr
    ,output logic [(       2)-1:0] rf_rop_dp_enq_dir_waddr
    ,output logic                  rf_rop_dp_enq_dir_we
    ,output logic                  rf_rop_dp_enq_dir_wclk
    ,output logic                  rf_rop_dp_enq_dir_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rop_dp_enq_dir_wdata
    ,input  logic [(     100)-1:0] rf_rop_dp_enq_dir_rdata

    ,output logic                  rf_rop_dp_enq_ro_re
    ,output logic                  rf_rop_dp_enq_ro_rclk
    ,output logic                  rf_rop_dp_enq_ro_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_dp_enq_ro_raddr
    ,output logic [(       2)-1:0] rf_rop_dp_enq_ro_waddr
    ,output logic                  rf_rop_dp_enq_ro_we
    ,output logic                  rf_rop_dp_enq_ro_wclk
    ,output logic                  rf_rop_dp_enq_ro_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rop_dp_enq_ro_wdata
    ,input  logic [(     100)-1:0] rf_rop_dp_enq_ro_rdata

    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_re
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_rclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_dir_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_dir_waddr
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_we
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_wclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n
    ,output logic [(      27)-1:0] rf_rx_sync_lsp_dp_sch_dir_wdata
    ,input  logic [(      27)-1:0] rf_rx_sync_lsp_dp_sch_dir_rdata

    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_re
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_rclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_rorply_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_rorply_waddr
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_we
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_wclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n
    ,output logic [(       8)-1:0] rf_rx_sync_lsp_dp_sch_rorply_wdata
    ,input  logic [(       8)-1:0] rf_rx_sync_lsp_dp_sch_rorply_rdata

    ,output logic                  rf_rx_sync_rop_dp_enq_re
    ,output logic                  rf_rx_sync_rop_dp_enq_rclk
    ,output logic                  rf_rx_sync_rop_dp_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_rop_dp_enq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_rop_dp_enq_waddr
    ,output logic                  rf_rx_sync_rop_dp_enq_we
    ,output logic                  rf_rx_sync_rop_dp_enq_wclk
    ,output logic                  rf_rx_sync_rop_dp_enq_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rx_sync_rop_dp_enq_wdata
    ,input  logic [(     100)-1:0] rf_rx_sync_rop_dp_enq_rdata

    ,output logic                  sr_dir_nxthp_re
    ,output logic                  sr_dir_nxthp_clk
    ,output logic                  sr_dir_nxthp_clk_rst_n
    ,output logic [(      14)-1:0] sr_dir_nxthp_addr
    ,output logic                  sr_dir_nxthp_we
    ,output logic [(      21)-1:0] sr_dir_nxthp_wdata
    ,input  logic [(      21)-1:0] sr_dir_nxthp_rdata

// END HQM_MEMPORT_DECL hqm_dir_pipe_core
) ;

`ifndef HQM_VISA_ELABORATE

// collage-pragma translate_off

 hqm_qed_pipe_core i_hqm_qed_pipe_core (.*);

// collage-pragma translate_on

`endif

endmodule // hqm_qed_pipe
