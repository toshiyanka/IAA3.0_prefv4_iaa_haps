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
// hqm_dir_pipe
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_dir_pipe_core
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

  , output logic dp_dqed_force_clockon

  , output logic                        dp_unit_idle
  , output logic                        dp_unit_pipeidle
  , output logic                        dp_reset_done

  // CFG interface
  , input  logic                        dp_cfg_req_up_read
  , input  logic                        dp_cfg_req_up_write
  , input  cfg_req_t                    dp_cfg_req_up
  , input  logic                        dp_cfg_rsp_up_ack
  , input  cfg_rsp_t                    dp_cfg_rsp_up
  , output logic                        dp_cfg_req_down_read
  , output logic                        dp_cfg_req_down_write
  , output cfg_req_t                    dp_cfg_req_down
  , output logic                        dp_cfg_rsp_down_ack
  , output cfg_rsp_t                    dp_cfg_rsp_down

  // interrupt interface
  , input  logic                        dp_alarm_up_v
  , output logic                        dp_alarm_up_ready
  , input  aw_alarm_t                   dp_alarm_up_data

  , output logic                        dp_alarm_down_v
  , input  logic                        dp_alarm_down_ready
  , output aw_alarm_t                   dp_alarm_down_data

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

  // dp_dqed interface
  , output logic                        dp_dqed_v
  , input  logic                        dp_dqed_ready
  , output dp_dqed_t                    dp_dqed_data

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
localparam HQM_DP_CFG_INT_DIS = 0 ;
localparam HQM_DP_CFG_INT_DIS_MBE = 2 ;
localparam HQM_DP_CFG_INT_DIS_SBE = 1 ;
localparam HQM_DP_CFG_INT_DIS_SYND = 31 ;
localparam HQM_DP_CFG_VASR_DIS = 30 ;
localparam HQM_DP_CHICKEN_33 = 2 ;
localparam HQM_DP_CHICKEN_50 = 1 ;
localparam HQM_DP_CHICKEN_REORDER_QID = 3 ;
localparam HQM_DP_CHICKEN_SIM = 0 ;
localparam HQM_DP_CHICKEN_V1MODE = 31 ;
localparam HQM_DP_CMD_DEQ = 2'd2 ;
localparam HQM_DP_CMD_ENQ = 2'd1 ;
localparam HQM_DP_CMD_ENQ_RORPLY = 2'd3 ;
localparam HQM_DP_CMD_NOOP = 2'd0 ;
localparam HQM_DP_DQED_DEPTH = NUM_CREDITS ;
localparam HQM_DP_DQED_DEPTHB2 = AW_logb2 ( HQM_DP_DQED_DEPTH - 1 ) + 1 ;
localparam HQM_DP_CNTB2 = ( NUM_CREDITS == 16384 ) ? HQM_DP_DQED_DEPTHB2 + 1 : HQM_DP_DQED_DEPTHB2 + 2 ;
localparam HQM_DP_FIFO_DP_DQED_DEPTH = 32 ;
localparam HQM_DP_FIFO_DP_DQED_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_DP_DQED_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_DP_DQED_WIDTH = 45 ;
localparam HQM_DP_FIFO_DP_DQED_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_DP_DQED_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_DIR_DEPTH = 16 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_DIR_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_DP_LSP_ENQ_DIR_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_DIR_WIDTH = 8 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_DIR_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_DP_LSP_ENQ_DIR_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_DEPTH = 16 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_WIDTH = 23 ;
localparam HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_DIR_DEPTH = 4 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_DIR_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_LSP_DP_SCH_DIR_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_DIR_WIDTH = 27 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_DIR_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_LSP_DP_SCH_DIR_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_RORPLY_DEPTH = 4 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_RORPLY_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_LSP_DP_SCH_RORPLY_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_RORPLY_WIDTH = 8 ;
localparam HQM_DP_FIFO_LSP_DP_SCH_RORPLY_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_LSP_DP_SCH_RORPLY_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_DIR_DEPTH = 4 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_DIR_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_ROP_DP_ENQ_DIR_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_DIR_WIDTH = 81 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_DIR_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_ROP_DP_ENQ_DIR_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RORPLY_DEPTH = 4 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RORPLY_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_ROP_DP_ENQ_RORPLY_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RORPLY_WIDTH = 81 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RORPLY_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_ROP_DP_ENQ_RORPLY_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RO_DEPTH = 4 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RO_DEPTHB2 = AW_logb2 ( HQM_DP_FIFO_ROP_DP_ENQ_RO_DEPTH - 1 ) + 1 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RO_WIDTH = 81 ;
localparam HQM_DP_FIFO_ROP_DP_ENQ_RO_WMWIDTH = AW_logb2 ( HQM_DP_FIFO_ROP_DP_ENQ_RO_DEPTH + 1 ) + 1 ;
localparam HQM_DP_FLIDB2 = HQM_DP_DQED_DEPTHB2 ;
localparam HQM_DP_NXTHP_DIR = 1'd0 ;
localparam HQM_DP_NXTHP_ORDERED = 1'd1 ;

localparam HQM_DP_NUM_DIR_QID = 128 ; //HQM_NUM_DIR_QID
localparam HQM_DP_NUM_PRI = 8 ; //HQM_NUM_PRI

localparam HQM_DP_RAM_DIR_CNT_DEPTH = HQM_DP_NUM_DIR_QID ;
localparam HQM_DP_RAM_DIR_CNT_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_DIR_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_DIR_CNT_WIDTH = HQM_DP_NUM_PRI * ( 15 + 2 ) ;
localparam HQM_DP_RAM_DIR_HP_DEPTH = HQM_DP_NUM_DIR_QID * HQM_DP_NUM_PRI ;
localparam HQM_DP_RAM_DIR_HP_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_DIR_HP_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_DIR_HP_WIDTH = ( HQM_DP_DQED_DEPTHB2 + 1 ) ;
localparam HQM_DP_RAM_DIR_NXTHP_DEPTH = HQM_DP_DQED_DEPTH ;
localparam HQM_DP_RAM_DIR_NXTHP_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_DIR_NXTHP_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_DIR_NXTHP_WIDTH = ( HQM_DP_DQED_DEPTHB2 + 1 + 6 ) ;
localparam HQM_DP_RAM_DIR_TP_DEPTH = HQM_DP_NUM_DIR_QID * HQM_DP_NUM_PRI ;
localparam HQM_DP_RAM_DIR_TP_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_DIR_TP_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_DIR_TP_WIDTH = ( HQM_DP_DQED_DEPTHB2 + 1 ) ;
localparam HQM_DP_RAM_REPLAY_CNT_DEPTH = 128 ;
localparam HQM_DP_RAM_REPLAY_CNT_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_REPLAY_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_REPLAY_CNT_WIDTH = 8 * ( 15 + 2 ) ;
localparam HQM_DP_RAM_REPLAY_HP_DEPTH = 1024 ;
localparam HQM_DP_RAM_REPLAY_HP_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_REPLAY_HP_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_REPLAY_HP_WIDTH = HQM_DP_DQED_DEPTHB2 + 1 ;
localparam HQM_DP_RAM_REPLAY_TP_DEPTH = 1024 ;
localparam HQM_DP_RAM_REPLAY_TP_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_REPLAY_TP_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_REPLAY_TP_WIDTH = HQM_DP_DQED_DEPTHB2 + 1 ;
localparam HQM_DP_RAM_ROFRAG_CNT_DEPTH = 512 ;
localparam HQM_DP_RAM_ROFRAG_CNT_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_ROFRAG_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_ROFRAG_CNT_WIDTH = ( 15 + 2 ) ;
localparam HQM_DP_RAM_ROFRAG_HP_DEPTH = 512 ;
localparam HQM_DP_RAM_ROFRAG_HP_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_ROFRAG_HP_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_ROFRAG_HP_WIDTH = HQM_DP_DQED_DEPTHB2 + 1 ;
localparam HQM_DP_RAM_ROFRAG_TP_DEPTH = 512 ;
localparam HQM_DP_RAM_ROFRAG_TP_DEPTHB2 = AW_logb2 ( HQM_DP_RAM_ROFRAG_TP_DEPTH - 1 ) + 1 ;
localparam HQM_DP_RAM_ROFRAG_TP_WIDTH = HQM_DP_DQED_DEPTHB2 + 1 ;
localparam HQM_DP_RO_ENQ_FRAG = 2'd0 ;
localparam HQM_DP_RO_ENQ_RORPLY = 2'd1 ;
localparam HQM_DP_RO_SCH_RORPLY = 2'd2 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_0 = 20'd1 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_1 = 20'd2 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_2 = 20'd3 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_3 = 20'd4 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_4 = 20'd5 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_5 = 20'd6 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_6 = 20'd7 ;
localparam HQM_DP_VF_RESET_CMD_CQ_WRITE_CNT_7 = 20'd8 ;
localparam HQM_DP_VF_RESET_CMD_DONE = 20'd15 ;
localparam HQM_DP_VF_RESET_CMD_INVALID = 20'd14 ;
localparam HQM_DP_VF_RESET_CMD_QID_READ_CNT_0 = 20'd9 ;
localparam HQM_DP_VF_RESET_CMD_QID_READ_CNT_X = 20'd11 ;
localparam HQM_DP_VF_RESET_CMD_QID_WRITE_CNT_X = 20'd12 ;
localparam HQM_DP_VF_RESET_CMD_QID_WRITE_CNT_Y = 20'd13 ;
localparam HQM_DP_VF_RESET_CMD_START = 20'd0 ;
localparam HQM_DP_CFG_RST_PFMAX = HQM_DP_DQED_DEPTH ;

