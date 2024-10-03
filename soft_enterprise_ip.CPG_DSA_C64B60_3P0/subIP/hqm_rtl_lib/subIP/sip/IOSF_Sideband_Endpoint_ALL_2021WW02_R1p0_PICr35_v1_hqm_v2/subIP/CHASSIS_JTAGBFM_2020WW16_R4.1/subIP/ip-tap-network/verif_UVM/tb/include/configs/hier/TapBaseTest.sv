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

    JtagBfmCfg         jtagBfmCfg;
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
    `uvm_field_object (jtagBfmCfg, UVM_ALL_ON|UVM_NOPRINT)
    `uvm_component_utils_end


    virtual function void build_phase(uvm_phase phase);   
        super.build_phase(phase);
        jtagBfmCfg = JtagBfmCfg::type_id::create("jtagBfmCfg", this);
        Env = TapEnv::type_id::create("Env", this);

        // To register the configuration descriptor    
        uvm_config_object::set(this, "Env.*", "JtagBfmCfg", jtagBfmCfg);

        jtagBfmCfg.quit_count        = 2;
        jtagBfmCfg.set_verbosity     = UVM_NONE;
        //jtagBfmCfg.set_verbosity     = UVM_LOW;
        //jtagBfmCfg.set_verbosity     = UVM_MEDIUM;
        //jtagBfmCfg.set_verbosity     = UVM_HIGH;
        //jtagBfmCfg.set_verbosity     = UVM_FULL;
        //jtagBfmCfg.set_verbosity     = UVM_DEBUG;
        jtagBfmCfg.enable_clk_gating = 1;
        jtagBfmCfg.park_clk_at       = 0;
        jtagBfmCfg.RESET_DELAY       = 10000;
        jtagBfmCfg.primary_tracker   = 1;
        jtagBfmCfg.secondary_tracker = 1;
        jtagBfmCfg.tertiary_tracker  = 0;
        jtagBfmCfg.tracker_name      = "STAP";

        uvm_config_int::set(this, "Env.*", "quit_count",        jtagBfmCfg.quit_count);
        uvm_config_int::set(this, "Env.*", "set_verbosity",     jtagBfmCfg.set_verbosity);
        uvm_config_int::set(this, "Env.*", "enable_clk_gating", jtagBfmCfg.enable_clk_gating);
        uvm_config_int::set(this, "Env.*", "park_clk_at",       jtagBfmCfg.park_clk_at);
        uvm_config_int::set(this, "Env.*", "RESET_DELAY",       jtagBfmCfg.RESET_DELAY);

        uvm_config_int::set(this, "Env.PriMasterAgent.*", "primary_tracker",   jtagBfmCfg.primary_tracker);
        uvm_config_int::set(this, "Env.PriMasterAgent.*", "secondary_tracker", 0);
        
		uvm_config_int::set(this, "Env.SecMasterAgent.*", "primary_tracker",   0);
        uvm_config_int::set(this, "Env.SecMasterAgent.*", "secondary_tracker", jtagBfmCfg.secondary_tracker);
        
		uvm_config_int::set(this, "Env.*", "tertiary_tracker",  jtagBfmCfg.tertiary_tracker);
        uvm_config_string::set(this, "Env.*", "tracker_name",  jtagBfmCfg.tracker_name);

        // Set the Max Error count after which the simulation stops
        ReportComponent.set_max_quit_count(jtagBfmCfg.quit_count);

        uvm_config_int::set(this, "Env", "has_scoreboard",    UVM_FLAGS_ON);
        uvm_config_int::set(this, "Env", "has_cov_collector", UVM_FLAGS_ON);

        // Hassan This will stop random sequences from starting at their own
        uvm_config_int::set(this, "Env.TerMasterAgent.Sequencer", "count", 0);
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
           set_report_verbosity_level_hier(jtagBfmCfg.set_verbosity);
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
