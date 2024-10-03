`ifndef HQM_PCIE_FLUSH_PHASE_SEQ_SV
`define HQM_PCIE_FLUSH_PHASE_SEQ_SV

class hqm_pcie_flush_phase_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_pcie_flush_phase_seq, sla_sequencer)

  hqm_tb_cfg_file_mode_seq i_cfg_file_mode_seq;
  const string             seq_name;

  function new(string name = "hqm_pcie_flush_phase_seq");
    super.new(name);
    seq_name = "hqm_pcie_flush_phase_seq";
  endfunction

  extern virtual task body();

endclass

task hqm_pcie_flush_phase_seq::body();

    string file_name;
    string cfg_name;

    cfg_name = "HQM_PCIE_FLUSH";
    void'($value$plusargs("HQM_PCIE_FLUSH=%0s", file_name));
	`ovm_info(get_full_name(),$psprintf("%0s::%0s=%0s", seq_name, cfg_name,file_name),OVM_LOW)
    i_cfg_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_cfg_file_mode_seq");
    i_cfg_file_mode_seq.set_cfg(cfg_name, 1'b0);
    i_cfg_file_mode_seq.start(get_sequencer());

endtask

`endif //HQM_PCIE_FLUSH_PHASE_SEQ_SV
