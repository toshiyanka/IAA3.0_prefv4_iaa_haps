//-------------------------------------------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//-------------------------------------------------------------------------------------------------------
// NOTE: Log history is at end of file
//-------------------------------------------------------------------------------------------------------
//
//    FILENAME    : dfxsecure_params_includevh
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : dfxsecure_plugin
//    PURPOSE     : RTL Parameters
//    VERSION     : 2016WW11_R05
//    DESCRIPTION :
//       This is a RTL parameter file Please refer IG for more details
//-------------------------------------------------------------------------------------------------------
//    LOCAL PARAMETERS  :
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
//    STAP_DFX_USE_SB_OVR
//       If this parameter is set then the plug-in will use the sb_policy_ovr_value input
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
//    STAP_DFX_EARLYBOOT_FEATURE_ENABLE
//       This parameter sets the hard coded value for the early debug window for this 
//       agent/IP-block For most IP-blocks this will be VISA green only However;
//       there are in the suspend (SUS) well IPs that require full access
//       Most IPs:
//       STAP_DFX_EARLYBOOT_FEATURE_ENABLE[1:0] = VISA_GREEN
//       STAP_DFX_EARLYBOOT_FEATURE_ENABLE[STAP_DFX_NUM_OF_FEATURES_TO_SECURE+1 : 2] = 
//       {[STAP_DFX_NUM_OF_FEATURES_TO_SECURE:2]}{1'b0}}
//-------------------------------------------------------------------------------------------------------

parameter STAP_DFX_NUM_OF_FEATURES_TO_SECURE = 3;

parameter STAP_DFX_SECURE_WIDTH = 4;

parameter STAP_DFX_USE_SB_OVR = 0;

parameter STAP_DFX_VISA_BLACK  = 2'b11;
parameter STAP_DFX_VISA_GREEN  = 2'b01;
parameter STAP_DFX_VISA_ORANGE = 2'b10;
parameter STAP_DFX_VISA_RED    = 2'b00;

parameter STAP_DFX_EARLYBOOT_FEATURE_ENABLE = {3'b001,STAP_DFX_VISA_BLACK};

parameter [(((STAP_DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** STAP_DFX_SECURE_WIDTH)) - 1):0] STAP_DFX_SECURE_POLICY_MATRIX = 
{
{3'b001,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_15
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_14
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_13
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_12
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_11
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_10
{3'b100,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_9
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_8
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_7
{3'b100,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_6
{3'b010,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_5
{3'b100,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_4
{3'b001,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_3
{3'b100,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_2
{3'b001,STAP_DFX_VISA_BLACK},  // 3 dfx features + 2 visa controls => Policy_1
{3'b001,STAP_DFX_VISA_BLACK}   // 3 dfx features + 2 visa controls => Policy_0
};
