
class hqm_pcie_ral_access_seq extends sla_ral_sequence_base;
  `ovm_sequence_utils(hqm_pcie_ral_access_seq,cdnPcieOvmUserSequencer);

  Iosf::address_t       addr;

//  hqm_sla_pcie_mem_seq	mem_read_seq;
//  hqm_sla_pcie_mem_seq	mem_write_seq;

  function new(string n="hqm_pcie_ral_access_seq");
    super.new();

  endfunction

  task body;

	logic [63:0]  absolute_addr;
	logic [31:0]  loc_compare_data;
	logic [31:0]  loc_expected = 0;
	logic [31:0]  loc_compare_mask;
	logic		  loc_compare;
	cdnPcieOvmUserSequencer	ral_seqr;

	if(!$cast(ral_seqr,get_sequencer()))
		`ovm_fatal(get_name(),"Couldn't cast my sequencer to ral_seqr")

    addr = target.get_addr_val(source);
	absolute_addr = addr ;
	absolute_addr[31:0] = (addr[31:0]>>2) ;

    `ovm_info(get_name(), $sformatf("RAL called PCIe sequence: reg=(%s) addr=(0x%0x), ral_data=(0x%0x), absolute_addr(0x%0x), operation(%s), space=(%s), bar(%0d)",target.get_name(),addr,ral_data,absolute_addr,operation,target.get_space(),target.get_bar("MEM-SB")), OVM_LOW)
    ral_status = SLA_OK;


    case (operation)
      "read","readx": begin

        case (target.get_space())
          "CFG":  begin
				  loc_compare           = (operation == "readx");
				  loc_compare_data  = loc_compare         ? loc_expected : 32'h_0 ;


				  absolute_addr[31:0]	  = (addr[31:0]<<2) ;
				  absolute_addr[31:24]	  = target.get_bus_num()+1; //
			  	  absolute_addr[23:16]	  = (target.get_dev_num()<<3) | target.get_func_num();
				  absolute_addr[15:0]	  = (addr[15:0]>>2) ;
				  `ovm_info(get_name(), $sformatf("CFG absolute_addr(0x%0x)",absolute_addr), OVM_LOW)

					`ovm_do_with(cfg_read_seq, {addr_ == absolute_addr; is_compare==loc_compare; data_ == loc_compare_data;is_ral==1'b1; exp_err == ignore_access_error;})
				  end
          "MEM": begin
		    `ovm_do_with(mem_read_seq,{data_.size==4;
                                                                      data_[0]==ral_data[31:24];
                                                                      data_[1]==ral_data[23:16];
                                                                      data_[2]==ral_data[15:8];
                                                                      data_[3]==ral_data[7:0];
                                                                      addr_==absolute_addr;
                                                                      do_write_ == 0;
                                                                      do_read_ == 1'b1; exp_err == ignore_access_error;});

          end
          default: begin
          end
        endcase

		ral_seqr.loc_tlm_inst.store_txn_id_tag_data[absolute_addr] = 1;
		`ovm_info(get_name(), $sformatf("Waiting for payload update for Absolute Address(0x%0x)",absolute_addr),OVM_LOW)
		while(!ral_seqr.loc_tlm_inst.stored_read_data.exists(absolute_addr)) @ral_seqr.loc_tlm_inst.received_iosf_pkt;
		ral_data[31:0] = (ral_seqr.loc_tlm_inst.stored_read_data[absolute_addr] >> (8*addr[1:0])) & ((1<<target.get_size())-1);
		`ovm_info(get_name(), $sformatf("Received payload update (0x%0x) and ral_data (0x%0x) for Absolute Address(0x%0x) from PCIE IOSF TLM ",ral_seqr.loc_tlm_inst.stored_read_data[absolute_addr],ral_data,absolute_addr),OVM_LOW)
		
		//Delete existing read data and address from look up table, to avoid false read data for next read// 
		ral_seqr.loc_tlm_inst.store_txn_id_tag_data.delete(absolute_addr);
		ral_seqr.loc_tlm_inst.stored_read_data.delete(absolute_addr);

      end
      "write": begin
			  if((8*(target.get_offset()%'h_4))!=0)	begin
				ral_data[31:0] = (ral_data[31:0] << (8*(target.get_offset()%'h_4))) | get_previous_reg_val(target) ;
			  end 	
			  	
			  if(target.get_size()!=32)	begin
				ral_data[31:0] = (ral_data[31:0]) & ((1<<(target.get_size()+(8*(target.get_offset()%'h_4)))) -1);
				ral_data[31:0] = ral_data[31:0] | get_next_reg_val(target);
			  end
			  `ovm_info(get_name(), $sformatf("Written payload/ral_data (0x%0x) for Absolute Address(0x%0x) from PCIE IOSF TLM ",ral_data,absolute_addr),OVM_LOW)

        case (target.get_space())
          "CFG": begin
				  absolute_addr[31:0]	  = (addr[31:0]<<2) ;
				  absolute_addr[31:24]	  = target.get_bus_num()+1; //
			  	  absolute_addr[23:16]	  = (target.get_dev_num()<<3) | target.get_func_num();
				  absolute_addr[15:0]	  = (addr[15:0]>>2) ;
				  `ovm_info(get_name(), $sformatf("CFG absolute_addr(0x%0x)",absolute_addr), OVM_LOW)

		           `ovm_do_with(cfg_write_seq, {addr_ == absolute_addr;data_ == ral_data[31:0];is_ral==1'b1; exp_err == ignore_access_error;})
				end
          "MEM": begin
				   `ovm_do_with(mem_write_seq,{data_.size==4;
                                                                      data_[0]==ral_data[31:24];
                                                                      data_[1]==ral_data[23:16];
                                                                      data_[2]==ral_data[15:8];
                                                                      data_[3]==ral_data[7:0];
                                                                      addr_==absolute_addr;
                                                                      do_write_ == 1'b1;
                                                                      do_read_ == 0; exp_err == (target.get_name()=="HQM_CSR_RAC_HI");});
				end
          default: begin
            ral_status = SLA_FAIL;
          end
        endcase
      end
        default: begin
          ral_status = SLA_FAIL;
        end
    endcase
  endtask


  virtual function logic [31:0] get_next_reg_val(sla_ral_reg r);
	  logic [31:0]	offset;
	  logic [31:0]	loc_offset = 0;
	  logic [31:0]	max_offset;
	  sla_ral_file	r_file;
	  sla_ral_reg	temp_reg;

	  get_next_reg_val=32'h_0;

	  r_file = r.get_file();
	  offset = r.get_offset();
	  max_offset = 'h_4 - ( (offset%'h_4) + (r.get_size()/8) );

	  for (int i=1; i<=max_offset; i++)	begin
		temp_reg = r_file.find_reg_by_offset(offset+i);
		if(temp_reg)	begin
		  get_next_reg_val = get_next_reg_val | (temp_reg.get()<< ( 8*(temp_reg.get_offset()%'h_4) )) ;
		  `ovm_info(get_name(), $sformatf("next_reg (%s) with last_written(0x%0x) and offset (0x%0x)",temp_reg.get_name(),temp_reg.get(),temp_reg.get_offset()),OVM_LOW)
		end
	  end
	  `ovm_info(get_name(), $sformatf("next_last_written(0x%0x)",get_next_reg_val),OVM_LOW)
  endfunction: get_next_reg_val

  virtual function logic [31:0] get_previous_reg_val(sla_ral_reg r);
	  logic [31:0]	offset;
	  logic [31:0]	loc_offset = 0;
	  logic [31:0]	max_offset;
	  sla_ral_file	r_file;
	  sla_ral_reg	temp_reg;

	  get_previous_reg_val=32'h_0;

	  r_file = r.get_file();
	  offset = r.get_offset();
	  max_offset = offset%'h_4;

	  for (int i=1; i<=max_offset; i++)	begin
		temp_reg = r_file.find_reg_by_offset(offset-i);
		if(temp_reg)	begin
		  get_previous_reg_val = get_previous_reg_val | (temp_reg.get()<< ( 8*(temp_reg.get_offset()%'h_4) )) ;
		  `ovm_info(get_name(), $sformatf("prev_reg (%s) with last_written(0x%0x) and offset (0x%0x)",temp_reg.get_name(),temp_reg.get(),temp_reg.get_offset()),OVM_LOW)
		end
	  end
	  `ovm_info(get_name(), $sformatf("prev_last_written(0x%0x)",get_previous_reg_val),OVM_LOW)
  endfunction: get_previous_reg_val


endclass
