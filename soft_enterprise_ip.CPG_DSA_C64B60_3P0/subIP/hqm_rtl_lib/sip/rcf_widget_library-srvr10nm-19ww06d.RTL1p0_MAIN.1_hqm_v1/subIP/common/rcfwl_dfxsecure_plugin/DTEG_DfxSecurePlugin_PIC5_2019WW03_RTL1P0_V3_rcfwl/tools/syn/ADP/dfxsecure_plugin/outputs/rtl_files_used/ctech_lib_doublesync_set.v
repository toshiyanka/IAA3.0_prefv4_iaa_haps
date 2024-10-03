module ctech_lib_doublesync_set (
   output logic o,
   input logic d,
   input logic clk,
   input logic set
); 
   d04hiy2cld0b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .psb(~set), .ss(1'b0), .si(1'b0), .so());
endmodule
