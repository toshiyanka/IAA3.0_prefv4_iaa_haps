module ctech_lib_msff_sync_rst (
   output logic o,
   input logic d,
   input logic clk,
   input logic rst
);
   d04fkn03ld6b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .rb(~rst));
endmodule