typedef struct packed {  logic [ ( 2 ) - 1 : 0 ] cmd ;  logic [ ( 8 ) - 1 : 0 ] cq ;  logic [ ( 7 ) - 1 : 0 ] qid ;  logic [ ( 3 ) - 1 : 0 ] qidix ;  logic  parity ;  logic [ ( 3 ) - 1 : 0 ] qpri ;  logic  empty ;  logic [ ( HQM_DP_DQED_DEPTHB2 ) - 1 : 0 ] hp ;  logic [ ( HQM_DP_DQED_DEPTHB2 ) - 1 : 0 ] tp ;  logic [ ( HQM_DP_DQED_DEPTHB2 ) - 1 : 0 ] flid ;  logic  flid_parity ;  logic  hp_parity ;  logic  tp_parity ;  logic [ ( 15 ) - 1 : 0 ] frag_cnt ;  logic [ ( 2 ) - 1 : 0 ] frag_residue ;  logic  error ;  hqm_core_flags_t hqm_core_flags ;} hqm_dp_dir_data_t ;
typedef struct packed {logic  hold ;logic  bypsel ;logic  enable ;} hqm_dp_dir_ctrl_t ;
aw_alarm_syn_t [ ( HQM_DP_ALARM_NUM_COR ) - 1 : 0 ] int_cor_data ;
aw_alarm_syn_t [ ( HQM_DP_ALARM_NUM_INF ) - 1 : 0 ] int_inf_data ;
aw_alarm_syn_t [ ( HQM_DP_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_data ;
aw_rmwpipe_cmd_t rmw_dir_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_dir_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_hp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_dir_hp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_hp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_hp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_tp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_tp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_dir_tp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_tp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_dir_tp_p3_rw_f_nc ;
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

logic cfg_rx_idle ;
logic cfg_rx_enable ;
logic cfg_idle ;
logic int_idle ;
logic  arb_dir_cnt_winner_v ;
logic  arb_dir_update ;
logic  arb_dir_winner ;
logic  arb_dir_winner_v ;
logic  arb_nxthp_update ;
logic  arb_nxthp_winner_v ;
logic  arb_replay_cnt_winner_v ;
logic  arb_ro_update ;
logic  arb_ro_winner_v ;



logic  error_badcmd0 ;
logic  error_dir_nopri ;
logic  error_dir_of ;
logic  error_replay_headroom ;
logic  error_replay_nopri ;
logic  error_replay_of ;
logic  error_rofrag_headroom ;
logic  error_rofrag_of ;
logic  fifo_dp_dqed_afull ;
logic  fifo_dp_dqed_empty ;
logic  fifo_dp_dqed_error_of ;
logic  fifo_dp_dqed_error_uf ;
logic  fifo_dp_dqed_full_nc ;
logic  fifo_dp_dqed_pop ;
logic  fifo_dp_dqed_push ;
logic  fifo_dp_lsp_enq_dir_afull ;
logic  fifo_dp_lsp_enq_dir_empty ;
logic  fifo_dp_lsp_enq_dir_error_of ;
logic  fifo_dp_lsp_enq_dir_error_uf ;
logic  fifo_dp_lsp_enq_dir_full ;
logic  fifo_dp_lsp_enq_dir_pop ;
logic  fifo_dp_lsp_enq_dir_push ;
logic  fifo_dp_lsp_enq_rorply_afull ;
logic  fifo_dp_lsp_enq_rorply_empty ;
logic  fifo_dp_lsp_enq_rorply_error_of ;
logic  fifo_dp_lsp_enq_rorply_error_uf ;
logic  fifo_dp_lsp_enq_rorply_full_nc ;
logic  fifo_dp_lsp_enq_rorply_pop ;
logic  fifo_dp_lsp_enq_rorply_push ;
logic  fifo_lsp_dp_sch_dir_afull ;
logic  fifo_lsp_dp_sch_dir_empty ;
logic  fifo_lsp_dp_sch_dir_error_of ;
logic  fifo_lsp_dp_sch_dir_error_uf ;
logic  fifo_lsp_dp_sch_dir_full_nc ;
logic  fifo_lsp_dp_sch_dir_pop ;
logic  fifo_lsp_dp_sch_dir_push ;
logic  fifo_lsp_dp_sch_rorply_afull ;
logic  fifo_lsp_dp_sch_rorply_empty ;
logic  fifo_lsp_dp_sch_rorply_error_of ;
logic  fifo_lsp_dp_sch_rorply_error_uf ;
logic  fifo_lsp_dp_sch_rorply_full ;
logic  fifo_lsp_dp_sch_rorply_pop ;
logic  fifo_lsp_dp_sch_rorply_push ;
logic  fifo_rop_dp_enq_dir_afull ;
logic  fifo_rop_dp_enq_dir_empty ;
logic  fifo_rop_dp_enq_dir_error_of ;
logic  fifo_rop_dp_enq_dir_error_uf ;
logic  fifo_rop_dp_enq_dir_full_nc ;
logic  fifo_rop_dp_enq_dir_pop ;
logic  fifo_rop_dp_enq_dir_push ;
logic  fifo_rop_dp_enq_ro_afull ;
logic  fifo_rop_dp_enq_ro_empty ;
logic  fifo_rop_dp_enq_ro_error_of ;
logic  fifo_rop_dp_enq_ro_error_uf ;
logic  fifo_rop_dp_enq_ro_full_nc ;
logic  fifo_rop_dp_enq_ro_pop ;
logic  fifo_rop_dp_enq_ro_push ;
logic  p0_dir_v_f , p0_dir_v_nxt , p1_dir_v_f , p1_dir_v_nxt , p2_dir_v_f , p2_dir_v_nxt , p3_dir_v_f , p3_dir_v_nxt , p4_dir_v_f , p4_dir_v_nxt , p5_dir_v_f , p5_dir_v_nxt , p6_dir_v_f , p6_dir_v_nxt , p7_dir_v_f , p7_dir_v_nxt , p8_dir_v_f , p8_dir_v_nxt , p9_dir_v_f_nc , p9_dir_v_nxt ;
logic  p0_replay_v_f , p0_replay_v_nxt , p1_replay_v_f , p1_replay_v_nxt , p2_replay_v_f , p2_replay_v_nxt , p3_replay_v_f , p3_replay_v_nxt , p4_replay_v_f , p4_replay_v_nxt , p5_replay_v_f , p5_replay_v_nxt , p6_replay_v_f , p6_replay_v_nxt , p7_replay_v_f , p7_replay_v_nxt , p8_replay_v_f , p8_replay_v_nxt , p9_replay_v_f_nc , p9_replay_v_nxt ;
logic  p0_rofrag_v_f , p0_rofrag_v_nxt , p1_rofrag_v_f , p1_rofrag_v_nxt , p2_rofrag_v_f , p2_rofrag_v_nxt , p3_rofrag_v_f , p3_rofrag_v_nxt , p4_rofrag_v_f , p4_rofrag_v_nxt , p5_rofrag_v_f , p5_rofrag_v_nxt , p6_rofrag_v_f , p6_rofrag_v_nxt , p7_rofrag_v_f , p7_rofrag_v_nxt , p8_rofrag_v_f , p8_rofrag_v_nxt , p9_rofrag_v_f_nc , p9_rofrag_v_nxt ;
logic  parity_check_rmw_dir_hp_p2_e ;
logic  parity_check_rmw_dir_hp_p2_error ;
logic  parity_check_rmw_dir_hp_p2_p ;
logic  parity_check_rmw_dir_tp_p2_e ;
logic  parity_check_rmw_dir_tp_p2_error ;
logic  parity_check_rmw_dir_tp_p2_p ;
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
logic  parity_check_rx_sync_lsp_dp_sch_dir_e ;
logic  parity_check_rx_sync_lsp_dp_sch_dir_error ;
logic  parity_check_rx_sync_lsp_dp_sch_dir_p ;
logic  parity_check_rx_sync_lsp_dp_sch_rorply_e ;
logic  parity_check_rx_sync_lsp_dp_sch_rorply_error ;
logic  parity_check_rx_sync_lsp_dp_sch_rorply_p ;
logic  parity_check_rx_sync_rop_dp_enq_data_flid_e ;
logic  parity_check_rx_sync_rop_dp_enq_data_flid_error ;
logic  parity_check_rx_sync_rop_dp_enq_data_flid_p ;
logic  parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_e ;
logic  parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_error ;
logic  parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_p ;
logic  parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_e ;
logic  parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_error ;
logic  parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_p ;
logic  parity_check_rx_sync_rop_dp_enq_data_hist_list_e ;
logic  parity_check_rx_sync_rop_dp_enq_data_hist_list_error ;
logic  parity_check_rx_sync_rop_dp_enq_data_hist_list_p ;
logic  parity_gen_dir_rop_dp_enq_data_hist_list_p ;
logic  parity_gen_rofrag_rop_dp_enq_data_hist_list_p ;
logic  replay_stall_nxt ;
logic  residue_check_dir_cnt_e_nxt , residue_check_dir_cnt_e_f ;
logic  residue_check_dir_cnt_err ;
logic  residue_check_replay_cnt_e_nxt , residue_check_replay_cnt_e_f ;
logic  residue_check_replay_cnt_err ;
logic  residue_check_rofrag_cnt_e_nxt , residue_check_rofrag_cnt_e_f ;
logic  residue_check_rofrag_cnt_err ;
logic  residue_check_rx_sync_rop_dp_enq_e ;
logic  residue_check_rx_sync_rop_dp_enq_err ;
logic  rmw_dir_cnt_p0_hold ;
logic  rmw_dir_cnt_p0_v_f ;
logic  rmw_dir_cnt_p0_v_nxt ;
logic  rmw_dir_cnt_p1_hold ;
logic  rmw_dir_cnt_p1_v_f ;
logic  rmw_dir_cnt_p2_hold ;
logic  rmw_dir_cnt_p2_v_f ;
logic  rmw_dir_cnt_p3_bypsel_nxt ;
logic  rmw_dir_cnt_p3_hold ;
logic  rmw_dir_cnt_p3_v_f ;
logic  rmw_dir_cnt_status ;
logic  rmw_dir_hp_p0_hold ;
logic  rmw_dir_hp_p0_v_f ;
logic  rmw_dir_hp_p0_v_nxt ;
logic  rmw_dir_hp_p1_hold ;
logic  rmw_dir_hp_p1_v_f ;
logic  rmw_dir_hp_p2_hold ;
logic  rmw_dir_hp_p2_v_f ;
logic  rmw_dir_hp_p3_bypsel_nxt ;
logic  rmw_dir_hp_p3_hold ;
logic  rmw_dir_hp_p3_v_f ;
logic  rmw_dir_hp_status ;
logic  rmw_dir_tp_p0_hold ;
logic  rmw_dir_tp_p0_v_f ;
logic  rmw_dir_tp_p0_v_nxt ;
logic  rmw_dir_tp_p1_hold ;
logic  rmw_dir_tp_p1_v_f ;
logic  rmw_dir_tp_p2_hold ;
logic  rmw_dir_tp_p2_v_f ;
logic  rmw_dir_tp_p3_bypsel_nxt ;
logic  rmw_dir_tp_p3_hold ;
logic  rmw_dir_tp_p3_v_f ;
logic  rmw_dir_tp_status ;
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
logic  rx_sync_lsp_dp_sch_dir_ready ;
logic  rx_sync_lsp_dp_sch_dir_v ;
logic  rx_sync_lsp_dp_sch_rorply_ready ;
logic  rx_sync_lsp_dp_sch_rorply_v ;
logic  rx_sync_rop_dp_enq_ready ;
logic  rx_sync_rop_dp_enq_v ;

logic  tx_sync_dp_dqed_ready ;
logic  tx_sync_dp_dqed_v ;
logic  tx_sync_dp_lsp_enq_dir_ready ;
logic  tx_sync_dp_lsp_enq_dir_v ;
logic  tx_sync_dp_lsp_enq_rorply_ready ;
logic  tx_sync_dp_lsp_enq_rorply_v ;
logic [ ( $bits ( dp_alarm_up_data.unit ) - 1 ) : 0 ] int_uid ;
logic [ ( 1 ) - 1 : 0 ] arb_nxthp_winner ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control0_f , cfg_control0_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control2_f , cfg_control2_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control3_f , cfg_control3_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control4_f , cfg_control4_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control5_f , cfg_control5_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control6_f_pnc , cfg_control6_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control7_f_pnc , cfg_control7_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control8_f , cfg_control8_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_csr_control_f , cfg_csr_control_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_error_inj_f , cfg_error_inj_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_interface_f , cfg_interface_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_hold_00_f , cfg_pipe_health_hold_00_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_valid_00_f , cfg_pipe_health_valid_00_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status0 ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status1 ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_status2 ;
logic [ ( 15 ) - 1 : 0 ] ecc_gen_d_nc ;
logic [ ( 13 ) - 1 : 0 ] residue_check_rx_sync_rop_dp_enq_d ;
logic [ ( 15 ) - 1 : 0 ] parity_check_rx_sync_rop_dp_enq_data_flid_d ;
logic [ ( 15 ) - 1 : 0 ] parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_d ;
logic [ ( 15 ) - 1 : 0 ] parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_d ;
logic [ ( 18 ) - 1 : 0 ] parity_check_rx_sync_lsp_dp_sch_dir_d ;
logic [ ( 2 ) - 1 : 0 ] arb_dir_reqs ;
logic [ ( 2 ) - 1 : 0 ] arb_nxthp_reqs ;
logic [ ( 2 ) - 1 : 0 ] arb_ro_winner ;
logic [ ( 2 ) - 1 : 0 ] error_dir_headroom ;
logic [ ( 2 ) - 1 : 0 ] residue_add_dir_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_dir_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_dir_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_replay_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_replay_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_replay_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rofrag_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rofrag_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rofrag_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_dir_cnt_r_nxt , residue_check_dir_cnt_r_f ;
logic [ ( 2 ) - 1 : 0 ] residue_check_replay_cnt_r_nxt , residue_check_replay_cnt_r_f ;
logic [ ( 2 ) - 1 : 0 ] residue_check_rofrag_cnt_r_nxt , residue_check_rofrag_cnt_r_f ;
logic [ ( 2 ) - 1 : 0 ] residue_check_rx_sync_rop_dp_enq_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_dir_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_dir_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_dir_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_replay_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_replay_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_replay_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rofrag_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rofrag_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rofrag_cnt_r ;
logic [ ( 24 * 1 ) - 1 : 0 ] smon_v ;
logic [ ( 24 * 32 ) - 1 : 0 ] smon_comp ;
logic [ ( 24 * 32 ) - 1 : 0 ] smon_val ;
logic [ ( 29 ) - 1 : 0 ] parity_gen_dir_rop_dp_enq_data_hist_list_d ;
logic [ ( 29 ) - 1 : 0 ] parity_gen_rofrag_rop_dp_enq_data_hist_list_d ;
logic [ ( 3 ) - 1 : 0 ] arb_dir_cnt_winner ;
logic [ ( 3 ) - 1 : 0 ] arb_replay_cnt_winner ;
logic [ ( 3 ) - 1 : 0 ] arb_ro_reqs ;
logic [ ( 32 ) - 1 : 0 ]  reset_pf_counter_nxt , reset_pf_counter_f ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_control_nxt , cfg_agitate_control_f ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_select_nxt , cfg_agitate_select_f ;
logic [ ( 32 ) - 1 : 0 ] int_status_pnc ;
logic [ ( 35 ) - 1 : 0 ] parity_check_rx_sync_rop_dp_enq_data_hist_list_d ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_dqed_dir_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_dqed_dir_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_dqed_rorply_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_dqed_rorply_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_lsp_enq_dir_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_lsp_enq_dir_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_lsp_enq_rorply_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_dp_lsp_enq_rorply_cnt_nxt ;
logic [ ( 6 ) - 1 : 0 ] ecc_gen ;
logic [ ( 7 ) - 1 : 0 ] parity_check_rx_sync_lsp_dp_sch_rorply_d ;
aw_fifo_status_t rx_sync_lsp_dp_sch_dir_status_pnc ;
aw_fifo_status_t rx_sync_lsp_dp_sch_rorply_status_pnc ;
aw_fifo_status_t rx_sync_rop_dp_enq_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_dp_dqed_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_dp_lsp_enq_dir_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_dp_lsp_enq_rorply_status_pnc ;
logic [ ( 8 ) - 1 : 0 ] arb_dir_cnt_reqs ;
logic [ ( 8 ) - 1 : 0 ] arb_replay_cnt_reqs ;
logic [ ( HQM_DP_ALARM_NUM_COR ) - 1 : 0 ] int_cor_v ;
logic [ ( HQM_DP_ALARM_NUM_INF ) - 1 : 0 ] int_inf_v ;
logic [ ( HQM_DP_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_v ;





logic [ ( HQM_DP_CNTB2 ) - 1 : 0 ] residue_check_dir_cnt_d_nxt , residue_check_dir_cnt_d_f ;
logic [ ( HQM_DP_CNTB2 ) - 1 : 0 ] residue_check_replay_cnt_d_nxt , residue_check_replay_cnt_d_f ;
logic [ ( HQM_DP_CNTB2 ) - 1 : 0 ] residue_check_rofrag_cnt_d_nxt , residue_check_rofrag_cnt_d_f ;
logic [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] parity_check_rmw_dir_hp_p2_d ;
logic [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] parity_check_rmw_dir_tp_p2_d ;
logic [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] parity_check_rmw_replay_hp_p2_d ;
logic [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] parity_check_rmw_replay_tp_p2_d ;
logic [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] parity_check_rmw_rofrag_hp_p2_d ;
logic [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] parity_check_rmw_rofrag_tp_p2_d ;
logic [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] parity_check_rw_nxthp_p2_data_d ;
logic [ ( HQM_DP_RAM_DIR_CNT_DEPTHB2 ) - 1 : 0 ] rmw_dir_cnt_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_CNT_DEPTHB2 ) - 1 : 0 ] rmw_dir_cnt_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_DIR_CNT_DEPTHB2 ) - 1 : 0 ] rmw_dir_cnt_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_CNT_DEPTHB2 ) - 1 : 0 ] rmw_dir_cnt_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_CNT_DEPTHB2 ) - 1 : 0 ] rmw_dir_cnt_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_CNT_WIDTH ) - 1 : 0 ] rmw_dir_cnt_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_CNT_WIDTH ) - 1 : 0 ] rmw_dir_cnt_p0_write_data_nxt_nc ;
logic [ ( HQM_DP_RAM_DIR_CNT_WIDTH ) - 1 : 0 ] rmw_dir_cnt_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_CNT_WIDTH ) - 1 : 0 ] rmw_dir_cnt_p2_data_f ;
logic [ ( HQM_DP_RAM_DIR_CNT_WIDTH ) - 1 : 0 ] rmw_dir_cnt_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_DIR_CNT_WIDTH ) - 1 : 0 ] rmw_dir_cnt_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_HP_DEPTHB2 ) - 1 : 0 ] rmw_dir_hp_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_HP_DEPTHB2 ) - 1 : 0 ] rmw_dir_hp_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_DIR_HP_DEPTHB2 ) - 1 : 0 ] rmw_dir_hp_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_HP_DEPTHB2 ) - 1 : 0 ] rmw_dir_hp_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_HP_DEPTHB2 ) - 1 : 0 ] rmw_dir_hp_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_HP_DEPTHB2 ) - 1 : 0 ] rmw_dir_hp_p3_bypaddr_nxt ;
logic [ ( HQM_DP_RAM_DIR_HP_WIDTH ) - 1 : 0 ] rmw_dir_hp_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_HP_WIDTH ) - 1 : 0 ] rmw_dir_hp_p0_write_data_nxt ;
logic [ ( HQM_DP_RAM_DIR_HP_WIDTH ) - 1 : 0 ] rmw_dir_hp_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_HP_WIDTH ) - 1 : 0 ] rmw_dir_hp_p2_data_f ;
logic [ ( HQM_DP_RAM_DIR_HP_WIDTH ) - 1 : 0 ] rmw_dir_hp_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_DIR_HP_WIDTH ) - 1 : 0 ] rmw_dir_hp_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p0_byp_addr_nxt ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_DEPTHB2 ) - 1 : 0 ] rw_nxthp_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p0_byp_write_data_nxt ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p0_write_data_nxt ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p2_data_f ;
logic [ ( HQM_DP_RAM_DIR_NXTHP_WIDTH ) - 1 : 0 ] rw_nxthp_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_TP_DEPTHB2 ) - 1 : 0 ] rmw_dir_tp_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_TP_DEPTHB2 ) - 1 : 0 ] rmw_dir_tp_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_DIR_TP_DEPTHB2 ) - 1 : 0 ] rmw_dir_tp_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_TP_DEPTHB2 ) - 1 : 0 ] rmw_dir_tp_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_TP_DEPTHB2 ) - 1 : 0 ] rmw_dir_tp_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_DIR_TP_DEPTHB2 ) - 1 : 0 ] rmw_dir_tp_p3_bypaddr_nxt ;
logic [ ( HQM_DP_RAM_DIR_TP_WIDTH ) - 1 : 0 ] rmw_dir_tp_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_TP_WIDTH ) - 1 : 0 ] rmw_dir_tp_p0_write_data_nxt ;
logic [ ( HQM_DP_RAM_DIR_TP_WIDTH ) - 1 : 0 ] rmw_dir_tp_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_DIR_TP_WIDTH ) - 1 : 0 ] rmw_dir_tp_p2_data_f ;
logic [ ( HQM_DP_RAM_DIR_TP_WIDTH ) - 1 : 0 ] rmw_dir_tp_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_DIR_TP_WIDTH ) - 1 : 0 ] rmw_dir_tp_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] rmw_replay_cnt_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p0_write_data_nxt_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p2_data_f ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_CNT_WIDTH ) - 1 : 0 ] rmw_replay_cnt_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] rmw_replay_hp_p3_bypaddr_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p0_write_data_nxt_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p2_data_f ;
logic [ ( HQM_DP_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_HP_WIDTH ) - 1 : 0 ] rmw_replay_hp_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] rmw_replay_tp_p3_bypaddr_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p0_write_data_nxt_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p2_data_f ;
logic [ ( HQM_DP_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_REPLAY_TP_WIDTH ) - 1 : 0 ] rmw_replay_tp_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_cnt_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p0_write_data_nxt_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p2_data_f ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_CNT_WIDTH ) - 1 : 0 ] rmw_rofrag_cnt_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_hp_p3_bypaddr_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p0_write_data_nxt_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p2_data_f ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_HP_WIDTH ) - 1 : 0 ] rmw_rofrag_hp_p3_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p0_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p0_addr_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p1_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p2_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p3_addr_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] rmw_rofrag_tp_p3_bypaddr_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p0_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p0_write_data_nxt_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p1_data_f_nc ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p2_data_f ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p3_bypdata_nxt ;
logic [ ( HQM_DP_RAM_ROFRAG_TP_WIDTH ) - 1 : 0 ] rmw_rofrag_tp_p3_data_f_nc ;
logic [ 4 : 0 ] dir_stall_nxt , dir_stall_f ;
logic [ 7 : 0 ] ordered_stall_nxt , ordered_stall_f ;
logic [ HQM_DP_FIFO_DP_DQED_WMWIDTH - 1 : 0 ] fifo_dp_dqed_if_cfg_high_wm ;
logic [ HQM_DP_FIFO_DP_LSP_ENQ_DIR_WMWIDTH - 1 : 0 ] fifo_dp_lsp_enq_dir_if_cfg_high_wm ;
logic [ HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_WMWIDTH - 1 : 0 ] fifo_dp_lsp_enq_rorply_if_cfg_high_wm ;
logic [ HQM_DP_FIFO_LSP_DP_SCH_DIR_WMWIDTH - 1 : 0 ] fifo_lsp_dp_sch_dir_if_cfg_high_wm ;
logic [ HQM_DP_FIFO_LSP_DP_SCH_RORPLY_WMWIDTH - 1 : 0 ] fifo_lsp_dp_sch_rorply_if_cfg_high_wm ;
logic [ HQM_DP_FIFO_ROP_DP_ENQ_DIR_WMWIDTH - 1 : 0 ] fifo_rop_dp_enq_dir_if_cfg_high_wm ;
logic [ HQM_DP_FIFO_ROP_DP_ENQ_RO_WMWIDTH - 1 : 0 ] fifo_rop_dp_enq_ro_if_cfg_high_wm ;
aw_fifo_status_t fifo_dp_dqed_if_status ;
aw_fifo_status_t fifo_dp_lsp_enq_dir_if_status ;
aw_fifo_status_t fifo_dp_lsp_enq_rorply_if_status ;
aw_fifo_status_t fifo_lsp_dp_sch_dir_if_status ;
aw_fifo_status_t fifo_lsp_dp_sch_rorply_if_status ;
aw_fifo_status_t fifo_rop_dp_enq_dir_if_status ;
aw_fifo_status_t fifo_rop_dp_enq_ro_if_status ;
aw_fifo_status_t cfg_rx_fifo_status ;
logic dir_stall_nc ;
logic fifo_dp_dqed_dir_dec ;
logic fifo_dp_dqed_dir_inc ;
logic fifo_dp_dqed_rorply_dec ;
logic fifo_dp_dqed_rorply_inc ;
logic fifo_dp_lsp_enq_dir_dec ;
logic fifo_dp_lsp_enq_dir_inc ;
logic fifo_dp_lsp_enq_rorply_dec ;
logic fifo_dp_lsp_enq_rorply_inc ;
logic hw_init_done_f , hw_init_done_nxt ;
logic ordered_stall_nc ;
logic replay_stall ;
logic reset_pf_active_f , reset_pf_active_nxt ;
logic reset_pf_done_f , reset_pf_done_nxt ;
logic rofrag_stall ;
logic stall ;
logic wire_sr_dir_nxthp_we ;
hqm_dp_dir_data_t p0_dir_data_f , p0_dir_data_nxt , p1_dir_data_f , p1_dir_data_nxt , p2_dir_data_f , p2_dir_data_nxt , p3_dir_data_f , p3_dir_data_nxt , p4_dir_data_f , p4_dir_data_nxt , p5_dir_data_f , p5_dir_data_nxt , p6_dir_data_f , p6_dir_data_nxt , p7_dir_data_f , p7_dir_data_nxt , p8_dir_data_f , p8_dir_data_nxt , p9_dir_data_f , p9_dir_data_nxt ;
hqm_dp_dir_ctrl_t p0_dir_ctrl , p1_dir_ctrl , p2_dir_ctrl , p3_dir_ctrl , p4_dir_ctrl , p5_dir_ctrl , p6_dir_ctrl , p7_dir_ctrl , p8_dir_ctrl , p9_dir_ctrl ;
hqm_dp_dir_data_t p0_rofrag_data_f , p0_rofrag_data_nxt , p1_rofrag_data_f , p1_rofrag_data_nxt , p2_rofrag_data_f , p2_rofrag_data_nxt , p3_rofrag_data_f , p3_rofrag_data_nxt , p4_rofrag_data_f , p4_rofrag_data_nxt , p5_rofrag_data_f , p5_rofrag_data_nxt , p6_rofrag_data_f , p6_rofrag_data_nxt , p7_rofrag_data_f , p7_rofrag_data_nxt , p8_rofrag_data_f , p8_rofrag_data_nxt , p9_rofrag_data_f , p9_rofrag_data_nxt ;
hqm_dp_dir_ctrl_t p0_rofrag_ctrl , p1_rofrag_ctrl , p2_rofrag_ctrl , p3_rofrag_ctrl , p4_rofrag_ctrl , p5_rofrag_ctrl , p6_rofrag_ctrl , p7_rofrag_ctrl , p8_rofrag_ctrl , p9_rofrag_ctrl ;
hqm_dp_dir_data_t p0_replay_data_f , p0_replay_data_nxt , p1_replay_data_f , p1_replay_data_nxt , p2_replay_data_f , p2_replay_data_nxt , p3_replay_data_f , p3_replay_data_nxt , p4_replay_data_f , p4_replay_data_nxt , p5_replay_data_f , p5_replay_data_nxt , p6_replay_data_f , p6_replay_data_nxt , p7_replay_data_f , p7_replay_data_nxt , p8_replay_data_f , p8_replay_data_nxt , p9_replay_data_f , p9_replay_data_nxt ;
hqm_dp_dir_ctrl_t p0_replay_ctrl , p1_replay_ctrl , p2_replay_ctrl , p3_replay_ctrl , p4_replay_ctrl , p5_replay_ctrl , p6_replay_ctrl , p7_replay_ctrl , p8_replay_ctrl , p9_replay_ctrl ;
rop_dp_enq_t rx_sync_rop_dp_enq_data ;
lsp_dp_sch_dir_t rx_sync_lsp_dp_sch_dir_data ;
lsp_dp_sch_rorply_t rx_sync_lsp_dp_sch_rorply_data ;
dp_lsp_enq_dir_t tx_sync_dp_lsp_enq_dir_data ;
dp_lsp_enq_rorply_t tx_sync_dp_lsp_enq_rorply_data ;
dp_dqed_t tx_sync_dp_dqed_data ;
rop_dp_enq_t fifo_rop_dp_enq_dir_push_data ;
rop_dp_enq_t fifo_rop_dp_enq_dir_pop_data ;
rop_dp_enq_t wire_fifo_rop_dp_enq_dir_pop_data ;
rop_dp_enq_t fifo_rop_dp_enq_ro_push_data ;
rop_dp_enq_t fifo_rop_dp_enq_ro_pop_data ;
logic fifo_rop_dp_enq_ro_pop_data_parity_error ;
logic fifo_rop_dp_enq_dir_pop_data_parity_error ;
rop_dp_enq_t wire_fifo_rop_dp_enq_ro_pop_data ;
lsp_dp_sch_dir_t fifo_lsp_dp_sch_dir_push_data ;
lsp_dp_sch_dir_t fifo_lsp_dp_sch_dir_pop_data ;
lsp_dp_sch_rorply_t fifo_lsp_dp_sch_rorply_push_data ;
lsp_dp_sch_rorply_t fifo_lsp_dp_sch_rorply_pop_data ;
dp_dqed_t fifo_dp_dqed_push_data ;
dp_dqed_t fifo_dp_dqed_pop_data ;
dp_lsp_enq_dir_t fifo_dp_lsp_enq_dir_push_data ;
dp_lsp_enq_dir_t fifo_dp_lsp_enq_dir_pop_data ;
dp_lsp_enq_rorply_t fifo_dp_lsp_enq_rorply_push_data ;
dp_lsp_enq_rorply_t fifo_dp_lsp_enq_rorply_pop_data ;

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
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write ; //I CFG
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read ; //I CFG
cfg_req_t pfcsr_cfg_req ; //I CFG
logic pfcsr_cfg_rsp_ack ; //O CFG
logic pfcsr_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata ; //O CFG
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_nxt ; //I HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_f ; //O HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0
logic hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_v ; //I HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_dir_1_status ; //I HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt ; //I HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_f ; //O HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0
logic hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_v ; //I HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_replay_1_status ; //I HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_general_reg_nxt ; //I HQM_DP_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_general_reg_f ; //O HQM_DP_TARGET_CFG_CONTROL_GENERAL
logic hqm_dp_target_cfg_control_general_reg_v ; //I HQM_DP_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_pipeline_credits_reg_nxt ; //I HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_pipeline_credits_reg_f ; //O HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic hqm_dp_target_cfg_control_pipeline_credits_reg_v ; //I HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_00_reg_nxt ; //I HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_00_reg_f ; //O HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_01_reg_nxt ; //I HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_01_reg_f ; //O HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_diagnostic_aw_status_status ; //I HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_diagnostic_aw_status_01_status ; //I HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_diagnostic_aw_status_02_status ; //I HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_dir_csr_control_reg_nxt ; //I HQM_DP_TARGET_CFG_DIR_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_dir_csr_control_reg_f ; //O HQM_DP_TARGET_CFG_DIR_CSR_CONTROL
logic hqm_dp_target_cfg_dir_csr_control_reg_v ; //I HQM_DP_TARGET_CFG_DIR_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_error_inject_reg_nxt ; //I HQM_DP_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_error_inject_reg_f ; //O HQM_DP_TARGET_CFG_ERROR_INJECT
logic hqm_dp_target_cfg_error_inject_reg_v ; //I HQM_DP_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_nxt ; //I HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_f ; //O HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_nxt ; //I HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_f ; //O HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_nxt ; //I HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_f ; //O HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_nxt ; //I HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_f ; //O HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_nxt ; //I HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_f ; //O HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_nxt ; //I HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_f ; //O HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_nxt ; //I HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_f ; //O HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_control_reg_nxt ; //I HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_control_reg_f ; //O HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL
logic hqm_dp_target_cfg_hw_agitate_control_reg_v ; //I HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_select_reg_nxt ; //I HQM_DP_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_select_reg_f ; //O HQM_DP_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_dp_target_cfg_hw_agitate_select_reg_v ; //I HQM_DP_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_interface_status_reg_nxt ; //I HQM_DP_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_interface_status_reg_f ; //O HQM_DP_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_patch_control_reg_nxt ; //I HQM_DP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_patch_control_reg_f ; //O HQM_DP_TARGET_CFG_PATCH_CONTROL
logic hqm_dp_target_cfg_patch_control_reg_v ; //I HQM_DP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_hold_00_reg_nxt ; //I HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_hold_00_reg_f ; //O HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_valid_00_reg_nxt ; //I HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_valid_00_reg_f ; //O HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00
logic hqm_dp_target_cfg_smon_disable_smon ; //I HQM_DP_TARGET_CFG_SMON
logic [ 24 - 1 : 0 ] hqm_dp_target_cfg_smon_smon_v ; //I HQM_DP_TARGET_CFG_SMON
logic [ ( 24 * 32 ) - 1 : 0 ] hqm_dp_target_cfg_smon_smon_comp ; //I HQM_DP_TARGET_CFG_SMON
logic [ ( 24 * 32 ) - 1 : 0 ] hqm_dp_target_cfg_smon_smon_val ; //I HQM_DP_TARGET_CFG_SMON
logic hqm_dp_target_cfg_smon_smon_enabled ; //O HQM_DP_TARGET_CFG_SMON
logic hqm_dp_target_cfg_smon_smon_interrupt ; //O HQM_DP_TARGET_CFG_SMON
logic hqm_dp_target_cfg_syndrome_00_capture_v ; //I HQM_DP_TARGET_CFG_SYNDROME_00
logic [ ( 31 ) - 1 : 0] hqm_dp_target_cfg_syndrome_00_capture_data ; //I HQM_DP_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_syndrome_00_syndrome_data ; //I HQM_DP_TARGET_CFG_SYNDROME_00
logic hqm_dp_target_cfg_syndrome_01_capture_v ; //I HQM_DP_TARGET_CFG_SYNDROME_01
logic [ ( 31 ) - 1 : 0] hqm_dp_target_cfg_syndrome_01_capture_data ; //I HQM_DP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_syndrome_01_syndrome_data ; //I HQM_DP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_idle_reg_nxt ; //I HQM_DP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_idle_reg_f ; //O HQM_DP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_timeout_reg_nxt ; //I HQM_DP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_timeout_reg_f ; //O HQM_DP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_version_status ; //I HQM_DP_TARGET_CFG_UNIT_VERSION
hqm_dp_pipe_register_pfcsr i_hqm_dp_pipe_register_pfcsr (
  .hqm_gated_clk ( hqm_gated_clk ) 
, .hqm_gated_rst_n ( hqm_gated_rst_n ) 
, .rst_prep ( '0 )
, .cfg_req_write ( pfcsr_cfg_req_write )
, .cfg_req_read ( pfcsr_cfg_req_read )
, .cfg_req ( pfcsr_cfg_req )
, .cfg_rsp_ack ( pfcsr_cfg_rsp_ack )
, .cfg_rsp_err ( pfcsr_cfg_rsp_err )
, .cfg_rsp_rdata ( pfcsr_cfg_rsp_rdata )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_nxt ( hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_nxt )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_f ( hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_f )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_v (  hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_v )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_dir_1_status ( hqm_dp_target_cfg_control_arb_weights_tqpri_dir_1_status )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt ( hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_f ( hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_f )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_v (  hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_v )
, .hqm_dp_target_cfg_control_arb_weights_tqpri_replay_1_status ( hqm_dp_target_cfg_control_arb_weights_tqpri_replay_1_status )
, .hqm_dp_target_cfg_control_general_reg_nxt ( hqm_dp_target_cfg_control_general_reg_nxt )
, .hqm_dp_target_cfg_control_general_reg_f ( hqm_dp_target_cfg_control_general_reg_f )
, .hqm_dp_target_cfg_control_general_reg_v (  hqm_dp_target_cfg_control_general_reg_v )
, .hqm_dp_target_cfg_control_pipeline_credits_reg_nxt ( hqm_dp_target_cfg_control_pipeline_credits_reg_nxt )
, .hqm_dp_target_cfg_control_pipeline_credits_reg_f ( hqm_dp_target_cfg_control_pipeline_credits_reg_f )
, .hqm_dp_target_cfg_control_pipeline_credits_reg_v (  hqm_dp_target_cfg_control_pipeline_credits_reg_v )
, .hqm_dp_target_cfg_detect_feature_operation_00_reg_nxt ( hqm_dp_target_cfg_detect_feature_operation_00_reg_nxt )
, .hqm_dp_target_cfg_detect_feature_operation_00_reg_f ( hqm_dp_target_cfg_detect_feature_operation_00_reg_f )
, .hqm_dp_target_cfg_detect_feature_operation_01_reg_nxt ( hqm_dp_target_cfg_detect_feature_operation_01_reg_nxt )
, .hqm_dp_target_cfg_detect_feature_operation_01_reg_f ( hqm_dp_target_cfg_detect_feature_operation_01_reg_f )
, .hqm_dp_target_cfg_diagnostic_aw_status_status ( hqm_dp_target_cfg_diagnostic_aw_status_status )
, .hqm_dp_target_cfg_diagnostic_aw_status_01_status ( hqm_dp_target_cfg_diagnostic_aw_status_01_status )
, .hqm_dp_target_cfg_diagnostic_aw_status_02_status ( hqm_dp_target_cfg_diagnostic_aw_status_02_status )
, .hqm_dp_target_cfg_dir_csr_control_reg_nxt ( hqm_dp_target_cfg_dir_csr_control_reg_nxt )
, .hqm_dp_target_cfg_dir_csr_control_reg_f ( hqm_dp_target_cfg_dir_csr_control_reg_f )
, .hqm_dp_target_cfg_dir_csr_control_reg_v (  hqm_dp_target_cfg_dir_csr_control_reg_v )
, .hqm_dp_target_cfg_error_inject_reg_nxt ( hqm_dp_target_cfg_error_inject_reg_nxt )
, .hqm_dp_target_cfg_error_inject_reg_f ( hqm_dp_target_cfg_error_inject_reg_f )
, .hqm_dp_target_cfg_error_inject_reg_v (  hqm_dp_target_cfg_error_inject_reg_v )
, .hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_nxt ( hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_nxt )
, .hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_f ( hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_f )
, .hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_nxt ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_nxt )
, .hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_f ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_f )
, .hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_nxt ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_nxt )
, .hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_f ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_f )
, .hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_nxt ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_nxt )
, .hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_f ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_f )
, .hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_nxt ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_nxt )
, .hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_f ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_f )
, .hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_nxt ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_nxt )
, .hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_f ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_f )
, .hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_nxt ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_nxt )
, .hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_f ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_f )
, .hqm_dp_target_cfg_hw_agitate_control_reg_nxt ( hqm_dp_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_dp_target_cfg_hw_agitate_control_reg_f ( hqm_dp_target_cfg_hw_agitate_control_reg_f )
, .hqm_dp_target_cfg_hw_agitate_control_reg_v (  hqm_dp_target_cfg_hw_agitate_control_reg_v )
, .hqm_dp_target_cfg_hw_agitate_select_reg_nxt ( hqm_dp_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_dp_target_cfg_hw_agitate_select_reg_f ( hqm_dp_target_cfg_hw_agitate_select_reg_f )
, .hqm_dp_target_cfg_hw_agitate_select_reg_v (  hqm_dp_target_cfg_hw_agitate_select_reg_v )
, .hqm_dp_target_cfg_interface_status_reg_nxt ( hqm_dp_target_cfg_interface_status_reg_nxt )
, .hqm_dp_target_cfg_interface_status_reg_f ( hqm_dp_target_cfg_interface_status_reg_f )
, .hqm_dp_target_cfg_patch_control_reg_nxt ( hqm_dp_target_cfg_patch_control_reg_nxt )
, .hqm_dp_target_cfg_patch_control_reg_f ( hqm_dp_target_cfg_patch_control_reg_f )
, .hqm_dp_target_cfg_patch_control_reg_v (  hqm_dp_target_cfg_patch_control_reg_v )
, .hqm_dp_target_cfg_pipe_health_hold_00_reg_nxt ( hqm_dp_target_cfg_pipe_health_hold_00_reg_nxt )
, .hqm_dp_target_cfg_pipe_health_hold_00_reg_f ( hqm_dp_target_cfg_pipe_health_hold_00_reg_f )
, .hqm_dp_target_cfg_pipe_health_valid_00_reg_nxt ( hqm_dp_target_cfg_pipe_health_valid_00_reg_nxt )
, .hqm_dp_target_cfg_pipe_health_valid_00_reg_f ( hqm_dp_target_cfg_pipe_health_valid_00_reg_f )
, .hqm_dp_target_cfg_smon_disable_smon ( hqm_dp_target_cfg_smon_disable_smon )
, .hqm_dp_target_cfg_smon_smon_v ( hqm_dp_target_cfg_smon_smon_v )
, .hqm_dp_target_cfg_smon_smon_comp ( hqm_dp_target_cfg_smon_smon_comp )
, .hqm_dp_target_cfg_smon_smon_val ( hqm_dp_target_cfg_smon_smon_val )
, .hqm_dp_target_cfg_smon_smon_enabled ( hqm_dp_target_cfg_smon_smon_enabled )
, .hqm_dp_target_cfg_smon_smon_interrupt ( hqm_dp_target_cfg_smon_smon_interrupt )
, .hqm_dp_target_cfg_syndrome_00_capture_v ( hqm_dp_target_cfg_syndrome_00_capture_v )
, .hqm_dp_target_cfg_syndrome_00_capture_data ( hqm_dp_target_cfg_syndrome_00_capture_data )
, .hqm_dp_target_cfg_syndrome_00_syndrome_data ( hqm_dp_target_cfg_syndrome_00_syndrome_data )
, .hqm_dp_target_cfg_syndrome_01_capture_v ( hqm_dp_target_cfg_syndrome_01_capture_v )
, .hqm_dp_target_cfg_syndrome_01_capture_data ( hqm_dp_target_cfg_syndrome_01_capture_data )
, .hqm_dp_target_cfg_syndrome_01_syndrome_data ( hqm_dp_target_cfg_syndrome_01_syndrome_data )
, .hqm_dp_target_cfg_unit_idle_reg_nxt ( hqm_dp_target_cfg_unit_idle_reg_nxt )
, .hqm_dp_target_cfg_unit_idle_reg_f ( hqm_dp_target_cfg_unit_idle_reg_f )
, .hqm_dp_target_cfg_unit_timeout_reg_nxt ( hqm_dp_target_cfg_unit_timeout_reg_nxt )
, .hqm_dp_target_cfg_unit_timeout_reg_f ( hqm_dp_target_cfg_unit_timeout_reg_f )
, .hqm_dp_target_cfg_unit_version_status ( hqm_dp_target_cfg_unit_version_status )
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


logic                  hqm_dir_pipe_rfw_top_ipar_error;

logic                  func_dir_cnt_re; //I
logic [(       7)-1:0] func_dir_cnt_raddr; //I
logic [(       7)-1:0] func_dir_cnt_waddr; //I
logic                  func_dir_cnt_we;    //I
logic [(      68)-1:0] func_dir_cnt_wdata; //I
logic [(      68)-1:0] func_dir_cnt_rdata;

logic                pf_dir_cnt_re;    //I
logic [(       7)-1:0] pf_dir_cnt_raddr; //I
logic [(       7)-1:0] pf_dir_cnt_waddr; //I
logic                  pf_dir_cnt_we;    //I
logic [(      68)-1:0] pf_dir_cnt_wdata; //I
logic [(      68)-1:0] pf_dir_cnt_rdata;

logic                  rf_dir_cnt_error;

logic                  func_dir_hp_re; //I
logic [(      10)-1:0] func_dir_hp_raddr; //I
logic [(      10)-1:0] func_dir_hp_waddr; //I
logic                  func_dir_hp_we;    //I
logic [(      15)-1:0] func_dir_hp_wdata; //I
logic [(      15)-1:0] func_dir_hp_rdata;

logic                pf_dir_hp_re;    //I
logic [(      10)-1:0] pf_dir_hp_raddr; //I
logic [(      10)-1:0] pf_dir_hp_waddr; //I
logic                  pf_dir_hp_we;    //I
logic [(      15)-1:0] pf_dir_hp_wdata; //I
logic [(      15)-1:0] pf_dir_hp_rdata;

logic                  rf_dir_hp_error;

logic                  func_dir_replay_cnt_re; //I
logic [(       7)-1:0] func_dir_replay_cnt_raddr; //I
logic [(       7)-1:0] func_dir_replay_cnt_waddr; //I
logic                  func_dir_replay_cnt_we;    //I
logic [(      68)-1:0] func_dir_replay_cnt_wdata; //I
logic [(      68)-1:0] func_dir_replay_cnt_rdata;

logic                pf_dir_replay_cnt_re;    //I
logic [(       7)-1:0] pf_dir_replay_cnt_raddr; //I
logic [(       7)-1:0] pf_dir_replay_cnt_waddr; //I
logic                  pf_dir_replay_cnt_we;    //I
logic [(      68)-1:0] pf_dir_replay_cnt_wdata; //I
logic [(      68)-1:0] pf_dir_replay_cnt_rdata;

logic                  rf_dir_replay_cnt_error;

logic                  func_dir_replay_hp_re; //I
logic [(      10)-1:0] func_dir_replay_hp_raddr; //I
logic [(      10)-1:0] func_dir_replay_hp_waddr; //I
logic                  func_dir_replay_hp_we;    //I
logic [(      15)-1:0] func_dir_replay_hp_wdata; //I
logic [(      15)-1:0] func_dir_replay_hp_rdata;

logic                pf_dir_replay_hp_re;    //I
logic [(      10)-1:0] pf_dir_replay_hp_raddr; //I
logic [(      10)-1:0] pf_dir_replay_hp_waddr; //I
logic                  pf_dir_replay_hp_we;    //I
logic [(      15)-1:0] pf_dir_replay_hp_wdata; //I
logic [(      15)-1:0] pf_dir_replay_hp_rdata;

logic                  rf_dir_replay_hp_error;

logic                  func_dir_replay_tp_re; //I
logic [(      10)-1:0] func_dir_replay_tp_raddr; //I
logic [(      10)-1:0] func_dir_replay_tp_waddr; //I
logic                  func_dir_replay_tp_we;    //I
logic [(      15)-1:0] func_dir_replay_tp_wdata; //I
logic [(      15)-1:0] func_dir_replay_tp_rdata;

logic                pf_dir_replay_tp_re;    //I
logic [(      10)-1:0] pf_dir_replay_tp_raddr; //I
logic [(      10)-1:0] pf_dir_replay_tp_waddr; //I
logic                  pf_dir_replay_tp_we;    //I
logic [(      15)-1:0] pf_dir_replay_tp_wdata; //I
logic [(      15)-1:0] pf_dir_replay_tp_rdata;

logic                  rf_dir_replay_tp_error;

logic                  func_dir_rofrag_cnt_re; //I
logic [(       9)-1:0] func_dir_rofrag_cnt_raddr; //I
logic [(       9)-1:0] func_dir_rofrag_cnt_waddr; //I
logic                  func_dir_rofrag_cnt_we;    //I
logic [(      17)-1:0] func_dir_rofrag_cnt_wdata; //I
logic [(      17)-1:0] func_dir_rofrag_cnt_rdata;

logic                pf_dir_rofrag_cnt_re;    //I
logic [(       9)-1:0] pf_dir_rofrag_cnt_raddr; //I
logic [(       9)-1:0] pf_dir_rofrag_cnt_waddr; //I
logic                  pf_dir_rofrag_cnt_we;    //I
logic [(      17)-1:0] pf_dir_rofrag_cnt_wdata; //I
logic [(      17)-1:0] pf_dir_rofrag_cnt_rdata;

logic                  rf_dir_rofrag_cnt_error;

logic                  func_dir_rofrag_hp_re; //I
logic [(       9)-1:0] func_dir_rofrag_hp_raddr; //I
logic [(       9)-1:0] func_dir_rofrag_hp_waddr; //I
logic                  func_dir_rofrag_hp_we;    //I
logic [(      15)-1:0] func_dir_rofrag_hp_wdata; //I
logic [(      15)-1:0] func_dir_rofrag_hp_rdata;

logic                pf_dir_rofrag_hp_re;    //I
logic [(       9)-1:0] pf_dir_rofrag_hp_raddr; //I
logic [(       9)-1:0] pf_dir_rofrag_hp_waddr; //I
logic                  pf_dir_rofrag_hp_we;    //I
logic [(      15)-1:0] pf_dir_rofrag_hp_wdata; //I
logic [(      15)-1:0] pf_dir_rofrag_hp_rdata;

logic                  rf_dir_rofrag_hp_error;

logic                  func_dir_rofrag_tp_re; //I
logic [(       9)-1:0] func_dir_rofrag_tp_raddr; //I
logic [(       9)-1:0] func_dir_rofrag_tp_waddr; //I
logic                  func_dir_rofrag_tp_we;    //I
logic [(      15)-1:0] func_dir_rofrag_tp_wdata; //I
logic [(      15)-1:0] func_dir_rofrag_tp_rdata;

logic                pf_dir_rofrag_tp_re;    //I
logic [(       9)-1:0] pf_dir_rofrag_tp_raddr; //I
logic [(       9)-1:0] pf_dir_rofrag_tp_waddr; //I
logic                  pf_dir_rofrag_tp_we;    //I
logic [(      15)-1:0] pf_dir_rofrag_tp_wdata; //I
logic [(      15)-1:0] pf_dir_rofrag_tp_rdata;

logic                  rf_dir_rofrag_tp_error;

logic                  func_dir_tp_re; //I
logic [(      10)-1:0] func_dir_tp_raddr; //I
logic [(      10)-1:0] func_dir_tp_waddr; //I
logic                  func_dir_tp_we;    //I
logic [(      15)-1:0] func_dir_tp_wdata; //I
logic [(      15)-1:0] func_dir_tp_rdata;

logic                pf_dir_tp_re;    //I
logic [(      10)-1:0] pf_dir_tp_raddr; //I
logic [(      10)-1:0] pf_dir_tp_waddr; //I
logic                  pf_dir_tp_we;    //I
logic [(      15)-1:0] pf_dir_tp_wdata; //I
logic [(      15)-1:0] pf_dir_tp_rdata;

logic                  rf_dir_tp_error;

logic                  func_dp_dqed_re; //I
logic [(       5)-1:0] func_dp_dqed_raddr; //I
logic [(       5)-1:0] func_dp_dqed_waddr; //I
logic                  func_dp_dqed_we;    //I
logic [(      45)-1:0] func_dp_dqed_wdata; //I
logic [(      45)-1:0] func_dp_dqed_rdata;

logic                pf_dp_dqed_re;    //I
logic [(       5)-1:0] pf_dp_dqed_raddr; //I
logic [(       5)-1:0] pf_dp_dqed_waddr; //I
logic                  pf_dp_dqed_we;    //I
logic [(      45)-1:0] pf_dp_dqed_wdata; //I
logic [(      45)-1:0] pf_dp_dqed_rdata;

logic                  rf_dp_dqed_error;

logic                  func_dp_lsp_enq_dir_re; //I
logic [(       4)-1:0] func_dp_lsp_enq_dir_raddr; //I
logic [(       4)-1:0] func_dp_lsp_enq_dir_waddr; //I
logic                  func_dp_lsp_enq_dir_we;    //I
logic [(       8)-1:0] func_dp_lsp_enq_dir_wdata; //I
logic [(       8)-1:0] func_dp_lsp_enq_dir_rdata;

logic                pf_dp_lsp_enq_dir_re;    //I
logic [(       4)-1:0] pf_dp_lsp_enq_dir_raddr; //I
logic [(       4)-1:0] pf_dp_lsp_enq_dir_waddr; //I
logic                  pf_dp_lsp_enq_dir_we;    //I
logic [(       8)-1:0] pf_dp_lsp_enq_dir_wdata; //I
logic [(       8)-1:0] pf_dp_lsp_enq_dir_rdata;

logic                  rf_dp_lsp_enq_dir_error;

logic                  func_dp_lsp_enq_rorply_re; //I
logic [(       4)-1:0] func_dp_lsp_enq_rorply_raddr; //I
logic [(       4)-1:0] func_dp_lsp_enq_rorply_waddr; //I
logic                  func_dp_lsp_enq_rorply_we;    //I
logic [(      23)-1:0] func_dp_lsp_enq_rorply_wdata; //I
logic [(      23)-1:0] func_dp_lsp_enq_rorply_rdata;

logic                pf_dp_lsp_enq_rorply_re;    //I
logic [(       4)-1:0] pf_dp_lsp_enq_rorply_raddr; //I
logic [(       4)-1:0] pf_dp_lsp_enq_rorply_waddr; //I
logic                  pf_dp_lsp_enq_rorply_we;    //I
logic [(      23)-1:0] pf_dp_lsp_enq_rorply_wdata; //I
logic [(      23)-1:0] pf_dp_lsp_enq_rorply_rdata;

logic                  rf_dp_lsp_enq_rorply_error;

logic                  func_lsp_dp_sch_dir_re; //I
logic [(       2)-1:0] func_lsp_dp_sch_dir_raddr; //I
logic [(       2)-1:0] func_lsp_dp_sch_dir_waddr; //I
logic                  func_lsp_dp_sch_dir_we;    //I
logic [(      27)-1:0] func_lsp_dp_sch_dir_wdata; //I
logic [(      27)-1:0] func_lsp_dp_sch_dir_rdata;

logic                pf_lsp_dp_sch_dir_re;    //I
logic [(       2)-1:0] pf_lsp_dp_sch_dir_raddr; //I
logic [(       2)-1:0] pf_lsp_dp_sch_dir_waddr; //I
logic                  pf_lsp_dp_sch_dir_we;    //I
logic [(      27)-1:0] pf_lsp_dp_sch_dir_wdata; //I
logic [(      27)-1:0] pf_lsp_dp_sch_dir_rdata;

logic                  rf_lsp_dp_sch_dir_error;

logic                  func_lsp_dp_sch_rorply_re; //I
logic [(       2)-1:0] func_lsp_dp_sch_rorply_raddr; //I
logic [(       2)-1:0] func_lsp_dp_sch_rorply_waddr; //I
logic                  func_lsp_dp_sch_rorply_we;    //I
logic [(       8)-1:0] func_lsp_dp_sch_rorply_wdata; //I
logic [(       8)-1:0] func_lsp_dp_sch_rorply_rdata;

logic                pf_lsp_dp_sch_rorply_re;    //I
logic [(       2)-1:0] pf_lsp_dp_sch_rorply_raddr; //I
logic [(       2)-1:0] pf_lsp_dp_sch_rorply_waddr; //I
logic                  pf_lsp_dp_sch_rorply_we;    //I
logic [(       8)-1:0] pf_lsp_dp_sch_rorply_wdata; //I
logic [(       8)-1:0] pf_lsp_dp_sch_rorply_rdata;

logic                  rf_lsp_dp_sch_rorply_error;

logic                  func_rop_dp_enq_dir_re; //I
logic [(       2)-1:0] func_rop_dp_enq_dir_raddr; //I
logic [(       2)-1:0] func_rop_dp_enq_dir_waddr; //I
logic                  func_rop_dp_enq_dir_we;    //I
logic [(     100)-1:0] func_rop_dp_enq_dir_wdata; //I
logic [(     100)-1:0] func_rop_dp_enq_dir_rdata;

logic                pf_rop_dp_enq_dir_re;    //I
logic [(       2)-1:0] pf_rop_dp_enq_dir_raddr; //I
logic [(       2)-1:0] pf_rop_dp_enq_dir_waddr; //I
logic                  pf_rop_dp_enq_dir_we;    //I
logic [(     100)-1:0] pf_rop_dp_enq_dir_wdata; //I
logic [(     100)-1:0] pf_rop_dp_enq_dir_rdata;

logic                  rf_rop_dp_enq_dir_error;

logic                  func_rop_dp_enq_ro_re; //I
logic [(       2)-1:0] func_rop_dp_enq_ro_raddr; //I
logic [(       2)-1:0] func_rop_dp_enq_ro_waddr; //I
logic                  func_rop_dp_enq_ro_we;    //I
logic [(     100)-1:0] func_rop_dp_enq_ro_wdata; //I
logic [(     100)-1:0] func_rop_dp_enq_ro_rdata;

logic                pf_rop_dp_enq_ro_re;    //I
logic [(       2)-1:0] pf_rop_dp_enq_ro_raddr; //I
logic [(       2)-1:0] pf_rop_dp_enq_ro_waddr; //I
logic                  pf_rop_dp_enq_ro_we;    //I
logic [(     100)-1:0] pf_rop_dp_enq_ro_wdata; //I
logic [(     100)-1:0] pf_rop_dp_enq_ro_rdata;

logic                  rf_rop_dp_enq_ro_error;

logic                  func_rx_sync_lsp_dp_sch_dir_re; //I
logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_dir_raddr; //I
logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_dir_waddr; //I
logic                  func_rx_sync_lsp_dp_sch_dir_we;    //I
logic [(      27)-1:0] func_rx_sync_lsp_dp_sch_dir_wdata; //I
logic [(      27)-1:0] func_rx_sync_lsp_dp_sch_dir_rdata;

logic                pf_rx_sync_lsp_dp_sch_dir_re;    //I
logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_dir_raddr; //I
logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_dir_waddr; //I
logic                  pf_rx_sync_lsp_dp_sch_dir_we;    //I
logic [(      27)-1:0] pf_rx_sync_lsp_dp_sch_dir_wdata; //I
logic [(      27)-1:0] pf_rx_sync_lsp_dp_sch_dir_rdata;

logic                  rf_rx_sync_lsp_dp_sch_dir_error;

logic                  func_rx_sync_lsp_dp_sch_rorply_re; //I
logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_rorply_raddr; //I
logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_rorply_waddr; //I
logic                  func_rx_sync_lsp_dp_sch_rorply_we;    //I
logic [(       8)-1:0] func_rx_sync_lsp_dp_sch_rorply_wdata; //I
logic [(       8)-1:0] func_rx_sync_lsp_dp_sch_rorply_rdata;

logic                pf_rx_sync_lsp_dp_sch_rorply_re;    //I
logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_rorply_raddr; //I
logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_rorply_waddr; //I
logic                  pf_rx_sync_lsp_dp_sch_rorply_we;    //I
logic [(       8)-1:0] pf_rx_sync_lsp_dp_sch_rorply_wdata; //I
logic [(       8)-1:0] pf_rx_sync_lsp_dp_sch_rorply_rdata;

logic                  rf_rx_sync_lsp_dp_sch_rorply_error;

logic                  func_rx_sync_rop_dp_enq_re; //I
logic [(       2)-1:0] func_rx_sync_rop_dp_enq_raddr; //I
logic [(       2)-1:0] func_rx_sync_rop_dp_enq_waddr; //I
logic                  func_rx_sync_rop_dp_enq_we;    //I
logic [(     100)-1:0] func_rx_sync_rop_dp_enq_wdata; //I
logic [(     100)-1:0] func_rx_sync_rop_dp_enq_rdata;

logic                pf_rx_sync_rop_dp_enq_re;    //I
logic [(       2)-1:0] pf_rx_sync_rop_dp_enq_raddr; //I
logic [(       2)-1:0] pf_rx_sync_rop_dp_enq_waddr; //I
logic                  pf_rx_sync_rop_dp_enq_we;    //I
logic [(     100)-1:0] pf_rx_sync_rop_dp_enq_wdata; //I
logic [(     100)-1:0] pf_rx_sync_rop_dp_enq_rdata;

logic                  rf_rx_sync_rop_dp_enq_error;

logic                  func_dir_nxthp_re;    //I
logic [(      14)-1:0] func_dir_nxthp_addr;  //I
logic                  func_dir_nxthp_we;    //I
logic [(      21)-1:0] func_dir_nxthp_wdata; //I
logic [(      21)-1:0] func_dir_nxthp_rdata;

logic                  pf_dir_nxthp_re;   //I
logic [(      14)-1:0] pf_dir_nxthp_addr; //I
logic                  pf_dir_nxthp_we;   //I
logic [(      21)-1:0] pf_dir_nxthp_wdata; //I
logic [(      21)-1:0] pf_dir_nxthp_rdata;

logic                  sr_dir_nxthp_error;

hqm_dir_pipe_ram_access i_hqm_dir_pipe_ram_access (
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

,.hqm_dir_pipe_rfw_top_ipar_error (hqm_dir_pipe_rfw_top_ipar_error)

,.func_dir_cnt_re    (func_dir_cnt_re)
,.func_dir_cnt_raddr (func_dir_cnt_raddr)
,.func_dir_cnt_waddr (func_dir_cnt_waddr)
,.func_dir_cnt_we    (func_dir_cnt_we)
,.func_dir_cnt_wdata (func_dir_cnt_wdata)
,.func_dir_cnt_rdata (func_dir_cnt_rdata)

,.pf_dir_cnt_re      (pf_dir_cnt_re)
,.pf_dir_cnt_raddr (pf_dir_cnt_raddr)
,.pf_dir_cnt_waddr (pf_dir_cnt_waddr)
,.pf_dir_cnt_we    (pf_dir_cnt_we)
,.pf_dir_cnt_wdata (pf_dir_cnt_wdata)
,.pf_dir_cnt_rdata (pf_dir_cnt_rdata)

,.rf_dir_cnt_rclk (rf_dir_cnt_rclk)
,.rf_dir_cnt_rclk_rst_n (rf_dir_cnt_rclk_rst_n)
,.rf_dir_cnt_re    (rf_dir_cnt_re)
,.rf_dir_cnt_raddr (rf_dir_cnt_raddr)
,.rf_dir_cnt_waddr (rf_dir_cnt_waddr)
,.rf_dir_cnt_wclk (rf_dir_cnt_wclk)
,.rf_dir_cnt_wclk_rst_n (rf_dir_cnt_wclk_rst_n)
,.rf_dir_cnt_we    (rf_dir_cnt_we)
,.rf_dir_cnt_wdata (rf_dir_cnt_wdata)
,.rf_dir_cnt_rdata (rf_dir_cnt_rdata)

,.rf_dir_cnt_error (rf_dir_cnt_error)

,.func_dir_hp_re    (func_dir_hp_re)
,.func_dir_hp_raddr (func_dir_hp_raddr)
,.func_dir_hp_waddr (func_dir_hp_waddr)
,.func_dir_hp_we    (func_dir_hp_we)
,.func_dir_hp_wdata (func_dir_hp_wdata)
,.func_dir_hp_rdata (func_dir_hp_rdata)

,.pf_dir_hp_re      (pf_dir_hp_re)
,.pf_dir_hp_raddr (pf_dir_hp_raddr)
,.pf_dir_hp_waddr (pf_dir_hp_waddr)
,.pf_dir_hp_we    (pf_dir_hp_we)
,.pf_dir_hp_wdata (pf_dir_hp_wdata)
,.pf_dir_hp_rdata (pf_dir_hp_rdata)

,.rf_dir_hp_rclk (rf_dir_hp_rclk)
,.rf_dir_hp_rclk_rst_n (rf_dir_hp_rclk_rst_n)
,.rf_dir_hp_re    (rf_dir_hp_re)
,.rf_dir_hp_raddr (rf_dir_hp_raddr)
,.rf_dir_hp_waddr (rf_dir_hp_waddr)
,.rf_dir_hp_wclk (rf_dir_hp_wclk)
,.rf_dir_hp_wclk_rst_n (rf_dir_hp_wclk_rst_n)
,.rf_dir_hp_we    (rf_dir_hp_we)
,.rf_dir_hp_wdata (rf_dir_hp_wdata)
,.rf_dir_hp_rdata (rf_dir_hp_rdata)

,.rf_dir_hp_error (rf_dir_hp_error)

,.func_dir_replay_cnt_re    (func_dir_replay_cnt_re)
,.func_dir_replay_cnt_raddr (func_dir_replay_cnt_raddr)
,.func_dir_replay_cnt_waddr (func_dir_replay_cnt_waddr)
,.func_dir_replay_cnt_we    (func_dir_replay_cnt_we)
,.func_dir_replay_cnt_wdata (func_dir_replay_cnt_wdata)
,.func_dir_replay_cnt_rdata (func_dir_replay_cnt_rdata)

,.pf_dir_replay_cnt_re      (pf_dir_replay_cnt_re)
,.pf_dir_replay_cnt_raddr (pf_dir_replay_cnt_raddr)
,.pf_dir_replay_cnt_waddr (pf_dir_replay_cnt_waddr)
,.pf_dir_replay_cnt_we    (pf_dir_replay_cnt_we)
,.pf_dir_replay_cnt_wdata (pf_dir_replay_cnt_wdata)
,.pf_dir_replay_cnt_rdata (pf_dir_replay_cnt_rdata)

,.rf_dir_replay_cnt_rclk (rf_dir_replay_cnt_rclk)
,.rf_dir_replay_cnt_rclk_rst_n (rf_dir_replay_cnt_rclk_rst_n)
,.rf_dir_replay_cnt_re    (rf_dir_replay_cnt_re)
,.rf_dir_replay_cnt_raddr (rf_dir_replay_cnt_raddr)
,.rf_dir_replay_cnt_waddr (rf_dir_replay_cnt_waddr)
,.rf_dir_replay_cnt_wclk (rf_dir_replay_cnt_wclk)
,.rf_dir_replay_cnt_wclk_rst_n (rf_dir_replay_cnt_wclk_rst_n)
,.rf_dir_replay_cnt_we    (rf_dir_replay_cnt_we)
,.rf_dir_replay_cnt_wdata (rf_dir_replay_cnt_wdata)
,.rf_dir_replay_cnt_rdata (rf_dir_replay_cnt_rdata)

,.rf_dir_replay_cnt_error (rf_dir_replay_cnt_error)

,.func_dir_replay_hp_re    (func_dir_replay_hp_re)
,.func_dir_replay_hp_raddr (func_dir_replay_hp_raddr)
,.func_dir_replay_hp_waddr (func_dir_replay_hp_waddr)
,.func_dir_replay_hp_we    (func_dir_replay_hp_we)
,.func_dir_replay_hp_wdata (func_dir_replay_hp_wdata)
,.func_dir_replay_hp_rdata (func_dir_replay_hp_rdata)

,.pf_dir_replay_hp_re      (pf_dir_replay_hp_re)
,.pf_dir_replay_hp_raddr (pf_dir_replay_hp_raddr)
,.pf_dir_replay_hp_waddr (pf_dir_replay_hp_waddr)
,.pf_dir_replay_hp_we    (pf_dir_replay_hp_we)
,.pf_dir_replay_hp_wdata (pf_dir_replay_hp_wdata)
,.pf_dir_replay_hp_rdata (pf_dir_replay_hp_rdata)

,.rf_dir_replay_hp_rclk (rf_dir_replay_hp_rclk)
,.rf_dir_replay_hp_rclk_rst_n (rf_dir_replay_hp_rclk_rst_n)
,.rf_dir_replay_hp_re    (rf_dir_replay_hp_re)
,.rf_dir_replay_hp_raddr (rf_dir_replay_hp_raddr)
,.rf_dir_replay_hp_waddr (rf_dir_replay_hp_waddr)
,.rf_dir_replay_hp_wclk (rf_dir_replay_hp_wclk)
,.rf_dir_replay_hp_wclk_rst_n (rf_dir_replay_hp_wclk_rst_n)
,.rf_dir_replay_hp_we    (rf_dir_replay_hp_we)
,.rf_dir_replay_hp_wdata (rf_dir_replay_hp_wdata)
,.rf_dir_replay_hp_rdata (rf_dir_replay_hp_rdata)

,.rf_dir_replay_hp_error (rf_dir_replay_hp_error)

,.func_dir_replay_tp_re    (func_dir_replay_tp_re)
,.func_dir_replay_tp_raddr (func_dir_replay_tp_raddr)
,.func_dir_replay_tp_waddr (func_dir_replay_tp_waddr)
,.func_dir_replay_tp_we    (func_dir_replay_tp_we)
,.func_dir_replay_tp_wdata (func_dir_replay_tp_wdata)
,.func_dir_replay_tp_rdata (func_dir_replay_tp_rdata)

,.pf_dir_replay_tp_re      (pf_dir_replay_tp_re)
,.pf_dir_replay_tp_raddr (pf_dir_replay_tp_raddr)
,.pf_dir_replay_tp_waddr (pf_dir_replay_tp_waddr)
,.pf_dir_replay_tp_we    (pf_dir_replay_tp_we)
,.pf_dir_replay_tp_wdata (pf_dir_replay_tp_wdata)
,.pf_dir_replay_tp_rdata (pf_dir_replay_tp_rdata)

,.rf_dir_replay_tp_rclk (rf_dir_replay_tp_rclk)
,.rf_dir_replay_tp_rclk_rst_n (rf_dir_replay_tp_rclk_rst_n)
,.rf_dir_replay_tp_re    (rf_dir_replay_tp_re)
,.rf_dir_replay_tp_raddr (rf_dir_replay_tp_raddr)
,.rf_dir_replay_tp_waddr (rf_dir_replay_tp_waddr)
,.rf_dir_replay_tp_wclk (rf_dir_replay_tp_wclk)
,.rf_dir_replay_tp_wclk_rst_n (rf_dir_replay_tp_wclk_rst_n)
,.rf_dir_replay_tp_we    (rf_dir_replay_tp_we)
,.rf_dir_replay_tp_wdata (rf_dir_replay_tp_wdata)
,.rf_dir_replay_tp_rdata (rf_dir_replay_tp_rdata)

,.rf_dir_replay_tp_error (rf_dir_replay_tp_error)

,.func_dir_rofrag_cnt_re    (func_dir_rofrag_cnt_re)
,.func_dir_rofrag_cnt_raddr (func_dir_rofrag_cnt_raddr)
,.func_dir_rofrag_cnt_waddr (func_dir_rofrag_cnt_waddr)
,.func_dir_rofrag_cnt_we    (func_dir_rofrag_cnt_we)
,.func_dir_rofrag_cnt_wdata (func_dir_rofrag_cnt_wdata)
,.func_dir_rofrag_cnt_rdata (func_dir_rofrag_cnt_rdata)

,.pf_dir_rofrag_cnt_re      (pf_dir_rofrag_cnt_re)
,.pf_dir_rofrag_cnt_raddr (pf_dir_rofrag_cnt_raddr)
,.pf_dir_rofrag_cnt_waddr (pf_dir_rofrag_cnt_waddr)
,.pf_dir_rofrag_cnt_we    (pf_dir_rofrag_cnt_we)
,.pf_dir_rofrag_cnt_wdata (pf_dir_rofrag_cnt_wdata)
,.pf_dir_rofrag_cnt_rdata (pf_dir_rofrag_cnt_rdata)

,.rf_dir_rofrag_cnt_rclk (rf_dir_rofrag_cnt_rclk)
,.rf_dir_rofrag_cnt_rclk_rst_n (rf_dir_rofrag_cnt_rclk_rst_n)
,.rf_dir_rofrag_cnt_re    (rf_dir_rofrag_cnt_re)
,.rf_dir_rofrag_cnt_raddr (rf_dir_rofrag_cnt_raddr)
,.rf_dir_rofrag_cnt_waddr (rf_dir_rofrag_cnt_waddr)
,.rf_dir_rofrag_cnt_wclk (rf_dir_rofrag_cnt_wclk)
,.rf_dir_rofrag_cnt_wclk_rst_n (rf_dir_rofrag_cnt_wclk_rst_n)
,.rf_dir_rofrag_cnt_we    (rf_dir_rofrag_cnt_we)
,.rf_dir_rofrag_cnt_wdata (rf_dir_rofrag_cnt_wdata)
,.rf_dir_rofrag_cnt_rdata (rf_dir_rofrag_cnt_rdata)

,.rf_dir_rofrag_cnt_error (rf_dir_rofrag_cnt_error)

,.func_dir_rofrag_hp_re    (func_dir_rofrag_hp_re)
,.func_dir_rofrag_hp_raddr (func_dir_rofrag_hp_raddr)
,.func_dir_rofrag_hp_waddr (func_dir_rofrag_hp_waddr)
,.func_dir_rofrag_hp_we    (func_dir_rofrag_hp_we)
,.func_dir_rofrag_hp_wdata (func_dir_rofrag_hp_wdata)
,.func_dir_rofrag_hp_rdata (func_dir_rofrag_hp_rdata)

,.pf_dir_rofrag_hp_re      (pf_dir_rofrag_hp_re)
,.pf_dir_rofrag_hp_raddr (pf_dir_rofrag_hp_raddr)
,.pf_dir_rofrag_hp_waddr (pf_dir_rofrag_hp_waddr)
,.pf_dir_rofrag_hp_we    (pf_dir_rofrag_hp_we)
,.pf_dir_rofrag_hp_wdata (pf_dir_rofrag_hp_wdata)
,.pf_dir_rofrag_hp_rdata (pf_dir_rofrag_hp_rdata)

,.rf_dir_rofrag_hp_rclk (rf_dir_rofrag_hp_rclk)
,.rf_dir_rofrag_hp_rclk_rst_n (rf_dir_rofrag_hp_rclk_rst_n)
,.rf_dir_rofrag_hp_re    (rf_dir_rofrag_hp_re)
,.rf_dir_rofrag_hp_raddr (rf_dir_rofrag_hp_raddr)
,.rf_dir_rofrag_hp_waddr (rf_dir_rofrag_hp_waddr)
,.rf_dir_rofrag_hp_wclk (rf_dir_rofrag_hp_wclk)
,.rf_dir_rofrag_hp_wclk_rst_n (rf_dir_rofrag_hp_wclk_rst_n)
,.rf_dir_rofrag_hp_we    (rf_dir_rofrag_hp_we)
,.rf_dir_rofrag_hp_wdata (rf_dir_rofrag_hp_wdata)
,.rf_dir_rofrag_hp_rdata (rf_dir_rofrag_hp_rdata)

,.rf_dir_rofrag_hp_error (rf_dir_rofrag_hp_error)

,.func_dir_rofrag_tp_re    (func_dir_rofrag_tp_re)
,.func_dir_rofrag_tp_raddr (func_dir_rofrag_tp_raddr)
,.func_dir_rofrag_tp_waddr (func_dir_rofrag_tp_waddr)
,.func_dir_rofrag_tp_we    (func_dir_rofrag_tp_we)
,.func_dir_rofrag_tp_wdata (func_dir_rofrag_tp_wdata)
,.func_dir_rofrag_tp_rdata (func_dir_rofrag_tp_rdata)

,.pf_dir_rofrag_tp_re      (pf_dir_rofrag_tp_re)
,.pf_dir_rofrag_tp_raddr (pf_dir_rofrag_tp_raddr)
,.pf_dir_rofrag_tp_waddr (pf_dir_rofrag_tp_waddr)
,.pf_dir_rofrag_tp_we    (pf_dir_rofrag_tp_we)
,.pf_dir_rofrag_tp_wdata (pf_dir_rofrag_tp_wdata)
,.pf_dir_rofrag_tp_rdata (pf_dir_rofrag_tp_rdata)

,.rf_dir_rofrag_tp_rclk (rf_dir_rofrag_tp_rclk)
,.rf_dir_rofrag_tp_rclk_rst_n (rf_dir_rofrag_tp_rclk_rst_n)
,.rf_dir_rofrag_tp_re    (rf_dir_rofrag_tp_re)
,.rf_dir_rofrag_tp_raddr (rf_dir_rofrag_tp_raddr)
,.rf_dir_rofrag_tp_waddr (rf_dir_rofrag_tp_waddr)
,.rf_dir_rofrag_tp_wclk (rf_dir_rofrag_tp_wclk)
,.rf_dir_rofrag_tp_wclk_rst_n (rf_dir_rofrag_tp_wclk_rst_n)
,.rf_dir_rofrag_tp_we    (rf_dir_rofrag_tp_we)
,.rf_dir_rofrag_tp_wdata (rf_dir_rofrag_tp_wdata)
,.rf_dir_rofrag_tp_rdata (rf_dir_rofrag_tp_rdata)

,.rf_dir_rofrag_tp_error (rf_dir_rofrag_tp_error)

,.func_dir_tp_re    (func_dir_tp_re)
,.func_dir_tp_raddr (func_dir_tp_raddr)
,.func_dir_tp_waddr (func_dir_tp_waddr)
,.func_dir_tp_we    (func_dir_tp_we)
,.func_dir_tp_wdata (func_dir_tp_wdata)
,.func_dir_tp_rdata (func_dir_tp_rdata)

,.pf_dir_tp_re      (pf_dir_tp_re)
,.pf_dir_tp_raddr (pf_dir_tp_raddr)
,.pf_dir_tp_waddr (pf_dir_tp_waddr)
,.pf_dir_tp_we    (pf_dir_tp_we)
,.pf_dir_tp_wdata (pf_dir_tp_wdata)
,.pf_dir_tp_rdata (pf_dir_tp_rdata)

,.rf_dir_tp_rclk (rf_dir_tp_rclk)
,.rf_dir_tp_rclk_rst_n (rf_dir_tp_rclk_rst_n)
,.rf_dir_tp_re    (rf_dir_tp_re)
,.rf_dir_tp_raddr (rf_dir_tp_raddr)
,.rf_dir_tp_waddr (rf_dir_tp_waddr)
,.rf_dir_tp_wclk (rf_dir_tp_wclk)
,.rf_dir_tp_wclk_rst_n (rf_dir_tp_wclk_rst_n)
,.rf_dir_tp_we    (rf_dir_tp_we)
,.rf_dir_tp_wdata (rf_dir_tp_wdata)
,.rf_dir_tp_rdata (rf_dir_tp_rdata)

,.rf_dir_tp_error (rf_dir_tp_error)

,.func_dp_dqed_re    (func_dp_dqed_re)
,.func_dp_dqed_raddr (func_dp_dqed_raddr)
,.func_dp_dqed_waddr (func_dp_dqed_waddr)
,.func_dp_dqed_we    (func_dp_dqed_we)
,.func_dp_dqed_wdata (func_dp_dqed_wdata)
,.func_dp_dqed_rdata (func_dp_dqed_rdata)

,.pf_dp_dqed_re      (pf_dp_dqed_re)
,.pf_dp_dqed_raddr (pf_dp_dqed_raddr)
,.pf_dp_dqed_waddr (pf_dp_dqed_waddr)
,.pf_dp_dqed_we    (pf_dp_dqed_we)
,.pf_dp_dqed_wdata (pf_dp_dqed_wdata)
,.pf_dp_dqed_rdata (pf_dp_dqed_rdata)

,.rf_dp_dqed_rclk (rf_dp_dqed_rclk)
,.rf_dp_dqed_rclk_rst_n (rf_dp_dqed_rclk_rst_n)
,.rf_dp_dqed_re    (rf_dp_dqed_re)
,.rf_dp_dqed_raddr (rf_dp_dqed_raddr)
,.rf_dp_dqed_waddr (rf_dp_dqed_waddr)
,.rf_dp_dqed_wclk (rf_dp_dqed_wclk)
,.rf_dp_dqed_wclk_rst_n (rf_dp_dqed_wclk_rst_n)
,.rf_dp_dqed_we    (rf_dp_dqed_we)
,.rf_dp_dqed_wdata (rf_dp_dqed_wdata)
,.rf_dp_dqed_rdata (rf_dp_dqed_rdata)

,.rf_dp_dqed_error (rf_dp_dqed_error)

,.func_dp_lsp_enq_dir_re    (func_dp_lsp_enq_dir_re)
,.func_dp_lsp_enq_dir_raddr (func_dp_lsp_enq_dir_raddr)
,.func_dp_lsp_enq_dir_waddr (func_dp_lsp_enq_dir_waddr)
,.func_dp_lsp_enq_dir_we    (func_dp_lsp_enq_dir_we)
,.func_dp_lsp_enq_dir_wdata (func_dp_lsp_enq_dir_wdata)
,.func_dp_lsp_enq_dir_rdata (func_dp_lsp_enq_dir_rdata)

,.pf_dp_lsp_enq_dir_re      (pf_dp_lsp_enq_dir_re)
,.pf_dp_lsp_enq_dir_raddr (pf_dp_lsp_enq_dir_raddr)
,.pf_dp_lsp_enq_dir_waddr (pf_dp_lsp_enq_dir_waddr)
,.pf_dp_lsp_enq_dir_we    (pf_dp_lsp_enq_dir_we)
,.pf_dp_lsp_enq_dir_wdata (pf_dp_lsp_enq_dir_wdata)
,.pf_dp_lsp_enq_dir_rdata (pf_dp_lsp_enq_dir_rdata)

,.rf_dp_lsp_enq_dir_rclk (rf_dp_lsp_enq_dir_rclk)
,.rf_dp_lsp_enq_dir_rclk_rst_n (rf_dp_lsp_enq_dir_rclk_rst_n)
,.rf_dp_lsp_enq_dir_re    (rf_dp_lsp_enq_dir_re)
,.rf_dp_lsp_enq_dir_raddr (rf_dp_lsp_enq_dir_raddr)
,.rf_dp_lsp_enq_dir_waddr (rf_dp_lsp_enq_dir_waddr)
,.rf_dp_lsp_enq_dir_wclk (rf_dp_lsp_enq_dir_wclk)
,.rf_dp_lsp_enq_dir_wclk_rst_n (rf_dp_lsp_enq_dir_wclk_rst_n)
,.rf_dp_lsp_enq_dir_we    (rf_dp_lsp_enq_dir_we)
,.rf_dp_lsp_enq_dir_wdata (rf_dp_lsp_enq_dir_wdata)
,.rf_dp_lsp_enq_dir_rdata (rf_dp_lsp_enq_dir_rdata)

,.rf_dp_lsp_enq_dir_error (rf_dp_lsp_enq_dir_error)

,.func_dp_lsp_enq_rorply_re    (func_dp_lsp_enq_rorply_re)
,.func_dp_lsp_enq_rorply_raddr (func_dp_lsp_enq_rorply_raddr)
,.func_dp_lsp_enq_rorply_waddr (func_dp_lsp_enq_rorply_waddr)
,.func_dp_lsp_enq_rorply_we    (func_dp_lsp_enq_rorply_we)
,.func_dp_lsp_enq_rorply_wdata (func_dp_lsp_enq_rorply_wdata)
,.func_dp_lsp_enq_rorply_rdata (func_dp_lsp_enq_rorply_rdata)

,.pf_dp_lsp_enq_rorply_re      (pf_dp_lsp_enq_rorply_re)
,.pf_dp_lsp_enq_rorply_raddr (pf_dp_lsp_enq_rorply_raddr)
,.pf_dp_lsp_enq_rorply_waddr (pf_dp_lsp_enq_rorply_waddr)
,.pf_dp_lsp_enq_rorply_we    (pf_dp_lsp_enq_rorply_we)
,.pf_dp_lsp_enq_rorply_wdata (pf_dp_lsp_enq_rorply_wdata)
,.pf_dp_lsp_enq_rorply_rdata (pf_dp_lsp_enq_rorply_rdata)

,.rf_dp_lsp_enq_rorply_rclk (rf_dp_lsp_enq_rorply_rclk)
,.rf_dp_lsp_enq_rorply_rclk_rst_n (rf_dp_lsp_enq_rorply_rclk_rst_n)
,.rf_dp_lsp_enq_rorply_re    (rf_dp_lsp_enq_rorply_re)
,.rf_dp_lsp_enq_rorply_raddr (rf_dp_lsp_enq_rorply_raddr)
,.rf_dp_lsp_enq_rorply_waddr (rf_dp_lsp_enq_rorply_waddr)
,.rf_dp_lsp_enq_rorply_wclk (rf_dp_lsp_enq_rorply_wclk)
,.rf_dp_lsp_enq_rorply_wclk_rst_n (rf_dp_lsp_enq_rorply_wclk_rst_n)
,.rf_dp_lsp_enq_rorply_we    (rf_dp_lsp_enq_rorply_we)
,.rf_dp_lsp_enq_rorply_wdata (rf_dp_lsp_enq_rorply_wdata)
,.rf_dp_lsp_enq_rorply_rdata (rf_dp_lsp_enq_rorply_rdata)

,.rf_dp_lsp_enq_rorply_error (rf_dp_lsp_enq_rorply_error)

,.func_lsp_dp_sch_dir_re    (func_lsp_dp_sch_dir_re)
,.func_lsp_dp_sch_dir_raddr (func_lsp_dp_sch_dir_raddr)
,.func_lsp_dp_sch_dir_waddr (func_lsp_dp_sch_dir_waddr)
,.func_lsp_dp_sch_dir_we    (func_lsp_dp_sch_dir_we)
,.func_lsp_dp_sch_dir_wdata (func_lsp_dp_sch_dir_wdata)
,.func_lsp_dp_sch_dir_rdata (func_lsp_dp_sch_dir_rdata)

,.pf_lsp_dp_sch_dir_re      (pf_lsp_dp_sch_dir_re)
,.pf_lsp_dp_sch_dir_raddr (pf_lsp_dp_sch_dir_raddr)
,.pf_lsp_dp_sch_dir_waddr (pf_lsp_dp_sch_dir_waddr)
,.pf_lsp_dp_sch_dir_we    (pf_lsp_dp_sch_dir_we)
,.pf_lsp_dp_sch_dir_wdata (pf_lsp_dp_sch_dir_wdata)
,.pf_lsp_dp_sch_dir_rdata (pf_lsp_dp_sch_dir_rdata)

,.rf_lsp_dp_sch_dir_rclk (rf_lsp_dp_sch_dir_rclk)
,.rf_lsp_dp_sch_dir_rclk_rst_n (rf_lsp_dp_sch_dir_rclk_rst_n)
,.rf_lsp_dp_sch_dir_re    (rf_lsp_dp_sch_dir_re)
,.rf_lsp_dp_sch_dir_raddr (rf_lsp_dp_sch_dir_raddr)
,.rf_lsp_dp_sch_dir_waddr (rf_lsp_dp_sch_dir_waddr)
,.rf_lsp_dp_sch_dir_wclk (rf_lsp_dp_sch_dir_wclk)
,.rf_lsp_dp_sch_dir_wclk_rst_n (rf_lsp_dp_sch_dir_wclk_rst_n)
,.rf_lsp_dp_sch_dir_we    (rf_lsp_dp_sch_dir_we)
,.rf_lsp_dp_sch_dir_wdata (rf_lsp_dp_sch_dir_wdata)
,.rf_lsp_dp_sch_dir_rdata (rf_lsp_dp_sch_dir_rdata)

,.rf_lsp_dp_sch_dir_error (rf_lsp_dp_sch_dir_error)

,.func_lsp_dp_sch_rorply_re    (func_lsp_dp_sch_rorply_re)
,.func_lsp_dp_sch_rorply_raddr (func_lsp_dp_sch_rorply_raddr)
,.func_lsp_dp_sch_rorply_waddr (func_lsp_dp_sch_rorply_waddr)
,.func_lsp_dp_sch_rorply_we    (func_lsp_dp_sch_rorply_we)
,.func_lsp_dp_sch_rorply_wdata (func_lsp_dp_sch_rorply_wdata)
,.func_lsp_dp_sch_rorply_rdata (func_lsp_dp_sch_rorply_rdata)

,.pf_lsp_dp_sch_rorply_re      (pf_lsp_dp_sch_rorply_re)
,.pf_lsp_dp_sch_rorply_raddr (pf_lsp_dp_sch_rorply_raddr)
,.pf_lsp_dp_sch_rorply_waddr (pf_lsp_dp_sch_rorply_waddr)
,.pf_lsp_dp_sch_rorply_we    (pf_lsp_dp_sch_rorply_we)
,.pf_lsp_dp_sch_rorply_wdata (pf_lsp_dp_sch_rorply_wdata)
,.pf_lsp_dp_sch_rorply_rdata (pf_lsp_dp_sch_rorply_rdata)

,.rf_lsp_dp_sch_rorply_rclk (rf_lsp_dp_sch_rorply_rclk)
,.rf_lsp_dp_sch_rorply_rclk_rst_n (rf_lsp_dp_sch_rorply_rclk_rst_n)
,.rf_lsp_dp_sch_rorply_re    (rf_lsp_dp_sch_rorply_re)
,.rf_lsp_dp_sch_rorply_raddr (rf_lsp_dp_sch_rorply_raddr)
,.rf_lsp_dp_sch_rorply_waddr (rf_lsp_dp_sch_rorply_waddr)
,.rf_lsp_dp_sch_rorply_wclk (rf_lsp_dp_sch_rorply_wclk)
,.rf_lsp_dp_sch_rorply_wclk_rst_n (rf_lsp_dp_sch_rorply_wclk_rst_n)
,.rf_lsp_dp_sch_rorply_we    (rf_lsp_dp_sch_rorply_we)
,.rf_lsp_dp_sch_rorply_wdata (rf_lsp_dp_sch_rorply_wdata)
,.rf_lsp_dp_sch_rorply_rdata (rf_lsp_dp_sch_rorply_rdata)

,.rf_lsp_dp_sch_rorply_error (rf_lsp_dp_sch_rorply_error)

,.func_rop_dp_enq_dir_re    (func_rop_dp_enq_dir_re)
,.func_rop_dp_enq_dir_raddr (func_rop_dp_enq_dir_raddr)
,.func_rop_dp_enq_dir_waddr (func_rop_dp_enq_dir_waddr)
,.func_rop_dp_enq_dir_we    (func_rop_dp_enq_dir_we)
,.func_rop_dp_enq_dir_wdata (func_rop_dp_enq_dir_wdata)
,.func_rop_dp_enq_dir_rdata (func_rop_dp_enq_dir_rdata)

,.pf_rop_dp_enq_dir_re      (pf_rop_dp_enq_dir_re)
,.pf_rop_dp_enq_dir_raddr (pf_rop_dp_enq_dir_raddr)
,.pf_rop_dp_enq_dir_waddr (pf_rop_dp_enq_dir_waddr)
,.pf_rop_dp_enq_dir_we    (pf_rop_dp_enq_dir_we)
,.pf_rop_dp_enq_dir_wdata (pf_rop_dp_enq_dir_wdata)
,.pf_rop_dp_enq_dir_rdata (pf_rop_dp_enq_dir_rdata)

,.rf_rop_dp_enq_dir_rclk (rf_rop_dp_enq_dir_rclk)
,.rf_rop_dp_enq_dir_rclk_rst_n (rf_rop_dp_enq_dir_rclk_rst_n)
,.rf_rop_dp_enq_dir_re    (rf_rop_dp_enq_dir_re)
,.rf_rop_dp_enq_dir_raddr (rf_rop_dp_enq_dir_raddr)
,.rf_rop_dp_enq_dir_waddr (rf_rop_dp_enq_dir_waddr)
,.rf_rop_dp_enq_dir_wclk (rf_rop_dp_enq_dir_wclk)
,.rf_rop_dp_enq_dir_wclk_rst_n (rf_rop_dp_enq_dir_wclk_rst_n)
,.rf_rop_dp_enq_dir_we    (rf_rop_dp_enq_dir_we)
,.rf_rop_dp_enq_dir_wdata (rf_rop_dp_enq_dir_wdata)
,.rf_rop_dp_enq_dir_rdata (rf_rop_dp_enq_dir_rdata)

,.rf_rop_dp_enq_dir_error (rf_rop_dp_enq_dir_error)

,.func_rop_dp_enq_ro_re    (func_rop_dp_enq_ro_re)
,.func_rop_dp_enq_ro_raddr (func_rop_dp_enq_ro_raddr)
,.func_rop_dp_enq_ro_waddr (func_rop_dp_enq_ro_waddr)
,.func_rop_dp_enq_ro_we    (func_rop_dp_enq_ro_we)
,.func_rop_dp_enq_ro_wdata (func_rop_dp_enq_ro_wdata)
,.func_rop_dp_enq_ro_rdata (func_rop_dp_enq_ro_rdata)

,.pf_rop_dp_enq_ro_re      (pf_rop_dp_enq_ro_re)
,.pf_rop_dp_enq_ro_raddr (pf_rop_dp_enq_ro_raddr)
,.pf_rop_dp_enq_ro_waddr (pf_rop_dp_enq_ro_waddr)
,.pf_rop_dp_enq_ro_we    (pf_rop_dp_enq_ro_we)
,.pf_rop_dp_enq_ro_wdata (pf_rop_dp_enq_ro_wdata)
,.pf_rop_dp_enq_ro_rdata (pf_rop_dp_enq_ro_rdata)

,.rf_rop_dp_enq_ro_rclk (rf_rop_dp_enq_ro_rclk)
,.rf_rop_dp_enq_ro_rclk_rst_n (rf_rop_dp_enq_ro_rclk_rst_n)
,.rf_rop_dp_enq_ro_re    (rf_rop_dp_enq_ro_re)
,.rf_rop_dp_enq_ro_raddr (rf_rop_dp_enq_ro_raddr)
,.rf_rop_dp_enq_ro_waddr (rf_rop_dp_enq_ro_waddr)
,.rf_rop_dp_enq_ro_wclk (rf_rop_dp_enq_ro_wclk)
,.rf_rop_dp_enq_ro_wclk_rst_n (rf_rop_dp_enq_ro_wclk_rst_n)
,.rf_rop_dp_enq_ro_we    (rf_rop_dp_enq_ro_we)
,.rf_rop_dp_enq_ro_wdata (rf_rop_dp_enq_ro_wdata)
,.rf_rop_dp_enq_ro_rdata (rf_rop_dp_enq_ro_rdata)

,.rf_rop_dp_enq_ro_error (rf_rop_dp_enq_ro_error)

,.func_rx_sync_lsp_dp_sch_dir_re    (func_rx_sync_lsp_dp_sch_dir_re)
,.func_rx_sync_lsp_dp_sch_dir_raddr (func_rx_sync_lsp_dp_sch_dir_raddr)
,.func_rx_sync_lsp_dp_sch_dir_waddr (func_rx_sync_lsp_dp_sch_dir_waddr)
,.func_rx_sync_lsp_dp_sch_dir_we    (func_rx_sync_lsp_dp_sch_dir_we)
,.func_rx_sync_lsp_dp_sch_dir_wdata (func_rx_sync_lsp_dp_sch_dir_wdata)
,.func_rx_sync_lsp_dp_sch_dir_rdata (func_rx_sync_lsp_dp_sch_dir_rdata)

,.pf_rx_sync_lsp_dp_sch_dir_re      (pf_rx_sync_lsp_dp_sch_dir_re)
,.pf_rx_sync_lsp_dp_sch_dir_raddr (pf_rx_sync_lsp_dp_sch_dir_raddr)
,.pf_rx_sync_lsp_dp_sch_dir_waddr (pf_rx_sync_lsp_dp_sch_dir_waddr)
,.pf_rx_sync_lsp_dp_sch_dir_we    (pf_rx_sync_lsp_dp_sch_dir_we)
,.pf_rx_sync_lsp_dp_sch_dir_wdata (pf_rx_sync_lsp_dp_sch_dir_wdata)
,.pf_rx_sync_lsp_dp_sch_dir_rdata (pf_rx_sync_lsp_dp_sch_dir_rdata)

,.rf_rx_sync_lsp_dp_sch_dir_rclk (rf_rx_sync_lsp_dp_sch_dir_rclk)
,.rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n (rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n)
,.rf_rx_sync_lsp_dp_sch_dir_re    (rf_rx_sync_lsp_dp_sch_dir_re)
,.rf_rx_sync_lsp_dp_sch_dir_raddr (rf_rx_sync_lsp_dp_sch_dir_raddr)
,.rf_rx_sync_lsp_dp_sch_dir_waddr (rf_rx_sync_lsp_dp_sch_dir_waddr)
,.rf_rx_sync_lsp_dp_sch_dir_wclk (rf_rx_sync_lsp_dp_sch_dir_wclk)
,.rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n (rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n)
,.rf_rx_sync_lsp_dp_sch_dir_we    (rf_rx_sync_lsp_dp_sch_dir_we)
,.rf_rx_sync_lsp_dp_sch_dir_wdata (rf_rx_sync_lsp_dp_sch_dir_wdata)
,.rf_rx_sync_lsp_dp_sch_dir_rdata (rf_rx_sync_lsp_dp_sch_dir_rdata)

,.rf_rx_sync_lsp_dp_sch_dir_error (rf_rx_sync_lsp_dp_sch_dir_error)

,.func_rx_sync_lsp_dp_sch_rorply_re    (func_rx_sync_lsp_dp_sch_rorply_re)
,.func_rx_sync_lsp_dp_sch_rorply_raddr (func_rx_sync_lsp_dp_sch_rorply_raddr)
,.func_rx_sync_lsp_dp_sch_rorply_waddr (func_rx_sync_lsp_dp_sch_rorply_waddr)
,.func_rx_sync_lsp_dp_sch_rorply_we    (func_rx_sync_lsp_dp_sch_rorply_we)
,.func_rx_sync_lsp_dp_sch_rorply_wdata (func_rx_sync_lsp_dp_sch_rorply_wdata)
,.func_rx_sync_lsp_dp_sch_rorply_rdata (func_rx_sync_lsp_dp_sch_rorply_rdata)

,.pf_rx_sync_lsp_dp_sch_rorply_re      (pf_rx_sync_lsp_dp_sch_rorply_re)
,.pf_rx_sync_lsp_dp_sch_rorply_raddr (pf_rx_sync_lsp_dp_sch_rorply_raddr)
,.pf_rx_sync_lsp_dp_sch_rorply_waddr (pf_rx_sync_lsp_dp_sch_rorply_waddr)
,.pf_rx_sync_lsp_dp_sch_rorply_we    (pf_rx_sync_lsp_dp_sch_rorply_we)
,.pf_rx_sync_lsp_dp_sch_rorply_wdata (pf_rx_sync_lsp_dp_sch_rorply_wdata)
,.pf_rx_sync_lsp_dp_sch_rorply_rdata (pf_rx_sync_lsp_dp_sch_rorply_rdata)

,.rf_rx_sync_lsp_dp_sch_rorply_rclk (rf_rx_sync_lsp_dp_sch_rorply_rclk)
,.rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n (rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n)
,.rf_rx_sync_lsp_dp_sch_rorply_re    (rf_rx_sync_lsp_dp_sch_rorply_re)
,.rf_rx_sync_lsp_dp_sch_rorply_raddr (rf_rx_sync_lsp_dp_sch_rorply_raddr)
,.rf_rx_sync_lsp_dp_sch_rorply_waddr (rf_rx_sync_lsp_dp_sch_rorply_waddr)
,.rf_rx_sync_lsp_dp_sch_rorply_wclk (rf_rx_sync_lsp_dp_sch_rorply_wclk)
,.rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n (rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n)
,.rf_rx_sync_lsp_dp_sch_rorply_we    (rf_rx_sync_lsp_dp_sch_rorply_we)
,.rf_rx_sync_lsp_dp_sch_rorply_wdata (rf_rx_sync_lsp_dp_sch_rorply_wdata)
,.rf_rx_sync_lsp_dp_sch_rorply_rdata (rf_rx_sync_lsp_dp_sch_rorply_rdata)

,.rf_rx_sync_lsp_dp_sch_rorply_error (rf_rx_sync_lsp_dp_sch_rorply_error)

,.func_rx_sync_rop_dp_enq_re    (func_rx_sync_rop_dp_enq_re)
,.func_rx_sync_rop_dp_enq_raddr (func_rx_sync_rop_dp_enq_raddr)
,.func_rx_sync_rop_dp_enq_waddr (func_rx_sync_rop_dp_enq_waddr)
,.func_rx_sync_rop_dp_enq_we    (func_rx_sync_rop_dp_enq_we)
,.func_rx_sync_rop_dp_enq_wdata (func_rx_sync_rop_dp_enq_wdata)
,.func_rx_sync_rop_dp_enq_rdata (func_rx_sync_rop_dp_enq_rdata)

,.pf_rx_sync_rop_dp_enq_re      (pf_rx_sync_rop_dp_enq_re)
,.pf_rx_sync_rop_dp_enq_raddr (pf_rx_sync_rop_dp_enq_raddr)
,.pf_rx_sync_rop_dp_enq_waddr (pf_rx_sync_rop_dp_enq_waddr)
,.pf_rx_sync_rop_dp_enq_we    (pf_rx_sync_rop_dp_enq_we)
,.pf_rx_sync_rop_dp_enq_wdata (pf_rx_sync_rop_dp_enq_wdata)
,.pf_rx_sync_rop_dp_enq_rdata (pf_rx_sync_rop_dp_enq_rdata)

,.rf_rx_sync_rop_dp_enq_rclk (rf_rx_sync_rop_dp_enq_rclk)
,.rf_rx_sync_rop_dp_enq_rclk_rst_n (rf_rx_sync_rop_dp_enq_rclk_rst_n)
,.rf_rx_sync_rop_dp_enq_re    (rf_rx_sync_rop_dp_enq_re)
,.rf_rx_sync_rop_dp_enq_raddr (rf_rx_sync_rop_dp_enq_raddr)
,.rf_rx_sync_rop_dp_enq_waddr (rf_rx_sync_rop_dp_enq_waddr)
,.rf_rx_sync_rop_dp_enq_wclk (rf_rx_sync_rop_dp_enq_wclk)
,.rf_rx_sync_rop_dp_enq_wclk_rst_n (rf_rx_sync_rop_dp_enq_wclk_rst_n)
,.rf_rx_sync_rop_dp_enq_we    (rf_rx_sync_rop_dp_enq_we)
,.rf_rx_sync_rop_dp_enq_wdata (rf_rx_sync_rop_dp_enq_wdata)
,.rf_rx_sync_rop_dp_enq_rdata (rf_rx_sync_rop_dp_enq_rdata)

,.rf_rx_sync_rop_dp_enq_error (rf_rx_sync_rop_dp_enq_error)

,.func_dir_nxthp_re    (func_dir_nxthp_re)
,.func_dir_nxthp_addr  (func_dir_nxthp_addr)
,.func_dir_nxthp_we    (func_dir_nxthp_we)
,.func_dir_nxthp_wdata (func_dir_nxthp_wdata)
,.func_dir_nxthp_rdata (func_dir_nxthp_rdata)

,.pf_dir_nxthp_re      (pf_dir_nxthp_re)
,.pf_dir_nxthp_addr    (pf_dir_nxthp_addr)
,.pf_dir_nxthp_we      (pf_dir_nxthp_we)
,.pf_dir_nxthp_wdata   (pf_dir_nxthp_wdata)
,.pf_dir_nxthp_rdata   (pf_dir_nxthp_rdata)

,.sr_dir_nxthp_clk (sr_dir_nxthp_clk)
,.sr_dir_nxthp_clk_rst_n (sr_dir_nxthp_clk_rst_n)
,.sr_dir_nxthp_re    (sr_dir_nxthp_re)
,.sr_dir_nxthp_addr  (sr_dir_nxthp_addr)
,.sr_dir_nxthp_we    (sr_dir_nxthp_we)
,.sr_dir_nxthp_wdata (sr_dir_nxthp_wdata)
,.sr_dir_nxthp_rdata (sr_dir_nxthp_rdata)

,.sr_dir_nxthp_error (sr_dir_nxthp_error)

);
// END HQM_RAM_ACCESS

//---------------------------------------------------------------------------------------------------------
// common core - Interface & clock control

logic rx_sync_rop_dp_enq_enable ;
logic rx_sync_rop_dp_enq_idle ;
logic rx_sync_lsp_dp_sch_dir_enable ;
logic rx_sync_lsp_dp_sch_dir_idle ;
logic rx_sync_lsp_dp_sch_rorply_enable ;
logic rx_sync_lsp_dp_sch_rorply_idle ;
logic tx_sync_dp_lsp_enq_dir_idle ;
logic tx_sync_dp_lsp_enq_rorply_idle ;
logic tx_sync_dp_dqed_idle ;
logic unit_idle_local ;
hqm_AW_module_clock_control # (
  .REQS ( 4 )
) i_hqm_AW_module_clock_control (
    .hqm_inp_gated_clk                    ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                  ( hqm_inp_gated_rst_n )
  , .hqm_gated_clk                        ( hqm_gated_clk )
  , .hqm_gated_rst_n                      ( hqm_gated_rst_n )
  , .cfg_co_dly                           ( { 2'd0 , hqm_dp_target_cfg_patch_control_reg_f [ 13 : 0 ] } ) 
  , .cfg_co_disable                       ( hqm_dp_target_cfg_patch_control_reg_f [ 31 ] ) 
  , .hqm_proc_clk_en                      ( hqm_proc_clk_en )
  , .unit_idle_local                      ( unit_idle_local )
  , .unit_idle                            ( dp_unit_idle )
  , .inp_fifo_empty                       ( { cfg_rx_idle
                                            , rx_sync_rop_dp_enq_idle
                                            , rx_sync_lsp_dp_sch_dir_idle
                                            , rx_sync_lsp_dp_sch_rorply_idle
                                            }
                                          )
  , .inp_fifo_en                          ( { cfg_rx_enable
                                            , rx_sync_rop_dp_enq_enable
                                            , rx_sync_lsp_dp_sch_dir_enable
                                            , rx_sync_lsp_dp_sch_rorply_enable
                                            }
                                          )
  , .cfg_idle                             ( cfg_idle )
  , .int_idle                             ( int_idle )

  , .rst_prep                             ( rst_prep )
  , .reset_active                         ( hqm_gated_rst_n_active )
) ;

assign dp_dqed_force_clockon = ( fifo_dp_dqed_push | ~ fifo_dp_dqed_empty ) ;

// double buffer for rop_dp interface to enqeue new/replay HCW
rop_dp_enq_t wire_rop_dp_enq_data ;
assign wire_rop_dp_enq_data.cmd = rop_dp_enq_data.cmd ;
assign wire_rop_dp_enq_data.cq = { ~ ( rop_dp_enq_data.cmd [ 2 ] ^ rop_dp_enq_data.cmd [ 1 ] ^ rop_dp_enq_data.cmd [ 0 ] ^ rop_dp_enq_data.cq [ 6 ] ^ rop_dp_enq_data.cq [ 5 ] ^ rop_dp_enq_data.cq [ 4 ] ^ rop_dp_enq_data.cq [ 3 ] ^ rop_dp_enq_data.cq [ 2 ] ^ rop_dp_enq_data.cq [ 1 ] ^ rop_dp_enq_data.cq [ 0 ] )
                                 , rop_dp_enq_data.cq [ 6 : 0 ] 
                                 } ;
assign wire_rop_dp_enq_data.flid = rop_dp_enq_data.flid ;
assign wire_rop_dp_enq_data.flid_parity = rop_dp_enq_data.flid_parity ;
assign wire_rop_dp_enq_data.hist_list_info = rop_dp_enq_data.hist_list_info ;
assign wire_rop_dp_enq_data.frag_list_info = rop_dp_enq_data.frag_list_info ;
hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_rop_dp_enq_data ) )
  , .SEED                               ( 32'h0f )
  ) i_rx_sync_rop_dp_enq (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_rop_dp_enq_status_pnc )
  , .enable                             ( rx_sync_rop_dp_enq_enable )
  , .idle                               ( rx_sync_rop_dp_enq_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( rop_dp_enq_v )
  , .in_ready                           ( rop_dp_enq_ready )
  , .in_data                            ( wire_rop_dp_enq_data )
  , .out_valid                          ( rx_sync_rop_dp_enq_v )
  , .out_ready                          ( rx_sync_rop_dp_enq_ready )
  , .out_data                           ( rx_sync_rop_dp_enq_data )
  , .mem_we                             ( func_rx_sync_rop_dp_enq_we )
  , .mem_waddr                          ( func_rx_sync_rop_dp_enq_waddr )
  , .mem_wdata                          ( func_rx_sync_rop_dp_enq_wdata )
  , .mem_re                             ( func_rx_sync_rop_dp_enq_re )
  , .mem_raddr                          ( func_rx_sync_rop_dp_enq_raddr )
  , .mem_rdata                          ( func_rx_sync_rop_dp_enq_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [0] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

// double buffer for lsp_dp interface to scheudle dir HCW
hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_lsp_dp_sch_dir_data ) )
  , .SEED                               ( 32'h1e )
  ) i_rx_sync_lsp_dp_sch_dir (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_lsp_dp_sch_dir_status_pnc )
  , .enable                             ( rx_sync_lsp_dp_sch_dir_enable )
  , .idle                               ( rx_sync_lsp_dp_sch_dir_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( lsp_dp_sch_dir_v )
  , .in_ready                           ( lsp_dp_sch_dir_ready )
  , .in_data                            ( lsp_dp_sch_dir_data )
  , .out_valid                          ( rx_sync_lsp_dp_sch_dir_v )
  , .out_ready                          ( rx_sync_lsp_dp_sch_dir_ready )
  , .out_data                           ( rx_sync_lsp_dp_sch_dir_data )
  , .mem_we                             ( func_rx_sync_lsp_dp_sch_dir_we )
  , .mem_waddr                          ( func_rx_sync_lsp_dp_sch_dir_waddr )
  , .mem_wdata                          ( func_rx_sync_lsp_dp_sch_dir_wdata )
  , .mem_re                             ( func_rx_sync_lsp_dp_sch_dir_re )
  , .mem_raddr                          ( func_rx_sync_lsp_dp_sch_dir_raddr )
  , .mem_rdata                          ( func_rx_sync_lsp_dp_sch_dir_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [1] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

// double buffer for lsp_dp interface to scheudle dir replay list
hqm_AW_rx_sync_wagitate # (
    .WIDTH                              ( $bits ( rx_sync_lsp_dp_sch_rorply_data ) )
  , .SEED                               ( 32'h2d )
  ) i_rx_sync_lsp_dp_sch_rorply (
    .hqm_inp_gated_clk                  ( hqm_inp_gated_clk )
  , .hqm_inp_gated_rst_n                ( hqm_inp_gated_rst_n )
  , .status                             ( rx_sync_lsp_dp_sch_rorply_status_pnc )
  , .enable                             ( rx_sync_lsp_dp_sch_rorply_enable )
  , .idle                               ( rx_sync_lsp_dp_sch_rorply_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( lsp_dp_sch_rorply_v )
  , .in_ready                           ( lsp_dp_sch_rorply_ready )
  , .in_data                            ( lsp_dp_sch_rorply_data )
  , .out_valid                          ( rx_sync_lsp_dp_sch_rorply_v )
  , .out_ready                          ( rx_sync_lsp_dp_sch_rorply_ready )
  , .out_data                           ( rx_sync_lsp_dp_sch_rorply_data )
  , .mem_we                             ( func_rx_sync_lsp_dp_sch_rorply_we )
  , .mem_waddr                          ( func_rx_sync_lsp_dp_sch_rorply_waddr )
  , .mem_wdata                          ( func_rx_sync_lsp_dp_sch_rorply_wdata )
  , .mem_re                             ( func_rx_sync_lsp_dp_sch_rorply_re )
  , .mem_raddr                          ( func_rx_sync_lsp_dp_sch_rorply_raddr )
  , .mem_rdata                          ( func_rx_sync_lsp_dp_sch_rorply_rdata )
  , .agit_enable                        ( cfg_agitate_select_f [2] )
  , .agit_control                       ( cfg_agitate_control_f )
) ;

// double buffer for dp_lsp interface to signal when a HCW has been enqueued
hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_dp_lsp_enq_dir_data ) )
  ) i_tx_sync_dp_lsp_enq_dir (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_n )
  , .status                             ( tx_sync_dp_lsp_enq_dir_status_pnc )
  , .idle                               ( tx_sync_dp_lsp_enq_dir_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_dp_lsp_enq_dir_v )
  , .in_ready                           ( tx_sync_dp_lsp_enq_dir_ready )
  , .in_data                            ( tx_sync_dp_lsp_enq_dir_data )
  , .out_valid                          ( dp_lsp_enq_dir_v )
  , .out_ready                          ( dp_lsp_enq_dir_ready )
  , .out_data                           ( dp_lsp_enq_dir_data )
) ;

