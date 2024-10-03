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

`ifndef HQM_DEVTLB_MSTRK_FSM_VS
`define HQM_DEVTLB_MSTRK_FSM_VS

`include "hqm_devtlb_pkg.vh"

module hqm_devtlb_mstrk_fsm
import `HQM_DEVTLB_PACKAGE_NAME::*; 
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter logic PRS_SUPP_EN = 1'b1,
    parameter logic RETRY_ON_ATSRSPERR = 1'b0,
    parameter int   XREQ_PORTNUM = 2,
    localparam int  XREQ_PORTID = (XREQ_PORTNUM>1)?$clog2(XREQ_PORTNUM):1
)(
    input  logic                PwrDnOvrd_nnnH,
    input  logic                clk,
    input  logic                rst_b,
    input  logic                reset_INST,
    input  logic                fscan_clkungate, 
    input  logic                CrPrsDis,
    input  logic                CrPrsCntDis,
    input  logic [2:0]          CrPrsCnt,

    output logic                MsTrkVacant,
    output logic                MsTrkVld,
    output t_mstrk_state        MsTrkPs,
    output logic                MsTrkNsIdle,

    output logic                AtsArbReq, 
    output logic                FillArbReq,
    output logic                FillArbPrs,
    output t_devtlb_prsrsp_sts  FillArbPrsSts,
    output logic                PrsArbReq,
    output logic                InvArbReq,
    output logic                MsTrkPrio,
    output logic                MsTrkWrOp,
    input  logic                ArbGnt,

    input  logic                MsTrkPut,
    input  logic                MsTrkPrs,
    input  logic                MsTrkReqPrio,
    input  logic                MsTrkReqWrOp,

    input  logic                AtsReqAck,
    input  logic                AtsRsp,
    //input  logic                AtsRspNoFill,
    input  logic                AtsRspErr,

    input  logic                PrsInit,
    input  logic                PrsReqAck,
    output logic                PrsRspLegal,
    input  logic                PrsRsp,
    input  t_devtlb_prsrsp_sts  PrsRspSts,
    
    input  logic                FillRsp,
    //input  logic [XREQ_PORTNUM-1:0]                FillRspPrio,
    //output logic                FillInPipe,

    output logic                PWakeArbReq,
    //output logic                PWakeForceXRsp,
    input  logic                PWakeArbGnt,
    output logic                MsTrkPop,
    
    input  logic                InvStart,
    input  logic                InvEnd,
    input  logic                InvRsp,
    input  logic                InvRspHit,
    output logic                InvBusy
);

//-------------------------------------------------------------------------------
//  States being tracked in each MsTrk Entry
//-------------------------------------------------------------------------------
t_mstrk_state MsTrkNs;
//logic [XREQ_PORTNUM-1:0][HPXREQ:LPXREQ] FillTrk, NxtFillTrk;
//logic [XREQ_PORTNUM-1:0][0:0] FillTrk, NxtFillTrk;
//output logic MsTrkPrio;
//output logic MsTrkWrOp;
//logic AtsRspNoFillSaved;
logic               AtsRspErrSaved;
logic [2:0]         MsTrkPrsCnt, MsTrkPrsNxtCnt;
t_devtlb_prsrsp_sts MsTrkPrsSts, MsTrkPrsNxtSts;

//-------------------------------------------------------------------------------
//  CLOCKING
//-------------------------------------------------------------------------------
   logic                                            pEn_ClkFsm_H;
   logic                                            ClkFsm_H;

