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
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_aqed_pipe_nxthp_rw_mem_4pipe_core
   import hqm_AW_pkg::* ;
# (
    parameter DEPTH = 2048

  , parameter ECC = 5
  , parameter PAR = 1
  , parameter DATA = 11
  , parameter PARAM_MASK = {DATA{1'b1}}

  , parameter WIDTH = ECC+PAR+DATA
  , parameter BLOCK_WRITE_ON_P0_HOLD = 0
  , parameter NO_RDATA_ASSERT = 0
//................................................................................................................................................
  , parameter DEPTHB2 = (AW_logb2 ( DEPTH -1 ) + 1)
) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        status

,output logic error_sb 
,output logic error_mb 
,output logic err_parity 

  //..............................................................................................................................................
  , input  logic                        p0_v_nxt
  , input  aw_rwpipe_cmd_t              p0_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_write_data_nxt

  , input  logic                        p0_byp_v_nxt
  , input  aw_rwpipe_cmd_t              p0_byp_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_byp_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_byp_write_data_nxt

  , input  logic                        p0_hold

  , output logic                        p0_v_f
  , output aw_rwpipe_cmd_t              p0_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p0_data_f

  //..............................................................................................................................................
  , input  logic                        p1_hold

  , output logic                        p1_v_f
  , output aw_rwpipe_cmd_t              p1_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p1_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p1_data_f

  //..............................................................................................................................................
  , input  logic                        p2_hold

  , output logic                        p2_v_f
  , output aw_rwpipe_cmd_t              p2_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p2_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p2_data_f

  //..............................................................................................................................................
  , input  logic                        p3_hold

  , output logic                        p3_v_f
  , output aw_rwpipe_cmd_t              p3_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p3_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p3_data_f

  //..............................................................................................................................................
  , output logic                        mem_write
  , output logic                        mem_read
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_addr
  , output logic [ (   WIDTH-1 ) -1 : 0 ] mem_write_data
  , input  logic [ (   WIDTH-1 ) -1 : 0 ] mem_read_data

);

logic [ (   WIDTH ) -1 : 0 ] internal_p2_data_f_pnc ;
logic internal_mem_write ;
logic internal_mem_read ;
logic [ ( DEPTHB2 ) -1 : 0 ] internal_mem_addr ;
logic [ (   WIDTH ) -1 : 0 ] internal_mem_write_data_pnc ;
logic [ (   WIDTH ) -1 : 0 ] internal_mem_read_data ;
logic [ ( ECC ) -1 : 0 ] gen_ecc ;
logic [( DATA ) -1 : 0 ] check_dout ;
logic gen_parity  ;

hqm_AW_rw_mem_4pipe_core #(
    .DEPTH                              ( DEPTH )
  , .WIDTH                              ( WIDTH )
  , .BLOCK_WRITE_ON_P0_HOLD ( 1 )
  , .PARAM_MASK ( PARAM_MASK )
) i_rw_nxthp (
    .clk                                ( clk )
  , .rst_n                              ( rst_n )
  , .status                             ( status )

  , .p0_v_nxt                           ( p0_v_nxt )
  , .p0_rw_nxt                          ( p0_rw_nxt )
  , .p0_addr_nxt                        ( p0_addr_nxt )
  , .p0_write_data_nxt                  ( p0_write_data_nxt )
  , .p0_byp_v_nxt                       ( p0_byp_v_nxt )
  , .p0_byp_rw_nxt                      ( p0_byp_rw_nxt )
  , .p0_byp_addr_nxt                    ( p0_byp_addr_nxt )
  , .p0_byp_write_data_nxt              ( p0_byp_write_data_nxt )
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
  , .p2_data_f                          ( internal_p2_data_f_pnc )

  , .p3_hold                            ( p3_hold )
  , .p3_v_f                             ( p3_v_f )
  , .p3_rw_f                            ( p3_rw_f )
  , .p3_addr_f                          ( p3_addr_f )
  , .p3_data_f                          ( p3_data_f )

  , .mem_write                          ( internal_mem_write )
  , .mem_read                           ( internal_mem_read )
  , .mem_addr                           ( internal_mem_addr )
  , .mem_write_data                     ( internal_mem_write_data_pnc )
  , .mem_read_data                      ( internal_mem_read_data )
) ;

hqm_AW_ecc_gen #(
   .DATA_WIDTH                        ( DATA )
 , .ECC_WIDTH                         ( ECC )
) i_ecc_gen (
   .d                                 ( internal_mem_write_data_pnc[(DATA)-1:0] )
 , .ecc                               ( gen_ecc )
);

logic ecc_check_din_v ;
assign ecc_check_din_v = p2_v_f & ( p2_rw_f == HQM_AW_RWPIPE_READ ) ;
hqm_AW_ecc_check #(
   .DATA_WIDTH                        ( DATA )
 , .ECC_WIDTH                         ( ECC )
) i_ecc_check (
   .din_v                             ( ecc_check_din_v )
 , .din                               ( internal_p2_data_f_pnc[(DATA)-1:0] )
 , .ecc                               ( internal_p2_data_f_pnc[(DATA+1+ECC)-1:(DATA+1)] )
 , .enable                            ( 1'b1 )
 , .correct                           ( 1'b1 )
 , .dout                              ( check_dout )
 , .error_sb                          ( error_sb )
 , .error_mb                          ( error_mb )
);

hqm_AW_parity_gen #(
   .WIDTH                             ( DATA )
) i_parity_gen (
   .d                                 ( check_dout[(DATA)-1:0] )
 , .odd                               ( 1'b1 )
 , .p                                 ( gen_parity )
);

hqm_AW_parity_check #(
   .WIDTH                             ( DATA )
) i_parity_check (
   .p                                 ( internal_mem_write_data_pnc[DATA] )
 , .d                                 ( internal_mem_write_data_pnc[(DATA)-1:0] )
 , .e                                 ( internal_mem_write )
 , .odd                               ( 1'b1 )
 , .err                               ( err_parity )
);

always_comb begin

  //drive control output to RAM
  // * read : pass with no modification
  // * write : convert the parity to ECC => FROM RMW {6'd0, PAR, DATA} -> RAM OUTPUT PORT {ECC , DATA}
  mem_write          = '0 ;
  mem_read           = internal_mem_read ;
  mem_addr           = internal_mem_addr ;
  mem_write_data     = '0 ;
  if ( internal_mem_write ) begin
    mem_write        = 1'b1 ;
    mem_write_data   = { gen_ecc , internal_mem_write_data_pnc[(DATA)-1:0] } ;
  end

  //PAD memory read response  => RAM INPUT PORT {ECC , DATA} -> RMW { PAD, ECC, DATA}
  internal_mem_read_data = {mem_read_data[(DATA+ECC)-1:DATA] , 1'b0 , mem_read_data[(DATA)-1:0] } ;

  // drive corrected read response, strip ECC & regenerate parity
  p2_data_f          = { {ECC{1'b0}} , gen_parity , check_dout[(DATA)-1:0] } ;  

end

endmodule 
