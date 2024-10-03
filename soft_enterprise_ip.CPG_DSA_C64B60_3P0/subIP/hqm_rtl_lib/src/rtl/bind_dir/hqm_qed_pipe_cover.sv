`ifdef INTEL_INST_ON
module hqm_qed_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
`ifdef HQM_COVER_ON
covergroup COVERGROUP @(posedge hqm_qed_pipe_core.hqm_gated_clk);

endgroup
COVERGROUP u_COVERGROUP = new();
`endif
endmodule
bind hqm_qed_pipe_core hqm_qed_pipe_cover i_hqm_qed_pipe_cover();
`endif
