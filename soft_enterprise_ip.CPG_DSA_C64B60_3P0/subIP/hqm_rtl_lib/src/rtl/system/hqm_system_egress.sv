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

module hqm_system_egress

         import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_system_type_pkg::*;

(

         input  logic                                           hqm_gated_clk
        ,input  logic                                           hqm_gated_rst_n

        ,input  logic                                           hqm_inp_gated_clk
        ,input  logic                                           hqm_inp_gated_rst_n

        ,input  logic                                           rx_sync_hcw_sched_enable

        ,output logic                                           rx_sync_hcw_sched_idle

        ,input  logic                                           rst_prep

        ,output logic                                           rst_done

        //---------------------------------------------------------------------------------------------
        // CFG interface

        ,input  hqm_system_egress_cfg_signal_t                  cfg_re
        ,input  hqm_system_egress_cfg_signal_t                  cfg_we
        ,input  logic   [10:0]                                  cfg_addr
        ,input  logic   [31:0]                                  cfg_wdata

        ,output hqm_system_egress_cfg_signal_t                  cfg_rvalid
        ,output hqm_system_egress_cfg_signal_t                  cfg_wvalid
        ,output hqm_system_egress_cfg_signal_t                  cfg_error
        ,output logic   [31:0]                                  cfg_rdata

        ,input  logic                                           cfg_int_parity_off
        ,input  logic                                           cfg_parity_off
        ,input  logic                                           cfg_residue_off
        ,input  logic                                           cfg_write_bad_parity
        ,input  logic   [4:0]                                   cfg_inj_par_err_egress
        ,input  logic                                           cfg_cnt_clear
        ,input  logic                                           cfg_cnt_clearv

        ,output new_EGRESS_LUT_ERR_t                            egress_lut_err
        ,output logic                                           egress_perr
        ,output logic                                           cq_addr_overflow_error
        ,output logic   [7:0]                                   cq_addr_overflow_syndrome

        ,output logic   [6:0]                                   hcw_sched_db_status

        ,output aw_fifo_status_t                                hcw_sch_fifo_status

        ,input  EG_HCW_SCHED_DB_AGITATE_CONTROL_t               eg_hcw_sched_db_agitate_control

        ,input  EGRESS_CTL_t                                    cfg_egress_ctl
        ,output new_EGRESS_STATUS_t                             egress_status
        ,output logic                                           egress_idle

        ,output logic [9:6] [31:0]                              cfg_egress_cnts

        //---------------------------------------------------------------------------------------------
        // CQ occupancy interrupt interface

        ,output logic                                           interrupt_w_req_ready

        ,input  interrupt_w_req_t                               interrupt_w_req
        ,input  logic                                           interrupt_w_req_valid

        //---------------------------------------------------------------------------------------------
        // HCW Sched interface from hqm_core

        ,output logic                                           hcw_sched_w_req_ready

        ,input  logic                                           hcw_sched_w_req_valid
        ,input  hcw_sched_w_req_t                               hcw_sched_w_req

        //---------------------------------------------------------------------------------------------
        // Core HCW Sched interface to write buffer

        ,input  logic                                           hcw_sched_out_ready

        ,output logic                                           hcw_sched_out_v
        ,output hqm_system_sch_data_out_t                       hcw_sched_out

        //---------------------------------------------------------------------------------------------
        // Memory interface

        ,output hqm_system_memi_lut_dir_cq_pasid_t              memi_lut_dir_cq_pasid
        ,input  hqm_system_memo_lut_dir_cq_pasid_t              memo_lut_dir_cq_pasid

        ,output hqm_system_memi_lut_ldb_cq_pasid_t              memi_lut_ldb_cq_pasid
        ,input  hqm_system_memo_lut_ldb_cq_pasid_t              memo_lut_ldb_cq_pasid

        ,output hqm_system_memi_lut_dir_cq_addr_l_t             memi_lut_dir_cq_addr_l
        ,input  hqm_system_memo_lut_dir_cq_addr_l_t             memo_lut_dir_cq_addr_l

        ,output hqm_system_memi_lut_ldb_cq_addr_l_t             memi_lut_ldb_cq_addr_l
        ,input  hqm_system_memo_lut_ldb_cq_addr_l_t             memo_lut_ldb_cq_addr_l

        ,output hqm_system_memi_lut_dir_cq_addr_u_t             memi_lut_dir_cq_addr_u
        ,input  hqm_system_memo_lut_dir_cq_addr_u_t             memo_lut_dir_cq_addr_u

        ,output hqm_system_memi_lut_ldb_cq_addr_u_t             memi_lut_ldb_cq_addr_u
        ,input  hqm_system_memo_lut_ldb_cq_addr_u_t             memo_lut_ldb_cq_addr_u

        ,output hqm_system_memi_lut_dir_cq2vf_pf_ro_t           memi_lut_dir_cq2vf_pf_ro
        ,input  hqm_system_memo_lut_dir_cq2vf_pf_ro_t           memo_lut_dir_cq2vf_pf_ro

        ,output hqm_system_memi_lut_ldb_cq2vf_pf_ro_t           memi_lut_ldb_cq2vf_pf_ro
        ,input  hqm_system_memo_lut_ldb_cq2vf_pf_ro_t           memo_lut_ldb_cq2vf_pf_ro

        ,output hqm_system_memi_lut_ldb_qid2vqid_t              memi_lut_ldb_qid2vqid
        ,input  hqm_system_memo_lut_ldb_qid2vqid_t              memo_lut_ldb_qid2vqid
);

//-----------------------------------------------------------------------------------------------------

logic   [3:0]                           init_q;
logic   [9:0]                           init_done;
logic                                   init_done_q;

logic                                   cfg_write_bad_parity_q;

hqm_system_egress_cfg_signal_t          cfg_re_next;
hqm_system_egress_cfg_signal_t          cfg_re_q;
hqm_system_egress_cfg_signal_t          cfg_re_v;
hqm_system_egress_cfg_signal_t          cfg_we_next;
hqm_system_egress_cfg_signal_t          cfg_we_q;
hqm_system_egress_cfg_signal_t          cfg_we_v;
logic   [10:0]                          cfg_addr_q;
logic   [31:0]                          cfg_wdata_q;
logic                                   cfg_taken_next;
logic                                   cfg_taken_q;
logic                                   cfg_taken_p0;
logic                                   cfg_taken_p3;

logic                                   cfg_re_in;
logic                                   cfg_we_in;
logic                                   cfg_re_p2;
logic                                   cfg_we_p2;

hqm_system_egress_cfg_data_t            cfg_rdata_lut;
logic                                   cfg_rdata_v_p2_next;
logic                                   cfg_rdata_v_p5_next;
logic                                   cfg_rdata_v_p2_q;
logic                                   cfg_rdata_v_p5_q;
logic   [31:0]                          cfg_rdata_p2_next;
logic   [31:0]                          cfg_rdata_p2_q;
logic   [31:0]                          cfg_rdata_p5_next;
logic   [31:0]                          cfg_rdata_p5_q;
logic   [31:0]                          cfg_rdata_next;
logic   [31:0]                          cfg_rdata_q;
logic                                   cfg_rvalid_next;
logic                                   cfg_wvalid_next;
logic                                   cfg_rvalid_q;
logic                                   cfg_wvalid_q;

logic   [4:0]                           intf_perr_next;
logic   [4:0]                           intf_perr_q;

