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

`ifndef HQM_DEVTLB_MSPROC_VS
`define HQM_DEVTLB_MSPROC_VS

`include "hqm_devtlb_pkg.vh"
`include "hqm_devtlb_rrarb.sv"

module hqm_devtlb_msproc
import `HQM_DEVTLB_PACKAGE_NAME::*; 
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter type T_REQ = logic, //t_devtlb_request,
    parameter type T_PROCREQ = logic,
    parameter type T_CAMREQ = logic, //t_devtlb_camreq,
    parameter type T_OPCODE = logic, //t_devtlb_opcode,
    parameter logic BDF_SUPP_EN = DEVTLB_BDF_SUPP_EN,
    parameter int BDF_WIDTH = DEVTLB_BDF_WIDTH,
    parameter logic PASID_SUPP_EN = DEVTLB_PASID_SUPP_EN,
    parameter int PASID_WIDTH = DEVTLB_PASID_WIDTH,
    parameter logic PENDQ_SUPP_EN = 1,
    parameter int XREQ_PORTNUM = 2,
    parameter int MISSTRK_DEPTH = 128,
    parameter int PENDQ_DEPTH = 128,
    parameter logic FWDPROG_EN = 1'b0,
    localparam int MISSCH_NUM = (FWDPROG_EN)? 2: 1,
    localparam int MISSTRK_IDW = $clog2(MISSTRK_DEPTH),
    localparam int PENDQ_IDW = $clog2(PENDQ_DEPTH),
    localparam int XREQ_PORTID = (XREQ_PORTNUM>1)? $clog2(XREQ_PORTNUM): 1
)(
    input  logic                            clk,
    input  logic                            reset,
    input  logic                            reset_INST,
    input  logic                            fscan_clkungate,
    input  logic                            PwrDnOvrd_nnnH,

    input  logic                            InvMsTrkEnd,
    
    input  logic                            MsProcPut,
    output logic                            MsProcFree,
    input  T_PROCREQ                        MsProcReq,
    output logic                            MsProcPrimCrdRet,
    output logic [MISSCH_NUM-1:0]           MsProcSecCrdRet,
    output logic                            MsProcPendQCrdRet,

    output logic                            MsTrkReqCamEn,
    output T_CAMREQ                         MsTrkReqCamData,
    input  logic [MISSTRK_DEPTH-1:0]        MsTrkReqCamHit,
    
    input  logic [MISSTRK_DEPTH-1:0]        MsTrkVacant,
    input  logic [MISSTRK_DEPTH-1:0]        MsTrkWrOp,
    input  logic [MISSTRK_DEPTH-1:0]        MsTrkVld,
    output logic                            MsTrkReqPut,
    output logic [MISSTRK_IDW-1:0]          MsTrkReqIdx,
    output T_REQ                            MsTrkReq,

    input  logic                            PendQFull,
    input  logic [PENDQ_DEPTH-1:0]          PendQVacant,
    output logic                            PendQPut,
    output logic [PENDQ_IDW-1:0]            PendQIdx,
    output T_REQ                            PendQReq,
    output logic                            PendQWakeAtPut,
    output t_wakeinfo                       PendQWakeInfoAtPut,
    output logic [MISSTRK_IDW-1:0]          PendQMsHitIdx
);

localparam logic CAMWR_CONFLICT_EN = 1'b1;
localparam logic PENDQSTALLPIPE_EN = 1'b0; //TODO low priority: implement 1 case
localparam MSTRK = 0;
localparam PENQ = 1;
localparam MSPROC_CAMCTL = 0;
localparam MSPROC_CAMRET = MSPROC_CAMCTL + 1;
localparam MSPROC_OUT = MSPROC_CAMRET + 1;

function automatic logic [MISSTRK_IDW -1:0] get_idx (
                                input logic [MISSTRK_DEPTH-1:0] onehotvec
);
    get_idx = '0;
    for (int i=(MISSTRK_DEPTH-1); i>=0; i--) if (onehotvec[i]) get_idx = i[MISSTRK_IDW-1:0];
endfunction

function automatic logic func_reqhit (
                                input T_REQ req0,
                                input T_REQ req1
);
    logic prior_hit;
    logic bdf_hit;
    logic pasid_hit;
    logic addr_hit;
    logic tlbid_hit;
    logic opcode_hit; // permission is covered by req1 ahead of req0
    
    prior_hit = (req0.MPrior == req1.MPrior);
    bdf_hit   = (req0.BDF == req1.BDF) || ~BDF_SUPP_EN;
    pasid_hit = (((req0.PASID == req1.PASID) && (req0.PR == req1.PR)) && (req0.PasidV == req1.PasidV)) || ~PASID_SUPP_EN; 
    addr_hit  = (req0.Address == req1.Address);
    tlbid_hit = (req0.TlbId == req1.TlbId);
    opcode_hit = ((req0.Opcode == T_OPCODE'(DEVTLB_OPCODE_UTRN_R)) || 
                  (req1.Opcode == T_OPCODE'(DEVTLB_OPCODE_UTRN_W)));
    
    func_reqhit = bdf_hit && pasid_hit && addr_hit && tlbid_hit && opcode_hit && (prior_hit || ~FWDPROG_EN);
endfunction

genvar g_stage;
genvar g_port;

//-------------------------------------------------------------------------------
//  CLOCKING
//-------------------------------------------------------------------------------
   logic [MSPROC_OUT-1:MSPROC_CAMCTL  ]             pEn_ClkMsprocPipe_H;
   logic [MSPROC_OUT  :MSPROC_CAMCTL+1]             ClkMsprocPipe_H;

generate
for (g_stage = MSPROC_CAMCTL+1; g_stage <= MSPROC_OUT; g_stage++) begin  : Pipe_State
         `HQM_DEVTLB_MAKE_LCB_PWR(ClkMsprocPipe_H[g_stage],  clk, pEn_ClkMsprocPipe_H[g_stage-1],  PwrDnOvrd_nnnH)
