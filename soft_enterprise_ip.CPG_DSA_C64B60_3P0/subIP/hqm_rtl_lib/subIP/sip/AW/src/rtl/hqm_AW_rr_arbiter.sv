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
// AW_rr_arbiter
//
// This module is responsible for implementing an arbiter that supports 3 modes of operation:
//
// mode=0	strict_priority		Requestor 0 has highest priority, followed by requestor 1, etc.
// mode=1	rotating_priority	Each clock, the next requestor becomes the highest priority.
// mode=2	round_robin		Rotating, but winner+1 becomes highest priority next clock.
//
// The following parameters are supported:
//
//	NUM_REQS	The number of requestors to arbitrate among.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_rr_arbiter
       import hqm_AW_pkg::*; #(

	 parameter NUM_REQS	= 2

	,parameter WIDTH	= (AW_logb2(NUM_REQS-1)+1)

) (

	 input	logic			clk
	,input	logic			rst_n

	,input	logic	[1:0]		mode		// Arbitration mode
	,input	logic			update		// Update index

	,input	logic	[NUM_REQS-1:0]	reqs		// Vector of requests

	,output	logic			winner_v
	,output	logic	[WIDTH-1:0]	winner		// Winner of the arbitration
);

//--------------------------------------------------------------------------------------------


localparam ROT_WIDTH = (1<<WIDTH);

//--------------------------------------------------------------------------------------------

genvar g;

generate
 if (NUM_REQS == 1) begin: g_NoArb

  logic unused;

  assign winner_v = reqs[0];
  assign winner   = 1'b0;

  assign unused = |{clk, rst_n, mode, update};	// spyglass disable W528

 end else begin: g_Arb

  //--------------------------------------------------------------------------------------------

  logic	[ROT_WIDTH-1:0]		reqs_scaled;

  logic	[ROT_WIDTH-1:0]		reqs_rot;

  logic	[WIDTH-1:0]		index;
  logic	[WIDTH-1:0]		index_next;
  logic	[WIDTH-1:0]		index_q;
  logic	[WIDTH-1:0]		index_plus1;

  logic				winner_v_int;
  logic	[WIDTH-1:0]		winner_int;

  logic	[WIDTH-1:0]		winner_plus1;

  logic	[WIDTH-1:0]		prienc;

  //--------------------------------------------------------------------------------------------
  // Request vector rotator

  hqm_AW_width_scale #(.A_WIDTH(NUM_REQS), .Z_WIDTH(ROT_WIDTH)) i_reqs_scaled (

	.a		(reqs),
	.z		(reqs_scaled)
  );

  DW_rbsh #(.A_width(ROT_WIDTH), .SH_width(WIDTH)) i_reqs_rot (

	.A		(reqs_scaled),
	.SH		(index),
	.SH_TC		(1'b0),
	.B		(reqs_rot)
  );

  //--------------------------------------------------------------------------------------------
  // Priority encoder for rotated request vector

logic any_nc ;
  hqm_AW_binenc #(.WIDTH(ROT_WIDTH)) i_prienc (

	.a		(reqs_rot),
	.enc		(prienc),
	.any		(any_nc)
  );

  assign winner_v_int = |reqs;
  assign winner_int   = prienc + index; // spyglass disable W484 W164a -- Don't need the upper bit

  assign winner_plus1 = ({{(32-WIDTH){1'b0}},winner_int} == (NUM_REQS-1)) ? {WIDTH{1'b0}} : (winner_int + {{(WIDTH-1){1'b0}},1'b1});
  assign index_plus1  = ({{(32-WIDTH){1'b0}},   index_q} == (NUM_REQS-1)) ? {WIDTH{1'b0}} : (index_q +    {{(WIDTH-1){1'b0}},1'b1});

  //--------------------------------------------------------------------------------------------
  // Index logic for Rotating and Round Robin functionality

  always_comb begin
   casez ({(winner_v_int & update),mode})
    3'b1_1?: index_next = winner_plus1;
    3'b1_01: index_next = index_plus1;
    3'b?_00: index_next = {WIDTH{1'b0}};
    default: index_next = index_q;
   endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
    index_q <= {WIDTH{1'b0}};
   end else begin
    index_q <= index_next;
   end
  end

  assign index = (|mode) ? index_q : {WIDTH{1'b0}};

  assign winner_v = winner_v_int;
  assign winner   = winner_int & {WIDTH{winner_v_int}};

 end
endgenerate

endmodule // AW_rr_arbiter

