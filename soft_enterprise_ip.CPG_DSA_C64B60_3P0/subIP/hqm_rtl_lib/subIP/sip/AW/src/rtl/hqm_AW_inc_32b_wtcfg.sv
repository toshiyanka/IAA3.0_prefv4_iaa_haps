module hqm_AW_inc_32b_wtcfg
import hqm_AW_pkg::* ;
(
input logic clk
, input logic rst_n

, input logic en
, input logic clr
, input logic clrv
, input logic inc
, output logic [ ( 32 ) - 1 : 0 ] count

, input logic [ ( 1 * 1 ) -1 : 0 ] cfg_write
, input logic [ ( 1 * 1 ) -1 : 0 ] cfg_read
, input cfg_req_t cfg_req 
, output logic [ ( 1 * 1 ) -1 : 0 ] cfg_ack
, output logic [ ( 1 * 1 ) -1 : 0 ] cfg_err
, output logic [ ( 1 * 32 ) -1 : 0 ] cfg_rdata
) ;

always_comb begin
  cfg_ack = '0 ;
  cfg_err = '0 ;
  cfg_rdata = '0 ;

  if ( cfg_write[ 0 ] ) begin cfg_ack[ 0 ] = 1'b1 ; cfg_err[ 0 ] = 1'b1 ; end
  if ( cfg_read[ 0 ] ) begin cfg_ack[ 0 ] = 1'b1 ; cfg_rdata [ ( 0 * 32 ) +: 32 ] = count [ ( 0 * 32 ) +: 32 ] ; end
end

hqm_AW_inc_32b i_hqm_AW_inc_32b (
 .clk ( clk )
 , .rst_n ( rst_n )
 , .en ( en )
 , .clr ( clr )
 , .clrv ( clrv )
 , .inc ( inc )
 , .count ( count )
) ;

endmodule