end
endgenerate
   
//--------------------------------------------------------------------------------
/*
CAM ACCESS follow by PndQ/MissQ write
Clk1:      port0 CAM_REQ
ClkN:     port0 CAM_GNT
ClkN+1: MsProcPut, CAM_en, CAM_din: S0
ClkN+2: CAM_hit :S1
ClkN+3: CAM_hit_id :S2
        if CAM_hit, write PendQ
        else, write Miss Q.
*/
logic                                         MsprocStall;
logic [MSPROC_OUT:MSPROC_CAMCTL]              reqV;
T_REQ [MSPROC_OUT:MSPROC_CAMCTL]              req;
logic [MSPROC_OUT:MSPROC_CAMCTL]              ProcReqHitMsTrkVld;
logic [MSPROC_OUT:MSPROC_CAMRET]              ProcReqHitMsTrkVld_ff;
t_wakeinfo [MSPROC_OUT:MSPROC_CAMCTL]         ProcReqHitInfo;
t_wakeinfo [MSPROC_OUT:MSPROC_CAMRET]         ProcReqHitInfo_ff;

logic [MSPROC_CAMRET:MSPROC_CAMCTL]           cam_ack;

always_comb begin
    for (int i=MSPROC_CAMCTL+1; i<= MSPROC_OUT; i++) begin
        pEn_ClkMsprocPipe_H[i-1]  = reset
                                    | reqV[i-1] | reqV[i];
    end
    MsprocStall = 1'b0; //PENDQWAKE_DLY_CNT not allow MsprocStall 
                        //if PendQFull, simply put the req to misstrk
    MsProcFree = CAMWR_CONFLICT_EN || ~MsTrkReqPut; //assume MsTrkReqPut == MsTrkWrEn 
end

