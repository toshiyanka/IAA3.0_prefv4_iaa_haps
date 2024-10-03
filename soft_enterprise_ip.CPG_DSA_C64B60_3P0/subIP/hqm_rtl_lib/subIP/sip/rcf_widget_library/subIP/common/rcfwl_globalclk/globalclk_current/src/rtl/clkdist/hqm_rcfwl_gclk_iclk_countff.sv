
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
//systemVerilog HDL for "c73p4plllc_coe73_sch", "c73p4plllc_d04fkn00ld0c0_countff"
//"systemverilog"

module hqm_rcfwl_gclk_iclk_countff ( 
     input logic clk, 
     input logic rb, 
     input logic d,
     input logic ratiom3,
     input logic ratiohalfquadcnt,
     output logic full_cmp_out,  
     output logic half_cmp_out,
     output logic o
       );

//logic resetb;

//initial begin
//   resetb = 1'b0;
//   #10 resetb = 1'b1;
//end


assign full_cmp_out = o~^ratiom3;
assign half_cmp_out = o~^ratiohalfquadcnt;

always_ff @(posedge clk or negedge rb) begin
//always_ff @(posedge clk) begin
   if (~rb) o <= 0;
   else     o <= d;
end

endmodule