// double buffer for dp_lsp interface to signal when a HCW has been enqueued
hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_dp_lsp_enq_rorply_data ) )
  ) i_tx_sync_dp_lsp_enq_rorply (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_n )
  , .status                             ( tx_sync_dp_lsp_enq_rorply_status_pnc )
  , .idle                               ( tx_sync_dp_lsp_enq_rorply_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_dp_lsp_enq_rorply_v )
  , .in_ready                           ( tx_sync_dp_lsp_enq_rorply_ready )
  , .in_data                            ( tx_sync_dp_lsp_enq_rorply_data )
  , .out_valid                          ( dp_lsp_enq_rorply_v )
  , .out_ready                          ( dp_lsp_enq_rorply_ready )
  , .out_data                           ( dp_lsp_enq_rorply_data )
) ;


// double buffer for dp_dqed interface to issue pop command when scheduling
hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_dp_dqed_data ) )
  ) i_tx_sync_dp_dqed (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_n )
  , .status                             ( tx_sync_dp_dqed_status_pnc )
  , .idle                               ( tx_sync_dp_dqed_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_dp_dqed_v )
  , .in_ready                           ( tx_sync_dp_dqed_ready )
  , .in_data                            ( tx_sync_dp_dqed_data )
  , .out_valid                          ( dp_dqed_v )
  , .out_ready                          ( dp_dqed_ready )
  , .out_data                           ( dp_dqed_data )
) ;

