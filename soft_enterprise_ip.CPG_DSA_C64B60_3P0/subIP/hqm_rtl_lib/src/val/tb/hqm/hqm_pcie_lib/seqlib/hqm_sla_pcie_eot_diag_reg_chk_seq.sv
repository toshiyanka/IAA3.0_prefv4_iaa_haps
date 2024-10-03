`ifndef HQM_SLA_PCIE_EOT_DIAG_REG_CHK_SEQ_
`define HQM_SLA_PCIE_EOT_DIAG_REG_CHK_SEQ_

class hqm_sla_pcie_eot_diag_reg_chk_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_eot_diag_reg_chk_seq,sla_sequencer)

  function new(string name = "hqm_sla_pcie_eot_diag_reg_chk_seq");
    super.new(name);
  endfunction

  virtual task body();
	logic [31:0] regval;
    sla_status_t status;
	`ovm_info(get_name(),$sformatf("Starting EOT diagnostic_registers check seq"),OVM_LOW);

	read_compare(master_regs.CFG_DIAGNOSTIC_RESET_STATUS,'h_8000_0bff,'h_ffff_ffff,result);
//ADP Check
//	read_compare(master_regs.CFG_DIAGNOSTIC_STATUS,32'h_FFFF_C200,32'h_ffff_ffff,result);
	master_regs.CFG_DIAGNOSTIC_SYNDROME.read(status,rd_val,primary_id,this,.sai(SRVR_HOSTIA_UCODE_SAI));
	if(|rd_val) begin `ovm_error(get_full_name(),$psprintf("EOT: MASTER_REGS.CFG_DIAGNOSTIC_SYNDROME read compare fails as rd_val(0x%0x)!=comp_val(0x%0x)",rd_val,32'h_0)) end
	else	    begin `ovm_info(get_full_name(),$psprintf("EOT: MASTER_REGS.CFG_DIAGNOSTIC_SYNDROME read compare passes as rd_val(0x%0x)",rd_val),OVM_LOW) end
	//master_regs.CFG_DIAGNOSTIC_SYNDROME.read(status,rd_val,primary_id,this,.sai(SRVR_PM_PCS_SAI));
	//if(|rd_val) begin `ovm_error(get_full_name(),$psprintf("EOT: MASTER_REGS.CFG_DIAGNOSTIC_SYNDROME read compare fails as rd_val(0x%0x)!=comp_val(0x%0x)",rd_val,32'h_0)) end


  endtask

  task pre_body();
    ovm_test_done.raise_objection(this);
  endtask

  task post_body();
    ovm_test_done.drop_objection(this);
  endtask


endclass

`endif
