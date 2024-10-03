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
module hqm_lsp_wu_pipe
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
# (
    parameter NUM_CQ                    = HQM_LSP_ARCH_NUM_LB_CQ                 // Scaling for jg
  , parameter WU_CNT_WIDTH              = HQM_LSP_LBWU_CQ_WU_CNT_WIDTH           // Scaling for jg
  , parameter DEPTH_QED_LSP_DEQ_FIFO    = 24                                     // Scaling for jg
  , parameter DEPTH_AQED_LSP_DEQ_FIFO   = 24                                     // Scaling for jg

//................
  , parameter WU_LIM_WIDTH                      = ( WU_CNT_WIDTH-2 )                                    // Scaling for jg
  , parameter NUM_CQB2                          = ( AW_logb2 ( NUM_CQ - 1 ) + 1 )                       // Scaling for jg
  , parameter DEPTH_QED_LSP_DEQ_FIFOB2          = ( AW_logb2 ( DEPTH_QED_LSP_DEQ_FIFO - 1 ) + 1 )       // Scaling for jg
  , parameter DEPTH_AQED_LSP_DEQ_FIFOB2         = ( AW_logb2 ( DEPTH_AQED_LSP_DEQ_FIFO - 1 ) + 1 )      // Scaling for jg
  , parameter QED_LSP_DEQ_SCALED_WMWIDTH        = ( AW_logb2 ( DEPTH_QED_LSP_DEQ_FIFO + 1 ) + 1 )       // Scaling for jg
  , parameter AQED_LSP_DEQ_SCALED_WMWIDTH       = ( AW_logb2 ( DEPTH_AQED_LSP_DEQ_FIFO + 1 ) + 1 )      // Scaling for jg
  , parameter QED_LSP_DEQ_SCALED_WIDTH          = ( 1 + NUM_CQB2 + 2 )                                  // Scaling for jg
  , parameter AQED_LSP_DEQ_SCALED_WIDTH         = ( 1 + NUM_CQB2 + 2 )                                  // Scaling for jg
) (
  input  logic                                  hqm_gated_clk
, input  logic                                  hqm_gated_rst_n

, input  logic [QED_LSP_DEQ_SCALED_WMWIDTH-1:0]         cfg_control_qed_lsp_deq_high_pri_wm
, input  logic [AQED_LSP_DEQ_SCALED_WMWIDTH-1:0]        cfg_control_aqed_lsp_deq_high_pri_wm
, input  logic                                  cfg_control_qe_wt_blk
, input  logic                                  cfg_control_qe_wt_frc_v
, input  logic [1:0]                            cfg_control_qe_wt_frc_val
, input  logic                                  cfg_control_disable_wu_res_chk
, input  logic [7:0]                            cfg_qed_deq_pipeline_credit_limit_pnc
, input  logic [7:0]                            cfg_aqed_deq_pipeline_credit_limit_pnc

, input  logic [19:0]                           cfg_mem_addr
, input  logic [31:0]                           cfgsc_cfg_mem_wdata
, input  logic                                  cfgsc_cfg_mem_wdata_par
, input  logic [1:0]                            cfgsc_cfg_mem_wdata_res
, output logic [31:0]                           cfgsc_wu_cfg_data_f

, input  logic                                  cfgsc_cq_ldb_wu_count_mem_re
, input  logic                                  cfgsc_cq_ldb_wu_count_mem_we
, input  logic                                  cfgsc_cfg_cq_ldb_wu_limit_mem_re
, input  logic                                  cfgsc_cfg_cq_ldb_wu_limit_mem_we

, output logic                                  cfgsc_wu_count_wr_ack
, output logic                                  cfgsc_wu_count_rd_ack
, output logic                                  cfgsc_wu_limit_wr_ack
, output logic                                  cfgsc_wu_limit_rd_ack

, input  logic                                  qed_lsp_deq_v
, input  logic                                  qed_lsp_deq_data_parity
, input  logic [NUM_CQB2-1:0]                   qed_lsp_deq_data_cq
, input  logic [1:0]                            qed_lsp_deq_data_qe_wt

, output logic                                  qed_lsp_deq_fifo_of
, output logic                                  qed_lsp_deq_fifo_uf
, output logic                                  qed_lsp_deq_fifo_empty

, input  logic                                  aqed_lsp_deq_v
, input  logic                                  aqed_lsp_deq_data_parity
, input  logic [NUM_CQB2-1:0]                   aqed_lsp_deq_data_cq
, input  logic [1:0]                            aqed_lsp_deq_data_qe_wt

, output logic                                  aqed_lsp_deq_fifo_of
, output logic                                  aqed_lsp_deq_fifo_uf
, output logic                                  aqed_lsp_deq_fifo_empty

, input  logic                                  p0_lba_nalb_credit_count_inc
, input  logic                                  p4_lba_nalb_credit_count_dec_miss
, input  logic                                  p4_lba_atm_credit_count_dec_miss
, output logic                                  qed_deq_credit_error
, output logic                                  qed_deq_credit_empty
, output logic                                  qed_deq_credit_afull
, output logic                                  aqed_deq_credit_error
, output logic                                  aqed_deq_credit_empty
, output logic                                  aqed_deq_credit_afull

, input  logic [NUM_CQB2-1:0]                   lbi_inp_cq_cmp_cq
, input  logic [1:0]                            lbi_inp_cq_cmp_qe_wt
, input  logic                                  lbi_inp_cq_cmp_cq_wt_p
, input  logic                                  lbi_cq_cmp_req_taken
, output logic                                  p0_lba_supress_cq_cmp

, input  logic                                  p0_lba_sch_state_ready_for_work

, output logic                                  p3_lbwu_cq_wu_cnt_upd_v_func

, output logic                                  p4_lbwu_cq_wu_cnt_upd_v_f
, output logic [NUM_CQB2-1:0]                   p4_lbwu_cq_wu_cnt_upd_cq_f
, output logic                                  p4_lbwu_cq_wu_cnt_upd_gt_lim_f

, output logic                                  p1_lbwu_ctrl_pipe_v_f
, output logic                                  p2_lbwu_ctrl_pipe_v_f
, output logic                                  p3_lbwu_ctrl_pipe_v_f
, output logic                                  p4_lbwu_ctrl_pipe_v_f

, output logic                                  lbwu_cq_wu_cnt_rmw_pipe_status

, output logic                                  p3_lbwu_cq_wu_cnt_res_err_cond
, output logic                                  p3_lbwu_cq_wu_lim_par_err_cond
, output logic                                  p3_lbwu_inp_par_err_cond

, output logic                                  smon_qed_lsp_deq_v
, output logic                                  smon_qed_lsp_deq_data_parity
, output logic [NUM_CQB2-1:0]                   smon_qed_lsp_deq_data_cq
, output logic [1:0]                            smon_qed_lsp_deq_data_qe_wt

, output logic                                  smon_aqed_lsp_deq_v
, output logic                                  smon_aqed_lsp_deq_data_parity
, output logic [NUM_CQB2-1:0]                   smon_aqed_lsp_deq_data_cq
, output logic [1:0]                            smon_aqed_lsp_deq_data_qe_wt

, output logic                                  func_qed_lsp_deq_fifo_mem_re
, output logic [DEPTH_QED_LSP_DEQ_FIFOB2-1:0]   func_qed_lsp_deq_fifo_mem_raddr
, output logic [DEPTH_QED_LSP_DEQ_FIFOB2-1:0]   func_qed_lsp_deq_fifo_mem_waddr
, output logic                                  func_qed_lsp_deq_fifo_mem_we
, output logic [QED_LSP_DEQ_SCALED_WIDTH-1:0]   func_qed_lsp_deq_fifo_mem_wdata
, input  logic [QED_LSP_DEQ_SCALED_WIDTH-1:0]   func_qed_lsp_deq_fifo_mem_rdata

, output logic                                  func_aqed_lsp_deq_fifo_mem_re
, output logic [DEPTH_AQED_LSP_DEQ_FIFOB2-1:0]  func_aqed_lsp_deq_fifo_mem_raddr
, output logic [DEPTH_AQED_LSP_DEQ_FIFOB2-1:0]  func_aqed_lsp_deq_fifo_mem_waddr
, output logic                                  func_aqed_lsp_deq_fifo_mem_we
, output logic [AQED_LSP_DEQ_SCALED_WIDTH-1:0]  func_aqed_lsp_deq_fifo_mem_wdata
, input  logic [AQED_LSP_DEQ_SCALED_WIDTH-1:0]  func_aqed_lsp_deq_fifo_mem_rdata

, output logic                                  func_cq_ldb_wu_count_mem_re
, output logic [NUM_CQB2-1:0]                   func_cq_ldb_wu_count_mem_raddr
, output logic [NUM_CQB2-1:0]                   func_cq_ldb_wu_count_mem_waddr
, output logic                                  func_cq_ldb_wu_count_mem_we
, output logic [(2+WU_CNT_WIDTH)-1:0]           func_cq_ldb_wu_count_mem_wdata
, input  logic [(2+WU_CNT_WIDTH)-1:0]           func_cq_ldb_wu_count_mem_rdata

, output logic                                  func_cfg_cq_ldb_wu_limit_mem_re
, output logic [NUM_CQB2-1:0]                   func_cfg_cq_ldb_wu_limit_mem_raddr
, output logic [NUM_CQB2-1:0]                   func_cfg_cq_ldb_wu_limit_mem_waddr
, output logic                                  func_cfg_cq_ldb_wu_limit_mem_we
, output logic [(1+1+WU_LIM_WIDTH)-1:0]         func_cfg_cq_ldb_wu_limit_mem_wdata
, input  logic [(1+1+WU_LIM_WIDTH)-1:0]         func_cfg_cq_ldb_wu_limit_mem_rdata
) ;

