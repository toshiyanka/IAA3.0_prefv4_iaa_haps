//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : STapTests.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//
//    PURPOSE     : Tests
//    DESCRIPTION : This component has all the test present in the ENV.
//                  Each Tests call for the corresponding sequneces.
//----------------------------------------------------------------------

//------------------------------------
// ONLY SLVIDCODE TEST when earlybooteexit is low.
//------------------------------------
class TapTestOnlySLVIDCODE_EBEL extends STapBaseTest;

    `ovm_component_utils(TapTestOnlySLVIDCODE_EBEL)
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    OnlySLVIDCODE     OSLV;

    function new (string name = "TapTestOnlySLVIDCODE_EBEL", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
		set_config_int("*.dfx_tap_virt_seqr", "count", 0);
    endfunction : build

    virtual task run();
        ovm_report_info("TapTestOnlySLVIDCODE_EBEL","Test Starts!!!");
        SUL   = SecurityUnlocked ::type_id::create("Security Unlocked Mode",this);
        EBEL  = EarlyBootExitLOW ::type_id::create("Early Boot Exit",this);
        OSLV  = OnlySLVIDCODE    ::type_id::create("ALL Primary Mode",this);

        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OSLV.start(Env.tap_agent.dfx_tap_virt_seqr);
        ovm_report_info("TapTestOnlySLVIDCODE_EBEL","Test Completed!!!");
        global_stop_request();
    endtask : run
endclass : TapTestOnlySLVIDCODE_EBEL

//------------------------------------
// ONLY BYPASS TEST when earlybooteexit is low.
//------------------------------------
class TapTestBypass extends STapBaseTest;

    `ovm_component_utils(TapTestBypass)
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    OnlyBypass        OB;

    function new (string name = "TapTestBypass", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
		set_config_int("*.dfx_tap_virt_seqr", "count", 0);
    endfunction : build

    virtual task run();
        ovm_report_info("TapTestBypass","Test Starts!!!");
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = OnlyBypass ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.tap_agent.dfx_tap_virt_seqr);
        ovm_report_info("TapTestBypass","Test Completed!!!");
        global_stop_request();
    endtask : run
endclass : TapTestBypass

//------------------------------------
// REGISTER ACCESS TEST
//------------------------------------
class TapTestRegisterAccess extends STapBaseTest;

    `ovm_component_utils(TapTestRegisterAccess)

    TapSequenceMultipleTapRegisterAccess SP;
    SecurityUnlocked                     SUL;

    function new (string name = "TapTestRegisterAccess", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
		set_config_int("*.dfx_tap_virt_seqr", "count", 0);
    endfunction : build

    virtual task run();
        ovm_report_info("TapTestRegisterAccess","Test Starts!!!");
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceMultipleTapRegisterAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.tap_agent.dfx_tap_virt_seqr);
        //#200000000;
        ovm_report_info("TapTestRegisterAccess","Test Completed!!!");
        global_stop_request();
    endtask : run
endclass : TapTestRegisterAccess

