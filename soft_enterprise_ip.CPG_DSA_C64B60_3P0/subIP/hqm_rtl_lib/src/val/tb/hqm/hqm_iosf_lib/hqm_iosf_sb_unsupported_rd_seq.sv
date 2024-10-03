import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_unsupported_rd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_unsupported_rd_seq,sla_sequencer)

  static logic [2:0]          iosf_tag = 0;
  randc  logic [7:0]          Iosf_sai;
  flit_t                      my_ext_headers[];
  rand bit [63:0]             addr;
  iosfsbm_seq::iosf_sb_seq    sb_seq;

  function new(string name = "hqm_iosf_sb_unsupported_rd_seq");
    super.new(name); 
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    if($test$plusargs("UR_SAI_TXN"))begin
      my_ext_headers[1]  = Iosf_sai[7:0]; 
    end 
    else begin
     my_ext_headers[1]   = 8'h01;               // Set SAI
    end

    my_ext_headers[2]    = 8'h00;
    my_ext_headers[3]    = 8'h00;
//TODO  check about the SAI value
  endfunction

  
  virtual task body();
   bit [31:0]  write_data;
   bit [31:0]  write_data_reset;
   bit [31:0]  actual_data;
   int         bar;
   int         fid;
    


   get_pid();
    repeat(5) begin
      if($test$plusargs("IORD_TXN"))begin
        foreach(reg_list_func_vf_csr_pf[i]) begin
          `ovm_info("hqm_iosf_sb_unsupported_rd_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("hqm_iosf_sb_unsupported_rd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
           write_data_reset = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           $display("write_data_reset:0x%0h",write_data_reset);
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           $display("actual_data=0x%0h",write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")); 
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
           send_command(reg_list_func_vf_csr_pf[i],IoRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));

      end
    end

      if($test$plusargs("IORD_SAI_TXN"))begin
        foreach(reg_list_func_vf_csr_pf[i]) begin
          for (int i=0 ;i <256;i++)begin
            `ovm_info("hqm_iosf_sb_unsupported_rd_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("hqm_iosf_sb_unsupported_rd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
           write_data_reset = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           $display("write_data_reset:0x%0h",write_data_reset);
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           $display("actual_data=0x%0h",write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")); 
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
           send_command(reg_list_func_vf_csr_pf[i],IoRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
          end
        end
       end

      if($test$plusargs("CRRD_TXN"))begin
        foreach(reg_list_func_vf_csr_pf[i]) begin
          `ovm_info("hqm_iosf_sb_unsupported_rd_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)
           reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
           `ovm_info("hqm_iosf_sb_unsupported_rd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

           bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
           fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
           write_data_reset = ~(reg_list_func_vf_csr_pf[i].get_reset_val());
           $display("write_data_reset:0x%0h",write_data_reset);
           send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
           $display("actual_data=0x%0h",write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")); 
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
           send_command(reg_list_func_vf_csr_pf[i],CrRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
           send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data_reset, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data_reset & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));

        end
      end

        
    end
//check for all the values o fopcodes which are unsupported 
  endtask : body
endclass : hqm_iosf_sb_unsupported_rd_seq