logic                                           qed_lsp_deq_fifo_push ;
logic [QED_LSP_DEQ_SCALED_WIDTH-1:0]            qed_lsp_deq_fifo_push_data ;
logic                                           qed_lsp_deq_fifo_pop ;
logic [QED_LSP_DEQ_SCALED_WIDTH-1:0]            qed_lsp_deq_fifo_pop_data ;
logic                                           qed_lsp_deq_fifo_pop_data_parity ;
logic [NUM_CQB2-1:0]                            qed_lsp_deq_fifo_pop_data_cq ;
logic [1:0]                                     qed_lsp_deq_fifo_pop_data_qe_wt ;
logic [QED_LSP_DEQ_SCALED_WMWIDTH-1:0]          qed_lsp_deq_fifo_hwm ;
logic                                           qed_lsp_deq_fifo_full_nc ;
logic                                           qed_lsp_deq_fifo_afull_nc ;
aw_fifo_status_t                                qed_lsp_deq_fifo_status_pnc ;
logic [23:0]                                    cfg_control_qed_lsp_deq_high_pri_wm_padded ;
logic                                           qed_lsp_deq_high_pri ;

logic                                           aqed_lsp_deq_fifo_push ;
logic [AQED_LSP_DEQ_SCALED_WIDTH-1:0]           aqed_lsp_deq_fifo_push_data ;
logic                                           aqed_lsp_deq_fifo_pop ;
logic [AQED_LSP_DEQ_SCALED_WIDTH-1:0]           aqed_lsp_deq_fifo_pop_data ;
logic                                           aqed_lsp_deq_fifo_pop_data_parity ;
logic [NUM_CQB2-1:0]                            aqed_lsp_deq_fifo_pop_data_cq ;
logic [1:0]                                     aqed_lsp_deq_fifo_pop_data_qe_wt ;
logic [AQED_LSP_DEQ_SCALED_WMWIDTH-1:0]         aqed_lsp_deq_fifo_hwm ;
logic                                           aqed_lsp_deq_fifo_full_nc ;
logic                                           aqed_lsp_deq_fifo_afull_nc ;
aw_fifo_status_t                                aqed_lsp_deq_fifo_status_pnc ;
logic [23:0]                                    cfg_control_aqed_lsp_deq_high_pri_wm_padded ;
logic                                           aqed_lsp_deq_high_pri ;

