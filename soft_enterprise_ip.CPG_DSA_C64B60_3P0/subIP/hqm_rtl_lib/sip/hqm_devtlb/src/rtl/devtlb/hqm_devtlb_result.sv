//=====================================================================================================================
//
// iommu_result.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_RESULT_VS
`define HQM_DEVTLB_RESULT_VS

`include "hqm_devtlb_pkg.vh"
`include "hqm_devtlb_fifo.sv"

module hqm_devtlb_result (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
//   PwrDnOvrd_nnnH,
   
   InvMsTrkEnd,
   
   TLBOutPipeV_nnnH,
   TLBOutXRspV_nnnH,
   TLBOutMsProcV_nnnH,
   TLBOutReq_nnnH,
   TLBOutCtrl_nnnH,
   TLBOutInfo_nnnH,

   MsFifoReqAvail,
   MsFifoProcReq,
   MsFifoReqGet,
   MsfifoCrdRet,
   
   RespCrdRet,
   resp_valid,          // A valid response is on the interface
   resp_id,             // ID as assigned by requesting agent
   resp_tlbid,          // TLBID as assigned by requesting agent
   resp_opcode,         //
   resp_status,         //
   resp_prs_code,
   resp_dperror,
   resp_hdrerror,
   resp_n,    //
   resp_payload,        // The resulting HPA
   resp_pagesize,       // The resulting pagesize
   resp_priv_data,
   resp_r,
   resp_w,
   resp_perm,
   resp_ep,
   resp_pa,
   resp_global,
   resp_u,
   resp_memtype,        // memtype of the payload HPA
   
   FillTLBOutV,
   FillTLBOutInfo,
   FillTLBOutMsTrkIdx
//lintra +68099
);

import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU
`include "hqm_devtlb_pkgparams.vh"

parameter type T_REQ             = logic; //t_devtlb_request;
parameter type T_PROCREQ         = logic; //t_devtlb_procreq;
parameter type T_REQ_CTRL        = logic; //t_devtlb_request_ctrl;
parameter type T_REQ_INFO        = logic; //t_devtlb_request_info;
parameter type T_STATUS          = logic; //t_devtlb_resp_status;
parameter type T_OPCODE          = logic; //t_devtlb_opcode;
parameter int DEVTLB_PORT_ID     = 0;
parameter int MISSFIFO_DEPTH     = 16;
parameter int RESP_PAYLOAD_MSB   = 63;
parameter int RESP_PAYLOAD_LSB   = 12;   
parameter int PS_MAX = IOTLB_PS_MAX;
parameter int PS_MIN = IOTLB_PS_MIN;
parameter int NUM_ARRAYS         = 0;
parameter logic TLB_SHARE_EN     = 1'b0;
parameter int TLB_ALIASING [NUM_ARRAYS:0][5:0] = '{ default:0 };
localparam int RESP_PAYLOAD_WIDTH       = RESP_PAYLOAD_MSB-RESP_PAYLOAD_LSB+1;
localparam int MISSFIFO_IDW = $clog2(MISSFIFO_DEPTH);
parameter logic FWDPROG_EN        = 1'b0;
localparam int  MISSCH_NUM        = (FWDPROG_EN)? 2: 1;
localparam int READ_LATENCY = DEVTLB_TLB_READ_LATENCY;

//======================================================================================================================
//                                           Interface signal declarations
//======================================================================================================================

   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
//   input    logic                               PwrDnOvrd_nnnH;       // Powerdown override

   input    logic                               InvMsTrkEnd;
  
   input    logic                               TLBOutPipeV_nnnH;    // TLB Ouput to response interface and/or fault detection
   input    logic                               TLBOutXRspV_nnnH;    // TLB Output to XRsp interface.
   input    logic                               TLBOutMsProcV_nnnH;     // TLB output to MsTrk 
   input    T_REQ                               TLBOutReq_nnnH;      // TLB Ouput to response interface and/or fault detection
   input    T_REQ_CTRL                          TLBOutCtrl_nnnH;     // TLB Ouput to response interface and/or fault detection
   input    T_REQ_INFO                          TLBOutInfo_nnnH;     // TLB Ouput to response interface and/or fault detection

   //sending miss request to either MissTrk or PendQ
   output   logic [MISSCH_NUM-1:0]              MsFifoReqAvail;
   output   T_PROCREQ [MISSCH_NUM-1:0]          MsFifoProcReq;
   input    logic [MISSCH_NUM-1:0]              MsFifoReqGet;
   output   logic [MISSCH_NUM-1:0]              MsfifoCrdRet;
   
   // DMA Response
   //
   output   logic [MISSCH_NUM-1:0]              RespCrdRet;
   output   logic                               resp_valid;          // A valid response is on the interface
   output   logic [DEVTLB_REQ_ID_WIDTH-1:0]     resp_id;             // ID as assigned by requesting agent
   output   logic [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_ARRAYS)-1:0] resp_tlbid;          // ID as assigned by requesting agent
   output   logic [$bits(T_OPCODE)-1:0]         resp_opcode;         
   output   logic [$bits(T_STATUS)-1:0]         resp_status;         
   output   logic [$bits(t_devtlb_prsrsp_sts)-1:0] resp_prs_code;
   output   logic                               resp_dperror;
   output   logic                               resp_hdrerror;
   
   output   logic                               resp_n;    
   output   logic                               resp_r;    
   output   logic                               resp_w;    
   output   logic                               resp_perm;    
   output   logic                               resp_u;    
   output   logic                               resp_ep;    
   output   logic                               resp_pa;    
   output   logic                               resp_global;    
   output   logic [RESP_PAYLOAD_MSB:RESP_PAYLOAD_LSB] resp_payload;   // The resulting HPA or remapped interrupt
   output   logic [DEVTLB_RESP_PGSIZE_WIDTH-1:0]resp_pagesize;       // Response page size
   output   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]  resp_priv_data; // Privated data stored in DEVTLB  
   output   logic [DEVTLB_MEMTYPE_WIDTH-1:0]    resp_memtype;

   output   logic                               FillTLBOutV;
   output   logic [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]      FillTLBOutMsTrkIdx;
   output   t_fillinfo                          FillTLBOutInfo;

