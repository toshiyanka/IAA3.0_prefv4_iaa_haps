module ctech_lib_clk_gate_or (
   input logic clk,
   input logic en,
   output logic clkout
);
   logic en_latch;
   d04ltn00ln0b0  ctech_lib_dcszo1        (.o(en_latch), .d(en), .clk(clk));
   d04gor00ld0c0  ctech_lib_dcszo2 (.clkout(clkout),.clk(clk),.en(en_latch));
endmodule
