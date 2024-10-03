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
//
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_lifo_control
import hqm_AW_pkg::* ;
# (
  parameter DEPTH                                 = 8
, parameter DWIDTH                                = 16
//...............................................................................................................................................
, parameter DEPTHB2                               = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHB2P1                             = ( ( ( 2 ** DEPTHB2 ) == DEPTH ) ? ( DEPTHB2 + 1 ) : DEPTHB2 )
) (
  input  logic                                    clk 
, input  logic                                    rst_n 

, input  logic [ ( DEPTHB2P1 ) - 1 : 0 ]          cfg_high_wm 

, output logic                                    mem_re 
, output logic                                    mem_we 
, output logic [ ( DEPTHB2 ) - 1 : 0 ]            mem_addr 
, output logic [ ( DWIDTH  ) - 1 : 0 ]  mem_wdata 
, input  logic [ ( DWIDTH  ) - 1 : 0 ]  mem_rdata 

, input  logic                                    lifo_push 
, input  logic [ ( DWIDTH ) - 1 : 0 ]             lifo_push_data 
, input  logic                                    lifo_pop 
, output logic [ ( DWIDTH ) - 1 : 0 ]             lifo_pop_data 
, output logic                                    lifo_full 
, output logic                                    lifo_afull 
, output logic                                    lifo_empty 

, output logic                                    status_idle 
, output logic [ ( DEPTHB2P1 - 1 ) : 0 ]          status_size
, output logic                                    error_uf
, output logic                                    error_of
) ;
localparam MSGWIDTH = 1;
logic rw_in_v ;
aw_rwpipe_cmd_t rw_in_cmd ;
logic [ ( DWIDTH ) - 1 : 0 ] rw_in_data ;
logic [ ( DEPTHB2 ) - 1 : 0 ] rw_in_addr ;
logic [ ( MSGWIDTH ) - 1 : 0 ] rw_in_msg ;
logic rw_out_v ; 
aw_rwpipe_cmd_t rw_out_cmd ; 
logic [ ( DEPTHB2 ) - 1 : 0 ] rw_out_addr ; 
logic [ ( DWIDTH ) - 1 : 0 ] rw_out_data ;
logic [ ( MSGWIDTH ) - 1 : 0 ] rw_out_msg ; 
logic rw_idle ;
hqm_AW_lifo_control_rw #(
  .DEPTH ( DEPTH )
, .DWIDTH ( DWIDTH )
, .MSGWIDTH ( MSGWIDTH )
) i_core (
  .clk ( clk )
, .rst_n ( rst_n )
, .mem_re ( mem_re )
, .mem_we ( mem_we )
, .mem_addr ( mem_addr )
, .mem_rdata ( mem_rdata )
, .mem_wdata ( mem_wdata )
, .rw_in_v ( rw_in_v )
, .rw_in_cmd ( rw_in_cmd )
, .rw_in_data ( rw_in_data )
, .rw_in_addr ( rw_in_addr )
, .rw_in_msg ( rw_in_msg )
, .rw_out_v ( rw_out_v )
, .rw_out_cmd ( rw_out_cmd )
, .rw_out_addr ( rw_out_addr )
, .rw_out_data ( rw_out_data )
, .rw_out_msg ( rw_out_msg )
, .status_idle ( rw_idle )
) ;

