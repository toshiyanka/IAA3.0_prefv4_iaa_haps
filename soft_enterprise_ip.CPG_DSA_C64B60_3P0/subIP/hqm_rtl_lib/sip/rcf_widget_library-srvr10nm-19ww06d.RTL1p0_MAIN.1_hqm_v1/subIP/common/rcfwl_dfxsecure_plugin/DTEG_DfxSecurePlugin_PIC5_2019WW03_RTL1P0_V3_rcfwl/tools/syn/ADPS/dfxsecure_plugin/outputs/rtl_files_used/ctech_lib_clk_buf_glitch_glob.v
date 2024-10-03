module ctech_lib_clk_buf_glitch_glob (clkout, clk);
   input logic clk;
   output logic clkout;
   d04gbf00ld0c0 ctech_lib_dcszo (.clk(clk), .clkout(clkout));
endmodule
