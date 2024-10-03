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
// AW_clkand2_comb
//
// This module is responsible for implementing a purely combinatorial 2-input clock "AND" gate.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapaths that are connected
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_clkand2_comb #(

  // Name:         WIDTH
  // Default:      1
  // Values:       -2147483648, ..., 2147483647
  parameter WIDTH = 1
  ) (
	 input	logic	[WIDTH-1:0]	clki0
	,input	logic	[WIDTH-1:0]	clki1

	,output	logic	[WIDTH-1:0]	clko
);

//-----------------------------------------------------------------------------------------------------

// synopsys translate_off

genvar g;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_w
  hqm_AW_ctech_clk_and i_clk_and (.clk1(clki0[g]), .clk2(clki1[g]), .clkout(clko[g]));
 end
endgenerate

// synopsys translate_on
endmodule // AW_clkand2_comb

