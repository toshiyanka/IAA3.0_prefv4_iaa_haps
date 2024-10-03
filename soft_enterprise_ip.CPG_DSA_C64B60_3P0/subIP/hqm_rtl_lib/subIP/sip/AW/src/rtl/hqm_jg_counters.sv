module hqm_jg_counters
 import hqm_AW_pkg::*; #(
parameter NUM = 1
, parameter DWIDTH = 16
, parameter CHECK_UF = 1
, parameter CHECK_WRAP = 1
) (
input logic clk
, input logic rst_n
, input logic [ ( NUM ) - 1 : 0 ] inc
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] inc_amount
, input logic [ ( NUM ) - 1 : 0 ] dec
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] dec_amount
, input logic [ ( NUM ) - 1 : 0 ] clr
, input logic [ ( NUM ) - 1 : 0 ] load
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] load_value
, input logic [ ( NUM ) - 1 : 0 ] sat
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] sat_amount
, input logic [ ( NUM ) - 1 : 0 ] wrap 
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] wrap_amount
, input logic [ ( NUM ) - 1 : 0 ] full
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] full_amount
, output logic [ ( NUM * DWIDTH ) - 1 : 0 ] counter
, output logic [ ( NUM ) - 1 : 0 ] counter_full
);
logic [ ( NUM ) - 1 : 0 ] [ ( DWIDTH + 1 ) - 1 : 0 ] counter_f , counter_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    counter_f <= '0 ;
  end
  else begin
    counter_f <= counter_nxt ;
  end
end
logic error_wrap ;
logic error_of ;
logic [ ( DWIDTH ) - 1 : 0 ] wrap_delta ;
always_comb begin
  counter_full = '0 ;
  counter = counter_f ;
  counter_nxt = counter_f ;
  error_wrap = '0 ;
  error_of = '0 ;
  wrap_delta = '0 ;

  for ( int i = 0 ; i < NUM ; i = i + 1 ) begin

    if ( counter_f [ i ] == full_amount [ ( i * DWIDTH ) +: DWIDTH ] ) begin counter_full [ i ] = 1'b1 ; end

    if ( inc [ i ] ) begin
      counter_nxt [ i ] = counter_nxt [ i ] + inc_amount [ ( i * DWIDTH ) +: DWIDTH ] ;
    end
    if ( dec [ i ] ) begin
      counter_nxt [ i ] = counter_nxt [ i ] - dec_amount [ ( i * DWIDTH ) +: DWIDTH ] ;
    end

    if ( sat [ i ] ) begin 
      if ( counter_nxt [ i ] >= sat_amount [ ( i * DWIDTH ) +: DWIDTH ] ) begin
        counter_nxt [ i ] = sat_amount [ ( i * DWIDTH ) +: DWIDTH ] ;
      end
    end
  
    wrap_delta = ( inc_amount [ ( i * DWIDTH ) +: DWIDTH ] ) ;
    if ( dec [ i ] & inc [ i ] ) begin wrap_delta =  ( inc_amount [ ( i * DWIDTH ) +: DWIDTH ] - dec_amount [ ( i * DWIDTH ) +: DWIDTH ] ) ; end
    if ( wrap [ i ] ) begin
      if ( counter_nxt [ i ] >= wrap_amount [ ( i * DWIDTH ) +: DWIDTH ] ) begin
        error_wrap = CHECK_WRAP ;
        counter_nxt [ i ] = ( counter_nxt [ i ] - wrap_amount [ ( i * DWIDTH ) +: DWIDTH ] ) ;
      end
    end

    if ( clr [ i ] ) begin counter_nxt [ i ] = '0 ; end

    if ( load [ i ] ) begin counter_nxt [ i ] = load_value [ ( i * DWIDTH ) +: DWIDTH ] ; end
    
    if ( counter_nxt [ i ] > 2**DWIDTH ) begin error_of = CHECK_WRAP ; counter_nxt [ i ] = '0 ; end

  end
end

//--------------------------------------------------------------------------------------------
// Assertions
logic error_uf ;
logic [ ( DWIDTH ) - 1 : 0 ] uf_delta ;
always_comb begin
  error_uf = '0 ;
  for ( int i = 0 ; i < NUM ; i = i + 1 ) begin
    uf_delta = ( dec_amount [ ( i * DWIDTH ) +: DWIDTH ] ) ;
    if ( dec [ i ] & inc [ i ] ) begin uf_delta =  ( dec_amount [ ( i * DWIDTH ) +: DWIDTH ] - inc_amount [ ( i * DWIDTH ) +: DWIDTH ] ) ; end
    if ( dec [ i ] & ( uf_delta > counter_f [ i ] ) ) begin error_uf = CHECK_UF ; end
  end
end
`ifndef INTEL_SVA_OFF
  jg_counters__check_wrap: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( error_wrap ) ) else begin
   $display ("\nERROR: %t: %m: jg_counters error detected : error_wrap !!!\n",$time ) ;
  end
  jg_counters__check_of: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( error_of ) ) else begin
   $display ("\nERROR: %t: %m: jg_counters error detected : error_of !!!\n",$time ) ;
  end
  jg_counters__check_uf: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( error_uf ) ) else begin
   $display ("\nERROR: %t: %m: jg_counters error detected : error_uf !!!\n",$time ) ;
  end
`endif

endmodule
