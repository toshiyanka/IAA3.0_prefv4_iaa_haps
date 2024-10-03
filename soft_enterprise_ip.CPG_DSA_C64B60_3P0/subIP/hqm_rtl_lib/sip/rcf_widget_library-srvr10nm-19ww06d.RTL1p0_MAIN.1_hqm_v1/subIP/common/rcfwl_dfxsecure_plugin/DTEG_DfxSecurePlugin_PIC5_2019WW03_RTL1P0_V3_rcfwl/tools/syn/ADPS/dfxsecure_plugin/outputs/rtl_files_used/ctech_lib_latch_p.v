module ctech_lib_latch_p (
  output logic o,
  input logic d,
  input logic clkb
);
  d04ltn80ld0b0 ctech_lib_dcszo (.o(o), .clkb(clkb), .d(d));
endmodule
