class hqm_tb_hcw_cfg_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_tb_hcw_cfg_seq,sla_sequencer)

  hqm_tb_cfg_file_mode_seq      i_file_mode_seq;
  hqm_tb_cfg2_file_mode_seq     i_file_mode_seq2;

  function new(string name = "hqm_tb_hcw_cfg_seq");
    super.new(name);
  endfunction

  virtual task init_hqm();
    hqm_init_seq     init_seq;

    init_seq = new("init_seq");
    init_seq.start(p_sequencer);
  endtask

  virtual task body();
    if(!$test$plusargs("HQM_NO_INIT_HQM")) begin
      init_hqm();
    end

    i_file_mode_seq =  hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_hcw_cfg_seq");
    i_file_mode_seq.start(get_sequencer());
    i_file_mode_seq2 =  hqm_tb_cfg2_file_mode_seq::type_id::create("i_hqm_tb_hcw_cfg2_seq");
    i_file_mode_seq2.start(get_sequencer());
  endtask


endclass : hqm_tb_hcw_cfg_seq
