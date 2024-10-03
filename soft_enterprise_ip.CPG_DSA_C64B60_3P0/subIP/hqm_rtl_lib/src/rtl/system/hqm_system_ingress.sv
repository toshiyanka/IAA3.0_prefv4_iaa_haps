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

`include "hqm_system_def.vh"

module hqm_system_ingress

         import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*;
(
         input  logic                                       prim_gated_clk
        ,input  logic                                       prim_gated_rst_n

        ,input  logic                                       hqm_inp_gated_clk
        ,input  logic                                       hqm_inp_gated_rst_n

        ,input  logic                                       hqm_gated_clk
        ,input  logic                                       hqm_gated_rst_n

        ,input  logic                                       rst_prep

        ,output logic                                       rst_done

        ,input  logic                                       hqm_enq_fifo_enable
        ,output logic                                       hqm_enq_fifo_idle

        //---------------------------------------------------------------------------------------------
        // CFG interface

        ,input  hqm_system_ingress_cfg_signal_t             cfg_re
        ,input  hqm_system_ingress_cfg_signal_t             cfg_we
        ,input  logic   [11:0]                              cfg_addr
        ,input  logic   [31:0]                              cfg_wdata

        ,output hqm_system_ingress_cfg_signal_t             cfg_rvalid
        ,output hqm_system_ingress_cfg_signal_t             cfg_wvalid
        ,output hqm_system_ingress_cfg_signal_t             cfg_error
        ,output logic   [31:0]                              cfg_rdata

        ,input  logic                                       cfg_parity_off
        ,input  logic                                       cfg_write_bad_parity
        ,input  logic                                       cfg_write_bad_sb_ecc
        ,input  logic                                       cfg_write_bad_mb_ecc
        ,input  logic                                       cfg_inj_par_err_ingress
        ,input  logic   [3:0]                               cfg_inj_ecc_err_ingress
        ,input  logic   [HQM_SYSTEM_AWIDTH_HCW_ENQ_FIFO:0]  cfg_hcw_enq_fifo_high_wm
        ,input  INGRESS_ALARM_ENABLE_t                      cfg_ingress_alarm_enable
        ,input  logic                                       cfg_hcw_enq_ecc_enable
        ,input  logic                                       cfg_lut_ecc_enable
        ,input  logic                                       cfg_cnt_clear
        ,input  logic                                       cfg_cnt_clearv

        ,input  HQM_DIR_PP2VDEV_t [NUM_DIR_PP-1:0]          dir_pp2vdev
        ,input  HQM_LDB_PP2VDEV_t [NUM_LDB_PP-1:0]          ldb_pp2vdev

        ,input  DIR_PP_ROB_V_t [NUM_DIR_PP-1:0]             dir_pp_rob_v
        ,input  LDB_PP_ROB_V_t [NUM_LDB_PP-1:0]             ldb_pp_rob_v

        ,output new_INGRESS_LUT_ERR_t                       ingress_lut_err
        ,output logic                                       ingress_perr
        ,output logic   [4:0]                               ingress_sb_ecc_error
        ,output logic   [2:0]                               ingress_mb_ecc_error
        ,output logic   [23:0]                              ingress_ecc_syndrome

        ,output logic                                       rob_error
        ,output logic   [7:0]                               rob_error_synd
        ,output new_ROB_SYNDROME_t                          rob_syndrome

        ,output aw_fifo_status_t                            hcw_enq_fifo_status

        ,input  IG_HCW_ENQ_AFULL_AGITATE_CONTROL_t          ig_hcw_enq_afull_agitate_control   // HCW Enqueue almost full agitate control
        ,input  IG_HCW_ENQ_W_DB_AGITATE_CONTROL_t           ig_hcw_enq_w_db_agitate_control    // HCW Enqueue W double buffer agitate control

        ,output logic   [6:0]                               hcw_enq_db_status
        ,output logic   [6:0]                               hcw_enq_w_db_status

        ,input  INGRESS_CTL_t                               cfg_ingress_ctl
        ,output new_INGRESS_STATUS_t                        ingress_status
        ,output logic                                       ingress_idle

        ,output logic [5:0] [31:0]                          cfg_ingress_cnts
        ,output logic [153:0]                               hcw_debug_data

        //---------------------------------------------------------------------------------------------
        // SIF endpoint HCW Enqueue input interface

        ,output logic                                       hcw_enq_in_ready

        ,input  logic                                       hcw_enq_in_v
        ,input  hqm_system_enq_data_in_t                    hcw_enq_in_data

        ,output logic                                       hcw_enq_in_sync

        //---------------------------------------------------------------------------------------------
        // Core HCW Enqueue output interface

        ,input  logic                                       hcw_enq_w_req_ready

        ,output logic                                       hcw_enq_w_req_valid
        ,output hcw_enq_w_req_t                             hcw_enq_w_req

        //---------------------------------------------------------------------------------------------
        // Alarm interface

        ,output logic                                       ingress_alarm_v
        ,output hqm_system_ingress_alarm_t                  ingress_alarm

        //---------------------------------------------------------------------------------------------
        // Memory interface

        ,output hqm_system_memi_lut_vf_dir_vpp2pp_t         memi_lut_vf_dir_vpp2pp
        ,input  hqm_system_memo_lut_vf_dir_vpp2pp_t         memo_lut_vf_dir_vpp2pp

        ,output hqm_system_memi_lut_vf_ldb_vpp2pp_t         memi_lut_vf_ldb_vpp2pp
        ,input  hqm_system_memo_lut_vf_ldb_vpp2pp_t         memo_lut_vf_ldb_vpp2pp

        ,output hqm_system_memi_lut_vf_dir_vpp_v_t          memi_lut_vf_dir_vpp_v
        ,input  hqm_system_memo_lut_vf_dir_vpp_v_t          memo_lut_vf_dir_vpp_v

        ,output hqm_system_memi_lut_vf_ldb_vpp_v_t          memi_lut_vf_ldb_vpp_v
        ,input  hqm_system_memo_lut_vf_ldb_vpp_v_t          memo_lut_vf_ldb_vpp_v

        ,output hqm_system_memi_lut_dir_pp_v_t              memi_lut_dir_pp_v
        ,input  hqm_system_memo_lut_dir_pp_v_t              memo_lut_dir_pp_v

        ,output hqm_system_memi_lut_vf_dir_vqid2qid_t       memi_lut_vf_dir_vqid2qid
        ,input  hqm_system_memo_lut_vf_dir_vqid2qid_t       memo_lut_vf_dir_vqid2qid

        ,output hqm_system_memi_lut_vf_ldb_vqid2qid_t       memi_lut_vf_ldb_vqid2qid
        ,input  hqm_system_memo_lut_vf_ldb_vqid2qid_t       memo_lut_vf_ldb_vqid2qid

        ,output hqm_system_memi_lut_vf_dir_vqid_v_t         memi_lut_vf_dir_vqid_v
        ,input  hqm_system_memo_lut_vf_dir_vqid_v_t         memo_lut_vf_dir_vqid_v

        ,output hqm_system_memi_lut_vf_ldb_vqid_v_t         memi_lut_vf_ldb_vqid_v
        ,input  hqm_system_memo_lut_vf_ldb_vqid_v_t         memo_lut_vf_ldb_vqid_v

        ,output hqm_system_memi_lut_dir_pp2vas_t            memi_lut_dir_pp2vas
        ,input  hqm_system_memo_lut_dir_pp2vas_t            memo_lut_dir_pp2vas

        ,output hqm_system_memi_lut_ldb_pp2vas_t            memi_lut_ldb_pp2vas
        ,input  hqm_system_memo_lut_ldb_pp2vas_t            memo_lut_ldb_pp2vas

        ,output hqm_system_memi_lut_dir_vasqid_v_t          memi_lut_dir_vasqid_v
        ,input  hqm_system_memo_lut_dir_vasqid_v_t          memo_lut_dir_vasqid_v

        ,output hqm_system_memi_lut_ldb_vasqid_v_t          memi_lut_ldb_vasqid_v
        ,input  hqm_system_memo_lut_ldb_vasqid_v_t          memo_lut_ldb_vasqid_v

        ,output hqm_system_memi_rob_mem_t                   memi_rob_mem
        ,input  hqm_system_memo_rob_mem_t                   memo_rob_mem

        ,output hqm_system_memi_hcw_enq_fifo_t              memi_hcw_enq_fifo
        ,input  hqm_system_memo_hcw_enq_fifo_t              memo_hcw_enq_fifo

        ,input  logic                                       fscan_byprst_b
        ,input  logic                                       fscan_rstbypen
);

//-----------------------------------------------------------------------------------------------------

logic   [3:0]                           init_q;
logic   [18:0]                          init_done;
logic                                   init_done_q;

logic                                   cfg_write_bad_parity_q;

hqm_system_ingress_cfg_signal_t         cfg_re_next;
hqm_system_ingress_cfg_signal_t         cfg_re_q;
hqm_system_ingress_cfg_signal_t         cfg_re_v;
hqm_system_ingress_cfg_signal_t         cfg_we_next;
hqm_system_ingress_cfg_signal_t         cfg_we_q;
hqm_system_ingress_cfg_signal_t         cfg_we_v;
logic   [11:0]                          cfg_addr_q;
logic   [31:0]                          cfg_wdata_q;
logic                                   cfg_taken_next;
logic                                   cfg_taken_q;
logic                                   cfg_taken_p0;
logic                                   cfg_taken_p3;
logic                                   cfg_taken_p6;

logic                                   cfg_re_in;
logic                                   cfg_we_in;
logic                                   cfg_re_p2;
logic                                   cfg_we_p2;
logic                                   cfg_re_p5;
logic                                   cfg_we_p5;

hqm_system_ingress_cfg_data_t           cfg_rdata_lut;
logic                                   cfg_rdata_v_p2_next;
logic                                   cfg_rdata_v_p5_next;
logic                                   cfg_rdata_v_p8_next;
logic                                   cfg_rdata_v_p2_q;
logic                                   cfg_rdata_v_p5_q;
logic                                   cfg_rdata_v_p8_q;
logic   [31:0]                          cfg_rdata_p2_next;
logic   [31:0]                          cfg_rdata_p2_q;
logic   [31:0]                          cfg_rdata_p5_next;
logic   [31:0]                          cfg_rdata_p5_q;
logic   [31:0]                          cfg_rdata_p8_next;
logic   [31:0]                          cfg_rdata_p8_q;
logic   [31:0]                          cfg_rdata_next;
logic   [31:0]                          cfg_rdata_q;
logic                                   cfg_rvalid_next;
logic                                   cfg_wvalid_next;
logic                                   cfg_rvalid_q;
logic                                   cfg_wvalid_q;

logic   [NUM_DIR_PP-1:0]                cfg_dir_pp_rob_v;
logic   [NUM_LDB_PP-1:0]                cfg_ldb_pp_rob_v;

logic                                   hcw_enq_in_v_q;
hqm_system_enq_data_in_t                hcw_enq_in_data_q;

logic                                   hcw_enq_fifo_afull_raw;
logic                                   hcw_enq_fifo_afull;
logic                                   hcw_enq_fifo_push;
hqm_system_enq_data_in_t                hcw_enq_fifo_push_data;
logic                                   hcw_enq_fifo_pop;
logic                                   hcw_enq_fifo_pop_data_v;
hqm_system_enq_data_in_t                hcw_enq_fifo_pop_data;
logic   [1:0]                           hcw_enq_inj_ecc_err_q;
logic   [1:0]                           hcw_enq_inj_ecc_err_last_q;
logic                                   hcw_enq_fifo_push_empty;

logic                                   rob_enq_in_ready;
logic                                   rob_enq_in_v;
hqm_system_enq_data_in_t                rob_enq_in;
logic                                   rob_enq_out_mask;
logic                                   rob_enq_out_ready;
logic                                   rob_enq_out_ready_limited;
logic                                   rob_enq_out_v;
hqm_system_enq_data_rob_t               rob_enq_out;
logic   [127:64]                        rob_enq_out_corrected;
logic                                   rob_enq_out_taken;
logic                                   rob_enq_out_hcw_parity_ms;
logic                                   rob_enq_out_sb_ecc_error;
logic                                   rob_enq_out_mb_ecc_error;

hqm_system_enq_data_p02_t               rob_enq_data;

logic                                   p0_ready;
logic                                   p0_hold;
logic                                   p0_load;
logic                                   p0_v_next;
logic                                   p0_v_q;
logic                                   p0_cfg_next;
logic                                   p0_cfg_q;
logic                                   p0_cfg_we_q;
hqm_system_enq_data_p02_t               p0_data_q;
logic                                   p0_debug_q;
logic                                   p0_step_q;
logic                                   p0_sb_ecc_error_q;
logic   [7:0]                           p0_vpp_scaled;
logic   [HQM_SYSTEM_VDEV_WIDTH-1:0]     p0_dir_vdev;
logic   [HQM_SYSTEM_VDEV_WIDTH-1:0]     p0_ldb_vdev;
logic   [HQM_SYSTEM_VDEV_WIDTH-1:0]     p0_vdev;
logic                                   p0_vdev_par_adj;

logic                                   p1_hold;
logic                                   p1_load;
logic                                   p1_v_q;
logic                                   p1_cfg_q;
logic                                   p1_cfg_we_q;
hqm_system_enq_data_p02_t               p1_data_q;

logic                                   p2_hold;
logic                                   p2_load;
logic                                   p2_v_q;
logic                                   p2_v;
logic                                   p2_taken;
logic                                   p2_cfg_q;
logic   [1:0]                           p2_cfg_we_q;
hqm_system_enq_data_p02_t               p2_data_q;
logic                                   p2_vpp_v_dir;
logic                                   p2_vpp_v_ldb;
logic                                   p2_vpp_v_luts;
logic                                   p2_pp_v_dir;
logic                                   p2_pp_v_ldb;
logic                                   p2_pp_v_luts;
logic                                   p2_pp_v;
logic   [HQM_SYSTEM_DIR_PP_WIDTH-1:0]   p2_pp_dir;
logic   [HQM_SYSTEM_LDB_PP_WIDTH-1:0]   p2_pp_ldb;
logic   [HQM_SYSTEM_HCW_PP_WIDTH-1:0]   p2_pp_dir_scaled;
logic   [HQM_SYSTEM_HCW_PP_WIDTH-1:0]   p2_pp_ldb_scaled;
logic   [HQM_SYSTEM_HCW_PP_WIDTH-1:0]   p2_pp_luts;
logic   [HQM_SYSTEM_HCW_PP_WIDTH-1:0]   p2_pp;
logic                                   p2_vqid_v_dir;
logic                                   p2_vqid_v_ldb;
logic                                   p2_vqid_v_luts;
logic                                   p2_qid_v_dir;
logic                                   p2_qid_v_ldb;
logic                                   p2_qid_v_luts;
logic                                   p2_qid_v;
logic   [HQM_SYSTEM_DIR_QID_WIDTH-1:0]  p2_qid_dir;
logic   [HQM_SYSTEM_LDB_QID_WIDTH-1:0]  p2_qid_ldb;
logic   [7:0]                           p2_qid;
logic   [7:0]                           p2_hcw_qid;
logic   [HQM_SYSTEM_HCW_PP_WIDTH-1:0]   p2_vpp_scaled;
logic                                   p2_perr;

logic                                   p3_hold;
logic                                   p3_load;
logic                                   p3_v_next;
logic                                   p3_v_q;
logic                                   p3_cfg_next;
logic                                   p3_cfg_q;
logic                                   p3_cfg_we_q;
hqm_system_enq_data_p35_t               p3_data_next;
hqm_system_enq_data_p35_t               p3_data_q;
logic                                   p3_lut_hold;
logic   [2:0]                           p3_sb_ecc_error_q;
logic   [2:0]                           p3_mb_ecc_error_q;
logic   [7:0]                           p3_synd_q;

logic                                   p4_hold;
logic                                   p4_load;
logic                                   p4_v_q;
logic                                   p4_cfg_q;
logic                                   p4_cfg_we_q;
hqm_system_enq_data_p35_t               p4_data_q;

logic                                   p5_hold;
logic                                   p5_load;
logic                                   p5_v_q;
logic                                   p5_v;
logic                                   p5_taken;
logic                                   p5_cfg_q;
logic   [1:0]                           p5_cfg_we_q;
hqm_system_enq_data_p35_t               p5_data_q;
logic   [HQM_SYSTEM_VAS_WIDTH-1:0]      p5_vas_dir;
logic   [HQM_SYSTEM_VAS_WIDTH-1:0]      p5_vas_ldb;
logic   [HQM_SYSTEM_VAS_WIDTH-1:0]      p5_vas;
logic   [2:0]                           p5_qid_cfg_v;
logic                                   p5_perr;
logic                                   p5_qid_cfg_v_perr;

logic                                   p6_hold;
logic                                   p6_load;
logic                                   p6_v_next;
logic                                   p6_v_q;
logic                                   p6_cfg_next;
logic                                   p6_cfg_q;
logic                                   p6_cfg_we_q;
hqm_system_enq_data_p68_t               p6_data_next;
hqm_system_enq_data_p68_t               p6_data_q;
logic                                   p6_lut_hold;

logic                                   p7_hold;
logic                                   p7_load;
logic                                   p7_v_q;
logic                                   p7_cfg_q;
logic                                   p7_cfg_we_q;
hqm_system_enq_data_p68_t               p7_data_q;

logic                                   p8_hold;
logic                                   p8_load;
logic                                   p8_v_q;
logic                                   p8_v;
logic                                   p8_cfg_q;
logic   [1:0]                           p8_cfg_we_q;
hqm_system_enq_data_p68_t               p8_data_q;
logic                                   p8_vasqid_v_dir;
logic                                   p8_vasqid_v_ldb;
logic                                   p8_vasqid_v;
logic                                   p8_qid_its_dir;
logic                                   p8_qid_its_ldb;
logic                                   p8_qid_its;
logic                                   p8_port_perr;
logic                                   p8_perr;
logic   [63:0]                          p8_hcw_corrected;
logic                                   p8_sb_ecc_error;
logic                                   p8_mb_ecc_error;
logic                                   p8_hcw_parity_ls;
logic                                   p8_inj_par_err_q;
logic                                   p8_inj_par_err_last_q;
logic   [1:0]                           p8_inj_ecc_err_q;
logic   [1:0]                           p8_inj_ecc_err_last_q;
logic   [7:0]                           p8_vpp_scaled;

logic                                   p9_load;
logic                                   p9_sb_ecc_error_q;
logic   [7:0]                           p9_synd_q;

logic                                   hcw_enq_lut_hold;

logic                                   hcw_enq_out_ready;

hqm_system_enq_data_out_t               hcw_enq_out_data;

logic   [2:0]                           hcw_debug_q;
logic                                   hcw_step_q;
logic                                   hcw_mask_q;

logic                                   hcw_enq_w_ready;
logic                                   hcw_enq_w_v;
logic                                   agg_hcw_enq_w_ready;
logic                                   agg_hcw_enq_w_v;
logic                                   hcw_enq_w_int_ready;
logic                                   hcw_enq_w_int_valid;
hcw_enq_w_req_t                         hcw_enq_w;

hqm_system_ingress_cfg_signal_t         lut_err;
new_INGRESS_LUT_ERR_t                   lut_err_next;
new_INGRESS_LUT_ERR_t                   lut_err_q;
logic                                   perr_next;
logic                                   perr_q;

logic                                   ingress_idle_next;
logic                                   ingress_idle_q;

logic   [2:0]                           lut_mb_ecc_err;
logic   [2:0]                           lut_sb_ecc_err;

hqm_system_memi_lut_ldb_qid_cfg_v_t     memi_lut_ldb_qid_cfg_v;
hqm_system_memo_lut_ldb_qid_cfg_v_t     memo_lut_ldb_qid_cfg_v;

logic                                   ingress_alarm_v_next;
logic                                   ingress_alarm_v_q;
hqm_system_ingress_alarm_t              ingress_alarm_next;
hqm_system_ingress_alarm_t              ingress_alarm_q;

hqm_system_memi_lut_dir_qid_its_t       memi_lut_dir_qid_its;
hqm_system_memo_lut_dir_qid_its_t       memo_lut_dir_qid_its;

hqm_system_memi_lut_ldb_qid_its_t       memi_lut_ldb_qid_its;
hqm_system_memo_lut_ldb_qid_its_t       memo_lut_ldb_qid_its;

genvar                                  g;

//-----------------------------------------------------------------------------------------------------
// Decode cfg access to individual memories here

assign cfg_re_next    = cfg_re & ~cfg_rvalid;
assign cfg_we_next    = cfg_we & ~cfg_wvalid;
assign cfg_taken_next = (|{cfg_taken_q, cfg_taken_p0, cfg_taken_p3, cfg_taken_p6}) &
                        ~(cfg_rvalid_q | cfg_wvalid_q);

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  init_q             <= '0;
  init_done_q        <= '0;
  cfg_taken_q        <= '0;
  cfg_re_q           <= '0;
  cfg_we_q           <= '0;
 end else begin
  init_q             <= {1'b1, init_q[3:1]};
  init_done_q        <= &init_done;
  cfg_taken_q        <= cfg_taken_next;
  if (init_done_q) begin
   cfg_re_q          <= cfg_re_next;
   cfg_we_q          <= cfg_we_next;
  end
 end
end

assign rst_done = init_done_q;

always_ff @(posedge hqm_gated_clk) begin
 if (~cfg_taken_q) cfg_addr_q  <= cfg_addr;
 if (~cfg_taken_q) cfg_wdata_q <= cfg_wdata;
 cfg_write_bad_parity_q        <= cfg_write_bad_parity;
end

assign cfg_re_in = (|{cfg_re_q.vf_dir_vpp2pp
                     ,cfg_re_q.vf_ldb_vpp2pp
                     ,cfg_re_q.vf_dir_vpp_v
                     ,cfg_re_q.vf_ldb_vpp_v
                     ,cfg_re_q.dir_pp_v
                     ,cfg_re_q.ldb_pp_v
                     ,cfg_re_q.vf_dir_vqid2qid
                     ,cfg_re_q.vf_ldb_vqid2qid
                     ,cfg_re_q.vf_dir_vqid_v
                     ,cfg_re_q.vf_ldb_vqid_v
                     ,cfg_re_q.dir_qid_v
                     ,cfg_re_q.ldb_qid_v
}) & (~cfg_taken_q);

assign cfg_we_in = (|{cfg_we_q.vf_dir_vpp2pp
                     ,cfg_we_q.vf_ldb_vpp2pp
                     ,cfg_we_q.vf_dir_vpp_v
                     ,cfg_we_q.vf_ldb_vpp_v
                     ,cfg_we_q.dir_pp_v
                     ,cfg_we_q.ldb_pp_v
                     ,cfg_we_q.vf_dir_vqid2qid
                     ,cfg_we_q.vf_ldb_vqid2qid
                     ,cfg_we_q.vf_dir_vqid_v
                     ,cfg_we_q.vf_ldb_vqid_v
                     ,cfg_we_q.dir_qid_v
                     ,cfg_we_q.ldb_qid_v
}) & (~cfg_taken_q);

assign cfg_re_p2 = (|{cfg_re_q.dir_pp2vas
                     ,cfg_re_q.ldb_pp2vas
                     ,cfg_re_q.ldb_qid_cfg_v
}) & (~cfg_taken_q);

assign cfg_we_p2 = (|{cfg_we_q.dir_pp2vas
                     ,cfg_we_q.ldb_pp2vas
                     ,cfg_we_q.ldb_qid_cfg_v
}) & (~cfg_taken_q);

assign cfg_re_p5 = (|{cfg_re_q.dir_vasqid_v
                     ,cfg_re_q.ldb_vasqid_v
                     ,cfg_re_q.dir_qid_its
                     ,cfg_re_q.ldb_qid_its
}) & (~cfg_taken_q);

assign cfg_we_p5 = (|{cfg_we_q.dir_vasqid_v
                     ,cfg_we_q.ldb_vasqid_v
                     ,cfg_we_q.dir_qid_its
                     ,cfg_we_q.ldb_qid_its
}) & (~cfg_taken_q);

assign cfg_re_v.vf_dir_vpp2pp     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_dir_vpp2pp;
assign cfg_re_v.vf_ldb_vpp2pp     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_ldb_vpp2pp;
assign cfg_re_v.vf_dir_vpp_v      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_dir_vpp_v;
assign cfg_re_v.vf_ldb_vpp_v      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_ldb_vpp_v;
assign cfg_re_v.dir_pp_v          = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_pp_v;
assign cfg_re_v.ldb_pp_v          = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_pp_v;
assign cfg_re_v.vf_dir_vqid2qid   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_dir_vqid2qid;
assign cfg_re_v.vf_ldb_vqid2qid   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_ldb_vqid2qid;
assign cfg_re_v.vf_dir_vqid_v     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_dir_vqid_v;
assign cfg_re_v.vf_ldb_vqid_v     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.vf_ldb_vqid_v;
assign cfg_re_v.dir_qid_v         = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_qid_v;
assign cfg_re_v.ldb_qid_v         = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_qid_v;

assign cfg_we_v.vf_dir_vpp2pp     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_dir_vpp2pp;
assign cfg_we_v.vf_ldb_vpp2pp     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_ldb_vpp2pp;
assign cfg_we_v.vf_dir_vpp_v      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_dir_vpp_v;
assign cfg_we_v.vf_ldb_vpp_v      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_ldb_vpp_v;
assign cfg_we_v.dir_pp_v          = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_pp_v;
assign cfg_we_v.ldb_pp_v          = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_pp_v;
assign cfg_we_v.vf_dir_vqid2qid   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_dir_vqid2qid;
assign cfg_we_v.vf_ldb_vqid2qid   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_ldb_vqid2qid;
assign cfg_we_v.vf_dir_vqid_v     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_dir_vqid_v;
assign cfg_we_v.vf_ldb_vqid_v     = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.vf_ldb_vqid_v;
assign cfg_we_v.dir_qid_v         = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_qid_v;
assign cfg_we_v.ldb_qid_v         = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_qid_v;

assign cfg_re_v.dir_pp2vas        = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_re_q.dir_pp2vas;
assign cfg_re_v.ldb_pp2vas        = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_pp2vas;
assign cfg_re_v.ldb_qid_cfg_v     = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_qid_cfg_v;

assign cfg_we_v.dir_pp2vas        = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_we_q.dir_pp2vas;
assign cfg_we_v.ldb_pp2vas        = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_pp2vas;
assign cfg_we_v.ldb_qid_cfg_v     = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_qid_cfg_v;

assign cfg_re_v.dir_vasqid_v      = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_re_q.dir_vasqid_v;
assign cfg_re_v.ldb_vasqid_v      = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_vasqid_v;
assign cfg_re_v.dir_qid_its       = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_re_q.dir_qid_its;
assign cfg_re_v.ldb_qid_its       = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_qid_its;

assign cfg_we_v.dir_vasqid_v      = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_we_q.dir_vasqid_v;
assign cfg_we_v.ldb_vasqid_v      = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_vasqid_v;
assign cfg_we_v.dir_qid_its       = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_we_q.dir_qid_its;
assign cfg_we_v.ldb_qid_its       = (~|{p6_v_q, p7_v_q, p8_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_qid_its;

//-----------------------------------------------------------------------------------------------------
// OR together all the P2, P5, and P8 cfg read data paths
// Can then OR together the p2, p5, and p8 lookups into one cfg response

assign cfg_rdata_p2_next   = cfg_rdata_lut.vf_dir_vpp2pp     | cfg_rdata_lut.vf_ldb_vpp2pp     |
                             cfg_rdata_lut.vf_dir_vpp_v      | cfg_rdata_lut.vf_ldb_vpp_v      |
                             cfg_rdata_lut.dir_pp_v          | cfg_rdata_lut.ldb_pp_v          |
                             cfg_rdata_lut.vf_dir_vqid2qid   | cfg_rdata_lut.vf_ldb_vqid2qid   |
                             cfg_rdata_lut.vf_dir_vqid_v     | cfg_rdata_lut.vf_ldb_vqid_v     |
                             cfg_rdata_lut.dir_qid_v         | cfg_rdata_lut.ldb_qid_v         ;

assign cfg_rdata_p5_next   = cfg_rdata_lut.dir_pp2vas        | cfg_rdata_lut.ldb_pp2vas        |
                             cfg_rdata_lut.ldb_qid_cfg_v     ;

assign cfg_rdata_p8_next   = cfg_rdata_lut.dir_vasqid_v      | cfg_rdata_lut.ldb_vasqid_v      |
                             cfg_rdata_lut.dir_qid_its       | cfg_rdata_lut.ldb_qid_its       ;

// CFG read data is valid when the memory output pipeline stage valid (p2/5/8_v_q) is asserted and
// the CFG flop is set but the write indication (p2/5/8_cfg_we_q) is not asserted.  Can ack CFG
// writes when the memory output pipeline stage is valid and the write indication is asserted.

assign cfg_rdata_v_p2_next = p2_v_q & p2_cfg_q & ~(|p2_cfg_we_q);
assign cfg_rdata_v_p5_next = p5_v_q & p5_cfg_q & ~(|p5_cfg_we_q);
assign cfg_rdata_v_p8_next = p8_v_q & p8_cfg_q & ~(|p8_cfg_we_q);

assign cfg_rvalid_next     = cfg_rdata_v_p2_q | cfg_rdata_v_p5_q | cfg_rdata_v_p8_q;
assign cfg_wvalid_next     = (&{p2_v_q,p2_cfg_we_q}) | (&{p5_v_q,p5_cfg_we_q}) | (&{p8_v_q,p8_cfg_we_q});

assign cfg_rdata_next      = (cfg_rdata_p2_q & {32{cfg_rdata_v_p2_q}}) |
                             (cfg_rdata_p5_q & {32{cfg_rdata_v_p5_q}}) |
                             (cfg_rdata_p8_q & {32{cfg_rdata_v_p8_q}});

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cfg_rdata_v_p2_q <= '0;
  cfg_rdata_v_p5_q <= '0;
  cfg_rdata_v_p8_q <= '0;
  cfg_rdata_p2_q   <= '0;
  cfg_rdata_p5_q   <= '0;
  cfg_rdata_p8_q   <= '0;
  cfg_rdata_q      <= '0;
  cfg_rvalid_q     <= '0;
  cfg_wvalid_q     <= '0;
 end else begin
  cfg_rdata_v_p2_q <= cfg_rdata_v_p2_next;
  cfg_rdata_v_p5_q <= cfg_rdata_v_p5_next;
  cfg_rdata_v_p8_q <= cfg_rdata_v_p8_next;
  if (cfg_rdata_v_p2_next) cfg_rdata_p2_q <= cfg_rdata_p2_next;
  if (cfg_rdata_v_p5_next) cfg_rdata_p5_q <= cfg_rdata_p5_next;
  if (cfg_rdata_v_p8_next) cfg_rdata_p8_q <= cfg_rdata_p8_next;
  if (cfg_rvalid_next)     cfg_rdata_q    <= cfg_rdata_next;
  cfg_rvalid_q     <= cfg_rvalid_next;
  cfg_wvalid_q     <= cfg_wvalid_next;
 end
end

assign cfg_rvalid = cfg_re_q & {$bits(cfg_rvalid){cfg_rvalid_q}};
assign cfg_wvalid = cfg_we_q & {$bits(cfg_wvalid){cfg_wvalid_q}};
assign cfg_error  = (cfg_re_q | cfg_we_q) & {$bits(cfg_error){1'b0}};        // For now
assign cfg_rdata  = cfg_rdata_q;

//-----------------------------------------------------------------------------------------------------
// HCW Enqueue Input FIFO

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_n) begin
 if (~prim_gated_rst_n) begin
  hcw_enq_in_v_q    <= '0;
  hcw_enq_in_data_q <= '0;
 end else begin
  hcw_enq_in_v_q    <= hcw_enq_in_v & ~hcw_enq_fifo_afull;
  if (hcw_enq_in_v & ~hcw_enq_fifo_afull) hcw_enq_in_data_q <= hcw_enq_in_data;
 end
end

assign hcw_enq_fifo_push      = hcw_enq_in_v_q;
assign hcw_enq_fifo_push_data = hcw_enq_in_data_q;

// The watermark shouldn't be changed when the data path is active but adding a
// sync to avoid metastability on the bits.

logic   [$bits(cfg_hcw_enq_fifo_high_wm)-1:0]   cfg_hcw_enq_fifo_high_wm_sync;

hqm_AW_sync #(.WIDTH($bits(cfg_hcw_enq_fifo_high_wm))) i_cfg_hcw_enq_fifo_high_wm_sync (

     .clk                   (prim_gated_clk)
    ,.data                  (cfg_hcw_enq_fifo_high_wm)
    ,.data_sync             (cfg_hcw_enq_fifo_high_wm_sync)
);

logic   [8:0]   hcw_enq_fifo_push_depth_nc;
logic           hcw_enq_fifo_push_full_nc;
logic           hcw_enq_fifo_push_aempty_nc;
logic   [8:0]   hcw_enq_fifo_pop_depth_nc;
logic           hcw_enq_fifo_pop_aempty_nc;
logic           hcw_enq_fifo_pop_empty_nc;

hqm_AW_fifo_control_gdc_wdb #(

     .DEPTH                 (HQM_SYSTEM_DEPTH_HCW_ENQ_FIFO)
    ,.DWIDTH                (HQM_SYSTEM_DWIDTH_HCW_ENQ_FIFO)

) i_hcw_enq_fifo (

     .clk_push              (prim_gated_clk)
    ,.rst_push_n            (prim_gated_rst_n)

    ,.clk_pop               (hqm_gated_clk)
    ,.rst_pop_n             (hqm_gated_rst_n)

    ,.cfg_high_wm           (cfg_hcw_enq_fifo_high_wm_sync)
    ,.cfg_low_wm            ('0)

    ,.fifo_enable           (hqm_enq_fifo_enable)

    ,.clear_pop_state       ('0)

    ,.push                  (hcw_enq_fifo_push)
    ,.push_data             (hcw_enq_fifo_push_data)

    ,.pop                   (hcw_enq_fifo_pop)
    ,.pop_data_v            (hcw_enq_fifo_pop_data_v)
    ,.pop_data              (hcw_enq_fifo_pop_data)

    ,.mem_we                (memi_hcw_enq_fifo.we)
    ,.mem_waddr             (memi_hcw_enq_fifo.waddr)
    ,.mem_wdata             (memi_hcw_enq_fifo.wdata)
    ,.mem_re                (memi_hcw_enq_fifo.re)
    ,.mem_raddr             (memi_hcw_enq_fifo.raddr)
    ,.mem_rdata             (memo_hcw_enq_fifo.rdata)

    ,.fifo_push_depth       (hcw_enq_fifo_push_depth_nc)
    ,.fifo_push_full        (hcw_enq_fifo_push_full_nc)
    ,.fifo_push_afull       (hcw_enq_fifo_afull_raw)
    ,.fifo_push_empty       (hcw_enq_fifo_push_empty)
    ,.fifo_push_aempty      (hcw_enq_fifo_push_aempty_nc)

    ,.fifo_pop_depth        (hcw_enq_fifo_pop_depth_nc)
    ,.fifo_pop_aempty       (hcw_enq_fifo_pop_aempty_nc)
    ,.fifo_pop_empty        (hcw_enq_fifo_pop_empty_nc)

    ,.fifo_status           (hcw_enq_fifo_status)
    ,.db_status             (hcw_enq_db_status)
);

hqm_AW_sync_rst0 i_hqm_enq_fifo_idle (

     .clk                   (hqm_inp_gated_clk)
    ,.rst_n                 (hqm_inp_gated_rst_n)
    ,.data                  (hcw_enq_fifo_push_empty)
    ,.data_sync             (hqm_enq_fifo_idle)
);

assign hcw_enq_in_ready        = ~hcw_enq_fifo_afull;

// Add reorder buffer on the output of the FIFO

assign hcw_enq_fifo_pop = hcw_enq_fifo_pop_data_v & rob_enq_in_ready;

assign rob_enq_in_v     = hcw_enq_fifo_pop_data_v;
assign rob_enq_in       = hcw_enq_fifo_pop_data;

hqm_system_rob i_hqm_system_rob (

     .hqm_gated_clk         (hqm_gated_clk)
    ,.hqm_gated_rst_n       (hqm_gated_rst_n)

    ,.rob_enq_in_ready      (rob_enq_in_ready)
    ,.rob_enq_in_v          (rob_enq_in_v)
    ,.rob_enq_in            (rob_enq_in)

    ,.rob_enq_out_ready     (rob_enq_out_ready_limited)
    ,.rob_enq_out_v         (rob_enq_out_v)
    ,.rob_enq_out           (rob_enq_out)

    ,.cfg_dir_pp_rob_v      (cfg_dir_pp_rob_v)
    ,.cfg_ldb_pp_rob_v      (cfg_ldb_pp_rob_v)

    ,.rob_error             (rob_error)
    ,.rob_error_synd        (rob_error_synd)
    ,.rob_syndrome          (rob_syndrome)

    ,.memi_rob_mem          (memi_rob_mem)
    ,.memo_rob_mem          (memo_rob_mem)
);

assign rob_enq_out_taken = rob_enq_out_v & rob_enq_out_ready_limited;

// Check ECC on hcw upper half; pointer in lower half is not used or modified by the pipeline
// so carry the ECC on the lower half through the whole pipeline and check/correct at the end.

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  hcw_enq_inj_ecc_err_q      <= '0;
  hcw_enq_inj_ecc_err_last_q <= '0;
 end else begin
  hcw_enq_inj_ecc_err_q      <= cfg_inj_ecc_err_ingress[1:0];
  hcw_enq_inj_ecc_err_last_q <= hcw_enq_inj_ecc_err_q & (hcw_enq_inj_ecc_err_last_q | {2{rob_enq_out_taken}});
 end
end

hqm_AW_ecc_check #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_hcw_enq_ecc_check_ms ( 

         .din_v     (rob_enq_out_taken)
        ,.din       ({ rob_enq_out.hcw[127:66]
                     ,(rob_enq_out.hcw[65] ^ (  hcw_enq_inj_ecc_err_q[0] & ~hcw_enq_inj_ecc_err_last_q[0] ))
                     ,(rob_enq_out.hcw[64] ^ (|(hcw_enq_inj_ecc_err_q    & ~hcw_enq_inj_ecc_err_last_q   )))
                    })
        ,.ecc       (rob_enq_out.ecc_h)
        ,.enable    (1'b1)
        ,.correct   (1'b1)

        ,.dout      (rob_enq_out_corrected[127:64])

        ,.error_sb  (rob_enq_out_sb_ecc_error)
        ,.error_mb  (rob_enq_out_mb_ecc_error)
);

// Generate parity on the uncorrected data instead of corrected data for timing
// and adjust later if sb ECC error detected.

hqm_AW_parity_gen #(.WIDTH(64)) i_rob_enq_out_hcw_parity_ms (

         .d         ({ rob_enq_out.hcw[127:66]
                     ,(rob_enq_out.hcw[65] ^ (  hcw_enq_inj_ecc_err_q[0] & ~hcw_enq_inj_ecc_err_last_q[0] ))
                     ,(rob_enq_out.hcw[64] ^ (|(hcw_enq_inj_ecc_err_q    & ~hcw_enq_inj_ecc_err_last_q   )))
                    })
        ,.odd       (1'b1)
        ,.p         (rob_enq_out_hcw_parity_ms)
);

//-----------------------------------------------------------------------------------------------------
// Rate limit the ROB output entering the ingress pipeline
//-----------------------------------------------------------------------------------------------------

assign rob_enq_out_mask  = cfg_ingress_ctl.HOLD_HCW_ENQ    &  p0_debug_q &
                         ~(cfg_ingress_ctl.SINGLE_STEP_ENQ & ~p0_step_q);

assign rob_enq_out_ready = p0_ready & ~rob_enq_out_mask;

hqm_AW_pipe_rate_limit #(.WIDTH(1), .DEPTH(10)) i_enq_rate_limit (  

     .cfg           (cfg_ingress_ctl.ENQ_RATE_LIMIT)
    ,.pipe_v        ({hcw_enq_w_int_valid,
                      p8_v_q, p7_v_q, p6_v_q, p5_v_q, p4_v_q, p3_v_q, p2_v_q, p1_v_q, p0_v_q})

    ,.v_in          (rob_enq_out_ready)

    ,.v_out         (rob_enq_out_ready_limited)
);

//-----------------------------------------------------------------------------------------------------
// P0
//-----------------------------------------------------------------------------------------------------

// Each pipeline stage can advance as long as the next pipeline stage is either not valid or is valid
// but is not holding.  The exception is CFG writes which, due to the fact that we may be doing a
// read-modify-write, may need to stall the pipeline above the access for at least an additional 3
// clock cycles over a normal access (or CFG read access).  The memory accesses occur in pipeline
// stages 0, 3, and 6.  For a CFG RMW, p0/3/6 is reading the memory, p1/4/7 has valid memory output
// data, p2/5/8 registers that read data, and the next cycle we are writing the memory with the modified
// data; so we need to stall for those 3 additional stages.  A p*_cfg_q flop tracks that the access is a
// CFG access and blocks any CFG access from propagating past stages p2/5/7 and keeps holds from
// propagating backwards from stages p3/6/output to stages p2/5/8.  A p*_cfg_we_q flop tracks
// that the access is a CFG write.  Adding the 3 clock stall by allowing p0/3/6_cfg_we_q to load
// as an indication of how many cycles we've stalled (when both bits of p2/5/8_cfg_we_q are set, we
// have stalled for the required amount of clocks and nothing further can hold up the CFG RMW, so
// we can set the downstream valid (P1/4/7_v_q) then, and let it terminate at the P2/5/8 stages).
// So the code below for P0, and further on for P3 and P6, forces the upstream hold (P0/3/6_hold)
// and prevents the setting of the P1/4/7_v_q based on the state of the p*_cfg_we_q flops.

HQM_DIR_PP2VDEV_t [(1<<HQM_SYSTEM_DIR_PP_WIDTH)-1:0] dir_pp2vdev_scaled;
HQM_LDB_PP2VDEV_t [(1<<HQM_SYSTEM_LDB_PP_WIDTH)-1:0] ldb_pp2vdev_scaled;

always_comb begin: scale_vdev

  for (int i=0; i<(1<<HQM_SYSTEM_DIR_PP_WIDTH); i=i+1) begin
   dir_pp2vdev_scaled[i] = '0;
   if (i < NUM_DIR_PP) dir_pp2vdev_scaled[i] = dir_pp2vdev[i];
  end

  for (int i=0; i<(1<<HQM_SYSTEM_LDB_PP_WIDTH); i=i+1) begin
   ldb_pp2vdev_scaled[i] = '0;
   if (i < NUM_LDB_PP) ldb_pp2vdev_scaled[i] = ldb_pp2vdev[i];
  end

end

assign p0_dir_vdev = dir_pp2vdev_scaled[rob_enq_out.vpp[HQM_SYSTEM_DIR_PP_WIDTH-1:0]].VDEV;
assign p0_ldb_vdev = ldb_pp2vdev_scaled[rob_enq_out.vpp[HQM_SYSTEM_LDB_PP_WIDTH-1:0]].VDEV;

assign p0_vdev     = (rob_enq_out.is_ldb_port) ? p0_ldb_vdev : p0_dir_vdev;

always_comb begin
  p0_vdev_par_adj = ^{((rob_enq_out.is_ldb_port) ? p0_ldb_vdev : p0_dir_vdev)};
end

always_comb begin
  rob_enq_data.mb_ecc_err    = rob_enq_out_mb_ecc_error & cfg_hcw_enq_ecc_enable;
  rob_enq_data.hcw_parity_ms = rob_enq_out_hcw_parity_ms ^ rob_enq_out_sb_ecc_error;
  rob_enq_data.ecc_l         = rob_enq_out.ecc_l;
  rob_enq_data.is_nm_pf      = rob_enq_out.is_nm_pf;
  rob_enq_data.is_pf_port    = rob_enq_out.is_pf_port;
  rob_enq_data.is_ldb_port   = rob_enq_out.is_ldb_port;
  rob_enq_data.vdev          = p0_vdev;
  rob_enq_data.vpp           = rob_enq_out.vpp;
  rob_enq_data.hcw           = {rob_enq_out_corrected[127:64], rob_enq_out.hcw[63:0]};

  // Need to adjust the parity for the vdev and mb_ecc_err pipeline field additions
  // Parity was already adjusted in the ROB for removal of the cl and cli fields.

  rob_enq_data.port_parity   = ^{rob_enq_out.port_parity, p0_vdev_par_adj, rob_enq_data.mb_ecc_err};
end

logic unused_sigs;

always_comb begin: unused_sig_bits
 unused_sigs = '0;
 unused_sigs |= (|rob_enq_out.spare);
 for (int i=0; i<NUM_DIR_PP; i=i+1) begin
  cfg_dir_pp_rob_v[i] = dir_pp_rob_v[i].ROB_V;              // Convert to bit vector
  unused_sigs = |{unused_sigs, dir_pp2vdev[i].reserved0};
  unused_sigs = |{unused_sigs, dir_pp_rob_v[i].reserved0};
 end
 for (int i=0; i<NUM_LDB_PP; i=i+1) begin
  cfg_ldb_pp_rob_v[i] = ldb_pp_rob_v[i].ROB_V;              // Convert to bit vector
  unused_sigs = |{unused_sigs, ldb_pp2vdev[i].reserved0};
  unused_sigs = |{unused_sigs, ldb_pp_rob_v[i].reserved0};
 end
end

hqm_AW_unused_bits i_unused_sigs ( 

        .a      (unused_sigs)
);

assign p0_cfg_next = cfg_re_in | cfg_we_in;

assign p0_v_next   = cfg_taken_p0 | rob_enq_out_taken;

assign p0_hold = p0_v_q & (p1_hold | (p0_cfg_we_q & ~(&p2_cfg_we_q)));
assign p0_load = p0_v_next;

assign cfg_taken_p0 = p0_cfg_next & ~|{p0_v_q, p1_v_q, p2_v_q};

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p0_v_q            <= '0;
  p0_cfg_q          <= '0;
  p0_cfg_we_q       <= '0;
  p0_debug_q        <= '0;
  p0_step_q         <= '0;
  p0_sb_ecc_error_q <= '0;
 end else begin
  p0_debug_q        <= cfg_ingress_ctl.ENABLE_DEBUG;
  if (~p0_hold) begin
   p0_v_q           <= p0_v_next;
   p0_cfg_q         <= p0_cfg_next;
   p0_cfg_we_q      <= p0_v_next & cfg_we_in;
   p0_step_q        <= cfg_ingress_ctl.SINGLE_STEP_ENQ;
  end
  p0_sb_ecc_error_q <= rob_enq_out_sb_ecc_error & cfg_hcw_enq_ecc_enable;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p0_load) begin
  if (~p0_cfg_next) p0_data_q <= rob_enq_data;
 end
end

assign p0_ready     = ~(p0_cfg_next | p0_hold) & init_done_q;

// Single bit ECC errors on the HCW ms word reported separately, since they are not reported as part
// of the ingress_error realm.

hqm_AW_width_scale #(.A_WIDTH($bits(p0_data_q.vpp)), .Z_WIDTH(8)) i_p0_vpp_scaled (

         .a         (p0_data_q.vpp)
        ,.z         (p0_vpp_scaled)
);

assign ingress_sb_ecc_error[4]     = p0_sb_ecc_error_q;
assign ingress_ecc_syndrome[23:16] = p0_vpp_scaled;

//-----------------------------------------------------------------------------------------------------
// P1
//-----------------------------------------------------------------------------------------------------

assign p1_hold = p1_v_q &  p2_hold;
assign p1_load = p0_v_q & ~p1_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p1_v_q      <= '0;
  p1_cfg_q    <= '0;
  p1_cfg_we_q <= '0;
 end else if (~p1_hold) begin
  p1_v_q      <= p0_v_q & (~p0_cfg_we_q | (&p2_cfg_we_q));
  p1_cfg_q    <= p0_cfg_q;
  p1_cfg_we_q <= p0_cfg_we_q;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p1_load) begin
  if (~p0_cfg_q) p1_data_q <= p0_data_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// P2
//-----------------------------------------------------------------------------------------------------

assign p2_v     = p2_v_q & ~p2_cfg_q;
assign p2_hold  = p2_v   & (p3_hold | p3_cfg_next);
assign p2_load  = p1_v_q & ~p2_hold;
assign p2_taken = p2_v   & ~p2_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p2_v_q      <= '0;
  p2_cfg_q    <= '0;
  p2_cfg_we_q <= '0;
 end else if (~p2_hold) begin
  p2_v_q      <= p1_v_q;
  p2_cfg_q    <= p1_cfg_q;
  p2_cfg_we_q <= {p1_cfg_we_q, p2_cfg_we_q[1]};
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p2_load) begin
  if (~p1_cfg_q) p2_data_q <= p1_data_q;
 end
end

assign p3_lut_hold = (p3_hold | p3_cfg_next) & ~p2_cfg_q;

logic [HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP-1:0] dir_vf_vpp_lut_addr;
logic [HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP-1:0] ldb_vf_vpp_lut_addr;

generate

 if (NUM_DIR_PP == 96) begin: g_dir_pp96

  assign dir_vf_vpp_lut_addr = ({7'd0, rob_enq_data.vdev} << 6) +                                       // (VF*64) +
                               ({7'd0, rob_enq_data.vdev} << 5) +                                       // (VF*32) +
                               {{(HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP-HQM_SYSTEM_DIR_PP_WIDTH){1'b0}}
                               ,rob_enq_data.vpp[HQM_SYSTEM_DIR_PP_WIDTH-1:0]};                         // VPP

 end else if (NUM_DIR_PP == 48) begin: g_dir_pp48

  assign dir_vf_vpp_lut_addr = ({6'd0, rob_enq_data.vdev} << 5) +                                       // (VF*32) +
                               ({6'd0, rob_enq_data.vdev} << 4) +                                       // (VF*16) +
                               {{(HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP-HQM_SYSTEM_DIR_PP_WIDTH){1'b0}}
                               ,rob_enq_data.vpp[HQM_SYSTEM_DIR_PP_WIDTH-1:0]};                         // VPP

 end else if (NUM_DIR_PP == 24) begin: g_dir_pp24

  assign dir_vf_vpp_lut_addr = ({5'd0, rob_enq_data.vdev} << 4) +                                       // (VF*16) +
                               ({5'd0, rob_enq_data.vdev} << 3) +                                       // (VF*8)  +
                               {{(HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP-HQM_SYSTEM_DIR_PP_WIDTH){1'b0}}
                               ,rob_enq_data.vpp[HQM_SYSTEM_DIR_PP_WIDTH-1:0]};                         // VPP
 end else begin: g_dir_pp_pwr2

  assign dir_vf_vpp_lut_addr = {rob_enq_data.vdev, rob_enq_data.vpp[HQM_SYSTEM_DIR_PP_WIDTH-1:0]};

 end

 if (NUM_LDB_PP == 96) begin: g_ldb_pp96

  assign ldb_vf_vpp_lut_addr = ({7'd0, rob_enq_data.vdev} << 6) +                                       // (VF*64) +
                               ({7'd0, rob_enq_data.vdev} << 5) +                                       // (VF*32) +
                               {{(HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP-HQM_SYSTEM_LDB_PP_WIDTH){1'b0}}
                               ,rob_enq_data.vpp[HQM_SYSTEM_LDB_PP_WIDTH-1:0]};                         // VPP

 end else if (NUM_LDB_PP == 48) begin: g_ldb_pp48

  assign ldb_vf_vpp_lut_addr = ({6'd0, rob_enq_data.vdev} << 5) +                                       // (VF*32) +
                               ({6'd0, rob_enq_data.vdev} << 4) +                                       // (VF*16) +
                               {{(HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP-HQM_SYSTEM_LDB_PP_WIDTH){1'b0}}
                               ,rob_enq_data.vpp[HQM_SYSTEM_LDB_PP_WIDTH-1:0]};                         // VPP

 end else if (NUM_LDB_PP == 24) begin: g_ldb_pp24

  assign ldb_vf_vpp_lut_addr = ({5'd0, rob_enq_data.vdev} << 4) +                                       // (VF*16) +
                               ({5'd0, rob_enq_data.vdev} << 3) +                                       // (VF*8)  +
                               {{(HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP-HQM_SYSTEM_LDB_PP_WIDTH){1'b0}}
                               ,rob_enq_data.vpp[HQM_SYSTEM_LDB_PP_WIDTH-1:0]};                         // VPP
 end else begin: g_ldb_pp_pwr2

  assign ldb_vf_vpp_lut_addr = {rob_enq_data.vdev, rob_enq_data.vpp[HQM_SYSTEM_LDB_PP_WIDTH-1:0]};

 end

endgenerate

hqm_system_lut_ecc #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_DIR_VPP2PP)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP2PP)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_DIR_VPP2PP)

) i_lut_vf_dir_vpp2pp (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.cfg_ecc_enable        (cfg_lut_ecc_enable)
        ,.cfg_write_bad_sb_ecc  (cfg_write_bad_sb_ecc)
        ,.cfg_write_bad_mb_ecc  (cfg_write_bad_mb_ecc)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[0])

        ,.cfg_re                (cfg_re_v.vf_dir_vpp2pp)
        ,.cfg_we                (cfg_we_v.vf_dir_vpp2pp)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP2PP-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_dir_vpp2pp)

        ,.memi                  (memi_lut_vf_dir_vpp2pp)

        ,.memo                  (memo_lut_vf_dir_vpp2pp)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (dir_vf_vpp_lut_addr)
        ,.lut_nord              (rob_enq_data.is_ldb_port | rob_enq_data.is_pf_port)        

        ,.lut_rdata             (p2_pp_dir)
        ,.lut_mb_ecc_err        (lut_mb_ecc_err[0])
        ,.lut_sb_ecc_err        (lut_sb_ecc_err[0])

        ,.lut_hold              (p3_lut_hold)
);

assign lut_err.vf_dir_vpp2pp = lut_mb_ecc_err[0];

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_LDB_VPP2PP)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP2PP)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_LDB_VPP2PP)

) i_lut_vf_ldb_vpp2pp (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[1])

        ,.cfg_re                (cfg_re_v.vf_ldb_vpp2pp)
        ,.cfg_we                (cfg_we_v.vf_ldb_vpp2pp)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP2PP-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_ldb_vpp2pp)

        ,.memi                  (memi_lut_vf_ldb_vpp2pp)

        ,.memo                  (memo_lut_vf_ldb_vpp2pp)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (ldb_vf_vpp_lut_addr)
        ,.lut_nord              (~rob_enq_data.is_ldb_port | rob_enq_data.is_pf_port)       

        ,.lut_rdata             (p2_pp_ldb)
        ,.lut_perr              (lut_err.vf_ldb_vpp2pp)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_DIR_VPP_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_DIR_VPP_V)

) i_lut_vf_dir_vpp_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[2])

        ,.cfg_re                (cfg_re_v.vf_dir_vpp_v)
        ,.cfg_we                (cfg_we_v.vf_dir_vpp_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_dir_vpp_v)

        ,.memi                  (memi_lut_vf_dir_vpp_v)

        ,.memo                  (memo_lut_vf_dir_vpp_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (dir_vf_vpp_lut_addr)
        ,.lut_nord              (rob_enq_data.is_ldb_port | rob_enq_data.is_pf_port)        

        ,.lut_rdata             (p2_vpp_v_dir)
        ,.lut_perr              (lut_err.vf_dir_vpp_v)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_LDB_VPP_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_LDB_VPP_V)

) i_lut_vf_ldb_vpp_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[3])

        ,.cfg_re                (cfg_re_v.vf_ldb_vpp_v)
        ,.cfg_we                (cfg_we_v.vf_ldb_vpp_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_ldb_vpp_v)

        ,.memi                  (memi_lut_vf_ldb_vpp_v)

        ,.memo                  (memo_lut_vf_ldb_vpp_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (ldb_vf_vpp_lut_addr)
        ,.lut_nord              (~rob_enq_data.is_ldb_port | rob_enq_data.is_pf_port)       

        ,.lut_rdata             (p2_vpp_v_ldb)
        ,.lut_perr              (lut_err.vf_ldb_vpp_v)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_PP_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_PP_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_PP_V)

) i_lut_dir_pp_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[4])

        ,.cfg_re                (cfg_re_v.dir_pp_v)
        ,.cfg_we                (cfg_we_v.dir_pp_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_PP_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_PP_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_pp_v)

        ,.memi                  (memi_lut_dir_pp_v)

        ,.memo                  (memo_lut_dir_pp_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (rob_enq_data.vpp[HQM_SYSTEM_DIR_PP_WIDTH-1:0])
        ,.lut_nord              (rob_enq_data.is_ldb_port | ~rob_enq_data.is_pf_port | rob_enq_data.is_nm_pf)   

        ,.lut_rdata             (p2_pp_v_dir)
        ,.lut_perr              (lut_err.dir_pp_v)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_memi_lut_ldb_pp_v_t  memi_lut_ldb_pp_v;
hqm_system_memo_lut_ldb_pp_v_t  memo_lut_ldb_pp_v;

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_PP_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_PP_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_PP_V)

) i_lut_ldb_pp_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[5])

        ,.cfg_re                (cfg_re_v.ldb_pp_v)
        ,.cfg_we                (cfg_we_v.ldb_pp_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_PP_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_PP_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_pp_v)

        ,.memi                  (memi_lut_ldb_pp_v)

        ,.memo                  (memo_lut_ldb_pp_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (rob_enq_data.vpp[HQM_SYSTEM_LDB_PP_WIDTH-1:0])
        ,.lut_nord              (~rob_enq_data.is_ldb_port | ~rob_enq_data.is_pf_port | rob_enq_data.is_nm_pf)  

        ,.lut_rdata             (p2_pp_v_ldb)
        ,.lut_perr              (lut_err.ldb_pp_v)

        ,.lut_hold              (p3_lut_hold)
);

// Using flops for this small memory

logic [(HQM_SYSTEM_DEPTH_LUT_LDB_PP_V /
        HQM_SYSTEM_PACK_LUT_LDB_PP_V)-1:0]
      [ HQM_SYSTEM_PDWIDTH_LUT_LDB_PP_V-1:0]        lut_ldb_pp_v_mem;

logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_PP_V-1:0]         lut_ldb_pp_v_mem_scaled;
logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_PP_V-1:0]         lut_ldb_pp_v_mem_next;

always_comb begin: scale_lut_ldb_pp_v_mem

 for (int i=0; i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V); i=i+1) begin

  lut_ldb_pp_v_mem_scaled[i] = '0;

  if (i < (HQM_SYSTEM_DEPTH_LUT_LDB_PP_V/HQM_SYSTEM_PACK_LUT_LDB_PP_V)) begin
   lut_ldb_pp_v_mem_scaled[i] = lut_ldb_pp_v_mem[i];
  end

 end

 lut_ldb_pp_v_mem_next = lut_ldb_pp_v_mem_scaled;

 if (memi_lut_ldb_pp_v.we &
     ({{(32-HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V){1'b0}}, memi_lut_ldb_pp_v.addr} <
      (HQM_SYSTEM_DEPTH_LUT_LDB_PP_V/HQM_SYSTEM_PACK_LUT_LDB_PP_V))) begin
  lut_ldb_pp_v_mem_next[memi_lut_ldb_pp_v.addr] = memi_lut_ldb_pp_v.wdata;  
 end

end

always_ff @(posedge hqm_gated_clk) begin: block_lut_ldb_pp_v_mem
 if (memi_lut_ldb_pp_v.re) begin
  memo_lut_ldb_pp_v.rdata <= lut_ldb_pp_v_mem_scaled[memi_lut_ldb_pp_v.addr];
 end
 for (int i=0; i<(HQM_SYSTEM_DEPTH_LUT_LDB_PP_V/HQM_SYSTEM_PACK_LUT_LDB_PP_V); i=i+1) begin
  lut_ldb_pp_v_mem[i] <= lut_ldb_pp_v_mem_next[i];
 end
end

logic [HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID-1:0] dir_vf_vqid_lut_addr;
logic [HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID-1:0] ldb_vf_vqid_lut_addr;

generate

 if ((HQM_SYSTEM_DEPTH_LUT_LDB_PP_V/HQM_SYSTEM_PACK_LUT_LDB_PP_V) !=
     (1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V)) begin: g_unused_lut_ldb_pp_v

  logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_PP_V-1:0] unused_lut_ldb_pp_v;

  always_comb begin: p_unused_lut_ldb_pp_v
   unused_lut_ldb_pp_v = '0;
   for (int i=(HQM_SYSTEM_DEPTH_LUT_LDB_PP_V/HQM_SYSTEM_PACK_LUT_LDB_PP_V);
       i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V); i=i+1) begin
    unused_lut_ldb_pp_v |= lut_ldb_pp_v_mem_next[i];
   end
  end

  hqm_AW_unused_bits i_unused_lut_ldb_pp_v (.a(|unused_lut_ldb_pp_v));      

 end

 if (NUM_DIR_QID == 96) begin: g_dir_qid96

  assign dir_vf_vqid_lut_addr = ({7'd0, rob_enq_data.vdev} << 6) +                                          // (VF*64) +
                                ({7'd0, rob_enq_data.vdev} << 5) +                                          // (VF*32) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID-HQM_SYSTEM_DIR_QID_WIDTH){1'b0}}
                                ,rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};              // QID

 end else if (NUM_DIR_QID == 48) begin: g_dir_qid48

  assign dir_vf_vqid_lut_addr = ({6'd0, rob_enq_data.vdev} << 5) +                                          // (VF*32) +
                                ({6'd0, rob_enq_data.vdev} << 4) +                                          // (VF*16) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID-HQM_SYSTEM_DIR_QID_WIDTH){1'b0}}
                                ,rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};              // QID

 end else if (NUM_DIR_QID == 24) begin: g_dir_qid24

  assign dir_vf_vqid_lut_addr = ({5'd0, rob_enq_data.vdev} << 4) +                                          // (VF*16) +
                                ({5'd0, rob_enq_data.vdev} << 3) +                                          // (VF*8)  +
                                {{(HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID-HQM_SYSTEM_DIR_QID_WIDTH){1'b0}}
                                ,rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};              // QID

 end else begin: g_dir_qid_pwr2

  assign dir_vf_vqid_lut_addr = {rob_enq_data.vdev, rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};

 end

 if (NUM_LDB_QID == 96) begin: g_ldb_qid96

  assign ldb_vf_vqid_lut_addr = ({7'd0, rob_enq_data.vdev} << 6) +                                          // (VF*64) +
                                ({7'd0, rob_enq_data.vdev} << 5) +                                          // (VF*32) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID-HQM_SYSTEM_LDB_QID_WIDTH){1'b0}}
                                ,rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};              // QID

 end else if (NUM_LDB_QID == 48) begin: g_ldb_qid48

  assign ldb_vf_vqid_lut_addr = ({6'd0, rob_enq_data.vdev} << 5) +                                          // (VF*32) +
                                ({6'd0, rob_enq_data.vdev} << 4) +                                          // (VF*16) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID-HQM_SYSTEM_LDB_QID_WIDTH){1'b0}}
                                ,rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};              // QID

 end else if (NUM_LDB_QID == 24) begin: g_ldb_qid24

  assign ldb_vf_vqid_lut_addr = ({5'd0, rob_enq_data.vdev} << 4) +                                          // (VF*16) +
                                ({5'd0, rob_enq_data.vdev} << 3) +                                          // (VF*8)  +
                                {{(HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID-HQM_SYSTEM_LDB_QID_WIDTH){1'b0}}
                                ,rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};              // QID

 end else begin: g_ldb_qid_pwr2

  assign ldb_vf_vqid_lut_addr = {rob_enq_data.vdev, rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};

 end

endgenerate

hqm_system_lut_ecc #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_DIR_VQID2QID)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID2QID)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_DIR_VQID2QID)

) i_lut_vf_dir_vqid2qid (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.cfg_ecc_enable        (cfg_lut_ecc_enable)
        ,.cfg_write_bad_sb_ecc  (cfg_write_bad_sb_ecc)
        ,.cfg_write_bad_mb_ecc  (cfg_write_bad_mb_ecc)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[6])

        ,.cfg_re                (cfg_re_v.vf_dir_vqid2qid)
        ,.cfg_we                (cfg_we_v.vf_dir_vqid2qid)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID2QID-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_dir_vqid2qid)

        ,.memi                  (memi_lut_vf_dir_vqid2qid)

        ,.memo                  (memo_lut_vf_dir_vqid2qid)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (dir_vf_vqid_lut_addr)
        ,.lut_nord              ((rob_enq_data.hcw.msg_info.qtype != DIRECT) | rob_enq_data.is_pf_port) 

        ,.lut_rdata             (p2_qid_dir)
        ,.lut_mb_ecc_err        (lut_mb_ecc_err[1])
        ,.lut_sb_ecc_err        (lut_sb_ecc_err[1])

        ,.lut_hold              (p3_lut_hold)
);

assign lut_err.vf_dir_vqid2qid = lut_mb_ecc_err[1];

hqm_system_lut_ecc #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_LDB_VQID2QID)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID2QID)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_LDB_VQID2QID)

) i_lut_vf_ldb_vqid2qid (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.cfg_ecc_enable        (cfg_lut_ecc_enable)
        ,.cfg_write_bad_sb_ecc  (cfg_write_bad_sb_ecc)
        ,.cfg_write_bad_mb_ecc  (cfg_write_bad_mb_ecc)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[7])

        ,.cfg_re                (cfg_re_v.vf_ldb_vqid2qid)
        ,.cfg_we                (cfg_we_v.vf_ldb_vqid2qid)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID2QID-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_ldb_vqid2qid)

        ,.memi                  (memi_lut_vf_ldb_vqid2qid)

        ,.memo                  (memo_lut_vf_ldb_vqid2qid)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (ldb_vf_vqid_lut_addr)
        ,.lut_nord              ((rob_enq_data.hcw.msg_info.qtype == DIRECT) | rob_enq_data.is_pf_port) 

        ,.lut_rdata             (p2_qid_ldb)
        ,.lut_mb_ecc_err        (lut_mb_ecc_err[2])
        ,.lut_sb_ecc_err        (lut_sb_ecc_err[2])

        ,.lut_hold              (p3_lut_hold)
);

assign lut_err.vf_ldb_vqid2qid = lut_mb_ecc_err[2];

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_DIR_VQID_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_DIR_VQID_V)

) i_lut_vf_dir_vqid_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[8])

        ,.cfg_re                (cfg_re_v.vf_dir_vqid_v)
        ,.cfg_we                (cfg_we_v.vf_dir_vqid_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_dir_vqid_v)

        ,.memi                  (memi_lut_vf_dir_vqid_v)

        ,.memo                  (memo_lut_vf_dir_vqid_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (dir_vf_vqid_lut_addr)
        ,.lut_nord              ((rob_enq_data.hcw.msg_info.qtype != DIRECT) | rob_enq_data.is_pf_port) 

        ,.lut_rdata             (p2_vqid_v_dir)
        ,.lut_perr              (lut_err.vf_dir_vqid_v)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_VF_LDB_VQID_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_VF_LDB_VQID_V)

) i_lut_vf_ldb_vqid_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[9])

        ,.cfg_re                (cfg_re_v.vf_ldb_vqid_v)
        ,.cfg_we                (cfg_we_v.vf_ldb_vqid_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.vf_ldb_vqid_v)

        ,.memi                  (memi_lut_vf_ldb_vqid_v)

        ,.memo                  (memo_lut_vf_ldb_vqid_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (ldb_vf_vqid_lut_addr)
        ,.lut_nord              ((rob_enq_data.hcw.msg_info.qtype == DIRECT) | rob_enq_data.is_pf_port) 

        ,.lut_rdata             (p2_vqid_v_ldb)
        ,.lut_perr              (lut_err.vf_ldb_vqid_v)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_memi_lut_dir_qid_v_t memi_lut_dir_qid_v;
hqm_system_memo_lut_dir_qid_v_t memo_lut_dir_qid_v;

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_QID_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_QID_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_QID_V)

) i_lut_dir_qid_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[10])

        ,.cfg_re                (cfg_re_v.dir_qid_v)
        ,.cfg_we                (cfg_we_v.dir_qid_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_QID_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_QID_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_qid_v)

        ,.memi                  (memi_lut_dir_qid_v)

        ,.memo                  (memo_lut_dir_qid_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0])
        ,.lut_nord              ((rob_enq_data.hcw.msg_info.qtype != DIRECT) | ~rob_enq_data.is_pf_port) 

        ,.lut_rdata             (p2_qid_v_dir)
        ,.lut_perr              (lut_err.dir_qid_v)

        ,.lut_hold              (p3_lut_hold)
);

// Using flops for this small memory

logic [(HQM_SYSTEM_DEPTH_LUT_DIR_QID_V /
        HQM_SYSTEM_PACK_LUT_DIR_QID_V)-1:0]
      [ HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_V-1:0]       lut_dir_qid_v_mem;

logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_V-1:0]        lut_dir_qid_v_mem_scaled;
logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_V-1:0]        lut_dir_qid_v_mem_next;

always_comb begin: scale_lut_dir_qid_v_mem

 for (int i=0; i<(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V); i=i+1) begin

  lut_dir_qid_v_mem_scaled[i] = '0;

  if (i < (HQM_SYSTEM_DEPTH_LUT_DIR_QID_V/HQM_SYSTEM_PACK_LUT_DIR_QID_V)) begin
   lut_dir_qid_v_mem_scaled[i] = lut_dir_qid_v_mem[i];
  end

 end

 lut_dir_qid_v_mem_next = lut_dir_qid_v_mem_scaled;

 if (memi_lut_dir_qid_v.we &
     ({{(32-HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V){1'b0}}, memi_lut_dir_qid_v.addr} <
      (HQM_SYSTEM_DEPTH_LUT_DIR_QID_V/HQM_SYSTEM_PACK_LUT_DIR_QID_V))) begin
  lut_dir_qid_v_mem_next[memi_lut_dir_qid_v.addr] = memi_lut_dir_qid_v.wdata;   
 end

end

always_ff @(posedge hqm_gated_clk) begin: block_lut_dir_qid_v_mem
 if (memi_lut_dir_qid_v.re) begin
  memo_lut_dir_qid_v.rdata <= lut_dir_qid_v_mem_scaled[memi_lut_dir_qid_v.addr];
 end
 for (int i=0; i<(HQM_SYSTEM_DEPTH_LUT_DIR_QID_V/HQM_SYSTEM_PACK_LUT_DIR_QID_V); i=i+1) begin
  lut_dir_qid_v_mem[i] <= lut_dir_qid_v_mem_next[i];
 end
end

generate

 if ((HQM_SYSTEM_DEPTH_LUT_DIR_QID_V/HQM_SYSTEM_PACK_LUT_DIR_QID_V) !=
     (1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V)) begin: g_unused_lut_dir_qid_v

  logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_V-1:0] unused_lut_dir_qid_v;

  always_comb begin: p_unused_lut_dir_qid_v
   unused_lut_dir_qid_v = '0;
   for (int i=(HQM_SYSTEM_DEPTH_LUT_DIR_QID_V/HQM_SYSTEM_PACK_LUT_DIR_QID_V);
       i<(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V); i=i+1) begin
    unused_lut_dir_qid_v |= lut_dir_qid_v_mem_next[i];
   end
  end

  hqm_AW_unused_bits i_unused_lut_dir_qid_v (.a(|unused_lut_dir_qid_v));        

 end

endgenerate

hqm_system_memi_lut_ldb_qid_v_t memi_lut_ldb_qid_v;
hqm_system_memo_lut_ldb_qid_v_t memo_lut_ldb_qid_v;

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_QID_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_QID_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_QID_V)

) i_lut_ldb_qid_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[11])

        ,.cfg_re                (cfg_re_v.ldb_qid_v)
        ,.cfg_we                (cfg_we_v.ldb_qid_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_QID_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_QID_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_qid_v)

        ,.memi                  (memi_lut_ldb_qid_v)

        ,.memo                  (memo_lut_ldb_qid_v)

        ,.lut_re                (rob_enq_out_taken)
        ,.lut_addr              (rob_enq_data.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0])
        ,.lut_nord              ((rob_enq_data.hcw.msg_info.qtype == DIRECT) | ~rob_enq_data.is_pf_port) 

        ,.lut_rdata             (p2_qid_v_ldb)
        ,.lut_perr              (lut_err.ldb_qid_v)

        ,.lut_hold              (p3_lut_hold)
);

// Using flops for this small memory

logic [(HQM_SYSTEM_DEPTH_LUT_LDB_QID_V /
        HQM_SYSTEM_PACK_LUT_LDB_QID_V)-1:0]
      [ HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_V-1:0]       lut_ldb_qid_v_mem;

logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_V-1:0]        lut_ldb_qid_v_mem_scaled;
logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_V-1:0]        lut_ldb_qid_v_mem_next;

always_comb begin: scale_lut_ldb_qid_v_mem

 for (int i=0; i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V); i=i+1) begin

  lut_ldb_qid_v_mem_scaled[i] = '0;

  if (i < (HQM_SYSTEM_DEPTH_LUT_LDB_QID_V/HQM_SYSTEM_PACK_LUT_LDB_QID_V)) begin
   lut_ldb_qid_v_mem_scaled[i] = lut_ldb_qid_v_mem[i];
  end

 end

 lut_ldb_qid_v_mem_next = lut_ldb_qid_v_mem_scaled;

 if (memi_lut_ldb_qid_v.we &
     ({{(32-HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V){1'b0}}, memi_lut_ldb_qid_v.addr} <
      (HQM_SYSTEM_DEPTH_LUT_LDB_QID_V/HQM_SYSTEM_PACK_LUT_LDB_QID_V))) begin
  lut_ldb_qid_v_mem_next[memi_lut_ldb_qid_v.addr] = memi_lut_ldb_qid_v.wdata;   
 end

end

always_ff @(posedge hqm_gated_clk) begin: block_lut_ldb_qid_v_mem
 if (memi_lut_ldb_qid_v.re) begin
  memo_lut_ldb_qid_v.rdata <= lut_ldb_qid_v_mem_scaled[memi_lut_ldb_qid_v.addr];
 end
 for (int i=0; i<(HQM_SYSTEM_DEPTH_LUT_LDB_QID_V/HQM_SYSTEM_PACK_LUT_LDB_QID_V); i=i+1) begin
  lut_ldb_qid_v_mem[i] <= lut_ldb_qid_v_mem_next[i];
 end
end

generate

 if ((HQM_SYSTEM_DEPTH_LUT_LDB_QID_V/HQM_SYSTEM_PACK_LUT_LDB_QID_V) !=
     (1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V)) begin: g_unused_lut_ldb_qid_v

  logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_V-1:0] unused_lut_ldb_qid_v;

  always_comb begin: p_unused_lut_ldb_qid_v
   unused_lut_ldb_qid_v = '0;
   for (int i=(HQM_SYSTEM_DEPTH_LUT_LDB_QID_V/HQM_SYSTEM_PACK_LUT_LDB_QID_V);
       i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V); i=i+1) begin
    unused_lut_ldb_qid_v |= lut_ldb_qid_v_mem_next[i];
   end
  end

  hqm_AW_unused_bits i_unused_lut_ldb_qid_v (.a(|unused_lut_ldb_qid_v));        

 end

endgenerate

hqm_AW_width_scale #(.A_WIDTH($bits(p2_data_q.vpp)), .Z_WIDTH(HQM_SYSTEM_HCW_PP_WIDTH)) i_p2_vpp_scaled (

         .a         (p2_data_q.vpp)
        ,.z         (p2_vpp_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_DIR_PP_WIDTH), .Z_WIDTH(HQM_SYSTEM_HCW_PP_WIDTH)) i_p2_pp_dir_scaled (

         .a         (p2_pp_dir)
        ,.z         (p2_pp_dir_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_LDB_PP_WIDTH), .Z_WIDTH(HQM_SYSTEM_HCW_PP_WIDTH)) i_p2_pp_ldb_scaled (

         .a         (p2_pp_ldb)
        ,.z         (p2_pp_ldb_scaled)
);

// Can just "OR" thses together because the LUTs zero out rdata when not accessed
// and we only access either the DIR or the LDB LUT of a pair at any one time.

assign p2_pp_luts     = p2_pp_ldb_scaled  | p2_pp_dir_scaled;
assign p2_vpp_v_luts  = p2_vpp_v_ldb      | p2_vpp_v_dir;
assign p2_pp_v_luts   = p2_pp_v_ldb       | p2_pp_v_dir;
assign p2_vqid_v_luts = p2_vqid_v_ldb     | p2_vqid_v_dir;
assign p2_qid_v_luts  = p2_qid_v_ldb      | p2_qid_v_dir;

assign p2_perr        = (p2_v & ~cfg_parity_off & (|{lut_err.vf_dir_vpp2pp
                                                    ,lut_err.vf_ldb_vpp2pp
                                                    ,lut_err.vf_dir_vpp_v
                                                    ,lut_err.vf_ldb_vpp_v
                                                    ,lut_err.dir_pp_v
                                                    ,lut_err.ldb_pp_v
                                                    ,lut_err.vf_dir_vqid2qid
                                                    ,lut_err.vf_ldb_vqid2qid
                                                    ,lut_err.vf_dir_vqid_v
                                                    ,lut_err.vf_ldb_vqid_v
                                                    ,lut_err.dir_qid_v
                                                    ,lut_err.ldb_qid_v}));

assign p2_hcw_qid     = p2_data_q.hcw.msg_info[7:0];

assign p2_pp          =  (p2_data_q.is_pf_port) ? p2_vpp_scaled : p2_pp_luts;
assign p2_pp_v        = ((p2_data_q.is_pf_port) ? p2_pp_v_luts  : p2_vpp_v_luts) | p2_data_q.is_nm_pf;
assign p2_qid_v       =  (p2_data_q.is_pf_port) ? p2_qid_v_luts : p2_vqid_v_luts;

always_comb begin

    // Pass any MS bits so they can be part of the ingress checks at the end of the pipeline

    p2_qid = p2_hcw_qid;

    if (~p2_data_q.is_pf_port) begin
        if (p2_data_q.hcw.msg_info.qtype == DIRECT) begin
            p2_qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0] = ({1'b0, p2_hcw_qid} >= NUM_DIR_QID[8:0]) ?
                p2_hcw_qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0] : p2_qid_dir;
        end else begin
            p2_qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0] = ({1'b0, p2_hcw_qid} >= NUM_LDB_QID[8:0]) ?
                p2_hcw_qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0] : p2_qid_ldb;
        end
    end
end

//-----------------------------------------------------------------------------------------------------
// P3
//-----------------------------------------------------------------------------------------------------

assign p3_cfg_next = cfg_re_p2 | cfg_we_p2;

assign p3_v_next   = (p3_cfg_next) ? (~|{p3_v_q, p4_v_q, p5_v_q}) : (p2_v & ~p3_hold);

assign p3_hold = p3_v_q & (p4_hold | (p3_cfg_we_q & ~(&p5_cfg_we_q)));
assign p3_load = p3_v_next;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p3_v_q      <= '0;
  p3_cfg_q    <= '0;
  p3_cfg_we_q <= '0;
 end else if (~p3_hold) begin
  p3_v_q      <= p3_v_next;
  p3_cfg_q    <= p3_cfg_next;
  p3_cfg_we_q <= p3_v_next & cfg_we_p2;
 end
end

always_comb begin
 p3_data_next.parity_err    = p2_perr;
 p3_data_next.pp_v          = p2_pp_v;
 p3_data_next.pp            = p2_pp;
 p3_data_next.qid_v         = p2_qid_v;
 p3_data_next.mb_ecc_err    = |{p2_data_q.mb_ecc_err, (lut_mb_ecc_err & ~{$bits(lut_mb_ecc_err){p2_cfg_q}})};
 p3_data_next.hcw_parity_ms = p2_data_q.hcw_parity_ms;
 p3_data_next.ecc_l         = p2_data_q.ecc_l;
 p3_data_next.is_pf_port    = p2_data_q.is_pf_port;
 p3_data_next.is_ldb_port   = p2_data_q.is_ldb_port;
 p3_data_next.vdev          = p2_data_q.vdev;
 p3_data_next.vpp           = p2_data_q.vpp;
 p3_data_next.hcw           = p2_data_q.hcw;

 // Need to adjust the parity for removal of is_nm_pf (not needed downstream) and the new pipeline fields added

 p3_data_next.port_parity   = ^{p2_data_q.port_parity, p2_data_q.is_nm_pf, p2_perr, p2_pp_v, p2_pp, p2_qid_v,
                                    ((|(lut_mb_ecc_err & ~{$bits(lut_mb_ecc_err){p2_cfg_q}})) & ~p2_data_q.mb_ecc_err)};

 // Need to adjust the ms parity bit along with the qid

 p3_data_next.hcw.msg_info[7:0] = p2_qid;

 p3_data_next.hcw_parity_ms = ^{p2_data_q.hcw_parity_ms
                               ,p2_data_q.hcw.msg_info[7:0]
                               ,p2_qid};
end

always_ff @(posedge hqm_gated_clk) begin
 if (p3_load) begin
  if (~p3_cfg_next) p3_data_q <= p3_data_next;
 end
end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p3_sb_ecc_error_q <= '0;
  p3_mb_ecc_error_q <= '0;
  p3_synd_q         <= '0;
 end else begin
  p3_sb_ecc_error_q <= lut_sb_ecc_err & {$bits(lut_sb_ecc_err){(p3_load | p2_cfg_q | p2_cfg_we_q[1])}}; // Any LUT SB ECC error
  p3_mb_ecc_error_q <= lut_mb_ecc_err & {$bits(lut_mb_ecc_err){(          p2_cfg_q | p2_cfg_we_q[1])}}; // Only CFG related LUT MB ECC errors
  p3_synd_q         <= (p2_cfg_q | p2_cfg_we_q[1]) ? cfg_addr_q[7:0] : p2_vpp_scaled;
 end
end

assign cfg_taken_p3 = p3_cfg_next & ~|{p3_v_q, p4_v_q, p5_v_q};

// Single bit LUT ECC errors (CFG or HCW related) or CFG related multiple bit LUT ECC errors need to
// be reported separately since they are not reported as part of the ingress_error realm.

assign ingress_sb_ecc_error[$bits(p3_sb_ecc_error_q)-1:0] = p3_sb_ecc_error_q;
assign ingress_mb_ecc_error[$bits(p3_mb_ecc_error_q)-1:0] = p3_mb_ecc_error_q;
assign ingress_ecc_syndrome[7:0]                          = p3_synd_q;

//-----------------------------------------------------------------------------------------------------
// P4
//-----------------------------------------------------------------------------------------------------

assign p4_hold = p4_v_q &  p5_hold;
assign p4_load = p3_v_q & ~p4_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p4_v_q      <= '0;
  p4_cfg_q    <= '0;
  p4_cfg_we_q <= '0;
 end else if (~p4_hold) begin
  p4_v_q      <= p3_v_q & (~p3_cfg_we_q | (&(p5_cfg_we_q)));
  p4_cfg_q    <= p3_cfg_q;
  p4_cfg_we_q <= p3_cfg_we_q;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p4_load) begin
  if (~p3_cfg_q) p4_data_q <= p3_data_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// P5
//-----------------------------------------------------------------------------------------------------

assign p5_v     = p5_v_q & ~p5_cfg_q;
assign p5_hold  = p5_v   & (p6_hold | p6_cfg_next);
assign p5_load  = p4_v_q & ~p5_hold;
assign p5_taken = p5_v   & ~p5_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p5_v_q      <= '0;
  p5_cfg_q    <= '0;
  p5_cfg_we_q <= '0;
 end else if (~p5_hold) begin
  p5_v_q      <= p4_v_q;
  p5_cfg_q    <= p4_cfg_q;
  p5_cfg_we_q <= {p4_cfg_we_q, p5_cfg_we_q[1]};
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p5_load) begin
  if (~p4_cfg_q) p5_data_q <= p4_data_q;
 end
end

assign p6_lut_hold = (p6_hold | p6_cfg_next) & ~p5_cfg_q;

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_PP2VAS)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_PP2VAS)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_PP2VAS)

) i_lut_dir_pp2vas (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[12])

        ,.cfg_re                (cfg_re_v.dir_pp2vas)
        ,.cfg_we                (cfg_we_v.dir_pp2vas)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_PP2VAS-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_PP2VAS-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_pp2vas)

        ,.memi                  (memi_lut_dir_pp2vas)

        ,.memo                  (memo_lut_dir_pp2vas)

        ,.lut_re                (p2_taken)
        ,.lut_addr              (p2_pp[HQM_SYSTEM_DIR_PP_WIDTH-1:0])
        ,.lut_nord              (p2_data_q.is_ldb_port)

        ,.lut_rdata             (p5_vas_dir)
        ,.lut_perr              (lut_err.dir_pp2vas)

        ,.lut_hold              (p6_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_PP2VAS)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_PP2VAS)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_PP2VAS)

) i_lut_ldb_pp2vas (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[13])

        ,.cfg_re                (cfg_re_v.ldb_pp2vas)
        ,.cfg_we                (cfg_we_v.ldb_pp2vas)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_PP2VAS-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_PP2VAS-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_pp2vas)

        ,.memi                  (memi_lut_ldb_pp2vas)

        ,.memo                  (memo_lut_ldb_pp2vas)

        ,.lut_re                (p2_taken)
        ,.lut_addr              (p2_pp[HQM_SYSTEM_LDB_PP_WIDTH-1:0])
        ,.lut_nord              (~p2_data_q.is_ldb_port)

        ,.lut_rdata             (p5_vas_ldb)
        ,.lut_perr              (lut_err.ldb_pp2vas)

        ,.lut_hold              (p6_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_QID_CFG_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V)

) i_lut_ldb_qid_cfg_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[14])

        ,.cfg_re                (cfg_re_v.ldb_qid_cfg_v)
        ,.cfg_we                (cfg_we_v.ldb_qid_cfg_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_QID_CFG_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_QID_CFG_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_qid_cfg_v)

        ,.memi                  (memi_lut_ldb_qid_cfg_v)

        ,.memo                  (memo_lut_ldb_qid_cfg_v)

        ,.lut_re                (p2_taken)
        ,.lut_addr              (p2_qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0])
        ,.lut_nord              (p2_data_q.hcw.msg_info.qtype == DIRECT)        

        ,.lut_rdata             (p5_qid_cfg_v)
        ,.lut_perr              (p5_qid_cfg_v_perr)

        ,.lut_hold              (p6_lut_hold)
);

// Using flops for this memory 

logic [(HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V /
        HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V)-1:0]
      [ HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_CFG_V-1:0]       lut_ldb_qid_cfg_v_mem;

logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_CFG_V-1:0]        lut_ldb_qid_cfg_v_mem_scaled;
logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_CFG_V-1:0]        lut_ldb_qid_cfg_v_mem_next;

always_comb begin: scale_lut_ldb_qid_cfg_v_mem

 for (int i=0; i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V); i=i+1) begin

  lut_ldb_qid_cfg_v_mem_scaled[i] = '0;

  if (i < (HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V/HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V)) begin
   lut_ldb_qid_cfg_v_mem_scaled[i] = lut_ldb_qid_cfg_v_mem[i];
  end

 end

 lut_ldb_qid_cfg_v_mem_next = lut_ldb_qid_cfg_v_mem_scaled;

 if (memi_lut_ldb_qid_cfg_v.we &
     ({{(32-HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V){1'b0}}, memi_lut_ldb_qid_cfg_v.addr} <
      (HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V/HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V))) begin
  lut_ldb_qid_cfg_v_mem_next[memi_lut_ldb_qid_cfg_v.addr] = memi_lut_ldb_qid_cfg_v.wdata;   
 end

end

always_ff @(posedge hqm_gated_clk) begin: block_lut_ldb_qid_cfg_v_mem
 if (memi_lut_ldb_qid_cfg_v.re) begin
  memo_lut_ldb_qid_cfg_v.rdata <= lut_ldb_qid_cfg_v_mem_scaled[memi_lut_ldb_qid_cfg_v.addr];
 end
 for (int i=0; i<(HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V/HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V); i=i+1) begin
  lut_ldb_qid_cfg_v_mem[i] <= lut_ldb_qid_cfg_v_mem_next[i];
 end
end

generate

 if ((HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V/HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V) !=
     (1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V)) begin: g_unused_lut_ldb_qid_cfg_v

  logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_CFG_V-1:0] unused_lut_ldb_qid_cfg_v;

  always_comb begin: p_unused_lut_ldb_qid_cfg_v
   unused_lut_ldb_qid_cfg_v = '0;
   for (int i=(HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V/HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V);
       i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V); i=i+1) begin
    unused_lut_ldb_qid_cfg_v |= lut_ldb_qid_cfg_v_mem_next[i];
   end
  end

  hqm_AW_unused_bits i_unused_lut_ldb_qid_cfg_v (.a(|unused_lut_ldb_qid_cfg_v));            

 end

endgenerate

assign lut_err.ldb_qid_cfg_v = p5_qid_cfg_v_perr;

assign p5_vas          = p5_vas_ldb | p5_vas_dir;

assign p5_perr         = (p5_v & ~cfg_parity_off &
                         (|{lut_err.dir_pp2vas
                           ,lut_err.ldb_pp2vas
                           ,lut_err.ldb_qid_cfg_v}));

//-----------------------------------------------------------------------------------------------------
// P6
//-----------------------------------------------------------------------------------------------------

assign p6_cfg_next = cfg_re_p5 | cfg_we_p5;

assign p6_v_next   = (p6_cfg_next) ? (~|{p6_v_q, p7_v_q, p8_v_q}) : (p5_v & ~p6_hold);

assign p6_hold = p6_v_q & (p7_hold | (p6_cfg_we_q & ~(&p8_cfg_we_q)));
assign p6_load = p6_v_next;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p6_v_q      <= '0;
  p6_cfg_q    <= '0;
  p6_cfg_we_q <= '0;
 end else if (~p6_hold) begin
  p6_v_q      <= p6_v_next;
  p6_cfg_q    <= p6_cfg_next;
  p6_cfg_we_q <= p6_v_next & cfg_we_p5;
 end
end

always_comb begin
 p6_data_next.parity_err     = p5_data_q.parity_err | p5_perr;
 p6_data_next.qid_cfg_v      = p5_qid_cfg_v;
 p6_data_next.vas            = p5_vas;
 p6_data_next.pp_v           = p5_data_q.pp_v;
 p6_data_next.pp             = p5_data_q.pp;
 p6_data_next.qid_v          = p5_data_q.qid_v;
 p6_data_next.mb_ecc_err     = p5_data_q.mb_ecc_err;
 p6_data_next.hcw_parity_ms  = p5_data_q.hcw_parity_ms;
 p6_data_next.ecc_l          = p5_data_q.ecc_l;
 p6_data_next.is_pf_port     = p5_data_q.is_pf_port;
 p6_data_next.is_ldb_port    = p5_data_q.is_ldb_port;
 p6_data_next.vdev           = p5_data_q.vdev;
 p6_data_next.vpp            = p5_data_q.vpp;
 p6_data_next.hcw            = p5_data_q.hcw;

 // Need to adjust the parity for the new pipeline fields added

 p6_data_next.port_parity    = ^{p5_data_q.port_parity, p5_qid_cfg_v, p5_vas, (p5_perr & ~p5_data_q.parity_err)};
end

always_ff @(posedge hqm_gated_clk) begin
 if (p6_load) begin
  if (~p6_cfg_next) p6_data_q <= p6_data_next;
 end
end

assign cfg_taken_p6 = p6_cfg_next  & ~|{p6_v_q, p7_v_q, p8_v_q};

//-----------------------------------------------------------------------------------------------------
// P7
//-----------------------------------------------------------------------------------------------------

assign p7_hold = p7_v_q &  p8_hold;
assign p7_load = p6_v_q & ~p7_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p7_v_q      <= '0;
  p7_cfg_q    <= '0;
  p7_cfg_we_q <= '0;
 end else if (~p7_hold) begin
  p7_v_q      <= p6_v_q & (~p6_cfg_we_q | (&p8_cfg_we_q));
  p7_cfg_q    <= p6_cfg_q;
  p7_cfg_we_q <= p6_cfg_we_q;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p7_load) begin
  if (~p6_cfg_q) p7_data_q <= p6_data_q;
 end
end

//-----------------------------------------------------------------------------------------------------
// P8
//-----------------------------------------------------------------------------------------------------

assign p8_v    = p8_v_q & ~p8_cfg_q;
assign p8_hold = p8_v   & ~hcw_enq_out_ready;
assign p8_load = p7_v_q & ~p8_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p8_v_q      <= '0;
  p8_cfg_q    <= '0;
  p8_cfg_we_q <= '0;
 end else if (~p8_hold) begin
  p8_v_q      <= p7_v_q;
  p8_cfg_q    <= p7_cfg_q;
  p8_cfg_we_q <= {p7_cfg_we_q, p8_cfg_we_q[1]};
 end
end

always_ff @(posedge hqm_gated_clk) begin
 if (p8_load) begin
  if (~p7_cfg_q) p8_data_q <= p7_data_q;
 end
end

assign hcw_enq_lut_hold = ~hcw_enq_out_ready & ~p8_cfg_q;

assign p9_load = p8_v & hcw_enq_out_ready;

logic [HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V-1:0] dir_vas_qid_lut_addr;
logic [HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V-1:0] ldb_vas_qid_lut_addr;

generate

 if (NUM_DIR_QID == 96) begin: g_dir_vasqid96

  assign dir_vas_qid_lut_addr = ({7'd0, p5_vas} << 6) +                                                 // (VAS*64) +
                                ({7'd0, p5_vas} << 5) +                                                 // (VAS*32) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V-HQM_SYSTEM_DIR_QID_WIDTH){1'b0}}
                                ,p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};             // QID

 end else if (NUM_DIR_QID == 48) begin: g_dir_vasqid48

  assign dir_vas_qid_lut_addr = ({6'd0, p5_vas} << 5) +                                                 // (VAS*32) +
                                ({6'd0, p5_vas} << 4) +                                                 // (VAS*16) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V-HQM_SYSTEM_DIR_QID_WIDTH){1'b0}}
                                ,p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};             // QID

 end else if (NUM_DIR_QID == 24) begin: g_dir_vasqid24

  assign dir_vas_qid_lut_addr = ({5'd0, p5_vas} << 4) +                                                 // (VAS*16) +
                                ({5'd0, p5_vas} << 3) +                                                 // (VAS*8)  +
                                {{(HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V-HQM_SYSTEM_DIR_QID_WIDTH){1'b0}}
                                ,p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};             // QID

 end else begin: g_dir_vasqid_pwr2

  assign dir_vas_qid_lut_addr = {p5_vas, p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0]};

 end

 if (NUM_LDB_QID == 96) begin: g_ldb_vasqid96

  assign ldb_vas_qid_lut_addr = ({7'd0, p5_vas} << 6) +                                                 // (VAS*64) +
                                ({7'd0, p5_vas} << 5) +                                                 // (VAS*32) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V-HQM_SYSTEM_LDB_QID_WIDTH){1'b0}}
                                ,p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};             // QID

 end else if (NUM_LDB_QID == 48) begin: g_ldb_vasqid48

  assign ldb_vas_qid_lut_addr = ({6'd0, p5_vas} << 5) +                                                 // (VAS*32) +
                                ({6'd0, p5_vas} << 4) +                                                 // (VAS*16) +
                                {{(HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V-HQM_SYSTEM_LDB_QID_WIDTH){1'b0}}
                                ,p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};             // QID

 end else if (NUM_LDB_QID == 24) begin: g_ldb_vasqid24

  assign ldb_vas_qid_lut_addr = ({5'd0, p5_vas} << 4) +                                                 // (VAS*16) +
                                ({5'd0, p5_vas} << 3) +                                                 // (VAS*8)  +
                                {{(HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V-HQM_SYSTEM_LDB_QID_WIDTH){1'b0}}
                                ,p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};             // QID

 end else begin: g_ldb_vasqid_pwr2

  assign ldb_vas_qid_lut_addr = {p5_vas, p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0]};

 end

endgenerate

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_VASQID_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_VASQID_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_VASQID_V)

) i_lut_dir_vasqid_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[15])

        ,.cfg_re                (cfg_re_v.dir_vasqid_v)
        ,.cfg_we                (cfg_we_v.dir_vasqid_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_VASQID_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_vasqid_v)

        ,.memi                  (memi_lut_dir_vasqid_v)

        ,.memo                  (memo_lut_dir_vasqid_v)

        ,.lut_re                (p5_taken)
        ,.lut_addr              (dir_vas_qid_lut_addr)
        ,.lut_nord              (p5_data_q.hcw.msg_info.qtype != DIRECT)        

        ,.lut_rdata             (p8_vasqid_v_dir)
        ,.lut_perr              (lut_err.dir_vasqid_v)

        ,.lut_hold              (hcw_enq_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_VASQID_V)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_VASQID_V)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_VASQID_V)

) i_lut_ldb_vasqid_v (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[16])

        ,.cfg_re                (cfg_re_v.ldb_vasqid_v)
        ,.cfg_we                (cfg_we_v.ldb_vasqid_v)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_VASQID_V-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_vasqid_v)

        ,.memi                  (memi_lut_ldb_vasqid_v)

        ,.memo                  (memo_lut_ldb_vasqid_v)

        ,.lut_re                (p5_taken)
        ,.lut_addr              (ldb_vas_qid_lut_addr)
        ,.lut_nord              (p5_data_q.hcw.msg_info.qtype == DIRECT)        

        ,.lut_rdata             (p8_vasqid_v_ldb)
        ,.lut_perr              (lut_err.ldb_vasqid_v)

        ,.lut_hold              (hcw_enq_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_QID_ITS)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_QID_ITS)

) i_lut_dir_qid_its (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[17])

        ,.cfg_re                (cfg_re_v.dir_qid_its)
        ,.cfg_we                (cfg_we_v.dir_qid_its)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_QID_ITS-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_QID_ITS-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_qid_its)

        ,.memi                  (memi_lut_dir_qid_its)

        ,.memo                  (memo_lut_dir_qid_its)

        ,.lut_re                (p5_taken)
        ,.lut_addr              (p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_DIR_QID_WIDTH-1:0])
        ,.lut_nord              (p5_data_q.hcw.msg_info.qtype != DIRECT)        

        ,.lut_rdata             (p8_qid_its_dir)
        ,.lut_perr              (lut_err.dir_qid_its)

        ,.lut_hold              (hcw_enq_lut_hold)
);

// Using flops for this small memory

logic [(HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS /
        HQM_SYSTEM_PACK_LUT_DIR_QID_ITS)-1:0]
      [ HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_ITS-1:0]     lut_dir_qid_its_mem;

logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_ITS-1:0]      lut_dir_qid_its_mem_scaled;
logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_ITS-1:0]      lut_dir_qid_its_mem_next;

always_comb begin: scale_lut_dir_qid_its_mem

 for (int i=0; i<(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS); i=i+1) begin

  lut_dir_qid_its_mem_scaled[i] = '0;

  if (i < (HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS/HQM_SYSTEM_PACK_LUT_DIR_QID_ITS)) begin
   lut_dir_qid_its_mem_scaled[i] = lut_dir_qid_its_mem[i];
  end

 end

 lut_dir_qid_its_mem_next = lut_dir_qid_its_mem_scaled;

 if (memi_lut_dir_qid_its.we &
     ({{(32-HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS){1'b0}}, memi_lut_dir_qid_its.addr} <
      (HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS/HQM_SYSTEM_PACK_LUT_DIR_QID_ITS))) begin
  lut_dir_qid_its_mem_next[memi_lut_dir_qid_its.addr] = memi_lut_dir_qid_its.wdata; 
 end

end

always_ff @(posedge hqm_gated_clk) begin: block_lut_dir_qid_its_mem
 if (memi_lut_dir_qid_its.re) begin
  memo_lut_dir_qid_its.rdata <= lut_dir_qid_its_mem_scaled[memi_lut_dir_qid_its.addr];
 end
 for (int i=0; i<(HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS/HQM_SYSTEM_PACK_LUT_DIR_QID_ITS); i=i+1) begin
  lut_dir_qid_its_mem[i] <= lut_dir_qid_its_mem_next[i];
 end
end

generate

 if ((HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS/HQM_SYSTEM_PACK_LUT_DIR_QID_ITS) !=
     (1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS)) begin: g_unused_lut_dir_qid_its

  logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_ITS-1:0] unused_lut_dir_qid_its;

  always_comb begin: p_unused_lut_dir_qid_its
   unused_lut_dir_qid_its = '0;
   for (int i=(HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS/HQM_SYSTEM_PACK_LUT_DIR_QID_ITS);
       i<(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS); i=i+1) begin
    unused_lut_dir_qid_its |= lut_dir_qid_its_mem_next[i];
   end
  end

  hqm_AW_unused_bits i_unused_lut_dir_qid_its (.a(|unused_lut_dir_qid_its));        

 end

endgenerate

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_QID_ITS)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_QID_ITS)

) i_lut_ldb_qid_its (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[18])

        ,.cfg_re                (cfg_re_v.ldb_qid_its)
        ,.cfg_we                (cfg_we_v.ldb_qid_its)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_QID_ITS-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_QID_ITS-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_qid_its)

        ,.memi                  (memi_lut_ldb_qid_its)

        ,.memo                  (memo_lut_ldb_qid_its)

        ,.lut_re                (p5_taken)
        ,.lut_addr              (p5_data_q.hcw.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0])
        ,.lut_nord              (p5_data_q.hcw.msg_info.qtype == DIRECT)        

        ,.lut_rdata             (p8_qid_its_ldb)
        ,.lut_perr              (lut_err.ldb_qid_its)

        ,.lut_hold              (hcw_enq_lut_hold)
);

// Using flops for this small memory

logic [(HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS /
        HQM_SYSTEM_PACK_LUT_LDB_QID_ITS)-1:0]
      [ HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_ITS-1:0]     lut_ldb_qid_its_mem;

logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_ITS-1:0]      lut_ldb_qid_its_mem_scaled;
logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_ITS-1:0]      lut_ldb_qid_its_mem_next;

always_comb begin: scale_lut_ldb_qid_its_mem

 for (int i=0; i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS); i=i+1) begin

  lut_ldb_qid_its_mem_scaled[i] = '0;

  if (i < (HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS/HQM_SYSTEM_PACK_LUT_LDB_QID_ITS)) begin
   lut_ldb_qid_its_mem_scaled[i] = lut_ldb_qid_its_mem[i];
  end

 end

 lut_ldb_qid_its_mem_next = lut_ldb_qid_its_mem_scaled;

 if (memi_lut_ldb_qid_its.we &
     ({{(32-HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS){1'b0}}, memi_lut_ldb_qid_its.addr} <
      (HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS/HQM_SYSTEM_PACK_LUT_LDB_QID_ITS))) begin
  lut_ldb_qid_its_mem_next[memi_lut_ldb_qid_its.addr] = memi_lut_ldb_qid_its.wdata; 
 end

end

always_ff @(posedge hqm_gated_clk) begin: block_lut_ldb_qid_its_mem
 if (memi_lut_ldb_qid_its.re) begin
  memo_lut_ldb_qid_its.rdata <= lut_ldb_qid_its_mem_scaled[memi_lut_ldb_qid_its.addr];
 end
 for (int i=0; i<(HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS/HQM_SYSTEM_PACK_LUT_LDB_QID_ITS); i=i+1) begin
  lut_ldb_qid_its_mem[i] <= lut_ldb_qid_its_mem_next[i];
 end
end

generate

 if ((HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS/HQM_SYSTEM_PACK_LUT_LDB_QID_ITS) !=
     (1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS)) begin: g_unused_lut_ldb_qid_its

  logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_ITS-1:0] unused_lut_ldb_qid_its;

  always_comb begin: p_unused_lut_ldb_qid_its
   unused_lut_ldb_qid_its = '0;
   for (int i=(HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS/HQM_SYSTEM_PACK_LUT_LDB_QID_ITS);
       i<(1<<HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS); i=i+1) begin
    unused_lut_ldb_qid_its |= lut_ldb_qid_its_mem_next[i];
   end
  end

  hqm_AW_unused_bits i_unused_lut_ldb_qid_its (.a(|unused_lut_ldb_qid_its));        

 end

endgenerate

assign p8_vasqid_v  = p8_vasqid_v_dir | p8_vasqid_v_ldb;
assign p8_qid_its   = p8_qid_its_dir  | p8_qid_its_ldb;

// Check ECC on the lower half of the hcw (pointer)

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p8_inj_par_err_q      <= '0;
  p8_inj_par_err_last_q <= '0;
  p8_inj_ecc_err_q      <= '0;
  p8_inj_ecc_err_last_q <= '0;
 end else begin
  p8_inj_par_err_q      <= cfg_inj_par_err_ingress;
  p8_inj_par_err_last_q <= p8_inj_par_err_q & (p8_inj_par_err_last_q | (p9_load & ~cfg_parity_off));
  p8_inj_ecc_err_q      <= cfg_inj_ecc_err_ingress[3:2];
  p8_inj_ecc_err_last_q <= p8_inj_ecc_err_q & (p8_inj_ecc_err_last_q | {2{p9_load}});
 end
end

hqm_AW_ecc_check #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_p8_hcw_ecc_check_ls (  

         .din_v     (p9_load)
        ,.din       ({ p8_data_q.hcw[63:2]
                     ,(p8_data_q.hcw[1] ^ (  p8_inj_ecc_err_q[0] & ~p8_inj_ecc_err_last_q[0] ))
                     ,(p8_data_q.hcw[0] ^ (|(p8_inj_ecc_err_q    & ~p8_inj_ecc_err_last_q   )))
                    })
        ,.ecc       (p8_data_q.ecc_l)
        ,.enable    (1'b1)
        ,.correct   (1'b1)

        ,.dout      (p8_hcw_corrected[63:0])

        ,.error_sb  (p8_sb_ecc_error)
        ,.error_mb  (p8_mb_ecc_error)
);

// Generate parity on the uncorrected data instead of corrected data for timing
// and adjust later if sb ECC error detected.

hqm_AW_parity_gen #(.WIDTH(64)) i_p8_hcw_parity_ls (

         .d         ({ p8_data_q.hcw[63:2]
                     ,(p8_data_q.hcw[1] ^ (  p8_inj_ecc_err_q[0] & ~p8_inj_ecc_err_last_q[0] ))
                     ,(p8_data_q.hcw[0] ^ (|(p8_inj_ecc_err_q    & ~p8_inj_ecc_err_last_q   )))
                    })
        ,.odd       (1'b1)
        ,.p         (p8_hcw_parity_ls)
);

assign p8_port_perr    = p9_load & ~cfg_parity_off &
                          ((^{p8_data_q.port_parity
                             ,p8_data_q.parity_err
                             ,p8_data_q.qid_cfg_v
                             ,p8_data_q.vas
                             ,p8_data_q.pp_v
                             ,p8_data_q.pp
                             ,p8_data_q.qid_v
                             ,p8_data_q.mb_ecc_err
                             ,p8_data_q.is_ldb_port
                             ,p8_data_q.is_pf_port
                             ,p8_data_q.vdev
                             ,p8_data_q.vpp}) |
                           (p8_inj_par_err_q & ~p8_inj_par_err_last_q));

assign p8_perr         = (p8_v & ~cfg_parity_off &
                         (|{p8_data_q.parity_err
                           ,lut_err.dir_vasqid_v
                           ,lut_err.ldb_vasqid_v
                           ,lut_err.dir_qid_its
                           ,lut_err.ldb_qid_its})) | p8_port_perr;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p9_sb_ecc_error_q <= '0;
 end else begin
  p9_sb_ecc_error_q <= p8_sb_ecc_error & cfg_hcw_enq_ecc_enable;
 end
end

hqm_AW_width_scale #(.A_WIDTH($bits(p8_data_q.vpp)), .Z_WIDTH(8)) i_p8_vpp_scaled (

         .a         (p8_data_q.vpp)
        ,.z         (p8_vpp_scaled)
);

always_ff @(posedge hqm_gated_clk) begin
 p9_synd_q <= p8_vpp_scaled;
end

// Single bit ECC errors on the HCW ls word reported separately, since they are not reported as part
// of the ingress_error realm.

assign ingress_sb_ecc_error[3]    = p9_sb_ecc_error_q;
assign ingress_ecc_syndrome[15:8] = p9_synd_q;

//-----------------------------------------------------------------------------------------------------

always_comb begin

 hcw_enq_out_data.qid_cfg_v          = p8_data_q.qid_cfg_v;
 hcw_enq_out_data.vasqid_v           = p8_vasqid_v;
 hcw_enq_out_data.insert_timestamp   = p8_qid_its;
 hcw_enq_out_data.vas                = p8_data_q.vas;
 hcw_enq_out_data.pp_v               = p8_data_q.pp_v;
 hcw_enq_out_data.pp                 = p8_data_q.pp;
 hcw_enq_out_data.qid_v              = p8_data_q.qid_v;
 hcw_enq_out_data.hcw_parity         = {p8_data_q.hcw_parity_ms, (p8_hcw_parity_ls ^ p8_sb_ecc_error)};
 hcw_enq_out_data.is_pf_port         = p8_data_q.is_pf_port;
 hcw_enq_out_data.is_ldb_port        = p8_data_q.is_ldb_port;
 hcw_enq_out_data.vdev               = p8_data_q.vdev;
 hcw_enq_out_data.vpp                = p8_data_q.vpp;
 hcw_enq_out_data.hcw                = {p8_data_q.hcw[127:64], p8_hcw_corrected[63:0]};

end

//-----------------------------------------------------------------------------------------------------
// HCW checks

always_comb begin

 ingress_alarm_v_next            = '0;
 ingress_alarm_next              = '0;
 ingress_alarm_next.is_ldb_port  = hcw_enq_out_data.is_ldb_port;
 ingress_alarm_next.is_pf        = hcw_enq_out_data.is_pf_port | p8_port_perr;
 ingress_alarm_next.vdev         = hcw_enq_out_data.vdev;
 ingress_alarm_next.vpp          = hcw_enq_out_data.vpp;
 ingress_alarm_next.hcw          = hcw_enq_out_data.hcw[127:64];
 ingress_alarm_next.msix_map     = INGRESS_ERROR;          // Use MSI-X 3 for ingress errors by default

 hcw_enq_w_v                     = '0;
 hcw_enq_w                       = '0;
 hcw_enq_w.data                  = hcw_enq_out_data.hcw;
 hcw_enq_w.user.hcw_parity       = hcw_enq_out_data.hcw_parity;
 hcw_enq_w.user.ao_v             = hcw_enq_out_data.qid_cfg_v[2];
 hcw_enq_w.user.pp               = hcw_enq_out_data.pp;
 hcw_enq_w.user.vas              = hcw_enq_out_data.vas;
 hcw_enq_w.user.pp_is_ldb        = hcw_enq_out_data.is_ldb_port;
 hcw_enq_w.user.qe_is_ldb        = (hcw_enq_out_data.hcw.msg_info.qtype != DIRECT);
 hcw_enq_w.user.qid              = hcw_enq_out_data.hcw.msg_info[7:0];
 hcw_enq_w.user.insert_timestamp = hcw_enq_out_data.insert_timestamp  &
                                   hcw_enq_out_data.hcw.debug.ts_flag;

 if (p9_load) begin

  if (p8_data_q.mb_ecc_err | (p8_mb_ecc_error & cfg_hcw_enq_ecc_enable)) begin

   // An ECC error drops the HCW and reports the alarm.

   ingress_alarm_v_next         = 1'b1;
   ingress_alarm_next.aid       = 6'd44;
   ingress_alarm_next.msix_map  = HQM_ALARM;    // Use MSI-X 0 for ingress ECC errors

  end else if (p8_perr) begin

   // A parity error drops the HCW and reports the alarm.

   ingress_alarm_v_next         = 1'b1;
   ingress_alarm_next.aid       = 6'd43;
   ingress_alarm_next.msix_map  = HQM_ALARM;    // Use MSI-X 0 for ingress parity errors

  end else if ((hcw_enq_out_data.hcw.cmd == HQM_CMD_ILLEGAL_CMD_4)  |
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_ILLEGAL_CMD_14) |
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_ILLEGAL_CMD_15) |
               (~hcw_enq_out_data.is_ldb_port &
                ((hcw_enq_out_data.hcw.cmd == HQM_CMD_COMP)             |
                 (hcw_enq_out_data.hcw.cmd == HQM_CMD_COMP_TOK_RET)     |
                 (hcw_enq_out_data.hcw.cmd == HQM_CMD_A_COMP)           |
                 (hcw_enq_out_data.hcw.cmd == HQM_CMD_A_COMP_TOK_RET)   |
                 (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP)         |
                 (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP_TOK_RET) |
                 (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_FRAG)         |
                 (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_FRAG_TOK_RET)
               ))) begin

   // An illegal command is either not a valid encoding or a COMP, COMP_T, RENQ,
   // or RENQ_T that is not from a load balanced port.
   // An illegal command drops the HCW and reports the alarm.

   ingress_alarm_v_next             = cfg_ingress_alarm_enable.ILLEGAL_HCW;
   ingress_alarm_next.aid           = 6'd0;

  end else if (~hcw_enq_out_data.pp_v) begin

   // The producer port is invalid if the valid bit is not set.
   // An invalid producer port drops the HCW and reports the alarm.

   ingress_alarm_v_next             = cfg_ingress_alarm_enable.ILLEGAL_PP;
   ingress_alarm_next.aid           = 6'd1;

  end else if ((hcw_enq_out_data.hcw.cmd == HQM_CMD_NOOP)        |
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_ARM)         |
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_BAT_TOK_RET) |
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_COMP)        |
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_COMP_TOK_RET)|
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_A_COMP)      |
               (hcw_enq_out_data.hcw.cmd == HQM_CMD_A_COMP_TOK_RET)) begin

   // Since the producer port is valid if we get here, and no further checks are required for
   // NOOP, ARM, BAT_T, COMP, or COMP_T, they can be passed on to hqm_core here, and they are
   // not considered for any of the subsequent checks.

   hcw_enq_w_v                      = '1;

  end else if (~hcw_enq_out_data.qid_v |
               ((hcw_enq_out_data.hcw.msg_info.qtype == DIRECT) ?
                ( {1'b0, hcw_enq_out_data.hcw.msg_info[7:0]} >= NUM_DIR_QID[8:0] ) : 
                ( {1'b0, hcw_enq_out_data.hcw.msg_info[7:0]} >= NUM_LDB_QID[8:0]))) begin


   // QID must be valid.
   // QID (all 8 bits) must be within the correct range of QIDs for DIR and LDB.
   // A QID check failure drops the HCW and reports the alarm.

   ingress_alarm_v_next             = cfg_ingress_alarm_enable.ILLEGAL_QID;
   ingress_alarm_next.aid           = 6'd3;

   // If a command includes CQ associated work (completion or token return) that is not associated
   // with the QE, we need to nuke the enqueue portion of the command (qe_valid/qe_orsp/lockid bits)
   // and adjust the associated hcw parity bit, so we can pass the CQ portion of the command.
   // This only needs to be done for NEW_T, RENQ, RENQ_T, and FRAG_T.

   if ((hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_NEW_TOK_RET)  |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP)         |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP_TOK_RET) |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_FRAG_TOK_RET)) begin

    hcw_enq_w_v                               = '1;
    hcw_enq_w.data.cmd.hcw_cmd_field.qe_valid = '0;
    hcw_enq_w.data.cmd.hcw_cmd_field.qe_orsp  = '0;
    hcw_enq_w.data.lockid_dir_info_tokens     = '0;
    hcw_enq_w.user.hcw_parity[1]              = ^{hcw_enq_out_data.hcw_parity[1]
                                                 ,hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_valid
                                                 ,hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_orsp
                                                 ,hcw_enq_out_data.hcw.lockid_dir_info_tokens};
   end

  end else if (( (hcw_enq_out_data.hcw.msg_info.qtype == ORDERED)   &   ~hcw_enq_out_data.qid_cfg_v[0]) |
               ( (hcw_enq_out_data.hcw.msg_info.qtype == UNORDERED) &    hcw_enq_out_data.qid_cfg_v[0]) |
               ( (hcw_enq_out_data.hcw.msg_info.qtype == ATOMIC)    &   ~hcw_enq_out_data.qid_cfg_v[1]) |
               ( (hcw_enq_out_data.hcw.msg_info.qtype != DIRECT)    &    hcw_enq_out_data.qid_cfg_v[2]  &
                ((hcw_enq_out_data.hcw.msg_info.qtype == UNORDERED) | ~(&hcw_enq_out_data.qid_cfg_v[1:0]))
               )
              ) begin

   // The target check makes sure ORD QIDs have the SN bit set, UNO QIDs do not have the SN bit set,
   // and ATM QIDs have the FID bit set.
   // Combined ATM/ORD type has AO bit (2) set and must be either ATM or ORD QID (cannot be UNO).
   // Combined ATM/ORD type must also have both the SN and FID bits set.
   // A target check failure drops the HCW and reports the alarm.

   ingress_alarm_v_next             = cfg_ingress_alarm_enable.ILLEGAL_LDB_QID_CFG;
   ingress_alarm_next.aid           = 6'd5;

   // If a command includes CQ associated work (completion or token return) that is not associated
   // with the QE, we need to nuke the enqueue portion of the command (qe_valid/qe_orsp/lockid bits)
   // and adjust the associated hcw parity bit, so we can pass the CQ portion of the command.
   // This only needs to be done for NEW_T, RENQ, RENQ_T, and FRAG_T.

   if ((hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_NEW_TOK_RET)  |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP)         |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP_TOK_RET) |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_FRAG_TOK_RET)) begin

    hcw_enq_w_v                               = '1;
    hcw_enq_w.data.cmd.hcw_cmd_field.qe_valid = '0; 
    hcw_enq_w.data.cmd.hcw_cmd_field.qe_orsp  = '0; 
    hcw_enq_w.data.lockid_dir_info_tokens     = '0;
    hcw_enq_w.user.hcw_parity[1]              = ^{hcw_enq_out_data.hcw_parity[1]
                                                 ,hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_valid
                                                 ,hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_orsp
                                                 ,hcw_enq_out_data.hcw.lockid_dir_info_tokens};
   end

  end else if (~hcw_enq_out_data.vasqid_v) begin

   // For only NEW, NEW_T, RENQ, and RENQ_T we check that the QID is valid for the referenced VAS.
   // Failing the checks drops the HCW and reports the alarm.

   ingress_alarm_v_next             = cfg_ingress_alarm_enable.DISABLED_QID;
   ingress_alarm_next.aid           = 6'd4;

   // If a command includes CQ associated work (completion or token return) that is not associated
   // with the QE, we need to nuke the enqueue portion of the command (qe_valid/qe_orsp/lockid bits)
   // and adjust the associated hcw parity bit, so we can pass the CQ portion of the command.
   // This only needs to be done for NEW_T, RENQ, RENQ_T, and FRAG_T.

   if ((hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_NEW_TOK_RET)  |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP)         |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_COMP_TOK_RET) |
       (hcw_enq_out_data.hcw.cmd == HQM_CMD_ENQ_FRAG_TOK_RET)) begin

    hcw_enq_w_v                               = '1;
    hcw_enq_w.data.cmd.hcw_cmd_field.qe_valid = '0; 
    hcw_enq_w.data.cmd.hcw_cmd_field.qe_orsp  = '0; 
    hcw_enq_w.data.lockid_dir_info_tokens     = '0;
    hcw_enq_w.user.hcw_parity[1]              = ^{hcw_enq_out_data.hcw_parity[1]
                                                 ,hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_valid
                                                 ,hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_orsp
                                                 ,hcw_enq_out_data.hcw.lockid_dir_info_tokens};
   end

  end else begin

   // If all of the checks pass, send the HCW to hqm_core.  Note any valid NOOP, ARM, BAT_T,
   // COMP, or COMP_T commands were already sent above and will never reach this point, so only
   // NEW, NEW_T, RENQ, RENQ_T, FRAG, and FRAG_T make it here.

   hcw_enq_w_v                      = '1;

  end

  hcw_enq_w.user.parity = ~(^{hcw_enq_w.user.pp
                             ,hcw_enq_w.user.ao_v
                             ,hcw_enq_w.user.vas
                             ,hcw_enq_w.user.qid
                             ,hcw_enq_w.user.qe_is_ldb
                             ,hcw_enq_w.user.pp_is_ldb
                             ,hcw_enq_w.user.insert_timestamp
  });

 end // p9_load

end

//-----------------------------------------------------------------------------------------------------
// Register the alarm output for timing

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ingress_alarm_v_q <= '0;
 end else begin
  ingress_alarm_v_q <= ingress_alarm_v_next;
 end
end

always_ff @(posedge hqm_gated_clk) begin
  ingress_alarm_q <= ingress_alarm_next;
end

assign ingress_alarm_v = ingress_alarm_v_q;
assign ingress_alarm   = ingress_alarm_q;

//-----------------------------------------------------------------------------------------------------
// Double buffer output to hqm_core

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  hcw_debug_q <= '0;
  hcw_step_q  <= '0;
  hcw_mask_q  <= '0;
 end else begin
  hcw_debug_q <= {3{cfg_ingress_ctl.ENABLE_DEBUG}};
  hcw_step_q  <= cfg_ingress_ctl.SINGLE_STEP_HCW_W;
  hcw_mask_q  <= cfg_ingress_ctl.HOLD_HCW_W & hcw_debug_q[0] &
               ~(cfg_ingress_ctl.SINGLE_STEP_HCW_W & ~hcw_step_q);
 end
end

assign hcw_enq_out_ready = hcw_enq_w_ready;

hqm_AW_agitate_readyvalid #(.SEED(32'h3541)) i_agitate_hcw_enq_w_db (

         .clk               (hqm_gated_clk)
        ,.rst_n             (hqm_gated_rst_n)

        ,.control           (ig_hcw_enq_w_db_agitate_control)
        ,.enable            (1'b1)

        ,.up_v              (hcw_enq_w_v)
        ,.up_ready          (hcw_enq_w_ready)

        ,.down_v            (agg_hcw_enq_w_v)
        ,.down_ready        (agg_hcw_enq_w_ready)
);

logic           hcw_enq_w_idle_nc;

hqm_AW_tx_sync #(.WIDTH($bits(hcw_enq_w_req))) i_hcw_enq_w_db (

         .hqm_gated_clk     (hqm_gated_clk)
        ,.hqm_gated_rst_n   (hqm_gated_rst_n)
        ,.rst_prep          (rst_prep)

        ,.idle              (hcw_enq_w_idle_nc)

        ,.status            (hcw_enq_w_db_status)

        ,.in_ready          (agg_hcw_enq_w_ready)

        ,.in_valid          (agg_hcw_enq_w_v)
        ,.in_data           (hcw_enq_w)

        ,.out_ready         (hcw_enq_w_int_ready)

        ,.out_valid         (hcw_enq_w_int_valid)
        ,.out_data          (hcw_enq_w_req)
) ;

assign hcw_enq_w_req_valid = hcw_enq_w_int_valid & ~hcw_mask_q;
assign hcw_enq_w_int_ready = hcw_enq_w_req_ready & ~hcw_mask_q;

assign hcw_debug_data = {hcw_enq_w_req.user.parity             // 153      // 25
                        ,hcw_enq_w_req.user.ao_v               // 152      // 24
                        ,hcw_enq_w_req.user.insert_timestamp   // 151      // 23
                        ,hcw_enq_w_req.user.qe_is_ldb          // 150      // 22
                        ,hcw_enq_w_req.user.pp_is_ldb          // 149      // 21
                        ,hcw_enq_w_req.user.vas                // 148:144  // 20:16
                        ,hcw_enq_w_req.user.qid                // 143:136  // 15: 8
                        ,hcw_enq_w_req.user.pp                 // 135:128  //  7: 0
                        ,hcw_enq_w_req.data                    // 127:  0
} & {{($bits(hcw_debug_data)-96){hcw_debug_q[2]}}, {48{hcw_debug_q[1]}}, {48{hcw_debug_q[0]}}};

//-----------------------------------------------------------------------------------------------------
// These bits are sticky parity or ECC error indications used for syndrome or error reporting.
//
// Parity or MB ECC errors associated with ingress HCWs (HCW MB ECC, HCW port parity, LUT MB ECC, or
// LUT parity) will be logged and reported as ingress errors.
//
// Still need to capture and report any SB ECC errors (HCW SB ECC, LUT SB ECC) or errors generated
// by CFG accesses (LUT MB ECC/LUT parity) separately.  The HCW SB ECC and LUT SB/MB ECC are handled
// in earlier code, and since the lut_err includes the LUT MB ECC and LUT parity cases for syndrome,
// just the CFG LUT parity error cases needs to be included in the perr reporting bit.

assign perr_next = ((p2_cfg_q | p2_cfg_we_q[1]) & (|{lut_err.vf_ldb_vpp2pp
                                                    ,lut_err.vf_dir_vpp_v
                                                    ,lut_err.vf_ldb_vpp_v
                                                    ,lut_err.dir_pp_v
                                                    ,lut_err.ldb_pp_v
                                                    ,lut_err.vf_dir_vqid_v
                                                    ,lut_err.vf_ldb_vqid_v
                                                    ,lut_err.dir_qid_v
                                                    ,lut_err.ldb_qid_v})) |

                   ((p5_cfg_q | p5_cfg_we_q[1]) & (|{lut_err.dir_pp2vas
                                                    ,lut_err.ldb_pp2vas
                                                    ,lut_err.ldb_qid_cfg_v})) |

                   ((p8_cfg_q | p8_cfg_we_q[1]) & (|{lut_err.dir_vasqid_v
                                                    ,lut_err.ldb_vasqid_v
                                                    ,lut_err.dir_qid_its
                                                    ,lut_err.ldb_qid_its}));

assign lut_err_next.VF_DIR_VPP2PP_MB_ECC_ERR     = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_dir_vpp2pp;
assign lut_err_next.VF_LDB_VPP2PP_PERR           = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_ldb_vpp2pp;
assign lut_err_next.VF_DIR_VPP_V_PERR            = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_dir_vpp_v;
assign lut_err_next.VF_LDB_VPP_V_PERR            = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_ldb_vpp_v;
assign lut_err_next.DIR_PP_V_PERR                = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.dir_pp_v;
assign lut_err_next.LDB_PP_V_PERR                = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.ldb_pp_v;
assign lut_err_next.VF_DIR_VQID2QID_MB_ECC_ERR   = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_dir_vqid2qid;
assign lut_err_next.VF_LDB_VQID2QID_MB_ECC_ERR   = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_ldb_vqid2qid;
assign lut_err_next.VF_DIR_VQID_V_PERR           = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_dir_vqid_v;
assign lut_err_next.VF_LDB_VQID_V_PERR           = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.vf_ldb_vqid_v;
assign lut_err_next.DIR_QID_V_PERR               = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.dir_qid_v;
assign lut_err_next.LDB_QID_V_PERR               = (p3_load | p2_cfg_q | p2_cfg_we_q[1]) & lut_err.ldb_qid_v;

assign lut_err_next.DIR_PP2VAS_PERR              = (p6_load | p5_cfg_q | p5_cfg_we_q[1]) & lut_err.dir_pp2vas;
assign lut_err_next.LDB_PP2VAS_PERR              = (p6_load | p5_cfg_q | p5_cfg_we_q[1]) & lut_err.ldb_pp2vas;
assign lut_err_next.LDB_QID_CFG_V_PERR           = (p6_load | p5_cfg_q | p5_cfg_we_q[1]) & lut_err.ldb_qid_cfg_v;

assign lut_err_next.DIR_VASQID_V_PERR            = (p9_load | p8_cfg_q | p8_cfg_we_q[1]) & lut_err.dir_vasqid_v;
assign lut_err_next.LDB_VASQID_V_PERR            = (p9_load | p8_cfg_q | p8_cfg_we_q[1]) & lut_err.ldb_vasqid_v;
assign lut_err_next.DIR_QID_ITS_PERR             = (p9_load | p8_cfg_q | p8_cfg_we_q[1]) & lut_err.dir_qid_its;
assign lut_err_next.LDB_QID_ITS_PERR             = (p9_load | p8_cfg_q | p8_cfg_we_q[1]) & lut_err.ldb_qid_its;

assign lut_err_next.PORT_PERR                    = p8_port_perr;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  perr_q    <= '0;
  lut_err_q <= '0;
 end else begin
  perr_q    <= perr_next & ~cfg_parity_off;
  lut_err_q <= lut_err_next & ~{$bits(lut_err_q){cfg_parity_off}};
 end
end

assign ingress_lut_err = lut_err_q;
assign ingress_perr    = perr_q;

//-----------------------------------------------------------------------------------------------------
// Status

assign ingress_status.P8_V = p8_v_q;
assign ingress_status.P7_V = p7_v_q;
assign ingress_status.P6_V = p6_v_q;
assign ingress_status.P5_V = p5_v_q;
assign ingress_status.P4_V = p4_v_q;
assign ingress_status.P3_V = p3_v_q;
assign ingress_status.P2_V = p2_v_q;
assign ingress_status.P1_V = p1_v_q;
assign ingress_status.P0_V = p0_v_q;

assign ingress_idle_next = (~(|{p8_v_q
                               ,p7_v_q
                               ,p6_v_q
                               ,p5_v_q
                               ,p4_v_q
                               ,p3_v_q
                               ,p2_v_q
                               ,p1_v_q
                               ,p0_v_q
                               ,hcw_enq_w_db_status[1:0]
                               ,hcw_enq_db_status[1:0]
                               ,hcw_enq_fifo_status.depth
                               ,cfg_re_q
                               ,cfg_we_q
})) & init_done_q;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ingress_idle_q <= '0;
 end else begin
  ingress_idle_q <= ingress_idle_next;
 end
end

assign ingress_idle = ingress_idle_q;

//-----------------------------------------------------------------------------------------------------
// Dedicated interface event counters
// Implementing these 64b counters as two 32b halves for timing.

logic               cnt_clear_q;
logic               cnt_clearv_q;

logic               cnt_inc0;
logic   [2:0]       cnt_inc;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cnt_clear_q   <= '0;
  cnt_clearv_q  <= '0;
 end else begin
  cnt_clear_q   <= cfg_cnt_clear;
  cnt_clearv_q  <= cfg_cnt_clearv;
 end
end

// The HCW enqueue signals are in the prim_gated_clk domain and the increment needs
// to be crossed into the hqm_gated_clk domain for the counter.

assign cnt_inc0 = hcw_enq_in_v_q;

hqm_AW_async_pulses #(.WIDTH(9)) i_cnt_inc0 (

     .clk_src           (prim_gated_clk)
    ,.rst_src_n         (prim_gated_rst_n)
    ,.data              (cnt_inc0)

    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)

    ,.clk_dst           (hqm_gated_clk)
    ,.rst_dst_n         (hqm_gated_rst_n)
    ,.data_sync         (cnt_inc[0])
);

assign hcw_enq_in_sync = cnt_inc[0];

assign cnt_inc[1] = hcw_enq_w_req_valid & hcw_enq_w_req_ready;      // 3: 2 Enqueued HCWs out
assign cnt_inc[2] = p9_load             & ~hcw_enq_w_v;             // 5: 4 Enqueued HCWs dropped

generate
 for (g=0; g<=2; g=g+1) begin: g_cnt

  hqm_AW_inc_64b_val i_cnt (

     .clk       (hqm_gated_clk)
    ,.rst_n     (hqm_gated_rst_n)
    ,.clr       (cnt_clear_q)
    ,.clrv      (cnt_clearv_q)
    ,.inc       (cnt_inc[g])
    ,.count     ({cfg_ingress_cnts[1+(g*2)], cfg_ingress_cnts[g*2]})
  );

 end
endgenerate

// This control should really not be changing during normal functional operation but, if it does,
// adding a sync to guard against the metastability and a qualifier on the mode changing.

IG_HCW_ENQ_AFULL_AGITATE_CONTROL_t      agitate_control_sync;
IG_HCW_ENQ_AFULL_AGITATE_CONTROL_t      agitate_control;
logic   [1:0]                           agitate_control_mode_q;
logic                                   agitate_control_stable;
logic                                   agitate_control_stable_q;

hqm_AW_sync_rst0 #(.WIDTH(32)) i_agitate_control_sync (

     .clk                   (prim_gated_clk)
    ,.rst_n                 (prim_gated_rst_n)
    ,.data                  (ig_hcw_enq_afull_agitate_control)
    ,.data_sync             (agitate_control_sync)
);

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_n) begin
 if (~prim_gated_rst_n) begin
  agitate_control_mode_q   <= '0;
  agitate_control_stable_q <= '0;
 end else begin
  if (~agitate_control_stable) begin
   agitate_control_mode_q  <= agitate_control_sync.MODE;
  end
  agitate_control_stable_q <= agitate_control_stable;
 end
end

assign agitate_control_stable = (agitate_control_sync.MODE == agitate_control_mode_q);

assign agitate_control = agitate_control_sync &
                         {32{(agitate_control_stable & agitate_control_stable_q)}};


hqm_AW_agitate #(.SEED(32'h3545)) i_agitate_hcw_enq_fifo_afull (

        .clk                                (prim_gated_clk),
        .rst_n                              (prim_gated_rst_n),

        .control                            (agitate_control),

        .in_agitate_value                   (1'b1),
        .in_data                            (hcw_enq_fifo_afull_raw),

        .in_stall_trigger                   (1'b1),
        .out_data                           (hcw_enq_fifo_afull)
);

//-----------------------------------------------------------------------------------------------------

endmodule // hqm_system_ingress

