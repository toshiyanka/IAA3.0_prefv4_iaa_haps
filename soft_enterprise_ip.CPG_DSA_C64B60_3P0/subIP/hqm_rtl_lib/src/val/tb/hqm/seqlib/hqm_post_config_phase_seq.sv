`ifndef HQM_POST_CONFIG_PHASE_SEQ_SV
`define HQM_POST_CONFIG_PHASE_SEQ_SV

class hqm_post_config_phase_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_post_config_phase_seq, sla_sequencer)

  hqm_hw_agitate_seq      agitate_seq;
  hqm_policy_reg_cfg_seq  policy_cfg_seq;

  function new(string name = "hqm_post_config_phase_seq");
    super.new(name);
  endfunction

  extern virtual task body();

endclass

task hqm_post_config_phase_seq::body();

  if ($test$plusargs("HQM_SAVE_CONFIG_STATE")) begin
    `ovm_info(get_full_name(),"Saving state of simulation after CONFIG_PHASE to hqm_save_config_state.chk",OVM_LOW)
    $save("hqm_save_config_state.chk");
  end

  //-- Run agitate sequence --//
  if ($test$plusargs("HQM_SKIP_AGITATE_SEQ_POST_CONFIG_PHASE")) begin
    `ovm_info("HQM_POST_CONFIG_PHASE_SEQ", $psprintf("+HQM_SKIP_AGITATE_SEQ_POST_CONFIG_PHASE provided, skipping agitate sequence call in POST_CONFIG_PHASE"), OVM_NONE);
  end
  else begin  
    `ovm_do_with(agitate_seq, {{agitate_seq.start_stop == START};})
  end

if ($test$plusargs("HQM_CFG_WAC_RAC_REG_SEQ")) begin
    `ovm_info("HQM_POST_CONFIG_PHASE_SEQ", $psprintf("+HQM_CFG_WAC_RAC_REG_SEQ provided to config CSR_WAC and RAC in POST_CONFIG_PHASE"), OVM_NONE);
    `ovm_do(policy_cfg_seq);
end 
  

endtask

`endif //HQM_POST_CONFIG_PHASE_SEQ_SV
