// =====================================================================================================
// FileName          : dfx_tap_sip_api_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Sat Nov  1 17:26:12 CDT 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx SIP API use case sequence
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_SIP_API_SEQUENCE_SV
`define DFX_TAP_SIP_API_SEQUENCE_SV

class dfx_tap_sip_api_sequence extends JtagBfmSequences;

  `ovm_sequence_utils(dfx_tap_sip_api_sequence, dfx_tap_virtual_sequencer)
  // JtagBfmSequencer

  function new(string n = "dfx_tap_sip_api_sequence");
    super.new(n);
  endfunction : new

  task body();
    $display("Real time: %0t", $realtime);
    Reset(2'b01);
    $display("Real time: %0t", $realtime);
    Reset(2'b00);
    $display("Real time: %0t", $realtime);
    `ovm_info(get_type_name(), "Before 11ns delay", OVM_NONE)
    #11ns;
    `ovm_info(get_type_name(), "After 11ns delay", OVM_NONE)
    $display("Real time: %0t", $realtime);
    Reset(2'b01);
    $display("Real time: %0t", $realtime);
    `ovm_info(get_type_name(), "Delaying 10 ns", OVM_NONE)
    #10ns;
    $display("Real time: %0t", $realtime);
    Reset(2'b10);
    $display("Real time: %0t", $realtime);
    `ovm_info(get_type_name(), "Delaying 11 ns", OVM_NONE)
    #11ns;
    $display("Real time: %0t", $realtime);
    Reset(2'b01);
    $display("Real time: %0t", $realtime);
    `ovm_info(get_type_name(), "Delaying 13 ns", OVM_NONE)
    #13ns;
    $display("Real time: %0t", $realtime);
    Reset(2'b11);
    $display("Real time: %0t", $realtime);
  endtask : body

endclass : dfx_tap_sip_api_sequence

class dfx_tap_sip_api_sequence_virt extends ovm_sequence;
  `ovm_sequence_utils(dfx_tap_sip_api_sequence_virt, dfx_tap_virtual_sequencer)

  function new (string n = "dfx_tap_sip_api_sequence_virt");
    super.new(n);
  endfunction : new

  task body;
    dfx_tap_sip_api_sequence seq;
    dfx_tap_enable_sequence enblseq;

    `ovm_create(enblseq)
    enblseq.enable_tap[STAP12] = TAP_PORT_P0;
    `ovm_send(enblseq)

    `ovm_do_with(seq, {my_port == TAP_PORT_P0;})

    `ovm_create(enblseq)
    enblseq.enable_tap[STAP28] = TAP_PORT_P1;
    `ovm_send(enblseq)

    `ovm_do_with(seq, {my_port == TAP_PORT_P1;})
  endtask : body

endclass : dfx_tap_sip_api_sequence_virt

`endif // `ifndef DFX_TAP_SIP_API_SEQUENCE_SV
