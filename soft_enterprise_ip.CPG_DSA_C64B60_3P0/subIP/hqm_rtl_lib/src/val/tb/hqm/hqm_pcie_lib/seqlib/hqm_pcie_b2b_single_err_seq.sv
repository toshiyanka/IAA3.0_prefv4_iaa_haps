`ifndef HQM_PCIE_B2B_SINGLE_ERR_SEQ__SV
`define HQM_PCIE_B2B_SINGLE_ERR_SEQ__SV

class hqm_pcie_b2b_single_err_seq extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_pcie_b2b_single_err_seq,sla_sequencer)
  hqm_sla_pcie_cpl_error_seq  ue_cpl_seq;
  hqm_sla_pcie_d3_err_chk_seq d3_ur_seq;
  hqm_sla_pcie_mem_mtlp_seq   mtlp_seq ;
  string                      first_err = "", second_err = "";
  bit                         skip_chk  = $test$plusargs("HQM_PCIE_B2B_SINGLE_ERR_SKIP_CHK");
  bit                         skip_d3_reinit  = $test$plusargs("HQM_PCIE_B2B_ERR_SKIP_D3_REINIT");

  function new(string name = "hqm_pcie_b2b_single_err_seq");
    super.new(name); 
  endfunction

  virtual task body();

    pf_cfg_regs.FUNC_BAR_L.write(status,32'h_0,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.FUNC_BAR_U.write(status,32'h_5,primary_id,this,.sai(legal_sai));
    
    pf_cfg_regs.CSR_BAR_L.write(status,32'h_0,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.CSR_BAR_U.write(status,32'h_3,primary_id,this,.sai(legal_sai));

    if(!$value$plusargs("HQM_PCIE_B2B_FIRST_ERR=%s",  first_err))  begin first_err  = $urandom(1) ? "mtlp" : ($urandom(1) ? "d3ur" : "ue_cpl" ); end
    if(!$value$plusargs("HQM_PCIE_B2B_SECOND_ERR=%s", second_err)) begin second_err = $urandom(1) ? "mtlp" : ($urandom(1) ? "d3ur" : "ue_cpl" ); end

    `ovm_info(get_full_name(), $psprintf("Starting hqm_pcie_b2b_single_err_seq with first_err(%s) & second_err(%s), skip_chk(0x%0x) and skip_d3_reinit", first_err, second_err, skip_chk, skip_d3_reinit), OVM_LOW)

    enable_err_reporting();

    // -- First error  -- //
    case(first_err.tolower())
    "mtlp":  begin `ovm_do_with(mtlp_seq,   {skip_checks == skip_chk;});                                end
    "d3ur":  begin `ovm_do_with(d3_ur_seq,  {skip_checks == skip_chk; skip_reinit == skip_d3_reinit;}); end
    "uecpl": begin `ovm_do_with(ue_cpl_seq, {skip_checks == skip_chk;});                                end
    endcase

    // -- Second error -- //
    case(second_err.tolower())
    "mtlp":  begin `ovm_do_with(mtlp_seq,   {skip_checks == skip_chk;});                                end
    "d3ur":  begin `ovm_do_with(d3_ur_seq,  {skip_checks == skip_chk; skip_reinit == skip_d3_reinit;}); end
    "uecpl": begin `ovm_do_with(ue_cpl_seq, {skip_checks == skip_chk;});                                end
    endcase

  endtask : body

  task enable_err_reporting();
     pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"NERE"},{1'b_1},primary_id,this,.sai(legal_sai));
     pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"FERE"},{1'b_1},primary_id,this,.sai(legal_sai));
     pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"CERE"},{1'b_1},primary_id,this,.sai(legal_sai));
     pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"URRO","CERE","FERE"},{1'b_1, 1'b_1, 1'b_1},primary_id,this,.sai(legal_sai)); 
  endtask : enable_err_reporting

endclass : hqm_pcie_b2b_single_err_seq

`endif
