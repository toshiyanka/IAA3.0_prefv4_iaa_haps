`ifndef HQM_SLA_PCIE_REG_RST_CHK_SEQUENCE_
`define HQM_SLA_PCIE_REG_RST_CHK_SEQUENCE_

class hqm_sla_pcie_reg_rst_val_chk_sequence extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_reg_rst_val_chk_sequence,sla_sequencer)

  hqm_tb_cfg_sequences_pkg::ral_pfrst_seq  rst_tb;

   function new(string name = "hqm_sla_pcie_reg_rst_val_chk_sequence");
    super.new(name);
   endfunction

  task reg_list_rst_chk(sla_ral_reg reg_list[$]);
	sla_ral_file reg_file;
	reg_file = reg_list[0].get_file();
	  foreach(reg_list[i]) begin
			  `ovm_info(get_name(), $sformatf("Checking reset_val for %s",reg_list[i].get_name()),OVM_LOW)
			  reset_check(reg_list[i]);
	  end
	  `ovm_info(get_name(), $sformatf("Completed reset_val check for (%0d) registers of reg_file (%0s)",reg_list.size(),reg_file.get_name()),OVM_LOW)
  endtask


  virtual task body();
	sla_ral_file  loc_ral_file;
	sla_ral_reg	  loc_reg_list[$];
	string		  reg_file_name;

    `ovm_do(rst_tb);

	if(!$value$plusargs("HQM_RESET_CHECK_REG_FILE=%s",reg_file_name))
			reg_file_name="hqm_pf_cfg_i";
	
	loc_ral_file = ral.find_file(reg_file_name);

	loc_ral_file.get_regs(loc_reg_list);

    reg_list_rst_chk(loc_reg_list);
	  
  endtask

endclass

`endif
