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
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_TestIsland.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Test Island for the OVM ENV
//    DESCRIPTION : This module sets the interfaces and is instantiated
//                  in the DfxSecurePlugin_TbTop
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_TestIsland
`define INC_DfxSecurePlugin_TestIsland

`include "DfxSecurePlugin_TbDefines.svh"
`define DFX_SECURE_PLUGIN_PIF i_DfxSecurePlugin_pin_if
//--------------------
// Test Island Module
//--------------------
module DfxSecurePlugin_TestIsland #(DFXSECUREPLUGINVIF = "*",
                                    `DSP_TB_PARAMS_DECL,
                                    `include "dsp_tb_params.vh"
                                   )
                                   (DfxSecurePlugin_pin_if `DFX_SECURE_PLUGIN_PIF);

   //`include "DFXSECURE_dfxsecureplugin_param_values.vh"

   //----------------------------------------
   // Importing OVM Package and SAOLA Package
   //----------------------------------------
   import ovm_pkg::*;
   import DfxSecurePlugin_Pkg::*;

   //------------------------
   // VIF Container instance
   //------------------------
   DfxSecurePlugin_VifContainer #(`DSP_TB_PARAMS_INST) vif_container;

   //---------------------------------------------
   // Setting virtual interface to ENV components
   //---------------------------------------------
   initial
   begin
      vif_container = new ();
      vif_container.set_v_if (`DFX_SECURE_PLUGIN_PIF);
      set_config_object (DFXSECUREPLUGINVIF, "V_DFXSECPLUGIN_VIF", vif_container, 0);
   end

   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   `ifndef INTEL_SVA_OFF

      //---------------------------------------------
      SECURE_POLICY_CHECK_BEFORE_EARLYBOOTEXIT: 
      assert property 
         ( @(posedge `DFX_SECURE_PLUGIN_PIF.tb_clk)
         
           disable iff (`DFX_SECURE_PLUGIN_PIF.fdfx_powergood !== HIGH)  

           (`DFX_SECURE_PLUGIN_PIF.fdfx_earlyboot_exit == LOW) |-> 
                 (  {`DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                     `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                     `DFX_SECURE_PLUGIN_PIF.visa_customer_dis} == DFX_EARLYBOOT_FEATURE_ENABLE
                 )
          )
 	   else $error("EARLYBOOT EXIT Violation: \n",  
                  "   dfxsecure_feature_en = %0b\n", `DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                  "   visa_all_dis         = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                  "   visa_customer_dis    = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_customer_dis
                 );

      //---------------------------------------------
      generate
         if (DFX_USE_SB_OVR == 1) begin
            for (genvar j = 0; j < 2 ** DFX_SECURE_WIDTH; j++) begin: policy_checker_use1

               SECURE_POLICY_CHECK_WHEN_USE_SB_1_OEM_MATCHES_POLICY: 
               assert property 
                  ( @(posedge `DFX_SECURE_PLUGIN_PIF.tb_clk)
                  
                    disable iff (`DFX_SECURE_PLUGIN_PIF.fdfx_powergood !== HIGH)  

                    ((`DFX_SECURE_PLUGIN_PIF.fdfx_secure_policy[(DFX_SECURE_WIDTH - 1):0] == j) && 
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_earlyboot_exit == HIGH) &&
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_policy_update  == HIGH) &&
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_secure_policy[(DFX_SECURE_WIDTH - 1):0] == 
                       `DFX_SECURE_PLUGIN_PIF.oem_secure_policy[(DFX_SECURE_WIDTH - 1):0])
                    ) |-> 
                          (  {`DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                              `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                              `DFX_SECURE_PLUGIN_PIF.visa_customer_dis} == 
                              
                              `DFX_SECURE_PLUGIN_PIF.sb_policy_ovr_value 
                          )
                   )
 	            else $error("SECURE_POLICY_%0h Violation: \n", j,  
                           "   sb_policy_ovr_value  = %0b\n", `DFX_SECURE_PLUGIN_PIF.sb_policy_ovr_value,
                           "   dfxsecure_feature_en = %0b\n", `DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                           "   visa_all_dis         = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                           "   visa_customer_dis    = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_customer_dis
                          );

               SECURE_POLICY_CHECK_WHEN_USE_SB_1_OEM_NOTMATCHES_POLICY: 
               assert property 
                  ( @(posedge `DFX_SECURE_PLUGIN_PIF.tb_clk)
                  
                    disable iff (`DFX_SECURE_PLUGIN_PIF.fdfx_powergood !== HIGH)  

                    ((`DFX_SECURE_PLUGIN_PIF.fdfx_secure_policy[(DFX_SECURE_WIDTH - 1):0] == j) && 
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_earlyboot_exit == HIGH) &&
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_policy_update  == HIGH) &&
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_secure_policy[(DFX_SECURE_WIDTH - 1):0] != 
                       `DFX_SECURE_PLUGIN_PIF.oem_secure_policy[(DFX_SECURE_WIDTH - 1):0])
                    ) |-> 
                          (  {`DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                              `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                              `DFX_SECURE_PLUGIN_PIF.visa_customer_dis} == 
                              
                              DFX_SECURE_POLICY_MATRIX[( ((j+1) * (DFX_NUM_OF_FEATURES_TO_SECURE + 2)) - 1) : 
                                                       (  (j)   * (DFX_NUM_OF_FEATURES_TO_SECURE + 2)     )
                                                      ] 
                          )
                   )
 	            else $error("SECURE_POLICY_%0h Violation: \n", j,  
                           "   dfxsecure_feature_en = %0b\n", `DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                           "   visa_all_dis         = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                           "   visa_customer_dis    = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_customer_dis
                          );
            end // for loop
         end // begin
      endgenerate

      //---------------------------------------------
      generate
         if (DFX_USE_SB_OVR == 0) begin
            for (genvar k = 0; k < 2 ** DFX_SECURE_WIDTH; k++) begin: policy_checker_use0

               SECURE_POLICY_CHECK_AFTER_EARLYBOOTEXIT_USE_SB_0: 
               assert property 
                  ( @(posedge `DFX_SECURE_PLUGIN_PIF.tb_clk)
                  
                    disable iff (`DFX_SECURE_PLUGIN_PIF.fdfx_powergood !== HIGH)  

                    ((`DFX_SECURE_PLUGIN_PIF.fdfx_secure_policy[(DFX_SECURE_WIDTH - 1):0] == k) && 
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_earlyboot_exit == HIGH) &&
                     (`DFX_SECURE_PLUGIN_PIF.fdfx_policy_update  == HIGH) 
                    ) |-> 
                          (  {`DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                              `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                              `DFX_SECURE_PLUGIN_PIF.visa_customer_dis} == 
                              
                              DFX_SECURE_POLICY_MATRIX[( ((k+1) * (DFX_NUM_OF_FEATURES_TO_SECURE + 2)) - 1) : 
                                                       (  (k)   * (DFX_NUM_OF_FEATURES_TO_SECURE + 2)     )
                                                      ] 
                          )
                   )
 	            else $error("SECURE_POLICY_%0h Violation: \n", k,  
                           "   dfxsecure_feature_en = %0b\n", `DFX_SECURE_PLUGIN_PIF.dfxsecure_feature_en,
                           "   visa_all_dis         = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_all_dis,
                           "   visa_customer_dis    = %0b\n", `DFX_SECURE_PLUGIN_PIF.visa_customer_dis
                          );

            end // for loop
         end // begin
      endgenerate

      //---------------------------------------------
   `endif

endmodule : DfxSecurePlugin_TestIsland

`endif // INC_DfxSecurePlugin_TestIsland
