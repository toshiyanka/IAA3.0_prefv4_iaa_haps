// =====================================================================================================
// FileName          : dfx_tap_idcode_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Jun 22 16:07:05 CDT 2011
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Basic IDCODE sequence
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_IDCODE_SEQUENCE_SV
`define DFX_TAP_IDCODE_SEQUENCE_SV

class dfx_tap_idcode_sequence extends dfx_common_sequence;

  `ovm_sequence_utils(dfx_tap_idcode_sequence, dfx_tap_virtual_sequencer)

  dfx_tap_enable_sequence enblseq;
  dfx_tap_single_tap_transaction stt;
  dfx_node_t[31:0] actual, expected;
  tap_ir_t ico = idcode_opcode(STAP25);

  function new(string name = "dfx_tap_transactions_sequence");
    super.new(name);
  endfunction : new

  task enable_tap(dfx_tap_unit_e t, dfx_tap_port_e p = TAP_PORT_P0);
    `ovm_create(enblseq)
    enblseq.enable_tap[t] = p;
    `ovm_send(enblseq)
  endtask : enable_tap

  task idcode_test(dfx_tap_unit_e t, dfx_tap_port_e p = TAP_PORT_P0);
    ico = idcode_opcode(t);
    `ovm_do_on_with(stt, p_sequencer.tap_seqr_array[p], {tap_u == local::t; ir_in == local::ico;})
    actual = {<< {stt.ttd_out}};
    check32::check_value({"TAP ", t.name}, actual, (expected = idcode_value(t)));
  endtask : idcode_test

  task body();

    idcode_test(CLTAP);
    
    enable_tap(STAP20);
    idcode_test(STAP20);

    enable_tap(STAP24);
    idcode_test(STAP24);

    enable_tap(STAP25);
    idcode_test(STAP25);

    `ovm_create(enblseq)
    enblseq.enable_tap[STAP20] = TAP_PORT_P1;
    enblseq.enable_tap[STAP24] = TAP_PORT_P1;
    enblseq.enable_tap[STAP25] = TAP_PORT_P1;
    `ovm_send(enblseq)

    idcode_test(STAP20, TAP_PORT_P1);
    idcode_test(STAP24, TAP_PORT_P1);
    idcode_test(STAP25, TAP_PORT_P1);

  endtask : body

endclass : dfx_tap_idcode_sequence

`endif // `ifndef DFX_TAP_IDCODE_SEQUENCE_SV