logic                                           qed_deq_credit_alloc ;
logic                                           qed_deq_credit_dealloc_miss ;
logic                                           qed_deq_credit_dealloc_hit ;
logic                                           qed_deq_credit_full_nc ;
logic [4:0]                                     qed_deq_credit_size_nc ;

logic                                           aqed_deq_credit_alloc ;
logic                                           aqed_deq_credit_dealloc_miss ;
logic                                           aqed_deq_credit_dealloc_hit ;
logic                                           aqed_deq_credit_full_nc ;
logic [4:0]                                     aqed_deq_credit_size_nc ;


assign qed_lsp_deq_fifo_push            = qed_lsp_deq_v & ~ cfg_control_qe_wt_blk ;
assign qed_lsp_deq_fifo_push_data       = { qed_lsp_deq_data_parity , qed_lsp_deq_data_cq , qed_lsp_deq_data_qe_wt } ;
assign qed_lsp_deq_fifo_hwm             = DEPTH_QED_LSP_DEQ_FIFO [QED_LSP_DEQ_SCALED_WMWIDTH-1:0] ;
assign { qed_lsp_deq_fifo_pop_data_parity , qed_lsp_deq_fifo_pop_data_cq , qed_lsp_deq_fifo_pop_data_qe_wt }    = qed_lsp_deq_fifo_pop_data ;
 
