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
//
//This module implements a triple buffer to decouple input/output timing on PAR receive interface with synch clocks.
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
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_quad_buffer
      import hqm_AW_pkg::*; #(
      parameter WIDTH                           = 32
    , parameter IN_READY_WIDTH                  = 1
    , parameter RESET_DATAPATH                  = 0
) (
    //------------------------------------------------------------------------------------------
    // Input side
      input  logic                              clk
    , input  logic                              rst_n

    , output logic   [ IN_READY_WIDTH - 1 : 0 ] in_ready
    , input  logic                              in_valid
    , input  logic   [ WIDTH - 1 : 0 ]          in_data

    , output logic   [ 7 : 0 ]                  status

    //------------------------------------------------------------------------------------------
    // Output side
    , input  logic                              out_ready
    , output logic                              out_valid
    , output logic   [ WIDTH - 1 : 0 ]          out_data

) ;



//--------------------------------------------------------------------------------------------------
logic in_taken ;
logic in_stall ;
logic out_taken ;
logic out_stall ;
logic [ ( 3 ) - 1 : 0 ] depth_f , depth_next ;
logic [ ( 5 ) - 1 : 0 ] status_f , status_next ;
logic [ ( 2 ) - 1 : 0 ] wp_f , wp_next ;
logic [ ( 2 ) - 1 : 0 ] rp_f , rp_next ;
// 2D array does not work properly in fpga. 
// logic [ ( WIDTH ) - 1 : 0 ] data_f [ ( 4 ) - 1 : 0 ] , data_next [ ( 4 ) - 1 : 0 ] ;
logic [ ( WIDTH ) - 1 : 0 ] data_3_f , data_3_next ;
logic [ ( WIDTH ) - 1 : 0 ] data_2_f , data_2_next ;
logic [ ( WIDTH ) - 1 : 0 ] data_1_f , data_1_next ;
logic [ ( WIDTH ) - 1 : 0 ] data_0_f , data_0_next ;
logic [ ( IN_READY_WIDTH ) - 1 : 0 ] in_ready_f , in_ready_next ;
genvar g ;

//--------------------------------------------------------------------------------------------------

assign in_ready = in_ready_f ;
assign in_taken = in_valid & in_ready [ 0 ] ;
assign in_stall = in_valid & ~ in_ready [ 0 ] ;

assign out_valid = | depth_f ;
assign out_taken = ( | depth_f ) & out_ready ;
assign out_stall = ( | depth_f ) & ~ out_ready ;

assign status_next = { in_stall , in_taken , out_stall , out_taken , out_ready } ;
assign status = { status_f , depth_f } ;

always_ff @( posedge clk or negedge rst_n ) begin :clk_l
 if ( ~ rst_n ) begin
  status_f <= '0 ;
  depth_f <= '0 ;
  wp_f <= '0 ;
  rp_f <= '0 ;
  in_ready_f <= '1 ;
 end else begin
  status_f <= status_next ;
  depth_f <= depth_next ;
  wp_f <= wp_next ;
  rp_f <= rp_next ;
  in_ready_f <= in_ready_next ;
 end
end

generate
 if ( RESET_DATAPATH == 0 ) begin : g_rdp0
  always_ff @( posedge clk ) begin : clk_d0
    data_3_f <= data_3_next ;
    data_2_f <= data_2_next ;
    data_1_f <= data_1_next ;
    data_0_f <= data_0_next ;
  end
 end else begin : g_rdp1
  always_ff @( posedge clk or negedge rst_n ) begin : clk_d1
   if ( ~ rst_n ) begin
    data_3_f <= '0 ;
    data_2_f <= '0 ;
    data_1_f <= '0 ;
    data_0_f <= '0 ;
   end else begin
    data_3_f <= data_3_next ;
    data_2_f <= data_2_next ;
    data_1_f <= data_1_next ;
    data_0_f <= data_0_next ;
   end
  end
 end
endgenerate

always_comb begin : comb
  data_3_next = data_3_f ;
  data_2_next = data_2_f ;
  data_1_next = data_1_f ;
  data_0_next = data_0_f ;

  case ( { in_taken , out_taken } )
    2'b10 : depth_next = depth_f + 3'd1 ;
    2'b01 : depth_next = depth_f - 3'd1 ;
    default : depth_next = depth_f ;
  endcase
  in_ready_next = { IN_READY_WIDTH { ~ ( depth_next == 3'd4 ) } } ;

  wp_next = wp_f ;
  if ( in_taken ) begin
    wp_next = wp_f + 2'd1 ;
    case ( wp_f )
      2'd3 : data_3_next = in_data ;
      2'd2 : data_2_next = in_data ;
      2'd1 : data_1_next = in_data ;
      2'd0 : data_0_next = in_data ;
    endcase
  end

  rp_next = rp_f ;
  if ( out_taken ) begin
    rp_next = rp_f + 2'd1 ;
  end
end

assign out_data = ( rp_f == 2'd3 ) ? data_3_f :
                  ( rp_f == 2'd2 ) ? data_2_f :
                  ( rp_f == 2'd1 ) ? data_1_f : 
                  data_0_f ;

endmodule
