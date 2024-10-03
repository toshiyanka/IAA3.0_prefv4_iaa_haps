module ctech_lib_clk_mux_2to1 (
   input logic clk1,
   input logic clk2,
   input logic s,
   output logic clkout
);
   d04gmx22ld0c0 ctech_lib_dcszo (.clkout(clkout), .s(s), .clk2(clk2), .clk1(clk1)); // note that clocks are intentionally switched due to mux polarity
endmodule
