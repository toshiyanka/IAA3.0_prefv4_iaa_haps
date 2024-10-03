import lvm_common_pkg::*;

class back2back_sb_memwr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_sb_memwr_seq,sla_sequencer)
   
  hqm_iosf_sb_memwr_seq        mem_write_seq;
  hqm_iosf_sb_memrd_seq        mem_read_seq;

  function new(string name = "back2back_sb_memwr_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]  rdata;
    bit [31:0]  write_data;
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    static logic [2:0]   iosf_tag = 0;
    sla_ral_reg  reg_list_random[$];
    int         np_cnt = 26;       
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    get_pid();
   
    if($test$plusargs("FUNC_PF_REGS_CHECK"))begin
     reg_list_random = reg_list_func_p ;
    end
    if($test$plusargs("FUNC_VF_REGS_CHECK"))begin
      reg_list_random = reg_list_func_v ;
    end
    if($test$plusargs("CSR_SYSTEM_REGS_CHECK"))begin
      reg_list_random = reg_list_csr_system ;
      $display("This is csr reg b2b wr test");
    end
    repeat(np_cnt+1) begin
      foreach(reg_list_random[i]) begin
        write_data = $urandom_range(0,32'h_ffff_ffff); 
       `ovm_info("back2back_sb_memwr_seq",$psprintf("Register name is %s", reg_list_random[i].get_name()),OVM_LOW)

       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_random[i]);
       `ovm_info("back2back_sb_memwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

       bar = reg_list_random[i].get_bar("MEM-SB");
       fid = reg_list_random[i].get_fid("MEM-SB");
       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
       write_data = $urandom_range(0,32'h_ffff_ffff); 
       
       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
       write_data = $urandom_range(0,32'h_ffff_ffff); 

       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));

       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, 32'hAABBCCDD, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));

       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, 32'hAABBCCDD, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
       
       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, 32'hAABBCCDD, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
       write_data = $urandom_range(0,32'h_ffff_ffff); 

       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
       write_data = $urandom_range(0,32'h_ffff_ffff); 

       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
       write_data = $urandom_range(0,32'h_ffff_ffff); 

       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
       send_command(reg_list_random[i],MemWr,POSTED, reg_addr, 32'hFFFFFFFF, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));

     end
   end
  
   foreach(reg_list_random[i]) begin
    `ovm_info("back2back_sb_memwr_seq",$psprintf("Register name is %s", reg_list_random[i].get_name()),OVM_LOW)

    reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_random[i]);
    `ovm_info("back2back_sb_memwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)
    bar = reg_list_random[i].get_bar("MEM-SB");
    fid = reg_list_random[i].get_fid("MEM-SB");
    
    send_command(reg_list_random[i],MemRd,NON_POSTED, reg_addr, 32'hFFFFFFFF, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data((32'hFFFF_FFFF & reg_list_random[i].get_attr_mask("RW"))));
  end

 endtask : body
endclass : back2back_sb_memwr_seq
//timeout situation
