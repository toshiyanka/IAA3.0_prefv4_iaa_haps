import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_sbe_memrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_sbe_memrd_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_sbe_memrd_seq");
    super.new(name); 
  endfunction

  virtual task body();
  bit [63:0]  write_data;
  bit [63:0]  actual_data;
  int         bar;
  int         fid;
  int         j = 0 ;
  int         quant;
    
   
    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",    'h0000_4000);    
    get_pid();
     foreach(reg_list_func_vf_csr_pf[i]) begin
       for(int j=0; j<16;j++)begin
          write_data = $urandom_range(0,64'h_ffff_ffff_ffff_ffff); 
         `ovm_info("hqm_iosf_sb_sbe_memrd_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)

         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
        `ovm_info("hqm_iosf_sb_sbe_memrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

        if(reg_addr[2]!=0)begin
            continue;
        end

         bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
         fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
         `ovm_info(get_full_name(), $psprintf("running %0d mem rd", j), OVM_LOW)
         if(j == 'h0)begin
         send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(j),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
     end else begin
         send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(j),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
          end
         `ovm_info(get_full_name(), $psprintf("response received for %0d mem rd", j), OVM_LOW)
     end
 end
       


  endtask : body
  //update seqname
  //pick randome value for sbe 
endclass : hqm_iosf_sb_sbe_memrd_seq
