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
// AW_async_one_pulse_reg
// 
// This module is responsible for ensuring that a pulse is seen across a clock domain crossing.
// Data accompanying the pulse is flopped in order to be seen across the clock domain crossing.
// This module will not accept any subsequent pulses until the destination pulse has been delivered and 
// the initial pulse request has been cleared by sychronizing from the dest side back to the source side.
// This design is intended for specific use cases that have a limited bandwidth.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_async_one_pulse_reg 
        import hqm_AW_pkg::*;
#(
        parameter WIDTH    = 32
) (
         input  logic             src_clk
       , input  logic             src_rst_n
       , input  logic             dst_clk
       , input  logic             dst_rst_n

       , input  logic             in_v
       , input  logic [WIDTH-1:0] in_data
       , output logic             out_v
       , output logic [WIDTH-1:0] out_data

       , output logic             req_active
);

//-----------------------------------------------------------------------------------------------------
logic in_v_f, in_v_nxt;
logic [WIDTH-1:0] in_data_f, in_data_nxt;
logic in_v_sync;
logic in_v_sync_f;
logic in_v_ack_f, in_v_ack_nxt;
logic in_v_ack_sync;
logic in_v_ack_sync_f;
logic active_f, active_nxt;
logic in_v_sync_re, in_v_sync_fe ;  // rising edge detect, falling edge detect
logic in_v_ack_re, in_v_ack_fe ;
//-----------------------------------------------------------------------------------------------------
// Flop and hold source request, capture data.  Reset only after seen by the destination (rising edge).
assign in_v_nxt       = ( (in_v & ~active_f) | in_v_f ) & ~in_v_ack_re ;
assign in_data_nxt    = ( (in_v & ~active_f) ? in_data : in_data_f ) ;

// Separate flop holds the request, but only resets when the request has been cleared on dest side (prevents hang)
assign active_nxt     = ( (in_v & ~active_f) | active_f ) & ~in_v_ack_fe ;
assign req_active     = active_f;

always_ff @(posedge src_clk or negedge src_rst_n) begin
  if (~src_rst_n) begin
    in_v_f            <= 1'b0;
    in_v_ack_sync_f   <= 1'b0;
    in_data_f         <= '0;
    active_f          <= 1'b0;
  end else begin
    in_v_f            <= in_v_nxt;
    in_v_ack_sync_f   <= in_v_ack_sync;
    in_data_f         <= in_data_nxt; 
    active_f          <= active_nxt;
  end
end

assign in_v_ack_re    = ( in_v_ack_sync & ~in_v_ack_sync_f);
assign in_v_ack_fe    = (~in_v_ack_sync &  in_v_ack_sync_f);

// Sync source to destination
hqm_AW_sync_rst0 #(.WIDTH(1)) i_in_v_sync (
        .clk            (dst_clk),
        .rst_n          (dst_rst_n),
        .data           (in_v_f),
        .data_sync      (in_v_sync)
);

// Generate single output pulse in destination domain
always_ff @(posedge dst_clk or negedge dst_rst_n) begin
  if (~dst_rst_n) begin
    in_v_sync_f       <= 1'b0;
    in_v_ack_f        <= 1'b0;
  end else begin
    in_v_sync_f       <= in_v_sync;
    in_v_ack_f        <= in_v_ack_nxt;
  end
end

assign in_v_sync_re   = ( in_v_sync & ~in_v_sync_f) ;
assign in_v_sync_fe   = (~in_v_sync &  in_v_sync_f) ; 

assign out_v          = in_v_sync_fe;
assign out_data       = in_data_f;

// Hold the ack until the dest side sees the falling edge of the request
assign in_v_ack_nxt   = ((in_v_sync_re | in_v_ack_f) & ~in_v_sync_fe ) ;
 
// Sync destination back to source as the reset trigger
hqm_AW_sync_rst0 #(.WIDTH(1)) i_in_v_ack_sync (
        .clk            (src_clk),
        .rst_n          (src_rst_n),
        .data           (in_v_ack_f),
        .data_sync      (in_v_ack_sync)
);

endmodule // AW_async_one_pulse_reg
