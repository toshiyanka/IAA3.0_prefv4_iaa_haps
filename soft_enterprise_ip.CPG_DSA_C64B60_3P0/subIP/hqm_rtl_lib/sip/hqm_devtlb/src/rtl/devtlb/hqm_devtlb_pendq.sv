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

`ifndef HQM_DEVTLB_PENDQ_VS
`define HQM_DEVTLB_PENDQ_VS

`include "hqm_devtlb_pkg.vh"
`include "hqm_devtlb_rrarb.sv"
`include "hqm_devtlb_pendq_fsm.sv"

module hqm_devtlb_pendq
import `HQM_DEVTLB_PACKAGE_NAME::*; 
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter type T_REQ = logic, //t_devtlb_request,
    parameter int XREQ_PORTNUM = 1,
    parameter int PENDQ_DEPTH = 128,
    parameter int MISSTRK_DEPTH = 128,
    localparam int MISSTRK_IDW = $clog2(MISSTRK_DEPTH),
    localparam int PENDQ_IDW = $clog2(PENDQ_DEPTH)
) (
    input  logic                            PwrDnOvrd_nnnH,
    input  logic                            clk,
    input  logic                            reset,
    input  logic                            reset_INST,
    input  logic                            fscan_clkungate,

    output logic                            PendQWrEn,
    output logic [PENDQ_IDW-1:0]            PendQWrAddr,
    output T_REQ                            PendQWrData,

    output logic                            PendQRdEn,
    output logic [PENDQ_IDW-1:0]            PendQRdAddr,
    input  T_REQ                            PendQRdData,
    input  logic                            PendQPerr,

    //MsTRK status
    output logic                            PendQFull,
    output logic                            PendQEmpty,

    //Filling PendQ
    output logic [PENDQ_DEPTH-1:0]          PendQVacant,
    input  logic                            PendQPut,
    input  logic [PENDQ_IDW-1:0]            PendQIdx,
    input  T_REQ                            PendQReq,
    input  logic                            PendQWakeAtPut,
    input  t_wakeinfo                       PendQWakeInfoAtPut,
    input  logic [MISSTRK_IDW-1:0]          PendQMsHitIdx,
    
    //pendq read - Wake
    input  logic                            PendQWake,
    input  logic [MISSTRK_IDW-1:0]          PendQWakeMsTrkId,
    input  t_wakeinfo                       PendQWakeInfo,
    output logic                            PendQCrdRet,
    
    input  logic                            InvMsTrkEnd,
    
    output logic [XREQ_PORTNUM-1:0]         PendQPipeV_100H,
    output logic [XREQ_PORTNUM-1:0]         PendQForceXRsp_100H,
    output logic [XREQ_PORTNUM-1:0]         PendQDPErr_100H,
    output logic [XREQ_PORTNUM-1:0]         PendQHdrErr_100H,
    output logic [XREQ_PORTNUM-1:0][1:0]    PendQPrsCode_100H,
    output T_REQ [XREQ_PORTNUM-1:0]         PendQReq_100H,
    input  logic [XREQ_PORTNUM-1:0]         PendQGnt_100H

);

localparam int XREQ_PORTID = (XREQ_PORTNUM>1)?$clog2(XREQ_PORTNUM):1;

//Pipe Stages for waking up pendq entry
localparam int WAKECAMCTL = 0;
localparam int WAKECAMRET = WAKECAMCTL + 1;

//Pipe Stages for replaying xreq
localparam int XREQARB = 0;
localparam int XREQRDCTL = XREQARB + 1;
localparam int XREQRDRET = XREQRDCTL + 1;
localparam int XREQOUT   = XREQRDRET + 1;
 
genvar g_stage;
genvar g_entry;

//-------------------------------------------------------------------------------
// Global signals.
logic [PENDQ_DEPTH-1:0]            PendQPut_i, pendq_pop_i;

//-------------------------------------------------------------------------------
//  CLOCKING
//-------------------------------------------------------------------------------
   logic                                   pEn_ClkPendQ_H;
   logic                                   ClkPendQ_H;

