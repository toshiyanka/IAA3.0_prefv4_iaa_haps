// =====================================================================================================
// FileName          : dfx_tap_agent.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri Jun 11 13:12:04 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP agent
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_AGENT_SV
`define DFX_TAP_AGENT_SV

class dfx_tap_agent extends ovm_agent;

  dfx_tap_port_e TapNumPorts; // number of JTAG ports
  dfx_tap_virtual_sequencer dfx_tap_virt_seqr;
  dfx_tap_sequencer tap_sequencer_array[];
  dfx_tap_driver tap_driver_array[];
  dfx_tap_monitor tap_monitor_array[];

  JtagBfmSequencer jtag_bfm_seqr; // SIP compatibility
  JtagBfmTracker jtag_tracker_array[]; // SIP functionality
  JtagBfmInputMonitor jtag_ipmon_array[]; // SIP functionality
  JtagBfmOutputMonitor jtag_opmon_array[]; // SIP functionality
  ovm_analysis_port #(JtagBfmInMonSbrPkt) jtag_ipmon_port_array[]; // SIP functionality
  ovm_analysis_port #(JtagBfmOutMonSbrPkt) jtag_opmon_port_array[]; // SIP functionality
  ovm_event_pool jtag_eventPool[];

`ifdef _B_TAP_BFM_
  string TapStimFileName; // STIM file name
  int    TapStimFile;     // Pointer to STIM file
  semaphore TapStimFile_access; // FIXME: flow should allow the common semaphore at project env level
  tap_globals_s TapGlobals; // Current global parameters/status
`endif // `ifdef _B_TAP_BFM_

  `ovm_component_utils_begin(dfx_tap_agent)
    `ovm_field_enum(dfx_tap_port_e, TapNumPorts, OVM_DEFAULT)
  `ovm_component_utils_end

  function new(string name = "dfx_tap_agent", ovm_component parent = null);
    super.new(name, parent);

`ifdef _B_TAP_BFM_
    TapStimFile_access = new(1);
`endif
  endfunction : new

  function void build();
    dfx_tap_network dfx_tap_nw;

    super.build();

    for (dfx_tap_port_e tp_i = tp_i.first(); tp_i != TapNumPorts; tp_i = tp_i.next()) begin
      set_config_int({"tap_sequencer_", tp_i.name()}, "count", 0);
      set_config_int({"tap_sequencer_", tp_i.name()}, "port", tp_i);
      set_config_int({"tap_monitor_", tp_i.name()}, "port", tp_i);
      set_config_int({"tap_driver_", tp_i.name()}, "port", tp_i);
      set_config_int({"jtag_tracker_", tp_i.name()}, "my_port", tp_i);
      set_config_int({"jtag_ipmonitor_", tp_i.name()}, "my_port", tp_i);
      set_config_int({"jtag_opmonitor_", tp_i.name()}, "my_port", tp_i);
    end

    // Create TAP network object.
    //
    // Note:  This functionality has been moved to the TAP network class.
    //
    dfx_tap_nw = dfx_tap_network::get_handle("dfx_tap_nw", this);
    // `ovm_info(get_type_name(), "TAP network singleton accessed/created", OVM_HIGH)
    `ovm_info(get_type_name(), "TAP network singleton accessed/created", OVM_LOW)
    //
    dfx_tap_nw.tap_array = new[TapNumPorts];  // create before use
    //
    // Set TAP network to its initial (PowerGood) state.
    dfx_tap_nw.set_initial_state;

    jtag_bfm_seqr = JtagBfmSequencer::type_id::create("dfx_tap_virt_seqr", this);
    dfx_tap_virt_seqr = jtag_bfm_seqr;
    ovm_top.set_config_object("*", "dfx_tap_virtual_sequencer", dfx_tap_virt_seqr, 0);

    tap_sequencer_array = new[TapNumPorts];
    tap_monitor_array = new[TapNumPorts];
    tap_driver_array = new[TapNumPorts];

    // SIP functionality:
    jtag_tracker_array = new[TapNumPorts];
    jtag_ipmon_array = new[TapNumPorts];
    jtag_opmon_array = new[TapNumPorts];
    jtag_ipmon_port_array = new[TapNumPorts];
    jtag_opmon_port_array = new[TapNumPorts];
    jtag_eventPool = new[TapNumPorts];

`ifdef B_TAP_BFM_
    if(!$value$plusargs("TAP_STIM_FILE=%s", TapStimFileName)) begin
      if (!get_config_int("STIM_FILE_PTR", TapStimFile)) begin
          TapStimFileName = "tap.stim";
          TapStimFile = $fopen(TapStimFileName, "w");
          `ovm_info(get_type_name(), $psprintf("TAP output STIM file: %s", TapStimFileName), OVM_LOW)
      end
    end
    else begin
      TapStimFile = $fopen(TapStimFileName, "w");
      `ovm_info(get_type_name(), $psprintf("TAP output STIM file: %s", TapStimFileName), OVM_LOW)
    end
