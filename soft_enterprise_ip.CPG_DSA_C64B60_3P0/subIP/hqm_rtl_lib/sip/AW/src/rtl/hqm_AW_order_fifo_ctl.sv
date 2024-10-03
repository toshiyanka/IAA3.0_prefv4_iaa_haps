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
// AW_order_fifo_ctl
//
// This is a parametized FIFO controller for a DEPTH deep by DWIDTH wide ordering FIFO.
// It includes a reset capabilty to cancel any currently allocated locations, and a watermark input.
// The watermark value is subtracted from the fifo_rdepth output, effectively masking that many
// locations in the FIFO from being available to the client.  The watermark does not affect
// the overflow error checking, but does provide a new simulation assertion if the engine tries to
// allocate more rows than are available after the watermark is subtracted from the total.
//
// The controller is designed to be hooked up to a memory that is DEPTH deep.  The bypass register
// holds the last read data so the memory does not have to be accessed unless we are doing a pop and
// it is not empty. This is done for power saving reasons.
// The write interface can write any location in the memory, but locations are only read from
// consecutive locations in FIFO fashion.  A valid vector with a bit for each memory location is
// maintained to indicate which memory locations contain valid data.  The FIFO only looks non-empty
// (pop_data_v==1) when the memory location at the FIFO read pointer is valid.
//
// The following parameters are supported:
//
//	DEPTH			Depth of the external memory.
//	DWIDTH			Width of the FIFO and datapath.
//
// The fifo_status output is a 32b zero extended vector with the following definition:
//
//	[2*DEPTHWIDTH+3:DEPTHWIDTH+4] =	Unallocated FIFO depth.
//	[DEPTHWIDTH+3:4] =		Current FIFO depth.
//	[3] =				FIFO overflow  (sticky) Wrote already valid location
//	[2] =				FIFO overflow  (sticky) Allocated more than rdepth
//	[1] =				FIFO overflow  (sticky) rdepth+depth > DEPTH
//	[0] =				FIFO underflow (sticky)
//
// It is recommended that the entire set of fifo_status and mem_v information be accessible through
// the configuration interface as read-only status.  It is required that at least the overflow and
// underflow bits be made available.  The overflow and underflow bits from all FIFO controllers
// must also be "OR"ed together into a single fifo_error sticky interrupt status bit to indicate
// that any FIFO error occurred.
//
//-----------------------------------------------------------------------------------------------------
// 
module hqm_AW_order_fifo_ctl
       import hqm_AW_pkg::*; #(

	 parameter DEPTH	= 48
	,parameter DWIDTH	= 4

	,parameter AWIDTH	= (AW_logb2(DEPTH-1)+1)
	,parameter LWIDTH	= (AW_logb2(DEPTH)+1)
	,parameter VWIDTH	= (AW_logb2(DEPTH-1)+2)
	,parameter WMWIDTH	= (AW_logb2(DEPTH+1)+1)
) (
	 input	logic			clk
	,input	logic			rst_n

	,input	logic	[WMWIDTH-1:0]	cfg_wm

	,input	logic			alloc
	,input	logic	[LWIDTH-1:0]	alloc_rows

	,input	logic			cancel

	,input	logic			write
	,input	logic	[AWIDTH-1:0]	write_addr
	,input	logic	[DWIDTH-1:0]	write_data

	,input	logic			pop
	,output	logic			pop_data_v
	,output	logic	[DWIDTH-1:0]	pop_data

	,output	logic			mem_enable

	,output	logic			mem_wr_v
	,output	logic	[AWIDTH-1:0]	mem_wr_addr
	,output	logic	[DWIDTH-1:0]	mem_wr_data

	,output	logic			mem_rd_v
	,output	logic	[AWIDTH-1:0]	mem_rd_addr
	,input	logic	[DWIDTH-1:0]	mem_rd_data

	,output	logic	[DEPTH-1:0]	mem_v

	,output	logic	[AWIDTH-1:0]	fifo_rptr
	,output	logic	[LWIDTH-1:0]	fifo_vdepth
	,output	logic	[LWIDTH-1:0]	fifo_rdepth

	,output	logic	[31:0]		fifo_status
);


//--------------------------------------------------------------------------------------------

logic				fifo_rp_v;

logic				wa_eq_rp;

logic				mem_write;

logic				mem_read;
logic				mem_read_q;

logic	[AWIDTH-1:0]		mem_addr_q;

logic	[DEPTH-1:0]		mem_v_next;
logic	[DEPTH-1:0]		mem_v_next_rot;
logic	[DEPTH-1:0]		mem_v_next_rev;		
logic	[DEPTH-1:0]		mem_v_q;

