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
// AW_barrel_bit
//
// This module is responsible for implementing a full bit length barrel rotator.
//
// It provides either a rotate or arithemtic shift and allows you to specify the padding bits for
// the arithmetic case ('0', '1', or '0' with sign_extension).
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath.
//	ARITH		Rotate (ARITH==0) or arithmetic shift (ARITH==1).
//	PAD		For arithmetic shift mode, pad with '0' (PAD==0), '1' (PAD==1) or '0' with
//			sign extension (PAD==2).
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_barrel_bit
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 32
	,parameter ARITH	= 0
	,parameter PAD		= 0

	,parameter ROT_WIDTH	= (AW_logb2(WIDTH-1)+1)
) (
	 input	logic	[WIDTH-1:0]	din
	,input	logic			dir
	,input	logic	[ROT_WIDTH-1:0]	rotate

	,output	logic	[WIDTH-1:0]	dout
);

//-----------------------------------------------------------------------------------------------------


localparam SH_WIDTH  = AW_logb2(WIDTH)+1;

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert (WIDTH>1) else begin
    $display ("\nERROR: %m: Parameter WIDTH had an illegal value (%d).  Valid values are (>1) !!!\n",WIDTH);
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

logic	[ROT_WIDTH:0]	shift;

assign shift = (dir) ? (~{1'b0,rotate} + 1'b1) : {1'b0,rotate};

// synopsys dc_script_begin
// set_implementation mx4 i_DW_shifter
// synopsys dc_script_end

DW_shifter #(

	.data_width	(WIDTH),
	.sh_width	(SH_WIDTH),
	.inv_mode	((PAD==1)?1:0)

) i_DW_shifter (

	.data_in	(din),
	.data_tc	((PAD==2)?1'b1:1'b0),
	.sh		(shift[SH_WIDTH-1:0]),
	.sh_tc		(1'b1),
	.sh_mode	((ARITH==0) ? 1'b0 : 1'b1),

	.data_out	(dout)
);

generate
 if (SH_WIDTH == ROT_WIDTH) begin: g_unused
  hqm_AW_unused_bits #(.WIDTH(1)) i_unused (.a(shift[SH_WIDTH]));
 end
endgenerate

endmodule // AW_barrel_bit

