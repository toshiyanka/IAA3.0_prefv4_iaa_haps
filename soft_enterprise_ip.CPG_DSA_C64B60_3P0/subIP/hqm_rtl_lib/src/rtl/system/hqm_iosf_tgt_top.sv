// cct.20150909 from PCIE3201509090088BEKB0.tar drop
//----------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intels prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------
//
//  $Id: cxt_iosf_tgt_top.sv,v 1.82 2014/05/21 23:20:28 albion Exp $
//
//  PROJECT : CCT-PCIE3
//  DATE    : $Date: 2014/05/21 23:20:28 $
//
//  Functional description:
//  PCIE IOSF Primary Channel Target
//
//----------------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_iosf_tgt_top

     import hqm_sif_pkg::*, hqm_sif_csr_pkg::*, hqm_system_type_pkg::*;
#(
     parameter bit TCRD_BYPASS       = 0
    ,parameter int D_WIDTH           = 255 // Primary Channel Databus Width
    ,parameter int PORTS             = 4
    ,parameter int VC                = 1
    ,parameter int MAX_LEN           = 63
    ,parameter int TX_PRH            = 6
    ,parameter int TX_NPRH           = 4
    ,parameter int TX_CPLH           = 6
    ,parameter int TX_PRD            = 30
    ,parameter int TX_NPRD           = 4
    ,parameter int TX_CPLD           = 30
    ,parameter int IOSF_TGT_STAGE2   = 1  // Enable flopping of IOSF interface signals before writing into the RFs.
    ,parameter bit TGT_CMDPARCHK_DIS = 0
    ,parameter bit TGT_DATPARCHK_DIS = 0
    ,parameter int GEN_ECRC          = 0
    ,parameter int DROP_ECRC         = 1
) (
    //-----------------------------------------------------------------------------
    // IOSF Target Clocks and Resets

     input  logic                                   prim_nonflr_clk
    ,input  logic                                   prim_gated_rst_b

    ,input  logic [2:0]                             prim_ism_agent

    ,input  logic                                   credit_init

    //-----------------------------------------------------------------------------
    // EP Credit bypass

    ,input  logic [7:0]                             ep_nprdcredits_sw_rxl
    ,input  logic [7:0]                             ep_nprhcredits_sw_rxl
    ,input  logic [7:0]                             ep_prdcredits_sw_rxl
    ,input  logic [7:0]                             ep_prhcredits_sw_rxl
    ,input  logic [7:0]                             ep_cpldcredits_sw_rxl
    ,input  logic [7:0]                             ep_cplhcredits_sw_rxl

    ,output new_TGT_INIT_HCREDITS_t                 tgt_init_hcredits
    ,output new_TGT_INIT_DCREDITS_t                 tgt_init_dcredits
    ,output new_TGT_REM_HCREDITS_t                  tgt_rem_hcredits
    ,output new_TGT_REM_DCREDITS_t                  tgt_rem_dcredits
    ,output new_TGT_RET_HCREDITS_t                  tgt_ret_hcredits
    ,output new_TGT_RET_DCREDITS_t                  tgt_ret_dcredits

    //-----------------------------------------------------------------------------
    // IOSF Target Interface to Fabric

    // Target Control Interface

    ,input  hqm_iosf_tgt_cput_t                     iosf_tgt_cput
    ,output hqm_iosf_tgt_credit_t                   iosf_tgt_credit

    ,input  logic                                   tdec 
    ,output logic [(VC*PORTS)-1:0]                  hit

    // Target Command Interface

    ,input hqm_iosf_tgt_cmd_t                       iosf_tgt_cmd

    // Target Data Interface

    ,input hqm_iosf_tgt_data_t                      iosf_tgt_data

    //-----------------------------------------------------------------------------
    // Credit updates

    ,input hqm_iosf_tgt_crd_t                       iosf_tgt_crd_dec
    ,input hqm_iosf_tgt_crd_t                       ri_tgt_crd_inc

    //-----------------------------------------------------------------------------
    // Flags to GCGU

    ,output logic                                   credit_init_done
    ,output logic                                   tgt_has_unret_credits

    //-----------------------------------------------------------------------------
    // Data, Header and Pointer Information to Queues

    ,output hqm_iosf_tgtq_cmddata_t                 iosf_tgtq_cmddata
    ,output hqm_iosf_tgtq_hdrbits_t                 iosf_tgtq_hdrbits

    //-----------------------------------------------------------------------------
    // Master grant signals

    ,input hqm_iosf_gnt_t                           mstr_iosf_gnt

    //-----------------------------------------------------------------------------
    // Clock Gating Signals

    ,output logic                                   tgt_idle

    //-----------------------------------------------------------------------------
    // Debug

    ,output logic [31:0]                            noa_tgt
);

//---------------------------------------------------------------------------------

logic                           credit_init_in_progress;
logic                           tgt_cntrl_idle;

