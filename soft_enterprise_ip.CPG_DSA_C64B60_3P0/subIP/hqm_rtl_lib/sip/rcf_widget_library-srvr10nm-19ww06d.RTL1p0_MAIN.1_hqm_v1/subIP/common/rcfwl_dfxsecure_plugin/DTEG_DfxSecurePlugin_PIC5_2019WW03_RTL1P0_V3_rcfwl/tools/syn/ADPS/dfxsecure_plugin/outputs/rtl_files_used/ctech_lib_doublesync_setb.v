module ctech_lib_doublesync_setb (
   output logic o,
   input logic d,
   input logic clk,
   input logic setb
); 
   d04hiy2cld0b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .psb(setb), .ss(1'b0), .si(1'b0), .so());
endmodule
