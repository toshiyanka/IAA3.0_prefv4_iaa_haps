//=====================================================================================================================
//
// devtlb_inv_tlb.sv
//
// Contacts            : Hai Ming Khor
// Original Date       : 12/2019
//
// -- Intel Proprietary
// -- Copyright (C) 2019 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_IODLTB_INV_TLB_VS
`define HQM_IODLTB_INV_TLB_VS

`include "hqm_devtlb_pkg.vh"

module hqm_devtlb_inv_tlb 
    import `HQM_DEVTLB_PACKAGE_NAME::*;
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter int REQ_PAYLOAD_MSB = 63,
    parameter int REQ_PAYLOAD_LSB = 12,
    parameter logic ZERO_CYCLE_TLB_ARB  = 1,  // 1 - TLB ARB has zero latency
    parameter int READ_LATENCY  = 1, // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
    parameter int TLB_NUM_ARRAYS = 32, // The number of TLBID's supported
    parameter int TLB_NUM_SETS [TLB_NUM_ARRAYS:0][5:0] = '{ default:0 },
    parameter logic TLB_SHARE_EN                       = 1'b0,
    parameter int TLB_ALIASING [TLB_NUM_ARRAYS:0][5:0] = '{ default:0 },
    parameter type T_INVREQ = logic, //t_devtlb_invreq,
    parameter type T_REQ = logic, //t_devtlb_request,
    parameter type T_REQ_CTRL = logic, //t_devtlb_request_ctrl,
    parameter type T_REQ_INFO = logic, //t_devtlb_request_info,
    parameter type T_OPCODE   = logic, //t_devtlb_opcode,
    parameter type T_PGSIZE = logic, //t_devtlb_page_type,
    parameter int ESIZE_IDW  = $clog2(REQ_PAYLOAD_MSB+1-REQ_PAYLOAD_LSB), // max is 6 it.
    parameter logic BDF_SUPP_EN = DEVTLB_BDF_SUPP_EN,
    parameter int BDF_WIDTH = DEVTLB_BDF_WIDTH,
    parameter logic PASID_SUPP_EN = DEVTLB_PASID_SUPP_EN,
    parameter int PASID_WIDTH = DEVTLB_PASID_WIDTH,
    parameter int PS_MAX = IOTLB_PS_MAX,
    parameter int PS_MIN = IOTLB_PS_MIN
) (
    input    logic                               clk,
    input    logic                               reset,
    input    logic                               reset_INST,
    input    logic                               fscan_clkungate, 
    input    logic                               PwrDnOvrd_nnnH,      // Powerdown override
//    input    logic                               DisPartInv_nnnH,

    input    logic                               InvPut,
    input    logic                               InvGlb,  // Invalidate all tlb, for reset/implicit invalidate without bdf
    input    logic [ESIZE_IDW-1:0]               InvESize, //all below are don't care if InvGlb=1
    input    T_INVREQ                            InvReq,
    output   logic                               InvFree,

    output   logic                               InvTLBAvail,
    output   T_REQ                               InvTLBReq,
    output   T_REQ_CTRL                          InvTLBCtrl,
    output   T_REQ_INFO                          InvTLBInfo,
    input    logic                               InvTLBGet,
    
    input    logic                               TLBOutInvTail,
    
    output   logic                               InvEnd
);

`include "hqm_devtlb_tlb_params.vh"
localparam int TLBID_WIDTH = `HQM_DEVTLB_LOG2(TLB_NUM_ARRAYS);

function automatic logic [1+PS_MAX:PS_MIN] getMaxTLBNUMSETS (
                        input logic [TLBID_WIDTH-1:0] TlbId,
                        input logic [ESIZE_IDW-1:0] InvESize,
                        input logic [15:0]           SetAddr,
                        input logic                  AllSet
);
    logic [15:0]                    tlb_max_setaddr;
    logic [PS_MAX:PS_MIN][15:0]     ps_max_setaddr;
    logic [TLB_NUM_ARRAYS:0][PS_MAX:PS_MIN][15:0]           tlb_max_setid;
    logic [PS_MAX:PS_MIN][REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB]  set_num_mask;
    logic [PS_MAX:PS_MIN]                                   DisPsRd;
    tlb_max_setaddr = '0;
    for(int ps=PS_MIN; ps <= PS_MAX; ps++) begin //no tlbid aliasing is needed for inv
        tlb_max_setid[TLB_NUM_ARRAYS][ps] = '0;
        for (int i=0; i<TLB_NUM_ARRAYS; i++) begin
            tlb_max_setid[i][ps] = '0;
            if (~(TLB_NUM_SETS[i][ps][15:0]==0))    tlb_max_setid[i][ps] = TLB_NUM_SETS[i][ps][15:0] -16'd1;
        end
    end
    DisPsRd = '0;
    for(int ps=PS_MIN; ps <= PS_MAX; ps++) begin
        set_num_mask[ps]    = AllSet? '0: ('1 << InvESize);
        set_num_mask[ps]    = (set_num_mask[ps]>>(ps*9)); //need to shift in '1 if ps >2
        ps_max_setaddr[ps]  = tlb_max_setid[TlbId][ps][15:0] & 
                              ~set_num_mask[ps][REQ_PAYLOAD_LSB+:16]; //lintra s-0241    TlbId stop at max, so won't be out of bounds 
        if(ps_max_setaddr[ps]>tlb_max_setaddr) tlb_max_setaddr = ps_max_setaddr[ps];
        if(SetAddr > ps_max_setaddr[ps]) DisPsRd[ps] = 1'b1;
    end
    getMaxTLBNUMSETS = {(tlb_max_setaddr==SetAddr), DisPsRd};
endfunction

function automatic logic IsEmptyTLBNUMSETS (
                        input logic [TLBID_WIDTH-1:0] TlbId
);
    IsEmptyTLBNUMSETS = 1'b1;
    for(int ps=PS_MIN; ps <= PS_MAX; ps++) begin
        if(TLB_NUM_SETS[TlbId][ps][15:0]!=0) IsEmptyTLBNUMSETS = 1'b0 ; //lintra s-0241    TlbId stop at max, so won't be out of bounds
    end
endfunction

//====================================================================================================================
localparam int INVALIN = 0;
localparam int INVALOUT = INVALIN + 1;

genvar g_stage;

//Inval FSM
typedef enum logic [1:0] {
    INVTLBIDLE,
    INVTLBINC,
    INVTLBEND 
} t_invtlb_state;

//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

// Signal for Clock generation
logic                                       pEn_ClkInv_H;
logic                                       ClkInv_H;
logic                                       ClkInvRcb_H;
logic [INVALOUT-1:INVALIN  ]                pEn_ClkInvPipe_H;
logic [INVALOUT  :INVALIN+1]                ClkInvPipe_H;

//global
logic                                       InvalGlb_i;
logic                                       InvalDTLB;

//FSM
t_invtlb_state                              InvTlbPs, InvTlbNs;
logic                                       InvTlbPsIdle, InvTlbPsInc;

//Pipe Stage Signals
logic                                       InvPipeStall;
logic [INVALOUT:INVALIN]                    InvPipeV;
logic [INVALOUT:INVALIN][TLBID_WIDTH-1:0]   InvPipeTlbId;
logic [INVALOUT:INVALIN][15:0]              InvPipeSetAddr;
logic [INVALOUT:INVALIN][PS_MAX:PS_MIN]     InvPipeDisRdEn;
T_REQ [INVALOUT:INVALOUT]                   InvPipeReq;
T_REQ_CTRL [INVALOUT:INVALOUT]              InvPipeCtrl;
T_REQ_INFO [INVALOUT:INVALOUT]              InvPipeInfo;


//=====================================================================================================================
// CLOCK GENERATION
//=====================================================================================================================


always_comb pEn_ClkInv_H   = reset
                            | InvPut
                            | (~InvTlbPsIdle)
                            | InvTLBGet;

`HQM_DEVTLB_MAKE_RCB_PH1(ClkInvRcb_H, clk, pEn_ClkInv_H,  PwrDnOvrd_nnnH)
`HQM_DEVTLB_MAKE_LCB_PWR(ClkInv_H, ClkInvRcb_H, pEn_ClkInv_H,  PwrDnOvrd_nnnH)

generate
for (g_stage = INVALIN+1; g_stage <= INVALOUT; g_stage++) begin  : InvPipeState
    always_comb pEn_ClkInvPipe_H[g_stage-1]  = reset | InvPipeV[g_stage-1] | InvPipeV[g_stage];
    `HQM_DEVTLB_MAKE_LCB_PWR(ClkInvPipe_H[g_stage],  clk, pEn_ClkInvPipe_H[g_stage-1],  PwrDnOvrd_nnnH)
