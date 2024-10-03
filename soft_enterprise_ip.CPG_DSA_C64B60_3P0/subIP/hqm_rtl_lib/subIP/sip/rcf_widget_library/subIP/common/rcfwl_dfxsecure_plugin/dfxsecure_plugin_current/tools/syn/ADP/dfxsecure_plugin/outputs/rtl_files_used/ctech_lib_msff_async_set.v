module ctech_lib_msff_async_set (
   output logic o,
   input logic d,
   input logic clk,
   input logic set
);
   d04fyn0cld0b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .psb(~set));
endmodule
