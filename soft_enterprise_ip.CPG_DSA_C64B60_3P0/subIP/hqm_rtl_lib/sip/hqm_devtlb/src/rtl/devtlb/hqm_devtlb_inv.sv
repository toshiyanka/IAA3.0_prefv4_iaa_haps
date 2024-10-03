//=====================================================================================================================
//
// iommu_inv.sv
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

`ifndef HQM_DEVTLB_INV_VS
`define HQM_DEVTLB_INV_VS

`include "hqm_devtlb_pkg.vh"
`include "hqm_devtlb_inv_tlb.sv"
`include "hqm_devtlb_inv_drain.sv"

module hqm_devtlb_inv
    import `HQM_DEVTLB_PACKAGE_NAME::*;
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter int REQ_PAYLOAD_MSB = 63,
    parameter int REQ_PAYLOAD_LSB = 12,
    parameter logic BDF_SUPP_EN = DEVTLB_BDF_SUPP_EN,
    parameter int BDF_WIDTH = DEVTLB_BDF_WIDTH,
    parameter logic PASID_SUPP_EN = DEVTLB_PASID_SUPP_EN,
    parameter int PASID_WIDTH = DEVTLB_PASID_WIDTH,
    parameter logic ZERO_CYCLE_TLB_ARB  = 1,  // 1 - TLB ARB has zero latency
    parameter int READ_LATENCY  = 1, // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
    parameter int TLB_NUM_ARRAYS = DEVTLB_TLB_NUM_ARRAYS,                   // The number of TLBID's supported
    parameter int TLB_NUM_SETS [TLB_NUM_ARRAYS:0][5:0] = '{ default:0 },
    parameter logic TLB_SHARE_EN                       = 1'b0,
    parameter int TLB_ALIASING [TLB_NUM_ARRAYS:0][5:0] = '{ default:0 },
    parameter int PS_MAX = IOTLB_PS_MAX,
    parameter int PS_MIN = IOTLB_PS_MIN,
    parameter logic PF_INV_VF = 1'b0,
    parameter type T_INVREQ = logic, //t_devtlb_invreq,
    parameter type T_REQ = logic, //t_devtlb_request,
    parameter type T_REQ_CTRL = logic, //t_devtlb_request_ctrl,
    parameter type T_REQ_INFO = logic, //t_devtlb_request_info,
    parameter type T_OPCODE = logic, //t_devtlb_opcode,
    parameter type T_PGSIZE = logic //t_devtlb_page_type
)(
   input    logic                               clk,
   input    logic                               reset,
   input    logic                               reset_INST,
   input    logic                               fscan_clkungate,
   input    logic [BDF_WIDTH-1:0]               CrPFId,
   input    logic                               PwrDnOvrd_nnnH,   // Powerdown override
   input    logic                               DisPartInv_nnnH,  // Configuration: covert to Global Inval
   
   //initialization - Invalidation request src 1: reset exit.
   output  logic                                InvInitDone,
   output  logic                                tlb_reset_active,

   //Invalidation request src 2: force inv
   input    logic                               ImplicitInv_nnnH,   // Triggiers a global invalidation of all TLBs.
   input    logic [BDF_WIDTH-1:0]               ImplicitInvBDF_nnnH,   // Triggiers a global invalidation of all TLBs.
   input    logic                               ImplicitInvBDFV_nnnH,   // Triggiers a global invalidation of all TLBs.
   input    logic [PASID_WIDTH-1:0]             ImplicitInvPASID_nnnH,   // Triggiers a global invalidation of all TLBs.
   input    logic                               ImplicitInvPasidV_nnnH,   // Triggiers a global invalidation of all TLBs.

   //Invalidation request src: force inv
   input   logic                                InvIfReqPut,
   input   T_INVREQ                             InvIfReq,  //valid one clk afterter InvIfReqPut
   output  logic                                InvIfReqFree,

   output  logic                                InvIfCmpAvail,
   output  logic [7:0]                          InvIfCmpTC,
   output  logic [4:0]                          InvIfCmpITag,
   output  logic [BDF_WIDTH-1:0]                InvIfCmpBDF,
   input   logic                                InvIfCmpGet,

   //Invalidation request to MsTrk
   output  logic                               InvMsTrkStart,
   output  logic                               InvMsTrkEnd,
   output  logic [BDF_WIDTH-1:0]               InvBDF,
   output  logic                               InvBdfV,
   output  logic [PASID_WIDTH-1:0]             InvPASID,
   output  logic                               InvPasidV,
   output  logic                               InvGlob,
   output  logic                               InvAOR,
   output  logic [REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB] InvAddr,
   output  logic [REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB] InvAddrMask,
   input   logic                               InvMsTrkBusy,//use this >=1 clk after InvMsTrkStart
   input   logic                               MsTrkFillInFlight,

   // Final Request output to TLB
   output   logic                               InvPipeV_100H,
   output   T_REQ                               InvReq_100H,   // Result
   output   T_REQ_CTRL                          InvCtrl_100H,  // Result
   output   T_REQ_INFO                          InvInfo_100H,  // Result
   input    logic                               InvGnt_100H,

   //Block control
   output   logic                               InvBlockDMA,
   output   logic                               InvBlockFill,
   input    logic                               TLBOutInvTail_nnH,  //Inv req reach end of TLB 

   //Drain Interface
   output   logic                               drainreq_valid,  // request to drain ALL transaction in Q
   output logic [PASID_WIDTH-1:0]               drainreq_pasid,
   output logic                                 drainreq_pasid_priv,
   output logic                                 drainreq_pasid_valid,
   output logic                                 drainreq_pasid_global,
   output logic [BDF_WIDTH-1:0]                 drainreq_bdf,
   output logic                                 drainreq_bdf_valid,
   input    logic                               drainreq_ack,    // set when a drainreq is accepted.
   input    logic                               drainrsp_valid,  // set when a drain req is processed, i.e outstanding request are flushed or marked for translation retry. 
   input    logic [7:0]                         drainrsp_tc,     // Traffic Class (bitwise) used by the hosting unit for all transaction.
   // Obs Signals
   //
   output   logic [2:0]                         ObsIotlbInvPs_nnnH,
   output   logic [2:0]                         ObsIotlbInvBusy_nnnH,
   output   logic                               ObsIotlbGlbInProg_nnnH,             // IOTLB global invalidation in progress
   output   logic                               ObsIotlbPgSInProg_nnnH             // IOTLB invalidation in progress
);

