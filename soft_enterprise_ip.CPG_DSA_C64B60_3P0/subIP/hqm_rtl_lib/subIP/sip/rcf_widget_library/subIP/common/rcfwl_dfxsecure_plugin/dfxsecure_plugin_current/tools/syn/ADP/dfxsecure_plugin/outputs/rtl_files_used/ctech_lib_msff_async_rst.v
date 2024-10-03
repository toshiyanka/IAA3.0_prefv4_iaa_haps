module ctech_lib_msff_async_rst (
   output logic o,
   input logic d,
   input logic clk,
   input logic rst
);
   d04fyn03ld0b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .rb(~rst));
endmodule
