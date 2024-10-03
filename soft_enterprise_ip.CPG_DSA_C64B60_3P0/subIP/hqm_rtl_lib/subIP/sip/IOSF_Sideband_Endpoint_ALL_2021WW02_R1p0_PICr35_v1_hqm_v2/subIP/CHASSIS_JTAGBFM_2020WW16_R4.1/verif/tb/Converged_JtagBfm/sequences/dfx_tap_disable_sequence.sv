// =====================================================================================================
// FileName          : dfx_tap_disable_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri Oct  1 13:48:41 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP Configuration sequence - Disable TAPs (place them in Excluded or Isolated mode without changing their ports)
//
// Before running this sequence, all TAPs must be in RTI state.
// After running this sequence, all TAPs are in RTI state.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_DISABLE_SEQUENCE_SV
`define DFX_TAP_DISABLE_SEQUENCE_SV

class dfx_tap_disable_sequence extends ovm_sequence;

  `ovm_sequence_utils_begin(dfx_tap_disable_sequence, dfx_tap_virtual_sequencer)
  `ovm_sequence_utils_end

  ovm_verbosity my_verbosity = OVM_LOW;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/
  rand dfx_tap_state_e disable_tap[dfx_tap_unit_e];
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/

  ciq_t tpqa[dfx_tap_unit_e]; // slave "TAP-port-state queue" array indexed by TAP

  function new(string name = "dfx_tap_disable_sequence");
    super.new(name);
  endfunction : new

  function void do_print(ovm_printer printer);
    dfx_tap_unit_e tap_u;

    /*
     if (my_verbosity < OVM_HIGH)
      return;
     */

    super.do_print(printer);

    printer.print_array_header("disable_tap array", disable_tap.size());
    foreach (disable_tap[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      printer.print_string($psprintf("disable_tap[%s]", tap_u.name()), disable_tap[tu_i].name());
    end
    printer.print_array_footer();

  endfunction : do_print

  function bit ok_to_disable(dfx_tap_unit_e h, dfx_tap_port_e hmp);
    dfx_tap_network tn = dfx_tap_network::get_handle();
    bit result = 1'b1; // default is to disable
    cfg_item_s ci;
    ciq_t ciq_tmp;

    if (tpqa.exists(h))
      // TAP "h" has slave TAPs that need disabling.
      if (tn.r_tap_configured(h, ci.ci_port, ci.ci_state))
        if (hmp != ci.ci_port)
          result = 1'b0; // disabling master and slave requires synchronization
        else begin
          ciq_tmp = tpqa[h];

          for (int i = 0; i < ciq_tmp.size() && result; i++)
            if (tn.r_tap_configured(ciq_tmp[i].ci_tap, ci.ci_port, ci.ci_state) && ciq_tmp[i].ci_state != ci.ci_state)
              // TAP must need to be disabled.
              result &= ok_to_disable(ciq_tmp[i].ci_tap, hmp);
        end
    // else TAP can be disabled since it has no slave TAPs that need disabling

    return result;

  endfunction : ok_to_disable

  local function void add_b(dfx_tap_multiple_taps_sequence myseq, dfx_tap_unit_e tap_u);
    dfx_tap_multiple_taps_sequence_b b;

    if ($cast(b, myseq)) begin
      b.ir_name[tap_u] = "TAPC_SELECT"; // FIXME: eliminate hardcoding
      b.raw_mode_tap = NUM_TAPS;
    end
  endfunction : add_b

  task body();
    dfx_tap_unit_e tap_u, tap_u2;
    dfx_tap_network tn = dfx_tap_network::get_handle();
    cfg_item_s ci;
    ciq_t ciq_tmp;
    int iter_num, endless, wait_cycs;
    bit state_change;
    dfx_tap_state_e state_changed[dfx_tap_unit_e];
    tap_ir_t ir;
    dfx_node_t dr[];
    dfx_tap_multiple_taps_sequence myseq;
    dfx_tap_tms_tap_transaction tms_tr;

    if (!$cast(my_verbosity, p_sequencer.get_report_verbosity_level()))
      `ovm_fatal(get_type_name(), "OVM verbosity not a valid enum value")

    // `ovm_info(get_type_name(), "TAP network before reconfiguration:", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network before reconfiguration:", OVM_NONE)
    // if (p_sequencer.get_report_verbosity_level() >= OVM_HIGH)
    tn.print();

    // TAP network can be mixed hierarchical and linear.

    foreach (disable_tap[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      if (!tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state))
        `ovm_error(get_type_name(), $psprintf("TAP %s being disabled is not configured in the DUT", tap_u.name()))

      if (disable_tap[tu_i] != TAP_STATE_EXCLUDED && disable_tap[tu_i] != TAP_STATE_ISOLATED)
        `ovm_error(get_type_name(), $psprintf("TAP %s being disabled can only be EXCLUDED/ISOLATED", tap_u.name()))

      if (tn.tap_tree[tap_u].w_tap)
        `ovm_error(get_type_name(), $psprintf("TAP %s is a WTAP and cannot be disabled using this sequence", tap_u.name()))

      if (tn.tap_tree[tap_u].mode)
        `ovm_error(get_type_name(), $psprintf("Cannot directly disable dependant TAP %s", tap_u.name()))

      if (ci.ci_state == disable_tap[tap_u]) begin
        `ovm_info(get_type_name(),
                  $psprintf("TAP %s is already disabled (in the desired state); nothing to do", tap_u.name()),
                  // OVM_HIGH)
                  OVM_NONE)
        continue; // nothing to do
      end

      if (tn.tap_tree[tap_u].master_tap == tap_u) begin
        `ovm_error(get_type_name(), $psprintf("Root TAP %s state cannot be changed using this sequence", tap_u.name))
        break;
      end

      if (!tn.r_tap_configured(tn.tap_tree[tap_u].master_tap, ci.ci_port, ci.ci_state) || ci.ci_state != TAP_STATE_NORMAL)
        `ovm_error(get_type_name(),
                   $psprintf("TAP %s's master TAP %s not configured/normal", tap_u.name(), tn.tap_tree[tap_u].master_tap.name()))

      void'(tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state));
      ci.ci_tap = tap_u;
      ci.ci_state = disable_tap[tap_u];

      tpqa[tn.tap_tree[tap_u].master_tap].push_back(ci);

    end

    // For each TAP required to issue configuration instructions/data, make a complete list of all sub-TAPs with the
    // required action.
    //
    foreach (tpqa[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      tpqa[tap_u].sort() with (item.ci_tap);

      // `ovm_info(get_type_name(), $psprintf("TAP %s needs to disable (exclude/isolate) these TAPS:", tap_u.name()), OVM_HIGH)
      `ovm_info(get_type_name(), $psprintf("TAP %s needs to disable (exclude/isolate) these TAPS:", tap_u.name()), OVM_NONE)
      for (int i = 0; i < tpqa[tap_u].size(); i++)
        `ovm_info(get_type_name(),
                  $psprintf("  TAP: %s, Port: %s, State: %s", tpqa[tap_u][i].ci_tap.name(), tpqa[tap_u][i].ci_port.name(),
                            tpqa[tap_u][i].ci_state.name()),
                  // OVM_HIGH)
                  OVM_NONE)

      for (int i = 0; i < tn.tap_tree[tap_u].s_taps.size(); i++) begin
        tap_u2 = dfx_tap_unit_e'(tn.tap_tree[tap_u].s_taps[i]);

        if (i >= tpqa[tap_u].size() || tap_u2 != tpqa[tap_u][i].ci_tap) begin
          if (!tn.r_tap_configured(tap_u2, ci.ci_port, ci.ci_state)) begin
            // Child/slave TAP is not in the DUT.  However, its data bits must still be included in the data bits for
            // the TAP.
            ci.ci_port = TAP_PORT_P0; // some port - choose default port
            ci.ci_state = TAP_STATE_ISOLATED; // some state - choose default state for an unconfigured TAP
          end
          ci.ci_tap = tap_u2;
          tpqa[tap_u].insert(i, ci);
        end
      end

      // If tpqa[tap_u] has some "junk" (WTAP) TAPS which caused an OVM_ERROR above, those TAPs still remain!
      // Ensure tpqa[tap_u].size() == tn.tap_tree[tap_u].s_taps.size()?
    end

    foreach (tpqa[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      // `ovm_info(get_type_name(), $psprintf("TAP %s full disable list:", tap_u.name()), OVM_HIGH)
      `ovm_info(get_type_name(), $psprintf("TAP %s full disable list:", tap_u.name()), OVM_NONE)
      for (int i = 0; i < tpqa[tap_u].size(); i++)
        `ovm_info(get_type_name(),
                  $psprintf("  Sub-TAP: %s, Port: %s, State: %s", tpqa[tap_u][i].ci_tap.name(), tpqa[tap_u][i].ci_port.name(),
                            tpqa[tap_u][i].ci_state.name()),
                  // OVM_HIGH)
                  OVM_NONE)
    end

    // Now create IR/DR sequences for each TAP.
    //
    // In any one given sequence used to disable a number of TAPs, a TAP, say TAP_x, can be disabled (excluded or
    // isolated) iff:
    // (1) TAP_x has no slave TAPs that need to be disabled; OR, failing that:
    // (2) (TAP_x has slave TAPs that need to be disabled) TAP_x is on the same port as its master TAP, and all of TAP_x's
    //     slave TAPs that need to be disabled can be disabled using this same definition.
    //
    // TAPs cannot be disabled in parallel on different ports because for a linear TAP sub-network, there may be TAP
    // "control" dependencies between the ports.

    iter_num = 0;
    endless = tpqa.num() + 1;

    while (tpqa.num()) begin

      if (tpqa.num() >= endless)
        `ovm_fatal(get_type_name(), "Internal TB error: Endless loop")
      else begin
        endless = tpqa.num();
        iter_num ++;
      end

      for (dfx_tap_port_e port_i = port_i.first(); port_i != p_sequencer.TapNumPorts; port_i = port_i.next()) begin

        if (!tpqa.num())
          break;

        wait_cycs = 0;

        `ovm_create_on(myseq, p_sequencer.tap_seqr_array[port_i])

        if (state_changed.num() > 0)
          state_changed.delete();

        foreach (tpqa[tu_i]) begin
          tap_u = dfx_tap_unit_e'(tu_i);

          // if (!tn.check_tap(tap_u, port_i, TAP_STATE_NORMAL))
          if (!tn.r_check_tap(tap_u, port_i, TAP_STATE_NORMAL))
            continue;

          if (ok_to_disable(tap_u, port_i)) begin
            ciq_tmp = tpqa[tap_u];

            state_change = 1'b0;
            for (int i = 0; i < ciq_tmp.size(); i++)
              if (tn.r_tap_configured(ciq_tmp[i].ci_tap, ci.ci_port, ci.ci_state))
                if (ciq_tmp[i].ci_state != ci.ci_state) begin
                  state_change = 1'b1;
                  state_changed[ciq_tmp[i].ci_tap] = ciq_tmp[i].ci_state;
                end

            if (state_change) begin
              tn.tap_array[port_i][tap_u].tap_handle.get_state_change_ir_dr(ciq_tmp, ir, dr);
              `ovm_info(get_type_name(),
                        $psprintf("For state change, TAP %s will issue instruction 'h%0h and data stream %0d%s",
                                  tap_u.name(), ir, dr.size(), dfx_tap_util::writeh(dr)),
                        // OVM_HIGH)
                        OVM_NONE)
              myseq.seq_ir_in[tap_u] = ir;
              myseq.seq_dr_in[tap_u] = dr;
              add_b(myseq, tap_u); // account for a/b differences
            end

            // `ovm_info(get_type_name(), "myseq (for state changes) so far:", OVM_FULL)
            `ovm_info(get_type_name(), "myseq (for state changes) so far:", OVM_NONE)
            // if (my_verbosity >= OVM_FULL)
            myseq.print();

            if (tn.tap_array[port_i][tap_u].tap_handle.wait_cycles > wait_cycs)
              wait_cycs = tn.tap_array[port_i][tap_u].tap_handle.wait_cycles;

            tpqa.delete(tap_u); // done with this TAP
          end
        end

        `ovm_info(get_type_name(),
                  $psprintf("On iteration %0d, TAPs on port %s need to disable these TAPS:", iter_num, port_i.name()),
                  // OVM_HIGH)
                  OVM_NONE)
        foreach (state_changed[tu_i]) begin
          tap_u = dfx_tap_unit_e'(tu_i);

          // `ovm_info(get_type_name(), $psprintf("  Sub-TAP %s, State %s", tap_u.name(), state_changed[tap_u].name()), OVM_HIGH)
          `ovm_info(get_type_name(), $psprintf("  Sub-TAP %s, State %s", tap_u.name(), state_changed[tap_u].name()), OVM_NONE)
        end

        // Issue TAP transactions for this port, if needed.

        if (myseq.seq_ir_in.num) begin
          `ovm_info(get_type_name(),
                    $psprintf("On iteration %0d, final myseq (for state changes) on port %s:", iter_num, port_i.name()),
                    // OVM_FULL)
                    OVM_NONE)
          // if (m_sequencer.get_report_verbosity_level() >= OVM_FULL)
          myseq.print();

          `ovm_send(myseq)

          // Check result?  A checker should do it.

          // `ovm_info(get_type_name(), "Completed myseq sequence:", OVM_FULL)
          `ovm_info(get_type_name(), "Completed myseq sequence:", OVM_NONE)
          // if (my_verbosity >= OVM_FULL)
          myseq.print();

          // Add wait cycles here?
          `ovm_do_on_with(tms_tr, p_sequencer.tap_seqr_array[port_i],
                          {assert_trst == 1'b0; ts == DFX_TAP_TS_RTI;
                           tms_in.size() == wait_cycs; foreach (tms_in[i]) tms_in[i] == 1'b0;})

          if (!state_changed.num())
            `ovm_fatal(get_type_name(),
                       $psprintf("Internal TB error: state_changed array unexpectedly empty on iteration %0d, on port %s",
                                 iter_num, port_i.name()))

          foreach (state_changed[tu_i]) begin
            tap_u = dfx_tap_unit_e'(tu_i);

            if (!tn.change_tap_state(tap_u, state_changed[tap_u]))
              `ovm_error(get_type_name(), "Could not change state in TAP network")
          end

          // `ovm_info(get_type_name(), "TAP network changed:", OVM_HIGH)
          `ovm_info(get_type_name(), "TAP network changed:", OVM_NONE)
          // if (my_verbosity >= OVM_HIGH)
          tn.print();
        end
      end
    end

    // `ovm_info(get_type_name(), "TAP network after reconfiguration:", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network after reconfiguration:", OVM_NONE)
    // if (my_verbosity >= OVM_HIGH)
    tn.print();

  endtask : body

endclass : dfx_tap_disable_sequence

`endif // `ifndef DFX_TAP_DISABLE_SEQUENCE_SV