always_comb begin
    pEn_ClkPendQ_H = reset || PendQPut || PendQWake || (|(PendQPipeV_100H & PendQGnt_100H)) || (~&PendQVacant);
end
`HQM_DEVTLB_MAKE_LCB_PWR(ClkPendQ_H,  clk, pEn_ClkPendQ_H,  PwrDnOvrd_nnnH)

   logic [XREQOUT-1:XREQARB  ]             pEn_ClkXReqPipe_H;
   logic [XREQOUT  :XREQARB+1]             ClkXReqPipe_H;

generate
for (g_stage = XREQARB+1; g_stage <= XREQOUT; g_stage++) begin  : gen_ClkXReqPipe
         `HQM_DEVTLB_MAKE_LCB_PWR(ClkXReqPipe_H[g_stage],  clk, pEn_ClkXReqPipe_H[g_stage-1],  PwrDnOvrd_nnnH)
end
endgenerate

   logic [WAKECAMRET-1:WAKECAMCTL  ]             pEn_ClkWakePipe_H;
   logic [WAKECAMRET  :WAKECAMCTL+1]             ClkWakePipe_H;

generate
for (g_stage = WAKECAMCTL+1; g_stage <= WAKECAMRET; g_stage++) begin  : gen_ClkWakePipe
         `HQM_DEVTLB_MAKE_LCB_PWR(ClkWakePipe_H[g_stage],  clk, pEn_ClkWakePipe_H[g_stage-1],  PwrDnOvrd_nnnH)
end
endgenerate

//------------------------------------------------------------------------------
// Data structure of each PendQ entry:
// 1. pendq_fsm, FSM state
// 2. mstrk_idx
// 3. PendQReq

//-------------------------------------------------------------------------------
// PendQ Memory WEN (only from south, due to ATS Req input)
always_comb begin
    PendQWrEn   = PendQPut && ~reset;
    PendQWrAddr = PendQIdx;
    PendQWrData = PendQReq;
//`ifndef DEVTLB_SVA_OFF
    //Only used for SVA
//    PendQWrData.MsTrkIdx = PendQMsHitIdx;
//`endif
end
logic [PENDQ_DEPTH-1:0][MISSTRK_IDW-1:0] pendq_mstrk_idx;

generate
for (g_entry=0; g_entry<PENDQ_DEPTH; g_entry++) begin : gen_mstrk_idx
    `HQM_DEVTLB_EN_MSFF(pendq_mstrk_idx[g_entry], PendQMsHitIdx, ClkPendQ_H, PendQPut_i[g_entry])
end
endgenerate

//-------------------------------------------------------------------------------
//PipeLine to wake pendq entry
//signals going thru the pipe
logic                              WakePipeStall;
logic [WAKECAMRET:WAKECAMCTL]      WakePipeV;
t_wakeinfo [WAKECAMRET:WAKECAMCTL]                 WakePipeInfo;
logic [WAKECAMCTL:WAKECAMCTL]                      PendQCamEn;
logic [WAKECAMCTL:WAKECAMCTL][MISSTRK_IDW-1:0]     PendQCamData;
logic [WAKECAMRET:WAKECAMCTL][PENDQ_DEPTH-1:0]     PendQCamHit;

//clk contrl
always_comb begin
    for (int i=WAKECAMCTL+1; i<= WAKECAMRET; i++) begin
        pEn_ClkWakePipe_H[i-1]  = reset
                                 | WakePipeV[i-1] | WakePipeV[i];
    end
end

always_comb WakePipeStall = '0; //never stall

//Storage for WAKECAMCTL++ stages
generate
for (g_stage=WAKECAMCTL+1; g_stage<=WAKECAMRET; g_stage++) begin : gen_WakePipeV
    `HQM_DEVTLB_EN_RST_MSFF(WakePipeV[g_stage],WakePipeV[g_stage-1],ClkWakePipe_H[g_stage],~WakePipeStall,reset)
    `HQM_DEVTLB_EN_MSFF(PendQCamHit[g_stage],PendQCamHit[g_stage-1],ClkWakePipe_H[g_stage],~WakePipeStall)
    `HQM_DEVTLB_EN_MSFF(WakePipeInfo[g_stage],WakePipeInfo[g_stage-1],ClkWakePipe_H[g_stage],~WakePipeStall)
