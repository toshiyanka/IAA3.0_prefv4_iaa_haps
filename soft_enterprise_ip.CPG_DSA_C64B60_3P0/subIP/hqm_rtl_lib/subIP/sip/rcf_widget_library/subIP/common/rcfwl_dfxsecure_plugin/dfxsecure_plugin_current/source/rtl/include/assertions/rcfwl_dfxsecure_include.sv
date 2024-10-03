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
//    DESCRIPTION : Contains the assertions
//----------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
   `ifdef DFX_PARAMETER_CHECKER
      `ifndef DFX_FPV_ENABLE
         initial
         begin
            //===================================================================================
            // To check DFX_SECURE_WIDTH parameter value
            //===================================================================================
            CHK_DFX_SECURE_WIDTH_IS_FOUR:
            assert (DFX_SECURE_WIDTH === 4)
            else $fatal (1,"Parameter DFX_SECURE_WIDTH value is not correct, it should be: 4");

            //===================================================================================
            // a delay of 1ps is given to avoid evaluation of the following 2 assertion conditions at 0ps
            //===================================================================================
            #1ps

            //===================================================================================
            // To check sb_policy_ovr_value input is equal to 0x0 when DFX_USE_SB_OVR is equal to 0
            //===================================================================================
            CHK_SB_POLICY_OVR_VALUE_IS_ZERO_IF_USE_OVR_IS_ZERO:
            assert ( (DFX_USE_SB_OVR === HIGH) ||
                         ( (DFX_USE_SB_OVR === LOW) &&
                           (sb_policy_ovr_value === {{DFX_NUM_OF_FEATURES_TO_SECURE{LOW}}, LOW, LOW})
                         )
                   )
            else $error ("Input sb_policy_ovr_value does not carry the value of 0x0 when parameter DFX_USE_SB_OVR is 0");

            //===================================================================================
            // To check oem_secure_policy input value equal to 0x0 when DFX_USE_SB_OVR is equal to 0
            //===================================================================================
            CHK_OEM_SECURE_POLICY_IS_ZERO_IF_USE_OVR_IS_ZERO:
            assert ( (DFX_USE_SB_OVR === HIGH) ||
                         ( (DFX_USE_SB_OVR === LOW) &&
                           (oem_secure_policy === POLICY0)
                         )
                   )
            else $error ("Input oem_secure_policy does not carry the value of 0x0 when parameter DFX_USE_SB_OVR is 0");

            //===================================================================================
            // To check oem_secure_policy is set to one of the user defined (unused) policy 
            // states when the parameter USE_SB_OVR is set to logic 1.  The user defined policy 
            // states are user 1 through 8 unlocked (hex values 0x7 through 0xE).
            //===================================================================================
            CHK_OEM_SECURE_POLICY_IS_USER_DEFINED_POLICY_STATES_IF_USE_OVR_IS_HIGH:
            assert ( (DFX_USE_SB_OVR === LOW) || 
                        ( (DFX_USE_SB_OVR === HIGH) && ( (oem_secure_policy === POLICY7)  ||
                                                        (oem_secure_policy === POLICY8)  || 
                                                        (oem_secure_policy === POLICY9)  || 
                                                        (oem_secure_policy === POLICY10) || 
                                                        (oem_secure_policy === POLICY11) || 
                                                        (oem_secure_policy === POLICY12) || 
                                                        (oem_secure_policy === POLICY13) || 
                                                        (oem_secure_policy === POLICY14)
                                                      )
                        )
                   )
            else $error ("Input oem_secure_policy is not one of the user defined policy states(0x7 through 0xE) when parameter DFX_USE_SB_OVR is 1");

         end
      `endif // DFX_FPV_ENABLE
   `endif // DFX_PARAMETER_CHECKER

   `ifdef DFX_ASSERTIONS
   wire [(DFX_NUM_OF_FEATURES_TO_SECURE + 1):0] local_feature_en_value;

   assign local_feature_en_value = {dfxsecure_feature_en, visa_all_dis, visa_customer_dis};

      //===================================================================================
      // To check DFxSecure Feature En & Visa Feature En values equal to sb_policy_ovr_value
      // when DFX_USE_SB_OVR equal to 1 and dfxsecure_feature_lch equal to oem_secure_policy 
      // value;
      //===================================================================================

      generate
         if (DFX_USE_SB_OVR === 1) 
         begin
            property check_output_eq_sb_ovr_val_when_use_sb_enabled_and_oem_eq_policy;
                @(local_feature_en_value)
                disable iff (fdfx_powergood  !== HIGH)  
                ( (DFX_USE_SB_OVR === HIGH) && 
                  (dfxsecure_feature_lch === oem_secure_policy) && 
                  (fdfx_earlyboot_exit === HIGH)
                ) |-> ({dfxsecure_feature_en, visa_all_dis, visa_customer_dis} === sb_policy_ovr_value);
            endproperty: check_output_eq_sb_ovr_val_when_use_sb_enabled_and_oem_eq_policy

            chk_check_output_eq_sb_ovr_val_when_use_sb_enabled_and_oem_eq_policy:
            assert property (check_output_eq_sb_ovr_val_when_use_sb_enabled_and_oem_eq_policy)
            else $error ("DFxSecure Feature En & VISA Feature En are not equal to sb_policy_ovr_value when DFX_USE_SB_OVR equal to 1 and dfxsecure_feature_lch equal to oem_secure_policy value");

            //===================================================================================
            // To check DFxSecure Feature En & Visa Feature En values equal to dfxsecure_feature_int
            // when DFX_USE_SB_OVR equal to 1 and dfxsecure_feature_lch not equal to oem_secure_policy
            // value;
            //===================================================================================
            property check_output_eq_plcy_matrix_val_when_use_sb_enabled_and_oem_not_eq_policy;
                @(local_feature_en_value)
                disable iff (fdfx_powergood  !== HIGH)  
                ( (DFX_USE_SB_OVR === HIGH) &&
                  (dfxsecure_feature_lch !== oem_secure_policy) &&
                  (fdfx_earlyboot_exit === HIGH)
                ) |-> ({dfxsecure_feature_en, visa_all_dis, visa_customer_dis} === dfxsecure_feature_int);
            endproperty: check_output_eq_plcy_matrix_val_when_use_sb_enabled_and_oem_not_eq_policy

            chk_check_output_eq_plcy_matrix_val_when_use_sb_enabled_and_oem_not_eq_policy:
            assert property (check_output_eq_plcy_matrix_val_when_use_sb_enabled_and_oem_not_eq_policy)
            else $error ("DFxSecure Feature En & VISA Feature En are not equal to dfxsecure_feature_int when DFX_USE_SB_OVR equal to 1 and dfxsecure_feature_lch not equal to oem_secure_policy value");

         end // begin
      endgenerate
      //===================================================================================
      // To check DFxSecure Feature En & Visa Feature En values equal to dfxsecure_feature_int
      // when DFX_USE_SB_OVR equal to 0 and fdfx_earlyboot_exit equal to 1;
      //===================================================================================
      generate
         if (DFX_USE_SB_OVR === 0) 
         begin
            property check_output_eq_plcy_matrix_val_when_use_sb_disabled_and_early_bootexit_high;
                @(local_feature_en_value)
                disable iff (fdfx_powergood  !== HIGH)  
                ( (DFX_USE_SB_OVR === LOW) &&
                  (fdfx_earlyboot_exit === HIGH)) |->
                ({dfxsecure_feature_en, visa_all_dis, visa_customer_dis} === dfxsecure_feature_int);
            endproperty: check_output_eq_plcy_matrix_val_when_use_sb_disabled_and_early_bootexit_high

            chk_check_output_eq_plcy_matrix_val_when_use_sb_disabled_and_early_bootexit_high:
            assert property (check_output_eq_plcy_matrix_val_when_use_sb_disabled_and_early_bootexit_high)
            else $error ("DFxSecure Feature En & VISA Feature En are not equal to dfxsecure_feature_int when DFX_USE_SB_OVR equal to 0 and fdfx_earlyboot_exit equal to 1");
               end // begin
      endgenerate

      //===================================================================================
      // To check DFxSecure Feature En & Visa Feature En values equal to DFX_EARLYBOOT_FEATURE_ENABLE 
      // when DFX_USE_SB_OVR equal to 0 and fdfx_earlyboot_exit equal to 0;
      //===================================================================================
      property check_output_eq_early_bootexit_val_when_early_bootexit_low;
          @(local_feature_en_value)
          disable iff (fdfx_powergood  !== HIGH)  
          (fdfx_earlyboot_exit === LOW) |-> 
          ({dfxsecure_feature_en, visa_all_dis, visa_customer_dis} === DFX_EARLYBOOT_FEATURE_ENABLE);
      endproperty: check_output_eq_early_bootexit_val_when_early_bootexit_low

      chk_check_output_eq_early_bootexit_val_when_early_bootexit_low:
      assert property (check_output_eq_early_bootexit_val_when_early_bootexit_low)
      else $error ("DFxSecure Feature En & VISA Feature En are not equal to DFX_EARLYBOOT_FEATURE_ENABLE when DFX_USE_SB_OVR equal to 0 and fdfx_earlyboot_exit equal to 0");

   `endif
`endif
