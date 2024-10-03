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
// hqm_lsp_atm_pipe
//   maintain the atomic scheduled & ready linked lists.  Atomic tasks are assigned a flowid (fid) and these fid operate
//     in the atomic state machine states :Idle, Ready, Scheduled, Empty.  Need to provide empty/full commands to list_sel_pipe
//     for the Ready & SCheduled LL so that list_sel_pipe can issue schedule commands to cq.
//
/////////////////////////
//   cq,qidix bypass details.
//     A schedule to rlst causes the fid to be assigned to a cq,qidix (state transition Ready -> Empty or Ready -> Scheduled )
//     A subsequent Enqueue needs to use the cq,qidix when the fid must be written onto the slst (state transition Empty -> Scheduled )
//     The enqueue reads the fid2qidix RAM to get the cq,qidix assigned to the fid.  This RAM is updated by the schedule to the rlst.
//     HAZARD: if the Enqueue to the same fid is active in the pipline with the schedule it read the incorrect cq,qidix from fid2qidix RAM 
//     The cq,qidix is needed to lookup the slst hp/tp in p0 if FID needs to be pushed onto the slst (Empty -> Scheduled) 
//
//   When a Schedule to the rlst is in p6 and a Enqueue to the same fid is past p0 it will have issued the read to fid2qidix with wrong cq,qidix
//   Need to bypass the updated cq,qidix & slst tp from p6 directly into the pipline stages with the matching fid.
//       NOTE: only the slst tp is needed (do not need slst hp) in the bypass becuase the enqueue adds to the slst tail.
//
//   Bypass into p0,p1,p2,p3 occurs as follows when the fid in the pipe stage matches p6 & the fid2qidix RAM is updated:
//   1.) cq & qidix are bypassed directly into the pipline storage
//   2.) the slst tp is bypassed directly into the pipeline storage and marked to prevent loading the stale RAM output 
//    a.) if the schedule is updating the slst tp then bypass that updated value into pipeline (Ready -> Scheduled)
//    b.) if the schedule is not updating the slst then bypass p6 slst.tp value into the pipeline (Ready -> Empty)
//   3.) Need a SUPER bypass for any Enqueue inbetween these 2 commands that will add to the tail.
//    a.) if slst cq,qidix is updated & p0,p1,p2,p3 has been marked that it was bypassed then bypass in the latest slst tp
/////////////////////////
//
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_lsp_atm_pipe
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
    input logic hqm_gated_clk
  , input logic hqm_gated_rst_b
  , input logic hqm_inp_gated_clk
  , input logic hqm_inp_gated_rst_b
  , input logic hqm_flr_prep
  , output logic hqm_proc_clk_en

  , input  logic hqm_gated_rst_b_start_atm
  , input  logic hqm_gated_rst_b_active_atm
  , output logic hqm_gated_rst_b_done_atm

, output logic atm_clk_idle
, input logic atm_clk_enable


, output logic                  ap_unit_idle
, output logic                  ap_unit_pipeidle
, output logic                  ap_reset_done

// CFG interface
, input  logic                  ap_cfg_req_up_read
, input  logic                  ap_cfg_req_up_write
, input  cfg_req_t              ap_cfg_req_up
, input  logic                  ap_cfg_rsp_up_ack
, input  cfg_rsp_t              ap_cfg_rsp_up
, output logic                  ap_cfg_req_down_read
, output logic                  ap_cfg_req_down_write
, output cfg_req_t              ap_cfg_req_down
, output logic                  ap_cfg_rsp_down_ack
, output cfg_rsp_t              ap_cfg_rsp_down

// interrupt interface
, input  logic                  ap_alarm_up_v
, output logic                  ap_alarm_up_ready
, input  aw_alarm_t             ap_alarm_up_data

, output logic                  ap_alarm_down_v
, input  logic                  ap_alarm_down_ready
, output aw_alarm_t             ap_alarm_down_data

, output logic                           lsp_aqed_cmp_v
, input  logic                           lsp_aqed_cmp_ready
, output lsp_aqed_cmp_t                  lsp_aqed_cmp_data

// ap_aqed interface
, output logic                  ap_aqed_v
, input  logic                  ap_aqed_ready
, output ap_aqed_t              ap_aqed_data

// aqed_ap_enq interface
, input  logic                  aqed_ap_enq_v
, output logic                  aqed_ap_enq_ready
, input  aqed_ap_enq_t          aqed_ap_enq_data

// ap_lsp_enq interface
, output logic                  ap_lsp_enq_v
, input  logic                  ap_lsp_enq_ready
, output ap_lsp_enq_t           ap_lsp_enq_data

// lsp_ap interface
, input  logic                  lsp_ap_atm_v
, output logic                  lsp_ap_atm_ready
, input  lsp_ap_atm_t           lsp_ap_atm_data

//--------------------------------------------------
//lsp signals
, output logic                  ap_lsp_freeze // lsp should free pipline while atm processes vf reset or cfg request
, input  logic                  lsp_ap_idle // lsp pipeline is idle and atm can perform cfg/vf reset

, output logic [ ( 2 ) - 1 : 0 ]        credit_fifo_ap_aqed_dec_sch // signal to  list_sel to decrement ap->aqed schedule output drain FIFO credits
, output logic                  credit_fifo_ap_aqed_dec_cmp // signal to  list_sel to decrement ap->aqed schedule output drain FIFO credits

//////////////////////////////////////////////////
, output logic                  ap_lsp_cmd_v
, output logic [ ( 2 ) - 1 : 0 ]        ap_lsp_cmd

, output logic [ ( 6 ) - 1 : 0 ]        ap_lsp_cq
, output logic [ ( 3 ) - 1 : 0 ]        ap_lsp_qidix
, output logic                          ap_lsp_qidix_msb
, output logic [ ( 7 ) - 1 : 0 ]        ap_lsp_qid
, output logic [ ( 512 ) - 1 : 0 ]      ap_lsp_qid2cqqidix

, output logic                  ap_lsp_haswork_rlst_v
, output logic                  ap_lsp_haswork_rlst_func

, output logic                  ap_lsp_haswork_slst_v
, output logic                  ap_lsp_haswork_slst_func

, output logic                  ap_lsp_cmpblast_v
//////////////////////////////////////////////////

, output logic                  ap_lsp_dec_fid_cnt_v

//--------------------------------------------------

// BEGIN HQM_MEMPORT_DECL hqm_lsp_atm_pipe
    ,output logic                  rf_aqed_qid2cqidix_re
    ,output logic                  rf_aqed_qid2cqidix_rclk
    ,output logic                  rf_aqed_qid2cqidix_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_qid2cqidix_raddr
    ,output logic [(       5)-1:0] rf_aqed_qid2cqidix_waddr
    ,output logic                  rf_aqed_qid2cqidix_we
    ,output logic                  rf_aqed_qid2cqidix_wclk
    ,output logic                  rf_aqed_qid2cqidix_wclk_rst_n
    ,output logic [(     528)-1:0] rf_aqed_qid2cqidix_wdata
    ,input  logic [(     528)-1:0] rf_aqed_qid2cqidix_rdata

    ,output logic                  rf_atm_fifo_ap_aqed_re
    ,output logic                  rf_atm_fifo_ap_aqed_rclk
    ,output logic                  rf_atm_fifo_ap_aqed_rclk_rst_n
    ,output logic [(       4)-1:0] rf_atm_fifo_ap_aqed_raddr
    ,output logic [(       4)-1:0] rf_atm_fifo_ap_aqed_waddr
    ,output logic                  rf_atm_fifo_ap_aqed_we
    ,output logic                  rf_atm_fifo_ap_aqed_wclk
    ,output logic                  rf_atm_fifo_ap_aqed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_atm_fifo_ap_aqed_wdata
    ,input  logic [(      45)-1:0] rf_atm_fifo_ap_aqed_rdata

    ,output logic                  rf_atm_fifo_aqed_ap_enq_re
    ,output logic                  rf_atm_fifo_aqed_ap_enq_rclk
    ,output logic                  rf_atm_fifo_aqed_ap_enq_rclk_rst_n
    ,output logic [(       5)-1:0] rf_atm_fifo_aqed_ap_enq_raddr
    ,output logic [(       5)-1:0] rf_atm_fifo_aqed_ap_enq_waddr
    ,output logic                  rf_atm_fifo_aqed_ap_enq_we
    ,output logic                  rf_atm_fifo_aqed_ap_enq_wclk
    ,output logic                  rf_atm_fifo_aqed_ap_enq_wclk_rst_n
    ,output logic [(      24)-1:0] rf_atm_fifo_aqed_ap_enq_wdata
    ,input  logic [(      24)-1:0] rf_atm_fifo_aqed_ap_enq_rdata

    ,output logic                  rf_fid2cqqidix_re
    ,output logic                  rf_fid2cqqidix_rclk
    ,output logic                  rf_fid2cqqidix_rclk_rst_n
    ,output logic [(      11)-1:0] rf_fid2cqqidix_raddr
    ,output logic [(      11)-1:0] rf_fid2cqqidix_waddr
    ,output logic                  rf_fid2cqqidix_we
    ,output logic                  rf_fid2cqqidix_wclk
    ,output logic                  rf_fid2cqqidix_wclk_rst_n
    ,output logic [(      12)-1:0] rf_fid2cqqidix_wdata
    ,input  logic [(      12)-1:0] rf_fid2cqqidix_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin0_re
    ,output logic                  rf_ll_enq_cnt_s_bin0_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin0_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin0_we
    ,output logic                  rf_ll_enq_cnt_s_bin0_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin0_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin1_re
    ,output logic                  rf_ll_enq_cnt_s_bin1_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin1_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin1_we
    ,output logic                  rf_ll_enq_cnt_s_bin1_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin1_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin2_re
    ,output logic                  rf_ll_enq_cnt_s_bin2_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin2_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin2_we
    ,output logic                  rf_ll_enq_cnt_s_bin2_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin2_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin3_re
    ,output logic                  rf_ll_enq_cnt_s_bin3_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin3_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin3_we
    ,output logic                  rf_ll_enq_cnt_s_bin3_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin3_rdata

    ,output logic                  rf_ll_rdylst_hp_bin0_re
    ,output logic                  rf_ll_rdylst_hp_bin0_rclk
    ,output logic                  rf_ll_rdylst_hp_bin0_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin0_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin0_waddr
    ,output logic                  rf_ll_rdylst_hp_bin0_we
    ,output logic                  rf_ll_rdylst_hp_bin0_wclk
    ,output logic                  rf_ll_rdylst_hp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin0_rdata

    ,output logic                  rf_ll_rdylst_hp_bin1_re
    ,output logic                  rf_ll_rdylst_hp_bin1_rclk
    ,output logic                  rf_ll_rdylst_hp_bin1_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin1_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin1_waddr
    ,output logic                  rf_ll_rdylst_hp_bin1_we
    ,output logic                  rf_ll_rdylst_hp_bin1_wclk
    ,output logic                  rf_ll_rdylst_hp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin1_rdata

    ,output logic                  rf_ll_rdylst_hp_bin2_re
    ,output logic                  rf_ll_rdylst_hp_bin2_rclk
    ,output logic                  rf_ll_rdylst_hp_bin2_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin2_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin2_waddr
    ,output logic                  rf_ll_rdylst_hp_bin2_we
    ,output logic                  rf_ll_rdylst_hp_bin2_wclk
    ,output logic                  rf_ll_rdylst_hp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin2_rdata

    ,output logic                  rf_ll_rdylst_hp_bin3_re
    ,output logic                  rf_ll_rdylst_hp_bin3_rclk
    ,output logic                  rf_ll_rdylst_hp_bin3_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin3_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin3_waddr
    ,output logic                  rf_ll_rdylst_hp_bin3_we
    ,output logic                  rf_ll_rdylst_hp_bin3_wclk
    ,output logic                  rf_ll_rdylst_hp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin3_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin0_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin0_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin1_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin1_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin2_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin2_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin3_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin3_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_rdylst_tp_bin0_re
    ,output logic                  rf_ll_rdylst_tp_bin0_rclk
    ,output logic                  rf_ll_rdylst_tp_bin0_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin0_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin0_waddr
    ,output logic                  rf_ll_rdylst_tp_bin0_we
    ,output logic                  rf_ll_rdylst_tp_bin0_wclk
    ,output logic                  rf_ll_rdylst_tp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin0_rdata

    ,output logic                  rf_ll_rdylst_tp_bin1_re
    ,output logic                  rf_ll_rdylst_tp_bin1_rclk
    ,output logic                  rf_ll_rdylst_tp_bin1_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin1_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin1_waddr
    ,output logic                  rf_ll_rdylst_tp_bin1_we
    ,output logic                  rf_ll_rdylst_tp_bin1_wclk
    ,output logic                  rf_ll_rdylst_tp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin1_rdata

    ,output logic                  rf_ll_rdylst_tp_bin2_re
    ,output logic                  rf_ll_rdylst_tp_bin2_rclk
    ,output logic                  rf_ll_rdylst_tp_bin2_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin2_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin2_waddr
    ,output logic                  rf_ll_rdylst_tp_bin2_we
    ,output logic                  rf_ll_rdylst_tp_bin2_wclk
    ,output logic                  rf_ll_rdylst_tp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin2_rdata

    ,output logic                  rf_ll_rdylst_tp_bin3_re
    ,output logic                  rf_ll_rdylst_tp_bin3_rclk
    ,output logic                  rf_ll_rdylst_tp_bin3_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin3_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin3_waddr
    ,output logic                  rf_ll_rdylst_tp_bin3_we
    ,output logic                  rf_ll_rdylst_tp_bin3_wclk
    ,output logic                  rf_ll_rdylst_tp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin3_rdata

    ,output logic                  rf_ll_rlst_cnt_re
    ,output logic                  rf_ll_rlst_cnt_rclk
    ,output logic                  rf_ll_rlst_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rlst_cnt_raddr
    ,output logic [(       5)-1:0] rf_ll_rlst_cnt_waddr
    ,output logic                  rf_ll_rlst_cnt_we
    ,output logic                  rf_ll_rlst_cnt_wclk
    ,output logic                  rf_ll_rlst_cnt_wclk_rst_n
    ,output logic [(      56)-1:0] rf_ll_rlst_cnt_wdata
    ,input  logic [(      56)-1:0] rf_ll_rlst_cnt_rdata

    ,output logic                  rf_ll_sch_cnt_dup0_re
    ,output logic                  rf_ll_sch_cnt_dup0_rclk
    ,output logic                  rf_ll_sch_cnt_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup0_waddr
    ,output logic                  rf_ll_sch_cnt_dup0_we
    ,output logic                  rf_ll_sch_cnt_dup0_wclk
    ,output logic                  rf_ll_sch_cnt_dup0_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup0_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup0_rdata

    ,output logic                  rf_ll_sch_cnt_dup1_re
    ,output logic                  rf_ll_sch_cnt_dup1_rclk
    ,output logic                  rf_ll_sch_cnt_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup1_waddr
    ,output logic                  rf_ll_sch_cnt_dup1_we
    ,output logic                  rf_ll_sch_cnt_dup1_wclk
    ,output logic                  rf_ll_sch_cnt_dup1_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup1_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup1_rdata

    ,output logic                  rf_ll_sch_cnt_dup2_re
    ,output logic                  rf_ll_sch_cnt_dup2_rclk
    ,output logic                  rf_ll_sch_cnt_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup2_waddr
    ,output logic                  rf_ll_sch_cnt_dup2_we
    ,output logic                  rf_ll_sch_cnt_dup2_wclk
    ,output logic                  rf_ll_sch_cnt_dup2_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup2_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup2_rdata

    ,output logic                  rf_ll_sch_cnt_dup3_re
    ,output logic                  rf_ll_sch_cnt_dup3_rclk
    ,output logic                  rf_ll_sch_cnt_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup3_waddr
    ,output logic                  rf_ll_sch_cnt_dup3_we
    ,output logic                  rf_ll_sch_cnt_dup3_wclk
    ,output logic                  rf_ll_sch_cnt_dup3_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup3_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup3_rdata

    ,output logic                  rf_ll_schlst_hp_bin0_re
    ,output logic                  rf_ll_schlst_hp_bin0_rclk
    ,output logic                  rf_ll_schlst_hp_bin0_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin0_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin0_waddr
    ,output logic                  rf_ll_schlst_hp_bin0_we
    ,output logic                  rf_ll_schlst_hp_bin0_wclk
    ,output logic                  rf_ll_schlst_hp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin0_rdata

    ,output logic                  rf_ll_schlst_hp_bin1_re
    ,output logic                  rf_ll_schlst_hp_bin1_rclk
    ,output logic                  rf_ll_schlst_hp_bin1_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin1_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin1_waddr
    ,output logic                  rf_ll_schlst_hp_bin1_we
    ,output logic                  rf_ll_schlst_hp_bin1_wclk
    ,output logic                  rf_ll_schlst_hp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin1_rdata

    ,output logic                  rf_ll_schlst_hp_bin2_re
    ,output logic                  rf_ll_schlst_hp_bin2_rclk
    ,output logic                  rf_ll_schlst_hp_bin2_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin2_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin2_waddr
    ,output logic                  rf_ll_schlst_hp_bin2_we
    ,output logic                  rf_ll_schlst_hp_bin2_wclk
    ,output logic                  rf_ll_schlst_hp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin2_rdata

    ,output logic                  rf_ll_schlst_hp_bin3_re
    ,output logic                  rf_ll_schlst_hp_bin3_rclk
    ,output logic                  rf_ll_schlst_hp_bin3_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin3_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin3_waddr
    ,output logic                  rf_ll_schlst_hp_bin3_we
    ,output logic                  rf_ll_schlst_hp_bin3_wclk
    ,output logic                  rf_ll_schlst_hp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin3_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin0_re
    ,output logic                  rf_ll_schlst_hpnxt_bin0_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin0_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin0_we
    ,output logic                  rf_ll_schlst_hpnxt_bin0_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin1_re
    ,output logic                  rf_ll_schlst_hpnxt_bin1_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin1_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin1_we
    ,output logic                  rf_ll_schlst_hpnxt_bin1_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin2_re
    ,output logic                  rf_ll_schlst_hpnxt_bin2_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin2_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin2_we
    ,output logic                  rf_ll_schlst_hpnxt_bin2_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin3_re
    ,output logic                  rf_ll_schlst_hpnxt_bin3_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin3_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin3_we
    ,output logic                  rf_ll_schlst_hpnxt_bin3_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_schlst_tp_bin0_re
    ,output logic                  rf_ll_schlst_tp_bin0_rclk
    ,output logic                  rf_ll_schlst_tp_bin0_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin0_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin0_waddr
    ,output logic                  rf_ll_schlst_tp_bin0_we
    ,output logic                  rf_ll_schlst_tp_bin0_wclk
    ,output logic                  rf_ll_schlst_tp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin0_rdata

    ,output logic                  rf_ll_schlst_tp_bin1_re
    ,output logic                  rf_ll_schlst_tp_bin1_rclk
    ,output logic                  rf_ll_schlst_tp_bin1_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin1_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin1_waddr
    ,output logic                  rf_ll_schlst_tp_bin1_we
    ,output logic                  rf_ll_schlst_tp_bin1_wclk
    ,output logic                  rf_ll_schlst_tp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin1_rdata

    ,output logic                  rf_ll_schlst_tp_bin2_re
    ,output logic                  rf_ll_schlst_tp_bin2_rclk
    ,output logic                  rf_ll_schlst_tp_bin2_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin2_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin2_waddr
    ,output logic                  rf_ll_schlst_tp_bin2_we
    ,output logic                  rf_ll_schlst_tp_bin2_wclk
    ,output logic                  rf_ll_schlst_tp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin2_rdata

    ,output logic                  rf_ll_schlst_tp_bin3_re
    ,output logic                  rf_ll_schlst_tp_bin3_rclk
    ,output logic                  rf_ll_schlst_tp_bin3_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin3_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin3_waddr
    ,output logic                  rf_ll_schlst_tp_bin3_we
    ,output logic                  rf_ll_schlst_tp_bin3_wclk
    ,output logic                  rf_ll_schlst_tp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin3_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin0_re
    ,output logic                  rf_ll_schlst_tpprv_bin0_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin0_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin0_we
    ,output logic                  rf_ll_schlst_tpprv_bin0_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin0_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin1_re
    ,output logic                  rf_ll_schlst_tpprv_bin1_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin1_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin1_we
    ,output logic                  rf_ll_schlst_tpprv_bin1_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin1_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin2_re
    ,output logic                  rf_ll_schlst_tpprv_bin2_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin2_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin2_we
    ,output logic                  rf_ll_schlst_tpprv_bin2_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin2_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin3_re
    ,output logic                  rf_ll_schlst_tpprv_bin3_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin3_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin3_we
    ,output logic                  rf_ll_schlst_tpprv_bin3_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin3_rdata

    ,output logic                  rf_ll_slst_cnt_re
    ,output logic                  rf_ll_slst_cnt_rclk
    ,output logic                  rf_ll_slst_cnt_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_slst_cnt_raddr
    ,output logic [(       9)-1:0] rf_ll_slst_cnt_waddr
    ,output logic                  rf_ll_slst_cnt_we
    ,output logic                  rf_ll_slst_cnt_wclk
    ,output logic                  rf_ll_slst_cnt_wclk_rst_n
    ,output logic [(      60)-1:0] rf_ll_slst_cnt_wdata
    ,input  logic [(      60)-1:0] rf_ll_slst_cnt_rdata

    ,output logic                  rf_qid_rdylst_clamp_re
    ,output logic                  rf_qid_rdylst_clamp_rclk
    ,output logic                  rf_qid_rdylst_clamp_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_rdylst_clamp_raddr
    ,output logic [(       5)-1:0] rf_qid_rdylst_clamp_waddr
    ,output logic                  rf_qid_rdylst_clamp_we
    ,output logic                  rf_qid_rdylst_clamp_wclk
    ,output logic                  rf_qid_rdylst_clamp_wclk_rst_n
    ,output logic [(       6)-1:0] rf_qid_rdylst_clamp_wdata
    ,input  logic [(       6)-1:0] rf_qid_rdylst_clamp_rdata

// END HQM_MEMPORT_DECL hqm_lsp_atm_pipe
) ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_0 = 20'd1 ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_1 = 20'd2 ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_2 = 20'd3 ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_3 = 20'd4 ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_4 = 20'd5 ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_5 = 20'd6 ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_6 = 20'd7 ;
localparam HQM_AP_VF_RESET_CMD_CQ_WRITE_CNT_7 = 20'd8 ;
localparam HQM_AP_VF_RESET_CMD_DONE = 20'd13 ;
localparam HQM_AP_VF_RESET_CMD_INVALID = 20'd14 ;
localparam HQM_AP_VF_RESET_CMD_QID_READ_CNT_0 = 20'd9 ;
localparam HQM_AP_VF_RESET_CMD_QID_READ_CNT_X = 20'd11 ;
localparam HQM_AP_VF_RESET_CMD_QID_WRITE_CNT_X = 20'd12 ;
localparam HQM_AP_VF_RESET_CMD_START = 20'd0 ;
localparam HQM_ATM_CFG_INT_DIS = 0 ;
localparam HQM_ATM_CFG_INT_DIS_MBE = 2 ;
localparam HQM_ATM_CFG_INT_DIS_SBE = 1 ;
localparam HQM_ATM_CFG_INT_DIS_SYND = 31 ;
localparam HQM_ATM_CFG_RST_PFMAX = 2048 ;
localparam HQM_ATM_CFG_VASR_DIS = 30 ;
localparam HQM_ATM_CHICKEN_14 = 6 ;
localparam HQM_ATM_CHICKEN_17 = 5 ;
localparam HQM_ATM_CHICKEN_20 = 4 ;
localparam HQM_ATM_CHICKEN_25 = 3 ;
localparam HQM_ATM_CHICKEN_33 = 2 ;
localparam HQM_ATM_CHICKEN_50 = 1 ;
localparam HQM_ATM_CHICKEN_DIS_ENQSTALL = 7 ;
localparam HQM_ATM_CHICKEN_DIS_ENQ_AFULL_HP_MODE = 8 ;
localparam HQM_ATM_CHICKEN_EN_ALWAYSBLAST = 9 ;
localparam HQM_ATM_CHICKEN_EN_ENQBLOCKRLST = 10 ;
localparam HQM_ATM_CHICKEN_SIM = 0 ;
localparam HQM_ATM_CMD_CMP = 2'd0 ;
localparam HQM_ATM_CMD_DEQ = 2'd1 ;
localparam HQM_ATM_CMD_ENQ = 2'd2 ;
localparam HQM_ATM_CMD_NOOP = 2'd3 ;
localparam HQM_ATM_CMP_SI = 4'd5 ;
localparam HQM_ATM_CMP_SR = 4'd4 ;
localparam HQM_ATM_CMP_SRESRE = 4'd6 ;
localparam HQM_ATM_CNTB2 = 12 ; // 2k entries gives counter width 12
localparam HQM_ATM_CNTB2WR = 12 + 2 ; // 2k entries gives counter width 12 and 2b for residue
localparam HQM_ATM_CQ_TOTAL_CNTB2 = 14 ; // 2k+4k
localparam HQM_ATM_CQ_TOTAL_CNTB2WR = 15 ; // 2k+4k
localparam HQM_ATM_CQ_TOTAL_DEPTH = 64 ;
localparam HQM_ATM_CQ_TOTAL_DEPTHB2 = AW_logb2 ( HQM_ATM_CQ_TOTAL_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_CQ_TOTAL_DWIDTH = 14 + 1 ;
localparam HQM_ATM_ENQ_ES = 4'd0 ;
localparam HQM_ATM_ENQ_IR = 4'd3 ;
localparam HQM_ATM_ENQ_RR = 4'd2 ;
localparam HQM_ATM_ENQ_SS = 4'd1 ;
localparam HQM_ATM_FID2CQQIDIX_DEPTH = 4096 ;
localparam HQM_ATM_FID2CQQIDIX_DEPTHB2 = AW_logb2 ( HQM_ATM_FID2CQQIDIX_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_FID2CQQIDIX_DWIDTH = 10 ;
localparam HQM_ATM_FIDB2 = 12 ; // 4k entries gives flowID width 12
localparam HQM_ATM_FIDB2WP = 12 + 1 ; // 4k entries gives flowID width 12
localparam HQM_ATM_FIFO_AP_AQED_DEPTH = 16 ;
localparam HQM_ATM_FIFO_AP_AQED_DEPTHB2 = AW_logb2 ( HQM_ATM_FIFO_AP_AQED_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_FIFO_AP_AQED_DWIDTH = 45 ;
localparam HQM_ATM_FIFO_AP_AQED_WMWIDTH = AW_logb2 ( HQM_ATM_FIFO_AP_AQED_DEPTH + 1 ) + 1 ;
localparam HQM_ATM_FIFO_AP_LSP_ENQ_DEPTH = 16 ;
localparam HQM_ATM_FIFO_AP_LSP_ENQ_DEPTHB2 = AW_logb2 ( HQM_ATM_FIFO_AP_LSP_ENQ_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_FIFO_AP_LSP_ENQ_DWIDTH = 8 ;
localparam HQM_ATM_FIFO_AP_LSP_ENQ_WMWIDTH = AW_logb2 ( HQM_ATM_FIFO_AP_LSP_ENQ_DEPTH + 1 ) + 1 ;
localparam HQM_ATM_FIFO_AQED_AP_ENQ_DEPTH = 32 ;
localparam HQM_ATM_FIFO_AQED_AP_ENQ_DEPTHB2 = AW_logb2 ( HQM_ATM_FIFO_AQED_AP_ENQ_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_FIFO_AQED_AP_ENQ_DWIDTH = 24 ;
localparam HQM_ATM_FIFO_AQED_AP_ENQ_WMWIDTH = AW_logb2 ( HQM_ATM_FIFO_AQED_AP_ENQ_DEPTH + 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH = 14 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH = 14 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH = 14 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH = 14 ;
localparam HQM_ATM_LL_ENQ_CNT_R_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_R_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_R_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_R_DWIDTH = 56 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH = 14 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN1_DWIDTH = 14 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN2_DWIDTH = 14 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTH = 4096 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_ENQ_CNT_S_BIN3_DWIDTH = 14 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTH = 4096 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTH = 4096 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTH = 4096 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTH = 4096 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN0_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HP_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN1_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HP_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN2_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HP_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN3_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_HP_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN0_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_TP_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN1_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_TP_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN2_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_TP_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN3_DEPTH = 128 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RDYLST_TP_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH = 13 ;
localparam HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH_WPARITY = HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH + 1 ;
localparam HQM_ATM_LL_RLST_CNT_DEPTH = 128 ;
localparam HQM_ATM_LL_RLST_CNT_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_RLST_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_RLST_CNT_DWIDTH = 56 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN0_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HP_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN1_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HP_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN2_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HP_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN3_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_HP_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN0_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TP_BIN0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN1_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TP_BIN1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN2_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TP_BIN2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN3_DEPTH = 512 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCHLST_TP_BIN3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH = 13 ;
localparam HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH_WPARITY = HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH + 1 ;
localparam HQM_ATM_LL_SCH_CNT_DUP0_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCH_CNT_DUP0_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH = 15 ;
localparam HQM_ATM_LL_SCH_CNT_DUP1_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCH_CNT_DUP1_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCH_CNT_DUP1_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCH_CNT_DUP1_DWIDTH = 15 ;
localparam HQM_ATM_LL_SCH_CNT_DUP2_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCH_CNT_DUP2_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCH_CNT_DUP2_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCH_CNT_DUP2_DWIDTH = 15 ;
localparam HQM_ATM_LL_SCH_CNT_DUP3_DEPTH = 4096 ;
localparam HQM_ATM_LL_SCH_CNT_DUP3_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SCH_CNT_DUP3_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SCH_CNT_DUP3_DWIDTH = 15 ;
localparam HQM_ATM_LL_SLST_CNT_DEPTH = 512 ;
localparam HQM_ATM_LL_SLST_CNT_DEPTHB2 = AW_logb2 ( HQM_ATM_LL_SLST_CNT_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_LL_SLST_CNT_DWIDTH = 56 ;
localparam HQM_ATM_NUM_BIN = 4 ;
localparam HQM_ATM_QID2CQIDIX_DEPTH = 128 ;
localparam HQM_ATM_QID2CQIDIX_DEPTHB2 = AW_logb2 ( HQM_ATM_QID2CQIDIX_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_QID2CQIDIX_DWIDTH = 512 + 16 ;
localparam HQM_ATM_QID_RDYLST_CLAMP_DEPTH = 128 ;
localparam HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 = AW_logb2 ( HQM_ATM_QID_RDYLST_CLAMP_DEPTH - 1 ) + 1 ;
localparam HQM_ATM_QID_RDYLST_CLAMP_DWIDTH = 6 ;
localparam HQM_ATM_SCH_CNT_CNTB2 = 13 ; // 4k entries
localparam HQM_ATM_SCH_CNT_CNTB2WR = 13 + 2 ; // 4k entries
localparam HQM_ATM_SCH_RE = 4'd10 ;
localparam HQM_ATM_SCH_RS = 4'd9 ;
localparam HQM_ATM_SCH_SE = 4'd7 ;
localparam HQM_ATM_SCH_SS = 4'd8 ;
localparam HQM_ATM_SEED = 0123 ;
typedef struct packed { 
  logic hold ; 
  logic bypsel ; 
  logic enable ;
} hqm_ll_ctrl_t ;
typedef struct packed { 
  logic [ ( 6 ) - 1 : 0 ] cq ; 
  logic [ ( 7 ) - 1 : 0 ] qid ; 
  logic [ ( 3 ) - 1 : 0 ] qidix ; 
  logic parity ; logic [ ( 3 ) - 1 : 0 ] qpri ;
  logic [ ( 2 ) - 1 : 0 ] bin ; 
  logic [ ( 12 ) - 1 : 0 ] fid ; 
  logic fid_parity ; 
  logic spare ;
} hqm_fid2qidix_data_t ;
typedef struct packed { 
  logic rdysch ; 
  logic pcm ;
  logic [ ( 2 ) - 1 : 0 ] cmd ; 
  logic [ ( 2 ) - 1 : 0 ] cmd_syncopy ; 
  logic [ ( 6 ) - 1 : 0 ] cq ; 
  logic [ ( 7 ) - 1 : 0 ] qid ; 
  logic [ ( 3 ) - 1 : 0 ] qidix ; 
  logic qidix_msb ; 
  logic [ ( 3 ) - 1 : 0 ] qpri ; 
  logic [ ( 2 ) - 1 : 0 ] bin ; 
  logic [ ( 2 ) - 1 : 0 ] rdy_bin ; 
  logic [ ( 4 * 12 ) - 1 : 0 ] rdy_hp ; 
  logic [ ( 4 * 12 ) - 1 : 0 ] rdy_tp ; 
  logic [ ( 4 * 12 ) - 1 : 0 ] sch_hp ; 
  logic [ ( 4 * 12 ) - 1 : 0 ] sch_tp ; 
  logic [ ( 12 ) - 1 : 0 ] fid ; 
  logic fid_sync ; 
  logic parity ; 
  logic fid_parity ; 
  logic [ ( 4 * 1 ) - 1 : 0 ] rdy_hp_parity ; 
  logic [ ( 4 * 1 ) - 1 : 0 ] rdy_tp_parity ; 
  logic [ ( 4 * 1 ) - 1 : 0 ] sch_hp_parity ; 
  logic [ ( 4 * 1 ) - 1 : 0 ] sch_tp_parity ; 
  logic error ; hqm_core_flags_t hqm_core_flags ; 
  logic [ ( 4 ) - 1 : 0 ] bypassed_sch_tp ; 
  logic super_bypassed ; 
} hqm_ll_data_t ;
aw_alarm_syn_t [ ( HQM_AP_ALARM_NUM_COR ) - 1 : 0 ] int_cor_data ;
aw_alarm_syn_t [ ( HQM_AP_ALARM_NUM_INF ) - 1 : 0 ] int_inf_data ;
aw_alarm_syn_t [ ( HQM_AP_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_data ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p3_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_rw_nxt ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p1_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p2_rw_f_nc ;
aw_rmwpipe_cmd_t [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_fid2cqqidix_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_fid2cqqidix_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_fid2cqqidix_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_fid2cqqidix_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_fid2cqqidix_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_rlst_cnt_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t rmw_ll_rlst_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_rlst_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_ll_rlst_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_rlst_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_rlst_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_slst_cnt_p0_byp_rw_nxt ;
aw_rmwpipe_cmd_t rmw_ll_slst_cnt_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_slst_cnt_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_ll_slst_cnt_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_slst_cnt_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_ll_slst_cnt_p3_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_qid_rdylst_clamp_p0_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_qid_rdylst_clamp_p0_rw_nxt ;
aw_rmwpipe_cmd_t rmw_qid_rdylst_clamp_p1_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_qid_rdylst_clamp_p2_rw_f_nc ;
aw_rmwpipe_cmd_t rmw_qid_rdylst_clamp_p3_rw_f_nc ;

idle_status_t cfg_unit_idle_f , cfg_unit_idle_nxt ;
logic                  disable_smon ;
assign disable_smon = 1'b0 ;
logic  pf_reset_active_0 ;
logic  pf_reset_active_1 ;
logic cfg_rx_idle ;
logic cfg_idle ;
logic int_idle ;
logic unit_idle_hqm_clk_gated ;
logic unit_idle_hqm_clk_inp_gated ;
logic p5_ll_v_syncopy0_f ;
logic p5_ll_v_syncopy1_f ;
logic p5_ll_v_syncopy2_f ;
logic arb_ll_rdy_pri_dup0_winner_v_nc ;
logic arb_ll_rdy_pri_dup1_winner_v_nc ;
logic arb_ll_rdy_pri_dup2_winner_v_nc ;
logic arb_ll_rdy_pri_dup3_winner_v_nc ;
logic arb_ll_rdy_winner_v ;
logic arb_ll_sch_winner_v ;
logic arb_ll_strict_winner ;
logic arb_ll_strict_winner_v ;
logic db_ap_aqed_ready ;
logic db_ap_aqed_valid ;
logic db_ap_lsp_enq_ready ;
logic db_ap_lsp_enq_valid ;
logic db_aqed_ap_enq_ready ;
logic db_aqed_ap_enq_valid ;
logic db_lsp_ap_atm_ready ;
logic db_lsp_ap_atm_valid ;
logic fifo_ap_aqed_afull ;
logic fifo_ap_aqed_empty ;
logic fifo_ap_aqed_error_of ;
logic fifo_ap_aqed_error_uf ;
logic fifo_ap_aqed_full ;
logic fifo_ap_aqed_pop ;
logic fifo_ap_aqed_push ;
logic fifo_ap_lsp_enq_afull ;
logic fifo_ap_lsp_enq_empty ;
logic fifo_ap_lsp_enq_error_of ;
logic fifo_ap_lsp_enq_error_uf ;
logic fifo_ap_lsp_enq_full ;
logic fifo_ap_lsp_enq_pop ;
logic fifo_ap_lsp_enq_push ;
logic fifo_aqed_ap_enq_afull ;
logic fifo_aqed_ap_enq_empty ;
logic fifo_aqed_ap_enq_error_of ;
logic fifo_aqed_ap_enq_error_uf ;
logic fifo_aqed_ap_enq_full ;
logic fifo_aqed_ap_enq_pop ;
logic fifo_aqed_ap_enq_push ;
logic fifo_enqueue0_pop_fid_parity ;
logic fifo_enqueue0_pop_parity ;
logic fifo_enqueue0_push_fid_parity ;
logic fifo_enqueue0_push_parity ;
logic fifo_enqueue1_pop_fid_parity ;
logic fifo_enqueue1_pop_parity ;
logic fifo_enqueue1_push_fid_parity ;
logic fifo_enqueue1_push_parity ;
logic fifo_enqueue2_pop_fid_parity ;
logic fifo_enqueue2_pop_parity ;
logic fifo_enqueue2_push_fid_parity ;
logic fifo_enqueue2_push_parity ;
logic fifo_enqueue3_pop_fid_parity ;
logic fifo_enqueue3_pop_parity ;
logic fifo_enqueue3_push_fid_parity ;
logic fifo_enqueue3_push_parity ;
logic p0_fid2qidix_v_f , p0_fid2qidix_v_nxt , p1_fid2qidix_v_f , p1_fid2qidix_v_nxt , p2_fid2qidix_v_f , p2_fid2qidix_v_nxt ;
logic p0_ll_v_f , p0_ll_v_nxt , p1_ll_v_f , p1_ll_v_nxt , p2_ll_v_f , p2_ll_v_nxt , p3_ll_v_f , p3_ll_v_nxt , p4_ll_v_f , p4_ll_v_nxt , p5_ll_v_f , p5_ll_v_nxt , p6_ll_v_f , p6_ll_v_nxt ;
logic parity_check_aqed_ap_enq_e ;
logic parity_check_aqed_ap_enq_error ;
logic parity_check_aqed_ap_enq_flid_e ;
logic parity_check_aqed_ap_enq_flid_error ;
logic parity_check_aqed_ap_enq_flid_p ;
logic parity_check_aqed_ap_enq_p ;
logic parity_check_fid2cqqidix_e ;
logic parity_check_fid2cqqidix_error ;
logic parity_check_fid2cqqidix_p ;
logic parity_check_ll_rdylst_bin0_hp_e ;
logic parity_check_ll_rdylst_bin0_hp_error ;
logic parity_check_ll_rdylst_bin0_hp_p ;
logic parity_check_ll_rdylst_bin0_hpnxt_e ;
logic parity_check_ll_rdylst_bin0_hpnxt_error ;
logic parity_check_ll_rdylst_bin0_hpnxt_p ;
logic parity_check_ll_rdylst_bin0_tp_e ;
logic parity_check_ll_rdylst_bin0_tp_error ;
logic parity_check_ll_rdylst_bin0_tp_p ;
logic parity_check_ll_rdylst_bin1_hp_e ;
logic parity_check_ll_rdylst_bin1_hp_error ;
logic parity_check_ll_rdylst_bin1_hp_p ;
logic parity_check_ll_rdylst_bin1_hpnxt_e ;
logic parity_check_ll_rdylst_bin1_hpnxt_error ;
logic parity_check_ll_rdylst_bin1_hpnxt_p ;
logic parity_check_ll_rdylst_bin1_tp_e ;
logic parity_check_ll_rdylst_bin1_tp_error ;
logic parity_check_ll_rdylst_bin1_tp_p ;
logic parity_check_ll_rdylst_bin2_hp_e ;
logic parity_check_ll_rdylst_bin2_hp_error ;
logic parity_check_ll_rdylst_bin2_hp_p ;
logic parity_check_ll_rdylst_bin2_hpnxt_e ;
logic parity_check_ll_rdylst_bin2_hpnxt_error ;
logic parity_check_ll_rdylst_bin2_hpnxt_p ;
logic parity_check_ll_rdylst_bin2_tp_e ;
logic parity_check_ll_rdylst_bin2_tp_error ;
logic parity_check_ll_rdylst_bin2_tp_p ;
logic parity_check_ll_rdylst_bin3_hp_e ;
logic parity_check_ll_rdylst_bin3_hp_error ;
logic parity_check_ll_rdylst_bin3_hp_p ;
logic parity_check_ll_rdylst_bin3_hpnxt_e ;
logic parity_check_ll_rdylst_bin3_hpnxt_error ;
logic parity_check_ll_rdylst_bin3_hpnxt_p ;
logic parity_check_ll_rdylst_bin3_tp_e ;
logic parity_check_ll_rdylst_bin3_tp_error ;
logic parity_check_ll_rdylst_bin3_tp_p ;
logic parity_check_ll_schlst_bin0_hp_e ;
logic parity_check_ll_schlst_bin0_hp_error ;
logic parity_check_ll_schlst_bin0_hp_p ;
logic parity_check_ll_schlst_bin0_hpnxt_e ;
logic parity_check_ll_schlst_bin0_hpnxt_error ;
logic parity_check_ll_schlst_bin0_hpnxt_p ;
logic parity_check_ll_schlst_bin0_tp_e ;
logic parity_check_ll_schlst_bin0_tp_error ;
logic parity_check_ll_schlst_bin0_tp_p ;
logic parity_check_ll_schlst_bin0_tpprv_e ;
logic parity_check_ll_schlst_bin0_tpprv_error ;
logic parity_check_ll_schlst_bin0_tpprv_p ;
logic parity_check_ll_schlst_bin1_hp_e ;
logic parity_check_ll_schlst_bin1_hp_error ;
logic parity_check_ll_schlst_bin1_hp_p ;
logic parity_check_ll_schlst_bin1_hpnxt_e ;
logic parity_check_ll_schlst_bin1_hpnxt_error ;
logic parity_check_ll_schlst_bin1_hpnxt_p ;
logic parity_check_ll_schlst_bin1_tp_e ;
logic parity_check_ll_schlst_bin1_tp_error ;
logic parity_check_ll_schlst_bin1_tp_p ;
logic parity_check_ll_schlst_bin1_tpprv_e ;
logic parity_check_ll_schlst_bin1_tpprv_error ;
logic parity_check_ll_schlst_bin1_tpprv_p ;
logic parity_check_ll_schlst_bin2_hp_e ;
logic parity_check_ll_schlst_bin2_hp_error ;
logic parity_check_ll_schlst_bin2_hp_p ;
logic parity_check_ll_schlst_bin2_hpnxt_e ;
logic parity_check_ll_schlst_bin2_hpnxt_error ;
logic parity_check_ll_schlst_bin2_hpnxt_p ;
logic parity_check_ll_schlst_bin2_tp_e ;
logic parity_check_ll_schlst_bin2_tp_error ;
logic parity_check_ll_schlst_bin2_tp_p ;
logic parity_check_ll_schlst_bin2_tpprv_e ;
logic parity_check_ll_schlst_bin2_tpprv_error ;
logic parity_check_ll_schlst_bin2_tpprv_p ;
logic parity_check_ll_schlst_bin3_hp_e ;
logic parity_check_ll_schlst_bin3_hp_error ;
logic parity_check_ll_schlst_bin3_hp_p ;
logic parity_check_ll_schlst_bin3_hpnxt_e ;
logic parity_check_ll_schlst_bin3_hpnxt_error ;
logic parity_check_ll_schlst_bin3_hpnxt_p ;
logic parity_check_ll_schlst_bin3_tp_e ;
logic parity_check_ll_schlst_bin3_tp_error ;
logic parity_check_ll_schlst_bin3_tp_p ;
logic parity_check_ll_schlst_bin3_tpprv_e ;
logic parity_check_ll_schlst_bin3_tpprv_error ;
logic parity_check_ll_schlst_bin3_tpprv_p ;
logic parity_check_qid2cqidix_e ;
logic parity_check_qid_rdylst_clamp_e ;
logic parity_check_qid_rdylst_clamp_error ;
logic parity_check_qid_rdylst_clamp_p ;
logic parity_gen_fid2cqqidix_p ;

logic residue_check_enq_cnt_r_bin0_e ;
logic residue_check_enq_cnt_r_bin0_err ;
logic residue_check_enq_cnt_r_bin1_e ;
logic residue_check_enq_cnt_r_bin1_err ;
logic residue_check_enq_cnt_r_bin2_e ;
logic residue_check_enq_cnt_r_bin2_err ;
logic residue_check_enq_cnt_r_bin3_e ;
logic residue_check_enq_cnt_r_bin3_err ;
logic residue_check_enq_cnt_s_bin0_e ;
logic residue_check_enq_cnt_s_bin0_err ;
logic residue_check_enq_cnt_s_bin1_e ;
logic residue_check_enq_cnt_s_bin1_err ;
logic residue_check_enq_cnt_s_bin2_e ;
logic residue_check_enq_cnt_s_bin2_err ;
logic residue_check_enq_cnt_s_bin3_e ;
logic residue_check_enq_cnt_s_bin3_err ;
logic residue_check_ll_rlst_cnt_bin0_e ;
logic residue_check_ll_rlst_cnt_bin0_err ;
logic residue_check_ll_rlst_cnt_bin1_e ;
logic residue_check_ll_rlst_cnt_bin1_err ;
logic residue_check_ll_rlst_cnt_bin2_e ;
logic residue_check_ll_rlst_cnt_bin2_err ;
logic residue_check_ll_rlst_cnt_bin3_e ;
logic residue_check_ll_rlst_cnt_bin3_err ;
logic residue_check_ll_slst_cnt_bin0_e ;
logic residue_check_ll_slst_cnt_bin0_err ;
logic residue_check_ll_slst_cnt_bin1_e ;
logic residue_check_ll_slst_cnt_bin1_err ;
logic residue_check_ll_slst_cnt_bin2_e ;
logic residue_check_ll_slst_cnt_bin2_err ;
logic residue_check_ll_slst_cnt_bin3_e ;
logic residue_check_ll_slst_cnt_bin3_err ;
logic residue_check_sch_cnt_bin0_e ;
logic residue_check_sch_cnt_bin0_err ;
logic residue_check_sch_cnt_bin1_e ;
logic residue_check_sch_cnt_bin1_err ;
logic residue_check_sch_cnt_bin2_e ;
logic residue_check_sch_cnt_bin2_err ;
logic residue_check_sch_cnt_bin3_e ;
logic residue_check_sch_cnt_bin3_err ;
logic rmw_fid2cqqidix_p0_hold ;
logic rmw_fid2cqqidix_p0_v_f ;
logic rmw_fid2cqqidix_p0_v_nxt ;
logic rmw_fid2cqqidix_p1_hold ;
logic rmw_fid2cqqidix_p1_v_f ;
logic rmw_fid2cqqidix_p2_hold ;
logic rmw_fid2cqqidix_p2_v_f ;
logic rmw_fid2cqqidix_p3_bypaddr_sel_nxt ;
logic rmw_fid2cqqidix_p3_bypdata_sel_nxt ;
logic rmw_fid2cqqidix_p3_hold ;
logic rmw_fid2cqqidix_p3_v_f ;
logic rmw_fid2cqqidix_status ;
logic rmw_ll_rlst_cnt_p0_byp_v_nxt ;
logic rmw_ll_rlst_cnt_p0_hold ;
logic rmw_ll_rlst_cnt_p0_v_f ;
logic rmw_ll_rlst_cnt_p0_v_nxt ;
logic rmw_ll_rlst_cnt_p1_hold ;
logic rmw_ll_rlst_cnt_p1_v_f ;
logic rmw_ll_rlst_cnt_p2_hold ;
logic rmw_ll_rlst_cnt_p2_v_f ;
logic rmw_ll_rlst_cnt_p3_bypaddr_sel_nxt ;
logic rmw_ll_rlst_cnt_p3_bypdata_sel_nxt ;
logic rmw_ll_rlst_cnt_p3_hold ;
logic rmw_ll_rlst_cnt_p3_v_f ;
logic rmw_ll_rlst_cnt_status ;
logic rmw_ll_slst_cnt_p0_byp_v_nxt ;
logic rmw_ll_slst_cnt_p0_hold ;
logic rmw_ll_slst_cnt_p0_v_f ;
logic rmw_ll_slst_cnt_p0_v_nxt ;
logic rmw_ll_slst_cnt_p1_hold ;
logic rmw_ll_slst_cnt_p1_v_f ;
logic rmw_ll_slst_cnt_p2_hold ;
logic rmw_ll_slst_cnt_p2_v_f ;
logic rmw_ll_slst_cnt_p3_bypaddr_sel_nxt ;
logic rmw_ll_slst_cnt_p3_bypdata_sel_nxt ;
logic rmw_ll_slst_cnt_p3_hold ;
logic rmw_ll_slst_cnt_p3_v_f ;
logic rmw_ll_slst_cnt_status ;
logic rmw_qid_rdylst_clamp_p0_hold ;
logic rmw_qid_rdylst_clamp_p0_v_f_nc ;
logic rmw_qid_rdylst_clamp_p0_v_nxt ;
logic rmw_qid_rdylst_clamp_p1_hold ;
logic rmw_qid_rdylst_clamp_p1_v_f_nc ;
logic rmw_qid_rdylst_clamp_p2_hold ;
logic rmw_qid_rdylst_clamp_p2_v_f_nc ;
logic rmw_qid_rdylst_clamp_p3_bypaddr_sel_nxt ;
logic rmw_qid_rdylst_clamp_p3_bypdata_sel_nxt ;
logic rmw_qid_rdylst_clamp_p3_hold ;
logic rmw_qid_rdylst_clamp_p3_v_f_nc ;
logic rmw_qid_rdylst_clamp_status ;
logic smon_interrupt_nc ;
logic stall_nc ;
logic [ ( $bits ( ap_alarm_up_data.unit ) - 1 ) : 0 ] int_uid ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_active_0_nxt , reset_pf_active_0_f ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_active_1_nxt , reset_pf_active_1_f ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_done_0_nxt , reset_pf_done_0_f ;
logic [ ( 1 ) - 1 : 0 ] reset_pf_done_1_nxt , reset_pf_done_1_f ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control0_f , cfg_control0_nxt ; //chicken
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control1_f , cfg_control1_nxt ; //chicken/weights
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control2_f , cfg_control2_nxt ; //weights
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control4_f , cfg_control4_nxt ; //pipeline credits
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control7_f , cfg_control7_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_control8_f , cfg_control8_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_csr_control_f , cfg_csr_control_nxt ; //alarm enables
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_error_inj_f , cfg_error_inj_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_interface_f , cfg_interface_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_hold_00_f , cfg_pipe_health_hold_00_nxt ;
logic [ ( 1 * 32 ) - 1 : 0 ] cfg_pipe_health_valid_00_f , cfg_pipe_health_valid_00_nxt ;
logic [ ( 10 ) - 1 : 0 ] parity_check_aqed_ap_enq_d ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue0_byp_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue0_pop_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue0_push_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue1_byp_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue1_pop_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue1_push_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue2_byp_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue2_pop_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue2_push_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue3_byp_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue3_pop_fid ;
logic [ ( 12 ) - 1 : 0 ] fifo_enqueue3_push_fid ;
logic [ ( 12 ) - 1 : 0 ] parity_check_aqed_ap_enq_flid_d ;
logic [ ( 16 ) - 1 : 0 ] p0_debug_print_nc ;
logic [ ( 16 ) - 1 : 0 ] p1_debug_print_nc ;
logic [ ( 16 ) - 1 : 0 ] p2_debug_print_nc ;
logic [ ( 16 ) - 1 : 0 ] p3_debug_print_nc ;
logic [ ( 16 ) - 1 : 0 ] p4_debug_print_nc ;
logic [ ( 16 ) - 1 : 0 ] p5_debug_print_nc ;
logic [ ( 16 ) - 1 : 0 ] p6_debug_print_nc ;
logic [ ( 16 ) - 1 : 0 ] parity_check_qid2cqidix_err ;
logic [ ( 16 ) - 1 : 0 ] parity_check_qid2cqidix_err_f ;
logic [ ( 16 ) - 1 : 0 ] parity_check_qid2cqidix_p ;
logic [ ( 16 * 1 ) - 1 : 0 ] smon_v , smon_v_f ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_comp , smon_comp_f ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_comp_nxt ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_val , smon_val_f ;
logic [ ( 16 * 32 ) - 1 : 0 ] smon_val_nxt ;
logic [ ( 2 ) - 1 : 0 ] ap_lsp_cmd_nxt , ap_lsp_cmd_f ;
logic [ ( 2 ) - 1 : 0 ] arb_enqueue_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_rdy_pri_dup0_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_rdy_pri_dup1_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_rdy_pri_dup2_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_rdy_pri_dup3_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_rdy_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_sch_winner ;
logic [ ( 2 ) - 1 : 0 ] arb_ll_strict_reqs ;
logic [ ( 2 ) - 1 : 0 ] error_headroom ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue0_pop_bin ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue0_push_bin ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue1_pop_bin ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue1_push_bin ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue2_pop_bin ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue2_push_bin ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue3_pop_bin ;
logic [ ( 2 ) - 1 : 0 ] fifo_enqueue3_push_bin ;
logic [ ( 2 ) - 1 : 0 ] rdy_bin_nnc ;
logic [ ( 2 ) - 1 : 0 ] rdy_dup_nnc ;
logic [ ( 2 ) - 1 : 0 ] residue_add_enq_cnt_r_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_enq_cnt_r_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_enq_cnt_r_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_enq_cnt_s_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_enq_cnt_s_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_enq_cnt_s_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rlst_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rlst_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_rlst_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_sch_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_sch_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_sch_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_add_slst_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_slst_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_slst_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin0_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin1_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin2_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin3_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin0_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin1_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin2_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin3_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin0_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin1_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin2_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin3_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin0_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin1_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin2_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin3_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_sch_cnt_bin0_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_sch_cnt_bin1_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_sch_cnt_bin2_r ;
logic [ ( 2 ) - 1 : 0 ] residue_check_sch_cnt_bin3_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_enq_cnt_r_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_enq_cnt_r_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_enq_cnt_r_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_enq_cnt_s_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_enq_cnt_s_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_enq_cnt_s_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rlst_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rlst_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_rlst_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_sch_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_sch_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_sch_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_slst_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_slst_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_slst_cnt_r ;
logic [ ( 2 ) - 1 : 0 ] sch_bin_nnc ;
logic ap_lsp_qidix_msb_nxt , ap_lsp_qidix_msb_f ;
logic [ ( 3 ) - 1 : 0 ] ap_lsp_qidix_nxt , ap_lsp_qidix_f ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue0_byp_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue0_pop_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue0_pop_qpri ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue0_push_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue0_push_qpri ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue1_byp_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue1_pop_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue1_pop_qpri ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue1_push_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue1_push_qpri ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue2_byp_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue2_pop_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue2_pop_qpri ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue2_push_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue2_push_qpri ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue3_byp_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue3_pop_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue3_pop_qpri ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue3_push_qidix ;
logic [ ( 3 ) - 1 : 0 ] fifo_enqueue3_push_qpri ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_control_nxt , cfg_agitate_control_f ;
logic [ ( 32 ) - 1 : 0 ] cfg_agitate_select_nxt , cfg_agitate_select_f ;
logic [ ( 32 ) - 1 : 0 ] cfg_status0 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status1 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status2 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status3 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status4 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status5 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status6 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status7 ;
logic [ ( 32 ) - 1 : 0 ] cfg_status8 ;
logic [ ( 32 ) - 1 : 0 ] fcnt ;
logic [ ( 32 ) - 1 : 0 ] int_status ;
logic [ ( 32 ) - 1 : 0 ] reset_pf_counter_0_nxt , reset_pf_counter_0_f ;
logic [ ( 32 ) - 1 : 0 ] reset_pf_counter_1_nxt , reset_pf_counter_1_f ;
logic [ ( 32 ) - 1 : 0 ] tcnt ;
logic [ ( 4 ) - 1 : 0 ] arb_enqueue_mask ;
logic [ ( 4 ) - 1 : 0 ] arb_enqueue_mask0 ;
logic [ ( 4 ) - 1 : 0 ] arb_enqueue_mask1 ;
logic [ ( 4 ) - 1 : 0 ] arb_enqueue_reqs ;
logic [ ( 4 ) - 1 : 0 ] arb_ll_rdy_pri_dup0_reqs ;
logic [ ( 4 ) - 1 : 0 ] arb_ll_rdy_pri_dup1_reqs ;
logic [ ( 4 ) - 1 : 0 ] arb_ll_rdy_pri_dup2_reqs ;
logic [ ( 4 ) - 1 : 0 ] arb_ll_rdy_pri_dup3_reqs ;
logic [ ( 4 ) - 1 : 0 ] arb_ll_rdy_reqs ;
logic [ ( 4 ) - 1 : 0 ] arb_ll_sch_reqs ;
logic [ ( 4 ) - 1 : 0 ] not_empty_nnc ;
logic [ ( 4 * 2 ) - 1 : 0 ] m_residue_add_slst_cnt_a ;
logic [ ( 4 * 2 ) - 1 : 0 ] m_residue_add_slst_cnt_b ;
logic [ ( 4 * 2 ) - 1 : 0 ] m_residue_add_slst_cnt_r ;
logic [ ( 4 * 2 ) - 1 : 0 ] m_residue_sub_slst_cnt_a ;
logic [ ( 4 * 2 ) - 1 : 0 ] m_residue_sub_slst_cnt_b ;
logic [ ( 4 * 2 ) - 1 : 0 ] m_residue_sub_slst_cnt_r ;
logic [ ( 5 ) - 1 : 0 ] fifo_ap_aqed_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_ap_aqed_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] fifo_ap_lsp_enq_cnt_f ;
logic [ ( 5 ) - 1 : 0 ] fifo_ap_lsp_enq_cnt_nxt ;
logic [ ( 5 ) - 1 : 0 ] parity_check_qid_rdylst_clamp_d ;
logic [ ( 512 ) - 1 : 0 ] parity_check_qid2cqidix_d ;
logic [ ( 528 ) - 1 : 0 ] ap_lsp_qid2cqqidix_nxt , ap_lsp_qid2cqqidix_f ;
logic [ ( 6 ) - 1 : 0 ] ap_lsp_cq_nxt , ap_lsp_cq_f ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue0_byp_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue0_pop_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue0_push_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue1_byp_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue1_pop_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue1_push_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue2_byp_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue2_pop_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue2_push_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue3_byp_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue3_pop_cq ;
logic [ ( 6 ) - 1 : 0 ] fifo_enqueue3_push_cq ;
logic [ ( 7 ) - 1 : 0 ] ap_lsp_qid_nxt , ap_lsp_qid_f ;
logic [ ( 7 ) - 1 : 0 ] db_ap_aqed_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] db_ap_lsp_enq_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] db_aqed_ap_enq_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] db_lsp_ap_atm_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] db_lsp_aqed_cmp_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue0_pop_qid ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue0_push_qid ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue1_pop_qid ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue1_push_qid ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue2_pop_qid ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue2_push_qid ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue3_pop_qid ;
logic [ ( 7 ) - 1 : 0 ] fifo_enqueue3_push_qid ;
logic [ ( 9 ) - 1 : 0 ] parity_check_fid2cqqidix_d ;
logic [ ( 9 ) - 1 : 0 ] parity_gen_fid2cqqidix_d ;
logic [ ( HQM_AP_ALARM_NUM_COR ) - 1 : 0 ] int_cor_v ;
logic [ ( HQM_AP_ALARM_NUM_INF ) - 1 : 0 ] int_inf_v ;
logic [ ( HQM_AP_ALARM_NUM_UNC ) - 1 : 0 ] int_unc_v ;



logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] enq_cnt_r_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] enq_cnt_rm1_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] enq_cnt_rp1_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] enq_cnt_s_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] enq_cnt_sm1_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] enq_cnt_sp1_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin0_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin1_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin2_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_r_bin3_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin0_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin1_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin2_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_enq_cnt_s_bin3_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin0_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin1_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin2_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_rlst_cnt_bin3_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin0_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin1_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin2_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] residue_check_ll_slst_cnt_bin3_d ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] rlst_cnt_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] rlst_cntm1_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] rlst_cntp1_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] rlst_total_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] slst_cnt_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] slst_cntm1_nnc ;
logic [ ( HQM_ATM_CNTB2 ) - 1 : 0 ] slst_cntp1_nnc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DEPTHB2 ) - 1 : 0 ] rmw_fid2cqqidix_p0_addr_f_nc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DEPTHB2 ) - 1 : 0 ] rmw_fid2cqqidix_p0_addr_nxt ;
logic [ ( HQM_ATM_FID2CQQIDIX_DEPTHB2 ) - 1 : 0 ] rmw_fid2cqqidix_p1_addr_f_nc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DEPTHB2 ) - 1 : 0 ] rmw_fid2cqqidix_p2_addr_f_nc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DEPTHB2 ) - 1 : 0 ] rmw_fid2cqqidix_p3_addr_f_nc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DEPTHB2 ) - 1 : 0 ] rmw_fid2cqqidix_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_FID2CQQIDIX_DWIDTH ) - 1 : 0 ] rmw_fid2cqqidix_p0_data_f_nc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DWIDTH ) - 1 : 0 ] rmw_fid2cqqidix_p0_write_data_nxt_nc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DWIDTH ) - 1 : 0 ] rmw_fid2cqqidix_p1_data_f_nc ;
logic [ ( HQM_ATM_FID2CQQIDIX_DWIDTH ) - 1 : 0 ] rmw_fid2cqqidix_p2_data_f ;
logic [ ( HQM_ATM_FID2CQQIDIX_DWIDTH ) - 1 : 0 ] rmw_fid2cqqidix_p3_bypdata_nxt ;
logic [ ( HQM_ATM_FID2CQQIDIX_DWIDTH ) - 1 : 0 ] rmw_fid2cqqidix_p3_data_f_nc ;
logic [ ( HQM_ATM_FIDB2 ) - 1 : 0 ] rdy_fid_nnc ;
logic [ ( HQM_ATM_FIDB2 ) - 1 : 0 ] sch_fid_nnc ;
logic [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin0_hpnxt_d ;
logic [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin1_hpnxt_d ;
logic [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin2_hpnxt_d ;
logic [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin3_hpnxt_d ;
logic [ ( HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin0_hp_d ;
logic [ ( HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin1_hp_d ;
logic [ ( HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin2_hp_d ;
logic [ ( HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin3_hp_d ;
logic [ ( HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin0_tp_d ;
logic [ ( HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin1_tp_d ;
logic [ ( HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin2_tp_d ;
logic [ ( HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_rdylst_bin3_tp_d ;
logic [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_rlst_cnt_p0_addr_f_nc ;
logic [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_rlst_cnt_p0_addr_nxt ;
logic [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_rlst_cnt_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_rlst_cnt_p1_addr_f_nc ;
logic [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_rlst_cnt_p2_addr_f_nc ;
logic [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_rlst_cnt_p3_addr_f_nc ;
logic [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_rlst_cnt_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p0_data_f_nc ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p0_write_data_nxt ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p1_data_f_nc ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p2_data_f ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p2_data_nxt_nc ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p3_bypdata_nxt ;
logic [ ( HQM_ATM_LL_RLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_rlst_cnt_p3_data_f_nc ;
logic [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin0_hpnxt_d ;
logic [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin1_hpnxt_d ;
logic [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin2_hpnxt_d ;
logic [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin3_hpnxt_d ;
logic [ ( HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin0_hp_d ;
logic [ ( HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin1_hp_d ;
logic [ ( HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin2_hp_d ;
logic [ ( HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin3_hp_d ;
logic [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin0_tpprv_d ;
logic [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin1_tpprv_d ;
logic [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin2_tpprv_d ;
logic [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin3_tpprv_d ;
logic [ ( HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin0_tp_d ;
logic [ ( HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin1_tp_d ;
logic [ ( HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin2_tp_d ;
logic [ ( HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH - 1 ) - 1 : 0 ] parity_check_ll_schlst_bin3_tp_d ;
logic [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_slst_cnt_p0_addr_f_nc ;
logic [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_slst_cnt_p0_addr_nxt ;
logic [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_slst_cnt_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_slst_cnt_p1_addr_f_nc ;
logic [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_slst_cnt_p2_addr_f_nc ;
logic [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_slst_cnt_p3_addr_f_nc ;
logic [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] rmw_ll_slst_cnt_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p0_data_f_nc ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p0_write_data_nxt ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p1_data_f_nc ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p2_data_f ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p2_data_nxt_nc ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p3_bypdata_nxt ;
logic [ ( HQM_ATM_LL_SLST_CNT_DWIDTH ) - 1 : 0 ] rmw_ll_slst_cnt_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN ) - 1 : 0 ] error_slst_cnt_of_nnc ;
logic [ ( HQM_ATM_NUM_BIN ) - 1 : 0 ] error_slst_cnt_uf_nnc ;
logic [ ( HQM_ATM_NUM_BIN ) - 1 : 0 ] report_error_slst_cnt_of ;
logic [ ( HQM_ATM_NUM_BIN ) - 1 : 0 ] report_error_slst_cnt_uf ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup0_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup0_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup1_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup1_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup2_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup2_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup3_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_r_dup3_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_s_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_enq_cnt_s_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_rdylst_hp_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_rdylst_hp_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_rdylst_hpnxt_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_rdylst_hpnxt_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_rdylst_tp_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_rdylst_tp_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_sch_cnt_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_sch_cnt_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_hp_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_hp_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_hpnxt_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_hpnxt_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_tp_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_tp_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_tpprv_re ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] func_ll_schlst_tpprv_we ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p1_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p2_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p1_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p2_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p1_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p2_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_v_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_enq_cnt_s_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_error ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hp_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_error ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_error ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_rdylst_tp_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_sch_cnt_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_error ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hp_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_error ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_error ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tp_status ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_error ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_byp_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_v_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p1_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p1_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p2_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p2_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_bypaddr_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_hold ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_v_f ;
logic [ ( HQM_ATM_NUM_BIN * 1 ) - 1 : 0 ] rmw_ll_schlst_tpprv_status ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup0_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup0_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup1_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup1_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup2_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup2_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup3_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_r_dup3_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup0_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup0_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup1_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup1_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup2_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup2_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup3_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_r_dup3_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p2_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup0_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p2_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup1_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p2_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup2_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p2_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_r_dup3_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_s_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_enq_cnt_s_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_s_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] func_ll_enq_cnt_s_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p2_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_enq_cnt_s_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_rdylst_hpnxt_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_rdylst_hpnxt_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hpnxt_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_rdylst_hpnxt_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_rdylst_hpnxt_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_rdylst_hp_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_rdylst_hp_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hp_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hp_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hp_p0_write_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hp_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hp_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_hp_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_rdylst_hp_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_rdylst_hp_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_rdylst_tp_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_rdylst_tp_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_tp_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_tp_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_tp_p0_write_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_tp_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_tp_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_rdylst_tp_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_rdylst_tp_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_rdylst_tp_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_hpnxt_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_hpnxt_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hpnxt_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_hpnxt_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_hpnxt_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_hp_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_hp_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hp_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hp_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hp_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hp_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hp_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_hp_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hp_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hp_p0_write_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hp_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hp_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hp_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_hp_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_hp_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_hp_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_tpprv_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_tpprv_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tpprv_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tpprv_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tpprv_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tpprv_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_tpprv_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_tpprv_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_tp_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] func_ll_schlst_tp_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tp_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tp_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tp_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tp_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tp_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] rmw_ll_schlst_tp_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tp_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tp_p0_write_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tp_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tp_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tp_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) - 1 : 0 ] rmw_ll_schlst_tp_p3_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_tp_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ) - 1 : 0 ] func_ll_schlst_tp_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] func_ll_sch_cnt_raddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] func_ll_sch_cnt_waddr ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] rmw_ll_sch_cnt_p0_byp_addr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] rmw_ll_sch_cnt_p1_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] rmw_ll_sch_cnt_p2_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] rmw_ll_sch_cnt_p3_addr_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] rmw_ll_sch_cnt_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] func_ll_sch_cnt_rdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] func_ll_sch_cnt_wdata ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p0_byp_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p0_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p0_write_data_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p1_data_f_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p2_data_f ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p2_data_nxt_nc ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p3_bypdata_nxt ;
logic [ ( HQM_ATM_NUM_BIN * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) - 1 : 0 ] rmw_ll_sch_cnt_p3_data_f_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 ) - 1 : 0 ] rmw_qid_rdylst_clamp_p0_addr_f_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 ) - 1 : 0 ] rmw_qid_rdylst_clamp_p0_addr_nxt ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 ) - 1 : 0 ] rmw_qid_rdylst_clamp_p1_addr_f_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 ) - 1 : 0 ] rmw_qid_rdylst_clamp_p2_addr_f_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 ) - 1 : 0 ] rmw_qid_rdylst_clamp_p3_addr_f_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 ) - 1 : 0 ] rmw_qid_rdylst_clamp_p3_bypaddr_nxt ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH ) - 1 : 0 ] rmw_qid_rdylst_clamp_p0_data_f_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH ) - 1 : 0 ] rmw_qid_rdylst_clamp_p0_write_data_nxt_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH ) - 1 : 0 ] rmw_qid_rdylst_clamp_p1_data_f_nc ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH ) - 1 : 0 ] rmw_qid_rdylst_clamp_p2_data_f ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH ) - 1 : 0 ] rmw_qid_rdylst_clamp_p3_bypdata_nxt ;
logic [ ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH ) - 1 : 0 ] rmw_qid_rdylst_clamp_p3_data_f_nc ;
logic [ ( HQM_ATM_SCH_CNT_CNTB2 ) - 1 : 0 ] residue_check_sch_cnt_bin0_d ;
logic [ ( HQM_ATM_SCH_CNT_CNTB2 ) - 1 : 0 ] residue_check_sch_cnt_bin1_d ;
logic [ ( HQM_ATM_SCH_CNT_CNTB2 ) - 1 : 0 ] residue_check_sch_cnt_bin2_d ;
logic [ ( HQM_ATM_SCH_CNT_CNTB2 ) - 1 : 0 ] residue_check_sch_cnt_bin3_d ;
logic [ ( HQM_ATM_SCH_CNT_CNTB2 ) - 1 : 0 ] sch_cnt_nnc ;
logic [ ( HQM_ATM_SCH_CNT_CNTB2 ) - 1 : 0 ] sch_cntm1_nnc ;
logic [ ( HQM_ATM_SCH_CNT_CNTB2 ) - 1 : 0 ] sch_cntp1_nnc ;
logic [ 3 : 0 ] enq_cnt_r_dup0_gt1 ;
logic [ 3 : 0 ] enq_cnt_r_dup1_gt1 ;
logic [ 3 : 0 ] enq_cnt_r_dup2_gt1 ;
logic [ 3 : 0 ] enq_cnt_r_dup3_gt1 ;
logic [ 4 : 0 ] stall_nxt , stall_f ;
logic [ HQM_ATM_FIFO_AP_AQED_WMWIDTH - 1 : 0 ] fifo_ap_aqed_cfg_high_wm ;
logic [ HQM_ATM_FIFO_AP_LSP_ENQ_WMWIDTH - 1 : 0 ] fifo_ap_lsp_enq_cfg_high_wm ;
logic [ HQM_ATM_FIFO_AQED_AP_ENQ_WMWIDTH - 1 : 0 ] fifo_aqed_ap_enq_cfg_high_wm ;
logic ap_lsp_cmd_v_nxt , ap_lsp_cmd_v_f ;
logic ap_lsp_cmpblast_v_nxt , ap_lsp_cmpblast_v_f ;
logic ap_lsp_dec_fid_cnt_v_nxt , ap_lsp_dec_fid_cnt_v_f ;
logic ap_lsp_haswork_rlst_func_nxt , ap_lsp_haswork_rlst_func_f ;
logic ap_lsp_haswork_rlst_v_nxt , ap_lsp_haswork_rlst_v_f ;
logic ap_lsp_haswork_slst_func_nxt , ap_lsp_haswork_slst_func_f ;
logic ap_lsp_haswork_slst_v_nxt , ap_lsp_haswork_slst_v_f ;
logic arb_enqueue_update ;
logic arb_enqueue_winner_v ;
logic block_sch2rdy ;
logic db_lsp_aqed_cmp_ready ;
logic db_lsp_aqed_cmp_v ;
logic enq_empty_nnc ;
logic error_ap_lsp ;
logic error_enq_cnt_r_of_nnc ;
logic error_enq_cnt_r_uf_nnc ;
logic error_enq_cnt_s_of_nnc ;
logic error_enq_cnt_s_uf_nnc ;
logic error_nopri ;
logic error_rlst_cnt_of_nnc ;
logic error_rlst_cnt_uf_nnc ;
logic error_sch_cnt_of_nnc ;
logic error_sch_cnt_uf_nnc ;
logic feature_clamped_high ;
logic feature_clamped_low ;
logic feature_enq_afull ;
logic fifo_ap_aqed_dec ;
logic fifo_ap_aqed_inc ;
logic fifo_ap_lsp_enq_dec ;
logic fifo_ap_lsp_enq_inc ;
logic fifo_enqueue0_byp ;
logic fifo_enqueue0_hold_v ;
logic fifo_enqueue0_pop ;
logic fifo_enqueue0_pop_v ;
logic fifo_enqueue0_push ;
logic fifo_enqueue1_byp ;
logic fifo_enqueue1_hold_v ;
logic fifo_enqueue1_pop ;
logic fifo_enqueue1_pop_v ;
logic fifo_enqueue1_push ;
logic fifo_enqueue2_byp ;
logic fifo_enqueue2_hold_v ;
logic fifo_enqueue2_pop ;
logic fifo_enqueue2_pop_v ;
logic fifo_enqueue2_push ;
logic fifo_enqueue3_byp ;
logic fifo_enqueue3_hold_v ;
logic fifo_enqueue3_pop ;
logic fifo_enqueue3_pop_v ;
logic fifo_enqueue3_push ;
logic hw_init_done_0_nxt , hw_init_done_0_f ;
logic hw_init_done_1_nxt , hw_init_done_1_f ;
logic rdy_fid_parity_nnc ;
logic rdy_override_nnc ;
logic rdy_wins_nnc ;
logic report_error_enq_cnt_r_of ;
logic report_error_enq_cnt_r_uf ;
logic report_error_enq_cnt_s_of ;
logic report_error_enq_cnt_s_uf ;
logic report_error_rlst_cnt_of ;
logic report_error_rlst_cnt_uf ;
logic report_error_sch_cnt_of ;
logic report_error_sch_cnt_uf ;
logic rlst_e_ne_nnc ;
logic rlst_lt_blast_nnc ;
logic rlst_ne_e_nnc ;
logic sch_fid_parity_nnc ;
logic sch_idle_nnc ;
logic sch_wins_nnc ;
logic slst_e_ne_nnc ;
logic slst_ne_e_nnc ;
hqm_ll_data_t p0_ll_data_f , p0_ll_data_nxt , p1_ll_data_f , p1_ll_data_nxt , p2_ll_data_f , p2_ll_data_nxt , p3_ll_data_f , p3_ll_data_nxt , p4_ll_data_f , p4_ll_data_nxt , p5_ll_data_f , p5_ll_data_nxt , p6_ll_data_f , p6_ll_data_nxt ;
hqm_ll_ctrl_t p0_ll_ctrl , p1_ll_ctrl , p2_ll_ctrl , p3_ll_ctrl , p4_ll_ctrl , p5_ll_ctrl , p6_ll_ctrl ;
hqm_fid2qidix_data_t p0_fid2qidix_data_f , p0_fid2qidix_data_nxt , p1_fid2qidix_data_f , p1_fid2qidix_data_nxt , p2_fid2qidix_data_f , p2_fid2qidix_data_nxt ;
hqm_ll_ctrl_t p0_fid2qidix_ctrl , p1_fid2qidix_ctrl , p2_fid2qidix_ctrl ;
lsp_aqed_cmp_t db_lsp_aqed_cmp_data ;
ap_aqed_t db_ap_aqed_data ;
aqed_ap_enq_t db_aqed_ap_enq_data ;
ap_lsp_enq_t db_ap_lsp_enq_data ;
lsp_ap_atm_t db_lsp_ap_atm_data ;
ap_aqed_t fifo_ap_aqed_push_data ;
ap_aqed_t fifo_ap_aqed_pop_data ;
aqed_ap_enq_t fifo_aqed_ap_enq_push_data ;
aqed_ap_enq_t fifo_aqed_ap_enq_pop_data ;
ap_lsp_enq_t fifo_ap_lsp_enq_push_data ;
ap_lsp_enq_t fifo_ap_lsp_enq_pop_data ;
aw_fifo_status_t fifo_ap_aqed_status ;
aw_fifo_status_t fifo_aqed_ap_enq_status ;
aw_fifo_status_t fifo_ap_lsp_enq_status ;
aw_fifo_status_t cfg_rx_fifo_status ;



//------------------------------------------------------------------------------------------------------------------------------------------------
// Check for invalid paramter configation : This will produce a build error if a unsupported paramter value is used
generate
  if ( ~ ( HQM_AQED_DEPTH == ( 2 * 1024 ) ) ) begin : invalid_HQM_ATM_DEPTH_0
    for ( genvar g = HQM_AQED_DEPTH ; g <= HQM_AQED_DEPTH ; g = g + 1 ) begin : invalid_HQM_ATM_DEPTH_1
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
logic rst_prep;
logic hqm_gated_rst_n ;
logic hqm_inp_gated_rst_n ;

assign rst_prep             = hqm_flr_prep;
assign hqm_gated_rst_n      = hqm_gated_rst_b;
assign hqm_inp_gated_rst_n  = hqm_inp_gated_rst_b;

logic hqm_gated_rst_n_start ;
logic hqm_gated_rst_n_active ;
logic hqm_gated_rst_n_done ; 
assign hqm_gated_rst_n_start    = hqm_gated_rst_b_start_atm;
assign hqm_gated_rst_n_active   = hqm_gated_rst_b_active_atm;
assign hqm_gated_rst_n_done = reset_pf_done_0_f & reset_pf_done_1_f ;
assign hqm_gated_rst_b_done_atm = hqm_gated_rst_n_done;
//---------------------------------------------------------------------------------------------------------
// common core - CFG accessible patch & proc registers 
// common core - RFW/SRW RAM gasket
// common core - RAM wrapper for all single PORT SR RAMs
// common core - RAM wrapper for all 2 port RF RAMs
// The following must be kept in-sync with generated code
// BEGIN HQM_CFG_ACCESS
logic [ ( HQM_AP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_write ; //I CFG
logic [ ( HQM_AP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] pfcsr_cfg_req_read ; //I CFG
cfg_req_t pfcsr_cfg_req ; //I CFG
logic pfcsr_cfg_rsp_ack ; //O CFG
logic pfcsr_cfg_rsp_err ; //O CFG
logic [ ( 32 ) - 1 : 0 ] pfcsr_cfg_rsp_rdata ; //O CFG
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_ap_csr_control_reg_nxt ; //I HQM_AP_TARGET_CFG_AP_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_ap_csr_control_reg_f ; //O HQM_AP_TARGET_CFG_AP_CSR_CONTROL
logic hqm_ap_target_cfg_ap_csr_control_reg_v ; //I HQM_AP_TARGET_CFG_AP_CSR_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_nxt ; //I HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_READY_BIN
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_f ; //O HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_READY_BIN
logic hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_v ; //I HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_READY_BIN
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_nxt ; //I HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_f ; //O HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN
logic hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_v ; //I HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_general_reg_nxt ; //I HQM_AP_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_general_reg_f ; //O HQM_AP_TARGET_CFG_CONTROL_GENERAL
logic hqm_ap_target_cfg_control_general_reg_v ; //I HQM_AP_TARGET_CFG_CONTROL_GENERAL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_pipeline_credits_reg_nxt ; //I HQM_AP_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_control_pipeline_credits_reg_f ; //O HQM_AP_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic hqm_ap_target_cfg_control_pipeline_credits_reg_v ; //I HQM_AP_TARGET_CFG_CONTROL_PIPELINE_CREDITS
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_detect_feature_operation_00_reg_nxt ; //I HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_detect_feature_operation_00_reg_f ; //O HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_00
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_detect_feature_operation_01_reg_nxt ; //I HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_01
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_detect_feature_operation_01_reg_f ; //O HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_01
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_diagnostic_aw_status_status ; //I HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_diagnostic_aw_status_01_status ; //I HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_diagnostic_aw_status_02_status ; //I HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_diagnostic_aw_status_03_status ; //I HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_03
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_error_inject_reg_nxt ; //I HQM_AP_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_error_inject_reg_f ; //O HQM_AP_TARGET_CFG_ERROR_INJECT
logic hqm_ap_target_cfg_error_inject_reg_v ; //I HQM_AP_TARGET_CFG_ERROR_INJECT
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt ; //I HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_f ; //O HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_nxt ; //I HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_f ; //O HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt ; //I HQM_AP_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f ; //O HQM_AP_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_hw_agitate_control_reg_nxt ; //I HQM_AP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_hw_agitate_control_reg_f ; //O HQM_AP_TARGET_CFG_HW_AGITATE_CONTROL
logic hqm_ap_target_cfg_hw_agitate_control_reg_v ; //I HQM_AP_TARGET_CFG_HW_AGITATE_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_hw_agitate_select_reg_nxt ; //I HQM_AP_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_hw_agitate_select_reg_f ; //O HQM_AP_TARGET_CFG_HW_AGITATE_SELECT
logic hqm_ap_target_cfg_hw_agitate_select_reg_v ; //I HQM_AP_TARGET_CFG_HW_AGITATE_SELECT
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_interface_status_reg_nxt ; //I HQM_AP_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_interface_status_reg_f ; //O HQM_AP_TARGET_CFG_INTERFACE_STATUS
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_patch_control_reg_nxt ; //I HQM_AP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_patch_control_reg_f ; //O HQM_AP_TARGET_CFG_PATCH_CONTROL
logic hqm_ap_target_cfg_patch_control_reg_v ; //I HQM_AP_TARGET_CFG_PATCH_CONTROL
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_pipe_health_hold_00_reg_nxt ; //I HQM_AP_TARGET_CFG_PIPE_HEALTH_HOLD_00
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_pipe_health_hold_00_reg_f ; //O HQM_AP_TARGET_CFG_PIPE_HEALTH_HOLD_00
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_pipe_health_valid_00_reg_nxt ; //I HQM_AP_TARGET_CFG_PIPE_HEALTH_VALID_00
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_pipe_health_valid_00_reg_f ; //O HQM_AP_TARGET_CFG_PIPE_HEALTH_VALID_00
logic hqm_ap_target_cfg_smon_disable_smon ; //I HQM_AP_TARGET_CFG_SMON
logic [ 16 - 1 : 0 ] hqm_ap_target_cfg_smon_smon_v ; //I HQM_AP_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_ap_target_cfg_smon_smon_comp ; //I HQM_AP_TARGET_CFG_SMON
logic [ ( 16 * 32 ) - 1 : 0 ] hqm_ap_target_cfg_smon_smon_val ; //I HQM_AP_TARGET_CFG_SMON
logic hqm_ap_target_cfg_smon_smon_enabled ; //O HQM_AP_TARGET_CFG_SMON
logic hqm_ap_target_cfg_smon_smon_interrupt ; //O HQM_AP_TARGET_CFG_SMON
logic hqm_ap_target_cfg_syndrome_00_capture_v ; //I HQM_AP_TARGET_CFG_SYNDROME_00
logic [ ( 31 ) - 1 : 0] hqm_ap_target_cfg_syndrome_00_capture_data ; //I HQM_AP_TARGET_CFG_SYNDROME_00
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_syndrome_00_syndrome_data ; //I HQM_AP_TARGET_CFG_SYNDROME_00
logic hqm_ap_target_cfg_syndrome_01_capture_v ; //I HQM_AP_TARGET_CFG_SYNDROME_01
logic [ ( 31 ) - 1 : 0] hqm_ap_target_cfg_syndrome_01_capture_data ; //I HQM_AP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_syndrome_01_syndrome_data ; //I HQM_AP_TARGET_CFG_SYNDROME_01
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_unit_idle_reg_nxt ; //I HQM_AP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_unit_idle_reg_f ; //O HQM_AP_TARGET_CFG_UNIT_IDLE
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_unit_timeout_reg_nxt ; //I HQM_AP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_unit_timeout_reg_f ; //O HQM_AP_TARGET_CFG_UNIT_TIMEOUT
logic [ ( 32 ) - 1 : 0] hqm_ap_target_cfg_unit_version_status ; //I HQM_AP_TARGET_CFG_UNIT_VERSION
hqm_ap_pipe_register_pfcsr i_hqm_ap_pipe_register_pfcsr (
  .hqm_gated_clk ( hqm_gated_clk ) 
, .hqm_gated_rst_n ( hqm_gated_rst_n ) 
, .rst_prep ( '0 )
, .cfg_req_write ( pfcsr_cfg_req_write )
, .cfg_req_read ( pfcsr_cfg_req_read )
, .cfg_req ( pfcsr_cfg_req )
, .cfg_rsp_ack ( pfcsr_cfg_rsp_ack )
, .cfg_rsp_err ( pfcsr_cfg_rsp_err )
, .cfg_rsp_rdata ( pfcsr_cfg_rsp_rdata )
, .hqm_ap_target_cfg_ap_csr_control_reg_nxt ( hqm_ap_target_cfg_ap_csr_control_reg_nxt )
, .hqm_ap_target_cfg_ap_csr_control_reg_f ( hqm_ap_target_cfg_ap_csr_control_reg_f )
, .hqm_ap_target_cfg_ap_csr_control_reg_v (  hqm_ap_target_cfg_ap_csr_control_reg_v )
, .hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_nxt ( hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_nxt )
, .hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_f ( hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_f )
, .hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_v (  hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_v )
, .hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_nxt ( hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_nxt )
, .hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_f ( hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_f )
, .hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_v (  hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_v )
, .hqm_ap_target_cfg_control_general_reg_nxt ( hqm_ap_target_cfg_control_general_reg_nxt )
, .hqm_ap_target_cfg_control_general_reg_f ( hqm_ap_target_cfg_control_general_reg_f )
, .hqm_ap_target_cfg_control_general_reg_v (  hqm_ap_target_cfg_control_general_reg_v )
, .hqm_ap_target_cfg_control_pipeline_credits_reg_nxt ( hqm_ap_target_cfg_control_pipeline_credits_reg_nxt )
, .hqm_ap_target_cfg_control_pipeline_credits_reg_f ( hqm_ap_target_cfg_control_pipeline_credits_reg_f )
, .hqm_ap_target_cfg_control_pipeline_credits_reg_v (  hqm_ap_target_cfg_control_pipeline_credits_reg_v )
, .hqm_ap_target_cfg_detect_feature_operation_00_reg_nxt ( hqm_ap_target_cfg_detect_feature_operation_00_reg_nxt )
, .hqm_ap_target_cfg_detect_feature_operation_00_reg_f ( hqm_ap_target_cfg_detect_feature_operation_00_reg_f )
, .hqm_ap_target_cfg_detect_feature_operation_01_reg_nxt ( hqm_ap_target_cfg_detect_feature_operation_01_reg_nxt )
, .hqm_ap_target_cfg_detect_feature_operation_01_reg_f ( hqm_ap_target_cfg_detect_feature_operation_01_reg_f )
, .hqm_ap_target_cfg_diagnostic_aw_status_status ( hqm_ap_target_cfg_diagnostic_aw_status_status )
, .hqm_ap_target_cfg_diagnostic_aw_status_01_status ( hqm_ap_target_cfg_diagnostic_aw_status_01_status )
, .hqm_ap_target_cfg_diagnostic_aw_status_02_status ( hqm_ap_target_cfg_diagnostic_aw_status_02_status )
, .hqm_ap_target_cfg_diagnostic_aw_status_03_status ( hqm_ap_target_cfg_diagnostic_aw_status_03_status )
, .hqm_ap_target_cfg_error_inject_reg_nxt ( hqm_ap_target_cfg_error_inject_reg_nxt )
, .hqm_ap_target_cfg_error_inject_reg_f ( hqm_ap_target_cfg_error_inject_reg_f )
, .hqm_ap_target_cfg_error_inject_reg_v (  hqm_ap_target_cfg_error_inject_reg_v )
, .hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt ( hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt )
, .hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_f ( hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_f )
, .hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_nxt ( hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_nxt )
, .hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_f ( hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_f )
, .hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt ( hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt )
, .hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f ( hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f )
, .hqm_ap_target_cfg_hw_agitate_control_reg_nxt ( hqm_ap_target_cfg_hw_agitate_control_reg_nxt )
, .hqm_ap_target_cfg_hw_agitate_control_reg_f ( hqm_ap_target_cfg_hw_agitate_control_reg_f )
, .hqm_ap_target_cfg_hw_agitate_control_reg_v (  hqm_ap_target_cfg_hw_agitate_control_reg_v )
, .hqm_ap_target_cfg_hw_agitate_select_reg_nxt ( hqm_ap_target_cfg_hw_agitate_select_reg_nxt )
, .hqm_ap_target_cfg_hw_agitate_select_reg_f ( hqm_ap_target_cfg_hw_agitate_select_reg_f )
, .hqm_ap_target_cfg_hw_agitate_select_reg_v (  hqm_ap_target_cfg_hw_agitate_select_reg_v )
, .hqm_ap_target_cfg_interface_status_reg_nxt ( hqm_ap_target_cfg_interface_status_reg_nxt )
, .hqm_ap_target_cfg_interface_status_reg_f ( hqm_ap_target_cfg_interface_status_reg_f )
, .hqm_ap_target_cfg_patch_control_reg_nxt ( hqm_ap_target_cfg_patch_control_reg_nxt )
, .hqm_ap_target_cfg_patch_control_reg_f ( hqm_ap_target_cfg_patch_control_reg_f )
, .hqm_ap_target_cfg_patch_control_reg_v (  hqm_ap_target_cfg_patch_control_reg_v )
, .hqm_ap_target_cfg_pipe_health_hold_00_reg_nxt ( hqm_ap_target_cfg_pipe_health_hold_00_reg_nxt )
, .hqm_ap_target_cfg_pipe_health_hold_00_reg_f ( hqm_ap_target_cfg_pipe_health_hold_00_reg_f )
, .hqm_ap_target_cfg_pipe_health_valid_00_reg_nxt ( hqm_ap_target_cfg_pipe_health_valid_00_reg_nxt )
, .hqm_ap_target_cfg_pipe_health_valid_00_reg_f ( hqm_ap_target_cfg_pipe_health_valid_00_reg_f )
, .hqm_ap_target_cfg_smon_disable_smon ( hqm_ap_target_cfg_smon_disable_smon )
, .hqm_ap_target_cfg_smon_smon_v ( hqm_ap_target_cfg_smon_smon_v )
, .hqm_ap_target_cfg_smon_smon_comp ( hqm_ap_target_cfg_smon_smon_comp )
, .hqm_ap_target_cfg_smon_smon_val ( hqm_ap_target_cfg_smon_smon_val )
, .hqm_ap_target_cfg_smon_smon_enabled ( hqm_ap_target_cfg_smon_smon_enabled )
, .hqm_ap_target_cfg_smon_smon_interrupt ( hqm_ap_target_cfg_smon_smon_interrupt )
, .hqm_ap_target_cfg_syndrome_00_capture_v ( hqm_ap_target_cfg_syndrome_00_capture_v )
, .hqm_ap_target_cfg_syndrome_00_capture_data ( hqm_ap_target_cfg_syndrome_00_capture_data )
, .hqm_ap_target_cfg_syndrome_00_syndrome_data ( hqm_ap_target_cfg_syndrome_00_syndrome_data )
, .hqm_ap_target_cfg_syndrome_01_capture_v ( hqm_ap_target_cfg_syndrome_01_capture_v )
, .hqm_ap_target_cfg_syndrome_01_capture_data ( hqm_ap_target_cfg_syndrome_01_capture_data )
, .hqm_ap_target_cfg_syndrome_01_syndrome_data ( hqm_ap_target_cfg_syndrome_01_syndrome_data )
, .hqm_ap_target_cfg_unit_idle_reg_nxt ( hqm_ap_target_cfg_unit_idle_reg_nxt )
, .hqm_ap_target_cfg_unit_idle_reg_f ( hqm_ap_target_cfg_unit_idle_reg_f )
, .hqm_ap_target_cfg_unit_timeout_reg_nxt ( hqm_ap_target_cfg_unit_timeout_reg_nxt )
, .hqm_ap_target_cfg_unit_timeout_reg_f ( hqm_ap_target_cfg_unit_timeout_reg_f )
, .hqm_ap_target_cfg_unit_version_status ( hqm_ap_target_cfg_unit_version_status )
) ;
// END HQM_CFG_ACCESS
// BEGIN HQM_RAM_ACCESS
localparam NUM_CFG_ACCESSIBLE_RAM = 2;
localparam CFG_ACCESSIBLE_RAM_AQED_QID2CQIDIX = 0; // HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15
localparam CFG_ACCESSIBLE_RAM_QID_RDYLST_CLAMP = 1; // HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP
logic [(  2 *  1)-1:0] cfg_mem_re;
logic [(  2 *  1)-1:0] cfg_mem_we;
logic [(      20)-1:0] cfg_mem_addr;
logic [(      12)-1:0] cfg_mem_minbit;
logic [(      12)-1:0] cfg_mem_maxbit;
logic [(      32)-1:0] cfg_mem_wdata;
logic [(  2 * 32)-1:0] cfg_mem_rdata;
logic [(  2 *  1)-1:0] cfg_mem_ack;
logic                  cfg_mem_cc_v;
logic [(       8)-1:0] cfg_mem_cc_value;
logic [(       4)-1:0] cfg_mem_cc_width;
logic [(      12)-1:0] cfg_mem_cc_position;


logic                  hqm_lsp_atm_pipe_rfw_top_ipar_error;

logic                  func_aqed_qid2cqidix_re; //I
logic [(       7)-1:0] func_aqed_qid2cqidix_addr; //I
logic                  func_aqed_qid2cqidix_we;    //I
logic [(     528)-1:0] func_aqed_qid2cqidix_wdata; //I
logic [(     528)-1:0] func_aqed_qid2cqidix_rdata;

logic                pf_aqed_qid2cqidix_re;    //I
logic [(       7)-1:0] pf_aqed_qid2cqidix_addr;  //I
logic                  pf_aqed_qid2cqidix_we;    //I
logic [(     528)-1:0] pf_aqed_qid2cqidix_wdata; //I
logic [(     528)-1:0] pf_aqed_qid2cqidix_rdata;

logic                  rf_aqed_qid2cqidix_error;

logic                  func_atm_fifo_ap_aqed_re; //I
logic [(       4)-1:0] func_atm_fifo_ap_aqed_raddr; //I
logic [(       4)-1:0] func_atm_fifo_ap_aqed_waddr; //I
logic                  func_atm_fifo_ap_aqed_we;    //I
logic [(      45)-1:0] func_atm_fifo_ap_aqed_wdata; //I
logic [(      45)-1:0] func_atm_fifo_ap_aqed_rdata;

logic                pf_atm_fifo_ap_aqed_re;    //I
logic [(       4)-1:0] pf_atm_fifo_ap_aqed_raddr; //I
logic [(       4)-1:0] pf_atm_fifo_ap_aqed_waddr; //I
logic                  pf_atm_fifo_ap_aqed_we;    //I
logic [(      45)-1:0] pf_atm_fifo_ap_aqed_wdata; //I
logic [(      45)-1:0] pf_atm_fifo_ap_aqed_rdata;

logic                  rf_atm_fifo_ap_aqed_error;

logic                  func_atm_fifo_aqed_ap_enq_re; //I
logic [(       5)-1:0] func_atm_fifo_aqed_ap_enq_raddr; //I
logic [(       5)-1:0] func_atm_fifo_aqed_ap_enq_waddr; //I
logic                  func_atm_fifo_aqed_ap_enq_we;    //I
logic [(      24)-1:0] func_atm_fifo_aqed_ap_enq_wdata; //I
logic [(      24)-1:0] func_atm_fifo_aqed_ap_enq_rdata;

logic                pf_atm_fifo_aqed_ap_enq_re;    //I
logic [(       5)-1:0] pf_atm_fifo_aqed_ap_enq_raddr; //I
logic [(       5)-1:0] pf_atm_fifo_aqed_ap_enq_waddr; //I
logic                  pf_atm_fifo_aqed_ap_enq_we;    //I
logic [(      24)-1:0] pf_atm_fifo_aqed_ap_enq_wdata; //I
logic [(      24)-1:0] pf_atm_fifo_aqed_ap_enq_rdata;

logic                  rf_atm_fifo_aqed_ap_enq_error;

logic                  func_fid2cqqidix_re; //I
logic [(      12)-1:0] func_fid2cqqidix_raddr; //I
logic [(      12)-1:0] func_fid2cqqidix_waddr; //I
logic                  func_fid2cqqidix_we;    //I
logic [(      10)-1:0] func_fid2cqqidix_wdata; //I
logic [(      10)-1:0] func_fid2cqqidix_rdata;

logic                pf_fid2cqqidix_re;    //I
logic [(      12)-1:0] pf_fid2cqqidix_raddr; //I
logic [(      12)-1:0] pf_fid2cqqidix_waddr; //I
logic                  pf_fid2cqqidix_we;    //I
logic [(      10)-1:0] pf_fid2cqqidix_wdata; //I
logic [(      10)-1:0] pf_fid2cqqidix_rdata;

logic                  rf_fid2cqqidix_error;

logic                  func_ll_enq_cnt_r_bin0_dup0_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup0_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup0_waddr; //I
logic                  func_ll_enq_cnt_r_bin0_dup0_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup0_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup0_rdata;

logic                pf_ll_enq_cnt_r_bin0_dup0_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup0_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup0_waddr; //I
logic                  pf_ll_enq_cnt_r_bin0_dup0_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup0_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup0_rdata;

logic                  rf_ll_enq_cnt_r_bin0_dup0_error;

logic                  func_ll_enq_cnt_r_bin0_dup1_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup1_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup1_waddr; //I
logic                  func_ll_enq_cnt_r_bin0_dup1_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup1_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup1_rdata;

logic                pf_ll_enq_cnt_r_bin0_dup1_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup1_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup1_waddr; //I
logic                  pf_ll_enq_cnt_r_bin0_dup1_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup1_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup1_rdata;

logic                  rf_ll_enq_cnt_r_bin0_dup1_error;

logic                  func_ll_enq_cnt_r_bin0_dup2_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup2_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup2_waddr; //I
logic                  func_ll_enq_cnt_r_bin0_dup2_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup2_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup2_rdata;

logic                pf_ll_enq_cnt_r_bin0_dup2_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup2_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup2_waddr; //I
logic                  pf_ll_enq_cnt_r_bin0_dup2_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup2_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup2_rdata;

logic                  rf_ll_enq_cnt_r_bin0_dup2_error;

logic                  func_ll_enq_cnt_r_bin0_dup3_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup3_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup3_waddr; //I
logic                  func_ll_enq_cnt_r_bin0_dup3_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup3_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup3_rdata;

logic                pf_ll_enq_cnt_r_bin0_dup3_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup3_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup3_waddr; //I
logic                  pf_ll_enq_cnt_r_bin0_dup3_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup3_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup3_rdata;

logic                  rf_ll_enq_cnt_r_bin0_dup3_error;

logic                  func_ll_enq_cnt_r_bin1_dup0_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup0_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup0_waddr; //I
logic                  func_ll_enq_cnt_r_bin1_dup0_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup0_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup0_rdata;

logic                pf_ll_enq_cnt_r_bin1_dup0_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup0_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup0_waddr; //I
logic                  pf_ll_enq_cnt_r_bin1_dup0_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup0_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup0_rdata;

logic                  rf_ll_enq_cnt_r_bin1_dup0_error;

logic                  func_ll_enq_cnt_r_bin1_dup1_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup1_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup1_waddr; //I
logic                  func_ll_enq_cnt_r_bin1_dup1_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup1_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup1_rdata;

logic                pf_ll_enq_cnt_r_bin1_dup1_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup1_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup1_waddr; //I
logic                  pf_ll_enq_cnt_r_bin1_dup1_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup1_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup1_rdata;

logic                  rf_ll_enq_cnt_r_bin1_dup1_error;

logic                  func_ll_enq_cnt_r_bin1_dup2_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup2_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup2_waddr; //I
logic                  func_ll_enq_cnt_r_bin1_dup2_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup2_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup2_rdata;

logic                pf_ll_enq_cnt_r_bin1_dup2_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup2_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup2_waddr; //I
logic                  pf_ll_enq_cnt_r_bin1_dup2_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup2_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup2_rdata;

logic                  rf_ll_enq_cnt_r_bin1_dup2_error;

logic                  func_ll_enq_cnt_r_bin1_dup3_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup3_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup3_waddr; //I
logic                  func_ll_enq_cnt_r_bin1_dup3_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup3_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup3_rdata;

logic                pf_ll_enq_cnt_r_bin1_dup3_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup3_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup3_waddr; //I
logic                  pf_ll_enq_cnt_r_bin1_dup3_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup3_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup3_rdata;

logic                  rf_ll_enq_cnt_r_bin1_dup3_error;

logic                  func_ll_enq_cnt_r_bin2_dup0_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup0_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup0_waddr; //I
logic                  func_ll_enq_cnt_r_bin2_dup0_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup0_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup0_rdata;

logic                pf_ll_enq_cnt_r_bin2_dup0_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup0_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup0_waddr; //I
logic                  pf_ll_enq_cnt_r_bin2_dup0_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup0_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup0_rdata;

logic                  rf_ll_enq_cnt_r_bin2_dup0_error;

logic                  func_ll_enq_cnt_r_bin2_dup1_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup1_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup1_waddr; //I
logic                  func_ll_enq_cnt_r_bin2_dup1_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup1_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup1_rdata;

logic                pf_ll_enq_cnt_r_bin2_dup1_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup1_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup1_waddr; //I
logic                  pf_ll_enq_cnt_r_bin2_dup1_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup1_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup1_rdata;

logic                  rf_ll_enq_cnt_r_bin2_dup1_error;

logic                  func_ll_enq_cnt_r_bin2_dup2_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup2_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup2_waddr; //I
logic                  func_ll_enq_cnt_r_bin2_dup2_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup2_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup2_rdata;

logic                pf_ll_enq_cnt_r_bin2_dup2_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup2_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup2_waddr; //I
logic                  pf_ll_enq_cnt_r_bin2_dup2_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup2_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup2_rdata;

logic                  rf_ll_enq_cnt_r_bin2_dup2_error;

logic                  func_ll_enq_cnt_r_bin2_dup3_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup3_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup3_waddr; //I
logic                  func_ll_enq_cnt_r_bin2_dup3_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup3_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup3_rdata;

logic                pf_ll_enq_cnt_r_bin2_dup3_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup3_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup3_waddr; //I
logic                  pf_ll_enq_cnt_r_bin2_dup3_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup3_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup3_rdata;

logic                  rf_ll_enq_cnt_r_bin2_dup3_error;

logic                  func_ll_enq_cnt_r_bin3_dup0_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup0_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup0_waddr; //I
logic                  func_ll_enq_cnt_r_bin3_dup0_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup0_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup0_rdata;

logic                pf_ll_enq_cnt_r_bin3_dup0_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup0_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup0_waddr; //I
logic                  pf_ll_enq_cnt_r_bin3_dup0_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup0_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup0_rdata;

logic                  rf_ll_enq_cnt_r_bin3_dup0_error;

logic                  func_ll_enq_cnt_r_bin3_dup1_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup1_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup1_waddr; //I
logic                  func_ll_enq_cnt_r_bin3_dup1_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup1_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup1_rdata;

logic                pf_ll_enq_cnt_r_bin3_dup1_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup1_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup1_waddr; //I
logic                  pf_ll_enq_cnt_r_bin3_dup1_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup1_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup1_rdata;

logic                  rf_ll_enq_cnt_r_bin3_dup1_error;

logic                  func_ll_enq_cnt_r_bin3_dup2_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup2_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup2_waddr; //I
logic                  func_ll_enq_cnt_r_bin3_dup2_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup2_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup2_rdata;

logic                pf_ll_enq_cnt_r_bin3_dup2_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup2_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup2_waddr; //I
logic                  pf_ll_enq_cnt_r_bin3_dup2_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup2_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup2_rdata;

logic                  rf_ll_enq_cnt_r_bin3_dup2_error;

logic                  func_ll_enq_cnt_r_bin3_dup3_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup3_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup3_waddr; //I
logic                  func_ll_enq_cnt_r_bin3_dup3_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup3_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup3_rdata;

logic                pf_ll_enq_cnt_r_bin3_dup3_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup3_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup3_waddr; //I
logic                  pf_ll_enq_cnt_r_bin3_dup3_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup3_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup3_rdata;

logic                  rf_ll_enq_cnt_r_bin3_dup3_error;

logic                  func_ll_enq_cnt_s_bin0_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin0_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin0_waddr; //I
logic                  func_ll_enq_cnt_s_bin0_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin0_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin0_rdata;

logic                pf_ll_enq_cnt_s_bin0_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin0_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin0_waddr; //I
logic                  pf_ll_enq_cnt_s_bin0_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin0_rdata;

logic                  rf_ll_enq_cnt_s_bin0_error;

logic                  func_ll_enq_cnt_s_bin1_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin1_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin1_waddr; //I
logic                  func_ll_enq_cnt_s_bin1_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin1_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin1_rdata;

logic                pf_ll_enq_cnt_s_bin1_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin1_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin1_waddr; //I
logic                  pf_ll_enq_cnt_s_bin1_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin1_rdata;

logic                  rf_ll_enq_cnt_s_bin1_error;

logic                  func_ll_enq_cnt_s_bin2_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin2_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin2_waddr; //I
logic                  func_ll_enq_cnt_s_bin2_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin2_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin2_rdata;

logic                pf_ll_enq_cnt_s_bin2_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin2_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin2_waddr; //I
logic                  pf_ll_enq_cnt_s_bin2_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin2_rdata;

logic                  rf_ll_enq_cnt_s_bin2_error;

logic                  func_ll_enq_cnt_s_bin3_re; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin3_raddr; //I
logic [(      12)-1:0] func_ll_enq_cnt_s_bin3_waddr; //I
logic                  func_ll_enq_cnt_s_bin3_we;    //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin3_wdata; //I
logic [(      14)-1:0] func_ll_enq_cnt_s_bin3_rdata;

logic                pf_ll_enq_cnt_s_bin3_re;    //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin3_raddr; //I
logic [(      12)-1:0] pf_ll_enq_cnt_s_bin3_waddr; //I
logic                  pf_ll_enq_cnt_s_bin3_we;    //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_enq_cnt_s_bin3_rdata;

logic                  rf_ll_enq_cnt_s_bin3_error;

logic                  func_ll_rdylst_hp_bin0_re; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin0_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin0_waddr; //I
logic                  func_ll_rdylst_hp_bin0_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin0_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin0_rdata;

logic                pf_ll_rdylst_hp_bin0_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin0_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin0_waddr; //I
logic                  pf_ll_rdylst_hp_bin0_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin0_rdata;

logic                  rf_ll_rdylst_hp_bin0_error;

logic                  func_ll_rdylst_hp_bin1_re; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin1_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin1_waddr; //I
logic                  func_ll_rdylst_hp_bin1_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin1_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin1_rdata;

logic                pf_ll_rdylst_hp_bin1_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin1_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin1_waddr; //I
logic                  pf_ll_rdylst_hp_bin1_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin1_rdata;

logic                  rf_ll_rdylst_hp_bin1_error;

logic                  func_ll_rdylst_hp_bin2_re; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin2_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin2_waddr; //I
logic                  func_ll_rdylst_hp_bin2_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin2_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin2_rdata;

logic                pf_ll_rdylst_hp_bin2_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin2_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin2_waddr; //I
logic                  pf_ll_rdylst_hp_bin2_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin2_rdata;

logic                  rf_ll_rdylst_hp_bin2_error;

logic                  func_ll_rdylst_hp_bin3_re; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin3_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_hp_bin3_waddr; //I
logic                  func_ll_rdylst_hp_bin3_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin3_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hp_bin3_rdata;

logic                pf_ll_rdylst_hp_bin3_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin3_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_hp_bin3_waddr; //I
logic                  pf_ll_rdylst_hp_bin3_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hp_bin3_rdata;

logic                  rf_ll_rdylst_hp_bin3_error;

logic                  func_ll_rdylst_hpnxt_bin0_re; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin0_raddr; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin0_waddr; //I
logic                  func_ll_rdylst_hpnxt_bin0_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin0_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin0_rdata;

logic                pf_ll_rdylst_hpnxt_bin0_re;    //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin0_raddr; //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin0_waddr; //I
logic                  pf_ll_rdylst_hpnxt_bin0_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin0_rdata;

logic                  rf_ll_rdylst_hpnxt_bin0_error;

logic                  func_ll_rdylst_hpnxt_bin1_re; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin1_raddr; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin1_waddr; //I
logic                  func_ll_rdylst_hpnxt_bin1_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin1_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin1_rdata;

logic                pf_ll_rdylst_hpnxt_bin1_re;    //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin1_raddr; //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin1_waddr; //I
logic                  pf_ll_rdylst_hpnxt_bin1_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin1_rdata;

logic                  rf_ll_rdylst_hpnxt_bin1_error;

logic                  func_ll_rdylst_hpnxt_bin2_re; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin2_raddr; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin2_waddr; //I
logic                  func_ll_rdylst_hpnxt_bin2_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin2_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin2_rdata;

logic                pf_ll_rdylst_hpnxt_bin2_re;    //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin2_raddr; //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin2_waddr; //I
logic                  pf_ll_rdylst_hpnxt_bin2_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin2_rdata;

logic                  rf_ll_rdylst_hpnxt_bin2_error;

logic                  func_ll_rdylst_hpnxt_bin3_re; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin3_raddr; //I
logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin3_waddr; //I
logic                  func_ll_rdylst_hpnxt_bin3_we;    //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin3_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin3_rdata;

logic                pf_ll_rdylst_hpnxt_bin3_re;    //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin3_raddr; //I
logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin3_waddr; //I
logic                  pf_ll_rdylst_hpnxt_bin3_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin3_rdata;

logic                  rf_ll_rdylst_hpnxt_bin3_error;

logic                  func_ll_rdylst_tp_bin0_re; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin0_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin0_waddr; //I
logic                  func_ll_rdylst_tp_bin0_we;    //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin0_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin0_rdata;

logic                pf_ll_rdylst_tp_bin0_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin0_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin0_waddr; //I
logic                  pf_ll_rdylst_tp_bin0_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin0_rdata;

logic                  rf_ll_rdylst_tp_bin0_error;

logic                  func_ll_rdylst_tp_bin1_re; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin1_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin1_waddr; //I
logic                  func_ll_rdylst_tp_bin1_we;    //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin1_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin1_rdata;

logic                pf_ll_rdylst_tp_bin1_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin1_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin1_waddr; //I
logic                  pf_ll_rdylst_tp_bin1_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin1_rdata;

logic                  rf_ll_rdylst_tp_bin1_error;

logic                  func_ll_rdylst_tp_bin2_re; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin2_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin2_waddr; //I
logic                  func_ll_rdylst_tp_bin2_we;    //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin2_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin2_rdata;

logic                pf_ll_rdylst_tp_bin2_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin2_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin2_waddr; //I
logic                  pf_ll_rdylst_tp_bin2_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin2_rdata;

logic                  rf_ll_rdylst_tp_bin2_error;

logic                  func_ll_rdylst_tp_bin3_re; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin3_raddr; //I
logic [(       7)-1:0] func_ll_rdylst_tp_bin3_waddr; //I
logic                  func_ll_rdylst_tp_bin3_we;    //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin3_wdata; //I
logic [(      14)-1:0] func_ll_rdylst_tp_bin3_rdata;

logic                pf_ll_rdylst_tp_bin3_re;    //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin3_raddr; //I
logic [(       7)-1:0] pf_ll_rdylst_tp_bin3_waddr; //I
logic                  pf_ll_rdylst_tp_bin3_we;    //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_rdylst_tp_bin3_rdata;

logic                  rf_ll_rdylst_tp_bin3_error;

logic                  func_ll_rlst_cnt_re; //I
logic [(       7)-1:0] func_ll_rlst_cnt_raddr; //I
logic [(       7)-1:0] func_ll_rlst_cnt_waddr; //I
logic                  func_ll_rlst_cnt_we;    //I
logic [(      56)-1:0] func_ll_rlst_cnt_wdata; //I
logic [(      56)-1:0] func_ll_rlst_cnt_rdata;

logic                pf_ll_rlst_cnt_re;    //I
logic [(       7)-1:0] pf_ll_rlst_cnt_raddr; //I
logic [(       7)-1:0] pf_ll_rlst_cnt_waddr; //I
logic                  pf_ll_rlst_cnt_we;    //I
logic [(      56)-1:0] pf_ll_rlst_cnt_wdata; //I
logic [(      56)-1:0] pf_ll_rlst_cnt_rdata;

logic                  rf_ll_rlst_cnt_error;

logic                  func_ll_sch_cnt_dup0_re; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup0_raddr; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup0_waddr; //I
logic                  func_ll_sch_cnt_dup0_we;    //I
logic [(      15)-1:0] func_ll_sch_cnt_dup0_wdata; //I
logic [(      15)-1:0] func_ll_sch_cnt_dup0_rdata;

logic                pf_ll_sch_cnt_dup0_re;    //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup0_raddr; //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup0_waddr; //I
logic                  pf_ll_sch_cnt_dup0_we;    //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup0_wdata; //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup0_rdata;

logic                  rf_ll_sch_cnt_dup0_error;

logic                  func_ll_sch_cnt_dup1_re; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup1_raddr; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup1_waddr; //I
logic                  func_ll_sch_cnt_dup1_we;    //I
logic [(      15)-1:0] func_ll_sch_cnt_dup1_wdata; //I
logic [(      15)-1:0] func_ll_sch_cnt_dup1_rdata;

logic                pf_ll_sch_cnt_dup1_re;    //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup1_raddr; //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup1_waddr; //I
logic                  pf_ll_sch_cnt_dup1_we;    //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup1_wdata; //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup1_rdata;

logic                  rf_ll_sch_cnt_dup1_error;

logic                  func_ll_sch_cnt_dup2_re; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup2_raddr; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup2_waddr; //I
logic                  func_ll_sch_cnt_dup2_we;    //I
logic [(      15)-1:0] func_ll_sch_cnt_dup2_wdata; //I
logic [(      15)-1:0] func_ll_sch_cnt_dup2_rdata;

logic                pf_ll_sch_cnt_dup2_re;    //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup2_raddr; //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup2_waddr; //I
logic                  pf_ll_sch_cnt_dup2_we;    //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup2_wdata; //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup2_rdata;

logic                  rf_ll_sch_cnt_dup2_error;

logic                  func_ll_sch_cnt_dup3_re; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup3_raddr; //I
logic [(      12)-1:0] func_ll_sch_cnt_dup3_waddr; //I
logic                  func_ll_sch_cnt_dup3_we;    //I
logic [(      15)-1:0] func_ll_sch_cnt_dup3_wdata; //I
logic [(      15)-1:0] func_ll_sch_cnt_dup3_rdata;

logic                pf_ll_sch_cnt_dup3_re;    //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup3_raddr; //I
logic [(      12)-1:0] pf_ll_sch_cnt_dup3_waddr; //I
logic                  pf_ll_sch_cnt_dup3_we;    //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup3_wdata; //I
logic [(      15)-1:0] pf_ll_sch_cnt_dup3_rdata;

logic                  rf_ll_sch_cnt_dup3_error;

logic                  func_ll_schlst_hp_bin0_re; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin0_raddr; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin0_waddr; //I
logic                  func_ll_schlst_hp_bin0_we;    //I
logic [(      14)-1:0] func_ll_schlst_hp_bin0_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hp_bin0_rdata;

logic                pf_ll_schlst_hp_bin0_re;    //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin0_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin0_waddr; //I
logic                  pf_ll_schlst_hp_bin0_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin0_rdata;

logic                  rf_ll_schlst_hp_bin0_error;

logic                  func_ll_schlst_hp_bin1_re; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin1_raddr; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin1_waddr; //I
logic                  func_ll_schlst_hp_bin1_we;    //I
logic [(      14)-1:0] func_ll_schlst_hp_bin1_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hp_bin1_rdata;

logic                pf_ll_schlst_hp_bin1_re;    //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin1_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin1_waddr; //I
logic                  pf_ll_schlst_hp_bin1_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin1_rdata;

logic                  rf_ll_schlst_hp_bin1_error;

logic                  func_ll_schlst_hp_bin2_re; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin2_raddr; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin2_waddr; //I
logic                  func_ll_schlst_hp_bin2_we;    //I
logic [(      14)-1:0] func_ll_schlst_hp_bin2_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hp_bin2_rdata;

logic                pf_ll_schlst_hp_bin2_re;    //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin2_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin2_waddr; //I
logic                  pf_ll_schlst_hp_bin2_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin2_rdata;

logic                  rf_ll_schlst_hp_bin2_error;

logic                  func_ll_schlst_hp_bin3_re; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin3_raddr; //I
logic [(       9)-1:0] func_ll_schlst_hp_bin3_waddr; //I
logic                  func_ll_schlst_hp_bin3_we;    //I
logic [(      14)-1:0] func_ll_schlst_hp_bin3_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hp_bin3_rdata;

logic                pf_ll_schlst_hp_bin3_re;    //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin3_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_hp_bin3_waddr; //I
logic                  pf_ll_schlst_hp_bin3_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hp_bin3_rdata;

logic                  rf_ll_schlst_hp_bin3_error;

logic                  func_ll_schlst_hpnxt_bin0_re; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin0_raddr; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin0_waddr; //I
logic                  func_ll_schlst_hpnxt_bin0_we;    //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin0_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin0_rdata;

logic                pf_ll_schlst_hpnxt_bin0_re;    //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin0_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin0_waddr; //I
logic                  pf_ll_schlst_hpnxt_bin0_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin0_rdata;

logic                  rf_ll_schlst_hpnxt_bin0_error;

logic                  func_ll_schlst_hpnxt_bin1_re; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin1_raddr; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin1_waddr; //I
logic                  func_ll_schlst_hpnxt_bin1_we;    //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin1_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin1_rdata;

logic                pf_ll_schlst_hpnxt_bin1_re;    //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin1_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin1_waddr; //I
logic                  pf_ll_schlst_hpnxt_bin1_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin1_rdata;

logic                  rf_ll_schlst_hpnxt_bin1_error;

logic                  func_ll_schlst_hpnxt_bin2_re; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin2_raddr; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin2_waddr; //I
logic                  func_ll_schlst_hpnxt_bin2_we;    //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin2_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin2_rdata;

logic                pf_ll_schlst_hpnxt_bin2_re;    //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin2_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin2_waddr; //I
logic                  pf_ll_schlst_hpnxt_bin2_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin2_rdata;

logic                  rf_ll_schlst_hpnxt_bin2_error;

logic                  func_ll_schlst_hpnxt_bin3_re; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin3_raddr; //I
logic [(      12)-1:0] func_ll_schlst_hpnxt_bin3_waddr; //I
logic                  func_ll_schlst_hpnxt_bin3_we;    //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin3_wdata; //I
logic [(      14)-1:0] func_ll_schlst_hpnxt_bin3_rdata;

logic                pf_ll_schlst_hpnxt_bin3_re;    //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin3_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin3_waddr; //I
logic                  pf_ll_schlst_hpnxt_bin3_we;    //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin3_rdata;

logic                  rf_ll_schlst_hpnxt_bin3_error;

logic                  func_ll_schlst_tp_bin0_re; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin0_raddr; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin0_waddr; //I
logic                  func_ll_schlst_tp_bin0_we;    //I
logic [(      14)-1:0] func_ll_schlst_tp_bin0_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tp_bin0_rdata;

logic                pf_ll_schlst_tp_bin0_re;    //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin0_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin0_waddr; //I
logic                  pf_ll_schlst_tp_bin0_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin0_rdata;

logic                  rf_ll_schlst_tp_bin0_error;

logic                  func_ll_schlst_tp_bin1_re; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin1_raddr; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin1_waddr; //I
logic                  func_ll_schlst_tp_bin1_we;    //I
logic [(      14)-1:0] func_ll_schlst_tp_bin1_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tp_bin1_rdata;

logic                pf_ll_schlst_tp_bin1_re;    //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin1_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin1_waddr; //I
logic                  pf_ll_schlst_tp_bin1_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin1_rdata;

logic                  rf_ll_schlst_tp_bin1_error;

logic                  func_ll_schlst_tp_bin2_re; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin2_raddr; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin2_waddr; //I
logic                  func_ll_schlst_tp_bin2_we;    //I
logic [(      14)-1:0] func_ll_schlst_tp_bin2_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tp_bin2_rdata;

logic                pf_ll_schlst_tp_bin2_re;    //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin2_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin2_waddr; //I
logic                  pf_ll_schlst_tp_bin2_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin2_rdata;

logic                  rf_ll_schlst_tp_bin2_error;

logic                  func_ll_schlst_tp_bin3_re; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin3_raddr; //I
logic [(       9)-1:0] func_ll_schlst_tp_bin3_waddr; //I
logic                  func_ll_schlst_tp_bin3_we;    //I
logic [(      14)-1:0] func_ll_schlst_tp_bin3_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tp_bin3_rdata;

logic                pf_ll_schlst_tp_bin3_re;    //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin3_raddr; //I
logic [(       9)-1:0] pf_ll_schlst_tp_bin3_waddr; //I
logic                  pf_ll_schlst_tp_bin3_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tp_bin3_rdata;

logic                  rf_ll_schlst_tp_bin3_error;

logic                  func_ll_schlst_tpprv_bin0_re; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin0_raddr; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin0_waddr; //I
logic                  func_ll_schlst_tpprv_bin0_we;    //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin0_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin0_rdata;

logic                pf_ll_schlst_tpprv_bin0_re;    //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin0_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin0_waddr; //I
logic                  pf_ll_schlst_tpprv_bin0_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin0_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin0_rdata;

logic                  rf_ll_schlst_tpprv_bin0_error;

logic                  func_ll_schlst_tpprv_bin1_re; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin1_raddr; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin1_waddr; //I
logic                  func_ll_schlst_tpprv_bin1_we;    //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin1_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin1_rdata;

logic                pf_ll_schlst_tpprv_bin1_re;    //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin1_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin1_waddr; //I
logic                  pf_ll_schlst_tpprv_bin1_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin1_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin1_rdata;

logic                  rf_ll_schlst_tpprv_bin1_error;

logic                  func_ll_schlst_tpprv_bin2_re; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin2_raddr; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin2_waddr; //I
logic                  func_ll_schlst_tpprv_bin2_we;    //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin2_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin2_rdata;

logic                pf_ll_schlst_tpprv_bin2_re;    //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin2_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin2_waddr; //I
logic                  pf_ll_schlst_tpprv_bin2_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin2_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin2_rdata;

logic                  rf_ll_schlst_tpprv_bin2_error;

logic                  func_ll_schlst_tpprv_bin3_re; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin3_raddr; //I
logic [(      12)-1:0] func_ll_schlst_tpprv_bin3_waddr; //I
logic                  func_ll_schlst_tpprv_bin3_we;    //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin3_wdata; //I
logic [(      14)-1:0] func_ll_schlst_tpprv_bin3_rdata;

logic                pf_ll_schlst_tpprv_bin3_re;    //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin3_raddr; //I
logic [(      12)-1:0] pf_ll_schlst_tpprv_bin3_waddr; //I
logic                  pf_ll_schlst_tpprv_bin3_we;    //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin3_wdata; //I
logic [(      14)-1:0] pf_ll_schlst_tpprv_bin3_rdata;

logic                  rf_ll_schlst_tpprv_bin3_error;

logic                  func_ll_slst_cnt_re; //I
logic [(       9)-1:0] func_ll_slst_cnt_raddr; //I
logic [(       9)-1:0] func_ll_slst_cnt_waddr; //I
logic                  func_ll_slst_cnt_we;    //I
logic [(      56)-1:0] func_ll_slst_cnt_wdata; //I
logic [(      56)-1:0] func_ll_slst_cnt_rdata;

logic                pf_ll_slst_cnt_re;    //I
logic [(       9)-1:0] pf_ll_slst_cnt_raddr; //I
logic [(       9)-1:0] pf_ll_slst_cnt_waddr; //I
logic                  pf_ll_slst_cnt_we;    //I
logic [(      56)-1:0] pf_ll_slst_cnt_wdata; //I
logic [(      56)-1:0] pf_ll_slst_cnt_rdata;

logic                  rf_ll_slst_cnt_error;

logic                  func_qid_rdylst_clamp_re; //I
logic [(       7)-1:0] func_qid_rdylst_clamp_raddr; //I
logic [(       7)-1:0] func_qid_rdylst_clamp_waddr; //I
logic                  func_qid_rdylst_clamp_we;    //I
logic [(       6)-1:0] func_qid_rdylst_clamp_wdata; //I
logic [(       6)-1:0] func_qid_rdylst_clamp_rdata;

logic                pf_qid_rdylst_clamp_re;    //I
logic [(       7)-1:0] pf_qid_rdylst_clamp_raddr; //I
logic [(       7)-1:0] pf_qid_rdylst_clamp_waddr; //I
logic                  pf_qid_rdylst_clamp_we;    //I
logic [(       6)-1:0] pf_qid_rdylst_clamp_wdata; //I
logic [(       6)-1:0] pf_qid_rdylst_clamp_rdata;

logic                  rf_qid_rdylst_clamp_error;

hqm_lsp_atm_pipe_ram_access i_hqm_lsp_atm_pipe_ram_access (
  .hqm_gated_clk (hqm_gated_clk)
, .hqm_gated_rst_n (hqm_gated_rst_n)
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

,.hqm_lsp_atm_pipe_rfw_top_ipar_error (hqm_lsp_atm_pipe_rfw_top_ipar_error)

,.func_aqed_qid2cqidix_re    (func_aqed_qid2cqidix_re)
,.func_aqed_qid2cqidix_addr  (func_aqed_qid2cqidix_addr)
,.func_aqed_qid2cqidix_we    (func_aqed_qid2cqidix_we)
,.func_aqed_qid2cqidix_wdata (func_aqed_qid2cqidix_wdata)
,.func_aqed_qid2cqidix_rdata (func_aqed_qid2cqidix_rdata)

,.pf_aqed_qid2cqidix_re      (pf_aqed_qid2cqidix_re)
,.pf_aqed_qid2cqidix_addr  (pf_aqed_qid2cqidix_addr)
,.pf_aqed_qid2cqidix_we    (pf_aqed_qid2cqidix_we)
,.pf_aqed_qid2cqidix_wdata (pf_aqed_qid2cqidix_wdata)
,.pf_aqed_qid2cqidix_rdata (pf_aqed_qid2cqidix_rdata)

,.rf_aqed_qid2cqidix_rclk (rf_aqed_qid2cqidix_rclk)
,.rf_aqed_qid2cqidix_rclk_rst_n (rf_aqed_qid2cqidix_rclk_rst_n)
,.rf_aqed_qid2cqidix_re    (rf_aqed_qid2cqidix_re)
,.rf_aqed_qid2cqidix_raddr (rf_aqed_qid2cqidix_raddr)
,.rf_aqed_qid2cqidix_waddr (rf_aqed_qid2cqidix_waddr)
,.rf_aqed_qid2cqidix_wclk (rf_aqed_qid2cqidix_wclk)
,.rf_aqed_qid2cqidix_wclk_rst_n (rf_aqed_qid2cqidix_wclk_rst_n)
,.rf_aqed_qid2cqidix_we    (rf_aqed_qid2cqidix_we)
,.rf_aqed_qid2cqidix_wdata (rf_aqed_qid2cqidix_wdata)
,.rf_aqed_qid2cqidix_rdata (rf_aqed_qid2cqidix_rdata)

,.rf_aqed_qid2cqidix_error (rf_aqed_qid2cqidix_error)

,.func_atm_fifo_ap_aqed_re    (func_atm_fifo_ap_aqed_re)
,.func_atm_fifo_ap_aqed_raddr (func_atm_fifo_ap_aqed_raddr)
,.func_atm_fifo_ap_aqed_waddr (func_atm_fifo_ap_aqed_waddr)
,.func_atm_fifo_ap_aqed_we    (func_atm_fifo_ap_aqed_we)
,.func_atm_fifo_ap_aqed_wdata (func_atm_fifo_ap_aqed_wdata)
,.func_atm_fifo_ap_aqed_rdata (func_atm_fifo_ap_aqed_rdata)

,.pf_atm_fifo_ap_aqed_re      (pf_atm_fifo_ap_aqed_re)
,.pf_atm_fifo_ap_aqed_raddr (pf_atm_fifo_ap_aqed_raddr)
,.pf_atm_fifo_ap_aqed_waddr (pf_atm_fifo_ap_aqed_waddr)
,.pf_atm_fifo_ap_aqed_we    (pf_atm_fifo_ap_aqed_we)
,.pf_atm_fifo_ap_aqed_wdata (pf_atm_fifo_ap_aqed_wdata)
,.pf_atm_fifo_ap_aqed_rdata (pf_atm_fifo_ap_aqed_rdata)

,.rf_atm_fifo_ap_aqed_rclk (rf_atm_fifo_ap_aqed_rclk)
,.rf_atm_fifo_ap_aqed_rclk_rst_n (rf_atm_fifo_ap_aqed_rclk_rst_n)
,.rf_atm_fifo_ap_aqed_re    (rf_atm_fifo_ap_aqed_re)
,.rf_atm_fifo_ap_aqed_raddr (rf_atm_fifo_ap_aqed_raddr)
,.rf_atm_fifo_ap_aqed_waddr (rf_atm_fifo_ap_aqed_waddr)
,.rf_atm_fifo_ap_aqed_wclk (rf_atm_fifo_ap_aqed_wclk)
,.rf_atm_fifo_ap_aqed_wclk_rst_n (rf_atm_fifo_ap_aqed_wclk_rst_n)
,.rf_atm_fifo_ap_aqed_we    (rf_atm_fifo_ap_aqed_we)
,.rf_atm_fifo_ap_aqed_wdata (rf_atm_fifo_ap_aqed_wdata)
,.rf_atm_fifo_ap_aqed_rdata (rf_atm_fifo_ap_aqed_rdata)

,.rf_atm_fifo_ap_aqed_error (rf_atm_fifo_ap_aqed_error)

,.func_atm_fifo_aqed_ap_enq_re    (func_atm_fifo_aqed_ap_enq_re)
,.func_atm_fifo_aqed_ap_enq_raddr (func_atm_fifo_aqed_ap_enq_raddr)
,.func_atm_fifo_aqed_ap_enq_waddr (func_atm_fifo_aqed_ap_enq_waddr)
,.func_atm_fifo_aqed_ap_enq_we    (func_atm_fifo_aqed_ap_enq_we)
,.func_atm_fifo_aqed_ap_enq_wdata (func_atm_fifo_aqed_ap_enq_wdata)
,.func_atm_fifo_aqed_ap_enq_rdata (func_atm_fifo_aqed_ap_enq_rdata)

,.pf_atm_fifo_aqed_ap_enq_re      (pf_atm_fifo_aqed_ap_enq_re)
,.pf_atm_fifo_aqed_ap_enq_raddr (pf_atm_fifo_aqed_ap_enq_raddr)
,.pf_atm_fifo_aqed_ap_enq_waddr (pf_atm_fifo_aqed_ap_enq_waddr)
,.pf_atm_fifo_aqed_ap_enq_we    (pf_atm_fifo_aqed_ap_enq_we)
,.pf_atm_fifo_aqed_ap_enq_wdata (pf_atm_fifo_aqed_ap_enq_wdata)
,.pf_atm_fifo_aqed_ap_enq_rdata (pf_atm_fifo_aqed_ap_enq_rdata)

,.rf_atm_fifo_aqed_ap_enq_rclk (rf_atm_fifo_aqed_ap_enq_rclk)
,.rf_atm_fifo_aqed_ap_enq_rclk_rst_n (rf_atm_fifo_aqed_ap_enq_rclk_rst_n)
,.rf_atm_fifo_aqed_ap_enq_re    (rf_atm_fifo_aqed_ap_enq_re)
,.rf_atm_fifo_aqed_ap_enq_raddr (rf_atm_fifo_aqed_ap_enq_raddr)
,.rf_atm_fifo_aqed_ap_enq_waddr (rf_atm_fifo_aqed_ap_enq_waddr)
,.rf_atm_fifo_aqed_ap_enq_wclk (rf_atm_fifo_aqed_ap_enq_wclk)
,.rf_atm_fifo_aqed_ap_enq_wclk_rst_n (rf_atm_fifo_aqed_ap_enq_wclk_rst_n)
,.rf_atm_fifo_aqed_ap_enq_we    (rf_atm_fifo_aqed_ap_enq_we)
,.rf_atm_fifo_aqed_ap_enq_wdata (rf_atm_fifo_aqed_ap_enq_wdata)
,.rf_atm_fifo_aqed_ap_enq_rdata (rf_atm_fifo_aqed_ap_enq_rdata)

,.rf_atm_fifo_aqed_ap_enq_error (rf_atm_fifo_aqed_ap_enq_error)

,.func_fid2cqqidix_re    (func_fid2cqqidix_re)
,.func_fid2cqqidix_raddr (func_fid2cqqidix_raddr)
,.func_fid2cqqidix_waddr (func_fid2cqqidix_waddr)
,.func_fid2cqqidix_we    (func_fid2cqqidix_we)
,.func_fid2cqqidix_wdata (func_fid2cqqidix_wdata)
,.func_fid2cqqidix_rdata (func_fid2cqqidix_rdata)

,.pf_fid2cqqidix_re      (pf_fid2cqqidix_re)
,.pf_fid2cqqidix_raddr (pf_fid2cqqidix_raddr)
,.pf_fid2cqqidix_waddr (pf_fid2cqqidix_waddr)
,.pf_fid2cqqidix_we    (pf_fid2cqqidix_we)
,.pf_fid2cqqidix_wdata (pf_fid2cqqidix_wdata)
,.pf_fid2cqqidix_rdata (pf_fid2cqqidix_rdata)

,.rf_fid2cqqidix_rclk (rf_fid2cqqidix_rclk)
,.rf_fid2cqqidix_rclk_rst_n (rf_fid2cqqidix_rclk_rst_n)
,.rf_fid2cqqidix_re    (rf_fid2cqqidix_re)
,.rf_fid2cqqidix_raddr (rf_fid2cqqidix_raddr)
,.rf_fid2cqqidix_waddr (rf_fid2cqqidix_waddr)
,.rf_fid2cqqidix_wclk (rf_fid2cqqidix_wclk)
,.rf_fid2cqqidix_wclk_rst_n (rf_fid2cqqidix_wclk_rst_n)
,.rf_fid2cqqidix_we    (rf_fid2cqqidix_we)
,.rf_fid2cqqidix_wdata (rf_fid2cqqidix_wdata)
,.rf_fid2cqqidix_rdata (rf_fid2cqqidix_rdata)

,.rf_fid2cqqidix_error (rf_fid2cqqidix_error)

,.func_ll_enq_cnt_r_bin0_dup0_re    (func_ll_enq_cnt_r_bin0_dup0_re)
,.func_ll_enq_cnt_r_bin0_dup0_raddr (func_ll_enq_cnt_r_bin0_dup0_raddr)
,.func_ll_enq_cnt_r_bin0_dup0_waddr (func_ll_enq_cnt_r_bin0_dup0_waddr)
,.func_ll_enq_cnt_r_bin0_dup0_we    (func_ll_enq_cnt_r_bin0_dup0_we)
,.func_ll_enq_cnt_r_bin0_dup0_wdata (func_ll_enq_cnt_r_bin0_dup0_wdata)
,.func_ll_enq_cnt_r_bin0_dup0_rdata (func_ll_enq_cnt_r_bin0_dup0_rdata)

,.pf_ll_enq_cnt_r_bin0_dup0_re      (pf_ll_enq_cnt_r_bin0_dup0_re)
,.pf_ll_enq_cnt_r_bin0_dup0_raddr (pf_ll_enq_cnt_r_bin0_dup0_raddr)
,.pf_ll_enq_cnt_r_bin0_dup0_waddr (pf_ll_enq_cnt_r_bin0_dup0_waddr)
,.pf_ll_enq_cnt_r_bin0_dup0_we    (pf_ll_enq_cnt_r_bin0_dup0_we)
,.pf_ll_enq_cnt_r_bin0_dup0_wdata (pf_ll_enq_cnt_r_bin0_dup0_wdata)
,.pf_ll_enq_cnt_r_bin0_dup0_rdata (pf_ll_enq_cnt_r_bin0_dup0_rdata)

,.rf_ll_enq_cnt_r_bin0_dup0_rclk (rf_ll_enq_cnt_r_bin0_dup0_rclk)
,.rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n (rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup0_re    (rf_ll_enq_cnt_r_bin0_dup0_re)
,.rf_ll_enq_cnt_r_bin0_dup0_raddr (rf_ll_enq_cnt_r_bin0_dup0_raddr)
,.rf_ll_enq_cnt_r_bin0_dup0_waddr (rf_ll_enq_cnt_r_bin0_dup0_waddr)
,.rf_ll_enq_cnt_r_bin0_dup0_wclk (rf_ll_enq_cnt_r_bin0_dup0_wclk)
,.rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n (rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup0_we    (rf_ll_enq_cnt_r_bin0_dup0_we)
,.rf_ll_enq_cnt_r_bin0_dup0_wdata (rf_ll_enq_cnt_r_bin0_dup0_wdata)
,.rf_ll_enq_cnt_r_bin0_dup0_rdata (rf_ll_enq_cnt_r_bin0_dup0_rdata)

,.rf_ll_enq_cnt_r_bin0_dup0_error (rf_ll_enq_cnt_r_bin0_dup0_error)

,.func_ll_enq_cnt_r_bin0_dup1_re    (func_ll_enq_cnt_r_bin0_dup1_re)
,.func_ll_enq_cnt_r_bin0_dup1_raddr (func_ll_enq_cnt_r_bin0_dup1_raddr)
,.func_ll_enq_cnt_r_bin0_dup1_waddr (func_ll_enq_cnt_r_bin0_dup1_waddr)
,.func_ll_enq_cnt_r_bin0_dup1_we    (func_ll_enq_cnt_r_bin0_dup1_we)
,.func_ll_enq_cnt_r_bin0_dup1_wdata (func_ll_enq_cnt_r_bin0_dup1_wdata)
,.func_ll_enq_cnt_r_bin0_dup1_rdata (func_ll_enq_cnt_r_bin0_dup1_rdata)

,.pf_ll_enq_cnt_r_bin0_dup1_re      (pf_ll_enq_cnt_r_bin0_dup1_re)
,.pf_ll_enq_cnt_r_bin0_dup1_raddr (pf_ll_enq_cnt_r_bin0_dup1_raddr)
,.pf_ll_enq_cnt_r_bin0_dup1_waddr (pf_ll_enq_cnt_r_bin0_dup1_waddr)
,.pf_ll_enq_cnt_r_bin0_dup1_we    (pf_ll_enq_cnt_r_bin0_dup1_we)
,.pf_ll_enq_cnt_r_bin0_dup1_wdata (pf_ll_enq_cnt_r_bin0_dup1_wdata)
,.pf_ll_enq_cnt_r_bin0_dup1_rdata (pf_ll_enq_cnt_r_bin0_dup1_rdata)

,.rf_ll_enq_cnt_r_bin0_dup1_rclk (rf_ll_enq_cnt_r_bin0_dup1_rclk)
,.rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n (rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup1_re    (rf_ll_enq_cnt_r_bin0_dup1_re)
,.rf_ll_enq_cnt_r_bin0_dup1_raddr (rf_ll_enq_cnt_r_bin0_dup1_raddr)
,.rf_ll_enq_cnt_r_bin0_dup1_waddr (rf_ll_enq_cnt_r_bin0_dup1_waddr)
,.rf_ll_enq_cnt_r_bin0_dup1_wclk (rf_ll_enq_cnt_r_bin0_dup1_wclk)
,.rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n (rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup1_we    (rf_ll_enq_cnt_r_bin0_dup1_we)
,.rf_ll_enq_cnt_r_bin0_dup1_wdata (rf_ll_enq_cnt_r_bin0_dup1_wdata)
,.rf_ll_enq_cnt_r_bin0_dup1_rdata (rf_ll_enq_cnt_r_bin0_dup1_rdata)

,.rf_ll_enq_cnt_r_bin0_dup1_error (rf_ll_enq_cnt_r_bin0_dup1_error)

,.func_ll_enq_cnt_r_bin0_dup2_re    (func_ll_enq_cnt_r_bin0_dup2_re)
,.func_ll_enq_cnt_r_bin0_dup2_raddr (func_ll_enq_cnt_r_bin0_dup2_raddr)
,.func_ll_enq_cnt_r_bin0_dup2_waddr (func_ll_enq_cnt_r_bin0_dup2_waddr)
,.func_ll_enq_cnt_r_bin0_dup2_we    (func_ll_enq_cnt_r_bin0_dup2_we)
,.func_ll_enq_cnt_r_bin0_dup2_wdata (func_ll_enq_cnt_r_bin0_dup2_wdata)
,.func_ll_enq_cnt_r_bin0_dup2_rdata (func_ll_enq_cnt_r_bin0_dup2_rdata)

,.pf_ll_enq_cnt_r_bin0_dup2_re      (pf_ll_enq_cnt_r_bin0_dup2_re)
,.pf_ll_enq_cnt_r_bin0_dup2_raddr (pf_ll_enq_cnt_r_bin0_dup2_raddr)
,.pf_ll_enq_cnt_r_bin0_dup2_waddr (pf_ll_enq_cnt_r_bin0_dup2_waddr)
,.pf_ll_enq_cnt_r_bin0_dup2_we    (pf_ll_enq_cnt_r_bin0_dup2_we)
,.pf_ll_enq_cnt_r_bin0_dup2_wdata (pf_ll_enq_cnt_r_bin0_dup2_wdata)
,.pf_ll_enq_cnt_r_bin0_dup2_rdata (pf_ll_enq_cnt_r_bin0_dup2_rdata)

,.rf_ll_enq_cnt_r_bin0_dup2_rclk (rf_ll_enq_cnt_r_bin0_dup2_rclk)
,.rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n (rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup2_re    (rf_ll_enq_cnt_r_bin0_dup2_re)
,.rf_ll_enq_cnt_r_bin0_dup2_raddr (rf_ll_enq_cnt_r_bin0_dup2_raddr)
,.rf_ll_enq_cnt_r_bin0_dup2_waddr (rf_ll_enq_cnt_r_bin0_dup2_waddr)
,.rf_ll_enq_cnt_r_bin0_dup2_wclk (rf_ll_enq_cnt_r_bin0_dup2_wclk)
,.rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n (rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup2_we    (rf_ll_enq_cnt_r_bin0_dup2_we)
,.rf_ll_enq_cnt_r_bin0_dup2_wdata (rf_ll_enq_cnt_r_bin0_dup2_wdata)
,.rf_ll_enq_cnt_r_bin0_dup2_rdata (rf_ll_enq_cnt_r_bin0_dup2_rdata)

,.rf_ll_enq_cnt_r_bin0_dup2_error (rf_ll_enq_cnt_r_bin0_dup2_error)

,.func_ll_enq_cnt_r_bin0_dup3_re    (func_ll_enq_cnt_r_bin0_dup3_re)
,.func_ll_enq_cnt_r_bin0_dup3_raddr (func_ll_enq_cnt_r_bin0_dup3_raddr)
,.func_ll_enq_cnt_r_bin0_dup3_waddr (func_ll_enq_cnt_r_bin0_dup3_waddr)
,.func_ll_enq_cnt_r_bin0_dup3_we    (func_ll_enq_cnt_r_bin0_dup3_we)
,.func_ll_enq_cnt_r_bin0_dup3_wdata (func_ll_enq_cnt_r_bin0_dup3_wdata)
,.func_ll_enq_cnt_r_bin0_dup3_rdata (func_ll_enq_cnt_r_bin0_dup3_rdata)

,.pf_ll_enq_cnt_r_bin0_dup3_re      (pf_ll_enq_cnt_r_bin0_dup3_re)
,.pf_ll_enq_cnt_r_bin0_dup3_raddr (pf_ll_enq_cnt_r_bin0_dup3_raddr)
,.pf_ll_enq_cnt_r_bin0_dup3_waddr (pf_ll_enq_cnt_r_bin0_dup3_waddr)
,.pf_ll_enq_cnt_r_bin0_dup3_we    (pf_ll_enq_cnt_r_bin0_dup3_we)
,.pf_ll_enq_cnt_r_bin0_dup3_wdata (pf_ll_enq_cnt_r_bin0_dup3_wdata)
,.pf_ll_enq_cnt_r_bin0_dup3_rdata (pf_ll_enq_cnt_r_bin0_dup3_rdata)

,.rf_ll_enq_cnt_r_bin0_dup3_rclk (rf_ll_enq_cnt_r_bin0_dup3_rclk)
,.rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n (rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup3_re    (rf_ll_enq_cnt_r_bin0_dup3_re)
,.rf_ll_enq_cnt_r_bin0_dup3_raddr (rf_ll_enq_cnt_r_bin0_dup3_raddr)
,.rf_ll_enq_cnt_r_bin0_dup3_waddr (rf_ll_enq_cnt_r_bin0_dup3_waddr)
,.rf_ll_enq_cnt_r_bin0_dup3_wclk (rf_ll_enq_cnt_r_bin0_dup3_wclk)
,.rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n (rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin0_dup3_we    (rf_ll_enq_cnt_r_bin0_dup3_we)
,.rf_ll_enq_cnt_r_bin0_dup3_wdata (rf_ll_enq_cnt_r_bin0_dup3_wdata)
,.rf_ll_enq_cnt_r_bin0_dup3_rdata (rf_ll_enq_cnt_r_bin0_dup3_rdata)

,.rf_ll_enq_cnt_r_bin0_dup3_error (rf_ll_enq_cnt_r_bin0_dup3_error)

,.func_ll_enq_cnt_r_bin1_dup0_re    (func_ll_enq_cnt_r_bin1_dup0_re)
,.func_ll_enq_cnt_r_bin1_dup0_raddr (func_ll_enq_cnt_r_bin1_dup0_raddr)
,.func_ll_enq_cnt_r_bin1_dup0_waddr (func_ll_enq_cnt_r_bin1_dup0_waddr)
,.func_ll_enq_cnt_r_bin1_dup0_we    (func_ll_enq_cnt_r_bin1_dup0_we)
,.func_ll_enq_cnt_r_bin1_dup0_wdata (func_ll_enq_cnt_r_bin1_dup0_wdata)
,.func_ll_enq_cnt_r_bin1_dup0_rdata (func_ll_enq_cnt_r_bin1_dup0_rdata)

,.pf_ll_enq_cnt_r_bin1_dup0_re      (pf_ll_enq_cnt_r_bin1_dup0_re)
,.pf_ll_enq_cnt_r_bin1_dup0_raddr (pf_ll_enq_cnt_r_bin1_dup0_raddr)
,.pf_ll_enq_cnt_r_bin1_dup0_waddr (pf_ll_enq_cnt_r_bin1_dup0_waddr)
,.pf_ll_enq_cnt_r_bin1_dup0_we    (pf_ll_enq_cnt_r_bin1_dup0_we)
,.pf_ll_enq_cnt_r_bin1_dup0_wdata (pf_ll_enq_cnt_r_bin1_dup0_wdata)
,.pf_ll_enq_cnt_r_bin1_dup0_rdata (pf_ll_enq_cnt_r_bin1_dup0_rdata)

,.rf_ll_enq_cnt_r_bin1_dup0_rclk (rf_ll_enq_cnt_r_bin1_dup0_rclk)
,.rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n (rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup0_re    (rf_ll_enq_cnt_r_bin1_dup0_re)
,.rf_ll_enq_cnt_r_bin1_dup0_raddr (rf_ll_enq_cnt_r_bin1_dup0_raddr)
,.rf_ll_enq_cnt_r_bin1_dup0_waddr (rf_ll_enq_cnt_r_bin1_dup0_waddr)
,.rf_ll_enq_cnt_r_bin1_dup0_wclk (rf_ll_enq_cnt_r_bin1_dup0_wclk)
,.rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n (rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup0_we    (rf_ll_enq_cnt_r_bin1_dup0_we)
,.rf_ll_enq_cnt_r_bin1_dup0_wdata (rf_ll_enq_cnt_r_bin1_dup0_wdata)
,.rf_ll_enq_cnt_r_bin1_dup0_rdata (rf_ll_enq_cnt_r_bin1_dup0_rdata)

,.rf_ll_enq_cnt_r_bin1_dup0_error (rf_ll_enq_cnt_r_bin1_dup0_error)

,.func_ll_enq_cnt_r_bin1_dup1_re    (func_ll_enq_cnt_r_bin1_dup1_re)
,.func_ll_enq_cnt_r_bin1_dup1_raddr (func_ll_enq_cnt_r_bin1_dup1_raddr)
,.func_ll_enq_cnt_r_bin1_dup1_waddr (func_ll_enq_cnt_r_bin1_dup1_waddr)
,.func_ll_enq_cnt_r_bin1_dup1_we    (func_ll_enq_cnt_r_bin1_dup1_we)
,.func_ll_enq_cnt_r_bin1_dup1_wdata (func_ll_enq_cnt_r_bin1_dup1_wdata)
,.func_ll_enq_cnt_r_bin1_dup1_rdata (func_ll_enq_cnt_r_bin1_dup1_rdata)

,.pf_ll_enq_cnt_r_bin1_dup1_re      (pf_ll_enq_cnt_r_bin1_dup1_re)
,.pf_ll_enq_cnt_r_bin1_dup1_raddr (pf_ll_enq_cnt_r_bin1_dup1_raddr)
,.pf_ll_enq_cnt_r_bin1_dup1_waddr (pf_ll_enq_cnt_r_bin1_dup1_waddr)
,.pf_ll_enq_cnt_r_bin1_dup1_we    (pf_ll_enq_cnt_r_bin1_dup1_we)
,.pf_ll_enq_cnt_r_bin1_dup1_wdata (pf_ll_enq_cnt_r_bin1_dup1_wdata)
,.pf_ll_enq_cnt_r_bin1_dup1_rdata (pf_ll_enq_cnt_r_bin1_dup1_rdata)

,.rf_ll_enq_cnt_r_bin1_dup1_rclk (rf_ll_enq_cnt_r_bin1_dup1_rclk)
,.rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n (rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup1_re    (rf_ll_enq_cnt_r_bin1_dup1_re)
,.rf_ll_enq_cnt_r_bin1_dup1_raddr (rf_ll_enq_cnt_r_bin1_dup1_raddr)
,.rf_ll_enq_cnt_r_bin1_dup1_waddr (rf_ll_enq_cnt_r_bin1_dup1_waddr)
,.rf_ll_enq_cnt_r_bin1_dup1_wclk (rf_ll_enq_cnt_r_bin1_dup1_wclk)
,.rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n (rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup1_we    (rf_ll_enq_cnt_r_bin1_dup1_we)
,.rf_ll_enq_cnt_r_bin1_dup1_wdata (rf_ll_enq_cnt_r_bin1_dup1_wdata)
,.rf_ll_enq_cnt_r_bin1_dup1_rdata (rf_ll_enq_cnt_r_bin1_dup1_rdata)

,.rf_ll_enq_cnt_r_bin1_dup1_error (rf_ll_enq_cnt_r_bin1_dup1_error)

,.func_ll_enq_cnt_r_bin1_dup2_re    (func_ll_enq_cnt_r_bin1_dup2_re)
,.func_ll_enq_cnt_r_bin1_dup2_raddr (func_ll_enq_cnt_r_bin1_dup2_raddr)
,.func_ll_enq_cnt_r_bin1_dup2_waddr (func_ll_enq_cnt_r_bin1_dup2_waddr)
,.func_ll_enq_cnt_r_bin1_dup2_we    (func_ll_enq_cnt_r_bin1_dup2_we)
,.func_ll_enq_cnt_r_bin1_dup2_wdata (func_ll_enq_cnt_r_bin1_dup2_wdata)
,.func_ll_enq_cnt_r_bin1_dup2_rdata (func_ll_enq_cnt_r_bin1_dup2_rdata)

,.pf_ll_enq_cnt_r_bin1_dup2_re      (pf_ll_enq_cnt_r_bin1_dup2_re)
,.pf_ll_enq_cnt_r_bin1_dup2_raddr (pf_ll_enq_cnt_r_bin1_dup2_raddr)
,.pf_ll_enq_cnt_r_bin1_dup2_waddr (pf_ll_enq_cnt_r_bin1_dup2_waddr)
,.pf_ll_enq_cnt_r_bin1_dup2_we    (pf_ll_enq_cnt_r_bin1_dup2_we)
,.pf_ll_enq_cnt_r_bin1_dup2_wdata (pf_ll_enq_cnt_r_bin1_dup2_wdata)
,.pf_ll_enq_cnt_r_bin1_dup2_rdata (pf_ll_enq_cnt_r_bin1_dup2_rdata)

,.rf_ll_enq_cnt_r_bin1_dup2_rclk (rf_ll_enq_cnt_r_bin1_dup2_rclk)
,.rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n (rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup2_re    (rf_ll_enq_cnt_r_bin1_dup2_re)
,.rf_ll_enq_cnt_r_bin1_dup2_raddr (rf_ll_enq_cnt_r_bin1_dup2_raddr)
,.rf_ll_enq_cnt_r_bin1_dup2_waddr (rf_ll_enq_cnt_r_bin1_dup2_waddr)
,.rf_ll_enq_cnt_r_bin1_dup2_wclk (rf_ll_enq_cnt_r_bin1_dup2_wclk)
,.rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n (rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup2_we    (rf_ll_enq_cnt_r_bin1_dup2_we)
,.rf_ll_enq_cnt_r_bin1_dup2_wdata (rf_ll_enq_cnt_r_bin1_dup2_wdata)
,.rf_ll_enq_cnt_r_bin1_dup2_rdata (rf_ll_enq_cnt_r_bin1_dup2_rdata)

,.rf_ll_enq_cnt_r_bin1_dup2_error (rf_ll_enq_cnt_r_bin1_dup2_error)

,.func_ll_enq_cnt_r_bin1_dup3_re    (func_ll_enq_cnt_r_bin1_dup3_re)
,.func_ll_enq_cnt_r_bin1_dup3_raddr (func_ll_enq_cnt_r_bin1_dup3_raddr)
,.func_ll_enq_cnt_r_bin1_dup3_waddr (func_ll_enq_cnt_r_bin1_dup3_waddr)
,.func_ll_enq_cnt_r_bin1_dup3_we    (func_ll_enq_cnt_r_bin1_dup3_we)
,.func_ll_enq_cnt_r_bin1_dup3_wdata (func_ll_enq_cnt_r_bin1_dup3_wdata)
,.func_ll_enq_cnt_r_bin1_dup3_rdata (func_ll_enq_cnt_r_bin1_dup3_rdata)

,.pf_ll_enq_cnt_r_bin1_dup3_re      (pf_ll_enq_cnt_r_bin1_dup3_re)
,.pf_ll_enq_cnt_r_bin1_dup3_raddr (pf_ll_enq_cnt_r_bin1_dup3_raddr)
,.pf_ll_enq_cnt_r_bin1_dup3_waddr (pf_ll_enq_cnt_r_bin1_dup3_waddr)
,.pf_ll_enq_cnt_r_bin1_dup3_we    (pf_ll_enq_cnt_r_bin1_dup3_we)
,.pf_ll_enq_cnt_r_bin1_dup3_wdata (pf_ll_enq_cnt_r_bin1_dup3_wdata)
,.pf_ll_enq_cnt_r_bin1_dup3_rdata (pf_ll_enq_cnt_r_bin1_dup3_rdata)

,.rf_ll_enq_cnt_r_bin1_dup3_rclk (rf_ll_enq_cnt_r_bin1_dup3_rclk)
,.rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n (rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup3_re    (rf_ll_enq_cnt_r_bin1_dup3_re)
,.rf_ll_enq_cnt_r_bin1_dup3_raddr (rf_ll_enq_cnt_r_bin1_dup3_raddr)
,.rf_ll_enq_cnt_r_bin1_dup3_waddr (rf_ll_enq_cnt_r_bin1_dup3_waddr)
,.rf_ll_enq_cnt_r_bin1_dup3_wclk (rf_ll_enq_cnt_r_bin1_dup3_wclk)
,.rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n (rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin1_dup3_we    (rf_ll_enq_cnt_r_bin1_dup3_we)
,.rf_ll_enq_cnt_r_bin1_dup3_wdata (rf_ll_enq_cnt_r_bin1_dup3_wdata)
,.rf_ll_enq_cnt_r_bin1_dup3_rdata (rf_ll_enq_cnt_r_bin1_dup3_rdata)

,.rf_ll_enq_cnt_r_bin1_dup3_error (rf_ll_enq_cnt_r_bin1_dup3_error)

,.func_ll_enq_cnt_r_bin2_dup0_re    (func_ll_enq_cnt_r_bin2_dup0_re)
,.func_ll_enq_cnt_r_bin2_dup0_raddr (func_ll_enq_cnt_r_bin2_dup0_raddr)
,.func_ll_enq_cnt_r_bin2_dup0_waddr (func_ll_enq_cnt_r_bin2_dup0_waddr)
,.func_ll_enq_cnt_r_bin2_dup0_we    (func_ll_enq_cnt_r_bin2_dup0_we)
,.func_ll_enq_cnt_r_bin2_dup0_wdata (func_ll_enq_cnt_r_bin2_dup0_wdata)
,.func_ll_enq_cnt_r_bin2_dup0_rdata (func_ll_enq_cnt_r_bin2_dup0_rdata)

,.pf_ll_enq_cnt_r_bin2_dup0_re      (pf_ll_enq_cnt_r_bin2_dup0_re)
,.pf_ll_enq_cnt_r_bin2_dup0_raddr (pf_ll_enq_cnt_r_bin2_dup0_raddr)
,.pf_ll_enq_cnt_r_bin2_dup0_waddr (pf_ll_enq_cnt_r_bin2_dup0_waddr)
,.pf_ll_enq_cnt_r_bin2_dup0_we    (pf_ll_enq_cnt_r_bin2_dup0_we)
,.pf_ll_enq_cnt_r_bin2_dup0_wdata (pf_ll_enq_cnt_r_bin2_dup0_wdata)
,.pf_ll_enq_cnt_r_bin2_dup0_rdata (pf_ll_enq_cnt_r_bin2_dup0_rdata)

,.rf_ll_enq_cnt_r_bin2_dup0_rclk (rf_ll_enq_cnt_r_bin2_dup0_rclk)
,.rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n (rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup0_re    (rf_ll_enq_cnt_r_bin2_dup0_re)
,.rf_ll_enq_cnt_r_bin2_dup0_raddr (rf_ll_enq_cnt_r_bin2_dup0_raddr)
,.rf_ll_enq_cnt_r_bin2_dup0_waddr (rf_ll_enq_cnt_r_bin2_dup0_waddr)
,.rf_ll_enq_cnt_r_bin2_dup0_wclk (rf_ll_enq_cnt_r_bin2_dup0_wclk)
,.rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n (rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup0_we    (rf_ll_enq_cnt_r_bin2_dup0_we)
,.rf_ll_enq_cnt_r_bin2_dup0_wdata (rf_ll_enq_cnt_r_bin2_dup0_wdata)
,.rf_ll_enq_cnt_r_bin2_dup0_rdata (rf_ll_enq_cnt_r_bin2_dup0_rdata)

,.rf_ll_enq_cnt_r_bin2_dup0_error (rf_ll_enq_cnt_r_bin2_dup0_error)

,.func_ll_enq_cnt_r_bin2_dup1_re    (func_ll_enq_cnt_r_bin2_dup1_re)
,.func_ll_enq_cnt_r_bin2_dup1_raddr (func_ll_enq_cnt_r_bin2_dup1_raddr)
,.func_ll_enq_cnt_r_bin2_dup1_waddr (func_ll_enq_cnt_r_bin2_dup1_waddr)
,.func_ll_enq_cnt_r_bin2_dup1_we    (func_ll_enq_cnt_r_bin2_dup1_we)
,.func_ll_enq_cnt_r_bin2_dup1_wdata (func_ll_enq_cnt_r_bin2_dup1_wdata)
,.func_ll_enq_cnt_r_bin2_dup1_rdata (func_ll_enq_cnt_r_bin2_dup1_rdata)

,.pf_ll_enq_cnt_r_bin2_dup1_re      (pf_ll_enq_cnt_r_bin2_dup1_re)
,.pf_ll_enq_cnt_r_bin2_dup1_raddr (pf_ll_enq_cnt_r_bin2_dup1_raddr)
,.pf_ll_enq_cnt_r_bin2_dup1_waddr (pf_ll_enq_cnt_r_bin2_dup1_waddr)
,.pf_ll_enq_cnt_r_bin2_dup1_we    (pf_ll_enq_cnt_r_bin2_dup1_we)
,.pf_ll_enq_cnt_r_bin2_dup1_wdata (pf_ll_enq_cnt_r_bin2_dup1_wdata)
,.pf_ll_enq_cnt_r_bin2_dup1_rdata (pf_ll_enq_cnt_r_bin2_dup1_rdata)

,.rf_ll_enq_cnt_r_bin2_dup1_rclk (rf_ll_enq_cnt_r_bin2_dup1_rclk)
,.rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n (rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup1_re    (rf_ll_enq_cnt_r_bin2_dup1_re)
,.rf_ll_enq_cnt_r_bin2_dup1_raddr (rf_ll_enq_cnt_r_bin2_dup1_raddr)
,.rf_ll_enq_cnt_r_bin2_dup1_waddr (rf_ll_enq_cnt_r_bin2_dup1_waddr)
,.rf_ll_enq_cnt_r_bin2_dup1_wclk (rf_ll_enq_cnt_r_bin2_dup1_wclk)
,.rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n (rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup1_we    (rf_ll_enq_cnt_r_bin2_dup1_we)
,.rf_ll_enq_cnt_r_bin2_dup1_wdata (rf_ll_enq_cnt_r_bin2_dup1_wdata)
,.rf_ll_enq_cnt_r_bin2_dup1_rdata (rf_ll_enq_cnt_r_bin2_dup1_rdata)

,.rf_ll_enq_cnt_r_bin2_dup1_error (rf_ll_enq_cnt_r_bin2_dup1_error)

,.func_ll_enq_cnt_r_bin2_dup2_re    (func_ll_enq_cnt_r_bin2_dup2_re)
,.func_ll_enq_cnt_r_bin2_dup2_raddr (func_ll_enq_cnt_r_bin2_dup2_raddr)
,.func_ll_enq_cnt_r_bin2_dup2_waddr (func_ll_enq_cnt_r_bin2_dup2_waddr)
,.func_ll_enq_cnt_r_bin2_dup2_we    (func_ll_enq_cnt_r_bin2_dup2_we)
,.func_ll_enq_cnt_r_bin2_dup2_wdata (func_ll_enq_cnt_r_bin2_dup2_wdata)
,.func_ll_enq_cnt_r_bin2_dup2_rdata (func_ll_enq_cnt_r_bin2_dup2_rdata)

,.pf_ll_enq_cnt_r_bin2_dup2_re      (pf_ll_enq_cnt_r_bin2_dup2_re)
,.pf_ll_enq_cnt_r_bin2_dup2_raddr (pf_ll_enq_cnt_r_bin2_dup2_raddr)
,.pf_ll_enq_cnt_r_bin2_dup2_waddr (pf_ll_enq_cnt_r_bin2_dup2_waddr)
,.pf_ll_enq_cnt_r_bin2_dup2_we    (pf_ll_enq_cnt_r_bin2_dup2_we)
,.pf_ll_enq_cnt_r_bin2_dup2_wdata (pf_ll_enq_cnt_r_bin2_dup2_wdata)
,.pf_ll_enq_cnt_r_bin2_dup2_rdata (pf_ll_enq_cnt_r_bin2_dup2_rdata)

,.rf_ll_enq_cnt_r_bin2_dup2_rclk (rf_ll_enq_cnt_r_bin2_dup2_rclk)
,.rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n (rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup2_re    (rf_ll_enq_cnt_r_bin2_dup2_re)
,.rf_ll_enq_cnt_r_bin2_dup2_raddr (rf_ll_enq_cnt_r_bin2_dup2_raddr)
,.rf_ll_enq_cnt_r_bin2_dup2_waddr (rf_ll_enq_cnt_r_bin2_dup2_waddr)
,.rf_ll_enq_cnt_r_bin2_dup2_wclk (rf_ll_enq_cnt_r_bin2_dup2_wclk)
,.rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n (rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup2_we    (rf_ll_enq_cnt_r_bin2_dup2_we)
,.rf_ll_enq_cnt_r_bin2_dup2_wdata (rf_ll_enq_cnt_r_bin2_dup2_wdata)
,.rf_ll_enq_cnt_r_bin2_dup2_rdata (rf_ll_enq_cnt_r_bin2_dup2_rdata)

,.rf_ll_enq_cnt_r_bin2_dup2_error (rf_ll_enq_cnt_r_bin2_dup2_error)

,.func_ll_enq_cnt_r_bin2_dup3_re    (func_ll_enq_cnt_r_bin2_dup3_re)
,.func_ll_enq_cnt_r_bin2_dup3_raddr (func_ll_enq_cnt_r_bin2_dup3_raddr)
,.func_ll_enq_cnt_r_bin2_dup3_waddr (func_ll_enq_cnt_r_bin2_dup3_waddr)
,.func_ll_enq_cnt_r_bin2_dup3_we    (func_ll_enq_cnt_r_bin2_dup3_we)
,.func_ll_enq_cnt_r_bin2_dup3_wdata (func_ll_enq_cnt_r_bin2_dup3_wdata)
,.func_ll_enq_cnt_r_bin2_dup3_rdata (func_ll_enq_cnt_r_bin2_dup3_rdata)

,.pf_ll_enq_cnt_r_bin2_dup3_re      (pf_ll_enq_cnt_r_bin2_dup3_re)
,.pf_ll_enq_cnt_r_bin2_dup3_raddr (pf_ll_enq_cnt_r_bin2_dup3_raddr)
,.pf_ll_enq_cnt_r_bin2_dup3_waddr (pf_ll_enq_cnt_r_bin2_dup3_waddr)
,.pf_ll_enq_cnt_r_bin2_dup3_we    (pf_ll_enq_cnt_r_bin2_dup3_we)
,.pf_ll_enq_cnt_r_bin2_dup3_wdata (pf_ll_enq_cnt_r_bin2_dup3_wdata)
,.pf_ll_enq_cnt_r_bin2_dup3_rdata (pf_ll_enq_cnt_r_bin2_dup3_rdata)

,.rf_ll_enq_cnt_r_bin2_dup3_rclk (rf_ll_enq_cnt_r_bin2_dup3_rclk)
,.rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n (rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup3_re    (rf_ll_enq_cnt_r_bin2_dup3_re)
,.rf_ll_enq_cnt_r_bin2_dup3_raddr (rf_ll_enq_cnt_r_bin2_dup3_raddr)
,.rf_ll_enq_cnt_r_bin2_dup3_waddr (rf_ll_enq_cnt_r_bin2_dup3_waddr)
,.rf_ll_enq_cnt_r_bin2_dup3_wclk (rf_ll_enq_cnt_r_bin2_dup3_wclk)
,.rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n (rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin2_dup3_we    (rf_ll_enq_cnt_r_bin2_dup3_we)
,.rf_ll_enq_cnt_r_bin2_dup3_wdata (rf_ll_enq_cnt_r_bin2_dup3_wdata)
,.rf_ll_enq_cnt_r_bin2_dup3_rdata (rf_ll_enq_cnt_r_bin2_dup3_rdata)

,.rf_ll_enq_cnt_r_bin2_dup3_error (rf_ll_enq_cnt_r_bin2_dup3_error)

,.func_ll_enq_cnt_r_bin3_dup0_re    (func_ll_enq_cnt_r_bin3_dup0_re)
,.func_ll_enq_cnt_r_bin3_dup0_raddr (func_ll_enq_cnt_r_bin3_dup0_raddr)
,.func_ll_enq_cnt_r_bin3_dup0_waddr (func_ll_enq_cnt_r_bin3_dup0_waddr)
,.func_ll_enq_cnt_r_bin3_dup0_we    (func_ll_enq_cnt_r_bin3_dup0_we)
,.func_ll_enq_cnt_r_bin3_dup0_wdata (func_ll_enq_cnt_r_bin3_dup0_wdata)
,.func_ll_enq_cnt_r_bin3_dup0_rdata (func_ll_enq_cnt_r_bin3_dup0_rdata)

,.pf_ll_enq_cnt_r_bin3_dup0_re      (pf_ll_enq_cnt_r_bin3_dup0_re)
,.pf_ll_enq_cnt_r_bin3_dup0_raddr (pf_ll_enq_cnt_r_bin3_dup0_raddr)
,.pf_ll_enq_cnt_r_bin3_dup0_waddr (pf_ll_enq_cnt_r_bin3_dup0_waddr)
,.pf_ll_enq_cnt_r_bin3_dup0_we    (pf_ll_enq_cnt_r_bin3_dup0_we)
,.pf_ll_enq_cnt_r_bin3_dup0_wdata (pf_ll_enq_cnt_r_bin3_dup0_wdata)
,.pf_ll_enq_cnt_r_bin3_dup0_rdata (pf_ll_enq_cnt_r_bin3_dup0_rdata)

,.rf_ll_enq_cnt_r_bin3_dup0_rclk (rf_ll_enq_cnt_r_bin3_dup0_rclk)
,.rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n (rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup0_re    (rf_ll_enq_cnt_r_bin3_dup0_re)
,.rf_ll_enq_cnt_r_bin3_dup0_raddr (rf_ll_enq_cnt_r_bin3_dup0_raddr)
,.rf_ll_enq_cnt_r_bin3_dup0_waddr (rf_ll_enq_cnt_r_bin3_dup0_waddr)
,.rf_ll_enq_cnt_r_bin3_dup0_wclk (rf_ll_enq_cnt_r_bin3_dup0_wclk)
,.rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n (rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup0_we    (rf_ll_enq_cnt_r_bin3_dup0_we)
,.rf_ll_enq_cnt_r_bin3_dup0_wdata (rf_ll_enq_cnt_r_bin3_dup0_wdata)
,.rf_ll_enq_cnt_r_bin3_dup0_rdata (rf_ll_enq_cnt_r_bin3_dup0_rdata)

,.rf_ll_enq_cnt_r_bin3_dup0_error (rf_ll_enq_cnt_r_bin3_dup0_error)

,.func_ll_enq_cnt_r_bin3_dup1_re    (func_ll_enq_cnt_r_bin3_dup1_re)
,.func_ll_enq_cnt_r_bin3_dup1_raddr (func_ll_enq_cnt_r_bin3_dup1_raddr)
,.func_ll_enq_cnt_r_bin3_dup1_waddr (func_ll_enq_cnt_r_bin3_dup1_waddr)
,.func_ll_enq_cnt_r_bin3_dup1_we    (func_ll_enq_cnt_r_bin3_dup1_we)
,.func_ll_enq_cnt_r_bin3_dup1_wdata (func_ll_enq_cnt_r_bin3_dup1_wdata)
,.func_ll_enq_cnt_r_bin3_dup1_rdata (func_ll_enq_cnt_r_bin3_dup1_rdata)

,.pf_ll_enq_cnt_r_bin3_dup1_re      (pf_ll_enq_cnt_r_bin3_dup1_re)
,.pf_ll_enq_cnt_r_bin3_dup1_raddr (pf_ll_enq_cnt_r_bin3_dup1_raddr)
,.pf_ll_enq_cnt_r_bin3_dup1_waddr (pf_ll_enq_cnt_r_bin3_dup1_waddr)
,.pf_ll_enq_cnt_r_bin3_dup1_we    (pf_ll_enq_cnt_r_bin3_dup1_we)
,.pf_ll_enq_cnt_r_bin3_dup1_wdata (pf_ll_enq_cnt_r_bin3_dup1_wdata)
,.pf_ll_enq_cnt_r_bin3_dup1_rdata (pf_ll_enq_cnt_r_bin3_dup1_rdata)

,.rf_ll_enq_cnt_r_bin3_dup1_rclk (rf_ll_enq_cnt_r_bin3_dup1_rclk)
,.rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n (rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup1_re    (rf_ll_enq_cnt_r_bin3_dup1_re)
,.rf_ll_enq_cnt_r_bin3_dup1_raddr (rf_ll_enq_cnt_r_bin3_dup1_raddr)
,.rf_ll_enq_cnt_r_bin3_dup1_waddr (rf_ll_enq_cnt_r_bin3_dup1_waddr)
,.rf_ll_enq_cnt_r_bin3_dup1_wclk (rf_ll_enq_cnt_r_bin3_dup1_wclk)
,.rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n (rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup1_we    (rf_ll_enq_cnt_r_bin3_dup1_we)
,.rf_ll_enq_cnt_r_bin3_dup1_wdata (rf_ll_enq_cnt_r_bin3_dup1_wdata)
,.rf_ll_enq_cnt_r_bin3_dup1_rdata (rf_ll_enq_cnt_r_bin3_dup1_rdata)

,.rf_ll_enq_cnt_r_bin3_dup1_error (rf_ll_enq_cnt_r_bin3_dup1_error)

,.func_ll_enq_cnt_r_bin3_dup2_re    (func_ll_enq_cnt_r_bin3_dup2_re)
,.func_ll_enq_cnt_r_bin3_dup2_raddr (func_ll_enq_cnt_r_bin3_dup2_raddr)
,.func_ll_enq_cnt_r_bin3_dup2_waddr (func_ll_enq_cnt_r_bin3_dup2_waddr)
,.func_ll_enq_cnt_r_bin3_dup2_we    (func_ll_enq_cnt_r_bin3_dup2_we)
,.func_ll_enq_cnt_r_bin3_dup2_wdata (func_ll_enq_cnt_r_bin3_dup2_wdata)
,.func_ll_enq_cnt_r_bin3_dup2_rdata (func_ll_enq_cnt_r_bin3_dup2_rdata)

,.pf_ll_enq_cnt_r_bin3_dup2_re      (pf_ll_enq_cnt_r_bin3_dup2_re)
,.pf_ll_enq_cnt_r_bin3_dup2_raddr (pf_ll_enq_cnt_r_bin3_dup2_raddr)
,.pf_ll_enq_cnt_r_bin3_dup2_waddr (pf_ll_enq_cnt_r_bin3_dup2_waddr)
,.pf_ll_enq_cnt_r_bin3_dup2_we    (pf_ll_enq_cnt_r_bin3_dup2_we)
,.pf_ll_enq_cnt_r_bin3_dup2_wdata (pf_ll_enq_cnt_r_bin3_dup2_wdata)
,.pf_ll_enq_cnt_r_bin3_dup2_rdata (pf_ll_enq_cnt_r_bin3_dup2_rdata)

,.rf_ll_enq_cnt_r_bin3_dup2_rclk (rf_ll_enq_cnt_r_bin3_dup2_rclk)
,.rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n (rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup2_re    (rf_ll_enq_cnt_r_bin3_dup2_re)
,.rf_ll_enq_cnt_r_bin3_dup2_raddr (rf_ll_enq_cnt_r_bin3_dup2_raddr)
,.rf_ll_enq_cnt_r_bin3_dup2_waddr (rf_ll_enq_cnt_r_bin3_dup2_waddr)
,.rf_ll_enq_cnt_r_bin3_dup2_wclk (rf_ll_enq_cnt_r_bin3_dup2_wclk)
,.rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n (rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup2_we    (rf_ll_enq_cnt_r_bin3_dup2_we)
,.rf_ll_enq_cnt_r_bin3_dup2_wdata (rf_ll_enq_cnt_r_bin3_dup2_wdata)
,.rf_ll_enq_cnt_r_bin3_dup2_rdata (rf_ll_enq_cnt_r_bin3_dup2_rdata)

,.rf_ll_enq_cnt_r_bin3_dup2_error (rf_ll_enq_cnt_r_bin3_dup2_error)

,.func_ll_enq_cnt_r_bin3_dup3_re    (func_ll_enq_cnt_r_bin3_dup3_re)
,.func_ll_enq_cnt_r_bin3_dup3_raddr (func_ll_enq_cnt_r_bin3_dup3_raddr)
,.func_ll_enq_cnt_r_bin3_dup3_waddr (func_ll_enq_cnt_r_bin3_dup3_waddr)
,.func_ll_enq_cnt_r_bin3_dup3_we    (func_ll_enq_cnt_r_bin3_dup3_we)
,.func_ll_enq_cnt_r_bin3_dup3_wdata (func_ll_enq_cnt_r_bin3_dup3_wdata)
,.func_ll_enq_cnt_r_bin3_dup3_rdata (func_ll_enq_cnt_r_bin3_dup3_rdata)

,.pf_ll_enq_cnt_r_bin3_dup3_re      (pf_ll_enq_cnt_r_bin3_dup3_re)
,.pf_ll_enq_cnt_r_bin3_dup3_raddr (pf_ll_enq_cnt_r_bin3_dup3_raddr)
,.pf_ll_enq_cnt_r_bin3_dup3_waddr (pf_ll_enq_cnt_r_bin3_dup3_waddr)
,.pf_ll_enq_cnt_r_bin3_dup3_we    (pf_ll_enq_cnt_r_bin3_dup3_we)
,.pf_ll_enq_cnt_r_bin3_dup3_wdata (pf_ll_enq_cnt_r_bin3_dup3_wdata)
,.pf_ll_enq_cnt_r_bin3_dup3_rdata (pf_ll_enq_cnt_r_bin3_dup3_rdata)

,.rf_ll_enq_cnt_r_bin3_dup3_rclk (rf_ll_enq_cnt_r_bin3_dup3_rclk)
,.rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n (rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup3_re    (rf_ll_enq_cnt_r_bin3_dup3_re)
,.rf_ll_enq_cnt_r_bin3_dup3_raddr (rf_ll_enq_cnt_r_bin3_dup3_raddr)
,.rf_ll_enq_cnt_r_bin3_dup3_waddr (rf_ll_enq_cnt_r_bin3_dup3_waddr)
,.rf_ll_enq_cnt_r_bin3_dup3_wclk (rf_ll_enq_cnt_r_bin3_dup3_wclk)
,.rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n (rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n)
,.rf_ll_enq_cnt_r_bin3_dup3_we    (rf_ll_enq_cnt_r_bin3_dup3_we)
,.rf_ll_enq_cnt_r_bin3_dup3_wdata (rf_ll_enq_cnt_r_bin3_dup3_wdata)
,.rf_ll_enq_cnt_r_bin3_dup3_rdata (rf_ll_enq_cnt_r_bin3_dup3_rdata)

,.rf_ll_enq_cnt_r_bin3_dup3_error (rf_ll_enq_cnt_r_bin3_dup3_error)

,.func_ll_enq_cnt_s_bin0_re    (func_ll_enq_cnt_s_bin0_re)
,.func_ll_enq_cnt_s_bin0_raddr (func_ll_enq_cnt_s_bin0_raddr)
,.func_ll_enq_cnt_s_bin0_waddr (func_ll_enq_cnt_s_bin0_waddr)
,.func_ll_enq_cnt_s_bin0_we    (func_ll_enq_cnt_s_bin0_we)
,.func_ll_enq_cnt_s_bin0_wdata (func_ll_enq_cnt_s_bin0_wdata)
,.func_ll_enq_cnt_s_bin0_rdata (func_ll_enq_cnt_s_bin0_rdata)

,.pf_ll_enq_cnt_s_bin0_re      (pf_ll_enq_cnt_s_bin0_re)
,.pf_ll_enq_cnt_s_bin0_raddr (pf_ll_enq_cnt_s_bin0_raddr)
,.pf_ll_enq_cnt_s_bin0_waddr (pf_ll_enq_cnt_s_bin0_waddr)
,.pf_ll_enq_cnt_s_bin0_we    (pf_ll_enq_cnt_s_bin0_we)
,.pf_ll_enq_cnt_s_bin0_wdata (pf_ll_enq_cnt_s_bin0_wdata)
,.pf_ll_enq_cnt_s_bin0_rdata (pf_ll_enq_cnt_s_bin0_rdata)

,.rf_ll_enq_cnt_s_bin0_rclk (rf_ll_enq_cnt_s_bin0_rclk)
,.rf_ll_enq_cnt_s_bin0_rclk_rst_n (rf_ll_enq_cnt_s_bin0_rclk_rst_n)
,.rf_ll_enq_cnt_s_bin0_re    (rf_ll_enq_cnt_s_bin0_re)
,.rf_ll_enq_cnt_s_bin0_raddr (rf_ll_enq_cnt_s_bin0_raddr)
,.rf_ll_enq_cnt_s_bin0_waddr (rf_ll_enq_cnt_s_bin0_waddr)
,.rf_ll_enq_cnt_s_bin0_wclk (rf_ll_enq_cnt_s_bin0_wclk)
,.rf_ll_enq_cnt_s_bin0_wclk_rst_n (rf_ll_enq_cnt_s_bin0_wclk_rst_n)
,.rf_ll_enq_cnt_s_bin0_we    (rf_ll_enq_cnt_s_bin0_we)
,.rf_ll_enq_cnt_s_bin0_wdata (rf_ll_enq_cnt_s_bin0_wdata)
,.rf_ll_enq_cnt_s_bin0_rdata (rf_ll_enq_cnt_s_bin0_rdata)

,.rf_ll_enq_cnt_s_bin0_error (rf_ll_enq_cnt_s_bin0_error)

,.func_ll_enq_cnt_s_bin1_re    (func_ll_enq_cnt_s_bin1_re)
,.func_ll_enq_cnt_s_bin1_raddr (func_ll_enq_cnt_s_bin1_raddr)
,.func_ll_enq_cnt_s_bin1_waddr (func_ll_enq_cnt_s_bin1_waddr)
,.func_ll_enq_cnt_s_bin1_we    (func_ll_enq_cnt_s_bin1_we)
,.func_ll_enq_cnt_s_bin1_wdata (func_ll_enq_cnt_s_bin1_wdata)
,.func_ll_enq_cnt_s_bin1_rdata (func_ll_enq_cnt_s_bin1_rdata)

,.pf_ll_enq_cnt_s_bin1_re      (pf_ll_enq_cnt_s_bin1_re)
,.pf_ll_enq_cnt_s_bin1_raddr (pf_ll_enq_cnt_s_bin1_raddr)
,.pf_ll_enq_cnt_s_bin1_waddr (pf_ll_enq_cnt_s_bin1_waddr)
,.pf_ll_enq_cnt_s_bin1_we    (pf_ll_enq_cnt_s_bin1_we)
,.pf_ll_enq_cnt_s_bin1_wdata (pf_ll_enq_cnt_s_bin1_wdata)
,.pf_ll_enq_cnt_s_bin1_rdata (pf_ll_enq_cnt_s_bin1_rdata)

,.rf_ll_enq_cnt_s_bin1_rclk (rf_ll_enq_cnt_s_bin1_rclk)
,.rf_ll_enq_cnt_s_bin1_rclk_rst_n (rf_ll_enq_cnt_s_bin1_rclk_rst_n)
,.rf_ll_enq_cnt_s_bin1_re    (rf_ll_enq_cnt_s_bin1_re)
,.rf_ll_enq_cnt_s_bin1_raddr (rf_ll_enq_cnt_s_bin1_raddr)
,.rf_ll_enq_cnt_s_bin1_waddr (rf_ll_enq_cnt_s_bin1_waddr)
,.rf_ll_enq_cnt_s_bin1_wclk (rf_ll_enq_cnt_s_bin1_wclk)
,.rf_ll_enq_cnt_s_bin1_wclk_rst_n (rf_ll_enq_cnt_s_bin1_wclk_rst_n)
,.rf_ll_enq_cnt_s_bin1_we    (rf_ll_enq_cnt_s_bin1_we)
,.rf_ll_enq_cnt_s_bin1_wdata (rf_ll_enq_cnt_s_bin1_wdata)
,.rf_ll_enq_cnt_s_bin1_rdata (rf_ll_enq_cnt_s_bin1_rdata)

,.rf_ll_enq_cnt_s_bin1_error (rf_ll_enq_cnt_s_bin1_error)

,.func_ll_enq_cnt_s_bin2_re    (func_ll_enq_cnt_s_bin2_re)
,.func_ll_enq_cnt_s_bin2_raddr (func_ll_enq_cnt_s_bin2_raddr)
,.func_ll_enq_cnt_s_bin2_waddr (func_ll_enq_cnt_s_bin2_waddr)
,.func_ll_enq_cnt_s_bin2_we    (func_ll_enq_cnt_s_bin2_we)
,.func_ll_enq_cnt_s_bin2_wdata (func_ll_enq_cnt_s_bin2_wdata)
,.func_ll_enq_cnt_s_bin2_rdata (func_ll_enq_cnt_s_bin2_rdata)

,.pf_ll_enq_cnt_s_bin2_re      (pf_ll_enq_cnt_s_bin2_re)
,.pf_ll_enq_cnt_s_bin2_raddr (pf_ll_enq_cnt_s_bin2_raddr)
,.pf_ll_enq_cnt_s_bin2_waddr (pf_ll_enq_cnt_s_bin2_waddr)
,.pf_ll_enq_cnt_s_bin2_we    (pf_ll_enq_cnt_s_bin2_we)
,.pf_ll_enq_cnt_s_bin2_wdata (pf_ll_enq_cnt_s_bin2_wdata)
,.pf_ll_enq_cnt_s_bin2_rdata (pf_ll_enq_cnt_s_bin2_rdata)

,.rf_ll_enq_cnt_s_bin2_rclk (rf_ll_enq_cnt_s_bin2_rclk)
,.rf_ll_enq_cnt_s_bin2_rclk_rst_n (rf_ll_enq_cnt_s_bin2_rclk_rst_n)
,.rf_ll_enq_cnt_s_bin2_re    (rf_ll_enq_cnt_s_bin2_re)
,.rf_ll_enq_cnt_s_bin2_raddr (rf_ll_enq_cnt_s_bin2_raddr)
,.rf_ll_enq_cnt_s_bin2_waddr (rf_ll_enq_cnt_s_bin2_waddr)
,.rf_ll_enq_cnt_s_bin2_wclk (rf_ll_enq_cnt_s_bin2_wclk)
,.rf_ll_enq_cnt_s_bin2_wclk_rst_n (rf_ll_enq_cnt_s_bin2_wclk_rst_n)
,.rf_ll_enq_cnt_s_bin2_we    (rf_ll_enq_cnt_s_bin2_we)
,.rf_ll_enq_cnt_s_bin2_wdata (rf_ll_enq_cnt_s_bin2_wdata)
,.rf_ll_enq_cnt_s_bin2_rdata (rf_ll_enq_cnt_s_bin2_rdata)

,.rf_ll_enq_cnt_s_bin2_error (rf_ll_enq_cnt_s_bin2_error)

,.func_ll_enq_cnt_s_bin3_re    (func_ll_enq_cnt_s_bin3_re)
,.func_ll_enq_cnt_s_bin3_raddr (func_ll_enq_cnt_s_bin3_raddr)
,.func_ll_enq_cnt_s_bin3_waddr (func_ll_enq_cnt_s_bin3_waddr)
,.func_ll_enq_cnt_s_bin3_we    (func_ll_enq_cnt_s_bin3_we)
,.func_ll_enq_cnt_s_bin3_wdata (func_ll_enq_cnt_s_bin3_wdata)
,.func_ll_enq_cnt_s_bin3_rdata (func_ll_enq_cnt_s_bin3_rdata)

,.pf_ll_enq_cnt_s_bin3_re      (pf_ll_enq_cnt_s_bin3_re)
,.pf_ll_enq_cnt_s_bin3_raddr (pf_ll_enq_cnt_s_bin3_raddr)
,.pf_ll_enq_cnt_s_bin3_waddr (pf_ll_enq_cnt_s_bin3_waddr)
,.pf_ll_enq_cnt_s_bin3_we    (pf_ll_enq_cnt_s_bin3_we)
,.pf_ll_enq_cnt_s_bin3_wdata (pf_ll_enq_cnt_s_bin3_wdata)
,.pf_ll_enq_cnt_s_bin3_rdata (pf_ll_enq_cnt_s_bin3_rdata)

,.rf_ll_enq_cnt_s_bin3_rclk (rf_ll_enq_cnt_s_bin3_rclk)
,.rf_ll_enq_cnt_s_bin3_rclk_rst_n (rf_ll_enq_cnt_s_bin3_rclk_rst_n)
,.rf_ll_enq_cnt_s_bin3_re    (rf_ll_enq_cnt_s_bin3_re)
,.rf_ll_enq_cnt_s_bin3_raddr (rf_ll_enq_cnt_s_bin3_raddr)
,.rf_ll_enq_cnt_s_bin3_waddr (rf_ll_enq_cnt_s_bin3_waddr)
,.rf_ll_enq_cnt_s_bin3_wclk (rf_ll_enq_cnt_s_bin3_wclk)
,.rf_ll_enq_cnt_s_bin3_wclk_rst_n (rf_ll_enq_cnt_s_bin3_wclk_rst_n)
,.rf_ll_enq_cnt_s_bin3_we    (rf_ll_enq_cnt_s_bin3_we)
,.rf_ll_enq_cnt_s_bin3_wdata (rf_ll_enq_cnt_s_bin3_wdata)
,.rf_ll_enq_cnt_s_bin3_rdata (rf_ll_enq_cnt_s_bin3_rdata)

,.rf_ll_enq_cnt_s_bin3_error (rf_ll_enq_cnt_s_bin3_error)

,.func_ll_rdylst_hp_bin0_re    (func_ll_rdylst_hp_bin0_re)
,.func_ll_rdylst_hp_bin0_raddr (func_ll_rdylst_hp_bin0_raddr)
,.func_ll_rdylst_hp_bin0_waddr (func_ll_rdylst_hp_bin0_waddr)
,.func_ll_rdylst_hp_bin0_we    (func_ll_rdylst_hp_bin0_we)
,.func_ll_rdylst_hp_bin0_wdata (func_ll_rdylst_hp_bin0_wdata)
,.func_ll_rdylst_hp_bin0_rdata (func_ll_rdylst_hp_bin0_rdata)

,.pf_ll_rdylst_hp_bin0_re      (pf_ll_rdylst_hp_bin0_re)
,.pf_ll_rdylst_hp_bin0_raddr (pf_ll_rdylst_hp_bin0_raddr)
,.pf_ll_rdylst_hp_bin0_waddr (pf_ll_rdylst_hp_bin0_waddr)
,.pf_ll_rdylst_hp_bin0_we    (pf_ll_rdylst_hp_bin0_we)
,.pf_ll_rdylst_hp_bin0_wdata (pf_ll_rdylst_hp_bin0_wdata)
,.pf_ll_rdylst_hp_bin0_rdata (pf_ll_rdylst_hp_bin0_rdata)

,.rf_ll_rdylst_hp_bin0_rclk (rf_ll_rdylst_hp_bin0_rclk)
,.rf_ll_rdylst_hp_bin0_rclk_rst_n (rf_ll_rdylst_hp_bin0_rclk_rst_n)
,.rf_ll_rdylst_hp_bin0_re    (rf_ll_rdylst_hp_bin0_re)
,.rf_ll_rdylst_hp_bin0_raddr (rf_ll_rdylst_hp_bin0_raddr)
,.rf_ll_rdylst_hp_bin0_waddr (rf_ll_rdylst_hp_bin0_waddr)
,.rf_ll_rdylst_hp_bin0_wclk (rf_ll_rdylst_hp_bin0_wclk)
,.rf_ll_rdylst_hp_bin0_wclk_rst_n (rf_ll_rdylst_hp_bin0_wclk_rst_n)
,.rf_ll_rdylst_hp_bin0_we    (rf_ll_rdylst_hp_bin0_we)
,.rf_ll_rdylst_hp_bin0_wdata (rf_ll_rdylst_hp_bin0_wdata)
,.rf_ll_rdylst_hp_bin0_rdata (rf_ll_rdylst_hp_bin0_rdata)

,.rf_ll_rdylst_hp_bin0_error (rf_ll_rdylst_hp_bin0_error)

,.func_ll_rdylst_hp_bin1_re    (func_ll_rdylst_hp_bin1_re)
,.func_ll_rdylst_hp_bin1_raddr (func_ll_rdylst_hp_bin1_raddr)
,.func_ll_rdylst_hp_bin1_waddr (func_ll_rdylst_hp_bin1_waddr)
,.func_ll_rdylst_hp_bin1_we    (func_ll_rdylst_hp_bin1_we)
,.func_ll_rdylst_hp_bin1_wdata (func_ll_rdylst_hp_bin1_wdata)
,.func_ll_rdylst_hp_bin1_rdata (func_ll_rdylst_hp_bin1_rdata)

,.pf_ll_rdylst_hp_bin1_re      (pf_ll_rdylst_hp_bin1_re)
,.pf_ll_rdylst_hp_bin1_raddr (pf_ll_rdylst_hp_bin1_raddr)
,.pf_ll_rdylst_hp_bin1_waddr (pf_ll_rdylst_hp_bin1_waddr)
,.pf_ll_rdylst_hp_bin1_we    (pf_ll_rdylst_hp_bin1_we)
,.pf_ll_rdylst_hp_bin1_wdata (pf_ll_rdylst_hp_bin1_wdata)
,.pf_ll_rdylst_hp_bin1_rdata (pf_ll_rdylst_hp_bin1_rdata)

,.rf_ll_rdylst_hp_bin1_rclk (rf_ll_rdylst_hp_bin1_rclk)
,.rf_ll_rdylst_hp_bin1_rclk_rst_n (rf_ll_rdylst_hp_bin1_rclk_rst_n)
,.rf_ll_rdylst_hp_bin1_re    (rf_ll_rdylst_hp_bin1_re)
,.rf_ll_rdylst_hp_bin1_raddr (rf_ll_rdylst_hp_bin1_raddr)
,.rf_ll_rdylst_hp_bin1_waddr (rf_ll_rdylst_hp_bin1_waddr)
,.rf_ll_rdylst_hp_bin1_wclk (rf_ll_rdylst_hp_bin1_wclk)
,.rf_ll_rdylst_hp_bin1_wclk_rst_n (rf_ll_rdylst_hp_bin1_wclk_rst_n)
,.rf_ll_rdylst_hp_bin1_we    (rf_ll_rdylst_hp_bin1_we)
,.rf_ll_rdylst_hp_bin1_wdata (rf_ll_rdylst_hp_bin1_wdata)
,.rf_ll_rdylst_hp_bin1_rdata (rf_ll_rdylst_hp_bin1_rdata)

,.rf_ll_rdylst_hp_bin1_error (rf_ll_rdylst_hp_bin1_error)

,.func_ll_rdylst_hp_bin2_re    (func_ll_rdylst_hp_bin2_re)
,.func_ll_rdylst_hp_bin2_raddr (func_ll_rdylst_hp_bin2_raddr)
,.func_ll_rdylst_hp_bin2_waddr (func_ll_rdylst_hp_bin2_waddr)
,.func_ll_rdylst_hp_bin2_we    (func_ll_rdylst_hp_bin2_we)
,.func_ll_rdylst_hp_bin2_wdata (func_ll_rdylst_hp_bin2_wdata)
,.func_ll_rdylst_hp_bin2_rdata (func_ll_rdylst_hp_bin2_rdata)

,.pf_ll_rdylst_hp_bin2_re      (pf_ll_rdylst_hp_bin2_re)
,.pf_ll_rdylst_hp_bin2_raddr (pf_ll_rdylst_hp_bin2_raddr)
,.pf_ll_rdylst_hp_bin2_waddr (pf_ll_rdylst_hp_bin2_waddr)
,.pf_ll_rdylst_hp_bin2_we    (pf_ll_rdylst_hp_bin2_we)
,.pf_ll_rdylst_hp_bin2_wdata (pf_ll_rdylst_hp_bin2_wdata)
,.pf_ll_rdylst_hp_bin2_rdata (pf_ll_rdylst_hp_bin2_rdata)

,.rf_ll_rdylst_hp_bin2_rclk (rf_ll_rdylst_hp_bin2_rclk)
,.rf_ll_rdylst_hp_bin2_rclk_rst_n (rf_ll_rdylst_hp_bin2_rclk_rst_n)
,.rf_ll_rdylst_hp_bin2_re    (rf_ll_rdylst_hp_bin2_re)
,.rf_ll_rdylst_hp_bin2_raddr (rf_ll_rdylst_hp_bin2_raddr)
,.rf_ll_rdylst_hp_bin2_waddr (rf_ll_rdylst_hp_bin2_waddr)
,.rf_ll_rdylst_hp_bin2_wclk (rf_ll_rdylst_hp_bin2_wclk)
,.rf_ll_rdylst_hp_bin2_wclk_rst_n (rf_ll_rdylst_hp_bin2_wclk_rst_n)
,.rf_ll_rdylst_hp_bin2_we    (rf_ll_rdylst_hp_bin2_we)
,.rf_ll_rdylst_hp_bin2_wdata (rf_ll_rdylst_hp_bin2_wdata)
,.rf_ll_rdylst_hp_bin2_rdata (rf_ll_rdylst_hp_bin2_rdata)

,.rf_ll_rdylst_hp_bin2_error (rf_ll_rdylst_hp_bin2_error)

,.func_ll_rdylst_hp_bin3_re    (func_ll_rdylst_hp_bin3_re)
,.func_ll_rdylst_hp_bin3_raddr (func_ll_rdylst_hp_bin3_raddr)
,.func_ll_rdylst_hp_bin3_waddr (func_ll_rdylst_hp_bin3_waddr)
,.func_ll_rdylst_hp_bin3_we    (func_ll_rdylst_hp_bin3_we)
,.func_ll_rdylst_hp_bin3_wdata (func_ll_rdylst_hp_bin3_wdata)
,.func_ll_rdylst_hp_bin3_rdata (func_ll_rdylst_hp_bin3_rdata)

,.pf_ll_rdylst_hp_bin3_re      (pf_ll_rdylst_hp_bin3_re)
,.pf_ll_rdylst_hp_bin3_raddr (pf_ll_rdylst_hp_bin3_raddr)
,.pf_ll_rdylst_hp_bin3_waddr (pf_ll_rdylst_hp_bin3_waddr)
,.pf_ll_rdylst_hp_bin3_we    (pf_ll_rdylst_hp_bin3_we)
,.pf_ll_rdylst_hp_bin3_wdata (pf_ll_rdylst_hp_bin3_wdata)
,.pf_ll_rdylst_hp_bin3_rdata (pf_ll_rdylst_hp_bin3_rdata)

,.rf_ll_rdylst_hp_bin3_rclk (rf_ll_rdylst_hp_bin3_rclk)
,.rf_ll_rdylst_hp_bin3_rclk_rst_n (rf_ll_rdylst_hp_bin3_rclk_rst_n)
,.rf_ll_rdylst_hp_bin3_re    (rf_ll_rdylst_hp_bin3_re)
,.rf_ll_rdylst_hp_bin3_raddr (rf_ll_rdylst_hp_bin3_raddr)
,.rf_ll_rdylst_hp_bin3_waddr (rf_ll_rdylst_hp_bin3_waddr)
,.rf_ll_rdylst_hp_bin3_wclk (rf_ll_rdylst_hp_bin3_wclk)
,.rf_ll_rdylst_hp_bin3_wclk_rst_n (rf_ll_rdylst_hp_bin3_wclk_rst_n)
,.rf_ll_rdylst_hp_bin3_we    (rf_ll_rdylst_hp_bin3_we)
,.rf_ll_rdylst_hp_bin3_wdata (rf_ll_rdylst_hp_bin3_wdata)
,.rf_ll_rdylst_hp_bin3_rdata (rf_ll_rdylst_hp_bin3_rdata)

,.rf_ll_rdylst_hp_bin3_error (rf_ll_rdylst_hp_bin3_error)

,.func_ll_rdylst_hpnxt_bin0_re    (func_ll_rdylst_hpnxt_bin0_re)
,.func_ll_rdylst_hpnxt_bin0_raddr (func_ll_rdylst_hpnxt_bin0_raddr)
,.func_ll_rdylst_hpnxt_bin0_waddr (func_ll_rdylst_hpnxt_bin0_waddr)
,.func_ll_rdylst_hpnxt_bin0_we    (func_ll_rdylst_hpnxt_bin0_we)
,.func_ll_rdylst_hpnxt_bin0_wdata (func_ll_rdylst_hpnxt_bin0_wdata)
,.func_ll_rdylst_hpnxt_bin0_rdata (func_ll_rdylst_hpnxt_bin0_rdata)

,.pf_ll_rdylst_hpnxt_bin0_re      (pf_ll_rdylst_hpnxt_bin0_re)
,.pf_ll_rdylst_hpnxt_bin0_raddr (pf_ll_rdylst_hpnxt_bin0_raddr)
,.pf_ll_rdylst_hpnxt_bin0_waddr (pf_ll_rdylst_hpnxt_bin0_waddr)
,.pf_ll_rdylst_hpnxt_bin0_we    (pf_ll_rdylst_hpnxt_bin0_we)
,.pf_ll_rdylst_hpnxt_bin0_wdata (pf_ll_rdylst_hpnxt_bin0_wdata)
,.pf_ll_rdylst_hpnxt_bin0_rdata (pf_ll_rdylst_hpnxt_bin0_rdata)

,.rf_ll_rdylst_hpnxt_bin0_rclk (rf_ll_rdylst_hpnxt_bin0_rclk)
,.rf_ll_rdylst_hpnxt_bin0_rclk_rst_n (rf_ll_rdylst_hpnxt_bin0_rclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin0_re    (rf_ll_rdylst_hpnxt_bin0_re)
,.rf_ll_rdylst_hpnxt_bin0_raddr (rf_ll_rdylst_hpnxt_bin0_raddr)
,.rf_ll_rdylst_hpnxt_bin0_waddr (rf_ll_rdylst_hpnxt_bin0_waddr)
,.rf_ll_rdylst_hpnxt_bin0_wclk (rf_ll_rdylst_hpnxt_bin0_wclk)
,.rf_ll_rdylst_hpnxt_bin0_wclk_rst_n (rf_ll_rdylst_hpnxt_bin0_wclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin0_we    (rf_ll_rdylst_hpnxt_bin0_we)
,.rf_ll_rdylst_hpnxt_bin0_wdata (rf_ll_rdylst_hpnxt_bin0_wdata)
,.rf_ll_rdylst_hpnxt_bin0_rdata (rf_ll_rdylst_hpnxt_bin0_rdata)

,.rf_ll_rdylst_hpnxt_bin0_error (rf_ll_rdylst_hpnxt_bin0_error)

,.func_ll_rdylst_hpnxt_bin1_re    (func_ll_rdylst_hpnxt_bin1_re)
,.func_ll_rdylst_hpnxt_bin1_raddr (func_ll_rdylst_hpnxt_bin1_raddr)
,.func_ll_rdylst_hpnxt_bin1_waddr (func_ll_rdylst_hpnxt_bin1_waddr)
,.func_ll_rdylst_hpnxt_bin1_we    (func_ll_rdylst_hpnxt_bin1_we)
,.func_ll_rdylst_hpnxt_bin1_wdata (func_ll_rdylst_hpnxt_bin1_wdata)
,.func_ll_rdylst_hpnxt_bin1_rdata (func_ll_rdylst_hpnxt_bin1_rdata)

,.pf_ll_rdylst_hpnxt_bin1_re      (pf_ll_rdylst_hpnxt_bin1_re)
,.pf_ll_rdylst_hpnxt_bin1_raddr (pf_ll_rdylst_hpnxt_bin1_raddr)
,.pf_ll_rdylst_hpnxt_bin1_waddr (pf_ll_rdylst_hpnxt_bin1_waddr)
,.pf_ll_rdylst_hpnxt_bin1_we    (pf_ll_rdylst_hpnxt_bin1_we)
,.pf_ll_rdylst_hpnxt_bin1_wdata (pf_ll_rdylst_hpnxt_bin1_wdata)
,.pf_ll_rdylst_hpnxt_bin1_rdata (pf_ll_rdylst_hpnxt_bin1_rdata)

,.rf_ll_rdylst_hpnxt_bin1_rclk (rf_ll_rdylst_hpnxt_bin1_rclk)
,.rf_ll_rdylst_hpnxt_bin1_rclk_rst_n (rf_ll_rdylst_hpnxt_bin1_rclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin1_re    (rf_ll_rdylst_hpnxt_bin1_re)
,.rf_ll_rdylst_hpnxt_bin1_raddr (rf_ll_rdylst_hpnxt_bin1_raddr)
,.rf_ll_rdylst_hpnxt_bin1_waddr (rf_ll_rdylst_hpnxt_bin1_waddr)
,.rf_ll_rdylst_hpnxt_bin1_wclk (rf_ll_rdylst_hpnxt_bin1_wclk)
,.rf_ll_rdylst_hpnxt_bin1_wclk_rst_n (rf_ll_rdylst_hpnxt_bin1_wclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin1_we    (rf_ll_rdylst_hpnxt_bin1_we)
,.rf_ll_rdylst_hpnxt_bin1_wdata (rf_ll_rdylst_hpnxt_bin1_wdata)
,.rf_ll_rdylst_hpnxt_bin1_rdata (rf_ll_rdylst_hpnxt_bin1_rdata)

,.rf_ll_rdylst_hpnxt_bin1_error (rf_ll_rdylst_hpnxt_bin1_error)

,.func_ll_rdylst_hpnxt_bin2_re    (func_ll_rdylst_hpnxt_bin2_re)
,.func_ll_rdylst_hpnxt_bin2_raddr (func_ll_rdylst_hpnxt_bin2_raddr)
,.func_ll_rdylst_hpnxt_bin2_waddr (func_ll_rdylst_hpnxt_bin2_waddr)
,.func_ll_rdylst_hpnxt_bin2_we    (func_ll_rdylst_hpnxt_bin2_we)
,.func_ll_rdylst_hpnxt_bin2_wdata (func_ll_rdylst_hpnxt_bin2_wdata)
,.func_ll_rdylst_hpnxt_bin2_rdata (func_ll_rdylst_hpnxt_bin2_rdata)

,.pf_ll_rdylst_hpnxt_bin2_re      (pf_ll_rdylst_hpnxt_bin2_re)
,.pf_ll_rdylst_hpnxt_bin2_raddr (pf_ll_rdylst_hpnxt_bin2_raddr)
,.pf_ll_rdylst_hpnxt_bin2_waddr (pf_ll_rdylst_hpnxt_bin2_waddr)
,.pf_ll_rdylst_hpnxt_bin2_we    (pf_ll_rdylst_hpnxt_bin2_we)
,.pf_ll_rdylst_hpnxt_bin2_wdata (pf_ll_rdylst_hpnxt_bin2_wdata)
,.pf_ll_rdylst_hpnxt_bin2_rdata (pf_ll_rdylst_hpnxt_bin2_rdata)

,.rf_ll_rdylst_hpnxt_bin2_rclk (rf_ll_rdylst_hpnxt_bin2_rclk)
,.rf_ll_rdylst_hpnxt_bin2_rclk_rst_n (rf_ll_rdylst_hpnxt_bin2_rclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin2_re    (rf_ll_rdylst_hpnxt_bin2_re)
,.rf_ll_rdylst_hpnxt_bin2_raddr (rf_ll_rdylst_hpnxt_bin2_raddr)
,.rf_ll_rdylst_hpnxt_bin2_waddr (rf_ll_rdylst_hpnxt_bin2_waddr)
,.rf_ll_rdylst_hpnxt_bin2_wclk (rf_ll_rdylst_hpnxt_bin2_wclk)
,.rf_ll_rdylst_hpnxt_bin2_wclk_rst_n (rf_ll_rdylst_hpnxt_bin2_wclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin2_we    (rf_ll_rdylst_hpnxt_bin2_we)
,.rf_ll_rdylst_hpnxt_bin2_wdata (rf_ll_rdylst_hpnxt_bin2_wdata)
,.rf_ll_rdylst_hpnxt_bin2_rdata (rf_ll_rdylst_hpnxt_bin2_rdata)

,.rf_ll_rdylst_hpnxt_bin2_error (rf_ll_rdylst_hpnxt_bin2_error)

,.func_ll_rdylst_hpnxt_bin3_re    (func_ll_rdylst_hpnxt_bin3_re)
,.func_ll_rdylst_hpnxt_bin3_raddr (func_ll_rdylst_hpnxt_bin3_raddr)
,.func_ll_rdylst_hpnxt_bin3_waddr (func_ll_rdylst_hpnxt_bin3_waddr)
,.func_ll_rdylst_hpnxt_bin3_we    (func_ll_rdylst_hpnxt_bin3_we)
,.func_ll_rdylst_hpnxt_bin3_wdata (func_ll_rdylst_hpnxt_bin3_wdata)
,.func_ll_rdylst_hpnxt_bin3_rdata (func_ll_rdylst_hpnxt_bin3_rdata)

,.pf_ll_rdylst_hpnxt_bin3_re      (pf_ll_rdylst_hpnxt_bin3_re)
,.pf_ll_rdylst_hpnxt_bin3_raddr (pf_ll_rdylst_hpnxt_bin3_raddr)
,.pf_ll_rdylst_hpnxt_bin3_waddr (pf_ll_rdylst_hpnxt_bin3_waddr)
,.pf_ll_rdylst_hpnxt_bin3_we    (pf_ll_rdylst_hpnxt_bin3_we)
,.pf_ll_rdylst_hpnxt_bin3_wdata (pf_ll_rdylst_hpnxt_bin3_wdata)
,.pf_ll_rdylst_hpnxt_bin3_rdata (pf_ll_rdylst_hpnxt_bin3_rdata)

,.rf_ll_rdylst_hpnxt_bin3_rclk (rf_ll_rdylst_hpnxt_bin3_rclk)
,.rf_ll_rdylst_hpnxt_bin3_rclk_rst_n (rf_ll_rdylst_hpnxt_bin3_rclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin3_re    (rf_ll_rdylst_hpnxt_bin3_re)
,.rf_ll_rdylst_hpnxt_bin3_raddr (rf_ll_rdylst_hpnxt_bin3_raddr)
,.rf_ll_rdylst_hpnxt_bin3_waddr (rf_ll_rdylst_hpnxt_bin3_waddr)
,.rf_ll_rdylst_hpnxt_bin3_wclk (rf_ll_rdylst_hpnxt_bin3_wclk)
,.rf_ll_rdylst_hpnxt_bin3_wclk_rst_n (rf_ll_rdylst_hpnxt_bin3_wclk_rst_n)
,.rf_ll_rdylst_hpnxt_bin3_we    (rf_ll_rdylst_hpnxt_bin3_we)
,.rf_ll_rdylst_hpnxt_bin3_wdata (rf_ll_rdylst_hpnxt_bin3_wdata)
,.rf_ll_rdylst_hpnxt_bin3_rdata (rf_ll_rdylst_hpnxt_bin3_rdata)

,.rf_ll_rdylst_hpnxt_bin3_error (rf_ll_rdylst_hpnxt_bin3_error)

,.func_ll_rdylst_tp_bin0_re    (func_ll_rdylst_tp_bin0_re)
,.func_ll_rdylst_tp_bin0_raddr (func_ll_rdylst_tp_bin0_raddr)
,.func_ll_rdylst_tp_bin0_waddr (func_ll_rdylst_tp_bin0_waddr)
,.func_ll_rdylst_tp_bin0_we    (func_ll_rdylst_tp_bin0_we)
,.func_ll_rdylst_tp_bin0_wdata (func_ll_rdylst_tp_bin0_wdata)
,.func_ll_rdylst_tp_bin0_rdata (func_ll_rdylst_tp_bin0_rdata)

,.pf_ll_rdylst_tp_bin0_re      (pf_ll_rdylst_tp_bin0_re)
,.pf_ll_rdylst_tp_bin0_raddr (pf_ll_rdylst_tp_bin0_raddr)
,.pf_ll_rdylst_tp_bin0_waddr (pf_ll_rdylst_tp_bin0_waddr)
,.pf_ll_rdylst_tp_bin0_we    (pf_ll_rdylst_tp_bin0_we)
,.pf_ll_rdylst_tp_bin0_wdata (pf_ll_rdylst_tp_bin0_wdata)
,.pf_ll_rdylst_tp_bin0_rdata (pf_ll_rdylst_tp_bin0_rdata)

,.rf_ll_rdylst_tp_bin0_rclk (rf_ll_rdylst_tp_bin0_rclk)
,.rf_ll_rdylst_tp_bin0_rclk_rst_n (rf_ll_rdylst_tp_bin0_rclk_rst_n)
,.rf_ll_rdylst_tp_bin0_re    (rf_ll_rdylst_tp_bin0_re)
,.rf_ll_rdylst_tp_bin0_raddr (rf_ll_rdylst_tp_bin0_raddr)
,.rf_ll_rdylst_tp_bin0_waddr (rf_ll_rdylst_tp_bin0_waddr)
,.rf_ll_rdylst_tp_bin0_wclk (rf_ll_rdylst_tp_bin0_wclk)
,.rf_ll_rdylst_tp_bin0_wclk_rst_n (rf_ll_rdylst_tp_bin0_wclk_rst_n)
,.rf_ll_rdylst_tp_bin0_we    (rf_ll_rdylst_tp_bin0_we)
,.rf_ll_rdylst_tp_bin0_wdata (rf_ll_rdylst_tp_bin0_wdata)
,.rf_ll_rdylst_tp_bin0_rdata (rf_ll_rdylst_tp_bin0_rdata)

,.rf_ll_rdylst_tp_bin0_error (rf_ll_rdylst_tp_bin0_error)

,.func_ll_rdylst_tp_bin1_re    (func_ll_rdylst_tp_bin1_re)
,.func_ll_rdylst_tp_bin1_raddr (func_ll_rdylst_tp_bin1_raddr)
,.func_ll_rdylst_tp_bin1_waddr (func_ll_rdylst_tp_bin1_waddr)
,.func_ll_rdylst_tp_bin1_we    (func_ll_rdylst_tp_bin1_we)
,.func_ll_rdylst_tp_bin1_wdata (func_ll_rdylst_tp_bin1_wdata)
,.func_ll_rdylst_tp_bin1_rdata (func_ll_rdylst_tp_bin1_rdata)

,.pf_ll_rdylst_tp_bin1_re      (pf_ll_rdylst_tp_bin1_re)
,.pf_ll_rdylst_tp_bin1_raddr (pf_ll_rdylst_tp_bin1_raddr)
,.pf_ll_rdylst_tp_bin1_waddr (pf_ll_rdylst_tp_bin1_waddr)
,.pf_ll_rdylst_tp_bin1_we    (pf_ll_rdylst_tp_bin1_we)
,.pf_ll_rdylst_tp_bin1_wdata (pf_ll_rdylst_tp_bin1_wdata)
,.pf_ll_rdylst_tp_bin1_rdata (pf_ll_rdylst_tp_bin1_rdata)

,.rf_ll_rdylst_tp_bin1_rclk (rf_ll_rdylst_tp_bin1_rclk)
,.rf_ll_rdylst_tp_bin1_rclk_rst_n (rf_ll_rdylst_tp_bin1_rclk_rst_n)
,.rf_ll_rdylst_tp_bin1_re    (rf_ll_rdylst_tp_bin1_re)
,.rf_ll_rdylst_tp_bin1_raddr (rf_ll_rdylst_tp_bin1_raddr)
,.rf_ll_rdylst_tp_bin1_waddr (rf_ll_rdylst_tp_bin1_waddr)
,.rf_ll_rdylst_tp_bin1_wclk (rf_ll_rdylst_tp_bin1_wclk)
,.rf_ll_rdylst_tp_bin1_wclk_rst_n (rf_ll_rdylst_tp_bin1_wclk_rst_n)
,.rf_ll_rdylst_tp_bin1_we    (rf_ll_rdylst_tp_bin1_we)
,.rf_ll_rdylst_tp_bin1_wdata (rf_ll_rdylst_tp_bin1_wdata)
,.rf_ll_rdylst_tp_bin1_rdata (rf_ll_rdylst_tp_bin1_rdata)

,.rf_ll_rdylst_tp_bin1_error (rf_ll_rdylst_tp_bin1_error)

,.func_ll_rdylst_tp_bin2_re    (func_ll_rdylst_tp_bin2_re)
,.func_ll_rdylst_tp_bin2_raddr (func_ll_rdylst_tp_bin2_raddr)
,.func_ll_rdylst_tp_bin2_waddr (func_ll_rdylst_tp_bin2_waddr)
,.func_ll_rdylst_tp_bin2_we    (func_ll_rdylst_tp_bin2_we)
,.func_ll_rdylst_tp_bin2_wdata (func_ll_rdylst_tp_bin2_wdata)
,.func_ll_rdylst_tp_bin2_rdata (func_ll_rdylst_tp_bin2_rdata)

,.pf_ll_rdylst_tp_bin2_re      (pf_ll_rdylst_tp_bin2_re)
,.pf_ll_rdylst_tp_bin2_raddr (pf_ll_rdylst_tp_bin2_raddr)
,.pf_ll_rdylst_tp_bin2_waddr (pf_ll_rdylst_tp_bin2_waddr)
,.pf_ll_rdylst_tp_bin2_we    (pf_ll_rdylst_tp_bin2_we)
,.pf_ll_rdylst_tp_bin2_wdata (pf_ll_rdylst_tp_bin2_wdata)
,.pf_ll_rdylst_tp_bin2_rdata (pf_ll_rdylst_tp_bin2_rdata)

,.rf_ll_rdylst_tp_bin2_rclk (rf_ll_rdylst_tp_bin2_rclk)
,.rf_ll_rdylst_tp_bin2_rclk_rst_n (rf_ll_rdylst_tp_bin2_rclk_rst_n)
,.rf_ll_rdylst_tp_bin2_re    (rf_ll_rdylst_tp_bin2_re)
,.rf_ll_rdylst_tp_bin2_raddr (rf_ll_rdylst_tp_bin2_raddr)
,.rf_ll_rdylst_tp_bin2_waddr (rf_ll_rdylst_tp_bin2_waddr)
,.rf_ll_rdylst_tp_bin2_wclk (rf_ll_rdylst_tp_bin2_wclk)
,.rf_ll_rdylst_tp_bin2_wclk_rst_n (rf_ll_rdylst_tp_bin2_wclk_rst_n)
,.rf_ll_rdylst_tp_bin2_we    (rf_ll_rdylst_tp_bin2_we)
,.rf_ll_rdylst_tp_bin2_wdata (rf_ll_rdylst_tp_bin2_wdata)
,.rf_ll_rdylst_tp_bin2_rdata (rf_ll_rdylst_tp_bin2_rdata)

,.rf_ll_rdylst_tp_bin2_error (rf_ll_rdylst_tp_bin2_error)

,.func_ll_rdylst_tp_bin3_re    (func_ll_rdylst_tp_bin3_re)
,.func_ll_rdylst_tp_bin3_raddr (func_ll_rdylst_tp_bin3_raddr)
,.func_ll_rdylst_tp_bin3_waddr (func_ll_rdylst_tp_bin3_waddr)
,.func_ll_rdylst_tp_bin3_we    (func_ll_rdylst_tp_bin3_we)
,.func_ll_rdylst_tp_bin3_wdata (func_ll_rdylst_tp_bin3_wdata)
,.func_ll_rdylst_tp_bin3_rdata (func_ll_rdylst_tp_bin3_rdata)

,.pf_ll_rdylst_tp_bin3_re      (pf_ll_rdylst_tp_bin3_re)
,.pf_ll_rdylst_tp_bin3_raddr (pf_ll_rdylst_tp_bin3_raddr)
,.pf_ll_rdylst_tp_bin3_waddr (pf_ll_rdylst_tp_bin3_waddr)
,.pf_ll_rdylst_tp_bin3_we    (pf_ll_rdylst_tp_bin3_we)
,.pf_ll_rdylst_tp_bin3_wdata (pf_ll_rdylst_tp_bin3_wdata)
,.pf_ll_rdylst_tp_bin3_rdata (pf_ll_rdylst_tp_bin3_rdata)

,.rf_ll_rdylst_tp_bin3_rclk (rf_ll_rdylst_tp_bin3_rclk)
,.rf_ll_rdylst_tp_bin3_rclk_rst_n (rf_ll_rdylst_tp_bin3_rclk_rst_n)
,.rf_ll_rdylst_tp_bin3_re    (rf_ll_rdylst_tp_bin3_re)
,.rf_ll_rdylst_tp_bin3_raddr (rf_ll_rdylst_tp_bin3_raddr)
,.rf_ll_rdylst_tp_bin3_waddr (rf_ll_rdylst_tp_bin3_waddr)
,.rf_ll_rdylst_tp_bin3_wclk (rf_ll_rdylst_tp_bin3_wclk)
,.rf_ll_rdylst_tp_bin3_wclk_rst_n (rf_ll_rdylst_tp_bin3_wclk_rst_n)
,.rf_ll_rdylst_tp_bin3_we    (rf_ll_rdylst_tp_bin3_we)
,.rf_ll_rdylst_tp_bin3_wdata (rf_ll_rdylst_tp_bin3_wdata)
,.rf_ll_rdylst_tp_bin3_rdata (rf_ll_rdylst_tp_bin3_rdata)

,.rf_ll_rdylst_tp_bin3_error (rf_ll_rdylst_tp_bin3_error)

,.func_ll_rlst_cnt_re    (func_ll_rlst_cnt_re)
,.func_ll_rlst_cnt_raddr (func_ll_rlst_cnt_raddr)
,.func_ll_rlst_cnt_waddr (func_ll_rlst_cnt_waddr)
,.func_ll_rlst_cnt_we    (func_ll_rlst_cnt_we)
,.func_ll_rlst_cnt_wdata (func_ll_rlst_cnt_wdata)
,.func_ll_rlst_cnt_rdata (func_ll_rlst_cnt_rdata)

,.pf_ll_rlst_cnt_re      (pf_ll_rlst_cnt_re)
,.pf_ll_rlst_cnt_raddr (pf_ll_rlst_cnt_raddr)
,.pf_ll_rlst_cnt_waddr (pf_ll_rlst_cnt_waddr)
,.pf_ll_rlst_cnt_we    (pf_ll_rlst_cnt_we)
,.pf_ll_rlst_cnt_wdata (pf_ll_rlst_cnt_wdata)
,.pf_ll_rlst_cnt_rdata (pf_ll_rlst_cnt_rdata)

,.rf_ll_rlst_cnt_rclk (rf_ll_rlst_cnt_rclk)
,.rf_ll_rlst_cnt_rclk_rst_n (rf_ll_rlst_cnt_rclk_rst_n)
,.rf_ll_rlst_cnt_re    (rf_ll_rlst_cnt_re)
,.rf_ll_rlst_cnt_raddr (rf_ll_rlst_cnt_raddr)
,.rf_ll_rlst_cnt_waddr (rf_ll_rlst_cnt_waddr)
,.rf_ll_rlst_cnt_wclk (rf_ll_rlst_cnt_wclk)
,.rf_ll_rlst_cnt_wclk_rst_n (rf_ll_rlst_cnt_wclk_rst_n)
,.rf_ll_rlst_cnt_we    (rf_ll_rlst_cnt_we)
,.rf_ll_rlst_cnt_wdata (rf_ll_rlst_cnt_wdata)
,.rf_ll_rlst_cnt_rdata (rf_ll_rlst_cnt_rdata)

,.rf_ll_rlst_cnt_error (rf_ll_rlst_cnt_error)

,.func_ll_sch_cnt_dup0_re    (func_ll_sch_cnt_dup0_re)
,.func_ll_sch_cnt_dup0_raddr (func_ll_sch_cnt_dup0_raddr)
,.func_ll_sch_cnt_dup0_waddr (func_ll_sch_cnt_dup0_waddr)
,.func_ll_sch_cnt_dup0_we    (func_ll_sch_cnt_dup0_we)
,.func_ll_sch_cnt_dup0_wdata (func_ll_sch_cnt_dup0_wdata)
,.func_ll_sch_cnt_dup0_rdata (func_ll_sch_cnt_dup0_rdata)

,.pf_ll_sch_cnt_dup0_re      (pf_ll_sch_cnt_dup0_re)
,.pf_ll_sch_cnt_dup0_raddr (pf_ll_sch_cnt_dup0_raddr)
,.pf_ll_sch_cnt_dup0_waddr (pf_ll_sch_cnt_dup0_waddr)
,.pf_ll_sch_cnt_dup0_we    (pf_ll_sch_cnt_dup0_we)
,.pf_ll_sch_cnt_dup0_wdata (pf_ll_sch_cnt_dup0_wdata)
,.pf_ll_sch_cnt_dup0_rdata (pf_ll_sch_cnt_dup0_rdata)

,.rf_ll_sch_cnt_dup0_rclk (rf_ll_sch_cnt_dup0_rclk)
,.rf_ll_sch_cnt_dup0_rclk_rst_n (rf_ll_sch_cnt_dup0_rclk_rst_n)
,.rf_ll_sch_cnt_dup0_re    (rf_ll_sch_cnt_dup0_re)
,.rf_ll_sch_cnt_dup0_raddr (rf_ll_sch_cnt_dup0_raddr)
,.rf_ll_sch_cnt_dup0_waddr (rf_ll_sch_cnt_dup0_waddr)
,.rf_ll_sch_cnt_dup0_wclk (rf_ll_sch_cnt_dup0_wclk)
,.rf_ll_sch_cnt_dup0_wclk_rst_n (rf_ll_sch_cnt_dup0_wclk_rst_n)
,.rf_ll_sch_cnt_dup0_we    (rf_ll_sch_cnt_dup0_we)
,.rf_ll_sch_cnt_dup0_wdata (rf_ll_sch_cnt_dup0_wdata)
,.rf_ll_sch_cnt_dup0_rdata (rf_ll_sch_cnt_dup0_rdata)

,.rf_ll_sch_cnt_dup0_error (rf_ll_sch_cnt_dup0_error)

,.func_ll_sch_cnt_dup1_re    (func_ll_sch_cnt_dup1_re)
,.func_ll_sch_cnt_dup1_raddr (func_ll_sch_cnt_dup1_raddr)
,.func_ll_sch_cnt_dup1_waddr (func_ll_sch_cnt_dup1_waddr)
,.func_ll_sch_cnt_dup1_we    (func_ll_sch_cnt_dup1_we)
,.func_ll_sch_cnt_dup1_wdata (func_ll_sch_cnt_dup1_wdata)
,.func_ll_sch_cnt_dup1_rdata (func_ll_sch_cnt_dup1_rdata)

,.pf_ll_sch_cnt_dup1_re      (pf_ll_sch_cnt_dup1_re)
,.pf_ll_sch_cnt_dup1_raddr (pf_ll_sch_cnt_dup1_raddr)
,.pf_ll_sch_cnt_dup1_waddr (pf_ll_sch_cnt_dup1_waddr)
,.pf_ll_sch_cnt_dup1_we    (pf_ll_sch_cnt_dup1_we)
,.pf_ll_sch_cnt_dup1_wdata (pf_ll_sch_cnt_dup1_wdata)
,.pf_ll_sch_cnt_dup1_rdata (pf_ll_sch_cnt_dup1_rdata)

,.rf_ll_sch_cnt_dup1_rclk (rf_ll_sch_cnt_dup1_rclk)
,.rf_ll_sch_cnt_dup1_rclk_rst_n (rf_ll_sch_cnt_dup1_rclk_rst_n)
,.rf_ll_sch_cnt_dup1_re    (rf_ll_sch_cnt_dup1_re)
,.rf_ll_sch_cnt_dup1_raddr (rf_ll_sch_cnt_dup1_raddr)
,.rf_ll_sch_cnt_dup1_waddr (rf_ll_sch_cnt_dup1_waddr)
,.rf_ll_sch_cnt_dup1_wclk (rf_ll_sch_cnt_dup1_wclk)
,.rf_ll_sch_cnt_dup1_wclk_rst_n (rf_ll_sch_cnt_dup1_wclk_rst_n)
,.rf_ll_sch_cnt_dup1_we    (rf_ll_sch_cnt_dup1_we)
,.rf_ll_sch_cnt_dup1_wdata (rf_ll_sch_cnt_dup1_wdata)
,.rf_ll_sch_cnt_dup1_rdata (rf_ll_sch_cnt_dup1_rdata)

,.rf_ll_sch_cnt_dup1_error (rf_ll_sch_cnt_dup1_error)

,.func_ll_sch_cnt_dup2_re    (func_ll_sch_cnt_dup2_re)
,.func_ll_sch_cnt_dup2_raddr (func_ll_sch_cnt_dup2_raddr)
,.func_ll_sch_cnt_dup2_waddr (func_ll_sch_cnt_dup2_waddr)
,.func_ll_sch_cnt_dup2_we    (func_ll_sch_cnt_dup2_we)
,.func_ll_sch_cnt_dup2_wdata (func_ll_sch_cnt_dup2_wdata)
,.func_ll_sch_cnt_dup2_rdata (func_ll_sch_cnt_dup2_rdata)

,.pf_ll_sch_cnt_dup2_re      (pf_ll_sch_cnt_dup2_re)
,.pf_ll_sch_cnt_dup2_raddr (pf_ll_sch_cnt_dup2_raddr)
,.pf_ll_sch_cnt_dup2_waddr (pf_ll_sch_cnt_dup2_waddr)
,.pf_ll_sch_cnt_dup2_we    (pf_ll_sch_cnt_dup2_we)
,.pf_ll_sch_cnt_dup2_wdata (pf_ll_sch_cnt_dup2_wdata)
,.pf_ll_sch_cnt_dup2_rdata (pf_ll_sch_cnt_dup2_rdata)

,.rf_ll_sch_cnt_dup2_rclk (rf_ll_sch_cnt_dup2_rclk)
,.rf_ll_sch_cnt_dup2_rclk_rst_n (rf_ll_sch_cnt_dup2_rclk_rst_n)
,.rf_ll_sch_cnt_dup2_re    (rf_ll_sch_cnt_dup2_re)
,.rf_ll_sch_cnt_dup2_raddr (rf_ll_sch_cnt_dup2_raddr)
,.rf_ll_sch_cnt_dup2_waddr (rf_ll_sch_cnt_dup2_waddr)
,.rf_ll_sch_cnt_dup2_wclk (rf_ll_sch_cnt_dup2_wclk)
,.rf_ll_sch_cnt_dup2_wclk_rst_n (rf_ll_sch_cnt_dup2_wclk_rst_n)
,.rf_ll_sch_cnt_dup2_we    (rf_ll_sch_cnt_dup2_we)
,.rf_ll_sch_cnt_dup2_wdata (rf_ll_sch_cnt_dup2_wdata)
,.rf_ll_sch_cnt_dup2_rdata (rf_ll_sch_cnt_dup2_rdata)

,.rf_ll_sch_cnt_dup2_error (rf_ll_sch_cnt_dup2_error)

,.func_ll_sch_cnt_dup3_re    (func_ll_sch_cnt_dup3_re)
,.func_ll_sch_cnt_dup3_raddr (func_ll_sch_cnt_dup3_raddr)
,.func_ll_sch_cnt_dup3_waddr (func_ll_sch_cnt_dup3_waddr)
,.func_ll_sch_cnt_dup3_we    (func_ll_sch_cnt_dup3_we)
,.func_ll_sch_cnt_dup3_wdata (func_ll_sch_cnt_dup3_wdata)
,.func_ll_sch_cnt_dup3_rdata (func_ll_sch_cnt_dup3_rdata)

,.pf_ll_sch_cnt_dup3_re      (pf_ll_sch_cnt_dup3_re)
,.pf_ll_sch_cnt_dup3_raddr (pf_ll_sch_cnt_dup3_raddr)
,.pf_ll_sch_cnt_dup3_waddr (pf_ll_sch_cnt_dup3_waddr)
,.pf_ll_sch_cnt_dup3_we    (pf_ll_sch_cnt_dup3_we)
,.pf_ll_sch_cnt_dup3_wdata (pf_ll_sch_cnt_dup3_wdata)
,.pf_ll_sch_cnt_dup3_rdata (pf_ll_sch_cnt_dup3_rdata)

,.rf_ll_sch_cnt_dup3_rclk (rf_ll_sch_cnt_dup3_rclk)
,.rf_ll_sch_cnt_dup3_rclk_rst_n (rf_ll_sch_cnt_dup3_rclk_rst_n)
,.rf_ll_sch_cnt_dup3_re    (rf_ll_sch_cnt_dup3_re)
,.rf_ll_sch_cnt_dup3_raddr (rf_ll_sch_cnt_dup3_raddr)
,.rf_ll_sch_cnt_dup3_waddr (rf_ll_sch_cnt_dup3_waddr)
,.rf_ll_sch_cnt_dup3_wclk (rf_ll_sch_cnt_dup3_wclk)
,.rf_ll_sch_cnt_dup3_wclk_rst_n (rf_ll_sch_cnt_dup3_wclk_rst_n)
,.rf_ll_sch_cnt_dup3_we    (rf_ll_sch_cnt_dup3_we)
,.rf_ll_sch_cnt_dup3_wdata (rf_ll_sch_cnt_dup3_wdata)
,.rf_ll_sch_cnt_dup3_rdata (rf_ll_sch_cnt_dup3_rdata)

,.rf_ll_sch_cnt_dup3_error (rf_ll_sch_cnt_dup3_error)

,.func_ll_schlst_hp_bin0_re    (func_ll_schlst_hp_bin0_re)
,.func_ll_schlst_hp_bin0_raddr (func_ll_schlst_hp_bin0_raddr)
,.func_ll_schlst_hp_bin0_waddr (func_ll_schlst_hp_bin0_waddr)
,.func_ll_schlst_hp_bin0_we    (func_ll_schlst_hp_bin0_we)
,.func_ll_schlst_hp_bin0_wdata (func_ll_schlst_hp_bin0_wdata)
,.func_ll_schlst_hp_bin0_rdata (func_ll_schlst_hp_bin0_rdata)

,.pf_ll_schlst_hp_bin0_re      (pf_ll_schlst_hp_bin0_re)
,.pf_ll_schlst_hp_bin0_raddr (pf_ll_schlst_hp_bin0_raddr)
,.pf_ll_schlst_hp_bin0_waddr (pf_ll_schlst_hp_bin0_waddr)
,.pf_ll_schlst_hp_bin0_we    (pf_ll_schlst_hp_bin0_we)
,.pf_ll_schlst_hp_bin0_wdata (pf_ll_schlst_hp_bin0_wdata)
,.pf_ll_schlst_hp_bin0_rdata (pf_ll_schlst_hp_bin0_rdata)

,.rf_ll_schlst_hp_bin0_rclk (rf_ll_schlst_hp_bin0_rclk)
,.rf_ll_schlst_hp_bin0_rclk_rst_n (rf_ll_schlst_hp_bin0_rclk_rst_n)
,.rf_ll_schlst_hp_bin0_re    (rf_ll_schlst_hp_bin0_re)
,.rf_ll_schlst_hp_bin0_raddr (rf_ll_schlst_hp_bin0_raddr)
,.rf_ll_schlst_hp_bin0_waddr (rf_ll_schlst_hp_bin0_waddr)
,.rf_ll_schlst_hp_bin0_wclk (rf_ll_schlst_hp_bin0_wclk)
,.rf_ll_schlst_hp_bin0_wclk_rst_n (rf_ll_schlst_hp_bin0_wclk_rst_n)
,.rf_ll_schlst_hp_bin0_we    (rf_ll_schlst_hp_bin0_we)
,.rf_ll_schlst_hp_bin0_wdata (rf_ll_schlst_hp_bin0_wdata)
,.rf_ll_schlst_hp_bin0_rdata (rf_ll_schlst_hp_bin0_rdata)

,.rf_ll_schlst_hp_bin0_error (rf_ll_schlst_hp_bin0_error)

,.func_ll_schlst_hp_bin1_re    (func_ll_schlst_hp_bin1_re)
,.func_ll_schlst_hp_bin1_raddr (func_ll_schlst_hp_bin1_raddr)
,.func_ll_schlst_hp_bin1_waddr (func_ll_schlst_hp_bin1_waddr)
,.func_ll_schlst_hp_bin1_we    (func_ll_schlst_hp_bin1_we)
,.func_ll_schlst_hp_bin1_wdata (func_ll_schlst_hp_bin1_wdata)
,.func_ll_schlst_hp_bin1_rdata (func_ll_schlst_hp_bin1_rdata)

,.pf_ll_schlst_hp_bin1_re      (pf_ll_schlst_hp_bin1_re)
,.pf_ll_schlst_hp_bin1_raddr (pf_ll_schlst_hp_bin1_raddr)
,.pf_ll_schlst_hp_bin1_waddr (pf_ll_schlst_hp_bin1_waddr)
,.pf_ll_schlst_hp_bin1_we    (pf_ll_schlst_hp_bin1_we)
,.pf_ll_schlst_hp_bin1_wdata (pf_ll_schlst_hp_bin1_wdata)
,.pf_ll_schlst_hp_bin1_rdata (pf_ll_schlst_hp_bin1_rdata)

,.rf_ll_schlst_hp_bin1_rclk (rf_ll_schlst_hp_bin1_rclk)
,.rf_ll_schlst_hp_bin1_rclk_rst_n (rf_ll_schlst_hp_bin1_rclk_rst_n)
,.rf_ll_schlst_hp_bin1_re    (rf_ll_schlst_hp_bin1_re)
,.rf_ll_schlst_hp_bin1_raddr (rf_ll_schlst_hp_bin1_raddr)
,.rf_ll_schlst_hp_bin1_waddr (rf_ll_schlst_hp_bin1_waddr)
,.rf_ll_schlst_hp_bin1_wclk (rf_ll_schlst_hp_bin1_wclk)
,.rf_ll_schlst_hp_bin1_wclk_rst_n (rf_ll_schlst_hp_bin1_wclk_rst_n)
,.rf_ll_schlst_hp_bin1_we    (rf_ll_schlst_hp_bin1_we)
,.rf_ll_schlst_hp_bin1_wdata (rf_ll_schlst_hp_bin1_wdata)
,.rf_ll_schlst_hp_bin1_rdata (rf_ll_schlst_hp_bin1_rdata)

,.rf_ll_schlst_hp_bin1_error (rf_ll_schlst_hp_bin1_error)

,.func_ll_schlst_hp_bin2_re    (func_ll_schlst_hp_bin2_re)
,.func_ll_schlst_hp_bin2_raddr (func_ll_schlst_hp_bin2_raddr)
,.func_ll_schlst_hp_bin2_waddr (func_ll_schlst_hp_bin2_waddr)
,.func_ll_schlst_hp_bin2_we    (func_ll_schlst_hp_bin2_we)
,.func_ll_schlst_hp_bin2_wdata (func_ll_schlst_hp_bin2_wdata)
,.func_ll_schlst_hp_bin2_rdata (func_ll_schlst_hp_bin2_rdata)

,.pf_ll_schlst_hp_bin2_re      (pf_ll_schlst_hp_bin2_re)
,.pf_ll_schlst_hp_bin2_raddr (pf_ll_schlst_hp_bin2_raddr)
,.pf_ll_schlst_hp_bin2_waddr (pf_ll_schlst_hp_bin2_waddr)
,.pf_ll_schlst_hp_bin2_we    (pf_ll_schlst_hp_bin2_we)
,.pf_ll_schlst_hp_bin2_wdata (pf_ll_schlst_hp_bin2_wdata)
,.pf_ll_schlst_hp_bin2_rdata (pf_ll_schlst_hp_bin2_rdata)

,.rf_ll_schlst_hp_bin2_rclk (rf_ll_schlst_hp_bin2_rclk)
,.rf_ll_schlst_hp_bin2_rclk_rst_n (rf_ll_schlst_hp_bin2_rclk_rst_n)
,.rf_ll_schlst_hp_bin2_re    (rf_ll_schlst_hp_bin2_re)
,.rf_ll_schlst_hp_bin2_raddr (rf_ll_schlst_hp_bin2_raddr)
,.rf_ll_schlst_hp_bin2_waddr (rf_ll_schlst_hp_bin2_waddr)
,.rf_ll_schlst_hp_bin2_wclk (rf_ll_schlst_hp_bin2_wclk)
,.rf_ll_schlst_hp_bin2_wclk_rst_n (rf_ll_schlst_hp_bin2_wclk_rst_n)
,.rf_ll_schlst_hp_bin2_we    (rf_ll_schlst_hp_bin2_we)
,.rf_ll_schlst_hp_bin2_wdata (rf_ll_schlst_hp_bin2_wdata)
,.rf_ll_schlst_hp_bin2_rdata (rf_ll_schlst_hp_bin2_rdata)

,.rf_ll_schlst_hp_bin2_error (rf_ll_schlst_hp_bin2_error)

,.func_ll_schlst_hp_bin3_re    (func_ll_schlst_hp_bin3_re)
,.func_ll_schlst_hp_bin3_raddr (func_ll_schlst_hp_bin3_raddr)
,.func_ll_schlst_hp_bin3_waddr (func_ll_schlst_hp_bin3_waddr)
,.func_ll_schlst_hp_bin3_we    (func_ll_schlst_hp_bin3_we)
,.func_ll_schlst_hp_bin3_wdata (func_ll_schlst_hp_bin3_wdata)
,.func_ll_schlst_hp_bin3_rdata (func_ll_schlst_hp_bin3_rdata)

,.pf_ll_schlst_hp_bin3_re      (pf_ll_schlst_hp_bin3_re)
,.pf_ll_schlst_hp_bin3_raddr (pf_ll_schlst_hp_bin3_raddr)
,.pf_ll_schlst_hp_bin3_waddr (pf_ll_schlst_hp_bin3_waddr)
,.pf_ll_schlst_hp_bin3_we    (pf_ll_schlst_hp_bin3_we)
,.pf_ll_schlst_hp_bin3_wdata (pf_ll_schlst_hp_bin3_wdata)
,.pf_ll_schlst_hp_bin3_rdata (pf_ll_schlst_hp_bin3_rdata)

,.rf_ll_schlst_hp_bin3_rclk (rf_ll_schlst_hp_bin3_rclk)
,.rf_ll_schlst_hp_bin3_rclk_rst_n (rf_ll_schlst_hp_bin3_rclk_rst_n)
,.rf_ll_schlst_hp_bin3_re    (rf_ll_schlst_hp_bin3_re)
,.rf_ll_schlst_hp_bin3_raddr (rf_ll_schlst_hp_bin3_raddr)
,.rf_ll_schlst_hp_bin3_waddr (rf_ll_schlst_hp_bin3_waddr)
,.rf_ll_schlst_hp_bin3_wclk (rf_ll_schlst_hp_bin3_wclk)
,.rf_ll_schlst_hp_bin3_wclk_rst_n (rf_ll_schlst_hp_bin3_wclk_rst_n)
,.rf_ll_schlst_hp_bin3_we    (rf_ll_schlst_hp_bin3_we)
,.rf_ll_schlst_hp_bin3_wdata (rf_ll_schlst_hp_bin3_wdata)
,.rf_ll_schlst_hp_bin3_rdata (rf_ll_schlst_hp_bin3_rdata)

,.rf_ll_schlst_hp_bin3_error (rf_ll_schlst_hp_bin3_error)

,.func_ll_schlst_hpnxt_bin0_re    (func_ll_schlst_hpnxt_bin0_re)
,.func_ll_schlst_hpnxt_bin0_raddr (func_ll_schlst_hpnxt_bin0_raddr)
,.func_ll_schlst_hpnxt_bin0_waddr (func_ll_schlst_hpnxt_bin0_waddr)
,.func_ll_schlst_hpnxt_bin0_we    (func_ll_schlst_hpnxt_bin0_we)
,.func_ll_schlst_hpnxt_bin0_wdata (func_ll_schlst_hpnxt_bin0_wdata)
,.func_ll_schlst_hpnxt_bin0_rdata (func_ll_schlst_hpnxt_bin0_rdata)

,.pf_ll_schlst_hpnxt_bin0_re      (pf_ll_schlst_hpnxt_bin0_re)
,.pf_ll_schlst_hpnxt_bin0_raddr (pf_ll_schlst_hpnxt_bin0_raddr)
,.pf_ll_schlst_hpnxt_bin0_waddr (pf_ll_schlst_hpnxt_bin0_waddr)
,.pf_ll_schlst_hpnxt_bin0_we    (pf_ll_schlst_hpnxt_bin0_we)
,.pf_ll_schlst_hpnxt_bin0_wdata (pf_ll_schlst_hpnxt_bin0_wdata)
,.pf_ll_schlst_hpnxt_bin0_rdata (pf_ll_schlst_hpnxt_bin0_rdata)

,.rf_ll_schlst_hpnxt_bin0_rclk (rf_ll_schlst_hpnxt_bin0_rclk)
,.rf_ll_schlst_hpnxt_bin0_rclk_rst_n (rf_ll_schlst_hpnxt_bin0_rclk_rst_n)
,.rf_ll_schlst_hpnxt_bin0_re    (rf_ll_schlst_hpnxt_bin0_re)
,.rf_ll_schlst_hpnxt_bin0_raddr (rf_ll_schlst_hpnxt_bin0_raddr)
,.rf_ll_schlst_hpnxt_bin0_waddr (rf_ll_schlst_hpnxt_bin0_waddr)
,.rf_ll_schlst_hpnxt_bin0_wclk (rf_ll_schlst_hpnxt_bin0_wclk)
,.rf_ll_schlst_hpnxt_bin0_wclk_rst_n (rf_ll_schlst_hpnxt_bin0_wclk_rst_n)
,.rf_ll_schlst_hpnxt_bin0_we    (rf_ll_schlst_hpnxt_bin0_we)
,.rf_ll_schlst_hpnxt_bin0_wdata (rf_ll_schlst_hpnxt_bin0_wdata)
,.rf_ll_schlst_hpnxt_bin0_rdata (rf_ll_schlst_hpnxt_bin0_rdata)

,.rf_ll_schlst_hpnxt_bin0_error (rf_ll_schlst_hpnxt_bin0_error)

,.func_ll_schlst_hpnxt_bin1_re    (func_ll_schlst_hpnxt_bin1_re)
,.func_ll_schlst_hpnxt_bin1_raddr (func_ll_schlst_hpnxt_bin1_raddr)
,.func_ll_schlst_hpnxt_bin1_waddr (func_ll_schlst_hpnxt_bin1_waddr)
,.func_ll_schlst_hpnxt_bin1_we    (func_ll_schlst_hpnxt_bin1_we)
,.func_ll_schlst_hpnxt_bin1_wdata (func_ll_schlst_hpnxt_bin1_wdata)
,.func_ll_schlst_hpnxt_bin1_rdata (func_ll_schlst_hpnxt_bin1_rdata)

,.pf_ll_schlst_hpnxt_bin1_re      (pf_ll_schlst_hpnxt_bin1_re)
,.pf_ll_schlst_hpnxt_bin1_raddr (pf_ll_schlst_hpnxt_bin1_raddr)
,.pf_ll_schlst_hpnxt_bin1_waddr (pf_ll_schlst_hpnxt_bin1_waddr)
,.pf_ll_schlst_hpnxt_bin1_we    (pf_ll_schlst_hpnxt_bin1_we)
,.pf_ll_schlst_hpnxt_bin1_wdata (pf_ll_schlst_hpnxt_bin1_wdata)
,.pf_ll_schlst_hpnxt_bin1_rdata (pf_ll_schlst_hpnxt_bin1_rdata)

,.rf_ll_schlst_hpnxt_bin1_rclk (rf_ll_schlst_hpnxt_bin1_rclk)
,.rf_ll_schlst_hpnxt_bin1_rclk_rst_n (rf_ll_schlst_hpnxt_bin1_rclk_rst_n)
,.rf_ll_schlst_hpnxt_bin1_re    (rf_ll_schlst_hpnxt_bin1_re)
,.rf_ll_schlst_hpnxt_bin1_raddr (rf_ll_schlst_hpnxt_bin1_raddr)
,.rf_ll_schlst_hpnxt_bin1_waddr (rf_ll_schlst_hpnxt_bin1_waddr)
,.rf_ll_schlst_hpnxt_bin1_wclk (rf_ll_schlst_hpnxt_bin1_wclk)
,.rf_ll_schlst_hpnxt_bin1_wclk_rst_n (rf_ll_schlst_hpnxt_bin1_wclk_rst_n)
,.rf_ll_schlst_hpnxt_bin1_we    (rf_ll_schlst_hpnxt_bin1_we)
,.rf_ll_schlst_hpnxt_bin1_wdata (rf_ll_schlst_hpnxt_bin1_wdata)
,.rf_ll_schlst_hpnxt_bin1_rdata (rf_ll_schlst_hpnxt_bin1_rdata)

,.rf_ll_schlst_hpnxt_bin1_error (rf_ll_schlst_hpnxt_bin1_error)

,.func_ll_schlst_hpnxt_bin2_re    (func_ll_schlst_hpnxt_bin2_re)
,.func_ll_schlst_hpnxt_bin2_raddr (func_ll_schlst_hpnxt_bin2_raddr)
,.func_ll_schlst_hpnxt_bin2_waddr (func_ll_schlst_hpnxt_bin2_waddr)
,.func_ll_schlst_hpnxt_bin2_we    (func_ll_schlst_hpnxt_bin2_we)
,.func_ll_schlst_hpnxt_bin2_wdata (func_ll_schlst_hpnxt_bin2_wdata)
,.func_ll_schlst_hpnxt_bin2_rdata (func_ll_schlst_hpnxt_bin2_rdata)

,.pf_ll_schlst_hpnxt_bin2_re      (pf_ll_schlst_hpnxt_bin2_re)
,.pf_ll_schlst_hpnxt_bin2_raddr (pf_ll_schlst_hpnxt_bin2_raddr)
,.pf_ll_schlst_hpnxt_bin2_waddr (pf_ll_schlst_hpnxt_bin2_waddr)
,.pf_ll_schlst_hpnxt_bin2_we    (pf_ll_schlst_hpnxt_bin2_we)
,.pf_ll_schlst_hpnxt_bin2_wdata (pf_ll_schlst_hpnxt_bin2_wdata)
,.pf_ll_schlst_hpnxt_bin2_rdata (pf_ll_schlst_hpnxt_bin2_rdata)

,.rf_ll_schlst_hpnxt_bin2_rclk (rf_ll_schlst_hpnxt_bin2_rclk)
,.rf_ll_schlst_hpnxt_bin2_rclk_rst_n (rf_ll_schlst_hpnxt_bin2_rclk_rst_n)
,.rf_ll_schlst_hpnxt_bin2_re    (rf_ll_schlst_hpnxt_bin2_re)
,.rf_ll_schlst_hpnxt_bin2_raddr (rf_ll_schlst_hpnxt_bin2_raddr)
,.rf_ll_schlst_hpnxt_bin2_waddr (rf_ll_schlst_hpnxt_bin2_waddr)
,.rf_ll_schlst_hpnxt_bin2_wclk (rf_ll_schlst_hpnxt_bin2_wclk)
,.rf_ll_schlst_hpnxt_bin2_wclk_rst_n (rf_ll_schlst_hpnxt_bin2_wclk_rst_n)
,.rf_ll_schlst_hpnxt_bin2_we    (rf_ll_schlst_hpnxt_bin2_we)
,.rf_ll_schlst_hpnxt_bin2_wdata (rf_ll_schlst_hpnxt_bin2_wdata)
,.rf_ll_schlst_hpnxt_bin2_rdata (rf_ll_schlst_hpnxt_bin2_rdata)

,.rf_ll_schlst_hpnxt_bin2_error (rf_ll_schlst_hpnxt_bin2_error)

,.func_ll_schlst_hpnxt_bin3_re    (func_ll_schlst_hpnxt_bin3_re)
,.func_ll_schlst_hpnxt_bin3_raddr (func_ll_schlst_hpnxt_bin3_raddr)
,.func_ll_schlst_hpnxt_bin3_waddr (func_ll_schlst_hpnxt_bin3_waddr)
,.func_ll_schlst_hpnxt_bin3_we    (func_ll_schlst_hpnxt_bin3_we)
,.func_ll_schlst_hpnxt_bin3_wdata (func_ll_schlst_hpnxt_bin3_wdata)
,.func_ll_schlst_hpnxt_bin3_rdata (func_ll_schlst_hpnxt_bin3_rdata)

,.pf_ll_schlst_hpnxt_bin3_re      (pf_ll_schlst_hpnxt_bin3_re)
,.pf_ll_schlst_hpnxt_bin3_raddr (pf_ll_schlst_hpnxt_bin3_raddr)
,.pf_ll_schlst_hpnxt_bin3_waddr (pf_ll_schlst_hpnxt_bin3_waddr)
,.pf_ll_schlst_hpnxt_bin3_we    (pf_ll_schlst_hpnxt_bin3_we)
,.pf_ll_schlst_hpnxt_bin3_wdata (pf_ll_schlst_hpnxt_bin3_wdata)
,.pf_ll_schlst_hpnxt_bin3_rdata (pf_ll_schlst_hpnxt_bin3_rdata)

,.rf_ll_schlst_hpnxt_bin3_rclk (rf_ll_schlst_hpnxt_bin3_rclk)
,.rf_ll_schlst_hpnxt_bin3_rclk_rst_n (rf_ll_schlst_hpnxt_bin3_rclk_rst_n)
,.rf_ll_schlst_hpnxt_bin3_re    (rf_ll_schlst_hpnxt_bin3_re)
,.rf_ll_schlst_hpnxt_bin3_raddr (rf_ll_schlst_hpnxt_bin3_raddr)
,.rf_ll_schlst_hpnxt_bin3_waddr (rf_ll_schlst_hpnxt_bin3_waddr)
,.rf_ll_schlst_hpnxt_bin3_wclk (rf_ll_schlst_hpnxt_bin3_wclk)
,.rf_ll_schlst_hpnxt_bin3_wclk_rst_n (rf_ll_schlst_hpnxt_bin3_wclk_rst_n)
,.rf_ll_schlst_hpnxt_bin3_we    (rf_ll_schlst_hpnxt_bin3_we)
,.rf_ll_schlst_hpnxt_bin3_wdata (rf_ll_schlst_hpnxt_bin3_wdata)
,.rf_ll_schlst_hpnxt_bin3_rdata (rf_ll_schlst_hpnxt_bin3_rdata)

,.rf_ll_schlst_hpnxt_bin3_error (rf_ll_schlst_hpnxt_bin3_error)

,.func_ll_schlst_tp_bin0_re    (func_ll_schlst_tp_bin0_re)
,.func_ll_schlst_tp_bin0_raddr (func_ll_schlst_tp_bin0_raddr)
,.func_ll_schlst_tp_bin0_waddr (func_ll_schlst_tp_bin0_waddr)
,.func_ll_schlst_tp_bin0_we    (func_ll_schlst_tp_bin0_we)
,.func_ll_schlst_tp_bin0_wdata (func_ll_schlst_tp_bin0_wdata)
,.func_ll_schlst_tp_bin0_rdata (func_ll_schlst_tp_bin0_rdata)

,.pf_ll_schlst_tp_bin0_re      (pf_ll_schlst_tp_bin0_re)
,.pf_ll_schlst_tp_bin0_raddr (pf_ll_schlst_tp_bin0_raddr)
,.pf_ll_schlst_tp_bin0_waddr (pf_ll_schlst_tp_bin0_waddr)
,.pf_ll_schlst_tp_bin0_we    (pf_ll_schlst_tp_bin0_we)
,.pf_ll_schlst_tp_bin0_wdata (pf_ll_schlst_tp_bin0_wdata)
,.pf_ll_schlst_tp_bin0_rdata (pf_ll_schlst_tp_bin0_rdata)

,.rf_ll_schlst_tp_bin0_rclk (rf_ll_schlst_tp_bin0_rclk)
,.rf_ll_schlst_tp_bin0_rclk_rst_n (rf_ll_schlst_tp_bin0_rclk_rst_n)
,.rf_ll_schlst_tp_bin0_re    (rf_ll_schlst_tp_bin0_re)
,.rf_ll_schlst_tp_bin0_raddr (rf_ll_schlst_tp_bin0_raddr)
,.rf_ll_schlst_tp_bin0_waddr (rf_ll_schlst_tp_bin0_waddr)
,.rf_ll_schlst_tp_bin0_wclk (rf_ll_schlst_tp_bin0_wclk)
,.rf_ll_schlst_tp_bin0_wclk_rst_n (rf_ll_schlst_tp_bin0_wclk_rst_n)
,.rf_ll_schlst_tp_bin0_we    (rf_ll_schlst_tp_bin0_we)
,.rf_ll_schlst_tp_bin0_wdata (rf_ll_schlst_tp_bin0_wdata)
,.rf_ll_schlst_tp_bin0_rdata (rf_ll_schlst_tp_bin0_rdata)

,.rf_ll_schlst_tp_bin0_error (rf_ll_schlst_tp_bin0_error)

,.func_ll_schlst_tp_bin1_re    (func_ll_schlst_tp_bin1_re)
,.func_ll_schlst_tp_bin1_raddr (func_ll_schlst_tp_bin1_raddr)
,.func_ll_schlst_tp_bin1_waddr (func_ll_schlst_tp_bin1_waddr)
,.func_ll_schlst_tp_bin1_we    (func_ll_schlst_tp_bin1_we)
,.func_ll_schlst_tp_bin1_wdata (func_ll_schlst_tp_bin1_wdata)
,.func_ll_schlst_tp_bin1_rdata (func_ll_schlst_tp_bin1_rdata)

,.pf_ll_schlst_tp_bin1_re      (pf_ll_schlst_tp_bin1_re)
,.pf_ll_schlst_tp_bin1_raddr (pf_ll_schlst_tp_bin1_raddr)
,.pf_ll_schlst_tp_bin1_waddr (pf_ll_schlst_tp_bin1_waddr)
,.pf_ll_schlst_tp_bin1_we    (pf_ll_schlst_tp_bin1_we)
,.pf_ll_schlst_tp_bin1_wdata (pf_ll_schlst_tp_bin1_wdata)
,.pf_ll_schlst_tp_bin1_rdata (pf_ll_schlst_tp_bin1_rdata)

,.rf_ll_schlst_tp_bin1_rclk (rf_ll_schlst_tp_bin1_rclk)
,.rf_ll_schlst_tp_bin1_rclk_rst_n (rf_ll_schlst_tp_bin1_rclk_rst_n)
,.rf_ll_schlst_tp_bin1_re    (rf_ll_schlst_tp_bin1_re)
,.rf_ll_schlst_tp_bin1_raddr (rf_ll_schlst_tp_bin1_raddr)
,.rf_ll_schlst_tp_bin1_waddr (rf_ll_schlst_tp_bin1_waddr)
,.rf_ll_schlst_tp_bin1_wclk (rf_ll_schlst_tp_bin1_wclk)
,.rf_ll_schlst_tp_bin1_wclk_rst_n (rf_ll_schlst_tp_bin1_wclk_rst_n)
,.rf_ll_schlst_tp_bin1_we    (rf_ll_schlst_tp_bin1_we)
,.rf_ll_schlst_tp_bin1_wdata (rf_ll_schlst_tp_bin1_wdata)
,.rf_ll_schlst_tp_bin1_rdata (rf_ll_schlst_tp_bin1_rdata)

,.rf_ll_schlst_tp_bin1_error (rf_ll_schlst_tp_bin1_error)

,.func_ll_schlst_tp_bin2_re    (func_ll_schlst_tp_bin2_re)
,.func_ll_schlst_tp_bin2_raddr (func_ll_schlst_tp_bin2_raddr)
,.func_ll_schlst_tp_bin2_waddr (func_ll_schlst_tp_bin2_waddr)
,.func_ll_schlst_tp_bin2_we    (func_ll_schlst_tp_bin2_we)
,.func_ll_schlst_tp_bin2_wdata (func_ll_schlst_tp_bin2_wdata)
,.func_ll_schlst_tp_bin2_rdata (func_ll_schlst_tp_bin2_rdata)

,.pf_ll_schlst_tp_bin2_re      (pf_ll_schlst_tp_bin2_re)
,.pf_ll_schlst_tp_bin2_raddr (pf_ll_schlst_tp_bin2_raddr)
,.pf_ll_schlst_tp_bin2_waddr (pf_ll_schlst_tp_bin2_waddr)
,.pf_ll_schlst_tp_bin2_we    (pf_ll_schlst_tp_bin2_we)
,.pf_ll_schlst_tp_bin2_wdata (pf_ll_schlst_tp_bin2_wdata)
,.pf_ll_schlst_tp_bin2_rdata (pf_ll_schlst_tp_bin2_rdata)

,.rf_ll_schlst_tp_bin2_rclk (rf_ll_schlst_tp_bin2_rclk)
,.rf_ll_schlst_tp_bin2_rclk_rst_n (rf_ll_schlst_tp_bin2_rclk_rst_n)
,.rf_ll_schlst_tp_bin2_re    (rf_ll_schlst_tp_bin2_re)
,.rf_ll_schlst_tp_bin2_raddr (rf_ll_schlst_tp_bin2_raddr)
,.rf_ll_schlst_tp_bin2_waddr (rf_ll_schlst_tp_bin2_waddr)
,.rf_ll_schlst_tp_bin2_wclk (rf_ll_schlst_tp_bin2_wclk)
,.rf_ll_schlst_tp_bin2_wclk_rst_n (rf_ll_schlst_tp_bin2_wclk_rst_n)
,.rf_ll_schlst_tp_bin2_we    (rf_ll_schlst_tp_bin2_we)
,.rf_ll_schlst_tp_bin2_wdata (rf_ll_schlst_tp_bin2_wdata)
,.rf_ll_schlst_tp_bin2_rdata (rf_ll_schlst_tp_bin2_rdata)

,.rf_ll_schlst_tp_bin2_error (rf_ll_schlst_tp_bin2_error)

,.func_ll_schlst_tp_bin3_re    (func_ll_schlst_tp_bin3_re)
,.func_ll_schlst_tp_bin3_raddr (func_ll_schlst_tp_bin3_raddr)
,.func_ll_schlst_tp_bin3_waddr (func_ll_schlst_tp_bin3_waddr)
,.func_ll_schlst_tp_bin3_we    (func_ll_schlst_tp_bin3_we)
,.func_ll_schlst_tp_bin3_wdata (func_ll_schlst_tp_bin3_wdata)
,.func_ll_schlst_tp_bin3_rdata (func_ll_schlst_tp_bin3_rdata)

,.pf_ll_schlst_tp_bin3_re      (pf_ll_schlst_tp_bin3_re)
,.pf_ll_schlst_tp_bin3_raddr (pf_ll_schlst_tp_bin3_raddr)
,.pf_ll_schlst_tp_bin3_waddr (pf_ll_schlst_tp_bin3_waddr)
,.pf_ll_schlst_tp_bin3_we    (pf_ll_schlst_tp_bin3_we)
,.pf_ll_schlst_tp_bin3_wdata (pf_ll_schlst_tp_bin3_wdata)
,.pf_ll_schlst_tp_bin3_rdata (pf_ll_schlst_tp_bin3_rdata)

,.rf_ll_schlst_tp_bin3_rclk (rf_ll_schlst_tp_bin3_rclk)
,.rf_ll_schlst_tp_bin3_rclk_rst_n (rf_ll_schlst_tp_bin3_rclk_rst_n)
,.rf_ll_schlst_tp_bin3_re    (rf_ll_schlst_tp_bin3_re)
,.rf_ll_schlst_tp_bin3_raddr (rf_ll_schlst_tp_bin3_raddr)
,.rf_ll_schlst_tp_bin3_waddr (rf_ll_schlst_tp_bin3_waddr)
,.rf_ll_schlst_tp_bin3_wclk (rf_ll_schlst_tp_bin3_wclk)
,.rf_ll_schlst_tp_bin3_wclk_rst_n (rf_ll_schlst_tp_bin3_wclk_rst_n)
,.rf_ll_schlst_tp_bin3_we    (rf_ll_schlst_tp_bin3_we)
,.rf_ll_schlst_tp_bin3_wdata (rf_ll_schlst_tp_bin3_wdata)
,.rf_ll_schlst_tp_bin3_rdata (rf_ll_schlst_tp_bin3_rdata)

,.rf_ll_schlst_tp_bin3_error (rf_ll_schlst_tp_bin3_error)

,.func_ll_schlst_tpprv_bin0_re    (func_ll_schlst_tpprv_bin0_re)
,.func_ll_schlst_tpprv_bin0_raddr (func_ll_schlst_tpprv_bin0_raddr)
,.func_ll_schlst_tpprv_bin0_waddr (func_ll_schlst_tpprv_bin0_waddr)
,.func_ll_schlst_tpprv_bin0_we    (func_ll_schlst_tpprv_bin0_we)
,.func_ll_schlst_tpprv_bin0_wdata (func_ll_schlst_tpprv_bin0_wdata)
,.func_ll_schlst_tpprv_bin0_rdata (func_ll_schlst_tpprv_bin0_rdata)

,.pf_ll_schlst_tpprv_bin0_re      (pf_ll_schlst_tpprv_bin0_re)
,.pf_ll_schlst_tpprv_bin0_raddr (pf_ll_schlst_tpprv_bin0_raddr)
,.pf_ll_schlst_tpprv_bin0_waddr (pf_ll_schlst_tpprv_bin0_waddr)
,.pf_ll_schlst_tpprv_bin0_we    (pf_ll_schlst_tpprv_bin0_we)
,.pf_ll_schlst_tpprv_bin0_wdata (pf_ll_schlst_tpprv_bin0_wdata)
,.pf_ll_schlst_tpprv_bin0_rdata (pf_ll_schlst_tpprv_bin0_rdata)

,.rf_ll_schlst_tpprv_bin0_rclk (rf_ll_schlst_tpprv_bin0_rclk)
,.rf_ll_schlst_tpprv_bin0_rclk_rst_n (rf_ll_schlst_tpprv_bin0_rclk_rst_n)
,.rf_ll_schlst_tpprv_bin0_re    (rf_ll_schlst_tpprv_bin0_re)
,.rf_ll_schlst_tpprv_bin0_raddr (rf_ll_schlst_tpprv_bin0_raddr)
,.rf_ll_schlst_tpprv_bin0_waddr (rf_ll_schlst_tpprv_bin0_waddr)
,.rf_ll_schlst_tpprv_bin0_wclk (rf_ll_schlst_tpprv_bin0_wclk)
,.rf_ll_schlst_tpprv_bin0_wclk_rst_n (rf_ll_schlst_tpprv_bin0_wclk_rst_n)
,.rf_ll_schlst_tpprv_bin0_we    (rf_ll_schlst_tpprv_bin0_we)
,.rf_ll_schlst_tpprv_bin0_wdata (rf_ll_schlst_tpprv_bin0_wdata)
,.rf_ll_schlst_tpprv_bin0_rdata (rf_ll_schlst_tpprv_bin0_rdata)

,.rf_ll_schlst_tpprv_bin0_error (rf_ll_schlst_tpprv_bin0_error)

,.func_ll_schlst_tpprv_bin1_re    (func_ll_schlst_tpprv_bin1_re)
,.func_ll_schlst_tpprv_bin1_raddr (func_ll_schlst_tpprv_bin1_raddr)
,.func_ll_schlst_tpprv_bin1_waddr (func_ll_schlst_tpprv_bin1_waddr)
,.func_ll_schlst_tpprv_bin1_we    (func_ll_schlst_tpprv_bin1_we)
,.func_ll_schlst_tpprv_bin1_wdata (func_ll_schlst_tpprv_bin1_wdata)
,.func_ll_schlst_tpprv_bin1_rdata (func_ll_schlst_tpprv_bin1_rdata)

,.pf_ll_schlst_tpprv_bin1_re      (pf_ll_schlst_tpprv_bin1_re)
,.pf_ll_schlst_tpprv_bin1_raddr (pf_ll_schlst_tpprv_bin1_raddr)
,.pf_ll_schlst_tpprv_bin1_waddr (pf_ll_schlst_tpprv_bin1_waddr)
,.pf_ll_schlst_tpprv_bin1_we    (pf_ll_schlst_tpprv_bin1_we)
,.pf_ll_schlst_tpprv_bin1_wdata (pf_ll_schlst_tpprv_bin1_wdata)
,.pf_ll_schlst_tpprv_bin1_rdata (pf_ll_schlst_tpprv_bin1_rdata)

,.rf_ll_schlst_tpprv_bin1_rclk (rf_ll_schlst_tpprv_bin1_rclk)
,.rf_ll_schlst_tpprv_bin1_rclk_rst_n (rf_ll_schlst_tpprv_bin1_rclk_rst_n)
,.rf_ll_schlst_tpprv_bin1_re    (rf_ll_schlst_tpprv_bin1_re)
,.rf_ll_schlst_tpprv_bin1_raddr (rf_ll_schlst_tpprv_bin1_raddr)
,.rf_ll_schlst_tpprv_bin1_waddr (rf_ll_schlst_tpprv_bin1_waddr)
,.rf_ll_schlst_tpprv_bin1_wclk (rf_ll_schlst_tpprv_bin1_wclk)
,.rf_ll_schlst_tpprv_bin1_wclk_rst_n (rf_ll_schlst_tpprv_bin1_wclk_rst_n)
,.rf_ll_schlst_tpprv_bin1_we    (rf_ll_schlst_tpprv_bin1_we)
,.rf_ll_schlst_tpprv_bin1_wdata (rf_ll_schlst_tpprv_bin1_wdata)
,.rf_ll_schlst_tpprv_bin1_rdata (rf_ll_schlst_tpprv_bin1_rdata)

,.rf_ll_schlst_tpprv_bin1_error (rf_ll_schlst_tpprv_bin1_error)

,.func_ll_schlst_tpprv_bin2_re    (func_ll_schlst_tpprv_bin2_re)
,.func_ll_schlst_tpprv_bin2_raddr (func_ll_schlst_tpprv_bin2_raddr)
,.func_ll_schlst_tpprv_bin2_waddr (func_ll_schlst_tpprv_bin2_waddr)
,.func_ll_schlst_tpprv_bin2_we    (func_ll_schlst_tpprv_bin2_we)
,.func_ll_schlst_tpprv_bin2_wdata (func_ll_schlst_tpprv_bin2_wdata)
,.func_ll_schlst_tpprv_bin2_rdata (func_ll_schlst_tpprv_bin2_rdata)

,.pf_ll_schlst_tpprv_bin2_re      (pf_ll_schlst_tpprv_bin2_re)
,.pf_ll_schlst_tpprv_bin2_raddr (pf_ll_schlst_tpprv_bin2_raddr)
,.pf_ll_schlst_tpprv_bin2_waddr (pf_ll_schlst_tpprv_bin2_waddr)
,.pf_ll_schlst_tpprv_bin2_we    (pf_ll_schlst_tpprv_bin2_we)
,.pf_ll_schlst_tpprv_bin2_wdata (pf_ll_schlst_tpprv_bin2_wdata)
,.pf_ll_schlst_tpprv_bin2_rdata (pf_ll_schlst_tpprv_bin2_rdata)

,.rf_ll_schlst_tpprv_bin2_rclk (rf_ll_schlst_tpprv_bin2_rclk)
,.rf_ll_schlst_tpprv_bin2_rclk_rst_n (rf_ll_schlst_tpprv_bin2_rclk_rst_n)
,.rf_ll_schlst_tpprv_bin2_re    (rf_ll_schlst_tpprv_bin2_re)
,.rf_ll_schlst_tpprv_bin2_raddr (rf_ll_schlst_tpprv_bin2_raddr)
,.rf_ll_schlst_tpprv_bin2_waddr (rf_ll_schlst_tpprv_bin2_waddr)
,.rf_ll_schlst_tpprv_bin2_wclk (rf_ll_schlst_tpprv_bin2_wclk)
,.rf_ll_schlst_tpprv_bin2_wclk_rst_n (rf_ll_schlst_tpprv_bin2_wclk_rst_n)
,.rf_ll_schlst_tpprv_bin2_we    (rf_ll_schlst_tpprv_bin2_we)
,.rf_ll_schlst_tpprv_bin2_wdata (rf_ll_schlst_tpprv_bin2_wdata)
,.rf_ll_schlst_tpprv_bin2_rdata (rf_ll_schlst_tpprv_bin2_rdata)

,.rf_ll_schlst_tpprv_bin2_error (rf_ll_schlst_tpprv_bin2_error)

,.func_ll_schlst_tpprv_bin3_re    (func_ll_schlst_tpprv_bin3_re)
,.func_ll_schlst_tpprv_bin3_raddr (func_ll_schlst_tpprv_bin3_raddr)
,.func_ll_schlst_tpprv_bin3_waddr (func_ll_schlst_tpprv_bin3_waddr)
,.func_ll_schlst_tpprv_bin3_we    (func_ll_schlst_tpprv_bin3_we)
,.func_ll_schlst_tpprv_bin3_wdata (func_ll_schlst_tpprv_bin3_wdata)
,.func_ll_schlst_tpprv_bin3_rdata (func_ll_schlst_tpprv_bin3_rdata)

,.pf_ll_schlst_tpprv_bin3_re      (pf_ll_schlst_tpprv_bin3_re)
,.pf_ll_schlst_tpprv_bin3_raddr (pf_ll_schlst_tpprv_bin3_raddr)
,.pf_ll_schlst_tpprv_bin3_waddr (pf_ll_schlst_tpprv_bin3_waddr)
,.pf_ll_schlst_tpprv_bin3_we    (pf_ll_schlst_tpprv_bin3_we)
,.pf_ll_schlst_tpprv_bin3_wdata (pf_ll_schlst_tpprv_bin3_wdata)
,.pf_ll_schlst_tpprv_bin3_rdata (pf_ll_schlst_tpprv_bin3_rdata)

,.rf_ll_schlst_tpprv_bin3_rclk (rf_ll_schlst_tpprv_bin3_rclk)
,.rf_ll_schlst_tpprv_bin3_rclk_rst_n (rf_ll_schlst_tpprv_bin3_rclk_rst_n)
,.rf_ll_schlst_tpprv_bin3_re    (rf_ll_schlst_tpprv_bin3_re)
,.rf_ll_schlst_tpprv_bin3_raddr (rf_ll_schlst_tpprv_bin3_raddr)
,.rf_ll_schlst_tpprv_bin3_waddr (rf_ll_schlst_tpprv_bin3_waddr)
,.rf_ll_schlst_tpprv_bin3_wclk (rf_ll_schlst_tpprv_bin3_wclk)
,.rf_ll_schlst_tpprv_bin3_wclk_rst_n (rf_ll_schlst_tpprv_bin3_wclk_rst_n)
,.rf_ll_schlst_tpprv_bin3_we    (rf_ll_schlst_tpprv_bin3_we)
,.rf_ll_schlst_tpprv_bin3_wdata (rf_ll_schlst_tpprv_bin3_wdata)
,.rf_ll_schlst_tpprv_bin3_rdata (rf_ll_schlst_tpprv_bin3_rdata)

,.rf_ll_schlst_tpprv_bin3_error (rf_ll_schlst_tpprv_bin3_error)

,.func_ll_slst_cnt_re    (func_ll_slst_cnt_re)
,.func_ll_slst_cnt_raddr (func_ll_slst_cnt_raddr)
,.func_ll_slst_cnt_waddr (func_ll_slst_cnt_waddr)
,.func_ll_slst_cnt_we    (func_ll_slst_cnt_we)
,.func_ll_slst_cnt_wdata (func_ll_slst_cnt_wdata)
,.func_ll_slst_cnt_rdata (func_ll_slst_cnt_rdata)

,.pf_ll_slst_cnt_re      (pf_ll_slst_cnt_re)
,.pf_ll_slst_cnt_raddr (pf_ll_slst_cnt_raddr)
,.pf_ll_slst_cnt_waddr (pf_ll_slst_cnt_waddr)
,.pf_ll_slst_cnt_we    (pf_ll_slst_cnt_we)
,.pf_ll_slst_cnt_wdata (pf_ll_slst_cnt_wdata)
,.pf_ll_slst_cnt_rdata (pf_ll_slst_cnt_rdata)

,.rf_ll_slst_cnt_rclk (rf_ll_slst_cnt_rclk)
,.rf_ll_slst_cnt_rclk_rst_n (rf_ll_slst_cnt_rclk_rst_n)
,.rf_ll_slst_cnt_re    (rf_ll_slst_cnt_re)
,.rf_ll_slst_cnt_raddr (rf_ll_slst_cnt_raddr)
,.rf_ll_slst_cnt_waddr (rf_ll_slst_cnt_waddr)
,.rf_ll_slst_cnt_wclk (rf_ll_slst_cnt_wclk)
,.rf_ll_slst_cnt_wclk_rst_n (rf_ll_slst_cnt_wclk_rst_n)
,.rf_ll_slst_cnt_we    (rf_ll_slst_cnt_we)
,.rf_ll_slst_cnt_wdata (rf_ll_slst_cnt_wdata)
,.rf_ll_slst_cnt_rdata (rf_ll_slst_cnt_rdata)

,.rf_ll_slst_cnt_error (rf_ll_slst_cnt_error)

,.func_qid_rdylst_clamp_re    (func_qid_rdylst_clamp_re)
,.func_qid_rdylst_clamp_raddr (func_qid_rdylst_clamp_raddr)
,.func_qid_rdylst_clamp_waddr (func_qid_rdylst_clamp_waddr)
,.func_qid_rdylst_clamp_we    (func_qid_rdylst_clamp_we)
,.func_qid_rdylst_clamp_wdata (func_qid_rdylst_clamp_wdata)
,.func_qid_rdylst_clamp_rdata (func_qid_rdylst_clamp_rdata)

,.pf_qid_rdylst_clamp_re      (pf_qid_rdylst_clamp_re)
,.pf_qid_rdylst_clamp_raddr (pf_qid_rdylst_clamp_raddr)
,.pf_qid_rdylst_clamp_waddr (pf_qid_rdylst_clamp_waddr)
,.pf_qid_rdylst_clamp_we    (pf_qid_rdylst_clamp_we)
,.pf_qid_rdylst_clamp_wdata (pf_qid_rdylst_clamp_wdata)
,.pf_qid_rdylst_clamp_rdata (pf_qid_rdylst_clamp_rdata)

,.rf_qid_rdylst_clamp_rclk (rf_qid_rdylst_clamp_rclk)
,.rf_qid_rdylst_clamp_rclk_rst_n (rf_qid_rdylst_clamp_rclk_rst_n)
,.rf_qid_rdylst_clamp_re    (rf_qid_rdylst_clamp_re)
,.rf_qid_rdylst_clamp_raddr (rf_qid_rdylst_clamp_raddr)
,.rf_qid_rdylst_clamp_waddr (rf_qid_rdylst_clamp_waddr)
,.rf_qid_rdylst_clamp_wclk (rf_qid_rdylst_clamp_wclk)
,.rf_qid_rdylst_clamp_wclk_rst_n (rf_qid_rdylst_clamp_wclk_rst_n)
,.rf_qid_rdylst_clamp_we    (rf_qid_rdylst_clamp_we)
,.rf_qid_rdylst_clamp_wdata (rf_qid_rdylst_clamp_wdata)
,.rf_qid_rdylst_clamp_rdata (rf_qid_rdylst_clamp_rdata)

,.rf_qid_rdylst_clamp_error (rf_qid_rdylst_clamp_error)

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
  , .in_valid                           ( db_ap_aqed_valid )
  , .in_ready                           ( db_ap_aqed_ready )
  , .in_data                            ( db_ap_aqed_data )
  , .out_valid                          ( ap_aqed_v )
  , .out_ready                          ( ap_aqed_ready )
  , .out_data                           ( ap_aqed_data )
) ;

hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_aqed_ap_enq_data ) )
) i_db_aqed_ap_enq_data (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_aqed_ap_enq_status_pnc )
  , .in_valid                           ( aqed_ap_enq_v )
  , .in_ready                           ( aqed_ap_enq_ready )
  , .in_data                            ( aqed_ap_enq_data )
  , .out_valid                          ( db_aqed_ap_enq_valid )
  , .out_ready                          ( db_aqed_ap_enq_ready )
  , .out_data                           ( db_aqed_ap_enq_data )
) ;

hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_ap_lsp_enq_data ) )
) i_db_ap_lsp_enq_data (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_ap_lsp_enq_status_pnc )
  , .in_valid                           ( db_ap_lsp_enq_valid )
  , .in_ready                           ( db_ap_lsp_enq_ready )
  , .in_data                            ( db_ap_lsp_enq_data )
  , .out_valid                          ( ap_lsp_enq_v )
  , .out_ready                          ( ap_lsp_enq_ready )
  , .out_data                           ( ap_lsp_enq_data )
) ;

hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_lsp_ap_atm_data ) )
) i_db_lsp_ap_atm_data (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_lsp_ap_atm_status_pnc )
  , .in_valid                           ( lsp_ap_atm_v )
  , .in_ready                           ( lsp_ap_atm_ready )
  , .in_data                            ( lsp_ap_atm_data )
  , .out_valid                          ( db_lsp_ap_atm_valid )
  , .out_ready                          ( db_lsp_ap_atm_ready )
  , .out_data                           ( db_lsp_ap_atm_data )
) ;


hqm_AW_double_buffer # (
    .WIDTH                              ( $bits ( db_lsp_aqed_cmp_data ) )
) i_db_lsp_aqed_cmp_data (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( db_lsp_aqed_cmp_status_pnc )
  , .in_valid                           ( db_lsp_aqed_cmp_v )
  , .in_ready                           ( db_lsp_aqed_cmp_ready )
  , .in_data                            ( db_lsp_aqed_cmp_data )
  , .out_valid                          ( lsp_aqed_cmp_v )
  , .out_ready                          ( lsp_aqed_cmp_ready )
  , .out_data                           ( lsp_aqed_cmp_data )
) ;

//---------------------------------------------------------------------------------------------------------
// common core - Configuration Ring & config sidecar

cfg_req_t unit_cfg_req ;
logic [ ( HQM_AP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_write ;
logic [ ( HQM_AP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] unit_cfg_req_read ;
logic unit_cfg_rsp_ack ;
logic unit_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ] unit_cfg_rsp_rdata ;
hqm_AW_cfg_ring_top # (
          .NODE_ID                     ( HQM_AP_CFG_NODE_ID )
        , .UNIT_ID                     ( HQM_AP_CFG_UNIT_ID )
        , .UNIT_TGT_MAP                ( HQM_AP_CFG_UNIT_TGT_MAP )
        , .UNIT_NUM_TGTS               ( HQM_AP_CFG_UNIT_NUM_TGTS )
) i_hqm_aw_cfg_ring_top (
          .hqm_inp_gated_clk           ( hqm_inp_gated_clk )
        , .hqm_inp_gated_rst_n         ( hqm_inp_gated_rst_n )
        , .hqm_gated_clk               ( hqm_gated_clk )
        , .hqm_gated_rst_n             ( hqm_gated_rst_n )
        , .rst_prep                    ( rst_prep )

        , .cfg_rx_enable               ( atm_clk_enable )
        , .cfg_rx_idle                 ( cfg_rx_idle ) 
        , .cfg_rx_fifo_status          ( cfg_rx_fifo_status )
        , .cfg_idle                    ( cfg_idle )

        , .up_cfg_req_write            ( ap_cfg_req_up_write )
        , .up_cfg_req_read             ( ap_cfg_req_up_read )
        , .up_cfg_req                  ( ap_cfg_req_up )
        , .up_cfg_rsp_ack              ( ap_cfg_rsp_up_ack )
        , .up_cfg_rsp                  ( ap_cfg_rsp_up )

        , .down_cfg_req_write          ( ap_cfg_req_down_write )
        , .down_cfg_req_read           ( ap_cfg_req_down_read )
        , .down_cfg_req                ( ap_cfg_req_down )
        , .down_cfg_rsp_ack            ( ap_cfg_rsp_down_ack )
        , .down_cfg_rsp                ( ap_cfg_rsp_down )

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
assign hqm_ap_target_cfg_unit_timeout_reg_nxt = {hqm_ap_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign cfg_unit_timeout = {hqm_ap_target_cfg_unit_timeout_reg_f[31:5],5'd31};
assign timeout_nc = hqm_ap_target_cfg_unit_timeout_reg_f[4:0]; 

localparam VERSION = 8'h00;
cfg_unit_version_t cfg_unit_version;
assign cfg_unit_version.VERSION = VERSION;
assign cfg_unit_version.SPARE   = '0;
assign hqm_ap_target_cfg_unit_version_status = cfg_unit_version;

//------------------------------------------------------------------------------------------------------------------

logic cfg_req_idlepipe ;
logic cfg_req_ready ;
logic [ ( HQM_AP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write ;
logic [ ( HQM_AP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read ;

logic [ ( 32 ) - 1 : 0 ] cfgsc_mem_wdata ;
hqm_AW_cfg_sc # (
          .MODULE                      ( HQM_AP_CFG_NODE_ID )
        , .NUM_CFG_TARGETS             ( HQM_AP_CFG_UNIT_NUM_TGTS )
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
        , .cfg_mem_wdata               ( cfgsc_mem_wdata )
        , .cfg_mem_rdata               ( cfg_mem_rdata )
        , .cfg_mem_ack                 ( cfg_mem_ack )
        , .cfg_req_idlepipe            ( cfg_req_idlepipe )
        , .cfg_req_ready               ( cfg_req_ready )

        , .cfg_timout_enable           ( cfg_unit_timeout.ENABLE )
        , .cfg_timout_threshold        ( cfg_unit_timeout.THRESHOLD )
) ;

// common core - (cfgsc) configuration sc logic ( do custom CFG access like inject correction code or split logical config request to physical implentation
logic cfgsc_cfg_qid_ldb_qid2cqidix_mem_we ;
assign cfgsc_cfg_qid_ldb_qid2cqidix_mem_we = cfg_mem_we [ CFG_ACCESSIBLE_RAM_AQED_QID2CQIDIX ] ;

logic cfgsc_mem_wdata_par_p ;
logic [ ( 32 ) - 1 : 0 ] cfgsc_mem_wdata_par_a ;
hqm_AW_parity_gen # ( .WIDTH ( 32 ) ) i_cfgsc_mem_wdata_par_gen (
          .d                    ( cfgsc_mem_wdata_par_a )
        , .odd                  ( 1'b1 )
        , .p                    ( cfgsc_mem_wdata_par_p )
) ;

always_comb begin

  //CFG correction code logic
  cfg_mem_cc_v = '0 ;
  cfg_mem_cc_value = '0 ;
  cfg_mem_cc_width = '0 ;
  cfg_mem_cc_position = '0 ;

  cfg_mem_wdata = cfgsc_mem_wdata ;
  cfgsc_mem_wdata_par_a = '0 ;

  if ( cfgsc_cfg_qid_ldb_qid2cqidix_mem_we ) begin
    cfg_mem_wdata                               = cfgsc_mem_wdata ;
    cfgsc_mem_wdata_par_a                       = cfg_mem_wdata ;
    cfg_mem_cc_v                                = 1'b1 ;
    cfg_mem_cc_value                            = { 7'h0 , cfgsc_mem_wdata_par_p } ;
    cfg_mem_cc_width                            = 4'h1 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) cfg_mem_cc_position       = 12'd512 + 12'd0 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) cfg_mem_cc_position       = 12'd512 + 12'd1 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) cfg_mem_cc_position       = 12'd512 + 12'd2 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) cfg_mem_cc_position       = 12'd512 + 12'd3 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) cfg_mem_cc_position       = 12'd512 + 12'd4 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) cfg_mem_cc_position       = 12'd512 + 12'd5 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) cfg_mem_cc_position       = 12'd512 + 12'd6 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) cfg_mem_cc_position       = 12'd512 + 12'd7 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) cfg_mem_cc_position       = 12'd512 + 12'd8 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) cfg_mem_cc_position       = 12'd512 + 12'd9 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) cfg_mem_cc_position       = 12'd512 + 12'd10 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) cfg_mem_cc_position       = 12'd512 + 12'd11 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) cfg_mem_cc_position       = 12'd512 + 12'd12 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) cfg_mem_cc_position       = 12'd512 + 12'd13 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) cfg_mem_cc_position       = 12'd512 + 12'd14 ;
    if ( cfg_req_write [ HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) cfg_mem_cc_position       = 12'd512 + 12'd15 ;
  end

  if ( cfg_req_write [ HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP * 1 +: 1 ]  ) begin
    cfg_mem_wdata                               = { 27'd0 , cfgsc_mem_wdata [ ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH - 1 ) - 1 : 0 ] } ;
    cfgsc_mem_wdata_par_a                       = cfg_mem_wdata ;
    cfg_mem_cc_v                                = 1'b1 ;
    cfg_mem_cc_value                            = { 7'h0 , cfgsc_mem_wdata_par_p } ;
    cfg_mem_cc_width                            = 4'h1 ;
    cfg_mem_cc_position                         = 12'd5 ;
  end

end


//---------------------------------------------------------------------------------------------------------
// common core - Interrupt serializer. Capture all interrutps from unit and send on interrupt ring

hqm_AW_int_serializer # (
    .NUM_INF                            ( HQM_AP_ALARM_NUM_INF )
  , .NUM_COR                            ( HQM_AP_ALARM_NUM_COR )
  , .NUM_UNC                            ( HQM_AP_ALARM_NUM_UNC )
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

  , .int_up_v                           ( ap_alarm_up_v )
  , .int_up_ready                       ( ap_alarm_up_ready )
  , .int_up_data                        ( ap_alarm_up_data )

  , .int_down_v                         ( ap_alarm_down_v )
  , .int_down_ready                     ( ap_alarm_down_ready )
  , .int_down_data                      ( ap_alarm_down_data )

  , .status                             ( int_status )

  , .int_idle                           ( int_idle )
) ;

logic err_hw_class_01_v_nxt , err_hw_class_01_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_01_nxt , err_hw_class_01_f ;
logic err_hw_class_02_v_nxt , err_hw_class_02_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_02_nxt , err_hw_class_02_f ;
logic err_hw_class_03_v_nxt , err_hw_class_03_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_03_nxt , err_hw_class_03_f ;
logic err_hw_class_04_v_nxt , err_hw_class_04_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_04_nxt , err_hw_class_04_f ;
logic err_hw_class_05_v_nxt , err_hw_class_05_v_f ;
logic [ ( 31 ) - 1 : 0 ] err_hw_class_05_nxt , err_hw_class_05_f ;

assign err_hw_class_01_nxt [ 0 ]  = error_nopri ;
assign err_hw_class_01_nxt [ 1 ]  = report_error_enq_cnt_r_of ;
assign err_hw_class_01_nxt [ 2 ]  = report_error_enq_cnt_r_uf ;
assign err_hw_class_01_nxt [ 3 ]  = report_error_enq_cnt_s_of ;
assign err_hw_class_01_nxt [ 4 ]  = report_error_enq_cnt_s_uf ;
assign err_hw_class_01_nxt [ 5 ]  = report_error_rlst_cnt_of ;
assign err_hw_class_01_nxt [ 6 ]  = report_error_rlst_cnt_uf ;
assign err_hw_class_01_nxt [ 7 ]  = report_error_sch_cnt_of ;
assign err_hw_class_01_nxt [ 8 ]  = report_error_sch_cnt_uf ;
assign err_hw_class_01_nxt [ 9 ]  = report_error_slst_cnt_of [ 3 ] ;
assign err_hw_class_01_nxt [ 10 ] = report_error_slst_cnt_of [ 2 ] ;
assign err_hw_class_01_nxt [ 11 ] = report_error_slst_cnt_of [ 1 ] ;
assign err_hw_class_01_nxt [ 12 ] = report_error_slst_cnt_of [ 0 ] ;
assign err_hw_class_01_nxt [ 13 ] = report_error_slst_cnt_uf [ 3 ] ;
assign err_hw_class_01_nxt [ 14 ] = report_error_slst_cnt_uf [ 2 ] ;
assign err_hw_class_01_nxt [ 15 ] = report_error_slst_cnt_uf [ 1 ] ;
assign err_hw_class_01_nxt [ 16 ] = report_error_slst_cnt_uf [ 0 ] ;
assign err_hw_class_01_nxt [ 17 ] = error_headroom [ 1 ] ;
assign err_hw_class_01_nxt [ 18 ] = error_headroom [ 0 ] ;
assign err_hw_class_01_nxt [ 19 ] = error_ap_lsp ;
assign err_hw_class_01_nxt [ 20 ] = rmw_fid2cqqidix_status ;
assign err_hw_class_01_nxt [ 21 ] = rmw_qid_rdylst_clamp_status ;
assign err_hw_class_01_nxt [ 22 ] = ( | rmw_ll_rdylst_hp_status ) ;
assign err_hw_class_01_nxt [ 23 ] = ( | rmw_ll_rdylst_tp_status ) ;
assign err_hw_class_01_nxt [ 24 ] = ( | rmw_ll_rdylst_hpnxt_status ) ;
assign err_hw_class_01_nxt [ 25 ] = rmw_ll_rlst_cnt_status ;
assign err_hw_class_01_nxt [ 26 ] = ( | rmw_ll_schlst_hp_status ) ;
assign err_hw_class_01_nxt [ 27 ] = ( rf_aqed_qid2cqidix_error
                             | rf_atm_fifo_ap_aqed_error
                             | rf_atm_fifo_aqed_ap_enq_error
                             | rf_fid2cqqidix_error
                             | rf_ll_enq_cnt_r_bin0_dup0_error
                             | rf_ll_enq_cnt_r_bin0_dup1_error
                             | rf_ll_enq_cnt_r_bin0_dup2_error
                             | rf_ll_enq_cnt_r_bin0_dup3_error
                             | rf_ll_enq_cnt_r_bin1_dup0_error
                             | rf_ll_enq_cnt_r_bin1_dup1_error
                             | rf_ll_enq_cnt_r_bin1_dup2_error
                             | rf_ll_enq_cnt_r_bin1_dup3_error
                             | rf_ll_enq_cnt_r_bin2_dup0_error
                             | rf_ll_enq_cnt_r_bin2_dup1_error
                             | rf_ll_enq_cnt_r_bin2_dup2_error
                             | rf_ll_enq_cnt_r_bin2_dup3_error
                             | rf_ll_enq_cnt_r_bin3_dup0_error
                             | rf_ll_enq_cnt_r_bin3_dup1_error
                             | rf_ll_enq_cnt_r_bin3_dup2_error
                             | rf_ll_enq_cnt_r_bin3_dup3_error
                             | rf_ll_enq_cnt_s_bin0_error
                             | rf_ll_enq_cnt_s_bin1_error
                             | rf_ll_enq_cnt_s_bin2_error
                             | rf_ll_enq_cnt_s_bin3_error
                             | rf_ll_rdylst_hp_bin0_error
                             | rf_ll_rdylst_hp_bin1_error
                             | rf_ll_rdylst_hp_bin2_error
                             | rf_ll_rdylst_hp_bin3_error
                             | rf_ll_rdylst_hpnxt_bin0_error
                             | rf_ll_rdylst_hpnxt_bin1_error
                             | rf_ll_rdylst_hpnxt_bin2_error
                             | rf_ll_rdylst_hpnxt_bin3_error
                             | rf_ll_rdylst_tp_bin0_error
                             | rf_ll_rdylst_tp_bin1_error
                             | rf_ll_rdylst_tp_bin2_error
                             | rf_ll_rdylst_tp_bin3_error
                             | rf_ll_rlst_cnt_error
                             | rf_ll_sch_cnt_dup0_error
                             | rf_ll_sch_cnt_dup1_error
                             | rf_ll_sch_cnt_dup2_error
                             | rf_ll_sch_cnt_dup3_error
                             | rf_ll_schlst_hp_bin0_error
                             | rf_ll_schlst_hp_bin1_error
                             | rf_ll_schlst_hp_bin2_error
                             | rf_ll_schlst_hp_bin3_error
                             | rf_ll_schlst_hpnxt_bin0_error
                             | rf_ll_schlst_hpnxt_bin1_error
                             | rf_ll_schlst_hpnxt_bin2_error
                             | rf_ll_schlst_hpnxt_bin3_error
                             | rf_ll_schlst_tp_bin0_error
                             | rf_ll_schlst_tp_bin1_error
                             | rf_ll_schlst_tp_bin2_error
                             | rf_ll_schlst_tp_bin3_error
                             | rf_ll_schlst_tpprv_bin0_error
                             | rf_ll_schlst_tpprv_bin1_error
                             | rf_ll_schlst_tpprv_bin2_error
                             | rf_ll_schlst_tpprv_bin3_error
                             | rf_ll_slst_cnt_error
                             | rf_qid_rdylst_clamp_error
                              ) ;
assign err_hw_class_01_nxt [ 30 : 28 ] = 3'd1 ;
assign err_hw_class_01_v_nxt = ( | err_hw_class_01_nxt [ 27 : 0 ] ) ;

assign err_hw_class_02_nxt [ 0 ]  = ( | rmw_ll_schlst_tp_status ) ;
assign err_hw_class_02_nxt [ 1 ]  = ( | rmw_ll_schlst_hpnxt_status ) ;
assign err_hw_class_02_nxt [ 2 ]  = ( | rmw_ll_schlst_tpprv_status ) ;
assign err_hw_class_02_nxt [ 3 ]  = rmw_ll_slst_cnt_status ;
assign err_hw_class_02_nxt [ 4 ]  = ( | rmw_ll_enq_cnt_r_dup0_status ) ;
assign err_hw_class_02_nxt [ 5 ]  = ( | rmw_ll_enq_cnt_r_dup1_status ) ;
assign err_hw_class_02_nxt [ 6 ]  = ( | rmw_ll_enq_cnt_r_dup2_status ) ;
assign err_hw_class_02_nxt [ 7 ]  = ( | rmw_ll_enq_cnt_r_dup3_status ) ;
assign err_hw_class_02_nxt [ 8 ]  = ( | rmw_ll_enq_cnt_s_status ) ;
assign err_hw_class_02_nxt [ 9 ]  = ( | rmw_ll_sch_cnt_status ) ;
assign err_hw_class_02_nxt [ 10 ] = ( | rmw_ll_rdylst_hp_error ) ;
assign err_hw_class_02_nxt [ 11 ] = ( | rmw_ll_rdylst_tp_error ) ;
assign err_hw_class_02_nxt [ 12 ] = ( | rmw_ll_rdylst_hpnxt_error ) ;
assign err_hw_class_02_nxt [ 13 ] = ( | rmw_ll_schlst_hp_error ) ;
assign err_hw_class_02_nxt [ 14 ] = ( | rmw_ll_schlst_tp_error ) ;
assign err_hw_class_02_nxt [ 15 ] = ( | rmw_ll_schlst_hpnxt_error ) ;
assign err_hw_class_02_nxt [ 16 ] = ( | rmw_ll_schlst_tpprv_error ) ;
assign err_hw_class_02_nxt [ 17 ] = parity_check_qid_rdylst_clamp_error ;
assign err_hw_class_02_nxt [ 18 ] = parity_check_qid2cqidix_err_f [ 0 ] ;
assign err_hw_class_02_nxt [ 19 ] = parity_check_qid2cqidix_err_f [ 1 ] ;
assign err_hw_class_02_nxt [ 20 ] = parity_check_qid2cqidix_err_f [ 2 ] ;
assign err_hw_class_02_nxt [ 21 ] = parity_check_qid2cqidix_err_f [ 3 ] ;
assign err_hw_class_02_nxt [ 22 ] = parity_check_qid2cqidix_err_f [ 4 ] ;
assign err_hw_class_02_nxt [ 23 ] = parity_check_qid2cqidix_err_f [ 5 ] ;
assign err_hw_class_02_nxt [ 24 ] = parity_check_qid2cqidix_err_f [ 6 ] ;
assign err_hw_class_02_nxt [ 25 ] = parity_check_qid2cqidix_err_f [ 7 ] ;
assign err_hw_class_02_nxt [ 26 ] = parity_check_qid2cqidix_err_f [ 8 ] ;
assign err_hw_class_02_nxt [ 27 ] = parity_check_qid2cqidix_err_f [ 9 ] ;
assign err_hw_class_02_nxt [ 30 : 28 ] = 3'd2 ;
assign err_hw_class_02_v_nxt = ( | err_hw_class_02_nxt [ 27 : 0 ] ) ;

assign err_hw_class_03_nxt [ 0 ]  = parity_check_qid2cqidix_err_f [ 10 ] ;
assign err_hw_class_03_nxt [ 1 ]  = parity_check_qid2cqidix_err_f [ 11 ] ;
assign err_hw_class_03_nxt [ 2 ]  = parity_check_qid2cqidix_err_f [ 12 ] ;
assign err_hw_class_03_nxt [ 3 ]  = parity_check_qid2cqidix_err_f [ 13 ] ;
assign err_hw_class_03_nxt [ 4 ]  = parity_check_qid2cqidix_err_f [ 14 ] ;
assign err_hw_class_03_nxt [ 5 ]  = parity_check_qid2cqidix_err_f [ 15 ] ;
assign err_hw_class_03_nxt [ 6 ]  = residue_check_ll_rlst_cnt_bin0_err ;
assign err_hw_class_03_nxt [ 7 ]  = residue_check_ll_rlst_cnt_bin1_err ;
assign err_hw_class_03_nxt [ 8 ]  = residue_check_ll_rlst_cnt_bin2_err ;
assign err_hw_class_03_nxt [ 9 ]  = residue_check_ll_rlst_cnt_bin3_err ;
assign err_hw_class_03_nxt [ 10 ] = residue_check_ll_slst_cnt_bin0_err ;
assign err_hw_class_03_nxt [ 11 ] = residue_check_enq_cnt_r_bin0_err ;
assign err_hw_class_03_nxt [ 12 ] = residue_check_enq_cnt_s_bin0_err ;
assign err_hw_class_03_nxt [ 13 ] = residue_check_sch_cnt_bin0_err ;
assign err_hw_class_03_nxt [ 14 ] = residue_check_ll_slst_cnt_bin1_err ;
assign err_hw_class_03_nxt [ 15 ] = residue_check_enq_cnt_r_bin1_err ;
assign err_hw_class_03_nxt [ 16 ] = residue_check_enq_cnt_s_bin1_err ;
assign err_hw_class_03_nxt [ 17 ] = residue_check_sch_cnt_bin1_err ;
assign err_hw_class_03_nxt [ 18 ] = residue_check_ll_slst_cnt_bin2_err ;
assign err_hw_class_03_nxt [ 19 ] = residue_check_enq_cnt_r_bin2_err ;
assign err_hw_class_03_nxt [ 20 ] = residue_check_enq_cnt_s_bin2_err ;
assign err_hw_class_03_nxt [ 21 ] = residue_check_sch_cnt_bin2_err ;
assign err_hw_class_03_nxt [ 22 ] = residue_check_ll_slst_cnt_bin3_err ;
assign err_hw_class_03_nxt [ 23 ] = residue_check_enq_cnt_r_bin3_err ;
assign err_hw_class_03_nxt [ 24 ] = residue_check_enq_cnt_s_bin3_err ;
assign err_hw_class_03_nxt [ 25 ] = residue_check_sch_cnt_bin3_err  ;
assign err_hw_class_03_nxt [ 26 ] = parity_check_aqed_ap_enq_error ;
assign err_hw_class_03_nxt [ 27 ] = parity_check_aqed_ap_enq_flid_error ;
assign err_hw_class_03_nxt [ 30 : 28 ] = 3'd3 ;
assign err_hw_class_03_v_nxt = ( | err_hw_class_03_nxt [ 27 : 0 ] ) ;

assign err_hw_class_04_nxt [ 0 ]  = parity_check_fid2cqqidix_error ;
assign err_hw_class_04_nxt [ 1 ]  = parity_check_ll_rdylst_bin0_hp_error ;
assign err_hw_class_04_nxt [ 2 ]  = parity_check_ll_rdylst_bin1_hp_error ;
assign err_hw_class_04_nxt [ 3 ]  = parity_check_ll_rdylst_bin2_hp_error ;
assign err_hw_class_04_nxt [ 4 ]  = parity_check_ll_rdylst_bin3_hp_error ;
assign err_hw_class_04_nxt [ 5 ]  = parity_check_ll_rdylst_bin0_tp_error ;
assign err_hw_class_04_nxt [ 6 ]  = parity_check_ll_rdylst_bin1_tp_error ;
assign err_hw_class_04_nxt [ 7 ]  = parity_check_ll_rdylst_bin2_tp_error ;
assign err_hw_class_04_nxt [ 8 ]  = parity_check_ll_rdylst_bin3_tp_error ;
assign err_hw_class_04_nxt [ 9 ]  = parity_check_ll_rdylst_bin0_hpnxt_error ;
assign err_hw_class_04_nxt [ 10 ] = parity_check_ll_rdylst_bin1_hpnxt_error ;
assign err_hw_class_04_nxt [ 11 ] = parity_check_ll_rdylst_bin2_hpnxt_error ;
assign err_hw_class_04_nxt [ 12 ] = parity_check_ll_rdylst_bin3_hpnxt_error ;
assign err_hw_class_04_nxt [ 13 ] = parity_check_ll_schlst_bin0_hp_error ;
assign err_hw_class_04_nxt [ 14 ] = parity_check_ll_schlst_bin0_tp_error ;
assign err_hw_class_04_nxt [ 15 ] = parity_check_ll_schlst_bin0_hpnxt_error ;
assign err_hw_class_04_nxt [ 16 ] = parity_check_ll_schlst_bin0_tpprv_error ;
assign err_hw_class_04_nxt [ 17 ] = parity_check_ll_schlst_bin1_hp_error ;
assign err_hw_class_04_nxt [ 18 ] = parity_check_ll_schlst_bin1_tp_error ;
assign err_hw_class_04_nxt [ 19 ] = parity_check_ll_schlst_bin1_hpnxt_error ;
assign err_hw_class_04_nxt [ 20 ] = parity_check_ll_schlst_bin1_tpprv_error ;
assign err_hw_class_04_nxt [ 21 ] = parity_check_ll_schlst_bin2_hp_error ;
assign err_hw_class_04_nxt [ 22 ] = parity_check_ll_schlst_bin2_tp_error ;
assign err_hw_class_04_nxt [ 23 ] = parity_check_ll_schlst_bin2_hpnxt_error ;
assign err_hw_class_04_nxt [ 24 ] = parity_check_ll_schlst_bin2_tpprv_error ;
assign err_hw_class_04_nxt [ 25 ] = parity_check_ll_schlst_bin3_hp_error ;
assign err_hw_class_04_nxt [ 26 ] = parity_check_ll_schlst_bin3_tp_error ;
assign err_hw_class_04_nxt [ 27 ] = parity_check_ll_schlst_bin3_hpnxt_error ;
assign err_hw_class_04_nxt [ 30 : 28 ] = 3'd4 ;
assign err_hw_class_04_v_nxt = ( | err_hw_class_04_nxt [ 27 : 0 ] ) ;

assign err_hw_class_05_nxt [ 0 ]  = parity_check_ll_schlst_bin3_tpprv_error ;
assign err_hw_class_05_nxt [ 1 ]  = cfg_rx_fifo_status.overflow ;
assign err_hw_class_05_nxt [ 2 ]  = cfg_rx_fifo_status.underflow ;
assign err_hw_class_05_nxt [ 3 ]  = fifo_ap_aqed_error_of ;
assign err_hw_class_05_nxt [ 4 ]  = fifo_ap_aqed_error_uf ;
assign err_hw_class_05_nxt [ 5 ]  = fifo_aqed_ap_enq_error_of ;
assign err_hw_class_05_nxt [ 6 ]  = fifo_aqed_ap_enq_error_uf ;
assign err_hw_class_05_nxt [ 7 ]  = fifo_ap_lsp_enq_error_of ;
assign err_hw_class_05_nxt [ 8 ]  = fifo_ap_lsp_enq_error_uf ;
assign err_hw_class_05_nxt [ 9 ]  = hqm_lsp_atm_pipe_rfw_top_ipar_error ;
assign err_hw_class_05_nxt [ 10 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 11 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 12 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 13 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 14 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 15 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 16 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 17 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 18 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 19 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 20 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 21 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 22 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 23 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 24 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 25 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 26 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 27 ] = 1'b0 ;
assign err_hw_class_05_nxt [ 30 : 28 ] = 3'd5 ;
assign err_hw_class_05_v_nxt = ( | err_hw_class_05_nxt [ 27 : 0 ] ) ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
    err_hw_class_01_f <= '0 ;
    err_hw_class_01_v_f <= '0 ;
    err_hw_class_02_f <= '0 ;
    err_hw_class_02_v_f <= '0 ;
    err_hw_class_03_f <= '0 ;
    err_hw_class_03_v_f <= '0 ;
    err_hw_class_04_f <= '0 ;
    err_hw_class_04_v_f <= '0 ;
    err_hw_class_05_f <= '0 ;
    err_hw_class_05_v_f <= '0 ;
  end
  else begin
    err_hw_class_01_f <= err_hw_class_01_nxt ;
    err_hw_class_01_v_f <= err_hw_class_01_v_nxt ;
    err_hw_class_02_f <= err_hw_class_02_nxt ;
    err_hw_class_02_v_f <= err_hw_class_02_v_nxt ;
    err_hw_class_03_f <= err_hw_class_03_nxt ;
    err_hw_class_03_v_f <= err_hw_class_03_v_nxt ;
    err_hw_class_04_f <= err_hw_class_04_nxt ;
    err_hw_class_04_v_f <= err_hw_class_04_v_nxt ;
    err_hw_class_05_f <= err_hw_class_05_nxt ;
    err_hw_class_05_v_f <= err_hw_class_05_v_nxt ;
  end
end

always_comb begin
  int_uid                                          = HQM_AP_CFG_UNIT_ID ;
  int_unc_v                                        = '0 ;
  int_unc_data                                     = '0 ;
  int_cor_v                                        = '0 ;
  int_cor_data                                     = '0 ;
  int_inf_v                                        = '0 ;
  int_inf_data                                     = '0 ;
  hqm_ap_target_cfg_syndrome_00_capture_v          = '0 ;
  hqm_ap_target_cfg_syndrome_00_capture_data       = '0 ;
  hqm_ap_target_cfg_syndrome_01_capture_v          = '0 ;
  hqm_ap_target_cfg_syndrome_01_capture_data       = '0 ;

  //  err_hw_class_01_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_01_v_f & ~hqm_ap_target_cfg_ap_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_ap_target_cfg_syndrome_00_capture_v        = ~hqm_ap_target_cfg_ap_csr_control_reg_f[5] ;
    hqm_ap_target_cfg_syndrome_00_capture_data     = err_hw_class_01_f ;
  end
  //  err_hw_class_02_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_02_v_f & ~hqm_ap_target_cfg_ap_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_ap_target_cfg_syndrome_00_capture_v        = ~hqm_ap_target_cfg_ap_csr_control_reg_f[5] ;
    hqm_ap_target_cfg_syndrome_00_capture_data     = err_hw_class_02_f ;
  end
  //  err_hw_class_03_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_03_v_f & ~hqm_ap_target_cfg_ap_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_ap_target_cfg_syndrome_00_capture_v        = ~hqm_ap_target_cfg_ap_csr_control_reg_f[5] ;
    hqm_ap_target_cfg_syndrome_00_capture_data     = err_hw_class_03_f ;
  end
  //  err_hw_class_04_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_04_v_f & ~hqm_ap_target_cfg_ap_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_ap_target_cfg_syndrome_00_capture_v        = ~hqm_ap_target_cfg_ap_csr_control_reg_f[5] ;
    hqm_ap_target_cfg_syndrome_00_capture_data     = err_hw_class_04_f ;
  end
  //  err_hw_class_05_v_f "HW Error" all hardware errors compressed
  if ( err_hw_class_05_v_f & ~hqm_ap_target_cfg_ap_csr_control_reg_f[4]  ) begin
    int_inf_v [ 0 ]                                = 1'b1 ;
    int_inf_data [ 0 ].rtype                       = 2'd0 ;
    int_inf_data [ 0 ].rid                         = 8'h0 ;
    int_inf_data [ 0 ].msix_map                    = HQM_ALARM ;
    hqm_ap_target_cfg_syndrome_00_capture_v        = ~hqm_ap_target_cfg_ap_csr_control_reg_f[5] ;
    hqm_ap_target_cfg_syndrome_00_capture_data     = err_hw_class_05_f ;
  end


end




//*****************************************************************************************************
//*****************************************************************************************************
// SECTION: END common core interfaces 
//*****************************************************************************************************
//*****************************************************************************************************















//------------------------------------------------------------------------------------------------------------------------------------------------
// flops

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
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L02
  if ( ! hqm_gated_rst_n ) begin



    p0_fid2qidix_v_f <= '0 ;
    p1_fid2qidix_v_f <= '0 ;
    p2_fid2qidix_v_f <= '0 ;

    p0_ll_v_f <= '0 ;
    p1_ll_v_f <= '0 ;
    p2_ll_v_f <= '0 ;
    p3_ll_v_f <= '0 ;
    p4_ll_v_f <= '0 ;
    p5_ll_v_f <= '0 ;
    p6_ll_v_f <= '0 ;

p5_ll_v_syncopy0_f <= '0 ;
p5_ll_v_syncopy1_f <= '0 ;
p5_ll_v_syncopy2_f <= '0 ;

  end
  else begin



    p0_fid2qidix_v_f <= p0_fid2qidix_v_nxt ;
    p1_fid2qidix_v_f <= p1_fid2qidix_v_nxt ;
    p2_fid2qidix_v_f <= p2_fid2qidix_v_nxt ;

    p0_ll_v_f <= p0_ll_v_nxt ;
    p1_ll_v_f <= p1_ll_v_nxt ;
    p2_ll_v_f <= p2_ll_v_nxt ;
    p3_ll_v_f <= p3_ll_v_nxt ;
    p4_ll_v_f <= p4_ll_v_nxt ;
    p5_ll_v_f <= p5_ll_v_nxt ;
    p6_ll_v_f <= p6_ll_v_nxt ;

p5_ll_v_syncopy0_f <= p5_ll_v_nxt ;
p5_ll_v_syncopy1_f <= p5_ll_v_nxt ;
p5_ll_v_syncopy2_f <= p5_ll_v_nxt ;

  end
end


always_ff @ ( posedge hqm_gated_clk ) begin : L03



    p0_fid2qidix_data_f <= p0_fid2qidix_data_nxt ;
    p1_fid2qidix_data_f <= p1_fid2qidix_data_nxt ;
    p2_fid2qidix_data_f <= p2_fid2qidix_data_nxt ;

    p0_ll_data_f <= p0_ll_data_nxt ;
    p1_ll_data_f <= p1_ll_data_nxt ;
    p2_ll_data_f <= p2_ll_data_nxt ;
    p3_ll_data_f <= p3_ll_data_nxt ;
    p4_ll_data_f <= p4_ll_data_nxt ;
    p5_ll_data_f <= p5_ll_data_nxt ;
    p6_ll_data_f <= p6_ll_data_nxt ;
end

// duplicate for fanout violation



assign smon_comp_nxt = hqm_ap_target_cfg_smon_smon_enabled ? smon_comp : smon_comp_f ;
assign smon_val_nxt = hqm_ap_target_cfg_smon_smon_enabled ? smon_val : smon_val_f ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L09
  if ( ! hqm_gated_rst_n ) begin
    stall_f <= '0 ;
    smon_v_f <= '0 ;
    smon_comp_f <= '0 ;
    smon_val_f <= '0 ;

  end
  else begin
    stall_f <= stall_nxt ;
    smon_v_f <= smon_v ;
    smon_comp_f <= smon_comp_nxt ;
    smon_val_f <= smon_val_nxt ;

  end
end
always_comb begin : L10

  stall_nxt                                    = { 5 { ( p3_ll_v_nxt
                                                    & ( ( p4_ll_v_nxt & ( p4_ll_data_nxt.qid == p3_ll_data_nxt.qid ) )
                                                      | ( p5_ll_v_nxt & ( p5_ll_data_nxt.qid == p3_ll_data_nxt.qid ) )
                                                      )
                                                    )
                                                 } } ;


end
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L05
  if ( ! hqm_gated_rst_n ) begin
    parity_check_qid2cqidix_err_f <= '0 ;
  end
  else begin
    parity_check_qid2cqidix_err_f <= parity_check_qid2cqidix_err ;
  end
end


always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L06
  if ( ! hqm_gated_rst_n ) begin
    fifo_ap_aqed_cnt_f <= '0 ;
    fifo_ap_lsp_enq_cnt_f <= '0 ;
  end
  else begin
    fifo_ap_aqed_cnt_f <= fifo_ap_aqed_cnt_nxt ;
    fifo_ap_lsp_enq_cnt_f <= fifo_ap_lsp_enq_cnt_nxt ;
  end
end









always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin : L08
  if ( ! hqm_gated_rst_n ) begin
    ap_lsp_cmd_v_f <= '0 ;
    ap_lsp_cmd_f <= '0 ;
    ap_lsp_cq_f <= '0 ;
    ap_lsp_qidix_msb_f <= '0 ;
    ap_lsp_qidix_f <= '0 ;
    ap_lsp_qid_f <= '0 ;
    ap_lsp_qid2cqqidix_f <= '0 ;
    ap_lsp_haswork_rlst_v_f <= '0 ;
    ap_lsp_haswork_rlst_func_f <= '0 ;
    ap_lsp_haswork_slst_v_f <= '0 ;
    ap_lsp_haswork_slst_func_f <= '0 ;
    ap_lsp_cmpblast_v_f <= '0 ;
    ap_lsp_dec_fid_cnt_v_f <= '0 ;
  end
  else begin
    ap_lsp_cmd_v_f <= ap_lsp_cmd_v_nxt ;
    ap_lsp_cmd_f <= ap_lsp_cmd_nxt ;
    ap_lsp_cq_f <= ap_lsp_cq_nxt ;
    ap_lsp_qidix_msb_f <= ap_lsp_qidix_msb_nxt ;
    ap_lsp_qidix_f <= ap_lsp_qidix_nxt ;
    ap_lsp_qid_f <= ap_lsp_qid_nxt ;
    ap_lsp_qid2cqqidix_f <= ap_lsp_qid2cqqidix_nxt ;
    ap_lsp_haswork_rlst_v_f <= ap_lsp_haswork_rlst_v_nxt ;
    ap_lsp_haswork_rlst_func_f <= ap_lsp_haswork_rlst_func_nxt ;
    ap_lsp_haswork_slst_v_f <= ap_lsp_haswork_slst_v_nxt ;
    ap_lsp_haswork_slst_func_f <= ap_lsp_haswork_slst_func_nxt ;
    ap_lsp_cmpblast_v_f <= ap_lsp_cmpblast_v_nxt ;
    ap_lsp_dec_fid_cnt_v_f <= ap_lsp_dec_fid_cnt_v_nxt ;
  end
end





//------------------------------------------------------------------------------------------------------------------------------------------------
// Instances



//....................................................................................................
//HW AGITATE
assign hqm_ap_target_cfg_hw_agitate_control_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_hw_agitate_control_reg_nxt = cfg_agitate_control_nxt ;
assign cfg_agitate_control_f = hqm_ap_target_cfg_hw_agitate_control_reg_f ;
assign cfg_agitate_control_nxt = cfg_agitate_control_f ;

assign hqm_ap_target_cfg_hw_agitate_select_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_hw_agitate_select_reg_nxt = cfg_agitate_select_nxt ;
assign cfg_agitate_select_f = hqm_ap_target_cfg_hw_agitate_select_reg_f ;
assign cfg_agitate_select_nxt = cfg_agitate_select_f ;





//....................................................................................................
// SMON logic
assign hqm_ap_target_cfg_smon_disable_smon = disable_smon ;
assign hqm_ap_target_cfg_smon_smon_v = smon_v_f ;
assign hqm_ap_target_cfg_smon_smon_comp = smon_comp_f ;
assign hqm_ap_target_cfg_smon_smon_val = smon_val_f ;
assign smon_interrupt_nc = hqm_ap_target_cfg_smon_smon_interrupt ;

//....................................................................................................
// SYNDROME logic

//....................................................................................................
// ECC logic

//....................................................................................................
// PARITY logic




generate
  for ( genvar g = 0 ; g < 16 ; g = g + 1 ) begin : parity_check_qid2cqidix
    hqm_AW_parity_check # ( .WIDTH ( 32 ) ) i_lba_qid2cqidix_par_chk (
          .p                    ( parity_check_qid2cqidix_p [ g ] )
        , .d                    ( parity_check_qid2cqidix_d [ ( g * 32 ) +: 32 ] )
        , .e                    ( parity_check_qid2cqidix_e )
        , .odd                  ( 1'b1 )
        , .err                  ( parity_check_qid2cqidix_err [ g ] )
    ) ;
  end
endgenerate




hqm_AW_parity_check # (
    .WIDTH                              ( 5 )
) i_parity_check_qid_rdylst_clamp (
     .p                                 ( parity_check_qid_rdylst_clamp_p )
   , .d                                 ( parity_check_qid_rdylst_clamp_d )
   , .e                                 ( parity_check_qid_rdylst_clamp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_qid_rdylst_clamp_error )
) ;




hqm_AW_parity_check # (
    .WIDTH                              ( 10 )
) i_parity_check_aqed_ap_enq (
     .p                                 ( parity_check_aqed_ap_enq_p )
   , .d                                 ( parity_check_aqed_ap_enq_d )
   , .e                                 ( parity_check_aqed_ap_enq_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_aqed_ap_enq_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( 12 )
) i_parity_check_aqed_ap_enq_flid (
     .p                                 ( parity_check_aqed_ap_enq_flid_p )
   , .d                                 ( parity_check_aqed_ap_enq_flid_d )
   , .e                                 ( parity_check_aqed_ap_enq_flid_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_aqed_ap_enq_flid_error )
) ;

hqm_AW_parity_gen # (
    .WIDTH                              ( 9 )
) i_parity_gen_fid2cqqidix (
     .d                                 ( parity_gen_fid2cqqidix_d )
   , .odd                               ( 1'b1 )
   , .p                                 ( parity_gen_fid2cqqidix_p )
) ;


logic parity_check_fid2cqqidix_p_f ;
logic [ ( 9 ) - 1 : 0 ] parity_check_fid2cqqidix_d_f ;
logic parity_check_fid2cqqidix_e_f ;
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ! hqm_gated_rst_n ) begin
parity_check_fid2cqqidix_p_f <= '0 ;
parity_check_fid2cqqidix_d_f <= '0 ;
parity_check_fid2cqqidix_e_f <= '0 ;
  end
  else begin
parity_check_fid2cqqidix_p_f <= parity_check_fid2cqqidix_p ;
parity_check_fid2cqqidix_d_f <= parity_check_fid2cqqidix_d ;
parity_check_fid2cqqidix_e_f <= parity_check_fid2cqqidix_e ;
  end
end
hqm_AW_parity_check # (
    .WIDTH                              ( 9 )
) i_parity_check_fid2cqqidix (
     .p                                 ( parity_check_fid2cqqidix_p_f )
   , .d                                 ( parity_check_fid2cqqidix_d_f )
   , .e                                 ( parity_check_fid2cqqidix_e_f )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_fid2cqqidix_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin0_hp (
     .p                                 ( parity_check_ll_rdylst_bin0_hp_p )
   , .d                                 ( parity_check_ll_rdylst_bin0_hp_d )
   , .e                                 ( parity_check_ll_rdylst_bin0_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin0_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin0_tp (
     .p                                 ( parity_check_ll_rdylst_bin0_tp_p )
   , .d                                 ( parity_check_ll_rdylst_bin0_tp_d )
   , .e                                 ( parity_check_ll_rdylst_bin0_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin0_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin0_hpnxt (
     .p                                 ( parity_check_ll_rdylst_bin0_hpnxt_p )
   , .d                                 ( parity_check_ll_rdylst_bin0_hpnxt_d )
   , .e                                 ( parity_check_ll_rdylst_bin0_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin0_hpnxt_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin1_hp (
     .p                                 ( parity_check_ll_rdylst_bin1_hp_p )
   , .d                                 ( parity_check_ll_rdylst_bin1_hp_d )
   , .e                                 ( parity_check_ll_rdylst_bin1_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin1_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin1_tp (
     .p                                 ( parity_check_ll_rdylst_bin1_tp_p )
   , .d                                 ( parity_check_ll_rdylst_bin1_tp_d )
   , .e                                 ( parity_check_ll_rdylst_bin1_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin1_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin1_hpnxt (
     .p                                 ( parity_check_ll_rdylst_bin1_hpnxt_p )
   , .d                                 ( parity_check_ll_rdylst_bin1_hpnxt_d )
   , .e                                 ( parity_check_ll_rdylst_bin1_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin1_hpnxt_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin2_hp (
     .p                                 ( parity_check_ll_rdylst_bin2_hp_p )
   , .d                                 ( parity_check_ll_rdylst_bin2_hp_d )
   , .e                                 ( parity_check_ll_rdylst_bin2_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin2_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin2_tp (
     .p                                 ( parity_check_ll_rdylst_bin2_tp_p )
   , .d                                 ( parity_check_ll_rdylst_bin2_tp_d )
   , .e                                 ( parity_check_ll_rdylst_bin2_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin2_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin2_hpnxt (
     .p                                 ( parity_check_ll_rdylst_bin2_hpnxt_p )
   , .d                                 ( parity_check_ll_rdylst_bin2_hpnxt_d )
   , .e                                 ( parity_check_ll_rdylst_bin2_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin2_hpnxt_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin3_hp (
     .p                                 ( parity_check_ll_rdylst_bin3_hp_p )
   , .d                                 ( parity_check_ll_rdylst_bin3_hp_d )
   , .e                                 ( parity_check_ll_rdylst_bin3_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin3_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin3_tp (
     .p                                 ( parity_check_ll_rdylst_bin3_tp_p )
   , .d                                 ( parity_check_ll_rdylst_bin3_tp_d )
   , .e                                 ( parity_check_ll_rdylst_bin3_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin3_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH - 1 )
) i_parity_check_ll_rdylst_bin3_hpnxt (
     .p                                 ( parity_check_ll_rdylst_bin3_hpnxt_p )
   , .d                                 ( parity_check_ll_rdylst_bin3_hpnxt_d )
   , .e                                 ( parity_check_ll_rdylst_bin3_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_rdylst_bin3_hpnxt_error )
) ;




hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin0_hp (
     .p                                 ( parity_check_ll_schlst_bin0_hp_p )
   , .d                                 ( parity_check_ll_schlst_bin0_hp_d )
   , .e                                 ( parity_check_ll_schlst_bin0_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin0_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin0_tp (
     .p                                 ( parity_check_ll_schlst_bin0_tp_p )
   , .d                                 ( parity_check_ll_schlst_bin0_tp_d )
   , .e                                 ( parity_check_ll_schlst_bin0_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin0_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin0_hpnxt (
     .p                                 ( parity_check_ll_schlst_bin0_hpnxt_p )
   , .d                                 ( parity_check_ll_schlst_bin0_hpnxt_d )
   , .e                                 ( parity_check_ll_schlst_bin0_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin0_hpnxt_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin0_tpprv (
     .p                                 ( parity_check_ll_schlst_bin0_tpprv_p )
   , .d                                 ( parity_check_ll_schlst_bin0_tpprv_d )
   , .e                                 ( parity_check_ll_schlst_bin0_tpprv_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin0_tpprv_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin1_hp (
     .p                                 ( parity_check_ll_schlst_bin1_hp_p )
   , .d                                 ( parity_check_ll_schlst_bin1_hp_d )
   , .e                                 ( parity_check_ll_schlst_bin1_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin1_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin1_tp (
     .p                                 ( parity_check_ll_schlst_bin1_tp_p )
   , .d                                 ( parity_check_ll_schlst_bin1_tp_d )
   , .e                                 ( parity_check_ll_schlst_bin1_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin1_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin1_hpnxt (
     .p                                 ( parity_check_ll_schlst_bin1_hpnxt_p )
   , .d                                 ( parity_check_ll_schlst_bin1_hpnxt_d )
   , .e                                 ( parity_check_ll_schlst_bin1_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin1_hpnxt_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin1_tpprv (
     .p                                 ( parity_check_ll_schlst_bin1_tpprv_p )
   , .d                                 ( parity_check_ll_schlst_bin1_tpprv_d )
   , .e                                 ( parity_check_ll_schlst_bin1_tpprv_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin1_tpprv_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin2_hp (
     .p                                 ( parity_check_ll_schlst_bin2_hp_p )
   , .d                                 ( parity_check_ll_schlst_bin2_hp_d )
   , .e                                 ( parity_check_ll_schlst_bin2_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin2_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin2_tp (
     .p                                 ( parity_check_ll_schlst_bin2_tp_p )
   , .d                                 ( parity_check_ll_schlst_bin2_tp_d )
   , .e                                 ( parity_check_ll_schlst_bin2_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin2_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin2_hpnxt (
     .p                                 ( parity_check_ll_schlst_bin2_hpnxt_p )
   , .d                                 ( parity_check_ll_schlst_bin2_hpnxt_d )
   , .e                                 ( parity_check_ll_schlst_bin2_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin2_hpnxt_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin2_tpprv (
     .p                                 ( parity_check_ll_schlst_bin2_tpprv_p )
   , .d                                 ( parity_check_ll_schlst_bin2_tpprv_d )
   , .e                                 ( parity_check_ll_schlst_bin2_tpprv_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin2_tpprv_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin3_hp (
     .p                                 ( parity_check_ll_schlst_bin3_hp_p )
   , .d                                 ( parity_check_ll_schlst_bin3_hp_d )
   , .e                                 ( parity_check_ll_schlst_bin3_hp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin3_hp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin3_tp (
     .p                                 ( parity_check_ll_schlst_bin3_tp_p )
   , .d                                 ( parity_check_ll_schlst_bin3_tp_d )
   , .e                                 ( parity_check_ll_schlst_bin3_tp_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin3_tp_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin3_hpnxt (
     .p                                 ( parity_check_ll_schlst_bin3_hpnxt_p )
   , .d                                 ( parity_check_ll_schlst_bin3_hpnxt_d )
   , .e                                 ( parity_check_ll_schlst_bin3_hpnxt_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin3_hpnxt_error )
) ;

hqm_AW_parity_check # (
    .WIDTH                              ( HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH - 1 )
) i_parity_check_ll_schlst_bin3_tpprv (
     .p                                 ( parity_check_ll_schlst_bin3_tpprv_p )
   , .d                                 ( parity_check_ll_schlst_bin3_tpprv_d )
   , .e                                 ( parity_check_ll_schlst_bin3_tpprv_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_ll_schlst_bin3_tpprv_error )
) ;


//....................................................................................................
// RESIDUE

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_rlst_cnt_bin0_data (
   .r                                 ( residue_check_ll_rlst_cnt_bin0_r )
 , .d                                 ( residue_check_ll_rlst_cnt_bin0_d )
 , .e                                 ( residue_check_ll_rlst_cnt_bin0_e )
 , .err                               ( residue_check_ll_rlst_cnt_bin0_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_rlst_cnt_bin1_data (
   .r                                 ( residue_check_ll_rlst_cnt_bin1_r )
 , .d                                 ( residue_check_ll_rlst_cnt_bin1_d )
 , .e                                 ( residue_check_ll_rlst_cnt_bin1_e )
 , .err                               ( residue_check_ll_rlst_cnt_bin1_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_rlst_cnt_bin2_data (
   .r                                 ( residue_check_ll_rlst_cnt_bin2_r )
 , .d                                 ( residue_check_ll_rlst_cnt_bin2_d )
 , .e                                 ( residue_check_ll_rlst_cnt_bin2_e )
 , .err                               ( residue_check_ll_rlst_cnt_bin2_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_rlst_cnt_bin3_data (
   .r                                 ( residue_check_ll_rlst_cnt_bin3_r )
 , .d                                 ( residue_check_ll_rlst_cnt_bin3_d )
 , .e                                 ( residue_check_ll_rlst_cnt_bin3_e )
 , .err                               ( residue_check_ll_rlst_cnt_bin3_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_slst_cnt_bin0_data (
   .r                                 ( residue_check_ll_slst_cnt_bin0_r )
 , .d                                 ( residue_check_ll_slst_cnt_bin0_d )
 , .e                                 ( residue_check_ll_slst_cnt_bin0_e )
 , .err                               ( residue_check_ll_slst_cnt_bin0_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_r_bin0_data (
   .r                                 ( residue_check_enq_cnt_r_bin0_r )
 , .d                                 ( residue_check_enq_cnt_r_bin0_d )
 , .e                                 ( residue_check_enq_cnt_r_bin0_e )
 , .err                               ( residue_check_enq_cnt_r_bin0_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_s_bin0_data (
   .r                                 ( residue_check_enq_cnt_s_bin0_r )
 , .d                                 ( residue_check_enq_cnt_s_bin0_d )
 , .e                                 ( residue_check_enq_cnt_s_bin0_e )
 , .err                               ( residue_check_enq_cnt_s_bin0_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_SCH_CNT_CNTB2 )
) i_residue_check_sch_cnt_bin0_data (
   .r                                 ( residue_check_sch_cnt_bin0_r )
 , .d                                 ( residue_check_sch_cnt_bin0_d )
 , .e                                 ( residue_check_sch_cnt_bin0_e )
 , .err                               ( residue_check_sch_cnt_bin0_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_slst_cnt_bin1_data (
   .r                                 ( residue_check_ll_slst_cnt_bin1_r )
 , .d                                 ( residue_check_ll_slst_cnt_bin1_d )
 , .e                                 ( residue_check_ll_slst_cnt_bin1_e )
 , .err                               ( residue_check_ll_slst_cnt_bin1_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_r_bin1_data (
   .r                                 ( residue_check_enq_cnt_r_bin1_r )
 , .d                                 ( residue_check_enq_cnt_r_bin1_d )
 , .e                                 ( residue_check_enq_cnt_r_bin1_e )
 , .err                               ( residue_check_enq_cnt_r_bin1_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_s_bin1_data (
   .r                                 ( residue_check_enq_cnt_s_bin1_r )
 , .d                                 ( residue_check_enq_cnt_s_bin1_d )
 , .e                                 ( residue_check_enq_cnt_s_bin1_e )
 , .err                               ( residue_check_enq_cnt_s_bin1_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_SCH_CNT_CNTB2 )
) i_residue_check_sch_cnt_bin1_data (
   .r                                 ( residue_check_sch_cnt_bin1_r )
 , .d                                 ( residue_check_sch_cnt_bin1_d )
 , .e                                 ( residue_check_sch_cnt_bin1_e )
 , .err                               ( residue_check_sch_cnt_bin1_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_slst_cnt_bin2_data (
   .r                                 ( residue_check_ll_slst_cnt_bin2_r )
 , .d                                 ( residue_check_ll_slst_cnt_bin2_d )
 , .e                                 ( residue_check_ll_slst_cnt_bin2_e )
 , .err                               ( residue_check_ll_slst_cnt_bin2_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_r_bin2_data (
   .r                                 ( residue_check_enq_cnt_r_bin2_r )
 , .d                                 ( residue_check_enq_cnt_r_bin2_d )
 , .e                                 ( residue_check_enq_cnt_r_bin2_e )
 , .err                               ( residue_check_enq_cnt_r_bin2_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_s_bin2_data (
   .r                                 ( residue_check_enq_cnt_s_bin2_r )
 , .d                                 ( residue_check_enq_cnt_s_bin2_d )
 , .e                                 ( residue_check_enq_cnt_s_bin2_e )
 , .err                               ( residue_check_enq_cnt_s_bin2_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_SCH_CNT_CNTB2 )
) i_residue_check_sch_cnt_bin2_data (
   .r                                 ( residue_check_sch_cnt_bin2_r )
 , .d                                 ( residue_check_sch_cnt_bin2_d )
 , .e                                 ( residue_check_sch_cnt_bin2_e )
 , .err                               ( residue_check_sch_cnt_bin2_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_ll_slst_cnt_bin3_data (
   .r                                 ( residue_check_ll_slst_cnt_bin3_r )
 , .d                                 ( residue_check_ll_slst_cnt_bin3_d )
 , .e                                 ( residue_check_ll_slst_cnt_bin3_e )
 , .err                               ( residue_check_ll_slst_cnt_bin3_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_r_bin3_data (
   .r                                 ( residue_check_enq_cnt_r_bin3_r )
 , .d                                 ( residue_check_enq_cnt_r_bin3_d )
 , .e                                 ( residue_check_enq_cnt_r_bin3_e )
 , .err                               ( residue_check_enq_cnt_r_bin3_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_CNTB2 )
) i_residue_check_enq_cnt_s_bin3_data (
   .r                                 ( residue_check_enq_cnt_s_bin3_r )
 , .d                                 ( residue_check_enq_cnt_s_bin3_d )
 , .e                                 ( residue_check_enq_cnt_s_bin3_e )
 , .err                               ( residue_check_enq_cnt_s_bin3_err )
) ;

hqm_AW_residue_check # (
   .WIDTH                             ( HQM_ATM_SCH_CNT_CNTB2 )
) i_residue_check_sch_cnt_bin3_data (
   .r                                 ( residue_check_sch_cnt_bin3_r )
 , .d                                 ( residue_check_sch_cnt_bin3_d )
 , .e                                 ( residue_check_sch_cnt_bin3_e )
 , .err                               ( residue_check_sch_cnt_bin3_err )
) ;

hqm_AW_residue_add i_residue_add_enq_cnt_r (
   .a                                 ( residue_add_enq_cnt_r_a )
 , .b                                 ( residue_add_enq_cnt_r_b )
 , .r                                 ( residue_add_enq_cnt_r_r )
) ;

hqm_AW_residue_sub i_residue_sub_enq_cnt_r (
   .a                                 ( residue_sub_enq_cnt_r_a )
 , .b                                 ( residue_sub_enq_cnt_r_b )
 , .r                                 ( residue_sub_enq_cnt_r_r )
) ;

hqm_AW_residue_add i_residue_add_enq_cnt_s (
   .a                                 ( residue_add_enq_cnt_s_a )
 , .b                                 ( residue_add_enq_cnt_s_b )
 , .r                                 ( residue_add_enq_cnt_s_r )
) ;

hqm_AW_residue_sub i_residue_sub_enq_cnt_s (
   .a                                 ( residue_sub_enq_cnt_s_a )
 , .b                                 ( residue_sub_enq_cnt_s_b )
 , .r                                 ( residue_sub_enq_cnt_s_r )
) ;

hqm_AW_residue_add i_residue_add_sch_cnt (
   .a                                 ( residue_add_sch_cnt_a )
 , .b                                 ( residue_add_sch_cnt_b )
 , .r                                 ( residue_add_sch_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_sch_cnt (
   .a                                 ( residue_sub_sch_cnt_a )
 , .b                                 ( residue_sub_sch_cnt_b )
 , .r                                 ( residue_sub_sch_cnt_r )
) ;


hqm_AW_residue_add i_residue_add_slst_cnt (
   .a                                 ( residue_add_slst_cnt_a )
 , .b                                 ( residue_add_slst_cnt_b )
 , .r                                 ( residue_add_slst_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_slst_cnt (
   .a                                 ( residue_sub_slst_cnt_a )
 , .b                                 ( residue_sub_slst_cnt_b )
 , .r                                 ( residue_sub_slst_cnt_r )
) ;


hqm_AW_residue_add i_residue_add_rlst_cnt (
   .a                                 ( residue_add_rlst_cnt_a )
 , .b                                 ( residue_add_rlst_cnt_b )
 , .r                                 ( residue_add_rlst_cnt_r )
) ;

hqm_AW_residue_sub i_residue_sub_rlst_cnt (
   .a                                 ( residue_sub_rlst_cnt_a )
 , .b                                 ( residue_sub_rlst_cnt_b )
 , .r                                 ( residue_sub_rlst_cnt_r )
) ;



hqm_AW_residue_add i_m_residue_add_slst_cnt_0 (
   .a                                 ( m_residue_add_slst_cnt_a [ 0 * 2 +: 2 ] )
 , .b                                 ( m_residue_add_slst_cnt_b [ 0 * 2 +: 2 ] )
 , .r                                 ( m_residue_add_slst_cnt_r [ 0 * 2 +: 2 ] )
) ;
hqm_AW_residue_add i_m_residue_add_slst_cnt_1 (
   .a                                 ( m_residue_add_slst_cnt_a [ 1 * 2 +: 2 ] )
 , .b                                 ( m_residue_add_slst_cnt_b [ 1 * 2 +: 2 ] )
 , .r                                 ( m_residue_add_slst_cnt_r [ 1 * 2 +: 2 ] )
) ;
hqm_AW_residue_add i_m_residue_add_slst_cnt_2 (
   .a                                 ( m_residue_add_slst_cnt_a [ 2 * 2 +: 2 ] )
 , .b                                 ( m_residue_add_slst_cnt_b [ 2 * 2 +: 2 ] )
 , .r                                 ( m_residue_add_slst_cnt_r [ 2 * 2 +: 2 ] )
) ;
hqm_AW_residue_add i_m_residue_add_slst_cnt_3 (
   .a                                 ( m_residue_add_slst_cnt_a [ 3 * 2 +: 2 ] )
 , .b                                 ( m_residue_add_slst_cnt_b [ 3 * 2 +: 2 ] )
 , .r                                 ( m_residue_add_slst_cnt_r [ 3 * 2 +: 2 ] )
) ;

hqm_AW_residue_sub i_m_residue_sub_slst_cnt_0 (
   .a                                 ( m_residue_sub_slst_cnt_a [ 0 * 2 +: 2 ] )
 , .b                                 ( m_residue_sub_slst_cnt_b [ 0 * 2 +: 2 ] )
 , .r                                 ( m_residue_sub_slst_cnt_r [ 0 * 2 +: 2 ] )
) ;
hqm_AW_residue_sub i_m_residue_sub_slst_cnt_1 (
   .a                                 ( m_residue_sub_slst_cnt_a [ 1 * 2 +: 2 ] )
 , .b                                 ( m_residue_sub_slst_cnt_b [ 1 * 2 +: 2 ] )
 , .r                                 ( m_residue_sub_slst_cnt_r [ 1 * 2 +: 2 ] )
) ;
hqm_AW_residue_sub i_m_residue_sub_slst_cnt_2 (
   .a                                 ( m_residue_sub_slst_cnt_a [ 2 * 2 +: 2 ] )
 , .b                                 ( m_residue_sub_slst_cnt_b [ 2 * 2 +: 2 ] )
 , .r                                 ( m_residue_sub_slst_cnt_r [ 2 * 2 +: 2 ] )
) ;
hqm_AW_residue_sub i_m_residue_sub_slst_cnt_3 (
   .a                                 ( m_residue_sub_slst_cnt_a [ 3 * 2 +: 2 ] )
 , .b                                 ( m_residue_sub_slst_cnt_b [ 3 * 2 +: 2 ] )
 , .r                                 ( m_residue_sub_slst_cnt_r [ 3 * 2 +: 2 ] )
) ;


//....................................................................................................
// FIFO
assign fifo_ap_aqed_error_of = fifo_ap_aqed_status [ 1 ] ;
assign fifo_ap_aqed_error_uf = fifo_ap_aqed_status [ 0 ] ;
assign fifo_ap_aqed_cfg_high_wm = hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_f [ HQM_ATM_FIFO_AP_AQED_WMWIDTH - 1 : 0 ] ;
assign hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_nxt = { fifo_ap_aqed_status [ 23 : 0 ] , hqm_ap_target_cfg_fifo_wmstat_ap_aqed_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_ATM_FIFO_AP_AQED_DEPTH )
  , .DWIDTH                             ( HQM_ATM_FIFO_AP_AQED_DWIDTH )
) i_fifo_ap_aqed (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_ap_aqed_cfg_high_wm )
  , .fifo_status                        ( fifo_ap_aqed_status )
  , .push                               ( fifo_ap_aqed_push )
  , .push_data                          ( { fifo_ap_aqed_push_data } )
  , .pop                                ( fifo_ap_aqed_pop )
  , .pop_data                           ( { fifo_ap_aqed_pop_data } )
  , .fifo_full                          ( fifo_ap_aqed_full )
  , .fifo_afull                         ( fifo_ap_aqed_afull )
  , .fifo_empty                         ( fifo_ap_aqed_empty )
  , .mem_we                             ( func_atm_fifo_ap_aqed_we )
  , .mem_waddr                          ( func_atm_fifo_ap_aqed_waddr )
  , .mem_wdata                          ( func_atm_fifo_ap_aqed_wdata )
  , .mem_re                             ( func_atm_fifo_ap_aqed_re )
  , .mem_raddr                          ( func_atm_fifo_ap_aqed_raddr )
  , .mem_rdata                          ( func_atm_fifo_ap_aqed_rdata )
) ;

assign fifo_aqed_ap_enq_error_of = fifo_aqed_ap_enq_status [ 1 ] ;
assign fifo_aqed_ap_enq_error_uf = fifo_aqed_ap_enq_status [ 0 ] ;
assign fifo_aqed_ap_enq_cfg_high_wm = hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f [ HQM_ATM_FIFO_AQED_AP_ENQ_WMWIDTH - 1 : 0 ] ;
assign hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_nxt = { fifo_aqed_ap_enq_status [ 23 : 0 ] , hqm_ap_target_cfg_fifo_wmstat_aqed_ap_enq_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control_latepp # (
    .DEPTH                              ( HQM_ATM_FIFO_AQED_AP_ENQ_DEPTH )
  , .DWIDTH                             ( HQM_ATM_FIFO_AQED_AP_ENQ_DWIDTH )
) i_fifo_aqed_ap_enq (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_aqed_ap_enq_cfg_high_wm )
  , .fifo_status                        ( fifo_aqed_ap_enq_status )
  , .push                               ( fifo_aqed_ap_enq_push )
  , .push_data                          ( { fifo_aqed_ap_enq_push_data } )
  , .pop                                ( fifo_aqed_ap_enq_pop )
  , .pop_data                           ( { fifo_aqed_ap_enq_pop_data } )
  , .fifo_full                          ( fifo_aqed_ap_enq_full )
  , .fifo_afull                         ( fifo_aqed_ap_enq_afull )
  , .fifo_empty                         ( fifo_aqed_ap_enq_empty )
  , .mem_we                             ( func_atm_fifo_aqed_ap_enq_we )
  , .mem_waddr                          ( func_atm_fifo_aqed_ap_enq_waddr )
  , .mem_wdata                          ( func_atm_fifo_aqed_ap_enq_wdata )
  , .mem_re                             ( func_atm_fifo_aqed_ap_enq_re )
  , .mem_raddr                          ( func_atm_fifo_aqed_ap_enq_raddr )
  , .mem_rdata                          ( func_atm_fifo_aqed_ap_enq_rdata )
) ;

logic                  func_atm_fifo_ap_lsp_enq_re_nc; //I
logic [(       4)-1:0] func_atm_fifo_ap_lsp_enq_raddr_nc; //I
logic [(       4)-1:0] func_atm_fifo_ap_lsp_enq_waddr_nc; //I
logic                  func_atm_fifo_ap_lsp_enq_we_nc;    //I
logic [(       8)-1:0] func_atm_fifo_ap_lsp_enq_wdata_nc; //I
logic [(       8)-1:0] func_atm_fifo_ap_lsp_enq_rdata;
assign func_atm_fifo_ap_lsp_enq_rdata = '0 ;

assign fifo_ap_lsp_enq_error_of = fifo_ap_lsp_enq_status [ 1 ] ;
assign fifo_ap_lsp_enq_error_uf = fifo_ap_lsp_enq_status [ 0 ] ;
assign fifo_ap_lsp_enq_cfg_high_wm = hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_f [ HQM_ATM_FIFO_AP_LSP_ENQ_WMWIDTH - 1 : 0 ] ;
assign hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_nxt = { fifo_ap_lsp_enq_status [ 23 : 0 ] , hqm_ap_target_cfg_fifo_wmstat_ap_lsp_enq_if_reg_f [ 7 : 0 ] } ;
hqm_AW_fifo_control # (
    .DEPTH                              ( HQM_ATM_FIFO_AP_LSP_ENQ_DEPTH )
  , .DWIDTH                             ( HQM_ATM_FIFO_AP_LSP_ENQ_DWIDTH )
) i_fifo_ap_lsp_enq (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_high_wm                        ( fifo_ap_lsp_enq_cfg_high_wm )
  , .fifo_status                        ( fifo_ap_lsp_enq_status )
  , .push                               ( fifo_ap_lsp_enq_push )
  , .push_data                          ( { fifo_ap_lsp_enq_push_data } )
  , .pop                                ( fifo_ap_lsp_enq_pop )
  , .pop_data                           ( { fifo_ap_lsp_enq_pop_data } )
  , .fifo_full                          ( fifo_ap_lsp_enq_full )
  , .fifo_afull                         ( fifo_ap_lsp_enq_afull )
  , .fifo_empty                         ( fifo_ap_lsp_enq_empty )
  , .mem_we                             ( func_atm_fifo_ap_lsp_enq_we_nc )
  , .mem_waddr                          ( func_atm_fifo_ap_lsp_enq_waddr_nc )
  , .mem_wdata                          ( func_atm_fifo_ap_lsp_enq_wdata_nc )
  , .mem_re                             ( func_atm_fifo_ap_lsp_enq_re_nc )
  , .mem_raddr                          ( func_atm_fifo_ap_lsp_enq_raddr_nc )
  , .mem_rdata                          ( func_atm_fifo_ap_lsp_enq_rdata )
) ;





hqm_lsp_atm_enq_reg i_lsp_atm_enqueue0 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .push ( fifo_enqueue0_push )
  , .push_cq ( fifo_enqueue0_push_cq )
  , .push_qid ( fifo_enqueue0_push_qid )
  , .push_qidix ( fifo_enqueue0_push_qidix )
  , .push_parity ( fifo_enqueue0_push_parity )
  , .push_qpri ( fifo_enqueue0_push_qpri )
  , .push_bin ( fifo_enqueue0_push_bin )
  , .push_fid ( fifo_enqueue0_push_fid )
  , .push_fid_parity ( fifo_enqueue0_push_fid_parity )
  , .pop ( fifo_enqueue0_pop )
  , .pop_cq ( fifo_enqueue0_pop_cq )
  , .pop_qid ( fifo_enqueue0_pop_qid )
  , .pop_qidix ( fifo_enqueue0_pop_qidix )
  , .pop_parity ( fifo_enqueue0_pop_parity )
  , .pop_qpri ( fifo_enqueue0_pop_qpri )
  , .pop_bin ( fifo_enqueue0_pop_bin )
  , .pop_fid ( fifo_enqueue0_pop_fid )
  , .pop_fid_parity ( fifo_enqueue0_pop_fid_parity )
  , .pop_v ( fifo_enqueue0_pop_v )
  , .hold_v ( fifo_enqueue0_hold_v )
  , .byp ( fifo_enqueue0_byp  )
  , .byp_fid ( fifo_enqueue0_byp_fid )
  , .byp_cq ( fifo_enqueue0_byp_cq )
  , .byp_qidix ( fifo_enqueue0_byp_qidix )
) ;

hqm_lsp_atm_enq_reg i_lsp_atm_enqueue1 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .push ( fifo_enqueue1_push )
  , .push_cq ( fifo_enqueue1_push_cq )
  , .push_qid ( fifo_enqueue1_push_qid )
  , .push_qidix ( fifo_enqueue1_push_qidix )
  , .push_parity ( fifo_enqueue1_push_parity )
  , .push_qpri ( fifo_enqueue1_push_qpri )
  , .push_bin ( fifo_enqueue1_push_bin )
  , .push_fid ( fifo_enqueue1_push_fid )
  , .push_fid_parity ( fifo_enqueue1_push_fid_parity )
  , .pop ( fifo_enqueue1_pop )
  , .pop_cq ( fifo_enqueue1_pop_cq )
  , .pop_qid ( fifo_enqueue1_pop_qid )
  , .pop_qidix ( fifo_enqueue1_pop_qidix )
  , .pop_parity ( fifo_enqueue1_pop_parity )
  , .pop_qpri ( fifo_enqueue1_pop_qpri )
  , .pop_bin ( fifo_enqueue1_pop_bin )
  , .pop_fid ( fifo_enqueue1_pop_fid )
  , .pop_fid_parity ( fifo_enqueue1_pop_fid_parity )
  , .pop_v ( fifo_enqueue1_pop_v )
  , .hold_v ( fifo_enqueue1_hold_v )
  , .byp ( fifo_enqueue1_byp  )
  , .byp_fid ( fifo_enqueue1_byp_fid )
  , .byp_cq ( fifo_enqueue1_byp_cq )
  , .byp_qidix ( fifo_enqueue1_byp_qidix )
) ;

hqm_lsp_atm_enq_reg i_lsp_atm_enqueue2 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .push ( fifo_enqueue2_push )
  , .push_cq ( fifo_enqueue2_push_cq )
  , .push_qid ( fifo_enqueue2_push_qid )
  , .push_qidix ( fifo_enqueue2_push_qidix )
  , .push_parity ( fifo_enqueue2_push_parity )
  , .push_qpri ( fifo_enqueue2_push_qpri )
  , .push_bin ( fifo_enqueue2_push_bin )
  , .push_fid ( fifo_enqueue2_push_fid )
  , .push_fid_parity ( fifo_enqueue2_push_fid_parity )
  , .pop ( fifo_enqueue2_pop )
  , .pop_cq ( fifo_enqueue2_pop_cq )
  , .pop_qid ( fifo_enqueue2_pop_qid )
  , .pop_qidix ( fifo_enqueue2_pop_qidix )
  , .pop_parity ( fifo_enqueue2_pop_parity )
  , .pop_qpri ( fifo_enqueue2_pop_qpri )
  , .pop_bin ( fifo_enqueue2_pop_bin )
  , .pop_fid ( fifo_enqueue2_pop_fid )
  , .pop_fid_parity ( fifo_enqueue2_pop_fid_parity )
  , .pop_v ( fifo_enqueue2_pop_v )
  , .hold_v ( fifo_enqueue2_hold_v )
  , .byp ( fifo_enqueue2_byp  )
  , .byp_fid ( fifo_enqueue2_byp_fid )
  , .byp_cq ( fifo_enqueue2_byp_cq )
  , .byp_qidix ( fifo_enqueue2_byp_qidix )
) ;

hqm_lsp_atm_enq_reg i_lsp_atm_enqueue3 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .push ( fifo_enqueue3_push )
  , .push_cq ( fifo_enqueue3_push_cq )
  , .push_qid ( fifo_enqueue3_push_qid )
  , .push_qidix ( fifo_enqueue3_push_qidix )
  , .push_parity ( fifo_enqueue3_push_parity )
  , .push_qpri ( fifo_enqueue3_push_qpri )
  , .push_bin ( fifo_enqueue3_push_bin )
  , .push_fid ( fifo_enqueue3_push_fid )
  , .push_fid_parity ( fifo_enqueue3_push_fid_parity )
  , .pop ( fifo_enqueue3_pop )
  , .pop_cq ( fifo_enqueue3_pop_cq )
  , .pop_qid ( fifo_enqueue3_pop_qid )
  , .pop_qidix ( fifo_enqueue3_pop_qidix )
  , .pop_parity ( fifo_enqueue3_pop_parity )
  , .pop_qpri ( fifo_enqueue3_pop_qpri )
  , .pop_bin ( fifo_enqueue3_pop_bin )
  , .pop_fid ( fifo_enqueue3_pop_fid )
  , .pop_fid_parity ( fifo_enqueue3_pop_fid_parity )
  , .pop_v ( fifo_enqueue3_pop_v )
  , .hold_v ( fifo_enqueue3_hold_v )
  , .byp ( fifo_enqueue3_byp  )
  , .byp_fid ( fifo_enqueue3_byp_fid )
  , .byp_cq ( fifo_enqueue3_byp_cq )
  , .byp_qidix ( fifo_enqueue3_byp_qidix )
) ;




//....................................................................................................
// ARB

hqm_AW_strict_arb # (
    .NUM_REQS ( 2 )
) i_arb_ll_strict (
    .reqs                               ( arb_ll_strict_reqs )
  , .winner_v                           ( arb_ll_strict_winner_v )
  , .winner                             ( arb_ll_strict_winner )
) ;


hqm_AW_wrand_arb # (
    .NUM_REQS ( 4 )
) i_arb_ll_sch (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control2_f [ 31 : 24 ] , cfg_control2_f [ 23 : 16 ] , cfg_control2_f [ 15 : 8 ] , cfg_control2_f [ 7 : 0 ] } )
  , .reqs                               ( arb_ll_sch_reqs )
  , .winner_v                           ( arb_ll_sch_winner_v )
  , .winner                             ( arb_ll_sch_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 4 )
) i_arb_ll_rdy (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control1_f [ 31 : 24 ] , cfg_control1_f [ 23 : 16 ] , cfg_control1_f [ 15 : 8 ] , cfg_control1_f [ 7 : 0 ] } )
  , .reqs                               ( arb_ll_rdy_reqs )
  , .winner_v                           ( arb_ll_rdy_winner_v )
  , .winner                             ( arb_ll_rdy_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 4 )
) i_arb_ll_rdy_pri_dup0 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control1_f [ 31 : 24 ] , cfg_control1_f [ 23 : 16 ] , cfg_control1_f [ 15 : 8 ] , cfg_control1_f [ 7 : 0 ] } )
  , .reqs                               ( arb_ll_rdy_pri_dup0_reqs )
  , .winner_v                           ( arb_ll_rdy_pri_dup0_winner_v_nc )
  , .winner                             ( arb_ll_rdy_pri_dup0_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 4 )
) i_arb_ll_rdy_pri_dup1 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control1_f [ 31 : 24 ] , cfg_control1_f [ 23 : 16 ] , cfg_control1_f [ 15 : 8 ] , cfg_control1_f [ 7 : 0 ] } )
  , .reqs                               ( arb_ll_rdy_pri_dup1_reqs )
  , .winner_v                           ( arb_ll_rdy_pri_dup1_winner_v_nc )
  , .winner                             ( arb_ll_rdy_pri_dup1_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 4 )
) i_arb_ll_rdy_pri_dup2 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control1_f [ 31 : 24 ] , cfg_control1_f [ 23 : 16 ] , cfg_control1_f [ 15 : 8 ] , cfg_control1_f [ 7 : 0 ] } )
  , .reqs                               ( arb_ll_rdy_pri_dup2_reqs )
  , .winner_v                           ( arb_ll_rdy_pri_dup2_winner_v_nc )
  , .winner                             ( arb_ll_rdy_pri_dup2_winner )
) ;

hqm_AW_wrand_arb # (
    .NUM_REQS ( 4 )
) i_arb_ll_rdy_pri_dup3 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg_weight                         ( { cfg_control1_f [ 31 : 24 ] , cfg_control1_f [ 23 : 16 ] , cfg_control1_f [ 15 : 8 ] , cfg_control1_f [ 7 : 0 ] } )
  , .reqs                               ( arb_ll_rdy_pri_dup3_reqs )
  , .winner_v                           ( arb_ll_rdy_pri_dup3_winner_v_nc )
  , .winner                             ( arb_ll_rdy_pri_dup3_winner )
) ;


//....................................................................................................
// RAM RW or RMW PIPELINE





hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_ATM_FID2CQQIDIX_DEPTH )
  , .WIDTH                              ( HQM_ATM_FID2CQQIDIX_DWIDTH )
) i_rmw_fid2cqqidix (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_fid2cqqidix_status )

  , .p0_v_nxt                           ( rmw_fid2cqqidix_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_fid2cqqidix_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_fid2cqqidix_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_fid2cqqidix_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_fid2cqqidix_p0_hold )
  , .p0_v_f                             ( rmw_fid2cqqidix_p0_v_f )
  , .p0_rw_f                            ( rmw_fid2cqqidix_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_fid2cqqidix_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_fid2cqqidix_p0_data_f_nc )

  , .p1_hold                            ( rmw_fid2cqqidix_p1_hold )
  , .p1_v_f                             ( rmw_fid2cqqidix_p1_v_f )
  , .p1_rw_f                            ( rmw_fid2cqqidix_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_fid2cqqidix_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_fid2cqqidix_p1_data_f_nc )

  , .p2_hold                            ( rmw_fid2cqqidix_p2_hold )
  , .p2_v_f                             ( rmw_fid2cqqidix_p2_v_f )
  , .p2_rw_f                            ( rmw_fid2cqqidix_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_fid2cqqidix_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_fid2cqqidix_p2_data_f )

  , .p3_hold                            ( rmw_fid2cqqidix_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_fid2cqqidix_p3_bypdata_sel_nxt )
  , .p3_bypdata_nxt                     ( rmw_fid2cqqidix_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_fid2cqqidix_p3_bypaddr_sel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_fid2cqqidix_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_fid2cqqidix_p3_v_f )
  , .p3_rw_f                            ( rmw_fid2cqqidix_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_fid2cqqidix_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_fid2cqqidix_p3_data_f_nc )

  , .mem_write                          ( func_fid2cqqidix_we )
  , .mem_read                           ( func_fid2cqqidix_re )
  , .mem_write_addr                     ( func_fid2cqqidix_waddr )
  , .mem_read_addr                      ( func_fid2cqqidix_raddr )
  , .mem_write_data                     ( func_fid2cqqidix_wdata )
  , .mem_read_data                      ( func_fid2cqqidix_rdata )
) ;


hqm_AW_rmw_mem_4pipe_waddr # (
    .DEPTH                              ( HQM_ATM_QID_RDYLST_CLAMP_DEPTH )
  , .WIDTH                              ( HQM_ATM_QID_RDYLST_CLAMP_DWIDTH )
) i_rmw_qid_rdylst_clamp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_qid_rdylst_clamp_status )

  , .p0_v_nxt                           ( rmw_qid_rdylst_clamp_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_qid_rdylst_clamp_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_qid_rdylst_clamp_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_qid_rdylst_clamp_p0_write_data_nxt_nc )
  , .p0_hold                            ( rmw_qid_rdylst_clamp_p0_hold )
  , .p0_v_f                             ( rmw_qid_rdylst_clamp_p0_v_f_nc )
  , .p0_rw_f                            ( rmw_qid_rdylst_clamp_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_qid_rdylst_clamp_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_qid_rdylst_clamp_p0_data_f_nc )

  , .p1_hold                            ( rmw_qid_rdylst_clamp_p1_hold )
  , .p1_v_f                             ( rmw_qid_rdylst_clamp_p1_v_f_nc )
  , .p1_rw_f                            ( rmw_qid_rdylst_clamp_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_qid_rdylst_clamp_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_qid_rdylst_clamp_p1_data_f_nc )

  , .p2_hold                            ( rmw_qid_rdylst_clamp_p2_hold )
  , .p2_v_f                             ( rmw_qid_rdylst_clamp_p2_v_f_nc )
  , .p2_rw_f                            ( rmw_qid_rdylst_clamp_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_qid_rdylst_clamp_p2_addr_f_nc )
  , .p2_data_f                          ( rmw_qid_rdylst_clamp_p2_data_f )

  , .p3_hold                            ( rmw_qid_rdylst_clamp_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_qid_rdylst_clamp_p3_bypdata_sel_nxt )
  , .p3_bypdata_nxt                     ( rmw_qid_rdylst_clamp_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_qid_rdylst_clamp_p3_bypaddr_sel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_qid_rdylst_clamp_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_qid_rdylst_clamp_p3_v_f_nc )
  , .p3_rw_f                            ( rmw_qid_rdylst_clamp_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_qid_rdylst_clamp_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_qid_rdylst_clamp_p3_data_f_nc )

  , .mem_write                          ( func_qid_rdylst_clamp_we )
  , .mem_read                           ( func_qid_rdylst_clamp_re )
  , .mem_write_addr                     ( func_qid_rdylst_clamp_waddr )
  , .mem_read_addr                      ( func_qid_rdylst_clamp_raddr )
  , .mem_write_data                     ( func_qid_rdylst_clamp_wdata )
  , .mem_read_data                      ( func_qid_rdylst_clamp_rdata )
) ;



generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_rdylst_hp
hqm_lsp_atm_rmw_mem_4pipe_waddr_wparity # (
    .DEPTH                              ( HQM_ATM_LL_RDYLST_HP_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH )
) i_rmw_ll_rdylst_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_rdylst_hp_status [ ( g * 1 ) +: 1 ] )
  , .error                              ( rmw_ll_rdylst_hp_error [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_rdylst_hp_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_rdylst_hp_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_rdylst_hp_p0_addr_nxt [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_rdylst_hp_p0_write_data_nxt_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_rdylst_hp_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_rdylst_hp_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_rdylst_hp_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_rdylst_hp_p0_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_rdylst_hp_p0_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_rdylst_hp_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_rdylst_hp_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_rdylst_hp_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_rdylst_hp_p1_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_rdylst_hp_p1_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_rdylst_hp_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_rdylst_hp_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_rdylst_hp_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_rdylst_hp_p2_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_rdylst_hp_p2_data_f [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_rdylst_hp_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_rdylst_hp_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_rdylst_hp_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_rdylst_hp_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_rdylst_hp_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_rdylst_hp_p3_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_rdylst_hp_p3_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_rdylst_hp_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_rdylst_hp_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_rdylst_hp_waddr [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_rdylst_hp_raddr [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_rdylst_hp_wdata [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ] )
  , .mem_read_data                      ( func_ll_rdylst_hp_rdata [ ( g * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ] )
) ;
end
endgenerate



generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_rdylst_tp
hqm_lsp_atm_rmw_mem_4pipe_waddr_wparity # (
    .DEPTH                              ( HQM_ATM_LL_RDYLST_TP_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH )
) i_rmw_ll_rdylst_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_rdylst_tp_status [ ( g * 1 ) +: 1 ] )
  , .error                              ( rmw_ll_rdylst_tp_error [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_rdylst_tp_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_rdylst_tp_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_rdylst_tp_p0_addr_nxt [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_rdylst_tp_p0_write_data_nxt_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_rdylst_tp_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_rdylst_tp_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_rdylst_tp_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_rdylst_tp_p0_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_rdylst_tp_p0_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_rdylst_tp_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_rdylst_tp_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_rdylst_tp_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_rdylst_tp_p1_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_rdylst_tp_p1_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_rdylst_tp_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_rdylst_tp_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_rdylst_tp_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_rdylst_tp_p2_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_rdylst_tp_p2_data_f [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_rdylst_tp_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_rdylst_tp_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_rdylst_tp_p3_bypdata_nxt [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_rdylst_tp_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_rdylst_tp_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_rdylst_tp_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_rdylst_tp_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_rdylst_tp_p3_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_rdylst_tp_p3_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_rdylst_tp_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_rdylst_tp_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_rdylst_tp_waddr [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_rdylst_tp_raddr [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_rdylst_tp_wdata [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ] )
  , .mem_read_data                      ( func_ll_rdylst_tp_rdata [ ( g * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ] )
) ;
end
endgenerate



generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_rdylst_hpnxt
hqm_lsp_atm_rmw_mem_4pipe_core_wparity # (
    .DEPTH                              ( HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH )
) i_rmw_ll_rdylst_hpnxt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_rdylst_hpnxt_status [ ( g * 1 ) +: 1 ] )
  , .error                              ( rmw_ll_rdylst_hpnxt_error [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_rdylst_hpnxt_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_rdylst_hpnxt_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_rdylst_hpnxt_p0_addr_nxt [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_rdylst_hpnxt_p0_write_data_nxt [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_rdylst_hpnxt_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_rdylst_hpnxt_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_rdylst_hpnxt_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_rdylst_hpnxt_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_rdylst_hpnxt_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_rdylst_hpnxt_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_rdylst_hpnxt_p0_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_rdylst_hpnxt_p0_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_rdylst_hpnxt_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_rdylst_hpnxt_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_rdylst_hpnxt_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_rdylst_hpnxt_p1_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_rdylst_hpnxt_p1_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_rdylst_hpnxt_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_rdylst_hpnxt_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_rdylst_hpnxt_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_rdylst_hpnxt_p2_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_rdylst_hpnxt_p2_data_f [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_rdylst_hpnxt_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_rdylst_hpnxt_p3_bypdata_nxt [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_rdylst_hpnxt_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_rdylst_hpnxt_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_rdylst_hpnxt_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_rdylst_hpnxt_p3_addr_f_nc [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_rdylst_hpnxt_p3_data_f_nc [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_rdylst_hpnxt_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_rdylst_hpnxt_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_rdylst_hpnxt_waddr [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_rdylst_hpnxt_raddr [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_rdylst_hpnxt_wdata [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ] )
  , .mem_read_data                      ( func_ll_rdylst_hpnxt_rdata [ ( g * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ] )
) ;
end
endgenerate



hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_RLST_CNT_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_RLST_CNT_DWIDTH )
) i_rmw_ll_rlst_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_rlst_cnt_status )

  , .p0_v_nxt                           ( rmw_ll_rlst_cnt_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_ll_rlst_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_ll_rlst_cnt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_ll_rlst_cnt_p0_write_data_nxt )
  , .p0_byp_v_nxt                           ( rmw_ll_rlst_cnt_p0_byp_v_nxt )
  , .p0_byp_rw_nxt                          ( rmw_ll_rlst_cnt_p0_byp_rw_nxt )
  , .p0_byp_addr_nxt                        ( rmw_ll_rlst_cnt_p0_byp_addr_nxt )
  , .p0_byp_write_data_nxt                  ( rmw_ll_rlst_cnt_p0_byp_write_data_nxt )
  , .p0_hold                            ( rmw_ll_rlst_cnt_p0_hold )
  , .p0_v_f                             ( rmw_ll_rlst_cnt_p0_v_f )
  , .p0_rw_f                            ( rmw_ll_rlst_cnt_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_ll_rlst_cnt_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_ll_rlst_cnt_p0_data_f_nc )

  , .p1_hold                            ( rmw_ll_rlst_cnt_p1_hold )
  , .p1_v_f                             ( rmw_ll_rlst_cnt_p1_v_f )
  , .p1_rw_f                            ( rmw_ll_rlst_cnt_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_ll_rlst_cnt_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_ll_rlst_cnt_p1_data_f_nc )

  , .p2_hold                            ( rmw_ll_rlst_cnt_p2_hold )
  , .p2_v_f                             ( rmw_ll_rlst_cnt_p2_v_f )
  , .p2_rw_f                            ( rmw_ll_rlst_cnt_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_ll_rlst_cnt_p2_addr_f_nc )
  , .p2_data_nxt                        ( rmw_ll_rlst_cnt_p2_data_nxt_nc )
  , .p2_data_f                          ( rmw_ll_rlst_cnt_p2_data_f )

  , .p3_hold                            ( rmw_ll_rlst_cnt_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_rlst_cnt_p3_bypdata_sel_nxt )
  , .p3_bypdata_nxt                     ( rmw_ll_rlst_cnt_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_rlst_cnt_p3_bypaddr_sel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_ll_rlst_cnt_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_ll_rlst_cnt_p3_v_f )
  , .p3_rw_f                            ( rmw_ll_rlst_cnt_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_ll_rlst_cnt_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_ll_rlst_cnt_p3_data_f_nc )

  , .mem_write                          ( func_ll_rlst_cnt_we )
  , .mem_read                           ( func_ll_rlst_cnt_re )
  , .mem_write_addr                     ( func_ll_rlst_cnt_waddr )
  , .mem_read_addr                      ( func_ll_rlst_cnt_raddr )
  , .mem_write_data                     ( func_ll_rlst_cnt_wdata )
  , .mem_read_data                      ( func_ll_rlst_cnt_rdata )
) ;




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_schlst_hp
hqm_lsp_atm_rmw_mem_4pipe_waddr_wparity # (
    .DEPTH                              ( HQM_ATM_LL_SCHLST_HP_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH )
) i_rmw_ll_schlst_hp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_schlst_hp_status [ ( g * 1 ) +: 1 ] )
  , .error                              ( rmw_ll_schlst_hp_error [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_schlst_hp_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_schlst_hp_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_schlst_hp_p0_addr_nxt [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_schlst_hp_p0_write_data_nxt_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_schlst_hp_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_schlst_hp_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_schlst_hp_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_schlst_hp_p0_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_schlst_hp_p0_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_schlst_hp_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_schlst_hp_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_schlst_hp_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_schlst_hp_p1_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_schlst_hp_p1_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_schlst_hp_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_schlst_hp_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_schlst_hp_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_schlst_hp_p2_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_schlst_hp_p2_data_f [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_schlst_hp_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_schlst_hp_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_schlst_hp_p3_bypdata_nxt [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_schlst_hp_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_schlst_hp_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_schlst_hp_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_schlst_hp_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_schlst_hp_p3_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_schlst_hp_p3_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_schlst_hp_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_schlst_hp_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_schlst_hp_waddr [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_schlst_hp_raddr [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_schlst_hp_wdata [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ] )
  , .mem_read_data                      ( func_ll_schlst_hp_rdata [ ( g * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ] )
) ;
end
endgenerate




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_schlst_tp
hqm_lsp_atm_rmw_mem_4pipe_waddr_wparity # (
    .DEPTH                              ( HQM_ATM_LL_SCHLST_TP_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH )
) i_rmw_ll_schlst_tp (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_schlst_tp_status [ ( g * 1 ) +: 1 ] )
  , .error                              ( rmw_ll_schlst_tp_error [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_schlst_tp_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_schlst_tp_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_schlst_tp_p0_addr_nxt [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_schlst_tp_p0_write_data_nxt_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_schlst_tp_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_schlst_tp_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_schlst_tp_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_schlst_tp_p0_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_schlst_tp_p0_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_schlst_tp_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_schlst_tp_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_schlst_tp_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_schlst_tp_p1_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_schlst_tp_p1_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_schlst_tp_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_schlst_tp_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_schlst_tp_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_schlst_tp_p2_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_schlst_tp_p2_data_f [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_schlst_tp_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_schlst_tp_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_schlst_tp_p3_bypdata_nxt [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_schlst_tp_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_schlst_tp_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_schlst_tp_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_schlst_tp_p3_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_schlst_tp_p3_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_schlst_tp_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_schlst_tp_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_schlst_tp_waddr [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_schlst_tp_raddr [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_schlst_tp_wdata [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ] )
  , .mem_read_data                      ( func_ll_schlst_tp_rdata [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ] )
) ;
end
endgenerate




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_schlst_hpnxt
hqm_lsp_atm_rmw_mem_4pipe_core_wparity # (
    .DEPTH                              ( HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH )
) i_rmw_ll_schlst_hpnxt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_schlst_hpnxt_status [ ( g * 1 ) +: 1 ] )
  , .error                              ( rmw_ll_schlst_hpnxt_error [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_schlst_hpnxt_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_schlst_hpnxt_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_schlst_hpnxt_p0_addr_nxt [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_schlst_hpnxt_p0_write_data_nxt [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_schlst_hpnxt_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_schlst_hpnxt_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_schlst_hpnxt_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_schlst_hpnxt_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_schlst_hpnxt_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_schlst_hpnxt_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_schlst_hpnxt_p0_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_schlst_hpnxt_p0_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_schlst_hpnxt_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_schlst_hpnxt_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_schlst_hpnxt_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_schlst_hpnxt_p1_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_schlst_hpnxt_p1_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_schlst_hpnxt_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_schlst_hpnxt_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_schlst_hpnxt_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_schlst_hpnxt_p2_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_schlst_hpnxt_p2_data_f [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_schlst_hpnxt_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_schlst_hpnxt_p3_bypdata_nxt [ ( g * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_schlst_hpnxt_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_schlst_hpnxt_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_schlst_hpnxt_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_schlst_hpnxt_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_schlst_hpnxt_p3_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_schlst_hpnxt_p3_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_schlst_hpnxt_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_schlst_hpnxt_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_schlst_hpnxt_waddr [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_schlst_hpnxt_raddr [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_schlst_hpnxt_wdata [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ] )
  , .mem_read_data                      ( func_ll_schlst_hpnxt_rdata [ ( g * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ] )
) ;
end
endgenerate




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_schlst_tpprv
hqm_lsp_atm_rmw_mem_4pipe_core_wparity # (
    .DEPTH                              ( HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH )
) i_rmw_ll_schlst_tpprv (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_schlst_tpprv_status [ ( g * 1 ) +: 1 ] )
  , .error                              ( rmw_ll_schlst_tpprv_error [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_schlst_tpprv_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_schlst_tpprv_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_schlst_tpprv_p0_addr_nxt [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_schlst_tpprv_p0_write_data_nxt [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_schlst_tpprv_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_schlst_tpprv_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_schlst_tpprv_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_schlst_tpprv_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_schlst_tpprv_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_schlst_tpprv_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_schlst_tpprv_p0_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_schlst_tpprv_p0_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_schlst_tpprv_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_schlst_tpprv_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_schlst_tpprv_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_schlst_tpprv_p1_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_schlst_tpprv_p1_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_schlst_tpprv_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_schlst_tpprv_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_schlst_tpprv_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_schlst_tpprv_p2_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .p2_data_f                          ( rmw_ll_schlst_tpprv_p2_data_f [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_schlst_tpprv_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_schlst_tpprv_p3_bypdata_nxt [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_schlst_tpprv_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_schlst_tpprv_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_schlst_tpprv_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_schlst_tpprv_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_schlst_tpprv_p3_addr_f_nc [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_schlst_tpprv_p3_data_f_nc [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_schlst_tpprv_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_schlst_tpprv_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_schlst_tpprv_waddr [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_schlst_tpprv_raddr [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_schlst_tpprv_wdata [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ] )
  , .mem_read_data                      ( func_ll_schlst_tpprv_rdata [ ( g * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ] )
) ;
end
endgenerate



hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_SLST_CNT_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_SLST_CNT_DWIDTH )
) i_rmw_ll_slst_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_slst_cnt_status )

  , .p0_v_nxt                           ( rmw_ll_slst_cnt_p0_v_nxt )
  , .p0_rw_nxt                          ( rmw_ll_slst_cnt_p0_rw_nxt )
  , .p0_addr_nxt                        ( rmw_ll_slst_cnt_p0_addr_nxt )
  , .p0_write_data_nxt                  ( rmw_ll_slst_cnt_p0_write_data_nxt )
  , .p0_byp_v_nxt                           ( rmw_ll_slst_cnt_p0_byp_v_nxt )
  , .p0_byp_rw_nxt                          ( rmw_ll_slst_cnt_p0_byp_rw_nxt )
  , .p0_byp_addr_nxt                        ( rmw_ll_slst_cnt_p0_byp_addr_nxt )
  , .p0_byp_write_data_nxt                  ( rmw_ll_slst_cnt_p0_byp_write_data_nxt )
  , .p0_hold                            ( rmw_ll_slst_cnt_p0_hold )
  , .p0_v_f                             ( rmw_ll_slst_cnt_p0_v_f )
  , .p0_rw_f                            ( rmw_ll_slst_cnt_p0_rw_f_nc )
  , .p0_addr_f                          ( rmw_ll_slst_cnt_p0_addr_f_nc )
  , .p0_data_f                          ( rmw_ll_slst_cnt_p0_data_f_nc )

  , .p1_hold                            ( rmw_ll_slst_cnt_p1_hold )
  , .p1_v_f                             ( rmw_ll_slst_cnt_p1_v_f )
  , .p1_rw_f                            ( rmw_ll_slst_cnt_p1_rw_f_nc )
  , .p1_addr_f                          ( rmw_ll_slst_cnt_p1_addr_f_nc )
  , .p1_data_f                          ( rmw_ll_slst_cnt_p1_data_f_nc )

  , .p2_hold                            ( rmw_ll_slst_cnt_p2_hold )
  , .p2_v_f                             ( rmw_ll_slst_cnt_p2_v_f )
  , .p2_rw_f                            ( rmw_ll_slst_cnt_p2_rw_f_nc )
  , .p2_addr_f                          ( rmw_ll_slst_cnt_p2_addr_f_nc )
  , .p2_data_nxt                        ( rmw_ll_slst_cnt_p2_data_nxt_nc )
  , .p2_data_f                          ( rmw_ll_slst_cnt_p2_data_f )

  , .p3_hold                            ( rmw_ll_slst_cnt_p3_hold )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_slst_cnt_p3_bypdata_sel_nxt )
  , .p3_bypdata_nxt                     ( rmw_ll_slst_cnt_p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_slst_cnt_p3_bypaddr_sel_nxt )
  , .p3_bypaddr_nxt                     ( rmw_ll_slst_cnt_p3_bypaddr_nxt )
  , .p3_v_f                             ( rmw_ll_slst_cnt_p3_v_f )
  , .p3_rw_f                            ( rmw_ll_slst_cnt_p3_rw_f_nc )
  , .p3_addr_f                          ( rmw_ll_slst_cnt_p3_addr_f_nc )
  , .p3_data_f                          ( rmw_ll_slst_cnt_p3_data_f_nc )

  , .mem_write                          ( func_ll_slst_cnt_we )
  , .mem_read                           ( func_ll_slst_cnt_re )
  , .mem_write_addr                     ( func_ll_slst_cnt_waddr )
  , .mem_read_addr                      ( func_ll_slst_cnt_raddr )
  , .mem_write_data                     ( func_ll_slst_cnt_wdata )
  , .mem_read_data                      ( func_ll_slst_cnt_rdata )
) ;







generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_enq_cnt_r_dup0
hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH )
) i_rmw_ll_enq_cnt_r_dup0 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_enq_cnt_r_dup0_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_enq_cnt_r_dup0_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_enq_cnt_r_dup0_p0_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup0_p0_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_enq_cnt_r_dup0_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_enq_cnt_r_dup0_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup0_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_enq_cnt_r_dup0_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_enq_cnt_r_dup0_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_enq_cnt_r_dup0_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_enq_cnt_r_dup0_p0_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_enq_cnt_r_dup0_p0_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_enq_cnt_r_dup0_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_enq_cnt_r_dup0_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_enq_cnt_r_dup0_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_enq_cnt_r_dup0_p1_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_enq_cnt_r_dup0_p1_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_enq_cnt_r_dup0_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_enq_cnt_r_dup0_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_enq_cnt_r_dup0_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_enq_cnt_r_dup0_p2_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p2_data_nxt                        ( rmw_ll_enq_cnt_r_dup0_p2_data_nxt_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p2_data_f                          ( rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_enq_cnt_r_dup0_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_enq_cnt_r_dup0_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_enq_cnt_r_dup0_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_enq_cnt_r_dup0_p3_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_enq_cnt_r_dup0_p3_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_enq_cnt_r_dup0_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_enq_cnt_r_dup0_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_enq_cnt_r_dup0_waddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_enq_cnt_r_dup0_raddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_enq_cnt_r_dup0_wdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .mem_read_data                      ( func_ll_enq_cnt_r_dup0_rdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
) ;
end
endgenerate




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_enq_cnt_r_dup1
hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH )
) i_rmw_ll_enq_cnt_r_dup1 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_enq_cnt_r_dup1_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_enq_cnt_r_dup1_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_enq_cnt_r_dup1_p0_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup1_p0_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_enq_cnt_r_dup1_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_enq_cnt_r_dup1_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup1_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_enq_cnt_r_dup1_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_enq_cnt_r_dup1_p0_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_enq_cnt_r_dup1_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_enq_cnt_r_dup1_p0_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_enq_cnt_r_dup1_p0_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_enq_cnt_r_dup1_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_enq_cnt_r_dup1_p1_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_enq_cnt_r_dup1_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_enq_cnt_r_dup1_p1_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_enq_cnt_r_dup1_p1_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_enq_cnt_r_dup1_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_enq_cnt_r_dup1_p2_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_enq_cnt_r_dup1_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_enq_cnt_r_dup1_p2_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p2_data_nxt                        ( rmw_ll_enq_cnt_r_dup1_p2_data_nxt_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p2_data_f                          ( rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_enq_cnt_r_dup1_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_enq_cnt_r_dup1_p3_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_enq_cnt_r_dup1_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_enq_cnt_r_dup1_p3_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_enq_cnt_r_dup1_p3_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_enq_cnt_r_dup1_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_enq_cnt_r_dup1_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_enq_cnt_r_dup1_waddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_enq_cnt_r_dup1_raddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_enq_cnt_r_dup1_wdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .mem_read_data                      ( func_ll_enq_cnt_r_dup1_rdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
) ;
end
endgenerate




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_enq_cnt_r_dup2
hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH )
) i_rmw_ll_enq_cnt_r_dup2 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_enq_cnt_r_dup2_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_enq_cnt_r_dup2_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_enq_cnt_r_dup2_p0_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup2_p0_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_enq_cnt_r_dup2_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_enq_cnt_r_dup2_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup2_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_enq_cnt_r_dup2_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_enq_cnt_r_dup2_p0_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_enq_cnt_r_dup2_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_enq_cnt_r_dup2_p0_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_enq_cnt_r_dup2_p0_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_enq_cnt_r_dup2_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_enq_cnt_r_dup2_p1_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_enq_cnt_r_dup2_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_enq_cnt_r_dup2_p1_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_enq_cnt_r_dup2_p1_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_enq_cnt_r_dup2_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_enq_cnt_r_dup2_p2_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_enq_cnt_r_dup2_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_enq_cnt_r_dup2_p2_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p2_data_nxt                        ( rmw_ll_enq_cnt_r_dup2_p2_data_nxt_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p2_data_f                          ( rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_enq_cnt_r_dup2_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_enq_cnt_r_dup2_p3_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_enq_cnt_r_dup2_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_enq_cnt_r_dup2_p3_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_enq_cnt_r_dup2_p3_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_enq_cnt_r_dup2_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_enq_cnt_r_dup2_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_enq_cnt_r_dup2_waddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_enq_cnt_r_dup2_raddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_enq_cnt_r_dup2_wdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .mem_read_data                      ( func_ll_enq_cnt_r_dup2_rdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
) ;
end
endgenerate




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_enq_cnt_r_dup3
hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH )
) i_rmw_ll_enq_cnt_r_dup3 (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_enq_cnt_r_dup3_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_enq_cnt_r_dup3_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_enq_cnt_r_dup3_p0_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup3_p0_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_enq_cnt_r_dup3_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_enq_cnt_r_dup3_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_enq_cnt_r_dup3_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_enq_cnt_r_dup3_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_enq_cnt_r_dup3_p0_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_enq_cnt_r_dup3_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_enq_cnt_r_dup3_p0_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_enq_cnt_r_dup3_p0_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_enq_cnt_r_dup3_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_enq_cnt_r_dup3_p1_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_enq_cnt_r_dup3_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_enq_cnt_r_dup3_p1_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_enq_cnt_r_dup3_p1_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_enq_cnt_r_dup3_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_enq_cnt_r_dup3_p2_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_enq_cnt_r_dup3_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_enq_cnt_r_dup3_p2_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p2_data_nxt                        ( rmw_ll_enq_cnt_r_dup3_p2_data_nxt_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p2_data_f                          ( rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_enq_cnt_r_dup3_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_enq_cnt_r_dup3_p3_v_f_nc [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_enq_cnt_r_dup3_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_enq_cnt_r_dup3_p3_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_enq_cnt_r_dup3_p3_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_enq_cnt_r_dup3_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_enq_cnt_r_dup3_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_enq_cnt_r_dup3_waddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_enq_cnt_r_dup3_raddr [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_enq_cnt_r_dup3_wdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
  , .mem_read_data                      ( func_ll_enq_cnt_r_dup3_rdata [ ( g * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] )
) ;
end
endgenerate






generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_enq_cnt_s
hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH )
) i_rmw_ll_enq_cnt_s (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_enq_cnt_s_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_enq_cnt_s_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_enq_cnt_s_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_enq_cnt_s_p0_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_enq_cnt_s_p0_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_enq_cnt_s_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_enq_cnt_s_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_enq_cnt_s_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_enq_cnt_s_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_enq_cnt_s_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_enq_cnt_s_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_enq_cnt_s_p0_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_enq_cnt_s_p0_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_enq_cnt_s_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_enq_cnt_s_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_enq_cnt_s_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_enq_cnt_s_p1_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_enq_cnt_s_p1_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_enq_cnt_s_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_enq_cnt_s_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_enq_cnt_s_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_enq_cnt_s_p2_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .p2_data_nxt                        ( rmw_ll_enq_cnt_s_p2_data_nxt_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )
  , .p2_data_f                          ( rmw_ll_enq_cnt_s_p2_data_f [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_enq_cnt_s_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_enq_cnt_s_p3_bypdata_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_enq_cnt_s_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_enq_cnt_s_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_enq_cnt_s_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_enq_cnt_s_p3_addr_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_enq_cnt_s_p3_data_f_nc [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )

  , .mem_write                          ( func_ll_enq_cnt_s_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_enq_cnt_s_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_enq_cnt_s_waddr [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_enq_cnt_s_raddr [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_enq_cnt_s_wdata [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )
  , .mem_read_data                      ( func_ll_enq_cnt_s_rdata [ ( g * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] )
) ;
end
endgenerate




generate
for ( genvar g = 0 ; g < HQM_ATM_NUM_BIN ; g = g + 1 ) begin : i_rmw_ll_sch_cnt
hqm_AW_rmw_mem_4pipe_core # (
    .DEPTH                              ( HQM_ATM_LL_SCH_CNT_DUP0_DEPTH )
  , .WIDTH                              ( HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH )
) i_rmw_ll_sch_cnt (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .status                             ( rmw_ll_sch_cnt_status [ ( g * 1 ) +: 1 ] )

  , .p0_v_nxt                           ( rmw_ll_sch_cnt_p0_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_rw_nxt                          ( rmw_ll_sch_cnt_p0_rw_nxt [ g ] )
  , .p0_addr_nxt                        ( rmw_ll_sch_cnt_p0_addr_nxt [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .p0_write_data_nxt                  ( rmw_ll_sch_cnt_p0_write_data_nxt [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )
  , .p0_byp_v_nxt                           ( rmw_ll_sch_cnt_p0_byp_v_nxt [ ( g * 1 ) +: 1 ] )
  , .p0_byp_rw_nxt                          ( rmw_ll_sch_cnt_p0_byp_rw_nxt [ g ] )
  , .p0_byp_addr_nxt                        ( rmw_ll_sch_cnt_p0_byp_addr_nxt [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .p0_byp_write_data_nxt                  ( rmw_ll_sch_cnt_p0_byp_write_data_nxt [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )
  , .p0_hold                            ( rmw_ll_sch_cnt_p0_hold [ ( g * 1 ) +: 1 ] )
  , .p0_v_f                             ( rmw_ll_sch_cnt_p0_v_f [ ( g * 1 ) +: 1 ] )
  , .p0_rw_f                            ( rmw_ll_sch_cnt_p0_rw_f_nc [ g ] )
  , .p0_addr_f                          ( rmw_ll_sch_cnt_p0_addr_f_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .p0_data_f                          ( rmw_ll_sch_cnt_p0_data_f_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )

  , .p1_hold                            ( rmw_ll_sch_cnt_p1_hold [ ( g * 1 ) +: 1 ] )
  , .p1_v_f                             ( rmw_ll_sch_cnt_p1_v_f [ ( g * 1 ) +: 1 ] )
  , .p1_rw_f                            ( rmw_ll_sch_cnt_p1_rw_f_nc [ g ] )
  , .p1_addr_f                          ( rmw_ll_sch_cnt_p1_addr_f_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .p1_data_f                          ( rmw_ll_sch_cnt_p1_data_f_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )

  , .p2_hold                            ( rmw_ll_sch_cnt_p2_hold [ ( g * 1 ) +: 1 ] )
  , .p2_v_f                             ( rmw_ll_sch_cnt_p2_v_f [ ( g * 1 ) +: 1 ] )
  , .p2_rw_f                            ( rmw_ll_sch_cnt_p2_rw_f_nc [ g ] )
  , .p2_addr_f                          ( rmw_ll_sch_cnt_p2_addr_f_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .p2_data_nxt                        ( rmw_ll_sch_cnt_p2_data_nxt_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )
  , .p2_data_f                          ( rmw_ll_sch_cnt_p2_data_f [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )

  , .p3_hold                            ( rmw_ll_sch_cnt_p3_hold [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_sel_nxt                 ( rmw_ll_sch_cnt_p3_bypdata_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypdata_nxt                     ( rmw_ll_sch_cnt_p3_bypdata_nxt [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )
  , .p3_bypaddr_sel_nxt                 ( rmw_ll_sch_cnt_p3_bypaddr_sel_nxt [ ( g * 1 ) +: 1 ] )
  , .p3_bypaddr_nxt                     ( rmw_ll_sch_cnt_p3_bypaddr_nxt [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .p3_v_f                             ( rmw_ll_sch_cnt_p3_v_f [ ( g * 1 ) +: 1 ] )
  , .p3_rw_f                            ( rmw_ll_sch_cnt_p3_rw_f_nc [ g ] )
  , .p3_addr_f                          ( rmw_ll_sch_cnt_p3_addr_f_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .p3_data_f                          ( rmw_ll_sch_cnt_p3_data_f_nc [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )

  , .mem_write                          ( func_ll_sch_cnt_we [ ( g * 1 ) +: 1 ] )
  , .mem_read                           ( func_ll_sch_cnt_re [ ( g * 1 ) +: 1 ] )
  , .mem_write_addr                     ( func_ll_sch_cnt_waddr [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .mem_read_addr                      ( func_ll_sch_cnt_raddr [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] )
  , .mem_write_data                     ( func_ll_sch_cnt_wdata [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )
  , .mem_read_data                      ( func_ll_sch_cnt_rdata [ ( g * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] )
) ;
end
endgenerate

assign func_ll_schlst_hp_bin0_we = func_ll_schlst_hp_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin0_re = func_ll_schlst_hp_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin0_waddr = func_ll_schlst_hp_waddr [ ( 0 * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin0_raddr = func_ll_schlst_hp_raddr [ ( 0 * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin0_wdata = func_ll_schlst_hp_wdata [ ( 0 * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hp_rdata [ ( 0 * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH_WPARITY ] = func_ll_schlst_hp_bin0_rdata ;

assign func_ll_schlst_hp_bin1_we = func_ll_schlst_hp_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin1_re = func_ll_schlst_hp_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin1_waddr = func_ll_schlst_hp_waddr [ ( 1 * HQM_ATM_LL_SCHLST_HP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin1_raddr = func_ll_schlst_hp_raddr [ ( 1 * HQM_ATM_LL_SCHLST_HP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin1_wdata = func_ll_schlst_hp_wdata [ ( 1 * HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hp_rdata [ ( 1 * HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH_WPARITY ] = func_ll_schlst_hp_bin1_rdata ;

assign func_ll_schlst_hp_bin2_we = func_ll_schlst_hp_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin2_re = func_ll_schlst_hp_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin2_waddr = func_ll_schlst_hp_waddr [ ( 2 * HQM_ATM_LL_SCHLST_HP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin2_raddr = func_ll_schlst_hp_raddr [ ( 2 * HQM_ATM_LL_SCHLST_HP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin2_wdata = func_ll_schlst_hp_wdata [ ( 2 * HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hp_rdata [ ( 2 * HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH_WPARITY ] = func_ll_schlst_hp_bin2_rdata ;

assign func_ll_schlst_hp_bin3_we = func_ll_schlst_hp_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin3_re = func_ll_schlst_hp_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_hp_bin3_waddr = func_ll_schlst_hp_waddr [ ( 3 * HQM_ATM_LL_SCHLST_HP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin3_raddr = func_ll_schlst_hp_raddr [ ( 3 * HQM_ATM_LL_SCHLST_HP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_hp_bin3_wdata = func_ll_schlst_hp_wdata [ ( 3 * HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hp_rdata [ ( 3 * HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH_WPARITY ] = func_ll_schlst_hp_bin3_rdata ;


assign func_ll_schlst_tp_bin0_we = func_ll_schlst_tp_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin0_re = func_ll_schlst_tp_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin0_waddr = func_ll_schlst_tp_waddr [ ( 0 * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin0_raddr = func_ll_schlst_tp_raddr [ ( 0 * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin0_wdata = func_ll_schlst_tp_wdata [ ( 0 * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tp_rdata [ ( 0 * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH_WPARITY ] = func_ll_schlst_tp_bin0_rdata ;

assign func_ll_schlst_tp_bin1_we = func_ll_schlst_tp_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin1_re = func_ll_schlst_tp_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin1_waddr = func_ll_schlst_tp_waddr [ ( 1 * HQM_ATM_LL_SCHLST_TP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin1_raddr = func_ll_schlst_tp_raddr [ ( 1 * HQM_ATM_LL_SCHLST_TP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin1_wdata = func_ll_schlst_tp_wdata [ ( 1 * HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tp_rdata [ ( 1 * HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH_WPARITY ] = func_ll_schlst_tp_bin1_rdata ;

assign func_ll_schlst_tp_bin2_we = func_ll_schlst_tp_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin2_re = func_ll_schlst_tp_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin2_waddr = func_ll_schlst_tp_waddr [ ( 2 * HQM_ATM_LL_SCHLST_TP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin2_raddr = func_ll_schlst_tp_raddr [ ( 2 * HQM_ATM_LL_SCHLST_TP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin2_wdata = func_ll_schlst_tp_wdata [ ( 2 * HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tp_rdata [ ( 2 * HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH_WPARITY ] = func_ll_schlst_tp_bin2_rdata ;

assign func_ll_schlst_tp_bin3_we = func_ll_schlst_tp_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin3_re = func_ll_schlst_tp_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_tp_bin3_waddr = func_ll_schlst_tp_waddr [ ( 3 * HQM_ATM_LL_SCHLST_TP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin3_raddr = func_ll_schlst_tp_raddr [ ( 3 * HQM_ATM_LL_SCHLST_TP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_tp_bin3_wdata = func_ll_schlst_tp_wdata [ ( 3 * HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tp_rdata [ ( 3 * HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH_WPARITY ] = func_ll_schlst_tp_bin3_rdata ;


assign func_ll_schlst_hpnxt_bin0_we = func_ll_schlst_hpnxt_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin0_re = func_ll_schlst_hpnxt_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin0_waddr = func_ll_schlst_hpnxt_waddr [ ( 0 * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin0_raddr = func_ll_schlst_hpnxt_raddr [ ( 0 * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin0_wdata = func_ll_schlst_hpnxt_wdata [ ( 0 * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hpnxt_rdata [ ( 0 * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH_WPARITY ] = func_ll_schlst_hpnxt_bin0_rdata ;

assign func_ll_schlst_hpnxt_bin1_we = func_ll_schlst_hpnxt_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin1_re = func_ll_schlst_hpnxt_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin1_waddr = func_ll_schlst_hpnxt_waddr [ ( 1 * HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin1_raddr = func_ll_schlst_hpnxt_raddr [ ( 1 * HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin1_wdata = func_ll_schlst_hpnxt_wdata [ ( 1 * HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hpnxt_rdata [ ( 1 * HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH_WPARITY ] = func_ll_schlst_hpnxt_bin1_rdata ;

assign func_ll_schlst_hpnxt_bin2_we = func_ll_schlst_hpnxt_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin2_re = func_ll_schlst_hpnxt_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin2_waddr = func_ll_schlst_hpnxt_waddr [ ( 2 * HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin2_raddr = func_ll_schlst_hpnxt_raddr [ ( 2 * HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin2_wdata = func_ll_schlst_hpnxt_wdata [ ( 2 * HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hpnxt_rdata [ ( 2 * HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH_WPARITY ] = func_ll_schlst_hpnxt_bin2_rdata ;

assign func_ll_schlst_hpnxt_bin3_we = func_ll_schlst_hpnxt_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin3_re = func_ll_schlst_hpnxt_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_hpnxt_bin3_waddr = func_ll_schlst_hpnxt_waddr [ ( 3 * HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin3_raddr = func_ll_schlst_hpnxt_raddr [ ( 3 * HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_hpnxt_bin3_wdata = func_ll_schlst_hpnxt_wdata [ ( 3 * HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH_WPARITY ] ;
assign func_ll_schlst_hpnxt_rdata [ ( 3 * HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH_WPARITY ] = func_ll_schlst_hpnxt_bin3_rdata ;


assign func_ll_rdylst_hp_bin0_we = func_ll_rdylst_hp_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin0_re = func_ll_rdylst_hp_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin0_waddr = func_ll_rdylst_hp_waddr [ ( 0 * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin0_raddr = func_ll_rdylst_hp_raddr [ ( 0 * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin0_wdata = func_ll_rdylst_hp_wdata [ ( 0 * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hp_rdata [ ( 0 * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH_WPARITY ] = func_ll_rdylst_hp_bin0_rdata ;

assign func_ll_rdylst_hp_bin1_we = func_ll_rdylst_hp_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin1_re = func_ll_rdylst_hp_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin1_waddr = func_ll_rdylst_hp_waddr [ ( 1 * HQM_ATM_LL_RDYLST_HP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN1_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin1_raddr = func_ll_rdylst_hp_raddr [ ( 1 * HQM_ATM_LL_RDYLST_HP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN1_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin1_wdata = func_ll_rdylst_hp_wdata [ ( 1 * HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hp_rdata [ ( 1 * HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH_WPARITY ] = func_ll_rdylst_hp_bin1_rdata ;

assign func_ll_rdylst_hp_bin2_we = func_ll_rdylst_hp_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin2_re = func_ll_rdylst_hp_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin2_waddr = func_ll_rdylst_hp_waddr [ ( 2 * HQM_ATM_LL_RDYLST_HP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN2_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin2_raddr = func_ll_rdylst_hp_raddr [ ( 2 * HQM_ATM_LL_RDYLST_HP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN2_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin2_wdata = func_ll_rdylst_hp_wdata [ ( 2 * HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hp_rdata [ ( 2 * HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH_WPARITY ] = func_ll_rdylst_hp_bin2_rdata ;

assign func_ll_rdylst_hp_bin3_we = func_ll_rdylst_hp_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin3_re = func_ll_rdylst_hp_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hp_bin3_waddr = func_ll_rdylst_hp_waddr [ ( 3 * HQM_ATM_LL_RDYLST_HP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN3_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin3_raddr = func_ll_rdylst_hp_raddr [ ( 3 * HQM_ATM_LL_RDYLST_HP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN3_DEPTHB2 ] ;
assign func_ll_rdylst_hp_bin3_wdata = func_ll_rdylst_hp_wdata [ ( 3 * HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hp_rdata [ ( 3 * HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH_WPARITY ] = func_ll_rdylst_hp_bin3_rdata ;


assign func_ll_rdylst_tp_bin0_we = func_ll_rdylst_tp_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin0_re = func_ll_rdylst_tp_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin0_waddr = func_ll_rdylst_tp_waddr [ ( 0 * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin0_raddr = func_ll_rdylst_tp_raddr [ ( 0 * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin0_wdata = func_ll_rdylst_tp_wdata [ ( 0 * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_tp_rdata [ ( 0 * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH_WPARITY ] = func_ll_rdylst_tp_bin0_rdata ;

assign func_ll_rdylst_tp_bin1_we = func_ll_rdylst_tp_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin1_re = func_ll_rdylst_tp_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin1_waddr = func_ll_rdylst_tp_waddr [ ( 1 * HQM_ATM_LL_RDYLST_TP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN1_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin1_raddr = func_ll_rdylst_tp_raddr [ ( 1 * HQM_ATM_LL_RDYLST_TP_BIN1_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN1_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin1_wdata = func_ll_rdylst_tp_wdata [ ( 1 * HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_tp_rdata [ ( 1 * HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH_WPARITY ] = func_ll_rdylst_tp_bin1_rdata ;

assign func_ll_rdylst_tp_bin2_we = func_ll_rdylst_tp_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin2_re = func_ll_rdylst_tp_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin2_waddr = func_ll_rdylst_tp_waddr [ ( 2 * HQM_ATM_LL_RDYLST_TP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN2_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin2_raddr = func_ll_rdylst_tp_raddr [ ( 2 * HQM_ATM_LL_RDYLST_TP_BIN2_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN2_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin2_wdata = func_ll_rdylst_tp_wdata [ ( 2 * HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_tp_rdata [ ( 2 * HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH_WPARITY ] = func_ll_rdylst_tp_bin2_rdata ;

assign func_ll_rdylst_tp_bin3_we = func_ll_rdylst_tp_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin3_re = func_ll_rdylst_tp_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_rdylst_tp_bin3_waddr = func_ll_rdylst_tp_waddr [ ( 3 * HQM_ATM_LL_RDYLST_TP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN3_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin3_raddr = func_ll_rdylst_tp_raddr [ ( 3 * HQM_ATM_LL_RDYLST_TP_BIN3_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN3_DEPTHB2 ] ;
assign func_ll_rdylst_tp_bin3_wdata = func_ll_rdylst_tp_wdata [ ( 3 * HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_tp_rdata [ ( 3 * HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH_WPARITY ] = func_ll_rdylst_tp_bin3_rdata ;


assign func_ll_rdylst_hpnxt_bin0_we = func_ll_rdylst_hpnxt_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin0_re = func_ll_rdylst_hpnxt_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin0_waddr = func_ll_rdylst_hpnxt_waddr [ ( 0 * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin0_raddr = func_ll_rdylst_hpnxt_raddr [ ( 0 * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin0_wdata = func_ll_rdylst_hpnxt_wdata [ ( 0 * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hpnxt_rdata [ ( 0 * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH_WPARITY ] = func_ll_rdylst_hpnxt_bin0_rdata ;

assign func_ll_rdylst_hpnxt_bin1_we = func_ll_rdylst_hpnxt_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin1_re = func_ll_rdylst_hpnxt_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin1_waddr = func_ll_rdylst_hpnxt_waddr [ ( 1 * HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin1_raddr = func_ll_rdylst_hpnxt_raddr [ ( 1 * HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin1_wdata = func_ll_rdylst_hpnxt_wdata [ ( 1 * HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hpnxt_rdata [ ( 1 * HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH_WPARITY ] = func_ll_rdylst_hpnxt_bin1_rdata ;

assign func_ll_rdylst_hpnxt_bin2_we = func_ll_rdylst_hpnxt_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin2_re = func_ll_rdylst_hpnxt_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin2_waddr = func_ll_rdylst_hpnxt_waddr [ ( 2 * HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin2_raddr = func_ll_rdylst_hpnxt_raddr [ ( 2 * HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin2_wdata = func_ll_rdylst_hpnxt_wdata [ ( 2 * HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hpnxt_rdata [ ( 2 * HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH_WPARITY ] = func_ll_rdylst_hpnxt_bin2_rdata ;

assign func_ll_rdylst_hpnxt_bin3_we = func_ll_rdylst_hpnxt_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin3_re = func_ll_rdylst_hpnxt_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_rdylst_hpnxt_bin3_waddr = func_ll_rdylst_hpnxt_waddr [ ( 3 * HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin3_raddr = func_ll_rdylst_hpnxt_raddr [ ( 3 * HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTHB2 ] ;
assign func_ll_rdylst_hpnxt_bin3_wdata = func_ll_rdylst_hpnxt_wdata [ ( 3 * HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH_WPARITY ] ;
assign func_ll_rdylst_hpnxt_rdata [ ( 3 * HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH_WPARITY ] = func_ll_rdylst_hpnxt_bin3_rdata ;

assign func_ll_schlst_tpprv_bin0_we = func_ll_schlst_tpprv_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin0_re = func_ll_schlst_tpprv_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin0_waddr = func_ll_schlst_tpprv_waddr [ ( 0 * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin0_raddr = func_ll_schlst_tpprv_raddr [ ( 0 * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin0_wdata = func_ll_schlst_tpprv_wdata [ ( 0 * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tpprv_rdata [ ( 0 * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH_WPARITY ] = func_ll_schlst_tpprv_bin0_rdata ;

assign func_ll_schlst_tpprv_bin1_we = func_ll_schlst_tpprv_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin1_re = func_ll_schlst_tpprv_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin1_waddr = func_ll_schlst_tpprv_waddr [ ( 1 * HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin1_raddr = func_ll_schlst_tpprv_raddr [ ( 1 * HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin1_wdata = func_ll_schlst_tpprv_wdata [ ( 1 * HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tpprv_rdata [ ( 1 * HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH_WPARITY ] = func_ll_schlst_tpprv_bin1_rdata ;

assign func_ll_schlst_tpprv_bin2_we = func_ll_schlst_tpprv_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin2_re = func_ll_schlst_tpprv_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin2_waddr = func_ll_schlst_tpprv_waddr [ ( 2 * HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin2_raddr = func_ll_schlst_tpprv_raddr [ ( 2 * HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin2_wdata = func_ll_schlst_tpprv_wdata [ ( 2 * HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tpprv_rdata [ ( 2 * HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH_WPARITY ] = func_ll_schlst_tpprv_bin2_rdata ;

assign func_ll_schlst_tpprv_bin3_we = func_ll_schlst_tpprv_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin3_re = func_ll_schlst_tpprv_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_schlst_tpprv_bin3_waddr = func_ll_schlst_tpprv_waddr [ ( 3 * HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin3_raddr = func_ll_schlst_tpprv_raddr [ ( 3 * HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTHB2 ] ;
assign func_ll_schlst_tpprv_bin3_wdata = func_ll_schlst_tpprv_wdata [ ( 3 * HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH_WPARITY ] ;
assign func_ll_schlst_tpprv_rdata [ ( 3 * HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH_WPARITY ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH_WPARITY ] = func_ll_schlst_tpprv_bin3_rdata ;


assign func_ll_enq_cnt_r_bin0_dup0_we = func_ll_enq_cnt_r_dup0_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup0_re = func_ll_enq_cnt_r_dup0_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup0_waddr = func_ll_enq_cnt_r_dup0_waddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup0_raddr = func_ll_enq_cnt_r_dup0_raddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup0_wdata = func_ll_enq_cnt_r_dup0_wdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup0_rdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] = func_ll_enq_cnt_r_bin0_dup0_rdata ;

assign func_ll_enq_cnt_r_bin1_dup0_we = func_ll_enq_cnt_r_dup0_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup0_re = func_ll_enq_cnt_r_dup0_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup0_waddr = func_ll_enq_cnt_r_dup0_waddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup0_raddr = func_ll_enq_cnt_r_dup0_raddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup0_wdata = func_ll_enq_cnt_r_dup0_wdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup0_rdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] = func_ll_enq_cnt_r_bin1_dup0_rdata ;

assign func_ll_enq_cnt_r_bin2_dup0_we = func_ll_enq_cnt_r_dup0_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup0_re = func_ll_enq_cnt_r_dup0_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup0_waddr = func_ll_enq_cnt_r_dup0_waddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup0_raddr = func_ll_enq_cnt_r_dup0_raddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup0_wdata = func_ll_enq_cnt_r_dup0_wdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup0_rdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] = func_ll_enq_cnt_r_bin2_dup0_rdata ;

assign func_ll_enq_cnt_r_bin3_dup0_we = func_ll_enq_cnt_r_dup0_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup0_re = func_ll_enq_cnt_r_dup0_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup0_waddr = func_ll_enq_cnt_r_dup0_waddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup0_raddr = func_ll_enq_cnt_r_dup0_raddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup0_wdata = func_ll_enq_cnt_r_dup0_wdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup0_rdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] = func_ll_enq_cnt_r_bin3_dup0_rdata ;

assign func_ll_enq_cnt_r_bin0_dup1_we = func_ll_enq_cnt_r_dup1_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup1_re = func_ll_enq_cnt_r_dup1_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup1_waddr = func_ll_enq_cnt_r_dup1_waddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup1_raddr = func_ll_enq_cnt_r_dup1_raddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup1_wdata = func_ll_enq_cnt_r_dup1_wdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup1_rdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] = func_ll_enq_cnt_r_bin0_dup1_rdata ;

assign func_ll_enq_cnt_r_bin1_dup1_we = func_ll_enq_cnt_r_dup1_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup1_re = func_ll_enq_cnt_r_dup1_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup1_waddr = func_ll_enq_cnt_r_dup1_waddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup1_raddr = func_ll_enq_cnt_r_dup1_raddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup1_wdata = func_ll_enq_cnt_r_dup1_wdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup1_rdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] = func_ll_enq_cnt_r_bin1_dup1_rdata ;

assign func_ll_enq_cnt_r_bin2_dup1_we = func_ll_enq_cnt_r_dup1_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup1_re = func_ll_enq_cnt_r_dup1_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup1_waddr = func_ll_enq_cnt_r_dup1_waddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup1_raddr = func_ll_enq_cnt_r_dup1_raddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup1_wdata = func_ll_enq_cnt_r_dup1_wdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup1_rdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] = func_ll_enq_cnt_r_bin2_dup1_rdata ;

assign func_ll_enq_cnt_r_bin3_dup1_we = func_ll_enq_cnt_r_dup1_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup1_re = func_ll_enq_cnt_r_dup1_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup1_waddr = func_ll_enq_cnt_r_dup1_waddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup1_raddr = func_ll_enq_cnt_r_dup1_raddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup1_wdata = func_ll_enq_cnt_r_dup1_wdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup1_rdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] = func_ll_enq_cnt_r_bin3_dup1_rdata ;

assign func_ll_enq_cnt_r_bin0_dup2_we = func_ll_enq_cnt_r_dup2_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup2_re = func_ll_enq_cnt_r_dup2_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup2_waddr = func_ll_enq_cnt_r_dup2_waddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup2_raddr = func_ll_enq_cnt_r_dup2_raddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup2_wdata = func_ll_enq_cnt_r_dup2_wdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup2_rdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] = func_ll_enq_cnt_r_bin0_dup2_rdata ;

assign func_ll_enq_cnt_r_bin1_dup2_we = func_ll_enq_cnt_r_dup2_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup2_re = func_ll_enq_cnt_r_dup2_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup2_waddr = func_ll_enq_cnt_r_dup2_waddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup2_raddr = func_ll_enq_cnt_r_dup2_raddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup2_wdata = func_ll_enq_cnt_r_dup2_wdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup2_rdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] = func_ll_enq_cnt_r_bin1_dup2_rdata ;

assign func_ll_enq_cnt_r_bin2_dup2_we = func_ll_enq_cnt_r_dup2_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup2_re = func_ll_enq_cnt_r_dup2_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup2_waddr = func_ll_enq_cnt_r_dup2_waddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup2_raddr = func_ll_enq_cnt_r_dup2_raddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup2_wdata = func_ll_enq_cnt_r_dup2_wdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup2_rdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] = func_ll_enq_cnt_r_bin2_dup2_rdata ;

assign func_ll_enq_cnt_r_bin3_dup2_we = func_ll_enq_cnt_r_dup2_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup2_re = func_ll_enq_cnt_r_dup2_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup2_waddr = func_ll_enq_cnt_r_dup2_waddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup2_raddr = func_ll_enq_cnt_r_dup2_raddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup2_wdata = func_ll_enq_cnt_r_dup2_wdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup2_rdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] = func_ll_enq_cnt_r_bin3_dup2_rdata ;

assign func_ll_enq_cnt_r_bin0_dup3_we = func_ll_enq_cnt_r_dup3_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup3_re = func_ll_enq_cnt_r_dup3_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin0_dup3_waddr = func_ll_enq_cnt_r_dup3_waddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup3_raddr = func_ll_enq_cnt_r_dup3_raddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin0_dup3_wdata = func_ll_enq_cnt_r_dup3_wdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup3_rdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ] = func_ll_enq_cnt_r_bin0_dup3_rdata ;

assign func_ll_enq_cnt_r_bin1_dup3_we = func_ll_enq_cnt_r_dup3_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup3_re = func_ll_enq_cnt_r_dup3_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin1_dup3_waddr = func_ll_enq_cnt_r_dup3_waddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup3_raddr = func_ll_enq_cnt_r_dup3_raddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin1_dup3_wdata = func_ll_enq_cnt_r_dup3_wdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup3_rdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH ] = func_ll_enq_cnt_r_bin1_dup3_rdata ;

assign func_ll_enq_cnt_r_bin2_dup3_we = func_ll_enq_cnt_r_dup3_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup3_re = func_ll_enq_cnt_r_dup3_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin2_dup3_waddr = func_ll_enq_cnt_r_dup3_waddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup3_raddr = func_ll_enq_cnt_r_dup3_raddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin2_dup3_wdata = func_ll_enq_cnt_r_dup3_wdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup3_rdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH ] = func_ll_enq_cnt_r_bin2_dup3_rdata ;

assign func_ll_enq_cnt_r_bin3_dup3_we = func_ll_enq_cnt_r_dup3_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup3_re = func_ll_enq_cnt_r_dup3_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_r_bin3_dup3_waddr = func_ll_enq_cnt_r_dup3_waddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup3_raddr = func_ll_enq_cnt_r_dup3_raddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_r_bin3_dup3_wdata = func_ll_enq_cnt_r_dup3_wdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] ;
assign func_ll_enq_cnt_r_dup3_rdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH ] = func_ll_enq_cnt_r_bin3_dup3_rdata ;


assign func_ll_enq_cnt_s_bin0_we = func_ll_enq_cnt_s_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin0_re = func_ll_enq_cnt_s_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin0_waddr = func_ll_enq_cnt_s_waddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin0_raddr = func_ll_enq_cnt_s_raddr [ ( 0 * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin0_wdata = func_ll_enq_cnt_s_wdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] ;
assign func_ll_enq_cnt_s_rdata [ ( 0 * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ] = func_ll_enq_cnt_s_bin0_rdata ;

assign func_ll_enq_cnt_s_bin1_we = func_ll_enq_cnt_s_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin1_re = func_ll_enq_cnt_s_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin1_waddr = func_ll_enq_cnt_s_waddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin1_raddr = func_ll_enq_cnt_s_raddr [ ( 1 * HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin1_wdata = func_ll_enq_cnt_s_wdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_S_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN1_DWIDTH ] ;
assign func_ll_enq_cnt_s_rdata [ ( 1 * HQM_ATM_LL_ENQ_CNT_S_BIN1_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN1_DWIDTH ] = func_ll_enq_cnt_s_bin1_rdata ;

assign func_ll_enq_cnt_s_bin2_we = func_ll_enq_cnt_s_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin2_re = func_ll_enq_cnt_s_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin2_waddr = func_ll_enq_cnt_s_waddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin2_raddr = func_ll_enq_cnt_s_raddr [ ( 2 * HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin2_wdata = func_ll_enq_cnt_s_wdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_S_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN2_DWIDTH ] ;
assign func_ll_enq_cnt_s_rdata [ ( 2 * HQM_ATM_LL_ENQ_CNT_S_BIN2_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN2_DWIDTH ] = func_ll_enq_cnt_s_bin2_rdata ;

assign func_ll_enq_cnt_s_bin3_we = func_ll_enq_cnt_s_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin3_re = func_ll_enq_cnt_s_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_enq_cnt_s_bin3_waddr = func_ll_enq_cnt_s_waddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin3_raddr = func_ll_enq_cnt_s_raddr [ ( 3 * HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTHB2 ] ;
assign func_ll_enq_cnt_s_bin3_wdata = func_ll_enq_cnt_s_wdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_S_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN3_DWIDTH ] ;
assign func_ll_enq_cnt_s_rdata [ ( 3 * HQM_ATM_LL_ENQ_CNT_S_BIN3_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN3_DWIDTH ] = func_ll_enq_cnt_s_bin3_rdata ;


assign func_ll_sch_cnt_dup0_we = func_ll_sch_cnt_we [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup0_re = func_ll_sch_cnt_re [ ( 0 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup0_waddr = func_ll_sch_cnt_waddr [ ( 0 * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup0_raddr = func_ll_sch_cnt_raddr [ ( 0 * HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup0_wdata = func_ll_sch_cnt_wdata [ ( 0 * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] ;
assign func_ll_sch_cnt_rdata [ ( 0 * HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH ] = func_ll_sch_cnt_dup0_rdata ;

assign func_ll_sch_cnt_dup1_we = func_ll_sch_cnt_we [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup1_re = func_ll_sch_cnt_re [ ( 1 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup1_waddr = func_ll_sch_cnt_waddr [ ( 1 * HQM_ATM_LL_SCH_CNT_DUP1_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP1_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup1_raddr = func_ll_sch_cnt_raddr [ ( 1 * HQM_ATM_LL_SCH_CNT_DUP1_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP1_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup1_wdata = func_ll_sch_cnt_wdata [ ( 1 * HQM_ATM_LL_SCH_CNT_DUP1_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP1_DWIDTH ] ;
assign func_ll_sch_cnt_rdata [ ( 1 * HQM_ATM_LL_SCH_CNT_DUP1_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP1_DWIDTH ] = func_ll_sch_cnt_dup1_rdata ;

assign func_ll_sch_cnt_dup2_we = func_ll_sch_cnt_we [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup2_re = func_ll_sch_cnt_re [ ( 2 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup2_waddr = func_ll_sch_cnt_waddr [ ( 2 * HQM_ATM_LL_SCH_CNT_DUP2_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP2_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup2_raddr = func_ll_sch_cnt_raddr [ ( 2 * HQM_ATM_LL_SCH_CNT_DUP2_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP2_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup2_wdata = func_ll_sch_cnt_wdata [ ( 2 * HQM_ATM_LL_SCH_CNT_DUP2_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP2_DWIDTH ] ;
assign func_ll_sch_cnt_rdata [ ( 2 * HQM_ATM_LL_SCH_CNT_DUP2_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP2_DWIDTH ] = func_ll_sch_cnt_dup2_rdata ;

assign func_ll_sch_cnt_dup3_we = func_ll_sch_cnt_we [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup3_re = func_ll_sch_cnt_re [ ( 3 * 1 ) +: 1 ] ;
assign func_ll_sch_cnt_dup3_waddr = func_ll_sch_cnt_waddr [ ( 3 * HQM_ATM_LL_SCH_CNT_DUP3_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP3_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup3_raddr = func_ll_sch_cnt_raddr [ ( 3 * HQM_ATM_LL_SCH_CNT_DUP3_DEPTHB2 ) +: HQM_ATM_LL_SCH_CNT_DUP3_DEPTHB2 ] ;
assign func_ll_sch_cnt_dup3_wdata = func_ll_sch_cnt_wdata [ ( 3 * HQM_ATM_LL_SCH_CNT_DUP3_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP3_DWIDTH ] ;
assign func_ll_sch_cnt_rdata [ ( 3 * HQM_ATM_LL_SCH_CNT_DUP3_DWIDTH ) +: HQM_ATM_LL_SCH_CNT_DUP3_DWIDTH ] = func_ll_sch_cnt_dup3_rdata ;


//....................................................................................................
// CFG REGISTER

// General CONTROL


assign hqm_ap_target_cfg_patch_control_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_patch_control_reg_nxt = hqm_ap_target_cfg_patch_control_reg_f ;

assign hqm_ap_target_cfg_ap_csr_control_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_ap_csr_control_reg_nxt = cfg_csr_control_nxt ;
assign cfg_csr_control_f = hqm_ap_target_cfg_ap_csr_control_reg_f ;

assign hqm_ap_target_cfg_control_general_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_control_general_reg_nxt = cfg_control0_nxt ;
assign cfg_control0_f = hqm_ap_target_cfg_control_general_reg_f ;

assign hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_nxt = cfg_control1_nxt ;
assign cfg_control1_f = hqm_ap_target_cfg_control_arb_weights_ready_bin_reg_f ;

assign hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_nxt = cfg_control2_nxt ;
assign cfg_control2_f = hqm_ap_target_cfg_control_arb_weights_sched_bin_reg_f ;

assign hqm_ap_target_cfg_control_pipeline_credits_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_control_pipeline_credits_reg_nxt = cfg_control4_nxt ;
assign cfg_control4_f = hqm_ap_target_cfg_control_pipeline_credits_reg_f ;

assign hqm_ap_target_cfg_detect_feature_operation_00_reg_nxt = cfg_control7_nxt ;
assign cfg_control7_f = hqm_ap_target_cfg_detect_feature_operation_00_reg_f ;

assign hqm_ap_target_cfg_detect_feature_operation_01_reg_nxt = cfg_control8_nxt ;
assign cfg_control8_f = hqm_ap_target_cfg_detect_feature_operation_01_reg_f ;

assign hqm_ap_target_cfg_unit_idle_reg_nxt = cfg_unit_idle_nxt ;
assign cfg_unit_idle_f = hqm_ap_target_cfg_unit_idle_reg_f ;

assign hqm_ap_target_cfg_pipe_health_valid_00_reg_nxt = cfg_pipe_health_valid_00_nxt ;
assign cfg_pipe_health_valid_00_f = hqm_ap_target_cfg_pipe_health_valid_00_reg_f ;

assign hqm_ap_target_cfg_pipe_health_hold_00_reg_nxt = cfg_pipe_health_hold_00_nxt ;
assign cfg_pipe_health_hold_00_f = hqm_ap_target_cfg_pipe_health_hold_00_reg_f ;

assign hqm_ap_target_cfg_interface_status_reg_nxt = cfg_interface_nxt ;
assign cfg_interface_f = hqm_ap_target_cfg_interface_status_reg_f ;

assign hqm_ap_target_cfg_error_inject_reg_v = 1'b0 ;
assign hqm_ap_target_cfg_error_inject_reg_nxt = cfg_error_inj_nxt ;
assign cfg_error_inj_f = hqm_ap_target_cfg_error_inject_reg_f ;



//....................................................................................................
// CFG STATUS

assign hqm_ap_target_cfg_diagnostic_aw_status_status = cfg_status0 ;

assign hqm_ap_target_cfg_diagnostic_aw_status_01_status = cfg_status1 ;

assign hqm_ap_target_cfg_diagnostic_aw_status_02_status = cfg_status2 ;

assign hqm_ap_target_cfg_diagnostic_aw_status_03_status = cfg_status3 ;







hqm_lsp_atm_enq_arb # (
    .HQM_ATM_NUM_REQS                           ( 4 )
) i_hqm_lsp_atm_enq_arb (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_n )
  , .cfg                                ( cfg_control0_f [ 14 : 12 ] )
  , .reqs                               ( arb_enqueue_reqs )
  , .mask                               ( arb_enqueue_mask )
  , .update                             ( arb_enqueue_update )
  , .winner_v                           ( arb_enqueue_winner_v )
  , .winner                             ( arb_enqueue_winner )
) ;



//------------------------------------------------------------------------------------------------------------------------------------------------
//counters

always_comb begin : L07
  fifo_ap_aqed_cnt_nxt = fifo_ap_aqed_cnt_f + { 4'd0 , fifo_ap_aqed_inc } - { 4'd0 , fifo_ap_aqed_dec } ;
  fifo_ap_lsp_enq_cnt_nxt = fifo_ap_lsp_enq_cnt_f + { 4'd0 , fifo_ap_lsp_enq_inc } - { 4'd0 , fifo_ap_lsp_enq_dec } ;
end


assign ap_lsp_cmd_v = ap_lsp_cmd_v_f ;
assign ap_lsp_cmd = ap_lsp_cmd_f ;
assign ap_lsp_cq = ap_lsp_cq_f ;
assign ap_lsp_qidix_msb = ap_lsp_qidix_msb_f ;
assign ap_lsp_qidix = ap_lsp_qidix_f ;
assign ap_lsp_qid = ap_lsp_qid_f ;
assign ap_lsp_qid2cqqidix = ap_lsp_qid2cqqidix_f [ 511 : 0 ] ;
assign ap_lsp_haswork_rlst_v = ap_lsp_haswork_rlst_v_f ;
assign ap_lsp_haswork_rlst_func = ap_lsp_haswork_rlst_func_f ;
assign ap_lsp_haswork_slst_v = ap_lsp_haswork_slst_v_f ;
assign ap_lsp_haswork_slst_func = ap_lsp_haswork_slst_func_f ;
assign ap_lsp_cmpblast_v = ap_lsp_cmpblast_v_f ;
assign ap_lsp_dec_fid_cnt_v = ap_lsp_dec_fid_cnt_v_f ;









//------------------------------------------------------------------------------------------------------------------------------------------------
// Functional



always_comb begin : L11
  //....................................................................................................
  // elastic FIFO storage



  parity_check_aqed_ap_enq_p = '0 ;
  parity_check_aqed_ap_enq_d = '0 ;
  parity_check_aqed_ap_enq_e = '0 ;

  parity_check_aqed_ap_enq_flid_p = '0 ;
  parity_check_aqed_ap_enq_flid_d = '0 ;
  parity_check_aqed_ap_enq_flid_e = '0 ;



  fifo_aqed_ap_enq_push = '0 ;
  fifo_aqed_ap_enq_push_data = '0 ;



  db_aqed_ap_enq_ready = '0 ;



  //CHP_AP_CMP

  //AQED_AP_ENQ
  db_aqed_ap_enq_ready                          = ~ ( fifo_aqed_ap_enq_afull ) ;
  if ( db_aqed_ap_enq_valid
     & db_aqed_ap_enq_ready
     ) begin

    parity_check_aqed_ap_enq_p                  = db_aqed_ap_enq_data.parity ^ cfg_error_inj_f [ 0 ] ;
    parity_check_aqed_ap_enq_d                  = { db_aqed_ap_enq_data.qid
                                                  , db_aqed_ap_enq_data.qpri
                                                  } ;
    parity_check_aqed_ap_enq_e                  = 1'b1 ;

    parity_check_aqed_ap_enq_flid_p             = db_aqed_ap_enq_data.flid_parity ;
    parity_check_aqed_ap_enq_flid_d             = db_aqed_ap_enq_data.flid ;
    parity_check_aqed_ap_enq_flid_e             = 1'b1 ;

    fifo_aqed_ap_enq_push                       = 1'b1 ;
    fifo_aqed_ap_enq_push_data                  = db_aqed_ap_enq_data ;
  end


end

always_comb begin : L12
  //....................................................................................................
  // p0 fid2cqqidix-0
  p0_fid2qidix_ctrl = '0 ;
  p0_fid2qidix_v_nxt = '0 ;
  p0_fid2qidix_data_nxt = p0_fid2qidix_data_f ;

  rmw_fid2cqqidix_p0_hold = '0 ;

  fifo_aqed_ap_enq_pop = '0 ;

  rmw_fid2cqqidix_p0_v_nxt = '0 ;
  rmw_fid2cqqidix_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_fid2cqqidix_p0_addr_nxt = '0 ;
  rmw_fid2cqqidix_p0_write_data_nxt_nc = '0 ;

  ap_lsp_freeze = cfg_req_idlepipe ;



  //.........................
  p0_fid2qidix_ctrl.hold                        = ( p0_fid2qidix_v_f & p1_fid2qidix_ctrl.hold ) ;
  p0_fid2qidix_ctrl.enable                      = ( ( ~ cfg_req_idlepipe )
                                                  & ( ~ p0_fid2qidix_ctrl.hold )
                                                  & ( ~ fifo_aqed_ap_enq_empty )
                                                  ) ;
  rmw_fid2cqqidix_p0_hold                       = p0_fid2qidix_ctrl.hold ;

  if ( p0_fid2qidix_ctrl.enable | p0_fid2qidix_ctrl.hold ) begin
    p0_fid2qidix_v_nxt                          = 1'b1 ;
  end
  if ( p0_fid2qidix_ctrl.enable ) begin
    p0_fid2qidix_data_nxt                       = '0 ;                  // Cover any missing/spare bits
    p0_fid2qidix_data_nxt.cq                    = '0 ;
    p0_fid2qidix_data_nxt.qid                   = fifo_aqed_ap_enq_pop_data.qid ;
    p0_fid2qidix_data_nxt.qidix                 = '0 ;
    p0_fid2qidix_data_nxt.parity                = fifo_aqed_ap_enq_pop_data.parity ^ cfg_error_inj_f [ 1 ] ;
    p0_fid2qidix_data_nxt.qpri                  = fifo_aqed_ap_enq_pop_data.qpri ;
    p0_fid2qidix_data_nxt.bin                   = fifo_aqed_ap_enq_pop_data.qpri [ 2 : 1 ] ;
    p0_fid2qidix_data_nxt.fid                   = fifo_aqed_ap_enq_pop_data.flid ;
    p0_fid2qidix_data_nxt.fid_parity            = fifo_aqed_ap_enq_pop_data.flid_parity ;

    rmw_fid2cqqidix_p0_v_nxt                    = 1'b1 ;
    rmw_fid2cqqidix_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_fid2cqqidix_p0_addr_nxt                 = p0_fid2qidix_data_nxt.fid ;
    rmw_fid2cqqidix_p0_write_data_nxt_nc           = '0 ;

    fifo_aqed_ap_enq_pop                        = 1'b1 ;
  end

end

always_comb begin : L13
  //....................................................................................................
  // p1 fid2cqqidix-1
  p1_fid2qidix_ctrl = '0 ;
  p1_fid2qidix_v_nxt = '0 ;
  p1_fid2qidix_data_nxt = p1_fid2qidix_data_f ;

  rmw_fid2cqqidix_p1_hold = '0 ;

  //.........................
  p1_fid2qidix_ctrl.hold                        = ( p1_fid2qidix_v_f & p2_fid2qidix_ctrl.hold ) ;
  p1_fid2qidix_ctrl.enable                      = ( p0_fid2qidix_v_f & ~ p1_fid2qidix_ctrl.hold ) ;

  if ( p1_fid2qidix_ctrl.enable | p1_fid2qidix_ctrl.hold ) begin
    p1_fid2qidix_v_nxt                          = 1'b1 ;
  end
  if ( p1_fid2qidix_ctrl.enable ) begin
    p1_fid2qidix_data_nxt                       = p0_fid2qidix_data_f ;
  end

  rmw_fid2cqqidix_p1_hold                       = p1_fid2qidix_ctrl.hold ;
end

always_comb begin : L14
  //....................................................................................................
  // p2 fid2cqqidix-2
  p2_fid2qidix_ctrl = '0 ;
  p2_fid2qidix_v_nxt = '0 ;
  p2_fid2qidix_data_nxt = p2_fid2qidix_data_f ;

  rmw_fid2cqqidix_p2_hold = '0 ;
  rmw_fid2cqqidix_p3_hold = '0 ;

  parity_check_fid2cqqidix_p = '0 ;
  parity_check_fid2cqqidix_d = '0 ;
  parity_check_fid2cqqidix_e = '0 ;

  fifo_enqueue0_push = '0 ;
  fifo_enqueue0_push_cq = '0 ;
  fifo_enqueue0_push_qid = '0 ;
  fifo_enqueue0_push_qidix = '0 ;
  fifo_enqueue0_push_parity = '0 ;
  fifo_enqueue0_push_qpri = '0 ;
  fifo_enqueue0_push_bin = '0 ;
  fifo_enqueue0_push_fid = '0 ;
  fifo_enqueue0_push_fid_parity = '0 ;

  fifo_enqueue1_push = '0 ;
  fifo_enqueue1_push_cq = '0 ;
  fifo_enqueue1_push_qid = '0 ;
  fifo_enqueue1_push_qidix = '0 ;
  fifo_enqueue1_push_parity = '0 ;
  fifo_enqueue1_push_qpri = '0 ;
  fifo_enqueue1_push_bin = '0 ;
  fifo_enqueue1_push_fid = '0 ;
  fifo_enqueue1_push_fid_parity = '0 ;

  fifo_enqueue2_push = '0 ;
  fifo_enqueue2_push_cq = '0 ;
  fifo_enqueue2_push_qid = '0 ;
  fifo_enqueue2_push_qidix = '0 ;
  fifo_enqueue2_push_parity = '0 ;
  fifo_enqueue2_push_qpri = '0 ;
  fifo_enqueue2_push_bin = '0 ;
  fifo_enqueue2_push_fid = '0 ;
  fifo_enqueue2_push_fid_parity = '0 ;

  fifo_enqueue3_push = '0 ;
  fifo_enqueue3_push_cq = '0 ;
  fifo_enqueue3_push_qid = '0 ;
  fifo_enqueue3_push_qidix = '0 ;
  fifo_enqueue3_push_parity = '0 ;
  fifo_enqueue3_push_qpri = '0 ;
  fifo_enqueue3_push_bin = '0 ;
  fifo_enqueue3_push_fid = '0 ;
  fifo_enqueue3_push_fid_parity = '0 ;

  fifo_enqueue0_byp = rmw_fid2cqqidix_p3_bypdata_sel_nxt ;
  fifo_enqueue0_byp_fid = rmw_fid2cqqidix_p3_bypaddr_nxt ;
  fifo_enqueue0_byp_cq = p6_ll_data_nxt.cq ;
  fifo_enqueue0_byp_qidix = p6_ll_data_nxt.qidix ;

  fifo_enqueue1_byp = rmw_fid2cqqidix_p3_bypdata_sel_nxt ;
  fifo_enqueue1_byp_fid = rmw_fid2cqqidix_p3_bypaddr_nxt ;
  fifo_enqueue1_byp_cq = p6_ll_data_nxt.cq ;
  fifo_enqueue1_byp_qidix = p6_ll_data_nxt.qidix ;

  fifo_enqueue2_byp = rmw_fid2cqqidix_p3_bypdata_sel_nxt ;
  fifo_enqueue2_byp_fid = rmw_fid2cqqidix_p3_bypaddr_nxt ;
  fifo_enqueue2_byp_cq = p6_ll_data_nxt.cq ;
  fifo_enqueue2_byp_qidix = p6_ll_data_nxt.qidix ;

  fifo_enqueue3_byp = rmw_fid2cqqidix_p3_bypdata_sel_nxt ;
  fifo_enqueue3_byp_fid = rmw_fid2cqqidix_p3_bypaddr_nxt ;
  fifo_enqueue3_byp_cq = p6_ll_data_nxt.cq ;
  fifo_enqueue3_byp_qidix = p6_ll_data_nxt.qidix ;

  //.........................
  p2_fid2qidix_ctrl.hold                        = ( ( p2_fid2qidix_v_f  )
                                                  & ( ( ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd0 ) ? ( fifo_enqueue0_hold_v ) : 1'b0 )
                                                    | ( ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd1 ) ? ( fifo_enqueue1_hold_v ) : 1'b0 )
                                                    | ( ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd2 ) ? ( fifo_enqueue2_hold_v ) : 1'b0 )
                                                    | ( ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd3 ) ? ( fifo_enqueue3_hold_v ) : 1'b0 )
                                                    )
                                                  ) ;
  p2_fid2qidix_ctrl.enable                      = ( p1_fid2qidix_v_f & ~ p2_fid2qidix_ctrl.hold ) ;

  if ( p2_fid2qidix_ctrl.enable | p2_fid2qidix_ctrl.hold ) begin
    p2_fid2qidix_v_nxt                          = 1'b1 ;
  end
  if ( p2_fid2qidix_ctrl.enable ) begin
    p2_fid2qidix_data_nxt                       = p1_fid2qidix_data_f ;
  end

  rmw_fid2cqqidix_p2_hold                       = p2_fid2qidix_ctrl.hold ;

  if ( ( p2_fid2qidix_v_f  )
     & ( ~ p2_fid2qidix_ctrl.hold )
     ) begin
      parity_check_fid2cqqidix_p               = rmw_fid2cqqidix_p2_data_f [ 9 ] ;
      parity_check_fid2cqqidix_d               = rmw_fid2cqqidix_p2_data_f [ 8 : 0 ] ;
      parity_check_fid2cqqidix_e               = 1'b1 ;

      if ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd0 ) begin
        fifo_enqueue0_push                       = 1'b1 ;
        fifo_enqueue0_push_cq               = rmw_fid2cqqidix_p2_data_f [ 8 : 3 ] ;
        fifo_enqueue0_push_qid              = p2_fid2qidix_data_f.qid ;
        fifo_enqueue0_push_qidix            = rmw_fid2cqqidix_p2_data_f [ 2 : 0 ] ;
        fifo_enqueue0_push_parity           = p2_fid2qidix_data_f.parity ;
        fifo_enqueue0_push_qpri             = p2_fid2qidix_data_f.qpri ;
        fifo_enqueue0_push_bin              = p2_fid2qidix_data_f.bin ;
        fifo_enqueue0_push_fid              = p2_fid2qidix_data_f.fid ;
        fifo_enqueue0_push_fid_parity       = p2_fid2qidix_data_f.fid_parity ;
      end

      if ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd1 ) begin
        fifo_enqueue1_push                       = 1'b1 ;
        fifo_enqueue1_push_cq               = rmw_fid2cqqidix_p2_data_f [ 8 : 3 ] ;
        fifo_enqueue1_push_qid              = p2_fid2qidix_data_f.qid ;
        fifo_enqueue1_push_qidix            = rmw_fid2cqqidix_p2_data_f [ 2 : 0 ] ;
        fifo_enqueue1_push_parity           = p2_fid2qidix_data_f.parity ;
        fifo_enqueue1_push_qpri             = p2_fid2qidix_data_f.qpri ;
        fifo_enqueue1_push_bin              = p2_fid2qidix_data_f.bin ;
        fifo_enqueue1_push_fid              = p2_fid2qidix_data_f.fid ;
        fifo_enqueue1_push_fid_parity       = p2_fid2qidix_data_f.fid_parity ;
      end

      if ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd2 ) begin
        fifo_enqueue2_push                       = 1'b1 ;
        fifo_enqueue2_push_cq               = rmw_fid2cqqidix_p2_data_f [ 8 : 3 ] ;
        fifo_enqueue2_push_qid              = p2_fid2qidix_data_f.qid ;
        fifo_enqueue2_push_qidix            = rmw_fid2cqqidix_p2_data_f [ 2 : 0 ] ;
        fifo_enqueue2_push_parity           = p2_fid2qidix_data_f.parity ;
        fifo_enqueue2_push_qpri             = p2_fid2qidix_data_f.qpri ;
        fifo_enqueue2_push_bin              = p2_fid2qidix_data_f.bin ;
        fifo_enqueue2_push_fid              = p2_fid2qidix_data_f.fid ;
        fifo_enqueue2_push_fid_parity       = p2_fid2qidix_data_f.fid_parity ;
      end

      if ( p2_fid2qidix_data_f.qid [ 1 : 0 ] == 2'd3 ) begin
        fifo_enqueue3_push                       = 1'b1 ;
        fifo_enqueue3_push_cq               = rmw_fid2cqqidix_p2_data_f [ 8 : 3 ] ;
        fifo_enqueue3_push_qid              = p2_fid2qidix_data_f.qid ;
        fifo_enqueue3_push_qidix            = rmw_fid2cqqidix_p2_data_f [ 2 : 0 ] ;
        fifo_enqueue3_push_parity           = p2_fid2qidix_data_f.parity ;
        fifo_enqueue3_push_qpri             = p2_fid2qidix_data_f.qpri ;
        fifo_enqueue3_push_bin              = p2_fid2qidix_data_f.bin ;
        fifo_enqueue3_push_fid              = p2_fid2qidix_data_f.fid ;
        fifo_enqueue3_push_fid_parity       = p2_fid2qidix_data_f.fid_parity ;
      end
  end
end

aw_rmwpipe_cmd_t hqm_aw_rmwpipe_noop ;
aw_rmwpipe_cmd_t hqm_aw_rmwpipe_read ;
assign hqm_aw_rmwpipe_noop = HQM_AW_RMWPIPE_NOOP ; //assign to parameter constant to prevent "Lintra 0241 implicit casting" warning
assign hqm_aw_rmwpipe_read = HQM_AW_RMWPIPE_READ ; //assign to parameter constant to prevent "Lintra 0241 implicit casting" warning
                                                                                                                                                                                                                                                                                                  

always_comb begin : L15
  //....................................................................................................
  // p0 ll pipeline
  p0_debug_print_nc = '0 ;

  p0_ll_ctrl = '0 ;
  p0_ll_v_nxt = '0 ;
  p0_ll_data_nxt = p0_ll_data_f ;

  rmw_ll_rdylst_hp_p0_hold = '0 ;
  rmw_ll_rdylst_tp_p0_hold = '0 ;
  rmw_ll_schlst_hp_p0_hold = '0 ;
  rmw_ll_schlst_tp_p0_hold = '0 ;

  fifo_ap_lsp_enq_inc = '0 ;
  fifo_ap_aqed_inc = '0 ;

  rmw_ll_rdylst_hp_p0_v_nxt = '0 ;
  rmw_ll_rdylst_hp_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hp_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hp_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hp_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hp_p0_addr_nxt = '0 ;
  rmw_ll_rdylst_hp_p0_write_data_nxt_nc = '0 ;

  rmw_ll_rdylst_tp_p0_v_nxt = '0 ;
  rmw_ll_rdylst_tp_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_tp_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_tp_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_tp_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_tp_p0_addr_nxt = '0 ;
  rmw_ll_rdylst_tp_p0_write_data_nxt_nc = '0 ;

  rmw_ll_schlst_hp_p0_v_nxt = '0 ;
  rmw_ll_schlst_hp_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hp_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hp_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hp_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hp_p0_addr_nxt = '0 ;
  rmw_ll_schlst_hp_p0_write_data_nxt_nc = '0 ;

  rmw_ll_schlst_tp_p0_v_nxt = '0 ;
  rmw_ll_schlst_tp_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tp_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tp_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tp_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tp_p0_addr_nxt = '0 ;
  rmw_ll_schlst_tp_p0_write_data_nxt_nc = '0 ;

  fifo_enqueue0_pop = '0 ;
  fifo_enqueue1_pop = '0 ;
  fifo_enqueue2_pop = '0 ;
  fifo_enqueue3_pop = '0 ;


  arb_ll_strict_reqs = '0 ;

  arb_enqueue_reqs = '0 ;
  arb_enqueue_mask0 = '0 ;
  arb_enqueue_mask1 = '0 ;
  arb_enqueue_mask = '0 ;
  arb_enqueue_update = '0 ;

  db_lsp_ap_atm_ready = db_lsp_ap_atm_valid ? ( ( arb_ll_strict_winner_v  ) & ( ~ arb_ll_strict_winner ) ) : 1'b1 ;

  feature_enq_afull = '0 ;

  db_lsp_aqed_cmp_v = '0 ;
  db_lsp_aqed_cmp_data = '0 ;

  //.........................
  p0_ll_ctrl.hold                               = ( p0_ll_v_f & p1_ll_ctrl.hold ) ;
  p0_ll_ctrl.enable                             = arb_ll_strict_winner_v ;
  rmw_ll_rdylst_hp_p0_hold                      = { 4 { p0_ll_ctrl.hold } } ;
  rmw_ll_rdylst_tp_p0_hold                      = { 4 { p0_ll_ctrl.hold } } ;
  rmw_ll_schlst_hp_p0_hold                      = { 4 { p0_ll_ctrl.hold } } ;
  rmw_ll_schlst_tp_p0_hold                      = { 4 { p0_ll_ctrl.hold } } ;

  //arbuter to select a qid to enqueue
  arb_enqueue_reqs [ 0 ]                          = ( fifo_enqueue0_pop_v ) ;
  arb_enqueue_reqs [ 1 ]                          = ( fifo_enqueue1_pop_v ) ;
  arb_enqueue_reqs [ 2 ]                          = ( fifo_enqueue2_pop_v ) ;
  arb_enqueue_reqs [ 3 ]                          = ( fifo_enqueue3_pop_v ) ;

  if ( ~ cfg_control0_f [ HQM_ATM_CHICKEN_DIS_ENQSTALL ] ) begin

  arb_enqueue_mask0 [ 0 ]                          = ~ ( ( p0_ll_v_f & ( p0_ll_data_f.qid == fifo_enqueue0_pop_qid ) )
                                                      | ( p1_ll_v_f & ( p1_ll_data_f.qid == fifo_enqueue0_pop_qid ) )
                                                      ) ;
  arb_enqueue_mask0 [ 1 ]                          = ~ ( ( p0_ll_v_f & ( p0_ll_data_f.qid == fifo_enqueue1_pop_qid ) )
                                                      | ( p1_ll_v_f & ( p1_ll_data_f.qid == fifo_enqueue1_pop_qid ) )
                                                      ) ;
  arb_enqueue_mask0 [ 2 ]                          = ~ ( ( p0_ll_v_f & ( p0_ll_data_f.qid == fifo_enqueue2_pop_qid ) )
                                                      | ( p1_ll_v_f & ( p1_ll_data_f.qid == fifo_enqueue2_pop_qid ) )
                                                      ) ;
  arb_enqueue_mask0 [ 3 ]                          = ~ ( ( p0_ll_v_f & ( p0_ll_data_f.qid == fifo_enqueue3_pop_qid ) )
                                                      | ( p1_ll_v_f & ( p1_ll_data_f.qid == fifo_enqueue3_pop_qid ) )
                                                      ) ;
  end
  else begin
    arb_enqueue_mask0 = 4'b1111 ;
  end

  if ( cfg_control0_f [ HQM_ATM_CHICKEN_EN_ENQBLOCKRLST ] ) begin

  arb_enqueue_mask1 [ 0 ]                          = ~ ( ( ( p0_ll_v_f & ( p0_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p0_ll_data_f.rdysch ) & ( p0_ll_data_f.qid == fifo_enqueue0_pop_qid ) ) )
                                                      | ( ( p1_ll_v_f & ( p1_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p1_ll_data_f.rdysch ) & ( p1_ll_data_f.qid == fifo_enqueue0_pop_qid ) ) )
                                                      | ( ( p2_ll_v_f & ( p2_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p2_ll_data_f.rdysch ) & ( p2_ll_data_f.qid == fifo_enqueue0_pop_qid ) ) )
                                                      | ( ( p3_ll_v_f & ( p3_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p3_ll_data_f.rdysch ) & ( p3_ll_data_f.qid == fifo_enqueue0_pop_qid ) ) )
                                                      | ( ( p4_ll_v_f & ( p4_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p4_ll_data_f.rdysch ) & ( p4_ll_data_f.qid == fifo_enqueue0_pop_qid ) ) )
                                                      | ( ( p5_ll_v_f & ( p5_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p5_ll_data_f.rdysch ) & ( p5_ll_data_f.qid == fifo_enqueue0_pop_qid ) ) )
                                                      ) ;
  arb_enqueue_mask1 [ 1 ]                          = ~ ( ( ( p0_ll_v_f & ( p0_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p0_ll_data_f.rdysch ) & ( p0_ll_data_f.qid == fifo_enqueue1_pop_qid ) ) )
                                                      | ( ( p1_ll_v_f & ( p1_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p1_ll_data_f.rdysch ) & ( p1_ll_data_f.qid == fifo_enqueue1_pop_qid ) ) )
                                                      | ( ( p2_ll_v_f & ( p2_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p2_ll_data_f.rdysch ) & ( p2_ll_data_f.qid == fifo_enqueue1_pop_qid ) ) )
                                                      | ( ( p3_ll_v_f & ( p3_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p3_ll_data_f.rdysch ) & ( p3_ll_data_f.qid == fifo_enqueue1_pop_qid ) ) )
                                                      | ( ( p4_ll_v_f & ( p4_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p4_ll_data_f.rdysch ) & ( p4_ll_data_f.qid == fifo_enqueue1_pop_qid ) ) )
                                                      | ( ( p5_ll_v_f & ( p5_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p5_ll_data_f.rdysch ) & ( p5_ll_data_f.qid == fifo_enqueue1_pop_qid ) ) )
                                                      ) ;

  arb_enqueue_mask1 [ 2 ]                          = ~ ( ( ( p0_ll_v_f & ( p0_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p0_ll_data_f.rdysch ) & ( p0_ll_data_f.qid == fifo_enqueue2_pop_qid ) ) )
                                                      | ( ( p1_ll_v_f & ( p1_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p1_ll_data_f.rdysch ) & ( p1_ll_data_f.qid == fifo_enqueue2_pop_qid ) ) )
                                                      | ( ( p2_ll_v_f & ( p2_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p2_ll_data_f.rdysch ) & ( p2_ll_data_f.qid == fifo_enqueue2_pop_qid ) ) )
                                                      | ( ( p3_ll_v_f & ( p3_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p3_ll_data_f.rdysch ) & ( p3_ll_data_f.qid == fifo_enqueue2_pop_qid ) ) )
                                                      | ( ( p4_ll_v_f & ( p4_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p4_ll_data_f.rdysch ) & ( p4_ll_data_f.qid == fifo_enqueue2_pop_qid ) ) )
                                                      | ( ( p5_ll_v_f & ( p5_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p5_ll_data_f.rdysch ) & ( p5_ll_data_f.qid == fifo_enqueue2_pop_qid ) ) )
                                                      ) ;

  arb_enqueue_mask1 [ 3 ]                          = ~ ( ( ( p0_ll_v_f & ( p0_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p0_ll_data_f.rdysch ) & ( p0_ll_data_f.qid == fifo_enqueue3_pop_qid ) ) )
                                                      | ( ( p1_ll_v_f & ( p1_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p1_ll_data_f.rdysch ) & ( p1_ll_data_f.qid == fifo_enqueue3_pop_qid ) ) )
                                                      | ( ( p2_ll_v_f & ( p2_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p2_ll_data_f.rdysch ) & ( p2_ll_data_f.qid == fifo_enqueue3_pop_qid ) ) )
                                                      | ( ( p3_ll_v_f & ( p3_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p3_ll_data_f.rdysch ) & ( p3_ll_data_f.qid == fifo_enqueue3_pop_qid ) ) )
                                                      | ( ( p4_ll_v_f & ( p4_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p4_ll_data_f.rdysch ) & ( p4_ll_data_f.qid == fifo_enqueue3_pop_qid ) ) )
                                                      | ( ( p5_ll_v_f & ( p5_ll_data_f.cmd == HQM_ATM_CMD_DEQ ) & ( ~ p5_ll_data_f.rdysch ) & ( p5_ll_data_f.qid == fifo_enqueue3_pop_qid ) ) )
                                                      ) ;
  end
  else begin
    arb_enqueue_mask1 = 4'b1111 ;
  end

  arb_enqueue_mask [ 0 ] = arb_enqueue_mask0 [ 0 ] & arb_enqueue_mask1 [ 0 ] ;
  arb_enqueue_mask [ 1 ] = arb_enqueue_mask0 [ 1 ] & arb_enqueue_mask1 [ 1 ] ;
  arb_enqueue_mask [ 2 ] = arb_enqueue_mask0 [ 2 ] & arb_enqueue_mask1 [ 2 ] ;
  arb_enqueue_mask [ 3 ] = arb_enqueue_mask0 [ 3 ] & arb_enqueue_mask1 [ 3 ] ;

  //select from LSP (SCH or CMP) with strict priority. 
  // fill in gaps with enqueue,  

//need to block CHICKEN_DIS_ENQ_AFULL_HP_MODE when cfg is active becuase the enqueue FIFO is not processed and can deadlock since afull will not go away if set when cfg access is issued
  if ( ( ~ p0_ll_ctrl.hold ) ) begin
    if ( ( db_lsp_ap_atm_valid  )
 & ( ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_CMP ) ? db_lsp_aqed_cmp_ready : 1'b1 )
       & ( ( cfg_control0_f [ HQM_ATM_CHICKEN_DIS_ENQ_AFULL_HP_MODE ] | cfg_req_idlepipe ) ? 1'b1 : ~ ( fifo_aqed_ap_enq_afull ) )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_50 ]  ? ( ~ p0_ll_v_f ) : 1'b1 )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_33 ]  ? ( ~ p0_ll_v_f & ~ p1_ll_v_f ) : 1'b1 )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_25 ]  ? ( ~ p0_ll_v_f & ~ p1_ll_v_f & ~ p2_ll_v_f ) : 1'b1 )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_SIM ] ? ( ~ p0_ll_v_f & ~ p1_ll_v_f & ~ p2_ll_v_f & ~ p3_ll_v_f & ~ p4_ll_v_f & ~ p5_ll_v_syncopy0_f & ~ p6_ll_v_f ) : 1'b1 )
       )  begin
      arb_ll_strict_reqs [ 0 ]                     = 1'b1 ;
    end
if ( fifo_aqed_ap_enq_afull & cfg_control0_f [ HQM_ATM_CHICKEN_DIS_ENQ_AFULL_HP_MODE ] & db_lsp_ap_atm_valid & ( ~ arb_ll_strict_reqs [ 0 ] ) ) begin
feature_enq_afull = 1'b1 ;
end
    if ( ( fifo_ap_lsp_enq_cnt_f < cfg_control4_f [ 4 : 0 ] )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_50 ]  ? ( ~ p0_ll_v_f ) : 1'b1 )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_33 ]  ? ( ~ p0_ll_v_f & ~ p1_ll_v_f ) : 1'b1 )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_25 ]  ? ( ~ p0_ll_v_f & ~ p1_ll_v_f & ~ p2_ll_v_f ) : 1'b1 )
       & ( cfg_control0_f [ HQM_ATM_CHICKEN_SIM ] ? ( ~ p0_ll_v_f & ~ p1_ll_v_f & ~ p2_ll_v_f & ~ p3_ll_v_f & ~ p4_ll_v_f & ~ p5_ll_v_syncopy0_f & ~ p6_ll_v_f ) : 1'b1 )
       ) begin
      if ( arb_enqueue_winner_v  ) begin
        arb_ll_strict_reqs [ 1 ]                   = 1'b1 ;
      end
    end
  end

  if ( p0_ll_ctrl.enable | p0_ll_ctrl.hold ) begin
    p0_ll_v_nxt                                 = 1'b1 ;
  end
  if ( p0_ll_ctrl.enable ) begin

    if ( ( arb_ll_strict_winner_v  ) & ( ~ arb_ll_strict_winner ) & ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_CMP ) ) begin

      db_lsp_aqed_cmp_v = 1'b1 ;
      db_lsp_aqed_cmp_data.fid = db_lsp_ap_atm_data.fid ;
      db_lsp_aqed_cmp_data.qid = db_lsp_ap_atm_data.qid [ 6 : 0 ] ;
      db_lsp_aqed_cmp_data.hid = db_lsp_ap_atm_data.hid ;
      db_lsp_aqed_cmp_data.hid_parity = db_lsp_ap_atm_data.hid_parity ;
      db_lsp_aqed_cmp_data.fid_parity = db_lsp_ap_atm_data.fid_parity ;

      p0_ll_data_nxt                            = '0 ;                  // Cover any missing/spare bits
      p0_ll_data_nxt.pcm                        = db_lsp_ap_atm_data.pcm ;
      p0_ll_data_nxt.cmd                        = HQM_ATM_CMD_CMP ;
      p0_ll_data_nxt.cmd_syncopy                    = p0_ll_data_nxt.cmd ;
      p0_ll_data_nxt.rdysch                     = '0 ;
      p0_ll_data_nxt.cq                         = db_lsp_ap_atm_data.cq [ 5 : 0 ] ;
      p0_ll_data_nxt.qid                        = db_lsp_ap_atm_data.qid ;
      p0_ll_data_nxt.qidix_msb                  = db_lsp_ap_atm_data.qidix_msb ;
      p0_ll_data_nxt.qidix                      = db_lsp_ap_atm_data.qidix ;
      p0_ll_data_nxt.parity                     = db_lsp_ap_atm_data.parity ;
      p0_ll_data_nxt.qpri                       = db_lsp_ap_atm_data.qpri ;
      p0_ll_data_nxt.bin                        = db_lsp_ap_atm_data.qpri [ 2 : 1 ] ;
      p0_ll_data_nxt.rdy_hp                     = '0 ;
      p0_ll_data_nxt.rdy_tp                     = '0 ;
      p0_ll_data_nxt.sch_hp                     = '0 ;
      p0_ll_data_nxt.sch_tp                     = '0 ;
      p0_ll_data_nxt.fid                        = db_lsp_ap_atm_data.fid ;
      p0_ll_data_nxt.fid_parity                 = db_lsp_ap_atm_data.fid_parity ;
      p0_ll_data_nxt.rdy_hp_parity              = '0 ;
      p0_ll_data_nxt.rdy_tp_parity              = '0 ;
      p0_ll_data_nxt.sch_hp_parity              = '0 ;
      p0_ll_data_nxt.sch_tp_parity              = '0 ;
      p0_ll_data_nxt.error                      = '0 ;
      p0_ll_data_nxt.hqm_core_flags             = '0 ;
      p0_ll_data_nxt.bypassed_sch_tp                   = '0 ;
      p0_ll_data_nxt.super_bypassed                 = '0 ;
    end

    if ( ( arb_ll_strict_winner_v  ) & ( ~ arb_ll_strict_winner ) & ( ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) | ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST ) ) ) begin

      p0_ll_data_nxt                            = '0 ;                  // Cover any missing/spare bits
      p0_ll_data_nxt.pcm                        = db_lsp_ap_atm_data.pcm ;
      p0_ll_data_nxt.cmd                        = HQM_ATM_CMD_DEQ ;
if ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) begin
      p0_ll_data_nxt.rdysch                     = 1'b0 ;
end
if ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST ) begin
      p0_ll_data_nxt.rdysch                     = 1'b1 ;
end
      p0_ll_data_nxt.cmd_syncopy                    = p0_ll_data_nxt.cmd ;
      p0_ll_data_nxt.cq                         = db_lsp_ap_atm_data.cq [ 5 : 0 ] ;
      p0_ll_data_nxt.qid                        = db_lsp_ap_atm_data.qid ;
      p0_ll_data_nxt.qidix_msb                  = db_lsp_ap_atm_data.qidix_msb ;
      p0_ll_data_nxt.qidix                      = db_lsp_ap_atm_data.qidix ;
      p0_ll_data_nxt.parity                     = db_lsp_ap_atm_data.parity ;
      p0_ll_data_nxt.qpri                       = '0 ;
      p0_ll_data_nxt.bin                        = '0 ;
      p0_ll_data_nxt.rdy_hp                     = '0 ;
      p0_ll_data_nxt.rdy_tp                     = '0 ;
      p0_ll_data_nxt.sch_hp                     = '0 ;
      p0_ll_data_nxt.sch_tp                     = '0 ;
      p0_ll_data_nxt.fid                        = '0 ;
      p0_ll_data_nxt.fid_parity                 = '0 ;
      p0_ll_data_nxt.rdy_hp_parity              = '0 ;
      p0_ll_data_nxt.rdy_tp_parity              = '0 ;
      p0_ll_data_nxt.sch_hp_parity              = '0 ;
      p0_ll_data_nxt.sch_tp_parity              = '0 ;
      p0_ll_data_nxt.error                      = '0 ;
      p0_ll_data_nxt.hqm_core_flags             = db_lsp_ap_atm_data.hqm_core_flags ;
      p0_ll_data_nxt.bypassed_sch_tp                   = '0 ;
      p0_ll_data_nxt.super_bypassed                 = '0 ;

      fifo_ap_aqed_inc                          = 1'b1 ;
    end
    if ( ( arb_ll_strict_winner_v  ) & ( arb_ll_strict_winner  ) ) begin
      arb_enqueue_update                     = 1'b1 ;
      fifo_ap_lsp_enq_inc                       = 1'b1 ;

      if ( arb_enqueue_winner == 2'd0 ) begin
        fifo_enqueue0_pop                       = 1'b1 ;
        p0_ll_data_nxt                          = '0 ;                  // Cover any missing/spare bits
        p0_ll_data_nxt.cmd                      = HQM_ATM_CMD_ENQ ;
        p0_ll_data_nxt.cmd_syncopy                  = p0_ll_data_nxt.cmd ;
        p0_ll_data_nxt.rdysch                   = '0 ;
        p0_ll_data_nxt.cq                       = fifo_enqueue0_pop_cq ;
        p0_ll_data_nxt.qid                      = fifo_enqueue0_pop_qid ;
        p0_ll_data_nxt.qidix                    = fifo_enqueue0_pop_qidix ;
        p0_ll_data_nxt.parity                   = fifo_enqueue0_pop_parity ;
        p0_ll_data_nxt.qpri                     = fifo_enqueue0_pop_qpri ;
        p0_ll_data_nxt.bin                      = fifo_enqueue0_pop_bin ;
        p0_ll_data_nxt.rdy_hp                   = '0 ;
        p0_ll_data_nxt.rdy_tp                   = '0 ;
        p0_ll_data_nxt.sch_hp                   = '0 ;
        p0_ll_data_nxt.sch_tp                   = '0 ;
        p0_ll_data_nxt.fid                      = fifo_enqueue0_pop_fid ;
        p0_ll_data_nxt.fid_parity               = fifo_enqueue0_pop_fid_parity ;
        p0_ll_data_nxt.rdy_hp_parity            = '0 ;
        p0_ll_data_nxt.rdy_tp_parity            = '0 ;
        p0_ll_data_nxt.sch_hp_parity            = '0 ;
        p0_ll_data_nxt.sch_tp_parity            = '0 ;
        p0_ll_data_nxt.error                    = '0 ;
        p0_ll_data_nxt.hqm_core_flags           = '0 ;
      p0_ll_data_nxt.bypassed_sch_tp                   = '0 ;
      p0_ll_data_nxt.super_bypassed                 = '0 ;
      end

      if ( arb_enqueue_winner == 2'd1 ) begin
        fifo_enqueue1_pop                       = 1'b1 ;
        p0_ll_data_nxt                          = '0 ;                  // Cover any missing/spare bits
        p0_ll_data_nxt.cmd                      = HQM_ATM_CMD_ENQ ;
        p0_ll_data_nxt.cmd_syncopy                  = p0_ll_data_nxt.cmd ;
        p0_ll_data_nxt.rdysch                   = '0 ;
        p0_ll_data_nxt.cq                       = fifo_enqueue1_pop_cq ;
        p0_ll_data_nxt.qid                      = fifo_enqueue1_pop_qid ;
        p0_ll_data_nxt.qidix                    = fifo_enqueue1_pop_qidix ;
        p0_ll_data_nxt.parity                   = fifo_enqueue1_pop_parity ;
        p0_ll_data_nxt.qpri                     = fifo_enqueue1_pop_qpri ;
        p0_ll_data_nxt.bin                      = fifo_enqueue1_pop_bin ;
        p0_ll_data_nxt.rdy_hp                   = '0 ;
        p0_ll_data_nxt.rdy_tp                   = '0 ;
        p0_ll_data_nxt.sch_hp                   = '0 ;
        p0_ll_data_nxt.sch_tp                   = '0 ;
        p0_ll_data_nxt.fid                      = fifo_enqueue1_pop_fid ;
        p0_ll_data_nxt.fid_parity               = fifo_enqueue1_pop_fid_parity ;
        p0_ll_data_nxt.rdy_hp_parity            = '0 ;
        p0_ll_data_nxt.rdy_tp_parity            = '0 ;
        p0_ll_data_nxt.sch_hp_parity            = '0 ;
        p0_ll_data_nxt.sch_tp_parity            = '0 ;
        p0_ll_data_nxt.error                    = '0 ;
        p0_ll_data_nxt.hqm_core_flags           = '0 ;
      p0_ll_data_nxt.bypassed_sch_tp                   = '0 ;
      p0_ll_data_nxt.super_bypassed                 = '0 ;
      end

      if ( arb_enqueue_winner == 2'd2 ) begin
        fifo_enqueue2_pop                       = 1'b1 ;
        p0_ll_data_nxt                          = '0 ;                  // Cover any missing/spare bits
        p0_ll_data_nxt.cmd                      = HQM_ATM_CMD_ENQ ;
        p0_ll_data_nxt.cmd_syncopy                  = p0_ll_data_nxt.cmd ;
        p0_ll_data_nxt.rdysch                   = '0 ;
        p0_ll_data_nxt.cq                       = fifo_enqueue2_pop_cq ;
        p0_ll_data_nxt.qid                      = fifo_enqueue2_pop_qid ;
        p0_ll_data_nxt.qidix                    = fifo_enqueue2_pop_qidix ;
        p0_ll_data_nxt.parity                   = fifo_enqueue2_pop_parity ;
        p0_ll_data_nxt.qpri                     = fifo_enqueue2_pop_qpri ;
        p0_ll_data_nxt.bin                      = fifo_enqueue2_pop_bin ;
        p0_ll_data_nxt.rdy_hp                   = '0 ;
        p0_ll_data_nxt.rdy_tp                   = '0 ;
        p0_ll_data_nxt.sch_hp                   = '0 ;
        p0_ll_data_nxt.sch_tp                   = '0 ;
        p0_ll_data_nxt.fid                      = fifo_enqueue2_pop_fid ;
        p0_ll_data_nxt.fid_parity               = fifo_enqueue2_pop_fid_parity ;
        p0_ll_data_nxt.rdy_hp_parity            = '0 ;
        p0_ll_data_nxt.rdy_tp_parity            = '0 ;
        p0_ll_data_nxt.sch_hp_parity            = '0 ;
        p0_ll_data_nxt.sch_tp_parity            = '0 ;
        p0_ll_data_nxt.error                    = '0 ;
        p0_ll_data_nxt.hqm_core_flags           = '0 ;
      p0_ll_data_nxt.bypassed_sch_tp                   = '0 ;
      p0_ll_data_nxt.super_bypassed                 = '0 ;
      end

      if ( arb_enqueue_winner == 2'd3 ) begin
        fifo_enqueue3_pop                       = 1'b1 ;
        p0_ll_data_nxt                          = '0 ;                  // Cover any missing/spare bits
        p0_ll_data_nxt.cmd                      = HQM_ATM_CMD_ENQ ;
        p0_ll_data_nxt.cmd_syncopy                  = p0_ll_data_nxt.cmd ;
        p0_ll_data_nxt.rdysch                   = '0 ;
        p0_ll_data_nxt.cq                       = fifo_enqueue3_pop_cq ;
        p0_ll_data_nxt.qid                      = fifo_enqueue3_pop_qid ;
        p0_ll_data_nxt.qidix                    = fifo_enqueue3_pop_qidix ;
        p0_ll_data_nxt.parity                   = fifo_enqueue3_pop_parity ;
        p0_ll_data_nxt.qpri                     = fifo_enqueue3_pop_qpri ;
        p0_ll_data_nxt.bin                      = fifo_enqueue3_pop_bin ;
        p0_ll_data_nxt.rdy_hp                   = '0 ;
        p0_ll_data_nxt.rdy_tp                   = '0 ;
        p0_ll_data_nxt.sch_hp                   = '0 ;
        p0_ll_data_nxt.sch_tp                   = '0 ;
        p0_ll_data_nxt.fid                      = fifo_enqueue3_pop_fid ;
        p0_ll_data_nxt.fid_parity               = fifo_enqueue3_pop_fid_parity ;
        p0_ll_data_nxt.rdy_hp_parity            = '0 ;
        p0_ll_data_nxt.rdy_tp_parity            = '0 ;
        p0_ll_data_nxt.sch_hp_parity            = '0 ;
        p0_ll_data_nxt.sch_tp_parity            = '0 ;
        p0_ll_data_nxt.error                    = '0 ;
        p0_ll_data_nxt.hqm_core_flags           = '0 ;
      p0_ll_data_nxt.bypassed_sch_tp                   = '0 ;
      p0_ll_data_nxt.super_bypassed                 = '0 ;
      end

    end


    rmw_ll_rdylst_hp_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_rdylst_hp_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hp_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hp_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hp_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hp_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p0_ll_data_nxt.qid } } ;
    rmw_ll_rdylst_hp_p0_write_data_nxt_nc          = '0 ;

    rmw_ll_rdylst_tp_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_rdylst_tp_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_tp_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_tp_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_tp_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_tp_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p0_ll_data_nxt.qid } } ;
    rmw_ll_rdylst_tp_p0_write_data_nxt_nc          = '0 ;

    rmw_ll_schlst_hp_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_hp_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hp_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hp_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hp_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hp_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p0_ll_data_nxt.cq , p0_ll_data_nxt.qidix } } ;
    rmw_ll_schlst_hp_p0_write_data_nxt_nc          = '0 ;

    rmw_ll_schlst_tp_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_tp_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tp_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tp_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tp_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tp_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p0_ll_data_nxt.cq , p0_ll_data_nxt.qidix } } ;
    rmw_ll_schlst_tp_p0_write_data_nxt_nc          = '0 ;

  end

  //BYPASS CQ & QIDIX for ENQUEUE that read old assignment
  if ( ( p0_ll_v_nxt  )
     & ( p0_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ )
     & ( rmw_fid2cqqidix_p3_bypdata_sel_nxt  )
     & ( rmw_fid2cqqidix_p3_bypaddr_nxt == p0_ll_data_nxt.fid )
     ) begin
    p0_debug_print_nc [ 0 ] = 1'b1 ;
    p0_ll_data_nxt.cq                          = p6_ll_data_nxt.cq ;
    p0_ll_data_nxt.qidix                       = p6_ll_data_nxt.qidix ;

    //need to bypass the slst tp since they are being read with incorrect cq,qidix. 
    // if p6 SCH is going R->E on the schedule then use the exisiting sch_tp. 
    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : axx0
      if ( ~ rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ] ) begin
        p0_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p0_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] ;
        p0_ll_data_nxt.sch_tp_parity [ i ] = p6_ll_data_nxt.sch_tp_parity [ i ] ;
      end
      else begin
        p0_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p0_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
        p0_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
      end
    end
  end
  //if slst tp was bypassed and cq,qidix slst tp is updated then use latest
  for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : axx1
    if ( ( p0_ll_v_nxt  )
       & ( p0_ll_data_nxt.bypassed_sch_tp [ i ]  )
       & ( p0_ll_data_nxt.cq == p6_ll_data_nxt.cq )
       & ( p0_ll_data_nxt.qidix == p6_ll_data_nxt.qidix )
       & ( rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ]  )
       ) begin
      p0_ll_data_nxt.super_bypassed = 1'b1 ;
      p0_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
      p0_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
    end
  end



end

always_comb begin : L16
  //....................................................................................................
  // p1 ll pipeline
  p1_debug_print_nc = '0 ;
  p1_ll_ctrl = '0 ;
  p1_ll_v_nxt = '0 ;
  p1_ll_data_nxt = p1_ll_data_f ;

  rmw_ll_rdylst_hp_p1_hold = '0 ;
  rmw_ll_rdylst_tp_p1_hold = '0 ;
  rmw_ll_schlst_hp_p1_hold = '0 ;
  rmw_ll_schlst_tp_p1_hold = '0 ;

  //.........................
  p1_ll_ctrl.hold                               = ( p1_ll_v_f & p2_ll_ctrl.hold ) ;
  p1_ll_ctrl.enable                             = ( p0_ll_v_f & ~ p1_ll_ctrl.hold ) ;

  if ( p1_ll_ctrl.enable | p1_ll_ctrl.hold ) begin
    p1_ll_v_nxt                                = 1'b1 ;
  end
  if ( p1_ll_ctrl.enable ) begin
    p1_ll_data_nxt                             = p0_ll_data_f ;
  end

  //BYPASS CQ & QIDIX for ENQUEUE that read old assignment
  if ( ( p1_ll_v_nxt  )
     & ( p1_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ )
     & ( rmw_fid2cqqidix_p3_bypdata_sel_nxt  )
     & ( rmw_fid2cqqidix_p3_bypaddr_nxt == p1_ll_data_nxt.fid )
     ) begin
    p1_debug_print_nc [ 0 ] = 1'b1 ;
    p1_ll_data_nxt.cq                          = p6_ll_data_nxt.cq ;
    p1_ll_data_nxt.qidix                       = p6_ll_data_nxt.qidix ;

    //need to bypass the slst tp since they are being read with incorrect cq,qidix. 
    // if p6 SCH is going R->E on the schedule then use the exisiting sch_tp. 
    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : bxx0
      if ( ~ rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ] ) begin
        p1_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p1_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] ;
        p1_ll_data_nxt.sch_tp_parity [ i ] = p6_ll_data_nxt.sch_tp_parity [ i ] ;
      end
      else begin
        p1_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p1_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
        p1_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
      end
    end
  end
  //if slst tp was bypassed and cq,qidix slst tp is updated then use latest
  for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : bxx1
    if ( ( p1_ll_v_nxt  )
       & ( p1_ll_data_nxt.bypassed_sch_tp [ i ]  )
       & ( p1_ll_data_nxt.cq == p6_ll_data_nxt.cq )
       & ( p1_ll_data_nxt.qidix == p6_ll_data_nxt.qidix )
       & ( rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ]  )
       ) begin
      p1_ll_data_nxt.super_bypassed = 1'b1 ;
      p1_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
      p1_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
    end
  end


  rmw_ll_rdylst_hp_p1_hold                     = { 4 { p1_ll_ctrl.hold } } ;
  rmw_ll_rdylst_tp_p1_hold                     = { 4 { p1_ll_ctrl.hold } } ;
  rmw_ll_schlst_hp_p1_hold                     = { 4 { p1_ll_ctrl.hold } } ;
  rmw_ll_schlst_tp_p1_hold                     = { 4 { p1_ll_ctrl.hold } } ;
end


always_comb begin : L17
  //....................................................................................................
  // p2 ll pipeline
  p2_debug_print_nc = '0 ;
  p2_ll_ctrl = '0 ;
  p2_ll_v_nxt = '0 ;
  p2_ll_data_nxt = p2_ll_data_f ;

  rmw_ll_rdylst_hp_p2_hold = '0 ;
  rmw_ll_rdylst_tp_p2_hold = '0 ;
  rmw_ll_schlst_hp_p2_hold = '0 ;
  rmw_ll_schlst_tp_p2_hold = '0 ;

  //.........................
  p2_ll_ctrl.hold                               = ( p2_ll_v_f & ( p3_ll_ctrl.hold
                                                  ) ) ;
  p2_ll_ctrl.enable                             = ( p1_ll_v_f & ~ p2_ll_ctrl.hold ) ;

  if ( p2_ll_ctrl.enable | p2_ll_ctrl.hold ) begin
    p2_ll_v_nxt                                = 1'b1 ;
  end
  if ( p2_ll_ctrl.enable ) begin
    p2_ll_data_nxt                             = p1_ll_data_f ;
  end

  //BYPASS CQ & QIDIX for ENQUEUE that read old assignment
  if ( ( p2_ll_v_nxt  )
     & ( p2_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ )
     & ( rmw_fid2cqqidix_p3_bypdata_sel_nxt  )
     & ( rmw_fid2cqqidix_p3_bypaddr_nxt == p2_ll_data_nxt.fid )
     ) begin
    p2_debug_print_nc [ 0 ] = 1'b1 ;
    p2_ll_data_nxt.cq                          = p6_ll_data_nxt.cq ;
    p2_ll_data_nxt.qidix                       = p6_ll_data_nxt.qidix ;

    //need to bypass the slst tp since they are being read with incorrect cq,qidix. 
    // if p6 SCH is going R->E on the schedule then use the exisiting sch_tp. 
    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : cxx0
      if ( ~ rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ] ) begin
        p2_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p2_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] ;
        p2_ll_data_nxt.sch_tp_parity [ i ] = p6_ll_data_nxt.sch_tp_parity [ i ] ;
      end
      else begin
        p2_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p2_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
        p2_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
      end
    end
  end
  //if slst tp was bypassed and cq,qidix slst tp is updated then use latest
  for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : cxx1
    if ( ( p2_ll_v_nxt  )
       & ( p2_ll_data_nxt.bypassed_sch_tp [ i ]  )
       & ( p2_ll_data_nxt.cq == p6_ll_data_nxt.cq )
       & ( p2_ll_data_nxt.qidix == p6_ll_data_nxt.qidix )
       & ( rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ]  )
       ) begin
      p2_ll_data_nxt.super_bypassed = 1'b1 ;
      p2_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
      p2_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
    end
  end



  rmw_ll_rdylst_hp_p2_hold                     = { 4 { p2_ll_ctrl.hold } } ;
  rmw_ll_rdylst_tp_p2_hold                     = { 4 { p2_ll_ctrl.hold } } ;
  rmw_ll_schlst_hp_p2_hold                     = { 4 { p2_ll_ctrl.hold } } ;
  rmw_ll_schlst_tp_p2_hold                     = { 4 { p2_ll_ctrl.hold } } ;
end

always_comb begin : L18
  //....................................................................................................
  // p3 ll pipeline
  p3_debug_print_nc = '0 ;
  p3_ll_ctrl = '0 ;
  p3_ll_v_nxt = '0 ;
  p3_ll_data_nxt = p3_ll_data_f ;

  rmw_ll_rdylst_hp_p3_hold = '0 ;
  rmw_ll_rdylst_tp_p3_hold = '0 ;
  rmw_ll_schlst_hp_p3_hold = '0 ;
  rmw_ll_schlst_tp_p3_hold = '0 ;

  rmw_ll_rdylst_hpnxt_p0_hold = '0 ;
  rmw_ll_schlst_hpnxt_p0_hold = '0 ;
  rmw_ll_schlst_tpprv_p0_hold = '0 ;
  rmw_ll_rlst_cnt_p0_hold = '0 ;
  rmw_ll_slst_cnt_p0_hold = '0 ;
  rmw_ll_enq_cnt_r_dup0_p0_hold = '0 ;
  rmw_ll_enq_cnt_r_dup1_p0_hold = '0 ;
  rmw_ll_enq_cnt_r_dup2_p0_hold = '0 ;
  rmw_ll_enq_cnt_r_dup3_p0_hold = '0 ;
  rmw_ll_enq_cnt_s_p0_hold = '0 ;
  rmw_ll_sch_cnt_p0_hold = '0 ;

  parity_check_ll_rdylst_bin0_hp_p = '0 ;
  parity_check_ll_rdylst_bin0_hp_d = '0 ;
  parity_check_ll_rdylst_bin0_hp_e = '0 ;

  parity_check_ll_rdylst_bin0_tp_p = '0 ;
  parity_check_ll_rdylst_bin0_tp_d = '0 ;
  parity_check_ll_rdylst_bin0_tp_e = '0 ;

  parity_check_ll_rdylst_bin1_hp_p = '0 ;
  parity_check_ll_rdylst_bin1_hp_d = '0 ;
  parity_check_ll_rdylst_bin1_hp_e = '0 ;

  parity_check_ll_rdylst_bin1_tp_p = '0 ;
  parity_check_ll_rdylst_bin1_tp_d = '0 ;
  parity_check_ll_rdylst_bin1_tp_e = '0 ;

  parity_check_ll_rdylst_bin2_hp_p = '0 ;
  parity_check_ll_rdylst_bin2_hp_d = '0 ;
  parity_check_ll_rdylst_bin2_hp_e = '0 ;

  parity_check_ll_rdylst_bin2_tp_p = '0 ;
  parity_check_ll_rdylst_bin2_tp_d = '0 ;
  parity_check_ll_rdylst_bin2_tp_e = '0 ;

  parity_check_ll_rdylst_bin3_hp_p = '0 ;
  parity_check_ll_rdylst_bin3_hp_d = '0 ;
  parity_check_ll_rdylst_bin3_hp_e = '0 ;

  parity_check_ll_rdylst_bin3_tp_p = '0 ;
  parity_check_ll_rdylst_bin3_tp_d = '0 ;
  parity_check_ll_rdylst_bin3_tp_e = '0 ;

  parity_check_ll_schlst_bin0_hp_p = '0 ;
  parity_check_ll_schlst_bin0_hp_d = '0 ;
  parity_check_ll_schlst_bin0_hp_e = '0 ;

  parity_check_ll_schlst_bin0_tp_p = '0 ;
  parity_check_ll_schlst_bin0_tp_d = '0 ;
  parity_check_ll_schlst_bin0_tp_e = '0 ;

  parity_check_ll_schlst_bin1_hp_p = '0 ;
  parity_check_ll_schlst_bin1_hp_d = '0 ;
  parity_check_ll_schlst_bin1_hp_e = '0 ;

  parity_check_ll_schlst_bin1_tp_p = '0 ;
  parity_check_ll_schlst_bin1_tp_d = '0 ;
  parity_check_ll_schlst_bin1_tp_e = '0 ;

  parity_check_ll_schlst_bin2_hp_p = '0 ;
  parity_check_ll_schlst_bin2_hp_d = '0 ;
  parity_check_ll_schlst_bin2_hp_e = '0 ;

  parity_check_ll_schlst_bin2_tp_p = '0 ;
  parity_check_ll_schlst_bin2_tp_d = '0 ;
  parity_check_ll_schlst_bin2_tp_e = '0 ;

  parity_check_ll_schlst_bin3_hp_p = '0 ;
  parity_check_ll_schlst_bin3_hp_d = '0 ;
  parity_check_ll_schlst_bin3_hp_e = '0 ;

  parity_check_ll_schlst_bin3_tp_p = '0 ;
  parity_check_ll_schlst_bin3_tp_d = '0 ;
  parity_check_ll_schlst_bin3_tp_e = '0 ;


  rmw_qid_rdylst_clamp_p0_v_nxt = '0 ;
  rmw_qid_rdylst_clamp_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_qid_rdylst_clamp_p0_addr_nxt = '0 ;
  rmw_qid_rdylst_clamp_p0_write_data_nxt_nc = '0 ;

  rmw_ll_rdylst_hpnxt_p0_v_nxt = '0 ;
  rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_addr_nxt = '0 ;
  rmw_ll_rdylst_hpnxt_p0_write_data_nxt = '0 ;

  rmw_ll_schlst_hpnxt_p0_v_nxt = '0 ;
  rmw_ll_schlst_hpnxt_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_addr_nxt = '0 ;
  rmw_ll_schlst_hpnxt_p0_write_data_nxt = '0 ;

  rmw_ll_schlst_tpprv_p0_v_nxt = '0 ;
  rmw_ll_schlst_tpprv_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_addr_nxt = '0 ;
  rmw_ll_schlst_tpprv_p0_write_data_nxt = '0 ;

  rmw_ll_rlst_cnt_p0_v_nxt = '0 ;
  rmw_ll_rlst_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_ll_rlst_cnt_p0_addr_nxt = '0 ;
  rmw_ll_rlst_cnt_p0_write_data_nxt = '0 ;

  rmw_ll_slst_cnt_p0_v_nxt = '0 ;
  rmw_ll_slst_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_ll_slst_cnt_p0_addr_nxt = '0 ;
  rmw_ll_slst_cnt_p0_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup0_p0_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup0_p0_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup1_p0_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup1_p0_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup2_p0_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup2_p0_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup3_p0_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup3_p0_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_s_p0_v_nxt = '0 ;
  rmw_ll_enq_cnt_s_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_addr_nxt = '0 ;
  rmw_ll_enq_cnt_s_p0_write_data_nxt = '0 ;

  rmw_ll_sch_cnt_p0_v_nxt = '0 ;
  rmw_ll_sch_cnt_p0_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_addr_nxt = '0 ;
  rmw_ll_sch_cnt_p0_write_data_nxt = '0 ;

  rmw_ll_rdylst_hpnxt_p0_byp_v_nxt = '0 ;
  rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_rdylst_hpnxt_p0_byp_addr_nxt = '0 ;
  rmw_ll_rdylst_hpnxt_p0_byp_write_data_nxt = '0 ;

  rmw_ll_schlst_hpnxt_p0_byp_v_nxt = '0 ;
  rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_hpnxt_p0_byp_addr_nxt = '0 ;
  rmw_ll_schlst_hpnxt_p0_byp_write_data_nxt = '0 ;

  rmw_ll_schlst_tpprv_p0_byp_v_nxt = '0 ;
  rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_schlst_tpprv_p0_byp_addr_nxt = '0 ;
  rmw_ll_schlst_tpprv_p0_byp_write_data_nxt = '0 ;

  rmw_ll_rlst_cnt_p0_byp_v_nxt = '0 ;
  rmw_ll_rlst_cnt_p0_byp_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_ll_rlst_cnt_p0_byp_addr_nxt = '0 ;
  rmw_ll_rlst_cnt_p0_byp_write_data_nxt = '0 ;

  rmw_ll_slst_cnt_p0_byp_v_nxt = '0 ;
  rmw_ll_slst_cnt_p0_byp_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rmw_ll_slst_cnt_p0_byp_addr_nxt = '0 ;
  rmw_ll_slst_cnt_p0_byp_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup0_p0_byp_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup0_p0_byp_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup0_p0_byp_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup1_p0_byp_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup1_p0_byp_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup1_p0_byp_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup2_p0_byp_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup2_p0_byp_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup2_p0_byp_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup3_p0_byp_v_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_r_dup3_p0_byp_addr_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup3_p0_byp_write_data_nxt = '0 ;

  rmw_ll_enq_cnt_s_p0_byp_v_nxt = '0 ;
  rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_enq_cnt_s_p0_byp_addr_nxt = '0 ;
  rmw_ll_enq_cnt_s_p0_byp_write_data_nxt = '0 ;

  rmw_ll_sch_cnt_p0_byp_v_nxt = '0 ;
  rmw_ll_sch_cnt_p0_byp_rw_nxt [ 0 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_byp_rw_nxt [ 1 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_byp_rw_nxt [ 2 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_byp_rw_nxt [ 3 ] = hqm_aw_rmwpipe_noop ;
  rmw_ll_sch_cnt_p0_byp_addr_nxt = '0 ;
  rmw_ll_sch_cnt_p0_byp_write_data_nxt = '0 ;


  //.........................
  stall_nc                                      = ( p3_ll_v_f
                                                  & ( ( p4_ll_v_f & ( p4_ll_data_f.qid == p3_ll_data_f.qid ) )
                                                    | ( p5_ll_v_syncopy1_f & ( p5_ll_data_f.qid == p3_ll_data_f.qid ) )
                                                    )
                                                  ) ;

  p3_ll_ctrl.hold                               = ( p3_ll_v_f & ( p4_ll_ctrl.hold | stall_f [ 0 ] ) ) ;
  p3_ll_ctrl.enable                             = ( p2_ll_v_f & ~ p3_ll_ctrl.hold
                                                  ) ;
  p3_ll_ctrl.bypsel                             = ( stall_f [ 1 ] ) ;

  rmw_ll_rdylst_hpnxt_p0_hold                   = { 4 { p3_ll_ctrl.hold } } ;
  rmw_ll_schlst_hpnxt_p0_hold                   = { 4 { p3_ll_ctrl.hold } } ;
  rmw_ll_schlst_tpprv_p0_hold                   = { 4 { p3_ll_ctrl.hold } } ;
  rmw_qid_rdylst_clamp_p0_hold                       = p3_ll_ctrl.hold ;
  rmw_ll_rlst_cnt_p0_hold                       = p3_ll_ctrl.hold ;
  rmw_ll_slst_cnt_p0_hold                       = p3_ll_ctrl.hold ;
  rmw_ll_enq_cnt_r_dup0_p0_hold                      = { 4 { p3_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup1_p0_hold                      = { 4 { p3_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup2_p0_hold                      = { 4 { p3_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup3_p0_hold                      = { 4 { p3_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_s_p0_hold                      = { 4 { p3_ll_ctrl.hold } } ;
  rmw_ll_sch_cnt_p0_hold                        = { 4 { p3_ll_ctrl.hold } } ;

  if ( p3_ll_ctrl.enable | p3_ll_ctrl.hold ) begin
    p3_ll_v_nxt                                 = 1'b1 ;
  end
  if ( p3_ll_ctrl.enable ) begin
      p3_ll_data_nxt                              = p2_ll_data_f ;

    parity_check_ll_rdylst_bin0_hp_p            = { rmw_ll_rdylst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin0_hp_d            = { rmw_ll_rdylst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin0_hp_e            = 1'b1 ;

    parity_check_ll_rdylst_bin0_tp_p            = { rmw_ll_rdylst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin0_tp_d            = { rmw_ll_rdylst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin0_tp_e            = 1'b1 ;

    parity_check_ll_rdylst_bin1_hp_p            = { rmw_ll_rdylst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin1_hp_d            = { rmw_ll_rdylst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin1_hp_e            = 1'b1 ;

    parity_check_ll_rdylst_bin1_tp_p            = { rmw_ll_rdylst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin1_tp_d            = { rmw_ll_rdylst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin1_tp_e            = 1'b1 ;

    parity_check_ll_rdylst_bin2_hp_p            = { rmw_ll_rdylst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin2_hp_d            = { rmw_ll_rdylst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin2_hp_e            = 1'b1 ;

    parity_check_ll_rdylst_bin2_tp_p            = { rmw_ll_rdylst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin2_tp_d            = { rmw_ll_rdylst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin2_tp_e            = 1'b1 ;

    parity_check_ll_rdylst_bin3_hp_p            = { rmw_ll_rdylst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin3_hp_d            = { rmw_ll_rdylst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin3_hp_e            = 1'b1 ;

    parity_check_ll_rdylst_bin3_tp_p            = { rmw_ll_rdylst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin3_tp_d            = { rmw_ll_rdylst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_rdylst_bin3_tp_e            = 1'b1 ;

    parity_check_ll_schlst_bin0_hp_p            = { rmw_ll_schlst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin0_hp_d            = { rmw_ll_schlst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin0_hp_e            = 1'b1 ;

    parity_check_ll_schlst_bin0_tp_p            = { rmw_ll_schlst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin0_tp_d            = { rmw_ll_schlst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin0_tp_e            = 1'b1 ;

    parity_check_ll_schlst_bin1_hp_p            = { rmw_ll_schlst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin1_hp_d            = { rmw_ll_schlst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin1_hp_e            = 1'b1 ;

    parity_check_ll_schlst_bin1_tp_p            = { rmw_ll_schlst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin1_tp_d            = { rmw_ll_schlst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin1_tp_e            = 1'b1 ;

    parity_check_ll_schlst_bin2_hp_p            = { rmw_ll_schlst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin2_hp_d            = { rmw_ll_schlst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin2_hp_e            = 1'b1 ;

    parity_check_ll_schlst_bin2_tp_p            = { rmw_ll_schlst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin2_tp_d            = { rmw_ll_schlst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin2_tp_e            = 1'b1 ;

    parity_check_ll_schlst_bin3_hp_p            = { rmw_ll_schlst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin3_hp_d            = { rmw_ll_schlst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin3_hp_e            = 1'b1 ;

    parity_check_ll_schlst_bin3_tp_p            = { rmw_ll_schlst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin3_tp_d            = { rmw_ll_schlst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
    parity_check_ll_schlst_bin3_tp_e            = 1'b1 ;


    p3_ll_data_nxt.rdy_hp                       = { rmw_ll_rdylst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  } ;
    p3_ll_data_nxt.rdy_tp                       = { rmw_ll_rdylst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ]
                                                  } ;

    p3_ll_data_nxt.sch_hp [ ( 3 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
    p3_ll_data_nxt.sch_hp [ ( 2 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
    p3_ll_data_nxt.sch_hp [ ( 1 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
    p3_ll_data_nxt.sch_hp [ ( 0 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;

if ( ~ p2_ll_data_f.bypassed_sch_tp [ 3 ] ) begin //NOTE: use p2_ll_data_f and not p3_ll_data_nxt to avoid lint issue   Syntax - Read before write in always_comb block not allowed: p3_ll_data_nxt bit(s) 1 read at line 7981 and written at line 8256 in same always_comb block
    p3_ll_data_nxt.sch_tp [ ( 3 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
end
if ( ~ p2_ll_data_f.bypassed_sch_tp [ 2 ] ) begin
    p3_ll_data_nxt.sch_tp [ ( 2 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
end
if ( ~ p2_ll_data_f.bypassed_sch_tp [ 1 ] ) begin
    p3_ll_data_nxt.sch_tp [ ( 1 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
end
if ( ~ p2_ll_data_f.bypassed_sch_tp [ 0 ] ) begin
    p3_ll_data_nxt.sch_tp [ ( 0 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
end


    p3_ll_data_nxt.rdy_hp_parity                = { rmw_ll_rdylst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  } ;
    p3_ll_data_nxt.rdy_tp_parity                = { rmw_ll_rdylst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  , rmw_ll_rdylst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ]
                                                  } ;
    p3_ll_data_nxt.sch_hp_parity [ 3 ]              = rmw_ll_schlst_hp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
    p3_ll_data_nxt.sch_hp_parity [ 2 ]              = rmw_ll_schlst_hp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
    p3_ll_data_nxt.sch_hp_parity [ 1 ]              = rmw_ll_schlst_hp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
    p3_ll_data_nxt.sch_hp_parity [ 0 ]              = rmw_ll_schlst_hp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;

if ( ~ p2_ll_data_f.bypassed_sch_tp [ 3 ] ) begin
    p3_ll_data_nxt.sch_tp_parity [ 3 ]              = rmw_ll_schlst_tp_p2_data_f [ ( 3 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
end
if ( ~ p2_ll_data_f.bypassed_sch_tp [ 2 ] ) begin
    p3_ll_data_nxt.sch_tp_parity [ 2 ]              = rmw_ll_schlst_tp_p2_data_f [ ( 2 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
end
if ( ~ p2_ll_data_f.bypassed_sch_tp [ 1 ] ) begin
    p3_ll_data_nxt.sch_tp_parity [ 1 ]              = rmw_ll_schlst_tp_p2_data_f [ ( 1 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
end
if ( ~ p2_ll_data_f.bypassed_sch_tp [ 0 ] ) begin
    p3_ll_data_nxt.sch_tp_parity [ 0 ]              = rmw_ll_schlst_tp_p2_data_f [ ( 0 * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
end



  //BYPASS CQ & QIDIX for ENQUEUE that read old assignment
  if ( ( p3_ll_v_nxt  )
     & ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ )
     & ( rmw_fid2cqqidix_p3_bypdata_sel_nxt  )
     & ( rmw_fid2cqqidix_p3_bypaddr_nxt == p3_ll_data_nxt.fid )
     ) begin
    p3_debug_print_nc [ 1 ] = 1'b1 ;
    p3_ll_data_nxt.cq                          = p6_ll_data_nxt.cq ;
    p3_ll_data_nxt.qidix                       = p6_ll_data_nxt.qidix ;

    //need to bypass the slst tp since they are being read with incorrect cq,qidix. 
    // if p6 SCH is going R->E on the schedule then use the exisiting sch_tp. 
    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : dxx0
      if ( ~ rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ] ) begin
        p3_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p3_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] ;
        p3_ll_data_nxt.sch_tp_parity [ i ] = p6_ll_data_nxt.sch_tp_parity [ i ] ;
      end
      else begin
        p3_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p3_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
        p3_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
      end
    end

  end


    //bypass directly into pipline storage (RMW does not have this bypass)
    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : xxx0
      if ( rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.qid == p3_ll_data_nxt.qid )
         ) begin
        p3_ll_data_nxt.rdy_hp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.rdy_hp_parity [ i ]               = { rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end
      if ( rmw_ll_rdylst_tp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.qid == p3_ll_data_nxt.qid )
         )  begin
        p3_ll_data_nxt.rdy_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_rdylst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.rdy_tp_parity [ i ]               = { rmw_ll_rdylst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end

      if ( rmw_ll_schlst_hp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.cq == p3_ll_data_nxt.cq )
         & ( p6_ll_data_nxt.qidix == p3_ll_data_nxt.qidix )
         ) begin
        p3_ll_data_nxt.sch_hp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_schlst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.sch_hp_parity [ i ]               = { rmw_ll_schlst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end
      if ( rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.cq == p3_ll_data_nxt.cq )
         & ( p6_ll_data_nxt.qidix == p3_ll_data_nxt.qidix )
         ) begin
        p3_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.sch_tp_parity [ i ]               = { rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end
    end

    rmw_qid_rdylst_clamp_p0_v_nxt                    = 1'b1 ;
    rmw_qid_rdylst_clamp_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_qid_rdylst_clamp_p0_addr_nxt                 = p3_ll_data_nxt.qid ;

if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_CMP ) begin

    rmw_ll_rdylst_hpnxt_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_addr_nxt             = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_schlst_hpnxt_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_addr_nxt             = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_schlst_tpprv_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_addr_nxt             = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_rlst_cnt_p0_v_nxt                    = 1'b1 ;
    rmw_ll_rlst_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_ll_rlst_cnt_p0_addr_nxt                 = p3_ll_data_nxt.qid ;

    rmw_ll_slst_cnt_p0_v_nxt                    = 1'b1 ;
    rmw_ll_slst_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_ll_slst_cnt_p0_addr_nxt                 = { p3_ll_data_nxt.cq , p3_ll_data_nxt.qidix } ;


    rmw_ll_enq_cnt_r_dup0_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_r_dup1_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_r_dup2_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_r_dup3_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_s_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_sch_cnt_p0_v_nxt                     = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 0 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 1 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 2 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 3 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_addr_nxt                  = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;
end
if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ ) begin

    rmw_ll_rdylst_hpnxt_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ; 
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ; 
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ; 
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ; 
    rmw_ll_rdylst_hpnxt_p0_addr_nxt             = { p3_ll_data_nxt.rdy_hp } ;

    rmw_ll_schlst_hpnxt_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_addr_nxt             = { p3_ll_data_nxt.sch_hp } ;

    rmw_ll_schlst_tpprv_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_addr_nxt             = { p3_ll_data_nxt.sch_tp } ;

    rmw_ll_rlst_cnt_p0_v_nxt                    = 1'b1 ;
    rmw_ll_rlst_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_ll_rlst_cnt_p0_addr_nxt                 = p3_ll_data_nxt.qid ;

    rmw_ll_slst_cnt_p0_v_nxt                    = 1'b1 ;
    rmw_ll_slst_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_ll_slst_cnt_p0_addr_nxt                 = { p3_ll_data_nxt.cq , p3_ll_data_nxt.qidix } ;


    if ( ~ p3_ll_data_nxt.rdysch ) begin
    rmw_ll_enq_cnt_r_dup0_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 0 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup1_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 1 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup2_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 2 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup3_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 3 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_s_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_addr_nxt                = { p3_ll_data_nxt.rdy_hp } ;

    rmw_ll_sch_cnt_p0_v_nxt                     = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 0 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 1 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 2 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 3 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_addr_nxt                  = { p3_ll_data_nxt.rdy_hp } ;
    end
    if ( p3_ll_data_nxt.rdysch  ) begin
    rmw_ll_enq_cnt_r_dup0_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 0 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup1_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 1 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup2_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 2 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup3_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 3 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_s_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_addr_nxt                = { p3_ll_data_nxt.sch_hp } ;

    rmw_ll_sch_cnt_p0_v_nxt                     = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 0 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 1 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 2 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 3 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_addr_nxt                  = { p3_ll_data_nxt.sch_hp } ;
    end
end
if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) begin

    rmw_ll_rdylst_hpnxt_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_addr_nxt             = { p3_ll_data_nxt.rdy_hp } ;

    rmw_ll_schlst_hpnxt_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_addr_nxt             = { p3_ll_data_nxt.sch_hp } ;

    rmw_ll_schlst_tpprv_p0_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_addr_nxt             = { p3_ll_data_nxt.sch_tp } ;

    rmw_ll_rlst_cnt_p0_v_nxt                    = 1'b1 ;
    rmw_ll_rlst_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_ll_rlst_cnt_p0_addr_nxt                 = p3_ll_data_nxt.qid ;

    rmw_ll_slst_cnt_p0_v_nxt                    = 1'b1 ;
    rmw_ll_slst_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_ll_slst_cnt_p0_addr_nxt                 = { p3_ll_data_nxt.cq , p3_ll_data_nxt.qidix } ;


    rmw_ll_enq_cnt_r_dup0_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_r_dup1_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_r_dup2_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_r_dup3_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_enq_cnt_s_p0_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;

    rmw_ll_sch_cnt_p0_v_nxt                     = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 0 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 1 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 2 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_rw_nxt [ 3 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_addr_nxt                  = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.fid } } ;
end


  end



  if ( p3_ll_ctrl.bypsel ) begin

  //BYPASS CQ & QIDIX for ENQUEUE that read old assignment
  if ( ( p3_ll_v_nxt  )
     & ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ )
     & ( rmw_fid2cqqidix_p3_bypdata_sel_nxt  )
     & ( rmw_fid2cqqidix_p3_bypaddr_nxt == p3_ll_data_nxt.fid )
     ) begin
    p3_debug_print_nc [ 0 ] = 1'b1 ;
    p3_ll_data_nxt.cq                          = p6_ll_data_nxt.cq ;
    p3_ll_data_nxt.qidix                       = p6_ll_data_nxt.qidix ;

    rmw_ll_slst_cnt_p0_byp_v_nxt                    = 1'b1 ;
    rmw_ll_slst_cnt_p0_byp_rw_nxt                   = HQM_AW_RMWPIPE_READ ;
    rmw_ll_slst_cnt_p0_byp_addr_nxt                 = { p3_ll_data_nxt.cq , p3_ll_data_nxt.qidix } ;

    //need to bypass the slst tp since they are being read with incorrect cq,qidix. 
    // if p6 SCH is going R->E on the schedule then use the exisiting sch_tp. 
    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : dxx1
      if ( ~ rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ] ) begin
        p3_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p3_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] ;
        p3_ll_data_nxt.sch_tp_parity [ i ] = p6_ll_data_nxt.sch_tp_parity [ i ] ;
      end
      else begin
        p3_ll_data_nxt.bypassed_sch_tp [ i ] = 1'b1 ;
        p3_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] ;
        p3_ll_data_nxt.sch_tp_parity [ i ] = rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] ;
      end
    end
  end









    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : xx111
      if ( rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.qid == p3_ll_data_nxt.qid )
         ) begin
        p3_ll_data_nxt.rdy_hp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.rdy_hp_parity [ i ]               = { rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end
    end

if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ ) begin
    rmw_ll_rdylst_hpnxt_p0_byp_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_addr_nxt             = p3_ll_data_nxt.rdy_hp ;

    if ( ~ p3_ll_data_nxt.rdysch ) begin
    rmw_ll_enq_cnt_r_dup0_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 0 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ]  } } ;

    rmw_ll_enq_cnt_r_dup1_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 1 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ]  } } ;

    rmw_ll_enq_cnt_r_dup2_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 2 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ]  } } ;

    rmw_ll_enq_cnt_r_dup3_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 3 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ]  } } ;

    rmw_ll_enq_cnt_s_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_addr_nxt                = { p3_ll_data_nxt.rdy_hp } ;

    rmw_ll_sch_cnt_p0_byp_v_nxt                     = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 0 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 1 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 2 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 3 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_addr_nxt                  = { p3_ll_data_nxt.rdy_hp } ;
    end

    if ( p3_ll_data_nxt.rdysch  ) begin
    rmw_ll_enq_cnt_r_dup0_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup0_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 0 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup1_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup1_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 1 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup2_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup2_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 2 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;

    rmw_ll_enq_cnt_r_dup3_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_r_dup3_p0_byp_addr_nxt                = { HQM_ATM_NUM_BIN { p3_ll_data_nxt.rdy_hp [ ( 3 * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } } ;
    end
end
if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) begin
    rmw_ll_rdylst_hpnxt_p0_byp_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_rdylst_hpnxt_p0_byp_addr_nxt             = p3_ll_data_nxt.rdy_hp ;
end






    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : xx11
      if ( rmw_ll_rdylst_tp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.qid == p3_ll_data_nxt.qid )
         )  begin
        p3_ll_data_nxt.rdy_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_rdylst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.rdy_tp_parity [ i ]               = { rmw_ll_rdylst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end
    end








    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : xxx1
      if ( rmw_ll_schlst_hp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.cq == p3_ll_data_nxt.cq )
         & ( p6_ll_data_nxt.qidix == p3_ll_data_nxt.qidix )
         ) begin
        p3_ll_data_nxt.sch_hp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_schlst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.sch_hp_parity [ i ]               = { rmw_ll_schlst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end
    end

if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ ) begin
    rmw_ll_schlst_hpnxt_p0_byp_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_addr_nxt             = { p3_ll_data_nxt.sch_hp } ;

    if ( p3_ll_data_nxt.rdysch  ) begin
    rmw_ll_enq_cnt_s_p0_byp_v_nxt                   = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 0 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 1 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 2 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_rw_nxt [ 3 ]            = hqm_aw_rmwpipe_read ;
    rmw_ll_enq_cnt_s_p0_byp_addr_nxt                = { p3_ll_data_nxt.sch_hp } ;

    rmw_ll_sch_cnt_p0_byp_v_nxt                     = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 0 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 1 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 2 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_rw_nxt [ 3 ]              = hqm_aw_rmwpipe_read ;
    rmw_ll_sch_cnt_p0_byp_addr_nxt                  = { p3_ll_data_nxt.sch_hp } ;
    end
end
if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) begin
    rmw_ll_schlst_hpnxt_p0_byp_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_hpnxt_p0_byp_addr_nxt             = { p3_ll_data_nxt.sch_hp } ;
end









    for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : xx21
      if ( rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ]
         & ( p6_ll_data_nxt.cq == p3_ll_data_nxt.cq )
         & ( p6_ll_data_nxt.qidix == p3_ll_data_nxt.qidix )
         ) begin
        p3_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] = { rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) +: HQM_ATM_FIDB2 ] } ;
        p3_ll_data_nxt.sch_tp_parity [ i ]               = { rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_FIDB2WP ) + HQM_ATM_FIDB2 ] } ;
      end
    end

if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ ) begin
    rmw_ll_schlst_tpprv_p0_byp_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_addr_nxt             = { p3_ll_data_nxt.sch_tp } ;
end
if ( p3_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) begin
    rmw_ll_schlst_tpprv_p0_byp_v_nxt                = { HQM_ATM_NUM_BIN { 1'b1 } } ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 0 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 1 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 2 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_rw_nxt [ 3 ]         = hqm_aw_rmwpipe_read ;
    rmw_ll_schlst_tpprv_p0_byp_addr_nxt             = { p3_ll_data_nxt.sch_tp } ;
end











  end





end

always_comb begin : L19
  //....................................................................................................
  // p4 ll pipeline
  p4_debug_print_nc = '0 ;
  p4_ll_ctrl = '0 ;
  p4_ll_v_nxt = '0 ;
  p4_ll_data_nxt = p4_ll_data_f ;

  rmw_ll_rdylst_hpnxt_p1_hold = '0 ;
  rmw_ll_schlst_hpnxt_p1_hold = '0 ;
  rmw_ll_schlst_tpprv_p1_hold = '0 ;
  rmw_qid_rdylst_clamp_p1_hold = '0 ;
  rmw_ll_rlst_cnt_p1_hold = '0 ;
  rmw_ll_slst_cnt_p1_hold = '0 ;
  rmw_ll_enq_cnt_r_dup0_p1_hold = '0 ;
  rmw_ll_enq_cnt_r_dup1_p1_hold = '0 ;
  rmw_ll_enq_cnt_r_dup2_p1_hold = '0 ;
  rmw_ll_enq_cnt_r_dup3_p1_hold = '0 ;
  rmw_ll_enq_cnt_s_p1_hold = '0 ;
  rmw_ll_sch_cnt_p1_hold = '0 ;

  //.........................
  p4_ll_ctrl.hold                               = ( p4_ll_v_f & p5_ll_ctrl.hold ) ;
  p4_ll_ctrl.enable                             = ( p3_ll_v_f & ~ stall_f [ 2 ] & ~ p4_ll_ctrl.hold ) ;

  rmw_ll_rdylst_hpnxt_p1_hold                   = { 4 { p4_ll_ctrl.hold } } ;
  rmw_ll_schlst_hpnxt_p1_hold                   = { 4 { p4_ll_ctrl.hold } } ;
  rmw_ll_schlst_tpprv_p1_hold                   = { 4 { p4_ll_ctrl.hold } } ;
  rmw_qid_rdylst_clamp_p1_hold                       = p4_ll_ctrl.hold ;
  rmw_ll_rlst_cnt_p1_hold                       = p4_ll_ctrl.hold ;
  rmw_ll_slst_cnt_p1_hold                       = p4_ll_ctrl.hold ;
  rmw_ll_enq_cnt_r_dup0_p1_hold                      = { 4 { p4_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup1_p1_hold                      = { 4 { p4_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup2_p1_hold                      = { 4 { p4_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup3_p1_hold                      = { 4 { p4_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_s_p1_hold                      = { 4 { p4_ll_ctrl.hold } } ;
  rmw_ll_sch_cnt_p1_hold                        = { 4 { p4_ll_ctrl.hold } } ;

  if ( p4_ll_ctrl.enable | p4_ll_ctrl.hold ) begin
    p4_ll_v_nxt                                 = 1'b1 ;
  end
  if ( p4_ll_ctrl.enable ) begin
    p4_ll_data_nxt                              = p3_ll_data_f ;
  end


end

always_comb begin : L20
  //....................................................................................................
  // p5 ll pipeline
  p5_debug_print_nc = '0 ;
  p5_ll_ctrl = '0 ;
  p5_ll_v_nxt = '0 ;
  p5_ll_data_nxt = p5_ll_data_f ;

  rmw_ll_rdylst_hpnxt_p2_hold = '0 ;
  rmw_ll_schlst_hpnxt_p2_hold = '0 ;
  rmw_ll_schlst_tpprv_p2_hold = '0 ;
  rmw_qid_rdylst_clamp_p2_hold = '0 ;
  rmw_ll_rlst_cnt_p2_hold = '0 ;
  rmw_ll_slst_cnt_p2_hold = '0 ;
  rmw_ll_enq_cnt_r_dup0_p2_hold = '0 ;
  rmw_ll_enq_cnt_r_dup1_p2_hold = '0 ;
  rmw_ll_enq_cnt_r_dup2_p2_hold = '0 ;
  rmw_ll_enq_cnt_r_dup3_p2_hold = '0 ;
  rmw_ll_enq_cnt_s_p2_hold = '0 ;
  rmw_ll_sch_cnt_p2_hold = '0 ;

  func_aqed_qid2cqidix_re = '0 ;
  func_aqed_qid2cqidix_addr = '0 ;

  //.........................
  p5_ll_ctrl.hold                               = ( p5_ll_v_syncopy2_f & p6_ll_ctrl.hold ) ;
  p5_ll_ctrl.enable                             = ( p4_ll_v_f & ~ p5_ll_ctrl.hold ) ;

  rmw_ll_rdylst_hpnxt_p2_hold                   = { 4 { p5_ll_ctrl.hold } } ;
  rmw_ll_schlst_hpnxt_p2_hold                   = { 4 { p5_ll_ctrl.hold } } ;
  rmw_ll_schlst_tpprv_p2_hold                   = { 4 { p5_ll_ctrl.hold } } ;
  rmw_qid_rdylst_clamp_p2_hold                       = p5_ll_ctrl.hold ;
  rmw_ll_rlst_cnt_p2_hold                       = p5_ll_ctrl.hold ;
  rmw_ll_slst_cnt_p2_hold                       = p5_ll_ctrl.hold ;
  rmw_ll_enq_cnt_r_dup0_p2_hold                      = { 4 { p5_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup1_p2_hold                      = { 4 { p5_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup2_p2_hold                      = { 4 { p5_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_r_dup3_p2_hold                      = { 4 { p5_ll_ctrl.hold } } ;
  rmw_ll_enq_cnt_s_p2_hold                      = { 4 { p5_ll_ctrl.hold } } ;
  rmw_ll_sch_cnt_p2_hold                        = { 4 { p5_ll_ctrl.hold } } ;

  if ( p5_ll_ctrl.enable | p5_ll_ctrl.hold ) begin
    p5_ll_v_nxt                                 = 1'b1 ;
  end
  if ( p5_ll_ctrl.enable ) begin
    p5_ll_data_nxt                              = p4_ll_data_f ;

    func_aqed_qid2cqidix_re = 1'b1 ;
    func_aqed_qid2cqidix_addr = p5_ll_data_nxt.qid ;
  end


end

always_comb begin : L21
  //....................................................................................................
  // p6 ll pipeline
  p6_debug_print_nc = '0 ;

credit_fifo_ap_aqed_dec_sch = '0 ;
credit_fifo_ap_aqed_dec_cmp = '0 ;

  feature_clamped_high = '0 ;
  feature_clamped_low = '0 ;


  rlst_total_nnc = '0 ;
  rlst_lt_blast_nnc = '0 ;
  rlst_e_ne_nnc = '0 ;
  rlst_ne_e_nnc = '0 ;
  slst_e_ne_nnc = '0 ;
  slst_ne_e_nnc = '0 ;
  ap_lsp_cmd_v_nxt = '0 ;
  ap_lsp_cmd_nxt = ap_lsp_cmd_f ;
  ap_lsp_cq_nxt = ap_lsp_cq_f ;
  ap_lsp_qidix_msb_nxt = ap_lsp_qidix_msb_f ;
  ap_lsp_qidix_nxt = ap_lsp_qidix_f ;
  ap_lsp_qid_nxt = ap_lsp_qid_f ;
  ap_lsp_qid2cqqidix_nxt = ap_lsp_qid2cqqidix_f ;
  ap_lsp_haswork_rlst_v_nxt = '0 ;
  ap_lsp_haswork_rlst_func_nxt = ap_lsp_haswork_rlst_func_f ;
  ap_lsp_haswork_slst_v_nxt = '0 ;
  ap_lsp_haswork_slst_func_nxt = ap_lsp_haswork_slst_func_f ;
  ap_lsp_cmpblast_v_nxt = '0 ;

  ap_lsp_dec_fid_cnt_v_nxt = '0 ;



  p6_ll_ctrl = '0 ;
  p6_ll_v_nxt = '0 ;
  p6_ll_data_nxt = p6_ll_data_f ;


  rmw_ll_rdylst_hpnxt_p3_hold = '0 ;
  rmw_ll_schlst_hpnxt_p3_hold = '0 ;
  rmw_ll_schlst_tpprv_p3_hold = '0 ;
  rmw_qid_rdylst_clamp_p3_hold = '0 ;
  rmw_ll_rlst_cnt_p3_hold = '0 ;
  rmw_ll_slst_cnt_p3_hold = '0 ;
  rmw_ll_enq_cnt_r_dup0_p3_hold = '0 ;
  rmw_ll_enq_cnt_r_dup1_p3_hold = '0 ;
  rmw_ll_enq_cnt_r_dup2_p3_hold = '0 ;
  rmw_ll_enq_cnt_r_dup3_p3_hold = '0 ;
  rmw_ll_enq_cnt_s_p3_hold = '0 ;
  rmw_ll_sch_cnt_p3_hold = '0 ;



  parity_check_ll_rdylst_bin0_hpnxt_p = '0 ;
  parity_check_ll_rdylst_bin0_hpnxt_d = '0 ;
  parity_check_ll_rdylst_bin0_hpnxt_e = '0 ;

  parity_check_ll_rdylst_bin1_hpnxt_p = '0 ;
  parity_check_ll_rdylst_bin1_hpnxt_d = '0 ;
  parity_check_ll_rdylst_bin1_hpnxt_e = '0 ;

  parity_check_ll_rdylst_bin2_hpnxt_p = '0 ;
  parity_check_ll_rdylst_bin2_hpnxt_d = '0 ;
  parity_check_ll_rdylst_bin2_hpnxt_e = '0 ;

  parity_check_ll_rdylst_bin3_hpnxt_p = '0 ;
  parity_check_ll_rdylst_bin3_hpnxt_d = '0 ;
  parity_check_ll_rdylst_bin3_hpnxt_e = '0 ;

  parity_check_ll_schlst_bin0_hpnxt_p = '0 ;
  parity_check_ll_schlst_bin0_hpnxt_d = '0 ;
  parity_check_ll_schlst_bin0_hpnxt_e = '0 ;

  parity_check_ll_schlst_bin0_tpprv_p = '0 ;
  parity_check_ll_schlst_bin0_tpprv_d = '0 ;
  parity_check_ll_schlst_bin0_tpprv_e = '0 ;

  parity_check_ll_schlst_bin1_hpnxt_p = '0 ;
  parity_check_ll_schlst_bin1_hpnxt_d = '0 ;
  parity_check_ll_schlst_bin1_hpnxt_e = '0 ;

  parity_check_ll_schlst_bin1_tpprv_p = '0 ;
  parity_check_ll_schlst_bin1_tpprv_d = '0 ;
  parity_check_ll_schlst_bin1_tpprv_e = '0 ;

  parity_check_ll_schlst_bin2_hpnxt_p = '0 ;
  parity_check_ll_schlst_bin2_hpnxt_d = '0 ;
  parity_check_ll_schlst_bin2_hpnxt_e = '0 ;

  parity_check_ll_schlst_bin2_tpprv_p = '0 ;
  parity_check_ll_schlst_bin2_tpprv_d = '0 ;
  parity_check_ll_schlst_bin2_tpprv_e = '0 ;

  parity_check_ll_schlst_bin3_hpnxt_p = '0 ;
  parity_check_ll_schlst_bin3_hpnxt_d = '0 ;
  parity_check_ll_schlst_bin3_hpnxt_e = '0 ;

  parity_check_ll_schlst_bin3_tpprv_p = '0 ;
  parity_check_ll_schlst_bin3_tpprv_d = '0 ;
  parity_check_ll_schlst_bin3_tpprv_e = '0 ;

  parity_gen_fid2cqqidix_d = '0 ;


  residue_check_ll_rlst_cnt_bin0_r = '0 ;
  residue_check_ll_rlst_cnt_bin0_d = '0 ;
  residue_check_ll_rlst_cnt_bin0_e = '0 ;

  residue_check_ll_rlst_cnt_bin1_r = '0 ;
  residue_check_ll_rlst_cnt_bin1_d = '0 ;
  residue_check_ll_rlst_cnt_bin1_e = '0 ;

  residue_check_ll_rlst_cnt_bin2_r = '0 ;
  residue_check_ll_rlst_cnt_bin2_d = '0 ;
  residue_check_ll_rlst_cnt_bin2_e = '0 ;

  residue_check_ll_rlst_cnt_bin3_r = '0 ;
  residue_check_ll_rlst_cnt_bin3_d = '0 ;
  residue_check_ll_rlst_cnt_bin3_e = '0 ;

  residue_check_ll_slst_cnt_bin0_r = '0 ;
  residue_check_ll_slst_cnt_bin0_d = '0 ;
  residue_check_ll_slst_cnt_bin0_e = '0 ;

  residue_check_enq_cnt_r_bin0_r = '0 ;
  residue_check_enq_cnt_r_bin0_d = '0 ;
  residue_check_enq_cnt_r_bin0_e = '0 ;

  residue_check_enq_cnt_s_bin0_r = '0 ;
  residue_check_enq_cnt_s_bin0_d = '0 ;
  residue_check_enq_cnt_s_bin0_e = '0 ;

  residue_check_sch_cnt_bin0_r = '0 ;
  residue_check_sch_cnt_bin0_d = '0 ;
  residue_check_sch_cnt_bin0_e = '0 ;

  residue_check_ll_slst_cnt_bin1_r = '0 ;
  residue_check_ll_slst_cnt_bin1_d = '0 ;
  residue_check_ll_slst_cnt_bin1_e = '0 ;

  residue_check_enq_cnt_r_bin1_r = '0 ;
  residue_check_enq_cnt_r_bin1_d = '0 ;
  residue_check_enq_cnt_r_bin1_e = '0 ;

  residue_check_enq_cnt_s_bin1_r = '0 ;
  residue_check_enq_cnt_s_bin1_d = '0 ;
  residue_check_enq_cnt_s_bin1_e = '0 ;

  residue_check_sch_cnt_bin1_r = '0 ;
  residue_check_sch_cnt_bin1_d = '0 ;
  residue_check_sch_cnt_bin1_e = '0 ;

  residue_check_ll_slst_cnt_bin2_r = '0 ;
  residue_check_ll_slst_cnt_bin2_d = '0 ;
  residue_check_ll_slst_cnt_bin2_e = '0 ;

  residue_check_enq_cnt_r_bin2_r = '0 ;
  residue_check_enq_cnt_r_bin2_d = '0 ;
  residue_check_enq_cnt_r_bin2_e = '0 ;

  residue_check_enq_cnt_s_bin2_r = '0 ;
  residue_check_enq_cnt_s_bin2_d = '0 ;
  residue_check_enq_cnt_s_bin2_e = '0 ;

  residue_check_sch_cnt_bin2_r = '0 ;
  residue_check_sch_cnt_bin2_d = '0 ;
  residue_check_sch_cnt_bin2_e = '0 ;

  residue_check_ll_slst_cnt_bin3_r = '0 ;
  residue_check_ll_slst_cnt_bin3_d = '0 ;
  residue_check_ll_slst_cnt_bin3_e = '0 ;

  residue_check_enq_cnt_r_bin3_r = '0 ;
  residue_check_enq_cnt_r_bin3_d = '0 ;
  residue_check_enq_cnt_r_bin3_e = '0 ;

  residue_check_enq_cnt_s_bin3_r = '0 ;
  residue_check_enq_cnt_s_bin3_d = '0 ;
  residue_check_enq_cnt_s_bin3_e = '0 ;

  residue_check_sch_cnt_bin3_r = '0 ;
  residue_check_sch_cnt_bin3_d = '0 ;
  residue_check_sch_cnt_bin3_e = '0 ;

  residue_add_enq_cnt_r_a = '0 ;
  residue_add_enq_cnt_r_b = '0 ;

  residue_sub_enq_cnt_r_a = '0 ;
  residue_sub_enq_cnt_r_b = '0 ;

  residue_add_enq_cnt_s_a = '0 ;
  residue_add_enq_cnt_s_b = '0 ;

  residue_sub_enq_cnt_s_a = '0 ;
  residue_sub_enq_cnt_s_b = '0 ;

  residue_add_sch_cnt_a = '0 ;
  residue_add_sch_cnt_b = '0 ;

  residue_sub_sch_cnt_a = '0 ;
  residue_sub_sch_cnt_b = '0 ;

  m_residue_add_slst_cnt_a = '0 ;
  m_residue_add_slst_cnt_b = '0 ;

  m_residue_sub_slst_cnt_a = '0 ;
  m_residue_sub_slst_cnt_b = '0 ;

  residue_add_slst_cnt_a = '0 ;
  residue_add_slst_cnt_b = '0 ;

  residue_sub_slst_cnt_a = '0 ;
  residue_sub_slst_cnt_b = '0 ;

  residue_add_rlst_cnt_a = '0 ;
  residue_add_rlst_cnt_b = '0 ;

  residue_sub_rlst_cnt_a = '0 ;
  residue_sub_rlst_cnt_b = '0 ;

  rmw_ll_rdylst_hp_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_rdylst_hp_p3_bypdata_nxt = '0 ;
  rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_rdylst_hp_p3_bypaddr_nxt = '0 ;

  rmw_ll_rdylst_tp_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_rdylst_tp_p3_bypdata_nxt = '0 ;
  rmw_ll_rdylst_tp_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_rdylst_tp_p3_bypaddr_nxt = '0 ;

  rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_rdylst_hpnxt_p3_bypdata_nxt = '0 ;
  rmw_ll_rdylst_hpnxt_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt = '0 ;

  rmw_qid_rdylst_clamp_p3_bypdata_sel_nxt = '0 ;
  rmw_qid_rdylst_clamp_p3_bypdata_nxt = '0 ;
  rmw_qid_rdylst_clamp_p3_bypaddr_sel_nxt = '0 ;
  rmw_qid_rdylst_clamp_p3_bypaddr_nxt = '0 ;

  rmw_ll_rlst_cnt_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_rlst_cnt_p3_bypdata_nxt = '0 ;
  rmw_ll_rlst_cnt_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_rlst_cnt_p3_bypaddr_nxt = '0 ;

  rmw_ll_schlst_hp_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_schlst_hp_p3_bypdata_nxt = '0 ;
  rmw_ll_schlst_hp_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_schlst_hp_p3_bypaddr_nxt = '0 ;

  rmw_ll_schlst_tp_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_schlst_tp_p3_bypdata_nxt = '0 ;
  rmw_ll_schlst_tp_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_schlst_tp_p3_bypaddr_nxt = '0 ;

  rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_schlst_hpnxt_p3_bypdata_nxt = '0 ;
  rmw_ll_schlst_hpnxt_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_schlst_hpnxt_p3_bypaddr_nxt = '0 ;

  rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_schlst_tpprv_p3_bypdata_nxt = '0 ;
  rmw_ll_schlst_tpprv_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_schlst_tpprv_p3_bypaddr_nxt = '0 ;

  rmw_ll_slst_cnt_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_slst_cnt_p3_bypdata_nxt = '0 ;
  rmw_ll_slst_cnt_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_slst_cnt_p3_bypaddr_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt = '0 ;

  rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt = '0 ;

  rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_enq_cnt_s_p3_bypdata_nxt = '0 ;
  rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_enq_cnt_s_p3_bypaddr_nxt = '0 ;

  rmw_ll_sch_cnt_p3_bypdata_sel_nxt = '0 ;
  rmw_ll_sch_cnt_p3_bypdata_nxt = '0 ;
  rmw_ll_sch_cnt_p3_bypaddr_sel_nxt = '0 ;
  rmw_ll_sch_cnt_p3_bypaddr_nxt = '0 ;

  rmw_fid2cqqidix_p3_bypdata_sel_nxt = '0 ;
  rmw_fid2cqqidix_p3_bypdata_nxt = '0 ;
  rmw_fid2cqqidix_p3_bypaddr_sel_nxt = '0 ;
  rmw_fid2cqqidix_p3_bypaddr_nxt = '0 ;

  fifo_ap_aqed_push = '0 ;
  fifo_ap_aqed_push_data = '0 ;


  fifo_ap_lsp_enq_push = '0 ;
  fifo_ap_lsp_enq_push_data = '0 ;

  arb_ll_sch_reqs = '0 ;
  arb_ll_rdy_reqs = '0 ;
  arb_ll_rdy_pri_dup0_reqs = '0 ;
  arb_ll_rdy_pri_dup1_reqs = '0 ;
  arb_ll_rdy_pri_dup2_reqs = '0 ;
  arb_ll_rdy_pri_dup3_reqs = '0 ;

  //
  sch_idle_nnc = '0 ;
  enq_empty_nnc = '0 ;

  enq_cnt_r_nnc = '0 ;
  enq_cnt_s_nnc = '0 ;
  sch_cnt_nnc = '0 ;
  slst_cnt_nnc = '0 ;
  rlst_cnt_nnc = '0 ;

  enq_cnt_rp1_nnc = '0 ;
  enq_cnt_rm1_nnc = '0 ;
  enq_cnt_sp1_nnc = '0 ;
  enq_cnt_sm1_nnc = '0 ;
  sch_cntp1_nnc = '0 ;
  sch_cntm1_nnc = '0 ;
  slst_cntp1_nnc = '0 ;
  slst_cntm1_nnc = '0 ;
  rlst_cntp1_nnc = '0 ;
  rlst_cntm1_nnc = '0 ;

  not_empty_nnc = '0 ;
  rdy_bin_nnc = '0 ;
  rdy_dup_nnc = '0 ;
  rdy_fid_nnc = '0 ;
  sch_bin_nnc = '0 ;
  sch_fid_nnc = '0 ;
  rdy_fid_parity_nnc = '0 ;
  sch_fid_parity_nnc = '0 ;
  sch_wins_nnc = '0 ;
  rdy_wins_nnc = '0 ;
  rdy_override_nnc = '0 ;

  error_ap_lsp = '0 ;
  error_headroom = '0 ;
  error_nopri = '0 ;
  error_enq_cnt_r_of_nnc = '0 ;
  error_enq_cnt_r_uf_nnc = '0 ;
  error_enq_cnt_s_of_nnc = '0 ;
  error_enq_cnt_s_uf_nnc = '0 ;
  error_rlst_cnt_of_nnc = '0 ;
  error_rlst_cnt_uf_nnc = '0 ;
  error_sch_cnt_of_nnc = '0 ;
  error_sch_cnt_uf_nnc = '0 ;
  error_slst_cnt_of_nnc = '0 ;
  error_slst_cnt_uf_nnc = '0 ;

  report_error_enq_cnt_r_of = '0 ;
  report_error_enq_cnt_r_uf = '0 ;
  report_error_enq_cnt_s_of = '0 ;
  report_error_enq_cnt_s_uf = '0 ;
  report_error_rlst_cnt_of = '0 ;
  report_error_rlst_cnt_uf = '0 ;
  report_error_sch_cnt_of = '0 ;
  report_error_sch_cnt_uf = '0 ;
  report_error_slst_cnt_of = '0 ;
  report_error_slst_cnt_uf = '0 ;

  parity_check_qid_rdylst_clamp_p = '0 ;
  parity_check_qid_rdylst_clamp_d = '0 ;
  parity_check_qid_rdylst_clamp_e = '0 ;

  fcnt = '0 ;
  tcnt = '0 ;
  block_sch2rdy = '0 ;

arb_ll_rdy_pri_dup0_reqs [ 3 ] =  ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup0_reqs [ 2 ] =  ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup0_reqs [ 1 ] =  ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup0_reqs [ 0 ] =  ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;

arb_ll_rdy_pri_dup1_reqs [ 3 ] =  ( | rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup1_reqs [ 2 ] =  ( | rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup1_reqs [ 1 ] =  ( | rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup1_reqs [ 0 ] =  ( | rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;

arb_ll_rdy_pri_dup2_reqs [ 3 ] =  ( | rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup2_reqs [ 2 ] =  ( | rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup2_reqs [ 1 ] =  ( | rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup2_reqs [ 0 ] =  ( | rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;

arb_ll_rdy_pri_dup3_reqs [ 3 ] =  ( | rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup3_reqs [ 2 ] =  ( | rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup3_reqs [ 1 ] =  ( | rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
arb_ll_rdy_pri_dup3_reqs [ 0 ] =  ( | rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;

for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : l_arb_ll_sch_reqs
  arb_ll_rdy_reqs [ i ]                     = ( | rmw_ll_rlst_cnt_p2_data_f [ ( i * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
  arb_ll_sch_reqs [ i ]                     = ( | rmw_ll_slst_cnt_p2_data_f [ ( i * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
end


enq_cnt_r_dup0_gt1 = '0 ;
enq_cnt_r_dup1_gt1 = '0 ;
enq_cnt_r_dup2_gt1 = '0 ;
enq_cnt_r_dup3_gt1 = '0 ;


      //RDY override:
      if ( ( p5_ll_data_f.rdysch  )
         & ~ ( | arb_ll_sch_reqs )
         &  ( | arb_ll_rdy_reqs )
         ) begin
      rdy_override_nnc = 1'b1 ;
      end
      //RDY override:

  //.........................
  p6_ll_ctrl.hold                               = 1'b0 ;
  p6_ll_ctrl.enable                             = ( p5_ll_v_f & ~ p6_ll_ctrl.hold ) ;

  error_headroom [ 0 ]                             = ( p5_ll_v_syncopy2_f
                                                  & ( ( p5_ll_data_f.cmd_syncopy == HQM_ATM_CMD_ENQ ) ? fifo_ap_aqed_afull : 1'b0 )
                                                  ) ;
  error_headroom [ 1 ]                             = ( p5_ll_v_syncopy2_f
                                                  & ( ( p5_ll_data_f.cmd_syncopy == HQM_ATM_CMD_DEQ ) ? fifo_ap_lsp_enq_afull : 1'b0 )
                                                  ) ;

  if ( p6_ll_ctrl.enable | p6_ll_ctrl.hold ) begin
    p6_ll_v_nxt                                 = 1'b1 ;
  end
  if ( p6_ll_ctrl.enable ) begin

    p6_ll_data_nxt                              = p5_ll_data_f ;

    parity_check_qid_rdylst_clamp_p = rmw_qid_rdylst_clamp_p2_data_f [ 5 ] ;
    parity_check_qid_rdylst_clamp_d = rmw_qid_rdylst_clamp_p2_data_f [ 4 : 0 ] ;
    parity_check_qid_rdylst_clamp_e = 1'b1 ;

    { parity_check_ll_rdylst_bin0_hpnxt_p , parity_check_ll_rdylst_bin0_hpnxt_d } = rmw_ll_rdylst_hpnxt_p2_data_f [ 0 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_rdylst_bin0_hpnxt_e              = 1'b1 ;

    { parity_check_ll_rdylst_bin1_hpnxt_p , parity_check_ll_rdylst_bin1_hpnxt_d } = rmw_ll_rdylst_hpnxt_p2_data_f [ 1 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_rdylst_bin1_hpnxt_e              = 1'b1 ;

    { parity_check_ll_rdylst_bin2_hpnxt_p , parity_check_ll_rdylst_bin2_hpnxt_d } = rmw_ll_rdylst_hpnxt_p2_data_f [ 2 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_rdylst_bin2_hpnxt_e              = 1'b1 ;

    { parity_check_ll_rdylst_bin3_hpnxt_p , parity_check_ll_rdylst_bin3_hpnxt_d } = rmw_ll_rdylst_hpnxt_p2_data_f [ 3 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_rdylst_bin3_hpnxt_e              = 1'b1 ;

    { parity_check_ll_schlst_bin0_hpnxt_p , parity_check_ll_schlst_bin0_hpnxt_d } = rmw_ll_schlst_hpnxt_p2_data_f [ 0 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin0_hpnxt_e         = 1'b1 ;

    { parity_check_ll_schlst_bin0_tpprv_p , parity_check_ll_schlst_bin0_tpprv_d } = rmw_ll_schlst_tpprv_p2_data_f [ 0 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin0_tpprv_e         = 1'b1 ;

    { parity_check_ll_schlst_bin1_hpnxt_p , parity_check_ll_schlst_bin1_hpnxt_d } = rmw_ll_schlst_hpnxt_p2_data_f [ 1 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin1_hpnxt_e         = 1'b1 ;

    { parity_check_ll_schlst_bin1_tpprv_p , parity_check_ll_schlst_bin1_tpprv_d } = rmw_ll_schlst_tpprv_p2_data_f [ 1 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin1_tpprv_e         = 1'b1 ;

    { parity_check_ll_schlst_bin2_hpnxt_p , parity_check_ll_schlst_bin2_hpnxt_d } = rmw_ll_schlst_hpnxt_p2_data_f [ 2 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin2_hpnxt_e         = 1'b1 ;

    { parity_check_ll_schlst_bin2_tpprv_p , parity_check_ll_schlst_bin2_tpprv_d } = rmw_ll_schlst_tpprv_p2_data_f [ 2 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin2_tpprv_e         = 1'b1 ;

    { parity_check_ll_schlst_bin3_hpnxt_p , parity_check_ll_schlst_bin3_hpnxt_d } = rmw_ll_schlst_hpnxt_p2_data_f [ 3 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin3_hpnxt_e         = 1'b1 ;

    { parity_check_ll_schlst_bin3_tpprv_p , parity_check_ll_schlst_bin3_tpprv_d } = rmw_ll_schlst_tpprv_p2_data_f [ 3 * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] ;
    parity_check_ll_schlst_bin3_tpprv_e         = 1'b1 ;


    { residue_check_ll_rlst_cnt_bin0_r , residue_check_ll_rlst_cnt_bin0_d } = rmw_ll_rlst_cnt_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_rlst_cnt_bin0_e                 = 1'b1 ;

    { residue_check_ll_rlst_cnt_bin1_r , residue_check_ll_rlst_cnt_bin1_d } = rmw_ll_rlst_cnt_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_rlst_cnt_bin1_e                 = 1'b1 ;

    { residue_check_ll_rlst_cnt_bin2_r , residue_check_ll_rlst_cnt_bin2_d } = rmw_ll_rlst_cnt_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_rlst_cnt_bin2_e                 = 1'b1 ;

    { residue_check_ll_rlst_cnt_bin3_r , residue_check_ll_rlst_cnt_bin3_d } = rmw_ll_rlst_cnt_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_rlst_cnt_bin3_e                 = 1'b1 ;


    { residue_check_ll_slst_cnt_bin0_r , residue_check_ll_slst_cnt_bin0_d } = rmw_ll_slst_cnt_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_slst_cnt_bin0_e            = 1'b1 ;

    { residue_check_enq_cnt_s_bin0_r , residue_check_enq_cnt_s_bin0_d } = rmw_ll_enq_cnt_s_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_s_bin0_e              = 1'b1 ;

    { residue_check_sch_cnt_bin0_r , residue_check_sch_cnt_bin0_d } = rmw_ll_sch_cnt_p2_data_f [ ( 0 * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2WR ] ;
    residue_check_sch_cnt_bin0_e                = 1'b1 ;

    { residue_check_ll_slst_cnt_bin1_r , residue_check_ll_slst_cnt_bin1_d } = rmw_ll_slst_cnt_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_slst_cnt_bin1_e            = 1'b1 ;

    { residue_check_enq_cnt_s_bin1_r , residue_check_enq_cnt_s_bin1_d } = rmw_ll_enq_cnt_s_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_s_bin1_e              = 1'b1 ;

    { residue_check_sch_cnt_bin1_r , residue_check_sch_cnt_bin1_d } = rmw_ll_sch_cnt_p2_data_f [ ( 1 * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2WR ] ;
    residue_check_sch_cnt_bin1_e                = 1'b1 ;

    { residue_check_ll_slst_cnt_bin2_r , residue_check_ll_slst_cnt_bin2_d } = rmw_ll_slst_cnt_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_slst_cnt_bin2_e            = 1'b1 ;

    { residue_check_enq_cnt_s_bin2_r , residue_check_enq_cnt_s_bin2_d } = rmw_ll_enq_cnt_s_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_s_bin2_e              = 1'b1 ;

    { residue_check_sch_cnt_bin2_r , residue_check_sch_cnt_bin2_d } = rmw_ll_sch_cnt_p2_data_f [ ( 2 * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2WR ] ;
    residue_check_sch_cnt_bin2_e                = 1'b1 ;

    { residue_check_ll_slst_cnt_bin3_r , residue_check_ll_slst_cnt_bin3_d } = rmw_ll_slst_cnt_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_ll_slst_cnt_bin3_e            = 1'b1 ;

    { residue_check_enq_cnt_s_bin3_r , residue_check_enq_cnt_s_bin3_d } = rmw_ll_enq_cnt_s_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_s_bin3_e              = 1'b1 ;

    { residue_check_sch_cnt_bin3_r , residue_check_sch_cnt_bin3_d } = rmw_ll_sch_cnt_p2_data_f [ ( 3 * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2WR ] ;
    residue_check_sch_cnt_bin3_e                = 1'b1 ;

    { residue_check_enq_cnt_r_bin0_r , residue_check_enq_cnt_r_bin0_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin0_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin1_r , residue_check_enq_cnt_r_bin1_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin1_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin2_r , residue_check_enq_cnt_r_bin2_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin2_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin3_r , residue_check_enq_cnt_r_bin3_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin3_e              = 1'b1 ;

    // ********** ENQUEUE-begin
    if ( p6_ll_data_nxt.cmd_syncopy == HQM_ATM_CMD_ENQ ) begin
      sch_idle_nnc                                  = ~ ( ( | rmw_ll_sch_cnt_p2_data_f [ ( 0 * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2 ] ) ) ;
      enq_empty_nnc                                 = ~ ( ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  | ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  | ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  | ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  ) ;
      enq_cnt_r_nnc                                 = ( rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( p6_ll_data_nxt.bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
      enq_cnt_rp1_nnc                               = enq_cnt_r_nnc + 12'd1 ;
      residue_add_enq_cnt_r_a                   = 2'b1 ;
      residue_add_enq_cnt_r_b                   = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( ( p6_ll_data_nxt.bin * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
      error_enq_cnt_r_of_nnc                        = ( enq_cnt_r_nnc == { HQM_ATM_CNTB2 { 1'b1 } } ) ;

      enq_cnt_s_nnc                                 = ( rmw_ll_enq_cnt_s_p2_data_f [ ( p6_ll_data_nxt.bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
      enq_cnt_sp1_nnc                               = enq_cnt_s_nnc + 12'd1 ;
      residue_add_enq_cnt_s_a                   = 2'b1 ;
      residue_add_enq_cnt_s_b                   = rmw_ll_enq_cnt_s_p2_data_f [ ( ( p6_ll_data_nxt.bin * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
      error_enq_cnt_s_of_nnc                        = ( enq_cnt_s_nnc == { HQM_ATM_CNTB2 { 1'b1 } } ) ;

      slst_cnt_nnc                                  = ( rmw_ll_slst_cnt_p2_data_f [ ( p6_ll_data_nxt.bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
      slst_cntp1_nnc                                = slst_cnt_nnc + 12'd1 ;
      residue_add_slst_cnt_a                    = 2'b1 ;
      residue_add_slst_cnt_b                    = rmw_ll_slst_cnt_p2_data_f [ ( ( p6_ll_data_nxt.bin * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
      error_slst_cnt_of_nnc [ 0 ]                      = ( slst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b1 } } ) ;

      fifo_ap_lsp_enq_push                      = 1'b1 ;
      fifo_ap_lsp_enq_push_data.qid             = p6_ll_data_nxt.qid ;
      fifo_ap_lsp_enq_push_data.parity          = p6_ll_data_nxt.parity ;

            rmw_ll_schlst_tp_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ]            = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
            rmw_ll_schlst_tp_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ]          = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ; 
            rmw_ll_schlst_hp_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ]            = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
            rmw_ll_schlst_hp_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ]          = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ; 
            rmw_ll_schlst_hpnxt_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ]   = {  p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
            rmw_ll_schlst_hpnxt_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ] = { p6_ll_data_nxt.sch_tp [ ( p6_ll_data_nxt.bin * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } ; 
            rmw_ll_schlst_tpprv_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ]   = { p6_ll_data_nxt.sch_tp_parity [ p6_ll_data_nxt.bin ] , p6_ll_data_nxt.sch_tp [ ( p6_ll_data_nxt.bin * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } ; 
            rmw_ll_schlst_tpprv_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ] = {  p6_ll_data_nxt.fid } ; 

      // sch_idle_nnc not equal to zero (assinged to CQ)
      if ( ~ sch_idle_nnc ) begin
        // no HCW is currently enqueued. PUSH onto scheduled LL
        if ( enq_cnt_s_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) begin

            rmw_ll_slst_cnt_p3_bypdata_nxt =  rmw_ll_slst_cnt_p2_data_f ;

            rmw_ll_slst_cnt_p3_bypdata_sel_nxt                                                                                                          = 1'b1 ; report_error_slst_cnt_of [ 0 ] = error_slst_cnt_of_nnc [ 0 ] ;
            rmw_ll_slst_cnt_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ]                                                               = { residue_add_slst_cnt_r , slst_cntp1_nnc } ; 
            rmw_ll_slst_cnt_p3_bypaddr_sel_nxt                                                                                                          = 1'b1 ;
            rmw_ll_slst_cnt_p3_bypaddr_nxt                                                                                                              = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;

if ( ( rmw_ll_slst_cnt_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_slst_cnt_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_slst_cnt_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_slst_cnt_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   ) begin
slst_e_ne_nnc = 1'b1 ;
end

            rmw_ll_schlst_tp_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                   = 1'b1 ; report_error_slst_cnt_of [ 0 ] = error_slst_cnt_of_nnc [ 0 ] ;
            rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                   = 1'b1 ;
          if ( slst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) begin
            rmw_ll_schlst_hp_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                   = 1'b1 ; report_error_slst_cnt_of [ 0 ] = error_slst_cnt_of_nnc [ 0 ] ;
            rmw_ll_schlst_hp_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                   = 1'b1 ;
          end
          else begin
            rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                = 1'b1 ; report_error_slst_cnt_of [ 0 ] = error_slst_cnt_of_nnc [ 0 ] ;
            rmw_ll_schlst_hpnxt_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                = 1'b1 ;

            rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                = 1'b1 ; report_error_slst_cnt_of [ 0 ] = error_slst_cnt_of_nnc [ 0 ] ;
            rmw_ll_schlst_tpprv_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                = 1'b1 ;
          end
          p6_debug_print_nc [ HQM_ATM_ENQ_ES ] = 1'b1 ; //00 ENQUEUE:  SCH & PUSH
        end
        else begin
          p6_debug_print_nc [ HQM_ATM_ENQ_SS ] = 1'b1 ; //01 ENQUEUE:  SCH & ACTIVE
        end

        // update enqueue counts
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                      = 1'b1 ; report_error_enq_cnt_s_of = error_enq_cnt_s_of_nnc ;
        rmw_ll_enq_cnt_s_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ]               = { residue_add_enq_cnt_s_r , enq_cnt_sp1_nnc } ; 
        rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                      = 1'b1 ;
        rmw_ll_enq_cnt_s_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ]             = { p6_ll_data_nxt.fid } ; 

      end

      // sch_idle_nnc equal to zero (not assigned to CQ) and something already enqueued for fid. already in ready LL.
      else if ( ~ enq_empty_nnc ) begin
        // update enqueue counts
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                      = 1'b1 ; report_error_enq_cnt_s_of = error_enq_cnt_s_of_nnc ;
        rmw_ll_enq_cnt_s_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ]               = { residue_add_enq_cnt_s_r , enq_cnt_sp1_nnc } ; 
        rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                      = 1'b1 ;
        rmw_ll_enq_cnt_s_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ]             = { p6_ll_data_nxt.fid } ; 
        p6_debug_print_nc [ HQM_ATM_ENQ_RR ] = 1'b1 ; //02 ENQUEUE:  RDY & ACTIVE
      end

      // sch_idle_nnc equal to zero (not assigned to CQ) and nothing enqueued. PUSH onto ready LL and update enqueue counts
      else begin

        //clamp the rdylst bin
        p6_ll_data_nxt.rdy_bin = p6_ll_data_nxt.bin ;
        if ( p6_ll_data_nxt.bin < rmw_qid_rdylst_clamp_p2_data_f [ 1 : 0 ] ) begin
           p6_ll_data_nxt.rdy_bin = rmw_qid_rdylst_clamp_p2_data_f [ 1 : 0 ] ;
           feature_clamped_low = 1'b1 ;
        end
        else begin
          if ( p6_ll_data_nxt.bin > rmw_qid_rdylst_clamp_p2_data_f [ 3 : 2 ] ) begin
           p6_ll_data_nxt.rdy_bin = rmw_qid_rdylst_clamp_p2_data_f [ 3 : 2 ] ;
           feature_clamped_high = 1'b1 ;
          end
        end

        //move this here to get correct count
        rlst_cnt_nnc                                  = ( rmw_ll_rlst_cnt_p2_data_f [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        rlst_cntp1_nnc                                = rlst_cnt_nnc + 12'd1 ;
        residue_add_rlst_cnt_a                    = 2'b1 ;
        residue_add_rlst_cnt_b                    = rmw_ll_rlst_cnt_p2_data_f [ ( ( p6_ll_data_nxt.rdy_bin * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
        error_rlst_cnt_of_nnc                         = ( rlst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b1 } } ) ;


          rmw_ll_rlst_cnt_p3_bypdata_nxt = rmw_ll_rlst_cnt_p2_data_f ;

          rmw_ll_rlst_cnt_p3_bypdata_sel_nxt                                                                                                            = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
          rmw_ll_rlst_cnt_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ]                                                                 = { residue_add_rlst_cnt_r , rlst_cntp1_nnc } ; 
          rmw_ll_rlst_cnt_p3_bypaddr_sel_nxt                                                                                                            = 1'b1 ;
          rmw_ll_rlst_cnt_p3_bypaddr_nxt                                                                                                                = { p6_ll_data_nxt.qid } ;


if ( ( rmw_ll_rlst_cnt_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_rlst_cnt_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_rlst_cnt_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_rlst_cnt_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   ) begin
rlst_e_ne_nnc = 1'b1 ;
end


          rmw_ll_rdylst_tp_p3_bypdata_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
          rmw_ll_rdylst_tp_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ]         = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
          rmw_ll_rdylst_tp_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                = 1'b1 ;
          rmw_ll_rdylst_tp_p3_bypaddr_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ]       = { p6_ll_data_nxt.qid } ; 
        if ( rlst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) begin
          rmw_ll_rdylst_hp_p3_bypdata_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
          rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ]         = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
          rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                = 1'b1 ;
          rmw_ll_rdylst_hp_p3_bypaddr_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ]       = { p6_ll_data_nxt.qid } ; 
        end
        else begin
          rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                             = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
          rmw_ll_rdylst_hpnxt_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ] = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
          rmw_ll_rdylst_hpnxt_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                             = 1'b1 ;
          rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] = { p6_ll_data_nxt.rdy_tp [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } ; 
        end

        // update enqueue counts
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ; report_error_enq_cnt_r_of = error_enq_cnt_r_of_nnc ;
        rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]          = { residue_add_enq_cnt_r_r , enq_cnt_rp1_nnc } ; 
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                 = 1'b1 ;
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]        = { p6_ll_data_nxt.fid } ; 

        rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                      = 1'b1 ; report_error_enq_cnt_s_of = error_enq_cnt_s_of_nnc ;
        rmw_ll_enq_cnt_s_p3_bypdata_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ]               = { residue_add_enq_cnt_s_r , enq_cnt_sp1_nnc } ; 
        rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.bin ]                                                                                      = 1'b1 ;
        rmw_ll_enq_cnt_s_p3_bypaddr_nxt [ ( p6_ll_data_nxt.bin * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ]             = { p6_ll_data_nxt.fid } ; 

        p6_debug_print_nc [ HQM_ATM_ENQ_IR ] = 1'b1 ; //03 ENQUEUE:  RDY & PUSH
      end

      p6_ll_data_nxt.error                      = ( error_enq_cnt_r_of_nnc | error_enq_cnt_s_of_nnc | error_slst_cnt_of_nnc [ 0 ] | error_rlst_cnt_of_nnc ) ;
    end
    // ********** ENQUEUE-end

    // ********** COMP-begin
    if ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_CMP ) begin

      sch_idle_nnc                                  = ( rmw_ll_sch_cnt_p2_data_f [ ( 0 * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2 ] ) == { { { ( HQM_ATM_SCH_CNT_CNTB2 - 1 ) } { 1'b0 } } , 1'b1 } ;

      enq_empty_nnc                                 = ~ ( ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  | ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  | ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  | ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
                                                  ) ;

      sch_cnt_nnc                                   = ( rmw_ll_sch_cnt_p2_data_f [ ( 0 * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2 ] ) ;
      sch_cntm1_nnc                                 = sch_cnt_nnc - 13'd1 ;
      residue_sub_sch_cnt_a                     = 2'b1 ;
      residue_sub_sch_cnt_b                     = rmw_ll_sch_cnt_p2_data_f [ ( ( 0 * HQM_ATM_SCH_CNT_CNTB2WR ) + HQM_ATM_SCH_CNT_CNTB2 )  +: 2 ] ;
      error_sch_cnt_uf_nnc                          = ( sch_cnt_nnc == { HQM_ATM_SCH_CNT_CNTB2 { 1'b0 } } ) ;


      // decrement sch_cnt for completion {fid,bin}
      rmw_ll_sch_cnt_p3_bypdata_sel_nxt                                                                                                                 = { 4 { 1'b1 } } ; report_error_sch_cnt_uf = error_sch_cnt_uf_nnc ;
      rmw_ll_sch_cnt_p3_bypdata_nxt                                                                                                                     = { 4 { residue_sub_sch_cnt_r , sch_cntm1_nnc } } ;
      rmw_ll_sch_cnt_p3_bypaddr_sel_nxt                                                                                                                 = { 4 { 1'b1 } } ;
      rmw_ll_sch_cnt_p3_bypaddr_nxt                                                                                                                     = { 4 { p6_ll_data_nxt.fid } } ;

      // sch_idle_nnc not equal to zero (assinged to CQ)

      if ( sch_idle_nnc
         ) begin

        rmw_ll_slst_cnt_p3_bypdata_nxt =  rmw_ll_slst_cnt_p2_data_f ;

        // check for sch->rdy transition. when sch_cnt equal to 0 for all bin & enq_cnt>0 for any bin
        for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : comp_sch2rdy

                rmw_ll_schlst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ]                         = { rmw_ll_schlst_hpnxt_p2_data_f [ i * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] } ; 
                rmw_ll_schlst_hp_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ]                       = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ; 
                rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ]                         = { rmw_ll_schlst_tpprv_p2_data_f [ i * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] } ; 
                rmw_ll_schlst_tp_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ]                       = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ; 
                rmw_ll_schlst_hpnxt_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ]                = { rmw_ll_schlst_hpnxt_p2_data_f [ i * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] } ; 
                rmw_ll_schlst_hpnxt_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ]              = { rmw_ll_schlst_tpprv_p2_data_f [ i * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2 ] } ; 
                rmw_ll_schlst_tpprv_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ]                = { rmw_ll_schlst_tpprv_p2_data_f [ i * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] } ; 
                rmw_ll_schlst_tpprv_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ]              = { rmw_ll_schlst_hpnxt_p2_data_f [ i * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2 ] } ; 

            slst_cnt_nnc                            = ( rmw_ll_slst_cnt_p2_data_f [ ( i * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ;
            slst_cntm1_nnc                          = slst_cnt_nnc - 12'd1 ;
            m_residue_sub_slst_cnt_a [ i * 2 +: 2 ]    = 2'b1 ;
            m_residue_sub_slst_cnt_b [ i * 2 +: 2 ]    = rmw_ll_slst_cnt_p2_data_f [ ( ( i * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ;
            rmw_ll_slst_cnt_p3_bypaddr_nxt                                                                                                              = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;

          if ( ( | rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( i * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) != 1'b0 ) begin
            not_empty_nnc [ i ]                           = 1'b1 ;
            error_slst_cnt_uf_nnc [ i ]                = ( slst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;
            // POP scheduled LL if not empty

            rmw_ll_slst_cnt_p3_bypdata_nxt [ ( i * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ]                                                                                = { m_residue_sub_slst_cnt_r [ i * 2 +: 2 ] , slst_cntm1_nnc } ;

            if ( slst_cntm1_nnc != '0 ) begin //LL does not go empty
              if ( p6_ll_data_nxt.fid == p6_ll_data_nxt.sch_hp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] ) begin //pop from HP of LL
                rmw_ll_schlst_hp_p3_bypdata_sel_nxt [ i ]                                                                                                = 1'b1 ;
                rmw_ll_schlst_hp_p3_bypaddr_sel_nxt [ i ]                                                                                                = 1'b1 ;
              end
              else if ( p6_ll_data_nxt.fid == p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] ) begin //pop from TP of LL
                rmw_ll_schlst_tp_p3_bypdata_sel_nxt [ i ]                                                                                                = 1'b1 ;
                rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ]                                                                                                = 1'b1 ;
              end
              else begin //pop from middle of LL
                rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt [ i ]                                                                                             = 1'b1 ;
                rmw_ll_schlst_hpnxt_p3_bypaddr_sel_nxt [ i ]                                                                                             = 1'b1 ;

                rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt [ i ]                                                                                             = 1'b1 ;
                rmw_ll_schlst_tpprv_p3_bypaddr_sel_nxt [ i ]                                                                                             = 1'b1 ;
              end
            end

          end
        end
        report_error_slst_cnt_uf = error_slst_cnt_uf_nnc ;

        if ( ( | not_empty_nnc )  ) begin

if ( ( ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     ) == 1'b0
   )  begin // all bin LL goes empty
slst_ne_e_nnc = 1'b1 ;
      end

          rmw_ll_slst_cnt_p3_bypdata_sel_nxt                                                                                                          = 1'b1 ;
          rmw_ll_slst_cnt_p3_bypaddr_sel_nxt                                                                                                          = 1'b1 ;

          //PUSH fid back onto ready LL

          //clamp the rdylst bin
          p6_ll_data_nxt.rdy_bin = p6_ll_data_nxt.bin ;
          if ( not_empty_nnc [ 3 ] ) begin p6_ll_data_nxt.rdy_bin = 2'd3 ; end
          if ( not_empty_nnc [ 2 ] ) begin p6_ll_data_nxt.rdy_bin = 2'd2 ; end
          if ( not_empty_nnc [ 1 ] ) begin p6_ll_data_nxt.rdy_bin = 2'd1 ; end
          if ( not_empty_nnc [ 0 ] ) begin p6_ll_data_nxt.rdy_bin = 2'd0 ; end
          if ( p6_ll_data_nxt.rdy_bin < rmw_qid_rdylst_clamp_p2_data_f [ 1 : 0 ] ) begin
             p6_ll_data_nxt.rdy_bin = rmw_qid_rdylst_clamp_p2_data_f [ 1 : 0 ] ;
             feature_clamped_low = 1'b1 ;
          end
          else begin
            if ( p6_ll_data_nxt.rdy_bin > rmw_qid_rdylst_clamp_p2_data_f [ 3 : 2 ] ) begin
             p6_ll_data_nxt.rdy_bin = rmw_qid_rdylst_clamp_p2_data_f [ 3 : 2 ] ;
             feature_clamped_high = 1'b1 ;
            end
          end

          //move this here to get correct count
          rlst_cnt_nnc                                  = ( rmw_ll_rlst_cnt_p2_data_f [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
          rlst_cntp1_nnc                                = rlst_cnt_nnc + 12'd1 ;
          residue_add_rlst_cnt_a                    = 2'b1 ;
          residue_add_rlst_cnt_b                    = rmw_ll_rlst_cnt_p2_data_f [ ( ( p6_ll_data_nxt.rdy_bin * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
          error_rlst_cnt_of_nnc                         = ( rlst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b1 } } ) ;


            rmw_ll_rlst_cnt_p3_bypdata_nxt = rmw_ll_rlst_cnt_p2_data_f ;

            rmw_ll_rlst_cnt_p3_bypdata_sel_nxt                                                                                                          = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
            rmw_ll_rlst_cnt_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ]                                                               = { residue_add_rlst_cnt_r , rlst_cntp1_nnc } ; 
            rmw_ll_rlst_cnt_p3_bypaddr_sel_nxt                                                                                                          = 1'b1 ;
            rmw_ll_rlst_cnt_p3_bypaddr_nxt                                                                                                              = { p6_ll_data_nxt.qid } ;

rlst_total_nnc = rmw_ll_rlst_cnt_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ]
           + rmw_ll_rlst_cnt_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ]
           + rmw_ll_rlst_cnt_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ]
           + rmw_ll_rlst_cnt_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ;
if ( rlst_total_nnc < { { ( HQM_ATM_CNTB2 - 2 ) { 1'b0 } } , 2'd2 } ) begin
 //lsp can schedule too fast to use rlst_e_ne_nnc to send cmpblast.Send a cmpblast when there are 1 or 2 entry remaining in rlst. 
//  Ex.) CMP moves S->R needs to cmpblast if only 2 remaining becuase lsp can have a rlst & slst schedule in flight, CMP disables slst, rlst sch pops rlost,slst sch taken from rlst, need to block more rlst with the cmpblast
rlst_lt_blast_nnc = 1'b1 ; // 1 in RLST and 1 moving from SLST then blast
end


if ( ( rmw_ll_rlst_cnt_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_rlst_cnt_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_rlst_cnt_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_rlst_cnt_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   ) begin
rlst_e_ne_nnc = 1'b1 ;
end

            rmw_ll_rdylst_tp_p3_bypdata_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                   = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
            rmw_ll_rdylst_tp_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH ]            = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
            rmw_ll_rdylst_tp_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                   = 1'b1 ;
            rmw_ll_rdylst_tp_p3_bypaddr_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ]          = { p6_ll_data_nxt.qid } ; 
          if ( rlst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) begin
            rmw_ll_rdylst_hp_p3_bypdata_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                   = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
            rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ]            = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
            rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                   = 1'b1 ;
            rmw_ll_rdylst_hp_p3_bypaddr_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ]          = { p6_ll_data_nxt.qid } ; 
          end
          else begin
            rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                = 1'b1 ; report_error_rlst_cnt_of = error_rlst_cnt_of_nnc ;
            rmw_ll_rdylst_hpnxt_p3_bypdata_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH ]   = { p6_ll_data_nxt.fid_parity , p6_ll_data_nxt.fid } ; 
            rmw_ll_rdylst_hpnxt_p3_bypaddr_sel_nxt [ p6_ll_data_nxt.rdy_bin ]                                                                                = 1'b1 ;
            rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ] = { p6_ll_data_nxt.rdy_tp [ ( p6_ll_data_nxt.rdy_bin * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } ; 
          end
        p6_debug_print_nc [ HQM_ATM_CMP_SR ] = 1'b1 ; //10 COMPLETE: LAST SCH -> RDY
        end
        else begin
        p6_debug_print_nc [ HQM_ATM_CMP_SI ] = 1'b1 ; //11 COMPLETE: LAST
        end
      end
      else begin
        p6_debug_print_nc [ HQM_ATM_CMP_SRESRE ] = 1'b1 ; //12 COMPLETE: NOTLAST
      end


      credit_fifo_ap_aqed_dec_cmp         = 1'b1 ;

      p6_ll_data_nxt.error                = error_sch_cnt_uf_nnc | error_rlst_cnt_of_nnc | ( | error_slst_cnt_uf_nnc ) ;
    end
    // ********** COMP-end

      rdy_wins_nnc                                  = ( ( arb_ll_rdy_winner_v  ) & ( ~ p6_ll_data_nxt.rdysch ) ) | rdy_override_nnc ;
      sch_wins_nnc                                  = ( arb_ll_sch_winner_v  ) & ( p6_ll_data_nxt.rdysch  ) ;

        if ( arb_ll_rdy_winner == 2'd0 ) begin
          rdy_bin_nnc                               = arb_ll_rdy_pri_dup0_winner ;
        end
        if ( arb_ll_rdy_winner == 2'd1 ) begin
          rdy_bin_nnc                               = arb_ll_rdy_pri_dup1_winner ;
        end
        if ( arb_ll_rdy_winner == 2'd2 ) begin
          rdy_bin_nnc                               = arb_ll_rdy_pri_dup2_winner ;
        end
        if ( arb_ll_rdy_winner == 2'd3 ) begin
          rdy_bin_nnc                               = arb_ll_rdy_pri_dup3_winner ;
        end
        rdy_dup_nnc                                 = arb_ll_rdy_winner ;

        rdy_fid_nnc                                 = p6_ll_data_nxt.rdy_hp [ rdy_dup_nnc * HQM_ATM_FIDB2 +: HQM_ATM_FIDB2 ] ; 
        rdy_fid_parity_nnc                          = p6_ll_data_nxt.rdy_hp_parity [ rdy_dup_nnc ] ;

        sch_bin_nnc                                 = arb_ll_sch_winner ;
        sch_fid_nnc                                 = p6_ll_data_nxt.sch_hp [ sch_bin_nnc * HQM_ATM_FIDB2 +: HQM_ATM_FIDB2 ] ; 
        sch_fid_parity_nnc                          = p6_ll_data_nxt.sch_hp_parity [ sch_bin_nnc ] ;


if ( rdy_bin_nnc == 2'd0 ) begin
enq_cnt_r_dup0_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup1_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup2_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup3_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
end else begin
enq_cnt_r_dup0_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup1_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup2_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup3_gt1 [ 0 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 0  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
end

if ( rdy_bin_nnc == 2'd1 ) begin
enq_cnt_r_dup0_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup1_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup2_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup3_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
end else begin
enq_cnt_r_dup0_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup1_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup2_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup3_gt1 [ 1 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 1  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
end

if ( rdy_bin_nnc == 2'd2 ) begin
enq_cnt_r_dup0_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup1_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup2_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup3_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
end else begin
enq_cnt_r_dup0_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup1_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup2_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup3_gt1 [ 2 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 2  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
end

if ( rdy_bin_nnc == 2'd3 ) begin
enq_cnt_r_dup0_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup1_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup2_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
enq_cnt_r_dup3_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd1 ;
end else begin
enq_cnt_r_dup0_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup1_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup2_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
enq_cnt_r_dup3_gt1 [ 3 ] = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 3  * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] > 12'd0 ;
end


    // ********** SCH-begin
    if ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ ) begin

      // **** SCH(select sch/rdy)-begin
      // arbitrate to find the highest priority sch or read fid

      if ( ( ~ rdy_wins_nnc ) & ( ~ sch_wins_nnc ) ) begin
        error_nopri                             = 1'b1 ;
      end

      if ( rdy_wins_nnc  ) begin

        fifo_ap_aqed_push                       = 1'b1 ;
        fifo_ap_aqed_push_data.cmd              = '0 ;
      //fifo_ap_aqed_push_data.cq               = p6_ll_data_nxt.pcm ? { 2'b0 , p6_ll_data_nxt.cq [ 5 : 1 ] , 1'b0 } : { 2'b0 , p6_ll_data_nxt.cq [ 5 : 0 ] } ;
        fifo_ap_aqed_push_data.cq               = { 2'b0 , p6_ll_data_nxt.cq [ 5 : 0 ] } ;
        fifo_ap_aqed_push_data.qid              = p6_ll_data_nxt.qid ;
        fifo_ap_aqed_push_data.qidix            = p6_ll_data_nxt.qidix ;
      //fifo_ap_aqed_push_data.parity           = p6_ll_data_nxt.parity ^ ( p6_ll_data_nxt.qidix_msb & p6_ll_data_nxt.cq [ 0 ] ) ;
        fifo_ap_aqed_push_data.parity           = p6_ll_data_nxt.parity ;
        fifo_ap_aqed_push_data.pcm              = p6_ll_data_nxt.pcm ;
        fifo_ap_aqed_push_data.bin              = rdy_bin_nnc ;
        fifo_ap_aqed_push_data.flid             = rdy_fid_nnc ;
        fifo_ap_aqed_push_data.flid_parity      = rdy_fid_parity_nnc ;
        fifo_ap_aqed_push_data.hqm_core_flags   = p6_ll_data_nxt.hqm_core_flags ;
      end
      if ( sch_wins_nnc  ) begin

        fifo_ap_aqed_push                       = 1'b1 ;
        fifo_ap_aqed_push_data.cmd              = '0 ;
      //fifo_ap_aqed_push_data.cq               = p6_ll_data_nxt.pcm ? { 2'b0 , p6_ll_data_nxt.cq [ 5 : 1 ] , 1'b0 } : { 2'b0 , p6_ll_data_nxt.cq [ 5 : 0 ] } ;
        fifo_ap_aqed_push_data.cq               = { 2'b0 , p6_ll_data_nxt.cq [ 5 : 0 ] } ;
        fifo_ap_aqed_push_data.qid              = p6_ll_data_nxt.qid ;
        fifo_ap_aqed_push_data.qidix            = p6_ll_data_nxt.qidix ;
      //fifo_ap_aqed_push_data.parity           = p6_ll_data_nxt.parity ^ ( p6_ll_data_nxt.qidix_msb & p6_ll_data_nxt.cq [ 0 ] ) ;
        fifo_ap_aqed_push_data.parity           = p6_ll_data_nxt.parity ;
        fifo_ap_aqed_push_data.pcm              = p6_ll_data_nxt.pcm ;
        fifo_ap_aqed_push_data.bin              = sch_bin_nnc ;
        fifo_ap_aqed_push_data.flid             = sch_fid_nnc ;
        fifo_ap_aqed_push_data.flid_parity      = sch_fid_parity_nnc ;
        fifo_ap_aqed_push_data.hqm_core_flags   = p6_ll_data_nxt.hqm_core_flags ;
      end

      // **** SCH(select sch/rdy)-end

        enq_cnt_s_nnc                               = ( rmw_ll_enq_cnt_s_p2_data_f [ ( sch_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        enq_cnt_sm1_nnc                             = enq_cnt_s_nnc - 12'd1 ;
        residue_sub_enq_cnt_s_a                 = 2'd1 ;
        residue_sub_enq_cnt_s_b                 = rmw_ll_enq_cnt_s_p2_data_f [ ( ( sch_bin_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 

        sch_cnt_nnc                                 = ( rmw_ll_sch_cnt_p2_data_f [ ( sch_bin_nnc * HQM_ATM_SCH_CNT_CNTB2WR ) +: HQM_ATM_SCH_CNT_CNTB2 ] ) ; 
        sch_cntp1_nnc                               = sch_cnt_nnc + 13'd1 ;
        residue_add_sch_cnt_a                   = 2'd1 ;
        residue_add_sch_cnt_b                   = rmw_ll_sch_cnt_p2_data_f [ ( ( sch_bin_nnc * HQM_ATM_SCH_CNT_CNTB2WR ) + HQM_ATM_SCH_CNT_CNTB2 ) +: 2 ] ; 

        slst_cnt_nnc                                = ( rmw_ll_slst_cnt_p2_data_f [ ( sch_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        slst_cntm1_nnc                              = slst_cnt_nnc - 12'd1 ;
        residue_sub_slst_cnt_a                  = 2'd1 ;
        residue_sub_slst_cnt_b                  =  rmw_ll_slst_cnt_p2_data_f [ ( ( sch_bin_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 

      // **** SCH(sch wins)-begin
      if ( sch_wins_nnc  ) begin

        error_enq_cnt_s_uf_nnc                      = ( enq_cnt_s_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;

        error_sch_cnt_of_nnc                        = ( sch_cnt_nnc == { HQM_ATM_SCH_CNT_CNTB2 { 1'b1 } } ) ;

        error_slst_cnt_uf_nnc [ 0 ]                    = ( slst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;

        //update counts
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ; //NOTE00: cannot do UF check since the fid read is NOT the sch_fid_nnc since there can be 4 of them
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]               = { residue_sub_enq_cnt_s_r , enq_cnt_sm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ;
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]             = { sch_fid_nnc } ; 

        rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ; //NOTE00: cannot do UF check since the fid read is NOT the sch_fid_nnc since there can be 4 of them
        rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]               = { residue_sub_enq_cnt_s_r , enq_cnt_sm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ;
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]             = { sch_fid_nnc } ; 

        rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ; //NOTE00: cannot do UF check since the fid read is NOT the sch_fid_nnc since there can be 4 of them
        rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]               = { residue_sub_enq_cnt_s_r , enq_cnt_sm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ;
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]             = { sch_fid_nnc } ; 

        rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ; //NOTE00: cannot do UF check since the fid read is NOT the sch_fid_nnc since there can be 4 of them
        rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]               = { residue_sub_enq_cnt_s_r , enq_cnt_sm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt [ sch_bin_nnc ]                                                                                      = 1'b1 ;
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]             = { sch_fid_nnc } ; 

        rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt [ sch_bin_nnc ]                                                                                           = 1'b1 ; report_error_enq_cnt_s_uf = error_enq_cnt_s_uf_nnc ;
        rmw_ll_enq_cnt_s_p3_bypdata_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ]                    = { residue_sub_enq_cnt_s_r , enq_cnt_sm1_nnc } ; 
        rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt [ sch_bin_nnc ]                                                                                           = 1'b1 ;
        rmw_ll_enq_cnt_s_p3_bypaddr_nxt [ ( sch_bin_nnc * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ]                  = { sch_fid_nnc } ; 

        rmw_ll_sch_cnt_p3_bypdata_sel_nxt                                                                                                             = { 4 { 1'b1 } } ; report_error_sch_cnt_of = error_sch_cnt_of_nnc ;
        rmw_ll_sch_cnt_p3_bypdata_nxt                                                                                                                 = { 4 { residue_add_sch_cnt_r , sch_cntp1_nnc } } ;
        rmw_ll_sch_cnt_p3_bypaddr_sel_nxt                                                                                                             = { 4 { 1'b1 } } ;
        rmw_ll_sch_cnt_p3_bypaddr_nxt                                                                                                                 = { 4 { sch_fid_nnc } } ;

        rmw_ll_slst_cnt_p3_bypdata_nxt =  rmw_ll_slst_cnt_p2_data_f ;

            rmw_ll_slst_cnt_p3_bypaddr_nxt                                                                                                            = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;
            rmw_ll_schlst_hp_p3_bypaddr_nxt [ ( sch_bin_nnc * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ]              = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ; 
            rmw_ll_schlst_hp_p3_bypdata_nxt [ ( sch_bin_nnc * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ]                = { rmw_ll_schlst_hpnxt_p2_data_f [ sch_bin_nnc * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] } ; 

        if ( ~ ( | enq_cnt_sm1_nnc ) ) begin // all task enqueued on fid are popped

            // POP fid from sch_list if no remaining enqueued fid on LL(bin)
            //need to always update slst_cnt[bin] when fid enq_cnt_s[bin] is exhausted
            rmw_ll_slst_cnt_p3_bypdata_sel_nxt                                                                                                        = 1'b1 ; report_error_slst_cnt_uf [ 0 ] = error_slst_cnt_uf_nnc [ 0 ] ;
            rmw_ll_slst_cnt_p3_bypaddr_sel_nxt                                                                                                        = 1'b1 ;
            rmw_ll_slst_cnt_p3_bypdata_nxt [ ( sch_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ]                                                   = { residue_sub_slst_cnt_r , slst_cntm1_nnc } ; 
          if ( ( | slst_cntm1_nnc ) != 1'b0 ) begin // this bin LL does not go empty
            rmw_ll_schlst_hp_p3_bypdata_sel_nxt [ sch_bin_nnc ]                                                                                       = 1'b1 ; report_error_slst_cnt_uf [ 0 ] = error_slst_cnt_uf_nnc [ 0 ] ;
            rmw_ll_schlst_hp_p3_bypaddr_sel_nxt [ sch_bin_nnc ]                                                                                       = 1'b1 ;
          end
          p6_debug_print_nc [ HQM_ATM_SCH_SE ] = 1'b1 ; //20 SCHEDULE: SCH_WINS S->E
        end
        else begin
          p6_debug_print_nc [ HQM_ATM_SCH_SS ] = 1'b1 ; //21 SCHEDULE: SCH_WINS S->S
        end

if ( ( ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_slst_cnt_p3_bypdata_nxt [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     ) == 1'b0
   )  begin // all bin LL goes empty
slst_ne_e_nnc = 1'b1 ;

      end

      end
      // **** SCH(sch wins)-end

      // **** SCH(rdy wins)-begin
      if ( rdy_wins_nnc  ) begin

        if ( rdy_dup_nnc == 2'd0 ) begin
    { residue_check_enq_cnt_r_bin0_r , residue_check_enq_cnt_r_bin0_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin0_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin1_r , residue_check_enq_cnt_r_bin1_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin1_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin2_r , residue_check_enq_cnt_r_bin2_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin2_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin3_r , residue_check_enq_cnt_r_bin3_d } = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin3_e              = 1'b1 ;

        enq_cnt_r_nnc                               = ( rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        enq_cnt_rm1_nnc                             = enq_cnt_r_nnc - 12'd1 ;
        residue_sub_enq_cnt_r_a                 = 2'd1 ;
        residue_sub_enq_cnt_r_b                 = rmw_ll_enq_cnt_r_dup0_p2_data_f [ ( ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
        error_enq_cnt_r_uf_nnc                      = ( enq_cnt_r_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;
        end

        if ( rdy_dup_nnc == 2'd1 ) begin
    { residue_check_enq_cnt_r_bin0_r , residue_check_enq_cnt_r_bin0_d } = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin0_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin1_r , residue_check_enq_cnt_r_bin1_d } = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin1_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin2_r , residue_check_enq_cnt_r_bin2_d } = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin2_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin3_r , residue_check_enq_cnt_r_bin3_d } = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin3_e              = 1'b1 ;

        enq_cnt_r_nnc                               = ( rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        enq_cnt_rm1_nnc                             = enq_cnt_r_nnc - 12'd1 ;
        residue_sub_enq_cnt_r_a                 = 2'd1 ;
        residue_sub_enq_cnt_r_b                 = rmw_ll_enq_cnt_r_dup1_p2_data_f [ ( ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
        error_enq_cnt_r_uf_nnc                      = ( enq_cnt_r_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;
        end

        if ( rdy_dup_nnc == 2'd2 ) begin
    { residue_check_enq_cnt_r_bin0_r , residue_check_enq_cnt_r_bin0_d } = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin0_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin1_r , residue_check_enq_cnt_r_bin1_d } = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin1_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin2_r , residue_check_enq_cnt_r_bin2_d } = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin2_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin3_r , residue_check_enq_cnt_r_bin3_d } = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin3_e              = 1'b1 ;

        enq_cnt_r_nnc                               = ( rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        enq_cnt_rm1_nnc                             = enq_cnt_r_nnc - 12'd1 ;
        residue_sub_enq_cnt_r_a                 = 2'd1 ;
        residue_sub_enq_cnt_r_b                 = rmw_ll_enq_cnt_r_dup2_p2_data_f [ ( ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
        error_enq_cnt_r_uf_nnc                      = ( enq_cnt_r_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;
        end

        if ( rdy_dup_nnc == 2'd3 ) begin
    { residue_check_enq_cnt_r_bin0_r , residue_check_enq_cnt_r_bin0_d } = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin0_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin1_r , residue_check_enq_cnt_r_bin1_d } = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin1_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin2_r , residue_check_enq_cnt_r_bin2_d } = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin2_e              = 1'b1 ;

    { residue_check_enq_cnt_r_bin3_r , residue_check_enq_cnt_r_bin3_d } = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ] ;
    residue_check_enq_cnt_r_bin3_e              = 1'b1 ;

        enq_cnt_r_nnc                               = ( rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        enq_cnt_rm1_nnc                             = enq_cnt_r_nnc - 12'd1 ;
        residue_sub_enq_cnt_r_a                 = 2'd1 ;
        residue_sub_enq_cnt_r_b                 = rmw_ll_enq_cnt_r_dup3_p2_data_f [ ( ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
        error_enq_cnt_r_uf_nnc                      = ( enq_cnt_r_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;
        end

        sch_cnt_nnc                                 = { HQM_ATM_SCH_CNT_CNTB2 { 1'b0 } } ;
        sch_cntp1_nnc                               = sch_cnt_nnc + 13'd1 ;
        residue_add_sch_cnt_a                   = 2'd1 ;
        residue_add_sch_cnt_b                   = 2'b0 ;
        error_sch_cnt_of_nnc                        = ( sch_cnt_nnc == { HQM_ATM_SCH_CNT_CNTB2 { 1'b1 } } ) ;

        slst_cnt_nnc                                = ( rmw_ll_slst_cnt_p2_data_f [ ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        slst_cntp1_nnc                              = slst_cnt_nnc + 12'd1 ;
        residue_add_slst_cnt_a                  = 2'd1 ;
        residue_add_slst_cnt_b                  = rmw_ll_slst_cnt_p2_data_f [ ( ( rdy_bin_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
        error_slst_cnt_of_nnc [ 0 ]                    = ( slst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b1 } } ) ;

        rlst_cnt_nnc                                = ( rmw_ll_rlst_cnt_p2_data_f [ ( rdy_dup_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
        rlst_cntm1_nnc                              = rlst_cnt_nnc - 12'd1 ;
        residue_sub_rlst_cnt_a                  = 2'd1 ;
        residue_sub_rlst_cnt_b                  = rmw_ll_rlst_cnt_p2_data_f [ ( ( rdy_dup_nnc * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 
        error_rlst_cnt_uf_nnc                       = ( rlst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) ;


        //POP fid from ready LL
        rmw_ll_rlst_cnt_p3_bypdata_nxt = rmw_ll_rlst_cnt_p2_data_f ;

        rmw_ll_rlst_cnt_p3_bypdata_sel_nxt                                                                                                              = 1'b1 ; report_error_rlst_cnt_uf = error_rlst_cnt_uf_nnc ;
        rmw_ll_rlst_cnt_p3_bypdata_nxt [ ( rdy_dup_nnc * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ]                                                                              = { residue_sub_rlst_cnt_r , rlst_cntm1_nnc } ; 
        rmw_ll_rlst_cnt_p3_bypaddr_sel_nxt                                                                                                              = 1'b1 ;
        rmw_ll_rlst_cnt_p3_bypaddr_nxt                                                                                                                  = { p6_ll_data_nxt.qid } ;

        if ( ( (  | rlst_cntm1_nnc ) != 1'b0 ) //LL does not go empty
           ) begin
          rmw_ll_rdylst_hp_p3_bypdata_sel_nxt [ rdy_dup_nnc ]                                                                                           = 1'b1 ; report_error_rlst_cnt_uf = error_rlst_cnt_uf_nnc ;
          rmw_ll_rdylst_hp_p3_bypdata_nxt [ ( rdy_dup_nnc * HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH ]                    = { rmw_ll_rdylst_hpnxt_p2_data_f [ rdy_dup_nnc * HQM_ATM_FIDB2WP +: HQM_ATM_FIDB2WP ] } ; 
          rmw_ll_rdylst_hp_p3_bypaddr_sel_nxt [ rdy_dup_nnc ]                                                                                           = 1'b1 ;
          rmw_ll_rdylst_hp_p3_bypaddr_nxt [ ( rdy_dup_nnc * HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ]                  = { p6_ll_data_nxt.qid } ; 
        end
        else begin

if ( ( ( | rmw_ll_rlst_cnt_p3_bypdata_nxt [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_rlst_cnt_p3_bypdata_nxt [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_rlst_cnt_p3_bypdata_nxt [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     | ( | rmw_ll_rlst_cnt_p3_bypdata_nxt [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] )
     ) == 1'b0
   )  begin // all bin LL goes empty
rlst_ne_e_nnc = 1'b1 ;
end
        end

        //need to set to initial value since this is used to transfer fid from RDY to each bin in SCH LL
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt                                                                                                            = rmw_ll_enq_cnt_r_dup0_p2_data_f ;
        rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt                                                                                                            = rmw_ll_enq_cnt_r_dup1_p2_data_f ;
        rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt                                                                                                            = rmw_ll_enq_cnt_r_dup2_p2_data_f ;
        rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt                                                                                                            = rmw_ll_enq_cnt_r_dup3_p2_data_f ;

        //update counts
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ; report_error_enq_cnt_r_uf = error_enq_cnt_r_uf_nnc ;
        rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]                 = { residue_sub_enq_cnt_r_r , enq_cnt_rm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ;
        rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]               = { rdy_fid_nnc } ; 

        rmw_ll_enq_cnt_r_dup1_p3_bypdata_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ; report_error_enq_cnt_r_uf = error_enq_cnt_r_uf_nnc ;
        rmw_ll_enq_cnt_r_dup1_p3_bypdata_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]                 = { residue_sub_enq_cnt_r_r , enq_cnt_rm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ;
        rmw_ll_enq_cnt_r_dup1_p3_bypaddr_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]               = { rdy_fid_nnc } ; 

        rmw_ll_enq_cnt_r_dup2_p3_bypdata_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ; report_error_enq_cnt_r_uf = error_enq_cnt_r_uf_nnc ;
        rmw_ll_enq_cnt_r_dup2_p3_bypdata_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]                 = { residue_sub_enq_cnt_r_r , enq_cnt_rm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ;
        rmw_ll_enq_cnt_r_dup2_p3_bypaddr_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]               = { rdy_fid_nnc } ; 

        rmw_ll_enq_cnt_r_dup3_p3_bypdata_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ; report_error_enq_cnt_r_uf = error_enq_cnt_r_uf_nnc ;
        rmw_ll_enq_cnt_r_dup3_p3_bypdata_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH ]                 = { residue_sub_enq_cnt_r_r , enq_cnt_rm1_nnc } ; 
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_sel_nxt [ rdy_bin_nnc ]                                                                                        = 1'b1 ;
        rmw_ll_enq_cnt_r_dup3_p3_bypaddr_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ]               = { rdy_fid_nnc } ; 

        rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt [ rdy_bin_nnc ]                                                                                             = 1'b1 ; report_error_enq_cnt_r_uf = error_enq_cnt_r_uf_nnc ;
        rmw_ll_enq_cnt_s_p3_bypdata_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH ]                      = { residue_sub_enq_cnt_r_r , enq_cnt_rm1_nnc } ; 
        rmw_ll_enq_cnt_s_p3_bypaddr_sel_nxt [ rdy_bin_nnc ]                                                                                             = 1'b1 ;
        rmw_ll_enq_cnt_s_p3_bypaddr_nxt [ ( rdy_bin_nnc * HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) +: HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ]                    = { rdy_fid_nnc } ; 

        rmw_ll_sch_cnt_p3_bypdata_sel_nxt                                                                                                               = { 4 { 1'b1 } } ; report_error_sch_cnt_of = error_sch_cnt_of_nnc ;
        rmw_ll_sch_cnt_p3_bypdata_nxt                                                                                                                   = { 4 { residue_add_sch_cnt_r , sch_cntp1_nnc } } ;
        rmw_ll_sch_cnt_p3_bypaddr_sel_nxt                                                                                                               = { 4 { 1'b1 } } ;
        rmw_ll_sch_cnt_p3_bypaddr_nxt                                                                                                                   = { 4 { rdy_fid_nnc } } ;

        //update fid2cqqidix
        parity_gen_fid2cqqidix_d                                                                                                                        = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;
        rmw_fid2cqqidix_p3_bypdata_sel_nxt                                                                                                              = 1'b1 ;
        rmw_fid2cqqidix_p3_bypdata_nxt                                                                                                                  = { parity_gen_fid2cqqidix_p , p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;
        rmw_fid2cqqidix_p3_bypaddr_sel_nxt                                                                                                              = 1'b1 ;
        rmw_fid2cqqidix_p3_bypaddr_nxt                                                                                                                  = { rdy_fid_nnc } ;

        rmw_ll_slst_cnt_p3_bypdata_nxt =  rmw_ll_slst_cnt_p2_data_f ;


        //PUSH onto sch LL for each bin that has enqueued fid
        for ( int i = 0 ; i < HQM_ATM_NUM_BIN ; i = i + 1 ) begin : sch_rdy2sch

              rmw_ll_schlst_tp_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH ]                           = { rdy_fid_parity_nnc , rdy_fid_nnc } ;
              rmw_ll_schlst_tp_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ]                         = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;
              rmw_ll_schlst_hp_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH ]                           = { rdy_fid_parity_nnc , rdy_fid_nnc } ;
              rmw_ll_schlst_hp_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ]                         = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;
              rmw_ll_schlst_hpnxt_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH ]                  = { rdy_fid_parity_nnc , rdy_fid_nnc } ;
              rmw_ll_schlst_hpnxt_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ]                = { p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } ;
              rmw_ll_schlst_tpprv_p3_bypdata_nxt [ ( i * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH ]                  = {  p6_ll_data_nxt.sch_tp_parity [ i ] , p6_ll_data_nxt.sch_tp [ ( i * HQM_ATM_FIDB2 ) +: HQM_ATM_FIDB2 ] } ;
              rmw_ll_schlst_tpprv_p3_bypaddr_nxt [ ( i * HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) +: HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ]                = {  rdy_fid_nnc } ;

              slst_cnt_nnc                            = ( rmw_ll_slst_cnt_p2_data_f [ ( i * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] ) ; 
              slst_cntp1_nnc                          = slst_cnt_nnc + 12'd1 ;
              m_residue_add_slst_cnt_a [ i * 2 +: 2 ]      = 2'd1 ;
              m_residue_add_slst_cnt_b [ i * 2 +: 2 ]      = rmw_ll_slst_cnt_p2_data_f [ ( ( i * HQM_ATM_CNTB2WR ) + HQM_ATM_CNTB2 ) +: 2 ] ; 

          if ( ( ( rdy_dup_nnc == 2'd0 ) & ( enq_cnt_r_dup0_gt1 [ i ] ) )
             | ( ( rdy_dup_nnc == 2'd1 ) & ( enq_cnt_r_dup1_gt1 [ i ] ) )
             | ( ( rdy_dup_nnc == 2'd2 ) & ( enq_cnt_r_dup2_gt1 [ i ] ) )
             | ( ( rdy_dup_nnc == 2'd3 ) & ( enq_cnt_r_dup3_gt1 [ i ] ) )
             ) begin
              not_empty_nnc [ i ]                           = 1'b1 ;

              error_slst_cnt_of_nnc [ i ]                = ( slst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b1 } } ) ;

              rmw_ll_slst_cnt_p3_bypdata_nxt [ ( i * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2WR ]                                                                              = { m_residue_add_slst_cnt_r [ i * 2 +: 2 ] , slst_cntp1_nnc } ;

              rmw_ll_schlst_tp_p3_bypdata_sel_nxt [ i ]                                                                                                  = 1'b1 ;
              rmw_ll_schlst_tp_p3_bypaddr_sel_nxt [ i ]                                                                                                  = 1'b1 ;
            if ( slst_cnt_nnc == { HQM_ATM_CNTB2 { 1'b0 } } ) begin
              rmw_ll_schlst_hp_p3_bypdata_sel_nxt [ i ]                                                                                                  = 1'b1 ;
              rmw_ll_schlst_hp_p3_bypaddr_sel_nxt [ i ]                                                                                                  = 1'b1 ;
            end
            else begin
              rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt [ i ]                                                                                               = 1'b1 ;
              rmw_ll_schlst_hpnxt_p3_bypaddr_sel_nxt [ i ]                                                                                               = 1'b1 ;

              rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt [ i ]                                                                                               = 1'b1 ;
              rmw_ll_schlst_tpprv_p3_bypaddr_sel_nxt [ i ]                                                                                               = 1'b1 ;
            end

          end
        end
        report_error_slst_cnt_of = error_slst_cnt_of_nnc ;

              rmw_ll_slst_cnt_p3_bypaddr_nxt                                                                                                            = { p6_ll_data_nxt.cq , p6_ll_data_nxt.qidix } ;
        if ( ( | not_empty_nnc )  ) begin

if ( ( rmw_ll_slst_cnt_p2_data_f [ ( 0 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_slst_cnt_p2_data_f [ ( 1 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_slst_cnt_p2_data_f [ ( 2 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   & ( rmw_ll_slst_cnt_p2_data_f [ ( 3 * HQM_ATM_CNTB2WR ) +: HQM_ATM_CNTB2 ] == { HQM_ATM_CNTB2 { 1'b0 } } )
   ) begin
slst_e_ne_nnc = 1'b1 ;
end

              rmw_ll_slst_cnt_p3_bypdata_sel_nxt                                                                                                        = 1'b1 ;
              rmw_ll_slst_cnt_p3_bypaddr_sel_nxt                                                                                                        = 1'b1 ;
          p6_debug_print_nc [ HQM_ATM_SCH_RS ] = 1'b1 ; //22 SCHEDULE: RDY_WINS  R->S
        end
        else begin
          p6_debug_print_nc [ HQM_ATM_SCH_RE ] = 1'b1 ; //23 SCHEDULE: RDY_WINS  R->E
        end


      end
      // **** SCH(rdy wins)-end

      p6_ll_data_nxt.error                = error_nopri | error_enq_cnt_r_uf_nnc | error_enq_cnt_s_uf_nnc | error_sch_cnt_of_nnc | error_enq_cnt_r_uf_nnc | error_enq_cnt_s_uf_nnc | error_sch_cnt_of_nnc | ( | error_slst_cnt_of_nnc ) | error_rlst_cnt_uf_nnc ;

    end
    // ********** SCH-end

  //////////////////////////////////////////////////
  //response to LSP
  //                ENQ     CMP     SCH
  //rlst_e_ne_nnc       X       X
  //rlst_ne_e_nnc                       X
  //
  //slst_e_ne_nnc       X               X
  //slst_ne_e_nnc               X       X
  //
  error_ap_lsp   = ( ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) & rlst_ne_e_nnc )
                   | ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) & slst_ne_e_nnc )
                   | ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_CMP ) & rlst_ne_e_nnc )
                   | ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_CMP ) & slst_e_ne_nnc )
                   | ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ ) & rlst_e_ne_nnc )
                   | ( rlst_e_ne_nnc & rlst_ne_e_nnc )
                   | ( rlst_e_ne_nnc & slst_e_ne_nnc )
                   | ( rlst_ne_e_nnc & slst_ne_e_nnc )
                   | ( slst_e_ne_nnc & slst_ne_e_nnc )
                   | ( slst_e_ne_nnc & rlst_e_ne_nnc )
                   | ( slst_ne_e_nnc & rlst_ne_e_nnc )
                   ) ;

  ap_lsp_cq_nxt          = p6_ll_data_nxt.cq ;
  ap_lsp_qidix_msb_nxt   = p6_ll_data_nxt.qidix_msb ;
  ap_lsp_qidix_nxt       = p6_ll_data_nxt.qidix ;
  ap_lsp_qid_nxt         = p6_ll_data_nxt.qid ;
  ap_lsp_qid2cqqidix_nxt = func_aqed_qid2cqidix_rdata ;

  if ( ( ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ )
         )
       | ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ )
           & ( rlst_e_ne_nnc | slst_e_ne_nnc )
         )
       | ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_CMP )
         )
       )
     )                                               begin ap_lsp_cmd_v_nxt             = 1'b1 ; end

  if ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_CMP ) )   begin ap_lsp_cmd_nxt               = 2'd0 ; end
  if ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ )
     & ( ~ p6_ll_data_nxt.rdysch )
     )                                               begin ap_lsp_cmd_nxt               = 2'd1 ; end
  if ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_DEQ )
     & ( p6_ll_data_nxt.rdysch  )
     )                                               begin ap_lsp_cmd_nxt               = 2'd2 ; end
  if ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) )   begin ap_lsp_cmd_nxt               = 2'd3 ; end

  if ( ( rlst_e_ne_nnc  ) | ( rlst_ne_e_nnc  ) )     begin ap_lsp_haswork_rlst_v_nxt    = 1'b1 ; end
  if ( ( rlst_e_ne_nnc  ) )                          begin ap_lsp_haswork_rlst_func_nxt = 1'b1 ; end
  if ( ( rlst_ne_e_nnc  ) )                          begin ap_lsp_haswork_rlst_func_nxt = 1'b0 ; end

  if ( ( slst_e_ne_nnc  ) | ( slst_ne_e_nnc  ) )     begin ap_lsp_haswork_slst_v_nxt    = 1'b1 ; end
  if ( ( slst_e_ne_nnc  ) )                          begin ap_lsp_haswork_slst_func_nxt = 1'b1 ; end
  if ( ( slst_ne_e_nnc  ) )                          begin ap_lsp_haswork_slst_func_nxt = 1'b0 ; end

  if ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_CMP )
     & ( slst_ne_e_nnc  )
     & ( cfg_control0_f [ HQM_ATM_CHICKEN_EN_ALWAYSBLAST ] ? 1'b1 : ( rlst_lt_blast_nnc  ) )
     )                                               begin ap_lsp_cmpblast_v_nxt        = 1'b1 ; end

  if ( error_nopri ) begin
    credit_fifo_ap_aqed_dec_sch [ 1 ] = 1'b1 ;
  end

  if ( ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_ENQ ) & ~ ( sch_idle_nnc & enq_empty_nnc ) )
     | ( ( p6_ll_data_nxt.cmd == HQM_ATM_CMD_CMP ) & ( sch_idle_nnc & enq_empty_nnc ) )
     ) begin
    ap_lsp_dec_fid_cnt_v_nxt = 1'b1 ;
  end



  //////////////////////////////////////////////////


  end


    parity_check_qid2cqidix_p = ap_lsp_qid2cqqidix_f [ 527 : 512 ] ;
    parity_check_qid2cqidix_d = ap_lsp_qid2cqqidix_f [ 511 : 0 ] ;
    parity_check_qid2cqidix_e = ap_lsp_cmd_v_f ;

  //drive FIFO to db output
  db_ap_aqed_valid = '0 ;
  db_ap_aqed_data = '0 ;
  fifo_ap_aqed_pop = '0 ;
  fifo_ap_aqed_dec = '0 ;

  db_ap_lsp_enq_valid = '0 ;
  db_ap_lsp_enq_data = '0 ;
  fifo_ap_lsp_enq_pop = '0 ;
  fifo_ap_lsp_enq_dec = '0 ;

  if ( ~ fifo_ap_aqed_empty & db_ap_aqed_ready ) begin
    db_ap_aqed_valid                            = 1'b1 ;
    db_ap_aqed_data                             = fifo_ap_aqed_pop_data ;

    fifo_ap_aqed_pop                            = 1'b1 ;
    fifo_ap_aqed_dec                            = fifo_ap_aqed_pop ;
  end

  if ( ~ fifo_ap_lsp_enq_empty & db_ap_lsp_enq_ready ) begin
    db_ap_lsp_enq_valid                             = 1'b1 ;
    db_ap_lsp_enq_data                          = fifo_ap_lsp_enq_pop_data ;

    fifo_ap_lsp_enq_pop                         = 1'b1 ;
    fifo_ap_lsp_enq_dec                         = fifo_ap_lsp_enq_pop ;
  end

  credit_fifo_ap_aqed_dec_sch [ 0 ]             = fifo_ap_aqed_pop ;
end


always_comb begin : L22
  //....................................................................................................
  // sidecar CFG
  //   control unit CFG registers
  //     reset status register (cfg accesible)
  //     default to init RAM
  //     check for pipe idle & stop processing

  //....................................................................................................
  // initial values


  //AW modules

  smon_v = '0 ;
  smon_comp = '0 ;
  smon_val = '0 ;

  // CFG registers defaults (prevent inferred latch )
  cfg_unit_idle_nxt = cfg_unit_idle_f ;
  cfg_csr_control_nxt = cfg_csr_control_f ;
  cfg_control0_nxt = cfg_control0_f ;
  cfg_control1_nxt = cfg_control1_f ;
  cfg_control2_nxt = cfg_control2_f ;
  cfg_control4_nxt = cfg_control4_f ;
  cfg_control7_nxt = cfg_control7_f ;
  cfg_control8_nxt = cfg_control8_f ;

  cfg_pipe_health_valid_00_nxt = cfg_pipe_health_valid_00_f ;
  cfg_pipe_health_hold_00_nxt = cfg_pipe_health_hold_00_f ;
  cfg_interface_nxt = cfg_interface_f ;
  cfg_error_inj_nxt = cfg_error_inj_f ;

  // PF reset state
reset_pf_counter_0_nxt = reset_pf_counter_0_f ;
reset_pf_counter_1_nxt = reset_pf_counter_1_f ;
reset_pf_active_0_nxt = reset_pf_active_0_f ;
reset_pf_active_1_nxt = reset_pf_active_1_f ;
reset_pf_done_0_nxt =  reset_pf_done_0_f ;
reset_pf_done_1_nxt =  reset_pf_done_1_f ;
hw_init_done_0_nxt = hw_init_done_0_f ;
hw_init_done_1_nxt = hw_init_done_1_f ;





  //....................................................................................................
  // CFG register update values
  cfg_pipe_health_valid_00_nxt                          = { 16'd0
                                                          , fifo_enqueue0_pop_v
                                                          , fifo_enqueue1_pop_v
                                                          , fifo_enqueue2_pop_v
                                                          , fifo_enqueue3_pop_v
                                                          , db_lsp_ap_atm_status_pnc [ 1 ]
                                                          , db_lsp_ap_atm_status_pnc [ 0 ]
                                                          , p2_fid2qidix_v_f
                                                          , p1_fid2qidix_v_f
                                                          , p0_fid2qidix_v_f
                                                          , p6_ll_v_f
                                                          , p5_ll_v_f
                                                          , p4_ll_v_f
                                                          , p3_ll_v_f
                                                          , p2_ll_v_f
                                                          , p1_ll_v_f
                                                          , p0_ll_v_f
                                                          } ;
  cfg_pipe_health_hold_00_nxt                           = { 22'd0
                                                          , p2_fid2qidix_ctrl.hold
                                                          , p1_fid2qidix_ctrl.hold
                                                          , p0_fid2qidix_ctrl.hold
                                                          , p6_ll_ctrl.hold
                                                          , p5_ll_ctrl.hold
                                                          , p4_ll_ctrl.hold
                                                          , p3_ll_ctrl.hold
                                                          , p2_ll_ctrl.hold
                                                          , p1_ll_ctrl.hold
                                                          , p0_ll_ctrl.hold
                                                          } ;

  cfg_status0                                           = { 3'd0
                                                          , ( | cfg_pipe_health_valid_00_f )
                                                          , 1'b0
                                                          , ( | cfg_pipe_health_hold_00_f )
                                                          , 1'b0
                                                          , ( | cfg_interface_f )
                                                          , 1'b0
                                                          , fifo_ap_aqed_full
                                                          , fifo_aqed_ap_enq_full
                                                          , fifo_ap_lsp_enq_full
                                                          , rmw_fid2cqqidix_p0_hold
                                                          , rmw_fid2cqqidix_p1_hold
                                                          , rmw_fid2cqqidix_p2_hold
                                                          , rmw_fid2cqqidix_p3_hold
                                                          , ( | rmw_ll_rdylst_hp_p0_hold )
                                                          , ( | rmw_ll_rdylst_hp_p1_hold )
                                                          , ( | rmw_ll_rdylst_hp_p2_hold )
                                                          , ( | rmw_ll_rdylst_hp_p3_hold )
                                                          , ( | rmw_ll_rdylst_tp_p0_hold )
                                                          , ( | rmw_ll_rdylst_tp_p1_hold )
                                                          , ( | rmw_ll_rdylst_tp_p2_hold )
                                                          , ( | rmw_ll_rdylst_tp_p3_hold )
                                                          , ( | rmw_ll_rdylst_hpnxt_p0_hold )
                                                          , ( | rmw_ll_rdylst_hpnxt_p1_hold )
                                                          , ( | rmw_ll_rdylst_hpnxt_p2_hold )
                                                          , ( | rmw_ll_rdylst_hpnxt_p3_hold )
                                                          , rmw_ll_rlst_cnt_p0_hold
                                                          , rmw_ll_rlst_cnt_p1_hold
                                                          , rmw_ll_rlst_cnt_p2_hold
                                                          , rmw_ll_rlst_cnt_p3_hold
                                                          } ;

  cfg_status1                                           = { ( | rmw_ll_schlst_hp_p0_hold )
                                                          , ( | rmw_ll_schlst_hp_p1_hold )
                                                          , ( | rmw_ll_schlst_hp_p2_hold )
                                                          , ( | rmw_ll_schlst_hp_p3_hold )
                                                          , ( | rmw_ll_schlst_tp_p0_hold )
                                                          , ( | rmw_ll_schlst_tp_p1_hold )
                                                          , ( | rmw_ll_schlst_tp_p2_hold )
                                                          , ( | rmw_ll_schlst_tp_p3_hold )
                                                          , ( | rmw_ll_schlst_hpnxt_p0_hold )
                                                          , ( | rmw_ll_schlst_hpnxt_p1_hold )
                                                          , ( | rmw_ll_schlst_hpnxt_p2_hold )
                                                          , ( | rmw_ll_schlst_hpnxt_p3_hold )
                                                          , ( | rmw_ll_schlst_tpprv_p0_hold )
                                                          , ( | rmw_ll_schlst_tpprv_p1_hold )
                                                          , ( | rmw_ll_schlst_tpprv_p2_hold )
                                                          , ( | rmw_ll_schlst_tpprv_p3_hold )
                                                          , rmw_ll_slst_cnt_p0_hold
                                                          , rmw_ll_slst_cnt_p1_hold
                                                          , rmw_ll_slst_cnt_p2_hold
                                                          , rmw_ll_slst_cnt_p3_hold
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p0_hold ) //other dup?
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p1_hold )
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p2_hold )
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p3_hold )
                                                          , ( | rmw_ll_enq_cnt_s_p0_hold )
                                                          , ( | rmw_ll_enq_cnt_s_p1_hold )
                                                          , ( | rmw_ll_enq_cnt_s_p2_hold )
                                                          , ( | rmw_ll_enq_cnt_s_p3_hold )
                                                          , ( | rmw_ll_sch_cnt_p0_hold )
                                                          , ( | rmw_ll_sch_cnt_p1_hold )
                                                          , ( | rmw_ll_sch_cnt_p2_hold )
                                                          , ( | rmw_ll_sch_cnt_p3_hold )
                                                          } ;

  cfg_status2                                           = { 12'd0
                                                          , rmw_fid2cqqidix_p0_v_f
                                                          , rmw_fid2cqqidix_p1_v_f
                                                          , rmw_fid2cqqidix_p2_v_f
                                                          , rmw_fid2cqqidix_p3_v_f
                                                          , ( | rmw_ll_rdylst_hp_p0_v_f )
                                                          , ( | rmw_ll_rdylst_hp_p1_v_f )
                                                          , ( | rmw_ll_rdylst_hp_p2_v_f )
                                                          , ( | rmw_ll_rdylst_hp_p3_v_f )
                                                          , ( | rmw_ll_rdylst_tp_p0_v_f )
                                                          , ( | rmw_ll_rdylst_tp_p1_v_f )
                                                          , ( | rmw_ll_rdylst_tp_p2_v_f )
                                                          , ( | rmw_ll_rdylst_tp_p3_v_f )
                                                          , ( | rmw_ll_rdylst_hpnxt_p0_v_f )
                                                          , ( | rmw_ll_rdylst_hpnxt_p1_v_f )
                                                          , ( | rmw_ll_rdylst_hpnxt_p2_v_f )
                                                          , ( | rmw_ll_rdylst_hpnxt_p3_v_f )
                                                          , rmw_ll_rlst_cnt_p0_v_f
                                                          , rmw_ll_rlst_cnt_p1_v_f
                                                          , rmw_ll_rlst_cnt_p2_v_f
                                                          , rmw_ll_rlst_cnt_p3_v_f
                                                          } ;

  cfg_status3                                           = { ( | rmw_ll_schlst_hp_p0_v_f )
                                                          , ( | rmw_ll_schlst_hp_p1_v_f )
                                                          , ( | rmw_ll_schlst_hp_p2_v_f )
                                                          , ( | rmw_ll_schlst_hp_p3_v_f )
                                                          , ( | rmw_ll_schlst_tp_p0_v_f )
                                                          , ( | rmw_ll_schlst_tp_p1_v_f )
                                                          , ( | rmw_ll_schlst_tp_p2_v_f )
                                                          , ( | rmw_ll_schlst_tp_p3_v_f )
                                                          , ( | rmw_ll_schlst_hpnxt_p0_v_f )
                                                          , ( | rmw_ll_schlst_hpnxt_p1_v_f )
                                                          , ( | rmw_ll_schlst_hpnxt_p2_v_f )
                                                          , ( | rmw_ll_schlst_hpnxt_p3_v_f )
                                                          , ( | rmw_ll_schlst_tpprv_p0_v_f )
                                                          , ( | rmw_ll_schlst_tpprv_p1_v_f )
                                                          , ( | rmw_ll_schlst_tpprv_p2_v_f )
                                                          , ( | rmw_ll_schlst_tpprv_p3_v_f )
                                                          , rmw_ll_slst_cnt_p0_v_f
                                                          , rmw_ll_slst_cnt_p1_v_f
                                                          , rmw_ll_slst_cnt_p2_v_f
                                                          , rmw_ll_slst_cnt_p3_v_f
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p0_v_f )
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p1_v_f )
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p2_v_f )
                                                          , ( | rmw_ll_enq_cnt_r_dup0_p3_v_f )
                                                          , ( | rmw_ll_enq_cnt_s_p0_v_f )
                                                          , ( | rmw_ll_enq_cnt_s_p1_v_f )
                                                          , ( | rmw_ll_enq_cnt_s_p2_v_f )
                                                          , ( | rmw_ll_enq_cnt_s_p3_v_f )
                                                          , ( | rmw_ll_sch_cnt_p0_v_f )
                                                          , ( | rmw_ll_sch_cnt_p1_v_f )
                                                          , ( | rmw_ll_sch_cnt_p2_v_f )
                                                          , ( | rmw_ll_sch_cnt_p3_v_f )
                                                          } ;

  cfg_status4                                           = '0 ;
  cfg_status5                                           = '0 ;
  cfg_status6                                           = { 1'b0
                                                          , ( | int_status [ 31 : 16 ] )
                                                          , int_status [ 15 : 0 ]
                                                          , 14'd0
                                                          } ;
  cfg_status7                                           = '0 ;
  cfg_status8                                           = '0 ;


  cfg_unit_idle_nxt.pipe_idle                           = ( ~ ( | cfg_pipe_health_valid_00_nxt )
                                                          ) ;

  unit_idle_hqm_clk_gated                               = ( ( cfg_unit_idle_nxt.pipe_idle  )

                                                          & ( fifo_ap_aqed_empty  )
                                                          & ( fifo_aqed_ap_enq_empty  )
                                                          & ( fifo_ap_lsp_enq_empty  )

                                                          & ( db_ap_aqed_status_pnc [ 1 : 0 ] == 2'd0 )
                                                          & ( db_aqed_ap_enq_status_pnc [ 1 : 0 ] == 2'd0 )
                                                          & ( db_ap_lsp_enq_status_pnc [ 1 : 0 ] == 2'd0 ) 
                                                          & ( db_lsp_aqed_cmp_status_pnc [ 1 : 0 ] == 2'd0 )

//reset_control                                                          & ~ cfg_reset_status_f.reset_active
//reset_control                                                          & ~ cfg_reset_status_f.vf_reset_active
                                                          ) ;

  unit_idle_hqm_clk_inp_gated                           = ( 
                                                            (  cfg_idle )
                                                          & (  int_idle )
                                                          ) ;

  cfg_unit_idle_nxt.unit_idle                           = ( unit_idle_hqm_clk_gated ) & ( ~ hqm_gated_rst_n_active ) ;





  //....................................................................................................
  // PF reset


pf_ll_enq_cnt_s_bin0_re = '0 ;
pf_ll_enq_cnt_s_bin0_raddr = '0 ;
pf_ll_enq_cnt_s_bin0_waddr = '0 ;
pf_ll_enq_cnt_s_bin0_we = '0 ;
pf_ll_enq_cnt_s_bin0_wdata = '0 ;
pf_ll_slst_cnt_re = '0 ;
pf_ll_slst_cnt_raddr = '0 ;
pf_ll_slst_cnt_waddr = '0 ;
pf_ll_slst_cnt_we = '0 ;
pf_ll_slst_cnt_wdata = '0 ;
pf_ll_schlst_hp_bin1_re = '0 ;
pf_ll_schlst_hp_bin1_raddr = '0 ;
pf_ll_schlst_hp_bin1_waddr = '0 ;
pf_ll_schlst_hp_bin1_we = '0 ;
pf_ll_schlst_hp_bin1_wdata = '0 ;
pf_ll_sch_cnt_dup3_re = '0 ;
pf_ll_sch_cnt_dup3_raddr = '0 ;
pf_ll_sch_cnt_dup3_waddr = '0 ;
pf_ll_sch_cnt_dup3_we = '0 ;
pf_ll_sch_cnt_dup3_wdata = '0 ;
pf_ll_sch_cnt_dup1_re = '0 ;
pf_ll_sch_cnt_dup1_raddr = '0 ;
pf_ll_sch_cnt_dup1_waddr = '0 ;
pf_ll_sch_cnt_dup1_we = '0 ;
pf_ll_sch_cnt_dup1_wdata = '0 ;
pf_atm_fifo_ap_aqed_re = '0 ;
pf_atm_fifo_ap_aqed_raddr = '0 ;
pf_atm_fifo_ap_aqed_waddr = '0 ;
pf_atm_fifo_ap_aqed_we = '0 ;
pf_atm_fifo_ap_aqed_wdata = '0 ;
pf_ll_enq_cnt_s_bin3_re = '0 ;
pf_ll_enq_cnt_s_bin3_raddr = '0 ;
pf_ll_enq_cnt_s_bin3_waddr = '0 ;
pf_ll_enq_cnt_s_bin3_we = '0 ;
pf_ll_enq_cnt_s_bin3_wdata = '0 ;
pf_ll_schlst_tpprv_bin2_re = '0 ;
pf_ll_schlst_tpprv_bin2_raddr = '0 ;
pf_ll_schlst_tpprv_bin2_waddr = '0 ;
pf_ll_schlst_tpprv_bin2_we = '0 ;
pf_ll_schlst_tpprv_bin2_wdata = '0 ;
pf_ll_enq_cnt_r_bin3_dup2_re = '0 ;
pf_ll_enq_cnt_r_bin3_dup2_raddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup2_waddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup2_we = '0 ;
pf_ll_enq_cnt_r_bin3_dup2_wdata = '0 ;
pf_ll_rdylst_hpnxt_bin2_re = '0 ;
pf_ll_rdylst_hpnxt_bin2_raddr = '0 ;
pf_ll_rdylst_hpnxt_bin2_waddr = '0 ;
pf_ll_rdylst_hpnxt_bin2_we = '0 ;
pf_ll_rdylst_hpnxt_bin2_wdata = '0 ;
pf_ll_rdylst_hp_bin0_re = '0 ;
pf_ll_rdylst_hp_bin0_raddr = '0 ;
pf_ll_rdylst_hp_bin0_waddr = '0 ;
pf_ll_rdylst_hp_bin0_we = '0 ;
pf_ll_rdylst_hp_bin0_wdata = '0 ;
pf_ll_sch_cnt_dup2_re = '0 ;
pf_ll_sch_cnt_dup2_raddr = '0 ;
pf_ll_sch_cnt_dup2_waddr = '0 ;
pf_ll_sch_cnt_dup2_we = '0 ;
pf_ll_sch_cnt_dup2_wdata = '0 ;
pf_ll_rlst_cnt_re = '0 ;
pf_ll_rlst_cnt_raddr = '0 ;
pf_ll_rlst_cnt_waddr = '0 ;
pf_ll_rlst_cnt_we = '0 ;
pf_ll_rlst_cnt_wdata = '0 ;
pf_ll_schlst_tp_bin2_re = '0 ;
pf_ll_schlst_tp_bin2_raddr = '0 ;
pf_ll_schlst_tp_bin2_waddr = '0 ;
pf_ll_schlst_tp_bin2_we = '0 ;
pf_ll_schlst_tp_bin2_wdata = '0 ;
pf_ll_rdylst_tp_bin1_re = '0 ;
pf_ll_rdylst_tp_bin1_raddr = '0 ;
pf_ll_rdylst_tp_bin1_waddr = '0 ;
pf_ll_rdylst_tp_bin1_we = '0 ;
pf_ll_rdylst_tp_bin1_wdata = '0 ;
pf_ll_schlst_hpnxt_bin2_re = '0 ;
pf_ll_schlst_hpnxt_bin2_raddr = '0 ;
pf_ll_schlst_hpnxt_bin2_waddr = '0 ;
pf_ll_schlst_hpnxt_bin2_we = '0 ;
pf_ll_schlst_hpnxt_bin2_wdata = '0 ;
pf_ll_schlst_hpnxt_bin1_re = '0 ;
pf_ll_schlst_hpnxt_bin1_raddr = '0 ;
pf_ll_schlst_hpnxt_bin1_waddr = '0 ;
pf_ll_schlst_hpnxt_bin1_we = '0 ;
pf_ll_schlst_hpnxt_bin1_wdata = '0 ;
pf_ll_enq_cnt_r_bin2_dup3_re = '0 ;
pf_ll_enq_cnt_r_bin2_dup3_raddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup3_waddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup3_we = '0 ;
pf_ll_enq_cnt_r_bin2_dup3_wdata = '0 ;
pf_ll_enq_cnt_r_bin0_dup3_re = '0 ;
pf_ll_enq_cnt_r_bin0_dup3_raddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup3_waddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup3_we = '0 ;
pf_ll_enq_cnt_r_bin0_dup3_wdata = '0 ;
pf_ll_schlst_tpprv_bin1_re = '0 ;
pf_ll_schlst_tpprv_bin1_raddr = '0 ;
pf_ll_schlst_tpprv_bin1_waddr = '0 ;
pf_ll_schlst_tpprv_bin1_we = '0 ;
pf_ll_schlst_tpprv_bin1_wdata = '0 ;
pf_ll_enq_cnt_r_bin1_dup2_re = '0 ;
pf_ll_enq_cnt_r_bin1_dup2_raddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup2_waddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup2_we = '0 ;
pf_ll_enq_cnt_r_bin1_dup2_wdata = '0 ;
pf_ll_schlst_tp_bin0_re = '0 ;
pf_ll_schlst_tp_bin0_raddr = '0 ;
pf_ll_schlst_tp_bin0_waddr = '0 ;
pf_ll_schlst_tp_bin0_we = '0 ;
pf_ll_schlst_tp_bin0_wdata = '0 ;
pf_ll_rdylst_hpnxt_bin3_re = '0 ;
pf_ll_rdylst_hpnxt_bin3_raddr = '0 ;
pf_ll_rdylst_hpnxt_bin3_waddr = '0 ;
pf_ll_rdylst_hpnxt_bin3_we = '0 ;
pf_ll_rdylst_hpnxt_bin3_wdata = '0 ;
pf_ll_enq_cnt_r_bin0_dup1_re = '0 ;
pf_ll_enq_cnt_r_bin0_dup1_raddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup1_waddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup1_we = '0 ;
pf_ll_enq_cnt_r_bin0_dup1_wdata = '0 ;
pf_ll_enq_cnt_r_bin3_dup1_re = '0 ;
pf_ll_enq_cnt_r_bin3_dup1_raddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup1_waddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup1_we = '0 ;
pf_ll_enq_cnt_r_bin3_dup1_wdata = '0 ;
pf_ll_schlst_hp_bin2_re = '0 ;
pf_ll_schlst_hp_bin2_raddr = '0 ;
pf_ll_schlst_hp_bin2_waddr = '0 ;
pf_ll_schlst_hp_bin2_we = '0 ;
pf_ll_schlst_hp_bin2_wdata = '0 ;
pf_ll_enq_cnt_r_bin1_dup0_re = '0 ;
pf_ll_enq_cnt_r_bin1_dup0_raddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup0_waddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup0_we = '0 ;
pf_ll_enq_cnt_r_bin1_dup0_wdata = '0 ;
pf_ll_enq_cnt_r_bin0_dup0_re = '0 ;
pf_ll_enq_cnt_r_bin0_dup0_raddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup0_waddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup0_we = '0 ;
pf_ll_enq_cnt_r_bin0_dup0_wdata = '0 ;
pf_ll_schlst_hpnxt_bin3_re = '0 ;
pf_ll_schlst_hpnxt_bin3_raddr = '0 ;
pf_ll_schlst_hpnxt_bin3_waddr = '0 ;
pf_ll_schlst_hpnxt_bin3_we = '0 ;
pf_ll_schlst_hpnxt_bin3_wdata = '0 ;
pf_ll_rdylst_hp_bin3_re = '0 ;
pf_ll_rdylst_hp_bin3_raddr = '0 ;
pf_ll_rdylst_hp_bin3_waddr = '0 ;
pf_ll_rdylst_hp_bin3_we = '0 ;
pf_ll_rdylst_hp_bin3_wdata = '0 ;
pf_ll_schlst_tp_bin1_re = '0 ;
pf_ll_schlst_tp_bin1_raddr = '0 ;
pf_ll_schlst_tp_bin1_waddr = '0 ;
pf_ll_schlst_tp_bin1_we = '0 ;
pf_ll_schlst_tp_bin1_wdata = '0 ;
pf_ll_enq_cnt_s_bin2_re = '0 ;
pf_ll_enq_cnt_s_bin2_raddr = '0 ;
pf_ll_enq_cnt_s_bin2_waddr = '0 ;
pf_ll_enq_cnt_s_bin2_we = '0 ;
pf_ll_enq_cnt_s_bin2_wdata = '0 ;
pf_aqed_qid2cqidix_re = '0 ;
pf_aqed_qid2cqidix_addr = '0 ;
pf_aqed_qid2cqidix_we = '0 ;
pf_aqed_qid2cqidix_wdata = '0 ;
pf_ll_rdylst_tp_bin3_re = '0 ;
pf_ll_rdylst_tp_bin3_raddr = '0 ;
pf_ll_rdylst_tp_bin3_waddr = '0 ;
pf_ll_rdylst_tp_bin3_we = '0 ;
pf_ll_rdylst_tp_bin3_wdata = '0 ;
pf_ll_schlst_tpprv_bin0_re = '0 ;
pf_ll_schlst_tpprv_bin0_raddr = '0 ;
pf_ll_schlst_tpprv_bin0_waddr = '0 ;
pf_ll_schlst_tpprv_bin0_we = '0 ;
pf_ll_schlst_tpprv_bin0_wdata = '0 ;
pf_ll_schlst_tp_bin3_re = '0 ;
pf_ll_schlst_tp_bin3_raddr = '0 ;
pf_ll_schlst_tp_bin3_waddr = '0 ;
pf_ll_schlst_tp_bin3_we = '0 ;
pf_ll_schlst_tp_bin3_wdata = '0 ;
pf_ll_enq_cnt_r_bin0_dup2_re = '0 ;
pf_ll_enq_cnt_r_bin0_dup2_raddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup2_waddr = '0 ;
pf_ll_enq_cnt_r_bin0_dup2_we = '0 ;
pf_ll_enq_cnt_r_bin0_dup2_wdata = '0 ;
pf_ll_enq_cnt_r_bin2_dup2_re = '0 ;
pf_ll_enq_cnt_r_bin2_dup2_raddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup2_waddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup2_we = '0 ;
pf_ll_enq_cnt_r_bin2_dup2_wdata = '0 ;
pf_ll_schlst_tpprv_bin3_re = '0 ;
pf_ll_schlst_tpprv_bin3_raddr = '0 ;
pf_ll_schlst_tpprv_bin3_waddr = '0 ;
pf_ll_schlst_tpprv_bin3_we = '0 ;
pf_ll_schlst_tpprv_bin3_wdata = '0 ;
pf_ll_enq_cnt_r_bin1_dup3_re = '0 ;
pf_ll_enq_cnt_r_bin1_dup3_raddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup3_waddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup3_we = '0 ;
pf_ll_enq_cnt_r_bin1_dup3_wdata = '0 ;
pf_ll_rdylst_tp_bin0_re = '0 ;
pf_ll_rdylst_tp_bin0_raddr = '0 ;
pf_ll_rdylst_tp_bin0_waddr = '0 ;
pf_ll_rdylst_tp_bin0_we = '0 ;
pf_ll_rdylst_tp_bin0_wdata = '0 ;
pf_ll_rdylst_hp_bin1_re = '0 ;
pf_ll_rdylst_hp_bin1_raddr = '0 ;
pf_ll_rdylst_hp_bin1_waddr = '0 ;
pf_ll_rdylst_hp_bin1_we = '0 ;
pf_ll_rdylst_hp_bin1_wdata = '0 ;
pf_ll_enq_cnt_r_bin3_dup3_re = '0 ;
pf_ll_enq_cnt_r_bin3_dup3_raddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup3_waddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup3_we = '0 ;
pf_ll_enq_cnt_r_bin3_dup3_wdata = '0 ;
pf_ll_rdylst_tp_bin2_re = '0 ;
pf_ll_rdylst_tp_bin2_raddr = '0 ;
pf_ll_rdylst_tp_bin2_waddr = '0 ;
pf_ll_rdylst_tp_bin2_we = '0 ;
pf_ll_rdylst_tp_bin2_wdata = '0 ;
pf_ll_schlst_hp_bin0_re = '0 ;
pf_ll_schlst_hp_bin0_raddr = '0 ;
pf_ll_schlst_hp_bin0_waddr = '0 ;
pf_ll_schlst_hp_bin0_we = '0 ;
pf_ll_schlst_hp_bin0_wdata = '0 ;
pf_ll_schlst_hpnxt_bin0_re = '0 ;
pf_ll_schlst_hpnxt_bin0_raddr = '0 ;
pf_ll_schlst_hpnxt_bin0_waddr = '0 ;
pf_ll_schlst_hpnxt_bin0_we = '0 ;
pf_ll_schlst_hpnxt_bin0_wdata = '0 ;
pf_ll_enq_cnt_r_bin1_dup1_re = '0 ;
pf_ll_enq_cnt_r_bin1_dup1_raddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup1_waddr = '0 ;
pf_ll_enq_cnt_r_bin1_dup1_we = '0 ;
pf_ll_enq_cnt_r_bin1_dup1_wdata = '0 ;
pf_atm_fifo_aqed_ap_enq_re = '0 ;
pf_atm_fifo_aqed_ap_enq_raddr = '0 ;
pf_atm_fifo_aqed_ap_enq_waddr = '0 ;
pf_atm_fifo_aqed_ap_enq_we = '0 ;
pf_atm_fifo_aqed_ap_enq_wdata = '0 ;
pf_qid_rdylst_clamp_re = '0 ;
pf_qid_rdylst_clamp_raddr = '0 ;
pf_qid_rdylst_clamp_waddr = '0 ;
pf_qid_rdylst_clamp_we = '0 ;
pf_qid_rdylst_clamp_wdata = '0 ;
pf_ll_enq_cnt_r_bin2_dup1_re = '0 ;
pf_ll_enq_cnt_r_bin2_dup1_raddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup1_waddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup1_we = '0 ;
pf_ll_enq_cnt_r_bin2_dup1_wdata = '0 ;
pf_ll_rdylst_hpnxt_bin1_re = '0 ;
pf_ll_rdylst_hpnxt_bin1_raddr = '0 ;
pf_ll_rdylst_hpnxt_bin1_waddr = '0 ;
pf_ll_rdylst_hpnxt_bin1_we = '0 ;
pf_ll_rdylst_hpnxt_bin1_wdata = '0 ;
pf_ll_enq_cnt_r_bin2_dup0_re = '0 ;
pf_ll_enq_cnt_r_bin2_dup0_raddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup0_waddr = '0 ;
pf_ll_enq_cnt_r_bin2_dup0_we = '0 ;
pf_ll_enq_cnt_r_bin2_dup0_wdata = '0 ;
pf_ll_enq_cnt_s_bin1_re = '0 ;
pf_ll_enq_cnt_s_bin1_raddr = '0 ;
pf_ll_enq_cnt_s_bin1_waddr = '0 ;
pf_ll_enq_cnt_s_bin1_we = '0 ;
pf_ll_enq_cnt_s_bin1_wdata = '0 ;
pf_ll_schlst_hp_bin3_re = '0 ;
pf_ll_schlst_hp_bin3_raddr = '0 ;
pf_ll_schlst_hp_bin3_waddr = '0 ;
pf_ll_schlst_hp_bin3_we = '0 ;
pf_ll_schlst_hp_bin3_wdata = '0 ;
pf_fid2cqqidix_re = '0 ;
pf_fid2cqqidix_raddr = '0 ;
pf_fid2cqqidix_waddr = '0 ;
pf_fid2cqqidix_we = '0 ;
pf_fid2cqqidix_wdata = '0 ;
pf_ll_rdylst_hpnxt_bin0_re = '0 ;
pf_ll_rdylst_hpnxt_bin0_raddr = '0 ;
pf_ll_rdylst_hpnxt_bin0_waddr = '0 ;
pf_ll_rdylst_hpnxt_bin0_we = '0 ;
pf_ll_rdylst_hpnxt_bin0_wdata = '0 ;
pf_ll_rdylst_hp_bin2_re = '0 ;
pf_ll_rdylst_hp_bin2_raddr = '0 ;
pf_ll_rdylst_hp_bin2_waddr = '0 ;
pf_ll_rdylst_hp_bin2_we = '0 ;
pf_ll_rdylst_hp_bin2_wdata = '0 ;
pf_ll_sch_cnt_dup0_re = '0 ;
pf_ll_sch_cnt_dup0_raddr = '0 ;
pf_ll_sch_cnt_dup0_waddr = '0 ;
pf_ll_sch_cnt_dup0_we = '0 ;
pf_ll_sch_cnt_dup0_wdata = '0 ;
pf_ll_enq_cnt_r_bin3_dup0_re = '0 ;
pf_ll_enq_cnt_r_bin3_dup0_raddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup0_waddr = '0 ;
pf_ll_enq_cnt_r_bin3_dup0_we = '0 ;
pf_ll_enq_cnt_r_bin3_dup0_wdata = '0 ;

pf_reset_active_0 = 1'b0 ;
pf_reset_active_1 = 1'b0 ;

  if ( hqm_gated_rst_n_start & reset_pf_active_0_f & ~ hw_init_done_0_f ) begin
    reset_pf_counter_0_nxt                        = reset_pf_counter_0_f + 32'b1 ;

    if ( reset_pf_counter_0_f < HQM_ATM_CFG_RST_PFMAX ) begin
      pf_reset_active_0 = 1'b1 ;

      pf_ll_rdylst_hp_bin0_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_hp_bin0_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hp_bin0_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HP_BIN0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_hp_bin1_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_hp_bin1_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HP_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hp_bin1_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HP_BIN1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_hp_bin2_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_hp_bin2_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HP_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hp_bin2_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HP_BIN2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_hp_bin3_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_hp_bin3_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HP_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hp_bin3_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HP_BIN3_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_tp_bin0_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_tp_bin0_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_tp_bin0_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_TP_BIN0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_tp_bin1_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_tp_bin1_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_TP_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_tp_bin1_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_TP_BIN1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_tp_bin2_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_tp_bin2_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_TP_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_tp_bin2_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_TP_BIN2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_tp_bin3_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rdylst_tp_bin3_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_TP_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_tp_bin3_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_TP_BIN3_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_hpnxt_bin0_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_rdylst_hpnxt_bin0_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hpnxt_bin0_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HPNXT_BIN0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_hpnxt_bin1_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_rdylst_hpnxt_bin1_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hpnxt_bin1_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HPNXT_BIN1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_hpnxt_bin2_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_rdylst_hpnxt_bin2_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hpnxt_bin2_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HPNXT_BIN2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rdylst_hpnxt_bin3_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_rdylst_hpnxt_bin3_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RDYLST_HPNXT_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rdylst_hpnxt_bin3_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_RDYLST_HPNXT_BIN3_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_rlst_cnt_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_ll_rlst_cnt_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_RLST_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_rlst_cnt_wdata = { 2'd0 , { ( HQM_ATM_LL_RLST_CNT_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_schlst_hp_bin0_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_hp_bin0_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HP_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hp_bin0_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HP_BIN0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_hp_bin1_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_hp_bin1_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HP_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hp_bin1_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HP_BIN1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_hp_bin2_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_hp_bin2_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HP_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hp_bin2_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HP_BIN2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_hp_bin3_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_hp_bin3_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HP_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hp_bin3_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HP_BIN3_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_tp_bin0_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_tp_bin0_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_TP_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tp_bin0_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TP_BIN0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_tp_bin1_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_tp_bin1_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_TP_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tp_bin1_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TP_BIN1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_tp_bin2_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_tp_bin2_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_TP_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tp_bin2_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TP_BIN2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_tp_bin3_we = ( reset_pf_counter_0_f < 32'd512 ) ;
      pf_ll_schlst_tp_bin3_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_TP_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tp_bin3_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TP_BIN3_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_hpnxt_bin0_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_schlst_hpnxt_bin0_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hpnxt_bin0_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HPNXT_BIN0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_hpnxt_bin1_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_schlst_hpnxt_bin1_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hpnxt_bin1_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HPNXT_BIN1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_hpnxt_bin2_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_schlst_hpnxt_bin2_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hpnxt_bin2_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HPNXT_BIN2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_hpnxt_bin3_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_schlst_hpnxt_bin3_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_HPNXT_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_hpnxt_bin3_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_HPNXT_BIN3_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_tpprv_bin0_we = ( reset_pf_counter_0_f < 32'd2048 ) ;
      pf_ll_schlst_tpprv_bin0_waddr = reset_pf_counter_0_f [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tpprv_bin0_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TPPRV_BIN0_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_aqed_qid2cqidix_we = ( reset_pf_counter_0_f < 32'd32 ) ;
      pf_aqed_qid2cqidix_addr = reset_pf_counter_0_f [ ( HQM_ATM_QID2CQIDIX_DEPTHB2 ) - 1 : 0 ] ;
      pf_aqed_qid2cqidix_wdata = { 16'b1111111111111111 , { ( HQM_ATM_QID2CQIDIX_DWIDTH - 16 ) { 1'b0 } } } ;

    end
    else begin
      reset_pf_counter_0_nxt                    = reset_pf_counter_0_f ;
      hw_init_done_0_nxt                          = 1'b1 ;
    end
  end

  if ( hqm_gated_rst_n_start & reset_pf_active_1_f & ~ hw_init_done_1_f ) begin
    reset_pf_counter_1_nxt                        = reset_pf_counter_1_f + 32'b1 ;

    if ( reset_pf_counter_1_f < HQM_ATM_CFG_RST_PFMAX ) begin
      pf_reset_active_1 = 1'b1 ;


      pf_ll_schlst_tpprv_bin1_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_schlst_tpprv_bin1_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tpprv_bin1_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TPPRV_BIN1_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_tpprv_bin2_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_schlst_tpprv_bin2_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tpprv_bin2_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TPPRV_BIN2_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_schlst_tpprv_bin3_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_schlst_tpprv_bin3_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SCHLST_TPPRV_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_schlst_tpprv_bin3_wdata = { 1'b1 , 1'b1 , { ( HQM_ATM_LL_SCHLST_TPPRV_BIN3_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_ll_slst_cnt_we = ( reset_pf_counter_1_f < 32'd512 ) ;
      pf_ll_slst_cnt_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SLST_CNT_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_slst_cnt_wdata = { 2'd0 , { ( HQM_ATM_LL_SLST_CNT_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin0_dup0_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin0_dup0_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin0_dup0_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin1_dup0_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin1_dup0_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin1_dup0_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin2_dup0_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin2_dup0_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin2_dup0_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin3_dup0_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin3_dup0_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin3_dup0_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin0_dup1_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin0_dup1_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin0_dup1_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin1_dup1_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin1_dup1_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin1_dup1_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin2_dup1_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin2_dup1_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin2_dup1_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin3_dup1_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin3_dup1_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin3_dup1_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin0_dup2_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin0_dup2_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin0_dup2_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin1_dup2_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin1_dup2_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin1_dup2_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin2_dup2_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin2_dup2_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin2_dup2_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin3_dup2_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin3_dup2_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin3_dup2_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin0_dup3_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin0_dup3_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin0_dup3_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN0_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin1_dup3_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin1_dup3_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin1_dup3_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN1_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin2_dup3_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin2_dup3_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin2_dup3_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN2_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_r_bin3_dup3_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_r_bin3_dup3_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_r_bin3_dup3_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_R_BIN3_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_s_bin0_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_s_bin0_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_S_BIN0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_s_bin0_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_S_BIN0_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_s_bin1_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_s_bin1_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_S_BIN1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_s_bin1_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_S_BIN1_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_s_bin2_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_s_bin2_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_S_BIN2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_s_bin2_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_S_BIN2_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_enq_cnt_s_bin3_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_enq_cnt_s_bin3_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_ENQ_CNT_S_BIN3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_enq_cnt_s_bin3_wdata = { 2'd0 , { ( HQM_ATM_LL_ENQ_CNT_S_BIN3_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_sch_cnt_dup0_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_sch_cnt_dup0_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SCH_CNT_DUP0_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_sch_cnt_dup0_wdata = { 2'd0 , { ( HQM_ATM_LL_SCH_CNT_DUP0_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_sch_cnt_dup1_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_sch_cnt_dup1_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SCH_CNT_DUP1_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_sch_cnt_dup1_wdata = { 2'd0 , { ( HQM_ATM_LL_SCH_CNT_DUP1_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_sch_cnt_dup2_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_sch_cnt_dup2_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SCH_CNT_DUP2_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_sch_cnt_dup2_wdata = { 2'd0 , { ( HQM_ATM_LL_SCH_CNT_DUP2_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_ll_sch_cnt_dup3_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_ll_sch_cnt_dup3_waddr = reset_pf_counter_1_f [ ( HQM_ATM_LL_SCH_CNT_DUP3_DEPTHB2 ) - 1 : 0 ] ;
      pf_ll_sch_cnt_dup3_wdata = { 2'd0 , { ( HQM_ATM_LL_SCH_CNT_DUP3_DWIDTH - 2 ) { 1'b0 } } } ;

      pf_fid2cqqidix_we = ( reset_pf_counter_1_f < 32'd2048 ) ;
      pf_fid2cqqidix_waddr = reset_pf_counter_1_f [ ( HQM_ATM_FID2CQQIDIX_DEPTHB2 ) - 1 : 0 ] ;
      pf_fid2cqqidix_wdata = { 1'b1 , { ( HQM_ATM_FID2CQQIDIX_DWIDTH - 1 ) { 1'b0 } } } ;

      pf_qid_rdylst_clamp_we = ( reset_pf_counter_1_f < 32'd32 ) ;
      pf_qid_rdylst_clamp_waddr = reset_pf_counter_1_f [ ( HQM_ATM_QID_RDYLST_CLAMP_DEPTHB2 ) - 1 : 0 ] ;
      pf_qid_rdylst_clamp_wdata = { 1'b1 , 1'b0 , 2'd3 , 2'd0 } ;

    end
    else begin
      reset_pf_counter_1_nxt                            = reset_pf_counter_1_f ;
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










  //....................................................................................................
  // INT & SYND

  //....................................................................................................
  // SMON
  //NOTE: smon_v 0-15 are functional, performance & stall
  //NOTE: smon_v 16+ are FPGA ONLY

  smon_v [ 0 * 1 +: 1 ]                                  = db_lsp_ap_atm_valid & db_lsp_ap_atm_ready & ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_CMP ) ;
  smon_comp [ 0 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 0 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 1 * 1 +: 1 ]                                  = fifo_ap_aqed_push ;
  smon_comp [ 1 * 32 +: 32 ]                             = { 25'd0 , fifo_ap_aqed_push_data.qid } ;
  smon_val [ 1 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 2 * 1 +: 1 ]                                  = fifo_aqed_ap_enq_push ;
  smon_comp [ 2 * 32 +: 32 ]                             = { 25'd0 , fifo_aqed_ap_enq_push_data.qid } ;
  smon_val [ 2 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 3 * 1 +: 1 ]                                  = fifo_ap_lsp_enq_push ;
  smon_comp [ 3 * 32 +: 32 ]                             = { 25'd0 , fifo_ap_lsp_enq_push_data.qid } ;
  smon_val [ 3 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 4 * 1 +: 1 ]                                  = db_lsp_ap_atm_valid & db_lsp_ap_atm_ready & ( ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_RLST ) | ( db_lsp_ap_atm_data.cmd == LSP_AP_ATM_SCH_SLST ) ) ;
  smon_comp [ 4 * 32 +: 32 ]                             = { 25'd0 , db_lsp_ap_atm_data.qid } ;
  smon_val [ 4 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 5 * 1 +: 1 ]                                  = db_lsp_aqed_cmp_v & db_lsp_aqed_cmp_ready ;
  smon_comp [ 5 * 32 +: 32 ]                             = { 25'd0 , db_lsp_aqed_cmp_data.qid } ;
  smon_val [ 5 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 6 * 1 +: 1 ]                                  = p6_debug_print_nc [ HQM_ATM_SCH_RS ] ; //22 SCHEDULE: RDY_WINS  R->S
  smon_comp [ 6 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 6 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 7 * 1 +: 1 ]                                  = p6_debug_print_nc [ HQM_ATM_SCH_SS ] ; //21 SCHEDULE: SCH_WINS S->S
  smon_comp [ 7 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 7 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 8 * 1 +: 1 ]                                  = p6_debug_print_nc [ HQM_ATM_CMP_SR ] ; //10 COMPLETE: LAST SCH -> RDY
  smon_comp [ 8 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 8 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 9 * 1 +: 1 ]                                  = arb_ll_strict_reqs [ 0 ] & arb_ll_strict_winner_v  & arb_ll_strict_winner ;
  smon_comp [ 9 * 32 +: 32 ]                             = { 32'd0 } ;
  smon_val [ 9 * 32 +: 32 ]                              = 32'd1 ;

  smon_v [ 10 * 1 +: 1 ]                                 = db_lsp_aqed_cmp_v & ~ db_lsp_aqed_cmp_ready ;
  smon_comp [ 10 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 10 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 11 * 1 +: 1 ]                                 = db_lsp_ap_atm_valid & ~ db_lsp_ap_atm_ready ;
  smon_comp [ 11 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 11 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 12 * 1 +: 1 ]                                 = db_ap_lsp_enq_valid & ~ db_ap_lsp_enq_ready ;
  smon_comp [ 12 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 12 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 13 * 1 +: 1 ]                                 = db_aqed_ap_enq_valid & ~ db_aqed_ap_enq_ready ;
  smon_comp [ 13 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 13 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 14 * 1 +: 1 ]                                 = db_ap_aqed_valid & ~ db_ap_aqed_ready ;
  smon_comp [ 14 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 14 * 32 +: 32 ]                             = 32'd1 ;

  smon_v [ 15 * 1 +: 1 ]                                 = stall_f [ 3 ] ;
  smon_comp [ 15 * 32 +: 32 ]                            = { 32'd0 } ;
  smon_val [ 15 * 32 +: 32 ]                             = 32'd1 ;





  //..................................................
  //Feature detect
cfg_control7_nxt [ 0 ] = cfg_control7_f [ 0 ] | ( p6_debug_print_nc [ HQM_ATM_ENQ_ES ] ) ;
cfg_control7_nxt [ 1 ] = cfg_control7_f [ 1 ] | ( p6_debug_print_nc [ HQM_ATM_ENQ_SS ] ) ;
cfg_control7_nxt [ 2 ] = cfg_control7_f [ 2 ] | ( p6_debug_print_nc [ HQM_ATM_ENQ_RR ] ) ;
cfg_control7_nxt [ 3 ] = cfg_control7_f [ 3 ] | ( p6_debug_print_nc [ HQM_ATM_ENQ_IR ] ) ;
cfg_control7_nxt [ 4 ] = cfg_control7_f [ 4 ] | ( p6_debug_print_nc [ HQM_ATM_CMP_SR ] ) ;
cfg_control7_nxt [ 5 ] = cfg_control7_f [ 5 ] | ( p6_debug_print_nc [ HQM_ATM_CMP_SI ] ) ;
cfg_control7_nxt [ 6 ] = cfg_control7_f [ 6 ] | ( p6_debug_print_nc [ HQM_ATM_CMP_SRESRE ] ) ;
cfg_control7_nxt [ 7 ] = cfg_control7_f [ 7 ] | ( p6_debug_print_nc [ HQM_ATM_SCH_SE ] ) ;
cfg_control7_nxt [ 8 ] = cfg_control7_f [ 8 ] | ( p6_debug_print_nc [ HQM_ATM_SCH_SS ] ) ;
cfg_control7_nxt [ 9 ] = cfg_control7_f [ 9 ] | ( p6_debug_print_nc [ HQM_ATM_SCH_RS ] ) ;
cfg_control7_nxt [ 10 ] = cfg_control7_f [ 10 ] | ( p6_debug_print_nc [ HQM_ATM_SCH_RE ] ) ;
cfg_control7_nxt [ 11 ] = cfg_control7_f [ 11 ] | ( feature_clamped_low ) ;
cfg_control7_nxt [ 12 ] = cfg_control7_f [ 12 ] | ( feature_clamped_high ) ;
cfg_control7_nxt [ 13 ] = cfg_control7_f [ 13 ] | ( feature_enq_afull ) ;



cfg_control7_nxt [ 17 ] = cfg_control7_f [ 17 ] | ( ( fifo_enqueue0_byp & fifo_enqueue0_pop_v & ( fifo_enqueue0_pop_fid == fifo_enqueue0_byp_fid ) ) | ( fifo_enqueue0_byp & fifo_enqueue0_push & ( fifo_enqueue0_push_fid == fifo_enqueue0_byp_fid ) ) ) ;
cfg_control7_nxt [ 18 ] = cfg_control7_f [ 18 ] | ( ( fifo_enqueue1_byp & fifo_enqueue1_pop_v & ( fifo_enqueue1_pop_fid == fifo_enqueue1_byp_fid ) ) | ( fifo_enqueue1_byp & fifo_enqueue1_push & ( fifo_enqueue1_push_fid == fifo_enqueue1_byp_fid ) ) ) ;
cfg_control7_nxt [ 19 ] = cfg_control7_f [ 19 ] | ( ( fifo_enqueue2_byp & fifo_enqueue2_pop_v & ( fifo_enqueue2_pop_fid == fifo_enqueue2_byp_fid ) ) | ( fifo_enqueue2_byp & fifo_enqueue2_push & ( fifo_enqueue2_push_fid == fifo_enqueue2_byp_fid ) ) ) ;
cfg_control7_nxt [ 20 ] = cfg_control7_f [ 20 ] | ( ( fifo_enqueue3_byp & fifo_enqueue3_pop_v & ( fifo_enqueue3_pop_fid == fifo_enqueue3_byp_fid ) ) | ( fifo_enqueue3_byp & fifo_enqueue3_push & ( fifo_enqueue3_push_fid == fifo_enqueue3_byp_fid ) ) ) ;

cfg_control7_nxt [ 21 ] = cfg_control7_f [ 21 ] | ( p0_ll_v_nxt & p0_ll_data_nxt.super_bypassed ) ; //for coverage: cq/qidix bypassed into p0
cfg_control7_nxt [ 22 ] = cfg_control7_f [ 22 ] | ( p1_ll_v_nxt & p1_ll_data_nxt.super_bypassed ) ; //for coverage: cq/qidix bypassed into p1
cfg_control7_nxt [ 23 ] = cfg_control7_f [ 23 ] | ( p2_ll_v_nxt & p2_ll_data_nxt.super_bypassed ) ; //for coverage: cq/qidix bypassed into p2
cfg_control7_nxt [ 24 ] = cfg_control7_f [ 24 ] | ( p3_ll_v_nxt & p3_ll_data_nxt.super_bypassed ) ; //for coverage: cq/qidix bypassed into p3
cfg_control7_nxt [ 25 ] = cfg_control7_f [ 25 ] | ( p0_ll_v_nxt & ( | p0_ll_data_nxt.bypassed_sch_tp ) ) ; //for coverage: cq/qidix bypassed into p0
cfg_control7_nxt [ 26 ] = cfg_control7_f [ 26 ] | ( p1_ll_v_nxt & ( | p1_ll_data_nxt.bypassed_sch_tp ) ) ; //for coverage: cq/qidix bypassed into p1
cfg_control7_nxt [ 27 ] = cfg_control7_f [ 27 ] | ( p2_ll_v_nxt & ( | p2_ll_data_nxt.bypassed_sch_tp ) ) ; //for coverage: cq/qidix bypassed into p2
cfg_control7_nxt [ 28 ] = cfg_control7_f [ 28 ] | ( p3_ll_v_nxt & ( | p3_ll_data_nxt.bypassed_sch_tp ) ) ; //for coverage: cq/qidix bypassed into p3
cfg_control7_nxt [ 29 ] = cfg_control7_f [ 29 ] | ( p4_ll_v_nxt & ( | p4_ll_data_nxt.bypassed_sch_tp ) ) ; //for coverage: cq/qidix bypassed into p4
cfg_control7_nxt [ 30 ] = cfg_control7_f [ 30 ] | ( ap_lsp_cmpblast_v_nxt ) ; //issue a completion blast command to lsp
cfg_control7_nxt [ 31 ] = cfg_control7_f [ 31 ] | ( stall_f [ 4 ] ) ; //pipeline contention stall


cfg_control8_nxt [ 0 ] = cfg_control8_f [ 0 ] | ( func_ll_enq_cnt_s_bin0_we & ( | func_ll_enq_cnt_s_bin0_wdata [ 11 : 0 ]  ) ) ;
cfg_control8_nxt [ 1 ] = cfg_control8_f [ 1 ] | ( func_ll_enq_cnt_s_bin1_we & ( | func_ll_enq_cnt_s_bin1_wdata [ 11 : 0 ] ) ) ;
cfg_control8_nxt [ 2 ] = cfg_control8_f [ 2 ] | ( func_ll_enq_cnt_s_bin2_we & ( | func_ll_enq_cnt_s_bin2_wdata [ 11 : 0 ] ) ) ;
cfg_control8_nxt [ 3 ] = cfg_control8_f [ 3 ] | ( func_ll_enq_cnt_s_bin3_we & ( | func_ll_enq_cnt_s_bin3_wdata [ 11 : 0 ] ) ) ;
cfg_control8_nxt [ 4 ] = cfg_control8_f [ 4 ] | ( func_ll_rlst_cnt_we & ( | func_ll_rlst_cnt_wdata [ 11 : 0 ] ) ) ;
cfg_control8_nxt [ 5 ] = cfg_control8_f [ 5 ] | ( func_ll_rlst_cnt_we & ( | func_ll_rlst_cnt_wdata [ 25 : 14 ] ) ) ;
cfg_control8_nxt [ 6 ] = cfg_control8_f [ 6 ] | ( func_ll_rlst_cnt_we & ( | func_ll_rlst_cnt_wdata [ 39 : 28 ] ) ) ;
cfg_control8_nxt [ 7 ] = cfg_control8_f [ 7 ] | ( func_ll_rlst_cnt_we & ( | func_ll_rlst_cnt_wdata [ 53 : 42 ] ) ) ;
cfg_control8_nxt [ 8 ] = cfg_control8_f [ 8 ] | ( func_ll_slst_cnt_we & ( | func_ll_slst_cnt_wdata [ 11 : 0 ] ) ) ;
cfg_control8_nxt [ 9 ] = cfg_control8_f [ 9 ] | ( func_ll_slst_cnt_we & ( | func_ll_slst_cnt_wdata [ 25 : 14 ] ) ) ;
cfg_control8_nxt [ 10 ] = cfg_control8_f [ 10 ] | ( func_ll_slst_cnt_we & ( | func_ll_slst_cnt_wdata [ 39 : 28 ] ) ) ;
cfg_control8_nxt [ 11 ] = cfg_control8_f [ 11 ] | ( func_ll_slst_cnt_we & ( | func_ll_slst_cnt_wdata [ 53 : 42 ] ) ) ;
cfg_control8_nxt [ 12 ] = cfg_control8_f [ 12 ] | ( func_ll_sch_cnt_dup0_we & ( | func_ll_sch_cnt_dup0_wdata [ 12 : 0 ] ) ) ;

cfg_control8_nxt [ 16 ] = cfg_control8_f [ 16 ] | ( func_ll_enq_cnt_s_bin0_we & ( func_ll_enq_cnt_s_bin0_wdata [ 11 : 0 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 17 ] = cfg_control8_f [ 17 ] | ( func_ll_enq_cnt_s_bin1_we & ( func_ll_enq_cnt_s_bin1_wdata [ 11 : 0 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 18 ] = cfg_control8_f [ 18 ] | ( func_ll_enq_cnt_s_bin2_we & ( func_ll_enq_cnt_s_bin2_wdata [ 11 : 0 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 19 ] = cfg_control8_f [ 19 ] | ( func_ll_enq_cnt_s_bin3_we & ( func_ll_enq_cnt_s_bin3_wdata [ 11 : 0 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 20 ] = cfg_control8_f [ 20 ] | ( func_ll_rlst_cnt_we & ( func_ll_rlst_cnt_wdata [ 11 : 0 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 21 ] = cfg_control8_f [ 21 ] | ( func_ll_rlst_cnt_we & ( func_ll_rlst_cnt_wdata [ 25 : 14 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 22 ] = cfg_control8_f [ 22 ] | ( func_ll_rlst_cnt_we & ( func_ll_rlst_cnt_wdata [ 39 : 28 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 23 ] = cfg_control8_f [ 23 ] | ( func_ll_rlst_cnt_we & ( func_ll_rlst_cnt_wdata [ 53 : 42 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 24 ] = cfg_control8_f [ 24 ] | ( func_ll_slst_cnt_we & ( func_ll_slst_cnt_wdata [ 11 : 0 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 25 ] = cfg_control8_f [ 25 ] | ( func_ll_slst_cnt_we & ( func_ll_slst_cnt_wdata [ 25 : 14 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 26 ] = cfg_control8_f [ 26 ] | ( func_ll_slst_cnt_we & ( func_ll_slst_cnt_wdata [ 39 : 28 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 27 ] = cfg_control8_f [ 27 ] | ( func_ll_slst_cnt_we & ( func_ll_slst_cnt_wdata [ 53 : 42 ] == 12'd2048 ) ) ;
cfg_control8_nxt [ 28 ] = cfg_control8_f [ 28 ] | ( func_ll_sch_cnt_dup0_we & ( func_ll_sch_cnt_dup0_wdata [ 12 : 0 ] == 13'd4096 ) ) ;

cfg_control8_nxt [ 31 ] = cfg_control8_f [ 31 ]  ;



  //control CFG access. Queue the CFG access until the pipe is idle then issue the reqeust and keep the pipe idle until complete
  cfg_req_ready = cfg_unit_idle_f.cfg_ready ;
  cfg_unit_idle_nxt.cfg_ready                   =  ( ( cfg_unit_idle_nxt.pipe_idle  )
                                                   & ( lsp_ap_idle  )
                                                   ) ;

  // top level ports ,  NOTE: dont use 'hqm_gated_rst_n_active' in "local" ap_unit_idle since LSP turns clocks on, only send indication that PF reset is running
  // hqm_gated_rst_n_active is included into cfg_unit_idle_f.unit_idle to cover gap after hqm_gated_clk is on (from lsp) until PF reset SM starts
  ap_reset_done = ~ ( hqm_gated_rst_n_active ) ;
  ap_unit_idle = cfg_unit_idle_f.unit_idle & ~ ( pf_reset_active_0 | pf_reset_active_1 ) & unit_idle_hqm_clk_inp_gated ;
  ap_unit_pipeidle = cfg_unit_idle_f.pipe_idle ;

  //LSP controls clock for ap & aqed
  // send atm_clk_idle to indicate that hqm_gated_clk pipeline is active or need to turn on clocks for CFG access or RX_SYNC
  atm_clk_idle = cfg_unit_idle_f.unit_idle & ( cfg_rx_idle ) ;





  cfg_interface_nxt                                     = { atm_clk_idle , 11'd0
                                                          , 1'b0 , db_lsp_aqed_cmp_status_pnc [ 2 : 0 ]
                                                          , 1'b0 , db_ap_aqed_status_pnc [ 2 : 0 ]
                                                          , 1'b0 , db_aqed_ap_enq_status_pnc [ 2 : 0 ]
                                                          , 1'b0 , db_ap_lsp_enq_status_pnc [ 2 : 0 ]
                                                          , 1'b0 , db_lsp_ap_atm_status_pnc [ 2 : 0 ]
                                                          } ;

end

always_comb begin : L23

  func_aqed_qid2cqidix_we = '0 ;
  func_aqed_qid2cqidix_wdata = '0 ;
end
assign hqm_proc_clk_en = '0 ;

//tieoff machine inserted code (write rse,cnt) to zero is reported sa 70036
logic tieoff_nc ;
assign tieoff_nc =
//reuse modules inserted by script cannot include _nc
  ( | hqm_ap_target_cfg_syndrome_00_syndrome_data )
| ( | hqm_ap_target_cfg_syndrome_01_syndrome_data )
| ( | pf_ll_enq_cnt_s_bin0_wdata )
| ( | pf_ll_enq_cnt_s_bin0_rdata )
| ( | pf_ll_slst_cnt_wdata )
| ( | pf_ll_slst_cnt_rdata )
| ( | pf_ll_schlst_hp_bin1_rdata )
| ( | pf_ll_sch_cnt_dup3_wdata )
| ( | pf_ll_sch_cnt_dup3_rdata )
| ( | pf_ll_sch_cnt_dup1_wdata )
| ( | pf_ll_sch_cnt_dup1_rdata )
| ( | pf_atm_fifo_ap_aqed_rdata )
| ( | pf_ll_enq_cnt_s_bin3_wdata )
| ( | pf_ll_enq_cnt_s_bin3_rdata )
| ( | pf_ll_schlst_tpprv_bin2_rdata )
| ( | pf_ll_enq_cnt_r_bin3_dup2_wdata )
| ( | pf_ll_enq_cnt_r_bin3_dup2_rdata )
| ( | pf_ll_rdylst_hpnxt_bin2_rdata )
| ( | pf_ll_rdylst_hp_bin0_rdata )
| ( | pf_ll_sch_cnt_dup2_wdata )
| ( | pf_ll_sch_cnt_dup2_rdata )
| ( | pf_ll_rlst_cnt_wdata )
| ( | pf_ll_rlst_cnt_rdata )
| ( | pf_ll_rdylst_tp_bin1_rdata )
| ( | pf_ll_schlst_tp_bin2_rdata )
| ( | pf_ll_schlst_hpnxt_bin2_rdata )
| ( | pf_ll_schlst_hpnxt_bin1_rdata )
| ( | pf_ll_enq_cnt_r_bin2_dup3_wdata )
| ( | pf_ll_enq_cnt_r_bin2_dup3_rdata )
| ( | pf_ll_enq_cnt_r_bin0_dup3_wdata )
| ( | pf_ll_enq_cnt_r_bin0_dup3_rdata )
| ( | pf_ll_schlst_tpprv_bin1_rdata )
| ( | pf_ll_enq_cnt_r_bin1_dup2_wdata )
| ( | pf_ll_enq_cnt_r_bin1_dup2_rdata )
| ( | pf_ll_rdylst_hpnxt_bin3_rdata )
| ( | pf_ll_schlst_tp_bin0_rdata )
| ( | pf_ll_enq_cnt_r_bin0_dup1_wdata )
| ( | pf_ll_enq_cnt_r_bin0_dup1_rdata )
| ( | pf_ll_enq_cnt_r_bin3_dup1_wdata )
| ( | pf_ll_enq_cnt_r_bin3_dup1_rdata )
| ( | pf_ll_schlst_hp_bin2_rdata )
| ( | pf_ll_enq_cnt_r_bin1_dup0_wdata )
| ( | pf_ll_enq_cnt_r_bin1_dup0_rdata )
| ( | pf_ll_enq_cnt_r_bin0_dup0_wdata )
| ( | pf_ll_enq_cnt_r_bin0_dup0_rdata )
| ( | pf_ll_rdylst_hp_bin3_rdata )
| ( | pf_ll_schlst_hpnxt_bin3_rdata )
| ( | pf_ll_schlst_tp_bin1_rdata )
| ( | pf_ll_enq_cnt_s_bin2_wdata )
| ( | pf_ll_enq_cnt_s_bin2_rdata )
| ( | pf_ll_rdylst_tp_bin3_rdata )
| ( | pf_aqed_qid2cqidix_rdata )
| ( | pf_ll_schlst_tp_bin3_rdata )
| ( | pf_ll_schlst_tpprv_bin0_rdata )
| ( | pf_ll_enq_cnt_r_bin0_dup2_wdata )
| ( | pf_ll_enq_cnt_r_bin0_dup2_rdata )
| ( | pf_ll_enq_cnt_r_bin2_dup2_wdata )
| ( | pf_ll_enq_cnt_r_bin2_dup2_rdata )
| ( | pf_ll_schlst_tpprv_bin3_rdata )
| ( | pf_ll_enq_cnt_r_bin1_dup3_wdata )
| ( | pf_ll_enq_cnt_r_bin1_dup3_rdata )
| ( | pf_ll_rdylst_tp_bin0_rdata )
| ( | pf_ll_rdylst_hp_bin1_rdata )
| ( | pf_ll_enq_cnt_r_bin3_dup3_wdata )
| ( | pf_ll_enq_cnt_r_bin3_dup3_rdata )
| ( | pf_ll_schlst_hp_bin0_rdata )
| ( | pf_ll_rdylst_tp_bin2_rdata )
| ( | pf_ll_schlst_hpnxt_bin0_rdata )
| ( | pf_ll_enq_cnt_r_bin1_dup1_wdata )
| ( | pf_ll_enq_cnt_r_bin1_dup1_rdata )
| ( | pf_atm_fifo_aqed_ap_enq_rdata )
| ( | pf_ll_enq_cnt_r_bin2_dup1_wdata )
| ( | pf_ll_enq_cnt_r_bin2_dup1_rdata )
| ( | pf_qid_rdylst_clamp_rdata )
| ( | pf_ll_rdylst_hpnxt_bin1_rdata )
| ( | pf_ll_enq_cnt_r_bin2_dup0_wdata )
| ( | pf_ll_enq_cnt_r_bin2_dup0_rdata )
| ( | pf_ll_enq_cnt_s_bin1_wdata )
| ( | pf_ll_enq_cnt_s_bin1_rdata )
| ( | pf_ll_schlst_hp_bin3_rdata )
| ( | pf_fid2cqqidix_rdata )
| ( | pf_ll_rdylst_hpnxt_bin0_rdata )
| ( | pf_ll_rdylst_hp_bin2_rdata )
| ( | pf_ll_sch_cnt_dup0_wdata )
| ( | pf_ll_sch_cnt_dup0_rdata )
| ( | pf_ll_enq_cnt_r_bin3_dup0_wdata )
| ( | pf_ll_enq_cnt_r_bin3_dup0_rdata )
| ( | cfg_req_read )
| ( | cfg_req_write )
//cannot mark part of struct with _nc for pipe levels it is not used
| ( p4_ll_ctrl [1] )
| ( p0_ll_ctrl [1] )
| ( p1_ll_ctrl [1] )
| ( p2_ll_ctrl [1] )
| ( p5_ll_ctrl [1] )
| ( p6_ll_ctrl [1] )
| ( p0_fid2qidix_ctrl [1] )
| ( p1_fid2qidix_ctrl [1] )
| ( p2_fid2qidix_ctrl [1] )
;

endmodule // hqm_lsp_atm_pipe

