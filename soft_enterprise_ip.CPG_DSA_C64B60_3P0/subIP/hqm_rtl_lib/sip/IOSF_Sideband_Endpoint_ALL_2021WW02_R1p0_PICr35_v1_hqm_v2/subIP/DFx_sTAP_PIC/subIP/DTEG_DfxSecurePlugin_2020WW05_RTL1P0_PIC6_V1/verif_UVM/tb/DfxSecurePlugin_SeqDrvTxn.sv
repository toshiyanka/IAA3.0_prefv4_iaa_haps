//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
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
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_SeqDrvTxn.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Packet (or Data item or Txn) between the Sequencer and Driver.
//    DESCRIPTION : This is the Packet between the Sequencer and the Driver. 
//                  The fields that are passed by the sequencer are:
//----------------------------------------------------------------------


`ifndef INC_DfxSecurePlugin_SeqDrvTxn
`define INC_DfxSecurePlugin_SeqDrvTxn

//-------------------
// Enum Declarations
//-------------------
typedef enum bit[3:0]  {
                 SECURITY_LOCKED                = 4'h0,
                 FUNCTIONALITY_LOCKED           = 4'h1,
                 SECURITY_UNLOCKED              = 4'h2,
                 FUSE_PROGRAMMING               = 4'h3,
                 INTEL_UNLOCKED                 = 4'h4,
                 OEM_UNLOCKED                   = 4'h5,
                 ENDEBUG_UNLOCKED               = 4'h6,
                 INFRARED_UNLOCKED             = 4'h7,
                 DRAMDEBUG_UNLOCKED            = 4'h8,
                 USER3_UNLOCKED                 = 4'h9,
                 USER4_UNLOCKED                 = 4'hA,
                 USER5_UNLOCKED                 = 4'hB,
                 USER6_UNLOCKED                 = 4'hC,
                 USER7_UNLOCKED                 = 4'hD,
                 USER8_UNLOCKED                 = 4'hE,
                 PART_DISABLED                  = 4'hF
               } Policy_t;

 typedef enum bit[4:0]  {
                 DEFAULT_MODE                   = 5'h10,
                 DRIVE_ALL_POLICIES             = 5'h11,
                 DRIVE_USER_POLICY              = 5'h1E,
                 SIDEBAND_POLICY                = 5'h1C,
                 POWERGOOD_RESET                = 5'h1F,
                 DRIVE_OEM_SECURE_POLICY_STRAP  = 5'h12,
                 DRIVE_FDFX_SECURE_POLICY       = 5'h13,
                 DRIVE_SB_POLICY_OVR_VALUE      = 5'h14,
                 DRIVE_FDFX_POLICY_UPDATE       = 5'h15,
                 DRIVE_FDFX_EARLYBOOT_EXIT      = 5'h16
               } UsageMode_t;
              
//-----------------
// Data Item Class
//-----------------
class DfxSecurePlugin_SeqDrvTxn #(`DSP_TB_PARAMS_DECL) extends uvm_sequence_item;

   //------------------
   // Class Properties
   //------------------

   // Mode of Operation
   rand UsageMode_t UsageMode;
   rand Policy_t    policy_value;
   rand reg [(TB_DFX_SECURE_WIDTH-1):0]                oem_secure_policy_strap_val_drv;
   rand reg [(TB_DFX_SECURE_WIDTH-1):0]                oem_secure_policy_const_val;
   rand reg [(TB_DFX_SECURE_WIDTH-1):0]                fdfx_secure_policy_val_drv;
   rand reg [(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1):0] sb_policy_ovr_val_drv;
   rand reg                                            fdfx_policy_update_val_drv;
   rand reg                                            fdfx_earlyboot_exit_val_drv;

   constraint ch_num { 
                      (TB_DFX_USE_SB_OVR == 1) ->
                      {
                        oem_secure_policy_const_val >= 7; 
                        oem_secure_policy_const_val < 15;
                      }
                      (TB_DFX_USE_SB_OVR == 0) ->
                      {
                        oem_secure_policy_const_val == 0; 
                      }
                     } 

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_SeqDrvTxn");

   //---------------------------------
   // Register component with Factory
   //---------------------------------
   `uvm_object_utils_begin (DfxSecurePlugin_SeqDrvTxn)
      `uvm_field_enum (UsageMode_t, UsageMode, UVM_ALL_ON)
      `uvm_field_int  (policy_value, UVM_ALL_ON + UVM_UNSIGNED)
      `uvm_field_int  (oem_secure_policy_strap_val_drv, UVM_ALL_ON + UVM_UNSIGNED)
      `uvm_field_int  (oem_secure_policy_const_val, UVM_ALL_ON + UVM_UNSIGNED)
      `uvm_field_int  (fdfx_secure_policy_val_drv, UVM_ALL_ON + UVM_UNSIGNED)
      `uvm_field_int  (sb_policy_ovr_val_drv, UVM_ALL_ON + UVM_UNSIGNED)
      `uvm_field_int  (fdfx_policy_update_val_drv, UVM_ALL_ON + UVM_UNSIGNED)
      `uvm_field_int  (fdfx_earlyboot_exit_val_drv, UVM_ALL_ON + UVM_UNSIGNED)
   `uvm_object_utils_end

endclass : DfxSecurePlugin_SeqDrvTxn

/***************************************************************
 * Standard UVM new function creates a new object 
 *  @param name : uvm name
 ***************************************************************/
function DfxSecurePlugin_SeqDrvTxn::new (string name = "DfxSecurePlugin_SeqDrvTxn");
   super.new (name);
endfunction : new

//TODO - add clone function
//TODO - eliminate the need for Parameters

`endif // INC_DfxSecurePlugin_SeqDrvTxn
