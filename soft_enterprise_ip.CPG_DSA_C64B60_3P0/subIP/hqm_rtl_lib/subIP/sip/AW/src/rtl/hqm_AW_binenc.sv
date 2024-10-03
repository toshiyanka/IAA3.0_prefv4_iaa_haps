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
// AW_binenc
//
// This module implements a priority encoder using the Synopsys DesignWare DW01_binenc binary encoder.
// It will output the encoded value of the bit position in the input vector of the first bit that is set
// (from LSB to MSB if the MSB parameter is 0, or MSB to LSB if the MSB parameter is 1) and has an "any"
// output to indicate at least one of the input vector bits is set.
//
// The following parameters are supported:
//
//	WIDTH		Width of the input datapath.
//	MSB		If 1, use MSB to LSB priority instead of LSB to MSB priority (default=0).
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_binenc
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2
	,parameter MSB		= 0

	,parameter EWIDTH	= (AW_logb2(WIDTH-1)+1)
) (
	 input	logic	[WIDTH-1:0]	a

	,output	logic	[EWIDTH-1:0]	enc
	,output	logic			any
);


localparam AWIDTH = (AW_logb2(WIDTH)+1);

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert (WIDTH>1) else begin
    $display ("\nERROR: %m: Parameter WIDTH had an illegal value (%d).  Valid values are (>1) !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

logic	[AWIDTH-1:0]	addr; 

generate
 if (MSB==0) begin: g_lsb

  DW01_binenc #(.A_width(WIDTH), .ADDR_width(AWIDTH)) i_DW01_binenc ( .A(a), .ADDR(addr) );

  assign enc = addr[EWIDTH-1:0];

 end else begin: g_msb

  DW01_prienc #(.A_width(WIDTH), .INDEX_width(AWIDTH)) i_DW01_binenc ( .A(a), .INDEX(addr) );

  assign enc = addr[EWIDTH-1:0] - 1'b1;

 end
endgenerate

assign any = |a;

endmodule // AW_binenc

