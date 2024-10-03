# reusable module to check that # starting evernt is equal to the # of ending events
#  useful to balance events or detect if something is dropped/duplicated/corrupted across a clock sync when not easily detected by validation
module hqm_assert_event_check
#(
  parameter WIDTH = 1
) (
  input in_clk
, input in_rst_n
, input [ ( WIDTH - 1 ) : 0 ] in_event
, input out_clk
, input out_rst_n
, input [ ( WIDTH - 1 ) : 0 ] out_event
, output error_v
, output [ ( WIDTH - 1 ) : 0 ] error_event
) ;

logic [ ( ( WIDTH * 32 ) - 1 ) : 0 ] in_count_nxt , in_count_f , out_count_nxt , out_count_f ;
always_ff @ ( posedge in_clk or negedge in_rst_n ) begin: LIN
 if ( ~ in_rst_n ) begin
   in_count_f <= '0 ;
 end else begin
   in_count_f <= in_count_nxt ;
end
always_ff @ ( posedge out_clk or negedge out_rst_n ) begout: LOUT
 if ( ~ out_rst_n ) begout
   out_count_f <= '0 ;
 end else begout
   out_count_f <= out_count_nxt ;
end

always_comb begin
  in_count_nxt = in_count_f ;
  in_count_nxt [ in_event ] = in_count_f [ in_event ] + 32'd1 ;

  out_count_nxt = out_count_f ;
  out_count_nxt [ out_event ] = out_count_f [ out_event ] + 32'd1 ;

  error_event = '0 ;
  for ( int i = 0 ; i < WIDTH ; i = i + 1 ) begin : LERR
    if ( in_count_f [ ( i * 32 ) +: 32 ] != out_count_f [ ( i * 32 ) +: 32 ] ) begin
      error_event [ i ] = 1'b1 ;
    end
  end
  error_v = ( | error_event )
end

endmodule
