`ifndef HQM_SLA_PCIE_ERROR_POLLUTION_SEQUENCE_
`define HQM_SLA_PCIE_ERROR_POLLUTION_SEQUENCE_

class hqm_sla_pcie_error_pollution_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_error_pollution_seq,sla_sequencer)
  hqm_sla_pcie_mem_ur_seq       mem_ur_seq;
  hqm_sla_pcie_mem_mtlp_seq     mem_mtlp_seq;
  hqm_sla_pcie_d3_err_chk_seq   d3_err_seq;
  hqm_sla_pcie_cpl_error_seq    cpl_err_seq;
  hqm_sla_pcie_mem_mtlp_seq     mem_mtlp_ur_seq;
  bit                           b2b_error_pollution = $test$plusargs("HQM_PCIE_B2B_ERR_POLLUTION");
  string                        first_err = "", second_err = "";
  bit                           skip_chk  = $test$plusargs("HQM_PCIE_B2B_SINGLE_ERR_SKIP_CHK");
  bit                           skip_d3_reinit  = $test$plusargs("HQM_PCIE_B2B_ERR_SKIP_D3_REINIT");

  function new(string name = "hqm_sla_pcie_error_pollution_seq");
    super.new(name);
  endfunction

  virtual task body();

    pf_cfg_regs.FUNC_BAR_L.write(status,32'h_0,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.FUNC_BAR_U.write(status,32'h_5,primary_id,this,.sai(legal_sai));
    
    pf_cfg_regs.CSR_BAR_L.write(status,32'h_0,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.CSR_BAR_U.write(status,32'h_3,primary_id,this,.sai(legal_sai));

   if(!$value$plusargs("HQM_PCIE_B2B_FIRST_ERR=%s",  first_err))  begin first_err  = "mtlp_ptlp" ; end
   if(!$value$plusargs("HQM_PCIE_B2B_SECOND_ERR=%s", second_err)) begin second_err = "mtlp_ptlp" ; end

   if(b2b_error_pollution) begin

      `ovm_info(get_full_name(), $psprintf("Starting hqm_sla_pcie_error_pollution_seq with first_err(%s) & second_err(%s), skip_chk(0x%0x) and skip_d3_reinit", first_err, second_err, skip_chk, skip_d3_reinit), OVM_LOW)

      case(first_err.tolower())
          "ur_ptlp":      begin `ovm_do_with(d3_err_seq, {skip_checks == skip_chk; Ep==1'b1; skip_reinit == skip_d3_reinit;} );  end  
          "mtlp_ptlp":    begin `ovm_do_with(mem_mtlp_seq, {skip_checks == skip_chk; Ep==1'b1;});                                end  
          "uecpl_ptlp":   begin `ovm_do_with(cpl_err_seq, {skip_checks == skip_chk; ep==1'b1;});                                 end 
          "mtlp_ur_ptlp": begin `ovm_do_with(mem_mtlp_ur_seq, {skip_checks == skip_chk; Ep==1'b1;ur_addr_en==1'b1;});            end   
      endcase

      case(second_err.tolower())
          "ur_ptlp":      begin `ovm_do_with(d3_err_seq, {skip_checks == skip_chk; Ep==1'b1; skip_reinit == skip_d3_reinit;} );  end  
          "mtlp_ptlp":    begin `ovm_do_with(mem_mtlp_seq, {skip_checks == skip_chk; Ep==1'b1;});                                end  
          "uecpl_ptlp":   begin `ovm_do_with(cpl_err_seq, {skip_checks == skip_chk; ep==1'b1;});                                 end 
          "mtlp_ur_ptlp": begin `ovm_do_with(mem_mtlp_ur_seq, {skip_checks == skip_chk; Ep==1'b1;ur_addr_en==1'b1;});            end   
      endcase

   end else begin
      if((!$test$plusargs("HQM_PCIE_MEM_MTLP_ERR")) && ($test$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO")))  begin `ovm_do_with(d3_err_seq, {Ep==1'b1;})   end
      if(($test$plusargs("HQM_PCIE_MEM_MTLP_ERR")) && (!$test$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO")))  begin `ovm_do_with(mem_mtlp_seq, {Ep==1'b1;}) end
      if($test$plusargs("HQM_PCIE_CPL_ERR_FUNC_NO"))  begin `ovm_do_with(cpl_err_seq, {ep==1'b1;}) end
      if(($test$plusargs("HQM_PCIE_MEM_MTLP_ERR")) && ($test$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO"))) begin `ovm_do_with(mem_mtlp_ur_seq, {Ep==1'b1;ur_addr_en==1'b1;}) end
   end
  endtask

endclass

`endif