logic	[AWIDTH-1:0]		fifo_rptr_q;
logic	[AWIDTH-1:0]		fifo_rptr_next;
logic	[AWIDTH-1:0]		fifo_rptr_p1;

logic	[LWIDTH-1:0]		fifo_depth_q;
logic	[LWIDTH-1:0]		fifo_depth_next;
logic	[LWIDTH-1:0]		fifo_rdepth_q;
logic	[LWIDTH-1:0]		fifo_rdepth_next;
logic	[LWIDTH-1:0]		fifo_vdepth_q;
logic	[VWIDTH-1:0]		fifo_vdepth_next;	

logic				fifo_bp_v_q;
logic				fifo_bp_v_next;

logic	[AWIDTH-1:0]		fifo_bp_addr_next;
logic	[AWIDTH-1:0]		fifo_bp_addr_q;

logic	[DWIDTH-1:0]		fifo_bp_data_next;
logic	[DWIDTH-1:0]		fifo_bp_data_q;

logic	[2:0]			fifo_overflow_q;
logic	[2:0]			fifo_overflow_next;

logic				fifo_underflow_q;
logic				fifo_underflow_next;

logic	[LWIDTH-1:0]		fifo_alloc_depth;
logic	[LWIDTH:0]		fifo_rptr_palloc;
logic	[LWIDTH:0]		fifo_rptr_mrdepth;	
logic	[AWIDTH-1:0]		fifo_rptr_skip;
logic	[LWIDTH-1:0]		fifo_rptr_scaled;
logic	[LWIDTH-1:0]		fifo_rdepth_minus_wm;

//--------------------------------------------------------------------------------------------

assign fifo_rp_v = mem_v_q[fifo_rptr_q];	// Memory is valid at RP location

assign mem_read = pop & fifo_rp_v;		// Only read mem on pop if valid RP in mem

assign wa_eq_rp = (write_addr == fifo_rptr_q);	// Need this for the bypass case

// We always do the memory write if the address isn't the current RP.
// Otherwise, we do the write only if we aren't popping current data from the memory or BP reg.

assign mem_write = write & (~wa_eq_rp | ((fifo_bp_v_q | mem_read_q) & ~pop));

//--------------------------------------------------------------------------------------------
// Vector for the valid bits (set on mem_write and reset on mem_read)

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  mem_v_q <= {DEPTH{1'b0}};
 end else begin
  mem_v_q <= mem_v_next & ~{DEPTH{cancel}};
 end
end

always_comb begin
 mem_v_next = mem_v_q;
 if (mem_write) mem_v_next[write_addr]  = 1'b1;
 if (mem_read)  mem_v_next[fifo_rptr_q] = 1'b0;
end

hqm_AW_rotate_bit #(.WIDTH(DEPTH), .LRN(0)) i_mem_v_next_rot (

	.din		(mem_v_next),
	.rot		(fifo_rptr_next),

	.dout		(mem_v_next_rot)
);

hqm_AW_reverse_bits #(.WIDTH(DEPTH)) i_mem_v_next_rev (

	.a		(mem_v_next_rot),
	.e		(1'b1),

	.z		(mem_v_next_rev)
);

logic [(DEPTH)-1:0] dec_nc ;
hqm_AW_leading_ones #(.WIDTH(DEPTH)) i_fifo_vdepth_next (

	.a		({(fifo_bp_v_next | mem_read) , mem_v_next_rev[DEPTH-1:1]}),

	.dec		(dec_nc), 
	.enc		(fifo_vdepth_next)	
);

//--------------------------------------------------------------------------------------------
// The RP only gets incremented when we consume an address, either by reading it out of the
// memory or bypassing it directly to the BP reg.

assign fifo_rptr_p1 = ({{32-AWIDTH{1'b0}},fifo_rptr_q} == (DEPTH-1)) ? {AWIDTH{1'b0}} :
			(fifo_rptr_q + {{(AWIDTH-1){1'b0}},1'b1});

assign fifo_rptr_next = (mem_read | (write & ~mem_write)) ? fifo_rptr_p1 : fifo_rptr_q;

always_comb begin
 case ({write,pop})
  2'b01:   fifo_depth_next = fifo_depth_q - {{(LWIDTH-1){1'b0}},1'b1};
  2'b10:   fifo_depth_next = fifo_depth_q + {{(LWIDTH-1){1'b0}},1'b1};
  default: fifo_depth_next = fifo_depth_q;
 endcase
end

