// =====================================================================================================
// FileName          : dfx_tap_driver.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Tue Jun  1 12:57:09 CDT 2010
// Last Modified     : Thu Aug  5 15:14:27 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP Driver
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_DRIVER_SV
`define DFX_TAP_DRIVER_SV

// TAP controller driver class.
//
// This driver works for a single TAP controller as well as a network of TAP controllers.
//
class dfx_tap_driver extends ovm_driver #(dfx_tap_base_transaction);

  ovm_verbosity my_verbosity = OVM_LOW;

  protected dfx_tap_port_e port; // TAP port
  /* local - change access to public; RDH ITPP/Si-Mode requirement */ dfx_tapfsm_state_e cts; // current TAP state
  // local bit trst_asserted; // TRST asserted here
  protected int RESET_DELAY = 1; // SIP compatibility, default value is 1 if not set by user
  protected int initial_delay = 1; // delay amount before driving pins
  local bit on_demand_tck = 1'b0;
  local bit avoid_race = 1'b0;
  local dfx_tap_scan_format_e scan_format = TAP_SCAN_NORMAL; // 4-pin format/mode is the default
  local bit sredge = 1'b0; // if 1'b1, sample TDO value on falling edge of TCK (when in 2-pin mode)

  `ovm_component_utils_begin(dfx_tap_driver)
    `ovm_field_enum(dfx_tap_port_e, port, OVM_DEFAULT)
    `ovm_field_int(RESET_DELAY, OVM_DEFAULT)
  `ovm_component_utils_end

  extern function new(string name, ovm_component parent = null);

  extern function void set_initial_state;

  extern task set_initial_signals(int tck_cycs = 0); // called from run()

  extern function void build();

  // extern function void connect();

  extern task run();

  extern task emit_ts_event();

  extern task run_initial();
  extern task run_mode(dfx_tap_scan_mode_transaction smt);
  extern task run_escape();
  extern task run_tms();
  extern virtual task run_normal();

  // extern function void set_port(dfx_tap_port_e port);

  // For both IR-scan and DR-scan, when scanning in/out a vector, such as "vec", vec[0] is scanned in/out first, then
  // vec[1], and so on.

  extern task scan_ir(const ref dfx_node_t instr[], ref dfx_node_t instr_out[], input dfx_tapfsm_state_e fs = DFX_TAP_TS_RTI);

  extern task scan_dr(const ref dfx_node_t data[], ref dfx_node_t data_out[], input dfx_tapfsm_state_e fs = DFX_TAP_TS_RTI);

  extern task scan_with_tms(const ref dfx_node_t tms_ary[], const ref dfx_node_t tdi_ary[], ref dfx_node_t tdo_ary[]);

  // Move TAP from its current state to the specified state.
  //
  extern local task move_tap(dfx_tapfsm_state_e nts);

  // Update TAP state based upon current state and TMS value.
  //
  extern local function void update_tap(input dfx_node_t tms_val);

  extern protected task pre_scan;
  extern protected task post_scan;

  extern protected task drive_jtag(input dfx_node_t tms, tdi, output tdo);
  extern local task drive_4pin(input dfx_node_t tms, tdi, output tdo);
  extern local task drive_2pin(input dfx_node_t tms, tdi, output tdo);

  extern function dfx_tapfsm_state_e get_current_fsm_state();
  extern protected function dfx_tapfsm_state_e get_next_fsm_state(input dfx_tapfsm_state_e istate, dfx_node_t tms_val);
  extern protected function bit get_tms_for_fsm_transition(input dfx_tapfsm_state_e cur_state, nxt_state);
  extern protected virtual task print_stim();

  local virtual dfx_jtag_if.TEST jtag_if;

  // Class to help randomize TRST assertion duration.
  class rst_delay;
    rand int delay_factor;
    constraint c {
      delay_factor dist {1 := 5, 2 := 5, 3 := 2};
    }
  endclass : rst_delay

  protected realtime tck_period = 1; // valid until TCK period is measured

  extern protected task measure_tck_period();

endclass : dfx_tap_driver

function dfx_tap_driver::new(string name, ovm_component parent = null);
  super.new(name, parent);
  // cts = DFX_TAP_TS_TLR;

  if (!$cast(my_verbosity, get_report_verbosity_level()))
    `ovm_fatal(get_type_name(), "OVM verbosity not a valid enum value")
endfunction : new

function void dfx_tap_driver::set_initial_state;
  dfx_tapfsm_state_e tap_fsm_state; // current TAP state
  // dfx_node_t tms_sig;

  // trst_asserted = 1'b0;

  if (get_config_int({"dfx_tap_fsm_initial_state_", port.name()}, tap_fsm_state))
    cts = tap_fsm_state;
  else begin
    if (port == TAP_PORT_P0)
      cts = DFX_TAP_TS_TLR;
    else
      cts = DFX_TAP_TS_RTI; // TAPs will be placed on secondary port(s) in RTI state
  end

  // if (cts == DFX_TAP_TS_TLR)
  //   tms_sig = 1'b1;
  // else
  //   cts == DFX_TAP_TS_RTI?
  //   If some other state, then what should initial TMS value be?  If TMS is set to 1 instead of 0, FSM will eventually
  //   cycle back to TLR state if TMS is not driven right away.
  //
  // tms_sig = 1'b0;

  // `ovm_info(get_type_name(), $psprintf("TAP port %s initial FSM state set to %s", port.name(), cts.name()), OVM_HIGH)
  `ovm_info(get_type_name(), $psprintf("TAP port %s initial FSM state set to %s", port.name(), cts.name()), OVM_NONE)
  // `ovm_info(get_type_name(), "Note:  Initial default FSM state is TLR for primary port and RTI for other ports", OVM_HIGH)
  `ovm_info(get_type_name(), "Note:  Initial default FSM state is TLR for primary port and RTI for other ports", OVM_NONE)

  // jtag_if.n_sigs.tms <= tms_sig;
  // jtag_if.tms = tms_sig;
  // `ovm_info(get_type_name(), $psprintf("TAP port %s initial TMS value set to %d", port.name(), tms_sig), OVM_HIGH)

  // `ovm_info(get_type_name(), "Setting scan format (JTAG mode) to 4-pin", OVM_HIGH)
  `ovm_info(get_type_name(), "Setting scan format (JTAG mode) to 4-pin", OVM_NONE)
  scan_format = TAP_SCAN_NORMAL;

  sredge = 1'b0; // only relevant in 2-pin mode

endfunction : set_initial_state

task dfx_tap_driver::set_initial_signals(int tck_cycs = 0);
  dfx_node_t tms_sig;

  if (cts == DFX_TAP_TS_TLR)
    tms_sig = 1'b1;
  else
    // cts == DFX_TAP_TS_RTI?
    // If some other state, then what should initial TMS value be?  If TMS is set to 1 instead of 0, FSM will eventually
    // cycle back to TLR state if TMS is not driven right away.
    tms_sig = 1'b0;

  // jtag_if.n_sigs.tms <= tms_sig;
  jtag_if.tms = tms_sig;
  // `ovm_info(get_type_name(), $psprintf("TAP port %s initial TMS value set to %d", port.name(), tms_sig), OVM_HIGH)
  `ovm_info(get_type_name(), $psprintf("TAP port %s initial TMS value set to %d", port.name(), tms_sig), OVM_NONE)

  // Wait requested number of full TCK cycles.
  // @(negedge jtag_if.tck);
  jtag_if.tck_enable = 1'b1;
  // repeat (tck_cycs) @(posedge jtag_if.tck);
  repeat (tck_cycs) @(negedge jtag_if.tck);

  if (on_demand_tck) begin
    jtag_if.tck_enable = 1'b0;
    // `ovm_info(get_type_name(), $psprintf("TAP port %s tck_enable value set to %0d", port.name(), 0), OVM_HIGH)
    `ovm_info(get_type_name(), $psprintf("TAP port %s tck_enable value set to %0d", port.name(), 0), OVM_NONE)
  end
  else begin
    jtag_if.tck_enable = 1'b1;
    // `ovm_info(get_type_name(), $psprintf("TAP port %s tck_enable value set to %0d", port.name(), 1), OVM_HIGH)
    `ovm_info(get_type_name(), $psprintf("TAP port %s tck_enable value set to %0d", port.name(), 1), OVM_NONE)
  end

endtask : set_initial_signals

task dfx_tap_driver::measure_tck_period();
  realtime rt1, rt2;

  @jtag_if.tck rt1 = $realtime;
  `ovm_info(get_type_name(), $psprintf("Initial time for TCK period measurement = %0t", rt1), OVM_DEBUG)
  repeat (2) @jtag_if.tck rt2 = $realtime;
  `ovm_info(get_type_name(), $psprintf("Final time for TCK period measurement = %0t", rt2), OVM_DEBUG)

  tck_period = rt2 - rt1;
  `ovm_info(get_type_name(), $psprintf("Measured TCK period = %0t", tck_period), OVM_DEBUG)

endtask : measure_tck_period

