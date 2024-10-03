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
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_rx_sync_core
import hqm_AW_pkg::* ; # (
  parameter DEPTH                           = 4
, parameter WIDTH                           = 16
, parameter ENABLE_DROPREADY                = 0 //set this to drop in_ready when clocks are disabled and include in_valid in 'idle'
, parameter WREG                            = 1
//...........................................................................................................................................
, parameter DEPTHB2                         = ( AW_logb2 ( DEPTH -1 ) + 1 )
, parameter WMWIDTH                         = ( AW_logb2 ( DEPTH +1 ) + 1 )
) (
  input  logic                              hqm_inp_gated_clk
, input  logic                              hqm_inp_gated_rst_n

, input  logic [ ( WMWIDTH ) -1 : 0]        cfg_high_wm
, output  aw_fifo_status_t                  status    // hqm_AW_rx_sync FIFO status

, input  logic                              enable    // enable control from hqm_AW_module_clock_control 
, output logic                              idle      // idle indication to hqm_AW_module_clock_control
, input  logic                              rst_prep

, output logic                              in_ready  // input interface (connect to PAR port) double buffer ready
, input  logic                              in_valid  // input interface (connect to PAR port) double buffer valid
, input  logic [ ( WIDTH ) - 1 : 0 ]        in_data   // input interface (connect to PAR port) double buffer data
, input  logic                              out_ready // output interface (connect to internal) double buffer ready
, output logic                              out_valid // output interface (connect to internal) double buffer valid
, output logic [ ( WIDTH ) - 1 : 0 ]        out_data  // output interface (connect to internal) double buffer data

, output logic                              mem_we     // FIFO memory write enable
, output logic [ ( DEPTHB2 ) - 1 : 0]       mem_waddr  // FIFO memory write address
, output logic [ ( WIDTH ) - 1 : 0]         mem_wdata  // FIFO memory write data
, output logic                              mem_re     // FIFO memory read enable
, output logic [ ( DEPTHB2 ) - 1 : 0]       mem_raddr  // FIFO memory read address
, input  logic [ ( WIDTH ) - 1 : 0]         mem_rdata  // FIFO memory read data

, input  logic                              agitate_data
, output logic                              fifo_pop


) ;

logic in_valid_f ; // needed for ENABLE_DROPREADY=1 case where fifo is not pushed until gated clocks are safe
always_ff @ ( posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n ) begin
  if ( ~ hqm_inp_gated_rst_n ) begin
    in_valid_f <= '0 ;
  end else begin
    in_valid_f <= in_valid ;
  end
end




generate
 if ( WREG == 0 ) begin : g_wreg0
    logic fifo_push ;
    logic [ ( WIDTH ) - 1 : 0 ] fifo_push_data ;
    logic [ ( WIDTH ) - 1 : 0 ] fifo_pop_data ;
    logic fifo_full_nc ;
    logic fifo_afull ;
    logic fifo_empty ;
    
    assign idle           = rst_prep ? 1'b0 : ( fifo_empty & ~ in_valid_f ) ;
    assign in_ready       = rst_prep ? 1'b1 : ( ~ fifo_afull & ~ ( ( ENABLE_DROPREADY == 32'd1 ) & ~ enable ) & agitate_data ) ;
    assign fifo_push      = rst_prep ? 1'b0 : ( in_valid & in_ready ) ;
    assign fifo_push_data = in_data ;
    assign out_valid      = enable & ~ fifo_empty & agitate_data ;
    assign out_data       = fifo_pop_data ;
    assign fifo_pop       = out_valid & out_ready ;
    
    hqm_AW_fifo_control #(
      .DEPTH ( DEPTH )
    , .DWIDTH ( WIDTH )
    ) i_fifo (
      .clk ( hqm_inp_gated_clk )
    , .rst_n ( hqm_inp_gated_rst_n )
    , .push ( fifo_push )
    , .push_data ( { fifo_push_data } )
    , .pop ( fifo_pop )
    , .pop_data ( { fifo_pop_data } )
    , .cfg_high_wm ( cfg_high_wm )
    , .fifo_status ( status )
    , .fifo_full ( fifo_full_nc )
    , .fifo_afull ( fifo_afull )
    , .fifo_empty ( fifo_empty )
    , .mem_we ( mem_we )
    , .mem_waddr ( mem_waddr )
    , .mem_wdata ( mem_wdata )
    , .mem_re ( mem_re )
    , .mem_raddr ( mem_raddr )
    , .mem_rdata ( mem_rdata )
    ) ;
  end
 if ( WREG == 1 ) begin : g_wreg1
    logic fifo_push ;
    logic [ ( WIDTH ) - 1 : 0 ] fifo_push_data ;
    logic [ ( WIDTH ) - 1 : 0 ] fifo_pop_data ;
    logic fifo_full_nc ;
    logic fifo_afull ;
    logic fifo_pop_data_v ;
    
    assign idle           = rst_prep ? 1'b0 : ( ~ fifo_pop_data_v & ~ in_valid_f) ;
    assign in_ready       = rst_prep ? 1'b1 : ( ~ fifo_afull & ~ ( ( ENABLE_DROPREADY == 32'd1 ) & ~ enable ) & agitate_data ) ;
    assign fifo_push      = rst_prep ? 1'b0 : ( in_valid & in_ready ) ;
    assign fifo_push_data = in_data ;
    assign out_valid      = enable & fifo_pop_data_v & agitate_data ;
    assign out_data       = fifo_pop_data ;
    assign fifo_pop       = out_valid & out_ready ;
    
    hqm_AW_fifo_control_wreg #(
      .DEPTH ( DEPTH )
    , .DWIDTH ( WIDTH )
    ) i_fifo (
      .clk ( hqm_inp_gated_clk )
    , .rst_n ( hqm_inp_gated_rst_n )
    , .push ( fifo_push )
    , .push_data ( { fifo_push_data } )
    , .pop ( fifo_pop )
    , .pop_data ( { fifo_pop_data } )
    , .pop_data_v ( fifo_pop_data_v )
    , .cfg_high_wm ( cfg_high_wm )
    , .fifo_status ( status )
    , .fifo_full ( fifo_full_nc )
    , .fifo_afull ( fifo_afull )
    , .mem_we ( mem_we )
    , .mem_waddr ( mem_waddr )
    , .mem_wdata ( mem_wdata )
    , .mem_re ( mem_re )
    , .mem_raddr ( mem_raddr )
    , .mem_rdata ( mem_rdata )
    ) ;
  end
endgenerate

endmodule