assign fifo_rdepth_next = fifo_rdepth_q - (alloc_rows & {LWIDTH{alloc}}) + {{(LWIDTH-1){1'b0}},pop};

//--------------------------------------------------------------------------------------------
// The BP reg is valid if the write didn't go to the memory (went to BP), or we are not popping
// current data from the memory or the BP reg.

assign fifo_bp_v_next = (write & ~mem_write) | ((fifo_bp_v_q | mem_read_q) & ~pop);

// If we aren't popping current data from a valid memory read, the BP gets it.

assign fifo_bp_data_next = (mem_read_q & ~pop) ? mem_rd_data : write_data;
assign fifo_bp_addr_next = (mem_read_q & ~pop) ? mem_addr_q  : write_addr;

//--------------------------------------------------------------------------------------------
// Overflow  is indicated if we try to write an already valid location.
// Underflow is indicated if we try to pop when the data isn't yet valid.

assign fifo_overflow_next  =  {(write & (mem_v_q[write_addr] |
				(mem_read_q  & (write_addr == mem_addr_q)) |
				(fifo_bp_v_q & (write_addr == fifo_bp_addr_q)))),
			     (alloc & (alloc_rows > fifo_rdepth_q)),
	     ({{(32-LWIDTH){1'b0}}, fifo_depth_q} > (DEPTH - {{(32-LWIDTH){1'b0}}, fifo_rdepth_q}))};

assign fifo_underflow_next =  (pop & ~pop_data_v);

//--------------------------------------------------------------------------------------------
// Regs

// For the pointer skip function on a cancel, the new rptr is rptr+(DEPTH-rdepth) mod DEPTH
// rptr' = ((rptr+DEPTH-rdepth) < DEPTH) ? rptr+DEPTH-rdepth : rptr+DEPTH-rdepth-DEPTH
// rptr' = ((rptr+DEPTH-rdepth) < DEPTH) ? rptr+DEPTH-rdepth : rptr-rdepth

hqm_AW_width_scale #(.A_WIDTH(AWIDTH), .Z_WIDTH(LWIDTH)) i_fifo_rptr_scaled (
	.a	(fifo_rptr_q),
	.z	(fifo_rptr_scaled)
);

assign fifo_alloc_depth  = DEPTH[LWIDTH-1:0] - fifo_rdepth_q;

assign fifo_rptr_palloc  = {1'b0,fifo_rptr_scaled} + {1'b0,fifo_alloc_depth};
assign fifo_rptr_mrdepth = {1'b0,fifo_rptr_scaled} - {1'b0,fifo_rdepth_q};	

assign fifo_rptr_skip    = ({{(32-LWIDTH-1){1'b0}},fifo_rptr_palloc} < DEPTH) ?
				fifo_rptr_palloc[AWIDTH-1:0] : fifo_rptr_mrdepth[AWIDTH-1:0];

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  mem_read_q       <= 1'b0;
  fifo_bp_v_q      <= 1'b0;
  fifo_rptr_q      <= {AWIDTH{1'b0}};
  fifo_depth_q     <= {LWIDTH{1'b0}};
  fifo_vdepth_q    <= {LWIDTH{1'b0}};
  fifo_rdepth_q    <= DEPTH;
  fifo_overflow_q  <= 3'd0;
  fifo_underflow_q <= 1'b0;
 end else if (cancel) begin
  mem_read_q       <= 1'b0;
  fifo_bp_v_q      <= 1'b0;
  fifo_rptr_q      <= fifo_rptr_skip;
  fifo_depth_q     <= {LWIDTH{1'b0}};
  fifo_vdepth_q    <= {LWIDTH{1'b0}};
  fifo_rdepth_q    <= DEPTH;
  fifo_overflow_q  <= 3'd0;
  fifo_underflow_q <= 1'b0;
 end else begin
  mem_read_q       <= mem_read;
  fifo_bp_v_q      <= fifo_bp_v_next;
  fifo_rptr_q      <= fifo_rptr_next;
  fifo_depth_q     <= fifo_depth_next;
  fifo_vdepth_q    <= fifo_vdepth_next[LWIDTH-1:0];
  fifo_rdepth_q    <= fifo_rdepth_next;
  fifo_overflow_q  <= fifo_overflow_next;
  fifo_underflow_q <= fifo_underflow_next;
 end
end

always_ff @(posedge clk ) begin
 if ((write & ~mem_write) | (mem_read_q & ~pop)) begin
  fifo_bp_data_q <= fifo_bp_data_next;
  fifo_bp_addr_q <= fifo_bp_addr_next;
 end
 mem_addr_q <= fifo_rptr_q;
end

//--------------------------------------------------------------------------------------------
// Interface to the actual memory
//--------------------------------------------------------------------------------------------

assign mem_wr_v    = mem_write;
assign mem_wr_addr = write_addr;
assign mem_wr_data = write_data;

assign mem_rd_v    = mem_read;
assign mem_rd_addr = fifo_rptr_q;

assign mem_enable  = mem_write | mem_read;

assign mem_v = mem_v_q;

//--------------------------------------------------------------------------------------------
// Drive the outputs
//--------------------------------------------------------------------------------------------

assign pop_data_v = (fifo_bp_v_q | mem_read_q) & ~(|{fifo_overflow_q, fifo_underflow_q});
assign pop_data   = (fifo_bp_v_q) ? fifo_bp_data_q : mem_rd_data;


assign fifo_rdepth_minus_wm = (cfg_wm > fifo_rdepth_q) ? {LWIDTH{1'b0}} : (fifo_rdepth_q - cfg_wm);


assign fifo_rptr   = fifo_rptr_q;
assign fifo_rdepth = (|{fifo_overflow_q, fifo_underflow_q}) ? {LWIDTH{1'b0}} : fifo_rdepth_minus_wm;
assign fifo_vdepth = (|{fifo_overflow_q, fifo_underflow_q}) ? {LWIDTH{1'b0}} : fifo_vdepth_q;

hqm_AW_width_scale #(.A_WIDTH((2*LWIDTH)+4), .Z_WIDTH(32)) i_fifo_status (

	.a	({fifo_rdepth_q
		 ,fifo_depth_q
		 ,fifo_overflow_q
		 ,fifo_underflow_q}),

	.z	(fifo_status)
);

//--------------------------------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  logic write_q;

  always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
    write_q <= 1'b0;
   end else begin
    write_q <= write;
   end
  end

  check_alloc_overflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(alloc && (alloc_rows > fifo_rdepth_q))) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected (allocating more rows than available) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  warn_alloc_overflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(alloc && (alloc_rows > fifo_rdepth_minus_wm))) else begin
   $display ("\nWARNING: %t: %m: Tried to allocate more rows than watermark allows !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_write_overflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(write && mem_v_q[write_addr])) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected (writing already valid location) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_write_overflow2: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(write && mem_read_q && (write_addr == mem_addr_q))) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected (writing same location just read) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_write_overflow3: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(write && fifo_bp_v_q && (write_addr == fifo_bp_addr_q))) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected (writing same location currently in BP reg) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_overflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(write_q & ({{(32-LWIDTH){1'b0}}, fifo_depth_q} > (DEPTH - fifo_rdepth_q)))) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected (wrote more locations than allocated) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_underflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(pop && !pop_data_v)) else begin
   $display ("\nERROR: %t: %m: FIFO underflow detected (pop while not valid) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_alloc_rows_unknown: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(alloc && $isunknown(alloc_rows))) else begin
   $display ("\nWARNING: %t: %m: Allocation rows contains 'x' or 'z' values !!!\n",$time);
   if ($test$plusargs("AW_STOP_ON_WARNING")) $stop;
  end

  check_write_addr_unknown: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(write && $isunknown(write_addr))) else begin
   $display ("\nWARNING: %t: %m: Write address contains 'x' or 'z' values !!!\n",$time);
   if ($test$plusargs("AW_STOP_ON_WARNING")) $stop;
  end

  check_write_data_unknown: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(write && $isunknown(write_data))) else begin
   $display ("\nWARNING: %t: %m: Write data contains 'x' or 'z' values !!!\n",$time);
   if ($test$plusargs("AW_STOP_ON_WARNING")) $stop;
  end

`endif

//--------------------------------------------------------------------------------------------
// Coverage

`ifdef HQM_COVER_ON

 covergroup AW_order_fifo_ctl_CG @(posedge clk);

  AW_order_fifo_ctl_CP_alloc: coverpoint alloc iff (rst_n === 1'b1) {
	bins		NO_ALLOC	= {0};
	bins		ALLOC		= {1};
  }

  AW_order_fifo_ctl_CP_write: coverpoint write iff (rst_n === 1'b1) {
	bins		NO_WRITE	= {0};
	bins		WRITE		= {1};
  }

  AW_order_fifo_ctl_CP_pop: coverpoint pop iff (rst_n === 1'b1) {
	bins		NO_POP		= {0};
	bins		POP		= {1};
  }

  AW_order_fifo_ctl_CX_ops: cross AW_order_fifo_ctl_CP_alloc, AW_order_fifo_ctl_CP_write, AW_order_fifo_ctl_CP_pop;

 endgroup

 AW_order_fifo_ctl_CG AW_order_fifo_ctl_CG_inst = new();

`endif

endmodule // AW_order_fifo_ctl
// 
