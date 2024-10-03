import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_sbe_cfgwr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_sbe_cfgwr_seq,sla_sequencer)

  static logic [2:0]    iosf_tag = 0;
  rand bit [63:0]       wdata;
  flit_t                my_ext_headers[];

  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_sbe_cfgwr_seq");
    super.new(name); 
  endfunction
  
  virtual task body();
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [63:0]  write_data;
    bit [63:0]  actual_data;
    int         bar;
    int         fid;


   
    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h1);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

//    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h0044_1000);    
    get_pid();
    foreach(reg_list_cfg_pf_vf_regs[i]) begin

       for(int j=1; j<16; j++)begin       
          `ovm_info("hqm_iosf_sb_sbe_cfgwr_np_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)

         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
         `ovm_info("hqm_iosf_sb_sbe_cfgwr_np_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

         if(reg_addr[2]!= 'h0 | reg_addr[15:12]!=4'h0)begin
           continue;
         end
         //check the constraints failing and add comments 

         bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");
         fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
         write_data = {~(reg_list_cfg_pf_vf_regs[i].get_reset_val()),$urandom_range(0,32'hFFFF_FFFF)};
//64bit wdata
         send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, 32'h00000000, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
         send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(j),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
        end
    end

    foreach(reg_list_cfg_pf_vf_regs[i]) begin
         `ovm_info("hqm_iosf_sb_sbe_memwr_np_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)

         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
         `ovm_info("hqm_iosf_sb_sbe_memwr_np_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

         bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");
         fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
         $display("reset_val=0x%0x",reg_list_cfg_pf_vf_regs[i].get_reset_val());

         send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(reg_list_cfg_pf_vf_regs[i].get_reset_val()));
    end

  endtask : body
endclass : hqm_iosf_sb_sbe_cfgwr_seq
