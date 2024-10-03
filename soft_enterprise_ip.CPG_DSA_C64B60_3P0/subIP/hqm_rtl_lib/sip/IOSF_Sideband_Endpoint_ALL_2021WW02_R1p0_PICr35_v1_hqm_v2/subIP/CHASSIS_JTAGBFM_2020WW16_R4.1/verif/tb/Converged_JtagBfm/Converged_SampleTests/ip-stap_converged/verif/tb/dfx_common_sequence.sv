// =====================================================================================================
// FileName          : dfx_common_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Apr 27 11:35:24 CDT 2011
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Base class for TAP sequences.  Can be used as a base class by any DFx sequence.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_COMMON_SEQUENCE_SV
`define DFX_COMMON_SEQUENCE_SV

virtual class dfx_common_sequence #(type T = ovm_sequence_item) extends JtagBfmSequences #(T);

  function new(string name = "dfx_common_sequence");
    super.new(name);
  endfunction : new

  virtual function string get_type_name();
    return "dfx_common_sequence";
  endfunction : get_type_name

  function tap_ir_t idcode_opcode(dfx_tap_unit_e tap);
    dfx_tap_network tap_nw = dfx_tap_network::get_handle;
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (tap_nw.tap_configured(tap, port, state))
      idcode_opcode = tap_nw.tap_array[port][tap].tap_handle.idcode_opcode;
    else begin
      `ovm_error(get_type_name(), $psprintf("TAP %s is not configured in DUT", tap.name()))
      // idcode_opcode = tap_ir_t'(x);
    end
  endfunction : idcode_opcode

  function dfx_node_t[31:0] idcode_value(dfx_tap_unit_e tap);
    dfx_tap_network tap_nw = dfx_tap_network::get_handle;
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (tap_nw.tap_configured(tap, port, state))
      idcode_value = tap_nw.tap_array[port][tap].tap_handle.idcode_value;
    else begin
      `ovm_error(get_type_name(), $psprintf("TAP %s is not configured in DUT", tap.name()))
      // idcode_value = 32'hx;
    end
  endfunction : idcode_value

  function string tap_security(dfx_tap_unit_e tap);
    dfx_tap_network tap_nw = dfx_tap_network::get_handle;
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (tap_nw.tap_configured(tap, port, state))
      tap_security = tap_nw.tap_array[port][tap].tap_handle.tap_security;
    else begin
      `ovm_error(get_type_name(), $psprintf("TAP %s is not configured in DUT", tap.name()))
      // idcode_value = 32'hx;
    end
  endfunction : tap_security

  class check #(int SIZE = 32);

    static function void check_value(string what, dfx_node_t [SIZE - 1 : 0] actual, expected);
      if (actual !== expected)
        // `ovm_error(get_type_name(),
        `ovm_error("dfx_common_sequence",
                   $psprintf("Fail - %s - Expected %0d'h%0h, actual %0d'h%0h", what, SIZE, expected, SIZE, actual))
      else
        // `ovm_info(get_type_name(),
        `ovm_info("dfx_common_sequence",
                  $psprintf("Success - %s - Expected %0d'h%0h, actual %0d'h%0h", what, SIZE, expected, SIZE, actual),
                  OVM_NONE)

    endfunction : check_value
  endclass : check

  typedef check check32; // check #(32)
  typedef check #(64) check64;

  typedef check #(`MAX_TAP_INSTR_LENGTH) checkIR;

endclass : dfx_common_sequence

`endif // `ifndef DFX_COMMON_SEQUENCE_SV
