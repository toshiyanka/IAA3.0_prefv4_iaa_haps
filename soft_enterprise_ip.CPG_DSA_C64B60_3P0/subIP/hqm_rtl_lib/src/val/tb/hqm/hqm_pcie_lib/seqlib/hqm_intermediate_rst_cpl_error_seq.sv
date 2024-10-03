`ifndef HQM_INTERMEDIATE_RST_CPL_ERROR_SEQ__SV
`define HQM_INTERMEDIATE_RST_CPL_ERROR_SEQ__SV

class hqm_intermediate_rst_cpl_error_seq extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_intermediate_rst_cpl_error_seq,sla_sequencer)

  hqm_sla_pcie_cpl_error_seq uecpl_seq; 
  bit                        warm_rst_chk = $test$plusargs("HQM_INTERMEDIATE_WARM_RST_CHK");
  bit                        vf_flr_chk   = $test$plusargs("HQM_INTERMEDIATE_VF_FLR_CHK");

  function new(string name = "hqm_intermediate_rst_cpl_error_seq");
    super.new(name); 
  endfunction

  virtual task body();
    `ovm_do_with(uecpl_seq, {warm_reset_before_checks == warm_rst_chk; vf_flr_before_checks == vf_flr_chk;});
  endtask : body

endclass : hqm_intermediate_rst_cpl_error_seq

`endif
