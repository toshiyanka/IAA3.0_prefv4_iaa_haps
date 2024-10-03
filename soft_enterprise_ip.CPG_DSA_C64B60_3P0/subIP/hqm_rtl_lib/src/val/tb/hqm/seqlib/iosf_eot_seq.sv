class iosf_eot_seq extends sla_sequence_base;
  `ovm_sequence_utils(iosf_eot_seq,sla_sequencer)

  hqm_eot_rd_seq                i_hqm_eot_rd_seq;
  hqm_tb_cfg_eot_file_mode_seq  i_eot_file_mode_seq;
  hqm_tb_eot_status_seq         i_hqm_tb_eot_status_seq;
  hqm_tb_cfg_eot_post_file_mode_seq  i_eot_post_file_mode_seq;

  function new(string name = "iosf_eot_seq");
    super.new(name);
  endfunction

  virtual task body();
    
    `ovm_do(i_eot_file_mode_seq)

    `ovm_do(i_hqm_eot_rd_seq)

    `ovm_do(i_hqm_tb_eot_status_seq)

    `ovm_do(i_eot_post_file_mode_seq)
  endtask

endclass : iosf_eot_seq
