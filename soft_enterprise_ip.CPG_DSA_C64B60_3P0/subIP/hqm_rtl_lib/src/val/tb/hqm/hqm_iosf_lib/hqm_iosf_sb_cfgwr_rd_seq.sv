import lvm_common_pkg::*;


class hqm_iosf_sb_cfgwr_rd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_cfgwr_rd_seq,sla_sequencer)
   
  bit      [63:0]              cfg_addr4, cfg_addr5;
  hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_iosf_sb_cfgwr_seq        cfg_write_seq;

  function new(string name = "hqm_iosf_sb_cfgwr_rd_seq");
    super.new(name); 

    cfg_addr4 = get_reg_addr("hqm_pf_cfg_i", "int_line",  "sideband");
/*    cfg_addr5 = get_reg_addr("hqm_pf_cfg_i", "pcie_cap_device_control",  "sideband"); */

  endfunction

  virtual task body();
    sla_ral_data_t      rdata;
    int                 count; 
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    bit [31:0]   write_data;  
    bit [31:0]   write_data_reset;  
    static logic [2:0]            iosf_tag = 0;

    count               = 10;
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);
 //   WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);
    WriteReg("hqm_pf_cfg_i", "pcie_cap_device_control",  'h291F);

    WriteReg("hqm_sif_csr", "hqm_csr_cp_lo",      'hFFFF_FFFF);
    WriteReg("hqm_sif_csr", "hqm_csr_cp_hi",      'hFFFF_FFFF);
    ReadReg("hqm_sif_csr",  "hqm_csr_cp_lo",  SLA_FALSE,  rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("hqm_iosf_sb_cfgwr_rd_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
    ReadReg("hqm_sif_csr",  "hqm_csr_cp_hi",  SLA_FALSE,  rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("hqm_iosf_sb_cfgwr_rd_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))

    WriteReg("hqm_sif_csr", "hqm_csr_rac_lo",     'hFFFF_FFFF);
    WriteReg("hqm_sif_csr", "hqm_csr_rac_hi",     'hFFFF_FFFF);
    ReadReg("hqm_sif_csr",  "hqm_csr_rac_lo"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("hqm_iosf_sb_cfgwr_rd_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
    ReadReg("hqm_sif_csr",  "hqm_csr_rac_hi"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("hqm_iosf_sb_cfgwr_rd_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))

    WriteReg("hqm_sif_csr", "hqm_csr_wac_lo",     'hFFFF_FFFF);
    WriteReg("hqm_sif_csr", "hqm_csr_wac_hi",     'hFFFF_FFFF);
    ReadReg("hqm_sif_csr",  "hqm_csr_wac_lo"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("hqm_iosf_sb_cfgwr_rd_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
    ReadReg("hqm_sif_csr",  "hqm_csr_wac_hi"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("hqm_iosf_sb_cfgwr_rd_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
      get_pid();
      repeat(count)begin
       foreach(reg_list_cfg_pf[i]) begin
      
      `ovm_info("back2back_sb_cfgrd_seq",$psprintf("Register name is %s", reg_list_cfg_pf[i].get_name()),OVM_LOW)
       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("back2back_sb_cfgrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

       fid = reg_list_cfg_pf[i].get_fid("CFG-SB");
       bar = reg_list_cfg_pf[i].get_bar("CFG-SB");
       write_data_reset = ~(reg_list_cfg_pf[i].get_reset_val());
       $display("write_data_reset:0x%0h",write_data_reset);
       send_command(reg_list_func_vf_csr_pf[i],CfgWr,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       if(reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW") == 'h0)begin
          send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW/P")));
       end else begin
          send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW")));
       end

    end
   end
//change name in the info
      

  endtask : body
endclass : hqm_iosf_sb_cfgwr_rd_seq