//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================
typedef struct packed {
    logic                                           MPrior;
    logic                                           W;
    logic [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_ARRAYS)-1:0] TlbId;
    logic                                           PasidV;           // Valid PASID input
    logic [DEVTLB_PASID_WIDTH-1:0]                  PASID;            // PCIE Function ID for ATS
    //logic                                         ER;               // Execute Request
    logic                                           PR;               // Privileged Mode Request
    logic [DEVTLB_BDF_WIDTH-1:0]                    BDF;              // PCIE BDF ID
    logic [DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]    Address;
    logic [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]        MsTrkIdx;
} t_fillreq;

//=====================================================================================================================
// CLOCK GENERATION
//=====================================================================================================================
/*logic           ClkResRcb_H;
logic           ClkResLcb_H;
logic           pEn_Result;

`HQM_DEVTLB_MAKE_RCB_PH1(ClkResRcb_H, clk, pEn_Result, PwrDnOvrd_nnnH)

always_comb begin: gClocks
   pEn_Result = ReqVal_1n1H | FifoAvail_1nnH | (~(Credits_1nnH=='0)) | CreditReturn_1nnH | reset;
end: gClocks

`HQM_DEVTLB_MAKE_LCB_PWR(ClkResLcb_H, ClkResRcb_H, pEn_Result, PwrDnOvrd_nnnH)
*/
//logic xreqHitTlb;
always_comb begin: Iommu_Response_Generation

   // Map TLB outputs to primary outputs
   //
//   xreqHitTlb        = TLBOutInfo_nnnH.Hit && (TLBOutInfo_nnnH.Status==DEVTLB_RESP_HIT_VALID);
   resp_valid        = TLBOutXRspV_nnnH;
   resp_status       = TLBOutInfo_nnnH.Status;
   resp_prs_code     = TLBOutInfo_nnnH.PrsCode;
   resp_dperror      = TLBOutInfo_nnnH.ParityError; //TODO
   resp_hdrerror     = TLBOutInfo_nnnH.HeaderError;
   resp_id           = TLBOutReq_nnnH.ID;
   resp_tlbid        = TLBOutReq_nnnH.TlbId;
   resp_opcode       = TLBOutReq_nnnH.Opcode;
   resp_n            = TLBOutInfo_nnnH.N;
   resp_memtype      = TLBOutInfo_nnnH.Memtype;
   resp_u            = TLBOutInfo_nnnH.U;
   resp_r            = TLBOutInfo_nnnH.R;
   resp_w            = TLBOutInfo_nnnH.W;
   resp_perm         = (TLBOutInfo_nnnH.W && (TLBOutReq_nnnH.Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_W))) ||
                       (TLBOutInfo_nnnH.R && (TLBOutReq_nnnH.Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_R)));
   resp_ep           = TLBOutInfo_nnnH.X;
   resp_pa           = TLBOutReq_nnnH.PR;
   resp_global       = TLBOutInfo_nnnH.Global;

    // resp_valid could be 1 for pendreq, xreq & fill
   if (FWDPROG_EN) begin
        RespCrdRet[MISSCH_NUM-1] = resp_valid && (~TLBOutMsProcV_nnnH) && ~TLBOutCtrl_nnnH.Fill && TLBOutReq_nnnH.Priority;
        RespCrdRet[0] = resp_valid && (~TLBOutMsProcV_nnnH) && ~TLBOutCtrl_nnnH.Fill && (~TLBOutReq_nnnH.Priority);
    end else begin
        RespCrdRet[0] = resp_valid && (~TLBOutMsProcV_nnnH) && ~TLBOutCtrl_nnnH.Fill;
    end
   // Payload is pre-qualified with the fault information formatted for dma vs. ir in the prior cycle
   // TODO: move payload mux to previous stage.
   resp_payload      = (resp_status==DEVTLB_RESP_HIT_VALID)? `HQM_DEVTLB_ZX(TLBOutInfo_nnnH.Address,  RESP_PAYLOAD_WIDTH): '0;
   resp_pagesize     = `HQM_DEVTLB_ZX(TLBOutInfo_nnnH.Size,     DEVTLB_RESP_PGSIZE_WIDTH);
   resp_priv_data    = TLBOutInfo_nnnH.Priv_Data;
end

logic [MISSCH_NUM-1:0] mfifo_push, mfifo_pop, mfifo_full, mfifo_avail;
T_REQ [MISSCH_NUM-1:0] mfifo_din;

//assert TLBOutInfo_nnnH.Fill |-> TLBOutInfo_nnnH.Hit
always_comb begin: MissReq_Fifo

    if(FWDPROG_EN) begin
        mfifo_push[MISSCH_NUM-1] = TLBOutPipeV_nnnH && TLBOutMsProcV_nnnH && (  TLBOutReq_nnnH.Priority  && ~mfifo_full[MISSCH_NUM-1]);
        mfifo_push[0] = TLBOutPipeV_nnnH && TLBOutMsProcV_nnnH && ((~TLBOutReq_nnnH.Priority) && ~mfifo_full[0]);
    end else begin
        mfifo_push[0] = TLBOutPipeV_nnnH && TLBOutMsProcV_nnnH && ~mfifo_full[0];
    end

    mfifo_pop  = MsFifoReqGet;
    MsFifoReqAvail   = mfifo_avail;
    MsfifoCrdRet = mfifo_pop;
    
    for (int i=0; i<MISSCH_NUM; i++) begin
        mfifo_din[i] = TLBOutReq_nnnH;
        mfifo_din[i] = TLBOutReq_nnnH;
    end
end