//Stage: MSPROC_CAMCTL
logic [MSPROC_OUT:MSPROC_CAMCTL][MISSTRK_IDW-1:0]       mstrk_hitidx;
logic [MSPROC_OUT:MSPROC_CAMCTL]                        mstrk_hitvld;
logic [MSPROC_OUT:MSPROC_CAMRET][MISSTRK_IDW-1:0]       mstrk_hitidx_ff;
logic [MSPROC_OUT:MSPROC_CAMRET]                        mstrk_hitvld_ff;
logic [MSPROC_CAMRET:MSPROC_CAMCTL]                     HitReqInAhead;
logic [MSPROC_OUT:MSPROC_OUT][MISSTRK_IDW-1:0]          MsTrkGntIdx;
logic [MSPROC_OUT:MSPROC_OUT]                           MsTrkReqPut_i;
logic [MSPROC_OUT:MSPROC_OUT]                           PendQPut_i; 
always_comb begin
    reqV[MSPROC_CAMCTL] = MsProcPut;
    req[MSPROC_CAMCTL]  = MsProcReq.Req;
    ProcReqHitMsTrkVld[MSPROC_CAMCTL] = '0;
    ProcReqHitInfo[MSPROC_CAMCTL].ForceXRsp = '0;
    ProcReqHitInfo[MSPROC_CAMCTL].PrsCode = '0;
    ProcReqHitInfo[MSPROC_CAMCTL].DPErr     = '0;
    ProcReqHitInfo[MSPROC_CAMCTL].HdrErr    = '0;

    MsTrkReqCamData.MPrior = MsProcReq.Req.MPrior;
    //MsTrkReqCamData.Opcode = MsProcReq.Req.Opcode;
    MsTrkReqCamData.TlbId = MsProcReq.Req.TlbId;
    MsTrkReqCamData.Address = MsProcReq.Req.Address;
    MsTrkReqCamData.PasidV = MsProcReq.Req.PasidV;
    MsTrkReqCamData.PR = MsProcReq.Req.PR;
    MsTrkReqCamData.PASID = MsProcReq.Req.PASID;
    MsTrkReqCamData.BDF = MsProcReq.Req.BDF;

    MsTrkReqCamEn = MsProcPut;
    cam_ack[MSPROC_CAMCTL] = MsTrkReqCamEn;

    HitReqInAhead[MSPROC_CAMCTL] =  reqV[MSPROC_OUT] && func_reqhit(req[MSPROC_CAMCTL], req[MSPROC_OUT]);
    mstrk_hitvld[MSPROC_CAMCTL] = '0;
    mstrk_hitidx[MSPROC_CAMCTL] = '0;
    if (HitReqInAhead[MSPROC_CAMCTL]) begin
        mstrk_hitidx[MSPROC_CAMCTL] = MsTrkReqPut_i[MSPROC_OUT]? MsTrkGntIdx[MSPROC_OUT]: mstrk_hitidx[MSPROC_OUT]; // if Req in front not going MsTrk, it is going to pendq, so takes its mstrk hitidx 
        mstrk_hitvld[MSPROC_CAMCTL] = MsTrkReqPut_i[MSPROC_OUT] || MsTrkVld[mstrk_hitidx[MSPROC_OUT]] || (ProcReqHitMsTrkVld[MSPROC_OUT] && PendQPut_i[MSPROC_OUT]);
        ProcReqHitMsTrkVld[MSPROC_CAMCTL]       = ProcReqHitMsTrkVld[MSPROC_OUT] && PendQPut_i[MSPROC_OUT];
        ProcReqHitInfo[MSPROC_CAMCTL].ForceXRsp = ProcReqHitInfo[MSPROC_OUT].ForceXRsp && ProcReqHitMsTrkVld[MSPROC_OUT];
        ProcReqHitInfo[MSPROC_CAMCTL].PrsCode   = ProcReqHitMsTrkVld[MSPROC_OUT]? ProcReqHitInfo[MSPROC_OUT].PrsCode: '0;
        ProcReqHitInfo[MSPROC_CAMCTL].DPErr     = ProcReqHitInfo[MSPROC_OUT].DPErr && ProcReqHitMsTrkVld[MSPROC_OUT];
        ProcReqHitInfo[MSPROC_CAMCTL].HdrErr    = ProcReqHitInfo[MSPROC_OUT].HdrErr && ProcReqHitMsTrkVld[MSPROC_OUT];
    end 
    ProcReqHitMsTrkVld[MSPROC_CAMCTL] |= MsProcReq.HitMsTrkVld;
    mstrk_hitvld[MSPROC_CAMCTL] |= MsProcReq.HitMsTrkVld;
    if (MsProcReq.HitMsTrkVld) begin
        mstrk_hitidx[MSPROC_CAMCTL]             = MsProcReq.HitMsTrkIdx;
        ProcReqHitInfo[MSPROC_CAMCTL].ForceXRsp = MsProcReq.ForceXRsp;
        ProcReqHitInfo[MSPROC_CAMCTL].PrsCode   = MsProcReq.PrsCode;
        ProcReqHitInfo[MSPROC_CAMCTL].DPErr     = MsProcReq.DPErr;
        ProcReqHitInfo[MSPROC_CAMCTL].HdrErr    = MsProcReq.HdrErr;
    end
