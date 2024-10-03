`ifndef HQM_SLA_PCIE_EOT_SEQUENCE_
`define HQM_SLA_PCIE_EOT_SEQUENCE_

class hqm_sla_pcie_eot_sequence extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_eot_sequence,sla_sequencer)
  hqm_sla_pcie_eot_checks_sequence	func_eot_chk_seq;

  rand logic [4:0]	total_func_no;
  constraint soft_total_func_no_c	{	soft total_func_no == 16;  }

  function new(string name = "hqm_sla_pcie_eot_sequence");
    super.new(name);
  endfunction

  virtual task body();
	sla_ral_data_t num_vf, pasid_control, pasid_enable;
	string reg_file_name;

	`ovm_do_with(func_eot_chk_seq,{func_no==0;})

  endtask

endclass

`endif
