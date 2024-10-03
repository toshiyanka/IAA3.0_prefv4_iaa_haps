//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// AW_fifo_ctl_dc_wreg
//
// This is just a wrapper around the AW_fifo_ctl_dc that adds an output data register so the memory
// read time does not appear in the output path.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_dc_wreg

     import hqm_AW_pkg::*;
#(
     parameter DEPTH                = 2
    ,parameter DWIDTH               = 2

    ,parameter AWIDTH               = AW_logb2(DEPTH-1)+1
    ,parameter DEPTHWIDTH           = (((2**AWIDTH)==DEPTH) ? (AWIDTH+1) : AWIDTH)
) (
     input  logic                   clk_push
    ,input  logic                   rst_push_n

    ,input  logic                   clk_pop
    ,input  logic                   rst_pop_n

    ,input  logic [DEPTHWIDTH-1:0]  cfg_high_wm
    ,input  logic [DEPTHWIDTH-1:0]  cfg_low_wm

    ,input  logic                   fifo_enable

    ,input  logic                   clear_pop_state

    ,input  logic                   push
    ,input  logic [DWIDTH-1:0]      push_data

    ,input  logic                   pop
    ,output logic                   pop_data_v
    ,output logic [DWIDTH-1:0]      pop_data

    ,output logic                   mem_we
    ,output logic [AWIDTH-1:0]      mem_waddr
    ,output logic [DWIDTH-1:0]      mem_wdata
    ,output logic                   mem_re
    ,output logic [AWIDTH-1:0]      mem_raddr
    ,input  logic [DWIDTH-1:0]      mem_rdata

    ,output logic [DEPTHWIDTH-1:0]  fifo_push_depth
    ,output logic                   fifo_push_full
    ,output logic                   fifo_push_afull
    ,output logic                   fifo_push_empty
    ,output logic                   fifo_push_aempty

    ,output logic [DEPTHWIDTH-1:0]  fifo_pop_depth
    ,output logic                   fifo_pop_aempty
    ,output logic                   fifo_pop_empty

    ,output logic [31:0]            fifo_status
);

//--------------------------------------------------------------------------------------------

logic                       fifo_pop;
logic   [DWIDTH-1:0]        fifo_pop_data;
logic   [31:0]              fifo_statusx;

logic                       pop_data_load;
logic                       pop_data_v_q;
logic   [DWIDTH-1:0]        pop_data_q;
logic                       pop_uf_q;

//-----------------------------------------------------------------------------------------------------

hqm_AW_fifo_control_dc #(

     .DEPTH                     (DEPTH)
    ,.DWIDTH                    (DWIDTH)
    ,.SYNC_POP                  (1)         // fifo_status synced to clk_pop

) i_fifo_control_dc (

     .clk_push                  (clk_push)
    ,.rst_push_n                (rst_push_n)

    ,.clk_pop                   (clk_pop)
    ,.rst_pop_n                 (rst_pop_n)

    ,.cfg_high_wm               (cfg_high_wm)
    ,.cfg_low_wm                (cfg_low_wm)

    ,.fifo_enable               (fifo_enable)

    ,.clear_pop_state           (clear_pop_state)

    ,.push                      (push)
    ,.push_data                 (push_data)

    ,.pop                       (fifo_pop)
    ,.pop_data                  (fifo_pop_data)

    ,.mem_we                    (mem_we)
    ,.mem_waddr                 (mem_waddr)
    ,.mem_wdata                 (mem_wdata)
    ,.mem_re                    (mem_re)
    ,.mem_raddr                 (mem_raddr)
    ,.mem_rdata                 (mem_rdata)

    ,.fifo_push_depth           (fifo_push_depth)
    ,.fifo_push_full            (fifo_push_full)
    ,.fifo_push_afull           (fifo_push_afull)
    ,.fifo_push_empty           (fifo_push_empty)
    ,.fifo_push_aempty          (fifo_push_aempty)

    ,.fifo_pop_depth            (fifo_pop_depth)
    ,.fifo_pop_aempty           (fifo_pop_aempty)
    ,.fifo_pop_empty            (fifo_pop_empty)

    ,.fifo_status               (fifo_statusx)
);

//--------------------------------------------------------------------------------------------

assign fifo_pop = ~fifo_pop_empty & (~pop_data_v_q | pop);

assign pop_data_load = ~pop_data_v_q | pop;

always_ff @(posedge clk_pop or negedge rst_pop_n) begin
 if (~rst_pop_n) begin
  pop_data_v_q <= '0;
 end else if (clear_pop_state) begin
  pop_data_v_q <= '0;
 end else if (fifo_enable) begin
  if (pop_data_load) pop_data_v_q <= ~fifo_pop_empty;
 end
end

always_ff @(posedge clk_pop or negedge rst_pop_n) begin
 if (~rst_pop_n) begin
  pop_uf_q     <= '0;
 end else if (fifo_enable) begin
  pop_uf_q     <= pop & ~pop_data_v_q;
 end
end

always_ff @(posedge clk_pop) begin
 if (fifo_pop) pop_data_q <= fifo_pop_data;
end

assign pop_data_v = pop_data_v_q & fifo_enable;
assign pop_data   = pop_data_q;

always_comb begin

 fifo_status    = fifo_statusx;

 fifo_status[0] = pop_uf_q & fifo_enable;

end

hqm_AW_unused_bits i_unused (.a(fifo_statusx[0]));

//--------------------------------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  check_underflow: assert property (@(posedge clk_pop) disable iff (rst_pop_n !== 1'b1)
  !(pop & ~pop_data_v_q)) else begin
   $display ("\nERROR: %t: %m: FIFO underflow detected (pop while not valid) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule // AW_fifo_ctl_dc_wreg

