//-------------------------------------------------------------------------------------------------------
// Intel Proprietary -- Copyright 2015 Intel -- All rights reserved
//-------------------------------------------------------------------------------------------------------
// NOTE: Log history is at end of file.
//-------------------------------------------------------------------------------------------------------
//
//    FILENAME    : dfxsecure_params_include.vh
//    DESIGNER    : Krishnadas B Bhagwat
//    PROJECT     : dfxsecure_plugin
//    PURPOSE     : RTL Parameters
//    DESCRIPTION :
//       This is a RTL parameter file. Please refer IG for more details.
//-------------------------------------------------------------------------------------------------------
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
//       If this parameter is set then the plug-in will use the sb_policy_ovr_value input.
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
{1'b0,DFX_VISA_BLACK},  // Policy_15 (Part Disabled)
{1'b0,DFX_VISA_ORANGE},  // Policy_14 (User8 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_13 (User7 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_12 (User6 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_11 (User5 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_10 (User4 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_9 (User3 Unlocked)
{1'b0,DFX_VISA_ORANGE},  // Policy_8 (DRAM Debug Unlocked)
{1'b1,DFX_VISA_RED},  // Policy_7 (InfraRed Unlocked)
{1'b0,DFX_VISA_BLACK},  // Policy_6 (Revoked (Reserved))
{1'b0,DFX_VISA_ORANGE},  // Policy_5 (OEM Unlocked)
{1'b1,DFX_VISA_RED},  // Policy_4 (Intel Unlocked)
{1'b0,DFX_VISA_GREEN},  // Policy_3 (Delayed Auth Locked)
{1'b1,DFX_VISA_RED},  // Policy_2 (Security Unlocked)
{1'b0,DFX_VISA_BLACK},  // Policy_1 (Functionality Locked)
{1'b0,DFX_VISA_GREEN}   // Policy_0 (Security Locked)
}
