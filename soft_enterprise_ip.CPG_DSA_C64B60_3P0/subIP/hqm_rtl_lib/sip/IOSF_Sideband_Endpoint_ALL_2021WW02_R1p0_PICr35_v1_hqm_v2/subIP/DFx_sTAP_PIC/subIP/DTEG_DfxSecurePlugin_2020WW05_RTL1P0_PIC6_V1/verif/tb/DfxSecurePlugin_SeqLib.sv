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
//  dteg-dfxsecure_plugin
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_DfxSecurePlugin_2020WW04_RTL1P0_PIC6_V1
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
//    FILENAME    : DfxSecurePlugin_SeqLib.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Sequence Library for the DfxSecurePlugin Transactions.
//    DESCRIPTION : This component defines various sequences applied to DfxSecurePlugin.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_SeqLib
`define INC_DfxSecurePlugin_SeqLib

//class DfxSecurePlugin_BaseSeq #(`DSP_TB_PARAMS_DECL) extends ovm_sequence #(ovm_sequence_item);
class DfxSecurePlugin_BaseSeq #(`DSP_TB_PARAMS_DECL) extends ovm_sequence;

   //----------------------------
   // Binding with the sequencer
   `ovm_sequence_utils (DfxSecurePlugin_BaseSeq, DfxSecurePlugin_Seqr)

   //-----------
   // Data Item
   DfxSecurePlugin_SeqDrvTxn i_DfxSecurePlugin_DefTxn;

   //--------------
   // New Function
   function new (string name = "DfxSecurePlugin_BaseSeq");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   virtual task body ();
      string msg;
      $swrite (msg, "Executing a sequence called %s", get_name());
      `ovm_info (get_type_name(), msg, OVM_LOW);
      `ovm_do_with (i_DfxSecurePlugin_DefTxn, {UsageMode == DEFAULT_MODE;});
      get_response(rsp);
   endtask : body

   //------------------------------------------
   //  DriveDfxSecurePolicy task
   //------------------------------------------    
   task DriveDfxSecurePolicy(input [(TB_DFX_SECURE_WIDTH - 1):0] policy);
       begin
           bit [(TB_DFX_SECURE_WIDTH - 1):0] fdfx_secure_policy = policy;


           `ovm_do_with(i_DfxSecurePlugin_DefTxn, {i_DfxSecurePlugin_DefTxn.UsageMode    == DRIVE_USER_POLICY;
                                                   i_DfxSecurePlugin_DefTxn.policy_value == fdfx_secure_policy;})
           get_response(rsp);                      
       end
   endtask : DriveDfxSecurePolicy

   //------------------------------------------
   //  DriveOemSecurePolicyStrap task
   //------------------------------------------    
   task DriveOemSecurePolicyStrap (input [(TB_DFX_SECURE_WIDTH - 1):0] policy);
       begin
           bit [(TB_DFX_SECURE_WIDTH - 1):0] oem_secure_policy = policy;

           `ovm_do_with(i_DfxSecurePlugin_DefTxn, {i_DfxSecurePlugin_DefTxn.UsageMode                       == DRIVE_OEM_SECURE_POLICY_STRAP;
                                                   i_DfxSecurePlugin_DefTxn.oem_secure_policy_strap_val_drv == oem_secure_policy;})
           get_response(rsp);                      
       end
   endtask : DriveOemSecurePolicyStrap

   //------------------------------------------
   //  DriveFdfxSecurePolicy task
   //------------------------------------------    
   task DriveFdfxSecurePolicy (input [(TB_DFX_SECURE_WIDTH - 1):0] policy);
       begin
           bit [(TB_DFX_SECURE_WIDTH - 1):0] fdfx_secure_policy = policy;

           `ovm_do_with(i_DfxSecurePlugin_DefTxn, {i_DfxSecurePlugin_DefTxn.UsageMode                  == DRIVE_FDFX_SECURE_POLICY;
                                                   i_DfxSecurePlugin_DefTxn.fdfx_secure_policy_val_drv == fdfx_secure_policy;})
           get_response(rsp);                      
       end
   endtask : DriveFdfxSecurePolicy

   //------------------------------------------
   //  DriveSbPolicyOvrValue task
   //------------------------------------------    
   task DriveSbPolicyOvrValue (input [(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1):0] policy);
       begin
           bit [(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1):0] sb_policy_ovr_value = policy;

           `ovm_do_with(i_DfxSecurePlugin_DefTxn, {i_DfxSecurePlugin_DefTxn.UsageMode             == DRIVE_SB_POLICY_OVR_VALUE;
                                                   i_DfxSecurePlugin_DefTxn.sb_policy_ovr_val_drv == sb_policy_ovr_value;})
           get_response(rsp);                      
       end
   endtask : DriveSbPolicyOvrValue

   //------------------------------------------
   //  DriveFdfxPolicyUpdate task
   //------------------------------------------    
   task DriveFdfxPolicyUpdate (input policy_update);
       begin
           bit fdfx_policy_update = policy_update;

           `ovm_do_with(i_DfxSecurePlugin_DefTxn, {i_DfxSecurePlugin_DefTxn.UsageMode                  == DRIVE_FDFX_POLICY_UPDATE;
                                                   i_DfxSecurePlugin_DefTxn.fdfx_policy_update_val_drv == fdfx_policy_update;})
           get_response(rsp);                      
       end
   endtask : DriveFdfxPolicyUpdate

   //------------------------------------------
   //  DriveFdfxEarlybootExit task
   //------------------------------------------    
   task DriveFdfxEarlybootExit (input earlyboot_exit);
       begin
           bit fdfx_earlyboot_exit = earlyboot_exit;

           `ovm_do_with(i_DfxSecurePlugin_DefTxn, {i_DfxSecurePlugin_DefTxn.UsageMode                   == DRIVE_FDFX_EARLYBOOT_EXIT;
                                                   i_DfxSecurePlugin_DefTxn.fdfx_earlyboot_exit_val_drv == fdfx_earlyboot_exit;})
           get_response(rsp);                      
       end
   endtask : DriveFdfxEarlybootExit

   //------------------------------------------
   //  DrivePowergood task
   //------------------------------------------    
   task Powergood_Reset;
       begin
           `ovm_do_with(i_DfxSecurePlugin_DefTxn, {i_DfxSecurePlugin_DefTxn.UsageMode    == POWERGOOD_RESET;})
           get_response(rsp);                      
       end
   endtask : Powergood_Reset

