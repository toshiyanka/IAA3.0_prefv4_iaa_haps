//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapTests.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : Tests 
//    DESCRIPTION : This component has all the test present in the ENV.
//                  Each Tests call for the corresponding sequneces. 
//----------------------------------------------------------------------

class TapTestTry5levelhier extends TapBaseTest;

    `uvm_component_utils(TapTestTry5levelhier)
    Tap5levelHierSequenceTry #(1) ST;

   function new (string name = "TapTestTry5levelhier", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TapTestTry5levelhier","Test Starts!!!");
        ST = new("ALL Primary Mode");
        ST.start(Env.PriMasterAgent.Sequencer);
        uvm_report_info("TapTestTry5levelhier","TapTestTry5levelhier Completed!!!");
        global_stop_request();
   endtask
endclass : TapTestTry5levelhier


class TapTestTry5levelhierSecondaryNew extends TapBaseTest;

   `uvm_component_utils(TapTestTry5levelhierSecondaryNew)

   Tap5levelHierSequenceTrySecConfigNew  #(1, STAP5)  ST_CONFIG;
   Tap5levelHierSequenceTrySecondaryNew  #(1, STAP5)  ST_SECONDARY;
   Tap5levelHierSequenceTrySecondaryNew1 #(1, STAP25) ST_PRIMARY;
   Tap5levelHierSequenceTrySecondaryNew1 #(1, STAP21) ST_PRIMARY1;
   Tap5levelHierSequenceTrySecondaryNew1 #(1, STAP6)  ST_SECONDARY1;
   Tap5levelHierSequenceTrySecondaryNew1 #(1, STAP17) ST_SECONDARY2;
   Tap5levelHierSequenceTrySecDisable    #(1, STAP24) ST_PRIMARY2;
   Tap5levelHierSequenceTrySecondaryNew1 #(1, STAP24) ST_PRIMARY3;
   Tap5levelHierSequenceTrySecondaryNew1 #(1, STAP3)  ST_SECONDARY3;
   Tap5levelHierSequenceTrySecDisable    #(1, STAP4)  ST_SECONDARY4;
   Tap5levelHierSequenceTrySecondaryNew1 #(1, STAP4)  ST_SECONDARY5;

   TapSequenceReset RESETPRIMARY, RESETSECONDARY;
   TapSequenceGoToRuti SECONDARY_RUTI;

   function new (string name = "TapTestTry5levelhierSecondaryNew", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestTry5levelhierSecondaryNew","Test Starts!!!");


      RESETPRIMARY = new();
      RESETSECONDARY = new();
      ST_CONFIG = new("ALL Primary Mode");
      ST_SECONDARY = new("ALL secondary Mode");
      ST_SECONDARY1 = new("ALL secondary Mode");
      ST_SECONDARY2 = new("ALL secondary Mode");
      ST_SECONDARY3 = new("ALL secondary Mode");
      ST_SECONDARY4 = new("ALL secondary Mode");
      ST_SECONDARY5 = new("ALL secondary Mode");
      ST_PRIMARY3 = new("ALL secondary Mode");
      SECONDARY_RUTI = new();
      ST_PRIMARY = new();
      ST_PRIMARY1 = new();
      ST_PRIMARY2 = new();

      RESETPRIMARY.start(Env.PriMasterAgent.Sequencer);
      RESETSECONDARY.start(Env.SecMasterAgent.Sequencer);
      SECONDARY_RUTI.start(Env.SecMasterAgent.Sequencer);

      ST_CONFIG.start(Env.PriMasterAgent.Sequencer);
      ST_SECONDARY.start(Env.SecMasterAgent.Sequencer);
      ST_PRIMARY.start(Env.PriMasterAgent.Sequencer);
      ST_PRIMARY1.start(Env.PriMasterAgent.Sequencer);
      ST_SECONDARY1.start(Env.SecMasterAgent.Sequencer);
      ST_SECONDARY2.start(Env.SecMasterAgent.Sequencer);
      ST_PRIMARY2.start(Env.PriMasterAgent.Sequencer);
//      ST_PRIMARY.start(Env.PriMasterAgent.Sequencer);
      ST_PRIMARY3.start(Env.PriMasterAgent.Sequencer);
      ST_PRIMARY.start(Env.PriMasterAgent.Sequencer);
      ST_SECONDARY3.start(Env.SecMasterAgent.Sequencer);
      ST_SECONDARY4.start(Env.SecMasterAgent.Sequencer);
//      ST_SECONDARY1.start(Env.SecMasterAgent.Sequencer);
      ST_SECONDARY5.start(Env.SecMasterAgent.Sequencer);
      ST_SECONDARY5.start(Env.SecMasterAgent.Sequencer);
      ST_SECONDARY1.start(Env.SecMasterAgent.Sequencer);
      ST_SECONDARY1.start(Env.SecMasterAgent.Sequencer);
      uvm_report_info("TapTestTry5levelhierSecondaryNew","TapTestTry5levelhierSecondaryNew Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestTry5levelhierSecondaryNew





class TapTestTry5levelhier_ReadIdCodes extends TapBaseTest;

   `uvm_component_utils(TapTestTry5levelhier_ReadIdCodes)

   function new (string name = "TapTestTry5levelhier_ReadIdCodes", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      Tap5levelHierSequenceTry_ReadIdCodes #(1, 0) ST;
      uvm_report_info("TapTestTry5levelhier_ReadIdCodes","Test Starts!!!");
      ST = new("ALL Primary Mode");
      ST.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTestTry5levelhier_ReadIdCodes","TapTestTry5levelhier_ReadIdCodes Completed!!!");
      global_stop_request();
   endtask
endclass : TapTestTry5levelhier_ReadIdCodes


class TapTestTry5levelhierWithHistory extends TapBaseTest;

    `uvm_component_utils(TapTestTry5levelhierWithHistory)

   function new (string name = "TapTestTry5levelhierWithHistory", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      Tap5levelHierSequenceTryWithHistory #(1, 0) ST;
      uvm_report_info("TapTestTry5levelhierWithHistory","Test Starts!!!");
      ST = new("ALL Primary Mode");
      ST.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTestTry5levelhierWithHistory",
                      "TapTestTry5levelhierWithHistory Completed!!!");
      global_stop_request();
   endtask
endclass : TapTestTry5levelhierWithHistory


class TapTestTry5levelhierDisable extends TapBaseTest;

    `uvm_component_utils(TapTestTry5levelhierDisable)

   function new (string name = "TapTestTry5levelhierDisable", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      Tap5levelHierSequenceDisable #(1, 0) ST;
      uvm_report_info("TapTestTry5levelhierDisable","Test Starts!!!");
      ST = new("ALL Primary Mode");
      ST.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTestTry5levelhierDisable",
                      "TapTestTry5levelhierDisable Completed!!!");
      global_stop_request();
   endtask
endclass : TapTestTry5levelhierDisable



class TapTestTry5levelhier_remove_detailedNew extends TapBaseTest;

    `uvm_component_utils(TapTestTry5levelhier_remove_detailedNew)

   function new (string name = "TapTestTry5levelhier_remove_detailedNew", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      Tap5levelHierSequenceTry_removeNew #(1, 0) ST;
      uvm_report_info("TapTestTry5levelhier_remove_detailedNew","Test Starts!!!");
      ST = new("ALL Primary Mode");
      ST.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTestTry5levelhier_remove_detailedNew",
                      "TapTestTry5levelhier_remove_detailedNew Completed!!!");
      global_stop_request();
   endtask
endclass : TapTestTry5levelhier_remove_detailedNew


class TapTestTry5levelhier_removeWithSecondaryNew extends TapBaseTest;

    `uvm_component_utils(TapTestTry5levelhier_removeWithSecondaryNew)
   Tap5levelHierSequenceTrySecConfigRemoveNew  #(1, STAP6)  ST_CONFIG;
   Tap5levelHierSequenceTry_removeWithSecondaryNew #(1, 0) ST;
   TapSequenceReset RESETPRIMARY, RESETSECONDARY;
   TapSequenceGoToRuti SECONDARY_RUTI;

   function new (string name = "TapTestTry5levelhier_removeWithSecondaryNew", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      RESETPRIMARY = new();
      RESETSECONDARY = new();
      SECONDARY_RUTI = new();
      ST_CONFIG = new("ALL Primary Mode");
      ST = new("ALL Primary Mode");

      uvm_report_info("TapTestTry5levelhier_removeWithSecondaryNew","Test Starts!!!");

      RESETPRIMARY.start(Env.PriMasterAgent.Sequencer);
      RESETSECONDARY.start(Env.SecMasterAgent.Sequencer);
      SECONDARY_RUTI.start(Env.SecMasterAgent.Sequencer);
      ST_CONFIG.start(Env.PriMasterAgent.Sequencer);
      ST.start(Env.SecMasterAgent.Sequencer);
      uvm_report_info("TapTestTry5levelhier_removeWithSecondaryNew",
                      "TapTestTry5levelhier_removeWithSecondaryNew Completed!!!");
      global_stop_request();
   endtask
endclass : TapTestTry5levelhier_removeWithSecondaryNew



class TapTestTry5levelhierReturnTdo extends TapBaseTest;

    `uvm_component_utils(TapTestTry5levelhierReturnTdo)

   function new (string name = "TapTestTry5levelhierReturnTdo", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      Tap5levelHierSequenceTryReturnTdo #(1, STAP29) ST;
      uvm_report_info("TapTestTry5levelhierReturnTdo","Test Starts!!!");
      ST = new("ALL Primary Mode");
      ST.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTestTry5levelhierReturnTdo",
                      "TapTestTry5levelhierReturnTdo Completed!!!");
      global_stop_request();
   endtask
endclass : TapTestTry5levelhierReturnTdo


class TapTestTry5levelhierSecondaryComplex extends TapBaseTest;

   `uvm_component_utils(TapTestTry5levelhierSecondaryComplex)

   Tap5levelHierSequenceTrySecConfigComplex #(1, STAP0)  ST_CONFIG;
   Tap5levelHierSequenceTryPriDataComplex   #(1, STAP0)  ST_PRIMARY;
   Tap5levelHierSequenceTrySecDataComplex   #(1, STAP0)  ST_SECONDARY;

   TapSequenceReset    RESETPRIMARY, RESETSECONDARY;
   TapSequenceGoToRuti SECONDARY_RUTI;

   function new (string name = "TapTestTry5levelhierSecondaryComplex", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestTry5levelhierSecondaryComplex","Test Starts!!!");


      RESETPRIMARY = new();
      RESETSECONDARY = new();
      SECONDARY_RUTI = new();
      ST_CONFIG = new("ALL Primary Mode");
      ST_PRIMARY = new("ALL Primary Mode");
      ST_SECONDARY = new("ALL secondary Mode");

      RESETPRIMARY.start(Env.PriMasterAgent.Sequencer);
      RESETSECONDARY.start(Env.SecMasterAgent.Sequencer);
      SECONDARY_RUTI.start(Env.SecMasterAgent.Sequencer);

      ST_CONFIG.start(Env.PriMasterAgent.Sequencer);

//      fork 
         ST_SECONDARY.start(Env.SecMasterAgent.Sequencer);
         ST_PRIMARY.start(Env.PriMasterAgent.Sequencer);
//      join

      uvm_report_info("TapTestTry5levelhierSecondaryComplex","TapTestTry5levelhierSecondaryComplex Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestTry5levelhierSecondaryComplex


class TapTestTry5levelhierOptimize extends TapBaseTest;
   `uvm_component_utils(TapTestTry5levelhierOptimize)
   Tap5levelHierSequenceOptimize #(1) ST;

   function new (string name = "TapTestTry5levelhierOptimize", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TapTestTry5levelhierOptimize","Test Starts!!!");
        ST = new("ALL Primary Mode");
        ST.start(Env.PriMasterAgent.Sequencer);
        uvm_report_info("TapTestTry5levelhierOptimize","TapTestTry5levelhierOptimize Completed!!!");
        global_stop_request();
   endtask

endclass : TapTestTry5levelhierOptimize


class TapTestTry5levelhierMultiTapAccess extends TapBaseTest;
   `uvm_component_utils(TapTestTry5levelhierMultiTapAccess)
   Tap5levelHierSeqMultiTapAccess #(1) ST;

   function new (string name = "TapTestTry5levelhierMultiTapAccess", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TapTestTry5levelhierMultiTapAccess","Test Starts!!!");
        ST = new("ALL Primary Mode");
        ST.start(Env.PriMasterAgent.Sequencer);
        uvm_report_info("TapTestTry5levelhierMultiTapAccess","TapTestTry5levelhierMultiTapAccess Completed!!!");
        global_stop_request();
   endtask

endclass : TapTestTry5levelhierMultiTapAccess


class slu_TapTestTry5levelhierOptimize extends TapBaseTest;
   `uvm_component_utils(slu_TapTestTry5levelhierOptimize)
   slu_Tap5levelHierSequenceOptimize  ST1;

   function new (string name = "slu_TapTestTry5levelhierOptimize", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual function void connect_phase(uvm_phase phase); 
       super.connect_phase(phase);
       Env.set_test_phase_type("Env", "USER_DATA_PHASE", "slu_Tap5levelHierSequenceOptimize");
       Env.set_test_phase_type("Env", "FLUSH_PHASE", "Tap_flush_seq");
   endfunction : connect_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("slu_TapTestTry5levelhierOptimize","slu_TapTestTry5levelhierOptimize Completed!!!");
   endtask
endclass : slu_TapTestTry5levelhierOptimize


class slu_TapTestTry5levelhierSecondaryNew extends TapBaseTest;
   `uvm_component_utils(slu_TapTestTry5levelhierSecondaryNew)
   slu_Tap5levelHierSequenceTrySecondaryNew ST1;

   function new (string name = "slu_TapTestTry5levelhierSecondaryNew", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual function void connect_phase(uvm_phase phase); 
       super.connect_phase(phase);
       Env.set_test_phase_type("Env", "USER_DATA_PHASE", "slu_Tap5levelHierSequenceTrySecondaryNew");
       Env.set_test_phase_type("Env", "FLUSH_PHASE", "Tap_flush_seq");
   endfunction : connect_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("slu_TapTestTry5levelhierSecondaryNew","slu_TapTestTry5levelhierSecondaryNew Completed!!!");
   endtask
endclass : slu_TapTestTry5levelhierSecondaryNew

//^^^^^^^^^^^^^^^^^^_______________^^^^^^^^^^^^^^^^^
//   WTAP                                ROCKS
//vvvvvvvvvvvvvvvvvv---------------vvvvvvvvvvvvvvvvv
class WTapTest extends TapBaseTest;

   `uvm_component_utils(WTapTest)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   Wtap0EnableSeq    CNFG0;
   Wtap0TDRAccessSeq DATA0; 
   Wtap1EnableSeq    CNFG1;
   Wtap1TDRAccessSeq DATA1; 

   function new (string name = "WTapTest", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("WTapTest","Test Starts!!!");

        BTDS = new("ALL Primary Mode");
        CNFG0 = new("ALL Primary Mode");
        DATA0 = new("ALL Primary Mode");
        CNFG1 = new("ALL Primary Mode");
        DATA1 = new("ALL Primary Mode");

        BTDS.start(Env.PriMasterAgent.Sequencer);
        CNFG0.start(Env.PriMasterAgent.Sequencer);
        DATA0.start(Env.PriMasterAgent.Sequencer);
        CNFG1.start(Env.PriMasterAgent.Sequencer);
        DATA1.start(Env.PriMasterAgent.Sequencer);

        uvm_report_info("WTapTest","WTapTest Completed!!!");
        global_stop_request();
   endtask

endclass : WTapTest

//^^^^^^^^^^^^^^^^^^_______________^^^^^^^^^^^^^^^^^
//   3rd TAP Port                     Validation
//vvvvvvvvvvvvvvvvvv---------------vvvvvvvvvvvvvvvvv
class TerTapTest_Scenario1 extends TapBaseTest;

   `uvm_component_utils(TerTapTest_Scenario1)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP,SRS,SRT1;
   TerCfgSeq     #(1) CNFG0;
   Ter1AccessSeq #(1) TER1;
   PriAccessSeq  #(1) PRI; 
   TapSequenceGoToRuti GOTO_RUTI;

   function new (string name = "TerTapTest_Scenario1", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TerTapTest_Scenario1","Test Starts!!!");

        BTDS  = new("ALL Primary Mode");
        CNFG0 = new("ALL Primary Mode");
        TER1  = new("Ter2 Mode");

        SRP   = new("TER1 Mode");
        SRS   = new("TER1 Mode");
        SRT1  = new("TER1 Mode");

        PRI  = new("Pri Mode");

        GOTO_RUTI = new();

        BTDS.start(Env.PriMasterAgent.Sequencer);

        // Reset all the instances of the BFM UVM Agent
        SRP.start(Env.PriMasterAgent.Sequencer);
        SRS.start(Env.SecMasterAgent.Sequencer);
        SRT1.start(Env.Ter1MasterAgent.Sequencer);

        CNFG0.start(Env.PriMasterAgent.Sequencer);

        GOTO_RUTI.start(Env.Ter1MasterAgent.Sequencer);
        TER1.start(Env.Ter1MasterAgent.Sequencer);

        PRI.start(Env.PriMasterAgent.Sequencer);

        uvm_report_info("TerTapTest_Scenario1","TerTapTest_Scenario1 Completed!!!");
        global_stop_request();
   endtask

endclass : TerTapTest_Scenario1

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
class TerTapTest_Scenario2 extends TapBaseTest;

   `uvm_component_utils(TerTapTest_Scenario2)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP,SRS,SRT1;
   TerCfgSeq     #(2) CNFG0;
   Ter0AccessSeq #(2) TER0;
   PriAccessSeq  #(2) PRI; 
   TapSequenceGoToRuti GOTO_RUTI;

   function new (string name = "TerTapTest_Scenario2", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TerTapTest_Scenario2","Test Starts!!!");

        BTDS  = new("ALL Primary Mode");
        CNFG0 = new("ALL Primary Mode");
        TER0  = new("Ter1 Mode");

        SRP   = new("TER0 Mode");
        SRS   = new("TER0 Mode");
        SRT1  = new("TER0 Mode");

        PRI  = new("Pri Mode");

        GOTO_RUTI = new();

        BTDS.start(Env.PriMasterAgent.Sequencer);

        // Reset all the instances of the BFM UVM Agent
        SRP.start(Env.PriMasterAgent.Sequencer);
        SRS.start(Env.SecMasterAgent.Sequencer);
        SRT1.start(Env.Ter0MasterAgent.Sequencer);

        CNFG0.start(Env.PriMasterAgent.Sequencer);

        GOTO_RUTI.start(Env.Ter0MasterAgent.Sequencer);
        TER0.start(Env.Ter0MasterAgent.Sequencer);

        PRI.start(Env.PriMasterAgent.Sequencer);

        uvm_report_info("TerTapTest_Scenario2","TerTapTest_Scenario2 Completed!!!");
        global_stop_request();
   endtask

endclass : TerTapTest_Scenario2  

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
class TerTapTest_Scenario3 extends TapBaseTest;

   `uvm_component_utils(TerTapTest_Scenario3)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP,SRS,SRT1,SRT2;
   TerCfgSeq     #(3) CNFG0;
   TerCfgSeq     #(33) CNFG1;
   Ter1AccessSeq #(3) TER1;
   Ter0AccessSeq #(3) TER0;
   PriAccessSeq  #(3) PRI; 
   TapSequenceGoToRuti GOTO_RUTI;

   function new (string name = "TerTapTest_Scenario3", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TerTapTest_Scenario3","Test Starts!!!");

        BTDS  = new("ALL Primary Mode");
        CNFG0 = new("ALL Primary Mode");
        CNFG1 = new("ALL Primary Mode");
        TER0  = new("Ter1 Mode");
        TER1  = new("Ter2 Mode");

        SRP   = new("Pri  Mode");
        SRS   = new("Sec  Mode");
        SRT1  = new("TER0 Mode");
        SRT2  = new("TER1 Mode");

        PRI  = new("Pri Mode");

        GOTO_RUTI = new();

        // Reset all the instances of the BFM UVM Agent
        BTDS.start(Env.PriMasterAgent.Sequencer);

        SRP.start(Env.PriMasterAgent.Sequencer);
        SRS.start(Env.SecMasterAgent.Sequencer);
        SRT1.start(Env.Ter0MasterAgent.Sequencer);
        SRT2.start(Env.Ter1MasterAgent.Sequencer);


        CNFG0.start(Env.PriMasterAgent.Sequencer);
        CNFG1.start(Env.PriMasterAgent.Sequencer);

        GOTO_RUTI.start(Env.Ter1MasterAgent.Sequencer);
        TER1.start(Env.Ter1MasterAgent.Sequencer);
        
        GOTO_RUTI.start(Env.Ter0MasterAgent.Sequencer);
        TER0.start(Env.Ter0MasterAgent.Sequencer);

        PRI.start(Env.PriMasterAgent.Sequencer);

        uvm_report_info("TerTapTest_Scenario3","TerTapTest_Scenario3 Completed!!!");
        global_stop_request();
   endtask

endclass : TerTapTest_Scenario3

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
class TerTapTest_Scenario4 extends TapBaseTest;

   `uvm_component_utils(TerTapTest_Scenario4)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP,SRS,SRT1,SRT2;
   TerCfgSeq     #(4) CNFG0;
   TerCfgSeq     #(44) CNFG1;
   Ter1AccessSeq #(4) TER1;
   Ter0AccessSeq #(3) TER0;
   PriAccessSeq  #(4) PRI; 
   PriAccessSeq  #(44) PRI0; 
   SecAccessSeq  #(4) SEC; 
   TapSequenceGoToRuti GOTO_RUTI;

   function new (string name = "TerTapTest_Scenario4", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TerTapTest_Scenario4","Test Starts!!!");

        BTDS  = new("ALL Primary Mode");
        CNFG0 = new("ALL Primary Mode");
        CNFG1 = new("ALL Primary Mode");
        TER0  = new("Ter1 Mode");
        TER1  = new("Ter2 Mode");

        SRP   = new("Pri  Mode");
        SRS   = new("Sec  Mode");
        SRT1  = new("TER0 Mode");
        SRT2  = new("TER1 Mode");

        PRI  = new("Pri Mode");
        PRI0  = new("Pri Mode");
        SEC  = new("Sec Mode");

        GOTO_RUTI = new();

        BTDS.start(Env.PriMasterAgent.Sequencer);

        // Reset all the instances of the BFM UVM Agent
        SRP.start(Env.PriMasterAgent.Sequencer);
        SRS.start(Env.SecMasterAgent.Sequencer);
        SRT1.start(Env.Ter0MasterAgent.Sequencer);
        SRT2.start(Env.Ter1MasterAgent.Sequencer);


        PRI.start(Env.PriMasterAgent.Sequencer);

        CNFG1.start(Env.PriMasterAgent.Sequencer);
        GOTO_RUTI.start(Env.SecMasterAgent.Sequencer);
        SEC.start(Env.SecMasterAgent.Sequencer);

        //CNFG0.start(Env.PriMasterAgent.Sequencer);
        CNFG0.start(Env.SecMasterAgent.Sequencer);
        GOTO_RUTI.start(Env.Ter1MasterAgent.Sequencer);
        TER1.start(Env.Ter1MasterAgent.Sequencer);

        //PRI.start(Env.PriMasterAgent.Sequencer);
        //TER1.start(Env.Ter1MasterAgent.Sequencer);

        PRI0.start(Env.PriMasterAgent.Sequencer);

        uvm_report_info("TerTapTest_Scenario4","TerTapTest_Scenario4 Completed!!!");
        global_stop_request();
   endtask

endclass : TerTapTest_Scenario4

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
class TerTapTest_Scenario5 extends TapBaseTest;

   `uvm_component_utils(TerTapTest_Scenario5)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP,SRS,SRT0,SRT1;
   TerCfgSeq     #(5) CNFG0;
   Ter0AccessSeq #(5) TER0;
   PriAccessSeq  #(5) PRI; 
   SecAccessSeq  #(5) SEC; 
   TapSequenceGoToRuti GOTO_RUTI;

   function new (string name = "TerTapTest_Scenario5", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TerTapTest_Scenario5","Test Starts!!!");

        BTDS  = new("ALL Primary Mode");

        CNFG0 = new("ALL Primary Mode");
        TER0  = new("Ter0 Mode");

        SRP   = new("Pri  Mode");
        SRS   = new("Sec  Mode");
        SRT0  = new("TER0 Mode");
        SRT1  = new("TER1 Mode");

        PRI  = new("Pri Mode");
        SEC  = new("Sec Mode");

        GOTO_RUTI = new();

        BTDS.start(Env.PriMasterAgent.Sequencer);

        // Reset all the instances of the BFM UVM Agent
        SRP.start(Env.PriMasterAgent.Sequencer);
        SRS.start(Env.SecMasterAgent.Sequencer);
        SRT0.start(Env.Ter0MasterAgent.Sequencer);
        SRT1.start(Env.Ter1MasterAgent.Sequencer);


        CNFG0.start(Env.PriMasterAgent.Sequencer);

        GOTO_RUTI.start(Env.Ter0MasterAgent.Sequencer);
        TER0.start(Env.Ter0MasterAgent.Sequencer);

        PRI.start(Env.PriMasterAgent.Sequencer);

        GOTO_RUTI.start(Env.SecMasterAgent.Sequencer);
        SEC.start(Env.SecMasterAgent.Sequencer);

        uvm_report_info("TerTapTest_Scenario5","TerTapTest_Scenario5 Completed!!!");
        global_stop_request();
   endtask

endclass : TerTapTest_Scenario5

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
class TerTapTest_Scenario6 extends TapBaseTest;

   `uvm_component_utils(TerTapTest_Scenario6)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP,SRS,SRT0,SRT1;
   TerCfgSeq     #(6) CNFG0;
   TerCfgSeq     #(6) CNFG1;
   Ter1AccessSeq #(6) TER1;
   Ter0AccessSeq #(6) TER0;
   PriAccessSeq  #(6) PRI; 
   SecAccessSeq  #(6) SEC; 
   TapSequenceGoToRuti GOTO_RUTI;

   function new (string name = "TerTapTest_Scenario6", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TerTapTest_Scenario6","Test Starts!!!");

        BTDS  = new("ALL Primary Mode");
        CNFG0 = new("ALL Primary Mode");
        CNFG1 = new("ALL Primary Mode");
        TER0  = new("Ter1 Mode");
        TER1  = new("Ter2 Mode");

        SRP   = new("Pri  Mode");
        SRS   = new("Sec  Mode");
        SRT0  = new("TER0 Mode");
        SRT1  = new("TER1 Mode");

        PRI  = new("Pri Mode");
        SEC  = new("Sec Mode");

        GOTO_RUTI = new();

        BTDS.start(Env.PriMasterAgent.Sequencer);

        // Reset all the instances of the BFM UVM Agent
        SRP.start(Env.PriMasterAgent.Sequencer);
        SRS.start(Env.SecMasterAgent.Sequencer);
        SRT0.start(Env.Ter0MasterAgent.Sequencer);
        SRT1.start(Env.Ter1MasterAgent.Sequencer);

        CNFG0.start(Env.PriMasterAgent.Sequencer);
        
        GOTO_RUTI.start(Env.Ter0MasterAgent.Sequencer);
        TER0.start(Env.Ter0MasterAgent.Sequencer);

        PRI.start(Env.PriMasterAgent.Sequencer);

        uvm_report_info("TerTapTest_Scenario6","TerTapTest_Scenario6 Completed!!!");
        global_stop_request();
   endtask

endclass : TerTapTest_Scenario6

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
class TerDisTapTest extends TapBaseTest;

   `uvm_component_utils(TerDisTapTest)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP,SRS,SRT1,SRT2;
   DisTerSeq CNFG0;

   function new (string name = "TerDisTapTest", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TerDisTapTest","Test Starts!!!");

        BTDS  = new("ALL Primary Mode");
        SRP   = new("Pri  Mode");
        CNFG0 = new("ALL Primary Mode");

        BTDS.start(Env.PriMasterAgent.Sequencer);

        // Reset all the instances of the BFM UVM Agent
        SRP.start(Env.PriMasterAgent.Sequencer);

        CNFG0.start(Env.PriMasterAgent.Sequencer);

        uvm_report_info("TerDisTapTest","TerDisTapTest Completed!!!");
        global_stop_request();
   endtask

endclass : TerDisTapTest


class TapAccessReadModifyWriteTest0 extends TapBaseTest;

   int SCENARIO_ARGUMENT = 0;

   `uvm_component_utils(TapAccessReadModifyWriteTest0)

   TapAccessReadModifyWriteTestSequence #(0) SequenceScenario_0;
   TapAccessReadModifyWriteTestSequence #(1) SequenceScenario_1;
   TapSequenceReset SRP;

   function new (string name = "TapAccessReadModifyWriteTest0", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapAccessReadModifyWriteTest0","TapAccessReadModifyWriteTest0 Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 0) begin
         SequenceScenario_0 = new("SequenceScenario_0 ALL Primary Mode");
         uvm_report_info("TapAccessReadModifyWriteTest0","SequenceScenario_0 Started");
         SequenceScenario_0.start(Env.PriMasterAgent.Sequencer);
         uvm_report_info("TapAccessReadModifyWriteTest0","SequenceScenario_0 Ended");
      end

      uvm_report_info("TapAccessReadModifyWriteTest0","TapAccessReadModifyWriteTest0 Completed!!!");
      global_stop_request();
   endtask

endclass : TapAccessReadModifyWriteTest0



class TapAccessReadModifyWriteTest1 extends TapBaseTest;

   int SCENARIO_ARGUMENT = 1;

   `uvm_component_utils(TapAccessReadModifyWriteTest1)

   TapAccessReadModifyWriteTestSequence #(0) SequenceScenario_0;
   TapAccessReadModifyWriteTestSequence #(1) SequenceScenario_1;
   TapSequenceReset SRP;

   function new (string name = "TapAccessReadModifyWriteTest1", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapAccessReadModifyWriteTest1","TapAccessReadModifyWriteTest1 Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 1) begin
         SequenceScenario_1 = new("SequenceScenario_1 ALL Primary Mode");
         uvm_report_info("TapAccessReadModifyWriteTest1","SequenceScenario_1 Started");
         SequenceScenario_1.start(Env.PriMasterAgent.Sequencer);
         uvm_report_info("TapAccessReadModifyWriteTest1","SequenceScenario_1 Ended");
      end

      uvm_report_info("TapAccessReadModifyWriteTest1","TapAccessReadModifyWriteTest1 Completed!!!");
      global_stop_request();
   endtask

endclass : TapAccessReadModifyWriteTest1

//----------------------------------------------------------------------
class TapTestTry extends TapBaseTest;

   int SCENARIO_ARGUMENT = 1;

   `uvm_component_utils(TapTestTry)

   TapSequenceReset SRP;
   TapSequenceTry   ST;

   function new (string name = "TapTestTry", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestTry","TapTestTry Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 1) begin
         SRP = new("SequenceScenario_1 ALL Primary Mode");
         ST  = new("SequenceScenario_1 ALL Primary Mode");

         SRP.start(Env.PriMasterAgent.Sequencer);
         ST.start(Env.PriMasterAgent.Sequencer);
      end

      uvm_report_info("TapTestTry","TapTestTry Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestTry




//----------------------------------------------------------------------
class TapTestFail_1 extends TapBaseTest;

   int SCENARIO_ARGUMENT = 1;

   `uvm_component_utils(TapTestFail_1)

   TapSequenceReset  SRP;
   TapSequenceFail_1 ST;

   function new (string name = "TapTestFail_1", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestFail_1","TapTestFail_1 Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 1) begin
         SRP = new("SequenceScenario_1 ALL Primary Mode");
         ST  = new("SequenceScenario_1 ALL Primary Mode");

         SRP.start(Env.PriMasterAgent.Sequencer);
         ST.start(Env.PriMasterAgent.Sequencer);
      end

      uvm_report_info("TapTestFail_1","TapTestFail_1 Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestFail_1


//----------------------------------------------------------------------
class TapTestFail_2 extends TapBaseTest;

   int SCENARIO_ARGUMENT = 1;

   `uvm_component_utils(TapTestFail_2)

   TapSequenceReset  SRP;
   TapSequenceFail_2 ST;

   function new (string name = "TapTestFail_2", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestFail_2","TapTestFail_2 Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 1) begin
         SRP = new("SequenceScenario_1 ALL Primary Mode");
         ST  = new("SequenceScenario_1 ALL Primary Mode");

         SRP.start(Env.PriMasterAgent.Sequencer);
         ST.start(Env.PriMasterAgent.Sequencer);
      end

      uvm_report_info("TapTestFail_2","TapTestFail_2 Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestFail_2


//----------------------------------------------------------------------
class TapTestFail_3 extends TapBaseTest;

   int SCENARIO_ARGUMENT = 1;

   `uvm_component_utils(TapTestFail_3)

   TapSequenceReset  SRP;
   TapSequenceFail_3 ST;

   function new (string name = "TapTestFail_3", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestFail_3","TapTestFail_3 Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 1) begin
         SRP = new("SequenceScenario_1 ALL Primary Mode");
         ST  = new("SequenceScenario_1 ALL Primary Mode");

         SRP.start(Env.PriMasterAgent.Sequencer);
         ST.start(Env.PriMasterAgent.Sequencer);
      end

      uvm_report_info("TapTestFail_3","TapTestFail_3 Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestFail_3





//----------------------------------------------------------------------
class TapTestShadow extends TapBaseTest;

   `uvm_component_utils(TapTestShadow)

   TapSequenceReset SRP;
   ShadowModeSeq    ST;

   function new (string name = "TapTestShadow", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestShadow","TapTestShadow Started");

      SRP = new("SequenceScenario_1 ALL Primary Mode");
      ST  = new("SequenceScenario_1 ALL Primary Mode");

      SRP.start(Env.PriMasterAgent.Sequencer);
      ST.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestShadow","TapTestShadow Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestShadow


class TestLayer0 extends TapBaseTest;

   `uvm_component_utils(TestLayer0)

   TapSequenceReset SRP;
   SequenceLayer0   ST0;
   SequenceLayer1   ST1;

   function new (string name = "TestLayer0", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TestLayer0","TestLayer0 Started");

//      SRP = new("SequenceScenario_1 ALL Primary Mode");
//      ST0 = new("SequenceScenario_1 ALL Primary Mode");
//      ST1 = new("SequenceScenario_1 ALL Primary Mode");
//
//      SRP.start(Env.PriMasterAgent.Sequencer);
//      ST0.start(Env.PriMasterAgent.Sequencer);
//      ST1.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TestLayer0","TestLayer0 Completed!!!");
      global_stop_request();
   endtask

endclass : TestLayer0

// No need to add to regression
class TestLayer1 extends TestLayer0;

   `uvm_component_utils(TestLayer1)

//   TapSequenceReset SRP;
//   SequenceLayer0   ST0;
//   SequenceLayer1   ST1;

   function new (string name = "TestLayer1", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TestLayer1","TestLayer1 Started");

//      SRP = new("SequenceScenario_1 ALL Primary Mode");
//      ST0 = new("SequenceScenario_1 ALL Primary Mode");
//      ST1 = new("SequenceScenario_1 ALL Primary Mode");
//
//      SRP.start(Env.PriMasterAgent.Sequencer);
//      ST0.start(Env.PriMasterAgent.Sequencer);
//      ST1.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TestLayer1","TestLayer1 Completed!!!");
      global_stop_request();
   endtask

endclass : TestLayer1


class TestLayer2 extends TestLayer1;

   `uvm_component_utils(TestLayer2)

//   TapSequenceReset SRP;
//   SequenceLayer0   ST0;
//   SequenceLayer1   ST1;

   function new (string name = "TestLayer2", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TestLayer2","TestLayer2 Started");

      SRP = new("SequenceScenario_1 ALL Primary Mode");
      ST0 = new("SequenceScenario_1 ALL Primary Mode");
      ST1 = new("SequenceScenario_1 ALL Primary Mode");

      SRP.start(Env.PriMasterAgent.Sequencer);
      ST0.start(Env.PriMasterAgent.Sequencer);
      ST1.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TestLayer2","TestLayer2 Completed!!!");
      global_stop_request();
   endtask

endclass : TestLayer2



class TapTestShadows extends TapBaseTest;

   parameter NUMBER_OF_SCENARIOS = 11;
   parameter SCENARIO_SELECTED = 11;
   parameter RUN_ONE_SCENARIO = 1;

   `uvm_component_utils(TapTestShadows)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   SequenceShadow #(.NUMBER_OF_SCENARIOS(NUMBER_OF_SCENARIOS),
                    .SCENARIO_SELECTED(SCENARIO_SELECTED),
                    .RUN_ONE_SCENARIO(RUN_ONE_SCENARIO)) ST;

   function new (string name = "TapTestShadows", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("TapTestShadows","TapTestShadows Started");

      SRP = new("SequenceScenario_1 ALL Primary Mode");
      ST  = new("SequenceScenario_1 ALL Primary Mode");

      SRP.start(Env.PriMasterAgent.Sequencer);
      ST.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestShadows","TapTestShadows Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestShadows



class TapTestFail_4 extends TapBaseTest;

   int SCENARIO_ARGUMENT = 1;

   `uvm_component_utils(TapTestFail_4)

   TapSequenceReset  SRP;
   TapSequenceFail_4 ST;

   function new (string name = "TapTestFail_4", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestFail_4","TapTestFail_4 Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 1) begin
         SRP = new("SequenceScenario_1 ALL Primary Mode");
         ST  = new("SequenceScenario_1 ALL Primary Mode");

         SRP.start(Env.PriMasterAgent.Sequencer);
         ST.start(Env.PriMasterAgent.Sequencer);
      end

      uvm_report_info("TapTestFail_4","TapTestFail_4 Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestFail_4



class TapTestLessthan8IR extends TapBaseTest;

   int SCENARIO_ARGUMENT = 1;

   `uvm_component_utils(TapTestLessthan8IR)

   TapSequenceReset  SRP;
   TapSequenceLessthan8IR ST;

   function new (string name = "TapTestLessthan8IR", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestLessthan8IR","TapTestLessthan8IR Started");

      if ($value$plusargs("SCENARIO=%d", SCENARIO_ARGUMENT)) begin
         $display ("SCENARIO Value was %d", SCENARIO_ARGUMENT); 
      end  
      else begin
         $display ("SCENARIO Not found"); 
      end  

      if (SCENARIO_ARGUMENT == 1) begin
         SRP = new("SequenceScenario_1 ALL Primary Mode");
         ST  = new("SequenceScenario_1 ALL Primary Mode");

         SRP.start(Env.PriMasterAgent.Sequencer);
         ST.start(Env.PriMasterAgent.Sequencer);
      end

      uvm_report_info("TapTestLessthan8IR","TapTestLessthan8IR Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestLessthan8IR

class TapTestTwoOnSec extends TapBaseTest;

   `uvm_component_utils(TapTestTwoOnSec)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqTwoOnSec TWO;  

   function new (string name = "TapTestTwoOnSec", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      TWO  = new("ALL Primary Mode");
      uvm_report_info("TapTestTwoOnSec","TapTestTwoOnSec Started");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      TWO.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestTwoOnSec","TapTestTwoOnSec Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestTwoOnSec

class TapTestRepeatEnbDis extends TapBaseTest;

   `uvm_component_utils(TapTestRepeatEnbDis)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqRepeatEnbDis ENBDIS;  

   function new (string name = "TapTestRepeatEnbDis", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      ENBDIS  = new("ALL Primary Mode");
      uvm_report_info("TapTestRepeatEnbDis","TapTestRepeatEnbDis Started");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      ENBDIS.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestRepeatEnbDis","TapTestRepeatEnbDis Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestRepeatEnbDis

class TapTestRepeatEnbDis2 extends TapBaseTest;

   `uvm_component_utils(TapTestRepeatEnbDis2)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqRepeatEnbDis2 ENBDIS;  

   function new (string name = "TapTestRepeatEnbDis2", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      ENBDIS  = new("ALL Primary Mode");
      uvm_report_info("TapTestRepeatEnbDis2","TapTestRepeatEnbDis2 Started");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      ENBDIS.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestRepeatEnbDis2","TapTestRepeatEnbDis2 Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestRepeatEnbDis2

class TapTestIntermittentIdcode extends TapBaseTest;

   `uvm_component_utils(TapTestIntermittentIdcode)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqIntermittentIdocde IDC;  

   function new (string name = "TapTestIntermittentIdcode", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      IDC  = new("ALL Primary Mode");
      uvm_report_info("TapTestIntermittentIdcode","TapTestIntermittentIdcode Started");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      IDC.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestIntermittentIdcode","TapTestIntermittentIdcode Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestIntermittentIdcode

class TapTestEnRegPreChk extends TapBaseTest;

   `uvm_component_utils(TapTestEnRegPreChk)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqEnRegPreChk IDC;  

   function new (string name = "TapTestEnRegPreChk", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      IDC  = new("ALL Primary Mode");
      uvm_report_info("TapTestEnRegPreChk","TapTestEnRegPreChk Started");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      IDC.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestEnRegPreChk","TapTestEnRegPreChk Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestEnRegPreChk

class TapTestAccess10Thrice extends TapBaseTest;

   `uvm_component_utils(TapTestAccess10Thrice)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqAccess10Thrice IDC;  

   function new (string name = "TapTestAccess10Thrice", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      IDC  = new("ALL Primary Mode");
      uvm_report_info("TapTestAccess10Thrice","TapTestAccess10Thrice Started");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      IDC.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestAccess10Thrice","TapTestAccess10Thrice Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestAccess10Thrice


class TapTestTracker extends TapBaseTest;

   `uvm_component_utils(TapTestTracker)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqTracker IDC;  

   function new (string name = "TapTestTracker", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      IDC  = new("ALL Primary Mode");
      uvm_report_info("TapTestTracker","TapTestAccess10Thrice Started");
      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      IDC.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestTracker","TapTestAccess10Thrice Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestTracker


class TapTestTrackerSec extends TapBaseTest;

   `uvm_component_utils(TapTestTrackerSec)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqTracker IDC;  
   TapSeqTrackerSecCfg CFG_SEC;  
   TapSeqTrackerSec    SEC;

   function new (string name = "TapTestTrackerSec", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      IDC  = new("ALL Primary Mode");
      CFG_SEC = new("ALL Primary Mode");
      SEC = new("ALL Primary Mode");

      uvm_report_info("TapTestTrackerSec","TapTestTrackerSec Started");

      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.SecMasterAgent.Sequencer);

      IDC.start(Env.PriMasterAgent.Sequencer);
      CFG_SEC.start(Env.PriMasterAgent.Sequencer);

      SEC.start(Env.SecMasterAgent.Sequencer);

      uvm_report_info("TapTestTrackerSec","TapTestTrackerSec Completed!!!");
      global_stop_request();
   endtask

endclass : TapTestTrackerSec

