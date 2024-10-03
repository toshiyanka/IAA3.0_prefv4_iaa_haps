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

module hqm_system_write_buffer

         import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_system_type_pkg::*;

(
         input  logic                                           hqm_gated_clk
        ,input  logic                                           hqm_gated_rst_n

        //---------------------------------------------------------------------------------------------
        // CFG interface

        ,input  hqm_system_wb_cfg_signal_t                      cfg_re
        ,input  hqm_system_wb_cfg_signal_t                      cfg_we
        ,input  logic   [HQM_SYSTEM_AWIDTH_WB-1:0]              cfg_addr
        ,input  logic   [31:0]                                  cfg_wdata

        ,output hqm_system_wb_cfg_signal_t                      cfg_rvalid
        ,output hqm_system_wb_cfg_signal_t                      cfg_wvalid
        ,output hqm_system_wb_cfg_signal_t                      cfg_error
        ,output logic   [31:0]                                  cfg_rdata

        ,input  WRITE_BUFFER_CTL_t                              cfg_write_buffer_ctl
        ,input  logic                                           cfg_sch_wb_ecc_enable
        ,input  logic   [7:0]                                   cfg_inj_ecc_err_wbuf
        ,input  logic   [4:0]                                   cfg_inj_par_err_wbuf
        ,input  logic   [HQM_SYSTEM_AWIDTH_SCH_OUT_FIFO:0]      cfg_sch_out_fifo_high_wm
        ,input  logic                                           cfg_cnt_clear
        ,input  logic                                           cfg_cnt_clearv
        ,input  logic                                           cfg_parity_off
        ,input  logic                                           cfg_residue_off

        ,input  logic                                           pci_cfg_sciov_en

        ,output logic                                           sch_wb_error
        ,output logic   [7:0]                                   sch_wb_error_synd
        ,output logic   [3:0]                                   sch_wb_sb_ecc_error
        ,output logic   [3:0]                                   sch_wb_mb_ecc_error
        ,output logic   [7:0]                                   sch_wb_ecc_syndrome
        ,output logic                                           sch_sm_error
        ,output logic   [7:0]                                   sch_sm_syndrome
        ,output logic   [2:0]                                   sch_sm_drops
        ,output logic   [HQM_SYSTEM_CQ_WIDTH-1:0]               sch_sm_drops_comp
        ,output logic   [2:0]                                   sch_clr_drops
        ,output logic   [HQM_SYSTEM_CQ_WIDTH-1:0]               sch_clr_drops_comp

        ,output aw_fifo_status_t                                sch_out_fifo_status
        ,output logic   [6:0]                                   cq_occ_db_status
        ,output logic   [6:0]                                   phdr_db_status
        ,output logic   [6:0]                                   pdata_ms_db_status
        ,output logic   [6:0]                                   pdata_ls_db_status

        ,output new_WBUF_STATUS_t                               wbuf_status
        ,output new_WBUF_STATUS2_t                              wbuf_status2
        ,output new_WBUF_DEBUG_t                                wbuf_debug

        ,output logic                                           wbuf_idle
        ,output logic [1:0]                                     wbuf_appended

        ,output logic [21:10] [31:0]                            cfg_wbuf_cnts
        ,output logic [83:0]                                    cfg_phdr_debug
        ,output logic [511:0]                                   cfg_pdata_debug

        // HW agitate control
        ,input  WB_SCH_OUT_AFULL_AGITATE_CONTROL_t              wb_sch_out_afull_agitate_control       // SCH_OUT almost full agitate control

        //---------------------------------------------------------------------------------------------
        // HCW Sched interface from egress

        ,output logic                                           hcw_sched_out_ready

        ,input  logic                                           hcw_sched_out_v
        ,input  hqm_system_sch_data_out_t                       hcw_sched_out

        //---------------------------------------------------------------------------------------------
        // CQ occupancy interrupt interface to alarm

        ,input  logic                                           cq_occ_int_busy

        ,output logic                                           cq_occ_int_v
        ,output interrupt_w_req_t                               cq_occ_int

        //---------------------------------------------------------------------------------------------
        // MSI-X interface from alarm

        ,output logic                                           ims_msix_w_ready

        ,input  logic                                           ims_msix_w_v
        ,input  hqm_system_ims_msix_w_t                         ims_msix_w

        //---------------------------------------------------------------------------------------------
        // SIF interface

        ,input  logic                                           write_buffer_mstr_ready

        ,output logic                                           write_buffer_mstr_v
        ,output write_buffer_mstr_t                             write_buffer_mstr

        ,output logic                                           pwrite_v
        ,output logic   [31:0]                                  pwrite_comp
        ,output logic   [31:0]                                  pwrite_value

        //---------------------------------------------------------------------------------------------
        // Memory interface

        ,output hqm_system_memi_sch_out_fifo_t                  memi_sch_out_fifo
        ,input  hqm_system_memo_sch_out_fifo_t                  memo_sch_out_fifo
        ,output hqm_system_memi_dir_wb_t                        memi_dir_wb0
        ,input  hqm_system_memo_dir_wb_t                        memo_dir_wb0
        ,output hqm_system_memi_dir_wb_t                        memi_dir_wb1
        ,input  hqm_system_memo_dir_wb_t                        memo_dir_wb1
        ,output hqm_system_memi_dir_wb_t                        memi_dir_wb2
        ,input  hqm_system_memo_dir_wb_t                        memo_dir_wb2
        ,output hqm_system_memi_ldb_wb_t                        memi_ldb_wb0
        ,input  hqm_system_memo_ldb_wb_t                        memo_ldb_wb0
        ,output hqm_system_memi_ldb_wb_t                        memi_ldb_wb1
        ,input  hqm_system_memo_ldb_wb_t                        memo_ldb_wb1
        ,output hqm_system_memi_ldb_wb_t                        memi_ldb_wb2
        ,input  hqm_system_memo_ldb_wb_t                        memo_ldb_wb2

);

localparam NUM_DIR_CQ_P2 = (1<<HQM_SYSTEM_DIR_CQ_WIDTH);
localparam NUM_LDB_CQ_P2 = (1<<HQM_SYSTEM_LDB_CQ_WIDTH);

//-----------------------------------------------------------------------------------------------------

logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   hcw_sched_out_dir_cq_scaled;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   hcw_sched_out_ldb_cq_scaled;

logic                                               sch_out_fifo_push;
logic                                               sch_out_fifo_push_q;
hqm_system_sch_out_fifo_t                           sch_out_fifo_push_data;
hqm_system_sch_out_fifo_t                           sch_out_fifo_push_data_q;
logic                                               sch_out_fifo_pop;
logic                                               sch_out_fifo_pop_data_v;
logic                                               sch_out_fifo_pop_data_v_limited;
hqm_system_sch_out_fifo_t                           sch_out_fifo_pop_data;
logic                                               sch_out_fifo_pop_parity;
logic                                               sch_out_fifo_full_nc;
logic                                               sch_out_fifo_afull;
logic                                               sch_out_fifo_afull_raw;
logic                                               sch_out_fifo_perr;
logic                                               sch_out_fifo_int_perr;

hqm_system_sch_sm_state_t                           sch_sm_state_next;
hqm_system_sch_sm_state_t                           sch_sm_state_q;
logic   [$bits(hqm_system_sch_sm_state_t)-1:0]      sch_sm_state;
logic   [63:4]                                      sch_sm_cq_addr;                 // 16B addr
logic   [1:0]                                       sch_sm_cq_addr_res;
logic                                               sch_sm_ldb;
logic                                               sch_sm_ro;
logic   [1:0]                                       sch_sm_spare;
logic   [HQM_PASIDTLP_WIDTH-1:0]                    sch_sm_pasidtlp;
logic                                               sch_sm_is_pf;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]                   sch_sm_vf;
logic   [2:0]                                       sch_sm_beats;
logic                                               sch_sm_data_v;
logic                                               sch_sm_sop;
logic                                               sch_sm_eop;
logic                                               sch_sm_parity;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   sch_sm_cq;
logic   [3:0]                                       sch_sm_dir_data_v_next;
logic   [3:0]                                       sch_sm_dir_data_v_q;
logic   [HQM_SYSTEM_DIR_CQ_WIDTH-1:0]               sch_sm_dir_cq_next;
logic   [HQM_SYSTEM_DIR_CQ_WIDTH-1:0]               sch_sm_dir_cq_q;
logic   [63:4]                                      sch_sm_dir_addr_next;
logic   [63:4]                                      sch_sm_dir_addr_q;
logic   [1:0]                                       sch_sm_dir_addr_res_next;
logic   [1:0]                                       sch_sm_dir_addr_res_q;
logic                                               sch_sm_dir_ro_next;
logic                                               sch_sm_dir_ro_q;
logic   [1:0]                                       sch_sm_dir_spare_next;
logic   [1:0]                                       sch_sm_dir_spare_q;
logic   [HQM_PASIDTLP_WIDTH-1:0]                    sch_sm_dir_pasidtlp_next;
logic   [HQM_PASIDTLP_WIDTH-1:0]                    sch_sm_dir_pasidtlp_q;
logic                                               sch_sm_dir_is_pf_next;
logic                                               sch_sm_dir_is_pf_q;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]                   sch_sm_dir_vf_next;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]                   sch_sm_dir_vf_q;
logic                                               sch_sm_dir_parity_next;
logic                                               sch_sm_dir_parity_q;
logic                                               sch_sm_dir_pad_ok_next;
logic                                               sch_sm_dir_pad_ok_q;
logic                                               sch_sm_dir_gen_next;
logic                                               sch_sm_dir_gen_q;
logic                                               sch_sm_opt_in_prog_next;
logic                                               sch_sm_opt_in_prog_q;
logic                                               sch_sm_opt_cq_mismatch;
logic                                               sch_sm_int_v;
logic                                               sch_sm_int_matches_opt;
logic                                               sch_sm_int_matches_dir_cq;
logic                                               sch_sm_error_idv;
logic                                               sch_sm_error_wbo;
logic                                               sch_sm_error_vdv;
logic                                               sch_sm_opt_clr;
logic   [2:0]                                       sch_sm_drops_next;
logic   [2:0]                                       sch_sm_drops_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   sch_sm_drops_comp_next;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   sch_sm_drops_comp_q;
logic   [2:0]                                       sch_clr_drops_next;
logic   [2:0]                                       sch_clr_drops_q;
logic   [1:0]                                       sch_sm_appended;
logic   [2:0]                                       sch_sm_dsel0;
logic   [2:0]                                       sch_sm_dsel1;
logic   [1:0]                                       sch_sm_res_adj;
logic                                               sch_sm_gen;

hqm_system_wb_t                                     error_pad;
hqm_system_wb_t                                     zero_pad;
hqm_system_wb_t                                     pad;

logic                                               sch_p0_hold;
logic                                               sch_p0_load;
logic                                               sch_p0_v_q;
hqm_system_sch_pipe_hdr_t                           sch_p0_hdr_next;
hqm_system_sch_pipe_hdr_t                           sch_p0_hdr_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   sch_p0_cq_q;
hqm_system_wb_t                                     sch_p0_data_q;
logic                                               sch_p0_fifo_perr_q;

logic                                               sch_p1_hold;
logic                                               sch_p1_load;
logic                                               sch_p1_v_q;
hqm_system_sch_pipe_hdr_t                           sch_p1_hdr_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   sch_p1_cq_q;
hqm_system_wb_t                                     sch_p1_data_q;

logic                                               sch_p2_hold;
logic                                               sch_p2_load;
logic                                               sch_p2_v_q;
hqm_system_sch_pipe_hdr_t                           sch_p2_hdr_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   sch_p2_cq_q;
hqm_system_wb_t                                     sch_p2_data_q;
logic   [4:0]                                       sch_p2_vf_scaled;
hqm_system_wb_t                                     sch_p2_wb0_q;
hqm_system_wb_t                                     sch_p2_wb1_q;
hqm_system_wb_t                                     sch_p2_wb2_q;
hqm_system_wb_t                                     sch_p2_data[1:0];
outbound_hcw_t                                      sch_p2_data_corrected[1:0];
logic   [1:0]                                       sch_p2_check_ecc;
logic                                               sch_p2_perr;
logic                                               sch_p2_rerr;
logic                                               sch_p2_res_check;
logic   [1:0]                                       sch_p2_cq_addr_res;

logic   [1:0]                                       sch_p2_sb_ecc_error_ls;
logic   [1:0]                                       sch_p2_sb_ecc_error_ms;
logic   [1:0]                                       sch_p2_mb_ecc_error_ls;
logic   [1:0]                                       sch_p2_mb_ecc_error_ms;

logic   [3:0]                                       sch_p3_sb_ecc_error_next;
logic   [3:0]                                       sch_p3_sb_ecc_error_q;
logic   [3:0]                                       sch_p3_mb_ecc_error_next;
logic   [3:0]                                       sch_p3_mb_ecc_error_q;
logic                                               sch_p3_perr_q;
logic                                               sch_p3_rerr_q;
logic   [HQM_SYSTEM_CQ_WIDTH-1:0]                   sch_p3_cq_q;

logic   [7:0]                                       sch_inj_ecc_err_q;
logic   [7:0]                                       sch_inj_ecc_err_last_q;
logic   [4:0]                                       sch_inj_par_err_q;
logic   [4:0]                                       sch_inj_par_err_last_q;

logic                                               sch_hdr_v;
hqm_ph_t                                            sch_hdr;
logic                                               sch_data_v;
outbound_hcw_t                                      sch_data[1:0];
logic                                               sch_data_first;
logic                                               sch_data_last;

logic                                               sch_arb_req;
logic                                               ims_msix_arb_req;

hqm_ph_t                                            ims_msix_hdr;
logic                                               ims_msix_res_check;
logic                                               ims_msix_rerr;
logic                                               ims_msix_rerr_q;
logic                                               ims_msix_perr;
logic                                               ims_msix_perr_q;
logic   [1:0]                                       ims_msix_res;

logic   [1:0]                                       arb_reqs;
logic   [1:0]                                       arb_reqs_q;
logic                                               arb_update;
logic                                               arb_winner_v;
logic                                               arb_winner;
logic                                               arb_winner_q;
logic                                               arb_winner_sch;
logic                                               arb_winner_msix;
logic                                               arb_hold_next;
logic                                               arb_hold_q;
logic   [1:0]                                       arb_single_step;
logic   [1:0]                                       arb_mask;
logic   [1:0]                                       arb_step_q;
logic   [9:0]                                       arb_debug_q;

logic                                               phdr_v;
hqm_ph_t                                            phdr;

logic                                               pdata_v;
hqm_pd_t                                            pdata;

logic                                               phdr_db_in_ready;
logic                                               phdr_db_in_v;
hqm_ph_t                                            phdr_db_in_data;
logic                                               phdr_db_out_ready;
logic                                               phdr_db_out_v;
hqm_ph_t                                            phdr_db_out_data;

logic                                               pdata_ms_db_in_ready;
logic                                               pdata_ms_db_in_v;
hqm_pd_t                                            pdata_ms_db_in_data;
logic                                               pdata_ms_db_out_ready;
logic                                               pdata_ms_db_out_v;
hqm_pd_t                                            pdata_ms_db_out_data;

logic                                               pdata_ls_db_in_ready;
logic                                               pdata_ls_db_in_v;
hqm_pd_t                                            pdata_ls_db_in_data;
logic                                               pdata_ls_db_out_ready;
logic                                               pdata_ls_db_out_v;
hqm_pd_t                                            pdata_ls_db_out_data;

logic                                               wbuf_idle_next;
logic                                               wbuf_idle_q;
new_WBUF_DEBUG_t                                    wbuf_debug_next;
new_WBUF_DEBUG_t                                    wbuf_debug_q;
logic   [1:0]                                       wbuf_appended_next;
logic   [1:0]                                       wbuf_appended_q;

logic                                               cq_occ_int_db_ready;
logic                                               cq_occ_int_db_v;
interrupt_w_req_t                                   cq_occ_int_db;
logic                                               cq_occ_int_ready;
logic                                               cq_occ_int_busy_q;

hqm_system_memi_dir_wb_t                            memi_dir_wb_next[3:0];
hqm_system_memi_ldb_wb_t                            memi_ldb_wb_next[3:0];

hqm_system_memi_dir_wb_t                            memi_dir_wb_nxt[2:0];
hqm_system_memi_ldb_wb_t                            memi_ldb_wb_nxt[2:0];

hqm_system_memi_dir_wb_t                            memi_dir_wb_q[2:0];
hqm_system_memi_ldb_wb_t                            memi_ldb_wb_q[2:0];


logic [NUM_DIR_CQ_P2-1:0]                           dir_wb0_v_next;
logic [NUM_DIR_CQ_P2-1:0]                           dir_wb1_v_next;
logic [NUM_DIR_CQ_P2-1:0]                           dir_wb2_v_next;
logic [NUM_LDB_CQ_P2-1:0]                           ldb_wb0_v_next;
logic [NUM_LDB_CQ_P2-1:0]                           ldb_wb1_v_next;
logic [NUM_LDB_CQ_P2-1:0]                           ldb_wb2_v_next;

logic [NUM_DIR_CQ-1:0]                              dir_wb0_v_q;
logic [NUM_DIR_CQ_P2-1:0]                           dir_wb0_v_scaled;
logic [NUM_DIR_CQ-1:0]                              dir_wb1_v_q;
logic [NUM_DIR_CQ_P2-1:0]                           dir_wb1_v_scaled;
logic [NUM_DIR_CQ-1:0]                              dir_wb2_v_q;
logic [NUM_DIR_CQ_P2-1:0]                           dir_wb2_v_scaled;
logic [NUM_LDB_CQ-1:0]                              ldb_wb0_v_q;
logic [NUM_LDB_CQ_P2-1:0]                           ldb_wb0_v_scaled;
logic [NUM_LDB_CQ-1:0]                              ldb_wb1_v_q;
logic [NUM_LDB_CQ_P2-1:0]                           ldb_wb1_v_scaled;
logic [NUM_LDB_CQ-1:0]                              ldb_wb2_v_q;
logic [NUM_LDB_CQ_P2-1:0]                           ldb_wb2_v_scaled;

hqm_system_wb_cfg_signal_t                          cfg_rvalid_next;
hqm_system_wb_cfg_signal_t                          cfg_rvalid_q;
hqm_system_wb_cfg_signal_t                          cfg_wvalid_next;
hqm_system_wb_cfg_signal_t                          cfg_wvalid_q;
hqm_system_wb_cfg_signal_t                          cfg_error_next;
hqm_system_wb_cfg_signal_t                          cfg_error_q;
logic [HQM_SYSTEM_AWIDTH_WB-1:0]                    cfg_addr_next;
logic [HQM_SYSTEM_AWIDTH_WB-1:0]                    cfg_addr_q;
logic   [31:0]                                      cfg_rdata_next;
logic   [31:0]                                      cfg_rdata_q;
logic                                               cfg_wdata_clr_wb_cq_state_next;
logic                                               cfg_wdata_clr_wb_cq_state_q;
         