logic                                   hcw_sched_req_in_ready;
logic                                   hcw_sched_req_in_v;
logic   [$bits(hcw_sched_w_req)+
         $bits(interrupt_w_req)+2:0]    hcw_sched_req_in;

logic                                   hcw_sched_req_out_ready;
logic                                   hcw_sched_req_out_v;
logic                                   hcw_sched_req_out_v_limited;
logic   [$bits(hcw_sched_w_req)+
         $bits(interrupt_w_req)+2:0]    hcw_sched_req_out;

logic                                   hcw_sched_w_v;
hcw_sched_w_req_t                       hcw_sched_w_rx;
hcw_sched_w_req_t                       hcw_sched_w;

logic                                   interrupt_w_v;
interrupt_w_req_t                       interrupt_w_rx;
interrupt_w_req_t                       interrupt_w;

logic                                   pl_parity;

logic                                   p0_hold;
logic                                   p0_load;
logic                                   p0_v_next;
logic                                   p0_v_q;
logic                                   p0_cfg_next;
logic                                   p0_cfg_q;
logic                                   p0_cfg_we_q;
hqm_system_sch_data_in_t                p0_data_next;
hqm_system_sch_data_in_t                p0_data_q;

logic                                   p1_hold;
logic                                   p1_load;
logic                                   p1_v_q;
logic                                   p1_cfg_q;
logic                                   p1_cfg_we_q;
hqm_system_sch_data_in_t                p1_data_q;

logic                                   p2_hold;
logic                                   p2_load;
logic                                   p2_v_q;
logic                                   p2_v;
logic                                   p2_taken;
logic                                   p2_cfg_q;
logic   [1:0]                           p2_cfg_we_q;
hqm_system_sch_data_in_t                p2_data_q;
logic   [63:6]                          p2_cq_addr_dir;
logic   [63:6]                          p2_cq_addr_ldb;
logic   [63:6]                          p2_cq_addr;
logic                                   p2_cq_fmt;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]       p2_vf_dir;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]       p2_vf_ldb;
logic   [HQM_SYSTEM_VF_WIDTH-1:0]       p2_vf;
hqm_pasidtlp_t                          p2_cq_pasidtlp_dir;
hqm_pasidtlp_t                          p2_cq_pasidtlp_ldb;
hqm_pasidtlp_t                          p2_cq_pasidtlp;
logic                                   p2_ro_dir;
logic                                   p2_ro_ldb;
logic                                   p2_ro;
logic                                   p2_is_pf_dir;
logic                                   p2_is_pf_ldb;
logic                                   p2_is_pf;
logic                                   p2_perr;
logic   [1:0]                           p2_cq_addr_res;
logic   [1:0]                           p2_cq_wptr_res;
logic   [1:0]                           p2_cq_sum_res;
logic                                   p2_parity;

logic   [27:0]                          addr_scaled;

logic                                   p3_hold;
logic                                   p3_load;
logic                                   p3_v_next;
logic                                   p3_v_q;
logic                                   p3_cfg_next;
logic                                   p3_cfg_q;
logic                                   p3_cfg_we_q;
hqm_system_sch_data_p35_t               p3_data_next;
hqm_system_sch_data_p35_t               p3_data_q;
logic                                   p3_lut_hold;
logic   [63:4]                          p3_addr_next;
logic                                   p3_carry_next;
logic                                   p3_carry_q;

logic                                   p4_hold;
logic                                   p4_load;
logic                                   p4_v_q;
logic                                   p4_cfg_q;
logic                                   p4_cfg_we_q;
hqm_system_sch_data_p35_t               p4_data_next;
hqm_system_sch_data_p35_t               p4_data_q;
logic   [63:4]                          p4_addr_next;
logic                                   p4_carry_next;
logic                                   p4_carry_q;

logic                                   p5_hold;
logic                                   p5_load;
logic                                   p5_v_q;
logic                                   p5_v;
logic                                   p5_cfg_q;
logic   [1:0]                           p5_cfg_we_q;
hqm_system_sch_data_p35_t               p5_data_q;
logic   [HQM_SYSTEM_LDB_QID_WIDTH-1:0]  p5_vqid;
logic                                   p5_carry_q;
logic                                   p5_err;
logic                                   p5_dperr;
logic                                   p5_hperr;
logic                                   p5_hrerr;
logic                                   p5_pperr;
logic                                   p5_iperr;
logic                                   p5_res_check;
logic   [1:0]                           p5_cq_addr_res;
logic                                   p5_addr_overflow;
logic                                   p5_error;
logic   [6:0]                           p5_vqid_scaled;
outbound_hcw_t                          p5_hcw_out;
logic   [7:0]                           p5_hcw_out_ecc_h;
logic   [7:0]                           p5_hcw_out_ecc_l;
logic   [4:0]                           p5_inj_par_err_q;
logic   [4:0]                           p5_inj_par_err_last_q;

logic                                   p6_load;

logic                                   sch_lut_hold;

logic                                   sched_out_ready;

hqm_system_egress_cfg_signal_t          lut_err;
hqm_system_egress_cfg_signal_t          lut_err_next;
hqm_system_egress_cfg_signal_t          lut_err_q;
logic                                   perr_next;
logic                                   perr_q;

logic                                   hcw_sched_ready;
logic                                   hcw_sched_v;
logic                                   agg_hcw_sched_ready;
logic                                   agg_hcw_sched_v;
hqm_system_sch_data_out_t               hcw_sched;

logic                                   egress_idle_next;
logic                                   egress_idle_q;

hqm_system_memi_lut_dir_cq_fmt_t        memi_lut_dir_cq_fmt;
hqm_system_memo_lut_dir_cq_fmt_t        memo_lut_dir_cq_fmt;

genvar                                  g;

//-----------------------------------------------------------------------------------------------------
// Decode cfg access to individual memories here

