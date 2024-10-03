class hqm_iosf_prim_pf_dump_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_prim_pf_dump_seq,sla_sequencer)

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_rd_seq  cfg_rd_seq;

  function new(string name = "hqm_iosf_prim_pf_dump_seq");
    super.new(name); 
  endfunction

  virtual task body();

    `ovm_do_with(cfg_rd_seq, {iosf_addr == 0;})
    `ovm_do_with(cfg_rd_seq, {iosf_addr == 4;})
    `ovm_do_with(cfg_rd_seq, {iosf_addr == 8;})
    `ovm_do_with(cfg_rd_seq, {iosf_addr == 12;})

  endtask : body
endclass : hqm_iosf_prim_pf_dump_seq
