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
// AW_id_freelist_bb_core
//
//wiki(Overview)
// This module is just a submodule for AW_id_freelist_bb, with the id_v_nxt and id_v_q accessible
// as ports.
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
module hqm_AW_id_freelist_bb_core
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

	,input	logic	[NUM_IDS-1:0]			id_v_q		// Actual vector reg is maintained externally
	,output	logic	[NUM_IDS-1:0]			id_v_nxt	// Next value as calculated here, may be overridden externally
);
//endwiki

//-----------------------------------------------------------------------------------------------------


localparam EWIDTH = (AW_logb2(NUM_IDS-1)+2);
localparam [ID_WIDTH-1:0] MAX_ID = NUM_IDS-1;

//-----------------------------------------------------------------------------------------------------

logic	[NUM_IDS-1:0]	id_v_set;
logic	[NUM_IDS-1:0]	id_v_clr;
logic	[EWIDTH-1:0]	id_v_lz;

//-----------------------------------------------------------------------------------------------------

// next value of id_v_q set based on id_v_clr and id_v_set.
// id_v_set overrides id_v_clr

assign id_v_nxt = (id_v_q & id_v_clr) | id_v_set;

// reset value of id_v_q is all 1's

// set output port value

always_comb begin: Flip_v
 for (int i=0; i<NUM_IDS; i=i+1) begin
  id_vector[i] = id_v_q[NUM_IDS-1-i];	// spyglass disable W116
 end
end

// find the first available id (first 1) in id_v_q
// id_v_lz is the number of leading zeros found in id_v_q, starting from index NUM_IDS-1

hqm_AW_leading_zeros #(.WIDTH(NUM_IDS)) i_id_v_lz (

	.a	(id_v_q),
	.dec	(),  
	.enc	(id_v_lz)
);

// ID is valid if the number of leading zeros is less than NUM_IDS

assign pop_id_v = (id_v_lz < NUM_IDS[EWIDTH-1:0]);

// pop_id is the number of leading zeros

assign pop_id = id_v_lz[ID_WIDTH-1:0];

// set corresponding bit of id_v_set if push asserted
// This vector is OR'ed with id_v_q, so set the index identified by ~push_id to set the bit in id_v_q

always_comb begin : set_vector_block

  id_v_set = {NUM_IDS{1'b0}};

  for (int i=0; i<NUM_PUSHES; i=i+1) begin
   if (push[i]) id_v_set[~push_id[(((i+1)*ID_WIDTH)-1) -: ID_WIDTH]] = 1'b1;
  end

end // set_vector_block

// clear corresponding bit of id_v_set if pop asserted
// This vector is AND'ed with id_v_q, so clear the index identified by pop_id_n to clear the bit in id_v_q

always_comb begin : clr_vector_block

  id_v_clr = {NUM_IDS{1'b1}};

  if (pop) id_v_clr[NUM_IDS - pop_id - 1] = 1'b0; 

end // clr_vector_block

`ifndef INTEL_SVA_OFF

  pop_avail_check: assert property ( @(posedge clk) disable iff (rst_n !== 1'b1) 
  pop |-> (id_v_q[NUM_IDS - pop_id - 1] == 1) ) else begin
   $display ("\nERROR: %m: pop_id (%d) refers to an id which is not available!!!\n",pop_id);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end // assert property

  genvar g;

  generate
   for (g=0; g<NUM_PUSHES; g=g+1) begin: g_chk

    push_avail_check: assert property ( @(posedge clk) disable iff (rst_n !== 1'b1) 
    push[g] |-> (id_v_q[~push_id[(((g+1)*ID_WIDTH)-1) -: ID_WIDTH]] == 0) ) else begin
     $display ("\nERROR: %m: push_id (%d) refers to an id which is already available!!!\n",
	push_id[(((g+1)*ID_WIDTH)-1) -: ID_WIDTH]);
     if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
    end // assert property

   end
  endgenerate

  initial begin
   check_width_param: assert ((NUM_IDS>=2) && (NUM_IDS<=1024) && ($countones(NUM_IDS)==1)) else begin
    $display ("\nERROR: %m: Parameter NUM_IDS had an illegal value (%d).  Valid values are (2**n >=2 and <=1024) !!!\n",NUM_IDS);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end
  end

`endif

endmodule // AW_id_freelist_bb_core

