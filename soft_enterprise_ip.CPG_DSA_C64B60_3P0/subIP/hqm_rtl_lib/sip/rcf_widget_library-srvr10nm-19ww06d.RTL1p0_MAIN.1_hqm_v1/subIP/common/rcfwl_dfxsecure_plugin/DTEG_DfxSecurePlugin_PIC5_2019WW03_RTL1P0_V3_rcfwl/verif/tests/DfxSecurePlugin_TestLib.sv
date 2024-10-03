//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//
//  Collateral Description:
//  %header_collateral%
//
//  Source organization:
//  %header_organization%
//
//  Support Information:
//  %header_support%
//
//  Revision:
//  %header_tag%
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_TestLib.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : This is the Test Library for the Testbench
//    DESCRIPTION : This file contains all the test classes. 
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_TestLib
`define INC_DfxSecurePlugin_TestLib


/*--------------------------------------------------
This test places the DUT in Default mode.
--------------------------------------------------*/
class DfxSecurePlugin_DefaultTest extends DfxSecurePlugin_BaseTest;

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `ovm_component_utils (DfxSecurePlugin_DefaultTest)

   //-------------------
   // Sequence Instance 
   //-------------------
   DfxSecurePlugin_BaseSeq#(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_DefaultSeq;
   DfxSecurePlugin_DrivePowerGoodSeq#(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_DrivePowerGoodSeq;

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DefaultTest",
                 ovm_component parent = null);
      super.new (name, parent);
   endfunction : new

   //----------------
   // Build Function
   //----------------
   function void build ();
      super.build ();
   endfunction : build

   //----------
   // Run Task
   //----------
   task run ();
      i_DfxSecurePlugin_DefaultSeq =DfxSecurePlugin_BaseSeq#(`DSP_TB_PARAMS_INST)::type_id::create("DfxSecurePlugin_BaseSeq",this);
      i_DfxSecurePlugin_DrivePowerGoodSeq = DfxSecurePlugin_DrivePowerGoodSeq#(`DSP_TB_PARAMS_INST)::type_id::create("DfxSecurePlugin_DrivePowerGoodSeq",this);
      `ovm_info (get_type_name(), "Running DfxSecurePlugin_DefaultTest ...", OVM_MEDIUM);

      i_DfxSecurePlugin_DrivePowerGoodSeq.start (i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
      i_DfxSecurePlugin_DefaultSeq.start (i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);

      `ovm_info (get_type_name(), "DfxSecurePlugin_DefaultTest Test Completed", OVM_MEDIUM);
      global_stop_request ();
   endtask : run

endclass : DfxSecurePlugin_DefaultTest

/*--------------------------------------------------
This test place the DUT in test_driver mode. Drive the reset asynchrously.
Drive all 16 policies in DFX_SECURE_POLICY_MATRIX
--------------------------------------------------*/
class DfxSecurePlugin_DriveUserPolicySeqTest extends DfxSecurePlugin_BaseTest;

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `ovm_component_utils (DfxSecurePlugin_DriveUserPolicySeqTest)

   //-------------------
   // Sequence Instance 
   //-------------------
   DfxSecurePlugin_DriveUserPolicySeq#(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_DriveUserPolicySeq;

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DriveUserPolicySeqTest",
                 ovm_component parent = null);
      super.new (name, parent);
   endfunction : new

   //----------------
   // Build Function
   //----------------
   function void build ();
      super.build ();
      i_DfxSecurePlugin_DriveUserPolicySeq = DfxSecurePlugin_DriveUserPolicySeq#(`DSP_TB_PARAMS_INST)::type_id::create("DfxSecurePlugin_BypSeq",this);
   endfunction : build

   //----------
   // Run Task
   //----------
   task run ();
      `ovm_info (get_type_name(), "Running DfxSecurePlugin_DriveUserPolicySeqTest ...", OVM_MEDIUM);
      i_DfxSecurePlugin_DriveUserPolicySeq.start (i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
      `ovm_info (get_type_name(), "DfxSecurePlugin_DriveUserPolicySeqTest Test Completed", OVM_MEDIUM);
      global_stop_request ();
   endtask : run

endclass : DfxSecurePlugin_DriveUserPolicySeqTest

