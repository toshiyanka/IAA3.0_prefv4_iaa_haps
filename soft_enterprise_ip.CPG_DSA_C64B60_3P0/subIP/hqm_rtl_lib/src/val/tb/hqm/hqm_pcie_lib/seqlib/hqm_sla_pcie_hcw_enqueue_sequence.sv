//`ifndef HQM_SLA_PCIE_HCW_ENQUEUE_SEQUENCE_
//`define HQM_SLA_PCIE_HCW_ENQUEUE_SEQUENCE_

class hqm_sla_pcie_hcw_enqueue_sequence extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_hcw_enqueue_sequence,sla_sequencer)
  hqm_sla_pcie_mem_seq		hcw_mem_wr_seq; 
  rand hcw_transaction		hcw_trans;
/*
  constraint soft_enquene_address {
	soft enqueue_address == 0;
  }
*/  
  function new(string name = "hqm_sla_pcie_hcw_enqueue_sequence");
    super.new(name);
	hcw_trans = new();
  endfunction

  virtual task body();
	bit	  [63:0]			enqueue_address;
	logic [127:0] packed_hcw = hcw_trans.byte_pack(0); //Packed in IOSF format//

    hcw_trans.print();

    sla_ral_reg       my_reg;
    sla_ral_data_t    ral_data;

    enqueue_address = 64'h0000_0000_0200_0000;

    my_reg   = ral.find_reg_by_file_name("func_bar_u", "hqm_pf_cfg_i");
    ral_data = my_reg.get_actual();

    enqueue_address[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name("func_bar_l", "hqm_pf_cfg_i");
    ral_data = my_reg.get_actual();

    enqueue_address[31:26] = ral_data[31:26];

    enqueue_address[19:12] = hcw_trans.ppid;
    enqueue_address[20]    = hcw_trans.is_ldb;

    enqueue_address[31:0]  = (enqueue_address[31:0] >> 2);

	`ovm_info(get_name(), $sformatf("PCIe Enqueue Address=(0x%0x) Data=(0x%0x) ",enqueue_address,packed_hcw[127:0]),OVM_LOW)


    `ovm_do_with(hcw_mem_wr_seq,{data.size()==4;
								data[0]==packed_hcw[127:96];
								data[1]==packed_hcw[95:64];
								data[2]==packed_hcw[63:32];
								data[3]==packed_hcw[31:00];
								address==enqueue_address; 
								do_write==1'b1; 
								do_read==1'b0;}); 

  endtask

endclass

//`endif
