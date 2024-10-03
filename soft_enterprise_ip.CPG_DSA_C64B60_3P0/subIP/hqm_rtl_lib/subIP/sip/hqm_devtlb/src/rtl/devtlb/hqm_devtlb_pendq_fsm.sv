// =============================================================================
// INTEL CONFIDENTIAL
// Copyright 2016 - 2016 Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to the source code ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material remains with Intel Corporation or its suppliers and licensors. The Material contains trade secrets and proprietary and confidential information of Intel or its suppliers and licensors. The Material is protected by worldwide copyright and trade secret laws and treaty provisions. No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted, transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
// No license under any patent, copyright, trade secret or other intellectual property right is granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by implication, inducement, estoppel or otherwise. Any license under such intellectual property rights must be express and approved by Intel in writing.
// =============================================================================

//--------------------------------------------------------------------
//
//  Author   : Khor, Hai Ming
//  Project  : DEVTLB
//  Comments : 
//
//  Functional description:
//
//--------------------------------------------------------------------

`ifndef HQM_DEVTLB_PENDQ_FSM_VS
`define HQM_DEVTLB_PENDQ_FSM_VS

`include "hqm_devtlb_pkg.vh"

module hqm_devtlb_pendq_fsm
import `HQM_DEVTLB_PACKAGE_NAME::*; 
(
    input  logic                PwrDnOvrd_nnnH,
    input  logic                clk,
    input  logic                rst_b,
    input  logic                reset_INST,
    input  logic                fscan_clkungate, 

    //pendq write
    output logic                PendQVacant,
    input  logic                PendQPut,
    input  logic                PendQWakeAtPut,
    input  t_wakeinfo           PendQWakeInfoAtPut,
    input  logic                PendQPop,

    output logic                NxtPendQIdle,
   // output t_pendq_state        pendqps,

    //pendq read  - replay xlat req
    input  logic                Wake, //pulse
    input  t_wakeinfo           WakeInfo,
    
    input  logic                InvEnd,

    // - TLB lookup
    output logic                PendQReqAvail,
    output t_wakeinfo           PendQReqReplayInfo,
    input  logic                PendQReqGet
);

parameter logic NO_POWER_GATING = 1'b0;

//-------------------------------------------------------------------------------
//  state
//-------------------------------------------------------------------------------
t_pendq_state PendQPs, PendQNs;

//-------------------------------------------------------------------------------
//  CLOCKING
//-------------------------------------------------------------------------------
   logic                                            pEn_ClkFsm_H;
   logic                                            ClkFsm_H;

always_comb begin
    pEn_ClkFsm_H = (~rst_b) || PendQPut || (PendQPs!=PENDQIDLE);
end
`HQM_DEVTLB_MAKE_LCB_PWR(ClkFsm_H,  clk, pEn_ClkFsm_H,  PwrDnOvrd_nnnH)

always_comb begin
    PendQNs = PendQPs;
    case (PendQPs)
    PENDQIDLE:
        if(PendQPut && ~PendQWakeAtPut)         PendQNs = PENDQARSP;
        else if(PendQPut &&  PendQWakeAtPut)    PendQNs = PENDQXREQI;
    PENDQARSP:
        if(Wake) PendQNs = PENDQXREQI;
    PENDQXREQI:
        if(PendQReqGet) PendQNs = PENDQXREQE;
    PENDQXREQE: // this state is needed to ensure pendq entry retired after RdEn. HSD22010222500
        if(PendQPop)    PendQNs = PENDQIDLE;
    default: ;
    endcase
end

logic ClrWakeInfo, sampleWake;
t_wakeinfo NxtReplayInfo;
always_comb begin
    //pendqps = PendQPs;
    NxtPendQIdle  = (PendQNs==PENDQIDLE);
    PendQVacant   = (PendQPs==PENDQIDLE);
    PendQReqAvail = (PendQPs==PENDQXREQI);
    
    sampleWake    = (PendQPs==PENDQARSP)? Wake: PendQPut;
    ClrWakeInfo   = InvEnd;
    NxtReplayInfo = (PendQPs==PENDQARSP)? WakeInfo: PendQWakeInfoAtPut;
    if (ClrWakeInfo) NxtReplayInfo.ForceXRsp = '0;
    //if (ClrWakeInfo) NxtReplayInfo.PrsCode   = '0;
end

`HQM_DEVTLB_RSTD_MSFF(PendQPs, PendQNs, ClkFsm_H, ~rst_b, PENDQIDLE)
`HQM_DEVTLB_EN_MSFF(PendQReqReplayInfo.ForceXRsp, NxtReplayInfo.ForceXRsp , ClkFsm_H, (sampleWake||ClrWakeInfo)) // InvMsTrkEnd to clr it, 
`HQM_DEVTLB_EN_MSFF(PendQReqReplayInfo.PrsCode, NxtReplayInfo.PrsCode , ClkFsm_H, (sampleWake/*||ClrWakeInfo*/))  
`HQM_DEVTLB_EN_MSFF(PendQReqReplayInfo.DPErr, NxtReplayInfo.DPErr , ClkFsm_H, (sampleWake))
`HQM_DEVTLB_EN_MSFF(PendQReqReplayInfo.HdrErr, NxtReplayInfo.HdrErr , ClkFsm_H, (sampleWake))

`ifndef HQM_DEVTLB_SVA_OFF
`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQFSM_InvEnd_OutstandingReplay,
   (InvEnd),
   ((PendQPs==PENDQXREQI) || (PendQPs==PENDQXREQE)),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQFSM_Wake_AfterWakeAtPut,
   (Wake),
   ((PendQPs==PENDQXREQI) || (PendQPs==PENDQXREQE)),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQFSM_Wake_PsNotIdle,
   (Wake),
   ($fell(PendQPop) || ~(PendQPs==PENDQIDLE)),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQFSM_Input_mutex,
   (|{PendQPut, PendQPop, PendQReqGet}),
   ($onehot({PendQPut, PendQPop, PendQReqGet})),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQFSM_Put_Idle,
   (PendQPut),
   (PendQPs==PENDQIDLE),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQFSM_ReqGet_ReqAvail,
   (PendQReqGet),
   (PendQPs==PENDQXREQI),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`endif //DEVTLB_SVA_OFF
endmodule

`endif // IOMMU_PENDQ_FSM_VS
