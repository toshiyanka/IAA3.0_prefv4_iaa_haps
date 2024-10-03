//
// common design to be used in assertion code ( cycle accurate )
//
// SAMPLE instantion
//--------------------------------------------------
//  localparam SAMPLE_DEPTH = 8 ;
//  localparam SAMPLE_DWIDTH = 16 ;
//  localparam SAMPLE_AWIDTH = ( AW_logb2 ( SAMPLE_DEPTH -1 ) + 1 ) ;
//  logic SAMPLE_ram_we ;
//  logic [ ( SAMPLE_AWIDTH - 1 ) : 0 ] SAMPLE_ram_waddr ;
//  logic [ ( SAMPLE_DWIDTH - 1 ) : 0 ] SAMPLE_ram_wdata ;
//  logic SAMPLE_ram_we2 ;
//  logic [ ( SAMPLE_AWIDTH - 1 ) : 0 ] SAMPLE_ram_waddr2 ;
//  logic [ ( SAMPLE_DWIDTH - 1 ) : 0 ] SAMPLE_ram_wdata2 ;
//  logic SAMPLE_ram_re ;
//  logic [ ( SAMPLE_AWIDTH - 1 ) : 0 ] SAMPLE_ram_raddr ;
//  logic [ ( SAMPLE_DWIDTH - 1 ) : 0 ] SAMPLE_ram_rdata ;
//  hqm_assertion_ram #(
//  .DEPTH ( SAMPLE_DEPTH )
//  , .DWIDTH ( SAMPLE_DWIDTH )
//  ) i_assertion_ram_SAMPLE (
//  .clk ( clk )
//  , .rst_n ( rst_n )
//  , .rst_val ( reset_value)
//  , .ram_we ( SAMPLE_ram_we )
//  , .ram_waddr ( SAMPLE_ram_waddr )
//  , .ram_wdata ( SAMPLE_ram_wdata )
//  , .ram_we2 ( SAMPLE_ram_we2 )
//  , .ram_waddr2 ( SAMPLE_ram_waddr2 )
//  , .ram_wdata2 ( SAMPLE_ram_wdata2 )
//  , .ram_re ( SAMPLE_ram_re )
//  , .ram_raddr ( SAMPLE_ram_raddr )
//  , .ram_rdata ( SAMPLE_ram_rdata )
//  );
//--------------------------------------------------
//
module hqm_assertion_ram 
import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
, parameter AWIDTH = ( AW_logb2 ( DEPTH -1 ) + 1 )
, parameter INIT = 0
) (
input logic clk
, input logic rst_n
, input logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ]  rst_val 
, input logic ram_we
, input logic [ ( AWIDTH - 1 ) : 0 ] ram_waddr
, input logic [ ( DWIDTH - 1 ) : 0 ] ram_wdata
, input logic ram_we2
, input logic [ ( AWIDTH - 1 ) : 0 ] ram_waddr2
, input logic [ ( DWIDTH - 1 ) : 0 ] ram_wdata2
, input logic ram_re
, input logic [ ( AWIDTH - 1 ) : 0 ] ram_raddr
, output logic [ ( DWIDTH - 1 ) : 0 ] ram_rdata
);

logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] ram_f ;
logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] ram_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    ram_f <= rst_val ;
  end
  else begin
    ram_f <= ram_nxt ;
  end
end

logic [ ( DWIDTH - 1 ) : 0 ] ram_rdata_f , ram_rdata_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    ram_rdata_f <= '0 ;
  end
  else begin
    ram_rdata_f <= ram_rdata_nxt ;
  end
end

always_comb begin
  ram_rdata_nxt = '0; // ram_rdata_f ;
  ram_nxt = ram_f ;
  ram_rdata = ram_rdata_f ;
  if ( ram_re ) begin ram_rdata_nxt = ram_f [ ( ram_raddr * DWIDTH ) +: DWIDTH ] ; end
  if ( ram_we ) begin ram_nxt [ ( ram_waddr * DWIDTH ) +: DWIDTH ] = ram_wdata ; end
  if ( ram_we2 ) begin ram_nxt [ ( ram_waddr2 * DWIDTH ) +: DWIDTH ] = ram_wdata2 ; end
end
endmodule