assign cfg_re_next    = cfg_re & ~cfg_rvalid;
assign cfg_we_next    = cfg_we & ~cfg_wvalid;
assign cfg_taken_next = (|{cfg_taken_q, cfg_taken_p0, cfg_taken_p3}) &
                        ~(cfg_rvalid_q | cfg_wvalid_q);

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  init_q      <= '0;
  init_done_q <= '0;
  cfg_re_q    <= '0;
  cfg_we_q    <= '0;
  cfg_taken_q <= '0;
 end else begin
  init_q      <= {1'b1, init_q[3:1]};
  init_done_q <= (&init_done);
  if (init_done_q) begin
   cfg_re_q   <= cfg_re_next;
   cfg_we_q   <= cfg_we_next;
  end
  cfg_taken_q <= cfg_taken_next;
 end
end

assign rst_done = init_done_q;

always_ff @(posedge hqm_gated_clk) begin
 if (~cfg_taken_q) cfg_addr_q  <= cfg_addr;
 if (~cfg_taken_q) cfg_wdata_q <= cfg_wdata;
 cfg_write_bad_parity_q        <= cfg_write_bad_parity;
end

assign cfg_re_in = (|{cfg_re_q.dir_cq_addr_l
                     ,cfg_re_q.ldb_cq_addr_l
                     ,cfg_re_q.dir_cq_addr_u
                     ,cfg_re_q.ldb_cq_addr_u
                     ,cfg_re_q.dir_cq_pasid
                     ,cfg_re_q.ldb_cq_pasid
                     ,cfg_re_q.dir_cq_fmt
                     ,cfg_re_q.dir_cq2vf_pf_ro
                     ,cfg_re_q.ldb_cq2vf_pf_ro
}) & (~cfg_taken_q);

assign cfg_we_in = (|{cfg_we_q.dir_cq_addr_l
                     ,cfg_we_q.ldb_cq_addr_l
                     ,cfg_we_q.dir_cq_addr_u
                     ,cfg_we_q.ldb_cq_addr_u
                     ,cfg_we_q.dir_cq_pasid
                     ,cfg_we_q.ldb_cq_pasid
                     ,cfg_we_q.dir_cq_fmt
                     ,cfg_we_q.dir_cq2vf_pf_ro
                     ,cfg_we_q.ldb_cq2vf_pf_ro
}) & (~cfg_taken_q);

assign cfg_re_p2 = cfg_re_q.ldb_qid2vqid & ~cfg_taken_q;

assign cfg_we_p2 = cfg_we_q.ldb_qid2vqid & ~cfg_taken_q;

assign cfg_re_v.dir_cq_addr_l   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_cq_addr_l;
assign cfg_re_v.ldb_cq_addr_l   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_cq_addr_l;
assign cfg_re_v.dir_cq_addr_u   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_cq_addr_u;
assign cfg_re_v.ldb_cq_addr_u   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_cq_addr_u;
assign cfg_re_v.dir_cq_pasid    = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_cq_pasid;
assign cfg_re_v.ldb_cq_pasid    = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_cq_pasid;
assign cfg_re_v.dir_cq_fmt      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_cq_fmt;
assign cfg_re_v.dir_cq2vf_pf_ro = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.dir_cq2vf_pf_ro;
assign cfg_re_v.ldb_cq2vf_pf_ro = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_cq2vf_pf_ro;
                                            
assign cfg_we_v.dir_cq_addr_l   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_cq_addr_l;
assign cfg_we_v.ldb_cq_addr_l   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_cq_addr_l;
assign cfg_we_v.dir_cq_addr_u   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_cq_addr_u;
assign cfg_we_v.ldb_cq_addr_u   = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_cq_addr_u;
assign cfg_we_v.dir_cq_pasid    = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_cq_pasid;
assign cfg_we_v.ldb_cq_pasid    = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_cq_pasid;
assign cfg_we_v.dir_cq_fmt      = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_cq_fmt;
assign cfg_we_v.dir_cq2vf_pf_ro = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.dir_cq2vf_pf_ro;
assign cfg_we_v.ldb_cq2vf_pf_ro = (~|{p0_v_q, p1_v_q, p2_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_cq2vf_pf_ro;
                                            
assign cfg_re_v.ldb_qid2vqid    = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_re_q.ldb_qid2vqid;
                                    
assign cfg_we_v.ldb_qid2vqid    = (~|{p3_v_q, p4_v_q, p5_v_q}) & ~cfg_taken_q & cfg_we_q.ldb_qid2vqid;

//-----------------------------------------------------------------------------------------------------
// OR together all the P2 and P5 cfg read data paths
// Can then OR together the p2 and p5 lookups into one cfg response

// Make the PASIDTLP PRIV_REQ and EXE_REQ bits look RO zero

DIR_CQ_PASID_t  cfg_rdata_lut_dir_cq_pasid;
LDB_CQ_PASID_t  cfg_rdata_lut_ldb_cq_pasid;

always_comb begin

    cfg_rdata_lut_dir_cq_pasid = cfg_rdata_lut.dir_cq_pasid;
    cfg_rdata_lut_ldb_cq_pasid = cfg_rdata_lut.ldb_cq_pasid;

    cfg_rdata_lut_dir_cq_pasid.PRIV_REQ = '0;
    cfg_rdata_lut_ldb_cq_pasid.PRIV_REQ = '0;

    cfg_rdata_lut_dir_cq_pasid.EXE_REQ  = '0;
    cfg_rdata_lut_ldb_cq_pasid.EXE_REQ  = '0;

end

assign cfg_rdata_p2_next    = cfg_rdata_lut.dir_cq_addr_l   | cfg_rdata_lut.ldb_cq_addr_l |
                              cfg_rdata_lut.dir_cq_addr_u   | cfg_rdata_lut.ldb_cq_addr_u |
                              cfg_rdata_lut_dir_cq_pasid    | cfg_rdata_lut_ldb_cq_pasid  |
                              cfg_rdata_lut.dir_cq_fmt      |
                              cfg_rdata_lut.dir_cq2vf_pf_ro | cfg_rdata_lut.ldb_cq2vf_pf_ro;

assign cfg_rdata_p5_next    = cfg_rdata_lut.ldb_qid2vqid;

// CFG read data is valid when the memory output pipeline stage valid (p2/5_v_q) is asserted and
// the CFG flop is set but the write indication (p2/5_cfg_we_q) is not asserted.  Can ack CFG
// writes when the memory output pipeline stage is valid and the write indication is asserted.

assign cfg_rdata_v_p5_next    = p5_v_q    & p5_cfg_q    & ~(|p5_cfg_we_q);
assign cfg_rdata_v_p2_next    = p2_v_q    & p2_cfg_q    & ~(|p2_cfg_we_q);

assign cfg_rvalid_next     = cfg_rdata_v_p2_q | cfg_rdata_v_p5_q;
assign cfg_wvalid_next     = (&{p2_v_q,p2_cfg_we_q}) | (&{p5_v_q,p5_cfg_we_q});

assign cfg_rdata_next      = (cfg_rdata_p2_q    & {32{cfg_rdata_v_p2_q}})    |
                             (cfg_rdata_p5_q    & {32{cfg_rdata_v_p5_q}});

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cfg_rdata_v_p2_q    <= '0;
  cfg_rdata_v_p5_q    <= '0;
  cfg_rvalid_q        <= '0;
  cfg_wvalid_q        <= '0;
  cfg_rdata_p2_q      <= '0;
  cfg_rdata_p5_q      <= '0;
  cfg_rdata_q         <= '0;
 end else begin
  cfg_rdata_v_p2_q    <= cfg_rdata_v_p2_next;
  cfg_rdata_v_p5_q    <= cfg_rdata_v_p5_next;
  cfg_rvalid_q        <= cfg_rvalid_next;
  cfg_wvalid_q        <= cfg_wvalid_next;
  if (cfg_rdata_v_p2_next)    cfg_rdata_p2_q    <= cfg_rdata_p2_next;
  if (cfg_rdata_v_p5_next)    cfg_rdata_p5_q    <= cfg_rdata_p5_next;
  if (cfg_rvalid_next)        cfg_rdata_q       <= cfg_rdata_next;
 end
end

assign cfg_rvalid = cfg_re_q & {$bits(cfg_rvalid){cfg_rvalid_q}};
assign cfg_wvalid = cfg_we_q & {$bits(cfg_wvalid){cfg_wvalid_q}};
assign cfg_error  = (cfg_re_q | cfg_we_q) & {$bits(cfg_error){1'b0}};        // For now
assign cfg_rdata  = cfg_rdata_q;

//-----------------------------------------------------------------------------------------------------
// Buffer hqm_core interrupt and hcw_sched inputs
// Need to keep these ordered with respect to each other, so they share the same buffer.

logic                                                               rx_sync_hcw_sched_re;
logic                                                               rx_sync_hcw_sched_we;
logic   [1:0]                                                       rx_sync_hcw_sched_raddr;
logic   [1:0]                                                       rx_sync_hcw_sched_waddr;
logic   [$bits(hcw_sched_w_req)+$bits(interrupt_w_req)+2:0]         rx_sync_hcw_sched_wdata;
logic   [$bits(hcw_sched_w_req)+$bits(interrupt_w_req)+2:0]         rx_sync_hcw_sched_rdata;
logic   [3:0][$bits(hcw_sched_w_req)+$bits(interrupt_w_req)+2:0]    rx_sync_hcw_sched_mem;

assign hcw_sched_req_in_v =   interrupt_w_req_valid | hcw_sched_w_req_valid;

// Generate parity on the 2 valid bits

assign hcw_sched_req_in   = {(interrupt_w_req_valid ^ hcw_sched_w_req_valid),
                              interrupt_w_req_valid,  hcw_sched_w_req_valid,
                              interrupt_w_req,        hcw_sched_w_req};

hqm_AW_rx_sync #(.WIDTH($bits(hcw_sched_w_req)+$bits(interrupt_w_req)+3)) i_hcw_sched_rx_sync (

     .hqm_inp_gated_clk         (hqm_inp_gated_clk)
    ,.hqm_inp_gated_rst_n       (hqm_inp_gated_rst_n)

    ,.status                    (hcw_sch_fifo_status)
    ,.enable                    (rx_sync_hcw_sched_enable)
    ,.idle                      (rx_sync_hcw_sched_idle)
    ,.rst_prep                  (rst_prep)

    ,.in_ready                  (hcw_sched_req_in_ready)

    ,.in_valid                  (hcw_sched_req_in_v)
    ,.in_data                   (hcw_sched_req_in)

    ,.out_ready                 (hcw_sched_req_out_ready)

    ,.out_valid                 (hcw_sched_req_out_v)
    ,.out_data                  (hcw_sched_req_out)

    ,.mem_re                    (rx_sync_hcw_sched_re)
    ,.mem_raddr                 (rx_sync_hcw_sched_raddr)
    ,.mem_we                    (rx_sync_hcw_sched_we)
    ,.mem_waddr                 (rx_sync_hcw_sched_waddr)
    ,.mem_wdata                 (rx_sync_hcw_sched_wdata)
    ,.mem_rdata                 (rx_sync_hcw_sched_rdata)
);

always_ff @(posedge hqm_inp_gated_clk) begin
 if (rx_sync_hcw_sched_we) rx_sync_hcw_sched_mem[rx_sync_hcw_sched_waddr] <= rx_sync_hcw_sched_wdata;   
 if (rx_sync_hcw_sched_re) rx_sync_hcw_sched_rdata <= rx_sync_hcw_sched_mem[rx_sync_hcw_sched_raddr];
end

assign {pl_parity, interrupt_w_v, hcw_sched_w_v, interrupt_w_rx, hcw_sched_w_rx} = hcw_sched_req_out;

assign hcw_sched_w_req_ready = hcw_sched_req_in_ready;
assign interrupt_w_req_ready = hcw_sched_req_in_ready;

always_comb begin

 // These have odd parity by default

 interrupt_w                            = '0;
 interrupt_w.parity                     = '1;
 hcw_sched_w                            = '0;
 hcw_sched_w.user.hqm_core_flags.parity = '1;
 hcw_sched_w.user.hcw_parity            = '1;

 if (interrupt_w_v) interrupt_w = interrupt_w_rx;
 if (hcw_sched_w_v) hcw_sched_w = hcw_sched_w_rx;

end

// Rate limit the schedule pipeline

hqm_AW_pipe_rate_limit #(.WIDTH(1), .DEPTH(7)) i_sch_rate_limit (   

     .cfg           (cfg_egress_ctl.SCH_RATE_LIMIT)
    ,.pipe_v        ({hcw_sched_out_v, p5_v_q, p4_v_q, p3_v_q, p2_v_q, p1_v_q, p0_v_q})

    ,.v_in          (hcw_sched_req_out_v)

    ,.v_out         (hcw_sched_req_out_v_limited)
);

assign hcw_sched_req_out_ready = init_done_q & hcw_sched_req_out_v_limited & ~(p0_cfg_next | p0_hold);

//-----------------------------------------------------------------------------------------------------
// P0
//-----------------------------------------------------------------------------------------------------

// Each pipeline stage can advance as long as the next pipeline stage is either not valid or is valid
// but is not holding.  The exception is CFG writes which, due to the fact that we may be doing a
// read-modify-write, may need to stall the pipeline above the access for at least an additional 3
// clock cycles over a normal access (or CFG read access).  The memory accesses occur in pipeline
// stages 0, and 3.  For a CFG RMW, p0/3 is reading the memory, p1/4 has valid memory output
// data, p2/5 registers that read data, and the next cycle we are writing the memory with the modified
// data; so we need to stall for those 3 additional stages.  A p*_cfg_q flop tracks that the access is
// a CFG access and blocks any CFG access from propagating past stages p2/5 and keeps holds from
// propagating backwards from stages p3/output to stages p2/5.  A p*_cfg_we_q flop tracks
// that the access is a CFG write.  Adding the 3 clock stall by allowing p0/3_cfg_we_q to load
// as an indication of how many cycles we've stalled (when both bits of p2/5_cfg_we_q are set, we
// have stalled for the required amount of clocks and nothing further can hold up the CFG RMW, so
// we can set the downstream valid (P1/4_v_q) then, and let it terminate at the P2/5 stages).
// So the code below for P0, and further on for P3, forces the upstream hold (P0/3_hold)
// and prevents the setting of the P1/4_v_q based on the state of the p*_cfg_we_q flops.

assign p0_cfg_next = cfg_re_in | cfg_we_in;

assign p0_v_next   = cfg_taken_p0 | hcw_sched_req_out_ready;

assign p0_hold = p0_v_q & (p1_hold | (p0_cfg_we_q & ~(&p2_cfg_we_q)));
assign p0_load = p0_v_next;

assign cfg_taken_p0 = p0_cfg_next & ~|{p0_v_q, p1_v_q, p2_v_q};

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p0_v_q      <= '0;
  p0_cfg_q    <= '0;
  p0_cfg_we_q <= '0;
 end else if (~p0_hold) begin
  p0_v_q      <= p0_v_next;
  p0_cfg_q    <= p0_cfg_next;
  p0_cfg_we_q <= p0_v_next & cfg_we_in;
 end
end

always_comb begin
 p0_data_next.parity = pl_parity;
 p0_data_next.int_v  = hcw_sched_req_out_ready & interrupt_w_v;
 p0_data_next.int_d  = interrupt_w;
 p0_data_next.hcw_v  = hcw_sched_req_out_ready & hcw_sched_w_v;
 p0_data_next.w      = hcw_sched_w;
end

always_ff @(posedge hqm_gated_clk) begin
 if (p0_load) begin
  if (~p0_cfg_next) p0_data_q <= p0_data_next;
 end
end

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

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ADDR_L)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_L)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_L)

) i_lut_dir_cq_addr_l (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[0])

        ,.cfg_re                (cfg_re_v.dir_cq_addr_l)
        ,.cfg_we                (cfg_we_v.dir_cq_addr_l)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_L-1:0])
        ,.cfg_wdata             (cfg_wdata_q[31:(32-HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_L)])                  // left justified

        ,.cfg_rdata             ({cfg_rdata_lut.dir_cq_addr_l[(31-HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_L):0]   // left justified
                                 ,cfg_rdata_lut.dir_cq_addr_l[31:(32-HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_L)]  // left justified
                                })

        ,.memi                  (memi_lut_dir_cq_addr_l)

        ,.memo                  (memo_lut_dir_cq_addr_l)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)                

        ,.lut_rdata             (p2_cq_addr_dir[31:6])
        ,.lut_perr              (lut_err.dir_cq_addr_l)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ADDR_L)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_L)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_L)

) i_lut_ldb_cq_addr_l (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[1])

        ,.cfg_re                (cfg_re_v.ldb_cq_addr_l)
        ,.cfg_we                (cfg_we_v.ldb_cq_addr_l)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_L-1:0])
        ,.cfg_wdata             (cfg_wdata_q[31:(32-HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_L)])                  // left justified

        ,.cfg_rdata             ({cfg_rdata_lut.ldb_cq_addr_l[(31-HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_L):0]   // left justified
                                 ,cfg_rdata_lut.ldb_cq_addr_l[31:(32-HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_L)]  // left justified
                                })

        ,.memi                  (memi_lut_ldb_cq_addr_l)

        ,.memo                  (memo_lut_ldb_cq_addr_l)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (~hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)               

        ,.lut_rdata             (p2_cq_addr_ldb[31:6])
        ,.lut_perr              (lut_err.ldb_cq_addr_l)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ADDR_U)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_U)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_U)

) i_lut_dir_cq_addr_u (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[2])

        ,.cfg_re                (cfg_re_v.dir_cq_addr_u)
        ,.cfg_we                (cfg_we_v.dir_cq_addr_u)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_U-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_U-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_cq_addr_u)

        ,.memi                  (memi_lut_dir_cq_addr_u)

        ,.memo                  (memo_lut_dir_cq_addr_u)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)            

        ,.lut_rdata             (p2_cq_addr_dir[63:32])
        ,.lut_perr              (lut_err.dir_cq_addr_u)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ADDR_U)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_U)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_U)

) i_lut_ldb_cq_addr_u (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[3])

        ,.cfg_re                (cfg_re_v.ldb_cq_addr_u)
        ,.cfg_we                (cfg_we_v.ldb_cq_addr_u)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_U-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_U-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_cq_addr_u)

        ,.memi                  (memi_lut_ldb_cq_addr_u)

        ,.memo                  (memo_lut_ldb_cq_addr_u)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (~hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)           

        ,.lut_rdata             (p2_cq_addr_ldb[63:32])
        ,.lut_perr              (lut_err.ldb_cq_addr_u)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_FMT)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT)

) i_lut_dir_cq_fmt (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[4])

        ,.cfg_re                (cfg_re_v.dir_cq_fmt)
        ,.cfg_we                (cfg_we_v.dir_cq_fmt)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_FMT-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_FMT-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_cq_fmt)

        ,.memi                  (memi_lut_dir_cq_fmt)

        ,.memo                  (memo_lut_dir_cq_fmt)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)            

        ,.lut_rdata             (p2_cq_fmt)
        ,.lut_perr              (lut_err.dir_cq_fmt)

        ,.lut_hold              (p3_lut_hold)
);

