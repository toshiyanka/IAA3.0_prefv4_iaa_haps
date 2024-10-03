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
// AW_zero_buffer
//
// Same pinout as AW_double_buffer & AW_single_buffer but no register stage.  The input/output timing 
// is not decoupled. This is to be used on instances where a double/sigle buffer needs buffering 
// removed (reduce latecny) and can tolerate the static timing, this design allows for the instance
// pinout connection & config status to be unchanged
//
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_zero_buffer
       import hqm_AW_pkg::*; #(

	 parameter WIDTH		= 32
	,parameter NOT_EMPTY_AT_EOT	= 0

) (

	 input	logic			clk
	,input	logic			rst_n

	,output	logic	[6:0]		status

	//------------------------------------------------------------------------------------------
	// Input side

	,output	logic			in_ready

	,input	logic			in_valid
	,input	logic	[WIDTH-1:0]	in_data

	//------------------------------------------------------------------------------------------
	// Output side

	,input	logic			out_ready

	,output	logic			out_valid
	,output	logic	[WIDTH-1:0]	out_data
);

//--------------------------------------------------------------------------------------------------


assign in_ready         = out_ready ;

assign out_valid        = in_valid ;
assign out_data         = in_data ;

assign status           = { {1'b0, 1'b0, 1'b0, 1'b0, out_ready} , 1'b0 , in_valid } ;  // Same format as double_buffer & single_buffer, use in_valid for depth

endmodule // AW_zero_buffer

