//=====================================================================================================================
//
// devtlb_inv_drain.sv
//
// Contacts            : Hai Ming Khor
// Original Date       : 12/2019
//
// -- Intel Proprietary
// -- Copyright (C) 2019 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_IODLTB_INV_DRAIN_VS
`define HQM_IODLTB_INV_DRAIN_VS

//`include "devtlb_pkg.vh"

module hqm_devtlb_inv_drain
    import `HQM_DEVTLB_PACKAGE_NAME::*;
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter logic BDF_SUPP_EN = DEVTLB_BDF_SUPP_EN,
    parameter int BDF_WIDTH = DEVTLB_BDF_WIDTH,
    parameter logic PASID_SUPP_EN = DEVTLB_PASID_SUPP_EN,
    parameter int PASID_WIDTH = DEVTLB_PASID_WIDTH,
    parameter type T_INVREQ = logic //t_devtlb_invreq,
)  (
    input  logic                             clk,
    input  logic                             reset,
    input  logic                             reset_INST,
    input  logic                             fscan_clkungate,

    input  logic                             PwrDnOvrd_nnnH,      // Powerdown override

    input  logic                             TLBOutInvTail,
    input  logic                             InvDrainPut,
    input  T_INVREQ                          InvReq,
    output logic                             InvDrainBusy,

    output logic                             drainreq_valid,  // request to drain ALL transaction in Q
    output logic [PASID_WIDTH-1:0]           drainreq_pasid,
    output logic                             drainreq_pasid_priv,
    output logic                             drainreq_pasid_valid,
    output logic                             drainreq_pasid_global,
    output logic [BDF_WIDTH-1:0]             drainreq_bdf,
    output logic                             drainreq_bdf_valid,
    input  logic                             drainreq_ack,    // set when a drainreq is accepted.

    input  logic                             drainrsp_valid,  // set when a drain req is processed, i.e outstanding request are flushed or marked for translation retry. 
    input  logic [7:0]                       drainrsp_tc     // Traffic Class (bitwise) used by the hosting unit for all transaction.
);

//    import `DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the DEVTLB
//====================================================================================================================
//Inval FSM
typedef enum logic [1:0] {
    DRAINIDLE,
    DRAINARM,
    DRAINREQ,
    DRAINRSP
} t_drain_state;

//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

// Signal for Clock generation
logic                                       pEn_ClkDrain_H;
logic                                       ClkDrain_H;
logic                                       ClkDrainRcb_H;

//Drain FSM
t_drain_state                              DrainPs, DrainNs;

//=====================================================================================================================
// CLOCK GENERATION
//=====================================================================================================================
always_comb pEn_ClkDrain_H   = reset
                            | InvDrainPut
                            | drainreq_ack
                            | drainrsp_valid
                            | ~(DrainPs==DRAINIDLE);

`HQM_DEVTLB_MAKE_RCB_PH1(ClkDrainRcb_H, clk, pEn_ClkDrain_H,  PwrDnOvrd_nnnH)
`HQM_DEVTLB_MAKE_LCB_PWR(ClkDrain_H, ClkDrainRcb_H, pEn_ClkDrain_H, PwrDnOvrd_nnnH)

//=====================================================================================================================
//Drain Req & Rsp
logic             nxt_drainreq_valid;

always_comb begin
    DrainNs = DrainPs;
    nxt_drainreq_valid = drainreq_valid;
    
    case (DrainPs)
        DRAINIDLE: begin
            if(InvDrainPut) begin
                DrainNs = DRAINARM;
            end
        end
        DRAINARM: begin
            if(TLBOutInvTail) begin
                DrainNs = DRAINREQ;
                nxt_drainreq_valid = 1'b1;
            end
        end
        DRAINREQ: begin
            if(drainreq_ack) begin
                nxt_drainreq_valid = 1'b0;
                DrainNs = DRAINRSP;
                if (drainrsp_valid) begin
                    DrainNs = DRAINIDLE;
                end
            end
        end
        DRAINRSP: begin
            if(drainrsp_valid) begin
                DrainNs = DRAINIDLE;
            end
        end
        default: ;
    endcase
end

logic [7:0] nc_drainrsp_tc;
always_comb begin : DrainFSM_Out
    InvDrainBusy = ~(DrainPs==DRAINIDLE);
    nc_drainrsp_tc = drainrsp_tc;
end
`HQM_DEVTLB_RSTD_MSFF(DrainPs,DrainNs,ClkDrain_H,reset,DRAINIDLE)
`HQM_DEVTLB_RSTD_MSFF(drainreq_valid,nxt_drainreq_valid,ClkDrain_H,reset,1'b0)
`HQM_DEVTLB_EN_MSFF(drainreq_pasid_priv,InvReq.PR,ClkDrain_H,InvDrainPut)
`HQM_DEVTLB_EN_MSFF(drainreq_pasid,InvReq.PASID,ClkDrain_H,InvDrainPut)
`HQM_DEVTLB_EN_MSFF(drainreq_pasid_global,InvReq.Glob,ClkDrain_H,InvDrainPut)
`HQM_DEVTLB_EN_RST_MSFF(drainreq_pasid_valid,InvReq.PasidV,ClkDrain_H,InvDrainPut,reset)
`HQM_DEVTLB_EN_MSFF(drainreq_bdf,(InvReq.BdfV? InvReq.BDF: '0),ClkDrain_H,InvDrainPut)
`HQM_DEVTLB_EN_RST_MSFF(drainreq_bdf_valid,InvReq.BdfV,ClkDrain_H,InvDrainPut,reset)

endmodule

`endif // DEVTLB_INV_DRAIN_VS

