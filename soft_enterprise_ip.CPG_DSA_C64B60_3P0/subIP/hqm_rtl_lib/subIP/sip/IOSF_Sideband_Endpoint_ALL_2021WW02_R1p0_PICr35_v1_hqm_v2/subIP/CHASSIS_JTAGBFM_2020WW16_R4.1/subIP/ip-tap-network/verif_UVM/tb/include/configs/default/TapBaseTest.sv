//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
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

    JtagBfmCfg         jtagBfmCfg_pri;
    JtagBfmCfg         jtagBfmCfg_sec;
    TapEnv             Env;
    TapReportComponent ReportObject;
    uvm_report_handler ReportComponent;
    
     TapSequencePrimaryOnly SP;
    
    function new (string name = "TapBaseTest", uvm_component parent = null);
       super.new(name,parent);
       ReportComponent = new;
       ReportObject = new("ReportObject" , this);
    endfunction : new
    
    `uvm_component_utils_begin(TapBaseTest)
    `uvm_field_object (jtagBfmCfg_pri, UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_object (jtagBfmCfg_sec, UVM_ALL_ON|UVM_NOPRINT)
    `uvm_component_utils_end


    virtual function void build_phase(uvm_phase phase);   
        super.build_phase(phase);
        jtagBfmCfg_pri = JtagBfmCfg::type_id::create("jtagBfmCfg_pri", this);
        jtagBfmCfg_sec = JtagBfmCfg::type_id::create("jtagBfmCfg_sec", this);
        Env = TapEnv::type_id::create("Env", this);

        // To register the configuration descriptor    
        uvm_config_object::set(this, "Env.PriMasterAgent*", "JtagBfmCfg", jtagBfmCfg_pri);
        uvm_config_object::set(this, "Env.SecMasterAgent*", "JtagBfmCfg", jtagBfmCfg_sec);

        jtagBfmCfg_pri.quit_count        = 2;
        jtagBfmCfg_pri.set_verbosity     = UVM_NONE;
        jtagBfmCfg_pri.enable_clk_gating = 1;
        jtagBfmCfg_pri.park_clk_at       = 0;
        jtagBfmCfg_pri.RESET_DELAY       = 10000;
        jtagBfmCfg_pri.primary_tracker   = 1;
        jtagBfmCfg_pri.secondary_tracker = 0;
        jtagBfmCfg_pri.tertiary_tracker  = 0;
        jtagBfmCfg_pri.tracker_name      = "STAP";

        jtagBfmCfg_sec.quit_count        = 2;
        jtagBfmCfg_sec.set_verbosity     = UVM_NONE;
        jtagBfmCfg_sec.enable_clk_gating = 1;
        jtagBfmCfg_sec.park_clk_at       = 0;
        jtagBfmCfg_sec.RESET_DELAY       = 10000;
        jtagBfmCfg_sec.primary_tracker   = 0;
        jtagBfmCfg_sec.secondary_tracker = 1;
        jtagBfmCfg_sec.tertiary_tracker  = 0;
        jtagBfmCfg_sec.tracker_name      = "SecTrack";

        uvm_config_int::set(this, "Env.PriMasterAgent*", "quit_count",        jtagBfmCfg_pri.quit_count);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "set_verbosity",     jtagBfmCfg_pri.set_verbosity);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "enable_clk_gating", jtagBfmCfg_pri.enable_clk_gating);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "park_clk_at",       jtagBfmCfg_pri.park_clk_at);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "RESET_DELAY",       jtagBfmCfg_pri.RESET_DELAY);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "primary_tracker",   jtagBfmCfg_pri.primary_tracker);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "secondary_tracker", jtagBfmCfg_pri.secondary_tracker);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "tertiary_tracker",  jtagBfmCfg_pri.tertiary_tracker);
        uvm_config_string::set(this, "Env.PriMasterAgent*", "tracker_name",   jtagBfmCfg_pri.tracker_name);

        uvm_config_int::set(this, "Env.SecMasterAgent*", "quit_count",        jtagBfmCfg_sec.quit_count);
        uvm_config_int::set(this, "Env.SecMasterAgent*", "set_verbosity",     jtagBfmCfg_sec.set_verbosity);
        uvm_config_int::set(this, "Env.SecMasterAgent*", "enable_clk_gating", jtagBfmCfg_sec.enable_clk_gating);
        uvm_config_int::set(this, "Env.SecMasterAgent*", "park_clk_at",       jtagBfmCfg_sec.park_clk_at);
        uvm_config_int::set(this, "Env.SecMasterAgent*", "RESET_DELAY",       jtagBfmCfg_sec.RESET_DELAY);
        uvm_config_int::set(this, "Env.SecMasterAgent*", "primary_tracker",   jtagBfmCfg_sec.primary_tracker);
        uvm_config_int::set(this, "Env.SecMasterAgent*", "secondary_tracker", jtagBfmCfg_sec.secondary_tracker);
        uvm_config_int::set(this, "Env.SecMasterAgent*", "tertiary_tracker",  jtagBfmCfg_sec.tertiary_tracker);
        uvm_config_string::set(this, "Env.SecMasterAgent*", "tracker_name",   jtagBfmCfg_sec.tracker_name);

        // Set the Max Error count after which the simulation stops
        ReportComponent.set_max_quit_count(jtagBfmCfg_pri.quit_count);

        uvm_config_int::set(this, "Env", "has_scoreboard",    UVM_FLAGS_ON);
        uvm_config_int::set(this, "Env", "has_cov_collector", UVM_FLAGS_ON);
        
        // Hassan This will stop random sequences from starting at their own
        uvm_config_int::set(this, "Env.SecMasterAgent.Sequencer", "count", 0);
        uvm_config_int::set(this, "Env.PriMasterAgent.Sequencer", "count", 0);
        uvm_config_int::set(this, "S1","number_of_tap",2);

    endfunction : build_phase

    // End of elaboration function for setting verbosity levels
    function void end_of_elaboration_phase (uvm_phase phase);
       string msg;
       integer verb_level = UVM_NONE;
    
       super.end_of_elaboration_phase (phase);
       print_config_settings ();
    
        if ($value$plusargs ("verbosity=%d", verb_level)) begin
           $swrite (msg, "plusarg: JTAG verbosity = %0d", verb_level);
           `uvm_info (get_type_name(), msg, 0);
            set_report_verbosity_level_hier(verb_level);
        end else begin
           //set_report_verbosity_level_hier(UVM_NONE);
           //set_report_verbosity_level_hier(UVM_LOW);
           //set_report_verbosity_level_hier(UVM_MEDIUM);
           //set_report_verbosity_level_hier(UVM_HIGH);
           //set_report_verbosity_level_hier(UVM_FULL);
           //set_report_verbosity_level_hier(UVM_DEBUG);
           set_report_verbosity_level_hier(jtagBfmCfg_pri.set_verbosity);
        end   
    
       uvm_top.print_topology ();
    endfunction : end_of_elaboration_phase
    
    //function void connect_phase(uvm_phase phase);
    //    Env.assign_vi(Primary_if,Secondary_if,Control_if);
    //endfunction : connect_phase
    
    virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTest","Test Starts!!!");
      SP = new("ALL Primary Mode");
      SP.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTest","Configure Done");
      //global_stop_request();
    endtask
endclass : TapBaseTest
