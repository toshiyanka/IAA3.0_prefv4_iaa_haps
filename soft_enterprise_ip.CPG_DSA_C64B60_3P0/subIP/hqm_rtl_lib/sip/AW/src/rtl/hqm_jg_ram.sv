module hqm_jg_ram 
import hqm_AW_pkg::*; #(
parameter DEPTH = 8
, parameter DWIDTH = 16
, parameter CHECK_RW_COLLIDE = 1
, parameter SCALED_DEPTH = DEPTH
//..................................................
, parameter DEPTHB2 = ( AW_logb2 ( DEPTH -1 ) + 1 )
) (
input logic clk
, input logic rst_n
, input logic ram_we
, input logic [ ( DEPTHB2 - 1 ) : 0 ] ram_waddr
, input logic [ ( DWIDTH - 1 ) : 0 ] ram_wdata
, input logic ram_re
, input logic [ ( DEPTHB2 - 1 ) : 0 ] ram_raddr
, output logic [ ( DWIDTH - 1 ) : 0 ] ram_rdata
);

logic [ ( ( SCALED_DEPTH ) - 1 ) : 0 ] [ ( DWIDTH ) - 1 : 0 ] ram_f ;
logic [ ( ( SCALED_DEPTH ) - 1 ) : 0 ] [ ( DWIDTH ) - 1 : 0 ] ram_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    ram_f <= '0 ;
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

logic error_rw_collide ;
logic error_bound ;
always_comb begin
  ram_rdata_nxt = '0; // ram_rdata_f ;
  ram_nxt = ram_f ;
  ram_rdata = ram_rdata_f ;
  if ( ram_re ) begin ram_rdata_nxt = ram_f [ ram_raddr ] ; end
  if ( ram_we ) begin ram_nxt [ ram_waddr ] = ram_wdata ; end
  error_rw_collide = 1'b0 ;
  if ( ram_re & ram_we & ( ram_raddr == ram_waddr ) ) begin error_rw_collide = CHECK_RW_COLLIDE ; end
  error_bound = 1'b0 ;
  if ( ram_re & ( ram_raddr > SCALED_DEPTH ) ) begin error_bound = 1'b1 ; end
  if ( ram_we & ( ram_raddr > SCALED_DEPTH ) ) begin error_bound = 1'b1 ; end
end

//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF
  jg_ram__check_rw_collide: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error_rw_collide ) ) else begin
    $display ("\nERROR: %t: %m: jg_ram error detected : error_rw_collide \n",$time ) ;
  end

  jg_ram__check_bound: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error_bound ) ) else begin
    $display ("\nERROR: %t: %m: jg_ram error detected : error_bound \n",$time ) ;
  end

`endif

endmodule
