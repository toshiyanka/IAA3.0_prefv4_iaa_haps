module ctech_lib_clk_div2 (clkout, in, clk);
   input logic in,clk;
   output logic clkout;
   d04cdc03ld0c0 ctech_lib_dcszo (.clkout(clkout),.d(in),.clk(clk),.rb(1'b1));
endmodule
