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
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_dfxsecure.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP DFx Secure Logic
//    DESCRIPTION :
//       This module implements the DFx Secure Logic as explained in HAS
//    PARAMETERS  :
//    DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE
//       This value defines the number of feature that can be implemented
//       in DFx Secure Block
//    DFXSECURE_STAP_DFX_SECURE_WIDTH
//       This value defines the width of DFx Secure Input
//----------------------------------------------------------------------
module stap_dfxsecure
   #(
   parameter DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE = 2,
   parameter DFXSECURE_STAP_DFX_SECURE_WIDTH                 = 2
   )
   (
   input  logic [(DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 1):0]
                [DFXSECURE_STAP_DFX_SECURE_WIDTH-1:0] dfxsecurestrap_feature,
   input  logic [DFXSECURE_STAP_DFX_SECURE_WIDTH-1:0] ftap_dfxsecure,
   output logic [DFXSECURE_STAP_DFX_SECURE_WIDTH-1:0] atap_dfxsecure,
   output logic                                       dfxsecure_all_en,
   output logic                                       dfxsecure_all_dis,
   output logic [(DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 1):0]
                dfxsecure_feature_en,
   output logic vodfv_all_dis,
   output logic vodfv_customer_dis
   );

   // *********************************************************************
   // Local Parameters
   // *********************************************************************
   localparam HIGH               = 1'b1;
   localparam LOW                = 1'b0;
   localparam TWO_BIT_BINARY_ONE = 2'b01;
   localparam TWO                = 2;

   // *********************************************************************
   // wires
   // *********************************************************************
   logic [(DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 1):0] dfxsecure_feature_en_int;
   logic [DFXSECURE_STAP_DFX_SECURE_WIDTH-1:0]dfx_secursestrap1_NC;
   logic                                      dfxsecure_feature_en_NC;

   // *********************************************************************
   // Generation of the DFx Secure Outputs
   // *********************************************************************
   assign atap_dfxsecure              = ftap_dfxsecure;
   assign dfxsecure_all_en            = (ftap_dfxsecure == {DFXSECURE_STAP_DFX_SECURE_WIDTH{HIGH}}) ?
                                         HIGH : LOW;
   assign dfxsecure_all_dis           = (ftap_dfxsecure == {DFXSECURE_STAP_DFX_SECURE_WIDTH{LOW}})  ?
                                         HIGH : LOW;
   assign dfxsecure_feature_en_int[0] = ((ftap_dfxsecure[1:0] == dfxsecurestrap_feature[0][1:0]) &
                                         (dfxsecurestrap_feature[0][1:0] == TWO_BIT_BINARY_ONE)) ? HIGH : LOW;
   assign dfxsecure_feature_en[0]     = ((~dfxsecure_all_dis & dfxsecure_feature_en_int[0]) |
                                           dfxsecure_all_en);
   // *********************************************************************
   // dummification of dfx secure wires
   // *********************************************************************
   assign dfxsecure_feature_en[1]      = LOW;
   assign dfxsecure_feature_en_int[1]  = LOW;
   assign dfxsecure_feature_en_NC = dfxsecure_feature_en_int[1];
   assign dfx_secursestrap1_NC         = dfxsecurestrap_feature[1][DFXSECURE_STAP_DFX_SECURE_WIDTH-1:0];


   generate
      if (DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE > TWO)
      begin
         for (genvar i = 2; i < DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE; i++)
         begin
//kbbhagwa assign dfxsecure_feature_en_int[i] = ((ftap_dfxsecure[i] == dfxsecurestrap_feature[i][i]) & (dfxsecurestrap_feature[i][i] == HIGH)) ? HIGH : LOW;
         assign dfxsecure_feature_en_int[i] = 
               ( |(ftap_dfxsecure & dfxsecurestrap_feature[i]) ) ;

         assign dfxsecure_feature_en[i]     = ((~dfxsecure_all_dis & dfxsecure_feature_en_int[i]) | dfxsecure_all_en);

//kbbhagwa this was only needed for spyglass/lintra resolution
//            logic [(DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 3):0]
//                            [DFXSECURE_STAP_DFX_SECURE_WIDTH-1:0] securestrap_featurei_NC;
//            assign securestrap_featurei_NC[i-2]  = dfxsecurestrap_feature[i];
         end
         // *********************************************************************
         // dummification of dfx secure wires
         // *********************************************************************
         logic [DFXSECURE_STAP_DFX_SECURE_WIDTH-3:0]dfx_secursestrap0_NC;
         assign dfx_secursestrap0_NC = dfxsecurestrap_feature[0][DFXSECURE_STAP_DFX_SECURE_WIDTH-1:TWO];
      end
   endgenerate

   // *********************************************************************
   // If VISA is enabled, dfxsecure_feature_en[0] should be used for VISA
   // *********************************************************************
   assign vodfv_customer_dis = (dfxsecure_all_dis | (~dfxsecure_all_en) | (~dfxsecure_feature_en[0]));
   assign vodfv_all_dis      = (dfxsecure_all_dis | ((~dfxsecure_all_en) & (~dfxsecure_feature_en[0])));

   // Assertions and coverage
//   `include "stap_dfxsecure_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
   `include "stap_dfxsecure_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif


endmodule
