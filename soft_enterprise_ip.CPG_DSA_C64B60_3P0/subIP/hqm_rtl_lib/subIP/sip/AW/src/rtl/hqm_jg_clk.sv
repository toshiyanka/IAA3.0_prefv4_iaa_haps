// phase : starting phase 0/1
module hqm_jg_clk
import hqm_AW_pkg::*; #(
parameter WIDTH = 4
) (
  input logic reference_clk
, input logic reference_rst_n
, input logic [ ( 2 ) - 1 : 0 ] mode
, input logic [ ( WIDTH ) - 1 : 0 ] freq
, input logic [ ( WIDTH ) - 1 : 0 ] punch
, input logic phase
, input logic random
, output logic clk 
) ;

logic clk_f , clk_nxt ;
logic [ ( WIDTH ) - 1 : 0 ] cnt_f , cnt_nxt ;
always_ff @ ( posedge reference_clk or negedge reference_rst_n ) begin
  if ( ~ reference_rst_n ) begin
    clk_f <= phase ;
    cnt_f <= '0 ;
  end else begin
    clk_f <= clk_nxt ;
    cnt_f <= cnt_nxt ;
  end
end

logic [ ( WIDTH ) - 1 : 0 ] freq_m1 ;
assign freq_m1 = freq - 1'b1 ;

always_comb begin 

  clk = '0 ;
  clk_nxt = clk_f ;
  cnt_nxt = cnt_f + 1'b1 ; if ( cnt_f == freq_m1 ) begin cnt_nxt = '0 ; end

  //reference clock
  if ( mode == 2'd0 ) begin
    clk = reference_clk ;
  end

  //divide down reference clock
  if ( mode == 2'd1 ) begin
    clk = clk_f ;
    if ( cnt_f == freq_m1 ) begin clk_nxt = ~ clk_f ; end
  end

  //punch out reference clock
  if ( mode == 2'd2 ) begin
    clk = '0 ;
    if ( cnt_f == punch ) begin clk = reference_clk ; end
  end

  //randomize (dont connect input random to allow JG to control)
  if ( mode == 2'd3 ) begin
    clk = random ;
  end

end

endmodule