hqm_AW_fifo_control #(
          .DEPTH                ( DEPTH_QED_LSP_DEQ_FIFO )
        , .DWIDTH               ( QED_LSP_DEQ_SCALED_WIDTH )
) i_hqm_AW_fifo_control_qed_lsp_deq_if_fifo (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )

        , .push                 ( qed_lsp_deq_fifo_push )
        , .push_data            ( qed_lsp_deq_fifo_push_data )
        , .pop                  ( qed_lsp_deq_fifo_pop )
        , .pop_data             ( qed_lsp_deq_fifo_pop_data )

        , .cfg_high_wm          ( qed_lsp_deq_fifo_hwm )

        , .mem_we               ( func_qed_lsp_deq_fifo_mem_we )
        , .mem_waddr            ( func_qed_lsp_deq_fifo_mem_waddr )
        , .mem_wdata            ( func_qed_lsp_deq_fifo_mem_wdata )
        , .mem_re               ( func_qed_lsp_deq_fifo_mem_re )
        , .mem_raddr            ( func_qed_lsp_deq_fifo_mem_raddr )
        , .mem_rdata            ( func_qed_lsp_deq_fifo_mem_rdata )


        , .fifo_status          ( qed_lsp_deq_fifo_status_pnc )
        , .fifo_full            ( qed_lsp_deq_fifo_full_nc )            // Controlled by credits
        , .fifo_afull           ( qed_lsp_deq_fifo_afull_nc )           // Controlled by credits
        , .fifo_empty           ( qed_lsp_deq_fifo_empty )
) ;

assign aqed_lsp_deq_fifo_push            = aqed_lsp_deq_v & ~ cfg_control_qe_wt_blk ;
assign aqed_lsp_deq_fifo_push_data       = { aqed_lsp_deq_data_parity , aqed_lsp_deq_data_cq , aqed_lsp_deq_data_qe_wt } ;
assign aqed_lsp_deq_fifo_hwm             = DEPTH_AQED_LSP_DEQ_FIFO [AQED_LSP_DEQ_SCALED_WMWIDTH-1:0] ;
assign { aqed_lsp_deq_fifo_pop_data_parity , aqed_lsp_deq_fifo_pop_data_cq , aqed_lsp_deq_fifo_pop_data_qe_wt } = aqed_lsp_deq_fifo_pop_data ;
 
hqm_AW_fifo_control #(
          .DEPTH                ( DEPTH_AQED_LSP_DEQ_FIFO )
        , .DWIDTH               ( AQED_LSP_DEQ_SCALED_WIDTH )
) i_hqm_AW_fifo_control_aqed_lsp_deq_if_fifo (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )

        , .push                 ( aqed_lsp_deq_fifo_push )
        , .push_data            ( aqed_lsp_deq_fifo_push_data )
        , .pop                  ( aqed_lsp_deq_fifo_pop )
        , .pop_data             ( aqed_lsp_deq_fifo_pop_data )

        , .cfg_high_wm          ( aqed_lsp_deq_fifo_hwm )

        , .mem_we               ( func_aqed_lsp_deq_fifo_mem_we )
        , .mem_waddr            ( func_aqed_lsp_deq_fifo_mem_waddr )
        , .mem_wdata            ( func_aqed_lsp_deq_fifo_mem_wdata )
        , .mem_re               ( func_aqed_lsp_deq_fifo_mem_re )
        , .mem_raddr            ( func_aqed_lsp_deq_fifo_mem_raddr )
        , .mem_rdata            ( func_aqed_lsp_deq_fifo_mem_rdata )


        , .fifo_status          ( aqed_lsp_deq_fifo_status_pnc )
        , .fifo_full            ( aqed_lsp_deq_fifo_full_nc )           // Controlled by credits
        , .fifo_afull           ( aqed_lsp_deq_fifo_afull_nc )          // Controlled by credits
        , .fifo_empty           ( aqed_lsp_deq_fifo_empty )
) ;


