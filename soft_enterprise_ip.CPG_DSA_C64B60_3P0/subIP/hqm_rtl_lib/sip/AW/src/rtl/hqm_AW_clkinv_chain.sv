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
// AW_clkinv_chain
//
// This module is responsible for buffering a signal through a chain of inverting buffers.
//
// The following parameters are supported:
//
//	WIDTH		Width of the buffer chain.
//	LENGTH		Length of the buffer chain.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_clkinv_chain
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
	,parameter LENGTH	= 1
) (
	 input	logic	[WIDTH-1:0]	clki

	,output	logic	[WIDTH-1:0]	clko
);

logic	[WIDTH-1:0]	clkc[LENGTH:0];
genvar			g;

//-----------------------------------------------------------------------------------------------------

assign clkc[0] = clki;

generate
 for (g=0; g<LENGTH; g=g+1) begin: g_length
  hqm_AW_clkinv #(.WIDTH(WIDTH)) i_clkinv_chain (.clki(clkc[g]), .clko(clkc[g+1]));
 end
endgenerate

assign clko = clkc[LENGTH];

endmodule // AW_clkinv_chain

