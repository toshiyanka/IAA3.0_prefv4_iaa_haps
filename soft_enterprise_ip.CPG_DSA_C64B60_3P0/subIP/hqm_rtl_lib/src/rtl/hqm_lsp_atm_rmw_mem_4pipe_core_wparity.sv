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
// extended hqm_AW_rmw_mem_4pipe
//
// hqm_AW_rmw_mem_4pipe : 4 stage pipeline for RAM read, write and read-modify-write access
//
// Functions
//   RAM READ : command is issued on p0_*_nxt input and the data is avaible on p2_*_f or p3_*_f interfacew
//   RAM WRITE : command is issued on p0_*_nxt interface. THe RAM write is issued on the p3_*_f interface
//   RAM RMW : command is issued on p0_*_nxt interface. The RAM read is issued on p0_*_f and the RAM write is issued on the p3_*_f.
//     * The read source data is supplied on the p2_*_f output port and the modifued updated value is supplied on p3_bypsel interface, the external
//       pipleine must match the hqm_AW_rmw_mem_pipe pipline including holds. 
//
// Pipeline defention
//   p0 : issue RAM read. Will not issue read unless p1 & p2 stages are not holding. THis is to avoid dropping the RAM read request.
//        will avoid read/write to same address and abort the RAM read and capture the new write data into data pipline
//   p1 : pipeline for RAM read access
//   p2 : capture RAM output or bypass internal data to load the latest value
//   p3 : issue RAM write
//
// connect to 2 port (1 read & 1 write) RAM through mem_* interface
// 
// input port to supply hold at p1, p2, or p3 stage
//
// supply each pipe stage valid, command, and address output port for external collision detection or to determine when the pipe is idle.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_lsp_atm_rmw_mem_4pipe_core_wparity
   import hqm_AW_pkg::* ;
# (
    parameter DEPTH = 8
  , parameter WIDTH =13 
  , parameter NO_RDATA_ASSERT = 0
//................................................................................................................................................
  , parameter DEPTHB2 = (AW_logb2 ( DEPTH -1 ) + 1)
) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        status
  , output logic                        error

  //..............................................................................................................................................
  , input  logic                        p0_v_nxt
  , input  aw_rmwpipe_cmd_t             p0_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_write_data_nxt

  , input  logic                        p0_byp_v_nxt
  , input  aw_rmwpipe_cmd_t             p0_byp_rw_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p0_byp_addr_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p0_byp_write_data_nxt

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
  , input  logic                        p3_bypdata_sel_nxt
  , input  logic [ (   WIDTH ) -1 : 0 ] p3_bypdata_nxt
  , input  logic                        p3_bypaddr_sel_nxt
  , input  logic [ ( DEPTHB2 ) -1 : 0 ] p3_bypaddr_nxt

  , output logic                        p3_v_f
  , output aw_rmwpipe_cmd_t             p3_rw_f
  , output logic [ ( DEPTHB2 ) -1 : 0 ] p3_addr_f
  , output logic [ (   WIDTH ) -1 : 0 ] p3_data_f

  //..............................................................................................................................................
  , output logic                        mem_write
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_write_addr
  , output logic [ (   WIDTH+1 ) -1 : 0 ] mem_write_data
  , output logic                        mem_read
  , output logic [ ( DEPTHB2 ) -1 : 0 ] mem_read_addr
  , input  logic [ (   WIDTH+1 ) -1 : 0 ] mem_read_data

);

logic [ (   WIDTH ) -1 : 0 ] p2_data_nxt_nc ;

logic [ (   WIDTH ) -1 : 0 ] wire_mem_write_data ;
logic [ (   WIDTH ) -1 : 0 ] wire_mem_read_data ;
logic parity_gen_wr0 ;
logic parity_gen_wr1 ;
logic parity_err_wr ;
logic parity_err_rd0 ;
logic parity_err_rd1 ;
logic mem_read_f ;
logic err_f ;
always_ff @(posedge clk or negedge rst_n) begin:L00
  if (!rst_n) begin
    mem_read_f <= '0 ;
    err_f <= '0 ;
  end
  else begin
    mem_read_f <= mem_read ;
    err_f <= parity_err_wr | parity_err_rd0 | parity_err_rd1 ;
  end
end

