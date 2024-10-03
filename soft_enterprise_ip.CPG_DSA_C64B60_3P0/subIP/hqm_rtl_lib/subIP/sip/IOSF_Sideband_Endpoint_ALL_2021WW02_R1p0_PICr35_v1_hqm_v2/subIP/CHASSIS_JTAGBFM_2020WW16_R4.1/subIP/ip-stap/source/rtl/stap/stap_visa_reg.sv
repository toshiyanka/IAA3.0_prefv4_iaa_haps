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
//    FILENAME    : stap_visa_reg.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP DR Register Implementation
//    DESCRIPTION :
//       This module is a generic register. This module has parallel input
//       and output ports. Once FSM asserts update signal, parallel data
//       is available on its module ports.
//    PARAMETERS  :
//    VISA_REG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA
//       This parameter specifies the width of the data register and will
//       normally be passed from the upper module where this module gets
//       instantiated.  This parameter is used to generate parallel in
//       and parallel out widths for shadow register.
//    VISA_REG_STAP_VISAOVR_RESET_VALUE
//       This parameter specifies the Reset values for the data register.
//       This parameter will normally be passed from upper module where
//       this module gets instantiated.
//----------------------------------------------------------------------
module stap_visa_reg
   #(
   parameter VISA_REG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA = 1,
   parameter VISA_REG_STAP_VISAOVR_RESET_VALUE        = 0
   )
   (
   input  logic                                                    ftap_tck,
   input  logic                                                    powergoodrst_b,
   input  logic                                                    selected_visa_reg,
   input  logic                                                    stap_fsm_update_dr,
   input  logic [(VISA_REG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA - 1):0] visa_shift_register,
   output logic [(VISA_REG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA - 1):0] visa_reg_parallel_out
   );

   // *********************************************************************
   // Local Parameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // parallel register implementation - the value will be updated to parallel
   // reg during update_DR state and negedge of tck
   // *********************************************************************
   always_ff @(negedge ftap_tck or negedge powergoodrst_b)
   begin
      if (!powergoodrst_b)
      begin
         visa_reg_parallel_out <= VISA_REG_STAP_VISAOVR_RESET_VALUE;
      end
      else if (stap_fsm_update_dr & selected_visa_reg)
      begin
         visa_reg_parallel_out <= visa_shift_register;
      end
   end

   //Assertions and coverage
//kbbhagwa   `include "stap_visa_reg_include.sv"

//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
 `include "stap_visa_reg_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif


endmodule
