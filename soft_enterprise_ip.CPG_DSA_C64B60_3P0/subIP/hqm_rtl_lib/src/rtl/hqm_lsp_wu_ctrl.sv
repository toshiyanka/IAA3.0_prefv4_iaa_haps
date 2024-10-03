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
module hqm_lsp_wu_ctrl
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
# (
    parameter NUM_CQ            = HQM_LSP_ARCH_NUM_LB_CQ                 // Scaling for jg
  , parameter WU_CNT_WIDTH      = HQM_LSP_LBWU_CQ_WU_CNT_WIDTH           // Scaling for jg
//................
  , parameter WU_LIM_WIDTH      = ( WU_CNT_WIDTH-2 )                     // Scaling for jg
  , parameter NUM_CQB2          = ( AW_logb2 ( NUM_CQ - 1 ) + 1 )        // Scaling for jg
) (
  input  logic                                  clk
, input  logic                                  rst_n

, input  logic                                  cfg_control_qe_wt_blk
, input  logic                                  cfg_control_qe_wt_frc_v
, input  logic [1:0]                            cfg_control_qe_wt_frc_val
, input  logic                                  cfg_control_disable_wu_res_chk

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

, input  logic                                  qed_lsp_deq_fifo_empty
, input  logic                                  qed_lsp_deq_fifo_pop_data_parity
, input  logic [NUM_CQB2-1:0]                   qed_lsp_deq_fifo_pop_data_cq
, input  logic [1:0]                            qed_lsp_deq_fifo_pop_data_qe_wt
, output logic                                  qed_lsp_deq_fifo_pop

, input  logic                                  aqed_lsp_deq_fifo_empty
, input  logic                                  aqed_lsp_deq_fifo_pop_data_parity
, input  logic [NUM_CQB2-1:0]                   aqed_lsp_deq_fifo_pop_data_cq
, input  logic [1:0]                            aqed_lsp_deq_fifo_pop_data_qe_wt
, output logic                                  aqed_lsp_deq_fifo_pop

, input  logic [NUM_CQB2-1:0]                   lbi_inp_cq_cmp_cq
, input  logic [1:0]                            lbi_inp_cq_cmp_qe_wt
, input  logic                                  lbi_inp_cq_cmp_cq_wt_p
, input  logic                                  lbi_cq_cmp_req_taken
, output logic                                  p0_lba_supress_cq_cmp

, input  logic                                  p0_lba_sch_state_ready_for_work
, input  logic                                  qed_lsp_deq_high_pri
, input  logic                                  aqed_lsp_deq_high_pri

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

localparam      HQM_LSP_DEQ_ARB_NALB            = 1'b0 ;
localparam      HQM_LSP_DEQ_ARB_ATM             = 1'b1 ;

//------------------------------------------------------------
// Scaling declarations - need to scale the cq for jg purposes
typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [WU_CNT_WIDTH-1:0] cnt ;
} lsp_lbwu_cq_wu_cnt_t ;

typedef struct packed {
  aw_rmwpipe_cmd_t                              rw_cmd ;
  logic  [NUM_CQB2-1:0]                         cq ;
  lsp_lbwu_cq_wu_cnt_t                          data ;
} lbwu_cq_wu_cnt_rmw_pipe_t ;

typedef struct packed {
  logic         lim_p ;
  logic         lim_v ;
  logic  [WU_LIM_WIDTH-1:0] lim ;
} lsp_lbwu_cq_wu_lim_t ;

typedef struct packed {
  aw_rmwpipe_cmd_t                              rw_cmd ;
  logic  [NUM_CQB2-1:0]                         cq ;
  lsp_lbwu_cq_wu_lim_t                          data ;
} lbwu_cq_wu_lim_rmw_pipe_t ;
//------------------------------------------------------------


logic                                           cfgsc_wu_count_wr ;
logic                                           cfgsc_wu_count_rd ;
logic                                           cfgsc_wu_limit_wr ;
logic                                           cfgsc_wu_limit_rd ;

logic [NUM_CQB2-1:0]                            cfgsc_wu_cfg_addr_nxt ;
logic [NUM_CQB2-1:0]                            cfgsc_wu_cfg_addr_f ;
logic [31:0]                                    cfgsc_wu_cfg_data_nxt ;
logic [1:0]                                     cfgsc_wu_cfg_ctrl_nxt ;
logic [1:0]                                     cfgsc_wu_cfg_ctrl_f ;
logic [3:0]                                     cfgsc_wu_cfg_sm_nxt ;
logic [3:0]                                     cfgsc_wu_cfg_sm_f ;

logic                                           cfgsc_wu_cfg_save_wdata_cnt ;
logic                                           cfgsc_wu_cfg_save_wdata_lim ;
logic                                           cfgsc_wu_cfg_save_rdata_cnt ;
logic                                           cfgsc_wu_cfg_save_rdata_lim ;

lsp_pipe_ctrl_t                                 p1_lbwu_ctrl_pipe_pnc ;
lsp_pipe_ctrl_t                                 p2_lbwu_ctrl_pipe_pnc ;
lsp_pipe_ctrl_t                                 p3_lbwu_ctrl_pipe_pnc ;

logic                                           p1_lbwu_ctrl_pipe_v_nxt ;
lbwu_ctrl_pipe_t                                p1_lbwu_ctrl_pipe_nxt ;
lbwu_ctrl_pipe_t                                p1_lbwu_ctrl_pipe_f ;
lbwu_ctrl_pipe_t                                p2_lbwu_ctrl_pipe_nxt ;
lbwu_ctrl_pipe_t                                p2_lbwu_ctrl_pipe_f ;
lbwu_ctrl_pipe_t                                p3_lbwu_ctrl_pipe_nxt ;
lbwu_ctrl_pipe_t                                p3_lbwu_ctrl_pipe_f ;

logic                                           cfgsc_wu_cfg_req_v ;
logic                                           p0_lba_wu_sel_deq ;
logic                                           p0_lba_wu_v ;

logic [1:0]                                     deq_arb_reqs ;
logic                                           deq_arb_winner_v ;
logic                                           deq_arb_winner ;
logic                                           deq_arb_update ;

logic                                           qed_lsp_deq_fifo_pop_data_v ;
logic                                           aqed_lsp_deq_fifo_pop_data_v ;

logic                                           xqed_lsp_deq_fifo_pop_data_parity ;
logic [NUM_CQB2-1:0]                            xqed_lsp_deq_fifo_pop_data_cq ;
logic [1:0]                                     xqed_lsp_deq_fifo_pop_data_qe_wt ;

lbwu_cq_wu_cnt_rmw_pipe_t                       p1_lbwu_cq_wu_cnt_rmw_pipe_nxt ;

