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
// hqm_lsp_cq_sel
//
// List Select Pipe load-balanced CQ arbitration logic.  Modularized because same equations are needed
// for p0 and p0 next.  p0 next is needed for functional reasons, feeding into the pipelined arbiter, and
// p0 is needed for p1 pipeline "blasted" vectors and smon - reduce loading on timing-critical arbiter
// requests.

module hqm_lsp_cq_sel
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
   parameter HQM_NUM_LB_CQ = 32
,  parameter HQM_QID_PER_CQ = 8
,  parameter HQM_NUM_CQ_QID = HQM_NUM_LB_CQ * HQM_QID_PER_CQ 
) (
  input  logic                          cfg_control_atm_cq_qid_priority_prot
, input  logic [HQM_NUM_LB_CQ-1:0]      cfg_cq_ldb_disable_f
, input  logic [HQM_NUM_CQ_QID-1:0]     slist_v
, input  logic [HQM_NUM_CQ_QID-1:0]     rlist_v
, input  logic [HQM_NUM_CQ_QID-1:0]     nalb_v
, input  logic [HQM_NUM_CQ_QID-1:0]     slist_blast
, input  logic [HQM_NUM_CQ_QID-1:0]     rlist_blast
, input  logic [HQM_NUM_CQ_QID-1:0]     nalb_blast
, input  logic [HQM_NUM_CQ_QID-1:0]     cmpblast
, input  logic [HQM_NUM_CQ_QID-1:0]     atm_if_v
, input  logic [HQM_NUM_LB_CQ-1:0]      cq_has_space
, input  logic [HQM_NUM_LB_CQ-1:0]      cq_busy_sch
, input  logic [HQM_NUM_LB_CQ-1:0]      cq_ow

, output logic [HQM_NUM_CQ_QID-1:0]     slist_v_blasted
, output logic [HQM_NUM_CQ_QID-1:0]     rlist_v_blasted
, output logic [HQM_NUM_CQ_QID-1:0]     nalb_v_blasted
, output logic [HQM_NUM_LB_CQ-1:0]      slist_has_work
, output logic [HQM_NUM_LB_CQ-1:0]      rlist_has_work
, output logic [HQM_NUM_LB_CQ-1:0]      nalb_has_work
, output logic [HQM_NUM_LB_CQ-1:0]      any_has_work
, output logic [HQM_NUM_LB_CQ-1:0]      cq_arb_reqs
) ;

//-----------------------------------------------------------------------------------------------------
// Create the per-CQ vectors for arbitration

// All types of scheduling must be supressed for a CQ which does not have space; space is shared.
// For cqidix vectors OK to just OR all 8 bits; individual ix will be selected below by looking at
// individual bits.

// A given CQ is eligible if any of its 8 qidix's has v=1 and blast=0.
// For slist, depending on mode bit, for a given CQ, if any of its 8 blast bits are 1, that CQ is ineligible.
always_comb begin
  for ( int i = 0 ; i < HQM_NUM_LB_CQ ; i = i + 1 ) begin
    if ( cfg_control_atm_cq_qid_priority_prot ) begin
      slist_v_blasted [ ( HQM_QID_PER_CQ * i ) +: HQM_QID_PER_CQ ]        = slist_v [ ( HQM_QID_PER_CQ * i ) +: HQM_QID_PER_CQ ] &
                                                  atm_if_v [ ( HQM_QID_PER_CQ * i ) +: HQM_QID_PER_CQ ] &
                                                  ~ { HQM_QID_PER_CQ { ( | ( slist_blast [ ( HQM_QID_PER_CQ * i ) +: HQM_QID_PER_CQ ] ) ) } } ;
    end
    else begin
      slist_v_blasted                           = slist_v & atm_if_v & ~ slist_blast ;
    end
  end // for
end //
assign rlist_v_blasted  = rlist_v & atm_if_v & ~ rlist_blast & ~cmpblast ;
assign nalb_v_blasted   = nalb_v  & ~ nalb_blast ;              // nalb already has if_v included in "has_work" input

always_comb begin
  for ( int i = 0 ; i < HQM_NUM_LB_CQ ; i = i + 1 ) begin
    slist_has_work [i]  = | ( slist_v_blasted [ ( HQM_QID_PER_CQ * i ) +: HQM_QID_PER_CQ ] ) ;
    rlist_has_work [i]  = | ( rlist_v_blasted [ ( HQM_QID_PER_CQ * i ) +: HQM_QID_PER_CQ ] ) ;
    nalb_has_work [i]   = | ( nalb_v_blasted  [ ( HQM_QID_PER_CQ * i ) +: HQM_QID_PER_CQ ] ) ;
  end // for
end //

assign any_has_work     = slist_has_work | rlist_has_work | nalb_has_work ;                                     // Bitwise
assign cq_arb_reqs      = any_has_work & cq_has_space & ~ cq_busy_sch & ~ cq_ow & ~ cfg_cq_ldb_disable_f ;      // Bitwise

endmodule // hqm_lsp_cq_sel