genvar                                              g;

assign cfg_rvalid = cfg_rvalid_q;
assign cfg_wvalid = cfg_wvalid_q;
assign cfg_error = cfg_error_q;
assign cfg_rdata = cfg_rdata_q;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cfg_rvalid_q <= '0;
  cfg_wvalid_q <= '0;
  cfg_error_q <= '0;
  cfg_addr_q <= '0;
  cfg_rdata_q <= '0;
  cfg_wdata_clr_wb_cq_state_q <= '0;
 end else begin
  cfg_rvalid_q <= cfg_rvalid_next;
  cfg_wvalid_q <= cfg_wvalid_next;
  cfg_error_q <= cfg_error_next;
  cfg_addr_q <= cfg_addr_next;
  cfg_rdata_q <= cfg_rdata_next;
  cfg_wdata_clr_wb_cq_state_q <= cfg_wdata_clr_wb_cq_state_next;
 end
end

always_comb begin
 cfg_rvalid_next = {(cfg_re.wb_dir_cq_state & ~cfg_rvalid_q.wb_dir_cq_state),
                    (cfg_re.wb_ldb_cq_state & ~cfg_rvalid_q.wb_ldb_cq_state)};
 cfg_wvalid_next = {(cfg_we.wb_dir_cq_state & ~cfg_wvalid_q.wb_dir_cq_state),
                    (cfg_we.wb_ldb_cq_state & ~cfg_wvalid_q.wb_ldb_cq_state)};
