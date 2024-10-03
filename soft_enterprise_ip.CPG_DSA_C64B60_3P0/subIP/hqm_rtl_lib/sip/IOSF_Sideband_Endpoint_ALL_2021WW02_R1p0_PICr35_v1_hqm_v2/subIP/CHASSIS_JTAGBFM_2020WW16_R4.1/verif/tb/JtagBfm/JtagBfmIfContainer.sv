//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
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
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : JtagBfmIfContainer.sv
//    CREATED BY  : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : This encloses the DUT interface.
//    DESCRIPTION : Has a get and a set function to use the virtual 
//                  interface in different env components like Monitors
//                  and drivers.
//----------------------------------------------------------------------

`ifndef INC_JtagBfmIfContainer
`define INC_JtagBfmIfContainer

//-----------------------------------
// Virtual Interface Container Class
//-----------------------------------
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
class JtagBfmIfContainer #(type T = int) extends ovm_object;
`else    
class JtagBfmIfContainer extends ovm_object;
`endif
   
   //https://hsdes.intel.com/home/default.html#article?id=1503985289
   //Changed due to an error in SVTB Lintra Tool
   `ovm_object_utils(JtagBfmIfContainer)
   //--------------------------------------------
   // The virtual interface to drive DUT signals
   //--------------------------------------------
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
   protected T v_if;
`else    
   protected virtual JtagBfmIntf v_if;
`endif

   //----------------------
   // Constructor Function
   //----------------------
   function new (string name="JtagBfmIfContainer");
      super.new (name);
   endfunction : new

   //--------------------------------
   // Set Virtual Interface Function
   //--------------------------------
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
   virtual function void set_v_if (T virt_if);
`else    
   virtual function void set_v_if (virtual JtagBfmIntf virt_if);
`endif
     v_if = virt_if;
   endfunction : set_v_if

   //------------------------------------
   // Get Virtual Interface Function
   //------------------------------------
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
   virtual function T get_v_if ();
`else    
   virtual function virtual JtagBfmIntf get_v_if ();
`endif
      return (v_if);
   endfunction : get_v_if

   //----------------
   // Clone Function
   //----------------
   virtual function ovm_object clone ();
   `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
      JtagBfmIfContainer #(T) temp = new this;
   `else    
      JtagBfmIfContainer temp = new this;
   `endif
      clone = temp; //return(temp);
   endfunction : clone

endclass : JtagBfmIfContainer

`endif // INC_JtagBfmIfContainer
