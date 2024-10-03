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
// AW_id_freelist_bb
//
//wiki(Overview)
// This module is just a building block used by AW_id_freelist.
//endwiki
//
//wiki(Parameters)
// The following parameters are supported:
//
//	| *Parameter*	| *Description* |
//	| NUM_IDS	| Number of IDs being managed. |
//	| NUM_PUSHES	| Number of IDs that can be pushed at once. |
//endwiki

//-----------------------------------------------------------------------------------------------------

//wiki(Module)
module hqm_AW_id_freelist_bb
       import hqm_AW_pkg::*; #(

	 parameter NUM_IDS	= 16
	,parameter NUM_PUSHES	= 1

	,parameter ID_WIDTH	= (AW_logb2(NUM_IDS-1)+1)
) (
	 input	logic					clk
	,input	logic					rst_n

	,input	logic					pop		// Pop the current ID from the freelist
	,output	logic					pop_id_v	// There is a freelist id available (pop_id is valid)
	,output	logic	[ID_WIDTH-1:0]			pop_id		// The next available freelist ID (if pop_id_v is asserted)

	,input	logic	[NUM_PUSHES-1:0]		push		// Push the ID in push_id back onto the freelist
	,input	logic	[(NUM_PUSHES*ID_WIDTH)-1:0]	push_id

	,output	logic	[NUM_IDS-1:0]			id_vector	// vector of available flags for all ids
);
//endwiki

//-----------------------------------------------------------------------------------------------------


localparam EWIDTH = (AW_logb2(NUM_IDS-1)+2);
localparam [ID_WIDTH-1:0] MAX_ID = NUM_IDS-1;

//-----------------------------------------------------------------------------------------------------

logic	[NUM_IDS-1:0]	id_v_q;
logic	[NUM_IDS-1:0]	id_v_nxt;

//-----------------------------------------------------------------------------------------------------

// reset value of id_v_q is all 1's
always_ff @(posedge clk or negedge rst_n) begin : id_v_block
 if (!rst_n) begin
  id_v_q <= {NUM_IDS{1'b1}};
 end else begin
  if (|{push,pop}) begin
   id_v_q <= id_v_nxt;
  end
 end
end // id_v_block

hqm_AW_id_freelist_bb_core # (
	.NUM_IDS			( NUM_IDS ) ,
	.NUM_PUSHES			( NUM_PUSHES )
) i_AW_id_freelist_bb_core (
	.clk				( clk ) ,
	.rst_n				( rst_n ) ,
	.pop				( pop ) ,
	.pop_id_v			( pop_id_v ) ,
	.pop_id				( pop_id ) ,
	.push				( push ) ,
	.push_id			( push_id ) ,
	.id_vector			( id_vector ) ,
	.id_v_q				( id_v_q ) ,
	.id_v_nxt			( id_v_nxt )
) ;

endmodule // AW_id_freelist_bb

