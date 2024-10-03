`ifndef HQM_RANDOM_DATA_SEQ_SV
`define HQM_RANDOM_DATA_SEQ_SV

class hqm_random_data_phase_seq extends hqm_sla_pcie_base_seq;//sla_sequence_base;

  `ovm_sequence_utils(hqm_random_data_phase_seq, sla_sequencer)

  hqm_fifo_hwm_stress_seq       hwm_stress_seq;
  hqm_background_cfg_seq        bg_cfg_gen_seq;
  hqm_iosf_sb_resetPrep_seq     resetPrep_seq;
  hqm_iosf_sb_forcewake_seq     forcePwrGatePOK_seq;

  function new(string name = "hqm_random_data_phase_seq");
    super.new(name);
  endfunction

  extern virtual task body();

endclass

task hqm_random_data_phase_seq::body();

  // FIFO High Watermark stress sequence - uses plusargs to enable individual fifo hwm stress
  if ($test$plusargs("HQM_EN_FIFO_HWM_STRESS_SEQ")) begin
    `ovm_do(hwm_stress_seq)
  end else begin
    `ovm_info(get_full_name(), $psprintf("Skipping FIFO high watermark sequence, as plusargs HQM_EN_FIFO_HWM_STRESS_SEQ has been specified"), OVM_LOW);
  end

  if ( $test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ") &&  !($test$plusargs("HQM_DISABLE_BACKGROUND_CFG_GEN_SEQ")) )	begin
	`ovm_info(get_full_name(),"Polling for DEVICE_COMMAND MEM fields to be set",OVM_LOW)
        poll_reg_val(pf_cfg_regs.DEVICE_COMMAND,'h_0000_0006,'h_0000_0002,1000);
	`ovm_info(get_full_name(),"Polling for CFG_PM_PMCSR_DISABLE DISABLE field to be cleared",OVM_LOW)
        poll_reg_val(master_regs.CFG_PM_PMCSR_DISABLE,'h_0000_0000,'h_ffff_ffff,1000);

	`ovm_info(get_full_name(),$psprintf("Starting hqm_background_cfg_seq as HQM_BACKGROUND_CFG_GEN_SEQ=%0d",$test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")),OVM_LOW)
	`ovm_do(bg_cfg_gen_seq);
  end else
	`ovm_info(get_full_name(),$psprintf("Avoiding hqm_background_cfg_seq as HQM_BACKGROUND_CFG_GEN_SEQ=%0d",$test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")),OVM_LOW)

  
  if($test$plusargs("HQM_ILLEGAL_FORCE_POK_SAI_WITH_HCW"))	begin repeat(10) begin `ovm_do_with(forcePwrGatePOK_seq,{inject_illegal_sai == 1;}); wait_ns_clk(100); end end

  if($test$plusargs("HQM_ILLEGAL_RESETPREP_SAI_WITH_HCW"))	begin repeat(10) begin `ovm_do_with(resetPrep_seq, {inject_illegal_sai == 1;})       wait_ns_clk(100); end end

endtask

`endif //HQM_BACKGROUND_CFG_SEQ_SV
