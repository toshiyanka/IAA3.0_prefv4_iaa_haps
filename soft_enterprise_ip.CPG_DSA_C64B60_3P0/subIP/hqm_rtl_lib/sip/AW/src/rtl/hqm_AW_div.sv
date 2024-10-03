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
// AW_div
//
// This is a wrapper for the DW_div Synopsys DesignWare combinatorial divider component.
//
// {Q,R} = A/B (DIV0 = (B==0))
//
// The following parameters are supported:
//
//	AWIDTH		Width of the dividend (A) input and quotient (QUOT) output.
//	BWIDTH		Width of the divisor (B) input and remainder (REM) output.
//	TC_MODE		Two's compliment mode (1=signed, 0=unsigned).
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_div
       import hqm_AW_pkg::*; #(

	 parameter A_WIDTH	= 1
	,parameter B_WIDTH	= 1
	,parameter TC_MODE	= 0
) (
	 input	logic	[A_WIDTH-1:0]	a
	,input	logic	[B_WIDTH-1:0]	b

	,output	logic	[A_WIDTH-1:0]	q
	,output	logic	[B_WIDTH-1:0]	r
	,output	logic			divo
);

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_params: assert ((A_WIDTH>0) && (B_WIDTH>0) && (A_WIDTH >= B_WIDTH)) else begin
    $display ("\nERROR: %m: Parameters A_WIDTH and B_WIDTH had illegal values (%d/%d).  Valid values are (>0 and A>=B) !!!\n",A_WIDTH,B_WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

DW_div #(.a_width(A_WIDTH), .b_width(B_WIDTH), .tc_mode(TC_MODE), .rem_mode(1)) i_DW_div (

	 .a		(a)
	,.b		(b)
	,.quotient	(q)
	,.remainder	(r)
	,.divide_by_0	(divo)
);

endmodule // AW_div

