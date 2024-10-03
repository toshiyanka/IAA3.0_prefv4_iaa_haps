`ifndef HQM_SLA_PCIE_BAR_CFG_SEQ_
`define HQM_SLA_PCIE_BAR_CFG_SEQ_

class hqm_sla_pcie_bar_cfg_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_bar_cfg_seq,sla_sequencer)
  rand bit [31:0] func_bar_h ; 
  rand bit [31:0] func_bar_l ; 
  rand bit [31:0] csr_bar_h ; 
 
  function new(string name = "hqm_sla_pcie_bar_cfg_seq");
    super.new(name);
  endfunction

  virtual task body();
	pf_cfg_regs.FUNC_BAR_L.write(status,func_bar_l,primary_id,this,.sai(legal_sai));
	pf_cfg_regs.FUNC_BAR_U.write(status,func_bar_h,primary_id,this,.sai(legal_sai));

	pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id,this,.sai(legal_sai));
	pf_cfg_regs.CSR_BAR_U.write(status,csr_bar_h,primary_id,this,.sai(legal_sai));

	// -- Not needed #500ns; //Wait for BAR regs to be updated//
  endtask


endclass

`endif
