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
//    FILENAME    : DfxSecurePlugin_Seqr.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Sequencer Component for the UVM ENV
//    DESCRIPTION : The sequencer takes a sequence as input, grabs a transaction at a
//                  time and passes it to a driver for execution.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Seqr
`define INC_DfxSecurePlugin_Seqr

//-----------------
// Sequencer Class
//-----------------
class DfxSecurePlugin_Seqr extends uvm_sequencer;

   //-------------------------------------
   // Register component with the factory
   //-------------------------------------
   `uvm_component_utils (DfxSecurePlugin_Seqr)

   //----------------------
   // Constructor Function
   //----------------------
   function new (string name = "DfxSecurePlugin_Seqr",
                 uvm_component parent = null);
      super.new (name, parent);
      // -*- association seqr-seq has changed `uvm_update_sequence_lib_and_item (DfxSecurePlugin_SeqDrvTxn#())
   endfunction : new
 
endclass : DfxSecurePlugin_Seqr

`endif // INC_DfxSecurePlugin_Seqr
