`ifndef HQM_SLA_PCIE_D3_ERR_CHK_SEQ__SV
`define HQM_SLA_PCIE_D3_ERR_CHK_SEQ__SV

class hqm_sla_pcie_d3_err_chk_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_d3_err_chk_seq,sla_sequencer)
  rand bit Ep = 1'b0;
  rand bit skip_checks ;
  rand bit skip_reinit ;
 
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_rd_seq;
  hqm_sla_pcie_eot_checks_sequence                      error_status_chk_seq;
  hqm_sla_pcie_init_seq                                 hqm_init_seq;


  rand bit reporting_en;
  ovm_event_pool glbl_pool;

  // ---------------------------------------------------------------
  // -- Event pool
  // ---------------------------------------------------------------

  ovm_event      exp_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_corr_msg[`MAX_NO_OF_VFS+1];

  constraint deflt_Ep { soft Ep == 1'b0; }
  constraint skip_checks_c { soft skip_checks == 1'b0; }
  constraint skip_reinit_c { soft skip_reinit == 1'b0; }
  constraint _report_en_ { soft reporting_en == 1'b1; }

  function new(string name = "hqm_sla_pcie_d3_err_chk_seq");
    super.new(name);

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      exp_ep_nfatal_msg[i]   = glbl_pool.get($psprintf("exp_ep_nfatal_msg_%0d",i));
      exp_ep_fatal_msg[i]    = glbl_pool.get($psprintf("exp_ep_fatal_msg_%0d",i));
      exp_ep_corr_msg[i]     = glbl_pool.get($psprintf("exp_ep_corr_msg_%0d",i));
    end

  endfunction

  virtual task body();
    sla_ral_reg       my_reg;
    sla_ral_data_t    ral_data;
    sla_ral_addr_t    _ur_inj_addr_='h_0;
    logic [7:0]  func_num=0;
    int sev_mask_val;
    bit [127:0] header = 128'h00000000_00000000_0000690f_00000001;

    if($test$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO")) begin $value$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO=%0d",func_num); end 

    // -- Enter D3 state -- //
    pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,32'h_3,primary_id,this,.sai(legal_sai)); wait_ns_clk(2000);;

        _ur_inj_addr_ = ral.get_addr_val(primary_id,master_regs.CFG_DIAGNOSTIC_RESET_STATUS); 
    `ovm_do_on_with(mem_rd_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr == _ur_inj_addr_; iosf_data == 32'h0; iosf_exp_error == 1'b_1; ep==Ep;})

    header[127:96] = _ur_inj_addr_[31:0];
    header[95:64] = _ur_inj_addr_[63:32];
    header[47:40] = mem_rd_seq.iosf_tag[7:0];
    header[31:24] = 8'b0010_0000;
    header[23]    = mem_rd_seq.iosf_tag[9];  
    header[19]    = mem_rd_seq.iosf_tag[8];  
    header[14] = Ep;
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_d3_err_chk_seq with: _ur_inj_addr_ (0x%0x); func_num (0x%0x), Ep %d, header=%0h",_ur_inj_addr_,func_num, Ep, header[127:0]),OVM_LOW)

    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val))  sev_mask_val = 0;
    `ovm_info(get_full_name(),$psprintf("tag field in header: iosf_tag = %h, sev_mask_val = %d", header[55:48], sev_mask_val),OVM_LOW)

    if(skip_checks) begin
          `ovm_info(get_full_name(), $psprintf("Skipping error logging checks in hqm_sla_pcie_d3_err_chk_seq as skip_checks(0x%0x)!!!", skip_checks), OVM_LOW)
          case (sev_mask_val)
              1: begin if(reporting_en) exp_ep_fatal_msg[func_num].trigger(); end 
              4: begin if(reporting_en) exp_ep_corr_msg[func_num].trigger() ; end 
          endcase    
          wait_ns_clk(3000); // -- Waiting for SB err message in case of skip checks only -- //
    end else begin

    case (sev_mask_val)
        0: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==(1'b_1); test_induced_urd==(1'b_1);test_induced_anfes==(1'b_1); test_induced_ur==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110; /*exp_header_log == header;*/}); //non-fatal unmask 
           end 
        1: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==(1'b_1); test_induced_urd==(1'b_1); test_induced_ur==(1'b_1);en_H_FP_check==1'b_1; exp_header_log == header; }); // fatal unmask
              if(reporting_en) exp_ep_fatal_msg[func_num].trigger();
           end 
        2: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==(1'b_1); test_induced_urd==(1'b_1);test_induced_anfes==(1'b_1); test_induced_ur==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); //non-fatal mask 
           end 
        3: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==(1'b_1); test_induced_urd==(1'b_1); test_induced_ur==(1'b_1);en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); // fatal mask
           end
        4: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==(1'b_1); test_induced_urd==(1'b_1);test_induced_anfes==(1'b_1); test_induced_ur==(1'b_1); en_H_FP_check==1'b_1; exp_header_log == header;}); //non-fatal unmask anfes unmask 
              if(reporting_en) exp_ep_corr_msg[func_num].trigger();
           end 

    endcase      

    end      

    if(skip_reinit) begin `ovm_info(get_full_name(), $psprintf("Skipping re-init of HQM in hqm_sla_pcie_d3_err_chk_seq !!"), OVM_LOW); end
    else            begin
         `ovm_info(get_full_name(), $psprintf("Doing re-init of HQM in hqm_sla_pcie_d3_err_chk_seq !!"), OVM_LOW);
         // -- Enter D0 state -- //
         pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,32'h_0,primary_id,this,.sai(legal_sai)); wait_ns_clk(2000);;
         `ovm_do(hqm_init_seq);
    end

  endtask

endclass

`endif
