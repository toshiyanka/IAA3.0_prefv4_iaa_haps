//======================================================================================================================
//
// iommu_iotlb_arb.sv
//
// Contacts            : Camron Rust & George Leming
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 9/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
// This block implements the IOMMU TLB Arbiter which selects a request for the TLB pipeline.
//
//======================================================================================================================

`ifndef HQM_DEVTLB_IOTLB_ARB_VS
`define HQM_DEVTLB_IOTLB_ARB_VS

`include "hqm_devtlb_pkg.vh"

module hqm_devtlb_iotlb_arb (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,
   CrMiscDis_nnnH,
   CrLoXReqGCnt,
   CrHiXReqGCnt,
   CrPendQGCnt,
   CrFillGCnt,
   CrTLBPsDis,
   CrEvictOpPsDis,
   IodtlbEmpty_nnnH,  //for devtlb_idle -> clk gating

   RespCrdRet,
   MsfifoCrdRet,

   TLBBlockArbInfo,
   
   CbHiPipeV_100H,
   CbHiReq_100H,
   CbHiGnt_100H,

   CbLoPipeV_100H,
   CbLoReq_100H,
   CbLoGnt_100H,

   PendQPipeV_100H,
   PendQForceXRsp_100H,
   PendQPrsCode_100H,
   PendQHdrErr_100H,
   PendQDPErr_100H,
   PendQReq_100H,
   PendQGnt_100H,

   InvBlockDMA,
   InvPipeV_100H,
   InvReq_100H,
   InvCtrl_100H,
   InvInfo_100H,
   InvGnt_100H,

   FillPipeV_100H,
   FillReq_100H,
   FillCtrl_100H,
   FillInfo_100H,
   FillGnt_100H,
         
   IotlbArbPipeV_101H,
   IotlbArbReq_101H,
   IotlbArbCtrl_101H,
   IotlbArbInfo_101H,
   
   ObsArbRs_nnnH
//lintra +68099   
);

import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU
`include "hqm_devtlb_pkgparams.vh"

parameter int DEVTLB_PORT_ID                 = 0;
parameter logic ZERO_CYCLE_TLB_ARB           = 0;
parameter logic ALLOW_TLBRWCONFLICT            = 0;  //1 if TLB array allow RW conflict
parameter type T_TAG_ENTRY_0                 = logic;
parameter type T_OPCODE                      = logic; //t_devtlb_opcode;
parameter type T_PGSIZE                      = logic; //t_devtlb_page_type;
parameter int NUM_ARRAYS                     = 0;
parameter int TLBID_WIDTH                    = 6;
parameter int PS_MAX                         = 2;
parameter int PS_MIN                         = 0;
parameter int NUM_PS_SETS  [5:0]             = '{ default:0 };   // Number of sets per TLBID per Size
parameter int NUM_SETS [NUM_ARRAYS:0][5:0]   = '{ default:0 };   // Number of sets per TLBID per Size
parameter logic TLB_SHARE_EN                   = 1'b0;
parameter int TLB_ALIASING [NUM_ARRAYS:0][5:0] = '{ default:0 };
parameter int MISSFIFO_DEPTH                 = 16;
localparam int MISSFIFO_IDW                  = $clog2(MISSFIFO_DEPTH);
parameter type T_TLBBLK_INFO                 = logic; //t_devtlb_arbtlbinfo;
parameter type T_REQ                         = logic; //t_devtlb_request;
parameter type T_REQ_CTRL                    = logic; //t_devtlb_request_ctrl;
parameter type T_REQ_INFO                    = logic; //t_devtlb_request_info;
parameter int MAX_GUEST_ADDRESS_WIDTH        = 64;
parameter int MAX_HOST_ADDRESS_WIDTH         = 64;
parameter type T_SETADDR                     = logic; //t_devtlb_tlb_setaddr;

parameter logic FWDPROG_EN                   = 1'b0;

parameter int   SV_FWDPROG_AS_CONST          = 3;
localparam int  MISSCH_NUM                   = (FWDPROG_EN)? 2: 1;

localparam logic ATSBYPASS_EN = 1'b0;

// TLB Fill block data structure -- used for blocking fills to a TLB to avoid r/w conflicts
typedef struct packed {
   logic                                           Valid;
   logic [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_ARRAYS)-1:0] TlbId;      // The TLB in which to cache the translation
   t_devtlb_page_type                              EffSize;    // PS after fracturing
   T_SETADDR [PS_MAX:PS_MIN]                       SetAddr;    // TLB Specific Set Address
} t_devtlb_fillblock_info;

//`include "devtlb_tlb_params.vh"         // TLB pipeline parameters

