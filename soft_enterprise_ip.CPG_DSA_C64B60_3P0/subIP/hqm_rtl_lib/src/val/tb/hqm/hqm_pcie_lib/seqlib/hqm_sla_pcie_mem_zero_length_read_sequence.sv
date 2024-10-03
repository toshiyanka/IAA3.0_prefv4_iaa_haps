`ifndef HQM_SLA_PCIE_MEM_ZERO_LENGTH_SEQ_SEQUENCE_
`define HQM_SLA_PCIE_MEM_ZERO_LENGTH_SEQ_SEQUENCE_

class hqm_sla_pcie_mem_zero_length_read_sequence extends hqm_sla_pcie_base_seq;

  `ovm_sequence_utils(hqm_sla_pcie_mem_zero_length_read_sequence,sla_sequencer)

  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_read_seq        mem_read_seq;
  rand bit [9:0] loc_tag;
  static bit            ten_bit_tag_en = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));

  constraint _loc_tag_  { if   (ten_bit_tag_en) loc_tag inside { [10'b_01_0000_0000 : 10'b_11_1111_1111] };  
                          else                  loc_tag inside { [10'b_00_0000_0000 : 10'b_00_1111_1111] };
                      }

  function new(string name = "hqm_sla_pcie_mem_zero_length_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
	logic [63:0] address;
  logic [7:0]  func_num=0;
  sla_ral_addr_t    mem_addr='h_0;

   if($test$plusargs("HQM_PCIE_MEM_FUNC_NO")) begin $value$plusargs("HQM_PCIE_MEM_FUNC_NO=%0d",func_num); end 

      mem_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),master_regs.CFG_DIAGNOSTIC_RESET_STATUS);

	    //address = get_address(master_regs.CFG_DIAGNOSTIC_RESET_STATUS);

    `ovm_info(get_name(), $sformatf("Starting Zero Length Read sequence with addr=(0x%0x), func_num=%0d", mem_addr, func_num), OVM_LOW)


	  mem_read_seq = new();
	  mem_read_seq.iosf_addr[63:32]  = mem_addr[63:32];//address[63:32];
	  mem_read_seq.iosf_addr[31:0]  = mem_addr[31:0];//address[31:00]<<2;
	  mem_read_seq.iosf_data_ = new[1];
	  mem_read_seq.iosf_tag  = loc_tag;
	  mem_read_seq.zero_length_read = 1;
	  mem_read_seq.iosf_exp_error   = 1;
          mem_read_seq.start(p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()));

  endtask

endclass

`endif