aw_rmwpipe_cmd_t                                p1_lbwu_cq_wu_cnt_rmw_pipe_rw_f_nc ;
logic [NUM_CQB2-1:0]                            p1_lbwu_cq_wu_cnt_rmw_pipe_addr_f_nc ;
logic [(WU_CNT_WIDTH+2)-1:0]                    p1_lbwu_cq_wu_cnt_rmw_pipe_data_f_nc ;          // +2 for residue
aw_rmwpipe_cmd_t                                p2_lbwu_cq_wu_cnt_rmw_pipe_rw_f_nc ;
logic [NUM_CQB2-1:0]                            p2_lbwu_cq_wu_cnt_rmw_pipe_addr_f_nc ;
logic [(WU_CNT_WIDTH+2)-1:0]                    p2_lbwu_cq_wu_cnt_rmw_pipe_data_f_nc ;          // +2 for residue
lbwu_cq_wu_cnt_rmw_pipe_t                       p3_lbwu_cq_wu_cnt_rmw_pipe_f ;
aw_rmwpipe_cmd_t                                p4_lbwu_cq_wu_cnt_rmw_pipe_rw_f_nc ;
logic [NUM_CQB2-1:0]                            p4_lbwu_cq_wu_cnt_rmw_pipe_addr_f_nc ;
logic [(WU_CNT_WIDTH+2)-1:0]                    p4_lbwu_cq_wu_cnt_rmw_pipe_data_f_nc ;          // +2 for residue

lbwu_cq_wu_lim_rmw_pipe_t                       p1_lbwu_cq_wu_lim_rmw_pipe_nxt ;
lbwu_cq_wu_lim_rmw_pipe_t                       p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc ;
logic                                           lbwu_cq_wu_lim_rmw_pipe_status_nc ;

logic                                           p1_lbwu_cq_wu_lim_rmw_pipe_v_f_nc ;
aw_rmwpipe_cmd_t                                p1_lbwu_cq_wu_lim_rmw_pipe_rw_f_nc ;
logic [NUM_CQB2-1:0]                            p1_lbwu_cq_wu_lim_rmw_pipe_addr_f_nc ;
logic [(WU_LIM_WIDTH+2)-1:0]                    p1_lbwu_cq_wu_lim_rmw_pipe_data_f_nc ;          // +1 for v, +1 for parity
logic                                           p2_lbwu_cq_wu_lim_rmw_pipe_v_f_nc ;
aw_rmwpipe_cmd_t                                p2_lbwu_cq_wu_lim_rmw_pipe_rw_f_nc ;
logic [NUM_CQB2-1:0]                            p2_lbwu_cq_wu_lim_rmw_pipe_addr_f_nc ;
logic [(WU_LIM_WIDTH+2)-1:0]                    p2_lbwu_cq_wu_lim_rmw_pipe_data_f_nc ;          // +1 for v, +1 for parity
logic                                           p3_lbwu_cq_wu_lim_rmw_pipe_v_f_nc ;
logic                                           p4_lbwu_cq_wu_lim_rmw_pipe_v_f_nc ;
aw_rmwpipe_cmd_t                                p4_lbwu_cq_wu_lim_rmw_pipe_rw_f_nc ;
logic [NUM_CQB2-1:0]                            p4_lbwu_cq_wu_lim_rmw_pipe_addr_f_nc ;
logic [(WU_LIM_WIDTH+2)-1:0]                    p4_lbwu_cq_wu_lim_rmw_pipe_data_f_nc ;          // +1 for v, +1 for parity

logic [1:0]                                     p3_lbwu_ctrl_pipe_qe_wt ;
logic [3:0]                                     p3_lbwu_ctrl_pipe_qe_wu ;
logic [1:0]                                     p3_lbwu_ctrl_pipe_qe_wu_res ;
logic [1:0]                                     p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj ;

logic [1:0]                                     p3_lbwu_cq_wu_cnt_res_pn ;
logic [1:0]                                     p3_lbwu_cq_wu_cnt_res_mn ;
logic [1:0]                                     p3_lbwu_cq_wu_cnt_res_corr_amt ;
logic [1:0]                                     p3_lbwu_cq_wu_cnt_res_pn_corr ;
logic [1:0]                                     p3_lbwu_cq_wu_cnt_res_mn_corr ;
logic                                           p3_lbwu_cq_wu_cnt_go_pos ;
logic                                           p3_lbwu_cq_wu_cnt_go_neg ;
logic [WU_CNT_WIDTH-1:0]                        p3_lbwu_cq_wu_cnt_pn ;                  // Includes sign bit
logic [WU_CNT_WIDTH-1:0]                        p3_lbwu_cq_wu_cnt_mn ;                  // Includes sign bit
logic                                           p3_lbwu_cq_wu_cnt_flip_oflow_cond ;
logic                                           p3_lbwu_cq_wu_cnt_flip_uflow_cond ;
logic                                           p3_lbwu_cq_wu_cnt_flip_pos_cond ;
logic                                           p3_lbwu_cq_wu_cnt_flip_neg_cond ;
logic                                           p3_lbwu_cq_wu_cnt_res_chk_en ;
logic                                           p3_lbwu_cq_wu_lim_par_chk_en ;
logic                                           p3_lbwu_inp_par_chk_en ;

logic                                           p3_lbwu_cq_wu_cnt_upd_v ;
lsp_lbwu_cq_wu_cnt_t                            p3_lbwu_cq_wu_cnt_upd_cnt ;

logic                                           p3_lbwu_cq_wu_lim_upd_v ;
lsp_lbwu_cq_wu_lim_t                            p3_lbwu_cq_wu_lim_upd_lim ;

logic                                           p3_lbwu_cq_cfg_v ;

logic                                           p3_lbwu_cq_wu_cnt_upd_gt_lim ;
logic                                           p4_lbwu_cq_wu_cnt_upd_v_nxt ;
logic [NUM_CQB2-1:0]                            p4_lbwu_cq_wu_cnt_upd_cq_nxt ;
logic                                           p4_lbwu_cq_wu_cnt_upd_gt_lim_nxt ;

