`ifndef hqm_sla_pcie_MSIx_65_generation_seqUENCE_
`define hqm_sla_pcie_MSIx_65_generation_seqUENCE_

class hqm_sla_pcie_MSIx_65_generation_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_MSIx_65_generation_seq,sla_sequencer)
  
// CfgWrPcieUser_poison_seq   cfg_wr_seq;
  //cdnCfgWrPcieUserSeq cfg_wr_seq;
  //cdnCfgRdPcieUserSeq cfg_rd_seq;
  //MemWrPCie_seq mem_wr_rd_seq; 

  function new(string name = "hqm_sla_pcie_MSIx_65_generation_seq");
    super.new(name);
  endfunction

  virtual task body();

  sla_ral_data_t      wdata;
    sla_ral_data_t      cmpdata;
    sla_ral_data_t      maskdata;

//enable  memory operations
pf_cfg_regs.DEVICE_COMMAND.write(status,16'h_0006,primary_id,this);
//`ovm_do_on_with(cfg_wr_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h_0000_0006;addr_==32'h00000001;pcie_func_no==0;}); 

//`ovm_do_on_with(cfg_rd_seq, p_sequencer.pick_sequencer("pcie"),{data_==32'h_0010_0006;addr_==32'h00000001;is_compare == 1'b1;pcie_func_no==0;});

//setup MSI-x Table_entry
hqm_msix_mem_regs.MSG_ADDR_L[65].write(status,32'hdeadf00c,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[65].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[65].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[65].write(status,32'h0000_0000,primary_id,this);

//Read compare for above values
read_compare(hqm_msix_mem_regs.MSG_ADDR_L[65],32'hFFFF_FFFF,32'hdeadf00c,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[65],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[65],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[65],32'hFFFF_FFFF,32'h00000000,result);

  endtask

endclass

`endif
