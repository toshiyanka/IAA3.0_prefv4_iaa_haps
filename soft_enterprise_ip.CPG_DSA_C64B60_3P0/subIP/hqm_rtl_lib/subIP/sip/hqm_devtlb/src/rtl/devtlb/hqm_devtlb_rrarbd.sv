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

`ifndef HQM_DEVTLB_RRARBD_VS
`define HQM_DEVTLB_RRARBD_VS

module hqm_devtlb_rrarbd
#(
  parameter int   REQ_W           = 4,
  parameter int   REQ_IDW         = (REQ_W==1)? 1: $clog2(REQ_W)
) (
    input  logic                clk,
    input  logic                rst_b,

    input  logic                arb_rs, //resource
    input  logic [REQ_W-1:0]    arb_req,
    output logic [REQ_W-1:0]    arb_gnt
);

`define HQM_RNDRBNARBD(Func_name, REQ_W)                                                     \
function automatic logic [REQ_W+REQ_W-1:0] Func_name (                              \
                            input logic             rs,                                 \
                            input logic [REQ_W-1:0] mask,                               \
                            input logic [REQ_W-1:0] req);                               \
    logic [REQ_W-1:0]            gnt;                                                   \
    logic [REQ_W-1:0]            hpArb, lpArb, nxt_mask;                                \
    logic [REQ_IDW-1:0]          winner, runner, actWinner;                             \
                                                                                        \
    hpArb = req & ~mask;                                                                \
    lpArb = req & mask;                                                                 \
    winner = '0;                                                                        \
    runner = '0;                                                                        \
    gnt = '0;                                                                           \
                                                                                        \
    for (int i=(REQ_W-1); i>=0; i--) begin                                              \
        if (hpArb[i])                                                                   \
            winner=i;                                                                   \
        if (lpArb[i])                                                                   \
            runner=i;                                                                   \
        end                                                                             \
                                                                                        \
    actWinner = |hpArb?winner:runner;                                                   \
    nxt_mask = ~({{(REQ_W-1){1'b1}},1'b0} << actWinner);                                \
    for (int i=0; i<REQ_W; i++) begin                                                   \
        gnt[i] = (actWinner==i[REQ_IDW-1:0]) && rs && |req;                             \
    end                                                                                 \
                                                                                        \
    Func_name = {nxt_mask,gnt};                                                         \
                                                                                        \
endfunction // automatic

`HQM_RNDRBNARBD(RRArbd,REQ_W)

logic [REQ_W-1:0]            nxt_mask, mask;

always_comb begin
    nxt_mask = mask;
    {nxt_mask, arb_gnt} = RRArbd(arb_rs, mask, arb_req);
end

always_ff @(posedge clk) begin
    if(~rst_b)   mask <= '0;
    else if(|arb_gnt) mask <= nxt_mask;
end


endmodule

`endif //DEVTLB_RRARBD_VS

