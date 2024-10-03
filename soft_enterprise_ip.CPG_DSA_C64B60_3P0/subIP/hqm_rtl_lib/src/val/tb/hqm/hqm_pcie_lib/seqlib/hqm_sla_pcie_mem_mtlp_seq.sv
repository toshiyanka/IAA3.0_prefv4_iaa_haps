`ifndef HQM_SLA_PCIE_MEM_MTLP_SEQ
`define HQM_SLA_PCIE_MEM_MTLP_SEQ

import lvm_common_pkg::*;


class hqm_sla_pcie_mem_mtlp_seq extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_sla_pcie_mem_mtlp_seq,sla_sequencer)
  rand bit Ep = 1'b0;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_badtxn_seq        mem_write_seq;
  hqm_sla_pcie_eot_checks_sequence                         error_status_chk_seq;
  rand bit ur_addr_en = 0;
  rand bit skip_checks = 0;
  rand bit reporting_en;
  bit exp_sse;

  // ---------------------------------------------------------------
  // -- Event pool
  // ---------------------------------------------------------------

  ovm_event_pool glbl_pool;
  ovm_event      exp_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_corr_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_fatal_msg[`MAX_NO_OF_VFS+1];


  constraint _report_en_ { soft reporting_en == 1'b1; }
  constraint deflt_Ep { soft Ep == 1'b0; }
  constraint deflt_ur_addr_en { soft ur_addr_en == 1'b0; }
  constraint skip_checks_c { soft skip_checks == 1'b0; }

  function new(string name = "hqm_sla_pcie_mem_mtlp_seq");
    super.new(name); 

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      exp_ep_nfatal_msg[i]   = glbl_pool.get($psprintf("exp_ep_nfatal_msg_%0d",i));
      exp_ep_fatal_msg[i]    = glbl_pool.get($psprintf("exp_ep_fatal_msg_%0d",i));
      exp_ep_corr_msg[i]     = glbl_pool.get($psprintf("exp_ep_corr_msg_%0d",i));
      obs_ep_nfatal_msg[i]   = glbl_pool.get($psprintf("obs_ep_nfatal_msg_%0d",i));
      obs_ep_fatal_msg[i]    = glbl_pool.get($psprintf("obs_ep_fatal_msg_%0d",i));
    end

  endfunction

  virtual task body();
    sla_ral_addr_t _mtlp_inj_addr_;
    sla_ral_data_t i_data;
    int sev_mask_val;
    bit [4:0] first_pointer = 5'b0;
    bit urd = 1'b0;
    bit [127:0] header = 128'h00000000_00000000_0000690f_60000000;

    if (ur_addr_en == 1'b0) begin 
      _mtlp_inj_addr_ = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),master_regs.CFG_DIAGNOSTIC_RESET_STATUS);
    end   
    else begin 
       _mtlp_inj_addr_ = 64'ha00008000;
    end   
    first_pointer = 5'h12;

       first_pointer = 5'h12;

    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_mem_mtlp_seq with: _mtlp_inj_addr_ (0x%0x) Ep %d ur_addr_en %d",_mtlp_inj_addr_, Ep, ur_addr_en),OVM_LOW)

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _mtlp_inj_addr_; iosf_data.size() == 1; iosf_data[0] == 32'h0; iosf_length=='h70;ep==Ep;})

    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val))
        sev_mask_val = 0;
    `ovm_info(get_full_name(),$psprintf("tag field: mem_write_seq.iosf_tag = %h, sev_mask_val = %d, mem_write_seq.iosf_length = %d", mem_write_seq.iosf_tag, sev_mask_val, mem_write_seq.iosf_length),OVM_LOW)
    i_data = get_reg_value("DEVICE_COMMAND", "hqm_pf_cfg_i");
    exp_sse = i_data[8];
    i_data = get_reg_value("PCIE_CAP_DEVICE_CONTROL", "hqm_pf_cfg_i");

    `ovm_info(get_full_name(),$psprintf("tag field: mem_write_seq.iosf_tag = %h, sev_mask_val = %d, mem_write_seq.iosf_length = %d, exp_sse = %d, i_data=%h", mem_write_seq.iosf_tag, sev_mask_val, mem_write_seq.iosf_length, exp_sse, i_data),OVM_LOW)
 

    if (_mtlp_inj_addr_[63:32]==0) begin
      header[95:64] = _mtlp_inj_addr_[31:0];
    end
    else begin
      header[127:96] = _mtlp_inj_addr_[31:0];
      header[95:64] = _mtlp_inj_addr_[63:32];
    end
    
    header[47:40] = (mem_write_seq.iosf_tag[7:0] - 1); // Tag
    header[39:36] = (mem_write_seq.iosf_length > 8) ? 4'hf : 4'h0; //LBE
    header[35:32] = 4'hf; // FBE
    header[31:29] = 3'b011; //Fmt -- MWr -> 3'b_011
    header[28:24] = 5'b00000; // Type
    header[23:8] = 16'h0000;
    header[23] = mem_write_seq.iosf_tag[9]; // Tag
    header[19] = mem_write_seq.iosf_tag[8]; // Tag
    header[14] = Ep;// Ep bit
    header[7:0] = mem_write_seq.iosf_length;// Length

    if(skip_checks) begin
          `ovm_info(get_full_name(), $psprintf("Skipping error logging checks in hqm_sla_pcie_mem_mtlp_seq as skip_checks(0x%0x)!!!", skip_checks), OVM_LOW)
          case (sev_mask_val)
              0: begin if(reporting_en) exp_ep_nfatal_msg[0].trigger(); end 
              1: begin if(reporting_en) exp_ep_fatal_msg[0].trigger() ; end 
          endcase    

    end else begin
    case (sev_mask_val)
        0: begin
              if(reporting_en) exp_ep_nfatal_msg[0].trigger();
              if (exp_sse)
                  obs_ep_nfatal_msg[0].wait_trigger();
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_ned==1'b_1; test_induced_mtlp==1'b_1; test_induced_anfes==urd;test_induced_ur==urd;test_induced_urd==urd;en_H_FP_check==1'b_1; exp_header_log == header; test_induced_fep==first_pointer; test_induced_sse==exp_sse;}); //non-fatal unmask 
           end 
        1: begin 
              if(reporting_en) exp_ep_fatal_msg[0].trigger();
              if (exp_sse)
                  obs_ep_fatal_msg[0].wait_trigger();
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_fed==1'b_1; test_induced_mtlp==1'b_1;test_induced_ur==urd;test_induced_urd==urd;en_H_FP_check==1'b_1; exp_header_log == header;test_induced_fep==first_pointer; test_induced_sse==exp_sse;}); // fatal unmask
           end 
        2: begin
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_ned==1'b_1; test_induced_mtlp==1'b_1; test_induced_anfes==urd;test_induced_ur==urd;test_induced_urd==urd;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); //non-fatal mask 
           end 
        3: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_fed==1'b_1; test_induced_mtlp==1'b_1;test_induced_ur==urd;test_induced_urd==urd;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); // fatal mask
           end
    endcase      
    //read_compare(pf_cfg_regs.AER_CAP_CONTROL,32'h0000_000c,32'hffff_ffff,rslt);
     end

  endtask : body
endclass : hqm_sla_pcie_mem_mtlp_seq

`endif
