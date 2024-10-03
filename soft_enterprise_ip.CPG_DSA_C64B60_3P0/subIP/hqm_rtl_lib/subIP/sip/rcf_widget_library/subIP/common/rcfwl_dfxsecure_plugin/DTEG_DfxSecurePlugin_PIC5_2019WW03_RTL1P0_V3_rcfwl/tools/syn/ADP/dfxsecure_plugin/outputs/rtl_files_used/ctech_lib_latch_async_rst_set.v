module ctech_lib_latch_async_rst_set (clk, d, rb, set, o);
   input clk, d, rb, set;
   output o;
   logic o;
   d04lyn0fld0a5 ctech_lib_dcszo (.clk(clk),.d(d),.psb(~set),.o(o),.rb(rb));
endmodule
