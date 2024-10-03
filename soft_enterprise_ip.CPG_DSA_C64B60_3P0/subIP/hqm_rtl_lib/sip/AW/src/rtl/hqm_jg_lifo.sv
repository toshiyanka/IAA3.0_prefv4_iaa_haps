//
// common design to be used in assertion code
//
//--------------------------------------------------
module hqm_jg_lifo
 import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
//...............................................................................................................................................
, parameter DEPTHB2 = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHB2P1 = DEPTHB2 + 1
) (
input logic clk
, input logic rst_n
, output logic empty
, output logic full
, input logic push
, input logic [ ( DWIDTH ) - 1 : 0 ] push_data
, input logic pop
, output logic [ ( DWIDTH ) - 1 : 0 ] pop_data
);


//////////////////////////////////////////////////
typedef struct packed {
logic [ ( DEPTH * DWIDTH ) - 1 : 0 ] data ;
logic [ ( DEPTHB2 ) - 1 : 0 ] wp ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] size ;
} state_t ;
state_t state_f , state_nxt ;

always_ff @( posedge clk or negedge rst_n ) begin : a0
  if ( ~ rst_n ) begin
    state_f <= '0 ;
  end else begin
    state_f <= state_nxt ;
  end
end
logic error_lifo ;
logic [ ( DEPTHB2 ) - 1 : 0 ] wpm1 ;
always_comb begin
  empty = ( state_f.size == '0 ) ;
  full = ( state_f.size == DEPTH ) ;

  wpm1 = state_f.wp - 1'b1 ;
  pop_data = state_f.data [ ( wpm1 * DWIDTH ) +: DWIDTH ] ;
  state_nxt = state_f ;
  if ( push ) begin
    state_nxt.data [ ( state_nxt.wp * DWIDTH ) +: DWIDTH ] = push_data ;
    state_nxt.wp = state_nxt.wp + { { { ( DEPTHB2 - 1 ) } { 1'b0 } } , 1'b1 } ;
    state_nxt.size = state_nxt.size + { { { ( DEPTHB2P1 - 1 ) } { 1'b0 } } , 1'b1 } ;
    pop_data = push_data ;
  end 
  if ( pop ) begin
    state_nxt.wp = state_nxt.wp - { { { ( DEPTHB2 - 1 ) } { 1'b0 } } , 1'b1 } ;
    state_nxt.size = state_nxt.size - { { { ( DEPTHB2P1 - 1 ) } { 1'b0 } } , 1'b1 } ;
  end

  error_lifo = ( state_nxt.size > DEPTH [ ( DEPTHB2P1 ) - 1 : 0 ] ) ;
end

//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF
  jg_lifo__check_lifo: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( error_lifo ) ) else begin
   $display ("\nERROR: %t: %m: jg_lifo error detected : error_lifo !!!\n",$time ) ;
  end
`endif

endmodule
