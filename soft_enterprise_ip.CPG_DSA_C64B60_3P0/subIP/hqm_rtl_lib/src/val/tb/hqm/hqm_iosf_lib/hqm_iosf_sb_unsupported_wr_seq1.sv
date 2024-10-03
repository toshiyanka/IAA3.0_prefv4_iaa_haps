import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_unsupported_wr_seq1 extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_unsupported_wr_seq1,sla_sequencer)

   static logic [2:0]       iosf_tag = 0;
   rand bit [63:0]          addr;
   rand bit [31:0]          wdata;
   flit_t                   my_ext_headers[];

  iosfsbm_seq::iosf_sb_seq  sb_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq   cfg_read_seq;

  function new(string name = "hqm_iosf_sb_unsupported_wr_seq1");
    super.new(name); 
  endfunction

  
  virtual task body();
    
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [63:0]  write_data;
    bit [31:0]  write_data_reset;
    bit [63:0]  actual_data;
    int         bar;
    int         fid;
    static logic [2:0]       iosf_tag = 0;

      
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    get_pid();
    repeat(5) begin
      if($test$plusargs("CRWR_POSTED_TXN"))begin
         foreach(reg_list_func_vf_csr_pf[i]) begin
          `ovm_info("hqm_iosf_sb_unsupported_wr_seq1",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("hqm_iosf_sb_unsupported_wr_seq1",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
           write_data_reset = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           $display("write_data_reset:0x%0h",write_data_reset);
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           $display("actual_data=0x%0h",write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")); 
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
           write_data = (reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],CrWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
        end
      end 

      if($test$plusargs("VIRTUAL_TXN"))begin
        foreach(reg_list_func_vf_csr_pf[i]) begin
          `ovm_info("hqm_iosf_sb_unsupported_wr_seq1",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("hqm_iosf_sb_unsupported_wr_seq1",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
           write_data_reset = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           $display("write_data_reset:0x%0h",write_data_reset);
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           $display("actual_data=0x%0h",write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")); 
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
           write_data = (reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],VirtualWire,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.misc(0),.exp_rsp(0),.compare_completion(0),.rsp(1),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
        end
      end

       
      if($test$plusargs("DO_PME_TXN"))begin
        foreach(reg_list_func_vf_csr_pf[i]) begin
          `ovm_info("hqm_iosf_sb_unsupported_wr_seq1",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("hqm_iosf_sb_unsupported_wr_seq1",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
           write_data_reset = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           $display("write_data_reset:0x%0h",write_data_reset);
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           $display("actual_data=0x%0h",write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")); 
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
           write_data = (reg_list_func_vf_csr_pf[i].get_reset_val());
           send_command(reg_list_func_vf_csr_pf[i],DoPme,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.misc(0),.exp_rsp(0),.compare_completion(0),.rsp(1),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
        end
      end
    end
//merge 2 unsupported opcode write sequences
  endtask : body
endclass : hqm_iosf_sb_unsupported_wr_seq1