// dirpp96
/*
 cfg_error_next = {((cfg_re.wb_dir_cq_state | cfg_we.wb_dir_cq_state) ? (cfg_addr>7'd95) : 1'b0),
                   ((cfg_re.wb_ldb_cq_state | cfg_we.wb_ldb_cq_state) ? (cfg_addr>7'd63) : 1'b0)};
*/
// dirpp64
 cfg_error_next = {((cfg_re.wb_dir_cq_state | cfg_we.wb_dir_cq_state) ? (1'b0          ) : 1'b0),
                   ((cfg_re.wb_ldb_cq_state | cfg_we.wb_ldb_cq_state) ? (1'b0          ) : 1'b0)};
// dirpp32
/* 
 cfg_error_next = {((cfg_re.wb_dir_cq_state | cfg_we.wb_dir_cq_state) ? (cfg_addr>6'd31) : 1'b0),
                   ((cfg_re.wb_ldb_cq_state | cfg_we.wb_ldb_cq_state) ? (1'b0          ) : 1'b0)};
*/
 cfg_addr_next = (cfg_rvalid_next.wb_dir_cq_state | cfg_rvalid_next.wb_ldb_cq_state) ? cfg_addr :
                 (cfg_wvalid_next.wb_dir_cq_state | cfg_wvalid_next.wb_ldb_cq_state) ? cfg_addr : cfg_addr_q;
 cfg_rdata_next = cfg_re.wb_dir_cq_state ? {28'd0,
                                            ((sch_sm_dir_cq_q==cfg_addr[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]) ? sch_sm_opt_in_prog_q : 1'd0 ), 
                                            dir_wb2_v_scaled[cfg_addr[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]],
                                            dir_wb1_v_scaled[cfg_addr[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]],
                                            dir_wb0_v_scaled[cfg_addr[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]} :
                  cfg_re.wb_ldb_cq_state ? {29'd0,
                                            ldb_wb2_v_scaled[cfg_addr[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]],
                                            ldb_wb1_v_scaled[cfg_addr[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]],
                                            ldb_wb0_v_scaled[cfg_addr[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]]} :
                  '0;
 cfg_wdata_clr_wb_cq_state_next = (cfg_wvalid_next.wb_dir_cq_state | cfg_wvalid_next.wb_ldb_cq_state) & cfg_wdata[4]; 
end

//-----------------------------------------------------------------------------------------------------
// HCW schedule input
//-----------------------------------------------------------------------------------------------------
// We pipeline and FIFO up any CQ occupany interrupts along with the HCW schedule stream so we can
// ensure that prior HCW schedules have been written out before sending the interrupt request to
// the alarm logic.  This means there may be cases where we have an interrupt flowing through the
// pipeline by itself, a schedule by itself, or both combined.  The hcw_v and int_v bits denote
// these different cases.

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_DIR_CQ_WIDTH),
                      .Z_WIDTH(HQM_SYSTEM_CQ_WIDTH)) u_hcw_sched_out_dir_cq_scaled (

     .a         (hcw_sched_out.w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
    ,.z         (hcw_sched_out_dir_cq_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_LDB_CQ_WIDTH),
                      .Z_WIDTH(HQM_SYSTEM_CQ_WIDTH)) u_hcw_sched_out_ldb_cq_scaled (

     .a         (hcw_sched_out.w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
    ,.z         (hcw_sched_out_ldb_cq_scaled)
);

// Logic to push current scheduled HCW request onto the schedule output FIFO.

always_comb begin

 hcw_sched_out_ready                = '0;
                                   
 sch_out_fifo_push                  = '0;
 sch_out_fifo_push_data             = '0;
                                   
 sch_out_fifo_push_data.pad_ok      = hcw_sched_out.w.user.hqm_core_flags.pad_ok;
 sch_out_fifo_push_data.ro          = hcw_sched_out.ro;
 sch_out_fifo_push_data.error_parity= hcw_sched_out.error_parity; 
 sch_out_fifo_push_data.error       = hcw_sched_out.error; 
 sch_out_fifo_push_data.pasidtlp    = hcw_sched_out.pasidtlp;
 sch_out_fifo_push_data.is_pf       = hcw_sched_out.is_pf;
 sch_out_fifo_push_data.vf          = hcw_sched_out.vf;
 sch_out_fifo_push_data.cq_addr     = hcw_sched_out.cq_addr;
 sch_out_fifo_push_data.int_v       = hcw_sched_out.int_v;
 sch_out_fifo_push_data.int_d       = hcw_sched_out.int_d;
 sch_out_fifo_push_data.hcw_v       = hcw_sched_out.hcw_v;
 sch_out_fifo_push_data.ldb         = hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb;
 sch_out_fifo_push_data.wbo         = hcw_sched_out.w.user.hqm_core_flags.write_buffer_optimization;
 sch_out_fifo_push_data.beat        = hcw_sched_out.w.user.cq_wptr[1:0];
 sch_out_fifo_push_data.hcw         = hcw_sched_out.w.data;
 sch_out_fifo_push_data.ecc         = hcw_sched_out.ecc;
 sch_out_fifo_push_data.cq_addr_res = hcw_sched_out.cq_addr_res;

 sch_out_fifo_push_data.cq          = (hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb) ?
                                       hcw_sched_out_ldb_cq_scaled :
                                       hcw_sched_out_dir_cq_scaled;

 // Coming over on the sched_out interface:
 //
 //     int_d   is covered by embedded parity
 //     cq_addr is covered by the cq_addr_res residue
 //     ro, is_pf, vf, pasidtlp, spare, hcw_v, and int_v are included in the parity bit
 //     The hqm_core_flags parity bit covers that field and the cq and cq_wptr fields.
 //
 // Need to adjust the parity bit to cover just the hqm_core_flags fields we actually use.
 // So need to adjust for removing the parity, congestion_management, ignore_cq_depth,
 // and cq_wptr[12:2] fields from the parity. That parity is odd, so invert.

 sch_out_fifo_push_data.parity = ~^{hcw_sched_out.parity
                                   ,hcw_sched_out.w.user.hqm_core_flags.parity
                                   ,hcw_sched_out.w.user.hqm_core_flags.congestion_management
                                   ,hcw_sched_out.w.user.hqm_core_flags.ignore_cq_depth
                                   ,hcw_sched_out.w.user.cq_wptr[12:2]};

 // Wait until we have a valid input request and the output FIFO is not full.
 // Can have the error bit set indicating that there was a LUT or header parity error.
 // The error can be set standalone or have an interrupt tacked onto it.
 // The standalone case can just be consumed w/o doing a push to the FIFO.
 // The tacked on interrupt case must push the interrupt onto the FIFO.  Note that
 // hcw_v cannot be set when the error is also set.

 // previously standalone hcw with error was not pushed into sch_out_fifo and the state machine was not aware of any prior drop.
 // now standalone hcw with error is pushed into sch_out_fifo
 // for ldb or non dir burst optimization case, standalone hcw with error will just be dropped.
 // for dir burst optimization case, the standalone hcw with error is now seen by the state machine and it's used to break the current optimization state
 //
 // hcw_v error int_v sch_out_fifo_push
 // 1     0     0     1				standalone hcw with no error
 // 1     0     1     1				hcw with no error + interrupt
 // 0     0     1     1				standalone interrupt 
 // 0     1     1     1                         hcw with error + interrupt becomes standalone interrupt
 // 0     1     0     1                         standalone hcw with error
      
 if (hcw_sched_out_v & ~sch_out_fifo_afull) begin

    hcw_sched_out_ready = '1;
    sch_out_fifo_push   = hcw_sched_out.int_v | hcw_sched_out.hcw_v | hcw_sched_out.error;

 end

end

hqm_AW_unused_bits i_unused (

         .a     (|{memi_dir_wb_next[3]
                  ,memi_ldb_wb_next[3]
                  ,memi_dir_wb_nxt[0].we
                  ,memi_dir_wb_nxt[0].re
                  ,memi_dir_wb_nxt[0].raddr
                  ,memi_dir_wb_nxt[1].we
                  ,memi_dir_wb_nxt[1].re
                  ,memi_dir_wb_nxt[1].raddr
                  ,memi_dir_wb_nxt[2].we
                  ,memi_dir_wb_nxt[2].re
                  ,memi_dir_wb_nxt[2].raddr
                  ,memi_ldb_wb_nxt[0].we
                  ,memi_ldb_wb_nxt[0].re
                  ,memi_ldb_wb_nxt[0].raddr
                  ,memi_ldb_wb_nxt[1].we
                  ,memi_ldb_wb_nxt[1].re
                  ,memi_ldb_wb_nxt[1].raddr
                  ,memi_ldb_wb_nxt[2].we
                  ,memi_ldb_wb_nxt[2].re
                  ,memi_ldb_wb_nxt[2].raddr
                })
);

//-----------------------------------------------------------------------------------------------------
// Schedule output request FIFO
//
// Register the push.  This increases latency but reduces logic levels in the path.

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  sch_out_fifo_push_q <= '0;
 end else begin
  sch_out_fifo_push_q <= sch_out_fifo_push;
 end
end

always_ff @(posedge hqm_gated_clk) begin
 sch_out_fifo_push_data_q <= sch_out_fifo_push_data;
end

hqm_AW_fifo_control_big_wreg #(

         .DEPTH                 (HQM_SYSTEM_DEPTH_SCH_OUT_FIFO)
        ,.DWIDTH                (HQM_SYSTEM_DWIDTH_SCH_OUT_FIFO)
        ,.MEMRE_POWER_OPT       (0)

) i_sch_out_fifo (

         .clk                   (hqm_gated_clk)
        ,.rst_n                 (hqm_gated_rst_n)

        ,.cfg_high_wm           (cfg_sch_out_fifo_high_wm)

        ,.push                  (sch_out_fifo_push_q)
        ,.push_data             (sch_out_fifo_push_data_q)
        ,.pop                   (sch_out_fifo_pop)
        ,.pop_data_v            (sch_out_fifo_pop_data_v)
        ,.pop_data              (sch_out_fifo_pop_data)

        ,.mem_we                (memi_sch_out_fifo.we)
        ,.mem_waddr             (memi_sch_out_fifo.waddr)
        ,.mem_wdata             (memi_sch_out_fifo.wdata)
        ,.mem_re                (memi_sch_out_fifo.re)
        ,.mem_raddr             (memi_sch_out_fifo.raddr)
        ,.mem_rdata             (memo_sch_out_fifo.rdata)

        ,.fifo_status           (sch_out_fifo_status)
        ,.fifo_full             (sch_out_fifo_full_nc)
        ,.fifo_afull            (sch_out_fifo_afull_raw)
);

// Rate limit the FIFO entering the schedule pipeline

hqm_AW_pipe_rate_limit #(.WIDTH(1), .DEPTH(3)) i_sch_rate_limit (

     .cfg           (cfg_write_buffer_ctl.SCH_RATE_LIMIT)
    ,.pipe_v        ({sch_p2_v_q, sch_p1_v_q, sch_p0_v_q})

    ,.v_in          (sch_out_fifo_pop_data_v)

    ,.v_out         (sch_out_fifo_pop_data_v_limited)
);

assign sch_out_fifo_perr = sch_out_fifo_pop_data_v_limited & ~cfg_parity_off & 
                       (((^{sch_out_fifo_pop_data.parity
                           ,sch_out_fifo_pop_data.spare
                           ,sch_out_fifo_pop_data.pad_ok
                           ,sch_out_fifo_pop_data.ldb
                           ,sch_out_fifo_pop_data.ro
                           ,sch_out_fifo_pop_data.pasidtlp
                           ,sch_out_fifo_pop_data.is_pf
                           ,sch_out_fifo_pop_data.vf
                           ,sch_out_fifo_pop_data.int_v
                           ,sch_out_fifo_pop_data.hcw_v
                           ,sch_out_fifo_pop_data.cq
                           ,sch_out_fifo_pop_data.beat
                           ,sch_out_fifo_pop_data.wbo}) & ~sch_out_fifo_pop_data.error) |
                        (^{1'b1,sch_out_fifo_pop_data.error_parity,sch_out_fifo_pop_data.error}) |
                        (sch_inj_par_err_q[0] & ~sch_inj_par_err_last_q[0]));

assign sch_out_fifo_int_perr = sch_out_fifo_pop_data_v_limited & ~cfg_parity_off & 
                               (^{1'b1,sch_out_fifo_pop_data.int_d});
// Remove the pad_ok, hcw_v, int_v, beat, wbo, ldb and cq fields from the parity as they are consumed
// So the parity now covers only ro, spare, pasidtlp, is_pf, and vf

assign sch_out_fifo_pop_parity = ^{sch_out_fifo_pop_data.parity
                                  ,sch_out_fifo_pop_data.pad_ok
                                  ,sch_out_fifo_pop_data.hcw_v
                                  ,sch_out_fifo_pop_data.int_v
                                  ,sch_out_fifo_pop_data.ldb
                                  ,sch_out_fifo_pop_data.cq
                                  ,sch_out_fifo_pop_data.beat
                                  ,sch_out_fifo_pop_data.wbo};

//-----------------------------------------------------------------------------------------------------
// HCW schedule output state machine
//-----------------------------------------------------------------------------------------------------
//
// Need to generate either 1 or 2 SIF posted writes depending on remaining beats information from the
// LSP for DIR CQs.  If for a LDB CQ or write_single_beats is set in the DIR CQ case, we will only
// write 16B at a time.
//
// wbv   SI0F               SIF1
//  1    0   /FIFO                             Partial
//  3    FIFO/SAVE                             Partial
//  7    FIFO/SAVE          0   /FIFO          Partial
//  f    FIFO/SAVE          FIFO/SAVE          Full
//  2    0   /FIFO                             Partial
//  6    FIFO/SAVE                             Partial
//  e    FIFO/SAVE          0   /FIFO          Partial
//  4    0   /FIFO                             Partial
//  c    FIFO/SAVE                             Partial
//  8    0   /FIFO                             Partial
//
// Note that we could have up to 4 interrupts piggybacking on a single DIR CQ write (one on each of the
// four 16B HCWs in the 64B case.
//
// Also need to handle the multiple beat DIR CQ cases where a standalone interrupt or load balanced CQ
// is inserted between the DIR CQ beats, or the DIR CQ of the current beat doesn't match the DIR CQ we
// started for the multiple beat cases.
//
// If a standalone interrupt or an interrupt tacked onto a LDB CQ comes in after we have started a
// multiple beat DIR CQ write, then we need to break the optimization and send out the DIR CQ data we
// currently have before sending the interrupt out.

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  sch_sm_state_q        <= SCH_SM_IDLE;
  sch_sm_dir_addr_q     <= '0;
  sch_sm_dir_addr_res_q <= '0;
  sch_sm_dir_cq_q       <= '0;
  sch_sm_dir_ro_q       <= '0;
  sch_sm_dir_spare_q    <= '0;
  sch_sm_dir_pasidtlp_q <= '0;
  sch_sm_dir_is_pf_q    <= '0;
  sch_sm_dir_vf_q       <= '0;
  sch_sm_dir_data_v_q   <= '0;
  sch_sm_dir_parity_q   <= '0;
  sch_sm_dir_pad_ok_q   <= '0;
  sch_sm_dir_gen_q      <= '0;
  sch_sm_opt_in_prog_q  <= '0;
  sch_sm_drops_q        <= '0;
  sch_sm_drops_comp_q   <= '0;
  sch_clr_drops_q       <= '0;
 end else begin
  sch_sm_state_q        <= sch_sm_state_next;
  sch_sm_dir_addr_q     <= sch_sm_dir_addr_next;
  sch_sm_dir_addr_res_q <= sch_sm_dir_addr_res_next;
  sch_sm_dir_cq_q       <= sch_sm_dir_cq_next;
  sch_sm_dir_ro_q       <= sch_sm_dir_ro_next;
  sch_sm_dir_spare_q    <= sch_sm_dir_spare_next;
  sch_sm_dir_pasidtlp_q <= sch_sm_dir_pasidtlp_next;
  sch_sm_dir_is_pf_q    <= sch_sm_dir_is_pf_next;
  sch_sm_dir_vf_q       <= sch_sm_dir_vf_next;
  sch_sm_dir_data_v_q   <= sch_sm_dir_data_v_next  & ~{4{sch_sm_opt_clr}};
  sch_sm_dir_parity_q   <= sch_sm_dir_parity_next;
  sch_sm_dir_pad_ok_q   <= sch_sm_dir_pad_ok_next;
  sch_sm_dir_gen_q      <= sch_sm_dir_gen_next;
  sch_sm_opt_in_prog_q  <= sch_sm_opt_in_prog_next &    ~sch_sm_opt_clr;
  sch_sm_drops_q        <= sch_sm_drops_next;
  sch_sm_drops_comp_q   <= sch_sm_drops_comp_next;
  sch_clr_drops_q       <= sch_clr_drops_next;
 end
end

assign sch_sm_state   = sch_sm_state_q;

assign sch_sm_opt_clr = cfg_wvalid_q.wb_dir_cq_state & cfg_wdata_clr_wb_cq_state_q &
                        (cfg_addr_q[HQM_SYSTEM_DIR_CQ_WIDTH-1:0] == sch_sm_dir_cq_q);
                       
assign sch_clr_drops_next = {3{sch_sm_opt_clr}} &
                            ({2'd0, sch_sm_dir_data_v_q[0]} +
                             {2'd0, sch_sm_dir_data_v_q[1]} +
                             {2'd0, sch_sm_dir_data_v_q[2]} +
                             {2'd0, sch_sm_dir_data_v_q[3]});

assign sch_sm_drops       = sch_sm_drops_q;
assign sch_sm_drops_comp  = sch_sm_drops_comp_q;
assign sch_clr_drops      = sch_clr_drops_q;
always_comb begin
 sch_clr_drops_comp = 'h0;
 sch_clr_drops_comp[HQM_SYSTEM_DIR_CQ_WIDTH-1:0] = sch_sm_dir_cq_q[HQM_SYSTEM_DIR_CQ_WIDTH-1:0];
end

// This indicates when the FIFO output contains an interrupt where the interrupt's DIR CQ
// matches the DIR CQ for a current optimization and it's either a standalone interrupt or
// it is appended with an HCW where the HCW's CQ is not the DIR CQ of a current optimization.

assign sch_sm_int_matches_opt = sch_out_fifo_pop_data_v_limited & sch_out_fifo_pop_data.int_v &
    sch_sm_opt_in_prog_q & ~sch_out_fifo_pop_data.int_d.is_ldb &
    (sch_out_fifo_pop_data.int_d.cq_occ_cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0] == sch_sm_dir_cq_q) &
    (~sch_out_fifo_pop_data.hcw_v | sch_out_fifo_pop_data.ldb |
     (sch_out_fifo_pop_data.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0] != sch_sm_dir_cq_q));

// This indicates when the FIFO output contains an interrupt where the interrupt's DIR CQ
// matches the HCW's DIR CQ

assign sch_sm_int_matches_dir_cq = sch_out_fifo_pop_data_v_limited & sch_out_fifo_pop_data.int_v &
    sch_out_fifo_pop_data.hcw_v & ~sch_out_fifo_pop_data.int_d.is_ldb & ~sch_out_fifo_pop_data.ldb &
    (sch_out_fifo_pop_data.int_d.cq_occ_cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0] == sch_out_fifo_pop_data.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0]);

// This indicates when the FIFO output contains an hcw where the hcw's CQ is DIR but
// does not match the DIR CQ for a current optimization.

assign sch_sm_opt_cq_mismatch = sch_out_fifo_pop_data_v_limited & sch_out_fifo_pop_data.hcw_v &
    ~sch_out_fifo_pop_data.ldb & sch_sm_opt_in_prog_q &
    (sch_out_fifo_pop_data.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0] != sch_sm_dir_cq_q);

always_comb begin

 dir_wb0_v_next           = dir_wb0_v_scaled;
 dir_wb1_v_next           = dir_wb1_v_scaled;
 dir_wb2_v_next           = dir_wb2_v_scaled;

 ldb_wb0_v_next           = ldb_wb0_v_scaled;
 ldb_wb1_v_next           = ldb_wb1_v_scaled;
 ldb_wb2_v_next           = ldb_wb2_v_scaled;

 if (cfg_wvalid_q.wb_dir_cq_state & cfg_wdata_clr_wb_cq_state_q) begin
  dir_wb0_v_next[cfg_addr_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
  dir_wb1_v_next[cfg_addr_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
  dir_wb2_v_next[cfg_addr_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
 end

 if (cfg_wvalid_q.wb_ldb_cq_state & cfg_wdata_clr_wb_cq_state_q) begin
  ldb_wb0_v_next[cfg_addr_q[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0;
  ldb_wb1_v_next[cfg_addr_q[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0;
  ldb_wb2_v_next[cfg_addr_q[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0;
 end

 sch_sm_state_next        = sch_sm_state_q;

 sch_sm_dir_addr_next     = sch_sm_dir_addr_q;
 sch_sm_dir_addr_res_next = sch_sm_dir_addr_res_q;
 sch_sm_dir_cq_next       = sch_sm_dir_cq_q;
 sch_sm_dir_data_v_next   = sch_sm_dir_data_v_q;
 sch_sm_dir_ro_next       = sch_sm_dir_ro_q;
 sch_sm_dir_spare_next    = sch_sm_dir_spare_q;
 sch_sm_dir_pasidtlp_next = sch_sm_dir_pasidtlp_q;
 sch_sm_dir_is_pf_next    = sch_sm_dir_is_pf_q;
 sch_sm_dir_vf_next       = sch_sm_dir_vf_q;
 sch_sm_dir_parity_next   = sch_sm_dir_parity_q;
 sch_sm_dir_pad_ok_next   = sch_sm_dir_pad_ok_q;
 sch_sm_dir_gen_next      = sch_sm_dir_gen_q;

 sch_sm_opt_in_prog_next  = sch_sm_opt_in_prog_q;

 sch_sm_drops_next        = '0;
 sch_sm_drops_comp_next   = '0;
 sch_sm_drops_comp_next[HQM_SYSTEM_DIR_CQ_WIDTH-1:0]   = sch_sm_dir_cq_q[HQM_SYSTEM_DIR_CQ_WIDTH-1:0];

 sch_out_fifo_pop         = '0;

 sch_sm_int_v             = '0;
 sch_sm_data_v            = '0;
 sch_sm_sop               = '0;
 sch_sm_eop               = '0;
 sch_sm_error_idv         = '0;
 sch_sm_beats             = '0;
 sch_sm_appended          = '0;
 sch_sm_dsel0             = '0;
 sch_sm_dsel1             = '0;
 sch_sm_ldb               = '0;
 sch_sm_cq                = sch_out_fifo_pop_data.cq;
 sch_sm_cq_addr           = sch_out_fifo_pop_data.cq_addr;
 sch_sm_cq_addr_res       = sch_out_fifo_pop_data.cq_addr_res;
 sch_sm_ro                = sch_out_fifo_pop_data.ro;
 sch_sm_spare             = '0;
 sch_sm_pasidtlp          = sch_out_fifo_pop_data.pasidtlp;
 sch_sm_is_pf             = sch_out_fifo_pop_data.is_pf;
 sch_sm_vf                = sch_out_fifo_pop_data.vf;
 sch_sm_parity            = sch_out_fifo_pop_parity;
 sch_sm_gen               = sch_out_fifo_pop_data.hcw.flags.cq_gen;
 sch_sm_res_adj           = '0;

 for (int i=0; i<4; i=i+1) begin
   memi_dir_wb_next[i]      = '0;
   memi_ldb_wb_next[i]      = '0;
 end
                         
 unique casez (1'b1)

  //---------------------------------------------------------------------------------------------------
  sch_sm_state[`HQM_SYSTEM_SCH_SM_IDLE]: begin

    // Wait until we have something in the FIFO and we're not holding the state machine or pipeline

    if (sch_out_fifo_pop_data_v_limited &
        ~cfg_write_buffer_ctl.HOLD_SCH_SM & ~sch_p0_hold) begin // FIFO valid and pipeline not holding

      if ((sch_out_fifo_perr | (sch_out_fifo_pop_data.error & ~sch_out_fifo_pop_data.int_v)) & ~sch_sm_opt_in_prog_q) begin // Parity error or standalone hcw error w/o current optimization

        // A parity error invalidates the FIFO information, so just throw it away unless we
        // have a currently pending optimization.  If we do, need to assume this bad entry
        // may have referenced the same CQ and need to break the optimization.

        sch_out_fifo_pop   = 1'b1;
        sch_sm_drops_next  = 3'd1;

      end // Parity error

      else if (sch_out_fifo_pop_data.int_v & ~sch_out_fifo_pop_data.hcw_v &
                ~(sch_sm_int_matches_opt & ~cfg_write_buffer_ctl.EARLY_DIR_INT) & ~sch_out_fifo_perr) begin

        // Standalone interrupt case. Send the interrupt and pop the FIFO.

        // Have to ensure this is not an interrupt for a current optimized DIR CQ in progress
        // that we haven't gotten all the data for yet.  If it is, we'll need to break the
        // optimization and force out just what we currently have for the DIR CQ before sending
        // the interrupt down the pipe.

        sch_out_fifo_pop   = 1'b1;
        sch_sm_int_v       = 1'b1;
        sch_sm_drops_next  = {2'd0,sch_out_fifo_pop_data.error};

      end // Standalone interrupt

      else if (sch_out_fifo_pop_data.hcw_v & sch_out_fifo_pop_data.ldb &
                ~(sch_sm_int_matches_opt & ~cfg_write_buffer_ctl.EARLY_DIR_INT) & ~sch_out_fifo_perr & ~sch_out_fifo_pop_data.error) begin // LDB CQ

          // Can just send out a LDB CQ w/ or w/o an attached interrupt
          // Single 32B write with 16B of valid data

          // Have to ensure this is not an interrupt for a current optimized DIR CQ in progress
          // that we haven't gotten all the data for yet.  If it is, we'll need to break the
          // optimization and force out just what we currently have for the DIR CQ before sending
          // the interrupt down the pipe, so the sch_sm_int_matches_opt keeps us from getting
          // here before we do that.

          sch_sm_ldb = 1'b1;

          if (sch_out_fifo_pop_data.pad_ok & ~cfg_write_buffer_ctl.WRITE_SINGLE_BEATS) begin

            // pad_ok is set, so write full cache line out

            sch_sm_data_v       = 1'b1;
            sch_sm_sop          = 1'b1;
            sch_sm_beats        = 3'd4;

            unique casez (sch_out_fifo_pop_data.beat)

              2'd0: begin // {pad, pad, pad, FIFO}

                sch_sm_dsel0              = 3'd3;   // FIFO
                sch_sm_dsel1              = 3'd4;   // FIFO PAD

              end

              2'd1: begin // {pad, pad, FIFO, LDB_WB0}

                memi_ldb_wb_next[0].re    = 1'b1;
                memi_ldb_wb_next[0].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0];

                sch_sm_dsel0              = 3'd0;   // WB0
                sch_sm_dsel1              = 3'd3;   // FIFO

                if ((ldb_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_LDB_WB_V) begin
                  sch_sm_dsel0            = 3'd5;   // ERROR
                end

              end

              default: begin // 2: {pad,  FIFO,    LDB_WB1, LDB_WB0}
                             // 3: {FIFO, LDB_WB2, LDB_WB1, LDB_WB0}

                memi_ldb_wb_next[0].re    = 1'b1;
                memi_ldb_wb_next[0].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0];
                memi_ldb_wb_next[1].re    = 1'b1;
                memi_ldb_wb_next[1].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0];

                sch_sm_dsel0              = 3'd0;   // WB0
                sch_sm_dsel1              = 3'd1;   // WB1

                if ((ldb_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_LDB_WB_V) begin
                  sch_sm_dsel0            = 3'd5;   // ERROR
                end
                if ((ldb_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_LDB_WB_V) begin
                  sch_sm_dsel1            = 3'd5;   // ERROR
                end

              end

            endcase

            sch_sm_state_next = SCH_SM_LDB_PAD;     // Will pop FIFO and handle any interrupt

          end else begin

            // Write single beat w/o padding

            sch_out_fifo_pop  = 1'b1;
            sch_sm_int_v      = sch_out_fifo_pop_data.int_v;

            sch_sm_data_v     = 1'b1;
            sch_sm_sop        = 1'b1;
            sch_sm_eop        = 1'b1;
            sch_sm_beats      = 3'd1;
            sch_sm_dsel0      = 3'd3;   // FIFO
            sch_sm_dsel1      = 3'd6;   // N/A

            if (sch_out_fifo_pop_data.beat==2'd3) begin
              ldb_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
              ldb_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
              ldb_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
            end

          end

          // Always write the beat into the WB for this LDB CQ.  Note that beat 3 is unused.

          memi_ldb_wb_next[sch_out_fifo_pop_data.beat].we    = '1;
          memi_ldb_wb_next[sch_out_fifo_pop_data.beat].waddr =
                sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0];
          memi_ldb_wb_next[sch_out_fifo_pop_data.beat].wdata =
                {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};

          if (sch_out_fifo_pop_data.beat==2'd0) begin
            ldb_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b1 ;
            ldb_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
            ldb_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
          end

          if (sch_out_fifo_pop_data.beat==2'd1) begin
            ldb_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b1 ;
            ldb_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
          end

          if (sch_out_fifo_pop_data.beat==2'd2) begin
            ldb_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b1 ;
          end

      end // LDB CQ

      else if (sch_sm_opt_in_prog_q) begin // DIR CQ Optimization in progress

        // In the middle of a current DIR CQ optimization

        if (sch_sm_opt_cq_mismatch |                                            // Different DIR CQ
                (sch_sm_int_matches_opt & ~cfg_write_buffer_ctl.EARLY_DIR_INT) |// Int on same DIR CQ
                sch_out_fifo_perr | sch_out_fifo_pop_data.error) begin          // FIFO parity error or hcw error

          // Got a new DIR CQ that didn't match the DIR CQ we are currently processing or
          // got an interrupt that matches the DIR CQ we are currently processing.
          // Need to abort the current DIR CQ optimization and send out the data we have saved
          // so far.  Don't pop the input FIFO in this case; we'll process it the next clock.
          // Reset the optimization state. No attached interrupt to worry about.

          sch_sm_cq          = sch_sm_dir_cq_q;
          sch_sm_cq_addr     = sch_sm_dir_addr_q;
          sch_sm_cq_addr_res = sch_sm_dir_addr_res_q;
          sch_sm_ro          = sch_sm_dir_ro_q;
          sch_sm_spare       = sch_sm_dir_spare_q;
          sch_sm_pasidtlp    = sch_sm_dir_pasidtlp_q;
          sch_sm_is_pf       = sch_sm_dir_is_pf_q;
          sch_sm_vf          = sch_sm_dir_vf_q;
          sch_sm_parity      = sch_sm_dir_parity_q;
          sch_sm_gen         = sch_sm_dir_gen_q;
          
          unique casez (sch_sm_dir_data_v_q)
          
            4'b0001: begin 

              // If saved pad_ok write full cache line w/ 16B data else 16B data

              memi_dir_wb_next[0].re      = 1'b1;
              memi_dir_wb_next[0].raddr   = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              sch_sm_dsel0                = 3'd0;         // WB0

              if ((dir_wb0_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel0            = 3'd5;           // ERROR
              end

              if (sch_sm_dir_pad_ok_q) begin              // {pad, pad, pad, DIR_WB0}

                sch_sm_beats              = 3'd4;
                sch_sm_dsel1              = 3'd4;         // DIR PAD
                sch_sm_state_next         = SCH_SM_OPTA;  // No pop or int for this case

              end else begin                              // {N/A, DIR_WB0}

                sch_sm_eop                = 1'b1;
                sch_sm_beats              = 3'd1;
                sch_sm_dsel1              = 3'd6;         // N/A

                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

              end

            end

            4'b0010: begin

              // If saved pad_ok write full cache line w/ 32B data else 16B data

              memi_dir_wb_next[1].re      = 1'b1;
              memi_dir_wb_next[1].raddr   = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;

              if (sch_sm_dir_pad_ok_q) begin              // {pad, pad, DIR_WB1, DIR_WB0}

                memi_dir_wb_next[0].re    = 1'b1;
                memi_dir_wb_next[0].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_beats              = 3'd4;
                sch_sm_dsel0              = 3'd0;         // WB0
                sch_sm_dsel1              = 3'd1;         // WB1
                sch_sm_state_next         = SCH_SM_OPTA;  // No pop or int for this case

                if ((dir_wb0_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;         // ERROR
                end
                if ((dir_wb1_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;         // ERROR
                end

              end else begin                              // {N/A, DIR_WB1}

                sch_sm_eop                = 1'b1;
                sch_sm_beats              = 3'd1;
                sch_sm_dsel0              = 3'd1;         // WB1
                sch_sm_dsel1              = 3'd6;         // N/A

                if ((dir_wb1_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;         // ERROR
                end

                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

              end

            end

            4'b0100: begin

              // If saved pad_ok write full cache line w/ 48B data else 16B data

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;

              if (sch_sm_dir_pad_ok_q) begin              // {pad, DIR_WB2, DIR_WB1, DIR_WB0}

                memi_dir_wb_next[0].re    = 1'b1;
                memi_dir_wb_next[0].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
                memi_dir_wb_next[1].re    = 1'b1;
                memi_dir_wb_next[1].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_beats              = 3'd4;
                sch_sm_dsel0              = 3'd0;         // WB0
                sch_sm_dsel1              = 3'd1;         // WB1
                sch_sm_state_next         = SCH_SM_OPTA;  // No pop or int for this case

                if ((dir_wb0_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;         // ERROR
                end
                if ((dir_wb1_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;         // ERROR
                end
              end else begin                              // {N/A, DIR_WB2}

                memi_dir_wb_next[2].re    = 1'b1;
                memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_eop                = 1'b1;
                sch_sm_beats              = 3'd1;
                sch_sm_dsel0              = 3'd2;         // WB2
                sch_sm_dsel1              = 3'd6;         // N/A

                if ((dir_wb2_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;         // ERROR
                end

                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

              end

            end

            4'b0011: begin

              // If saved pad_ok write full cache line w/ 32B data else 32B data

              memi_dir_wb_next[0].re      = 1'b1;
              memi_dir_wb_next[0].raddr   = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[1].re      = 1'b1;
              memi_dir_wb_next[1].raddr   = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              sch_sm_dsel0                = 3'd0;         // WB0
              sch_sm_dsel1                = 3'd1;         // WB1

              if ((dir_wb0_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel0              = 3'd5;         // ERROR
              end
              if ((dir_wb1_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel1              = 3'd5;         // ERROR
              end

              if (sch_sm_dir_pad_ok_q) begin              // {pad, pad, DIR_WB1, DIR_WB0}

                sch_sm_beats              = 3'd4;
                sch_sm_state_next         = SCH_SM_OPTA;  // No pop or int for this case

              end else begin                              // {DIR_WB1, DIR_WB0}

                sch_sm_eop                = 1'b1;
                sch_sm_beats              = 3'd2;
                sch_sm_appended           = 2'd1;

                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

              end

            end

            4'b0110: begin

              // If saved pad_ok write full cache line w/ 32B data else 32B data

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              memi_dir_wb_next[1].re      = 1'b1;
              memi_dir_wb_next[1].raddr   = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

              if (sch_sm_dir_pad_ok_q) begin              // {pad, DIR_WB2, DIR_WB1, DIR_WB0}

                memi_dir_wb_next[0].re    = 1'b1;
                memi_dir_wb_next[0].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_beats              = 3'd4;
                sch_sm_dsel0              = 3'd0;         // WB0
                sch_sm_dsel1              = 3'd1;         // WB1
                sch_sm_state_next         = SCH_SM_OPTA;  // No pop or int for this case

                if ((dir_wb0_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;         // ERROR
                end
                if ((dir_wb1_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;         // ERROR
                end

              end else begin                              // {DIR_WB2, DIR_WB1}

                memi_dir_wb_next[2].re    = 1'b1;
                memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_eop                = 1'b1;
                sch_sm_dsel0              = 3'd1;         // WB1
                sch_sm_dsel1              = 3'd2;         // WB2
                sch_sm_beats              = 3'd2;
                sch_sm_appended           = 2'd1;

                if ((dir_wb1_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;         // ERROR
                end
                if ((dir_wb2_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;         // ERROR
                end

                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

              end

            end

            4'b0111:begin

              // If saved pad_ok write full cache line w/ 48B data else 48B data

              memi_dir_wb_next[0].re      = 1'b1;
              memi_dir_wb_next[0].raddr   = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[1].re      = 1'b1;
              memi_dir_wb_next[1].raddr   = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              sch_sm_dsel0                = 3'd0;         // WB0
              sch_sm_dsel1                = 3'd1;         // WB1
              sch_sm_beats                = (sch_sm_dir_pad_ok_q) ? 3'd4 : 3'd3; 
              sch_sm_state_next           = SCH_SM_OPTA;  // No pop or int for this case

              if ((dir_wb0_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel0              = 3'd5;         // ERROR
              end
              if ((dir_wb1_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel1              = 3'd5;         // ERROR
              end

            end

            default:begin  // Send no data

              sch_sm_error_idv         = 1'b1;   // Invalid beat valid state

              // Need to account for any HCWs we're throwing away
                     
              sch_sm_drops_next        = {2'd0, sch_sm_dir_data_v_q[0]} +
                                         {2'd0, sch_sm_dir_data_v_q[1]} +
                                         {2'd0, sch_sm_dir_data_v_q[2]} +
                                         {2'd0, sch_sm_dir_data_v_q[3]};

              sch_sm_dir_data_v_next   = '0;
              sch_sm_opt_in_prog_next  = '0;
              sch_sm_dir_pad_ok_next   = '0;

              dir_wb0_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
              dir_wb1_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
              dir_wb2_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
            end

          endcase // sch_sm_dir_data_v_q

        end // Different DIR CQ or int on same DIR CQ or FIFO parity error

        else if ((sch_out_fifo_pop_data.wbo == 2'd0) |  // Last beat of optimization
                 (sch_sm_int_matches_dir_cq &           // Int for same DIR CQ on any beat
                  ~cfg_write_buffer_ctl.EARLY_DIR_INT)) begin

          // Last beat of an optimized DIR CQ w/ or w/o an attached interrupt -or-
          // Not the last beat and there is an attached interrupt for the same DIR CQ

          sch_sm_cq          = sch_sm_dir_cq_q;
          sch_sm_cq_addr     = sch_sm_dir_addr_q;
          sch_sm_cq_addr_res = sch_sm_dir_addr_res_q;
          sch_sm_ro          = sch_sm_dir_ro_q;
          sch_sm_spare       = sch_sm_dir_spare_q;
          sch_sm_pasidtlp    = sch_sm_dir_pasidtlp_q;
          sch_sm_is_pf       = sch_sm_dir_is_pf_q;
          sch_sm_vf          = sch_sm_dir_vf_q;
          sch_sm_parity      = sch_sm_dir_parity_q;
          sch_sm_gen         = sch_sm_dir_gen_q;

          // Send an attached interrupt down the pipe only if we're popping the FIFO
          // for a valid case.
          
          unique casez (sch_sm_dir_data_v_q)
          
            4'b0001: begin

              // If pad_ok write full cache line w/ 32B data else write 32B data

              memi_dir_wb_next[0].re      = 1'b1;
              memi_dir_wb_next[0].raddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[1].we      = 1'b1;
              memi_dir_wb_next[1].waddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[1].wdata   = {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};

              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              sch_sm_dsel0                = 3'd0;             // WB0
              sch_sm_dsel1                = 3'd3;             // FIFO

              if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel0              = 3'd5;             // ERROR
              end

              if (sch_out_fifo_pop_data.pad_ok | sch_sm_dir_pad_ok_q) begin
                                                              // {pad, pad, FIFO, DIR_WB0}

                sch_sm_beats              = 3'd4;

                sch_sm_state_next         = SCH_SM_DIR_PAD;   // Will pop FIFO and handle interrupt
          
              end else begin                                  // {FIFO, DIR_WB0}

                sch_sm_eop                = 1'b1;
                sch_sm_beats              = 3'd2;
                sch_sm_appended           = 2'd1;

                sch_out_fifo_pop          = 1'b1;
                sch_sm_int_v              = sch_out_fifo_pop_data.int_v;

                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

              end

            end

            4'b0010: begin

              // If pad_ok write full cache line w/ 48B data else write 32B data

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              memi_dir_wb_next[2].we      = 1'b1;
              memi_dir_wb_next[2].waddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[2].wdata   = {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};

              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;

              if (sch_out_fifo_pop_data.pad_ok | sch_sm_dir_pad_ok_q) begin
                                                              // {pad, FIFO, DIR_WB1, DIR_WB0}

                memi_dir_wb_next[0].re    = 1'b1;
                memi_dir_wb_next[0].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
                memi_dir_wb_next[1].re    = 1'b1;
                memi_dir_wb_next[1].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_beats              = 3'd4;
                sch_sm_dsel0              = 3'd0;             // WB0
                sch_sm_dsel1              = 3'd1;             // WB1
                sch_sm_state_next         = SCH_SM_DIR_PAD;   // Will pop FIFO and handle interrupt

                if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;             // ERROR
                end
          
                if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;             // ERROR
                end
          
              end else begin                                  // {FIFO, DIR_WB1}

                memi_dir_wb_next[1].re    = 1'b1;
                memi_dir_wb_next[1].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_eop                = 1'b1;
                sch_sm_beats              = 3'd2;
                sch_sm_dsel0              = 3'd1;             // WB1
                sch_sm_dsel1              = 3'd3;             // FIFO
                sch_sm_appended           = 2'd1;

                if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;             // ERROR
                end
          
                sch_out_fifo_pop          = 1'b1;
                sch_sm_int_v              = sch_out_fifo_pop_data.int_v;
          
                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

              end

            end

            4'b0011: begin

              // If pad_ok write full cache line w/ 48B data else write 48B data

              memi_dir_wb_next[0].re      = 1'b1;
              memi_dir_wb_next[0].raddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[1].re      = 1'b1;
              memi_dir_wb_next[1].raddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[2].we      = 1'b1;
              memi_dir_wb_next[2].waddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[2].wdata   = {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};

              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              sch_sm_dsel0                = 3'd0;             // WB0
              sch_sm_dsel1                = 3'd1;             // WB1

              if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel0              = 3'd5;             // ERROR
              end
          
              if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel1              = 3'd5;             // ERROR
              end

              if (sch_out_fifo_pop_data.pad_ok | sch_sm_dir_pad_ok_q) begin
                                                              // {pad, FIFO, DIR_WB1, DIR_WB0}

                sch_sm_beats              = 3'd4;
                sch_sm_state_next         = SCH_SM_DIR_PAD;   // Will pop FIFO and handle interrupt

              end else begin                                  // {N/A, FIFO, DIR_WB1, DIR_WB0}

                sch_sm_beats              = 3'd3;
                sch_sm_state_next         = SCH_SM_DIR;       // Will pop FIFO and handle interrupt

              end

            end

            4'b0100: begin

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;

              if (sch_out_fifo_pop_data.pad_ok | sch_sm_dir_pad_ok_q) begin
                                                              // {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}

                memi_dir_wb_next[0].re    = 1'b1;
                memi_dir_wb_next[0].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
                memi_dir_wb_next[1].re    = 1'b1;
                memi_dir_wb_next[1].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_beats              = 3'd4;
                sch_sm_dsel0              = 3'd0;             // WB0
                sch_sm_dsel1              = 3'd1;             // WB1

                if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;             // ERROR
                end
          
                if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;             // ERROR
                end
                sch_sm_state_next         = SCH_SM_DIR_PAD;   // Will pop FIFO and handle interrupt

              end else begin                                  // {FIFO, DIR_WB2}

                memi_dir_wb_next[2].re    = 1'b1;
                memi_dir_wb_next[2].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_eop                = 1'b1;
                sch_sm_beats              = 3'd2;
                sch_sm_dsel0              = 3'd2;             // WB2
                sch_sm_dsel1              = 3'd3;             // FIFO
                sch_sm_appended           = 2'd1;

                if ((dir_wb2_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;             // ERROR
                end

                sch_out_fifo_pop          = 1'b1;
                sch_sm_int_v              = sch_out_fifo_pop_data.int_v;

                sch_sm_dir_data_v_next    = '0;
                sch_sm_opt_in_prog_next   = '0;
                sch_sm_dir_pad_ok_next    = '0;

                dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
                dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
                dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
              end

            end

            4'b0110: begin

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;

              if (sch_out_fifo_pop_data.pad_ok | sch_sm_dir_pad_ok_q) begin
                                                              // {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}

                memi_dir_wb_next[0].re    = 1'b1;
                memi_dir_wb_next[0].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
                memi_dir_wb_next[1].re    = 1'b1;
                memi_dir_wb_next[1].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_beats              = 3'd4;
                sch_sm_dsel0              = 3'd0;             // WB0
                sch_sm_dsel1              = 3'd1;             // WB1

                if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;             // ERROR
                end
          
                if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;             // ERROR
                end

                sch_sm_state_next         = SCH_SM_DIR_PAD;   // Will pop FIFO and handle interrupt

              end else begin                                  // {N/A, FIFO, DIR_WB2, DIR_WB1}

                memi_dir_wb_next[1].re    = 1'b1;
                memi_dir_wb_next[1].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
                memi_dir_wb_next[2].re    = 1'b1;
                memi_dir_wb_next[2].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                sch_sm_beats              = 3'd3;
                sch_sm_dsel0              = 3'd1;             // WB1
                sch_sm_dsel1              = 3'd2;             // WB2

                if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel0            = 3'd5;             // ERROR
                end
          
                if ((dir_wb2_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                    ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                  sch_sm_dsel1            = 3'd5;             // ERROR
                end

                sch_sm_state_next         = SCH_SM_DIR;       // Will pop FIFO and handle interrupt

              end

            end

            4'b0111: begin

              // Always write full cache line w/ 64B data {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}

              memi_dir_wb_next[0].re      = 1'b1;
              memi_dir_wb_next[0].raddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
              memi_dir_wb_next[1].re      = 1'b1;
              memi_dir_wb_next[1].raddr   = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

              sch_sm_data_v               = 1'b1;
              sch_sm_sop                  = 1'b1;
              sch_sm_beats                = 3'd4;
              sch_sm_dsel0                = 3'd0;             // WB0
              sch_sm_dsel1                = 3'd1;             // WB1

              if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel0              = 3'd5;             // ERROR
              end
          
              if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel1              = 3'd5;             // ERROR
              end

              sch_sm_state_next           = SCH_SM_DIR;       // Will pop FIFO and handle interrupt

            end

            default:begin  // Send no data

              // Invalid beat valid state
              // Throw away the transaction by popping the current beat and resetting
              // the optimization state.

              sch_sm_error_idv         = 1'b1;
              sch_out_fifo_pop         = 1'b1;

              // Any attached interrupt still needs to be sent down the pipe.

              sch_sm_int_v             = sch_out_fifo_pop_data.int_v;

              // Need to account for any HCWs we're throwing away
                     
              sch_sm_drops_next        = 3'd1 +
                                         {2'd0, sch_sm_dir_data_v_q[0]} +
                                         {2'd0, sch_sm_dir_data_v_q[1]} +
                                         {2'd0, sch_sm_dir_data_v_q[2]} +
                                         {2'd0, sch_sm_dir_data_v_q[3]};

              sch_sm_dir_data_v_next   = '0;
              sch_sm_opt_in_prog_next  = '0;
              sch_sm_dir_pad_ok_next   = '0;

              dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0 ;
            end

          endcase // sch_sm_dir_data_v_q

        end // Last beat of optimization

        else begin // Not last beat of optimization

          // Another (not last) beat of an optimized DIR CQ w/ or w/o an attached interrupt
          // Any attached interrupt still needs to be sent down the pipe.

          sch_sm_int_v    = sch_out_fifo_pop_data.int_v;

          // Write the current beat into the DIR WB, update the DIR CQ optimization state,
          // pop the FIFO, and send any attached interrupt down the pipe.

          memi_dir_wb_next[sch_out_fifo_pop_data.beat].we    = '1;
          memi_dir_wb_next[sch_out_fifo_pop_data.beat].waddr =
              sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
          memi_dir_wb_next[sch_out_fifo_pop_data.beat].wdata =
              {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};

          if (sch_out_fifo_pop_data.beat==2'd0) begin
            dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
            dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
          end

          if (sch_out_fifo_pop_data.beat==2'd1) begin
            dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
            dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
          end

          if (sch_out_fifo_pop_data.beat==2'd2) begin
            dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
          end

          sch_sm_dir_data_v_next[sch_out_fifo_pop_data.beat] = 1'b1;

          // Update the pad_ok and gen bits on any intermediate beat

          if (sch_out_fifo_pop_data.pad_ok) sch_sm_dir_pad_ok_next = 1'b1;
          sch_sm_dir_gen_next      = sch_out_fifo_pop_data.hcw.flags.cq_gen;

          sch_out_fifo_pop         = 1'b1;
          sch_sm_int_v             = sch_out_fifo_pop_data.int_v;

        end // Not last beat of optimization

      end // DIR CQ Optimization in progress

      else begin // No optimization in progress

        // No current DIR CQ optimization

        // If there is an attached interrupt and it is for the same DIR CQ, then we
        // should not set the optimization and treat it as a single beat case.

        if (sch_out_fifo_pop_data.int_v & ~sch_out_fifo_pop_data.hcw_v) begin // Standalone int

          sch_out_fifo_pop = 1'b1;
          sch_sm_int_v     = 1'b1;

        end // Standalone int

        else if (sch_out_fifo_pop_data.hcw_v) begin // HCW valid

          if (cfg_write_buffer_ctl.WRITE_SINGLE_BEATS) begin // Force Single beat
          
            // Forced single beat DIR CQ
            // Sending only a single 32B write with 16B of valid data
          
            sch_out_fifo_pop         = 1'b1;
            sch_sm_int_v             = sch_out_fifo_pop_data.int_v;
                                    
            sch_sm_data_v            = 1'b1;
            sch_sm_sop               = 1'b1;
            sch_sm_eop               = 1'b1;
            sch_sm_beats             = 3'd1;
            sch_sm_dsel0             = 3'd3;             // FIFO
            sch_sm_dsel1             = 3'd6;             // N/A

            sch_sm_dir_cq_next       = sch_out_fifo_pop_data.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0];
            sch_sm_dir_addr_next     = sch_out_fifo_pop_data.cq_addr;
            sch_sm_dir_addr_res_next = sch_out_fifo_pop_data.cq_addr_res;
            sch_sm_dir_ro_next       = sch_out_fifo_pop_data.ro;
            sch_sm_dir_spare_next    = '0;
            sch_sm_dir_pasidtlp_next = sch_out_fifo_pop_data.pasidtlp;
            sch_sm_dir_is_pf_next    = sch_out_fifo_pop_data.is_pf;
            sch_sm_dir_vf_next       = sch_out_fifo_pop_data.vf;
            sch_sm_dir_gen_next      = sch_out_fifo_pop_data.hcw.flags.cq_gen;
            sch_sm_dir_parity_next   = sch_out_fifo_pop_parity;

            memi_dir_wb_next[sch_out_fifo_pop_data.beat].we    = '1;
            memi_dir_wb_next[sch_out_fifo_pop_data.beat].waddr =
                sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
            memi_dir_wb_next[sch_out_fifo_pop_data.beat].wdata =
                {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};

            if (sch_out_fifo_pop_data.beat==2'd0) begin
              dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

            if (sch_out_fifo_pop_data.beat==2'd1) begin
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

            if (sch_out_fifo_pop_data.beat==2'd2) begin
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
            end

            if (sch_out_fifo_pop_data.beat==2'd3) begin
              dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

          end // Force Single beat

          else if ((sch_out_fifo_pop_data.wbo == 2'd0) |
            (sch_sm_int_matches_dir_cq & ~cfg_write_buffer_ctl.EARLY_DIR_INT)) begin // Single beat
          
            // Single beat DIR CQ
            // Sending only a single 32B write with 16B of valid data if not padded

            sch_sm_data_v            = 1'b1;
            sch_sm_sop               = 1'b1;

            sch_sm_dir_cq_next       = sch_out_fifo_pop_data.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0];
            sch_sm_dir_addr_next     = sch_out_fifo_pop_data.cq_addr;
            sch_sm_dir_addr_res_next = sch_out_fifo_pop_data.cq_addr_res;
            sch_sm_dir_ro_next       = sch_out_fifo_pop_data.ro;
            sch_sm_dir_spare_next    = '0;
            sch_sm_dir_pasidtlp_next = sch_out_fifo_pop_data.pasidtlp;
            sch_sm_dir_is_pf_next    = sch_out_fifo_pop_data.is_pf;
            sch_sm_dir_vf_next       = sch_out_fifo_pop_data.vf;
            sch_sm_dir_gen_next      = sch_out_fifo_pop_data.hcw.flags.cq_gen;
            sch_sm_dir_parity_next   = sch_out_fifo_pop_parity;
            sch_sm_dir_pad_ok_next   = sch_out_fifo_pop_data.pad_ok;

            if (sch_out_fifo_pop_data.pad_ok) begin

              sch_sm_beats      = 3'd4;

              unique casez (sch_out_fifo_pop_data.beat)

                2'd0: begin                             // {pad,  pad,     pad,     FIFO}

                  sch_sm_dsel0              = 3'd3;     // FIFO
                  sch_sm_dsel1              = 3'd4;     // FIFO PAD

                end

                2'd1: begin                             // {pad,  pad,     FIFO,    DIR_WB0}

                  memi_dir_wb_next[0].re    = 1'b1;
                  memi_dir_wb_next[0].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                  sch_sm_dsel0              = 3'd0;     // WB0
                  sch_sm_dsel1              = 3'd3;     // FIFO

                  if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                      ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                    sch_sm_dsel0            = 3'd5;     // ERROR
                  end
           
                end

                default: begin                          // 2: {pad,  FIFO,    DIR_WB1, DIR_WB0}
                                                        // 3: {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}
                  memi_dir_wb_next[0].re    = 1'b1;
                  memi_dir_wb_next[0].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
                  memi_dir_wb_next[1].re    = 1'b1;
                  memi_dir_wb_next[1].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

                  sch_sm_dsel0              = 3'd0;     // WB0
                  sch_sm_dsel1              = 3'd1;     // WB1

                  if ((dir_wb0_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                      ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                    sch_sm_dsel0            = 3'd5;     // ERROR
                  end

                  if ((dir_wb1_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                      ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                    sch_sm_dsel1            = 3'd5;     // ERROR
                  end
                end

              endcase

              sch_sm_state_next = SCH_SM_DIR_PAD;       // Will pop FIFO and handle interrupt

            end else begin

              sch_out_fifo_pop  = 1'b1;
              sch_sm_int_v      = sch_out_fifo_pop_data.int_v;

              sch_sm_eop        = 1'b1;
              sch_sm_beats      = 3'd1;
              sch_sm_dsel0      = 3'd3;             // FIFO
              sch_sm_dsel1      = 3'd6;             // N/A

              if (sch_out_fifo_pop_data.beat==2'd3) begin
                dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
                dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
                dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              end

            end

            memi_dir_wb_next[sch_out_fifo_pop_data.beat].we    = '1;
            memi_dir_wb_next[sch_out_fifo_pop_data.beat].waddr =
                sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
            memi_dir_wb_next[sch_out_fifo_pop_data.beat].wdata =
                {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};
          
            if (sch_out_fifo_pop_data.beat==2'd0) begin
              dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

            if (sch_out_fifo_pop_data.beat==2'd1) begin
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

            if (sch_out_fifo_pop_data.beat==2'd2) begin
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
            end

          end // Single beat

          else begin // Optimization start

            // More than 1 beat expected, set the optimized indication.
            // Save the header info from this beat

            sch_sm_opt_in_prog_next  = 1'b1;

            sch_out_fifo_pop         = 1'b1;
            sch_sm_int_v             = sch_out_fifo_pop_data.int_v;

            sch_sm_dir_cq_next       = sch_out_fifo_pop_data.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0];
            sch_sm_dir_addr_next     = sch_out_fifo_pop_data.cq_addr;
            sch_sm_dir_addr_res_next = sch_out_fifo_pop_data.cq_addr_res;
            sch_sm_dir_ro_next       = sch_out_fifo_pop_data.ro;
            sch_sm_dir_spare_next    = '0;
            sch_sm_dir_pasidtlp_next = sch_out_fifo_pop_data.pasidtlp;
            sch_sm_dir_is_pf_next    = sch_out_fifo_pop_data.is_pf;
            sch_sm_dir_vf_next       = sch_out_fifo_pop_data.vf;
            sch_sm_dir_pad_ok_next   = sch_out_fifo_pop_data.pad_ok;
            sch_sm_dir_gen_next      = sch_out_fifo_pop_data.hcw.flags.cq_gen;
            sch_sm_dir_parity_next   = sch_out_fifo_pop_parity;

            // First beat of multiple beat DIR CQ. Save the beat.

            memi_dir_wb_next[sch_out_fifo_pop_data.beat].we    = '1;
            memi_dir_wb_next[sch_out_fifo_pop_data.beat].waddr =
                  sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];
            memi_dir_wb_next[sch_out_fifo_pop_data.beat].wdata =
                  {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};

            if (sch_out_fifo_pop_data.beat==2'd0) begin
              dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

            if (sch_out_fifo_pop_data.beat==2'd1) begin
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

            if (sch_out_fifo_pop_data.beat==2'd2) begin
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b1;
            end

            if (sch_out_fifo_pop_data.beat==2'd3) begin
              dir_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

            sch_sm_dir_data_v_next[sch_out_fifo_pop_data.beat] = 1'b1;
           
          end // Optimization start

        end // HCW valid

      end // No optimization in progress

    end // Not holding

  end // HQM_SYSTEM_SCH_SM_IDLE

  //---------------------------------------------------------------------------------------------------
  sch_sm_state[`HQM_SYSTEM_SCH_SM_LDB_PAD]: begin

    // Get to this state when we need to write the second word for a padded LDB CQ.
    // Send it out, pop the FIFO and return to IDLE.

    // Wait until the pipeline is not holding

    if (~sch_p0_hold) begin // Not holding

      sch_out_fifo_pop    = 1'b1;
      sch_sm_int_v        = sch_out_fifo_pop_data.int_v;

      sch_sm_ldb          = 1'b1;
      sch_sm_data_v       = 1'b1;
      sch_sm_eop          = 1'b1;
      sch_sm_beats        = 3'd4; 

      // Force address to start of cache line and adjust the residue

      sch_sm_cq_addr[5:4] = 2'd0;
      sch_sm_res_adj      = (&sch_out_fifo_pop_data.cq_addr[5:4]) ? 2'd0 :
                              sch_out_fifo_pop_data.cq_addr[5:4];

      unique casez (sch_out_fifo_pop_data.beat)

        2'd3: begin                             // {FIFO, LDB_WB2, LDB_WB1, LDB_WB0}

          memi_ldb_wb_next[2].re    = 1'b1;
          memi_ldb_wb_next[2].raddr = sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0];

          sch_sm_dsel0    = 3'd2;               // WB2
          sch_sm_dsel1    = 3'd3;               // FIFO

          ldb_wb0_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
          ldb_wb1_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;
          ldb_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b0 ;

          if ((ldb_wb2_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]]==1'b0) &
              ~cfg_write_buffer_ctl.IGNORE_LDB_WB_V) begin
            sch_sm_dsel0  = 3'd5;               // ERROR
          end
        end

        2'd2: begin                             // {PAD, FIFO, LDB_WB1, LDB_WB0}
          sch_sm_dsel0    = 3'd3;               // FIFO
          sch_sm_dsel1    = 3'd4;               // FIFO PAD
          ldb_wb2_v_next[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_LDB_WB-1:0]] = 1'b1 ;
        end

        default: begin                          // {PAD, PAD, PAD,  FIFO}
                                                // {PAD, PAD, FIFO, LDB_CQ0}
          sch_sm_dsel0    = 3'd4;               // FIFO PAD
          sch_sm_dsel1    = 3'd4;               // FIFO PAD
        end

      endcase

      sch_sm_state_next  = SCH_SM_IDLE;

    end // Not holding

  end // HQM_SYSTEM_SCH_SM_LDB_PAD

  //---------------------------------------------------------------------------------------------------
  sch_sm_state[`HQM_SYSTEM_SCH_SM_DIR]: begin

    // Get to this state when the FIFO has the last beat of an optimized DIR CQ and we need to write
    // a second word for the non-padded cases.  Need to pop the FIFO, send out any attached interrupt,
    // and go back to IDLE.

    // Wait until the pipeline is not holding

    if (~sch_p0_hold) begin // Not holding

      sch_sm_data_v                 = 1'b1;
      sch_sm_eop                    = 1'b1;
                                   
      sch_out_fifo_pop              = 1'b1;
      sch_sm_int_v                  = sch_out_fifo_pop_data.int_v;
                              
      sch_sm_cq_addr                = sch_sm_dir_addr_q;
      sch_sm_cq_addr_res            = sch_sm_dir_addr_res_q;
      sch_sm_ro                     = sch_sm_dir_ro_q;
      sch_sm_spare                  = sch_sm_dir_spare_q;
      sch_sm_pasidtlp               = sch_sm_dir_pasidtlp_q;
      sch_sm_is_pf                  = sch_sm_dir_is_pf_q;
      sch_sm_vf                     = sch_sm_dir_vf_q;
      sch_sm_parity                 = sch_sm_dir_parity_q;
      sch_sm_gen                    = sch_sm_dir_gen_q;

      unique casez (sch_sm_dir_data_v_q)

        4'b0011,        // {N/A, FIFO, DIR_WB1, DIR_WB0}
        4'b0110: begin  // {N/A, FIFO, DIR_WB2, DIR_WB1}

          sch_sm_beats              = 3'd3;
          sch_sm_dsel0              = 3'd3;      // FIFO
          sch_sm_dsel1              = 3'd6;      // N/A
          sch_sm_appended           = 2'd2;

          if (sch_sm_dir_data_v_q==4'b0110) begin
            dir_wb0_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            dir_wb1_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            dir_wb2_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
          end

        end

        default: begin  // 4'b0111 {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}

          memi_dir_wb_next[2].re    = 1'b1;
          memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

          sch_sm_beats              = 3'd4;
          sch_sm_dsel0              = 3'd2;      // DIR WB2
          sch_sm_dsel1              = 3'd3;      // FIFO
          sch_sm_appended           = 2'd3;

          if ((dir_wb2_v_scaled[sch_out_fifo_pop_data.cq[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
              ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
            sch_sm_dsel0            = 3'd5;     // ERROR
          end

          dir_wb0_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
          dir_wb1_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
          dir_wb2_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;

        end

      endcase

      sch_sm_dir_data_v_next  = '0;
      sch_sm_opt_in_prog_next = '0;
      sch_sm_dir_pad_ok_next  = '0;
                                    
      sch_sm_state_next       = SCH_SM_IDLE;

    end // Not holding

  end // HQM_SYSTEM_SCH_SM_DIR

  //---------------------------------------------------------------------------------------------------
  sch_sm_state[`HQM_SYSTEM_SCH_SM_DIR_PAD]: begin

    // Get to this state when the FIFO has the last beat of an optimized DIR CQ and we need to write
    // a second word for the padded cases.  Need to pop the FIFO, send out any attached interrupt,
    // and go back to IDLE.

    // Wait until the pipeline is not holding

    if (~sch_p0_hold) begin // Not holding

      sch_sm_data_v       = 1'b1;
      sch_sm_eop          = 1'b1;
      sch_sm_beats        = 3'd4;
                          
      sch_out_fifo_pop    = 1'b1;
      sch_sm_int_v        = sch_out_fifo_pop_data.int_v;

      sch_sm_cq_addr      = sch_sm_dir_addr_q;
      sch_sm_cq_addr_res  = sch_sm_dir_addr_res_q;
      sch_sm_ro           = sch_sm_dir_ro_q;
      sch_sm_spare        = sch_sm_dir_spare_q;
      sch_sm_pasidtlp     = sch_sm_dir_pasidtlp_q;
      sch_sm_is_pf        = sch_sm_dir_is_pf_q;
      sch_sm_vf           = sch_sm_dir_vf_q;
      sch_sm_parity       = sch_sm_dir_parity_q;
      sch_sm_gen          = sch_sm_dir_gen_q;

      // Force address to start of cache line and adjust the residue

      sch_sm_cq_addr[5:4] = 2'd0;
      sch_sm_res_adj      = (&sch_sm_dir_addr_q[5:4]) ? 2'd0 :
                              sch_sm_dir_addr_q[5:4];

      unique casez (sch_sm_dir_data_v_q)

        4'b0000: begin  // Non-optimized: No saved beat case

          unique casez (sch_out_fifo_pop_data.beat)

            2'd0,           // {pad,  pad,     pad,     FIFO}
            2'd1: begin     // {pad,  pad,     FIFO,    DIR_WB0}

              sch_sm_dsel0              = 3'd4;     // FIFO PAD
              sch_sm_dsel1              = 3'd4;     // FIFO PAD

            end

            2'd2: begin     // {pad,  FIFO,    DIR_WB1, DIR_WB0}

              sch_sm_dsel0              = 3'd3;     // FIFO
              sch_sm_dsel1              = 3'd4;     // FIFO PAD

            end

            default: begin  // {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}

              memi_dir_wb_next[2].re    = 1'b1;
              memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

              sch_sm_dsel0              = 3'd2;     // WB2
              sch_sm_dsel1              = 3'd3;     // FIFO

              if ((dir_wb2_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                  ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
                sch_sm_dsel0            = 3'd5;     // ERROR
              end

              dir_wb0_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb1_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
              dir_wb2_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
            end

          endcase

        end

        4'b0001: begin  // {pad, pad, FIFO, DIR_WB0}

          sch_sm_dsel0              = 3'd4;     // FIFO PAD
          sch_sm_dsel1              = 3'd4;     // FIFO PAD
          sch_sm_appended           = 2'd1;

        end

        4'b0010,        // {pad, FIFO, DIR_WB1, DIR_WB0}
        4'b0011: begin  // {pad, FIFO, DIR_WB1, DIR_WB0}

          memi_dir_wb_next[2].re    = 1'b1;
          memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

          sch_sm_dsel0              = 3'd3;     // FIFO
          sch_sm_dsel1              = 3'd4;     // FIFO PAD
          sch_sm_appended           = {sch_sm_dir_data_v_q[0], ~sch_sm_dir_data_v_q[0]};

        end

        default: begin  // 4'b0100 {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}
                        // 4'b0110 {FIFO, DIR_WB2, DIR_WB1, DIR_WB0}

          memi_dir_wb_next[2].re    = 1'b1;
          memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

          sch_sm_dsel0              = 3'd2;     // DIR WB2
          sch_sm_dsel1              = 3'd3;     // FIFO
          sch_sm_appended           = {sch_sm_dir_data_v_q[1], ~sch_sm_dir_data_v_q[1]};

          if ((dir_wb2_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
              ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
            sch_sm_dsel0            = 3'd5;     // ERROR
          end

          dir_wb0_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
          dir_wb1_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;
          dir_wb2_v_next[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]] = 1'b0;

        end

      endcase

      sch_sm_dir_data_v_next  = '0;
      sch_sm_opt_in_prog_next = '0;
      sch_sm_dir_pad_ok_next  = '0;
                                    
      sch_sm_state_next       = SCH_SM_IDLE;

    end // Not holding

  end // HQM_SYSTEM_SCH_SM_DIR_PAD

  //---------------------------------------------------------------------------------------------------
  sch_sm_state[`HQM_SYSTEM_SCH_SM_OPTA]: begin

    // Get to this state only when aborting a current DIR CQ optimization and we need to write a
    // second word.  This only occurs for the padded cases which are all full cache line writes
    // or the non-padded 3 beat case.
    // Since it is only using the saved DIR CQ data and not consuming the FIFO, there is no FIFO pop
    // or interrupt to worry about.
    // Just send it out and return to IDLE.

    // Wait until the pipeline is not holding

    if (~sch_p0_hold) begin // Not holding

      sch_sm_data_v                 = 1'b1;
      sch_sm_eop                    = 1'b1;
                                   
      sch_sm_cq                     = sch_sm_dir_cq_q;
      sch_sm_cq_addr                = sch_sm_dir_addr_q;
      sch_sm_cq_addr_res            = sch_sm_dir_addr_res_q;
      sch_sm_ro                     = sch_sm_dir_ro_q;
      sch_sm_spare                  = sch_sm_dir_spare_q;
      sch_sm_pasidtlp               = sch_sm_dir_pasidtlp_q;
      sch_sm_is_pf                  = sch_sm_dir_is_pf_q;
      sch_sm_vf                     = sch_sm_dir_vf_q;
      sch_sm_parity                 = sch_sm_dir_parity_q;
      sch_sm_gen                    = sch_sm_dir_gen_q;

      unique casez (sch_sm_dir_data_v_q)

        4'b0001,        // {pad, pad, pad,     DIR_WB0} had to have been a padded case
        4'b0010,        // {pad, pad, DIR_WB1, DIR_WB0} had to have been a padded case
        4'b0011: begin  // {pad, pad, DIR_WB1, DIR_WB0} had to have been a padded case

          sch_sm_beats              = 3'd4;
          sch_sm_dsel0              = 3'd4;      // DIR PAD
          sch_sm_dsel1              = 3'd4;      // DIR PAD
          sch_sm_appended           = {1'd0, (&sch_sm_dir_data_v_q[1:0])};

          // Force address to start of cache line and adjust the residue

          sch_sm_cq_addr[5:4]       = 2'd0;
          sch_sm_res_adj            = (&sch_sm_dir_addr_q[5:4]) ? 2'd0 :
                                        sch_sm_dir_addr_q[5:4];

        end

        4'b0100,
        4'b0110: begin  // {pad, DIR_WB2, DIR_WB1, DIR_WB0} had to have been a padded case

          memi_dir_wb_next[2].re    = 1'b1;
          memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

          sch_sm_beats              = 3'd4;
          sch_sm_dsel0              = 3'd2;      // DIR WB2
          sch_sm_dsel1              = 3'd4;      // DIR PAD
          sch_sm_appended           = {1'd0, (&sch_sm_dir_data_v_q[2:1])};

          if ((dir_wb2_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
              ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
            sch_sm_dsel0            = 3'd5;     // ERROR
          end

          // Force address to start of cache line and adjust the residue

          sch_sm_cq_addr[5:4]       = 2'd0;
          sch_sm_res_adj            = (&sch_sm_dir_addr_q[5:4]) ? 2'd0 :
                                        sch_sm_dir_addr_q[5:4];

        end

        default: begin  // 4'b0111

          memi_dir_wb_next[2].re    = 1'b1;
          memi_dir_wb_next[2].raddr = sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0];

          sch_sm_appended           = 2'd2;

          if (sch_sm_dir_pad_ok_q) begin    // {pad, DIR_WB2, DIR_WB1, DIR_WB0} 

            sch_sm_beats            = 3'd4;
            sch_sm_dsel0            = 3'd2;      // DIR WB2
            sch_sm_dsel1            = 3'd4;      // DIR PAD

            if ((dir_wb2_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
              sch_sm_dsel0          = 3'd5;     // ERROR
            end

          end else begin                    // {N/A, DIR_WB2, DIR_WB1, DIR_WB0}

            sch_sm_beats            = 3'd3;
            sch_sm_dsel0            = 3'd2;      // DIR WB2
            sch_sm_dsel1            = 3'd6;      // N/A

            if ((dir_wb2_v_scaled[sch_sm_dir_cq_q[HQM_SYSTEM_AWIDTH_DIR_WB-1:0]]==1'b0) &
                ~cfg_write_buffer_ctl.IGNORE_DIR_WB_V) begin
              sch_sm_dsel0          = 3'd5;     // ERROR
            end

          end

        end

      endcase

      sch_sm_dir_data_v_next  = '0;
      sch_sm_opt_in_prog_next = '0;
      sch_sm_dir_pad_ok_next  = '0;

      sch_sm_state_next       = SCH_SM_IDLE;

    end // Not holding

  end // HQM_SYSTEM_SCH_SM_OPTA

 endcase // sch_sm_state

end

//----------------------------------------------------------------------------------------------------

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
   dir_wb0_v_q <= '0;
   dir_wb1_v_q <= '0;
   dir_wb2_v_q <= '0;
   ldb_wb0_v_q <= '0;
   ldb_wb1_v_q <= '0;
   ldb_wb2_v_q <= '0;
 end else begin
   dir_wb0_v_q <= dir_wb0_v_next[NUM_DIR_CQ-1:0];
   dir_wb1_v_q <= dir_wb1_v_next[NUM_DIR_CQ-1:0];
   dir_wb2_v_q <= dir_wb2_v_next[NUM_DIR_CQ-1:0];
   ldb_wb0_v_q <= ldb_wb0_v_next[NUM_LDB_CQ-1:0];
   ldb_wb1_v_q <= ldb_wb1_v_next[NUM_LDB_CQ-1:0];
   ldb_wb2_v_q <= ldb_wb2_v_next[NUM_LDB_CQ-1:0];
 end
end

hqm_AW_width_scale #(.A_WIDTH(NUM_DIR_CQ), .Z_WIDTH(NUM_DIR_CQ_P2)) i_dir_wb0_v_scaled (

     .a     (dir_wb0_v_q)
    ,.z     (dir_wb0_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(NUM_DIR_CQ), .Z_WIDTH(NUM_DIR_CQ_P2)) i_dir_wb1_v_scaled (

     .a     (dir_wb1_v_q)
    ,.z     (dir_wb1_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(NUM_DIR_CQ), .Z_WIDTH(NUM_DIR_CQ_P2)) i_dir_wb2_v_scaled (

     .a     (dir_wb2_v_q)
    ,.z     (dir_wb2_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(NUM_LDB_CQ), .Z_WIDTH(NUM_LDB_CQ_P2)) i_ldb_wb0_v_scaled (

     .a     (ldb_wb0_v_q)
    ,.z     (ldb_wb0_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(NUM_LDB_CQ), .Z_WIDTH(NUM_LDB_CQ_P2)) i_ldb_wb1_v_scaled (

     .a     (ldb_wb1_v_q)
    ,.z     (ldb_wb1_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(NUM_LDB_CQ), .Z_WIDTH(NUM_LDB_CQ_P2)) i_ldb_wb2_v_scaled (

     .a     (ldb_wb2_v_q)
    ,.z     (ldb_wb2_v_scaled)
);

generate

 if (NUM_DIR_CQ_P2 > NUM_DIR_CQ) begin: g_dir_unused

  hqm_AW_unused_bits #(.WIDTH(3*(NUM_DIR_CQ_P2-NUM_DIR_CQ))) i_dir_unused (
     .a     ({dir_wb2_v_next[NUM_DIR_CQ_P2-1:NUM_DIR_CQ]
             ,dir_wb1_v_next[NUM_DIR_CQ_P2-1:NUM_DIR_CQ]
             ,dir_wb0_v_next[NUM_DIR_CQ_P2-1:NUM_DIR_CQ]})
  );

 end

 if (NUM_LDB_CQ_P2 > NUM_LDB_CQ) begin: g_ldb_unused

  hqm_AW_unused_bits #(.WIDTH(3*(NUM_LDB_CQ_P2-NUM_LDB_CQ))) i_ldb_unused (
     .a     ({ldb_wb2_v_next[NUM_LDB_CQ_P2-1:NUM_LDB_CQ]
             ,ldb_wb1_v_next[NUM_LDB_CQ_P2-1:NUM_LDB_CQ]
             ,ldb_wb0_v_next[NUM_LDB_CQ_P2-1:NUM_LDB_CQ]})
  );

 end

endgenerate

//----------------------------------------------------------------------------------------------------
// WB memory interface signals

// For clock gating
always_comb begin
 for (int i=0; i<3; i=i+1) begin
   memi_dir_wb_nxt[i]           = memi_dir_wb_q[i];
   memi_ldb_wb_nxt[i]           = memi_ldb_wb_q[i];

   if (memi_dir_wb_next[i].we) begin
     memi_dir_wb_nxt[i].waddr   = memi_dir_wb_next[i].waddr;
     memi_dir_wb_nxt[i].wdata   = memi_dir_wb_next[i].wdata;
   end
   if (memi_ldb_wb_next[i].we) begin
     memi_ldb_wb_nxt[i].waddr   = memi_ldb_wb_next[i].waddr;
     memi_ldb_wb_nxt[i].wdata   = memi_ldb_wb_next[i].wdata;
   end
 end
end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin

  memi_dir_wb_q[0] <= '0;
  memi_dir_wb_q[1] <= '0;
  memi_dir_wb_q[2] <= '0;

  memi_ldb_wb_q[0] <= '0;
  memi_ldb_wb_q[1] <= '0;
  memi_ldb_wb_q[2] <= '0;

 end else begin

  memi_dir_wb_q[0].we     <= memi_dir_wb_next[0].we;
  memi_dir_wb_q[0].waddr  <= memi_dir_wb_nxt[0].waddr;
  memi_dir_wb_q[0].wdata  <= memi_dir_wb_nxt[0].wdata;
  memi_dir_wb_q[1].we     <= memi_dir_wb_next[1].we;
  memi_dir_wb_q[1].waddr  <= memi_dir_wb_nxt[1].waddr;
  memi_dir_wb_q[1].wdata  <= memi_dir_wb_nxt[1].wdata;
  memi_dir_wb_q[2].we     <= memi_dir_wb_next[2].we;
  memi_dir_wb_q[2].waddr  <= memi_dir_wb_nxt[2].waddr;
  memi_dir_wb_q[2].wdata  <= memi_dir_wb_nxt[2].wdata;

  memi_ldb_wb_q[0].we     <= memi_ldb_wb_next[0].we;
  memi_ldb_wb_q[0].waddr  <= memi_ldb_wb_nxt[0].waddr;
  memi_ldb_wb_q[0].wdata  <= memi_ldb_wb_nxt[0].wdata;
  memi_ldb_wb_q[1].we     <= memi_ldb_wb_next[1].we;
  memi_ldb_wb_q[1].waddr  <= memi_ldb_wb_nxt[1].waddr;
  memi_ldb_wb_q[1].wdata  <= memi_ldb_wb_nxt[1].wdata;
  memi_ldb_wb_q[2].we     <= memi_ldb_wb_next[2].we;
  memi_ldb_wb_q[2].waddr  <= memi_ldb_wb_nxt[2].waddr;
  memi_ldb_wb_q[2].wdata  <= memi_ldb_wb_nxt[2].wdata;

  if (~sch_p0_hold) begin
   memi_dir_wb_q[0].re    <= memi_dir_wb_next[0].re;
   memi_dir_wb_q[0].raddr <= memi_dir_wb_next[0].raddr;
   memi_dir_wb_q[1].re    <= memi_dir_wb_next[1].re;
   memi_dir_wb_q[1].raddr <= memi_dir_wb_next[1].raddr;
   memi_dir_wb_q[2].re    <= memi_dir_wb_next[2].re;
   memi_dir_wb_q[2].raddr <= memi_dir_wb_next[2].raddr;
   memi_ldb_wb_q[0].re    <= memi_ldb_wb_next[0].re;
   memi_ldb_wb_q[0].raddr <= memi_ldb_wb_next[0].raddr;
   memi_ldb_wb_q[1].re    <= memi_ldb_wb_next[1].re;
   memi_ldb_wb_q[1].raddr <= memi_ldb_wb_next[1].raddr;
   memi_ldb_wb_q[2].re    <= memi_ldb_wb_next[2].re;
   memi_ldb_wb_q[2].raddr <= memi_ldb_wb_next[2].raddr;
  end

 end
end

always_comb begin

 memi_dir_wb0 = memi_dir_wb_q[0];
 memi_dir_wb1 = memi_dir_wb_q[1];
 memi_dir_wb2 = memi_dir_wb_q[2];
 memi_ldb_wb0 = memi_ldb_wb_q[0];
 memi_ldb_wb1 = memi_ldb_wb_q[1];
 memi_ldb_wb2 = memi_ldb_wb_q[2];

 if (sch_p0_hold) begin

  memi_dir_wb0.re = '0;
  memi_dir_wb1.re = '0;
  memi_dir_wb2.re = '0;
  memi_ldb_wb0.re = '0;
  memi_ldb_wb1.re = '0;
  memi_ldb_wb2.re = '0;

 end

end

//----------------------------------------------------------------------------------------------------
// State machine error check

always_comb begin

 sch_sm_error_wbo        = '0;
 sch_sm_error_vdv        = '0;

 if (sch_out_fifo_pop_data_v_limited & sch_out_fifo_pop_data.hcw_v & ~sch_out_fifo_pop_data.ldb) begin

    // Only checks are on DIR CQs

    // It is an error if the write_buffer_optimization specifies more beats than are
    // available in the 64B block as indicated by the cq_wptr.

    sch_sm_error_wbo = ((sch_out_fifo_pop_data.beat==2'd1) & (sch_out_fifo_pop_data.wbo > 2'd2)) |
                       ((sch_out_fifo_pop_data.beat==2'd2) & (sch_out_fifo_pop_data.wbo > 2'd1)) |
                       ((sch_out_fifo_pop_data.beat==2'd3) & (sch_out_fifo_pop_data.wbo > 2'd0));

    if (sch_sm_opt_in_prog_q & (sch_out_fifo_pop_data.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0] == sch_sm_dir_cq_q)) begin

      // If we are already in an optimized DIR CQ case for the current DIR CQ, then it
      // is an error if the beat in the 64B block being written or a later beat is already
      // marked as being valid (rewriting same or earlier address).
      // Don't trigger this again if we've already reported it for this CQ's current optimization

      sch_sm_error_vdv = (sch_out_fifo_pop_data.beat==2'd0) |
                        ((sch_out_fifo_pop_data.beat==2'd1) & (|sch_sm_dir_data_v_q[3:1])) |
                        ((sch_out_fifo_pop_data.beat==2'd2) & (|sch_sm_dir_data_v_q[3:2])) |
                        ((sch_out_fifo_pop_data.beat==2'd3) &   sch_sm_dir_data_v_q[3]);
    end
 end

 sch_sm_error = sch_sm_error_idv | (sch_out_fifo_pop & (sch_sm_error_wbo | sch_sm_error_vdv));

 sch_sm_syndrome = {(sch_sm_error_wbo | sch_sm_error_vdv)
                   ,1'b0
                   ,((sch_sm_error_wbo) ? sch_out_fifo_pop_data.cq : sch_sm_dir_cq_q)
 };

end

//-----------------------------------------------------------------------------------------------------
// Pipeline for the requests generated by the state machine
// Transactions enter this pipeline when we're popping the sched_out FIFO.
// Since SIF write transactions use a 32B bus, we can consume the 16B hcw in the sch_p0 level along
// with the 16B hcw at the bottom of the FIFO in the same cycle.  When we do this, we gate the data_v
// indication going into the sch_p0 level.  We still set the sch_p0_v in case there was a piggybacked
// interrupt which needs to go out and will now look like a standalone interrupt after the last write
// if it was on the 2nd beat of a 32B write or 4th beat of a 64B write, or go out between the two writes
// if it was on the 2nd beat of a 48B write.  If there was no piggybacked interrupt, sch_p0_v shouldn't
// matter being set because it's always gated with either data_v, hdr_v, or int_v.

assign sch_p0_hold = sch_p0_v_q &  sch_p1_hold;
assign sch_p0_load = (sch_sm_data_v | sch_sm_int_v) & ~sch_p0_hold;

assign sch_p0_hdr_next.sop         = sch_sm_sop;
assign sch_p0_hdr_next.eop         = sch_sm_eop;
assign sch_p0_hdr_next.beats       = sch_sm_beats;
assign sch_p0_hdr_next.cq_addr     = sch_sm_cq_addr;
assign sch_p0_hdr_next.data_v      = sch_sm_data_v & (sch_sm_sop | sch_sm_eop);
assign sch_p0_hdr_next.int_v       = sch_sm_int_v;
assign sch_p0_hdr_next.int_d       = sch_out_fifo_pop_data.int_d;
assign sch_p0_hdr_next.ro          = sch_sm_ro;
assign sch_p0_hdr_next.spare       = sch_sm_spare;
assign sch_p0_hdr_next.pasidtlp    = sch_sm_pasidtlp;
assign sch_p0_hdr_next.is_pf       = sch_sm_is_pf;
assign sch_p0_hdr_next.vf          = sch_sm_vf;
assign sch_p0_hdr_next.ldb         = sch_sm_ldb;
assign sch_p0_hdr_next.appended    = sch_sm_appended;
assign sch_p0_hdr_next.dsel0       = sch_sm_dsel0;
assign sch_p0_hdr_next.dsel1       = sch_sm_dsel1;
assign sch_p0_hdr_next.gen         = sch_sm_gen;

// Adjust the cq address residue is we nuked bits [5:4] to point at the start of the cache line
// in a padded case.

hqm_AW_residue_sub i_sch_p0_res_sub (

     .a     (sch_sm_res_adj)
    ,.b     (sch_sm_cq_addr_res)
    ,.r     (sch_p0_hdr_next.cq_addr_res)
);

// Parity covers only ro, spare, pasidtlp, is_pf, and vf
// Need to account for SM outputs sop, eop, beats, data_v, int_v, ldb, appended, dsel0, and dsel1
// in the pipeline parity

assign sch_p0_hdr_next.parity      = ^{sch_sm_parity
                                      ,sch_sm_sop
                                      ,sch_sm_eop
                                      ,sch_sm_beats
                                      ,(sch_sm_data_v & (sch_sm_sop | sch_sm_eop))
                                      ,sch_sm_int_v
                                      ,sch_sm_ldb
                                      ,sch_sm_appended
                                      ,sch_sm_dsel1
                                      ,sch_sm_dsel0};

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  sch_p0_v_q     <= '0;
  sch_p0_hdr_q   <= '0;
  sch_p0_data_q  <= '0;
  sch_p0_cq_q    <= '0;
 end else begin
  if (~sch_p0_hold) begin
   sch_p0_v_q    <= sch_sm_data_v | sch_sm_int_v;
  end
  if (sch_p0_load) begin
   sch_p0_hdr_q  <= sch_p0_hdr_next;
   sch_p0_data_q <= {sch_out_fifo_pop_data.ecc, sch_out_fifo_pop_data.hcw};
   sch_p0_cq_q   <= sch_sm_cq;
  end
 end
end

//-----------------------------------------------------------------------------------------------------

assign sch_p1_hold = sch_p1_v_q &  sch_p2_hold;
assign sch_p1_load = sch_p0_v_q & ~sch_p1_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  sch_p1_v_q     <= '0;
  sch_p1_hdr_q   <= '0;
  sch_p1_data_q  <= '0;
  sch_p1_cq_q    <= '0;
 end else begin
  if (~sch_p1_hold) begin
   sch_p1_v_q    <= sch_p0_v_q;
  end
  if (sch_p1_load) begin
   sch_p1_hdr_q  <= sch_p0_hdr_q;
   sch_p1_data_q <= sch_p0_data_q;
   sch_p1_cq_q   <= sch_p0_cq_q;
  end
 end
end

//-----------------------------------------------------------------------------------------------------

// Have to hold if CQ write is valid and the output DBs are not ready.
// Have to hold if CQ int   is valid and the cq_occ DB  is  not ready.
// Have to hold if the scheduler path is not being selected by the arbiter.

assign sch_p2_hold = sch_p2_v_q & ((sch_p2_hdr_q.data_v &
                                    ((sch_p2_hdr_q.sop &  ~pdata_ls_db_in_ready) |
                                     (sch_p2_hdr_q.eop & (~pdata_ms_db_in_ready  | ~phdr_db_in_ready))
                                    )
                                   ) |
                                   (sch_p2_hdr_q.int_v  & ~cq_occ_int_db_ready) |
                                   (sch_arb_req         & ~arb_winner_sch));

assign sch_p2_load = sch_p1_v_q & ~sch_p2_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  sch_p2_v_q     <= '0;
  sch_p2_hdr_q   <= '0;
  sch_p2_data_q  <= '0;
  sch_p2_cq_q    <= '0;
  sch_p2_wb0_q   <= '0;
  sch_p2_wb1_q   <= '0;
  sch_p2_wb2_q   <= '0;
 end else begin
  if (~sch_p2_hold) begin
   sch_p2_v_q    <= sch_p1_v_q;
  end
  if (sch_p2_load) begin
   sch_p2_hdr_q  <= sch_p1_hdr_q;
   sch_p2_data_q <= sch_p1_data_q;
   sch_p2_cq_q   <= sch_p1_cq_q;
   if ((sch_p1_hdr_q.dsel0==3'd0) | (sch_p1_hdr_q.dsel1==3'd0)) begin
    sch_p2_wb0_q <= (sch_p1_hdr_q.ldb) ? memo_ldb_wb0.rdata : memo_dir_wb0.rdata;
   end
   if ((sch_p1_hdr_q.dsel0==3'd1) | (sch_p1_hdr_q.dsel1==3'd1)) begin
    sch_p2_wb1_q <= (sch_p1_hdr_q.ldb) ? memo_ldb_wb1.rdata : memo_dir_wb1.rdata;
   end
   if ((sch_p1_hdr_q.dsel0==3'd2) | (sch_p1_hdr_q.dsel1==3'd2)) begin
    sch_p2_wb2_q <= (sch_p1_hdr_q.ldb) ? memo_ldb_wb2.rdata : memo_dir_wb2.rdata;
   end
  end
 end
end

//----------------------------------------------------------------------------------------------------
// Generate PAD as all 0s but with the HCW cq_gen bit inverted from the current cq_gen bit
// Need ECC on the PAD as well.

always_comb begin

 error_pad.hcw                 = '0;
 error_pad.hcw.flags.hcw_error = 1'b1;
 error_pad.hcw.flags.cq_gen    = sch_p2_hdr_q.gen;

 zero_pad.hcw         = '0;

 pad.hcw              = '0;
 pad.hcw.flags.cq_gen = ~sch_p2_hdr_q.gen;

end

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_error_pad_ecc_h (

     .d         (error_pad.hcw[127:64])
    ,.ecc       (error_pad.ecc[15:8])
);

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_error_pad_ecc_l (

     .d         (error_pad.hcw[63:0])
    ,.ecc       (error_pad.ecc[7:0])
);

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_pad_ecc_h (

     .d         (pad.hcw[127:64])
    ,.ecc       (pad.ecc[15:8])
);

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_pad_ecc_l (

     .d         (pad.hcw[63:0])
    ,.ecc       (pad.ecc[7:0])
);

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_zero_pad_ecc_h (

     .d         (zero_pad.hcw[127:64])
    ,.ecc       (zero_pad.ecc[15:8])
);

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_zero_pad_ecc_l (

     .d         (zero_pad.hcw[63:0])
    ,.ecc       (zero_pad.ecc[7:0])
);

//----------------------------------------------------------------------------------------------------
// Generate correct 32B write data based on the data selects

always_comb begin

 unique casez (sch_p2_hdr_q.dsel0)
  3'd0:    sch_p2_data[0] = sch_p2_wb0_q;       // DIR_WB0 or LDB_WB0
  3'd1:    sch_p2_data[0] = sch_p2_wb1_q;       // DIR_WB1 or LDB_WB1
  3'd2:    sch_p2_data[0] = sch_p2_wb2_q;       // DIR_WB2 or LDB_WB2
  3'd3:    sch_p2_data[0] = sch_p2_data_q;      // FIFO
  3'd4:    sch_p2_data[0] = pad;                // PAD
  3'd5:    sch_p2_data[0] = error_pad;          // ERROR
  default: sch_p2_data[0] = zero_pad;
 endcase

 unique casez (sch_p2_hdr_q.dsel1)
  3'd0:    sch_p2_data[1] = sch_p2_wb0_q;       // DIR_WB0 or LDB_WB0
  3'd1:    sch_p2_data[1] = sch_p2_wb1_q;       // DIR_WB1 or LDB_WB1
  3'd2:    sch_p2_data[1] = sch_p2_wb2_q;       // DIR_WB2 or LDB_WB2
  3'd3:    sch_p2_data[1] = sch_p2_data_q;      // FIFO
  3'd4:    sch_p2_data[1] = pad;                // PAD
  3'd5:    sch_p2_data[1] = error_pad;          // ERROR
  default: sch_p2_data[1] = zero_pad;
 endcase

end

//-----------------------------------------------------------------------------------------------------

// Need to request the SIF path when the transaction has valid data and the posted data FIFO is not full.
// If we also need to send a header on this cycle, need to check that the posted header FIFO is not full.
// If an interrupt is piggybacking, then need to make sure the interface to the alarm block isn't busy.

assign sch_arb_req = sch_p2_v_q & sch_p2_hdr_q.data_v & sch_p2_hdr_q.sop & phdr_db_in_ready &
                        ~(sch_p2_hdr_q.int_v & ~cq_occ_int_db_ready);

// Interrupts can be sent to the alarm block when the interface is not busy and either the interrupt
// is standalone (since we either don't need to arbitrate for the SIF path) or when the sch has
// already won the SIF arbitration.  Using a DB to decouple the cq_occ_int_busy timing from the
// rest of the path.

assign cq_occ_int_db_v = cq_occ_int_db_ready & sch_p2_v_q & sch_p2_hdr_q.int_v &
                        (~sch_p2_hdr_q.data_v | (arb_winner_sch & ~sch_p2_hold));

assign cq_occ_int_db   = sch_p2_hdr_q.int_d;

hqm_AW_double_buffer #(

     .WIDTH             ($bits(cq_occ_int_db))
    ,.NOT_EMPTY_AT_EOT  (0)

) i_cq_occ_db (

     .clk               (hqm_gated_clk)
    ,.rst_n             (hqm_gated_rst_n)

    ,.status            (cq_occ_db_status)

    ,.in_ready          (cq_occ_int_db_ready)

    ,.in_valid          (cq_occ_int_db_v)
    ,.in_data           (cq_occ_int_db)

    ,.out_ready         (cq_occ_int_ready)

    ,.out_valid         (cq_occ_int_v)
    ,.out_data          (cq_occ_int)
);

assign cq_occ_int_ready = ~cq_occ_int_busy;

//-----------------------------------------------------------------------------------------------------
// Integrity checks and data correction

assign sch_p2_res_check = sch_p2_v_q & ~sch_p2_hold & sch_hdr_v & ~cfg_residue_off;

assign sch_p2_cq_addr_res = {sch_p2_hdr_q.cq_addr_res[1],
    (sch_p2_hdr_q.cq_addr_res[0] ^ (sch_inj_par_err_q[2] & ~sch_inj_par_err_last_q[2]))};

hqm_AW_residue_check #(.WIDTH($bits(sch_p2_hdr_q.cq_addr))) i_sch_p2_rerr (

     .r         (sch_p2_cq_addr_res)
    ,.d         (sch_p2_hdr_q.cq_addr)
    ,.e         (sch_p2_res_check)
    ,.err       (sch_p2_rerr)
);

assign sch_p2_perr = sch_p2_v_q & ~sch_p2_hold & sch_hdr_v & ~cfg_parity_off &
    (^{sch_p2_hdr_q.parity
      ,sch_p2_hdr_q.sop
      ,sch_p2_hdr_q.eop
      ,sch_p2_hdr_q.beats
      ,sch_p2_hdr_q.data_v
      ,sch_p2_hdr_q.int_v
      ,sch_p2_hdr_q.ldb
      ,sch_p2_hdr_q.ro
      ,sch_p2_hdr_q.spare
      ,sch_p2_hdr_q.pasidtlp
      ,sch_p2_hdr_q.is_pf
      ,sch_p2_hdr_q.vf
      ,sch_p2_hdr_q.appended
      ,sch_p2_hdr_q.dsel1
      ,sch_p2_hdr_q.dsel0
      ,(sch_inj_par_err_q[1] & ~sch_inj_par_err_last_q[1])});

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  sch_inj_ecc_err_q      <= '0;
  sch_inj_ecc_err_last_q <= '0;
  sch_inj_par_err_q      <= '0;
  sch_inj_par_err_last_q <= '0;
  sch_p0_fifo_perr_q     <= '0;
  sch_p3_perr_q          <= '0;
  sch_p3_rerr_q          <= '0;
 end else begin
  sch_inj_ecc_err_q      <= cfg_inj_ecc_err_wbuf[7:0];
  sch_inj_ecc_err_last_q <= sch_inj_ecc_err_q & (sch_inj_ecc_err_last_q |
                                {{4{(sch_p2_check_ecc[1] & sch_data_v)}}
                                ,{4{(sch_p2_check_ecc[0] & sch_data_v)}}});
  sch_inj_par_err_q      <= cfg_inj_par_err_wbuf;
  sch_inj_par_err_last_q <= sch_inj_par_err_q & (sch_inj_par_err_last_q |
                                {{2{(ims_msix_w_v & ims_msix_w_ready)}}
                                ,{2{(sch_p2_v_q & ~sch_p2_hold & sch_hdr_v)}}
                                ,sch_out_fifo_pop});
  sch_p0_fifo_perr_q     <= sch_out_fifo_pop & (sch_out_fifo_perr | sch_out_fifo_int_perr);
  sch_p3_perr_q          <= sch_p2_perr;
  sch_p3_rerr_q          <= sch_p2_rerr;
 end
end

// Don't check the padding in the MS word if we're sending only 16B instead of 32B
 
assign sch_p2_check_ecc[1] = sch_p2_v_q & sch_p2_hdr_q.data_v &
                                ((sch_p2_hdr_q.beats == 3'd2) |     // 2 beats
                                 (sch_p2_hdr_q.beats == 3'd4) |     // 4 beats
             (sch_p2_hdr_q.sop & (sch_p2_hdr_q.beats == 3'd3)));    // 3 beats first write

assign sch_p2_check_ecc[0] = sch_p2_v_q & sch_p2_hdr_q.data_v;

hqm_AW_ecc_check #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_sch_ecc_check0_ls (

     .din_v     (sch_p2_check_ecc[0])
    ,.din       ({ sch_p2_data[0][ 63 -:  62]
                 ,(sch_p2_data[0][  1 -:   1] ^ (  sch_inj_ecc_err_q[  0] & ~sch_inj_ecc_err_last_q[  0] ))
                 ,(sch_p2_data[0][  0 -:   1] ^ (|(sch_inj_ecc_err_q[1:0] & ~sch_inj_ecc_err_last_q[1:0])))
                })
    ,.ecc       (sch_p2_data[0][135 -:  8])
    ,.enable    (cfg_sch_wb_ecc_enable)
    ,.correct   (1'b1)

    ,.dout      (sch_p2_data_corrected[0][63 -: 64])

    ,.error_sb  (sch_p2_sb_ecc_error_ls[0])
    ,.error_mb  (sch_p2_mb_ecc_error_ls[0])
);

hqm_AW_ecc_check #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_sch_ecc_check0_ms (

     .din_v     (sch_p2_check_ecc[0])
    ,.din       ({ sch_p2_data[0][127 -:  62]
                 ,(sch_p2_data[0][ 65 -:   1] ^ (  sch_inj_ecc_err_q[  2] & ~sch_inj_ecc_err_last_q[  2] ))
                 ,(sch_p2_data[0][ 64 -:   1] ^ (|(sch_inj_ecc_err_q[3:2] & ~sch_inj_ecc_err_last_q[3:2])))
                })
    ,.ecc       (sch_p2_data[0][143 -:  8])
    ,.enable    (cfg_sch_wb_ecc_enable)
    ,.correct   (1'b1)

    ,.dout      (sch_p2_data_corrected[0][127 -: 64])

    ,.error_sb  (sch_p2_sb_ecc_error_ms[0])
    ,.error_mb  (sch_p2_mb_ecc_error_ms[0])
);

hqm_AW_ecc_check #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_sch_ecc_check1_ls (

     .din_v     (sch_p2_check_ecc[1])
    ,.din       ({ sch_p2_data[1][ 63 -:  62]
                 ,(sch_p2_data[1][  1 -:   1] ^ (  sch_inj_ecc_err_q[  4] & ~sch_inj_ecc_err_last_q[  4] ))
                 ,(sch_p2_data[1][  0 -:   1] ^ (|(sch_inj_ecc_err_q[5:4] & ~sch_inj_ecc_err_last_q[5:4])))
                })
    ,.ecc       (sch_p2_data[1][135 -:  8])
    ,.enable    (cfg_sch_wb_ecc_enable)
    ,.correct   (1'b1)

    ,.dout      (sch_p2_data_corrected[1][63 -: 64])

    ,.error_sb  (sch_p2_sb_ecc_error_ls[1])
    ,.error_mb  (sch_p2_mb_ecc_error_ls[1])
);

hqm_AW_ecc_check #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_sch_ecc_check1_ms (

     .din_v     (sch_p2_check_ecc[1])
    ,.din       ({ sch_p2_data[1][127 -:  62]
                 ,(sch_p2_data[1][ 65 -:   1] ^ (  sch_inj_ecc_err_q[  6] & ~sch_inj_ecc_err_last_q[  6] ))
                 ,(sch_p2_data[1][ 64 -:   1] ^ (|(sch_inj_ecc_err_q[7:6] & ~sch_inj_ecc_err_last_q[7:6])))
                })
    ,.ecc       (sch_p2_data[1][143 -:  8])
    ,.enable    (cfg_sch_wb_ecc_enable)
    ,.correct   (1'b1)

    ,.dout      (sch_p2_data_corrected[1][127 -: 64])

    ,.error_sb  (sch_p2_sb_ecc_error_ms[1])
    ,.error_mb  (sch_p2_mb_ecc_error_ms[1])
);

assign sch_p3_sb_ecc_error_next = {4{sch_data_v}} & {sch_p2_sb_ecc_error_ms[1]
                                                    ,sch_p2_sb_ecc_error_ls[1]
                                                    ,sch_p2_sb_ecc_error_ms[0]
                                                    ,sch_p2_sb_ecc_error_ls[0]};

assign sch_p3_mb_ecc_error_next = {4{sch_data_v}} & {sch_p2_mb_ecc_error_ms[1]
                                                    ,sch_p2_mb_ecc_error_ls[1]
                                                    ,sch_p2_mb_ecc_error_ms[0]
                                                    ,sch_p2_mb_ecc_error_ls[0]};

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  sch_p3_sb_ecc_error_q <= '0;
  sch_p3_mb_ecc_error_q <= '0;
  sch_p3_cq_q           <= '0;
 end else begin
  sch_p3_sb_ecc_error_q <= sch_p3_sb_ecc_error_next;
  sch_p3_mb_ecc_error_q <= sch_p3_mb_ecc_error_next;
  if (|{sch_p3_sb_ecc_error_next, sch_p3_mb_ecc_error_next}) sch_p3_cq_q <= sch_p2_cq_q;
 end
end

assign sch_wb_sb_ecc_error = sch_p3_sb_ecc_error_q;
assign sch_wb_mb_ecc_error = sch_p3_mb_ecc_error_q;

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_CQ_WIDTH), .Z_WIDTH(8)) i_ecc_synd (

     .a         (sch_p3_cq_q)
    ,.z         (sch_wb_ecc_syndrome[7:0])
);

//-----------------------------------------------------------------------------------------------------
// Header formation and data alignment

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_VF_WIDTH), .Z_WIDTH(5)) i_sch_p2_vf_scaled (

     .a         (sch_p2_hdr_q.vf)
    ,.z         (sch_p2_vf_scaled)
);

always_comb begin

 sch_hdr_v       = arb_winner_sch & sch_p2_v_q & sch_p2_hdr_q.data_v & 
                    sch_p2_hdr_q.eop & phdr_db_in_ready & ~(sch_p2_hdr_q.int_v & ~cq_occ_int_db_ready);

 sch_hdr          = '0;

 sch_hdr.src      =  SCH;
 sch_hdr.ro       =  sch_p2_hdr_q.ro;
 sch_hdr.cq_v     =  '1;
 sch_hdr.cq_ldb   =  sch_p2_hdr_q.ldb;
 sch_hdr.cq       =  sch_p2_cq_q[5:0];
 sch_hdr.tc_sel   = (sch_p2_hdr_q.ldb) ? sch_p2_cq_q[5:4] :
                        {(^{                sch_p2_cq_q[4], sch_p2_cq_q[2], sch_p2_cq_q[0]})
                        ,(^{sch_p2_cq_q[5], sch_p2_cq_q[3], sch_p2_cq_q[1]})};
 sch_hdr.length   = {sch_p2_hdr_q.beats, 2'd0};     // DWs
 sch_hdr.add      = {sch_p2_hdr_q.cq_addr, 2'd0};

 if (pci_cfg_sciov_en) begin

    sch_hdr.pasidtlp = sch_p2_hdr_q.pasidtlp;       // 0 by default unless in SC-IOV mode

 end

 // A parity or residue error invalidates the write

 sch_hdr.invalid  = sch_p2_perr | sch_p2_rerr;

 sch_hdr.len_par  = ^sch_p2_hdr_q.beats;

 sch_hdr.add_par  = {(^sch_p2_hdr_q.cq_addr[63:32])
                    ,(^sch_p2_hdr_q.cq_addr[31: 4])};

 sch_hdr.num_hcws = sch_p2_hdr_q.appended + 3'd1;

 sch_hdr.par      = ^{sch_hdr.invalid
                     ,sch_hdr.num_hcws
                     ,sch_hdr.src
                     ,sch_hdr.ro
                     ,sch_hdr.cq_v
                     ,sch_hdr.cq_ldb
                     ,sch_hdr.cq
                     ,sch_hdr.tc_sel
                     ,sch_hdr.pasidtlp
                     };

 sch_data_v       = arb_winner_sch & sch_p2_v_q & sch_p2_hdr_q.data_v & 
                     ~(sch_p2_hdr_q.eop & ~phdr_db_in_ready) & ~(sch_p2_hdr_q.int_v & ~cq_occ_int_db_ready);
                 
 sch_data_first   = sch_data_v & sch_p2_hdr_q.sop;
 sch_data_last    = sch_data_v & sch_p2_hdr_q.eop;
                 
 sch_data[1]      = sch_p2_data_corrected[1];
 sch_data[0]      = sch_p2_data_corrected[0];

 if (sch_p2_mb_ecc_error_ms[1] | sch_p2_mb_ecc_error_ls[1]) sch_data[1].flags.hcw_error = '1;
 if (sch_p2_mb_ecc_error_ms[0] | sch_p2_mb_ecc_error_ls[0]) sch_data[0].flags.hcw_error = '1;

end

//-----------------------------------------------------------------------------------------------------
// MSI-X writes

assign ims_msix_arb_req = ims_msix_w_v & phdr_db_in_ready;

assign ims_msix_res_check = ims_msix_w_v & ims_msix_w_ready & ~cfg_residue_off;

assign ims_msix_res       = {ims_msix_w.addr_res[1],
    (ims_msix_w.addr_res[0] ^ (sch_inj_par_err_q[4] & ~sch_inj_par_err_last_q[4]))};

hqm_AW_residue_check #(.WIDTH($bits(ims_msix_w.addr))) i_ims_msix_rerr (

     .r         (ims_msix_res)
    ,.d         (ims_msix_w.addr)
    ,.e         (ims_msix_res_check)
    ,.err       (ims_msix_rerr)
);

assign ims_msix_perr = ims_msix_w_v & ims_msix_w_ready & ~cfg_parity_off &
    ^{ims_msix_w.parity
     ,ims_msix_w.poll
     ,ims_msix_w.ai
     ,ims_msix_w.cq_v
     ,ims_msix_w.cq_ldb
     ,ims_msix_w.cq
     ,ims_msix_w.tc_sel
     ,(sch_inj_par_err_q[3] & ~sch_inj_par_err_last_q[3])};

always_comb begin

 ims_msix_hdr          = '0;

 ims_msix_hdr.add      = ims_msix_w.addr;

 // PASIDTLP is 0 by default unless in SC-IOV IMS polling mode where it is set valid
 // with PASID[19:0] = data[31:12].

 if (pci_cfg_sciov_en & ims_msix_w.poll) begin

    ims_msix_hdr.pasidtlp = {3'd4, ims_msix_w.data[31:12]};

 end

 // A parity or residue error invalidates the write

 ims_msix_hdr.invalid  = ims_msix_perr | ims_msix_rerr;

 ims_msix_hdr.length   = 5'h01;                         // 1DW for IMS or MSI-X

 ims_msix_hdr.len_par  = ^ims_msix_hdr.length;

 ims_msix_hdr.src      = (ims_msix_w.ai) ? AI : MSIX;

 ims_msix_hdr.cq_v     = ims_msix_w.cq_v;
 ims_msix_hdr.cq_ldb   = ims_msix_w.cq_ldb;
 ims_msix_hdr.cq       = ims_msix_w.cq;

 ims_msix_hdr.tc_sel   = ims_msix_w.tc_sel;

 ims_msix_hdr.add_par  = {(^ims_msix_w.addr[63:32])
                         ,(^ims_msix_w.addr[31: 2])};

 ims_msix_hdr.par      = ^{ims_msix_hdr.invalid
                          ,ims_msix_hdr.pasidtlp
                          ,ims_msix_hdr.src
                          ,ims_msix_hdr.cq_v
                          ,ims_msix_hdr.cq_ldb
                          ,ims_msix_hdr.cq
                          ,ims_msix_hdr.tc_sel
                          };

end

assign ims_msix_w_ready = arb_winner_msix;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  ims_msix_perr_q <= '0;
  ims_msix_rerr_q <= '0;
 end else begin
  ims_msix_perr_q <= ims_msix_perr;
  ims_msix_rerr_q <= ims_msix_rerr;
 end
end

assign sch_wb_error_synd = {3'd0, ims_msix_perr_q, ims_msix_rerr_q,
                            sch_p0_fifo_perr_q,  sch_p3_perr_q,  sch_p3_rerr_q};

assign sch_wb_error      = |sch_wb_error_synd;

//-----------------------------------------------------------------------------------------------------
// Arbitration
//
// The cfg mask can be used to mask off each of the requestors.
// A leading edge on the CFG single_step will allow a single request to arbitrate if already masked.

assign arb_single_step = {cfg_write_buffer_ctl.SINGLE_STEP_MSI
                         ,cfg_write_buffer_ctl.SINGLE_STEP_SCH} & ~arb_step_q;

assign arb_mask = ~{cfg_write_buffer_ctl.ARB_MSI_MASK
                   ,cfg_write_buffer_ctl.ARB_SCH_MASK} | arb_single_step | ~arb_debug_q[1:0];

assign arb_reqs = {ims_msix_arb_req, sch_arb_req};

hqm_AW_rr_arbiter #(.NUM_REQS(2)) u_rr_arb (

     .clk           (hqm_gated_clk)
    ,.rst_n         (hqm_gated_rst_n)

    ,.mode          (2'd2)
    ,.update        (arb_update)

    ,.reqs          (arb_reqs & arb_mask)

    ,.winner_v      (arb_winner_v)
    ,.winner        (arb_winner)
);

assign arb_winner_msix = (arb_hold_q)      ? 1'b0             : (arb_winner_v &  arb_winner);
assign arb_winner_sch  = (arb_hold_q)      ? (~arb_winner_q)  : (arb_winner_v & ~arb_winner);
assign arb_hold_next   = (arb_winner_sch ) ? (~sch_data_last) :  arb_hold_q;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  arb_debug_q  <= '0;
  arb_hold_q   <= '0;
  arb_step_q   <= '0;
  arb_reqs_q   <= '0;
  arb_winner_q <= '0;
 end else begin
  arb_debug_q  <= {10{cfg_write_buffer_ctl.ENABLE_DEBUG}};
  arb_hold_q   <= arb_hold_next;
  arb_step_q   <= {cfg_write_buffer_ctl.SINGLE_STEP_MSI
                  ,cfg_write_buffer_ctl.SINGLE_STEP_SCH};
  arb_reqs_q   <= arb_reqs;
  if (arb_hold_next & ~arb_hold_q) arb_winner_q <= arb_winner;
 end
end

assign arb_update = arb_winner_v & ~arb_hold_q;

//-----------------------------------------------------------------------------------------------------

assign wbuf_appended_next = (sch_hdr_v) ? sch_p2_hdr_q.appended : '0;

always_comb begin

 phdr_v      =  ims_msix_w_ready | sch_hdr_v;
 phdr        = (ims_msix_w_ready) ? ims_msix_hdr : sch_hdr;

 pdata_v     =  ims_msix_w_ready | sch_data_v;
 pdata.data  = '0;
 pdata.dpar  = '0;

 if (ims_msix_w_ready) begin

  // Only DW0 is non-zero data

  pdata.data    = {224'd0, ims_msix_w.data};
  pdata.dpar    = {  7'd0, ims_msix_w.data_par};

 end else if (sch_data_v) begin

  pdata.data    = {sch_data[1], sch_data[0]};

  pdata.dpar[0] = ^sch_data[0][0  +:32];
  pdata.dpar[1] = ^sch_data[0][32 +:32];
  pdata.dpar[2] = ^sch_data[0][64 +:32];
  pdata.dpar[3] = ^sch_data[0][96 +:32];
  pdata.dpar[4] = ^sch_data[1][0  +:32];
  pdata.dpar[5] = ^sch_data[1][32 +:32];
  pdata.dpar[6] = ^sch_data[1][64 +:32];
  pdata.dpar[7] = ^sch_data[1][96 +:32];

 end

end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  wbuf_appended_q   <= '0;
 end else begin
  wbuf_appended_q   <= wbuf_appended_next;
 end
end

assign wbuf_appended = wbuf_appended_q;

always_comb begin

 phdr_db_in_v        = '0;
 pdata_ms_db_in_v    = '0;
 pdata_ls_db_in_v    = '0;

 phdr_db_in_data     = phdr;

 pdata_ms_db_in_data = pdata;
 pdata_ls_db_in_data = pdata;

 if (pdata_v & ~phdr_v) begin

  // First beat of multibeat write - load just data LS

  pdata_ls_db_in_v   = '1;

 end

 else if (phdr_v) begin

  // Single beat write or second beat of multibeat write - load header

  phdr_db_in_v       = '1;

  if (((phdr.src == SCH) & sch_data_first) | (phdr.src == MSIX) | (phdr.src == AI)) begin

   // Single beat write - load data LS, put 0s in MS

   pdata_ls_db_in_v    = '1;
   pdata_ms_db_in_v    = '1;
   pdata_ms_db_in_data = '0;

  end else begin

   // Multibeat write - load data MS

   pdata_ms_db_in_v  = '1;

  end

 end

end

hqm_AW_double_buffer #(

     .WIDTH             ($bits(phdr_db_in_data))
    ,.NOT_EMPTY_AT_EOT  (0)

) i_phdr_db (

     .clk               (hqm_gated_clk)
    ,.rst_n             (hqm_gated_rst_n)

    ,.status            (phdr_db_status)

    ,.in_ready          (phdr_db_in_ready)

    ,.in_valid          (phdr_db_in_v)
    ,.in_data           (phdr_db_in_data)

    ,.out_ready         (phdr_db_out_ready)

    ,.out_valid         (phdr_db_out_v)
    ,.out_data          (phdr_db_out_data)
);

hqm_AW_double_buffer #(

     .WIDTH             ($bits(pdata_ms_db_in_data))
    ,.NOT_EMPTY_AT_EOT  (0)

) i_pdata_ms_db (

     .clk               (hqm_gated_clk)
    ,.rst_n             (hqm_gated_rst_n)

    ,.status            (pdata_ms_db_status)

    ,.in_ready          (pdata_ms_db_in_ready)

    ,.in_valid          (pdata_ms_db_in_v)
    ,.in_data           (pdata_ms_db_in_data)

    ,.out_ready         (pdata_ms_db_out_ready)

    ,.out_valid         (pdata_ms_db_out_v)
    ,.out_data          (pdata_ms_db_out_data)
);

hqm_AW_double_buffer #(

     .WIDTH             ($bits(pdata_ls_db_in_data))
    ,.NOT_EMPTY_AT_EOT  (0)

) i_pdata_ls_db (

     .clk               (hqm_gated_clk)
    ,.rst_n             (hqm_gated_rst_n)

    ,.status            (pdata_ls_db_status)

    ,.in_ready          (pdata_ls_db_in_ready)

    ,.in_valid          (pdata_ls_db_in_v)
    ,.in_data           (pdata_ls_db_in_data)

    ,.out_ready         (pdata_ls_db_out_ready)

    ,.out_valid         (pdata_ls_db_out_v)
    ,.out_data          (pdata_ls_db_out_data)
);

always_comb begin

 phdr_db_out_ready         = '0;
 pdata_ms_db_out_ready     = '0;
 pdata_ls_db_out_ready     = '0;

 write_buffer_mstr_v       = '0;
 write_buffer_mstr.hdr     = '0;
 write_buffer_mstr.data_ms = '0;
 write_buffer_mstr.data_ls = '0;

 pwrite_v                  = '0;

 if (phdr_db_out_v & pdata_ls_db_out_v & pdata_ms_db_out_v) begin

  write_buffer_mstr_v       = '1;
  write_buffer_mstr.hdr     = phdr_db_out_data;
  write_buffer_mstr.data_ms = pdata_ms_db_out_data;
  write_buffer_mstr.data_ls = pdata_ls_db_out_data;

  if (write_buffer_mstr_ready) begin

   phdr_db_out_ready     = '1;
   pdata_ms_db_out_ready = '1;
   pdata_ls_db_out_ready = '1;

   pwrite_v              = '1;  // For SMON

  end

 end

 pwrite_comp     = {8'd0
                   ,phdr_db_out_data.num_hcws       // 21:19
                   ,phdr_db_out_data.invalid        // 18
                   ,phdr_db_out_data.ro             // 17
                   ,phdr_db_out_data.length         // 16:12
                   ,phdr_db_out_data.cq_v           // 11
                   ,phdr_db_out_data.cq_ldb         // 10
                   ,phdr_db_out_data.cq             //  9: 4
                   ,phdr_db_out_data.tc_sel         //  3: 2
                   ,phdr_db_out_data.src            //  1: 0
                   };

 pwrite_value    = {29'd0
                   ,phdr_db_out_data.num_hcws
                   };

 cfg_phdr_debug  = {phdr_db_out_data.invalid        // 83       // 19
                   ,phdr_db_out_data.ro             // 82       // 18   
                   ,phdr_db_out_data.cq_v           // 81       // 17   
                   ,phdr_db_out_data.cq_ldb         // 80       // 16
                   ,phdr_db_out_data.cq             // 79:74    // 15:10
                   ,phdr_db_out_data.num_hcws       // 73:71    //  9: 7
                   ,phdr_db_out_data.src            // 70:69    //  6: 5
                   ,phdr_db_out_data.length         // 68:64    //  4: 0
                   ,phdr_db_out_data.add            // 63: 2
                   ,phdr_db_out_data.tc_sel         //  1: 0
                   } &                              
                   {{($bits(cfg_phdr_debug)-64){arb_debug_q[9]}}, {64{arb_debug_q[8]}}};

 cfg_pdata_debug = {pdata_ms_db_out_data.data       // 511:256
                   ,pdata_ls_db_out_data.data       // 255:  0
                   } &
                   {{64{arb_debug_q[7]}}, {64{arb_debug_q[6]}},
                    {64{arb_debug_q[5]}}, {64{arb_debug_q[4]}},
                    {64{arb_debug_q[3]}}, {64{arb_debug_q[2]}},
                    {64{arb_debug_q[1]}}, {64{arb_debug_q[0]}}
                   };

end

//-----------------------------------------------------------------------------------------------------
// Dedicated interface event counters

logic               cnt_clear_q;
logic               cnt_clearv_q;

logic   [3:0]       cnt_inc;
logic   [3:0]       cnt_inc_4_next;
logic   [3:0]       cnt_inc_4_q;
logic   [1:0]       cnt_inc_5;
logic   [63:0]      cnt4_next;
logic   [63:0]      cnt4_q;
logic   [63:0]      cnt5_next;
logic   [63:0]      cnt5_q;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cnt_clear_q   <= '0;
  cnt_clearv_q  <= '0;
  cnt_inc_4_q   <= '0;
  cnt4_q        <= '0;
  cnt5_q        <= '0;
 end else begin
  cnt_clear_q   <= cfg_cnt_clear;
  cnt_clearv_q  <= cfg_cnt_clearv;
  cnt_inc_4_q   <= cnt_inc_4_next;
  cnt4_q        <= cnt4_next;
  cnt5_q        <= cnt5_next;
 end
end

assign cnt_inc[0]     = pwrite_v     & phdr_db_out_data.invalid;            // 11:10 Posted SIF invalid writes
assign cnt_inc[1]     = ims_msix_w_v & ims_msix_w_ready &  ims_msix_w.ai;   // 13:12 AI    input
assign cnt_inc[2]     = ims_msix_w_v & ims_msix_w_ready & ~ims_msix_w.ai;   // 15:14 MSI-X input
assign cnt_inc[3]     = pwrite_v     & ~phdr_db_out_data.invalid;           // 17:16 Posted SIF writes

assign cnt_inc_4_next = {1'd0, sch_sm_drops_q}  +                           // 19:18 Posted SIF writes dropped (SM)
                        {1'd0, sch_clr_drops_q};                            //       (DIR CQ clear drops)

assign cnt_inc_5      = wbuf_appended_q;                                    // 21:20 Coalesced writes             

assign cnt4_next      = (cnt_clear_q)  ? {64{cnt_clearv_q}} :
                        (|cnt_inc_4_q) ? (cnt4_q + {60'd0, cnt_inc_4_q}) : cnt4_q;

assign cnt5_next      = (cnt_clear_q)  ? {64{cnt_clearv_q}} :
                        (|cnt_inc_5)   ? (cnt5_q + {62'd0, cnt_inc_5  }) : cnt5_q;

generate
 for (g=0; g<=3; g=g+1) begin: g_cnt

  hqm_AW_inc_64b_val i_cnt (

     .clk       (hqm_gated_clk)
    ,.rst_n     (hqm_gated_rst_n)
    ,.clr       (cnt_clear_q)
    ,.clrv      (cnt_clearv_q)
    ,.inc       (cnt_inc[g])
    ,.count     ({cfg_wbuf_cnts[11+(g*2)], cfg_wbuf_cnts[10+(g*2)]})
  );

 end
endgenerate

assign {cfg_wbuf_cnts[19], cfg_wbuf_cnts[18]} = cnt4_q;
assign {cfg_wbuf_cnts[21], cfg_wbuf_cnts[20]} = cnt5_q;

//-----------------------------------------------------------------------------------------------------
// Status

new_WBUF_STATUS_t   wbuf_status_next;
new_WBUF_STATUS_t   wbuf_status_q;
new_WBUF_STATUS2_t  wbuf_status2_next;
new_WBUF_STATUS2_t  wbuf_status2_q;

always_comb begin

 wbuf_status_next                  = '0;
 wbuf_status_next.SCH_P2_SOP       = sch_p2_hdr_q.sop;
 wbuf_status_next.SCH_P2_INT_V     = sch_p2_hdr_q.int_v;
 wbuf_status_next.SCH_P2_DATA_V    = sch_p2_hdr_q.data_v;
 wbuf_status_next.SCH_P2_HDR_V     = sch_p2_hdr_q.eop;
 wbuf_status_next.SCH_SM_STATE     = sch_sm_state_q;
 wbuf_status_next.PD_FIFO_AFULL    = '0;
 wbuf_status_next.PH_FIFO_AFULL    = '0;
 wbuf_status_next.SCH_CQ           = hcw_sched_out.w.user.cq;
 wbuf_status_next.SCH_BEAT         = hcw_sched_out.w.user.cq_wptr[1:0];
 wbuf_status_next.SCH_LDB          = hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb;
 wbuf_status_next.SCH_HCW_V        = hcw_sched_out.hcw_v;
 wbuf_status_next.SCH_INT_V        = hcw_sched_out.int_v;
 wbuf_status_next.SCH_P2_V         = sch_p2_v_q;
 wbuf_status_next.SCH_P1_V         = sch_p1_v_q;
 wbuf_status_next.SCH_P0_V         = sch_p0_v_q;

 wbuf_status2_next                 = '0;
 wbuf_status2_next.OPT_ERR         = '0;
 wbuf_status2_next.OPT_IN_PROG     = sch_sm_opt_in_prog_q;
 wbuf_status2_next.OPT_IN_PROG_CQ  = sch_sm_dir_cq_q;
 wbuf_status2_next.OPT_DATA_VALID  = sch_sm_dir_data_v_q;
 wbuf_status2_next.CQ_OCC_INT_BUSY = cq_occ_int_busy_q;
 wbuf_status2_next.ARB_HOLD        = arb_hold_q;
 wbuf_status2_next.ARB_WINNER      = arb_winner_q;
 wbuf_status2_next.ARB_REQS        = arb_reqs_q;

end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cq_occ_int_busy_q <= '0;
  wbuf_status_q     <= '0;
  wbuf_status2_q    <= '0;
 end else begin
  cq_occ_int_busy_q <= cq_occ_int_busy;
  wbuf_status_q     <= wbuf_status_next;
  wbuf_status2_q    <= wbuf_status2_next;
 end
end

assign wbuf_status  = wbuf_status_q;
assign wbuf_status2 = wbuf_status2_q;

assign wbuf_debug_next = {sch_p2_hdr_q.beats[2:0]
                         ,sch_p2_hdr_q.ldb
                         ,sch_p2_hdr_q.is_pf
                         ,sch_p2_hdr_q.vf[HQM_SYSTEM_VF_WIDTH-1:0]
                         ,sch_p2_hold
                         ,sch_p2_load
                         ,sch_p2_v_q
                         ,sch_p2_hdr_q.data_v
                         ,sch_p2_hdr_q.int_v
                         ,sch_p2_hdr_q.sop
                         ,sch_p2_hdr_q.eop
                         ,sch_hdr_v
                         ,sch_data_v
                         ,sch_data_first
                         ,sch_data_last
                         ,cq_occ_int_busy
                         ,1'b0
                         ,1'b0
                         ,ims_msix_arb_req
                         ,sch_arb_req
                         ,arb_winner_v
                         ,arb_winner
                         ,arb_hold_q
                         ,arb_winner_q
};

assign wbuf_idle_next = ~|{
                           sch_p0_v_q
                          ,sch_p1_v_q
                          ,sch_p2_v_q
                          ,sch_out_fifo_status.depth
                          ,(sch_sm_state != SCH_SM_IDLE)
                          ,sch_p3_sb_ecc_error_q
                          ,sch_p3_mb_ecc_error_q
                          ,phdr_db_out_v
                          ,sch_out_fifo_push_q
                          ,cq_occ_db_status[1:0]
};

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  wbuf_idle_q  <= '0;
  wbuf_debug_q <= '0;
 end else begin
  wbuf_idle_q  <= wbuf_idle_next;
  wbuf_debug_q <= wbuf_debug_next;
 end
end

assign wbuf_idle  = wbuf_idle_q;
assign wbuf_debug = wbuf_debug_q;

hqm_AW_agitate #(.SEED(32'h2230)) i_agitate_sch_out_fifo_afull (

        .clk                                (hqm_gated_clk),
        .rst_n                              (hqm_gated_rst_n),

        .control                            (wb_sch_out_afull_agitate_control),

        .in_agitate_value                   (1'b1),
        .in_data                            (sch_out_fifo_afull_raw),

        .in_stall_trigger                   (1'b1),
        .out_data                           (sch_out_fifo_afull)
);

//-----------------------------------------------------------------------------------------------------

endmodule // hqm_system_write_buffer
