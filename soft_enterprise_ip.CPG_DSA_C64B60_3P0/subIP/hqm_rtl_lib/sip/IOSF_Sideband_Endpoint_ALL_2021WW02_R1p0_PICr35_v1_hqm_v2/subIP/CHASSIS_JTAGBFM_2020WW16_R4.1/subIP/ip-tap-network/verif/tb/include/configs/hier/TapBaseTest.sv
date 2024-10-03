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

class TapBaseTest extends ovm_test;

    JtagBfmCfg         jtagBfmCfg;
    TapEnv             Env;
    TapReportComponent ReportObject;
    ovm_report_handler ReportComponent;
    
     TapSequencePrimaryOnly SP;
    
    function new (string name = "TapBaseTest", ovm_component parent = null);
       super.new(name,parent);
       ReportComponent = new;
       ReportObject = new("ReportObject" , this);
    endfunction : new
    
    `ovm_component_utils_begin(TapBaseTest)
    `ovm_field_object (jtagBfmCfg, OVM_ALL_ON|OVM_NOPRINT)
    `ovm_component_utils_end


    virtual function void build();
        super.build();
        jtagBfmCfg = JtagBfmCfg::type_id::create("jtagBfmCfg", this);
        Env = TapEnv::type_id::create("Env", this);

        // To register the configuration descriptor    
        set_config_object("Env.*", "JtagBfmCfg", jtagBfmCfg, 0);

        jtagBfmCfg.quit_count        = 2;
        jtagBfmCfg.set_verbosity     = OVM_NONE;
        //jtagBfmCfg.set_verbosity     = OVM_LOW;
        //jtagBfmCfg.set_verbosity     = OVM_MEDIUM;
        //jtagBfmCfg.set_verbosity     = OVM_HIGH;
        //jtagBfmCfg.set_verbosity     = OVM_FULL;
        //jtagBfmCfg.set_verbosity     = OVM_DEBUG;
        jtagBfmCfg.enable_clk_gating = 1;
        jtagBfmCfg.park_clk_at       = 0;
        jtagBfmCfg.RESET_DELAY       = 10000;
        jtagBfmCfg.primary_tracker   = 1;
        jtagBfmCfg.secondary_tracker = 1;
        jtagBfmCfg.tertiary_tracker  = 0;
        jtagBfmCfg.tracker_name      = "STAP";

        set_config_int("Env.*", "quit_count",        jtagBfmCfg.quit_count);
        set_config_int("Env.*", "set_verbosity",     jtagBfmCfg.set_verbosity);
        set_config_int("Env.*", "enable_clk_gating", jtagBfmCfg.enable_clk_gating);
        set_config_int("Env.*", "park_clk_at",       jtagBfmCfg.park_clk_at);
        set_config_int("Env.*", "RESET_DELAY",       jtagBfmCfg.RESET_DELAY);

        set_config_int("Env.PriMasterAgent.*", "primary_tracker",   jtagBfmCfg.primary_tracker);
        set_config_int("Env.PriMasterAgent.*", "secondary_tracker", 0);
        
		set_config_int("Env.SecMasterAgent.*", "primary_tracker",   0);
        set_config_int("Env.SecMasterAgent.*", "secondary_tracker", jtagBfmCfg.secondary_tracker);
        
		set_config_int("Env.*", "tertiary_tracker",  jtagBfmCfg.tertiary_tracker);
        set_config_string("Env.*", "tracker_name",  jtagBfmCfg.tracker_name);

        // Set the Max Error count after which the simulation stops
        ReportComponent.set_max_quit_count(jtagBfmCfg.quit_count);

        set_config_int("Env", "has_scoreboard",    OVM_FLAGS_ON);
        set_config_int("Env", "has_cov_collector", OVM_FLAGS_ON);

        // Hassan This will stop random sequences from starting at their own
        set_config_int("Env.TerMasterAgent.Sequencer", "count", 0);
        set_config_int("Env.SecMasterAgent.Sequencer", "count", 0);
        set_config_int("Env.PriMasterAgent.Sequencer", "count", 0);
        set_config_int("S1","number_of_tap",2);

    endfunction : build

    // End of elaboration function for setting verbosity levels
    function void end_of_elaboration ();
       string msg;
       integer verb_level = OVM_NONE;
    
       super.end_of_elaboration ();
       print_config_settings ();
    
        if ($value$plusargs ("verbosity=%d", verb_level)) begin
           $swrite (msg, "plusarg: JTAG verbosity = %0d", verb_level);
           `ovm_info (get_type_name(), msg, 0);
            set_report_verbosity_level_hier(verb_level);
        end else begin
           //set_report_verbosity_level_hier(OVM_NONE);
           //set_report_verbosity_level_hier(OVM_LOW);
           //set_report_verbosity_level_hier(OVM_MEDIUM);
           //set_report_verbosity_level_hier(OVM_HIGH);
           //set_report_verbosity_level_hier(OVM_FULL);
           //set_report_verbosity_level_hier(OVM_DEBUG);
           set_report_verbosity_level_hier(jtagBfmCfg.set_verbosity);
        end   
    
       ovm_top.print_topology ();
    endfunction : end_of_elaboration

    //function void connect();
    //    Env.assign_vi(Primary_if,Secondary_if,Control_if);
    //endfunction: connect
    
    virtual task run();
      ovm_report_info("TapTest","Test Starts!!!");
      SP = new("ALL Primary Mode");
      SP.start(Env.PriMasterAgent.Sequencer);
      ovm_report_info("TapTest","Configure Done");
      global_stop_request();
    endtask : run
endclass : TapBaseTest
