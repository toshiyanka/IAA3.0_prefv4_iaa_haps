//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapBaseTest.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAP NW
//
//
//    PURPOSE     : Test Component for the ENV
//    DESCRIPTION : Test component for the env. This component calls for the
//                  Global stop request
//----------------------------------------------------------------------

class TapBaseTest extends ovm_test;

    `ovm_component_utils(TapBaseTest)
    TapEnv Env;
    TapReportComponent ReportObject;
    ovm_report_handler ReportComponent;

     TapSequencePrimaryOnly SP;

    function new (string name = "TapBaseTest", ovm_component parent = null);
       super.new(name,parent);
       ReportComponent = new;
       ReportComponent.set_max_quit_count(2);
       ReportObject = new("ReportObject" , this);
       ReportObject.set_report_verbosity_level_hier(OVM_NONE);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env.MasterAgent", "is_active", OVM_ACTIVE);
        set_config_int("Env", "has_scoreboard",    OVM_PASSIVE);
        set_config_int("Env", "has_cov_collector", OVM_FLAGS_ON);
        set_config_int("Env", "quit_count", 2);
        set_config_int("Env", "set_verbosity", OVM_DEBUG);
        set_config_int("Env", "enable_clk_gating", OVM_ACTIVE);
        set_config_int("Env", "park_clk_at", OVM_PASSIVE);
        // Hassan This will stop random sequences from starting at their own
        set_config_int("Env.Ter0MasterAgent.Sequencer", "count", 0);
        set_config_int("Env.Ter1MasterAgent.Sequencer", "count", 0);
        set_config_int("Env.SecMasterAgent.Sequencer", "count", 0);
        set_config_int("Env.PriMasterAgent.Sequencer", "count", 0);
        set_config_int("S1","number_of_tap",2);

         // To Enable Tracker file in Monitors for both Agents
         set_config_int("Env.PriMasterAgent.InputMonitor", "primary_agent", 1);
         set_config_int("Env.SecMasterAgent.InputMonitor", "secondary_agent", 1);

         set_config_int("Env.PriMasterAgent.OutputMonitor", "primary_agent", 1);
         set_config_int("Env.SecMasterAgent.OutputMonitor", "secondary_agent", 1);

         // To Enable Tracker file in Agents
         set_config_int("Env.PriMasterAgent.JtagTracker", "primary_tracker", 1);
         set_config_int("Env.SecMasterAgent.JtagTracker", "secondary_tracker", 1);

        Env = TapEnv::type_id::create("Env", this);
    endfunction : build

    //function void connect();
    //    Env.assign_vi(Primary_if,Secondary_if,pif);
    //endfunction: connect

    virtual task run();
      ovm_report_info("TapTest","Test Starts!!!");
      SP = new("ALL Primary Mode");
      SP.start(Env.PriMasterAgent.Sequencer);
      ovm_report_info("TapTest","Configure Done");
      global_stop_request();
    endtask : run
endclass : TapBaseTest
