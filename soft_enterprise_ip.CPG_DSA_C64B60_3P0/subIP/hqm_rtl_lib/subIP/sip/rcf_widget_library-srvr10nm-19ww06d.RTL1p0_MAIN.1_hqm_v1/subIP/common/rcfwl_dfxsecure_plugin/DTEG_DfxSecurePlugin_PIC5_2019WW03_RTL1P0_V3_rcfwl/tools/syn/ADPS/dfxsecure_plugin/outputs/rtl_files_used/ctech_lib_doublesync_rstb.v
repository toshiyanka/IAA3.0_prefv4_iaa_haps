module ctech_lib_doublesync_rstb (
   input logic clk,
   input logic d, 
   input logic rstb,
   output logic o
);
  d04hiy23ld0b0 ctech_lib_dcszo  (.o(o), .d(d), .clk(clk), .rb(rstb), .ss(1'b0), .si(1'b0), .so());
endmodule
