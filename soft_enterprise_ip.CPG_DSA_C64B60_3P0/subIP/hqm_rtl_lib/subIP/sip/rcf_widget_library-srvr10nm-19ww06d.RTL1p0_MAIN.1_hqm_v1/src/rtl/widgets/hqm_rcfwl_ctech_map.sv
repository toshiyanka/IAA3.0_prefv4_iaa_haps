//
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

module hqm_rcfwl_ctech_doublesync_rstb (input logic d,
                                        input logic clk,
                                        input logic rstb,
                                        output logic o);
   ctech_lib_doublesync_rstb ctech_lib_synccell(.d(d), .clk(clk), .rstb(rstb), .o(o));
   
endmodule // rcfwl_ctech_doublesync_rstb


module hqm_rcfwl_ctech_buf (input logic a,
                            output logic o);
   
   ctech_lib_buf ctech_lib_buf(.a(a), .o(o));
   
endmodule // rcfwl_ctech_buf


module hqm_rcfwl_ctech_mux_2to1 (input logic d1,
                                 input logic d2,
                                 input logic s,
                                 output logic o);
   
   ctech_lib_mux_2to1 ctech_lib_mux(.d1(d1), .d2(d2), .s(s), .o(o));
endmodule

   
module hqm_rcfwl_ctech_doublesync (input logic d,
                               input logic clk,
                               output logic o);
   
   ctech_lib_doublesync ctech_lib_doublesync(.clk(clk), .d(d), .o(o));
endmodule // rcfwl_ctech_doublesync

module hqm_rcfwl_ctech_lib_or(input logic a,
                          input logic b,
                          output logic o);
   ctech_lib_or ctech_lib_or(.a(a), .b(b), .o(o));
endmodule // rcfwl_ctech_lib_or

module hqm_rcfwl_ctech_lib_and(input logic a,
                           input logic b,
                           output logic  o);
   ctech_lib_and ctech_lib_and(.a(a), .b(b), .o(o));
endmodule // rcfwl_ctech_lib_and

module hqm_rcfwl_ctech_lib_inv(input logic a,
                            output logic o1);
   ctech_lib_inv ctech_lib_inv(.a(a), .o1(o1));
endmodule // rcfwl_ctech_lib_inv
