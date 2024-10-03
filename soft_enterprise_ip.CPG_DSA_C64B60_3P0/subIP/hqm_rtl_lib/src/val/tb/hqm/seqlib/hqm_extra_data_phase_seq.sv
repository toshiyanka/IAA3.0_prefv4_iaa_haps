`ifndef HQM_EXTRA_DATA_SEQ_SV
`define HQM_EXTRA_DATA_SEQ_SV

class hqm_extra_data_phase_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_extra_data_phase_seq, sla_sequencer)

  hqm_tb_cfg_file_mode_seq i_cfg_file_mode_seq;
  hqm_tb_cfg_file_mode_seq i_hcw_file_mode_seq;

  function new(string name = "hqm_extra_data_phase_seq");
    super.new(name);
  endfunction

  extern virtual task body();

endclass

task hqm_extra_data_phase_seq::body();
	`ovm_info(get_full_name(),$psprintf("Plusargs defined HQM_EXTRA_DATA_PHASE_CFG=%0d, HQM_EXTRA_DATA_PHASE_HCW=%0d",$test$plusargs("HQM_EXTRA_DATA_PHASE_CFG"),$test$plusargs("HQM_EXTRA_DATA_PHASE_HCW")),OVM_LOW)
    i_cfg_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_cfg_file_mode_seq");
    i_cfg_file_mode_seq.set_cfg("HQM_EXTRA_DATA_PHASE_CFG", 1'b0);
    i_cfg_file_mode_seq.start(get_sequencer());

    i_hcw_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hcw_file_mode_seq");
    i_hcw_file_mode_seq.set_cfg("HQM_EXTRA_DATA_PHASE_HCW", 1'b0);
    i_hcw_file_mode_seq.start(get_sequencer());

endtask

`endif //HQM_BACKGROUND_CFG_SEQ_SV
