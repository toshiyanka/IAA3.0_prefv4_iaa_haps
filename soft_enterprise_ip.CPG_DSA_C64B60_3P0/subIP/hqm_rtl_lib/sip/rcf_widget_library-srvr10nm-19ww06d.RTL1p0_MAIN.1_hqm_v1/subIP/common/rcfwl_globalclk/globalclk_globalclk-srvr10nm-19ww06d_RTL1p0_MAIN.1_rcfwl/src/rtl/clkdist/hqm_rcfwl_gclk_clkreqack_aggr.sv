
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
module hqm_rcfwl_gclk_clkreqack_aggr  #(
        parameter NUM_CLKREQS = 'd3               // number of clocks in cluster
        )
(
input   logic async_rst_n,                           //async reset pin. Tie off now.
input   logic clk,                                   //free running async clock.  Tie off now
input   logic [NUM_CLKREQS-1:0] clkreq_downstream,   //This connects to the agent side clkreqs
output  logic [NUM_CLKREQS-1:0] clkack_downstream,   //This connects to the agent side clkacks
output  logic clkreq_upstream,                      //connects to PMA clkreq pin
input   logic clkack_upstream                       //connects to PMA clkack pin

);


always_comb
begin
assign clkack_downstream = clkreq_downstream;
assign clkreq_upstream  = |clkreq_downstream ; 
end

endmodule
