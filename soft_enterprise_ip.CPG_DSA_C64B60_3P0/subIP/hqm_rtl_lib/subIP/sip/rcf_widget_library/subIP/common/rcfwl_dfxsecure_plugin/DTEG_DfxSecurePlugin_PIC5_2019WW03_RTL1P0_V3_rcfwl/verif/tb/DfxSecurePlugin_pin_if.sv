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
//  DTEG_DfxSecurePlugin_PIC5_2019WW03_RTL1P0_V3
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
//    FILENAME    : DfxSecurePlugin_pin_if.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin 
//    PURPOSE     : Pin Interface for the ENV
//    DESCRIPTION : This is the pin interface for the environment.
//----------------------------------------------------------------------
//`include "tb_params.inc"

interface DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_DECL) (input tb_clk);


    //DFX Secure Plug in ports
    reg                                            fdfx_powergood;
    reg [(TB_DFX_SECURE_WIDTH - 1):0]              fdfx_secure_policy;
    reg                                            fdfx_earlyboot_exit;
    reg                                            fdfx_policy_update;
    reg [(TB_DFX_NUM_OF_FEATURES_TO_SECURE - 1):0] dfxsecure_feature_en;
    reg                                            visa_all_dis;
    reg                                            visa_customer_dis;
    reg [(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1):0] sb_policy_ovr_value;
    reg [(TB_DFX_SECURE_WIDTH - 1) : 0]            oem_secure_policy;

   //------------------------
   // Driver clocking blocks
   //------------------------
   clocking drv_cb_neg @ (negedge tb_clk);
      default input #0 output #0;
      output
         fdfx_earlyboot_exit,
         fdfx_policy_update,
         fdfx_secure_policy,
         sb_policy_ovr_value,
         oem_secure_policy;
   endclocking : drv_cb_neg

   clocking mon_cb @ (posedge tb_clk);
      default input #1;
      input
         fdfx_earlyboot_exit,
         fdfx_policy_update,
         fdfx_secure_policy,
         sb_policy_ovr_value,
         oem_secure_policy;
   endclocking : mon_cb

endinterface
