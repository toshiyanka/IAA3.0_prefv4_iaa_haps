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
//    FILENAME    : TapTop.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : Top file of the ENV
//    DESCRIPTION : Instantiates and connects the Program block and the
//                  DUT and the Clock Gen module
//----------------------------------------------------------------------

module TapTestIsland(
                     JtagBfmIntf Primary_if,
                     JtagBfmIntf Secondary_if,
                     Control_IF  Control_if
                    );

   import TapPkg::*;
   import ovm_pkg::*;
   import JtagBfmPkg::*;

   TapVifContainer                          i_TapVifContainer;
   //sla_vif_container #(virtual JtagBfmIntf)     vif_container;
   JtagBfmIfContainer #(virtual JtagBfmIntf)     vif_container;

   initial begin
      // Set the Control_if which is part of tapnw_pin_if 
      i_TapVifContainer = new ();
      i_TapVifContainer.set_tapnw_vif(Control_if);
      set_config_object ("*", "V_TAPNW_PINIF", i_TapVifContainer,0);

      // Connect the system core clock signal to the sla_tb_env for running task set_clk_rst in TapEnv. 
      // Hence no need for secondary_if here.
      vif_container = new ();
      vif_container.set_v_if(Primary_if);
      set_config_object("ovm_test_top.Env", "V_JTAGBFM_PIN_IF", vif_container,0);
   end

   // Instatitate the SubIP's TestIslands.
   JtagBfmTestIsland  pri_JtagBfmTestIsland(Primary_if);  
   JtagBfmTestIsland  sec_JtagBfmTestIsland(Secondary_if);  

   // Set the hierarchy for the interface string so that it is unique.
   defparam pri_JtagBfmTestIsland.TAPVIF = "ovm_test_top.Env.PriMasterAgent.*";
   defparam sec_JtagBfmTestIsland.TAPVIF = "ovm_test_top.Env.SecMasterAgent.*";

endmodule
