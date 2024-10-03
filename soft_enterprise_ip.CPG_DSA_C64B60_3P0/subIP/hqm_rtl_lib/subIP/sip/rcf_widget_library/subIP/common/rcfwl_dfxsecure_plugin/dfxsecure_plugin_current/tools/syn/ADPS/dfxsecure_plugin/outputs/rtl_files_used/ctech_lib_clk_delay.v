module ctech_lib_clk_delay (output logic clkout, input logic clk, input logic rsel0, input logic rsel1, input logic rsel2);
   d04cpk30ld0c0 ctech_lib_dcszo (.clk(clk), .rsel0(rsel0), .rsel1(rsel1), .rsel2(rsel2), .clkout(clkout));
endmodule
