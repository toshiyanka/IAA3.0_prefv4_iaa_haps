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
// AW_double_buffer
//
// This module implements a double buffer to decouple input/output timing.
//
// The 7-bit status output provides the following registered information:
//
//  [6] Input stalled   (in_valid &  ~in_ready) : Can be used as countable input  stall    event
//  [5] Input taken     (in_valid &   in_ready) : Can be used as countable input  accepted event
//  [4] Output stalled (out_valid & ~out_ready) : Can be used as countable output stall    event
//  [3] Output taken   (out_valid &  out_ready) : Can be used as countable output accepted event
//  [2] Registered value of out_ready       : Useful as read-only backpressure status
//  [1:0]   Current depth value         : Useful as read-only depth status
//
// It is recommended that bits [6:3] are hooked to an SMON so they can be counted and that bits [2:0]
// are available as read-only configuration status.
//
// An inline covergroup is included to provide comprehensive code coverage information if the design
// is compile with coverage enabled.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_double_buffer

     import hqm_AW_pkg::*; #(

     parameter WIDTH            = 32
    ,parameter NOT_EMPTY_AT_EOT = 0
    ,parameter IN_READY_WIDTH   = 1
    ,parameter RESET_DATAPATH   = 0
) (
     input  logic                           clk
    ,input  logic                           rst_n

    ,output logic   [6:0]                   status

    //------------------------------------------------------------------------------------------
    // Input side

    ,output logic   [IN_READY_WIDTH-1:0]    in_ready

    ,input  logic                           in_valid
    ,input  logic   [WIDTH-1:0]             in_data

    //------------------------------------------------------------------------------------------
    // Output side

    ,input  logic                           out_ready

    ,output logic                           out_valid
    ,output logic   [WIDTH-1:0]             out_data
);

// Put at most 8 loads on any output mux select.

localparam RP_WIDTH = ((WIDTH+7)>>3);

//--------------------------------------------------------------------------------------------------

logic                           in_taken;
logic                           in_stall;
logic                           out_taken;
logic                           out_stall;
logic   [1:0]                   depth_next;
logic   [1:0]                   depth_q;
logic   [4:0]                   status_next;
logic   [4:0]                   status_q;
logic                           wp_q;
logic   [RP_WIDTH-1:0]          rp_q;
logic   [WIDTH-1:0]             data_q[1:0];
logic   [IN_READY_WIDTH-1:0]    in_ready_f;
logic   [IN_READY_WIDTH-1:0]    in_ready_nxt;

genvar                          g;

//--------------------------------------------------------------------------------------------------

assign in_ready = in_ready_f;

assign in_taken = in_valid &  in_ready[0];
assign in_stall = in_valid & ~in_ready[0];

assign out_taken = (|depth_q) &  out_ready;
assign out_stall = (|depth_q) & ~out_ready;

assign status_next = {in_stall, in_taken, out_stall, out_taken, out_ready};

always_comb begin
 case ({in_taken, out_taken})
  2'b10:   depth_next = depth_q + 2'd1;
  2'b01:   depth_next = depth_q - 2'd1;
  default: depth_next = depth_q;
 endcase
