//-------------------------------------------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//-------------------------------------------------------------------------------------------------------
// NOTE: Log history is at end of file.
//-------------------------------------------------------------------------------------------------------
//
//    FILENAME    : tb_params.inc
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : dfxsecure_plugin 
//    PURPOSE     : TB Parameters
//    DESCRIPTION :
//       This is a TB parameter file. Please refer IG for more details.
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
//-------------------------------------------------------------------------------------------------------

parameter DFX_NUM_OF_FEATURES_TO_SECURE    = 3;
parameter DFX_SECURE_WIDTH                 = 4;
parameter DFX_USE_SB_OVR                   = 0;
parameter [(((DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** DFX_SECURE_WIDTH)) - 1):0] DFX_SECURE_POLICY_MATRIX = 
{
5'b00011, //3 dfx features + 2 visa controls => Policy_15
5'b00101, //3 dfx features + 2 visa controls => Policy_14
5'b00101, //3 dfx features + 2 visa controls => Policy_13
5'b00101, //3 dfx features + 2 visa controls => Policy_12
5'b00101, //3 dfx features + 2 visa controls => Policy_11
5'b00101, //3 dfx features + 2 visa controls => Policy_10
5'b00101, //3 dfx features + 2 visa controls => Policy_9
5'b00101, //3 dfx features + 2 visa controls => Policy_8
5'b10110, //3 dfx features + 2 visa controls => Policy_7
5'b00011, //3 dfx features + 2 visa controls => Policy_6
5'b00010, //3 dfx features + 2 visa controls => Policy_5
5'b11100, //3 dfx features + 2 visa controls => Policy_4
5'b00011, //3 dfx features + 2 visa controls => Policy_3
5'b11100, //3 dfx features + 2 visa controls => Policy_2
5'b00011, //3 dfx features + 2 visa controls => Policy_1
5'b00001  //3 dfx features + 2 visa controls => Policy_0
};
