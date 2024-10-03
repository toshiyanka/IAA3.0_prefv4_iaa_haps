module ctech_lib_clk_and_en (
   output logic clkout,
   input logic clk,
   input logic en
);
   d04gan00ld0c0 ctech_lib_dcszo (.clkout(clkout), .clk(clk), .en(en));
endmodule   
