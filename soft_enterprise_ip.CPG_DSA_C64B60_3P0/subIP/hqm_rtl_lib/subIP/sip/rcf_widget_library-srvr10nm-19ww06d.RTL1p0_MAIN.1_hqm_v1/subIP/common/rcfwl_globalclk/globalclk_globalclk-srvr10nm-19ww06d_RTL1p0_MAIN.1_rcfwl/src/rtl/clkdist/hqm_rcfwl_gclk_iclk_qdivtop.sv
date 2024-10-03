
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
///NON-POR DIRECTIVE
//`ifdef HIP_PS_RESOLUTION
//  `timescale 1ps/1ps
//`else
//  `timescale 1ps/1fs
//`endif
  
//systemVerilog HDL for "c71p1plllc_coe71_sch", "c71p1plllc_qdivtop" "systemverilog"


module hqm_rcfwl_gclk_iclk_qdivtop ( 
       output logic hith, 
       output logic hitl, 
       input logic clkin, 
       input logic divrstb, 
       input logic [3:0] ratiom3, 
       input logic dutycyc_50p_en
       );

logic full_cmp_out;
logic half_cmp_out;
logic lcl_hith;
logic lcl_hith_dly;
logic lcl_hitl;
logic lcl_hitl_50p;
logic full_cmp_out_b;
logic half_cmp_out_b;

logic first_clock;


//assign hith = lcl_hith_dly | ~divrstb; // DNV removed hith_dly to allow /3 to work
assign hith = lcl_hith_dly; // DNV removed hith_dly to allow /3 to work
// During reset apply the posedge reset term
assign hitl = (ratiom3[0] & dutycyc_50p_en)? lcl_hitl_50p:lcl_hitl; // DNV removed inversion and latch

hqm_rcfwl_gclk_iclk_qdivcnt4 icount ( .clk(clkin),
                                  .ratiom3(ratiom3-1),
                                  .ratiohalfquadcnt({1'b0,ratiom3[3:1]}),
                                  .full_cmp_out(full_cmp_out_b),
                                  .half_cmp_out(half_cmp_out_b),
                                  //.rb(divrstb&hithb) // DNV Removed delay
                                  .rb(divrstb), // DNV Removed delay
                                  .count(),
                                  .reset(lcl_hith) // DNV SYNC reset
                                );

// DNV added inversion to replace extra level of div
// Also prevent cmp_out signals from asserting during reset.
//assign full_cmp_out = ~(full_cmp_out_b&~(first_clock));
assign full_cmp_out = ~(full_cmp_out_b);
assign half_cmp_out = ~(half_cmp_out_b);

// Need this buffer to remove the zero cycle paths on clock generation
// clk_div is inverting
//ctech_lib_clk_div2_reset i_pos (
//    .clk    (clkin),
//    .rst    (~divrstb),
//    .in     (~(lcl_hith | first_clock)), // lintra s-60008
//    .clkout (lcl_hith_dly)
//);
//ctech_lib_clk_div2_reset i_neg (
//    .clk    (clkin),
//    .rst    (~divrstb),
//    .in     (~half_cmp_out), // lintra s-60008
 //   .clkout (lcl_hitl)
//);
//ctech_lib_clk_div2_reset i_neg_50p (
//    .clk    (~clkin),
//    .rst    (~divrstb),
//    .in     (~lcl_hitl), // lintra s-60008
 //   .clkout (lcl_hitl_50p)
//);

always_ff @(posedge clkin or negedge divrstb) begin
   if(~divrstb) begin
   lcl_hith_dly =1'b0;
   end
   else begin
   lcl_hith_dly = (lcl_hith | first_clock);
   end
end

always_ff @(posedge clkin or negedge divrstb) begin
   if(~divrstb) begin
   lcl_hitl =1'b0;
   end
   else begin
   lcl_hitl = half_cmp_out;
   end
end

always_ff @(negedge clkin or negedge divrstb) begin
   if(~divrstb) begin
   lcl_hitl_50p =1'b0;
   end
   else begin
   lcl_hitl_50p = lcl_hitl;
   end
end

always_ff @(posedge clkin or negedge divrstb) begin
   if(~divrstb) begin
       first_clock <= 1'b1;
       lcl_hith <= 1'b0;
   end
   else begin
       first_clock <= 1'b0;
       lcl_hith <= full_cmp_out;
   end
end

endmodule
