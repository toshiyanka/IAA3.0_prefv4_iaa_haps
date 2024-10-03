module hqm_AW_cirptrs
import hqm_AW_pkg::*; #(
parameter DEPTH = 1024
, parameter DEPTHB2 = ( AW_logb2 ( DEPTH - 1 ) + 1 )
) (
input logic [ DEPTHB2 : 0 ] hp
, input logic [ DEPTHB2 : 0 ] tp
, output logic empty
, output logic full
, output logic [ DEPTHB2 : 0 ] size
, output logic err
) ;

logic hp_gen ;
logic [ DEPTHB2 - 1 : 0 ] hp_val ;
logic tp_gen ;
logic [ DEPTHB2 - 1 : 0 ] tp_val ;

always_comb begin : C00
  err = '0 ;
  full = '0 ;
  empty = '0 ;
  size = '0 ;

  { hp_gen , hp_val } = hp ;
  { tp_gen , tp_val } = tp ;

  if ( ( hp_gen != tp_gen ) & ( hp_val == tp_val ) ) begin
    full = 1'b1 ;
  end
  if ( ( hp_gen == tp_gen ) & ( hp_val == tp_val ) ) begin
    empty = 1'b1 ;
  end

  size = (tp - hp) & { ( DEPTHB2+1 ) { 1'b1 } } ;

  if ( size > DEPTH ) begin
   err = 1'b1 ;
  end

end

endmodule
