//-------------------------------------------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//-------------------------------------------------------------------------------------------------------
// NOTE: Log history is at end of file
//-------------------------------------------------------------------------------------------------------
//
//    FILENAME    : dfxsecure_params_includevh
//    DESIGNER    : Rakesh Kandula
//    PROJECT     : dfxsecure_plugin
//    PURPOSE     : RTL Parameters
//    DESCRIPTION :
//       This is a RTL parameter file Please refer IG for more details
//-------------------------------------------------------------------------------------------------------
//    PARAMETERS  :
//
//    DFXSECURE_DFX_NUM_OF_FEATURES_TO_SECURE
//       The minimum number of features to secure is one Although, theoretically
//       it can be any number of features but it is likely to be in an single digits
//
//    DFXSECURE_DFX_SECURE_WIDTH
//       This parameter is fixed at 4 for the 14nm chassis generation (Chassis Gen3)
//
//    DFXSECURE_DFX_SECURE_POLICY_MATRIX
//       This parameter determines the lookup table necessary to assign the
//       appropriate policy with the DFx feature(s) including VISA access
//
//    DFXSECURE_DFX_USE_SB_OVR
//       If this parameter is set then the plug-in will use the sb_policy_ovr_value input
//
//    DFXSECURE_DFX_VISA_BLACK
//       This is used to define the VISA access value in an enumerated parameter format
//       This value will clock gate the output flops and prevent bypass from functioning
//
//    DFXSECURE_DFX_VISA_GREEN
//       This is used to define the VISA access value in an enumerated parameter format
//       A VISA green level of access provides debug signals to customers without a key
//
//    DFXSECURE_DFX_VISA_ORANGE
//       This is used to define the VISA access value in an enumerated parameter format
//       A VISA orange level of access provides debug signals to customers with a key
//
//    DFXSECURE_DFX_VISA_RED
//       This is used to define the VISA access value in an enumerated parameter format
//       A VISA red level of access provides debug signals to Intel's use models 
//
//    DFXSECURE_DFX_EARLYBOOT_FEATURE_ENABLE
//       This parameter sets the hard coded value for the early debug window for this 
//       agent/IP-block For most IP-blocks this will be VISA green only However;
//       there are in the suspend (SUS) well IPs that require full access
//       Most IPs:
//       DFXSECURE_DFX_EARLYBOOT_FEATURE_ENABLE[1:0] = VISA_GREEN
//       DFXSECURE_DFX_EARLYBOOT_FEATURE_ENABLE[DFXSECURE_DFX_NUM_OF_FEATURES_TO_SECURE+1 : 2] = 
//       {[DFXSECURE_DFX_NUM_OF_FEATURES_TO _SECURE:2]}{1'b0}}
//-------------------------------------------------------------------------------------------------------

parameter DFXSECURE_DFX_NUM_OF_FEATURES_TO_SECURE = 1;

parameter DFXSECURE_DFX_SECURE_WIDTH = 4;

parameter DFXSECURE_DFX_USE_SB_OVR = 1;

parameter DFXSECURE_DFX_VISA_BLACK  = 2'b11;
parameter DFXSECURE_DFX_VISA_GREEN  = 2'b01;
parameter DFXSECURE_DFX_VISA_ORANGE = 2'b10;
parameter DFXSECURE_DFX_VISA_RED    = 2'b00;

parameter DFXSECURE_DFX_EARLYBOOT_FEATURE_ENABLE = {1'b0,DFXSECURE_DFX_VISA_BLACK};

parameter [(((DFXSECURE_DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** DFXSECURE_DFX_SECURE_WIDTH)) - 1):0] DFXSECURE_DFX_SECURE_POLICY_MATRIX = 
{
{1'b0,DFXSECURE_DFX_VISA_BLACK},  // Policy_15 (Part Disabled)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_14 (User8 Unlocked)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_13 (User7 Unlocked)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_12 (User6 Unlocked)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_11 (User5 Unlocked)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_10 (User4 Unlocked)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_9 (User3 Unlocked)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_8 (DRAM Debug Unlocked)
{1'b1,DFXSECURE_DFX_VISA_RED},  // Policy_7 (InfraRed Unlocked)
{1'b0,DFXSECURE_DFX_VISA_BLACK},  // Policy_6 (enDebug Unlocked)
{1'b0,DFXSECURE_DFX_VISA_ORANGE},  // Policy_5 (OEM Unlocked)
{1'b1,DFXSECURE_DFX_VISA_RED},  // Policy_4 (Intel Unlocked)
{1'b0,DFXSECURE_DFX_VISA_GREEN},  // Policy_3 (Delayed Auth Locked)
{1'b1,DFXSECURE_DFX_VISA_RED},  // Policy_2 (Security Unlocked)
{1'b0,DFXSECURE_DFX_VISA_BLACK},  // Policy_1 (Functionality Locked)
{1'b0,DFXSECURE_DFX_VISA_GREEN}   // Policy_0 (Security Locked)
};