hqm_iosf_tgt_cput_t             iosf_tgt_cput_q;
hqm_iosf_tgt_cmd_t              iosf_tgt_cmd_q;
hqm_iosf_tgt_data_t             iosf_tgt_data_q;

logic                           tdec_nc;

assign tdec_nc = tdec;

//=================================================================================

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_tgt_cput_q <= '0;
 end else if (|prim_ism_agent) begin
  iosf_tgt_cput_q <= iosf_tgt_cput;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
 if (|prim_ism_agent) begin
  iosf_tgt_cmd_q  <= iosf_tgt_cmd;
  iosf_tgt_data_q <= iosf_tgt_data;
 end
end

assign tgt_idle = tgt_cntrl_idle & ~iosf_tgt_credit.credit_put & ~iosf_tgt_cput.cmd_put &
                    ~tgt_has_unret_credits;

//=====================================================================================
//  Module Instantiations
//=====================================================================================

hqm_iosf_tgt_crdt # (

     .TCRD_BYPASS                   (TCRD_BYPASS)
    ,.PORTS                         (PORTS)
    ,.VC                            (VC)
    ,.TX_PRH                        (TX_PRH)
    ,.TX_NPRH                       (TX_NPRH)
    ,.TX_CPLH                       (TX_CPLH)
    ,.TX_PRD                        (TX_PRD)
    ,.TX_NPRD                       (TX_NPRD)
    ,.TX_CPLD                       (TX_CPLD)

) hqm_iosf_tgt_crdt (

     .prim_nonflr_clk               (prim_nonflr_clk)
    ,.prim_gated_rst_b              (prim_gated_rst_b)

    ,.prim_ism_agent                (prim_ism_agent)

    ,.ep_nprdcredits_sw_rxl         (ep_nprdcredits_sw_rxl)
    ,.ep_nprhcredits_sw_rxl         (ep_nprhcredits_sw_rxl)
    ,.ep_prdcredits_sw_rxl          (ep_prdcredits_sw_rxl)
    ,.ep_prhcredits_sw_rxl          (ep_prhcredits_sw_rxl)
    ,.ep_cpldcredits_sw_rxl         (ep_cpldcredits_sw_rxl)
    ,.ep_cplhcredits_sw_rxl         (ep_cplhcredits_sw_rxl)

    ,.credit_init                   (credit_init)

    ,.credit_init_done              (credit_init_done)
    ,.credit_init_in_progress       (credit_init_in_progress)

    ,.tgt_has_unret_credits         (tgt_has_unret_credits)

    ,.iosf_tgt_crd_dec              (iosf_tgt_crd_dec)
    ,.ri_tgt_crd_inc                (ri_tgt_crd_inc)

    ,.iosf_tgt_credit               (iosf_tgt_credit)

    ,.noa_tgtcrdt                   (noa_tgt[7:0])

    ,.tgt_init_hcredits             (tgt_init_hcredits)
    ,.tgt_init_dcredits             (tgt_init_dcredits)
    ,.tgt_rem_hcredits              (tgt_rem_hcredits)
    ,.tgt_rem_dcredits              (tgt_rem_dcredits)
    ,.tgt_ret_hcredits              (tgt_ret_hcredits)
    ,.tgt_ret_dcredits              (tgt_ret_dcredits)
);

hqm_iosf_tgt_cntrl  # (

     .D_WIDTH                       (D_WIDTH)
    ,.PORTS                         (PORTS)
    ,.VC                            (VC)
    ,.MAX_LEN                       (MAX_LEN)
    ,.PBG_TIMING                    (IOSF_TGT_STAGE2)
    ,.TGT_CMDPARCHK_DIS             (TGT_CMDPARCHK_DIS)
    ,.TGT_DATPARCHK_DIS             (TGT_DATPARCHK_DIS)
    ,.GEN_ECRC                      (GEN_ECRC)
    ,.DROP_ECRC                     (DROP_ECRC)

) hqm_iosf_tgt_cntrl (

     .prim_nonflr_clk               (prim_nonflr_clk)
    ,.prim_gated_rst_b              (prim_gated_rst_b)

    ,.prim_ism_agent                (prim_ism_agent)

    ,.iosf_tgt_cput                 (iosf_tgt_cput_q)
    ,.iosf_tgt_cmd                  (iosf_tgt_cmd_q)
    ,.iosf_tgt_data                 (iosf_tgt_data_q)

    ,.iosf_tgtq_cmddata             (iosf_tgtq_cmddata)
    ,.iosf_tgtq_hdrbits             (iosf_tgtq_hdrbits)

    ,.credit_init_in_progress       (credit_init_in_progress)

    ,.tgt_idle                      (tgt_cntrl_idle)

    ,.mstr_iosf_gnt                 (mstr_iosf_gnt)

    ,.noa_tgtcntrl                  (noa_tgt[31:8])
);

always_comb begin
 hit = '0;
end

endmodule