//======================================================================================================================
//                                           Interface signal declarations
//======================================================================================================================

   // Interface to IOMMU top level and global signals
   //
   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
   input  logic                           PwrDnOvrd_nnnH;      // Powerdown override
   input  t_devtlb_cr_misc_dis_defeature  CrMiscDis_nnnH;      // Misc defeature register
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    CrLoXReqGCnt;
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    CrHiXReqGCnt;
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    CrPendQGCnt;
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    CrFillGCnt;
   input  logic [PS_MAX:PS_MIN]                   CrTLBPsDis;
   input  logic [PS_MAX:PS_MIN]                   CrEvictOpPsDis;

   output logic                           IodtlbEmpty_nnnH;    // IOMMU tlbarb is idle (empty)
   
   input  logic [MISSCH_NUM-1:0]          RespCrdRet;
   input  logic [MISSCH_NUM-1:0]          MsfifoCrdRet;

   input  T_TLBBLK_INFO                   TLBBlockArbInfo;
  // Interfaces to requesters
   //
   input  logic                           CbLoPipeV_100H;  // Request from credit buffer (low priority)
   input  T_REQ                           CbLoReq_100H;    // Request from credit buffer (low priority)
   output logic                           CbLoGnt_100H;    // Grant to credit buffer (low priority)

   input  logic                           CbHiPipeV_100H;  // Request from credit buffer (high priority)
   input  T_REQ                           CbHiReq_100H;    // Request from credit buffer (high priority)
   output logic                           CbHiGnt_100H;    // Grant to credit buffer (high priority)

   input  logic                           PendQPipeV_100H;  // Request from credit buffer (high priority)
   input  logic                           PendQForceXRsp_100H; // Set to force the replay takes XRSP path.
   input  logic [1:0]                     PendQPrsCode_100H;
   input  logic                           PendQHdrErr_100H; // Set if atsrsp had hdr err
   input  logic                           PendQDPErr_100H; // Set if atsrsp had dperr
   input  T_REQ                           PendQReq_100H;    // Request from credit buffer (high priority)
   output logic                           PendQGnt_100H;    // Grant to credit buffer (high priority)

   input  logic                           InvBlockDMA;
   input  logic                           InvPipeV_100H;   // Request from invalidation engine
   input  T_REQ                           InvReq_100H;
   input  T_REQ_CTRL                      InvCtrl_100H;
   input  T_REQ_INFO                      InvInfo_100H;
   output logic                           InvGnt_100H;    // Grant to credit buffer (high priority)

   input  logic                           FillPipeV_100H;  // Request from Fill
   input  T_REQ                           FillReq_100H;
   input  T_REQ_CTRL                      FillCtrl_100H;
   input  T_REQ_INFO                      FillInfo_100H;
   output logic                           FillGnt_100H;

   // Interfaces to TLB pipeline
   //
   output logic                           IotlbArbPipeV_101H;  // Final request to TLB pipeline
   output T_REQ                           IotlbArbReq_101H;
   output T_REQ_CTRL                      IotlbArbCtrl_101H;
   output T_REQ_INFO                      IotlbArbInfo_101H;
   
   output logic [1:0]                     ObsArbRs_nnnH;

genvar g_id;
//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

// Signals for clock generation
//
//logic                                     ClkCountH;         // Clock gated with global VTD enable

logic                                     ClkTlbArb101H;   // Gated clock
logic                                     ArbLpEn_100H;    // TLB arbiter clock enable
logic                                     MsFifoAccCrdActive;

logic                                     ArbPipeV_100H, ArbPipeV_101H;   // Final request to TLB pipeline
T_REQ                                     ArbReq_100H, ArbReq_101H, LoReq_100H, HiReq_100H;
T_REQ_CTRL                                ArbCtrl_100H, ArbCtrl_101H, LoCtrl_100H, HiCtrl_100H;
T_REQ_INFO                                ArbInfo_100H, ArbInfo_101H, LoInfo_100H, HiInfo_100H;

