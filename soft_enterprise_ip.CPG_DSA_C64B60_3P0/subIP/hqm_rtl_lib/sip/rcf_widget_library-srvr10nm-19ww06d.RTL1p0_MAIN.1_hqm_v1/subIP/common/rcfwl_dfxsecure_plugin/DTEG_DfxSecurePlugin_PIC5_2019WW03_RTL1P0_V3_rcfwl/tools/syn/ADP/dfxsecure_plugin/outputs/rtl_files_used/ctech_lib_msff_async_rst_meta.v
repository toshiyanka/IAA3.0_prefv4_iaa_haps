module ctech_lib_msff_async_rst_meta (
   input logic clk,
   input logic d, 
   input logic rst,
   output logic o
);
  d04hiy23ld0b0 ctech_lib_dcszo  (.o(o), .d(d), .clk(clk), .rb(~rst), .ss(1'b0), .si(1'b0), .so());
endmodule