//-------------------------------------------------------------------------------
// FillTrk : when all bits set, indicates that all xreq in front of fill have been flushed from TLB pipe, and all xreq in front of fill and in msfifo have been marked for WakeAtPut if they ended up in pendq.
//logic [XREQ_PORTNUM-1:0][HPXREQ:LPXREQ] SetFillTrk, ClrFillTrk;
//logic [XREQ_PORTNUM-1:0][0:0] SetFillTrk, ClrFillTrk;  // replaced FillTrk with FillLast bit in ctrl indicates last fill
/*
always_comb begin
    for (int i=0; i<XREQ_PORTNUM; i++) begin 
        //for(int j=LPXREQ; j<=HPXREQ; j++) begin
        for(int j=0; j<=0; j++) begin
            SetFillTrk[i][j] = FillRsp[i];
            ClrFillTrk[i][j] = (MsTrkPs==MSTRKIDLE);
                                //&& (FillRspPrio[i]==j[0]);
            NxtFillTrk[i][j] = (SetFillTrk[i][j] || FillTrk[i][j]) && ~ClrFillTrk[i][j] ; // assert set clr nvr happen
        end
    end
end

genvar g_port, g_prio;
generate
for (g_port=0; g_port<XREQ_PORTNUM; g_port++) begin: gen_filltrk_port
    //for (g_prio=LPXREQ; g_prio<=HPXREQ; g_prio++) begin: gen_filltrk_prio
    //    `DEVTLB_EN_MSFF(FillTrk[g_port][g_prio], NxtFillTrk[g_port][g_prio], ClkFsm_H, 
    //                    (SetFillTrk[g_port][g_prio] || ClrFillTrk[g_port][g_prio]))
    //end
    `HQM_DEVTLB_EN_MSFF(FillTrk[g_port][0], NxtFillTrk[g_port][0], ClkFsm_H, 
                    (SetFillTrk[g_port][0] || ClrFillTrk[g_port][0]))
end
endgenerate
*/
//-------------------------------------------------------------------------------

`HQM_DEVTLB_EN_MSFF(MsTrkPrio, MsTrkReqPrio, ClkFsm_H, MsTrkPut)
`HQM_DEVTLB_EN_MSFF(MsTrkWrOp, MsTrkReqWrOp, ClkFsm_H, MsTrkPut)
//`DEVTLB_EN_MSFF(AtsRspNoFillSaved, AtsRspNoFill, ClkFsm_H, AtsRsp)

