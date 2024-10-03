module ctech_lib_mux_2to1 (
   input logic d1,
   input logic d2,
   input logic s,
   output logic o
);
   d04mbn22ld0c7 ctech_lib_dcszo (.d1(d1), .d2(d2), .s(s), .o(o));
endmodule
