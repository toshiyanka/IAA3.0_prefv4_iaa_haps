`ifndef order_seqUENCE_
`define order_seqUENCE_

class order_seq extends pcie_prim_base_seq;
  //`ovm_sequence_utils(order_seq,sla_sequencer)
  `ovm_sequence_utils(order_seq,IosfAgtSeqr)
 
  rand logic [31:0]  iosf_data;
  rand logic [31:0]    l_data;
  hqm_sif_csr_bridge_file hqm_sif_csr_regs;

  function new(string name = "order_seq");
    super.new(name);
    `sla_assert($cast(hqm_sif_csr_regs,          ral.find_file("hqm_sif_csr")),     ("Unable to get handle to iosf_regs."))
  endfunction

  virtual task body();

    sla_ral_data_t      wdata1;
    sla_ral_data_t      wdata2;
    sla_ral_data_t      maskdata;
     
    l_data = 32'h0000_0000;
    wdata1 = 'h100; //iosf_data ;
    wdata2 = 'hF; //iosf_data ;




read_compare(pf_cfg_regs.DEVICE_STATUS,32'h00000010,32'hFFFF_FFFF,result);
read_compare(pf_cfg_regs.PCIE_CAP_DEVICE_STATUS,16'h_0000,32'hFFFF_FFFF,result);
read_compare(pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS,32'h_0000_0000,32'hFFFF_FFFF,result);

//read_compare(hqm_system_csr_regs.CMPL_DATA_FIFO_CTL,{l_data[31:5],wdata[4:0]},32'hFFFF_FFFF,result);
//read_compare(hqm_system_csr_regs.TI_SB_THRESH,{l_data[31:9],wdata[8:0]},32'hFFFF_FFFF,result);
//read_compare(hqm_system_csr_regs.CMPL_HDR_FIFO_CTL,{l_data[31:4],wdata[3:0]},32'hFFFF_FFFF,result);

read_compare(hqm_sif_csr_regs.IBCPL_HDR_FIFO_CTL,{l_data[31:9],wdata1[8:0]},32'hFFFF_FFFF,result);
read_compare(hqm_sif_csr_regs.RI_PHDR_FIFO_CTL,{l_data[31:9],wdata2[8:0]},32'hFFFF_FFFF,result);



  endtask

endclass

`endif