end
//see /p/hdk/rtl/ip_releases/shdk74/sdg_bcam/sdg_bcam-srvr10nm-spr_1p0-19ww04a/src/rtl/srf026b256e1r1w1cbbeheaa0aan.sv

//Stage: MSPROC_CAMCTL++
generate
for (g_stage=MSPROC_CAMCTL+1; g_stage<=MSPROC_OUT; g_stage++) begin: gen_msproc_reqv
    `HQM_DEVTLB_EN_RST_MSFF(reqV[g_stage],reqV[g_stage-1],ClkMsprocPipe_H[g_stage],~MsprocStall, reset)
    `HQM_DEVTLB_EN_MSFF(req[g_stage],req[g_stage-1],ClkMsprocPipe_H[g_stage],~MsprocStall)
    `HQM_DEVTLB_EN_RST_MSFF(ProcReqHitMsTrkVld_ff[g_stage],ProcReqHitMsTrkVld[g_stage-1],ClkMsprocPipe_H[g_stage],~MsprocStall, reset)
    `HQM_DEVTLB_EN_MSFF(ProcReqHitInfo_ff[g_stage].ForceXRsp,(ProcReqHitInfo[g_stage-1].ForceXRsp && ~InvMsTrkEnd),ClkMsprocPipe_H[g_stage],(InvMsTrkEnd || ~MsprocStall))
    `HQM_DEVTLB_EN_MSFF(ProcReqHitInfo_ff[g_stage].PrsCode,ProcReqHitInfo[g_stage-1].PrsCode,ClkMsprocPipe_H[g_stage],(~MsprocStall))
    `HQM_DEVTLB_EN_MSFF(ProcReqHitInfo_ff[g_stage].DPErr,(ProcReqHitInfo[g_stage-1].DPErr),ClkMsprocPipe_H[g_stage],(~MsprocStall))
    `HQM_DEVTLB_EN_MSFF(ProcReqHitInfo_ff[g_stage].HdrErr,(ProcReqHitInfo[g_stage-1].HdrErr),ClkMsprocPipe_H[g_stage],(~MsprocStall))
    `HQM_DEVTLB_EN_MSFF(mstrk_hitidx_ff[g_stage],mstrk_hitidx[g_stage-1],ClkMsprocPipe_H[g_stage],~MsprocStall)
    `HQM_DEVTLB_EN_RST_MSFF(mstrk_hitvld_ff[g_stage],mstrk_hitvld[g_stage-1],ClkMsprocPipe_H[g_stage],~MsprocStall, reset)
end

for (g_stage=MSPROC_CAMCTL+1; g_stage<=MSPROC_CAMRET; g_stage++) begin: gen_msproc_camack
    `HQM_DEVTLB_RST_MSFF(cam_ack[g_stage],cam_ack[g_stage-1],ClkMsprocPipe_H[g_stage],reset)
end
endgenerate

//assert MsProcPut |-> ~MsprocStall;

//Stage MSPROC_CAMRET
logic [MISSTRK_IDW-1:0]                                 MsTrkCamHitIdx, MsTrkWrCamConflictIdx;
logic [MISSTRK_IDW-1:0]                                 SavedMsTrkCamHitIdx;
logic                                                   MsTrkCamHitVld, MsTrkWrCamConflict;
logic                                                   SavedMsTrkCamHitVld;
logic [MISSTRK_DEPTH-1:0]                               MsTrkCamHitVec, MsTrkVldQual;

`HQM_DEVTLB_EN_RST_MSFF(MsTrkWrCamConflict,MsTrkReqPut,ClkMsprocPipe_H[MSPROC_CAMCTL+1],cam_ack[MSPROC_CAMCTL], reset)
`HQM_DEVTLB_EN_MSFF(MsTrkWrCamConflictIdx,MsTrkReqIdx,ClkMsprocPipe_H[MSPROC_CAMCTL+1],cam_ack[MSPROC_CAMCTL])