always_comb begin
  //*************************************************************************************************************************
  //**** For wu memories, pipe is not halted for config access, but need to support cfg access while lba and lbwu pipes  ****
  //**** are running.  When a config access to one of these regfiles is attempted by the sidecar:                        ****
  //**** - Intercept config access and record in regs, don't pass it on to ram_access                                    ****
  //**** - Next clock give it highest priority.  qed_lsp_deq and aqed_lsp_deq FIFOs are guaranteed to have room for      ****
  //****   any pushes which may come in since they are managed by credits.                                               ****
  //**** - Mux the config access into the appropriate wu rmw p1_nxt as a functional access would, with cmd="config"      ****
  //**** - When access reaches p3, determine which specific cfg access from saved state:                                 ****
  //****    - if cfg write, use rmw byp nxt input to write in the cfg data (with cfg-generated parity or residue)        ****
  //****    - if cfg read, use rmw data out as cfg response data                                                         ****
  //****    - for either cfg read or write, provide ack back for specific target when rx_sync is not afull               ****


  cfgsc_wu_cfg_ctrl_nxt                                         = cfgsc_wu_cfg_ctrl_f ;
  cfgsc_wu_cfg_sm_nxt                                           = cfgsc_wu_cfg_sm_f ;

  cfgsc_wu_cfg_addr_nxt                                         = cfgsc_wu_cfg_addr_f ;
  cfgsc_wu_cfg_data_nxt                                         = cfgsc_wu_cfg_data_f ;

  cfgsc_wu_cfg_req_v                                            = 1'b0 ;
  cfgsc_wu_count_wr_ack                                         = 1'b0 ;
  cfgsc_wu_count_rd_ack                                         = 1'b0 ;
  cfgsc_wu_limit_wr_ack                                         = 1'b0 ;
  cfgsc_wu_limit_rd_ack                                         = 1'b0 ;

  cfgsc_wu_cfg_save_wdata_cnt                                   = 1'b0 ;
  cfgsc_wu_cfg_save_wdata_lim                                   = 1'b0 ;
  cfgsc_wu_cfg_save_rdata_cnt                                   = 1'b0 ;
  cfgsc_wu_cfg_save_rdata_lim                                   = 1'b0 ;

  cfgsc_wu_count_wr                                             = ( cfgsc_wu_cfg_ctrl_f == HQM_LSP_LBWU_CFG_CTRL_WUCNT_WR ) ;
  cfgsc_wu_count_rd                                             = ( cfgsc_wu_cfg_ctrl_f == HQM_LSP_LBWU_CFG_CTRL_WUCNT_RD ) ;
  cfgsc_wu_limit_wr                                             = ( cfgsc_wu_cfg_ctrl_f == HQM_LSP_LBWU_CFG_CTRL_WULIM_WR ) ;
  cfgsc_wu_limit_rd                                             = ( cfgsc_wu_cfg_ctrl_f == HQM_LSP_LBWU_CFG_CTRL_WULIM_RD ) ;


  case ( cfgsc_wu_cfg_sm_f )
    HQM_LSP_LBWU_CFGSM_IDLE : begin
      if ( cfgsc_cq_ldb_wu_count_mem_we     | cfgsc_cq_ldb_wu_count_mem_re |
           cfgsc_cfg_cq_ldb_wu_limit_mem_we | cfgsc_cfg_cq_ldb_wu_limit_mem_re ) begin
        cfgsc_wu_cfg_sm_nxt                                     = HQM_LSP_LBWU_CFGSM_VLD ;
        //--------
        cfgsc_wu_cfg_addr_nxt                                   = cfg_mem_addr [NUM_CQB2-1:0] ;
        if ( cfgsc_cq_ldb_wu_count_mem_we ) begin
          cfgsc_wu_cfg_ctrl_nxt                                 = HQM_LSP_LBWU_CFG_CTRL_WUCNT_WR ;
          cfgsc_wu_cfg_save_wdata_cnt                           = 1'b1 ;
        end
        if ( cfgsc_cq_ldb_wu_count_mem_re ) begin
          cfgsc_wu_cfg_ctrl_nxt                                 = HQM_LSP_LBWU_CFG_CTRL_WUCNT_RD ;
        end
        if ( cfgsc_cfg_cq_ldb_wu_limit_mem_we ) begin
          cfgsc_wu_cfg_ctrl_nxt                                 = HQM_LSP_LBWU_CFG_CTRL_WULIM_WR ;
          cfgsc_wu_cfg_save_wdata_lim                           = 1'b1 ;
        end
        if ( cfgsc_cfg_cq_ldb_wu_limit_mem_re ) begin
          cfgsc_wu_cfg_ctrl_nxt                                 = HQM_LSP_LBWU_CFG_CTRL_WULIM_RD ;
        end
      end
    end
    HQM_LSP_LBWU_CFGSM_VLD : begin
      cfgsc_wu_cfg_sm_nxt               = HQM_LSP_LBWU_CFGSM_WT_RDATA ;         // One-clock pulse
      //--------
      cfgsc_wu_cfg_req_v                = 1'b1 ;
    end
    HQM_LSP_LBWU_CFGSM_WT_RDATA : begin
      if ( p3_lbwu_cq_cfg_v ) begin     // Wait until AW rmw access is active : rdata available at p3, or doing bypass write into p4 nxt
        cfgsc_wu_cfg_sm_nxt             = HQM_LSP_LBWU_CFGSM_ACK ;      // OK to ack immediately, OK if next cfg req comes in next clock, rx_sync have room
        //--------
        cfgsc_wu_cfg_save_rdata_cnt     = cfgsc_wu_count_rd ;
        cfgsc_wu_cfg_save_rdata_lim     = cfgsc_wu_limit_rd ;
      end
    end
    HQM_LSP_LBWU_CFGSM_ACK : begin
      cfgsc_wu_cfg_sm_nxt               = HQM_LSP_LBWU_CFGSM_IDLE ;             // One-clock pulse
      //--------
      cfgsc_wu_count_wr_ack             = cfgsc_wu_count_wr ;
      cfgsc_wu_count_rd_ack             = cfgsc_wu_count_rd ;
      cfgsc_wu_limit_wr_ack             = cfgsc_wu_limit_wr ;
      cfgsc_wu_limit_rd_ack             = cfgsc_wu_limit_rd ;
    end
    default : begin
      cfgsc_wu_cfg_sm_nxt               = HQM_LSP_LBWU_CFGSM_IDLE ;
    end
  endcase

  if ( cfgsc_wu_cfg_save_wdata_cnt ) begin
    cfgsc_wu_cfg_data_nxt                               = 32'h0 ;
    cfgsc_wu_cfg_data_nxt [2+(WU_CNT_WIDTH-1):0]        = { cfgsc_cfg_mem_wdata_res , cfgsc_cfg_mem_wdata [WU_CNT_WIDTH-1:0] } ;
  end
  if ( cfgsc_wu_cfg_save_wdata_lim ) begin
    cfgsc_wu_cfg_data_nxt                               = 32'h0 ;
    cfgsc_wu_cfg_data_nxt [1+1+(WU_LIM_WIDTH-1):0]      = { cfgsc_cfg_mem_wdata_par , cfgsc_cfg_mem_wdata [1+(WU_LIM_WIDTH-1):0] } ;
  end
  if ( cfgsc_wu_cfg_save_rdata_cnt ) begin
    cfgsc_wu_cfg_data_nxt                               = 32'h0 ;
    cfgsc_wu_cfg_data_nxt [WU_CNT_WIDTH-1:0]            = p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt ;       // Strip off residue bits
  end
  if ( cfgsc_wu_cfg_save_rdata_lim ) begin
    cfgsc_wu_cfg_data_nxt                               = 32'h0 ;
    cfgsc_wu_cfg_data_nxt [1+(WU_LIM_WIDTH-1):0]        = { p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim_v , p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim } ; // Strip off parity bit
  end
end // always

