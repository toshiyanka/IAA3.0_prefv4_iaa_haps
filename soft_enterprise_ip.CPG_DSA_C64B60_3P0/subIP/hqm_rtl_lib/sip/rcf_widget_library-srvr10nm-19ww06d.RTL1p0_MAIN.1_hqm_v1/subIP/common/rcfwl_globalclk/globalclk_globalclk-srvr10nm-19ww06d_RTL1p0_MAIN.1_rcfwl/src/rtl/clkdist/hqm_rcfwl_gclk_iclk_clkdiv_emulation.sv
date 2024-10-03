
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
module hqm_rcfwl_gclk_iclk_clkdiv_emulation #(
    parameter int   MAX = 15,
    parameter logic CFG = 1,
    parameter int   WID = clogb2(MAX)
) (
    input  logic clk,
    input  logic rst_b,
    input  logic [WID-1:0] div,

    output logic clkdiv
);

function int clogb2 (input int Depth);
int i;
begin
    i = Depth;        
    for(clogb2 = 0; i > 0; clogb2 = clogb2 + 1) i = i >> 1; // lintra s-60118
end
endfunction

//function logic [MAX-1:0] pos_next (input logic [WID-1:0] seed);
//begin
   //if(seed == 0) begin
      //pos_nxt = {MAX{1'b0)}};
   //else if(seed == 1) begin
      //pos_nxt = {MAX{1'b1)}};
   //else if(seed == MAX) begin
      //pos_nxt = {pos[0], pos[MAX-1:1]};
   //else   
      //pos_nxt = {{MAX-seed{1'b0}},pos[0],pos[seed-1:1]};
//end      

logic [WID-1:0] seed;
logic [MAX-1:0] pos, pos_nxt;
logic [0:0]     neg;//, neg_nxt;
logic           junk;

always_comb    seed = CFG ? div : MAX[WID-1:0];
always_comb    {pos_nxt,junk} = ({pos[0], pos[MAX-1:1], 1'b0} & ~(1'b1 << seed)) | (pos[0] << seed);

always_ff @(posedge clk, negedge rst_b)
    if (!rst_b) begin
        for (int i = 0; i < MAX-1; i++)
            if (i < (seed>>1))  pos[i+1] <= '1;
            else if (i < seed)  pos[i+1] <= '0;
            else                pos[i+1] <= '1;
    end        
    else        pos[MAX-1:1] <= pos_nxt[MAX-1:1];

hqm_rcfwl_gclk_ctech_clk_div2_reset i_pos (
    .clk    (clk),
    .rst    (~rst_b),
    .in     (~pos_nxt[0]), // clk_div is inverting
    .clkout (pos[0])
);

generate
if (CFG || MAX[0]) begin : odd_div_logic

//always_comb neg_nxt[0] = seed[0] ? pos[0] : '0;

hqm_rcfwl_gclk_ctech_clk_div2_reset i_neg (
    .clk     (~clk), // TODO - CTECH
    .rst     (~rst_b),
    //.d      (neg_nxt[0]),
    .in      (~pos[0]), //clk_div is inverting
    .clkout  (neg[0])
);

always_comb clkdiv = ~((~pos[0]) & (~(neg[0]&seed[0]))); // TODO - CTECH

end : odd_div_logic
else begin : even_div_only

always_comb neg[0] = '0;
//always_comb neg_nxt[0] = '0;
always_comb clkdiv = pos[0];

end : even_div_only
endgenerate

// TODO - assert if div changes while not in reset

endmodule
