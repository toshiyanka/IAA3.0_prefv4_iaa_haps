import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_cplD_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_cplD_seq,sla_sequencer)

  randc logic[1:0]              rsp;
  iosfsbm_seq::iosf_sb_seq      sb_seq;

  constraint cplstatus {
    rsp inside {iosfsbm_cm::RSP_NOTSUPPORTED,iosfsbm_cm::RSP_SUCCESSFUL,iosfsbm_cm::RSP_MCASTMIXED,iosfsbm_cm::RSP_POWEREDDOWN};
  }

  function new(string name = "hqm_iosf_sb_cplD_seq");
    super.new(name); 
  endfunction

  
  virtual task body();
    bit [31:0]  write_data;
    bit [31:0]  write_data_reset;
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    static logic [2:0]       iosf_tag = 0;

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",   'h0000_4000);
    get_pid();
     foreach(reg_list_func_vf_csr_pf[i]) begin
          `ovm_info("hqm_iosf_sb_cplD_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("hqm_iosf_sb_cplD_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
           write_data_reset = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data((write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW"))));
           write_data = (reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],CmpD,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(rsp),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data((write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW"))));
      end
endtask : body
endclass : hqm_iosf_sb_cplD_seq
