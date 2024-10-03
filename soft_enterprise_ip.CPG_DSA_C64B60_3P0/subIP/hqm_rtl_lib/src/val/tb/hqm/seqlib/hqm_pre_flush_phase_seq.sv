`ifndef HQM_PRE_FLUSH_PHASE_SEQ_SV
`define HQM_PRE_FLUSH_PHASE_SEQ_SV

class hqm_pre_flush_phase_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_pre_flush_phase_seq, sla_sequencer)

  hqm_hw_agitate_seq            agitate_seq;

  function new(string name = "hqm_pre_flush_phase_seq");
    super.new(name);
  endfunction

  extern virtual task body();

endclass

task hqm_pre_flush_phase_seq::body();
  //-- Stop Agitation --//
  `ovm_do_with(agitate_seq, {{agitate_seq.start_stop == STOP};})

endtask

`endif //HQM_PRE_FLUSH_PHASE_SEQ_SV
