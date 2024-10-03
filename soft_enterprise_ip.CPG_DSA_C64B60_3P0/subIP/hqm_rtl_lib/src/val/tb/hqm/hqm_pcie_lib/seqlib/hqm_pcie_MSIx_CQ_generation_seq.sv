`ifndef hqm_pcie_MSIx_CQ_generation_seqUENCE_
`define hqm_pcie_MSIx_CQ_generation_seqUENCE_

class hqm_pcie_MSIx_CQ_generation_seq extends tgen_base_seq;
  `ovm_sequence_utils(hqm_pcie_MSIx_CQ_generation_seq,sla_sequencer)
  
// CfgWrPcieUser_poison_seq   cfg_wr_seq;
 // cdnCfgWrPcieUserSeq cfg_wr_seq;
 // cdnCfgRdPcieUserSeq cfg_rd_seq;
 // MemWrPCie_seq mem_wr_rd_seq; 

  function new(string name = "hqm_pcie_MSIx_CQ_generation_seq");
    super.new(name);
  endfunction

  virtual task body();

  sla_ral_data_t      wdata;
    sla_ral_data_t      cmpdata;
    sla_ral_data_t      maskdata;


 // Enable PF memory operations
pf_cfg_regs.DEVICE_COMMAND.write(status,16'h_0006,primary_id,this);
read_compare(pf_cfg_regs.DEVICE_COMMAND,32'hFFFF_FFFF,16'h0006,result);

//bar setting 
pf_cfg_regs.FUNC_BAR_L.write(status,32'h0000_0000,primary_id,this);
pf_cfg_regs.FUNC_BAR_U.write(status,32'h0000_0001,primary_id,this);
pf_cfg_regs.CSR_BAR_L.write(status,32'h0000_0000,primary_id,this);
pf_cfg_regs.CSR_BAR_U.write(status,32'h0000_0002,primary_id,this);
   
    
    //setup MSI-x Table_entry
hqm_msix_mem_regs.MSG_ADDR_L[0].write(status,32'hdeadf000,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[0].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[0].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[0].write(status,32'h0000_0000,primary_id,this);

hqm_msix_mem_regs.MSG_ADDR_L[1].write(status,32'hdeadf001,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[1].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[1].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[1].write(status,32'h0000_0000,primary_id,this);

hqm_msix_mem_regs.MSG_ADDR_L[2].write(status,32'hdeadf002,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[2].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[2].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[2].write(status,32'h0000_0000,primary_id,this);

hqm_msix_mem_regs.MSG_ADDR_L[3].write(status,32'hdeadf003,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[3].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[3].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[3].write(status,32'h0000_0000,primary_id,this);

hqm_msix_mem_regs.MSG_ADDR_L[4].write(status,32'hdeadf004,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[4].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[4].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[4].write(status,32'h0000_0000,primary_id,this);


hqm_msix_mem_regs.MSG_ADDR_L[5].write(status,32'hdeadf005,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[5].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[5].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[5].write(status,32'h0000_0000,primary_id,this);

hqm_msix_mem_regs.MSG_ADDR_L[6].write(status,32'hdeadf006,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[6].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[6].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[6].write(status,32'h0000_0000,primary_id,this);

hqm_msix_mem_regs.MSG_ADDR_L[7].write(status,32'hdeadf007,primary_id,this);
hqm_msix_mem_regs.MSG_ADDR_U[7].write(status,32'hfeeddeaf,primary_id,this);
hqm_msix_mem_regs.MSG_DATA[7].write(status,32'hAAAA_BBBB,primary_id,this);
hqm_msix_mem_regs.VECTOR_CTRL[7].write(status,32'h0000_0000,primary_id,this);




//Read compare for above values
read_compare(hqm_msix_mem_regs.MSG_ADDR_L[0],32'hFFFF_FFFF,32'hdeadf000,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[0],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[0],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[0],32'hFFFF_FFFF,32'h000000000,result);

read_compare(hqm_msix_mem_regs.MSG_ADDR_L[1],32'hFFFF_FFFF,32'hdeadf001,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[1],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[1],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[1],32'hFFFF_FFFF,32'h000000000,result);

read_compare(hqm_msix_mem_regs.MSG_ADDR_L[2],32'hFFFF_FFFF,32'hdeadf002,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[2],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[2],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[2],32'hFFFF_FFFF,32'h000000000,result);

read_compare(hqm_msix_mem_regs.MSG_ADDR_L[3],32'hFFFF_FFFF,32'hdeadf003,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[3],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[3],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[3],32'hFFFF_FFFF,32'h000000000,result);

read_compare(hqm_msix_mem_regs.MSG_ADDR_L[4],32'hFFFF_FFFF,32'hdeadf004,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[4],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[4],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[4],32'hFFFF_FFFF,32'h000000000,result);

read_compare(hqm_msix_mem_regs.MSG_ADDR_L[5],32'hFFFF_FFFF,32'hdeadf005,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[5],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[5],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[5],32'hFFFF_FFFF,32'h000000000,result);

read_compare(hqm_msix_mem_regs.MSG_ADDR_L[6],32'hFFFF_FFFF,32'hdeadf006,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[6],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[6],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[6],32'hFFFF_FFFF,32'h000000000,result);

read_compare(hqm_msix_mem_regs.MSG_ADDR_L[7],32'hFFFF_FFFF,32'hdeadf007,result);
read_compare(hqm_msix_mem_regs.MSG_ADDR_U[7],32'hFFFF_FFFF,32'hfeeddeaf,result);
read_compare(hqm_msix_mem_regs.MSG_DATA[7],32'hFFFF_FFFF,32'hAAAA_BBBB,result);
read_compare(hqm_msix_mem_regs.VECTOR_CTRL[7],32'hFFFF_FFFF,32'h000000000,result);



//enable MSI-x 
pf_cfg_regs.MSIX_CAP_CONTROL.write(status,16'h8000,primary_id,this);
read_compare(pf_cfg_regs.MSIX_CAP_CONTROL,32'hFFFF_FFFF,16'h8047,result);

//MSIX
if($test$plusargs("MSIX0"))begin
hqm_system_csr_regs.DIR_CQ_ISR[0].write(status,32'h800,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h800,primary_id,this);
end


if($test$plusargs("MSIX1"))begin
hqm_system_csr_regs.DIR_CQ_ISR[1].write(status,32'h841,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h841,primary_id,this);
end

if($test$plusargs("MSIX2"))begin

hqm_system_csr_regs.DIR_CQ_ISR[2].write(status,32'h882,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h882,primary_id,this);
end


if($test$plusargs("MSIX3"))begin
hqm_system_csr_regs.DIR_CQ_ISR[3].write(status,32'h8C3,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h8C3,primary_id,this);
end

if($test$plusargs("MSIX4"))begin

hqm_system_csr_regs.DIR_CQ_ISR[4].write(status,32'h904,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h904,primary_id,this);
end

if($test$plusargs("MSIX5"))begin

hqm_system_csr_regs.DIR_CQ_ISR[4].write(status,32'h945,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h945,primary_id,this);
end

if($test$plusargs("MSIX6"))begin

hqm_system_csr_regs.DIR_CQ_ISR[4].write(status,32'h986,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h986,primary_id,this);
end

if($test$plusargs("MSIX7"))begin

hqm_system_csr_regs.DIR_CQ_ISR[4].write(status,32'h9C7,primary_id,this);
hqm_system_csr_regs.LDB_CQ_ISR[0].write(status,32'h9C7,primary_id,this);
end


credit_hist_pipe_regs.CFG_LDB_CQ_INTR_ARMED0.write(status,32'hFFFF,primary_id,this);
credit_hist_pipe_regs.CFG_DIR_CQ_INTR_ARMED0.write(status,32'hFFFF,primary_id,this);

  
  endtask

endclass

`endif
