class hqm_eot_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_eot_seq,sla_sequencer)

  hqm_eot_rd_seq                i_hqm_eot_rd_seq;
  hqm_system_eot_seq            i_hqm_system_eot_seq;

  function new(string name = "hqm_eot_seq");
    super.new(name);
  endfunction

  virtual task body();
    `ovm_do(i_hqm_eot_rd_seq)

    `ovm_do(i_hqm_system_eot_seq)
  endtask

endclass : hqm_eot_seq
