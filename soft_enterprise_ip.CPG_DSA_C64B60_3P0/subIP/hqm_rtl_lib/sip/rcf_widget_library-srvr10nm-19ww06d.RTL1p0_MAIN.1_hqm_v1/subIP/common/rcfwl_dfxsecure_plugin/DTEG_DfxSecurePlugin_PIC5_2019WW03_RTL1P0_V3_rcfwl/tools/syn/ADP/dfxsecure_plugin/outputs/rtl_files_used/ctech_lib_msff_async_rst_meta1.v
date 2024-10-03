module ctech_lib_msff_async_rst_meta1 (clk, d, rst, o);
   input  clk, d, rst;
   output o;
   logic o;
   d04hgn13ld0b0 ctech_lib_dcszo (.clk(clk),.d(d),.rb(~rst),.o(o));
endmodule
