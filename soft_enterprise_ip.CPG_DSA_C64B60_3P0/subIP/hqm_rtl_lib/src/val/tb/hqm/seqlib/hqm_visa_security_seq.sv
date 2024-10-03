class hqm_visa_security_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_visa_security_seq, sla_sequencer)
  function new(string name = "hqm_visa_security_seq");
    super.new(name);
  endfunction

  `include "hqm_visa_security_body.svh"
  //`include "hqm_visa_body.svh"

endclass : hqm_visa_security_seq