//---------------------------------------------------------------------------------------------------
typedef struct packed {
logic [ ( DEPTHB2P1 - 1 ) : 0 ] lifo_size ;
logic [ ( DEPTHB2P1 - 1 ) : 0 ] lifo_size_m1 ;
logic [ ( DEPTHB2P1 - 1 ) : 0 ] lifo_size_p1 ;
logic lifo_full ;
logic lifo_afull ;
logic lifo_empty ;
logic lifo_overflow ;
logic lifo_underflow ;
} state_t ;
state_t state_f , state_nxt ;
logic do_push , do_pop ;
logic [ ( DEPTHB2P1 - 1 ) : 0 ] lifo_size_m1 ; 
always_ff @ ( posedge clk or negedge rst_n )
begin
  if ( rst_n == 1'd0 ) begin
    state_f.lifo_size <= '0 ;
    state_f.lifo_size_m1 <= '0;
    state_f.lifo_size_p1 <= '0;
    state_f.lifo_full <= 1'b0 ;
    state_f.lifo_afull <= 1'b0 ;
    state_f.lifo_empty <= 1'b1 ;
    state_f.lifo_overflow <= 1'b0 ;
    state_f.lifo_underflow <= 1'b0 ;
  end else begin
    state_f <= state_nxt ;
  end
end
always_comb begin
  //..................................................
  // flop default
  state_nxt                             = state_f ;

  //..................................................
  // output
  rw_in_v                               = '0 ;
  rw_in_cmd                             = HQM_AW_RWPIPE_NOOP ;
  rw_in_data                            = '0 ;
  rw_in_addr                            = '0 ;
  rw_in_msg                             = '0 ;
  lifo_pop_data                         = rw_out_data ;
  lifo_full                             = state_f.lifo_full ;
  lifo_afull                            = state_f.lifo_afull ;
  lifo_empty                            = state_f.lifo_empty ;
  status_idle                           = rw_idle ;

  //..................................................
  // process input commands & check for error
  do_pop                                = ( lifo_pop & ~ state_f.lifo_empty ) ;
  do_push                               = ( lifo_push & ~ state_f.lifo_full ) ;
  state_nxt.lifo_underflow              = ( lifo_pop & state_f.lifo_empty ) ;
  state_nxt.lifo_overflow               = ( lifo_push & state_f.lifo_full ) ;

  error_of                              = state_nxt.lifo_overflow ;
  error_uf                              = state_nxt.lifo_underflow ;

  if ( do_push | do_pop ) begin
    //................................................
    // calcualte size & state fields
    state_nxt.lifo_size                 = ( state_f.lifo_size + { {(DEPTHB2P1-1){1'b0}} , ( do_push ) } - { {(DEPTHB2P1-1){1'b0}} , ( do_pop ) } ) ;
    state_nxt.lifo_size_m1              = ( state_nxt.lifo_size - { {(DEPTHB2P1-1){1'b0}} , ( 1'b1 ) } ) ;
    state_nxt.lifo_size_p1              = ( state_nxt.lifo_size + { {(DEPTHB2P1-1){1'b0}} , ( 1'b1 ) } ) ;
    state_nxt.lifo_empty                = ( state_nxt.lifo_size == {(DEPTHB2P1){1'b0}} ) ;
    state_nxt.lifo_full                 = ( state_nxt.lifo_size == DEPTH [ ( DEPTHB2P1 - 1 ) : 0 ] ) ;
    state_nxt.lifo_afull                = ( state_nxt.lifo_size >= cfg_high_wm ) ;
  end

  //..................................................
  // process push & pop through RW module
  lifo_size_m1                          = state_f.lifo_size - { {(DEPTHB2P1-1){1'b0}} , ( 1'b1) } ;
  if (   do_push &   do_pop ) begin
    rw_in_v                             = 1'b1 ;
    rw_in_cmd                           = HQM_AW_RWPIPE_NOOP ;
    rw_in_data                          = lifo_push_data ;
    rw_in_addr                          = '0 ;
  end
  if (   do_push & ~ do_pop ) begin
    rw_in_v                             = 1'b1 ;
    rw_in_cmd                           = HQM_AW_RWPIPE_WRITE ;
    rw_in_data                          = lifo_push_data ;
    rw_in_addr                          = state_f.lifo_size [ ( DEPTHB2 ) - 1 : 0 ] ;
  end
  if ( ~ do_push &   do_pop ) begin
    rw_in_v                             = 1'b1 ;
    rw_in_cmd                           = HQM_AW_RWPIPE_READ ;
    rw_in_data                          = '0 ;
    rw_in_addr                          = state_f.lifo_size_m1 [ ( DEPTHB2 ) - 1 : 0 ] ;
  end

  //send muxed flopped size for top level compare
  status_size = state_f.lifo_size ;
  if (   do_push & ~ do_pop ) begin status_size = state_f.lifo_size_p1 ; end
  if ( ~ do_push &   do_pop ) begin status_size = state_f.lifo_size_m1 ; end

end

logic unused_nc ;       // avoid lint warning
assign unused_nc        = | { rw_out_v , rw_out_cmd , rw_out_addr , rw_out_msg , lifo_size_m1 } ;

endmodule // hqm_AW_lifo_control
