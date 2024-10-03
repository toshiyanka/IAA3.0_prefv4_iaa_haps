module ctech_lib_msff_async_rst_meta_hard (o, d, clk, rst);
   input logic d,clk,rst;
   output logic o;
   d04fyn03ld0b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .rb(~rst));
endmodule
