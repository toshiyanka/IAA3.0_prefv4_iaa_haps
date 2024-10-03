//
//
module hqm_assertion_ram_wv
import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
, parameter AWIDTH = ( AW_logb2 ( DEPTH -1 ) + 1 )
, parameter INIT = 0
) (
input logic clk
, input logic rst_n
, input logic ram_we
, input logic [ ( AWIDTH - 1 ) : 0 ] ram_waddr
, input logic [ ( DWIDTH - 1 ) : 0 ] ram_wdata
, input logic ram_re
, input logic [ ( AWIDTH - 1 ) : 0 ] ram_raddr
, output logic [ ( DWIDTH - 1 ) : 0 ] ram_rdata
, output logic ram_rdata_v
);

logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] ram_f ;
logic [ ( ( DWIDTH * DEPTH ) - 1 ) : 0 ] ram_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    ram_f <= INIT ;
  end
  else begin
    ram_f <= ram_nxt ;
  end
end

logic [ ( DWIDTH - 1 ) : 0 ] ram_rdata_f , ram_rdata_nxt ;
logic ram_rdata_v_f , ram_rdata_v_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    ram_rdata_f <= '0 ;
    ram_rdata_v_f <= '0 ;
  end
  else begin
    ram_rdata_f <= ram_rdata_nxt ;
    ram_rdata_v_f <= ram_rdata_v_nxt ;
  end
end

always_comb begin
  ram_rdata_nxt = '0; // ram_rdata_f ;
  ram_rdata_v_nxt = '0 ;
  ram_nxt = ram_f ;
  ram_rdata = ram_rdata_f ;
  ram_rdata_v = ram_rdata_v_f ;
  if ( ram_re ) begin ram_rdata_nxt = ram_f [ ( ram_raddr * DWIDTH ) +: DWIDTH ] ; ram_rdata_v_nxt = 1'b1 ;end
  if ( ram_we ) begin ram_nxt [ ( ram_waddr * DWIDTH ) +: DWIDTH ] = ram_wdata ; end
end
endmodule
