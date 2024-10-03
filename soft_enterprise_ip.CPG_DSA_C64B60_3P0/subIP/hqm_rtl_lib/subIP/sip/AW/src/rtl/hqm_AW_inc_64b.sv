module hqm_AW_inc_64b
import hqm_AW_pkg::* ;
(
input logic clk
, input logic rst_n
, input logic en
, input logic clr
, input logic clrv
, input logic inc
, output logic [ ( 64 ) - 1 : 0 ] count
) ;

logic [ 31 : 0 ] count_1_nxt , count_1_f ;
logic [ 31 : 0 ] count_0_nxt , count_0_f ;
logic [ 1 : 0 ] count_incr_nxt , count_incr_f ;
logic [ 31 : 0 ] count_1_p1;
logic [ 31 : 0 ] count_0_p1;



always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count_incr_f <= '0 ;
    count_0_f <='0 ;
    count_1_f <= '0 ;
  end
  else begin
    count_incr_f <= count_incr_nxt ;
    count_0_f <= count_0_nxt ;
    count_1_f <= count_1_nxt ;
  end
end

hqm_AW_inc #(
.WIDTH ( 32 )
) count_1_inc (
.a ( count_1_f )
, .sum ( count_1_p1 )
);

hqm_AW_inc #(
.WIDTH ( 32 )
) count_0_inc (
.a ( count_0_f )
, .sum ( count_0_p1 )
);

always_comb begin
  count = { count_1_f , count_0_f } ;
  count_incr_nxt [ 1 ] = en & inc & ((count_incr_f[0]) ? (&{count_0_f[31:1], ~count_0_f[0]}) : (&count_0_f));
  count_incr_nxt [ 0 ] = en & inc ;
  count_1_nxt = count_1_f ;
  count_0_nxt = count_0_f ;
  if ( count_incr_f [ 1 ] ) begin
    count_1_nxt = count_1_p1 ;
  end
  if ( count_incr_f [ 0 ] ) begin
     count_0_nxt = count_0_p1 [ 31 : 0 ] ;
  end
  if ( clr ) begin
    count_incr_nxt = '0 ;
    count_0_nxt = {32{clrv}} ;
    count_1_nxt = {32{clrv}} ;
  end
end

endmodule
