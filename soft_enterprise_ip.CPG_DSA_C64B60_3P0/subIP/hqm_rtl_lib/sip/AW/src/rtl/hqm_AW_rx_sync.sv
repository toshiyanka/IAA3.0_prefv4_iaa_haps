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
module hqm_AW_rx_sync
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


) ;

logic           fifo_pop_nc ;
logic [ ( WMWIDTH ) -1 : 0]     cfg_high_wm ;


assign cfg_high_wm = DEPTH [ ( WMWIDTH ) -1 : 0] ;
 
hqm_AW_rx_sync_core # (
          .DEPTH                ( DEPTH )
        , .WIDTH                ( WIDTH )
        , .ENABLE_DROPREADY     ( ENABLE_DROPREADY )
        , .WREG                 ( WREG )
) i_hqm_AW_rx_sync_core (
          .hqm_inp_gated_clk            ( hqm_inp_gated_clk )
        , .hqm_inp_gated_rst_n          ( hqm_inp_gated_rst_n )
        , .cfg_high_wm                  ( cfg_high_wm )
        , .status                       ( status )
        , .enable                       ( enable )
        , .idle                         ( idle )
        , .rst_prep                     ( rst_prep )
        , .in_ready                     ( in_ready )
        , .in_valid                     ( in_valid )
        , .in_data                      ( in_data )
        , .out_ready                    ( out_ready )
        , .out_valid                    ( out_valid )
        , .out_data                     ( out_data )
        , .mem_we                       ( mem_we )
        , .mem_waddr                    ( mem_waddr )
        , .mem_wdata                    ( mem_wdata )
        , .mem_re                       ( mem_re )
        , .mem_raddr                    ( mem_raddr )
        , .mem_rdata                    ( mem_rdata )
        , .agitate_data                 ( 1'b1 )
        , .fifo_pop                     ( fifo_pop_nc )
) ;
endmodule
