import lvm_common_pkg::*;

class back2back_cfgwr_badCmdparity_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_cfgwr_badCmdparity_seq,sla_sequencer)

  hqm_iosf_prim_cfg_wr_badparity_seq    cfg_write_badparity_seq;
  hqm_reset_init_sequence               warm_reset;
  hqm_sla_pcie_init_seq                 pcie_init;
  hqm_iosf_extra_data_phase_seq         sideband_traffic_seq;

  function new(string name = "back2back_cfgwr_badCmdparity_seq");
    super.new(name); 
    ral_access_path = iosf_sb_sla_pkg::get_src_type();
  endfunction

  virtual task body();
    bit [31:0] rdata;
      
    `ovm_info(get_type_name(),"Step1: WriteReg aer_cap_uncorr_err_sev", OVM_LOW);
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    

    `ovm_info(get_type_name(),"Step2: mem_addr and issue seq", OVM_LOW);
    randomize(cfg_addr);

    `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr0; iosf_data == 32'h0; m_driveBadCmdParity == 1;
    m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;})
        
    `ovm_info("back2back_cfgwr_badCmdparity_seq",$psprintf("Step3.1: cfgwr0: addr=0x%08x wdata=0x0",cfg_write_badparity_seq.iosf_addr),OVM_LOW)

    `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr1; iosf_data == 32'h01; m_driveBadCmdParity == 1;
       m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;})
        
    `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("Step3.2: cfgwr0: addr=0x%08x wdata=0x01",cfg_write_badparity_seq.iosf_addr),OVM_LOW)
                                    
    `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr; iosf_data == 32'hAA; m_driveBadCmdParity == 1;
       m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;})
        
    `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("Step3.3: cfgwr0: addr=0x%08x wdata=0x0",cfg_write_badparity_seq.iosf_addr),OVM_LOW)

    `ovm_info(get_type_name(),"Step4: poll aer_cap_uncorr_err_status.ecrcc=1", OVM_LOW);
    poll("hqm_pf_cfg_i", "aer_cap_uncorr_err_status", "ecrcc", SLA_FALSE, 1'b1);    

    `ovm_info(get_type_name(),"Step5: sideband_traffic_seq", OVM_LOW);
    `ovm_do(sideband_traffic_seq) 

    `ovm_info(get_type_name(),"Step6: warm_reset", OVM_LOW);
    `ovm_do(warm_reset) 
    `ovm_info(get_type_name(),"Step7: pcie_init", OVM_LOW);
    `ovm_do(pcie_init);
    `ovm_info(get_type_name(),"Completed pcie_init", OVM_LOW);

  endtask : body
endclass : back2back_cfgwr_badCmdparity_seq
