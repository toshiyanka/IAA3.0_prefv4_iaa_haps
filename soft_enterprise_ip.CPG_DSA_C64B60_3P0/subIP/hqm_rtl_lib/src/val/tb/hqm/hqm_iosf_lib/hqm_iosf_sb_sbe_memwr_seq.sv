import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_sbe_memwr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_sbe_memwr_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  flit_t                        my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_sbe_memwr_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [63:0]  write_data;
    bit [63:0]  actual_data;
    int         bar;
    int         fid;
    int         j = 0 ;

    
    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",    'h0000_4000);    
    
     get_pid();
     foreach(reg_list_func_vf_csr_pf[i]) begin
      for(int j=1; j<16;j++)begin
          write_data = $urandom_range(0,64'h_ffff_ffff_ffff_ffff); 
          //write_data can be reset val
         `ovm_info("hqm_iosf_sb_sbe_memwr_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
        `ovm_info("hqm_iosf_sb_sbe_memwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

         bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
         fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
         if(reg_addr[2]!=0)begin
             continue;
         end
         `ovm_info(get_full_name(), $psprintf("running %0d mem rd", j), OVM_LOW)
         send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(j),.exp_rsp(0),.compare_completion(0),.rsp(1),.actual_data(0));
         `ovm_info(get_full_name(), $psprintf("response received for %0d mem rd", j), OVM_LOW)
       end
    end


    foreach(reg_list_func_vf_csr_pf[i]) begin
       `ovm_info("hqm_iosf_sb_sbe_memwr_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)

       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
      `ovm_info("hqm_iosf_sb_sbe_memwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

       bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
       fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
        if(reg_addr[2]!=0)begin
             continue;
         end
       send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(reg_list_func_vf_csr_pf[i].get_reset_val()));
   end


   
  endtask : body
endclass : hqm_iosf_sb_sbe_memwr_seq
