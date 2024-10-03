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

`ifndef HQM_DEVTLB_MSTRK_VS
`define HQM_DEVTLB_MSTRK_VS

`include "hqm_devtlb_pkg.vh"
`include "hqm_devtlb_rrarb.sv"
`include "hqm_devtlb_mstrk_fsm.sv"

module hqm_devtlb_mstrk
import `HQM_DEVTLB_PACKAGE_NAME::*; 
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter logic PARITY_EN = 1'b0,
    parameter logic PRS_SUPP_EN = DEVTLB_PRS_SUPP_EN,
    parameter logic BDF_SUPP_EN = DEVTLB_BDF_SUPP_EN,
    parameter int BDF_WIDTH = DEVTLB_BDF_WIDTH,
    parameter logic PASID_SUPP_EN = DEVTLB_PASID_SUPP_EN,
    parameter int PASID_WIDTH = DEVTLB_PASID_WIDTH,
    parameter logic TLB_GLOB_SUPP = 1'b0,
    parameter logic ARSP_U_SUPP = 1'b0,
    parameter logic ARSP_X_SUPP = 1'b0,
    parameter int XREQ_PORTNUM = 1,
    parameter int TLB_NUM_ARRAYS = DEVTLB_TLB_NUM_ARRAYS,                   // The number of TLBID's supported
    parameter int TLB_NUM_SETS [TLB_NUM_ARRAYS:0][5:0] = '{ default:0 },
    parameter logic TLB_SHARE_EN                       = 1'b0,
    parameter int TLB_ALIASING [TLB_NUM_ARRAYS:0][5:0] = '{ default:0 },
    parameter int PS_MAX = IOTLB_PS_MAX,
    parameter int PS_MIN = IOTLB_PS_MIN,
    parameter type T_REQ = logic, //t_devtlb_request,
    parameter type T_REQ_CTRL = logic, //t_devtlb_request_ctrl,
    parameter type T_REQ_INFO = logic, //t_devtlb_request_info,
    parameter type T_ATSRSP   = logic, //t_mstrk_atsrsp,
    parameter type T_OPCODE = logic, //t_devtlb_opcode,
    parameter type T_PGSIZE = logic, //t_devtlb_page_type,
    parameter type T_SETADDR = logic, //t_devtlb_tlb_setaddr,
    parameter type T_FAULTREASON = logic, //t_devtlb_fault_reason,
    parameter int READ_LATENCY  = 1, // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
    parameter int ATSREQ_PORTNUM = 1,
    parameter int REQ_PAYLOAD_MSB = 63,
    parameter int REQ_PAYLOAD_LSB = 12,
    parameter int TLBID_WIDTH     = 6,
    parameter int MAX_HOST_ADDRESS_WIDTH = 64,
    parameter int MISSTRK_DEPTH = 128,
    parameter int HPMSTRK_CRDT = 4,
    parameter int LPMSTRK_CRDT = 4,
    parameter logic FWDPROG_EN = 1'b0,
    localparam int MISSCH_NUM = (FWDPROG_EN)? 2: 1,
    localparam int MISSTRK_IDW = $clog2(MISSTRK_DEPTH),
    localparam int XREQ_PORTID = (XREQ_PORTNUM>1)?$clog2(XREQ_PORTNUM):1
)(
    input  logic                            PwrDnOvrd_nnnH,
    input  logic                            clk,
    input  logic                            reset,
    input  logic                            reset_INST,
    input  logic                            fscan_clkungate,
    input  logic                            fscan_latchopen,
    input  logic                            fscan_latchclosed_b,
    input  logic [PS_MAX:PS_MIN]            CrTLBPsDis,
    input  logic                            CrTMaxATSReqEn,
    input  logic [MISSTRK_IDW:0]            CrTMaxATSReq,
    input  logic                            CrPrsDis,
    input  logic                            CrPrsCntDis,
    input  logic [2:0]                      CrPrsCnt,
    input  logic [MISSTRK_IDW:0]            CrPrsReqAlloc,
    output logic                            CrPrsStsUprgi,
    output logic                            CrPrsStsRf,
    output logic                            CrPrsStsStopped,

    //MsTRK status
    output logic [MISSTRK_DEPTH-1:0]        MsTrkVacant,
    output logic [MISSTRK_DEPTH-1:0]        MsTrkVld,
    output logic [MISSTRK_DEPTH-1:0]        MsTrkWrOp,
    //Filling MsTRK
    input  logic                            MsTrkPut,
    input  logic [MISSTRK_IDW-1:0]          MsTrkIdx,
    input  T_REQ                            MsTrkReq,
    output logic                            MsTrkPrimCrdRet,
    output logic [MISSCH_NUM-1:0]           MsTrkSecCrdRet,
    
    output logic                            MsTrkReqWrEn,
    output logic [MISSTRK_IDW-1:0]          MsTrkReqWrAddr,
    output T_REQ                            MsTrkReqWrData,

    //mstrk read - ATS REQ/Fill
    output logic                            MsTrkReqRdEn,
    output logic [MISSTRK_IDW-1:0]          MsTrkReqRdAddr,
    input  T_REQ                            MsTrkReqRdData,
    input  logic                            MsTrkReqPerr,

    //Invalidation
    input  logic                            InvMsTrkStart,
    input  logic                            InvMsTrkEnd,
    input  logic                            InvBlockFill, // for blocking new fillreq from mstrk fsm
    input  logic [BDF_WIDTH-1:0]            InvBDF,
    input  logic                            InvBdfV,
    input  logic [PASID_WIDTH-1:0]          InvPASID,
    input  logic                            InvGlob,
    input  logic                            InvPasidV,
    input  logic                            InvAOR,
    input  logic [REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB]  InvAddr,
    input  logic [REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB]  InvAddrMask,
    output logic                                    InvMsTrkBusy,
    output logic                            MsTrkFillInFlight,

    //ATS REQ
    output logic [ATSREQ_PORTNUM-1:0]                           atsreq_vld,
    output logic [ATSREQ_PORTNUM-1:0][REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB] atsreq_addr,
    output logic [ATSREQ_PORTNUM-1:0][BDF_WIDTH-1:0]            atsreq_bdf,
    output logic [ATSREQ_PORTNUM-1:0][MISSTRK_IDW-1:0]          atsreq_id,
    output logic [ATSREQ_PORTNUM-1:0]                           atsreq_pasid_vld,
    output logic [ATSREQ_PORTNUM-1:0]                           atsreq_pasid_priv,
    output logic [ATSREQ_PORTNUM-1:0][PASID_WIDTH-1:0]          atsreq_pasid,
    output logic [ATSREQ_PORTNUM-1:0][2:0]                      atsreq_tc,
//    output logic [ATSREQ_PORTNUM-1:0][2:0]                      atsreq_vc,
    output logic [ATSREQ_PORTNUM-1:0]                           atsreq_nw,
    input  logic [ATSREQ_PORTNUM-1:0]                           atsreq_ack,

    //mstrk read 1 - TLB Fill
    input  logic                                                atsrsp_vld,
    input  logic [3:0]                                          atsrsp_sts,
    input  logic                                                atsrsp_dperr,
    input  logic                                                atsrsp_hdrerr,
    input  logic [MISSTRK_IDW-1:0]                              atsrsp_id,
    input  logic [63:0]                                         atsrsp_data,                        
    
    //PRS REQ
    output logic                                                prsreq_vld,
    output logic [REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB]              prsreq_addr,
    output logic                                                prsreq_W,
    output logic                                                prsreq_R,
    output logic [BDF_WIDTH-1:0]                                prsreq_bdf,
    output logic [MISSTRK_IDW-1:0]                              prsreq_id,
    output logic                                                prsreq_pasid_vld,
    output logic                                                prsreq_pasid_priv,
    output logic [PASID_WIDTH-1:0]                              prsreq_pasid,
    input  logic                                                prsreq_ack,

    //mstrk read 2 - TLB Fill/Ats
    input  logic                                                prsrsp_vld,
    input  logic [3:0]                                          prsrsp_sts,
    input  logic [8:0]                                          prsrsp_id,

    //mstrk rsp write
    output logic                            MsTrkRspWrEn,
    output logic [MISSTRK_IDW-1:0]          MsTrkRspWrAddr,
    output T_ATSRSP                         MsTrkRspWrData,

    //mstrk rsp read - Fill
    output logic                            MsTrkRspRdEn,
    output logic [MISSTRK_IDW-1:0]          MsTrkRspRdAddr,
    input  T_ATSRSP                         MsTrkRspRdData,
    input  logic                            MsTrkRspPerr,

    output logic [XREQ_PORTNUM-1:0]         FillReqV,
    output T_REQ [XREQ_PORTNUM-1:0]         FillReq,
    output T_REQ_CTRL [XREQ_PORTNUM-1:0]    FillCtrl,
    output T_REQ_INFO [XREQ_PORTNUM-1:0]    FillInfo,
    input  logic [XREQ_PORTNUM-1:0]         FillGnt,

    input  logic [XREQ_PORTNUM-1:0]         FillTLBOutV,
    input  logic [XREQ_PORTNUM-1:0] [MISSTRK_IDW-1:0] FillTLBOutMsTrkIdx,
    input  t_fillinfo [XREQ_PORTNUM-1:0]    FillTLBOutInfo,

    //pendq read - Wake
    output logic                            PendQWake,
    output t_wakeinfo                       PendQWakeInfo,
    output logic [MISSTRK_IDW-1:0]          PendQWakeMsTrkId
);

localparam int ATSREQQ_DEPTH    = 4;
localparam int ATSREQQ_IDW      = $clog2(ATSREQQ_DEPTH);
localparam int ARSP_ADDRW_MAX   = MAX_HOST_ADDRESS_WIDTH;
localparam int PRSREQQ_DEPTH    = 4;
localparam int PRSREQQ_IDW      = $clog2(PRSREQQ_DEPTH);
localparam int PGOFFSET_W       = 12;
localparam int LSHIFT_IDW       = $clog2(ARSP_ADDRW_MAX-PGOFFSET_W);
localparam int LSHIFT_MAX       = ARSP_ADDRW_MAX-PGOFFSET_W;

function automatic logic [MISSTRK_IDW -1:0] get_idx (
                                input logic [MISSTRK_DEPTH-1:0] onehotvec
);
    get_idx = '0;
    for (int i=0; i<MISSTRK_DEPTH; i++) if (onehotvec[i]) get_idx = i[MISSTRK_IDW-1:0];
endfunction

