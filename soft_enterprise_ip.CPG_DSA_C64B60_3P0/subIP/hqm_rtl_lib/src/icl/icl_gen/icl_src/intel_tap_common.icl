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
//
//  Collateral Description:
//  DTEG DUVE-M (TAP RDL2ICL)
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DUVE_M_2020WW38_R0.3
//
//  intel_tap_common.icl : definitions of standard ICL components/registers
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : intel_tap_common.icl
//    DESIGNER    : Igor V Molchanov
//    PROJECT	  : DUVE-M (TAP RDL2ICL)
//
//    PURPOSE	  : Definitions of standard ICL components/registers
//    DESCRIPTION : ICL library contains:
//      iclgen_intel_tap_ir              : TAP IR
//      iclgen_intel_bypass_reg          : BYPASS register
//      iclgen_intel_bypass_rsvd_reg     : TAP RESERVED register
//      iclgen_intel_idcode_reg          : TAP IDCODE register
//      iclgen_intel_slvidcode_reg       : Intel SLVIDCODE register - parameterized
//      iclgen_intel_slvidcode_strap_reg : Intel SLVIDCODE register - with strap
//      iclgen_intel_tap_rpt1            : TAP TDR repeater - 1bit
//      iclgen_intel_tap_rpt2            : TAP TDR repeater - 2bit
//      iclgen_intel_tap_rptn            : TAP TDR repeater - parameterized
//      iclgen_intel_ijtag_sib           : IJTAG SIB - standard
//      iclgen_intel_dfxsecure_plugin    : Intel DFx Secure Plugin
//      iclgen_intel_tap_fsm             : TAP FSM
//----------------------------------------------------------------------

// TAP IR
Module iclgen_intel_tap_ir {

   Parameter IR_SIZE        = 8;
   Parameter IR_RESET_VALUE = 'b0;
   Parameter IR_CAPTURE_SRC = 'b01;
  
   ScanInPort    si;
   ScanOutPort   so                    { Source IR[0]; }
   DataOutPort   tir_out[$IR_SIZE-1:0] { Source IR;}
   ResetPort     rst                   { ActivePolarity 1;}

   // Reset signal: Trstb|TLR; Reset value: IDCODE|BYPASS (IEEE1149.1)
   ScanRegister IR[$IR_SIZE-1:0] {
      ScanInSource     si;
      ResetValue       $IR_RESET_VALUE;
      CaptureSource    $IR_CAPTURE_SRC;
   }
}

// BYPASS rgister
Module iclgen_intel_bypass_reg {

   ScanInPort    si;
   ScanOutPort   so                 { Source DR[0]; }
   SelectPort    sel;

   ScanRegister DR[0:0] {
      ScanInSource     si;
      CaptureSource    1'b0; 
   }
}

// TAP RESERVED register
Module iclgen_intel_bypass_rsvd_reg {

   ScanInPort    si;
   ScanOutPort   so                 { Source DR[0]; }
   SelectPort    sel;

   ScanRegister DR[0:0] {
      ScanInSource     si;
      CaptureSource    1'b0; 
   }

   Attribute explicit_iwrite_only = 1'b1;
}

// TAP IDCODE register
Module iclgen_intel_idcode_reg {

   Parameter IDCODE_VALUE = 32'b0;
  
   ScanInPort    si;
   ScanOutPort   so                 { Source DR[0]; }
   SelectPort    sel;

   ScanRegister DR[31:0] {
      ScanInSource     si;
      CaptureSource    $IDCODE_VALUE; 
   }
}

// Intel SLVICODE register - parameterized
Module iclgen_intel_slvidcode_reg {

   Parameter SLVIDCODE_VALUE = 32'b0;
  
   ScanInPort    si;
   ScanOutPort   so                 { Source DR[0]; }
   SelectPort    sel;

   ScanRegister DR[31:0] {
      ScanInSource     si;
      CaptureSource    $SLVIDCODE_VALUE; 
   }
}

// Intel SLVICODE register - with strap
Module iclgen_intel_slvidcode_strap_reg {

   ScanInPort    si;
   ScanOutPort   so                 { Source DR[0]; }
   SelectPort    sel;

   DataInPort ftap_slvidcode [31:0];

   ScanRegister DR[31:0] {
      ScanInSource     si;
      CaptureSource    ftap_slvidcode; 
   }
}

// TAP TDR repeater - 1 bit
Module iclgen_intel_tap_rpt1 {
 
   ScanInPort    si;
   ScanOutPort   so                    { Source RPT[0]; }
   ResetPort     rst                   { ActivePolarity 1;}

   ScanRegister RPT[0:0] {
      ScanInSource     si;
      ResetValue       'b0; // FIXME
      CaptureSource    'b0; // FIXME
   }

   Attribute explicit_iwrite_only = 1'b1;
}

// TDR repeater - 2bit
Module iclgen_intel_tap_rpt2 {
 
   ScanInPort    si;
   ScanOutPort   so                    { Source RPT[0]; }
   ResetPort     rst                   { ActivePolarity 1;}

   ScanRegister RPT[1:0] {
      ScanInSource     si;
      ResetValue       'b0; // FIXME
      CaptureSource    'b0; // FIXME
   }

   Attribute explicit_iwrite_only = 2'b11;
}

// TDR repeater - parameterized
Module iclgen_intel_tap_rptn {

   Parameter DELAY        = 1;
  
   ScanInPort    si;
   ScanOutPort   so                    { Source RPT[0]; }
   ResetPort     rst                   { ActivePolarity 1;}

   ScanRegister RPT[$DELAY-1:0] {
      ScanInSource     si;
      ResetValue       'b0; // FIXME
      CaptureSource    'b0; // FIXME
   }
}

