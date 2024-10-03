//------------------------------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// AW_fifo_control_wreg
//
// This is just a wrapper for the AW_fifo_control_wreg FIFO controller and includes a register at the bottom of
// the FIFO to take the memory read latency out of any timing paths.
//
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_wreg

    import hqm_AW_pkg::* ;

#(
     parameter DEPTH                = 8
    ,parameter DWIDTH               = 16
    ,parameter MEMRE_POWER_OPT      = 0
    ,parameter NUM_V                = 1
    //............................................................................................................................................
    ,parameter DEPTHB2              = ( AW_logb2 ( DEPTH -1 ) + 1 )
    ,parameter DEPTHWIDTH           = ( AW_logb2 ( DEPTH    ) + 1 )
    ,parameter WMWIDTH              = ( AW_logb2 ( DEPTH +1 ) + 1 )

) (

     input  logic                   clk
    ,input  logic                   rst_n
    
    ,input  logic                   push
    ,input  logic [DWIDTH-1:0]      push_data
    ,input  logic                   pop

    ,output logic [NUM_V-1:0]       pop_data_v
    ,output logic [DWIDTH-1:0]      pop_data
    
    ,input  logic [WMWIDTH-1:0]     cfg_high_wm
    
    ,output logic                   mem_we
    ,output logic [DEPTHB2-1:0]     mem_waddr
    ,output logic [DWIDTH-1:0]      mem_wdata
    ,output logic                   mem_re
    ,output logic [DEPTHB2-1:0]     mem_raddr
    ,input  logic [DWIDTH-1:0]      mem_rdata
    
    ,output aw_fifo_status_t        fifo_status
    ,output logic                   fifo_full
    ,output logic                   fifo_afull
);

//--------------------------------------------------------------------------------------------

logic                       fifo_push;
logic                       fifo_pop;
logic   [DWIDTH-1:0]        fifo_pop_data;
logic                       fifo_empty;
aw_fifo_status_t            fifo_statusx;
logic   [WMWIDTH-1:0]       fifo_depth_wreg;

logic                       pop_data_load;
logic   [NUM_V-1:0]         pop_data_v_q;
logic   [DWIDTH-1:0]        pop_data_q;

logic                       pop_uf_q;

//--------------------------------------------------------------------------------------------

assign pop_data_load = ~pop_data_v_q[0] | pop;
assign fifo_push     = push & ~(fifo_empty & pop_data_load);
assign fifo_pop      = pop  & ~(fifo_empty & pop_data_v_q[0]);

hqm_AW_fifo_control #(

     .DEPTH             (DEPTH)
    ,.DWIDTH            (DWIDTH)
    ,.MEMRE_POWER_OPT   (MEMRE_POWER_OPT)

) i_hqm_AW_fifo_control (

     .clk               (clk)
    ,.rst_n             (rst_n)
    
    ,.push              (fifo_push)
    ,.push_data         (push_data)
    ,.pop               (fifo_pop)
    ,.pop_data          (fifo_pop_data)
    
    ,.cfg_high_wm       (cfg_high_wm)
    
    ,.mem_we            (mem_we)
    ,.mem_waddr         (mem_waddr)
    ,.mem_wdata         (mem_wdata)
    ,.mem_re            (mem_re)
    ,.mem_raddr         (mem_raddr)
    ,.mem_rdata         (mem_rdata)
    
    ,.fifo_status       (fifo_statusx)
    ,.fifo_full         (fifo_full)
    ,.fifo_afull        (fifo_afull)
    ,.fifo_empty        (fifo_empty)
);

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  pop_data_v_q <= '0;
  pop_uf_q     <= '0;
 end else begin
  if (pop_data_load) pop_data_v_q <= {NUM_V{(push | ~fifo_empty)}};
  pop_uf_q     <= pop_uf_q | (pop & ~pop_data_v_q[0]);
 end
end

always_ff @(posedge clk) begin
 if (pop_data_load) pop_data_q <= (fifo_empty) ? push_data : fifo_pop_data;
end

assign pop_data_v      = pop_data_v_q;
assign pop_data        = pop_data_q;

assign fifo_depth_wreg = { {(WMWIDTH-DEPTHWIDTH){1'b0}} , fifo_statusx.depth[DEPTHWIDTH-1:0] } +
                         { {(WMWIDTH-1)         {1'b0}} , pop_data_v_q[0] } ;

always_comb begin
 fifo_status           = fifo_statusx;
 fifo_status.depth     = {{($bits(fifo_status.depth)-$bits(fifo_depth_wreg)){1'b0}}, fifo_depth_wreg};
 fifo_status.empty     = fifo_statusx.empty & ~pop_data_v_q[0];
 fifo_status.underflow = fifo_statusx.underflow | pop_uf_q;
end

//--------------------------------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  check_underflow: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
  !(pop & ~pop_data_v_q[0])) else begin
   $display ("\nERROR: %t: %m: FIFO underflow detected (pop while not valid) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule // hqm_AW_fifo_control_wreg