`include "hqm_devtlb_tlb_params.vh"
localparam TLBFILLLAT = 1+TLB_TAG_WR_CTRL-TLB_TAG_RD_CTRL; // 1 is for the push to missfifo
                                                        //cover "TLB_TAG_WR_CTRL-TLB_TAG_RD_CTRL" xreq lagging Fill

genvar g_msfifo, g_ps, g_id;

logic [TLBFILLLAT:0]        TLBOutPipeV_H;
t_fillinfo [TLBFILLLAT:0]   TLBOutInfo_H;
t_fillreq [TLBFILLLAT:0]    TLBOutReq_H;
logic [TLBFILLLAT:0]        TLBOutCtrlFill_H;

always_comb begin
    TLBOutPipeV_H[0] = TLBOutPipeV_nnnH;
    TLBOutReq_H[0].W = ~(TLBOutCtrl_nnnH.FillReqOp[0]); // FillReqOp=1 if DMA_R
    TLBOutReq_H[0].Address  = TLBOutReq_nnnH.Address;
    TLBOutReq_H[0].PasidV   = DEVTLB_PASID_SUPP_EN? TLBOutReq_nnnH.PasidV: '0;
    TLBOutReq_H[0].PR       = DEVTLB_PASID_SUPP_EN? TLBOutReq_nnnH.PR: '0;
    TLBOutReq_H[0].PASID    = DEVTLB_PASID_SUPP_EN? TLBOutReq_nnnH.PASID: '0;
    TLBOutReq_H[0].BDF      = DEVTLB_BDF_SUPP_EN? TLBOutReq_nnnH.BDF: '0;
    TLBOutReq_H[0].TlbId    = TLBOutReq_nnnH.TlbId;
    TLBOutReq_H[0].MsTrkIdx = TLBOutReq_nnnH.MsTrkIdx;
    TLBOutReq_H[0].MPrior   = TLBOutReq_nnnH.MPrior;
    TLBOutInfo_H[0].W = TLBOutInfo_nnnH.W;
    TLBOutInfo_H[0].R = TLBOutInfo_nnnH.R;
    TLBOutInfo_H[0].PrsCode = TLBOutInfo_nnnH.PrsCode;
    TLBOutInfo_H[0].DPErr = TLBOutInfo_nnnH.ParityError; // for Fill, this is atsrsp dperr only
    TLBOutInfo_H[0].HdrErr = TLBOutInfo_nnnH.HeaderError;
    TLBOutInfo_H[0].FillLast = TLBOutCtrl_nnnH.CtrlFlg.FillLast;
    TLBOutCtrlFill_H[0] = TLBOutCtrl_nnnH.Fill;

    FillTLBOutV = TLBOutPipeV_H[TLBFILLLAT] && TLBOutCtrlFill_H[TLBFILLLAT];
    FillTLBOutMsTrkIdx = TLBOutReq_H[TLBFILLLAT].MsTrkIdx;
    FillTLBOutInfo = TLBOutInfo_H[TLBFILLLAT];
end

generate
for (g_id=1; g_id<=TLBFILLLAT; g_id++) begin : gen_TLBOut
    `HQM_DEVTLB_RST_MSFF(TLBOutPipeV_H[g_id], TLBOutPipeV_H[g_id-1], clk, reset)
    `HQM_DEVTLB_EN_MSFF(TLBOutReq_H[g_id],TLBOutReq_H[g_id-1],clk,TLBOutPipeV_H[g_id-1])
    `HQM_DEVTLB_EN_MSFF(TLBOutInfo_H[g_id],TLBOutInfo_H[g_id-1],clk,TLBOutPipeV_H[g_id-1])
    `HQM_DEVTLB_EN_MSFF(TLBOutCtrlFill_H[g_id],TLBOutCtrlFill_H[g_id-1],clk,TLBOutPipeV_H[g_id-1])
end
endgenerate

T_REQ [MISSCH_NUM-1:0]                      MsFifoReq;
T_REQ [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0]  msfifo;
logic [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0]  msfifo_vld, nxt_msfifo_vld;
logic [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0]  HitMsTrkVld, NxtHitMsTrkVld, SetHitMsTrkVld, ClrHitMsTrkVld, HitMsTrkUpdate;
logic [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0]  HitMsTrkDPErr, NxtHitMsTrkDPErr;
logic [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0]  HitMsTrkHdrErr, NxtHitMsTrkHdrErr;
logic [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0][1:0]  HitMsTrkPrsCode, NxtHitMsTrkPrsCode;
logic [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0]  HitMsTrkForceXRsp, NxtHitMsTrkForceXRsp;
logic [MISSCH_NUM-1:0][MISSFIFO_DEPTH-1:0][$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]  HitMsTrkIdx, NxtHitMsTrkIdx;
logic [MISSCH_NUM-1:0][MISSFIFO_IDW-1:0]    msfifo_wrptr, msfifo_rdptr;

always_comb begin
    for (int i=0; i<MISSCH_NUM; i++) begin
        for (int j=0; j<MISSFIFO_DEPTH; j++) begin
            nxt_msfifo_vld[i][j] = (msfifo_vld[i][j] || (mfifo_push[i] && (msfifo_wrptr[i]==j[MISSFIFO_IDW-1:0]))) && 
                                   ~(mfifo_pop[i] && (msfifo_rdptr[i]==j[MISSFIFO_IDW-1:0]));
            SetHitMsTrkVld[i][j] = TLBOutCtrlFill_H[TLBFILLLAT] && msfifo_vld[i][j] &&
                                   (TLBOutReq_H[TLBFILLLAT].MPrior==msfifo[i][j].MPrior) && 
                                   (TLBOutReq_H[TLBFILLLAT].Address==msfifo[i][j].Address) && 
                                   ((TLBOutReq_H[TLBFILLLAT].PasidV==msfifo[i][j].PasidV) || ~DEVTLB_PASID_SUPP_EN) && 
                                   ((TLBOutReq_H[TLBFILLLAT].PR==msfifo[i][j].PR) || ~DEVTLB_PASID_SUPP_EN) && 
                                   ((TLBOutReq_H[TLBFILLLAT].PASID==msfifo[i][j].PASID) || ~DEVTLB_PASID_SUPP_EN) && 
                                   ((TLBOutReq_H[TLBFILLLAT].BDF==msfifo[i][j].BDF) || ~DEVTLB_BDF_SUPP_EN) && 
                                   (TLBOutReq_H[TLBFILLLAT].TlbId==msfifo[i][j].TlbId) && 
                                   (TLBOutReq_H[TLBFILLLAT].W || (msfifo[i][j].Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_R)));
            ClrHitMsTrkVld[i][j] = mfifo_push[i] && (msfifo_wrptr[i] == j[MISSFIFO_IDW-1:0]);
            HitMsTrkUpdate[i][j] = (TLBOutPipeV_H[TLBFILLLAT] && SetHitMsTrkVld[i][j]) ||
                                   (ClrHitMsTrkVld[i][j]);
            NxtHitMsTrkVld[i][j] = (HitMsTrkVld[i][j] || SetHitMsTrkVld[i][j]) && ~ClrHitMsTrkVld[i][j]; // clr higher priority, not matching the one being pushed, assuming tlb had xrspd it if it is a hit

            NxtHitMsTrkIdx[i][j] = TLBOutReq_H[TLBFILLLAT].MsTrkIdx;
            NxtHitMsTrkDPErr[i][j]  = TLBOutInfo_H[TLBFILLLAT].DPErr;
            NxtHitMsTrkHdrErr[i][j] = TLBOutInfo_H[TLBFILLLAT].HdrErr;
            NxtHitMsTrkPrsCode[i][j] = TLBOutInfo_H[TLBFILLLAT].PrsCode;
            NxtHitMsTrkForceXRsp[i][j] = (~(TLBOutInfo_H[TLBFILLLAT].R || TLBOutInfo_H[TLBFILLLAT].W)) && ~InvMsTrkEnd;

        end
        MsFifoProcReq[i].HitMsTrkVld = HitMsTrkVld[i][msfifo_rdptr[i]];
        MsFifoProcReq[i].HitMsTrkIdx = HitMsTrkIdx[i][msfifo_rdptr[i]];
        MsFifoProcReq[i].DPErr       = HitMsTrkDPErr[i][msfifo_rdptr[i]];
        MsFifoProcReq[i].HdrErr      = HitMsTrkHdrErr[i][msfifo_rdptr[i]];
        MsFifoProcReq[i].PrsCode     = HitMsTrkPrsCode[i][msfifo_rdptr[i]];
        MsFifoProcReq[i].ForceXRsp   = HitMsTrkForceXRsp[i][msfifo_rdptr[i]];

        MsFifoProcReq[i].Req = MsFifoReq[i];
    end
end

generate
for (g_msfifo=0; g_msfifo<MISSCH_NUM; g_msfifo++) begin : gen_msfifo_hit
    for (g_id=0; g_id<MISSFIFO_DEPTH; g_id++) begin : gen_msfifod_hit
        `HQM_DEVTLB_EN_MSFF(HitMsTrkVld[g_msfifo][g_id],NxtHitMsTrkVld[g_msfifo][g_id],clk,HitMsTrkUpdate[g_msfifo][g_id])
        `HQM_DEVTLB_EN_MSFF(HitMsTrkDPErr[g_msfifo][g_id],NxtHitMsTrkDPErr[g_msfifo][g_id],clk,(HitMsTrkUpdate[g_msfifo][g_id]))
        `HQM_DEVTLB_EN_MSFF(HitMsTrkHdrErr[g_msfifo][g_id],NxtHitMsTrkHdrErr[g_msfifo][g_id],clk,(HitMsTrkUpdate[g_msfifo][g_id]))
        `HQM_DEVTLB_EN_MSFF(HitMsTrkPrsCode[g_msfifo][g_id],NxtHitMsTrkPrsCode[g_msfifo][g_id],clk,(HitMsTrkUpdate[g_msfifo][g_id]))
        `HQM_DEVTLB_EN_MSFF(HitMsTrkForceXRsp[g_msfifo][g_id],NxtHitMsTrkForceXRsp[g_msfifo][g_id],clk,(HitMsTrkUpdate[g_msfifo][g_id] || InvMsTrkEnd))
        `HQM_DEVTLB_EN_MSFF(HitMsTrkIdx[g_msfifo][g_id],NxtHitMsTrkIdx[g_msfifo][g_id],clk,HitMsTrkUpdate[g_msfifo][g_id])
        `HQM_DEVTLB_EN_RST_MSFF(msfifo_vld[g_msfifo][g_id], nxt_msfifo_vld[g_msfifo][g_id], clk, (mfifo_push[g_msfifo] || mfifo_pop[g_msfifo]), reset)
    end
