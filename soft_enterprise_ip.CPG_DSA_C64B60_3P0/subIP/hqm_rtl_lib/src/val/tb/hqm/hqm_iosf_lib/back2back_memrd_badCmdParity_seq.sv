import lvm_common_pkg::*;

class back2back_memrd_badCmdParity_seq  extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_memrd_badCmdParity_seq,sla_sequencer)
   
  hqm_sla_pcie_init_seq                 pcie_init;
  hqm_reset_init_sequence               warm_reset;
  hqm_iosf_prim_mem_rd_badparity_seq    mem_read_seq;
  hqm_iosf_extra_data_phase_seq         sideband_traffic_seq;

  function new(string name = "back2back_memrd_badCmdParity_seq");
    super.new(name); 
    ral_access_path = iosf_sb_sla_pkg::get_src_type();
  endfunction

  virtual task body();
    bit [31:0]     rdata;
    bit [31:0]     rdata_new[8];
    

    `ovm_info(get_type_name(),"Step1: WriteReg aer_cap_uncorr_err_sev/aer_cap_corr_err_mask", OVM_LOW);
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);    

    `ovm_info(get_type_name(),"Step2: mem_addr and issue seq", OVM_LOW);
    randomize(mem_addr);

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr; m_driveBadCmdParity == 1; m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;})
    rdata = mem_read_seq.iosf_data;
    `ovm_info(get_type_name(),$psprintf("Step3: memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

    `ovm_info(get_type_name(),"Step3: poll aer_cap_uncorr_err_status.ecrcc=1", OVM_LOW);
    poll("hqm_pf_cfg_i", "aer_cap_uncorr_err_status", "ecrcc", SLA_FALSE, 1'b1);    
    
    `ovm_info(get_type_name(),"Step4: sideband_traffic_seq", OVM_LOW);
    `ovm_do(sideband_traffic_seq) 

    `ovm_info(get_type_name(),"Step5: warm_reset", OVM_LOW);
    `ovm_do(warm_reset) 
    `ovm_info(get_type_name(),"Step6: pcie_init", OVM_LOW);
    `ovm_do(pcie_init);
    `ovm_info(get_type_name(),"Completed pcie_init", OVM_LOW);
    
  endtask : body

endclass : back2back_memrd_badCmdParity_seq  
