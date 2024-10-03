//
// common design to be used in assertion code
//
// SAMPLE instantion
//--------------------------------------------------
//  localparam SAMPLE_REQS = 1 ;
//  localparam SAMPLE_DWIDTH = 16 ;
//  logic [ ( REQS ) - 1 : 0 ] SAMPLE_alloc ; 
//  logic [ ( REQS ) - 1 : 0 ] SAMPLE_dealloc ; 
//  logic SAMPLE_inc ;
//  logic SAMPLE_dec ;
//  logic SAMPLE_clr ;
//  logic [ ( SAMPLE_DWIDTH ) - 1 : 0 ] SAMPLE_credit ;
//  hqm_assertion_credit #(
//  .REQS ( SAMPLE_REQS )
//  , .DWIDTH ( SAMPLE_DWIDTH )
//  ) i_assertion_credit_SAMPLE (
//  .clk ( clk )
//  , .rst_n ( rst_n )
//  , .alloc ( SAMPLE_alloc )
//  , .dealloc ( SAMPLE_dealloc )
//  , .inc ( SAMPLE_inc )
//  , .dec ( SAMPLE_dnc )
//  , .clr ( SAMPLE_clr )
//  , .credit ( SAMPLE_credit )
//  );
//--------------------------------------------------

module hqm_assertion_credit
 import hqm_AW_pkg::*; #(
parameter REQS = 1
, parameter DWIDTH = 16
) (
input logic clk
, input logic rst_n
, input logic [ ( REQS ) - 1 : 0 ] alloc
, input logic [ ( REQS ) - 1 : 0 ] dealloc
, input logic inc
, input logic dec
, input logic clr
, output logic [ ( DWIDTH ) - 1 : 0 ] credit
);
logic [ ( DWIDTH ) - 1 : 0 ] credit_f , credit_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    credit_f <= '0 ;
  end
  else begin
    credit_f <= credit_nxt ;
  end
end
always_comb begin
  credit = credit_f ;
  credit_nxt = credit_f ;

  for ( int i = 0 ; i < REQS ; i = i + 1 ) begin
    if ( alloc [ i ] ) begin credit_nxt = credit_nxt + 1'b1 ; end
    if ( dealloc [ i ] ) begin credit_nxt = credit_nxt - 1'b1 ; end
  end
  if ( inc ) begin credit_nxt = credit_nxt + 1'b1 ; end
  if ( dec ) begin credit_nxt = credit_nxt - 1'b1 ; end
  if ( clr ) begin credit_nxt = '0 ; end
end
endmodule
