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
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------------------------
//
//    FILENAME    : stap_params_include.inc
//    DESIGNER    : Rakesh Kandula
//    PROJECT     : sTAP
//    PURPOSE     : sTAP RTL Parameters
//    VERSION     : %header_tag%
//    DESCRIPTION :
//       This is a RTL parameter file. Please refer IG for more details.
//----------------------------------------------------------------------------------------
//    PARAMETERS  :
//
//    STAP_DFX_NUM_OF_FEATURES_TO_SECURE
//       The minimum number of features to secure is one Although, theoretically
//       it can be any number of features but it is likely to be in an single digits
//
//    STAP_DFX_SECURE_WIDTH
//       This parameter is fixed at 4 for the 14nm chassis generation (Chassis Gen3)
//
//    STAP_DFX_SECURE_POLICY_MATRIX
//       This parameter determines the lookup table necessary to assign the
//       appropriate policy with the DFx feature(s) including VISA access
//
//
//    STAP_DFX_VISA_BLACK
//       This is used to define the VISA access value in an enumerated parameter format
//       This value will clock gate the output flops and prevent bypass from functioning
//
//    STAP_DFX_VISA_GREEN
//       This is used to define the VISA access value in an enumerated parameter format
//       A VISA green level of access provides debug signals to customers without a key
//
//    STAP_DFX_VISA_ORANGE
//       This is used to define the VISA access value in an enumerated parameter format
//       A VISA orange level of access provides debug signals to customers with a key
//
//    STAP_DFX_VISA_RED
//       This is used to define the VISA access value in an enumerated parameter format
//       A VISA red level of access provides debug signals to Intel's use models
//
//    STAP_DFX_USE_SB_OVR
//       If this parameter is set then the plug-in will use the sb_policy_ovr_value input
//
//    STAP_DFX_EARLYBOOT_FEATURE_ENABLE
//       This parameter sets the hard coded value for the early debug window for this 
//       agent/IP-block For most IP-blocks this will be VISA green only However;
//       there are in the suspend (SUS) well IPs that require full access
//       Most IPs:
//       STAP_DFX_EARLYBOOT_FEATURE_ENABLE[1:0] = VISA_GREEN
//       STAP_DFX_EARLYBOOT_FEATURE_ENABLE[STAP_DFX_NUM_OF_FEATURES_TO_SECURE+1 : 2] = 
//       {[STAP_DFX_NUM_OF_FEATURES_TO_SECURE:2]}{1'b0}}
//
//----------------------------------------------------------------------------------------
localparam STAP_DFX_NUM_OF_FEATURES_TO_SECURE = 3;

localparam STAP_DFX_SECURE_WIDTH = 4;

localparam STAP_DFX_USE_SB_OVR  = 0;
localparam STAP_DFX_VISA_BLACK  = 2'b11;
localparam STAP_DFX_VISA_GREEN  = 2'b01;
localparam STAP_DFX_VISA_ORANGE = 2'b10;
localparam STAP_DFX_VISA_RED    = 2'b00;

//localparam STAP_DFX_EARLYBOOT_FEATURE_ENABLE = {3'b001,STAP_DFX_VISA_BLACK};

