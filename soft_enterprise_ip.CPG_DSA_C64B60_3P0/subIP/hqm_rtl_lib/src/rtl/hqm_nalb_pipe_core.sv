//------------------------------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------------------------------
// hqm_nalb_pipe
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_nalb_pipe_core
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
    input logic hqm_gated_clk
  , input logic hqm_gated_rst_b
  , input logic hqm_inp_gated_clk
  , input logic hqm_inp_gated_rst_b
  , input logic hqm_rst_prep
  , output logic hqm_proc_clk_en

  , input  logic hqm_gated_rst_n_start
  , input  logic hqm_gated_rst_n_active
  , output logic hqm_gated_rst_n_done

  , output logic nalb_qed_force_clockon

  , output logic                        nalb_unit_idle
  , output logic                        nalb_unit_pipeidle
  , output logic                        nalb_reset_done

  // CFG interface
  , input  logic                        nalb_cfg_req_up_read
  , input  logic                        nalb_cfg_req_up_write
  , input  cfg_req_t                    nalb_cfg_req_up
  , input  logic                        nalb_cfg_rsp_up_ack
  , input  cfg_rsp_t                    nalb_cfg_rsp_up
  , output logic                        nalb_cfg_req_down_read
  , output logic                        nalb_cfg_req_down_write
  , output cfg_req_t                    nalb_cfg_req_down
  , output logic                        nalb_cfg_rsp_down_ack
  , output cfg_rsp_t                    nalb_cfg_rsp_down

  // interrupt interface
  , input  logic                        nalb_alarm_up_v
  , output logic                        nalb_alarm_up_ready
  , input  aw_alarm_t                   nalb_alarm_up_data

  , output logic                        nalb_alarm_down_v
  , input  logic                        nalb_alarm_down_ready
  , output aw_alarm_t                   nalb_alarm_down_data

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

  // nalb_qed interface
  , output logic                        nalb_qed_v
  , input  logic                        nalb_qed_ready
  , output nalb_qed_t                   nalb_qed_data


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
) ;
localparam HQM_NALB_CFG_INT_DIS = 0 ;
localparam HQM_NALB_CFG_INT_DIS_MBE = 2 ;
localparam HQM_NALB_CFG_INT_DIS_SBE = 1 ;
localparam HQM_NALB_CFG_INT_DIS_SYND = 31 ;
localparam HQM_NALB_CFG_VASR_DIS = 30 ;
localparam HQM_NALB_CHICKEN_33 = 2 ;
localparam HQM_NALB_CHICKEN_50 = 1 ;
localparam HQM_NALB_CHICKEN_REORDER_QID = 3 ;
localparam HQM_NALB_CHICKEN_REORDER_QIDIX = 4 ;
localparam HQM_NALB_CHICKEN_SIM = 0 ;
localparam HQM_NALB_CHICKEN_V1MODE = 31 ;
localparam HQM_NALB_CMD_DEQ = 2'd2 ;
localparam HQM_NALB_CMD_ENQ = 2'd1 ;
localparam HQM_NALB_CMD_ENQ_RORPLY = 2'd3 ;
localparam HQM_NALB_CMD_NOOP = 2'd0 ;
localparam HQM_NALB_QED_DEPTH = NUM_CREDITS ;
localparam HQM_NALB_QED_DEPTHB2 = AW_logb2 ( HQM_NALB_QED_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_CNTB2 = ( NUM_CREDITS == 16384 ) ? HQM_NALB_QED_DEPTHB2 + 1 : HQM_NALB_QED_DEPTHB2 + 2 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_DEPTH = 4 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_WIDTH = 8 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_DEPTH = 4 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_WIDTH = 27 ;
localparam HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_ATQ_DEPTH = 32 ;
localparam HQM_NALB_FIFO_NALB_ATQ_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_NALB_ATQ_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_ATQ_WIDTH = 8 ;
localparam HQM_NALB_FIFO_NALB_ATQ_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_NALB_ATQ_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_DEPTH = 32 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_WIDTH = 27 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_DEPTH = 32 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_WIDTH = 10 ;
localparam HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_QED_DEPTH = 32 ;
localparam HQM_NALB_FIFO_NALB_QED_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_NALB_QED_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_NALB_QED_WIDTH = 45 ;
localparam HQM_NALB_FIFO_NALB_QED_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_NALB_QED_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RORPLY_DEPTH = 4 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RORPLY_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_ROP_NALB_ENQ_RORPLY_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RORPLY_WIDTH = 81 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RORPLY_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_ROP_NALB_ENQ_RORPLY_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RO_DEPTH = 4 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RO_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_ROP_NALB_ENQ_RO_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RO_WIDTH = 81 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_RO_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_ROP_NALB_ENQ_RO_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_DEPTH = 4 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_DEPTHB2 = AW_logb2 ( HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_WIDTH = 81 ;
localparam HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_WMWIDTH = AW_logb2 ( HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_DEPTH + 1 ) + 1 ;
localparam HQM_NALB_FLIDB2 = HQM_NALB_QED_DEPTHB2 ;
localparam HQM_NALB_NXTHP_ATQ = 2'd2 ;
localparam HQM_NALB_NXTHP_ORDERED = 2'd1 ;
localparam HQM_NALB_NXTHP_UNOORD = 2'd0 ;

localparam HQM_NALB_NUM_LB_QID = 128 ; //TOP HQM_NUM_LB_QID
localparam HQM_NALB_NUM_PRI = 8 ;  //TOP HQM_NUM_PRI

localparam HQM_NALB_RAM_ATQ_CNT_DEPTH = HQM_NALB_NUM_LB_QID ;
localparam HQM_NALB_RAM_ATQ_CNT_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_ATQ_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_ATQ_CNT_WIDTH = HQM_NALB_NUM_PRI * ( 15 + 2 ) ;
localparam HQM_NALB_RAM_ATQ_HP_DEPTH = HQM_NALB_NUM_LB_QID * HQM_NALB_NUM_PRI ;
localparam HQM_NALB_RAM_ATQ_HP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_ATQ_HP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_ATQ_HP_WIDTH = ( HQM_NALB_QED_DEPTHB2 + 1 ) ;
localparam HQM_NALB_RAM_ATQ_TP_DEPTH = HQM_NALB_NUM_LB_QID * HQM_NALB_NUM_PRI ;
localparam HQM_NALB_RAM_ATQ_TP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_ATQ_TP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_ATQ_TP_WIDTH = ( HQM_NALB_QED_DEPTHB2 + 1 ) ;
localparam HQM_NALB_RAM_REPLAY_CNT_DEPTH = 128 ; //HQM_NALB_NUM_LB_QID ;
localparam HQM_NALB_RAM_REPLAY_CNT_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_REPLAY_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_REPLAY_CNT_WIDTH = 8 * ( 15 + 2 ) ;
localparam HQM_NALB_RAM_REPLAY_HP_DEPTH = 1024 ;
localparam HQM_NALB_RAM_REPLAY_HP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_REPLAY_HP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_REPLAY_HP_WIDTH = HQM_NALB_QED_DEPTHB2 + 1 ;
localparam HQM_NALB_RAM_REPLAY_TP_DEPTH = 1024 ;
localparam HQM_NALB_RAM_REPLAY_TP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_REPLAY_TP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_REPLAY_TP_WIDTH = HQM_NALB_QED_DEPTHB2 + 1 ;
localparam HQM_NALB_RAM_ROFRAG_CNT_DEPTH = 512 ;
localparam HQM_NALB_RAM_ROFRAG_CNT_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_ROFRAG_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_ROFRAG_CNT_WIDTH = 15 + 2 ;
localparam HQM_NALB_RAM_ROFRAG_HP_DEPTH = 512 ;
localparam HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_ROFRAG_HP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_ROFRAG_HP_WIDTH = HQM_NALB_QED_DEPTHB2 + 1 ;
localparam HQM_NALB_RAM_ROFRAG_TP_DEPTH = 512 ;
localparam HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_ROFRAG_TP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_ROFRAG_TP_WIDTH = HQM_NALB_QED_DEPTHB2 + 1 ;
localparam HQM_NALB_RAM_UNOORD_CNT_DEPTH = HQM_NALB_NUM_LB_QID ;
localparam HQM_NALB_RAM_UNOORD_CNT_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_UNOORD_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_UNOORD_CNT_WIDTH = HQM_NALB_NUM_PRI * ( 15 + 2 ) ;
localparam HQM_NALB_RAM_UNOORD_HP_DEPTH = HQM_NALB_NUM_LB_QID * HQM_NALB_NUM_PRI ;
localparam HQM_NALB_RAM_UNOORD_HP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_UNOORD_HP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_UNOORD_HP_WIDTH = ( HQM_NALB_QED_DEPTHB2 + 1 ) ;
localparam HQM_NALB_RAM_UNOORD_NXTHP_DEPTH = HQM_NALB_QED_DEPTH ;
localparam HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_UNOORD_NXTHP_WIDTH = ( HQM_NALB_QED_DEPTHB2 + 1 + 6 ) ;
localparam HQM_NALB_RAM_UNOORD_TP_DEPTH = HQM_NALB_NUM_LB_QID * HQM_NALB_NUM_PRI ;
localparam HQM_NALB_RAM_UNOORD_TP_DEPTHB2 = AW_logb2 ( HQM_NALB_RAM_UNOORD_TP_DEPTH - 1 ) + 1 ;
localparam HQM_NALB_RAM_UNOORD_TP_WIDTH = ( HQM_NALB_QED_DEPTHB2 + 1 ) ;
localparam HQM_NALB_RO_ENQ_FRAG = 2'd0 ;
localparam HQM_NALB_RO_ENQ_RORPLY = 2'd1 ;
localparam HQM_NALB_RO_SCH_RORPLY = 2'd2 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_0 = 20'd1 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_1 = 20'd2 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_2 = 20'd3 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_3 = 20'd4 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_4 = 20'd5 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_5 = 20'd6 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_6 = 20'd7 ;
localparam HQM_NALB_VF_RESET_CMD_CQ_WRITE_CNT_7 = 20'd8 ;
localparam HQM_NALB_VF_RESET_CMD_DONE = 20'd13 ;
localparam HQM_NALB_VF_RESET_CMD_INVALID = 20'd14 ;
localparam HQM_NALB_VF_RESET_CMD_QID_READ_CNT_0 = 20'd9 ;
localparam HQM_NALB_VF_RESET_CMD_QID_READ_CNT_X = 20'd11 ;
localparam HQM_NALB_VF_RESET_CMD_QID_WRITE_CNT_X = 20'd12 ;
localparam HQM_NALB_VF_RESET_CMD_START = 20'd0 ;
localparam HQM_NALB_CFG_RST_PFMAX = HQM_NALB_QED_DEPTH ;

typedef struct packed {  logic [ ( 2 ) - 1 : 0 ] cmd ;  logic [ ( 8 ) - 1 : 0 ] cq ;  logic [ ( 7 ) - 1 : 0 ] qid ;  hqm_pkg::qtype_t qtype ;  logic [ ( 3 ) - 1 : 0 ] qidix ;  logic  parity ;  logic [ ( 3 ) - 1 : 0 ] qpri ;  logic  empty ;  logic [ ( 14 ) - 1 : 0 ] hp ;  logic [ ( 14 ) - 1 : 0 ] tp ;  logic [ ( 14 ) - 1 : 0 ] flid ;  logic  flid_parity ;  logic  hp_parity ;  logic  tp_parity ;  logic [ ( 15 ) - 1 : 0 ] frag_cnt ;  logic [ ( 2 ) - 1 : 0 ] frag_residue ;  logic  error ;  hqm_core_flags_t hqm_core_flags ;} hqm_nalb_nalb_data_t ;
typedef struct packed {logic  hold ;logic  bypsel ;logic  enable ;} hqm_nalb_nalb_ctrl_t ;
aw_rmwpipe_cmd_t rmw_atq_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_atq_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_hp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_atq_hp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_hp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_hp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_tp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_tp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_atq_tp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_tp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_atq_tp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_nalb_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_hp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_nalb_hp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_hp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_hp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_tp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_tp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_nalb_tp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_tp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_nalb_tp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_replay_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_hp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_replay_hp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_hp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_hp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_tp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_tp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_replay_tp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_tp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_replay_tp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_rofrag_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_hp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_rofrag_hp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_hp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_hp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_tp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_tp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_rofrag_tp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_tp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_rofrag_tp_p3_rw_f_nc ;
aw_rwpipe_cmd_t rw_nxthp_p0_byp_rw_nxt ;
aw_rwpipe_cmd_t rw_nxthp_p0_rw_f_nc ;
aw_rwpipe_cmd_t rw_nxthp_p0_rw_nxt ;
aw_rwpipe_cmd_t rw_nxthp_p1_rw_f_nc ;
aw_rwpipe_cmd_t rw_nxthp_p2_rw_f_nc ;
aw_rwpipe_cmd_t rw_nxthp_p3_rw_f_nc ;
idle_status_t cfg_unit_idle_f , cfg_unit_idle_nxt ;
logic                  disable_smon ;
assign disable_smon = 1'b0 ;
logic [ ( HQM_NALB_ALARM_NUM_COR ) - 1 : 0 ] int_cor_v ;
logic [ ( HQM_NALB_ALARM_NUM_INF ) - 1 : 0 ] int_inf_v ;
logic [ ( HQM_NALB_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_v ;
aw_alarm_syn_t [ ( HQM_NALB_ALARM_NUM_COR ) - 1 : 0 ] int_cor_data ;
aw_alarm_syn_t [ ( HQM_NALB_ALARM_NUM_INF ) - 1 : 0 ] int_inf_data ;
aw_alarm_syn_t [ ( HQM_NALB_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_data ;
logic cfg_rx_idle ;
logic cfg_rx_enable ;
logic cfg_idle ;
logic int_idle ;
logic  arb_atq_cnt_winner_v ;
logic  arb_atq_update ;
logic  arb_atq_winner ;
logic  arb_atq_winner_v ;
logic  arb_nalb_cnt_winner_v ;
logic  arb_nalb_update ;
logic  arb_nalb_winner ;
logic  arb_nalb_winner_v ;
logic  arb_nxthp_update ;
logic  arb_nxthp_winner_v ;
logic  arb_replay_cnt_winner_v ;
logic  arb_ro_update ;
logic  arb_ro_winner_v ;
logic  error_atq_nopri ;
logic  error_atq_of ;
logic  error_badcmd0 ;
logic  error_nalb_nopri ;
logic  error_nalb_of ;
logic  error_replay_headroom ;
logic  error_replay_nopri ;
logic  error_replay_of ;
logic  error_rofrag_headroom ;
logic  error_rofrag_of ;
logic  fifo_lsp_nalb_sch_atq_afull ;
logic  fifo_lsp_nalb_sch_atq_empty ;
logic  fifo_lsp_nalb_sch_atq_error_of ;
logic  fifo_lsp_nalb_sch_atq_error_uf ;
logic  fifo_lsp_nalb_sch_atq_full_nc ;
logic  fifo_lsp_nalb_sch_atq_pop ;
logic  fifo_lsp_nalb_sch_atq_push ;
logic  fifo_lsp_nalb_sch_rorply_afull ;
logic  fifo_lsp_nalb_sch_rorply_empty ;
logic  fifo_lsp_nalb_sch_rorply_error_of ;
logic  fifo_lsp_nalb_sch_rorply_error_uf ;
logic  fifo_lsp_nalb_sch_rorply_full_nc ;
logic  fifo_lsp_nalb_sch_rorply_pop ;
logic  fifo_lsp_nalb_sch_rorply_push ;
logic  fifo_lsp_nalb_sch_unoord_afull ;
logic  fifo_lsp_nalb_sch_unoord_empty ;
logic  fifo_lsp_nalb_sch_unoord_error_of ;
logic  fifo_lsp_nalb_sch_unoord_error_uf ;
logic  fifo_lsp_nalb_sch_unoord_full_nc ;
logic  fifo_lsp_nalb_sch_unoord_pop ;
logic  fifo_lsp_nalb_sch_unoord_push ;
logic  fifo_nalb_lsp_enq_lb_afull ;
logic  fifo_nalb_lsp_enq_lb_empty ;
logic  fifo_nalb_lsp_enq_lb_error_of ;
logic  fifo_nalb_lsp_enq_lb_error_uf ;
logic  fifo_nalb_lsp_enq_lb_full_nc ;
logic  fifo_nalb_lsp_enq_lb_pop ;
logic  fifo_nalb_lsp_enq_lb_push ;
logic  fifo_nalb_lsp_enq_rorply_afull ;
logic  fifo_nalb_lsp_enq_rorply_empty ;
logic  fifo_nalb_lsp_enq_rorply_error_of ;
logic  fifo_nalb_lsp_enq_rorply_error_uf ;
logic  fifo_nalb_lsp_enq_rorply_full_nc ;
logic  fifo_nalb_lsp_enq_rorply_pop ;
logic  fifo_nalb_lsp_enq_rorply_push ;
logic  fifo_nalb_qed_afull ;
logic  fifo_nalb_qed_empty ;
logic  fifo_nalb_qed_error_of ;
logic  fifo_nalb_qed_error_uf ;
logic  fifo_nalb_qed_full_nc ;
logic  fifo_nalb_qed_pop ;
logic  fifo_nalb_qed_push ;
logic  fifo_rop_nalb_enq_nalb_afull ;
logic  fifo_rop_nalb_enq_nalb_empty ;
logic  fifo_rop_nalb_enq_nalb_error_of ;
logic  fifo_rop_nalb_enq_nalb_error_uf ;
logic  fifo_rop_nalb_enq_nalb_full_nc ;
logic  fifo_rop_nalb_enq_nalb_pop ;
logic  fifo_rop_nalb_enq_nalb_push ;
logic  fifo_rop_nalb_enq_ro_afull ;
logic  fifo_rop_nalb_enq_ro_empty ;
logic  fifo_rop_nalb_enq_ro_error_of ;
logic  fifo_rop_nalb_enq_ro_error_uf ;
logic  fifo_rop_nalb_enq_ro_full_nc ;
logic  fifo_rop_nalb_enq_ro_pop ;
logic  fifo_rop_nalb_enq_ro_push ;
logic  p0_atq_v_f , p0_atq_v_nxt , p1_atq_v_f , p1_atq_v_nxt , p2_atq_v_f , p2_atq_v_nxt , p3_atq_v_f , p3_atq_v_nxt , p4_atq_v_f , p4_atq_v_nxt , p5_atq_v_f , p5_atq_v_nxt , p6_atq_v_f , p6_atq_v_nxt , p7_atq_v_f , p7_atq_v_nxt , p8_atq_v_f , p8_atq_v_nxt , p9_atq_v_f_nc , p9_atq_v_nxt ;
logic  p0_nalb_v_f , p0_nalb_v_nxt , p1_nalb_v_f , p1_nalb_v_nxt , p2_nalb_v_f , p2_nalb_v_nxt , p3_nalb_v_f , p3_nalb_v_nxt , p4_nalb_v_f , p4_nalb_v_nxt , p5_nalb_v_f , p5_nalb_v_nxt , p6_nalb_v_f , p6_nalb_v_nxt , p7_nalb_v_f , p7_nalb_v_nxt , p8_nalb_v_f , p8_nalb_v_nxt , p9_nalb_v_f_nc , p9_nalb_v_nxt ;
logic  p0_replay_v_f , p0_replay_v_nxt , p1_replay_v_f , p1_replay_v_nxt , p2_replay_v_f , p2_replay_v_nxt , p3_replay_v_f , p3_replay_v_nxt , p4_replay_v_f , p4_replay_v_nxt , p5_replay_v_f , p5_replay_v_nxt , p6_replay_v_f , p6_replay_v_nxt , p7_replay_v_f , p7_replay_v_nxt , p8_replay_v_f , p8_replay_v_nxt , p9_replay_v_f_nc , p9_replay_v_nxt ;
logic  p0_rofrag_v_f , p0_rofrag_v_nxt , p1_rofrag_v_f , p1_rofrag_v_nxt , p2_rofrag_v_f , p2_rofrag_v_nxt , p3_rofrag_v_f , p3_rofrag_v_nxt , p4_rofrag_v_f , p4_rofrag_v_nxt , p5_rofrag_v_f , p5_rofrag_v_nxt , p6_rofrag_v_f , p6_rofrag_v_nxt , p7_rofrag_v_f , p7_rofrag_v_nxt , p8_rofrag_v_f , p8_rofrag_v_nxt , p9_rofrag_v_f_nc , p9_rofrag_v_nxt ;
logic  parity_check_rmw_atq_hp_p2_e ;
logic  parity_check_rmw_atq_hp_p2_error ;
logic  parity_check_rmw_atq_hp_p2_p ;
logic  parity_check_rmw_atq_tp_p2_e ;
logic  parity_check_rmw_atq_tp_p2_error ;
logic  parity_check_rmw_atq_tp_p2_p ;
logic  parity_check_rmw_nalb_hp_p2_e ;
logic  parity_check_rmw_nalb_hp_p2_error ;
logic  parity_check_rmw_nalb_hp_p2_p ;
logic  parity_check_rmw_nalb_tp_p2_e ;
logic  parity_check_rmw_nalb_tp_p2_error ;
logic  parity_check_rmw_nalb_tp_p2_p ;
logic  parity_check_rmw_replay_hp_p2_e ;
logic  parity_check_rmw_replay_hp_p2_error ;
logic  parity_check_rmw_replay_hp_p2_p ;
logic  parity_check_rmw_replay_tp_p2_e ;
logic  parity_check_rmw_replay_tp_p2_error ;
logic  parity_check_rmw_replay_tp_p2_p ;
logic  parity_check_rmw_rofrag_hp_p2_e ;
logic  parity_check_rmw_rofrag_hp_p2_error ;
logic  parity_check_rmw_rofrag_hp_p2_p ;
logic  parity_check_rmw_rofrag_tp_p2_e ;
logic  parity_check_rmw_rofrag_tp_p2_error ;
logic  parity_check_rmw_rofrag_tp_p2_p ;
logic  parity_check_rw_nxthp_p2_data_e ;
logic  parity_check_rw_nxthp_p2_data_error ;
logic  parity_check_rw_nxthp_p2_data_p ;
logic  parity_check_rx_sync_lsp_nalb_sch_atq_e ;
logic  parity_check_rx_sync_lsp_nalb_sch_atq_error ;
logic  parity_check_rx_sync_lsp_nalb_sch_atq_p ;
logic  parity_check_rx_sync_lsp_nalb_sch_rorply_e ;
logic  parity_check_rx_sync_lsp_nalb_sch_rorply_error ;
logic  parity_check_rx_sync_lsp_nalb_sch_rorply_p ;
logic  parity_check_rx_sync_lsp_nalb_sch_unoord_e ;
logic  parity_check_rx_sync_lsp_nalb_sch_unoord_error ;
logic  parity_check_rx_sync_lsp_nalb_sch_unoord_p ;
logic  parity_check_rx_sync_rop_nalb_enq_data_flid_e ;
logic  parity_check_rx_sync_rop_nalb_enq_data_flid_error ;
logic  parity_check_rx_sync_rop_nalb_enq_data_flid_p ;
logic  parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_e ;
logic  parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_error ;
logic  parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_p ;
logic  parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_e ;
logic  parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_error ;
logic  parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_p ;
logic  parity_check_rx_sync_rop_nalb_enq_data_hist_list_e ;
logic  parity_check_rx_sync_rop_nalb_enq_data_hist_list_error ;
logic  parity_check_rx_sync_rop_nalb_enq_data_hist_list_p ;
logic  parity_gen_atq_rop_nalb_enq_data_hist_list_p ;
logic  parity_gen_nalb_rop_nalb_enq_data_hist_list_p ;
logic  parity_gen_rofrag_rop_dp_enq_data_hist_list_p ;
logic  replay_stall_nxt ;
logic  residue_check_atq_cnt_e_f , residue_check_atq_cnt_e_nxt ;
logic  residue_check_atq_cnt_err ;
logic  residue_check_nalb_cnt_e_f , residue_check_nalb_cnt_e_nxt ;
logic  residue_check_nalb_cnt_err ;
logic  residue_check_replay_cnt_e_f , residue_check_replay_cnt_e_nxt ;
logic  residue_check_replay_cnt_err ;
logic  residue_check_rofrag_cnt_e_f , residue_check_rofrag_cnt_e_nxt ;
logic  residue_check_rofrag_cnt_err ;
logic  residue_check_rx_sync_rop_nalb_enq_e ;
logic  residue_check_rx_sync_rop_nalb_enq_err ;
logic  rmw_atq_cnt_p0_hold ;
logic  rmw_atq_cnt_p0_v_f ;
logic  rmw_atq_cnt_p0_v_nxt ;
logic  rmw_atq_cnt_p1_hold ;
logic  rmw_atq_cnt_p1_v_f ;
logic  rmw_atq_cnt_p2_hold ;
logic  rmw_atq_cnt_p2_v_f ;
logic  rmw_atq_cnt_p3_bypsel_nxt ;
logic  rmw_atq_cnt_p3_hold ;
logic  rmw_atq_cnt_p3_v_f ;
logic  rmw_atq_cnt_status ;
logic  rmw_atq_hp_p0_hold ;
logic  rmw_atq_hp_p0_v_f ;
logic  rmw_atq_hp_p0_v_nxt ;
logic  rmw_atq_hp_p1_hold ;
logic  rmw_atq_hp_p1_v_f ;
logic  rmw_atq_hp_p2_hold ;
logic  rmw_atq_hp_p2_v_f ;
logic  rmw_atq_hp_p3_bypsel_nxt ;
logic  rmw_atq_hp_p3_hold ;
logic  rmw_atq_hp_p3_v_f ;
logic  rmw_atq_hp_status ;
logic  rmw_atq_tp_p0_hold ;
logic  rmw_atq_tp_p0_v_f ;
logic  rmw_atq_tp_p0_v_nxt ;
logic  rmw_atq_tp_p1_hold ;
logic  rmw_atq_tp_p1_v_f ;
logic  rmw_atq_tp_p2_hold ;
logic  rmw_atq_tp_p2_v_f ;
logic  rmw_atq_tp_p3_bypsel_nxt ;
logic  rmw_atq_tp_p3_hold ;
logic  rmw_atq_tp_p3_v_f ;
logic  rmw_atq_tp_status ;
logic  rmw_nalb_cnt_p0_hold ;
logic  rmw_nalb_cnt_p0_v_f ;
logic  rmw_nalb_cnt_p0_v_nxt ;
logic  rmw_nalb_cnt_p1_hold ;
logic  rmw_nalb_cnt_p1_v_f ;
logic  rmw_nalb_cnt_p2_hold ;
logic  rmw_nalb_cnt_p2_v_f ;
logic  rmw_nalb_cnt_p3_bypsel_nxt ;
logic  rmw_nalb_cnt_p3_hold ;
logic  rmw_nalb_cnt_p3_v_f ;
logic  rmw_nalb_cnt_status ;
logic  rmw_nalb_hp_p0_hold ;
logic  rmw_nalb_hp_p0_v_f ;
logic  rmw_nalb_hp_p0_v_nxt ;
logic  rmw_nalb_hp_p1_hold ;
logic  rmw_nalb_hp_p1_v_f ;
logic  rmw_nalb_hp_p2_hold ;
logic  rmw_nalb_hp_p2_v_f ;
logic  rmw_nalb_hp_p3_bypsel_nxt ;
logic  rmw_nalb_hp_p3_hold ;
logic  rmw_nalb_hp_p3_v_f ;
logic  rmw_nalb_hp_status ;
logic  rmw_nalb_tp_p0_hold ;
logic  rmw_nalb_tp_p0_v_f ;
logic  rmw_nalb_tp_p0_v_nxt ;
logic  rmw_nalb_tp_p1_hold ;
logic  rmw_nalb_tp_p1_v_f ;
logic  rmw_nalb_tp_p2_hold ;
logic  rmw_nalb_tp_p2_v_f ;
logic  rmw_nalb_tp_p3_bypsel_nxt ;
logic  rmw_nalb_tp_p3_hold ;
logic  rmw_nalb_tp_p3_v_f ;
logic  rmw_nalb_tp_status ;
logic  rmw_replay_cnt_p0_hold ;
logic  rmw_replay_cnt_p0_v_f ;
logic  rmw_replay_cnt_p0_v_nxt ;
logic  rmw_replay_cnt_p1_hold ;
logic  rmw_replay_cnt_p1_v_f ;
logic  rmw_replay_cnt_p2_hold ;
logic  rmw_replay_cnt_p2_v_f ;
logic  rmw_replay_cnt_p3_bypsel_nxt ;
logic  rmw_replay_cnt_p3_hold ;
logic  rmw_replay_cnt_p3_v_f ;
logic  rmw_replay_cnt_status ;
logic  rmw_replay_hp_p0_hold ;
logic  rmw_replay_hp_p0_v_f ;
logic  rmw_replay_hp_p0_v_nxt ;
logic  rmw_replay_hp_p1_hold ;
logic  rmw_replay_hp_p1_v_f ;
logic  rmw_replay_hp_p2_hold ;
logic  rmw_replay_hp_p2_v_f ;
logic  rmw_replay_hp_p3_bypsel_nxt ;
logic  rmw_replay_hp_p3_hold ;
logic  rmw_replay_hp_p3_v_f ;
logic  rmw_replay_hp_status ;
logic  rmw_replay_tp_p0_hold ;
logic  rmw_replay_tp_p0_v_f ;
logic  rmw_replay_tp_p0_v_nxt ;
logic  rmw_replay_tp_p1_hold ;
logic  rmw_replay_tp_p1_v_f ;
logic  rmw_replay_tp_p2_hold ;
logic  rmw_replay_tp_p2_v_f ;
logic  rmw_replay_tp_p3_bypsel_nxt ;
logic  rmw_replay_tp_p3_hold ;
logic  rmw_replay_tp_p3_v_f ;
logic  rmw_replay_tp_status ;
logic  rmw_rofrag_cnt_p0_hold ;
logic  rmw_rofrag_cnt_p0_v_f ;
logic  rmw_rofrag_cnt_p0_v_nxt ;
logic  rmw_rofrag_cnt_p1_hold ;
logic  rmw_rofrag_cnt_p1_v_f ;
logic  rmw_rofrag_cnt_p2_hold ;
logic  rmw_rofrag_cnt_p2_v_f ;
logic  rmw_rofrag_cnt_p3_bypsel_nxt ;
logic  rmw_rofrag_cnt_p3_hold ;
logic  rmw_rofrag_cnt_p3_v_f ;
logic  rmw_rofrag_cnt_status ;
logic  rmw_rofrag_hp_p0_hold ;
logic  rmw_rofrag_hp_p0_v_f ;
logic  rmw_rofrag_hp_p0_v_nxt ;
logic  rmw_rofrag_hp_p1_hold ;
logic  rmw_rofrag_hp_p1_v_f ;
logic  rmw_rofrag_hp_p2_hold ;
logic  rmw_rofrag_hp_p2_v_f ;
logic  rmw_rofrag_hp_p3_bypsel_nxt ;
logic  rmw_rofrag_hp_p3_hold ;
logic  rmw_rofrag_hp_p3_v_f ;
logic  rmw_rofrag_hp_status ;
logic  rmw_rofrag_tp_p0_hold ;
logic  rmw_rofrag_tp_p0_v_f ;
logic  rmw_rofrag_tp_p0_v_nxt ;
logic  rmw_rofrag_tp_p1_hold ;
logic  rmw_rofrag_tp_p1_v_f ;
logic  rmw_rofrag_tp_p2_hold ;
logic  rmw_rofrag_tp_p2_v_f ;
logic  rmw_rofrag_tp_p3_bypsel_nxt ;
logic  rmw_rofrag_tp_p3_hold ;
logic  rmw_rofrag_tp_p3_v_f ;
logic  rmw_rofrag_tp_status ;
logic  rofrag_stall_nxt ;
logic  rw_nxthp_err_parity ;
logic  rw_nxthp_error_mb ;
logic  rw_nxthp_error_sb ;
logic  rw_nxthp_p0_byp_v_nxt ;
logic  rw_nxthp_p0_hold ;
logic  rw_nxthp_p0_v_f ;
logic  rw_nxthp_p0_v_nxt ;
logic  rw_nxthp_p1_hold ;
logic  rw_nxthp_p1_v_f ;
logic  rw_nxthp_p2_hold ;
logic  rw_nxthp_p2_v_f ;
logic  rw_nxthp_p3_hold ;
logic  rw_nxthp_p3_v_f ;
logic  rw_nxthp_status ;
logic  rx_sync_lsp_nalb_sch_atq_ready ;
logic  rx_sync_lsp_nalb_sch_atq_v ;
logic  rx_sync_lsp_nalb_sch_rorply_ready ;
logic  rx_sync_lsp_nalb_sch_rorply_v ;
logic  rx_sync_lsp_nalb_sch_unoord_ready ;
logic  rx_sync_lsp_nalb_sch_unoord_v ;
logic  rx_sync_rop_nalb_enq_ready ;
logic  rx_sync_rop_nalb_enq_v ;

logic  tx_sync_nalb_lsp_enq_lb_ready ;
logic  tx_sync_nalb_lsp_enq_lb_v ;
logic  tx_sync_nalb_lsp_enq_rorply_ready ;
logic  tx_sync_nalb_lsp_enq_rorply_v ;
logic  tx_sync_nalb_qed_ready ;
logic  tx_sync_nalb_qed_v ;
logic [ ( $bits ( nalb_alarm_up_data.unit ) - 1 ) : 0 ] int_uid ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control0_f , cfg_control0_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control10_f , cfg_control10_nxt ; //unused
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control11_f , cfg_control11_nxt ; //pipe credits
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control3_f , cfg_control3_nxt ; //ARB weight
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control4_f , cfg_control4_nxt ; //ARB weight
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control5_f , cfg_control5_nxt ; //ARB weight
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control6_f , cfg_control6_nxt ; //ARB weight
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control7_f , cfg_control7_nxt ; //ARB weight
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control8_f , cfg_control8_nxt ; //ARB weight
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control9_f , cfg_control9_nxt ; //unused
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_csr_control_f , cfg_csr_control_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_error_inj_f , cfg_error_inj_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_interface_f , cfg_interface_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_hold_00_f , cfg_pipe_health_hold_00_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_hold_01_f , cfg_pipe_health_hold_01_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_valid_00_f , cfg_pipe_health_valid_00_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_valid_01_f , cfg_pipe_health_valid_01_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status0 ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status1 ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status2 ;
logic [ ( 15 ) - 1 : 0 ] ecc_gen_d_nc ;
logic [ ( 15 ) - 1 : 0 ] parity_check_rx_sync_rop_nalb_enq_data_flid_d ;
logic [ ( 15 ) - 1 : 0 ] parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_d ;
logic [ ( 15 ) - 1 : 0 ] parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_d ;
logic [ ( 15 ) - 1 : 0 ] residue_check_rx_sync_rop_nalb_enq_d ;
logic [ ( 18 ) - 1 : 0 ] parity_check_rx_sync_lsp_nalb_sch_unoord_d ;
logic [ ( 2 ) - 1 : 0 ] arb_atq_reqs ;
logic [ ( 2 ) - 1 : 0 ] arb_nalb_reqs ;
logic [ ( 2 ) - 1 : 0 ] arb_nxthp_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ro_winner ;
logic [ ( 2 ) - 1 : 0 ] error_atq_headroom ;
logic [ ( 2 ) - 1 : 0 ] error_nalb_headroom ;
logic [ ( 2 ) - 1 : 0 ] residue_add_atq_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_atq_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_atq_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_nalb_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_nalb_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_nalb_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_replay_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_replay_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_replay_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rofrag_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rofrag_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rofrag_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_atq_cnt_r_f , residue_check_atq_cnt_r_nxt ;
logic [ ( 2 ) - 1 : 0 ] residue_check_nalb_cnt_r_f , residue_check_nalb_cnt_r_nxt ;
logic [ ( 2 ) - 1 : 0 ] residue_check_replay_cnt_r_f , residue_check_replay_cnt_r_nxt ;
logic [ ( 2 ) - 1 : 0 ] residue_check_rofrag_cnt_r_f , residue_check_rofrag_cnt_r_nxt ;
logic [ ( 2 ) - 1 : 0 ] residue_check_rx_sync_rop_nalb_enq_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_atq_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_atq_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_atq_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_nalb_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_nalb_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_nalb_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_replay_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_replay_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_replay_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rofrag_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rofrag_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rofrag_cnt_r ;
logic [ ( 24 * 1 ) - 1 : 0 ] smon_v ;
logic [ ( 24 * 32 ) - 1 : 0 ] smon_comp ;
logic [ ( 24 * 32 ) - 1 : 0 ] smon_val ;
logic [ ( 27 ) - 1 : 0 ] parity_gen_atq_rop_nalb_enq_data_hist_list_d ;
logic [ ( 27 ) - 1 : 0 ] parity_gen_nalb_rop_nalb_enq_data_hist_list_d ;
logic [ ( 29 ) - 1 : 0 ] parity_gen_rofrag_rop_dp_enq_data_hist_list_d ;
logic [ ( 3 ) - 1 : 0 ] arb_atq_cnt_winner ;
logic [ ( 3 ) - 1 : 0 ] arb_nalb_cnt_winner ;
logic [ ( 3 ) - 1 : 0 ] arb_nxthp_reqs ;
logic [ ( 3 ) - 1 : 0 ] arb_replay_cnt_winner ;
logic [ ( 3 ) - 1 : 0 ] arb_ro_reqs ;
logic [ ( 32 ) - 1 : 0 ]  reset_pf_counter_nxt , reset_pf_counter_f ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_control_nxt , cfg_agitate_control_f ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_select_nxt , cfg_agitate_select_f ;
logic [ ( 32 ) - 1 : 0 ] int_status_pnc ;
logic [ ( 35 ) - 1 : 0 ] parity_check_rx_sync_rop_nalb_enq_data_hist_list_d ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_lsp_enq_lb_atq_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_lsp_enq_lb_atq_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_lsp_enq_lb_nalb_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_lsp_enq_lb_nalb_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_lsp_enq_lb_rorply_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_lsp_enq_lb_rorply_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_qed_atq_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_qed_atq_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_qed_nalb_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_qed_nalb_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_qed_rorply_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_nalb_qed_rorply_cnt_nxt ;
logic [ ( 6 ) - 1 : 0 ] ecc_gen ;
logic [ ( 7 ) - 1 : 0 ] parity_check_rx_sync_lsp_nalb_sch_atq_d ;
logic [ ( 7 ) - 1 : 0 ] parity_check_rx_sync_lsp_nalb_sch_rorply_d ;
aw_fifo_status_t rx_sync_lsp_nalb_sch_atq_status_pnc ;
aw_fifo_status_t rx_sync_lsp_nalb_sch_rorply_status_pnc ;
aw_fifo_status_t rx_sync_lsp_nalb_sch_unoord_status_pnc ;
aw_fifo_status_t rx_sync_rop_nalb_enq_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_nalb_lsp_enq_lb_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_nalb_lsp_enq_rorply_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_nalb_qed_status_pnc ;
logic [ ( 8 ) - 1 : 0 ] arb_atq_cnt_reqs ;
logic [ ( 8 ) - 1 : 0 ] arb_nalb_cnt_reqs ;
logic [ ( 8 ) - 1 : 0 ] arb_replay_cnt_reqs ;


logic [ ( HQM_NALB_CNTB2 ) - 1 : 0 ] residue_check_atq_cnt_d_f , residue_check_atq_cnt_d_nxt ;
logic [ ( HQM_NALB_CNTB2 ) - 1 : 0 ] residue_check_nalb_cnt_d_f , residue_check_nalb_cnt_d_nxt ;
logic [ ( HQM_NALB_CNTB2 ) - 1 : 0 ] residue_check_replay_cnt_d_f , residue_check_replay_cnt_d_nxt ;
logic [ ( HQM_NALB_CNTB2 ) - 1 : 0 ] residue_check_rofrag_cnt_d_f , residue_check_rofrag_cnt_d_nxt ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_atq_hp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_atq_tp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_nalb_hp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_nalb_tp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_replay_hp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_replay_tp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_rofrag_hp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rmw_rofrag_tp_p2_d ;
logic [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] parity_check_rw_nxthp_p2_data_d ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_DEPTHB2 ) - 1 : 0 ] rmw_atq_cnt_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_DEPTHB2 ) - 1 : 0 ] rmw_atq_cnt_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_DEPTHB2 ) - 1 : 0 ] rmw_atq_cnt_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_DEPTHB2 ) - 1 : 0 ] rmw_atq_cnt_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_DEPTHB2 ) - 1 : 0 ] rmw_atq_cnt_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_WIDTH ) - 1 : 0 ] rmw_atq_cnt_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_WIDTH ) - 1 : 0 ] rmw_atq_cnt_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_WIDTH ) - 1 : 0 ] rmw_atq_cnt_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_WIDTH ) - 1 : 0 ] rmw_atq_cnt_p2_data_f ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_WIDTH ) - 1 : 0 ] rmw_atq_cnt_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_CNT_WIDTH ) - 1 : 0 ] rmw_atq_cnt_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_HP_DEPTHB2 ) - 1 : 0 ] rmw_atq_hp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_HP_DEPTHB2 ) - 1 : 0 ] rmw_atq_hp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_HP_DEPTHB2 ) - 1 : 0 ] rmw_atq_hp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_HP_DEPTHB2 ) - 1 : 0 ] rmw_atq_hp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_HP_DEPTHB2 ) - 1 : 0 ] rmw_atq_hp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_HP_DEPTHB2 ) - 1 : 0 ] rmw_atq_hp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_HP_WIDTH ) - 1 : 0 ] rmw_atq_hp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_HP_WIDTH ) - 1 : 0 ] rmw_atq_hp_p0_write_data_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_HP_WIDTH ) - 1 : 0 ] rmw_atq_hp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_HP_WIDTH ) - 1 : 0 ] rmw_atq_hp_p2_data_f ;
logic [ ( HQM_NALB_RAM_ATQ_HP_WIDTH ) - 1 : 0 ] rmw_atq_hp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_HP_WIDTH ) - 1 : 0 ] rmw_atq_hp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_TP_DEPTHB2 ) - 1 : 0 ] rmw_atq_tp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_TP_DEPTHB2 ) - 1 : 0 ] rmw_atq_tp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_TP_DEPTHB2 ) - 1 : 0 ] rmw_atq_tp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_TP_DEPTHB2 ) - 1 : 0 ] rmw_atq_tp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_TP_DEPTHB2 ) - 1 : 0 ] rmw_atq_tp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_TP_DEPTHB2 ) - 1 : 0 ] rmw_atq_tp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_TP_WIDTH ) - 1 : 0 ] rmw_atq_tp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_TP_WIDTH ) - 1 : 0 ] rmw_atq_tp_p0_write_data_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_TP_WIDTH ) - 1 : 0 ] rmw_atq_tp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_ATQ_TP_WIDTH ) - 1 : 0 ] rmw_atq_tp_p2_data_f ;
logic [ ( HQM_NALB_RAM_ATQ_TP_WIDTH ) - 1 : 0 ] rmw_atq_tp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_ATQ_TP_WIDTH ) - 1 : 0 ] rmw_atq_tp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p2_data_f ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p2_data_f ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p2_data_f ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p2_data_f ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p2_data_f ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p2_data_f ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_DEPTHB2 ) - 1 : 0 ] rmw_nalb_cnt_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_DEPTHB2 ) - 1 : 0 ] rmw_nalb_cnt_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_DEPTHB2 ) - 1 : 0 ] rmw_nalb_cnt_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_DEPTHB2 ) - 1 : 0 ] rmw_nalb_cnt_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_DEPTHB2 ) - 1 : 0 ] rmw_nalb_cnt_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_WIDTH ) - 1 : 0 ] rmw_nalb_cnt_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_WIDTH ) - 1 : 0 ] rmw_nalb_cnt_p0_write_data_nxt_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_WIDTH ) - 1 : 0 ] rmw_nalb_cnt_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_WIDTH ) - 1 : 0 ] rmw_nalb_cnt_p2_data_f ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_WIDTH ) - 1 : 0 ] rmw_nalb_cnt_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_CNT_WIDTH ) - 1 : 0 ] rmw_nalb_cnt_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_hp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_hp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_hp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_hp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_hp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_hp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_WIDTH ) - 1 : 0 ] rmw_nalb_hp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_WIDTH ) - 1 : 0 ] rmw_nalb_hp_p0_write_data_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_WIDTH ) - 1 : 0 ] rmw_nalb_hp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_WIDTH ) - 1 : 0 ] rmw_nalb_hp_p2_data_f ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_WIDTH ) - 1 : 0 ] rmw_nalb_hp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_HP_WIDTH ) - 1 : 0 ] rmw_nalb_hp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p0_byp_addr_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p0_byp_write_data_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p0_write_data_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p2_data_f ;
logic [ ( HQM_NALB_RAM_UNOORD_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p3_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_tp_p0_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_tp_p0_addr_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_tp_p1_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_tp_p2_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_tp_p3_addr_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_DEPTHB2 ) - 1 : 0 ] rmw_nalb_tp_p3_bypaddr_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_WIDTH ) - 1 : 0 ] rmw_nalb_tp_p0_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_WIDTH ) - 1 : 0 ] rmw_nalb_tp_p0_write_data_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_WIDTH ) - 1 : 0 ] rmw_nalb_tp_p1_data_f_nc ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_WIDTH ) - 1 : 0 ] rmw_nalb_tp_p2_data_f ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_WIDTH ) - 1 : 0 ] rmw_nalb_tp_p3_bypdata_nxt ;
logic [ ( HQM_NALB_RAM_UNOORD_TP_WIDTH ) - 1 : 0 ] rmw_nalb_tp_p3_data_f_nc ;
logic [ 4 : 0 ] atq_stall_nxt , atq_stall_f ;
logic [ 4 : 0 ] nalb_stall_nxt , nalb_stall_f ;
logic [ 7 : 0 ] ordered_stall_nxt , ordered_stall_f ;
logic [ HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_WMWIDTH - 1 : 0 ] fifo_lsp_nalb_sch_rorply_if_cfg_high_wm ;
logic [ HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_WMWIDTH - 1 : 0 ] fifo_lsp_nalb_sch_if_cfg_high_wm ;
logic [ HQM_NALB_FIFO_NALB_ATQ_WMWIDTH - 1 : 0 ] fifo_lsp_nalb_sch_atq_if_cfg_high_wm ;
logic [ HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_WMWIDTH - 1 : 0 ] fifo_nalb_lsp_enq_rorply_if_cfg_high_wm ;
logic [ HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_WMWIDTH - 1 : 0 ] fifo_nalb_lsp_enq_dir_if_cfg_high_wm ;
logic [ HQM_NALB_FIFO_NALB_QED_WMWIDTH - 1 : 0 ] fifo_nalb_qed_if_cfg_high_wm ;
logic [ HQM_NALB_FIFO_ROP_NALB_ENQ_RO_WMWIDTH - 1 : 0 ] fifo_rop_nalb_enq_ro_if_cfg_high_wm ;
logic [ HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_WMWIDTH - 1 : 0 ] fifo_rop_nalb_enq_uno_ord_if_cfg_high_wm ;
logic atq_stall_nc ;
aw_fifo_status_t fifo_lsp_nalb_sch_atq_if_status ;
aw_fifo_status_t fifo_lsp_nalb_sch_if_status ;
aw_fifo_status_t fifo_lsp_nalb_sch_rorply_if_status ;
aw_fifo_status_t fifo_nalb_lsp_enq_dir_if_status ;
aw_fifo_status_t fifo_nalb_lsp_enq_rorply_if_status ;
aw_fifo_status_t fifo_nalb_qed_if_status ;
aw_fifo_status_t fifo_rop_nalb_enq_ro_if_status ;
aw_fifo_status_t fifo_rop_nalb_enq_uno_ord_if_status ;
aw_fifo_status_t cfg_rx_fifo_status ;
logic fifo_nalb_lsp_enq_lb_atq_dec ;
logic fifo_nalb_lsp_enq_lb_atq_inc ;
logic fifo_nalb_lsp_enq_lb_nalb_dec ;
logic fifo_nalb_lsp_enq_lb_nalb_inc ;
logic fifo_nalb_lsp_enq_lb_rorply_dec ;
logic fifo_nalb_lsp_enq_lb_rorply_inc ;
logic fifo_nalb_qed_atq_dec ;
logic fifo_nalb_qed_atq_inc ;
logic fifo_nalb_qed_nalb_dec ;
logic fifo_nalb_qed_nalb_inc ;
logic fifo_nalb_qed_rorply_dec ;
logic fifo_nalb_qed_rorply_inc ;
logic hw_init_done_f , hw_init_done_nxt ;
logic nalb_stall_nc ;
logic ordered_stall_nc ;
logic replay_stall ;
logic reset_pf_active_f , reset_pf_active_nxt ;
logic reset_pf_done_f , reset_pf_done_nxt ;
logic rofrag_stall ;
logic stall ;
logic wire_sr_nalb_nxthp_we ;
hqm_nalb_nalb_data_t p0_nalb_data_f , p0_nalb_data_nxt , p1_nalb_data_f , p1_nalb_data_nxt , p2_nalb_data_f , p2_nalb_data_nxt , p3_nalb_data_f , p3_nalb_data_nxt , p4_nalb_data_f , p4_nalb_data_nxt , p5_nalb_data_f , p5_nalb_data_nxt , p6_nalb_data_f , p6_nalb_data_nxt , p7_nalb_data_f , p7_nalb_data_nxt , p8_nalb_data_f , p8_nalb_data_nxt , p9_nalb_data_f , p9_nalb_data_nxt ;
hqm_nalb_nalb_ctrl_t p0_nalb_ctrl , p1_nalb_ctrl , p2_nalb_ctrl , p3_nalb_ctrl , p4_nalb_ctrl , p5_nalb_ctrl , p6_nalb_ctrl , p7_nalb_ctrl , p8_nalb_ctrl , p9_nalb_ctrl ;
hqm_nalb_nalb_data_t p0_atq_data_f , p0_atq_data_nxt , p1_atq_data_f , p1_atq_data_nxt , p2_atq_data_f , p2_atq_data_nxt , p3_atq_data_f , p3_atq_data_nxt , p4_atq_data_f , p4_atq_data_nxt , p5_atq_data_f , p5_atq_data_nxt , p6_atq_data_f , p6_atq_data_nxt , p7_atq_data_f , p7_atq_data_nxt , p8_atq_data_f , p8_atq_data_nxt , p9_atq_data_f , p9_atq_data_nxt ;
hqm_nalb_nalb_ctrl_t p0_atq_ctrl , p1_atq_ctrl , p2_atq_ctrl , p3_atq_ctrl , p4_atq_ctrl , p5_atq_ctrl , p6_atq_ctrl , p7_atq_ctrl , p8_atq_ctrl , p9_atq_ctrl ;
hqm_nalb_nalb_data_t p0_rofrag_data_f , p0_rofrag_data_nxt , p1_rofrag_data_f , p1_rofrag_data_nxt , p2_rofrag_data_f , p2_rofrag_data_nxt , p3_rofrag_data_f , p3_rofrag_data_nxt , p4_rofrag_data_f , p4_rofrag_data_nxt , p5_rofrag_data_f , p5_rofrag_data_nxt , p6_rofrag_data_f , p6_rofrag_data_nxt , p7_rofrag_data_f , p7_rofrag_data_nxt , p8_rofrag_data_f , p8_rofrag_data_nxt , p9_rofrag_data_f , p9_rofrag_data_nxt ;
hqm_nalb_nalb_ctrl_t p0_rofrag_ctrl , p1_rofrag_ctrl , p2_rofrag_ctrl , p3_rofrag_ctrl , p4_rofrag_ctrl , p5_rofrag_ctrl , p6_rofrag_ctrl , p7_rofrag_ctrl , p8_rofrag_ctrl , p9_rofrag_ctrl ;
hqm_nalb_nalb_data_t p0_replay_data_f , p0_replay_data_nxt , p1_replay_data_f , p1_replay_data_nxt , p2_replay_data_f , p2_replay_data_nxt , p3_replay_data_f , p3_replay_data_nxt , p4_replay_data_f , p4_replay_data_nxt , p5_replay_data_f , p5_replay_data_nxt , p6_replay_data_f , p6_replay_data_nxt , p7_replay_data_f , p7_replay_data_nxt , p8_replay_data_f , p8_replay_data_nxt , p9_replay_data_f , p9_replay_data_nxt ;
hqm_nalb_nalb_ctrl_t p0_replay_ctrl , p1_replay_ctrl , p2_replay_ctrl , p3_replay_ctrl , p4_replay_ctrl , p5_replay_ctrl , p6_replay_ctrl , p7_replay_ctrl , p8_replay_ctrl , p9_replay_ctrl ;
rop_nalb_enq_t rx_sync_rop_nalb_enq_data ;
lsp_nalb_sch_unoord_t rx_sync_lsp_nalb_sch_unoord_data ;
lsp_nalb_sch_rorply_t rx_sync_lsp_nalb_sch_rorply_data ;
lsp_nalb_sch_atq_t rx_sync_lsp_nalb_sch_atq_data ;
nalb_lsp_enq_lb_t tx_sync_nalb_lsp_enq_lb_data ;
nalb_lsp_enq_rorply_t tx_sync_nalb_lsp_enq_rorply_data ;
nalb_qed_t tx_sync_nalb_qed_data ;
rop_nalb_enq_t fifo_rop_nalb_enq_nalb_push_data ;
rop_nalb_enq_t fifo_rop_nalb_enq_nalb_pop_data ;
rop_nalb_enq_t wire_fifo_rop_nalb_enq_nalb_pop_data ;
rop_nalb_enq_t fifo_rop_nalb_enq_ro_push_data ;
rop_nalb_enq_t fifo_rop_nalb_enq_ro_pop_data ;
rop_nalb_enq_t wire_fifo_rop_nalb_enq_ro_pop_data ;
logic fifo_rop_nalb_enq_nalb_pop_data_parity_error ;
logic fifo_rop_nalb_enq_ro_pop_data_parity_error ;
lsp_nalb_sch_unoord_t fifo_lsp_nalb_sch_unoord_push_data ;
lsp_nalb_sch_unoord_t fifo_lsp_nalb_sch_unoord_pop_data ;
lsp_nalb_sch_rorply_t fifo_lsp_nalb_sch_rorply_push_data ;
lsp_nalb_sch_rorply_t fifo_lsp_nalb_sch_rorply_pop_data ;
lsp_nalb_sch_atq_t fifo_lsp_nalb_sch_atq_push_data ;
lsp_nalb_sch_atq_t fifo_lsp_nalb_sch_atq_pop_data ;
nalb_qed_t fifo_nalb_qed_push_data ;
nalb_qed_t fifo_nalb_qed_pop_data ;
nalb_lsp_enq_lb_t fifo_nalb_lsp_enq_lb_push_data ;
nalb_lsp_enq_lb_t fifo_nalb_lsp_enq_lb_pop_data ;
nalb_lsp_enq_rorply_t fifo_nalb_lsp_enq_rorply_push_data ;
nalb_lsp_enq_rorply_t fifo_nalb_lsp_enq_rorply_pop_data ;

//------------------------------------------------------------------------------------------------------------------------------------------------
// Check for invalid paramter configation : This will produce a build error if a unsupported paramter value is used


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
assign rst_prep             = hqm_rst_prep;
assign hqm_gated_rst_n      = hqm_gated_rst_b;
assign hqm_inp_gated_rst_n  = hqm_inp_gated_rst_b;
assign hqm_gated_rst_n_done = reset_pf_done_f ;

//---------------------------------------------------------------------------------------------------------
// common core - CFG accessible patch & proc registers 
// common core - RFW/SRW RAM gasket
// common core - RAM wrapper for all single PORT SR RAMs
// common core - RAM wrapper for all 2 port RF RAMs
// The following must be kept in-sync with generated code
// BEGIN HQM_CFG_ACCESS
logic [ ( HQM_NALB_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write ; //I CFG
logic [ ( HQM_NALB_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read ; //I CFG
cfg_req_t pfcsr_cfg_req ; //I CFG
logic pfcsr_cfg_rsp_ack ; //O CFG
logic pfcsr_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata ; //O CFG
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_nxt ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_f ; //O HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0
logic hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_v ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_1_status ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_1
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_nxt ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_f ; //O HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0
logic hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_v ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_1_status ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_1
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_f ; //O HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0
logic hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_v ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_1_status ; //I HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_general_reg_nxt ; //I HQM_NALB_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_general_reg_f ; //O HQM_NALB_TARGET_CFG_CONTROL_GENERAL
logic hqm_nalb_target_cfg_control_general_reg_v ; //I HQM_NALB_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_pipeline_credits_reg_nxt ; //I HQM_NALB_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_control_pipeline_credits_reg_f ; //O HQM_NALB_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic hqm_nalb_target_cfg_control_pipeline_credits_reg_v ; //I HQM_NALB_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_detect_feature_operation_00_reg_nxt ; //I HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_detect_feature_operation_00_reg_f ; //O HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_detect_feature_operation_01_reg_nxt ; //I HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_detect_feature_operation_01_reg_f ; //O HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_diagnostic_aw_status_status ; //I HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_diagnostic_aw_status_01_status ; //I HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_diagnostic_aw_status_02_status ; //I HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_error_inject_reg_nxt ; //I HQM_NALB_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_error_inject_reg_f ; //O HQM_NALB_TARGET_CFG_ERROR_INJECT
logic hqm_nalb_target_cfg_error_inject_reg_v ; //I HQM_NALB_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_QED_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_QED_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_nxt ; //I HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_f ; //O HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_hw_agitate_control_reg_nxt ; //I HQM_NALB_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_hw_agitate_control_reg_f ; //O HQM_NALB_TARGET_CFG_HW_AGITATE_CONTROL
logic hqm_nalb_target_cfg_hw_agitate_control_reg_v ; //I HQM_NALB_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_hw_agitate_select_reg_nxt ; //I HQM_NALB_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_hw_agitate_select_reg_f ; //O HQM_NALB_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_nalb_target_cfg_hw_agitate_select_reg_v ; //I HQM_NALB_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_interface_status_reg_nxt ; //I HQM_NALB_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_interface_status_reg_f ; //O HQM_NALB_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_nalb_csr_control_reg_nxt ; //I HQM_NALB_TARGET_CFG_NALB_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_nalb_csr_control_reg_f ; //O HQM_NALB_TARGET_CFG_NALB_CSR_CONTROL
logic hqm_nalb_target_cfg_nalb_csr_control_reg_v ; //I HQM_NALB_TARGET_CFG_NALB_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_patch_control_reg_nxt ; //I HQM_NALB_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_patch_control_reg_f ; //O HQM_NALB_TARGET_CFG_PATCH_CONTROL
logic hqm_nalb_target_cfg_patch_control_reg_v ; //I HQM_NALB_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_hold_00_reg_nxt ; //I HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_00
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_hold_00_reg_f ; //O HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_00
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_hold_01_reg_nxt ; //I HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_hold_01_reg_f ; //O HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_valid_00_reg_nxt ; //I HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_00
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_valid_00_reg_f ; //O HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_00
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_valid_01_reg_nxt ; //I HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_pipe_health_valid_01_reg_f ; //O HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_01
logic hqm_nalb_target_cfg_smon_disable_smon ; //I HQM_NALB_TARGET_CFG_SMON
logic [ 24 - 1 : 0 ] hqm_nalb_target_cfg_smon_smon_v ; //I HQM_NALB_TARGET_CFG_SMON
logic [ ( 24 * 32 ) - 1 : 0 ] hqm_nalb_target_cfg_smon_smon_comp ; //I HQM_NALB_TARGET_CFG_SMON
logic [ ( 24 * 32 ) - 1 : 0 ] hqm_nalb_target_cfg_smon_smon_val ; //I HQM_NALB_TARGET_CFG_SMON
logic hqm_nalb_target_cfg_smon_smon_enabled ; //O HQM_NALB_TARGET_CFG_SMON
logic hqm_nalb_target_cfg_smon_smon_interrupt ; //O HQM_NALB_TARGET_CFG_SMON
logic hqm_nalb_target_cfg_syndrome_00_capture_v ; //I HQM_NALB_TARGET_CFG_SYNDROME_00
logic [ ( 31 ) - 1 : 0] hqm_nalb_target_cfg_syndrome_00_capture_data ; //I HQM_NALB_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_syndrome_00_syndrome_data ; //I HQM_NALB_TARGET_CFG_SYNDROME_00
logic hqm_nalb_target_cfg_syndrome_01_capture_v ; //I HQM_NALB_TARGET_CFG_SYNDROME_01
logic [ ( 31 ) - 1 : 0] hqm_nalb_target_cfg_syndrome_01_capture_data ; //I HQM_NALB_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_syndrome_01_syndrome_data ; //I HQM_NALB_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_unit_idle_reg_nxt ; //I HQM_NALB_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_unit_idle_reg_f ; //O HQM_NALB_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_unit_timeout_reg_nxt ; //I HQM_NALB_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_unit_timeout_reg_f ; //O HQM_NALB_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_nalb_target_cfg_unit_version_status ; //I HQM_NALB_TARGET_CFG_UNIT_VERSION
hqm_nalb_pipe_register_pfcsr i_hqm_nalb_pipe_register_pfcsr (
  .hqm_gated_clk ( hqm_gated_clk ) 
, .hqm_gated_rst_n ( hqm_gated_rst_n ) 
, .rst_prep ( '0 )
, .cfg_req_write ( pfcsr_cfg_req_write )
, .cfg_req_read ( pfcsr_cfg_req_read )
, .cfg_req ( pfcsr_cfg_req )
, .cfg_rsp_ack ( pfcsr_cfg_rsp_ack )
, .cfg_rsp_err ( pfcsr_cfg_rsp_err )
, .cfg_rsp_rdata ( pfcsr_cfg_rsp_rdata )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_nxt ( hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_nxt )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_f ( hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_f )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_v (  hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_v )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_1_status ( hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_1_status )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_nxt ( hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_nxt )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_f ( hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_f )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_v (  hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_v )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_1_status ( hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_1_status )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt ( hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_f ( hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_f )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_v (  hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_v )
, .hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_1_status ( hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_1_status )
, .hqm_nalb_target_cfg_control_general_reg_nxt ( hqm_nalb_target_cfg_control_general_reg_nxt )
, .hqm_nalb_target_cfg_control_general_reg_f ( hqm_nalb_target_cfg_control_general_reg_f )
, .hqm_nalb_target_cfg_control_general_reg_v (  hqm_nalb_target_cfg_control_general_reg_v )
, .hqm_nalb_target_cfg_control_pipeline_credits_reg_nxt ( hqm_nalb_target_cfg_control_pipeline_credits_reg_nxt )
, .hqm_nalb_target_cfg_control_pipeline_credits_reg_f ( hqm_nalb_target_cfg_control_pipeline_credits_reg_f )
, .hqm_nalb_target_cfg_control_pipeline_credits_reg_v (  hqm_nalb_target_cfg_control_pipeline_credits_reg_v )
, .hqm_nalb_target_cfg_detect_feature_operation_00_reg_nxt ( hqm_nalb_target_cfg_detect_feature_operation_00_reg_nxt )
, .hqm_nalb_target_cfg_detect_feature_operation_00_reg_f ( hqm_nalb_target_cfg_detect_feature_operation_00_reg_f )
, .hqm_nalb_target_cfg_detect_feature_operation_01_reg_nxt ( hqm_nalb_target_cfg_detect_feature_operation_01_reg_nxt )
, .hqm_nalb_target_cfg_detect_feature_operation_01_reg_f ( hqm_nalb_target_cfg_detect_feature_operation_01_reg_f )
, .hqm_nalb_target_cfg_diagnostic_aw_status_status ( hqm_nalb_target_cfg_diagnostic_aw_status_status )
, .hqm_nalb_target_cfg_diagnostic_aw_status_01_status ( hqm_nalb_target_cfg_diagnostic_aw_status_01_status )
, .hqm_nalb_target_cfg_diagnostic_aw_status_02_status ( hqm_nalb_target_cfg_diagnostic_aw_status_02_status )
, .hqm_nalb_target_cfg_error_inject_reg_nxt ( hqm_nalb_target_cfg_error_inject_reg_nxt )
, .hqm_nalb_target_cfg_error_inject_reg_f ( hqm_nalb_target_cfg_error_inject_reg_f )
, .hqm_nalb_target_cfg_error_inject_reg_v (  hqm_nalb_target_cfg_error_inject_reg_v )
, .hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_f )
, .hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_f )
, .hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_f )
, .hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_f )
, .hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_f )
, .hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_f )
, .hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_f )
, .hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_nxt ( hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_nxt )
, .hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_f ( hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_f )
, .hqm_nalb_target_cfg_hw_agitate_control_reg_nxt ( hqm_nalb_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_nalb_target_cfg_hw_agitate_control_reg_f ( hqm_nalb_target_cfg_hw_agitate_control_reg_f )
, .hqm_nalb_target_cfg_hw_agitate_control_reg_v (  hqm_nalb_target_cfg_hw_agitate_control_reg_v )
, .hqm_nalb_target_cfg_hw_agitate_select_reg_nxt ( hqm_nalb_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_nalb_target_cfg_hw_agitate_select_reg_f ( hqm_nalb_target_cfg_hw_agitate_select_reg_f )
, .hqm_nalb_target_cfg_hw_agitate_select_reg_v (  hqm_nalb_target_cfg_hw_agitate_select_reg_v )
, .hqm_nalb_target_cfg_interface_status_reg_nxt ( hqm_nalb_target_cfg_interface_status_reg_nxt )
, .hqm_nalb_target_cfg_interface_status_reg_f ( hqm_nalb_target_cfg_interface_status_reg_f )
, .hqm_nalb_target_cfg_nalb_csr_control_reg_nxt ( hqm_nalb_target_cfg_nalb_csr_control_reg_nxt )
, .hqm_nalb_target_cfg_nalb_csr_control_reg_f ( hqm_nalb_target_cfg_nalb_csr_control_reg_f )
, .hqm_nalb_target_cfg_nalb_csr_control_reg_v (  hqm_nalb_target_cfg_nalb_csr_control_reg_v )
, .hqm_nalb_target_cfg_patch_control_reg_nxt ( hqm_nalb_target_cfg_patch_control_reg_nxt )
, .hqm_nalb_target_cfg_patch_control_reg_f ( hqm_nalb_target_cfg_patch_control_reg_f )
, .hqm_nalb_target_cfg_patch_control_reg_v (  hqm_nalb_target_cfg_patch_control_reg_v )
, .hqm_nalb_target_cfg_pipe_health_hold_00_reg_nxt ( hqm_nalb_target_cfg_pipe_health_hold_00_reg_nxt )
, .hqm_nalb_target_cfg_pipe_health_hold_00_reg_f ( hqm_nalb_target_cfg_pipe_health_hold_00_reg_f )
, .hqm_nalb_target_cfg_pipe_health_hold_01_reg_nxt ( hqm_nalb_target_cfg_pipe_health_hold_01_reg_nxt )
, .hqm_nalb_target_cfg_pipe_health_hold_01_reg_f ( hqm_nalb_target_cfg_pipe_health_hold_01_reg_f )
, .hqm_nalb_target_cfg_pipe_health_valid_00_reg_nxt ( hqm_nalb_target_cfg_pipe_health_valid_00_reg_nxt )
, .hqm_nalb_target_cfg_pipe_health_valid_00_reg_f ( hqm_nalb_target_cfg_pipe_health_valid_00_reg_f )
, .hqm_nalb_target_cfg_pipe_health_valid_01_reg_nxt ( hqm_nalb_target_cfg_pipe_health_valid_01_reg_nxt )
, .hqm_nalb_target_cfg_pipe_health_valid_01_reg_f ( hqm_nalb_target_cfg_pipe_health_valid_01_reg_f )
, .hqm_nalb_target_cfg_smon_disable_smon ( hqm_nalb_target_cfg_smon_disable_smon )
, .hqm_nalb_target_cfg_smon_smon_v ( hqm_nalb_target_cfg_smon_smon_v )
, .hqm_nalb_target_cfg_smon_smon_comp ( hqm_nalb_target_cfg_smon_smon_comp )
, .hqm_nalb_target_cfg_smon_smon_val ( hqm_nalb_target_cfg_smon_smon_val )
, .hqm_nalb_target_cfg_smon_smon_enabled ( hqm_nalb_target_cfg_smon_smon_enabled )
, .hqm_nalb_target_cfg_smon_smon_interrupt ( hqm_nalb_target_cfg_smon_smon_interrupt )
, .hqm_nalb_target_cfg_syndrome_00_capture_v ( hqm_nalb_target_cfg_syndrome_00_capture_v )
, .hqm_nalb_target_cfg_syndrome_00_capture_data ( hqm_nalb_target_cfg_syndrome_00_capture_data )
, .hqm_nalb_target_cfg_syndrome_00_syndrome_data ( hqm_nalb_target_cfg_syndrome_00_syndrome_data )
, .hqm_nalb_target_cfg_syndrome_01_capture_v ( hqm_nalb_target_cfg_syndrome_01_capture_v )
, .hqm_nalb_target_cfg_syndrome_01_capture_data ( hqm_nalb_target_cfg_syndrome_01_capture_data )
, .hqm_nalb_target_cfg_syndrome_01_syndrome_data ( hqm_nalb_target_cfg_syndrome_01_syndrome_data )
, .hqm_nalb_target_cfg_unit_idle_reg_nxt ( hqm_nalb_target_cfg_unit_idle_reg_nxt )
, .hqm_nalb_target_cfg_unit_idle_reg_f ( hqm_nalb_target_cfg_unit_idle_reg_f )
, .hqm_nalb_target_cfg_unit_timeout_reg_nxt ( hqm_nalb_target_cfg_unit_timeout_reg_nxt )
, .hqm_nalb_target_cfg_unit_timeout_reg_f ( hqm_nalb_target_cfg_unit_timeout_reg_f )
, .hqm_nalb_target_cfg_unit_version_status ( hqm_nalb_target_cfg_unit_version_status )
) ;
// END HQM_CFG_ACCESS
// BEGIN HQM_RAM_ACCESS
localparam NUM_CFG_ACCESSIBLE_RAM = 1;
logic [(  1 *  1)-1:0] cfg_mem_re;
logic [(  1 *  1)-1:0] cfg_mem_we;
logic [(      20)-1:0] cfg_mem_addr;
logic [(      12)-1:0] cfg_mem_minbit;
logic [(      12)-1:0] cfg_mem_maxbit;
logic [(      32)-1:0] cfg_mem_wdata;
logic [(  1 * 32)-1:0] cfg_mem_rdata;
logic [(  1 *  1)-1:0] cfg_mem_ack;
logic                  cfg_mem_cc_v;
logic [(       8)-1:0] cfg_mem_cc_value;
logic [(       4)-1:0] cfg_mem_cc_width;
logic [(      12)-1:0] cfg_mem_cc_position;


logic                  hqm_nalb_pipe_rfw_top_ipar_error;

logic                  func_atq_cnt_re; //I
logic [(       7)-1:0] func_atq_cnt_raddr; //I
logic [(       7)-1:0] func_atq_cnt_waddr; //I
logic                  func_atq_cnt_we;    //I
logic [(      68)-1:0] func_atq_cnt_wdata; //I
logic [(      68)-1:0] func_atq_cnt_rdata;

logic                pf_atq_cnt_re;    //I
logic [(       7)-1:0] pf_atq_cnt_raddr; //I
logic [(       7)-1:0] pf_atq_cnt_waddr; //I
logic                  pf_atq_cnt_we;    //I
logic [(      68)-1:0] pf_atq_cnt_wdata; //I
logic [(      68)-1:0] pf_atq_cnt_rdata;

logic                  rf_atq_cnt_error;

logic                  func_atq_hp_re; //I
logic [(      10)-1:0] func_atq_hp_raddr; //I
logic [(      10)-1:0] func_atq_hp_waddr; //I
logic                  func_atq_hp_we;    //I
logic [(      15)-1:0] func_atq_hp_wdata; //I
logic [(      15)-1:0] func_atq_hp_rdata;

logic                pf_atq_hp_re;    //I
logic [(      10)-1:0] pf_atq_hp_raddr; //I
logic [(      10)-1:0] pf_atq_hp_waddr; //I
logic                  pf_atq_hp_we;    //I
logic [(      15)-1:0] pf_atq_hp_wdata; //I
logic [(      15)-1:0] pf_atq_hp_rdata;

logic                  rf_atq_hp_error;

logic                  func_atq_tp_re; //I
logic [(      10)-1:0] func_atq_tp_raddr; //I
logic [(      10)-1:0] func_atq_tp_waddr; //I
logic                  func_atq_tp_we;    //I
logic [(      15)-1:0] func_atq_tp_wdata; //I
logic [(      15)-1:0] func_atq_tp_rdata;

logic                pf_atq_tp_re;    //I
logic [(      10)-1:0] pf_atq_tp_raddr; //I
logic [(      10)-1:0] pf_atq_tp_waddr; //I
logic                  pf_atq_tp_we;    //I
logic [(      15)-1:0] pf_atq_tp_wdata; //I
logic [(      15)-1:0] pf_atq_tp_rdata;

logic                  rf_atq_tp_error;

logic                  func_lsp_nalb_sch_atq_re; //I
logic [(       5)-1:0] func_lsp_nalb_sch_atq_raddr; //I
logic [(       5)-1:0] func_lsp_nalb_sch_atq_waddr; //I
logic                  func_lsp_nalb_sch_atq_we;    //I
logic [(       8)-1:0] func_lsp_nalb_sch_atq_wdata; //I
logic [(       8)-1:0] func_lsp_nalb_sch_atq_rdata;

logic                pf_lsp_nalb_sch_atq_re;    //I
logic [(       5)-1:0] pf_lsp_nalb_sch_atq_raddr; //I
logic [(       5)-1:0] pf_lsp_nalb_sch_atq_waddr; //I
logic                  pf_lsp_nalb_sch_atq_we;    //I
logic [(       8)-1:0] pf_lsp_nalb_sch_atq_wdata; //I
logic [(       8)-1:0] pf_lsp_nalb_sch_atq_rdata;

logic                  rf_lsp_nalb_sch_atq_error;

logic                  func_lsp_nalb_sch_rorply_re; //I
logic [(       2)-1:0] func_lsp_nalb_sch_rorply_raddr; //I
logic [(       2)-1:0] func_lsp_nalb_sch_rorply_waddr; //I
logic                  func_lsp_nalb_sch_rorply_we;    //I
logic [(       8)-1:0] func_lsp_nalb_sch_rorply_wdata; //I
logic [(       8)-1:0] func_lsp_nalb_sch_rorply_rdata;

logic                pf_lsp_nalb_sch_rorply_re;    //I
logic [(       2)-1:0] pf_lsp_nalb_sch_rorply_raddr; //I
logic [(       2)-1:0] pf_lsp_nalb_sch_rorply_waddr; //I
logic                  pf_lsp_nalb_sch_rorply_we;    //I
logic [(       8)-1:0] pf_lsp_nalb_sch_rorply_wdata; //I
logic [(       8)-1:0] pf_lsp_nalb_sch_rorply_rdata;

logic                  rf_lsp_nalb_sch_rorply_error;

logic                  func_lsp_nalb_sch_unoord_re; //I
logic [(       2)-1:0] func_lsp_nalb_sch_unoord_raddr; //I
logic [(       2)-1:0] func_lsp_nalb_sch_unoord_waddr; //I
logic                  func_lsp_nalb_sch_unoord_we;    //I
logic [(      27)-1:0] func_lsp_nalb_sch_unoord_wdata; //I
logic [(      27)-1:0] func_lsp_nalb_sch_unoord_rdata;

logic                pf_lsp_nalb_sch_unoord_re;    //I
logic [(       2)-1:0] pf_lsp_nalb_sch_unoord_raddr; //I
logic [(       2)-1:0] pf_lsp_nalb_sch_unoord_waddr; //I
logic                  pf_lsp_nalb_sch_unoord_we;    //I
logic [(      27)-1:0] pf_lsp_nalb_sch_unoord_wdata; //I
logic [(      27)-1:0] pf_lsp_nalb_sch_unoord_rdata;

logic                  rf_lsp_nalb_sch_unoord_error;

logic                  func_nalb_cnt_re; //I
logic [(       7)-1:0] func_nalb_cnt_raddr; //I
logic [(       7)-1:0] func_nalb_cnt_waddr; //I
logic                  func_nalb_cnt_we;    //I
logic [(      68)-1:0] func_nalb_cnt_wdata; //I
logic [(      68)-1:0] func_nalb_cnt_rdata;

logic                pf_nalb_cnt_re;    //I
logic [(       7)-1:0] pf_nalb_cnt_raddr; //I
logic [(       7)-1:0] pf_nalb_cnt_waddr; //I
logic                  pf_nalb_cnt_we;    //I
logic [(      68)-1:0] pf_nalb_cnt_wdata; //I
logic [(      68)-1:0] pf_nalb_cnt_rdata;

logic                  rf_nalb_cnt_error;

logic                  func_nalb_hp_re; //I
logic [(      10)-1:0] func_nalb_hp_raddr; //I
logic [(      10)-1:0] func_nalb_hp_waddr; //I
logic                  func_nalb_hp_we;    //I
logic [(      15)-1:0] func_nalb_hp_wdata; //I
logic [(      15)-1:0] func_nalb_hp_rdata;

logic                pf_nalb_hp_re;    //I
logic [(      10)-1:0] pf_nalb_hp_raddr; //I
logic [(      10)-1:0] pf_nalb_hp_waddr; //I
logic                  pf_nalb_hp_we;    //I
logic [(      15)-1:0] pf_nalb_hp_wdata; //I
logic [(      15)-1:0] pf_nalb_hp_rdata;

logic                  rf_nalb_hp_error;

logic                  func_nalb_lsp_enq_rorply_re; //I
logic [(       5)-1:0] func_nalb_lsp_enq_rorply_raddr; //I
logic [(       5)-1:0] func_nalb_lsp_enq_rorply_waddr; //I
logic                  func_nalb_lsp_enq_rorply_we;    //I
logic [(      27)-1:0] func_nalb_lsp_enq_rorply_wdata; //I
logic [(      27)-1:0] func_nalb_lsp_enq_rorply_rdata;

logic                pf_nalb_lsp_enq_rorply_re;    //I
logic [(       5)-1:0] pf_nalb_lsp_enq_rorply_raddr; //I
logic [(       5)-1:0] pf_nalb_lsp_enq_rorply_waddr; //I
logic                  pf_nalb_lsp_enq_rorply_we;    //I
logic [(      27)-1:0] pf_nalb_lsp_enq_rorply_wdata; //I
logic [(      27)-1:0] pf_nalb_lsp_enq_rorply_rdata;

logic                  rf_nalb_lsp_enq_rorply_error;

logic                  func_nalb_lsp_enq_unoord_re; //I
logic [(       5)-1:0] func_nalb_lsp_enq_unoord_raddr; //I
logic [(       5)-1:0] func_nalb_lsp_enq_unoord_waddr; //I
logic                  func_nalb_lsp_enq_unoord_we;    //I
logic [(      10)-1:0] func_nalb_lsp_enq_unoord_wdata; //I
logic [(      10)-1:0] func_nalb_lsp_enq_unoord_rdata;

logic                pf_nalb_lsp_enq_unoord_re;    //I
logic [(       5)-1:0] pf_nalb_lsp_enq_unoord_raddr; //I
logic [(       5)-1:0] pf_nalb_lsp_enq_unoord_waddr; //I
logic                  pf_nalb_lsp_enq_unoord_we;    //I
logic [(      10)-1:0] pf_nalb_lsp_enq_unoord_wdata; //I
logic [(      10)-1:0] pf_nalb_lsp_enq_unoord_rdata;

logic                  rf_nalb_lsp_enq_unoord_error;

logic                  func_nalb_qed_re; //I
logic [(       5)-1:0] func_nalb_qed_raddr; //I
logic [(       5)-1:0] func_nalb_qed_waddr; //I
logic                  func_nalb_qed_we;    //I
logic [(      45)-1:0] func_nalb_qed_wdata; //I
logic [(      45)-1:0] func_nalb_qed_rdata;

logic                pf_nalb_qed_re;    //I
logic [(       5)-1:0] pf_nalb_qed_raddr; //I
logic [(       5)-1:0] pf_nalb_qed_waddr; //I
logic                  pf_nalb_qed_we;    //I
logic [(      45)-1:0] pf_nalb_qed_wdata; //I
logic [(      45)-1:0] pf_nalb_qed_rdata;

logic                  rf_nalb_qed_error;

logic                  func_nalb_replay_cnt_re; //I
logic [(       7)-1:0] func_nalb_replay_cnt_raddr; //I
logic [(       7)-1:0] func_nalb_replay_cnt_waddr; //I
logic                  func_nalb_replay_cnt_we;    //I
logic [(      68)-1:0] func_nalb_replay_cnt_wdata; //I
logic [(      68)-1:0] func_nalb_replay_cnt_rdata;

logic                pf_nalb_replay_cnt_re;    //I
logic [(       7)-1:0] pf_nalb_replay_cnt_raddr; //I
logic [(       7)-1:0] pf_nalb_replay_cnt_waddr; //I
logic                  pf_nalb_replay_cnt_we;    //I
logic [(      68)-1:0] pf_nalb_replay_cnt_wdata; //I
logic [(      68)-1:0] pf_nalb_replay_cnt_rdata;

logic                  rf_nalb_replay_cnt_error;

logic                  func_nalb_replay_hp_re; //I
logic [(      10)-1:0] func_nalb_replay_hp_raddr; //I
logic [(      10)-1:0] func_nalb_replay_hp_waddr; //I
logic                  func_nalb_replay_hp_we;    //I
logic [(      15)-1:0] func_nalb_replay_hp_wdata; //I
logic [(      15)-1:0] func_nalb_replay_hp_rdata;

logic                pf_nalb_replay_hp_re;    //I
logic [(      10)-1:0] pf_nalb_replay_hp_raddr; //I
logic [(      10)-1:0] pf_nalb_replay_hp_waddr; //I
logic                  pf_nalb_replay_hp_we;    //I
logic [(      15)-1:0] pf_nalb_replay_hp_wdata; //I
logic [(      15)-1:0] pf_nalb_replay_hp_rdata;

logic                  rf_nalb_replay_hp_error;

logic                  func_nalb_replay_tp_re; //I
logic [(      10)-1:0] func_nalb_replay_tp_raddr; //I
logic [(      10)-1:0] func_nalb_replay_tp_waddr; //I
logic                  func_nalb_replay_tp_we;    //I
logic [(      15)-1:0] func_nalb_replay_tp_wdata; //I
logic [(      15)-1:0] func_nalb_replay_tp_rdata;

logic                pf_nalb_replay_tp_re;    //I
logic [(      10)-1:0] pf_nalb_replay_tp_raddr; //I
logic [(      10)-1:0] pf_nalb_replay_tp_waddr; //I
logic                  pf_nalb_replay_tp_we;    //I
logic [(      15)-1:0] pf_nalb_replay_tp_wdata; //I
logic [(      15)-1:0] pf_nalb_replay_tp_rdata;

logic                  rf_nalb_replay_tp_error;

logic                  func_nalb_rofrag_cnt_re; //I
logic [(       9)-1:0] func_nalb_rofrag_cnt_raddr; //I
logic [(       9)-1:0] func_nalb_rofrag_cnt_waddr; //I
logic                  func_nalb_rofrag_cnt_we;    //I
logic [(      17)-1:0] func_nalb_rofrag_cnt_wdata; //I
logic [(      17)-1:0] func_nalb_rofrag_cnt_rdata;

logic                pf_nalb_rofrag_cnt_re;    //I
logic [(       9)-1:0] pf_nalb_rofrag_cnt_raddr; //I
logic [(       9)-1:0] pf_nalb_rofrag_cnt_waddr; //I
logic                  pf_nalb_rofrag_cnt_we;    //I
logic [(      17)-1:0] pf_nalb_rofrag_cnt_wdata; //I
logic [(      17)-1:0] pf_nalb_rofrag_cnt_rdata;

logic                  rf_nalb_rofrag_cnt_error;

logic                  func_nalb_rofrag_hp_re; //I
logic [(       9)-1:0] func_nalb_rofrag_hp_raddr; //I
logic [(       9)-1:0] func_nalb_rofrag_hp_waddr; //I
logic                  func_nalb_rofrag_hp_we;    //I
logic [(      15)-1:0] func_nalb_rofrag_hp_wdata; //I
logic [(      15)-1:0] func_nalb_rofrag_hp_rdata;

logic                pf_nalb_rofrag_hp_re;    //I
logic [(       9)-1:0] pf_nalb_rofrag_hp_raddr; //I
logic [(       9)-1:0] pf_nalb_rofrag_hp_waddr; //I
logic                  pf_nalb_rofrag_hp_we;    //I
logic [(      15)-1:0] pf_nalb_rofrag_hp_wdata; //I
logic [(      15)-1:0] pf_nalb_rofrag_hp_rdata;

logic                  rf_nalb_rofrag_hp_error;

logic                  func_nalb_rofrag_tp_re; //I
logic [(       9)-1:0] func_nalb_rofrag_tp_raddr; //I
logic [(       9)-1:0] func_nalb_rofrag_tp_waddr; //I
logic                  func_nalb_rofrag_tp_we;    //I
logic [(      15)-1:0] func_nalb_rofrag_tp_wdata; //I
logic [(      15)-1:0] func_nalb_rofrag_tp_rdata;

logic                pf_nalb_rofrag_tp_re;    //I
logic [(       9)-1:0] pf_nalb_rofrag_tp_raddr; //I
logic [(       9)-1:0] pf_nalb_rofrag_tp_waddr; //I
logic                  pf_nalb_rofrag_tp_we;    //I
logic [(      15)-1:0] pf_nalb_rofrag_tp_wdata; //I
logic [(      15)-1:0] pf_nalb_rofrag_tp_rdata;

logic                  rf_nalb_rofrag_tp_error;

logic                  func_nalb_tp_re; //I
logic [(      10)-1:0] func_nalb_tp_raddr; //I
logic [(      10)-1:0] func_nalb_tp_waddr; //I
logic                  func_nalb_tp_we;    //I
logic [(      15)-1:0] func_nalb_tp_wdata; //I
logic [(      15)-1:0] func_nalb_tp_rdata;

logic                pf_nalb_tp_re;    //I
logic [(      10)-1:0] pf_nalb_tp_raddr; //I
logic [(      10)-1:0] pf_nalb_tp_waddr; //I
logic                  pf_nalb_tp_we;    //I
logic [(      15)-1:0] pf_nalb_tp_wdata; //I
logic [(      15)-1:0] pf_nalb_tp_rdata;

logic                  rf_nalb_tp_error;

logic                  func_rop_nalb_enq_ro_re; //I
logic [(       2)-1:0] func_rop_nalb_enq_ro_raddr; //I
logic [(       2)-1:0] func_rop_nalb_enq_ro_waddr; //I
logic                  func_rop_nalb_enq_ro_we;    //I
logic [(     100)-1:0] func_rop_nalb_enq_ro_wdata; //I
logic [(     100)-1:0] func_rop_nalb_enq_ro_rdata;

logic                pf_rop_nalb_enq_ro_re;    //I
logic [(       2)-1:0] pf_rop_nalb_enq_ro_raddr; //I
logic [(       2)-1:0] pf_rop_nalb_enq_ro_waddr; //I
logic                  pf_rop_nalb_enq_ro_we;    //I
logic [(     100)-1:0] pf_rop_nalb_enq_ro_wdata; //I
logic [(     100)-1:0] pf_rop_nalb_enq_ro_rdata;

logic                  rf_rop_nalb_enq_ro_error;

logic                  func_rop_nalb_enq_unoord_re; //I
logic [(       2)-1:0] func_rop_nalb_enq_unoord_raddr; //I
logic [(       2)-1:0] func_rop_nalb_enq_unoord_waddr; //I
logic                  func_rop_nalb_enq_unoord_we;    //I
logic [(     100)-1:0] func_rop_nalb_enq_unoord_wdata; //I
logic [(     100)-1:0] func_rop_nalb_enq_unoord_rdata;

logic                pf_rop_nalb_enq_unoord_re;    //I
logic [(       2)-1:0] pf_rop_nalb_enq_unoord_raddr; //I
logic [(       2)-1:0] pf_rop_nalb_enq_unoord_waddr; //I
logic                  pf_rop_nalb_enq_unoord_we;    //I
logic [(     100)-1:0] pf_rop_nalb_enq_unoord_wdata; //I
logic [(     100)-1:0] pf_rop_nalb_enq_unoord_rdata;

logic                  rf_rop_nalb_enq_unoord_error;

logic                  func_rx_sync_lsp_nalb_sch_atq_re; //I
logic [(       2)-1:0] func_rx_sync_lsp_nalb_sch_atq_raddr; //I
logic [(       2)-1:0] func_rx_sync_lsp_nalb_sch_atq_waddr; //I
logic                  func_rx_sync_lsp_nalb_sch_atq_we;    //I
logic [(       8)-1:0] func_rx_sync_lsp_nalb_sch_atq_wdata; //I
logic [(       8)-1:0] func_rx_sync_lsp_nalb_sch_atq_rdata;

logic                pf_rx_sync_lsp_nalb_sch_atq_re;    //I
logic [(       2)-1:0] pf_rx_sync_lsp_nalb_sch_atq_raddr; //I
logic [(       2)-1:0] pf_rx_sync_lsp_nalb_sch_atq_waddr; //I
logic                  pf_rx_sync_lsp_nalb_sch_atq_we;    //I
logic [(       8)-1:0] pf_rx_sync_lsp_nalb_sch_atq_wdata; //I
logic [(       8)-1:0] pf_rx_sync_lsp_nalb_sch_atq_rdata;

logic                  rf_rx_sync_lsp_nalb_sch_atq_error;

logic                  func_rx_sync_lsp_nalb_sch_rorply_re; //I
logic [(       2)-1:0] func_rx_sync_lsp_nalb_sch_rorply_raddr; //I
logic [(       2)-1:0] func_rx_sync_lsp_nalb_sch_rorply_waddr; //I
logic                  func_rx_sync_lsp_nalb_sch_rorply_we;    //I
logic [(       8)-1:0] func_rx_sync_lsp_nalb_sch_rorply_wdata; //I
logic [(       8)-1:0] func_rx_sync_lsp_nalb_sch_rorply_rdata;

logic                pf_rx_sync_lsp_nalb_sch_rorply_re;    //I
logic [(       2)-1:0] pf_rx_sync_lsp_nalb_sch_rorply_raddr; //I
logic [(       2)-1:0] pf_rx_sync_lsp_nalb_sch_rorply_waddr; //I
logic                  pf_rx_sync_lsp_nalb_sch_rorply_we;    //I
logic [(       8)-1:0] pf_rx_sync_lsp_nalb_sch_rorply_wdata; //I
logic [(       8)-1:0] pf_rx_sync_lsp_nalb_sch_rorply_rdata;

logic                  rf_rx_sync_lsp_nalb_sch_rorply_error;

logic                  func_rx_sync_lsp_nalb_sch_unoord_re; //I
logic [(       2)-1:0] func_rx_sync_lsp_nalb_sch_unoord_raddr; //I
logic [(       2)-1:0] func_rx_sync_lsp_nalb_sch_unoord_waddr; //I
logic                  func_rx_sync_lsp_nalb_sch_unoord_we;    //I
logic [(      27)-1:0] func_rx_sync_lsp_nalb_sch_unoord_wdata; //I
logic [(      27)-1:0] func_rx_sync_lsp_nalb_sch_unoord_rdata;

logic                pf_rx_sync_lsp_nalb_sch_unoord_re;    //I
logic [(       2)-1:0] pf_rx_sync_lsp_nalb_sch_unoord_raddr; //I
logic [(       2)-1:0] pf_rx_sync_lsp_nalb_sch_unoord_waddr; //I
logic                  pf_rx_sync_lsp_nalb_sch_unoord_we;    //I
logic [(      27)-1:0] pf_rx_sync_lsp_nalb_sch_unoord_wdata; //I
logic [(      27)-1:0] pf_rx_sync_lsp_nalb_sch_unoord_rdata;

logic                  rf_rx_sync_lsp_nalb_sch_unoord_error;

logic                  func_rx_sync_rop_nalb_enq_re; //I
logic [(       2)-1:0] func_rx_sync_rop_nalb_enq_raddr; //I
logic [(       2)-1:0] func_rx_sync_rop_nalb_enq_waddr; //I
logic                  func_rx_sync_rop_nalb_enq_we;    //I
logic [(     100)-1:0] func_rx_sync_rop_nalb_enq_wdata; //I
logic [(     100)-1:0] func_rx_sync_rop_nalb_enq_rdata;

logic                pf_rx_sync_rop_nalb_enq_re;    //I
logic [(       2)-1:0] pf_rx_sync_rop_nalb_enq_raddr; //I
logic [(       2)-1:0] pf_rx_sync_rop_nalb_enq_waddr; //I
logic                  pf_rx_sync_rop_nalb_enq_we;    //I
logic [(     100)-1:0] pf_rx_sync_rop_nalb_enq_wdata; //I
logic [(     100)-1:0] pf_rx_sync_rop_nalb_enq_rdata;

logic                  rf_rx_sync_rop_nalb_enq_error;

logic                  func_nalb_nxthp_re;    //I
logic [(      14)-1:0] func_nalb_nxthp_addr;  //I
logic                  func_nalb_nxthp_we;    //I
logic [(      21)-1:0] func_nalb_nxthp_wdata; //I
logic [(      21)-1:0] func_nalb_nxthp_rdata;

logic                  pf_nalb_nxthp_re;   //I
logic [(      14)-1:0] pf_nalb_nxthp_addr; //I
logic                  pf_nalb_nxthp_we;   //I
logic [(      21)-1:0] pf_nalb_nxthp_wdata; //I
logic [(      21)-1:0] pf_nalb_nxthp_rdata;

logic                  sr_nalb_nxthp_error;

hqm_nalb_pipe_ram_access i_hqm_nalb_pipe_ram_access (
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

,.hqm_nalb_pipe_rfw_top_ipar_error (hqm_nalb_pipe_rfw_top_ipar_error)

,.func_atq_cnt_re    (func_atq_cnt_re)
,.func_atq_cnt_raddr (func_atq_cnt_raddr)
,.func_atq_cnt_waddr (func_atq_cnt_waddr)
,.func_atq_cnt_we    (func_atq_cnt_we)
,.func_atq_cnt_wdata (func_atq_cnt_wdata)
,.func_atq_cnt_rdata (func_atq_cnt_rdata)

,.pf_atq_cnt_re      (pf_atq_cnt_re)
,.pf_atq_cnt_raddr (pf_atq_cnt_raddr)
,.pf_atq_cnt_waddr (pf_atq_cnt_waddr)
,.pf_atq_cnt_we    (pf_atq_cnt_we)
,.pf_atq_cnt_wdata (pf_atq_cnt_wdata)
,.pf_atq_cnt_rdata (pf_atq_cnt_rdata)

,.rf_atq_cnt_rclk (rf_atq_cnt_rclk)
,.rf_atq_cnt_rclk_rst_n (rf_atq_cnt_rclk_rst_n)
,.rf_atq_cnt_re    (rf_atq_cnt_re)
,.rf_atq_cnt_raddr (rf_atq_cnt_raddr)
,.rf_atq_cnt_waddr (rf_atq_cnt_waddr)
,.rf_atq_cnt_wclk (rf_atq_cnt_wclk)
,.rf_atq_cnt_wclk_rst_n (rf_atq_cnt_wclk_rst_n)
,.rf_atq_cnt_we    (rf_atq_cnt_we)
,.rf_atq_cnt_wdata (rf_atq_cnt_wdata)
,.rf_atq_cnt_rdata (rf_atq_cnt_rdata)

,.rf_atq_cnt_error (rf_atq_cnt_error)

,.func_atq_hp_re    (func_atq_hp_re)
,.func_atq_hp_raddr (func_atq_hp_raddr)
,.func_atq_hp_waddr (func_atq_hp_waddr)
,.func_atq_hp_we    (func_atq_hp_we)
,.func_atq_hp_wdata (func_atq_hp_wdata)
,.func_atq_hp_rdata (func_atq_hp_rdata)

,.pf_atq_hp_re      (pf_atq_hp_re)
,.pf_atq_hp_raddr (pf_atq_hp_raddr)
,.pf_atq_hp_waddr (pf_atq_hp_waddr)
,.pf_atq_hp_we    (pf_atq_hp_we)
,.pf_atq_hp_wdata (pf_atq_hp_wdata)
,.pf_atq_hp_rdata (pf_atq_hp_rdata)

,.rf_atq_hp_rclk (rf_atq_hp_rclk)
,.rf_atq_hp_rclk_rst_n (rf_atq_hp_rclk_rst_n)
,.rf_atq_hp_re    (rf_atq_hp_re)
,.rf_atq_hp_raddr (rf_atq_hp_raddr)
,.rf_atq_hp_waddr (rf_atq_hp_waddr)
,.rf_atq_hp_wclk (rf_atq_hp_wclk)
,.rf_atq_hp_wclk_rst_n (rf_atq_hp_wclk_rst_n)
,.rf_atq_hp_we    (rf_atq_hp_we)
,.rf_atq_hp_wdata (rf_atq_hp_wdata)
,.rf_atq_hp_rdata (rf_atq_hp_rdata)

,.rf_atq_hp_error (rf_atq_hp_error)

,.func_atq_tp_re    (func_atq_tp_re)
,.func_atq_tp_raddr (func_atq_tp_raddr)
,.func_atq_tp_waddr (func_atq_tp_waddr)
,.func_atq_tp_we    (func_atq_tp_we)
,.func_atq_tp_wdata (func_atq_tp_wdata)
,.func_atq_tp_rdata (func_atq_tp_rdata)

,.pf_atq_tp_re      (pf_atq_tp_re)
,.pf_atq_tp_raddr (pf_atq_tp_raddr)
,.pf_atq_tp_waddr (pf_atq_tp_waddr)
,.pf_atq_tp_we    (pf_atq_tp_we)
,.pf_atq_tp_wdata (pf_atq_tp_wdata)
,.pf_atq_tp_rdata (pf_atq_tp_rdata)

,.rf_atq_tp_rclk (rf_atq_tp_rclk)
,.rf_atq_tp_rclk_rst_n (rf_atq_tp_rclk_rst_n)
,.rf_atq_tp_re    (rf_atq_tp_re)
,.rf_atq_tp_raddr (rf_atq_tp_raddr)
,.rf_atq_tp_waddr (rf_atq_tp_waddr)
,.rf_atq_tp_wclk (rf_atq_tp_wclk)
,.rf_atq_tp_wclk_rst_n (rf_atq_tp_wclk_rst_n)
,.rf_atq_tp_we    (rf_atq_tp_we)
,.rf_atq_tp_wdata (rf_atq_tp_wdata)
,.rf_atq_tp_rdata (rf_atq_tp_rdata)

,.rf_atq_tp_error (rf_atq_tp_error)

,.func_lsp_nalb_sch_atq_re    (func_lsp_nalb_sch_atq_re)
,.func_lsp_nalb_sch_atq_raddr (func_lsp_nalb_sch_atq_raddr)
,.func_lsp_nalb_sch_atq_waddr (func_lsp_nalb_sch_atq_waddr)
,.func_lsp_nalb_sch_atq_we    (func_lsp_nalb_sch_atq_we)
,.func_lsp_nalb_sch_atq_wdata (func_lsp_nalb_sch_atq_wdata)
,.func_lsp_nalb_sch_atq_rdata (func_lsp_nalb_sch_atq_rdata)

,.pf_lsp_nalb_sch_atq_re      (pf_lsp_nalb_sch_atq_re)
,.pf_lsp_nalb_sch_atq_raddr (pf_lsp_nalb_sch_atq_raddr)
,.pf_lsp_nalb_sch_atq_waddr (pf_lsp_nalb_sch_atq_waddr)
,.pf_lsp_nalb_sch_atq_we    (pf_lsp_nalb_sch_atq_we)
,.pf_lsp_nalb_sch_atq_wdata (pf_lsp_nalb_sch_atq_wdata)
,.pf_lsp_nalb_sch_atq_rdata (pf_lsp_nalb_sch_atq_rdata)

,.rf_lsp_nalb_sch_atq_rclk (rf_lsp_nalb_sch_atq_rclk)
,.rf_lsp_nalb_sch_atq_rclk_rst_n (rf_lsp_nalb_sch_atq_rclk_rst_n)
,.rf_lsp_nalb_sch_atq_re    (rf_lsp_nalb_sch_atq_re)
,.rf_lsp_nalb_sch_atq_raddr (rf_lsp_nalb_sch_atq_raddr)
,.rf_lsp_nalb_sch_atq_waddr (rf_lsp_nalb_sch_atq_waddr)
,.rf_lsp_nalb_sch_atq_wclk (rf_lsp_nalb_sch_atq_wclk)
,.rf_lsp_nalb_sch_atq_wclk_rst_n (rf_lsp_nalb_sch_atq_wclk_rst_n)
,.rf_lsp_nalb_sch_atq_we    (rf_lsp_nalb_sch_atq_we)
,.rf_lsp_nalb_sch_atq_wdata (rf_lsp_nalb_sch_atq_wdata)
,.rf_lsp_nalb_sch_atq_rdata (rf_lsp_nalb_sch_atq_rdata)

,.rf_lsp_nalb_sch_atq_error (rf_lsp_nalb_sch_atq_error)

,.func_lsp_nalb_sch_rorply_re    (func_lsp_nalb_sch_rorply_re)
,.func_lsp_nalb_sch_rorply_raddr (func_lsp_nalb_sch_rorply_raddr)
,.func_lsp_nalb_sch_rorply_waddr (func_lsp_nalb_sch_rorply_waddr)
,.func_lsp_nalb_sch_rorply_we    (func_lsp_nalb_sch_rorply_we)
,.func_lsp_nalb_sch_rorply_wdata (func_lsp_nalb_sch_rorply_wdata)
,.func_lsp_nalb_sch_rorply_rdata (func_lsp_nalb_sch_rorply_rdata)

,.pf_lsp_nalb_sch_rorply_re      (pf_lsp_nalb_sch_rorply_re)
,.pf_lsp_nalb_sch_rorply_raddr (pf_lsp_nalb_sch_rorply_raddr)
,.pf_lsp_nalb_sch_rorply_waddr (pf_lsp_nalb_sch_rorply_waddr)
,.pf_lsp_nalb_sch_rorply_we    (pf_lsp_nalb_sch_rorply_we)
,.pf_lsp_nalb_sch_rorply_wdata (pf_lsp_nalb_sch_rorply_wdata)
,.pf_lsp_nalb_sch_rorply_rdata (pf_lsp_nalb_sch_rorply_rdata)

,.rf_lsp_nalb_sch_rorply_rclk (rf_lsp_nalb_sch_rorply_rclk)
,.rf_lsp_nalb_sch_rorply_rclk_rst_n (rf_lsp_nalb_sch_rorply_rclk_rst_n)
,.rf_lsp_nalb_sch_rorply_re    (rf_lsp_nalb_sch_rorply_re)
,.rf_lsp_nalb_sch_rorply_raddr (rf_lsp_nalb_sch_rorply_raddr)
,.rf_lsp_nalb_sch_rorply_waddr (rf_lsp_nalb_sch_rorply_waddr)
,.rf_lsp_nalb_sch_rorply_wclk (rf_lsp_nalb_sch_rorply_wclk)
,.rf_lsp_nalb_sch_rorply_wclk_rst_n (rf_lsp_nalb_sch_rorply_wclk_rst_n)
,.rf_lsp_nalb_sch_rorply_we    (rf_lsp_nalb_sch_rorply_we)
,.rf_lsp_nalb_sch_rorply_wdata (rf_lsp_nalb_sch_rorply_wdata)
,.rf_lsp_nalb_sch_rorply_rdata (rf_lsp_nalb_sch_rorply_rdata)

,.rf_lsp_nalb_sch_rorply_error (rf_lsp_nalb_sch_rorply_error)

,.func_lsp_nalb_sch_unoord_re    (func_lsp_nalb_sch_unoord_re)
,.func_lsp_nalb_sch_unoord_raddr (func_lsp_nalb_sch_unoord_raddr)
,.func_lsp_nalb_sch_unoord_waddr (func_lsp_nalb_sch_unoord_waddr)
,.func_lsp_nalb_sch_unoord_we    (func_lsp_nalb_sch_unoord_we)
,.func_lsp_nalb_sch_unoord_wdata (func_lsp_nalb_sch_unoord_wdata)
,.func_lsp_nalb_sch_unoord_rdata (func_lsp_nalb_sch_unoord_rdata)

,.pf_lsp_nalb_sch_unoord_re      (pf_lsp_nalb_sch_unoord_re)
,.pf_lsp_nalb_sch_unoord_raddr (pf_lsp_nalb_sch_unoord_raddr)
,.pf_lsp_nalb_sch_unoord_waddr (pf_lsp_nalb_sch_unoord_waddr)
,.pf_lsp_nalb_sch_unoord_we    (pf_lsp_nalb_sch_unoord_we)
,.pf_lsp_nalb_sch_unoord_wdata (pf_lsp_nalb_sch_unoord_wdata)
,.pf_lsp_nalb_sch_unoord_rdata (pf_lsp_nalb_sch_unoord_rdata)

,.rf_lsp_nalb_sch_unoord_rclk (rf_lsp_nalb_sch_unoord_rclk)
,.rf_lsp_nalb_sch_unoord_rclk_rst_n (rf_lsp_nalb_sch_unoord_rclk_rst_n)
,.rf_lsp_nalb_sch_unoord_re    (rf_lsp_nalb_sch_unoord_re)
,.rf_lsp_nalb_sch_unoord_raddr (rf_lsp_nalb_sch_unoord_raddr)
,.rf_lsp_nalb_sch_unoord_waddr (rf_lsp_nalb_sch_unoord_waddr)
,.rf_lsp_nalb_sch_unoord_wclk (rf_lsp_nalb_sch_unoord_wclk)
,.rf_lsp_nalb_sch_unoord_wclk_rst_n (rf_lsp_nalb_sch_unoord_wclk_rst_n)
,.rf_lsp_nalb_sch_unoord_we    (rf_lsp_nalb_sch_unoord_we)
,.rf_lsp_nalb_sch_unoord_wdata (rf_lsp_nalb_sch_unoord_wdata)
,.rf_lsp_nalb_sch_unoord_rdata (rf_lsp_nalb_sch_unoord_rdata)

,.rf_lsp_nalb_sch_unoord_error (rf_lsp_nalb_sch_unoord_error)

,.func_nalb_cnt_re    (func_nalb_cnt_re)
,.func_nalb_cnt_raddr (func_nalb_cnt_raddr)
,.func_nalb_cnt_waddr (func_nalb_cnt_waddr)
,.func_nalb_cnt_we    (func_nalb_cnt_we)
,.func_nalb_cnt_wdata (func_nalb_cnt_wdata)
,.func_nalb_cnt_rdata (func_nalb_cnt_rdata)

,.pf_nalb_cnt_re      (pf_nalb_cnt_re)
,.pf_nalb_cnt_raddr (pf_nalb_cnt_raddr)
,.pf_nalb_cnt_waddr (pf_nalb_cnt_waddr)
,.pf_nalb_cnt_we    (pf_nalb_cnt_we)
,.pf_nalb_cnt_wdata (pf_nalb_cnt_wdata)
,.pf_nalb_cnt_rdata (pf_nalb_cnt_rdata)

,.rf_nalb_cnt_rclk (rf_nalb_cnt_rclk)
,.rf_nalb_cnt_rclk_rst_n (rf_nalb_cnt_rclk_rst_n)
,.rf_nalb_cnt_re    (rf_nalb_cnt_re)
,.rf_nalb_cnt_raddr (rf_nalb_cnt_raddr)
,.rf_nalb_cnt_waddr (rf_nalb_cnt_waddr)
,.rf_nalb_cnt_wclk (rf_nalb_cnt_wclk)
,.rf_nalb_cnt_wclk_rst_n (rf_nalb_cnt_wclk_rst_n)
,.rf_nalb_cnt_we    (rf_nalb_cnt_we)
,.rf_nalb_cnt_wdata (rf_nalb_cnt_wdata)
,.rf_nalb_cnt_rdata (rf_nalb_cnt_rdata)

,.rf_nalb_cnt_error (rf_nalb_cnt_error)

,.func_nalb_hp_re    (func_nalb_hp_re)
,.func_nalb_hp_raddr (func_nalb_hp_raddr)
,.func_nalb_hp_waddr (func_nalb_hp_waddr)
,.func_nalb_hp_we    (func_nalb_hp_we)
,.func_nalb_hp_wdata (func_nalb_hp_wdata)
,.func_nalb_hp_rdata (func_nalb_hp_rdata)

,.pf_nalb_hp_re      (pf_nalb_hp_re)
,.pf_nalb_hp_raddr (pf_nalb_hp_raddr)
,.pf_nalb_hp_waddr (pf_nalb_hp_waddr)
,.pf_nalb_hp_we    (pf_nalb_hp_we)
,.pf_nalb_hp_wdata (pf_nalb_hp_wdata)
,.pf_nalb_hp_rdata (pf_nalb_hp_rdata)

,.rf_nalb_hp_rclk (rf_nalb_hp_rclk)
,.rf_nalb_hp_rclk_rst_n (rf_nalb_hp_rclk_rst_n)
,.rf_nalb_hp_re    (rf_nalb_hp_re)
,.rf_nalb_hp_raddr (rf_nalb_hp_raddr)
,.rf_nalb_hp_waddr (rf_nalb_hp_waddr)
,.rf_nalb_hp_wclk (rf_nalb_hp_wclk)
,.rf_nalb_hp_wclk_rst_n (rf_nalb_hp_wclk_rst_n)
,.rf_nalb_hp_we    (rf_nalb_hp_we)
,.rf_nalb_hp_wdata (rf_nalb_hp_wdata)
,.rf_nalb_hp_rdata (rf_nalb_hp_rdata)

,.rf_nalb_hp_error (rf_nalb_hp_error)

,.func_nalb_lsp_enq_rorply_re    (func_nalb_lsp_enq_rorply_re)
,.func_nalb_lsp_enq_rorply_raddr (func_nalb_lsp_enq_rorply_raddr)
,.func_nalb_lsp_enq_rorply_waddr (func_nalb_lsp_enq_rorply_waddr)
,.func_nalb_lsp_enq_rorply_we    (func_nalb_lsp_enq_rorply_we)
,.func_nalb_lsp_enq_rorply_wdata (func_nalb_lsp_enq_rorply_wdata)
,.func_nalb_lsp_enq_rorply_rdata (func_nalb_lsp_enq_rorply_rdata)

,.pf_nalb_lsp_enq_rorply_re      (pf_nalb_lsp_enq_rorply_re)
,.pf_nalb_lsp_enq_rorply_raddr (pf_nalb_lsp_enq_rorply_raddr)
,.pf_nalb_lsp_enq_rorply_waddr (pf_nalb_lsp_enq_rorply_waddr)
,.pf_nalb_lsp_enq_rorply_we    (pf_nalb_lsp_enq_rorply_we)
,.pf_nalb_lsp_enq_rorply_wdata (pf_nalb_lsp_enq_rorply_wdata)
,.pf_nalb_lsp_enq_rorply_rdata (pf_nalb_lsp_enq_rorply_rdata)

,.rf_nalb_lsp_enq_rorply_rclk (rf_nalb_lsp_enq_rorply_rclk)
,.rf_nalb_lsp_enq_rorply_rclk_rst_n (rf_nalb_lsp_enq_rorply_rclk_rst_n)
,.rf_nalb_lsp_enq_rorply_re    (rf_nalb_lsp_enq_rorply_re)
,.rf_nalb_lsp_enq_rorply_raddr (rf_nalb_lsp_enq_rorply_raddr)
,.rf_nalb_lsp_enq_rorply_waddr (rf_nalb_lsp_enq_rorply_waddr)
,.rf_nalb_lsp_enq_rorply_wclk (rf_nalb_lsp_enq_rorply_wclk)
,.rf_nalb_lsp_enq_rorply_wclk_rst_n (rf_nalb_lsp_enq_rorply_wclk_rst_n)
,.rf_nalb_lsp_enq_rorply_we    (rf_nalb_lsp_enq_rorply_we)
,.rf_nalb_lsp_enq_rorply_wdata (rf_nalb_lsp_enq_rorply_wdata)
,.rf_nalb_lsp_enq_rorply_rdata (rf_nalb_lsp_enq_rorply_rdata)

,.rf_nalb_lsp_enq_rorply_error (rf_nalb_lsp_enq_rorply_error)

,.func_nalb_lsp_enq_unoord_re    (func_nalb_lsp_enq_unoord_re)
,.func_nalb_lsp_enq_unoord_raddr (func_nalb_lsp_enq_unoord_raddr)
,.func_nalb_lsp_enq_unoord_waddr (func_nalb_lsp_enq_unoord_waddr)
,.func_nalb_lsp_enq_unoord_we    (func_nalb_lsp_enq_unoord_we)
,.func_nalb_lsp_enq_unoord_wdata (func_nalb_lsp_enq_unoord_wdata)
,.func_nalb_lsp_enq_unoord_rdata (func_nalb_lsp_enq_unoord_rdata)

,.pf_nalb_lsp_enq_unoord_re      (pf_nalb_lsp_enq_unoord_re)
,.pf_nalb_lsp_enq_unoord_raddr (pf_nalb_lsp_enq_unoord_raddr)
,.pf_nalb_lsp_enq_unoord_waddr (pf_nalb_lsp_enq_unoord_waddr)
,.pf_nalb_lsp_enq_unoord_we    (pf_nalb_lsp_enq_unoord_we)
,.pf_nalb_lsp_enq_unoord_wdata (pf_nalb_lsp_enq_unoord_wdata)
,.pf_nalb_lsp_enq_unoord_rdata (pf_nalb_lsp_enq_unoord_rdata)

,.rf_nalb_lsp_enq_unoord_rclk (rf_nalb_lsp_enq_unoord_rclk)
,.rf_nalb_lsp_enq_unoord_rclk_rst_n (rf_nalb_lsp_enq_unoord_rclk_rst_n)
,.rf_nalb_lsp_enq_unoord_re    (rf_nalb_lsp_enq_unoord_re)
,.rf_nalb_lsp_enq_unoord_raddr (rf_nalb_lsp_enq_unoord_raddr)
,.rf_nalb_lsp_enq_unoord_waddr (rf_nalb_lsp_enq_unoord_waddr)
,.rf_nalb_lsp_enq_unoord_wclk (rf_nalb_lsp_enq_unoord_wclk)
,.rf_nalb_lsp_enq_unoord_wclk_rst_n (rf_nalb_lsp_enq_unoord_wclk_rst_n)
,.rf_nalb_lsp_enq_unoord_we    (rf_nalb_lsp_enq_unoord_we)
,.rf_nalb_lsp_enq_unoord_wdata (rf_nalb_lsp_enq_unoord_wdata)
,.rf_nalb_lsp_enq_unoord_rdata (rf_nalb_lsp_enq_unoord_rdata)

,.rf_nalb_lsp_enq_unoord_error (rf_nalb_lsp_enq_unoord_error)

,.func_nalb_qed_re    (func_nalb_qed_re)
,.func_nalb_qed_raddr (func_nalb_qed_raddr)
,.func_nalb_qed_waddr (func_nalb_qed_waddr)
,.func_nalb_qed_we    (func_nalb_qed_we)
,.func_nalb_qed_wdata (func_nalb_qed_wdata)
,.func_nalb_qed_rdata (func_nalb_qed_rdata)

,.pf_nalb_qed_re      (pf_nalb_qed_re)
,.pf_nalb_qed_raddr (pf_nalb_qed_raddr)
,.pf_nalb_qed_waddr (pf_nalb_qed_waddr)
,.pf_nalb_qed_we    (pf_nalb_qed_we)
,.pf_nalb_qed_wdata (pf_nalb_qed_wdata)
,.pf_nalb_qed_rdata (pf_nalb_qed_rdata)

,.rf_nalb_qed_rclk (rf_nalb_qed_rclk)
,.rf_nalb_qed_rclk_rst_n (rf_nalb_qed_rclk_rst_n)
,.rf_nalb_qed_re    (rf_nalb_qed_re)
,.rf_nalb_qed_raddr (rf_nalb_qed_raddr)
,.rf_nalb_qed_waddr (rf_nalb_qed_waddr)
,.rf_nalb_qed_wclk (rf_nalb_qed_wclk)
,.rf_nalb_qed_wclk_rst_n (rf_nalb_qed_wclk_rst_n)
,.rf_nalb_qed_we    (rf_nalb_qed_we)
,.rf_nalb_qed_wdata (rf_nalb_qed_wdata)
,.rf_nalb_qed_rdata (rf_nalb_qed_rdata)

,.rf_nalb_qed_error (rf_nalb_qed_error)

,.func_nalb_replay_cnt_re    (func_nalb_replay_cnt_re)
,.func_nalb_replay_cnt_raddr (func_nalb_replay_cnt_raddr)
,.func_nalb_replay_cnt_waddr (func_nalb_replay_cnt_waddr)
,.func_nalb_replay_cnt_we    (func_nalb_replay_cnt_we)
,.func_nalb_replay_cnt_wdata (func_nalb_replay_cnt_wdata)
,.func_nalb_replay_cnt_rdata (func_nalb_replay_cnt_rdata)

,.pf_nalb_replay_cnt_re      (pf_nalb_replay_cnt_re)
,.pf_nalb_replay_cnt_raddr (pf_nalb_replay_cnt_raddr)
,.pf_nalb_replay_cnt_waddr (pf_nalb_replay_cnt_waddr)
,.pf_nalb_replay_cnt_we    (pf_nalb_replay_cnt_we)
,.pf_nalb_replay_cnt_wdata (pf_nalb_replay_cnt_wdata)
,.pf_nalb_replay_cnt_rdata (pf_nalb_replay_cnt_rdata)

,.rf_nalb_replay_cnt_rclk (rf_nalb_replay_cnt_rclk)
,.rf_nalb_replay_cnt_rclk_rst_n (rf_nalb_replay_cnt_rclk_rst_n)
,.rf_nalb_replay_cnt_re    (rf_nalb_replay_cnt_re)
,.rf_nalb_replay_cnt_raddr (rf_nalb_replay_cnt_raddr)
,.rf_nalb_replay_cnt_waddr (rf_nalb_replay_cnt_waddr)
,.rf_nalb_replay_cnt_wclk (rf_nalb_replay_cnt_wclk)
,.rf_nalb_replay_cnt_wclk_rst_n (rf_nalb_replay_cnt_wclk_rst_n)
,.rf_nalb_replay_cnt_we    (rf_nalb_replay_cnt_we)
,.rf_nalb_replay_cnt_wdata (rf_nalb_replay_cnt_wdata)
,.rf_nalb_replay_cnt_rdata (rf_nalb_replay_cnt_rdata)

,.rf_nalb_replay_cnt_error (rf_nalb_replay_cnt_error)

,.func_nalb_replay_hp_re    (func_nalb_replay_hp_re)
,.func_nalb_replay_hp_raddr (func_nalb_replay_hp_raddr)
,.func_nalb_replay_hp_waddr (func_nalb_replay_hp_waddr)
,.func_nalb_replay_hp_we    (func_nalb_replay_hp_we)
,.func_nalb_replay_hp_wdata (func_nalb_replay_hp_wdata)
,.func_nalb_replay_hp_rdata (func_nalb_replay_hp_rdata)

,.pf_nalb_replay_hp_re      (pf_nalb_replay_hp_re)
,.pf_nalb_replay_hp_raddr (pf_nalb_replay_hp_raddr)
,.pf_nalb_replay_hp_waddr (pf_nalb_replay_hp_waddr)
,.pf_nalb_replay_hp_we    (pf_nalb_replay_hp_we)
,.pf_nalb_replay_hp_wdata (pf_nalb_replay_hp_wdata)
,.pf_nalb_replay_hp_rdata (pf_nalb_replay_hp_rdata)

,.rf_nalb_replay_hp_rclk (rf_nalb_replay_hp_rclk)
,.rf_nalb_replay_hp_rclk_rst_n (rf_nalb_replay_hp_rclk_rst_n)
,.rf_nalb_replay_hp_re    (rf_nalb_replay_hp_re)
,.rf_nalb_replay_hp_raddr (rf_nalb_replay_hp_raddr)
,.rf_nalb_replay_hp_waddr (rf_nalb_replay_hp_waddr)
,.rf_nalb_replay_hp_wclk (rf_nalb_replay_hp_wclk)
,.rf_nalb_replay_hp_wclk_rst_n (rf_nalb_replay_hp_wclk_rst_n)
,.rf_nalb_replay_hp_we    (rf_nalb_replay_hp_we)
,.rf_nalb_replay_hp_wdata (rf_nalb_replay_hp_wdata)
,.rf_nalb_replay_hp_rdata (rf_nalb_replay_hp_rdata)

,.rf_nalb_replay_hp_error (rf_nalb_replay_hp_error)

,.func_nalb_replay_tp_re    (func_nalb_replay_tp_re)
,.func_nalb_replay_tp_raddr (func_nalb_replay_tp_raddr)
,.func_nalb_replay_tp_waddr (func_nalb_replay_tp_waddr)
,.func_nalb_replay_tp_we    (func_nalb_replay_tp_we)
,.func_nalb_replay_tp_wdata (func_nalb_replay_tp_wdata)
,.func_nalb_replay_tp_rdata (func_nalb_replay_tp_rdata)

,.pf_nalb_replay_tp_re      (pf_nalb_replay_tp_re)
,.pf_nalb_replay_tp_raddr (pf_nalb_replay_tp_raddr)
,.pf_nalb_replay_tp_waddr (pf_nalb_replay_tp_waddr)
,.pf_nalb_replay_tp_we    (pf_nalb_replay_tp_we)
,.pf_nalb_replay_tp_wdata (pf_nalb_replay_tp_wdata)
,.pf_nalb_replay_tp_rdata (pf_nalb_replay_tp_rdata)

,.rf_nalb_replay_tp_rclk (rf_nalb_replay_tp_rclk)
,.rf_nalb_replay_tp_rclk_rst_n (rf_nalb_replay_tp_rclk_rst_n)
,.rf_nalb_replay_tp_re    (rf_nalb_replay_tp_re)
,.rf_nalb_replay_tp_raddr (rf_nalb_replay_tp_raddr)
,.rf_nalb_replay_tp_waddr (rf_nalb_replay_tp_waddr)
,.rf_nalb_replay_tp_wclk (rf_nalb_replay_tp_wclk)
,.rf_nalb_replay_tp_wclk_rst_n (rf_nalb_replay_tp_wclk_rst_n)
,.rf_nalb_replay_tp_we    (rf_nalb_replay_tp_we)
,.rf_nalb_replay_tp_wdata (rf_nalb_replay_tp_wdata)
,.rf_nalb_replay_tp_rdata (rf_nalb_replay_tp_rdata)

,.rf_nalb_replay_tp_error (rf_nalb_replay_tp_error)

,.func_nalb_rofrag_cnt_re    (func_nalb_rofrag_cnt_re)
,.func_nalb_rofrag_cnt_raddr (func_nalb_rofrag_cnt_raddr)
,.func_nalb_rofrag_cnt_waddr (func_nalb_rofrag_cnt_waddr)
,.func_nalb_rofrag_cnt_we    (func_nalb_rofrag_cnt_we)
,.func_nalb_rofrag_cnt_wdata (func_nalb_rofrag_cnt_wdata)
,.func_nalb_rofrag_cnt_rdata (func_nalb_rofrag_cnt_rdata)

,.pf_nalb_rofrag_cnt_re      (pf_nalb_rofrag_cnt_re)
,.pf_nalb_rofrag_cnt_raddr (pf_nalb_rofrag_cnt_raddr)
,.pf_nalb_rofrag_cnt_waddr (pf_nalb_rofrag_cnt_waddr)
,.pf_nalb_rofrag_cnt_we    (pf_nalb_rofrag_cnt_we)
,.pf_nalb_rofrag_cnt_wdata (pf_nalb_rofrag_cnt_wdata)
,.pf_nalb_rofrag_cnt_rdata (pf_nalb_rofrag_cnt_rdata)

,.rf_nalb_rofrag_cnt_rclk (rf_nalb_rofrag_cnt_rclk)
,.rf_nalb_rofrag_cnt_rclk_rst_n (rf_nalb_rofrag_cnt_rclk_rst_n)
,.rf_nalb_rofrag_cnt_re    (rf_nalb_rofrag_cnt_re)
,.rf_nalb_rofrag_cnt_raddr (rf_nalb_rofrag_cnt_raddr)
,.rf_nalb_rofrag_cnt_waddr (rf_nalb_rofrag_cnt_waddr)
,.rf_nalb_rofrag_cnt_wclk (rf_nalb_rofrag_cnt_wclk)
,.rf_nalb_rofrag_cnt_wclk_rst_n (rf_nalb_rofrag_cnt_wclk_rst_n)
,.rf_nalb_rofrag_cnt_we    (rf_nalb_rofrag_cnt_we)
,.rf_nalb_rofrag_cnt_wdata (rf_nalb_rofrag_cnt_wdata)
,.rf_nalb_rofrag_cnt_rdata (rf_nalb_rofrag_cnt_rdata)

,.rf_nalb_rofrag_cnt_error (rf_nalb_rofrag_cnt_error)

,.func_nalb_rofrag_hp_re    (func_nalb_rofrag_hp_re)
,.func_nalb_rofrag_hp_raddr (func_nalb_rofrag_hp_raddr)
,.func_nalb_rofrag_hp_waddr (func_nalb_rofrag_hp_waddr)
,.func_nalb_rofrag_hp_we    (func_nalb_rofrag_hp_we)
,.func_nalb_rofrag_hp_wdata (func_nalb_rofrag_hp_wdata)
,.func_nalb_rofrag_hp_rdata (func_nalb_rofrag_hp_rdata)

,.pf_nalb_rofrag_hp_re      (pf_nalb_rofrag_hp_re)
,.pf_nalb_rofrag_hp_raddr (pf_nalb_rofrag_hp_raddr)
,.pf_nalb_rofrag_hp_waddr (pf_nalb_rofrag_hp_waddr)
,.pf_nalb_rofrag_hp_we    (pf_nalb_rofrag_hp_we)
,.pf_nalb_rofrag_hp_wdata (pf_nalb_rofrag_hp_wdata)
,.pf_nalb_rofrag_hp_rdata (pf_nalb_rofrag_hp_rdata)

,.rf_nalb_rofrag_hp_rclk (rf_nalb_rofrag_hp_rclk)
,.rf_nalb_rofrag_hp_rclk_rst_n (rf_nalb_rofrag_hp_rclk_rst_n)
,.rf_nalb_rofrag_hp_re    (rf_nalb_rofrag_hp_re)
,.rf_nalb_rofrag_hp_raddr (rf_nalb_rofrag_hp_raddr)
,.rf_nalb_rofrag_hp_waddr (rf_nalb_rofrag_hp_waddr)
,.rf_nalb_rofrag_hp_wclk (rf_nalb_rofrag_hp_wclk)
,.rf_nalb_rofrag_hp_wclk_rst_n (rf_nalb_rofrag_hp_wclk_rst_n)
,.rf_nalb_rofrag_hp_we    (rf_nalb_rofrag_hp_we)
,.rf_nalb_rofrag_hp_wdata (rf_nalb_rofrag_hp_wdata)
,.rf_nalb_rofrag_hp_rdata (rf_nalb_rofrag_hp_rdata)

,.rf_nalb_rofrag_hp_error (rf_nalb_rofrag_hp_error)

,.func_nalb_rofrag_tp_re    (func_nalb_rofrag_tp_re)
,.func_nalb_rofrag_tp_raddr (func_nalb_rofrag_tp_raddr)
,.func_nalb_rofrag_tp_waddr (func_nalb_rofrag_tp_waddr)
,.func_nalb_rofrag_tp_we    (func_nalb_rofrag_tp_we)
,.func_nalb_rofrag_tp_wdata (func_nalb_rofrag_tp_wdata)
,.func_nalb_rofrag_tp_rdata (func_nalb_rofrag_tp_rdata)

,.pf_nalb_rofrag_tp_re      (pf_nalb_rofrag_tp_re)
,.pf_nalb_rofrag_tp_raddr (pf_nalb_rofrag_tp_raddr)
,.pf_nalb_rofrag_tp_waddr (pf_nalb_rofrag_tp_waddr)
,.pf_nalb_rofrag_tp_we    (pf_nalb_rofrag_tp_we)
,.pf_nalb_rofrag_tp_wdata (pf_nalb_rofrag_tp_wdata)
,.pf_nalb_rofrag_tp_rdata (pf_nalb_rofrag_tp_rdata)

,.rf_nalb_rofrag_tp_rclk (rf_nalb_rofrag_tp_rclk)
,.rf_nalb_rofrag_tp_rclk_rst_n (rf_nalb_rofrag_tp_rclk_rst_n)
,.rf_nalb_rofrag_tp_re    (rf_nalb_rofrag_tp_re)
,.rf_nalb_rofrag_tp_raddr (rf_nalb_rofrag_tp_raddr)
,.rf_nalb_rofrag_tp_waddr (rf_nalb_rofrag_tp_waddr)
,.rf_nalb_rofrag_tp_wclk (rf_nalb_rofrag_tp_wclk)
,.rf_nalb_rofrag_tp_wclk_rst_n (rf_nalb_rofrag_tp_wclk_rst_n)
,.rf_nalb_rofrag_tp_we    (rf_nalb_rofrag_tp_we)
,.rf_nalb_rofrag_tp_wdata (rf_nalb_rofrag_tp_wdata)
,.rf_nalb_rofrag_tp_rdata (rf_nalb_rofrag_tp_rdata)

,.rf_nalb_rofrag_tp_error (rf_nalb_rofrag_tp_error)

,.func_nalb_tp_re    (func_nalb_tp_re)
,.func_nalb_tp_raddr (func_nalb_tp_raddr)
,.func_nalb_tp_waddr (func_nalb_tp_waddr)
,.func_nalb_tp_we    (func_nalb_tp_we)
,.func_nalb_tp_wdata (func_nalb_tp_wdata)
,.func_nalb_tp_rdata (func_nalb_tp_rdata)

,.pf_nalb_tp_re      (pf_nalb_tp_re)
,.pf_nalb_tp_raddr (pf_nalb_tp_raddr)
,.pf_nalb_tp_waddr (pf_nalb_tp_waddr)
,.pf_nalb_tp_we    (pf_nalb_tp_we)
,.pf_nalb_tp_wdata (pf_nalb_tp_wdata)
,.pf_nalb_tp_rdata (pf_nalb_tp_rdata)

,.rf_nalb_tp_rclk (rf_nalb_tp_rclk)
,.rf_nalb_tp_rclk_rst_n (rf_nalb_tp_rclk_rst_n)
,.rf_nalb_tp_re    (rf_nalb_tp_re)
,.rf_nalb_tp_raddr (rf_nalb_tp_raddr)
,.rf_nalb_tp_waddr (rf_nalb_tp_waddr)
,.rf_nalb_tp_wclk (rf_nalb_tp_wclk)
,.rf_nalb_tp_wclk_rst_n (rf_nalb_tp_wclk_rst_n)
,.rf_nalb_tp_we    (rf_nalb_tp_we)
,.rf_nalb_tp_wdata (rf_nalb_tp_wdata)
,.rf_nalb_tp_rdata (rf_nalb_tp_rdata)

,.rf_nalb_tp_error (rf_nalb_tp_error)

,.func_rop_nalb_enq_ro_re    (func_rop_nalb_enq_ro_re)
,.func_rop_nalb_enq_ro_raddr (func_rop_nalb_enq_ro_raddr)
,.func_rop_nalb_enq_ro_waddr (func_rop_nalb_enq_ro_waddr)
,.func_rop_nalb_enq_ro_we    (func_rop_nalb_enq_ro_we)
,.func_rop_nalb_enq_ro_wdata (func_rop_nalb_enq_ro_wdata)
,.func_rop_nalb_enq_ro_rdata (func_rop_nalb_enq_ro_rdata)

,.pf_rop_nalb_enq_ro_re      (pf_rop_nalb_enq_ro_re)
,.pf_rop_nalb_enq_ro_raddr (pf_rop_nalb_enq_ro_raddr)
,.pf_rop_nalb_enq_ro_waddr (pf_rop_nalb_enq_ro_waddr)
,.pf_rop_nalb_enq_ro_we    (pf_rop_nalb_enq_ro_we)
,.pf_rop_nalb_enq_ro_wdata (pf_rop_nalb_enq_ro_wdata)
,.pf_rop_nalb_enq_ro_rdata (pf_rop_nalb_enq_ro_rdata)

,.rf_rop_nalb_enq_ro_rclk (rf_rop_nalb_enq_ro_rclk)
,.rf_rop_nalb_enq_ro_rclk_rst_n (rf_rop_nalb_enq_ro_rclk_rst_n)
,.rf_rop_nalb_enq_ro_re    (rf_rop_nalb_enq_ro_re)
,.rf_rop_nalb_enq_ro_raddr (rf_rop_nalb_enq_ro_raddr)
,.rf_rop_nalb_enq_ro_waddr (rf_rop_nalb_enq_ro_waddr)
,.rf_rop_nalb_enq_ro_wclk (rf_rop_nalb_enq_ro_wclk)
,.rf_rop_nalb_enq_ro_wclk_rst_n (rf_rop_nalb_enq_ro_wclk_rst_n)
,.rf_rop_nalb_enq_ro_we    (rf_rop_nalb_enq_ro_we)
,.rf_rop_nalb_enq_ro_wdata (rf_rop_nalb_enq_ro_wdata)
,.rf_rop_nalb_enq_ro_rdata (rf_rop_nalb_enq_ro_rdata)

,.rf_rop_nalb_enq_ro_error (rf_rop_nalb_enq_ro_error)

,.func_rop_nalb_enq_unoord_re    (func_rop_nalb_enq_unoord_re)
,.func_rop_nalb_enq_unoord_raddr (func_rop_nalb_enq_unoord_raddr)
,.func_rop_nalb_enq_unoord_waddr (func_rop_nalb_enq_unoord_waddr)
,.func_rop_nalb_enq_unoord_we    (func_rop_nalb_enq_unoord_we)
,.func_rop_nalb_enq_unoord_wdata (func_rop_nalb_enq_unoord_wdata)
,.func_rop_nalb_enq_unoord_rdata (func_rop_nalb_enq_unoord_rdata)

,.pf_rop_nalb_enq_unoord_re      (pf_rop_nalb_enq_unoord_re)
,.pf_rop_nalb_enq_unoord_raddr (pf_rop_nalb_enq_unoord_raddr)
,.pf_rop_nalb_enq_unoord_waddr (pf_rop_nalb_enq_unoord_waddr)
,.pf_rop_nalb_enq_unoord_we    (pf_rop_nalb_enq_unoord_we)
,.pf_rop_nalb_enq_unoord_wdata (pf_rop_nalb_enq_unoord_wdata)
,.pf_rop_nalb_enq_unoord_rdata (pf_rop_nalb_enq_unoord_rdata)

,.rf_rop_nalb_enq_unoord_rclk (rf_rop_nalb_enq_unoord_rclk)
,.rf_rop_nalb_enq_unoord_rclk_rst_n (rf_rop_nalb_enq_unoord_rclk_rst_n)
,.rf_rop_nalb_enq_unoord_re    (rf_rop_nalb_enq_unoord_re)
,.rf_rop_nalb_enq_unoord_raddr (rf_rop_nalb_enq_unoord_raddr)
,.rf_rop_nalb_enq_unoord_waddr (rf_rop_nalb_enq_unoord_waddr)
,.rf_rop_nalb_enq_unoord_wclk (rf_rop_nalb_enq_unoord_wclk)
,.rf_rop_nalb_enq_unoord_wclk_rst_n (rf_rop_nalb_enq_unoord_wclk_rst_n)
,.rf_rop_nalb_enq_unoord_we    (rf_rop_nalb_enq_unoord_we)
,.rf_rop_nalb_enq_unoord_wdata (rf_rop_nalb_enq_unoord_wdata)
,.rf_rop_nalb_enq_unoord_rdata (rf_rop_nalb_enq_unoord_rdata)

,.rf_rop_nalb_enq_unoord_error (rf_rop_nalb_enq_unoord_error)

,.func_rx_sync_lsp_nalb_sch_atq_re    (func_rx_sync_lsp_nalb_sch_atq_re)
,.func_rx_sync_lsp_nalb_sch_atq_raddr (func_rx_sync_lsp_nalb_sch_atq_raddr)
,.func_rx_sync_lsp_nalb_sch_atq_waddr (func_rx_sync_lsp_nalb_sch_atq_waddr)
,.func_rx_sync_lsp_nalb_sch_atq_we    (func_rx_sync_lsp_nalb_sch_atq_we)
,.func_rx_sync_lsp_nalb_sch_atq_wdata (func_rx_sync_lsp_nalb_sch_atq_wdata)
,.func_rx_sync_lsp_nalb_sch_atq_rdata (func_rx_sync_lsp_nalb_sch_atq_rdata)

,.pf_rx_sync_lsp_nalb_sch_atq_re      (pf_rx_sync_lsp_nalb_sch_atq_re)
,.pf_rx_sync_lsp_nalb_sch_atq_raddr (pf_rx_sync_lsp_nalb_sch_atq_raddr)
,.pf_rx_sync_lsp_nalb_sch_atq_waddr (pf_rx_sync_lsp_nalb_sch_atq_waddr)
,.pf_rx_sync_lsp_nalb_sch_atq_we    (pf_rx_sync_lsp_nalb_sch_atq_we)
,.pf_rx_sync_lsp_nalb_sch_atq_wdata (pf_rx_sync_lsp_nalb_sch_atq_wdata)
,.pf_rx_sync_lsp_nalb_sch_atq_rdata (pf_rx_sync_lsp_nalb_sch_atq_rdata)

,.rf_rx_sync_lsp_nalb_sch_atq_rclk (rf_rx_sync_lsp_nalb_sch_atq_rclk)
,.rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n (rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n)
,.rf_rx_sync_lsp_nalb_sch_atq_re    (rf_rx_sync_lsp_nalb_sch_atq_re)
,.rf_rx_sync_lsp_nalb_sch_atq_raddr (rf_rx_sync_lsp_nalb_sch_atq_raddr)
,.rf_rx_sync_lsp_nalb_sch_atq_waddr (rf_rx_sync_lsp_nalb_sch_atq_waddr)
,.rf_rx_sync_lsp_nalb_sch_atq_wclk (rf_rx_sync_lsp_nalb_sch_atq_wclk)
,.rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n (rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n)
,.rf_rx_sync_lsp_nalb_sch_atq_we    (rf_rx_sync_lsp_nalb_sch_atq_we)
,.rf_rx_sync_lsp_nalb_sch_atq_wdata (rf_rx_sync_lsp_nalb_sch_atq_wdata)
,.rf_rx_sync_lsp_nalb_sch_atq_rdata (rf_rx_sync_lsp_nalb_sch_atq_rdata)

,.rf_rx_sync_lsp_nalb_sch_atq_error (rf_rx_sync_lsp_nalb_sch_atq_error)

,.func_rx_sync_lsp_nalb_sch_rorply_re    (func_rx_sync_lsp_nalb_sch_rorply_re)
,.func_rx_sync_lsp_nalb_sch_rorply_raddr (func_rx_sync_lsp_nalb_sch_rorply_raddr)
,.func_rx_sync_lsp_nalb_sch_rorply_waddr (func_rx_sync_lsp_nalb_sch_rorply_waddr)
,.func_rx_sync_lsp_nalb_sch_rorply_we    (func_rx_sync_lsp_nalb_sch_rorply_we)
,.func_rx_sync_lsp_nalb_sch_rorply_wdata (func_rx_sync_lsp_nalb_sch_rorply_wdata)
,.func_rx_sync_lsp_nalb_sch_rorply_rdata (func_rx_sync_lsp_nalb_sch_rorply_rdata)

,.pf_rx_sync_lsp_nalb_sch_rorply_re      (pf_rx_sync_lsp_nalb_sch_rorply_re)
,.pf_rx_sync_lsp_nalb_sch_rorply_raddr (pf_rx_sync_lsp_nalb_sch_rorply_raddr)
,.pf_rx_sync_lsp_nalb_sch_rorply_waddr (pf_rx_sync_lsp_nalb_sch_rorply_waddr)
,.pf_rx_sync_lsp_nalb_sch_rorply_we    (pf_rx_sync_lsp_nalb_sch_rorply_we)
,.pf_rx_sync_lsp_nalb_sch_rorply_wdata (pf_rx_sync_lsp_nalb_sch_rorply_wdata)
,.pf_rx_sync_lsp_nalb_sch_rorply_rdata (pf_rx_sync_lsp_nalb_sch_rorply_rdata)

,.rf_rx_sync_lsp_nalb_sch_rorply_rclk (rf_rx_sync_lsp_nalb_sch_rorply_rclk)
,.rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n (rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n)
,.rf_rx_sync_lsp_nalb_sch_rorply_re    (rf_rx_sync_lsp_nalb_sch_rorply_re)
,.rf_rx_sync_lsp_nalb_sch_rorply_raddr (rf_rx_sync_lsp_nalb_sch_rorply_raddr)
,.rf_rx_sync_lsp_nalb_sch_rorply_waddr (rf_rx_sync_lsp_nalb_sch_rorply_waddr)
,.rf_rx_sync_lsp_nalb_sch_rorply_wclk (rf_rx_sync_lsp_nalb_sch_rorply_wclk)
,.rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n (rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n)
,.rf_rx_sync_lsp_nalb_sch_rorply_we    (rf_rx_sync_lsp_nalb_sch_rorply_we)
,.rf_rx_sync_lsp_nalb_sch_rorply_wdata (rf_rx_sync_lsp_nalb_sch_rorply_wdata)
,.rf_rx_sync_lsp_nalb_sch_rorply_rdata (rf_rx_sync_lsp_nalb_sch_rorply_rdata)

,.rf_rx_sync_lsp_nalb_sch_rorply_error (rf_rx_sync_lsp_nalb_sch_rorply_error)

,.func_rx_sync_lsp_nalb_sch_unoord_re    (func_rx_sync_lsp_nalb_sch_unoord_re)
,.func_rx_sync_lsp_nalb_sch_unoord_raddr (func_rx_sync_lsp_nalb_sch_unoord_raddr)
,.func_rx_sync_lsp_nalb_sch_unoord_waddr (func_rx_sync_lsp_nalb_sch_unoord_waddr)
,.func_rx_sync_lsp_nalb_sch_unoord_we    (func_rx_sync_lsp_nalb_sch_unoord_we)
,.func_rx_sync_lsp_nalb_sch_unoord_wdata (func_rx_sync_lsp_nalb_sch_unoord_wdata)
,.func_rx_sync_lsp_nalb_sch_unoord_rdata (func_rx_sync_lsp_nalb_sch_unoord_rdata)

,.pf_rx_sync_lsp_nalb_sch_unoord_re      (pf_rx_sync_lsp_nalb_sch_unoord_re)
,.pf_rx_sync_lsp_nalb_sch_unoord_raddr (pf_rx_sync_lsp_nalb_sch_unoord_raddr)
,.pf_rx_sync_lsp_nalb_sch_unoord_waddr (pf_rx_sync_lsp_nalb_sch_unoord_waddr)
,.pf_rx_sync_lsp_nalb_sch_unoord_we    (pf_rx_sync_lsp_nalb_sch_unoord_we)
,.pf_rx_sync_lsp_nalb_sch_unoord_wdata (pf_rx_sync_lsp_nalb_sch_unoord_wdata)
,.pf_rx_sync_lsp_nalb_sch_unoord_rdata (pf_rx_sync_lsp_nalb_sch_unoord_rdata)

,.rf_rx_sync_lsp_nalb_sch_unoord_rclk (rf_rx_sync_lsp_nalb_sch_unoord_rclk)
,.rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n (rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n)
,.rf_rx_sync_lsp_nalb_sch_unoord_re    (rf_rx_sync_lsp_nalb_sch_unoord_re)
,.rf_rx_sync_lsp_nalb_sch_unoord_raddr (rf_rx_sync_lsp_nalb_sch_unoord_raddr)
,.rf_rx_sync_lsp_nalb_sch_unoord_waddr (rf_rx_sync_lsp_nalb_sch_unoord_waddr)
,.rf_rx_sync_lsp_nalb_sch_unoord_wclk (rf_rx_sync_lsp_nalb_sch_unoord_wclk)
,.rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n (rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n)
,.rf_rx_sync_lsp_nalb_sch_unoord_we    (rf_rx_sync_lsp_nalb_sch_unoord_we)
,.rf_rx_sync_lsp_nalb_sch_unoord_wdata (rf_rx_sync_lsp_nalb_sch_unoord_wdata)
,.rf_rx_sync_lsp_nalb_sch_unoord_rdata (rf_rx_sync_lsp_nalb_sch_unoord_rdata)

,.rf_rx_sync_lsp_nalb_sch_unoord_error (rf_rx_sync_lsp_nalb_sch_unoord_error)

,.func_rx_sync_rop_nalb_enq_re    (func_rx_sync_rop_nalb_enq_re)
,.func_rx_sync_rop_nalb_enq_raddr (func_rx_sync_rop_nalb_enq_raddr)
,.func_rx_sync_rop_nalb_enq_waddr (func_rx_sync_rop_nalb_enq_waddr)
,.func_rx_sync_rop_nalb_enq_we    (func_rx_sync_rop_nalb_enq_we)
,.func_rx_sync_rop_nalb_enq_wdata (func_rx_sync_rop_nalb_enq_wdata)
,.func_rx_sync_rop_nalb_enq_rdata (func_rx_sync_rop_nalb_enq_rdata)

,.pf_rx_sync_rop_nalb_enq_re      (pf_rx_sync_rop_nalb_enq_re)
,.pf_rx_sync_rop_nalb_enq_raddr (pf_rx_sync_rop_nalb_enq_raddr)
,.pf_rx_sync_rop_nalb_enq_waddr (pf_rx_sync_rop_nalb_enq_waddr)
,.pf_rx_sync_rop_nalb_enq_we    (pf_rx_sync_rop_nalb_enq_we)
,.pf_rx_sync_rop_nalb_enq_wdata (pf_rx_sync_rop_nalb_enq_wdata)
,.pf_rx_sync_rop_nalb_enq_rdata (pf_rx_sync_rop_nalb_enq_rdata)

,.rf_rx_sync_rop_nalb_enq_rclk (rf_rx_sync_rop_nalb_enq_rclk)
,.rf_rx_sync_rop_nalb_enq_rclk_rst_n (rf_rx_sync_rop_nalb_enq_rclk_rst_n)
,.rf_rx_sync_rop_nalb_enq_re    (rf_rx_sync_rop_nalb_enq_re)
,.rf_rx_sync_rop_nalb_enq_raddr (rf_rx_sync_rop_nalb_enq_raddr)
,.rf_rx_sync_rop_nalb_enq_waddr (rf_rx_sync_rop_nalb_enq_waddr)
,.rf_rx_sync_rop_nalb_enq_wclk (rf_rx_sync_rop_nalb_enq_wclk)
,.rf_rx_sync_rop_nalb_enq_wclk_rst_n (rf_rx_sync_rop_nalb_enq_wclk_rst_n)
,.rf_rx_sync_rop_nalb_enq_we    (rf_rx_sync_rop_nalb_enq_we)
,.rf_rx_sync_rop_nalb_enq_wdata (rf_rx_sync_rop_nalb_enq_wdata)
,.rf_rx_sync_rop_nalb_enq_rdata (rf_rx_sync_rop_nalb_enq_rdata)

,.rf_rx_sync_rop_nalb_enq_error (rf_rx_sync_rop_nalb_enq_error)

,.func_nalb_nxthp_re    (func_nalb_nxthp_re)
,.func_nalb_nxthp_addr  (func_nalb_nxthp_addr)
,.func_nalb_nxthp_we    (func_nalb_nxthp_we)
,.func_nalb_nxthp_wdata (func_nalb_nxthp_wdata)
,.func_nalb_nxthp_rdata (func_nalb_nxthp_rdata)

,.pf_nalb_nxthp_re      (pf_nalb_nxthp_re)
,.pf_nalb_nxthp_addr    (pf_nalb_nxthp_addr)
,.pf_nalb_nxthp_we      (pf_nalb_nxthp_we)
,.pf_nalb_nxthp_wdata   (pf_nalb_nxthp_wdata)
,.pf_nalb_nxthp_rdata   (pf_nalb_nxthp_rdata)

,.sr_nalb_nxthp_clk (sr_nalb_nxthp_clk)
,.sr_nalb_nxthp_clk_rst_n (sr_nalb_nxthp_clk_rst_n)
,.sr_nalb_nxthp_re    (sr_nalb_nxthp_re)
,.sr_nalb_nxthp_addr  (sr_nalb_nxthp_addr)
,.sr_nalb_nxthp_we    (sr_nalb_nxthp_we)
,.sr_nalb_nxthp_wdata (sr_nalb_nxthp_wdata)
,.sr_nalb_nxthp_rdata (sr_nalb_nxthp_rdata)

,.sr_nalb_nxthp_error (sr_nalb_nxthp_error)

);
// END HQM_RAM_ACCESS

//---------------------------------------------------------------------------------------------------------
// common core - Interface & clock control

logic rx_sync_rop_nalb_enq_enable ;
logic rx_sync_rop_nalb_enq_idle ;
logic rx_sync_lsp_nalb_sch_unoord_enable ;
logic rx_sync_lsp_nalb_sch_unoord_idle ;
logic rx_sync_lsp_nalb_sch_rorply_enable ;
logic rx_sync_lsp_nalb_sch_rorply_idle ;
logic rx_sync_lsp_nalb_sch_atq_enable ;
logic rx_sync_lsp_nalb_sch_atq_idle ;
logic tx_sync_nalb_lsp_enq_lb_idle ;
logic tx_sync_nalb_lsp_enq_rorply_idle ;
logic tx_sync_nalb_qed_idle ;
logic unit_idle_local ;
hqm_AW_module_clock_control # (
  .REQS ( 5 )
) i_hqm_AW_module_clock_control (
    .hqm_inp_gated_clk                    ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                  ( hqm_inp_gated_rst_n )
  , .hqm_gated_clk                        ( hqm_gated_clk )
  , .hqm_gated_rst_n                      ( hqm_gated_rst_n )
  , .cfg_co_dly                           ( { 2'd0 , hqm_nalb_target_cfg_patch_control_reg_f [ 13 : 0 ] } ) 
  , .cfg_co_disable                       ( hqm_nalb_target_cfg_patch_control_reg_f [ 31 ] ) 
  , .hqm_proc_clk_en                      ( hqm_proc_clk_en )
  , .unit_idle_local                      ( unit_idle_local )
  , .unit_idle                            ( nalb_unit_idle )
  , .inp_fifo_empty                       ( { cfg_rx_idle
                                            , rx_sync_rop_nalb_enq_idle
                                            , rx_sync_lsp_nalb_sch_unoord_idle
                                            , rx_sync_lsp_nalb_sch_rorply_idle
                                            , rx_sync_lsp_nalb_sch_atq_idle
                                            }
                                          )
  , .inp_fifo_en                          ( { cfg_rx_enable
                                            , rx_sync_rop_nalb_enq_enable
                                            , rx_sync_lsp_nalb_sch_unoord_enable
                                            , rx_sync_lsp_nalb_sch_rorply_enable
                                            , rx_sync_lsp_nalb_sch_atq_enable
                                            }
                                          )

  , .cfg_idle                             ( cfg_idle )
  , .int_idle                             ( int_idle )

  , .rst_prep                             ( rst_prep )
  , .reset_active                         ( hqm_gated_rst_n_active )
) ;

assign nalb_qed_force_clockon = ( fifo_nalb_qed_push | ~ fifo_nalb_qed_empty ) ;

// double buffer for rop_nalb interface to enqeue new/replay HCW
rop_nalb_enq_t wire_rop_nalb_enq_data ;
assign wire_rop_nalb_enq_data.cmd = rop_nalb_enq_data.cmd ;
assign wire_rop_nalb_enq_data.cq = { ~ ( rop_nalb_enq_data.cmd [ 2 ] ^ rop_nalb_enq_data.cmd [ 1 ] ^ rop_nalb_enq_data.cmd [ 0 ] ^ rop_nalb_enq_data.cq [ 6 ] ^ rop_nalb_enq_data.cq [ 5 ] ^ rop_nalb_enq_data.cq [ 4 ] ^ rop_nalb_enq_data.cq [ 3 ] ^ rop_nalb_enq_data.cq [ 2 ] ^ rop_nalb_enq_data.cq [ 1 ] ^ rop_nalb_enq_data.cq [ 0 ]  )
                                   , rop_nalb_enq_data.cq [ 6 : 0 ]
                                   } ;
assign wire_rop_nalb_enq_data.flid = rop_nalb_enq_data.flid ;
assign wire_rop_nalb_enq_data.flid_parity = rop_nalb_enq_data.flid_parity ;
assign wire_rop_nalb_enq_data.hist_list_info = rop_nalb_enq_data.hist_list_info ;
assign wire_rop_nalb_enq_data.frag_list_info = rop_nalb_enq_data.frag_list_info ;

hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_rop_nalb_enq_data ) )
  , .SEED                               ( 32'h0f )

  ) i_rx_sync_rop_nalb_enq (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_rop_nalb_enq_status_pnc )
  , .enable                             ( rx_sync_rop_nalb_enq_enable )
  , .idle                               ( rx_sync_rop_nalb_enq_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( rop_nalb_enq_v )
  , .in_ready                           ( rop_nalb_enq_ready )
  , .in_data                            ( wire_rop_nalb_enq_data )
  , .out_valid                          ( rx_sync_rop_nalb_enq_v )
  , .out_ready                          ( rx_sync_rop_nalb_enq_ready )
  , .out_data                           ( rx_sync_rop_nalb_enq_data )
  , .mem_we                             ( func_rx_sync_rop_nalb_enq_we )
  , .mem_waddr                          ( func_rx_sync_rop_nalb_enq_waddr )
  , .mem_wdata                          ( func_rx_sync_rop_nalb_enq_wdata )
  , .mem_re                             ( func_rx_sync_rop_nalb_enq_re )
  , .mem_raddr                          ( func_rx_sync_rop_nalb_enq_raddr )
  , .mem_rdata                          ( func_rx_sync_rop_nalb_enq_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [0] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

// double buffer for lsp_nalb interface to scheudle nalb HCW
hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_lsp_nalb_sch_unoord_data ) )
  , .SEED                               ( 32'h1e )
  ) i_rx_sync_lsp_nalb_sch_unoord (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_lsp_nalb_sch_unoord_status_pnc )
  , .enable                             ( rx_sync_lsp_nalb_sch_unoord_enable )
  , .idle                               ( rx_sync_lsp_nalb_sch_unoord_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( lsp_nalb_sch_unoord_v )
  , .in_ready                           ( lsp_nalb_sch_unoord_ready )
  , .in_data                            ( lsp_nalb_sch_unoord_data )
  , .out_valid                          ( rx_sync_lsp_nalb_sch_unoord_v )
  , .out_ready                          ( rx_sync_lsp_nalb_sch_unoord_ready )
  , .out_data                           ( rx_sync_lsp_nalb_sch_unoord_data )
  , .mem_we                             ( func_rx_sync_lsp_nalb_sch_unoord_we )
  , .mem_waddr                          ( func_rx_sync_lsp_nalb_sch_unoord_waddr )
  , .mem_wdata                          ( func_rx_sync_lsp_nalb_sch_unoord_wdata )
  , .mem_re                             ( func_rx_sync_lsp_nalb_sch_unoord_re )
  , .mem_raddr                          ( func_rx_sync_lsp_nalb_sch_unoord_raddr )
  , .mem_rdata                          ( func_rx_sync_lsp_nalb_sch_unoord_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [1] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

// double buffer for lsp_nalb interface to scheudle nalb replay list
hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_lsp_nalb_sch_rorply_data ) )
  , .SEED                               ( 32'h2d )
  ) i_rx_sync_lsp_nalb_sch_rorply (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_lsp_nalb_sch_rorply_status_pnc )
  , .enable                             ( rx_sync_lsp_nalb_sch_rorply_enable )
  , .idle                               ( rx_sync_lsp_nalb_sch_rorply_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( lsp_nalb_sch_rorply_v )
  , .in_ready                           ( lsp_nalb_sch_rorply_ready )
  , .in_data                            ( lsp_nalb_sch_rorply_data )
  , .out_valid                          ( rx_sync_lsp_nalb_sch_rorply_v )
  , .out_ready                          ( rx_sync_lsp_nalb_sch_rorply_ready )
  , .out_data                           ( rx_sync_lsp_nalb_sch_rorply_data )
  , .mem_we                             ( func_rx_sync_lsp_nalb_sch_rorply_we )
  , .mem_waddr                          ( func_rx_sync_lsp_nalb_sch_rorply_waddr )
  , .mem_wdata                          ( func_rx_sync_lsp_nalb_sch_rorply_wdata )
  , .mem_re                             ( func_rx_sync_lsp_nalb_sch_rorply_re )
  , .mem_raddr                          ( func_rx_sync_lsp_nalb_sch_rorply_raddr )
  , .mem_rdata                          ( func_rx_sync_lsp_nalb_sch_rorply_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [2] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

// double buffer
hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_lsp_nalb_sch_atq_data ) )
  , .SEED                               ( 32'h3c )
  ) i_rx_sync_lsp_nalb_sch_atq (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_lsp_nalb_sch_atq_status_pnc )
  , .enable                             ( rx_sync_lsp_nalb_sch_atq_enable )
  , .idle                               ( rx_sync_lsp_nalb_sch_atq_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( lsp_nalb_sch_atq_v )
  , .in_ready                           ( lsp_nalb_sch_atq_ready )
  , .in_data                            ( lsp_nalb_sch_atq_data )
  , .out_valid                          ( rx_sync_lsp_nalb_sch_atq_v )
  , .out_ready                          ( rx_sync_lsp_nalb_sch_atq_ready )
  , .out_data                           ( rx_sync_lsp_nalb_sch_atq_data )
  , .mem_we                             ( func_rx_sync_lsp_nalb_sch_atq_we )
  , .mem_waddr                          ( func_rx_sync_lsp_nalb_sch_atq_waddr )
  , .mem_wdata                          ( func_rx_sync_lsp_nalb_sch_atq_wdata )
  , .mem_re                             ( func_rx_sync_lsp_nalb_sch_atq_re )
  , .mem_raddr                          ( func_rx_sync_lsp_nalb_sch_atq_raddr )
  , .mem_rdata                          ( func_rx_sync_lsp_nalb_sch_atq_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [3] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

// double buffer for nalb_lsp interface to signal when a HCW has been enqueued
hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_nalb_lsp_enq_lb_data ) )
  ) i_tx_sync_nalb_lsp_enq_lb (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_n )
  , .status                             ( tx_sync_nalb_lsp_enq_lb_status_pnc )
  , .idle                               ( tx_sync_nalb_lsp_enq_lb_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_nalb_lsp_enq_lb_v )
  , .in_ready                           ( tx_sync_nalb_lsp_enq_lb_ready )
  , .in_data                            ( tx_sync_nalb_lsp_enq_lb_data )
  , .out_valid                          ( nalb_lsp_enq_lb_v )
  , .out_ready                          ( nalb_lsp_enq_lb_ready )
  , .out_data                           ( nalb_lsp_enq_lb_data )
) ;

// double buffer for nalb_lsp interface to signal when a HCW has been enqueued
hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_nalb_lsp_enq_rorply_data ) )
  ) i_tx_sync_nalb_lsp_enq_rorply (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_n )
  , .status                             ( tx_sync_nalb_lsp_enq_rorply_status_pnc )
  , .idle                               ( tx_sync_nalb_lsp_enq_rorply_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_nalb_lsp_enq_rorply_v )
  , .in_ready                           ( tx_sync_nalb_lsp_enq_rorply_ready )
  , .in_data                            ( tx_sync_nalb_lsp_enq_rorply_data )
  , .out_valid                          ( nalb_lsp_enq_rorply_v )
  , .out_ready                          ( nalb_lsp_enq_rorply_ready )
  , .out_data                           ( nalb_lsp_enq_rorply_data )
) ;


// double buffer for nalb_qed interface to issue pop command when scheduling
hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_nalb_qed_data ) )
  ) i_tx_sync_nalb_qed (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_n )
  , .status                             ( tx_sync_nalb_qed_status_pnc )
  , .idle                               ( tx_sync_nalb_qed_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_nalb_qed_v )
  , .in_ready                           ( tx_sync_nalb_qed_ready )
  , .in_data                            ( tx_sync_nalb_qed_data )
  , .out_valid                          ( nalb_qed_v )
  , .out_ready                          ( nalb_qed_ready )
  , .out_data                           ( nalb_qed_data )
) ;



//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar

cfg_req_t unit_cfg_req ;
logic [ ( HQM_NALB_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write ;
logic [ ( HQM_NALB_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read ;
logic unit_cfg_rsp_ack ;
logic unit_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ] unit_cfg_rsp_rdata ;
hqm_AW_cfg_ring_top # (
          .NODE_ID                     ( HQM_NALB_CFG_NODE_ID )
        , .UNIT_ID                     ( HQM_NALB_CFG_UNIT_ID )
        , .UNIT_TGT_MAP                ( HQM_NALB_CFG_UNIT_TGT_MAP )
        , .UNIT_NUM_TGTS               ( HQM_NALB_CFG_UNIT_NUM_TGTS )
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

        , .up_cfg_req_write            ( nalb_cfg_req_up_write )
        , .up_cfg_req_read             ( nalb_cfg_req_up_read )
        , .up_cfg_req                  ( nalb_cfg_req_up )
        , .up_cfg_rsp_ack              ( nalb_cfg_rsp_up_ack )
        , .up_cfg_rsp                  ( nalb_cfg_rsp_up )

        , .down_cfg_req_write          ( nalb_cfg_req_down_write )
        , .down_cfg_req_read           ( nalb_cfg_req_down_read )
        , .down_cfg_req                ( nalb_cfg_req_down )
        , .down_cfg_rsp_ack            ( nalb_cfg_rsp_down_ack )
        , .down_cfg_rsp                ( nalb_cfg_rsp_down )

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
assign hqm_nalb_target_cfg_unit_timeout_reg_nxt = {hqm_nalb_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign cfg_unit_timeout = {hqm_nalb_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_nalb_target_cfg_unit_timeout_reg_f[4:0];

localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_nalb_target_cfg_unit_version_status = cfg_unit_version;

//------------------------------------------------------------------------------------------------------------------

logic cfg_req_idlepipe ;
logic cfg_req_ready ;
logic [ ( HQM_NALB_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write ;
logic [ ( HQM_NALB_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read ;

hqm_AW_cfg_sc # (
          .MODULE                      ( HQM_NALB_CFG_NODE_ID )
        , .NUM_CFG_TARGETS             ( HQM_NALB_CFG_UNIT_NUM_TGTS )
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
    .NUM_INF                            ( HQM_NALB_ALARM_NUM_INF )
  , .NUM_COR                            ( HQM_NALB_ALARM_NUM_COR )
  , .NUM_UNC                            ( HQM_NALB_ALARM_NUM_UNC )
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

  , .int_up_v                           ( nalb_alarm_up_v )
  , .int_up_ready                       ( nalb_alarm_up_ready )
  , .int_up_data                        ( nalb_alarm_up_data )

  , .int_down_v                         ( nalb_alarm_down_v )
  , .int_down_ready                     ( nalb_alarm_down_ready )
  , .int_down_data                      ( nalb_alarm_down_data )

  , .status                             ( int_status_pnc )

  , .int_idle                           ( int_idle )
) ;

logic err_hw_class_01_v_nxt , err_hw_class_01_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_01_nxt , err_hw_class_01_f ;
logic err_hw_class_02_v_nxt , err_hw_class_02_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_02_nxt , err_hw_class_02_f ;
logic err_hw_class_03_v_nxt , err_hw_class_03_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_03_nxt , err_hw_class_03_f ;

logic rw_nxthp_error_sb_f ;
logic rw_nxthp_error_mb_f ;

assign err_hw_class_01_nxt [ 0 ]  = error_nalb_nopri ;
assign err_hw_class_01_nxt [ 1 ]  = error_nalb_of ;
assign err_hw_class_01_nxt [ 2 ]  = error_atq_nopri ;
assign err_hw_class_01_nxt [ 3 ]  = error_atq_of ;
assign err_hw_class_01_nxt [ 4 ]  = error_rofrag_of ;
assign err_hw_class_01_nxt [ 5 ]  = error_replay_nopri ;
assign err_hw_class_01_nxt [ 6 ]  = error_replay_of ;
assign err_hw_class_01_nxt [ 7 ]  = error_badcmd0 ;
assign err_hw_class_01_nxt [ 8 ]  = error_replay_headroom ;
assign err_hw_class_01_nxt [ 9 ]  = error_rofrag_headroom ;
assign err_hw_class_01_nxt [ 10 ] = error_atq_headroom [ 1 ] ;
assign err_hw_class_01_nxt [ 11 ] = error_atq_headroom [ 0 ] ;
assign err_hw_class_01_nxt [ 12 ] = error_nalb_headroom [ 1 ] ;
assign err_hw_class_01_nxt [ 13 ] = error_nalb_headroom [ 0 ] ;
assign err_hw_class_01_nxt [ 14 ] = rw_nxthp_status ;
assign err_hw_class_01_nxt [ 15 ] = rmw_nalb_tp_status ;
assign err_hw_class_01_nxt [ 16 ] = rmw_nalb_hp_status ;
assign err_hw_class_01_nxt [ 17 ] = rmw_nalb_cnt_status ;
assign err_hw_class_01_nxt [ 18 ] = rmw_atq_cnt_status ;
assign err_hw_class_01_nxt [ 19 ] = rmw_atq_hp_status ;
assign err_hw_class_01_nxt [ 20 ] = rmw_atq_tp_status ;
assign err_hw_class_01_nxt [ 21 ] = rmw_rofrag_cnt_status ;
assign err_hw_class_01_nxt [ 22 ] = rmw_rofrag_hp_status ;
assign err_hw_class_01_nxt [ 23 ] = rmw_rofrag_tp_status ;
assign err_hw_class_01_nxt [ 24 ] = rmw_replay_cnt_status ;
assign err_hw_class_01_nxt [ 25 ] = rmw_replay_hp_status ;
assign err_hw_class_01_nxt [ 26 ] = rmw_replay_tp_status ;
assign err_hw_class_01_nxt [ 27 ] = ( sr_nalb_nxthp_error
                             | rf_atq_cnt_error
                             | rf_nalb_replay_cnt_error
                             | rf_nalb_hp_error
                             | rf_lsp_nalb_sch_unoord_error
                             | rf_rx_sync_lsp_nalb_sch_atq_error
                             | rf_nalb_replay_hp_error
                             | rf_rx_sync_lsp_nalb_sch_unoord_error
                             | rf_lsp_nalb_sch_rorply_error
                             | rf_nalb_lsp_enq_unoord_error
                             | rf_rx_sync_rop_nalb_enq_error
                             | rf_nalb_rofrag_hp_error
                             | rf_nalb_cnt_error
                             | rf_nalb_lsp_enq_rorply_error
                             | rf_rop_nalb_enq_ro_error
                             | rf_nalb_tp_error
                             | rf_lsp_nalb_sch_atq_error
                             | rf_nalb_qed_error
                             | rf_nalb_replay_tp_error
                             | rf_nalb_rofrag_cnt_error
                             | rf_rx_sync_lsp_nalb_sch_rorply_error
                             | rf_atq_hp_error
                             | rf_nalb_rofrag_tp_error
                             | rf_atq_tp_error
                             | rf_rop_nalb_enq_unoord_error
                             ) ;
assign err_hw_class_01_nxt [ 30 : 28 ] = 3'd1 ; 
assign err_hw_class_01_v_nxt = ( | err_hw_class_01_nxt [ 27 : 0 ] ) ; 

assign err_hw_class_02_nxt [ 0 ]  = residue_check_rx_sync_rop_nalb_enq_err ;
assign err_hw_class_02_nxt [ 1 ]  = residue_check_nalb_cnt_err ;
assign err_hw_class_02_nxt [ 2 ]  = residue_check_atq_cnt_err ;
assign err_hw_class_02_nxt [ 3 ]  = residue_check_rofrag_cnt_err ;
assign err_hw_class_02_nxt [ 4 ]  = residue_check_replay_cnt_err ;
assign err_hw_class_02_nxt [ 5 ]  = rw_nxthp_err_parity ;
assign err_hw_class_02_nxt [ 6 ]  = parity_check_rmw_nalb_hp_p2_error ;
assign err_hw_class_02_nxt [ 7 ]  = parity_check_rmw_nalb_tp_p2_error ;
assign err_hw_class_02_nxt [ 8 ]  = parity_check_rmw_atq_hp_p2_error ;
assign err_hw_class_02_nxt [ 9 ]  = parity_check_rmw_atq_tp_p2_error ;
assign err_hw_class_02_nxt [ 10 ] = parity_check_rmw_rofrag_hp_p2_error ;
assign err_hw_class_02_nxt [ 11 ] = parity_check_rmw_rofrag_tp_p2_error ;
assign err_hw_class_02_nxt [ 12 ] = parity_check_rmw_replay_hp_p2_error ;
assign err_hw_class_02_nxt [ 13 ] = parity_check_rmw_replay_tp_p2_error ;
assign err_hw_class_02_nxt [ 14 ] = parity_check_rw_nxthp_p2_data_error ;
assign err_hw_class_02_nxt [ 15 ] = parity_check_rx_sync_lsp_nalb_sch_unoord_error ;
assign err_hw_class_02_nxt [ 16 ] = parity_check_rx_sync_lsp_nalb_sch_rorply_error ;
assign err_hw_class_02_nxt [ 17 ] = parity_check_rx_sync_lsp_nalb_sch_atq_error ;
assign err_hw_class_02_nxt [ 18 ] = parity_check_rx_sync_rop_nalb_enq_data_flid_error ;
assign err_hw_class_02_nxt [ 19 ] = parity_check_rx_sync_rop_nalb_enq_data_hist_list_error ;
assign err_hw_class_02_nxt [ 20 ] = parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_error ;
assign err_hw_class_02_nxt [ 21 ] = parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_error ;
assign err_hw_class_02_nxt [ 22 ] = cfg_rx_fifo_status.overflow ;
assign err_hw_class_02_nxt [ 23 ] = cfg_rx_fifo_status.underflow ;
assign err_hw_class_02_nxt [ 24 ] = rx_sync_rop_nalb_enq_status_pnc.overflow ;
assign err_hw_class_02_nxt [ 25 ] = rx_sync_rop_nalb_enq_status_pnc.underflow ;
assign err_hw_class_02_nxt [ 26 ] = rx_sync_lsp_nalb_sch_unoord_status_pnc.overflow ;
assign err_hw_class_02_nxt [ 27 ] = rx_sync_lsp_nalb_sch_unoord_status_pnc.underflow ;
assign err_hw_class_02_nxt [ 30 : 28 ] = 3'd2 ; 
assign err_hw_class_02_v_nxt = ( | err_hw_class_02_nxt [ 27 : 0 ] ) ; 

assign err_hw_class_03_nxt [ 0 ]  = rx_sync_lsp_nalb_sch_rorply_status_pnc.overflow ;
assign err_hw_class_03_nxt [ 1 ]  = rx_sync_lsp_nalb_sch_rorply_status_pnc.underflow ;
assign err_hw_class_03_nxt [ 2 ]  = rx_sync_lsp_nalb_sch_atq_status_pnc.overflow ;
assign err_hw_class_03_nxt [ 3 ]  = rx_sync_lsp_nalb_sch_atq_status_pnc.underflow ;
assign err_hw_class_03_nxt [ 4 ]  = fifo_rop_nalb_enq_nalb_error_of ;
assign err_hw_class_03_nxt [ 5 ]  = fifo_rop_nalb_enq_nalb_error_uf ;
assign err_hw_class_03_nxt [ 6 ]  = fifo_rop_nalb_enq_ro_error_of ;
assign err_hw_class_03_nxt [ 7 ]  = fifo_rop_nalb_enq_ro_error_uf ;
assign err_hw_class_03_nxt [ 8 ]  = fifo_lsp_nalb_sch_unoord_error_of ;
assign err_hw_class_03_nxt [ 9 ]  = fifo_lsp_nalb_sch_unoord_error_uf ;
assign err_hw_class_03_nxt [ 10 ] = fifo_lsp_nalb_sch_rorply_error_of ;
assign err_hw_class_03_nxt [ 11 ] = fifo_lsp_nalb_sch_rorply_error_uf ;
assign err_hw_class_03_nxt [ 12 ] = fifo_lsp_nalb_sch_atq_error_of ;
assign err_hw_class_03_nxt [ 13 ] = fifo_lsp_nalb_sch_atq_error_uf ;
assign err_hw_class_03_nxt [ 14 ] = fifo_nalb_qed_error_of ;
assign err_hw_class_03_nxt [ 15 ] = fifo_nalb_qed_error_uf ;
assign err_hw_class_03_nxt [ 16 ] = fifo_nalb_lsp_enq_lb_error_of ;
assign err_hw_class_03_nxt [ 17 ] = fifo_nalb_lsp_enq_lb_error_uf ;
assign err_hw_class_03_nxt [ 18 ] = fifo_nalb_lsp_enq_rorply_error_of ;
assign err_hw_class_03_nxt [ 19 ] = fifo_nalb_lsp_enq_rorply_error_uf ;
assign err_hw_class_03_nxt [ 20 ] = fifo_rop_nalb_enq_nalb_pop_data_parity_error ;
assign err_hw_class_03_nxt [ 21 ] = fifo_rop_nalb_enq_ro_pop_data_parity_error ;
assign err_hw_class_03_nxt [ 22 ] = hqm_nalb_pipe_rfw_top_ipar_error ;
assign err_hw_class_03_nxt [ 23 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 24 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 25 ] = 1'b0 ;
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

    rw_nxthp_error_sb_f <= '0 ;
    rw_nxthp_error_mb_f <= '0 ;
  end
  else begin
    err_hw_class_01_f <= err_hw_class_01_nxt ;
    err_hw_class_01_v_f <= err_hw_class_01_v_nxt ;
    err_hw_class_02_f <= err_hw_class_02_nxt ;
    err_hw_class_02_v_f <= err_hw_class_02_v_nxt ;
    err_hw_class_03_f <= err_hw_class_03_nxt ;
    err_hw_class_03_v_f <= err_hw_class_03_v_nxt ;

    rw_nxthp_error_sb_f <= rw_nxthp_error_sb ;
    rw_nxthp_error_mb_f <= rw_nxthp_error_mb ;
  end
end

always_comb begin
  int_uid                                          = HQM_NALB_CFG_UNIT_ID ;
  int_unc_v                                        = '0 ;
  int_unc_data                                     = '0 ;
  int_cor_v                                        = '0 ;
  int_cor_data                                     = '0 ;
  int_inf_v                                        = '0 ;
  int_inf_data                                     = '0 ;
  hqm_nalb_target_cfg_syndrome_00_capture_v        = '0 ;
  hqm_nalb_target_cfg_syndrome_00_capture_data     = '0 ;
  hqm_nalb_target_cfg_syndrome_01_capture_v        = '0 ;
  hqm_nalb_target_cfg_syndrome_01_capture_data     = '0 ;

  //  rw_nxthp_error_sb_f "SB ECC Error" correctable ECC error on NALB nxthp storage
  if ( rw_nxthp_error_sb_f & ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_nalb_target_cfg_syndrome_01_capture_v      = ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[1] ;
    hqm_nalb_target_cfg_syndrome_01_capture_data   = 31'h00000001 ;
  end
  //  rw_nxthp_error_mb_f "MB ECC Error" uncorrectable ECC error on NALB nxthp storage
  if ( rw_nxthp_error_mb_f & ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_nalb_target_cfg_syndrome_01_capture_v      = ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[3] ;
    hqm_nalb_target_cfg_syndrome_01_capture_data   = 31'h00000002 ;
  end
  //  err_hw_class_01_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_01_v_f & ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_nalb_target_cfg_syndrome_00_capture_v      = ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[5] ;
    hqm_nalb_target_cfg_syndrome_00_capture_data   = err_hw_class_01_f ;
  end
  //  err_hw_class_02_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_02_v_f & ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_nalb_target_cfg_syndrome_00_capture_v      = ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[5] ;
    hqm_nalb_target_cfg_syndrome_00_capture_data   = err_hw_class_02_f ;
  end
  //  err_hw_class_03_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_03_v_f & ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_nalb_target_cfg_syndrome_00_capture_v      = ~hqm_nalb_target_cfg_nalb_csr_control_reg_f[5] ;
    hqm_nalb_target_cfg_syndrome_00_capture_data   = err_hw_class_03_f ;
  end

end


//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: END common core interfaces 
//*****************************************************************************************************
//*****************************************************************************************************





//------------------------------------------------------------------------------------------------------------------------------------------------
// flops

logic hqm_proc_clk_en_f ;
logic hqm_proc_clk_en_fall ;
assign hqm_proc_clk_en_fall = hqm_proc_clk_en_f & ~ hqm_proc_clk_en ;
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    hqm_proc_clk_en_f <= '0 ;
  end
  else begin
    hqm_proc_clk_en_f <= hqm_proc_clk_en ;
  end
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    reset_pf_counter_f <= '0 ;
    reset_pf_active_f <= 1'b1 ;
    reset_pf_done_f <= '0 ;
    hw_init_done_f <= '0 ;
  end
  else begin
    reset_pf_counter_f <= reset_pf_counter_nxt ;
    reset_pf_active_f <= reset_pf_active_nxt ;
    reset_pf_done_f <= reset_pf_done_nxt ;
    hw_init_done_f <= hw_init_done_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L02
  if ( ! hqm_gated_rst_n ) begin



    p0_nalb_v_f <= '0 ;
    p1_nalb_v_f <= '0 ;
    p2_nalb_v_f <= '0 ;
    p3_nalb_v_f <= '0 ;
    p4_nalb_v_f <= '0 ;
    p5_nalb_v_f <= '0 ;
    p6_nalb_v_f <= '0 ;
    p7_nalb_v_f <= '0 ;
    p8_nalb_v_f <= '0 ;
    p9_nalb_v_f_nc <= '0 ;

    p0_atq_v_f <= '0 ;
    p1_atq_v_f <= '0 ;
    p2_atq_v_f <= '0 ;
    p3_atq_v_f <= '0 ;
    p4_atq_v_f <= '0 ;
    p5_atq_v_f <= '0 ;
    p6_atq_v_f <= '0 ;
    p7_atq_v_f <= '0 ;
    p8_atq_v_f <= '0 ;
    p9_atq_v_f_nc <= '0 ;

    p0_rofrag_v_f <= '0 ;
    p1_rofrag_v_f <= '0 ;
    p2_rofrag_v_f <= '0 ;
    p3_rofrag_v_f <= '0 ;
    p4_rofrag_v_f <= '0 ;
    p5_rofrag_v_f <= '0 ;
    p6_rofrag_v_f <= '0 ;
    p7_rofrag_v_f <= '0 ;
    p8_rofrag_v_f <= '0 ;
    p9_rofrag_v_f_nc <= '0 ;

    p0_replay_v_f <= '0 ;
    p1_replay_v_f <= '0 ;
    p2_replay_v_f <= '0 ;
    p3_replay_v_f <= '0 ;
    p4_replay_v_f <= '0 ;
    p5_replay_v_f <= '0 ;
    p6_replay_v_f <= '0 ;
    p7_replay_v_f <= '0 ;
    p8_replay_v_f <= '0 ;
    p9_replay_v_f_nc <= '0 ;

  end
  else begin




    p0_nalb_v_f <= p0_nalb_v_nxt ;
    p1_nalb_v_f <= p1_nalb_v_nxt ;
    p2_nalb_v_f <= p2_nalb_v_nxt ;
    p3_nalb_v_f <= p3_nalb_v_nxt ;
    p4_nalb_v_f <= p4_nalb_v_nxt ;
    p5_nalb_v_f <= p5_nalb_v_nxt ;
    p6_nalb_v_f <= p6_nalb_v_nxt ;
    p7_nalb_v_f <= p7_nalb_v_nxt ;
    p8_nalb_v_f <= p8_nalb_v_nxt ;
    p9_nalb_v_f_nc <= p9_nalb_v_nxt ;

    p0_atq_v_f <= p0_atq_v_nxt ;
    p1_atq_v_f <= p1_atq_v_nxt ;
    p2_atq_v_f <= p2_atq_v_nxt ;
    p3_atq_v_f <= p3_atq_v_nxt ;
    p4_atq_v_f <= p4_atq_v_nxt ;
    p5_atq_v_f <= p5_atq_v_nxt ;
    p6_atq_v_f <= p6_atq_v_nxt ;
    p7_atq_v_f <= p7_atq_v_nxt ;
    p8_atq_v_f <= p8_atq_v_nxt ;
    p9_atq_v_f_nc <= p9_atq_v_nxt ;

    p0_rofrag_v_f <= p0_rofrag_v_nxt ;
    p1_rofrag_v_f <= p1_rofrag_v_nxt ;
    p2_rofrag_v_f <= p2_rofrag_v_nxt ;
    p3_rofrag_v_f <= p3_rofrag_v_nxt ;
    p4_rofrag_v_f <= p4_rofrag_v_nxt ;
    p5_rofrag_v_f <= p5_rofrag_v_nxt ;
    p6_rofrag_v_f <= p6_rofrag_v_nxt ;
    p7_rofrag_v_f <= p7_rofrag_v_nxt ;
    p8_rofrag_v_f <= p8_rofrag_v_nxt ;
    p9_rofrag_v_f_nc <= p9_rofrag_v_nxt ;

    p0_replay_v_f <= p0_replay_v_nxt ;
    p1_replay_v_f <= p1_replay_v_nxt ;
    p2_replay_v_f <= p2_replay_v_nxt ;
    p3_replay_v_f <= p3_replay_v_nxt ;
    p4_replay_v_f <= p4_replay_v_nxt ;
    p5_replay_v_f <= p5_replay_v_nxt ;
    p6_replay_v_f <= p6_replay_v_nxt ;
    p7_replay_v_f <= p7_replay_v_nxt ;
    p8_replay_v_f <= p8_replay_v_nxt ;
    p9_replay_v_f_nc <= p9_replay_v_nxt ;

  end
end
always_ff @ ( posedge hqm_gated_clk ) begin : L03


    p0_nalb_data_f <= p0_nalb_data_nxt ;
    p1_nalb_data_f <= p1_nalb_data_nxt ;
    p2_nalb_data_f <= p2_nalb_data_nxt ;
    p3_nalb_data_f <= p3_nalb_data_nxt ;
    p4_nalb_data_f <= p4_nalb_data_nxt ;
    p5_nalb_data_f <= p5_nalb_data_nxt ;
    p6_nalb_data_f <= p6_nalb_data_nxt ;
    p7_nalb_data_f <= p7_nalb_data_nxt ;
    p8_nalb_data_f <= p8_nalb_data_nxt ;
    p9_nalb_data_f <= p9_nalb_data_nxt ;


    p0_atq_data_f <= p0_atq_data_nxt ;
    p1_atq_data_f <= p1_atq_data_nxt ;
    p2_atq_data_f <= p2_atq_data_nxt ;
    p3_atq_data_f <= p3_atq_data_nxt ;
    p4_atq_data_f <= p4_atq_data_nxt ;
    p5_atq_data_f <= p5_atq_data_nxt ;
    p6_atq_data_f <= p6_atq_data_nxt ;
    p7_atq_data_f <= p7_atq_data_nxt ;
    p8_atq_data_f <= p8_atq_data_nxt ;
    p9_atq_data_f <= p9_atq_data_nxt ;

    p0_rofrag_data_f <= p0_rofrag_data_nxt ;
    p1_rofrag_data_f <= p1_rofrag_data_nxt ;
    p2_rofrag_data_f <= p2_rofrag_data_nxt ;
    p3_rofrag_data_f <= p3_rofrag_data_nxt ;
    p4_rofrag_data_f <= p4_rofrag_data_nxt ;
    p5_rofrag_data_f <= p5_rofrag_data_nxt ;
    p6_rofrag_data_f <= p6_rofrag_data_nxt ;
    p7_rofrag_data_f <= p7_rofrag_data_nxt ;
    p8_rofrag_data_f <= p8_rofrag_data_nxt ;
    p9_rofrag_data_f <= p9_rofrag_data_nxt ;

    p0_replay_data_f <= p0_replay_data_nxt ;
    p1_replay_data_f <= p1_replay_data_nxt ;
    p2_replay_data_f <= p2_replay_data_nxt ;
    p3_replay_data_f <= p3_replay_data_nxt ;
    p4_replay_data_f <= p4_replay_data_nxt ;
    p5_replay_data_f <= p5_replay_data_nxt ;
    p6_replay_data_f <= p6_replay_data_nxt ;
    p7_replay_data_f <= p7_replay_data_nxt ;
    p8_replay_data_f <= p8_replay_data_nxt ;
    p9_replay_data_f <= p9_replay_data_nxt ;

end






always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L05
  if ( ! hqm_gated_rst_n ) begin
    fifo_nalb_lsp_enq_lb_nalb_cnt_f <= '0 ;
    fifo_nalb_lsp_enq_lb_atq_cnt_f <= '0 ;
    fifo_nalb_lsp_enq_lb_rorply_cnt_f <= '0 ;
    fifo_nalb_qed_nalb_cnt_f <= '0 ;
    fifo_nalb_qed_atq_cnt_f <= '0 ;
    fifo_nalb_qed_rorply_cnt_f <= '0 ;
  end
  else begin
    fifo_nalb_lsp_enq_lb_nalb_cnt_f <= fifo_nalb_lsp_enq_lb_nalb_cnt_nxt ;
    fifo_nalb_lsp_enq_lb_atq_cnt_f <= fifo_nalb_lsp_enq_lb_atq_cnt_nxt ;
    fifo_nalb_lsp_enq_lb_rorply_cnt_f <= fifo_nalb_lsp_enq_lb_rorply_cnt_nxt ;
    fifo_nalb_qed_nalb_cnt_f <= fifo_nalb_qed_nalb_cnt_nxt ;
    fifo_nalb_qed_atq_cnt_f <= fifo_nalb_qed_atq_cnt_nxt ;
    fifo_nalb_qed_rorply_cnt_f <= fifo_nalb_qed_rorply_cnt_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L07
  if ( ! hqm_gated_rst_n ) begin
residue_check_nalb_cnt_r_f <= '0 ;
residue_check_nalb_cnt_d_f <= '0 ;
residue_check_nalb_cnt_e_f <= '0 ;
residue_check_atq_cnt_r_f <= '0 ;
residue_check_atq_cnt_d_f <= '0 ;
residue_check_atq_cnt_e_f <= '0 ;
residue_check_rofrag_cnt_r_f <= '0 ;
residue_check_rofrag_cnt_d_f <= '0 ;
residue_check_rofrag_cnt_e_f <= '0 ;
residue_check_replay_cnt_r_f <= '0 ;
residue_check_replay_cnt_d_f <= '0 ;
residue_check_replay_cnt_e_f <= '0 ;

  end
  else begin
residue_check_nalb_cnt_r_f <= residue_check_nalb_cnt_r_nxt ;
residue_check_nalb_cnt_d_f <= residue_check_nalb_cnt_d_nxt ;
residue_check_nalb_cnt_e_f <= residue_check_nalb_cnt_e_nxt ;
residue_check_atq_cnt_r_f <= residue_check_atq_cnt_r_nxt ;
residue_check_atq_cnt_d_f <= residue_check_atq_cnt_d_nxt ;
residue_check_atq_cnt_e_f <= residue_check_atq_cnt_e_nxt ;
residue_check_rofrag_cnt_r_f <= residue_check_rofrag_cnt_r_nxt ;
residue_check_rofrag_cnt_d_f <= residue_check_rofrag_cnt_d_nxt ;
residue_check_rofrag_cnt_e_f <= residue_check_rofrag_cnt_e_nxt ;
residue_check_replay_cnt_r_f <= residue_check_replay_cnt_r_nxt ;
residue_check_replay_cnt_d_f <= residue_check_replay_cnt_d_nxt ;
residue_check_replay_cnt_e_f <= residue_check_replay_cnt_e_nxt ;

  end
end

// duplicate for fanout violation
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L08
  if ( ! hqm_gated_rst_n ) begin
    nalb_stall_f <= '0 ;
    atq_stall_f <= '0 ;
    ordered_stall_f <= '0 ;
  end
  else begin
    nalb_stall_f <= nalb_stall_nxt ;
    atq_stall_f <= atq_stall_nxt ;
    ordered_stall_f <= ordered_stall_nxt ;
  end
end



//------------------------------------------------------------------------------------------------------------------------------------------------
// Instances


//....................................................................................................
//HW AGITATE
assign cfg_agitate_control_nxt = cfg_agitate_control_f ;
assign hqm_nalb_target_cfg_hw_agitate_control_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_hw_agitate_control_reg_nxt = cfg_agitate_control_nxt ;
assign cfg_agitate_control_f = hqm_nalb_target_cfg_hw_agitate_control_reg_f ;


assign cfg_agitate_select_nxt = cfg_agitate_select_f ;
assign hqm_nalb_target_cfg_hw_agitate_select_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_hw_agitate_select_reg_nxt = cfg_agitate_select_nxt ;
assign cfg_agitate_select_f = hqm_nalb_target_cfg_hw_agitate_select_reg_f ;


// SMON
assign hqm_nalb_target_cfg_smon_smon_v         = smon_v ;
assign hqm_nalb_target_cfg_smon_disable_smon   = disable_smon ;
assign hqm_nalb_target_cfg_smon_smon_comp      = smon_comp ;
assign hqm_nalb_target_cfg_smon_smon_val       = smon_val ;


//....................................................................................................
// Parity logic

hqm_AW_ecc_gen # (
   .DATA_WIDTH                          ( 15 )
 , .ECC_WIDTH                           ( 6 )
) i_ecc_gen_l (   
   .d                                   ( ecc_gen_d_nc )
 , .ecc                                 ( ecc_gen )
) ;
assign ecc_gen_d_nc = 15'b100_0000_0000_0000 ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 27 )
) i_parity_gen_nalb_rop_nalb_enq_data_hist_list (
     .d                                 ( parity_gen_nalb_rop_nalb_enq_data_hist_list_d )
   , .odd                               ( 1'b0 ) //NOTE: used for parity subtraction and not checking
   , .p                                 ( parity_gen_nalb_rop_nalb_enq_data_hist_list_p )
) ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 27 )
) i_parity_gen_atq_rop_nalb_enq_data_hist_list (
     .d                                 ( parity_gen_atq_rop_nalb_enq_data_hist_list_d )
   , .odd                               ( 1'b0 ) //NOTE: used for parity subtraction and not checking
   , .p                                 ( parity_gen_atq_rop_nalb_enq_data_hist_list_p )
) ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 29 )
) i_parity_gen_rofrag_rop_dp_enq_data_hist_list_d (
     .d                                 ( parity_gen_rofrag_rop_dp_enq_data_hist_list_d )
   , .odd                               ( 1'b0 ) //NOTE: used for parity subtraction and not checking
   , .p                                 ( parity_gen_rofrag_rop_dp_enq_data_hist_list_p )
) ;



hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_nalb_hp_p2 (
     .p                                 ( parity_check_rmw_nalb_hp_p2_p )
   , .d                                 ( parity_check_rmw_nalb_hp_p2_d )
   , .e                                 ( parity_check_rmw_nalb_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_nalb_hp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_nalb_tp_p2 (
     .p                                 ( parity_check_rmw_nalb_tp_p2_p )
   , .d                                 ( parity_check_rmw_nalb_tp_p2_d )
   , .e                                 ( parity_check_rmw_nalb_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_nalb_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_atq_hp_p2 (
     .p                                 ( parity_check_rmw_atq_hp_p2_p )
   , .d                                 ( parity_check_rmw_atq_hp_p2_d )
   , .e                                 ( parity_check_rmw_atq_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_atq_hp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_atq_tp_p2 (
     .p                                 ( parity_check_rmw_atq_tp_p2_p )
   , .d                                 ( parity_check_rmw_atq_tp_p2_d )
   , .e                                 ( parity_check_rmw_atq_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_atq_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_rofrag_hp_p2 (
     .p                                 ( parity_check_rmw_rofrag_hp_p2_p )
   , .d                                 ( parity_check_rmw_rofrag_hp_p2_d )
   , .e                                 ( parity_check_rmw_rofrag_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_rofrag_hp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_rofrag_tp_p2 (
     .p                                 ( parity_check_rmw_rofrag_tp_p2_p )
   , .d                                 ( parity_check_rmw_rofrag_tp_p2_d )
   , .e                                 ( parity_check_rmw_rofrag_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_rofrag_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_replay_hp_p2 (
     .p                                 ( parity_check_rmw_replay_hp_p2_p )
   , .d                                 ( parity_check_rmw_replay_hp_p2_d )
   , .e                                 ( parity_check_rmw_replay_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_replay_hp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rmw_replay_tp_p2 (
     .p                                 ( parity_check_rmw_replay_tp_p2_p )
   , .d                                 ( parity_check_rmw_replay_tp_p2_d )
   , .e                                 ( parity_check_rmw_replay_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_replay_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_NALB_FLIDB2 )
) i_parity_check_rw_nxthp_p2 (
     .p                                 ( parity_check_rw_nxthp_p2_data_p )
   , .d                                 ( parity_check_rw_nxthp_p2_data_d )
   , .e                                 ( parity_check_rw_nxthp_p2_data_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rw_nxthp_p2_data_error )
) ;




hqm_AW_parity_check # (
    .WIDTH                              ( 18 )
) i_parity_check_rx_sync_lsp_nalb_sch_unoord (
     .p                                 ( parity_check_rx_sync_lsp_nalb_sch_unoord_p )
   , .d                                 ( parity_check_rx_sync_lsp_nalb_sch_unoord_d )
   , .e                                 ( parity_check_rx_sync_lsp_nalb_sch_unoord_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_lsp_nalb_sch_unoord_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 7 )
) i_parity_check_rx_sync_lsp_nalb_sch_rorply (
     .p                                 ( parity_check_rx_sync_lsp_nalb_sch_rorply_p )
   , .d                                 ( parity_check_rx_sync_lsp_nalb_sch_rorply_d )
   , .e                                 ( parity_check_rx_sync_lsp_nalb_sch_rorply_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_lsp_nalb_sch_rorply_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 7 )
) i_parity_check_rx_sync_lsp_nalb_sch_atq (
     .p                                 ( parity_check_rx_sync_lsp_nalb_sch_atq_p )
   , .d                                 ( parity_check_rx_sync_lsp_nalb_sch_atq_d )
   , .e                                 ( parity_check_rx_sync_lsp_nalb_sch_atq_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_lsp_nalb_sch_atq_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 15 )
) i_parity_check_rx_sync_rop_nalb_enq_data_flid (
     .p                                 ( parity_check_rx_sync_rop_nalb_enq_data_flid_p )
   , .d                                 ( parity_check_rx_sync_rop_nalb_enq_data_flid_d )
   , .e                                 ( parity_check_rx_sync_rop_nalb_enq_data_flid_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_nalb_enq_data_flid_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 35 )
) i_parity_check_rx_sync_rop_nalb_enq_data_hist_list (
     .p                                 ( parity_check_rx_sync_rop_nalb_enq_data_hist_list_p )
   , .d                                 ( parity_check_rx_sync_rop_nalb_enq_data_hist_list_d )
   , .e                                 ( parity_check_rx_sync_rop_nalb_enq_data_hist_list_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_nalb_enq_data_hist_list_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 15 )
) i_parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr (
     .p                                 ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_p )
   , .d                                 ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_d )
   , .e                                 ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 15 )
) i_parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr (
     .p                                 ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_p )
   , .d                                 ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_d )
   , .e                                 ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_error )
) ;

//....................................................................................................
// Residue logic

hqm_AW_residue_check # (
   .WIDTH                             ( 15 )
) i_residue_check_rx_sync_rop_nalb_enq_data (
   .r                                 ( residue_check_rx_sync_rop_nalb_enq_r )
 , .d                                 ( residue_check_rx_sync_rop_nalb_enq_d )
 , .e                                 ( residue_check_rx_sync_rop_nalb_enq_e )
 , .err                               ( residue_check_rx_sync_rop_nalb_enq_err )
) ;

hqm_AW_residue_add i_residue_add_nalb_cnt (
   .a                                 ( residue_add_nalb_cnt_a )
 , .b                                 ( residue_add_nalb_cnt_b )
 , .r                                 ( residue_add_nalb_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_nalb_cnt (
   .a                                 ( residue_sub_nalb_cnt_a )
 , .b                                 ( residue_sub_nalb_cnt_b )
 , .r                                 ( residue_sub_nalb_cnt_r )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_NALB_CNTB2 )
) i_residue_check_nalb_cnt (
   .r                                 ( residue_check_nalb_cnt_r_f )
 , .d                                 ( residue_check_nalb_cnt_d_f )
 , .e                                 ( residue_check_nalb_cnt_e_f )
 , .err                               ( residue_check_nalb_cnt_err )
) ;

hqm_AW_residue_add i_residue_add_atq_cnt (
   .a                                 ( residue_add_atq_cnt_a )
 , .b                                 ( residue_add_atq_cnt_b )
 , .r                                 ( residue_add_atq_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_atq_cnt (
   .a                                 ( residue_sub_atq_cnt_a )
 , .b                                 ( residue_sub_atq_cnt_b )
 , .r                                 ( residue_sub_atq_cnt_r )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_NALB_CNTB2 )
) i_residue_check_atq_cnt (
   .r                                 ( residue_check_atq_cnt_r_f )
 , .d                                 ( residue_check_atq_cnt_d_f )
 , .e                                 ( residue_check_atq_cnt_e_f )
 , .err                               ( residue_check_atq_cnt_err )
) ;

hqm_AW_residue_add i_residue_add_rofrag_cnt (
   .a                                 ( residue_add_rofrag_cnt_a )
 , .b                                 ( residue_add_rofrag_cnt_b )
 , .r                                 ( residue_add_rofrag_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_rofrag_cnt (
   .a                                 ( residue_sub_rofrag_cnt_a )
 , .b                                 ( residue_sub_rofrag_cnt_b )
 , .r                                 ( residue_sub_rofrag_cnt_r )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_NALB_CNTB2 )
) i_residue_check_rofrag_cnt (
   .r                                 ( residue_check_rofrag_cnt_r_f )
 , .d                                 ( residue_check_rofrag_cnt_d_f )
 , .e                                 ( residue_check_rofrag_cnt_e_f )
 , .err                               ( residue_check_rofrag_cnt_err )
) ;

hqm_AW_residue_add i_residue_add_replay_cnt (
   .a                                 ( residue_add_replay_cnt_a )
 , .b                                 ( residue_add_replay_cnt_b )
 , .r                                 ( residue_add_replay_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_replay_cnt (
   .a                                 ( residue_sub_replay_cnt_a )
 , .b                                 ( residue_sub_replay_cnt_b )
 , .r                                 ( residue_sub_replay_cnt_r )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_NALB_CNTB2 )
) i_residue_check_replay_cnt (
   .r                                 ( residue_check_replay_cnt_r_f )
 , .d                                 ( residue_check_replay_cnt_d_f )
 , .e                                 ( residue_check_replay_cnt_e_f )
 , .err                               ( residue_check_replay_cnt_err )
) ;

//....................................................................................................
// FIFOs

// FIFO for rop_nalb_enq interface used to enqueue HCW : ROP_NALB_ENQ_UNOORD_ENQ_NEW_HCW
assign fifo_rop_nalb_enq_nalb_error_of = fifo_rop_nalb_enq_uno_ord_if_status [ 1 ] ;
assign fifo_rop_nalb_enq_nalb_error_uf = fifo_rop_nalb_enq_uno_ord_if_status [ 0 ] ;
assign fifo_rop_nalb_enq_uno_ord_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_f [ HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_nxt = { fifo_rop_nalb_enq_uno_ord_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_ROP_NALB_ENQ_UNOORD_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_rop_nalb_enq_nalb_push_data ) )
) i_fifo_rop_nalb_enq_nalb (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_rop_nalb_enq_uno_ord_if_cfg_high_wm )
  , .fifo_status                        ( fifo_rop_nalb_enq_uno_ord_if_status )
  , .fifo_full                          ( fifo_rop_nalb_enq_nalb_full_nc )
  , .fifo_afull                         ( fifo_rop_nalb_enq_nalb_afull )
  , .fifo_empty                         ( fifo_rop_nalb_enq_nalb_empty )
  , .push                               ( fifo_rop_nalb_enq_nalb_push )
  , .push_data                          ( { fifo_rop_nalb_enq_nalb_push_data } )
  , .pop                                ( fifo_rop_nalb_enq_nalb_pop )
  , .pop_data                           ( { wire_fifo_rop_nalb_enq_nalb_pop_data } )
  , .mem_we                             ( func_rop_nalb_enq_unoord_we )
  , .mem_waddr                          ( func_rop_nalb_enq_unoord_waddr )
  , .mem_wdata                          ( func_rop_nalb_enq_unoord_wdata )
  , .mem_re                             ( func_rop_nalb_enq_unoord_re )
  , .mem_raddr                          ( func_rop_nalb_enq_unoord_raddr )
  , .mem_rdata                          ( func_rop_nalb_enq_unoord_rdata )
) ;

assign fifo_rop_nalb_enq_nalb_pop_data.cmd = wire_fifo_rop_nalb_enq_nalb_pop_data.cmd ;
assign fifo_rop_nalb_enq_nalb_pop_data.cq = { 1'b0 , wire_fifo_rop_nalb_enq_nalb_pop_data.cq [6 : 0 ] } ;
assign fifo_rop_nalb_enq_nalb_pop_data.flid = wire_fifo_rop_nalb_enq_nalb_pop_data.flid ; 
assign fifo_rop_nalb_enq_nalb_pop_data.flid_parity = wire_fifo_rop_nalb_enq_nalb_pop_data.flid_parity ; 
assign fifo_rop_nalb_enq_nalb_pop_data.hist_list_info = wire_fifo_rop_nalb_enq_nalb_pop_data.hist_list_info ;
assign fifo_rop_nalb_enq_nalb_pop_data.frag_list_info = wire_fifo_rop_nalb_enq_nalb_pop_data.frag_list_info ;

assign fifo_rop_nalb_enq_nalb_pop_data_parity_error = ( fifo_rop_nalb_enq_nalb_pop
                                                      & ( ~ ( wire_fifo_rop_nalb_enq_nalb_pop_data.cmd [ 0 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cmd [ 1 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cmd [ 2 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 0 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 1 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 2 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 3 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 4 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 5 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 6 ] ^ wire_fifo_rop_nalb_enq_nalb_pop_data.cq [ 7 ] ) )
                                                      ) ;

// FIFO for rop_nalb_enq interface used to enqueue HCW : ROP_NALB_ENQ_UNOORD_ENQ_REORDER_HCW
assign fifo_rop_nalb_enq_ro_error_of = fifo_rop_nalb_enq_ro_if_status [ 1 ] ;
assign fifo_rop_nalb_enq_ro_error_uf = fifo_rop_nalb_enq_ro_if_status [ 0 ] ;
assign fifo_rop_nalb_enq_ro_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_f [ HQM_NALB_FIFO_ROP_NALB_ENQ_RO_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_nxt = { fifo_rop_nalb_enq_ro_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_rop_nalb_enq_ro_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_ROP_NALB_ENQ_RO_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_rop_nalb_enq_ro_push_data ) )
) i_fifo_rop_nalb_enq_ro (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_rop_nalb_enq_ro_if_cfg_high_wm )
  , .fifo_status                        ( fifo_rop_nalb_enq_ro_if_status )
  , .fifo_full                          ( fifo_rop_nalb_enq_ro_full_nc )
  , .fifo_afull                         ( fifo_rop_nalb_enq_ro_afull )
  , .fifo_empty                         ( fifo_rop_nalb_enq_ro_empty )
  , .push                               ( fifo_rop_nalb_enq_ro_push )
  , .push_data                          ( { fifo_rop_nalb_enq_ro_push_data } )
  , .pop                                ( fifo_rop_nalb_enq_ro_pop )
  , .pop_data                           ( { wire_fifo_rop_nalb_enq_ro_pop_data } )
  , .mem_we                             ( func_rop_nalb_enq_ro_we )
  , .mem_waddr                          ( func_rop_nalb_enq_ro_waddr )
  , .mem_wdata                          ( func_rop_nalb_enq_ro_wdata )
  , .mem_re                             ( func_rop_nalb_enq_ro_re )
  , .mem_raddr                          ( func_rop_nalb_enq_ro_raddr )
  , .mem_rdata                          ( func_rop_nalb_enq_ro_rdata )
) ;

assign fifo_rop_nalb_enq_ro_pop_data.cmd = wire_fifo_rop_nalb_enq_ro_pop_data.cmd ;
assign fifo_rop_nalb_enq_ro_pop_data.cq = { 1'b0 , wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 6 : 0 ] } ;
assign fifo_rop_nalb_enq_ro_pop_data.flid = wire_fifo_rop_nalb_enq_ro_pop_data.flid ;
assign fifo_rop_nalb_enq_ro_pop_data.flid_parity = wire_fifo_rop_nalb_enq_ro_pop_data.flid_parity ;
assign fifo_rop_nalb_enq_ro_pop_data.hist_list_info = wire_fifo_rop_nalb_enq_ro_pop_data.hist_list_info ;
assign fifo_rop_nalb_enq_ro_pop_data.frag_list_info = wire_fifo_rop_nalb_enq_ro_pop_data.frag_list_info ;

assign fifo_rop_nalb_enq_ro_pop_data_parity_error = ( fifo_rop_nalb_enq_ro_pop 
                                                    & ( ~ ( wire_fifo_rop_nalb_enq_ro_pop_data.cmd [ 0 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cmd [ 1 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cmd [ 2 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 0 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 1 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 2 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 3 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 4 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 5 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 6 ] ^ wire_fifo_rop_nalb_enq_ro_pop_data.cq [ 7 ]  ) )
                                                    ) ;

// FIFO for lsp_nalb_sch_unoord interface used to schedule nalbect HCW
assign fifo_lsp_nalb_sch_unoord_error_of = fifo_lsp_nalb_sch_if_status [ 1 ] ;
assign fifo_lsp_nalb_sch_unoord_error_uf = fifo_lsp_nalb_sch_if_status [ 0 ] ;
assign fifo_lsp_nalb_sch_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_f [ HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_nxt = { fifo_lsp_nalb_sch_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_LSP_NALB_SCH_UNOORD_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_lsp_nalb_sch_unoord_push_data ) )
) i_fifo_lsp_nalb_sch_unoord (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_lsp_nalb_sch_if_cfg_high_wm )
  , .fifo_status                        ( fifo_lsp_nalb_sch_if_status )
  , .fifo_full                          ( fifo_lsp_nalb_sch_unoord_full_nc )
  , .fifo_afull                         ( fifo_lsp_nalb_sch_unoord_afull )
  , .fifo_empty                         ( fifo_lsp_nalb_sch_unoord_empty )
  , .push                               ( fifo_lsp_nalb_sch_unoord_push )
  , .push_data                          ( { fifo_lsp_nalb_sch_unoord_push_data } )
  , .pop                                ( fifo_lsp_nalb_sch_unoord_pop )
  , .pop_data                           ( { fifo_lsp_nalb_sch_unoord_pop_data } )
  , .mem_we                             ( func_lsp_nalb_sch_unoord_we )
  , .mem_waddr                          ( func_lsp_nalb_sch_unoord_waddr )
  , .mem_wdata                          ( func_lsp_nalb_sch_unoord_wdata )
  , .mem_re                             ( func_lsp_nalb_sch_unoord_re )
  , .mem_raddr                          ( func_lsp_nalb_sch_unoord_raddr )
  , .mem_rdata                          ( func_lsp_nalb_sch_unoord_rdata )
) ;

// FIFO for lsp_nalb_sch_rorply interface used to schedule nalbect replay list
assign fifo_lsp_nalb_sch_rorply_error_of = fifo_lsp_nalb_sch_rorply_if_status [ 1 ] ;
assign fifo_lsp_nalb_sch_rorply_error_uf = fifo_lsp_nalb_sch_rorply_if_status [ 0 ] ;
assign fifo_lsp_nalb_sch_rorply_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_f [ HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_nxt = { fifo_lsp_nalb_sch_rorply_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_rorply_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_LSP_NALB_SCH_RORPLY_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_lsp_nalb_sch_rorply_push_data ) )
) i_fifo_lsp_nalb_sch_rorply (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_lsp_nalb_sch_rorply_if_cfg_high_wm )
  , .fifo_status                        ( fifo_lsp_nalb_sch_rorply_if_status )
  , .fifo_full                          ( fifo_lsp_nalb_sch_rorply_full_nc )
  , .fifo_afull                         ( fifo_lsp_nalb_sch_rorply_afull )
  , .fifo_empty                         ( fifo_lsp_nalb_sch_rorply_empty )
  , .push                               ( fifo_lsp_nalb_sch_rorply_push )
  , .push_data                          ( { fifo_lsp_nalb_sch_rorply_push_data } )
  , .pop                                ( fifo_lsp_nalb_sch_rorply_pop )
  , .pop_data                           ( { fifo_lsp_nalb_sch_rorply_pop_data } )
  , .mem_we                             ( func_lsp_nalb_sch_rorply_we )
  , .mem_waddr                          ( func_lsp_nalb_sch_rorply_waddr )
  , .mem_wdata                          ( func_lsp_nalb_sch_rorply_wdata )
  , .mem_re                             ( func_lsp_nalb_sch_rorply_re )
  , .mem_raddr                          ( func_lsp_nalb_sch_rorply_raddr )
  , .mem_rdata                          ( func_lsp_nalb_sch_rorply_rdata )
) ;

// FIFO
assign fifo_lsp_nalb_sch_atq_error_of = fifo_lsp_nalb_sch_atq_if_status [ 1 ] ;
assign fifo_lsp_nalb_sch_atq_error_uf = fifo_lsp_nalb_sch_atq_if_status [ 0 ] ;
assign fifo_lsp_nalb_sch_atq_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_f [ HQM_NALB_FIFO_NALB_ATQ_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_nxt = { fifo_lsp_nalb_sch_atq_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_lsp_nalb_sch_atq_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_NALB_ATQ_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_lsp_nalb_sch_atq_push_data ) )
) i_fifo_lsp_nalb_sch_atq (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_lsp_nalb_sch_atq_if_cfg_high_wm )
  , .fifo_status                        ( fifo_lsp_nalb_sch_atq_if_status )
  , .fifo_full                          ( fifo_lsp_nalb_sch_atq_full_nc )
  , .fifo_afull                         ( fifo_lsp_nalb_sch_atq_afull )
  , .fifo_empty                         ( fifo_lsp_nalb_sch_atq_empty )
  , .push                               ( fifo_lsp_nalb_sch_atq_push )
  , .push_data                          ( { fifo_lsp_nalb_sch_atq_push_data } )
  , .pop                                ( fifo_lsp_nalb_sch_atq_pop )
  , .pop_data                           ( { fifo_lsp_nalb_sch_atq_pop_data } )
  , .mem_we                             ( func_lsp_nalb_sch_atq_we )
  , .mem_waddr                          ( func_lsp_nalb_sch_atq_waddr )
  , .mem_wdata                          ( func_lsp_nalb_sch_atq_wdata )
  , .mem_re                             ( func_lsp_nalb_sch_atq_re )
  , .mem_raddr                          ( func_lsp_nalb_sch_atq_raddr )
  , .mem_rdata                          ( func_lsp_nalb_sch_atq_rdata )
) ;

// FIFO
assign fifo_nalb_qed_error_of = fifo_nalb_qed_if_status [ 1 ] ;
assign fifo_nalb_qed_error_uf = fifo_nalb_qed_if_status [ 0 ] ;
assign fifo_nalb_qed_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_f [ HQM_NALB_FIFO_NALB_QED_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_nxt = { fifo_nalb_qed_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_nalb_qed_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_NALB_QED_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_nalb_qed_push_data ) )
) i_fifo_nalb_qed_nalb (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_nalb_qed_if_cfg_high_wm )
  , .fifo_status                        ( fifo_nalb_qed_if_status )
  , .fifo_full                          ( fifo_nalb_qed_full_nc )
  , .fifo_afull                         ( fifo_nalb_qed_afull )
  , .fifo_empty                         ( fifo_nalb_qed_empty )
  , .push                               ( fifo_nalb_qed_push )
  , .push_data                          ( { fifo_nalb_qed_push_data } )
  , .pop                                ( fifo_nalb_qed_pop )
  , .pop_data                           ( { fifo_nalb_qed_pop_data } )
  , .mem_we                             ( func_nalb_qed_we )
  , .mem_waddr                          ( func_nalb_qed_waddr )
  , .mem_wdata                          ( func_nalb_qed_wdata )
  , .mem_re                             ( func_nalb_qed_re )
  , .mem_raddr                          ( func_nalb_qed_raddr )
  , .mem_rdata                          ( func_nalb_qed_rdata )
) ;

// FIFO
assign fifo_nalb_lsp_enq_lb_error_of = fifo_nalb_lsp_enq_dir_if_status [ 1 ] ;
assign fifo_nalb_lsp_enq_lb_error_uf = fifo_nalb_lsp_enq_dir_if_status [ 0 ] ;
assign fifo_nalb_lsp_enq_dir_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_f [ HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_nxt = { fifo_nalb_lsp_enq_dir_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_dir_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_NALB_LSP_ENQ_UNOORD_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_nalb_lsp_enq_lb_push_data ) )
) i_fifo_nalb_lsp_enq_lb (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_nalb_lsp_enq_dir_if_cfg_high_wm )
  , .fifo_status                        ( fifo_nalb_lsp_enq_dir_if_status )
  , .fifo_full                          ( fifo_nalb_lsp_enq_lb_full_nc )
  , .fifo_afull                         ( fifo_nalb_lsp_enq_lb_afull )
  , .fifo_empty                         ( fifo_nalb_lsp_enq_lb_empty )
  , .push                               ( fifo_nalb_lsp_enq_lb_push )
  , .push_data                          ( { fifo_nalb_lsp_enq_lb_push_data } )
  , .pop                                ( fifo_nalb_lsp_enq_lb_pop )
  , .pop_data                           ( { fifo_nalb_lsp_enq_lb_pop_data } )
  , .mem_we                             ( func_nalb_lsp_enq_unoord_we )
  , .mem_waddr                          ( func_nalb_lsp_enq_unoord_waddr )
  , .mem_wdata                          ( func_nalb_lsp_enq_unoord_wdata )
  , .mem_re                             ( func_nalb_lsp_enq_unoord_re )
  , .mem_raddr                          ( func_nalb_lsp_enq_unoord_raddr )
  , .mem_rdata                          ( func_nalb_lsp_enq_unoord_rdata )
) ;

// FIFO
assign fifo_nalb_lsp_enq_rorply_error_of = fifo_nalb_lsp_enq_rorply_if_status [ 1 ] ;
assign fifo_nalb_lsp_enq_rorply_error_uf = fifo_nalb_lsp_enq_rorply_if_status [ 0 ] ;
assign fifo_nalb_lsp_enq_rorply_if_cfg_high_wm = hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_f [ HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_WMWIDTH - 1 : 0 ] ;
assign hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_nxt = { fifo_nalb_lsp_enq_rorply_if_status [ 23 : 0 ] , hqm_nalb_target_cfg_fifo_wmstat_nalb_lsp_enq_rorply_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_NALB_FIFO_NALB_LSP_ENQ_RORPLY_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_nalb_lsp_enq_rorply_push_data ) )
) i_fifo_nalb_lsp_enq_rorply_nalb (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_nalb_lsp_enq_rorply_if_cfg_high_wm )
  , .fifo_status                        ( fifo_nalb_lsp_enq_rorply_if_status )
  , .fifo_full                          ( fifo_nalb_lsp_enq_rorply_full_nc )
  , .fifo_afull                         ( fifo_nalb_lsp_enq_rorply_afull )
  , .fifo_empty                         ( fifo_nalb_lsp_enq_rorply_empty )
  , .push                               ( fifo_nalb_lsp_enq_rorply_push )
  , .push_data                          ( { fifo_nalb_lsp_enq_rorply_push_data } )
  , .pop                                ( fifo_nalb_lsp_enq_rorply_pop )
  , .pop_data                           ( { fifo_nalb_lsp_enq_rorply_pop_data } )
  , .mem_we                             ( func_nalb_lsp_enq_rorply_we )
  , .mem_waddr                          ( func_nalb_lsp_enq_rorply_waddr )
  , .mem_wdata                          ( func_nalb_lsp_enq_rorply_wdata )
  , .mem_re                             ( func_nalb_lsp_enq_rorply_re )
  , .mem_raddr                          ( func_nalb_lsp_enq_rorply_raddr )
  , .mem_rdata                          ( func_nalb_lsp_enq_rorply_rdata )
) ;


//....................................................................................................
// ARB
hqm_AW_rr_arb # (
    .NUM_REQS ( 2 )
) i_arb_nalb (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .reqs                               ( arb_nalb_reqs )
  , .update                             ( arb_nalb_update )
  , .winner_v                           ( arb_nalb_winner_v )
  , .winner                             ( arb_nalb_winner )
) ;

hqm_AW_rr_arb # (
    .NUM_REQS ( 2 )
) i_arb_atq (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .reqs                               ( arb_atq_reqs )
  , .update                             ( arb_atq_update )
  , .winner_v                           ( arb_atq_winner_v )
  , .winner                             ( arb_atq_winner )
) ;

hqm_AW_rr_arb # (
    .NUM_REQS ( 3 )
) i_arb_ro (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .reqs                               ( arb_ro_reqs )
  , .update                             ( arb_ro_update )
  , .winner_v                           ( arb_ro_winner_v )
  , .winner                             ( arb_ro_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 8 )
) i_arb_nalb_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control8_f [ 31 : 24 ] , cfg_control8_f [ 23 : 16 ] , cfg_control8_f [ 15 : 8 ] , cfg_control8_f [ 7 : 0 ] , cfg_control7_f [ 31 : 24 ] , cfg_control7_f [ 23 : 16 ] , cfg_control7_f [ 15 : 8 ] , cfg_control7_f [ 7 : 0 ] } )
  , .reqs                               ( arb_nalb_cnt_reqs )
  , .winner_v                           ( arb_nalb_cnt_winner_v )
  , .winner                             ( arb_nalb_cnt_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 8 )
) i_arb_atq_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control6_f [ 31 : 24 ] , cfg_control6_f [ 23 : 16 ] , cfg_control6_f [ 15 : 8 ] , cfg_control6_f [ 7 : 0 ] , cfg_control5_f [ 31 : 24 ] , cfg_control5_f [ 23 : 16 ] , cfg_control5_f [ 15 : 8 ] , cfg_control5_f [ 7 : 0 ] } )
  , .reqs                               ( arb_atq_cnt_reqs )
  , .winner_v                           ( arb_atq_cnt_winner_v )
  , .winner                             ( arb_atq_cnt_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 8 )
) i_arb_replay_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control4_f [ 31 : 24 ] , cfg_control4_f [ 23 : 16 ] , cfg_control4_f [ 15 : 8 ] , cfg_control4_f [ 7 : 0 ] , cfg_control3_f [ 31 : 24 ] , cfg_control3_f [ 23 : 16 ] , cfg_control3_f [ 15 : 8 ] , cfg_control3_f [ 7 : 0 ] } )
  , .reqs                               ( arb_replay_cnt_reqs )
  , .winner_v                           ( arb_replay_cnt_winner_v )
  , .winner                             ( arb_replay_cnt_winner )
) ;

hqm_AW_rr_arb # (
    .NUM_REQS ( 3 )
) i_arb_nxthp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .reqs                               ( arb_nxthp_reqs )
  , .update                             ( arb_nxthp_update )
  , .winner_v                           ( arb_nxthp_winner_v )
  , .winner                             ( arb_nxthp_winner )
) ;

//....................................................................................................
// RAM RW or RMW pipe
logic [ ( 136 ) - 1 : 0 ] wire_func_nalb_cnt_wdata ;
logic [ ( 136 ) - 1 : 0 ] wire_func_nalb_cnt_rdata ;
assign func_nalb_cnt_wdata = { wire_func_nalb_cnt_wdata [ 127 : 120 ] , wire_func_nalb_cnt_wdata [ 59 : 0 ] } ;
assign wire_func_nalb_cnt_rdata = { 8'd0 , func_nalb_cnt_rdata [ 67 : 60 ] , 60'd0 ,func_nalb_cnt_rdata [ 59 : 0 ] } ;
hqm_AW_rmw_mem_4pipe # (
    .DEPTH                              ( HQM_NALB_RAM_UNOORD_CNT_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_UNOORD_CNT_WIDTH )
) i_rmw_nalb_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_nalb_cnt_status )

  , .p0_v_nxt                           ( rmw_nalb_cnt_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_nalb_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_nalb_cnt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_nalb_cnt_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_nalb_cnt_p0_hold )
  , .p0_v_f                             ( rmw_nalb_cnt_p0_v_f )
  , .p0_rw_f                            ( rmw_nalb_cnt_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_nalb_cnt_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_nalb_cnt_p0_data_f_nc )

  , .p1_hold                            ( rmw_nalb_cnt_p1_hold )
  , .p1_v_f                             ( rmw_nalb_cnt_p1_v_f )
  , .p1_rw_f                            ( rmw_nalb_cnt_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_nalb_cnt_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_nalb_cnt_p1_data_f_nc )

  , .p2_hold                            ( rmw_nalb_cnt_p2_hold )
  , .p2_v_f                             ( rmw_nalb_cnt_p2_v_f )
  , .p2_rw_f                            ( rmw_nalb_cnt_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_nalb_cnt_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_nalb_cnt_p2_data_f )

  , .p3_hold                            ( rmw_nalb_cnt_p3_hold )
  , .p3_bypsel_nxt                      ( rmw_nalb_cnt_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_nalb_cnt_p3_bypdata_nxt )
  , .p3_v_f                             ( rmw_nalb_cnt_p3_v_f )
  , .p3_rw_f                            ( rmw_nalb_cnt_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_nalb_cnt_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_nalb_cnt_p3_data_f_nc )

  , .mem_write                          ( func_nalb_cnt_we )
  , .mem_read                           ( func_nalb_cnt_re )
  , .mem_write_addr                     ( func_nalb_cnt_waddr )
  , .mem_read_addr                      ( func_nalb_cnt_raddr )
  , .mem_write_data                     ( wire_func_nalb_cnt_wdata )
  , .mem_read_data                      ( wire_func_nalb_cnt_rdata )
) ;

// uncomment for 8K credits
/*
logic func_nalb_hp_rdata_14_nc ;

assign func_nalb_hp_wdata [ 14 ] = 1'b0 ;
assign func_nalb_hp_rdata_14_nc = func_nalb_hp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_UNOORD_HP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_UNOORD_HP_WIDTH )
) i_rmw_nalb_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_nalb_hp_status )

  , .p0_v_nxt                           ( rmw_nalb_hp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_nalb_hp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_nalb_hp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_nalb_hp_p0_write_data_nxt )
  , .p0_hold                            ( rmw_nalb_hp_p0_hold )
  , .p0_v_f                             ( rmw_nalb_hp_p0_v_f )
  , .p0_rw_f                            ( rmw_nalb_hp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_nalb_hp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_nalb_hp_p0_data_f_nc )

  , .p1_hold                            ( rmw_nalb_hp_p1_hold )
  , .p1_v_f                             ( rmw_nalb_hp_p1_v_f )
  , .p1_rw_f                            ( rmw_nalb_hp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_nalb_hp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_nalb_hp_p1_data_f_nc )

  , .p2_hold                            ( rmw_nalb_hp_p2_hold )
  , .p2_v_f                             ( rmw_nalb_hp_p2_v_f )
  , .p2_rw_f                            ( rmw_nalb_hp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_nalb_hp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_nalb_hp_p2_data_f )

  , .p3_hold                            ( rmw_nalb_hp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_nalb_hp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_nalb_hp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_nalb_hp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_nalb_hp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_nalb_hp_p3_v_f )
  , .p3_rw_f                            ( rmw_nalb_hp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_nalb_hp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_nalb_hp_p3_data_f_nc )

  , .mem_write                          ( func_nalb_hp_we )
  , .mem_read                           ( func_nalb_hp_re )
  , .mem_write_addr                     ( func_nalb_hp_waddr )
  , .mem_read_addr                      ( func_nalb_hp_raddr )
  , .mem_write_data                     ( func_nalb_hp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_nalb_hp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;

// uncomment for 8K credits
/*
logic func_nalb_tp_rdata_14_nc ;

assign func_nalb_tp_wdata [ 14 ] = 1'b0 ;
assign func_nalb_tp_rdata_14_nc = func_nalb_tp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_UNOORD_TP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_UNOORD_TP_WIDTH )
) i_rmw_nalb_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_nalb_tp_status )

  , .p0_v_nxt                           ( rmw_nalb_tp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_nalb_tp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_nalb_tp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_nalb_tp_p0_write_data_nxt )
  , .p0_hold                            ( rmw_nalb_tp_p0_hold )
  , .p0_v_f                             ( rmw_nalb_tp_p0_v_f )
  , .p0_rw_f                            ( rmw_nalb_tp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_nalb_tp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_nalb_tp_p0_data_f_nc )

  , .p1_hold                            ( rmw_nalb_tp_p1_hold )
  , .p1_v_f                             ( rmw_nalb_tp_p1_v_f )
  , .p1_rw_f                            ( rmw_nalb_tp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_nalb_tp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_nalb_tp_p1_data_f_nc )

  , .p2_hold                            ( rmw_nalb_tp_p2_hold )
  , .p2_v_f                             ( rmw_nalb_tp_p2_v_f )
  , .p2_rw_f                            ( rmw_nalb_tp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_nalb_tp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_nalb_tp_p2_data_f )

  , .p3_hold                            ( rmw_nalb_tp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_nalb_tp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_nalb_tp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_nalb_tp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_nalb_tp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_nalb_tp_p3_v_f )
  , .p3_rw_f                            ( rmw_nalb_tp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_nalb_tp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_nalb_tp_p3_data_f_nc )

  , .mem_write                          ( func_nalb_tp_we )
  , .mem_read                           ( func_nalb_tp_re )
  , .mem_write_addr                     ( func_nalb_tp_waddr )
  , .mem_read_addr                      ( func_nalb_tp_raddr )
  , .mem_write_data                     ( func_nalb_tp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_nalb_tp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;





logic [ ( 136 ) - 1 : 0 ] wire_func_atq_cnt_wdata ;
logic [ ( 136 ) - 1 : 0 ] wire_func_atq_cnt_rdata ;
assign func_atq_cnt_wdata = { wire_func_atq_cnt_wdata [ 127 : 120 ] , wire_func_atq_cnt_wdata [ 59 : 0 ] } ;
assign wire_func_atq_cnt_rdata = { 8'd0 , func_atq_cnt_rdata [ 67 : 60 ] , 60'd0 ,func_atq_cnt_rdata [ 59 : 0 ] } ;
hqm_AW_rmw_mem_4pipe # (
    .DEPTH                              ( HQM_NALB_RAM_ATQ_CNT_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_ATQ_CNT_WIDTH )
) i_rmw_atq_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_atq_cnt_status )

  , .p0_v_nxt                           ( rmw_atq_cnt_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_atq_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_atq_cnt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_atq_cnt_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_atq_cnt_p0_hold )
  , .p0_v_f                             ( rmw_atq_cnt_p0_v_f )
  , .p0_rw_f                            ( rmw_atq_cnt_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_atq_cnt_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_atq_cnt_p0_data_f_nc )

  , .p1_hold                            ( rmw_atq_cnt_p1_hold )
  , .p1_v_f                             ( rmw_atq_cnt_p1_v_f )
  , .p1_rw_f                            ( rmw_atq_cnt_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_atq_cnt_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_atq_cnt_p1_data_f_nc )

  , .p2_hold                            ( rmw_atq_cnt_p2_hold )
  , .p2_v_f                             ( rmw_atq_cnt_p2_v_f )
  , .p2_rw_f                            ( rmw_atq_cnt_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_atq_cnt_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_atq_cnt_p2_data_f )

  , .p3_hold                            ( rmw_atq_cnt_p3_hold )
  , .p3_bypsel_nxt                      ( rmw_atq_cnt_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_atq_cnt_p3_bypdata_nxt )
  , .p3_v_f                             ( rmw_atq_cnt_p3_v_f )
  , .p3_rw_f                            ( rmw_atq_cnt_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_atq_cnt_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_atq_cnt_p3_data_f_nc )

  , .mem_write                          ( func_atq_cnt_we )
  , .mem_read                           ( func_atq_cnt_re )
  , .mem_write_addr                     ( func_atq_cnt_waddr )
  , .mem_read_addr                      ( func_atq_cnt_raddr )
  , .mem_write_data                     ( wire_func_atq_cnt_wdata )
  , .mem_read_data                      ( wire_func_atq_cnt_rdata )
) ;

// uncomment for 8K credits
/*
logic func_atq_hp_rdata_14_nc ;

assign func_atq_hp_wdata [ 14 ] = 1'b0 ;
assign func_atq_hp_rdata_14_nc = func_atq_hp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_ATQ_HP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_ATQ_HP_WIDTH )
) i_rmw_atq_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_atq_hp_status )

  , .p0_v_nxt                           ( rmw_atq_hp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_atq_hp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_atq_hp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_atq_hp_p0_write_data_nxt )
  , .p0_hold                            ( rmw_atq_hp_p0_hold )
  , .p0_v_f                             ( rmw_atq_hp_p0_v_f )
  , .p0_rw_f                            ( rmw_atq_hp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_atq_hp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_atq_hp_p0_data_f_nc )

  , .p1_hold                            ( rmw_atq_hp_p1_hold )
  , .p1_v_f                             ( rmw_atq_hp_p1_v_f )
  , .p1_rw_f                            ( rmw_atq_hp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_atq_hp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_atq_hp_p1_data_f_nc )

  , .p2_hold                            ( rmw_atq_hp_p2_hold )
  , .p2_v_f                             ( rmw_atq_hp_p2_v_f )
  , .p2_rw_f                            ( rmw_atq_hp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_atq_hp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_atq_hp_p2_data_f )

  , .p3_hold                            ( rmw_atq_hp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_atq_hp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_atq_hp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_atq_hp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_atq_hp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_atq_hp_p3_v_f )
  , .p3_rw_f                            ( rmw_atq_hp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_atq_hp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_atq_hp_p3_data_f_nc )

  , .mem_write                          ( func_atq_hp_we )
  , .mem_read                           ( func_atq_hp_re )
  , .mem_write_addr                     ( func_atq_hp_waddr )
  , .mem_read_addr                      ( func_atq_hp_raddr )
  , .mem_write_data                     ( func_atq_hp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_atq_hp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;

// uncomment for 8K credits
/*
logic func_atq_tp_rdata_14_nc ;

assign func_atq_tp_wdata [ 14 ] = 1'b0 ;
assign func_atq_tp_rdata_14_nc = func_atq_tp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_ATQ_TP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_ATQ_TP_WIDTH )
) i_rmw_atq_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_atq_tp_status )

  , .p0_v_nxt                           ( rmw_atq_tp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_atq_tp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_atq_tp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_atq_tp_p0_write_data_nxt )
  , .p0_hold                            ( rmw_atq_tp_p0_hold )
  , .p0_v_f                             ( rmw_atq_tp_p0_v_f )
  , .p0_rw_f                            ( rmw_atq_tp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_atq_tp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_atq_tp_p0_data_f_nc )

  , .p1_hold                            ( rmw_atq_tp_p1_hold )
  , .p1_v_f                             ( rmw_atq_tp_p1_v_f )
  , .p1_rw_f                            ( rmw_atq_tp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_atq_tp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_atq_tp_p1_data_f_nc )

  , .p2_hold                            ( rmw_atq_tp_p2_hold )
  , .p2_v_f                             ( rmw_atq_tp_p2_v_f )
  , .p2_rw_f                            ( rmw_atq_tp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_atq_tp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_atq_tp_p2_data_f )

  , .p3_hold                            ( rmw_atq_tp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_atq_tp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_atq_tp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_atq_tp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_atq_tp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_atq_tp_p3_v_f )
  , .p3_rw_f                            ( rmw_atq_tp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_atq_tp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_atq_tp_p3_data_f_nc )

  , .mem_write                          ( func_atq_tp_we )
  , .mem_read                           ( func_atq_tp_re )
  , .mem_write_addr                     ( func_atq_tp_waddr )
  , .mem_read_addr                      ( func_atq_tp_raddr )
  , .mem_write_data                     ( func_atq_tp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_atq_tp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;

hqm_AW_rmw_mem_4pipe # (
    .DEPTH                              ( HQM_NALB_RAM_ROFRAG_CNT_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_ROFRAG_CNT_WIDTH )
) i_rmw_rofrag_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_rofrag_cnt_status )

  , .p0_v_nxt                           ( rmw_rofrag_cnt_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_rofrag_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_rofrag_cnt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_rofrag_cnt_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_rofrag_cnt_p0_hold )
  , .p0_v_f                             ( rmw_rofrag_cnt_p0_v_f )
  , .p0_rw_f                            ( rmw_rofrag_cnt_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_rofrag_cnt_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_rofrag_cnt_p0_data_f_nc )

  , .p1_hold                            ( rmw_rofrag_cnt_p1_hold )
  , .p1_v_f                             ( rmw_rofrag_cnt_p1_v_f )
  , .p1_rw_f                            ( rmw_rofrag_cnt_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_rofrag_cnt_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_rofrag_cnt_p1_data_f_nc )

  , .p2_hold                            ( rmw_rofrag_cnt_p2_hold )
  , .p2_v_f                             ( rmw_rofrag_cnt_p2_v_f )
  , .p2_rw_f                            ( rmw_rofrag_cnt_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_rofrag_cnt_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_rofrag_cnt_p2_data_f )

  , .p3_hold                            ( rmw_rofrag_cnt_p3_hold )
  , .p3_bypsel_nxt                      ( rmw_rofrag_cnt_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_rofrag_cnt_p3_bypdata_nxt )
  , .p3_v_f                             ( rmw_rofrag_cnt_p3_v_f )
  , .p3_rw_f                            ( rmw_rofrag_cnt_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_rofrag_cnt_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_rofrag_cnt_p3_data_f_nc )

  , .mem_write                          ( func_nalb_rofrag_cnt_we )
  , .mem_read                           ( func_nalb_rofrag_cnt_re )
  , .mem_write_addr                     ( func_nalb_rofrag_cnt_waddr )
  , .mem_read_addr                      ( func_nalb_rofrag_cnt_raddr )
  , .mem_write_data                     ( func_nalb_rofrag_cnt_wdata )
  , .mem_read_data                      ( func_nalb_rofrag_cnt_rdata )
) ;

// uncomment for 8K credits
/*
logic func_nalb_rofrag_hp_rdata_14_nc ;

assign func_nalb_rofrag_hp_wdata [ 14 ] = 1'b0 ;
assign func_nalb_rofrag_hp_rdata_14_nc = func_nalb_rofrag_hp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_ROFRAG_HP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_ROFRAG_HP_WIDTH )
) i_rmw_rofrag_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_rofrag_hp_status )

  , .p0_v_nxt                           ( rmw_rofrag_hp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_rofrag_hp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_rofrag_hp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_rofrag_hp_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_rofrag_hp_p0_hold )
  , .p0_v_f                             ( rmw_rofrag_hp_p0_v_f )
  , .p0_rw_f                            ( rmw_rofrag_hp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_rofrag_hp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_rofrag_hp_p0_data_f_nc )

  , .p1_hold                            ( rmw_rofrag_hp_p1_hold )
  , .p1_v_f                             ( rmw_rofrag_hp_p1_v_f )
  , .p1_rw_f                            ( rmw_rofrag_hp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_rofrag_hp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_rofrag_hp_p1_data_f_nc )

  , .p2_hold                            ( rmw_rofrag_hp_p2_hold )
  , .p2_v_f                             ( rmw_rofrag_hp_p2_v_f )
  , .p2_rw_f                            ( rmw_rofrag_hp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_rofrag_hp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_rofrag_hp_p2_data_f )

  , .p3_hold                            ( rmw_rofrag_hp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_rofrag_hp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_rofrag_hp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_rofrag_hp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_rofrag_hp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_rofrag_hp_p3_v_f )
  , .p3_rw_f                            ( rmw_rofrag_hp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_rofrag_hp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_rofrag_hp_p3_data_f_nc )

  , .mem_write                          ( func_nalb_rofrag_hp_we )
  , .mem_read                           ( func_nalb_rofrag_hp_re )
  , .mem_write_addr                     ( func_nalb_rofrag_hp_waddr )
  , .mem_read_addr                      ( func_nalb_rofrag_hp_raddr )
  , .mem_write_data                     ( func_nalb_rofrag_hp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_nalb_rofrag_hp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;

// uncomment for 8K credits
/*
logic func_nalb_rofrag_tp_rdata_14_nc ;

assign func_nalb_rofrag_tp_wdata [ 14 ] = 1'b0 ;
assign func_nalb_rofrag_tp_rdata_14_nc = func_nalb_rofrag_tp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_ROFRAG_TP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_ROFRAG_TP_WIDTH )
) i_rmw_rofrag_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_rofrag_tp_status )

  , .p0_v_nxt                           ( rmw_rofrag_tp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_rofrag_tp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_rofrag_tp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_rofrag_tp_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_rofrag_tp_p0_hold )
  , .p0_v_f                             ( rmw_rofrag_tp_p0_v_f )
  , .p0_rw_f                            ( rmw_rofrag_tp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_rofrag_tp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_rofrag_tp_p0_data_f_nc )

  , .p1_hold                            ( rmw_rofrag_tp_p1_hold )
  , .p1_v_f                             ( rmw_rofrag_tp_p1_v_f )
  , .p1_rw_f                            ( rmw_rofrag_tp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_rofrag_tp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_rofrag_tp_p1_data_f_nc )

  , .p2_hold                            ( rmw_rofrag_tp_p2_hold )
  , .p2_v_f                             ( rmw_rofrag_tp_p2_v_f )
  , .p2_rw_f                            ( rmw_rofrag_tp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_rofrag_tp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_rofrag_tp_p2_data_f )

  , .p3_hold                            ( rmw_rofrag_tp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_rofrag_tp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_rofrag_tp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_rofrag_tp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_rofrag_tp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_rofrag_tp_p3_v_f )
  , .p3_rw_f                            ( rmw_rofrag_tp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_rofrag_tp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_rofrag_tp_p3_data_f_nc )

  , .mem_write                          ( func_nalb_rofrag_tp_we )
  , .mem_read                           ( func_nalb_rofrag_tp_re )
  , .mem_write_addr                     ( func_nalb_rofrag_tp_waddr )
  , .mem_read_addr                      ( func_nalb_rofrag_tp_raddr )
  , .mem_write_data                     ( func_nalb_rofrag_tp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_nalb_rofrag_tp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;

logic [ ( 136 ) - 1 : 0 ] wire_func_nalb_replay_cnt_wdata ;
logic [ ( 136 ) - 1 : 0 ] wire_func_nalb_replay_cnt_rdata ;
assign func_nalb_replay_cnt_wdata = { wire_func_nalb_replay_cnt_wdata [ 127 : 120 ] , wire_func_nalb_replay_cnt_wdata [ 59 : 0 ] } ;
assign wire_func_nalb_replay_cnt_rdata = { 8'd0 , func_nalb_replay_cnt_rdata [ 67 : 60 ] , 60'd0 ,func_nalb_replay_cnt_rdata [ 59 : 0 ] } ;
hqm_AW_rmw_mem_4pipe # (
    .DEPTH                              ( HQM_NALB_RAM_REPLAY_CNT_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_REPLAY_CNT_WIDTH )
) i_rmw_replay_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_replay_cnt_status )

  , .p0_v_nxt                           ( rmw_replay_cnt_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_replay_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_replay_cnt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_replay_cnt_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_replay_cnt_p0_hold )
  , .p0_v_f                             ( rmw_replay_cnt_p0_v_f )
  , .p0_rw_f                            ( rmw_replay_cnt_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_replay_cnt_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_replay_cnt_p0_data_f_nc )

  , .p1_hold                            ( rmw_replay_cnt_p1_hold )
  , .p1_v_f                             ( rmw_replay_cnt_p1_v_f )
  , .p1_rw_f                            ( rmw_replay_cnt_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_replay_cnt_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_replay_cnt_p1_data_f_nc )

  , .p2_hold                            ( rmw_replay_cnt_p2_hold )
  , .p2_v_f                             ( rmw_replay_cnt_p2_v_f )
  , .p2_rw_f                            ( rmw_replay_cnt_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_replay_cnt_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_replay_cnt_p2_data_f )

  , .p3_hold                            ( rmw_replay_cnt_p3_hold )
  , .p3_bypsel_nxt                      ( rmw_replay_cnt_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_replay_cnt_p3_bypdata_nxt )
  , .p3_v_f                             ( rmw_replay_cnt_p3_v_f )
  , .p3_rw_f                            ( rmw_replay_cnt_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_replay_cnt_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_replay_cnt_p3_data_f_nc )

  , .mem_write                          ( func_nalb_replay_cnt_we )
  , .mem_read                           ( func_nalb_replay_cnt_re )
  , .mem_write_addr                     ( func_nalb_replay_cnt_waddr )
  , .mem_read_addr                      ( func_nalb_replay_cnt_raddr )
  , .mem_write_data                     ( wire_func_nalb_replay_cnt_wdata )
  , .mem_read_data                      ( wire_func_nalb_replay_cnt_rdata )
) ;

// uncomment for 8K credits
/*
logic func_nalb_replay_hp_rdata_14_nc ;

assign func_nalb_replay_hp_wdata [ 14 ] = 1'b0 ;
assign func_nalb_replay_hp_rdata_14_nc = func_nalb_replay_hp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_REPLAY_HP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_REPLAY_HP_WIDTH )
) i_rmw_replay_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_replay_hp_status )

  , .p0_v_nxt                           ( rmw_replay_hp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_replay_hp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_replay_hp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_replay_hp_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_replay_hp_p0_hold )
  , .p0_v_f                             ( rmw_replay_hp_p0_v_f )
  , .p0_rw_f                            ( rmw_replay_hp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_replay_hp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_replay_hp_p0_data_f_nc )

  , .p1_hold                            ( rmw_replay_hp_p1_hold )
  , .p1_v_f                             ( rmw_replay_hp_p1_v_f )
  , .p1_rw_f                            ( rmw_replay_hp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_replay_hp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_replay_hp_p1_data_f_nc )

  , .p2_hold                            ( rmw_replay_hp_p2_hold )
  , .p2_v_f                             ( rmw_replay_hp_p2_v_f )
  , .p2_rw_f                            ( rmw_replay_hp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_replay_hp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_replay_hp_p2_data_f )

  , .p3_hold                            ( rmw_replay_hp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_replay_hp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_replay_hp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_replay_hp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_replay_hp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_replay_hp_p3_v_f )
  , .p3_rw_f                            ( rmw_replay_hp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_replay_hp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_replay_hp_p3_data_f_nc )

  , .mem_write                          ( func_nalb_replay_hp_we )
  , .mem_read                           ( func_nalb_replay_hp_re )
  , .mem_write_addr                     ( func_nalb_replay_hp_waddr )
  , .mem_read_addr                      ( func_nalb_replay_hp_raddr )
  , .mem_write_data                     ( func_nalb_replay_hp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_nalb_replay_hp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;

// uncomment for 8K credits
/*
logic func_nalb_replay_tp_rdata_14_nc ;

assign func_nalb_replay_tp_wdata [ 14 ] = 1'b0 ;
assign func_nalb_replay_tp_rdata_14_nc = func_nalb_replay_tp_rdata [ 14 ] ;  
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_NALB_RAM_REPLAY_TP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_REPLAY_TP_WIDTH )
) i_rmw_replay_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_replay_tp_status )

  , .p0_v_nxt                           ( rmw_replay_tp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_replay_tp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_replay_tp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_replay_tp_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_replay_tp_p0_hold )
  , .p0_v_f                             ( rmw_replay_tp_p0_v_f )
  , .p0_rw_f                            ( rmw_replay_tp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_replay_tp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_replay_tp_p0_data_f_nc )

  , .p1_hold                            ( rmw_replay_tp_p1_hold )
  , .p1_v_f                             ( rmw_replay_tp_p1_v_f )
  , .p1_rw_f                            ( rmw_replay_tp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_replay_tp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_replay_tp_p1_data_f_nc )

  , .p2_hold                            ( rmw_replay_tp_p2_hold )
  , .p2_v_f                             ( rmw_replay_tp_p2_v_f )
  , .p2_rw_f                            ( rmw_replay_tp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_replay_tp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_replay_tp_p2_data_f )

  , .p3_hold                            ( rmw_replay_tp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_replay_tp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_replay_tp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_replay_tp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_replay_tp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_replay_tp_p3_v_f )
  , .p3_rw_f                            ( rmw_replay_tp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_replay_tp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_replay_tp_p3_data_f_nc )

  , .mem_write                          ( func_nalb_replay_tp_we )
  , .mem_read                           ( func_nalb_replay_tp_re )
  , .mem_write_addr                     ( func_nalb_replay_tp_waddr )
  , .mem_read_addr                      ( func_nalb_replay_tp_raddr )
  , .mem_write_data                     ( func_nalb_replay_tp_wdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_nalb_replay_tp_rdata [ HQM_NALB_QED_DEPTHB2 : 0 ] )
) ;
//compress to save area
logic [ ( 21 ) - 1 : 0 ] wire_func_nalb_nxthp_wdata ;
logic [ ( 21 ) - 1 : 0 ] wire_func_nalb_nxthp_rdata ;
assign func_nalb_nxthp_wdata = { 1'b0 , wire_func_nalb_nxthp_wdata [ 20 : 15 ] , wire_func_nalb_nxthp_wdata [ 14 : 0 ] } ;
//FIX when nalb datapad removed assign func_nalb_nxthp_wdata = { 1'b0, wire_func_nalb_nxthp_wdata [ 20 : 15 ] , wire_func_nalb_nxthp_wdata [ 13 : 0 ] } ;
assign wire_func_nalb_nxthp_rdata = { func_nalb_nxthp_rdata [ 20 : 15 ] , func_nalb_nxthp_rdata [ 14: 0 ] } ;

assign func_nalb_nxthp_we = wire_sr_nalb_nxthp_we & ~ stall ;
hqm_nalb_pipe_nxthp_rw_mem_4pipe_core # (
    .DEPTH                              ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTH )
  , .WIDTH                              ( HQM_NALB_RAM_UNOORD_NXTHP_WIDTH )
  , .DATA                               ( HQM_NALB_QED_DEPTHB2 )
  , .BLOCK_WRITE_ON_P0_HOLD ( 1 )
) i_rw_nxthp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rw_nxthp_status )

, .error_sb ( rw_nxthp_error_sb )
, .error_mb ( rw_nxthp_error_mb )
, .err_parity ( rw_nxthp_err_parity )

  , .p0_v_nxt                           ( rw_nxthp_p0_v_nxt )
  , .p0_rw_nxt                          ( rw_nxthp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rw_nxthp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rw_nxthp_p0_write_data_nxt )
  , .p0_byp_v_nxt                           ( rw_nxthp_p0_byp_v_nxt )
  , .p0_byp_rw_nxt                          ( rw_nxthp_p0_byp_rw_nxt )
  , .p0_byp_addr_nxt                        ( rw_nxthp_p0_byp_addr_nxt )
  , .p0_byp_write_data_nxt                  ( rw_nxthp_p0_byp_write_data_nxt )
  , .p0_hold                            ( rw_nxthp_p0_hold )
  , .p0_v_f                             ( rw_nxthp_p0_v_f )
  , .p0_rw_f                            ( rw_nxthp_p0_rw_f_nc )
  , .p0_addr_f                          ( rw_nxthp_p0_addr_f_nc )
  , .p0_data_f                          ( rw_nxthp_p0_data_f_nc )

  , .p1_hold                            ( rw_nxthp_p1_hold )
  , .p1_v_f                             ( rw_nxthp_p1_v_f )
  , .p1_rw_f                            ( rw_nxthp_p1_rw_f_nc )
  , .p1_addr_f                          ( rw_nxthp_p1_addr_f_nc )
  , .p1_data_f                          ( rw_nxthp_p1_data_f_nc )

  , .p2_hold                            ( rw_nxthp_p2_hold )
  , .p2_v_f                             ( rw_nxthp_p2_v_f )
  , .p2_rw_f                            ( rw_nxthp_p2_rw_f_nc )
  , .p2_addr_f                          ( rw_nxthp_p2_addr_f_nc )
  , .p2_data_f                          ( rw_nxthp_p2_data_f )

  , .p3_hold                            ( rw_nxthp_p3_hold )
  , .p3_v_f                             ( rw_nxthp_p3_v_f )
  , .p3_rw_f                            ( rw_nxthp_p3_rw_f_nc )
  , .p3_addr_f                          ( rw_nxthp_p3_addr_f_nc )
  , .p3_data_f                          ( rw_nxthp_p3_data_f_nc )

  , .mem_write                          ( wire_sr_nalb_nxthp_we )
  , .mem_read                           ( func_nalb_nxthp_re )
  , .mem_addr                           ( func_nalb_nxthp_addr )
  , .mem_write_data                     ( wire_func_nalb_nxthp_wdata )
  , .mem_read_data                      ( wire_func_nalb_nxthp_rdata )
) ;

//....................................................................................................
// CONTROL

// General CONTROL


assign hqm_nalb_target_cfg_patch_control_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_patch_control_reg_nxt = hqm_nalb_target_cfg_patch_control_reg_f ;

assign hqm_nalb_target_cfg_nalb_csr_control_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_nalb_csr_control_reg_nxt = cfg_csr_control_nxt ;
assign cfg_csr_control_f = hqm_nalb_target_cfg_nalb_csr_control_reg_f ;

assign hqm_nalb_target_cfg_control_general_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_control_general_reg_nxt = cfg_control0_nxt ;
assign cfg_control0_f = hqm_nalb_target_cfg_control_general_reg_f ;

assign hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt = cfg_control3_nxt ;
assign cfg_control3_f = hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_0_reg_f ;

assign hqm_nalb_target_cfg_control_arb_weights_tqpri_replay_1_status = 32'd0 ;
assign cfg_control4_f = 32'd0 ;

assign hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_nxt = cfg_control5_nxt ;
assign cfg_control5_f = hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_0_reg_f ;

assign hqm_nalb_target_cfg_control_arb_weights_tqpri_atq_1_status = 32'd0 ;
assign cfg_control6_f = 32'd0 ;

assign hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_nxt = cfg_control7_nxt ;
assign cfg_control7_f = hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_0_reg_f ;

assign hqm_nalb_target_cfg_control_arb_weights_tqpri_nalb_1_status = 32'd0 ;
assign cfg_control8_f = 32'd0 ;

assign hqm_nalb_target_cfg_detect_feature_operation_00_reg_nxt = cfg_control9_nxt ;
assign cfg_control9_f = hqm_nalb_target_cfg_detect_feature_operation_00_reg_f ;

assign hqm_nalb_target_cfg_detect_feature_operation_01_reg_nxt = cfg_control10_nxt ;
assign cfg_control10_f = hqm_nalb_target_cfg_detect_feature_operation_01_reg_f ;

assign hqm_nalb_target_cfg_control_pipeline_credits_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_control_pipeline_credits_reg_nxt = cfg_control11_nxt ;
assign cfg_control11_f = hqm_nalb_target_cfg_control_pipeline_credits_reg_f ;

assign hqm_nalb_target_cfg_unit_idle_reg_nxt = cfg_unit_idle_nxt ;
assign cfg_unit_idle_f = hqm_nalb_target_cfg_unit_idle_reg_f ;

assign hqm_nalb_target_cfg_pipe_health_valid_00_reg_nxt = cfg_pipe_health_valid_00_nxt ;
assign cfg_pipe_health_valid_00_f = hqm_nalb_target_cfg_pipe_health_valid_00_reg_f ;

assign hqm_nalb_target_cfg_pipe_health_valid_01_reg_nxt = cfg_pipe_health_valid_01_nxt ;
assign cfg_pipe_health_valid_01_f = hqm_nalb_target_cfg_pipe_health_valid_01_reg_f ;

assign hqm_nalb_target_cfg_pipe_health_hold_00_reg_nxt = cfg_pipe_health_hold_00_nxt ;
assign cfg_pipe_health_hold_00_f = hqm_nalb_target_cfg_pipe_health_hold_00_reg_f ;

assign hqm_nalb_target_cfg_pipe_health_hold_01_reg_nxt = cfg_pipe_health_hold_01_nxt ;
assign cfg_pipe_health_hold_01_f = hqm_nalb_target_cfg_pipe_health_hold_01_reg_f ;

assign hqm_nalb_target_cfg_interface_status_reg_nxt = cfg_interface_nxt ;
assign cfg_interface_f = hqm_nalb_target_cfg_interface_status_reg_f ;

assign hqm_nalb_target_cfg_error_inject_reg_v = 1'b0 ;
assign hqm_nalb_target_cfg_error_inject_reg_nxt = cfg_error_inj_nxt ;
assign cfg_error_inj_f = hqm_nalb_target_cfg_error_inject_reg_f ;



//....................................................................................................
// STATUS

assign hqm_nalb_target_cfg_diagnostic_aw_status_status = cfg_status0 ;

assign hqm_nalb_target_cfg_diagnostic_aw_status_01_status = cfg_status1 ;

assign hqm_nalb_target_cfg_diagnostic_aw_status_02_status = cfg_status2 ;

// Status 3,4,5,6,7 have RESERVED in TARGET Name

//------------------------------------------------------------------------------------------------------------------------------------------------
//counters
always_comb begin : L06
  fifo_nalb_lsp_enq_lb_nalb_cnt_nxt = fifo_nalb_lsp_enq_lb_nalb_cnt_f + { 4'd0 , fifo_nalb_lsp_enq_lb_nalb_inc } - { 4'd0 , fifo_nalb_lsp_enq_lb_nalb_dec } ;
  fifo_nalb_lsp_enq_lb_atq_cnt_nxt = fifo_nalb_lsp_enq_lb_atq_cnt_f + { 4'd0 , fifo_nalb_lsp_enq_lb_atq_inc } - { 4'd0 , fifo_nalb_lsp_enq_lb_atq_dec } ;
  fifo_nalb_lsp_enq_lb_rorply_cnt_nxt = fifo_nalb_lsp_enq_lb_rorply_cnt_f + { 4'd0 , fifo_nalb_lsp_enq_lb_rorply_inc } - { 4'd0 , fifo_nalb_lsp_enq_lb_rorply_dec } ;
  fifo_nalb_qed_nalb_cnt_nxt = fifo_nalb_qed_nalb_cnt_f + { 4'd0 , fifo_nalb_qed_nalb_inc } - { 4'd0 , fifo_nalb_qed_nalb_dec } ;
  fifo_nalb_qed_atq_cnt_nxt = fifo_nalb_qed_atq_cnt_f + { 4'd0 , fifo_nalb_qed_atq_inc } - { 4'd0 , fifo_nalb_qed_atq_dec } ;
  fifo_nalb_qed_rorply_cnt_nxt = fifo_nalb_qed_rorply_cnt_f + { 4'd0 , fifo_nalb_qed_rorply_inc } - { 4'd0 , fifo_nalb_qed_rorply_dec } ;
end

always_comb begin : L09
  nalb_stall_nxt = { 5 { ( p6_nalb_v_nxt & ( ( p6_nalb_data_nxt.cmd == HQM_NALB_CMD_DEQ ) | cfg_control0_f [ HQM_NALB_CHICKEN_V1MODE ] )
                      & ( ( ( p7_nalb_v_nxt & ( p7_nalb_data_nxt.qid == p6_nalb_data_nxt.qid ) ) & ( p7_nalb_v_nxt & ( p7_nalb_data_nxt.qpri == p6_nalb_data_nxt.qpri ) ) )
                        | ( ( p8_nalb_v_nxt & ( p8_nalb_data_nxt.qid == p6_nalb_data_nxt.qid ) ) & ( p8_nalb_v_nxt & ( p8_nalb_data_nxt.qpri == p6_nalb_data_nxt.qpri ) ) )
                        )
                      )
                    } } ;

  atq_stall_nxt = { 5 { ( p6_atq_v_nxt
                     & ( ( ( p7_atq_v_nxt & ( p7_atq_data_nxt.qid == p6_atq_data_nxt.qid ) ) & ( p7_atq_v_nxt & ( p7_atq_data_nxt.qpri == p6_atq_data_nxt.qpri ) ) )
                        | ( ( p8_atq_v_nxt & ( p8_atq_data_nxt.qid == p6_atq_data_nxt.qid ) ) & ( p8_atq_v_nxt & ( p8_atq_data_nxt.qpri == p6_atq_data_nxt.qpri ) ) )
                        )
                     )
                  } } ;

  rofrag_stall_nxt = ( p6_rofrag_v_nxt
                        & ( ( ( p7_rofrag_v_nxt & ( p7_rofrag_data_nxt.cq == p6_rofrag_data_nxt.cq ) ) & ( p7_rofrag_v_nxt & ( p7_rofrag_data_nxt.qidix == p6_rofrag_data_nxt.qidix ) ) )
                           | ( ( p8_rofrag_v_nxt & ( p8_rofrag_data_nxt.cq == p6_rofrag_data_nxt.cq ) ) & ( p8_rofrag_v_nxt & ( p8_rofrag_data_nxt.qidix == p6_rofrag_data_nxt.qidix ) ) )
                           )
                     ) ;

  replay_stall_nxt = ( p6_replay_v_nxt
                     & ( ( ( p7_replay_v_nxt & ( p7_replay_data_nxt.qid == p6_replay_data_nxt.qid ) ) & ( p7_replay_v_nxt & ( p7_replay_data_nxt.qpri == p6_replay_data_nxt.qpri ) ) )
                        | ( ( p8_replay_v_nxt & ( p8_replay_data_nxt.qid == p6_replay_data_nxt.qid ) ) & ( p8_replay_v_nxt & ( p8_replay_data_nxt.qpri == p6_replay_data_nxt.qpri ) ) )
                        )
                     ) ;

  ordered_stall_nxt = { 8 { ( rofrag_stall_nxt | replay_stall_nxt ) } } ;
end




//------------------------------------------------------------------------------------------------------------------------------------------------
// Functional

always_comb begin : L10
  //....................................................................................................
  // elastic FIFO storage

  residue_check_rx_sync_rop_nalb_enq_r = '0 ;
  residue_check_rx_sync_rop_nalb_enq_d = '0 ;
  residue_check_rx_sync_rop_nalb_enq_e = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_flid_p = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_flid_d = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_flid_e = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_hist_list_p = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_hist_list_d = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_hist_list_e = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_p = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_d = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_e = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_p = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_d = '0 ;
  parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_e = '0 ;

  parity_check_rx_sync_lsp_nalb_sch_unoord_p = '0 ;
  parity_check_rx_sync_lsp_nalb_sch_unoord_d = '0 ;
  parity_check_rx_sync_lsp_nalb_sch_unoord_e = '0 ;

  parity_check_rx_sync_lsp_nalb_sch_rorply_p = '0 ;
  parity_check_rx_sync_lsp_nalb_sch_rorply_d = '0 ;
  parity_check_rx_sync_lsp_nalb_sch_rorply_e = '0 ;

  parity_check_rx_sync_lsp_nalb_sch_atq_p = '0 ;
  parity_check_rx_sync_lsp_nalb_sch_atq_d = '0 ;
  parity_check_rx_sync_lsp_nalb_sch_atq_e = '0 ;

  fifo_rop_nalb_enq_nalb_push = '0 ;
  fifo_rop_nalb_enq_nalb_push_data = '0 ;
  fifo_rop_nalb_enq_ro_push = '0 ;
  fifo_rop_nalb_enq_ro_push_data = '0 ;
  fifo_lsp_nalb_sch_unoord_push = '0 ;
  fifo_lsp_nalb_sch_unoord_push_data = '0 ;
  fifo_lsp_nalb_sch_rorply_push = '0 ;
  fifo_lsp_nalb_sch_rorply_push_data = '0 ;
  fifo_lsp_nalb_sch_atq_push = '0 ;
  fifo_lsp_nalb_sch_atq_push_data = '0 ;

  error_badcmd0 = '0 ;

  //ROP_NALB_ENQ interface
  rx_sync_rop_nalb_enq_ready                           = ~ ( fifo_rop_nalb_enq_nalb_afull | fifo_rop_nalb_enq_ro_afull ) ;

  if ( rx_sync_rop_nalb_enq_v
     & rx_sync_rop_nalb_enq_ready
     ) begin
    residue_check_rx_sync_rop_nalb_enq_r               = rx_sync_rop_nalb_enq_data.frag_list_info.cnt_residue ;
    residue_check_rx_sync_rop_nalb_enq_d               = { 14'd0 , rx_sync_rop_nalb_enq_data.frag_list_info.cnt } ;
    residue_check_rx_sync_rop_nalb_enq_e               = ~ ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP ) ;
    parity_check_rx_sync_rop_nalb_enq_data_flid_p      = rx_sync_rop_nalb_enq_data.flid_parity ;
    parity_check_rx_sync_rop_nalb_enq_data_flid_d      = rx_sync_rop_nalb_enq_data.flid ;
    parity_check_rx_sync_rop_nalb_enq_data_flid_e      = ( ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW ) |
                                                           ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_HCW ) |
                                                           ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_LIST ) ) ;
    parity_check_rx_sync_rop_nalb_enq_data_hist_list_p = rx_sync_rop_nalb_enq_data.hist_list_info.parity ^ cfg_error_inj_f [ 0 ] ;
    parity_check_rx_sync_rop_nalb_enq_data_hist_list_d = { rx_sync_rop_nalb_enq_data.hist_list_info.qtype
                                                  , rx_sync_rop_nalb_enq_data.hist_list_info.qpri
                                                  , rx_sync_rop_nalb_enq_data.hist_list_info.qid
                                                  , rx_sync_rop_nalb_enq_data.hist_list_info.qidix_msb
                                                  , rx_sync_rop_nalb_enq_data.hist_list_info.qidix
                                                  , rx_sync_rop_nalb_enq_data.hist_list_info.reord_mode
                                                  , rx_sync_rop_nalb_enq_data.hist_list_info.reord_slot
                                                  , rx_sync_rop_nalb_enq_data.hist_list_info.sn_fid
                                                  } ;
    parity_check_rx_sync_rop_nalb_enq_data_hist_list_e = 1'b1 ;
    parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_p = rx_sync_rop_nalb_enq_data.frag_list_info.hptr_parity ;
    parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_d = { 2'd0 , rx_sync_rop_nalb_enq_data.frag_list_info.hptr } ;
    parity_check_rx_sync_rop_nalb_enq_data_frag_list_hptr_e = ~ ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP ) ;
    parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_p = rx_sync_rop_nalb_enq_data.frag_list_info.tptr_parity ;
    parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_d = { 2'd0 , rx_sync_rop_nalb_enq_data.frag_list_info.tptr } ;
    parity_check_rx_sync_rop_nalb_enq_data_frag_list_tptr_e = ~ ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP ) ;

  end

  if ( rx_sync_rop_nalb_enq_v
     & rx_sync_rop_nalb_enq_ready
     & ( ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_ILL0 )
       | ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_ILL5 )
       | ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_ILL6 )
       | ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_ILL7 )
       )
     ) begin
    error_badcmd0                               = 1'b1 ;
  end

  if ( rx_sync_rop_nalb_enq_v
     & rx_sync_rop_nalb_enq_ready
     & ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW )
     ) begin
    fifo_rop_nalb_enq_nalb_push                 = 1'b1 ;
    fifo_rop_nalb_enq_nalb_push_data            = rx_sync_rop_nalb_enq_data ;
  end

  if ( rx_sync_rop_nalb_enq_v
     & rx_sync_rop_nalb_enq_ready
     & ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_HCW )
     ) begin
    fifo_rop_nalb_enq_ro_push                   = 1'b1 ;
    fifo_rop_nalb_enq_ro_push_data              = rx_sync_rop_nalb_enq_data ;
  end

  if ( rx_sync_rop_nalb_enq_v
     & rx_sync_rop_nalb_enq_ready
     & ( rx_sync_rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_LIST )
     ) begin
    fifo_rop_nalb_enq_ro_push                   = 1'b1 ;
    fifo_rop_nalb_enq_ro_push_data              = rx_sync_rop_nalb_enq_data ;
  end


  //LSP_NALB_SCH nalb interface
  rx_sync_lsp_nalb_sch_unoord_ready                  = ~ ( fifo_lsp_nalb_sch_unoord_afull ) ;

  if ( rx_sync_lsp_nalb_sch_unoord_v
     & rx_sync_lsp_nalb_sch_unoord_ready
     ) begin
    parity_check_rx_sync_lsp_nalb_sch_unoord_p       = rx_sync_lsp_nalb_sch_unoord_data.parity ^ cfg_error_inj_f [ 1 ] ;
    parity_check_rx_sync_lsp_nalb_sch_unoord_d       = { rx_sync_lsp_nalb_sch_unoord_data.cq
                                                  , rx_sync_lsp_nalb_sch_unoord_data.qid
                                                  , rx_sync_lsp_nalb_sch_unoord_data.qidix
                                                  } ;
    parity_check_rx_sync_lsp_nalb_sch_unoord_e       = 1'd1 ;
  end

  if ( rx_sync_lsp_nalb_sch_unoord_v
     & rx_sync_lsp_nalb_sch_unoord_ready
     ) begin
    fifo_lsp_nalb_sch_unoord_push               = 1'b1 ;
    fifo_lsp_nalb_sch_unoord_push_data          = rx_sync_lsp_nalb_sch_unoord_data ;
  end

  //LSP_NALB_SCH rorply interface
  rx_sync_lsp_nalb_sch_rorply_ready                  = ~ ( fifo_lsp_nalb_sch_rorply_afull ) ;

  if ( rx_sync_lsp_nalb_sch_rorply_v
     & rx_sync_lsp_nalb_sch_rorply_ready
     ) begin
    parity_check_rx_sync_lsp_nalb_sch_rorply_p       = rx_sync_lsp_nalb_sch_rorply_data.parity ^ cfg_error_inj_f [ 2 ] ;
    parity_check_rx_sync_lsp_nalb_sch_rorply_d       = rx_sync_lsp_nalb_sch_rorply_data.qid ;
    parity_check_rx_sync_lsp_nalb_sch_rorply_e       = 1'b1 ;
  end

  if ( rx_sync_lsp_nalb_sch_rorply_v
     & rx_sync_lsp_nalb_sch_rorply_ready
     ) begin
    fifo_lsp_nalb_sch_rorply_push               = 1'b1 ;
    fifo_lsp_nalb_sch_rorply_push_data          = rx_sync_lsp_nalb_sch_rorply_data ;
  end

  //LSP_NALB_SCH atq interface
  rx_sync_lsp_nalb_sch_atq_ready                     = ~ ( fifo_lsp_nalb_sch_atq_afull ) ;

  if ( rx_sync_lsp_nalb_sch_atq_v
     & rx_sync_lsp_nalb_sch_atq_ready
     ) begin
    parity_check_rx_sync_lsp_nalb_sch_atq_p          = rx_sync_lsp_nalb_sch_atq_data.parity ^ cfg_error_inj_f [ 3 ] ;
    parity_check_rx_sync_lsp_nalb_sch_atq_d          = rx_sync_lsp_nalb_sch_atq_data.qid ;
    parity_check_rx_sync_lsp_nalb_sch_atq_e          = 1'b1 ;
  end

  if ( rx_sync_lsp_nalb_sch_atq_v
     & rx_sync_lsp_nalb_sch_atq_ready
     ) begin
    fifo_lsp_nalb_sch_atq_push                  = 1'b1 ;
    fifo_lsp_nalb_sch_atq_push_data             = rx_sync_lsp_nalb_sch_atq_data ;
  end


end

always_comb begin : L11
  fifo_rop_nalb_enq_nalb_pop = '0 ;
  fifo_lsp_nalb_sch_unoord_pop = '0 ;
  fifo_lsp_nalb_sch_atq_pop = '0 ;
  fifo_rop_nalb_enq_ro_pop = '0 ;
  fifo_lsp_nalb_sch_rorply_pop = '0 ;

      parity_gen_nalb_rop_nalb_enq_data_hist_list_d = {
                                                    fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qpri
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qidix_msb
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qidix
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.reord_mode
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.reord_slot
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.sn_fid
                                                  } ;

      parity_gen_atq_rop_nalb_enq_data_hist_list_d = {
                                                    fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qpri
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qidix_msb
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qidix
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.reord_mode
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.reord_slot
                                                  , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.sn_fid
                                                  } ;

  //....................................................................................................
  // p0 nalb pipeline
  //  counter-0
  p0_nalb_ctrl = '0 ;
  p0_nalb_v_nxt = '0 ;
  p0_nalb_data_nxt = p0_nalb_data_f ;

  rmw_nalb_cnt_p0_hold = '0 ;

  fifo_nalb_lsp_enq_lb_nalb_inc = '0 ;
  fifo_nalb_qed_nalb_inc = '0 ;

  rmw_nalb_cnt_p0_v_nxt = '0 ;
  rmw_nalb_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_nalb_cnt_p0_addr_nxt = '0 ;
  rmw_nalb_cnt_p0_write_data_nxt_nc = '0 ;

  arb_nalb_reqs = '0 ;
  arb_nalb_update = '0 ;

  p0_nalb_ctrl.hold                             = ( p0_nalb_v_f & p1_nalb_ctrl.hold ) ;
  p0_nalb_ctrl.enable                           = ( arb_nalb_winner_v ) ;
  rmw_nalb_cnt_p0_hold                           = p0_nalb_ctrl.hold ;


  arb_nalb_reqs [ 0 ]                              = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_nalb_ctrl.hold )
                                                  & ( ( ~ fifo_rop_nalb_enq_nalb_empty )  & ( fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qtype != ATOMIC ) )
                                                  & ( fifo_nalb_lsp_enq_lb_nalb_cnt_f < cfg_control11_f [ 4 : 0 ] )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_50 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_33 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f & ~ p1_nalb_v_f & ~ p1_rofrag_v_f & ~ p1_replay_v_f & ~ p1_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ 2 ] ? ( cfg_unit_idle_nxt.pipe_idle & fifo_lsp_nalb_sch_unoord_empty ) : 1'b1 )
                                                  & ( cfg_control0_f [ 4 ] ? ( fifo_lsp_nalb_sch_unoord_empty ) : 1'b1 )
                                                  ) ;
  arb_nalb_reqs [ 1 ]                              = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_nalb_ctrl.hold )
                                                  & ( ~ fifo_lsp_nalb_sch_unoord_empty )
                                                  & ( fifo_nalb_qed_nalb_cnt_f < cfg_control11_f [ 9 : 5 ] )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_50 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_33 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f & ~ p1_nalb_v_f & ~ p1_rofrag_v_f & ~ p1_replay_v_f & ~ p1_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ 3 ] ? ( cfg_unit_idle_nxt.pipe_idle & fifo_rop_nalb_enq_nalb_empty ) : 1'b1 )
                                                  & ( cfg_control0_f [ 5 ] ? ( fifo_rop_nalb_enq_nalb_empty ) : 1'b1 )
                                                  ) ;

  if ( p0_nalb_ctrl.enable | p0_nalb_ctrl.hold ) begin
    p0_nalb_v_nxt                               = 1'b1 ;
  end
  if ( p0_nalb_ctrl.enable ) begin

    if ( ( arb_nalb_winner_v  ) & ( ~ arb_nalb_winner ) ) begin
      arb_nalb_update = 1'b1 ;
      fifo_nalb_lsp_enq_lb_nalb_inc             = 1'b1 ;

      p0_nalb_data_nxt.cmd                      = HQM_NALB_CMD_ENQ ;
      if ( fifo_rop_nalb_enq_nalb_pop_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP ) begin
        p0_nalb_data_nxt.cmd                    = HQM_NALB_CMD_NOOP ;
      end

      p0_nalb_data_nxt.cq                       = '0 ;
      p0_nalb_data_nxt.qid                      = { 1'b0 , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qid } ;
      p0_nalb_data_nxt.qtype                    = fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qtype ;
      p0_nalb_data_nxt.qidix                    = '0 ;
      p0_nalb_data_nxt.parity                   = fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 4 ] ^ parity_gen_nalb_rop_nalb_enq_data_hist_list_p ;
      p0_nalb_data_nxt.qpri                     = { 1'b0 , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qpri [ 2 : 1 ] }  ;
      p0_nalb_data_nxt.empty                    = '0 ;
      p0_nalb_data_nxt.hp                       = '0 ;
      p0_nalb_data_nxt.hp_parity                = '0 ;
      p0_nalb_data_nxt.tp                       = '0 ;
      p0_nalb_data_nxt.tp_parity                = '0 ;
      p0_nalb_data_nxt.flid                     = { 1'd0 , fifo_rop_nalb_enq_nalb_pop_data.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      p0_nalb_data_nxt.flid_parity              = fifo_rop_nalb_enq_nalb_pop_data.flid_parity ;
      p0_nalb_data_nxt.error                    = '0 ;
      p0_nalb_data_nxt.frag_cnt                 = '0 ;
      p0_nalb_data_nxt.frag_residue             = '0 ;
      p0_nalb_data_nxt.hqm_core_flags           = '0 ;

      if ( fifo_rop_nalb_enq_nalb_pop_data.cmd != ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP ) begin
        rmw_nalb_cnt_p0_v_nxt                   = 1'b1 ;
        rmw_nalb_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
        rmw_nalb_cnt_p0_addr_nxt                = { 1'b0 , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qid } ;
        rmw_nalb_cnt_p0_write_data_nxt_nc          = '0 ;
      end
      fifo_rop_nalb_enq_nalb_pop                = 1'b1 ;
    end

    if ( ( arb_nalb_winner_v  ) & ( arb_nalb_winner  ) ) begin
      arb_nalb_update = 1'b1 ;
      fifo_nalb_qed_nalb_inc                    = 1'b1 ;

      p0_nalb_data_nxt.cmd                      = HQM_NALB_CMD_DEQ ;
      p0_nalb_data_nxt.cq                       = fifo_lsp_nalb_sch_unoord_pop_data.cq ;
      p0_nalb_data_nxt.qid                      = fifo_lsp_nalb_sch_unoord_pop_data.qid ;
      p0_nalb_data_nxt.qtype                    = ATOMIC ; //UNUSED
      p0_nalb_data_nxt.qidix                    = fifo_lsp_nalb_sch_unoord_pop_data.qidix ;
if ( cfg_control0_f [ HQM_NALB_CHICKEN_REORDER_QIDIX ] ) begin
      p0_nalb_data_nxt.qidix                    = '0 ;
end
      p0_nalb_data_nxt.parity                   = fifo_lsp_nalb_sch_unoord_pop_data.parity ^ cfg_error_inj_f [ 5 ] ;
      p0_nalb_data_nxt.qpri                     = '0 ;
      p0_nalb_data_nxt.empty                    = '0 ;
      p0_nalb_data_nxt.hp                       = '0 ;
      p0_nalb_data_nxt.hp_parity                = '0 ;
      p0_nalb_data_nxt.tp                       = '0 ;
      p0_nalb_data_nxt.tp_parity                = '0 ;
      p0_nalb_data_nxt.flid                     = '0 ;
      p0_nalb_data_nxt.flid_parity              = '0 ;
      p0_nalb_data_nxt.error                    = '0 ;
      p0_nalb_data_nxt.frag_cnt                 = '0 ;
      p0_nalb_data_nxt.frag_residue             = '0 ;
      p0_nalb_data_nxt.hqm_core_flags           = fifo_lsp_nalb_sch_unoord_pop_data.hqm_core_flags ;

      rmw_nalb_cnt_p0_v_nxt                     = 1'b1 ;
      rmw_nalb_cnt_p0_rw_nxt                    = HQM_AW_RMWPIPE_RMW ;
      rmw_nalb_cnt_p0_addr_nxt                  = fifo_lsp_nalb_sch_unoord_pop_data.qid ;
      rmw_nalb_cnt_p0_write_data_nxt_nc            = '0 ;

      fifo_lsp_nalb_sch_unoord_pop              = 1'd1 ;
    end

  end

  //....................................................................................................
  // p0 atq pipeline
  //  counter-0
  p0_atq_ctrl = '0 ;
  p0_atq_v_nxt = '0 ;
  p0_atq_data_nxt = p0_atq_data_f ;
  rmw_atq_cnt_p0_hold = '0 ;

  fifo_nalb_lsp_enq_lb_atq_inc = '0 ;
  fifo_nalb_qed_atq_inc = '0 ;

  rmw_atq_cnt_p0_v_nxt = '0 ;
  rmw_atq_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_atq_cnt_p0_addr_nxt = '0 ;
  rmw_atq_cnt_p0_write_data_nxt_nc = '0 ;

  arb_atq_reqs = '0 ;
  arb_atq_update = '0 ;

  p0_atq_ctrl.hold                              = ( p0_atq_v_f & p1_atq_ctrl.hold ) ;
  p0_atq_ctrl.enable                            = ( arb_atq_winner_v ) ;
  rmw_atq_cnt_p0_hold                           = p0_atq_ctrl.hold ;

  arb_atq_reqs [ 0 ]                               = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_atq_ctrl.hold )
                                                  & ( ( ~ fifo_rop_nalb_enq_nalb_empty ) & ( fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qtype == ATOMIC ) )
                                                  & ( fifo_nalb_lsp_enq_lb_atq_cnt_f < cfg_control11_f [ 24 : 20 ] )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_50 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_33 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f & ~ p1_nalb_v_f & ~ p1_rofrag_v_f & ~ p1_replay_v_f & ~ p1_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ 6 ] ? ( cfg_unit_idle_nxt.pipe_idle & fifo_lsp_nalb_sch_atq_empty ) : 1'b1 )
                                                  & ( cfg_control0_f [ 8 ] ? ( fifo_lsp_nalb_sch_atq_empty ) : 1'b1 )
                                                  ) ;
  arb_atq_reqs [ 1 ]                               = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_atq_ctrl.hold )
                                                  & ( ~ fifo_lsp_nalb_sch_atq_empty )
                                                  & ( fifo_nalb_qed_atq_cnt_f < cfg_control11_f [ 29 : 25 ] )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_50 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_33 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f & ~ p1_nalb_v_f & ~ p1_rofrag_v_f & ~ p1_replay_v_f & ~ p1_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ 7 ] ? ( cfg_unit_idle_nxt.pipe_idle & fifo_rop_nalb_enq_nalb_empty ) : 1'b1 )
                                                  & ( cfg_control0_f [ 9 ] ? ( fifo_rop_nalb_enq_nalb_empty ) : 1'b1 )
                                                  ) ;

  if ( p0_atq_ctrl.enable | p0_atq_ctrl.hold ) begin
    p0_atq_v_nxt                                = 1'b1 ;
  end
  if ( p0_atq_ctrl.enable ) begin

    if ( ( arb_atq_winner_v  ) & ( ~ arb_atq_winner ) ) begin
      arb_atq_update = 1'b1 ;
      fifo_nalb_lsp_enq_lb_atq_inc              = 1'b1 ;

      p0_atq_data_nxt.cmd                       = HQM_NALB_CMD_ENQ ;
      if ( fifo_rop_nalb_enq_nalb_pop_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP ) begin
        p0_atq_data_nxt.cmd                     = HQM_NALB_CMD_NOOP ;
      end

      p0_atq_data_nxt.cq                        = '0 ;
      p0_atq_data_nxt.qid                       = { 1'b0 , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qid } ;
      p0_atq_data_nxt.qtype                     = fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qtype ;
      p0_atq_data_nxt.qidix                     = '0 ;
      p0_atq_data_nxt.parity                    = fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 6 ] ^ parity_gen_atq_rop_nalb_enq_data_hist_list_p ;
      p0_atq_data_nxt.qpri                      = { 1'b0 , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qpri [ 2 : 1 ] } ;
      p0_atq_data_nxt.empty                     = '0 ;
      p0_atq_data_nxt.hp                        = '0 ;
      p0_atq_data_nxt.hp_parity                 = '0 ;
      p0_atq_data_nxt.tp                        = '0 ;
      p0_atq_data_nxt.tp_parity                 = '0 ;
      p0_atq_data_nxt.flid                      = { 1'd0 , fifo_rop_nalb_enq_nalb_pop_data.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      p0_atq_data_nxt.flid_parity               = fifo_rop_nalb_enq_nalb_pop_data.flid_parity ;
      p0_atq_data_nxt.error                     = '0 ;
      p0_atq_data_nxt.frag_cnt                  = '0 ;
      p0_atq_data_nxt.frag_residue              = '0 ;
      p0_atq_data_nxt.hqm_core_flags            = '0 ;

      if ( fifo_rop_nalb_enq_nalb_pop_data.cmd != ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP ) begin
        rmw_atq_cnt_p0_v_nxt                   = 1'b1 ;
        rmw_atq_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
        rmw_atq_cnt_p0_addr_nxt                = { 1'b0 , fifo_rop_nalb_enq_nalb_pop_data.hist_list_info.qid } ;
        rmw_atq_cnt_p0_write_data_nxt_nc          = '0 ;
      end
      fifo_rop_nalb_enq_nalb_pop                = 1'b1 ;
    end

    if ( ( arb_atq_winner_v  ) & ( arb_atq_winner  ) ) begin
      arb_atq_update = 1'b1 ;
      fifo_nalb_qed_atq_inc                     = 1'b1 ;

      p0_atq_data_nxt.cmd                       = HQM_NALB_CMD_DEQ ;
      p0_atq_data_nxt.cq                        = '0 ;
      p0_atq_data_nxt.qid                       = fifo_lsp_nalb_sch_atq_pop_data.qid ;
      p0_atq_data_nxt.qtype                     = ATOMIC ; //UNUSED
      p0_atq_data_nxt.qidix                     = '0 ;
      p0_atq_data_nxt.parity                    = fifo_lsp_nalb_sch_atq_pop_data.parity ^ cfg_error_inj_f [ 7 ] ;
      p0_atq_data_nxt.qpri                      = '0 ;
      p0_atq_data_nxt.empty                     = '0 ;
      p0_atq_data_nxt.hp                        = '0 ;
      p0_atq_data_nxt.hp_parity                 = '0 ;
      p0_atq_data_nxt.tp                        = '0 ;
      p0_atq_data_nxt.tp_parity                 = '0 ;
      p0_atq_data_nxt.flid                      = '0 ;
      p0_atq_data_nxt.flid_parity               = '0 ;
      p0_atq_data_nxt.error                     = '0 ;
      p0_atq_data_nxt.frag_cnt                  = '0 ;
      p0_atq_data_nxt.frag_residue              = '0 ;
      p0_atq_data_nxt.hqm_core_flags            = '0 ;

      rmw_atq_cnt_p0_v_nxt                     = 1'b1 ;
      rmw_atq_cnt_p0_rw_nxt                    = HQM_AW_RMWPIPE_RMW ;
      rmw_atq_cnt_p0_addr_nxt                  = fifo_lsp_nalb_sch_atq_pop_data.qid ;
      rmw_atq_cnt_p0_write_data_nxt_nc            = '0 ;

      fifo_lsp_nalb_sch_atq_pop                 = 1'd1 ;
    end

  end

  //....................................................................................................
  // p0 ordered pipeline
  //  counter-0
  p0_rofrag_ctrl = '0 ;
  p0_rofrag_v_nxt = '0 ;
  p0_rofrag_data_nxt = p0_rofrag_data_f ;

  rmw_rofrag_cnt_p0_hold = '0 ;

  p0_replay_ctrl = '0 ;
  p0_replay_v_nxt = '0 ;
  p0_replay_data_nxt = p0_replay_data_f ;

  rmw_replay_cnt_p0_hold = '0 ;

  rmw_rofrag_cnt_p0_v_nxt = '0 ;
  rmw_rofrag_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_rofrag_cnt_p0_addr_nxt = '0 ;
  rmw_rofrag_cnt_p0_write_data_nxt_nc = '0 ;

  rmw_replay_cnt_p0_v_nxt = '0 ;
  rmw_replay_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_replay_cnt_p0_addr_nxt = '0 ;
  rmw_replay_cnt_p0_write_data_nxt_nc = '0 ;

  fifo_nalb_lsp_enq_lb_rorply_inc = '0 ;
  fifo_nalb_qed_rorply_inc = '0 ;

  parity_gen_rofrag_rop_dp_enq_data_hist_list_d = '0 ;
      parity_gen_rofrag_rop_dp_enq_data_hist_list_d = { fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qtype
                                                  , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qpri
                                                  , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qidix_msb
                                                  , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qidix
                                                  , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.reord_mode
                                                  , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.reord_slot
                                                  , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.sn_fid
                                                  } ;

  arb_ro_reqs = '0 ;
  arb_ro_update = '0 ;

  p0_rofrag_ctrl.hold                           = ( p0_rofrag_v_f & p1_rofrag_ctrl.hold )
                                                | ( p0_replay_v_f & p1_replay_ctrl.hold ) ;
  p0_rofrag_ctrl.enable                         = ( arb_ro_winner_v ) ;
  rmw_rofrag_cnt_p0_hold                        = p0_rofrag_ctrl.hold ;

  p0_replay_ctrl.hold                           = ( p0_rofrag_v_f & p1_rofrag_ctrl.hold )
                                                | ( p0_replay_v_f & p1_replay_ctrl.hold ) ;
  p0_replay_ctrl.enable                         = ( arb_ro_winner_v ) ;
  rmw_replay_cnt_p0_hold                        = p0_replay_ctrl.hold ;

  arb_ro_reqs [ HQM_NALB_RO_ENQ_FRAG ]          = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_rofrag_ctrl.hold )
                                                  & ( ~ p0_replay_ctrl.hold )
                                                  & ( ~ ( fifo_rop_nalb_enq_ro_empty ) )
                                                  & ( ( fifo_rop_nalb_enq_ro_pop_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_HCW ) )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_50 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_33 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f & ~ p1_nalb_v_f & ~ p1_rofrag_v_f & ~ p1_replay_v_f & ~ p1_atq_v_f ) : 1'b1 )
                                                  ) ;
  arb_ro_reqs [ HQM_NALB_RO_ENQ_RORPLY ]        = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_rofrag_ctrl.hold )
                                                  & ( ~ p0_replay_ctrl.hold )
                                                  & ( ( ~ fifo_rop_nalb_enq_ro_empty ) )
                                                  & ( ( fifo_rop_nalb_enq_ro_pop_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_LIST ) )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_50 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_33 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f & ~ p1_nalb_v_f & ~ p1_rofrag_v_f & ~ p1_replay_v_f & ~ p1_atq_v_f ) : 1'b1 )
                                                  & ( fifo_nalb_lsp_enq_lb_rorply_cnt_f < cfg_control11_f [ 14 : 10 ] )
                                                  ) ;
  arb_ro_reqs [ HQM_NALB_RO_SCH_RORPLY ]        = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_rofrag_ctrl.hold )
                                                  & ( ~ p0_replay_ctrl.hold )
                                                  & ( ( ~ fifo_lsp_nalb_sch_rorply_empty ) )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_50 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_NALB_CHICKEN_33 ] ? ( ~ p0_nalb_v_f & ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p0_atq_v_f & ~ p1_nalb_v_f & ~ p1_rofrag_v_f & ~ p1_replay_v_f & ~ p1_atq_v_f ) : 1'b1 )
                                                  & ( fifo_nalb_qed_rorply_cnt_f < cfg_control11_f [ 19 : 15 ] )
                                                  ) ;

  if ( p0_rofrag_ctrl.enable | p0_rofrag_ctrl.hold ) begin
    p0_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p0_replay_ctrl.enable | p0_replay_ctrl.hold ) begin
    p0_replay_v_nxt                             = 1'b1 ;
  end

  if ( p0_rofrag_ctrl.enable | p0_replay_ctrl.enable ) begin

    if ( ( arb_ro_winner_v  ) & ( arb_ro_winner == HQM_NALB_RO_ENQ_FRAG ) ) begin
      arb_ro_update = 1'b1 ;

      p0_rofrag_data_nxt.cmd                    = HQM_NALB_CMD_ENQ ;
      p0_rofrag_data_nxt.cq                     = { fifo_rop_nalb_enq_ro_pop_data.cq [ 7 : 1 ] , ( fifo_rop_nalb_enq_ro_pop_data.cq [ 0 ] | fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qidix_msb ) }  ;
      p0_rofrag_data_nxt.qid                    = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qid } ;
      p0_rofrag_data_nxt.qtype                  = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qtype ;
      p0_rofrag_data_nxt.qidix                  = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qidix ;
if ( cfg_control0_f [ HQM_NALB_CHICKEN_REORDER_QID ] ) begin
      p0_rofrag_data_nxt.qid                    = '0 ;
end
      p0_rofrag_data_nxt.parity                 = '0 ;
      p0_rofrag_data_nxt.qpri                   = '0 ;
      p0_rofrag_data_nxt.empty                  = '0 ;
      p0_rofrag_data_nxt.hp                     = '0 ;
      p0_rofrag_data_nxt.tp                     = '0 ;
      p0_rofrag_data_nxt.flid                   = { 1'd0 , fifo_rop_nalb_enq_ro_pop_data.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      p0_rofrag_data_nxt.flid_parity            = fifo_rop_nalb_enq_ro_pop_data.flid_parity ^ cfg_error_inj_f [ 8 ] ;
      p0_rofrag_data_nxt.hp_parity              = '0 ;
      p0_rofrag_data_nxt.tp_parity              = '0 ;
      p0_rofrag_data_nxt.frag_cnt               = '0 ;
      p0_rofrag_data_nxt.frag_residue           = '0 ;
      p0_rofrag_data_nxt.error                  = '0 ;
      p0_rofrag_data_nxt.hqm_core_flags         = '0 ;

      p0_replay_data_nxt.cmd                    = HQM_NALB_CMD_NOOP ;
      p0_replay_data_nxt.cq                     = '0 ;
      p0_replay_data_nxt.qid                    = '0 ;
      p0_replay_data_nxt.qtype                  = ATOMIC ; //UNUSED
      p0_replay_data_nxt.qidix                  = '0 ;
      p0_replay_data_nxt.parity                 = '0 ;
      p0_replay_data_nxt.qpri                   = '0 ;
      p0_replay_data_nxt.empty                  = '0 ;
      p0_replay_data_nxt.hp                     = '0 ;
      p0_replay_data_nxt.tp                     = '0 ;
      p0_replay_data_nxt.flid                   = '0 ;
      p0_replay_data_nxt.flid_parity            = '0 ;
      p0_replay_data_nxt.hp_parity              = '0 ;
      p0_replay_data_nxt.tp_parity              = '0 ;
      p0_replay_data_nxt.frag_cnt               = '0 ;
      p0_replay_data_nxt.frag_residue           = '0 ;
      p0_replay_data_nxt.error                  = '0 ;
      p0_replay_data_nxt.hqm_core_flags         = '0 ;

      rmw_rofrag_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_rofrag_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
      rmw_rofrag_cnt_p0_addr_nxt                = { p0_rofrag_data_nxt.cq [ 5 : 0 ] , p0_rofrag_data_nxt.qidix } ;
      rmw_rofrag_cnt_p0_write_data_nxt_nc          = '0 ;

      rmw_replay_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_replay_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_NOOP ;
      rmw_replay_cnt_p0_addr_nxt                = { p0_replay_data_nxt.qid } ;
      rmw_replay_cnt_p0_write_data_nxt_nc          = '0 ;

      fifo_rop_nalb_enq_ro_pop                  = 1'd1 ;
    end

    if ( ( arb_ro_winner_v  ) & ( arb_ro_winner == HQM_NALB_RO_ENQ_RORPLY ) ) begin
      arb_ro_update = 1'b1 ;
      fifo_nalb_lsp_enq_lb_rorply_inc           = 1'b1 ;

      p0_rofrag_data_nxt.cmd                    = HQM_NALB_CMD_ENQ_RORPLY ;
      p0_rofrag_data_nxt.cq                     = { fifo_rop_nalb_enq_ro_pop_data.cq [ 7 : 1 ] , ( fifo_rop_nalb_enq_ro_pop_data.cq [ 0 ] | fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qidix_msb ) }  ;
      p0_rofrag_data_nxt.qid                    = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qid } ;

      p0_rofrag_data_nxt.qtype                  = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qtype ;
      p0_rofrag_data_nxt.qidix                  = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qidix ;
if ( cfg_control0_f [ HQM_NALB_CHICKEN_REORDER_QID ] ) begin
      p0_rofrag_data_nxt.qid                    = '0 ;
end
      p0_rofrag_data_nxt.parity                 = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 9 ] ^ parity_gen_rofrag_rop_dp_enq_data_hist_list_p ;
      p0_rofrag_data_nxt.qpri                   = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qpri [ 2 : 1 ] }  ;
      p0_rofrag_data_nxt.empty                  = '0 ;
      p0_rofrag_data_nxt.hp                     = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.frag_list_info.hptr } ;
      p0_rofrag_data_nxt.tp                     = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.frag_list_info.tptr } ;
      p0_rofrag_data_nxt.flid                   = '0 ;
      p0_rofrag_data_nxt.flid_parity            = '0 ;
      p0_rofrag_data_nxt.hp_parity              = fifo_rop_nalb_enq_ro_pop_data.frag_list_info.hptr_parity ;
      p0_rofrag_data_nxt.tp_parity              = fifo_rop_nalb_enq_ro_pop_data.frag_list_info.tptr_parity ;
      p0_rofrag_data_nxt.frag_cnt               = { 11'd0 , fifo_rop_nalb_enq_ro_pop_data.frag_list_info.cnt } ;
      p0_rofrag_data_nxt.frag_residue           = fifo_rop_nalb_enq_ro_pop_data.frag_list_info.cnt_residue ;
      p0_rofrag_data_nxt.error                  = '0 ;
      p0_rofrag_data_nxt.hqm_core_flags         = '0 ;

      p0_replay_data_nxt.cmd                    = HQM_NALB_CMD_ENQ_RORPLY ;
      p0_replay_data_nxt.cq                     = fifo_rop_nalb_enq_ro_pop_data.cq ;
      p0_replay_data_nxt.qid                    = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qid } ;
      p0_replay_data_nxt.qtype                  = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qtype ;
      p0_replay_data_nxt.qidix                  = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qidix ;
if ( cfg_control0_f [ HQM_NALB_CHICKEN_REORDER_QID ] ) begin
      p0_replay_data_nxt.qid                    = '0 ;
end
      p0_replay_data_nxt.parity                 = fifo_rop_nalb_enq_ro_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 10 ] ^ parity_gen_rofrag_rop_dp_enq_data_hist_list_p ;
      p0_replay_data_nxt.qpri                   = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.hist_list_info.qpri [ 2 : 1 ] } ;
      p0_replay_data_nxt.empty                  = '0 ;
      p0_replay_data_nxt.hp                     = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.frag_list_info.hptr } ;
      p0_replay_data_nxt.tp                     = { 1'b0 , fifo_rop_nalb_enq_ro_pop_data.frag_list_info.tptr } ;
      p0_replay_data_nxt.flid                   = '0 ;
      p0_replay_data_nxt.flid_parity            = '0 ;
      p0_replay_data_nxt.hp_parity              = fifo_rop_nalb_enq_ro_pop_data.frag_list_info.hptr_parity ;
      p0_replay_data_nxt.tp_parity              = fifo_rop_nalb_enq_ro_pop_data.frag_list_info.tptr_parity ;
      p0_replay_data_nxt.frag_cnt               = { 11'd0 , fifo_rop_nalb_enq_ro_pop_data.frag_list_info.cnt } ;
      p0_replay_data_nxt.frag_residue           = fifo_rop_nalb_enq_ro_pop_data.frag_list_info.cnt_residue ;
      p0_rofrag_data_nxt.error                  = '0 ;
      p0_rofrag_data_nxt.hqm_core_flags         = '0 ;

      rmw_rofrag_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_rofrag_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
      rmw_rofrag_cnt_p0_addr_nxt                = { p0_rofrag_data_nxt.cq [ 5 : 0 ] , p0_rofrag_data_nxt.qidix } ;
      rmw_rofrag_cnt_p0_write_data_nxt_nc          = '0 ;

      rmw_replay_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_replay_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
      rmw_replay_cnt_p0_addr_nxt                = { p0_replay_data_nxt.qid } ;
      rmw_replay_cnt_p0_write_data_nxt_nc          = '0 ;

      fifo_rop_nalb_enq_ro_pop              = 1'b1 ;
    end

    if ( ( arb_ro_winner_v  ) & ( arb_ro_winner == HQM_NALB_RO_SCH_RORPLY ) ) begin
      arb_ro_update = 1'b1 ;
      fifo_nalb_qed_rorply_inc                  = 1'b1 ;

      p0_rofrag_data_nxt.cmd                    = HQM_NALB_CMD_NOOP ;
      p0_rofrag_data_nxt.cq                     = '0 ;
      p0_rofrag_data_nxt.qid                    = '0 ;
      p0_rofrag_data_nxt.qtype                  = ATOMIC ; //UNUSED
      p0_rofrag_data_nxt.qidix                  = '0 ;
      p0_rofrag_data_nxt.parity                 = '0 ;
      p0_rofrag_data_nxt.qpri                   = '0 ;
      p0_rofrag_data_nxt.empty                  = '0 ;
      p0_rofrag_data_nxt.hp                     = '0 ;
      p0_rofrag_data_nxt.tp                     = '0 ;
      p0_rofrag_data_nxt.flid                   = '0 ;
      p0_rofrag_data_nxt.flid_parity            = '0 ;
      p0_rofrag_data_nxt.hp_parity              = '0 ;
      p0_rofrag_data_nxt.tp_parity              = '0 ;
      p0_rofrag_data_nxt.frag_cnt               = '0 ;
      p0_rofrag_data_nxt.frag_residue           = '0 ;
      p0_rofrag_data_nxt.error                  = '0 ;
      p0_rofrag_data_nxt.hqm_core_flags         = '0 ;

      p0_replay_data_nxt.cmd                    = HQM_NALB_CMD_DEQ ;
      p0_replay_data_nxt.cq                     = '0 ;
      p0_replay_data_nxt.qid                    = fifo_lsp_nalb_sch_rorply_pop_data.qid ;
      p0_replay_data_nxt.qtype                  = ATOMIC ; //UNUSED
      p0_replay_data_nxt.qidix                  = '0 ;
      p0_replay_data_nxt.parity                 = fifo_lsp_nalb_sch_rorply_pop_data.parity ^ cfg_error_inj_f [ 11 ] ;
      p0_replay_data_nxt.qpri                   = '0 ;
      p0_replay_data_nxt.empty                  = '0 ;
      p0_replay_data_nxt.hp                     = '0 ;
      p0_replay_data_nxt.tp                     = '0 ;
      p0_replay_data_nxt.flid                   = '0 ;
      p0_replay_data_nxt.flid_parity            = '0 ;
      p0_replay_data_nxt.hp_parity              = '0 ;
      p0_replay_data_nxt.tp_parity              = '0 ;
      p0_replay_data_nxt.frag_cnt               = '0 ;
      p0_replay_data_nxt.frag_residue           = '0 ;
      p0_replay_data_nxt.error                  = '0 ;
      p0_replay_data_nxt.hqm_core_flags         = '0 ;

      rmw_rofrag_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_rofrag_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_NOOP ;
      rmw_rofrag_cnt_p0_addr_nxt                = { p0_rofrag_data_nxt.cq [ 5 : 0 ] , p0_rofrag_data_nxt.qidix } ;
      rmw_rofrag_cnt_p0_write_data_nxt_nc          = '0 ;

      rmw_replay_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_replay_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
      rmw_replay_cnt_p0_addr_nxt                = { p0_replay_data_nxt.qid } ;
      rmw_replay_cnt_p0_write_data_nxt_nc          = '0 ;


      fifo_lsp_nalb_sch_rorply_pop              = 1'b1 ;
    end

  end

end

always_comb begin : L12
  //....................................................................................................
  // p1 nalb pipeline
  //  counter-1
  p1_nalb_ctrl = '0 ;
  p1_nalb_v_nxt = '0 ;
  p1_nalb_data_nxt = p1_nalb_data_f ;
  rmw_nalb_cnt_p1_hold = '0 ;

  p1_nalb_ctrl.hold                              = ( p1_nalb_v_f & p2_nalb_ctrl.hold ) ;
  p1_nalb_ctrl.enable                            = ( p0_nalb_v_f & ~ p1_nalb_ctrl.hold ) ;
  rmw_nalb_cnt_p1_hold                           = p1_nalb_ctrl.hold ;
  if ( p1_nalb_ctrl.enable | p1_nalb_ctrl.hold ) begin
    p1_nalb_v_nxt                                = 1'b1 ;
  end
  if ( p1_nalb_ctrl.enable ) begin
    p1_nalb_data_nxt                             = p0_nalb_data_f ;
  end


  //....................................................................................................
  // p1 atq pipeline
  //  counter-1
  p1_atq_ctrl = '0 ;
  p1_atq_v_nxt = '0 ;
  p1_atq_data_nxt = p1_atq_data_f ;
  rmw_atq_cnt_p1_hold = '0 ;

  p1_atq_ctrl.hold                              = ( p1_atq_v_f & p2_atq_ctrl.hold ) ;
  p1_atq_ctrl.enable                            = ( p0_atq_v_f & ~ p1_atq_ctrl.hold ) ;
  rmw_atq_cnt_p1_hold                           = p1_atq_ctrl.hold ;
  if ( p1_atq_ctrl.enable | p1_atq_ctrl.hold ) begin
    p1_atq_v_nxt                                = 1'b1 ;
  end
  if ( p1_atq_ctrl.enable ) begin
    p1_atq_data_nxt                             = p0_atq_data_f ;
  end


  //....................................................................................................
  // p1 ordered pipeline
  //  counter-1

  // rofrag
  p1_rofrag_ctrl = '0 ;
  p1_rofrag_v_nxt = '0 ;
  p1_rofrag_data_nxt = p1_rofrag_data_f ;
  rmw_rofrag_cnt_p1_hold = '0 ;

  p1_rofrag_ctrl.hold                           = ( p1_rofrag_v_f & p2_rofrag_ctrl.hold ) ;
  p1_rofrag_ctrl.enable                         = ( p0_rofrag_v_f & ~ p1_rofrag_ctrl.hold ) ;
  rmw_rofrag_cnt_p1_hold                        = p1_rofrag_ctrl.hold ;
  if ( p1_rofrag_ctrl.enable | p1_rofrag_ctrl.hold ) begin
    p1_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p1_rofrag_ctrl.enable ) begin
    p1_rofrag_data_nxt                          = p0_rofrag_data_f ;
  end


  // replay
  p1_replay_ctrl = '0 ;
  p1_replay_v_nxt = '0 ;
  p1_replay_data_nxt = p1_replay_data_f ;
  rmw_replay_cnt_p1_hold = '0 ;

  p1_replay_ctrl.hold                           = ( p1_replay_v_f & p2_replay_ctrl.hold ) ;
  p1_replay_ctrl.enable                         = ( p0_replay_v_f & ~ p1_replay_ctrl.hold ) ;
  rmw_replay_cnt_p1_hold                        = p1_replay_ctrl.hold ;
  if ( p1_replay_ctrl.enable | p1_replay_ctrl.hold ) begin
    p1_replay_v_nxt                             = 1'b1 ;
  end
  if ( p1_replay_ctrl.enable ) begin
    p1_replay_data_nxt                          = p0_replay_data_f ;
  end


end

always_comb begin : L13
  //....................................................................................................
  // p2 nalb pipeline
  //  counter-2
  p2_nalb_ctrl = '0 ;
  p2_nalb_v_nxt = '0 ;
  p2_nalb_data_nxt = p2_nalb_data_f ;
  rmw_nalb_cnt_p2_hold = '0 ;

  p2_nalb_ctrl.hold                             = ( p2_nalb_v_f & p3_nalb_ctrl.hold ) ;
  p2_nalb_ctrl.enable                           = ( p1_nalb_v_f & ~ p2_nalb_ctrl.hold ) ;
  rmw_nalb_cnt_p2_hold                          = p2_nalb_ctrl.hold ;

  if ( p2_nalb_ctrl.enable | p2_nalb_ctrl.hold ) begin
    p2_nalb_v_nxt                               = 1'b1 ;
  end
  if ( p2_nalb_ctrl.enable ) begin
    p2_nalb_data_nxt                            = p1_nalb_data_f ;
  end


  //....................................................................................................
  // p2 atq pipeline
  //  counter-2
  p2_atq_ctrl = '0 ;
  p2_atq_v_nxt = '0 ;
  p2_atq_data_nxt = p2_atq_data_f ;
  rmw_atq_cnt_p2_hold = '0 ;

  p2_atq_ctrl.hold                              = ( p2_atq_v_f & p3_atq_ctrl.hold ) ;
  p2_atq_ctrl.enable                            = ( p1_atq_v_f & ~ p2_atq_ctrl.hold ) ;
  rmw_atq_cnt_p2_hold                           = p2_atq_ctrl.hold ;

  if ( p2_atq_ctrl.enable | p2_atq_ctrl.hold ) begin
    p2_atq_v_nxt                                = 1'b1 ;
  end
  if ( p2_atq_ctrl.enable ) begin
    p2_atq_data_nxt                             = p1_atq_data_f ;
  end


  //....................................................................................................
  // p2 ordered pipeline
  //  counter-2

  // rofrag
  p2_rofrag_ctrl = '0 ;
  p2_rofrag_v_nxt = '0 ;
  p2_rofrag_data_nxt = p2_rofrag_data_f ;
  rmw_rofrag_cnt_p2_hold = '0 ;

  p2_rofrag_ctrl.hold                           = ( p2_rofrag_v_f & p3_rofrag_ctrl.hold ) ;
  p2_rofrag_ctrl.enable                         = ( p1_rofrag_v_f & ~ p2_rofrag_ctrl.hold ) ;
  rmw_rofrag_cnt_p2_hold                        = p2_rofrag_ctrl.hold ;

  if ( p2_rofrag_ctrl.enable | p2_rofrag_ctrl.hold ) begin
    p2_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p2_rofrag_ctrl.enable ) begin
    p2_rofrag_data_nxt                          = p1_rofrag_data_f ;
  end


  // replay
  p2_replay_ctrl = '0 ;
  p2_replay_v_nxt = '0 ;
  p2_replay_data_nxt = p2_replay_data_f ;
  rmw_replay_cnt_p2_hold = '0 ;

  p2_replay_ctrl.hold                           = ( p2_replay_v_f & p3_replay_ctrl.hold ) ;
  p2_replay_ctrl.enable                         = ( p1_replay_v_f & ~ p2_replay_ctrl.hold ) ;
  rmw_replay_cnt_p2_hold                        = p2_replay_ctrl.hold ;

  if ( p2_replay_ctrl.enable | p2_replay_ctrl.hold ) begin
    p2_replay_v_nxt                             = 1'b1 ;
  end
  if ( p2_replay_ctrl.enable ) begin
    p2_replay_data_nxt                          = p1_replay_data_f ;
  end


end

always_comb begin : L14

  //....................................................................................................
  // p3 nalb pipeline
  //  ll-0
  p3_nalb_ctrl = '0 ;
  p3_nalb_v_nxt = '0 ;
  p3_nalb_data_nxt = p3_nalb_data_f ;

  rmw_nalb_cnt_p3_hold = '0 ;

  rmw_nalb_hp_p0_hold = '0 ;
  rmw_nalb_tp_p0_hold = '0 ;

  residue_add_nalb_cnt_a = '0 ;
  residue_add_nalb_cnt_b = '0 ;
  residue_sub_nalb_cnt_a = '0 ;
  residue_sub_nalb_cnt_b = '0 ;
  residue_check_nalb_cnt_r_nxt = '0 ;
  residue_check_nalb_cnt_d_nxt = '0 ;
  residue_check_nalb_cnt_e_nxt = '0 ;

  rmw_nalb_cnt_p3_bypsel_nxt = '0 ;
  rmw_nalb_cnt_p3_bypdata_nxt = rmw_nalb_cnt_p2_data_f ;

  rmw_nalb_hp_p0_v_nxt = '0 ;
  rmw_nalb_hp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_nalb_hp_p0_addr_nxt = '0 ;
  rmw_nalb_hp_p0_write_data_nxt = '0 ;

  rmw_nalb_tp_p0_v_nxt = '0 ;
  rmw_nalb_tp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_nalb_tp_p0_addr_nxt = '0 ;
  rmw_nalb_tp_p0_write_data_nxt = '0 ;

  arb_nalb_cnt_reqs = '0 ;
      for ( int i = 0 ; i < HQM_NALB_NUM_PRI ; i = i + 1 ) begin
        arb_nalb_cnt_reqs [ i ]                    = ( | rmw_nalb_cnt_p2_data_f [ ( i * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ;
      end

  error_nalb_nopri = '0 ;
  error_nalb_of = '0 ;

  p3_nalb_ctrl.hold                             = ( p3_nalb_v_f & p4_nalb_ctrl.hold ) ;
  p3_nalb_ctrl.enable                           = ( p2_nalb_v_f & ~ p3_nalb_ctrl.hold ) ;
  rmw_nalb_hp_p0_hold = p3_nalb_ctrl.hold ;
  rmw_nalb_tp_p0_hold = p3_nalb_ctrl.hold ;
  if ( p3_nalb_ctrl.enable | p3_nalb_ctrl.hold ) begin
    p3_nalb_v_nxt                               = 1'b1 ;
  end
  if ( p3_nalb_ctrl.enable ) begin
    p3_nalb_data_nxt                            = p2_nalb_data_f ;

    //process the counter based on enqueue (increment)
    if ( p3_nalb_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin

      residue_check_nalb_cnt_r_nxt                  = rmw_nalb_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_nalb_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_check_nalb_cnt_d_nxt                  = rmw_nalb_cnt_p2_data_f [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ; 
      residue_check_nalb_cnt_e_nxt                  = 1'b1 ;

      rmw_nalb_cnt_p3_bypsel_nxt                = 1'b1 ;
      rmw_nalb_cnt_p3_bypdata_nxt [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] = rmw_nalb_cnt_p2_data_f [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] + { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

      residue_add_nalb_cnt_a                    = rmw_nalb_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_nalb_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_add_nalb_cnt_b                    = 2'd1 ;
      rmw_nalb_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_nalb_data_nxt.qpri * 2 ) ) +: 2 ] = residue_add_nalb_cnt_r ; 

      p3_nalb_data_nxt.empty                    = ( rmw_nalb_cnt_p2_data_f [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ; 

      error_nalb_of                             = ( rmw_nalb_cnt_p2_data_f [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { HQM_NALB_CNTB2 { 1'b1 } } ) ; 
    end
    //process the counter based on dequeue (decrement)
    if ( p3_nalb_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin

      if ( arb_nalb_cnt_winner_v ) begin
        p3_nalb_data_nxt.qpri                   = arb_nalb_cnt_winner ;

        residue_check_nalb_cnt_r_nxt                = rmw_nalb_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_nalb_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        residue_check_nalb_cnt_d_nxt                = rmw_nalb_cnt_p2_data_f [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ; 
        residue_check_nalb_cnt_e_nxt                = 1'b1 ;

        rmw_nalb_cnt_p3_bypsel_nxt              = 1'b1 ;
        rmw_nalb_cnt_p3_bypdata_nxt [ ( arb_nalb_cnt_winner * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] = rmw_nalb_cnt_p2_data_f [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] - { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

        residue_sub_nalb_cnt_a                  = 2'd1 ;
        residue_sub_nalb_cnt_b                  = rmw_nalb_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_nalb_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        rmw_nalb_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_nalb_data_nxt.qpri * 2 ) ) +: 2 ] = residue_sub_nalb_cnt_r ; 

        p3_nalb_data_nxt.empty                  = ( rmw_nalb_cnt_p2_data_f [ ( p3_nalb_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ) ; 
      end
      else begin
        error_nalb_nopri                        = 1'b1 ;
        p3_nalb_data_nxt.error                  = 1'b1 ;
      end
    end

   if ( p3_nalb_data_nxt.cmd != HQM_NALB_CMD_NOOP ) begin
      rmw_nalb_hp_p0_v_nxt                      = 1'b1 ;
      rmw_nalb_hp_p0_rw_nxt                     = HQM_AW_RMWPIPE_READ ;
      rmw_nalb_hp_p0_addr_nxt                   = { 1'b0 , p3_nalb_data_nxt.qid , p3_nalb_data_nxt.qpri [ 1 : 0 ] } ;

      rmw_nalb_tp_p0_v_nxt                      = 1'b1 ;
      rmw_nalb_tp_p0_rw_nxt                     = HQM_AW_RMWPIPE_READ ;
      rmw_nalb_tp_p0_addr_nxt                   = { 1'b0 , p3_nalb_data_nxt.qid , p3_nalb_data_nxt.qpri [ 1 : 0 ] } ;
    end
  end


  //....................................................................................................
  // p3 atq pipeline
  //  ll-0
  p3_atq_ctrl = '0 ;
  p3_atq_v_nxt = '0 ;
  p3_atq_data_nxt = p3_atq_data_f ;

  rmw_atq_cnt_p3_hold = '0 ;

  rmw_atq_hp_p0_hold = '0 ;
  rmw_atq_tp_p0_hold = '0 ;

  residue_add_atq_cnt_a = '0 ;
  residue_add_atq_cnt_b = '0 ;
  residue_sub_atq_cnt_a = '0 ;
  residue_sub_atq_cnt_b = '0 ;
  residue_check_atq_cnt_r_nxt = '0 ;
  residue_check_atq_cnt_d_nxt = '0 ;
  residue_check_atq_cnt_e_nxt = '0 ;

  rmw_atq_cnt_p3_bypsel_nxt = '0 ;
  rmw_atq_cnt_p3_bypdata_nxt = rmw_atq_cnt_p2_data_f ;

  rmw_atq_hp_p0_v_nxt = '0 ;
  rmw_atq_hp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_atq_hp_p0_addr_nxt = '0 ;
  rmw_atq_hp_p0_write_data_nxt = '0 ;

  rmw_atq_tp_p0_v_nxt = '0 ;
  rmw_atq_tp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_atq_tp_p0_addr_nxt = '0 ;
  rmw_atq_tp_p0_write_data_nxt = '0 ;

  arb_atq_cnt_reqs = '0 ;
      for ( int i = 0 ; i < HQM_NALB_NUM_PRI ; i = i + 1 ) begin
        arb_atq_cnt_reqs [ i ]                     = ( | rmw_atq_cnt_p2_data_f [ ( i * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ;
      end

  error_atq_nopri = '0 ;
  error_atq_of = '0 ;

  p3_atq_ctrl.hold                              = ( p3_atq_v_f & p4_atq_ctrl.hold ) ;
  p3_atq_ctrl.enable                            = ( p2_atq_v_f & ~ p3_atq_ctrl.hold ) ;
  rmw_atq_hp_p0_hold = p3_atq_ctrl.hold ;
  rmw_atq_tp_p0_hold = p3_atq_ctrl.hold ;
  if ( p3_atq_ctrl.enable | p3_atq_ctrl.hold ) begin
    p3_atq_v_nxt                                = 1'b1 ;
  end
  if ( p3_atq_ctrl.enable ) begin
    p3_atq_data_nxt                             = p2_atq_data_f ;

    //process the counter based on enqueue (increment)
    if ( p3_atq_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin

      residue_check_atq_cnt_r_nxt                   = rmw_atq_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_atq_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_check_atq_cnt_d_nxt                   = rmw_atq_cnt_p2_data_f [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ; 
      residue_check_atq_cnt_e_nxt                   = 1'b1 ;

      rmw_atq_cnt_p3_bypsel_nxt                 = 1'b1 ;
      rmw_atq_cnt_p3_bypdata_nxt [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] = rmw_atq_cnt_p2_data_f [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] + { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

      residue_add_atq_cnt_a                     = rmw_atq_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_atq_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_add_atq_cnt_b                     = 2'd1 ;
      rmw_atq_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_atq_data_nxt.qpri * 2 ) ) +: 2 ] = residue_add_atq_cnt_r ; 

      p3_atq_data_nxt.empty                     = ( rmw_atq_cnt_p2_data_f [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ; 

      error_atq_of                              = ( rmw_atq_cnt_p2_data_f [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { HQM_NALB_CNTB2 { 1'b1 } } ) ; 
    end
    //process the counter based on dequeue (decrement)
    if ( p3_atq_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin

      if ( arb_atq_cnt_winner_v ) begin
        p3_atq_data_nxt.qpri                    = arb_atq_cnt_winner ;

        residue_check_atq_cnt_r_nxt                 = rmw_atq_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_atq_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        residue_check_atq_cnt_d_nxt                 = rmw_atq_cnt_p2_data_f [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ; 
        residue_check_atq_cnt_e_nxt                 = 1'b1 ;

        rmw_atq_cnt_p3_bypsel_nxt               = 1'b1 ;
        rmw_atq_cnt_p3_bypdata_nxt [ ( arb_atq_cnt_winner * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] = rmw_atq_cnt_p2_data_f [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] - { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

        residue_sub_atq_cnt_a                   = 2'd1 ;
        residue_sub_atq_cnt_b                   = rmw_atq_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_atq_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        rmw_atq_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_atq_data_nxt.qpri * 2 ) ) +: 2 ] = residue_sub_atq_cnt_r ; 

        p3_atq_data_nxt.empty                   = ( rmw_atq_cnt_p2_data_f [ ( p3_atq_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ) ; 
      end
      else begin
        error_atq_nopri                         = 1'b1 ;
        p3_atq_data_nxt.error                   = 1'b1 ;
      end
    end

   if ( p3_atq_data_nxt.cmd != HQM_NALB_CMD_NOOP ) begin
      rmw_atq_hp_p0_v_nxt                       = 1'b1 ;
      rmw_atq_hp_p0_rw_nxt                      = HQM_AW_RMWPIPE_READ ;
      rmw_atq_hp_p0_addr_nxt                    = { 1'b0 , p3_atq_data_nxt.qid , p3_atq_data_nxt.qpri [ 1 : 0 ] } ;

      rmw_atq_tp_p0_v_nxt                       = 1'b1 ;
      rmw_atq_tp_p0_rw_nxt                      = HQM_AW_RMWPIPE_READ ;
      rmw_atq_tp_p0_addr_nxt                    = { 1'b0 , p3_atq_data_nxt.qid , p3_atq_data_nxt.qpri [ 1 : 0 ] } ;
    end
  end


  //....................................................................................................
  // p3 ordered pipeline
  //  ll-0

  // rofrag
  p3_rofrag_ctrl = '0 ;
  p3_rofrag_v_nxt = '0 ;
  p3_rofrag_data_nxt = p3_rofrag_data_f ;

  rmw_rofrag_cnt_p3_hold = '0 ;

  rmw_rofrag_hp_p0_hold = '0 ;
  rmw_rofrag_tp_p0_hold = '0 ;

  residue_add_rofrag_cnt_a = '0 ;
  residue_add_rofrag_cnt_b = '0 ;
  residue_sub_rofrag_cnt_a = '0 ;
  residue_sub_rofrag_cnt_b = '0 ;
  residue_check_rofrag_cnt_r_nxt = '0 ;
  residue_check_rofrag_cnt_d_nxt = '0 ;
  residue_check_rofrag_cnt_e_nxt = '0 ;

  rmw_rofrag_cnt_p3_bypsel_nxt = '0 ;
  rmw_rofrag_cnt_p3_bypdata_nxt = rmw_rofrag_cnt_p2_data_f ;

  rmw_rofrag_hp_p0_v_nxt = '0 ;
  rmw_rofrag_hp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_rofrag_hp_p0_addr_nxt = '0 ;
  rmw_rofrag_hp_p0_write_data_nxt_nc = '0 ;

  rmw_rofrag_tp_p0_v_nxt = '0 ;
  rmw_rofrag_tp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_rofrag_tp_p0_addr_nxt = '0 ;
  rmw_rofrag_tp_p0_write_data_nxt_nc = '0 ;

  error_rofrag_of = '0 ;

  p3_rofrag_ctrl.hold                              = ( p3_rofrag_v_f & p4_rofrag_ctrl.hold ) ;
  p3_rofrag_ctrl.enable                            = ( p2_rofrag_v_f & ~ p3_rofrag_ctrl.hold ) ;
  rmw_rofrag_hp_p0_hold = p3_rofrag_ctrl.hold ;
  rmw_rofrag_tp_p0_hold = p3_rofrag_ctrl.hold ;
  if ( p3_rofrag_ctrl.enable | p3_rofrag_ctrl.hold ) begin
    p3_rofrag_v_nxt                                = 1'b1 ;
  end
  if ( p3_rofrag_ctrl.enable ) begin
    p3_rofrag_data_nxt                             = p2_rofrag_data_f ;

    if ( p3_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
      error_rofrag_of                              = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_NALB_CNTB2 ] == { HQM_NALB_CNTB2 { 1'b1 } } ) ;
      p3_rofrag_data_nxt.error                     = error_rofrag_of ;

      residue_check_rofrag_cnt_r_nxt                   = rmw_rofrag_cnt_p2_data_f [ ( HQM_NALB_CNTB2 ) +: 2 ] ;
      residue_check_rofrag_cnt_d_nxt                   = rmw_rofrag_cnt_p2_data_f [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ;
      residue_check_rofrag_cnt_e_nxt                   = 1'b1 ;

      if ( ~ p3_rofrag_data_nxt.error ) begin
      rmw_rofrag_cnt_p3_bypsel_nxt                 = 1'b1 ;
      end
      rmw_rofrag_cnt_p3_bypdata_nxt [ 0 +: HQM_NALB_CNTB2 ]  = rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_NALB_CNTB2 ] + { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ;

      residue_add_rofrag_cnt_a                     = rmw_rofrag_cnt_p2_data_f [ ( HQM_NALB_CNTB2 ) +: 2 ] ;
      residue_add_rofrag_cnt_b                     = 2'd1 ;
      rmw_rofrag_cnt_p3_bypdata_nxt [ HQM_NALB_CNTB2 +: 2 ]  = residue_add_rofrag_cnt_r ;

      p3_rofrag_data_nxt.empty                     = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_NALB_CNTB2 ] == { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ;

    end

    if ( p3_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) begin
      error_rofrag_of                              = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_NALB_CNTB2 ] < p2_rofrag_data_f.frag_cnt ) ;
      p3_rofrag_data_nxt.error                     = error_rofrag_of ;

      residue_check_rofrag_cnt_r_nxt                   = rmw_rofrag_cnt_p2_data_f [ ( HQM_NALB_CNTB2 ) +: 2 ] ;
      residue_check_rofrag_cnt_d_nxt                   = rmw_rofrag_cnt_p2_data_f [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ;
      residue_check_rofrag_cnt_e_nxt                   = 1'b1 ;

      if ( ~ p3_rofrag_data_nxt.error ) begin
      rmw_rofrag_cnt_p3_bypsel_nxt                 = 1'b1 ;
      end
      rmw_rofrag_cnt_p3_bypdata_nxt [ 0 +: HQM_NALB_CNTB2 ]  = rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_NALB_CNTB2 ] - { p2_rofrag_data_f.frag_cnt } ;

      residue_sub_rofrag_cnt_a                     = p3_rofrag_data_nxt.frag_residue ;
      residue_sub_rofrag_cnt_b                     = rmw_rofrag_cnt_p2_data_f [ ( HQM_NALB_CNTB2 ) +: 2 ] ;
      rmw_rofrag_cnt_p3_bypdata_nxt [ HQM_NALB_CNTB2 +: 2 ]  = residue_sub_rofrag_cnt_r ;

      p3_rofrag_data_nxt.empty                     = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_NALB_CNTB2 ] == p2_rofrag_data_f.frag_cnt )
                                                   | ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_NALB_CNTB2 ] == ( p2_rofrag_data_f.frag_cnt + 15'd1 ) ) ; //NOTE: set HP->TP if reduce to 0 or 1 task left in LL, set to NXTHP of TP if > 1

    end

      rmw_rofrag_hp_p0_v_nxt                       = 1'b1 ;
      rmw_rofrag_hp_p0_rw_nxt                      = HQM_AW_RMWPIPE_RMW ;
      rmw_rofrag_hp_p0_addr_nxt                    = { p2_rofrag_data_f.cq [ 5 : 0 ] , p2_rofrag_data_f.qidix } ;
      rmw_rofrag_hp_p0_write_data_nxt_nc              = '0 ;

      rmw_rofrag_tp_p0_v_nxt                       = 1'b1 ;
      rmw_rofrag_tp_p0_rw_nxt                      = HQM_AW_RMWPIPE_RMW ;
      rmw_rofrag_tp_p0_addr_nxt                    = { p2_rofrag_data_f.cq [ 5 : 0 ] , p2_rofrag_data_f.qidix } ;
      rmw_rofrag_tp_p0_write_data_nxt_nc              = '0 ;
  end

  // replay
  p3_replay_ctrl = '0 ;
  p3_replay_v_nxt = '0 ;
  p3_replay_data_nxt = p3_replay_data_f ;

  rmw_replay_cnt_p3_hold = '0 ;

  rmw_replay_hp_p0_hold = '0 ;
  rmw_replay_tp_p0_hold = '0 ;

  residue_add_replay_cnt_a = '0 ;
  residue_add_replay_cnt_b = '0 ;
  residue_sub_replay_cnt_a = '0 ;
  residue_sub_replay_cnt_b = '0 ;
  residue_check_replay_cnt_r_nxt = '0 ;
  residue_check_replay_cnt_d_nxt = '0 ;
  residue_check_replay_cnt_e_nxt = '0 ;

  rmw_replay_cnt_p3_bypsel_nxt = '0 ;
  rmw_replay_cnt_p3_bypdata_nxt = rmw_replay_cnt_p2_data_f ;

  rmw_replay_hp_p0_v_nxt = '0 ;
  rmw_replay_hp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_replay_hp_p0_addr_nxt = '0 ;
  rmw_replay_hp_p0_write_data_nxt_nc = '0 ;

  rmw_replay_tp_p0_v_nxt = '0 ;
  rmw_replay_tp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_replay_tp_p0_addr_nxt = '0 ;
  rmw_replay_tp_p0_write_data_nxt_nc = '0 ;

  arb_replay_cnt_reqs = '0 ;
      for ( int i = 0 ; i < HQM_NALB_NUM_PRI ; i = i + 1 ) begin
        arb_replay_cnt_reqs [ i ]                     = ( | rmw_replay_cnt_p2_data_f [ ( i * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ;
      end

  error_replay_nopri = '0 ;
  error_replay_of = '0 ;

  p3_replay_ctrl.hold                              = ( p3_replay_v_f & p4_replay_ctrl.hold ) ;
  p3_replay_ctrl.enable                            = ( p2_replay_v_f & ~ p3_replay_ctrl.hold ) ;
  rmw_replay_hp_p0_hold = p3_replay_ctrl.hold ;
  rmw_replay_tp_p0_hold = p3_replay_ctrl.hold ;
  if ( p3_replay_ctrl.enable | p3_replay_ctrl.hold ) begin
    p3_replay_v_nxt                                = 1'b1 ;
  end
  if ( p3_replay_ctrl.enable ) begin
    p3_replay_data_nxt                             = p2_replay_data_f ;

    if ( p3_replay_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) begin
      error_replay_of                              = ( ( rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] + { p3_replay_data_nxt.frag_cnt } ) > NUM_CREDITS [ 0 +: HQM_NALB_CNTB2 ] ) ; 
      p3_replay_data_nxt.error                     = error_replay_of ;

      residue_check_replay_cnt_r_nxt                   = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_check_replay_cnt_d_nxt                   = rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ; 
      residue_check_replay_cnt_e_nxt                   = 1'b1 ;

      if ( ~ p3_replay_data_nxt.error ) begin
      rmw_replay_cnt_p3_bypsel_nxt                 = 1'b1 ;
      end
      rmw_replay_cnt_p3_bypdata_nxt [ ( p3_replay_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ]  = rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] + { p3_replay_data_nxt.frag_cnt } ; 

      residue_add_replay_cnt_a                     = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_add_replay_cnt_b                     = p3_replay_data_nxt.frag_residue ;
      rmw_replay_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) )  +: 2 ] = residue_add_replay_cnt_r ; 

      p3_replay_data_nxt.empty                     = ( rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ; 
    end

    if ( p3_replay_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
      if ( arb_replay_cnt_winner_v ) begin
        p3_replay_data_nxt.qpri                    = arb_replay_cnt_winner ;

        residue_check_replay_cnt_r_nxt                 = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        residue_check_replay_cnt_d_nxt                 = rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ; 
        residue_check_replay_cnt_e_nxt                 = 1'b1 ;

        rmw_replay_cnt_p3_bypsel_nxt               = 1'b1 ;
        rmw_replay_cnt_p3_bypdata_nxt [ ( arb_replay_cnt_winner * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] = rmw_replay_cnt_p2_data_f [ ( arb_replay_cnt_winner * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] - { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

        residue_sub_replay_cnt_a                   = 2'd1 ;
        residue_sub_replay_cnt_b                   = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_NALB_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        rmw_replay_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_NALB_CNTB2 ) + ( arb_replay_cnt_winner * 2 ) ) +: 2 ] = residue_sub_replay_cnt_r ; 

        p3_replay_data_nxt.empty                   = ( rmw_replay_cnt_p2_data_f [ ( arb_replay_cnt_winner * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == { { ( HQM_NALB_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ) ; 
      end
      else begin
        error_replay_nopri                         = 1'b1 ;
        p3_replay_data_nxt.error                   = 1'b1 ;
      end

    end

      rmw_replay_hp_p0_v_nxt                       = 1'b1 ;
      rmw_replay_hp_p0_rw_nxt                      = HQM_AW_RMWPIPE_RMW ;
      rmw_replay_hp_p0_addr_nxt                    = { 1'b0 , p3_replay_data_nxt.qid , p3_replay_data_nxt.qpri [ 1 : 0 ] } ;
      rmw_replay_hp_p0_write_data_nxt_nc              = '0 ;

      rmw_replay_tp_p0_v_nxt                       = 1'b1 ;
      rmw_replay_tp_p0_rw_nxt                      = HQM_AW_RMWPIPE_RMW ;
      rmw_replay_tp_p0_addr_nxt                    = { 1'b0 , p3_replay_data_nxt.qid , p3_replay_data_nxt.qpri [ 1 : 0 ] } ;
      rmw_replay_tp_p0_write_data_nxt_nc              = '0 ;

  end


end

always_comb begin : L15
  //....................................................................................................
  // p4 nalb pipeline
  //  ll-1
  p4_nalb_ctrl = '0 ;
  p4_nalb_v_nxt = '0 ;
  p4_nalb_data_nxt = p4_nalb_data_f ;
  rmw_nalb_hp_p1_hold = '0 ;
  rmw_nalb_tp_p1_hold = '0 ;

  p4_nalb_ctrl.hold                              = ( p4_nalb_v_f & p5_nalb_ctrl.hold ) ;
  p4_nalb_ctrl.enable                            = ( p3_nalb_v_f & ~ p4_nalb_ctrl.hold ) ;
  rmw_nalb_hp_p1_hold = p4_nalb_ctrl.hold ;
  rmw_nalb_tp_p1_hold = p4_nalb_ctrl.hold ;
  if ( p4_nalb_ctrl.enable | p4_nalb_ctrl.hold ) begin
    p4_nalb_v_nxt                                = 1'b1 ;
  end
  if ( p4_nalb_ctrl.enable ) begin
    p4_nalb_data_nxt                             = p3_nalb_data_f ;
  end



  //....................................................................................................
  // p4 atq pipeline
  //  ll-1
  p4_atq_ctrl = '0 ;
  p4_atq_v_nxt = '0 ;
  p4_atq_data_nxt = p4_atq_data_f ;
  rmw_atq_hp_p1_hold = '0 ;
  rmw_atq_tp_p1_hold = '0 ;

  p4_atq_ctrl.hold                              = ( p4_atq_v_f & p5_atq_ctrl.hold ) ;
  p4_atq_ctrl.enable                            = ( p3_atq_v_f & ~ p4_atq_ctrl.hold ) ;
  rmw_atq_hp_p1_hold = p4_atq_ctrl.hold ;
  rmw_atq_tp_p1_hold = p4_atq_ctrl.hold ;
  if ( p4_atq_ctrl.enable | p4_atq_ctrl.hold ) begin
    p4_atq_v_nxt                                = 1'b1 ;
  end
  if ( p4_atq_ctrl.enable ) begin
    p4_atq_data_nxt                             = p3_atq_data_f ;
  end


  //....................................................................................................
  // p4 ordered pipeline
  //  ll-1

  // rofrag
  p4_rofrag_ctrl = '0 ;
  p4_rofrag_v_nxt = '0 ;
  p4_rofrag_data_nxt = p4_rofrag_data_f ;
  rmw_rofrag_hp_p1_hold = '0 ;
  rmw_rofrag_tp_p1_hold = '0 ;

  p4_rofrag_ctrl.hold                              = ( p4_rofrag_v_f & p5_rofrag_ctrl.hold ) ;
  p4_rofrag_ctrl.enable                            = ( p3_rofrag_v_f & ~ p4_rofrag_ctrl.hold ) ;
  rmw_rofrag_hp_p1_hold = p4_rofrag_ctrl.hold ;
  rmw_rofrag_tp_p1_hold = p4_rofrag_ctrl.hold ;
  if ( p4_rofrag_ctrl.enable | p4_rofrag_ctrl.hold ) begin
    p4_rofrag_v_nxt                                = 1'b1 ;
  end
  if ( p4_rofrag_ctrl.enable ) begin
    p4_rofrag_data_nxt                             = p3_rofrag_data_f ;
  end


  // replay
  p4_replay_ctrl = '0 ;
  p4_replay_v_nxt = '0 ;
  p4_replay_data_nxt = p4_replay_data_f ;
  rmw_replay_hp_p1_hold = '0 ;
  rmw_replay_tp_p1_hold = '0 ;

  p4_replay_ctrl.hold                              = ( p4_replay_v_f & p5_replay_ctrl.hold ) ;
  p4_replay_ctrl.enable                            = ( p3_replay_v_f & ~ p4_replay_ctrl.hold ) ;
  rmw_replay_hp_p1_hold = p4_replay_ctrl.hold ;
  rmw_replay_tp_p1_hold = p4_replay_ctrl.hold ;
  if ( p4_replay_ctrl.enable | p4_replay_ctrl.hold ) begin
    p4_replay_v_nxt                                = 1'b1 ;
  end
  if ( p4_replay_ctrl.enable ) begin
    p4_replay_data_nxt                             = p3_replay_data_f ;
  end


end

always_comb begin : L16
  //....................................................................................................
  // p5 nalb pipeline
  //  ll-2
  p5_nalb_ctrl = '0 ;
  p5_nalb_v_nxt = '0 ;
  p5_nalb_data_nxt = p5_nalb_data_f ;
  rmw_nalb_hp_p2_hold = '0 ;
  rmw_nalb_tp_p2_hold = '0 ;

  p5_nalb_ctrl.hold                              = ( ( p5_nalb_v_f & p6_nalb_ctrl.hold )
                                                  | ( p5_nalb_v_f & ~ ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_UNOORD ) ) )
                                                  ) ;
  p5_nalb_ctrl.enable                            = ( p4_nalb_v_f & ~ p5_nalb_ctrl.hold ) ;
  rmw_nalb_hp_p2_hold = p5_nalb_ctrl.hold ;
  rmw_nalb_tp_p2_hold = p5_nalb_ctrl.hold ;
  if ( p5_nalb_ctrl.enable | p5_nalb_ctrl.hold ) begin
    p5_nalb_v_nxt                                = 1'b1 ;
  end
  if ( p5_nalb_ctrl.enable ) begin
    p5_nalb_data_nxt                             = p4_nalb_data_f ;
  end


  //....................................................................................................
  // p5 atq pipeline
  //  ll-2
  p5_atq_ctrl = '0 ;
  p5_atq_v_nxt = '0 ;
  p5_atq_data_nxt = p5_atq_data_f ;
  rmw_atq_hp_p2_hold = '0 ;
  rmw_atq_tp_p2_hold = '0 ;

  p5_atq_ctrl.hold                              = ( ( p5_atq_v_f & p6_atq_ctrl.hold )
                                                  | ( p5_atq_v_f & ~ ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_ATQ ) ) )
                                                  ) ;
  p5_atq_ctrl.enable                            = ( p4_atq_v_f & ~ p5_atq_ctrl.hold ) ;
  rmw_atq_hp_p2_hold = p5_atq_ctrl.hold ;
  rmw_atq_tp_p2_hold = p5_atq_ctrl.hold ;
  if ( p5_atq_ctrl.enable | p5_atq_ctrl.hold ) begin
    p5_atq_v_nxt                                = 1'b1 ;
  end
  if ( p5_atq_ctrl.enable ) begin
    p5_atq_data_nxt                             = p4_atq_data_f ;
  end


  //....................................................................................................
  // p5 ordered pipeline
  //  ll-2

  // rofrag
  p5_rofrag_ctrl = '0 ;
  p5_rofrag_v_nxt = '0 ;
  p5_rofrag_data_nxt = p5_rofrag_data_f ;
  rmw_rofrag_hp_p2_hold = '0 ;
  rmw_rofrag_tp_p2_hold = '0 ;

  p5_rofrag_ctrl.hold                              = ( ( p5_rofrag_v_f & p6_rofrag_ctrl.hold )
                                                   | ( p5_rofrag_v_f & ~ ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_ORDERED ) ) )
                                                   ) ;
  p5_rofrag_ctrl.enable                            = ( p4_rofrag_v_f & ~ p5_rofrag_ctrl.hold ) ;
  rmw_rofrag_hp_p2_hold = p5_rofrag_ctrl.hold ;
  rmw_rofrag_tp_p2_hold = p5_rofrag_ctrl.hold ;
  if ( p5_rofrag_ctrl.enable | p5_rofrag_ctrl.hold ) begin
    p5_rofrag_v_nxt                                = 1'b1 ;
  end
  if ( p5_rofrag_ctrl.enable ) begin
    p5_rofrag_data_nxt                             = p4_rofrag_data_f ;
  end

  // replay
  p5_replay_ctrl = '0 ;
  p5_replay_v_nxt = '0 ;
  p5_replay_data_nxt = p5_replay_data_f ;
  rmw_replay_hp_p2_hold = '0 ;
  rmw_replay_tp_p2_hold = '0 ;

  p5_replay_ctrl.hold                              = ( ( p5_replay_v_f & p6_replay_ctrl.hold )
                                                   | ( p5_replay_v_f & ~ ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_ORDERED ) ) )
                                                   ) ;
  p5_replay_ctrl.enable                            = ( p4_replay_v_f & ~ p5_replay_ctrl.hold ) ;
  rmw_replay_hp_p2_hold = p5_replay_ctrl.hold ;
  rmw_replay_tp_p2_hold = p5_replay_ctrl.hold ;
  if ( p5_replay_ctrl.enable | p5_replay_ctrl.hold ) begin
    p5_replay_v_nxt                                = 1'b1 ;
  end
  if ( p5_replay_ctrl.enable ) begin
    p5_replay_data_nxt                             = p4_replay_data_f ;
  end



end












always_comb begin : L17
  arb_nxthp_reqs = '0 ;
  arb_nxthp_update = '0 ;

  rw_nxthp_p0_v_nxt = '0 ;
  rw_nxthp_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_nxthp_p0_addr_nxt = '0 ;
  rw_nxthp_p0_write_data_nxt = '0 ;

  rw_nxthp_p0_byp_v_nxt = '0 ;
  rw_nxthp_p0_byp_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_nxthp_p0_byp_addr_nxt = '0 ;
  rw_nxthp_p0_byp_write_data_nxt = '0 ;

  rmw_nalb_hp_p3_hold = '0 ;
  rmw_nalb_tp_p3_hold = '0 ;

  rmw_rofrag_hp_p3_hold = '0 ;
  rmw_rofrag_tp_p3_hold = '0 ;

  rmw_replay_hp_p3_hold = '0 ;
  rmw_replay_tp_p3_hold = '0 ;

  rmw_atq_hp_p3_hold = '0 ;
  rmw_atq_tp_p3_hold = '0 ;

  parity_check_rmw_nalb_hp_p2_p = '0 ;
  parity_check_rmw_nalb_hp_p2_d = '0 ;
  parity_check_rmw_nalb_hp_p2_e = '0 ;
  parity_check_rmw_nalb_tp_p2_p = '0 ;
  parity_check_rmw_nalb_tp_p2_d = '0 ;
  parity_check_rmw_nalb_tp_p2_e = '0 ;

  parity_check_rmw_atq_hp_p2_p = '0 ;
  parity_check_rmw_atq_hp_p2_d = '0 ;
  parity_check_rmw_atq_hp_p2_e = '0 ;
  parity_check_rmw_atq_tp_p2_p = '0 ;
  parity_check_rmw_atq_tp_p2_d = '0 ;
  parity_check_rmw_atq_tp_p2_e = '0 ;

  parity_check_rmw_rofrag_hp_p2_p = '0 ;
  parity_check_rmw_rofrag_hp_p2_d = '0 ;
  parity_check_rmw_rofrag_hp_p2_e = '0 ;
  parity_check_rmw_rofrag_tp_p2_p = '0 ;
  parity_check_rmw_rofrag_tp_p2_d = '0 ;
  parity_check_rmw_rofrag_tp_p2_e = '0 ;

  parity_check_rmw_replay_hp_p2_p = '0 ;
  parity_check_rmw_replay_hp_p2_d = '0 ;
  parity_check_rmw_replay_hp_p2_e = '0 ;
  parity_check_rmw_replay_tp_p2_p = '0 ;
  parity_check_rmw_replay_tp_p2_d = '0 ;
  parity_check_rmw_replay_tp_p2_e = '0 ;

  rw_nxthp_p0_hold = '0 ;

  error_nalb_headroom = '0 ;
  error_atq_headroom = '0 ;
  error_rofrag_headroom = '0 ;
  error_replay_headroom = '0 ;


  //....................................................................................................
  // p6 nalb nxt pipeline
  //  nxt-0
  p6_nalb_ctrl = '0 ;
  p6_nalb_v_nxt = '0 ;
  p6_nalb_data_nxt = p6_nalb_data_f ;

  nalb_stall_nc = ( p6_nalb_v_f
              & ( ( ( p7_nalb_v_f & ( p7_nalb_data_f.qid == p6_nalb_data_f.qid ) ) & ( p7_nalb_v_f & ( p7_nalb_data_f.qpri == p6_nalb_data_f.qpri ) ) )
                | ( ( p8_nalb_v_f & ( p8_nalb_data_f.qid == p6_nalb_data_f.qid ) ) & ( p8_nalb_v_f & ( p8_nalb_data_f.qpri == p6_nalb_data_f.qpri ) ) )
                )
              ) ;

  p6_nalb_ctrl.hold                             = ( p6_nalb_v_f & ( p7_nalb_ctrl.hold | nalb_stall_f [ 0 ] ) ) ;
  p6_nalb_ctrl.enable                           = ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_UNOORD ) ) ;
  p6_nalb_ctrl.bypsel                           = ( nalb_stall_f [ 1 ] ) ;





  //....................................................................................................
  // p6 atq nxt pipeline
  //  nxt-0
  p6_atq_ctrl = '0 ;
  p6_atq_v_nxt = '0 ;
  p6_atq_data_nxt = p6_atq_data_f ;

  atq_stall_nc = ( p6_atq_v_f
              & ( ( ( p7_atq_v_f & ( p7_atq_data_f.qid == p6_atq_data_f.qid ) ) & ( p7_atq_v_f & ( p7_atq_data_f.qpri == p6_atq_data_f.qpri ) ) )
                | ( ( p8_atq_v_f & ( p8_atq_data_f.qid == p6_atq_data_f.qid ) ) & ( p8_atq_v_f & ( p8_atq_data_f.qpri == p6_atq_data_f.qpri ) ) )
                )
              ) ;

  p6_atq_ctrl.hold                             = ( p6_atq_v_f & ( p7_atq_ctrl.hold | atq_stall_f [ 0 ] ) ) ;
  p6_atq_ctrl.enable                           = ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_ATQ ) ) ;
  p6_atq_ctrl.bypsel                           = ( atq_stall_f [ 1 ] ) ;



  //....................................................................................................
  // p6 ordered nxt pipeline
  //  nxt-0
  p6_rofrag_ctrl = '0 ;
  p6_rofrag_v_nxt = '0 ;
  p6_rofrag_data_nxt = p6_rofrag_data_f ;

  rofrag_stall = ( p6_rofrag_v_f
                 & ( ( ( p7_rofrag_v_f & ( p7_rofrag_data_f.cq == p6_rofrag_data_f.cq ) ) & ( p7_rofrag_v_f & ( p7_rofrag_data_f.qidix == p6_rofrag_data_f.qidix ) ) )
                   | ( ( p8_rofrag_v_f & ( p8_rofrag_data_f.cq == p6_rofrag_data_f.cq ) ) & ( p8_rofrag_v_f & ( p8_rofrag_data_f.qidix == p6_rofrag_data_f.qidix ) ) )
                   )
                 ) ;

  replay_stall = ( p6_replay_v_f
                 & ( ( ( p7_replay_v_f & ( p7_replay_data_f.qid == p6_replay_data_f.qid ) ) & ( p7_replay_v_f & ( p7_replay_data_f.qpri == p6_replay_data_f.qpri ) ) )
                   | ( ( p8_replay_v_f & ( p8_replay_data_f.qid == p6_replay_data_f.qid ) ) & ( p8_replay_v_f & ( p8_replay_data_f.qpri == p6_replay_data_f.qpri ) ) )
                   )
                 ) ;

  ordered_stall_nc = rofrag_stall | replay_stall ;

  p6_rofrag_ctrl.hold                           = ( p6_rofrag_v_f & ( p7_rofrag_ctrl.hold | ordered_stall_f [ 0 ] ) ) ;
  p6_rofrag_ctrl.enable                         = ( arb_nxthp_winner_v & (  ( arb_nxthp_winner == HQM_NALB_NXTHP_ORDERED ) ) ) ;
  p6_rofrag_ctrl.bypsel                         = ( ordered_stall_f [ 1 ] ) ;

  p6_replay_ctrl = '0 ;
  p6_replay_v_nxt = '0 ;
  p6_replay_data_nxt = p6_replay_data_f ;

  p6_replay_ctrl.hold                           = ( p6_replay_v_f & ( p7_replay_ctrl.hold | ordered_stall_f [ 2 ] ) ) ;
  p6_replay_ctrl.enable                         = ( arb_nxthp_winner_v & (  ( arb_nxthp_winner == HQM_NALB_NXTHP_ORDERED ) ) ) ;
  p6_replay_ctrl.bypsel                         = ( ordered_stall_f [ 3 ] ) ;



  rmw_nalb_tp_p3_bypsel_nxt = '0 ;
  rmw_nalb_tp_p3_bypaddr_nxt = '0 ;
  rmw_nalb_tp_p3_bypdata_nxt = '0 ;



  //....................................................................................................
  // p6 nalb nxt pipeline
  //  nxt-0

  arb_nxthp_reqs [ HQM_NALB_NXTHP_UNOORD ]                  = ( p5_nalb_v_f
                                                  & ~ p6_nalb_ctrl.hold
                                                  & ~ p6_atq_ctrl.hold
                                                  & ~ p6_rofrag_ctrl.hold
                                                  & ~ p6_replay_ctrl.hold
                                                  & ( ( p5_nalb_data_f.cmd == HQM_NALB_CMD_ENQ ) ? ~ fifo_nalb_lsp_enq_lb_afull : 1'b1 )
                                                  & ( ( p5_nalb_data_f.cmd == HQM_NALB_CMD_DEQ ) ? ~ fifo_nalb_qed_afull : 1'b1 )
                                                  ) ;

  error_nalb_headroom [ 0 ]                        = ( p5_nalb_v_f
                                                  & ( ( p5_nalb_data_f.cmd == HQM_NALB_CMD_ENQ ) ? fifo_nalb_lsp_enq_lb_afull : 1'b0 )
                                                  ) ;
  error_nalb_headroom [ 1 ]                        = ( p5_nalb_v_f
                                                  & ( ( p5_nalb_data_f.cmd == HQM_NALB_CMD_DEQ ) ? fifo_nalb_qed_afull : 1'b0 )
                                                  ) ;


  if ( p6_nalb_ctrl.enable | p6_nalb_ctrl.hold ) begin
    p6_nalb_v_nxt                               = 1'b1 ;
  end
  if ( p6_nalb_ctrl.enable ) begin
    //..................................................
    // service UNOORD pipe request
    if ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_UNOORD ) ) begin
      arb_nxthp_update = 1'b1 ;
      p6_nalb_data_nxt                           = p5_nalb_data_f ;

      if ( p6_nalb_data_nxt.cmd != HQM_NALB_CMD_NOOP ) begin
        p6_nalb_data_nxt.hp                        = { 1'd0 , rmw_nalb_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_nalb_data_nxt.hp_parity                 = rmw_nalb_hp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;
        p6_nalb_data_nxt.tp                        = { 1'd0 , rmw_nalb_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_nalb_data_nxt.tp_parity                 = rmw_nalb_tp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;
      end

      parity_check_rmw_nalb_hp_p2_p              = rmw_nalb_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
      parity_check_rmw_nalb_hp_p2_d              = rmw_nalb_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
      parity_check_rmw_nalb_hp_p2_e              = 1'b1 ;

      parity_check_rmw_nalb_tp_p2_p              = rmw_nalb_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
      parity_check_rmw_nalb_tp_p2_d              = rmw_nalb_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
      parity_check_rmw_nalb_tp_p2_e              = 1'b1 ;

      //bypass directly into pipeline storage (RMW does not have this bypass)
      if ( ( rmw_nalb_hp_p3_bypsel_nxt  )
         & ( p6_nalb_data_nxt.qid == p9_nalb_data_nxt.qid )
         & ( p6_nalb_data_nxt.qpri == p9_nalb_data_nxt.qpri )
         )  begin
        p6_nalb_data_nxt.hp_parity                = rmw_nalb_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_nalb_data_nxt.hp                       = { 1'd0 , rmw_nalb_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end








      if ( p6_nalb_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
////
      rmw_nalb_tp_p3_bypsel_nxt                 = 1'b1 ;
      rmw_nalb_tp_p3_bypaddr_nxt                = { 1'b0 , p6_nalb_data_nxt.qid , p6_nalb_data_nxt.qpri [ 1 : 0 ] } ;
      rmw_nalb_tp_p3_bypdata_nxt                = { 1'd0 , p6_nalb_data_nxt.flid_parity , p6_nalb_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
////

        if ( ~ p6_nalb_data_nxt.empty ) begin
          rw_nxthp_p0_v_nxt                    = 1'b1 ;
          rw_nxthp_p0_rw_nxt                   = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_addr_nxt                 = p6_nalb_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_write_data_nxt           = { 7'd0 , p6_nalb_data_nxt.flid_parity , p6_nalb_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
        else begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_NOOP ;
        end

      end
      if ( p6_nalb_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
          rw_nxthp_p0_v_nxt                    = 1'b1 ;
          rw_nxthp_p0_rw_nxt                   = HQM_AW_RWPIPE_READ ;
          rw_nxthp_p0_addr_nxt                 = p6_nalb_data_nxt.hp [ 13 : 0 ] ;
      end
    end
  end
  if ( p6_nalb_ctrl.bypsel ) begin
    if ( ( rmw_nalb_hp_p3_bypsel_nxt  )
       & ( p6_nalb_data_nxt.qid == p9_nalb_data_nxt.qid )
       & ( p6_nalb_data_nxt.qpri == p9_nalb_data_nxt.qpri )
       )  begin
      p6_nalb_data_nxt.hp_parity                = rmw_nalb_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
      p6_nalb_data_nxt.hp                       = { 1'd0 , rmw_nalb_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;

      if ( p6_nalb_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
          rw_nxthp_p0_byp_v_nxt                 = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                = HQM_AW_RWPIPE_READ ;
          rw_nxthp_p0_byp_addr_nxt              = p6_nalb_data_nxt.hp [ 13 : 0 ] ;
      end

    end
    if ( ( rmw_nalb_tp_p3_bypsel_nxt  )
       & ( p6_nalb_data_nxt.qid == p9_nalb_data_nxt.qid )
       & ( p6_nalb_data_nxt.qpri == p9_nalb_data_nxt.qpri )
       )  begin



      if ( p6_nalb_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
        if ( ~ p6_nalb_data_nxt.empty ) begin
          rw_nxthp_p0_byp_v_nxt                 = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_byp_addr_nxt              = p6_nalb_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_byp_write_data_nxt        = { 7'd0 , p6_nalb_data_nxt.flid_parity , p6_nalb_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
      end
    end

  end


  //....................................................................................................
  // p6 atq nxt pipeline
  //  nxt-0
  arb_nxthp_reqs [ HQM_NALB_NXTHP_ATQ ]                     = ( p5_atq_v_f
                                                  & ~ p6_nalb_ctrl.hold
                                                  & ~ p6_atq_ctrl.hold
                                                  & ~ p6_rofrag_ctrl.hold
                                                  & ~ p6_replay_ctrl.hold
                                                  & ( ( p5_atq_data_f.cmd == HQM_NALB_CMD_ENQ ) ? ~ fifo_nalb_lsp_enq_lb_afull : 1'b1 )
                                                  & ( ( p5_atq_data_f.cmd == HQM_NALB_CMD_DEQ ) ? ~ fifo_nalb_qed_afull : 1'b1 )
                                                  ) ;

  error_atq_headroom [ 0 ]                         = ( p5_atq_v_f
                                                  & ( ( p5_atq_data_f.cmd == HQM_NALB_CMD_ENQ ) ? fifo_nalb_lsp_enq_lb_afull : 1'b0 )
                                                  ) ;
  error_atq_headroom [ 1 ]                         = ( p5_atq_v_f
                                                  & ( ( p5_atq_data_f.cmd == HQM_NALB_CMD_DEQ ) ? fifo_nalb_qed_afull : 1'b0 )
                                                  ) ;

  if ( p6_atq_ctrl.enable | p6_atq_ctrl.hold ) begin
    p6_atq_v_nxt                                = 1'b1 ;
  end
  if ( p6_atq_ctrl.enable ) begin

    //..................................................
    // service UNOORD pipe request
    if ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_ATQ ) ) begin
      arb_nxthp_update = 1'b1 ;
      p6_atq_data_nxt                           = p5_atq_data_f ;

      if ( p6_atq_data_nxt.cmd != HQM_NALB_CMD_NOOP ) begin
        p6_atq_data_nxt.hp                      = { 1'd0 , rmw_atq_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_atq_data_nxt.hp_parity               = rmw_atq_hp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;
        p6_atq_data_nxt.tp                      = { 1'd0 , rmw_atq_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_atq_data_nxt.tp_parity               = rmw_atq_tp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;
      end

      parity_check_rmw_atq_hp_p2_p              = rmw_atq_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
      parity_check_rmw_atq_hp_p2_d              = rmw_atq_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
      parity_check_rmw_atq_hp_p2_e              = 1'b1 ;

      parity_check_rmw_atq_tp_p2_p              = rmw_atq_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
      parity_check_rmw_atq_tp_p2_d              = rmw_atq_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
      parity_check_rmw_atq_tp_p2_e              = 1'b1 ;

      //bypass directly into pipeline storage (RMW does not have this bypass)
      if ( ( rmw_atq_hp_p3_bypsel_nxt  )
         & ( p6_atq_data_nxt.qid == p9_atq_data_nxt.qid )
         & ( p6_atq_data_nxt.qpri == p9_atq_data_nxt.qpri )
         )  begin
        p6_atq_data_nxt.hp_parity                 = rmw_atq_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_atq_data_nxt.hp                        = { 1'd0 , rmw_atq_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
      if ( ( rmw_atq_tp_p3_bypsel_nxt  )
         & ( p6_atq_data_nxt.qid == p9_atq_data_nxt.qid )
         & ( p6_atq_data_nxt.qpri == p9_atq_data_nxt.qpri )
         )  begin
        p6_atq_data_nxt.tp_parity                 = rmw_atq_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_atq_data_nxt.tp                        = { 1'd0 , rmw_atq_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end

      if ( p6_atq_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
        if ( ~ p6_atq_data_nxt.empty ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_addr_nxt                  = p6_atq_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_write_data_nxt            = { 7'd0 , p6_atq_data_nxt.flid_parity , p6_atq_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
        else begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_NOOP ;
        end

      end
      if ( p6_atq_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_READ ;
          rw_nxthp_p0_addr_nxt                  = p6_atq_data_nxt.hp [ 13 : 0 ] ;
      end
    end
  end
  if ( p6_atq_ctrl.bypsel ) begin
    if ( ( rmw_atq_hp_p3_bypsel_nxt  )
       & ( p6_atq_data_nxt.qid == p9_atq_data_nxt.qid )
       & ( p6_atq_data_nxt.qpri == p9_atq_data_nxt.qpri )
       )  begin
      p6_atq_data_nxt.hp_parity                 = rmw_atq_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
      p6_atq_data_nxt.hp                        = { 1'd0 , rmw_atq_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;

      if ( p6_atq_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
          rw_nxthp_p0_byp_v_nxt                 = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                = HQM_AW_RWPIPE_READ ;
          rw_nxthp_p0_byp_addr_nxt              = p6_atq_data_nxt.hp [ 13 : 0 ] ;
      end

    end
    if ( ( rmw_atq_tp_p3_bypsel_nxt  )
       & ( p6_atq_data_nxt.qid == p9_atq_data_nxt.qid )
       & ( p6_atq_data_nxt.qpri == p9_atq_data_nxt.qpri )
       )  begin
      p6_atq_data_nxt.tp_parity                 = rmw_atq_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
      p6_atq_data_nxt.tp                        = { 1'd0 , rmw_atq_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;

      if ( p6_atq_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
        if ( ~ p6_atq_data_nxt.empty ) begin
          rw_nxthp_p0_byp_v_nxt                 = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_byp_addr_nxt              = p6_atq_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_byp_write_data_nxt         = { 7'd0 , p6_atq_data_nxt.flid_parity , p6_atq_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
      end

    end
  end


  //....................................................................................................
  // p6 ordered nxt pipeline
  //  nxt-0
  arb_nxthp_reqs [ HQM_NALB_NXTHP_ORDERED ]                 = ( p5_rofrag_v_f
                                                  & p5_replay_v_f
                                                  & ~ p6_nalb_ctrl.hold
                                                  & ~ p6_atq_ctrl.hold
                                                  & ~ p6_rofrag_ctrl.hold
                                                  & ~ p6_replay_ctrl.hold
                                                  & ( ( p5_replay_data_f.cmd == HQM_NALB_CMD_DEQ ) ? ~ fifo_nalb_qed_afull : 1'b1 )
                                                  & ( ( ( p5_rofrag_data_f.cmd == HQM_NALB_CMD_ENQ_RORPLY ) & ( p5_replay_data_f.cmd == HQM_NALB_CMD_ENQ_RORPLY ) ) ? ~ fifo_nalb_lsp_enq_rorply_afull : 1'b1 )
                                                  ) ;

  error_rofrag_headroom                         = ( p5_replay_v_f
                                                  & ( p5_replay_data_f.cmd == HQM_NALB_CMD_DEQ )
                                                  & fifo_nalb_qed_afull
                                                  ) ;

  error_replay_headroom                         = ( p5_rofrag_v_f
                                                  & p5_replay_v_f
                                                  & ( p5_rofrag_data_f.cmd == HQM_NALB_CMD_ENQ_RORPLY )
                                                  & ( p5_replay_data_f.cmd == HQM_NALB_CMD_ENQ_RORPLY )
                                                  & fifo_nalb_lsp_enq_rorply_afull
                                                  ) ;

  if ( p6_rofrag_ctrl.enable | p6_rofrag_ctrl.hold ) begin
    p6_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p6_replay_ctrl.enable | p6_replay_ctrl.hold ) begin
    p6_replay_v_nxt                             = 1'b1 ;
  end
  if ( p6_rofrag_ctrl.enable | p6_replay_ctrl.enable ) begin

    if ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_NALB_NXTHP_ORDERED ) ) begin
      arb_nxthp_update = 1'b1 ;

      p6_rofrag_data_nxt                        = p5_rofrag_data_f ;
      p6_replay_data_nxt                        = p5_replay_data_f ;

      if ( ( p6_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ ) & ( p6_replay_data_nxt.cmd == HQM_NALB_CMD_NOOP ) ) begin

        p6_rofrag_data_nxt.hp                     = { 1'd0 , rmw_rofrag_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_rofrag_data_nxt.hp_parity              = rmw_rofrag_hp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;
        p6_rofrag_data_nxt.tp                     = { 1'd0 , rmw_rofrag_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_rofrag_data_nxt.tp_parity              = rmw_rofrag_tp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;

        parity_check_rmw_rofrag_hp_p2_p           = rmw_rofrag_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rmw_rofrag_hp_p2_d           = rmw_rofrag_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_rofrag_hp_p2_e           = 1'b1 ;

        parity_check_rmw_rofrag_tp_p2_p           = rmw_rofrag_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rmw_rofrag_tp_p2_d           = rmw_rofrag_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_rofrag_tp_p2_e           = 1'b1 ;

        //bypass directly into pipeline storage (RMW does not have this bypass)
        if ( ( rmw_rofrag_hp_p3_bypsel_nxt  )
           & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
           & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
           )  begin
          p6_rofrag_data_nxt.hp_parity                  = rmw_rofrag_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
          p6_rofrag_data_nxt.hp                         = { 1'd0 , rmw_rofrag_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
        if ( ( rmw_rofrag_tp_p3_bypsel_nxt  )
           & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
           & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
           )  begin
          p6_rofrag_data_nxt.tp_parity                  = rmw_rofrag_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
          p6_rofrag_data_nxt.tp                         = { 1'd0 , rmw_rofrag_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end

        if ( ~ p6_rofrag_data_nxt.empty ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_addr_nxt                  = p6_rofrag_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_write_data_nxt            = { 7'd0 , p6_rofrag_data_nxt.flid_parity , p6_rofrag_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
        else begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_NOOP ;
        end

      end

      if ( ( p6_rofrag_data_nxt.cmd == HQM_NALB_CMD_NOOP ) & ( p6_replay_data_nxt.cmd == HQM_NALB_CMD_DEQ ) ) begin

        p6_replay_data_nxt.hp                     = { 1'd0 , rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_replay_data_nxt.hp_parity              = rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;
        p6_replay_data_nxt.tp                     = { 1'd0 , rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_replay_data_nxt.tp_parity              = rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;

        parity_check_rmw_replay_hp_p2_p           = rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rmw_replay_hp_p2_d           = rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_hp_p2_e           = 1'b1 ;

        parity_check_rmw_replay_tp_p2_p           = rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rmw_replay_tp_p2_d           = rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_tp_p2_e           = 1'b1 ;

        //bypass directly into pipeline storage (RMW does not have this bypass)
        if ( ( rmw_replay_hp_p3_bypsel_nxt  )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.hp_parity                 = rmw_replay_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
          p6_replay_data_nxt.hp                        = { 1'd0 , rmw_replay_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
        if ( ( rmw_replay_tp_p3_bypsel_nxt  )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.tp_parity                 = rmw_replay_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
          p6_replay_data_nxt.tp                        = { 1'd0 , rmw_replay_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end

        rw_nxthp_p0_v_nxt                       = 1'b1 ;
        rw_nxthp_p0_rw_nxt                      = HQM_AW_RWPIPE_READ ;
        rw_nxthp_p0_addr_nxt                    = p6_replay_data_nxt.hp [ 13 : 0 ] ;
      end

      if ( ( p6_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) & ( p6_replay_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) ) begin
        p6_replay_data_nxt.hp                     = { 1'd0 , rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_replay_data_nxt.hp_parity              = rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;
        p6_replay_data_nxt.tp                     = { 1'd0 , rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        p6_replay_data_nxt.tp_parity              = rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 )  ] ;

        parity_check_rmw_replay_hp_p2_p           = rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rmw_replay_hp_p2_d           = rmw_replay_hp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_hp_p2_e           = 1'b1 ;

        parity_check_rmw_replay_tp_p2_p           = rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rmw_replay_tp_p2_d           = rmw_replay_tp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_tp_p2_e           = 1'b1 ;

        //bypass directly into pipeline storage (RMW does not have this bypass)
        if ( ( rmw_replay_hp_p3_bypsel_nxt  )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.hp_parity                 = rmw_replay_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
          p6_replay_data_nxt.hp                        = { 1'd0 , rmw_replay_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
        if ( ( rmw_replay_tp_p3_bypsel_nxt  )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.tp_parity                 = rmw_replay_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
          p6_replay_data_nxt.tp                        = { 1'd0 , rmw_replay_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end

        if ( ~ p6_replay_data_nxt.empty ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_addr_nxt                  = p6_replay_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_write_data_nxt            = { 7'd0 , p6_rofrag_data_nxt.hp_parity , p6_rofrag_data_nxt.hp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ; //NOTE: when replay is active need to link the current replay TP to the replay list HP
        end
        else begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_NOOP ;
        end

      end
    end
  end
  if ( p6_rofrag_ctrl.bypsel | p6_replay_ctrl.bypsel ) begin

    if ( ( p6_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ ) & ( p6_replay_data_nxt.cmd == HQM_NALB_CMD_NOOP ) ) begin
      if ( ( rmw_rofrag_hp_p3_bypsel_nxt  )
         & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
         & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
         )  begin
        p6_rofrag_data_nxt.hp_parity              = rmw_rofrag_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_rofrag_data_nxt.hp                     = { 1'd0 , rmw_rofrag_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
      if ( ( rmw_rofrag_tp_p3_bypsel_nxt  )
         & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
         & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
         )  begin
        p6_rofrag_data_nxt.tp_parity              = rmw_rofrag_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_rofrag_data_nxt.tp                     = { 1'd0 , rmw_rofrag_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
        if ( ~ p6_rofrag_data_nxt.empty ) begin
          rw_nxthp_p0_byp_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_byp_addr_nxt                  = p6_rofrag_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_byp_write_data_nxt            = { 7'd0 , p6_rofrag_data_nxt.flid_parity , p6_rofrag_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
    end

    if ( ( p6_rofrag_data_nxt.cmd == HQM_NALB_CMD_NOOP ) & ( p6_replay_data_nxt.cmd == HQM_NALB_CMD_DEQ ) ) begin
      if ( ( rmw_replay_hp_p3_bypsel_nxt  )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.hp_parity              = rmw_replay_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_replay_data_nxt.hp                     = { 1'd0 , rmw_replay_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
      if ( ( rmw_replay_tp_p3_bypsel_nxt  )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.tp_parity              = rmw_replay_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_replay_data_nxt.tp                     = { 1'd0 , rmw_replay_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end

        rw_nxthp_p0_byp_v_nxt                       = 1'b1 ;
        rw_nxthp_p0_byp_rw_nxt                      = HQM_AW_RWPIPE_READ ;
        rw_nxthp_p0_byp_addr_nxt                    = p6_replay_data_nxt.hp [ 13 : 0 ] ;
    end

    if ( ( p6_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) & ( p6_replay_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) ) begin
      if ( ( rmw_replay_hp_p3_bypsel_nxt  )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.hp_parity                 = rmw_replay_hp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_replay_data_nxt.hp                        = { 1'd0 , rmw_replay_hp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
      if ( ( rmw_replay_tp_p3_bypsel_nxt  )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.tp_parity                 = rmw_replay_tp_p3_bypdata_nxt [ HQM_NALB_FLIDB2 ] ;
        p6_replay_data_nxt.tp                        = { 1'd0 , rmw_replay_tp_p3_bypdata_nxt [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
        if ( ~ p6_replay_data_nxt.empty ) begin
          rw_nxthp_p0_byp_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_byp_addr_nxt                  = p6_replay_data_nxt.tp [ 13 : 0 ] ;
          rw_nxthp_p0_byp_write_data_nxt            = { 7'd0 , p6_rofrag_data_nxt.hp_parity , p6_rofrag_data_nxt.hp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
        end
    end

  end

  rw_nxthp_p0_hold = p6_nalb_ctrl.hold | p6_atq_ctrl.hold | p6_rofrag_ctrl.hold | p6_replay_ctrl.hold ;

  stall = nalb_stall_f [ 2 ] | ordered_stall_f [ 4 ] | atq_stall_f [ 2 ] ;
end

always_comb begin : L18
  //....................................................................................................
  // p7 nalb nxt pipeline
  //  nxt-1
  p7_nalb_ctrl = '0 ;
  p7_nalb_v_nxt = '0 ;
  p7_nalb_data_nxt = p7_nalb_data_f ;

  rw_nxthp_p1_hold = '0 ;

  p7_nalb_ctrl.hold                              = '0 ;
  p7_nalb_ctrl.enable                            = ( p6_nalb_v_f & ~ nalb_stall_f [ 3 ] & ~ p7_nalb_ctrl.hold ) ;

  if ( p7_nalb_ctrl.enable | p7_nalb_ctrl.hold ) begin
    p7_nalb_v_nxt                                = 1'b1 ;
  end
  if ( p7_nalb_ctrl.enable ) begin
    p7_nalb_data_nxt                             = p6_nalb_data_f ;
  end

  //....................................................................................................
  // p7 atq nxt pipeline
  //  nxt-1
  p7_atq_ctrl = '0 ;
  p7_atq_v_nxt = '0 ;
  p7_atq_data_nxt = p7_atq_data_f ;

  p7_atq_ctrl.hold                              = '0 ;
  p7_atq_ctrl.enable                            = ( p6_atq_v_f & ~ atq_stall_f [ 3 ] & ~ p7_atq_ctrl.hold ) ;

  if ( p7_atq_ctrl.enable | p7_atq_ctrl.hold ) begin
    p7_atq_v_nxt                                = 1'b1 ;
  end
  if ( p7_atq_ctrl.enable ) begin
    p7_atq_data_nxt                             = p6_atq_data_f ;
  end

  //....................................................................................................
  // p7 ordered nxt pipeline
  //  nxt-1

  // rofrag
  p7_rofrag_ctrl = '0 ;
  p7_rofrag_v_nxt = '0 ;
  p7_rofrag_data_nxt = p7_rofrag_data_f ;

  p7_rofrag_ctrl.hold                              = '0 ;
  p7_rofrag_ctrl.enable                            = ( p6_rofrag_v_f & ~ ordered_stall_f [ 5 ] & ~ p7_rofrag_ctrl.hold ) ;

  if ( p7_rofrag_ctrl.enable | p7_rofrag_ctrl.hold ) begin
    p7_rofrag_v_nxt                                = 1'b1 ;
  end
  if ( p7_rofrag_ctrl.enable ) begin
    p7_rofrag_data_nxt                             = p6_rofrag_data_f ;
  end

  // replay
  p7_replay_ctrl = '0 ;
  p7_replay_v_nxt = '0 ;
  p7_replay_data_nxt = p7_replay_data_f ;

  p7_replay_ctrl.hold                              = '0 ;
  p7_replay_ctrl.enable                            = ( p6_replay_v_f & ~ ordered_stall_f [ 6 ] & ~ p7_replay_ctrl.hold ) ;

  if ( p7_replay_ctrl.enable | p7_replay_ctrl.hold ) begin
    p7_replay_v_nxt                                = 1'b1 ;
  end
  if ( p7_replay_ctrl.enable ) begin
    p7_replay_data_nxt                             = p6_replay_data_f ;
  end

  rw_nxthp_p1_hold = p7_nalb_ctrl.hold | p7_atq_ctrl.hold | p7_rofrag_ctrl.hold | p7_replay_ctrl.hold ;

end




always_comb begin : L19

  fifo_nalb_qed_push = '0 ;
  fifo_nalb_qed_push_data = '0 ;

  fifo_nalb_lsp_enq_lb_push = '0 ;
  fifo_nalb_lsp_enq_lb_push_data = '0 ;

  fifo_nalb_lsp_enq_rorply_push = '0 ;
  fifo_nalb_lsp_enq_rorply_push_data = '0 ;

  rw_nxthp_p2_hold = '0 ;

  //....................................................................................................
  // p8 nalb nxt pipeline
  //  nxt-2
  p8_nalb_ctrl = '0 ;
  p8_nalb_v_nxt = '0 ;
  p8_nalb_data_nxt = p8_nalb_data_f ;

  p8_nalb_ctrl.hold                             = '0 ;
  p8_nalb_ctrl.enable                           = ( p7_nalb_v_f & ~ p8_nalb_ctrl.hold ) ;

  if ( p8_nalb_ctrl.enable | p8_nalb_ctrl.hold ) begin
    p8_nalb_v_nxt                               = 1'b1 ;
  end
  if ( p8_nalb_ctrl.enable ) begin
    p8_nalb_data_nxt                            = p7_nalb_data_f ;
  end

  if ( p8_nalb_ctrl.enable ) begin

    if ( p8_nalb_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
      fifo_nalb_lsp_enq_lb_push                  = 1'b1 ;
      fifo_nalb_lsp_enq_lb_push_data.qid         = p8_nalb_data_nxt.qid ;
      fifo_nalb_lsp_enq_lb_push_data.qtype       = p8_nalb_data_nxt.qtype ;
      fifo_nalb_lsp_enq_lb_push_data.parity      = p8_nalb_data_nxt.parity ;

    end
    if ( p8_nalb_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
      fifo_nalb_qed_push                         = 1'b1 ;
      fifo_nalb_qed_push_data.cmd                = NALB_QED_POP ;
      fifo_nalb_qed_push_data.cq                 = p8_nalb_data_nxt.cq ;
      fifo_nalb_qed_push_data.qid                = p8_nalb_data_nxt.qid ;
      fifo_nalb_qed_push_data.qidix              = p8_nalb_data_nxt.qidix ;
      fifo_nalb_qed_push_data.parity             = p8_nalb_data_nxt.parity ;
      fifo_nalb_qed_push_data.flid               = { 1'd0 , p8_nalb_data_nxt.hp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      fifo_nalb_qed_push_data.flid_parity        = p8_nalb_data_nxt.hp_parity ;
      fifo_nalb_qed_push_data.hqm_core_flags     = p8_nalb_data_nxt.hqm_core_flags ;
    end
  end

  //....................................................................................................
  // p8 atq nxt pipeline
  //  nxt-2
  p8_atq_ctrl = '0 ;
  p8_atq_v_nxt = '0 ;
  p8_atq_data_nxt = p8_atq_data_f ;

  p8_atq_ctrl.hold                             = '0 ;
  p8_atq_ctrl.enable                           = ( p7_atq_v_f & ~ p8_atq_ctrl.hold ) ;

  if ( p8_atq_ctrl.enable | p8_atq_ctrl.hold ) begin
    p8_atq_v_nxt                               = 1'b1 ;
  end
  if ( p8_atq_ctrl.enable ) begin
    p8_atq_data_nxt                            = p7_atq_data_f ;
  end

  if ( p8_atq_ctrl.enable ) begin

    if ( p8_atq_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
      fifo_nalb_lsp_enq_lb_push                  = 1'b1 ;
      fifo_nalb_lsp_enq_lb_push_data.qid         = p8_atq_data_nxt.qid ;
      fifo_nalb_lsp_enq_lb_push_data.qtype       = p8_atq_data_nxt.qtype ;
      fifo_nalb_lsp_enq_lb_push_data.parity      = p8_atq_data_nxt.parity ;

    end
    if ( p8_atq_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
      fifo_nalb_qed_push                         = 1'b1 ;
      fifo_nalb_qed_push_data.cmd                = NALB_QED_TRANSFER ;
      fifo_nalb_qed_push_data.cq                 = p8_atq_data_nxt.cq ;
      fifo_nalb_qed_push_data.qid                = p8_atq_data_nxt.qid ;
      fifo_nalb_qed_push_data.qidix              = p8_atq_data_nxt.qidix ;
      fifo_nalb_qed_push_data.parity             = p8_atq_data_nxt.parity ;
      fifo_nalb_qed_push_data.flid               = { 1'd0 , p8_atq_data_nxt.hp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      fifo_nalb_qed_push_data.flid_parity        = p8_atq_data_nxt.hp_parity ;
      fifo_nalb_qed_push_data.hqm_core_flags     = p8_atq_data_nxt.hqm_core_flags ;
    end
  end


  //....................................................................................................
  // p8 ordered nxt pipeline
  //  nxt-2

  // rofrag
  p8_rofrag_ctrl = '0 ;
  p8_rofrag_v_nxt = '0 ;
  p8_rofrag_data_nxt = p8_rofrag_data_f ;

  p8_rofrag_ctrl.hold                           = '0 ;
  p8_rofrag_ctrl.enable                         = ( p7_rofrag_v_f & ~ p8_rofrag_ctrl.hold ) ;

  if ( p8_rofrag_ctrl.enable | p8_rofrag_ctrl.hold ) begin
    p8_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p8_rofrag_ctrl.enable ) begin
    p8_rofrag_data_nxt                          = p7_rofrag_data_f ;
  end

  if ( p8_rofrag_ctrl.enable ) begin

    if ( p8_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) begin //no response for CMD_ENQ
      fifo_nalb_lsp_enq_rorply_push                     = 1'b1 ;
      fifo_nalb_lsp_enq_rorply_push_data.qid            = p8_rofrag_data_nxt.qid ;
      fifo_nalb_lsp_enq_rorply_push_data.qtype          = p8_rofrag_data_nxt.qtype ;
      fifo_nalb_lsp_enq_rorply_push_data.parity         = p8_rofrag_data_nxt.parity ;
      fifo_nalb_lsp_enq_rorply_push_data.frag_cnt       = p8_rofrag_data_nxt.frag_cnt ;
      fifo_nalb_lsp_enq_rorply_push_data.frag_residue   = p8_rofrag_data_nxt.frag_residue ;
    end

  end

  // replay
  p8_replay_ctrl = '0 ;
  p8_replay_v_nxt = '0 ;
  p8_replay_data_nxt = p8_replay_data_f ;

  p8_replay_ctrl.hold                           = '0 ;
  p8_replay_ctrl.enable                         = ( p7_replay_v_f & ~ p8_replay_ctrl.hold ) ;

  if ( p8_replay_ctrl.enable | p8_replay_ctrl.hold ) begin
    p8_replay_v_nxt                             = 1'b1 ;
  end
  if ( p8_replay_ctrl.enable ) begin
    p8_replay_data_nxt                          = p7_replay_data_f ;
  end

  if ( p8_replay_ctrl.enable ) begin

    if ( p8_replay_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin //no response for CMD_ENQ_RORPLY
      fifo_nalb_qed_push                         = 1'b1 ;
      fifo_nalb_qed_push_data.cmd                = NALB_QED_READ ;
      fifo_nalb_qed_push_data.cq                 = p8_replay_data_nxt.cq ;
      fifo_nalb_qed_push_data.qid                = p8_replay_data_nxt.qid ;
      fifo_nalb_qed_push_data.qidix              = p8_replay_data_nxt.qidix ;
      fifo_nalb_qed_push_data.parity             = p8_replay_data_nxt.parity ;
      fifo_nalb_qed_push_data.flid               = { 1'd0 , p8_replay_data_nxt.hp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      fifo_nalb_qed_push_data.flid_parity        = p8_replay_data_nxt.hp_parity ;
      fifo_nalb_qed_push_data.hqm_core_flags     = p8_replay_data_nxt.hqm_core_flags ;
    end

  end

  rw_nxthp_p2_hold                             = p8_nalb_ctrl.hold | p8_atq_ctrl.hold | p8_rofrag_ctrl.hold | p8_replay_ctrl.hold ;

  //....................................................................................................
  // drive FIFO output to ports

  fifo_nalb_qed_pop = '0 ;
  fifo_nalb_lsp_enq_lb_pop = '0 ;
  fifo_nalb_lsp_enq_rorply_pop = '0 ;

  tx_sync_nalb_qed_v = '0 ;
  tx_sync_nalb_qed_data = '0 ;

  tx_sync_nalb_lsp_enq_lb_v = '0 ;
  tx_sync_nalb_lsp_enq_lb_data = '0 ;

  tx_sync_nalb_lsp_enq_rorply_v = '0 ;
  tx_sync_nalb_lsp_enq_rorply_data = '0 ;

fifo_nalb_lsp_enq_lb_atq_dec = '0 ;
fifo_nalb_lsp_enq_lb_nalb_dec = '0 ;
fifo_nalb_lsp_enq_lb_rorply_dec = '0 ;
fifo_nalb_qed_atq_dec = '0 ;
fifo_nalb_qed_nalb_dec = '0 ;
fifo_nalb_qed_rorply_dec = '0 ;

  //FIFO drives double buffer
  tx_sync_nalb_qed_v                                  = ~ fifo_nalb_qed_empty ;
  tx_sync_nalb_qed_data                               = fifo_nalb_qed_pop_data ;
  fifo_nalb_qed_pop                              = tx_sync_nalb_qed_v & tx_sync_nalb_qed_ready ;
fifo_nalb_qed_atq_dec                            = fifo_nalb_qed_pop & ( tx_sync_nalb_qed_data.cmd == NALB_QED_TRANSFER ) ;
fifo_nalb_qed_nalb_dec                           = fifo_nalb_qed_pop & ( tx_sync_nalb_qed_data.cmd == NALB_QED_POP ) ;
fifo_nalb_qed_rorply_dec                         = fifo_nalb_qed_pop & ( tx_sync_nalb_qed_data.cmd == NALB_QED_READ ) ;

  //FIFO drives double buffer
  tx_sync_nalb_lsp_enq_lb_v                           = ~ fifo_nalb_lsp_enq_lb_empty ;
  tx_sync_nalb_lsp_enq_lb_data                        = fifo_nalb_lsp_enq_lb_pop_data ;
  fifo_nalb_lsp_enq_lb_pop                       = tx_sync_nalb_lsp_enq_lb_v & tx_sync_nalb_lsp_enq_lb_ready ;
fifo_nalb_lsp_enq_lb_atq_dec                     = fifo_nalb_lsp_enq_lb_pop & ( fifo_nalb_lsp_enq_lb_pop_data.qtype == ATOMIC ) ;
fifo_nalb_lsp_enq_lb_nalb_dec                    = fifo_nalb_lsp_enq_lb_pop & ~ ( fifo_nalb_lsp_enq_lb_pop_data.qtype == ATOMIC ) ;

  //FIFO drives double buffer
  tx_sync_nalb_lsp_enq_rorply_v                       = ~ fifo_nalb_lsp_enq_rorply_empty ;
  tx_sync_nalb_lsp_enq_rorply_data                    = fifo_nalb_lsp_enq_rorply_pop_data ;
  fifo_nalb_lsp_enq_rorply_pop                   = tx_sync_nalb_lsp_enq_rorply_v & tx_sync_nalb_lsp_enq_rorply_ready ;
fifo_nalb_lsp_enq_lb_rorply_dec                  = fifo_nalb_lsp_enq_rorply_pop ;

end

always_comb begin : L20
  rw_nxthp_p3_hold = '0 ;

  parity_check_rw_nxthp_p2_data_p = '0 ;
  parity_check_rw_nxthp_p2_data_d = '0 ;
  parity_check_rw_nxthp_p2_data_e = '0 ;

  //....................................................................................................
  // p9 nalb nxt pipeline
  //  nxt-3
  p9_nalb_ctrl = '0 ;
  p9_nalb_v_nxt = '0 ;
  p9_nalb_data_nxt = p9_nalb_data_f ;

  rmw_nalb_hp_p3_bypsel_nxt = '0 ;
  rmw_nalb_hp_p3_bypaddr_nxt = '0 ;
  rmw_nalb_hp_p3_bypdata_nxt = '0 ;





  p9_nalb_ctrl.hold                             = '0 ;
  p9_nalb_ctrl.enable                           = p8_nalb_v_f & ~ p9_nalb_ctrl.hold ;

  if ( p9_nalb_ctrl.enable | p9_nalb_ctrl.hold ) begin
    p9_nalb_v_nxt                               = 1'b1 ;
  end
  if ( p9_nalb_ctrl.enable ) begin
    p9_nalb_data_nxt                            = p8_nalb_data_f ;
  end

  if ( p9_nalb_ctrl.enable ) begin

    if ( p9_nalb_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin

      if ( p9_nalb_data_nxt.empty  ) begin
        rmw_nalb_hp_p3_bypsel_nxt               = 1'b1 ;
        rmw_nalb_hp_p3_bypaddr_nxt              = { 1'b0 , p9_nalb_data_nxt.qid , p9_nalb_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_nalb_hp_p3_bypdata_nxt              = { 1'd0 , p9_nalb_data_nxt.flid_parity , p9_nalb_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end




    end
    if ( p9_nalb_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin

      if ( ~ p9_nalb_data_nxt.empty ) begin
        parity_check_rw_nxthp_p2_data_p        = rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rw_nxthp_p2_data_d        = rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rw_nxthp_p2_data_e        = 1'b1 ;

        rmw_nalb_hp_p3_bypsel_nxt               = 1'b1 ;
        rmw_nalb_hp_p3_bypaddr_nxt              = { 1'b0 , p9_nalb_data_nxt.qid , p9_nalb_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_nalb_hp_p3_bypdata_nxt              = { 1'd0 , rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] , rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
    end
  end

  //....................................................................................................
  // p9 atq nxt pipeline
  //  nxt-3
  p9_atq_ctrl = '0 ;
  p9_atq_v_nxt = '0 ;
  p9_atq_data_nxt = p9_atq_data_f ;

  rmw_atq_hp_p3_bypsel_nxt = '0 ;
  rmw_atq_hp_p3_bypaddr_nxt = '0 ;
  rmw_atq_hp_p3_bypdata_nxt = '0 ;

  rmw_atq_tp_p3_bypsel_nxt = '0 ;
  rmw_atq_tp_p3_bypaddr_nxt = '0 ;
  rmw_atq_tp_p3_bypdata_nxt = '0 ;

  p9_atq_ctrl.hold                              = '0 ;
  p9_atq_ctrl.enable                            = p8_atq_v_f & ~ p9_atq_ctrl.hold ;

  if ( p9_atq_ctrl.enable | p9_atq_ctrl.hold ) begin
    p9_atq_v_nxt                                = 1'b1 ;
  end
  if ( p9_atq_ctrl.enable ) begin
    p9_atq_data_nxt                             = p8_atq_data_f ;
  end

  if ( p9_atq_ctrl.enable ) begin

    if ( p9_atq_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin

      if ( p9_atq_data_nxt.empty  ) begin
        rmw_atq_hp_p3_bypsel_nxt                = 1'b1 ;
        rmw_atq_hp_p3_bypaddr_nxt               = { 1'b0 , p9_atq_data_nxt.qid , p9_atq_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_atq_hp_p3_bypdata_nxt               = { 1'd0 , p9_atq_data_nxt.flid_parity , p9_atq_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
      rmw_atq_tp_p3_bypsel_nxt                  = 1'b1 ;
      rmw_atq_tp_p3_bypaddr_nxt                 = { 1'b0 , p9_atq_data_nxt.qid , p9_atq_data_nxt.qpri [ 1 : 0 ] } ;
      rmw_atq_tp_p3_bypdata_nxt                 = { 1'd0 , p9_atq_data_nxt.flid_parity , p9_atq_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;

    end
    if ( p9_atq_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin

      if ( ~ p9_atq_data_nxt.empty ) begin
        parity_check_rw_nxthp_p2_data_p         = rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rw_nxthp_p2_data_d         = rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rw_nxthp_p2_data_e         = 1'b1 ;

        rmw_atq_hp_p3_bypsel_nxt                = 1'b1 ;
        rmw_atq_hp_p3_bypaddr_nxt               = { 1'b0 , p9_atq_data_nxt.qid , p9_atq_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_atq_hp_p3_bypdata_nxt               = { 1'd0 , rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] , rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
    end
  end

  //....................................................................................................
  // p9 ordered nxt pipeline

  // rofrag
  p9_rofrag_ctrl = '0 ;
  p9_rofrag_v_nxt = '0 ;
  p9_rofrag_data_nxt = p9_rofrag_data_f ;

  rmw_rofrag_hp_p3_bypsel_nxt = '0 ;
  rmw_rofrag_hp_p3_bypaddr_nxt = '0 ;
  rmw_rofrag_hp_p3_bypdata_nxt = '0 ;

  rmw_rofrag_tp_p3_bypsel_nxt = '0 ;
  rmw_rofrag_tp_p3_bypaddr_nxt = '0 ;
  rmw_rofrag_tp_p3_bypdata_nxt = '0 ;

  p9_rofrag_ctrl.hold                           = '0 ;
  p9_rofrag_ctrl.enable                         = p8_rofrag_v_f & ~ p9_rofrag_ctrl.hold ;

  if ( p9_rofrag_ctrl.enable | p9_rofrag_ctrl.hold ) begin
    p9_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p9_rofrag_ctrl.enable ) begin
    p9_rofrag_data_nxt                          = p8_rofrag_data_f ;

    if ( p9_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ ) begin
      if ( p9_rofrag_data_nxt.empty  ) begin
        rmw_rofrag_hp_p3_bypsel_nxt             = 1'b1 ;
        rmw_rofrag_hp_p3_bypaddr_nxt            = { p9_rofrag_data_nxt.cq [ 5 : 0 ] , p9_rofrag_data_nxt.qidix } ;
        rmw_rofrag_hp_p3_bypdata_nxt            = { 1'd0 , p9_rofrag_data_nxt.flid_parity , p9_rofrag_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
      rmw_rofrag_tp_p3_bypsel_nxt               = 1'b1 ;
      rmw_rofrag_tp_p3_bypaddr_nxt              = { p9_rofrag_data_nxt.cq [ 5 : 0 ] , p9_rofrag_data_nxt.qidix } ;
      rmw_rofrag_tp_p3_bypdata_nxt              = { 1'd0 , p9_rofrag_data_nxt.flid_parity , p9_rofrag_data_nxt.flid [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;

    end
    if ( p9_rofrag_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) begin
      if ( p9_rofrag_data_nxt.empty  ) begin
        rmw_rofrag_hp_p3_bypsel_nxt             = 1'b1 ;
        rmw_rofrag_hp_p3_bypaddr_nxt            = { p9_rofrag_data_nxt.cq [ 5 : 0 ] , p9_rofrag_data_nxt.qidix } ;
        rmw_rofrag_hp_p3_bypdata_nxt            = { 1'd0 , p9_rofrag_data_nxt.tp_parity , p9_rofrag_data_nxt.tp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end

    end
  end

  // replay
  p9_replay_ctrl = '0 ;
  p9_replay_v_nxt = '0 ;
  p9_replay_data_nxt = p9_replay_data_f ;

  rmw_replay_hp_p3_bypsel_nxt = '0 ;
  rmw_replay_hp_p3_bypaddr_nxt = '0 ;
  rmw_replay_hp_p3_bypdata_nxt = '0 ;

  rmw_replay_tp_p3_bypsel_nxt = '0 ;
  rmw_replay_tp_p3_bypaddr_nxt = '0 ;
  rmw_replay_tp_p3_bypdata_nxt = '0 ;

  p9_replay_ctrl.hold                           = '0 ;
  p9_replay_ctrl.enable                         = p8_replay_v_f & ~ p9_replay_ctrl.hold ;

  if ( p9_replay_ctrl.enable | p9_replay_ctrl.hold ) begin
    p9_replay_v_nxt                             = 1'b1 ;
  end
  if ( p9_replay_ctrl.enable ) begin
    p9_replay_data_nxt                          = p8_replay_data_f ;

    if ( p9_replay_data_nxt.cmd == HQM_NALB_CMD_ENQ_RORPLY ) begin
      if ( p9_replay_data_nxt.empty  ) begin
        rmw_replay_hp_p3_bypsel_nxt               = 1'b1 ;
        rmw_replay_hp_p3_bypaddr_nxt              = { 1'b0 , p9_rofrag_data_nxt.qid , p9_rofrag_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_replay_hp_p3_bypdata_nxt              = { 1'd0 , p9_rofrag_data_nxt.hp_parity , p9_rofrag_data_nxt.hp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end

      rmw_replay_tp_p3_bypsel_nxt               = 1'b1 ;
      rmw_replay_tp_p3_bypaddr_nxt              = { 1'b0 , p9_rofrag_data_nxt.qid , p9_rofrag_data_nxt.qpri [ 1 : 0 ] } ;
      rmw_replay_tp_p3_bypdata_nxt              = { 1'd0 , p9_rofrag_data_nxt.tp_parity , p9_rofrag_data_nxt.tp [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
    end
    if ( p9_replay_data_nxt.cmd == HQM_NALB_CMD_DEQ ) begin
      if ( ~ p9_replay_data_nxt.empty ) begin
        parity_check_rw_nxthp_p2_data_p         = rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] ;
        parity_check_rw_nxthp_p2_data_d         = rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rw_nxthp_p2_data_e         = 1'b1 ;

        rmw_replay_hp_p3_bypsel_nxt             = 1'b1 ;
        rmw_replay_hp_p3_bypaddr_nxt            = { 1'b0 , p9_replay_data_nxt.qid , p9_replay_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_replay_hp_p3_bypdata_nxt            = { 1'd0 , rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) ] , rw_nxthp_p2_data_f [ ( HQM_NALB_FLIDB2 ) - 1 : 0 ] } ;
      end
    end
  end


end




//------------------------------------------------------------------------------------------------------------------------------------------------
always_comb begin : L21
  //....................................................................................................
  // sidecar CFG
  //   control unit CFG registers
  //     reset status register (cfg accesible)
  //     default to init RAM
  //     check for pipe idle & stop processing


  //....................................................................................................
  // initial values


  // CFG registers defaults (prevent inferred latch )
  cfg_unit_idle_nxt = cfg_unit_idle_f ;
  cfg_csr_control_nxt = cfg_csr_control_f ;
  cfg_control0_nxt = cfg_control0_f ;
  cfg_control3_nxt = cfg_control3_f ;
  cfg_control4_nxt = cfg_control4_f ;
  cfg_control5_nxt = cfg_control5_f ;
  cfg_control6_nxt = cfg_control6_f ;
  cfg_control7_nxt = cfg_control7_f ;
  cfg_control8_nxt = cfg_control8_f ;
  cfg_control9_nxt = cfg_control9_f ;
  cfg_control10_nxt = cfg_control10_f ;
  cfg_control11_nxt = cfg_control11_f ;
  cfg_pipe_health_valid_00_nxt = cfg_pipe_health_valid_00_f ;
  cfg_pipe_health_valid_01_nxt = cfg_pipe_health_valid_01_f ;
  cfg_pipe_health_hold_00_nxt = cfg_pipe_health_hold_00_f ;
  cfg_pipe_health_hold_01_nxt = cfg_pipe_health_hold_01_f ;
  cfg_interface_nxt = cfg_interface_f ;
  cfg_error_inj_nxt = cfg_error_inj_f ;

  // PF reset state
reset_pf_counter_nxt = reset_pf_counter_f ;
reset_pf_active_nxt = reset_pf_active_f ;
reset_pf_done_nxt = reset_pf_done_f ;
hw_init_done_nxt = hw_init_done_f ;


  //....................................................................................................
  // CFG register update values
  cfg_pipe_health_valid_00_nxt                  = { 5'd0
                                                  , p8_replay_v_f
                                                  , p7_replay_v_f
                                                  , p6_replay_v_f
                                                  , p5_replay_v_f
                                                  , p4_replay_v_f
                                                  , p3_replay_v_f
                                                  , p2_replay_v_f
                                                  , p1_replay_v_f
                                                  , p0_replay_v_f

                                                  , p8_rofrag_v_f
                                                  , p7_rofrag_v_f
                                                  , p6_rofrag_v_f
                                                  , p5_rofrag_v_f
                                                  , p4_rofrag_v_f
                                                  , p3_rofrag_v_f
                                                  , p2_rofrag_v_f
                                                  , p1_rofrag_v_f
                                                  , p0_rofrag_v_f

                                                  , p8_nalb_v_f
                                                  , p7_nalb_v_f
                                                  , p6_nalb_v_f
                                                  , p5_nalb_v_f
                                                  , p4_nalb_v_f
                                                  , p3_nalb_v_f
                                                  , p2_nalb_v_f
                                                  , p1_nalb_v_f
                                                  , p0_nalb_v_f
                                                  } ;

  cfg_pipe_health_valid_01_nxt                  = { 23'd0
                                                  , p8_atq_v_f
                                                  , p7_atq_v_f
                                                  , p6_atq_v_f
                                                  , p5_atq_v_f
                                                  , p4_atq_v_f
                                                  , p3_atq_v_f
                                                  , p2_atq_v_f
                                                  , p1_atq_v_f
                                                  , p0_atq_v_f
                                                  } ;

  cfg_pipe_health_hold_00_nxt                   = { 5'd0
                                                  , p8_replay_ctrl.hold
                                                  , p7_replay_ctrl.hold
                                                  , p6_replay_ctrl.hold
                                                  , p5_replay_ctrl.hold
                                                  , p4_replay_ctrl.hold
                                                  , p3_replay_ctrl.hold
                                                  , p2_replay_ctrl.hold
                                                  , p1_replay_ctrl.hold
                                                  , p0_replay_ctrl.hold

                                                  , p8_rofrag_ctrl.hold
                                                  , p7_rofrag_ctrl.hold
                                                  , p6_rofrag_ctrl.hold
                                                  , p5_rofrag_ctrl.hold
                                                  , p4_rofrag_ctrl.hold
                                                  , p3_rofrag_ctrl.hold
                                                  , p2_rofrag_ctrl.hold
                                                  , p1_rofrag_ctrl.hold
                                                  , p0_rofrag_ctrl.hold


                                                  , p8_nalb_ctrl.hold
                                                  , p7_nalb_ctrl.hold
                                                  , p6_nalb_ctrl.hold
                                                  , p5_nalb_ctrl.hold
                                                  , p4_nalb_ctrl.hold
                                                  , p3_nalb_ctrl.hold
                                                  , p2_nalb_ctrl.hold
                                                  , p1_nalb_ctrl.hold
                                                  , p0_nalb_ctrl.hold
                                                  } ;

  cfg_pipe_health_hold_01_nxt                   = { 23'd0
                                                  , p8_atq_ctrl.hold
                                                  , p7_atq_ctrl.hold
                                                  , p6_atq_ctrl.hold
                                                  , p5_atq_ctrl.hold
                                                  , p4_atq_ctrl.hold
                                                  , p3_atq_ctrl.hold
                                                  , p2_atq_ctrl.hold
                                                  , p1_atq_ctrl.hold
                                                  , p0_atq_ctrl.hold
                                                  } ;

  cfg_status0                                   = { 1'b0
                                                  , int_status_pnc [ 7 ]
                                                  , int_status_pnc [ 6 ]
                                                  , int_status_pnc [ 1 ]
                                                  , int_status_pnc [ 0 ]
                                                  , rw_nxthp_p3_v_f
                                                  , rw_nxthp_p2_v_f
                                                  , rw_nxthp_p1_v_f
                                                  , rw_nxthp_p0_v_f
                                                  , rw_nxthp_p3_hold
                                                  , rw_nxthp_p2_hold
                                                  , rw_nxthp_p1_hold
                                                  , rmw_nalb_cnt_p3_v_f
                                                  , rmw_nalb_cnt_p2_v_f
                                                  , rmw_nalb_cnt_p1_v_f
                                                  , rmw_nalb_cnt_p0_v_f
                                                  , rmw_nalb_cnt_p3_hold
                                                  , rmw_nalb_cnt_p2_hold
                                                  , rmw_nalb_cnt_p1_hold
                                                  , rmw_nalb_hp_p3_v_f
                                                  , rmw_nalb_hp_p2_v_f
                                                  , rmw_nalb_hp_p1_v_f
                                                  , rmw_nalb_hp_p0_v_f
                                                  , rmw_nalb_hp_p3_hold
                                                  , rmw_nalb_hp_p2_hold
                                                  , rmw_nalb_hp_p1_hold
                                                  , rmw_nalb_tp_p3_v_f
                                                  , rmw_nalb_tp_p2_v_f
                                                  , rmw_nalb_tp_p1_v_f
                                                  , rmw_nalb_tp_p0_v_f
                                                  , rmw_nalb_tp_p3_hold
                                                  , rmw_nalb_tp_p2_hold
                                                  } ;
  cfg_status1                                   = { rmw_nalb_tp_p1_hold
                                                  , rmw_atq_cnt_p3_v_f
                                                  , rmw_atq_cnt_p2_v_f
                                                  , rmw_atq_cnt_p1_v_f
                                                  , rmw_atq_cnt_p0_v_f
                                                  , rmw_atq_cnt_p3_hold
                                                  , rmw_atq_cnt_p2_hold
                                                  , rmw_atq_cnt_p1_hold
                                                  , rmw_atq_hp_p3_v_f
                                                  , rmw_atq_hp_p2_v_f
                                                  , rmw_atq_hp_p1_v_f
                                                  , rmw_atq_hp_p0_v_f
                                                  , rmw_atq_hp_p3_hold
                                                  , rmw_atq_hp_p2_hold
                                                  , rmw_atq_hp_p1_hold
                                                  , rmw_atq_tp_p3_v_f
                                                  , rmw_atq_tp_p2_v_f
                                                  , rmw_atq_tp_p1_v_f
                                                  , rmw_atq_tp_p0_v_f
                                                  , rmw_atq_tp_p3_hold
                                                  , rmw_atq_tp_p2_hold
                                                  , rmw_atq_tp_p1_hold
                                                  , rmw_rofrag_cnt_p3_v_f
                                                  , rmw_rofrag_cnt_p2_v_f
                                                  , rmw_rofrag_cnt_p1_v_f
                                                  , rmw_rofrag_cnt_p0_v_f
                                                  , rmw_rofrag_cnt_p3_hold
                                                  , rmw_rofrag_cnt_p2_hold
                                                  , rmw_rofrag_cnt_p1_hold
                                                  , rmw_rofrag_hp_p3_v_f
                                                  , rmw_rofrag_hp_p2_v_f
                                                  , rmw_rofrag_hp_p1_v_f
                                                  } ;
  cfg_status2                                   = { rmw_rofrag_hp_p0_v_f
                                                  , rmw_rofrag_hp_p3_hold
                                                  , rmw_rofrag_hp_p2_hold
                                                  , rmw_rofrag_hp_p1_hold
                                                  , rmw_rofrag_tp_p3_v_f
                                                  , rmw_rofrag_tp_p2_v_f
                                                  , rmw_rofrag_tp_p1_v_f
                                                  , rmw_rofrag_tp_p0_v_f
                                                  , rmw_rofrag_tp_p3_hold
                                                  , rmw_rofrag_tp_p2_hold
                                                  , rmw_rofrag_tp_p1_hold
                                                  , rmw_replay_cnt_p3_v_f
                                                  , rmw_replay_cnt_p2_v_f
                                                  , rmw_replay_cnt_p1_v_f
                                                  , rmw_replay_cnt_p0_v_f
                                                  , rmw_replay_cnt_p3_hold
                                                  , rmw_replay_cnt_p2_hold
                                                  , rmw_replay_cnt_p1_hold
                                                  , rmw_replay_hp_p3_v_f
                                                  , rmw_replay_hp_p2_v_f
                                                  , rmw_replay_hp_p1_v_f
                                                  , rmw_replay_hp_p0_v_f
                                                  , rmw_replay_hp_p3_hold
                                                  , rmw_replay_hp_p2_hold
                                                  , rmw_replay_hp_p1_hold
                                                  , rmw_replay_tp_p3_v_f
                                                  , rmw_replay_tp_p2_v_f
                                                  , rmw_replay_tp_p1_v_f
                                                  , rmw_replay_tp_p0_v_f
                                                  , rmw_replay_tp_p3_hold
                                                  , rmw_replay_tp_p2_hold
                                                  , rmw_replay_tp_p1_hold
                                                  } ;


  cfg_interface_nxt                             = { ~ int_idle , 3'd0
                                                  , 1'b0 , ~ rx_sync_rop_nalb_enq_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_rop_nalb_enq_idle 
                                                  , 1'b0 , ~ rx_sync_lsp_nalb_sch_unoord_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_lsp_nalb_sch_unoord_idle
                                                  , 1'b0 , ~ rx_sync_lsp_nalb_sch_rorply_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_lsp_nalb_sch_rorply_idle
                                                  , 1'b0 , ~ rx_sync_lsp_nalb_sch_atq_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_lsp_nalb_sch_atq_idle
                                                  , 1'b0 , tx_sync_nalb_lsp_enq_lb_ready , 1'b0 , ~ tx_sync_nalb_lsp_enq_lb_idle
                                                  , 1'b0 , tx_sync_nalb_lsp_enq_rorply_ready , 1'b0 , ~ tx_sync_nalb_lsp_enq_rorply_idle
                                                  , 1'b0 , tx_sync_nalb_qed_ready , 1'b0 , ~ tx_sync_nalb_qed_idle
                                                  } ;

  cfg_unit_idle_nxt.pipe_idle                   = ~ ( ( | cfg_pipe_health_valid_00_nxt ) | ( | cfg_pipe_health_valid_01_nxt ) ) ;

  cfg_unit_idle_nxt.unit_idle                   = ( ( cfg_unit_idle_nxt.pipe_idle )

                                                  & ( fifo_rop_nalb_enq_nalb_empty  )
                                                  & ( fifo_rop_nalb_enq_ro_empty  )
                                                  & ( fifo_lsp_nalb_sch_unoord_empty  )
                                                  & ( fifo_lsp_nalb_sch_rorply_empty  )
                                                  & ( fifo_lsp_nalb_sch_atq_empty  )
                                                  & ( fifo_nalb_qed_empty  )
                                                  & ( fifo_nalb_lsp_enq_lb_empty  )
                                                  & ( fifo_nalb_lsp_enq_rorply_empty  )

                                                  & ( tx_sync_nalb_lsp_enq_lb_idle )
                                                  & ( tx_sync_nalb_lsp_enq_rorply_idle )
                                                  & ( tx_sync_nalb_qed_idle )

//reset                                                              & ~ cfg_reset_status_f.reset_active
//reset                                                              & ~ cfg_reset_status_f.vf_reset_active

//hqm_inp_gated_clk                                                  & ( cfg_ring_idle )
//hqm_inp_gated_clk                                                  & ( int_idle )
//hqm_inp_gated_clk                                                  & ( rx_sync_rop_nalb_enq_idle ) 
//hqm_inp_gated_clk                                                  & ( rx_sync_lsp_nalb_sch_unoord_idle )
//hqm_inp_gated_clk                                                  & ( rx_sync_lsp_nalb_sch_rorply_idle )
//hqm_inp_gated_clk                                                  & ( rx_sync_lsp_nalb_sch_atq_idle )

                                                  ) ;


  // top level ports
  nalb_reset_done = ~ ( hqm_gated_rst_n_active ) ;
  unit_idle_local = ~ ( hqm_gated_rst_n_active ) & cfg_unit_idle_nxt.unit_idle ;
  nalb_unit_pipeidle = cfg_unit_idle_f.pipe_idle ;


  //....................................................................................................
  // PF reset

pf_nalb_nxthp_re = '0 ;
pf_nalb_nxthp_addr = '0 ;
pf_nalb_nxthp_we = '0 ;
pf_nalb_nxthp_wdata = '0 ;
pf_atq_cnt_re = '0 ;
pf_atq_cnt_raddr = '0 ;
pf_atq_cnt_waddr = '0 ;
pf_atq_cnt_we = '0 ;
pf_atq_cnt_wdata = '0 ;
pf_nalb_replay_cnt_re = '0 ;
pf_nalb_replay_cnt_raddr = '0 ;
pf_nalb_replay_cnt_waddr = '0 ;
pf_nalb_replay_cnt_we = '0 ;
pf_nalb_replay_cnt_wdata = '0 ;
pf_nalb_hp_re = '0 ;
pf_nalb_hp_raddr = '0 ;
pf_nalb_hp_waddr = '0 ;
pf_nalb_hp_we = '0 ;
pf_nalb_hp_wdata = '0 ;
pf_lsp_nalb_sch_unoord_re = '0 ;
pf_lsp_nalb_sch_unoord_raddr = '0 ;
pf_lsp_nalb_sch_unoord_waddr = '0 ;
pf_lsp_nalb_sch_unoord_we = '0 ;
pf_lsp_nalb_sch_unoord_wdata = '0 ;
pf_rx_sync_lsp_nalb_sch_atq_re = '0 ;
pf_rx_sync_lsp_nalb_sch_atq_raddr = '0 ;
pf_rx_sync_lsp_nalb_sch_atq_waddr = '0 ;
pf_rx_sync_lsp_nalb_sch_atq_we = '0 ;
pf_rx_sync_lsp_nalb_sch_atq_wdata = '0 ;
pf_nalb_replay_hp_re = '0 ;
pf_nalb_replay_hp_raddr = '0 ;
pf_nalb_replay_hp_waddr = '0 ;
pf_nalb_replay_hp_we = '0 ;
pf_nalb_replay_hp_wdata = '0 ;
pf_rx_sync_lsp_nalb_sch_unoord_re = '0 ;
pf_rx_sync_lsp_nalb_sch_unoord_raddr = '0 ;
pf_rx_sync_lsp_nalb_sch_unoord_waddr = '0 ;
pf_rx_sync_lsp_nalb_sch_unoord_we = '0 ;
pf_rx_sync_lsp_nalb_sch_unoord_wdata = '0 ;
pf_lsp_nalb_sch_rorply_re = '0 ;
pf_lsp_nalb_sch_rorply_raddr = '0 ;
pf_lsp_nalb_sch_rorply_waddr = '0 ;
pf_lsp_nalb_sch_rorply_we = '0 ;
pf_lsp_nalb_sch_rorply_wdata = '0 ;
pf_nalb_lsp_enq_unoord_re = '0 ;
pf_nalb_lsp_enq_unoord_raddr = '0 ;
pf_nalb_lsp_enq_unoord_waddr = '0 ;
pf_nalb_lsp_enq_unoord_we = '0 ;
pf_nalb_lsp_enq_unoord_wdata = '0 ;
pf_rx_sync_rop_nalb_enq_re = '0 ;
pf_rx_sync_rop_nalb_enq_raddr = '0 ;
pf_rx_sync_rop_nalb_enq_waddr = '0 ;
pf_rx_sync_rop_nalb_enq_we = '0 ;
pf_rx_sync_rop_nalb_enq_wdata = '0 ;
pf_nalb_rofrag_hp_re = '0 ;
pf_nalb_rofrag_hp_raddr = '0 ;
pf_nalb_rofrag_hp_waddr = '0 ;
pf_nalb_rofrag_hp_we = '0 ;
pf_nalb_rofrag_hp_wdata = '0 ;
pf_nalb_cnt_re = '0 ;
pf_nalb_cnt_raddr = '0 ;
pf_nalb_cnt_waddr = '0 ;
pf_nalb_cnt_we = '0 ;
pf_nalb_cnt_wdata = '0 ;
pf_nalb_lsp_enq_rorply_re = '0 ;
pf_nalb_lsp_enq_rorply_raddr = '0 ;
pf_nalb_lsp_enq_rorply_waddr = '0 ;
pf_nalb_lsp_enq_rorply_we = '0 ;
pf_nalb_lsp_enq_rorply_wdata = '0 ;
pf_rop_nalb_enq_ro_re = '0 ;
pf_rop_nalb_enq_ro_raddr = '0 ;
pf_rop_nalb_enq_ro_waddr = '0 ;
pf_rop_nalb_enq_ro_we = '0 ;
pf_rop_nalb_enq_ro_wdata = '0 ;
pf_nalb_tp_re = '0 ;
pf_nalb_tp_raddr = '0 ;
pf_nalb_tp_waddr = '0 ;
pf_nalb_tp_we = '0 ;
pf_nalb_tp_wdata = '0 ;
pf_lsp_nalb_sch_atq_re = '0 ;
pf_lsp_nalb_sch_atq_raddr = '0 ;
pf_lsp_nalb_sch_atq_waddr = '0 ;
pf_lsp_nalb_sch_atq_we = '0 ;
pf_lsp_nalb_sch_atq_wdata = '0 ;
pf_nalb_qed_re = '0 ;
pf_nalb_qed_raddr = '0 ;
pf_nalb_qed_waddr = '0 ;
pf_nalb_qed_we = '0 ;
pf_nalb_qed_wdata = '0 ;
pf_nalb_replay_tp_re = '0 ;
pf_nalb_replay_tp_raddr = '0 ;
pf_nalb_replay_tp_waddr = '0 ;
pf_nalb_replay_tp_we = '0 ;
pf_nalb_replay_tp_wdata = '0 ;
pf_nalb_rofrag_cnt_re = '0 ;
pf_nalb_rofrag_cnt_raddr = '0 ;
pf_nalb_rofrag_cnt_waddr = '0 ;
pf_nalb_rofrag_cnt_we = '0 ;
pf_nalb_rofrag_cnt_wdata = '0 ;
pf_rx_sync_lsp_nalb_sch_rorply_re = '0 ;
pf_rx_sync_lsp_nalb_sch_rorply_raddr = '0 ;
pf_rx_sync_lsp_nalb_sch_rorply_waddr = '0 ;
pf_rx_sync_lsp_nalb_sch_rorply_we = '0 ;
pf_rx_sync_lsp_nalb_sch_rorply_wdata = '0 ;
pf_atq_hp_re = '0 ;
pf_atq_hp_raddr = '0 ;
pf_atq_hp_waddr = '0 ;
pf_atq_hp_we = '0 ;
pf_atq_hp_wdata = '0 ;
pf_nalb_rofrag_tp_re = '0 ;
pf_nalb_rofrag_tp_raddr = '0 ;
pf_nalb_rofrag_tp_waddr = '0 ;
pf_nalb_rofrag_tp_we = '0 ;
pf_nalb_rofrag_tp_wdata = '0 ;
pf_atq_tp_re = '0 ;
pf_atq_tp_raddr = '0 ;
pf_atq_tp_waddr = '0 ;
pf_atq_tp_we = '0 ;
pf_atq_tp_wdata = '0 ;
pf_rop_nalb_enq_unoord_re = '0 ;
pf_rop_nalb_enq_unoord_raddr = '0 ;
pf_rop_nalb_enq_unoord_waddr = '0 ;
pf_rop_nalb_enq_unoord_we = '0 ;
pf_rop_nalb_enq_unoord_wdata = '0 ;

  if ( hqm_gated_rst_n_start & reset_pf_active_f & ~ hw_init_done_f ) begin
    reset_pf_counter_nxt                        = reset_pf_counter_f + 32'b1 ;

    if ( reset_pf_counter_f < HQM_NALB_CFG_RST_PFMAX ) begin
      pf_nalb_nxthp_we                      = 1'b1 ;
      pf_nalb_nxthp_addr                    = reset_pf_counter_f [ ( HQM_NALB_RAM_UNOORD_NXTHP_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_nxthp_wdata                   = {  ecc_gen , ecc_gen_d_nc } ; 

      pf_nalb_cnt_we                        = ( reset_pf_counter_f < 32'd32 ) ;
      pf_nalb_cnt_waddr                     = reset_pf_counter_f [ ( HQM_NALB_RAM_UNOORD_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_cnt_wdata                     = { { 8 { 2'd0 } } , { HQM_NALB_CNTB2 * 8 { 1'b0 } } } ;

      pf_nalb_hp_we                         = ( reset_pf_counter_f < 32'd128 ) ;
      pf_nalb_hp_waddr                      = reset_pf_counter_f [ ( HQM_NALB_RAM_UNOORD_HP_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_hp_wdata                      = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;

      pf_nalb_tp_we                         = ( reset_pf_counter_f < 32'd128 ) ;
      pf_nalb_tp_waddr                      = reset_pf_counter_f [ ( HQM_NALB_RAM_UNOORD_TP_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_tp_wdata                      = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;

      pf_atq_cnt_we                         = ( reset_pf_counter_f < 32'd32 ) ;
      pf_atq_cnt_waddr                      = reset_pf_counter_f [ ( HQM_NALB_RAM_ATQ_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_atq_cnt_wdata                      = { { 8 { 2'd0 } } , { HQM_NALB_CNTB2 * 8 { 1'b0 } } } ;

      pf_atq_hp_we                          = ( reset_pf_counter_f < 32'd128 ) ;
      pf_atq_hp_waddr                       = reset_pf_counter_f [ ( HQM_NALB_RAM_ATQ_HP_DEPTHB2 ) - 1 : 0 ] ;
      pf_atq_hp_wdata                       = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;

      pf_atq_tp_we                          = ( reset_pf_counter_f < 32'd128 ) ;
      pf_atq_tp_waddr                       = reset_pf_counter_f [ ( HQM_NALB_RAM_ATQ_TP_DEPTHB2 ) - 1 : 0 ] ;
      pf_atq_tp_wdata                       = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;

      pf_nalb_rofrag_cnt_we                 = ( reset_pf_counter_f < 32'd512 ) ;
      pf_nalb_rofrag_cnt_waddr              = reset_pf_counter_f [ ( HQM_NALB_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_rofrag_cnt_wdata              = { 2'd0 , { HQM_NALB_CNTB2 { 1'b0 } } } ;

      pf_nalb_rofrag_hp_we                  = ( reset_pf_counter_f < 32'd512 ) ;
      pf_nalb_rofrag_hp_waddr               = reset_pf_counter_f [ ( HQM_NALB_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_rofrag_hp_wdata               = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;

      pf_nalb_rofrag_tp_we                  = ( reset_pf_counter_f < 32'd512 ) ;
      pf_nalb_rofrag_tp_waddr               = reset_pf_counter_f [ ( HQM_NALB_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_rofrag_tp_wdata               = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;

      pf_nalb_replay_cnt_we                 = ( reset_pf_counter_f < 32'd32 ) ;
      pf_nalb_replay_cnt_waddr              = reset_pf_counter_f [ ( HQM_NALB_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_replay_cnt_wdata              = { { 8 { 2'd0 } } , { HQM_NALB_CNTB2 * 8 { 1'b0 } } } ;

      pf_nalb_replay_hp_we                  = ( reset_pf_counter_f < 32'd128 ) ;
      pf_nalb_replay_hp_waddr               = reset_pf_counter_f [ ( HQM_NALB_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_replay_hp_wdata               = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;

      pf_nalb_replay_tp_we                  = ( reset_pf_counter_f < 32'd128 ) ;
      pf_nalb_replay_tp_waddr               = reset_pf_counter_f [ ( HQM_NALB_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] ;
      pf_nalb_replay_tp_wdata               = { 1'd0 , 1'b1 , { HQM_NALB_FLIDB2 { 1'b0 } } } ;
    end
    else begin
      reset_pf_counter_nxt                      = reset_pf_counter_f ;
      hw_init_done_nxt                          = 1'b1 ;
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
  smon_v [ 0 * 1 +: 1 ]                                  = fifo_rop_nalb_enq_nalb_push ;
  smon_comp [ 0 * 32 +: 32 ]                             = { 25'd0 , { 1'b0 , fifo_rop_nalb_enq_nalb_push_data.hist_list_info.qid } } ;
  smon_val [ 0 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 1 * 1 +: 1 ]                                  = fifo_rop_nalb_enq_ro_push ;
  smon_comp [ 1 * 32 +: 32 ]                             = { 25'd0 , { 1'b0 , fifo_rop_nalb_enq_ro_push_data.hist_list_info.qid } } ;
  smon_val [ 1 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 2 * 1 +: 1 ]                                  = 1'b0 ;
  smon_comp [ 2 * 32 +: 32 ]                             = 32'd0 ;
  smon_val [ 2 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 3 * 1 +: 1 ]                                  = fifo_lsp_nalb_sch_unoord_push ;
  smon_comp [ 3 * 32 +: 32 ]                             = { 25'd0 , fifo_lsp_nalb_sch_unoord_push_data.qid } ;
  smon_val [ 3 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 4 * 1 +: 1 ]                                  = fifo_lsp_nalb_sch_rorply_push ;
  smon_comp [ 4 * 32 +: 32 ]                             = { 25'd0 , fifo_lsp_nalb_sch_rorply_push_data.qid } ;
  smon_val [ 4 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 5 * 1 +: 1 ]                                  = fifo_lsp_nalb_sch_atq_push ;
  smon_comp [ 5 * 32 +: 32 ]                             = { 25'd0 , fifo_lsp_nalb_sch_atq_push_data.qid } ;
  smon_val [ 5 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 6 * 1 +: 1 ]                                  = fifo_nalb_qed_push ;
  smon_comp [ 6 * 32 +: 32 ]                             = { 25'd0 , fifo_nalb_qed_push_data.qid } ;
  smon_val [ 6 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 7 * 1 +: 1 ]                                  = fifo_nalb_lsp_enq_lb_push ;
  smon_comp [ 7 * 32 +: 32 ]                             = { 25'd0 , fifo_nalb_lsp_enq_lb_push_data.qid } ;
  smon_val [ 7 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 8 * 1 +: 1 ]                                  = fifo_nalb_lsp_enq_rorply_push ;
  smon_comp [ 8 * 32 +: 32 ]                             = { 25'd0 , fifo_nalb_lsp_enq_rorply_push_data.qid } ;
  smon_val [ 8 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 9 * 1 +: 1 ]                                  = tx_sync_nalb_qed_v & ~ tx_sync_nalb_qed_ready ;
  smon_comp [ 9 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 9 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 10 * 1 +: 1 ]                                 = tx_sync_nalb_lsp_enq_rorply_v & ~ tx_sync_nalb_lsp_enq_rorply_ready ;
  smon_comp [ 10 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 10 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 11 * 1 +: 1 ]                                 = tx_sync_nalb_lsp_enq_lb_v & ~ tx_sync_nalb_lsp_enq_lb_ready ;
  smon_comp [ 11 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 11 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 12 * 1 +: 1 ]                                 = rx_sync_lsp_nalb_sch_atq_v & ~ rx_sync_lsp_nalb_sch_atq_ready ;
  smon_comp [ 12 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 12 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 13 * 1 +: 1 ]                                 = rx_sync_lsp_nalb_sch_rorply_v & ~ rx_sync_lsp_nalb_sch_rorply_ready ;
  smon_comp [ 13 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 13 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 14 * 1 +: 1 ]                                 = rx_sync_lsp_nalb_sch_unoord_v & ~ rx_sync_lsp_nalb_sch_unoord_ready ;
  smon_comp [ 14 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 14 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 15 * 1 +: 1 ]                                 = rx_sync_rop_nalb_enq_v & ~ rx_sync_rop_nalb_enq_ready ;
  smon_comp [ 15 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 15 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 16 * 1 +: 1 ]                                 = stall ;
  smon_comp [ 16 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 16 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 17 * 1 +: 1 ]                                 = nalb_stall_f [ 4 ] ;
  smon_comp [ 17 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 17 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 18 * 1 +: 1 ]                                 = ordered_stall_f [ 7 ] ;
  smon_comp [ 18 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 18 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 19 * 1 +: 1 ]                                 = atq_stall_f [ 4 ] ;
  smon_comp [ 19 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 19 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 20 * 1 +: 1 ]                                 = hqm_proc_clk_en_fall ;
  smon_comp [ 20 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 20 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 21 * 1 +: 1 ]                                 = 1'b0 ;
  smon_comp [ 21 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 21 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 22 * 1 +: 1 ]                                 = 1'b0 ;
  smon_comp [ 22 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 22 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 23 * 1 +: 1 ]                                 = 1'b0 ;
  smon_comp [ 23 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 23 * 32 +: 32 ]                             = 32'd1 ;


  //..................................................
  //Feature detect
  cfg_control9_nxt [ 0 ] = cfg_control9_f [ 0 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 1 ] = cfg_control9_f [ 1 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 1 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 2 ] = cfg_control9_f [ 2 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 2 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 3 ] = cfg_control9_f [ 3 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 3 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 4 ] = cfg_control9_f [ 4 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 4 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 5 ] = cfg_control9_f [ 5 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 5 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 6 ] = cfg_control9_f [ 6 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 6 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 7 ] = cfg_control9_f [ 7 ] | ( func_nalb_cnt_we & ( | wire_func_nalb_cnt_wdata [ ( 7 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 8 ] = cfg_control9_f [ 8 ] | ( func_nalb_rofrag_cnt_we & ( | func_nalb_rofrag_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 16 ] = cfg_control9_f [ 16 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 17 ] = cfg_control9_f [ 17 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 1 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 18 ] = cfg_control9_f [ 18 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 2 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 19 ] = cfg_control9_f [ 19 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 3 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 20 ] = cfg_control9_f [ 20 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 4 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 21 ] = cfg_control9_f [ 21 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 5 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 22 ] = cfg_control9_f [ 22 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 6 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 23 ] = cfg_control9_f [ 23 ] | ( func_nalb_replay_cnt_we & ( | wire_func_nalb_replay_cnt_wdata [ ( 7 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 24 ] = cfg_control9_f [ 24 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 25 ] = cfg_control9_f [ 25 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 1 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 26 ] = cfg_control9_f [ 26 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 2 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 27 ] = cfg_control9_f [ 27 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 3 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 28 ] = cfg_control9_f [ 28 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 4 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 29 ] = cfg_control9_f [ 29 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 5 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 30 ] = cfg_control9_f [ 30 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 6 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;
  cfg_control9_nxt [ 31 ] = cfg_control9_f [ 31 ] | ( func_atq_cnt_we & ( | wire_func_atq_cnt_wdata [ ( 7 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] ) ) ;

  cfg_control10_nxt [ 0 ] = cfg_control10_f [ 0 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 1 ] = cfg_control10_f [ 1 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 1 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 2 ] = cfg_control10_f [ 2 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 2 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 3 ] = cfg_control10_f [ 3 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 3 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 4 ] = cfg_control10_f [ 4 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 4 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 5 ] = cfg_control10_f [ 5 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 5 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 6 ] = cfg_control10_f [ 6 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 6 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 7 ] = cfg_control10_f [ 7 ] | ( func_nalb_cnt_we & ( wire_func_nalb_cnt_wdata [ ( 7 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 8 ] = cfg_control10_f [ 8 ] | ( func_nalb_rofrag_cnt_we & ( func_nalb_rofrag_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 16 ] = cfg_control10_f [ 16 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 17 ] = cfg_control10_f [ 17 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 1 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 18 ] = cfg_control10_f [ 18 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 2 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 19 ] = cfg_control10_f [ 19 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 3 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 20 ] = cfg_control10_f [ 20 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 4 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 )  ) ;
  cfg_control10_nxt [ 21 ] = cfg_control10_f [ 21 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 5 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 22 ] = cfg_control10_f [ 22 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 6 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 23 ] = cfg_control10_f [ 23 ] | ( func_nalb_replay_cnt_we & ( wire_func_nalb_replay_cnt_wdata [ ( 7 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 24 ] = cfg_control10_f [ 24 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 0 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 25 ] = cfg_control10_f [ 25 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 1 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 26 ] = cfg_control10_f [ 26 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 2 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 27 ] = cfg_control10_f [ 27 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 3 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 28 ] = cfg_control10_f [ 28 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 4 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 29 ] = cfg_control10_f [ 29 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 5 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 30 ] = cfg_control10_f [ 30 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 6 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;
  cfg_control10_nxt [ 31 ] = cfg_control10_f [ 31 ] | ( func_atq_cnt_we & ( wire_func_atq_cnt_wdata [ ( 7 * HQM_NALB_CNTB2 ) +: HQM_NALB_CNTB2 ] == 'd16384 ) ) ;

  cfg_control10_nxt [ 9 ] = cfg_control10_f [ 9 ] | ( | int_inf_v ) ;


  //control CFG access. Queue the CFG access until the pipe is idle then issue the reqeust and keep the pipe idle until complete
  cfg_req_ready = cfg_unit_idle_f.cfg_ready ;
  cfg_unit_idle_nxt.cfg_ready                   = ( ( cfg_unit_idle_nxt.pipe_idle  )
                                                  ) ;




end



//tieoff machine inserted code
logic tieoff_nc ;
assign tieoff_nc = 
//reuse modules inserted by script cannot include _nc
  ( | hqm_nalb_target_cfg_smon_smon_enabled )
| ( | hqm_nalb_target_cfg_smon_smon_interrupt )
| ( | hqm_nalb_target_cfg_syndrome_00_syndrome_data )
| ( | hqm_nalb_target_cfg_syndrome_01_syndrome_data )
| ( | cfg_pipe_health_hold_01_f )
| ( | cfg_pipe_health_valid_01_f )
| ( | cfg_interface_f )
| ( | cfg_pipe_health_hold_00_f )
| ( | cfg_pipe_health_valid_00_f )
| ( | pf_nalb_nxthp_rdata )
| ( | pf_atq_cnt_wdata )
| ( | pf_atq_cnt_rdata )
| ( | pf_lsp_nalb_sch_unoord_rdata )
| ( | pf_nalb_replay_cnt_wdata )
| ( | pf_nalb_replay_cnt_rdata )
| ( | pf_nalb_hp_rdata )
| ( | pf_rx_sync_lsp_nalb_sch_atq_rdata )
| ( | pf_rx_sync_lsp_nalb_sch_unoord_rdata )
| ( | pf_nalb_replay_hp_rdata )
| ( | pf_lsp_nalb_sch_rorply_rdata )
| ( | pf_nalb_lsp_enq_unoord_rdata )
| ( | pf_rx_sync_rop_nalb_enq_rdata )
| ( | pf_nalb_rofrag_hp_rdata )
| ( | pf_nalb_lsp_enq_rorply_rdata )
| ( | pf_nalb_cnt_wdata )
| ( | pf_nalb_cnt_rdata )
| ( | pf_rop_nalb_enq_ro_rdata )
| ( | pf_nalb_tp_rdata )
| ( | pf_lsp_nalb_sch_atq_rdata )
| ( | pf_nalb_qed_rdata )
| ( | pf_nalb_replay_tp_rdata )
| ( | pf_nalb_rofrag_cnt_wdata )
| ( | pf_nalb_rofrag_cnt_rdata )
| ( | pf_rx_sync_lsp_nalb_sch_rorply_rdata )
| ( | pf_atq_hp_rdata )
| ( | pf_nalb_rofrag_tp_rdata )
| ( | pf_atq_tp_rdata )
| ( | pf_rop_nalb_enq_unoord_rdata )
| ( | cfg_req_write )
| ( | cfg_req_read )
| ( | int_status_pnc )
//cannot mark part of struct with _nc for pipe levels it is not used
| ( | p7_nalb_ctrl [1] )
| ( | p1_nalb_ctrl [1] )
| ( | p2_nalb_ctrl [1] )
| ( | p0_nalb_ctrl [1] )
| ( | p9_nalb_ctrl [1] )
| ( | p4_nalb_ctrl [1] )
| ( | p8_nalb_ctrl [1] )
| ( | p5_nalb_ctrl [1] )
| ( | p3_nalb_ctrl [1] )
| ( | p7_atq_ctrl [1] )
| ( | p9_atq_ctrl [1] )
| ( | p8_atq_ctrl [1] )
| ( | p3_atq_ctrl [1] )
| ( | p2_atq_ctrl [1] )
| ( | p4_atq_ctrl [1] )
| ( | p5_atq_ctrl [1] )
| ( | p1_atq_ctrl [1] )
| ( | p0_atq_ctrl [1] )
| ( | p1_rofrag_ctrl [1] )
| ( | p5_rofrag_ctrl [1] )
| ( | p4_rofrag_ctrl [1] )
| ( | p9_rofrag_ctrl [1] )
| ( | p2_rofrag_ctrl [1] )
| ( | p0_rofrag_ctrl [1] )
| ( | p8_rofrag_ctrl [1] )
| ( | p7_rofrag_ctrl [1] )
| ( | p3_rofrag_ctrl [1] )
| ( | p4_replay_ctrl [1] )
| ( | p3_replay_ctrl [1] )
| ( | p9_replay_ctrl [1] )
| ( | p8_replay_ctrl [1] )
| ( | p1_replay_ctrl [1] )
| ( | p0_replay_ctrl [1] )
| ( | p2_replay_ctrl [1] )
| ( | p7_replay_ctrl [1] )
| ( | p5_replay_ctrl [1] )
//nets tied to '0 reported as 70036
| ( | pf_atq_cnt_wdata )
| ( | pf_nalb_replay_cnt_wdata )
| ( | pf_nalb_cnt_wdata )
| ( | pf_nalb_rofrag_cnt_wdata )
//partial fields used, put here to avoid pnc suffix
| ( | fifo_rop_nalb_enq_nalb_pop_data )
;


endmodule // hqm_nalb_pipe_core