end
endgenerate

generate
for (g_msfifo=0; g_msfifo<MISSCH_NUM; g_msfifo++) begin : gen_msfifo
    hqm_devtlb_fifo
    #(
        .NO_POWER_GATING(NO_POWER_GATING),
        .T_REQ(T_REQ),
        .ENTRIES(MISSFIFO_DEPTH)
    ) miss_fifo
    (
        .clk,  //TODO clk gating
        .rst_b(~reset),
        .reset_INST(reset_INST),
        .fscan_latchopen,
        .fscan_latchclosed_b,
        .full(mfifo_full[g_msfifo]),
        .push(mfifo_push[g_msfifo]),
        .wraddr(msfifo_wrptr[g_msfifo]),
        .din(mfifo_din[g_msfifo]),
        .avail(mfifo_avail[g_msfifo]),
        .pop(mfifo_pop[g_msfifo]),
        .rdaddr0(msfifo_rdptr[g_msfifo]),
        .dout(MsFifoReq[g_msfifo]),
        .array(msfifo[g_msfifo])
    );
end
endgenerate

//=====================================================================================================================
// COVERS
//=====================================================================================================================
`ifdef HQM_DEVTLB_COVER_EN

`ifndef HQM_DEVTLB_SVA_OFF

if(DEVTLB_PORT_ID == 0) begin : gen_sva1_portid
   `HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Ack_Fill,
      resp_valid & resp_opcode == DEVTLB_OPCODE_FILL,
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("Valid Ack Status"));
end

/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_ZLREAD
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Valid_UTRN_ZLREAD, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_ZLREAD & resp_status == DEVTLB_RESP_HIT_VALID, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Status"));*/

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Valid_UTRN_R, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_R & resp_status == DEVTLB_RESP_HIT_VALID, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Status"));

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Valid_UTRN_W, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_W & resp_status == DEVTLB_RESP_HIT_VALID, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Status"));

/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_RW
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Valid_UTRN_RW, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_RW & resp_status == DEVTLB_RESP_HIT_VALID, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Status"));*/

/* hkhor1 : Atsrsp.U=1 is not supported in DEVTLB2.0
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Untranslated_UTRN_ZLREAD, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_ZLREAD & resp_status == DEVTLB_RESP_HIT_UTRN, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Untranslated Status"));

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Untranslated_UTRN_R, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_R & resp_status == DEVTLB_RESP_HIT_UTRN, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Untranslated Status"));

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Untranslated_UTRN_W, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_W & resp_status == DEVTLB_RESP_HIT_UTRN, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Untranslated Status"));

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Untranslated_UTRN_RW, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_RW & resp_status == DEVTLB_RESP_HIT_UTRN, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Untranslated Status"));
 hkhor1 : Atsrsp.U=1 is not supported in DEVTLB2.0*/

/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_ZLREAD
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Fault_UTRN_ZLREAD, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_ZLREAD & resp_status == DEVTLB_RESP_HIT_FAULT, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Fault Status"));*/

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Fault_UTRN_R, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_R & resp_status == DEVTLB_RESP_HIT_FAULT, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Fault Status"));

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Fault_UTRN_W, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_W & resp_status == DEVTLB_RESP_HIT_FAULT, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Fault Status"));

/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_RW
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Hit_Fault_UTRN_RW, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_RW & resp_status == DEVTLB_RESP_HIT_FAULT, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Hit Fault Status"));*/   

/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_ZLREAD
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Miss_UTRN_ZLREAD, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_ZLREAD & resp_status == DEVTLB_RESP_MISS, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));*/

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Miss_UTRN_R, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_R & resp_status == DEVTLB_RESP_MISS, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Miss_UTRN_W, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_W & resp_status == DEVTLB_RESP_MISS, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));

/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_RW
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Miss_UTRN_RW, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_RW & resp_status == DEVTLB_RESP_MISS, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));*/


/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_ZLREAD
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Failure_UTRN_ZLREAD, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_ZLREAD & resp_status == DEVTLB_RESP_FAILURE, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));*/

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Failure_UTRN_R, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_R & resp_status == DEVTLB_RESP_FAILURE, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));

`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Failure_UTRN_W, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_W & resp_status == DEVTLB_RESP_FAILURE, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));

