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
// AW_mux
//
// This module is responsible for implementing a parameterized n-to-1 non-inverting multiplexer using
// the Synopsys DesignWare DW01_mux_any component.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath that is multiplexed.
//	NINPUTS		The number of inputs to multiplex (the "n" in n-to-1).
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_mux
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
	,parameter NINPUTS	= 2
	,parameter SWIDTH	= (AW_logb2(NINPUTS-1)+1)
) (
	 input	logic	[(WIDTH*NINPUTS)-1:0]	d
	,input	logic	[SWIDTH-1:0]		s

	,output	logic	[WIDTH-1:0]		z
);


//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert (WIDTH>0) else begin
    $display ("\nERROR: %m: Parameter WIDTH had an illegal value (%d).  Valid values are (>0) !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_ninputs_param: assert (NINPUTS>1) else begin
    $display ("\nERROR: %m: Parameter NINPUTS had an illegal value (%d).  Valid values are (>1) !!!\n",NINPUTS);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

DW01_mux_any #(

	 .A_width	(WIDTH*NINPUTS)
	,.SEL_width	(SWIDTH)
	,.MUX_width	(WIDTH)

) i_DW01_mux_any (

	 .A		(d)
	,.SEL		(s)

	,.MUX		(z)
);

endmodule // AW_mux

