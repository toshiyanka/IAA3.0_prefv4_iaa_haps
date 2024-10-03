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
// AW_inc
//
// This is a wrapper for the DW01_inc Synopsys DesignWare incrementer component.
//
// SUM = A+1	There is no carry out and SUM wraps to all zeros if A is all ones.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_inc
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
) (
	 input	logic	[WIDTH-1:0]	a

	,output	logic	[WIDTH-1:0]	sum
);

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert (WIDTH>0) else begin
    $display ("\nERROR: %m: Parameter WIDTH had an illegal value (%d).  Valid values are (>0) !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

DW01_inc #(.width(WIDTH)) i_DW01_inc ( .A(a), .SUM(sum) );

endmodule // AW_inc

