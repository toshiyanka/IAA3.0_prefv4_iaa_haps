import lvm_common_pkg::*;

class back2back_cfgrd_badDataparity_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_cfgrd_badDataparity_seq,sla_sequencer)

  hqm_iosf_prim_cfg_rd_badparity_seq        cfg_read_badparity_seq;

  function new(string name = "back2back_cfgrd_badDataparity_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]      rdata;
    int             np_cnt ; 

    np_cnt = 0 ;

    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h1);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    WriteReg("hqm_pf_cfg_i", "pcie_cap_device_control",  'h291F);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    

    WriteReg("hqm_pf_cfg_i", "device_command",  'h046);

    repeat(np_cnt+1) begin
      `ovm_do_on_with(cfg_read_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_addr == cfg_addr0; m_driveBadCmdParity == 0; m_driveBadDataParity == 1; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 100; })
      rdata = cfg_read_badparity_seq.iosf_data;
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_badparity_seq.iosf_addr ,rdata),OVM_LOW)
    end 
    
  endtask : body
endclass : back2back_cfgrd_badDataparity_seq
