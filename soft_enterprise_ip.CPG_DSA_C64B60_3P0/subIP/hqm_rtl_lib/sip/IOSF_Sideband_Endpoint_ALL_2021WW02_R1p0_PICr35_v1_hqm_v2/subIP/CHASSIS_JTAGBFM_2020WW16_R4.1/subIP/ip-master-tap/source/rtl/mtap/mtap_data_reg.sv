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
//    FILENAME    : mtap_data_reg.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//    
//    
//    PURPOSE     : MTAP DR Register Implementation
//    DESCRIPTION :
//       This module is generic JTAG register. This module accepts the data
//       from tdi and shifts according to shift enable provided by FSM.
//       This module also has parallel input and output ports. Once FSM asserts
//       update signal, parallel data is available on its module ports.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module mtap_data_reg #( parameter DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           = 1,
                        parameter DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       = 0,
                        parameter DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = 0
                      )
                     (
                      input  logic                                                         mtap_fsm_tlrs,
                      input  logic                                                         atappris_tck,
                      input  logic                                                         atappris_tdi,
                      input  logic                                                         reset_b,
                      input  logic                                                         mtap_irdecoder_drselect,
                      input  logic                                                         mtap_fsm_capture_dr,
                      input  logic                                                         mtap_fsm_shift_dr,
                      input  logic                                                         mtap_fsm_update_dr,
                      input  logic [(DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):0] tdr_data_in,
                      output logic                                                         mtap_drreg_drout,
                      output logic [(DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):0] tdr_data_out
                     );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal Signals
   // *********************************************************************
   logic [(DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):0] shift_register;
   logic [(DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):0] mux_input_pin_loopback;

   // *********************************************************************
   // Selection between pin value or loopback value
   // *********************************************************************
   generate
      if (DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER > 1)
      begin
         always_comb
         begin
            for (int i = 0; i < DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER; i = i + 1)
            begin
               if (DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT[i] == HIGH)
               begin
                  mux_input_pin_loopback[i] = tdr_data_in[i];
               end
               else
               begin
                  mux_input_pin_loopback[i] = tdr_data_out[i];
               end
            end
         end
      end
      else
      begin
         always_comb
         begin
            for (int i = 0; i < DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER; i = i + 1)
            begin
               if (DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT == HIGH)
               begin
                  mux_input_pin_loopback[i] = tdr_data_in[i];
               end
               else
               begin
                  mux_input_pin_loopback[i] = tdr_data_out[i];
               end
            end
         end   
      end
   endgenerate

   // *********************************************************************
   // shift register implementation - the value of tdi pin will come to this
   // reg during shift_DR state. Implementation support single bit register
   // *********************************************************************
   generate
      if (DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER > 1)
      begin
         always_ff @(posedge atappris_tck or negedge reset_b)
         begin
            if (!reset_b)
            begin
               shift_register <= DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (mtap_fsm_tlrs)
            begin
               shift_register <= DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (mtap_fsm_capture_dr & mtap_irdecoder_drselect)
            begin
               shift_register <= mux_input_pin_loopback;
            end
            else if (mtap_fsm_shift_dr & mtap_irdecoder_drselect)
            begin
               shift_register <= {atappris_tdi, shift_register[(DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):1]};
            end
         end
      end
      else
      begin
         always_ff @(posedge atappris_tck or negedge reset_b)
         begin
            if (!reset_b)
            begin
               shift_register <= DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (mtap_fsm_tlrs)
            begin
               shift_register <= DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (mtap_fsm_capture_dr & mtap_irdecoder_drselect)
            begin
               shift_register <= mux_input_pin_loopback;
            end
            else if (mtap_fsm_shift_dr & mtap_irdecoder_drselect)
            begin
               shift_register <= atappris_tdi;
            end
         end
      end
   endgenerate

   // *********************************************************************
   // Bit0 is assigned to mtap_drreg_drout and this is going to the TDOmux FUB.
   // *********************************************************************
   assign mtap_drreg_drout = shift_register[0];

   // *********************************************************************
   // parallel register implementation - the value will be updated to parallel
   // reg during update_DR state and negedge of tck
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge reset_b)
   begin
      if (!reset_b)
      begin
         tdr_data_out <= DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
      end
      else if (mtap_fsm_tlrs)
      begin
         tdr_data_out <= DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
      end
      else if (mtap_fsm_update_dr & mtap_irdecoder_drselect)
      begin
         tdr_data_out <= shift_register;
      end
   end

   // Assertions and coverage
//kbbhagwa   `include "mtap_data_reg_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
 `include "mtap_data_reg_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif


endmodule
