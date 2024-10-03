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
// AW_sticky_data
//
// This module is responsible for capturing and holding information associated with a trigger signal.
// Its primary use is to hold debug (syndrome) information from an error event where the error is
// remembered using an AW_sticky_bit block, and the edge formed by an input bit and the associated
//  output bit of that block is used as the trigger to this one.
//
// A write interface is also provided for testing.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath that is registered
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_sticky_data
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
) (
	 input	logic			clk
	,input	logic			rst_n

	,input	logic			trigger
	,input	logic			trigger_q

	,input	logic	[WIDTH-1:0]	d
	
	,input	logic			write
	,input	logic	[WIDTH-1:0]	wdata

	,output	logic	[WIDTH-1:0]	q
);

//-----------------------------------------------------------------------------------------------------
// Dataflow
//
// error/error_data	AW_sticky_bit.q		AW_sticky_data.trigger/trigger_q/trigger_edge/d/q
//   0       A		       0			0    0    0    A    x
//   0       B		       0			0    0    0    B    x
//   1       C		       0			1    0    1    C    x
//   0       D		       1			0    1    0    D    C
//   x       x		       1			0    1    0    x    C
//-----------------------------------------------------------------------------------------------------

logic			trigger_edge;
logic	[WIDTH-1:0]	q_q;

assign trigger_edge = trigger & ~trigger_q;

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  q_q <= {WIDTH{1'b0}};
 end else begin
  q_q <= (write) ? wdata : ((trigger_edge) ? d : q_q);
 end
end

assign q = q_q;

endmodule // AW_sticky_data

