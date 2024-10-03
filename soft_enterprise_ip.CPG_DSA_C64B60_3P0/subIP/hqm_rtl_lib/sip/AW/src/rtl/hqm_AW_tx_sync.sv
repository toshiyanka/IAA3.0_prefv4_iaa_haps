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
//-----------------------------------------------------------------------------------------------------
module hqm_AW_tx_sync
import hqm_AW_pkg::*; #(
  parameter WIDTH                           = 32
, parameter STAGES                          = 2
) (
  input  logic                              hqm_gated_clk
, input  logic                              hqm_gated_rst_n

, output logic   [ 6 : 0 ]                  status
, output logic                              idle
, input  logic                              rst_prep

, output logic                              in_ready
, input  logic                              in_valid
, input  logic   [ WIDTH - 1 : 0 ]          in_data
, input  logic                              out_ready
, output logic                              out_valid
, output logic   [ WIDTH - 1 : 0 ]          out_data
) ;

assign idle = rst_prep ? 1'b0 : ( status[1:0] == 2'd0 ) ;

logic db_out_valid ;
logic [ WIDTH - 1 : 0 ] db_out_data ;
assign out_valid = rst_prep ? 1'b0 : db_out_valid ;
assign out_data = db_out_data ;

generate
  if ( STAGES == 1 ) begin : g_s1
    hqm_AW_single_buffer # (
      .WIDTH ( WIDTH )
    , .RESET_DATAPATH ( 1 )
    ) i_db (
      .clk ( hqm_gated_clk )
    , .rst_n ( hqm_gated_rst_n )
    , .status ( status )
    , .in_valid ( in_valid )
    , .in_ready ( in_ready )
    , .in_data ( in_data )
    , .out_valid ( db_out_valid )
    , .out_ready ( out_ready )
    , .out_data ( db_out_data )
    ) ;
  end
  if ( STAGES == 2 ) begin : g_s2
    hqm_AW_double_buffer # (
      .WIDTH ( WIDTH )
    , .RESET_DATAPATH ( 1 )
    ) i_db (
      .clk ( hqm_gated_clk )
    , .rst_n ( hqm_gated_rst_n )
    , .status ( status )
    , .in_valid ( in_valid )
    , .in_ready ( in_ready )
    , .in_data ( in_data )
    , .out_valid ( db_out_valid )
    , .out_ready ( out_ready )
    , .out_data ( db_out_data )
    ) ;
  end
  if ( STAGES == 3 ) begin : g_s3
    hqm_AW_triple_buffer # (
      .WIDTH ( WIDTH )
    , .RESET_DATAPATH ( 1 )
    ) i_db (
      .clk ( hqm_gated_clk )
    , .rst_n ( hqm_gated_rst_n )
    , .status ( status )
    , .in_valid ( in_valid )
    , .in_ready ( in_ready )
    , .in_data ( in_data )
    , .out_valid ( db_out_valid )
    , .out_ready ( out_ready )
    , .out_data ( db_out_data )
    ) ;
  end
endgenerate





endmodule
