import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_fbe_memwr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_fbe_memwr_seq,sla_sequencer)

    static logic [2:0]            iosf_tag = 0;
    iosfsbm_seq::iosf_sb_seq      sb_seq;
    bit [31:0]  rdata;
    bit [31:0]  write_data;
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    int         j = 0;
    static logic [2:0]   iosf_tag = 0;
   
 
  function new(string name = "hqm_iosf_sb_fbe_memwr_seq");
    super.new(name); 
  endfunction
  
  virtual task body();
   
       get_pid();
//     write_data       = 32'hFFFF_FFFF;
    foreach(reg_list_func_vf_csr_pf[i]) begin
         `ovm_info("hqm_iosf_sb_fbe_memwr_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)

         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
         `ovm_info("hqm_iosf_sb_fbe_memwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

         bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
         fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
         write_data = reg_list_func_vf_csr_pf[i].get_reset_val();
         send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
         send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(reg_list_func_vf_csr_pf[i].get_reset_val()));
    end
 
    foreach(reg_list_func_vf_csr_pf[i]) begin
       for(int j=0; j<16; j++) begin
          `ovm_info("hqm_iosf_sb_fbe_memwr_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)

         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
         `ovm_info("hqm_iosf_sb_fbe_memwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

         bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
         fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");

        
         write_data = ~ (reg_list_func_vf_csr_pf[i].get_reset_val());
         send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(j),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
         if(j == 15)begin
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
         end
       end
    end
      endtask : body
  //same scenario ans np memwr
  //Write legal reset_val -> read -> wr inverted/~reset_val with illegal fbe -> read and exp reset_val
endclass : hqm_iosf_sb_fbe_memwr_seq
