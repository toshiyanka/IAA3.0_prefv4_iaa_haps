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
// ONLY BYPASS TEST when earlybooteexit is low.
//------------------------------------
class TapTestOnlyBypassEBEL extends STapBaseTest;

    `ovm_component_utils(TapTestOnlyBypassEBEL)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    OnlyBypass        OB;

    function new (string name = "TapTestOnlyBypassEBEL", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestOnlyBypassEBEL","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = OnlyBypass ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestOnlyBypassEBEL","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestOnlyBypassEBEL

//------------------------------------
// ONLY BYPASS TEST
//------------------------------------
class TapTestOnlyBypass extends STapBaseTest;

    `ovm_component_utils(TapTestOnlyBypass)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    OnlyBypass        OB;
    Drive_EBE_Low     EBE;
    OEMUnlocked       OEMUL;

    function new (string name = "TapTestOnlyBypass", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestOnlyBypass","Test Starts!!!",OVM_LOW);
        SL    = SecurityLocked     ::type_id::create("Security Locked Mode",this);
        PG    = PowergoodReset     ::type_id::create("Powergood reset",this);
        SUL   = SecurityUnlocked   ::type_id::create("Security Unlocked Mode",this);
        OB    = OnlyBypass         ::type_id::create("ALL Primary Mode",this);
        EBE   = Drive_EBE_Low      ::type_id::create("Early Boot Exit LOW",this);
        OEMUL = OEMUnlocked        ::type_id::create("Security Unlocked Mode",this);

        //Feature Enable is red
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        EBE.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);

        //Feature Enable is Orange
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OEMUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        EBE.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);

        //Feature Enable is Green
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        EBE.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);

        `ovm_info("TapTestOnlyBypass","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestOnlyBypass
//------------------------------------
// ONLY SuppressUpdateCapture TEST
//------------------------------------
class TapTestSuppressUpdateCapture extends STapBaseTest;

    `ovm_component_utils(TapTestSuppressUpdateCapture)
    SecurityLocked        SL;
    PowergoodReset        PG;
    SecurityUnlocked      SUL;
    SuppressUpdateCapture SUC;
    Drive_EBE_Low         EBE;
    OEMUnlocked           OEMUL;

    function new (string name = "TapTestSuppressUpdateCapture", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        //set_config_int("Env", "has_scoreboard",    0);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestSuppressUpdateCapture","Test Starts!!!",OVM_LOW);
        SL    = SecurityLocked        ::type_id::create("Security Locked Mode",this);
        PG    = PowergoodReset        ::type_id::create("Powergood reset",this);
        SUL   = SecurityUnlocked      ::type_id::create("Security Unlocked Mode",this);
        SUC   = SuppressUpdateCapture ::type_id::create("ALL Primary Mode",this);
        EBE   = Drive_EBE_Low         ::type_id::create("Early Boot Exit LOW",this);
        OEMUL = OEMUnlocked           ::type_id::create("Security Unlocked Mode",this);

        //Feature Enable is red
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SUC.start(Env.stap_JtagMasterAgent.Sequencer);
        EBE.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);

     //   //Feature Enable is Orange
     //   SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
     //   PG.start(Env.stap_JtagMasterAgent.Sequencer);
     //   SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
     //   OEMUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
     //   SUC.start(Env.stap_JtagMasterAgent.Sequencer);
     //   EBE.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);

     //   //Feature Enable is Green
     //   SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
     //   PG.start(Env.stap_JtagMasterAgent.Sequencer);
     //   SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
     //   SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
     //   SUC.start(Env.stap_JtagMasterAgent.Sequencer);
     //   EBE.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);

        `ovm_info("TapTestSuppressUpdateCapture","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestSuppressUpdateCapture


//------------------------------------
// ONLY SLVIDCODE TEST when earlybooteexit is low.
//------------------------------------
class TapTestOnlySLVIDCODE_EBEL extends STapBaseTest;

    `ovm_component_utils(TapTestOnlySLVIDCODE_EBEL)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    OnlySLVIDCODE     OSLV;

    function new (string name = "TapTestOnlySLVIDCODE_EBEL", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestOnlySLVIDCODE_EBEL","Test Starts!!!",OVM_LOW);
        SL    = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG    = PowergoodReset   ::type_id::create("Powergood reset",this);
        SUL   = SecurityUnlocked ::type_id::create("Security Unlocked Mode",this);
        EBEL  = EarlyBootExitLOW ::type_id::create("Early Boot Exit",this);
        OSLV  = OnlySLVIDCODE    ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OSLV.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestOnlySLVIDCODE_EBEL","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestOnlySLVIDCODE_EBEL

//------------------------------------
// ONLY SLVIDCODE TEST
//------------------------------------
class TapTestOnlySLVIDCODE extends STapBaseTest;

    `ovm_component_utils(TapTestOnlySLVIDCODE)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    OnlySLVIDCODE     OSLV;

    function new (string name = "TapTestOnlySLVIDCODE", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestOnlySLVIDCODE","Test Starts!!!",OVM_LOW);
        SL    = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG    = PowergoodReset   ::type_id::create("Powergood reset",this);
        SUL   = SecurityUnlocked ::type_id::create("Security Unlocked Mode",this);
        OSLV  = OnlySLVIDCODE    ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OSLV.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestOnlySLVIDCODE","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestOnlySLVIDCODE


//-------------------------------------------
//Idcode read test when stap_isol_en_b is LOW
//-------------------------------------------

class Rd_tdr_isol_en_test extends STapBaseTest;

    `ovm_component_utils(Rd_tdr_isol_en_test)
    
    virtual stap_pin_if pif;
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    Rd_tdr_isol_en   RD;


    function new (string name = "Rd_tdr_isol_en_test", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    0);
        begin
        ovm_object temp;
        STapVifContainer  vif_container;
         assert(get_config_object("V_STAP_PINIF", temp));
        $cast(vif_container, temp);
        pif = vif_container.get_v_if();
       end
    endfunction : build

    virtual task run();
        `ovm_info("Rd_tdr_isol_en_test","Test Starts!!!",OVM_LOW);
       
        SL    = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG    = PowergoodReset   ::type_id::create("Powergood reset",this);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL   = SecurityUnlocked ::type_id::create("Security Unlocked Mode",this);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
       
       #30;
       pif.stap_isol_en_b = 'b0;
       pif.ftap_pwrdomain_rst_b='b0;
        
        RD  =  Rd_tdr_isol_en::type_id::create("read tdr",this);
        RD.set_mode(0);
        RD.start(Env.stap_JtagMasterAgent.Sequencer);
        
         pif.stap_isol_en_b = 'b0;
         pif.ftap_pwrdomain_rst_b='b1;
         RD  = Rd_tdr_isol_en::type_id::create("read tdr",this);
         RD.set_mode(1);
         RD.start(Env.stap_JtagMasterAgent.Sequencer);
         
         pif.stap_isol_en_b = 'b1;
         pif.ftap_pwrdomain_rst_b='b1;
         RD  =   Rd_tdr_isol_en::type_id::create("read tdr",this);
         RD.set_mode(0);
         RD.start(Env.stap_JtagMasterAgent.Sequencer);
         
          pif.stap_isol_en_b = 'b1;
          pif.ftap_pwrdomain_rst_b='b0;
          RD  =   Rd_tdr_isol_en::type_id::create("read tdr",this);
          RD.set_mode(2);
          RD.start(Env.stap_JtagMasterAgent.Sequencer);
         pif.ftap_pwrdomain_rst_b='b1;

         #200000000;
        `ovm_info("Rd_tdr_isol_en_test","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : Rd_tdr_isol_en_test



//------------------------------------
// BYPASS TEST
//------------------------------------
class TapTestBypass extends STapBaseTest;

    `ovm_component_utils(TapTestBypass)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    TapSequenceBypass SP;

    function new (string name = "TapTestBypass", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestBypass","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked    ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset    ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceBypass ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestBypass","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestBypass

//------------------------------------
// REGISTER ACCESS TEST
//------------------------------------
//class TapTestSuppressRegisterAccess extends STapBaseTest;
//
//    `ovm_component_utils(TapTestSuppressRegisterAccess)
//
//    MultipleTapRegSuppressUpdateCapture  SP;
//    PowergoodReset                       PG;
//    SecurityLocked                       SL;
//    SecurityUnlocked                     SUL;
//
//    function new (string name = "TapTestSuppressRegisterAccess", ovm_component parent = null);
//        super.new(name,parent);
//    endfunction : new
//
//    virtual function void build();
//        super.build();
//        set_config_int("Env", "quit_count", 32);
//    endfunction : build
//
//    virtual task run();
//        `ovm_info("TapTestSuppressRegisterAccess","Test Starts!!!",OVM_LOW);
//        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
//        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
//        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
//        SP  = MultipleTapRegSuppressUpdateCapture::type_id::create("ALL Primary Mode",this);
//
//        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
//        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
//        PG.start(Env.stap_JtagMasterAgent.Sequencer);
//        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
//        SP.start(Env.stap_JtagMasterAgent.Sequencer);
//        //#200000000;
//        `ovm_info("TapTestSuppressRegisterAccess","Test Completed!!!",OVM_LOW);
//        global_stop_request();
//    endtask : run
//endclass : TapTestSuppressRegisterAccess

//------------------------------------
// REGISTER ACCESS TEST
//------------------------------------
class TapTestRegisterAccess extends STapBaseTest;

    `ovm_component_utils(TapTestRegisterAccess)

    TapSequenceMultipleTapRegisterAccess SP;
    PowergoodReset                       PG;
    SecurityLocked                       SL;
    SecurityUnlocked                     SUL;

    function new (string name = "TapTestRegisterAccess", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestRegisterAccess","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceMultipleTapRegisterAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestRegisterAccess","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestRegisterAccess

//------------------------------------
// REGISTER ACCESS TEST
//------------------------------------
class TapTestRegisterAccess_EnDebug extends STapBaseTest;

    `ovm_component_utils(TapTestRegisterAccess_EnDebug)

    TapSequenceMultipleTapRegisterAccess SP;
    PowergoodReset                       PG;
    SecurityLocked                       SL;
    EnDebugUnlocked                      ENDEBUGUL;

    function new (string name = "TapTestRegisterAccess_EnDebug", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestRegisterAccess_EnDebug","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        ENDEBUGUL = EnDebugUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceMultipleTapRegisterAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        ENDEBUGUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestRegisterAccess_EnDebug","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestRegisterAccess_EnDebug

//------------------------------------------
// Test To Trasnit Through All FSM States
//------------------------------------------
class TapTestFsmStates extends STapBaseTest;

    `ovm_component_utils(TapTestFsmStates)

    TapSequenceFsmStates SP;
    PowergoodReset       PG;
    SecurityLocked       SL;
    SecurityUnlocked     SUL;

    function new (string name = "TapTestFsmStates", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestFsmStates","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceFsmStates ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestFsmStates","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestFsmStates

//--------------------------------------------------------------------------------
//  Test To Access WTAP NETWORK and 0.7 TAP NW Registers and then access Data Registers
//--------------------------------------------------------------------------------
class TapTestNetworkRegisterAccess extends STapBaseTest;

    `ovm_component_utils(TapTestNetworkRegisterAccess)

    TapSequenceNetworkRegisterAccess  SP;
    PowergoodReset                    PG;
    SecurityLocked                    SL;
    SecurityUnlocked                  SUL;

    function new (string name = "TapTestNetworkRegisterAccess", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestNetworkRegisterAccess","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceNetworkRegisterAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestNetworkRegisterAccess","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestNetworkRegisterAccess

//--------------------------------------------------------------------------------
//  Test to Access Boundary Scan Registers
//--------------------------------------------------------------------------------
class TapTestBoundaryRegisterAccess extends STapBaseTest;

    `ovm_component_utils(TapTestBoundaryRegisterAccess)

    TapSequenceBoundaryRegisterAccess SP;
    PowergoodReset                    PG;
    SecurityLocked                    SL;
    SecurityUnlocked                  SUL;

    function new (string name = "TapTestBoundaryRegisterAccess", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestBoundaryRegisterAccess","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceBoundaryRegisterAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestBoundaryRegisterAccess","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestBoundaryRegisterAccess

//--------------------------------------------------------------------------------
//  Test to Check TMS Glitch
//--------------------------------------------------------------------------------
class TapTestTmsGlitch extends STapBaseTest;

    `ovm_component_utils(TapTestTmsGlitch)

    TapSequenceTmsGlitch SP;
    PowergoodReset       PG;
    SecurityLocked       SL;
    SecurityUnlocked     SUL;

    function new (string name = "TapTestTmsGlitch", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_string("Env.stap_JtagMasterAgent.Sequencer", "default_sequence", "TapSequenceTmsGlitch");
    endfunction : build

    virtual task run();
        `ovm_info("TapTestTmsGlitch","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceTmsGlitch ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestTmsGlitch","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestTmsGlitch

//--------------------------------------------------------------------------------
//  Random Test
//--------------------------------------------------------------------------------
class TapTestRandom extends STapBaseTest;

    `ovm_component_utils(TapTestRandom)

    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    TapSequenceRandom SP;

    function new (string name = "TapTestRandom", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestRandom","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceRandom ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        #200000000;
        `ovm_info("TapTestRandom","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestRandom

//--------------------------------------------------------------------------------
//  Test to Check Remote TDR
//--------------------------------------------------------------------------------
class TapTestRemoteTDR extends STapBaseTest;

    `ovm_component_utils(TapTestRemoteTDR)

    SecurityLocked       SL;
    PowergoodReset       PG;
    SecurityUnlocked     SUL;
    TapSequenceRemoteTDR SP;

    function new (string name = "TapTestRemoteTDR", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    0);
        set_config_int("Env", "quit_count", 64);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestRemoteTDR","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceRemoteTDR ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        #200000000;
        `ovm_info("TapTestRemoteTDR","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestRemoteTDR

class TapTestSuppressRemoteTDR extends STapBaseTest;

    `ovm_component_utils(TapTestSuppressRemoteTDR)

    SecurityLocked               SL;
    PowergoodReset               PG;
    SecurityUnlocked             SUL;
    TapSuppressSequenceRemoteTDR SP;

    function new (string name = "TapTestSuppressRemoteTDR", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    0);
        set_config_int("Env", "quit_count", 64);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestSuppressRemoteTDR","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSuppressSequenceRemoteTDR::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        #200000000;
        `ovm_info("TapTestSuppressRemoteTDR","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass :TapTestSuppressRemoteTDR 

//--------------------------------------------------------------------------------
//  Test to Check Trial tests
//--------------------------------------------------------------------------------
class TapTestTry extends STapBaseTest;

    `ovm_component_utils(TapTestTry)

    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    TapSequenceTry    SP;

    function new (string name = "TapTestTry", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    1);
        set_config_int("Env", "quit_count", 32);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestTry","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceTry ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        #200000000;
        `ovm_info("TapTestTry","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestTry

//--------------------------------------------------------------------------------
//  Test to Access Boundary Scan Registers Without Register
//--------------------------------------------------------------------------------
class TapTestBoundaryRegisterAccessWoReset extends STapBaseTest;

    `ovm_component_utils(TapTestBoundaryRegisterAccessWoReset)

    SecurityLocked                           SL;
    PowergoodReset                           PG;
    SecurityUnlocked                         SUL;
    TapSequenceBoundaryRegisterAccessWoReset SP;

    function new (string name = "TapTestBoundaryRegisterAccessWoReset", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    0);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestBoundaryRegisterAccessWoReset","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP  = TapSequenceBoundaryRegisterAccessWoReset ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        #200000000;
        `ovm_info("TapTestBoundaryRegisterAccessWoReset","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestBoundaryRegisterAccessWoReset

//------------------------------------
//  Test to Access Reserved Opcodes
//------------------------------------
class TapTestReservedOpcodeAccess extends STapBaseTest;

    `ovm_component_utils(TapTestReservedOpcodeAccess)

    SecurityLocked                  SL;
    PowergoodReset                  PG;
    SecurityUnlocked                SUL;
    TapSequenceReservedOpcodeAccess ROA;

    function new (string name = "TapTestReservedOpcodeAccess", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestReservedOpcodeAccess","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        ROA = TapSequenceReservedOpcodeAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        ROA.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestReservedOpcodeAccess","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestReservedOpcodeAccess

//------------------------------------
// Orange and Green opcode register access test
//------------------------------------
class TapTestOrangeGreenRegisterAccess extends STapBaseTest;

    `ovm_component_utils(TapTestOrangeGreenRegisterAccess)

    TapSequenceMultipleTapRegisterAccess SP;
    PowergoodReset                       PG;
    SecurityLocked                       SL;
    OEMUnlocked                          OEMUL;

    function new (string name = "TapTestOrangeGreenRegisterAccess", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestOrangeGreenRegisterAccess","Test Starts!!!",OVM_LOW);
        SL    = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG    = PowergoodReset  ::type_id::create("Powergood reset",this);
        OEMUL = OEMUnlocked  ::type_id::create("Security Unlocked Mode",this);
        SP    = TapSequenceMultipleTapRegisterAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        OEMUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestOrangeGreenRegisterAccess","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestOrangeGreenRegisterAccess

//------------------------------------
// Green opcode register access test
//------------------------------------
class TapTestGreenRegisterAccess extends STapBaseTest;

    `ovm_component_utils(TapTestGreenRegisterAccess)

    TapSequenceMultipleTapRegisterAccess SP;
    PowergoodReset                       PG;
    SecurityLocked                       SL;

    function new (string name = "TapTestGreenRegisterAccess", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestGreenRegisterAccess","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SP  = TapSequenceMultipleTapRegisterAccess ::type_id::create("ALL Primary Mode",this);

        //PG.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        //#200000000;
        `ovm_info("TapTestGreenRegisterAccess","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestGreenRegisterAccess

//------------------------------------
// Green opcode register access test
//------------------------------------
class TapTestProgRstITDR extends STapBaseTest;

    `ovm_component_utils(TapTestProgRstITDR)

    TapSequenceProgRstITDR SP;
    PowergoodReset         PG;
    SecurityLocked         SL;

    function new (string name = "TapTestProgRstITDR", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestProgRstITDR","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SP  = TapSequenceProgRstITDR ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestProgRstITDR","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestProgRstITDR

//------------------------------------
// EarlyBootExit LOW (EBEL), to reproduce HSD ...
// https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=4795640
// Title:  dfx_earlyboot_exit not asserted, GREEN IR's not accessible
//------------------------------------
class TapTestProgRstITDR_EBEL extends STapBaseTest;

    `ovm_component_utils(TapTestProgRstITDR_EBEL)

    TapSequenceProgRstITDR SP;
    PowergoodReset         PG;
    SecurityLocked         SL;
    EarlyBootExitLOW       EBEL; 

    function new (string name = "TapTestProgRstITDR_EBEL", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestProgRstITDR_EBEL","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SP  = TapSequenceProgRstITDR ::type_id::create("ALL Primary Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestProgRstITDR_EBEL","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestProgRstITDR_EBEL

//------------------------------------
// Green opcode register access test
//------------------------------------
class TapTestProgRstRTDR extends STapBaseTest;

    `ovm_component_utils(TapTestProgRstRTDR)

    TapSequenceProgRstRTDR SP;
    PowergoodReset         PG;
    SecurityLocked         SL;

    function new (string name = "TapTestProgRstRTDR", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
        set_config_int("Env", "has_scoreboard",    0);
    endfunction : build

    virtual task run();
        `ovm_info("TapTestProgRstRTDR","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SP  = TapSequenceProgRstRTDR ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestProgRstRTDR","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestProgRstRTDR


//------------------------------------
// Green opcode register access test
//------------------------------------
class TapTest_CTT extends STapBaseTest;

    `ovm_component_utils(TapTest_CTT)

    PowergoodReset         PG;
    SecurityLocked         SL;
    TapSequenceIPLevelCTT  SP; 

    function new (string name = "TapTest_CTT", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env", "quit_count", 32);
        set_config_int("Env", "has_scoreboard",    0);
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_CTT","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked  ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SP  = TapSequenceIPLevelCTT ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_CTT","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_CTT

/*------------------------------------------------------
"This test checks the BYPASS and SLVIDCODE Transactions"
--------------------------------------------------------*/
class TapTestBypassAndSlvidCode extends STapBaseTest;

    `ovm_component_utils(TapTestBypassAndSlvidCode)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    TapSequenceBypass SP;
    OnlySLVIDCODE     SLVID;

    function new (string name = "TapTestBypassAndSlvidCode", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTestBypassAndSlvidCode","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked::type_id::create("Security Locked Mode");
        PG  = PowergoodReset::type_id::create("Powergood reset");
        SUL = SecurityUnlocked::type_id::create("Security Unlocked Mode");
        SP  = TapSequenceBypass::type_id::create("ALL Primary Mode");
        SLVID =OnlySLVIDCODE::type_id::create("SLVIDCODE");

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        SP.start(Env.stap_JtagMasterAgent.Sequencer);
        SLVID.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTestBypass","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTestBypassAndSlvidCode

class TapTest_Swcomp_Slvidcode extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_Slvidcode)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    swcomp_slvidcode_seq        OB;

    function new (string name = "TapTest_Swcomp_Slvidcode", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = swcomp_slvidcode_seq ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_Slvidcode

class TapTest_Swcomp_Force extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_Force)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    swcomp_force_seq  OB;

    function new (string name = "TapTest_Swcomp_Force", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Force","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = swcomp_force_seq ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Force","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_Force

class TapTest_Swcomp_Bypass extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_Bypass)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    swcomp_bypass_seq  OB;

    function new (string name = "TapTest_Swcomp_Bypass", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Bypass","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = swcomp_bypass_seq ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Bypass","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_Bypass


class TapTest_Swcomp_Signed extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_Signed)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    swcomp_signed_seq  OB;

    function new (string name = "TapTest_Swcomp_Signed", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Signed","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = swcomp_signed_seq ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Signed","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_Signed

class TapTest_Swcomp_Mask extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_Mask)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    swcomp_mask_seq  OB;

    function new (string name = "TapTest_Swcomp_Mask", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Mask","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = swcomp_mask_seq ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Force","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_Mask

class TapTest_Swcomp_upf extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_upf)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    swcomp_upf_seq    OB;

    function new (string name = "TapTest_Swcomp_upf", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        //OB  = swcomp_isol_seq ::type_id::create("ALL Primary Mode",this);
        OB  = swcomp_upf_seq::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_upf

class TapTest_Swcomp_tdosel extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_tdosel)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    //swcomp_isol_seq        OB;
    swcomp_tdosel_seq OB;

    function new (string name = "TapTest_Swcomp_tdosel", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = swcomp_tdosel_seq::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_tdosel

class TapTest_Swcomp_mirror extends STapBaseTest;

    `ovm_component_utils(TapTest_Swcomp_mirror)
    SecurityLocked    SL;
    PowergoodReset    PG;
    SecurityUnlocked  SUL;
    EarlyBootExitLOW  EBEL; 
    swcomp_mirror_seq        OB;

    function new (string name = "TapTest_Swcomp_mirror", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
    endfunction : build

    virtual task run();
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Starts!!!",OVM_LOW);
        SL  = SecurityLocked   ::type_id::create("Security Locked Mode",this);
        PG  = PowergoodReset  ::type_id::create("Powergood reset",this);
        SUL = SecurityUnlocked  ::type_id::create("Security Unlocked Mode",this);
        EBEL= EarlyBootExitLOW  ::type_id::create("Early Boot Exit",this);
        OB  = swcomp_mirror_seq ::type_id::create("ALL Primary Mode",this);

        SL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        PG.start(Env.stap_JtagMasterAgent.Sequencer);
        SUL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        EBEL.start(Env.stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
        OB.start(Env.stap_JtagMasterAgent.Sequencer);
        `ovm_info("TapTest_Swcomp_Slvidcode","Test Completed!!!",OVM_LOW);
        global_stop_request();
    endtask : run
endclass : TapTest_Swcomp_mirror

