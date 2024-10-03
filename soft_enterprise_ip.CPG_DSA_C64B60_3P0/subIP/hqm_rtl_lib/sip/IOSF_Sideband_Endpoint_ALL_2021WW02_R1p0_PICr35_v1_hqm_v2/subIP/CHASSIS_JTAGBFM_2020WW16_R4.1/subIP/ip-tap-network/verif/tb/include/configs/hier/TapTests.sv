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
//-- HIERARCHICAL NETWORK TESTS-------------------------------------------------------------
//------------------------------------------------------------------------------------------

class TapTestHier extends TapBaseTest;

    `ovm_component_utils(TapTestHier)

   TapSequenceReset               SRP,SRS,SRT;
   
   // sTAP_0123 = PPPP, 5 flop delay including Master.
   TapSequenceHierAllPriBypass    H1_Pri_Byp;
   TapSequenceHierAllPriIdcode    H1_Pri_Idc;  
                      
   // sTAP_0123 = SSTT, Since no Teritiary port only 2 flop delay exists.
   // sTAP_0123 = SSSS, 4 flop delay exists, is tested int he same seq by small change & undoing it.
   TapSequenceHierCfg2Sec2TerBypass H2_2SecCfg_Byp;
   TapSequenceHier2Bypass           H2_2Sec_Byp;
   TapSequenceHierCfg4SecBypass     H2a_4SecCfg_Byp;
   TapSequenceHier4Bypass           H2a_4Sec_Byp;

   // sTAP_0123 = SPPP, 1 flop delay on Sec and 4 on Primary.
   TapSequenceHierCfg_sTAP0onSec_sTAP123onPrim_Bypass H3_Cfg;
   TapSequenceHier_sTAP0onSec_Bypass                  H3_Sec_Byp;
   TapSequenceHier_sTAP123onPrim_Bypass               H3_Pri_Byp; 

   // sTAP_0123 = SPTT Teritiary Port
   TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass       H4_TerCfg_Byp;
   TapSequenceHier_sTAP1onPri_Bypass                  H4_Pri_Byp;
   TapSequenceHier_sTAP0onSec_Bypass                  H4_Sec_Byp;
   TapSequenceHier_sTAP23onTer_Bypass                 H4_Ter_Byp;

   // sTAP_0123 = -SP- Pri, Sec Port
   TapSequenceHierCfg_sTap1Sec_sTAP2Pri_Bypass        H5_Cfg;         
   TapSequenceHier_sTAP1onSec_Bypass                  H5_Sec_Byp; 
   TapSequenceHier_sTAP2onPri_Bypass                  H5_Pri_Byp;      

   function new (string name = "TapTestHier", ovm_component parent = null);
       super.new(name,parent);
       SRP = new("Reset Primary");
       SRS = new("Reset Secondary");
       SRT = new("Reset Secondary");

       H1_Pri_Byp    = new("Configure Sequence");
       H1_Pri_Idc    = new("Configure Sequence");

       H2_2SecCfg_Byp = new("Configure Sequence");
       H2_2Sec_Byp    = new("Configure Sequence");
       H2a_4SecCfg_Byp = new("Configure Sequence");
       H2a_4Sec_Byp    = new("Configure Sequence");

       H3_Cfg        = new("Configure Sequence");
       H3_Sec_Byp    = new("Configure Sequence");
       H3_Pri_Byp    = new("Configure Sequence");

       H4_TerCfg_Byp = new("Configure Sequence");
       H4_Pri_Byp    = new("Configure Sequence");
       H4_Sec_Byp    = new("Configure Sequence");
       H4_Ter_Byp    = new("Configure Sequence");

       H5_Cfg        = new("Configure Sequence");
       H5_Sec_Byp    = new("Configure Sequence");
       H5_Pri_Byp    = new("Configure Sequence");

   endfunction : new

   virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    0);
        set_config_int("Env", "quit_count", 200);
        set_config_int("PriMasterAgent", "is_active", OVM_ACTIVE);
        set_config_int("SecMasterAgent", "is_active", OVM_ACTIVE);
        set_config_int("TerMasterAgent", "is_active", OVM_ACTIVE);
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestHier","Test Starts!!!",OVM_NONE);

      // Each of the Agent
      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);
      SRT.start(Env.TerMasterAgent.Sequencer);

      H1_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
      H1_Pri_Idc.start(Env.PriMasterAgent.Sequencer);

      H2_2SecCfg_Byp.start(Env.PriMasterAgent.Sequencer);
      H2_2Sec_Byp.start(Env.SecMasterAgent.Sequencer);

      H2a_4SecCfg_Byp.start(Env.PriMasterAgent.Sequencer);
      H2a_4Sec_Byp.start(Env.SecMasterAgent.Sequencer);

      H3_Cfg.start(Env.PriMasterAgent.Sequencer);
      fork
         H3_Sec_Byp.start(Env.SecMasterAgent.Sequencer);
         H3_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
      join

      H4_TerCfg_Byp.start(Env.PriMasterAgent.Sequencer);
      fork
         H4_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
         H4_Sec_Byp.start(Env.SecMasterAgent.Sequencer);
         H4_Ter_Byp.start(Env.TerMasterAgent.Sequencer);
      join


//  This is not possible architecturally.      
//      H5_Cfg.start(Env.PriMasterAgent.Sequencer);
//      fork
//         //H5_Sec_Byp.start(Env.SecMasterAgent.Sequencer);
//         H5_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
//      join

      ovm_report_info("TapTestHier","TapTestHier Test Completed!!!",OVM_NONE);
      global_stop_request();

   endtask : run
endclass : TapTestHier
//------------------------------------------------------------------------------------------
class MyTapTestHier extends TapBaseTest;

    `ovm_component_utils(MyTapTestHier)

   //TapSequenceReset               SRP,SRS,SRT;
   TapSequenceReset               SRP;

   MyTapSeq_TapSequnceHierAllPrimConfig    My_H1_Pri_Idc_Cfg;  
   MyTapSeq_TapSequnceHierAllPrim          My_H1_Pri_Idc;  

   function new (string name = "MyTapTestHier", ovm_component parent = null);
       super.new(name,parent);
   endfunction : new

   virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    OVM_PASSIVE);
        set_config_int("Env", "quit_count", 200);
        //set_config_int("PriMasterAgent", "is_active", OVM_ACTIVE);
   endfunction : build

   virtual task run();
      ovm_report_info("MyTapTestHier","Test Starts!!!",OVM_NONE);

      SRP                  = new("Reset Primary");
      My_H1_Pri_Idc_Cfg    = new("Configure Sequence");
      My_H1_Pri_Idc        = new("STAP Sequence");

      // Each of the Agent
      SRP.start(Env.PriMasterAgent.Sequencer);

      My_H1_Pri_Idc_Cfg.start(Env.PriMasterAgent.Sequencer);
      fork 
         My_H1_Pri_Idc.start(Env.PriMasterAgent.Sequencer);
      join

      ovm_report_info("MyTapTestHier","MyTapTestHier Test Completed!!!",OVM_NONE);
      global_stop_request();
   endtask : run

endclass : MyTapTestHier
//------------------------------------------------------------------------------------------
