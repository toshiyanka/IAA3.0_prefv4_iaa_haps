module ctech_lib_mux_2to1_inv_hf (out,in1,in2,sel);
   input logic in1,in2,sel;
   output logic out;
   d04mdn22ld0c7 ctech_lib_dcszo (.a(in1),.b(in2),.sa(sel),.o1(out));
endmodule
