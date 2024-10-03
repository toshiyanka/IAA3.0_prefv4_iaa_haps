`ifndef hqm_sla_pcie_MSIx_generation_seqUENCE_
`define hqm_sla_pcie_MSIx_generation_seqUENCE_

class hqm_sla_pcie_MSIx_generation_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_MSIx_generation_seq,sla_sequencer)
  

  function new(string name = "hqm_sla_pcie_MSIx_generation_seq");
    super.new(name);
  endfunction

  virtual task body();

  sla_ral_data_t      wdata;
    sla_ral_data_t      cmpdata;
    sla_ral_data_t      maskdata;

//enable  memory operations
pf_cfg_regs.DEVICE_COMMAND.write(status,16'h_0006,primary_id,this);
//`ovm_do_on_with(cfg_wr_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h_0000_0006;addr_==32'h00000001;pcie_func_no==0;}); 

//setup MSI-x Table_entry
hqm_msix_mem_regs.MSG_ADDR_L[0].write(status,32'hdeadf00c,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[0].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[0].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[0].write(status,32'h0000_0000,primary_id,this);

//Read compare for above values
read_compare(hqm_msix_mem_regs.MSG_ADDR_L[0],32'hFFFF_FFFF,32'hdeadf00c,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[0],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[0],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[0],32'hFFFF_FFFF,32'h00000000,result);

//setup MSI-x Table_entry
hqm_msix_mem_regs.MSG_ADDR_L[3].write(status,32'hdeadf0ac,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[3].write(status,32'hfeeddeff,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[3].write(status,32'hAAAA_BB00,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[3].write(status,32'h0000_0000,primary_id,this);

//Read compare for above values
read_compare(hqm_msix_mem_regs.MSG_ADDR_L[3],32'hFFFF_FFFF,32'hdeadf0ac,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[3],32'hFFFF_FFFF,32'hfeeddeff,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[3],32'hFFFF_FFFF,32'hAAAA_BB00,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[3],32'hFFFF_FFFF,32'h00000000,result);


//enable MSI-x 
	pf_cfg_regs.MSIX_CAP_CONTROL.write(status,32'h_8000,primary_id,this);
//`ovm_do_on_with(cfg_wr_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h80476C11;addr_==32'h00000018;pcie_func_no==0;}); //enable MSIx signal


  
  //enable bad parity
hqm_system_csr_regs.PARITY_CTL.write(status,32'h0000_0001,primary_id,this);
hqm_system_csr_regs.PARITY_CTL.read(status,rd_val,primary_id,this);


hqm_system_csr_regs.VF_DIR_VPP_V[0].write(status,32'h0000_0000,primary_id,this);
hqm_system_csr_regs.VF_DIR_VPP_V[0].read(status,rd_val,primary_id,this);

 //`ovm_info(get_name(), $sformatf("Starting sequence with addr=(0x%0x), data=(0x%0x), do_write=(%0d), do_read(%0d)",address,data[0],do_write,do_read), OVM_LOW)
   // `ovm_do_on_with(mem_wr_rd_seq, p_sequencer.pick_sequencer("pcie"),{data_.size() == 4;  data_[0]==8'h00;data_[1]==8'h00; data_[2]==8'h00; data_[3]==8'h00;  addr_==64'h5000003C4; do_write_ == 1'h1; do_read_ == 1;});
	    
hqm_system_csr_regs.PARITY_CTL.write(status,32'h0000_0000,primary_id,this);
hqm_system_csr_regs.PARITY_CTL.read(status,rd_val,primary_id,this);

//check the Msix ack 
hqm_system_csr_regs.MSIX_ACK.read(status,rd_val,primary_id,this);
read_compare(hqm_system_csr_regs.MSIX_ACK,32'hFFFF_FFFF,32'h00000001,result);

  endtask

endclass

`endif