function void dfx_tap_driver::build();
  int odtck = 0, ar = 0;
  ovm_object o_obj;
  dfx_vif_container #(virtual dfx_jtag_if) vif;
  string s;

  super.build();

  $sformat(s, "Port found: %s", port.name());
  // `ovm_info(get_type_name(), s, OVM_HIGH)
  `ovm_info(get_type_name(), s, OVM_NONE)

  s = {"jtag_vif_", port.name()};
  if (get_config_object(s, o_obj, 0) == 0)
    `ovm_fatal(get_type_name(), {"No JTAG interface available for port ", port.name()})
  if (!$cast(vif, o_obj))
    `ovm_fatal(get_type_name(), "JTAG interface not the right type")

  // `ovm_info(get_type_name(), {"JTAG interface found for port ", port.name()}, OVM_HIGH)
  `ovm_info(get_type_name(), {"JTAG interface found for port ", port.name()}, OVM_NONE)
  jtag_if = vif.get_v_if();
  if (jtag_if == null)
    `ovm_fatal(get_type_name(), {"jtag_if not set in jtag_vif_", port.name()})

  if (!get_config_int({"dfx_tap_on_demand_tck_", port.name()}, odtck))
    odtck = 0; // necessary?

  if (odtck > 0) begin
    on_demand_tck = 1'b1;
    // `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will use on-demand TCK", port.name()), OVM_HIGH)
    `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will use on-demand TCK", port.name()), OVM_NONE)
    // jtag_if.tck_enable = 1'b0;
  end else begin
    on_demand_tck = 1'b0;
    // `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will use free-running TCK", port.name()), OVM_HIGH)
    `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will use free-running TCK", port.name()), OVM_NONE)
    // jtag_if.tck_enable = 1'b1;
  end

  if (!get_config_int({"dfx_tap_avoid_race_", port.name()}, ar))
    ar = 0;

  if (ar > 0) begin
    avoid_race = 1'b1;
    // `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will strictly avoid race conditions", port.name()), OVM_HIGH)
    `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will strictly avoid race conditions", port.name()), OVM_NONE)
  end else begin
    avoid_race = 1'b0;
    // `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will avoid most race conditions", port.name()), OVM_HIGH)
    `ovm_info(get_type_name(), $psprintf("TAP driver for port %s will avoid most race conditions", port.name()), OVM_NONE)
  end

  `ovm_info(get_type_name(), $psprintf("RESET_DELAY = %0d", RESET_DELAY), OVM_DEBUG)

  if (!get_config_int({"dfx_tap_initial_delay_", port.name()}, initial_delay))
    initial_delay = 1; // legacy

  set_initial_state;

endfunction : build