logic           PrsRspSuc;
always_comb begin
    PrsRspSuc = (PrsRspSts==DEVTLB_PRSRSP_SUC);
    MsTrkPrsNxtSts = (MsTrkPut || (InvRsp &&  InvRspHit))? DEVTLB_PRSRSP_SUC:
                     PrsRsp? PrsRspSts :MsTrkPrsSts;
    MsTrkPrsNxtCnt = ((MsTrkPut && (MsTrkPrs && ~CrPrsDis)) || (InvRsp &&  InvRspHit))? CrPrsCnt:
                      ((PrsRsp && ~PrsRspSuc) || (MsTrkPut && (CrPrsDis || ~MsTrkPrs)))?  3'd0:
                      (PrsRsp && PrsRspSuc && ~CrPrsCntDis)? (MsTrkPrsCnt-'d1):
                      MsTrkPrsCnt;
end
generate
if (PRS_SUPP_EN) begin: gen_MsTrkPrsCnt_prs_en
    `HQM_DEVTLB_EN_MSFF(MsTrkPrsCnt, MsTrkPrsNxtCnt, ClkFsm_H, (MsTrkPut || PrsRsp))
    `HQM_DEVTLB_EN_MSFF(MsTrkPrsSts, MsTrkPrsNxtSts, ClkFsm_H, (MsTrkPut || PrsRsp))
end else begin: gen_MsTrkPrsCnt_prs_dis
    always_comb begin
        MsTrkPrsCnt = '0;
        MsTrkPrsSts = DEVTLB_PRSRSP_SUC;
    end
end
endgenerate

generate
if(RETRY_ON_ATSRSPERR) begin : gen_atsrsperr
    `HQM_DEVTLB_EN_MSFF(AtsRspErrSaved, AtsRspErr, ClkFsm_H, AtsRsp)
end else begin : gen_atsrsperr_else 
    always_comb AtsRspErrSaved = 1'b0;
end
endgenerate
always_comb begin
    pEn_ClkFsm_H = (~rst_b) || MsTrkPut || (MsTrkPs!=MSTRKIDLE);
end
`HQM_DEVTLB_MAKE_LCB_PWR(ClkFsm_H,  clk, pEn_ClkFsm_H,  PwrDnOvrd_nnnH)

always_comb begin
    MsTrkPop = 1'b0;
    MsTrkNs = MsTrkPs;
    case (MsTrkPs)
    MSTRKIDLE: begin
        unique if (MsTrkPut && ~InvStart)    MsTrkNs = AREQARB;
        else if   (MsTrkPut &&  InvStart)    MsTrkNs = AREQHOLD;
        else       MsTrkNs = MsTrkPs;
        //invstart stay in MSTRKIDLE
    end
    AREQHOLD: begin
        if(InvEnd) MsTrkNs = AREQARB; //not participating in inv, there won't be invrsp. TODO ASSERT
                                      //not raising atsinvreq_avail or terminated the handshake, there won't be atsinvreq_get // TODO ASSERT
    end
    AREQARB: begin
        if (ArbGnt)   MsTrkNs = AREQINIT; // this ATS REQ won't participate in the inv that invstart here
        else     if (InvStart) MsTrkNs = AREQHOLD; // terminate atsinvreq_avail handshake.
    end
    AREQINIT: begin
        if(AtsReqAck) MsTrkNs = AREQEND; // this ATS REQ won't participate in the inv that InvStart here
    end
    AREQEND: begin
        unique if (~InvStart &&  AtsRsp && ~AtsRspErr) MsTrkNs = FREQARB;
        else if   (~InvStart &&  AtsRsp &&  AtsRspErr) MsTrkNs = AREQARB;
        else if   ( InvStart && ~AtsRsp              ) MsTrkNs = AINVARB;
        else if   ( InvStart &&  AtsRsp              ) MsTrkNs = FINVARB;
        else       MsTrkNs = MsTrkPs;
    end
    AINVARB: begin
        unique if ( AtsRsp && ~ArbGnt) MsTrkNs = FINVARB; 
        else if   ( AtsRsp &&  ArbGnt) MsTrkNs = FINVINIT; //not possible due to ARB, allow FILL, and retire inv
        else if   (~AtsRsp &&  ArbGnt) MsTrkNs = AINVINIT;
        else       MsTrkNs = MsTrkPs;
    end
    AINVINIT: begin
        unique if (( InvRsp && ~InvRspHit) && ~AtsRsp              ) MsTrkNs = AREQEND; 
        else if   (( InvRsp &&  InvRspHit) && ~AtsRsp              ) MsTrkNs = AREQREP; 
        else if   ((~InvRsp              ) &&  AtsRsp              ) MsTrkNs = FINVINIT; 
        else if   (( InvRsp && ~InvRspHit) &&  AtsRsp && ~AtsRspErr) MsTrkNs = FREQARB;
        else if   (( InvRsp && ~InvRspHit) &&  AtsRsp &&  AtsRspErr) MsTrkNs = AREQARB;
        else if   (( InvRsp &&  InvRspHit) &&  AtsRsp              ) MsTrkNs = AREQARB;
        else       MsTrkNs = MsTrkPs;
    end
    AREQREP: begin
        unique if (AtsRsp && ~InvStart) MsTrkNs = AREQARB;
        else if   (AtsRsp &&  InvStart) MsTrkNs = AREQHOLD;
        else       MsTrkNs = MsTrkPs;
        //invstart alone stay in here, not going to re-participate
    end
    FREQARB: begin
        if (ArbGnt)   MsTrkNs = FREQINIT; // once Gnt, no way to back up the Fill.
        else     if (InvStart) MsTrkNs = FINVARB; // terminate freqarb handshake.
        //Note: “InvStart & ArbGnt” won’t involve INV. See visio
    end
    FREQINIT: begin // this ATS REQ won't participate in the inv that InvStart here
        unique if (FillRsp) MsTrkNs = FREQEND; 
        else if (PrsInit)   MsTrkNs = PREQARB; 
        else                MsTrkNs = MsTrkPs;
    end
    PREQARB: begin
        if (ArbGnt)   MsTrkNs = PREQEND; //PREQINIT; // this ATS REQ won't participate in the inv that invstart here
    end
//    PREQINIT: begin //todo remove this stage
//        if(PrsReqAck) MsTrkNs = PREQEND; // this ATS REQ won't participate in the inv that InvStart here
//    end
    PREQEND: begin
        unique if (PrsRsp &&  PrsRspSuc) MsTrkNs = AREQARB;
        else if   (PrsRsp && ~PrsRspSuc) MsTrkNs = FREQARB;
        else       MsTrkNs = MsTrkPs;
    end
    FREQEND: begin
        if(PWakeArbGnt) begin// add delay here if needed.
            MsTrkNs = MSTRKIDLE; // this ATS REQ won't participate in the inv that InvStart here
            MsTrkPop = 1'b1;
        end
    end
    FINVARB: begin
        if (ArbGnt) MsTrkNs = FINVINIT; 
    end
    FINVINIT: begin
        unique if ( InvRsp && ~InvRspHit && ~AtsRspErrSaved) MsTrkNs = FREQARB; 
        else   if ( InvRsp && ~InvRspHit &&  AtsRspErrSaved) MsTrkNs = AREQARB; 
        else   if ( InvRsp &&  InvRspHit             ) MsTrkNs = AREQARB; 
        else       MsTrkNs = MsTrkPs;
    end
    default:;
    endcase
end
//TODO assert ~(atsinvreq_get && atsrsp)
//TODO assert (invend |-> state!=(INV*))
always_comb begin
    MsTrkNsIdle = (MsTrkNs==MSTRKIDLE);
    MsTrkVacant = (MsTrkPs==MSTRKIDLE);
    MsTrkVld    = ~(MsTrkPs==MSTRKIDLE);
    AtsArbReq   = (MsTrkPs==AREQARB);
    PrsArbReq   = (MsTrkPs==PREQARB);
    InvArbReq   = (MsTrkPs==AINVARB) || (MsTrkPs==FINVARB);
    PWakeArbReq = (MsTrkPs==FREQEND);
    //PWakeForceXRsp = AtsRspNoFillSaved;
    FillArbReq  = (MsTrkPs==FREQARB);
    FillArbPrs  = ~(MsTrkPrsCnt=='0);
    FillArbPrsSts = MsTrkPrsSts;
    PrsRspLegal = (MsTrkPs==PREQEND);
    InvBusy     = (MsTrkPs==AINVARB) || (MsTrkPs==AINVINIT) ||
                  (MsTrkPs==FINVARB) || (MsTrkPs==FINVINIT);
    //FillInPipe  = (MsTrkPs==FREQINIT);
end

`HQM_DEVTLB_RSTD_MSFF(MsTrkPs, MsTrkNs, ClkFsm_H, ~rst_b, MSTRKIDLE)

`ifndef HQM_DEVTLB_SVA_OFF
CP_DEVTLB_FSM_INVST_AT_AREQREP:
cover property (@(posedge clk) (InvStart && (MsTrkPs == AREQREP) |-> ~AtsRsp)) `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time);

//When InvEnd, no FillReq anywhere outside of mstrk, otherwise those need to be invalidated, before forcexrsp used for wake
`HQM_DEVTLB_ASSERTS_TRIGGER(AS_InvEnd_MsTrk_FillIdle,
   (InvEnd),
   !((MsTrkPs==FREQINIT) || (MsTrkPs==FREQEND)),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`endif //DEVTLB_SVA_OFF
endmodule

`endif // IOMMU_MSTRK_FSM_VS