function automatic logic [ARSP_ADDRW_MAX-1:PGOFFSET_W] get_vamask  (
                                input logic size,
                                input logic [ARSP_ADDRW_MAX-1:PGOFFSET_W] addr);
    logic [ARSP_ADDRW_MAX-1:PGOFFSET_W] vamask;
    logic [LSHIFT_IDW-1:0]              ls0_ind;
    //if S is 1, and all addr bit is 1, assert error and default to invalidate ALL, vs spec said undefined.
    ls0_ind = LSHIFT_MAX[LSHIFT_IDW-1:0];
    for (int j=(ARSP_ADDRW_MAX-PGOFFSET_W); j>=(PGOFFSET_W-PGOFFSET_W+1); j--) if (addr[(j+PGOFFSET_W-1)]==1'b0) ls0_ind  =  j[LSHIFT_IDW-1:0];
    vamask     =  size? ({(ARSP_ADDRW_MAX-PGOFFSET_W){1'b1}} << ls0_ind): '1;  // 1- don't takes from areq addr.
    get_vamask = vamask;
endfunction

function automatic logic [LSHIFT_IDW-1:0] get_ls0_ind  (
                                input logic size,
                                input logic [ARSP_ADDRW_MAX-1:PGOFFSET_W] addr);
    logic [LSHIFT_IDW-1:0] ls0_ind;
    //if S is 1, and all addr bit is 1, assert error and default to invalidate ALL, vs spec said undefined.
    ls0_ind = LSHIFT_MAX[LSHIFT_IDW-1:0];
    for (int j=(ARSP_ADDRW_MAX-PGOFFSET_W); j>=(PGOFFSET_W-PGOFFSET_W+1); j--) if (addr[(j+PGOFFSET_W-1)]==1'b0) ls0_ind  =  j[LSHIFT_IDW-1:0];
    get_ls0_ind  =  size? ls0_ind: '0;
endfunction

function automatic logic func_fillhit (
                                input T_PGSIZE  effsize0,
                                input T_PGSIZE  effsize1,
                                input T_SETADDR setaddr0,
                                input T_SETADDR setaddr1,
                                input [TLBID_WIDTH-1:0] tlbid0,
                                input [TLBID_WIDTH-1:0] tlbid1
);
    logic effsize_hit;
    logic addr_hit;
    logic tlbid_hit;
    
    effsize_hit = (effsize0 == effsize1);
    addr_hit = (setaddr0 == setaddr1);
    tlbid_hit = (tlbid0 == tlbid1);
    
    func_fillhit = effsize_hit && addr_hit && tlbid_hit;
endfunction

function automatic T_SETADDR getsetaddr(
                                input logic [REQ_PAYLOAD_MSB:12] addr, 
                                input logic [TLBID_WIDTH-1:0] tlbid, 
                                input T_PGSIZE pgsize
);
    logic [PS_MAX:PS_MIN][TLB_NUM_ARRAYS-1:0][REQ_PAYLOAD_MSB:12]  mask;
    
    for (int ps=PS_MIN; ps<=PS_MAX; ps++) begin
        for (int tlb=0; tlb<TLB_NUM_ARRAYS; tlb++) begin
            mask[ps][tlb] = '1 << (ps*9);
            if (TLB_NUM_SETS[tlb][ps] > 1) begin    // if there bits implied by the set address
               mask[ps][tlb] &= {(REQ_PAYLOAD_MSB+1-12){1'b1}} << (`HQM_DEVTLB_TLB_SET_MSB(TLB_NUM_SETS,tlb,ps) - 12 + 1);
            end
        end
    end
    
    getsetaddr = '0;
    for (int ps=PS_MIN; ps<=PS_MAX; ps++) begin
        if (ps == pgsize) getsetaddr = T_SETADDR'((addr[REQ_PAYLOAD_MSB:12]
                         & ~mask[ps][tlbid][REQ_PAYLOAD_MSB:12]           //lintra s-0241    TlbId stop at max, so won't be out of bounds
                         ) >> (ps*9)); // Mask away the non-set bits
    end
endfunction

typedef struct packed {
    logic [63:REQ_PAYLOAD_LSB]       Address; //[63:12]
    logic                            Size; //[11]
    logic                            N; //[10]
    logic [9:6]                      Reserved; //[9:6]
    logic                            Glob; //[5]
    logic                            Priv;//[4]
    logic                            X; //[3]
    logic                            U;//[2]
    logic                            W;//[1]
    logic                            R;//[0]
} t_devtlb_atsrsp_io;

`include "hqm_devtlb_tlb_params.vh"
localparam int FILLBLK = TLB_TAG_WR_CTRL-TLB_TAG_RD_CTRL-1; //N-1, N is the gap between 2 matching fill, 1 is used by FILLOUT.

//1st 3 pipe stages for ATS & Fill
localparam int MSTRKARB = 0;
localparam int MSTRKRDCTL = MSTRKARB + 1;
localparam int MSTRKRET = MSTRKRDCTL + 1;

//final stages for FILL
localparam int FILLPROC = MSTRKRET+1;
localparam int FILLOUT  = FILLPROC+1;
localparam int FILLEND  = FILLOUT+FILLBLK;
//final stage for ATS/INV/PRS
localparam int ATSOUT = MSTRKRET;
localparam int PRSOUT = MSTRKRET;
localparam int INVOUT = MSTRKRET+1;
localparam int ATSINVEND = MSTRKRET+1;

genvar g_stage, g_port, g_id, g_prio;

//-------------------------------------------------------------------------------
//  Global signals
//-------------------------------------------------------------------------------
logic [ATSREQ_PORTNUM-1:0]      AtsReqQPush;
logic                           FillReqPut, FillProcPrs;
logic                           AtsArbGnt;
logic                           PrsReqQPush, PrsArbGnt;

logic [ATSOUT:MSTRKRET][ATSREQ_PORTNUM-1:0]             AtsPipeV;
logic [INVOUT:MSTRKRET]                                 InvPipeV;
logic [PRSOUT:MSTRKRET]                                 PrsPipeV;
logic [FILLEND:MSTRKARB]                                FillPipeV;

logic [FILLBLK:0]                                       FillHitVec;
logic [FILLOUT:FILLPROC][FILLBLK:0]                     FillReqVBlock;

//-------------------------------------------------------------------------------
//  CLOCKING
//-------------------------------------------------------------------------------
   logic                                            pEn_ClkMsTrk_H;
   logic                                            ClkMsTrk_H;

always_comb begin
    pEn_ClkMsTrk_H = reset || MsTrkPut /*|| AtsArbGnt*/ || (|FillTLBOutV) || (|FillReqVBlock[FILLOUT]) || 
                    (|AtsPipeV[ATSOUT]) || (|(atsreq_ack & atsreq_vld)) || atsrsp_vld ||
                    (|PrsPipeV[PRSOUT]) || (|(prsreq_ack & prsreq_vld)) || prsrsp_vld || 
                    FillPipeV[FILLPROC] ||(|(FillReqV & FillGnt)) || 
                    (~&MsTrkVacant) || InvMsTrkStart || InvMsTrkBusy || InvMsTrkEnd;
end
`HQM_DEVTLB_MAKE_LCB_PWR(ClkMsTrk_H,  clk, pEn_ClkMsTrk_H,  PwrDnOvrd_nnnH)

   logic [ATSINVEND-1:MSTRKARB  ]             pEn_ClkAtsPrsInvPipe_H;
   logic [ATSINVEND  :MSTRKARB+1]             ClkAtsPrsInvPipe_H;

generate
for (g_stage = MSTRKARB+1; g_stage <= ATSINVEND; g_stage++) begin  : AtsPrsInvPipeState
         `HQM_DEVTLB_MAKE_LCB_PWR(ClkAtsPrsInvPipe_H[g_stage],  clk, pEn_ClkAtsPrsInvPipe_H[g_stage-1],  PwrDnOvrd_nnnH)
end
endgenerate

   logic [FILLEND-1:MSTRKARB  ]             pEn_ClkFillPipe_H;
   logic [FILLEND  :MSTRKARB+1]             ClkFillPipe_H;

generate
for (g_stage = MSTRKARB+1; g_stage <= FILLEND; g_stage++) begin  : FillPipeState
         `HQM_DEVTLB_MAKE_LCB_PWR(ClkFillPipe_H[g_stage],  clk, pEn_ClkFillPipe_H[g_stage-1],  PwrDnOvrd_nnnH)
end
endgenerate

//-------------------------------------------------------------------------------
// MsTrk Memory WEN (only from south, due to ATS Req input)
always_comb begin
    MsTrkReqWrEn   = MsTrkPut && ~reset;
    MsTrkReqWrAddr = MsTrkIdx;
    MsTrkReqWrData = MsTrkReq;
end

//-------------------------------------------------------------------------------
// MsTrk Memory WEN (only from south, due to ATS Req input)
t_devtlb_atsrsp_io atsrsp_data_i;
//logic              AtsRspNoFill;
always_comb atsrsp_data_i = t_devtlb_atsrsp_io'(atsrsp_data);

always_comb begin
    MsTrkRspWrEn   = atsrsp_vld && ~reset;
    MsTrkRspWrAddr = atsrsp_id;
    MsTrkRspWrData = '0;
    MsTrkRspWrData.HdrErr = atsrsp_hdrerr;
    MsTrkRspWrData.DPErr = atsrsp_dperr;
    MsTrkRspWrData.Address = atsrsp_data_i.Address[MAX_HOST_ADDRESS_WIDTH-1:REQ_PAYLOAD_LSB];
    MsTrkRspWrData.Size = atsrsp_data_i.Size;
    MsTrkRspWrData.Glob = TLB_GLOB_SUPP? atsrsp_data_i.Glob: '0;
    MsTrkRspWrData.N = atsrsp_data_i.N;
    MsTrkRspWrData.Priv = atsrsp_data_i.Priv;
    MsTrkRspWrData.X = ARSP_X_SUPP? atsrsp_data_i.X: '0;
    MsTrkRspWrData.U = ARSP_U_SUPP? atsrsp_data_i.U: '0;
    MsTrkRspWrData.W = (atsrsp_data_i.U && ~ARSP_U_SUPP)? '0: atsrsp_data_i.W;
    MsTrkRspWrData.R = (atsrsp_data_i.U && ~ARSP_U_SUPP)? '0: atsrsp_data_i.R;
    MsTrkRspWrData.Parity = '0;
    MsTrkRspWrData.Parity = `HQM_DEVTLB_CALC_PARITY(MsTrkRspWrData, 1'b0);
    //AtsRspNoFill = ~(MsTrkRspWrData.W | MsTrkRspWrData.R);
end

//-------------------------------------------------------------------------------
logic                                                   FillPipeStall;
logic [FILLPROC:MSTRKARB][MISSTRK_IDW-1:0]              FillPipeMsTrkId;
logic [FILLPROC:MSTRKARB]                               FillPipePrsReq;
t_devtlb_prsrsp_sts [FILLPROC:MSTRKARB]                 FillPipePrsSts;
logic                                                   FillMsTrkRen;
logic [MISSTRK_IDW-1:0]                                 FillMsTrkRdAddr;
logic [XREQ_PORTNUM-1:0]                                FillReqV_i;

logic                                                   AtsPrsInvPipeStall;
logic [ATSINVEND:MSTRKARB]                              AtsPrsInvPipeV;
logic [ATSINVEND:MSTRKARB][MISSTRK_IDW-1:0]             AtsPrsInvPipeMsTrkId;
logic [MSTRKRET:MSTRKARB]                               AtsPrsInvPipeIsInv, AtsPrsInvPipeIsAts, AtsPrsInvPipeIsPrs;

logic                                                   AtsMsTrkRen;
logic [MISSTRK_IDW-1:0]                                 AtsMsTrkRdAddr;

logic [MISSTRK_DEPTH-1:0]                               MsTrkPut_i, AtsPrsInvArbGnt, AtsReqAck, PrsReqAck, FillArbGnt;
logic [MISSTRK_DEPTH-1:0]                               PrsInit, PrsRspLegal;
t_mstrk_state [MISSTRK_DEPTH-1:0]                       MsTrkPs;
logic [MISSTRK_DEPTH-1:0]                               AtsRsp, PrsRsp, MsTrkNsIdle;
logic [MISSTRK_DEPTH-1:0]                               InvRsp, InvRspHit, InvBusy;
t_devtlb_prsrsp_sts                                     PrsRspSts;
logic                                                   PrsRspVld;

//------------------------------------------------------------------------------
//FILL pipe
always_comb FillPipeStall = |(FillReqV_i & ~FillGnt); //design intend is to never stall fill req
                                                      //due to this eq, last fillrsp of a port never backto mstrk at same clk.
                                                      //i.e no >1 fsm need to wakependq simultaneoulsy, no arb is needed.

always_comb begin
    for (int i=MSTRKARB+1; i<= FILLEND; i++) begin
        pEn_ClkFillPipe_H[i-1]  = reset
                                 | FillPipeV[i-1] | FillPipeV[i];
    end

    MsTrkFillInFlight = |{FillPipeV, FillReqV};
end

//MSTRKARB, arbitrate ats_req for RF ren
//fill always win
logic [MISSTRK_DEPTH-1:0]               FillArbReq, FillArbPrs, FillArbReqQ;
t_devtlb_prsrsp_sts [MISSTRK_DEPTH-1:0] FillArbPrsSts;

//MSTRKARB, arbitrate ats_req for RF ren
//InvMsTrkStart will prevent the AtsRsp arrive one clk after InvReq. InvReq processing has minimun 1 clk latency.
hqm_devtlb_rrarb #(.REQ_W (MISSTRK_DEPTH), .REQ_IDW (MISSTRK_IDW))
   rr_fill_arb (.clk (ClkFillPipe_H[MSTRKARB+1]), .rst_b (~reset), .arb_rs (~(FillPipeStall || InvMsTrkStart)), .arb_req (FillArbReqQ), .arb_gnt (FillPipeV[MSTRKARB]), .arb_gntid (FillPipeMsTrkId[MSTRKARB]));

always_comb begin
    FillPipePrsReq[MSTRKARB] = FillArbPrs[FillPipeMsTrkId[MSTRKARB]];
    FillPipePrsSts[MSTRKARB] = FillArbPrsSts[FillPipeMsTrkId[MSTRKARB]];
end
//MSTRKARB++
generate
for (g_stage=MSTRKARB+1; g_stage<=FILLEND; g_stage++) begin : gen_FillPipeV
if ((g_stage-1) == FILLPROC) begin : gen_FillPipeV_FIllPROC
    `HQM_DEVTLB_EN_RST_MSFF(FillPipeV[g_stage],(FillPipeV[g_stage-1] && ~FillProcPrs),ClkFillPipe_H[g_stage],~FillPipeStall,reset)
end else begin : gen_FillPipeV_OTHERS
    `HQM_DEVTLB_EN_RST_MSFF(FillPipeV[g_stage],FillPipeV[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall,reset)
end
end
endgenerate
generate
for (g_stage=MSTRKARB+1; g_stage<=FILLPROC; g_stage++) begin : gen_FillMsTrkId
    `HQM_DEVTLB_EN_MSFF(FillPipeMsTrkId[g_stage],FillPipeMsTrkId[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
    if(PRS_SUPP_EN) begin: gen_prs_en_pipe
        `HQM_DEVTLB_EN_RST_MSFF(FillPipePrsReq[g_stage],FillPipePrsReq[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall, reset)
        `HQM_DEVTLB_EN_RSTD_MSFF(FillPipePrsSts[g_stage],FillPipePrsSts[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall, reset, DEVTLB_PRSRSP_SUC)
    end else begin : gen_prs_dis_pipe
        always_comb begin
            FillPipePrsReq[g_stage] = '0;
            FillPipePrsSts[g_stage] = DEVTLB_PRSRSP_SUC;
        end
    end
end
endgenerate

//MSTRKRDCTL
logic [MSTRKRET:MSTRKRDCTL] FillMsTrkRenAck;
always_comb begin
    FillMsTrkRen = (FillPipeV[MSTRKRDCTL] && ~FillPipeStall); 
    FillMsTrkRdAddr = FillPipeMsTrkId[MSTRKRDCTL];
    FillMsTrkRenAck[MSTRKRDCTL] = FillMsTrkRen;
    
    MsTrkRspRdEn = FillMsTrkRen;
    MsTrkRspRdAddr = FillMsTrkRdAddr;
end
generate
for (g_stage=MSTRKRDCTL+1; g_stage<=MSTRKRET; g_stage++) begin : gen_FillRen
    `HQM_DEVTLB_RST_MSFF(FillMsTrkRenAck[g_stage],FillMsTrkRenAck[g_stage-1],ClkFillPipe_H[g_stage],reset)
end
endgenerate

//MSTRKRET
T_REQ                        FillMsTrkReqSaved;
T_REQ [FILLPROC:MSTRKRET]     FillMsTrkReqRdData;
T_ATSRSP                     FillMsTrkRspSaved;
T_ATSRSP [FILLPROC:MSTRKRET]  FillMsTrkRspRdData;
always_comb begin
    FillMsTrkReqRdData[MSTRKRET] = FillMsTrkRenAck[MSTRKRET]? MsTrkReqRdData: FillMsTrkReqSaved;
    FillMsTrkRspRdData[MSTRKRET] = FillMsTrkRenAck[MSTRKRET]? MsTrkRspRdData: FillMsTrkRspSaved;
    //TODO PERR
end
`HQM_DEVTLB_EN_MSFF(FillMsTrkReqSaved,MsTrkReqRdData,ClkFillPipe_H[MSTRKRET+1],FillMsTrkRenAck[MSTRKRET])
`HQM_DEVTLB_EN_MSFF(FillMsTrkRspSaved,MsTrkRspRdData,ClkFillPipe_H[MSTRKRET+1],FillMsTrkRenAck[MSTRKRET])

//MSTRKRET++
generate
for (g_stage=MSTRKRET+1; g_stage<=FILLPROC; g_stage++) begin: gen_FillData
    `HQM_DEVTLB_EN_MSFF(FillMsTrkReqRdData[g_stage],FillMsTrkReqRdData[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
    `HQM_DEVTLB_EN_MSFF(FillMsTrkRspRdData[g_stage],FillMsTrkRspRdData[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
end
endgenerate

//FILLPROC
logic FillReadFault_H, FillWriteFault_H;
logic atsrsp4k, atsrsp2M, atsrsp1G;
logic [LSHIFT_IDW-1:0] ls0_ind;

T_REQ      [FILLOUT:FILLPROC]   FillPipeReq;
T_REQ_CTRL [FILLOUT:FILLPROC]   FillPipeCtrl;
T_REQ_INFO [FILLOUT:FILLPROC]   FillPipeInfo;
T_SETADDR  [FILLEND:FILLPROC]   FillPipeSetAddr;
logic [FILLEND:FILLOUT][TLBID_WIDTH-1:0]     FillPipeTlbId;
T_PGSIZE   [FILLEND:FILLPROC]   FillPipeEffSize;
logic [FILLEND:FILLPROC]        FillPipeBadPRS; //FILLEND:FILLOUT+1 are for assertion only
logic                           BadPS;
logic [ARSP_ADDRW_MAX-1:PGOFFSET_W] vaMask;

always_comb begin
    ls0_ind  = get_ls0_ind(FillMsTrkRspRdData[FILLPROC].Size, FillMsTrkRspRdData[FILLPROC].Address);
    vaMask   = get_vamask(FillMsTrkRspRdData[FILLPROC].Size, FillMsTrkRspRdData[FILLPROC].Address);
    atsrsp4k = (ls0_ind==0);  //4K
    atsrsp2M = (ls0_ind==9);  //2M
    atsrsp1G = (ls0_ind==18);    //1G
    BadPS = &{FillMsTrkRspRdData[FILLPROC].Size, FillMsTrkRspRdData[FILLPROC].Address};

    FillPipeReq[FILLPROC] = FillMsTrkReqRdData[FILLPROC];
    FillPipeReq[FILLPROC].MsTrkIdx = FillPipeMsTrkId[FILLPROC];
    FillPipeReq[FILLPROC].Opcode = T_OPCODE'(DEVTLB_OPCODE_FILL);
    FillPipeCtrl[FILLPROC] = '0;
    FillPipeCtrl[FILLPROC].Fill = '1;
    FillPipeCtrl[FILLPROC].FillReqOp = (FillMsTrkReqRdData[FILLPROC].Opcode == T_OPCODE'(DEVTLB_OPCODE_UTRN_R));
    
    FillPipeInfo[FILLPROC]    = '0;
    FillPipeInfo[FILLPROC].ParityError = FillMsTrkRspRdData[FILLPROC].DPErr;
    FillPipeInfo[FILLPROC].HeaderError = FillMsTrkRspRdData[FILLPROC].HdrErr;
    FillPipeInfo[FILLPROC].Address = (FillMsTrkRspRdData[FILLPROC].Address & ( vaMask)) |
                                     (FillMsTrkReqRdData[FILLPROC].Address[MAX_HOST_ADDRESS_WIDTH-1:REQ_PAYLOAD_LSB] & (~vaMask));

    //instead of effsize, atsrsp size is needed by tlb to generate the final phy addr
    unique casez (1'b1)
        atsrsp4k: FillPipeInfo[FILLPROC].Size = T_PGSIZE'(SIZE_4K);
        atsrsp2M: FillPipeInfo[FILLPROC].Size = T_PGSIZE'(SIZE_2M);
        atsrsp1G: FillPipeInfo[FILLPROC].Size = T_PGSIZE'(SIZE_1G);
        default:  FillPipeInfo[FILLPROC].Size = T_PGSIZE'(SIZE_4K);
    endcase
   
    FillPipeBadPRS[FILLPROC] = FillMsTrkReqRdData[FILLPROC].Prs && ~(FillPipePrsSts[FILLPROC]==DEVTLB_PRSRSP_SUC);

    FillPipeInfo[FILLPROC].N = FillMsTrkRspRdData[FILLPROC].N;
    FillPipeInfo[FILLPROC].U = FillMsTrkRspRdData[FILLPROC].U;
    FillPipeInfo[FILLPROC].R = FillMsTrkRspRdData[FILLPROC].R && ~(BadPS || FillPipeBadPRS[FILLPROC]);
    FillPipeInfo[FILLPROC].W = FillMsTrkRspRdData[FILLPROC].W && ~(BadPS || FillPipeBadPRS[FILLPROC]);
    FillPipeInfo[FILLPROC].X = ARSP_X_SUPP && FillMsTrkRspRdData[FILLPROC].X && ~(BadPS || FillPipeBadPRS[FILLPROC]);
    FillPipeInfo[FILLPROC].Global = FillMsTrkRspRdData[FILLPROC].Glob;
    FillPipeInfo[FILLPROC].Priv_Data = '0;
    FillPipeInfo[FILLPROC].Memtype = '0;

    FillReadFault_H = f_dma_read_req(FillMsTrkReqRdData[FILLPROC].Opcode) && ~FillMsTrkRspRdData[FILLPROC].R;
    FillWriteFault_H = f_dma_write_req(FillMsTrkReqRdData[FILLPROC].Opcode) && ~FillMsTrkRspRdData[FILLPROC].W;
    FillPipeInfo[FILLPROC].Fault = FillReadFault_H || FillWriteFault_H;
    //priority casez (1'b1)
    //    FillWriteFault_H: FillPipeInfo[FILLPROC].FaultReason = T_FAULTREASON'(DEVTLB_FAULT_RSN_DMA_PAGE_W);
    //    FillReadFault_H: FillPipeInfo[FILLPROC].FaultReason = T_FAULTREASON'(DEVTLB_FAULT_RSN_DMA_PAGE_R);
    //    default: ;
    //endcase
    if (FillMsTrkReqRdData[FILLPROC].Prs && (~CrPrsDis) && (~FillPipePrsReq[FILLPROC]) && 
        (FillPipePrsSts[FILLPROC]==DEVTLB_PRSRSP_SUC) && FillPipeInfo[FILLPROC].Fault) begin
        FillPipeInfo[FILLPROC].PrsCode = DEVTLB_PRSRSP_RET;
    end else begin
        FillPipeInfo[FILLPROC].PrsCode = FillPipePrsSts[FILLPROC];
    end

    FillProcPrs = (FillReadFault_H || FillWriteFault_H) && FillPipePrsReq[FILLPROC] &&
                  ~(FillMsTrkRspRdData[FILLPROC].HdrErr || FillMsTrkRspRdData[FILLPROC].DPErr);
    FillReqPut  = FillPipeV[FILLPROC] && (~FillProcPrs) && ~FillPipeStall;

    // Find largest PageSize TLB array that is equal to or smaller than the calculated pagesize.
    // This fractures large pages down to the first available TLB that can represent the page.
    //
    FillPipeEffSize[FILLPROC] = T_PGSIZE'(SIZE_4K);
    for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin : Fill_Eff_PS_Lp
        if ((tlb_ps <= FillPipeInfo[FILLPROC].Size) && (TLB_NUM_SETS[`HQM_DEVTLB_GET_TLBID(FillPipeReq[FILLPROC].TlbId, tlb_ps)][tlb_ps] > 0) && ~CrTLBPsDis[tlb_ps])  //lintra s-0241    TlbId stop at max, so won't be out of bounds
            FillPipeEffSize[FILLPROC] = T_PGSIZE'(f_IOMMU_Int_2_PS(tlb_ps));
    end
    for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin : Fill_DisRd_PS_Lp
            FillPipeCtrl[FILLPROC].DisRdEn[tlb_ps] = ~(FillPipeEffSize[FILLPROC] == T_PGSIZE'(f_IOMMU_Int_2_PS(tlb_ps)));
    end

   FillPipeSetAddr[FILLPROC]  = getsetaddr(FillPipeReq[FILLPROC].Address, TLBID_WIDTH'(`HQM_DEVTLB_GET_TLBID(FillPipeReq[FILLPROC].TlbId, FillPipeEffSize[FILLPROC])), FillPipeEffSize[FILLPROC]);
end

always_comb begin
    for (int i=FILLBLK; i>=0; i--) begin
        FillHitVec[i] = (FillPipeV[FILLPROC] && (~FillProcPrs)) &&
                        (FillPipeV[FILLPROC+1+i]) &&
                      func_fillhit(FillPipeEffSize[FILLPROC],   FillPipeEffSize[FILLPROC+1+i],
                                   FillPipeSetAddr[FILLPROC],   FillPipeSetAddr[FILLPROC+1+i],
                                   TLBID_WIDTH'(`HQM_DEVTLB_GET_TLBID(FillPipeReq[FILLPROC].TlbId, FillPipeEffSize[FILLPROC])),
                                   TLBID_WIDTH'(`HQM_DEVTLB_GET_TLBID(FillPipeTlbId[FILLPROC+1+i], FillPipeEffSize[FILLPROC+1+i])) );
    end
                               
    FillReqVBlock[FILLPROC] = '0;
    for (int i=FILLBLK; i>=0; i--) begin
        if (FillHitVec[i]) FillReqVBlock[FILLPROC] = ('1 >> i); //spyglass disable W164b
    end
    
    FillReqVBlock[FILLPROC]= (|FillReqVBlock[FILLOUT])? (FillReqVBlock[FILLOUT]>>1): FillReqVBlock[FILLPROC]; //spyglass disable W164b
end

//FILLPROC++
`HQM_DEVTLB_EN_RST_MSFF(FillReqVBlock[FILLOUT],FillReqVBlock[FILLPROC],ClkMsTrk_H,((|FillReqVBlock[FILLOUT]) || ~FillPipeStall),reset)

generate
for (g_stage=FILLPROC+1; g_stage<=FILLOUT; g_stage++) begin: gen_FillStruct
`HQM_DEVTLB_EN_MSFF(FillPipeReq[g_stage],FillPipeReq[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
`HQM_DEVTLB_EN_MSFF(FillPipeCtrl[g_stage],FillPipeCtrl[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
`HQM_DEVTLB_EN_MSFF(FillPipeInfo[g_stage],FillPipeInfo[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
end
endgenerate

generate
for (g_stage=FILLPROC+1; g_stage<=FILLEND; g_stage++) begin: gen_FillSetAddr
`HQM_DEVTLB_EN_MSFF(FillPipeSetAddr[g_stage],FillPipeSetAddr[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
`HQM_DEVTLB_EN_MSFF(FillPipeEffSize[g_stage],FillPipeEffSize[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
`HQM_DEVTLB_EN_MSFF(FillPipeBadPRS[g_stage],FillPipeBadPRS[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
end
endgenerate

//FILLOUT
generate
for (g_port=0; g_port<XREQ_PORTNUM; g_port++) begin: gen_FillReqV
    `HQM_DEVTLB_EN_RST_MSFF(FillReqV_i[g_port],(FillReqPut || (FillReqV_i[g_port] && ~FillGnt[g_port])),ClkMsTrk_H, (FillReqPut || FillGnt[g_port]),reset)
end
endgenerate

generate
    for (g_port=0; g_port<XREQ_PORTNUM; g_port++) begin: gen_FillReq_port
        always_comb begin
            FillReqV[g_port] = FillReqV_i[g_port];
            FillReqV[0]      &= ~|FillReqVBlock[FILLOUT]; 
            FillReq[g_port]  = FillPipeReq[FILLOUT];
            FillCtrl[g_port] = FillPipeCtrl[FILLOUT];
            FillCtrl[g_port].CtrlFlg.FillLast = (FillReqV==FillGnt);
            FillInfo[g_port] = FillPipeInfo[FILLOUT];
            FillInfo[g_port].EffSize = FillPipeEffSize[FILLOUT];
        end
    end
endgenerate

//FILLOUT++
always_comb begin
    FillPipeTlbId[FILLOUT]    = FillPipeReq[FILLOUT].TlbId;
end

generate
for (g_stage=FILLOUT+1; g_stage<=FILLEND; g_stage++) begin: gen_Block
`HQM_DEVTLB_EN_MSFF(FillPipeTlbId[g_stage],FillPipeTlbId[g_stage-1],ClkFillPipe_H[g_stage],~FillPipeStall)
end
endgenerate

//------------------------------------------------------------------------------
//ATS/INV pipe
always_comb AtsPrsInvPipeStall = 1'b0;

always_comb begin
    for (int i=MSTRKARB+1; i<= ATSINVEND; i++) begin
        pEn_ClkAtsPrsInvPipe_H[i-1]  = reset
                                 | AtsPrsInvPipeV[i-1] | AtsPrsInvPipeV[i];
    end
end

logic [MISSTRK_DEPTH-1:0]                   AtsPrsInvArbReq, InvArbReq, AtsArbReq, PrsArbReq, MsTrkPrio; 
logic [HPXREQ:LPXREQ]                       AtsReqQCrdAvail, AtsReqBlk;
logic                                       PrsReqQCrdAvail;

always_comb begin
    for (int i=0; i<MISSTRK_DEPTH; i++) begin
        AtsPrsInvArbReq[i] = (AtsArbReq[i] && (MsTrkPrio[i]? 
                                                (AtsReqQCrdAvail[HPXREQ] && ~AtsReqBlk[HPXREQ]): 
                                                (AtsReqQCrdAvail[LPXREQ] && ~AtsReqBlk[LPXREQ]))) ||
                             (PrsArbReq[i] && PrsReqQCrdAvail) ||
                             (InvArbReq[i]);
    end
end

//MSTRKARB, arbitrate ats_req for RF ren
hqm_devtlb_rrarb #(.REQ_W (MISSTRK_DEPTH), .REQ_IDW (MISSTRK_IDW))
   rr_atsinv_arb (.clk (ClkAtsPrsInvPipe_H[MSTRKARB+1]), .rst_b (~reset), .arb_rs (~(AtsPrsInvPipeStall || ((~FillPipeStall) && |FillArbReqQ) || FillMsTrkRen)), .arb_req (AtsPrsInvArbReq), .arb_gnt (AtsPrsInvPipeV[MSTRKARB]), .arb_gntid (AtsPrsInvPipeMsTrkId[MSTRKARB]));

always_comb begin
     AtsPrsInvPipeIsInv[MSTRKARB] = (InvArbReq[AtsPrsInvPipeMsTrkId[MSTRKARB]]);
     AtsPrsInvPipeIsAts[MSTRKARB] = (AtsArbReq[AtsPrsInvPipeMsTrkId[MSTRKARB]]);
     AtsPrsInvPipeIsPrs[MSTRKARB] = (PrsArbReq[AtsPrsInvPipeMsTrkId[MSTRKARB]]);
end

//MSTRKARB++
    `HQM_DEVTLB_EN_RST_MSFF(AtsPrsInvPipeV[MSTRKRDCTL],AtsPrsInvPipeV[MSTRKRDCTL-1],ClkAtsPrsInvPipe_H[MSTRKRDCTL],~(AtsPrsInvPipeStall || FillMsTrkRen),reset)
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeMsTrkId[MSTRKRDCTL],AtsPrsInvPipeMsTrkId[MSTRKRDCTL-1],ClkAtsPrsInvPipe_H[MSTRKRDCTL],~(AtsPrsInvPipeStall || FillMsTrkRen))
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeIsInv[MSTRKRDCTL],AtsPrsInvPipeIsInv[MSTRKRDCTL-1],ClkAtsPrsInvPipe_H[MSTRKRDCTL],~(AtsPrsInvPipeStall || FillMsTrkRen))
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeIsAts[MSTRKRDCTL],AtsPrsInvPipeIsAts[MSTRKRDCTL-1],ClkAtsPrsInvPipe_H[MSTRKRDCTL],~(AtsPrsInvPipeStall || FillMsTrkRen))
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeIsPrs[MSTRKRDCTL],AtsPrsInvPipeIsPrs[MSTRKRDCTL-1],ClkAtsPrsInvPipe_H[MSTRKRDCTL],~(AtsPrsInvPipeStall || FillMsTrkRen))
    
    `HQM_DEVTLB_EN_RST_MSFF(AtsPrsInvPipeV[MSTRKRET],AtsMsTrkRen,ClkAtsPrsInvPipe_H[MSTRKRET],~AtsPrsInvPipeStall,reset)
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeMsTrkId[MSTRKRET],AtsPrsInvPipeMsTrkId[MSTRKRDCTL],ClkAtsPrsInvPipe_H[MSTRKRET],~AtsPrsInvPipeStall)
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeIsInv[MSTRKRET],AtsPrsInvPipeIsInv[MSTRKRDCTL],ClkAtsPrsInvPipe_H[MSTRKRET],~AtsPrsInvPipeStall)
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeIsAts[MSTRKRET],AtsPrsInvPipeIsAts[MSTRKRDCTL],ClkAtsPrsInvPipe_H[MSTRKRET],~AtsPrsInvPipeStall)
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeIsPrs[MSTRKRET],AtsPrsInvPipeIsPrs[MSTRKRDCTL],ClkAtsPrsInvPipe_H[MSTRKRET],~AtsPrsInvPipeStall)

generate
for (g_stage=MSTRKRET+1; g_stage<=ATSINVEND; g_stage++) begin: gen_AtsInvV
    `HQM_DEVTLB_EN_RST_MSFF(AtsPrsInvPipeV[g_stage],AtsPrsInvPipeV[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],~AtsPrsInvPipeStall,reset)
    `HQM_DEVTLB_EN_MSFF(AtsPrsInvPipeMsTrkId[g_stage],AtsPrsInvPipeMsTrkId[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],~AtsPrsInvPipeStall)
end
endgenerate

//MSTRKRDCTL
logic [MSTRKRET:MSTRKRDCTL] AtsMsTrkRenAck;
always_comb begin
    AtsMsTrkRen = (AtsPrsInvPipeV[MSTRKRDCTL] && ~(AtsPrsInvPipeStall || FillMsTrkRen) && ~reset); 
    AtsMsTrkRdAddr = AtsPrsInvPipeMsTrkId[MSTRKRDCTL];
    AtsMsTrkRenAck[MSTRKRDCTL] = AtsMsTrkRen;
end
generate
for (g_stage=MSTRKRDCTL+1; g_stage<=MSTRKRET; g_stage++) begin: gen_AtsRen
    `HQM_DEVTLB_RST_MSFF(AtsMsTrkRenAck[g_stage],AtsMsTrkRenAck[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],reset)
end
endgenerate

//MSTRKRET
logic [MSTRKRET:MSTRKRET]                   MsTrkRdDataPErr;
logic [MSTRKRET:MSTRKRET]                   InvVAHit, InvPasidHit, InvBDFHit;
logic [INVOUT:MSTRKRET]                     InvPipeHit;
T_REQ                                       AtsMsTrkSaved;
T_REQ [ATSOUT:MSTRKRET]                     AtsMsTrkRdData;
always_comb begin
    AtsMsTrkRdData[MSTRKRET] = AtsMsTrkRenAck[MSTRKRET]? MsTrkReqRdData: AtsMsTrkSaved;
    MsTrkRdDataPErr[MSTRKRET] = '0; //TODO

    //ATS
    AtsPipeV[MSTRKRET][0] = AtsPrsInvPipeV[MSTRKRET] && ~AtsMsTrkRdData[MSTRKRET].Priority
                            && AtsPrsInvPipeIsAts[MSTRKRET];
    for (int i=1; i<ATSREQ_PORTNUM; i++) begin
        AtsPipeV[MSTRKRET][i] = AtsPrsInvPipeV[MSTRKRET] && AtsMsTrkRdData[MSTRKRET].Priority
                                && AtsPrsInvPipeIsAts[MSTRKRET];
    end
    
    //PRS
    PrsPipeV[MSTRKRET]   = AtsPrsInvPipeV[MSTRKRET] && AtsPrsInvPipeIsPrs[MSTRKRET];

    //INV
    InvPipeV[MSTRKRET]   = AtsPrsInvPipeV[MSTRKRET] && AtsPrsInvPipeIsInv[MSTRKRET];
    //MSTrk entry need to re-request ATS if it hit Invalidation request
    InvBDFHit[MSTRKRET]  = (InvBdfV && BDF_SUPP_EN)? (InvBDF==AtsMsTrkRdData[MSTRKRET].BDF): '1;

    if (InvPasidV && PASID_SUPP_EN)
        InvPasidHit[MSTRKRET]    = AtsMsTrkRdData[MSTRKRET].PasidV && ((InvPASID == AtsMsTrkRdData[MSTRKRET].PASID) || InvGlob);
    else
        InvPasidHit[MSTRKRET]    = '1;

    //all zero if the atc va falled in inv va range
    InvVAHit[MSTRKRET]   = ((~|((InvAddr ^ AtsMsTrkRdData[MSTRKRET].Address) & ~InvAddrMask)) && (~InvAOR)) ||
                           (PASID_SUPP_EN && AtsMsTrkRdData[MSTRKRET].PasidV && ~InvPasidV);
                       
    InvPipeHit[MSTRKRET] = ((InvBDFHit[MSTRKRET] && InvPasidHit[MSTRKRET] && InvVAHit[MSTRKRET]) || MsTrkRdDataPErr[MSTRKRET]);
end
`HQM_DEVTLB_EN_MSFF(AtsMsTrkSaved,MsTrkReqRdData,ClkAtsPrsInvPipe_H[MSTRKRET+1],AtsMsTrkRenAck[MSTRKRET])

//MSTRKRET++
generate
if(MSTRKRET<ATSOUT) begin : gen_AtsPrsOut0
    for (g_stage=MSTRKRET+1; g_stage<=ATSOUT; g_stage++) begin : gen_AtsOut1
        `HQM_DEVTLB_EN_RST_MSFF(AtsPipeV[g_stage],AtsPipeV[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],~AtsPrsInvPipeStall,reset)
        `HQM_DEVTLB_EN_RST_MSFF(PrsPipeV[g_stage],PrsPipeV[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],~AtsPrsInvPipeStall,reset)
        `HQM_DEVTLB_EN_MSFF(AtsMsTrkRdData[g_stage],AtsMsTrkRdData[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],~AtsPrsInvPipeStall)
    end
end
for (g_stage=MSTRKRET+1; g_stage<=INVOUT; g_stage++) begin : gen_InvOut
    `HQM_DEVTLB_EN_RST_MSFF(InvPipeV[g_stage],InvPipeV[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],~AtsPrsInvPipeStall,reset)
    `HQM_DEVTLB_EN_MSFF(InvPipeHit[g_stage],InvPipeHit[g_stage-1],ClkAtsPrsInvPipe_H[g_stage],~AtsPrsInvPipeStall)
end
endgenerate

//ATSOUT
typedef struct packed {
    logic [REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB] addr;
    logic [BDF_WIDTH-1:0]            BDF;
    logic                            PasidV;           // Valid PASID input
    logic [PASID_WIDTH-1:0]          PASID;            // PCIE Function ID for ATS
    logic                            PR;               // Privileged Mode Request
    logic [MISSTRK_IDW-1:0]          ID;
    logic [2:0]                      tc;
    //logic [2:0]                      vc;
    logic                            nw;
} t_atsreq; 

logic    [ATSREQ_PORTNUM-1:0] AtsReqQPop, AtsReqQFull, AtsReqQAvail;
t_atsreq [ATSREQ_PORTNUM-1:0] AtsReqQDIn, AtsReqQDOut;

always_comb begin
   for (int i=0; i<ATSREQ_PORTNUM; i++) begin
        AtsReqQPush[i] =  AtsPipeV[ATSOUT][i] && (~AtsReqQFull[i]) && ~AtsPrsInvPipeStall;
        
        AtsReqQDIn[i].addr = AtsMsTrkRdData[ATSOUT].Address;
        AtsReqQDIn[i].BDF  = AtsMsTrkRdData[ATSOUT].BDF;
        AtsReqQDIn[i].PasidV  = AtsMsTrkRdData[ATSOUT].PasidV;
        AtsReqQDIn[i].PR      = AtsMsTrkRdData[ATSOUT].PR;
        AtsReqQDIn[i].PASID   = AtsMsTrkRdData[ATSOUT].PASID;
        AtsReqQDIn[i].ID = AtsPrsInvPipeMsTrkId[ATSOUT];
        AtsReqQDIn[i].tc = AtsMsTrkRdData[ATSOUT].tc; // use param or cfg
//        AtsReqQDIn[i].vc = AtsMsTrkRdData[ATSOUT].vc; // use param or cfg
        AtsReqQDIn[i].nw = ~(AtsMsTrkRdData[ATSOUT].Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_W));
    end
end
//INVOUT

//--------------------------------------------------------
//ATSREQ Q
logic [HPXREQ:LPXREQ][ATSREQQ_IDW:0]    AtsReqQCrd, NxtAtsReqQCrd;
logic [HPXREQ:LPXREQ]                   AtsReqQCrdInc, AtsReqQCrdDec;

always_comb begin
    AtsArbGnt = AtsPrsInvPipeV[MSTRKARB] && AtsArbReq[AtsPrsInvPipeMsTrkId[MSTRKARB]];
    
    AtsReqQCrdDec[LPXREQ] = AtsArbGnt && ~MsTrkPrio[AtsPrsInvPipeMsTrkId[MSTRKARB]];
    AtsReqQCrdDec[HPXREQ] = AtsArbGnt &&  MsTrkPrio[AtsPrsInvPipeMsTrkId[MSTRKARB]];

    for (int j=LPXREQ; j<=HPXREQ; j++) begin
        AtsReqQCrdInc[j] = AtsReqQPop[j];        
        NxtAtsReqQCrd[j] = (AtsReqQCrdInc[j] ^ AtsReqQCrdDec[j])? 
                          (AtsReqQCrd[j] + {{(ATSREQQ_IDW){AtsReqQCrdDec[j]}},1'b1}): AtsReqQCrd[j];
    end
end

generate
for (g_id=LPXREQ; g_id<=HPXREQ; g_id++) begin : gen_crd_prio
    `HQM_DEVTLB_RSTD_MSFF(AtsReqQCrd[g_id],NxtAtsReqQCrd[g_id],ClkMsTrk_H,reset,ATSREQQ_DEPTH)
    `HQM_DEVTLB_RST_MSFF(AtsReqQCrdAvail[g_id],(NxtAtsReqQCrd[g_id]!='0),ClkMsTrk_H,reset)
end
endgenerate

logic [ATSREQ_PORTNUM-1:0][MISSTRK_IDW:0]       AtsReqCnt, NxtAtsReqCnt, CrMaxATSReq;
logic [MISSTRK_IDW:0]                           AtsReqTCnt, NxtAtsReqTCnt;

always_comb begin
    CrMaxATSReq[0] = CrTMaxATSReq - HPMSTRK_CRDT[MISSTRK_IDW:0];
    CrMaxATSReq[1] = CrTMaxATSReq - LPMSTRK_CRDT[MISSTRK_IDW:0];

    NxtAtsReqCnt[0] = (CrTMaxATSReqEn && (AtsReqQCrdDec[0] ^ (atsrsp_vld && ~MsTrkPrio[atsrsp_id])))? 
                      (AtsReqCnt[0] + {{(MISSTRK_IDW){(atsrsp_vld && ~MsTrkPrio[atsrsp_id])}}, 1'b1}):
                      AtsReqCnt[0];
    NxtAtsReqCnt[1] = (CrTMaxATSReqEn && (AtsReqQCrdDec[1] ^ (atsrsp_vld &&  MsTrkPrio[atsrsp_id])))? 
                      (AtsReqCnt[1] + {{(MISSTRK_IDW){(atsrsp_vld &&  MsTrkPrio[atsrsp_id])}}, 1'b1}):
                      AtsReqCnt[1];
    NxtAtsReqTCnt   = (CrTMaxATSReqEn && ((|AtsReqQCrdDec) ^ atsrsp_vld))? 
                      (AtsReqTCnt + {{(MISSTRK_IDW){atsrsp_vld}}, 1'b1}):
                      AtsReqTCnt;
end

`HQM_DEVTLB_RST_MSFF(AtsReqCnt[0],NxtAtsReqCnt[0],ClkMsTrk_H,reset)
`HQM_DEVTLB_RST_MSFF(AtsReqCnt[1],NxtAtsReqCnt[1],ClkMsTrk_H,reset)
`HQM_DEVTLB_RST_MSFF(AtsReqTCnt,NxtAtsReqTCnt,ClkMsTrk_H,reset)

`HQM_DEVTLB_RST_MSFF(AtsReqBlk[0],(CrTMaxATSReqEn && ((NxtAtsReqCnt[0]==CrMaxATSReq[0]) || (NxtAtsReqTCnt==CrTMaxATSReq)) && ~(CrTMaxATSReq=='0)),ClkMsTrk_H,reset)
`HQM_DEVTLB_RST_MSFF(AtsReqBlk[1],(CrTMaxATSReqEn && ((NxtAtsReqCnt[1]==CrMaxATSReq[1]) || (NxtAtsReqTCnt==CrTMaxATSReq)) && ~(CrTMaxATSReq=='0)),ClkMsTrk_H,reset)

generate
for (genvar i=0; i<ATSREQ_PORTNUM; i++) begin : gen_atsreqq
    hqm_devtlb_fifo
    #(
        .NO_POWER_GATING(NO_POWER_GATING),
        .T_REQ(t_atsreq),
        .ENTRIES(ATSREQQ_DEPTH)
    ) atsreq_fifo
    (
        .clk(ClkMsTrk_H),
        .rst_b(~reset),
        .reset_INST(reset_INST),
        .fscan_latchopen,
        .fscan_latchclosed_b,
        .full(AtsReqQFull[i]),
        .push(AtsReqQPush[i]),
        .wraddr(), // lintra s-0214
        .din(AtsReqQDIn[i]),
        .avail(AtsReqQAvail[i]),
        .pop(AtsReqQPop[i]),
        .rdaddr0(), // lintra s-0214
        .dout(AtsReqQDOut[i]),
        .array() // lintra s-0214
    );
end
endgenerate

always_comb begin
    for (int i=0; i<ATSREQ_PORTNUM; i++) begin
        atsreq_vld[i] =  AtsReqQAvail[i];
        AtsReqQPop[i] = atsreq_ack[i];
        
        atsreq_addr[i] = AtsReqQDOut[i].addr;
        atsreq_bdf[i] = AtsReqQDOut[i].BDF;
        atsreq_pasid_vld[i] = AtsReqQDOut[i].PasidV;
        atsreq_pasid_priv[i] = AtsReqQDOut[i].PR;
        atsreq_pasid[i] = AtsReqQDOut[i].PASID;
        atsreq_id[i] = AtsReqQDOut[i].ID;
        atsreq_tc[i] = AtsReqQDOut[i].tc; // use param or cfg
//        atsreq_vc[i] = AtsReqQDOut[i].vc; // use param or cfg
        atsreq_nw[i] = AtsReqQDOut[i].nw; 
    end
end

//--------------------------------------------------------
//PRSOUT
typedef struct packed {
    logic [REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB] addr;
    logic [BDF_WIDTH-1:0]            BDF;
    logic                            PasidV;           // Valid PASID input
    logic [PASID_WIDTH-1:0]          PASID;            // PCIE Function ID for ATS
    logic                            PR;               // Privileged Mode Request
    logic [MISSTRK_IDW-1:0]          ID;
    logic                            nw;
} t_prsreq; 

logic    PrsReqQPop, PrsReqQFull, PrsReqQAvail;
t_prsreq PrsReqQDIn, PrsReqQDOut;

always_comb begin
        PrsReqQPush =  PrsPipeV[ATSOUT] && (~PrsReqQFull) && ~AtsPrsInvPipeStall;
        
        PrsReqQDIn.addr = AtsMsTrkRdData[PRSOUT].Address;
        PrsReqQDIn.BDF  = AtsMsTrkRdData[PRSOUT].BDF;
        PrsReqQDIn.PasidV  = AtsMsTrkRdData[PRSOUT].PasidV;
        PrsReqQDIn.PR      = AtsMsTrkRdData[PRSOUT].PR;
        PrsReqQDIn.PASID   = AtsMsTrkRdData[PRSOUT].PASID;
        PrsReqQDIn.ID = AtsPrsInvPipeMsTrkId[PRSOUT];
        PrsReqQDIn.nw = ~(AtsMsTrkRdData[ATSOUT].Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_W));
end
//--------------------------------------------------------
//PRSREQ Q
logic [PRSREQQ_IDW:0]    PrsReqQCrd, NxtPrsReqQCrd;
logic                    PrsReqQCrdInc, PrsReqQCrdDec;

always_comb begin
    PrsArbGnt = AtsPrsInvPipeV[MSTRKARB] && PrsArbReq[AtsPrsInvPipeMsTrkId[MSTRKARB]];
    PrsReqQCrdDec = PrsArbGnt;

    PrsReqQCrdInc = PrsReqQPop;        
    NxtPrsReqQCrd = (PrsReqQCrdInc ^ PrsReqQCrdDec)? 
                      (PrsReqQCrd + {{(PRSREQQ_IDW){PrsReqQCrdDec}},1'b1}): PrsReqQCrd;
end

`HQM_DEVTLB_RSTD_MSFF(PrsReqQCrd,NxtPrsReqQCrd,ClkMsTrk_H,reset,PRSREQQ_DEPTH)
`HQM_DEVTLB_RST_MSFF(PrsReqQCrdAvail,(NxtPrsReqQCrd!='0),ClkMsTrk_H,reset)

hqm_devtlb_fifo
#(
    .NO_POWER_GATING(NO_POWER_GATING),
    .T_REQ(t_prsreq),
    .ENTRIES(PRSREQQ_DEPTH)
) prsreq_fifo
(
    .clk(ClkMsTrk_H),
    .rst_b(~reset),
    .reset_INST(reset_INST),
    .fscan_latchopen,
    .fscan_latchclosed_b,
    .full(PrsReqQFull),
    .push(PrsReqQPush),
    .wraddr(), // lintra s-0214
    .din(PrsReqQDIn),
    .avail(PrsReqQAvail),
    .pop(PrsReqQPop),
    .rdaddr0(), // lintra s-0214
    .dout(PrsReqQDOut),
    .array() // lintra s-0214
);


logic [MISSTRK_IDW:0]            PrsReqCnt;
logic                            PrsReqBlk;

`HQM_DEVTLB_EN_RST_MSFF(PrsReqCnt,(PrsReqCnt + {{(MISSTRK_IDW){PrsRspVld}}, 1'b1}),ClkMsTrk_H,(prsreq_ack ^ PrsRspVld), reset)
`HQM_DEVTLB_RST_MSFF(PrsReqBlk,(PrsReqCnt > CrPrsReqAlloc),ClkMsTrk_H,reset)

always_comb begin
        prsreq_vld = PrsReqQAvail && (~PrsReqBlk) && ~(PrsReqCnt==CrPrsReqAlloc);
        PrsReqQPop = prsreq_ack;
        
        prsreq_addr = PrsReqQDOut.addr;
        prsreq_bdf = PrsReqQDOut.BDF;
        prsreq_pasid_vld = PrsReqQDOut.PasidV;
        prsreq_pasid_priv = PrsReqQDOut.PR;
        prsreq_pasid = PrsReqQDOut.PASID;
        prsreq_id = PrsReqQDOut.ID;
        prsreq_W = ~PrsReqQDOut.nw;
        prsreq_R = '1;
end

`HQM_DEVTLB_RST_MSFF(CrPrsStsUprgi,(prsrsp_vld && (|prsrsp_id[8:MISSTRK_IDW] || ~PrsRspLegal[prsrsp_id[MISSTRK_IDW-1:0]])),ClkMsTrk_H,reset)
`HQM_DEVTLB_RST_MSFF(CrPrsStsRf,((prsrsp_vld && PrsRspLegal[prsrsp_id]) && (PrsRspSts == DEVTLB_PRSRSP_FAIL)),ClkMsTrk_H,reset)
`HQM_DEVTLB_RSTD_MSFF(CrPrsStsStopped,(PrsReqCnt=='0) && (~|{PrsReqQAvail, PrsPipeV, (AtsPrsInvPipeV[MSTRKRDCTL] && AtsPrsInvPipeIsPrs[MSTRKRDCTL]), PrsArbReq}),ClkMsTrk_H,reset,1'b1)

//--------------------------------------------------------
//MSTRK RF ACCESS
//MSTRKRDCTL
always_comb begin
    //assert 2 terms in RHS below need to be onehot
    MsTrkReqRdEn = (AtsMsTrkRen || FillMsTrkRen) && ~reset; 
    MsTrkReqRdAddr = FillMsTrkRen? FillMsTrkRdAddr: AtsMsTrkRdAddr;
end

//---------------------------------------------------------
// PendQ Wake - stages for Passing Replay Info from TLB to PendQ Wake PPipe
localparam int PWAKE_INFO_DLY = 1; //from FILLRsp->FillTrk=='1-> PWakeArbReq
t_wakeinfo [PWAKE_INFO_DLY:0] PWakeInfo;

always_comb begin
    for (int i=0; i<XREQ_PORTNUM; i++) begin
        if (FillTLBOutV[i] && FillTLBOutInfo[i].FillLast) begin
            PWakeInfo[0].ForceXRsp = ~(FillTLBOutInfo[i].W || FillTLBOutInfo[i].R);
            PWakeInfo[0].PrsCode   = FillTLBOutInfo[i].PrsCode;
            PWakeInfo[0].HdrErr    = FillTLBOutInfo[i].HdrErr;
            PWakeInfo[0].DPErr     = FillTLBOutInfo[i].DPErr;
        end else begin
            PWakeInfo[0] = '0;
        end
    end
end

generate
for (g_stage=1; g_stage<=PWAKE_INFO_DLY; g_stage++) begin: gen_PWakeInfo
    `HQM_DEVTLB_MSFF(PWakeInfo[g_stage],PWakeInfo[g_stage-1],ClkMsTrk_H)
end
endgenerate

//---------------------------------------------------------
// PendQ Wake Pipe
//PENDQWAKE_DLY_CNT = Lat from MsTrkPop to PWake, set to MSPROC pipe len (MSPROC_OUT- MSPROC_ARB), ensure last PendQPut, which is qualified by MsTrkVld, is one clk before Pwake. Only works if msproc pipestall is  always 0// TODO CP_
localparam int PENDQWAKE_DLY_CNT = 2; 

localparam int PWAKEARB = 0;
localparam int PWAKEDLY = PWAKEARB+PENDQWAKE_DLY_CNT-1;
localparam int PWAKEOUT = PWAKEDLY+1;

logic [PWAKEOUT-1:PWAKEARB  ]               pEn_ClkPWakePipe_H;
logic [PWAKEOUT  :PWAKEARB+1]               ClkPWakePipe_H;
logic                                       PWakePipeStall;
logic [PWAKEOUT:PWAKEARB]                   PWakePipeV;
logic [PWAKEOUT:PWAKEARB][MISSTRK_IDW-1:0]  PWakePipeMsTrkId;
t_wakeinfo [PWAKEOUT:PWAKEARB]              PWakePipeInfo;

generate
for (g_stage = PWAKEARB+1; g_stage <= PWAKEOUT; g_stage++) begin  : PWakePipeState
         `HQM_DEVTLB_MAKE_LCB_PWR(ClkPWakePipe_H[g_stage],  clk, pEn_ClkPWakePipe_H[g_stage-1],  PwrDnOvrd_nnnH)
end
endgenerate

always_comb PWakePipeStall = 1'b0;

always_comb begin
    for (int i=PWAKEARB+1; i<= PWAKEOUT; i++) begin
        pEn_ClkPWakePipe_H[i-1]  = reset
                                 | PWakePipeV[i-1] | PWakePipeV[i];
    end
end

logic [MISSTRK_DEPTH-1:0]                   PWakeArbReq, PWakeArbGnt; 

//PWAKEARB, arbitrate ats_req for RF ren
/*devtlb_rrarb #(.REQ_W (MISSTRK_DEPTH), .REQ_IDW (MISSTRK_IDW))
   rr_pwake_arb (.clk (ClkPWakePipe_H[PWAKEARB+1]), .rst_b (~reset), .arb_rs (~PWakePipeStall), .arb_req (PWakeArbReq), .arb_gnt (PWakePipeV[PWAKEARB]), .arb_gntid (PWakePipeMsTrkId[PWAKEARB]));
*/
always_comb begin
    PWakePipeV[PWAKEARB] = |PWakeArbReq;
    PWakePipeMsTrkId[PWAKEARB] = get_idx(PWakeArbReq);
end

always_comb begin
     PWakePipeInfo[PWAKEARB] = (PWakeInfo[PWAKE_INFO_DLY]);
end

//PWAKEARB++
generate
for (g_stage=PWAKEARB+1; g_stage<=PWAKEOUT; g_stage++) begin: gen_PWakePipeV
    `HQM_DEVTLB_EN_RST_MSFF(PWakePipeV[g_stage],PWakePipeV[g_stage-1],ClkPWakePipe_H[g_stage],~PWakePipeStall,reset)
    `HQM_DEVTLB_EN_MSFF(PWakePipeMsTrkId[g_stage],PWakePipeMsTrkId[g_stage-1],ClkPWakePipe_H[g_stage],~PWakePipeStall)
    `HQM_DEVTLB_EN_MSFF(PWakePipeInfo[g_stage],PWakePipeInfo[g_stage-1],ClkPWakePipe_H[g_stage],~PWakePipeStall)
end
endgenerate

//PWAKEOUT
always_comb begin
    PendQWake = PWakePipeV[PWAKEOUT];
    PendQWakeMsTrkId = PWakePipeMsTrkId[PWAKEOUT];
    PendQWakeInfo = PWakePipeInfo[PWAKEOUT];
end

//-------------------------------------------------------
//MsTrk Entries
logic InvMsTrkWip, NxtInvMsTrkBusy;
logic [MISSTRK_DEPTH-1:0] MsTrkPop;
logic [MISSTRK_DEPTH-1:0] FillRsp;
//logic [MISSTRK_DEPTH-1:0] FillInPipe;
logic [MISSTRK_DEPTH-1:0] ArbGnt;
logic Filled;
logic [MISSTRK_IDW-1:0]   FilledIdx;
logic                     MsTrkReqWrOp;

always_comb begin
    NxtInvMsTrkBusy = InvMsTrkStart;

    for (int i=0; i<MISSTRK_DEPTH; i++) begin
        NxtInvMsTrkBusy    |= InvBusy[i];
        MsTrkPut_i[i]       = MsTrkPut && (MsTrkIdx == i[MISSTRK_IDW-1:0]);
        AtsRsp[i]           = atsrsp_vld && (i[MISSTRK_IDW-1:0] == atsrsp_id);
        PrsRsp[i]           = prsrsp_vld && (i[MISSTRK_IDW-1:0] == prsrsp_id) && PrsRspLegal[i] ;
        FillRsp[i]          = '0;
        for (int j=0; j<XREQ_PORTNUM;j++) begin
            FillRsp[i]     |= FillTLBOutV[j] && FillTLBOutInfo[j].FillLast && (i[MISSTRK_IDW-1:0] == FillTLBOutMsTrkIdx[j]);
        end
        AtsPrsInvArbGnt[i]   = AtsPrsInvPipeV[MSTRKARB] && (i[MISSTRK_IDW-1:0] == AtsPrsInvPipeMsTrkId[MSTRKARB]);
        FillArbReqQ[i]      = FillArbReq[i] && ~InvMsTrkWip;
        FillArbGnt[i]       = FillPipeV[MSTRKARB] && (i[MISSTRK_IDW-1:0] == FillPipeMsTrkId[MSTRKARB]);
        PrsInit[i]          = FillPipeV[FILLPROC] && FillProcPrs &&  (i[MISSTRK_IDW-1:0] == FillPipeMsTrkId[FILLPROC]);
        AtsReqAck[i]        = '0;
        for (int j=0; j<ATSREQ_PORTNUM; j++) AtsReqAck[i]  |= (atsreq_ack[j] && (i[MISSTRK_IDW-1:0] == atsreq_id[j]));
        PrsReqAck[i]        = (prsreq_ack && (i[MISSTRK_IDW-1:0] == prsreq_id));
        PWakeArbGnt[i]      = PWakePipeV[PWAKEARB] && (i[MISSTRK_IDW-1:0] == PWakePipeMsTrkId[PWAKEARB]);
        InvRsp[i]           = InvPipeV[INVOUT] && (i[MISSTRK_IDW-1:0] == AtsPrsInvPipeMsTrkId[INVOUT]); 
        InvRspHit[i]        = InvPipeHit[INVOUT]; 
    end
    PrsRspSts    = (prsrsp_sts==4'b0000)? DEVTLB_PRSRSP_SUC:
                   (prsrsp_sts==4'b0001)? DEVTLB_PRSRSP_IR: //Inv Req
                    DEVTLB_PRSRSP_FAIL; //Rsp Railure or other code
    PrsRspVld    = (prsrsp_vld && PrsRspLegal[prsrsp_id]);
   
    MsTrkReqWrOp = (MsTrkReq.Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_W));
    
    ArbGnt = AtsPrsInvArbGnt | FillArbGnt; //assert one hot
    
    MsTrkPrimCrdRet = |MsTrkPop; //assert onehot pop
    MsTrkSecCrdRet = '0;
    if(FWDPROG_EN) begin
        MsTrkSecCrdRet[0] = |(MsTrkPop & ~MsTrkPrio);
        MsTrkSecCrdRet[MISSCH_NUM-1] = |(MsTrkPop & MsTrkPrio);
    end
end

always_comb begin
    Filled = |MsTrkPop; 
    FilledIdx = get_idx(MsTrkPop); 
end

generate
    for (genvar i=0; i<MISSTRK_DEPTH; i++) begin : gen_mstrk_fsm
        hqm_devtlb_mstrk_fsm
        #(
            .NO_POWER_GATING(NO_POWER_GATING),
            .PRS_SUPP_EN(PRS_SUPP_EN),
            .XREQ_PORTNUM(XREQ_PORTNUM)
        ) mstrk_fsm (
            .PwrDnOvrd_nnnH,
            .clk,
            .rst_b (~reset),
            .reset_INST(reset_INST),
            .fscan_clkungate(fscan_clkungate),
            .CrPrsDis(CrPrsDis),
            .CrPrsCntDis(CrPrsCntDis),
            .CrPrsCnt(CrPrsCnt),

            .MsTrkVacant(MsTrkVacant[i]),
            .MsTrkVld(MsTrkVld[i]),
            .MsTrkPrio(MsTrkPrio[i]),
            .MsTrkWrOp(MsTrkWrOp[i]),
            .MsTrkPs(MsTrkPs[i]),
            .MsTrkNsIdle(MsTrkNsIdle[i]),

            .AtsArbReq(AtsArbReq[i]),
            .FillArbReq(FillArbReq[i]),
            .FillArbPrs(FillArbPrs[i]),
            .FillArbPrsSts(FillArbPrsSts[i]),
            .PrsArbReq(PrsArbReq[i]),
            .InvArbReq(InvArbReq[i]),
            .ArbGnt(ArbGnt[i]),

            .MsTrkPut(MsTrkPut_i[i]),
            .MsTrkPrs(MsTrkReq.Prs),
            .MsTrkReqPrio(MsTrkReq.Priority),
            .MsTrkReqWrOp(MsTrkReqWrOp),
            
            .AtsReqAck(AtsReqAck[i]),
            .AtsRsp(AtsRsp[i]), //pulse
            .AtsRspErr(1'b0),
            //.AtsRspNoFill(AtsRspNoFill),
            
            .PrsInit(PrsInit[i]),
            .PrsReqAck(PrsReqAck[i]),
            .PrsRspLegal(PrsRspLegal[i]),
            .PrsRsp(PrsRsp[i]),
            .PrsRspSts(PrsRspSts),

            .FillRsp(FillRsp[i]),
            //.FillInPipe(FillInPipe[i]),
            
            .PWakeArbReq(PWakeArbReq[i]),
            //.PWakeForceXRsp(PWakeForceXRsp[i]),
            .PWakeArbGnt(PWakeArbGnt[i]),
            .MsTrkPop(MsTrkPop[i]),  // assert onhot(pop)
            
            //invalidation req
            .InvStart(InvMsTrkStart), // pulse
            .InvEnd(InvMsTrkEnd),
            .InvRsp(InvRsp[i]),
            .InvRspHit(InvRspHit[i]),
            .InvBusy(InvBusy[i])
        );
    end
endgenerate

`HQM_DEVTLB_RST_MSFF(InvMsTrkBusy,NxtInvMsTrkBusy,ClkMsTrk_H,reset)
`HQM_DEVTLB_RST_MSFF(InvMsTrkWip,((InvMsTrkStart || InvMsTrkWip) && ~InvMsTrkEnd),ClkMsTrk_H,reset)

`ifndef HQM_DEVTLB_SVA_OFF
logic [MISSTRK_DEPTH-1:0] MsTrkVldForPendQ;
generate
for (genvar i=0; i<MISSTRK_DEPTH; i++) begin : gen_mstrrvldforpendq
`HQM_DEVTLB_RST_MSFF(MsTrkVldForPendQ[i],((MsTrkVldForPendQ[i] && ~(PWakePipeV[PWAKEOUT-1] && (PWakePipeMsTrkId[PWAKEOUT-1]==i[MISSTRK_IDW-1:0])))
                                    || MsTrkPut_i[i]),clk,reset)
end
endgenerate
/*
     AS_BADARSP_ADDR: assert property (@(posedge clk) disable iff (reset == 1'b1) (
     $rose(atsrsp_vld) |->
     (get_vamask(atsrsp_data_i.size, atsrsp_data_i.address)==(52'hFFFF_FFFF_FFFF_F<<0)) ||  //4K
     (get_vamask(atsrsp_data_i.size, atsrsp_data_i.address)==(52'hFFFF_FFFF_FFFF_F<<9)) ||  //2M
     (get_vamask(atsrsp_data_i.size, atsrsp_data_i.address)==(52'hFFFF_FFFF_FFFF_F<<18))    //1G
     )) $error("%0t: %m FAILED", $time); 
     //leftshift = log2(pagesize) - 10 -2
*/
     AS_BADARSP_ADDR: assert property (@(posedge clk) disable iff (reset == 1'b1) (
     $rose(atsrsp_vld) |->
     (get_ls0_ind(atsrsp_data_i.Size, atsrsp_data_i.Address)==0) ||  //4K
     (get_ls0_ind(atsrsp_data_i.Size, atsrsp_data_i.Address)==9) ||  //2M
     (get_ls0_ind(atsrsp_data_i.Size, atsrsp_data_i.Address)==18)    //1G
     )) `HQM_DEVTLB_ERR_MSG("%0t: %m FAILED. Expecting Translation Size of 4k, 2M or 1G only", $time); 
     //leftshift = log2(pagesize) - 10 -2

    generate
    for (g_id=0; g_id<ATSREQ_PORTNUM; g_id++) begin : gen_asatsreqq
     AS_ATSREQQPUSH_FULL: assert property (@(posedge clk) disable iff (reset == 1'b1) (
        AtsPipeV[ATSOUT][g_id] && ~AtsPrsInvPipeStall |->
        ~AtsReqQFull[g_id]
     )) `HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);
    end
    endgenerate
  
    AS_ATSREQ_SINGLE: assert property (@(posedge clk) disable iff (reset == 1'b1) (
        (&atsreq_vld) |-> (~(atsreq_id[0] == atsreq_id[1])) 
    )) `HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);

CP_DEVTLB_ARSP_4K:
cover property (@(posedge clk) ($rose(atsrsp_vld) |-> (get_ls0_ind(atsrsp_data_i.Size, atsrsp_data_i.Address)==0))) `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time); 
CP_DEVTLB_ARSP_2M:
cover property (@(posedge clk) ($rose(atsrsp_vld) |-> (get_ls0_ind(atsrsp_data_i.Size, atsrsp_data_i.Address)==9))) `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time); 
CP_DEVTLB_ARSP_1G:
cover property (@(posedge clk) ($rose(atsrsp_vld) |-> (get_ls0_ind(atsrsp_data_i.Size, atsrsp_data_i.Address)==18))) `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time); 
CP_DEVTLB_MSTRK_FillATSReQ_RFREnRace10: 
cover property (@(posedge clk) ($rose(atsrsp_vld) |=> AtsPrsInvPipeV[MSTRKRDCTL])) `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);
CP_DEVTLB_MSTRK_FillATSReq_RFRenRace11: 
cover property (@(posedge clk) ($rose(atsrsp_vld) |-> AtsPrsInvPipeV[MSTRKRDCTL])) `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);
CP_DEVTLB_MSTRK_FillATSReq_RFRenRace01: 
cover property (@(posedge clk) ($rose(AtsPrsInvPipeV[MSTRKRDCTL]) |=> atsrsp_vld)) `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);
CP_DEVTLB_MSTRK_INVST_AT_MSTRKPUT: 
cover property (@(posedge clk) (InvMsTrkStart |-> |MsTrkPut_i)) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, MsTrkId=%d", $time, MsTrkIdx);
CP_DEVTLB_MSTRK_INVST_AT_ATSREQGET: 
cover property (@(posedge clk) (InvMsTrkStart |-> |AtsPrsInvArbGnt)) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, MsTrkId=%d", $time, AtsPrsInvPipeMsTrkId[MSTRKARB]);
CP_DEVTLB_MSTRK_INVST_AT_ATSREQACK: 
cover property (@(posedge clk) (InvMsTrkStart |-> atsreq_ack[0])) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, MsTrkId=%d", $time, atsreq_id[0]);
CP_DEVTLB_MSTRK_INVST_AT_ATSRSP: 
cover property (@(posedge clk) (InvMsTrkStart |-> atsrsp_vld)) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, MsTrkId=%d", $time, atsrsp_id);
CP_DEVTLB_MSTRK_INVRSPHIT_AT_ATSRSP: 
cover property (@(posedge clk) (InvPipeV[INVOUT] && InvPipeHit[INVOUT] && (AtsPrsInvPipeMsTrkId[INVOUT]==atsrsp_id)|-> atsrsp_vld)) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, MsTrkId=%d", $time, AtsPrsInvPipeMsTrkId[INVOUT]);
CP_DEVTLB_MSTRK_INVRSPMISS_AT_ATSRSP: 
cover property (@(posedge clk) (InvPipeV[INVOUT] && ~InvPipeHit[INVOUT] && (AtsPrsInvPipeMsTrkId[INVOUT]==atsrsp_id) |-> atsrsp_vld)) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, MsTrkId=%d", $time, AtsPrsInvPipeMsTrkId[INVOUT]);
CP_DEVTLB_MSTRK_ATSRSP_AT_MSTRKAREQR: 
cover property (@(posedge clk) (atsrsp_vld |-> (MsTrkPs[atsrsp_id] == AREQREP))) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, dropping a fill for MsTrkId=%d", $time, atsrsp_id);
CP_DEVTLB_MSTRK_ATSRSP_AT_MSTRKINVE:
cover property (@(posedge clk) (atsrsp_vld && InvPipeV[INVOUT] && (AtsPrsInvPipeMsTrkId[INVOUT]==atsrsp_id) |-> (MsTrkPs[atsrsp_id] == AINVINIT))) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, inv is terminated by atsrsp, MsTrkId=%d", $time, atsrsp_id);
CP_DEVTLB_MSTRK_ATSRSP_AT_MSTRKINVA:
cover property (@(posedge clk) (atsrsp_vld |-> (MsTrkPs[atsrsp_id] == AINVARB))) `HQM_DEVTLB_COVER_MSG("%0t %m HIT, inv is terminated by atsrsp, MsTrkId=%d", $time, atsrsp_id);
CP_MSTRK_HSD_22010368091: // When scenario is hit, Wrong MsTrk RdAddr was used for reading structure used for initiating ATS Req.
cover property (@(posedge clk) ((FillPipeV[MSTRKRDCTL] && FillPipeStall) |-> AtsMsTrkRen)) 
`HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);
CP_DEVTLB_MSTRK_ATSREQ_ACKS:
cover property (@(posedge clk) ((&atsreq_vld) |-> (&atsreq_ack))) 
`HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);
CP_DEVTLB_MSTRK_ATSREQ_HPFIFOCRDT:
cover property (@(posedge clk) (|(AtsArbReq & MsTrkPrio) |-> ~AtsReqQCrdAvail[HPXREQ])) 
`HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);
CP_DEVTLB_MSTRK_ATSREQ_LPFIFOCRDT:
cover property (@(posedge clk) (|(AtsArbReq & ~MsTrkPrio) |-> ~AtsReqQCrdAvail[LPXREQ])) 
`HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);

CP_MSTRK_HSD22010222500: // an entery is grabbed immediately after turned vacant
cover property (@(posedge clk) (MsTrkReqWrEn |-> $rose(MsTrkVacant[MsTrkReqWrAddr]))) 
`HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);

CP_MSTRK_FILLxINV_FWDPROG: // CP hit means Inv could move fwd even when fsm fighting for Fill and Inv
cover property (@(posedge clk) (NxtInvMsTrkBusy && InvBlockFill && (|FillArbReq) && |InvArbReq |-> ##[2:5] !NxtInvMsTrkBusy)) 
`HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);

CP_MATCHINGATSRSPB2B:
cover property (@(posedge clk) (FillPipeV[FILLPROC] |-> (FillHitVec[0])))
`HQM_DEVTLB_COVER_MSG ("%0t %m HIT", $time);

CP_MATCHINGATSRSP1CLKGAP:
cover property (@(posedge clk) (FillPipeV[FILLPROC] |-> (FillHitVec[1])))
`HQM_DEVTLB_COVER_MSG ("%0t %m HIT", $time);

CP_3MATCHINGATSRSPB2B:
cover property (@(posedge clk) (FillPipeV[FILLPROC] |-> (&FillHitVec)))
`HQM_DEVTLB_COVER_MSG ("%0t %m HIT", $time);

`HQM_DEVTLB_COVERS_TRIGGER(CP_AtsRsp_Size_Around4KB,
   atsrsp_vld,
   (atsrsp_data_i.Size=='0) || //4KB
   (atsrsp_data_i.Size && ({atsrsp_data_i.Address[REQ_PAYLOAD_LSB+:1]}==1'b0)), //8kB
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_AtsRsp_Size_Around2MB,
   atsrsp_vld,
   (atsrsp_data_i.Size && ({atsrsp_data_i.Address[REQ_PAYLOAD_LSB+:8]}=={1'b0, {(8-1){1'b1}}})) || //1MB
   (atsrsp_data_i.Size && ({atsrsp_data_i.Address[REQ_PAYLOAD_LSB+:9]}=={1'b0, {(9-1){1'b1}}})) || //2MB
   (atsrsp_data_i.Size && ({atsrsp_data_i.Address[REQ_PAYLOAD_LSB+:10]}=={1'b0, {(10-1){1'b1}}})), //4MB
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_AtsRsp_Size_Around1GB,
   atsrsp_vld,
   (atsrsp_data_i.Size && ({atsrsp_data_i.Address[REQ_PAYLOAD_LSB+:17]}=={1'b0, {(17-1){1'b1}}})) || //512MB
   (atsrsp_data_i.Size && ({atsrsp_data_i.Address[REQ_PAYLOAD_LSB+:18]}=={1'b0, {(18-1){1'b1}}})) || //1GB
   (atsrsp_data_i.Size && ({atsrsp_data_i.Address[REQ_PAYLOAD_LSB+:19]}=={1'b0, {(19-1){1'b1}}})),   //2GB
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_MsTrkFsm0_MaxATSReqBlk_LP,
    AtsReqBlk[LPXREQ],
    (AtsArbReq[0] && AtsReqQCrdAvail[LPXREQ] && ~MsTrkPrio[0]),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_MsTrkFsm0_MaxATSReqBlk_HP,
    AtsReqBlk[HPXREQ],
    (AtsArbReq[0] && AtsReqQCrdAvail[HPXREQ] &&  MsTrkPrio[0]),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

AS_MSTRKREN_ONEHOT:
assert property (@(posedge clk) disable iff (reset == 1'b1) (|{AtsMsTrkRen, FillMsTrkRen} |-> $onehot({AtsMsTrkRen, FillMsTrkRen}))) 
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);
AS_MSTRKARBGNT_ONEHOT:
assert property (@(posedge clk) disable iff (reset == 1'b1) (|{AtsPrsInvArbGnt, FillArbGnt} |-> $onehot({AtsPrsInvArbGnt, FillArbGnt}))) 
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);
AS_MSTRKPOP_ONEHOT:
assert property (@(posedge clk) disable iff (reset == 1'b1) (|MsTrkPop|-> $onehot(MsTrkPop))) 
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);
AS_MSTRKPOP_PWAKEIDX:
assert property (@(posedge clk) disable iff (reset == 1'b1) (|MsTrkPop|-> (PWakePipeV[PWAKEARB] && (get_idx(MsTrkPop) ==  PWakePipeMsTrkId[PWAKEARB])))) 
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);

AS_MSTRK_RDWR_CONFLICT:
assert property (@(posedge clk) disable iff (reset == 1'b1) (MsTrkReqWrEn && MsTrkReqRdEn |-> ~(MsTrkReqWrAddr == MsTrkReqRdAddr))) 
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);
AS_MSTRK_PUTVACANT:
assert property (@(posedge clk) disable iff (reset == 1'b1) (MsTrkPut |-> MsTrkVacant[MsTrkIdx])) 
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time);

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_atsreq_id_different,
   (atsreq_vld[0] && atsreq_vld[1]), 
   (atsreq_id[0] != atsreq_id[1]),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

// assert no $rose(MsTrkFillInFlight) between invstart & invend

AS_FillPrsStsNonSucc_MustBePRS:
assert property (@(posedge clk) disable iff (reset == 1'b1) (FillPipeV[MSTRKRET] && ~(FillPipePrsSts[MSTRKRET]==DEVTLB_PRSRSP_SUC) |-> FillMsTrkReqRdData[MSTRKRET].Prs)) 
`HQM_DEVTLB_ERR_MSG("%0t %m failed", $time);

AS_NonPRS_MustBeFillPrsStsSucc:
assert property (@(posedge clk) disable iff (reset == 1'b1) (FillPipeV[MSTRKRET] && ~FillMsTrkReqRdData[MSTRKRET].Prs |-> (FillPipePrsSts[MSTRKRET]==DEVTLB_PRSRSP_SUC))) 
`HQM_DEVTLB_ERR_MSG("%0t %m failed", $time);

AS_INV_FillINGLIGHT:  // no NEW (i.e $rose) fill reqv (that cause TLB Fill) AFTER invMstrkstart is sampled, and before InvMsTrkEnd is sampled
assert property (@(posedge clk) disable iff (reset == 1'b1) (InvMsTrkWip |-> ~$rose(MsTrkFillInFlight)))
`HQM_DEVTLB_ERR_MSG("%0t %m failed", $time);

`HQM_DEVTLB_COVERS_TRIGGER(CP_InvMsTrkWip_FillArbReq,
   InvMsTrkWip,
   |FillArbReq,
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

AS_FillByWrongOpcode: //Expect Fill to be originated from either DMA_R/W only
assert property (@(posedge clk) disable iff (reset == 1'b1) (FillReqPut |-> 
    ((FillMsTrkReqRdData[FILLPROC].Opcode == T_OPCODE'(DEVTLB_OPCODE_UTRN_R)) ||
     (FillMsTrkReqRdData[FILLPROC].Opcode == T_OPCODE'(DEVTLB_OPCODE_UTRN_W)))
)) `HQM_DEVTLB_ERR_MSG("%0t %m failed", $time);

//When InvEnd, no FillReq anywhere outside of mstrk, otherwise those need to be invalidated, before forcexrsp used for wake
AS_INVEND_FillIDLE:
assert property (@(posedge clk) disable iff (reset == 1'b1) (InvMsTrkEnd |-> (~|{PWakePipeV, PWakeArbReq, FillTLBOutV}))) 
`HQM_DEVTLB_ERR_MSG("%0t %m failed", $time);

AS_PWakeReqOneHot:
assert property (@(posedge clk) disable iff (reset == 1'b1) ((|PWakeArbReq) |-> $onehot(PWakeArbReq))) 
`HQM_DEVTLB_ERR_MSG("%0t %m failed", $time);

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_FillRspWakeReq_FixedLat,
   (FillRsp[FillTLBOutMsTrkIdx[0]]), PWAKE_INFO_DLY,
   (PWakePipeV[PWAKEARB] && (PWakePipeMsTrkId[PWAKEARB]== $past(FillTLBOutMsTrkIdx[0],PWAKE_INFO_DLY))),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

generate
for (g_id=0; g_id<MISSTRK_DEPTH; g_id++) begin : gen_FillRsp
    AS_FillRsp_PWakeReq_FixedLat:
    assert property (@(posedge clk) disable iff (reset == 1'b1) (PWakeArbReq[g_id] |-> $past(FillRsp[g_id],1))) 
    `HQM_DEVTLB_ERR_MSG("%0t %m failed", $time);
end
endgenerate

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_AtsReqCnt_TCnt_valid,
   CrTMaxATSReqEn, 
   ((AtsReqCnt[0]<=CrMaxATSReq[0]) && (!(CrMaxATSReq[0]=='0)) &&
    (AtsReqCnt[1]<=CrMaxATSReq[1]) && (!(CrMaxATSReq[0]=='0)) &&
    (AtsReqTCnt<=CrTMaxATSReq)     && (!(CrTMaxATSReq=='0))),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

final begin : ASF_MSTRK_IDLE
    assert (MsTrkVacant=='1) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: MsTrk not empty.");
    assert ({AtsPipeV, InvPipeV, AtsPrsInvPipeV, FillPipeV}=='0) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: Pipe Is not empty.");
    assert ((AtsReqCnt=='0) && (AtsReqTCnt=='0))
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: AtsReq Cnt Is not empty.");
end
`endif //DEVTLB_SVA_OFF

endmodule

`endif // IOMMU_MSTRK_VS