always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    cfgsc_wu_cfg_sm_f                                   <= HQM_LSP_LBWU_CFGSM_IDLE ;
    cfgsc_wu_cfg_ctrl_f                                 <= HQM_LSP_LBWU_CFG_CTRL_WUCNT_WR ;
  end
  else begin
    cfgsc_wu_cfg_sm_f                                   <= cfgsc_wu_cfg_sm_nxt ;
    cfgsc_wu_cfg_ctrl_f                                 <= cfgsc_wu_cfg_ctrl_nxt ;
  end
end // always

//-------------------------------------------------------------------------------------------------
// cq_wu_cnt, cq_wu_lim
// Track if a CQ is overworked : sum(scheduled work) > limit

// Nothing backpressures the lbwu pipe
// p0_lba_wu_v is effectively the "pipeline valid" for p0 lba and qed_lsp_deq/aqed_lsp_deq feeding into p1 lbwu
assign p1_lbwu_ctrl_pipe_pnc.hold       = 1'b0 ;
assign p1_lbwu_ctrl_pipe_pnc.en         = p0_lba_wu_v ;

assign p2_lbwu_ctrl_pipe_pnc.hold       = 1'b0 ;
assign p2_lbwu_ctrl_pipe_pnc.en         = p1_lbwu_ctrl_pipe_v_f ;

assign p3_lbwu_ctrl_pipe_pnc.hold       = 1'b0 ;
assign p3_lbwu_ctrl_pipe_pnc.en         = p2_lbwu_ctrl_pipe_v_f ;

always_comb begin
  p1_lbwu_ctrl_pipe_nxt                 = p1_lbwu_ctrl_pipe_f ;
  p2_lbwu_ctrl_pipe_nxt                 = p2_lbwu_ctrl_pipe_f ;
  p3_lbwu_ctrl_pipe_nxt                 = p3_lbwu_ctrl_pipe_f ;

  if ( p1_lbwu_ctrl_pipe_pnc.en ) begin
    if ( cfgsc_wu_cfg_req_v ) begin     // cfgsc_wu_cfg_req_v forces pipe enable on
      p1_lbwu_ctrl_pipe_nxt.cmd         = HQM_LSP_LBWU_CMD_CFG ;
      p1_lbwu_ctrl_pipe_nxt.qe_wt       = 2'h0 ;                // unused
      p1_lbwu_ctrl_pipe_nxt.parity      = 1'b0 ;                // unused
    end
    else if ( p0_lba_wu_sel_deq ) begin
      p1_lbwu_ctrl_pipe_nxt.cmd         = HQM_LSP_LBWU_CMD_DEQ ;
      p1_lbwu_ctrl_pipe_nxt.qe_wt       = xqed_lsp_deq_fifo_pop_data_qe_wt ;
      p1_lbwu_ctrl_pipe_nxt.parity      = xqed_lsp_deq_fifo_pop_data_parity ;
    end
    else begin
      p1_lbwu_ctrl_pipe_nxt.cmd         = HQM_LSP_LBWU_CMD_CMP ;
      p1_lbwu_ctrl_pipe_nxt.qe_wt       = lbi_inp_cq_cmp_qe_wt ;
      p1_lbwu_ctrl_pipe_nxt.parity      = lbi_inp_cq_cmp_cq_wt_p ;
    end
  end

  if ( p2_lbwu_ctrl_pipe_pnc.en ) begin
    p2_lbwu_ctrl_pipe_nxt        = p1_lbwu_ctrl_pipe_f ;
  end

  if ( p3_lbwu_ctrl_pipe_pnc.en ) begin
    p3_lbwu_ctrl_pipe_nxt        = p2_lbwu_ctrl_pipe_f ;
  end
end // always

always_ff @ ( posedge clk ) begin
  cfgsc_wu_cfg_addr_f           <= cfgsc_wu_cfg_addr_nxt ;
  cfgsc_wu_cfg_data_f           <= cfgsc_wu_cfg_data_nxt ;

  p1_lbwu_ctrl_pipe_f           <= p1_lbwu_ctrl_pipe_nxt ;
  p2_lbwu_ctrl_pipe_f           <= p2_lbwu_ctrl_pipe_nxt ;
  p3_lbwu_ctrl_pipe_f           <= p3_lbwu_ctrl_pipe_nxt ;
end // always

always_comb begin
  qed_lsp_deq_fifo_pop_data_v                   = ! qed_lsp_deq_fifo_empty ;
  aqed_lsp_deq_fifo_pop_data_v                  = ! aqed_lsp_deq_fifo_empty ;

  deq_arb_reqs [ HQM_LSP_DEQ_ARB_NALB ]         = qed_lsp_deq_fifo_pop_data_v ;
  deq_arb_reqs [ HQM_LSP_DEQ_ARB_ATM ]          = aqed_lsp_deq_fifo_pop_data_v ;

  xqed_lsp_deq_fifo_pop_data_parity             = qed_lsp_deq_fifo_pop_data_parity ;
  xqed_lsp_deq_fifo_pop_data_cq                 = qed_lsp_deq_fifo_pop_data_cq ;
  xqed_lsp_deq_fifo_pop_data_qe_wt              = qed_lsp_deq_fifo_pop_data_qe_wt ;

  if ( deq_arb_winner == HQM_LSP_DEQ_ARB_ATM ) begin
    xqed_lsp_deq_fifo_pop_data_parity           = aqed_lsp_deq_fifo_pop_data_parity ;
    xqed_lsp_deq_fifo_pop_data_cq               = aqed_lsp_deq_fifo_pop_data_cq ;
    xqed_lsp_deq_fifo_pop_data_qe_wt            = aqed_lsp_deq_fifo_pop_data_qe_wt ;
  end
end // always

hqm_AW_rr_arb # ( .NUM_REQS ( 2 ) ) i_deq_arb (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .reqs                 ( deq_arb_reqs )
        , .update               ( deq_arb_update )
        , .winner_v             ( deq_arb_winner_v )
        , .winner               ( deq_arb_winner )
) ;

