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
// AW_order_fifo_ctl_wreg
//
// This is just a wrapper around the AW_order_fifo_ctl block that adds a register to the output of the
// FIFO to take the memory read time out of the pop_data output path.  See the AW_order_fifo_ctl block
// for functional details.  Note that pop_data_v_q (and not pop_data_v) is now the indication that
// the ordering FIFO output is valid (pop_data_q is valid).
//
// The following parameters are supported:
//
//	DEPTH			Depth of the external memory.
//	DWIDTH			Width of the FIFO and datapath.
//
// The fifo_status output is a 32b zero extended vector with the following definition:
//
//	[2*DEPTHWIDTH+4] =		pop_data_v_q
//      [2*DEPTHWIDTH+3:DEPTHWIDTH+4] =	Unallocated FIFO depth.
//      [DEPTHWIDTH+3:4] =		Current FIFO depth.
//      [3] =				FIFO overflow  (sticky) Wrote already valid location
//      [2] =				FIFO overflow  (sticky) Allocated more than rdepth
//      [1] =				FIFO overflow  (sticky) rdepth+depth > DEPTH
//      [0] =				FIFO underflow (sticky)
//
// It is recommended that the entire set of fifo_status and mem_v information be accessible through
// the configuration interface as read-only status.  It is required that at least the overflow and
// underflow bits be made available.  The overflow and underflow bits from all FIFO controllers
// must also be "OR"ed together into a single fifo_error sticky interrupt status bit to indicate
// that any FIFO error occurred.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_order_fifo_ctl_wreg
       import hqm_AW_pkg::*; #(

	 parameter DEPTH	= 4
	,parameter DWIDTH	= 4

	,parameter AWIDTH	= (AW_logb2(DEPTH-1)+1)
	,parameter LWIDTH	= (AW_logb2(DEPTH)+1)
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
	,output	logic			pop_data_v_q
	,output	logic	[DWIDTH-1:0]	pop_data_q

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


//-----------------------------------------------------------------------------------------------------

logic				fifo_pop;
logic				fifo_pop_data_v;
logic	[DWIDTH-1:0]		fifo_pop_data;

logic				reg_pop_data_v_q;
logic	[DWIDTH-1:0]		reg_pop_data_q;
logic				reg_pop_uf_q;

logic	[LWIDTH-1:0]		fifo_vdepthx;
logic	[LWIDTH-1:0]		fifo_rdepthx;

logic	[31:0]			fifo_statusx;

//-----------------------------------------------------------------------------------------------------

hqm_AW_order_fifo_ctl #(.DEPTH(DEPTH), .DWIDTH(DWIDTH)) i_AW_order_fifo_ctl (

	 .clk		(clk)
	,.rst_n		(rst_n)

	,.cfg_wm	(cfg_wm)

	,.alloc		(alloc)
	,.alloc_rows	(alloc_rows)

	,.cancel	(cancel)

	,.write		(write)
	,.write_addr	(write_addr)
	,.write_data	(write_data)

	,.pop		(fifo_pop)
	,.pop_data_v	(fifo_pop_data_v)
	,.pop_data	(fifo_pop_data)

	,.mem_enable	(mem_enable)

	,.mem_wr_v	(mem_wr_v)
	,.mem_wr_addr	(mem_wr_addr)
	,.mem_wr_data	(mem_wr_data)

	,.mem_rd_v	(mem_rd_v)
	,.mem_rd_addr	(mem_rd_addr)
	,.mem_rd_data	(mem_rd_data)

	,.mem_v		(mem_v)

	,.fifo_rptr	(fifo_rptr)
	,.fifo_vdepth	(fifo_vdepthx)
	,.fifo_rdepth	(fifo_rdepthx)

	,.fifo_status	(fifo_statusx)
);

assign fifo_pop = (~reg_pop_data_v_q | pop) & fifo_pop_data_v;

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  reg_pop_data_v_q <= 1'b0;
  reg_pop_uf_q     <= 1'b0;
 end else if (cancel)begin
  reg_pop_data_v_q <= 1'b0;
  reg_pop_uf_q     <= 1'b0;
 end else begin
  reg_pop_data_v_q <= (reg_pop_data_v_q & ~pop) | fifo_pop_data_v;
  reg_pop_uf_q     <= reg_pop_uf_q | (pop & ~reg_pop_data_v_q);
 end
end

always_ff @(posedge clk) begin
 if (pop | (~pop_data_v_q & fifo_pop_data_v)) reg_pop_data_q <= fifo_pop_data;
end

assign pop_data_v_q = reg_pop_data_v_q & ~(|{fifo_statusx[3:0], reg_pop_uf_q});
assign pop_data_q   = reg_pop_data_q;

assign fifo_vdepth  = (reg_pop_uf_q | ~reg_pop_data_v_q) ? {LWIDTH{1'b0}} : (fifo_vdepthx+1'b1);
assign fifo_rdepth  = (reg_pop_uf_q) ? {LWIDTH{1'b0}} : fifo_rdepthx;

assign fifo_status  = {	  fifo_statusx[31:(2*LWIDTH)+5]
			,(fifo_statusx[(2*LWIDTH)+4] | reg_pop_data_v_q)
			, fifo_statusx[(2*LWIDTH)+3:1]
			,(fifo_statusx[0] | reg_pop_uf_q)};

//--------------------------------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  check_underflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
  !(pop & ~reg_pop_data_v_q)) else begin
   $display ("\nERROR: %t: %m: FIFO underflow detected (pop while not valid) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule // AW_order_fifo_ctl_wreg