//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar

cfg_req_t unit_cfg_req ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read ;
logic unit_cfg_rsp_ack ;
logic unit_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ] unit_cfg_rsp_rdata ;
hqm_AW_cfg_ring_top # (
          .NODE_ID                     ( HQM_DP_CFG_NODE_ID )
        , .UNIT_ID                     ( HQM_DP_CFG_UNIT_ID )
        , .UNIT_TGT_MAP                ( HQM_DP_CFG_UNIT_TGT_MAP )
        , .UNIT_NUM_TGTS               ( HQM_DP_CFG_UNIT_NUM_TGTS )
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

        , .up_cfg_req_write            ( dp_cfg_req_up_write )
        , .up_cfg_req_read             ( dp_cfg_req_up_read )
        , .up_cfg_req                  ( dp_cfg_req_up )
        , .up_cfg_rsp_ack              ( dp_cfg_rsp_up_ack )
        , .up_cfg_rsp                  ( dp_cfg_rsp_up )

        , .down_cfg_req_write          ( dp_cfg_req_down_write )
        , .down_cfg_req_read           ( dp_cfg_req_down_read )
        , .down_cfg_req                ( dp_cfg_req_down )
        , .down_cfg_rsp_ack            ( dp_cfg_rsp_down_ack )
        , .down_cfg_rsp                ( dp_cfg_rsp_down )

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
assign hqm_dp_target_cfg_unit_timeout_reg_nxt = {hqm_dp_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign cfg_unit_timeout = {hqm_dp_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_dp_target_cfg_unit_timeout_reg_f[4:0];

localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_dp_target_cfg_unit_version_status = cfg_unit_version;

//------------------------------------------------------------------------------------------------------------------

logic cfg_req_idlepipe ;
logic cfg_req_ready ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read ;
hqm_AW_cfg_sc # (
          .MODULE                      ( HQM_DP_CFG_NODE_ID )
        , .NUM_CFG_TARGETS             ( HQM_DP_CFG_UNIT_NUM_TGTS )
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
    .NUM_INF                            ( HQM_DP_ALARM_NUM_INF )
  , .NUM_COR                            ( HQM_DP_ALARM_NUM_COR )
  , .NUM_UNC                            ( HQM_DP_ALARM_NUM_UNC )
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

  , .int_up_v                           ( dp_alarm_up_v )
  , .int_up_ready                       ( dp_alarm_up_ready )
  , .int_up_data                        ( dp_alarm_up_data )

  , .int_down_v                         ( dp_alarm_down_v )
  , .int_down_ready                     ( dp_alarm_down_ready )
  , .int_down_data                      ( dp_alarm_down_data )

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

assign err_hw_class_01_nxt [ 0 ]  = error_dir_nopri ;
assign err_hw_class_01_nxt [ 1 ]  = error_dir_of ;
assign err_hw_class_01_nxt [ 2 ]  = error_rofrag_of ;
assign err_hw_class_01_nxt [ 3 ]  = error_replay_nopri ;
assign err_hw_class_01_nxt [ 4 ]  = error_replay_of ;
assign err_hw_class_01_nxt [ 5 ]  = error_badcmd0 ;
assign err_hw_class_01_nxt [ 6 ]  = error_replay_headroom ;
assign err_hw_class_01_nxt [ 7 ]  = error_rofrag_headroom ;
assign err_hw_class_01_nxt [ 8 ]  = error_dir_headroom [ 1 ] ;
assign err_hw_class_01_nxt [ 9 ]  = error_dir_headroom [ 0 ] ;
assign err_hw_class_01_nxt [ 10 ] = rw_nxthp_status ;
assign err_hw_class_01_nxt [ 11 ] = rmw_replay_tp_status ;
assign err_hw_class_01_nxt [ 12 ] = rmw_replay_hp_status ;
assign err_hw_class_01_nxt [ 13 ] = rmw_replay_cnt_status ;
assign err_hw_class_01_nxt [ 14 ] = rmw_rofrag_tp_status ;
assign err_hw_class_01_nxt [ 15 ] = rmw_rofrag_hp_status ;
assign err_hw_class_01_nxt [ 16 ] = rmw_rofrag_cnt_status ;
assign err_hw_class_01_nxt [ 17 ] = rmw_dir_tp_status ;
assign err_hw_class_01_nxt [ 18 ] = rmw_dir_hp_status ;
assign err_hw_class_01_nxt [ 19 ] = rmw_dir_cnt_status ;
assign err_hw_class_01_nxt [ 20 ] = residue_check_rx_sync_rop_dp_enq_err ;
assign err_hw_class_01_nxt [ 21 ] = residue_check_dir_cnt_err ;
assign err_hw_class_01_nxt [ 22 ] = residue_check_rofrag_cnt_err ;
assign err_hw_class_01_nxt [ 23 ] = residue_check_replay_cnt_err ;
assign err_hw_class_01_nxt [ 24 ] = rw_nxthp_err_parity ;
assign err_hw_class_01_nxt [ 25 ] = parity_check_rmw_dir_hp_p2_error ;
assign err_hw_class_01_nxt [ 26 ] = parity_check_rmw_dir_tp_p2_error ;
assign err_hw_class_01_nxt [ 27 ] = ( sr_dir_nxthp_error
                             | rf_dp_lsp_enq_dir_error
                             | rf_dir_replay_cnt_error
                             | rf_rx_sync_rop_dp_enq_error
                             | rf_dir_cnt_error
                             | rf_dir_replay_hp_error
                             | rf_lsp_dp_sch_dir_error
                             | rf_rx_sync_lsp_dp_sch_dir_error
                             | rf_rop_dp_enq_dir_error
                             | rf_dir_rofrag_hp_error
                             | rf_dp_dqed_error
                             | rf_dir_tp_error
                             | rf_dir_hp_error
                             | rf_rx_sync_lsp_dp_sch_rorply_error
                             | rf_rop_dp_enq_ro_error
                             | rf_dir_replay_tp_error
                             | rf_dp_lsp_enq_rorply_error
                             | rf_dir_rofrag_cnt_error
                             | rf_lsp_dp_sch_rorply_error
                             | rf_dir_rofrag_tp_error
                             ) ;
assign err_hw_class_01_nxt [ 30 : 28 ] = 3'd1 ;
assign err_hw_class_01_v_nxt = ( | err_hw_class_01_nxt [ 27 : 0 ] ) ;

assign err_hw_class_02_nxt [ 0 ]  = parity_check_rmw_rofrag_hp_p2_error ;
assign err_hw_class_02_nxt [ 1 ]  = parity_check_rmw_rofrag_tp_p2_error ;
assign err_hw_class_02_nxt [ 2 ]  = parity_check_rmw_replay_hp_p2_error ;
assign err_hw_class_02_nxt [ 3 ]  = parity_check_rmw_replay_tp_p2_error ;
assign err_hw_class_02_nxt [ 4 ]  = parity_check_rw_nxthp_p2_data_error ;
assign err_hw_class_02_nxt [ 5 ]  = parity_check_rx_sync_lsp_dp_sch_dir_error ;
assign err_hw_class_02_nxt [ 6 ]  = parity_check_rx_sync_lsp_dp_sch_rorply_error ;
assign err_hw_class_02_nxt [ 7 ]  = parity_check_rx_sync_rop_dp_enq_data_flid_error ;
assign err_hw_class_02_nxt [ 8 ]  = parity_check_rx_sync_rop_dp_enq_data_hist_list_error ;
assign err_hw_class_02_nxt [ 9 ]  = parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_error ;
assign err_hw_class_02_nxt [ 10 ] = parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_error ;
assign err_hw_class_02_nxt [ 11 ] = cfg_rx_fifo_status.overflow ;
assign err_hw_class_02_nxt [ 12 ] = cfg_rx_fifo_status.underflow ;
assign err_hw_class_02_nxt [ 13 ] = rx_sync_rop_dp_enq_status_pnc.overflow ;
assign err_hw_class_02_nxt [ 14 ] = rx_sync_rop_dp_enq_status_pnc.underflow ;
assign err_hw_class_02_nxt [ 15 ] = rx_sync_lsp_dp_sch_dir_status_pnc.overflow ;
assign err_hw_class_02_nxt [ 16 ] = rx_sync_lsp_dp_sch_dir_status_pnc.underflow ;
assign err_hw_class_02_nxt [ 17 ] = rx_sync_lsp_dp_sch_rorply_status_pnc.overflow ;
assign err_hw_class_02_nxt [ 18 ] = rx_sync_lsp_dp_sch_rorply_status_pnc.underflow ;
assign err_hw_class_02_nxt [ 19 ] = fifo_rop_dp_enq_dir_error_of ;
assign err_hw_class_02_nxt [ 20 ] = fifo_rop_dp_enq_dir_error_uf ;
assign err_hw_class_02_nxt [ 21 ] = fifo_rop_dp_enq_ro_error_of ;
assign err_hw_class_02_nxt [ 22 ] = fifo_rop_dp_enq_ro_error_uf ;
assign err_hw_class_02_nxt [ 23 ] = fifo_lsp_dp_sch_dir_error_of ;
assign err_hw_class_02_nxt [ 24 ] = fifo_lsp_dp_sch_dir_error_uf ;
assign err_hw_class_02_nxt [ 25 ] = fifo_lsp_dp_sch_rorply_error_of ;
assign err_hw_class_02_nxt [ 26 ] = fifo_lsp_dp_sch_rorply_error_uf ;
assign err_hw_class_02_nxt [ 27 ] = fifo_dp_dqed_error_of ;
assign err_hw_class_02_nxt [ 30 : 28 ] = 3'd2 ;
assign err_hw_class_02_v_nxt = ( | err_hw_class_02_nxt [ 27 : 0 ] ) ;

assign err_hw_class_03_nxt [ 0 ]  = fifo_dp_dqed_error_uf ;
assign err_hw_class_03_nxt [ 1 ]  = fifo_dp_lsp_enq_dir_error_of ;
assign err_hw_class_03_nxt [ 2 ]  = fifo_dp_lsp_enq_dir_error_uf ;
assign err_hw_class_03_nxt [ 3 ]  = fifo_dp_lsp_enq_rorply_error_of ;
assign err_hw_class_03_nxt [ 4 ]  = fifo_dp_lsp_enq_rorply_error_uf ;
assign err_hw_class_03_nxt [ 5 ]  = fifo_rop_dp_enq_dir_pop_data_parity_error ;
assign err_hw_class_03_nxt [ 6 ]  = fifo_rop_dp_enq_ro_pop_data_parity_error ;
assign err_hw_class_03_nxt [ 7 ]  = 1'b0 ;
assign err_hw_class_03_nxt [ 8 ]  = 1'b0 ;
assign err_hw_class_03_nxt [ 9 ]  = 1'b0 ;
assign err_hw_class_03_nxt [ 10 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 11 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 12 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 13 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 14 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 15 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 16 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 17 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 18 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 19 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 20 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 21 ] = 1'b0 ;
assign err_hw_class_03_nxt [ 22 ] = hqm_dir_pipe_rfw_top_ipar_error ;
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
  int_uid                                          = HQM_DP_CFG_UNIT_ID ;
  int_unc_v                                        = '0 ;
  int_unc_data                                     = '0 ;
  int_cor_v                                        = '0 ;
  int_cor_data                                     = '0 ;
  int_inf_v                                        = '0 ;
  int_inf_data                                     = '0 ;
  hqm_dp_target_cfg_syndrome_00_capture_v          = '0 ;
  hqm_dp_target_cfg_syndrome_00_capture_data       = '0 ;
  hqm_dp_target_cfg_syndrome_01_capture_v          = '0 ;
  hqm_dp_target_cfg_syndrome_01_capture_data       = '0 ;


  //  rw_nxthp_error_sb_f "SB ECC Error" correctable ECC error on DP nxthp storage
  if ( rw_nxthp_error_sb_f & ~hqm_dp_target_cfg_dir_csr_control_reg_f[0]  ) begin
    int_cor_v [ 0 ]                                = 1'b1 ;
    int_cor_data [ 0 ].rtype                       = 2'd0 ;
    int_cor_data [ 0 ].rid                         = 8'h0 ;
    int_cor_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_dp_target_cfg_syndrome_01_capture_v        = ~hqm_dp_target_cfg_dir_csr_control_reg_f[1] ;
    hqm_dp_target_cfg_syndrome_01_capture_data     = 31'h00000001 ;
  end
  //  rw_nxthp_error_mb_f "MB ECC Error" uncorrectable ECC error on DP nxthp storage
  if ( rw_nxthp_error_mb_f & ~hqm_dp_target_cfg_dir_csr_control_reg_f[2]  ) begin
    int_unc_v [ 0 ]                                = 1'b1 ;
    int_unc_data [ 0 ].rtype                       = 2'd0 ;
    int_unc_data [ 0 ].rid                         = 8'h0 ;
    int_unc_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_dp_target_cfg_syndrome_01_capture_v        = ~hqm_dp_target_cfg_dir_csr_control_reg_f[3] ;
    hqm_dp_target_cfg_syndrome_01_capture_data     = 31'h00000002 ;
  end
  //  err_hw_class_01_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_01_v_f & ~hqm_dp_target_cfg_dir_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_dp_target_cfg_syndrome_00_capture_v        = ~hqm_dp_target_cfg_dir_csr_control_reg_f[5] ;
    hqm_dp_target_cfg_syndrome_00_capture_data     = err_hw_class_01_f ;
  end
  //  err_hw_class_02_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_02_v_f & ~hqm_dp_target_cfg_dir_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_dp_target_cfg_syndrome_00_capture_v        = ~hqm_dp_target_cfg_dir_csr_control_reg_f[5] ;
    hqm_dp_target_cfg_syndrome_00_capture_data     = err_hw_class_02_f ;
  end
  //  err_hw_class_03_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_03_v_f & ~hqm_dp_target_cfg_dir_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_dp_target_cfg_syndrome_00_capture_v        = ~hqm_dp_target_cfg_dir_csr_control_reg_f[5] ;
    hqm_dp_target_cfg_syndrome_00_capture_data     = err_hw_class_03_f ;
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



    p0_dir_v_f <= '0 ;
    p1_dir_v_f <= '0 ;
    p2_dir_v_f <= '0 ;
    p3_dir_v_f <= '0 ;
    p4_dir_v_f <= '0 ;
    p5_dir_v_f <= '0 ;
    p6_dir_v_f <= '0 ;
    p7_dir_v_f <= '0 ;
    p8_dir_v_f <= '0 ;
    p9_dir_v_f_nc <= '0 ;

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



    p0_dir_v_f <= p0_dir_v_nxt ;
    p1_dir_v_f <= p1_dir_v_nxt ;
    p2_dir_v_f <= p2_dir_v_nxt ;
    p3_dir_v_f <= p3_dir_v_nxt ;
    p4_dir_v_f <= p4_dir_v_nxt ;
    p5_dir_v_f <= p5_dir_v_nxt ;
    p6_dir_v_f <= p6_dir_v_nxt ;
    p7_dir_v_f <= p7_dir_v_nxt ;
    p8_dir_v_f <= p8_dir_v_nxt ;
    p9_dir_v_f_nc <= p9_dir_v_nxt ;

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


    p0_dir_data_f <= p0_dir_data_nxt ;
    p1_dir_data_f <= p1_dir_data_nxt ;
    p2_dir_data_f <= p2_dir_data_nxt ;
    p3_dir_data_f <= p3_dir_data_nxt ;
    p4_dir_data_f <= p4_dir_data_nxt ;
    p5_dir_data_f <= p5_dir_data_nxt ;
    p6_dir_data_f <= p6_dir_data_nxt ;
    p7_dir_data_f <= p7_dir_data_nxt ;
    p8_dir_data_f <= p8_dir_data_nxt ;
    p9_dir_data_f <= p9_dir_data_nxt ;

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
    residue_check_dir_cnt_r_f <= '0 ;
    residue_check_dir_cnt_d_f <= '0 ;
    residue_check_dir_cnt_e_f <= '0 ;
  end
  else begin
    residue_check_dir_cnt_r_f <= residue_check_dir_cnt_r_nxt ;
    residue_check_dir_cnt_d_f <= residue_check_dir_cnt_d_nxt ;
    residue_check_dir_cnt_e_f <= residue_check_dir_cnt_e_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L06
  if ( ! hqm_gated_rst_n ) begin
    residue_check_rofrag_cnt_r_f <= '0 ;
    residue_check_rofrag_cnt_d_f <= '0 ;
    residue_check_rofrag_cnt_e_f <= '0 ;
  end
  else begin
    residue_check_rofrag_cnt_r_f <= residue_check_rofrag_cnt_r_nxt ;
    residue_check_rofrag_cnt_d_f <= residue_check_rofrag_cnt_d_nxt ;
    residue_check_rofrag_cnt_e_f <= residue_check_rofrag_cnt_e_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L07
  if ( ! hqm_gated_rst_n ) begin
    residue_check_replay_cnt_r_f <= '0 ;
    residue_check_replay_cnt_d_f <= '0 ;
    residue_check_replay_cnt_e_f <= '0 ;
  end
  else begin
    residue_check_replay_cnt_r_f <= residue_check_replay_cnt_r_nxt ;
    residue_check_replay_cnt_d_f <= residue_check_replay_cnt_d_nxt ;
    residue_check_replay_cnt_e_f <= residue_check_replay_cnt_e_nxt ;
  end
end





always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L08
  if ( ! hqm_gated_rst_n ) begin
    fifo_dp_lsp_enq_dir_cnt_f <= '0 ;
    fifo_dp_lsp_enq_rorply_cnt_f <= '0 ;
    fifo_dp_dqed_dir_cnt_f <= '0 ;
    fifo_dp_dqed_rorply_cnt_f <= '0 ;
  end
  else begin
    fifo_dp_lsp_enq_dir_cnt_f <= fifo_dp_lsp_enq_dir_cnt_nxt ;
    fifo_dp_lsp_enq_rorply_cnt_f <= fifo_dp_lsp_enq_rorply_cnt_nxt ;
    fifo_dp_dqed_dir_cnt_f <= fifo_dp_dqed_dir_cnt_nxt ;
    fifo_dp_dqed_rorply_cnt_f <= fifo_dp_dqed_rorply_cnt_nxt ;
  end
end



// duplicate for fanout violation
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L10
  if ( ! hqm_gated_rst_n ) begin
    dir_stall_f <= '0 ;
    ordered_stall_f <= '0 ;
  end
  else begin
    dir_stall_f <= dir_stall_nxt ;
    ordered_stall_f <= ordered_stall_nxt ;
  end
end







//------------------------------------------------------------------------------------------------------------------------------------------------
// Instances



//....................................................................................................
//HW AGITATE
assign cfg_agitate_control_nxt = cfg_agitate_control_f ;
assign hqm_dp_target_cfg_hw_agitate_control_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_hw_agitate_control_reg_nxt = cfg_agitate_control_nxt ;
assign cfg_agitate_control_f = hqm_dp_target_cfg_hw_agitate_control_reg_f ;

assign cfg_agitate_select_nxt = cfg_agitate_select_f ;
assign hqm_dp_target_cfg_hw_agitate_select_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_hw_agitate_select_reg_nxt = cfg_agitate_select_nxt ;
assign cfg_agitate_select_f = hqm_dp_target_cfg_hw_agitate_select_reg_f ;







//....................................................................................................
// SMON
assign hqm_dp_target_cfg_smon_smon_v         = smon_v ;
assign hqm_dp_target_cfg_smon_disable_smon   = disable_smon ;
assign hqm_dp_target_cfg_smon_smon_comp      = smon_comp ;
assign hqm_dp_target_cfg_smon_smon_val       = smon_val ;
//....................................................................................................
// ECC logic


//....................................................................................................
// Parity logic

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_DP_CNTB2 )
) i_residue_check_replay_cnt (
   .r                                 ( residue_check_replay_cnt_r_f )
 , .d                                 ( residue_check_replay_cnt_d_f )
 , .e                                 ( residue_check_replay_cnt_e_f )
 , .err                               ( residue_check_replay_cnt_err )
) ;


hqm_AW_ecc_gen # (
   .DATA_WIDTH                          ( 15 )
 , .ECC_WIDTH                           ( 6 )
) i_ecc_gen_l (   
   .d                                   ( ecc_gen_d_nc )
 , .ecc                                 ( ecc_gen )
) ;
assign ecc_gen_d_nc = 15'b100_0000_0000_0000 ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 29 )
) i_parity_gen_dir_rop_dp_enq_data_hist_list_d (
     .d                                 ( parity_gen_dir_rop_dp_enq_data_hist_list_d )
   , .odd                               ( 1'b0 ) //NOTE: used for parity subtraction and not checking
   , .p                                 ( parity_gen_dir_rop_dp_enq_data_hist_list_p )
) ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 29 )
) i_parity_gen_rofrag_rop_dp_enq_data_hist_list_d (
     .d                                 ( parity_gen_rofrag_rop_dp_enq_data_hist_list_d )
   , .odd                               ( 1'b0 ) //NOTE: used for parity subtraction and not checking
   , .p                                 ( parity_gen_rofrag_rop_dp_enq_data_hist_list_p )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_DP_FLIDB2 )
) i_parity_check_rmw_dir_hp_p2 (
     .p                                 ( parity_check_rmw_dir_hp_p2_p )
   , .d                                 ( parity_check_rmw_dir_hp_p2_d )
   , .e                                 ( parity_check_rmw_dir_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_dir_hp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_DP_FLIDB2 )
) i_parity_check_rmw_dir_tp_p2 (
     .p                                 ( parity_check_rmw_dir_tp_p2_p )
   , .d                                 ( parity_check_rmw_dir_tp_p2_d )
   , .e                                 ( parity_check_rmw_dir_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_dir_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_DP_FLIDB2 )
) i_parity_check_rmw_rofrag_hp_p2 (
     .p                                 ( parity_check_rmw_rofrag_hp_p2_p )
   , .d                                 ( parity_check_rmw_rofrag_hp_p2_d )
   , .e                                 ( parity_check_rmw_rofrag_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_rofrag_hp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_DP_FLIDB2 )
) i_parity_check_rmw_rofrag_tp_p2 (
     .p                                 ( parity_check_rmw_rofrag_tp_p2_p )
   , .d                                 ( parity_check_rmw_rofrag_tp_p2_d )
   , .e                                 ( parity_check_rmw_rofrag_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_rofrag_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_DP_FLIDB2 )
) i_parity_check_rmw_replay_hp_p2 (
     .p                                 ( parity_check_rmw_replay_hp_p2_p )
   , .d                                 ( parity_check_rmw_replay_hp_p2_d )
   , .e                                 ( parity_check_rmw_replay_hp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_replay_hp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_DP_FLIDB2 )
) i_parity_check_rmw_replay_tp_p2 (
     .p                                 ( parity_check_rmw_replay_tp_p2_p )
   , .d                                 ( parity_check_rmw_replay_tp_p2_d )
   , .e                                 ( parity_check_rmw_replay_tp_p2_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rmw_replay_tp_p2_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_DP_FLIDB2 )
) i_parity_check_rw_nxthp_p2 (
     .p                                 ( parity_check_rw_nxthp_p2_data_p )
   , .d                                 ( parity_check_rw_nxthp_p2_data_d )
   , .e                                 ( parity_check_rw_nxthp_p2_data_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rw_nxthp_p2_data_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 18 )
) i_parity_check_rx_sync_lsp_dp_sch_dir (
     .p                                 ( parity_check_rx_sync_lsp_dp_sch_dir_p )
   , .d                                 ( parity_check_rx_sync_lsp_dp_sch_dir_d )
   , .e                                 ( parity_check_rx_sync_lsp_dp_sch_dir_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_lsp_dp_sch_dir_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 7 )
) i_parity_check_rx_sync_lsp_dp_sch_rorply (
     .p                                 ( parity_check_rx_sync_lsp_dp_sch_rorply_p )
   , .d                                 ( parity_check_rx_sync_lsp_dp_sch_rorply_d )
   , .e                                 ( parity_check_rx_sync_lsp_dp_sch_rorply_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_lsp_dp_sch_rorply_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 15 )
) i_parity_check_rx_sync_rop_dp_enq_data_flid (
     .p                                 ( parity_check_rx_sync_rop_dp_enq_data_flid_p )
   , .d                                 ( parity_check_rx_sync_rop_dp_enq_data_flid_d )
   , .e                                 ( parity_check_rx_sync_rop_dp_enq_data_flid_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_dp_enq_data_flid_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 35 )
) i_parity_check_rx_sync_rop_dp_enq_data_hist_list (
     .p                                 ( parity_check_rx_sync_rop_dp_enq_data_hist_list_p )
   , .d                                 ( parity_check_rx_sync_rop_dp_enq_data_hist_list_d )
   , .e                                 ( parity_check_rx_sync_rop_dp_enq_data_hist_list_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_dp_enq_data_hist_list_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 15 )
) i_parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr (
     .p                                 ( parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_p )
   , .d                                 ( parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_d )
   , .e                                 ( parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 15 )
) i_parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr (
     .p                                 ( parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_p )
   , .d                                 ( parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_d )
   , .e                                 ( parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_error )
) ;