task dfx_tap_driver::run();
  dfx_tap_powergood_transaction pgt;
  dfx_tap_scan_mode_transaction smt;
  dfx_tap_escape_sequence_transaction est;
  string s;

  fork
    measure_tck_period;
  join_none

  // Add slight delay to avoid conflict with TMS/TRST values set at t = 0.
  // #1ns;
  // #1;
  `ovm_info(get_type_name(), $sformatf("run(): Waiting initial_delay amount of %0d", initial_delay), OVM_FULL)
  #initial_delay; // user configurable initial delay
  `ovm_info(get_type_name(), "run(): Done waiting initial_delay amount", OVM_FULL)
 

  set_initial_signals;

  /********
   #1ns;
   jtag_if.trst = 1; // force TAP out of test reset (for now) - FIXME!!!
   ********/

  forever begin
    `ovm_info(get_type_name(), "run(): Waiting for a transaction", OVM_FULL)
    seq_item_port.get_next_item(req);

    `ovm_info(get_type_name(), "run(): Received item: ", OVM_FULL)
    if (my_verbosity >= OVM_FULL)
      req.print();

    // Compose instruction and data streams - transaction item decides how to compose them.
    req.compose(port);

    `ovm_info(get_type_name(), "run(): Item after composition: ", OVM_FULL)
    if (my_verbosity >= OVM_FULL)
      req.print();

    // This scheme can be made more general, but there are only a few cases currently, so this is still not too complex.
    if ($cast(pgt, req))
      run_initial;
    else if ($cast(smt, req))
      run_mode(smt);
    else if ($cast(est, req))
      run_escape;
    else if (req.assert_trst)
      run_tms();
    else if (req.tms_in.size() > 0)
      run_tms();
    else
      run_normal();

    `ovm_info(get_type_name(), "run(): Item after scanning: ", OVM_FULL)
    if (my_verbosity >= OVM_FULL)
      req.print();

    // Decompose instruction and data streams - transaction item decides how to decompose them.
    req.decompose(port);

    `ovm_info(get_type_name(), "run(): Item after decomposition: ", OVM_FULL)
    if (my_verbosity >= OVM_FULL)
      req.print();

    seq_item_port.item_done();
  end
endtask : run

task dfx_tap_driver::emit_ts_event();

  -> jtag_if.FSM_Event;

  if (cts == DFX_TAP_TS_SHIFT_DR)
    -> jtag_if.SHIFT_DR_Event;
  else if (cts == DFX_TAP_TS_EXIT1_DR)
    -> jtag_if.EXIT1_DR_Event;
  else if (cts == DFX_TAP_TS_UPDATE_IR)
    -> jtag_if.UPDATE_IR_Done_Event;
  else if (cts == DFX_TAP_TS_UPDATE_DR)
    -> jtag_if.UPDATE_DR_Done_Event;

endtask : emit_ts_event

task dfx_tap_driver::run_initial();

  // `ovm_info(get_type_name(), {"Resetting TAP driver for port ", port.name, " to initial (PowerGood) state"}, OVM_HIGH)
  `ovm_info(get_type_name(), {"Resetting TAP driver for port ", port.name, " to initial (PowerGood) state"}, OVM_NONE)

  set_initial_state;

  set_initial_signals(req.tms_in.size);

  // `ovm_info(get_type_name(), {"Finished resetting TAP driver for port ", port.name, " to initial (PowerGood) state"}, OVM_HIGH)
  `ovm_info(get_type_name(), {"Finished resetting TAP driver for port ", port.name, " to initial (PowerGood) state"}, OVM_NONE)

endtask : run_initial

task dfx_tap_driver::run_mode(dfx_tap_scan_mode_transaction smt);
  string s;

  // `ovm_info(get_type_name(), {"Changing scan format (JTAG mode) for port ", port.name, " to ", smt.scan_format.name}, OVM_HIGH)
  `ovm_info(get_type_name(), {"Changing scan format (JTAG mode) for port ", port.name, " to ", smt.scan_format.name}, OVM_NONE)
  scan_format = smt.scan_format;

  sredge = smt.sredge;
  s = sredge ? "falling" : "rising";
  // `ovm_info(get_type_name(), {"TDO will be sampled on the ", s, " edge of TCK for port ", port.name}, OVM_HIGH)
  `ovm_info(get_type_name(), {"TDO will be sampled on the ", s, " edge of TCK for port ", port.name}, OVM_NONE)

endtask : run_mode

task dfx_tap_driver::run_escape();

  `ovm_info(get_type_name(),
            $psprintf("Running escape sequence of length %0d for port %s", req.tms_in.size, port.name),
            // OVM_FULL)
            OVM_NONE)

  pre_scan;

  jtag_if.tck_high = 1'b1;

  foreach (req.tms_in[i]) begin
    jtag_if.tms = req.tms_in[i];
    @(negedge jtag_if.tck_in);
  end

  post_scan;

  jtag_if.tck_high = 1'b0;

  // `ovm_info(get_type_name(), "Finished running escape sequence", OVM_FULL)
  `ovm_info(get_type_name(), "Finished running escape sequence", OVM_NONE)

endtask : run_escape

task dfx_tap_driver::run_tms();
  string s;
  rst_delay rd = new;
  realtime trst_dur;

  // print_stim(); // print_stim() requires that req be of type dfx_tap_multiple_taps_transaction_b

  // Drive TAP port using tms_in[] and tdi_in[] arrays.  Collect TDO bits in tdo_out[] array.

  $sformat(s, "Assert TRST = %0d", req.assert_trst);
  // `ovm_info(get_type_name(), s, OVM_FULL)
  `ovm_info(get_type_name(), s, OVM_NONE)
  $sformat(s, "Total TMS size = %0d", req.tms_in.size());
  // `ovm_info(get_type_name(), s, OVM_FULL)
  `ovm_info(get_type_name(), s, OVM_NONE)
  $sformat(s, "Total TDI size = %0d", req.tdi_in.size());
  // `ovm_info(get_type_name(), s, OVM_FULL)
  `ovm_info(get_type_name(), s, OVM_NONE)

  if (req.assert_trst) begin
    `ovm_info (get_type_name(), "Asserting TRST", OVM_FULL)
    jtag_if.trst = 1'b0;
    cts = DFX_TAP_TS_TLR;

    if (!req.tdi_in.size()) begin
      if (!rd.randomize())
        `ovm_error(get_type_name(), "Treset time randomization failed")

      `ovm_info(get_type_name(), $psprintf("delay_factor (divisor) for TRST duration = %0d", rd.delay_factor), OVM_DEBUG)
      `ovm_info(get_type_name(), $psprintf("TCK period used in calculation = %0t", tck_period), OVM_DEBUG)
      trst_dur = (RESET_DELAY * tck_period) / rd.delay_factor;
      `ovm_info(get_type_name(), $psprintf("TRST duration = %0t", trst_dur), OVM_DEBUG)

      #trst_dur;
    end
  end

  if (req.tdi_in.size()) begin
    pre_scan;
    scan_with_tms(req.tms_in, req.tdi_in, req.tdo_out); // drive TMS/TDI
    post_scan;
  end

  if (req.assert_trst) begin
    `ovm_info (get_type_name(), "Deasserting TRST", OVM_FULL)
    jtag_if.tms = 1'b1;
    // `ovm_info(get_type_name(), $psprintf("TAP port %s TMS value set to %d", port.name(), 1'b1), OVM_FULL)
    `ovm_info(get_type_name(), $psprintf("TAP port %s TMS value set to %d", port.name(), 1'b1), OVM_NONE)

    jtag_if.trst = 1'b1;
  end

  if (req.ts != cts) begin
    `ovm_warning(get_type_name(), "Final TAP FSM state does not match final state specified in TAP transaction")
    // req.ts = cts; // correct it
  end

endtask : run_tms

task dfx_tap_driver::run_normal();
  `ovm_error(get_type_name(), dfx_tap_build_error_message)
endtask : run_normal

task dfx_tap_driver::move_tap(dfx_tapfsm_state_e nts);
  dfx_node_t tdi = 1'b0, tdo;

  // Ensure that current TAP state is defined.
  if (cts == DFX_TAP_TS_UNKNOWN)
    `ovm_error(get_type_name(), "move_tap(): Starting TAP state is unknown!")

  // `ovm_info(get_type_name(), $psprintf("Moving TAP FSM from state %s to state %s", cts.name, nts.name), OVM_FULL)
  `ovm_info(get_type_name(), $psprintf("Moving TAP FSM from state %s to state %s", cts.name, nts.name), OVM_HIGH)

  while (cts != nts)
    case (cts)
      DFX_TAP_TS_TLR:
           begin
             drive_jtag(1'b0, tdi, tdo);
             cts = DFX_TAP_TS_RTI;
           end
      DFX_TAP_TS_RTI:
        begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_SELECT_DR;
        end
      DFX_TAP_TS_SELECT_DR:
        if (nts == DFX_TAP_TS_CAPTURE_DR ||
            nts == DFX_TAP_TS_SHIFT_DR ||
            nts == DFX_TAP_TS_EXIT1_DR ||
            nts == DFX_TAP_TS_PAUSE_DR ||
            nts == DFX_TAP_TS_EXIT2_DR ||
            nts == DFX_TAP_TS_UPDATE_DR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_CAPTURE_DR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_SELECT_IR;
        end
      DFX_TAP_TS_CAPTURE_DR:
        if (nts == DFX_TAP_TS_SHIFT_DR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_SHIFT_DR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_EXIT1_DR;
        end
      DFX_TAP_TS_SHIFT_DR:
        begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_EXIT1_DR;
        end
      DFX_TAP_TS_EXIT1_DR:
        if (nts == DFX_TAP_TS_PAUSE_DR ||
            nts == DFX_TAP_TS_EXIT2_DR ||
            nts == DFX_TAP_TS_SHIFT_DR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_PAUSE_DR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_UPDATE_DR;
        end
      DFX_TAP_TS_PAUSE_DR:
        begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_EXIT2_DR;
        end
      DFX_TAP_TS_EXIT2_DR:
        if (nts == DFX_TAP_TS_SHIFT_DR ||
            nts == DFX_TAP_TS_EXIT1_DR ||
            nts == DFX_TAP_TS_PAUSE_DR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_SHIFT_DR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_UPDATE_DR;
        end
      DFX_TAP_TS_UPDATE_DR:
        if (nts == DFX_TAP_TS_RTI) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_RTI;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_SELECT_DR;
        end
      DFX_TAP_TS_SELECT_IR:
        if (nts == DFX_TAP_TS_CAPTURE_IR ||
            nts == DFX_TAP_TS_SHIFT_IR ||
            nts == DFX_TAP_TS_EXIT1_IR ||
            nts == DFX_TAP_TS_PAUSE_IR ||
            nts == DFX_TAP_TS_EXIT2_IR ||
            nts == DFX_TAP_TS_UPDATE_IR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_CAPTURE_IR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_TLR;
        end
      DFX_TAP_TS_CAPTURE_IR:
        if (nts == DFX_TAP_TS_SHIFT_IR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_SHIFT_IR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_EXIT1_IR;
        end
      DFX_TAP_TS_SHIFT_IR:
        begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_EXIT1_IR;
        end
      DFX_TAP_TS_EXIT1_IR:
        if (nts == DFX_TAP_TS_PAUSE_IR ||
            nts == DFX_TAP_TS_EXIT2_IR ||
            nts == DFX_TAP_TS_SHIFT_IR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_PAUSE_IR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_UPDATE_IR;
        end
      DFX_TAP_TS_PAUSE_IR:
        begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_EXIT2_IR;
        end
      DFX_TAP_TS_EXIT2_IR:
        if (nts == DFX_TAP_TS_SHIFT_IR ||
            nts == DFX_TAP_TS_EXIT1_IR ||
            nts == DFX_TAP_TS_PAUSE_IR) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_SHIFT_IR;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_UPDATE_IR;
        end
      DFX_TAP_TS_UPDATE_IR:
        if (nts == DFX_TAP_TS_RTI) begin
          drive_jtag(1'b0, tdi, tdo);
          cts = DFX_TAP_TS_RTI;
        end
        else begin
          drive_jtag(1'b1, tdi, tdo);
          cts = DFX_TAP_TS_SELECT_DR;
        end
      default:
        // Data corruption? (DFX_TAP_TS_UNKNOWN already caught above.)
        `ovm_error(get_type_name(), "move_tap(): Internal error - invalid/unrecognized starting state")
    endcase // case (cts)
  // while (cts != nts)
endtask : move_tap

function void dfx_tap_driver::update_tap(input dfx_node_t tms_val);

  cts = get_next_fsm_state(cts, tms_val);

  if (!jtag_if.trst)
    cts = DFX_TAP_TS_TLR; // TRST override

endfunction : update_tap

// function get_current_fsm_state returns the current TAP FSM state
function dfx_tapfsm_state_e dfx_tap_driver::get_current_fsm_state();
  return cts;
endfunction : get_current_fsm_state

// FIXME: (ivmolcha) dfx_node_t for tms value ?
// TAP FSM definition (without trst)
function dfx_tapfsm_state_e dfx_tap_driver::get_next_fsm_state(input dfx_tapfsm_state_e istate, dfx_node_t tms_val);

  case (istate)
    DFX_TAP_TS_TLR          : return (tms_val == 1) ? DFX_TAP_TS_TLR       : DFX_TAP_TS_RTI        ;
    DFX_TAP_TS_RTI          : return (tms_val == 1) ? DFX_TAP_TS_SELECT_DR : DFX_TAP_TS_RTI        ;
    DFX_TAP_TS_SELECT_DR  : return (tms_val == 1) ? DFX_TAP_TS_SELECT_IR : DFX_TAP_TS_CAPTURE_DR ;
    DFX_TAP_TS_CAPTURE_DR : return (tms_val == 1) ? DFX_TAP_TS_EXIT1_DR  : DFX_TAP_TS_SHIFT_DR   ;
    DFX_TAP_TS_SHIFT_DR   : return (tms_val == 1) ? DFX_TAP_TS_EXIT1_DR  : DFX_TAP_TS_SHIFT_DR   ;
    DFX_TAP_TS_EXIT1_DR   : return (tms_val == 1) ? DFX_TAP_TS_UPDATE_DR : DFX_TAP_TS_PAUSE_DR   ;
    DFX_TAP_TS_PAUSE_DR   : return (tms_val == 1) ? DFX_TAP_TS_EXIT2_DR  : DFX_TAP_TS_PAUSE_DR   ;
    DFX_TAP_TS_EXIT2_DR   : return (tms_val == 1) ? DFX_TAP_TS_UPDATE_DR : DFX_TAP_TS_SHIFT_DR   ;
    DFX_TAP_TS_UPDATE_DR  : return (tms_val == 1) ? DFX_TAP_TS_SELECT_DR : DFX_TAP_TS_RTI          ;
    DFX_TAP_TS_SELECT_IR  : return (tms_val == 1) ? DFX_TAP_TS_TLR         : DFX_TAP_TS_CAPTURE_IR ;
    DFX_TAP_TS_CAPTURE_IR : return (tms_val == 1) ? DFX_TAP_TS_EXIT1_IR  : DFX_TAP_TS_SHIFT_IR   ;
    DFX_TAP_TS_SHIFT_IR   : return (tms_val == 1) ? DFX_TAP_TS_EXIT1_IR  : DFX_TAP_TS_SHIFT_IR   ;
    DFX_TAP_TS_EXIT1_IR   : return (tms_val == 1) ? DFX_TAP_TS_UPDATE_IR : DFX_TAP_TS_PAUSE_IR   ;
    DFX_TAP_TS_PAUSE_IR   : return (tms_val == 1) ? DFX_TAP_TS_EXIT2_IR  : DFX_TAP_TS_PAUSE_IR   ;
    DFX_TAP_TS_EXIT2_IR   : return (tms_val == 1) ? DFX_TAP_TS_UPDATE_IR : DFX_TAP_TS_SHIFT_IR   ;
    DFX_TAP_TS_UPDATE_IR  : return (tms_val == 1) ? DFX_TAP_TS_SELECT_DR : DFX_TAP_TS_RTI          ;

    default:
      `ovm_error(get_type_name(), $psprintf("get_next_fsm_state(): invalid/unrecognized starting state %s", istate))
  endcase // case (istate)

endfunction : get_next_fsm_state

// Function to calculate TMS value for cur_state->nxt_state fsm transition
// Error if such transition isn't possible
function bit dfx_tap_driver::get_tms_for_fsm_transition(input dfx_tapfsm_state_e cur_state, nxt_state);

  if (get_next_fsm_state(cur_state,0) == nxt_state)
    return 0;
  else if (get_next_fsm_state(cur_state,1) == nxt_state)
    return 1;
  else
    `ovm_error(get_type_name(), $psprintf("get_tms_for_fsm_transition(): Incorrent state transition %s -> %s", cur_state, nxt_state))

endfunction : get_tms_for_fsm_transition

// Scan in/out instruction bits.  The bits are scanned in/out in this order:
//
//   1st bit         2nd bit         3rd bit        ... last bit
//   scanned in/out  scanned in/out  scanned in/out     scanned in/out
//
//   ary[0]          ary[1]          ary[2]         ... ary[$size(ary) - 1]
//
task dfx_tap_driver::scan_ir(const ref dfx_node_t instr[],
                             ref dfx_node_t instr_out[],
                             input dfx_tapfsm_state_e fs = DFX_TAP_TS_RTI);
  dfx_node_t tdo;

  instr_out = new[instr.size()];

  move_tap(DFX_TAP_TS_SHIFT_IR);

  foreach (instr[i]) begin
    if (i < instr.size() - 1)
      drive_jtag(1'b0, instr[i], tdo);
    else begin
      if (fs == DFX_TAP_TS_SHIFT_IR)
        drive_jtag(1'b0, instr[i], tdo);
      else
        drive_jtag(1'b1, instr[i], tdo);
    end

    instr_out[i] = tdo;
  end

  move_tap(fs);
endtask : scan_ir

task dfx_tap_driver::scan_dr(const ref dfx_node_t data[],
                             ref dfx_node_t data_out[],
                             input dfx_tapfsm_state_e fs = DFX_TAP_TS_RTI);
  dfx_node_t tdo;

  data_out = new[data.size()];

  move_tap(DFX_TAP_TS_SHIFT_DR);

  foreach (data[i]) begin
    if (i < data.size() - 1)
      drive_jtag(1'b0, data[i], tdo);
    else begin
      if (fs == DFX_TAP_TS_SHIFT_DR)
        drive_jtag(1'b0, data[i], tdo);
      else
        drive_jtag(1'b1, data[i], tdo);
    end

    data_out[i] = tdo;
  end

  move_tap(fs);
endtask : scan_dr

task dfx_tap_driver::scan_with_tms(const ref dfx_node_t tms_ary[],
                                   const ref dfx_node_t tdi_ary[],
                                   ref dfx_node_t tdo_ary[]);

  tdo_ary = new[tdi_ary.size()];

  foreach (tms_ary[i])
    drive_jtag(tms_ary[i], tdi_ary[i], tdo_ary[i]); // no change in "cts"

endtask : scan_with_tms

task dfx_tap_driver::pre_scan;

  // This is necessary to avoid possible race conditions.  In the case of "on demand TCK", or when starting a
  // transaction not aligned with the negedge of TCK (such as the first transaction), wait for a negative TCK edge to
  // really avoid race conditions.
  if (avoid_race && (on_demand_tck || (cts == DFX_TAP_TS_TLR || cts == DFX_TAP_TS_RTI)))
    @(negedge jtag_if.tck_in); // strong condition, but may waste a TCK cycle
  else
    wait (!jtag_if.tck_in); // weaker condition, and not fool-proof

  if (on_demand_tck)
    jtag_if.tck_enable = 1'b1;

endtask : pre_scan

task dfx_tap_driver::post_scan;

  if (on_demand_tck)
    jtag_if.tck_enable = 1'b0;

endtask : post_scan

// At the end of a "transaction" (scanning in/out instruction/data), the TAP FSM is "parked" immediately after the
// negative edge of TCK before which the last FSM transition occurred.
//
task dfx_tap_driver::drive_jtag(input dfx_node_t tms, tdi, output tdo);

  if (!jtag_if.trst)
    `ovm_warning(get_type_name(), "drive_jtag(): TRST asserted just before TMS/TDI to be driven")

  /*
   if (!jtag_if.tck_enable)
   `ovm_warning(get_type_name(), "drive_jtag(): TCK not enabled just before TMS/TDI to be driven")
   */

  if (scan_format == TAP_SCAN_NORMAL)
    drive_4pin(tms, tdi, tdo);
  else
    drive_2pin(tms, tdi, tdo);

  update_tap(tms);
  jtag_if.cts = cts;
  emit_ts_event();

endtask : drive_jtag

task dfx_tap_driver::drive_4pin(input dfx_node_t tms, tdi, output tdo);

  // wait (!jtag_if.tck);
  jtag_if.tms = tms;
  jtag_if.tdi = tdi;

  @(posedge jtag_if.tck)
    tdo = jtag_if.tdo;

  @(negedge jtag_if.tck);

endtask : drive_4pin

task dfx_tap_driver::drive_2pin(input dfx_node_t tms, tdi, output tdo);

  // First drive TDI
  //
  // For some scan formats, TDI is not driven in non-shift states
  //
  if ((scan_format != TAP_SCAN_OSCAN2 &&
       scan_format != TAP_SCAN_OSCAN3 &&
       scan_format != TAP_SCAN_OSCAN6 &&
       scan_format != TAP_SCAN_OSCAN7) ||
      (cts == DFX_TAP_TS_SHIFT_IR || cts == DFX_TAP_TS_SHIFT_IR)) begin
    jtag_if.tms = ~tdi;

    @(posedge jtag_if.tck);

    if ((cts == DFX_TAP_TS_SHIFT_IR || cts == DFX_TAP_TS_SHIFT_IR) && tms == 1'b1 &&
        (scan_format == TAP_SCAN_OSCAN4 || scan_format == TAP_SCAN_OSCAN5)) begin
      // Drive EOT (~nTDI) at rising edge of TCK
      jtag_if.tms = tdi;
      #1ns;
      jtag_if.tms = ~tdi;
    end

    @(negedge jtag_if.tck);
  end

  // Second, drive TMS
  //
  // For some scan formats, TMS is not driven in shift states
  //
  if ((scan_format != TAP_SCAN_OSCAN4 &&
       scan_format != TAP_SCAN_OSCAN5 &&
       scan_format != TAP_SCAN_OSCAN6 &&
       scan_format != TAP_SCAN_OSCAN7) ||
      (cts != DFX_TAP_TS_SHIFT_IR && cts != DFX_TAP_TS_SHIFT_IR)) begin
    jtag_if.tms = tms;

    @(posedge jtag_if.tck);
    // jtag_if.tms = 1'bz;
    @(negedge jtag_if.tck);
  end

  // PC0
  if (scan_format == TAP_SCAN_MSCAN) begin
    // Drive PC0 bit to 1
    jtag_if.tms = 1'b1;

    // @(posedge jtag_if.tck);
    @(negedge jtag_if.tck);
  end

  // RDY
  if (scan_format == TAP_SCAN_OSCAN0 ||
      scan_format == TAP_SCAN_MSCAN ||
      scan_format == TAP_SCAN_OSCAN4) begin
    jtag_if.tms = 1'bz; // before negedge of TCK?  when is it driven by DUT?

    @(posedge jtag_if.tck);

    while (jtag_if.tms !== 1'b1)
      @(posedge jtag_if.tck);

    @(negedge jtag_if.tck);
  end

  // PC1
  if (scan_format == TAP_SCAN_MSCAN) begin
    // Drive PC1 bit to 1
    jtag_if.tms = 1'b1;

    // @(posedge jtag_if.tck);
    @(negedge jtag_if.tck);
  end

  // TDO
  //
  // TDO is not driven at all for OSCAN3 and OSCAN7 formats
  // TDO is not driven in non-shift states for OSCAN2 and OSCAN6
  //
  if (scan_format != TAP_SCAN_OSCAN3 && scan_format != TAP_SCAN_OSCAN7 &&
      ((scan_format != TAP_SCAN_OSCAN2 && scan_format != TAP_SCAN_OSCAN6) ||
       (cts == DFX_TAP_TS_SHIFT_IR || cts == DFX_TAP_TS_SHIFT_IR))) begin

    jtag_if.tms = 1'bz;

    @(posedge jtag_if.tck);

    // Sample TDO (on TMS pin) at falling edge of TCK if SREDGE register is set
    if (sredge)
      @(negedge jtag_if.tck);

    // Sample TDO
    tdo = jtag_if.tms;

    if (!sredge)
      @(negedge jtag_if.tck);
  end

endtask : drive_2pin

task dfx_tap_driver::print_stim();
endtask : print_stim

// A version:
class dfx_tap_driver_a extends dfx_tap_driver;

  `ovm_component_utils(dfx_tap_driver_a)

  extern task run_normal();

  function new(string name, ovm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass : dfx_tap_driver_a

task dfx_tap_driver_a::run_normal();
  string s;

  if (req.instr_in.size() == 0 && req.data_in.size() == 0) begin
    // Nothing to do
    `ovm_info(get_type_name(), "No instruction or data to scan in", OVM_FULL)
    return;
  end

  pre_scan;

  // Drive TAP port - first instruction, then data.

  if (req.instr_in.size() > 0) begin
    $sformat(s, "Total instruction size = %0d", req.instr_in.size());
    `ovm_info(get_type_name(), s, OVM_FULL)
    s = {"Scanning in instruction stream: ", dfx_tap_util::writeh(req.instr_in)};
    `ovm_info(get_type_name(), s, OVM_FULL)
    scan_ir(req.instr_in, req.instr_out, req.its); // drive instruction
    s = {"Scanned out instruction stream: ", dfx_tap_util::writeh(req.instr_out)};
    `ovm_info(get_type_name(), s, OVM_FULL)
  end

  if (req.data_in.size() > 0) begin
    $sformat(s, "Total data size = %0d", req.data_in.size());
    `ovm_info(get_type_name(), s, OVM_FULL)
    s = {"Scanning in data stream: ", dfx_tap_util::writeh(req.data_in)};
    `ovm_info(get_type_name(), s, OVM_FULL)
    scan_dr(req.data_in, req.data_out, req.dts); // drive data
    s = {"Scanned out data stream: ", dfx_tap_util::writeh(req.data_out)};
    `ovm_info(get_type_name(), s, OVM_FULL)
  end

  post_scan;

endtask : run_normal

// B version:
class dfx_tap_driver_b extends dfx_tap_driver;

  semaphore TapStimFile_access;
  int       TapStimFile;     // Pointer to STIM file
  tap_globals_s TapGlobals;
  bit random_mode = 0;
  bit tdi_default_value = 1;

  `ovm_component_utils(dfx_tap_driver_b)

  extern task run_normal();
  extern local function tap_fsm_state_s compute_next_fsm_state(input dfx_tap_base_transaction cmd, dfx_tapfsm_state_e cur_state, bit first_state);
  extern local function void make_tap_driver_data(ref dfx_tap_base_transaction cmd,input dfx_tapfsm_state_e cts);
  extern local function void make_shift_pause_lists(ref dfx_tap_base_transaction cmd);
  extern local function void make_val_shift_pause_list(input int data_size, ref shift_pause_s shift_pause_l[$], input bit last_pause=0);
  extern local function shift_pause_s make_shift_pause(input int shift_size = 0, pause_size = 0);

  extern local task print_stim();

  function new(string name, ovm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass : dfx_tap_driver_b

task dfx_tap_driver_b::run_normal();

  string s;
  bit tdo;
  bit ir_tdo_l[$];
  bit dr_tdo_l[$];
  dfx_tap_multiple_taps_transaction_b reqq;

  print_stim();

  if (!$cast(reqq, req))
    `ovm_fatal(get_type_name(),
               "Override factory type dfx_tap_multiple_taps_transaction with dfx_tap_multiple_taps_transaction_b")

  if (reqq.instr_in.size() > 0)
    reqq.set_ir = 1;
  if (reqq.data_in.size() > 0)
    reqq.set_dr = 1;

  if ( ~ (reqq.set_ir | reqq.set_dr) ) begin
    // Nothing to do
    `ovm_info(get_type_name(), "No instruction or data to scan in", OVM_NONE)
    return;
  end

  pre_scan;

  // Ensure that current TAP state is defined.
  if (cts == DFX_TAP_TS_UNKNOWN)
    `ovm_error(get_type_name(), "run_normal(): Starting TAP state is unknown!")

  // Drive TAP port - first instruction, then data.

  if (reqq.instr_in.size() > 0) begin
    $sformat(s, "TAP> Total instruction size = %0d", reqq.instr_in.size());
    `ovm_info(get_type_name(), s, OVM_NONE)
    s = {"TAP> Scanning in instruction stream: ", dfx_tap_util::writeh(reqq.instr_in)};
    `ovm_info(get_type_name(), s, OVM_NONE)
    //    scan_ir(req.instr_in, req.instr_out, req.its); // drive instruction
    //    s = {"Scanned out instruction stream: ", dfx_tap_util::writeh(req.instr_out)};
    //    `ovm_info(get_type_name(), s, OVM_NONE)
  end

  if (reqq.data_in.size() > 0) begin
    $sformat(s, "TAP> Total data size = %0d", reqq.data_in.size());
    `ovm_info(get_type_name(), s, OVM_NONE)
    s = {"TAP> Scanning in data stream: ", dfx_tap_util::writeh(reqq.data_in)};
    `ovm_info(get_type_name(), s, OVM_NONE)
    //    scan_dr(req.data_in, req.data_out, req.dts); // drive data
    //    s = {"Scanned out data stream: ", dfx_tap_util::writeh(req.data_out)};
    //    `ovm_info(get_type_name(), s, OVM_NONE)
  end

  // make_tap_driver_data(reqq, cts); // VCS complains about argument type - report error
  make_tap_driver_data(req, cts);
  foreach (reqq.tap_driver_data_l[state]) begin
    $sformat(s, "Driving state %s (cycles: %0d)", reqq.tap_driver_data_l[state].cur_state, reqq.tap_driver_data_l[state].cycles);
    `ovm_info(get_type_name(), s, OVM_NONE)
    foreach (reqq.tap_driver_data_l[state].tms_l[i]) begin
      drive_jtag(reqq.tap_driver_data_l[state].tms_l[i], reqq.tap_driver_data_l[state].tdi_l[i], tdo);
      reqq.tap_driver_data_l[state].tdo_l.push_back(tdo);
    end
    if (reqq.tap_driver_data_l[state].cur_state == DFX_TAP_TS_SHIFT_IR)
      foreach (reqq.tap_driver_data_l[state].tdo_l[i])
        ir_tdo_l.push_back(reqq.tap_driver_data_l[state].tdo_l[i]);
    if (reqq.tap_driver_data_l[state].cur_state == DFX_TAP_TS_SHIFT_DR)
      foreach (reqq.tap_driver_data_l[state].tdo_l[i])
        dr_tdo_l.push_back(reqq.tap_driver_data_l[state].tdo_l[i]);
  end

  reqq.instr_out = new[reqq.instr_in.size()];
  if (reqq.instr_out.size() != ir_tdo_l.size())
    `ovm_error(get_type_name(), $psprintf("TAP> instr_out & ir_tdo_l suze mismatch (%0d vs. %0d)", reqq.instr_out.size(), ir_tdo_l.size()))
  else begin
    foreach (ir_tdo_l[i])
      reqq.instr_out[i] = ir_tdo_l[i];
    s = {"TAP> Scanned out instruction stream: ", dfx_tap_util::writeh(reqq.instr_out)};
    `ovm_info(get_type_name(), s, OVM_NONE)
  end

  reqq.data_out = new[reqq.data_in.size()];
  if (reqq.data_out.size() != dr_tdo_l.size())
    `ovm_error(get_type_name(), $psprintf("TAP> data_out & dr_tdo_l size mismatch (%0d vs. %0d)", reqq.data_out.size(), dr_tdo_l.size()))
  else begin
    foreach (dr_tdo_l[i])
      reqq.data_out[i] = dr_tdo_l[i];
    s = {"TAP> Scanned out data stream: ", dfx_tap_util::writeh(reqq.data_out)};
    `ovm_info(get_type_name(), s, OVM_NONE)
  end

  post_scan;

endtask : run_normal

// Method to calculate next FSM state based on control flags in the transaction.
// Control flags/data: goto_tlr,set_ir,set_dr,goto_rti,is_back_to_back,skip_rti,
//                     dr_shift_pause_l,ir_shift_pause_l
function tap_fsm_state_s dfx_tap_driver_b::compute_next_fsm_state(input dfx_tap_base_transaction cmd, dfx_tapfsm_state_e cur_state, bit first_state);

  // Default configuration for the current state
  tap_fsm_state_s state_data;
  dfx_tap_multiple_taps_transaction_b cmdd;

  if (!$cast(cmdd, cmd))
    `ovm_fatal(get_type_name(),
               "Override factory type dfx_tap_multiple_taps_transaction with dfx_tap_multiple_taps_transaction_b")

  state_data.cur_state  = cur_state;
  state_data.next_state = cur_state;
  state_data.cycles     = 1;

  if (cmdd.goto_tlr) begin

    if (cur_state == DFX_TAP_TS_TLR) begin
      //state_data.next_state = DFX_TAP_TS_TLR;
      state_data.cycles = (cmdd.clocks_in_tlr > 1) ? cmdd.clocks_in_tlr : 1;
      cmdd.goto_tlr           = 0;
    end
    else
      state_data.next_state = get_next_fsm_state(cur_state,1);
  end

  else begin

    case (cur_state)

      DFX_TAP_TS_TLR: begin //(tms_value == 1) ? DFX_TAP_TS_TLR : DFX_TAP_TS_RTI

        if (cmdd.set_ir | cmdd.set_dr)
          // Just one cycle in RTI
          state_data.next_state = DFX_TAP_TS_RTI;
        //cmdd.goto_tlr         = 0;
        else if (cmdd.goto_rti) begin
          state_data.next_state = DFX_TAP_TS_RTI;
          cmdd.goto_rti         = 0;
          //cmdd.goto_tlr               = 0;
        end
      end

      DFX_TAP_TS_RTI: begin //(tms_value == 1) ? DFX_TAP_TS_SELECT_DR : DFX_TAP_TS_RTI

        if (cmdd.set_ir) begin
          state_data.next_state = DFX_TAP_TS_SELECT_DR;
          if ( ~first_state )
            state_data.cycles = (cmdd.clocks_in_rti_after_instruction > 1) ? cmdd.clocks_in_rti_after_instruction : 1;
        end
        else if(cmdd.set_dr) begin // && !cmdd.set_ir
          state_data.next_state = DFX_TAP_TS_SELECT_DR;
          state_data.cycles     = (cmdd.clocks_in_rti_before_dr_shift > 1) ? cmdd.clocks_in_rti_before_dr_shift : 1;
        end
        else begin // !cmdd.set_ir && !cmdd.set_dr
          // Final RTI state
          //state_data.next_state = DFX_TAP_TS_RTI;
          state_data.cycles     = (cmdd.clocks_in_rti_after_instruction > 1) ? cmdd.clocks_in_rti_after_instruction : 1;
          cmdd.goto_rti         = 0;
        end
      end

      DFX_TAP_TS_SELECT_DR: begin //(tms_value == 1) ? DFX_TAP_TS_SELECT_IR : DFX_TAP_TS_CAPTURE_DR

        if (cmdd.set_ir)
          state_data.next_state = DFX_TAP_TS_SELECT_IR;
        else if(cmdd.set_dr) // && !cmdd.set_ir
          state_data.next_state = DFX_TAP_TS_CAPTURE_DR;
        else
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
      end

      DFX_TAP_TS_SELECT_IR: begin //(tms_value == 1) ? DFX_TAP_TS_TLR : DFX_TAP_TS_CAPTURE_IR

        if (cmdd.set_ir)
          state_data.next_state = DFX_TAP_TS_CAPTURE_IR;
        else
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
      end

      DFX_TAP_TS_CAPTURE_DR: begin //(tms_value == 1) ? DFX_TAP_TS_EXIT1_DR : DFX_TAP_TS_SHIFT_DR

        if( ~cmdd.set_dr )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (cmdd.dr_shift_pause_l[0].shifts == 0)
          state_data.next_state = DFX_TAP_TS_EXIT1_DR;
        else
          state_data.next_state = DFX_TAP_TS_SHIFT_DR;
        cmdd.current_shift_pause_loop = 0;
      end

      DFX_TAP_TS_CAPTURE_IR: begin //(tms_value == 1) ? DFX_TAP_TS_EXIT1_IR : DFX_TAP_TS_SHIFT_IR

        if( ~cmdd.set_ir )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (cmdd.ir_shift_pause_l[0].shifts == 0)
          state_data.next_state = DFX_TAP_TS_EXIT1_IR;
        else
          state_data.next_state = DFX_TAP_TS_SHIFT_IR;
        cmdd.current_shift_pause_loop = 0;
      end

      DFX_TAP_TS_SHIFT_DR: begin //(tms_value == 1) ? DFX_TAP_TS_EXIT1_DR : DFX_TAP_TS_SHIFT_DR

        int shifts = cmdd.dr_shift_pause_l[cmdd.current_shift_pause_loop].shifts;
        if( ~cmdd.set_dr )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (shifts == 0)
          `ovm_error(get_type_name(),$psprintf("(FSM) Incorrect value of cmdd.dr_shift_pause_l[%0d].shifts == %0d for the current FSM state %s",cmdd.current_shift_pause_loop,shifts,cur_state))
        else begin
          state_data.next_state = DFX_TAP_TS_EXIT1_DR;
          state_data.cycles     = shifts;
        end
      end

      DFX_TAP_TS_SHIFT_IR: begin //(tms_value == 1) ? DFX_TAP_TS_EXIT1_IR : DFX_TAP_TS_SHIFT_IR

        int shifts = cmdd.ir_shift_pause_l[cmdd.current_shift_pause_loop].shifts;
        if( ~cmdd.set_ir )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (shifts == 0)
          `ovm_error(get_type_name(),$psprintf("(FSM) Incorrect value of cmdd.ir_shift_pause_l[%0d].shifts == %0d for the current FSM state %s",cmdd.current_shift_pause_loop,shifts,cur_state))
        else begin
          state_data.next_state = DFX_TAP_TS_EXIT1_IR;
          state_data.cycles     = shifts;
        end
      end

      DFX_TAP_TS_PAUSE_DR: begin //(tms_value == 1) ? DFX_TAP_TS_EXIT2_DR : DFX_TAP_TS_PAUSE_DR

        int pause = cmdd.dr_shift_pause_l[cmdd.current_shift_pause_loop].pause;
        if( ~cmdd.set_dr )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (pause == 0)
          `ovm_error(get_type_name(),$psprintf("(FSM) Incorrect value of cmdd.dr_shift_pause_l[%0d].pause == %0d for the current FSM state %s",cmdd.current_shift_pause_loop,pause,cur_state))
        else begin
          state_data.next_state = DFX_TAP_TS_EXIT2_DR;
          state_data.cycles     = pause;
        end
      end

      DFX_TAP_TS_PAUSE_IR: begin //(tms_value == 1) ? DFX_TAP_TS_EXIT2_IR : DFX_TAP_TS_PAUSE_IR

        int pause = cmdd.ir_shift_pause_l[cmdd.current_shift_pause_loop].pause;
        if( ~cmdd.set_ir )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (pause == 0)
          `ovm_error(get_type_name(),$psprintf("(FSM) Incorrect value of cmdd.ir_shift_pause_l[%0d].pause == %0d for the current FSM state %s",cmdd.current_shift_pause_loop,pause,cur_state))
        else begin
          state_data.next_state = DFX_TAP_TS_EXIT2_IR;
          state_data.cycles     = pause;
        end
      end

      DFX_TAP_TS_EXIT1_DR: begin //result = (tms_value == 1) ? DFX_TAP_TS_UPDATE_DR : DFX_TAP_TS_PAUSE_DR

        int pause = cmdd.dr_shift_pause_l[cmdd.current_shift_pause_loop].pause;
        if( ~cmdd.set_dr )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (pause == 0) begin
          if (cmdd.dr_shift_pause_l.size() == (cmdd.current_shift_pause_loop + 1))
            state_data.next_state = DFX_TAP_TS_UPDATE_DR;
          else
            `ovm_error(get_type_name(),$psprintf("(FSM) Incorrect value of cmdd.dr_shift_pause_l[%0d].pause == %0d for the current FSM state %s (total loops:%0d)",cmdd.current_shift_pause_loop,pause,cur_state,cmdd.dr_shift_pause_l.size()))
        end
        else
          state_data.next_state = DFX_TAP_TS_PAUSE_DR;
      end

      DFX_TAP_TS_EXIT1_IR: begin //result = (tms_value == 1) ? DFX_TAP_TS_UPDATE_IR : DFX_TAP_TS_PAUSE_IR

        int pause = cmdd.ir_shift_pause_l[cmdd.current_shift_pause_loop].pause;
        if( ~cmdd.set_ir )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (pause == 0) begin
          if (cmdd.ir_shift_pause_l.size() == (cmdd.current_shift_pause_loop + 1))
            state_data.next_state = DFX_TAP_TS_UPDATE_IR;
          else
            `ovm_error(get_type_name(),$psprintf("(FSM) Incorrect value of cmdd.ir_shift_pause_l[%0d].pause == %0d for the current FSM state %s (total loops:%0d)",cmdd.current_shift_pause_loop,pause,cur_state,cmdd.ir_shift_pause_l.size()))
        end
        else
          state_data.next_state = DFX_TAP_TS_PAUSE_IR;
      end

      DFX_TAP_TS_EXIT2_DR: begin //(tms_value == 1) ? DFX_TAP_TS_UPDATE_DR : DFX_TAP_TS_SHIFT_DR

        cmdd.current_shift_pause_loop += 1;
        if( ~cmdd.set_dr )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (cmdd.dr_shift_pause_l.size() == cmdd.current_shift_pause_loop)
          state_data.next_state = DFX_TAP_TS_UPDATE_DR;
        else
          state_data.next_state = DFX_TAP_TS_SHIFT_DR;
      end

      DFX_TAP_TS_EXIT2_IR: begin //(tms_value == 1) ? DFX_TAP_TS_UPDATE_IR : DFX_TAP_TS_SHIFT_IR

        cmdd.current_shift_pause_loop += 1;
        if( ~cmdd.set_ir )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (cmdd.ir_shift_pause_l.size() == cmdd.current_shift_pause_loop)
          state_data.next_state = DFX_TAP_TS_UPDATE_IR;
        else
          state_data.next_state = DFX_TAP_TS_SHIFT_IR;
      end

      DFX_TAP_TS_UPDATE_DR: begin //(tms_value == 1) ? DFX_TAP_TS_SELECT_DR : DFX_TAP_TS_RTI

        if( ~cmdd.set_dr )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if (cmdd.is_back_to_back)
          state_data.next_state = DFX_TAP_TS_SELECT_DR;
        else
          state_data.next_state = DFX_TAP_TS_RTI;
        cmdd.set_dr = 0;
      end

      DFX_TAP_TS_UPDATE_IR: begin //(tms_value == 1) ? DFX_TAP_TS_SELECT_DR : DFX_TAP_TS_RTI

        if( ~cmdd.set_ir )
          `ovm_error(get_type_name(),$psprintf("(FSM) No instruction for further transition from the current FSM state %s (goto_tlr:%0d goto_rti:%0d set_ir:%0d set_dr:%0d)",cur_state,cmdd.goto_tlr,cmdd.goto_rti,cmdd.set_ir,cmdd.set_dr))
        else if ((cmdd.is_back_to_back & ~cmdd.set_dr) | (cmdd.skip_rti & cmdd.set_dr))
          state_data.next_state = DFX_TAP_TS_SELECT_DR;
        else
          state_data.next_state = DFX_TAP_TS_RTI;
        cmdd.set_ir = 0;
      end

      default:
        `ovm_error(get_type_name(),$psprintf("(FSM) Unknown FSM state %s",cur_state))

    endcase //case (cur_state)

  end //if (cmdd.goto_tlr)

  return state_data;

endfunction : compute_next_fsm_state

// This function takes a tap command, and builds all the bit streams
// for the TMS & TDI , and stores
// those bit streams in the tap driver data structure in the tap command.
//
function void dfx_tap_driver_b::make_tap_driver_data(ref dfx_tap_base_transaction cmd, input dfx_tapfsm_state_e cts);

  dfx_tapfsm_state_e this_tap_state = cts;//current_state;
  dfx_tapfsm_state_e next_tap_state = cts;
  bit next_tms_value    = 0;
  int ir_data_index     = 0;
  int dr_data_index     = 0;
  bit random_mode = 0;
  bit tdi_default_value = 1;
  tap_fsm_state_s cur_data; // pointer to current data in the tap_driver_data_l
  bit first_state = 1;
  dfx_tap_multiple_taps_transaction_b cmdd;

  if (!$cast(cmdd, cmd))
    `ovm_fatal(get_type_name(),
               "Override factory type dfx_tap_multiple_taps_transaction with dfx_tap_multiple_taps_transaction_b")

  if (!get_config_int("TAP_RANDOM_NONSHIFT_TDI", random_mode))
    random_mode = 0;
  if (!get_config_int("TAP_TDI_DEFAULT_VALUE", tdi_default_value))
    tdi_default_value = 1;

  // Save off the set_dr and set_ir fields in case this instruction will
  // use express mode. These flags will tell the express mode pounding
  // code whether to wait for an IR or DR shift to do pounding or not.
  // We have to save these because set_ir and set_dr are always cleared
  // during the process of building the driver data, and so will always
  // be FALSE when the command gets issued.
  //
  cmdd.has_set_ir = cmdd.set_ir;
  cmdd.has_set_dr = cmdd.set_dr;

  // Step 1: Get the current state. Do checks.
  // -If the goto_tlr flag is set in the instruction, we can start from
  // anywhere.
  // -If the goto_rti flag is set, we expect to start in TLR,RTI or SLDR.
  // -If the back-to-back flag is set, we will start in TLR,RTI or SLDR,
  // depending on whether we are the first back-to-back instruction
  // being issued (RTI) or a subsequent instruction (SLDR).
  // -Otherwise, we should assume we are always starting in RTI, and
  // throw an error if we are not.

  /*
   if ( !(this_tap_state inside {DFX_TAP_TS_RTI,DFX_TAP_TS_SELECT_DR,DFX_TAP_TS_TLR}) )
   `ovm_error(get_type_name(),$psprintf("(FSM) Attempting to start TAP instruction in wrong state %s",this_tap_state))
   */
  // make_shift_pause_lists(cmdd); // VCS complains about argument type - report error
  make_shift_pause_lists(cmd);

  cmdd.current_shift_pause_loop = 0;

  cmdd.tap_driver_data_l.delete();

  // This is the loop which creates the driver data. Assume the flags
  // will get cleared once their purpose has been achieved. We are done
  // when all the flags are cleared. The last state will be returned
  // at the same time that the flags are cleared.
  //
  // FIXME Make sure that set_dr with no_data is supported
  while(cmdd.goto_tlr || cmdd.goto_rti || cmdd.set_ir || cmdd.set_dr) begin

    // Calling user defined method (advanced FSM validation)
    //if (config.fsm_override_en)
    //    override_tap_driver_data(cmdd,this_tap_state);

    // Ask the current state what state is next, given the current
    // instruction we're processing

    cur_data = compute_next_fsm_state(cmdd,this_tap_state,first_state);
    next_tap_state = cur_data.next_state;
    next_tms_value = get_tms_for_fsm_transition(this_tap_state,next_tap_state);
    first_state = 0;

    if (cur_data.cycles == 0)
      `ovm_error(get_type_name(),$psprintf("(FSM)Zero cycles specified for the state %s",this_tap_state))
    else if (cur_data.cycles == 1)
      cur_data.tms_l = {next_tms_value};
    else begin
      if (this_tap_state == next_tap_state)
        for (int i=0; i < cur_data.cycles; i++)
          cur_data.tms_l.push_back(next_tms_value);
      else begin
        for (int i=0; i < (cur_data.cycles-1); i++)
          cur_data.tms_l.push_back(~next_tms_value);
        cur_data.tms_l.push_back(next_tms_value);
      end
    end

    // Only add IR or DR data in the shift states.
    // Do it once for each TDI/TDO chain we have. Copy the IR and DR
    // data from the chain_ir_dr_l list of tdi_tdo_chain_ir_dr_s in
    // the any_tap_cmd_s. This is a list of IR and DR values to shift
    // in, per tdi/tdo chain. The assumption is that each chain has
    // exactly the same number of ir shifts as the other chains, and the
    // same for the dr chains. The lengths of the IR and DR shifts for
    // each chain must have been normalized with "filler" bits to the
    // same length.
    // 8/24/2009 SethB - Initially I didn't comprehend the delay between
    // changing states and when the TAP starts sampling TDI. It only
    // samples TDI in the shift states when the clock rises and the TAP
    // is already in that state. That means there is no sampling of TDI
    // on the clock when the TAP transitions from Capture to Shift. AND
    // that means there IS a sampling of TDI when the TAP transitions
    // from SHIFT to the EXIT1 state. There's sort of a 1 clock delay.
    //
    // Only add bits when the current (this) state is the shift state.
    //
    // This: CAP SHF SHF SHF SHF SHF SHF, EX1
    // Next: SHF SHF SHF SHF SHF SHF EX1, ?
    // TDI:      NA  LSB [1] [2] [3] [4] [5] NA

    cur_data.tdi_l = new[cur_data.cycles];
    if(this_tap_state == DFX_TAP_TS_SHIFT_IR) begin
      foreach (cur_data.tdi_l[i])
        cur_data.tdi_l[i] = cmdd.instr_in[ir_data_index+i];
      ir_data_index += cur_data.cycles;
    end
    else if(this_tap_state == DFX_TAP_TS_SHIFT_DR) begin
      foreach (cur_data.tdi_l[i])
        cur_data.tdi_l[i] = cmdd.data_in[dr_data_index+i];
      dr_data_index += cur_data.cycles;
    end
    else begin // Not a shift state. TDI doesn't really matter.
      if (random_mode)
        foreach (cur_data.tdi_l[i])
          cur_data.tdi_l[i] = $random();
      else
        foreach (cur_data.tdi_l[i])
          cur_data.tdi_l[i] = tdi_default_value;
    end // end if next state is DFX_TAP_TS_SHIFT_DR

    // Now advance to the next TAP cycle. Move to the next TAP state
    // and go figure out what to do then.
    //

    cmdd.tap_driver_data_l.push_back(cur_data);

    this_tap_state = next_tap_state;

  end // end while we still have work to do for this TAP instruction.

  `ovm_info(get_type_name(), "TAP> Done building the TAP driver data. FSM sequence:", OVM_MEDIUM)

  foreach (cmdd.tap_driver_data_l[i])
    `ovm_info(get_type_name(), $psprintf("TAP> FSM state %s (%0d cycles)",cmdd.tap_driver_data_l[i].cur_state, cmdd.tap_driver_data_l[i].cycles), OVM_MEDIUM)

endfunction : make_tap_driver_data

// make_shift_pause_lists()
//
// For shift pause lists, there are 4 options:
// 1. random_shift_pause is FALSE and the user does not provide any
//    manually-generated shift/pause lists. In this case, just do the
//    normal thing and shift everything without pauses. This is the default
//    and most common case.
// 2. random_shift_pause is FALSE and the user does provide shift/
//    pause lists that precisely control the issuing of the instruction.
//    use those lists.
// 3. random_shift_pause is TRUE. Use this code to randomly generate
//    the shift/pause lists for this instruction. Ignore any lists the user
//    has already created.
// 4. EXPRESS MODE. This forces there to be just one shift/pause in the list,
//    with a single bit shift and no pauses at all. In this case, a TCM
//    will monitor the TAP states and jam the IR and DR values at the end
//    of the shift states for us. Express mode takes precedence over other
//    modes and may break some instructions which need shift/pause sequences
//    to work properly.
//
function void dfx_tap_driver_b::make_shift_pause_lists(ref dfx_tap_base_transaction cmd);

  bit random_shift_pause;
  bit fixed_shift_pause;
  bit val_shift_pause;
  bit last_pause;
  int max_loop_num;
  int max_pause_time;
  int fsm_stay_in_shift_ir;
  int fsm_stay_in_pause_ir;
  int fsm_stay_in_shift_dr;
  int fsm_stay_in_pause_dr;
  shift_pause_s shift_pause_ir;
  shift_pause_s shift_pause_dr;
  dfx_tap_multiple_taps_transaction_b cmdd;

  if (!$cast(cmdd, cmd))
    `ovm_fatal(get_type_name(),
               "Override factory type dfx_tap_multiple_taps_transaction with dfx_tap_multiple_taps_transaction_b")

  if (!get_config_int("TAP_RANDOM_SHIFT_PAUSE", random_shift_pause))
    random_shift_pause = 0;
  if (!get_config_int("TAP_FIXED_SHIFT_PAUSE", fixed_shift_pause))
    fixed_shift_pause = 0;
  if (!get_config_int("TAP_VAL_SHIFT_PAUSE", val_shift_pause))
    val_shift_pause = 0;
  if (!get_config_int("TAP_VAL_LAST_PAUSE", last_pause))
    last_pause = 0;

  if (!get_config_int("TAP_MAX_SHIFT_LOOP_NUM", max_loop_num))
    max_loop_num = 3;
  if (!get_config_int("TAP_MAX_PAUSE_TIME", max_pause_time))
    max_pause_time = 10;

  if (!get_config_int("TAP_FSM_STAY_SHIR", fsm_stay_in_shift_ir))
    fsm_stay_in_shift_ir = 64;
  if (!get_config_int("TAP_FSM_STAY_PAIR", fsm_stay_in_pause_ir))
    fsm_stay_in_pause_ir = 1;
  if (!get_config_int("TAP_FSM_STAY_SHDR", fsm_stay_in_shift_dr))
    fsm_stay_in_shift_dr = 64;
  if (!get_config_int("TAP_FSM_STAY_PADR", fsm_stay_in_pause_dr))
    fsm_stay_in_pause_dr = 1;

  // This option is off by default, and can be set or constrained to true
  // to enable random generation of shift/pause lists. A shift pause list
  // is necessary for issuing both IRs and DRs, but without this flag, we
  // will always generate a list with all shifts and no pauses (see the
  // else clause below). Only if this flag is set will pauses be randomly
  // generated.
  //

  //    if (random_shift_pause) begin
  //
  //      // Erase existing lists first. If this instruction is being re-used
  //      // then this clears out the old cruft.
  //      //
  //
  //     `ovm_info(get_type_name(),"TAP> (FSM) Randomizing DFX_TAP_TS_SHIFT_IR/DFX_TAP_TS_PAUSE_IR...", OVM_MEDIUM)
  //      //cmdd.ir_shift_pause_l = make_random_shift_pause_list(cmdd.instr_in.size(), max_loop_num, max_pause_time);
  //     `ovm_info(get_type_name(),"TAP> (FSM) Randomizing DFX_TAP_TS_SHIFT_DR/DFX_TAP_TS_PAUSE_DR...", OVM_MEDIUM)
  //      //cmdd.dr_shift_pause_l = make_random_shift_pause_list(cmdd.data_in.size(), max_loop_num, max_pause_time);
  //
  //    end
  //
  //    else if (val_shift_pause) begin
  if (val_shift_pause) begin

    `ovm_info(get_type_name(),"TAP> (FSM) Using validation shift-pause sequence...", OVM_MEDIUM)
    make_val_shift_pause_list(cmdd.instr_in.size(), cmdd.ir_shift_pause_l, last_pause);
    make_val_shift_pause_list(cmdd.data_in.size(),  cmdd.dr_shift_pause_l, last_pause);

  end

  else begin

    // If the user has not added any shift_pause_s structs to the
    // shift_pause_l lists for IR or DR, we can safely assume they want
    // to issue the IR or DR without any pauses. Therefore, make a default
    // shift_pause_s and add it to the list and tell it NOT to pause,
    // and to issue all the shift bits at once. This is the default and most
    // desired behavior.
    //
    // When an any_tap_cmd_s is generated, then these lists are
    // constrained to have 0 entries. However, if you re-use an
    // any_tap_cmd_s without re-generating it between uses, then
    // these lists will have the values from a previous run, which
    // is not correct. XXX TODO FIXME Is that Ok?
    //
    if (cmdd.ir_shift_pause_l.size() == 0) begin
      //            if (fsm_stay_in_shift_ir > 0) begin
      //              cmdd.ir_shift_pause_l =  make_fixed_shift_pause_list(cmdd.instr_in.size(),
      //                  fsm_stay_in_shift_ir,
      //                  ((fsm_stay_in_pause_ir > 1) ? fsm_stay_in_pause_ir : 1));
      //            end
      //            else begin
      //Default behavior: just one shift cycle, no pause
      `ovm_info(get_type_name(),"TAP> (FSM) Using default shift IR sequence (no pauses)...", OVM_MEDIUM)
      cmdd.ir_shift_pause_l.push_back(make_shift_pause(cmdd.instr_in.size(),0));
      //            end
    end // end if no IR shift_pause_l entries

    if (cmdd.dr_shift_pause_l.size() == 0) begin
      //            if (fsm_stay_in_shift_dr > 0) begin
      //              cmdd.dr_shift_pause_l =  make_fixed_shift_pause_list(cmdd.data_in.size(),
      //                  fsm_stay_in_shift_dr,
      //                  ((fsm_stay_in_pause_dr > 1) ? fsm_stay_in_pause_dr : 1));
      //            end
      //            else begin
      //Default behavior: just one shift cycle, no pause
      `ovm_info(get_type_name(),"TAP> (FSM) Using default shift DR sequence (no pauses)...", OVM_MEDIUM)
      cmdd.dr_shift_pause_l.push_back(make_shift_pause(cmdd.data_in.size(),0));
      //            end
    end // end if no IR shift_pause_l entries

  end // end if auto-generation of shift pause lists is enabled.

endfunction : make_shift_pause_lists

function void dfx_tap_driver_b::make_val_shift_pause_list(input int data_size, ref shift_pause_s shift_pause_l[$], input bit last_pause=0);

  int remaining_size = data_size;

  shift_pause_l.delete();

  if (remaining_size == 0)
    return;
  else begin
    int pause_cnt = 1;
    int shift_num;
    while(remaining_size > 0) begin
      case (pause_cnt)
        1: shift_num = 0;
        2: shift_num = 1;
        3: shift_num = (remaining_size > 1) ? (remaining_size - 1) : remaining_size;
        4: shift_num = 1;
        default:
          `ovm_error(get_type_name(), $psprintf("TAP> (FSM) Incorrect pause_cnt %0d", pause_cnt))
      endcase
      remaining_size -= shift_num;
      if ((remaining_size == 0) & ~last_pause)
        pause_cnt = 0;
      shift_pause_l.push_back(make_shift_pause(shift_num,pause_cnt));
      pause_cnt += 1;
    end
  end

endfunction : make_val_shift_pause_list

function shift_pause_s dfx_tap_driver_b::make_shift_pause(input int shift_size = 0, pause_size = 0);

  shift_pause_s sp;
  sp.pause  = pause_size;
  sp.shifts = shift_size;
  return sp;

endfunction : make_shift_pause

task dfx_tap_driver_b::print_stim();

  tap_nw_s  tap_nw_info;
  string    sir;
  string    sdr;
  dfx_tap_multiple_taps_transaction_b reqq;

  if (!$cast(reqq, req))
    `ovm_fatal(get_type_name(),
               "Override factory type dfx_tap_multiple_taps_transaction with dfx_tap_multiple_taps_transaction_b")

  TapStimFile_access.get();
  `ovm_info(get_type_name(), "TAP> Writing out operation info to STIM file", OVM_HIGH)
  if (reqq.tms_in.size() == 0) begin
    TapGlobals.tap_op_id += 1;
    $fdisplay(TapStimFile, "\n## [ %0d ps]: TAP operation %0d ##########################", $time, TapGlobals.tap_op_id);
    $fdisplay(TapStimFile, "## ==== Current tap network connectivity from TDI to TDO");
    foreach (reqq.tapnw_l[tu_i]) begin
      sir = {sir, " ", reqq.tapnw_l[tu_i].tap_name};
      if (reqq.tapnw_l[tu_i].status != TAP_STATE_EXCLUDED)
        sdr = {sdr, " ", reqq.tapnw_l[tu_i].tap_name};
    end
    $fdisplay(TapStimFile, "# tapnw %s IR: %s",port.name(),sir);
    $fdisplay(TapStimFile, "# tapnw %s DR: %s",port.name(),sdr);
    $fdisplay(TapStimFile, "## ==== Concatenated TDI streams");
    $fdisplay(TapStimFile, "## IR_FULL: %s (%0d)", dfx_tap_util::writex(reqq.instr_in),reqq.instr_in.size());
    $fdisplay(TapStimFile, "## DR_FULL: %s (%0d)", dfx_tap_util::writex(reqq.data_in),reqq.data_in.size());
    // BFM does not support expected TDO & mask
    //## ==== Expected TDO & Mask
    //## TDO_FULL:  value (size)
    //## MSK_FULL: value (size)
    $fdisplay(TapStimFile, "## ==== Tap Instructions");
    foreach (reqq.tapnw_l[tu_i]) begin
      tap_nw_info = reqq.tapnw_l[tu_i];
      $fdisplay(TapStimFile, "# tap set %s (%0d)",tap_nw_info.tap_name,tap_nw_info.ir_in_l.size());
      $fdisplay(TapStimFile, "## IR=%s DR=%s",tap_nw_info.ir_name,dfx_tap_util::writeh(tap_nw_info.dr_in_l));
      $fdisplay(TapStimFile, "# %s: %s (%0d) %s : %s",
                dfx_tap_util::writex(tap_nw_info.ir_in_l),
                "0x0",
                tap_nw_info.dr_in_l.size(),
                "0x0",
                dfx_tap_util::writex(tap_nw_info.dr_in_l));
    end
    if (reqq.raw_mode_move)
      $fdisplay(TapStimFile, "# tap set DR_RAW: %s (%0d)", dfx_tap_util::writex(reqq.data_in),reqq.data_in.size());
    if (reqq.ir_prin.size() > 0)
      $fdisplay(TapStimFile, "# tap set IR_PREFIX: %s (%0d)",dfx_tap_util::writex(reqq.ir_prin),reqq.ir_prin.size());
    if (reqq.dr_prin.size() > 0)
      $fdisplay(TapStimFile, "# tap set DR_PREFIX: %s (%0d)",dfx_tap_util::writex(reqq.dr_prin),reqq.dr_prin.size());
    $fdisplay(TapStimFile, "# tap access\n");
    // Legacy STIM
    foreach (reqq.tapnw_l[tu_i]) begin
      tap_nw_info = reqq.tapnw_l[tu_i];
      if (tap_nw_info.user_cmd) begin
        if (tap_nw_info.tdo_dr_exp_l.size() == 0) begin
          $fdisplay(TapStimFile, "tap write %s",tap_nw_info.tap_name);
          $fdisplay(TapStimFile, "# IR_SIZE=%0d",tap_nw_info.ir_in_l.size());
          $fdisplay(TapStimFile, "%s: %s (%0d)",
                    dfx_tap_util::writex(tap_nw_info.ir_in_l),
                    dfx_tap_util::writex(tap_nw_info.dr_in_l),
                    tap_nw_info.dr_in_l.size());
        end
        else begin
          if (tap_nw_info.tdo_dr_msk_l.size() > 0)
            sdr = dfx_tap_util::writex(tap_nw_info.tdo_dr_msk_l);
          else
            sdr = "";
          $fdisplay(TapStimFile, "tap read %s",tap_nw_info.tap_name);
          $fdisplay(TapStimFile, "# IR_SIZE=%0d",tap_nw_info.ir_in_l.size());
          $fdisplay(TapStimFile, "%s: %s (%0d) %s : %s",
                    dfx_tap_util::writex(tap_nw_info.ir_in_l),
                    dfx_tap_util::writex(tap_nw_info.tdo_dr_exp_l),
                    tap_nw_info.dr_in_l.size(),
                    sdr,
                    dfx_tap_util::writex(tap_nw_info.dr_in_l));
        end
      end
    end
  end
  else begin
    $fdisplay(TapStimFile, "\n## [ %0d ps]: Wait cycles", $time);
    $fdisplay(TapStimFile, "## wait TCLK (%0d)",reqq.tms_in.size());
  end
  TapStimFile_access.put();

endtask : print_stim

`endif // `ifndef DFX_TAP_DRIVER_SV
