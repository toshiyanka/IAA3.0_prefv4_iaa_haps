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

module hqm_qed_pipe_core
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
  , input  cfg_req_t                    qed_cfg_req_up
  , input  logic                        qed_cfg_rsp_up_ack
  , input  cfg_rsp_t                    qed_cfg_rsp_up
  , output logic                        qed_cfg_req_down_read
  , output logic                        qed_cfg_req_down_write
  , output cfg_req_t                    qed_cfg_req_down
  , output logic                        qed_cfg_rsp_down_ack
  , output cfg_rsp_t                    qed_cfg_rsp_down

  // interrupt interface
  , input  logic                        qed_alarm_up_v
  , output logic                        qed_alarm_up_ready
  , input  aw_alarm_t                   qed_alarm_up_data

  , output logic                        qed_alarm_down_v
  , input  logic                        qed_alarm_down_ready
  , output aw_alarm_t                   qed_alarm_down_data

  // rop_qed_dqed_enq interface
  , input  logic                        rop_qed_dqed_enq_v
  , output logic                        rop_qed_enq_ready
  , output logic                        rop_dqed_enq_ready
  , input  rop_qed_dqed_enq_t           rop_qed_dqed_enq_data

  // qed_chp_sch interface
  , output logic                        qed_chp_sch_v
  , input  logic                        qed_chp_sch_ready
  , output qed_chp_sch_t                qed_chp_sch_data

  // qed_aqed_enq interface
  , output logic                        qed_aqed_enq_v
  , input  logic                        qed_aqed_enq_ready
  , output qed_aqed_enq_t               qed_aqed_enq_data

// qed_lsp_deq interface
, output  logic                  qed_lsp_deq_v
, output  qed_lsp_deq_t          qed_lsp_deq_data

  // rop_dp_enq interface
  , input  logic                        rop_dp_enq_v
  , output logic                        rop_dp_enq_ready
  , input  rop_dp_enq_t                 rop_dp_enq_data

  // lsp_dp_sch_dir interface
  , input  logic                        lsp_dp_sch_dir_v
  , output logic                        lsp_dp_sch_dir_ready
  , input  lsp_dp_sch_dir_t             lsp_dp_sch_dir_data

  // lsp_dp_sch_rorply interface
  , input  logic                        lsp_dp_sch_rorply_v
  , output logic                        lsp_dp_sch_rorply_ready
  , input  lsp_dp_sch_rorply_t          lsp_dp_sch_rorply_data

  // dp_lsp_enq interface
  , output logic                        dp_lsp_enq_dir_v
  , input  logic                        dp_lsp_enq_dir_ready
  , output dp_lsp_enq_dir_t             dp_lsp_enq_dir_data

  // dp_lsp_enq interface
  , output logic                        dp_lsp_enq_rorply_v
  , input  logic                        dp_lsp_enq_rorply_ready
  , output dp_lsp_enq_rorply_t          dp_lsp_enq_rorply_data

  // rop_nalb_enq interface
  , input  logic                        rop_nalb_enq_v
  , output logic                        rop_nalb_enq_ready
  , input  rop_nalb_enq_t               rop_nalb_enq_data

  // lsp_nalb_sch_unoord interface
  , input  logic                        lsp_nalb_sch_unoord_v
  , output logic                        lsp_nalb_sch_unoord_ready
  , input  lsp_nalb_sch_unoord_t        lsp_nalb_sch_unoord_data

  // lsp_nalb_sch_rorply interface
  , input  logic                        lsp_nalb_sch_rorply_v
  , output logic                        lsp_nalb_sch_rorply_ready
  , input  lsp_nalb_sch_rorply_t        lsp_nalb_sch_rorply_data

  // lsp_nalb_sch_atq interface
  , input  logic                        lsp_nalb_sch_atq_v
  , output logic                        lsp_nalb_sch_atq_ready
  , input  lsp_nalb_sch_atq_t           lsp_nalb_sch_atq_data

  // nalb_lsp_enq interface
  , output logic                        nalb_lsp_enq_lb_v
  , input  logic                        nalb_lsp_enq_lb_ready
  , output nalb_lsp_enq_lb_t            nalb_lsp_enq_lb_data

  // nalb_lsp_enq interface
  , output logic                        nalb_lsp_enq_rorply_v
  , input  logic                        nalb_lsp_enq_rorply_ready
  , output nalb_lsp_enq_rorply_t        nalb_lsp_enq_rorply_data

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
localparam HQM_QED_CFG_RST_PFMAX = 2048 ; 
//make top level (non nalb & dir) from qed input 
logic hqm_gated_clk ;
logic hqm_proc_clk_en ;
assign hqm_gated_clk = hqm_gated_clk_qed ;
assign hqm_proc_clk_en_qed = hqm_proc_clk_en ;

