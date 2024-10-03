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
// AW_clkand2_sync
//
// This module is responsible for implementing a 2-input clock "AND" gate w/ a synced and latched enable.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_clkand2_sync
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
) (
	 input	logic	[WIDTH-1:0]	clki
	,input	logic	[WIDTH-1:0]	e

	,output	logic	[WIDTH-1:0]	clko
);

//-----------------------------------------------------------------------------------------------------

logic	[WIDTH-1:0]	e_sync;
genvar			g;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_sync

  hqm_AW_sync #(.WIDTH(1)) i_e_sync (.clk(clki[g]), .data(e[g]), .data_sync(e_sync[g]));

 end
endgenerate

hqm_AW_clkand2 #(.WIDTH(WIDTH)) i_clko (.clki(clki), .e(e_sync), .clko(clko));

endmodule // AW_clkand2_sync

