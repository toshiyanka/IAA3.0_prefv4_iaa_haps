`ifndef HQM_SLA_PCIE_P_BYPASS_NP_REQ_SEQUENCE_
`define HQM_SLA_PCIE_P_BYPASS_NP_REQ_SEQUENCE_

class hqm_sla_pcie_posted_bypass_non_posted_reqs_sequence extends cdnPcieOvmUserBaseSeq;
  `ovm_sequence_utils(hqm_sla_pcie_posted_bypass_non_posted_reqs_sequence,cdnPcieOvmUserSequencer)
	
  function new(string name = "hqm_sla_pcie_posted_bypass_non_posted_reqs_sequence");
    super.new(name);
  endfunction

  virtual task body();
	cdnPcieOvmUserSequencer ral_seqr;
	if(!$cast(ral_seqr,get_sequencer())) `ovm_fatal(get_name(),"Couldn't cast my sequencer to ral_seqr")
	`ovm_info(get_name(),"Starting bypass np req sequence",OVM_LOW);
	ral_seqr.loc_tlm_inst.set_expect_np_req_bypass(1);

  endtask

endclass

class hqm_sla_pcie_bypass_np_req_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_bypass_np_req_seq,sla_sequencer)

  hqm_sla_pcie_posted_bypass_non_posted_reqs_sequence bypass_np_req_seq;

  function new(string name = "hqm_sla_pcie_bypass_np_req_seq");
    super.new(name);
  endfunction

  virtual task body();
	sla_ral_reg reg_list[$];
	`ovm_do_on(bypass_np_req_seq,p_sequencer.pick_sequencer("pcie"));
	pf_cfg_regs.get_regs(reg_list);

	//Multiple NP requests sent out//
	foreach(reg_list[i])
	  reg_list[i].read(status,rd_val,primary_id,this);

	list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[0].read(status,rd_val,primary_id,this);

	//Followed by posted request//
	list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[0].write(status,rd_val,primary_id,this);
	list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[0].write(status,rd_val,primary_id,this);
	list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[0].write(status,rd_val,primary_id,this);

  endtask

endclass

`endif
