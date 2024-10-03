module ctech_lib_clk_div2_reset  (
   output logic clkout,
   input logic in,
   input logic clk,
   input logic rst
);
   d04cdc03ld0c0 ctech_lib_dcszo (.clkout(clkout),.d(in),.clk(clk),.rb(~rst));
endmodule
