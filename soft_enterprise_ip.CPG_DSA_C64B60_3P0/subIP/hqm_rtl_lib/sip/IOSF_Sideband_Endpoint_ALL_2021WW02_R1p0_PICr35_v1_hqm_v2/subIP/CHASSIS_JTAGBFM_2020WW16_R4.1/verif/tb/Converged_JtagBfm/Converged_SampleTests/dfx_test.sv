// =====================================================================================================
// FileName          : dfx_test.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon Dec  8 21:30:02 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFX test to run any sequence
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TEST_SV
`define DFX_TEST_SV

class dfx_test extends `TEST_BASE;
  `ovm_component_utils(dfx_test)

  string test_sequence, tap_sequencer;

  function new(string name = "dfx_test", ovm_component parent = null);
    super.new(name, parent);
  endfunction: new

  virtual function void build();
    super.build();

    set_config_int("*", "enable_dfx", 1);
    set_config_int("*.dfx_tap_virt_seqr", "count", 0);
    // set_config_int("*tap_agent*", "RESET_DELAY", 3);

    if ($test$plusargs("ON_DEMAND_TCK_P0"))
      set_config_int("*tap_agent*", "dfx_tap_on_demand_tck_TAP_PORT_P0", 1);

    if ($test$plusargs("ON_DEMAND_TCK_P1"))
      set_config_int("*tap_agent*", "dfx_tap_on_demand_tck_TAP_PORT_P1", 1);

    if ($test$plusargs("USE_TAP_SELECT_OVR"))
      set_config_int("*tap_agent*", "tapc_select_ovr", 1);

    // As needed (for example):
    // set_config_int("*tap_agent*", "dfx_tap_avoid_race_TAP_PORT_P0", 0);
    // set_config_int("*tap_agent*", "dfx_tap_avoid_race_TAP_PORT_P1", 0);

    // As needed (for example):
    // set_config_int("*tap_agent*", "RDUVNNTAP0_port_override", TAP_PORT_P1);
    // set_config_int("*tap_agent*", "RDUVNNTAP0_state_override", TAP_STATE_NORMAL);
    // set_config_int("*tap_agent*", "dfx_tap_fsm_initial_state_TAP_PORT_P1", DFX_TAP_TS_RTI);
  endfunction: build

  virtual function void connect();
    super.connect();

    if (!$value$plusargs("DFX_TEST_SEQUENCE=%s", test_sequence))
      `ovm_fatal(get_type_name(), "Test sequence to run not specified using DFX_TEST_SEQUENCE plusarg")

    if ($value$plusargs("DFX_TAP_SEQUENCER=%s", tap_sequencer)) begin
      if (tap_sequencer != "dfx_tap_virtual_sequencer" /* && tap_sequencer != "JtagBfmSequencer" */)
        `ovm_fatal(get_type_name(), "Invalid TAP sequencer specified")
    end else
      tap_sequencer = "dfx_tap_virtual_sequencer";

    `ovm_info(get_type_name(), {"Running DFx sequence ", test_sequence, " on sequencer ", tap_sequencer}, OVM_NONE)

  endfunction : connect

  task run();
    ovm_sequence ds; // DFx sequence
    ovm_object ts; // TAP sequencer
    dfx_tap_sequencer dts;
    dfx_tap_virtual_sequencer dtvs;

    // Wait for a signal or a certain amount of time?
    #2.1ns;

    $cast(ds, create_object(test_sequence, test_sequence));
    if (ds == null)
      `ovm_fatal(get_type_name(), {"Could not create sequence ", test_sequence})

    if (!get_config_object(tap_sequencer, ts, 0))
      `ovm_fatal(get_type_name(), {"Could not find TAP sequencer ", tap_sequencer})

    // DFx sequences currently run only on the TAP virtual sequencer.
    if (!$cast(dtvs, ts))
      `ovm_fatal(get_type_name(), "TAP sequencer not of the right type")

    ds.start(dtvs);

    global_stop_request();

  endtask : run

endclass : dfx_test

`endif // `ifndef DFX_TEST_SV
