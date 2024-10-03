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

class TapBaseTest extends uvm_test;

    `uvm_component_utils(TapBaseTest)
    TapEnv Env;
    TapReportComponent ReportObject;
    uvm_report_handler ReportComponent;

     TapSequencePrimaryOnly SP;

    function new (string name = "TapBaseTest", uvm_component parent = null);
       super.new(name,parent);
       ReportComponent = new;
       ReportComponent.set_max_quit_count(2);
       ReportObject = new("ReportObject" , this);
       ReportObject.set_report_verbosity_level_hier(UVM_NONE);
    endfunction : new

    virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        uvm_config_int::set(this, "Env.MasterAgent", "is_active", UVM_ACTIVE);
        uvm_config_int::set(this, "Env", "has_scoreboard",    UVM_PASSIVE);
        uvm_config_int::set(this, "Env", "has_cov_collector", UVM_FLAGS_ON);
        uvm_config_int::set(this, "Env", "quit_count", 2);
        uvm_config_int::set(this, "Env", "set_verbosity", UVM_DEBUG);
        uvm_config_int::set(this, "Env", "enable_clk_gating", UVM_ACTIVE);
        uvm_config_int::set(this, "Env", "park_clk_at", UVM_PASSIVE);
        // Hassan This will stop random sequences from starting at their own
        uvm_config_int::set(this, "Env.Ter0MasterAgent.Sequencer", "count", 0);
        uvm_config_int::set(this, "Env.Ter1MasterAgent.Sequencer", "count", 0);
        uvm_config_int::set(this, "Env.SecMasterAgent.Sequencer", "count", 0);
        uvm_config_int::set(this, "Env.PriMasterAgent.Sequencer", "count", 0);
        uvm_config_int::set(this, "S1","number_of_tap",2);

         // To Enable Tracker file in Monitors for both Agents
         uvm_config_int::set(this, "Env.PriMasterAgent.InputMonitor", "primary_agent", 1);
         uvm_config_int::set(this, "Env.SecMasterAgent.InputMonitor", "secondary_agent", 1);

         uvm_config_int::set(this, "Env.PriMasterAgent.OutputMonitor", "primary_agent", 1);
         uvm_config_int::set(this, "Env.SecMasterAgent.OutputMonitor", "secondary_agent", 1);

         // To Enable Tracker file in Agents
         uvm_config_int::set(this, "Env.PriMasterAgent.JtagTracker", "primary_tracker", 1);
         uvm_config_int::set(this, "Env.SecMasterAgent.JtagTracker", "secondary_tracker", 1);

        Env = TapEnv::type_id::create("Env", this);
    endfunction : build_phase

    //function void connect_phase(uvm_phase phase);
    //    Env.assign_vi(Primary_if,Secondary_if,pif);
    //endfunction : connect_phase

    virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTest","Test Starts!!!");
      SP = new("ALL Primary Mode");
      SP.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTest","Configure Done");
      global_stop_request();
    endtask
endclass : TapBaseTest