//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

localparam  PAGE_SIZE_STRIDE = 9;  // The must be 9 otherwise the multiple TLB pagesize invalidation uarch breaks. Not all 9 bits must be used, however.

localparam int ADDRESS_W  = REQ_PAYLOAD_MSB+1;
localparam int PGOFFSET_W = REQ_PAYLOAD_LSB;
localparam int LSHIFT_MAX = ADDRESS_W-PGOFFSET_W;
localparam int ESIZE_IDW  = $clog2(LSHIFT_MAX);

typedef struct packed {
//    logic [BDF_WIDTH-1:0]          bdfmask; // 
//    logic [PASID_WIDTH-1:0]        pasidmask; //
    logic [ADDRESS_W-1:PGOFFSET_W] addrmask; // 4k all 0; 8k 0..1{1}; 2^46 0..34{1}
    logic [ESIZE_IDW-1:0] esize;  //encoded size location 0=4k, 1=8k ... 34=2^46
} t_invreq_datadec;

function automatic t_invreq_datadec get_invreq_datadec  (                            
                                input logic alladdr,
                                input logic size,
                                input logic [ADDRESS_W-1:PGOFFSET_W] va);
    //logic                 badsize;
    logic [ESIZE_IDW-1:0] ls0_ind;
    logic [ADDRESS_W-1:PGOFFSET_W] inverted_addrmask;
    //if S is 1, and all va bit is 1, assert error and default to invalidate ALL, vs spec said undefined.
    //badsize = &{va, size}; //if true or alladdr, esize=ls0_ind=LSHIFT_MAX, addrmask='1

    ls0_ind = LSHIFT_MAX[ESIZE_IDW-1:0];
    for (int j=(ADDRESS_W-PGOFFSET_W); j>=(PGOFFSET_W-PGOFFSET_W+1); j--) if (va[(j+PGOFFSET_W-1)]==1'b0) ls0_ind  =  j[ESIZE_IDW-1:0];
    inverted_addrmask = ('1 << ls0_ind);
    get_invreq_datadec.addrmask    = size? (~inverted_addrmask): '0; 
    get_invreq_datadec.esize       = size? ls0_ind: '0;
    if (alladdr) get_invreq_datadec.addrmask = '1;
    if (alladdr) get_invreq_datadec.esize = LSHIFT_MAX[ESIZE_IDW-1:0];
endfunction

typedef enum logic [2:0] {
    INVIDLE,
    INVSAMPLE,
    INVFLUSHFILL,
    INVFILLEND,
    INVTLB,
    INVHOLD,
    INVDRAIN,
    INVCMP
} t_inv_fsm;

//=====================================================================================================================
// Global signals
//=====================================================================================================================

logic                               ResetInvAvail, setResetInvAvail, clrResetInvAvail;
logic                               ImplicitInvAvail, setImplicitInvAvail, clrImplicitInvAvail;
logic                               InitInval, setInitInval, clrInitInval;
logic                               InitInvalBdfV, InitInvalPasidV;
logic [BDF_WIDTH-1:0]               InitInvalBDF;
logic [PASID_WIDTH-1:0]             InitInvalPASID;

t_inv_fsm InvFSMPs, InvFSMNs;

logic                               InvTLBStart, InvTLBBusy;
logic                               InvDrainPut;
logic                               InvDrainBusy;
logic                               InvTLBEnd;
logic                               SkipDrain;

logic                               setInvBlockDMA, clrInvBlockDMA;
logic                               InvTLBDlyReload, InvTLBDlyDec, InvTLBDlyDone;
logic [1:0]                         InvTLBDly, NxtInvTLBDly; //counter to dly InvTLB by N clk after fill flushed.

logic                               NxtInvIfCmpAvail;

//=====================================================================================================================
// CLOCK GENERATION
//=====================================================================================================================
   logic pEn_ClkInval_H;
   logic ClkInval_H;
   logic ClkInvalRcb_H;

   always_comb pEn_ClkInval_H   = reset | ResetInvAvail | ImplicitInvAvail
                                | ImplicitInv_nnnH
                                | InvIfReqPut | InvIfCmpAvail | drainrsp_valid | InvIfCmpGet
                                | (~(InvFSMPs==INVIDLE))
                                | InvTLBEnd;                                

   `HQM_DEVTLB_MAKE_RCB_PH1(ClkInvalRcb_H, clk, pEn_ClkInval_H,  PwrDnOvrd_nnnH)
   `HQM_DEVTLB_MAKE_LCB_PWR(ClkInval_H, ClkInvalRcb_H, pEn_ClkInval_H,  PwrDnOvrd_nnnH)

//=====================================================================================================================
//Inv Sources
always_comb begin
    setResetInvAvail  = 1'b0;
    setImplicitInvAvail = ImplicitInv_nnnH && ~ImplicitInvAvail;
end
`HQM_DEVTLB_RSTD_MSFF(ResetInvAvail,((ResetInvAvail || setResetInvAvail) && ~clrResetInvAvail),ClkInval_H,reset,1'b1)
`HQM_DEVTLB_RSTD_MSFF(ImplicitInvAvail,((ImplicitInvAvail || setImplicitInvAvail) && ~clrImplicitInvAvail),ClkInval_H,reset,1'b0)
`HQM_DEVTLB_EN_RSTD_MSFF(InitInvalBdfV,(ImplicitInvBDFV_nnnH && ImplicitInv_nnnH),ClkInval_H,setImplicitInvAvail,reset,1'b0)
`HQM_DEVTLB_EN_MSFF(InitInvalBDF,ImplicitInvBDF_nnnH,ClkInval_H,setImplicitInvAvail)
`HQM_DEVTLB_EN_RSTD_MSFF(InitInvalPasidV,(ImplicitInvPasidV_nnnH && ImplicitInv_nnnH),ClkInval_H,setImplicitInvAvail,reset,1'b0)
`HQM_DEVTLB_EN_MSFF(InitInvalPASID,ImplicitInvPASID_nnnH,ClkInval_H,setImplicitInvAvail)

//=====================================================================================================================
always_comb begin
    clrResetInvAvail  = 1'b0;
    clrImplicitInvAvail = 1'b0;
    setInitInval  = 1'b0;
    clrInitInval  = 1'b0;

    InvMsTrkStart = 1'b0; 
    InvTLBStart   = 1'b0;
    InvMsTrkEnd   = 1'b0;
    InvDrainPut   = 1'b0;
    SkipDrain     = 1'b0;
    
    setInvBlockDMA = '0;
    clrInvBlockDMA = '0;
    InvTLBDlyReload= '0;
    InvTLBDlyDec   = '0;

    NxtInvIfCmpAvail = InvIfCmpAvail;

    InvFSMNs = InvFSMPs;
    
    case (InvFSMPs)
        INVIDLE: begin
            if (ResetInvAvail) begin
                setInvBlockDMA = '1;
                setInitInval = 1'b1;
                InvFSMNs = INVSAMPLE;
            end else if(ImplicitInvAvail) begin
                clrImplicitInvAvail = 1'b1;
                setInitInval = 1'b1;
                InvFSMNs = INVSAMPLE;
            end else if(InvIfReqPut) begin
                InvFSMNs = INVSAMPLE;
            end
        end
        INVSAMPLE: begin
            if(ResetInvAvail) begin
                InvFSMNs = INVFLUSHFILL;
                clrResetInvAvail = 1'b1;
            end else if (InvIfReq.InvAOR && (InvIfReq.PasidV || ~PASID_SUPP_EN) && ~InitInval) begin
                InvFSMNs = INVCMP;
                NxtInvIfCmpAvail = 1'b1;
                SkipDrain = 1'b1;
                //clrInvBlockDMA = ~InvIfReqAvail; // todo assertion if InvIfReqAvail at here, will come back here to clr
            end else begin
                InvFSMNs = INVFLUSHFILL;
                InvMsTrkStart = 1'b1; // this will stop mstrk initiating any new fill reqv
            end
        end
        INVFLUSHFILL: 
            if(~MsTrkFillInFlight) begin // wait for ongoing fill reqv to finish,
                InvTLBDlyReload = '1;    // ideally all the way to end of TLB pipe, but 2 clk gap is sufficient
                setInvBlockDMA = '1;
                InvFSMNs = INVFILLEND;     // to avoid read write conflict
            end
        INVFILLEND: begin //assert no $rose(MsTrkFillInFlight) this and after this point.
            if(~InvTLBDlyDone) begin
                InvTLBDlyDec = '1;
            end else begin
                InvTLBDlyDec = '0;
                InvTLBStart = 1'b1;
                if (~InitInval)  InvDrainPut = 1'b1;
                InvFSMNs = INVTLB; // see mstrk: assert no $rose(MsTrkFillInFlight) between invstart & invend
            end
        end
        INVTLB: begin 
            if((~InvTLBBusy) && ~InvMsTrkBusy) begin // InvTLBBusy deasserts after last invReq reach end of TLB pipe.
                //clrInvBlockDMA = ~InvIfReqAvail; // todo assertion if InvIfReqAvail at here, will come back here to clr
                clrInvBlockDMA = 1'b1;
                InvMsTrkEnd   = 1'b1;
                if (InitInval) begin
                    clrInitInval = 1'b1;
                    InvFSMNs = INVIDLE;
                end else begin
                    InvFSMNs = INVDRAIN;
                end
            end
        end
        INVDRAIN: begin
            if(~InvDrainBusy) begin
                InvFSMNs = INVCMP;
                NxtInvIfCmpAvail = 1'b1;
             end
        end
        INVCMP: begin
            if(InvIfCmpGet) begin
                InvFSMNs = INVIDLE;
                NxtInvIfCmpAvail = 1'b0;
            end
        end
        default: ;
    endcase
end

//FSM output
always_comb begin
    InvIfReqFree = (InvFSMPs==INVIDLE) && (~ImplicitInvAvail) && (~ResetInvAvail);
    NxtInvTLBDly = InvTLBDlyReload? 2'b01: (InvTLBDlyDec? (InvTLBDly-'d1): InvTLBDly);
    InvTLBDlyDone = (InvTLBDly=='0);
end

T_INVREQ               InvInReq;
logic                  InvInAllAddr, InvInAll;
t_invreq_datadec       InvInDatDec;
always_comb begin 
    InvInAll = DisPartInv_nnnH ||
                ResetInvAvail ||
                (({(InitInvalBdfV && BDF_SUPP_EN), (InitInvalPasidV && PASID_SUPP_EN)}=='0) && InitInval) ||
                (InvIfReq.InvQPErr && ~InitInval);

    if (InitInval) begin
        InvInAllAddr = '1;
        InvInReq        = '0;
        InvInReq.BdfV   = InitInvalBdfV;
        InvInReq.BDF    = InvInReq.BdfV? InitInvalBDF: '0;
        InvInReq.PasidV = InitInvalPasidV;
        InvInReq.PASID  = InvInReq.PasidV? InitInvalPASID: '0;
    end else begin
        InvInAllAddr = DisPartInv_nnnH;
        InvInReq = InvIfReq;
        InvInReq.BdfV &= ~((InvIfReq.BDF == CrPFId[BDF_WIDTH-1:0]) && PF_INV_VF);
        if (InvIfReq.IODPErr) begin
            InvInAllAddr = '1;  //Pasid match is performed in cased of InvReq.PasidV=1
            InvInReq.Glob = '1; //all Pasid
        end
    end
    InvInReq.BdfV   &= BDF_SUPP_EN;
    InvInReq.PasidV &= PASID_SUPP_EN;

    InvInDatDec = get_invreq_datadec(InvInAllAddr, InvIfReq.Size, InvIfReq.Address);
    
end

logic [ESIZE_IDW-1:0]  InvESize;
logic                  InvAll;
T_INVREQ               SavedInvIfReq;

`HQM_DEVTLB_RSTD_MSFF(InvFSMPs,InvFSMNs,ClkInval_H,reset,INVIDLE)
`HQM_DEVTLB_RSTD_MSFF(InitInval,((InitInval || setInitInval) && ~clrInitInval),ClkInval_H,reset,1'b0)
`HQM_DEVTLB_EN_MSFF(SavedInvIfReq,InvInReq,ClkInval_H,(InvFSMPs==INVSAMPLE))
`HQM_DEVTLB_EN_MSFF(InvAddrMask,InvInDatDec.addrmask,ClkInval_H,(InvFSMPs==INVSAMPLE))
`HQM_DEVTLB_EN_MSFF(InvESize,InvInDatDec.esize,ClkInval_H,(InvFSMPs==INVSAMPLE))
`HQM_DEVTLB_EN_MSFF(InvAll,InvInAll,ClkInval_H,(InvFSMPs==INVSAMPLE))
`HQM_DEVTLB_RSTD_MSFF(InvBlockDMA, ((setInvBlockDMA || InvBlockDMA) && ~clrInvBlockDMA), ClkInval_H, reset, '1)
`HQM_DEVTLB_EN_MSFF(InvTLBDly, NxtInvTLBDly, ClkInval_H, (InvTLBDlyDec || InvTLBDlyReload)) 

always_comb begin
    InvAddr      = SavedInvIfReq.Address;
    InvAOR       = SavedInvIfReq.InvAOR;
    InvPASID     = SavedInvIfReq.PASID;
    InvPasidV    = SavedInvIfReq.PasidV;
    InvGlob      = SavedInvIfReq.Glob;
    InvBDF       = SavedInvIfReq.BDF;
    InvBdfV      = SavedInvIfReq.BdfV;

    InvIfCmpITag = SavedInvIfReq.ITag;
    InvIfCmpBDF  = SavedInvIfReq.BDF; 
    InvBlockFill = InvBlockDMA;
end

`HQM_DEVTLB_RSTD_MSFF(InvIfCmpAvail,NxtInvIfCmpAvail,ClkInval_H,reset,1'b0)
`HQM_DEVTLB_EN_MSFF(InvIfCmpTC,(drainrsp_valid? drainrsp_tc : 8'h01),ClkInval_H,(drainrsp_valid | SkipDrain))

//=====================================================================================================================
//PINVTLB
logic InvTLBFree;

hqm_devtlb_inv_tlb 
#(
    .NO_POWER_GATING(NO_POWER_GATING),
    .ESIZE_IDW(ESIZE_IDW),
    .T_INVREQ(T_INVREQ),
    .T_REQ(T_REQ),
    .T_REQ_CTRL(T_REQ_CTRL),
    .T_REQ_INFO(T_REQ_INFO),
    .T_OPCODE(T_OPCODE),
    .T_PGSIZE(T_PGSIZE),
    .REQ_PAYLOAD_MSB(REQ_PAYLOAD_MSB),
    .REQ_PAYLOAD_LSB(REQ_PAYLOAD_LSB),
    .TLB_NUM_ARRAYS(TLB_NUM_ARRAYS),
    .READ_LATENCY(READ_LATENCY),
    .TLB_NUM_SETS(TLB_NUM_SETS),
    .TLB_SHARE_EN(TLB_SHARE_EN),
    .TLB_ALIASING(TLB_ALIASING),
    .BDF_SUPP_EN(BDF_SUPP_EN),
    .BDF_WIDTH(BDF_WIDTH),
    .PASID_SUPP_EN(PASID_SUPP_EN),
    .PASID_WIDTH(PASID_WIDTH),
    .PS_MAX(PS_MAX),
    .PS_MIN(PS_MIN)
) devtlb_inv_tlb (
    .clk(clk),
    .reset(reset),
    .reset_INST(reset_INST),
    .fscan_clkungate(fscan_clkungate),
    .PwrDnOvrd_nnnH(PwrDnOvrd_nnnH),
    //.DisPartInv_nnnH(DisPartInv_nnnH),
    
    .InvPut(InvTLBStart),
    .InvGlb(InvAll),
    .InvESize(InvESize),
    .InvReq(SavedInvIfReq),
    .InvFree(InvTLBFree),
    
    .InvTLBAvail(InvPipeV_100H),
    .InvTLBReq(InvReq_100H),
    .InvTLBCtrl(InvCtrl_100H),
    .InvTLBInfo(InvInfo_100H),
    .InvTLBGet(InvGnt_100H),
    .TLBOutInvTail(TLBOutInvTail_nnH),
    
    .InvEnd(InvTLBEnd)  //InvTLBEnd is for InvInitDone only , it does not wait for TLBOutInvTail_nnH.
);

logic InvInitDone_i;
always_comb begin
    InvTLBBusy = ~InvTLBFree;
    InvInitDone = InvInitDone_i;
    tlb_reset_active = ImplicitInvAvail || InitInval || ResetInvAvail;
end
`HQM_DEVTLB_RSTD_MSFF(InvInitDone_i,(InvInitDone_i || InvTLBEnd),ClkInval_H,reset,1'b0)
 
//=====================================================================================================================
hqm_devtlb_inv_drain
#(  .T_INVREQ(T_INVREQ),
    .BDF_SUPP_EN(BDF_SUPP_EN),
    .BDF_WIDTH(BDF_WIDTH),
    .PASID_SUPP_EN(PASID_SUPP_EN),
    .PASID_WIDTH(PASID_WIDTH),
    .NO_POWER_GATING(NO_POWER_GATING)
) devtlb_inv_drain (
    .clk(clk),
    .reset(reset),
    .reset_INST(reset_INST),
    .fscan_clkungate(fscan_clkungate),
    .PwrDnOvrd_nnnH(PwrDnOvrd_nnnH),
    
    .TLBOutInvTail(TLBOutInvTail_nnH),

    .InvDrainPut(InvDrainPut),
    .InvReq(SavedInvIfReq),
    .InvDrainBusy(InvDrainBusy),
   
    .drainreq_valid(drainreq_valid),
    .drainreq_pasid(drainreq_pasid),
    .drainreq_pasid_priv(drainreq_pasid_priv),
    .drainreq_pasid_valid(drainreq_pasid_valid),
    .drainreq_pasid_global(drainreq_pasid_global),
    .drainreq_bdf(drainreq_bdf),
    .drainreq_bdf_valid(drainreq_bdf_valid),
    .drainreq_ack(drainreq_ack),
    
    .drainrsp_valid(drainrsp_valid),
    .drainrsp_tc(drainrsp_tc)
);

//=====================================================================================================================
// Obs Signals 
//=====================================================================================================================

assign ObsIotlbGlbInProg_nnnH             =  InvPipeV_100H     &  InvCtrl_100H.InvalGlb;
assign ObsIotlbPgSInProg_nnnH             =  InvPipeV_100H     &  InvCtrl_100H.InvalDTLB;
assign ObsIotlbInvPs_nnnH                 =  `HQM_DEVTLB_ZX(InvFSMPs,$bits(ObsIotlbInvPs_nnnH));
assign ObsIotlbInvBusy_nnnH               =  {InvMsTrkBusy, InvTLBBusy, InvDrainBusy};

`ifndef HQM_DEVTLB_SVA_OFF

generate
if (PASID_SUPP_EN) begin : gen_cp_PASID_SUPP_EN
    `HQM_DEVTLB_COVERS_TRIGGER(CP_PASIDSUPP_EN_InvReqWithoutPasidV,
       InvIfReqPut,
       (~InvIfReq.PasidV),
       posedge clk, reset_INST,
    `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

    `HQM_DEVTLB_COVERS_TRIGGER(CP_PASIDSUPP_EN_InvReqWithoutPasidV_AOR,
       InvIfReqPut,
       (InvIfReq.InvAOR && ~InvIfReq.PasidV),
       posedge clk, reset_INST,
    `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

    `HQM_DEVTLB_COVERS_TRIGGER(CP_PASIDSUPP_EN_InvReqWithPasidV_AOR,
       InvIfReqPut,
       (InvIfReq.InvAOR && InvIfReq.PasidV),
       posedge clk, reset_INST,
    `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));
end else begin : gen_cp_PASID_SUPP_DIS
    `HQM_DEVTLB_COVERS_TRIGGER(CP_InvReq_AOR,
       InvIfReqPut,
       (InvIfReq.InvAOR),
       posedge clk, reset_INST,
    `HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));
end
endgenerate

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_DEVTLB_InvIfReqPut_Reception,
     InvIfReqPut, 1, ((InvFSMPs==INVSAMPLE) && ~InitInval),
     posedge clk, reset_INST,
     `HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_DEVTLB_INV_FillInFlightFlush,
     $rose(MsTrkFillInFlight),
     !((InvFSMPs==INVFILLEND) || (InvFSMPs==INVTLB)),
     posedge clk, reset_INST,
     `HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_DEVTLB_INV_SKIPDRAIN_DRAINRSP,
    (|{SkipDrain, drainrsp_valid}),
    ($onehot({SkipDrain, drainrsp_valid})),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

//`DEVTLB_ASSERTS_TRIGGER( AS_DEVTLB_INV_DRAINRSP_TC,
//    (drainrsp_valid),
//    (|drainrsp_tc),
//    posedge clk, reset_INST,
//`DEVTLB_ERR_MSG("%t %m failed", $time));

`endif //DEVTLB_SVA_OFF

endmodule
`endif // IOMMU_INV_VS