always_comb begin
    // Multiple hit is possible, e.g a DMA_W is pushed to MsTrk while a matching DMA_R in MsTrk.
    // In this case, if op=R, then get_idx will choose the lsb
    for (int i=0; i<MISSTRK_DEPTH; i++) begin 
        MsTrkVldQual[i] = cam_ack[MSPROC_CAMRET] && 
                          ~(MsTrkWrCamConflict && (MsTrkWrCamConflictIdx==i[MISSTRK_IDW-1:0])); 
    end
    MsTrkCamHitVec = MsTrkVld & MsTrkVldQual &
                     ((req[MSPROC_CAMRET].Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_R))? 
                       MsTrkReqCamHit:
                       MsTrkReqCamHit & MsTrkWrOp); 
    MsTrkCamHitIdx = get_idx(MsTrkCamHitVec); //TODO: stage CAM ret for RF
    MsTrkCamHitVld = (|MsTrkCamHitVec); // qualify Cam output
    //MsTrkCamHitVld &= ((req[MSPROC_CAMRET].Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_R)) || MsTrkWrOp[MsTrkCamHitIdx]);
end
`HQM_DEVTLB_EN_RST_MSFF(SavedMsTrkCamHitVld,MsTrkCamHitVld,ClkMsprocPipe_H[MSPROC_CAMRET+1],cam_ack[MSPROC_CAMRET], reset)
`HQM_DEVTLB_EN_MSFF(SavedMsTrkCamHitIdx,MsTrkCamHitIdx,ClkMsprocPipe_H[MSPROC_CAMRET+1],cam_ack[MSPROC_CAMRET])

//Stage MSPROC_CAMRET++
always_comb begin
    mstrk_hitvld[MSPROC_CAMRET] = mstrk_hitvld_ff[MSPROC_CAMRET];
    mstrk_hitidx[MSPROC_CAMRET] = mstrk_hitidx_ff[MSPROC_CAMRET];
    ProcReqHitMsTrkVld[MSPROC_CAMRET] = ProcReqHitMsTrkVld_ff[MSPROC_CAMRET];
    ProcReqHitInfo[MSPROC_CAMRET] = ProcReqHitInfo_ff[MSPROC_CAMRET];

    HitReqInAhead[MSPROC_CAMRET] = '0;
    if (~ProcReqHitMsTrkVld_ff[MSPROC_CAMRET]) begin
        if ((cam_ack[MSPROC_CAMRET]? MsTrkCamHitVld: SavedMsTrkCamHitVld)) begin
            mstrk_hitidx[MSPROC_CAMRET] = cam_ack[MSPROC_CAMRET]? MsTrkCamHitIdx: SavedMsTrkCamHitIdx;
            mstrk_hitvld[MSPROC_CAMRET] = '1;
        end else begin
            HitReqInAhead[MSPROC_CAMRET] =  reqV[MSPROC_OUT] && func_reqhit(req[MSPROC_CAMRET], req[MSPROC_OUT]);
            if (HitReqInAhead[MSPROC_CAMRET]) begin
                mstrk_hitidx[MSPROC_CAMRET] = MsTrkReqPut_i[MSPROC_OUT]? MsTrkGntIdx[MSPROC_OUT]: mstrk_hitidx[MSPROC_OUT]; // if Req in front not going MsTrk, it is going to pendq, so takes its mstrk hitidx 
                mstrk_hitvld[MSPROC_CAMRET] = MsTrkReqPut_i[MSPROC_OUT] || MsTrkVld[mstrk_hitidx[MSPROC_OUT]] || (ProcReqHitMsTrkVld[MSPROC_OUT] && PendQPut_i[MSPROC_OUT]);
                ProcReqHitMsTrkVld[MSPROC_CAMRET]       = ProcReqHitMsTrkVld[MSPROC_OUT] && PendQPut_i[MSPROC_OUT];
                ProcReqHitInfo[MSPROC_CAMRET].ForceXRsp = ProcReqHitInfo[MSPROC_OUT].ForceXRsp && ProcReqHitMsTrkVld[MSPROC_OUT];
                ProcReqHitInfo[MSPROC_CAMRET].PrsCode   = ProcReqHitMsTrkVld[MSPROC_OUT]? ProcReqHitInfo[MSPROC_OUT].PrsCode: '0;
                ProcReqHitInfo[MSPROC_CAMRET].DPErr     = ProcReqHitInfo[MSPROC_OUT].DPErr && ProcReqHitMsTrkVld[MSPROC_OUT];
                ProcReqHitInfo[MSPROC_CAMRET].HdrErr    = ProcReqHitInfo[MSPROC_OUT].HdrErr && ProcReqHitMsTrkVld[MSPROC_OUT];
            end else begin
                if (mstrk_hitvld_ff[MSPROC_CAMRET]) begin
                    mstrk_hitvld[MSPROC_CAMRET] = MsTrkVld[mstrk_hitidx_ff[MSPROC_CAMRET]];
                end
            end 
        end
    end

    //mstrk_hitvld[MSPROC_CAMRET] &= (req[MSPROC_CAMRET].Opcode != T_OPCODE'(DEVTLB_OPCODE_FILL));
    mstrk_hitvld[MSPROC_CAMRET] &= PENDQ_SUPP_EN;