// Using flops for this small memory

logic [(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT /
        HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT)-1:0]
      [ HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_FMT-1:0]      lut_dir_cq_fmt_mem;

logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_FMT-1:0]       lut_dir_cq_fmt_mem_scaled;
logic [(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT)-1:0]
      [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_FMT-1:0]       lut_dir_cq_fmt_mem_next;

always_comb begin: scale_lut_dir_cq_fmt_mem

 for (int i=0; i<(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT); i=i+1) begin

  lut_dir_cq_fmt_mem_scaled[i] = '0;

  if (i < (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT/HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT)) begin
   lut_dir_cq_fmt_mem_scaled[i] = lut_dir_cq_fmt_mem[i];
  end

 end

 lut_dir_cq_fmt_mem_next = lut_dir_cq_fmt_mem_scaled;

 if (memi_lut_dir_cq_fmt.we &
     ({{(32-HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT){1'b0}}, memi_lut_dir_cq_fmt.addr} <
      (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT/HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT))) begin
  lut_dir_cq_fmt_mem_next[memi_lut_dir_cq_fmt.addr] = memi_lut_dir_cq_fmt.wdata;    
 end

end

always_ff @(posedge hqm_gated_clk) begin: block_lut_dir_cq_fmt_mem
 if (memi_lut_dir_cq_fmt.re) begin
  memo_lut_dir_cq_fmt.rdata <= lut_dir_cq_fmt_mem_scaled[memi_lut_dir_cq_fmt.addr];
 end
 for (int i=0; i<(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT/HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT); i=i+1) begin
  lut_dir_cq_fmt_mem[i] <= lut_dir_cq_fmt_mem_next[i];
 end
end

generate

 if ((HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT/HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT) !=
     (1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT)) begin: g_unused_lut_dir_cq_fmt

  logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_FMT-1:0] unused_lut_dir_cq_fmt;

  always_comb begin: p_unused_lut_dir_cq_fmt
   unused_lut_dir_cq_fmt = '0;
   for (int i=(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT/HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT);
       i<(1<<HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT); i=i+1) begin
    unused_lut_dir_cq_fmt |= lut_dir_cq_fmt_mem_next[i];
   end
  end

  hqm_AW_unused_bits i_unused_lut_dir_cq_fmt (.a(|unused_lut_dir_cq_fmt));          

 end

endgenerate

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ2VF_PF_RO)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ2VF_PF_RO)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ2VF_PF_RO)

) i_lut_dir_cq2vf_pf_ro (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[5])

        ,.cfg_re                (cfg_re_v.dir_cq2vf_pf_ro)
        ,.cfg_we                (cfg_we_v.dir_cq2vf_pf_ro)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ2VF_PF_RO-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_CQ2VF_PF_RO-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_cq2vf_pf_ro)

        ,.memi                  (memi_lut_dir_cq2vf_pf_ro)

        ,.memo                  (memo_lut_dir_cq2vf_pf_ro)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)            

        ,.lut_rdata             ({p2_ro_dir, p2_is_pf_dir, p2_vf_dir})
        ,.lut_perr              (lut_err.dir_cq2vf_pf_ro)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ2VF_PF_RO)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ2VF_PF_RO)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ2VF_PF_RO)

) i_lut_ldb_cq2vf_pf_ro (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[6])

        ,.cfg_re                (cfg_re_v.ldb_cq2vf_pf_ro)
        ,.cfg_we                (cfg_we_v.ldb_cq2vf_pf_ro)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ2VF_PF_RO-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_CQ2VF_PF_RO-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_cq2vf_pf_ro)

        ,.memi                  (memi_lut_ldb_cq2vf_pf_ro)

        ,.memo                  (memo_lut_ldb_cq2vf_pf_ro)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (~hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)           

        ,.lut_rdata             ({p2_ro_ldb, p2_is_pf_ldb, p2_vf_ldb})
        ,.lut_perr              (lut_err.ldb_cq2vf_pf_ro)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_DIR_CQ_PASID)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_PASID)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_DIR_CQ_PASID)

) i_lut_dir_cq_pasid (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[7])

        ,.cfg_re                (cfg_re_v.dir_cq_pasid)
        ,.cfg_we                (cfg_we_v.dir_cq_pasid)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_PASID-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_PASID-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.dir_cq_pasid)

        ,.memi                  (memi_lut_dir_cq_pasid)

        ,.memo                  (memo_lut_dir_cq_pasid)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
        ,.lut_nord              (hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)                

        ,.lut_rdata             (p2_cq_pasidtlp_dir)
        ,.lut_perr              (lut_err.dir_cq_pasid)

        ,.lut_hold              (p3_lut_hold)
);

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_CQ_PASID)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_PASID)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_CQ_PASID)

) i_lut_ldb_cq_pasid (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[8])

        ,.cfg_re                (cfg_re_v.ldb_cq_pasid)
        ,.cfg_we                (cfg_we_v.ldb_cq_pasid)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_PASID-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_PASID-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_cq_pasid)

        ,.memi                  (memi_lut_ldb_cq_pasid)

        ,.memo                  (memo_lut_ldb_cq_pasid)

        ,.lut_re                (hcw_sched_req_out_ready)
        ,.lut_addr              (hcw_sched_w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0])
        ,.lut_nord              (~hcw_sched_w.user.hqm_core_flags.cq_is_ldb | ~hcw_sched_w_v)               

        ,.lut_rdata             (p2_cq_pasidtlp_ldb)
        ,.lut_perr              (lut_err.ldb_cq_pasid)

        ,.lut_hold              (p3_lut_hold)
);

