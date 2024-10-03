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
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

// *********************************************************************
// Localparameters
// *********************************************************************

`ifndef INTEL_SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Parallel output of shift IR changed when stap_fsm_update_ir is
      // not HIGH or TLRS is not HIGH
      // ====================================================================
      property stap_irreg_change_when_update_ir_0;
         @(posedge ftap_tck)
		 disable iff (powergood_rst_trst_b === LOW)
            ($changed(stap_irreg_ireg)) |-> ((stap_fsm_update_ir === HIGH) || (stap_fsm_tlrs === HIGH));
      endproperty : stap_irreg_change_when_update_ir_0
      chk_stap_irreg_change_when_update_ir_0:
      assert property (stap_irreg_change_when_update_ir_0)
	  else $error("Parallel output of shift IR changed when stap_fsm_update_ir is not HIGH or TLRS is LOW");


      // ====================================================================
      // shift_reg is not equal to reset value (1)
      // ====================================================================
      property stap_shift_ir_reg_equals_01_during_tlrs;
         @(posedge ftap_tck)
            (stap_fsm_tlrs       === HIGH) ||  (powergood_rst_trst_b === LOW) ||
            (stap_fsm_capture_ir === HIGH) |=> (shift_reg === 1);
      endproperty: stap_shift_ir_reg_equals_01_during_tlrs
      chk_stap_shift_ir_reg_equals_01_during_tlrs_0:
      assert property (stap_shift_ir_reg_equals_01_during_tlrs)
         else $error("shift IR reg is not equal to 1 during reset");

      // ====================================================================
      // stap_irreg_ireg is not equal to reset value
      // ====================================================================
      property stap_ir_equals_slvidcode;
         @(posedge ftap_tck)
            (stap_fsm_tlrs   === HIGH) || (powergood_rst_trst_b === LOW) |=>
            (stap_irreg_ireg === IRREG_STAP_ADDRESS_OF_SLVIDCODE);
      endproperty: stap_ir_equals_slvidcode
      chk_stap_ir_equals_slvidcode_01:
      assume property (stap_ir_equals_slvidcode);
      //   else $error("stap_irreg_ireg is not equal to reset value (IRREG_STAP_ADDRESS_OF_SLVIDCODE)");
   `endif
`endif
