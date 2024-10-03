// =====================================================================================================
// FileName          : dfx_wtap_config_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon Sep 13 19:19:37 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx WTAP Configuration sequence - Enable/Disable WTAPs (on the master TAP's ports)
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_WTAP_CONFIG_SEQUENCE_SV
`define DFX_WTAP_CONFIG_SEQUENCE_SV

class dfx_wtap_config_sequence extends ovm_sequence;

  `ovm_sequence_utils_begin(dfx_wtap_config_sequence, dfx_tap_virtual_sequencer)
  `ovm_sequence_utils_end

  ovm_verbosity my_verbosity = OVM_LOW;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/
  rand bit config_wtap[dfx_tap_unit_e]; // 1'b1 to enable, 1'b0 to disable
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this sequence
   ************************************************************************************************************************/

  function new(string name = "dfx_wtap_config_sequence");
    super.new(name);
  endfunction : new

  function void do_print(ovm_printer printer);
    dfx_tap_unit_e tap_u;

    /*
     if (my_verbosity < OVM_HIGH)
      return;
     */

    super.do_print(printer);

    printer.print_array_header("config_wtap array", config_wtap.size());
    foreach (config_wtap[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      printer.print_field($psprintf("TAP %s: ", tap_u.name()), config_wtap[tap_u], 1, OVM_DEC);
    end
    printer.print_array_footer();

  endfunction : do_print

  task body();
    dfx_tap_unit_e tap_u, tap_u2;
    dfx_tap_network tn = dfx_tap_network::get_handle();
    cfg_item_s ci;
    ciq_t ciq_tmp,
      tpqa[dfx_tap_unit_e]; // slave "TAP-port-state queue" array indexed by TAP
    dfx_tap_state_e state_changed[dfx_tap_unit_e];
    tap_ir_t ir;
    dfx_node_t dr[];
    dfx_tap_multiple_taps_sequence myseq[dfx_tap_port_e];
    int wait_cycs[dfx_tap_port_e];

    if (!$cast(my_verbosity, p_sequencer.get_report_verbosity_level()))
      `ovm_fatal(get_type_name(), "OVM verbosity not a valid enum value")

    // `ovm_info(get_type_name(), "TAP network before reconfiguration:", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network before reconfiguration:", OVM_NONE)
    // if (my_verbosity >= OVM_HIGH)
    tn.print();

    foreach (config_wtap[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      if (!tn.tap_tree[tap_u].w_tap)
        `ovm_error(get_type_name(), $psprintf("TAP %s being configured is not a WTAP", tap_u.name()))

      if (!tn.r_tap_configured(tap_u, ci.ci_port, ci.ci_state))
        `ovm_error(get_type_name(), $psprintf("WTAP %s being enabled is not configured in the DUT", tap_u.name()))
      else
        if ((config_wtap[tap_u] && ci.ci_state == TAP_STATE_NORMAL) ||
            (!config_wtap[tap_u] && ci.ci_state == TAP_STATE_ISOLATED)) begin
          // `ovm_info(get_type_name(), $psprintf("TAP %s is already in specified state, nothing to do", tap_u.name()), OVM_HIGH)
          `ovm_info(get_type_name(), $psprintf("TAP %s is already in specified state, nothing to do", tap_u.name()), OVM_NONE)
          continue; // nothing to do
        end

      // if (!tn.tap_configured(tn.tap_tree[tap_u].master_tap, ci.ci_port, ci.ci_state) || ci.ci_state != TAP_STATE_NORMAL)
      if (!tn.r_tap_configured(tn.tap_tree[tap_u].master_tap, ci.ci_port, ci.ci_state) || ci.ci_state != TAP_STATE_NORMAL)
        `ovm_error(get_type_name(),
                   $psprintf("WTAP %s's master TAP %s not configured/normal",
                             tap_u.name(), tn.tap_tree[tap_u].master_tap.name()))

      ci.ci_tap = tap_u;
      // ci.ci_port is already set correctly to the master TAP's port
      ci.ci_state = config_wtap[tap_u] ? TAP_STATE_NORMAL : TAP_STATE_ISOLATED;

      tpqa[tn.tap_tree[tap_u].master_tap].push_back(ci);
    end

    // For each TAP required to issue configuration instructions/data, make a complete list of all WTAPs with the
    // required actions.
    //
    foreach (tpqa[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      tpqa[tap_u].sort() with (item.ci_tap);

      // `ovm_info(get_type_name(), $psprintf("TAP %s needs to configure these WTAPS:", tap_u.name()), OVM_HIGH)
      `ovm_info(get_type_name(), $psprintf("TAP %s needs to configure these WTAPS:", tap_u.name()), OVM_NONE)
      for (int i = 0; i < tpqa[tap_u].size(); i++)
        `ovm_info(get_type_name(),
                  $psprintf("  WTAP: %s, Port: %s, State: %s", tpqa[tap_u][i].ci_tap.name(), tpqa[tap_u][i].ci_port.name(),
                            // tpqa[tap_u][i].ci_state.name()), OVM_HIGH)
                            tpqa[tap_u][i].ci_state.name()), OVM_NONE)

      for (int i = 0; i < tn.tap_tree[tap_u].w_taps.size(); i++) begin
        tap_u2 = dfx_tap_unit_e'(tn.tap_tree[tap_u].w_taps[i]);

        if (i >= tpqa[tap_u].size() || tap_u2 != tpqa[tap_u][i].ci_tap) begin
          if (!tn.r_tap_configured(tap_u2, ci.ci_port, ci.ci_state)) begin
            // WTAP is not in the DUT.  However, its data bits must still be included in the data bits for the TAP.
            ci.ci_port = tpqa[tap_u][0].ci_port; // same port as one of the WTAPs
            ci.ci_state = TAP_STATE_ISOLATED; // some state - choose default state for an unconfigured TAP
          end
          ci.ci_tap = tap_u2;
          tpqa[tap_u].insert(i, ci);
        end
      end

      // If tpqa[tap_u] has some "junk" (non-WTAP) TAPS which caused an OVM_ERROR above, those TAPs still remain!
      // Ensure tpqa[tap_u].size() == tn.tap_tree[tap_u].w_taps.size()?
    end

    foreach (tpqa[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);

      // `ovm_info(get_type_name(), $psprintf("TAP %s full configure list:", tap_u.name()), OVM_HIGH)
      `ovm_info(get_type_name(), $psprintf("TAP %s full configure list:", tap_u.name()), OVM_NONE)
      for (int i = 0; i < tpqa[tap_u].size(); i++)
        `ovm_info(get_type_name(),
                  $psprintf("  WTAP: %s, Port: %s, State: %s", tpqa[tap_u][i].ci_tap.name(), tpqa[tap_u][i].ci_port.name(),
                            tpqa[tap_u][i].ci_state.name()),
                  // OVM_HIGH)
                  OVM_NONE)
    end

    // Now create IR/DR sequences for each TAP.  Create at most one sequence for each port.

    foreach (tpqa[tu_i]) begin
      dfx_tap_port_e port;

      tap_u = dfx_tap_unit_e'(tu_i);

      ciq_tmp = tpqa[tap_u];

      for (int i = 0; i < ciq_tmp.size(); i++)
        if (tn.r_tap_configured(ciq_tmp[i].ci_tap, ci.ci_port, ci.ci_state)) begin

          if (ciq_tmp[i].ci_state != ci.ci_state)
            state_changed[ciq_tmp[i].ci_tap] = ciq_tmp[i].ci_state;
        end

      port = ciq_tmp[0].ci_port;

      tn.tap_array[port][tap_u].tap_handle.get_wtap_config_ir_dr(ciq_tmp, ir, dr);
      `ovm_info(get_type_name(),
                $psprintf("TAP %s will issue instruction 'h%0h and data stream %0d%s",
                          // tap_u.name(), ir, dr.size(), dfx_tap_util::writeh(dr)), OVM_HIGH)
                          tap_u.name(), ir, dr.size(), dfx_tap_util::writeh(dr)), OVM_NONE)

      if (!myseq.exists(port)) begin
        `ovm_create_on(myseq[port], p_sequencer.tap_seqr_array[port])
        wait_cycs[port] = 0;
      end

      myseq[port].seq_ir_in[tap_u] = ir;
      myseq[port].seq_dr_in[tap_u] = dr;

      if (tn.tap_array[port][tap_u].tap_handle.wait_cycles > wait_cycs[port])
        wait_cycs[port] = tn.tap_array[port][tap_u].tap_handle.wait_cycles;
    end

    // Print and issue TAP transactions in parallel.
    foreach (myseq[port_i]) begin
      dfx_tap_port_e port = dfx_tap_port_e'(port_i);

      // `ovm_info(get_type_name(), $psprintf("myseq[%s]:", port.name()), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("myseq[%s]:", port.name()), OVM_NONE)
      // if (my_verbosity >= OVM_FULL)
      myseq[port].print();

      fork
        dfx_tap_port_e portt = port;
        dfx_tap_tms_tap_transaction tms_tr;

        begin
          `ovm_send(myseq[portt])
          `ovm_do_on_with(tms_tr, p_sequencer.tap_seqr_array[portt],
                          {assert_trst == 1'b0; ts == DFX_TAP_TS_RTI;
                           tms_in.size() == wait_cycs[portt]; foreach (tms_in[i]) tms_in[i] == 1'b0;})
        end
      join_none
    end

    wait fork;

    // Check result?  A checker should do it.

    foreach (myseq[port_i]) begin
      dfx_tap_port_e port = dfx_tap_port_e'(port_i);

      // `ovm_info(get_type_name(), $psprintf("Completed myseq[%s]:", port.name()), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("Completed myseq[%s]:", port.name()), OVM_NONE)
      // if (my_verbosity >= OVM_FULL)
      myseq[port].print();
    end

    foreach (state_changed[tu_i])
      if (!tn.change_tap_state(tu_i, state_changed[tu_i]))
        `ovm_error(get_type_name(), "Could not change state in TAP network")

    if (state_changed.num()) begin
      // `ovm_info(get_type_name(), "TAP network changed.  TAP network after reconfiguration:", OVM_HIGH)
      `ovm_info(get_type_name(), "TAP network changed.  TAP network after reconfiguration:", OVM_NONE)
      // if (my_verbosity >= OVM_HIGH)
      tn.print();
    end

  endtask : body

endclass : dfx_wtap_config_sequence

`endif // `ifndef DFX_WTAP_CONFIG_SEQUENCE_SV