end
endgenerate

//WAKECAMCTL

always_comb begin
    WakePipeV[WAKECAMCTL] = PendQWake; // WakePipeStall always 0 
    WakePipeInfo[WAKECAMCTL] = PendQWakeInfo;

    PendQCamEn[WAKECAMCTL] = WakePipeV[WAKECAMCTL] && ~WakePipeStall;
    PendQCamData[WAKECAMCTL] = PendQWakeMsTrkId;
end
// see wake_i
always_comb begin
    for (int i=0; i<PENDQ_DEPTH; i++) begin
        PendQCamHit[WAKECAMCTL][i] = (~PendQVacant[i]) && (PendQCamData[WAKECAMCTL] == pendq_mstrk_idx[i]);
    end
end
    
//WAKECAMRET
//-------------------------------------------------------------------------------
//Pipeline for replaying xreq
//signals going thru the pipe
logic                                       XReqPipeStall;
logic [XREQOUT:XREQARB]                     XReqPipeV;
logic [XREQOUT:XREQARB][PENDQ_IDW-1:0]      XReqPipePendQId;

//clk contrl
always_comb begin
    for (int i=XREQARB+1; i<= XREQOUT; i++) begin
        pEn_ClkXReqPipe_H[i-1]  = reset
                                 | XReqPipeV[i-1] | XReqPipeV[i];
    end
end

always_comb XReqPipeStall = |(PendQPipeV_100H & ~PendQGnt_100H);

//Storage for XREQARB++ stages
generate
for (g_stage=XREQARB+1; g_stage<=XREQOUT; g_stage++) begin : gen_XReqPipeV
    `HQM_DEVTLB_EN_RST_MSFF(XReqPipeV[g_stage],XReqPipeV[g_stage-1],ClkXReqPipe_H[g_stage],~XReqPipeStall,reset)
    `HQM_DEVTLB_EN_RST_MSFF(XReqPipePendQId[g_stage],XReqPipePendQId[g_stage-1],ClkXReqPipe_H[g_stage],~XReqPipeStall,reset)
end
endgenerate

//XREQARB, arbitrate xreq for RF ren
logic arb_XReqPipeV;
logic [PENDQ_DEPTH-1:0]  PendQReqAvail, PendQReqGet;

hqm_devtlb_rrarb #(.REQ_W (PENDQ_DEPTH), .REQ_IDW (PENDQ_IDW))
   rr_xreq_arb (.clk (ClkXReqPipe_H[XREQARB+1]), .rst_b (~reset), .arb_rs (~XReqPipeStall), .arb_req (PendQReqAvail), .arb_gnt (arb_XReqPipeV), .arb_gntid (XReqPipePendQId[XREQARB]));

always_comb begin
     XReqPipeV[XREQARB] = arb_XReqPipeV;
end

//XREQRDCTL
//MSTRK RF ACCESS
logic [XREQRDRET:XREQRDCTL]  PendQRenAck, RdForceXRsp, RdDPErr, RdHdrErr;
logic [XREQRDRET:XREQRDCTL][1:0]  RdPrsCode;
t_wakeinfo [PENDQ_DEPTH-1:0] PendQReqReplayInfo;
always_comb begin
    PendQRdEn = XReqPipeV[XREQRDCTL] && ~XReqPipeStall && ~reset; 
    PendQRdAddr = XReqPipePendQId[XREQRDCTL];
    PendQRenAck[XREQRDCTL] = PendQRdEn;
    PendQCrdRet = PendQRdEn;
    
    RdForceXRsp[XREQRDCTL] = PendQReqReplayInfo[PendQRdAddr].ForceXRsp;
    RdPrsCode[XREQRDCTL]   = PendQReqReplayInfo[PendQRdAddr].PrsCode;
    RdHdrErr[XREQRDCTL]    = PendQReqReplayInfo[PendQRdAddr].HdrErr;
    RdDPErr[XREQRDCTL]     = PendQReqReplayInfo[PendQRdAddr].DPErr;
