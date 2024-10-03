//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2015 Intel Corporation All Rights Reserved.
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
// Intel Proprietary -- Copyright 2015 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : dfxsecure_plugin.sv
//    DESIGNER    : Krishnadas B Bhagwat
//    PROJECT     : dfxsecure_plugin 
//
//    PURPOSE     : DFx Secure Logic
//    DESCRIPTION :
//       This module implements the DFx Security plugin Logic to enable 
//       chassis complaince.
//----------------------------------------------------------------------
`include "dfxsecure_defines_include.inc"

module dfxsecure_plugin
   #(
   `include "dfxsecure_params_include.vh"
   )
   (
   // // -----------------------------------------------------------------
   // // DFX Secure signals
   // // -----------------------------------------------------------------
   // fdfx_powergood        // Active low:  This singnal is sinked
   //                       // by the IP-Block for its power good reset. This 
   //                       // signal is equivalent to fdfx_powergood.
   // fdfx_secure_policy,   // This bus is a binary encoded value of the
   //                       // security policy that is the current state of
   //                       // the SoC.  The parameter value is constant for
   //                       // a given SoC generation and aligned with a process
   //                       // node. All IP-blocks must have the same width.
   //                       // For 14nm chassis: DFX_SECURE_WIDTH = 4.
   // dfxsecure_feature_en, // This is a legacy implementation where the decoded
   //                       // value of the fdfx_secure_policy enables each 
   //                       // assigned DFx feature based on the policy assignment
   //                       // from the policy matrix.
   // visa_all_dis,         // This output gets asserted when policy indicates that
   //                       // none of the features are enabled(VISA_BLACK Policy)
   // visa_customer_dis,    // This output gets asserted when fdfx_secure_policy 
   //                       // is VISA_GREEN policy or VISA_BLACK policy.
   // fdfx_earlyboot_exit   // This signal indicates when the early boot debug
   //                       // window is closed.
   //                       // 0: Debug capabilities are available during this phase
   //                       // of the boot flow
   //                       // 1: DFx security policy must be used
   // fdfx_policy_update    // This signal is the latch enable to capture the policy
   //                       // value to prevent glitches.
   //                       // 0: Latch values
   //                       // 1: Update to new policy value
   // sb_policy_ovr_value   // This signal bus is the same width as the policy 
   //                       // matrix parameter. It is the number of features to
   //                       // secure plus the two bits from the concatenation of
   //                       // the VISA signals. If the Sideband policy override
   //                       // feature is not used then connect  
   //                       // sb_policy_ovr_value = policy_fivehex
   // oem_secure_policy     // This is a strap on the IP-block that allows a
   //                       // user-defined value specifically between 0x7 and
   //                       // 0xE to use the sideband policy override value 
   //                       // (sb_policy_ovr_value). If the Sideband is not used
   //                       // then this bus input should be set to the OEM unlock 
   //                       // policy value of 0x7. Default: Set to 0x7 if not used.
   // // -----------------------------------------------------------------

   input  logic                                         fdfx_powergood,
   input  logic [(DFX_SECURE_WIDTH -1) :0]              fdfx_secure_policy,
   input  logic                                         fdfx_earlyboot_exit,
   input  logic                                         fdfx_policy_update,
   output logic [(DFX_NUM_OF_FEATURES_TO_SECURE - 1):0] dfxsecure_feature_en,
   output logic                                         visa_all_dis,
   output logic                                         visa_customer_dis,
   input  logic [(DFX_NUM_OF_FEATURES_TO_SECURE + 1):0] sb_policy_ovr_value,
   input  logic [(DFX_SECURE_WIDTH - 1) : 0]            oem_secure_policy
   );

   // *********************************************************************
   // Local Parameters
   // *********************************************************************
   localparam LOW                        = 1'b0;
   localparam HIGH                       = 1'b1;
   localparam POLICY0                    = 4'b0000;
   localparam POLICY1                    = 4'b0001;
   localparam POLICY2                    = 4'b0010;
   localparam POLICY3                    = 4'b0011;
   localparam POLICY4                    = 4'b0100;
   localparam POLICY5                    = 4'b0101;
   localparam POLICY6                    = 4'b0110;
   localparam POLICY7                    = 4'b0111;
   localparam POLICY8                    = 4'b1000;
   localparam POLICY9                    = 4'b1001;
   localparam POLICY10                   = 4'b1010;
   localparam POLICY11                   = 4'b1011;
   localparam POLICY12                   = 4'b1100;
   localparam POLICY13                   = 4'b1101;
   localparam POLICY14                   = 4'b1110;
   localparam POLICY15                   = 4'b1111;
   localparam UNDRIVEN                   = 5'b10000;
   localparam SIZE_OF_EACH_FEATURE_GROUP = DFX_NUM_OF_FEATURES_TO_SECURE + 2;

   // *********************************************************************
   // Internal Signals
   // *********************************************************************
   logic [(SIZE_OF_EACH_FEATURE_GROUP - 1):0] dfxsecure_feature_int;
   logic [(DFX_SECURE_WIDTH- 1):0]            dfxsecure_feature_lch;
   logic [(SIZE_OF_EACH_FEATURE_GROUP - 1):0] dfxsecure_feature_mux;
   logic                                      oem_dfx_compare;
   logic                                      oem_select;
  
   // *********************************************************************
   // Outputs 
   // *********************************************************************
   assign visa_customer_dis    = (fdfx_earlyboot_exit == LOW) ? DFX_EARLYBOOT_FEATURE_ENABLE[0] : dfxsecure_feature_mux[0];
   assign visa_all_dis         = (fdfx_earlyboot_exit == LOW) ? DFX_EARLYBOOT_FEATURE_ENABLE[1] : dfxsecure_feature_mux[1]; 
   assign dfxsecure_feature_en = (fdfx_earlyboot_exit == LOW) ? DFX_EARLYBOOT_FEATURE_ENABLE[(SIZE_OF_EACH_FEATURE_GROUP - 1):2] : dfxsecure_feature_mux[(SIZE_OF_EACH_FEATURE_GROUP - 1):2];

   // *********************************************************************
   // Sideband override for targeted OEM enabling 
   // *********************************************************************
   assign oem_dfx_compare       = (dfxsecure_feature_lch == oem_secure_policy) ? HIGH : LOW; 
   assign oem_select            = (DFX_USE_SB_OVR == HIGH) ? oem_dfx_compare : LOW;
   assign dfxsecure_feature_mux = (oem_select == HIGH) ? sb_policy_ovr_value : dfxsecure_feature_int;

   // *********************************************************************
   // DFx Features and visa controls from lookup table based on policy value 
   // *********************************************************************
   always_latch
   begin
      if (!fdfx_powergood)
      begin  
        dfxsecure_feature_lch <= {DFX_SECURE_WIDTH{LOW}};
      end  
      else
      begin
         if (fdfx_policy_update)
         begin  
            dfxsecure_feature_lch <= fdfx_secure_policy;
         end   
      end   
   end     
  
  //---------------------------------------------------------------------------------------
  always_comb
  begin
    case (dfxsecure_feature_lch)
    POLICY0:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY0 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY0 * SIZE_OF_EACH_FEATURE_GROUP)]; 
    end
    POLICY1:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY1 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY1 * SIZE_OF_EACH_FEATURE_GROUP)]; 
    end
    POLICY2:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY2 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY2 * SIZE_OF_EACH_FEATURE_GROUP)];
    end
    POLICY3:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY3 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY3 * SIZE_OF_EACH_FEATURE_GROUP)];
    end
    POLICY4:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY4 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY4 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY5:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY5 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY5 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY6:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY6 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY6 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY7:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY7 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY7 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY8:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY8 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY8 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY9:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY9 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY9 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY10:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY10 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY10 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY11:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY11 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY11 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY12:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY12 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY12 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY13:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY13 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY13 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY14:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY14 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY14 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    POLICY15:
    begin
      dfxsecure_feature_int = DFX_SECURE_POLICY_MATRIX[(((POLICY15 * SIZE_OF_EACH_FEATURE_GROUP) + SIZE_OF_EACH_FEATURE_GROUP) - 1):(POLICY15 * SIZE_OF_EACH_FEATURE_GROUP)] ;
    end
    default:
    begin
      dfxsecure_feature_int = {SIZE_OF_EACH_FEATURE_GROUP{LOW}};
    end
    endcase
  end  
  //---------------------------------------------------------------------------------------

   // ====================================================================
   // synopsys translate_off
   // ====================================================================
   typedef enum logic [4:0] {
      security_locked       = {1'b0,POLICY0},
      functionality_locked  = {1'b0,POLICY1},
      security_unlocked     = {1'b0,POLICY2},
      fuse_programming_only = {1'b0,POLICY3},
      intel_unlocked        = {1'b0,POLICY4},
      oem_unlocked          = {1'b0,POLICY5},
      revoked_or_reserved   = {1'b0,POLICY6},
      user1_unlocked        = {1'b0,POLICY7},
      user2_unlocked        = {1'b0,POLICY8},
      user3_unlocked        = {1'b0,POLICY9},
      user4_unlocked        = {1'b0,POLICY10},
      user5_unlocked        = {1'b0,POLICY11},
      user6_unlocked        = {1'b0,POLICY12},
      user7_unlocked        = {1'b0,POLICY13},
      user8_unlocked        = {1'b0,POLICY14},
      part_disabled         = {1'b0,POLICY15},
      undriven              = UNDRIVEN} dfxsecure_policy_encode;

   dfxsecure_policy_encode policy_name;

   always_comb
   begin
      policy_name = dfxsecure_policy_str(dfxsecure_feature_lch);
   end

   function dfxsecure_policy_encode dfxsecure_policy_str(logic [(DFX_SECURE_WIDTH - 1):0] secure_policy);
      begin
         dfxsecure_policy_encode str;
         case (secure_policy)
            POLICY0 : begin str = security_locked;       end
            POLICY1 : begin str = functionality_locked;  end
            POLICY2 : begin str = security_unlocked;     end
            POLICY3 : begin str = fuse_programming_only; end
            POLICY4 : begin str = intel_unlocked;        end
            POLICY5 : begin str = oem_unlocked;          end
            POLICY6 : begin str = revoked_or_reserved;   end
            POLICY7 : begin str = user1_unlocked;        end
            POLICY8 : begin str = user2_unlocked;        end
            POLICY9 : begin str = user3_unlocked;        end
            POLICY10: begin str = user4_unlocked;        end
            POLICY11: begin str = user5_unlocked;        end
            POLICY12: begin str = user6_unlocked;        end
            POLICY13: begin str = user7_unlocked;        end
            POLICY14: begin str = user8_unlocked;        end
            POLICY15: begin str = part_disabled;         end
            default:  begin str = undriven;              end
         endcase
         return str;
      end
   endfunction
   // ====================================================================
   // synopsys translate_on
   // ====================================================================

// Assertions and coverage
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`else
   //\\// synopsys translate_off  note:1
`endif

   // Assertions and coverage
   `include "dfxsecure_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`else
   //\\// synopsys translate_on
`endif

endmodule