//....................................................................................................
// Residue logic

hqm_AW_residue_check # (
   .WIDTH                             ( 13 )
) i_residue_check_rx_sync_rop_dp_enq_data (
   .r                                 ( residue_check_rx_sync_rop_dp_enq_r )
 , .d                                 ( residue_check_rx_sync_rop_dp_enq_d )
 , .e                                 ( residue_check_rx_sync_rop_dp_enq_e )
 , .err                               ( residue_check_rx_sync_rop_dp_enq_err )
) ;

hqm_AW_residue_add i_residue_add_dir_cnt (
   .a                                 ( residue_add_dir_cnt_a )
 , .b                                 ( residue_add_dir_cnt_b )
 , .r                                 ( residue_add_dir_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_dir_cnt (
   .a                                 ( residue_sub_dir_cnt_a )
 , .b                                 ( residue_sub_dir_cnt_b )
 , .r                                 ( residue_sub_dir_cnt_r )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_DP_CNTB2 )
) i_residue_check_dir_cnt (
   .r                                 ( residue_check_dir_cnt_r_f )
 , .d                                 ( residue_check_dir_cnt_d_f )
 , .e                                 ( residue_check_dir_cnt_e_f )
 , .err                               ( residue_check_dir_cnt_err )
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
   .WIDTH                             ( HQM_DP_CNTB2 )
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





//....................................................................................................
// FIFOs

// FIFO for rop_dp_enq interface used to enqueue HCW : ROP_DP_ENQ_DIR_ENQ_NEW_HCW
assign fifo_rop_dp_enq_dir_error_of = fifo_rop_dp_enq_dir_if_status [ 1 ] ;
assign fifo_rop_dp_enq_dir_error_uf = fifo_rop_dp_enq_dir_if_status [ 0 ] ;
assign fifo_rop_dp_enq_dir_if_cfg_high_wm = hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_f [ HQM_DP_FIFO_ROP_DP_ENQ_DIR_WMWIDTH - 1 : 0 ] ;
assign hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_nxt = { fifo_rop_dp_enq_dir_if_status [ 23 : 0 ] , hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_DP_FIFO_ROP_DP_ENQ_DIR_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_rop_dp_enq_dir_push_data ) )
) i_fifo_rop_dp_enq_dir (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_rop_dp_enq_dir_if_cfg_high_wm )
  , .fifo_status                        ( fifo_rop_dp_enq_dir_if_status )
  , .fifo_full                          ( fifo_rop_dp_enq_dir_full_nc )
  , .fifo_afull                         ( fifo_rop_dp_enq_dir_afull )
  , .fifo_empty                         ( fifo_rop_dp_enq_dir_empty )
  , .push                               ( fifo_rop_dp_enq_dir_push )
  , .push_data                          ( { fifo_rop_dp_enq_dir_push_data } )
  , .pop                                ( fifo_rop_dp_enq_dir_pop )
  , .pop_data                           ( { wire_fifo_rop_dp_enq_dir_pop_data } )
  , .mem_we                             ( func_rop_dp_enq_dir_we )
  , .mem_waddr                          ( func_rop_dp_enq_dir_waddr )
  , .mem_wdata                          ( func_rop_dp_enq_dir_wdata )
  , .mem_re                             ( func_rop_dp_enq_dir_re )
  , .mem_raddr                          ( func_rop_dp_enq_dir_raddr )
  , .mem_rdata                          ( func_rop_dp_enq_dir_rdata )
) ;
assign fifo_rop_dp_enq_dir_pop_data.cmd = wire_fifo_rop_dp_enq_dir_pop_data.cmd ;
assign fifo_rop_dp_enq_dir_pop_data.cq = { 1'b0 , wire_fifo_rop_dp_enq_dir_pop_data.cq [ 6 : 0 ] } ;
assign fifo_rop_dp_enq_dir_pop_data.flid = wire_fifo_rop_dp_enq_dir_pop_data.flid ;
assign fifo_rop_dp_enq_dir_pop_data.flid_parity = wire_fifo_rop_dp_enq_dir_pop_data.flid_parity ;
assign fifo_rop_dp_enq_dir_pop_data.hist_list_info = wire_fifo_rop_dp_enq_dir_pop_data.hist_list_info ;
assign fifo_rop_dp_enq_dir_pop_data.frag_list_info = wire_fifo_rop_dp_enq_dir_pop_data.frag_list_info ;

assign fifo_rop_dp_enq_dir_pop_data_parity_error = ( fifo_rop_dp_enq_dir_pop 
                                                   & ( ~ ( wire_fifo_rop_dp_enq_dir_pop_data.cmd [ 2 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cmd [ 1 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cmd [ 0 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 7 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 6 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 5 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 4 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 3 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 2 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 1 ] ^ wire_fifo_rop_dp_enq_dir_pop_data.cq [ 0 ] ) )
                                                   ) ;

// FIFO for rop_dp_enq interface used to enqueue HCW : ROP_DP_ENQ_DIR_ENQ_REORDER_HCW
assign fifo_rop_dp_enq_ro_error_of = fifo_rop_dp_enq_ro_if_status [ 1 ] ;
assign fifo_rop_dp_enq_ro_error_uf = fifo_rop_dp_enq_ro_if_status [ 0 ] ;
assign fifo_rop_dp_enq_ro_if_cfg_high_wm = hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_f [ HQM_DP_FIFO_ROP_DP_ENQ_RO_WMWIDTH - 1 : 0 ] ;
assign hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_nxt = { fifo_rop_dp_enq_ro_if_status [ 23 : 0 ] , hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_DP_FIFO_ROP_DP_ENQ_RO_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_rop_dp_enq_ro_push_data ) )
) i_fifo_rop_dp_enq_ro (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_rop_dp_enq_ro_if_cfg_high_wm )
  , .fifo_status                        ( fifo_rop_dp_enq_ro_if_status )
  , .fifo_full                          ( fifo_rop_dp_enq_ro_full_nc )
  , .fifo_afull                         ( fifo_rop_dp_enq_ro_afull )
  , .fifo_empty                         ( fifo_rop_dp_enq_ro_empty )
  , .push                               ( fifo_rop_dp_enq_ro_push )
  , .push_data                          ( { fifo_rop_dp_enq_ro_push_data } )
  , .pop                                ( fifo_rop_dp_enq_ro_pop )
  , .pop_data                           ( { wire_fifo_rop_dp_enq_ro_pop_data } )
  , .mem_we                             ( func_rop_dp_enq_ro_we )
  , .mem_waddr                          ( func_rop_dp_enq_ro_waddr )
  , .mem_wdata                          ( func_rop_dp_enq_ro_wdata )
  , .mem_re                             ( func_rop_dp_enq_ro_re )
  , .mem_raddr                          ( func_rop_dp_enq_ro_raddr )
  , .mem_rdata                          ( func_rop_dp_enq_ro_rdata )
) ;

assign fifo_rop_dp_enq_ro_pop_data.cmd = wire_fifo_rop_dp_enq_ro_pop_data.cmd ;
assign fifo_rop_dp_enq_ro_pop_data.cq = { 1'b0 , wire_fifo_rop_dp_enq_ro_pop_data.cq [ 6 : 0 ] } ;
assign fifo_rop_dp_enq_ro_pop_data.flid = wire_fifo_rop_dp_enq_ro_pop_data.flid ;
assign fifo_rop_dp_enq_ro_pop_data.flid_parity = wire_fifo_rop_dp_enq_ro_pop_data.flid_parity ;
assign fifo_rop_dp_enq_ro_pop_data.hist_list_info = wire_fifo_rop_dp_enq_ro_pop_data.hist_list_info ;
assign fifo_rop_dp_enq_ro_pop_data.frag_list_info = wire_fifo_rop_dp_enq_ro_pop_data.frag_list_info ;

assign fifo_rop_dp_enq_ro_pop_data_parity_error = ( fifo_rop_dp_enq_ro_pop 
                                                  & ( ~ ( wire_fifo_rop_dp_enq_ro_pop_data.cmd [ 2 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cmd [ 1 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cmd [ 0 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 7 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 6 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 5 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 4 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 3 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 2 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 1 ] ^ wire_fifo_rop_dp_enq_ro_pop_data.cq [ 0 ] ) )
                                                  ) ;



// FIFO for lsp_dp_sch_dir interface used to schedule direct HCW
assign fifo_lsp_dp_sch_dir_error_of = fifo_lsp_dp_sch_dir_if_status [ 1 ] ;
assign fifo_lsp_dp_sch_dir_error_uf = fifo_lsp_dp_sch_dir_if_status [ 0 ] ;
assign fifo_lsp_dp_sch_dir_if_cfg_high_wm = hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_f [ HQM_DP_FIFO_LSP_DP_SCH_DIR_WMWIDTH - 1 : 0 ] ;
assign hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_nxt = { fifo_lsp_dp_sch_dir_if_status [ 23 : 0 ] , hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_DP_FIFO_LSP_DP_SCH_DIR_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_lsp_dp_sch_dir_push_data ) )
) i_fifo_lsp_dp_sch_dir (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_lsp_dp_sch_dir_if_cfg_high_wm )
  , .fifo_status                        ( fifo_lsp_dp_sch_dir_if_status )
  , .fifo_full                          ( fifo_lsp_dp_sch_dir_full_nc )
  , .fifo_afull                         ( fifo_lsp_dp_sch_dir_afull )
  , .fifo_empty                         ( fifo_lsp_dp_sch_dir_empty )
  , .push                               ( fifo_lsp_dp_sch_dir_push )
  , .push_data                          ( { fifo_lsp_dp_sch_dir_push_data } )
  , .pop                                ( fifo_lsp_dp_sch_dir_pop )
  , .pop_data                           ( { fifo_lsp_dp_sch_dir_pop_data } )
  , .mem_we                             ( func_lsp_dp_sch_dir_we )
  , .mem_waddr                          ( func_lsp_dp_sch_dir_waddr )
  , .mem_wdata                          ( func_lsp_dp_sch_dir_wdata )
  , .mem_re                             ( func_lsp_dp_sch_dir_re )
  , .mem_raddr                          ( func_lsp_dp_sch_dir_raddr )
  , .mem_rdata                          ( func_lsp_dp_sch_dir_rdata )
) ;

// FIFO for lsp_dp_sch_rorply interface used to schedule direct replay list
assign fifo_lsp_dp_sch_rorply_error_of = fifo_lsp_dp_sch_rorply_if_status [ 1 ] ;
assign fifo_lsp_dp_sch_rorply_error_uf = fifo_lsp_dp_sch_rorply_if_status [ 0 ] ;
assign fifo_lsp_dp_sch_rorply_if_cfg_high_wm = hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_f [ HQM_DP_FIFO_LSP_DP_SCH_RORPLY_WMWIDTH - 1 : 0 ] ;
assign hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_nxt = { fifo_lsp_dp_sch_rorply_if_status [ 23 : 0 ] , hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_DP_FIFO_LSP_DP_SCH_RORPLY_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_lsp_dp_sch_rorply_push_data ) )
) i_fifo_lsp_dp_sch_rorply (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_lsp_dp_sch_rorply_if_cfg_high_wm )
  , .fifo_status                        ( fifo_lsp_dp_sch_rorply_if_status )
  , .fifo_full                          ( fifo_lsp_dp_sch_rorply_full )
  , .fifo_afull                         ( fifo_lsp_dp_sch_rorply_afull )
  , .fifo_empty                         ( fifo_lsp_dp_sch_rorply_empty )
  , .push                               ( fifo_lsp_dp_sch_rorply_push )
  , .push_data                          ( { fifo_lsp_dp_sch_rorply_push_data } )
  , .pop                                ( fifo_lsp_dp_sch_rorply_pop )
  , .pop_data                           ( { fifo_lsp_dp_sch_rorply_pop_data } )
  , .mem_we                             ( func_lsp_dp_sch_rorply_we )
  , .mem_waddr                          ( func_lsp_dp_sch_rorply_waddr )
  , .mem_wdata                          ( func_lsp_dp_sch_rorply_wdata )
  , .mem_re                             ( func_lsp_dp_sch_rorply_re )
  , .mem_raddr                          ( func_lsp_dp_sch_rorply_raddr )
  , .mem_rdata                          ( func_lsp_dp_sch_rorply_rdata )
) ;

// FIFO
assign fifo_dp_dqed_error_of = fifo_dp_dqed_if_status [ 1 ] ;
assign fifo_dp_dqed_error_uf = fifo_dp_dqed_if_status [ 0 ] ;
assign fifo_dp_dqed_if_cfg_high_wm = hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_f [ HQM_DP_FIFO_DP_DQED_WMWIDTH - 1 : 0 ] ;
assign hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_nxt = { fifo_dp_dqed_if_status [ 23 : 0 ] , hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_DP_FIFO_DP_DQED_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_dp_dqed_push_data ) )
) i_fifo_dp_dqed_dir (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_dp_dqed_if_cfg_high_wm )
  , .fifo_status                        ( fifo_dp_dqed_if_status )
  , .fifo_full                          ( fifo_dp_dqed_full_nc )
  , .fifo_afull                         ( fifo_dp_dqed_afull )
  , .fifo_empty                         ( fifo_dp_dqed_empty )
  , .push                               ( fifo_dp_dqed_push )
  , .push_data                          ( { fifo_dp_dqed_push_data } )
  , .pop                                ( fifo_dp_dqed_pop )
  , .pop_data                           ( { fifo_dp_dqed_pop_data } )
  , .mem_we                             ( func_dp_dqed_we )
  , .mem_waddr                          ( func_dp_dqed_waddr )
  , .mem_wdata                          ( func_dp_dqed_wdata )
  , .mem_re                             ( func_dp_dqed_re )
  , .mem_raddr                          ( func_dp_dqed_raddr )
  , .mem_rdata                          ( func_dp_dqed_rdata )
) ;

// FIFO
assign fifo_dp_lsp_enq_dir_error_of = fifo_dp_lsp_enq_dir_if_status [ 1 ] ;
assign fifo_dp_lsp_enq_dir_error_uf = fifo_dp_lsp_enq_dir_if_status [ 0 ] ;
assign fifo_dp_lsp_enq_dir_if_cfg_high_wm = hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_f [ HQM_DP_FIFO_DP_LSP_ENQ_DIR_WMWIDTH - 1 : 0 ] ;
assign hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_nxt = { fifo_dp_lsp_enq_dir_if_status [ 23 : 0 ] , hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_DP_FIFO_DP_LSP_ENQ_DIR_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_dp_lsp_enq_dir_push_data ) )
) i_fifo_dp_lsp_enq_dir (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_dp_lsp_enq_dir_if_cfg_high_wm )
  , .fifo_status                        ( fifo_dp_lsp_enq_dir_if_status )
  , .fifo_full                          ( fifo_dp_lsp_enq_dir_full )
  , .fifo_afull                         ( fifo_dp_lsp_enq_dir_afull )
  , .fifo_empty                         ( fifo_dp_lsp_enq_dir_empty )
  , .push                               ( fifo_dp_lsp_enq_dir_push )
  , .push_data                          ( { fifo_dp_lsp_enq_dir_push_data } )
  , .pop                                ( fifo_dp_lsp_enq_dir_pop )
  , .pop_data                           ( { fifo_dp_lsp_enq_dir_pop_data } )
  , .mem_we                             ( func_dp_lsp_enq_dir_we )
  , .mem_waddr                          ( func_dp_lsp_enq_dir_waddr )
  , .mem_wdata                          ( func_dp_lsp_enq_dir_wdata )
  , .mem_re                             ( func_dp_lsp_enq_dir_re )
  , .mem_raddr                          ( func_dp_lsp_enq_dir_raddr )
  , .mem_rdata                          ( func_dp_lsp_enq_dir_rdata )
) ;

assign fifo_dp_lsp_enq_rorply_error_of = fifo_dp_lsp_enq_rorply_if_status [ 1 ] ;
assign fifo_dp_lsp_enq_rorply_error_uf = fifo_dp_lsp_enq_rorply_if_status [ 0 ] ;
assign fifo_dp_lsp_enq_rorply_if_cfg_high_wm = hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_f [ HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_WMWIDTH - 1 : 0 ] ;
assign hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_nxt = { fifo_dp_lsp_enq_rorply_if_status [ 23 : 0 ] , hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_f [ 7 : 0 ] } ;

hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_DP_FIFO_DP_LSP_ENQ_RORPLY_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_dp_lsp_enq_rorply_push_data ) )
) i_fifo_dp_lsp_enq_rorply_dir (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_dp_lsp_enq_rorply_if_cfg_high_wm )
  , .fifo_status                        ( fifo_dp_lsp_enq_rorply_if_status )
  , .fifo_full                          ( fifo_dp_lsp_enq_rorply_full_nc )
  , .fifo_afull                         ( fifo_dp_lsp_enq_rorply_afull )
  , .fifo_empty                         ( fifo_dp_lsp_enq_rorply_empty )
  , .push                               ( fifo_dp_lsp_enq_rorply_push )
  , .push_data                          ( { fifo_dp_lsp_enq_rorply_push_data } )
  , .pop                                ( fifo_dp_lsp_enq_rorply_pop )
  , .pop_data                           ( { fifo_dp_lsp_enq_rorply_pop_data } )
  , .mem_we                             ( func_dp_lsp_enq_rorply_we )
  , .mem_waddr                          ( func_dp_lsp_enq_rorply_waddr )
  , .mem_wdata                          ( func_dp_lsp_enq_rorply_wdata )
  , .mem_re                             ( func_dp_lsp_enq_rorply_re )
  , .mem_raddr                          ( func_dp_lsp_enq_rorply_raddr )
  , .mem_rdata                          ( func_dp_lsp_enq_rorply_rdata )
) ;


//....................................................................................................
// ARB
hqm_AW_rr_arb # (
    .NUM_REQS ( 2 )
) i_arb_dir (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .reqs                               ( arb_dir_reqs )
  , .update                             ( arb_dir_update )
  , .winner_v                           ( arb_dir_winner_v )
  , .winner                             ( arb_dir_winner )
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
) i_arb_dir_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control5_f [ 31 : 24 ] , cfg_control5_f [ 23 : 16 ] , cfg_control5_f [ 15 : 8 ] , cfg_control5_f [ 7 : 0 ] , cfg_control4_f [ 31 : 24 ] , cfg_control4_f [ 23 : 16 ] , cfg_control4_f [ 15 : 8 ] , cfg_control4_f [ 7 : 0 ] } )
  , .reqs                               ( arb_dir_cnt_reqs )
  , .winner_v                           ( arb_dir_cnt_winner_v )
  , .winner                             ( arb_dir_cnt_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 8 )
) i_arb_replay_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control3_f [ 31 : 24 ] , cfg_control3_f [ 23 : 16 ] , cfg_control3_f [ 15 : 8 ] , cfg_control3_f [ 7 : 0 ] , cfg_control2_f [ 31 : 24 ] , cfg_control2_f [ 23 : 16 ] , cfg_control2_f [ 15 : 8 ] , cfg_control2_f [ 7 : 0 ] } )
  , .reqs                               ( arb_replay_cnt_reqs )
  , .winner_v                           ( arb_replay_cnt_winner_v )
  , .winner                             ( arb_replay_cnt_winner )
) ;

hqm_AW_rr_arb # (
    .NUM_REQS ( 2 )
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

logic [ ( 136 ) - 1 : 0 ] wire_func_dir_cnt_wdata ;
logic [ ( 136 ) - 1 : 0 ] wire_func_dir_cnt_rdata ;
assign func_dir_cnt_wdata = { wire_func_dir_cnt_wdata [ 127 : 120 ] , wire_func_dir_cnt_wdata [ 59 : 0 ] } ;
assign wire_func_dir_cnt_rdata = { 8'd0 , func_dir_cnt_rdata [ 67 : 60 ] , 60'd0 , func_dir_cnt_rdata [ 59 : 0 ] } ;
hqm_AW_rmw_mem_4pipe # (
    .DEPTH                              ( HQM_DP_RAM_DIR_CNT_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_DIR_CNT_WIDTH )
) i_rmw_dir_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_dir_cnt_status )

  , .p0_v_nxt                           ( rmw_dir_cnt_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_dir_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_dir_cnt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_dir_cnt_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_dir_cnt_p0_hold )
  , .p0_v_f                             ( rmw_dir_cnt_p0_v_f )
  , .p0_rw_f                            ( rmw_dir_cnt_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_dir_cnt_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_dir_cnt_p0_data_f_nc )

  , .p1_hold                            ( rmw_dir_cnt_p1_hold )
  , .p1_v_f                             ( rmw_dir_cnt_p1_v_f )
  , .p1_rw_f                            ( rmw_dir_cnt_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_dir_cnt_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_dir_cnt_p1_data_f_nc )

  , .p2_hold                            ( rmw_dir_cnt_p2_hold )
  , .p2_v_f                             ( rmw_dir_cnt_p2_v_f )
  , .p2_rw_f                            ( rmw_dir_cnt_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_dir_cnt_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_dir_cnt_p2_data_f )

  , .p3_hold                            ( rmw_dir_cnt_p3_hold )
  , .p3_bypsel_nxt                      ( rmw_dir_cnt_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_dir_cnt_p3_bypdata_nxt )
  , .p3_v_f                             ( rmw_dir_cnt_p3_v_f )
  , .p3_rw_f                            ( rmw_dir_cnt_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_dir_cnt_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_dir_cnt_p3_data_f_nc )

  , .mem_write                          ( func_dir_cnt_we )
  , .mem_read                           ( func_dir_cnt_re )
  , .mem_write_addr                     ( func_dir_cnt_waddr )
  , .mem_read_addr                      ( func_dir_cnt_raddr )
  , .mem_write_data                     ( wire_func_dir_cnt_wdata )
  , .mem_read_data                      ( wire_func_dir_cnt_rdata )
) ;

// uncomment for 8K credits
/*
logic func_dir_hp_rdata_14_nc ;

assign func_dir_hp_wdata [ 14 ] = 1'b0 ;
assign func_dir_hp_rdata_14_nc = func_dir_hp_rdata [14 ] ;
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_DP_RAM_DIR_HP_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_DIR_HP_WIDTH )
) i_rmw_dir_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_dir_hp_status )

  , .p0_v_nxt                           ( rmw_dir_hp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_dir_hp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_dir_hp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_dir_hp_p0_write_data_nxt )
  , .p0_hold                            ( rmw_dir_hp_p0_hold )
  , .p0_v_f                             ( rmw_dir_hp_p0_v_f )
  , .p0_rw_f                            ( rmw_dir_hp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_dir_hp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_dir_hp_p0_data_f_nc )

  , .p1_hold                            ( rmw_dir_hp_p1_hold )
  , .p1_v_f                             ( rmw_dir_hp_p1_v_f )
  , .p1_rw_f                            ( rmw_dir_hp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_dir_hp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_dir_hp_p1_data_f_nc )

  , .p2_hold                            ( rmw_dir_hp_p2_hold )
  , .p2_v_f                             ( rmw_dir_hp_p2_v_f )
  , .p2_rw_f                            ( rmw_dir_hp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_dir_hp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_dir_hp_p2_data_f )

  , .p3_hold                            ( rmw_dir_hp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_dir_hp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_dir_hp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_dir_hp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_dir_hp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_dir_hp_p3_v_f )
  , .p3_rw_f                            ( rmw_dir_hp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_dir_hp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_dir_hp_p3_data_f_nc )

  , .mem_write                          ( func_dir_hp_we )
  , .mem_read                           ( func_dir_hp_re )
  , .mem_write_addr                     ( func_dir_hp_waddr )
  , .mem_read_addr                      ( func_dir_hp_raddr )
  , .mem_write_data                     ( func_dir_hp_wdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_dir_hp_rdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
) ;

// uncomment for 8K credits
/*
logic func_dir_tp_rdata_14_nc ;

assign func_dir_tp_wdata [ 14 ] = 1'b0 ;
assign func_dir_tp_rdata_14_nc = func_dir_tp_rdata [14 ] ;
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_DP_RAM_DIR_TP_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_DIR_TP_WIDTH )
) i_rmw_dir_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_dir_tp_status )

  , .p0_v_nxt                           ( rmw_dir_tp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_dir_tp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_dir_tp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_dir_tp_p0_write_data_nxt )
  , .p0_hold                            ( rmw_dir_tp_p0_hold )
  , .p0_v_f                             ( rmw_dir_tp_p0_v_f )
  , .p0_rw_f                            ( rmw_dir_tp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_dir_tp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_dir_tp_p0_data_f_nc )

  , .p1_hold                            ( rmw_dir_tp_p1_hold )
  , .p1_v_f                             ( rmw_dir_tp_p1_v_f )
  , .p1_rw_f                            ( rmw_dir_tp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_dir_tp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_dir_tp_p1_data_f_nc )

  , .p2_hold                            ( rmw_dir_tp_p2_hold )
  , .p2_v_f                             ( rmw_dir_tp_p2_v_f )
  , .p2_rw_f                            ( rmw_dir_tp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_dir_tp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_dir_tp_p2_data_f )

  , .p3_hold                            ( rmw_dir_tp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_dir_tp_p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( rmw_dir_tp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_dir_tp_p3_bypsel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_dir_tp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_dir_tp_p3_v_f )
  , .p3_rw_f                            ( rmw_dir_tp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_dir_tp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_dir_tp_p3_data_f_nc )

  , .mem_write                          ( func_dir_tp_we )
  , .mem_read                           ( func_dir_tp_re )
  , .mem_write_addr                     ( func_dir_tp_waddr )
  , .mem_read_addr                      ( func_dir_tp_raddr )
  , .mem_write_data                     ( func_dir_tp_wdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_dir_tp_rdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
) ;

assign func_dir_nxthp_we = wire_sr_dir_nxthp_we & ~ stall ;
hqm_dir_pipe_nxthp_rw_mem_4pipe_core # (
    .DEPTH                              ( HQM_DP_RAM_DIR_NXTHP_DEPTH )
  , .WIDTH				( HQM_DP_RAM_DIR_NXTHP_WIDTH )
  , .DATA				( HQM_DP_DQED_DEPTHB2 )
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

  , .mem_write                          ( wire_sr_dir_nxthp_we )
  , .mem_read                           ( func_dir_nxthp_re )
  , .mem_addr                           ( func_dir_nxthp_addr )
  , .mem_write_data                     ( func_dir_nxthp_wdata )
  , .mem_read_data                      ( func_dir_nxthp_rdata )
) ;

hqm_AW_rmw_mem_4pipe # (
    .DEPTH                              ( HQM_DP_RAM_ROFRAG_CNT_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_ROFRAG_CNT_WIDTH )
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

  , .mem_write                          ( func_dir_rofrag_cnt_we )
  , .mem_read                           ( func_dir_rofrag_cnt_re )
  , .mem_write_addr                     ( func_dir_rofrag_cnt_waddr )
  , .mem_read_addr                      ( func_dir_rofrag_cnt_raddr )
  , .mem_write_data                     ( func_dir_rofrag_cnt_wdata )
  , .mem_read_data                      ( func_dir_rofrag_cnt_rdata )
) ;

// uncomment for 8K credits
/*
logic func_dir_rofrag_hp_rdata_14_nc ;

assign func_dir_rofrag_hp_wdata [ 14 ] = 1'b0 ;
assign func_dir_rofrag_hp_rdata_14_nc = func_dir_rofrag_hp_rdata [14 ] ;
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_DP_RAM_ROFRAG_HP_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_ROFRAG_HP_WIDTH )
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

  , .mem_write                          ( func_dir_rofrag_hp_we )
  , .mem_read                           ( func_dir_rofrag_hp_re )
  , .mem_write_addr                     ( func_dir_rofrag_hp_waddr )
  , .mem_read_addr                      ( func_dir_rofrag_hp_raddr )
  , .mem_write_data                     ( func_dir_rofrag_hp_wdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_dir_rofrag_hp_rdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
) ;

// uncomment for 8K credits
/*
logic func_dir_rofrag_tp_rdata_14_nc ;

assign func_dir_rofrag_tp_wdata [ 14 ] = 1'b0 ;
assign func_dir_rofrag_tp_rdata_14_nc = func_dir_rofrag_tp_rdata [14 ] ;
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_DP_RAM_ROFRAG_TP_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_ROFRAG_TP_WIDTH )
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

  , .mem_write                          ( func_dir_rofrag_tp_we )
  , .mem_read                           ( func_dir_rofrag_tp_re )
  , .mem_write_addr                     ( func_dir_rofrag_tp_waddr )
  , .mem_read_addr                      ( func_dir_rofrag_tp_raddr )
  , .mem_write_data                     ( func_dir_rofrag_tp_wdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_dir_rofrag_tp_rdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
) ;

logic [ ( 136 ) - 1 : 0 ] wire_func_dir_replay_cnt_wdata ;
logic [ ( 136 ) - 1 : 0 ] wire_func_dir_replay_cnt_rdata ;
assign func_dir_replay_cnt_wdata = { wire_func_dir_replay_cnt_wdata [ 127 : 120 ] , wire_func_dir_replay_cnt_wdata [ 59 : 0 ] } ;
assign wire_func_dir_replay_cnt_rdata = { 8'd0 , func_dir_replay_cnt_rdata [ 67 : 60 ] , 60'd0 , func_dir_replay_cnt_rdata [ 59 : 0 ] } ;
hqm_AW_rmw_mem_4pipe # (
    .DEPTH                              ( HQM_DP_RAM_REPLAY_CNT_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_REPLAY_CNT_WIDTH )
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

  , .mem_write                          ( func_dir_replay_cnt_we )
  , .mem_read                           ( func_dir_replay_cnt_re )
  , .mem_write_addr                     ( func_dir_replay_cnt_waddr )
  , .mem_read_addr                      ( func_dir_replay_cnt_raddr )
  , .mem_write_data                     ( wire_func_dir_replay_cnt_wdata )
  , .mem_read_data                      ( wire_func_dir_replay_cnt_rdata )
) ;

// uncomment for 8K credits
/*
logic func_dir_replay_hp_rdata_14_nc ;

assign func_dir_replay_hp_wdata [ 14 ] = 1'b0 ;
assign func_dir_replay_hp_rdata_14_nc = func_dir_replay_hp_rdata [14 ] ;
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_DP_RAM_REPLAY_HP_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_REPLAY_HP_WIDTH )
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

  , .mem_write                          ( func_dir_replay_hp_we )
  , .mem_read                           ( func_dir_replay_hp_re )
  , .mem_write_addr                     ( func_dir_replay_hp_waddr )
  , .mem_read_addr                      ( func_dir_replay_hp_raddr )
  , .mem_write_data                     ( func_dir_replay_hp_wdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_dir_replay_hp_rdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
) ;

// uncomment for 8K credits
/*
logic func_dir_replay_tp_rdata_14_nc ;

assign func_dir_replay_tp_wdata [ 14 ] = 1'b0 ;
assign func_dir_replay_tp_rdata_14_nc = func_dir_replay_tp_rdata [14 ] ;
*/

hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_DP_RAM_REPLAY_TP_DEPTH )
  , .WIDTH                              ( HQM_DP_RAM_REPLAY_TP_WIDTH )
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

  , .mem_write                          ( func_dir_replay_tp_we )
  , .mem_read                           ( func_dir_replay_tp_re )
  , .mem_write_addr                     ( func_dir_replay_tp_waddr )
  , .mem_read_addr                      ( func_dir_replay_tp_raddr )
  , .mem_write_data                     ( func_dir_replay_tp_wdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
  , .mem_read_data                      ( func_dir_replay_tp_rdata [ HQM_DP_DQED_DEPTHB2 : 0 ] )
) ;



assign hqm_dp_target_cfg_patch_control_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_patch_control_reg_nxt = hqm_dp_target_cfg_patch_control_reg_f ;

assign hqm_dp_target_cfg_dir_csr_control_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_dir_csr_control_reg_nxt = cfg_csr_control_nxt ;
assign cfg_csr_control_f = hqm_dp_target_cfg_dir_csr_control_reg_f ;

assign hqm_dp_target_cfg_control_general_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_control_general_reg_nxt = cfg_control0_nxt ;
assign cfg_control0_f = hqm_dp_target_cfg_control_general_reg_f ;

assign hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt = cfg_control2_nxt ;
assign cfg_control2_f = hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_f ;

assign hqm_dp_target_cfg_control_arb_weights_tqpri_replay_1_status = 32'd0 ;
assign cfg_control3_f = 32'd0 ;

assign hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_nxt = cfg_control4_nxt ;
assign cfg_control4_f = hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_f ;

assign hqm_dp_target_cfg_control_arb_weights_tqpri_dir_1_status = 32'd0 ;
assign cfg_control5_f =  32'd0 ;

assign hqm_dp_target_cfg_detect_feature_operation_00_reg_nxt = cfg_control6_nxt ;
assign cfg_control6_f_pnc = hqm_dp_target_cfg_detect_feature_operation_00_reg_f ;

assign hqm_dp_target_cfg_detect_feature_operation_01_reg_nxt = cfg_control7_nxt ;
assign cfg_control7_f_pnc = hqm_dp_target_cfg_detect_feature_operation_01_reg_f ;

assign hqm_dp_target_cfg_control_pipeline_credits_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_control_pipeline_credits_reg_nxt = cfg_control8_nxt ;
assign cfg_control8_f = hqm_dp_target_cfg_control_pipeline_credits_reg_f ;

assign hqm_dp_target_cfg_unit_idle_reg_nxt = cfg_unit_idle_nxt ;
assign cfg_unit_idle_f = hqm_dp_target_cfg_unit_idle_reg_f ;

assign hqm_dp_target_cfg_pipe_health_valid_00_reg_nxt = cfg_pipe_health_valid_00_nxt ;
assign cfg_pipe_health_valid_00_f = hqm_dp_target_cfg_pipe_health_valid_00_reg_f ;

assign hqm_dp_target_cfg_pipe_health_hold_00_reg_nxt = cfg_pipe_health_hold_00_nxt ;
assign cfg_pipe_health_hold_00_f = hqm_dp_target_cfg_pipe_health_hold_00_reg_f ;

assign hqm_dp_target_cfg_interface_status_reg_nxt = cfg_interface_nxt ;
assign cfg_interface_f = hqm_dp_target_cfg_interface_status_reg_f ;

assign hqm_dp_target_cfg_error_inject_reg_v = 1'b0 ;
assign hqm_dp_target_cfg_error_inject_reg_nxt = cfg_error_inj_nxt ;
assign cfg_error_inj_f = hqm_dp_target_cfg_error_inject_reg_f ;

//....................................................................................................
// STATUS

assign hqm_dp_target_cfg_diagnostic_aw_status_status = cfg_status0 ;

assign hqm_dp_target_cfg_diagnostic_aw_status_01_status = cfg_status1 ;

assign hqm_dp_target_cfg_diagnostic_aw_status_02_status = cfg_status2 ;



//------------------------------------------------------------------------------------------------------------------------------------------------
//counters 
always_comb begin : L09
  fifo_dp_lsp_enq_dir_cnt_nxt = fifo_dp_lsp_enq_dir_cnt_f + { 4'd0 , fifo_dp_lsp_enq_dir_inc } - { 4'd0 , fifo_dp_lsp_enq_dir_dec } ;
  fifo_dp_lsp_enq_rorply_cnt_nxt = fifo_dp_lsp_enq_rorply_cnt_f + { 4'd0 , fifo_dp_lsp_enq_rorply_inc } - { 4'd0 , fifo_dp_lsp_enq_rorply_dec } ;
  fifo_dp_dqed_dir_cnt_nxt = fifo_dp_dqed_dir_cnt_f + { 4'd0 , fifo_dp_dqed_dir_inc } - { 4'd0 , fifo_dp_dqed_dir_dec } ;
  fifo_dp_dqed_rorply_cnt_nxt = fifo_dp_dqed_rorply_cnt_f + { 4'd0 , fifo_dp_dqed_rorply_inc } - { 4'd0 , fifo_dp_dqed_rorply_dec } ;
