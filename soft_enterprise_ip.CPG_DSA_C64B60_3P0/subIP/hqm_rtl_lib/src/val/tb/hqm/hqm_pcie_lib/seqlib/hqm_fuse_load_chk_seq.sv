`ifndef HQM_FUSE_LOAD_CHK_SEQ_SV
`define HQM_FUSE_LOAD_CHK_SEQ_SV

class hqm_fuse_load_chk_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_fuse_load_chk_seq,sla_sequencer)
  
  bit hqm_illegal_fuse_cmpl_sai = $test$plusargs("HQM_ILLEGAL_FUSE_CMPL_SAI");

  ovm_event_pool  global_pool;
  ovm_event       hqm_send_ip_ready;

  function new(string name = "hqm_fuse_load_chk_seq");
    super.new(name);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_send_ip_ready = global_pool.get("hqm_send_ip_ready");

  endfunction

  virtual task body();
     if(hqm_illegal_fuse_cmpl_sai) begin // -- Illegal fuse cmpl sai chk sequence; Note: after fp removal, this is not applicable
          illegal_fuse_cmpl_sai_chk();
     end else begin // -- Normal fuse load chk sequence 
    bit rslt;
    string      fuse_string;
    longint     lfuse_val;
    bit [31:0]  expected_fuse_val;
    bit [31:0]  expected_reset_fuse_val;
    int fuse_data_var;
    int fuse_data_size;
    bit comp_result;

    // default desired 40 bit fuse value
    fuse_string =  "0x00000000";
    
    $value$plusargs("HQM_TB_FUSE_VALUES=%s",fuse_string);
    if (!$value$plusargs("HQM_TB_FUSE_DATA_VAR=%d",fuse_data_var)) fuse_data_var=0;
    if (!$value$plusargs("HQM_TB_FUSE_DATA_SIZE=%d", fuse_data_size)) fuse_data_size=1; // in DWs

    if (lvm_common_pkg::token_to_longint(fuse_string,lfuse_val) == 0) begin
      `ovm_error(get_full_name(),$psprintf("+HQM_TB_FUSE_VALUES=%s not a valid integer value",fuse_string))
      return;
    end
    expected_fuse_val[31:0] = lfuse_val[31:0];
    `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG 000: expected_fuse_val=0x%0x lfuse_val=0x%0x fuse_string=%0s", expected_fuse_val, lfuse_val, fuse_string), OVM_LOW);
    `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG 000: fuse_data_var=%0d fuse_data_size=%0d", fuse_data_var, fuse_data_size), OVM_LOW);

    // not_enough_fuse_data; Note: this is not applicable in HQMV25, fp removed
            

    // when proc_disable fuse is set to 1, Expect UR response for all transactions to HQM: HSD:2203610185
    if($test$plusargs("PROC_DISABLE_MODE")) begin
        `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG PROC_DISABLE_MODE"), OVM_LOW);
        send_rd(pf_cfg_regs.INT_LINE, 0,1);
        send_wr(pf_cfg_regs.INT_LINE, 8'h55,0,1);
    end
    else begin
        if (!$test$plusargs("RANDOMIZE_FUSE_VALUES")) begin
            // validate pulled fuses values from the registers    
            `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG validate pulled fuses values from the registers"), OVM_LOW);
            read_compare(hqm_sif_csr_regs.HQM_PULLED_FUSES_0, expected_fuse_val[31:0],.mask(32'h_0000_ffff),.result(rslt));
            `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG hqm_sif_csr_regs.HQM_PULLED_FUSES_0 expected_fuse_val=0x%0x result=%0d", expected_fuse_val, rslt), OVM_LOW);

            read_compare(pf_cfg_regs.REVISION_ID_CLASS_CODE, expected_fuse_val[15:8],.mask(32'h_0000_00ff),.result(rslt));
            `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG pf_cfg_regs.REVISION_ID_CLASS_CODE expected_fuse_val[15:8]=0x%0x result=%0d", expected_fuse_val[15:8], rslt), OVM_LOW);

            //exp[0] = proc_disable; exp[1] = force_on
            read_compare(master_regs.CFG_PM_STATUS, {expected_fuse_val[0],expected_fuse_val[1],10'h0},.mask(32'h_0000_0c00),.result(rslt));
            `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG master_regs.CFG_PM_STATUS expected_fuse_val[0][1]=0x%0x result=%0d", {expected_fuse_val[0],expected_fuse_val[1]}, rslt), OVM_LOW);
        end
    end
     end // -- Normal fuse cmpl chk sequence

    pf_cfg_regs.CACHE_LINE_SIZE.write(status,32'h_55aa_bcde, iosf_sb_sla_pkg::get_src_type(),this,.sai(legal_sai));
    pf_cfg_regs.CACHE_LINE_SIZE.read(status,rd_val, iosf_sb_sla_pkg::get_src_type(),this,.sai(legal_sai));

  endtask

  task illegal_fuse_cmpl_sai_chk();
       bit rslt;
       reset_check(hqm_sif_csr_regs.HQM_PULLED_FUSES_0);
       // -- read_compare(hqm_sif_csr_regs.HQM_PULLED_FUSES[0], 32'h_0, .mask(32'h_ffff_ffff),.result(rslt));
  endtask

endclass

`endif
