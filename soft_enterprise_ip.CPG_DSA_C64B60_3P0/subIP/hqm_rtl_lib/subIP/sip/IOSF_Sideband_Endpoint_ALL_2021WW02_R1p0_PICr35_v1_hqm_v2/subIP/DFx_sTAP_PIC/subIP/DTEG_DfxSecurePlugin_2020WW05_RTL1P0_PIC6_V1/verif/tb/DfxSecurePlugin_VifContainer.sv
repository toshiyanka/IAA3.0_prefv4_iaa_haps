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
//    FILENAME    : DfxSecurePlugin_VifContainer.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : This encloses the DUT interface.
//    DESCRIPTION : Has a get and a set function to use the virtual 
//                  interface in different env components like Monitors
//                  and drivers.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_VifContainer
`define INC_DfxSecurePlugin_VifContainer

//-----------------------------------
// Virtual Interface Container Class
//-----------------------------------
class DfxSecurePlugin_VifContainer #(`DSP_TB_PARAMS_DECL) extends ovm_object;

   //--------------------------------------------
   // The virtual interface to drive DUT signals
   //--------------------------------------------
   protected virtual DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_pin_if;
   
   //`ovm_object_param_utils(DfxSecurePlugin_VifContainer#(`DSP_TB_PARAMS_DECL))
   `ovm_object_utils(DfxSecurePlugin_VifContainer)
   //----------------------
   // Constructor Function
   //----------------------
   function new (string name="DfxSecurePlugin_VifContainer");
      super.new (name);
   endfunction : new

   //--------------------------------
   // Set Virtual Interface Function
   //--------------------------------
   virtual function void set_v_if (virtual DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_INST) ii_DfxSecurePlugin_pin_if);
      this.i_DfxSecurePlugin_pin_if = ii_DfxSecurePlugin_pin_if;
   endfunction : set_v_if

   //------------------------------------
   // Get TAP Primary Interface Function
   //------------------------------------
   virtual function virtual DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_INST) get_v_if ();
      return (i_DfxSecurePlugin_pin_if);
   endfunction : get_v_if

   //----------------
   // Clone Function
   //----------------
   virtual function ovm_object clone ();
      DfxSecurePlugin_VifContainer #(`DSP_TB_PARAMS_INST) temp = new this;
      clone = temp; //return(temp);
   endfunction : clone

endclass : DfxSecurePlugin_VifContainer

`endif // INC_DfxSecurePlugin_VifContainer
