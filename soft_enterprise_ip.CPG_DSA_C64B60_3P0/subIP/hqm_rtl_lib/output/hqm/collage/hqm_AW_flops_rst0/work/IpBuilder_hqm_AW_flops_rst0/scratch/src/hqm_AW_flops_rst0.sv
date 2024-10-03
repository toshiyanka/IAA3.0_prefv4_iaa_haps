//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// AW_flops_rst0
//
// This module is responsible for instantiating a parameterized number of flipflops w/ an async reset.
//
// The following parameters are supported:
//
//      WIDTH           Width of the datapath
//
//-----------------------------------------------------------------------------------------------------

// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_AW_flops_rst0

         import hqm_AW_pkg::*;
#(

         // reuse-pragma startSub WIDTH [ReplaceParameter -design hqm_AW_flops_rst0 -lib work -format systemverilog WIDTH -endTok "" -indent "         "]
         parameter WIDTH        = 1

         // reuse-pragma endSub WIDTH
         ) (
         input  logic                   clk
        ,input  logic                   rst_n
        ,input  logic   [WIDTH-1:0]     data

        ,output logic   [WIDTH-1:0]     data_q
);

//-----------------------------------------------------------------------------------------------------

genvar g;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_w
  always_ff @(posedge clk or negedge rst_n) if (~rst_n) data_q[g] <= 1'b0; else data_q[g] <= data[g];
 end
endgenerate

endmodule // AW_flops_rst0