// Note: if config qe_wt blk bit is set, deq requests are dropped
always_comb begin
  p0_lba_supress_cq_cmp         = 1'b0 ;
  qed_lsp_deq_fifo_pop          = 1'b0 ;
  aqed_lsp_deq_fifo_pop         = 1'b0 ;
  deq_arb_update                = 1'b0 ;
  p0_lba_wu_v                   = 1'b0 ;
  p0_lba_wu_sel_deq             = 1'b0 ;

  if ( cfgsc_wu_cfg_req_v ) begin                               // cfg unconditionally wins, block deq and cq_cmp
    p0_lba_supress_cq_cmp       = ~ cfg_control_qe_wt_blk ;     // No need to supress, lbi "taken" will be ignored
    qed_lsp_deq_fifo_pop        = 1'b0 ;
    aqed_lsp_deq_fifo_pop       = 1'b0 ;
    p0_lba_wu_v                 = 1'b1 ;
    p0_lba_wu_sel_deq           = 1'b0 ;
  end
  else if ( cfg_control_qe_wt_blk ) begin                       // If blocking with cfg, don't select func into lbwu pipe, force/allow deq and cmp ready
    p0_lba_supress_cq_cmp       = 1'b0 ;
    qed_lsp_deq_fifo_pop        = 1'b0 ;
    aqed_lsp_deq_fifo_pop       = 1'b0 ;
    p0_lba_wu_v                 = 1'b0 ;
    p0_lba_wu_sel_deq           = 1'b0 ;
  end
  else if ( p0_lba_sch_state_ready_for_work | qed_lsp_deq_high_pri | aqed_lsp_deq_high_pri ) begin
    // if sched sm is in the 1/8 "ready to sched" state, deq has strict priority
    // if sched sm is not in the 1/8 "ready to sched" state, deq only has strict priority if high_pri
    if ( deq_arb_winner_v ) begin                               // deq wins, block cq_cmp
      p0_lba_supress_cq_cmp     = 1'b1 ;
      deq_arb_update            = 1'b1 ;
      p0_lba_wu_v               = 1'b1 ;
      p0_lba_wu_sel_deq         = 1'b1 ;
      if ( deq_arb_winner == HQM_LSP_DEQ_ARB_ATM ) begin        // ATM wins
        qed_lsp_deq_fifo_pop    = 1'b0 ;
        aqed_lsp_deq_fifo_pop   = 1'b1 ;
      end
      else begin                                                // NALB wins
        qed_lsp_deq_fifo_pop    = 1'b1 ;
        aqed_lsp_deq_fifo_pop   = 1'b0 ;
      end
    end
    else begin                                                  // cq_cmp wins if there is one
      p0_lba_supress_cq_cmp     = 1'b0 ;
      qed_lsp_deq_fifo_pop      = 1'b0 ;
      aqed_lsp_deq_fifo_pop     = 1'b0 ;
      p0_lba_wu_v               = lbi_cq_cmp_req_taken ;
      p0_lba_wu_sel_deq         = 1'b0 ;
    end
  end
  else begin                                                    // cq_cmp (if there is one) wins over deq
    p0_lba_supress_cq_cmp       = 1'b0 ;
    if ( lbi_cq_cmp_req_taken ) begin
      qed_lsp_deq_fifo_pop      = 1'b0 ;
      aqed_lsp_deq_fifo_pop     = 1'b0 ;
      p0_lba_wu_v               = 1'b1 ;
      p0_lba_wu_sel_deq         = 1'b0 ;
    end
    else if ( deq_arb_winner_v ) begin                          // else deq if valid
      deq_arb_update            = 1'b1 ;
      p0_lba_wu_v               = 1'b1 ;
      p0_lba_wu_sel_deq         = 1'b1 ;
      if ( deq_arb_winner == HQM_LSP_DEQ_ARB_ATM ) begin        // ATM wins
        qed_lsp_deq_fifo_pop    = 1'b0 ;
        aqed_lsp_deq_fifo_pop   = 1'b1 ;
      end
      else begin                                                // NALB wins
        qed_lsp_deq_fifo_pop    = 1'b1 ;
        aqed_lsp_deq_fifo_pop   = 1'b0 ;
      end
    end
    else begin                                                  // else nothing to do
      qed_lsp_deq_fifo_pop      = 1'b0 ;
      aqed_lsp_deq_fifo_pop     = 1'b0 ;
      p0_lba_wu_v               = 1'b0 ;
      p0_lba_wu_sel_deq         = 1'b0 ;
    end
  end
end // always

//-------------------------------------------------------------------------------------------------
// Manage storage for per-cq wu count and wu limit.
// p0 for the rmw_pipe loads from lba pipe levels p0 and is independent of the lba pipe, no holds

assign p1_lbwu_ctrl_pipe_v_nxt                  = p0_lba_wu_v ;         // No holds

