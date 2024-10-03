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

`ifndef INTEL_SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // data_reg_parallel_out is not equal to reset value during reset_b
      // ====================================================================
      property stap_dr_stable_during_trst;
         @(posedge ftap_tck)
         (reset_b === 1'b0 ) |=> (tdr_data_out === DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS);
      endproperty : stap_dr_stable_during_trst

      chk_stap_dr_stable_during_trst :
      assert property (stap_dr_stable_during_trst) else
         $error("data_reg_parallel_out is not equal to reset value during reset_b");

   `endif
`endif
