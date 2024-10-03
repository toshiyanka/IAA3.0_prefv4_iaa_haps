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
// AW_leading_ones
//
// This module is a wrapper for the Synopsys DesignWare DW_lod leading ones detector.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_leading_ones
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2

	,parameter EWIDTH	= (AW_logb2(WIDTH-1)+2)
) (
	 input	logic	[WIDTH-1:0]	a

	,output	logic	[WIDTH-1:0]	dec
	,output	logic	[EWIDTH-1:0]	enc
);


//-----------------------------------------------------------------------------------------------------

logic	[EWIDTH-1:0]	encx;

DW_lod #(.a_width(WIDTH)) i_DW_lod ( .a(a), .dec(dec), .enc(encx) );

// If input is all ones, then encx is set to all 1s and we want the real value...

assign enc = (&encx) ? WIDTH[EWIDTH-1:0] : encx;

endmodule // AW_leading_ones

