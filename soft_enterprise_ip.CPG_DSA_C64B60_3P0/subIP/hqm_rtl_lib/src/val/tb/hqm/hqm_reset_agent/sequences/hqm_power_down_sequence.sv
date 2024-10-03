class hqm_power_down_sequence extends sla_sequence_base;

  `ovm_sequence_utils(hqm_power_down_sequence, sla_sequencer)

  hqm_reset_unit_sequence   power_down_sequence;

  function new(string name="hqm_power_down_sequence");
    super.new(name);
  endfunction

  task body;

    `ovm_info(get_type_name(),"Starting hqm_power_down_sequence", OVM_DEBUG);
    `ovm_do_on_with(power_down_sequence, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==POWER_DOWN;}); 
    `ovm_info(get_type_name(),"Done with hqm_power_down_sequence", OVM_DEBUG);

  endtask
   
endclass:hqm_power_down_sequence
