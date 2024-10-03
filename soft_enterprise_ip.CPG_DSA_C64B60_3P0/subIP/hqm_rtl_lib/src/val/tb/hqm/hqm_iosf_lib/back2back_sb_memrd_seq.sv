import lvm_common_pkg::*;

class back2back_sb_memrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_sb_memrd_seq,sla_sequencer)

   hqm_sla_pcie_bar_cfg_seq   pcie_bar_cfg_seq;

  function new(string name = "back2back_sb_memrd_seq");
    super.new(name); 
  endfunction

  virtual task body();
    int         np_cnt ; 
    bit [31:0]  write_data;
    bit [31:0]  write_data_reset;
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    static logic [2:0]       iosf_tag = 0;  
    np_cnt = 15 ;
           
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    get_pid();

   if($test$plusargs("MEM64_TXN"))begin
      foreach(reg_list_func_vf_csr_pf[i]) begin
        repeat(np_cnt+1)begin
          `ovm_info("back2back_sb_memrd_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("back2back_sb_memrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
            write_data_reset = (reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data((write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW"))));
            write_data = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(0),.actual_data(0));
        end
      end
    end
       

    if($test$plusargs("MEM32_TXN"))begin
      `ovm_do_with(pcie_bar_cfg_seq,{func_bar_h=='h01; func_bar_l == 'h0; csr_bar_h=='h0;});
     foreach(reg_list_func_vf_csr_pf[i]) begin
        repeat(np_cnt+1)begin
          `ovm_info("back2back_sb_memrd_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("back2back_sb_memrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
            write_data_reset = (reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data((write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW"))));
            write_data = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(0),.actual_data(0));
        end
     end
  end 
//exp_rsp make it 0 ffor back to back checks  
   //wait after all sequence given
   #15000;
   #10000;
//send command with exp_rsp =1 which makes sure all the above are done and remove delay     
  endtask : body
endclass : back2back_sb_memrd_seq
