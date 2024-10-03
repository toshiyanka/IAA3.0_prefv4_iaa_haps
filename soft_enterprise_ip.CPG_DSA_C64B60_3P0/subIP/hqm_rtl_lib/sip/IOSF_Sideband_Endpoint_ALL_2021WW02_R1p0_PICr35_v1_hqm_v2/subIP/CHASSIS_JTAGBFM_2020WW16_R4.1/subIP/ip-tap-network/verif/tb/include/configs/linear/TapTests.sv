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

//------------------------------------------------------------------------------------------
//-- LINEAR NETWORK TESTS-------------------------------------------------------------------
//------------------------------------------------------------------------------------------

class TapTestLinear extends TapBaseTest;

    `ovm_component_utils(TapTestLinear)
   
   TapSequenceReset                    SRP,SRS,SRT;

   // sTAP_0123 = PPPP, 5 flop delay including Master.
   TapSequenceHierAllPriBypass         L1_Pri_Byp;
   TapSequenceHierAllPriIdcode         L1_Pri_Idc;  
                      
   // sTAP_0123 = --P-, 2 flop delay including Master.
   TapSequenceLinearCfg                L2_Pri_Cfg;
   TapSequenceLinear_sTAP2onPri_Bypass L2_Pri_Byp;

   // sTAP_0123 = --P-, Idcode for above.
   TapSequenceLinearCfg_Idcode         L3_Pri_Cfg_Idc;
   TapSequenceLinear_sTAP2onPri_Idcode L3_Pri_Idc;                        

   // sTAP_0123 = --PS, Bypass.
   TapSequenceLinearCfg_S2Pri_S3Sec_Byp L4_Cfg;
   TapSequenceLinear_sTAP2onPri_Bypass  L4_Pri_Byp;
   TapSequenceLinear_sTAP3onSec_Bypass  L4_Sec_Byp;
   TapSequenceLinear_sTAP2onPri_Idcode  L4_Pri_Idc;
   TapSequenceLinear_sTAP3onSec_Idcode  L4_Sec_Idc;

   // sTAP_0123 = -PS-, Bypass
   TapSequenceLinearCfg_S1Pri_S2Sec_Byp L5_Cfg;
   TapSequenceLinear_sTAP2onPri_Bypass  L5_Pri_Byp;
   TapSequenceLinear_sTAP3onSec_Bypass  L5_Sec_Byp;

   // sTAP_0123 = -SP-, Bypass
   TapSequenceLinearCfg_S1Sec_S2Pri_Byp L6_Cfg;
   TapSequenceLinear_sTAP2onPri_Bypass  L6_Pri_Byp;
   TapSequenceLinear_sTAP3onSec_Bypass  L6_Sec_Byp;

   // sTAP_0123 = SSSS, 4 flop delay excluding Master.
   TapSequenceLinearCfg_AllSec_Byp      L7_AllSec_Cfg;
   TapSequenceHier_sTAP123onPrim_Bypass L7_AllSec_Byp;

   TapSequenceSoftReset Five_TMS;

   function new (string name = "TapTestLinear", ovm_component parent = null);
       super.new(name,parent);
       
       SRP = new("Reset Primary");
       SRS = new("Reset Secondary");

       Five_TMS = new("Soft Reset");

       L1_Pri_Byp     = new("Configure Sequence");
       L1_Pri_Idc     = new("Configure Sequence");

       L2_Pri_Cfg     = new("Configure Sequence1");
       L2_Pri_Byp     = new("Configure Sequence2");

       L3_Pri_Cfg_Idc = new("Configure Sequence");
       L3_Pri_Idc     = new("Configure Sequence");

       L4_Cfg         = new("Configure Sequence");
       L4_Pri_Byp     = new("Configure Sequence");
       L4_Sec_Byp     = new("Configure Sequence");
       L4_Pri_Idc     = new("Configure Sequence");
       L4_Sec_Idc     = new("Configure Sequence");

       L5_Cfg         = new("Configure Sequence");
       L5_Pri_Byp     = new("Configure Sequence");
       L5_Sec_Byp     = new("Configure Sequence");

       L6_Cfg         = new("Configure Sequence");
       L6_Pri_Byp     = new("Configure Sequence");
       L6_Sec_Byp     = new("Configure Sequence");

       L7_AllSec_Cfg  = new("Configure Sequence");
       L7_AllSec_Byp  = new("Configure Sequence");

   endfunction : new

   virtual function void build();
        super.build();
        set_config_int("Env", "has_scoreboard",    0);
        set_config_int("Env", "quit_count", 200);
   endfunction : build

   virtual task run();
      ovm_report_info("TapTestLinear","Test Starts!!!",OVM_NONE);

      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);

      L1_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
      L1_Pri_Idc.start(Env.PriMasterAgent.Sequencer);

      L2_Pri_Cfg.start(Env.PriMasterAgent.Sequencer);
      L2_Pri_Byp.start(Env.PriMasterAgent.Sequencer);

      L3_Pri_Cfg_Idc.start(Env.PriMasterAgent.Sequencer);
      L3_Pri_Idc.start(Env.PriMasterAgent.Sequencer);

      L4_Cfg.start(Env.PriMasterAgent.Sequencer);
      fork
         L4_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
         L4_Sec_Byp.start(Env.SecMasterAgent.Sequencer);
      join
      fork
         L4_Pri_Idc.start(Env.PriMasterAgent.Sequencer);
         L4_Sec_Idc.start(Env.SecMasterAgent.Sequencer);
      join

      L5_Cfg.start(Env.PriMasterAgent.Sequencer);
      fork
         begin 
            L5_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
         end   
         begin 
            Five_TMS.start(Env.SecMasterAgent.Sequencer);
            L5_Sec_Byp.start(Env.SecMasterAgent.Sequencer);
         end   
      join

      L6_Cfg.start(Env.PriMasterAgent.Sequencer);
      fork
         L6_Pri_Byp.start(Env.PriMasterAgent.Sequencer);
         L6_Sec_Byp.start(Env.SecMasterAgent.Sequencer);
      join

      L7_AllSec_Cfg.start(Env.PriMasterAgent.Sequencer);
      L7_AllSec_Byp.start(Env.SecMasterAgent.Sequencer);

      ovm_report_info("TapTestLinear","TapTestLinear Test Completed!!!",OVM_NONE);
      global_stop_request();

   endtask : run
endclass : TapTestLinear

