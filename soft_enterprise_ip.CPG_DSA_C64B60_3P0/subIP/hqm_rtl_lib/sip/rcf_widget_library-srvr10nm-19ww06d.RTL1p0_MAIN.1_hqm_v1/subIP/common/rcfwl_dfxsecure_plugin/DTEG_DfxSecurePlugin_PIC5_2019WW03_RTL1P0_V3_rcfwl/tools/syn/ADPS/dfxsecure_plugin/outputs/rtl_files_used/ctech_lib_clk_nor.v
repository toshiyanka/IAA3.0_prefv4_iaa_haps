module ctech_lib_clk_nor (
   output logic clkout,
   input logic clk1,
   input logic clk2
);
   d04gno02ld0c0 ctech_clknor_dcszo (.clkout(clkout), .clk1(clk1), .clk2(clk2));
endmodule
