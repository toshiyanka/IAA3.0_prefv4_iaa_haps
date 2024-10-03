// =====================================================================================================
// FileName          : dfx_tap_powergood_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon May 16 15:51:45 CDT 2011
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP PowerGood sequence
//
// This sequence does not assert PowerGood, but takes care of all TAP related states
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_POWERGOOD_SEQUENCE_SV
`define DFX_TAP_POWERGOOD_SEQUENCE_SV

class dfx_tap_powergood_sequence extends ovm_sequence;

  `ovm_sequence_utils(dfx_tap_powergood_sequence, dfx_tap_virtual_sequencer)

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/
  // rand int wait_cycles; // number of TCK cycles to wait after PowerGood
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/

  dfx_tap_network tn;

  function new(string name = "dfx_tap_powergood_sequence");
    super.new(name);

    tn = dfx_tap_network::get_handle();
  endfunction : new

  task body();
    dfx_tap_powergood_transaction pgt[];

    // `ovm_info(get_type_name(), "TAP network before PowerGood:", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network before PowerGood:", OVM_NONE)
    // if (p_sequencer.get_report_verbosity_level() >= OVM_HIGH)
    tn.print();

    pgt = new[p_sequencer.TapNumPorts];

    // Issue PowerGood TAP transactions for all ports in parallel.
    foreach (pgt[port_i]) begin
      dfx_tap_port_e port = dfx_tap_port_e'(port_i);

      // `ovm_info(get_type_name(), $psprintf("Issuing PowerGood transaction for port %s", port.name()), OVM_HIGH)
      `ovm_info(get_type_name(), $psprintf("Issuing PowerGood transaction for port %s", port.name()), OVM_NONE)

      fork
        dfx_tap_port_e portt = port;

        `ovm_do_on(pgt[portt], p_sequencer.tap_seqr_array[portt])
      join_none
    end

    wait fork;

    // Check result?  A checker should do it.

    tn.set_initial_state;
    // `ovm_info(get_type_name(), "TAP network after PowerGood:", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network after PowerGood:", OVM_NONE)
    // if (p_sequencer.get_report_verbosity_level() >= OVM_HIGH)
    tn.print();

  endtask : body

endclass : dfx_tap_powergood_sequence

`endif // `ifndef DFX_TAP_POWERGOOD_SEQUENCE_SV
