//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
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
`ifdef JTAG_BFM_TAPLINK_MODE
class TapTestAllPrimary extends TapBaseTest;

    `ovm_component_utils(TapTestAllPrimary)
    TapSequencePrimaryOnly SP;

   function new (string name = "TapTestAllPrimary", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
        ovm_report_info("TapTest","Test Starts!!!",OVM_NONE);
        SP = new("ALL Primary Mode");
        SP.start(Env.PriMasterAgent.Sequencer);
        ovm_report_info("TapTestAllPrimaryTest","TapTestAllPrimaryTest Completed!!!",OVM_NONE);
        global_stop_request();
   endtask : run
endclass : TapTestAllPrimary
`else
//----------------------------------------------------------------------
class TapTestAllPrimary extends TapBaseTest;

    `ovm_component_utils(TapTestAllPrimary)
    TapSequencePrimaryOnly SP;

   function new (string name = "TapTestAllPrimary", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
        ovm_report_info("TapTest","Test Starts!!!",OVM_NONE);
        SP = new("ALL Primary Mode");
        SP.start(Env.PriMasterAgent.Sequencer);
        ovm_report_info("TapTestAllPrimaryTest","TapTestAllPrimaryTest Completed!!!",OVM_NONE);
        global_stop_request();
   endtask : run
endclass : TapTestAllPrimary
`endif

//------------------------------------------------------------------------------------------
class TapTestAllSecondaryNormal extends TapBaseTest;

    `ovm_component_utils(TapTestAllSecondaryNormal)
   TapSequenceReset SRP,SRS;
   TapSequenceConfigureAllSecNormal S1;
   TapSequenceAllSecNormal S2;

   function new (string name = "TapTestAllSecondaryNormal", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestAllSecondaryNormal","Test Starts!!!",OVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      S1 =  new("Configure Sequence");
      S2 =  new("Secondary Sequence");
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      S1.start(Env.PriMasterAgent.Sequencer);
      S2.start(Env.SecMasterAgent.Sequencer);
      ovm_report_info("TapTestAllSecondaryNormal","TapTestAllSecondaryNormal Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run
endclass : TapTestAllSecondaryNormal
//------------------------------------------------------------------------------------------
class TapTestAllSecondaryNormalDecoupled extends TapBaseTest;

    `ovm_component_utils(TapTestAllSecondaryNormalDecoupled)
   TapSequenceReset SRP,SRS;
   TapSequenceConfigureAllSecNormalDecoupledC1 SC1;
   TapSequenceConfigureAllSecNormalDecoupledC2 SC2;
   TapSequenceConfigureAllSecNormalDecoupledC3 SC3;
   TapSequenceConfigureAllSecNormalDecoupledC4 SC4;
   TapSequenceSingleTAP SC;

   function new (string name = "TapTestAllSecondaryNormalDecoupled", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestAllSecondaryNormalDecoupled","Test Starts!!!",OVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      SC1 =  new("Configure Sequence");
      SC2 =  new("Configure Sequence");
      SC3 =  new("Configure Sequence");
      SC4 =  new("Configure Sequence");
      SC =  new("Secondary Sequence");
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SC1.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      SC2.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      SC3.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      SC4.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      ovm_report_info("TapTestAllSecondaryNormalDecoupled","TapTestAllSecondaryNormalDecoupled Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run
endclass : TapTestAllSecondaryNormalDecoupled
//------------------------------------------------------------------------------------------
class TapTestAllSecondaryNormalShadow extends TapBaseTest;

    `ovm_component_utils(TapTestAllSecondaryNormalShadow)
   TapSequenceReset SRP,SRS;
   TapSequenceConfigureAllSecNormalShadowC1 SC1;
   TapSequenceConfigureAllSecNormalShadowC2 SC2;
   TapSequenceConfigureAllSecNormalShadowC3 SC3;
   TapSequenceConfigureAllSecNormalShadowC4 SC4;
   TapSequenceSingleTAP SC;

   function new (string name = "TapTestAllSecondaryNormalShadow", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestAllSecondaryNormalShadow","Test Starts!!!",OVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      SC1 =  new("Configure Sequence");
      SC2 =  new("Configure Sequence");
      SC3 =  new("Configure Sequence");
      SC4 =  new("Configure Sequence");
      SC =  new("Secondary Sequence");
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SC1.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SC2.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SC3.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SC4.start(Env.PriMasterAgent.Sequencer);
      SC.start(Env.SecMasterAgent.Sequencer);
      ovm_report_info("TapTestAllSecondaryNormalShadow","TapTestAllSecondaryNormalShadow Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run
endclass : TapTestAllSecondaryNormalShadow
//------------------------------------------------------------------------------------------
class TapTestAllPriSecInParallel extends TapBaseTest;

    `ovm_component_utils(TapTestAllPriSecInParallel)
   TapSequenceReset                    SRP,SRS;
   TapSequenceConfigureSTAPSecWTAPPri1 SCon1;
   TapSequenceConfigureSTAPSecWTAPPri2 SCon2;
   TapSequenceAllSecNormal             SW;
   TapSequence5TapRegAccess            SP;

   function new (string name = "TapTestAllPriSecInParallel", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestAllPriSecInParallel","Test Starts!!!",OVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      SCon1 =  new("Configure Sequence");
      SCon2 =  new("Configure Sequence");
      SW =  new("Secondary Sequence");
      SP =  new("Primary Sequence");

      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SCon1.start(Env.PriMasterAgent.Sequencer);
      fork 
          SW.start(Env.SecMasterAgent.Sequencer);
          SP.start(Env.PriMasterAgent.Sequencer);
      join    
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SCon2.start(Env.PriMasterAgent.Sequencer);
      fork 
          SW.start(Env.SecMasterAgent.Sequencer);
          SP.start(Env.PriMasterAgent.Sequencer);
      join    
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      ovm_report_info("TapTestAllPriSecInParallel","TapTestAllPriSecInParallel Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run
endclass : TapTestAllPriSecInParallel
//------------------------------------------------------------------------------------------
class TapTestMiscConfig extends TapBaseTest;

    `ovm_component_utils(TapTestMiscConfig)
   TapSequenceReset                                 SRP,SRS;
   TapSequenceConfigure2sTAPPri2sTAPSecAllWTAPPri   SCon;
   TapSequence2TAPRegAccess                         SSec;
   TapSequence7TapRegAccess                         SPri;

   function new (string name = "TapTestMiscConfig", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestMiscConfig","Test Starts!!!",OVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      SCon =  new("Configure Sequence");
      SSec =  new("Secondary Sequence");
      SPri =  new("Primary Sequence");

      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SCon.start(Env.PriMasterAgent.Sequencer);
      fork 
          SSec.start(Env.SecMasterAgent.Sequencer);
          SPri.start(Env.PriMasterAgent.Sequencer);
      join    
      ovm_report_info("TapTestMiscConfig","TapTestMiscConfig Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run
endclass : TapTestMiscConfig
//------------------------------------------------------------------------------------------
class TapTestNWp7ConfigOVR extends TapBaseTest;

    `ovm_component_utils(TapTestNWp7ConfigOVR)
   TapSequenceReset                                 SRP,SRS;
   TapSequenceNWp7ConfigOVR                         SCon;
   TapSequenceSingleTAP                             SSec;
   TapSequence2TAPRegAccess                         SPri;
   TapSequenceReset_b                               SRstb;

   function new (string name = "TapTestNWp7ConfigOVR", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestNWp7ConfigOVR","Test Starts!!!",OVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      SCon =  new("Configure Sequence");
      SSec =  new("Secondary Sequence");
      SPri =  new("Primary Sequence");
      SRstb = new("Asserting RESET_B");
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SCon.start(Env.PriMasterAgent.Sequencer);
      fork
          SSec.start(Env.SecMasterAgent.Sequencer);
          SPri.start(Env.PriMasterAgent.Sequencer);
      join    
      SRstb.start(Env.PriMasterAgent.Sequencer);
      fork
          SSec.start(Env.SecMasterAgent.Sequencer);
          SPri.start(Env.PriMasterAgent.Sequencer);
      join 
      ovm_report_info("TapTestNWp7ConfigOVR","TapTestNWp7ConfigOVR Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run
endclass : TapTestNWp7ConfigOVR
//------------------------------------------------------------------------------------------
class TapTestALLsTAPSEC extends TapBaseTest;

    `ovm_component_utils(TapTestALLsTAPSEC)
   TapSequenceReset                                 SRP,SRS;
   TapSequenceConfigureWTAPPri                      SConPri;
   TapSequenceConfigureWTAPSec                      SConSec;
   TapSequenceWTAPIDCODE                            SSec;
   TapSequence5TapRegAccess                         SPri;

   function new (string name = "TapTestALLsTAPSEC", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestALLsTAPSEC","Test Starts!!!",OVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      SConPri =  new("Configure Sequence");
      SConSec =  new("Configure Sequence");
      SSec =  new("Secondary Sequence");
      SPri =  new("Primary Sequence");

      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SConPri.start(Env.PriMasterAgent.Sequencer);
      SPri.start(Env.PriMasterAgent.Sequencer);
      SConSec.start(Env.PriMasterAgent.Sequencer);
      SSec.start(Env.SecMasterAgent.Sequencer);
      ovm_report_info("TapTestALLsTAPSEC","TapTestALLsTAPSEC Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run
endclass : TapTestALLsTAPSEC
//------------------------------------------------------------------------------------------
class TapTestTry extends TapBaseTest;

    `ovm_component_utils(TapTestTry)
    TapSequenceTry ST;

   function new (string name = "TapTestTry", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
        set_config_int("*", "max_run_clocks", 2000000);
   endfunction : build

   virtual task run();
        ovm_report_info("TapTestTry","Test Starts!!!",OVM_NONE);
        ST = new("ALL Primary Mode");
        ST.start(Env.PriMasterAgent.Sequencer);
        ovm_report_info("TapTestTry","TapTestTry Completed!!!",OVM_NONE);
        global_stop_request();
   endtask : run
endclass : TapTestTry

//---------------------------------------------------------------
// Added 27Mar14 for matching ITPP opcode on Tester
// LoadDR_E1DR, LoadIR_E1IR -- https://hsdes.intel.com/home/default.html/article?id=1018012221 
//---------------------------------------------------------------
class TapTestLoadIRDR_E1 extends TapBaseTest;

   `ovm_component_utils(TapTestLoadIRDR_E1)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqLoadIRDR_E1 IDC;

   function new (string name = "TapTestLoadIRDR_E1", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
   endfunction : build

   virtual task run();
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      IDC  = new("ALL Primary Mode");

      ovm_report_info("TapTestLoadIRDR_E1","TapTestLoadIRDR_E1 Started");

      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      IDC.start(Env.PriMasterAgent.Sequencer);

      ovm_report_info("TapTestLoadIRDR_E1","TapTestLoadIRDR_E1 Completed!!!", OVM_NONE);
      global_stop_request();
   endtask : run

endclass : TapTestLoadIRDR_E1


//------------------------------------
// 19-Nov-2014 tms_tdi_stream missing clock issue
// https://hsdes.intel.com/home/default.html#article?id=1603916954
//------------------------------------
class TapTestTmsTdiStrmTry extends TapBaseTest;

    `ovm_component_utils(TapTestTmsTdiStrmTry)


    SoCTapNwBuildTapDataBaseSeq BTDS;
    TapSequenceReset SRP;
    TapSeqTmsTdiStrmTry IDC;

    function new (string name = "TapTestTmsTdiStrmTry", ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build();
        super.build();
        set_config_int("Env.PriMasterAgent*", "enable_clk_gating", 1);
    endfunction : build

    virtual task run();
       ovm_report_info("TapTestTmsTdiStrmTry","Test Starts!!!");
       BTDS = new("ALL Primary Mode");
       SRP  = new("ALL Primary Mode");
       IDC  = new("ALL Primary Mode");

       BTDS.start(Env.PriMasterAgent.Sequencer);
       SRP.start(Env.PriMasterAgent.Sequencer);
       IDC.start(Env.PriMasterAgent.Sequencer);
       #100ns;
       ovm_report_info("TapTestTmsTdiStrmTry","Test Completed!!!", OVM_NONE);
       global_stop_request();
    endtask : run
endclass : TapTestTmsTdiStrmTry