/*--------------------------------------------------
This test place the DUT in test_driver mode. 
Drive User defined inputs to DUT
--------------------------------------------------*/
class DfxSecurePlugin_DriveAllUserInputSeqTest extends DfxSecurePlugin_BaseTest;

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `ovm_component_utils (DfxSecurePlugin_DriveAllUserInputSeqTest)

   //-------------------
   // Sequence Instance 
   //-------------------
   DfxSecurePlugin_DriveAllUserInputSeq#(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_DriveAllUserInputSeq;

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DriveAllUserInputSeqTest",
                 ovm_component parent = null);
      super.new (name, parent);
   endfunction : new

   //----------------
   // Build Function
   //----------------
   function void build ();
      super.build ();
   endfunction : build

   //----------
   // Run Task
   //----------
   task run ();
      i_DfxSecurePlugin_DriveAllUserInputSeq = DfxSecurePlugin_DriveAllUserInputSeq#(`DSP_TB_PARAMS_INST)::type_id::create("DfxSecurePlugin_DriveAllUserInputSeq",this);
      `ovm_info (get_type_name(), "Running DfxSecurePlugin_DriveAllUserInputSeqTest ...", OVM_MEDIUM);
      i_DfxSecurePlugin_DriveAllUserInputSeq.start (i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
      `ovm_info (get_type_name(), "DfxSecurePlugin_DriveAllUserInputSeqTest Test Completed", OVM_MEDIUM);
      global_stop_request ();
   endtask : run

endclass : DfxSecurePlugin_DriveAllUserInputSeqTest
/*--------------------------------------------------
This test place the DUT in drive_user_policy mode. Drive the reset asynchrously.
Drive the user defined policies on DFX_SECURE_POLICY_MATRIX
--------------------------------------------------*/
class DfxSecurePlugin_PolicySweepSeqTest extends DfxSecurePlugin_BaseTest;

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `ovm_component_utils (DfxSecurePlugin_PolicySweepSeqTest)

   //-------------------
   // Sequence Instance 
   //-------------------
   DfxSecurePlugin_PolicySweepSeq i_DfxSecurePlugin_PolicySweepSeq;

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_PolicySweepSeqTest",
                 ovm_component parent = null);
      super.new (name, parent);
   endfunction : new

   //----------------
   // Build Function
   //----------------
   function void build ();
      super.build ();
   endfunction : build

   //----------
   // Run Task
   //----------
   task run ();
      i_DfxSecurePlugin_PolicySweepSeq = DfxSecurePlugin_PolicySweepSeq::type_id::create("DfxSecurePlugin_PolicySweepSeq",this);
      `ovm_info (get_type_name(), "Running DfxSecurePlugin_PolicySweepSeqTest ...", OVM_MEDIUM);
      i_DfxSecurePlugin_PolicySweepSeq.start (i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
      `ovm_info (get_type_name(), "DfxSecurePlugin_PolicySweepSeqTest Test Completed", OVM_MEDIUM);
      global_stop_request ();
   endtask : run

endclass : DfxSecurePlugin_PolicySweepSeqTest

/*--------------------------------------------------
This test place the DUT in sideband_policy mode. Drive the reset asynchrously.
Drive the sb_policy_ovr_value & oem_secure_policy inputs to the 0x5 & 0x7
respectively
--------------------------------------------------*/
class DfxSecurePlugin_DriveUserPolicyViaSBOVRSeqTest extends DfxSecurePlugin_BaseTest;

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `ovm_component_utils (DfxSecurePlugin_DriveUserPolicyViaSBOVRSeqTest)

   //-------------------
   // Sequence Instance 
   //-------------------
   DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq i_DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq;

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DriveUserPolicyViaSBOVRSeqTest",
                 ovm_component parent = null);
      super.new (name, parent);
   endfunction : new

   //----------------
   // Build Function
   //----------------
   function void build ();
      super.build ();
   endfunction : build

   //----------
   // Run Task
   //----------
   task run ();
      i_DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq = DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq::type_id::create("DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq",this);
      `ovm_info (get_type_name(), "Running DfxSecurePlugin_DriveUserPolicyViaSBOVRSeqTest ...", OVM_MEDIUM);
      i_DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq.start (i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr);
      `ovm_info (get_type_name(), "DfxSecurePlugin_DriveUserPolicyViaSBOVRSeqTest Test Completed", OVM_MEDIUM);
      global_stop_request ();
   endtask : run

endclass : DfxSecurePlugin_DriveUserPolicyViaSBOVRSeqTest

`endif // INC_DfxSecurePlugin_TestLib
