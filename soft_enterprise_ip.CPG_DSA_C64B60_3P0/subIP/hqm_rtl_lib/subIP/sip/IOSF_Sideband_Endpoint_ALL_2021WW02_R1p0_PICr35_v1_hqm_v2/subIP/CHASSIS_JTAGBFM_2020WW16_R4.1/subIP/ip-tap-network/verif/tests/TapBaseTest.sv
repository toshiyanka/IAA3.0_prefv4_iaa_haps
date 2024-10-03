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

    JtagBfmCfg         jtagBfmCfg_pri;
    JtagBfmCfg         jtagBfmCfg_sec;
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
    `ovm_field_object (jtagBfmCfg_pri, OVM_ALL_ON|OVM_NOPRINT)
    `ovm_field_object (jtagBfmCfg_sec, OVM_ALL_ON|OVM_NOPRINT)
    `ovm_component_utils_end


    virtual function void build();
        super.build();
        jtagBfmCfg_pri = JtagBfmCfg::type_id::create("jtagBfmCfg_pri", this);
        jtagBfmCfg_sec = JtagBfmCfg::type_id::create("jtagBfmCfg_sec", this);
        Env = TapEnv::type_id::create("Env", this);

        // To register the configuration descriptor    
        set_config_object("Env.PriMasterAgent*", "JtagBfmCfg", jtagBfmCfg_pri, 0);
        set_config_object("Env.SecMasterAgent*", "JtagBfmCfg", jtagBfmCfg_sec, 0);

        jtagBfmCfg_pri.quit_count                  = 1000;
        jtagBfmCfg_pri.set_verbosity               = OVM_NONE;
        jtagBfmCfg_pri.enable_clk_gating           = 1;
        jtagBfmCfg_pri.park_clk_at                 = 0;
        jtagBfmCfg_pri.RESET_DELAY                 = 10000;
        jtagBfmCfg_pri.jtag_bfm_tracker_en         = 1;
        jtagBfmCfg_pri.tracker_name                = "STAP";
        jtagBfmCfg_pri.jtag_bfm_runtime_tracker_en = 1;      // switch to enable primary runtime tracker 1 - enable
                                                             //                                          0 - disable
                                                             // can use set_config_int("Env.SecMasterAgent*", "jtag_bfm_runtime_tracker_en",1);
                                                             // to enable the run time tracker explicitly.  
 
        jtagBfmCfg_sec.quit_count                  = 2;
        jtagBfmCfg_sec.set_verbosity               = OVM_NONE;
        jtagBfmCfg_sec.enable_clk_gating           = 1;
        jtagBfmCfg_sec.park_clk_at                 = 0;
        jtagBfmCfg_sec.RESET_DELAY                 = 10000;
        jtagBfmCfg_sec.jtag_bfm_tracker_en         = 1;
        jtagBfmCfg_sec.tracker_name                = "STAP";
        jtagBfmCfg_sec.jtag_bfm_runtime_tracker_en = 1;      //switch to enable secondary runtime tracker : refer primary

        set_config_int("Env.PriMasterAgent*", "quit_count",                 jtagBfmCfg_pri.quit_count);
        set_config_int("Env.PriMasterAgent*", "set_verbosity",              jtagBfmCfg_pri.set_verbosity);
        set_config_int("Env.PriMasterAgent*", "enable_clk_gating",          jtagBfmCfg_pri.enable_clk_gating);
        set_config_int("Env.PriMasterAgent*", "park_clk_at",                jtagBfmCfg_pri.park_clk_at);
        set_config_int("Env.PriMasterAgent*", "RESET_DELAY",                jtagBfmCfg_pri.RESET_DELAY);
        set_config_int("Env.PriMasterAgent*", "jtag_bfm_tracker_en",        jtagBfmCfg_pri.jtag_bfm_tracker_en);
        set_config_string("Env.PriMasterAgent*", "tracker_name",               jtagBfmCfg_pri.tracker_name);
        set_config_int("Env.PriMasterAgent*", "jtag_bfm_runtime_tracker_en",jtagBfmCfg_pri.jtag_bfm_runtime_tracker_en);

        set_config_int("Env.SecMasterAgent*", "quit_count",                 jtagBfmCfg_sec.quit_count);
        set_config_int("Env.SecMasterAgent*", "set_verbosity",              jtagBfmCfg_sec.set_verbosity);
        set_config_int("Env.SecMasterAgent*", "enable_clk_gating",          jtagBfmCfg_sec.enable_clk_gating);
        set_config_int("Env.SecMasterAgent*", "park_clk_at",                jtagBfmCfg_sec.park_clk_at);
        set_config_int("Env.SecMasterAgent*", "RESET_DELAY",                jtagBfmCfg_sec.RESET_DELAY);
        set_config_int("Env.SecMasterAgent*", "jtag_bfm_tracker_en",        jtagBfmCfg_sec.jtag_bfm_tracker_en);
        set_config_string("Env.SecMasterAgent*", "tracker_name",               jtagBfmCfg_sec.tracker_name);
        set_config_int("Env.SecMasterAgent*", "jtag_bfm_runtime_tracker_en",jtagBfmCfg_sec.jtag_bfm_runtime_tracker_en);

        // Set the Max Error count after which the simulation stops
        ReportComponent.set_max_quit_count(jtagBfmCfg_pri.quit_count);

        set_config_int("Env", "has_scoreboard",    OVM_FLAGS_ON);
        set_config_int("Env", "has_cov_collector", OVM_FLAGS_ON);
        
        // Hassan This will stop random sequences from starting at their own
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
           set_report_verbosity_level_hier(jtagBfmCfg_pri.set_verbosity);
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
