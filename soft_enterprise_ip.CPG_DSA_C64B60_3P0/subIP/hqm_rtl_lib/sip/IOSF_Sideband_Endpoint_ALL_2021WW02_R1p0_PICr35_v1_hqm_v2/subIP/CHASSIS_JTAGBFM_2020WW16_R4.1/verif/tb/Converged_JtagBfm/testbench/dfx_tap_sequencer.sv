// =====================================================================================================
// FileName          : dfx_tap_sequencer.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Jun  2 12:55:29 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP Sequencer
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_SEQUENCER_SV
`define DFX_TAP_SEQUENCER_SV

class dfx_tap_sequencer extends ovm_sequencer #(dfx_tap_base_transaction);

  dfx_tap_port_e port;

  `ovm_sequencer_utils_begin(dfx_tap_sequencer)
    `ovm_field_enum(dfx_tap_port_e, port, OVM_DEFAULT)
  `ovm_sequencer_utils_end

  function new(string name = "dfx_tap_sequencer", ovm_component parent = null);
    super.new(name, parent);
    `ovm_update_sequence_lib_and_item(dfx_tap_base_transaction)
    // `ovm_update_sequence_lib
  endfunction : new

endclass : dfx_tap_sequencer

class dfx_tap_virtual_sequencer extends ovm_sequencer;

  dfx_tap_port_e TapNumPorts;
  dfx_tap_sequencer tap_seqr_array[];

  `ovm_sequencer_utils_begin(dfx_tap_virtual_sequencer)
    `ovm_field_enum(dfx_tap_port_e, TapNumPorts, OVM_DEFAULT)
  `ovm_sequencer_utils_end

  function new(string name = "dfx_tap_virtual_sequencer", ovm_component parent = null);
    super.new(name, parent);
    `ovm_update_sequence_lib
  endfunction : new

  function void build();
    super.build();

    if (TapNumPorts <= 0)
      `ovm_fatal(get_type_name(), "TapNumPorts value is 0")

    tap_seqr_array = new[TapNumPorts]; // one sequencer per port
  endfunction : build

endclass : dfx_tap_virtual_sequencer

// SIP JTAG BFM compatibility sequencer
//
class JtagBfmSequencer extends dfx_tap_virtual_sequencer;

  `ovm_sequencer_utils(JtagBfmSequencer)

  function new(string name = "JtagBfmSequencer", ovm_component parent = null);
    super.new(name, parent);
    // `ovm_update_sequence_lib // defer to dfx_tap_virtual_sequencer
  endfunction : new

endclass : JtagBfmSequencer

`endif // `ifndef DFX_TAP_SEQUENCER_SV