//======================================================================================================================
//                                                     Clocking
//======================================================================================================================

   logic ClkArbRcb_H;
   `HQM_DEVTLB_MAKE_RCB_PH1(ClkArbRcb_H, clk, /*CountEn_nnnH |*/ ArbLpEn_100H, PwrDnOvrd_nnnH)

   // Create a clock only gated with VTD enable for mostly free-running flops.
   //
   //assign CountEn_nnnH =  InvPipeV_100H
   //                     | CbLoPipeV_100H
   //                     //| (|InFlightVec_nnnH)
   //                     | reset;
 
   //`DEVTLB_MAKE_LCB_PWR(ClkCountH, ClkArbRcb_H, CountEn_nnnH,  PwrDnOvrd_nnnH)

   // The TLB arbiter output staging is clock gated with the final valid bit.
   //
   assign ArbLpEn_100H = reset | InvPipeV_100H                  // Inval requests
                        | FillPipeV_100H
                        | CbHiPipeV_100H                             // New requests
                        | CbLoPipeV_100H                             // New requests
                        | PendQPipeV_100H                             // New requests
                        | IotlbArbPipeV_101H                         // staged requests
                        | (|RespCrdRet)
                        | (|MsfifoCrdRet)
                        | MsFifoAccCrdActive;
                                                                      //inval/fill history

   `HQM_DEVTLB_MAKE_LCB_PWR(ClkTlbArb101H,  ClkArbRcb_H, ArbLpEn_100H,  PwrDnOvrd_nnnH)

//============================================================================================================
//               Configuration
logic ATSBypassModeEn;

always_comb ATSBypassModeEn = ATSBYPASS_EN; // && CrMiscDis_nnnH.ATSBypassModeEn;

//======================================================================================================================
//                                                   mfifo credit
//======================================================================================================================
//logic [MISSCH_NUM-1:0]                   MsFifoFree;
logic [MISSCH_NUM-1:0]                   MsFifoCrdInc, MsFifoCrdDec;
logic [MISSCH_NUM-1:0]                   MsFifoAccCrdInc, MsFifoAccCrdDec;
logic [MISSCH_NUM-1:0][MISSFIFO_IDW:0]   MsFifoCrd, MsFifoAccCrd;
logic [MISSCH_NUM-1:0][MISSFIFO_IDW:0]   MsFifoCrdNxt, MsFifoAccCrdNxt;

always_comb begin : mfifo_credit
    MsFifoAccCrdActive = ~(MsFifoAccCrd=='0);

    if (FWDPROG_EN) begin
        MsFifoCrdDec[MISSCH_NUM-1] = (CbHiGnt_100H || (PendQGnt_100H && PendQReq_100H.Priority));
        MsFifoCrdDec[0]            = (CbLoGnt_100H || (PendQGnt_100H && ~PendQReq_100H.Priority));
    end else begin
        MsFifoCrdDec[0] = (CbHiGnt_100H || (PendQGnt_100H && PendQReq_100H.Priority)) ||
                          (CbLoGnt_100H || (PendQGnt_100H && ~PendQReq_100H.Priority));
    end
    for (int i=0; i<MISSCH_NUM; i++) begin
       MsFifoAccCrdInc[i] = RespCrdRet[i];
       MsFifoAccCrdDec[i] = (~MsfifoCrdRet[i]) & ~(MsFifoAccCrd[i]=='0);
       MsFifoCrdInc[i]    = MsfifoCrdRet[i] || MsFifoAccCrdDec[i];
       
       MsFifoAccCrdNxt[i] = (MsFifoAccCrdInc[i] ^ MsFifoAccCrdDec[i])? 
                            (MsFifoAccCrd[i] + {{(MISSFIFO_IDW){MsFifoAccCrdDec[i]}},1'b1}): MsFifoAccCrd[i];
       MsFifoCrdNxt[i]  = (MsFifoCrdInc[i] ^ MsFifoCrdDec[i])? 
                          (MsFifoCrd[i] + {{(MISSFIFO_IDW){MsFifoCrdDec[i]}},1'b1}): MsFifoCrd[i];
    end
end

generate
for (g_id=0; g_id<MISSCH_NUM; g_id++) begin : gen_crd
    `HQM_DEVTLB_RSTD_MSFF(MsFifoCrd[g_id],MsFifoCrdNxt[g_id],ClkTlbArb101H,reset,MISSFIFO_DEPTH)
    `HQM_DEVTLB_RST_MSFF(MsFifoAccCrd[g_id],MsFifoAccCrdNxt[g_id],ClkTlbArb101H,reset)
    //`DEVTLB_RST_MSFF(MsFifoFree[g_id],(MsFifoCrdNxt[g_id]!='0),ClkTlbArb101H,reset)
end
endgenerate

//======================================================================================================================
//                                                   TLB arbiter
//======================================================================================================================
parameter int INVREQ_GCNT = 4;
parameter int HPREQ_GCNT = 4;
parameter int LPREQ_GCNT = 1;

localparam int TLB_ARB_W = 5;
localparam int TLB_ARB_IDW = $clog2(TLB_ARB_W);

T_REQ_INFO TmpFillInfo_100H;
T_REQ_INFO ForceFillInfo;
logic [TLB_ARB_W-1:0] TlbArbRawReq, TlbArbReq, TlbArbGnt;
logic                                 InvBlockXreq, InvBlockFill;
logic                                 CbLoRs, CbHiRs, PendQHiRs, PendQLoRs;
logic                                 CbLoBlock, CbHiBlock, PendQBlock, FillBlock;

always_comb begin
    TlbArbRawReq = {CbLoPipeV_100H,
                    CbHiPipeV_100H,
                    PendQPipeV_100H,
                    FillPipeV_100H,
                    InvPipeV_100H
                    };
end

always_comb begin
    LoReq_100H  = CbLoReq_100H;
    LoCtrl_100H = '0;
    LoInfo_100H = '0;
    if (CbLoReq_100H.Opcode==T_OPCODE'(DEVTLB_OPCODE_UARCH_INV)) begin
        LoInfo_100H = '0;
        LoInfo_100H.am = '0;
        LoInfo_100H.Size = T_PGSIZE'(`HQM_DEVTLB_PS_4K); //SIZE_4K
        LoInfo_100H.Global = ~CbLoReq_100H.PasidV;

        LoCtrl_100H = '0;
        LoCtrl_100H.GL = ~CbLoReq_100H.PasidV; 
        LoCtrl_100H.InvalGlb = '0;
        LoCtrl_100H.InvalDTLB = '1;
        LoCtrl_100H.InvalMaskBits = '0; //InvalMaskBits i [5:0]  always 4k, i.e 0
        LoCtrl_100H.InvalBdfMask  = ~DEVTLB_BDF_SUPP_EN;
        //LoCtrl_100H.InvalPasidMask= ~(InvReq.PasidV && PASID_SUPP_ON);
        LoCtrl_100H.InvalSetAddr = '0; //no scanning
        for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
            LoCtrl_100H.DisRdEn[tlb_ps] = CrEvictOpPsDis[tlb_ps];
        end
    end

    HiReq_100H  = CbHiReq_100H;
    HiCtrl_100H = '0;
    HiInfo_100H = '0;
    if (CbHiReq_100H.Opcode==T_OPCODE'(DEVTLB_OPCODE_UARCH_INV)) begin
        HiInfo_100H = '0;
        HiInfo_100H.am = '0;
        HiInfo_100H.Size = T_PGSIZE'(`HQM_DEVTLB_PS_4K); //SIZE_4K
        HiInfo_100H.Global = ~CbHiReq_100H.PasidV;

        HiCtrl_100H = '0;
        HiCtrl_100H.GL = ~CbHiReq_100H.PasidV; 
        HiCtrl_100H.InvalGlb = '0;
        HiCtrl_100H.InvalDTLB = '1;
        HiCtrl_100H.InvalMaskBits = '0; //InvalMaskBits i [5:0]  always 4k, i.e 0
        HiCtrl_100H.InvalBdfMask  = ~DEVTLB_BDF_SUPP_EN;
        //HiCtrl_100H.InvalPasidMask= ~(InvReq.PasidV && PASID_SUPP_ON);
        HiCtrl_100H.InvalSetAddr = '0; //no scanning
        for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
            HiCtrl_100H.DisRdEn[tlb_ps] = CrEvictOpPsDis[tlb_ps];
        end
    end
end

always_comb begin
    //Fill may writes a page differnt than xreq's read, SetAddr is not comparable
    CbLoBlock    = '0;
    CbHiBlock    = '0;
    PendQBlock   = '0;
    FillBlock     = '0;
    for (int ps=PS_MIN; ps<=PS_MAX; ps++) begin
    //assumption on TLBBlockArbInfo.TlbId: each XEvict invalidating 1 PS only.
        CbLoBlock    |= (TLBBlockArbInfo.TlbId == TLBID_WIDTH'(`HQM_DEVTLB_GET_TLBID(LoReq_100H.TlbId, ps))); 
        CbHiBlock    |= (TLBBlockArbInfo.TlbId == TLBID_WIDTH'(`HQM_DEVTLB_GET_TLBID(HiReq_100H.TlbId, ps))); 
        PendQBlock   |= (TLBBlockArbInfo.TlbId == TLBID_WIDTH'(`HQM_DEVTLB_GET_TLBID(PendQReq_100H.TlbId, ps))); 
        FillBlock    |= (TLBBlockArbInfo.TlbId == TLBID_WIDTH'(`HQM_DEVTLB_GET_TLBID(FillReq_100H.TlbId, ps)));
    end
    CbLoBlock    &= ALLOW_TLBRWCONFLICT? 1'b0: (TLBBlockArbInfo.Fill || TLBBlockArbInfo.InvalDTLB); 
    CbHiBlock    &= ALLOW_TLBRWCONFLICT? 1'b0: (TLBBlockArbInfo.Fill || TLBBlockArbInfo.InvalDTLB); 
    PendQBlock   &= ALLOW_TLBRWCONFLICT? 1'b0: (TLBBlockArbInfo.Fill || TLBBlockArbInfo.InvalDTLB); 
    FillBlock    &= ALLOW_TLBRWCONFLICT? 1'b0: TLBBlockArbInfo.InvalDTLB && //WrEn due to Evict
                   (TLBBlockArbInfo.DisRdEn == FillCtrl_100H.DisRdEn);
    InvBlockXreq = InvBlockDMA;
    InvBlockFill = '0;
    //TODO Inter-port xreq blocking: Arb for non-port_0 may need to block xreq to avoid conflicting with Fill at port_0
    // intra-port xreq blocking: -no xreq within 1-N cycle following a Fill in TLB
    //                           -no Fill within 1-M cycle following a Fill in TLB 

    TlbArbReq = { CbLoPipeV_100H && ~(CbLoBlock || InvBlockXreq),
                  CbHiPipeV_100H && ~(CbHiBlock || InvBlockXreq),
                  PendQPipeV_100H && ~(PendQBlock || InvBlockXreq),
                  FillPipeV_100H && ~(FillBlock || InvBlockFill),  //This FillBlock is for FillUarchInvBlock, FillFillBlock is implemented in MsTrk
                  InvPipeV_100H
                }; //RoundRobin is granting req from lsb to msb

    {CbLoGnt_100H,
     CbHiGnt_100H,
     PendQGnt_100H,
     FillGnt_100H,
     InvGnt_100H} = TlbArbGnt;
     
    ArbPipeV_100H = |TlbArbGnt;

    ForceFillInfo    = '0;
    ForceFillInfo.Size = T_PGSIZE'(SIZE_4K);
    ForceFillInfo.N = 1'b0;
    ForceFillInfo.U = 1'b1;
    ForceFillInfo.R = 1'b1;
    ForceFillInfo.W = 1'b1;
    ForceFillInfo.X = 1'b1;
    ForceFillInfo.Global = 1'b1;
    ForceFillInfo.Priv_Data = '0;
    ForceFillInfo.Memtype = '0;

    TmpFillInfo_100H = FillInfo_100H;
    unique casez (FillInfo_100H.Size)
       // QP page size may not be compatibile with certain GPA/HPA combinations
       /* SIZE_QP : begin
            if (MAX_GUEST_ADDRESS_WIDTH > 48) begin
               TmpFillInfo_100H.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_QP)]
                   = FillReq_100H.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_QP)];
            end else begin
               TmpFillInfo_100H.Address = '0;
            end
        end*/
        //SIZE_5T : TmpFillInfo_100H.Address[`DEVTLB_TLB_UNTRAN_RANGE(`DEVTLB_PS_5T)]
        //                = FillReq_100H.Address[`DEVTLB_TLB_UNTRAN_RANGE(`DEVTLB_PS_5T)];

        SIZE_1G : TmpFillInfo_100H.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_1G)]
                        = FillReq_100H.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_1G)];

        SIZE_2M : TmpFillInfo_100H.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_2M)]
                        = FillReq_100H.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_2M)];

        default: ;   // This is to make Jasper not complain about an incomplete case
    endcase

   unique casez (1'b1)
        CbLoGnt_100H   : begin
                        ArbReq_100H = LoReq_100H;
                        //if (ATSBypassModeEn) ArbReq_100H.Opcode = T_OPCODE'(DEVTLB_OPCODE_FILL);
                        ArbCtrl_100H = LoCtrl_100H;
                        //ArbCtrl_100H.Fill = ATSBypassModeEn;
                        ForceFillInfo.Address = LoReq_100H.Address[MAX_HOST_ADDRESS_WIDTH-1:12];
                        //ArbInfo_100H = ATSBypassModeEn? ForceFillInfo: '0;
                        ArbInfo_100H = LoInfo_100H;
                       end
        CbHiGnt_100H   : begin
                        ArbReq_100H = CbHiReq_100H;
                        //if (ATSBypassModeEn) ArbReq_100H.Opcode = T_OPCODE'(DEVTLB_OPCODE_FILL);
                        ArbCtrl_100H = HiCtrl_100H;
                        //ArbCtrl_100H.Fill = ATSBypassModeEn;
                        ForceFillInfo.Address = CbHiReq_100H.Address[MAX_HOST_ADDRESS_WIDTH-1:12];
                        //ArbInfo_100H = ATSBypassModeEn? ForceFillInfo: '0;
                        ArbInfo_100H = HiInfo_100H;
                       end
        PendQGnt_100H  : begin
                        ArbReq_100H = PendQReq_100H;
                        ArbCtrl_100H = '0;
                        ArbCtrl_100H.PendQXReq = 1'b1;
                        ArbCtrl_100H.ForceXRsp = PendQForceXRsp_100H;
                        ArbInfo_100H = '0;
                        ArbInfo_100H.HeaderError = PendQHdrErr_100H;
                        ArbInfo_100H.ParityError = PendQDPErr_100H;
                        ArbInfo_100H.PrsCode     = PendQPrsCode_100H;
                       end
        FillGnt_100H   : begin
                        ArbReq_100H = FillReq_100H;
                        ArbCtrl_100H = FillCtrl_100H;
                        ArbInfo_100H = TmpFillInfo_100H;
                       end
        InvGnt_100H    : begin
                        ArbReq_100H = InvReq_100H;
                        ArbCtrl_100H = InvCtrl_100H;
                        ArbInfo_100H = InvInfo_100H;
                       end
        default        : begin
                        ArbReq_100H = InvReq_100H;
                        ArbCtrl_100H = InvCtrl_100H;
                        ArbInfo_100H = InvInfo_100H;
                       end
    endcase

    for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
        ArbCtrl_100H.DisRdEn[tlb_ps] |= CrTLBPsDis[tlb_ps];
    end

   // IOTLB Pipe outputs
    IotlbArbPipeV_101H = (ZERO_CYCLE_TLB_ARB == 1) ? ArbPipeV_100H: ArbPipeV_101H;
    IotlbArbReq_101H   = (ZERO_CYCLE_TLB_ARB == 1) ? ArbReq_100H: ArbReq_101H;
    IotlbArbCtrl_101H  = (ZERO_CYCLE_TLB_ARB == 1) ? ArbCtrl_100H: ArbCtrl_101H;
    IotlbArbInfo_101H  = (ZERO_CYCLE_TLB_ARB == 1) ? ArbInfo_100H: ArbInfo_101H;
end

logic [TLB_ARB_W-1:0][DEVTLB_TLB_ARBGCNT_WIDTH-1:0] cr_gcnt;
logic [TLB_ARB_W-1:0] arb_rs;
always_comb begin
    cr_gcnt = {CrLoXReqGCnt,
               CrHiXReqGCnt,
               CrPendQGCnt,
               CrFillGCnt,
               INVREQ_GCNT[DEVTLB_TLB_ARBGCNT_WIDTH-1:0]
               };

    arb_rs = {CbLoRs,
              CbHiRs,
              (PendQReq_100H.Priority? PendQHiRs: PendQLoRs),
              1'b1,
              1'b1};
end
hqm_devtlb_rrarbdgpr #(.REQ_W (TLB_ARB_W), .REQ_IDW (TLB_ARB_IDW), .GCNT_IDW(DEVTLB_TLB_ARBGCNT_WIDTH-1), .GCNT_DIS(5'b00001))
   rr_ats_arb (.clk(ClkTlbArb101H), .rst_b(~reset), .reset_INST(reset_INST), .cr_gcnt(cr_gcnt), .arb_rs(arb_rs), .arb_rawreq(TlbArbRawReq), .arb_req(TlbArbReq), .arb_gnt(TlbArbGnt));

generate
if (FWDPROG_EN) begin:   gen_ready
    `HQM_DEVTLB_RSTD_MSFF(CbLoRs, (MsFifoCrdNxt[0]!='0), clk, reset, 1'b1)
    `HQM_DEVTLB_RSTD_MSFF(CbHiRs, (MsFifoCrdNxt[MISSCH_NUM-1]!='0), clk, reset, 1'b1)
    `HQM_DEVTLB_RSTD_MSFF(PendQHiRs, (MsFifoCrdNxt[MISSCH_NUM-1]!='0), clk, reset, 1'b1)
    `HQM_DEVTLB_RSTD_MSFF(PendQLoRs, (MsFifoCrdNxt[0]!='0), clk, reset, 1'b1)
end else begin
    `HQM_DEVTLB_RSTD_MSFF(CbLoRs, (MsFifoCrdNxt[0]!='0), clk, reset, 1'b1)
    `HQM_DEVTLB_RSTD_MSFF(CbHiRs, (MsFifoCrdNxt[0]!='0), clk, reset, 1'b1)
    `HQM_DEVTLB_RSTD_MSFF(PendQLoRs, (MsFifoCrdNxt[0]!='0), clk, reset, 1'b1)
   
    always_comb PendQHiRs = PendQLoRs;
end
endgenerate

//TODO
   //assert (FillBid_100H |->~InvBlockDMA)

generate
if (ZERO_CYCLE_TLB_ARB == 1) begin:   ZERO_LATENCY
   // IOTLB Pipe outputs
   assign ArbPipeV_101H = '0;
   assign ArbReq_101H   = '0;
   assign ArbCtrl_101H  = '0;
   assign ArbInfo_101H  = '0;

end
else begin: ONE_LATENCY
   `HQM_DEVTLB_RSTD_MSFF(ArbPipeV_101H, ArbPipeV_100H, ClkTlbArb101H, reset, 1'b0)
   `HQM_DEVTLB_MSFF(ArbReq_101H,   ArbReq_100H,   ClkTlbArb101H)
   `HQM_DEVTLB_MSFF(ArbCtrl_101H,  ArbCtrl_100H,  ClkTlbArb101H)
   `HQM_DEVTLB_MSFF(ArbInfo_101H,  ArbInfo_100H,  ClkTlbArb101H)
end
endgenerate

assign IodtlbEmpty_nnnH = '0;

always_comb begin
    ObsArbRs_nnnH = {CbHiRs, CbLoRs};
end

//======================================================================================================================
//                                                       Covers 
//======================================================================================================================
//`ifndef VISA_CHECK 
`ifdef HQM_DEVTLB_COVER_EN
`HQM_DEVTLB_COVERS( DEVTLB_TlbArb_InvalBlockPendQ,
    (InvGnt_100H && PendQReq_100H)
    /*(InvReq_100H.Ctrl.InvalGlb || ()*/,
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("PendQ Request is blocked by Inval"));

`HQM_DEVTLB_COVERS_TRIGGER( DEVTLB_TlbArb_CbHiBlock,
    (CbHiPipeV_100H),
    CbHiBlock,
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("Request is blocked to prevent TLB array RW conflict"));

`HQM_DEVTLB_COVERS_TRIGGER( DEVTLB_TlbArb_CbLoBlock,
    (CbLoPipeV_100H),
    CbLoBlock,
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("Request is blocked to prevent TLB array RW conflict"));

`HQM_DEVTLB_COVERS_TRIGGER( DEVTLB_TlbArb_PendQBlock,
    (PendQPipeV_100H),
    PendQBlock,
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("Request is blocked to prevent TLB array RW conflict"));

`HQM_DEVTLB_COVERS_TRIGGER( DEVTLB_TlbArb_FillBlock,
    (FillPipeV_100H),
    FillBlock,
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("Request is blocked to prevent TLB array RW conflict"));

`endif
//`endif


//======================================================================================================================
//                                                    Assertions
//======================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF

`ifdef INTEL_SIMONLY
logic [TLB_ARB_IDW+4:0] as_CbLoReqHoldCnt, as_CbHiReqHoldCnt, as_PendQReqHoldCnt, as_FillReqHoldCnt, as_InvReqHoldCnt;

generate
if (FWDPROG_EN) begin : gen_asreqhold 
always_ff @(posedge clk) begin
     as_CbLoReqHoldCnt <= (reset || CbLoGnt_100H)? '0: ((CbLoPipeV_100H && (|MsFifoCrd[0]) && ~(CbLoBlock || InvBlockXreq))? (as_CbLoReqHoldCnt+1): as_CbLoReqHoldCnt);
     as_CbHiReqHoldCnt <= (reset || CbHiGnt_100H)? '0: ((CbHiPipeV_100H && (|MsFifoCrd[1]) && ~(CbHiBlock || InvBlockXreq))? (as_CbHiReqHoldCnt+1): as_CbHiReqHoldCnt);
     as_PendQReqHoldCnt <= (reset || PendQGnt_100H)? '0: ((PendQPipeV_100H && (|(PendQReq_100H.Priority? MsFifoCrd[1]: MsFifoCrd[0])) && ~(PendQBlock || InvBlockXreq))? (as_PendQReqHoldCnt+1): as_PendQReqHoldCnt);
     as_FillReqHoldCnt <= (reset || FillGnt_100H)? '0: (FillPipeV_100H && ~(FillBlock || InvBlockFill))? (as_FillReqHoldCnt+1): as_FillReqHoldCnt;
     as_InvReqHoldCnt <= (reset || InvGnt_100H)? '0: InvPipeV_100H? (as_InvReqHoldCnt+1): as_InvReqHoldCnt;
end
end else begin : gen_asreqhold_else
always_ff @(posedge clk) begin
     as_CbLoReqHoldCnt <= (reset || CbLoGnt_100H)? '0: ((CbLoPipeV_100H && (~|MsFifoCrd[0]) && ~(CbLoBlock || InvBlockXreq))? (as_CbLoReqHoldCnt+1): as_CbLoReqHoldCnt);
     as_CbHiReqHoldCnt <= (reset || CbHiGnt_100H)? '0: ((CbHiPipeV_100H && (~|MsFifoCrd[0]) && ~(CbHiBlock || InvBlockXreq))? (as_CbHiReqHoldCnt+1): as_CbHiReqHoldCnt);
     as_PendQReqHoldCnt <= (reset || PendQGnt_100H)? '0: ((PendQPipeV_100H && (~|MsFifoCrd[0]) && ~(PendQBlock || InvBlockXreq))? (as_PendQReqHoldCnt+1): as_PendQReqHoldCnt);
     as_FillReqHoldCnt <= (reset || FillGnt_100H)? '0: (FillPipeV_100H && ~(FillBlock || InvBlockFill))? (as_FillReqHoldCnt+1): as_FillReqHoldCnt;
     as_InvReqHoldCnt <= (reset || InvGnt_100H)? '0: InvPipeV_100H? (as_InvReqHoldCnt+1): as_InvReqHoldCnt;
end
end
endgenerate

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_CbLoReqFwdProg,
    (CbLoPipeV_100H),
    (as_CbLoReqHoldCnt < SV_FWDPROG_AS_CONST*(CrHiXReqGCnt+CrPendQGCnt+CrFillGCnt)),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_CbHiReqFwdProg,
    (CbHiPipeV_100H),
    (as_CbHiReqHoldCnt < SV_FWDPROG_AS_CONST*(CrLoXReqGCnt+CrPendQGCnt+CrFillGCnt)),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_PendQReqFwdProg,
    (PendQPipeV_100H),
    (as_PendQReqHoldCnt < SV_FWDPROG_AS_CONST*(CrLoXReqGCnt+CrHiXReqGCnt+CrFillGCnt)),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_FillReqFwdProg,
    (FillPipeV_100H),
    (as_FillReqHoldCnt < SV_FWDPROG_AS_CONST*(CrLoXReqGCnt+CrHiXReqGCnt+CrPendQGCnt)),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_InvReqFwdProg,
    (InvPipeV_100H),
    (as_InvReqHoldCnt < TLB_ARB_W),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`endif //INTEL_INST_ON

//`DEVTLB_ASSERTS_NEVER(DEVTLB_TlbArb_Gnt_Select_Inv, InvGnt_100H  & ~InvSel_100H,  clk, reset_INST, `DEVTLB_ERR_MSG("TlbArb Grant requires matching select"));
//`DEVTLB_ASSERTS_NEVER(DEVTLB_TlbArb_Gnt_Select_CbL, CbLoGnt_100H, clk, reset_INST, `DEVTLB_ERR_MSG("TlbArb Grant requires matching select"));

`HQM_DEVTLB_ASSERTS_NEVER( IOMMU_MsFifoCrd0_vld,
    (MsFifoCrd[0]>MISSFIFO_DEPTH),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("bad MsFifoCrd"));
`HQM_DEVTLB_ASSERTS_NEVER( IOMMU_MsFifoCrd1_vld,
    (MsFifoCrd[1]>MISSFIFO_DEPTH),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("bad MsFifoCrd"));


`HQM_DEVTLB_ASSERTS_NEVER( IOMMU_TlbArb_LoXReqGCnt,
    (CrLoXReqGCnt=='0),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Zero Grant Count"));

`HQM_DEVTLB_ASSERTS_NEVER( IOMMU_TlbArb_HiXReqGCnt,
    (CrHiXReqGCnt=='0),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Zero Grant Count"));

`HQM_DEVTLB_ASSERTS_NEVER( IOMMU_TlbArb_PendQGCnt,
    (CrPendQGCnt=='0),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Zero Grant Count"));

`HQM_DEVTLB_ASSERTS_NEVER( IOMMU_TlbArb_FillGCnt,
    (CrFillGCnt=='0),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Zero Grant Count"));

`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_TlbArb_Grant_Mutex,
    |{CbLoGnt_100H, CbHiGnt_100H, PendQGnt_100H, FillGnt_100H, InvGnt_100H},
    $onehot({CbLoGnt_100H, CbHiGnt_100H, PendQGnt_100H, FillGnt_100H, InvGnt_100H}),
    posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("IOMMU TLB arbiter grants must be mutex"));

generate
for (g_id=2; g_id<=4; g_id++) begin : gen_as_arb_rs
`HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_TlbArb_noRS_Grant_Others,
    (TlbArbReq[g_id] && (|TlbArbGnt) && ~arb_rs[g_id]),
    ~TlbArbGnt[g_id],
    posedge clk, reset_INST,
  `HQM_DEVTLB_ERR_MSG("Request has no RS, should grant others."));
end
endgenerate

//`DEVTLB_ASSERTS_NEVER(IOMMU_TlbArb_ReqCount_Overflow,
//         IommuFull_nnnH & ReqCountInc_100H & ~ReqCountDec_nnnH, clk, reset_INST,
//         `DEVTLB_ERR_MSG("IOMMU request counter overflow."));

//`DEVTLB_ASSERTS_NEVER(IOMMU_TlbArb_PwNotBypass,
//         PwPipeV_100H & ~PwCtrl_100H.Bypass, clk, reset_INST,
//         `DEVTLB_ERR_MSG("All requests from pagewalker are expected to bypass IOTLB fill path."));

//`DEVTLB_ASSERTS_NEVER(IOMMU_TlbArb_ReqCount_Underflow,
//   IodtlbEmpty_nnnH & ReqCountDec_nnnH & ~ReqCountInc_100H, clk, reset_INST,
//   `DEVTLB_ERR_MSG("IOMMU request counter underflow."));

//`DEVTLB_ASSERTS_NEVER(IOMMU_TlbArb_FillNotPW,
//   ArbPipeV_100H & ArbCtrl_100H.Fill & ~PwGnt_100H, clk, reset_INST,
//   `DEVTLB_ERR_MSG("Fill not from pagewalker."));
//
//`DEVTLB_ASSERTS_NEVER(IOMMU_TlbArb_PwNotFill,
//   PwPipeV_100H & PwCtrl_100H.Fill & PwInfo_100H.Fault, clk, reset_INST,
//   `DEVTLB_ERR_MSG("Pagewalker should not fill faulting requests."));
//
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_TlbArb_IECInval_no_arbpipev,
//                     IECInvPipeV_100H & ~RCCInvPipeV_100H,
//                     ~ArbPipeV_100H,
//                     clk, reset_INST, `DEVTLB_ERR_MSG("IEC inval should not grant to IOTLB/TTC/IEC-Leaf pipeline"));
//
//   if (PWTRK_NUM_BANKS > 1) begin : Banks
//      if ((NUM_PS_SETS[0] > 1)
//       || (NUM_PS_SETS[1] > 1)
//       || (NUM_PS_SETS[2] > 1)
//       || (NUM_PS_SETS[3] > 1)
//       || (NUM_PS_SETS[4] > 1)) begin : Mult_Fill    // More than one set in the array
//`DEVTLB_ASSERTS_TRIGGER  (IOMMU_TlbArb_blocks_new_fills_when_prior_fills_still_in_TLB_pipeline,
//                           PwBid_100H & PwCtrl_100H.Fill & FillBlock_Pw_H,
//                           ~PwGnt_100H,
//                           clk, reset_INST, `DEVTLB_ERR_MSG("If there is a fill in the TLB pipeline, arb cannot grant another fill."));
//      end
//   end
//
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbTtcArb_gnt_means_tlb_and_ttc_both_gnt,
//   TTCEnable_100H                                              // TTC pipe is enabled
//   & (CbHiGnt_100H | CbLoGnt_100H | PqGnt_100H | PwGnt_100H)   // a request was granted
//   & (~(InvSel_100H & RCCInvPipeV_100H & ~InvPipeV_100H)) // the request is not an RCC invalidation 
//   & ~QIPipeV_100H,                                            // the request is not DTLB Invalidation Completion 
//   TTCArbPipeV_100H & IotlbArbPipeV_100H,                      // both pipes must be enabled
//   clk, reset_INST,
//   `DEVTLB_ERR_MSG("TTC and IOTLB arb pipes should both be firing."));
//
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbTtcArb_ttc_must_gnt_ptfill_and_rccinv,
//                       ~InvalPreBlock_nnnH
//                       & ArbPipeV_100H 
//                       & (  (TTCInvalGnt_100H) 
//                          | (TTCFill_100H)
//                         ),
//                        TTCArbPipeV_100H,
//                        clk, reset_INST,
//                        `DEVTLB_ERR_MSG("If an RCC invalidation or PT req is granted, the TTC pipe must be activated."));
//
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbTtcArb_ttc_iotlb_must_fire_on_gnt,
//                      (PwGnt_100H | CbHiGnt_100H | CbLoGnt_100H | PqGnt_100H) & TTCHasValidEnt_101H & ~QIPipeV_100H,
//                      TTCArbPipeV_100H & IotlbArbPipeV_100H,                      // both pipes must be enabled
//                       clk, reset_INST,
//                       `DEVTLB_ERR_MSG("TTC and IOTLB arb pipes should both be firing for CB and PQ grants."));
//                    
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbTtcArb_ttc_and_iotlb_fill_blocks_must_match,
//                        TTCFillBlock_H,
//                        ~IotlbArbPipeV_100H,
//                        clk, reset_INST, `DEVTLB_ERR_MSG("TTC and IOTLB fill blocks not matched. pipes will be out of sync")); 
//
//
//generate
//if (IEC_NUM_PS_SETS[0] > 0) begin : IEC_COVERS
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbArb_Interrupt_IEC_IOTLB_PipeV,
//                     IECArbPipeV_100H && IotlbArbPipeV_100H,
//                     f_IOMMU_Opcode_is_Interrupt(IECArbReq_100H.Opcode) && IECArbReq_100H.Address[IOMMU_IR_FORMAT_POS],
//                     clk, reset_INST, `DEVTLB_ERR_MSG("IEC and IOTLB pipelines are accessed simultaneously only by remapped interrupts.")); 
//
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbArb_Interrupt_IEC_IOTLB_same_info_req,
//                     IECArbPipeV_100H && IotlbArbPipeV_100H,
//                     (IECArbReq_100H == IotlbArbReq_101H),
//                     clk, reset_INST, `DEVTLB_ERR_MSG("IEC and IOTLB pipelines should have the same information going into them.")); 
//
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbArb_Interrupt_IEC_IOTLB_same_info_ctrl,
//                     IECArbPipeV_100H && IotlbArbPipeV_100H,
//                     (IECArbCtrl_100H == IotlbArbCtrl_100H),
//                     clk, reset_INST, `DEVTLB_ERR_MSG("IEC and IOTLB pipelines should have the same information going into them.")); 
//end 
//
//`DEVTLB_ASSERTS_TRIGGER(IOMMU_IotlbArb_Interrupt_fill_does_not_trigger_IEC_pipeline,
//                     PwGnt_100H && f_IOMMU_Opcode_is_Interrupt(PwReq_100H.Opcode),
//                     ~IECArbPipeV_100H,
//                     clk, reset_INST, `DEVTLB_ERR_MSG("Interrupts from Fill FSM should never go down IEC pipeline."));
//endgenerate
                     
`endif

endmodule

`endif // IOMMU_TLBARB_VS