end


//------------------------------------------------------------------------------------------------------------------------------------------------
// Functional

always_comb begin : L11
  dir_stall_nxt = { 5 { ( p6_dir_v_nxt & ( ( p6_dir_data_nxt.cmd == HQM_DP_CMD_DEQ ) | cfg_control0_f [ HQM_DP_CHICKEN_V1MODE ] )
                     & ( ( ( p7_dir_v_nxt & ( p7_dir_data_nxt.qid == p6_dir_data_nxt.qid ) ) & ( p7_dir_v_nxt & ( p7_dir_data_nxt.qpri == p6_dir_data_nxt.qpri ) ) )
                       | ( ( p8_dir_v_nxt & ( p8_dir_data_nxt.qid == p6_dir_data_nxt.qid ) ) & ( p8_dir_v_nxt & ( p8_dir_data_nxt.qpri == p6_dir_data_nxt.qpri ) ) )
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


always_comb begin : L12
  //....................................................................................................
  // elastic FIFO storage

  residue_check_rx_sync_rop_dp_enq_r = '0 ;
  residue_check_rx_sync_rop_dp_enq_d = '0 ;
  residue_check_rx_sync_rop_dp_enq_e = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_flid_p = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_flid_d = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_flid_e = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_hist_list_p = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_hist_list_d = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_hist_list_e = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_p = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_d = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_e = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_p = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_d = '0 ;
  parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_e = '0 ;

  parity_check_rx_sync_lsp_dp_sch_dir_p = '0 ;
  parity_check_rx_sync_lsp_dp_sch_dir_d = '0 ;
  parity_check_rx_sync_lsp_dp_sch_dir_e = '0 ;

  parity_check_rx_sync_lsp_dp_sch_rorply_p = '0 ;
  parity_check_rx_sync_lsp_dp_sch_rorply_d = '0 ;
  parity_check_rx_sync_lsp_dp_sch_rorply_e = '0 ;

  fifo_rop_dp_enq_dir_push = '0 ;
  fifo_rop_dp_enq_dir_push_data = '0 ;
  fifo_rop_dp_enq_ro_push = '0 ;
  fifo_rop_dp_enq_ro_push_data = '0 ;
  fifo_lsp_dp_sch_dir_push = '0 ;
  fifo_lsp_dp_sch_dir_push_data = '0 ;
  fifo_lsp_dp_sch_rorply_push = '0 ;
  fifo_lsp_dp_sch_rorply_push_data = '0 ;

  error_badcmd0 = '0 ;

  //ROP_DP_ENQ interface
  rx_sync_rop_dp_enq_ready                           = ~ ( fifo_rop_dp_enq_dir_afull | fifo_rop_dp_enq_ro_afull ) ;

  if ( rx_sync_rop_dp_enq_v
     & rx_sync_rop_dp_enq_ready
     ) begin
    residue_check_rx_sync_rop_dp_enq_r               = rx_sync_rop_dp_enq_data.frag_list_info.cnt_residue ;
    residue_check_rx_sync_rop_dp_enq_d               = { 12'd0 , rx_sync_rop_dp_enq_data.frag_list_info.cnt } ;
    residue_check_rx_sync_rop_dp_enq_e               = ~ ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP ) ;
    parity_check_rx_sync_rop_dp_enq_data_flid_p      = rx_sync_rop_dp_enq_data.flid_parity ;
    parity_check_rx_sync_rop_dp_enq_data_flid_d      = rx_sync_rop_dp_enq_data.flid ;
    parity_check_rx_sync_rop_dp_enq_data_flid_e      = ( ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_NEW_HCW ) |
                                                         ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_HCW ) |
                                                         ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_LIST ) ) ;
    parity_check_rx_sync_rop_dp_enq_data_hist_list_p = rx_sync_rop_dp_enq_data.hist_list_info.parity ^ cfg_error_inj_f [ 0 ] ;
    parity_check_rx_sync_rop_dp_enq_data_hist_list_d = { rx_sync_rop_dp_enq_data.hist_list_info.qtype
                                                  , rx_sync_rop_dp_enq_data.hist_list_info.qpri
                                                  , rx_sync_rop_dp_enq_data.hist_list_info.qid
                                                  , rx_sync_rop_dp_enq_data.hist_list_info.qidix_msb
                                                  , rx_sync_rop_dp_enq_data.hist_list_info.qidix
                                                  , rx_sync_rop_dp_enq_data.hist_list_info.reord_mode
                                                  , rx_sync_rop_dp_enq_data.hist_list_info.reord_slot
                                                  , rx_sync_rop_dp_enq_data.hist_list_info.sn_fid
                                                  } ;
    parity_check_rx_sync_rop_dp_enq_data_hist_list_e = ~ ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP ) ;
    parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_p = rx_sync_rop_dp_enq_data.frag_list_info.hptr_parity ;
    parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_d = { 2'd0 , rx_sync_rop_dp_enq_data.frag_list_info.hptr } ;
    parity_check_rx_sync_rop_dp_enq_data_frag_list_hptr_e = ~ ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP ) ;
    parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_p = rx_sync_rop_dp_enq_data.frag_list_info.tptr_parity ;
    parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_d = { 2'd0 , rx_sync_rop_dp_enq_data.frag_list_info.tptr } ;
    parity_check_rx_sync_rop_dp_enq_data_frag_list_tptr_e = ~ ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP ) ;

  end

  if ( rx_sync_rop_dp_enq_v
     & rx_sync_rop_dp_enq_ready
     & ( ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_ILL0 )
       | ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_ILL5 )
       | ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_ILL6 )
       | ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_ILL7 )
       )
     ) begin
    error_badcmd0                               = 1'b1 ;
  end

  if ( rx_sync_rop_dp_enq_v
     & rx_sync_rop_dp_enq_ready
     & ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_NEW_HCW )
     ) begin
    fifo_rop_dp_enq_dir_push                    = 1'b1 ;
    fifo_rop_dp_enq_dir_push_data               = rx_sync_rop_dp_enq_data ;
  end

  if ( rx_sync_rop_dp_enq_v
     & rx_sync_rop_dp_enq_ready
     & ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_HCW )
     ) begin
    fifo_rop_dp_enq_ro_push                     = 1'b1 ;
    fifo_rop_dp_enq_ro_push_data                = rx_sync_rop_dp_enq_data ;
  end

  if ( rx_sync_rop_dp_enq_v
     & rx_sync_rop_dp_enq_ready
     & ( rx_sync_rop_dp_enq_data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_LIST )
     ) begin
    fifo_rop_dp_enq_ro_push                     = 1'b1 ;
    fifo_rop_dp_enq_ro_push_data                = rx_sync_rop_dp_enq_data ;
  end


  //LSP_DP_SCH dir interface
  rx_sync_lsp_dp_sch_dir_ready                       = ~ ( fifo_lsp_dp_sch_dir_afull ) ;

  if ( rx_sync_lsp_dp_sch_dir_v
     & rx_sync_lsp_dp_sch_dir_ready
     ) begin
    parity_check_rx_sync_lsp_dp_sch_dir_p            = rx_sync_lsp_dp_sch_dir_data.parity ^ cfg_error_inj_f [ 1 ] ;
    parity_check_rx_sync_lsp_dp_sch_dir_d            = { rx_sync_lsp_dp_sch_dir_data.cq
                                                  , rx_sync_lsp_dp_sch_dir_data.qid
                                                  , rx_sync_lsp_dp_sch_dir_data.qidix
                                                  } ;
    parity_check_rx_sync_lsp_dp_sch_dir_e            = 1'd1 ;
  end

  if ( rx_sync_lsp_dp_sch_dir_v
     & rx_sync_lsp_dp_sch_dir_ready
     ) begin
    fifo_lsp_dp_sch_dir_push                    = 1'b1 ;
    fifo_lsp_dp_sch_dir_push_data               = rx_sync_lsp_dp_sch_dir_data ;
  end

  //LSP_DP_SCH dir interface
  rx_sync_lsp_dp_sch_rorply_ready                    = ~ ( fifo_lsp_dp_sch_rorply_afull ) ;

  if ( rx_sync_lsp_dp_sch_rorply_v
     & rx_sync_lsp_dp_sch_rorply_ready
     ) begin
    parity_check_rx_sync_lsp_dp_sch_rorply_p         = rx_sync_lsp_dp_sch_rorply_data.parity ^ cfg_error_inj_f [ 2 ] ;
    parity_check_rx_sync_lsp_dp_sch_rorply_d         = rx_sync_lsp_dp_sch_rorply_data.qid ;
    parity_check_rx_sync_lsp_dp_sch_rorply_e         = 1'b1 ;
  end

  if ( rx_sync_lsp_dp_sch_rorply_v
     & rx_sync_lsp_dp_sch_rorply_ready
     ) begin
    fifo_lsp_dp_sch_rorply_push                 = 1'b1 ;
    fifo_lsp_dp_sch_rorply_push_data            = rx_sync_lsp_dp_sch_rorply_data ;
  end

end

always_comb begin : L13
  fifo_rop_dp_enq_dir_pop = '0 ;
  fifo_lsp_dp_sch_dir_pop = '0 ;

  fifo_rop_dp_enq_ro_pop = '0 ;
  fifo_lsp_dp_sch_rorply_pop = '0 ;

  parity_gen_dir_rop_dp_enq_data_hist_list_d = '0 ;
  //....................................................................................................
  // p0 dir pipeline
  //  counter-0

  p0_dir_ctrl = '0 ;
  p0_dir_v_nxt = '0 ;
  p0_dir_data_nxt = p0_dir_data_f ;
  rmw_dir_cnt_p0_hold = '0 ;

fifo_dp_lsp_enq_dir_inc = '0 ;
fifo_dp_dqed_dir_inc = '0 ;

  rmw_dir_cnt_p0_v_nxt = '0 ;
  rmw_dir_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_dir_cnt_p0_addr_nxt = '0 ;
  rmw_dir_cnt_p0_write_data_nxt_nc = '0 ;

  arb_dir_reqs = '0 ;
  arb_dir_update = '0 ;

  p0_dir_ctrl.hold                              = ( p0_dir_v_f & p1_dir_ctrl.hold ) ;
  p0_dir_ctrl.enable                            = ( arb_dir_winner_v ) ;
  rmw_dir_cnt_p0_hold = p0_dir_ctrl.hold ;

  arb_dir_reqs [ 0 ]                               = ( ( ~ cfg_req_idlepipe ) 
                                                  & ( ~ p0_dir_ctrl.hold )
                                                  & ( ~ fifo_rop_dp_enq_dir_empty )
                                                  & ( fifo_dp_lsp_enq_dir_cnt_f < cfg_control8_f [ 4 : 0 ] )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_50 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_33 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p1_dir_v_f &  ~ p1_rofrag_v_f & ~ p1_replay_v_f ) : 1'b1 )
                                                  ) ;
  arb_dir_reqs [ 1 ]                               = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_dir_ctrl.hold )
                                                  & ( ~ fifo_lsp_dp_sch_dir_empty )
                                                  & ( fifo_dp_dqed_dir_cnt_f < cfg_control8_f [ 9 : 5 ] )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_50 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_33 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p1_dir_v_f &  ~ p1_rofrag_v_f & ~ p1_replay_v_f ) : 1'b1 )
                                                  ) ;

  if ( p0_dir_ctrl.enable | p0_dir_ctrl.hold ) begin
    p0_dir_v_nxt                                = 1'b1 ;
  end
  if ( p0_dir_ctrl.enable ) begin

    if ( ( arb_dir_winner_v ) & ( ~ arb_dir_winner ) ) begin
      arb_dir_update = 1'b1 ;
      //process the counter based on enqueue (increment)
      fifo_dp_lsp_enq_dir_inc                   = 1'b1 ;
      p0_dir_data_nxt.cmd                       = HQM_DP_CMD_ENQ ;
      if ( fifo_rop_dp_enq_dir_pop_data.cmd == ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP ) begin
        p0_dir_data_nxt.cmd                     = HQM_DP_CMD_NOOP ;
      end
      parity_gen_dir_rop_dp_enq_data_hist_list_d = { fifo_rop_dp_enq_dir_pop_data.hist_list_info.qtype
                                                  , fifo_rop_dp_enq_dir_pop_data.hist_list_info.qpri
                                                  , fifo_rop_dp_enq_dir_pop_data.hist_list_info.qidix_msb
                                                  , fifo_rop_dp_enq_dir_pop_data.hist_list_info.qidix
                                                  , fifo_rop_dp_enq_dir_pop_data.hist_list_info.reord_mode
                                                  , fifo_rop_dp_enq_dir_pop_data.hist_list_info.reord_slot
                                                  , fifo_rop_dp_enq_dir_pop_data.hist_list_info.sn_fid
                                                  } ;

      p0_dir_data_nxt.cq                        = '0 ;
      p0_dir_data_nxt.qid                       = fifo_rop_dp_enq_dir_pop_data.hist_list_info.qid ;
      p0_dir_data_nxt.qidix                     = '0 ;
      p0_dir_data_nxt.parity                    = fifo_rop_dp_enq_dir_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 3 ] ^ parity_gen_dir_rop_dp_enq_data_hist_list_p ;
      p0_dir_data_nxt.qpri                      = { 1'b0 , fifo_rop_dp_enq_dir_pop_data.hist_list_info.qpri [ 2 : 1 ] } ;
      p0_dir_data_nxt.empty                     = '0 ;
      p0_dir_data_nxt.hp                        = '0 ;
      p0_dir_data_nxt.hp_parity                 = '0 ;
      p0_dir_data_nxt.tp                        = '0 ;
      p0_dir_data_nxt.tp_parity                 = '0 ;
      p0_dir_data_nxt.flid                      = fifo_rop_dp_enq_dir_pop_data.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      p0_dir_data_nxt.flid_parity               = fifo_rop_dp_enq_dir_pop_data.flid_parity ;
      p0_dir_data_nxt.error                     = '0 ;
      p0_dir_data_nxt.frag_cnt                  = '0 ;
      p0_dir_data_nxt.frag_residue              = '0 ;
      p0_dir_data_nxt.hqm_core_flags            = '0 ;

      if ( fifo_rop_dp_enq_dir_pop_data.cmd != ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP ) begin
        rmw_dir_cnt_p0_v_nxt                    = 1'b1 ;
        rmw_dir_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_RMW ;
        rmw_dir_cnt_p0_addr_nxt                 = fifo_rop_dp_enq_dir_pop_data.hist_list_info.qid ;
        rmw_dir_cnt_p0_write_data_nxt_nc           = '0 ;
      end
      fifo_rop_dp_enq_dir_pop                   = 1'b1 ;
    end

    if ( ( arb_dir_winner_v ) & ( arb_dir_winner ) ) begin
      arb_dir_update = 1'b1 ;
      //process the counter based on dequeue (decrement)
      fifo_dp_dqed_dir_inc                      = 1'b1 ;
      p0_dir_data_nxt.cmd                       = HQM_DP_CMD_DEQ ;
      p0_dir_data_nxt.cq                        = fifo_lsp_dp_sch_dir_pop_data.cq ;
      p0_dir_data_nxt.qid                       = fifo_lsp_dp_sch_dir_pop_data.qid ;
      p0_dir_data_nxt.qidix                     = fifo_lsp_dp_sch_dir_pop_data.qidix ;
      p0_dir_data_nxt.parity                    = fifo_lsp_dp_sch_dir_pop_data.parity ^ cfg_error_inj_f [ 4 ] ;
      p0_dir_data_nxt.qpri                      = '0 ;
      p0_dir_data_nxt.empty                     = '0 ;
      p0_dir_data_nxt.hp                        = '0 ;
      p0_dir_data_nxt.hp_parity                 = '0 ;
      p0_dir_data_nxt.tp                        = '0 ;
      p0_dir_data_nxt.tp_parity                 = '0 ;
      p0_dir_data_nxt.flid                      = '0 ;
      p0_dir_data_nxt.flid_parity               = '0 ;
      p0_dir_data_nxt.error                     = '0 ;
      p0_dir_data_nxt.frag_cnt                  = '0 ;
      p0_dir_data_nxt.frag_residue              = '0 ;
      p0_dir_data_nxt.hqm_core_flags            = fifo_lsp_dp_sch_dir_pop_data.hqm_core_flags ;

      rmw_dir_cnt_p0_v_nxt                      = 1'b1 ;
      rmw_dir_cnt_p0_rw_nxt                     = HQM_AW_RMWPIPE_RMW ;
      rmw_dir_cnt_p0_addr_nxt                   = fifo_lsp_dp_sch_dir_pop_data.qid ;
      rmw_dir_cnt_p0_write_data_nxt_nc             = '0 ;

      fifo_lsp_dp_sch_dir_pop                   = 1'd1 ;
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

fifo_dp_lsp_enq_rorply_inc = '0 ;
fifo_dp_dqed_rorply_inc = '0 ;

  rmw_rofrag_cnt_p0_v_nxt = '0 ;
  rmw_rofrag_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_rofrag_cnt_p0_addr_nxt = '0 ;
  rmw_rofrag_cnt_p0_write_data_nxt_nc = '0 ;

  rmw_replay_cnt_p0_v_nxt = '0 ;
  rmw_replay_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_replay_cnt_p0_addr_nxt = '0 ;
  rmw_replay_cnt_p0_write_data_nxt_nc = '0 ;

  fifo_dp_lsp_enq_rorply_inc = '0 ;
  fifo_dp_dqed_rorply_inc = '0 ;

      parity_gen_rofrag_rop_dp_enq_data_hist_list_d = { fifo_rop_dp_enq_ro_pop_data.hist_list_info.qtype
                                                  , fifo_rop_dp_enq_ro_pop_data.hist_list_info.qpri
                                                  , fifo_rop_dp_enq_ro_pop_data.hist_list_info.qidix_msb
                                                  , fifo_rop_dp_enq_ro_pop_data.hist_list_info.qidix
                                                  , fifo_rop_dp_enq_ro_pop_data.hist_list_info.reord_mode
                                                  , fifo_rop_dp_enq_ro_pop_data.hist_list_info.reord_slot
                                                  , fifo_rop_dp_enq_ro_pop_data.hist_list_info.sn_fid
                                                  } ;

  arb_ro_reqs = '0 ;
  arb_ro_update = '0 ;

  p0_rofrag_ctrl.hold                           = ( p0_rofrag_v_f & p1_rofrag_ctrl.hold )
                                                | ( p0_replay_v_f & p1_replay_ctrl.hold ) ;
  p0_rofrag_ctrl.enable                         = ( arb_ro_winner_v ) ;
  rmw_rofrag_cnt_p0_hold = p0_rofrag_ctrl.hold ;

  p0_replay_ctrl.hold                           = ( p0_rofrag_v_f & p1_rofrag_ctrl.hold )
                                                | ( p0_replay_v_f & p1_replay_ctrl.hold ) ;
  p0_replay_ctrl.enable                         = ( arb_ro_winner_v ) ;
  rmw_replay_cnt_p0_hold = p0_replay_ctrl.hold ;

  arb_ro_reqs [ HQM_DP_RO_ENQ_FRAG ]            = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_rofrag_ctrl.hold )
                                                  & ( ~ p0_replay_ctrl.hold )
                                                  & ( ( ~ fifo_rop_dp_enq_ro_empty ) )
                                                  & ( ( fifo_rop_dp_enq_ro_pop_data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_HCW ) )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_50 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_33 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p1_dir_v_f &  ~ p1_rofrag_v_f & ~ p1_replay_v_f ) : 1'b1 )
                                                  ) ;
  arb_ro_reqs [ HQM_DP_RO_ENQ_RORPLY ]          = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_rofrag_ctrl.hold )
                                                  & ( ~ p0_replay_ctrl.hold )
                                                  & ( ( ~ fifo_rop_dp_enq_ro_empty ) )
                                                  & ( ( fifo_rop_dp_enq_ro_pop_data.cmd == ROP_DP_ENQ_DIR_ENQ_REORDER_LIST ) )
                                                  & ( fifo_dp_lsp_enq_rorply_cnt_f < cfg_control8_f [ 14 : 10 ] )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_50 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_33 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p1_dir_v_f &  ~ p1_rofrag_v_f & ~ p1_replay_v_f ) : 1'b1 )
                                                  ) ;
  arb_ro_reqs [ HQM_DP_RO_SCH_RORPLY ]          = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_rofrag_ctrl.hold )
                                                  & ( ~ p0_replay_ctrl.hold )
                                                  & ( ( ~ fifo_lsp_dp_sch_rorply_empty ) )
                                                  & ( fifo_dp_dqed_rorply_cnt_f < cfg_control8_f [ 19 : 15 ] )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_SIM ] ? ( cfg_unit_idle_f.pipe_idle ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_50 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f ) : 1'b1 )
                                                  & ( cfg_control0_f [ HQM_DP_CHICKEN_33 ] ? ( ~ p0_dir_v_f &  ~ p0_rofrag_v_f & ~ p0_replay_v_f & ~ p1_dir_v_f &  ~ p1_rofrag_v_f & ~ p1_replay_v_f ) : 1'b1 )
                                                  ) ;

  if ( p0_rofrag_ctrl.enable | p0_rofrag_ctrl.hold ) begin
    p0_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p0_replay_ctrl.enable | p0_replay_ctrl.hold ) begin
    p0_replay_v_nxt                             = 1'b1 ;
  end

  if ( p0_rofrag_ctrl.enable | p0_replay_ctrl.enable ) begin
    if ( ( arb_ro_winner_v ) & ( arb_ro_winner == HQM_DP_RO_ENQ_FRAG ) ) begin
      arb_ro_update = 1'b1 ;

      p0_rofrag_data_nxt.cmd                    = HQM_DP_CMD_ENQ ;
      p0_rofrag_data_nxt.cq                     = { fifo_rop_dp_enq_ro_pop_data.cq [ 7 : 1 ] , ( fifo_rop_dp_enq_ro_pop_data.cq [ 0 ] | fifo_rop_dp_enq_ro_pop_data.hist_list_info.qidix_msb ) }  ;
      p0_rofrag_data_nxt.qid                    = fifo_rop_dp_enq_ro_pop_data.hist_list_info.qid ;
      p0_rofrag_data_nxt.qidix                  = fifo_rop_dp_enq_ro_pop_data.hist_list_info.qidix ;
if ( cfg_control0_f [ HQM_DP_CHICKEN_REORDER_QID ] ) begin
      p0_rofrag_data_nxt.qid                    = '0 ;
end
      p0_rofrag_data_nxt.parity                 = fifo_rop_dp_enq_ro_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 5 ] ;
      p0_rofrag_data_nxt.qpri                   = '0 ;
      p0_rofrag_data_nxt.empty                  = '0 ;
      p0_rofrag_data_nxt.hp                     = '0 ;
      p0_rofrag_data_nxt.tp                     = '0 ;
      p0_rofrag_data_nxt.flid                   = fifo_rop_dp_enq_ro_pop_data.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      p0_rofrag_data_nxt.flid_parity            = fifo_rop_dp_enq_ro_pop_data.flid_parity ;
      p0_rofrag_data_nxt.hp_parity              = '0 ;
      p0_rofrag_data_nxt.tp_parity              = '0 ;
      p0_rofrag_data_nxt.frag_cnt               = '0 ;
      p0_rofrag_data_nxt.frag_residue           = '0 ;
      p0_rofrag_data_nxt.error                  = '0 ;
      p0_rofrag_data_nxt.hqm_core_flags         = '0 ;

      p0_replay_data_nxt.cmd                    = HQM_DP_CMD_NOOP ;
      p0_replay_data_nxt.cq                     = '0 ;
      p0_replay_data_nxt.qid                    = '0 ;
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

      fifo_rop_dp_enq_ro_pop                    = 1'd1 ;
    end

    if ( ( arb_ro_winner_v ) & ( arb_ro_winner == HQM_DP_RO_ENQ_RORPLY ) ) begin
      arb_ro_update = 1'b1 ;

      p0_rofrag_data_nxt.cmd                    = HQM_DP_CMD_ENQ_RORPLY ;
      p0_rofrag_data_nxt.cq                     = { fifo_rop_dp_enq_ro_pop_data.cq [ 7 : 1 ] , ( fifo_rop_dp_enq_ro_pop_data.cq [ 0 ] | fifo_rop_dp_enq_ro_pop_data.hist_list_info.qidix_msb ) }  ;

      p0_rofrag_data_nxt.qid                    = fifo_rop_dp_enq_ro_pop_data.hist_list_info.qid ;
      p0_rofrag_data_nxt.qidix                  = fifo_rop_dp_enq_ro_pop_data.hist_list_info.qidix ;
if ( cfg_control0_f [ HQM_DP_CHICKEN_REORDER_QID ] ) begin
      p0_rofrag_data_nxt.qid                    = '0 ;
