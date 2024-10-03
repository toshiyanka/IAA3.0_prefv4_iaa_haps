module hqm_jg_countdown
 import hqm_AW_pkg::*; #(
parameter NUM = 1 //number of countdown, start with start_countdown when start issued,  stall count when stall issued, repoort error if countdown expires
, parameter DWIDTH = 16
, parameter CHECK_DONE = 1
, parameter CHECK_ACTIVE = 1
) (
input logic clk
, input logic rst_n
, input logic [ ( NUM ) - 1 : 0 ] start
, input logic [ ( NUM * DWIDTH ) - 1 : 0 ] start_countdown
, input logic [ ( NUM ) - 1 : 0 ] done
, input logic [ ( NUM ) - 1 : 0 ] stall
);
logic [ ( DWIDTH ) - 1 : 0 ] countdown_f[(NUM-1) : 0];
logic [ ( DWIDTH ) - 1 : 0 ] countdown_nxt[(NUM-1) : 0];
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    for (int i = 0 ; i <NUM; i = i + 1) begin
      countdown_f[i] <= '0 ;
    end
  end
  else begin
    for (int i = 0 ; i <NUM; i = i + 1) begin
    countdown_f[i] <= countdown_nxt[i] ;
    end
  end
end

logic [ ( NUM ) - 1 : 0 ] error_expire ;
logic [ ( NUM ) - 1 : 0 ] error_done ;
logic [ ( NUM ) - 1 : 0 ] error_active ;
always_comb begin
  error_expire = '0 ;
  error_done = '0 ;
  error_active = '0 ;
  countdown_nxt = countdown_f ;

  for ( int i = 0 ; i < NUM ; i = i + 1 ) begin

    if ( ( ~ stall [ i ] )
       & ( ~ done [ i ] )
       & ( countdown_f [ i ] > 1'b0 )
       ) begin
      countdown_nxt [ i ] = countdown_f [ i ] - 1'b1 ;
      error_expire [ i ]  = ( countdown_f [ i ] == 1'b1 ) ;
    end

    if ( start [ i ] ) begin
      if ( countdown_f [ i ] > 1'b0 ) begin error_active = CHECK_ACTIVE ; end
      countdown_nxt [ i ] = start_countdown [ ( i * DWIDTH ) +: DWIDTH ] ;
    end

    if ( done [ i ] ) begin 
      countdown_nxt [ i ] = '0 ;
      if ( countdown_f [ i ] == 1'b0 ) begin error_done [ i ] = CHECK_DONE ; end
    end

  end
end

//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF
  jg_countdown__check_expire : assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error_expire ) ) else begin
   $display ("\nERROR: %t: %m: jg_countdown error detected : error_expire !!!\n",$time ) ;
  end
  jg_countdown__check_done : assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error_done ) ) else begin
   $display ("\nERROR: %t: %m: jg_countdown error detected : error_done !!!\n",$time ) ;
  end
  jg_countdown__check_active : assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error_active ) ) else begin
   $display ("\nERROR: %t: %m: jg_countdown error detected : error_active !!!\n",$time ) ;
  end

`endif

endmodule