logic nalb_qed_force_clockon ;
logic dp_dqed_force_clockon ;
logic [ ( 32 ) - 1 : 0 ]  reset_pf_counter_nxt , reset_pf_counter_f ;
logic reset_pf_active_f , reset_pf_active_nxt ;
logic reset_pf_done_f , reset_pf_done_nxt ;
logic hw_init_done_f , hw_init_done_nxt ; 
logic [3:0] cfg_fifo_qed_chp_sch_crd_hwm ;
logic nalb_cfg_req_up_read ;
logic nalb_cfg_req_up_write ;
cfg_req_t nalb_cfg_req_up ;
logic nalb_cfg_rsp_up_ack ;
cfg_rsp_t nalb_cfg_rsp_up ;
logic nalb_alarm_up_v ;
logic nalb_alarm_up_ready ;
aw_alarm_t nalb_alarm_up_data ;
logic dp_cfg_req_up_read ;
logic dp_cfg_req_up_write ;
cfg_req_t dp_cfg_req_up ;
logic dp_cfg_rsp_up_ack ;
cfg_rsp_t dp_cfg_rsp_up ;
logic dp_alarm_up_v ;
logic dp_alarm_up_ready ;
aw_alarm_t dp_alarm_up_data ;
logic [ ( $bits ( qed_alarm_up_data.unit ) - 1 ) : 0 ] int_uid ;
logic [ ( HQM_QED_ALARM_NUM_INF ) - 1 : 0 ] int_inf_v ;
aw_alarm_syn_t [ ( HQM_QED_ALARM_NUM_INF ) - 1 : 0 ] int_inf_data ;
logic [ ( HQM_QED_ALARM_NUM_COR ) - 1 : 0 ] int_cor_v ;
aw_alarm_syn_t [ ( HQM_QED_ALARM_NUM_COR ) - 1 : 0 ] int_cor_data ;
logic [ ( HQM_QED_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_v ;
aw_alarm_syn_t [ ( HQM_QED_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_data ;
logic [ ( 32 ) - 1 : 0 ] int_status ;
logic [ ( 16 * 1 ) - 1 : 0 ] smon_v_nxt , smon_v_f ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_comp_nxt , smon_comp_f ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_val_nxt , smon_val_f ;
idle_status_t cfg_unit_idle_reg_f , cfg_unit_idle_reg_nxt ;
logic [ ( 7 ) - 1 : 0 ] parity_gen_nalb_qed_d ;
logic  parity_gen_nalb_qed_p ;
logic [ ( 10 ) - 1 : 0 ] parity_gen_dp_dqed_d ;
logic  parity_gen_dp_dqed_p ;
logic  parity_check_enq_flid_p ;
logic [ ( 15 + 2 ) - 1 : 0 ] parity_check_enq_flid_data ;
logic  parity_check_enq_flid_e ;
logic  parity_check_enq_flid_error ;
logic  parity_check_sch_dqed_flid_e ;
logic  parity_check_sch_dqed_flid_error ;
logic  parity_check_sch_dqed_flid_p ;
logic [ ( 15 ) - 1 : 0 ] parity_check_sch_dqed_flid_data ;
logic  parity_check_sch_qed_flid_e ;
logic  parity_check_sch_qed_flid_error ;
logic  parity_check_sch_qed_flid_p ;
logic [ ( 15 ) - 1 : 0 ] parity_check_sch_qed_flid_data ;
logic hqm_qed_pipe_rw_pipe_idle ;
logic hqm_qed_pipe_rw_idle ;
logic hqm_qed_pipe_rw_error ;
logic [ ( 18 ) - 1 : 0 ] hqm_qed_pipe_rw_debug ;
logic error_badcmd1 ;
aw_fifo_status_t rx_sync_nalb_qed_status_pnc ;
aw_fifo_status_t rx_sync_dp_dqed_status_pnc ;
logic rx_sync_dp_dqed_enable ;
logic rx_sync_dp_dqed_idle ;
logic rx_sync_rop_qed_dqed_enq_enable ;
logic rx_sync_rop_qed_dqed_enq_idle ;
logic rx_sync_nalb_qed_enable ;
logic rx_sync_nalb_qed_idle ;
logic cfg_rx_idle ;
logic cfg_rx_enable ;
logic cfg_idle ;
logic int_idle ;
logic wire_rop_qed_dqed_enq_v ;
aw_fifo_status_t rx_sync_rop_qed_dqed_enq_status_pnc ;
logic wire_rop_qed_enq_ready ;
rop_qed_dqed_enq_t wire_rop_qed_dqed_enq_data ;
logic rx_sync_rop_qed_dqed_enq_valid ;
logic rx_sync_rop_qed_dqed_enq_ready ;
rop_qed_dqed_enq_t rx_sync_rop_qed_dqed_enq_data ;
aw_fifo_status_t cfg_rx_fifo_status ;
logic nalb_qed_v ;
logic nalb_qed_ready ;
nalb_qed_t nalb_qed_data ;
logic dp_dqed_v ;
logic dp_dqed_ready ;
dp_dqed_t dp_dqed_data ;
logic rx_sync_nalb_qed_valid ;
logic rx_sync_nalb_qed_ready ;
nalb_qed_t rx_sync_nalb_qed_data ;
nalb_qed_t wire_rx_sync_nalb_qed_data ;
logic rx_sync_dp_dqed_valid ;
logic rx_sync_dp_dqed_ready ;
dp_dqed_t rx_sync_dp_dqed_data ;
dp_dqed_t wire_rx_sync_dp_dqed_data ;
logic disable_smon ;
assign disable_smon = 1'b0 ;
logic counter_inc_1rdy_1sel ;
logic counter_inc_2rdy_1sel ;
logic counter_inc_2rdy_2sel ;
logic counter_inc_3rdy_1sel ;
logic counter_inc_3rdy_2sel ;

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
assign rst_prep             = hqm_rst_prep_qed;
assign hqm_gated_rst_n      = hqm_gated_rst_b_qed;
assign hqm_inp_gated_rst_n  = hqm_inp_gated_rst_b_qed;

logic hqm_gated_rst_n_start;
logic hqm_gated_rst_n_active;
logic hqm_gated_rst_n_done;
assign hqm_gated_rst_n_start    = hqm_gated_rst_b_start_qed;
assign hqm_gated_rst_n_active   = hqm_gated_rst_b_active_qed;
assign hqm_gated_rst_n_done = reset_pf_done_f;
assign hqm_gated_rst_b_done_qed = hqm_gated_rst_n_done;

//---------------------------------------------------------------------------------------------------------
// common core - CFG accessible patch & proc registers 
// common core - RFW/SRW RAM gasket
// common core - RAM wrapper for all single PORT SR RAMs
// common core - RAM wrapper for all 2 port RF RAMs
// The following must be kept in-sync with generated code
// BEGIN HQM_CFG_ACCESS
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write ; //I CFG
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read ; //I CFG
cfg_req_t pfcsr_cfg_req ; //I CFG
logic pfcsr_cfg_rsp_ack ; //O CFG
logic pfcsr_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata ; //O CFG
logic hqm_qed_target_cfg_2rdy1iss_en ; //I HQM_QED_TARGET_CFG_2RDY1ISS
logic hqm_qed_target_cfg_2rdy1iss_clr ; //I HQM_QED_TARGET_CFG_2RDY1ISS
logic hqm_qed_target_cfg_2rdy1iss_clrv ; //I HQM_QED_TARGET_CFG_2RDY1ISS
logic hqm_qed_target_cfg_2rdy1iss_inc ; //I HQM_QED_TARGET_CFG_2RDY1ISS
logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_2rdy1iss_count ; //O HQM_QED_TARGET_CFG_2RDY1ISS
logic hqm_qed_target_cfg_2rdy2iss_en ; //I HQM_QED_TARGET_CFG_2RDY2ISS
logic hqm_qed_target_cfg_2rdy2iss_clr ; //I HQM_QED_TARGET_CFG_2RDY2ISS
logic hqm_qed_target_cfg_2rdy2iss_clrv ; //I HQM_QED_TARGET_CFG_2RDY2ISS
logic hqm_qed_target_cfg_2rdy2iss_inc ; //I HQM_QED_TARGET_CFG_2RDY2ISS
logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_2rdy2iss_count ; //O HQM_QED_TARGET_CFG_2RDY2ISS
logic hqm_qed_target_cfg_3rdy1iss_en ; //I HQM_QED_TARGET_CFG_3RDY1ISS
logic hqm_qed_target_cfg_3rdy1iss_clr ; //I HQM_QED_TARGET_CFG_3RDY1ISS
logic hqm_qed_target_cfg_3rdy1iss_clrv ; //I HQM_QED_TARGET_CFG_3RDY1ISS
logic hqm_qed_target_cfg_3rdy1iss_inc ; //I HQM_QED_TARGET_CFG_3RDY1ISS
logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_3rdy1iss_count ; //O HQM_QED_TARGET_CFG_3RDY1ISS
logic hqm_qed_target_cfg_3rdy2iss_en ; //I HQM_QED_TARGET_CFG_3RDY2ISS
logic hqm_qed_target_cfg_3rdy2iss_clr ; //I HQM_QED_TARGET_CFG_3RDY2ISS
logic hqm_qed_target_cfg_3rdy2iss_clrv ; //I HQM_QED_TARGET_CFG_3RDY2ISS
logic hqm_qed_target_cfg_3rdy2iss_inc ; //I HQM_QED_TARGET_CFG_3RDY2ISS
logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_3rdy2iss_count ; //O HQM_QED_TARGET_CFG_3RDY2ISS
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_general_reg_nxt ; //I HQM_QED_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_general_reg_f ; //O HQM_QED_TARGET_CFG_CONTROL_GENERAL
logic hqm_qed_target_cfg_control_general_reg_v ; //I HQM_QED_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_pipeline_credits_reg_nxt ; //I HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_pipeline_credits_reg_f ; //O HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic hqm_qed_target_cfg_control_pipeline_credits_reg_v ; //I HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_diagnostic_aw_status_status ; //I HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_error_inject_reg_nxt ; //I HQM_QED_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_error_inject_reg_f ; //O HQM_QED_TARGET_CFG_ERROR_INJECT
logic hqm_qed_target_cfg_error_inject_reg_v ; //I HQM_QED_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_control_reg_nxt ; //I HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_control_reg_f ; //O HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL
logic hqm_qed_target_cfg_hw_agitate_control_reg_v ; //I HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_select_reg_nxt ; //I HQM_QED_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_select_reg_f ; //O HQM_QED_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_qed_target_cfg_hw_agitate_select_reg_v ; //I HQM_QED_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_interface_status_reg_nxt ; //I HQM_QED_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_interface_status_reg_f ; //O HQM_QED_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_patch_control_reg_nxt ; //I HQM_QED_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_patch_control_reg_f ; //O HQM_QED_TARGET_CFG_PATCH_CONTROL
logic hqm_qed_target_cfg_patch_control_reg_v ; //I HQM_QED_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_hold_reg_nxt ; //I HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_hold_reg_f ; //O HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_valid_reg_nxt ; //I HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_valid_reg_f ; //O HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_qed_csr_control_reg_nxt ; //I HQM_QED_TARGET_CFG_QED_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_qed_csr_control_reg_f ; //O HQM_QED_TARGET_CFG_QED_CSR_CONTROL
logic hqm_qed_target_cfg_qed_csr_control_reg_v ; //I HQM_QED_TARGET_CFG_QED_CSR_CONTROL
logic hqm_qed_target_cfg_smon_disable_smon ; //I HQM_QED_TARGET_CFG_SMON
logic [ 16 - 1 : 0 ] hqm_qed_target_cfg_smon_smon_v ; //I HQM_QED_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_qed_target_cfg_smon_smon_comp ; //I HQM_QED_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_qed_target_cfg_smon_smon_val ; //I HQM_QED_TARGET_CFG_SMON
logic hqm_qed_target_cfg_smon_smon_enabled ; //O HQM_QED_TARGET_CFG_SMON
logic hqm_qed_target_cfg_smon_smon_interrupt ; //O HQM_QED_TARGET_CFG_SMON
logic hqm_qed_target_cfg_syndrome_00_capture_v ; //I HQM_QED_TARGET_CFG_SYNDROME_00
logic [ ( 31 ) - 1 : 0] hqm_qed_target_cfg_syndrome_00_capture_data ; //I HQM_QED_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_syndrome_00_syndrome_data ; //I HQM_QED_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_idle_reg_nxt ; //I HQM_QED_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_idle_reg_f ; //O HQM_QED_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_timeout_reg_nxt ; //I HQM_QED_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_timeout_reg_f ; //O HQM_QED_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_version_status ; //I HQM_QED_TARGET_CFG_UNIT_VERSION
hqm_qed_pipe_register_pfcsr i_hqm_qed_pipe_register_pfcsr (
  .hqm_gated_clk ( hqm_gated_clk ) 
, .hqm_gated_rst_n ( hqm_gated_rst_n ) 
, .rst_prep ( '0 )
, .cfg_req_write ( pfcsr_cfg_req_write )
, .cfg_req_read ( pfcsr_cfg_req_read )
, .cfg_req ( pfcsr_cfg_req )
, .cfg_rsp_ack ( pfcsr_cfg_rsp_ack )
, .cfg_rsp_err ( pfcsr_cfg_rsp_err )
, .cfg_rsp_rdata ( pfcsr_cfg_rsp_rdata )
, .hqm_qed_target_cfg_2rdy1iss_en ( hqm_qed_target_cfg_2rdy1iss_en )
, .hqm_qed_target_cfg_2rdy1iss_clr ( hqm_qed_target_cfg_2rdy1iss_clr )
, .hqm_qed_target_cfg_2rdy1iss_clrv ( hqm_qed_target_cfg_2rdy1iss_clrv )
, .hqm_qed_target_cfg_2rdy1iss_inc ( hqm_qed_target_cfg_2rdy1iss_inc )
, .hqm_qed_target_cfg_2rdy1iss_count ( hqm_qed_target_cfg_2rdy1iss_count )
, .hqm_qed_target_cfg_2rdy2iss_en ( hqm_qed_target_cfg_2rdy2iss_en )
, .hqm_qed_target_cfg_2rdy2iss_clr ( hqm_qed_target_cfg_2rdy2iss_clr )
, .hqm_qed_target_cfg_2rdy2iss_clrv ( hqm_qed_target_cfg_2rdy2iss_clrv )
, .hqm_qed_target_cfg_2rdy2iss_inc ( hqm_qed_target_cfg_2rdy2iss_inc )
, .hqm_qed_target_cfg_2rdy2iss_count ( hqm_qed_target_cfg_2rdy2iss_count )
, .hqm_qed_target_cfg_3rdy1iss_en ( hqm_qed_target_cfg_3rdy1iss_en )
, .hqm_qed_target_cfg_3rdy1iss_clr ( hqm_qed_target_cfg_3rdy1iss_clr )
, .hqm_qed_target_cfg_3rdy1iss_clrv ( hqm_qed_target_cfg_3rdy1iss_clrv )
, .hqm_qed_target_cfg_3rdy1iss_inc ( hqm_qed_target_cfg_3rdy1iss_inc )
, .hqm_qed_target_cfg_3rdy1iss_count ( hqm_qed_target_cfg_3rdy1iss_count )
, .hqm_qed_target_cfg_3rdy2iss_en ( hqm_qed_target_cfg_3rdy2iss_en )
, .hqm_qed_target_cfg_3rdy2iss_clr ( hqm_qed_target_cfg_3rdy2iss_clr )
, .hqm_qed_target_cfg_3rdy2iss_clrv ( hqm_qed_target_cfg_3rdy2iss_clrv )
, .hqm_qed_target_cfg_3rdy2iss_inc ( hqm_qed_target_cfg_3rdy2iss_inc )
, .hqm_qed_target_cfg_3rdy2iss_count ( hqm_qed_target_cfg_3rdy2iss_count )
, .hqm_qed_target_cfg_control_general_reg_nxt ( hqm_qed_target_cfg_control_general_reg_nxt )
, .hqm_qed_target_cfg_control_general_reg_f ( hqm_qed_target_cfg_control_general_reg_f )
, .hqm_qed_target_cfg_control_general_reg_v (  hqm_qed_target_cfg_control_general_reg_v )
, .hqm_qed_target_cfg_control_pipeline_credits_reg_nxt ( hqm_qed_target_cfg_control_pipeline_credits_reg_nxt )
, .hqm_qed_target_cfg_control_pipeline_credits_reg_f ( hqm_qed_target_cfg_control_pipeline_credits_reg_f )
, .hqm_qed_target_cfg_control_pipeline_credits_reg_v (  hqm_qed_target_cfg_control_pipeline_credits_reg_v )
, .hqm_qed_target_cfg_diagnostic_aw_status_status ( hqm_qed_target_cfg_diagnostic_aw_status_status )
, .hqm_qed_target_cfg_error_inject_reg_nxt ( hqm_qed_target_cfg_error_inject_reg_nxt )
, .hqm_qed_target_cfg_error_inject_reg_f ( hqm_qed_target_cfg_error_inject_reg_f )
, .hqm_qed_target_cfg_error_inject_reg_v (  hqm_qed_target_cfg_error_inject_reg_v )
, .hqm_qed_target_cfg_hw_agitate_control_reg_nxt ( hqm_qed_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_qed_target_cfg_hw_agitate_control_reg_f ( hqm_qed_target_cfg_hw_agitate_control_reg_f )
, .hqm_qed_target_cfg_hw_agitate_control_reg_v (  hqm_qed_target_cfg_hw_agitate_control_reg_v )
, .hqm_qed_target_cfg_hw_agitate_select_reg_nxt ( hqm_qed_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_qed_target_cfg_hw_agitate_select_reg_f ( hqm_qed_target_cfg_hw_agitate_select_reg_f )
, .hqm_qed_target_cfg_hw_agitate_select_reg_v (  hqm_qed_target_cfg_hw_agitate_select_reg_v )
, .hqm_qed_target_cfg_interface_status_reg_nxt ( hqm_qed_target_cfg_interface_status_reg_nxt )
, .hqm_qed_target_cfg_interface_status_reg_f ( hqm_qed_target_cfg_interface_status_reg_f )
, .hqm_qed_target_cfg_patch_control_reg_nxt ( hqm_qed_target_cfg_patch_control_reg_nxt )
, .hqm_qed_target_cfg_patch_control_reg_f ( hqm_qed_target_cfg_patch_control_reg_f )
, .hqm_qed_target_cfg_patch_control_reg_v (  hqm_qed_target_cfg_patch_control_reg_v )
, .hqm_qed_target_cfg_pipe_health_hold_reg_nxt ( hqm_qed_target_cfg_pipe_health_hold_reg_nxt )
, .hqm_qed_target_cfg_pipe_health_hold_reg_f ( hqm_qed_target_cfg_pipe_health_hold_reg_f )
, .hqm_qed_target_cfg_pipe_health_valid_reg_nxt ( hqm_qed_target_cfg_pipe_health_valid_reg_nxt )
, .hqm_qed_target_cfg_pipe_health_valid_reg_f ( hqm_qed_target_cfg_pipe_health_valid_reg_f )
, .hqm_qed_target_cfg_qed_csr_control_reg_nxt ( hqm_qed_target_cfg_qed_csr_control_reg_nxt )
, .hqm_qed_target_cfg_qed_csr_control_reg_f ( hqm_qed_target_cfg_qed_csr_control_reg_f )
, .hqm_qed_target_cfg_qed_csr_control_reg_v (  hqm_qed_target_cfg_qed_csr_control_reg_v )
, .hqm_qed_target_cfg_smon_disable_smon ( hqm_qed_target_cfg_smon_disable_smon )
, .hqm_qed_target_cfg_smon_smon_v ( hqm_qed_target_cfg_smon_smon_v )
, .hqm_qed_target_cfg_smon_smon_comp ( hqm_qed_target_cfg_smon_smon_comp )
, .hqm_qed_target_cfg_smon_smon_val ( hqm_qed_target_cfg_smon_smon_val )
, .hqm_qed_target_cfg_smon_smon_enabled ( hqm_qed_target_cfg_smon_smon_enabled )
, .hqm_qed_target_cfg_smon_smon_interrupt ( hqm_qed_target_cfg_smon_smon_interrupt )
, .hqm_qed_target_cfg_syndrome_00_capture_v ( hqm_qed_target_cfg_syndrome_00_capture_v )
, .hqm_qed_target_cfg_syndrome_00_capture_data ( hqm_qed_target_cfg_syndrome_00_capture_data )
, .hqm_qed_target_cfg_syndrome_00_syndrome_data ( hqm_qed_target_cfg_syndrome_00_syndrome_data )
, .hqm_qed_target_cfg_unit_idle_reg_nxt ( hqm_qed_target_cfg_unit_idle_reg_nxt )
, .hqm_qed_target_cfg_unit_idle_reg_f ( hqm_qed_target_cfg_unit_idle_reg_f )
, .hqm_qed_target_cfg_unit_timeout_reg_nxt ( hqm_qed_target_cfg_unit_timeout_reg_nxt )
, .hqm_qed_target_cfg_unit_timeout_reg_f ( hqm_qed_target_cfg_unit_timeout_reg_f )
, .hqm_qed_target_cfg_unit_version_status ( hqm_qed_target_cfg_unit_version_status )
) ;
// END HQM_CFG_ACCESS
// BEGIN HQM_RAM_ACCESS
localparam NUM_CFG_ACCESSIBLE_RAM = 8;
localparam CFG_ACCESSIBLE_RAM_QED_0 = 0; // HQM_QED_TARGET_CFG_QED0_WRD0 HQM_QED_TARGET_CFG_QED0_WRD1 HQM_QED_TARGET_CFG_QED0_WRD2 HQM_QED_TARGET_CFG_QED0_WRD3
localparam CFG_ACCESSIBLE_RAM_QED_1 = 1; // HQM_QED_TARGET_CFG_QED1_WRD0 HQM_QED_TARGET_CFG_QED1_WRD1 HQM_QED_TARGET_CFG_QED1_WRD2 HQM_QED_TARGET_CFG_QED1_WRD3
localparam CFG_ACCESSIBLE_RAM_QED_2 = 2; // HQM_QED_TARGET_CFG_QED2_WRD0 HQM_QED_TARGET_CFG_QED2_WRD1 HQM_QED_TARGET_CFG_QED2_WRD2 HQM_QED_TARGET_CFG_QED2_WRD3
localparam CFG_ACCESSIBLE_RAM_QED_3 = 3; // HQM_QED_TARGET_CFG_QED3_WRD0 HQM_QED_TARGET_CFG_QED3_WRD1 HQM_QED_TARGET_CFG_QED3_WRD2 HQM_QED_TARGET_CFG_QED3_WRD3
localparam CFG_ACCESSIBLE_RAM_QED_4 = 4; // HQM_QED_TARGET_CFG_QED4_WRD0 HQM_QED_TARGET_CFG_QED4_WRD1 HQM_QED_TARGET_CFG_QED4_WRD2 HQM_QED_TARGET_CFG_QED4_WRD3
localparam CFG_ACCESSIBLE_RAM_QED_5 = 5; // HQM_QED_TARGET_CFG_QED5_WRD0 HQM_QED_TARGET_CFG_QED5_WRD1 HQM_QED_TARGET_CFG_QED5_WRD2 HQM_QED_TARGET_CFG_QED5_WRD3
localparam CFG_ACCESSIBLE_RAM_QED_6 = 6; // HQM_QED_TARGET_CFG_QED6_WRD0 HQM_QED_TARGET_CFG_QED6_WRD1 HQM_QED_TARGET_CFG_QED6_WRD2 HQM_QED_TARGET_CFG_QED6_WRD3
localparam CFG_ACCESSIBLE_RAM_QED_7 = 7; // HQM_QED_TARGET_CFG_QED7_WRD0 HQM_QED_TARGET_CFG_QED7_WRD1 HQM_QED_TARGET_CFG_QED7_WRD2 HQM_QED_TARGET_CFG_QED7_WRD3
logic [(  8 *  1)-1:0] cfg_mem_re;
logic [(  8 *  1)-1:0] cfg_mem_we;
logic [(      20)-1:0] cfg_mem_addr;
logic [(      12)-1:0] cfg_mem_minbit;
logic [(      12)-1:0] cfg_mem_maxbit;
logic [(      32)-1:0] cfg_mem_wdata;
logic [(  8 * 32)-1:0] cfg_mem_rdata;
logic [(  8 *  1)-1:0] cfg_mem_ack;
logic                  cfg_mem_cc_v;
logic [(       8)-1:0] cfg_mem_cc_value;
logic [(       4)-1:0] cfg_mem_cc_width;
logic [(      12)-1:0] cfg_mem_cc_position;


logic                  hqm_qed_pipe_rfw_top_ipar_error;

logic                  func_qed_chp_sch_data_re; //I
logic [(       3)-1:0] func_qed_chp_sch_data_raddr; //I
logic [(       3)-1:0] func_qed_chp_sch_data_waddr; //I
logic                  func_qed_chp_sch_data_we;    //I
logic [(     177)-1:0] func_qed_chp_sch_data_wdata; //I
logic [(     177)-1:0] func_qed_chp_sch_data_rdata;

logic                pf_qed_chp_sch_data_re;    //I
logic [(       3)-1:0] pf_qed_chp_sch_data_raddr; //I
logic [(       3)-1:0] pf_qed_chp_sch_data_waddr; //I
logic                  pf_qed_chp_sch_data_we;    //I
logic [(     177)-1:0] pf_qed_chp_sch_data_wdata; //I
logic [(     177)-1:0] pf_qed_chp_sch_data_rdata;

logic                  rf_qed_chp_sch_data_error;

logic                  func_rx_sync_dp_dqed_data_re; //I
logic [(       2)-1:0] func_rx_sync_dp_dqed_data_raddr; //I
logic [(       2)-1:0] func_rx_sync_dp_dqed_data_waddr; //I
logic                  func_rx_sync_dp_dqed_data_we;    //I
logic [(      45)-1:0] func_rx_sync_dp_dqed_data_wdata; //I
logic [(      45)-1:0] func_rx_sync_dp_dqed_data_rdata;

logic                pf_rx_sync_dp_dqed_data_re;    //I
logic [(       2)-1:0] pf_rx_sync_dp_dqed_data_raddr; //I
logic [(       2)-1:0] pf_rx_sync_dp_dqed_data_waddr; //I
logic                  pf_rx_sync_dp_dqed_data_we;    //I
logic [(      45)-1:0] pf_rx_sync_dp_dqed_data_wdata; //I
logic [(      45)-1:0] pf_rx_sync_dp_dqed_data_rdata;

logic                  rf_rx_sync_dp_dqed_data_error;

logic                  func_rx_sync_nalb_qed_data_re; //I
logic [(       2)-1:0] func_rx_sync_nalb_qed_data_raddr; //I
logic [(       2)-1:0] func_rx_sync_nalb_qed_data_waddr; //I
logic                  func_rx_sync_nalb_qed_data_we;    //I
logic [(      45)-1:0] func_rx_sync_nalb_qed_data_wdata; //I
logic [(      45)-1:0] func_rx_sync_nalb_qed_data_rdata;

logic                pf_rx_sync_nalb_qed_data_re;    //I
logic [(       2)-1:0] pf_rx_sync_nalb_qed_data_raddr; //I
logic [(       2)-1:0] pf_rx_sync_nalb_qed_data_waddr; //I
logic                  pf_rx_sync_nalb_qed_data_we;    //I
logic [(      45)-1:0] pf_rx_sync_nalb_qed_data_wdata; //I
logic [(      45)-1:0] pf_rx_sync_nalb_qed_data_rdata;

logic                  rf_rx_sync_nalb_qed_data_error;

logic                  func_rx_sync_rop_qed_dqed_enq_re; //I
logic [(       2)-1:0] func_rx_sync_rop_qed_dqed_enq_raddr; //I
logic [(       2)-1:0] func_rx_sync_rop_qed_dqed_enq_waddr; //I
logic                  func_rx_sync_rop_qed_dqed_enq_we;    //I
logic [(     157)-1:0] func_rx_sync_rop_qed_dqed_enq_wdata; //I
logic [(     157)-1:0] func_rx_sync_rop_qed_dqed_enq_rdata;

logic                pf_rx_sync_rop_qed_dqed_enq_re;    //I
logic [(       2)-1:0] pf_rx_sync_rop_qed_dqed_enq_raddr; //I
logic [(       2)-1:0] pf_rx_sync_rop_qed_dqed_enq_waddr; //I
logic                  pf_rx_sync_rop_qed_dqed_enq_we;    //I
logic [(     157)-1:0] pf_rx_sync_rop_qed_dqed_enq_wdata; //I
logic [(     157)-1:0] pf_rx_sync_rop_qed_dqed_enq_rdata;

logic                  rf_rx_sync_rop_qed_dqed_enq_error;

logic                  func_qed_0_re;    //I
logic [(      11)-1:0] func_qed_0_addr;  //I
logic                  func_qed_0_we;    //I
logic [(     139)-1:0] func_qed_0_wdata; //I
logic [(     139)-1:0] func_qed_0_rdata;

logic                  pf_qed_0_re;   //I
logic [(      11)-1:0] pf_qed_0_addr; //I
logic                  pf_qed_0_we;   //I
logic [(     139)-1:0] pf_qed_0_wdata; //I
logic [(     139)-1:0] pf_qed_0_rdata;

logic                  sr_qed_0_error;

logic                  func_qed_1_re;    //I
logic [(      11)-1:0] func_qed_1_addr;  //I
logic                  func_qed_1_we;    //I
logic [(     139)-1:0] func_qed_1_wdata; //I
logic [(     139)-1:0] func_qed_1_rdata;

logic                  pf_qed_1_re;   //I
logic [(      11)-1:0] pf_qed_1_addr; //I
logic                  pf_qed_1_we;   //I
logic [(     139)-1:0] pf_qed_1_wdata; //I
logic [(     139)-1:0] pf_qed_1_rdata;

logic                  sr_qed_1_error;

logic                  func_qed_2_re;    //I
logic [(      11)-1:0] func_qed_2_addr;  //I
logic                  func_qed_2_we;    //I
logic [(     139)-1:0] func_qed_2_wdata; //I
logic [(     139)-1:0] func_qed_2_rdata;

logic                  pf_qed_2_re;   //I
logic [(      11)-1:0] pf_qed_2_addr; //I
logic                  pf_qed_2_we;   //I
logic [(     139)-1:0] pf_qed_2_wdata; //I
logic [(     139)-1:0] pf_qed_2_rdata;

logic                  sr_qed_2_error;

logic                  func_qed_3_re;    //I
logic [(      11)-1:0] func_qed_3_addr;  //I
logic                  func_qed_3_we;    //I
logic [(     139)-1:0] func_qed_3_wdata; //I
logic [(     139)-1:0] func_qed_3_rdata;

logic                  pf_qed_3_re;   //I
logic [(      11)-1:0] pf_qed_3_addr; //I
logic                  pf_qed_3_we;   //I
logic [(     139)-1:0] pf_qed_3_wdata; //I
logic [(     139)-1:0] pf_qed_3_rdata;

logic                  sr_qed_3_error;

logic                  func_qed_4_re;    //I
logic [(      11)-1:0] func_qed_4_addr;  //I
logic                  func_qed_4_we;    //I
logic [(     139)-1:0] func_qed_4_wdata; //I
logic [(     139)-1:0] func_qed_4_rdata;

logic                  pf_qed_4_re;   //I
logic [(      11)-1:0] pf_qed_4_addr; //I
logic                  pf_qed_4_we;   //I
logic [(     139)-1:0] pf_qed_4_wdata; //I
logic [(     139)-1:0] pf_qed_4_rdata;

logic                  sr_qed_4_error;

logic                  func_qed_5_re;    //I
logic [(      11)-1:0] func_qed_5_addr;  //I
logic                  func_qed_5_we;    //I
logic [(     139)-1:0] func_qed_5_wdata; //I
logic [(     139)-1:0] func_qed_5_rdata;

logic                  pf_qed_5_re;   //I
logic [(      11)-1:0] pf_qed_5_addr; //I
logic                  pf_qed_5_we;   //I
logic [(     139)-1:0] pf_qed_5_wdata; //I
logic [(     139)-1:0] pf_qed_5_rdata;

logic                  sr_qed_5_error;

logic                  func_qed_6_re;    //I
logic [(      11)-1:0] func_qed_6_addr;  //I
logic                  func_qed_6_we;    //I
logic [(     139)-1:0] func_qed_6_wdata; //I
logic [(     139)-1:0] func_qed_6_rdata;

logic                  pf_qed_6_re;   //I
logic [(      11)-1:0] pf_qed_6_addr; //I
logic                  pf_qed_6_we;   //I
logic [(     139)-1:0] pf_qed_6_wdata; //I
logic [(     139)-1:0] pf_qed_6_rdata;

logic                  sr_qed_6_error;

logic                  func_qed_7_re;    //I
logic [(      11)-1:0] func_qed_7_addr;  //I
logic                  func_qed_7_we;    //I
logic [(     139)-1:0] func_qed_7_wdata; //I
logic [(     139)-1:0] func_qed_7_rdata;

logic                  pf_qed_7_re;   //I
logic [(      11)-1:0] pf_qed_7_addr; //I
logic                  pf_qed_7_we;   //I
logic [(     139)-1:0] pf_qed_7_wdata; //I
logic [(     139)-1:0] pf_qed_7_rdata;

logic                  sr_qed_7_error;

hqm_qed_pipe_ram_access i_hqm_qed_pipe_ram_access (
  .hqm_gated_clk (hqm_gated_clk)
, .hqm_inp_gated_clk (hqm_inp_gated_clk)
, .hqm_gated_rst_n (hqm_gated_rst_n)
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

,.hqm_qed_pipe_rfw_top_ipar_error (hqm_qed_pipe_rfw_top_ipar_error)

,.func_qed_chp_sch_data_re    (func_qed_chp_sch_data_re)
,.func_qed_chp_sch_data_raddr (func_qed_chp_sch_data_raddr)
,.func_qed_chp_sch_data_waddr (func_qed_chp_sch_data_waddr)
,.func_qed_chp_sch_data_we    (func_qed_chp_sch_data_we)
,.func_qed_chp_sch_data_wdata (func_qed_chp_sch_data_wdata)
,.func_qed_chp_sch_data_rdata (func_qed_chp_sch_data_rdata)

,.pf_qed_chp_sch_data_re      (pf_qed_chp_sch_data_re)
,.pf_qed_chp_sch_data_raddr (pf_qed_chp_sch_data_raddr)
,.pf_qed_chp_sch_data_waddr (pf_qed_chp_sch_data_waddr)
,.pf_qed_chp_sch_data_we    (pf_qed_chp_sch_data_we)
,.pf_qed_chp_sch_data_wdata (pf_qed_chp_sch_data_wdata)
,.pf_qed_chp_sch_data_rdata (pf_qed_chp_sch_data_rdata)

,.rf_qed_chp_sch_data_rclk (rf_qed_chp_sch_data_rclk)
,.rf_qed_chp_sch_data_rclk_rst_n (rf_qed_chp_sch_data_rclk_rst_n)
,.rf_qed_chp_sch_data_re    (rf_qed_chp_sch_data_re)
,.rf_qed_chp_sch_data_raddr (rf_qed_chp_sch_data_raddr)
,.rf_qed_chp_sch_data_waddr (rf_qed_chp_sch_data_waddr)
,.rf_qed_chp_sch_data_wclk (rf_qed_chp_sch_data_wclk)
,.rf_qed_chp_sch_data_wclk_rst_n (rf_qed_chp_sch_data_wclk_rst_n)
,.rf_qed_chp_sch_data_we    (rf_qed_chp_sch_data_we)
,.rf_qed_chp_sch_data_wdata (rf_qed_chp_sch_data_wdata)
,.rf_qed_chp_sch_data_rdata (rf_qed_chp_sch_data_rdata)

,.rf_qed_chp_sch_data_error (rf_qed_chp_sch_data_error)

,.func_rx_sync_dp_dqed_data_re    (func_rx_sync_dp_dqed_data_re)
,.func_rx_sync_dp_dqed_data_raddr (func_rx_sync_dp_dqed_data_raddr)
,.func_rx_sync_dp_dqed_data_waddr (func_rx_sync_dp_dqed_data_waddr)
,.func_rx_sync_dp_dqed_data_we    (func_rx_sync_dp_dqed_data_we)
,.func_rx_sync_dp_dqed_data_wdata (func_rx_sync_dp_dqed_data_wdata)
,.func_rx_sync_dp_dqed_data_rdata (func_rx_sync_dp_dqed_data_rdata)

,.pf_rx_sync_dp_dqed_data_re      (pf_rx_sync_dp_dqed_data_re)
,.pf_rx_sync_dp_dqed_data_raddr (pf_rx_sync_dp_dqed_data_raddr)
,.pf_rx_sync_dp_dqed_data_waddr (pf_rx_sync_dp_dqed_data_waddr)
,.pf_rx_sync_dp_dqed_data_we    (pf_rx_sync_dp_dqed_data_we)
,.pf_rx_sync_dp_dqed_data_wdata (pf_rx_sync_dp_dqed_data_wdata)
,.pf_rx_sync_dp_dqed_data_rdata (pf_rx_sync_dp_dqed_data_rdata)

,.rf_rx_sync_dp_dqed_data_rclk (rf_rx_sync_dp_dqed_data_rclk)
,.rf_rx_sync_dp_dqed_data_rclk_rst_n (rf_rx_sync_dp_dqed_data_rclk_rst_n)
,.rf_rx_sync_dp_dqed_data_re    (rf_rx_sync_dp_dqed_data_re)
,.rf_rx_sync_dp_dqed_data_raddr (rf_rx_sync_dp_dqed_data_raddr)
,.rf_rx_sync_dp_dqed_data_waddr (rf_rx_sync_dp_dqed_data_waddr)
,.rf_rx_sync_dp_dqed_data_wclk (rf_rx_sync_dp_dqed_data_wclk)
,.rf_rx_sync_dp_dqed_data_wclk_rst_n (rf_rx_sync_dp_dqed_data_wclk_rst_n)
,.rf_rx_sync_dp_dqed_data_we    (rf_rx_sync_dp_dqed_data_we)
,.rf_rx_sync_dp_dqed_data_wdata (rf_rx_sync_dp_dqed_data_wdata)
,.rf_rx_sync_dp_dqed_data_rdata (rf_rx_sync_dp_dqed_data_rdata)

,.rf_rx_sync_dp_dqed_data_error (rf_rx_sync_dp_dqed_data_error)

,.func_rx_sync_nalb_qed_data_re    (func_rx_sync_nalb_qed_data_re)
,.func_rx_sync_nalb_qed_data_raddr (func_rx_sync_nalb_qed_data_raddr)
,.func_rx_sync_nalb_qed_data_waddr (func_rx_sync_nalb_qed_data_waddr)
,.func_rx_sync_nalb_qed_data_we    (func_rx_sync_nalb_qed_data_we)
,.func_rx_sync_nalb_qed_data_wdata (func_rx_sync_nalb_qed_data_wdata)
,.func_rx_sync_nalb_qed_data_rdata (func_rx_sync_nalb_qed_data_rdata)

,.pf_rx_sync_nalb_qed_data_re      (pf_rx_sync_nalb_qed_data_re)
,.pf_rx_sync_nalb_qed_data_raddr (pf_rx_sync_nalb_qed_data_raddr)
,.pf_rx_sync_nalb_qed_data_waddr (pf_rx_sync_nalb_qed_data_waddr)
,.pf_rx_sync_nalb_qed_data_we    (pf_rx_sync_nalb_qed_data_we)
,.pf_rx_sync_nalb_qed_data_wdata (pf_rx_sync_nalb_qed_data_wdata)
,.pf_rx_sync_nalb_qed_data_rdata (pf_rx_sync_nalb_qed_data_rdata)

,.rf_rx_sync_nalb_qed_data_rclk (rf_rx_sync_nalb_qed_data_rclk)
,.rf_rx_sync_nalb_qed_data_rclk_rst_n (rf_rx_sync_nalb_qed_data_rclk_rst_n)
,.rf_rx_sync_nalb_qed_data_re    (rf_rx_sync_nalb_qed_data_re)
,.rf_rx_sync_nalb_qed_data_raddr (rf_rx_sync_nalb_qed_data_raddr)
,.rf_rx_sync_nalb_qed_data_waddr (rf_rx_sync_nalb_qed_data_waddr)
,.rf_rx_sync_nalb_qed_data_wclk (rf_rx_sync_nalb_qed_data_wclk)
,.rf_rx_sync_nalb_qed_data_wclk_rst_n (rf_rx_sync_nalb_qed_data_wclk_rst_n)
,.rf_rx_sync_nalb_qed_data_we    (rf_rx_sync_nalb_qed_data_we)
,.rf_rx_sync_nalb_qed_data_wdata (rf_rx_sync_nalb_qed_data_wdata)
,.rf_rx_sync_nalb_qed_data_rdata (rf_rx_sync_nalb_qed_data_rdata)

,.rf_rx_sync_nalb_qed_data_error (rf_rx_sync_nalb_qed_data_error)

,.func_rx_sync_rop_qed_dqed_enq_re    (func_rx_sync_rop_qed_dqed_enq_re)
,.func_rx_sync_rop_qed_dqed_enq_raddr (func_rx_sync_rop_qed_dqed_enq_raddr)
,.func_rx_sync_rop_qed_dqed_enq_waddr (func_rx_sync_rop_qed_dqed_enq_waddr)
,.func_rx_sync_rop_qed_dqed_enq_we    (func_rx_sync_rop_qed_dqed_enq_we)
,.func_rx_sync_rop_qed_dqed_enq_wdata (func_rx_sync_rop_qed_dqed_enq_wdata)
,.func_rx_sync_rop_qed_dqed_enq_rdata (func_rx_sync_rop_qed_dqed_enq_rdata)

,.pf_rx_sync_rop_qed_dqed_enq_re      (pf_rx_sync_rop_qed_dqed_enq_re)
,.pf_rx_sync_rop_qed_dqed_enq_raddr (pf_rx_sync_rop_qed_dqed_enq_raddr)
,.pf_rx_sync_rop_qed_dqed_enq_waddr (pf_rx_sync_rop_qed_dqed_enq_waddr)
,.pf_rx_sync_rop_qed_dqed_enq_we    (pf_rx_sync_rop_qed_dqed_enq_we)
,.pf_rx_sync_rop_qed_dqed_enq_wdata (pf_rx_sync_rop_qed_dqed_enq_wdata)
,.pf_rx_sync_rop_qed_dqed_enq_rdata (pf_rx_sync_rop_qed_dqed_enq_rdata)

,.rf_rx_sync_rop_qed_dqed_enq_rclk (rf_rx_sync_rop_qed_dqed_enq_rclk)
,.rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n (rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n)
,.rf_rx_sync_rop_qed_dqed_enq_re    (rf_rx_sync_rop_qed_dqed_enq_re)
,.rf_rx_sync_rop_qed_dqed_enq_raddr (rf_rx_sync_rop_qed_dqed_enq_raddr)
,.rf_rx_sync_rop_qed_dqed_enq_waddr (rf_rx_sync_rop_qed_dqed_enq_waddr)
,.rf_rx_sync_rop_qed_dqed_enq_wclk (rf_rx_sync_rop_qed_dqed_enq_wclk)
,.rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n (rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n)
,.rf_rx_sync_rop_qed_dqed_enq_we    (rf_rx_sync_rop_qed_dqed_enq_we)
,.rf_rx_sync_rop_qed_dqed_enq_wdata (rf_rx_sync_rop_qed_dqed_enq_wdata)
,.rf_rx_sync_rop_qed_dqed_enq_rdata (rf_rx_sync_rop_qed_dqed_enq_rdata)

,.rf_rx_sync_rop_qed_dqed_enq_error (rf_rx_sync_rop_qed_dqed_enq_error)

,.func_qed_0_re    (func_qed_0_re)
,.func_qed_0_addr  (func_qed_0_addr)
,.func_qed_0_we    (func_qed_0_we)
,.func_qed_0_wdata (func_qed_0_wdata)
,.func_qed_0_rdata (func_qed_0_rdata)

,.pf_qed_0_re      (pf_qed_0_re)
,.pf_qed_0_addr    (pf_qed_0_addr)
,.pf_qed_0_we      (pf_qed_0_we)
,.pf_qed_0_wdata   (pf_qed_0_wdata)
,.pf_qed_0_rdata   (pf_qed_0_rdata)

,.sr_qed_0_clk (sr_qed_0_clk)
,.sr_qed_0_clk_rst_n (sr_qed_0_clk_rst_n)
,.sr_qed_0_re    (sr_qed_0_re)
,.sr_qed_0_addr  (sr_qed_0_addr)
,.sr_qed_0_we    (sr_qed_0_we)
,.sr_qed_0_wdata (sr_qed_0_wdata)
,.sr_qed_0_rdata (sr_qed_0_rdata)

,.sr_qed_0_error (sr_qed_0_error)

,.func_qed_1_re    (func_qed_1_re)
,.func_qed_1_addr  (func_qed_1_addr)
,.func_qed_1_we    (func_qed_1_we)
,.func_qed_1_wdata (func_qed_1_wdata)
,.func_qed_1_rdata (func_qed_1_rdata)

,.pf_qed_1_re      (pf_qed_1_re)
,.pf_qed_1_addr    (pf_qed_1_addr)
,.pf_qed_1_we      (pf_qed_1_we)
,.pf_qed_1_wdata   (pf_qed_1_wdata)
,.pf_qed_1_rdata   (pf_qed_1_rdata)

,.sr_qed_1_clk (sr_qed_1_clk)
,.sr_qed_1_clk_rst_n (sr_qed_1_clk_rst_n)
,.sr_qed_1_re    (sr_qed_1_re)
,.sr_qed_1_addr  (sr_qed_1_addr)
,.sr_qed_1_we    (sr_qed_1_we)
,.sr_qed_1_wdata (sr_qed_1_wdata)
,.sr_qed_1_rdata (sr_qed_1_rdata)

,.sr_qed_1_error (sr_qed_1_error)

,.func_qed_2_re    (func_qed_2_re)
,.func_qed_2_addr  (func_qed_2_addr)
,.func_qed_2_we    (func_qed_2_we)
,.func_qed_2_wdata (func_qed_2_wdata)
,.func_qed_2_rdata (func_qed_2_rdata)

,.pf_qed_2_re      (pf_qed_2_re)
,.pf_qed_2_addr    (pf_qed_2_addr)
,.pf_qed_2_we      (pf_qed_2_we)
,.pf_qed_2_wdata   (pf_qed_2_wdata)
,.pf_qed_2_rdata   (pf_qed_2_rdata)

,.sr_qed_2_clk (sr_qed_2_clk)
,.sr_qed_2_clk_rst_n (sr_qed_2_clk_rst_n)
,.sr_qed_2_re    (sr_qed_2_re)
,.sr_qed_2_addr  (sr_qed_2_addr)
,.sr_qed_2_we    (sr_qed_2_we)
,.sr_qed_2_wdata (sr_qed_2_wdata)
,.sr_qed_2_rdata (sr_qed_2_rdata)

,.sr_qed_2_error (sr_qed_2_error)

,.func_qed_3_re    (func_qed_3_re)
,.func_qed_3_addr  (func_qed_3_addr)
,.func_qed_3_we    (func_qed_3_we)
,.func_qed_3_wdata (func_qed_3_wdata)
,.func_qed_3_rdata (func_qed_3_rdata)

,.pf_qed_3_re      (pf_qed_3_re)
,.pf_qed_3_addr    (pf_qed_3_addr)
,.pf_qed_3_we      (pf_qed_3_we)
,.pf_qed_3_wdata   (pf_qed_3_wdata)
,.pf_qed_3_rdata   (pf_qed_3_rdata)

,.sr_qed_3_clk (sr_qed_3_clk)
,.sr_qed_3_clk_rst_n (sr_qed_3_clk_rst_n)
,.sr_qed_3_re    (sr_qed_3_re)
,.sr_qed_3_addr  (sr_qed_3_addr)
,.sr_qed_3_we    (sr_qed_3_we)
,.sr_qed_3_wdata (sr_qed_3_wdata)
,.sr_qed_3_rdata (sr_qed_3_rdata)

,.sr_qed_3_error (sr_qed_3_error)

,.func_qed_4_re    (func_qed_4_re)
,.func_qed_4_addr  (func_qed_4_addr)
,.func_qed_4_we    (func_qed_4_we)
,.func_qed_4_wdata (func_qed_4_wdata)
,.func_qed_4_rdata (func_qed_4_rdata)

,.pf_qed_4_re      (pf_qed_4_re)
,.pf_qed_4_addr    (pf_qed_4_addr)
,.pf_qed_4_we      (pf_qed_4_we)
,.pf_qed_4_wdata   (pf_qed_4_wdata)
,.pf_qed_4_rdata   (pf_qed_4_rdata)

,.sr_qed_4_clk (sr_qed_4_clk)
,.sr_qed_4_clk_rst_n (sr_qed_4_clk_rst_n)
,.sr_qed_4_re    (sr_qed_4_re)
,.sr_qed_4_addr  (sr_qed_4_addr)
,.sr_qed_4_we    (sr_qed_4_we)
,.sr_qed_4_wdata (sr_qed_4_wdata)
,.sr_qed_4_rdata (sr_qed_4_rdata)

,.sr_qed_4_error (sr_qed_4_error)

,.func_qed_5_re    (func_qed_5_re)
,.func_qed_5_addr  (func_qed_5_addr)
,.func_qed_5_we    (func_qed_5_we)
,.func_qed_5_wdata (func_qed_5_wdata)
,.func_qed_5_rdata (func_qed_5_rdata)

,.pf_qed_5_re      (pf_qed_5_re)
,.pf_qed_5_addr    (pf_qed_5_addr)
,.pf_qed_5_we      (pf_qed_5_we)
,.pf_qed_5_wdata   (pf_qed_5_wdata)
,.pf_qed_5_rdata   (pf_qed_5_rdata)

,.sr_qed_5_clk (sr_qed_5_clk)
,.sr_qed_5_clk_rst_n (sr_qed_5_clk_rst_n)
,.sr_qed_5_re    (sr_qed_5_re)
,.sr_qed_5_addr  (sr_qed_5_addr)
,.sr_qed_5_we    (sr_qed_5_we)
,.sr_qed_5_wdata (sr_qed_5_wdata)
,.sr_qed_5_rdata (sr_qed_5_rdata)

,.sr_qed_5_error (sr_qed_5_error)

,.func_qed_6_re    (func_qed_6_re)
,.func_qed_6_addr  (func_qed_6_addr)
,.func_qed_6_we    (func_qed_6_we)
,.func_qed_6_wdata (func_qed_6_wdata)
,.func_qed_6_rdata (func_qed_6_rdata)

,.pf_qed_6_re      (pf_qed_6_re)
,.pf_qed_6_addr    (pf_qed_6_addr)
,.pf_qed_6_we      (pf_qed_6_we)
,.pf_qed_6_wdata   (pf_qed_6_wdata)
,.pf_qed_6_rdata   (pf_qed_6_rdata)

,.sr_qed_6_clk (sr_qed_6_clk)
,.sr_qed_6_clk_rst_n (sr_qed_6_clk_rst_n)
,.sr_qed_6_re    (sr_qed_6_re)
,.sr_qed_6_addr  (sr_qed_6_addr)
,.sr_qed_6_we    (sr_qed_6_we)
,.sr_qed_6_wdata (sr_qed_6_wdata)
,.sr_qed_6_rdata (sr_qed_6_rdata)

,.sr_qed_6_error (sr_qed_6_error)

,.func_qed_7_re    (func_qed_7_re)
,.func_qed_7_addr  (func_qed_7_addr)
,.func_qed_7_we    (func_qed_7_we)
,.func_qed_7_wdata (func_qed_7_wdata)
,.func_qed_7_rdata (func_qed_7_rdata)

,.pf_qed_7_re      (pf_qed_7_re)
,.pf_qed_7_addr    (pf_qed_7_addr)
,.pf_qed_7_we      (pf_qed_7_we)
,.pf_qed_7_wdata   (pf_qed_7_wdata)
,.pf_qed_7_rdata   (pf_qed_7_rdata)

,.sr_qed_7_clk (sr_qed_7_clk)
,.sr_qed_7_clk_rst_n (sr_qed_7_clk_rst_n)
,.sr_qed_7_re    (sr_qed_7_re)
,.sr_qed_7_addr  (sr_qed_7_addr)
,.sr_qed_7_we    (sr_qed_7_we)
,.sr_qed_7_wdata (sr_qed_7_wdata)
,.sr_qed_7_rdata (sr_qed_7_rdata)

,.sr_qed_7_error (sr_qed_7_error)

);
// END HQM_RAM_ACCESS

//---------------------------------------------------------------------------------------------------------
// common core - Interface & clock control

logic unit_idle_local ;
logic inp_fifo_empty_pre ;
assign inp_fifo_empty_pre =  ~ ( rop_qed_dqed_enq_v ) ;
hqm_AW_module_clock_control_wpre # (
  .REQS ( 4 )
) i_hqm_AW_module_clock_control (
    .hqm_inp_gated_clk                    ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                  ( hqm_inp_gated_rst_n )
  , .hqm_gated_clk                        ( hqm_gated_clk )
  , .hqm_gated_rst_n                      ( hqm_gated_rst_n )
  , .cfg_co_dly                           ( { 2'd0 , hqm_qed_target_cfg_patch_control_reg_f [ 13 : 0 ] } )
  , .cfg_co_disable                       ( hqm_qed_target_cfg_patch_control_reg_f [ 31 ] )
  , .hqm_proc_clk_en                      ( hqm_proc_clk_en )
  , .unit_idle_local                      ( unit_idle_local )
  , .unit_idle                            ( qed_unit_idle )
  , .inp_fifo_empty_pre                   ( inp_fifo_empty_pre )
  , .inp_fifo_empty                       ( { cfg_rx_idle
                                            , rx_sync_rop_qed_dqed_enq_idle
                                            , rx_sync_nalb_qed_idle
                                            , rx_sync_dp_dqed_idle
                                            }
                                          )
  , .inp_fifo_en                          ( { cfg_rx_enable
                                            , rx_sync_rop_qed_dqed_enq_enable
                                            , rx_sync_nalb_qed_enable
                                            , rx_sync_dp_dqed_enable
                                            }
                                          )
  , .cfg_idle                             ( cfg_idle )
  , .int_idle                             ( int_idle )

  , .rst_prep                             ( rst_prep )
  , .reset_active                         ( hqm_gated_rst_n_active )
) ;

//....................................................................................................
// to maintain system order from rop need to disable the interface when idling for cfg access.
logic cfg_req_idlepipe ;
logic cfg_req_ready ;
assign rop_qed_enq_ready                        = ( cfg_req_idlepipe ) ? 1'b0 : wire_rop_qed_enq_ready ;
assign rop_dqed_enq_ready                       = rop_qed_enq_ready ;
assign wire_rop_qed_dqed_enq_v                  = ( cfg_req_idlepipe ) ? 1'b0 : ( rop_qed_dqed_enq_v ) ;
assign wire_rop_qed_dqed_enq_data.cmd           = rop_qed_dqed_enq_data.cmd ;
assign wire_rop_qed_dqed_enq_data.flid          = rop_qed_dqed_enq_data.flid ;
assign wire_rop_qed_dqed_enq_data.flid_parity   = rop_qed_dqed_enq_data.flid_parity ^ rop_qed_dqed_enq_data.cmd [ 1 ] ^ rop_qed_dqed_enq_data.cmd [ 0 ] ;
assign wire_rop_qed_dqed_enq_data.cq_hcw        = rop_qed_dqed_enq_data.cq_hcw ;
assign wire_rop_qed_dqed_enq_data.cq_hcw_ecc    = rop_qed_dqed_enq_data.cq_hcw_ecc ;

hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( wire_rop_qed_dqed_enq_data ) )
,   .ENABLE_DROPREADY                   ( 1 )
  , .SEED                               ( 32'h0f )
) i_rx_sync_rop_qed_dqed_enq (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk ) 
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_rop_qed_dqed_enq_status_pnc )
  , .enable                             ( rx_sync_rop_qed_dqed_enq_enable )
  , .idle                               ( rx_sync_rop_qed_dqed_enq_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( wire_rop_qed_dqed_enq_v )
  , .in_ready                           ( wire_rop_qed_enq_ready )
  , .in_data                            ( wire_rop_qed_dqed_enq_data )
  , .out_valid                          ( rx_sync_rop_qed_dqed_enq_valid )
  , .out_ready                          ( rx_sync_rop_qed_dqed_enq_ready )
  , .out_data                           ( rx_sync_rop_qed_dqed_enq_data )
  , .mem_we                             ( func_rx_sync_rop_qed_dqed_enq_we )
  , .mem_waddr                          ( func_rx_sync_rop_qed_dqed_enq_waddr )
  , .mem_wdata                          ( func_rx_sync_rop_qed_dqed_enq_wdata )
  , .mem_re                             ( func_rx_sync_rop_qed_dqed_enq_re )
  , .mem_raddr                          ( func_rx_sync_rop_qed_dqed_enq_raddr )
  , .mem_rdata                          ( func_rx_sync_rop_qed_dqed_enq_rdata )
  , .agit_enable                        ( hqm_qed_target_cfg_hw_agitate_select_reg_f [0] )
  , .agit_control                       ( hqm_qed_target_cfg_hw_agitate_control_reg_f )
) ;

hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_dp_dqed_data ) )
  , .SEED                               ( 32'h1e )
) i_rx_sync_dp_dqed (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_dp_dqed_status_pnc )
  , .enable                             ( rx_sync_dp_dqed_enable )
  , .idle                               ( rx_sync_dp_dqed_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( dp_dqed_v )
  , .in_ready                           ( dp_dqed_ready )
  , .in_data                            ( dp_dqed_data )
  , .out_valid                          ( rx_sync_dp_dqed_valid )
  , .out_ready                          ( rx_sync_dp_dqed_ready )
  , .out_data                           ( rx_sync_dp_dqed_data )
  , .mem_we                             ( func_rx_sync_dp_dqed_data_we )
  , .mem_waddr                          ( func_rx_sync_dp_dqed_data_waddr )
  , .mem_wdata                          ( func_rx_sync_dp_dqed_data_wdata )
  , .mem_re                             ( func_rx_sync_dp_dqed_data_re )
  , .mem_raddr                          ( func_rx_sync_dp_dqed_data_raddr )
  , .mem_rdata                          ( func_rx_sync_dp_dqed_data_rdata )
  , .agit_enable                        ( '0 )
  , .agit_control                       ( '0 )
) ;

hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_nalb_qed_data ) )
  , .SEED                               ( 32'h1e )
) i_rx_sync_nalb_qed (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_nalb_qed_status_pnc )
  , .enable                             ( rx_sync_nalb_qed_enable )
  , .idle                               ( rx_sync_nalb_qed_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( nalb_qed_v )
  , .in_ready                           ( nalb_qed_ready )
  , .in_data                            ( nalb_qed_data )
  , .out_valid                          ( rx_sync_nalb_qed_valid )
  , .out_ready                          ( rx_sync_nalb_qed_ready )
  , .out_data                           ( rx_sync_nalb_qed_data )
  , .mem_we                             ( func_rx_sync_nalb_qed_data_we )
  , .mem_waddr                          ( func_rx_sync_nalb_qed_data_waddr )
  , .mem_wdata                          ( func_rx_sync_nalb_qed_data_wdata )
  , .mem_re                             ( func_rx_sync_nalb_qed_data_re )
  , .mem_raddr                          ( func_rx_sync_nalb_qed_data_raddr )
  , .mem_rdata                          ( func_rx_sync_nalb_qed_data_rdata )
  , .agit_enable                        ( '0 )
  , .agit_control                       ( '0 )
) ;

//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar
cfg_req_t unit_cfg_req ;
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write ;
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read ;
logic unit_cfg_rsp_ack ;
logic unit_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ] unit_cfg_rsp_rdata ;
hqm_AW_cfg_ring_top # (
          .NODE_ID                     ( HQM_QED_CFG_NODE_ID )
        , .UNIT_ID                     ( HQM_QED_CFG_UNIT_ID )
        , .UNIT_TGT_MAP                ( HQM_QED_CFG_UNIT_TGT_MAP )
        , .UNIT_NUM_TGTS               ( HQM_QED_CFG_UNIT_NUM_TGTS )
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

        , .up_cfg_req_write            ( qed_cfg_req_up_write )
        , .up_cfg_req_read             ( qed_cfg_req_up_read )
        , .up_cfg_req                  ( qed_cfg_req_up )
        , .up_cfg_rsp_ack              ( qed_cfg_rsp_up_ack )
        , .up_cfg_rsp                  ( qed_cfg_rsp_up )

        , .down_cfg_req_write          ( nalb_cfg_req_up_write )
        , .down_cfg_req_read           ( nalb_cfg_req_up_read )
        , .down_cfg_req                ( nalb_cfg_req_up )
        , .down_cfg_rsp_ack            ( nalb_cfg_rsp_up_ack )
        , .down_cfg_rsp                ( nalb_cfg_rsp_up )

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
assign hqm_qed_target_cfg_unit_timeout_reg_nxt = {hqm_qed_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign cfg_unit_timeout = {hqm_qed_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_qed_target_cfg_unit_timeout_reg_f[4:0];

localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_qed_target_cfg_unit_version_status = cfg_unit_version;

//------------------------------------------------------------------------------------------------------------------
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write ;
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read ;
hqm_AW_cfg_sc # (
          .MODULE                      ( HQM_QED_CFG_NODE_ID )
        , .NUM_CFG_TARGETS             ( HQM_QED_CFG_UNIT_NUM_TGTS )
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

end

//---------------------------------------------------------------------------------------------------------
// common core - Interrupt serializer. Capture all interrutps from unit and send on interrupt ring

hqm_AW_int_serializer # (
    .NUM_INF                            ( HQM_QED_ALARM_NUM_INF )
  , .NUM_COR                            ( HQM_QED_ALARM_NUM_COR )
  , .NUM_UNC                            ( HQM_QED_ALARM_NUM_UNC )
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

  , .int_up_v                           ( qed_alarm_up_v )
  , .int_up_ready                       ( qed_alarm_up_ready )
  , .int_up_data                        ( qed_alarm_up_data )

  , .int_down_v                         ( nalb_alarm_up_v )
  , .int_down_ready                     ( nalb_alarm_up_ready )
  , .int_down_data                      ( nalb_alarm_up_data )

  , .status                             ( int_status )
  , .int_idle                           ( int_idle )
) ;

logic err_hw_class_01_v_nxt , err_hw_class_01_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_01_nxt , err_hw_class_01_f ;

assign err_hw_class_01_nxt [ 0 ]  = error_badcmd1 ;
assign err_hw_class_01_nxt [ 1 ]  = hqm_qed_pipe_rw_error ;
assign err_hw_class_01_nxt [ 2 ]  = 1'b0 ;
assign err_hw_class_01_nxt [ 3 ]  = parity_check_enq_flid_error ;
assign err_hw_class_01_nxt [ 4 ]  = parity_check_sch_qed_flid_error ;
assign err_hw_class_01_nxt [ 5 ]  = parity_check_sch_dqed_flid_error ;
assign err_hw_class_01_nxt [ 6 ]  = cfg_rx_fifo_status.overflow ;
assign err_hw_class_01_nxt [ 7 ]  = cfg_rx_fifo_status.underflow ;
assign err_hw_class_01_nxt [ 8 ]  = rx_sync_rop_qed_dqed_enq_status_pnc.underflow ;
assign err_hw_class_01_nxt [ 9 ]  = rx_sync_rop_qed_dqed_enq_status_pnc.overflow ;
assign err_hw_class_01_nxt [ 10 ] = rx_sync_nalb_qed_status_pnc.underflow ;
assign err_hw_class_01_nxt [ 11 ] = rx_sync_nalb_qed_status_pnc.overflow ;
assign err_hw_class_01_nxt [ 12 ] = rx_sync_dp_dqed_status_pnc.underflow ;
assign err_hw_class_01_nxt [ 13 ] = rx_sync_dp_dqed_status_pnc.overflow ;
assign err_hw_class_01_nxt [ 14 ] = hqm_qed_pipe_rfw_top_ipar_error ;
assign err_hw_class_01_nxt [ 15 ] = '0 ;
assign err_hw_class_01_nxt [ 16 ] = '0 ;
assign err_hw_class_01_nxt [ 17 ] = '0 ;
assign err_hw_class_01_nxt [ 18 ] = '0 ;
assign err_hw_class_01_nxt [ 19 ] = '0 ;
assign err_hw_class_01_nxt [ 20 ] = '0 ;
assign err_hw_class_01_nxt [ 21 ] = '0 ;
assign err_hw_class_01_nxt [ 22 ] = '0 ;
assign err_hw_class_01_nxt [ 23 ] = '0 ;
assign err_hw_class_01_nxt [ 24 ] = '0 ;
assign err_hw_class_01_nxt [ 25 ] = '0 ;
assign err_hw_class_01_nxt [ 26 ] = '0 ;
assign err_hw_class_01_nxt [ 27 ] = ( sr_qed_0_error
                                    | sr_qed_1_error
                                    | sr_qed_2_error
                                    | sr_qed_3_error
                                    | sr_qed_4_error
                                    | sr_qed_5_error
                                    | sr_qed_6_error
                                    | sr_qed_7_error
                                    | rf_rx_sync_rop_qed_dqed_enq_error
                                    | rf_rx_sync_dp_dqed_data_error
                                    | rf_qed_chp_sch_data_error
                                    | rf_rx_sync_nalb_qed_data_error
                                    ) ;
assign err_hw_class_01_nxt [ 30 : 28 ] = 3'd1 ;
assign err_hw_class_01_v_nxt = ( | err_hw_class_01_nxt [ 27 : 0 ] ) ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    err_hw_class_01_f <= '0 ;
    err_hw_class_01_v_f <= '0 ;
    
  end
  else begin
    err_hw_class_01_f <= err_hw_class_01_nxt ;
    err_hw_class_01_v_f <= err_hw_class_01_v_nxt ;
  end
end

always_comb begin
  int_uid                                          = HQM_QED_CFG_UNIT_ID ;
  int_unc_v                                        = '0 ;
  int_unc_data                                     = '0 ;
  int_cor_v                                        = '0 ;
  int_cor_data                                     = '0 ;
  int_inf_v                                        = '0 ;
  int_inf_data                                     = '0 ;
  hqm_qed_target_cfg_syndrome_00_capture_v         = '0 ;
  hqm_qed_target_cfg_syndrome_00_capture_data      = '0 ;
  
  //  err_hw_class_01_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_01_v_f & ~hqm_qed_target_cfg_qed_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_qed_target_cfg_syndrome_00_capture_v       = ~hqm_qed_target_cfg_qed_csr_control_reg_f[5] ;
    hqm_qed_target_cfg_syndrome_00_capture_data    = err_hw_class_01_f ;
  end

end


//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: END common core interfaces 
//*****************************************************************************************************
//*****************************************************************************************************

hqm_nalb_pipe_core i_hqm_nalb_pipe_core (
  .hqm_gated_clk ( hqm_gated_clk_nalb )
, .hqm_gated_rst_b ( hqm_gated_rst_b_nalb )
, .hqm_inp_gated_clk ( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_b ( hqm_inp_gated_rst_b_nalb )
, .hqm_rst_prep ( hqm_rst_prep_nalb )
, .hqm_gated_rst_n_start ( hqm_gated_rst_b_start_nalb )
, .hqm_gated_rst_n_active ( hqm_gated_rst_b_active_nalb )
, .hqm_gated_rst_n_done ( hqm_gated_rst_b_done_nalb )
, .hqm_proc_clk_en ( hqm_proc_clk_en_nalb )
, .nalb_qed_force_clockon ( nalb_qed_force_clockon )
, .nalb_unit_idle ( nalb_unit_idle )
, .nalb_unit_pipeidle ( nalb_unit_pipeidle )
, .nalb_reset_done ( nalb_reset_done )
, .nalb_cfg_req_up_read ( nalb_cfg_req_up_read )
, .nalb_cfg_req_up_write ( nalb_cfg_req_up_write )
, .nalb_cfg_req_up ( nalb_cfg_req_up )
, .nalb_cfg_rsp_up_ack ( nalb_cfg_rsp_up_ack )
, .nalb_cfg_rsp_up ( nalb_cfg_rsp_up )
, .nalb_cfg_req_down_read ( dp_cfg_req_up_read )
, .nalb_cfg_req_down_write ( dp_cfg_req_up_write )
, .nalb_cfg_req_down ( dp_cfg_req_up )
, .nalb_cfg_rsp_down_ack ( dp_cfg_rsp_up_ack )
, .nalb_cfg_rsp_down (dp_cfg_rsp_up )
, .nalb_alarm_up_v ( nalb_alarm_up_v )
, .nalb_alarm_up_ready ( nalb_alarm_up_ready )
, .nalb_alarm_up_data ( nalb_alarm_up_data )
, .nalb_alarm_down_v ( dp_alarm_up_v )
, .nalb_alarm_down_ready ( dp_alarm_up_ready )
, .nalb_alarm_down_data ( dp_alarm_up_data )
, .rop_nalb_enq_v ( rop_nalb_enq_v )
, .rop_nalb_enq_ready ( rop_nalb_enq_ready )
, .rop_nalb_enq_data ( rop_nalb_enq_data )
, .lsp_nalb_sch_unoord_v ( lsp_nalb_sch_unoord_v )
, .lsp_nalb_sch_unoord_ready ( lsp_nalb_sch_unoord_ready )
, .lsp_nalb_sch_unoord_data ( lsp_nalb_sch_unoord_data )
, .lsp_nalb_sch_rorply_v ( lsp_nalb_sch_rorply_v )
, .lsp_nalb_sch_rorply_ready ( lsp_nalb_sch_rorply_ready )
, .lsp_nalb_sch_rorply_data ( lsp_nalb_sch_rorply_data )
, .lsp_nalb_sch_atq_v ( lsp_nalb_sch_atq_v )
, .lsp_nalb_sch_atq_ready ( lsp_nalb_sch_atq_ready )
, .lsp_nalb_sch_atq_data ( lsp_nalb_sch_atq_data )
, .nalb_lsp_enq_lb_v ( nalb_lsp_enq_lb_v )
, .nalb_lsp_enq_lb_ready ( nalb_lsp_enq_lb_ready )
, .nalb_lsp_enq_lb_data ( nalb_lsp_enq_lb_data )
, .nalb_lsp_enq_rorply_v ( nalb_lsp_enq_rorply_v )
, .nalb_lsp_enq_rorply_ready ( nalb_lsp_enq_rorply_ready )
, .nalb_lsp_enq_rorply_data ( nalb_lsp_enq_rorply_data )
, .nalb_qed_v ( nalb_qed_v )
, .nalb_qed_ready ( nalb_qed_ready )
, .nalb_qed_data ( nalb_qed_data )
// BEGIN HQM_MEMPORT_INST hqm_nalb_pipe_core
    ,.rf_atq_cnt_re                                     (rf_atq_cnt_re)
    ,.rf_atq_cnt_rclk                                   (rf_atq_cnt_rclk)
    ,.rf_atq_cnt_rclk_rst_n                             (rf_atq_cnt_rclk_rst_n)
    ,.rf_atq_cnt_raddr                                  (rf_atq_cnt_raddr)
    ,.rf_atq_cnt_waddr                                  (rf_atq_cnt_waddr)
    ,.rf_atq_cnt_we                                     (rf_atq_cnt_we)
    ,.rf_atq_cnt_wclk                                   (rf_atq_cnt_wclk)
    ,.rf_atq_cnt_wclk_rst_n                             (rf_atq_cnt_wclk_rst_n)
    ,.rf_atq_cnt_wdata                                  (rf_atq_cnt_wdata)
    ,.rf_atq_cnt_rdata                                  (rf_atq_cnt_rdata)

    ,.rf_atq_hp_re                                      (rf_atq_hp_re)
    ,.rf_atq_hp_rclk                                    (rf_atq_hp_rclk)
    ,.rf_atq_hp_rclk_rst_n                              (rf_atq_hp_rclk_rst_n)
    ,.rf_atq_hp_raddr                                   (rf_atq_hp_raddr)
    ,.rf_atq_hp_waddr                                   (rf_atq_hp_waddr)
    ,.rf_atq_hp_we                                      (rf_atq_hp_we)
    ,.rf_atq_hp_wclk                                    (rf_atq_hp_wclk)
    ,.rf_atq_hp_wclk_rst_n                              (rf_atq_hp_wclk_rst_n)
    ,.rf_atq_hp_wdata                                   (rf_atq_hp_wdata)
    ,.rf_atq_hp_rdata                                   (rf_atq_hp_rdata)

    ,.rf_atq_tp_re                                      (rf_atq_tp_re)
    ,.rf_atq_tp_rclk                                    (rf_atq_tp_rclk)
    ,.rf_atq_tp_rclk_rst_n                              (rf_atq_tp_rclk_rst_n)
    ,.rf_atq_tp_raddr                                   (rf_atq_tp_raddr)
    ,.rf_atq_tp_waddr                                   (rf_atq_tp_waddr)
    ,.rf_atq_tp_we                                      (rf_atq_tp_we)
    ,.rf_atq_tp_wclk                                    (rf_atq_tp_wclk)
    ,.rf_atq_tp_wclk_rst_n                              (rf_atq_tp_wclk_rst_n)
    ,.rf_atq_tp_wdata                                   (rf_atq_tp_wdata)
    ,.rf_atq_tp_rdata                                   (rf_atq_tp_rdata)

    ,.rf_lsp_nalb_sch_atq_re                            (rf_lsp_nalb_sch_atq_re)
    ,.rf_lsp_nalb_sch_atq_rclk                          (rf_lsp_nalb_sch_atq_rclk)
    ,.rf_lsp_nalb_sch_atq_rclk_rst_n                    (rf_lsp_nalb_sch_atq_rclk_rst_n)
    ,.rf_lsp_nalb_sch_atq_raddr                         (rf_lsp_nalb_sch_atq_raddr)
    ,.rf_lsp_nalb_sch_atq_waddr                         (rf_lsp_nalb_sch_atq_waddr)
    ,.rf_lsp_nalb_sch_atq_we                            (rf_lsp_nalb_sch_atq_we)
    ,.rf_lsp_nalb_sch_atq_wclk                          (rf_lsp_nalb_sch_atq_wclk)
    ,.rf_lsp_nalb_sch_atq_wclk_rst_n                    (rf_lsp_nalb_sch_atq_wclk_rst_n)
    ,.rf_lsp_nalb_sch_atq_wdata                         (rf_lsp_nalb_sch_atq_wdata)
    ,.rf_lsp_nalb_sch_atq_rdata                         (rf_lsp_nalb_sch_atq_rdata)

    ,.rf_lsp_nalb_sch_rorply_re                         (rf_lsp_nalb_sch_rorply_re)
    ,.rf_lsp_nalb_sch_rorply_rclk                       (rf_lsp_nalb_sch_rorply_rclk)
    ,.rf_lsp_nalb_sch_rorply_rclk_rst_n                 (rf_lsp_nalb_sch_rorply_rclk_rst_n)
    ,.rf_lsp_nalb_sch_rorply_raddr                      (rf_lsp_nalb_sch_rorply_raddr)
    ,.rf_lsp_nalb_sch_rorply_waddr                      (rf_lsp_nalb_sch_rorply_waddr)
    ,.rf_lsp_nalb_sch_rorply_we                         (rf_lsp_nalb_sch_rorply_we)
    ,.rf_lsp_nalb_sch_rorply_wclk                       (rf_lsp_nalb_sch_rorply_wclk)
    ,.rf_lsp_nalb_sch_rorply_wclk_rst_n                 (rf_lsp_nalb_sch_rorply_wclk_rst_n)
    ,.rf_lsp_nalb_sch_rorply_wdata                      (rf_lsp_nalb_sch_rorply_wdata)
    ,.rf_lsp_nalb_sch_rorply_rdata                      (rf_lsp_nalb_sch_rorply_rdata)

    ,.rf_lsp_nalb_sch_unoord_re                         (rf_lsp_nalb_sch_unoord_re)
    ,.rf_lsp_nalb_sch_unoord_rclk                       (rf_lsp_nalb_sch_unoord_rclk)
    ,.rf_lsp_nalb_sch_unoord_rclk_rst_n                 (rf_lsp_nalb_sch_unoord_rclk_rst_n)
    ,.rf_lsp_nalb_sch_unoord_raddr                      (rf_lsp_nalb_sch_unoord_raddr)
    ,.rf_lsp_nalb_sch_unoord_waddr                      (rf_lsp_nalb_sch_unoord_waddr)
    ,.rf_lsp_nalb_sch_unoord_we                         (rf_lsp_nalb_sch_unoord_we)
    ,.rf_lsp_nalb_sch_unoord_wclk                       (rf_lsp_nalb_sch_unoord_wclk)
    ,.rf_lsp_nalb_sch_unoord_wclk_rst_n                 (rf_lsp_nalb_sch_unoord_wclk_rst_n)
    ,.rf_lsp_nalb_sch_unoord_wdata                      (rf_lsp_nalb_sch_unoord_wdata)
    ,.rf_lsp_nalb_sch_unoord_rdata                      (rf_lsp_nalb_sch_unoord_rdata)

    ,.rf_nalb_cnt_re                                    (rf_nalb_cnt_re)
    ,.rf_nalb_cnt_rclk                                  (rf_nalb_cnt_rclk)
    ,.rf_nalb_cnt_rclk_rst_n                            (rf_nalb_cnt_rclk_rst_n)
    ,.rf_nalb_cnt_raddr                                 (rf_nalb_cnt_raddr)
    ,.rf_nalb_cnt_waddr                                 (rf_nalb_cnt_waddr)
    ,.rf_nalb_cnt_we                                    (rf_nalb_cnt_we)
    ,.rf_nalb_cnt_wclk                                  (rf_nalb_cnt_wclk)
    ,.rf_nalb_cnt_wclk_rst_n                            (rf_nalb_cnt_wclk_rst_n)
    ,.rf_nalb_cnt_wdata                                 (rf_nalb_cnt_wdata)
    ,.rf_nalb_cnt_rdata                                 (rf_nalb_cnt_rdata)

    ,.rf_nalb_hp_re                                     (rf_nalb_hp_re)
    ,.rf_nalb_hp_rclk                                   (rf_nalb_hp_rclk)
    ,.rf_nalb_hp_rclk_rst_n                             (rf_nalb_hp_rclk_rst_n)
    ,.rf_nalb_hp_raddr                                  (rf_nalb_hp_raddr)
    ,.rf_nalb_hp_waddr                                  (rf_nalb_hp_waddr)
    ,.rf_nalb_hp_we                                     (rf_nalb_hp_we)
    ,.rf_nalb_hp_wclk                                   (rf_nalb_hp_wclk)
    ,.rf_nalb_hp_wclk_rst_n                             (rf_nalb_hp_wclk_rst_n)
    ,.rf_nalb_hp_wdata                                  (rf_nalb_hp_wdata)
    ,.rf_nalb_hp_rdata                                  (rf_nalb_hp_rdata)

    ,.rf_nalb_lsp_enq_rorply_re                         (rf_nalb_lsp_enq_rorply_re)
    ,.rf_nalb_lsp_enq_rorply_rclk                       (rf_nalb_lsp_enq_rorply_rclk)
    ,.rf_nalb_lsp_enq_rorply_rclk_rst_n                 (rf_nalb_lsp_enq_rorply_rclk_rst_n)
    ,.rf_nalb_lsp_enq_rorply_raddr                      (rf_nalb_lsp_enq_rorply_raddr)
    ,.rf_nalb_lsp_enq_rorply_waddr                      (rf_nalb_lsp_enq_rorply_waddr)
    ,.rf_nalb_lsp_enq_rorply_we                         (rf_nalb_lsp_enq_rorply_we)
    ,.rf_nalb_lsp_enq_rorply_wclk                       (rf_nalb_lsp_enq_rorply_wclk)
    ,.rf_nalb_lsp_enq_rorply_wclk_rst_n                 (rf_nalb_lsp_enq_rorply_wclk_rst_n)
    ,.rf_nalb_lsp_enq_rorply_wdata                      (rf_nalb_lsp_enq_rorply_wdata)
    ,.rf_nalb_lsp_enq_rorply_rdata                      (rf_nalb_lsp_enq_rorply_rdata)

    ,.rf_nalb_lsp_enq_unoord_re                         (rf_nalb_lsp_enq_unoord_re)
    ,.rf_nalb_lsp_enq_unoord_rclk                       (rf_nalb_lsp_enq_unoord_rclk)
    ,.rf_nalb_lsp_enq_unoord_rclk_rst_n                 (rf_nalb_lsp_enq_unoord_rclk_rst_n)
    ,.rf_nalb_lsp_enq_unoord_raddr                      (rf_nalb_lsp_enq_unoord_raddr)
    ,.rf_nalb_lsp_enq_unoord_waddr                      (rf_nalb_lsp_enq_unoord_waddr)
    ,.rf_nalb_lsp_enq_unoord_we                         (rf_nalb_lsp_enq_unoord_we)
    ,.rf_nalb_lsp_enq_unoord_wclk                       (rf_nalb_lsp_enq_unoord_wclk)
    ,.rf_nalb_lsp_enq_unoord_wclk_rst_n                 (rf_nalb_lsp_enq_unoord_wclk_rst_n)
    ,.rf_nalb_lsp_enq_unoord_wdata                      (rf_nalb_lsp_enq_unoord_wdata)
    ,.rf_nalb_lsp_enq_unoord_rdata                      (rf_nalb_lsp_enq_unoord_rdata)

    ,.rf_nalb_qed_re                                    (rf_nalb_qed_re)
    ,.rf_nalb_qed_rclk                                  (rf_nalb_qed_rclk)
    ,.rf_nalb_qed_rclk_rst_n                            (rf_nalb_qed_rclk_rst_n)
    ,.rf_nalb_qed_raddr                                 (rf_nalb_qed_raddr)
    ,.rf_nalb_qed_waddr                                 (rf_nalb_qed_waddr)
    ,.rf_nalb_qed_we                                    (rf_nalb_qed_we)
    ,.rf_nalb_qed_wclk                                  (rf_nalb_qed_wclk)
    ,.rf_nalb_qed_wclk_rst_n                            (rf_nalb_qed_wclk_rst_n)
    ,.rf_nalb_qed_wdata                                 (rf_nalb_qed_wdata)
    ,.rf_nalb_qed_rdata                                 (rf_nalb_qed_rdata)

    ,.rf_nalb_replay_cnt_re                             (rf_nalb_replay_cnt_re)
    ,.rf_nalb_replay_cnt_rclk                           (rf_nalb_replay_cnt_rclk)
    ,.rf_nalb_replay_cnt_rclk_rst_n                     (rf_nalb_replay_cnt_rclk_rst_n)
    ,.rf_nalb_replay_cnt_raddr                          (rf_nalb_replay_cnt_raddr)
    ,.rf_nalb_replay_cnt_waddr                          (rf_nalb_replay_cnt_waddr)
    ,.rf_nalb_replay_cnt_we                             (rf_nalb_replay_cnt_we)
    ,.rf_nalb_replay_cnt_wclk                           (rf_nalb_replay_cnt_wclk)
    ,.rf_nalb_replay_cnt_wclk_rst_n                     (rf_nalb_replay_cnt_wclk_rst_n)
    ,.rf_nalb_replay_cnt_wdata                          (rf_nalb_replay_cnt_wdata)
    ,.rf_nalb_replay_cnt_rdata                          (rf_nalb_replay_cnt_rdata)

    ,.rf_nalb_replay_hp_re                              (rf_nalb_replay_hp_re)
    ,.rf_nalb_replay_hp_rclk                            (rf_nalb_replay_hp_rclk)
    ,.rf_nalb_replay_hp_rclk_rst_n                      (rf_nalb_replay_hp_rclk_rst_n)
    ,.rf_nalb_replay_hp_raddr                           (rf_nalb_replay_hp_raddr)
    ,.rf_nalb_replay_hp_waddr                           (rf_nalb_replay_hp_waddr)
    ,.rf_nalb_replay_hp_we                              (rf_nalb_replay_hp_we)
    ,.rf_nalb_replay_hp_wclk                            (rf_nalb_replay_hp_wclk)
    ,.rf_nalb_replay_hp_wclk_rst_n                      (rf_nalb_replay_hp_wclk_rst_n)
    ,.rf_nalb_replay_hp_wdata                           (rf_nalb_replay_hp_wdata)
    ,.rf_nalb_replay_hp_rdata                           (rf_nalb_replay_hp_rdata)

    ,.rf_nalb_replay_tp_re                              (rf_nalb_replay_tp_re)
    ,.rf_nalb_replay_tp_rclk                            (rf_nalb_replay_tp_rclk)
    ,.rf_nalb_replay_tp_rclk_rst_n                      (rf_nalb_replay_tp_rclk_rst_n)
    ,.rf_nalb_replay_tp_raddr                           (rf_nalb_replay_tp_raddr)
    ,.rf_nalb_replay_tp_waddr                           (rf_nalb_replay_tp_waddr)
    ,.rf_nalb_replay_tp_we                              (rf_nalb_replay_tp_we)
    ,.rf_nalb_replay_tp_wclk                            (rf_nalb_replay_tp_wclk)
    ,.rf_nalb_replay_tp_wclk_rst_n                      (rf_nalb_replay_tp_wclk_rst_n)
    ,.rf_nalb_replay_tp_wdata                           (rf_nalb_replay_tp_wdata)
    ,.rf_nalb_replay_tp_rdata                           (rf_nalb_replay_tp_rdata)

    ,.rf_nalb_rofrag_cnt_re                             (rf_nalb_rofrag_cnt_re)
    ,.rf_nalb_rofrag_cnt_rclk                           (rf_nalb_rofrag_cnt_rclk)
    ,.rf_nalb_rofrag_cnt_rclk_rst_n                     (rf_nalb_rofrag_cnt_rclk_rst_n)
    ,.rf_nalb_rofrag_cnt_raddr                          (rf_nalb_rofrag_cnt_raddr)
    ,.rf_nalb_rofrag_cnt_waddr                          (rf_nalb_rofrag_cnt_waddr)
    ,.rf_nalb_rofrag_cnt_we                             (rf_nalb_rofrag_cnt_we)
    ,.rf_nalb_rofrag_cnt_wclk                           (rf_nalb_rofrag_cnt_wclk)
    ,.rf_nalb_rofrag_cnt_wclk_rst_n                     (rf_nalb_rofrag_cnt_wclk_rst_n)
    ,.rf_nalb_rofrag_cnt_wdata                          (rf_nalb_rofrag_cnt_wdata)
    ,.rf_nalb_rofrag_cnt_rdata                          (rf_nalb_rofrag_cnt_rdata)

    ,.rf_nalb_rofrag_hp_re                              (rf_nalb_rofrag_hp_re)
    ,.rf_nalb_rofrag_hp_rclk                            (rf_nalb_rofrag_hp_rclk)
    ,.rf_nalb_rofrag_hp_rclk_rst_n                      (rf_nalb_rofrag_hp_rclk_rst_n)
    ,.rf_nalb_rofrag_hp_raddr                           (rf_nalb_rofrag_hp_raddr)
    ,.rf_nalb_rofrag_hp_waddr                           (rf_nalb_rofrag_hp_waddr)
    ,.rf_nalb_rofrag_hp_we                              (rf_nalb_rofrag_hp_we)
    ,.rf_nalb_rofrag_hp_wclk                            (rf_nalb_rofrag_hp_wclk)
    ,.rf_nalb_rofrag_hp_wclk_rst_n                      (rf_nalb_rofrag_hp_wclk_rst_n)
    ,.rf_nalb_rofrag_hp_wdata                           (rf_nalb_rofrag_hp_wdata)
    ,.rf_nalb_rofrag_hp_rdata                           (rf_nalb_rofrag_hp_rdata)

    ,.rf_nalb_rofrag_tp_re                              (rf_nalb_rofrag_tp_re)
    ,.rf_nalb_rofrag_tp_rclk                            (rf_nalb_rofrag_tp_rclk)
    ,.rf_nalb_rofrag_tp_rclk_rst_n                      (rf_nalb_rofrag_tp_rclk_rst_n)
    ,.rf_nalb_rofrag_tp_raddr                           (rf_nalb_rofrag_tp_raddr)
    ,.rf_nalb_rofrag_tp_waddr                           (rf_nalb_rofrag_tp_waddr)
    ,.rf_nalb_rofrag_tp_we                              (rf_nalb_rofrag_tp_we)
    ,.rf_nalb_rofrag_tp_wclk                            (rf_nalb_rofrag_tp_wclk)
    ,.rf_nalb_rofrag_tp_wclk_rst_n                      (rf_nalb_rofrag_tp_wclk_rst_n)
    ,.rf_nalb_rofrag_tp_wdata                           (rf_nalb_rofrag_tp_wdata)
    ,.rf_nalb_rofrag_tp_rdata                           (rf_nalb_rofrag_tp_rdata)

    ,.rf_nalb_tp_re                                     (rf_nalb_tp_re)
    ,.rf_nalb_tp_rclk                                   (rf_nalb_tp_rclk)
    ,.rf_nalb_tp_rclk_rst_n                             (rf_nalb_tp_rclk_rst_n)
    ,.rf_nalb_tp_raddr                                  (rf_nalb_tp_raddr)
    ,.rf_nalb_tp_waddr                                  (rf_nalb_tp_waddr)
    ,.rf_nalb_tp_we                                     (rf_nalb_tp_we)
    ,.rf_nalb_tp_wclk                                   (rf_nalb_tp_wclk)
    ,.rf_nalb_tp_wclk_rst_n                             (rf_nalb_tp_wclk_rst_n)
    ,.rf_nalb_tp_wdata                                  (rf_nalb_tp_wdata)
    ,.rf_nalb_tp_rdata                                  (rf_nalb_tp_rdata)

    ,.rf_rop_nalb_enq_ro_re                             (rf_rop_nalb_enq_ro_re)
    ,.rf_rop_nalb_enq_ro_rclk                           (rf_rop_nalb_enq_ro_rclk)
    ,.rf_rop_nalb_enq_ro_rclk_rst_n                     (rf_rop_nalb_enq_ro_rclk_rst_n)
    ,.rf_rop_nalb_enq_ro_raddr                          (rf_rop_nalb_enq_ro_raddr)
    ,.rf_rop_nalb_enq_ro_waddr                          (rf_rop_nalb_enq_ro_waddr)
    ,.rf_rop_nalb_enq_ro_we                             (rf_rop_nalb_enq_ro_we)
    ,.rf_rop_nalb_enq_ro_wclk                           (rf_rop_nalb_enq_ro_wclk)
    ,.rf_rop_nalb_enq_ro_wclk_rst_n                     (rf_rop_nalb_enq_ro_wclk_rst_n)
    ,.rf_rop_nalb_enq_ro_wdata                          (rf_rop_nalb_enq_ro_wdata)
    ,.rf_rop_nalb_enq_ro_rdata                          (rf_rop_nalb_enq_ro_rdata)

    ,.rf_rop_nalb_enq_unoord_re                         (rf_rop_nalb_enq_unoord_re)
    ,.rf_rop_nalb_enq_unoord_rclk                       (rf_rop_nalb_enq_unoord_rclk)
    ,.rf_rop_nalb_enq_unoord_rclk_rst_n                 (rf_rop_nalb_enq_unoord_rclk_rst_n)
    ,.rf_rop_nalb_enq_unoord_raddr                      (rf_rop_nalb_enq_unoord_raddr)
    ,.rf_rop_nalb_enq_unoord_waddr                      (rf_rop_nalb_enq_unoord_waddr)
    ,.rf_rop_nalb_enq_unoord_we                         (rf_rop_nalb_enq_unoord_we)
    ,.rf_rop_nalb_enq_unoord_wclk                       (rf_rop_nalb_enq_unoord_wclk)
    ,.rf_rop_nalb_enq_unoord_wclk_rst_n                 (rf_rop_nalb_enq_unoord_wclk_rst_n)
    ,.rf_rop_nalb_enq_unoord_wdata                      (rf_rop_nalb_enq_unoord_wdata)
    ,.rf_rop_nalb_enq_unoord_rdata                      (rf_rop_nalb_enq_unoord_rdata)

    ,.rf_rx_sync_lsp_nalb_sch_atq_re                    (rf_rx_sync_lsp_nalb_sch_atq_re)
    ,.rf_rx_sync_lsp_nalb_sch_atq_rclk                  (rf_rx_sync_lsp_nalb_sch_atq_rclk)
    ,.rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n            (rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n)
    ,.rf_rx_sync_lsp_nalb_sch_atq_raddr                 (rf_rx_sync_lsp_nalb_sch_atq_raddr)
    ,.rf_rx_sync_lsp_nalb_sch_atq_waddr                 (rf_rx_sync_lsp_nalb_sch_atq_waddr)
    ,.rf_rx_sync_lsp_nalb_sch_atq_we                    (rf_rx_sync_lsp_nalb_sch_atq_we)
    ,.rf_rx_sync_lsp_nalb_sch_atq_wclk                  (rf_rx_sync_lsp_nalb_sch_atq_wclk)
    ,.rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n            (rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n)
    ,.rf_rx_sync_lsp_nalb_sch_atq_wdata                 (rf_rx_sync_lsp_nalb_sch_atq_wdata)
    ,.rf_rx_sync_lsp_nalb_sch_atq_rdata                 (rf_rx_sync_lsp_nalb_sch_atq_rdata)

    ,.rf_rx_sync_lsp_nalb_sch_rorply_re                 (rf_rx_sync_lsp_nalb_sch_rorply_re)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_rclk               (rf_rx_sync_lsp_nalb_sch_rorply_rclk)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n         (rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_raddr              (rf_rx_sync_lsp_nalb_sch_rorply_raddr)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_waddr              (rf_rx_sync_lsp_nalb_sch_rorply_waddr)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_we                 (rf_rx_sync_lsp_nalb_sch_rorply_we)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_wclk               (rf_rx_sync_lsp_nalb_sch_rorply_wclk)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n         (rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_wdata              (rf_rx_sync_lsp_nalb_sch_rorply_wdata)
    ,.rf_rx_sync_lsp_nalb_sch_rorply_rdata              (rf_rx_sync_lsp_nalb_sch_rorply_rdata)

    ,.rf_rx_sync_lsp_nalb_sch_unoord_re                 (rf_rx_sync_lsp_nalb_sch_unoord_re)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_rclk               (rf_rx_sync_lsp_nalb_sch_unoord_rclk)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n         (rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_raddr              (rf_rx_sync_lsp_nalb_sch_unoord_raddr)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_waddr              (rf_rx_sync_lsp_nalb_sch_unoord_waddr)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_we                 (rf_rx_sync_lsp_nalb_sch_unoord_we)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_wclk               (rf_rx_sync_lsp_nalb_sch_unoord_wclk)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n         (rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_wdata              (rf_rx_sync_lsp_nalb_sch_unoord_wdata)
    ,.rf_rx_sync_lsp_nalb_sch_unoord_rdata              (rf_rx_sync_lsp_nalb_sch_unoord_rdata)

    ,.rf_rx_sync_rop_nalb_enq_re                        (rf_rx_sync_rop_nalb_enq_re)
    ,.rf_rx_sync_rop_nalb_enq_rclk                      (rf_rx_sync_rop_nalb_enq_rclk)
    ,.rf_rx_sync_rop_nalb_enq_rclk_rst_n                (rf_rx_sync_rop_nalb_enq_rclk_rst_n)
    ,.rf_rx_sync_rop_nalb_enq_raddr                     (rf_rx_sync_rop_nalb_enq_raddr)
    ,.rf_rx_sync_rop_nalb_enq_waddr                     (rf_rx_sync_rop_nalb_enq_waddr)
    ,.rf_rx_sync_rop_nalb_enq_we                        (rf_rx_sync_rop_nalb_enq_we)
    ,.rf_rx_sync_rop_nalb_enq_wclk                      (rf_rx_sync_rop_nalb_enq_wclk)
    ,.rf_rx_sync_rop_nalb_enq_wclk_rst_n                (rf_rx_sync_rop_nalb_enq_wclk_rst_n)
    ,.rf_rx_sync_rop_nalb_enq_wdata                     (rf_rx_sync_rop_nalb_enq_wdata)
    ,.rf_rx_sync_rop_nalb_enq_rdata                     (rf_rx_sync_rop_nalb_enq_rdata)

    ,.sr_nalb_nxthp_re                                  (sr_nalb_nxthp_re)
    ,.sr_nalb_nxthp_clk                                 (sr_nalb_nxthp_clk)
    ,.sr_nalb_nxthp_clk_rst_n                           (sr_nalb_nxthp_clk_rst_n)
    ,.sr_nalb_nxthp_addr                                (sr_nalb_nxthp_addr)
    ,.sr_nalb_nxthp_we                                  (sr_nalb_nxthp_we)
    ,.sr_nalb_nxthp_wdata                               (sr_nalb_nxthp_wdata)
    ,.sr_nalb_nxthp_rdata                               (sr_nalb_nxthp_rdata)

// END HQM_MEMPORT_INST hqm_nalb_pipe_core
) ;

hqm_dir_pipe_core i_hqm_dir_pipe_core (
  .hqm_gated_clk ( hqm_gated_clk_dir )
, .hqm_gated_rst_b ( hqm_gated_rst_b_dir )
, .hqm_inp_gated_clk ( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_b ( hqm_inp_gated_rst_b_dir )
, .hqm_rst_prep ( hqm_rst_prep_dir )
, .hqm_gated_rst_n_start ( hqm_gated_rst_b_start_dir )
, .hqm_gated_rst_n_active ( hqm_gated_rst_b_active_dir )
, .hqm_gated_rst_n_done ( hqm_gated_rst_b_done_dir )
, .hqm_proc_clk_en ( hqm_proc_clk_en_dir  )
, .dp_dqed_force_clockon ( dp_dqed_force_clockon )
, .dp_unit_idle ( dp_unit_idle )
, .dp_unit_pipeidle ( dp_unit_pipeidle )
, .dp_reset_done ( dp_reset_done )
, .dp_cfg_req_up_read ( dp_cfg_req_up_read )
, .dp_cfg_req_up_write ( dp_cfg_req_up_write )
, .dp_cfg_req_up ( dp_cfg_req_up )
, .dp_cfg_rsp_up_ack ( dp_cfg_rsp_up_ack )
, .dp_cfg_rsp_up ( dp_cfg_rsp_up )
, .dp_cfg_req_down_read ( qed_cfg_req_down_read )
, .dp_cfg_req_down_write ( qed_cfg_req_down_write )
, .dp_cfg_req_down ( qed_cfg_req_down )
, .dp_cfg_rsp_down_ack ( qed_cfg_rsp_down_ack )
, .dp_cfg_rsp_down ( qed_cfg_rsp_down )
, .dp_alarm_up_v ( dp_alarm_up_v )
, .dp_alarm_up_ready ( dp_alarm_up_ready )
, .dp_alarm_up_data ( dp_alarm_up_data )
, .dp_alarm_down_v ( qed_alarm_down_v )
, .dp_alarm_down_ready ( qed_alarm_down_ready )
, .dp_alarm_down_data ( qed_alarm_down_data )
, .rop_dp_enq_v ( rop_dp_enq_v )
, .rop_dp_enq_ready ( rop_dp_enq_ready )
, .rop_dp_enq_data ( rop_dp_enq_data )
, .lsp_dp_sch_dir_v ( lsp_dp_sch_dir_v )
, .lsp_dp_sch_dir_ready ( lsp_dp_sch_dir_ready )
, .lsp_dp_sch_dir_data ( lsp_dp_sch_dir_data )
, .lsp_dp_sch_rorply_v ( lsp_dp_sch_rorply_v )
, .lsp_dp_sch_rorply_ready ( lsp_dp_sch_rorply_ready )
, .lsp_dp_sch_rorply_data ( lsp_dp_sch_rorply_data )
, .dp_lsp_enq_dir_v ( dp_lsp_enq_dir_v )
, .dp_lsp_enq_dir_ready ( dp_lsp_enq_dir_ready )
, .dp_lsp_enq_dir_data ( dp_lsp_enq_dir_data )
, .dp_lsp_enq_rorply_v ( dp_lsp_enq_rorply_v )
, .dp_lsp_enq_rorply_ready ( dp_lsp_enq_rorply_ready )
, .dp_lsp_enq_rorply_data ( dp_lsp_enq_rorply_data )
, .dp_dqed_v ( dp_dqed_v )
, .dp_dqed_ready ( dp_dqed_ready )
, .dp_dqed_data ( dp_dqed_data )
// BEGIN HQM_MEMPORT_INST hqm_dir_pipe_core
    ,.rf_dir_cnt_re                                     (rf_dir_cnt_re)
    ,.rf_dir_cnt_rclk                                   (rf_dir_cnt_rclk)
    ,.rf_dir_cnt_rclk_rst_n                             (rf_dir_cnt_rclk_rst_n)
    ,.rf_dir_cnt_raddr                                  (rf_dir_cnt_raddr)
    ,.rf_dir_cnt_waddr                                  (rf_dir_cnt_waddr)
    ,.rf_dir_cnt_we                                     (rf_dir_cnt_we)
    ,.rf_dir_cnt_wclk                                   (rf_dir_cnt_wclk)
    ,.rf_dir_cnt_wclk_rst_n                             (rf_dir_cnt_wclk_rst_n)
    ,.rf_dir_cnt_wdata                                  (rf_dir_cnt_wdata)
    ,.rf_dir_cnt_rdata                                  (rf_dir_cnt_rdata)

    ,.rf_dir_hp_re                                      (rf_dir_hp_re)
    ,.rf_dir_hp_rclk                                    (rf_dir_hp_rclk)
    ,.rf_dir_hp_rclk_rst_n                              (rf_dir_hp_rclk_rst_n)
    ,.rf_dir_hp_raddr                                   (rf_dir_hp_raddr)
    ,.rf_dir_hp_waddr                                   (rf_dir_hp_waddr)
    ,.rf_dir_hp_we                                      (rf_dir_hp_we)
    ,.rf_dir_hp_wclk                                    (rf_dir_hp_wclk)
    ,.rf_dir_hp_wclk_rst_n                              (rf_dir_hp_wclk_rst_n)
    ,.rf_dir_hp_wdata                                   (rf_dir_hp_wdata)
    ,.rf_dir_hp_rdata                                   (rf_dir_hp_rdata)

    ,.rf_dir_replay_cnt_re                              (rf_dir_replay_cnt_re)
    ,.rf_dir_replay_cnt_rclk                            (rf_dir_replay_cnt_rclk)
    ,.rf_dir_replay_cnt_rclk_rst_n                      (rf_dir_replay_cnt_rclk_rst_n)
    ,.rf_dir_replay_cnt_raddr                           (rf_dir_replay_cnt_raddr)
    ,.rf_dir_replay_cnt_waddr                           (rf_dir_replay_cnt_waddr)
    ,.rf_dir_replay_cnt_we                              (rf_dir_replay_cnt_we)
    ,.rf_dir_replay_cnt_wclk                            (rf_dir_replay_cnt_wclk)
    ,.rf_dir_replay_cnt_wclk_rst_n                      (rf_dir_replay_cnt_wclk_rst_n)
    ,.rf_dir_replay_cnt_wdata                           (rf_dir_replay_cnt_wdata)
    ,.rf_dir_replay_cnt_rdata                           (rf_dir_replay_cnt_rdata)

    ,.rf_dir_replay_hp_re                               (rf_dir_replay_hp_re)
    ,.rf_dir_replay_hp_rclk                             (rf_dir_replay_hp_rclk)
    ,.rf_dir_replay_hp_rclk_rst_n                       (rf_dir_replay_hp_rclk_rst_n)
    ,.rf_dir_replay_hp_raddr                            (rf_dir_replay_hp_raddr)
    ,.rf_dir_replay_hp_waddr                            (rf_dir_replay_hp_waddr)
    ,.rf_dir_replay_hp_we                               (rf_dir_replay_hp_we)
    ,.rf_dir_replay_hp_wclk                             (rf_dir_replay_hp_wclk)
    ,.rf_dir_replay_hp_wclk_rst_n                       (rf_dir_replay_hp_wclk_rst_n)
    ,.rf_dir_replay_hp_wdata                            (rf_dir_replay_hp_wdata)
    ,.rf_dir_replay_hp_rdata                            (rf_dir_replay_hp_rdata)

    ,.rf_dir_replay_tp_re                               (rf_dir_replay_tp_re)
    ,.rf_dir_replay_tp_rclk                             (rf_dir_replay_tp_rclk)
    ,.rf_dir_replay_tp_rclk_rst_n                       (rf_dir_replay_tp_rclk_rst_n)
    ,.rf_dir_replay_tp_raddr                            (rf_dir_replay_tp_raddr)
    ,.rf_dir_replay_tp_waddr                            (rf_dir_replay_tp_waddr)
    ,.rf_dir_replay_tp_we                               (rf_dir_replay_tp_we)
    ,.rf_dir_replay_tp_wclk                             (rf_dir_replay_tp_wclk)
    ,.rf_dir_replay_tp_wclk_rst_n                       (rf_dir_replay_tp_wclk_rst_n)
    ,.rf_dir_replay_tp_wdata                            (rf_dir_replay_tp_wdata)
    ,.rf_dir_replay_tp_rdata                            (rf_dir_replay_tp_rdata)

    ,.rf_dir_rofrag_cnt_re                              (rf_dir_rofrag_cnt_re)
    ,.rf_dir_rofrag_cnt_rclk                            (rf_dir_rofrag_cnt_rclk)
    ,.rf_dir_rofrag_cnt_rclk_rst_n                      (rf_dir_rofrag_cnt_rclk_rst_n)
    ,.rf_dir_rofrag_cnt_raddr                           (rf_dir_rofrag_cnt_raddr)
    ,.rf_dir_rofrag_cnt_waddr                           (rf_dir_rofrag_cnt_waddr)
    ,.rf_dir_rofrag_cnt_we                              (rf_dir_rofrag_cnt_we)
    ,.rf_dir_rofrag_cnt_wclk                            (rf_dir_rofrag_cnt_wclk)
    ,.rf_dir_rofrag_cnt_wclk_rst_n                      (rf_dir_rofrag_cnt_wclk_rst_n)
    ,.rf_dir_rofrag_cnt_wdata                           (rf_dir_rofrag_cnt_wdata)
    ,.rf_dir_rofrag_cnt_rdata                           (rf_dir_rofrag_cnt_rdata)

    ,.rf_dir_rofrag_hp_re                               (rf_dir_rofrag_hp_re)
    ,.rf_dir_rofrag_hp_rclk                             (rf_dir_rofrag_hp_rclk)
    ,.rf_dir_rofrag_hp_rclk_rst_n                       (rf_dir_rofrag_hp_rclk_rst_n)
    ,.rf_dir_rofrag_hp_raddr                            (rf_dir_rofrag_hp_raddr)
    ,.rf_dir_rofrag_hp_waddr                            (rf_dir_rofrag_hp_waddr)
    ,.rf_dir_rofrag_hp_we                               (rf_dir_rofrag_hp_we)
    ,.rf_dir_rofrag_hp_wclk                             (rf_dir_rofrag_hp_wclk)
    ,.rf_dir_rofrag_hp_wclk_rst_n                       (rf_dir_rofrag_hp_wclk_rst_n)
    ,.rf_dir_rofrag_hp_wdata                            (rf_dir_rofrag_hp_wdata)
    ,.rf_dir_rofrag_hp_rdata                            (rf_dir_rofrag_hp_rdata)

    ,.rf_dir_rofrag_tp_re                               (rf_dir_rofrag_tp_re)
    ,.rf_dir_rofrag_tp_rclk                             (rf_dir_rofrag_tp_rclk)
    ,.rf_dir_rofrag_tp_rclk_rst_n                       (rf_dir_rofrag_tp_rclk_rst_n)
    ,.rf_dir_rofrag_tp_raddr                            (rf_dir_rofrag_tp_raddr)
    ,.rf_dir_rofrag_tp_waddr                            (rf_dir_rofrag_tp_waddr)
    ,.rf_dir_rofrag_tp_we                               (rf_dir_rofrag_tp_we)
    ,.rf_dir_rofrag_tp_wclk                             (rf_dir_rofrag_tp_wclk)
    ,.rf_dir_rofrag_tp_wclk_rst_n                       (rf_dir_rofrag_tp_wclk_rst_n)
    ,.rf_dir_rofrag_tp_wdata                            (rf_dir_rofrag_tp_wdata)
    ,.rf_dir_rofrag_tp_rdata                            (rf_dir_rofrag_tp_rdata)

    ,.rf_dir_tp_re                                      (rf_dir_tp_re)
    ,.rf_dir_tp_rclk                                    (rf_dir_tp_rclk)
    ,.rf_dir_tp_rclk_rst_n                              (rf_dir_tp_rclk_rst_n)
    ,.rf_dir_tp_raddr                                   (rf_dir_tp_raddr)
    ,.rf_dir_tp_waddr                                   (rf_dir_tp_waddr)
    ,.rf_dir_tp_we                                      (rf_dir_tp_we)
    ,.rf_dir_tp_wclk                                    (rf_dir_tp_wclk)
    ,.rf_dir_tp_wclk_rst_n                              (rf_dir_tp_wclk_rst_n)
    ,.rf_dir_tp_wdata                                   (rf_dir_tp_wdata)
    ,.rf_dir_tp_rdata                                   (rf_dir_tp_rdata)

    ,.rf_dp_dqed_re                                     (rf_dp_dqed_re)
    ,.rf_dp_dqed_rclk                                   (rf_dp_dqed_rclk)
    ,.rf_dp_dqed_rclk_rst_n                             (rf_dp_dqed_rclk_rst_n)
    ,.rf_dp_dqed_raddr                                  (rf_dp_dqed_raddr)
    ,.rf_dp_dqed_waddr                                  (rf_dp_dqed_waddr)
    ,.rf_dp_dqed_we                                     (rf_dp_dqed_we)
    ,.rf_dp_dqed_wclk                                   (rf_dp_dqed_wclk)
    ,.rf_dp_dqed_wclk_rst_n                             (rf_dp_dqed_wclk_rst_n)
    ,.rf_dp_dqed_wdata                                  (rf_dp_dqed_wdata)
    ,.rf_dp_dqed_rdata                                  (rf_dp_dqed_rdata)

    ,.rf_dp_lsp_enq_dir_re                              (rf_dp_lsp_enq_dir_re)
    ,.rf_dp_lsp_enq_dir_rclk                            (rf_dp_lsp_enq_dir_rclk)
    ,.rf_dp_lsp_enq_dir_rclk_rst_n                      (rf_dp_lsp_enq_dir_rclk_rst_n)
    ,.rf_dp_lsp_enq_dir_raddr                           (rf_dp_lsp_enq_dir_raddr)
    ,.rf_dp_lsp_enq_dir_waddr                           (rf_dp_lsp_enq_dir_waddr)
    ,.rf_dp_lsp_enq_dir_we                              (rf_dp_lsp_enq_dir_we)
    ,.rf_dp_lsp_enq_dir_wclk                            (rf_dp_lsp_enq_dir_wclk)
    ,.rf_dp_lsp_enq_dir_wclk_rst_n                      (rf_dp_lsp_enq_dir_wclk_rst_n)
    ,.rf_dp_lsp_enq_dir_wdata                           (rf_dp_lsp_enq_dir_wdata)
    ,.rf_dp_lsp_enq_dir_rdata                           (rf_dp_lsp_enq_dir_rdata)

    ,.rf_dp_lsp_enq_rorply_re                           (rf_dp_lsp_enq_rorply_re)
    ,.rf_dp_lsp_enq_rorply_rclk                         (rf_dp_lsp_enq_rorply_rclk)
    ,.rf_dp_lsp_enq_rorply_rclk_rst_n                   (rf_dp_lsp_enq_rorply_rclk_rst_n)
    ,.rf_dp_lsp_enq_rorply_raddr                        (rf_dp_lsp_enq_rorply_raddr)
    ,.rf_dp_lsp_enq_rorply_waddr                        (rf_dp_lsp_enq_rorply_waddr)
    ,.rf_dp_lsp_enq_rorply_we                           (rf_dp_lsp_enq_rorply_we)
    ,.rf_dp_lsp_enq_rorply_wclk                         (rf_dp_lsp_enq_rorply_wclk)
    ,.rf_dp_lsp_enq_rorply_wclk_rst_n                   (rf_dp_lsp_enq_rorply_wclk_rst_n)
    ,.rf_dp_lsp_enq_rorply_wdata                        (rf_dp_lsp_enq_rorply_wdata)
    ,.rf_dp_lsp_enq_rorply_rdata                        (rf_dp_lsp_enq_rorply_rdata)

    ,.rf_lsp_dp_sch_dir_re                              (rf_lsp_dp_sch_dir_re)
    ,.rf_lsp_dp_sch_dir_rclk                            (rf_lsp_dp_sch_dir_rclk)
    ,.rf_lsp_dp_sch_dir_rclk_rst_n                      (rf_lsp_dp_sch_dir_rclk_rst_n)
    ,.rf_lsp_dp_sch_dir_raddr                           (rf_lsp_dp_sch_dir_raddr)
    ,.rf_lsp_dp_sch_dir_waddr                           (rf_lsp_dp_sch_dir_waddr)
    ,.rf_lsp_dp_sch_dir_we                              (rf_lsp_dp_sch_dir_we)
    ,.rf_lsp_dp_sch_dir_wclk                            (rf_lsp_dp_sch_dir_wclk)
    ,.rf_lsp_dp_sch_dir_wclk_rst_n                      (rf_lsp_dp_sch_dir_wclk_rst_n)
    ,.rf_lsp_dp_sch_dir_wdata                           (rf_lsp_dp_sch_dir_wdata)
    ,.rf_lsp_dp_sch_dir_rdata                           (rf_lsp_dp_sch_dir_rdata)

    ,.rf_lsp_dp_sch_rorply_re                           (rf_lsp_dp_sch_rorply_re)
    ,.rf_lsp_dp_sch_rorply_rclk                         (rf_lsp_dp_sch_rorply_rclk)
    ,.rf_lsp_dp_sch_rorply_rclk_rst_n                   (rf_lsp_dp_sch_rorply_rclk_rst_n)
    ,.rf_lsp_dp_sch_rorply_raddr                        (rf_lsp_dp_sch_rorply_raddr)
    ,.rf_lsp_dp_sch_rorply_waddr                        (rf_lsp_dp_sch_rorply_waddr)
    ,.rf_lsp_dp_sch_rorply_we                           (rf_lsp_dp_sch_rorply_we)
    ,.rf_lsp_dp_sch_rorply_wclk                         (rf_lsp_dp_sch_rorply_wclk)
    ,.rf_lsp_dp_sch_rorply_wclk_rst_n                   (rf_lsp_dp_sch_rorply_wclk_rst_n)
    ,.rf_lsp_dp_sch_rorply_wdata                        (rf_lsp_dp_sch_rorply_wdata)
    ,.rf_lsp_dp_sch_rorply_rdata                        (rf_lsp_dp_sch_rorply_rdata)

    ,.rf_rop_dp_enq_dir_re                              (rf_rop_dp_enq_dir_re)
    ,.rf_rop_dp_enq_dir_rclk                            (rf_rop_dp_enq_dir_rclk)
    ,.rf_rop_dp_enq_dir_rclk_rst_n                      (rf_rop_dp_enq_dir_rclk_rst_n)
    ,.rf_rop_dp_enq_dir_raddr                           (rf_rop_dp_enq_dir_raddr)
    ,.rf_rop_dp_enq_dir_waddr                           (rf_rop_dp_enq_dir_waddr)
    ,.rf_rop_dp_enq_dir_we                              (rf_rop_dp_enq_dir_we)
    ,.rf_rop_dp_enq_dir_wclk                            (rf_rop_dp_enq_dir_wclk)
    ,.rf_rop_dp_enq_dir_wclk_rst_n                      (rf_rop_dp_enq_dir_wclk_rst_n)
    ,.rf_rop_dp_enq_dir_wdata                           (rf_rop_dp_enq_dir_wdata)
    ,.rf_rop_dp_enq_dir_rdata                           (rf_rop_dp_enq_dir_rdata)

    ,.rf_rop_dp_enq_ro_re                               (rf_rop_dp_enq_ro_re)
    ,.rf_rop_dp_enq_ro_rclk                             (rf_rop_dp_enq_ro_rclk)
    ,.rf_rop_dp_enq_ro_rclk_rst_n                       (rf_rop_dp_enq_ro_rclk_rst_n)
    ,.rf_rop_dp_enq_ro_raddr                            (rf_rop_dp_enq_ro_raddr)
    ,.rf_rop_dp_enq_ro_waddr                            (rf_rop_dp_enq_ro_waddr)
    ,.rf_rop_dp_enq_ro_we                               (rf_rop_dp_enq_ro_we)
    ,.rf_rop_dp_enq_ro_wclk                             (rf_rop_dp_enq_ro_wclk)
    ,.rf_rop_dp_enq_ro_wclk_rst_n                       (rf_rop_dp_enq_ro_wclk_rst_n)
    ,.rf_rop_dp_enq_ro_wdata                            (rf_rop_dp_enq_ro_wdata)
    ,.rf_rop_dp_enq_ro_rdata                            (rf_rop_dp_enq_ro_rdata)

    ,.rf_rx_sync_lsp_dp_sch_dir_re                      (rf_rx_sync_lsp_dp_sch_dir_re)
    ,.rf_rx_sync_lsp_dp_sch_dir_rclk                    (rf_rx_sync_lsp_dp_sch_dir_rclk)
    ,.rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n              (rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n)
    ,.rf_rx_sync_lsp_dp_sch_dir_raddr                   (rf_rx_sync_lsp_dp_sch_dir_raddr)
    ,.rf_rx_sync_lsp_dp_sch_dir_waddr                   (rf_rx_sync_lsp_dp_sch_dir_waddr)
    ,.rf_rx_sync_lsp_dp_sch_dir_we                      (rf_rx_sync_lsp_dp_sch_dir_we)
    ,.rf_rx_sync_lsp_dp_sch_dir_wclk                    (rf_rx_sync_lsp_dp_sch_dir_wclk)
    ,.rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n              (rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n)
    ,.rf_rx_sync_lsp_dp_sch_dir_wdata                   (rf_rx_sync_lsp_dp_sch_dir_wdata)
    ,.rf_rx_sync_lsp_dp_sch_dir_rdata                   (rf_rx_sync_lsp_dp_sch_dir_rdata)

    ,.rf_rx_sync_lsp_dp_sch_rorply_re                   (rf_rx_sync_lsp_dp_sch_rorply_re)
    ,.rf_rx_sync_lsp_dp_sch_rorply_rclk                 (rf_rx_sync_lsp_dp_sch_rorply_rclk)
    ,.rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n           (rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n)
    ,.rf_rx_sync_lsp_dp_sch_rorply_raddr                (rf_rx_sync_lsp_dp_sch_rorply_raddr)
    ,.rf_rx_sync_lsp_dp_sch_rorply_waddr                (rf_rx_sync_lsp_dp_sch_rorply_waddr)
    ,.rf_rx_sync_lsp_dp_sch_rorply_we                   (rf_rx_sync_lsp_dp_sch_rorply_we)
    ,.rf_rx_sync_lsp_dp_sch_rorply_wclk                 (rf_rx_sync_lsp_dp_sch_rorply_wclk)
    ,.rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n           (rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n)
    ,.rf_rx_sync_lsp_dp_sch_rorply_wdata                (rf_rx_sync_lsp_dp_sch_rorply_wdata)
    ,.rf_rx_sync_lsp_dp_sch_rorply_rdata                (rf_rx_sync_lsp_dp_sch_rorply_rdata)

    ,.rf_rx_sync_rop_dp_enq_re                          (rf_rx_sync_rop_dp_enq_re)
    ,.rf_rx_sync_rop_dp_enq_rclk                        (rf_rx_sync_rop_dp_enq_rclk)
    ,.rf_rx_sync_rop_dp_enq_rclk_rst_n                  (rf_rx_sync_rop_dp_enq_rclk_rst_n)
    ,.rf_rx_sync_rop_dp_enq_raddr                       (rf_rx_sync_rop_dp_enq_raddr)
    ,.rf_rx_sync_rop_dp_enq_waddr                       (rf_rx_sync_rop_dp_enq_waddr)
    ,.rf_rx_sync_rop_dp_enq_we                          (rf_rx_sync_rop_dp_enq_we)
    ,.rf_rx_sync_rop_dp_enq_wclk                        (rf_rx_sync_rop_dp_enq_wclk)
    ,.rf_rx_sync_rop_dp_enq_wclk_rst_n                  (rf_rx_sync_rop_dp_enq_wclk_rst_n)
    ,.rf_rx_sync_rop_dp_enq_wdata                       (rf_rx_sync_rop_dp_enq_wdata)
    ,.rf_rx_sync_rop_dp_enq_rdata                       (rf_rx_sync_rop_dp_enq_rdata)

    ,.sr_dir_nxthp_re                                   (sr_dir_nxthp_re)
    ,.sr_dir_nxthp_clk                                  (sr_dir_nxthp_clk)
    ,.sr_dir_nxthp_clk_rst_n                            (sr_dir_nxthp_clk_rst_n)
    ,.sr_dir_nxthp_addr                                 (sr_dir_nxthp_addr)
    ,.sr_dir_nxthp_we                                   (sr_dir_nxthp_we)
    ,.sr_dir_nxthp_wdata                                (sr_dir_nxthp_wdata)
    ,.sr_dir_nxthp_rdata                                (sr_dir_nxthp_rdata)

// END HQM_MEMPORT_INST hqm_dir_pipe_core
) ;

hqm_qed_pipe_rw # (
  .QED_DEPTHB2 ( $bits ( sr_qed_0_addr ) )
) i_hqm_qed_pipe_rw (
  .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_b ( hqm_gated_rst_n )
, .rst_prep ( rst_prep )
, .cfg_req_idlepipe ( cfg_req_idlepipe )
, .cfg_fifo_qed_chp_sch_crd_hwm ( cfg_fifo_qed_chp_sch_crd_hwm )
, .error ( hqm_qed_pipe_rw_error )
, .pipe_idle ( hqm_qed_pipe_rw_pipe_idle )
, .idle ( hqm_qed_pipe_rw_idle )
, .debug ( hqm_qed_pipe_rw_debug )
, .counter_inc_1rdy_1sel ( counter_inc_1rdy_1sel )
, .counter_inc_2rdy_1sel ( counter_inc_2rdy_1sel )
, .counter_inc_2rdy_2sel ( counter_inc_2rdy_2sel )
, .counter_inc_3rdy_1sel ( counter_inc_3rdy_1sel )
, .counter_inc_3rdy_2sel ( counter_inc_3rdy_2sel )
, .func_qed_chp_sch_data_re ( func_qed_chp_sch_data_re )
, .func_qed_chp_sch_data_raddr ( func_qed_chp_sch_data_raddr )
, .func_qed_chp_sch_data_waddr ( func_qed_chp_sch_data_waddr )
, .func_qed_chp_sch_data_we ( func_qed_chp_sch_data_we )
, .func_qed_chp_sch_data_wdata ( func_qed_chp_sch_data_wdata )
, .func_qed_chp_sch_data_rdata ( func_qed_chp_sch_data_rdata )
, .func_qed_0_re ( func_qed_0_re )
, .func_qed_0_addr ( func_qed_0_addr )
, .func_qed_0_we ( func_qed_0_we )
, .func_qed_0_wdata ( func_qed_0_wdata )
, .func_qed_0_rdata ( func_qed_0_rdata )
, .func_qed_1_re ( func_qed_1_re )
, .func_qed_1_addr ( func_qed_1_addr )
, .func_qed_1_we ( func_qed_1_we )
, .func_qed_1_wdata ( func_qed_1_wdata )
, .func_qed_1_rdata ( func_qed_1_rdata )
, .func_qed_2_re ( func_qed_2_re )
, .func_qed_2_addr ( func_qed_2_addr )
, .func_qed_2_we ( func_qed_2_we )
, .func_qed_2_wdata ( func_qed_2_wdata )
, .func_qed_2_rdata ( func_qed_2_rdata )
, .func_qed_3_re ( func_qed_3_re )
, .func_qed_3_addr ( func_qed_3_addr )
, .func_qed_3_we ( func_qed_3_we )
, .func_qed_3_wdata ( func_qed_3_wdata )
, .func_qed_3_rdata ( func_qed_3_rdata )
, .func_qed_4_re ( func_qed_4_re )
, .func_qed_4_addr ( func_qed_4_addr )
, .func_qed_4_we ( func_qed_4_we )
, .func_qed_4_wdata ( func_qed_4_wdata )
, .func_qed_4_rdata ( func_qed_4_rdata )
, .func_qed_5_re ( func_qed_5_re )
, .func_qed_5_addr ( func_qed_5_addr )
, .func_qed_5_we ( func_qed_5_we )
, .func_qed_5_wdata ( func_qed_5_wdata )
, .func_qed_5_rdata ( func_qed_5_rdata )
, .func_qed_6_re ( func_qed_6_re )
, .func_qed_6_addr ( func_qed_6_addr )
, .func_qed_6_we ( func_qed_6_we )
, .func_qed_6_wdata ( func_qed_6_wdata )
, .func_qed_6_rdata ( func_qed_6_rdata )
, .func_qed_7_re ( func_qed_7_re )
, .func_qed_7_addr ( func_qed_7_addr )
, .func_qed_7_we ( func_qed_7_we )
, .func_qed_7_wdata ( func_qed_7_wdata )
, .func_qed_7_rdata ( func_qed_7_rdata )
, .rx_sync_rop_qed_dqed_enq_ready ( rx_sync_rop_qed_dqed_enq_ready )
, .rx_sync_rop_qed_dqed_enq_valid ( rx_sync_rop_qed_dqed_enq_valid )
, .rx_sync_rop_qed_dqed_enq_data ( rx_sync_rop_qed_dqed_enq_data )
, .rx_sync_nalb_qed_ready ( rx_sync_nalb_qed_ready )
, .rx_sync_nalb_qed_valid ( rx_sync_nalb_qed_valid )
, .rx_sync_nalb_qed_data ( wire_rx_sync_nalb_qed_data )
, .rx_sync_dp_dqed_ready ( rx_sync_dp_dqed_ready )
, .rx_sync_dp_dqed_valid ( rx_sync_dp_dqed_valid )
, .rx_sync_dp_dqed_data ( wire_rx_sync_dp_dqed_data )
, .qed_chp_sch_v ( qed_chp_sch_v )
, .qed_chp_sch_ready ( qed_chp_sch_ready )
, .qed_chp_sch_data ( qed_chp_sch_data )
, .qed_aqed_enq_v ( qed_aqed_enq_v )
, .qed_aqed_enq_ready ( qed_aqed_enq_ready )
, .qed_aqed_enq_data ( qed_aqed_enq_data )
, .qed_lsp_deq_v ( qed_lsp_deq_v )
, .qed_lsp_deq_data ( qed_lsp_deq_data )
);

hqm_AW_parity_gen # (
  .WIDTH ( 7 )
) i_parity_gen_nalb_qed (
  .d ( parity_gen_nalb_qed_d )
, .odd ( 1'b0 )
, .p ( parity_gen_nalb_qed_p )
) ;

hqm_AW_parity_gen # (
  .WIDTH ( 10 )
) i_parity_gen_dp_dqed (
  .d ( parity_gen_dp_dqed_d )
, .odd ( 1'b0 )
, .p ( parity_gen_dp_dqed_p )
) ;

hqm_AW_parity_check # (
  .WIDTH ( 15 + 2 )
) i_parity_check_enq_flid (
  .p ( parity_check_enq_flid_p )
, .d ( parity_check_enq_flid_data )
, .e ( parity_check_enq_flid_e )
, .odd ( 1'b1 )
, .err ( parity_check_enq_flid_error )
) ;

hqm_AW_parity_check # (
  .WIDTH ( 15 )
) i_parity_check_sch_dqed_flid (
  .p ( parity_check_sch_dqed_flid_p )
, .d ( parity_check_sch_dqed_flid_data )
, .e ( parity_check_sch_dqed_flid_e )
, .odd ( 1'b1 )
, .err ( parity_check_sch_dqed_flid_error )
) ;

hqm_AW_parity_check # (
  .WIDTH ( 15 )
) i_parity_check_sch_qed_flid (
  .p ( parity_check_sch_qed_flid_p )
, .d ( parity_check_sch_qed_flid_data )
, .e ( parity_check_sch_qed_flid_e )
, .odd ( 1'b1 )
, .err ( parity_check_sch_qed_flid_error )
) ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L02
  if ( ! hqm_gated_rst_n ) begin
    smon_v_f <= '0 ;
    smon_comp_f <= '0 ;
    smon_val_f <= '0 ;

    reset_pf_counter_f <= '0 ;
    reset_pf_active_f <= 1'b1 ;
    reset_pf_done_f <= '0 ;
    hw_init_done_f <= '0 ;
  end
  else begin
    smon_v_f <= smon_v_nxt ;
    smon_comp_f <= smon_comp_nxt ;
    smon_val_f <= smon_val_nxt ;

    reset_pf_counter_f <= reset_pf_counter_nxt ;
    reset_pf_active_f <= reset_pf_active_nxt ; 
    reset_pf_done_f <= reset_pf_done_nxt ;
    hw_init_done_f <= hw_init_done_nxt ; 
  end
end




always_comb begin


  //....................................................................................................
  // detect errors
  error_badcmd1 = ( ( rx_sync_nalb_qed_valid & rx_sync_nalb_qed_ready & ( ( rx_sync_nalb_qed_data.cmd == NALB_QED_ILL0 ) ) )
                  | ( rx_sync_dp_dqed_valid & rx_sync_dp_dqed_ready & ( ( rx_sync_dp_dqed_data.cmd == DP_DQED_ILL0 ) | ( rx_sync_dp_dqed_data.cmd == DP_DQED_ILL3 ) ) )
                  ) ;

  parity_gen_nalb_qed_d = { rx_sync_nalb_qed_data.qid } ;
  wire_rx_sync_nalb_qed_data = rx_sync_nalb_qed_data ;
  wire_rx_sync_nalb_qed_data.parity = rx_sync_nalb_qed_data.parity ^ parity_gen_nalb_qed_p ;

  parity_gen_dp_dqed_d = { rx_sync_dp_dqed_data.qid , rx_sync_dp_dqed_data.qidix } ;
  wire_rx_sync_dp_dqed_data = rx_sync_dp_dqed_data ;
  wire_rx_sync_dp_dqed_data.parity = rx_sync_dp_dqed_data.parity ^ parity_gen_dp_dqed_p ;

  parity_check_enq_flid_e = rx_sync_rop_qed_dqed_enq_valid & rx_sync_rop_qed_dqed_enq_ready &
                            ( ( rx_sync_rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_LB ) |
                              ( rx_sync_rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_DIR ) ) ;
  parity_check_enq_flid_p = rx_sync_rop_qed_dqed_enq_data.flid_parity ;
  parity_check_enq_flid_data = { rx_sync_rop_qed_dqed_enq_data.flid , rx_sync_rop_qed_dqed_enq_data.cmd } ;

  parity_check_sch_qed_flid_e = rx_sync_nalb_qed_valid & rx_sync_nalb_qed_ready ;
  parity_check_sch_qed_flid_p = rx_sync_nalb_qed_data.flid_parity ;
  parity_check_sch_qed_flid_data = rx_sync_nalb_qed_data.flid ;

  parity_check_sch_dqed_flid_e = rx_sync_dp_dqed_valid & rx_sync_dp_dqed_ready ;
  parity_check_sch_dqed_flid_p = rx_sync_dp_dqed_data.flid_parity ;
  parity_check_sch_dqed_flid_data = rx_sync_dp_dqed_data.flid ;

  //....................................................................................................
  // sidecar CFG
  //   control unit CFG registers
  //     reset status register (cfg accesible)
  //     default to init RAM
  //     check for pipe idle & stop processing

  //....................................................................................................
  // CFG register update values
  hqm_qed_target_cfg_qed_csr_control_reg_v              = 1'b0 ;
  hqm_qed_target_cfg_qed_csr_control_reg_nxt            = hqm_qed_target_cfg_qed_csr_control_reg_f ;
  hqm_qed_target_cfg_patch_control_reg_v                = 1'b0 ;
  hqm_qed_target_cfg_patch_control_reg_nxt              = hqm_qed_target_cfg_patch_control_reg_f ;
  hqm_qed_target_cfg_control_general_reg_v              = 1'b0 ;
  hqm_qed_target_cfg_control_general_reg_nxt            = hqm_qed_target_cfg_control_general_reg_f ;
  hqm_qed_target_cfg_control_pipeline_credits_reg_v     = 1'b0 ;
  hqm_qed_target_cfg_control_pipeline_credits_reg_nxt   = hqm_qed_target_cfg_control_pipeline_credits_reg_f ;
    cfg_fifo_qed_chp_sch_crd_hwm                        = hqm_qed_target_cfg_control_pipeline_credits_reg_f [ 3: 0 ] ;
  hqm_qed_target_cfg_hw_agitate_control_reg_v           = 1'b0 ;
  hqm_qed_target_cfg_hw_agitate_control_reg_nxt         = hqm_qed_target_cfg_hw_agitate_control_reg_f ;
  hqm_qed_target_cfg_hw_agitate_select_reg_v            = 1'b0 ;
  hqm_qed_target_cfg_hw_agitate_select_reg_nxt          = hqm_qed_target_cfg_hw_agitate_select_reg_f ;
  hqm_qed_target_cfg_error_inject_reg_v                 = 1'b0 ;
  hqm_qed_target_cfg_error_inject_reg_nxt               = hqm_qed_target_cfg_error_inject_reg_f ;

  hqm_qed_target_cfg_smon_disable_smon                  = disable_smon ;
  hqm_qed_target_cfg_smon_smon_v                        = smon_v_f ;
  hqm_qed_target_cfg_smon_smon_comp                     = smon_comp_f ;
  hqm_qed_target_cfg_smon_smon_val                      = smon_val_f ;

  hqm_qed_target_cfg_diagnostic_aw_status_status        = { int_status [ 15 : 0 ] , hqm_qed_pipe_rw_debug [ 15 : 0 ] };

  hqm_qed_target_cfg_interface_status_reg_nxt           =  { 1'b0
                                                           , int_idle
                                                           , rop_qed_dqed_enq_v
                                                           , rop_qed_enq_ready
                                                           , qed_chp_sch_v
                                                           , qed_chp_sch_ready
                                                           , qed_aqed_enq_v
                                                           , qed_aqed_enq_ready
                                                           , 1'b0
                                                           , 1'b1
                                                           , rop_dp_enq_v
                                                           , rop_dp_enq_ready
                                                           , lsp_dp_sch_dir_v
                                                           , lsp_dp_sch_dir_ready
                                                           , lsp_dp_sch_rorply_v
                                                           , lsp_dp_sch_rorply_ready
                                                           , dp_lsp_enq_dir_v
                                                           , dp_lsp_enq_dir_ready
                                                           , dp_lsp_enq_rorply_v
                                                           , dp_lsp_enq_rorply_ready
                                                           , rop_nalb_enq_v
                                                           , rop_nalb_enq_ready
                                                           , lsp_nalb_sch_unoord_v
                                                           , lsp_nalb_sch_unoord_ready
                                                           , lsp_nalb_sch_rorply_v
                                                           , lsp_nalb_sch_rorply_ready
                                                           , lsp_nalb_sch_atq_v
                                                           , lsp_nalb_sch_atq_ready
                                                           , nalb_lsp_enq_lb_v
                                                           , nalb_lsp_enq_lb_ready
                                                           , nalb_lsp_enq_rorply_v
                                                           , nalb_lsp_enq_rorply_ready
                                                           } ;

  hqm_qed_target_cfg_pipe_health_hold_reg_nxt           = hqm_qed_target_cfg_pipe_health_hold_reg_f ;

  hqm_qed_target_cfg_pipe_health_valid_reg_nxt          = hqm_qed_target_cfg_pipe_health_valid_reg_f ;
  hqm_qed_target_cfg_pipe_health_valid_reg_nxt [ 0 ]    = hqm_qed_pipe_rw_pipe_idle ;


  //PERF counters
  hqm_qed_target_cfg_2rdy1iss_en                        = counter_inc_2rdy_1sel ;
  hqm_qed_target_cfg_2rdy1iss_clr                       = 1'b0 ;
  hqm_qed_target_cfg_2rdy1iss_clrv                      = 1'b0 ;
  hqm_qed_target_cfg_2rdy1iss_inc                       = counter_inc_2rdy_1sel ;

  hqm_qed_target_cfg_2rdy2iss_en                        = counter_inc_2rdy_2sel ;
  hqm_qed_target_cfg_2rdy2iss_clr                       = 1'b0 ;
  hqm_qed_target_cfg_2rdy2iss_clrv                      = 1'b0 ;
  hqm_qed_target_cfg_2rdy2iss_inc                       = counter_inc_2rdy_2sel ;

  hqm_qed_target_cfg_3rdy1iss_en                        = counter_inc_3rdy_1sel ;
  hqm_qed_target_cfg_3rdy1iss_clr                       = 1'b0 ;
  hqm_qed_target_cfg_3rdy1iss_clrv                      = 1'b0 ;
  hqm_qed_target_cfg_3rdy1iss_inc                       = counter_inc_3rdy_1sel ;

  hqm_qed_target_cfg_3rdy2iss_en                        = counter_inc_3rdy_2sel ;
  hqm_qed_target_cfg_3rdy2iss_clr                       = 1'b0 ;
  hqm_qed_target_cfg_3rdy2iss_clrv                      = 1'b0 ;
  hqm_qed_target_cfg_3rdy2iss_inc                       = counter_inc_3rdy_2sel ;



  // IDLE signals
  cfg_unit_idle_reg_f                                   = hqm_qed_target_cfg_unit_idle_reg_f ; // attach strucutres using cfg_unit_idle_reg_f
  cfg_unit_idle_reg_nxt                                 = cfg_unit_idle_reg_f ;  // attach strucutres using cfg_unit_idle_reg_f

  cfg_unit_idle_reg_nxt.pipe_idle                       = (   hqm_qed_target_cfg_pipe_health_valid_reg_nxt [ 0 ]  ) ;

  cfg_unit_idle_reg_nxt.unit_idle                       = ( ( cfg_unit_idle_reg_nxt.pipe_idle )
                                                          & ( hqm_qed_pipe_rw_idle )
//hqm_inp_gated_clk                                                          & ( cfg_idle )
//hqm_inp_gated_clk                                                          & ( int_idle )
//hqm_inp_gated_clk                                                          & ( rx_sync_nalb_qed_idle )
//hqm_inp_gated_clk                                                          & ( rx_sync_dp_dqed_idle )
//hqm_inp_gated_clk                                                          & ( rx_sync_rop_qed_dqed_enq_idle )
                                                          ) ;

  qed_reset_done                                        = ~ ( hqm_gated_rst_n_active ) ;
  unit_idle_local                                       = ( ( ~ hqm_gated_rst_n_active )
                                                          & ( cfg_unit_idle_reg_nxt.unit_idle )
                                                          & ( inp_fifo_empty_pre )
                                                          & ( ~ nalb_qed_force_clockon )
                                                          & ( ~ dp_dqed_force_clockon )
                                                          & ( ~ rop_qed_force_clockon )
                                                          ) ;
  qed_unit_pipeidle                                     = cfg_unit_idle_reg_f.pipe_idle ;

  //control CFG access. Queue the CFG access until the pipe is idle then issue the reqeust and keep the pipe idle until complete
  cfg_req_ready                                         = cfg_unit_idle_reg_f.cfg_ready ;
  cfg_unit_idle_reg_nxt.cfg_ready                       = ( ( cfg_unit_idle_reg_nxt.pipe_idle  )
                                                          & ( rx_sync_rop_qed_dqed_enq_idle )
                                                          ) ;

  // assign after all updates
  hqm_qed_target_cfg_unit_idle_reg_nxt                  = cfg_unit_idle_reg_nxt ; // attach strucutres using cfg_unit_idle_reg_f
  //....................................................................................................
  // PF reset
pf_qed_6_re = '0 ;
pf_qed_6_addr = '0 ;
pf_qed_6_we = '0 ;
pf_qed_6_wdata = '0 ;
pf_qed_0_re = '0 ;
pf_qed_0_addr = '0 ;
pf_qed_0_we = '0 ;
pf_qed_0_wdata = '0 ;
pf_qed_7_re = '0 ;
pf_qed_7_addr = '0 ;
pf_qed_7_we = '0 ;
pf_qed_7_wdata = '0 ;
pf_qed_3_re = '0 ;
pf_qed_3_addr = '0 ;
pf_qed_3_we = '0 ;
pf_qed_3_wdata = '0 ;
pf_qed_2_re = '0 ;
pf_qed_2_addr = '0 ;
pf_qed_2_we = '0 ;
pf_qed_2_wdata = '0 ;
pf_qed_4_re = '0 ;
pf_qed_4_addr = '0 ;
pf_qed_4_we = '0 ;
pf_qed_4_wdata = '0 ;
pf_qed_1_re = '0 ;
pf_qed_1_addr = '0 ;
pf_qed_1_we = '0 ;
pf_qed_1_wdata = '0 ;
pf_qed_5_re = '0 ;
pf_qed_5_addr = '0 ;
pf_qed_5_we = '0 ;
pf_qed_5_wdata = '0 ;
pf_rx_sync_rop_qed_dqed_enq_re = '0 ;
pf_rx_sync_rop_qed_dqed_enq_raddr = '0 ;
pf_rx_sync_rop_qed_dqed_enq_waddr = '0 ;
pf_rx_sync_rop_qed_dqed_enq_we = '0 ;
pf_rx_sync_rop_qed_dqed_enq_wdata = '0 ;
pf_qed_chp_sch_data_re = '0 ;
pf_qed_chp_sch_data_raddr = '0 ;
pf_qed_chp_sch_data_waddr = '0 ;
pf_qed_chp_sch_data_we = '0 ;
pf_qed_chp_sch_data_wdata = '0 ;
pf_rx_sync_dp_dqed_data_re = '0 ;
pf_rx_sync_dp_dqed_data_raddr = '0 ;
pf_rx_sync_dp_dqed_data_waddr = '0 ;
pf_rx_sync_dp_dqed_data_we = '0 ;
pf_rx_sync_dp_dqed_data_wdata = '0 ;
pf_rx_sync_nalb_qed_data_re = '0 ;
pf_rx_sync_nalb_qed_data_raddr = '0 ;
pf_rx_sync_nalb_qed_data_waddr = '0 ;
pf_rx_sync_nalb_qed_data_we = '0 ;
pf_rx_sync_nalb_qed_data_wdata = '0 ;
  reset_pf_counter_nxt = reset_pf_counter_f ;
  reset_pf_active_nxt = reset_pf_active_f ;
  reset_pf_done_nxt = reset_pf_done_f ;
  hw_init_done_nxt = hw_init_done_f ;
  if ( hqm_gated_rst_n_start & reset_pf_active_f & ~ hw_init_done_f ) begin
    reset_pf_counter_nxt                          = reset_pf_counter_f + 32'b1 ;

    if ( reset_pf_counter_f < HQM_QED_CFG_RST_PFMAX ) begin
      pf_qed_0_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_0_addr = reset_pf_counter_f[10:0] ;
      pf_qed_0_wdata = '0 ;

      pf_qed_1_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_1_addr = reset_pf_counter_f[10:0] ;
      pf_qed_1_wdata = '0 ;

      pf_qed_2_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_2_addr = reset_pf_counter_f[10:0] ;
      pf_qed_2_wdata = '0 ;

      pf_qed_3_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_3_addr = reset_pf_counter_f[10:0] ;
      pf_qed_3_wdata = '0 ;

      pf_qed_4_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_4_addr = reset_pf_counter_f[10:0] ;
      pf_qed_4_wdata = '0 ;

      pf_qed_5_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_5_addr = reset_pf_counter_f[10:0] ;
      pf_qed_5_wdata = '0 ;

      pf_qed_6_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_6_addr = reset_pf_counter_f[10:0] ;
      pf_qed_6_wdata = '0 ;

      pf_qed_7_we = ( reset_pf_counter_f < 32'd2048 ) ;
      pf_qed_7_addr = reset_pf_counter_f[10:0] ;
      pf_qed_7_wdata = '0 ;
    end
    else begin
      reset_pf_counter_nxt                        = reset_pf_counter_f ;
      hw_init_done_nxt                            = 1'b1 ;
    end
  end
  // reset_active is set on reset.
  // reset_active is cleared when hw_init_done_f is set
  if ( reset_pf_active_f ) begin
      if ( hw_init_done_f ) begin
        reset_pf_counter_nxt = 32'd0 ;
        reset_pf_active_nxt = 1'b0 ;
        reset_pf_done_nxt = 1'b1 ;
        hw_init_done_nxt = 1'b0 ;
      end
  end

  //....................................................................................................
  // SMON
  //NOTE: smon_v 0-15 are functional, performance & stall
  //NOTE: smon_v 16+ are FPGA ONLY
  smon_v_nxt = '0 ;
  smon_comp_nxt = smon_comp_f ;
  smon_val_nxt = smon_val_f ;
  if ( hqm_qed_target_cfg_smon_smon_enabled ) begin
  smon_v_nxt [ 0 * 1 +: 1 ]                                  = rx_sync_rop_qed_dqed_enq_ready & rx_sync_rop_qed_dqed_enq_valid ;
  smon_comp_nxt [ 0 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 0 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 1 * 1 +: 1 ]                                  = rx_sync_nalb_qed_ready & rx_sync_nalb_qed_valid ;
  smon_comp_nxt [ 1 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 1 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 2 * 1 +: 1 ]                                  = rx_sync_dp_dqed_ready & rx_sync_dp_dqed_valid ;
  smon_comp_nxt [ 2 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 2 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 3 * 1 +: 1 ]                                  = qed_chp_sch_ready & qed_chp_sch_v ;
  smon_comp_nxt [ 3 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 3 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 4 * 1 +: 1 ]                                  = qed_aqed_enq_ready & qed_aqed_enq_v ;
  smon_comp_nxt [ 4 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 4 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 5 * 1 +: 1 ]                                  = 1'b0 ;
  smon_comp_nxt [ 5 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 5 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 6 * 1 +: 1 ]                                  = hqm_qed_pipe_rw_debug [ 16 ]  ;
  smon_comp_nxt [ 6 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 6 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 7 * 1 +: 1 ]                                  = 1'b0 ;
  smon_comp_nxt [ 7 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 7 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 8 * 1 +: 1 ]                                  = 1'b0 ;
  smon_comp_nxt [ 8 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 8 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 9 * 1 +: 1 ]                                  = counter_inc_1rdy_1sel ;
  smon_comp_nxt [ 9 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val_nxt [ 9 * 32 +: 32 ]                              = 32'd1 ;

  smon_v_nxt [ 10 * 1 +: 1 ]                                 = ~ rx_sync_rop_qed_dqed_enq_ready & rx_sync_rop_qed_dqed_enq_valid ;
  smon_comp_nxt [ 10 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val_nxt [ 10 * 32 +: 32 ]                             = 32'd1 ;

  smon_v_nxt [ 11 * 1 +: 1 ]                                 = ~ rx_sync_nalb_qed_ready & rx_sync_nalb_qed_valid ;
  smon_comp_nxt [ 11 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val_nxt [ 11 * 32 +: 32 ]                             = 32'd1 ;

  smon_v_nxt [ 12 * 1 +: 1 ]                                 = ~ rx_sync_dp_dqed_ready & rx_sync_dp_dqed_valid ;
  smon_comp_nxt [ 12 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val_nxt [ 12 * 32 +: 32 ]                             = 32'd1 ;

  smon_v_nxt [ 13 * 1 +: 1 ]                                 = ~ qed_chp_sch_ready & qed_chp_sch_v ;
  smon_comp_nxt [ 13 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val_nxt [ 13 * 32 +: 32 ]                             = 32'd1 ;

  smon_v_nxt [ 14 * 1 +: 1 ]                                 = ~ qed_aqed_enq_ready & qed_aqed_enq_v ;
  smon_comp_nxt [ 14 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val_nxt [ 14 * 32 +: 32 ]                             = 32'd1 ;

  smon_v_nxt [ 15 * 1 +: 1 ]                                 = 1'b0 ;
  smon_comp_nxt [ 15 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val_nxt [ 15 * 32 +: 32 ]                             = 32'd1 ;
  end

end


//tieoff machine inserted code
logic tieoff_nc ;
assign tieoff_nc =
//reuse modules inserted by script cannot include _nc
  ( | hqm_qed_target_cfg_smon_smon_interrupt )
| ( | hqm_qed_target_cfg_syndrome_00_syndrome_data )
| ( | hqm_qed_target_cfg_interface_status_reg_f )
| ( | pf_qed_6_rdata )
| ( | pf_qed_0_rdata )
| ( | pf_qed_7_rdata )
| ( | pf_qed_3_rdata )
| ( | pf_qed_2_rdata )
| ( | pf_qed_4_rdata )
| ( | pf_qed_1_rdata )
| ( | pf_qed_5_rdata )
| ( | pf_rx_sync_rop_qed_dqed_enq_rdata )
| ( | pf_rx_sync_dp_dqed_data_rdata )
| ( | pf_qed_chp_sch_data_rdata )
| ( | pf_rx_sync_nalb_qed_data_rdata )
| ( | cfg_req_write )
| ( | cfg_req_read )
//debug
| ( | hqm_qed_target_cfg_2rdy1iss_count )
| ( | hqm_qed_target_cfg_2rdy2iss_count )
| ( | hqm_qed_target_cfg_3rdy1iss_count )
| ( | hqm_qed_target_cfg_3rdy2iss_count )
;

//-----------------------------------------------------------------------------------------------------
// Spares

hqm_AW_spare_ports i_spare_ports_lsp (

     .clk                       (hqm_inp_gated_clk)
    ,.rst_n                     (hqm_inp_gated_rst_b_qed)
    ,.spare_in                  (spare_lsp_qed)
    ,.spare_out                 (spare_qed_lsp)
);

hqm_AW_spare_ports i_spare_ports_sys (

     .clk                       (hqm_inp_gated_clk)
    ,.rst_n                     (hqm_inp_gated_rst_b_qed)
    ,.spare_in                  (spare_sys_qed)
    ,.spare_out                 (spare_qed_sys)
);

endmodule // hqm_qed_pipe_core
