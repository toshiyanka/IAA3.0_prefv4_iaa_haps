module ctech_lib_msff_async_rst_set (
   input logic d,
   input logic rst,
   input logic set,
   input logic clk,
   output logic o
);
   d04fyn0fld0b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .rb(~rst), .psb(~set));
endmodule