/*hkhor1 : DEVTLB2.0 does not support DEVTLB_OPCODE_UTRN_RW
`HQM_DEVTLB_COVERS(DEVTLB_RESULTS_Failure_UTRN_RW, 
   resp_valid & resp_opcode == DEVTLB_OPCODE_UTRN_RW & resp_status == DEVTLB_RESP_FAILURE, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid Miss Status"));*/

`HQM_DEVTLB_COVERS_DELAYED_TRIGGER(CP_HSD22010374473, 
   (TLBOutPipeV_nnnH && TLBOutCtrl_nnnH.Fill && ~|MsFifoReqAvail), 1,
   (((~TLBOutPipeV_nnnH) && ~|MsFifoReqAvail)
   ##1 (TLBOutPipeV_nnnH && (TLBOutReq_nnnH.Opcode==T_OPCODE'(DEVTLB_OPCODE_UTRN_R)) && 
                (`HQM_DEVTLB_GET_TLBID(TLBOutReq_H[0].TlbId, TLBOutInfo_nnnH.PSSel) == 
                 `HQM_DEVTLB_GET_TLBID(TLBOutReq_H[2].TlbId, $past(TLBOutInfo_nnnH.EffSize, 2))) && 
                (TLBOutReq_H[0].MPrior == TLBOutReq_H[2].MPrior) && 
                (TLBOutReq_H[0].Address == TLBOutReq_H[2].Address) &&
                (TLBOutReq_H[0].PasidV == TLBOutReq_H[2].PasidV) &&
                (TLBOutReq_H[0].PR == TLBOutReq_H[2].PR) &&
                (TLBOutReq_H[0].PASID == TLBOutReq_H[2].PASID) &&
                (TLBOutReq_H[0].BDF == TLBOutReq_H[2].BDF) &&
                ~|MsFifoReqAvail)), 
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Fill-RF update latency: matching DMA_R 2 clk later is handled"));

`endif


//=====================================================================================================================
// ASSERTIONS
//=====================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF
`HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_RESULTS_Opcode_Supported,
    resp_valid & (resp_opcode != DEVTLB_OPCODE_UARCH_INV) & (resp_status == DEVTLB_RESP_ACK),
    posedge clk, reset_INST, 
`HQM_DEVTLB_ERR_MSG("DEVTLB Array Following Cycle Read/Write Conflict"));

`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Opcode_Is_Dma_For_Hit_Valid_Status, 
   resp_valid & resp_status == DEVTLB_RESP_HIT_VALID, 
   (f_IOMMU_Opcode_is_DMA(resp_opcode) || f_IOMMU_Opcode_is_FILL(resp_opcode)), 
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Opcode is not a DMA for Hit, Valid status."));

/* hkhor1 : Atsrsp.U=1 is not supported in DEVTLB2.0
`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Opcode_Is_Dma_For_Hit_Untranslated_Status, 
   resp_valid & resp_status == DEVTLB_RESP_HIT_UTRN, 
   (f_IOMMU_Opcode_is_DMA(resp_opcode) || f_IOMMU_Opcode_is_FILL(resp_opcode)), 
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Opcode is not a DMA for Hit, Untranslated status."));
hkhor1 : Atsrsp.U=1 is not supported in DEVTLB2.0*/

`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Opcode_Is_Dma_For_Hit_Fault_Status, 
   resp_valid & resp_status == DEVTLB_RESP_HIT_FAULT, 
   (f_IOMMU_Opcode_is_DMA(resp_opcode) || f_IOMMU_Opcode_is_FILL(resp_opcode)), 
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Opcode is not a DMA for Hit, Fault status."));

`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Opcode_Is_Dma_For_Miss_Status, 
   resp_valid & resp_status == DEVTLB_RESP_MISS, 
   f_IOMMU_Opcode_is_DMA(resp_opcode), 
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Opcode is not a DMA for Miss status."));

`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Opcode_Is_Dma_For_Failure_Status, 
   resp_valid & resp_status == DEVTLB_RESP_FAILURE, 
   (f_IOMMU_Opcode_is_DMA(resp_opcode) || f_IOMMU_Opcode_is_FILL(resp_opcode)), 
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Opcode is not a DMA for Failure status."));

`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Dma_Opcode_Has_Proper_Status, 
   resp_valid 
   & f_IOMMU_Opcode_is_DMA(resp_opcode), 
   resp_status == DEVTLB_RESP_HIT_VALID
   //hkhor1 : Atsrsp.U=1 is not supported in DEVTLB2.0 | resp_status == DEVTLB_RESP_HIT_UTRN
   | resp_status == DEVTLB_RESP_HIT_FAULT
   | resp_status == DEVTLB_RESP_MISS
   | resp_status == DEVTLB_RESP_FAILURE, 
   posedge clk, reset_INST, 
