module ctech_lib_clk_or (
   output logic clkout,
   input logic clk1,
   input logic clk2
);
   logic clk_nor;
   d04gno02ld0c0 ctech_clknor_dcszo (.clkout(clk_nor), .clk1(clk1), .clk2(clk2));
   d04gin00ld0c0 ctech_clkinv_dcszo (.clk(clk_nor), .clkout(clkout));
endmodule