`endif // `ifdef _B_TAP_BFM_

    for (dfx_tap_port_e tp_i = tp_i.first(); tp_i != TapNumPorts; tp_i = tp_i.next()) begin
      tap_sequencer_array[tp_i] = dfx_tap_sequencer::type_id::create({"tap_sequencer_", tp_i.name()}, this);
      tap_monitor_array[tp_i] = dfx_tap_monitor::type_id::create({"tap_monitor_", tp_i.name()}, this);
      tap_driver_array[tp_i] = dfx_tap_driver::type_id::create({"tap_driver_", tp_i.name()}, this);
      jtag_tracker_array[tp_i] = JtagBfmTracker::type_id::create({"jtag_tracker_", tp_i.name()}, this);
      jtag_ipmon_array[tp_i] = JtagBfmInputMonitor::type_id::create({"jtag_ipmonitor_", tp_i.name()}, this);
      jtag_opmon_array[tp_i] = JtagBfmOutputMonitor::type_id::create({"jtag_opmonitor_", tp_i.name()}, this);
      jtag_ipmon_port_array[tp_i] = new({"jtag_ipmonitor_port_", tp_i.name()}, this);
      jtag_opmon_port_array[tp_i] = new({"jtag_opmonitor_port_", tp_i.name()}, this);
      jtag_eventPool[tp_i] = new({"JtagBfm_EventPool_", tp_i.name()});
      // Assign event pools before connect() to avoid modifying monitors unnecessarily.
      jtag_ipmon_array[tp_i].eventPool = jtag_eventPool[tp_i];
      jtag_opmon_array[tp_i].eventPool = jtag_eventPool[tp_i];

      // ovm_top.set_config_object("*", {"tap_sequencer_", tp_i.name()}, tap_sequencer_array[tp_i], 0);

`ifdef _B_TAP_BFM_
      begin
        dfx_tap_driver_b db;

        if (!$cast(db, tap_driver_array[tp_i]))
          `ovm_fatal(get_type_name(), "Set _B_TAP_BFM_ overrides")

        db.TapStimFile_access = TapStimFile_access;
        db.TapStimFile = TapStimFile;
        db.TapGlobals  = TapGlobals;
      end
`endif // _B_TAP_BFM_
    end

  endfunction : build

  function void connect();
    for (dfx_tap_port_e tp_i = tp_i.first(); tp_i != TapNumPorts; tp_i = tp_i.next()) begin
      dfx_tap_virt_seqr.tap_seqr_array[tp_i] = tap_sequencer_array[tp_i];

      tap_driver_array[tp_i].seq_item_port.connect(tap_sequencer_array[tp_i].seq_item_export);

      jtag_ipmon_array[tp_i].InputMonitorPort.connect(jtag_ipmon_port_array[tp_i]);
      jtag_opmon_array[tp_i].OutputMonitorPort.connect(jtag_opmon_port_array[tp_i]);
    end

  endfunction : connect

  function dfx_tapfsm_state_e get_current_fsm_state(dfx_tap_port_e port);
     if (int'(port) < TapNumPorts)
        return tap_driver_array[port].get_current_fsm_state();
     else
        `ovm_fatal(get_type_name(),
                   $psprintf("get_current_fsm_state(<port>): Requested port %s, index %0d does not exist (TapNumPorts = %0d)",
                             port.name(), port,TapNumPorts))
  endfunction : get_current_fsm_state

endclass : dfx_tap_agent

`endif // `ifndef DFX_TAP_AGENT_SV
