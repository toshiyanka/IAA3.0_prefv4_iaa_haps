`ifndef cfg_order_seqUENCE_
`define cfg_order_seqUENCE_

class cfg_order_seq extends pcie_prim_base_seq;
  //`ovm_sequence_utils(cfg_order_seq,sla_sequencer)
  `ovm_sequence_utils(cfg_order_seq,IosfAgtSeqr)
 
  rand logic [31:0]  iosf_data;
  rand logic [31:0]    l_data;


  function new(string name = "cfg_order_seq");
    super.new(name);
  endfunction

  virtual task body();

     sla_ral_data_t      wdata;
    sla_ral_data_t      maskdata;
       int vf_id;
     
    l_data = 32'h0000_0000;
    wdata = iosf_data ;




read_compare(pf_cfg_regs.DEVICE_STATUS,32'h00000010,32'hFFFF_FFFF,result);
read_compare(pf_cfg_regs.PCIE_CAP_DEVICE_STATUS,16'h_0000,32'hFFFF_FFFF,result);
read_compare(pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS,32'h_0000_0000,32'hFFFF_FFFF,result);

read_compare(pf_cfg_regs.FUNC_BAR_L,{wdata[31:26],26'h00000C},32'hFFFF_FFFF,result);
read_compare(pf_cfg_regs.FUNC_BAR_U,wdata[31:0],32'hFFFF_FFFF,result);
read_compare(pf_cfg_regs.INT_LINE,{l_data[31:8],wdata[7:0]},32'hFFFF_FFFF,result);




  endtask

endclass

`endif
