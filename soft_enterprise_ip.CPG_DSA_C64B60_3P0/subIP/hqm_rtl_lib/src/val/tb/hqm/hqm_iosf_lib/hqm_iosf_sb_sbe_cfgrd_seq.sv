import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_sbe_cfgrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_sbe_cfgrd_seq,sla_sequencer)

  static logic [2:0]       iosf_tag = 0;
  rand bit [63:0]          addr;
  flit_t                   my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq sb_seq;

  function new(string name = "hqm_iosf_sb_sbe_cfgrd_seq");
    super.new(name); 
  endfunction
  
  virtual task body();
    iosfsbm_cm::flit_t  iosf_addr[];
    bit [31:0]  write_data;
    bit [31:0]  actual_data;
    int         bar;
    int         fid;

                 
    
    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h1);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h0044_1000);    
    get_pid();
    foreach(reg_list_cfg_pf_vf_regs[i]) begin

       for(int j=1; j<16; j++)begin       
          `ovm_info("hqm_iosf_sb_sbe_cfgrd_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)

         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
         `ovm_info("hqm_iosf_sb_sbe_cfgrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

         bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");
         fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
         if(reg_addr[2] != 'h0)begin
             continue;
         end
         send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(j),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
        end
    end

   
  endtask : body
endclass : hqm_iosf_sb_sbe_cfgrd_seq
