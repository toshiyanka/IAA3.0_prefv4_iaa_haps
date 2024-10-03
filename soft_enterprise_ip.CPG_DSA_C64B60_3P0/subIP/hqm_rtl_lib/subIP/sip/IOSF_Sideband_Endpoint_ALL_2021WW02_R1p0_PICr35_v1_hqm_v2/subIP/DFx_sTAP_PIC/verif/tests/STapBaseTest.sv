//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : STapBaseTest.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//
//    PURPOSE     : Test Component for the ENV
//    DESCRIPTION : Test component for the env. This component calls for the
//                  Global stop request
//----------------------------------------------------------------------

class STapBaseTest #(`STAP_DSP_TB_PARAMS_DECL) extends ovm_test;

    STapEnv #(`STAP_DSP_TB_PARAMS_INST) Env;
    STapReportComponent ReportObject;
    ovm_report_handler  ReportComponent;


    // Constructor
    function new (string name = "STapBaseTest", ovm_component parent = null);
        super.new(name,parent);
        ReportComponent = new;
        ReportComponent.set_max_quit_count(2);
        ReportObject = STapReportComponent::type_id::create("ReportObject" , this);
        ReportObject.set_report_verbosity_level_hier(OVM_NONE);
    endfunction : new

    // Register component with Factory
    `ovm_component_param_utils(STapBaseTest #(`STAP_DSP_TB_PARAMS_INST))

  ////  Virtual pin Interface for connection to the ENV
  //virtual stap_pin_if pin_if;

    // Build
    virtual function void build();
         super.build();
        set_config_int("Env", "has_scoreboard",    1);
        set_config_int("Env", "has_cov_collector", 1);
        set_config_int("Env", "quit_count", 2);
        set_config_int("Env", "set_verbosity", OVM_DEBUG);
        set_config_int("Env", "enable_clk_gating", OVM_ACTIVE);
        set_config_int("Env", "park_clk_at", OVM_PASSIVE);
        // Hassan This will stop random sequences from starting at their own
        set_config_int("Env.stap_JtagMasterAgent.Sequencer", "count", 0);
        set_config_int("Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr", "count", 0);
        Env = STapEnv#(`STAP_DSP_TB_PARAMS_INST)::type_id::create("Env", this);
        // Enabling runtime tracker  
        set_config_int("*", "jtag_bfm_tracker_en",        1);
        set_config_string("*", "tracker_name",         "sTAP");
        set_config_int("*", "jtag_bfm_runtime_tracker_en",1);

      // Converged TAP BFM config parameters follow.
      
`ifdef USE_CONVERGED_JTAGBFM
      set_config_int("*", "enable_dfx", 1);
      set_config_int("*.dfx_tap_virt_seqr", "count", 0);

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
      // set_config_int("*tap_agent*", "<TAP enum>_port_override", TAP_PORT_P1);
      // set_config_int("*tap_agent*", "<TAP enum>_state_override", TAP_STATE_NORMAL);
      // set_config_int("*tap_agent*", "dfx_tap_fsm_initial_state_TAP_PORT_P1", DFX_TAP_TS_RTI);
`endif
    endfunction : build

    //Connect Pin Interface to The ENV
    //function void connect();
    //     Env.assign_vi(PinIf);
    //endfunction: connect

    // Run Task
    virtual task run();
         `ovm_info("STapBaseTest","Test Starts!!!",OVM_LOW);
         `ovm_info("STapBaseTest","TapBase Test Completed!!!",OVM_LOW);
         global_stop_request();
    endtask : run

endclass : STapBaseTest
