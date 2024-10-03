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
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
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
//    FILENAME    : STapVifContainer.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : This encloses the DUT interface
//    DESCRIPTION : Has a get and a set function to use the virtual
//                  interface in different env components.
//-----------------------------------------------------------------------------

class STapVifContainer extends ovm_object;
  `include "ovm_macros.svh"

`ovm_object_utils(STapVifContainer)

   // Instance of DUT interface
   protected virtual stap_pin_if v_if;
   //protected virtual JtagBfmIntf PinIf;

   function new(string name="STapVifContainer");
      super.new(name);
   endfunction

   // Set virtual interface function
   //virtual function void set_v_if(virtual stap_pin_if virt_if,
   //                               virtual JtagBfmIntf virt_if_bfm);
   virtual function void set_v_if(virtual stap_pin_if virt_if);
      v_if = virt_if;
      //PinIf = virt_if_bfm;
   endfunction

   // Get virtual interface function
   virtual function virtual stap_pin_if get_v_if( );
      return(v_if);
   endfunction

   //virtual function virtual JtagBfmIntf get_v_if_bfm( );
   //   return(PinIf);
   //endfunction

   // Clone Function
   virtual function ovm_object clone ();
      STapVifContainer temp = new this;
      clone = temp;
   endfunction

endclass : STapVifContainer
