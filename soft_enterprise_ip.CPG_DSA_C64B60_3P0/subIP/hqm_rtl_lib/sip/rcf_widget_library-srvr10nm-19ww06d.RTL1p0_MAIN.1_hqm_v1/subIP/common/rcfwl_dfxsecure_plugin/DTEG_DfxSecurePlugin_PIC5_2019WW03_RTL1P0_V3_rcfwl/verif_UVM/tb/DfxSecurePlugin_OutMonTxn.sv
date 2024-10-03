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
class DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_DECL) extends uvm_sequence_item;

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
   `uvm_object_param_utils_begin (DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_INST))
      `uvm_field_int (dfxsecure_feature_en, UVM_ALL_ON)
      `uvm_field_int (visa_all_dis, UVM_ALL_ON)
      `uvm_field_int (visa_customer_dis, UVM_ALL_ON)
   `uvm_object_utils_end

endclass : DfxSecurePlugin_OutMonTxn

/***************************************************************
 * Standard UVM new function creates a new object 
 *  @param name : uvm name
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
