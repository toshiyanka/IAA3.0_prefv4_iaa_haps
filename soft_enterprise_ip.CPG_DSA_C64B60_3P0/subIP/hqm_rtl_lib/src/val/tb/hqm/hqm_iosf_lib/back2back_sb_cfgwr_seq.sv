import lvm_common_pkg::*;

class back2back_sb_cfgwr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_sb_cfgwr_seq,sla_sequencer)

  hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_iosf_sb_cfgwr_seq        cfg_write_seq;

  function new(string name = "back2back_sb_cfgwr_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]      rdata;
    int             np_cnt; 
    bit [31:0]  actual_data;
    int         bar;
    int        fid;
    bit [31:0]   write_data; 
    static logic [2:0]            iosf_tag = 0;

    np_cnt = 26 ;
  
//    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);

    WriteReg("hqm_sif_csr", "hqm_csr_cp_lo",      'hFFFF_FFFF);
    WriteReg("hqm_sif_csr", "hqm_csr_cp_hi",      'hFFFF_FFFF);
    ReadReg("hqm_sif_csr",  "hqm_csr_cp_lo",  SLA_FALSE,  rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_cfgwr_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
    ReadReg("hqm_sif_csr",  "hqm_csr_cp_hi",  SLA_FALSE,  rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_cfgwr_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))

    WriteReg("hqm_sif_csr", "hqm_csr_rac_lo",     'hFFFF_FFFF);
    WriteReg("hqm_sif_csr", "hqm_csr_rac_hi",     'hFFFF_FFFF);
    ReadReg("hqm_sif_csr",  "hqm_csr_rac_lo"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_cfgwr_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
    ReadReg("hqm_sif_csr",  "hqm_csr_rac_hi"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_cfgwr_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))

    WriteReg("hqm_sif_csr", "hqm_csr_wac_lo",     'hFFFF_FFFF);
    WriteReg("hqm_sif_csr", "hqm_csr_wac_hi",     'hFFFF_FFFF);
    ReadReg("hqm_sif_csr",  "hqm_csr_wac_lo"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_cfgwr_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
    ReadReg("hqm_sif_csr",  "hqm_csr_wac_hi"  ,SLA_FALSE, rdata);
    if(rdata != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_cfgwr_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rdata))
    get_pid();
    repeat(np_cnt+1) begin
     foreach(reg_list_cfg_pf_vf_regs[i]) begin
      
      `ovm_info("back2back_sb_cfgwr_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)
       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("back2back_sb_cfgwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

      fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
       bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");
       write_data = ~(reg_list_cfg_pf_vf_regs[i].get_reset_val());
       $display("write_data:0x%0h",write_data);

       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, write_data, iosf_tag, bar,fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, 32'hAABBCCDD, iosf_tag, bar,fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, 32'h0ABBCCDD, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, 32'hAACCEFDD, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, 32'hAACCEEEE, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, 32'hFFFF_FFFF, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
    end
   end
   foreach(reg_list_cfg_pf_vf_regs[i]) begin
      
      `ovm_info("back2back_sb_cfgwr_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)
       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("back2back_sb_cfgwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

      fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
       bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");

       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, 32'hFFFF_FFFF, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       if(reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW") == 'h0)begin
       send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, 32'hFFFF_FFFF, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(32'hFFFF_FFFF & reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW/P")));
   end else begin
       send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, 32'hFFFF_FFFF, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(32'hFFFF_FFFF & reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW")));
   end

   end

//add another scenario with exp_rsp=0 for wr/rd
//add comments for any extra changes

  endtask : body
endclass : back2back_sb_cfgwr_seq
