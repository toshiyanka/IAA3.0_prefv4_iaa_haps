//-----------------------------------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_flopfifo_core
  import hqm_AW_pkg::*;
#(
  parameter DEPTH                                 = 8
, parameter DWIDTH                                = 16
, parameter PUSH                                  = 1
, parameter POP                                   = 1
, parameter IDV                                   = 1
, parameter IDWIDTH                               = 1
//...............................................................................................................................................
, parameter DEPTHB2                               = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHB2P1                             = DEPTHB2 + 1
) (
  input  logic                                    clk 
, input  logic                                    rst_n 

, input  logic [ ( PUSH ) - 1 : 0 ]               fifo_push 
, input  logic [ ( PUSH * DWIDTH ) - 1 : 0 ]      fifo_push_data 
, input  logic [ ( POP ) - 1 : 0 ]                fifo_pop 
, output logic [ ( POP ) - 1 : 0 ]                fifo_pop_datav 
, output logic [ ( POP * DWIDTH ) - 1 : 0 ]       fifo_pop_data 
, output logic [ ( DEPTHB2P1 ) - 1 : 0 ]          fifo_size 

, output logic                                    status_idle 
, output logic                                    error 

, input  logic [ ( PUSH * IDWIDTH ) - 1 : 0 ]     fifo_push_id
, input  logic                                    fifo_byp
, input  logic [ ( IDWIDTH ) - 1 : 0 ]            fifo_byp_id
, input  logic [ ( DWIDTH ) - 1 : 0 ]             fifo_byp_data
);

//////////////////////////////////////////////////
typedef struct packed {
logic [ ( DEPTH * DWIDTH ) - 1 : 0 ] data ;
logic [ ( DEPTH * IDWIDTH ) - 1 : 0 ] id ;
logic [ ( DEPTH * 1 ) - 1 : 0 ] datav ;
logic [ ( DEPTHB2 ) - 1 : 0 ] wp ;
logic [ ( DEPTHB2 ) - 1 : 0 ] rp ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] size ;
} state_t ;
state_t state_f , state_nxt ;

logic [ ( DEPTHB2 ) - 1 : 0 ] s_rp ;
always_ff @( posedge clk or negedge rst_n ) begin : a0
  if ( ~ rst_n ) begin
    state_f <= '0 ;
  end else begin
    state_f <= state_nxt ;
  end
end
always_comb begin
  fifo_size = state_f.size ;
  status_idle = ( state_f.size == '0 ) ;
  error = ( state_f.size > DEPTH [ ( DEPTHB2P1 ) - 1 : 0 ] ) ;
  state_nxt = state_f ; 
  for ( int i = 0 ; i < POP ; i = i + 1 ) begin : i0
    s_rp = ( state_f.rp + i [ ( DEPTHB2 ) - 1 : 0 ] ) ;
    fifo_pop_datav [ i ] = state_f.datav [ s_rp ] ;
    fifo_pop_data [ ( i * DWIDTH ) +: DWIDTH ] = state_f.data [ ( s_rp * DWIDTH ) +: DWIDTH ] ;
  end

  if ( ~ error ) begin
    for ( int i = 0 ; i < POP ; i = i + 1 ) begin : i1
      if ( fifo_pop [ i ] ) begin
        state_nxt.datav [ state_nxt.rp ] = 1'b0 ;
        state_nxt.rp = state_nxt.rp + { { { ( DEPTHB2 - 1 ) } { 1'b0 } } , 1'b1 } ;
        if ( { 1'b0 , state_nxt.rp } == DEPTH [ ( DEPTHB2P1 ) - 1 : 0 ] ) begin state_nxt.rp = '0 ; end
        state_nxt.size = state_nxt.size - { { { ( DEPTHB2P1 - 1 ) } { 1'b0 } } , 1'b1 } ;
      end
    end
    for ( int i = 0 ; i < PUSH ; i = i + 1 ) begin : i2
      if ( fifo_push [ i ] ) begin 
        state_nxt.datav [ state_nxt.wp ] = 1'b1 ;
        state_nxt.id [ ( state_nxt.wp * IDWIDTH ) +: IDWIDTH ] = fifo_push_id ;
        state_nxt.data [ ( state_nxt.wp * DWIDTH ) +: DWIDTH ] = fifo_push_data [ ( i * DWIDTH ) +: DWIDTH ] ;
        state_nxt.wp = state_nxt.wp + { { { ( DEPTHB2 - 1 ) } { 1'b0 } } , 1'b1 } ; 
        if ( { 1'b0 , state_nxt.wp } == DEPTH [ ( DEPTHB2P1 ) - 1 : 0 ] ) begin state_nxt.wp = '0 ; end
        state_nxt.size = state_nxt.size + { { { ( DEPTHB2P1 - 1 ) } { 1'b0 } } , 1'b1 } ;
      end
    end
  end

  for ( int i = 0 ; i < DEPTH ; i = i + 1 ) begin : i3
    if ( IDV & fifo_byp & state_nxt.datav [ i ] & ( state_nxt.id [ ( i * IDWIDTH ) +: IDWIDTH ] == fifo_byp_id ) ) begin
       state_nxt.data [ ( state_nxt.wp * DWIDTH ) +: DWIDTH ] =  fifo_byp_data ;
    end
  end

end

endmodule // hqm_AW_flopfifo_core