end

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  status_q   <= 5'd0;
  depth_q    <= 2'd0;
  wp_q       <= 1'b0;
  rp_q       <= {RP_WIDTH{1'b0}};
  in_ready_f <= {IN_READY_WIDTH{1'b0}};
 end else begin
  status_q   <= status_next;
  depth_q    <= depth_next;
  if (in_taken)  wp_q <= ~wp_q;
  if (out_taken) rp_q <= ~rp_q;
  in_ready_f <= in_ready_nxt ;
 end
end

assign in_ready_nxt = {IN_READY_WIDTH{~depth_next[1]}} ;

generate
 if (RESET_DATAPATH == 0) begin: g_rdp0

  always_ff @(posedge clk) if (in_taken) data_q[wp_q] <= in_data;   

 end else begin: g_rdp1

  always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
    data_q[1] <= '0;
    data_q[0] <= '0;
   end else if (in_taken) data_q[wp_q] <= in_data;                 
  end

 end
endgenerate

assign status    = {status_q, depth_q};

assign out_valid = |depth_q;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_bit

  assign out_data[g] = data_q[rp_q[g>>3]][g -: 1];

 end
endgenerate

//--------------------------------------------------------------------------------------------
// Coverage

`ifdef HQM_COVER_ON

 covergroup AW_double_buffer_CG @(posedge clk);

  AW_double_buffer_CP_in_valid: coverpoint in_valid iff (rst_n === 1'b1) {
    bins        NOT_VALID   = {0};
    bins        VALID       = {1};
  }

  AW_double_buffer_CP_in_ready: coverpoint (|in_ready) iff (rst_n === 1'b1) {
    bins        NOT_READY   = {0};
    bins        READY       = {1};
  }

  AW_double_buffer_CP_depth: coverpoint depth_q iff (rst_n === 1'b1) {
    bins        DEPTH0      = {0};
    bins        DEPTH1      = {1};
    bins        DEPTH2      = {2};
    ignore_bins DEPTH3      = {3}; // illegal_bins  DEPTH3      = {3};
  }

  AW_double_buffer_CP_out_valid: coverpoint out_valid iff (rst_n === 1'b1) {
    bins        NOT_VALID   = {0};
    bins        VALID       = {1};
  }

  AW_double_buffer_CP_out_ready: coverpoint out_ready iff (rst_n === 1'b1) {
    bins        NOT_READY   = {0};
    bins        READY       = {1};
  }

  AW_double_buffer_CX: cross AW_double_buffer_CP_in_valid, AW_double_buffer_CP_depth,
    AW_double_buffer_CP_in_ready, AW_double_buffer_CP_out_valid, AW_double_buffer_CP_out_ready {
    ignore_bins FULL_READY  = binsof(AW_double_buffer_CP_depth.DEPTH2) && // illegal_bins   FULL_READY  = binsof(AW_double_buffer_CP_depth.DEPTH2) &&
                      binsof(AW_double_buffer_CP_in_ready.READY);
`ifndef HQM_AW_DOUBLE_BUFFER_COV_ALLOW_AGITATION
    ignore_bins NOT_FULL_READY  = !binsof(AW_double_buffer_CP_depth.DEPTH2) && // illegal_bins  NOT_FULL_READY  = !binsof(AW_double_buffer_CP_depth.DEPTH2) &&
                      binsof(AW_double_buffer_CP_in_ready.NOT_READY);
`else
    ignore_bins NOT_FULL_READY  = !binsof(AW_double_buffer_CP_depth.DEPTH2) &&
                      binsof(AW_double_buffer_CP_in_ready.NOT_READY);
`endif
    ignore_bins EMPTY_VALID = binsof(AW_double_buffer_CP_depth.DEPTH0) && // illegal_bins   EMPTY_VALID = binsof(AW_double_buffer_CP_depth.DEPTH0) &&
                      binsof(AW_double_buffer_CP_out_valid.VALID);
    ignore_bins NOT_EMPTY_VALID = !binsof(AW_double_buffer_CP_depth.DEPTH0) && // illegal_bins  NOT_EMPTY_VALID = !binsof(AW_double_buffer_CP_depth.DEPTH0) &&
                      binsof(AW_double_buffer_CP_out_valid.NOT_VALID);
    ignore_bins NOT_VALID_READY = binsof(AW_double_buffer_CP_out_valid.NOT_VALID) &&
                      binsof(AW_double_buffer_CP_out_ready.READY);
  }

 endgroup

 AW_double_buffer_CG AW_double_buffer_CG_inst = new();

`endif

`ifndef INTEL_SVA_OFF

  check_depth_ne3: assert property (@(posedge clk) disable iff (rst_n !== 1'b1) !(depth_q == 2'd3)) else begin
   $display ("\nERROR: %t: %m: Double buffer depth set to illegal value of 3 !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  generate

   if (NOT_EMPTY_AT_EOT != 1) begin: g_eot_check

    logic disable_eot_check;

    initial begin
     disable_eot_check = '0;
     if ($test$plusargs("HQM_DISABLE_EOT_CHECK")) disable_eot_check = '1;
    end

    final begin
     assert ((depth_q===2'd0) | disable_eot_check) else begin
      $display("ERROR: %t: %m: AW_double_buffer depth was not 0 at end of test !!!", $time);
      if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
     end
    end

  end

  endgenerate

`endif

endmodule // AW_double_buffer

