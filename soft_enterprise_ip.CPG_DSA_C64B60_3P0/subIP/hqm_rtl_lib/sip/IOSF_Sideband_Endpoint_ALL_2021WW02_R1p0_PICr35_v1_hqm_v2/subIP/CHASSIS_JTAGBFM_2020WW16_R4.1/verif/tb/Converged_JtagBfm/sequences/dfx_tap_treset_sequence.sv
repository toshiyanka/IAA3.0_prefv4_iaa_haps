// =====================================================================================================
// FileName          : dfx_tap_treset_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri Oct 31 11:22:25 CDT 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP Treset sequence
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_TRESET_SEQUENCE_SV
`define DFX_TAP_TRESET_SEQUENCE_SV

class dfx_tap_treset_sequence extends ovm_sequence;

  `ovm_sequence_utils(dfx_tap_treset_sequence, dfx_tap_virtual_sequencer)

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/
  rand int tms_cycles = 5; // number of TCK cycles to hold TMS high (0 if TRESET is not through TMS)
  rand bit assert_treset = 1; // whether or not to assert TRST when tms_cycles > 0 (1 to assert)
  rand dfx_tap_port_e port = TAP_PORT_P0; // port for the TRESET
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/

  dfx_tap_network tn;

  function new(string name = "dfx_tap_treset_sequence");
    super.new(name);

    tn = dfx_tap_network::get_handle();
  endfunction : new

  task body();
    dfx_tap_tms_tap_transaction ttt;

    `ovm_info(get_type_name(), "TAP network before Treset:", OVM_NONE)
    tn.print();

    `ovm_do_on_with(ttt, p_sequencer.tap_seqr_array[port], {ts == DFX_TAP_TS_TLR; assert_trst == assert_treset; tms_in.size == tms_cycles; tdi_in.size == tms_cycles; foreach (tms_in[i]) tms_in[i] == 1'b1; foreach (tdi_in[i]) tdi_in[i] == 1'b0;})

    tn.set_initial_state_trst;

    `ovm_info(get_type_name(), "TAP network after Treset:", OVM_NONE)
    tn.print();

  endtask : body

endclass : dfx_tap_treset_sequence

`endif // `ifndef DFX_TAP_TRESET_SEQUENCE_SV
