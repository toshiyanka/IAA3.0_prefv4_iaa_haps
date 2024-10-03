// =====================================================================================================
// FileName          : dfx_tap_remove_tap_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri Nov 26 19:40:05 CST 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP Remove sequence
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_REMOVE_TAP_SEQUENCE_SV
`define DFX_TAP_REMOVE_TAP_SEQUENCE_SV

class dfx_tap_remove_tap_sequence extends ovm_sequence;

  `ovm_sequence_utils_begin(dfx_tap_remove_tap_sequence, dfx_tap_virtual_sequencer)
  `ovm_sequence_utils_end

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/
  int wait_cycles = 3; // number of TCK cycles to wait after removing a TAP (per standard)
  dfx_tap_port_e taps2rm[dfx_tap_unit_e]; // TAPs to remove
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/

  dfx_tap_network tn;

  function new(string name = "dfx_tap_remove_tap_sequence");
    super.new(name);

    tn = dfx_tap_network::get_handle();
  endfunction : new

  task body();
    tap_ir_t ir;
    dfx_tap_unit_e tap;
    dfx_tap_port_e port;
    dfx_tap_multiple_taps_sequence myseq[dfx_tap_port_e];

    // `ovm_info(get_type_name(), "TAP network before removing TAP(s):", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network before removing TAP(s):", OVM_NONE)
    // if (m_sequencer.get_report_verbosity_level() >= OVM_HIGH)
    tn.print();

    foreach (taps2rm[tu]) begin
      cfg_item_s ci;

      tap = dfx_tap_unit_e'(tu);
      port = taps2rm[tap];

      if (!tn.tap_configured(tap, ci.ci_port, ci.ci_state)) begin
        `ovm_error(get_type_name(), $psprintf("%s is not configured in the TAP network - was it removed already?", tap.name()))
        continue;
      end

      if (tn.tap_tree[tap].w_tap)
        `ovm_error(get_type_name(), $psprintf("TAP %s is a WTAP and cannot be removed", tap.name()))

      if (tn.tap_tree[tap].mode)
        `ovm_error(get_type_name(), $psprintf("Cannot directly remove dependant TAP %s", tap.name()))

      if (taps2rm[tap] != ci.ci_port) begin
        `ovm_error(get_type_name(), {"TAP ", tap.name, " is on port ", ci.ci_port.name, " and not port ", taps2rm[tap].name})
        continue;
      end

      if (ci.ci_state != TAP_STATE_NORMAL) begin
        `ovm_error(get_type_name(), $psprintf("TAP %s is not (effectively) in Normal state and cannot be removed", tap.name()))
        continue;
      end

      ir = tn.tap_array[port][tap].tap_handle.opcode_value("TAPC_REMOVE");

      if (!myseq.exists(port))
        `ovm_create_on(myseq[port], p_sequencer.tap_seqr_array[port])

      myseq[port].seq_ir_in[tap] = ir;
      myseq[port].seq_dr_in[tap] = new[1];
      myseq[port].seq_dr_in[tap][0] = 1'b1;
    end

    // Print and issue TAP transactions in parallel.
    foreach (myseq[port_i]) begin
      port = dfx_tap_port_e'(port_i);

      // `ovm_info(get_type_name(), $psprintf("myseq[%s]:", port.name()), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("myseq[%s]:", port.name()), OVM_NONE)
      // if (p_sequencer.get_report_verbosity_level() >= OVM_FULL)
      myseq[port].print();

      fork
        dfx_tap_port_e portt = port;
        dfx_tap_tms_tap_transaction tms_tr;

        begin
          `ovm_send(myseq[portt])
          `ovm_do_on_with(tms_tr, p_sequencer.tap_seqr_array[portt],
                          {assert_trst == 1'b0; ts == DFX_TAP_TS_RTI;
                           tms_in.size() == wait_cycles; foreach (tms_in[i]) tms_in[i] == 1'b0;})
        end
      join_none
    end

    wait fork;

    // Check result?  A checker should do it.

    foreach (myseq[port_i]) begin
      port = dfx_tap_port_e'(port_i);

      // `ovm_info(get_type_name(), $psprintf("Completed myseq[%s]:", port.name()), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("Completed myseq[%s]:", port.name()), OVM_NONE)
      // if (p_sequencer.get_report_verbosity_level() >= OVM_FULL)
      myseq[port].print();
    end

    foreach (taps2rm[tu]) begin
      tap = dfx_tap_unit_e'(tu);

      if (myseq.exists(taps2rm[tap]) && myseq[taps2rm[tap]].seq_ir_in.exists(tap))
        if (!tn.remove_tap(tap))
          `ovm_error(get_type_name(), {"Could not remove TAP ", tap.name, " from TAP network"})
    end

    // `ovm_info(get_type_name(), "TAP network after removing TAP(s):", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network after removing TAP(s):", OVM_NONE)
    // if (p_sequencer.get_report_verbosity_level() >= OVM_HIGH)
    tn.print();

  endtask : body

endclass : dfx_tap_remove_tap_sequence

`endif // `ifndef DFX_TAP_REMOVE_TAP_SEQUENCE_SV