end
endgenerate

//-----------------------------------------------------------------------------
always_comb begin
    InvalGlb_i = InvGlb;
    InvalDTLB = ~InvGlb;
end

//------------------------------------------------------------------------------
// INVALIDATION FSM
//drainreq needs inv tail to include TLB_HIT_TO_OUTPUT
//inv_tlb needs inv tail to include last TLB_TAG_WR_CTRL
localparam int INVTLBHOLDLEN = (INVALOUT+TLB_INV_TAIL-TLB_PIPE_START);

logic                               SetAddrMax, TlbIdMax, resetSetAddr, resetTlbId;
logic [TLBID_WIDTH-1:0]             TlbId, NxtTlbId;
logic [15:0]                        SetAddr, NxtSetAddr;  // Of a TlbId
logic [PS_MAX:PS_MIN]               DisRdEn;
logic                               LoadHoldTimer, DecHoldTimer, InvTlbHoldTimeout;
logic [`HQM_DEVTLB_LOG2(INVTLBHOLDLEN):0] HoldTimer, NxtHoldTimer;

always_comb begin : INVAL_FSM
    InvTlbPsIdle = (InvTlbPs == INVTLBIDLE);
    InvTlbPsInc  = (InvTlbPs == INVTLBINC);
    InvTlbNs = InvTlbPs;
    InvEnd         = 1'b0;
    LoadHoldTimer  = 1'b0;
    DecHoldTimer   = 1'b0;

    case (InvTlbPs)
    INVTLBIDLE: begin
        if(InvPut) begin
            InvTlbNs = INVTLBINC;
            LoadHoldTimer = '1;
        end
    end
    INVTLBINC: begin
        if(InvPipeV[INVALIN] && SetAddrMax && TlbIdMax) begin
            InvEnd         = 1'b1;
            InvTlbNs = INVTLBEND;
        end
    end
    INVTLBEND: begin 
        if (InvTlbHoldTimeout) begin
        //need to delay TLBOutInvTail chk until first InvPipeV reach TLB tail, i.e INVALOUT+TLB_HIT_TO_OUTPUT.
        //This is needed for SetAddrMax*TlbIdMax smaller than INVALOUT+TLB_HIT_TO_OUTPUT.
            DecHoldTimer = 1'b0;
            if(~TLBOutInvTail) InvTlbNs = INVTLBIDLE;   // assert iodtlb arb never delay granting to invreq
        end else begin
            DecHoldTimer = 1'b1;
        end
    end
    default: ;
    endcase
end

always_comb begin : FSM_output
    InvTlbHoldTimeout = (HoldTimer=='0);
    NxtHoldTimer = LoadHoldTimer? INVTLBHOLDLEN[`HQM_DEVTLB_LOG2(INVTLBHOLDLEN):0]: 
                   (DecHoldTimer? (HoldTimer-'d1): HoldTimer);

    InvFree = InvTlbPsIdle;
    
    {SetAddrMax, DisRdEn} = getMaxTLBNUMSETS(TlbId, InvESize, SetAddr, (PASID_SUPP_EN && ~InvReq.PasidV));

    NxtSetAddr = InvPipeV[INVALIN]? (SetAddr+1): SetAddr;
    resetSetAddr = (reset | (InvPipeV[INVALIN] && SetAddrMax));

    //waiving lintra "max TlbId is determined by TLB_NUM_ARRAYS"
    // lintra -2056
    // lintra -0393
    TlbIdMax = (TlbId == (TLB_NUM_ARRAYS[TLBID_WIDTH:0] - 1));
    // lintra +2056
    // lintra +0393
    NxtTlbId = (InvPipeV[INVALIN] && SetAddrMax)? (TlbId+1): TlbId; 
    resetTlbId = (reset | (InvPipeV[INVALIN] && SetAddrMax && TlbIdMax));
end

`HQM_DEVTLB_RSTD_MSFF(InvTlbPs, InvTlbNs, ClkInv_H, reset, INVTLBIDLE)
`HQM_DEVTLB_RSTD_MSFF(TlbId, NxtTlbId, ClkInv_H, resetTlbId, '0)
`HQM_DEVTLB_RSTD_MSFF(SetAddr, NxtSetAddr, ClkInv_H, resetSetAddr, '0)
`HQM_DEVTLB_EN_MSFF(HoldTimer,NxtHoldTimer,ClkInv_H,(LoadHoldTimer || DecHoldTimer))

//------------------------------------------------------------------------------
//pipeline to put Inv Req to TLB
always_comb begin
    InvPipeStall = (InvTLBAvail && ~InvTLBGet);
end

//------------------------------------------------------------------------------
// Stage INVALIN

always_comb begin
    InvPipeV[INVALIN]   = InvTlbPsInc && ~InvPipeStall; 
    InvPipeTlbId[INVALIN] = TlbId;
    InvPipeSetAddr[INVALIN] = SetAddr;
    InvPipeDisRdEn[INVALIN] = DisRdEn;
end

//INVALIN++
generate
for (g_stage=INVALIN+1; g_stage<=INVALOUT; g_stage++) begin: gen_InvV
    `HQM_DEVTLB_EN_RST_MSFF(InvPipeV[g_stage],InvPipeV[g_stage-1],ClkInvPipe_H[g_stage],~InvPipeStall,reset)
    `HQM_DEVTLB_EN_MSFF(InvPipeTlbId[g_stage],InvPipeTlbId[g_stage-1],ClkInvPipe_H[g_stage],~InvPipeStall)
    `HQM_DEVTLB_EN_MSFF(InvPipeSetAddr[g_stage],InvPipeSetAddr[g_stage-1],ClkInvPipe_H[g_stage],~InvPipeStall)
    `HQM_DEVTLB_EN_MSFF(InvPipeDisRdEn[g_stage],InvPipeDisRdEn[g_stage-1],ClkInvPipe_H[g_stage],~InvPipeStall)
end
endgenerate

//------------------------------------------------------------------------------
//INVALOUT
always_comb begin
    InvPipeReq[INVALOUT] = '0;
    InvPipeReq[INVALOUT].TlbId = InvPipeTlbId[INVALOUT];
    //InvPipeReq[INVALOUT].Opcode = T_OPCODE'(InvalGlb_i? DEVTLB_OPCODE_GLB_INV: DEVTLB_OPCODE_DTLB_INV);
    InvPipeReq[INVALOUT].Opcode  = T_OPCODE'(InvalGlb_i? 3'd7: 3'd5);
    InvPipeReq[INVALOUT].Address = InvReq.Address;
    InvPipeReq[INVALOUT].BDF     = InvReq.BdfV? InvReq.BDF: '0;
    InvPipeReq[INVALOUT].PASID   = InvReq.PASID;
    InvPipeReq[INVALOUT].PR      = InvReq.PR;
    InvPipeReq[INVALOUT].PasidV  = InvReq.PasidV;
    
    InvPipeInfo[INVALOUT] = '0;
    InvPipeInfo[INVALOUT].am = '0;
    InvPipeInfo[INVALOUT].Size = T_PGSIZE'(`HQM_DEVTLB_PS_4K); //SIZE_4K
    InvPipeInfo[INVALOUT].Global = InvReq.Glob;

    InvPipeCtrl[INVALOUT] = '0;
    InvPipeCtrl[INVALOUT].GL = InvReq.Glob; 
    InvPipeCtrl[INVALOUT].InvalGlb = InvalGlb_i;
    InvPipeCtrl[INVALOUT].InvalDTLB = InvalDTLB;
    InvPipeCtrl[INVALOUT].CtrlFlg.InvAOR = InvReq.InvAOR;
    InvPipeCtrl[INVALOUT].InvalMaskBits = {{(6-ESIZE_IDW){1'b0}},InvESize[ESIZE_IDW-1:0]}; //InvalMaskBits i [5:0]
    InvPipeCtrl[INVALOUT].InvalBdfMask  = ~(InvReq.BdfV && BDF_SUPP_EN);
    //InvPipeCtrl[INVALOUT].InvalPasidMask= ~(InvReq.PasidV && PASID_SUPP_ON);
    InvPipeCtrl[INVALOUT].InvalSetAddr = InvPipeSetAddr[INVALOUT];
    for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : gen_PS_Lp
        InvPipeCtrl[INVALOUT].DisRdEn[tlb_ps] = InvPipeDisRdEn[INVALOUT][tlb_ps];
        if(InvalGlb_i || (TLB_NUM_SETS[InvPipeTlbId[INVALOUT]][tlb_ps][15:0]==0)) InvPipeCtrl[INVALOUT].DisRdEn[tlb_ps] = 1'b1;
    end
end

//module output
always_comb begin
    InvTLBAvail   = InvPipeV[INVALOUT];
    InvTLBReq     = InvPipeReq[INVALOUT];
    InvTLBCtrl    = InvPipeCtrl[INVALOUT];
    InvTLBInfo    = InvPipeInfo[INVALOUT];
end

`ifndef HQM_DEVTLB_SVA_OFF

`HQM_DEVTLB_COVERS_TRIGGER(CP_InvESize_GT4K_LT2M,
   (InvTlbPs==INVTLBEND),
   (InvESize=='d3),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_InvESize_GT2M_LT1G,
   (InvTlbPs==INVTLBEND),
   (InvESize=='d12),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_InvESize_GT1G,
   (InvTlbPs==INVTLBEND),
   (InvESize=='d24),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

        // assert iodtlb arb never delay granting to invreq
        `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_INVTLB_NOGRANT,
               (InvTLBAvail != InvTLBAvail),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB: INV TLB not granted immediately"));

`endif //DEVTLB_SVA_OFF

endmodule

`endif // DEVTLB_INV_TLB_VS

