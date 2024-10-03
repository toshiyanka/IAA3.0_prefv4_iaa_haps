//
// common design to be used in assertion code
//
module hqm_assertion_ofifo
 import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
, parameter AWIDTH = ( AW_logb2 ( DEPTH -1 ) + 1 )
, parameter DEPTHWIDTH  = ( AW_logb2 ( DEPTH ) + 1 )
) (
input logic clk
, input logic rst_n
, input logic [ ( DEPTHWIDTH ) - 1 : 0 ] low_wm
, input logic push
, input logic [ ( DWIDTH ) - 1 : 0 ] push_data
, input logic pop
, output logic [ ( DWIDTH ) - 1 : 0 ] pop_data
, output logic pop_v
, input logic init 
, input logic [ ( AWIDTH ) - 1 : 0 ] init_amount
, input logic append
, input logic [ ( AWIDTH ) - 1 : 0 ] append_amount
, input logic write
, input logic [ ( AWIDTH ) - 1 : 0 ] write_addr         // Adjusted externally if larger shared RAM
, input logic [ ( DWIDTH ) - 1 : 0 ] write_data

, output logic empty
, output logic aempty
, output logic full
, output logic [ ( DEPTHWIDTH ) - 1 : 0 ] fifo_depth

, output logic [ ( AWIDTH ) - 1 : 0 ] rp
, output logic [ ( AWIDTH ) - 1 : 0 ] wp

);
logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] mem_f , mem_nxt ;
logic [ ( AWIDTH ) - 1 : 0 ] rp_nxt , rp_f ;
logic [ ( AWIDTH ) - 1 : 0 ] wp_nxt , wp_f ;
logic [ ( DEPTH ) - 1 : 0 ] v_nxt , v_f ;

assign fifo_depth = ( wp_f > rp_f ) ? ( wp_f - rp_f ) : ( v_f == '0 ) ? 0 : ( DEPTH - ( rp_f - wp_f ) ) ;

always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    mem_f <= '0 ;
    rp_f <= '0 ;
    wp_f <= '0 ;
    v_f <= '0 ;
  end
  else begin
    mem_f <= mem_nxt ;
    rp_f <= rp_nxt ;
    wp_f <= wp_nxt ;
    v_f <= v_nxt ;
  end
end
always_comb begin
  empty = ( v_f == '0 ) ;
  full = ( v_f == '1 ) ;
  aempty = ( fifo_depth <= low_wm ) ;
  rp = rp_f ;
  wp = wp_f ;
  mem_nxt = mem_f ;
  rp_nxt = rp_f ;
  wp_nxt = wp_f ;
  v_nxt = v_f ;
  if ( pop ) begin 
    rp_nxt = rp_f + 1'b1 ;
    if ( rp_nxt > DEPTH ) begin rp_nxt = '0 ; end
     v_nxt [ rp_f ] = 1'b0 ;
   end
  if ( push ) begin
    mem_nxt [ ( wp_f * DWIDTH ) +: DWIDTH ] = push_data ;
    wp_nxt = wp_f + 1'b1 ;
    if ( wp_nxt > DEPTH ) begin wp_nxt = '0 ; end
    v_nxt [ wp_f ] = 1'b1 ;
  end
  pop_data = mem_f [ ( rp_f * DWIDTH ) +: DWIDTH ] ;
  pop_v = v_f [ rp_f ] ;
  if ( init ) begin
    rp_nxt = '0 ;
    wp_nxt = init_amount ;
    v_nxt  = '0 ;
  end
  if ( append ) begin
    wp_nxt = wp_f + append_amount ;
  end
  if ( write ) begin
     mem_nxt [ ( write_addr * DWIDTH ) +: DWIDTH ] = write_data ;
     v_nxt [ write_addr ] = 1'b1 ; 
  end
end
endmodule
