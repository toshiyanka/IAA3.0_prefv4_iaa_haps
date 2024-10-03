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
// AW_id_freelist
//
//wiki(Overview)
// This module provides logic to manage a freelist of ID values. It supports IDs from 0 to NUM_IDS-1
// where NUM_IDS is a power of 2.
// All IDs are initially available. This module selects an available ID and returns the ID number using
// the pop_id and pop_id_v outputs. The user of this module can "pop" an ID from the available list and
// "push" an ID to the available list. The id_vector output has a bit for each ID, with a 0 for not
// available and a 1 for available. id_vector[i] corresponds to ID "i".
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
module hqm_AW_id_freelist
       import hqm_AW_pkg::*; #(

	 parameter NUM_IDS	= 16
	,parameter NUM_PUSHES	= 1

	,parameter ID_WIDTH	= (AW_logb2(NUM_IDS-1)+1)
) (
	// System Control Interface

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


localparam NUM_BLKS = NUM_IDS<=16 ? 1 : (NUM_IDS >> 4);
localparam BWIDTH   = AW_logb2(NUM_BLKS-1)+1;

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_num_ids_param: assert ((NUM_IDS>1) && (NUM_IDS<=2048) && ($countones(NUM_IDS)==1)) else begin
    $display ("\nERROR: %m: Parameter NUM_IDS had an illegal value (%d).  Valid values are (2**n >=2 and <=1024) !!!\n",NUM_IDS);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

genvar		d,g,p;

generate
 if (NUM_IDS <= 16) begin: g_lt16ids

   hqm_AW_id_freelist_bb #(.NUM_IDS(NUM_IDS), .NUM_PUSHES(NUM_PUSHES)) i_id_freelist_bb (

	.clk		(clk),
	.rst_n		(rst_n),

	.pop		(pop),
	.pop_id_v	(pop_id_v),
	.pop_id		(pop_id),

	.push		(push),
	.push_id	(push_id),

	.id_vector	(id_vector)
   );

 end else begin: g_ge16ids

  // For implementations of >16 IDs, break the blocks into 16b chunks to
  // limit the size of the leading zeros detection that needs to be done.

  logic	[NUM_BLKS-1:0]		pop_decode;
  logic	[NUM_BLKS-1:0]		push_decode[NUM_PUSHES-1:0];
  logic	[NUM_PUSHES-1:0]	push_decode_vec[NUM_BLKS-1:0];
  logic	[(NUM_PUSHES*4)-1:0]	push_id_ls;

  logic	[NUM_BLKS-1:0]		pop_id_valid;
  logic	[(4*NUM_BLKS)-1:0]	pop_id_value;

  logic	[BWIDTH-1:0]		pop_id_ms;
  logic	[3:0]			pop_id_ls;

  for (g=0; g<NUM_BLKS; g=g+1) begin: g_blk

   hqm_AW_id_freelist_bb #(.NUM_IDS(16), .NUM_PUSHES(NUM_PUSHES)) i_id_freelist_bb (

	.clk		(clk),
	.rst_n		(rst_n),

	.pop		(pop_decode[g]),
	.pop_id_v	(pop_id_valid[g]),
	.pop_id		(pop_id_value[(((g+1)*4)-1) -: 4]),

	.push		(push_decode_vec[g]),
	.push_id	(push_id_ls),

	.id_vector	(id_vector[(((g+1)*16)-1) -: 16])
   );

   for (d=0; d<NUM_PUSHES; d=d+1) begin: d_l

    assign push_decode_vec[g][d -: 1] = push_decode[d][g -: 1];

   end

  end

  hqm_AW_binenc #(.WIDTH(NUM_BLKS)) i_pop_id_ms (

	.a		(pop_id_valid),

	.enc		(pop_id_ms),
	.any		(pop_id_v)
  );

  hqm_AW_mux #(.WIDTH(4), .NINPUTS(NUM_BLKS)) i_pop_id_ls (

	.d		(pop_id_value),
	.s		(pop_id_ms),

	.z		(pop_id_ls)
  );

  hqm_AW_bindec #(.WIDTH(BWIDTH)) i_pop_decode (

	.a		(pop_id_ms),
	.enable		(pop),

	.dec		(pop_decode)
  );

  for (p=0; p<NUM_PUSHES; p=p+1) begin: p_dec

   hqm_AW_bindec #(.WIDTH(BWIDTH)) i_push_decode (

	.a		(push_id[(((p+1)*ID_WIDTH)-1) -: (ID_WIDTH-4)]),
	.enable		(push[p]),

	.dec		(push_decode[p])
   );

   assign push_id_ls[(((p+1)*4)-1) -: 4] = push_id[((p*ID_WIDTH)+3) -: 4];

  end

  assign pop_id = {pop_id_ms, pop_id_ls};

 end
endgenerate

endmodule // AW_id_freelist