always_comb begin
  cfg_control_qed_lsp_deq_high_pri_wm_padded                                    = '0 ;
  cfg_control_qed_lsp_deq_high_pri_wm_padded [QED_LSP_DEQ_SCALED_WMWIDTH-1:0]   = cfg_control_qed_lsp_deq_high_pri_wm ;
  cfg_control_aqed_lsp_deq_high_pri_wm_padded                                   = '0 ;
  cfg_control_aqed_lsp_deq_high_pri_wm_padded [AQED_LSP_DEQ_SCALED_WMWIDTH-1:0] = cfg_control_aqed_lsp_deq_high_pri_wm ;

  qed_lsp_deq_fifo_of                           = qed_lsp_deq_fifo_status_pnc.overflow ;
  qed_lsp_deq_fifo_uf                           = qed_lsp_deq_fifo_status_pnc.underflow ;
  aqed_lsp_deq_fifo_of                          = aqed_lsp_deq_fifo_status_pnc.overflow ;
  aqed_lsp_deq_fifo_uf                          = aqed_lsp_deq_fifo_status_pnc.underflow ;
end // always

assign qed_lsp_deq_high_pri                     = ( qed_lsp_deq_fifo_status_pnc.depth >= cfg_control_qed_lsp_deq_high_pri_wm_padded ) ;
assign aqed_lsp_deq_high_pri                    = ( aqed_lsp_deq_fifo_status_pnc.depth >= cfg_control_aqed_lsp_deq_high_pri_wm_padded ) ;

assign smon_qed_lsp_deq_v                       = qed_lsp_deq_fifo_pop ;
assign smon_qed_lsp_deq_data_parity             = qed_lsp_deq_fifo_pop_data_parity ;
assign smon_qed_lsp_deq_data_cq                 = qed_lsp_deq_fifo_pop_data_cq ;
assign smon_qed_lsp_deq_data_qe_wt              = qed_lsp_deq_fifo_pop_data_qe_wt ;

assign smon_aqed_lsp_deq_v                      = aqed_lsp_deq_fifo_pop ;
assign smon_aqed_lsp_deq_data_parity            = aqed_lsp_deq_fifo_pop_data_parity ;
assign smon_aqed_lsp_deq_data_cq                = aqed_lsp_deq_fifo_pop_data_cq ;
assign smon_aqed_lsp_deq_data_qe_wt             = aqed_lsp_deq_fifo_pop_data_qe_wt ;

