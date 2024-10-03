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

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_tapnw.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : TAPNW Control Logic
//    DESCRIPTION :
//       Tap network control logic.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    TWO
//       This is number 2 to and is declared just to avoid lint warnings
//----------------------------------------------------------------------
module stap_tapnw
   #(
   parameter TAPNW_STAP_NUMBER_OF_TAPS  = 1,
   parameter TAPNW_STAP_NUMBER_OF_WTAPS = 1
   )
   (
   input  logic                                         stap_selectwir_neg, //kbbhagwa posedge negedge signal merge
   input  logic [(TAPNW_STAP_NUMBER_OF_TAPS * 2) - 1:0] tapc_select,
   output logic [(TAPNW_STAP_NUMBER_OF_TAPS - 1):0]     sftapnw_ftap_enabletap,
   output logic [(TAPNW_STAP_NUMBER_OF_TAPS - 1):0]     sftapnw_ftap_enabletdo
   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;
   localparam TWO  = 2;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [((TAPNW_STAP_NUMBER_OF_TAPS * 2) - 1):0] agent_tapc_select;

   // *********************************************************************
   // Implementation of override logic
   // *********************************************************************
   assign agent_tapc_select = tapc_select;

   // *********************************************************************
   // Generate Enable TAP & Enable TDO for each stap.
   // *********************************************************************
   generate
      for(genvar j = 0; j < TAPNW_STAP_NUMBER_OF_TAPS; j = j + 1)
      begin:generate_tapnw_tdo
         assign sftapnw_ftap_enabletap[j] = (agent_tapc_select[(TWO * j) + 1]) | agent_tapc_select[(TWO * j)];
         assign sftapnw_ftap_enabletdo[j] = ((~(agent_tapc_select[(TWO * j) + 1])) & (agent_tapc_select[(TWO * j)])) |
                                            ((stap_selectwir_neg) & (agent_tapc_select[(TWO * j) + 1] &
                                            ~(agent_tapc_select[(TWO * j)])));
      end
   endgenerate

endmodule
