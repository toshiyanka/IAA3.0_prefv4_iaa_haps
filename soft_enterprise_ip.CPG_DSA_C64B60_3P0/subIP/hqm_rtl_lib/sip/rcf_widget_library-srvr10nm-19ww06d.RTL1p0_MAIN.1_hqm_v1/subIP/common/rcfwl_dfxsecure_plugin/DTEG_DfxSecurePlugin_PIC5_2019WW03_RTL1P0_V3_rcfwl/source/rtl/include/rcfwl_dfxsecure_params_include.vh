//------------------------------------------------------------------------------
//
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
//  Module <dfxsecure_plugin> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : dfxsecure_plugin.sv
//    DESIGNER    : B.S.Adithya 
//    PROJECT     : dfxsecure_plugin 
//
//    PURPOSE     : DFx Secure Logic
//    DESCRIPTION : Parameter file
//----------------------------------------------------------------------

//    PARAMETERS  :
//
//    DFX_NUM_OF_FEATURES_TO_SECURE
//       The minimum number of features to secure is one. Although, theoretically
//       it can be any number of features but it is likely to be in an single digits.
//
//    DFX_SECURE_WIDTH
//       This parameter is fixed at 4 for the 14nm chassis generation (Chassis Gen3)
//
//    DFX_SECURE_POLICY_MATRIX
//       This parameter determines the lookup table necessary to assign the
//       appropriate policy with the DFx feature(s) including VISA access.
//
//    DFX_USE_SB_OVR
//     If this parameter is set then  the sb_policy_ovr_value input should be any value including 0.
//     If this parameter is not set then the sb_policy_ovr_value input should be 0.
//
//    DFX_VISA_BLACK
//       This is used to define the VISA access value in an enumerated parameter format.
//       This value will clock gate the output flops and prevent bypass from functioning.
//
//    DFX_VISA_GREEN
//       This is used to define the VISA access value in an enumerated parameter format.
//       A VISA green level of access provides debug signals to customers without a key.
//
//    DFX_VISA_ORANGE
//       This is used to define the VISA access value in an enumerated parameter format.
//       A VISA orange level of access provides debug signals to customers with a key.
//
//    DFX_VISA_RED
//       This is used to define the VISA access value in an enumerated parameter format.
//       A VISA red level of access provides debug signals to Intel's use models. 
//
//    DFX_EARLYBOOT_FEATURE_ENABLE
//       This parameter sets the hard coded value for the early debug window for this 
//       agent/IP-block. For most IP-blocks this will be VISA green only. However, 
//       there are in the suspend (SUS) well IPs that require full access.
//       Most IPs:
//       DFX_EARLYBOOT_FEATURE_ENABLE[1:0] = VISA_GREEN
//       DFX_EARLYBOOT_FEATURE_ENABLE[DFX_NUM_OF_FEATURES_TO_SECURE+1 : 2] = 
//       {[DFX_NUM_OF_FEATURES_TO _SECURE:2]}{1'b0}}
//-------------------------------------------------------------------------------------------------------

parameter DFX_NUM_OF_FEATURES_TO_SECURE = 1,

parameter DFX_SECURE_WIDTH = 4,

parameter DFX_USE_SB_OVR = 0,

parameter DFX_VISA_BLACK  = 2'b11,
parameter DFX_VISA_GREEN  = 2'b01,
parameter DFX_VISA_ORANGE = 2'b10,
parameter DFX_VISA_RED    = 2'b00,

parameter DFX_EARLYBOOT_FEATURE_ENABLE = {1'b0,DFX_VISA_GREEN},

parameter [(((DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** DFX_SECURE_WIDTH)) - 1):0] DFX_SECURE_POLICY_MATRIX = 
{
{1'b0,DFX_VISA_BLACK},   // Policy_15 (Part Disabled)
{1'b0,DFX_VISA_ORANGE},  // Policy_14 (User8 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_13 (User7 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_12 (User6 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_11 (User5 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_10 (User4 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_9  (FuSa Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_8  (DRAM Debug Unlocked)
{1'b1,DFX_VISA_RED},     // Policy_7  (InfraRed Unlocked)
{1'b0,DFX_VISA_BLACK},   // Policy_6  (enDebug Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_5  (OEM Unlocked)
{1'b1,DFX_VISA_RED},     // Policy_4  (Intel Unlocked)
{1'b0,DFX_VISA_GREEN},   // Policy_3  (Delayed Auth Locked)
{1'b1,DFX_VISA_RED},     // Policy_2  (Security Unlocked)
{1'b0,DFX_VISA_BLACK},   // Policy_1  (Functionality Locked)
{1'b0,DFX_VISA_GREEN}    // Policy_0  (Security Locked)
}