hqm_lsp_wu_ctrl # (
          .NUM_CQ                                       ( NUM_CQ )
        , .WU_CNT_WIDTH                                 ( WU_CNT_WIDTH )
) i_hqm_lsp_wu_ctrl (
          .clk                                          ( hqm_gated_clk )
        , .rst_n                                        ( hqm_gated_rst_n )

        , .cfg_control_qe_wt_blk                        ( cfg_control_qe_wt_blk )
        , .cfg_control_qe_wt_frc_v                      ( cfg_control_qe_wt_frc_v )
        , .cfg_control_qe_wt_frc_val                    ( cfg_control_qe_wt_frc_val )
        , .cfg_control_disable_wu_res_chk               ( cfg_control_disable_wu_res_chk )

        , .cfg_mem_addr                                 ( cfg_mem_addr )
        , .cfgsc_cfg_mem_wdata                          ( cfgsc_cfg_mem_wdata )
        , .cfgsc_cfg_mem_wdata_par                      ( cfgsc_cfg_mem_wdata_par )
        , .cfgsc_cfg_mem_wdata_res                      ( cfgsc_cfg_mem_wdata_res )
        , .cfgsc_wu_cfg_data_f                          ( cfgsc_wu_cfg_data_f )

        , .cfgsc_cq_ldb_wu_count_mem_re                 ( cfgsc_cq_ldb_wu_count_mem_re )
        , .cfgsc_cq_ldb_wu_count_mem_we                 ( cfgsc_cq_ldb_wu_count_mem_we )
        , .cfgsc_cfg_cq_ldb_wu_limit_mem_re             ( cfgsc_cfg_cq_ldb_wu_limit_mem_re )
        , .cfgsc_cfg_cq_ldb_wu_limit_mem_we             ( cfgsc_cfg_cq_ldb_wu_limit_mem_we )

        , .cfgsc_wu_count_wr_ack                        ( cfgsc_wu_count_wr_ack )
        , .cfgsc_wu_count_rd_ack                        ( cfgsc_wu_count_rd_ack )
        , .cfgsc_wu_limit_wr_ack                        ( cfgsc_wu_limit_wr_ack )
        , .cfgsc_wu_limit_rd_ack                        ( cfgsc_wu_limit_rd_ack )

        , .qed_lsp_deq_fifo_empty                       ( qed_lsp_deq_fifo_empty )
        , .qed_lsp_deq_fifo_pop_data_parity             ( qed_lsp_deq_fifo_pop_data_parity )
        , .qed_lsp_deq_fifo_pop_data_cq                 ( qed_lsp_deq_fifo_pop_data_cq )
        , .qed_lsp_deq_fifo_pop_data_qe_wt              ( qed_lsp_deq_fifo_pop_data_qe_wt )
        , .qed_lsp_deq_fifo_pop                         ( qed_lsp_deq_fifo_pop )

        , .aqed_lsp_deq_fifo_empty                      ( aqed_lsp_deq_fifo_empty )
        , .aqed_lsp_deq_fifo_pop_data_parity            ( aqed_lsp_deq_fifo_pop_data_parity )
        , .aqed_lsp_deq_fifo_pop_data_cq                ( aqed_lsp_deq_fifo_pop_data_cq )
        , .aqed_lsp_deq_fifo_pop_data_qe_wt             ( aqed_lsp_deq_fifo_pop_data_qe_wt )
        , .aqed_lsp_deq_fifo_pop                        ( aqed_lsp_deq_fifo_pop )

        , .lbi_inp_cq_cmp_cq                            ( lbi_inp_cq_cmp_cq )
        , .lbi_inp_cq_cmp_qe_wt                         ( lbi_inp_cq_cmp_qe_wt )
        , .lbi_inp_cq_cmp_cq_wt_p                       ( lbi_inp_cq_cmp_cq_wt_p )
        , .lbi_cq_cmp_req_taken                         ( lbi_cq_cmp_req_taken )
        , .p0_lba_supress_cq_cmp                        ( p0_lba_supress_cq_cmp )

        , .p0_lba_sch_state_ready_for_work              ( p0_lba_sch_state_ready_for_work )
        , .qed_lsp_deq_high_pri                         ( qed_lsp_deq_high_pri )
        , .aqed_lsp_deq_high_pri                        ( aqed_lsp_deq_high_pri )

        , .p3_lbwu_cq_wu_cnt_upd_v_func                 ( p3_lbwu_cq_wu_cnt_upd_v_func )

        , .p4_lbwu_cq_wu_cnt_upd_v_f                    ( p4_lbwu_cq_wu_cnt_upd_v_f )
        , .p4_lbwu_cq_wu_cnt_upd_cq_f                   ( p4_lbwu_cq_wu_cnt_upd_cq_f )
        , .p4_lbwu_cq_wu_cnt_upd_gt_lim_f               ( p4_lbwu_cq_wu_cnt_upd_gt_lim_f )

        , .p1_lbwu_ctrl_pipe_v_f                        ( p1_lbwu_ctrl_pipe_v_f )
        , .p2_lbwu_ctrl_pipe_v_f                        ( p2_lbwu_ctrl_pipe_v_f )
        , .p3_lbwu_ctrl_pipe_v_f                        ( p3_lbwu_ctrl_pipe_v_f )
        , .p4_lbwu_ctrl_pipe_v_f                        ( p4_lbwu_ctrl_pipe_v_f )

        , .lbwu_cq_wu_cnt_rmw_pipe_status               ( lbwu_cq_wu_cnt_rmw_pipe_status )

        , .p3_lbwu_cq_wu_cnt_res_err_cond               ( p3_lbwu_cq_wu_cnt_res_err_cond )
        , .p3_lbwu_cq_wu_lim_par_err_cond               ( p3_lbwu_cq_wu_lim_par_err_cond )
        , .p3_lbwu_inp_par_err_cond                     ( p3_lbwu_inp_par_err_cond )

        , .func_cq_ldb_wu_count_mem_re                  ( func_cq_ldb_wu_count_mem_re )
        , .func_cq_ldb_wu_count_mem_raddr               ( func_cq_ldb_wu_count_mem_raddr )
        , .func_cq_ldb_wu_count_mem_waddr               ( func_cq_ldb_wu_count_mem_waddr )
        , .func_cq_ldb_wu_count_mem_we                  ( func_cq_ldb_wu_count_mem_we )
        , .func_cq_ldb_wu_count_mem_wdata               ( func_cq_ldb_wu_count_mem_wdata )
        , .func_cq_ldb_wu_count_mem_rdata               ( func_cq_ldb_wu_count_mem_rdata )

        , .func_cfg_cq_ldb_wu_limit_mem_re              ( func_cfg_cq_ldb_wu_limit_mem_re )
        , .func_cfg_cq_ldb_wu_limit_mem_raddr           ( func_cfg_cq_ldb_wu_limit_mem_raddr )
        , .func_cfg_cq_ldb_wu_limit_mem_waddr           ( func_cfg_cq_ldb_wu_limit_mem_waddr )
        , .func_cfg_cq_ldb_wu_limit_mem_we              ( func_cfg_cq_ldb_wu_limit_mem_we )
        , .func_cfg_cq_ldb_wu_limit_mem_wdata           ( func_cfg_cq_ldb_wu_limit_mem_wdata )
        , .func_cfg_cq_ldb_wu_limit_mem_rdata           ( func_cfg_cq_ldb_wu_limit_mem_rdata )
) ;


