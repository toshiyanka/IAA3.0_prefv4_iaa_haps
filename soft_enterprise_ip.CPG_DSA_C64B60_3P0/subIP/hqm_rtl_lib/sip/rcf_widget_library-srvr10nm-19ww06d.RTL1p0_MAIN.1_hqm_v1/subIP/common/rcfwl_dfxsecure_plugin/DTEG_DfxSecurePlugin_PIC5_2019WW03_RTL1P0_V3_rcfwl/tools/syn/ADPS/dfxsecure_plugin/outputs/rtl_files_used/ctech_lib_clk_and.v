module ctech_lib_clk_and (
   input logic clk1,
   input logic clk2,
   output logic clkout
);
   logic clkout_b;
   d04gna02ld0c0 ctech_clkand_dcszo1 (.clkout(clkout_b),.clk1(clk1),.clk2(clk2));
   d04gin00ld0c0 ctech_clkand_dcszo2 (.clkout(clkout),.clk(clkout_b));
endmodule
