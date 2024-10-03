//----------------------------------------------------------------------------------------------------
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
// AW_clkmux4
//
// This module is responsible for implementing a 4-to-1 non-inverting clock multiplexer.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath that is multiplexed
//	BUSS		If set to 1, use a vector of selects (1/bit) instead of a single select.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_clkmux4
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
	,parameter BUSS		= 0
) (
	 input	logic	[WIDTH-1:0]		d0
	,input	logic	[WIDTH-1:0]		d1
	,input	logic	[WIDTH-1:0]		d2
	,input	logic	[WIDTH-1:0]		d3
	,input	logic	[((WIDTH-1)*BUSS):0]	s1
	,input	logic	[((WIDTH-1)*BUSS):0]	s0

	,output	logic	[WIDTH-1:0]		z
);

//-----------------------------------------------------------------------------------------------------

logic	[WIDTH-1:0]	d10;
logic	[WIDTH-1:0]	d32;

hqm_AW_clkmux2 #(.WIDTH(WIDTH), .BUSS(BUSS)) i_d10 (.d0( d0), .d1( d1), .s(s0), .z(d10));
hqm_AW_clkmux2 #(.WIDTH(WIDTH), .BUSS(BUSS)) i_d32 (.d0( d2), .d1( d3), .s(s0), .z(d32));
hqm_AW_clkmux2 #(.WIDTH(WIDTH), .BUSS(BUSS)) i_z   (.d0(d10), .d1(d32), .s(s1), .z(  z));

endmodule // AW_clkmux4