endclass : DfxSecurePlugin_BaseSeq

/*****************************************************************************************/
class DfxSecurePlugin_DrivePowerGoodSeq #(`DSP_TB_PARAMS_DECL) extends DfxSecurePlugin_BaseSeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (DfxSecurePlugin_DrivePowerGoodSeq, DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DrivePowerGoodSeq");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
      string msg;
      $swrite (msg, "Executing a sequence called %s", get_name()); `ovm_info (get_type_name(), msg, OVM_LOW);
       Powergood_Reset;
   endtask : body

endclass : DfxSecurePlugin_DrivePowerGoodSeq

/*****************************************************************************************/
class DfxSecurePlugin_DriveUserPolicySeq #(`DSP_TB_PARAMS_DECL) extends DfxSecurePlugin_BaseSeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (DfxSecurePlugin_DriveUserPolicySeq, DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DriveUserPolicySeq");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
      string msg;
      $swrite (msg, "Executing a sequence called %s", get_name());
      `ovm_info (get_type_name(), msg, OVM_LOW);
       Powergood_Reset;
       DriveDfxSecurePolicy(SECURITY_LOCKED);
       DriveDfxSecurePolicy(SECURITY_UNLOCKED);
       DriveDfxSecurePolicy(USER7_UNLOCKED);
       DriveDfxSecurePolicy(FUNCTIONALITY_LOCKED);
       DriveDfxSecurePolicy(FUSE_PROGRAMMING);
       DriveDfxSecurePolicy(INTEL_UNLOCKED);
       DriveDfxSecurePolicy(OEM_UNLOCKED);
       DriveDfxSecurePolicy(ENDEBUG_UNLOCKED);
       DriveDfxSecurePolicy(INFRARED_UNLOCKED);
       DriveDfxSecurePolicy(DRAMDEBUG_UNLOCKED);
       DriveDfxSecurePolicy(USER3_UNLOCKED);
       DriveDfxSecurePolicy(USER4_UNLOCKED);
       DriveDfxSecurePolicy(USER5_UNLOCKED);
       DriveDfxSecurePolicy(USER6_UNLOCKED);
       DriveDfxSecurePolicy(USER8_UNLOCKED);
       DriveDfxSecurePolicy(PART_DISABLED);
   endtask : body

endclass : DfxSecurePlugin_DriveUserPolicySeq

/*****************************************************************************************/
class DfxSecurePlugin_DriveAllUserInputSeq #(`DSP_TB_PARAMS_DECL) extends DfxSecurePlugin_BaseSeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (DfxSecurePlugin_DriveAllUserInputSeq, DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DriveAllUserInputSeq");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
      string msg;
      $swrite (msg, "Executing a sequence called %s", get_name());
      `ovm_info (get_type_name(), msg, OVM_LOW);
       Powergood_Reset;
       DriveOemSecurePolicyStrap(INFRARED_UNLOCKED);
       DriveFdfxSecurePolicy(INFRARED_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
       DriveOemSecurePolicyStrap(DRAMDEBUG_UNLOCKED);
       DriveFdfxSecurePolicy(DRAMDEBUG_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
       DriveOemSecurePolicyStrap(USER3_UNLOCKED);
       DriveFdfxSecurePolicy(USER3_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
       DriveOemSecurePolicyStrap(USER4_UNLOCKED);
       DriveFdfxSecurePolicy(USER4_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
       DriveOemSecurePolicyStrap(USER5_UNLOCKED);
       DriveFdfxSecurePolicy(USER5_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
       DriveOemSecurePolicyStrap(USER6_UNLOCKED);
       DriveFdfxSecurePolicy(USER6_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
       DriveOemSecurePolicyStrap(USER7_UNLOCKED);
       DriveFdfxSecurePolicy(USER7_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
       DriveOemSecurePolicyStrap(USER8_UNLOCKED);
       DriveFdfxSecurePolicy(USER8_UNLOCKED);
       DriveSbPolicyOvrValue($urandom_range(0, ((2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1)));
       DriveFdfxPolicyUpdate(1'b1);
       DriveFdfxEarlybootExit(1'b1);
   endtask : body

endclass : DfxSecurePlugin_DriveAllUserInputSeq

/*****************************************************************************************/
class DfxSecurePlugin_PolicySweepSeq extends ovm_sequence #(ovm_sequence_item);

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (DfxSecurePlugin_PolicySweepSeq, DfxSecurePlugin_Seqr)

   //-----------
   // Data Item
   //-----------
   DfxSecurePlugin_SeqDrvTxn i_DfxSecurePlugin_TestTxn;

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_PolicySweepSeq");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
      string msg;
      $swrite (msg, "Executing a sequence called %s", get_name());
      `ovm_info (get_type_name(), msg, OVM_LOW);
      `ovm_do_with (i_DfxSecurePlugin_TestTxn, {UsageMode == DRIVE_ALL_POLICIES;});
      get_response(rsp);
   endtask : body

endclass : DfxSecurePlugin_PolicySweepSeq

/*****************************************************************************************/
class DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq extends ovm_sequence #(ovm_sequence_item);

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq, DfxSecurePlugin_Seqr)

   //-----------
   // Data Item
   //-----------
   DfxSecurePlugin_SeqDrvTxn i_DfxSecurePlugin_SidebandTxn;

   //--------------
   // New Function
   //--------------
   function new (string name = "DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
      string msg;
      $swrite (msg, "Executing a sequence called %s", get_name());
      `ovm_info (get_type_name(), msg, OVM_LOW);
      `ovm_do_with (i_DfxSecurePlugin_SidebandTxn, {UsageMode == SIDEBAND_POLICY;});
   endtask : body

endclass : DfxSecurePlugin_DriveUserPolicyViaSBOVRSeq

`endif // INC_DfxSecurePlugin_SeqLib
