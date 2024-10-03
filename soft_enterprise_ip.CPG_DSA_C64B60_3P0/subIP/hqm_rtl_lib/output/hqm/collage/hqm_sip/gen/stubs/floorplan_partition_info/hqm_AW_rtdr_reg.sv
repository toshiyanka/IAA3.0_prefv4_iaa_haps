module hqm_AW_rtdr_reg 
 #(
  parameter DWIDTH = 32
)
(
input     tck,
input     trstb,
input     tdi,
input     irdec,
input     shiftdr,
input     updatedr,
input     capturedr,
input    [31:0]  func_pi,
output    tdo,
output   [31:0]  func_po
);

endmodule // hqm_AW_rtdr_reg
