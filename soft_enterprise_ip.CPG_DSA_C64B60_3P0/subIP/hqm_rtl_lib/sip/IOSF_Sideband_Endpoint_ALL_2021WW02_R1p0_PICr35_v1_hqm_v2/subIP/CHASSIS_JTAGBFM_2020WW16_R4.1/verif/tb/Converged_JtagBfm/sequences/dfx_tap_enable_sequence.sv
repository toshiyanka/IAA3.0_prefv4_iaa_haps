// =====================================================================================================
// FileName          : dfx_tap_enable_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Tue Jul 27 17:58:07 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP Configuration sequence - Enable TAPs (place them in Normal mode on the specified ports)
//
// Before running this sequence, all TAPs must be in RTI state.
// After running this sequence, all TAPs are in RTI state.
//
// Treatment of hybrid TAPs satisfies all requirements, even though it is "incorrect".  For example, if
// a hybrid TAP is placed on the secondary port, and then its master is also placed on the secondary
// port, then if the master is moved back to the primary port, the hybrid TAP moves with it to the
// primary port (hierarchical behaviour).  (The state of the secondary select register in the RTL would
// continue to indicate that the hybrid TAP is on the secondary port.)  This "incorrect" behaviour is
// also present in the TAP testbench.  This is simply an outcome of the design (which has been kept
// simple).  This example is not a valid usage model, according to the standard.  (In fact, the standard
// does not define what happens in this case.)  The valid usage models of a hybrid TAP are supported
// correctly.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_ENABLE_SEQUENCE_SV
`define DFX_TAP_ENABLE_SEQUENCE_SV

class dfx_tap_enable_sequence extends ovm_sequence;

  `ovm_sequence_utils_begin(dfx_tap_enable_sequence, dfx_tap_virtual_sequencer)
  `ovm_sequence_utils_end

  ovm_verbosity my_verbosity = OVM_LOW;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/
  rand dfx_tap_port_e enable_tap[dfx_tap_unit_e];
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/

  function new(string name = "dfx_tap_enable_sequence");
    super.new(name);
  endfunction : new

  function void do_print(ovm_printer printer);
    dfx_tap_unit_e tap_u;

    /*
     if (my_verbosity < OVM_HIGH)
      return;
     */

    super.do_print(printer);

    printer.print_array_header("enable_tap array", enable_tap.size());
    foreach (enable_tap[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      printer.print_string($psprintf("enable_tap[%s]", tap_u.name()), enable_tap[tu_i].name());
    end
    printer.print_array_footer();

  endfunction : do_print

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
    ciq_t ciq_tmp,
      tpqa[dfx_tap_unit_e]; // slave "TAP-port-state queue" array indexed by TAP
    int dups[$], iter_num, endless, wait_cycs;
    bit real_port_change[dfx_tap_unit_e]; // for hybrid TAPs
    bit port_change, state_change;
    dfx_tap_port_e child_port, port_changed[dfx_tap_unit_e];
    dfx_tap_state_e state_changed[dfx_tap_unit_e];
    tap_ir_t ir;
    dfx_node_t dr[];
    dfx_tap_multiple_taps_sequence myseq1, myseq2;

    if (!$cast(my_verbosity, m_sequencer.get_report_verbosity_level()))
      `ovm_fatal(get_type_name(), "OVM verbosity not a valid enum value")

    // `ovm_info(get_type_name(), "TAP network before reconfiguration:", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network before reconfiguration:", OVM_NONE)
    // if (my_verbosity >= OVM_HIGH)
    tn.print();

    // TAP network can be mixed hierarchical and linear.

    foreach (enable_tap[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      // `ovm_info(get_type_name(), $psprintf("Processing TAP %s in enable_tap[]", tap_u.name()), OVM_FULL)

      if (!tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state))
        `ovm_error(get_type_name(), $psprintf("TAP %s being enabled is not configured in the DUT", tap_u.name()))

      if (tn.tap_tree[tap_u].w_tap)
        `ovm_error(get_type_name(), $psprintf("TAP %s is a WTAP and cannot be enabled using this sequence", tap_u.name()))

      if (tn.tap_tree[tap_u].mode)
        `ovm_error(get_type_name(), $psprintf("Cannot directly enable dependant TAP %s", tap_u.name()))

      if (tn.r_check_tap(tap_u, enable_tap[tap_u], TAP_STATE_NORMAL)) begin
        `ovm_info(get_type_name(),
                  $psprintf("TAP %s is already enabled and on port %s; nothing to do", tap_u.name(), enable_tap[tap_u].name()),
                  // OVM_HIGH)
                  OVM_NONE)
        continue; // nothing to do
      end

      ci.ci_tap = tap_u;
      ci.ci_port = enable_tap[tap_u];
      ci.ci_state = TAP_STATE_NORMAL;

      // A master is always placed on this list before any of its slave TAPs because of the implicit ordering of the
      // "enable_tap" array.  Otherwise, check for duplicates here also.
      tpqa[tn.tap_tree[tap_u].master_tap].push_back(ci);

      child_port = enable_tap[tap_u];

      /*
      if (tn.tap_tree[tap_u].hybrid)
        hybrid_port = child_port;
       */

      tap_u2 = tap_u; // save sTAP
      tap_u = tn.tap_tree[tap_u].master_tap;

      // while (!tn.tap_normal(tap_u)) begin
      while (!tn.r_tap_normal(tap_u)) begin
        // `ovm_info(get_type_name(), $psprintf("Processing master TAP %s", tap_u.name()), OVM_FULL)

        if (tn.tap_tree[tap_u].master_tap == tap_u) begin // or level == 0
          `ovm_error(get_type_name(),
                     $psprintf("Root TAP %s either not configured in the DUT, or it cannot be placed in Normal state using this sequence",
                               tap_u.name))
          break;
        end

        ci.ci_tap = tap_u;

        if (!tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state)) begin
          `ovm_error(get_type_name(), $psprintf("Inferred TAP %s being enabled is not configured in the DUT", tap_u.name()))
          break;
        end

        ci.ci_state = TAP_STATE_NORMAL;

        // Prefer to treat a hybrid TAP as a child of a hierarchical TAP.

        if (tn.tap_tree[tap_u].hierarchical) // && !tn.tap_tree[tap_u2].hybrid)
          ci.ci_port = child_port;
        else
          child_port = ci.ci_port; // for the next iteration

        dups = tpqa[tn.tap_tree[tap_u].master_tap].find_index with (item.ci_tap == ci.ci_tap);

        if (dups.size() == 0)
          tpqa[tn.tap_tree[tap_u].master_tap].push_back(ci);
        else if (dups.size == 1) begin
          // The port a master gets enabled on depends upon which child TAP gets here first - a hybrid TAP (on a
          // non-primary port) or a non-hybrid TAP (on a primary port or a different port).  In this sense, the
          // processing here is asymmetrical.  However, this sequence does not guarantee correct processing of all cases
          // involving a hybrid port.  However, it will correctly handle a hybrid TAP provided the user enables a hybrid
          // port according to the TAP standards specification.
          if (tpqa[tn.tap_tree[tap_u].master_tap][dups[0]].ci_port != ci.ci_port) begin
            if (tn.tap_tree[tap_u2].hybrid) begin
              real_port_change[tap_u2] = 1'b1;
              child_port = tpqa[tn.tap_tree[tap_u].master_tap][dups[0]].ci_port; // fix this
            end
            else
              `ovm_error(get_type_name(),
                         $psprintf("TAP %s cannot enable TAP %s on different ports", tn.tap_tree[tap_u].master_tap.name, tap_u.name))
          end
        end else // if (dups.size() > 1)
          `ovm_fatal(get_type_name(), $psprintf("tpqa corrupted for tap %s", tn.tap_tree[tap_u].master_tap.name()))

        /*
        if (tn.tap_tree[tap_u].hybrid)
          hybrid_port = child_port;
         */

        tap_u2 = tap_u; // save sTAP
        tap_u = tn.tap_tree[tap_u].master_tap;
      end

      // `ovm_info(get_type_name(), $psprintf("Exited master TAP loop, current master TAP is %s", tap_u.name()), OVM_FULL)

      // "tap_u" is either the root TAP (dealt with inside the loop above), or a slave TAP (dealt with here).

      if (!tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state))
        // Getting TAP port, but TAP is unconfigured root TAP.
        `ovm_error(get_type_name(), "Root TAP error (repeat of previous)")

      if (tn.tap_tree[tap_u].hierarchical)
        if (tn.tap_tree[tap_u2].hybrid) begin
          // Cover most possibilities, perhaps not all.
          cfg_item_s cia;

          if (!tn.r_tap_configured(tap_u2, cia.ci_port, cia.ci_state))
            `ovm_error(get_type_name(), {"TAP ", tap_u2.name, " not configured in DUT"})

          if (child_port != cia.ci_port)
            // Hybrid TAP's port needs to be changed
            if (!enable_tap.exists(tap_u) || enable_tap[tap_u] != child_port)
              real_port_change[tap_u2] = 1'b1;
        end
        else if (ci.ci_port != child_port) begin
          /*
          `ovm_info(get_type_name(), $psprintf("Master TAP %s existing port mismatch", tap_u.name()), OVM_FULL)
          `ovm_info(get_type_name(), $psprintf("Master TAP port is %s, child port is %s", ci.ci_port.name, child_port.name), OVM_FULL)

          if (enable_tap.exists(tap_u))
            `ovm_info(get_type_name(), $psprintf("Master TAP port in enable_tap array is %s", enable_tap[tap_u].name), OVM_FULL)
          else
            `ovm_info(get_type_name(), "Master TAP port is not in enable_tap array", OVM_FULL)

          if (!enable_tap.exists(tap_u))
            `ovm_info(get_type_name(), "Condition !enable_tap.exists(tap_u) is TRUE", OVM_FULL)
          else
            `ovm_info(get_type_name(), "Condition !enable_tap.exists(tap_u) is FALSE", OVM_FULL)

          if (enable_tap[tap_u] != child_port)
            `ovm_info(get_type_name(), "Condition enable_tap[tap_u] != child_port is TRUE", OVM_FULL)
          else
            `ovm_info(get_type_name(), "Condition enable_tap[tap_u] != child_port is FALSE", OVM_FULL)
          */
          // Master's port may also be getting changed.
          if (!enable_tap.exists(tap_u) || enable_tap[tap_u] != child_port)
            `ovm_error(get_type_name(),
                       $psprintf("Hierarchical TAP %s is not or will not be on same port as a child TAP being enabled", tap_u.name))
      end
    end

    // For each TAP required to issue configuration instructions/data, make a complete list of all sub-TAPs with the
    // required action.
    //
    foreach (tpqa[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      tpqa[tap_u].sort() with (item.ci_tap);

      `ovm_info(get_type_name(),
                // $psprintf("TAP %s needs to enable and/or change ports for these TAPS:", tap_u.name()), OVM_HIGH)
                $psprintf("TAP %s needs to enable and/or change ports for these TAPS:", tap_u.name()), OVM_NONE)
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
            ci.ci_port = TAP_PORT_P0; // some port - choose default port (may be better to choose the same port as the
                                      // master TAP when the master TAP is hierarchical)
            ci.ci_state = TAP_STATE_ISOLATED; // some state - choose default state for an unconfigured TAP
          end
          else if (tn.tap_tree[tap_u].hierarchical)
            `ovm_warning(get_type_name(),
                         {"TAP ", tap_u2.name, " may get moved with its hierarchical controlling TAP to another port"})

          ci.ci_tap = tap_u2;
          tpqa[tap_u].insert(i, ci);
        end
      end

      // If tpqa[tap_u] has some "junk" (WTAP) TAPS which caused an OVM_ERROR above, those TAPs still remain!
      // Ensure tpqa[tap_u].size() == tn.tap_tree[tap_u].s_taps.size()?
    end

    foreach (tpqa[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      // `ovm_info(get_type_name(), $psprintf("TAP %s full enable list:", tap_u.name()), OVM_HIGH)
      `ovm_info(get_type_name(), $psprintf("TAP %s full enable list:", tap_u.name()), OVM_NONE)
      for (int i = 0; i < tpqa[tap_u].size(); i++)
        `ovm_info(get_type_name(),
                  $psprintf("  Sub-TAP: %s, Port: %s, State: %s", tpqa[tap_u][i].ci_tap.name(), tpqa[tap_u][i].ci_port.name(),
                            tpqa[tap_u][i].ci_state.name()),
                  // OVM_HIGH)
                  OVM_NONE)
    end

    if (real_port_change.num) begin
      // `ovm_info(get_type_name(), "Note:  Hybrid TAPs with real port change:", OVM_HIGH)
      `ovm_info(get_type_name(), "Note:  Hybrid TAPs with real port change:", OVM_NONE)
      foreach (real_port_change[tu_i]) begin
        tap_u = dfx_tap_unit_e'(tu_i);

        if (tn.tap_tree[tap_u].hybrid)
          // `ovm_info(get_type_name(), {"Hybrid TAP ", tap_u.name}, OVM_HIGH)
          `ovm_info(get_type_name(), {"Hybrid TAP ", tap_u.name}, OVM_NONE)
        else
          `ovm_error(get_type_name(), {"Hybrid TAP list incorrect, contains TAP ", tap_u.name})
      end
    end

    // Now create IR/DR sequences for each TAP.

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

        bit skip = 1'b0;

        if (!tpqa.num())
          break;

        wait_cycs = 0;

        `ovm_create_on(myseq1, p_sequencer.tap_seqr_array[port_i])
        `ovm_create_on(myseq2, p_sequencer.tap_seqr_array[port_i])

        if (port_changed.num() > 0)
          port_changed.delete();

        if (state_changed.num() > 0)
          state_changed.delete();

        foreach (tpqa[tu_i]) begin
          tap_u = dfx_tap_unit_e'(tu_i);

          // if (!tn.check_tap(tap_u, port_i, TAP_STATE_NORMAL))
          if (!tn.r_check_tap(tap_u, port_i, TAP_STATE_NORMAL))
            continue;

          ciq_tmp = tpqa[tap_u];

          port_change = 1'b0;
          state_change = 1'b0;
          for (int i = 0; i < ciq_tmp.size(); i++)
            if (tn.r_tap_configured(ciq_tmp[i].ci_tap, ci.ci_port, ci.ci_state)) begin

              if (ciq_tmp[i].ci_port != ci.ci_port) begin
                if (tn.tap_tree[tap_u].hierarchical &&
                    (!tn.tap_tree[ciq_tmp[i].ci_tap].hybrid || !real_port_change.exists(ciq_tmp[i].ci_tap)))
                  // "tap_u", the master of "ciq_tmp[i].ci_tap", should be on the same port, i.e., port "ci.ci_port".
                  // Therefore, this port change will work only if the master TAP is also being moved to the same port.
                  // The validity/legality of port changes for TAPs has already been checked above, so there's no need
                  // to check again.
                  `ovm_info(get_type_name(), $psprintf("Hierarchical TAP %s will not change slave TAP %s port directly",
                                                       // tap_u.name, ciq_tmp[i].ci_tap.name), OVM_HIGH)
                                                       tap_u.name, ciq_tmp[i].ci_tap.name), OVM_NONE)
                else begin
                  port_change = 1'b1;
                  port_changed[ciq_tmp[i].ci_tap] = ciq_tmp[i].ci_port;
                end
              end

              if (ciq_tmp[i].ci_state != ci.ci_state) begin
                if (!port_changed.exists(tn.tap_tree[ciq_tmp[i].ci_tap].master_tap)) begin
                  state_change = 1'b1;
                  state_changed[ciq_tmp[i].ci_tap] = ciq_tmp[i].ci_state;
                end
                else
                  skip = 1'b1;
              end
            end

          if (skip)
            continue;

          // Unnecessary check.  But ci.ci_port and ci.ci_state used below!
          if (!tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state)) begin
            `ovm_error(get_type_name(), $psprintf("TAP %s expected to be configured but isn't", tap_u.name()))
            break;
          end

          // Unnecessary check.
          if (ci.ci_state != TAP_STATE_NORMAL) begin
            `ovm_error(get_type_name(), $psprintf("TAP %s expected to be in NORMAL state but isn't", tap_u.name()))
            break;
          end

          // ci.ci_port == port_i
          // ci.ci_state == TAP_STATE_NORMAL

          if (port_change) begin
            tn.tap_array[ci.ci_port][tap_u].tap_handle.get_port_change_ir_dr(ciq_tmp, ir, dr);
            `ovm_info(get_type_name(),
                      $psprintf("For port change, TAP %s will issue instruction 'h%0h and data stream %0d%s",
                                tap_u.name(), ir, dr.size(), dfx_tap_util::writeh(dr)),
                      // OVM_HIGH)
                      OVM_NONE)
            myseq1.seq_ir_in[tap_u] = ir;
            myseq1.seq_dr_in[tap_u] = dr;
            add_b(myseq1, tap_u); // account for a/b differences
          end

          if (state_change) begin
            tn.tap_array[ci.ci_port][tap_u].tap_handle.get_state_change_ir_dr(ciq_tmp, ir, dr);
            `ovm_info(get_type_name(),
                      $psprintf("For state change, TAP %s will issue instruction 'h%0h and data stream %0d%s",
                                tap_u.name(), ir, dr.size(), dfx_tap_util::writeh(dr)),
                      // OVM_HIGH)
                      OVM_NONE)
            myseq2.seq_ir_in[tap_u] = ir;
            myseq2.seq_dr_in[tap_u] = dr;
            add_b(myseq2, tap_u); // account for a/b differences
          end

          // `ovm_info(get_type_name(), "myseq1 (for port changes) so far:", OVM_FULL)
          `ovm_info(get_type_name(), "myseq1 (for port changes) so far:", OVM_NONE)
          // if (my_verbosity >= OVM_FULL)
          myseq1.print();

          // `ovm_info(get_type_name(), "myseq2 (for state changes) so far:", OVM_FULL)
          `ovm_info(get_type_name(), "myseq2 (for state changes) so far:", OVM_NONE)
          // if (my_verbosity >= OVM_FULL)
          myseq2.print();

          if (tn.tap_array[port_i][tap_u].tap_handle.wait_cycles > wait_cycs)
            wait_cycs = tn.tap_array[port_i][tap_u].tap_handle.wait_cycles;

          tpqa.delete(tap_u); // done with this TAP
        end

        `ovm_info(get_type_name(),
                  $psprintf("On iteration %0d, TAPs on port %s need to change ports for these TAPS:", iter_num, port_i.name()),
                  // OVM_HIGH)
                  OVM_NONE)
        foreach (port_changed[tu_i]) begin
          tap_u = dfx_tap_unit_e'(tu_i);

          // `ovm_info(get_type_name(), $psprintf("  Sub-TAP %s, Port %s", tap_u.name(), port_changed[tap_u].name()), OVM_HIGH)
          `ovm_info(get_type_name(), $psprintf("  Sub-TAP %s, Port %s", tap_u.name(), port_changed[tap_u].name()), OVM_NONE)
        end

        `ovm_info(get_type_name(),
                  $psprintf("On iteration %0d, TAPs on port %s need to enable these TAPS:", iter_num, port_i.name()),
                  // OVM_HIGH)
                  OVM_NONE)
        foreach (state_changed[tu_i]) begin
          tap_u = dfx_tap_unit_e'(tu_i);

          // `ovm_info(get_type_name(), $psprintf("  Sub-TAP %s, State %s", tap_u.name(), state_changed[tap_u].name()), OVM_HIGH)
          `ovm_info(get_type_name(), $psprintf("  Sub-TAP %s, State %s", tap_u.name(), state_changed[tap_u].name()), OVM_NONE)
        end

        // Issue TAP transactions for this port, if needed.

        if (myseq1.seq_ir_in.num) begin
          `ovm_info(get_type_name(),
                    $psprintf("On iteration %0d, final myseq1 (for port changes) on port %s:", iter_num, port_i.name()),
                    // OVM_FULL)
                    OVM_NONE)
          // if (my_verbosity >= OVM_FULL)
          myseq1.print();

          `ovm_send(myseq1)

          // Check result?  A checker should do it.

          // `ovm_info(get_type_name(), "Completed myseq1 sequence:", OVM_FULL)
          `ovm_info(get_type_name(), "Completed myseq1 sequence:", OVM_NONE)
          // if (my_verbosity >= OVM_FULL)
          myseq1.print();

          // Add wait cycles here?
          //
          // Each port that a TAP gets moved to must have this number of wait cycles.
          for (dfx_tap_port_e port_j = port_j.first(); port_j != p_sequencer.TapNumPorts; port_j = port_j.next()) begin

            dfx_tap_port_e port_k = p_sequencer.TapNumPorts;

            if (port_j == port_i)
              port_k = port_j; // wait cyles on this port
            else
              foreach (port_changed[tu_j])
                if (port_changed[tu_j] == port_j) begin
                  port_k = port_j; // wait cyles on this port
                  break;
                end

            if (port_k != p_sequencer.TapNumPorts)
              fork
                dfx_tap_port_e portt = port_k;
                dfx_tap_tms_tap_transaction tms_tr;

                `ovm_do_on_with(tms_tr, p_sequencer.tap_seqr_array[portt],
                                {assert_trst == 1'b0; ts == DFX_TAP_TS_RTI;
                                 tms_in.size() == wait_cycs; foreach (tms_in[i]) tms_in[i] == 1'b0;})
              join_none
          end

          wait fork;

          if (!port_changed.num())
            `ovm_fatal(get_type_name(),
                       $psprintf("Internal TB error: port_changed array unexpectedly empty on iteration %0d, on port %s",
                                 iter_num, port_i.name()))

          foreach (port_changed[tu_i]) begin
            tap_u = dfx_tap_unit_e'(tu_i);

            if (!tn.change_tap_port(tap_u, port_changed[tap_u]))
              `ovm_error(get_type_name(), "Could not change port in TAP network")
          end

          // `ovm_info(get_type_name(), "TAP network changed:", OVM_HIGH)
          `ovm_info(get_type_name(), "TAP network changed:", OVM_NONE)
          // if (my_verbosity >= OVM_HIGH)
          tn.print();
        end

        if (myseq2.seq_ir_in.num) begin
          dfx_tap_tms_tap_transaction tms_tr;

          `ovm_info(get_type_name(),
                    $psprintf("On iteration %0d, final myseq2 (for state changes) on port %s:", iter_num, port_i.name()),
                    // OVM_FULL)
                    OVM_NONE)
          // if (my_verbosity >= OVM_FULL)
          myseq2.print();

          `ovm_send(myseq2)

          // Check result?  A checker should do it.

          // `ovm_info(get_type_name(), "Completed myseq2 sequence:", OVM_FULL)
          `ovm_info(get_type_name(), "Completed myseq2 sequence:", OVM_NONE)
          // if (my_verbosity >= OVM_FULL)
          myseq2.print();

          // Add wait cycles here?
          //
          // Each port with a TAP that gets its state changed must have this number of wait cycles.
          for (dfx_tap_port_e port_j = port_j.first(); port_j != p_sequencer.TapNumPorts; port_j = port_j.next()) begin

            dfx_tap_port_e port_k = p_sequencer.TapNumPorts;

            if (port_j == port_i)
              port_k = port_j; // wait cyles on this port
            else
              foreach (state_changed[tu_i]) begin
                tap_u = dfx_tap_unit_e'(tu_i);

                if (!tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state))
                  `ovm_error(get_type_name(), $psprintf("TAP %s expected to be configured but isn't", tap_u.name()))

                if (ci.ci_port == port_j) begin
                  port_k = port_j; // wait cyles on this port
                  break;
                end
              end

            if (port_k != p_sequencer.TapNumPorts)
              fork
                dfx_tap_port_e portt = port_k;
                dfx_tap_tms_tap_transaction tms_tr;

                `ovm_do_on_with(tms_tr, p_sequencer.tap_seqr_array[portt],
                                {assert_trst == 1'b0; ts == DFX_TAP_TS_RTI;
                                 tms_in.size() == wait_cycs; foreach (tms_in[i]) tms_in[i] == 1'b0;})
              join_none
          end

          wait fork;

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

endclass : dfx_tap_enable_sequence

`endif // `ifndef DFX_TAP_ENABLE_SEQUENCE_SV
