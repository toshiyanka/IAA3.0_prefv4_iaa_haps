module ctech_lib_msff_sync_set (
   output logic o,
   input logic d,
   input logic clk,
   input logic set
);
   d04fkn0cld6b0 ctech_lib_dcszo (.o(o), .d(d), .clk(clk), .psb(~set));
endmodule
