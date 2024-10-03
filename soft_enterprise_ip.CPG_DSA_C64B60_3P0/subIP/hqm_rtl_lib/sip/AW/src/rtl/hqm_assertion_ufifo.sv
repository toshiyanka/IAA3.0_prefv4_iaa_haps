//
// common design to be used in assertion code
//
// hqm_assertion_ufifo #(
// .DEPTH (  )
// , .DWIDTH (  )
// ) i_assertion_ufifo (
// .clk (  )
// , .rst_n (  )
// , .push (  )
// , .push_data (  )
// , .pop (  )
// , .pop_data (  )
// , .pop_v (  )
// , .init ( )
// , .init_amount (  )
// , .append (  )
// , .append_amount (  )
// , .write (  )
// , .write_addr (  )
// , .write_data (  )
// , .empty (  )
// , .full (  )
// , .afull ( ) 
// , .of (  )
// , .uf (  )
// , .rp (  )
// , .wp (  )
// , .hwm ( )
// , .size ( )
// );
module hqm_assertion_ufifo
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
, output logic pop_v
, input logic init 
, input logic [ ( AWIDTH ) - 1 : 0 ] init_amount
, input logic append
, input logic [ ( AWIDTH ) - 1 : 0 ] append_amount
, input logic write
, input logic [ ( AWIDTH ) - 1 : 0 ] write_addr
, input logic [ ( DWIDTH ) - 1 : 0 ] write_data
, output logic empty
, output logic full
, output logic afull
, output logic of
, output logic uf
, output logic [ ( AWIDTH ) - 1 : 0 ] rp
, output logic [ ( AWIDTH ) - 1 : 0 ] wp
, input logic [ ( AWIDTH + 1 ) - 1 : 0 ] hwm
, output logic [ ( AWIDTH + 1 ) - 1 : 0 ] size
);
logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] mem_f , mem_nxt ;
logic [ ( AWIDTH ) - 1 : 0 ] rp_nxt , rp_f ;
logic [ ( AWIDTH ) - 1 : 0 ] wp_nxt , wp_f ;
logic [ ( DEPTH ) - 1 : 0 ] v_nxt , v_f ;
logic [ ( AWIDTH ) - 1 : 0 ] size_nxt , size_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    mem_f <= '0 ;
    rp_f <= '0 ;
    wp_f <= '0 ;
    v_f <= '0 ;
    size_f <= '0 ;
  end
  else begin
    mem_f <= mem_nxt ;
    rp_f <= rp_nxt ;
    wp_f <= wp_nxt ;
    v_f <= v_nxt ;
    size_f <= size_nxt ;
  end
end
always_comb begin
  empty = ( v_f == '0 ) ;
  full = ( v_f == '1 ) ;
  rp = rp_f ;
  wp = wp_f ;
  mem_nxt = mem_f ;
  rp_nxt = rp_f ;
  wp_nxt = wp_f ;
  v_nxt = v_f ;
  size = size_f ;
  size_nxt = size_f + push - pop ;
  of = '0 ;
  uf = '0 ;
  afull = ( size_f >= hwm ) ;
  if ( pop ) begin 
    if ( size_f == '0 ) begin uf = 1'b1 ; end
    rp_nxt = rp_f + 1'b1 ;
    if ( rp_nxt > DEPTH ) begin rp_nxt = '0 ; end
     v_nxt [ rp_f ] = 1'b0 ;
   end
  if ( push ) begin
    if ( size_f == DEPTH ) begin of = 1'b1 ; end
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
  end
  if ( append ) begin
    wp_nxt = wp_f + init_amount ;
  end
  if ( write ) begin
     mem_nxt [ ( write_addr * DWIDTH ) +: DWIDTH ] = write_data ;
     v_nxt [ write_addr ] = 1'b1 ; 
  end
end
endmodule
