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
//    FILENAME    : stap_decoder.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP Decoder Logic
//    DESCRIPTION :
//       This module is generic decoder of all the registers in the design.
//       This module is used within IRdecoder module to generate number of
//       select lines equal to number of registers.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    DECODER_STAP_SIZE_OF_COLOR_CODE
//       This parameter specifies the size of the security color code.
//----------------------------------------------------------------------
module stap_decoder
   #(
   parameter DECODER_INSTRUCTION_TO_DECODE         = 1,
   parameter DECODER_STAP_SIZE_OF_EACH_INSTRUCTION = 8,
   parameter DECODER_STAP_DFX_SECURE_POLICY_OPCODE = 2'b00,
   parameter DECODER_STAP_SECURE_GREEN             = 2'b00,
   parameter DECODER_STAP_SECURE_ORANGE            = 2'b01,
   parameter DECODER_STAP_SECURE_RED               = 2'b10
   )
   (
   input  logic [(DECODER_STAP_SIZE_OF_EACH_INSTRUCTION - 1):0] stap_irreg_ireg,
   output logic                                                 decoder_drselect,
   input  logic                                                 feature_green_en,
   input  logic                                                 feature_orange_en,
   input  logic                                                 feature_red_en
   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;
   localparam DECODER_STAP_SIZE_OF_COLOR_CODE  = 2;
   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [(DECODER_STAP_SIZE_OF_COLOR_CODE - 1):0] security_level;
   logic                                           green_en;
   logic                                           ornage_en;


   assign green_en   = (feature_green_en | feature_orange_en | feature_red_en);
   assign ornage_en  = (feature_orange_en | feature_red_en);

   assign security_level =  DECODER_STAP_DFX_SECURE_POLICY_OPCODE;

   // *********************************************************************
   // This generates decoder output by comparing with DECODER_INSTRUCTION_TO_DECODE.
   // This is overriden by STAP_INSTRUCTION_FOR_DATA_REGISTERS in stap_IRdecoder
   // module. Value of output is HIGH if address matches with the input and
   // is LOW otherwise.
   // *********************************************************************
   //assign decoder_drselect = (stap_irreg_ireg == DECODER_INSTRUCTION_TO_DECODE) ? HIGH : LOW;

  always_comb
  begin
    case (security_level)
    DECODER_STAP_SECURE_RED:
    begin
      if (feature_red_en)
        decoder_drselect = (stap_irreg_ireg == DECODER_INSTRUCTION_TO_DECODE) ? HIGH : LOW;
      else
        decoder_drselect = LOW;
    end
    DECODER_STAP_SECURE_ORANGE:
    begin
      if (ornage_en)
        decoder_drselect = (stap_irreg_ireg == DECODER_INSTRUCTION_TO_DECODE) ? HIGH : LOW;
      else
        decoder_drselect = LOW;
    end
    DECODER_STAP_SECURE_GREEN:
    begin
      if (green_en)
        decoder_drselect = (stap_irreg_ireg == DECODER_INSTRUCTION_TO_DECODE) ? HIGH : LOW;
      else
         decoder_drselect = LOW;
    end
    default:
    begin
      decoder_drselect = LOW;
    end
    endcase
  end  

endmodule
