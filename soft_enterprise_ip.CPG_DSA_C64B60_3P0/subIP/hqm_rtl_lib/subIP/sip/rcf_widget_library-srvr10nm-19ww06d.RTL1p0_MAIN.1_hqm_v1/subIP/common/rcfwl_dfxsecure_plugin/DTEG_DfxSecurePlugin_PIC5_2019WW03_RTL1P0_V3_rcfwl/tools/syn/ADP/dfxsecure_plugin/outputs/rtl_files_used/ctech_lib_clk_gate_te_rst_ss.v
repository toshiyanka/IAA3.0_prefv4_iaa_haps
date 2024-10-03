module ctech_lib_clk_gate_te_rst_ss (
   input logic en,     // Enable input logic signal
   input logic te,     // Test mode latch open. Port map to: Tlatch_open
   input logic rst,   // Test mode latch close. Port map to: Tlatch_closedB
   input logic clk,     // Clock input
   output logic clkout,  // Clock-gated enable output
   input logic ss
);
   d04cgc02ld0d0 ctech_lib_dcszo (.clkout(clkout),.clk(clk),.en(en),.te(te), .rb(~rst), .ss(ss) ); 
endmodule
