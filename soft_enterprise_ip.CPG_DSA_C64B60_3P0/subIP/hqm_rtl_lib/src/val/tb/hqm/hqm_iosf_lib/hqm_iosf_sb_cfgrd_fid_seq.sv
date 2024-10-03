import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_cfgrd_fid_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_cfgrd_fid_seq,sla_sequencer)

  static logic [2:0]   iosf_tag = 0;
  rand bit [63:0]      addr;
  bit [31:0]           rdata;
  flit_t               my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq      sb_seq;
  int                  exp_rsp ;

  function new(string name = "hqm_iosf_sb_cfgrd_fid_seq");
    super.new(name); 
  endfunction

  
  virtual task body();
     iosfsbm_cm::flit_t  iosf_addr[];
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    int         j;
    static logic [2:0]   iosf_tag = 0;
    bit [31:0]   write_data; 

    write_data           = 32'hFFFF_FFFF;       
    get_pid();
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    foreach(reg_list_cfg_pf_vf_regs[i]) begin
      
      fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
      for(j=0;j<256;j++)begin
        $display("j=%d,fid=%d",j,fid);
        if(fid == j)begin
           $display("fid equal to j");
           continue;
       end
      `ovm_info("hqm_iosf_sb_cfgwr_fid_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)
       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("hqm_iosf_sb_cfgwr_fid_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

       bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");

       if(j>0)begin
       send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, .fid(j),.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(1),.actual_data(0));
       end
       else begin
       send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, .fid(j),.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(0),.actual_data(0));
       end 
    end 
   end
//replace 16 with the defines and replace display with ovm_info   
  endtask : body
endclass : hqm_iosf_sb_cfgrd_fid_seq
