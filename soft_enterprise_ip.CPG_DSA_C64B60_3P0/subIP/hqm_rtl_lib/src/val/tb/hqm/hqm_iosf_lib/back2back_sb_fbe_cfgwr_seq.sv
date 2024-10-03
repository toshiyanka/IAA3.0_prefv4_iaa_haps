import lvm_common_pkg::*;

class back2back_sb_fbe_cfgwr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_sb_fbe_cfgwr_seq,sla_sequencer)

  hqm_iosf_sb_cfgrd_seq           cfg_read_seq;
  hqm_iosf_sb_fbe_cfgwr_seq       cfg_write_seq;
  bit      [63:0]                 cfg_addr3;

  function new(string name = "back2back_sb_fbe_cfgwr_seq");
    super.new(name); 
    cfg_addr3 = get_reg_addr("hqm_pf_cfg_i", "int_line",  "sideband");
  endfunction

  virtual task body();
    bit [31:0]          rdata;
    int  np_cnt ; 
    int         bar;
    int        fid;
    bit [31:0]   write_data; 
    bit [31:0]   actual_data; 
    bit [31:0]   mask_data; 
    bit [31:0]   reset_val_data; 
    bit [3:0]  fbe;
    static logic [2:0]            iosf_tag = 0;
    np_cnt = 16 ;

    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h1);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    //WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    
    get_pid();
    if($test$plusargs("CFGWR_ALL"))begin
     foreach(reg_list_cfg_pf_vf_regs[i]) begin
       for(j = 0 ; j < 16 ; j++)begin 
      `ovm_info("back2back_sb_fbe_cfgwr_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)
       reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("back2back_sb_fbe_cfgwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

       fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
       bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");
       fbe = j ;
       if(reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW") == 'h0)begin
           mask_data[31:0] = reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW/P");
       end else begin
           mask_data[31:0] = reg_list_cfg_pf_vf_regs[i].get_attr_mask("RW");
       end
       reset_val_data[31:0] = reg_list_cfg_pf_vf_regs[i].get_reset_val();

       write_data = 32'hFFFF_FFFF;
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr,write_data, iosf_tag, bar, fid,.fbe(j),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
       if(fbe != 4'h0)begin
       actual_data = { fbe[3]?write_data[31:24] & mask_data[31:24]:8'h0,fbe[2]?write_data[23:16] & mask_data[23:16]:8'h0,fbe[1]?write_data[15:8] & mask_data[15:8]:8'h0,fbe[0]?write_data[7:0] & mask_data[7:0]:8'h0 };
      end else begin
       actual_data = reg_list_cfg_pf_vf_regs[i].get_reset_val();
      end
       $display("actual_data:0x%0x, fbe:%0d",actual_data,fbe);
       send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr,write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(actual_data));
       send_command(reg_list_cfg_pf_vf_regs[i],CfgWr,NON_POSTED, reg_addr,32'h00000000, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
      end
     end
    end


    //make exp_rsp = 0 and make an other scenario
  endtask : body
endclass : back2back_sb_fbe_cfgwr_seq