end
generate
for (g_stage=XREQRDCTL+1; g_stage<=XREQRDRET; g_stage++) begin : gen_XReqRen
    `HQM_DEVTLB_RST_MSFF(PendQRenAck[g_stage],PendQRenAck[g_stage-1],ClkXReqPipe_H[g_stage],reset)
    `HQM_DEVTLB_MSFF(RdForceXRsp[g_stage],(RdForceXRsp[g_stage-1] && ~InvMsTrkEnd),ClkXReqPipe_H[g_stage]) //InvMsTrkEnd Invalides ForceXRsp
    `HQM_DEVTLB_MSFF(RdPrsCode[g_stage],RdPrsCode[g_stage-1],ClkXReqPipe_H[g_stage]) //InvMsTrkEnd Invalides ForceXRsp
    `HQM_DEVTLB_MSFF(RdHdrErr[g_stage],(RdHdrErr[g_stage-1]),ClkXReqPipe_H[g_stage])
    `HQM_DEVTLB_MSFF(RdDPErr[g_stage],(RdDPErr[g_stage-1]),ClkXReqPipe_H[g_stage])
end
endgenerate

//XREQRDRET
T_REQ                         PendQSaved;
logic                         ForceXRspSaved, DPErrSaved, HdrErrSaved; 
logic [1:0]                   PrsCodeSaved; 
T_REQ [XREQOUT:XREQRDRET]     XReqPendQRdData;
logic [XREQOUT:XREQRDRET]     ForceXRsp, DPErr, HdrErr; 
logic [XREQOUT:XREQRDRET][1:0] PrsCode; 
always_comb begin
    XReqPendQRdData[XREQRDRET] = PendQRenAck[XREQRDRET]? PendQRdData: PendQSaved;
    ForceXRsp[XREQRDRET] = PendQRenAck[XREQRDRET]? (RdForceXRsp[XREQRDRET] && ~InvMsTrkEnd): ForceXRspSaved;
    PrsCode[XREQRDRET]   = PendQRenAck[XREQRDRET]? RdPrsCode[XREQRDRET]: PrsCodeSaved;
    DPErr[XREQRDRET]     = PendQRenAck[XREQRDRET]? (RdDPErr[XREQRDRET]): DPErrSaved;
    HdrErr[XREQRDRET]    = PendQRenAck[XREQRDRET]? (RdHdrErr[XREQRDRET]): HdrErrSaved;
    //TODO PendQ array PERR
end
`HQM_DEVTLB_EN_MSFF(PendQSaved,PendQRdData,ClkXReqPipe_H[XREQRDRET+1],PendQRenAck[XREQRDRET])
`HQM_DEVTLB_EN_MSFF(ForceXRspSaved,(RdForceXRsp[XREQRDRET] && ~InvMsTrkEnd),ClkXReqPipe_H[XREQRDRET+1],(InvMsTrkEnd || PendQRenAck[XREQRDRET]))
`HQM_DEVTLB_EN_MSFF(PrsCodeSaved,RdPrsCode[XREQRDRET],ClkXReqPipe_H[XREQRDRET+1],(PendQRenAck[XREQRDRET]))
`HQM_DEVTLB_EN_MSFF(DPErrSaved,(RdDPErr[XREQRDRET]),ClkXReqPipe_H[XREQRDRET+1],(PendQRenAck[XREQRDRET]))
`HQM_DEVTLB_EN_MSFF(HdrErrSaved,(RdHdrErr[XREQRDRET]),ClkXReqPipe_H[XREQRDRET+1],(PendQRenAck[XREQRDRET]))

