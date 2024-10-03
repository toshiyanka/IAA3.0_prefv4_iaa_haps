module hqm_AW_reset_core 
 #(
  parameter NO_PGCB = 0,
  parameter NUM_GATED = 1,
  parameter NUM_INP_GATED = 1,
  parameter NUM_PATCH_GATED = 1,
  parameter NUM_PGSB = 1
)
(
input     fscan_rstbypen,
input     fscan_byprst_b,
input     hqm_pgcb_clk,
output   [0:0]  hqm_pgcb_rst_n,
output    hqm_pgcb_rst_n_start,
input     hqm_inp_gated_clk,
input     hqm_inp_gated_rst_b,
output   [0:0]  hqm_inp_gated_rst_n,
input     hqm_gated_clk,
input     hqm_gated_rst_b,
output   [0:0]  hqm_gated_rst_n,
output    hqm_gated_rst_n_start,
output    hqm_gated_rst_n_active,
input     hqm_gated_rst_n_done,
input     hqm_flr_prep,
output    rst_prep
);

endmodule // hqm_AW_reset_core
