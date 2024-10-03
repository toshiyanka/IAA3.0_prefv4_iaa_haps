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
// AW_32b_access_scale
//
// This module is responsible for providing a 32-bit R/W interface to a wider than 32-bit structure.
// It will accumulate writes in an internal register and will write an entire row of the structure at
// once whenever a write to the MS word of the structure is received.  It will mux the correct word
// of the structure row read data based on the source address for reads.
// The wide structure is assumed to be mapped into an address space where each row of the structure
// fits completely into a row of a big-endian word pseudo structure that is on a power of 2 boundary,
// with any MS bits that are not part of the physical structure padded out with 0s to fill the power
// of 2 boundary row.  The input address is a word (32-bit) address and the output address is a
// structure row address.
//
// For example:
//
// An Nx33 structure would need to be mapped into an Nx64 pseudo structure in an (N*2)x32 address map:
//
// foreach N in DEPTH psuedo_row[N].[63:0] = { 31'd0, struct_row[N].[32:0] }
//
//   addr[0]       = pseudo_row[0].[63:32] = struct_row[0].[32]    (word 0) w/ [31:1] zeroed
//   addr[1]       = pseudo_row[0].[31: 0] = struct_row[0].[31:0]  (word 1)
//   addr[2]       = pseudo_row[1].[63:32] = struct_row[1].[32]    (word 2) w/ [31:1] zeroed
//   addr[3]       = pseudo_row[1].[31: 0] = struct_row[1].[31:0]  (word 3)
//   ...
//   addr[(N*2)]   = pseudo_row[N].[63:32] = struct_row[N].[32]	   (word N*2) w/ [31:1] zeroed
//   addr[(N*2)+1] = pseudo_row[N].[31: 0] = struct_row[N].[31:0]  (word N*2+1)
//
// An Nx93 structure would need to be mapped into an Nx128 pseudo structure in an (N*4)x32 address map:
//
// foreach N in DEPTH psuedo_row[N].[127:0] = { 35'd0, struct_row[N].[92:0] }
//
//   addr[0]       = pseudo_row[0].[127:96] = Not Defined           (word 0) w/ [31: 0] zeroed
//   addr[1]       = pseudo_row[0].[ 95:64] = struct_row[0].[92:64] (word 1) w/ [31:28] zeroed
//   addr[2]       = pseudo_row[0].[ 63:32] = struct_row[0].[63:32] (word 2)
//   addr[3]       = pseudo_row[0].[ 31: 0] = struct_row[0].[31: 0] (word 3)
//   addr[4]       = pseudo_row[1].[127:96] = Not Defined           (word 4) w/ [31: 0] zeroed
//   addr[5]       = pseudo_row[1].[ 95:64] = struct_row[1].[92:64] (word 5) w/ [31:28] zeroed
//   addr[6]       = pseudo_row[1].[ 63:32] = struct_row[1].[63:32] (word 6)
//   addr[7]       = pseudo_row[1].[ 31: 0] = struct_row[1].[31:0]  (word 7)
//   ...
//   addr[(N*4)]   = pseudo_row[N].[127:96] = Not Defined           (word N*4)   w/ [31: 0] zeroed
//   addr[(N*4)+1] = pseudo_row[N].[ 95:64] = struct_row[N].[92:64] (word N*4+1) w/ [31:28] zeroed
//   addr[(N*4)+2] = pseudo_row[N].[ 63:32] = struct_row[N].[63:32] (word N*4+2)
//   addr[(N*4)+3] = pseudo_row[N].[ 31: 0] = struct_row[N].[31: 0] (word N*4+3)
//
// The following parameters are supported:
//
//	DEPTH		The depth of the structure.
//	WIDTH		The width of the structure.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_32b_access_scale
       import hqm_AW_pkg::*; #(

	 parameter DEPTH		= 2			// Depth of structure and pseudo structure
	,parameter WIDTH		= 33			// Width of structure

	// The following params should not be changed in instantiation

	,parameter WORDS_PER_WIDTH	= ((WIDTH+31)>>5)	// Ceiling of # 32b words in a structure row
	,parameter WORDS_PER_ROW	= ((WORDS_PER_WIDTH > 16) ? 32 :	// # 32b words in a pseudo 
					  ((WORDS_PER_WIDTH >  8) ? 16 :	// structure row
					  ((WORDS_PER_WIDTH >  4) ?  8 :
					  ((WORDS_PER_WIDTH >  2) ?  4 :
					    WORDS_PER_WIDTH))))
	,parameter TOTAL_WORDS		= (WORDS_PER_ROW * DEPTH)		// Total pseudo structure words
	,parameter SA_WIDTH		= (AW_logb2(TOTAL_WORDS-1)+1)		// Pseudo structure addr width
	,parameter DA_WIDTH		= (AW_logb2(DEPTH-1)+1)			// Structure addr width
) (
	 input	logic			clk
	,input	logic			rst_n

	,input	logic			src_write
	,input	logic			src_read
	,input	logic			src_abort
	,input	logic	[SA_WIDTH-1:0]	src_addr
	,input	logic	[31:0]		src_wdata

	,output	logic			src_ack
	,output	logic			src_error
	,output	logic	[31:0]		src_rdata

	,output	logic			dst_write
	,output	logic			dst_read
	,output	logic			dst_abort
	,output	logic	[DA_WIDTH-1:0]	dst_addr
	,output	logic	[WIDTH-1:0]	dst_wdata

	,input	logic			dst_ack
	,input	logic			dst_error
	,input	logic	[WIDTH-1:0]	dst_rdata
);