end

//Stage MSPROC_OUT++

//Stage MSPROC_OUT
logic [MSPROC_OUT:MSPROC_OUT][PENDQ_IDW-1:0]            pendq_idx_i;
//logic                                                   MsTrkArbRs;
logic                                                   MsTrkGnt;

always_comb begin
    mstrk_hitvld[MSPROC_OUT] = mstrk_hitvld_ff[MSPROC_OUT];
    mstrk_hitidx[MSPROC_OUT] = mstrk_hitidx_ff[MSPROC_OUT];

    MsTrkReqPut_i[MSPROC_OUT] = reqV[MSPROC_OUT] && (~MsprocStall) &&
                              (~(mstrk_hitvld[MSPROC_OUT] && ~PendQFull));

    PendQPut_i[MSPROC_OUT] = reqV[MSPROC_OUT]  && (~MsprocStall) && 
                              ( (mstrk_hitvld[MSPROC_OUT] && ~PendQFull));
end
hqm_devtlb_rrarb #(.REQ_W (MISSTRK_DEPTH), .REQ_IDW (MISSTRK_IDW))
MsTrk_RRClaim (
    .clk (ClkMsprocPipe_H[MSPROC_OUT]), .rst_b (~reset), .arb_rs (MsTrkReqPut_i[MSPROC_OUT]), 
    .arb_req (MsTrkVacant), 
    .arb_gnt (MsTrkGnt),
    .arb_gntid (MsTrkGntIdx)
);  

hqm_devtlb_rrarb #(.REQ_W (PENDQ_DEPTH), .REQ_IDW (PENDQ_IDW))
PendQ_RRClaim (
    .clk (ClkMsprocPipe_H[MSPROC_OUT]), .rst_b (~reset), .arb_rs (PendQPut_i[MSPROC_OUT]), 
    .arb_req (PendQVacant), 
    .arb_gnt (), // lintra s-0214
    .arb_gntid (pendq_idx_i[MSPROC_OUT])
);  

always_comb begin
    ProcReqHitMsTrkVld[MSPROC_OUT] = ProcReqHitMsTrkVld_ff[MSPROC_OUT];
    ProcReqHitInfo[MSPROC_OUT] = ProcReqHitInfo_ff[MSPROC_OUT];

    MsTrkReqPut = MsTrkReqPut_i[MSPROC_OUT];
    MsTrkReqIdx = MsTrkGntIdx[MSPROC_OUT];
    MsTrkReq = req[MSPROC_OUT];
    
    PendQPut = PendQPut_i[MSPROC_OUT];
    PendQIdx = pendq_idx_i[MSPROC_OUT];
    PendQMsHitIdx = mstrk_hitidx[MSPROC_OUT];
    PendQReq = req[MSPROC_OUT];
    PendQWakeAtPut = ProcReqHitMsTrkVld[MSPROC_OUT];
    PendQWakeInfoAtPut = ProcReqHitInfo[MSPROC_OUT];
    
    MsProcPrimCrdRet = PendQPut_i[MSPROC_OUT]; 
    MsProcSecCrdRet = '0;
    if (FWDPROG_EN) begin
        MsProcSecCrdRet[0] = PendQPut_i[MSPROC_OUT] &&
                                (~req[MSPROC_OUT].Priority);
        MsProcSecCrdRet[MISSCH_NUM-1] = PendQPut_i[MSPROC_OUT] &&
                                ( req[MSPROC_OUT].Priority);
    end
    MsProcPendQCrdRet = MsTrkReqPut_i[MSPROC_OUT];