// SIB (standard)
Module iclgen_intel_ijtag_sib {

   ScanInPort    si;
   ScanOutPort   so     { Source sib[0]; }
   SelectPort    sel;
   ResetPort     rstn { ActivePolarity 0; }

   ToSelectPort  inst_sel { Source select_out;}
   ScanOutPort   inst_si  { Source si;}
   ScanInPort    inst_so;
 
   ScanInterface c {
      Port si; 
      Port so; 
      Port sel;
   } 

   ScanInterface host   { 
      Port inst_si; 
      Port inst_so; 
      Port inst_sel; 
   }
  
   ScanRegister sib [0:0] {
      ScanInSource     scan_in_mux;
      CaptureSource    sib[0:0];
      ResetValue       1'b0;
      DefaultLoadValue 1'b0;
   }

   ScanMux scan_in_mux SelectedBy sib {
      1'b0 : si;
      1'b1 : inst_so;
   }

   LogicSignal select_out { sel,sib == 2'b11; }
}

// Intel DFx Secure Plugin
Module iclgen_intel_dfxsecure_plugin {

   Parameter ENDEBUG_UNLOCK_RED  = 1'b0; // Policy 6
   Parameter INFRARED_UNLOCK_RED = 1'b0; // Policy 7
   Parameter FUSA_UNLOCK_RED     = 1'b0; // Policy 9

   // DFx Secure Plugin - simplified: no latch, fdfx_earlyboot_exit, fdfx_policy_update
   DataInPort     fdfx_secure_policy[3:0] { 
       RefEnum TAP_SECURITY; 
   }

   DataOutPort    dfxsecure_feature_en[2:0] { Source tap_unlocked_red, tap_unlocked_orange, 1'b1;}

   //-- Tap security
   LocalParameter  SECURITY_LOCKED_POLICY      = 4'h0;
   LocalParameter  FUNCTIONALITY_LOCKED_POLICY = 4'h1;
   LocalParameter  SECURITY_UNLOCKED_POLICY    = 4'h2;
   LocalParameter  RESERVED_POLICY             = 4'h3;
   LocalParameter  INTEL_UNLOCKED_POLICY       = 4'h4;
   LocalParameter  OEM_UNLOCKED_POLICY         = 4'h5;
   LocalParameter  ENDEBUG_UNLOCKED_POLICY     = 4'h6;
   LocalParameter  INFRARED_UNLOCKED_POLICY    = 4'h7;
   LocalParameter  DRAM_DEBUG_UNLOCKED_POLICY  = 4'h8;
   LocalParameter  FUSA_UNLOCKED_POLICY        = 4'h9;
   LocalParameter  USER4_UNLOCKED_POLICY       = 4'ha;
   LocalParameter  USER5_UNLOCKED_POLICY       = 4'hb;
   LocalParameter  USER6_UNLOCKED_POLICY       = 4'hc;
   LocalParameter  USER7_UNLOCKED_POLICY       = 4'hd;
   LocalParameter  USER8_UNLOCKED_POLICY       = 4'he;
   LocalParameter  PART_DISABLED_POLICY        = 4'hf; 
   
   Enum TAP_SECURITY {
      SECURITY_LOCKED      = $SECURITY_LOCKED_POLICY;
      FUNCTIONALITY_LOCKED = $FUNCTIONALITY_LOCKED_POLICY;
      SECURITY_UNLOCKED    = $SECURITY_UNLOCKED_POLICY;
      RESERVED             = $RESERVED_POLICY;
      INTEL_UNLOCKED       = $INTEL_UNLOCKED_POLICY;
      OEM_UNLOCKED         = $OEM_UNLOCKED_POLICY;
      ENDEBUG_UNLOCKED     = $ENDEBUG_UNLOCKED_POLICY;
      INFRARED_UNLOCKED    = $INFRARED_UNLOCKED_POLICY;
      DRAM_DEBUG_UNLOCKED  = $DRAM_DEBUG_UNLOCKED_POLICY;
      FUSA_UNLOCKED        = $FUSA_UNLOCKED_POLICY;
      USER4_UNLOCKED       = $USER4_UNLOCKED_POLICY;
      USER5_UNLOCKED       = $USER5_UNLOCKED_POLICY;
      USER6_UNLOCKED       = $USER6_UNLOCKED_POLICY;
      USER7_UNLOCKED       = $USER7_UNLOCKED_POLICY;
      USER8_UNLOCKED       = $USER8_UNLOCKED_POLICY;
      PART_DISABLED        = $PART_DISABLED_POLICY; 
   }

   DataMux tap_unlocked_red SelectedBy fdfx_secure_policy {
     $SECURITY_UNLOCKED_POLICY  : 1'b1;
     $INTEL_UNLOCKED_POLICY     : 1'b1;
     $ENDEBUG_UNLOCKED_POLICY   : $ENDEBUG_UNLOCK_RED;
     $INFRARED_UNLOCKED_POLICY  : $INFRARED_UNLOCK_RED;
     $FUSA_UNLOCKED_POLICY      : $FUSA_UNLOCK_RED;
     'bx                        : 1'b0;
   }

   DataMux tap_unlocked_orange SelectedBy fdfx_secure_policy {
     $OEM_UNLOCKED_POLICY       : 1'b1;
     'bx                        : 1'b0;
   }

}

// TAP FSM
Module iclgen_intel_tap_fsm {
   TCKPort          tck;
   TRSTPort         trstb; // active low
   TMSPort          tms;
   ToIRSelectPort   irsel;
   ToCaptureEnPort  ce;
   ToShiftEnPort    se;
   ToUpdateEnPort   ue;
   ToResetPort      tlr;
}
