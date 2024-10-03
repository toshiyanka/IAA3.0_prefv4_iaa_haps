
class hqm_iosf_eot_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_iosf_eot_seq, sla_sequencer)

  hqm_tb_hcw_eot_file_mode_seq hcw_eot_file_mode_seq;
  hqm_sla_pcie_eot_sequence pcie_eot_seq;

  function new(string name = "hqm_iosf_eot_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit skip_pcie_eot, skip_hcw_eot;
    super.body();
    `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_eot_seq started \n"),OVM_LOW)

    if (!$value$plusargs("HQM_SKIP_HCW_EOT=%b",skip_hcw_eot))
        skip_hcw_eot = 1'b0;
    if (!$value$plusargs("HQM_SKIP_PCIE_EOT=%b",skip_pcie_eot))
        skip_pcie_eot = 1'b0;

    if (!skip_hcw_eot) 
       `ovm_do(hcw_eot_file_mode_seq);

    `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_eot_seq ended \n"),OVM_LOW)
  endtask: body
endclass: hqm_iosf_eot_seq   

