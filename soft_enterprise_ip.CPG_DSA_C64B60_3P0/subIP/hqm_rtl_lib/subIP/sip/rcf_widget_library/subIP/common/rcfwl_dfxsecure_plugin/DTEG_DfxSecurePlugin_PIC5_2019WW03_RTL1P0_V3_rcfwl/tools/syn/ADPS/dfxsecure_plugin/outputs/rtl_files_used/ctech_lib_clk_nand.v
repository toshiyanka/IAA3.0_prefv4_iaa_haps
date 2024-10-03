module ctech_lib_clk_nand (
   output logic clkout,
   input logic clk1,
   input logic clk2
);
   d04gna02ld0c0 ctech_lib_dcszo (.clkout(clkout), .clk1(clk1), .clk2(clk2));
endmodule
