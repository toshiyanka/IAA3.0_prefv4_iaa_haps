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
// AW_32b_atomic_access
//
// This module is responsible for providing a 32-bit R/W interface to a wider than 32-bit structure.
// It will accumulate writes in an internal register and will write an entire row of the structure at
// once whenever a write to the LS word of the structure is received.  It maintains a one-deep read
// data cache that is loaded whenever the MS word of the structure is read.  Subsequent reads to other
// words of the same structure row will not cause a structure read and the read data will be returned
// from the cached data.
//
// The LEVEL parameter controls whether the src_read/write and dest_read/write signals behave as
// a pulse or level type interface.  If LEVEL==0, the src_read/write inputs are expected to be a
// single pulse that is valid for just one clock cycle.  If LEVEL==1, the src_read/write signals
// are expected to assert and remain asserted until the clock after the src_ack signal is seen.
// In either case, the dst_ack is expected to come back at least one clock after the dst_read/write
// is asserted (ie. the ack cannot be combinatorially returned on the same clock as the request).
//
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
//   addr[(N*2)]   = pseudo_row[N].[63:32] = struct_row[N].[32]    (word N*2) w/ [31:1] zeroed
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
//      DEPTH           The depth of the structure.
//      WIDTH           The width of the structure.
//	LEVEL		Determines whether pulse or level behavior is expected on src signals (0: pulse 1: level).
//	LEVEL_OUT	Determines whether the dst signals are pulses or levels (0: pulse 1: level).
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_32b_atomic_access
       import hqm_AW_pkg::*; #(

	 parameter DEPTH		= 1		// Depth of structure and pseudo structure
	,parameter WIDTH		= 33		// Width of structure
	,parameter LEVEL		= 0
	,parameter LEVEL_OUT		= 0

	// The following params should not be changed in instantiation
	//
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
    $display ("\nERROR: %m: Parameter WIDTH value had an illegal value (%d).  Valid values are 33-1024 !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_depth_param: assert (DEPTH > 0) else begin
    $display ("\nERROR: %m: Parameter DEPTH value had an illegal value (%d).  Valid values are >0 !!!\n",DEPTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_level_parm: assert (!((LEVEL == 1) && (LEVEL_OUT==1))) else begin
    $display ("\nERROR: %m: Parameter LEVEL_OUT should only be set to 1 if LEVEL==0 !!!\n",DEPTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

logic					sread;
logic					swrite;

logic	[(WORDS_PER_WIDTH*32)-1:32]	src_wdata_next;		// Accumulated write data
logic	[WIDTH-1:32]			src_wdata_q;
logic	[(WORDS_PER_WIDTH*32)-1:32]	src_wdata_q_scaled;

logic	[A_WIDTH-1:0]			rdata_sel;		// Read data word select

logic					first_word;		// Address is first word
logic					last_word;		// Address is last  word
logic					zero_word;		// Address is outside physical structure

logic					tag_v_next;		// One-deep read cache tag
logic					tag_v_q;
logic	[DA_WIDTH-1:0]			tag_q;

logic					cache_hit;		// Read hit in cache

logic					int_read_next;		// One-deep cache read
logic					int_read_q;

logic					int_write_next;		// Internal reg write
logic					int_write_q;

logic	[(WORDS_PER_WIDTH*32)-33:0]	dst_rdata_q;		// One-deep read cache
logic	[WIDTH-1:0]			dst_rdata_in;		// Structure or cache read data
logic	[ROW_WIDTH-1:0]			dst_rdata_scaled;	// Read data scaled to pseudo structure width

logic	[31:0]				dst_rdata_word[WORDS_PER_ROW-1:0];	// Read data words

logic					dst_read_next;
logic					dst_write_next;
logic	[DA_WIDTH-1:0]			dst_addr_next;
logic	[WIDTH-1:0]			dst_wdata_next;

genvar					g;

//-----------------------------------------------------------------------------------------------------
// Accumulate the write data and save the LS read address to mux the return data.

generate

 if (LEVEL==1) begin: g_level_in

  assign sread  = src_read  & ~int_read_q;
  assign swrite = src_write & ~int_write_q;

  assign rdata_sel = src_addr[(A_WIDTH-1):0];

 end else begin : g_pulse_in

  assign sread  = src_read;
  assign swrite = src_write;

  logic	[A_WIDTH-1:0]	rdata_sel_q;

  always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
    rdata_sel_q <= {A_WIDTH{1'b0}};
   end else begin
    if (src_read) rdata_sel_q <= src_addr[(A_WIDTH-1):0];
   end
  end

  assign rdata_sel = rdata_sel_q;

 end

 if ((WORDS_PER_WIDTH*32) != WIDTH) begin: g_unused

  hqm_AW_unused_bits #(.WIDTH((WORDS_PER_WIDTH*32)-WIDTH)) i_src_wdata_next_unused (

	.a	(src_wdata_next[(WORDS_PER_WIDTH*32)-1:WIDTH])
  );

 end

endgenerate

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  src_wdata_q <= {(WIDTH-32){1'b0}};
 end else begin
  src_wdata_q <= src_wdata_next[WIDTH-1:32];
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

  src_wdata_next[(((WORDS_PER_ROW-i)*32)-1) -: 32] =
   (swrite & ({{(32-A_WIDTH){1'b0}},src_addr[(A_WIDTH-1):0]} == i)) ?
    src_wdata : src_wdata_q_scaled[(((WORDS_PER_ROW-i)*32)-1) -: 32];

 end

end

assign first_word = (src_addr[A_WIDTH-1:0] == LS_WORD[A_WIDTH-1:0]);
assign zero_word  = (src_addr[A_WIDTH-1:0] <  LS_WORD[A_WIDTH-1:0]);

//-----------------------------------------------------------------------------------------------------
// One-deep read data cache tag logic

assign tag_v_next = (sread & first_word) | (tag_v_q & ~src_abort & ~swrite & (~dst_read_next | cache_hit));

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  tag_v_q <= 1'b0;
  tag_q   <= {DA_WIDTH{1'b0}};
 end else begin
  tag_v_q <= tag_v_next;
  if (sread & first_word) tag_q <= dst_addr;
 end
end

assign cache_hit = sread & ~first_word & tag_v_q & (dst_addr_next == tag_q);

//-----------------------------------------------------------------------------------------------------
// Send out the structure access if required

assign dst_abort = src_abort;					// Pass the abort to the destination

// A structure read only occurs when we don't have a cache hit

assign dst_read_next = sread & ~(cache_hit | zero_word);

// The write data is the concatenation of the accumulated data reg and the current source write data.

assign dst_wdata_next = {src_wdata_q, src_wdata};

// The structure write only occurs on a write to the word that is the MS word of the structure (note
// that this may not be the MS word of the pseudo structure) based on the LS bits of the address.

assign last_word = &{1'b1, src_addr[A_WIDTH-1:0]};

assign dst_write_next = swrite & last_word;

generate

 if (DEPTH == 1) begin: g_deptheq1

  assign dst_addr_next = 1'b0;

 end else begin: g_depthgt1

  assign dst_addr_next = src_addr[SA_WIDTH-1:A_WIDTH];		// The dest addr is the MS source addr

 end

 if (LEVEL_OUT==1) begin: g_level_out

  logic				dst_write_q;
  logic				dst_read_q;
  logic	[DA_WIDTH-1:0]		dst_addr_q;
  logic	[31:0]			dst_wdata_q;

  always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
    dst_read_q  <= 1'b0;
    dst_write_q <= 1'b0;
   end else begin
    dst_read_q  <= (dst_read_next  | dst_read_q ) & ~dst_ack & ~dst_abort;
    dst_write_q <= (dst_write_next | dst_write_q) & ~dst_ack & ~dst_abort;
   end
  end

  always_ff @(posedge clk) begin
   if (dst_read_next | dst_write_next) dst_addr_q <= dst_addr_next;
   if (dst_write_next) dst_wdata_q <= dst_wdata_next[31:0];
  end

  assign dst_read  = dst_read_next  | dst_read_q;
  assign dst_write = dst_write_next | dst_write_q;
  assign dst_addr  = (dst_read_next | dst_write_next) ? dst_addr_next : dst_addr_q;
  assign dst_wdata = (dst_write_next) ? dst_wdata_next : {src_wdata_q, dst_wdata_q};

 end else begin: g_pulse_out

  assign dst_read  = dst_read_next;
  assign dst_write = dst_write_next;
  assign dst_addr  = dst_addr_next;
  assign dst_wdata = dst_wdata_next;

 end

endgenerate

//-----------------------------------------------------------------------------------------------------
// Internal (non-structure) reads and writes

assign int_read_next  = sread & (cache_hit | zero_word);
assign int_write_next = swrite & ~last_word;

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
// Receive the structure response or use the cache response

// If this response needs to be cached, save it

always_ff @(posedge clk) if (dst_ack & tag_v_q) dst_rdata_q <= dst_rdata[(WORDS_PER_WIDTH*32)-33:0];

assign dst_rdata_in = { dst_rdata[WIDTH-1:((WORDS_PER_WIDTH-1)*32)],
			((tag_v_q) ? dst_rdata_q : dst_rdata[(((WORDS_PER_WIDTH-1)*32)-1):0]) };

// Scale the read data return to the width of the pseudo structure

hqm_AW_width_scale #(.A_WIDTH(WIDTH), .Z_WIDTH(ROW_WIDTH)) i_dst_rdata_scaled (

	.a	(dst_rdata_in),
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
assign src_rdata = dst_rdata_word[rdata_sel];

endmodule // AW_32b_atomic_access

