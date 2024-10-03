
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
//systemVerilog HDL for "c73p4plllc_coe73_sch", "c73p4plllc_dutycycflop" "systemverilog"


module hqm_rcfwl_gclk_iclk_dutycycflop ( 
     input logic clk, 
     input logic psb,
     input logic rb,
     output logic o
       );

//NON POR DIRECTIVE
//`ifdef EMULATION
logic d;
logic psb_b;
assign d = 1'b1;
assign psb_b = ~psb;
always_ff @(posedge psb_b or negedge rb) begin
    if (~rb) o <= 1'b0;
    else     o <= d;
end
`else
//`ifdef LINTRA_DEF
 hqm_rcfwl_gclk_ctech_msff_async_rst_set ctech_flop (.d(o), .clk(clk), .rst(~rb), .set(~psb), .o(o));
`else
logic d;
// this is an o not a 0
// Clock is not really used in this flop
always_comb d = o;  

logic psb_gated;
always_comb  psb_gated = psb | ~rb; // Ensure that rb is high before dropping psb.  

// Blocking statements removed since this is a clock divider
always @ (negedge (rb) or negedge (psb_gated) or posedge clk) begin
  if (~(rb)) 
     o = 1'b0;
  else if (~(psb_gated)) 
     o = 1'b1;
  else   
     o = d;
end     
`endif
`endif

endmodule
