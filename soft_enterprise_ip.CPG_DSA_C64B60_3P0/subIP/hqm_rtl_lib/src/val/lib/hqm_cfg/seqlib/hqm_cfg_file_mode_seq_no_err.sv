class hqm_cfg_file_mode_seq_no_err extends hqm_cfg_file_mode_seq;
  `ovm_sequence_utils(hqm_cfg_file_mode_seq_no_err,sla_sequencer)

  function new(string name = "hqm_cfg_file_mode_seq_no_err");
    super.new(name, "HQM_SEQ_CFG", 1'b0);  // do not generate an error if no file specified
  endfunction

endclass : hqm_cfg_file_mode_seq_no_err
