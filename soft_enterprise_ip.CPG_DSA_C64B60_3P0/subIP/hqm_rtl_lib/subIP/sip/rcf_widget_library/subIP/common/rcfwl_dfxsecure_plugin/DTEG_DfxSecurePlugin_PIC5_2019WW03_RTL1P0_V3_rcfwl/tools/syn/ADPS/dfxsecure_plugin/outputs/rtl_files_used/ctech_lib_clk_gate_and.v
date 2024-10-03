module ctech_lib_clk_gate_and (
   input logic clk,
   input logic en,
   output logic clkout
);
   logic en_latch;
   d04ltn80ld0b0 ctech_lib_dcszo2 (.o(en_latch), .clkb(clk), .d(en));
   d04gan00ld0c0 ctech_lib_dcszo1 (.clkout(clkout), .clk(clk), .en(en_latch));
endmodule