`HQM_DEVTLB_ERR_MSG("Dma opcode did not have one of the proper statuses"));

   `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_RESULTS_Inval_No_XRsp, 
      resp_valid &&  
      ((resp_opcode==DEVTLB_OPCODE_DTLB_INV) ||
       (resp_opcode==DEVTLB_OPCODE_GLB_INV)), 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("Entry was invalidated, but response status was incorrect."));   

if(DEVTLB_PORT_ID == PORT_0) begin : gen_sva2_portid
/* hm no longer true,fill can ended with hit now
   `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Fill_Has_Proper_Status, 
      resp_valid
      & f_IOMMU_Opcode_is_FILL(resp_opcode),
      resp_status == DEVTLB_RESP_ACK, 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("Fill or Inval did not have the proper status."));
*/

end

    `HQM_DEVTLB_ASSERTS_TRIGGER(AS_FULLPUSH, 
      (|mfifo_push), 
      (~|(mfifo_full & mfifo_push)), 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("%t %m failed", $time));  

    `HQM_DEVTLB_ASSERTS_TRIGGER(AS_TLBOUT_ONEHOT, 
      (|{TLBOutMsProcV_nnnH, TLBOutXRspV_nnnH} ), 
      $onehot({TLBOutMsProcV_nnnH, TLBOutXRspV_nnnH}), 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("%t %m failed", $time)); 
   
//When InvEnd, no FillReq anywhere outside of mstrk, otherwise those need to be invalidated, before forcexrsp used for wake
    `HQM_DEVTLB_ASSERTS_TRIGGER(AS_TLBOUT_NOFILLREQ_ATINVEND, 
      InvMsTrkEnd, 
      ((~|FillTLBOutV) && ~|(TLBOutPipeV_H & TLBOutCtrlFill_H)), 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("%t %m failed", $time)); 

    `HQM_DEVTLB_ASSERTS_TRIGGER(AS_TLBOUT_PRSCODE_VALID, 
      TLBOutPipeV_nnnH && ~(TLBOutInfo_nnnH.PrsCode==DEVTLB_PRSRSP_SUC), 
      (TLBOutCtrl_nnnH.Fill || TLBOutCtrl_nnnH.PendQXReq) && TLBOutReq_nnnH.Prs, 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("%t %m failed", $time)); 

