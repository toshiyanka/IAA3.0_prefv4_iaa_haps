`ifndef HQM_PCIE_AER_HEADER_FP_BEHAVIOR_MASKED_ERROR_SEQ
`define HQM_PCIE_AER_HEADER_FP_BEHAVIOR_MASKED_ERROR_SEQ

import lvm_common_pkg::*;

class hqm_pcie_aer_header_fp_behavior_masked_error extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_pcie_aer_header_fp_behavior_masked_error,sla_sequencer)

  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_poisoned_seq      cfg_write_poison_seq;
  hqm_sla_pcie_eot_checks_sequence                             error_status_chk_seq;
  bit [7:0]                                                    func_num;
  hqm_ue_cpl_seq                                               ue_cpl_seq;

  ovm_event_pool                                               glbl_pool;
  ovm_event                                                    exp_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event                                                    exp_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event                                                    exp_ep_corr_msg[`MAX_NO_OF_VFS+1];
  ovm_event                                                    obs_ep_fatal_msg[`MAX_NO_OF_VFS+1];


  function new(string name = "hqm_pcie_aer_header_fp_behavior_masked_error");
    super.new(name); 
    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      exp_ep_nfatal_msg[i]   = glbl_pool.get($psprintf("exp_ep_nfatal_msg_%0d",i));
      exp_ep_fatal_msg[i]    = glbl_pool.get($psprintf("exp_ep_fatal_msg_%0d",i));
      exp_ep_corr_msg[i]     = glbl_pool.get($psprintf("exp_ep_corr_msg_%0d",i));

      obs_ep_fatal_msg[i]    = glbl_pool.get($psprintf("obs_ep_fatal_msg_%0d",i));
    end
  endfunction

  virtual task body();
    sla_ral_addr_t        _poison_inj_addr_;
    sla_ral_data_t        rd_val;
    sla_status_t          status;
    bit [31:0]            cache_line_default_val;
    bit [127:0]           header = 128'h0007000c_00000000_0000690f_44004001;// bits ep = 1, length[7:0] = 1, {fmt,type} = 02 (as per steve mail) -- Should be actual // 
    bit[31:0]             write_data;
    bit [127:0]           header_per_func[int];


    //For the PF and all VFs, pick an uncorrectable error type and set the mask bit for that error type in the AER uncorrectable mask reg.
    //Mask:IEUNC=PTLPR=1
    pf_cfg_regs.AER_CAP_UNCORR_ERR_MASK.write(status,32'h_0040_1000,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.AER_CAP_UNCORR_ERR_MASK.read(status,rd_val,primary_id,this,.sai(legal_sai));
    //Sev: EC=PTLPR=IEUNC=MTLP=1
    pf_cfg_regs.AER_CAP_UNCORR_ERR_SEV.write(status,32'h_0045_1000,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.AER_CAP_UNCORR_ERR_SEV.read(status,rd_val,primary_id,this,.sai(legal_sai));

    pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.read(status, rd_val,primary_id,this,.sai(legal_sai));
    rd_val[3:0] = 4'b1111;//urro, fere, nere, cere=1
    pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write(status, rd_val,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.read(status, rd_val,primary_id,this,.sai(legal_sai));

    pf_cfg_regs.DEVICE_COMMAND.write(status,32'h_46,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.DEVICE_COMMAND.read(status, rd_val,primary_id,this,.sai(legal_sai));

    //For the PF and all VFs, cause the above uncorrectable error type (Error #1).
            _poison_inj_addr_ = ral.get_addr_val(primary_id, pf_cfg_regs.CACHE_LINE_SIZE);
  
        write_data =$urandom();
        `ovm_info(get_full_name(),$psprintf("Section 1: Starting hqm_pcie_aer_header_fp_behavior_masked_error with: _poison_inj_addr_ (0x%0x); func_num (0x%0x) , bus_number (0x%0x), write_data=%0h",_poison_inj_addr_,0, _poison_inj_addr_[31:24], write_data),OVM_LOW)
        `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr == _poison_inj_addr_; iosf_data == write_data;})
        //exp_ep_fatal_msg[0].trigger();

        header[28:24] = 5'b00100; // CfgWr0 - Type
        header[31:29] = 3'b010;   // CfgWr0 - Fmt
        header[47:40]   = cfg_write_poison_seq.iosf_tag[7:0];
        header[19]      = cfg_write_poison_seq.iosf_tag[8];  
        header[23]      = cfg_write_poison_seq.iosf_tag[9];  
        header[95:64]  = _poison_inj_addr_[31:0];
        header[127:96]  = _poison_inj_addr_[63:32];

        header_per_func[0] = header;
        `ovm_info(get_full_name(),$psprintf("Section 1: Pushing expected header into array, for func_no = %0h, header_per_func[func_num] = %0h ", 0, header_per_func[0]),OVM_DEBUG)
             
    //For the PF and all VFs, verify the PCIe and AER regs have correctly logged Error #1 in the uncorrectable error status reg but that the first error pointer and the error header log were not updated.
    //Do not clear any of the PCIe status or AER bits.
        `ovm_info(get_full_name(),$psprintf("Section 1: checking AER regs: Starting error_status_chk_seq for func_no = %0h, header_per_func[func_num] = %0h ", 0, header_per_func[0]),OVM_LOW)
        `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1; en_H_FP_check==1'b_1; exp_header_log == 0; skip_status_clear==1'b1; test_induced_fep==0;}); // fatal unmask

    `ovm_info(get_full_name(),$psprintf("Section 1: End"),OVM_LOW)


     `ovm_info(get_full_name(),$psprintf("Section 2: Start"),OVM_LOW)
     header = 128'h00000000_00006900_00000004_0a000000;

     //Send transactions that will cause function specific errors in each VF.
  
         write_data =$urandom();
         `ovm_info(get_full_name(),$psprintf("Section 2: Starting hqm_pcie_aer_header_fp_behavior_masked_error with Unexpected Completion:  func_num (0x%0x), write_data=%0h", 0, write_data),OVM_LOW)
         `ovm_do_on_with(ue_cpl_seq, p_sequencer.pick_sequencer(primary_id), {iosf_req_id == 0; iosf_cpl_status == 'h_0;})

         exp_ep_fatal_msg[0].trigger();

         header[19]    = ue_cpl_seq.iosf_tag[8];  
         header[23]    = ue_cpl_seq.iosf_tag[9];  
         header[79:72] = ue_cpl_seq.iosf_tag[7:0];
         header[95:80] = 0;
         header[22]    = 0;

         header_per_func[0] = header;
         `ovm_info(get_full_name(),$psprintf("Section 2: Pushing expected header into array, for func_no = %0h, header_per_func[func_num] = %0h ", 0, header_per_func[0]),OVM_DEBUG)
              
     //Verify PCIe and AER regs have correctly logged Error #2 in the uncorrectable error status reg and that the first error pointer and the error header log were updated to reflect Error #2.

         `ovm_info(get_full_name(),$psprintf("Section 2: after EC error transaction: Starting error_status_chk_seq for func_no = %0h, header_per_func[func_num] = %0h ", 0, header_per_func[0]),OVM_LOW)
         `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_fed==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1; test_induced_ec==1'b_1;en_H_FP_check==1'b_1; exp_header_log == header_per_func[0]; test_induced_fep==5'b10000;}); // fatal unmask

     `ovm_info(get_full_name(),$psprintf("Section 2: End"),OVM_LOW);

     //Section 2 End

  endtask : body

  task wait_sys_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

endclass : hqm_pcie_aer_header_fp_behavior_masked_error

`endif

