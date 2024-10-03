module ctech_lib_firewall_or (out,data,enable);
   input logic enable, data;
   output logic out;
   d04swo00ld0c0 ctech_lib_dcszo (.a(data),.o(out),.en(~enable));
endmodule