end

`ifndef HQM_DEVTLB_SVA_OFF
`HQM_DEVTLB_COVERS_TRIGGER(CP_MSPROC_HITMSTRK_PENDQFULL,
   ((reqV[MSPROC_OUT] && (~MsprocStall)) && mstrk_hitvld[MSPROC_OUT]),
   (PendQFull),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_MSPROC_CAMWR_CONFLICT,
   (MsTrkReqPut),
   (MsTrkReqCamEn),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_DELAYED_TRIGGER(CP_PENDQ_HSD22010400569, // AS_PENDQ_PUTMISSWAKE error
   (MsTrkReqPut), 1,
   ((cam_ack[MSPROC_CAMRET] && ~MsTrkCamHitVld) && (|HitReqInAhead[MSPROC_CAMRET]) &&
      (PendQPut_i[MSPROC_OUT] && ~MsTrkVld[mstrk_hitidx[MSPROC_CAMRET]])),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_DELAYED_TRIGGER(CP_DMAR_CAMHIT_NOTONEHOT,
   (MsTrkReqCamEn), 1,
   ((req[MSPROC_CAMRET].Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_R)) && !$onehot(MsTrkReqCamHit & MsTrkVld)),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_DELAYED_TRIGGER(CP_DMAW_CAMHIT_NOTONEHOT,
   (MsTrkReqCamEn), 1,
   ((req[MSPROC_CAMRET].Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_W)) && !$onehot(MsTrkReqCamHit & MsTrkVld)),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_CAMCTL_HIT_OUT_WITH_WAKEATPUT_MSTRKnotVld,
   (reqV[MSPROC_CAMCTL] && HitReqInAhead[MSPROC_CAMCTL]),
   (PendQPut && ProcReqHitMsTrkVld[MSPROC_OUT] && ~MsTrkVld[mstrk_hitidx[MSPROC_OUT]]),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_CAMCTL_HIT_OUT_WITH_WAKEATPUT_MSTRKVld,
   (reqV[MSPROC_CAMCTL] && HitReqInAhead[MSPROC_CAMCTL]),
   (PendQPut && ProcReqHitMsTrkVld[MSPROC_OUT] && MsTrkVld[mstrk_hitidx[MSPROC_OUT]]),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_CAMRET_HIT_OUT_WITH_WAKEATPUT_MSTRKnotVld,
   (reqV[MSPROC_CAMRET] && HitReqInAhead[MSPROC_CAMRET]),
   (PendQPut && ProcReqHitMsTrkVld[MSPROC_OUT] && ~MsTrkVld[mstrk_hitidx[MSPROC_OUT]]),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_CAMRET_HIT_OUT_WITH_WAKEATPUT_MSTRKVld,
   (reqV[MSPROC_CAMRET] && HitReqInAhead[MSPROC_CAMRET]),
   (PendQPut && ProcReqHitMsTrkVld[MSPROC_OUT] && MsTrkVld[mstrk_hitidx[MSPROC_OUT]]),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_MSPROC_PUT_VALID_OPCODE,
   (MsProcPut),
   (MsProcReq.Req.Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_R)) || (MsProcReq.Req.Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_W)),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_CAMCTL_HIT_OUT_WITH_WAKEATPUT,
   (reqV[MSPROC_CAMCTL] && HitReqInAhead[MSPROC_CAMCTL] && ProcReqHitMsTrkVld[MSPROC_CAMCTL] && PendQPut && ~MsProcReq.HitMsTrkVld), 2,
   (((PendQWakeAtPut == $past(PendQWakeAtPut, 2)) &&
     (PendQWakeInfoAtPut == $past(PendQWakeInfoAtPut, 2)) &&
     (PendQMsHitIdx == $past(PendQMsHitIdx, 2))) || ~PendQPut),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_CAMRET_HIT_OUT_WITH_WAKEATPUT,
   (reqV[MSPROC_CAMRET] && HitReqInAhead[MSPROC_CAMRET] && ProcReqHitMsTrkVld[MSPROC_CAMRET] && PendQPut), 1,
   (((PendQWakeAtPut == $past(PendQWakeAtPut, 1)) &&
     (PendQWakeInfoAtPut == $past(PendQWakeInfoAtPut, 1)) &&
     (PendQMsHitIdx == $past(PendQMsHitIdx, 1))) || ~PendQPut),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

