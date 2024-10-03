module ctech_lib_clk_gate_te (
  output logic clkout,
  input logic clk,
  input logic en,
  input logic te);
  d04cgc01ld0h0 ctech_lib_dcszo (.clkout(clkout),.clk(clk),.en(en),.te(te)); 
endmodule
