module ctech_lib_clk_gate_and_hf (clkout,clk,en);
   input logic clk,en;
   output logic clkout;
   d04cgc00ld0c0 ctech_lib_dcszo (.clk(clk),.en(en),.clkout(clkout));
endmodule
