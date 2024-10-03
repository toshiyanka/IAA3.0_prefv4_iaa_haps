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
//  Module <mTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : mtap_visa.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//    
//    
//    PURPOSE     : mTAP VISA Implementation
//    DESCRIPTION :
//       This module is a generic visa implementation. This module accepts the data
//       from tdi and shifts according to shift enable provided by FSM.
//       This module also has parallel output port. Once FSM asserts
//       update signal, parallel data is available on its module ports.
//    PARAMETERS  :
//    VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS
//       This parameter specifies the number of visa register required and will
//       normally be passed from the upper module where this module gets
//       instantiated.  This parameter is used to generate parallel out and
//       shift register widths for each registers.
//    VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS
//       This parameter specifies the address field width of the visa implementation
//       This parameter will normally be passed from upper module where
//       this module gets instantiated.
//    VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA
//       This parameter specifies the data field width of the visa implementation.
//       It denotes the width of each VISA Register. This parameter will normally be
//       passed from upper module where this module gets instantiated.
//----------------------------------------------------------------------
module mtap_visa #( parameter VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS =  2,
                    parameter VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS    = 10,
                    parameter VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA       = 32
                  )
                  (
                    input  logic atappris_tck,
                    input  logic atappris_tdi,
                    input  logic powergoodrst_b,
                    input  logic mtap_irdecoder_drselect,
                    input  logic mtap_fsm_shift_dr,
                    input  logic mtap_fsm_update_dr,
                    output logic mtap_drreg_drout,
                    output logic [(VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS - 1):0]
                                 [(VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA - 1):0] tdr_data_out
                   );

   // *********************************************************************
   // Local Parameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Registers
   // *********************************************************************
   logic [(VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS +
           VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA - 1):0]       visa_shift_register;
   logic [(VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS - 1):0]
         [(VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS - 1):0]    visa_reg_addr_for_compare;
   logic [(VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS - 1):0] compare_results;
   logic [(VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS - 1):0] selected_visa_reg;

   // *********************************************************************
   // shift register implementation - the value of tdi pin will come to this
   // reg during shift_DR state
   // *********************************************************************
   always_ff @(posedge atappris_tck or negedge powergoodrst_b)
   begin
      if (!powergoodrst_b)
      begin
         visa_shift_register <= {{VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS +
                                  VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA}{1'b0}};
      end
      else if (mtap_fsm_shift_dr & mtap_irdecoder_drselect)
      begin
         visa_shift_register <= {atappris_tdi,
                                 visa_shift_register[(VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS +
                                                      VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA - 1):1]};
      end
   end

   // *********************************************************************
   // mtap_drreg_drout is going to the TDOmux FUB.
   // *********************************************************************
   assign mtap_drreg_drout = visa_shift_register[0];

   generate
      for (genvar i = 0; i < VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS; i++)
      begin
         assign visa_reg_addr_for_compare[i] = i;
      end
   endgenerate

   generate
      for (genvar j = 0; j < VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS; j++)
      begin
         assign compare_results[j] = (visa_shift_register[(VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS +
                                                           VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA - 1):
                                                           VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA] ==
                                      visa_reg_addr_for_compare[j]) ? HIGH : LOW;
      end
   endgenerate

   generate
      for (genvar k = 0; k < VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS; k++)
      begin
         assign selected_visa_reg[k] = mtap_irdecoder_drselect & compare_results[k];
      end

      for (genvar l = 0; l < VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS; l++)
      begin
         mtap_visa_reg #(
                         .VISA_REG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA (VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA),
                         .VISA_REG_MTAP_VISAOVR_RESET_VALUE          ({VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA{LOW}})
                        )
         i_mtap_visa_reg (
                          .atappris_tck          (atappris_tck),
                          .powergoodrst_b        (powergoodrst_b),
                          .selected_visa_reg     (selected_visa_reg[l]),
                          .mtap_fsm_update_dr    (mtap_fsm_update_dr),
                          .visa_shift_register   (visa_shift_register[(VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA - 1):0]),
                          .visa_reg_parallel_out (tdr_data_out[l])
                         );
      end
   endgenerate

   // Assertions and coverage
//kbbhagwa   `include "mtap_visa_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
 `include "mtap_visa_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif

endmodule
