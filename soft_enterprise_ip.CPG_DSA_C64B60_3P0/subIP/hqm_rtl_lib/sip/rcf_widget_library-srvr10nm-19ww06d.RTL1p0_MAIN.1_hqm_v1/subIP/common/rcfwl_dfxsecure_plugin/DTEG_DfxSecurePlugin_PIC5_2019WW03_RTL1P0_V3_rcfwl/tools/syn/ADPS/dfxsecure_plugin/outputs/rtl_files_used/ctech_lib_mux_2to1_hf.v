module ctech_lib_mux_2to1_hf (out,in1,in2,sel);
   input logic in1,in2,sel;
   output logic out;
   d04mbn22ld0c7 ctech_lib_dcszo (.d1(in1), .d2(in2), .s(sel), .o(out));
endmodule
