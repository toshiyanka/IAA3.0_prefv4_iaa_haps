class hqm_tb_cfg_pre_file_mode_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_tb_cfg_pre_file_mode_seq,sla_sequencer)

    hqm_tb_cfg_file_mode_seq i_pre_file_mode_seq;

  function new(string name = "hqm_tb_cfg_pre_file_mode_seq");
    super.new(name);
  endfunction

  virtual task body();
    i_pre_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg_pre_file_mode_seq");
    i_pre_file_mode_seq.set_cfg("HQM_SEQ_PRE_CFG", 1'b0);
    i_pre_file_mode_seq.start(get_sequencer());
  endtask: body;

endclass : hqm_tb_cfg_pre_file_mode_seq
