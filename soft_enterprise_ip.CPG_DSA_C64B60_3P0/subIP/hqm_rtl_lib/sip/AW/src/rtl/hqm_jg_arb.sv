module hqm_jg_arb
import hqm_AW_pkg::*;
#(
parameter REQ = 2
, parameter MODE = 0 
//.........................
, parameter REQB2 = ( AW_logb2 ( REQ - 1 ) + 1 )
) (
input logic clk
, input logic rst_n
, input logic [ ( REQ ) - 1 : 0 ] req
, input logic gnt
, output logic ack
, output logic [ ( REQB2 ) - 1 : 0 ] ack_req
);

logic [ ( REQB2 ) - 1 : 0 ] idx_nxt , idx_f , idx ;
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    idx_f <= '0 ;
  end else begin
    idx_f <= idx_nxt ;
  end
end
generate
if ( MODE == 0 ) begin //RAND
end
else if ( MODE == 1 ) begin //STRICT 0->REQ
  assign idx_nxt = '0 ;
end
else if ( MODE == 2 ) begin //STRICT REQ->0
  assign idx_nxt = REQ - 1 ;
end
else if ( MODE == 3 ) begin //RR (ack+1) on gnt
  assign idx_nxt = gnt ? ack_req + 1'b1 : idx_f ;
end
endgenerate

always_comb begin
  ack = ( | req ) ; 
  ack_req = '0 ;

  idx = idx_f ;
  if ( MODE == 2 ) begin idx = REQ - idx -1 ; end
  for ( int i = 0 ; i < REQ ; i = i + 1 ) begin
    if (idx > REQ) begin idx = '0 ; end
    if ( req [ i ] ) begin
      ack_req = i ;
    end
    idx = idx + 1'b1 ;
  end
 
end

endmodule
