import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;
import hqm_reset_sequences_pkg::*;

class hqm_iosf_sb_poison_cfgrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_poison_cfgrd_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  flit_t                        my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq      sb_seq;
  hqm_reset_sequences_pkg::hqm_reset_init_sequence       warm_reset;
  hqm_sla_pcie_init_seq         pcie_init;
  cfg_genric_seq                rd_wr_seq;
  logic[1:0]                    cplstatus;

  function new(string name = "hqm_iosf_sb_poison_cfgrd_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]  rdata;
    bit [31:0]  rd_data;
    string              opcode;
    bit [31:0]  write_data;
    bit [31:0]  actual_data;
    int         bar;
    int         fid;
    iosfsbm_cm::flit_t  iosf_addr[];

   
    get_pid();

    //disable parity constraint
    foreach(reg_list_cfg_pf_vf_regs[i])begin
    repeat(10)begin
    write_data = $urandom_range(0,32'hFFFF_FFFF);
     `ovm_info("hqm_iosf_sb_poison_cfgrd_seq",$psprintf("Register name is %s", reg_list_cfg_pf_vf_regs[i].get_name()),OVM_LOW)

      reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_cfg_pf_vf_regs[i]);
      `ovm_info("hqm_iosf_sb_poison_cfgrd_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

      bar = reg_list_cfg_pf_vf_regs[i].get_bar("CFG-SB");
      fid = reg_list_cfg_pf_vf_regs[i].get_fid("CFG-SB");
      send_command_with_constraint(reg_list_cfg_pf_vf_regs[i],CfgRd,'h0,0,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.parity_en(1),.exp_rsp(0),.compare_completion(0),.actual_data(0));
      
      ReadReg("hqm_pf_cfg_i","aer_cap_uncorr_err_status",SLA_FALSE,rd_data);
       if(rd_data!=32'h0)begin
         `ovm_error(get_full_name(),$psprintf("rd_data can only be zero"));
      end

    `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: addr=0x%08x",opcode,addr),OVM_LOW)	
    //Initiating primary sequence when HQM sideband network is in hung state
    `ovm_do(rd_wr_seq);

    //Initiating warm reset to take sideband out of hung state
    `ovm_do(warm_reset);

    `ovm_do(pcie_init)

    send_command(reg_list_cfg_pf_vf_regs[i],CfgRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.parity_en_checks(1),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(write_data));
  end 
  end
  endtask : body
endclass : hqm_iosf_sb_poison_cfgrd_seq
