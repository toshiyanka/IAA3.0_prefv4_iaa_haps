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

`ifndef HQM_DEVTLB_RRARBDGPR_VS
`define HQM_DEVTLB_RRARBDGPR_VS

module hqm_devtlb_rrarbdgpr
#(
  parameter int   REQ_W           = 4,
  parameter int   REQ_IDW         = (REQ_W==1)? 1: $clog2(REQ_W),
  parameter int   GCNT_IDW        = 2,
  parameter logic [REQ_W-1:0] GCNT_DIS = '0 
) (
    input  logic                clk,
    input  logic                rst_b,
    input  logic                reset_INST,
    input  logic [REQ_W-1:0][GCNT_IDW:0]   cr_gcnt, // grant count, one based

    input  logic [REQ_W-1:0]    arb_rs, //resource
    input  logic [REQ_W-1:0]    arb_rawreq,
    input  logic [REQ_W-1:0]    arb_req,
    output logic [REQ_W-1:0]    arb_gnt
);

`define HQM_DEVTTLBRRARBDGPR(Func_name, REQWIDTH)                                           \
function automatic logic [REQWIDTH+REQWIDTH+REQWIDTH+REQWIDTH-1:0] Func_name (          \
                            input logic [REQWIDTH-1:0] gcavail,                         \
                            input logic [REQWIDTH-1:0] gceqone,                         \
                            input logic [REQWIDTH-1:0] hpflg,                           \
                            input logic [REQWIDTH-1:0] mask,                            \
                            input logic [REQWIDTH-1:0] rs,                              \
                            input logic [REQWIDTH-1:0] rawreq,                          \
                            input logic [REQWIDTH-1:0] req);                            \
    logic [REQWIDTH-1:0]            greq, hpArb, mhpArb, lpArb, mlpArb;                 \
    logic [REQWIDTH-1:0]            qhpArb, qmhpArb, qlpArb, qmlpArb;                   \
    logic [REQWIDTH-1:0]            gnt, nxt_mask, nxt_hpflg, gcreload;                 \
    logic [$clog2(REQWIDTH)-1:0]    winner, runner, third, forth, actWinner;            \
                                                                                        \
    greq   = req & gcavail;                                                             \
    hpArb  = greq & ~mask & hpflg;                                                      \
    mhpArb = greq &  mask & hpflg;                                                      \
    lpArb  = greq & ~mask;                                                              \
    mlpArb = greq &  mask;                                                              \
    qhpArb  = hpArb  & rs;                                                              \
    qmhpArb = mhpArb & rs;                                                              \
    qlpArb  = lpArb  & rs;                                                              \
    qmlpArb = mlpArb & rs;                                                              \
    winner = '0;                                                                        \
    runner = '0;                                                                        \
    third  = '0;                                                                        \
    forth  = '0;                                                                        \
    gnt    = '0;                                                                        \
                                                                                        \
    for (int i=(REQWIDTH-1); i>=0; i--) begin                                           \
        if (qhpArb[i])                                                                  \
          winner=i[$clog2(REQWIDTH)-1:0];                                               \
        if (qmhpArb[i])                                                                 \
          runner=i[$clog2(REQWIDTH)-1:0];                                               \
        if (qlpArb[i])                                                                  \
          third=i[$clog2(REQWIDTH)-1:0];                                                \
        if (qmlpArb[i])                                                                 \
           forth=i[$clog2(REQWIDTH)-1:0];                                               \
    end                                                                                 \
                                                                                        \
    actWinner = |qhpArb? winner:(|qmhpArb? runner:(|qlpArb? third: forth));             \
    for (int i=0; i<REQWIDTH; i++) begin                                                \
        gnt[i] = (actWinner==i[$clog2(REQWIDTH)-1:0]) && (greq[i] & rs[i]);             \
    end                                                                                 \
    nxt_mask = (|gnt)? (~({{(REQWIDTH-1){1'b1}},1'b0} << actWinner)): mask;             \
    for (int i=(REQWIDTH-1); i>=0; i--) begin                                           \
        nxt_hpflg[i] = (hpflg[i] && (~(gnt[i] && gceqone[i]))) ||                       \
                       (~|{rawreq & gcavail & hpflg});                                  \
        gcreload[i] = ((gnt[i] && gceqone[i] && hpflg[i]) ||                            \
                       (~|{rawreq & gcavail & rs} && rs[i] && ~hpflg[i])) ||            \
                      ~|{rawreq & gcavail & hpflg};                                     \
    end                                                                                 \
    Func_name = {gcreload, nxt_hpflg, nxt_mask, gnt};                                   \
                                                                                        \
endfunction // automatic
/*documentatoin
        nxt_hpflg[i] = (hpflg[i] && (~(gnt[i] && gceqone[i]))) ||  //while in hp, move to lp when last gc used.
                       (~|{rawreq & gcavail & hpflg});             // reset all hpflg when none in hp, including this req[i]
        gcreload[i] = ((gnt[i] && gceqone[i] && hpflg[i]) ||   //after all gcnt consumed while in hp, reset gcnt then goes to lp
                       (~|{rawreq & gcavail & rs} && rs[i] && ~hpflg[i])) || //while in lp, wait til all req (regardless of pool) used out gc, or no rs, or no req.
                       //                                       //this req need to have rs in order to reload gc
                      ~|{rawreq & gcavail & hpflg};              //reload when all hpflg reset
*/
`HQM_DEVTTLBRRARBDGPR(RRArbd, REQ_W)


logic [REQ_W-1:0]            nxt_hpflg, hpflg, nxt_mask, mask;
logic [REQ_W-1:0]            gcreload, gceqone, gcavail;
logic [REQ_W-1:0][GCNT_IDW:0] gcnt, nxtgcnt;

always_comb begin
    for (int i=0; i<REQ_W; i++) gceqone[i] = (gcnt[i] == 'd1);

    {gcreload, nxt_hpflg, nxt_mask, arb_gnt} = RRArbd(gcavail, gceqone, hpflg, mask, arb_rs, arb_rawreq, arb_req);

    for (int i=0; i<REQ_W; i++) begin 
        nxtgcnt[i] = gcreload[i]? cr_gcnt[i]:
                     (arb_gnt[i]? (gcnt[i]-'d1):
                      gcnt[i]);
    end
end

always_ff @(posedge clk) begin
    if(~rst_b) begin
        mask  <= '0;
        hpflg <= '1;
        for (int i=0; i<REQ_W; i++) begin
            gcnt[i]  <= cr_gcnt[i];
            gcavail[i] <= ~(gcnt[i]=='0);
        end
    end else begin
        mask <= nxt_mask;
        hpflg <= nxt_hpflg;
        for (int i=0; i<REQ_W; i++) begin
            gcnt[i]    <= nxtgcnt[i];
            gcavail[i] <= GCNT_DIS[i]? '1: ~(nxtgcnt[i]=='0);
        end
    end
end

`ifndef HQM_DEVTLB_SVA_OFF

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_TlbArb_GntIfRs,
    |(arb_req & arb_rs & gcavail),
    |(arb_gnt),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`endif //DEVTLB_SVA_OFF

endmodule

`endif //DEVTLB_RRARBDGPR_VS

