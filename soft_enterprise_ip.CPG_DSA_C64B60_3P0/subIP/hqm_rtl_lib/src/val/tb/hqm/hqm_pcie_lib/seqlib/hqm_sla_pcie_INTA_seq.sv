`ifndef hqm_sla_pcie_INTA_seqUENCE_
`define hqm_sla_pcie_INTA_seqUENCE_

class hqm_sla_pcie_INTA_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_INTA_seq,sla_sequencer)
  
// CfgWrPcieUser_poison_seq   cfg_wr_seq;
  //cdnCfgWrPcieUserSeq cfg_wr_seq;
  //cdnCfgRdPcieUserSeq cfg_rd_seq;

  function new(string name = "hqm_sla_pcie_INTA_seq");
    super.new(name);
  endfunction

  virtual task body();

  sla_ral_data_t      wdata;
    sla_ral_data_t      cmpdata;
    sla_ral_data_t      maskdata;

//`ovm_do_on_with(cfg_wr_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h_0000_0006;addr_==32'h00000001;pcie_func_no==0;}); 

//`ovm_do_on_with(cfg_rd_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h_0010_0006;addr_==32'h00000001;is_compare == 1'b1;pcie_func_no==0;});

//`ovm_do_on_with(cfg_wr_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h00476C11;addr_==32'h00000018;pcie_func_no==0;}); //disable MSIx signal

//enable  memory operations
pf_cfg_regs.DEVICE_COMMAND.write(status,16'h_0006,primary_id,this);

  //enable INTA for PF
pf_cfg_regs.MSIX_CAP_CONTROL.write(status,32'h_0000,primary_id,this);

  //enable bad parity
hqm_system_csr_regs.PARITY_CTL.write(status,32'h0000_0001,primary_id,this);
hqm_system_csr_regs.PARITY_CTL.read(status,rd_val,primary_id,this);


hqm_system_csr_regs.VF_DIR_VPP_V[0].write(status,32'h0000_0000,primary_id,this);
hqm_system_csr_regs.VF_DIR_VPP_V[0].read(status,rd_val,primary_id,this);

 //`ovm_info(get_name(), $sformatf("Starting sequence with addr=(0x%0x), data=(0x%0x), do_write=(%0d), do_read(%0d)",address,data[0],do_write,do_read), OVM_LOW)
   // `ovm_do_on_with(mem_wr_rd_seq, p_sequencer.pick_sequencer("pcie"),{data_.size() == 4;  data_[0]==8'h00;data_[1]==8'h00; data_[2]==8'h00; data_[3]==8'h00;  addr_==64'h5000003C4; do_write_ == 1'h1; do_read_ == 1;});
	    
hqm_system_csr_regs.PARITY_CTL.write(status,32'h0000_0000,primary_id,this);
hqm_system_csr_regs.PARITY_CTL.read(status,rd_val,primary_id,this);

  endtask

endclass

`endif