end
      p0_rofrag_data_nxt.parity                 = fifo_rop_dp_enq_ro_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 6 ] ^ parity_gen_rofrag_rop_dp_enq_data_hist_list_p ;
      p0_rofrag_data_nxt.qpri                   = { 1'b0 , fifo_rop_dp_enq_ro_pop_data.hist_list_info.qpri [ 2 : 1 ] } ;
      p0_rofrag_data_nxt.empty                  = '0 ;
      p0_rofrag_data_nxt.hp                     = fifo_rop_dp_enq_ro_pop_data.frag_list_info.hptr [ 13 : 0 ] ;
      p0_rofrag_data_nxt.tp                     = fifo_rop_dp_enq_ro_pop_data.frag_list_info.tptr [ 13 : 0 ] ;
      p0_rofrag_data_nxt.flid                   = '0 ;
      p0_rofrag_data_nxt.flid_parity            = '0 ;
      p0_rofrag_data_nxt.hp_parity              = fifo_rop_dp_enq_ro_pop_data.frag_list_info.hptr_parity ;
      p0_rofrag_data_nxt.tp_parity              = fifo_rop_dp_enq_ro_pop_data.frag_list_info.tptr_parity ;
      p0_rofrag_data_nxt.frag_cnt               = { 11'd0 , fifo_rop_dp_enq_ro_pop_data.frag_list_info.cnt } ;
      p0_rofrag_data_nxt.frag_residue           = fifo_rop_dp_enq_ro_pop_data.frag_list_info.cnt_residue ;
      p0_rofrag_data_nxt.error                  = '0 ;
      p0_rofrag_data_nxt.hqm_core_flags         = '0 ;

      p0_replay_data_nxt.cmd                    = HQM_DP_CMD_ENQ_RORPLY ;
      p0_replay_data_nxt.cq                     = fifo_rop_dp_enq_ro_pop_data.cq ;
      p0_replay_data_nxt.qid                    = fifo_rop_dp_enq_ro_pop_data.hist_list_info.qid ;
      p0_replay_data_nxt.qidix                  = fifo_rop_dp_enq_ro_pop_data.hist_list_info.qidix ;
if ( cfg_control0_f [ HQM_DP_CHICKEN_REORDER_QID ] ) begin
      p0_replay_data_nxt.qid                    = '0 ;
end
      p0_replay_data_nxt.parity                 = fifo_rop_dp_enq_ro_pop_data.hist_list_info.parity ^ cfg_error_inj_f [ 7 ] ^ parity_gen_rofrag_rop_dp_enq_data_hist_list_p ;
      p0_replay_data_nxt.qpri                   = { 1'b0 , fifo_rop_dp_enq_ro_pop_data.hist_list_info.qpri [ 2 : 1 ] } ;
      p0_replay_data_nxt.empty                  = '0 ;
      p0_replay_data_nxt.hp                     = fifo_rop_dp_enq_ro_pop_data.frag_list_info.hptr [ 13 : 0 ] ;
      p0_replay_data_nxt.tp                     = fifo_rop_dp_enq_ro_pop_data.frag_list_info.tptr [ 13 : 0 ] ;
      p0_replay_data_nxt.flid                   = '0 ;
      p0_replay_data_nxt.flid_parity            = '0 ;
      p0_replay_data_nxt.hp_parity              = fifo_rop_dp_enq_ro_pop_data.frag_list_info.hptr_parity ;
      p0_replay_data_nxt.tp_parity              = fifo_rop_dp_enq_ro_pop_data.frag_list_info.tptr_parity ;
      p0_replay_data_nxt.frag_cnt               = { 11'd0 , fifo_rop_dp_enq_ro_pop_data.frag_list_info.cnt } ;
      p0_replay_data_nxt.frag_residue           = fifo_rop_dp_enq_ro_pop_data.frag_list_info.cnt_residue ;
      p0_replay_data_nxt.error                  = '0 ;
      p0_replay_data_nxt.hqm_core_flags         = '0 ;

      rmw_rofrag_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_rofrag_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
      rmw_rofrag_cnt_p0_addr_nxt                = { p0_rofrag_data_nxt.cq [ 5 : 0 ] , p0_rofrag_data_nxt.qidix } ;
      rmw_rofrag_cnt_p0_write_data_nxt_nc          = '0 ;

      rmw_replay_cnt_p0_v_nxt                   = 1'b1 ;
      rmw_replay_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
      rmw_replay_cnt_p0_addr_nxt                = { p0_replay_data_nxt.qid } ;
      rmw_replay_cnt_p0_write_data_nxt_nc          = '0 ;

      fifo_dp_lsp_enq_rorply_inc                = 1'b1 ;

      fifo_rop_dp_enq_ro_pop                = 1'b1 ;
    end
    if ( ( arb_ro_winner_v ) & ( arb_ro_winner == HQM_DP_RO_SCH_RORPLY ) ) begin
      arb_ro_update = 1'b1 ;

      p0_rofrag_data_nxt.cmd                    = HQM_DP_CMD_NOOP ;
      p0_rofrag_data_nxt.cq                     = '0 ;
      p0_rofrag_data_nxt.qid                    = '0 ;
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

      p0_replay_data_nxt.cmd                    = HQM_DP_CMD_DEQ ;
      p0_replay_data_nxt.cq                     = '0 ;
      p0_replay_data_nxt.qid                    = fifo_lsp_dp_sch_rorply_pop_data.qid ;
      p0_replay_data_nxt.qidix                  = '0 ;
      p0_replay_data_nxt.parity                 = fifo_lsp_dp_sch_rorply_pop_data.parity ^ cfg_error_inj_f [ 8 ] ;
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

      fifo_dp_dqed_rorply_inc                   = 1'b1 ;

      fifo_lsp_dp_sch_rorply_pop                = 1'b1 ;
    end

  end

end

always_comb begin : L14
  //....................................................................................................
  // p1 dir pipeline
  //  counter-1
  p1_dir_ctrl = '0 ;
  p1_dir_v_nxt = '0 ;
  p1_dir_data_nxt = p1_dir_data_f ;
  rmw_dir_cnt_p1_hold = '0 ;

  p1_dir_ctrl.hold                              = ( p1_dir_v_f & p2_dir_ctrl.hold ) ;
  p1_dir_ctrl.enable                            = ( p0_dir_v_f & ~ p1_dir_ctrl.hold ) ;
  rmw_dir_cnt_p1_hold = p1_dir_ctrl.hold ;
  if ( p1_dir_ctrl.enable | p1_dir_ctrl.hold ) begin
    p1_dir_v_nxt                                = 1'b1 ;
  end
  if ( p1_dir_ctrl.enable ) begin
    p1_dir_data_nxt                             = p0_dir_data_f ;
  end


  //....................................................................................................
  // p1 ordered pipeline
  //  counter-1

  // rofrag
  p1_rofrag_ctrl = '0 ;
  p1_rofrag_v_nxt = '0 ;
  p1_rofrag_data_nxt = p1_rofrag_data_f ;
  rmw_rofrag_cnt_p1_hold = '0 ;

  p1_rofrag_ctrl.hold                              = ( p1_rofrag_v_f & p2_rofrag_ctrl.hold ) ;
  p1_rofrag_ctrl.enable                            = ( p0_rofrag_v_f & ~ p1_rofrag_ctrl.hold ) ;
  rmw_rofrag_cnt_p1_hold = p1_rofrag_ctrl.hold ;
  if ( p1_rofrag_ctrl.enable | p1_rofrag_ctrl.hold ) begin
    p1_rofrag_v_nxt                                = 1'b1 ;
  end
  if ( p1_rofrag_ctrl.enable ) begin
    p1_rofrag_data_nxt                             = p0_rofrag_data_f ;
  end


  // replay
  p1_replay_ctrl = '0 ;
  p1_replay_v_nxt = '0 ;
  p1_replay_data_nxt = p1_replay_data_f ;
  rmw_replay_cnt_p1_hold = '0 ;

  p1_replay_ctrl.hold                              = ( p1_replay_v_f & p2_replay_ctrl.hold ) ;
  p1_replay_ctrl.enable                            = ( p0_replay_v_f & ~ p1_replay_ctrl.hold ) ;
  rmw_replay_cnt_p1_hold = p1_replay_ctrl.hold ;
  if ( p1_replay_ctrl.enable | p1_replay_ctrl.hold ) begin
    p1_replay_v_nxt                                = 1'b1 ;
  end
  if ( p1_replay_ctrl.enable ) begin
    p1_replay_data_nxt                             = p0_replay_data_f ;
  end


end

always_comb begin : L15
  //....................................................................................................
  // p2 dir pipeline
  //  counter-2
  p2_dir_ctrl = '0 ;
  p2_dir_v_nxt = '0 ;
  p2_dir_data_nxt = p2_dir_data_f ;
  rmw_dir_cnt_p2_hold = '0 ;

  p2_dir_ctrl.hold                              = ( p2_dir_v_f & p3_dir_ctrl.hold ) ;
  p2_dir_ctrl.enable                            = ( p1_dir_v_f & ~ p2_dir_ctrl.hold ) ;
  rmw_dir_cnt_p2_hold = p2_dir_ctrl.hold ;
  if ( p2_dir_ctrl.enable | p2_dir_ctrl.hold ) begin
    p2_dir_v_nxt                                = 1'b1 ;
  end
  if ( p2_dir_ctrl.enable ) begin
    p2_dir_data_nxt                             = p1_dir_data_f ;
  end


  //....................................................................................................
  // p2 ordered pipeline
  //  counter-2

  // rofrag 
  p2_rofrag_ctrl = '0 ;
  p2_rofrag_v_nxt = '0 ;
  p2_rofrag_data_nxt = p2_rofrag_data_f ;
  rmw_rofrag_cnt_p2_hold = '0 ;

  p2_rofrag_ctrl.hold                              = ( p2_rofrag_v_f & p3_rofrag_ctrl.hold ) ;
  p2_rofrag_ctrl.enable                            = ( p1_rofrag_v_f & ~ p2_rofrag_ctrl.hold ) ;
  rmw_rofrag_cnt_p2_hold = p2_rofrag_ctrl.hold ;
  if ( p2_rofrag_ctrl.enable | p2_rofrag_ctrl.hold ) begin
    p2_rofrag_v_nxt                                = 1'b1 ;
  end
  if ( p2_rofrag_ctrl.enable ) begin
    p2_rofrag_data_nxt                             = p1_rofrag_data_f ;
  end


  // replay 
  p2_replay_ctrl = '0 ;
  p2_replay_v_nxt = '0 ;
  p2_replay_data_nxt = p2_replay_data_f ;
  rmw_replay_cnt_p2_hold = '0 ;

  p2_replay_ctrl.hold                              = ( p2_replay_v_f & p3_replay_ctrl.hold ) ;
  p2_replay_ctrl.enable                            = ( p1_replay_v_f & ~ p2_replay_ctrl.hold ) ;
  rmw_replay_cnt_p2_hold = p2_replay_ctrl.hold ;

  if ( p2_replay_ctrl.enable | p2_replay_ctrl.hold ) begin
    p2_replay_v_nxt                                = 1'b1 ;
  end
  if ( p2_replay_ctrl.enable ) begin
    p2_replay_data_nxt                             = p1_replay_data_f ;
  end


end


always_comb begin : L16
  //....................................................................................................
  // p3 dir pipeline
  //  ll-0
  p3_dir_ctrl = '0 ;
  p3_dir_v_nxt = '0 ;
  p3_dir_data_nxt = p3_dir_data_f ;
  rmw_dir_cnt_p3_hold = '0 ;

  rmw_dir_hp_p0_hold = '0 ;
  rmw_dir_tp_p0_hold = '0 ;

  residue_add_dir_cnt_a = '0 ;
  residue_add_dir_cnt_b = '0 ;
  residue_sub_dir_cnt_a = '0 ;
  residue_sub_dir_cnt_b = '0 ;
  residue_check_dir_cnt_r_nxt = residue_check_dir_cnt_r_f ;
  residue_check_dir_cnt_d_nxt = residue_check_dir_cnt_d_f ;
  residue_check_dir_cnt_e_nxt = '0 ;

  rmw_dir_cnt_p3_bypsel_nxt = '0 ;
  rmw_dir_cnt_p3_bypdata_nxt = rmw_dir_cnt_p2_data_f ;

  rmw_dir_hp_p0_v_nxt = '0 ;
  rmw_dir_hp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_dir_hp_p0_addr_nxt = '0 ;
  rmw_dir_hp_p0_write_data_nxt = '0 ;

  rmw_dir_tp_p0_v_nxt = '0 ;
  rmw_dir_tp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_dir_tp_p0_addr_nxt = '0 ;
  rmw_dir_tp_p0_write_data_nxt = '0 ;

  arb_dir_cnt_reqs = '0 ;
      for ( int i = 0 ; i < HQM_DP_NUM_PRI ; i = i + 1 ) begin
        arb_dir_cnt_reqs [ i ]                     = ( | rmw_dir_cnt_p2_data_f [ ( i * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ;
      end

  error_dir_nopri = '0 ;
  error_dir_of = '0 ;

  p3_dir_ctrl.hold                              = ( p3_dir_v_f & p4_dir_ctrl.hold ) ;
  p3_dir_ctrl.enable                            = ( p2_dir_v_f & ~ p3_dir_ctrl.hold ) ;
  rmw_dir_hp_p0_hold = p3_dir_ctrl.hold ;
  rmw_dir_tp_p0_hold = p3_dir_ctrl.hold ;
  if ( p3_dir_ctrl.enable | p3_dir_ctrl.hold ) begin
    p3_dir_v_nxt                                = 1'b1 ;
  end
  if ( p3_dir_ctrl.enable ) begin
    p3_dir_data_nxt                             = p2_dir_data_f ;

    //process the counter based on enqueue (increment)
    if ( p3_dir_data_nxt.cmd == HQM_DP_CMD_ENQ ) begin
      error_dir_of                              = ( rmw_dir_cnt_p2_data_f [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == { HQM_DP_CNTB2 { 1'b1 } } ) ; 
      p3_dir_data_nxt.error                     = error_dir_of ;

      residue_check_dir_cnt_r_nxt               = rmw_dir_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_dir_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_check_dir_cnt_d_nxt               = rmw_dir_cnt_p2_data_f [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ; 
      residue_check_dir_cnt_e_nxt               = 1'b1 ;

      if ( ~ p3_dir_data_nxt.error ) begin
      rmw_dir_cnt_p3_bypsel_nxt                 = 1'b1 ;
      end
      rmw_dir_cnt_p3_bypdata_nxt [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] = rmw_dir_cnt_p2_data_f [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] + { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

      residue_add_dir_cnt_a                     = rmw_dir_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_dir_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_add_dir_cnt_b                     = 2'd1 ;
      rmw_dir_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_dir_data_nxt.qpri * 2 ) ) +: 2 ] = residue_add_dir_cnt_r ; 

      p3_dir_data_nxt.empty                     = ( rmw_dir_cnt_p2_data_f [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ; 
    end
    //process the counter based on dequeue (decrement)
    if ( p3_dir_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin

      if ( arb_dir_cnt_winner_v ) begin
        p3_dir_data_nxt.qpri                    = arb_dir_cnt_winner ;

        residue_check_dir_cnt_r_nxt             = rmw_dir_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_dir_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        residue_check_dir_cnt_d_nxt             = rmw_dir_cnt_p2_data_f [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ; 
        residue_check_dir_cnt_e_nxt             = 1'b1 ;

        rmw_dir_cnt_p3_bypsel_nxt               = 1'b1 ;
        rmw_dir_cnt_p3_bypdata_nxt [ ( arb_dir_cnt_winner * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] = rmw_dir_cnt_p2_data_f [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] - { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

        residue_sub_dir_cnt_a                   = 2'd1 ;
        residue_sub_dir_cnt_b                   = rmw_dir_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_dir_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        rmw_dir_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_dir_data_nxt.qpri * 2 ) ) +: 2 ] = residue_sub_dir_cnt_r ; 

        p3_dir_data_nxt.empty                   = ( rmw_dir_cnt_p2_data_f [ ( p3_dir_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ) ; 
      end
      else begin
        error_dir_nopri                         = 1'b1 ;
        p3_dir_data_nxt.error                   = 1'b1 ;
      end
    end

   if ( p3_dir_data_nxt.cmd != HQM_DP_CMD_NOOP ) begin
      rmw_dir_hp_p0_v_nxt                       = 1'b1 ;
      rmw_dir_hp_p0_rw_nxt                      = HQM_AW_RMWPIPE_READ ;
      rmw_dir_hp_p0_addr_nxt                    = { 1'b0 , p3_dir_data_nxt.qid , p3_dir_data_nxt.qpri [ 1 : 0 ] } ;

      rmw_dir_tp_p0_v_nxt                       = 1'b1 ;
      rmw_dir_tp_p0_rw_nxt                      = HQM_AW_RMWPIPE_READ ;
      rmw_dir_tp_p0_addr_nxt                    = { 1'b0 , p3_dir_data_nxt.qid , p3_dir_data_nxt.qpri [ 1 : 0 ] } ;
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
  residue_check_rofrag_cnt_r_nxt = residue_check_rofrag_cnt_r_f ;
  residue_check_rofrag_cnt_d_nxt = residue_check_rofrag_cnt_d_f ;
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

    if ( p3_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ ) begin
      error_rofrag_of                              = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_DP_CNTB2 ] == { HQM_DP_CNTB2 { 1'b1 } } ) ;
      p3_rofrag_data_nxt.error                     = error_rofrag_of ;

      residue_check_rofrag_cnt_r_nxt               = rmw_rofrag_cnt_p2_data_f [ ( HQM_DP_CNTB2 ) +: 2 ] ;
      residue_check_rofrag_cnt_d_nxt               = rmw_rofrag_cnt_p2_data_f [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ;
      residue_check_rofrag_cnt_e_nxt               = 1'b1 ;

      if ( ~ p3_rofrag_data_nxt.error ) begin
      rmw_rofrag_cnt_p3_bypsel_nxt                 = 1'b1 ;
      end
      rmw_rofrag_cnt_p3_bypdata_nxt [ 0 +: HQM_DP_CNTB2 ]  = rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_DP_CNTB2 ] + { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ;

      residue_add_rofrag_cnt_a                     = rmw_rofrag_cnt_p2_data_f [ ( HQM_DP_CNTB2 ) +: 2 ] ;
      residue_add_rofrag_cnt_b                     = 2'd1 ;
      rmw_rofrag_cnt_p3_bypdata_nxt [ HQM_DP_CNTB2 +: 2 ]  = residue_add_rofrag_cnt_r ;

      p3_rofrag_data_nxt.empty                     = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_DP_CNTB2 ] == { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ;

    end

    if ( p3_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) begin
      error_rofrag_of                              = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_DP_CNTB2 ] < { p3_rofrag_data_nxt.frag_cnt } ) ;
      p3_rofrag_data_nxt.error                     = error_rofrag_of ;

      residue_check_rofrag_cnt_r_nxt               = rmw_rofrag_cnt_p2_data_f [ ( HQM_DP_CNTB2 ) +: 2 ] ;
      residue_check_rofrag_cnt_d_nxt               = rmw_rofrag_cnt_p2_data_f [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ;
      residue_check_rofrag_cnt_e_nxt               = 1'b1 ;

      if ( ~ p3_rofrag_data_nxt.error ) begin
      rmw_rofrag_cnt_p3_bypsel_nxt                 = 1'b1 ;
      end
      rmw_rofrag_cnt_p3_bypdata_nxt [ 0 +: HQM_DP_CNTB2 ]  = rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_DP_CNTB2 ] - { p3_rofrag_data_nxt.frag_cnt } ;

      residue_sub_rofrag_cnt_a                     = p3_rofrag_data_nxt.frag_residue ;
      residue_sub_rofrag_cnt_b                     = rmw_rofrag_cnt_p2_data_f [ ( HQM_DP_CNTB2 ) +: 2 ] ;
      rmw_rofrag_cnt_p3_bypdata_nxt [ HQM_DP_CNTB2 +: 2 ]  = residue_sub_rofrag_cnt_r ;

      p3_rofrag_data_nxt.empty                     = ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_DP_CNTB2 ] == { 1'd0 , p3_rofrag_data_nxt.frag_cnt } )
                                                   | ( rmw_rofrag_cnt_p2_data_f [ 0 +: HQM_DP_CNTB2 ] == ( { 1'd0 , p3_rofrag_data_nxt.frag_cnt } + 15'd1 ) ) ; //NOTE: set HP->TP if reduce to 0 or 1 task left in LL, set to NXTHP of TP if > 1

    end

      rmw_rofrag_hp_p0_v_nxt                       = 1'b1 ;
      rmw_rofrag_hp_p0_rw_nxt                      = HQM_AW_RMWPIPE_RMW ;
      rmw_rofrag_hp_p0_addr_nxt                    = { p3_rofrag_data_nxt.cq [ 5 : 0 ] , p3_rofrag_data_nxt.qidix } ;
      rmw_rofrag_hp_p0_write_data_nxt_nc              = '0 ;

      rmw_rofrag_tp_p0_v_nxt                       = 1'b1 ;
      rmw_rofrag_tp_p0_rw_nxt                      = HQM_AW_RMWPIPE_RMW ;
      rmw_rofrag_tp_p0_addr_nxt                    = { p3_rofrag_data_nxt.cq [ 5 : 0 ] , p3_rofrag_data_nxt.qidix } ;
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
  residue_check_replay_cnt_r_nxt = residue_check_replay_cnt_r_f ;
  residue_check_replay_cnt_d_nxt = residue_check_replay_cnt_d_f ;
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
      for ( int i = 0 ; i < HQM_DP_NUM_PRI ; i = i + 1 ) begin
        arb_replay_cnt_reqs [ i ]                     = ( | rmw_replay_cnt_p2_data_f [ ( i * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ;
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

    if ( p3_replay_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) begin
      error_replay_of                              = ( ( rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] + { p3_replay_data_nxt.frag_cnt } ) > NUM_CREDITS [ 0 +: HQM_DP_CNTB2 ] ) ; 
      p3_replay_data_nxt.error                     = error_replay_of ;

      residue_check_replay_cnt_r_nxt               = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_check_replay_cnt_d_nxt               = rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ; 
      residue_check_replay_cnt_e_nxt               = 1'b1 ;

      if ( ~ p3_replay_data_nxt.error ) begin
      rmw_replay_cnt_p3_bypsel_nxt                 = 1'b1 ;
      end
      rmw_replay_cnt_p3_bypdata_nxt [ ( p3_replay_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ]  = rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] + { p3_replay_data_nxt.frag_cnt } ; 

      residue_add_replay_cnt_a                     = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
      residue_add_replay_cnt_b                     = p3_replay_data_nxt.frag_residue ;
      rmw_replay_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) )  +: 2 ] = residue_add_replay_cnt_r ; 


      p3_replay_data_nxt.empty                     = ( rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'd0 } ) ; 

    end

    if ( p3_replay_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin
      if ( arb_replay_cnt_winner_v ) begin
        p3_replay_data_nxt.qpri                    = arb_replay_cnt_winner ;

        residue_check_replay_cnt_r_nxt             = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        residue_check_replay_cnt_d_nxt             = rmw_replay_cnt_p2_data_f [ ( p3_replay_data_nxt.qpri * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ; 
        residue_check_replay_cnt_e_nxt             = 1'b1 ;

        rmw_replay_cnt_p3_bypsel_nxt               = 1'b1 ;
        rmw_replay_cnt_p3_bypdata_nxt [ ( arb_replay_cnt_winner * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] = rmw_replay_cnt_p2_data_f [ ( arb_replay_cnt_winner * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] - { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ; 

        residue_sub_replay_cnt_a                   = 2'd1 ;
        residue_sub_replay_cnt_b                   = rmw_replay_cnt_p2_data_f [ ( ( 8 * HQM_DP_CNTB2 ) + ( p3_replay_data_nxt.qpri * 2 ) ) +: 2 ] ; 
        rmw_replay_cnt_p3_bypdata_nxt [ ( ( 8 * HQM_DP_CNTB2 ) + ( arb_replay_cnt_winner * 2 ) ) +: 2 ] = residue_sub_replay_cnt_r ; 

        p3_replay_data_nxt.empty                   = ( rmw_replay_cnt_p2_data_f [ ( arb_replay_cnt_winner * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == { { ( HQM_DP_CNTB2 - 1 ) { 1'b0 } } , 1'b1 } ) ; 
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

always_comb begin : L17
  //....................................................................................................
  // p4 dir pipeline
  //  ll-1
  p4_dir_ctrl = '0 ;
  p4_dir_v_nxt = '0 ;
  p4_dir_data_nxt = p4_dir_data_f ;
  rmw_dir_hp_p1_hold = '0 ;
  rmw_dir_tp_p1_hold = '0 ;

  p4_dir_ctrl.hold                              = ( p4_dir_v_f & p5_dir_ctrl.hold ) ;
  p4_dir_ctrl.enable                            = ( p3_dir_v_f & ~ p4_dir_ctrl.hold ) ;
  rmw_dir_hp_p1_hold = p4_dir_ctrl.hold ;
  rmw_dir_tp_p1_hold = p4_dir_ctrl.hold ;
  if ( p4_dir_ctrl.enable | p4_dir_ctrl.hold ) begin
    p4_dir_v_nxt                                = 1'b1 ;
  end
  if ( p4_dir_ctrl.enable ) begin
    p4_dir_data_nxt                             = p3_dir_data_f ;
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

always_comb begin : L18
  //....................................................................................................
  // p5 dir pipeline
  //  ll-2
  p5_dir_ctrl = '0 ;
  p5_dir_v_nxt = '0 ;
  p5_dir_data_nxt = p5_dir_data_f ;
  rmw_dir_hp_p2_hold = '0 ;
  rmw_dir_tp_p2_hold = '0 ;

  p5_dir_ctrl.hold                              = ( ( p5_dir_v_f & p6_dir_ctrl.hold )
                                                  | ( p5_dir_v_f & ~ ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_DP_NXTHP_DIR ) ) )
                                                  ) ;
  p5_dir_ctrl.enable                            = ( p4_dir_v_f & ~ p5_dir_ctrl.hold ) ;
  rmw_dir_hp_p2_hold = p5_dir_ctrl.hold ;
  rmw_dir_tp_p2_hold = p5_dir_ctrl.hold ;
  if ( p5_dir_ctrl.enable | p5_dir_ctrl.hold ) begin
    p5_dir_v_nxt                                = 1'b1 ;
  end
  if ( p5_dir_ctrl.enable ) begin
    p5_dir_data_nxt                             = p4_dir_data_f ;
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
                                                   | ( p5_rofrag_v_f & ~ ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_DP_NXTHP_ORDERED ) ) )
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
                                                   | ( p5_replay_v_f & ~ ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_DP_NXTHP_ORDERED ) ) )
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

always_comb begin : L19
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

  parity_check_rmw_dir_hp_p2_p = '0 ;
  parity_check_rmw_dir_hp_p2_d = '0 ;
  parity_check_rmw_dir_hp_p2_e = '0 ;
  parity_check_rmw_dir_tp_p2_p = '0 ;
  parity_check_rmw_dir_tp_p2_d = '0 ;
  parity_check_rmw_dir_tp_p2_e = '0 ;

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

  rmw_dir_hp_p3_hold = '0 ;
  rmw_dir_tp_p3_hold = '0 ;

  rmw_rofrag_hp_p3_hold = '0 ;
  rmw_rofrag_tp_p3_hold = '0 ;

  rmw_replay_hp_p3_hold = '0 ;
  rmw_replay_tp_p3_hold = '0 ;

  rw_nxthp_p0_hold = '0 ;

  error_dir_headroom = '0 ;
  error_rofrag_headroom = '0 ;
  error_replay_headroom = '0 ;

  //....................................................................................................
  // p6 nxt pipeline
  //  nxt-0
  p6_dir_ctrl = '0 ;
  p6_dir_v_nxt = '0 ;
  p6_dir_data_nxt = p6_dir_data_f ;

  dir_stall_nc = ( p6_dir_v_f
              & ( ( ( p7_dir_v_f & ( p7_dir_data_f.qid == p6_dir_data_f.qid ) ) & ( p7_dir_v_f & ( p7_dir_data_f.qpri == p6_dir_data_f.qpri ) ) )
                | ( ( p8_dir_v_f & ( p8_dir_data_f.qid == p6_dir_data_f.qid ) ) & ( p8_dir_v_f & ( p8_dir_data_f.qpri == p6_dir_data_f.qpri ) ) )
                )
              ) ;

  p6_dir_ctrl.hold                              = ( p6_dir_v_f & ( p7_dir_ctrl.hold | dir_stall_f [ 0 ] ) ) ;
  p6_dir_ctrl.enable                            = ( arb_nxthp_winner_v & ( ( arb_nxthp_winner == HQM_DP_NXTHP_DIR ) ) ) ;
  p6_dir_ctrl.bypsel                            = ( dir_stall_f [ 1 ] ) ;





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
  p6_rofrag_ctrl.enable                         = ( arb_nxthp_winner_v & (  ( arb_nxthp_winner == HQM_DP_NXTHP_ORDERED ) ) ) ;
  p6_rofrag_ctrl.bypsel                         = ( ordered_stall_f [ 1 ] ) ;

  p6_replay_ctrl = '0 ;
  p6_replay_v_nxt = '0 ;
  p6_replay_data_nxt = p6_replay_data_f ;

  p6_replay_ctrl.hold                           = ( p6_replay_v_f & ( p7_replay_ctrl.hold | ordered_stall_f [ 2 ] ) ) ;
  p6_replay_ctrl.enable                         = ( arb_nxthp_winner_v & (  ( arb_nxthp_winner == HQM_DP_NXTHP_ORDERED ) ) ) ;
  p6_replay_ctrl.bypsel                         = ( ordered_stall_f [ 3 ] ) ;



  rmw_dir_tp_p3_bypsel_nxt = '0 ;
  rmw_dir_tp_p3_bypaddr_nxt = '0 ;
  rmw_dir_tp_p3_bypdata_nxt = '0 ;



  //....................................................................................................
  // p6 nxt pipeline
  //  nxt-0
  arb_nxthp_reqs [ HQM_DP_NXTHP_DIR ]                     = ( p5_dir_v_f
                                                  & ~ p6_dir_ctrl.hold
                                                  & ~ p6_rofrag_ctrl.hold
                                                  & ~ p6_replay_ctrl.hold
                                                  & ( ( p5_dir_data_f.cmd == HQM_DP_CMD_ENQ ) ? ~ fifo_dp_lsp_enq_dir_afull : 1'b1 )
                                                  & ( ( p5_dir_data_f.cmd == HQM_DP_CMD_DEQ ) ? ~ fifo_dp_dqed_afull : 1'b1 )
                                                  ) ;

  error_dir_headroom [ 0 ]                         = ( p5_dir_v_f
                                                  & ( ( p5_dir_data_f.cmd == HQM_DP_CMD_ENQ ) ? fifo_dp_lsp_enq_dir_afull : 1'b0 )
                                                  ) ;
  error_dir_headroom [ 1 ]                         = ( p5_dir_v_f
                                                  & ( ( p5_dir_data_f.cmd == HQM_DP_CMD_DEQ ) ? fifo_dp_dqed_afull : 1'b0 )
                                                  ) ;

  if ( p6_dir_ctrl.enable | p6_dir_ctrl.hold ) begin
    p6_dir_v_nxt                                = 1'b1 ;
  end
  if ( p6_dir_ctrl.enable ) begin
    //..................................................
    // service DIR pipe request
    if ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_DP_NXTHP_DIR ) ) begin
      arb_nxthp_update = 1'b1 ;
      p6_dir_data_nxt                           = p5_dir_data_f ;

      if ( p6_dir_data_nxt.cmd != HQM_DP_CMD_NOOP ) begin
        p6_dir_data_nxt.hp                      = rmw_dir_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_dir_data_nxt.hp_parity               = rmw_dir_hp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;
        p6_dir_data_nxt.tp                      = rmw_dir_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_dir_data_nxt.tp_parity               = rmw_dir_tp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;

        parity_check_rmw_dir_hp_p2_p            = rmw_dir_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_dir_hp_p2_d            = rmw_dir_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_dir_hp_p2_e            = 1'b1 ;

        parity_check_rmw_dir_tp_p2_p            = rmw_dir_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_dir_tp_p2_d            = rmw_dir_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_dir_tp_p2_e            = 1'b1 ;
      end

      //bypass directly into pipeline storage (RMW does not have this bypass)
      if ( ( rmw_dir_hp_p3_bypsel_nxt )
         & ( p6_dir_data_nxt.qid == p9_dir_data_nxt.qid )
         & ( p6_dir_data_nxt.qpri == p9_dir_data_nxt.qpri )
         )  begin
        p6_dir_data_nxt.hp_parity                 = rmw_dir_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
        p6_dir_data_nxt.hp                        = rmw_dir_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      end








      if ( p6_dir_data_nxt.cmd == HQM_DP_CMD_ENQ ) begin
////
      rmw_dir_tp_p3_bypsel_nxt                  = 1'b1 ;
      rmw_dir_tp_p3_bypaddr_nxt                 = { 1'b0 , p6_dir_data_nxt.qid , p6_dir_data_nxt.qpri [ 1 : 0 ] } ;
      rmw_dir_tp_p3_bypdata_nxt                 = { p6_dir_data_nxt.flid_parity , p6_dir_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
////
        if ( ~ p6_dir_data_nxt.empty ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_addr_nxt                  = p6_dir_data_nxt.tp ;
          rw_nxthp_p0_write_data_nxt            = { 6'd0 , p6_dir_data_nxt.flid_parity , p6_dir_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
        end
        else begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_NOOP ;
        end
      end
      if ( p6_dir_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_READ ;
          rw_nxthp_p0_addr_nxt                  = p6_dir_data_nxt.hp ;
      end
    end






  end
  if ( p6_dir_ctrl.bypsel ) begin
    if ( ( rmw_dir_hp_p3_bypsel_nxt )
       & ( p6_dir_data_nxt.qid == p9_dir_data_nxt.qid )
       & ( p6_dir_data_nxt.qpri == p9_dir_data_nxt.qpri )
       )  begin
      p6_dir_data_nxt.hp_parity                 = rmw_dir_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
      p6_dir_data_nxt.hp                        = rmw_dir_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;

      if ( p6_dir_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin
          rw_nxthp_p0_byp_v_nxt                 = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                = HQM_AW_RWPIPE_READ ;
          rw_nxthp_p0_byp_addr_nxt              = p6_dir_data_nxt.hp ;
      end

    end
    if ( ( rmw_dir_tp_p3_bypsel_nxt )
       & ( p6_dir_data_nxt.qid == p9_dir_data_nxt.qid )
       & ( p6_dir_data_nxt.qpri == p9_dir_data_nxt.qpri )
       )  begin



      if ( p6_dir_data_nxt.cmd == HQM_DP_CMD_ENQ ) begin
        if ( ~ p6_dir_data_nxt.empty ) begin
          rw_nxthp_p0_byp_v_nxt                 = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_byp_addr_nxt              = p6_dir_data_nxt.tp ;
          rw_nxthp_p0_byp_write_data_nxt        = { 6'd0 , p6_dir_data_nxt.flid_parity , p6_dir_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
        end
      end

    end
  end

  //....................................................................................................
  // p6 ordered nxt pipeline
  //  nxt-0
  arb_nxthp_reqs [ HQM_DP_NXTHP_ORDERED ]                 = ( p5_rofrag_v_f
                                                  & p5_replay_v_f
                                                  & ~ p6_dir_ctrl.hold
                                                  & ~ p6_rofrag_ctrl.hold
                                                  & ~ p6_replay_ctrl.hold
                                                  & ( ( p5_replay_data_f.cmd == HQM_DP_CMD_DEQ ) ? ~ fifo_dp_dqed_afull : 1'b1 )
                                                  & ( ( ( p5_rofrag_data_f.cmd == HQM_DP_CMD_ENQ_RORPLY ) & ( ~ p5_replay_data_f.cmd == HQM_DP_CMD_ENQ_RORPLY ) ) ? fifo_dp_lsp_enq_rorply_afull : 1'b1 )
                                                  ) ;

  error_rofrag_headroom                         = ( p5_replay_v_f
                                                  & ( p5_replay_data_f.cmd == HQM_DP_CMD_DEQ )
                                                  & fifo_dp_dqed_afull
                                                  ) ;

  error_replay_headroom                         = ( p5_rofrag_v_f
                                                  & p5_replay_v_f
                                                  & ( p5_rofrag_data_f.cmd == HQM_DP_CMD_ENQ_RORPLY )
                                                  & ( p5_replay_data_f.cmd == HQM_DP_CMD_ENQ_RORPLY )
                                                  & fifo_dp_lsp_enq_rorply_afull
                                                  ) ;

  if ( p6_rofrag_ctrl.enable | p6_rofrag_ctrl.hold ) begin
    p6_rofrag_v_nxt                             = 1'b1 ;
  end
  if ( p6_replay_ctrl.enable | p6_replay_ctrl.hold ) begin
    p6_replay_v_nxt                             = 1'b1 ;
  end
  if ( p6_rofrag_ctrl.enable | p6_replay_ctrl.enable ) begin

    if ( arb_nxthp_winner_v & ( arb_nxthp_winner == HQM_DP_NXTHP_ORDERED ) ) begin
      arb_nxthp_update = 1'b1 ;

      p6_rofrag_data_nxt                        = p5_rofrag_data_f ;
      p6_replay_data_nxt                        = p5_replay_data_f ;

      if ( ( p6_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ ) & ( p6_replay_data_nxt.cmd == HQM_DP_CMD_NOOP ) ) begin

        p6_rofrag_data_nxt.hp                     = rmw_rofrag_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_rofrag_data_nxt.hp_parity              = rmw_rofrag_hp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;
        p6_rofrag_data_nxt.tp                     = rmw_rofrag_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_rofrag_data_nxt.tp_parity              = rmw_rofrag_tp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;

        parity_check_rmw_rofrag_hp_p2_p           = rmw_rofrag_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_rofrag_hp_p2_d           = rmw_rofrag_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_rofrag_hp_p2_e           = 1'b1 ;

        parity_check_rmw_rofrag_tp_p2_p           = rmw_rofrag_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_rofrag_tp_p2_d           = rmw_rofrag_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_rofrag_tp_p2_e           = 1'b1 ;

        //bypass directly into storage (RMW does not have this bypass)
        if ( ( rmw_rofrag_hp_p3_bypsel_nxt )
           & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
           & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
           )  begin
          p6_rofrag_data_nxt.hp_parity                  = rmw_rofrag_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
          p6_rofrag_data_nxt.hp                         = rmw_rofrag_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        end
        if ( ( rmw_rofrag_tp_p3_bypsel_nxt )
           & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
           & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
           )  begin
          p6_rofrag_data_nxt.tp_parity                  = rmw_rofrag_tp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
          p6_rofrag_data_nxt.tp                         = rmw_rofrag_tp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        end

        if ( ~ p6_rofrag_data_nxt.empty ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_addr_nxt                  = p6_rofrag_data_nxt.tp ;
          rw_nxthp_p0_write_data_nxt            = { 6'd0 , p6_rofrag_data_nxt.flid_parity , p6_rofrag_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
        end
        else begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_NOOP ;
        end

      end

      if ( ( p6_rofrag_data_nxt.cmd == HQM_DP_CMD_NOOP ) & ( p6_replay_data_nxt.cmd == HQM_DP_CMD_DEQ ) ) begin

        p6_replay_data_nxt.hp                     = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_replay_data_nxt.hp_parity              = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;
        p6_replay_data_nxt.tp                     = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_replay_data_nxt.tp_parity              = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;

        parity_check_rmw_replay_hp_p2_p           = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_replay_hp_p2_d           = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_hp_p2_e           = 1'b1 ;

        parity_check_rmw_replay_tp_p2_p           = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_replay_tp_p2_d           = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_tp_p2_e           = 1'b1 ;

        //bypass directly into storage (RMW does not have this bypass)
        if ( ( rmw_replay_hp_p3_bypsel_nxt )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.hp_parity                 = rmw_replay_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
          p6_replay_data_nxt.hp                        = rmw_replay_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        end
        if ( ( rmw_replay_tp_p3_bypsel_nxt )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.tp_parity                 = rmw_replay_tp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
          p6_replay_data_nxt.tp                        = rmw_replay_tp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        end

        rw_nxthp_p0_v_nxt                       = 1'b1 ;
        rw_nxthp_p0_rw_nxt                      = HQM_AW_RWPIPE_READ ;
        rw_nxthp_p0_addr_nxt                    = p6_replay_data_nxt.hp ;
      end

      if ( ( p6_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) & ( p6_replay_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) ) begin
        p6_replay_data_nxt.hp                     = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_replay_data_nxt.hp_parity              = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;
        p6_replay_data_nxt.tp                     = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        p6_replay_data_nxt.tp_parity              = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 )  ] ;

        parity_check_rmw_replay_hp_p2_p           = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_replay_hp_p2_d           = rmw_replay_hp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_hp_p2_e           = 1'b1 ;

        parity_check_rmw_replay_tp_p2_p           = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rmw_replay_tp_p2_d           = rmw_replay_tp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rmw_replay_tp_p2_e           = 1'b1 ;

        //bypass directly into storage (RMW does not have this bypass)
        if ( ( rmw_replay_hp_p3_bypsel_nxt )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.hp_parity                 = rmw_replay_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
          p6_replay_data_nxt.hp                        = rmw_replay_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        end
        if ( ( rmw_replay_tp_p3_bypsel_nxt )
           & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
           & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
           )  begin
          p6_replay_data_nxt.tp_parity                 = rmw_replay_tp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
          p6_replay_data_nxt.tp                        = rmw_replay_tp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        end

        if ( ~ p6_replay_data_nxt.empty ) begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_addr_nxt                  = p6_replay_data_nxt.tp ;
          rw_nxthp_p0_write_data_nxt            = { 6'd0 , p6_rofrag_data_nxt.hp_parity , p6_rofrag_data_nxt.hp [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ; //NOTE: when replay is active need to link the current replay TP to the replay list HP
        end
        else begin
          rw_nxthp_p0_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_rw_nxt                    = HQM_AW_RWPIPE_NOOP ;
        end

      end

    end
  end
  if ( p6_rofrag_ctrl.bypsel | p6_replay_ctrl.bypsel ) begin

    if ( ( p6_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ ) & ( p6_replay_data_nxt.cmd == HQM_DP_CMD_NOOP ) ) begin
      if ( ( rmw_rofrag_hp_p3_bypsel_nxt )
         & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
         & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
         )  begin
        p6_rofrag_data_nxt.hp_parity                  = rmw_rofrag_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
        p6_rofrag_data_nxt.hp                         = rmw_rofrag_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      end
      if ( ( rmw_rofrag_tp_p3_bypsel_nxt )
         & ( p6_rofrag_data_nxt.cq == p9_rofrag_data_nxt.cq )
         & ( p6_rofrag_data_nxt.qidix == p9_rofrag_data_nxt.qidix )
         )  begin
        p6_rofrag_data_nxt.tp_parity                  = rmw_rofrag_tp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
        p6_rofrag_data_nxt.tp                         = rmw_rofrag_tp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      end
        if ( ~ p6_rofrag_data_nxt.empty ) begin
          rw_nxthp_p0_byp_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_byp_addr_nxt                  = p6_rofrag_data_nxt.tp ;
          rw_nxthp_p0_byp_write_data_nxt            = { 6'd0 , p6_rofrag_data_nxt.flid_parity , p6_rofrag_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
        end
    end

    if ( ( p6_rofrag_data_nxt.cmd == HQM_DP_CMD_NOOP ) & ( p6_replay_data_nxt.cmd == HQM_DP_CMD_DEQ ) ) begin
      if ( ( rmw_replay_hp_p3_bypsel_nxt )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.hp_parity                 = rmw_replay_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
        p6_replay_data_nxt.hp                        = rmw_replay_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      end
      if ( ( rmw_replay_tp_p3_bypsel_nxt )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.tp_parity                 = rmw_replay_tp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
        p6_replay_data_nxt.tp                        = rmw_replay_tp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      end

        rw_nxthp_p0_byp_v_nxt                       = 1'b1 ;
        rw_nxthp_p0_byp_rw_nxt                      = HQM_AW_RWPIPE_READ ;
        rw_nxthp_p0_byp_addr_nxt                    = p6_replay_data_nxt.hp ;
    end

    if ( ( p6_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) & ( p6_replay_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) ) begin
      if ( ( rmw_replay_hp_p3_bypsel_nxt )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.hp_parity                 = rmw_replay_hp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
        p6_replay_data_nxt.hp                        = rmw_replay_hp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      end
      if ( ( rmw_replay_tp_p3_bypsel_nxt )
         & ( p6_replay_data_nxt.qid == p9_replay_data_nxt.qid )
         & ( p6_replay_data_nxt.qpri == p9_replay_data_nxt.qpri )
         )  begin
        p6_replay_data_nxt.tp_parity                 = rmw_replay_tp_p3_bypdata_nxt [ HQM_DP_FLIDB2 ] ;
        p6_replay_data_nxt.tp                        = rmw_replay_tp_p3_bypdata_nxt [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
      end
        if ( ~ p6_replay_data_nxt.empty ) begin
          rw_nxthp_p0_byp_v_nxt                     = 1'b1 ;
          rw_nxthp_p0_byp_rw_nxt                    = HQM_AW_RWPIPE_WRITE ;
          rw_nxthp_p0_byp_addr_nxt                  = p6_replay_data_nxt.tp ;
          rw_nxthp_p0_byp_write_data_nxt            = { 6'd0 , p6_rofrag_data_nxt.hp_parity , p6_rofrag_data_nxt.hp [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
        end
    end


  end

  rw_nxthp_p0_hold = p6_dir_ctrl.hold | p6_rofrag_ctrl.hold | p6_replay_ctrl.hold ;

  stall = dir_stall_f [ 2 ] | ordered_stall_f [ 4 ] ;
end

always_comb begin : L20
  //....................................................................................................
  // p7 nxt pipeline
  //  nxt-1
  p7_dir_ctrl = '0 ;
  p7_dir_v_nxt = '0 ;
  p7_dir_data_nxt = p7_dir_data_f ;
  rw_nxthp_p1_hold = '0 ;

  p7_dir_ctrl.hold                              = '0 ;
  p7_dir_ctrl.enable                            = ( p6_dir_v_f & ~ dir_stall_f [ 3 ] & ~ p7_dir_ctrl.hold ) ;

  if ( p7_dir_ctrl.enable | p7_dir_ctrl.hold ) begin
    p7_dir_v_nxt                                = 1'b1 ;
  end
  if ( p7_dir_ctrl.enable ) begin
    p7_dir_data_nxt                             = p6_dir_data_f ;
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

  rw_nxthp_p1_hold = p7_dir_ctrl.hold | p7_rofrag_ctrl.hold | p7_replay_ctrl.hold ;

end

always_comb begin : L21

  fifo_dp_dqed_push = '0 ;
  fifo_dp_dqed_push_data = '0 ;

  fifo_dp_lsp_enq_dir_push = '0 ;
  fifo_dp_lsp_enq_dir_push_data = '0 ;

  fifo_dp_lsp_enq_rorply_push = '0 ;
  fifo_dp_lsp_enq_rorply_push_data = '0 ;


  //....................................................................................................
  // p8 nxt pipeline
  //  nxt-2
  p8_dir_ctrl = '0 ;
  p8_dir_v_nxt = '0 ;
  p8_dir_data_nxt = p8_dir_data_f ;
  rw_nxthp_p2_hold = '0 ;

  p8_dir_ctrl.hold                              = '0 ;
  p8_dir_ctrl.enable                            = ( p7_dir_v_f & ~ p8_dir_ctrl.hold ) ;


  if ( p8_dir_ctrl.enable | p8_dir_ctrl.hold ) begin
    p8_dir_v_nxt                                = 1'b1 ;
  end
  if ( p8_dir_ctrl.enable ) begin
    p8_dir_data_nxt                             = p7_dir_data_f ;
  end

  if ( p8_dir_ctrl.enable ) begin

    if ( p8_dir_data_nxt.cmd == HQM_DP_CMD_ENQ ) begin
      fifo_dp_lsp_enq_dir_push                  = 1'b1 ;
      fifo_dp_lsp_enq_dir_push_data.qid         = p8_dir_data_nxt.qid ;
      fifo_dp_lsp_enq_dir_push_data.parity      = p8_dir_data_nxt.parity ;

    end
    if ( p8_dir_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin
      fifo_dp_dqed_push                         = 1'b1 ;
      fifo_dp_dqed_push_data.cmd                = DP_DQED_POP ;
      fifo_dp_dqed_push_data.cq                 = p8_dir_data_nxt.cq ;
      fifo_dp_dqed_push_data.qid                = p8_dir_data_nxt.qid ;
      fifo_dp_dqed_push_data.parity             = p8_dir_data_nxt.parity ;
      fifo_dp_dqed_push_data.flid               = { 2'd0 , p8_dir_data_nxt.hp [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
      fifo_dp_dqed_push_data.flid_parity        = p8_dir_data_nxt.hp_parity ;
      fifo_dp_dqed_push_data.hqm_core_flags     = p8_dir_data_nxt.hqm_core_flags ;
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

    if ( p8_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) begin //no response for CMD_ENQ
      fifo_dp_lsp_enq_rorply_push                     = 1'b1 ;
      fifo_dp_lsp_enq_rorply_push_data.qid            = p8_rofrag_data_nxt.qid ;
      fifo_dp_lsp_enq_rorply_push_data.parity         = p8_rofrag_data_nxt.parity ;
      fifo_dp_lsp_enq_rorply_push_data.frag_cnt       = p8_rofrag_data_nxt.frag_cnt [12:0]; 
      fifo_dp_lsp_enq_rorply_push_data.frag_residue   = p8_rofrag_data_nxt.frag_residue ;
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

    if ( p8_replay_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin //no response for CMD_ENQ_RORPLY
      fifo_dp_dqed_push                         = 1'b1 ;
      fifo_dp_dqed_push_data.cmd                = DP_DQED_READ ;
      fifo_dp_dqed_push_data.cq                 = p8_replay_data_nxt.cq ;
      fifo_dp_dqed_push_data.qid                = p8_replay_data_nxt.qid ;
      fifo_dp_dqed_push_data.parity             = p8_replay_data_nxt.parity ;
      fifo_dp_dqed_push_data.flid               = { 2'd0 , p8_replay_data_nxt.hp [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
      fifo_dp_dqed_push_data.flid_parity        = p8_replay_data_nxt.hp_parity ;
      fifo_dp_dqed_push_data.hqm_core_flags     = p8_replay_data_nxt.hqm_core_flags ;
    end

  end

  rw_nxthp_p2_hold                             = p8_dir_ctrl.hold | p8_rofrag_ctrl.hold | p8_replay_ctrl.hold ;

  //....................................................................................................
  // drive FIFO output to ports

  fifo_dp_dqed_pop = '0 ;
  fifo_dp_lsp_enq_dir_pop = '0 ;
  fifo_dp_lsp_enq_rorply_pop = '0 ;

  tx_sync_dp_lsp_enq_dir_v = '0 ;
  tx_sync_dp_lsp_enq_dir_data = '0 ;

  tx_sync_dp_lsp_enq_rorply_v = '0 ;
  tx_sync_dp_lsp_enq_rorply_data = '0 ;

  tx_sync_dp_dqed_v = '0 ;
  tx_sync_dp_dqed_data = '0 ;

  fifo_dp_lsp_enq_dir_dec = '0 ;
  fifo_dp_dqed_dir_dec = '0 ;
  fifo_dp_lsp_enq_rorply_dec = '0 ;
  fifo_dp_dqed_rorply_dec = '0 ;

  //FIFO drives double buffer
  tx_sync_dp_dqed_v                                  = ~ fifo_dp_dqed_empty ;
  tx_sync_dp_dqed_data                               = fifo_dp_dqed_pop_data ;
  fifo_dp_dqed_pop                              = tx_sync_dp_dqed_v & tx_sync_dp_dqed_ready ;
  fifo_dp_dqed_dir_dec                          = fifo_dp_dqed_pop & ( fifo_dp_dqed_pop_data.cmd == DP_DQED_POP ) ;
  fifo_dp_dqed_rorply_dec                       = fifo_dp_dqed_pop & ( fifo_dp_dqed_pop_data.cmd == DP_DQED_READ ) ;

  //FIFO drives double buffer
  tx_sync_dp_lsp_enq_dir_v                           = ~ fifo_dp_lsp_enq_dir_empty ;
  tx_sync_dp_lsp_enq_dir_data                        = fifo_dp_lsp_enq_dir_pop_data ;
  fifo_dp_lsp_enq_dir_pop                       = tx_sync_dp_lsp_enq_dir_v & tx_sync_dp_lsp_enq_dir_ready ;
  fifo_dp_lsp_enq_dir_dec                      = fifo_dp_lsp_enq_dir_pop ;

  //FIFO drives double buffer
  tx_sync_dp_lsp_enq_rorply_v                       = ~ fifo_dp_lsp_enq_rorply_empty ;
  tx_sync_dp_lsp_enq_rorply_data                    = fifo_dp_lsp_enq_rorply_pop_data ;
  fifo_dp_lsp_enq_rorply_pop                   = tx_sync_dp_lsp_enq_rorply_v & tx_sync_dp_lsp_enq_rorply_ready ;
  fifo_dp_lsp_enq_rorply_dec                   = fifo_dp_lsp_enq_rorply_pop ;

end

always_comb begin : L22
  rw_nxthp_p3_hold = '0 ;

  parity_check_rw_nxthp_p2_data_p = '0 ;
  parity_check_rw_nxthp_p2_data_d = '0 ;
  parity_check_rw_nxthp_p2_data_e = '0 ;

  //....................................................................................................
  // p9 nxt pipeline
  //  nxt-3

  p9_dir_ctrl = '0 ;
  p9_dir_v_nxt = '0 ;
  p9_dir_data_nxt = p9_dir_data_f ;

  rmw_dir_hp_p3_bypsel_nxt = '0 ;
  rmw_dir_hp_p3_bypaddr_nxt = '0 ;
  rmw_dir_hp_p3_bypdata_nxt = '0 ;





  p9_dir_ctrl.hold                              = '0 ;
  p9_dir_ctrl.enable                            = p8_dir_v_f & ~ p9_dir_ctrl.hold ;

  if ( p9_dir_ctrl.enable | p9_dir_ctrl.hold ) begin
    p9_dir_v_nxt                                = 1'b1 ;
  end
  if ( p9_dir_ctrl.enable ) begin
    p9_dir_data_nxt                             = p8_dir_data_f ;
  end

  if ( p9_dir_ctrl.enable ) begin

    if ( p9_dir_data_nxt.cmd == HQM_DP_CMD_ENQ ) begin

      if ( p9_dir_data_nxt.empty ) begin
        rmw_dir_hp_p3_bypsel_nxt                = 1'b1 ;
        rmw_dir_hp_p3_bypaddr_nxt               = { 1'b0 , p9_dir_data_nxt.qid , p9_dir_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_dir_hp_p3_bypdata_nxt               = { p9_dir_data_nxt.flid_parity , p9_dir_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
      end




    end
    if ( p9_dir_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin

      if ( ~ p9_dir_data_nxt.empty ) begin
        parity_check_rw_nxthp_p2_data_p         = rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rw_nxthp_p2_data_d         = rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rw_nxthp_p2_data_e         = 1'b1 ;

        rmw_dir_hp_p3_bypsel_nxt                = 1'b1 ;
        rmw_dir_hp_p3_bypaddr_nxt               = { 1'b0 , p9_dir_data_nxt.qid , p9_dir_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_dir_hp_p3_bypdata_nxt               = { rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) ]
                                                  , rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ]
                                                  } ;
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

    if ( p9_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ ) begin
      if ( p9_rofrag_data_nxt.empty ) begin
        rmw_rofrag_hp_p3_bypsel_nxt             = 1'b1 ;
        rmw_rofrag_hp_p3_bypaddr_nxt            = { p9_rofrag_data_nxt.cq [ 5 : 0 ] , p9_rofrag_data_nxt.qidix } ;
        rmw_rofrag_hp_p3_bypdata_nxt            = { p9_rofrag_data_nxt.flid_parity , p9_rofrag_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
      end
      rmw_rofrag_tp_p3_bypsel_nxt               = 1'b1 ;
      rmw_rofrag_tp_p3_bypaddr_nxt              = { p9_rofrag_data_nxt.cq [ 5 : 0 ] , p9_rofrag_data_nxt.qidix } ;
      rmw_rofrag_tp_p3_bypdata_nxt              = { p9_rofrag_data_nxt.flid_parity , p9_rofrag_data_nxt.flid [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;

    end
    if ( p9_rofrag_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) begin
      if ( p9_rofrag_data_nxt.empty ) begin
        rmw_rofrag_hp_p3_bypsel_nxt             = 1'b1 ;
        rmw_rofrag_hp_p3_bypaddr_nxt            = { p9_rofrag_data_nxt.cq [ 5 : 0 ] , p9_rofrag_data_nxt.qidix } ;
        rmw_rofrag_hp_p3_bypdata_nxt            = { p9_rofrag_data_nxt.tp_parity , p9_rofrag_data_nxt.tp [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
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

    if ( p9_replay_data_nxt.cmd == HQM_DP_CMD_ENQ_RORPLY ) begin
      if ( p9_replay_data_nxt.empty ) begin
        rmw_replay_hp_p3_bypsel_nxt             = 1'b1 ;
        rmw_replay_hp_p3_bypaddr_nxt            = { 1'b0 , p9_rofrag_data_nxt.qid , p9_rofrag_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_replay_hp_p3_bypdata_nxt            = { p9_rofrag_data_nxt.hp_parity , p9_rofrag_data_nxt.hp [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
      end
      rmw_replay_tp_p3_bypsel_nxt               = 1'b1 ;
      rmw_replay_tp_p3_bypaddr_nxt              = { 1'b0 , p9_rofrag_data_nxt.qid , p9_rofrag_data_nxt.qpri [ 1 : 0 ] } ;
      rmw_replay_tp_p3_bypdata_nxt              = { p9_rofrag_data_nxt.tp_parity , p9_rofrag_data_nxt.tp [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
    end
    if ( p9_replay_data_nxt.cmd == HQM_DP_CMD_DEQ ) begin
      if ( ~ p9_replay_data_nxt.empty ) begin
        parity_check_rw_nxthp_p2_data_p         = rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] ;
        parity_check_rw_nxthp_p2_data_d         = rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] ;
        parity_check_rw_nxthp_p2_data_e         = 1'b1 ;

        rmw_replay_hp_p3_bypsel_nxt             = 1'b1 ;
        rmw_replay_hp_p3_bypaddr_nxt            = { 1'b0 , p9_replay_data_nxt.qid , p9_replay_data_nxt.qpri [ 1 : 0 ] } ;
        rmw_replay_hp_p3_bypdata_nxt            = { rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) ] , rw_nxthp_p2_data_f [ ( HQM_DP_FLIDB2 ) - 1 : 0 ] } ;
      end
    end
  end

end




//------------------------------------------------------------------------------------------------------------------------------------------------
always_comb begin : L23
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
  cfg_control2_nxt = cfg_control2_f ;
  cfg_control3_nxt = cfg_control3_f ;
  cfg_control4_nxt = cfg_control4_f ;
  cfg_control5_nxt = cfg_control5_f ;
  cfg_control6_nxt = cfg_control6_f_pnc ;
  cfg_control7_nxt = cfg_control7_f_pnc ;
  cfg_control8_nxt = cfg_control8_f ;
  cfg_pipe_health_valid_00_nxt = cfg_pipe_health_valid_00_f ;
  cfg_pipe_health_hold_00_nxt = cfg_pipe_health_hold_00_f ;
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

                                                  , p8_dir_v_f
                                                  , p7_dir_v_f
                                                  , p6_dir_v_f
                                                  , p5_dir_v_f
                                                  , p4_dir_v_f
                                                  , p3_dir_v_f
                                                  , p2_dir_v_f
                                                  , p1_dir_v_f
                                                  , p0_dir_v_f
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

                                                  , p8_dir_ctrl.hold
                                                  , p7_dir_ctrl.hold
                                                  , p6_dir_ctrl.hold
                                                  , p5_dir_ctrl.hold
                                                  , p4_dir_ctrl.hold
                                                  , p3_dir_ctrl.hold
                                                  , p2_dir_ctrl.hold
                                                  , p1_dir_ctrl.hold
                                                  , p0_dir_ctrl.hold
                                                  } ;

  cfg_status0                                   = { 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , 1'b0
                                                  , int_status_pnc [ 7 ]
                                                  , int_status_pnc [ 6 ]
                                                  , int_status_pnc [ 1 ]
                                                  , int_status_pnc [ 0 ]
                                                  , fifo_lsp_dp_sch_rorply_full
                                                  , fifo_dp_lsp_enq_dir_full
                                                  , rw_nxthp_p3_v_f
                                                  , rw_nxthp_p2_v_f
                                                  , rw_nxthp_p1_v_f
                                                  , rw_nxthp_p0_v_f
                                                  , rw_nxthp_p3_hold
                                                  , rw_nxthp_p2_hold
                                                  } ;
  cfg_status1                                   = { rw_nxthp_p1_hold
                                                  , rmw_dir_cnt_p3_v_f
                                                  , rmw_dir_cnt_p2_v_f
                                                  , rmw_dir_cnt_p1_v_f
                                                  , rmw_dir_cnt_p0_v_f
                                                  , rmw_dir_cnt_p3_hold
                                                  , rmw_dir_cnt_p2_hold
                                                  , rmw_dir_cnt_p1_hold
                                                  , rmw_dir_hp_p3_v_f
                                                  , rmw_dir_hp_p2_v_f
                                                  , rmw_dir_hp_p1_v_f
                                                  , rmw_dir_hp_p0_v_f
                                                  , rmw_dir_hp_p3_hold
                                                  , rmw_dir_hp_p2_hold
                                                  , rmw_dir_hp_p1_hold
                                                  , rmw_dir_tp_p3_v_f
                                                  , rmw_dir_tp_p2_v_f
                                                  , rmw_dir_tp_p1_v_f
                                                  , rmw_dir_tp_p0_v_f
                                                  , rmw_dir_tp_p3_hold
                                                  , rmw_dir_tp_p2_hold
                                                  , rmw_dir_tp_p1_hold
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
                                                  , 1'b0 , ~ rx_sync_rop_dp_enq_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_rop_dp_enq_idle
                                                  , 1'b0 , ~ rx_sync_lsp_dp_sch_dir_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_lsp_dp_sch_dir_idle
                                                  , 1'b0 , ~ rx_sync_lsp_dp_sch_rorply_status_pnc [ 6 ] , 1'b0 , ~ rx_sync_lsp_dp_sch_rorply_idle
                                                  , 1'b0 , tx_sync_dp_lsp_enq_dir_ready , 1'b0 , ~ tx_sync_dp_lsp_enq_dir_idle
                                                  , 1'b0 , tx_sync_dp_lsp_enq_rorply_ready , 1'b0 , ~ tx_sync_dp_lsp_enq_rorply_idle
                                                  , 1'b0 , tx_sync_dp_dqed_ready , 1'b0 , ~ tx_sync_dp_dqed_idle
                                                  , 1'b0 , tx_sync_dp_dqed_status_pnc [ 2 : 0 ]

                                                  } ;

  cfg_unit_idle_nxt.pipe_idle                   = ~ ( ( | cfg_pipe_health_valid_00_nxt ) ) ;

  cfg_unit_idle_nxt.unit_idle                   = ( ( cfg_unit_idle_nxt.pipe_idle )

                                                  & ( fifo_rop_dp_enq_dir_empty )
                                                  & ( fifo_rop_dp_enq_ro_empty )
                                                  & ( fifo_lsp_dp_sch_dir_empty )
                                                  & ( fifo_lsp_dp_sch_rorply_empty )
                                                  & ( fifo_dp_dqed_empty )
                                                  & ( fifo_dp_lsp_enq_dir_empty )
                                                  & ( fifo_dp_lsp_enq_rorply_empty )

                                                  & ( tx_sync_dp_lsp_enq_dir_idle )
                                                  & ( tx_sync_dp_lsp_enq_rorply_idle )
                                                  & ( tx_sync_dp_dqed_idle )

//reset                                                              & ~ cfg_reset_status_f.reset_active
//reset                                                              & ~ cfg_reset_status_f.vf_reset_active

//hqm_inp_gated_clk                                                  & ( cfg_ring_idle )
//hqm_inp_gated_clk                                                  & ( int_idle )
//hqm_inp_gated_clk                                                  & ( rx_sync_rop_dp_enq_idle )
//hqm_inp_gated_clk                                                  & ( rx_sync_lsp_dp_sch_dir_idle )
//hqm_inp_gated_clk                                                  & ( rx_sync_lsp_dp_sch_rorply_idle )
                                                  ) ;

  // top level ports
  dp_reset_done =  ~ ( hqm_gated_rst_n_active ) ;
  unit_idle_local = ~ ( hqm_gated_rst_n_active ) & cfg_unit_idle_nxt.unit_idle ;
  dp_unit_pipeidle = cfg_unit_idle_f.pipe_idle ;


  //....................................................................................................
  // PF reset
pf_dir_nxthp_re = '0 ;
pf_dir_nxthp_addr = '0 ;
pf_dir_nxthp_we = '0 ;
pf_dir_nxthp_wdata = '0 ;
pf_dp_lsp_enq_dir_re = '0 ;
pf_dp_lsp_enq_dir_raddr = '0 ;
pf_dp_lsp_enq_dir_waddr = '0 ;
pf_dp_lsp_enq_dir_we = '0 ;
pf_dp_lsp_enq_dir_wdata = '0 ;
pf_dir_replay_cnt_re = '0 ;
pf_dir_replay_cnt_raddr = '0 ;
pf_dir_replay_cnt_waddr = '0 ;
pf_dir_replay_cnt_we = '0 ;
pf_dir_replay_cnt_wdata = '0 ;
pf_rx_sync_rop_dp_enq_re = '0 ;
pf_rx_sync_rop_dp_enq_raddr = '0 ;
pf_rx_sync_rop_dp_enq_waddr = '0 ;
pf_rx_sync_rop_dp_enq_we = '0 ;
pf_rx_sync_rop_dp_enq_wdata = '0 ;
pf_dir_cnt_re = '0 ;
pf_dir_cnt_raddr = '0 ;
pf_dir_cnt_waddr = '0 ;
pf_dir_cnt_we = '0 ;
pf_dir_cnt_wdata = '0 ;
pf_dir_replay_hp_re = '0 ;
pf_dir_replay_hp_raddr = '0 ;
pf_dir_replay_hp_waddr = '0 ;
pf_dir_replay_hp_we = '0 ;
pf_dir_replay_hp_wdata = '0 ;
pf_lsp_dp_sch_dir_re = '0 ;
pf_lsp_dp_sch_dir_raddr = '0 ;
pf_lsp_dp_sch_dir_waddr = '0 ;
pf_lsp_dp_sch_dir_we = '0 ;
pf_lsp_dp_sch_dir_wdata = '0 ;
pf_rx_sync_lsp_dp_sch_dir_re = '0 ;
pf_rx_sync_lsp_dp_sch_dir_raddr = '0 ;
pf_rx_sync_lsp_dp_sch_dir_waddr = '0 ;
pf_rx_sync_lsp_dp_sch_dir_we = '0 ;
pf_rx_sync_lsp_dp_sch_dir_wdata = '0 ;
pf_rop_dp_enq_dir_re = '0 ;
pf_rop_dp_enq_dir_raddr = '0 ;
pf_rop_dp_enq_dir_waddr = '0 ;
pf_rop_dp_enq_dir_we = '0 ;
pf_rop_dp_enq_dir_wdata = '0 ;
pf_dir_rofrag_hp_re = '0 ;
pf_dir_rofrag_hp_raddr = '0 ;
pf_dir_rofrag_hp_waddr = '0 ;
pf_dir_rofrag_hp_we = '0 ;
pf_dir_rofrag_hp_wdata = '0 ;
pf_dp_dqed_re = '0 ;
pf_dp_dqed_raddr = '0 ;
pf_dp_dqed_waddr = '0 ;
pf_dp_dqed_we = '0 ;
pf_dp_dqed_wdata = '0 ;
pf_dir_tp_re = '0 ;
pf_dir_tp_raddr = '0 ;
pf_dir_tp_waddr = '0 ;
pf_dir_tp_we = '0 ;
pf_dir_tp_wdata = '0 ;
pf_dir_hp_re = '0 ;
pf_dir_hp_raddr = '0 ;
pf_dir_hp_waddr = '0 ;
pf_dir_hp_we = '0 ;
pf_dir_hp_wdata = '0 ;
pf_rx_sync_lsp_dp_sch_rorply_re = '0 ;
pf_rx_sync_lsp_dp_sch_rorply_raddr = '0 ;
pf_rx_sync_lsp_dp_sch_rorply_waddr = '0 ;
pf_rx_sync_lsp_dp_sch_rorply_we = '0 ;
pf_rx_sync_lsp_dp_sch_rorply_wdata = '0 ;
pf_rop_dp_enq_ro_re = '0 ;
pf_rop_dp_enq_ro_raddr = '0 ;
pf_rop_dp_enq_ro_waddr = '0 ;
pf_rop_dp_enq_ro_we = '0 ;
pf_rop_dp_enq_ro_wdata = '0 ;
pf_dir_replay_tp_re = '0 ;
pf_dir_replay_tp_raddr = '0 ;
pf_dir_replay_tp_waddr = '0 ;
pf_dir_replay_tp_we = '0 ;
pf_dir_replay_tp_wdata = '0 ;
pf_dp_lsp_enq_rorply_re = '0 ;
pf_dp_lsp_enq_rorply_raddr = '0 ;
pf_dp_lsp_enq_rorply_waddr = '0 ;
pf_dp_lsp_enq_rorply_we = '0 ;
pf_dp_lsp_enq_rorply_wdata = '0 ;
pf_dir_rofrag_cnt_re = '0 ;
pf_dir_rofrag_cnt_raddr = '0 ;
pf_dir_rofrag_cnt_waddr = '0 ;
pf_dir_rofrag_cnt_we = '0 ;
pf_dir_rofrag_cnt_wdata = '0 ;
pf_lsp_dp_sch_rorply_re = '0 ;
pf_lsp_dp_sch_rorply_raddr = '0 ;
pf_lsp_dp_sch_rorply_waddr = '0 ;
pf_lsp_dp_sch_rorply_we = '0 ;
pf_lsp_dp_sch_rorply_wdata = '0 ;
pf_dir_rofrag_tp_re = '0 ;
pf_dir_rofrag_tp_raddr = '0 ;
pf_dir_rofrag_tp_waddr = '0 ;
pf_dir_rofrag_tp_we = '0 ;
pf_dir_rofrag_tp_wdata = '0 ;

  if ( hqm_gated_rst_n_start & reset_pf_active_f & ~ hw_init_done_f ) begin
    reset_pf_counter_nxt                        = reset_pf_counter_f + 32'b1 ;

    if ( reset_pf_counter_f < HQM_DP_CFG_RST_PFMAX ) begin
      pf_dir_nxthp_we                       = 1'b1 ;
      pf_dir_nxthp_addr                     = reset_pf_counter_f [ ( HQM_DP_RAM_DIR_NXTHP_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_nxthp_wdata                    = { ecc_gen , ecc_gen_d_nc } ;

      pf_dir_cnt_we                         = ( reset_pf_counter_f < 32'd96 ) ;
      pf_dir_cnt_waddr                      = reset_pf_counter_f [ ( HQM_DP_RAM_DIR_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_cnt_wdata                      = { { 8 { 2'd0 } } , { HQM_DP_CNTB2 * 8 { 1'b0 } } } ;

      pf_dir_hp_we                          = ( reset_pf_counter_f < 32'd384 ) ;
      pf_dir_hp_waddr                       = reset_pf_counter_f [ ( HQM_DP_RAM_DIR_HP_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_hp_wdata                       = { 1'b1 , { HQM_DP_DQED_DEPTHB2 { 1'b0 } } } ;

      pf_dir_tp_we                          = ( reset_pf_counter_f < 32'd384 ) ;
      pf_dir_tp_waddr                       = reset_pf_counter_f [ ( HQM_DP_RAM_DIR_TP_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_tp_wdata                       = { 1'b1 , { HQM_DP_DQED_DEPTHB2 { 1'b0 } } } ;

      pf_dir_rofrag_cnt_we                  = ( reset_pf_counter_f < 32'd512 ) ;
      pf_dir_rofrag_cnt_waddr               = reset_pf_counter_f [ ( HQM_DP_RAM_ROFRAG_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_rofrag_cnt_wdata               = { 2'd0 , { HQM_DP_CNTB2 { 1'b0 } } } ;

      pf_dir_rofrag_hp_we                   = ( reset_pf_counter_f < 32'd512 ) ;
      pf_dir_rofrag_hp_waddr                = reset_pf_counter_f [ ( HQM_DP_RAM_ROFRAG_HP_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_rofrag_hp_wdata                = { 1'b1 , { HQM_DP_DQED_DEPTHB2 { 1'b0 } } } ;

      pf_dir_rofrag_tp_we                   = ( reset_pf_counter_f < 32'd512 ) ;
      pf_dir_rofrag_tp_waddr                = reset_pf_counter_f [ ( HQM_DP_RAM_ROFRAG_TP_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_rofrag_tp_wdata                = { 1'b1 , { HQM_DP_DQED_DEPTHB2 { 1'b0 } } } ;

      pf_dir_replay_cnt_we                  = ( reset_pf_counter_f < 32'd32 ) ;
      pf_dir_replay_cnt_waddr               = reset_pf_counter_f [ ( HQM_DP_RAM_REPLAY_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_replay_cnt_wdata               = { { 8 { 2'd0 } } , { HQM_DP_CNTB2 * 8 { 1'b0 } } } ;

      pf_dir_replay_hp_we                   = ( reset_pf_counter_f < 32'd128 ) ;
      pf_dir_replay_hp_waddr                = reset_pf_counter_f [ ( HQM_DP_RAM_REPLAY_HP_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_replay_hp_wdata                = { 1'b1 , { HQM_DP_DQED_DEPTHB2 { 1'b0 } } } ;

      pf_dir_replay_tp_we                   = ( reset_pf_counter_f < 32'd128 ) ;
      pf_dir_replay_tp_waddr                = reset_pf_counter_f [ ( HQM_DP_RAM_REPLAY_TP_DEPTHB2 ) - 1 : 0 ] ;
      pf_dir_replay_tp_wdata                = { 1'b1 , { HQM_DP_DQED_DEPTHB2 { 1'b0 } } } ;
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
  smon_v [ 0 * 1 +: 1 ]                                  = fifo_rop_dp_enq_dir_push ;
  smon_comp [ 0 * 32 +: 32 ]                             = { 25'd0 , fifo_rop_dp_enq_dir_push_data.hist_list_info.qid } ;
  smon_val [ 0 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 1 * 1 +: 1 ]                                  = fifo_rop_dp_enq_ro_push ;
  smon_comp [ 1 * 32 +: 32 ]                             = { 25'd0 , fifo_rop_dp_enq_ro_push_data.hist_list_info.qid } ;
  smon_val [ 1 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 2 * 1 +: 1 ]                                  = 1'b1 ;
  smon_comp [ 2 * 32 +: 32 ]                             = 32'd0 ;
  smon_val [ 2 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 3 * 1 +: 1 ]                                  = fifo_lsp_dp_sch_dir_push ;
  smon_comp [ 3 * 32 +: 32 ]                             = { 25'd0 , fifo_lsp_dp_sch_dir_push_data.qid } ;
  smon_val [ 3 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 4 * 1 +: 1 ]                                  = fifo_lsp_dp_sch_rorply_push ;
  smon_comp [ 4 * 32 +: 32 ]                             = { 25'd0 , fifo_lsp_dp_sch_rorply_push_data.qid } ;
  smon_val [ 4 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 5 * 1 +: 1 ]                                  = fifo_dp_dqed_push ;
  smon_comp [ 5 * 32 +: 32 ]                             = { 25'd0 , fifo_dp_dqed_push_data.qid } ;
  smon_val [ 5 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 6 * 1 +: 1 ]                                  = fifo_dp_lsp_enq_dir_push ;
  smon_comp [ 6 * 32 +: 32 ]                             = { 25'd0 , fifo_dp_lsp_enq_dir_push_data.qid } ;
  smon_val [ 6 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 7 * 1 +: 1 ]                                  = fifo_dp_lsp_enq_rorply_push ;
  smon_comp [ 7 * 32 +: 32 ]                             = { 25'd0 , fifo_dp_lsp_enq_rorply_push_data.qid } ;
  smon_val [ 7 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 8 * 1 +: 1 ]                                  = 1'b0 ;
  smon_comp [ 8 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 8 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 9 * 1 +: 1 ]                                  = 1'b0 ;
  smon_comp [ 9 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 9 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 10 * 1 +: 1 ]                                 = tx_sync_dp_dqed_v & ~ tx_sync_dp_dqed_ready ;
  smon_comp [ 10 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 10 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 11 * 1 +: 1 ]                                 = tx_sync_dp_lsp_enq_rorply_v & ~ tx_sync_dp_lsp_enq_rorply_ready ;
  smon_comp [ 11 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 11 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 12 * 1 +: 1 ]                                 = tx_sync_dp_lsp_enq_dir_v & ~ tx_sync_dp_lsp_enq_dir_ready ;
  smon_comp [ 12 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 12 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 13 * 1 +: 1 ]                                 = rx_sync_lsp_dp_sch_rorply_v & ~ rx_sync_lsp_dp_sch_rorply_ready ;
  smon_comp [ 13 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 13 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 14 * 1 +: 1 ]                                 = rx_sync_lsp_dp_sch_dir_v & ~ rx_sync_lsp_dp_sch_dir_ready ;
  smon_comp [ 14 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 14 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 15 * 1 +: 1 ]                                 = rx_sync_rop_dp_enq_v & ~ rx_sync_rop_dp_enq_ready ;
  smon_comp [ 15 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 15 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 16 * 1 +: 1 ]                                 = stall ;
  smon_comp [ 16 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 16 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 17 * 1 +: 1 ]                                 = dir_stall_f [ 4 ] ;
  smon_comp [ 17 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 17 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 18 * 1 +: 1 ]                                 = ordered_stall_f [ 7 ] ;
  smon_comp [ 18 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 18 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 19 * 1 +: 1 ]                                 = 1'b0 ;
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


  cfg_control6_nxt [ 0 ] = cfg_control6_f_pnc [ 0 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 1 ] = cfg_control6_f_pnc [ 1 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 1 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 2 ] = cfg_control6_f_pnc [ 2 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 2 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 3 ] = cfg_control6_f_pnc [ 3 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 3 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 4 ] = cfg_control6_f_pnc [ 4 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 4 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 5 ] = cfg_control6_f_pnc [ 5 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 5 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 6 ] = cfg_control6_f_pnc [ 6 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 6 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 7 ] = cfg_control6_f_pnc [ 7 ] | ( func_dir_cnt_we & ( | wire_func_dir_cnt_wdata [ ( 7 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 8 ] = cfg_control6_f_pnc [ 8 ] | ( func_dir_rofrag_cnt_we & ( | func_dir_rofrag_cnt_wdata [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 16 ] = cfg_control6_f_pnc [ 16 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 17 ] = cfg_control6_f_pnc [ 17 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 1 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 18 ] = cfg_control6_f_pnc [ 18 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 2 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 19 ] = cfg_control6_f_pnc [ 19 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 3 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 20 ] = cfg_control6_f_pnc [ 20 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 4 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 21 ] = cfg_control6_f_pnc [ 21 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 5 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 22 ] = cfg_control6_f_pnc [ 22 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 6 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;
  cfg_control6_nxt [ 23 ] = cfg_control6_f_pnc [ 23 ] | ( func_dir_replay_cnt_we & ( | wire_func_dir_replay_cnt_wdata [ ( 7 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] ) ) ;

  cfg_control7_nxt [ 0 ] = cfg_control7_f_pnc [ 0 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 1 ] = cfg_control7_f_pnc [ 1 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 1 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 2 ] = cfg_control7_f_pnc [ 2 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 2 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 3 ] = cfg_control7_f_pnc [ 3 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 3 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 4 ] = cfg_control7_f_pnc [ 4 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 4 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 5 ] = cfg_control7_f_pnc [ 5 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 5 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 6 ] = cfg_control7_f_pnc [ 6 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 6 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 7 ] = cfg_control7_f_pnc [ 7 ] | ( func_dir_cnt_we & ( wire_func_dir_cnt_wdata [ ( 7 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 8 ] = cfg_control7_f_pnc [ 8 ] | ( func_dir_rofrag_cnt_we & ( func_dir_rofrag_cnt_wdata [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 16 ] = cfg_control7_f_pnc [ 16 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 0 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 17 ] = cfg_control7_f_pnc [ 17 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 1 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 18 ] = cfg_control7_f_pnc [ 18 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 2 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 19 ] = cfg_control7_f_pnc [ 19 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 3 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 20 ] = cfg_control7_f_pnc [ 20 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 4 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 )  ) ;
  cfg_control7_nxt [ 21 ] = cfg_control7_f_pnc [ 21 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 5 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 22 ] = cfg_control7_f_pnc [ 22 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 6 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;
  cfg_control7_nxt [ 23 ] = cfg_control7_f_pnc [ 23 ] | ( func_dir_replay_cnt_we & ( wire_func_dir_replay_cnt_wdata [ ( 7 * HQM_DP_CNTB2 ) +: HQM_DP_CNTB2 ] == 'd4096 ) ) ;

  cfg_control7_nxt [ 31 ] = cfg_control7_f_pnc [ 31 ] | ( | int_inf_v ) ;


  //control CFG access. Queue the CFG access until the pipe is idle then issue the reqeust and keep the pipe idle until complete
  cfg_req_ready = cfg_unit_idle_f.cfg_ready ;
  cfg_unit_idle_nxt.cfg_ready                   =  ( ( cfg_unit_idle_nxt.pipe_idle )
                                                   ) ;

end

//tieoff machine inserted code
logic tieoff_nc ;
assign tieoff_nc = 
//reuse modules inserted by script cannot include _nc
  ( | hqm_dp_target_cfg_smon_smon_enabled )
| ( | hqm_dp_target_cfg_smon_smon_interrupt )
| ( | hqm_dp_target_cfg_syndrome_00_syndrome_data )
| ( | hqm_dp_target_cfg_syndrome_01_syndrome_data )
| ( | cfg_interface_f )
| ( | cfg_pipe_health_hold_00_f )
| ( | cfg_pipe_health_valid_00_f )
| ( | pf_dir_nxthp_rdata )
| ( | pf_dp_lsp_enq_dir_rdata )
| ( | pf_rx_sync_rop_dp_enq_rdata )
| ( | pf_dir_replay_cnt_wdata )
| ( | pf_dir_replay_cnt_rdata )
| ( | pf_dir_cnt_wdata )
| ( | pf_dir_cnt_rdata )
| ( | pf_dir_replay_hp_rdata )
| ( | pf_lsp_dp_sch_dir_rdata )
| ( | pf_rx_sync_lsp_dp_sch_dir_rdata )
| ( | pf_rop_dp_enq_dir_rdata )
| ( | pf_dir_rofrag_hp_rdata )
| ( | pf_dir_tp_rdata )
| ( | pf_dp_dqed_rdata )
| ( | pf_dir_hp_rdata )
| ( | pf_rx_sync_lsp_dp_sch_rorply_rdata )
| ( | pf_rop_dp_enq_ro_rdata )
| ( | pf_dir_rofrag_cnt_wdata )
| ( | pf_dir_rofrag_cnt_rdata )
| ( | pf_dp_lsp_enq_rorply_rdata )
| ( | pf_dir_replay_tp_rdata )
| ( | pf_lsp_dp_sch_rorply_rdata )
| ( | pf_dir_rofrag_tp_rdata )
| ( | cfg_req_write )
| ( | cfg_req_read )
| ( | int_status_pnc )
//cannot mark part of struct with _nc for pipe levels it is not used
| ( | p5_dir_ctrl [1] )
| ( | p8_dir_ctrl [1] )
| ( | p0_dir_ctrl [1] )
| ( | p2_dir_ctrl [1] )
| ( | p3_dir_ctrl [1] )
| ( | p4_dir_ctrl [1] )
| ( | p7_dir_ctrl [1] )
| ( | p9_dir_ctrl [1] )
| ( | p1_dir_ctrl [1] )
| ( | p9_rofrag_ctrl [1] )
| ( | p3_rofrag_ctrl [1] )
| ( | p2_rofrag_ctrl [1] )
| ( | p1_rofrag_ctrl [1] )
| ( | p5_rofrag_ctrl [1] )
| ( | p7_rofrag_ctrl [1] )
| ( | p8_rofrag_ctrl [1] )
| ( | p0_rofrag_ctrl [1] )
| ( | p4_rofrag_ctrl [1] )
| ( | p5_replay_ctrl [1] )
| ( | p8_replay_ctrl [1] )
| ( | p2_replay_ctrl [1] )
| ( | p3_replay_ctrl [1] )
| ( | p1_replay_ctrl [1] )
| ( | p0_replay_ctrl [1] )
| ( | p4_replay_ctrl [1] )
| ( | p7_replay_ctrl [1] )
| ( | p9_replay_ctrl [1] )
//nets tied to '0 reported as 70036
| ( | pf_dir_replay_cnt_wdata )
| ( | pf_dir_cnt_wdata )
| ( | pf_dir_rofrag_cnt_wdata )
//paritally used strucutre, put here to avoid _pnc suffix
| ( | fifo_rop_dp_enq_dir_pop_data )
;



endmodule // hqm_dir_pipe_core
