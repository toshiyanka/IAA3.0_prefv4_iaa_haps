//------------------------------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// hqm_AW_rf_mem_3pipe : 3 stage read pipeline plus write port for regfile with no possibility of read vs. write collision
//
// Functions
//   RAM READ : command is issued on p0_*_nxt input and the data is available on p2_*_f
//   RAM WRITE : command is issued on px_*_nxt interface. The RAM write is issued independently of the read pipe with no comparisons or holds.
//
// Pipeline definition
//   p0 : issue RAM read. Will not issue read unless p1 & p2 stages are not holding. This is to avoid dropping the RAM read request.
//   p1 : pipeline for RAM read access
//   p2 : capture RAM output
//
// connect to 2 port RAM through mem_* interface
// 
// input port to supply hold at p0, p1, or p2 stage.  px does not hold.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_rf_mem_3pipe
   import hqm_AW_pkg::* ;
# (
    parameter DEPTH = 8
  , parameter WIDTH = 32
//................................................................................................................................................
  , parameter DEPTHB2 = (AW_logb2 ( DEPTH -1 ) + 1)
) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        status

  //..............................................................................................................................................
  , input  logic                        p0_v_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_nxt

  , input  logic                        p0_hold

  , output logic                        p0_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_f

  //..............................................................................................................................................
  , input  logic                        p1_hold

  , output logic                        p1_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p1_addr_f

  //..............................................................................................................................................
  , input  logic                        p2_hold

  , output logic                        p2_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p2_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_f

  //..............................................................................................................................................
  , input  logic                        pw_v_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] pw_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] pw_data_nxt

  , output logic                        pw_v_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] pw_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] pw_data_f
  //..............................................................................................................................................
  , output logic                        mem_write
  , output logic                        mem_read
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_write_addr
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_read_addr
  , output logic [ (   WIDTH ) -1 : 0 ] mem_write_data
  , input  logic [ (   WIDTH ) -1 : 0 ] mem_read_data

);

logic [ (   WIDTH ) -1 : 0 ]            p2_data_nobyp_f_nc ;

hqm_AW_rf_mem_3pipe_core #(
    .DEPTH                              ( DEPTH )
  , .WIDTH                              ( WIDTH )
) i_rf_mem_3pipe_core (
    .clk                                ( clk )
  , .rst_n                              ( rst_n )
  , .status                             ( status )

  , .p0_v_nxt                           ( p0_v_nxt )
  , .p0_rd_v_nxt                        ( 1'b1 )
  , .p0_addr_nxt                        ( p0_addr_nxt )
  , .p0_hold                            ( p0_hold )
  , .p0_v_f                             ( p0_v_f )
  , .p0_addr_f                          ( p0_addr_f )

  , .p1_hold                            ( p1_hold )
  , .p1_v_f                             ( p1_v_f )
  , .p1_addr_f                          ( p1_addr_f )

  , .p2_hold                            ( p2_hold )
  , .p2_v_f                             ( p2_v_f )
  , .p2_addr_f                          ( p2_addr_f )
  , .p2_data_f                          ( p2_data_f )
  , .p2_data_nobyp_f                    ( p2_data_nobyp_f_nc )
  , .p2_byp_v_nxt                       ( 1'b0 )
  , .p2_bypdata_nxt                     ( { WIDTH { 1'b0 } } )

  , .pw_v_nxt                           ( pw_v_nxt )
  , .pw_addr_nxt                        ( pw_addr_nxt )
  , .pw_data_nxt                        ( pw_data_nxt )

  , .pw_v_f                             ( pw_v_f )
  , .pw_addr_f                          ( pw_addr_f )
  , .pw_data_f                          ( pw_data_f )

  , .mem_write                          ( mem_write )
  , .mem_read                           ( mem_read )
  , .mem_write_addr                     ( mem_write_addr )
  , .mem_read_addr                      ( mem_read_addr )
  , .mem_write_data                     ( mem_write_data )
  , .mem_read_data                      ( mem_read_data )

);


endmodule // hqm_AW_rf_mem_3pipe
