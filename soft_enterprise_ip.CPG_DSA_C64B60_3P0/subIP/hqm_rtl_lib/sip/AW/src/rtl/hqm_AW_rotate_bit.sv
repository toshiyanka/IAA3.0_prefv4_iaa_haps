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
// AW_rotate_bit
//
// This module is responsible for implementing a full bit length rotator or shifter.
//
// It provides either a rotate or arithemtic shift and allows you to specify the padding bits for
// the arithmetic case ('0', '1', or '0' with sign_extension).
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath in bits.
//	LRN		Right (LRN==0) or Left (LRN==1) rotate or shift (Left Right Not)
//	ARITH		Rotate (ARITH==0) or arithmetic shift (ARITH==1).
//	PAD		For arithmetic shift mode, pad with '0' (PAD==0), '1' (PAD==1) or '0' with
//			sign extension (PAD==2).
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_rotate_bit
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2
	,parameter LRN		= 0
	,parameter ARITH	= 0
	,parameter PAD		= 0

	,parameter ROT_WIDTH	= (AW_logb2(WIDTH-1)+1)
) (
	 input	logic	[WIDTH-1:0]	din
	,input	logic	[ROT_WIDTH-1:0]	rot

	,output	logic	[WIDTH-1:0]	dout
);


//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert (WIDTH>1) else begin
    $display ("\nERROR: %m: Parameter WIDTH had an illegal value (%d).  Valid values are (>1) !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_lrn_param: assert ((LRN==0) || (LRN==1)) else begin
    $display ("\nERROR: %m: Parameter LRN had an illegal value (%d).  Valid values are (0 or 1) !!!\n",ARITH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_arith_param: assert ((ARITH==0) || (ARITH==1)) else begin
    $display ("\nERROR: %m: Parameter ARITH had an illegal value (%d).  Valid values are (0 or 1) !!!\n",ARITH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_pad_param: assert ((PAD>=0) && (PAD<3)) else begin
    $display ("\nERROR: %m: Parameter PAD had an illegal value (%d).  Valid values are (0-2) !!!\n",PAD);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

logic	[(WIDTH*3)-1:0]	d;
logic			p;

generate

 if (PAD == 2) begin: g_pad2

  if (LRN == 0) begin: g_pad2_lrn0

   assign p = din[WIDTH-1];					// PAD==2, Right

  end else begin: g_pad2_lrn1

   assign p = 1'b0;						// PAD==2, Left

  end

 end else if (PAD == 1) begin: g_pad1

  assign p = 1'b1;						// PAD==1

 end else begin: g_pad0

  assign p = 1'b0;	// spyglass disable W528 -- May not use    PAD==0

 end

 if (LRN == 1) begin: g_lrn1

  if (ARITH == 1) begin: g_lrn1_arith1

   assign d = {din,{(WIDTH*2){p}}};				// Left Shift

  end else begin: g_lrn1_arith0

   assign d = {3{din}};						// Left Rotate

  end

  // spyglass disable_block SYNTH_5130 -- Index will always be okay

  assign dout = d[(((WIDTH*3)-rot)-1) -: WIDTH];		// Left Rotate or Shift

  // spyglass enable_block  SYNTH_5130

 end else begin: g_lrn0

  if (ARITH == 1) begin: g_lrn0_arith1

   assign d = {{(WIDTH*2){p}},din};				// Right Shift

  end else begin: g_lrn0_arith0

   assign d = {3{din}};						// Right Rotate

  end

  assign dout = d[((WIDTH + {{(32-ROT_WIDTH){1'b0}},rot}) - 1) -: WIDTH];

 end

endgenerate

endmodule // AW_rotate_bit

