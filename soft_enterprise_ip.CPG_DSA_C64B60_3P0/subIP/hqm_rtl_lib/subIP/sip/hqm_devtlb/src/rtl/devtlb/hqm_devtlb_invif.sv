// =============================================================================
// INTEL CONFIDENTIAL
// Copyright 2019 - 2019 Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to the source code ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material remains with Intel Corporation or its suppliers and licensors. The Material contains trade secrets and proprietary and confidential information of Intel or its suppliers and licensors. The Material is protected by worldwide copyright and trade secret laws and treaty provisions. No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted, transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
// No license under any patent, copyright, trade secret or other intellectual property right is granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by implication, inducement, estoppel or otherwise. Any license under such intellectual property rights must be express and approved by Intel in writing.
// =============================================================================

//--------------------------------------------------------------------
//
//  Author   : 
//  Project  : DevTLB 2.0
//  Comments : 
//
//  Functional description: DevTLB Invalidation Interface
//    PCIe spec DevTLB Invalidation 
//
//--------------------------------------------------------------------

`ifndef HQM_DEVTLB_INVIF_SV
`define HQM_DEVTLB_INVIF_SV

`include "hqm_devtlb_pkg.vh"

module hqm_devtlb_invif
    import `HQM_DEVTLB_PACKAGE_NAME::*;
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter type T_INVREQ = logic, //t_devtlb_invreq,
    parameter logic BDF_SUPP_EN = DEVTLB_BDF_SUPP_EN,
    parameter logic PF_INV_VF = 1'b0,
    parameter int BDF_WIDTH = DEVTLB_BDF_WIDTH,
    parameter logic PASID_SUPP_EN = DEVTLB_PASID_SUPP_EN,
    parameter int PASID_WIDTH = DEVTLB_PASID_WIDTH,
    parameter int REQ_PAYLOAD_MSB = 63,
    parameter int REQ_PAYLOAD_LSB = 12,
    parameter int DEVTLB_INVQ_DEPTH = 32,
    localparam int DEVTLB_INVQ_IDW = $clog2(DEVTLB_INVQ_DEPTH)
) (// Clock / Reset
    input  logic                            clk,
    input  logic                            reset,
    input  logic                            reset_INST,
    input  logic                            fscan_clkungate,
    input  logic                            flr_fw,
    output logic                            invreqs_active,

   // CSR interface
   input    logic                           PwrDnOvrd_nnnH,
   
    // IPI interface
    // Request MSGD
   input  logic                             invreq_valid,
   input  logic                             invreq_dperror,
   input  logic [15:0]                      invreq_reqid,
   input  logic [BDF_WIDTH-1:0]             invreq_bdf,
   input  logic [PASID_WIDTH-1:0]           invreq_pasid,
   input  logic                             invreq_pasid_priv,
   input  logic                             invreq_pasid_valid,
   input  logic [4:0]                       invreq_itag,
   input  logic [63:0]                      invreq_data,

    //Inteface with devtlb_inv
    output logic                            InvIfReqAvail,
    output logic                            InvIfReqPut,
    output T_INVREQ                         InvIfReq,
    input  logic                            InvIfReqFree,
   // output logic [DEVTLB_INVQ_IDW:0]      inv_req_cnt,   //1 based
    
    input  logic                            InvIfCmpAvail,
    input  logic [7:0]                      InvIfCmpTC,
    input  logic [4:0]                      InvIfCmpITag,
    input  logic [BDF_WIDTH-1:0]            InvIfCmpBDF,
    output logic                            InvIfCmpGet,

    // Completion MSG
    output logic                            invrsp_valid, 
    input  logic                            invrsp_ack,
    output logic [15:0]                     invrsp_did,
    output logic [31:0]                     invrsp_itag,
    output logic [BDF_WIDTH-1:0]            invrsp_bdf,
    output logic [2:0]                      invrsp_cc,
    output logic [2:0]                      invrsp_tc,

    // ATC Invalidation Queue: 32 Entries X 84 Bits
    output logic                            InvQWrEn,    // 
    output logic [DEVTLB_INVQ_IDW-1:0]      InvQWrAddr,  //  [4:0]
    output T_INVREQ                         InvQWrData,  // [79:0]
    output logic                            InvQRdEn,    // 
    output logic [DEVTLB_INVQ_IDW-1:0]      InvQRdAddr,  //  [4:0]
    input  T_INVREQ                         InvQRdData  // [79:0]
 );

    // support:
    //  atscap.gis = 1 (global inv support)
    //  atscap.iqd=0 (inv queuue depth=32)
    //  pasidcap.maxwid='d20
    //cr_atccfg.pasid_en, ats_en, ats_stu[4:0]
    //if ats en=0 or (pasiden=0 & pasidtlp exist) or dev is disabled --> just send completion msg immediately, on tc0 only
