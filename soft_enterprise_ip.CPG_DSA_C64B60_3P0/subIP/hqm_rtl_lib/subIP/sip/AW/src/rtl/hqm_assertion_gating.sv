//
// common design to be used in assertion code
//

module hqm_assertion_gating
 import hqm_AW_pkg::*; #(
parameter NUM_FORCE_ON = 1
, parameter NUM_FORCE_OFF = 1
, parameter ON_WINS = 0
) (
input logic in
, output logic out
, input logic [ ( NUM_FORCE_ON ) - 1 : 0 ] force_on
, input logic [ ( NUM_FORCE_OFF ) - 1 : 0 ] force_off
);
always_comb begin

  out = ( in | ( | force_on ) ) & ~ ( | force_off ) ;
  if ( ON_WINS == 1 ) begin
  out = ( in & ~ ( | force_off ) ) | ( | force_on ) ;
  end
end
endmodule