hqm_AW_rmw_mem_4pipe_core # (
          .DEPTH                        ( DEPTH )
        , .WIDTH                        ( WIDTH )
  , .NO_RDATA_ASSERT                    ( NO_RDATA_ASSERT )
) i_hqm_AW_rmw_mem_4pipe_core (
          .clk                          ( clk )
        , .rst_n                        ( rst_n )

        , .status                       ( status )

        , .p0_v_nxt                     ( p0_v_nxt )
        , .p0_rw_nxt                    ( p0_rw_nxt )
        , .p0_addr_nxt                  ( p0_addr_nxt )
        , .p0_write_data_nxt            ( p0_write_data_nxt )

        , .p0_byp_v_nxt                 ( p0_byp_v_nxt )
        , .p0_byp_rw_nxt                ( p0_byp_rw_nxt )
        , .p0_byp_addr_nxt              ( p0_byp_addr_nxt )
        , .p0_byp_write_data_nxt        ( p0_byp_write_data_nxt )

        , .p0_hold                      ( p0_hold )
        , .p0_v_f                       ( p0_v_f )
        , .p0_rw_f                      ( p0_rw_f )
        , .p0_addr_f                    ( p0_addr_f )
        , .p0_data_f                    ( p0_data_f )

        , .p1_hold                      ( p1_hold )
        , .p1_v_f                       ( p1_v_f )
        , .p1_rw_f                      ( p1_rw_f )
        , .p1_addr_f                    ( p1_addr_f )
        , .p1_data_f                    ( p1_data_f )

        , .p2_hold                      ( p2_hold )
        , .p2_v_f                       ( p2_v_f )
        , .p2_rw_f                      ( p2_rw_f )
        , .p2_addr_f                    ( p2_addr_f )
        , .p2_data_nxt                  ( p2_data_nxt_nc )
        , .p2_data_f                    ( p2_data_f )

        , .p3_hold                      ( p3_hold )
        , .p3_bypdata_sel_nxt           ( p3_bypdata_sel_nxt )
        , .p3_bypdata_nxt               ( p3_bypdata_nxt )
        , .p3_bypaddr_sel_nxt           ( p3_bypaddr_sel_nxt )
        , .p3_bypaddr_nxt               ( p3_bypaddr_nxt )
        , .p3_v_f                       ( p3_v_f )
        , .p3_rw_f                      ( p3_rw_f )
        , .p3_addr_f                    ( p3_addr_f )
        , .p3_data_f                    ( p3_data_f )

        , .mem_write                    ( mem_write )
        , .mem_write_addr               ( mem_write_addr )
        , .mem_write_data               ( wire_mem_write_data )
        , .mem_read                     ( mem_read )
        , .mem_read_addr                ( mem_read_addr )
        , .mem_read_data                ( wire_mem_read_data )
) ;

//--------------------------------------------------
// Translate wire_mem_write_data from RMW to mem_write_data to port with modified parity to improve protection

hqm_AW_parity_check #(
 .WIDTH ( 12 )
) i_parity_check_wr (
   .p ( wire_mem_write_data[12] )
 , .d ( wire_mem_write_data[11:0] )
 , .e ( mem_write )
 , .odd ( 1'b1 )
 , .err ( parity_err_wr )
);

hqm_AW_parity_gen #(
 .WIDTH ( 6 )
) i_parity_gen_wr0 (
   .d ( { wire_mem_write_data[11] , wire_mem_write_data[9] , wire_mem_write_data[7] , wire_mem_write_data[5] , wire_mem_write_data[3] , wire_mem_write_data[1] } )
 , .odd ( 1'b1 )
 , .p ( parity_gen_wr0 )
);

hqm_AW_parity_gen #(
 .WIDTH ( 6 )
) i_parity_gen_wr1 (
   .d ( { wire_mem_write_data[10] , wire_mem_write_data[8] , wire_mem_write_data[6] , wire_mem_write_data[4] , wire_mem_write_data[2] , wire_mem_write_data[0] } )
 , .odd ( 1'b1 )
 , .p ( parity_gen_wr1 )
);
assign mem_write_data[13] = parity_gen_wr0 ;
assign mem_write_data[12] = parity_gen_wr1 ;
assign mem_write_data[11:0] = wire_mem_write_data[11:0] ;
//--------------------------------------------------

//--------------------------------------------------
// Translate mem_read_data from RMW to wire_mem_read_data

hqm_AW_parity_check #(
 .WIDTH ( 6 )
) i_parity_check_rd0 (
   .p ( mem_read_data[13] )
 , .d ( { mem_read_data[11] , mem_read_data[9] , mem_read_data[7] , mem_read_data[5] , mem_read_data[3] , mem_read_data[1] } )
 , .e ( mem_read_f )
 , .odd ( 1'b1 )
 , .err ( parity_err_rd0 )
);

hqm_AW_parity_check #(
 .WIDTH ( 6 )
) i_parity_check_rd1 (
   .p ( mem_read_data[12] )
 , .d ( { mem_read_data[10] , mem_read_data[8] , mem_read_data[6] , mem_read_data[4] , mem_read_data[2] , mem_read_data[0] } )
 , .e ( mem_read_f )
 , .odd ( 1'b1 )
 , .err ( parity_err_rd1 )
);

assign wire_mem_read_data[12] = 1'b1 ^ mem_read_data[13] ^ mem_read_data[12] ;
assign wire_mem_read_data[11:0] = mem_read_data[11:0] ;
//--------------------------------------------------

assign error = err_f ;

endmodule