always_comb begin
  p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.rw_cmd         = HQM_AW_RMWPIPE_NOOP ;
  p1_lbwu_cq_wu_lim_rmw_pipe_nxt.rw_cmd         = HQM_AW_RMWPIPE_NOOP ;

  if ( p1_lbwu_ctrl_pipe_v_nxt ) begin
    if ( cfgsc_wu_cfg_req_v ) begin             // cfgsc_wu_cfg_req_v forces p1 v next
      if ( cfgsc_wu_count_wr ) begin
        p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_RMW ;
        p1_lbwu_cq_wu_lim_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_NOOP ;
      end
      if ( cfgsc_wu_count_rd ) begin
        p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_READ ;
        p1_lbwu_cq_wu_lim_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_NOOP ;
      end
      if ( cfgsc_wu_limit_wr ) begin
        p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_NOOP ;
        p1_lbwu_cq_wu_lim_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_RMW ;
      end
      if ( cfgsc_wu_limit_rd ) begin
        p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_NOOP ;
        p1_lbwu_cq_wu_lim_rmw_pipe_nxt.rw_cmd   = HQM_AW_RMWPIPE_READ ;
      end
    end
    else begin
      p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_RMW ;
      p1_lbwu_cq_wu_lim_rmw_pipe_nxt.rw_cmd     = HQM_AW_RMWPIPE_READ ;
    end
  end
  //----------------------------------------------------------------------------
  if ( cfgsc_wu_cfg_req_v ) begin
    p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.cq           = cfgsc_wu_cfg_addr_f ;
    p1_lbwu_cq_wu_lim_rmw_pipe_nxt.cq           = cfgsc_wu_cfg_addr_f ;
  end
  else if ( p0_lba_wu_sel_deq ) begin
    p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.cq           = xqed_lsp_deq_fifo_pop_data_cq[NUM_CQB2-1:0] ;
    p1_lbwu_cq_wu_lim_rmw_pipe_nxt.cq           = xqed_lsp_deq_fifo_pop_data_cq[NUM_CQB2-1:0] ;
  end
  else begin
    p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.cq           = lbi_inp_cq_cmp_cq ;
    p1_lbwu_cq_wu_lim_rmw_pipe_nxt.cq           = lbi_inp_cq_cmp_cq ;
  end
  //----------------------------------------------------------------------------
  p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.data           = { $bits ( lsp_lbwu_cq_wu_cnt_t ) { 1'b0 } } ; // Unused - cfg write handled later in pipe
  p1_lbwu_cq_wu_lim_rmw_pipe_nxt.data           = { $bits ( lsp_lbwu_cq_wu_lim_t ) { 1'b0 } } ; // Unused - cfg write handled later in pipe
end // always

hqm_AW_rmw_mem_4pipe #(
          .DEPTH                ( NUM_CQ )
        , .WIDTH                ( $bits(lsp_lbwu_cq_wu_cnt_t) )
) i_lbwu_cq_wu_cnt_pipe (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .status               ( lbwu_cq_wu_cnt_rmw_pipe_status )

        // cmd input
        , .p0_hold              ( 1'b0 )
        , .p0_v_nxt             ( p1_lbwu_ctrl_pipe_v_nxt )
        , .p0_rw_nxt            ( p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.rw_cmd )
        , .p0_addr_nxt          ( p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.cq )
        , .p0_write_data_nxt    ( p1_lbwu_cq_wu_cnt_rmw_pipe_nxt.data )
        , .p0_v_f               ( p1_lbwu_ctrl_pipe_v_f )
        , .p0_rw_f              ( p1_lbwu_cq_wu_cnt_rmw_pipe_rw_f_nc )                  // Unused
        , .p0_addr_f            ( p1_lbwu_cq_wu_cnt_rmw_pipe_addr_f_nc )                // Unused
        , .p0_data_f            ( p1_lbwu_cq_wu_cnt_rmw_pipe_data_f_nc )                // Unused

        , .p1_hold              ( 1'b0 )
        , .p1_v_f               ( p2_lbwu_ctrl_pipe_v_f )
        , .p1_rw_f              ( p2_lbwu_cq_wu_cnt_rmw_pipe_rw_f_nc )                  // Unused
        , .p1_addr_f            ( p2_lbwu_cq_wu_cnt_rmw_pipe_addr_f_nc )                // Unused
        , .p1_data_f            ( p2_lbwu_cq_wu_cnt_rmw_pipe_data_f_nc )                // Unused

        , .p2_hold              ( 1'b0 )
        , .p2_v_f               ( p3_lbwu_ctrl_pipe_v_f )
        , .p2_rw_f              ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.rw_cmd )
        , .p2_addr_f            ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.cq )
        , .p2_data_f            ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.data )

        , .p3_hold              ( 1'b0 )
        , .p3_bypsel_nxt        ( p3_lbwu_cq_wu_cnt_upd_v )
        , .p3_bypdata_nxt       ( p3_lbwu_cq_wu_cnt_upd_cnt )
        , .p3_v_f               ( p4_lbwu_ctrl_pipe_v_f )                               // Diag only
        , .p3_rw_f              ( p4_lbwu_cq_wu_cnt_rmw_pipe_rw_f_nc )                  // Unused
        , .p3_addr_f            ( p4_lbwu_cq_wu_cnt_rmw_pipe_addr_f_nc )                // Unused
        , .p3_data_f            ( p4_lbwu_cq_wu_cnt_rmw_pipe_data_f_nc )                // Unused


        // mem intf
        , .mem_write            ( func_cq_ldb_wu_count_mem_we )
        , .mem_read             ( func_cq_ldb_wu_count_mem_re )
        , .mem_write_addr       ( func_cq_ldb_wu_count_mem_waddr )
        , .mem_read_addr        ( func_cq_ldb_wu_count_mem_raddr )
        , .mem_write_data       ( func_cq_ldb_wu_count_mem_wdata )
        , .mem_read_data        ( func_cq_ldb_wu_count_mem_rdata )
) ;

// End-to-end checking on cq and qe_wt from CHP.  "input parity" is invalid for a config access
assign p3_lbwu_inp_par_chk_en   = p3_lbwu_cq_wu_cnt_upd_v_func ;
hqm_AW_parity_check # ( .WIDTH ( NUM_CQB2 + 2 ) ) i_lbwu_cq_wt_par_chk (
          .p                    ( p3_lbwu_ctrl_pipe_f.parity )
        , .d                    ( {   p3_lbwu_ctrl_pipe_f.qe_wt
                                    , p3_lbwu_cq_wu_cnt_rmw_pipe_f.cq } )
        , .e                    ( p3_lbwu_inp_par_chk_en )
        , .odd                  ( 1'b1 )
        , .err                  ( p3_lbwu_inp_par_err_cond )
) ;

hqm_AW_rmw_mem_4pipe #(
          .DEPTH                ( NUM_CQ )
        , .WIDTH                ( $bits(lsp_lbwu_cq_wu_lim_t) )
) i_lbwu_cq_wu_lim_pipe (
          .clk                  ( clk )
        , .rst_n                ( rst_n )
        , .status               ( lbwu_cq_wu_lim_rmw_pipe_status_nc )           // Unused: same as lbwu_cq_wu_cnt_rmw_pipe_status

        // cmd input
        , .p0_hold              ( 1'b0 )
        , .p0_v_nxt             ( p1_lbwu_ctrl_pipe_v_nxt )
        , .p0_rw_nxt            ( p1_lbwu_cq_wu_lim_rmw_pipe_nxt.rw_cmd )
        , .p0_addr_nxt          ( p1_lbwu_cq_wu_lim_rmw_pipe_nxt.cq )
        , .p0_write_data_nxt    ( p1_lbwu_cq_wu_lim_rmw_pipe_nxt.data )
        , .p0_v_f               ( p1_lbwu_cq_wu_lim_rmw_pipe_v_f_nc )           // Unused: same as cq_wu_cnt pipe
        , .p0_rw_f              ( p1_lbwu_cq_wu_lim_rmw_pipe_rw_f_nc )
        , .p0_addr_f            ( p1_lbwu_cq_wu_lim_rmw_pipe_addr_f_nc )
        , .p0_data_f            ( p1_lbwu_cq_wu_lim_rmw_pipe_data_f_nc )

        , .p1_hold              ( 1'b0 )
        , .p1_v_f               ( p2_lbwu_cq_wu_lim_rmw_pipe_v_f_nc )           // Unused: same as cq_wu_cnt pipe
        , .p1_rw_f              ( p2_lbwu_cq_wu_lim_rmw_pipe_rw_f_nc )
        , .p1_addr_f            ( p2_lbwu_cq_wu_lim_rmw_pipe_addr_f_nc )
        , .p1_data_f            ( p2_lbwu_cq_wu_lim_rmw_pipe_data_f_nc )

        , .p2_hold              ( 1'b0 )
        , .p2_v_f               ( p3_lbwu_cq_wu_lim_rmw_pipe_v_f_nc )           // Unused: same as cq_wu_cnt pipe
        , .p2_rw_f              ( p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.rw_cmd )     // Unused
        , .p2_addr_f            ( p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.cq )         // Unused
        , .p2_data_f            ( p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data )

        , .p3_hold              ( 1'b0 )
        , .p3_bypsel_nxt        ( p3_lbwu_cq_wu_lim_upd_v )
        , .p3_bypdata_nxt       ( p3_lbwu_cq_wu_lim_upd_lim )
        , .p3_v_f               ( p4_lbwu_cq_wu_lim_rmw_pipe_v_f_nc )           // Unused
        , .p3_rw_f              ( p4_lbwu_cq_wu_lim_rmw_pipe_rw_f_nc )          // Unused
        , .p3_addr_f            ( p4_lbwu_cq_wu_lim_rmw_pipe_addr_f_nc )        // Unused
        , .p3_data_f            ( p4_lbwu_cq_wu_lim_rmw_pipe_data_f_nc )        // Unused

        // mem intf
        , .mem_write            ( func_cfg_cq_ldb_wu_limit_mem_we )
        , .mem_read             ( func_cfg_cq_ldb_wu_limit_mem_re )
        , .mem_write_addr       ( func_cfg_cq_ldb_wu_limit_mem_waddr )
        , .mem_read_addr        ( func_cfg_cq_ldb_wu_limit_mem_raddr )
        , .mem_write_data       ( func_cfg_cq_ldb_wu_limit_mem_wdata )
        , .mem_read_data        ( func_cfg_cq_ldb_wu_limit_mem_rdata )
) ;





//==================================================================================
//==================================================================================

always_comb begin
  if ( cfg_control_qe_wt_frc_v ) begin
    p3_lbwu_ctrl_pipe_qe_wt     = cfg_control_qe_wt_frc_val ;
  end
  else begin
    p3_lbwu_ctrl_pipe_qe_wt     = p3_lbwu_ctrl_pipe_f.qe_wt ;
  end

  p3_lbwu_ctrl_pipe_qe_wu       = ( 4'h1 << p3_lbwu_ctrl_pipe_qe_wt ) ;

  p3_lbwu_ctrl_pipe_qe_wu_res = 2'h1 ;
  case ( p3_lbwu_ctrl_pipe_qe_wt )
    2'b00 : p3_lbwu_ctrl_pipe_qe_wu_res = 2'h1 ;
    2'b01 : p3_lbwu_ctrl_pipe_qe_wu_res = 2'h2 ;
    2'b10 : p3_lbwu_ctrl_pipe_qe_wu_res = 2'h1 ;
    2'b11 : p3_lbwu_ctrl_pipe_qe_wu_res = 2'h2 ;
  endcase
end // always

hqm_AW_residue_add i_lbwu_cq_wu_cnt_res_add (
          .a                    ( p3_lbwu_ctrl_pipe_qe_wu_res )
        , .b                    ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt_res )
        , .r                    ( p3_lbwu_cq_wu_cnt_res_pn )
) ;

hqm_AW_residue_sub i_lbwu_cq_wu_cnt_res_sub (
          .a                    ( p3_lbwu_ctrl_pipe_qe_wu_res )
        , .b                    ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt_res )
        , .r                    ( p3_lbwu_cq_wu_cnt_res_mn )
) ;

generate
  if ( ( WU_CNT_WIDTH % 2 ) == 1 ) begin: g_odd   // Odd number of bits
    // If an odd number of bits, when there's a carry due to changing sign, the amount lost is into an odd bit position so has a value of 2
    assign p3_lbwu_cq_wu_cnt_res_corr_amt       = 2'h2 ;

    // residue of the 2s-complement of the wu.  Need to adjust for sign bit coming on.  The residue value of the sign bit depends on
    // if the sign is in an even or odd bit position.
    // e.g. 4 bits plus sign = odd
    //   wu    2sc_wu  res(2sc_wu)
    // 0,0001  1,1111      01
    // 0,0010  1,1110      00
    // 0,0100  1,1100      01
    // 0,1000  1,1000      00
    always_comb begin
      p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj = 2'h1 ;
      case ( p3_lbwu_ctrl_pipe_qe_wt )
        2'b00 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h1 ;
        2'b01 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h0 ;
        2'b10 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h1 ;
        2'b11 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h0 ;
      endcase
    end // always
  end
  else begin: g_even
    // If an even number of bits, when there's a carry due to changing sign, the amount lost is into an even bit position so has a value of 1
    assign p3_lbwu_cq_wu_cnt_res_corr_amt       = 2'h1 ;

    // e.g. 5 bits plus sign = even
    //   wu     2sc_wu   res(2sc_wu)
    // 0,00001  1,11111      00
    // 0,00010  1,11110      10
    // 0,00100  1,11100      00
    // 0,01000  1,11000      10
    always_comb begin
      p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj = 2'h0 ;
      case ( p3_lbwu_ctrl_pipe_qe_wt )
        2'b00 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h0 ;
        2'b01 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h2 ;
        2'b10 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h0 ;
        2'b11 : p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj     = 2'h2 ;
      endcase
    end // always
  end
endgenerate

hqm_AW_residue_sub i_lbwu_cq_wu_cnt_res_add_corr (
          .a                    ( p3_lbwu_cq_wu_cnt_res_corr_amt )
        , .b                    ( p3_lbwu_cq_wu_cnt_res_pn )
        , .r                    ( p3_lbwu_cq_wu_cnt_res_pn_corr )
) ;

// If go from positive to negative, since doing 2s-complement math, instead of subtracting the residue, need to add the residue of the
// 2s-complement of the wu.
hqm_AW_residue_add i_lbwu_cq_wu_cnt_res_sub_corr (
          .a                    ( p3_lbwu_ctrl_pipe_qe_wu_res_2sc_adj )
        , .b                    ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt_res )
        , .r                    ( p3_lbwu_cq_wu_cnt_res_mn_corr )
) ;

// 2s-comp math, can go neg -> pos
assign { p3_lbwu_cq_wu_cnt_go_pos , p3_lbwu_cq_wu_cnt_pn }      = { 1'b0 , p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt } +
                                                                  { { (1+WU_CNT_WIDTH-4) { 1'b0 } } , p3_lbwu_ctrl_pipe_qe_wu } ;

// 2s-comp math, can go pos -> neg
assign { p3_lbwu_cq_wu_cnt_go_neg , p3_lbwu_cq_wu_cnt_mn }      = { 1'b0 , p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt } -
                                                                  { { (1+WU_CNT_WIDTH-4) { 1'b0 } } , p3_lbwu_ctrl_pipe_qe_wu } ;

// Overflow if adding and sign switches from positive (0) to negative (1).  ms bit is sign bit
assign p3_lbwu_cq_wu_cnt_flip_oflow_cond        = ~ p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt [WU_CNT_WIDTH-1] &
                                                    p3_lbwu_cq_wu_cnt_pn                  [WU_CNT_WIDTH-1] ;

// Underflow if subtracting and sign switches from negative (1) to positive (0).  ms bit is sign bit
assign p3_lbwu_cq_wu_cnt_flip_uflow_cond        =   p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt [WU_CNT_WIDTH-1] &
                                                  ~ p3_lbwu_cq_wu_cnt_mn                  [WU_CNT_WIDTH-1] ;

assign p3_lbwu_cq_cfg_v                         = p3_lbwu_ctrl_pipe_v_f & ( p3_lbwu_ctrl_pipe_f.cmd == HQM_LSP_LBWU_CMD_CFG ) ;

assign p3_lbwu_cq_wu_cnt_upd_v                  = p3_lbwu_ctrl_pipe_v_f & ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.rw_cmd == HQM_AW_RMWPIPE_RMW ) ;
assign p3_lbwu_cq_wu_lim_upd_v                  = p3_lbwu_ctrl_pipe_v_f & ( p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.rw_cmd == HQM_AW_RMWPIPE_RMW ) ;

assign p3_lbwu_cq_wu_cnt_upd_v_func             = p3_lbwu_cq_wu_cnt_upd_v & ~ p3_lbwu_cq_cfg_v ;

always_comb begin
  p3_lbwu_cq_wu_cnt_flip_pos_cond               = 1'b0 ;
  p3_lbwu_cq_wu_cnt_flip_neg_cond               = 1'b0 ;
  p3_lbwu_cq_wu_cnt_upd_cnt                     = p3_lbwu_cq_wu_cnt_rmw_pipe_f.data ;
  p3_lbwu_cq_wu_lim_upd_lim                     = cfgsc_wu_cfg_data_f [$bits(lsp_lbwu_cq_wu_lim_t)-1:0] ;

  if ( p3_lbwu_cq_cfg_v ) begin
    if ( cfgsc_wu_count_wr ) begin
      p3_lbwu_cq_wu_cnt_upd_cnt                 = cfgsc_wu_cfg_data_f [$bits(lsp_lbwu_cq_wu_cnt_t)-1:0] ;
    end
    if ( cfgsc_wu_limit_wr ) begin
      p3_lbwu_cq_wu_lim_upd_lim                 = cfgsc_wu_cfg_data_f [$bits(lsp_lbwu_cq_wu_lim_t)-1:0] ;
    end
  end
  else if ( p3_lbwu_ctrl_pipe_v_f & ( p3_lbwu_ctrl_pipe_f.cmd == HQM_LSP_LBWU_CMD_DEQ ) ) begin
    if ( p3_lbwu_cq_wu_cnt_go_pos ) begin
      p3_lbwu_cq_wu_cnt_flip_pos_cond           = 1'b1 ;
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt             = p3_lbwu_cq_wu_cnt_pn ;                // Signed math should still be correct
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt_res         = p3_lbwu_cq_wu_cnt_res_pn_corr ;       // ... but need to correct residue
    end
    else if ( p3_lbwu_cq_wu_cnt_flip_oflow_cond ) begin                                 // Hold the value - this is an unexpected error condition - don't provoke a hw error
      p3_lbwu_cq_wu_cnt_upd_cnt                 = p3_lbwu_cq_wu_cnt_rmw_pipe_f.data ;
    end
    else begin
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt             = p3_lbwu_cq_wu_cnt_pn ;
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt_res         = p3_lbwu_cq_wu_cnt_res_pn ;
    end
  end
  else if ( p3_lbwu_ctrl_pipe_v_f ) begin       // CMP
    if ( p3_lbwu_cq_wu_cnt_go_neg ) begin
      p3_lbwu_cq_wu_cnt_flip_neg_cond           = 1'b1 ;
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt             = p3_lbwu_cq_wu_cnt_mn ;                // Signed math should still be correct
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt_res         = p3_lbwu_cq_wu_cnt_res_mn_corr ;       // ... but need to correct residue
    end
    else if ( p3_lbwu_cq_wu_cnt_flip_uflow_cond ) begin                                 // Hold the value - this is an unexpected error condition - don't provoke a hw error
      p3_lbwu_cq_wu_cnt_upd_cnt                 = p3_lbwu_cq_wu_cnt_rmw_pipe_f.data ;
    end
    else begin
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt             = p3_lbwu_cq_wu_cnt_mn ;
      p3_lbwu_cq_wu_cnt_upd_cnt.cnt_res         = p3_lbwu_cq_wu_cnt_res_mn ;
    end
  end
end // always

assign p3_lbwu_cq_wu_cnt_upd_gt_lim             =   p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim_v                 // limit is configured
                                                  & ~ p3_lbwu_cq_wu_cnt_upd_cnt.cnt[WU_CNT_WIDTH-1]             // sign=0 : positive
                                                  & ( p3_lbwu_cq_wu_cnt_upd_cnt.cnt[WU_CNT_WIDTH-2:0] > { 1'b0 , p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim } ) ;

// Don't do the check on a location which is not in use, or on a config access
assign p3_lbwu_cq_wu_cnt_res_chk_en             = p3_lbwu_cq_wu_cnt_upd_v_func & p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim_v & ~ cfg_control_disable_wu_res_chk ;

// Don't condition the parity check on the valid bit, because the valid bit itself is covered by the parity and may be the bad bit.  Don't check on config access
assign p3_lbwu_cq_wu_lim_par_chk_en             = p3_lbwu_cq_wu_cnt_upd_v_func ;

hqm_AW_residue_check #( .WIDTH ( WU_CNT_WIDTH ) ) i_lbwu_cq_wu_cnt_res_chk (
          .r                    ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt_res )
        , .d                    ( p3_lbwu_cq_wu_cnt_rmw_pipe_f.data.cnt )
        , .e                    ( p3_lbwu_cq_wu_cnt_res_chk_en )
        , .err                  ( p3_lbwu_cq_wu_cnt_res_err_cond )
) ;

hqm_AW_parity_check # ( .WIDTH ( WU_LIM_WIDTH + 1 ) ) i_lbwu_cq_wu_lim_par_chk (
          .p                    ( p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim_p )
        , .d                    ( { p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim_v , p3_lbwu_cq_wu_lim_rmw_pipe_f_pnc.data.lim } )
        , .e                    ( p3_lbwu_cq_wu_lim_par_chk_en )
        , .odd                  ( 1'b1 )
        , .err                  ( p3_lbwu_cq_wu_lim_par_err_cond )
) ;

assign p4_lbwu_cq_wu_cnt_upd_v_nxt              = p3_lbwu_cq_wu_cnt_upd_v_func ;
assign p4_lbwu_cq_wu_cnt_upd_cq_nxt             = p3_lbwu_cq_wu_cnt_rmw_pipe_f.cq ;
assign p4_lbwu_cq_wu_cnt_upd_gt_lim_nxt         = p3_lbwu_cq_wu_cnt_upd_gt_lim ;

always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    p4_lbwu_cq_wu_cnt_upd_v_f                           <= 1'b0 ;
    p4_lbwu_cq_wu_cnt_upd_cq_f                          <= '0 ;
    p4_lbwu_cq_wu_cnt_upd_gt_lim_f                      <= 1'b0 ;
  end
  else begin
    p4_lbwu_cq_wu_cnt_upd_v_f                           <= p4_lbwu_cq_wu_cnt_upd_v_nxt ;
    p4_lbwu_cq_wu_cnt_upd_cq_f                          <= p4_lbwu_cq_wu_cnt_upd_cq_nxt ;
    p4_lbwu_cq_wu_cnt_upd_gt_lim_f                      <= p4_lbwu_cq_wu_cnt_upd_gt_lim_nxt ;
  end
end // always

endmodule // hqm_lsp_wu_ctrl
