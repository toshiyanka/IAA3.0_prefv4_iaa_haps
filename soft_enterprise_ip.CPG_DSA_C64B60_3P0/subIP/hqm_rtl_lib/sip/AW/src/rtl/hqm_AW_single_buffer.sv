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
// AW_single_buffer
//
// Same pinout as AW_double_buffer but just a single register stage.  As with AW_double_buffer,
// decouple input/output timing for data, but out_ready does feed back combinationally to in_ready.
//
// The 7-bit status output provides the following registered information:
//
//	[6]	Input stalled   (in_valid &  ~in_ready)	: Can be used as countable input  stall    event
//	[5]	Input taken     (in_valid &   in_ready)	: Can be used as countable input  accepted event
//	[4]	Output stalled (out_valid & ~out_ready)	: Can be used as countable output stall    event
//	[3]	Output taken   (out_valid &  out_ready)	: Can be used as countable output accepted event
//	[2]	Registered value of out_ready		: Useful as read-only backpressure status
//	[1:0]	Current depth value			: Useful as read-only depth status
//
// It is recommended that bits [6:3] are hooked to an SMON so they can be counted and that bits [2:0]
// are available as read-only configuration status.
//
// An inline covergroup is included to provide comprehensive code coverage information if the design
// is compile with coverage enabled.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_single_buffer
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

logic			in_taken ;
logic			in_stall ;
logic			out_taken ;
logic			out_stall ;
logic                   depth_nxt ;
logic                   depth_f ;
logic [4:0]             status_nxt ;
logic [4:0]             status_f ;
logic [WIDTH-1:0]       data_nxt ;
logic [WIDTH-1:0]       data_f ;

//--------------------------------------------------------------------------------------------------

assign in_ready         = out_ready | ! depth_f ;       // Note - output timing passed through to input

assign in_taken         = in_valid &   in_ready ;
assign in_stall         = in_valid & ! in_ready ;

assign out_taken        = depth_f &   out_ready ;
assign out_stall        = depth_f & ! out_ready ;

assign status_nxt       = {in_stall, in_taken, out_stall, out_taken, out_ready};

always_comb begin
  data_nxt              = data_f ;
  depth_nxt             = depth_f ;
  if ( in_taken ) begin
    depth_nxt           = 1'b1 ;
    data_nxt            = in_data ;
  end
  else if ( out_ready )
    depth_nxt           = 1'b0 ;
end // always


always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    depth_f             <= 1'b0 ;
    status_f            <= 5'd0;
  end
  else begin
    depth_f             <= depth_nxt ;
    status_f            <= status_nxt;
  end
end // always

always_ff @( posedge clk ) begin
  data_f                <= data_nxt ;
end // always

assign out_valid        = depth_f ;
assign out_data         = data_f ;

assign status           = {status_f, 1'b0 , depth_f};  // Same format as double_buffer, pad depth



endmodule // AW_single_buffer

