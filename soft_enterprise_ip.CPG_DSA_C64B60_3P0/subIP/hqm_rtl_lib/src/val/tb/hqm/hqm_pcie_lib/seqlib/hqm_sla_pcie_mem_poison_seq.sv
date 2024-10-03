`ifndef hqm_sla_pcie_mem_poison_seqUENCE_
`define hqm_sla_pcie_mem_poison_seqUENCE_

class hqm_sla_pcie_mem_poison_seq extends hqm_sla_pcie_base_seq;

  `ovm_sequence_utils(hqm_sla_pcie_mem_poison_seq,sla_sequencer)
  rand logic [63:0] address ;
  rand logic [31:0] data [];
  rand bit do_read ;
  rand bit do_write ;

  MemWrPCie_poison_seq mem_wr_rd_seq; 
  function new(string name = "hqm_sla_pcie_mem_poison_seq");
    super.new(name);
  endfunction

  constraint default_memwr64 {
             // mem_addr inside {64'h202000100,64'h2A0000120,64'h202000D00,64'h202000040,64'h202000044,64'h202002D04,64'h20200ED04};
               address inside {64'h500000106,64'h500000105,64'h5000000C4};
              // address inside {64'h500000418,64'h500000414,64'h500000310};

                             }

  virtual task body();

    sla_ral_data_t      wdata;
    sla_ral_data_t      cmpdata;
    sla_ral_data_t      maskdata;


   
     hqm_system_csr_regs.PARITY_CTL.write(status,32'h00000000,primary_id,this,.sai(legal_sai));

   `ovm_info(get_name(), $sformatf("Starting sequence with addr=(0x%0x), data=(0x%0x), do_write=(%0d), do_read(%0d)",address,data[0],do_write,do_read), OVM_LOW)
    `ovm_do_on_with(mem_wr_rd_seq, p_sequencer.pick_sequencer("pcie"),{data_.size() == 4;  data_[0]==8'hFF;data_[1]==8'hFF; data_[2]==8'hFF; data_[3]==8'hFF;  addr_==address; do_write_ == 1'h1; do_read_ == 0;});


   `ovm_info(get_name(), $sformatf("Starting sequence with addr=(0x%0x), data=(0x%0x), do_write=(%0d), do_read(%0d)",address,data[0],do_write,do_read), OVM_LOW)
    `ovm_do_on_with(mem_wr_rd_seq, p_sequencer.pick_sequencer("pcie"),{data_.size() == 4;  data_[0]==8'hAA;data_[1]==8'hBB; data_[2]==8'hCC; data_[3]==8'hFF;  addr_==address; do_write_ == 1'h1; do_read_ == 0;});
	    
												  																	   
																	   
																	  																  																  
																	 												  

   `ovm_info(get_name(), $sformatf("Starting sequence with addr=(0x%0x), data=(0x%0x), do_write=(%0d), do_read(%0d)",address,data[0],do_write,do_read), OVM_LOW)
    `ovm_do_on_with(mem_wr_rd_seq, p_sequencer.pick_sequencer("pcie"),{data_.size() == 4;  data_[0]==8'hAA;data_[1]==8'hBB; data_[2]==8'hCC; data_[3]==8'hFF;  addr_==address; do_write_ == 1'h1; do_read_ == 0;});
	    
			
                                                                                                                                          
  endtask

endclass

`endif
