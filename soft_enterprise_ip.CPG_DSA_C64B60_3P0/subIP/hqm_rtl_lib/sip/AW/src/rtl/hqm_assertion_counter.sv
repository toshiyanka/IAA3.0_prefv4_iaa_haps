//
// common design to be used in assertion code
//
// SAMPLE instantion
//--------------------------------------------------
//  localparam SAMPLE_NUM = 1 ;
//  localparam SAMPLE_DWIDTH = 16 ;
//  logic [ ( SAMPLE_NUM ) - 1 : 0 ] SAMPLE_inc ;
//  logic [ ( SAMPLE_NUM * SAMPLE_DWIDTH ) - 1 : 0 ] SAMPLE_inc_amount ;
//  logic [ ( SAMPLE_NUM ) - 1 : 0 ] SAMPLE_dec ;
//  logic [ ( SAMPLE_NUM * SAMPLE_DWIDTH ) - 1 : 0 ] SAMPLE_dec_amount ;
//  logic [ ( SAMPLE_NUM ) - 1 : 0 ] SAMPLE_clr ;
//  logic [ ( SAMPLE_NUM ) - 1 : 0 ] SAMPLE_load ;
//  logic [ ( SAMPLE_NUM * SAMPLE_DWIDTH ) - 1 : 0 ] SAMPLE_load_value ;
//  logic [ ( SAMPLE_NUM * SAMPLE_DWIDTH ) - 1 : 0 ] SAMPLE_counter ;
//  hqm_assertion_counter #(
//  .NUM ( SAMPLE_NUM )
//  , .DWIDTH ( SAMPLE_DWIDTH )
//  ) i_assertion_counter_SAMPLE (
//  .clk ( clk )
//  , .rst_n ( rst_n )
//  , .inc ( SAMPLE_inc )
//  , .inc_amount ( SAMPLE_inc_amount )
//  , .dec ( SAMPLE_dec )
//  , .dec_amount ( SAMPLE_dec_amount )
//  , .clr ( SAMPLE_clr )
//  , .load ( SAMPLE_load )
//  , .load_value ( SAMPLE_load_value )
//  , .counter ( SAMPLE_counter )
//  );
//--------------------------------------------------
//
module hqm_assertion_counter
 import hqm_AW_pkg::*; #(
parameter NUM = 1
, parameter DWIDTH = 16
) (
input logic clk
, input logic rst_n
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] rst_val
, input logic [ ( NUM ) - 1 : 0 ] inc
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] inc_amount
, input logic [ ( NUM ) - 1 : 0 ] dec
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] dec_amount
, input logic [ ( NUM ) - 1 : 0 ] clr
, input logic [ ( NUM ) - 1 : 0 ] load
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] load_value
, output logic [ ( NUM * DWIDTH ) - 1 : 0 ] counter
);
logic [ ( NUM * DWIDTH ) - 1 : 0 ] counter_f , counter_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    counter_f <= rst_val ;
  end
  else begin
    counter_f <= counter_nxt ;
  end
end
always_comb begin
  counter = counter_f ;
  counter_nxt = counter_f ;
  for ( int i = 0 ; i < NUM ; i = i + 1 ) begin
    if ( inc [ i ] ) begin counter_nxt [ ( i * DWIDTH ) +: DWIDTH ] = counter_nxt [ ( i * DWIDTH ) +: DWIDTH ] + inc_amount [ ( i * DWIDTH ) +: DWIDTH ] ; end
    if ( dec [ i ] ) begin counter_nxt [ ( i * DWIDTH ) +: DWIDTH ] = counter_nxt [ ( i * DWIDTH ) +: DWIDTH ] - dec_amount [ ( i * DWIDTH ) +: DWIDTH ] ; end
    if ( clr [ i ] ) begin counter_nxt [ ( i * DWIDTH ) +: DWIDTH ] = '0 ; end
    if ( load [ i ] ) begin counter_nxt [ ( i * DWIDTH ) +: DWIDTH ] = load_value [ ( i * DWIDTH ) +: DWIDTH ] ; end
  end
end
endmodule
