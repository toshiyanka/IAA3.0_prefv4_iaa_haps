//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
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
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2020WW22_PICr33
//
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_tapnw.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : TAPNW control logic
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
   parameter TAPNW_STAP_NUMBER_OF_TAPS        = 1,
   parameter TAPNW_STAP_NUMBER_OF_WTAPS       = 1
   )
   (
   //input  logic                                          stap_selectwir,
   input  logic                                          stap_selectwir_neg, //kbbhagwa posedge negedge signal merge

   input  logic [(TAPNW_STAP_NUMBER_OF_TAPS * 2) - 1:0]  tapc_select,
   output logic [(TAPNW_STAP_NUMBER_OF_TAPS  - 1):0]     sftapnw_ftap_enabletap,
   output logic [(TAPNW_STAP_NUMBER_OF_TAPS  - 1):0]     sftapnw_ftap_enabletdo,
   input  logic [(TAPNW_STAP_NUMBER_OF_TAPS - 1):0]      stapnw_atap_subtapactvi,
   output logic                                          atap_subtapactv_tapnw
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
      for(genvar m = 0; m < TAPNW_STAP_NUMBER_OF_TAPS; m = m + 1)
      begin
         assign sftapnw_ftap_enabletap[m] =    (agent_tapc_select[(TWO * m) + 1])  |  agent_tapc_select[(TWO * m)];
/*
kbbhagwa posedge negedge signal merge
         assign sftapnw_ftap_enabletdo[m] = ((~(agent_tapc_select[(TWO * m) + 1])) & (agent_tapc_select[(TWO * m)]))   |
                                      ((stap_selectwir)                    & (agent_tapc_select[(TWO * m) + 1] &
                                     ~(agent_tapc_select[(TWO * m)])));
*/
         assign sftapnw_ftap_enabletdo[m] = ((~(agent_tapc_select[(TWO * m) + 1])) & (agent_tapc_select[(TWO * m)]))   |
                                      ((stap_selectwir_neg)                    & (agent_tapc_select[(TWO * m) + 1] &
                                     ~(agent_tapc_select[(TWO * m)])));


      end
   endgenerate

   // *********************************************************************
   // subtap active logic Oring and propogation
   // *********************************************************************
   assign atap_subtapactv_tapnw   = (|stapnw_atap_subtapactvi) | (|agent_tapc_select) ;

endmodule
