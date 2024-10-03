class hqm_hw_reset_force_pwr_on_sequence extends sla_sequence_base;

  `ovm_sequence_utils(hqm_hw_reset_force_pwr_on_sequence, sla_sequencer)

  hqm_reset_unit_sequence   hw_reset_force_pwr_on_sequence;

  function new(string name="hqm_hw_reset_force_pwr_on_sequence");
    super.new(name);
  endfunction

  task body;

    `ovm_info(get_type_name(),"Starting hqm_hw_reset_force_pwr_on_sequence", OVM_LOW);
    `ovm_do_on_with(hw_reset_force_pwr_on_sequence, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==HW_RESET_FORCE_PWR_ON_ASSERT;}); 
    `ovm_info(get_type_name(),"Done with hqm_hw_reset_force_pwr_on_sequence", OVM_LOW);

  endtask
   
endclass:hqm_hw_reset_force_pwr_on_sequence
