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
//    FILENAME    : DfxSecurePlugin_OutMonTxn.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Packet (or Data item or Txn) between the Outut Monitor and Scoreboard.
//    DESCRIPTION : The fields that are passed by the sequencer are:
//----------------------------------------------------------------------


`ifndef INC_DfxSecurePlugin_OutMonTxn
`define INC_DfxSecurePlugin_OutMonTxn

//-----------------
// Data Item Class
//-----------------
class DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_DECL) extends ovm_sequence_item;

   //------------------
   // Class Properties
   //------------------
   logic [(TB_DFX_NUM_OF_FEATURES_TO_SECURE - 1):0] dfxsecure_feature_en;
   logic                                            visa_all_dis;
   logic                                            visa_customer_dis;

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_OutMonTxn");
   // extern function DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_INST) clone ();

   //---------------------------------
   // Register component with Factory
   //---------------------------------
   `ovm_object_param_utils_begin (DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_INST))
      `ovm_field_int (dfxsecure_feature_en, OVM_ALL_ON)
      `ovm_field_int (visa_all_dis, OVM_ALL_ON)
      `ovm_field_int (visa_customer_dis, OVM_ALL_ON)
   `ovm_object_utils_end

endclass : DfxSecurePlugin_OutMonTxn

/***************************************************************
 * Standard OVM new function creates a new object 
 *  @param name : ovm name
 ***************************************************************/
function DfxSecurePlugin_OutMonTxn::new (string name = "DfxSecurePlugin_OutMonTxn");
   super.new (name);
endfunction : new

/***************************************************************
 * Clone Function to create and copy this object
 ***************************************************************/
//function DfxSecurePlugin_OutMonTxn DfxSecurePlugin_OutMonTxn::clone ();
//   DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_OutMonTxn= new this;
//   clone = i_DfxSecurePlugin_OutMonTxn;
//endfunction : clone

`endif // INC_DfxSecurePlugin_OutMonTxn
