import lvm_common_pkg::*;

class back2back_posted_badcmdparity_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_posted_badcmdparity_seq,sla_sequencer)

  hqm_sla_pcie_init_seq                         pcie_init;
  hqm_iosf_prim_mem_wr_badparity_seq            mem_write_seq;
  hqm_reset_init_sequence                   warm_reset;
  hqm_iosf_extra_data_phase_seq                 sideband_traffic_seq;
  rand Iosf::data_t     mem_data[];

constraint mem_data_size { 
  // mem_data.size() inside {[8:8]};
  (mem_data.size() == 1);
 }


  function new(string name = "back2back_posted_badcmdparity_seq");
    super.new(name); 
    ral_access_path = iosf_sb_sla_pkg::get_src_type();
  endfunction

  virtual task body();
    bit [31:0]      rdata;
     
    foreach(mem_data[i]) begin 
      mem_data[i] = i; 
    end  

    `ovm_info(get_type_name(),"Step1: WriteReg aer_cap_uncorr_err_sev/aer_cap_corr_err_mask", OVM_LOW);
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);    

    `ovm_info(get_type_name(),"Step2: mem_addr", OVM_LOW);
    randomize(mem_addr);
                                     
    `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
    `ovm_info(get_type_name(),"Step3: start_item mem_write_seq", OVM_LOW);
    start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == mem_addr; iosf_data.size() == mem_data.size(); m_driveBadCmdParity == 1; m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;}) begin
      `ovm_error("get_type_name()", "Randomization failed for mem_write_seq");
    end
    foreach (mem_data[i]) begin
      mem_write_seq.iosf_data[i] = mem_data[i];
    end
    finish_item(mem_write_seq);
    `ovm_info(get_type_name(),"Step4: mem_write_seq finish_item done", OVM_LOW);

    `ovm_info(get_type_name(),"Step5: poll aer_cap_uncorr_err_status.ecrcc=1", OVM_LOW);
    poll("hqm_pf_cfg_i", "aer_cap_uncorr_err_status", "ecrcc", SLA_FALSE, 1'b1);    

    `ovm_info(get_type_name(),"Step6: sideband_traffic_seq", OVM_LOW);
    `ovm_do(sideband_traffic_seq) 
    `ovm_info(get_type_name(),"Step7: warm_reset", OVM_LOW);
    `ovm_do(warm_reset) 
    `ovm_info(get_type_name(),"Step8: pcie_init", OVM_LOW);
    `ovm_do(pcie_init);
    `ovm_info(get_type_name(),"Completed pcie_init", OVM_LOW);

  endtask : body
endclass : back2back_posted_badcmdparity_seq 
