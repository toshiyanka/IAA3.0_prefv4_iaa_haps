// =====================================================================================================
// FileName          : dfx_tap_network.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon Nov  1 15:38:08 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// TAP network class
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_NETWORK_SV
`define DFX_TAP_NETWORK_SV

// TAP network element
//
typedef struct {
  dfx_tap_any tap_handle;
  dfx_tap_state_e r_tap_state; // real TAP state
  dfx_tap_state_e e_tap_state; // effective TAP state - determined by state of controlling hierarchical TAP
 //  bit sticky_port; // for hybrid TAPs only - the port is non-P0 and was changed in the controlling TAP
} dfx_tap_status_s;

typedef dfx_tap_status_s dfx_tap_status_ary_t[NUM_TAPS];

// Queue of TAPs
//
// typedef dfx_tap_unit_e tap_queue_t[$];

// TAP control tree element
//
typedef struct {
  int level; // TAP node level in TAP tree
  bit hierarchical; // 1 if hierarchical, 0 if linear
  // Should a WTAP's master TAP have this bit set to 1?
  bit hybrid; // 1 if hybrid, 0 if linear or hierarchical

  dfx_tap_unit_e master_tap; // master TAP (at most one per TAP in the network)
  bit w_tap; // WTAP

  bit mode; // 0 if independent TAP; 1 if mode follows another TAP's
  dfx_tap_unit_e primary_tap; // if mode == 1, then the TAP whose mode this TAP follows
  // A "dependant" TAP must come after the primary TAP in the TAP network.

  dfx_tap_unit_e s_taps[$]; // queue of slave/child TAPs in the correct order (0 or more per TAP in the network) -
                            // excluding dependant TAPs
  dfx_tap_unit_e w_taps[$]; // queue of WTAPs in the correct order (0 or more per TAP in the network)
} dfx_tap_tree_s;

// This component behaves more like an object than a component.
//
class dfx_tap_network extends ovm_component;

  protected function new(string name = "dfx_tap_network", ovm_component parent = null);
    int num_ports;
    dfx_tap_unit_e l_list[$]; // list of TAPs for determining levels

    super.new(name, parent);

    if (!get_config_int("TapNumPorts", num_ports))
      `ovm_fatal(get_type_name(), "TapNumPorts not set")
    if (!$cast(TapNumPorts, num_ports))
      `ovm_fatal(get_type_name(), "TapNumPorts value not in enum range - increase range")

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next()) begin
      tap_tree[tu_i].hierarchical = 0; // default to "no slave TAPs" or linear; set later
      tap_tree[tu_i].hybrid = 0; // default to non-hybrid; set later
      tap_tree[tu_i].w_tap = 1'b0; // default to non-WTAP; set later
      tap_tree[tu_i].mode = 0; // default to independent mode; set later
      tap_tree[tu_i].primary_tap = dfx_tap_unit_e'(0); // default to some TAP; set later
    end

    `dfx_tap_define_master_TAPs

    determine_s_taps();
    determine_levels(l_list);
    // determine_ss_taps();
    determine_w_taps();

  endfunction : new

  function string get_type_name();
    return "dfx_tap_network";
  endfunction : get_type_name

  // TAP topology
  dfx_tap_status_ary_t tap_array[];

  // TAP control tree
  dfx_tap_tree_s tap_tree[NUM_TAPS];

  dfx_tap_port_e TapNumPorts; // number of JTAG ports

  bit use_override = 1'b0; // TAPC_SELECT_OVR - currently one override for all TAPs, but can be refined to be one per
                           // TAP if needed

  static local dfx_tap_network tap_network = null;

  static function dfx_tap_network get_handle(string name = "", ovm_component parent = null);
    if (tap_network == null)
      tap_network = new(name, parent);

    return tap_network;
  endfunction : get_handle

  function void do_print(ovm_printer printer);
    dfx_tap_port_e port_i;

    super.do_print(printer);

    printer.print_array_header("tap_array in TAP network", NUM_TAPS);
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next()) begin

      for (port_i = port_i.first(); port_i != TapNumPorts; port_i = port_i.next())
        if (tap_array[port_i][tu_i].tap_handle != null)
          break;

      if (port_i != TapNumPorts) begin
        printer.print_string($psprintf("TAP %s port", tu_i.name()), port_i.name());
        printer.print_object($psprintf("TAP %s", tu_i.name()), tap_array[port_i][tu_i].tap_handle);
        printer.print_string($psprintf("TAP %s r_tap_state", tu_i.name()), tap_array[port_i][tu_i].r_tap_state.name());
        printer.print_string($psprintf("TAP %s e_tap_state", tu_i.name()), tap_array[port_i][tu_i].e_tap_state.name());
        /*
        printer.print_field($psprintf("TAP %s sticky_port", tu_i.name()),
                            tap_array[port_i][tu_i].sticky_port, $bits(tap_array[port_i][tu_i].sticky_port), OVM_UNSIGNED);
        */
      end
      else
        printer.print_string($psprintf("TAP %s not configured on any port", tu_i.name()), "null");

    end
    printer.print_array_footer();

    // Print only once?
    //
    printer.print_array_header("tap_tree in TAP network", NUM_TAPS);
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next()) begin
      printer.print_field($psprintf("TAP %s level", tu_i.name()), tap_tree[tu_i].level, $bits(tap_tree[tu_i].level), OVM_DEC);
      printer.print_field($psprintf("TAP %s hierarchical", tu_i.name()),
                          tap_tree[tu_i].hierarchical, $bits(tap_tree[tu_i].hierarchical), OVM_UNSIGNED);
      printer.print_field($psprintf("TAP %s hybrid", tu_i.name()),
                           tap_tree[tu_i].hybrid, $bits(tap_tree[tu_i].hybrid), OVM_UNSIGNED);
      printer.print_field($psprintf("TAP %s mode", tu_i.name()),
                           tap_tree[tu_i].mode, $bits(tap_tree[tu_i].mode), OVM_UNSIGNED);
      if (tap_tree[tu_i].mode)
        printer.print_string($psprintf("TAP %s primary TAP", tu_i.name()), tap_tree[tu_i].primary_tap.name);
      printer.print_string($psprintf("TAP %s master", tu_i.name()), tap_tree[tu_i].master_tap.name());
      printer.print_field($psprintf("TAP %s w_tap", tu_i.name()), tap_tree[tu_i].w_tap, $bits(tap_tree[tu_i].w_tap), OVM_UNSIGNED);

      printer.print_array_header($psprintf("TAP %s slave TAPs queue", tu_i.name()), tap_tree[tu_i].s_taps.size());
      for (int i = 0; i < tap_tree[tu_i].s_taps.size(); i++)
        printer.print_string($psprintf("TAP %s slave TAP %0d", tu_i.name(), i), tap_tree[tu_i].s_taps[i].name());
      printer.print_array_footer();

      printer.print_array_header($psprintf("TAP %s WTAPs queue", tu_i.name()), tap_tree[tu_i].w_taps.size());
      for (int i = 0; i < tap_tree[tu_i].w_taps.size(); i++)
        printer.print_string($psprintf("TAP %s WTAP %0d", tu_i.name(), i), tap_tree[tu_i].w_taps[i].name());
      printer.print_array_footer();

    end
    printer.print_array_footer();

  endfunction : do_print

  // Not needed yet.
  //
  // function void build();
  //   super.build();
  // endfunction : build

  // Set TAP network to its initial (PowerGood) state.
  //
  // All configured TAPs are on port P0 initially.  All TAPs except the "root" TAPs are in isolated state.  Also take
  // into account any overrides.
  //
  // It is only necessary to configure those TAPs which are in the DUT.  (Others are already set to null.)
  //
  // Note: This function can also be invoked from the build() function of this (TAP network) class.  However, it is
  // currently invoked by the TAP agent's build() function.  It is also invoked by any sequences that may deassert
  // POWERGOOD.
  //
  function void set_initial_state;
    dfx_tap_unit_e tap_u;
    int tap_exists, tmp_int;
    string s1, s2, s3;
    dfx_tap_port_e port_i, port_j, tap_port_override;
    dfx_tap_state_e state_i, state_j, tap_state_override;

    // (Re)Create TAP network object.
    //
    // It is only necessary to create/configure those TAPs which are in the DUT.  Others are defaulted to null.
    //
    // Note: This functionality was moved here from the build() function of the TAP agent class.
    //
    // Clear initial state to: no TAPS configured.
    //
    for (port_i = port_i.first(); port_i != TapNumPorts; port_i = port_i.next())
      for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next())
        tap_array[port_i][tu_i] = '{null, TAP_STATE_ISOLATED, TAP_STATE_ISOLATED};
    //
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      s1 = tu_i.name();

      if (!get_config_int(s1, tap_exists))
        tap_exists = 0;

      if (tap_exists) begin
