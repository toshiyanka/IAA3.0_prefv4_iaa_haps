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
// AW_mult
//
// This is a wrapper for the DW02_mult Synopsys DesignWare subtractor component.
//
// PRODUCT = A X B 
//
// The control signal TC determines whether the input and output data is
// iterpreted as unsigned (TC=0) or signed (TC=1) numbers.
//
// The following parameters are supported:
//
//	A_WIDTH		Width of the A datapath.
//	B_WIDTH     Width of the B datapath.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_mult
       import hqm_AW_pkg::*; #(

	 parameter A_WIDTH	= 1
	,parameter B_WIDTH	= 1
) (
	 input	logic	[A_WIDTH-1:0]	        a
	,input	logic	[B_WIDTH-1:0]	        b
	,input	logic				tc

	,output	logic	[(A_WIDTH+B_WIDTH)-1:0]	product
);

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_a_width_param: assert (A_WIDTH>=1) else begin
    $display ("\nERROR: %m: Parameter A_WIDTH had an illegal value (%d).  Valid values are (>=1) !!!\n",A_WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_b_width_param: assert (B_WIDTH>=1) else begin
    $display ("\nERROR: %m: Parameter B_WIDTH had an illegal value (%d).  Valid values are (>=1) !!!\n",B_WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

DW02_mult #(.A_width(A_WIDTH),.B_width(B_WIDTH)) i_DW02_mult ( .A(a), .B(b), .TC(tc), .PRODUCT(product) );

endmodule // AW_mult