assign p2_cq_addr     = p2_cq_addr_ldb     | p2_cq_addr_dir;
assign p2_ro          = p2_ro_ldb          | p2_ro_dir;
assign p2_is_pf       = p2_is_pf_ldb       | p2_is_pf_dir;
assign p2_vf          = p2_vf_ldb          | p2_vf_dir;
assign p2_cq_pasidtlp = p2_cq_pasidtlp_ldb | p2_cq_pasidtlp_dir;

assign p2_perr        = p2_v & p2_data_q.hcw_v & ~cfg_parity_off &
                            (|{lut_err.ldb_cq_pasid
                              ,lut_err.ldb_cq_addr_l
                              ,lut_err.ldb_cq_addr_u
                              ,lut_err.ldb_cq2vf_pf_ro
                              ,lut_err.dir_cq_pasid
                              ,lut_err.dir_cq_addr_l
                              ,lut_err.dir_cq_addr_u
                              ,lut_err.dir_cq_fmt
                              ,lut_err.dir_cq2vf_pf_ro
                            });

hqm_AW_residue_gen #(.WIDTH($bits(p2_cq_addr))) i_p2_cq_addr_res (

     .a     (p2_cq_addr)
    ,.r     (p2_cq_addr_res)
);

hqm_AW_residue_gen #(.WIDTH($bits(p2_data_q.w.user.cq_wptr))) i_p2_cq_wptr_res (

     .a     (p2_data_q.w.user.cq_wptr)
    ,.r     (p2_cq_wptr_res)
);

