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
//    FILENAME    : DfxSecurePlugin_TbTop.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//
//    PURPOSE     : Top file of the ENV
//    DESCRIPTION : Instantiates and connects the Program block and the
//                  DUT and the Clock Gen module
//----------------------------------------------------------------------

`include "DFXSECURE_dfxsecureplugin_param_values.vh"

module DfxSecurePlugin_Tbtop #(`DSP_TB_PARAMS_DECL) ();
    
    reg soc_clock;
    
    DfxSecurePlugin_ClkGen #(TB_CLK_PERIOD) i_DfxSecurePlugin_ClkGen (soc_clock);

    //------------------
    // Instatiate the Interface
    //------------------
    DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_INST) pif(soc_clock);

    //------------------
    // Instatiate the Test Island
    //------------------
    DfxSecurePlugin_TestIsland #(`DSP_TB_PARAMS_INST, `include "DFXSECURE_dfxsecureplugin_param_overide.vh") i_DfxSecurePlugin_TestIsland(pif);

    defparam i_DfxSecurePlugin_TestIsland.DFXSECUREPLUGINVIF    = "ovm_test_top.i_DfxSecurePlugin_Env*";

    //------------------
    // Instatiate the DUT
    //------------------
    dfxsecure_plugin #(`include "DFXSECURE_dfxsecureplugin_param_overide.vh")
    dfxsecure_top_inst
       (
         .fdfx_powergood       (pif.fdfx_powergood),
         .fdfx_secure_policy   (pif.fdfx_secure_policy),
         .fdfx_earlyboot_exit  (pif.fdfx_earlyboot_exit),
         .fdfx_policy_update   (pif.fdfx_policy_update),
         .dfxsecure_feature_en (pif.dfxsecure_feature_en),
         .visa_all_dis         (pif.visa_all_dis),
         .visa_customer_dis    (pif.visa_customer_dis),
         .sb_policy_ovr_value  (pif.sb_policy_ovr_value),
         .oem_secure_policy    (pif.oem_secure_policy)
       );

    //------------------
    // Instantiate Program Block
    //------------------
    DfxSecurePlugin_Test i_DfxSecurePlugin_Test();

    //--------------------------------------------
    // ACE needs this for dumping FSDB
    //--------------------------------------------

   initial begin : VCD_BLOCK
      if (($test$plusargs("DUMP_VCD")) || ($test$plusargs("VCD"))) begin
         $display("Dump in VCD format ENABLED");
         $vcdplusfile("Dump.vcd");
            $vcdpluson(0,DfxSecurePlugin_Tbtop);
      end
   end : VCD_BLOCK

   initial begin : VPD_BLOCK
      if (($test$plusargs("DUMP_VPD")) || ($test$plusargs("VPD"))) begin
         $display("Dump in VPD format ENABLED");
         $vcdplusfile("Dump.vpd");
            $vcdpluson(0,DfxSecurePlugin_Tbtop);
      end
   end : VPD_BLOCK

   initial begin : FSDB_BLOCK
      if (($test$plusargs("DUMP")) || ($test$plusargs("FSDB"))) begin
         $display("Dump ENABLED");
         $fsdbDumpfile("Dump.fsdb");
         $fsdbDumpSVAon; 
         `ifdef POWERVCD
         $fsdbDumpvars(dfxsecure_plugin,"+all");
         `else
         $fsdbDumpvars("+all");
         `endif
       $fsdbDumpSVAoff;
      end
   end : FSDB_BLOCK

endmodule 