generate
for (genvar ch=0; ch<MISSCH_NUM; ch++) begin : gen_as_tlbout_InvEnd_ch
  for (genvar i=0; i<MISSFIFO_DEPTH; i++) begin : gen_as_tlbout_InvEnd_entry
    `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_MsFifo_NOHIT_ForceXRspOrAtsRspErr_ATINVEND, //hsd14013241686
      InvMsTrkEnd, 1,
//      ((~|{HitMsTrkDPErr[ch][i], HitMsTrkHdrErr[ch][i], HitMsTrkForceXRsp[ch][i]}) ||
      ((~|{HitMsTrkForceXRsp[ch][i]}) ||
       (~(HitMsTrkVld[ch][i] && msfifo_vld[ch][i]))),
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("%t %m failed", $time)); 
  end
end
endgenerate

`HQM_DEVTLB_COVERS(DEVTLB_MsFiFo_hit_ForceXRsp_hsd14013241686,
   InvMsTrkEnd &&
   |((HitMsTrkForceXRsp) & HitMsTrkVld & msfifo_vld),
   posedge clk, reset, 
`HQM_DEVTLB_COVER_MSG("Request completes after Hitting IOTLB"));

`HQM_DEVTLB_COVERS(DEVTLB_MsFiFo_hit_HitMsTrkDPErr_hsd14013241686,
   InvMsTrkEnd &&
   |((HitMsTrkDPErr) & HitMsTrkVld & msfifo_vld),
   posedge clk, reset, 
`HQM_DEVTLB_COVER_MSG("Request completes after Hitting IOTLB"));

`HQM_DEVTLB_COVERS(DEVTLB_MsFiFo_hit_HitMsTrkHdrErr_hsd14013241686,
   InvMsTrkEnd &&
   |((HitMsTrkHdrErr) & HitMsTrkVld & msfifo_vld),
   posedge clk, reset, 
`HQM_DEVTLB_COVER_MSG("Request completes after Hitting IOTLB"));

generate
   for (g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin : ps
      for (g_id = 0; g_id < DEVTLB_TLB_NUM_ARRAYS; g_id++) begin : id
         if (DEVTLB_TLB_NUM_SETS[g_id][g_ps]) begin : gen_cp_hit_same_uTLB// Can only hit or fill to a cache that exists
   
            `HQM_DEVTLB_COVERS(DEVTLB_RESULTS_done_hit_same_uTLB,
               TLBOutPipeV_nnnH
               && (TLBOutReq_nnnH.TlbId == g_id)
               && f_IOMMU_Opcode_is_DMA(TLBOutReq_nnnH.Opcode)
               && (TLBOutInfo_nnnH.PSSel == g_ps)
               && TLBOutInfo_nnnH.Hit,
               posedge clk, reset, 
            `HQM_DEVTLB_COVER_MSG("Request completes after Hitting set from a uTLB ID same as xreq_tlbid"));
   
         end

         if (DEVTLB_TLB_NUM_SETS[`HQM_DEVTLB_GET_TLBID(g_id, g_ps)][g_ps]) begin : gen_cp_hit_other_uTLB// Can only hit or fill to a cache that exists
   
            `HQM_DEVTLB_COVERS(DEVTLB_RESULTS_done_hit_other_uTLB,
               TLBOutPipeV_nnnH
               && (TLBOutReq_nnnH.TlbId == g_id)
               && f_IOMMU_Opcode_is_DMA(TLBOutReq_nnnH.Opcode)
               && (TLBOutInfo_nnnH.PSSel == g_ps)
               && TLBOutInfo_nnnH.Hit,
               posedge clk, reset, 
            `HQM_DEVTLB_COVER_MSG("Request completes after Hitting set from a uTLB ID different than xreq_tlbid"));
   
         end
      end
   end
endgenerate

`endif

//`ifdef DEVTLB_COVER_EN // Do not use covers in VCS...it floods the log files with too many messages
//
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid,       resp_valid,                            clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid"));
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_hit,   resp_valid & (resp_status == IOMMU_HIT_RESP),  clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a hit"));
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_fault, resp_valid & (resp_status == IOMMU_UNRECOVERABLE_FAULT_RESP),  clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a fault"));
//
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_snoop0, resp_valid & resp_n,       clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU responsed with no snoop requiured"));
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_snoop1, resp_valid & ~resp_n,       clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU responsed with a  snoop requiured"));
//
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_passthrough0, resp_valid & ~f_IOMMU_Opcode_is_DMA_l3_base_fetch(resp_opcode) & ~resp_passthrough,
//                                                                                    clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU responsed with no passthrough")); 
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_passthrough1, resp_valid & ~f_IOMMU_Opcode_is_DMA_l3_base_fetch(resp_opcode) &  resp_passthrough,
//                                                                                    clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU responsed with a  passthrough"));
//
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_passthrough0_partial, resp_valid &  f_IOMMU_Opcode_is_DMA_l3_base_fetch(resp_opcode) & ~resp_passthrough,
//                                                                                    clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU responsed with no passthrough")); 
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_passthrough1_partial, resp_valid &  f_IOMMU_Opcode_is_DMA_l3_base_fetch(resp_opcode) &  resp_passthrough,
//                                                                                    clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU responsed with a  passthrough"));
//
//generate 
//if (~IOMMU_PI_ATOMIC_EXTERNAL) begin
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_posted_interrupt_NoGenMSI, resp_valid &  f_IOMMU_Opcode_is_Interrupt(resp_opcode) & (resp_status == IOMMU_COMPLETER_ABORT_RESP),
//                                                                                    clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU responsed with no msi"));
//end
//endgenerate
//
//generate
//if (DEVTLB_SVM_SUPPORT_EN) begin
//   `DEVTLB_COVERS(IOMMU_TLB_resp_valid_mt_uc,       resp_valid & (resp_memtype == MEMTYPE_UC),  clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid with MT = UC"));
//   if (DEVTLB_MEMTYPE_EN) begin : Memtype  // Other memtypes are not possible when memtype functionality is not enabled
//      `DEVTLB_COVERS(IOMMU_TLB_resp_valid_mt_uswc,     resp_valid & (resp_memtype == MEMTYPE_USWC),clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid with MT = USWC"));
//      `DEVTLB_COVERS(IOMMU_TLB_resp_valid_mt_wt,       resp_valid & (resp_memtype == MEMTYPE_WT),  clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid with MT = WT"));
//      `DEVTLB_COVERS(IOMMU_TLB_resp_valid_mt_wp,       resp_valid & (resp_memtype == MEMTYPE_WP),  clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid with MT = WP"));
//      `DEVTLB_COVERS(IOMMU_TLB_resp_valid_mt_wb,       resp_valid & (resp_memtype == MEMTYPE_WB),  clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid with MT = WB"));
//      `DEVTLB_COVERS(IOMMU_TLB_resp_valid_mt_ucw,      resp_valid & (resp_memtype == MEMTYPE_UCW), clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid with MT = UCW"));
//   end
//end
//endgenerate
//
//generate
//   for (genvar g_id = 0; g_id < 2**`DEVTLB_LOG2(DEVTLB_TLB_NUM_ARRAYS); g_id++) begin : id
//      `DEVTLB_COVERS(IOMMU_TLB_resp_valid_tlbid, resp_valid & (TLBOutReq_nnnH.TlbId == g_id), clk, reset_INST, `DEVTLB_COVER_MSG("IOMMU delivered a resp_valid with each tlbid"));
//   end
//endgenerate
//
//generate
//   if (DEVTLB_MAX_HOST_ADDRESS_WIDTH > 39) begin : large_haw
//      `DEVTLB_COVERS(IOMMU_result_large_HAW, 
//         resp_valid & (|resp_payload[DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:39]) & f_IOMMU_Opcode_is_DMA(resp_opcode) & (resp_status == IOMMU_HIT_RESP) & ~resp_passthrough & ~TLBOutInfo_nnnH.Fault, clk, reset_INST, 
//         `DEVTLB_COVER_MSG("Bits above 39 assigned"));
//   end
//endgenerate
//
//
//`endif
//
//`ifndef DEVTLB_SVA_OFF
//   `DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_resp_valid_hit_byp, 
//      resp_valid, 
//      TLBOutInfo_nnnH.Hit | TLBOutCtrl_nnnH.Bypass | TLBOutInfo_nnnH.PT | (TLBOutReq_nnnH.Opcode ==  DEVTLB_OPCODE_DTLB_INV_COMP)
//      | (f_IOMMU_Opcode_is_Translation(TLBOutReq_nnnH.Opcode) & (TLBOutInfo_nnnH.FaultReason == DEVTLB_FAULT_RSN_DMA_CTX_MSI)),
//      clk, reset_INST, `DEVTLB_ERR_MSG("IOMMU output without hit or bypass or PT."));
//
//   `DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_resp_illegal_status, 
//      resp_valid,
//           (resp_status == IOMMU_HIT_RESP)  // Success
//         | (resp_status == IOMMU_POSTED_INTR_RESP)  
//         | (resp_status == IOMMU_UNRECOVERABLE_FAULT_RESP)
//         | (resp_status == IOMMU_COMPLETER_ABORT_RESP)
//         | (resp_status == IOMMU_PARITY_ERR_RESP), // Corrupted Request or IOTLB Data Parity Error
//      clk, reset_INST, `DEVTLB_ERR_MSG("IOMMU delivered an illegal status code"));
//
//   `DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_resp_ATS_recoverable_noFault_check,
//      resp_valid & f_IOMMU_Opcode_is_Translation(TLBOutReq_nnnH.Opcode) 
//      & (TLBOutInfo_nnnH.FaultReason inside {DEVTLB_FAULT_RSN_DMA_ADDR_OVERFLOW,
//                                             DEVTLB_FAULT_RSN_DMA_PAGE_W,
//                                             DEVTLB_FAULT_RSN_DMA_PAGE_R,
//                                             DEVTLB_FAULT_RSN_DMA_PASID_P,
//                                             DEVTLB_FAULT_RSN_DMA_ADDR_CANONICAL,
//                                             DEVTLB_FAULT_RSN_DMA_PASID_X,
//                                             DEVTLB_FAULT_RSN_DMA_PASID_ERE,
//                                             DEVTLB_FAULT_RSN_DMA_PASID_SRE,
//                                             DEVTLB_FAULT_RSN_DMA_FL_PAGE_US}),
//      (resp_status == IOMMU_HIT_RESP) || (resp_status == IOMMU_PARITY_ERR_RESP),
//      clk, reset_INST,
//   `DEVTLB_ERR_MSG("Certain faults should be sent as successful by Translation requests or corrupted request"));
//
//   `DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_resp_ATS_abort_check,
//      resp_valid & f_IOMMU_Opcode_is_Translation(TLBOutReq_nnnH.Opcode) 
//      & (TLBOutInfo_nnnH.FaultReason inside {DEVTLB_FAULT_RSN_DMA_CTX_INV,
//                                             DEVTLB_FAULT_RSN_DMA_PAGE_HPA,
//                                             DEVTLB_FAULT_RSN_DMA_RTA,
//                                             DEVTLB_FAULT_RSN_DMA_CTP,
//                                             DEVTLB_FAULT_RSN_DMA_ROOT_RNZ,
//                                             DEVTLB_FAULT_RSN_DMA_CTX_RNZ,
//                                             DEVTLB_FAULT_RSN_DMA_PAGE_RNZ,
//                                             DEVTLB_FAULT_RSN_DMA_PASID_RNZ,
//                                             DEVTLB_FAULT_RSN_DMA_FLPTPTR,
//                                             DEVTLB_FAULT_RSN_DMA_FL_PAGE_RNZ,
//                                             DEVTLB_FAULT_RSN_DMA_FL_PAGE_HPA}),
//      (resp_status == IOMMU_COMPLETER_ABORT_RESP) || (resp_status == IOMMU_PARITY_ERR_RESP),   
//      clk, reset_INST,
//   `DEVTLB_ERR_MSG("Certain faults should be sent as completer abort by Translation requests or corrupted request"));
//
//   if (DEVTLB_PASID_SUPP_EN) begin : PASID_SUPP_EN_FAULT
//      `DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_resp_pasid_fault_check,
//         resp_valid & (TLBOutInfo_nnnH.FaultReason inside { DEVTLB_FAULT_RSN_DMA_CTX_PASIDE,
//                                                            DEVTLB_FAULT_RSN_DMA_CTX_PTS,
//                                                            DEVTLB_FAULT_RSN_DMA_PASID_P,
//                                                            DEVTLB_FAULT_RSN_DMA_PASID_RNZ,
//                                                            DEVTLB_FAULT_RSN_DMA_ADDR_CANONICAL,
//                                                            DEVTLB_FAULT_RSN_DMA_FLPTPTR,
//                                                            DEVTLB_FAULT_RSN_DMA_FL_PAGE_RNZ,
//                                                            DEVTLB_FAULT_RSN_DMA_FL_PAGE_HPA,
//                                                            DEVTLB_FAULT_RSN_DMA_PASID_X,
//                                                            DEVTLB_FAULT_RSN_DMA_PASID_ERE,
//                                                            DEVTLB_FAULT_RSN_DMA_PASID_SRE,
//                                                            DEVTLB_FAULT_RSN_DMA_PASID_RTT,
//                                                            DEVTLB_FAULT_RSN_DMA_FL_PAGE_US}),
//         TLBOutReq_nnnH.PasidV,
//         clk, reset_INST,
//      `DEVTLB_ERR_MSG("Certain faults should only be seen by pasid requests"));
//   end
//   // Overflow fault is added in this assertion but it only exists here due to potentially bad software.
//   // In a normal case, overflow fault should never be seen by Translated requests.
//   `DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_resp_Translated_no_fault_check,
//      resp_valid & TLBOutInfo_nnnH.Fault & ~(TLBOutInfo_nnnH.FaultReason inside {DEVTLB_FAULT_RSN_DMA_ROOT_P,
//                                                                                 DEVTLB_FAULT_RSN_DMA_CTX_P,
//                                                                                 DEVTLB_FAULT_RSN_DMA_CTX_INV,
//                                                                                 DEVTLB_FAULT_RSN_DMA_ADDR_OVERFLOW, // Semi-true
//                                                                                 DEVTLB_FAULT_RSN_DMA_RTA,
//                                                                                 DEVTLB_FAULT_RSN_DMA_CTP,
//                                                                                 DEVTLB_FAULT_RSN_DMA_ROOT_RNZ,
//                                                                                 DEVTLB_FAULT_RSN_DMA_CTX_RNZ,
//                                                                                 DEVTLB_FAULT_RSN_DMA_CTX_T}),
//      ~f_IOMMU_Opcode_is_Translated(TLBOutReq_nnnH.Opcode),
//      clk, reset_INST,
//   `DEVTLB_ERR_MSG("Certain faults should not be seen by Translated requests"));
//   
//   `DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_resp_CTX_DT_EN_fault_is_successful,
//      resp_valid & (TLBOutInfo_nnnH.FaultReason == DEVTLB_FAULT_RSN_DMA_CTX_DT_EN)
//       | ~(CrEcap_nnnH.pt & CrEcap_nnnH.pasid & CrEcap_nnnH.dt),
//       ~(CrEcap_nnnH.pt & CrEcap_nnnH.pasid & CrEcap_nnnH.dt) ? '1 : f_IOMMU_Opcode_is_Translation(TLBOutReq_nnnH.Opcode) && (resp_status == IOMMU_HIT_RESP) && ~TLBOutInfo_nnnH.Fault,
//      clk, reset_INST,
//   `DEVTLB_ERR_MSG("CTX_DT_EN is an internal fault and should not be reported to faultcap or response interface as a fault."));
//
`endif

endmodule

`endif // IOMMU_RESULT_VS

