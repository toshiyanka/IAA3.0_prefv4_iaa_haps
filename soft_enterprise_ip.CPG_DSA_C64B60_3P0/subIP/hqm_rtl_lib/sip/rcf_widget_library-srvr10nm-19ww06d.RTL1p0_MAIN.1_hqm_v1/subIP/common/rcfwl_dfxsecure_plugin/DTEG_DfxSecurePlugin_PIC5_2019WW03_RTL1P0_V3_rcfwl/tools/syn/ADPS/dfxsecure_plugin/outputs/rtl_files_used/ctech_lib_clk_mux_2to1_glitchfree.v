module ctech_lib_clk_mux_2to1_glitchfree (clkout, clk1, clk2, s1, s2);
   input logic clk1,clk2,s1,s2;
   output logic clkout;
   d04cgm22ld0b0 ctech_lib_dcszo (.clkout(clkout),.clk1(clk1),.clk2(clk2),.sa(s1),.sb(s2));
endmodule
