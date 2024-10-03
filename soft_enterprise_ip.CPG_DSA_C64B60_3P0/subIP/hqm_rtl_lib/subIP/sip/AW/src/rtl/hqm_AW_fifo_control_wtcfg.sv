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
//
// AW_fifo_control_wtcfg
//  *only supports 1 CFG target
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_wtcfg
import hqm_AW_pkg::* ;
# (
    parameter DEPTH                     = 8
  , parameter DWIDTH                    = 16
  , parameter DEFAULT_HWM               = 1
  , parameter DEFAULT_HWM_PAR               = 1'b1 ^ DEFAULT_HWM[7] ^ DEFAULT_HWM[6] ^ DEFAULT_HWM[5] ^ DEFAULT_HWM[4] ^ DEFAULT_HWM[3] ^ DEFAULT_HWM[2] ^ DEFAULT_HWM[1] ^ DEFAULT_HWM[0] 
  //...............................................................................................................................................
  , parameter DEPTHB2                   = ( AW_logb2 ( DEPTH -1 ) + 1 )
  , parameter DEPTHWIDTH                = ( AW_logb2 ( DEPTH    ) + 1 )
  , parameter WMWIDTH                   = ( AW_logb2 ( DEPTH +1 ) + 1 )
  ) (
    input  logic                        clk
  , input  logic                        rst_n

  , output logic                        error_of
  , output logic                        error_uf

  , input  logic                        cfg_write
  , input  logic                        cfg_read
  , input cfg_req_t cfg_req
  , output logic                        cfg_ack
  , output logic                        cfg_err
  , output logic [( 32 ) -1 : 0]        cfg_rdata

  , input  logic                        push
  , input  logic [( DWIDTH ) -1 : 0]    push_data
  , input  logic                        pop
  , output logic [( DWIDTH ) -1 : 0]    pop_data

  , output logic                        mem_we
  , output logic [( DEPTHB2 ) -1 : 0]   mem_waddr
  , output logic [( DWIDTH ) -1 : 0]    mem_wdata
  , output logic                        mem_re
  , output logic [( DEPTHB2 ) -1 : 0]   mem_raddr
  , input  logic [( DWIDTH ) -1 : 0]    mem_rdata

  , output logic                        fifo_full
  , output logic                        fifo_afull
  , output logic                        fifo_empty
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
// local paramters & typedefs

typedef struct packed {
logic  enbl ;
logic  rdenbl ;
logic  hold ;
logic  bypsel ;
} pipe_ctrl_t ;

typedef struct packed {
logic [ ( DEPTHB2 ) -1 : 0 ] wp ;
logic [ ( DEPTHB2 ) -1 : 0 ] rp ;
logic  mem_re ;
logic [ ( DEPTHWIDTH ) -1 : 0 ] fifo_size ;
logic  fifo_full ;
logic  fifo_afull ;
logic  fifo_empty ;
logic  fifo_overflow ;
logic  fifo_underflow ;
} pipe_state_t ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers

logic [ ( 32 ) -1 : 0 ] reg_f , reg_nxt ; 
hqm_AW_register_wtcfg #(
 .WIDTH ( 32 )
,.DEFAULT ( DEFAULT_HWM )
) i_hqm_AW_register_wtcfg (
  .clk ( clk )
, .rst_n ( rst_n )
, .reg_nxt ( reg_nxt )
, .reg_f ( reg_f )
, .cfg_write ( cfg_write )
, .cfg_read ( cfg_read )
, .cfg_req ( cfg_req )
, .cfg_ack ( cfg_ack )
, .cfg_err ( cfg_err )
, .cfg_rdata ( cfg_rdata )
);
logic [ ( 32 ) -1 : 0 ] fifo_status ;



logic parity_f , parity_nxt ;
always_ff @(posedge clk or negedge rst_n) begin:L08
  if (!rst_n) begin
    parity_f <= DEFAULT_HWM_PAR ;
  end
  else begin
    parity_f <= parity_nxt ;
  end
end

logic parity_gen_cfg_p ;
hqm_AW_parity_gen #(
   .WIDTH ( WMWIDTH )
) i_parity_gen_cfg_d (
   .d ( cfg_req.wdata[ ( WMWIDTH ) -1 : 0 ] )
 , .odd ( 1'b1 )
 , .p ( parity_gen_cfg_p )
);

logic parity_check_error ;
hqm_AW_parity_check #(
   .WIDTH ( WMWIDTH )
) i_parity_check_rmw_dir_hp_p2 (
   .p ( parity_f )
 , .d ( reg_f[ ( WMWIDTH ) -1 : 0 ] )
 , .e ( 1'b1 )
 , .odd ( 1'b1 )
 , .err ( parity_check_error )
);

always_comb begin
  parity_nxt = parity_f ;
  reg_nxt = { fifo_status[23:0] , reg_f[7:0] } ;
  if ( parity_check_error ) begin
    parity_nxt = DEFAULT_HWM_PAR ;
    reg_nxt[7:0] = DEFAULT_HWM ;
  end
  if ( cfg_write ) begin
    parity_nxt = parity_gen_cfg_p ;
  end
end




hqm_AW_fifo_control #(
  .DEPTH ( DEPTH ) 
, .DWIDTH ( DWIDTH )
) i_hqm_AW_fifo_control (
  .clk ( clk )
, .rst_n ( rst_n )
, .push ( push )
, .push_data ( push_data )
, .pop ( pop )
, .pop_data ( pop_data )
, .cfg_high_wm ( reg_f[ ( WMWIDTH ) -1 : 0 ] )
, .mem_we ( mem_we )
, .mem_waddr ( mem_waddr )
, .mem_wdata ( mem_wdata )
, .mem_re ( mem_re )
, .mem_raddr ( mem_raddr )
, .mem_rdata ( mem_rdata )
, .fifo_status ( fifo_status )
, .fifo_full ( fifo_full )
, .fifo_afull ( fifo_afull )
, .fifo_empty ( fifo_empty )
); 
assign error_of = fifo_status[1] ;
assign error_uf = fifo_status[0] | parity_check_error ;

endmodule
