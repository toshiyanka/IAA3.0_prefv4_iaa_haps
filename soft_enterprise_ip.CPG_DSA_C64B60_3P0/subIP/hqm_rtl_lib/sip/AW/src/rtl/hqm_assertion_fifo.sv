//
// common design to be used in assertion code
//
// SAMPLE instantion
//--------------------------------------------------
//  localparam SAMPLE_DEPTH = 8 ;
//  localparam SAMPLE_DWIDTH = 16 ;
//  logic SAMPLE_push ;
//  logic [ ( SAMPLE_DWIDTH ) - 1 : 0 ] SAMPLE_push_data ;
//  logic SAMPLE_pop ;
//  logic [ ( SAMPLE_DWIDTH ) - 1 : 0 ] SAMPLE_pop_data ;
//  hqm_assertion_fifo #(
//  .DEPTH ( SAMPLE_DEPTH )
//  , .DWIDTH ( SAMPLE_DWIDTH )
//  ) i_assertion_fifo_SAMPLE (
//  .clk ( clk )
//  , .rst_n ( rst_n )
//  , .push ( SAMPLE_push )
//  , .push_data ( SAMPLE_push_data )
//  , .pop ( SAMPLE_pop )
//  , .pop_data ( SAMPLE_pop_data )
//  );
//--------------------------------------------------
//
module hqm_assertion_fifo
 import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
, parameter AWIDTH = ( AW_logb2 ( DEPTH -1 ) + 1 )
) (
input logic clk
, input logic rst_n
, input logic push
, input logic [ ( DWIDTH ) - 1 : 0 ] push_data
, input logic pop
, output logic [ ( DWIDTH ) - 1 : 0 ] pop_data
);
logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] mem_f , mem_nxt ;
logic [ ( AWIDTH ) - 1 : 0 ] rp_nxt , rp_f ;
logic [ ( AWIDTH ) - 1 : 0 ] wp_nxt , wp_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    mem_f <= '0 ;
    rp_f <= '0 ;
    wp_f <= '0 ;
  end
  else begin
    mem_f <= mem_nxt ;
    rp_f <= rp_nxt ;
    wp_f <= wp_nxt ;
  end
end
always_comb begin
  mem_nxt = mem_f ;
  rp_nxt = rp_f ;
  wp_nxt = wp_f ;
  if ( pop ) begin
    rp_nxt = rp_f + 1'b1 ;
    if ( rp_nxt > DEPTH ) begin rp_nxt = '0 ; end
    end
  if ( push ) begin
    mem_nxt [ ( wp_f * DWIDTH ) +: DWIDTH ] = push_data ;
    wp_nxt = wp_f + 1'b1 ;
    if ( wp_nxt > DEPTH ) begin wp_nxt = '0 ; end
  end
  pop_data = mem_f [ ( rp_f * DWIDTH ) +: DWIDTH ] ;
end
endmodule
