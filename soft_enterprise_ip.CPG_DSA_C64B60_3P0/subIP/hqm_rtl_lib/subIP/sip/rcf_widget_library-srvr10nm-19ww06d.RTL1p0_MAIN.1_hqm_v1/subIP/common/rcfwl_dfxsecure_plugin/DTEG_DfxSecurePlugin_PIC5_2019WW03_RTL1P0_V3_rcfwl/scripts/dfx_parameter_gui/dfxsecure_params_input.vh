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
//-------------------------------------------------------------------------------------------------------

parameter DFX_NUM_OF_FEATURES_TO_SECURE = 5,

parameter DFX_SECURE_WIDTH = 4,

parameter DFX_USE_SB_OVR = 1,

parameter DFX_VISA_BLACK  = 2'b11,
parameter DFX_VISA_GREEN  = 2'b01,
parameter DFX_VISA_ORANGE = 2'b10,
parameter DFX_VISA_RED    = 2'b00,

parameter [(((DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** DFX_SECURE_WIDTH)) - 1):0] DFX_SECURE_POLICY_MATRIX = 
{
{5'b00000,DFX_VISA_BLACK},   // 5 dfx features + 2 visa controls => Policy_15
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_14
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_13
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_12
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_11
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_10
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_9
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_8
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_7
{5'b00000,DFX_VISA_BLACK},   // 5 dfx features + 2 visa controls => Policy_6
{5'b00000,DFX_VISA_ORANGE},  // 5 dfx features + 2 visa controls => Policy_5
{5'b11111,DFX_VISA_RED},     // 5 dfx features + 2 visa controls => Policy_4
{5'b00000,DFX_VISA_BLACK},  // 5 dfx features + 2 visa controls => Policy_3
{5'b11111,DFX_VISA_RED},     // 5 dfx features + 2 visa controls => Policy_2
{5'b00000,DFX_VISA_BLACK},  // 5 dfx features + 2 visa controls => Policy_1
{5'b00000,DFX_VISA_GREEN}   // 5 dfx features + 2 visa controls => Policy_0
}