hqm_AW_residue_add i_p2_cq_sum_res (

     .a     (p2_cq_addr_res)
    ,.b     (p2_cq_wptr_res)
    ,.r     (p2_cq_sum_res)
);

// Add the ro, is_pf, vf, pasidtlp, and fmt bits to the pipeline parity

assign p2_parity = ^{p2_data_q.parity, p2_ro, p2_is_pf, p2_vf, p2_cq_pasidtlp, p2_cq_fmt};

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

hqm_AW_width_scale #(.A_WIDTH($bits(p2_data_q.w.user.cq_wptr)), .Z_WIDTH(28)) i_addr_scaled (

         .a     (p2_data_q.w.user.cq_wptr)
        ,.z     (addr_scaled)
);

assign p3_addr_next[63:32] = p2_cq_addr[63:32];

hqm_AW_add #(.WIDTH(28)) i_p3_addr_sum_ls (

     .a     ({p2_cq_addr[31:6], 2'd0})
    ,.b     (addr_scaled)
    ,.ci    ('0)
    ,.sum   (p3_addr_next[31:4])
    ,.co    (p3_carry_next)
);

always_comb begin
 p3_data_next              = '0;
 p3_data_next.int_v        = p2_data_q.int_v;
 p3_data_next.int_d        = p2_data_q.int_d;
 p3_data_next.hcw_v        = p2_data_q.hcw_v;
 p3_data_next.w            = p2_data_q.w;
 p3_data_next.cq_addr      = p3_addr_next;
 p3_data_next.cq_addr_res  = p2_cq_sum_res;
 p3_data_next.parity       = p2_parity;
 p3_data_next.perr         = p2_perr;
 p3_data_next.ro           = p2_ro;
 p3_data_next.pasidtlp     = {p2_cq_pasidtlp.fmt2, 2'd0, p2_cq_pasidtlp.pasid};
 p3_data_next.is_pf        = p2_is_pf;
 p3_data_next.vf           = p2_vf;
 p3_data_next.keep_pf_ppid = p2_cq_fmt;
end

always_ff @(posedge hqm_gated_clk) begin
 if (p3_load) begin
  if (~p3_cfg_next) begin
   p3_carry_q <= p3_carry_next;
   p3_data_q  <= p3_data_next;
  end
 end
end

assign cfg_taken_p3 = p3_cfg_next & ~|{p3_v_q, p4_v_q, p5_v_q};

hqm_AW_unused_bits i_unused_pasidtlp ( 

        .a      (|{p2_cq_pasidtlp.pm_req
                  ,p2_cq_pasidtlp.exe_req
                })
);

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
  p4_v_q      <= p3_v_q & (~p3_cfg_we_q | (&p5_cfg_we_q));
  p4_cfg_q    <= p3_cfg_q;
  p4_cfg_we_q <= p3_cfg_we_q;
 end
end

assign p4_addr_next[31:4] = p3_data_q.cq_addr[31:4];

hqm_AW_add #(.WIDTH(32)) i_p4_addr_sum_ms (

     .a     (p3_data_q.cq_addr[63:32])
    ,.b     (32'd0)
    ,.ci    (p3_carry_q)
    ,.sum   (p4_addr_next[63:32])
    ,.co    (p4_carry_next)
);

always_comb begin
 p4_data_next         = p3_data_q;
 p4_data_next.cq_addr = p4_addr_next;
end

always_ff @(posedge hqm_gated_clk) begin
 if (p4_load) begin
  if (~p3_cfg_q) begin
   p4_carry_q <= p4_carry_next;
   p4_data_q  <= p4_data_next;
  end
 end
end

//-----------------------------------------------------------------------------------------------------
// P5
//-----------------------------------------------------------------------------------------------------

assign p5_v    = p5_v_q & ~p5_cfg_q;
assign p5_hold = p5_v   & ~sched_out_ready;
assign p5_load = p4_v_q & ~p5_hold;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p5_v_q       <= '0;
  p5_cfg_q     <= '0;
  p5_cfg_we_q  <= '0;
  p5_carry_q   <= '0;
  p5_data_q    <= '0;
 end else begin
  if (~p5_hold) begin
   p5_v_q      <= p4_v_q;
   p5_cfg_q    <= p4_cfg_q;
   p5_cfg_we_q <= {p4_cfg_we_q, p5_cfg_we_q[1]};
  end
  if (p5_load) begin
   if (~p4_cfg_q) begin
    p5_carry_q <= p4_carry_q;
    p5_data_q  <= p4_data_q;
   end
  end
 end
end

assign p6_load = p5_v & sched_out_ready;

assign sch_lut_hold = ~sched_out_ready & ~p5_cfg_q;

hqm_system_lut_rmw #(//--------------------------------------------------------------------------------

         .DEPTH                 (HQM_SYSTEM_DEPTH_LUT_LDB_QID2VQID)
        ,.WIDTH                 (HQM_SYSTEM_DWIDTH_LUT_LDB_QID2VQID)
        ,.PACK                  (HQM_SYSTEM_PACK_LUT_LDB_QID2VQID)

) i_lut_ldb_qid2vqid (

         .clk                   (hqm_gated_clk)
        ,.rst_b                 (hqm_gated_rst_n)

        ,.wr_bad_par            (cfg_write_bad_parity_q)

        ,.init                  (init_q[0])
        ,.init_done             (init_done[9])

        ,.cfg_re                (cfg_re_v.ldb_qid2vqid)
        ,.cfg_we                (cfg_we_v.ldb_qid2vqid)
        ,.cfg_addr              (cfg_addr_q[HQM_SYSTEM_AWIDTH_LUT_LDB_QID2VQID-1:0])
        ,.cfg_wdata             (cfg_wdata_q[HQM_SYSTEM_DWIDTH_LUT_LDB_QID2VQID-1:0])

        ,.cfg_rdata             (cfg_rdata_lut.ldb_qid2vqid)

        ,.memi                  (memi_lut_ldb_qid2vqid)

        ,.memo                  (memo_lut_ldb_qid2vqid)

        ,.lut_re                (p2_taken)
        ,.lut_addr              (p2_data_q.w.data.msg_info.qid[HQM_SYSTEM_LDB_QID_WIDTH-1:0])
        ,.lut_nord              (~p2_data_q.w.user.hqm_core_flags.cq_is_ldb | ~p2_data_q.hcw_v | p2_is_pf)     

        ,.lut_rdata             (p5_vqid)
        ,.lut_perr              (lut_err.ldb_qid2vqid)

        ,.lut_hold              (sch_lut_hold)
);

assign p5_err = p5_v & p5_data_q.hcw_v & ~cfg_parity_off & (p5_data_q.perr | lut_err.ldb_qid2vqid);

//-----------------------------------------------------------------------------------------------------
// Core scheduled HCWs are destined for the SIF port by way of the write buffer.
// An interrupt can be tacked onto them or the interrupt can be by itself.
// On a LUT or header parity error, or a header residue error, or an address overflow, don't send out
// the HCW, and just report the error.  Doing this by setting the error bit and resetting the hcw_v
// bit in the transaction going to the write buffer.
// A data parity error just sets the hcw_error bit.
// Need to be careful that a piggybacked interrupt isn't thrown away in the error case.

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  p5_inj_par_err_q      <= '0;
  p5_inj_par_err_last_q <= '0;
 end else begin
  p5_inj_par_err_q      <= cfg_inj_par_err_egress[4:0];
  p5_inj_par_err_last_q <= p5_inj_par_err_q & (p5_inj_par_err_last_q |
                            {   (p6_load & p5_data_q.int_v & ~cfg_parity_off)
                            ,{4{(p6_load & p5_data_q.hcw_v & ~cfg_parity_off)}}});
 end
end

assign p5_res_check   = p6_load & p5_data_q.hcw_v & ~p5_carry_q & ~cfg_residue_off;

assign p5_cq_addr_res = {p5_data_q.cq_addr_res[1],
    (p5_data_q.cq_addr_res[0] ^ (p5_inj_par_err_q[2] & ~p5_inj_par_err_last_q[2]))};

hqm_AW_residue_check #(.WIDTH($bits(p5_data_q.cq_addr))) i_p5_hrerr (

     .r         (p5_cq_addr_res)
    ,.d         (p5_data_q.cq_addr)
    ,.e         (p5_res_check)
    ,.err       (p5_hrerr)
);

assign p5_iperr = p6_load & (~cfg_int_parity_off) &
                  ((^{1'b1,p5_data_q.int_d}) |
                  (p5_data_q.int_v & p5_inj_par_err_q[4] & (~p5_inj_par_err_last_q[4])));

assign p5_pperr = p6_load & (~cfg_parity_off) &
                  ((^{p5_data_q.parity
                     ,p5_data_q.hcw_v
                     ,p5_data_q.int_v
                     ,p5_data_q.ro
                     ,p5_data_q.is_pf
                     ,p5_data_q.vf
                     ,p5_data_q.pasidtlp
                     ,p5_data_q.keep_pf_ppid}) |
                 (p5_inj_par_err_q[3] & (~p5_inj_par_err_last_q[3])));

assign p5_hperr = p6_load & p5_data_q.hcw_v & (~cfg_parity_off) &
                  ((~(^{p5_data_q.w.user.hqm_core_flags
                       ,p5_data_q.w.user.cq_wptr
                       ,p5_data_q.w.user.cq})) |
                   (p5_inj_par_err_q[1] & (~p5_inj_par_err_last_q[1])));

assign p5_dperr = p6_load & p5_data_q.hcw_v & (~cfg_parity_off) &
                  ((~(^{p5_data_q.w.user.hcw_parity[1], p5_data_q.w.data[127:64]})) |
                   (~(^{p5_data_q.w.user.hcw_parity[0], p5_data_q.w.data[ 63: 0]})) |
                   (p5_inj_par_err_q[0] & (~p5_inj_par_err_last_q[0])));

assign p5_addr_overflow = p6_load & p5_data_q.hcw_v & p5_carry_q;

// LUT or header parity error detected

assign p5_error = |{p5_err, p5_pperr, p5_hperr, p5_hrerr, p5_addr_overflow};

assign hcw_sched_v     = p5_v & (p5_data_q.int_v | p5_data_q.hcw_v);
assign sched_out_ready = hcw_sched_v & hcw_sched_ready;

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_LDB_QID_WIDTH), .Z_WIDTH(7)) i_p5_vqid_scaled (

     .a         (p5_vqid)
    ,.z         (p5_vqid_scaled)
);

always_comb begin

 p5_hcw_out = p5_data_q.w.data;

 // A data parity error is passed to the write buffer normally but sets the hcw_error bit

 if (p5_dperr) p5_hcw_out.flags.hcw_error = '1;

 if (p5_data_q.w.user.hqm_core_flags.cq_is_ldb) begin
  if (~p5_data_q.is_pf) begin
   p5_hcw_out.msg_info.qid      = p5_vqid_scaled;
  end
 end else if (~p5_data_q.keep_pf_ppid) begin
   p5_hcw_out.msg_info.qid      = '0;
 end

end

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_gen_ecc_l (

     .d         (p5_hcw_out[63:0])
    ,.ecc       (p5_hcw_out_ecc_l)
);

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_gen_ecc_h (

     .d         (p5_hcw_out[127:64])
    ,.ecc       (p5_hcw_out_ecc_h)
);

always_comb begin

 // A LUT or header parity error will be dropped in the write buffer
 // Signal this by setting the error bit and resetting the hcw_v bit
 // Adjust the parity to remove the consumed keep_pf_ppid bit and if we reset the hcw_v bit

 hcw_sched             = '0;
 hcw_sched.error_parity= ^{1'b1,p5_error};
 hcw_sched.error       = p5_error;
 hcw_sched.parity      = p5_data_q.parity ^ (p5_data_q.hcw_v & p5_error) ^ (p5_data_q.int_v & p5_iperr) ^ p5_data_q.keep_pf_ppid;
 hcw_sched.cq_addr_res = p5_data_q.cq_addr_res;
 hcw_sched.ro          = p5_data_q.ro;
 hcw_sched.pasidtlp    = p5_data_q.pasidtlp;
 hcw_sched.is_pf       = p5_data_q.is_pf;
 hcw_sched.vf          = p5_data_q.vf;
 hcw_sched.cq_addr     = p5_data_q.cq_addr;
 hcw_sched.int_v       = p5_data_q.int_v & ~p5_iperr;
 hcw_sched.int_d       = p5_data_q.int_d;
 hcw_sched.hcw_v       = p5_data_q.hcw_v & ~p5_error;
 hcw_sched.w           = p5_data_q.w;
 hcw_sched.w.data      = p5_hcw_out;
 hcw_sched.ecc         = {p5_hcw_out_ecc_h, p5_hcw_out_ecc_l};

end

//-----------------------------------------------------------------------------------------------------
// Double buffer write buffer interface

hqm_AW_agitate_readyvalid #(.SEED(32'h5238)) i_agitate_hcw_sched_db (

         .clk                   (hqm_gated_clk)
        ,.rst_n                 (hqm_gated_rst_n)

        ,.control               (eg_hcw_sched_db_agitate_control)
        ,.enable                (1'b1)

        ,.up_v                  (hcw_sched_v)
        ,.up_ready              (hcw_sched_ready)

        ,.down_v                (agg_hcw_sched_v)
        ,.down_ready            (agg_hcw_sched_ready)
);

hqm_AW_double_buffer #(.WIDTH($bits(hcw_sched_out)), .RESET_DATAPATH(1)) i_hcw_sched_db (

         .clk           (hqm_gated_clk)
        ,.rst_n         (hqm_gated_rst_n)

        ,.status        (hcw_sched_db_status)

        ,.in_ready      (agg_hcw_sched_ready)

        ,.in_valid      (agg_hcw_sched_v)
        ,.in_data       (hcw_sched)

        ,.out_ready     (hcw_sched_out_ready)

        ,.out_valid     (hcw_sched_out_v)
        ,.out_data      (hcw_sched_out)
);

//-----------------------------------------------------------------------------------------------------
// These bits are sticky parity error indications.

assign lut_err_next.ldb_cq_pasid    = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.ldb_cq_pasid;
assign lut_err_next.ldb_cq_addr_l   = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.ldb_cq_addr_l;
assign lut_err_next.ldb_cq_addr_u   = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.ldb_cq_addr_u;
assign lut_err_next.ldb_cq2vf_pf_ro = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.ldb_cq2vf_pf_ro;
assign lut_err_next.dir_cq_pasid    = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.dir_cq_pasid;
assign lut_err_next.dir_cq_addr_l   = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.dir_cq_addr_l;
assign lut_err_next.dir_cq_addr_u   = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.dir_cq_addr_u;
assign lut_err_next.dir_cq2vf_pf_ro = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.dir_cq2vf_pf_ro;
assign lut_err_next.dir_cq_fmt      = (p3_load    | p2_cfg_q    | p2_cfg_we_q[1]   ) & lut_err.dir_cq_fmt;
                                                                                        
assign lut_err_next.ldb_qid2vqid    = (p6_load    | p5_cfg_q    | p5_cfg_we_q[1]   ) & lut_err.ldb_qid2vqid;

assign intf_perr_next[4] = p5_iperr;
assign intf_perr_next[3] = p5_pperr;
assign intf_perr_next[2] = p5_hrerr;
assign intf_perr_next[1] = p5_hperr;
assign intf_perr_next[0] = p5_dperr;

assign perr_next = |{intf_perr_next
                    ,lut_err_next.ldb_cq_pasid
                    ,lut_err_next.ldb_cq_addr_l
                    ,lut_err_next.ldb_cq_addr_u
                    ,lut_err_next.ldb_cq2vf_pf_ro
                    ,lut_err_next.dir_cq_pasid
                    ,lut_err_next.dir_cq_addr_l
                    ,lut_err_next.dir_cq_addr_u
                    ,lut_err_next.dir_cq2vf_pf_ro
                    ,lut_err_next.dir_cq_fmt
                    ,lut_err_next.ldb_qid2vqid
};

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  perr_q      <= '0;
  intf_perr_q <= '0;
  lut_err_q   <= '0;
 end else begin
  perr_q      <= perr_next & ~cfg_parity_off;
  intf_perr_q <= intf_perr_next;
  lut_err_q   <= lut_err_next   & ~{$bits(lut_err_q){cfg_parity_off}};
 end
end

assign egress_lut_err = {intf_perr_q, lut_err_q};
assign egress_perr    = perr_q;

assign cq_addr_overflow_error = p5_addr_overflow;

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_DIR_CQ_WIDTH), .Z_WIDTH(8)) i_overflow_syndrome (

     .a         (p5_data_q.w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0])
    ,.z         (cq_addr_overflow_syndrome)
);

