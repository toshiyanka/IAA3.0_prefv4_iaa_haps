// =====================================================================================================
// FileName          : JtagBfmSoCTapNwSequences.sv
// Primary Contact   : psharm3
// Secondary Contact :
// Creation Date     : Sat Apr  9 23:02:59 CDT 2016
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Base class for SEG network type API sequences.
// Compatibility layer for Austin TAP TB.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================


//------------------------------------------------------------------------------

`ifndef JTAGBFMSOCTAPNWSEQUENCES_SV
`define JTAGBFMSOCTAPNWSEQUENCES_SV

class JtagBfmSoCTapNwSequences extends JtagBfmSequences;

  `ovm_sequence_utils(JtagBfmSoCTapNwSequences, JtagBfmSequencer)

  dfx_tap_network tap_nw;

  function new(string name = "JtagBfmSoCTapNwSequences");
    tap_nw = dfx_tap_network::get_handle;
  endfunction : new

  // Enable a TAP on port P0
  //
  task EnableTap(input dfx_tap_unit_e Tap = dfx_tap_unit_e'(0));
    dfx_tap_enable_sequence enblseq;
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (!tap_nw.tap_configured(Tap, port, state)) begin
      `ovm_error(get_type_name(), {"Tap ", Tap.name(), " is not configured in DUT"})
      return;
    end

    `ovm_create(enblseq)
    enblseq.enable_tap[Tap] = TAP_PORT_P0;
    `ovm_send(enblseq)

  endtask : EnableTap

  // Place a TAP in Isolated state
  //
  task DisableTap(input dfx_tap_unit_e Tap = dfx_tap_unit_e'(0));
    dfx_tap_disable_sequence dsblseq;
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (!tap_nw.tap_configured(Tap, port, state)) begin
      `ovm_error(get_type_name(), {"Tap ", Tap.name(), " is not configured in DUT"})
      return;
    end

    `ovm_create(dsblseq)
    dsblseq.disable_tap[Tap] = TAP_STATE_ISOLATED;
    `ovm_send(dsblseq)

  endtask : DisableTap

  // Place a TAP on the secondary port
  //
  task PutTapOnSecondary(input dfx_tap_unit_e Tap);
    dfx_tap_enable_sequence enblseq;
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (!tap_nw.tap_configured(Tap, port, state)) begin
      `ovm_error(get_type_name(), {"Tap ", Tap.name(), " is not configured in DUT"})
      return;
    end

    `ovm_create(enblseq)
    enblseq.enable_tap[Tap] = TAP_PORT_P1;
    `ovm_send(enblseq)

  endtask : PutTapOnSecondary

  // Return IR size of a TAP
  //
  function int Get_IR_Width(input Tap_t Tap);
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (!tap_nw.tap_configured(Tap, port, state)) begin
      `ovm_error(get_type_name(), {"Tap ", Tap.name(), " is not configured in DUT"})
      return 0;
    end

    return tap_nw.tap_array[port][Tap].tap_handle.IR_length;
  endfunction : Get_IR_Width

  // Enable a TAP, scan in an IR/DR pair, and return the scanned out data
  //
  task TapAccess(input dfx_tap_unit_e Tap = dfx_tap_unit_e'(0),
                 input [API_SIZE_OF_IR_REG-1:0] Opcode = 0,
                 input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
                 input int ShiftLength = 0,
                 input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
                 input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
                 input bit EnUserDefinedShiftLength = 0,
                 input bit EnRegisterPresenceCheck = 1,
                 output bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo);

    dfx_tap_enable_sequence enblseq;
    tap_ir_t opcode = tap_ir_t'(Opcode);
    dfx_tap_port_e port;
    dfx_tap_state_e state;
    dfx_tap_single_tap_transaction stt;
    bit [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;

    if (!tap_nw.tap_configured(Tap, port, state)) begin
      `ovm_error(get_type_name(), {"Tap ", Tap.name(), " is not configured in DUT"})
      return;
    end

    if (!EnUserDefinedShiftLength)
      ShiftLength = tap_nw.tap_array[port][Tap].tap_handle.dr_length(opcode); // 0 if undefined

    `ovm_create(enblseq)
    enblseq.enable_tap[Tap] = TAP_PORT_P0;
    `ovm_send(enblseq)

    ary = {<< {ShiftIn}};
    ary = new[ShiftLength](ary);

    `ovm_do_on_with(stt, p_sequencer.tap_seqr_array[port],
                    {tap_u == Tap; ir_in == opcode;
                     foreach (ary[i]) dr_in [i] == ary[i];})

    tdo_data = {<< {stt.ttd_out}};
    compare_tdo(ExpectedData, CompareMask, ShiftLength, tdo_data);

    `ovm_info(get_type_name(), "TapAccess Calling RUTI (kind of) ...", OVM_MEDIUM);
  endtask : TapAccess

endclass : JtagBfmSoCTapNwSequences

`endif // JTAGBFMSOCTAPNWSEQUENCES_SV

