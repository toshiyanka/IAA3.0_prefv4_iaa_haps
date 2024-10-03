`ifndef HQM_SLA_PCIE_CFG_POISON_SEQ
`define HQM_SLA_PCIE_CFG_POISON_SEQ

import lvm_common_pkg::*;


class hqm_sla_pcie_cfg_poison_seq extends hqm_sla_pcie_base_seq;//ovm_sequence; 
  `ovm_sequence_utils(hqm_sla_pcie_cfg_poison_seq,sla_sequencer)

  //hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_poisoned_seq  cfg_write_poison_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_rd_seq    cfg_read_poison_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_seq    cfg_write_poison_seq;
  hqm_tb_sequences_pkg::hqm_iosf_unsupport_transaction_seq     unsupport_transaction_seq;

  bit serr_en = $test$plusargs("HQM_SERR_EN");

  hqm_sla_pcie_eot_checks_sequence                         error_status_chk_seq;
  ovm_event_pool glbl_pool;
  rand bit reporting_en;

  // ---------------------------------------------------------------
  // -- Event pool
  // ---------------------------------------------------------------

  ovm_event      exp_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_corr_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_fatal_msg[`MAX_NO_OF_VFS+1];

  constraint _report_en_ { soft reporting_en == 1'b1; }

  function new(string name = "hqm_sla_pcie_cfg_poison_seq");
    super.new(name); 

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      exp_ep_nfatal_msg[i]   = glbl_pool.get($psprintf("exp_ep_nfatal_msg_%0d",i));
      exp_ep_fatal_msg[i]    = glbl_pool.get($psprintf("exp_ep_fatal_msg_%0d",i));
      exp_ep_corr_msg[i]     = glbl_pool.get($psprintf("exp_ep_corr_msg_%0d",i));

      obs_ep_fatal_msg[i]    = glbl_pool.get($psprintf("obs_ep_fatal_msg_%0d",i));
    end

    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    `sla_assert($cast(pf_cfg_regs,          ral.find_file("hqm_pf_cfg_i")),     ("Unable to get handle to pf_cfg_regs."))

  endfunction

  virtual task body();
    sla_ral_addr_t    _poison_inj_addr_;
    sla_ral_data_t    rd_val;
    logic   [4:0]     func_num=0;
    bit    [31:0]     reg_default_val;
    bit    [31:0]     reg_wr_val;
    int               sev_mask_val;
    bit    [31:0]      write_data;
    bit   [127:0]      header;
    int                ptlp_txn_type;
    int                bus_number_change;
    bit    [9:0]       exp_tag;
    int                skip_aer_checks;
    int                sticky_bits_chk_after_warm_rst;

    // bits ep = 1, length[7:0] = 1, {fmt,type} = 02 (as per steve mail) -- Should be actual for V2 
    header = 128'h0007000c_00000000_0000000f_44004001;
    write_data =$urandom();
    skip_aer_checks=0;

    if($test$plusargs("HQM_PCIE_CFG_ERR_FUNC_NO")) begin $value$plusargs("HQM_PCIE_CFG_ERR_FUNC_NO=%0d",func_num); end
    $value$plusargs("PTLP_TXN_TYPE=%0d",ptlp_txn_type);
    $value$plusargs("PTLP_BUS_CHANGE=%0d", bus_number_change);
    if($test$plusargs("SKIP_AER_CHECKS")) 
        skip_aer_checks=1;
    if($test$plusargs("STICKY_CHK_AFTER_WARM_RST")) sticky_bits_chk_after_warm_rst=1;

    if (func_num == 0) begin 
        _poison_inj_addr_ = ral.get_addr_val(primary_id, pf_cfg_regs.CACHE_LINE_SIZE);
	    pf_cfg_regs.CACHE_LINE_SIZE.write(status, write_data[7:0], primary_id);
	    pf_cfg_regs.CACHE_LINE_SIZE.read(status, rd_val, primary_id);

        reg_default_val = rd_val[7:0];
        reg_wr_val      = 32'hf;
    end  
  
    if (bus_number_change==1)
        _poison_inj_addr_[31:24] = 8'h2F;
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_cfg_poison_seq with: _poison_inj_addr_ (0x%0x); func_num (0x%0x), bus_number (0x%0x), ptlp_txn_type=%0d",_poison_inj_addr_,func_num, _poison_inj_addr_[31:24], ptlp_txn_type),OVM_LOW)

    if (ptlp_txn_type==0) begin// CfgWr0
        `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_poison_inj_addr_;  iosf_exp_error==1; iosf_data==reg_wr_val; iosf_EP==1;});
        exp_tag = cfg_write_poison_seq.iosf_tag;
        //exp_tag = cfg_read_poison_seq.iosf_tag;
    end
    else if (ptlp_txn_type==1) begin // CfgRd0
        //PCIe spec 2.7.2.2: The behavior of the Rreceiver is not specified if the EP bit is set for any TLP that does not include a data payload
        send_tlp(get_tlp(_poison_inj_addr_, Iosf::CfgRd0, .i_errorPresent(1'b1)), .skip_ur_chk(1));
        //`ovm_do_on_with(cfg_read_poison_seq, p_sequencer.pick_sequencer(primary_id), { iosf_addr==_poison_inj_addr_;  iosf_exp_error==0; iosf_EP==1;}); 
        //exp_tag = cfg_read_poison_seq.iosf_tag;
    end
    else if (ptlp_txn_type==2) begin // CfgWr0,CfgRd0
        fork
        begin
            `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_poison_inj_addr_;  iosf_exp_error==1; iosf_data==reg_wr_val; iosf_EP==1;});
            exp_tag = cfg_write_poison_seq.iosf_tag;
        end
        begin
            `ovm_do_on_with(cfg_read_poison_seq, p_sequencer.pick_sequencer(primary_id), { iosf_addr==_poison_inj_addr_;  iosf_exp_error==1; iosf_EP==1;});
        end
        join
    end
    else if (ptlp_txn_type==3) begin // poison,UR
         `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_poison_inj_addr_;  iosf_exp_error==1; iosf_data==reg_wr_val; iosf_EP==1;});
         exp_tag = cfg_write_poison_seq.iosf_tag;
         `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_poison_inj_addr_; iosf_data==reg_wr_val; iosf_cmd32==Iosf::LTMWr32;})
         `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_poison_inj_addr_; iosf_data==reg_wr_val; iosf_cmd32==Iosf::IOWr; })
         `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_cmd==Iosf::Cpl; is_cpl==1; iosf_addr=={57'h0,_poison_inj_addr_[6:0]}; length_i==0; iosf_data==reg_wr_val; fbe_i==3'h0; lbe_i==4;})

    end
    if (bus_number_change==1) begin
        _poison_inj_addr_[31:24] = 8'hEF;
        `ovm_do_on_with(cfg_read_poison_seq, p_sequencer.pick_sequencer(primary_id), { iosf_addr==_poison_inj_addr_;});
    end

    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val))
        sev_mask_val = 0;
    `ovm_info(get_full_name(),$psprintf("tag field: cfg_write_poison_seq.iosf_tag=%h, sev_mask_val = %d, cfg_read_poison_seq.iosf_tag=%h, ptlp_txn_type=%0d", cfg_write_poison_seq.iosf_tag, sev_mask_val, cfg_read_poison_seq.iosf_tag, ptlp_txn_type),OVM_LOW)

    header[47:40]   = exp_tag[7:0];
    header[31:24]   = (ptlp_txn_type==1)?8'h04:8'h44;
    header[23]      = exp_tag[9];  
    header[19]      = exp_tag[8];  
    header[95:64]  = _poison_inj_addr_[31:0];
    header[127:96]  = _poison_inj_addr_[63:32];

    if (skip_aer_checks)
        `ovm_info(get_full_name(),$psprintf("Skipping AER checks as the plusarg SKIP_AER_CHECKS is set. skip_aer_checks = %0d", skip_aer_checks),OVM_LOW)
    else begin
        case (sev_mask_val)
            0: begin
                  `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110; /*exp_header_log == header;*/}); //non-fatal unmask 
                  // -- if(reporting_en) exp_ep_nfatal_msg[func_num].trigger();
               end 
            1: begin
                  if(serr_en) wait_fatal_msg(func_num);
                  `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_sse==serr_en; test_induced_ptlpr==1'b_1; en_H_FP_check==1'b_1; exp_header_log == header; }); // fatal unmask
                  if(reporting_en) exp_ep_fatal_msg[func_num].trigger();
               end 
            2: begin
                  `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); //non-fatal mask 
               end 
            3: begin 
                  `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); // fatal mask
               end
            4: begin
                  `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1; en_H_FP_check==1'b_1; exp_header_log == header;}); //non-fatal unmask anfes unmask 
                  if(reporting_en) exp_ep_corr_msg[func_num].trigger();
               end 
        endcase      
    end

    if (sticky_bits_chk_after_warm_rst) begin
          `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_sse==serr_en; test_induced_ptlpr==1'b_1; en_H_FP_check==1'b_1; exp_header_log == header; skip_status_clear==1'b1; }); // fatal unmask
          exp_ep_fatal_msg[func_num].trigger();
    end

    if (func_num == 0) 
        read_compare(pf_cfg_regs.CACHE_LINE_SIZE, reg_default_val,8'h_ff,result); 

  endtask : body

  task wait_fatal_msg(int func_num);
    bit timeout = 1;

    fork 
       begin obs_ep_fatal_msg[func_num].wait_trigger(); timeout=0; end
       begin wait_ns_clk(7000); end
    join_any

    if(timeout) `ovm_error(get_full_name(), $psprintf("Didn't receive Fatal msg from func_num (0x%0x) within 7000ns", func_num))
    else        `ovm_info (get_full_name(), $psprintf("Received Fatal msg from func_num (0x%0x) within 7000ns", func_num), OVM_LOW)

  endtask : wait_fatal_msg

endclass : hqm_sla_pcie_cfg_poison_seq

`endif