`ifndef DFX_TAP_PRE_AUTOMATION
        s2 = s1;
`else
        s2 = dfx_tap_util::a_prefix(s1);
`endif
        s3 = {"dfx_tap_", s2.tolower()};
        if (tap_array[TAP_PORT_P0][tu_i].tap_handle == null) begin // unnecessary
          $cast(tap_array[TAP_PORT_P0][tu_i].tap_handle, create_object(s3, s1));
          tap_array[TAP_PORT_P0][tu_i].tap_handle.this_tap = tu_i;
          tap_array[TAP_PORT_P0][tu_i].tap_handle.set_idcode_value;
        end
      end
    end

    // The TAPC_SELECT_OVR can be refined so that it can be specified on a per-TAP basis.  Currently, it is defined to
    // apply to the entire TAP network (essentially, the top level TAP or CLTAP).  The same comment applies to the
    // "use_override" field.
    //
    if (get_config_int("tapc_select_ovr", tmp_int) && (tmp_int > 0)) begin
      `ovm_info(get_type_name(), "Top/Chip level TAP will use TAPC_SELECT_OVR instruction instead of TAPC_SELECT instruction",
                OVM_NONE)
      use_override = 1'b1;

      tap_u = tap_u.first;
      if (r_tap_configured(tap_u, port_i, state_i))
        tap_array[port_i][tap_u].tap_handle.use_override = 1'b1;
    end

    // Place the highest (lowest level) configured TAP in any sub-tree in NORMAL state.  This will allow all TAPs to be
    // configured using TAP instructions.  A "dependant" TAP assumes its primary TAP's state.
    //
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next()) begin

      if (r_tap_configured(tu_i, port_i, state_i) &&
          tap_tree[tu_i].w_tap &&
          !r_tap_configured(tap_tree[tu_i].master_tap, port_i, state_i))
        `ovm_error(get_type_name(), $psprintf("WTAP %s is configured, but its master isn't", tu_i.name()))

      if (r_tap_configured(tu_i, port_i, state_i) && tap_tree[tu_i].mode &&
          !r_tap_configured(tap_tree[tu_i].primary_tap, port_i, state_i))
        `ovm_error(get_type_name(), $psprintf("TAP %s is configured, but its primary TAP isn't", tu_i.name()))

      tap_u = tu_i;
      while (r_tap_configured(tap_u, port_i, state_i) && state_i != TAP_STATE_NORMAL)
        if (tap_tree[tap_u].master_tap != tap_u && r_tap_configured(tap_tree[tap_u].master_tap, port_j, state_j))
          tap_u = tap_tree[tap_u].master_tap;
        else begin
          if (!tap_tree[tap_u].mode) begin
            tap_array[port_i][tap_u].r_tap_state = TAP_STATE_NORMAL;
            tap_array[port_i][tap_u].e_tap_state = TAP_STATE_NORMAL;
            // FIXME!!! Place WTAPs, if configured, on "port_i" also?  "port_i" should always be TAP_PORT_P0.
          end
          else
            break;
        end

    end

    // Set states of dependant TAPs now.
    for (dfx_tap_unit_e tu = tu.first(); tu != tu.last; tu = tu.next())
      if (tap_tree[tu].mode && r_tap_configured(tu, port_i, state_i) &&
          r_tap_configured(tap_tree[tu].primary_tap, port_j, state_j)) begin
        // Assumption: port_i == port_j == TAP_PORT_P0
        tap_array[port_i][tu].r_tap_state = state_j;
        tap_array[port_i][tu].e_tap_state = tap_array[port_j][tap_tree[tu].primary_tap].e_tap_state;
      end

    // Now set any overrides on TAP ports and states.
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      bit tap_port_overridden, tap_state_overridden;
      string s1 = tu_i.name();

      if (!get_config_int({s1, "_port_override"}, tmp_int))
        tap_port_overridden = 1'b0;
      else begin
        if (!$cast(tap_port_override, tmp_int))
          `ovm_fatal(get_type_name(), "TAP port override does not specify a valid port")
        tap_port_overridden = 1'b1;
        `ovm_info(get_type_name(), $psprintf("Overriding port to %s for TAP %s", tap_port_override.name(), s1), OVM_NONE)
      end

      if (!get_config_int({s1, "_state_override"}, tmp_int))
        tap_state_overridden = 1'b0;
      else begin
        if (!$cast(tap_state_override, tmp_int))
          `ovm_fatal(get_type_name(), "TAP state override does not specify a valid state")
        tap_state_overridden = 1'b1;
        `ovm_info(get_type_name(), $psprintf("Overriding state to %s for TAP %s", tap_state_override.name(), s1), OVM_NONE)
      end

      if (tap_port_overridden || tap_state_overridden)
        if (!r_tap_configured(tu_i, port_i, state_i))
          `ovm_warning(get_type_name(),
                       $psprintf("TAP port or state overridden for TAP %s, but TAP not configured", tu_i.name()))
        else begin
          if (tap_port_overridden)
            // Note: For WTAPs, change_tap_port() will report an error.  For STAPs whose master is hierarchical,
            // change_tap_port() may report an error.
            if (!change_tap_port(tu_i, tap_port_override))
              `ovm_error(get_type_name(),
                         $psprintf("Could not override TAP %s port to %s", tu_i.name, tap_port_override.name))

          if (tap_state_overridden)
            if (!change_tap_state(tu_i, tap_state_override))
              `ovm_error(get_type_name(),
                         $psprintf("Could not override TAP %s state to %s", tu_i.name, tap_state_override.name))
        end
    end // for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin

    ensure_consistency; // make sure overrides don't leave TAP network inconsistent, including "dependant" TAPs

  endfunction : set_initial_state

  // Set TAP network to its TRST state.
  //
  function void set_initial_state_trst;
    dfx_tap_unit_e tap;
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    // TRST affects only CLTAP, based upon whether it's using TAPC_SELECT_OVR.  As mentioned above, this can be extended
    // to a methodology that applies on a per-TAP basis.

    tap = tap.first; // CLTAP

    if (!use_override)
      foreach (tap_tree[tap].s_taps[i])
        if (r_tap_configured(tap_tree[tap].s_taps[i], port, state))
          if (!change_tap_state(tap_tree[tap].s_taps[i], TAP_STATE_ISOLATED))
            `ovm_error(get_type_name(),
                       $psprintf("Could not Isolate TAP %s in set_initial_state_trst()", tap_tree[tap].s_taps[i].name))

    ensure_consistency;

  endfunction : set_initial_state_trst

  // Determine levels of the TAP nodes in the TAP control tree.
  //
  function void determine_levels(dfx_tap_unit_e in_list[$]);
    dfx_tap_unit_e tap_u, tmp_list[$], out_list[$];
    int lvl;

    while (in_list.size()) begin
      tap_u = in_list.pop_front();
      lvl = tap_tree[tap_u].level + 1;
      tmp_list = tap_tree[tap_u].s_taps;
      tmp_list = {tmp_list, tap_tree[tap_u].w_taps};

      foreach(tmp_list[i])
        tap_tree[tmp_list[i]].level = lvl;

      out_list = {out_list, tmp_list};
    end

    if (out_list.size())
      determine_levels(out_list);
  endfunction : determine_levels

  // Determine slave/child/controlled TAPs for each TAP in the TAP control tree.
  //
  function void determine_s_taps();

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next())
      if (tap_tree[tu_i].master_tap != tu_i  && !tap_tree[tu_i].w_tap && !tap_tree[tu_i].mode)
        tap_tree[tap_tree[tu_i].master_tap].s_taps.push_back(tu_i);

    // Really, there's no need to sort because higher numbered TAPs are added after lower numbered TAPs.
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next())
      if (tap_tree[tu_i].s_taps.size())
        tap_tree[tu_i].s_taps.sort(); // place TAPs in the correct order

  endfunction : determine_s_taps

  // Determine WTAPs for each TAP in the TAP control tree.
  //
  function void determine_w_taps();

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != tu_i.last(); tu_i = tu_i.next())
      if (tap_tree[tu_i].w_tap) // tap_tree[tu_i].master_tap != tu_i
        tap_tree[tap_tree[tu_i].master_tap].w_taps.push_back(tu_i); // queue is created sorted

  endfunction : determine_w_taps

  // Return 1'b1 if the specified TAP is on the specified port in the specified real state, 0 otherwise.
  // (This could be implemented with a call to r_tap_configured().)
  //
  function bit r_check_tap(dfx_tap_unit_e tap_u, dfx_tap_port_e port, dfx_tap_state_e state);
    if (tap_array[port][tap_u].tap_handle != null && tap_array[port][tap_u].r_tap_state == state)
      return 1'b1;
    else
      return 1'b0;
  endfunction : r_check_tap

  // Return 1'b1 if the specified TAP is on the specified port in the specified effective state, 0 otherwise.
  // (This could be implemented with a call to tap_configured().)
  //
  // e_check_tap()
  //
  function bit check_tap(dfx_tap_unit_e tap_u, dfx_tap_port_e port, dfx_tap_state_e state);
    if (tap_array[port][tap_u].tap_handle != null && tap_array[port][tap_u].e_tap_state == state)
      return 1'b1;
    else
      return 1'b0;
  endfunction : check_tap

  // Return 1'b1 if the specified TAP is configured and in NORMAL real state, 0 otherwise.
  // (This could be implemented with a call to r_tap_configured().)
  //
  function bit r_tap_normal(dfx_tap_unit_e tap_u);
    dfx_tap_port_e port_i;

    for (port_i = port_i.first(); port_i != TapNumPorts; port_i = port_i.next())
      if (r_check_tap(tap_u, port_i, TAP_STATE_NORMAL))
        break;

    if (port_i == TapNumPorts)
      return 1'b0;
    else
      return 1'b1;
  endfunction : r_tap_normal

  // Return 1'b1 if the specified TAP is configured and in NORMAL effective state, 0 otherwise.
  // (This could be implemented with a call to tap_configured().)
  //
  // e_tap_normal()
  //
  function bit tap_normal(dfx_tap_unit_e tap_u);
    dfx_tap_port_e port_i;

    for (port_i = port_i.first(); port_i != TapNumPorts; port_i = port_i.next())
      if (check_tap(tap_u, port_i, TAP_STATE_NORMAL))
        break;

    if (port_i == TapNumPorts)
      return 1'b0;
    else
      return 1'b1;
  endfunction : tap_normal

  // Return 1'b1 if the specified TAP is configured, 0 otherwise.  If TAP is configured, also indicate its port and
  // real state.
  //
  function bit r_tap_configured(dfx_tap_unit_e tap_u, ref dfx_tap_port_e port, ref dfx_tap_state_e state);

    for (port = port.first(); port != TapNumPorts; port = port.next())
      if (tap_array[port][tap_u].tap_handle != null)
        break;

    if (port == TapNumPorts)
      return 1'b0;

    state = tap_array[port][tap_u].r_tap_state;

    return 1'b1;
  endfunction : r_tap_configured

  // Return 1'b1 if the specified TAP is configured, 0 otherwise.  If TAP is configured, also indicate its port and
  // effective state.
  //
  // e_tap_configured()
  //
  function bit tap_configured(dfx_tap_unit_e tap_u, ref dfx_tap_port_e port, ref dfx_tap_state_e state);

    for (port = port.first(); port != TapNumPorts; port = port.next())
      if (tap_array[port][tap_u].tap_handle != null)
        break;

    if (port == TapNumPorts)
      return 1'b0;

    state = tap_array[port][tap_u].e_tap_state;

    return 1'b1;
  endfunction : tap_configured

  // Return 1'b1 if the specified TAP is "effectively" isolated, 0 otherwise.
  //
  function bit tap_effectively_isolated(dfx_tap_unit_e tap_u, dfx_tap_port_e port);

    if (tap_array[port][tap_u].tap_handle == null ||
        tap_array[port][tap_u].e_tap_state == TAP_STATE_ISOLATED)
      return 1'b1;
    else
      return 1'b0;

  endfunction : tap_effectively_isolated

  // Return 1'b1 if TAP network is in a consistent state, 0 otherwise.
  //
  function bit ensure_consistency();
    int tap_exists, tap_found;
    dfx_tap_port_e port_i, port_j, port_f;
    dfx_tap_state_e state_i, state_j;
    bit rv = 1'b1;

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      if (!get_config_int(tu_i.name(), tap_exists))
        tap_exists = 0;

      tap_found = 0;

      for (port_i = port_i.first(); port_i != TapNumPorts; port_i = port_i.next())
        if (tap_array[port_i][tu_i].tap_handle != null) begin
          tap_found++;
          // break; // break on first instance found
          port_f = port_i; // save port number - if more than one found, doesn't matter which is saved
        end
        // To use this "else" clause (inside the "for" loop), remove the "break" in the above "if" clause.
        // else if (tap_array[port_i][tu_i].r_tap_state != TAP_STATE_ISOLATED) begin
        //   `ovm_warning(get_type_name(), "TAP not configured, but state is not isolated - correcting")
        //   tap_array[port_i][tu_i].r_tap_state = TAP_STATE_ISOLATED;
        // end

      port_i = port_f;

      if (tap_exists) begin
        if (tap_found == 0)
          // TAP is not configured.
          `ovm_warning(get_type_name(),
                       $psprintf("TAP network inconsistent - configured TAP %s not on any port - was it removed?", tu_i.name))
        else if (tap_found == 1) begin
          // TAP is configured on port_i.

          if (tap_array[port_i][tu_i].r_tap_state > tap_array[port_i][tu_i].e_tap_state) begin
            `ovm_error(get_type_name(),
                       $psprintf("TAP network inconsistent - TAP %s - invalid combination: actual state %s, effective state %s",
                                 tu_i.name, tap_array[port_i][tu_i].r_tap_state.name,
                                 tap_array[port_i][tu_i].e_tap_state.name))
            rv = 1'b0;
          end

          if (tap_tree[tu_i].mode) begin
            if (tap_configured(tap_tree[tu_i].primary_tap, port_j, state_j) &&
                r_tap_configured(tap_tree[tu_i].primary_tap, port_f, state_i)) begin

              if (port_j != port_f)
                `ovm_fatal(get_type_name(), "Internal error in TAP network class")

              if (port_i != port_j) begin
                `ovm_error(get_type_name(),
                           $psprintf("TAP network inconsistent - TAP %s and its primary TAP %s are on different ports",
                                     tu_i.name, tap_tree[tu_i].primary_tap.name))
                rv = 1'b0;
              end

              if (tap_array[port_i][tu_i].r_tap_state != state_i) begin
                `ovm_error(get_type_name(),
                           $psprintf("TAP network inconsistent - TAP %s and its primary TAP %s have different real states",
                                     tu_i.name, tap_tree[tu_i].primary_tap.name))
                rv = 1'b0;
              end

              if (tap_array[port_i][tu_i].e_tap_state != state_j) begin
                `ovm_error(get_type_name(),
                           $psprintf("TAP network inconsistent - TAP %s and its primary TAP %s have different effective states",
                                     tu_i.name, tap_tree[tu_i].primary_tap.name))
                rv = 1'b0;
              end
            end
            else begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - TAP %s configured, but not its primary TAP %s",
                                   tu_i.name, tap_tree[tu_i].primary_tap.name))
              rv = 1'b0;
            end
          end

          if (tap_tree[tu_i].w_tap) begin
            // WTAP
            if (tap_array[port_i][tu_i].r_tap_state != TAP_STATE_NORMAL &&
                tap_array[port_i][tu_i].r_tap_state != TAP_STATE_ISOLATED) begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - WTAP %s in invalid state %s",
                                   tu_i.name, tap_array[port_i][tu_i].r_tap_state.name))
              rv = 1'b0;
            end

            if (!tap_configured(tap_tree[tu_i].master_tap, port_j, state_j)) begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - WTAP %s configured, but not its master %s",
                                   tu_i.name, tap_tree[tu_i].master_tap.name))
              rv = 1'b0;
            end

            if (state_j > tap_array[port_i][tu_i].e_tap_state) begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - WTAP %s should have less accessibility", tu_i.name))
              rv = 1'b0;
            end

            if (tap_array[port_i][tu_i].e_tap_state != state_j &&
                tap_array[port_i][tu_i].e_tap_state != tap_array[port_i][tu_i].r_tap_state) begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - WTAP %s has invalid effective state", tu_i.name))
              rv = 1'b0;
            end
          end
          else if (tap_configured(tap_tree[tu_i].master_tap, port_j, state_j) &&
                   tap_tree[tap_tree[tu_i].master_tap].hierarchical &&
                   (!tap_tree[tu_i].hybrid || port_i == port_j)) begin
            // Non-WTAP slave TAP (linear, hierarchical or plain; non-hybrid) with configured hierarchical master on
            // port port_j

            if (port_i != port_j) begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - TAP %s and hierarchical master %s on different ports",
                                   tu_i.name, tap_tree[tu_i].master_tap.name))
              rv = 1'b0;
            end

            if (state_j > tap_array[port_i][tu_i].e_tap_state) begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - TAP %s should have less accessibility", tu_i.name))
              rv = 1'b0;
            end

            if (tap_array[port_i][tu_i].e_tap_state != state_j &&
                tap_array[port_i][tu_i].e_tap_state != tap_array[port_i][tu_i].r_tap_state) begin
              `ovm_error(get_type_name(),
                         $psprintf("TAP network inconsistent - TAP %s has invalid effective state", tu_i.name))
              rv = 1'b0;
            end
          end
        end
        else if (tap_found > 1) begin
          // TAP is configured too many times.
          `ovm_error(get_type_name(),
                     $psprintf("TAP network inconsistent - same configured TAP %s on more than one port", tu_i.name))
          return 1'b0;
        end
      end
      else if (tap_found) begin
        `ovm_error(get_type_name(),
                   {"TAP network inconsistent - TAP ", tu_i.name, " not configured but found on one or more ports"})
        return 1'b0;
      end
    end

    return rv;
  endfunction : ensure_consistency

  // Move a TAP to the specified port.
  //
  // Do not change the port for a WTAP or a non-hybrid slave TAP whose master is hierarchical.
  //
  // This function essentially calls the recursive version of this function.
  //
  // Return 1'b1 if all goes well, 0 otherwise.
  //
  function bit change_tap_port(dfx_tap_unit_e tu, dfx_tap_port_e port);
    int tap_exists = 0;
    dfx_tap_port_e port_i, port_j;
    dfx_tap_state_e state_i, state_j;

    if (!get_config_int(tu.name(), tap_exists) || !tap_exists) begin
      `ovm_error(get_type_name(), "TAP not in configuration, cannot change port")
      return 1'b0;
    end

    if (tap_tree[tu].w_tap)
      `ovm_error(get_type_name(), $psprintf("Cannot directly change port for WTAP %s", tu.name()))
    else if ((tu != tap_tree[tu].master_tap) &&
             tap_tree[tap_tree[tu].master_tap].hierarchical &&
             r_tap_configured(tap_tree[tu].master_tap, port_j, state_j) &&
             !tap_tree[tu].hybrid)
      // The port of a non-hybrid TAP whose (configured) master is a hierarchical TAP cannot be changed directly.
      `ovm_error(get_type_name(),
                 $psprintf("Cannot directly change port for slave TAP %s (whose master is hierarchical)", tu.name()))

    if (tap_tree[tu].mode) begin
      `ovm_error(get_type_name(), $psprintf("Cannot directly change port for dependant TAP %s", tu.name()))
      return 1'b0;
    end

    if (!ensure_consistency)
      return 1'b0;

    // The TAP whose port is being changed is not a WTAP.  It may be a linear or hierarchical TAP, or a plain slave TAP;
    // it may be a hybrid TAP (with a hierarchical master) or its master is a non-hierarchical TAP or its master is not
    // configured.
    //
    if (!change_subtree_tap_port(tu, port)) begin
      `ovm_error(get_type_name(), $psprintf("Could not change TAP %s port to %s", tu.name, port.name))
      return 1'b0;
    end

    // Change port of any dependant TAPs at this time.
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next())
      if (tap_tree[tu_i].mode &&
          tap_configured(tu_i, port_i, state_i) &&
          tap_configured(tap_tree[tu_i].primary_tap, port_j, state_j) && port_i != port_j) begin
        // Any necessary checks (of primary and dependant TAPs) will be taken care of in ensure_consistency() function.
        tap_array[port_j][tu_i] = tap_array[port_i][tu_i];
        tap_array[port_i][tu_i].tap_handle = null;
      end

    if (!ensure_consistency)
      return 1'b0;

    return 1'b1;
  endfunction : change_tap_port

  // Move the specified TAP to the specified port.
  //
  // If the TAP has WTAPs, move those WTAPs also to the same port.
  //
  // If the specified TAP is hierarchical and has slave TAPs, move the configured slave TAPs also to the same port
  // (recursively).
  //
  // Return 1'b1 if all goes well, 0 otherwise.
  //
  local function bit change_subtree_tap_port(dfx_tap_unit_e tu, dfx_tap_port_e port);
    dfx_tap_port_e port_i, port_j;
    dfx_tap_state_e state_i, state_j;

    if (!r_tap_configured(tu, port_i, state_i)) begin
      `ovm_error(get_type_name(), $psprintf("TAP %s not configured, cannot change port", tu.name))
      return 1'b0;
    end

    if (port == port_i) begin
      `ovm_warning(get_type_name(), $psprintf("TAP %s already on port %s, nothing to do", tu.name, port.name))
      return 1'b1; // or continue with the slave TAPs, just to be safe?
    end

    if (tap_tree[tu].mode) begin
      `ovm_info(get_type_name(), $psprintf("change_subtree_tap_port(): Skipping dependant TAP %s", tu.name()), OVM_HIGH)
      return 1'b1;
    end

    tap_array[port][tu] = tap_array[port_i][tu];
    tap_array[port_i][tu].tap_handle = null;

    // When changing the port of a hybrid TAP, the hybrid TAP's effective state may also need to be changed.  However,
    // since the controlling TAP has to be in Normal state in order to change the hybrid TAP's port, this case shouldn't
    // really arise.

    // Change port for WTAPs also.
    for (int j = 0; j < tap_tree[tu].w_taps.size(); j++)
      if (r_tap_configured(tap_tree[tu].w_taps[j], port_j, state_j)) begin
        if (port_j != port_i) begin
          // This is an extra (redundant?) check, just to be safe.
          `ovm_error(get_type_name(),
                     $psprintf("WTAP %s not on the same port as its master TAP", tap_tree[tu].w_taps[j].name()))
          return 1'b0;
        end

        if (!change_subtree_tap_port(tap_tree[tu].w_taps[j], port)) begin
          `ovm_error(get_type_name(),
                     $psprintf("Could not change TAP %s port to %s", tap_tree[tu].w_taps[j].name, port.name))
          return 1'b0;
        end
      end

    if (tap_tree[tu].hierarchical)
      // Recursively change port for slave TAPs also.

      for (int j = 0; j < tap_tree[tu].s_taps.size(); j++)
        if (r_tap_configured(tap_tree[tu].s_taps[j], port_j, state_j)) begin
          if (port_j != port_i && !tap_tree[tap_tree[tu].s_taps[j]].hybrid) begin
            // This is an extra (redundant?) check, just to be safe.
            `ovm_error(get_type_name(),
                       $psprintf("Slave TAP %s of hierarchical TAP %s not on the same port as its master TAP",
                                 tap_tree[tu].s_taps[j].name(), tu.name))
            return 1'b0;
          end

          // If a slave TAP is a hybrid TAP, and it's already on a different port than its hierarchical master, then it
          // is illegal to change its master's port.

          if (!change_subtree_tap_port(tap_tree[tu].s_taps[j], port)) begin
            `ovm_error(get_type_name(),
                       $psprintf("Could not change TAP %s port to %s", tap_tree[tu].s_taps[j].name, port.name))
            return 1'b0;
          end
        end

    return 1'b1;
  endfunction : change_subtree_tap_port

  // Change a TAP state.
  //
  // Return 1'b1 if all goes well, 0 otherwise.
  //
  function bit change_tap_state(dfx_tap_unit_e tu, dfx_tap_state_e state);
    int tap_exists = 0;
    dfx_tap_port_e port_i, port_j;
    dfx_tap_state_e state_i, state_j;

    if (!get_config_int(tu.name(), tap_exists) || !tap_exists) begin
      `ovm_error(get_type_name(),
                 $psprintf("TAP %s not in configuration, cannot change its state", tu.name))
      return 1'b0;
    end

    if (!ensure_consistency)
      return 1'b0;

    for (port_i = port_i.first(); port_i != TapNumPorts; port_i = port_i.next())
      if (tap_array[port_i][tu].tap_handle != null)
        break;

    if (port_i == TapNumPorts) begin
      `ovm_error(get_type_name(), $psprintf("TAP %s not configured, cannot change state", tu.name))
      return 1'b0;
    end

    if (state != tap_array[port_i][tu].r_tap_state) begin

      if (tap_tree[tu].mode) begin
        `ovm_error(get_type_name(), $psprintf("Cannot directly change state of dependant TAP %s", tu.name()))
        return 1'b0;
      end

      if (tap_tree[tu].w_tap) begin

        // This case is needed only to deal with a state override.
        if (!r_tap_configured(tap_tree[tu].master_tap, port_j, state_j)) begin
          // This case should never arise during simulation.
          `ovm_error(get_type_name(),
                     $psprintf("TAP network inconsistent - WTAP %s configured, but not its master", tu.name))
          return 1'b0;
        end
      end

      tap_array[port_i][tu].r_tap_state = state;

      // During simulation, this TAP's master TAP must always be configured and in NORMAL state - or else this TAP's
      // state couldn't be changed.

      // Fix accessibility for sub-tree.
      if (!change_subtree_tap_access(tu, port_i /*, state */)) begin
        `ovm_error(get_type_name(),
                   $psprintf("Could not change TAP %s sub-tree access settings", tu.name))
        return 1'b0;
      end
    end else
      `ovm_warning(get_type_name(), $psprintf("TAP %s already in desired state", tu.name))

    // Change states of any dependant TAPs at this time.
    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      dfx_tap_state_e state_ii, state_jj;

      if (tap_tree[tu_i].mode &&
          r_tap_configured(tu_i, port_i, state_i) &&
          tap_configured(tu_i, port_i, state_ii) && // same port_i
          r_tap_configured(tap_tree[tu_i].primary_tap, port_j, state_j) &&
          tap_configured(tap_tree[tu_i].primary_tap, port_j, state_jj) && // same port_j
          (state_i != state_j || state_ii != state_jj)) begin
        // Any necessary checks (of primary and dependant TAPs) will be taken care of in ensure_consistency() function.
        // port_i == port_j
        tap_array[port_i][tu_i].r_tap_state = state_j;
        tap_array[port_i][tu_i].e_tap_state = state_jj;
      end
    end

    if (!ensure_consistency)
      return 1'b0;

    return 1'b1;
  endfunction : change_tap_state

  // Change TAP effective state.
  //
  // If the TAP has WTAPs, set the effective states for the WTAPs.
  //
  // If the specified TAP is hierarchical, set the effective state recursively for every configured slave TAP.
  //
  // Return 1'b1 if all goes well, 0 otherwise.
  //
  local function bit change_subtree_tap_access(dfx_tap_unit_e tu, dfx_tap_port_e port /* , dfx_tap_state_e state */);
    dfx_tap_port_e port_j;
    dfx_tap_state_e state_j;

    if (tap_tree[tu].mode) begin
      `ovm_info(get_type_name(), $psprintf("change_subtree_tap_access(): Skipping dependant TAP %s", tu.name()), OVM_HIGH)
      return 1'b1;
    end

    tap_array[port][tu].e_tap_state = tap_array[port][tu].r_tap_state; // default effective state

    if (tap_configured(tap_tree[tu].master_tap, port_j, state_j)) begin
      // Master TAP is configured and decides the inaccesibility setting on this TAP.

      if (tap_tree[tu].w_tap || tap_tree[tap_tree[tu].master_tap].hierarchical) begin
        if (!tap_tree[tu].hybrid && port_j != port) begin
          `ovm_error(get_type_name(),
                     $psprintf("WTAP/sTAP %s not on the same port as its (hierarchical) master TAP", tu.name()))
          return 1'b0;
        end

        if (!tap_tree[tu].hybrid || port_j == port)
          if (state_j > tap_array[port][tu].r_tap_state)
            tap_array[port][tu].e_tap_state = state_j;
          /*
          else
            tap_array[port][tu].e_tap_state = tap_array[port][tu].r_tap_state;
           */
      end
    end

    // Deal with this TAP's WTAPs, if any.
    for (int j = 0; j < tap_tree[tu].w_taps.size(); j++)
      if (r_tap_configured(tap_tree[tu].w_taps[j], port_j, state_j))
        if (!change_subtree_tap_access(tap_tree[tu].w_taps[j], port_j /* , state_j */)) begin
          `ovm_error(get_type_name(),
                     $psprintf("Could not change TAP %s sub-tree access settings", tap_tree[tu].w_taps[j].name))
          return 1'b0;
        end

    if (tap_tree[tu].hierarchical)
      // Recursively set effective state for slave TAPs also.
      for (int j = 0; j < tap_tree[tu].s_taps.size(); j++)
        if (r_tap_configured(tap_tree[tu].s_taps[j], port_j, state_j))
          if (!change_subtree_tap_access(tap_tree[tu].s_taps[j], port_j /* , state_j */)) begin
            `ovm_error(get_type_name(),
                       $psprintf("Could not change TAP %s sub-tree access settings", tap_tree[tu].s_taps[j].name))
            return 1'b0;
          end

    return 1'b1;
  endfunction : change_subtree_tap_access

  // Remove a TAP from the TAP network.
  //
  // Note: This does not affect any of the TAP's slave TAPs.
  //
  function bit remove_tap(dfx_tap_unit_e tap);
    dfx_tap_port_e port;
    dfx_tap_state_e state;

    if (r_tap_configured(tap, port, state)) begin
      tap_array[port][tap].tap_handle = null;
      tap_array[port][tap].r_tap_state = TAP_STATE_ISOLATED; // unnecessary, but good practice
      tap_array[port][tap].e_tap_state = TAP_STATE_ISOLATED; // unnecessary, but good practice
      return 1'b1;
    end
    else begin
      `ovm_error(get_type_name(), $psprintf("TAP %s not configured; cannot remove it", tap.name))
      return 1'b0;
    end

    // Remove any WTAPs and dependant TAPs.
    // Note: WTAP masters and primary TAPs probably don't even provide the TAP REMOVE instruction.
    for (dfx_tap_unit_e tu = tu.first(); tu != NUM_TAPS; tu = tu.next())
      if (tap_tree[tu].w_tap && tap_tree[tu].master_tap == tap && tap_configured(tu, port, state) ||
          tap_tree[tu].mode && tap_tree[tu].primary_tap == tap && tap_configured(tu, port, state)) begin
        // Any necessary checks (of primary and dependant TAPs) will be taken care of in ensure_consistency() function.
        tap_array[port][tu].tap_handle = null;
        tap_array[port][tu].r_tap_state = TAP_STATE_ISOLATED;
        tap_array[port][tu].e_tap_state = TAP_STATE_ISOLATED;
      end

    ensure_consistency;

  endfunction : remove_tap

endclass : dfx_tap_network

`endif // `ifndef DFX_TAP_NETWORK_SV
