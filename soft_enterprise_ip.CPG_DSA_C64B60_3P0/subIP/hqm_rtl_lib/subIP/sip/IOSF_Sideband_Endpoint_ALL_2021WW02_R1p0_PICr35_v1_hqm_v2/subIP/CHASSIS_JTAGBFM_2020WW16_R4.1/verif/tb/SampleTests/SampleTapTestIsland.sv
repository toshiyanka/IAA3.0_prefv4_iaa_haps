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
//    FILENAME    : TapTop.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//
//
//    PURPOSE     : Top file of the ENV
//    DESCRIPTION : Instantiates and connects the Program block and the
//                  DUT and the Clock Gen module
//----------------------------------------------------------------------

module TapTestIsland #(parameter TAPNWVIF = "*", 
                                 PRI_JTAGBFMVIF = "*", 
                                 SEC_JTAGBFMVIF = "*", 
                                 TER0_JTAGBFMVIF = "*",
                                 TER1_JTAGBFMVIF = "*")(
                     JtagBfmIntf Primary_if,
                     JtagBfmIntf Secondary_if,
                     JtagBfmIntf Teritiary0_if,
                     JtagBfmIntf Teritiary1_if
                    );

   import TapPkg::*;
   import ovm_pkg::*;
   import JtagBfmPkg::*;

   sla_vif_container #(virtual JtagBfmIntf) vif_container;

   initial begin
      // Connect the system core clock signal to the sla_tb_env for running task set_clk_rst in TapEnv.
      // Hence no need for secondary_if here.
      vif_container = new ();
      vif_container.set_v_if(Primary_if);
      set_config_object(TAPNWVIF, "V_JTAGBFM_PIN_IF", vif_container,0);
   end

   // Instatitate the SubIP's TestIslands.

   //JtagBfmTestIsland  pri_JtagBfmTestIsland(Primary_if);
   JtagBfmTestIsland #(.TAPVIF("ovm_test_top.Env.PriMasterAgent.*"), `SOC_PRI_JTAG_IF_PARAMS_INST) pri_JtagBfmTestIsland(Primary_if);
   JtagBfmTestIsland #(.TAPVIF("ovm_test_top.Env.SecMasterAgent.*"), `SOC_SEC_JTAG_IF_PARAMS_INST) sec_JtagBfmTestIsland(Secondary_if);
   JtagBfmTestIsland #(.TAPVIF("ovm_test_top.Env.Ter0MasterAgent.*"), `SOC_TR0_JTAG_IF_PARAMS_INST) ter0_JtagBfmTestIsland(Teritiary0_if);
   JtagBfmTestIsland #(.TAPVIF("ovm_test_top.Env.Ter1MasterAgent.*"), `SOC_TR1_JTAG_IF_PARAMS_INST) ter1_JtagBfmTestIsland(Teritiary1_if);

   // Set the hierarchy for the interface string so that it is unique.
   // Fix for HSD4256873
   //defparam pri_JtagBfmTestIsland.TAPVIF = "ovm_test_top.Env.PriMasterAgent.*";
   //defparam sec_JtagBfmTestIsland.TAPVIF = "ovm_test_top.Env.SecMasterAgent.*";
   //defparam ter_JtagBfmTestIsland.TAPVIF = "ovm_test_top.Env.TerMasterAgent.*";
  // defparam pri_JtagBfmTestIsland.TAPVIF = PRI_JTAGBFMVIF;
   defparam sec_JtagBfmTestIsland.TAPVIF = SEC_JTAGBFMVIF;
   defparam ter0_JtagBfmTestIsland.TAPVIF = TER0_JTAGBFMVIF;
   defparam ter1_JtagBfmTestIsland.TAPVIF = TER1_JTAGBFMVIF;

endmodule
