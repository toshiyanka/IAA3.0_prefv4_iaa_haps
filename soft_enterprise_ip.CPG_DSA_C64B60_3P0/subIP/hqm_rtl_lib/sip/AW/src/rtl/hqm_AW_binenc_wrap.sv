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
// wrap AW_binenc to support all scaling and allow a value of 1.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_binenc_wrap
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2
	,parameter MSB		= 0

	,parameter EWIDTH	= (WIDTH==1) ? 1 : (AW_logb2(WIDTH-1)+1)
) (
	 input	logic	[WIDTH-1:0]	a

	,output	logic	[EWIDTH-1:0]	enc
	,output	logic			any
);

genvar                                  g;

generate
 if (WIDTH == 1) begin: g_noenc
  assign enc = '0 ;
  assign any = a ;
 end else begin: g_enc
    hqm_AW_binenc #(
     .WIDTH (WIDTH)
    ,.MSB (MSB)
    ) i_hqm_AW_binenc_read (
     .a (a)
    ,.enc (enc)
    ,.any (any)
    );
 end
endgenerate

endmodule // AW_binenc
