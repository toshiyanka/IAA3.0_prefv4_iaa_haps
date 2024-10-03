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
// AW_clkmux2
//
// This module is responsible for implementing a 2-to-1 non-inverting clock multiplexer.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath that is multiplexed
//	BUSS		If set to 1, use a vector of selects (1/bit) instead of a single select.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_clkmux2
// collage-pragma translate_off
       import hqm_AW_pkg::*; 
// collage-pragma translate_on
#(
	 parameter WIDTH	= 1
	,parameter BUSS		= 0
) (
	 input	logic	[WIDTH-1:0]		d0
	,input	logic	[WIDTH-1:0]		d1
	,input	logic	[(WIDTH-1)*BUSS:0]	s

	,output	logic	[WIDTH-1:0]		z
);

//-----------------------------------------------------------------------------------------------------

// collage-pragma translate_off

genvar g;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_w
  hqm_AW_ctech_clk_mux_2to1 i_clk_mux_2to1 (.clk1(d1[g]), .clk2(d0[g]), .s(s[g*BUSS]), .clkout(z[g]));
 end
endgenerate

// collage-pragma translate_on

endmodule // AW_clkmux2

