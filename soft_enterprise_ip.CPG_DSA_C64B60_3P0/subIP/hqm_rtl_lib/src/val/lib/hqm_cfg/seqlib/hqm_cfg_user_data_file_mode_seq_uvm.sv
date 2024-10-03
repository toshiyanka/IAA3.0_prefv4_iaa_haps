class hqm_cfg_user_data_file_mode_seq extends slu_sequence_base;
  `uvm_object_utils(hqm_cfg_user_data_file_mode_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

    hqm_cfg_file_mode_seq i_usr_file_mode_seq;

  function new(string name = "hqm_cfg_user_data_file_mode_seq");
    super.new(name);
  endfunction

  virtual task body();
    i_usr_file_mode_seq = hqm_cfg_file_mode_seq::type_id::create("i_usr_file_mode_seq");
    i_usr_file_mode_seq.set_cfg("HQM_SEQ_CFG_USER_DATA", 1'b0);
    i_usr_file_mode_seq.start(get_sequencer());
  endtask: body;

endclass : hqm_cfg_user_data_file_mode_seq
