import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_memwr_np_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_memwr_np_seq,sla_sequencer)

   static logic [2:0]              iosf_tag = 0;
   rand bit [63:0]                 addr;
   rand bit [31:0]                 wdata;
   flit_t                          my_ext_headers[];
   iosfsbm_seq::iosf_sb_seq        sb_seq;
   hqm_sla_pcie_bar_cfg_seq        pcie_bar_cfg_seq;

  function new(string name = "hqm_iosf_sb_memwr_np_seq");
    super.new(name); 
  endfunction
  
  virtual task body();
    
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [31:0]          rdata;
    logic[1:0]          cplstatus;
    bit [31:0]  write_data;
    bit [31:0]  actual_data;
    bit         rsp;
    int         bar;
    int         fid;
    int         j = 0;
    static logic [2:0]   iosf_tag = 0;
   

      
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);
    WriteReg("hqm_pf_cfg_i", "pcie_cap_device_control", 'h291F);

    if($test$plusargs("MEM32")) 
      `ovm_do_with(pcie_bar_cfg_seq,{func_bar_h=='h01; func_bar_l == 'h0; csr_bar_h=='h0;});

    if($test$plusargs("MEM64")) 
      `ovm_do_with(pcie_bar_cfg_seq,{func_bar_h=='h0; func_bar_l == 'h0; csr_bar_h=='h02;});
    if($test$plusargs("UR_TXN")) begin
       rsp = 'h1;
    end else begin
       rsp = 'h0;
    end
    get_pid(); 

    foreach(reg_list_func_vf_csr_pf[i]) begin
         `ovm_info("hqm_iosf_sb_fbe_memwr_seq",$psprintf("Register name is %s", reg_list_func_vf_csr_pf[i].get_name()),OVM_LOW)

         reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list_func_vf_csr_pf[i]);
         `ovm_info("hqm_iosf_sb_fbe_memwr_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

         bar = reg_list_func_vf_csr_pf[i].get_bar("MEM-SB");
         fid = reg_list_func_vf_csr_pf[i].get_fid("MEM-SB");
         write_data = reg_list_func_vf_csr_pf[i].get_reset_val();
         send_command(reg_list_func_vf_csr_pf[i],MemWr,POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0), .np_32_64_seq(1),.exp_rsp(0),.compare_completion(0),.rsp(0),.actual_data(0));
         send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.np_32_64_seq(1),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(reg_list_func_vf_csr_pf[i].get_reset_val()));
          write_data = ~ (reg_list_func_vf_csr_pf[i].get_reset_val());
         send_command(reg_list_func_vf_csr_pf[i],MemWr,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.np_32_64_seq(1),.exp_rsp(1),.compare_completion(0),.rsp(0),.actual_data(0));
         send_command(reg_list_func_vf_csr_pf[i],MemRd,NON_POSTED, reg_addr, write_data, iosf_tag, bar, fid,.fbe(4'h0f),.sbe(0),.np_32_64_seq(1),.exp_rsp(1),.compare_completion(0),.rsp(rsp),.actual_data(write_data & reg_list_func_vf_csr_pf[i].get_attr_mask("RW")));
    end
 
//change name

  endtask : body
  //check if there is a test with invalid SAI and randomize the ex_h[3] all bits
endclass : hqm_iosf_sb_memwr_np_seq