//XREQRDRET++
generate
for (g_stage=XREQRDRET+1; g_stage<=XREQOUT; g_stage++) begin: gen_XReqData
    `HQM_DEVTLB_EN_MSFF(XReqPendQRdData[g_stage],XReqPendQRdData[g_stage-1],ClkXReqPipe_H[g_stage],~XReqPipeStall)
    `HQM_DEVTLB_EN_MSFF(ForceXRsp[g_stage],(ForceXRsp[g_stage-1] && ~InvMsTrkEnd),ClkXReqPipe_H[g_stage],(InvMsTrkEnd || ~XReqPipeStall))
    `HQM_DEVTLB_EN_MSFF(PrsCode[g_stage],PrsCode[g_stage-1],ClkXReqPipe_H[g_stage],(~XReqPipeStall))
    `HQM_DEVTLB_EN_MSFF(DPErr[g_stage],(DPErr[g_stage-1]),ClkXReqPipe_H[g_stage],(~XReqPipeStall))
    `HQM_DEVTLB_EN_MSFF(HdrErr[g_stage],(HdrErr[g_stage-1]),ClkXReqPipe_H[g_stage],(~XReqPipeStall))
end
endgenerate

//XREQOUT

always_comb begin
    for (int i=0; i<XREQ_PORTNUM; i++) begin
        PendQPipeV_100H[i] = XReqPipeV[XREQOUT] && (i[XREQ_PORTID-1:0]== XReqPendQRdData[XREQOUT].PortId); //XReqPipeStall not needed
        PendQReq_100H[i] = XReqPendQRdData[XREQOUT];
        PendQForceXRsp_100H[i] = ForceXRsp[XREQOUT]; //InvMsTrkEnd is not needed here because of InvBlock
        PendQPrsCode_100H[i]   = XReqPendQRdData[XREQOUT].Prs? PrsCode[XREQOUT]: '0; //InvMsTrkEnd is not needed here because of InvBlock
        PendQDPErr_100H[i] = DPErr[XREQOUT];
        PendQHdrErr_100H[i] = HdrErr[XREQOUT];
    end
end

//---------------------------------------------------------------------------------------------------------
//PendQ FSM
logic [PENDQ_DEPTH-1:0]                          wake_i, NxtPendQIdle;
logic                                            nxt_pendq_full_i;

t_wakeinfo                                       WakeInfo;
 

always_comb begin
    nxt_pendq_full_i = '0;
    for (int i=0; i<PENDQ_DEPTH; i++) begin
        nxt_pendq_full_i |= NxtPendQIdle[i];
        PendQPut_i[i]  = PendQPut && (i[PENDQ_IDW-1:0] == PendQIdx);
        wake_i[i]       = WakePipeV[WAKECAMRET] && PendQCamHit[WAKECAMRET][i] && ~WakePipeStall; //WakePipeStall always 0
        PendQReqGet[i] = XReqPipeV[XREQARB] && (i[PENDQ_IDW-1:0] == XReqPipePendQId[XREQARB]);
        pendq_pop_i[i]    = PendQRdEn && (i[PENDQ_IDW-1:0]==PendQRdAddr);
    end
    nxt_pendq_full_i = ~nxt_pendq_full_i;
    
    WakeInfo      = WakePipeInfo[WAKECAMRET];
end

generate
    for (genvar i=0; i<PENDQ_DEPTH; i++) begin : gen_pendq_fsm
        hqm_devtlb_pendq_fsm
        #(
            .NO_POWER_GATING(NO_POWER_GATING)
        ) pendq_fsm (
            .PwrDnOvrd_nnnH,
            .clk,
            .rst_b (~reset),
            .reset_INST(reset_INST),
            .fscan_clkungate(fscan_clkungate),
            .NxtPendQIdle(NxtPendQIdle[i]),

            //mstrk write
            .PendQVacant(PendQVacant[i]),
            .PendQPut(PendQPut_i[i]),
            .PendQWakeAtPut(PendQWakeAtPut),
            .PendQWakeInfoAtPut(PendQWakeInfoAtPut),
            //pendq read 1 - XLat Req to TLB
            .Wake(wake_i[i]), //pulse
            .WakeInfo(WakeInfo),
            .InvEnd(InvMsTrkEnd),
            //TLB lookup
            .PendQReqAvail(PendQReqAvail[i]),
            .PendQReqReplayInfo(PendQReqReplayInfo[i]),
            .PendQReqGet(PendQReqGet[i]),
            
            .PendQPop(pendq_pop_i[i])
        );
    end
endgenerate

`HQM_DEVTLB_RST_MSFF(PendQFull,nxt_pendq_full_i,ClkPendQ_H,reset) 
`HQM_DEVTLB_RSTD_MSFF(PendQEmpty,&NxtPendQIdle,ClkPendQ_H,reset,'1) 

`ifndef HQM_DEVTLB_SVA_OFF
//cover more than one CAMHIT
`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_WakeAtPut,
   (PendQPut),
   (PendQWakeAtPut),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_WakeErrAtPut,
   (PendQPut),
   (PendQWakeInfoAtPut.DPErr || PendQWakeInfoAtPut.HdrErr),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_WakeForceXRspAtPut,
   (PendQPut),
   (PendQWakeInfoAtPut.ForceXRsp),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_WakePrsCodeAtPut,
   (PendQPut),
   (~|PendQWakeInfoAtPut.PrsCode),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_WakeErr,
   (PendQWake && ~PendQVacant[PendQWakeMsTrkId]),
   (PendQWakeInfo.DPErr || PendQWakeInfo.HdrErr),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_WakeForceXRsp,
   (PendQWake && ~PendQVacant[PendQWakeMsTrkId]),
   (PendQWakeInfo.ForceXRsp),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_DELAYED_TRIGGER(CP_PENDQCAMHIT_NOTONEHOT,
   (PendQCamEn[WAKECAMCTL]), 1,
   (!$onehot(PendQCamHit[WAKECAMRET])),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_CAMWR_CONFLICT_HSD22011285488,
   (PendQCamEn[WAKECAMCTL]),
   (PendQWrEn),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

// an entery is grabbed immediately after turned vacant
`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_HSD22010222500,
   (PendQWrEn),
   ($rose(PendQVacant[PendQWrAddr])),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_PENDQ_InvEnd_XReqPipe,
   (InvMsTrkEnd),
   (|XReqPipeV),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQ_PUTVACANT,
   (PendQPut),
   (PendQVacant[PendQIdx]),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQ_RDWR_CONFLICT,
   (PendQWrEn && PendQRdEn),
   (~(PendQWrAddr == PendQRdAddr)),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

