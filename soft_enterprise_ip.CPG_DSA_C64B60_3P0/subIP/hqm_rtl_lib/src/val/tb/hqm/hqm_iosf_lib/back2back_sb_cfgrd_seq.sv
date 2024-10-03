import lvm_common_pkg::*;

class back2back_sb_cfgrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_sb_cfgrd_seq,sla_sequencer)
   
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;

  function new(string name = "back2back_sb_cfgrd_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]      rdata;
    int             np_cnt ; 
    Iosf::data_t    cfg_data;
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    bit [31:0]   write_data;  
    bit [31:0]   write_data_reset;  
    static logic [2:0]            iosf_tag = 0;
    np_cnt = 25 ;
    cfg_data = $urandom;

    if($test$plusargs("ECRC_CHECK"))
      WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h004C_1000);
//    else   
//      WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);

    get_pid();
    repeat(np_cnt+1) begin
     foreach(reg_list_cfg_pf_vf_regs[i]) begin
      
      `ovm_info("back2back_sb_cfgrd_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)
       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("back2back_sb_cfgrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

       fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
       bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");
       write_data_reset = ~(reg_list_cfg_pf_vf_regs[i].get_reset_val());
       $display("write_data_reset:0x%0h",write_data_reset);
       send_command(reg_list_func_vf_csr_pf[i],CfgWr,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       if(reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW") == 'h0)begin
       send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW/P")));
       end
       else begin
       send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW")));
       end

    end
   end

//    repeat(np_cnt+1) begin
//      randomize(cfg_addr);
//      `ovm_do_with(cfg_read_seq, {addr == cfg_addr;})
//    end 
     

  repeat(3)begin
    foreach(reg_list_cfg_pf_vf_regs[i]) begin
      `ovm_info("back2back_sb_cfgrd_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)
       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("back2back_sb_cfgrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

       fid = reg_list_cfg_pf_vf_regs[i].get_fid("MEM-SB");
       bar = reg_list_cfg_pf_vf_regs[i].get_bar("MEM-SB");
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, cfg_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
    end
  end

//    repeat(3)begin
//      `ovm_do_with(cfg_write_seq, {addr == cfg_addr; wdata == cfg_data;})
//    end            
                   
    #15000;
    #10000;
    //check without delay at the end and replace clockcycles if required
     
  endtask : body
endclass : back2back_sb_cfgrd_seq
