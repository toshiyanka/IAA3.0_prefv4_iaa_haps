module hqm_AW_viewpin_mux 
 #(
  parameter MUX_SEL_WIDTH = 3,
  parameter NUM_IN = 8,
  parameter NUM_OUT = 2
)
(
input    [6:0]  mux_in,
input    [5:0]  mux_sel,
output   [1:0]  mux_out
);

endmodule // hqm_AW_viewpin_mux
