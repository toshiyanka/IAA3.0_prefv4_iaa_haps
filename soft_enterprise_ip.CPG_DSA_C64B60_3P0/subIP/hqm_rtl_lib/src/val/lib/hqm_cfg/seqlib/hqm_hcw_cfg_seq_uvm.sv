class hqm_hcw_cfg_seq extends slu_sequence_base;
  `uvm_object_utils(hqm_hcw_cfg_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

  hqm_cfg_file_mode_seq      i_file_mode_seq;
  hqm_cfg2_file_mode_seq     i_file_mode_seq2;

  function new(string name = "hqm_hcw_cfg_seq");
    super.new(name);
  endfunction

  virtual task body();
    i_file_mode_seq =  hqm_cfg_file_mode_seq::type_id::create("i_hqm_hcw_cfg_seq");
    i_file_mode_seq.start(get_sequencer());
    i_file_mode_seq2 =  hqm_cfg2_file_mode_seq::type_id::create("i_hqm_hcw_cfg2_seq");
    i_file_mode_seq2.start(get_sequencer());
  endtask

endclass : hqm_hcw_cfg_seq
