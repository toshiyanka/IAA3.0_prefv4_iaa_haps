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

`ifndef HQM_DEVTLB_FIFO_VS
`define HQM_DEVTLB_FIFO_VS

module hqm_devtlb_fifo
#(
    parameter logic NO_POWER_GATING = 1'b0,
    parameter type T_REQ     = logic,
    parameter  int ENTRIES   = 8,
    localparam int FIFO_IDW     = (ENTRIES<2)? 1: $clog2(ENTRIES)
) (
    input  logic                clk,

    input  logic                rst_b,
    input  logic                reset_INST,

    input  logic                fscan_latchopen,
    input  logic                fscan_latchclosed_b,

    output logic                full,
    input  logic                push,
    output logic [FIFO_IDW-1:0] wraddr,
    input  T_REQ                din,

    output logic                avail,
    input  logic                pop,
    output logic [FIFO_IDW-1:0] rdaddr0,
    output T_REQ                dout,
    output T_REQ [ENTRIES-1:0]  array
);

localparam int  FIFO_W       = $bits(T_REQ);

logic [FIFO_IDW:0]                       wraddr_i, rdaddr0_i, nxt_wraddr_i, nxt_rdaddr0_i;

always_comb begin
    wraddr = wraddr_i[FIFO_IDW-1:0];
    rdaddr0 = rdaddr0_i[FIFO_IDW-1:0];
    nxt_wraddr_i = push? wraddr_i + 'd1: wraddr_i;
    nxt_rdaddr0_i = pop? rdaddr0_i + 'd1: rdaddr0_i;
end

always_ff @(posedge clk) begin
    if (!rst_b) begin
        wraddr_i       <= '0;
        rdaddr0_i      <= '0;
        full         <= '0;
        avail        <= '0;
    end
    else begin
        if (push) wraddr_i       <= nxt_wraddr_i;
        if (pop)  rdaddr0_i      <= nxt_rdaddr0_i;
        if (push || pop) full    <= (nxt_rdaddr0_i[FIFO_IDW]!=nxt_wraddr_i[FIFO_IDW]) && (nxt_rdaddr0_i[FIFO_IDW-1:0]==nxt_wraddr_i[FIFO_IDW-1:0]);
        if (push || pop) avail   <= ~(nxt_rdaddr0_i[FIFO_IDW:0]==nxt_wraddr_i[FIFO_IDW:0]);
    end
end


T_REQ                            wrdata_ff;
logic [ENTRIES-1:0]              en;
logic [ENTRIES-1:0]              enclk;


always_ff @(posedge clk) if (push) wrdata_ff <= din;

always_comb for (int i=0; i<ENTRIES; i++) en[i] = push & (i[FIFO_IDW-1:0] == wraddr_i[FIFO_IDW-1:0]);

hqm_devtlb_ctech_clk_gate_te_rstb latch_gate [ENTRIES-1:0] (
    .en     (en),
    .te     (fscan_latchopen),
    .rstb   (fscan_latchclosed_b),
    .clk    (clk),
    .clkout (enclk)
);

always_latch for (int i=0; i<ENTRIES; i++) if (enclk[i]) array[i] <= wrdata_ff;

always_comb begin
    dout  = '0;
    for (int i=0; i<ENTRIES; i++) if (i[FIFO_IDW-1:0] == rdaddr0_i[FIFO_IDW-1:0]) dout |= array[i];
end

AS_FULLPUSH:
assert property ( @(posedge clk) disable iff(rst_b !== 1'b1) (push |-> ~full))
    `HQM_DEVTLB_ERR_MSG("%t %m failed", $time);

AS_AVAILPOP:
assert property ( @(posedge clk) disable iff(rst_b !== 1'b1) (pop |-> avail))
    `HQM_DEVTLB_ERR_MSG("%t %m failed", $time);

AS_wraddr_i_VALID:
assert property ( @(posedge clk) disable iff(rst_b !== 1'b1) ( push |-> (wraddr_i[FIFO_IDW-1:0] < ENTRIES) ) ) // lintra s-0393
    `HQM_DEVTLB_ERR_MSG("%t %m failed", $time);

AS_rdaddr0_i_VALID:
assert property ( @(rdaddr0_i) disable iff(rst_b !== 1'b1) ( rdaddr0_i[FIFO_IDW-1:0] < ENTRIES ) ) // lintra s-0393
    `HQM_DEVTLB_ERR_MSG("%t %m failed", $time);

endmodule

`endif //DEVTLB_FIFO_VS