assign qed_deq_credit_alloc             = p0_lba_nalb_credit_count_inc & ~ cfg_control_qe_wt_blk ;      // inc for nalb or atm, don't know which yet
assign qed_deq_credit_dealloc_miss      = p4_lba_nalb_credit_count_dec_miss & ~ cfg_control_qe_wt_blk ; // dec, is atm, should not have inc
assign qed_deq_credit_dealloc_hit       = qed_lsp_deq_fifo_pop & ~ cfg_control_qe_wt_blk ;

hqm_AW_control_credits # (
   .DEPTH                             ( DEPTH_QED_LSP_DEQ_FIFO )
 , .NUM_A                             ( 1 )
 , .NUM_D                             ( 2 )
) i_hqm_AW_control_credits_qed_deq (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .alloc                             ( qed_deq_credit_alloc )
 , .dealloc                           ( { qed_deq_credit_dealloc_hit , qed_deq_credit_dealloc_miss } )
 , .empty                             ( qed_deq_credit_empty )
 , .full                              ( qed_deq_credit_full_nc )
 , .size                              ( qed_deq_credit_size_nc )
 , .error                             ( qed_deq_credit_error )
 , .hwm                               ( cfg_qed_deq_pipeline_credit_limit_pnc [4:0] )
 , .afull                             ( qed_deq_credit_afull )
) ;

assign aqed_deq_credit_alloc            = p0_lba_nalb_credit_count_inc & ~ cfg_control_qe_wt_blk ;      // inc for nalb or atm, don't know which yet
assign aqed_deq_credit_dealloc_miss     = p4_lba_atm_credit_count_dec_miss & ~ cfg_control_qe_wt_blk ;  // dec, is nalb, should not have inc
assign aqed_deq_credit_dealloc_hit      = aqed_lsp_deq_fifo_pop & ~ cfg_control_qe_wt_blk ;

hqm_AW_control_credits # (
   .DEPTH                             ( DEPTH_AQED_LSP_DEQ_FIFO )
 , .NUM_A                             ( 1 )
 , .NUM_D                             ( 2 )
) i_hqm_AW_control_credits_aqed_deq (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_n )
 , .alloc                             ( aqed_deq_credit_alloc )
 , .dealloc                           ( { aqed_deq_credit_dealloc_hit , aqed_deq_credit_dealloc_miss } )
 , .empty                             ( aqed_deq_credit_empty )
 , .full                              ( aqed_deq_credit_full_nc )
 , .size                              ( aqed_deq_credit_size_nc )
 , .error                             ( aqed_deq_credit_error )
 , .hwm                               ( cfg_aqed_deq_pipeline_credit_limit_pnc [4:0] )
 , .afull                             ( aqed_deq_credit_afull )
) ;

endmodule // hqm_lsp_wu_pipe