//assert onehot pendq, mstrkxreq put, & fill put.
`HQM_DEVTLB_ASSERTS_TRIGGER(AS_MSPROC_OUT_PUTONEHOT,
   (reqV[MSPROC_OUT]  && (~MsprocStall)),
   ($onehot({PendQPut, MsTrkReqPut}) && (|{PendQPut, MsTrkReqPut})),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

//flag error if faulty cam vld is set.
`HQM_DEVTLB_ASSERTS_TRIGGER(AS_MSPROC_MSTRKHITVLD,
   (reqV[MSPROC_CAMRET] && mstrk_hitvld[MSPROC_CAMRET] && ~(mstrk_hitvld_ff[MSPROC_CAMRET] || HitReqInAhead[MSPROC_CAMRET] )),
   (|(({{(MISSTRK_DEPTH-1){1'b0}}, 1'b1} << mstrk_hitidx[MSPROC_CAMRET]) & $past(MsTrkVld))),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_MSPROC_PENDQPUTMSTRKVLD,
   (PendQPut && ~PendQWakeAtPut),
   (MsTrkVld[PendQMsHitIdx] || 
    (|(({{(MISSTRK_DEPTH-1){1'b0}}, 1'b1} << PendQMsHitIdx) & $past(MsTrkVld)))),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

//hsd14013241686
generate
for (g_stage=MSPROC_CAMCTL; g_stage<=MSPROC_OUT; g_stage++) begin : gen_as_hsd14013241686_msproc_stage
    `HQM_DEVTLB_COVERS_TRIGGER(CP_MSPROC_hsd14013241686_ForceXRsp,
       (InvMsTrkEnd),
       (reqV[g_stage] && (ProcReqHitInfo[g_stage].ForceXRsp)),
       posedge clk, reset_INST,
    `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

    `HQM_DEVTLB_COVERS_TRIGGER(CP_MSPROC_hsd14013241686_Err,
       (InvMsTrkEnd),
       (reqV[g_stage] && (ProcReqHitInfo[g_stage].DPErr || ProcReqHitInfo[g_stage].HdrErr)),
       posedge clk, reset_INST,
    `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

    `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_MSPROC_INVEND_NO_HIT_WITH_FORCEXRSP_OR_ATSRSPERR,
       InvMsTrkEnd, 1,
/*       ~|{(reqV[g_stage] && ProcReqHitInfo[g_stage].ForceXRsp),
          (reqV[g_stage] && ProcReqHitInfo[g_stage].DPErr),
          (reqV[g_stage] && ProcReqHitInfo[g_stage].HdrErr)},*/
       ~|{(reqV[g_stage] && ProcReqHitInfo[g_stage].ForceXRsp)},
       posedge clk, reset_INST,
    `HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));
end
endgenerate

//assert $countones(MsTrkReqCamHit & MsTrkVld & MsTrkWrOp) ==1: 
/*commented out, PendQFull handling make this an legal situation
AS_DMAR_CAMHITVEC:
assert property (@(posedge clk) (
    MsTrkReqCamEn |=>
    ($countones(MsTrkReqCamHit & MsTrkVld & ~MsTrkWrOp)<2)
)) else $error("%0t, %m FAILED", $time);
AS_DMAW_CAMHITVEC:
assert property (@(posedge clk) (
    MsTrkReqCamEn |=>
    ($countones(MsTrkReqCamHit & MsTrkVld & MsTrkWrOp)<2)
)) else $error("%0t, %m FAILED", $time);*/

final begin : ASF_MSPROC_IDLE
    assert (reqV=='0) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: Pipe Is not empty.");
end
`endif
endmodule

`endif // DEVTLB_MSPROC_VS
