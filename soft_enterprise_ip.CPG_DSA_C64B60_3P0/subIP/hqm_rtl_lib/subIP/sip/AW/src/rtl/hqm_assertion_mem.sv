//
// common design to be used in assertion code
//
// SAMPLE instantion
//--------------------------------------------------
//  localpamem SAMPLE_DEPTH = 8 ;
//  localpamem SAMPLE_DWIDTH = 16 ;
//  localpamem SAMPLE_AWIDTH = ( AW_logb2 ( SAMPLE_DEPTH -1 ) + 1 ) ;
//  logic SAMPLE_we ;
//  logic [ ( SAMPLE_AWIDTH - 1 ) : 0 ] SAMPLE_waddr ;
//  logic [ ( SAMPLE_DWIDTH - 1 ) : 0 ] SAMPLE_wdata ;
//  logic SAMPLE_re ;
//  logic [ ( SAMPLE_AWIDTH - 1 ) : 0 ] SAMPLE_raddr ;
//  logic [ ( SAMPLE_DWIDTH - 1 ) : 0 ] SAMPLE_rdata ;
//  hqm_assertion_mem #(
//  .DEPTH ( SAMPLE_DEPTH )
//  , .DWIDTH ( SAMPLE_DWIDTH )
//  ) i_assertion_mem_SAMPLE (
//  .clk ( clk )
//  , .rst_n ( rst_n )
//  , .we ( SAMPLE_we )
//  , .waddr ( SAMPLE_waddr )
//  , .wdata ( SAMPLE_wdata )
//  , .re ( SAMPLE_re )
//  , .raddr ( SAMPLE_raddr )
//  , .rdata ( SAMPLE_rdata )
//  );
//--------------------------------------------------
//
module hqm_assertion_mem 
import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
, parameter AWIDTH = ( AW_logb2 ( DEPTH -1 ) + 1 )
, parameter INIT = 0
) (
input logic clk
, input logic rst_n
, input logic we
, input logic [ ( AWIDTH - 1 ) : 0 ] waddr
, input logic [ ( DWIDTH - 1 ) : 0 ] wdata
, input logic re
, input logic [ ( AWIDTH - 1 ) : 0 ] raddr
, output logic [ ( DWIDTH - 1 ) : 0 ] rdata
);

logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] mem_f ;
logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] mem_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    mem_f <= INIT ;
  end
  else begin
    mem_f <= mem_nxt ;
  end
end

always_comb begin
  mem_nxt = mem_f ;
  if ( re ) begin rdata = mem_f [ ( raddr * DWIDTH ) +: DWIDTH ] ; end
  if ( we ) begin mem_nxt [ ( waddr * DWIDTH ) +: DWIDTH ] = wdata ; end
end
endmodule
