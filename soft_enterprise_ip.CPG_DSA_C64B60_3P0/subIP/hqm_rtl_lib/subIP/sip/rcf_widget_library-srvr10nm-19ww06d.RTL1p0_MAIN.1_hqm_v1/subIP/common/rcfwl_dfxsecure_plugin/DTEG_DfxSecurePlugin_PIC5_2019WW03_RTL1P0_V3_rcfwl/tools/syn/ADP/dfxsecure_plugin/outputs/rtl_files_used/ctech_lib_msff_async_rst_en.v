module ctech_lib_msff_async_rst_en (
   input d,
   input en,
   input clk,
   input rst,
   output o
);
   d04fyn43ld0a5 ctech_lib_dcszo (.d(d),.den(en),.clk(clk),.rb(~rst),.o(o));
endmodule
