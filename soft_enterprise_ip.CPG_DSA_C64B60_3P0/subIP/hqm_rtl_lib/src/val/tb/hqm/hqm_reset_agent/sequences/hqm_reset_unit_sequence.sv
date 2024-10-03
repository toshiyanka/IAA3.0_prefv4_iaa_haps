`ifndef HQM_RESET_UNIT_SEQUENCE__SV
`define HQM_RESET_UNIT_SEQUENCE__SV

class hqm_reset_unit_sequence extends ovm_sequence#(hqm_reset_transaction);

  `ovm_sequence_utils(hqm_reset_unit_sequence, hqm_reset_sequencer)

  rand reset_flow_t reset_flow_typ;
  rand bit[(`LCP_DEPTH - 1):0]    LcpDatIn_l;
  rand bit[15:0]    EarlyFuseIn_l;

  function new(string name="hqm_reset_unit_sequence");
    super.new(name);
  endfunction

  task body;

    `ovm_info(get_type_name(),"Starting hqm_reset_unit_sequence", OVM_DEBUG);
    `ovm_do_with (req, {reset_flow_type==reset_flow_typ; LcpDatIn==LcpDatIn_l; EarlyFuseIn==EarlyFuseIn_l;})
    `ovm_info(get_type_name(),"Done with hqm_reset_unit_sequence", OVM_DEBUG);

  endtask
   
endclass:hqm_reset_unit_sequence

`endif