//-----------------------------------------------------------------------------------------------------

localparam LS_WORD	= WORDS_PER_ROW - WORDS_PER_WIDTH;
localparam ROW_WIDTH	= WORDS_PER_ROW * 32;			// Width of pseudo structure
localparam A_WIDTH	= (SA_WIDTH==DA_WIDTH)?1:((DEPTH==1)?SA_WIDTH:(SA_WIDTH-DA_WIDTH));

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert ((WIDTH > 32) && (WIDTH < 1025)) else begin
    $display ("\nERROR: %m: Parameter WIDTH value had an illegal value (%d).  Valid values are 33-1024. !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_depth_param: assert (DEPTH > 1) else begin
    $display ("\nERROR: %m: Parameter DEPTH value had an illegal value (%d).  Valid values are >1. !!!\n",DEPTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

// spyglass disable_block W498 -- May not use all bits of src_wdata_next if WIDTH isn't modulo-32

logic	[(WORDS_PER_WIDTH*32)-1:32]	src_wdata_next;		// Accumulated write data

// spyglass  enable_block W498

logic	[WIDTH-1:32]			src_wdata_q;
logic	[(WORDS_PER_WIDTH*32)-1:32]	src_wdata_q_scaled;

logic	[A_WIDTH-1:0]			rdata_sel_q;		// Read data word select

logic					last_word;		// Address is last word
logic					zero_word;		// Address is outside physical structure

logic					int_read_next;		// Internal read
logic					int_read_q;

logic					int_write_next;		// Internal write
logic					int_write_q;

logic	[ROW_WIDTH-1:0]			dst_rdata_scaled;	// Read data scaled to pseudo structure width

logic	[31:0]				dst_rdata_word[WORDS_PER_ROW-1:0];	// Read data words

genvar					g;

//-----------------------------------------------------------------------------------------------------
// Accumulate the write data and save the LS read address to mux the return data.

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  src_wdata_q <= {(WIDTH-32){1'b0}};
  rdata_sel_q <= {A_WIDTH{1'b0}};
 end else begin
  src_wdata_q <= src_wdata_next[WIDTH-1:32];
  if (src_read) rdata_sel_q <= src_addr[(A_WIDTH-1):0];
 end
end

hqm_AW_width_scale #(.A_WIDTH(WIDTH-32), .Z_WIDTH((WORDS_PER_WIDTH-1)*32)) i_src_wdata_q_scaled (

	.a	(src_wdata_q),
	.z	(src_wdata_q_scaled)
);

always_comb begin: Write_Data_Next
 integer i;

 // Only update the write data word specified by the LS bits of the address.  The register does not
 // hold the MS word of the write data which is bypassed directly from the source to the destination.

 for (i=LS_WORD;i<(WORDS_PER_ROW-1);i=i+1) begin

  // spyglass disable_block W528 -- May not use all bits of src_wdata_next

  src_wdata_next[(((WORDS_PER_ROW-i)*32)-1) -: 32] =
   (src_write & ({{(32-A_WIDTH){1'b0}},src_addr[(A_WIDTH-1):0]} == i)) ?
    src_wdata : src_wdata_q_scaled[(((WORDS_PER_ROW-i)*32)-1) -: 32];

  // spyglass  enable_block W528
 end

end

assign zero_word = (src_addr[A_WIDTH-1:0] < LS_WORD[A_WIDTH-1:0]);

//-----------------------------------------------------------------------------------------------------
// Send out the structure access

assign dst_abort = src_abort;					// Pass the abort to the destination

generate
 if (DEPTH == 1) begin: g_deptheq1

  assign dst_addr  = 1'b0;

 end else begin: g_depthgt1

  assign dst_addr  = src_addr[SA_WIDTH-1:A_WIDTH];		// The dest addr is the MS source addr

 end
endgenerate

assign dst_read  = src_read & ~zero_word;			// Pass the read to the destination

// The write data is the concatenation of the accumulated data reg and the current source write data.

assign dst_wdata = {src_wdata_q, src_wdata};

// The structure write only occurs on a write to the word that is the MS word of the structure.

assign last_word = &{1'b1, src_addr[(A_WIDTH-1):0]};

assign dst_write = src_write & last_word;

//-----------------------------------------------------------------------------------------------------
// Internal reads & writes

assign int_read_next  = src_read  &  zero_word;
assign int_write_next = src_write & ~last_word;

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  int_read_q  <= 1'b0;
  int_write_q <= 1'b0;
 end else begin
  int_read_q  <= int_read_next;
  int_write_q <= int_write_next;
 end
end

//-----------------------------------------------------------------------------------------------------
// Receive the structure response

// Scale the structure read data return to the width of the pseudo structure

hqm_AW_width_scale #(.A_WIDTH(WIDTH), .Z_WIDTH(ROW_WIDTH)) i_dst_rdata_scaled (

	.a	(dst_rdata),
	.z	(dst_rdata_scaled)
);

// Break the pseudo structure return into individual words so it can be muxed easily.

generate
 for (g=0;g<WORDS_PER_ROW;g=g+1) begin: g_dw
  assign dst_rdata_word[g] = dst_rdata_scaled[(((WORDS_PER_ROW-g)*32)-1) -: 32];
 end
endgenerate

assign src_ack   = int_write_q | int_read_q | dst_ack;
assign src_error = ~(int_write_q | int_read_q) & dst_ack & dst_error;
assign src_rdata = dst_rdata_word[rdata_sel_q];

endmodule // AW_32b_access_scale

