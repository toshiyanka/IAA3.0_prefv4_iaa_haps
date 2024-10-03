`ifndef HQM_SLA_PCIE_CFG_BUSNUM_SEQ
`define HQM_SLA_PCIE_CFG_BUSNUM_SEQ

import lvm_common_pkg::*;


class hqm_sla_pcie_cfg_busnum_seq extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_sla_pcie_cfg_busnum_seq,sla_sequencer)

  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq  cfg_write_busnum_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq  cfg_read_busnum_seq;
  hqm_sla_pcie_mem_error_seq                    mem_err_seq;
  hqm_sla_pcie_rand_bdf_seq                     rand_bdf_seq;
  hqm_sla_pcie_init_seq                         sys_init;
  hqm_tb_cfg_file_mode_seq                      cfg99_seq;
  hqm_tb_cfg_file_mode_seq                      cfg98_seq;

  function new(string name = "hqm_sla_pcie_cfg_busnum_seq");
    super.new(name); 
  endfunction
 
  task issue_cfgwr_unimp_func();
    send_tlp( get_tlp( (ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_regs.DEVICE_COMMAND) + 32'h_ff_0000), Iosf::CfgWr0), .ur(1));
    send_tlp( get_tlp( (ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_regs.DEVICE_COMMAND)               ), Iosf::CfgRd0));
  endtask

  virtual task body();
    sla_ral_addr_t _busnum_inj_addr_;
    sla_ral_data_t rd_val, wr_rand_data, func_bar_u, func_bar_l;
    logic [4:0]  func_num=0, ur_func_num=0;
    logic [7:0]  hqm_func_base_strap_arg=0;
    bit [7:0] default_bus_num;
    int       multi_err_num;


    func_bar_u=32'h_678910;   func_bar_l=32'h_f000_0000;
	pf_cfg_regs.FUNC_BAR_U.write(status,func_bar_u,primary_id,this,.sai(legal_sai)); // -- FUNC_PF[63:32] -- //
	pf_cfg_regs.FUNC_BAR_L.write(status,func_bar_l,primary_id,this,.sai(legal_sai)); // -- FUNC_PF[31:00] -- //

    if($test$plusargs("HQM_PCIE_CFG_ERR_FUNC_NO")) begin $value$plusargs("HQM_PCIE_CFG_ERR_FUNC_NO=%0d",func_num); end
    if (func_num == 0) begin
      wr_rand_data = $urandom_range(1,255);
      _busnum_inj_addr_ = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_regs.CACHE_LINE_SIZE);
    end
      default_bus_num = _busnum_inj_addr_[31:24];
  
    // -------- Test 1 -------- // 
    _busnum_inj_addr_[31:24] = 8'h2F;
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_cfg_busnum_seq with: _busnum_inj_addr_ (0x%0x); func_num (0x%0x) and hqm_func_base_strap_arg (0x%0x), bus_number (0x%0x), default_bus_num (0x%0x)",_busnum_inj_addr_,func_num,hqm_func_base_strap_arg, _busnum_inj_addr_[31:24], default_bus_num),OVM_LOW)
    `ovm_info(get_full_name(),$psprintf("Writing random data (0x%0x)",wr_rand_data),OVM_LOW)
    `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; iosf_data == wr_rand_data; req_id == 16'h0;})
    `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})

       pf_cfg_regs.CACHE_LINE_SIZE.read(status,rd_val,primary_id,this,.sai(legal_sai));
       // -------- VFARI disabled Test -------- // 
      _busnum_inj_addr_[31:24] = 8'h_55;
      `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; iosf_data == wr_rand_data; req_id == 16'h0;})
      `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
       master_regs.CFG_DIAGNOSTIC_RESET_STATUS.read(status,rd_val,primary_id,this,.sai(legal_sai));
       pf_cfg_regs.CACHE_LINE_SIZE.read(status,rd_val,primary_id,this,.sai(legal_sai));

    if( (rd_val && 16'h_ffff) == (wr_rand_data && 16'h_ffff) ) 
           `ovm_info(get_full_name(),$psprintf("Bus num change read data (0x%0x) matched written (0x%0x) !!",rd_val,wr_rand_data),OVM_LOW)
    else   `ovm_error(get_full_name(),$psprintf("Bus num change read data (0x%0x) mismatched written (0x%0x) !!",rd_val,wr_rand_data))

    master_regs.CFG_DIAGNOSTIC_RESET_STATUS.read(status,rd_val,primary_id,this,.sai(legal_sai));

    // -------- Test 2 -------- // 
      _busnum_inj_addr_[31:24] = 8'h00;
      `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
      _busnum_inj_addr_[31:24] = 8'h2F;
      `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
    master_regs.CFG_DIAGNOSTIC_RESET_STATUS.read(status,rd_val,primary_id,this,.sai(legal_sai));

      _busnum_inj_addr_[31:24] = 8'h3F;
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_cfg_busnum_seq with: _busnum_inj_addr_ (0x%0x); func_num (0x%0x) and hqm_func_base_strap_arg (0x%0x), bus_number (0x%0x), default_bus_num (0x%0x)",_busnum_inj_addr_,func_num,hqm_func_base_strap_arg, _busnum_inj_addr_[31:24], default_bus_num),OVM_LOW)
    `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; iosf_data == 32'hF; req_id == 16'h0;})
    `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
      _busnum_inj_addr_[31:24] = 8'h2F;
      `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
      _busnum_inj_addr_[31:24] = 8'hFF;
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_cfg_busnum_seq with: _busnum_inj_addr_ (0x%0x); func_num (0x%0x) and hqm_func_base_strap_arg (0x%0x), bus_number (0x%0x), default_bus_num (0x%0x)",_busnum_inj_addr_,func_num,hqm_func_base_strap_arg, _busnum_inj_addr_[31:24], default_bus_num),OVM_LOW)
    `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; iosf_data == 32'hF; req_id == 16'h0;})
    `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
      _busnum_inj_addr_[31:24] = 8'h3F;
      `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
    master_regs.CFG_DIAGNOSTIC_RESET_STATUS.read(status,rd_val,primary_id,this,.sai(legal_sai));

      _busnum_inj_addr_[31:24] = 8'hF0;
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_cfg_busnum_seq with: _busnum_inj_addr_ (0x%0x); func_num (0x%0x) and hqm_func_base_strap_arg (0x%0x), bus_number (0x%0x), default_bus_num (0x%0x)",_busnum_inj_addr_,func_num,hqm_func_base_strap_arg, _busnum_inj_addr_[31:24], default_bus_num),OVM_LOW)
    `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; iosf_data == 32'hF; req_id == 16'h0;})
    `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
      _busnum_inj_addr_[31:24] = 8'hFF;
      `ovm_do_on_with(cfg_read_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; req_id == 16'h0; iosf_exp_error == 1'b0;bus_num_variation_test == 1'b1;})
    master_regs.CFG_DIAGNOSTIC_RESET_STATUS.read(status,rd_val,primary_id,this,.sai(legal_sai));

      _busnum_inj_addr_[31:24] = default_bus_num;
      `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _busnum_inj_addr_; iosf_data == 32'h0; req_id == 16'h0;})

    multi_err_num = $urandom_range(2,5);
    if($test$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO")) begin 
      $value$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO=%0d",ur_func_num); 
      `ovm_info(get_full_name(),$psprintf("Running hqm_sla_pcie_mem_error_seq for (0x%0x) # of times",multi_err_num),OVM_LOW);
      repeat(multi_err_num) begin
        cfg99_seq = hqm_tb_cfg_file_mode_seq::type_id::create("cfg99_seq");
        cfg99_seq.set_cfg("HQM_SEQ_CFG99", 1'b0);
        cfg99_seq.start(get_sequencer());

        `ovm_do(rand_bdf_seq);
        if(|ur_func_num) begin
            // -- Enter the D3 state now -- //
            pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,32'h_3,primary_id,this,.sai(legal_sai));
        end
        `ovm_do(mem_err_seq);

        cfg98_seq = hqm_tb_cfg_file_mode_seq::type_id::create("cfg98_seq");
        cfg98_seq.set_cfg("HQM_SEQ_CFG98", 1'b0);
        cfg98_seq.start(get_sequencer());

      end
    end
   
     if($test$plusargs("HQM_CFG_BUSNUM_UNIMP_FUNC")) issue_cfgwr_unimp_func();
  endtask : body

endclass : hqm_sla_pcie_cfg_busnum_seq

`endif