//-----------------------------------------------------------------------------------------------------
// Dedicated interface event counters

logic               cnt_clear_q;
logic               cnt_clearv_q;

logic   [1:0]       cnt_inc;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  cnt_clear_q   <= '0;
  cnt_clearv_q  <= '0;
 end else begin
  cnt_clear_q   <= cfg_cnt_clear;
  cnt_clearv_q  <= cfg_cnt_clearv;
 end
end

assign cnt_inc[0] = hcw_sched_w_req_valid & hcw_sched_w_req_ready;      // 7:6 Scheduled HCWs in
assign cnt_inc[1] = hcw_sched_out_v       & hcw_sched_out_ready &       // 9:8 Scheduled HCWs out to write buffer
                   (hcw_sched_out.hcw_v   | hcw_sched_out.error);

hqm_AW_inc_64b_val i_cnt_0 (

     .clk       (hqm_inp_gated_clk)
    ,.rst_n     (hqm_inp_gated_rst_n)
    ,.clr       (cnt_clear_q)
    ,.clrv      (cnt_clearv_q)
    ,.inc       (cnt_inc[0])
    ,.count     ({cfg_egress_cnts[7], cfg_egress_cnts[6]})
);

hqm_AW_inc_64b_val i_cnt_1 (

     .clk       (hqm_gated_clk)
    ,.rst_n     (hqm_gated_rst_n)
    ,.clr       (cnt_clear_q)
    ,.clrv      (cnt_clearv_q)
    ,.inc       (cnt_inc[1])
    ,.count     ({cfg_egress_cnts[9], cfg_egress_cnts[8]})
);

//-----------------------------------------------------------------------------------------------------
// Status

assign egress_status.P5_HCW_V       = p5_data_q.hcw_v;
assign egress_status.P5_INT_V       = p5_data_q.int_v;
assign egress_status.SCH_P5_V       = p5_v_q;
assign egress_status.SCH_P4_V       = p4_v_q;
assign egress_status.SCH_P3_V       = p3_v_q;
assign egress_status.SCH_P2_V       = p2_v_q;
assign egress_status.SCH_P1_V       = p1_v_q;
assign egress_status.SCH_P0_V       = p0_v_q;

assign egress_idle_next = (~(|{p5_v_q
                              ,p4_v_q
                              ,p3_v_q
                              ,p2_v_q
                              ,p1_v_q
                              ,p0_v_q
                              ,hcw_sch_fifo_status.depth
                              ,hcw_sched_db_status[1:0]
                              ,cfg_re_q
                              ,cfg_we_q
})) & init_done_q;

always_ff @(posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n) begin
 if (~hqm_inp_gated_rst_n) begin
  egress_idle_q <= '0;
 end else begin
  egress_idle_q <= egress_idle_next;
 end
end

assign egress_idle = egress_idle_q;

endmodule // hqm_system_egress

