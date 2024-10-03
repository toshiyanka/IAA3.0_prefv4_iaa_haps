module hqm_AW_fifo_control_tb
       import hqm_AW_pkg::*; #(

	 parameter DEPTH		= 4
	,parameter DWIDTH		= 2

 	,parameter COV_FULL_PUSHPOP	= 0
 	,parameter COV_NEVER_FULL	= 0
 	,parameter CHECK_PUSH_XZ	= 1

	,parameter AWIDTH		= (AW_logb2(DEPTH-1)+1)
	,parameter DEPTHWIDTH		= (AW_logb2(DEPTH+1)+1)
	,parameter WMWIDTH		= (AW_logb2(DEPTH+2)+1)

) (

	 input	logic				clk
	,input	logic				rst_n

	,input	logic	[WMWIDTH-1:0]		cfg_high_wm

	,input	logic				push
	,input	logic	[DWIDTH-1:0]		push_data

	,input	logic				pop
	,output	logic	[DWIDTH-1:0]		pop_data

	,output	logic				fifo_full
	,output	logic				fifo_afull
	,output	logic				fifo_empty

	,output	aw_fifo_status_t		fifo_status
);

logic				mem_we;
logic	[AWIDTH-1:0]		mem_waddr;
logic	[DWIDTH-1:0]		mem_wdata;

logic				mem_re;
logic	[AWIDTH-1:0]		mem_raddr;
logic	[DWIDTH-1:0]		mem_rdata;

hqm_AW_fifo_control #(
  .DEPTH(DEPTH),
  .DWIDTH(DWIDTH),
  .MEMRE_POWER_OPT(0)
) i_fifo_control (
  .clk(clk),
  .rst_n(rst_n),
  .cfg_high_wm(cfg_high_wm),
  .push(push),
  .push_data(push_data),
  .pop(pop),
  .pop_data(pop_data),
  .mem_we(mem_we),
  .mem_waddr(mem_waddr),
  .mem_wdata(mem_wdata),
  .mem_re(mem_re),
  .mem_raddr(mem_raddr),
  .mem_rdata(mem_rdata),
  .fifo_full(fifo_full),
  .fifo_afull(fifo_afull),
  .fifo_empty(fifo_empty),
  .fifo_status(fifo_status)
);

logic	[DWIDTH-1:0]		fifo_mem [DEPTH+1];


always_ff @(posedge clk) begin
  if (mem_re) begin
    mem_rdata <= fifo_mem[mem_raddr];
  end
  if (mem_we) begin
    fifo_mem[mem_waddr] <= mem_wdata;
  end
end

  assert_fifo #(
    .depth(5),
    .elem_sz(2)
  ) i_assert_fifo(
    clk,
    rst_n,
    push & ~fifo_full,
    push_data,
    pop & ~fifo_empty,
    pop_data
  );

  overflow_check: assert property (@(posedge clk) disable iff (rst_n !== 1'b1) (push & fifo_full) |-> ##1 fifo_status.overflow);
  underflow_check: assert property (@(posedge clk) disable iff (rst_n !== 1'b1) (pop & fifo_empty) |-> ##1 fifo_status.underflow);

  overflow_hold_check: assert property (@(posedge clk) disable iff (rst_n !== 1'b1) fifo_status.overflow |-> ##1 fifo_status.overflow);
  underflow_hold_check: assert property (@(posedge clk) disable iff (rst_n !== 1'b1) fifo_status.underflow |-> ##1 fifo_status.underflow);

endmodule
