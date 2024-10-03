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
// wrap hqm_AW_rmw_mem_4pipe_waddr: this is for cases where the bypass address is in-sync with the RMW operation.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_rmw_mem_4pipe
   import hqm_AW_pkg::* ;
# (
    parameter DEPTH = 8
  , parameter WIDTH = 32
  , parameter NO_RDATA_ASSERT = 0
  , parameter RESET_ALL_FLOPS = 0
//................................................................................................................................................
  , parameter DEPTHB2 = (AW_logb2 ( DEPTH -1 ) + 1)
) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        status

  //..............................................................................................................................................
  , input  logic                        p0_v_nxt
  , input  aw_rmwpipe_cmd_t             p0_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_write_data_nxt

  , input  logic                        p0_hold

  , output logic                        p0_v_f
  , output aw_rmwpipe_cmd_t             p0_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p0_data_f

  //..............................................................................................................................................
  , input  logic                        p1_hold

  , output logic                        p1_v_f
  , output aw_rmwpipe_cmd_t             p1_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p1_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p1_data_f

  //..............................................................................................................................................
  , input  logic                        p2_hold

  , output logic                        p2_v_f
  , output aw_rmwpipe_cmd_t             p2_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p2_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_f

  //..............................................................................................................................................
  , input  logic                        p3_hold
  , input  logic                        p3_bypsel_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p3_bypdata_nxt


  , output logic                        p3_v_f
  , output aw_rmwpipe_cmd_t             p3_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p3_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p3_data_f

  //..............................................................................................................................................
  , output logic                        mem_write
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_write_addr
  , output logic [ (   WIDTH ) -1 : 0 ] mem_write_data
  , output logic                        mem_read
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_read_addr
  , input  logic [ (   WIDTH ) -1 : 0 ] mem_read_data

);

hqm_AW_rmw_mem_4pipe_waddr #(
    .DEPTH                              ( DEPTH )
  , .WIDTH                              ( WIDTH )
  , .NO_RDATA_ASSERT                    ( NO_RDATA_ASSERT )
  , .RESET_ALL_FLOPS                    ( RESET_ALL_FLOPS )
) i_rmw_mem_4pipe_waddr (
    .clk                                ( clk )
  , .rst_n                              ( rst_n )
  , .status                             ( status )

  , .p0_v_nxt                           ( p0_v_nxt )
  , .p0_rw_nxt                          ( p0_rw_nxt )
  , .p0_addr_nxt                        ( p0_addr_nxt )
  , .p0_write_data_nxt                  ( p0_write_data_nxt )
  , .p0_hold                            ( p0_hold )
  , .p0_v_f                             ( p0_v_f )
  , .p0_rw_f                            ( p0_rw_f )
  , .p0_addr_f                          ( p0_addr_f )
  , .p0_data_f                          ( p0_data_f )

  , .p1_hold                            ( p1_hold )
  , .p1_v_f                             ( p1_v_f )
  , .p1_rw_f                            ( p1_rw_f )
  , .p1_addr_f                          ( p1_addr_f )
  , .p1_data_f                          ( p1_data_f )

  , .p2_hold                            ( p2_hold )
  , .p2_v_f                             ( p2_v_f )
  , .p2_rw_f                            ( p2_rw_f )
  , .p2_addr_f                          ( p2_addr_f )
  , .p2_data_f                          ( p2_data_f )

  , .p3_hold                            ( p3_hold )
  , .p3_bypdata_sel_nxt                 ( p3_bypsel_nxt )
  , .p3_bypdata_nxt                     ( p3_bypdata_nxt )
  , .p3_bypaddr_sel_nxt                 ( 1'b0 )
  , .p3_bypaddr_nxt                     ( p2_addr_f )
  , .p3_v_f                             ( p3_v_f )
  , .p3_rw_f                            ( p3_rw_f )
  , .p3_addr_f                          ( p3_addr_f )
  , .p3_data_f                          ( p3_data_f )

  , .mem_write                          ( mem_write )
  , .mem_read                           ( mem_read )
  , .mem_write_addr                     ( mem_write_addr )
  , .mem_read_addr                      ( mem_read_addr )
  , .mem_write_data                     ( mem_write_data )
  , .mem_read_data                      ( mem_read_data )
) ;

endmodule