//When InvEnd, no Wake in pipe, otherwise those need to be invalidated, before forcexrsp used for wake
`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQ_INVEND_WakePipeIdle,
   (InvMsTrkEnd),
   (~(|WakePipeV)),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_PENDQ_InvEnd_ClrForXRspInXReqPipe,
   InvMsTrkEnd,1,
   !(|(RdForceXRsp & XReqPipeV[XREQRDRET:XREQRDCTL]) || |(ForceXRsp & XReqPipeV[XREQOUT: XREQRDRET])),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_COVERS_DELAYED_TRIGGER(CP_PENDQ_InvEnd_ClrPrsCodeInXReqPipe,
   InvMsTrkEnd,1,
   ~(((RdPrsCode[XREQRDCTL]=='0) || ~XReqPipeV[XREQRDCTL]) &&
    ((RdPrsCode[XREQRDRET]=='0) || ~XReqPipeV[XREQRDRET]) &&
    ((PrsCode[XREQRDRET]=='0) || ~XReqPipeV[XREQRDRET]) &&
    ((PrsCode[XREQOUT]=='0) || ~XReqPipeV[XREQOUT])),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

final begin : ASF_PENDQ_IDLE
    assert (PendQVacant=='1) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: MsTrk not empty.");
    assert ({WakePipeV, XReqPipeV}=='0) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: Pipe Is not empty.");
end
`endif //DEVTLB_SVA_OFF

endmodule

`endif // DEVTLB_PENDQ_VS
