import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_memrd_fid_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_memrd_fid_seq,sla_sequencer)

  static logic [2:0]       iosf_tag = 0;
  flit_t                   my_ext_headers[];
  rand bit [63:0]          addr;

  iosfsbm_seq::iosf_sb_seq sb_seq;

  function new(string name = "hqm_iosf_sb_memrd_fid_seq");
    super.new(name); 
  endfunction

  
  virtual task body();
        bit [31:0]  actual_data;
        int         bar;
        int         fid;
        int         j;
        static logic [2:0]   iosf_tag = 0;
        bit [31:0]   write_data;
        bit [31:0]   write_data_reset;


    WriteReg("hqm_pf_cfg_i", "func_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u",  'h1);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    get_pid();
    foreach(reg_list_func_regs[i]) begin
     `ovm_info("hqm_iosf_sb_memrd_fid_seq",$psprintf("Register name is %s", reg_list_func_regs[i].get_name()),OVM_LOW)
      reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_regs[i]);

     `ovm_info("hqm_iosf_sb_memrd_fid_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

     bar = reg_list_func_regs[i].get_bar("MEM-SB");

     fid = reg_list_func_regs[i].get_fid("MEM-SB");
     write_data_reset = ~(reg_list_func_regs[i].get_reset_val());
     $display("write_data_reset:0x%0h",write_data_reset);
     send_command(reg_list_func_regs[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
     $display("actual_data=0x%0h",write_data_reset & reg_list_func_regs[i].get_attr_mask("RW")); 
     send_command(reg_list_func_regs[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_regs[i].get_attr_mask("RW")));

    repeat(50)begin
     j=$urandom_range(0,255);
     $display("j=%d,fid=%d",j,fid);
        if(fid == j)begin
           $display("fid equal to j");
           continue;
        end
        $display("j=%0d", j);
        if(j>0)begin
        send_command(reg_list_func_regs[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, .fid(j),.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(1),.actual_data(0));
           end else begin
        send_command(reg_list_func_regs[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, .fid(j),.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(0),.actual_data(0));
        end
       end
    end



    foreach(reg_list_csr_system[i]) begin
     `ovm_info("hqm_iosf_sb_memrd_fid_seq",$psprintf("Register name is %s", reg_list_csr_system[i].get_name()),OVM_LOW)
      reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_csr_system[i]);
     `ovm_info("hqm_iosf_sb_memrd_fid_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

     bar = reg_list_csr_system[i].get_bar("MEM-SB");

     fid = reg_list_csr_system[i].get_fid("MEM-SB");
     write_data_reset = ~(reg_list_csr_system[i].get_reset_val());
     $display("write_data_reset:0x%0h",write_data_reset);
     send_command(reg_list_csr_system[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));

     $display("actual_data=0x%0h",write_data_reset & reg_list_csr_system[i].get_attr_mask("RW")); 
     send_command(reg_list_csr_system[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_csr_system[i].get_attr_mask("RW")));

    repeat(50)begin
     j=$urandom_range(0,255);
     $display("j=%d,fid=%d",j,fid);
        if(fid == j)begin
           $display("fid equal to j");
           continue;
        end
        $display("j=%0d", j);
           //send_command(reg_list_func_regs[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, .fid(j),.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(1),.actual_data(0));
           send_command(reg_list_csr_system[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, .fid(j),.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.do_compare(0),.rsp(1),.actual_data(0));
       end
    end

 endtask : body
//use get_fid and send other values for fid unsupported
//check supported fid for func_vf and csr
//check for all the 255 illegal values
endclass : hqm_iosf_sb_memrd_fid_seq
