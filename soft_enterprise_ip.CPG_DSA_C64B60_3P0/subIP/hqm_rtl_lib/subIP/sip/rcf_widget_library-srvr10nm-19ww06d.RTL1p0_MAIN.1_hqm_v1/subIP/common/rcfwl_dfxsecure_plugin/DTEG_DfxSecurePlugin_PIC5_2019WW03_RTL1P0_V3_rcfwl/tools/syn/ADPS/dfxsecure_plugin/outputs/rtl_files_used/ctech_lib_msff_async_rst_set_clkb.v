module ctech_lib_msff_async_rst_set_clkb (
   input logic d,
   input logic rst,
   input logic set,
   input logic clkb,
   output logic o
);
   d04fyn8fnd0b0 ctech_lib_dcszo (.o(o), .d(d), .clkb(clkb), .rb(~rst), .psb(~set));
endmodule