typedef struct packed {
    logic [63:REQ_PAYLOAD_LSB]       Address; //[63:12]
    logic                            Size; //[11]
    logic [10:1]                     Reserved; //[10:1]
    logic                            Glob;//[0]
} t_devtlb_invreq_data;

localparam int ADDRESS_W  = REQ_PAYLOAD_MSB+1;
localparam int PGOFFSET_W = REQ_PAYLOAD_LSB;

//if va[MSB:11] all 1
//  if va[63:MSB+1] has contiguos 1 in lower part, and contiguos 0 at upper part, pass //let inv handle
//else
//   pass if va[63:MSB+1]==0 or MSB=63
function automatic logic invreq_addrchk  ( //1-pass                            
                                input logic size,
                                input logic [63:REQ_PAYLOAD_LSB] va);
    logic uaddrchk, set, zero_uaddr;
    uaddrchk = '1;
    for (int j=62; j>=(REQ_PAYLOAD_MSB+1); j--) begin //spyglass disable 0209  //lintra s-0209
        set = '0;
        for (int i=63; i>j; i--) begin
            set |= va[i]; 
        end
        if (va[j]==1'b0) uaddrchk = ~set; 
    end
    
    zero_uaddr = '0;
    for (int i=63; i>=(REQ_PAYLOAD_MSB+1); i--) zero_uaddr |= va[i];  //spyglass disable 0209   //lintra s-0209
    zero_uaddr = ~zero_uaddr;

    invreq_addrchk = (&{va[REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB], size})? uaddrchk: zero_uaddr;

endfunction

//=====================================================================================================================
//global signals
// Invalidation IDLE
logic                       inv_cmp_avail_fw, invq_avail;
logic                       invif_free, nxt_invif_free;

//=====================================================================================================================
// CLOCK GENERATION
//=====================================================================================================================
   logic pEn_ClkInvif_H;
   logic ClkInvif_H;
   logic ClkInvifRcb_H;

   always_comb pEn_ClkInvif_H   = reset | flr_fw
                                | invreq_valid | inv_cmp_avail_fw | invrsp_ack
                                | invq_avail | invrsp_valid | ~invif_free;

   `HQM_DEVTLB_MAKE_RCB_PH1(ClkInvifRcb_H, clk, pEn_ClkInvif_H,  PwrDnOvrd_nnnH)
   `HQM_DEVTLB_MAKE_LCB_PWR(ClkInvif_H, ClkInvifRcb_H, pEn_ClkInvif_H,  PwrDnOvrd_nnnH)

//============================================================================
// Receiving Inv Request
// decode IPI MsgD,  write to RF if legitimate

T_INVREQ     invq_in; //invq_out;
logic               invq_push;
//logic               ipi_pasid_en_r;
//logic [PASID_W-1:0] ipi_pasid_r;
//logic [4:0]         ipi_tag_r;
//logic [15:0]        invreq_rqid;

always_comb begin
    invq_push       = invreq_valid;
    invq_in         = '0;
    invq_in.PasidV  = PASID_SUPP_EN? invreq_pasid_valid: '0;
    invq_in.PR      = PASID_SUPP_EN? invreq_pasid_priv: '0;
    invq_in.PASID   = PASID_SUPP_EN? invreq_pasid: '0;
    invq_in.Glob    = PASID_SUPP_EN? invreq_data[0]: '0;
    invq_in.BdfV    = BDF_SUPP_EN;
    invq_in.BDF     = invq_in.BdfV? invreq_bdf: '0;
    invq_in.ITag    = invreq_itag;
    invq_in.Address = invreq_data[REQ_PAYLOAD_MSB:REQ_PAYLOAD_LSB];
    invq_in.Size    = invreq_data[11];
    invq_in.IODPErr = invreq_dperror;
    invq_in.InvAOR  = (~invreq_dperror) && ~invreq_addrchk(invreq_data[11], invreq_data[63:REQ_PAYLOAD_LSB]);
end
`HQM_DEVTLB_EN_MSFF(invrsp_did, invreq_reqid, ClkInvif_H, invreq_valid);

//=============================================================================================
// invalidation Request Q
logic                  invq_pop, invq_pop1;
logic [DEVTLB_INVQ_IDW:0] invq_wraddr, invq_rdaddr, nxt_invq_wraddr, nxt_invq_rdaddr;
logic [DEVTLB_INVQ_IDW:0] invq_rdaddr1, nxt_invq_rdaddr1;
logic                  InvIfReqFree_fw;

always_comb begin
    InvIfReqFree_fw = InvIfReqFree && ~flr_fw; //when flr_fw, indicates inv is not available
    InvIfReqPut   = invq_avail && InvIfReqFree_fw; 
    InvIfReqAvail = invq_avail;
    invq_pop        = InvIfReqPut; 
    invq_pop1       = InvIfCmpGet;
    nxt_invq_wraddr = invq_push? (invq_wraddr + 'd1): invq_wraddr;
    nxt_invq_rdaddr = flr_fw? invq_rdaddr1: (invq_pop? (invq_rdaddr + 'd1): invq_rdaddr); //assert onehoe(flr & pop1)
    nxt_invq_rdaddr1= invq_pop1? (invq_rdaddr1 + 'd1): invq_rdaddr1;
    //inv_req_cnt     = nxt_invq_count;
end

`HQM_DEVTLB_RSTD_MSFF(invq_wraddr, nxt_invq_wraddr, ClkInvif_H, reset, '0);
`HQM_DEVTLB_RSTD_MSFF(invq_rdaddr, nxt_invq_rdaddr, ClkInvif_H, reset, '0);
`HQM_DEVTLB_RSTD_MSFF(invq_rdaddr1, nxt_invq_rdaddr1, ClkInvif_H, reset, '0);
`HQM_DEVTLB_RSTD_MSFF(invq_avail, (~(nxt_invq_wraddr==nxt_invq_rdaddr)), ClkInvif_H, reset, '0);

// Memory interface
always_comb begin
    InvQWrEn      = invq_push;
    InvQWrAddr    = invq_wraddr[DEVTLB_INVQ_IDW-1:0];
    InvQWrData    = invq_in;

    InvQRdEn      = invq_pop;
    InvQRdAddr    = invq_rdaddr[DEVTLB_INVQ_IDW-1:0];
    InvIfReq      = InvQRdData;
end 

//============================================================================
// Sending Inv Completion
function automatic logic [3:0] count_tc  (                            
                                input logic [7:0] inv_tc);
    logic [3:0] one_cnt;
    one_cnt   = '0;
    for (int i=0; i<8; i++) one_cnt  =  one_cnt + {3'b0, inv_tc[i]};
    count_tc = one_cnt;
endfunction

function automatic logic [2:0] get_tc_lid  (                            
                                input logic [7:0] inv_tc);
    get_tc_lid  = '0;
    for (int i=7; i>=0; i--) if (inv_tc[i]) get_tc_lid  =  i[2:0];
endfunction

logic                       load_inv_tc;
logic [7:0]                 nxt_inv_tc, new_inv_tc, clr_inv_tc, inv_tc;
logic [2:0]                 nxt_tc_id, tc_id;
logic [3:0]                 invcpl_cc;
logic [DEVTLB_INVQ_DEPTH-1:0] invcpl_itag, nxt_invcpl_itag;
logic [BDF_WIDTH-1:0]       invcpl_bdf;

always_comb begin
    inv_cmp_avail_fw = InvIfCmpAvail && !flr_fw;
    
    InvIfCmpGet         = invif_free && inv_cmp_avail_fw;

    load_inv_tc         = InvIfCmpGet;
    clr_inv_tc          = '0;
    clr_inv_tc[tc_id]   = invrsp_ack;

    //new_inv_tc[0]   = InvIfCmpTC[0] || 1'b1;         //always enable the Inv Completion to tc0.
    for (int i=0; i<8; i++) begin
        new_inv_tc[i]   = InvIfCmpTC[i];
    end
    new_inv_tc[0]   |= ~|InvIfCmpTC;
    //assert (load_inv_tc && ~|new_inv_tc)
    
    for (int i=0; i<8; i++) nxt_inv_tc[i]   = load_inv_tc? new_inv_tc[i]: (clr_inv_tc[i]? '0: inv_tc[i]);
    nxt_tc_id   = get_tc_lid(nxt_inv_tc);
    
    nxt_invif_free = (((~|inv_tc) || invif_free) && ~InvIfCmpGet);
end

always_comb begin
        for (int i=0; i<DEVTLB_INVQ_DEPTH; i++) nxt_invcpl_itag[i] = (i[DEVTLB_INVQ_IDW-1:0]==(InvIfCmpITag & {(DEVTLB_INVQ_IDW){~flr_fw}}));
end

`HQM_DEVTLB_RSTD_MSFF(invrsp_valid, (|nxt_inv_tc), ClkInvif_H, reset, '0);
`HQM_DEVTLB_RSTD_MSFF(invif_free, nxt_invif_free, ClkInvif_H, reset, '1);
`HQM_DEVTLB_RSTD_MSFF(inv_tc, nxt_inv_tc, ClkInvif_H, reset, '0);
`HQM_DEVTLB_RSTD_MSFF(tc_id, nxt_tc_id, ClkInvif_H, reset, '0);
`HQM_DEVTLB_EN_RSTD_MSFF(invcpl_itag, nxt_invcpl_itag, ClkInvif_H, load_inv_tc, reset, '0);
`HQM_DEVTLB_EN_MSFF(invcpl_bdf, InvIfCmpBDF, ClkInvif_H, load_inv_tc);
`HQM_DEVTLB_EN_RSTD_MSFF(invcpl_cc, count_tc(new_inv_tc), ClkInvif_H, load_inv_tc, reset, '0);
`HQM_DEVTLB_RSTD_MSFF(invreqs_active, (~(nxt_invq_wraddr==nxt_invq_rdaddr1)) || ~nxt_invif_free, ClkInvif_H, reset, '0);

always_comb begin
    invrsp_itag   = invcpl_itag;
    invrsp_cc     = invcpl_cc[2:0];
    invrsp_tc     = tc_id;
    invrsp_bdf    = invcpl_bdf;

    //td=0(no pcie link, so no ecrc),rqid=0,ido=0(not id base order),ep=0(not supported),cparity=0(assume ipi generate it)
    //inv_ipi_po_cmd.opcode                       = Msg2; //MSG route by ID.
    //{inv_ipi_po_cmd.lbe, inv_ipi_po_cmd.fbe}    = 8'b0000_0010;
    //inv_ipi_po_cmd.address[31:16]               = invreq_rqid; // TA id, assuming there is only one TA
    //inv_ipi_po_cmd.address[2:0]                 = invcpl_cc[2:0];
    //inv_ipi_po_cmd.address[63:32]               = invcpl_itag;
    //inv_ipi_po_cmd.tc                           = {1'b0, tc_id};
    //inv_ipi_po_cmd.sai                        = strap_mem_sai;    // ipi to handle
    
end

`ifndef HQM_DEVTLB_SVA_OFF
logic [DEVTLB_INVQ_IDW:0]   invq_count, nxt_invq_count;
logic [DEVTLB_INVQ_IDW:0]   invq_count1, nxt_invq_count1;
always_comb begin
    if      ( invq_push & ~invq_pop1) nxt_invq_count1 = invq_count1 + 'd1;
    else if (~invq_push &  invq_pop1) nxt_invq_count1 = invq_count1 - 'd1;
    else    nxt_invq_count1 = invq_count1;

    if      ( flr_fw ) nxt_invq_count = invq_count1 + invq_push;
    else if ( invq_push & ~invq_pop) nxt_invq_count = invq_count + 'd1;
    else if (~invq_push &  invq_pop) nxt_invq_count = invq_count - 'd1;
    else    nxt_invq_count = invq_count;
end
`HQM_DEVTLB_RSTD_MSFF(invq_count, nxt_invq_count, ClkInvif_H, reset, '0);
`HQM_DEVTLB_RSTD_MSFF(invq_count1, nxt_invq_count1, ClkInvif_H, reset, '0);

//EVENTS
`HQM_DEVTLB_COVERS_TRIGGER(CP_MULTIINVCP,
   invrsp_valid,
   ($countones(new_inv_tc)>0),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t %m HIT: %b", $time, new_inv_tc));

`HQM_DEVTLB_COVERS_TRIGGER(CP_INVCNTGT1,
   invq_pop,
   (invq_count>'d1),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_INVCMPHOLD,
   inv_cmp_avail_fw,
   (~invif_free),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

//FLR while no invalidation is outstanding
`HQM_DEVTLB_COVERS_TRIGGER(CP_FLRINVQ0,
   $rose(flr_fw),
   (~invq_avail),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));
//FLR while at least one invalidation is outstanding
`HQM_DEVTLB_COVERS_TRIGGER(CP_FLRINVQEQ1,
   $rose(flr_fw),
   (invq_count==1),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_FLRINVQGT1,
   $rose(flr_fw),
   (invq_count>1),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));
//Request Invalidation while FLR is ongoing
`HQM_DEVTLB_COVERS_TRIGGER(CP_FLRINVQPUSH,
   $rose(invq_push),
   (flr_fw),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));
//CP_FLRINVCMP: cover property (@(posedge clk) ($rose(InvIfCmpAvail) |-> flr_fw)) $info("%0t %m HIT", $time);
`HQM_DEVTLB_COVERS_TRIGGER(CP_FLRIPI0,
   $rose(flr_fw),
   (|inv_tc),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_FLRIPI1,
   $fell(flr_fw),
   (|inv_tc),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));
//INVreq that arrive during FLR and 1 outstanding in invq
`HQM_DEVTLB_COVERS_TRIGGER(CP_FLR_HSD22010550035,
   $rose(flr_fw),
   ((invq_wraddr==invq_rdaddr) && ~(invq_wraddr==invq_rdaddr1)),
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_InvReq_Size_Around4KB,
   invq_push,
   (invq_in.Size=='0) || //4KB
   (invq_in.Size && ({invq_in.Address[DEVTLB_REQ_PAYLOAD_LSB+:1]}==1'b0)), //8kB
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_InvReq_Size_Around2MB,
   invq_push,
   (invq_in.Size && ({invq_in.Address[DEVTLB_REQ_PAYLOAD_LSB+:8]}=={1'b0, {(8-1){1'b1}}})) || //1MB
   (invq_in.Size && ({invq_in.Address[DEVTLB_REQ_PAYLOAD_LSB+:9]}=={1'b0, {(9-1){1'b1}}})) || //2MB
   (invq_in.Size && ({invq_in.Address[DEVTLB_REQ_PAYLOAD_LSB+:10]}=={1'b0, {(10-1){1'b1}}})), //4MB
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER(CP_InvReq_Size_Around1GB,
   invq_push,
   (invq_in.Size && ({invq_in.Address[DEVTLB_REQ_PAYLOAD_LSB+:17]}=={1'b0, {(17-1){1'b1}}})) || //512MB
   (invq_in.Size && ({invq_in.Address[DEVTLB_REQ_PAYLOAD_LSB+:18]}=={1'b0, {(18-1){1'b1}}})) || //1GB
   (invq_in.Size && ({invq_in.Address[DEVTLB_REQ_PAYLOAD_LSB+:19]}=={1'b0, {(19-1){1'b1}}})),   //2GB
   posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%t %m HIT", $time));

//ASSERTIONS
`HQM_DEVTLB_ASSERTS_TRIGGER(AS_INVQOVERFLW1,
   invq_push,
   (invq_count1!=='1),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_INVQOVERFLW,
   invq_push,
   (invq_count!=='1),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_INVQUNDERFLW,
   invq_pop,
   (invq_count!=='0),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_ONECP,
   invrsp_valid,
   ($onehot(invcpl_itag)),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_FLRINVQRD,
   flr_fw, 1,
   (!(invq_pop || invq_pop1)),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_FLRPOP1_ONEHOT,
   flr_fw,
   ($onehot({flr_fw, invq_pop1})),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

final begin : ASF_INVIFIDLE
    assert (invq_count=='0) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: INVQ is not empty.");
    assert (inv_tc=='0) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: INV_TC is not empty.");
end

`endif //DEVTLB_SVA_OFF

endmodule // devtlb_invif
`endif // DEVTLB_INVIF_SV
