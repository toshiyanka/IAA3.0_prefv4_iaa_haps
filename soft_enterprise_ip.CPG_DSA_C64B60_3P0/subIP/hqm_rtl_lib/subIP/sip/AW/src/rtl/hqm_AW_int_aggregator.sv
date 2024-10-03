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
// hqm_AW_int_aggregator
//
// This module is responsible for accepting a paramterized number of interrupts with associated data,
// latching the data in parallel, and serializing the interrupts into a string of single interrupt
// events that are FIFOed to be pulled one at a time by the higher level.
//
// The following parameters are supported:
//
//	NUM_INTS	Number of interrupts
//	NUM_WIDTH	Width of interrupt number fields
//	DATA_WIDTH	Width of interrupt syndrome fields
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_int_aggregator

       import hqm_AW_pkg::*;
#(

	 parameter NUM_INTS	= 16
	,parameter NUM_WIDTH	= 2
	,parameter DATA_WIDTH	= 8

	,parameter NWIDTH	= (NUM_INTS*NUM_WIDTH)
	,parameter DWIDTH	= (NUM_INTS*DATA_WIDTH)
	,parameter SRC_WIDTH	= (AW_logb2(NUM_INTS-1)+1)
) (
	 input	logic				clk
	,input	logic				rst_n

	,output	logic	[NUM_INTS-1:0]		int_ready_in

	,input	logic	[NUM_INTS-1:0]		int_v_in
	,input	logic	[NWIDTH-1:0]		int_num_in
	,input	logic	[DWIDTH-1:0]		int_data_in

	,input	logic				int_ready

	,output	logic				int_v
	,output	logic	[SRC_WIDTH-1:0]		int_src
	,output	logic	[NUM_WIDTH-1:0]		int_num
	,output	logic	[DATA_WIDTH-1:0]	int_data

	,output	logic	[31:0]			status
);

//-----------------------------------------------------------------------------------------------------

logic	[NUM_INTS-1:0]		dbi_ready;
logic	[NUM_INTS-1:0]		dbi_v;
logic	[NUM_WIDTH-1:0]		dbi_num[(1<<SRC_WIDTH)-1:0];
logic	[DATA_WIDTH-1:0]	dbi_data[(1<<SRC_WIDTH)-1:0];
logic	[6:0]			dbi_status[NUM_INTS-1:0];
logic	[6:0]			dbo_status;

logic	[NUM_INTS-1:0]		int_ss_mask;
logic	[NUM_INTS-1:0]		int_ss_masked;
logic	[NUM_INTS-1:0]		int_ss_next;
logic	[NUM_INTS-1:0]		int_ss_q;

logic				int_ss_any;
logic	[SRC_WIDTH-1:0]		int_ss_enc;
logic				int_ss_ready;

genvar				g;

//-----------------------------------------------------------------------------------------------------

generate
 for (g=0; g<(1<<SRC_WIDTH); g=g+1) begin: g_1
  if (g<NUM_INTS) begin: g_int

   hqm_AW_double_buffer #(.WIDTH(NUM_WIDTH + DATA_WIDTH)) i_dbi (

         .clk		(clk)
        ,.rst_n		(rst_n)

        ,.status	(dbi_status[g])

        ,.in_ready	(int_ready_in[g])

        ,.in_valid	(int_v_in[g])
        ,.in_data	({int_num_in[(g*NUM_WIDTH) +: NUM_WIDTH], int_data_in[(g*DATA_WIDTH) +: DATA_WIDTH]})

        ,.out_ready	(dbi_ready[g])

        ,.out_valid	(dbi_v[g])
        ,.out_data	({dbi_num[g], dbi_data[g]})
   );

  end else begin: g_noint

   assign dbi_num[g]  = {NUM_WIDTH{1'd0}};
   assign dbi_data[g] = {DATA_WIDTH{1'd0}};

   hqm_AW_unused_bits #(.WIDTH(1)) i_unused_dbi_x (.a(|{dbi_num[g], dbi_data[g]}));

  end
 end
endgenerate

assign dbi_ready = int_ss_mask;

assign int_ss_next = (|int_ss_masked) ? int_ss_masked : (dbi_v & ~int_ss_mask);

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  int_ss_q <= {NUM_INTS{1'd0}};
 end else begin
  int_ss_q <= int_ss_next;
 end
end

assign int_ss_masked = int_ss_q & ~int_ss_mask;

hqm_AW_binenc #(.WIDTH(NUM_INTS)) i_AW_binenc (

	 .a		(int_ss_q)
	,.enc		(int_ss_enc)
	,.any		(int_ss_any)
);

assign int_ss_mask = {{(NUM_INTS-1){1'd0}},(int_ss_any & int_ss_ready)} << int_ss_enc;

hqm_AW_double_buffer #(.WIDTH(SRC_WIDTH + NUM_WIDTH + DATA_WIDTH)) i_dbo (

         .clk		(clk)
        ,.rst_n		(rst_n)

        ,.status	(dbo_status)

        ,.in_ready	(int_ss_ready)

        ,.in_valid	(int_ss_any)
        ,.in_data	({int_ss_enc, dbi_num[int_ss_enc], dbi_data[int_ss_enc]})

        ,.out_ready	(int_ready)

        ,.out_valid	(int_v)
        ,.out_data	({int_src, int_num, int_data})
);

hqm_AW_unused_bits #(.WIDTH(1)) i_unused_dbo_status (.a(|dbo_status[6:2]));

assign status[31:30] = dbo_status[1:0];

generate
 for (g=0; g<15; g=g+1) begin: g_2
  if (g<NUM_INTS) begin: g_ip

   hqm_AW_unused_bits #(.WIDTH(1)) i_unused_dbi_status (.a(|dbi_status[g][2 +: 5]));
   assign status[(g*2) +: 2] = dbi_status[g][0 +: 2];

  end else begin: g_np

   assign status[(g*2) +: 2] = 2'd0;

  end
 end
endgenerate

endmodule // hqm_AW_int_aggregator

