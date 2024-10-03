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

class TapTestAllPrimary extends TapBaseTest;

    `uvm_component_utils(TapTestAllPrimary)
    TapSequencePrimaryOnly SP;

   function new (string name = "TapTestAllPrimary", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TapTest","Test Starts!!!",UVM_NONE);
        SP = new("ALL Primary Mode");
        SP.start(Env.PriMasterAgent.Sequencer);
        uvm_report_info("TapTestAllPrimaryTest","TapTestAllPrimaryTest Completed!!!",UVM_NONE);
        //global_stop_request();
   endtask
endclass : TapTestAllPrimary
//------------------------------------------------------------------------------------------
class TapTestAllSecondaryNormal extends TapBaseTest;

    `uvm_component_utils(TapTestAllSecondaryNormal)
   TapSequenceReset SRP,SRS;
   TapSequenceConfigureAllSecNormal S1;
   TapSequenceAllSecNormal S2;

   function new (string name = "TapTestAllSecondaryNormal", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestAllSecondaryNormal","Test Starts!!!",UVM_NONE);
      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      S1 =  new("Configure Sequence");
      S2 =  new("Secondary Sequence");
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      S1.start(Env.PriMasterAgent.Sequencer);
      S2.start(Env.SecMasterAgent.Sequencer);
      uvm_report_info("TapTestAllSecondaryNormal","TapTestAllSecondaryNormal Test Completed!!!",UVM_NONE);
      //global_stop_request();
   endtask
endclass : TapTestAllSecondaryNormal
//------------------------------------------------------------------------------------------
class TapTestAllSecondaryNormalDecoupled extends TapBaseTest;

    `uvm_component_utils(TapTestAllSecondaryNormalDecoupled)
   TapSequenceReset SRP,SRS;
   TapSequenceConfigureAllSecNormalDecoupledC1 SC1;
   TapSequenceConfigureAllSecNormalDecoupledC2 SC2;
   TapSequenceConfigureAllSecNormalDecoupledC3 SC3;
   TapSequenceConfigureAllSecNormalDecoupledC4 SC4;
   TapSequenceSingleTAP SC;

   function new (string name = "TapTestAllSecondaryNormalDecoupled", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestAllSecondaryNormalDecoupled","Test Starts!!!",UVM_NONE);
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
      uvm_report_info("TapTestAllSecondaryNormalDecoupled","TapTestAllSecondaryNormalDecoupled Test Completed!!!",UVM_NONE);
      //global_stop_request();
   endtask
endclass : TapTestAllSecondaryNormalDecoupled
//------------------------------------------------------------------------------------------
class TapTestAllSecondaryNormalShadow extends TapBaseTest;

    `uvm_component_utils(TapTestAllSecondaryNormalShadow)
   TapSequenceReset SRP,SRS;
   TapSequenceConfigureAllSecNormalShadowC1 SC1;
   TapSequenceConfigureAllSecNormalShadowC2 SC2;
   TapSequenceConfigureAllSecNormalShadowC3 SC3;
   TapSequenceConfigureAllSecNormalShadowC4 SC4;
   TapSequenceSingleTAP SC;

   function new (string name = "TapTestAllSecondaryNormalShadow", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestAllSecondaryNormalShadow","Test Starts!!!",UVM_NONE);
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
      uvm_report_info("TapTestAllSecondaryNormalShadow","TapTestAllSecondaryNormalShadow Test Completed!!!",UVM_NONE);
      //global_stop_request();
   endtask
endclass : TapTestAllSecondaryNormalShadow
//------------------------------------------------------------------------------------------
class TapTestAllPriSecInParallel extends TapBaseTest;

    `uvm_component_utils(TapTestAllPriSecInParallel)
   TapSequenceReset                    SRP,SRS;
   TapSequenceConfigureSTAPSecWTAPPri1 SCon1;
   TapSequenceConfigureSTAPSecWTAPPri2 SCon2;
   TapSequenceAllSecNormal             SW;
   TapSequence5TapRegAccess            SP;

   function new (string name = "TapTestAllPriSecInParallel", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestAllPriSecInParallel","Test Starts!!!",UVM_NONE);
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
      uvm_report_info("TapTestAllPriSecInParallel","TapTestAllPriSecInParallel Test Completed!!!",UVM_NONE);
      //global_stop_request();
   endtask
endclass : TapTestAllPriSecInParallel
//------------------------------------------------------------------------------------------
class TapTestMiscConfig extends TapBaseTest;

    `uvm_component_utils(TapTestMiscConfig)
   TapSequenceReset                                 SRP,SRS;
   TapSequenceConfigure2sTAPPri2sTAPSecAllWTAPPri   SCon;
   TapSequence2TAPRegAccess                         SSec;
   TapSequence7TapRegAccess                         SPri;

   function new (string name = "TapTestMiscConfig", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestMiscConfig","Test Starts!!!",UVM_NONE);
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
      uvm_report_info("TapTestMiscConfig","TapTestMiscConfig Test Completed!!!",UVM_NONE);
      //global_stop_request();
   endtask
endclass : TapTestMiscConfig
//------------------------------------------------------------------------------------------
class TapTestNWp7ConfigOVR extends TapBaseTest;

    `uvm_component_utils(TapTestNWp7ConfigOVR)
   TapSequenceReset                                 SRP,SRS;
   TapSequenceNWp7ConfigOVR                         SCon;
   TapSequenceSingleTAP                             SSec;
   TapSequence2TAPRegAccess                         SPri;
   TapSequenceReset_b                               SRstb;

   function new (string name = "TapTestNWp7ConfigOVR", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestNWp7ConfigOVR","Test Starts!!!",UVM_NONE);
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
      uvm_report_info("TapTestNWp7ConfigOVR","TapTestNWp7ConfigOVR Test Completed!!!",UVM_NONE);
      //global_stop_request();
   endtask
endclass : TapTestNWp7ConfigOVR
//------------------------------------------------------------------------------------------
class TapTestALLsTAPSEC extends TapBaseTest;

    `uvm_component_utils(TapTestALLsTAPSEC)
   TapSequenceReset                                 SRP,SRS;
   TapSequenceConfigureWTAPPri                      SConPri;
   TapSequenceConfigureWTAPSec                      SConSec;
   TapSequenceWTAPIDCODE                            SSec;
   TapSequence5TapRegAccess                         SPri;

   function new (string name = "TapTestALLsTAPSEC", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("TapTestALLsTAPSEC","Test Starts!!!",UVM_NONE);
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
      uvm_report_info("TapTestALLsTAPSEC","TapTestALLsTAPSEC Test Completed!!!",UVM_NONE);
      //global_stop_request();
   endtask
endclass : TapTestALLsTAPSEC
//------------------------------------------------------------------------------------------
class TapTestTry extends TapBaseTest;

    `uvm_component_utils(TapTestTry)
    TapSequenceTry ST;

   function new (string name = "TapTestTry", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        uvm_config_int::set(this, "*", "max_run_clocks", 2000000);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("TapTestTry","Test Starts!!!",UVM_NONE);
        ST = new("ALL Primary Mode");
        ST.start(Env.PriMasterAgent.Sequencer);
        uvm_report_info("TapTestTry","TapTestTry Completed!!!",UVM_NONE);
        //global_stop_request();
   endtask
endclass : TapTestTry

//---------------------------------------------------------------
// Added 27Mar14 for matching ITPP opcode on Tester
// LoadDR_E1DR, LoadIR_E1IR -- https://hsdes.intel.com/home/default.html/article?id=1018012221 
//---------------------------------------------------------------
class TapTestLoadIRDR_E1 extends TapBaseTest;

   `uvm_component_utils(TapTestLoadIRDR_E1)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqLoadIRDR_E1 IDC;

   function new (string name = "TapTestLoadIRDR_E1", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS = new("ALL Primary Mode");
      SRP  = new("ALL Primary Mode");
      IDC  = new("ALL Primary Mode");

      uvm_report_info("TapTestLoadIRDR_E1","TapTestLoadIRDR_E1 Started");

      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      IDC.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestLoadIRDR_E1","TapTestLoadIRDR_E1 Completed!!!", UVM_NONE);
      //global_stop_request();
   endtask

endclass : TapTestLoadIRDR_E1

//------------------------------------
// 19-Nov-2014 tms_tdi_stream missing clock issue
// https://hsdes.intel.com/home/default.html#article?id=1603916954
//------------------------------------
class TapTestTmsTdiStrmTry extends TapBaseTest;

    `uvm_component_utils(TapTestTmsTdiStrmTry)


    SoCTapNwBuildTapDataBaseSeq BTDS;
    TapSequenceReset SRP;
    TapSeqTmsTdiStrmTry IDC;

    function new (string name = "TapTestTmsTdiStrmTry", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        uvm_config_int::set(this, "Env.PriMasterAgent*", "enable_clk_gating", 1);
    endfunction : build_phase

    virtual task run_phase (uvm_phase phase);
       uvm_report_info("TapTestTmsTdiStrmTry","Test Starts!!!");
       BTDS = new("ALL Primary Mode");
       SRP  = new("ALL Primary Mode");
       IDC  = new("ALL Primary Mode");

       BTDS.start(Env.PriMasterAgent.Sequencer);
       SRP.start(Env.PriMasterAgent.Sequencer);
       IDC.start(Env.PriMasterAgent.Sequencer);
       #100ns;
       uvm_report_info("TapTestTmsTdiStrmTry","Test Completed!!!", UVM_NONE);
       //global_stop_request();
    endtask
endclass : TapTestTmsTdiStrmTry

//-----------------------------------------------------------------------------------------------------
// 05-Mar-2015: Added for displaying the bits in log file based on corresponding mask_capture inputs
// PCR_TITLE: Jtag BFM - Request for new ExpDataorCapData_MultipleTapRegisterAccess
// PCR_NO: https://hsdes.intel.com/home/default.html#article?id=1205378989 
//-----------------------------------------------------------------------------------------------------
class TapTestCTVReturnTDO extends TapBaseTest;

   `uvm_component_utils(TapTestCTVReturnTDO)

   SoCTapNwBuildTapDataBaseSeq BTDS;
   TapSequenceReset SRP;
   TapSeqCTVReturnTDO CTVRTDO;

   function new (string name = "TapTestCTVReturnTDO", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      BTDS    = new("ALL Primary Mode");
      SRP     = new("ALL Primary Mode");
      CTVRTDO = new("ALL Primary Mode");

      uvm_report_info("TapTestCTVReturnTDO","TapTestCTVReturnTDOStarted");

      BTDS.start(Env.PriMasterAgent.Sequencer);
      SRP.start(Env.PriMasterAgent.Sequencer);
      CTVRTDO.start(Env.PriMasterAgent.Sequencer);

      uvm_report_info("TapTestCTVReturnTDO","TapTestCTVReturnTDOCompleted!!!", UVM_NONE);
      //global_stop_request();
   endtask

endclass : TapTestCTVReturnTDO


//------------------------------------------------------------------------------------------
class RTDRTapTest extends TapBaseTest;
   
   `uvm_component_utils_begin(RTDRTapTest)
   `uvm_field_object (i_JtagBfmCfg, UVM_ALL_ON|UVM_NOPRINT)
   `uvm_component_utils_end

   TapSeqRtdr SP;
   // Components of the environment
   JtagBfmCfg            i_JtagBfmCfg;

   function new (string name = "RTDRTapTest", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);  
      super.build_phase(phase);
      i_JtagBfmCfg = JtagBfmCfg::type_id::create("i_JtagBfmCfg",this);

      // To register the configuration descriptor
      uvm_config_object::set(this, "*", "JtagBfmCfg", i_JtagBfmCfg);
//      i_JtagBfmCfg.rtdr_is_bussed =1'b1;
      i_JtagBfmCfg.use_rtdr_interface = 1'b1;
      uvm_config_int::set(this, "Env.PriMasterAgent**","rtdr_is_bussed", i_JtagBfmCfg.rtdr_is_bussed); 
      uvm_config_int::set(this, "Env.PriMasterAgent**","use_rtdr_interface",  i_JtagBfmCfg.use_rtdr_interface);
      uvm_config_int::set(this, "Env.SecMasterAgent**","rtdr_is_bussed", i_JtagBfmCfg.rtdr_is_bussed); 
      uvm_config_int::set(this, "Env.SecMasterAgent**","use_rtdr_interface",  i_JtagBfmCfg.use_rtdr_interface);
      uvm_config_int::set(this, "Env","has_scoreboard",  0);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("RTDRTapTest", "Test Starts!!!",UVM_NONE);
      SP = new("TapSeqRtdr");
      SP.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("RTDRTapTest", "RTDRTapTest Completed",UVM_NONE);
      //global_stop_request();
   endtask

endclass : RTDRTapTest
