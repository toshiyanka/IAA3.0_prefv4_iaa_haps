module ctech_lib_clk_nor_en (clkout,clk,en);
   input logic clk,en;
   output logic clkout;
   d04gno00ld0c0 ctech_lib_dcszo (.clk(clk),.en(en),.clkout(clkout));
endmodule
