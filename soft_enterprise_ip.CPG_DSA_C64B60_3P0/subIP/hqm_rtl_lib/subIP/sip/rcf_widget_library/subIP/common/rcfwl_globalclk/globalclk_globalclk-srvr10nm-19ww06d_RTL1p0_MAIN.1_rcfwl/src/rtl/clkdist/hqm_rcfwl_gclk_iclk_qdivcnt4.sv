
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
//systemVerilog HDL for "c73p4plllc_coe73_sch", "c73p4plllc_qdivcnt4" "systemverilog"


module hqm_rcfwl_gclk_iclk_qdivcnt4 #(parameter COUNTER_WIDTH = 4)
   ( 
   input logic clk,
   input logic rb,
   input logic reset,
   input logic [COUNTER_WIDTH-1:0] ratiom3,
   input logic [COUNTER_WIDTH-1:0] ratiohalfquadcnt,
   output logic [COUNTER_WIDTH-1:0] count,
   output logic full_cmp_out,
   output logic half_cmp_out
   );

logic [COUNTER_WIDTH-1:1] den;
logic [COUNTER_WIDTH-1:0] lcl_full_cmp_out;
logic [COUNTER_WIDTH-1:0] lcl_half_cmp_out;

assign den[1] = count[0];
assign den[2] = count[0] & count[1];
assign den[3] = count[0] & count[1] & count[2];
assign full_cmp_out = ~(&lcl_full_cmp_out);
assign half_cmp_out = ~(&lcl_half_cmp_out);

//assign reset = ~rb;

hqm_rcfwl_gclk_iclk_countff iffbit0 (
                                 .clk(clk),
                                 .rb,
                                 .ratiom3(ratiom3[0]),
                                 .ratiohalfquadcnt(ratiohalfquadcnt[0]),
                                 .full_cmp_out(lcl_full_cmp_out[0]),
                                 .half_cmp_out(lcl_half_cmp_out[0]),
                                 //.d(~(reset|count[0])), // ~reset&~count[0] ==> reset|~count[0] == ~(~reset&count[0])
                                 .d(~(~reset&count[0])),
                                 .o(count[0])); //Synchronous reset 
hqm_rcfwl_gclk_iclk_den_countff iffbit1 (
                                     .clk(clk),
                                     .rb(rb),
                                     .reset,
                                     .ratiom3(ratiom3[1]),
                                     .ratiohalfquadcnt(ratiohalfquadcnt[1]),
                                     .full_cmp_out(lcl_full_cmp_out[1]),
                                     .half_cmp_out(lcl_half_cmp_out[1]),
                                     .den(den[1]),
                                     .d(~count[1]),
                                     .o(count[1]));
hqm_rcfwl_gclk_iclk_den_countff iffbit2 (
                                     .clk(clk),
                                     .rb(rb),
                                     .reset,
                                     .ratiom3(ratiom3[2]),
                                     .ratiohalfquadcnt(ratiohalfquadcnt[2]),
                                     .full_cmp_out(lcl_full_cmp_out[2]),
                                     .half_cmp_out(lcl_half_cmp_out[2]),
                                     .den(den[2]),
                                     .d(~count[2]),
                                     .o(count[2]));
hqm_rcfwl_gclk_iclk_den_countff iffbit3 (
                                     .clk(clk),
                                     .rb(rb),
                                     .reset,
                                     .ratiom3(ratiom3[3]),
                                     .ratiohalfquadcnt(ratiohalfquadcnt[3]),
                                     .full_cmp_out(lcl_full_cmp_out[3]),
                                     .half_cmp_out(lcl_half_cmp_out[3]),
                                     .den(den[3]),
                                     .d(~count[3]),
                                     .o(count[3]));

endmodule
