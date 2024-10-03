//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
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
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2020WW22_PICr33
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapVifContainer.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : The UVM ENV file for the sTAP 
//    DESCRIPTION : Instantiation  and connection of the MasterAgent;
//                  ScoreBoard; Coverage and the output monitor. Also the
//                  configurable parameter like quit count are set here.
//-----------------------------------------------------------------------------

//-----------------------------------
// Virtual Interface Container Class
//-----------------------------------
class TapVifContainer extends uvm_object;

   //--------------------------------------------
   // The virtual interface to drive DUT signals
   //--------------------------------------------
   protected virtual Control_IF tapnw_ctl_vif;

   //----------------------
   // Constructor Function
   //----------------------
   function new(string name="TapVifContainer");
      super.new(name);
   endfunction

   //--------------------------------
   // Set Virtual Interface Function
   //--------------------------------
   virtual function void set_tapnw_vif (virtual Control_IF tapnw_ctl_vif);
      this.tapnw_ctl_vif = tapnw_ctl_vif;
   endfunction : set_tapnw_vif

   //------------------------------------
   // Get TAPNW Control Interface Function
   //------------------------------------
   virtual function virtual Control_IF get_tapnw_ctl_vif ();
      return (tapnw_ctl_vif);
   endfunction : get_tapnw_ctl_vif

   //----------------
   // Clone Function
   //----------------
   virtual function uvm_object clone ();
      TapVifContainer temp = new this;
      clone = temp;
   endfunction : clone

endclass : TapVifContainer

