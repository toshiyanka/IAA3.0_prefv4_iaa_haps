module ctech_lib_firewall_ls_or (o,a,en);
   input logic a,en;
   output logic o;
   d04sco00ld0c0 ctech_lib_dcszo (.a(a),.o(o),.en(~en));
endmodule
