//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
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
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_rtdr_ref.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP DR Register Implementation
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
module stap_rtdr_ref
   #(
   parameter DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           = 1,
   parameter DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       = 0
   )
   (
   input  logic                                                         sync_reset,
   input  logic                                                         ftap_tck,
   input  logic                                                         ftap_tdi,
   input  logic                                                         reset_b,
   input  logic                                                         stap_irdecoder_drselect,
   input  logic                                                         stap_fsm_capture_dr,
   input  logic                                                         stap_fsm_shift_dr,
   input  logic                                                         stap_fsm_update_dr,
   input  logic [(DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):0] tdr_data_in,
   output logic                                                         data_reg_tdo,
   output logic [(DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):0] tdr_data_out
   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal Signals
   // *********************************************************************
   logic [(DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):0] shift_register;

   // *********************************************************************
   // shift register implementation - the value of tdi pin will come to this
   // reg during shift_DR state. Implementation support single bit register
   // *********************************************************************
   generate
      if (DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER > 1)
      begin:generate_tdr_shift_capture
         always_ff @(posedge ftap_tck or negedge reset_b)
         begin
            if (!reset_b)
            begin
               shift_register <= DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (sync_reset)
            begin
               shift_register <= DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (stap_fsm_capture_dr & stap_irdecoder_drselect)
            begin
               shift_register <= tdr_data_in;
            end
            else if (stap_fsm_shift_dr & stap_irdecoder_drselect)
            begin
               shift_register <= {ftap_tdi, shift_register[(DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER - 1):1]};
            end
         end
      end
      else
      begin:generate_tdr_shift_capture
         always_ff @(posedge ftap_tck or negedge reset_b)
         begin
            if (!reset_b)
            begin
               shift_register <= DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (sync_reset)
            begin
               shift_register <= DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
            end
            else if (stap_fsm_capture_dr & stap_irdecoder_drselect)
            begin
               shift_register <= tdr_data_in;
            end
            else if (stap_fsm_shift_dr & stap_irdecoder_drselect)
            begin
               shift_register <= ftap_tdi;
            end
         end
      end
   endgenerate

   // *********************************************************************
   // Bit0 is assigned to data_reg_tdo and this is going to the TDOmux FUB.
   // *********************************************************************
   assign data_reg_tdo = shift_register[0];

   // *********************************************************************
   // parallel register implementation - the value will be updated to parallel
   // reg during update_DR state and negedge of tck
   // *********************************************************************
   always_ff @(negedge ftap_tck or negedge reset_b)
   begin
      if (!reset_b)
      begin
         tdr_data_out <= DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
      end
      else if (sync_reset)
      begin
         tdr_data_out <= DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS;
      end
      else if (stap_fsm_update_dr & stap_irdecoder_drselect)
      begin
         tdr_data_out <= shift_register;
      end
   end

endmodule
