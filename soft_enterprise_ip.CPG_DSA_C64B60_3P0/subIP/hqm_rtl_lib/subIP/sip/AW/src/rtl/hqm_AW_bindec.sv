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
// AW_bindec
//
// This module implements a binary decoder using the Synopsys DesignWare DW01_decode binary decoder.
// The dec output is a one-hot bus of width 2**WIDTH with the bit line specified by the input set.
// If the enable input is deasserted, the dec output is all zeros.
//
// The following parameters are supported:
//
//	WIDTH		Width of the input datapath.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_bindec
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2

	,parameter DWIDTH	= (1<<WIDTH)
) (
	 input	logic	[WIDTH-1:0]	a
	,input	logic			enable

	,output	logic	[DWIDTH-1:0]	dec
);

logic	[DWIDTH-1:0]	dec_int;
logic	[DWIDTH-1:0]	zero;		// This intermediate signal shouldn't be necessary, but avoids bogus W116 lint warnings

assign zero = {DWIDTH{1'b0}};

DW01_decode #(.width(WIDTH)) i_DW01_decode ( .A(a), .B(dec_int) );

assign dec = (enable) ? dec_int : zero;

endmodule // AW_bindec

