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
//    FILENAME    : mtap_irreg.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//    
//    
//    PURPOSE     : MTAP IR Register
//    DESCRIPTION :
//       This module stored the instruction register by shifting tdi
//       signal and is controlled by fsm.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    IRREG_MTAP_ADDRESS_OF_IDCODE
//       This is address of optional IDCODE register.
//
//    IRREG_MTAP_ADDRESS_OF_SLVIDCODE
//       This is address of optional SLVIDCODE register.
//
//    TWO
//       This is number 2 to and is declared just to avoid lint warnings
//
//    TWO_LSB_BITS_OF_IR
//       This is 2 bit 01 value to and is declared just to avoid lint warnings
//----------------------------------------------------------------------
module mtap_irreg #( parameter IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION       = 8,
                     parameter IRREG_MTAP_INSTRUCTION_FOR_DATA_REGISTERS = 0,
                     parameter IRREG_MTAP_MINIMUM_SIZEOF_INSTRUCTION     = 0
                   )
                  (
                   input  logic                                               mtap_fsm_tlrs,
                   input  logic                                               mtap_fsm_capture_ir,
                   input  logic                                               mtap_fsm_shift_ir,
                   input  logic                                               mtap_fsm_update_ir,
                   input  logic                                               atappris_tdi,
                   input  logic                                               atappris_tck,
                   input  logic                                               powergoodrst_trst_b,
                   output logic [(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0] mtap_irreg_ireg,
                   output logic [(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0] mtap_irreg_ireg_nxt, //kbbhagwa cdc fix
                   output logic                                               mtap_irreg_serial_out,
                   output logic [(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0] mtap_irreg_shift_reg
                  );

   // *********************************************************************
   // Parameters
   // *********************************************************************
   localparam HIGH                            = 1'b1;
   localparam LOW                             = 1'b0;
   localparam IRREG_MTAP_ADDRESS_OF_IDCODE    = (IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h02 :
      {{(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION  - IRREG_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h2};
   localparam IRREG_MTAP_ADDRESS_OF_SLVIDCODE = (IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0C :
      {{(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION  - IRREG_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hC};
   localparam TWO                             = 2;
   localparam TWO_LSB_BITS_OF_IR              = 2'b01;

   // *********************************************************************
   // Registers
   // *********************************************************************
   logic [(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0] shift_reg;

   // *********************************************************************
   // shift register implementation
   // If part: resetting the value of shift reg to 01 during capture_IR state
   // Else part: shifting the tdi pin data
   // *********************************************************************
   always_ff @(posedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         shift_reg <= {{(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - TWO){LOW}}, TWO_LSB_BITS_OF_IR};
      end
      else if (mtap_fsm_tlrs)
      begin
         shift_reg <= {{(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - TWO){LOW}}, TWO_LSB_BITS_OF_IR};
      end
      else if (mtap_fsm_capture_ir)
      begin
         shift_reg <= {{(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - TWO){LOW}}, TWO_LSB_BITS_OF_IR};
      end
      else if (mtap_fsm_shift_ir)
      begin
         shift_reg <= {atappris_tdi, shift_reg[(IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION - 1):1]};
      end
   end

   // *********************************************************************
   // shift_reg data going to bscan
   // *********************************************************************
   assign mtap_irreg_shift_reg = shift_reg;

   // *********************************************************************
   // shift_reg data going to TDOmux FUB
   // *********************************************************************
   assign mtap_irreg_serial_out = shift_reg[0];

   // *********************************************************************
   // parallel register implementation
   // Reset part: resetting the parallel register to all1 vaue - which
   // means bypass instruction will be selected
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         mtap_irreg_ireg <= IRREG_MTAP_ADDRESS_OF_IDCODE;
      end
      else if (mtap_fsm_tlrs)
      begin
         mtap_irreg_ireg <= IRREG_MTAP_ADDRESS_OF_IDCODE;
      end
      else if (mtap_fsm_update_ir)
      begin
         mtap_irreg_ireg <= shift_reg;
      end
   end

//kbbhagwa cdc fix
   always_comb 
   begin
     if ( mtap_fsm_update_ir )
      mtap_irreg_ireg_nxt = shift_reg ;
     else
      mtap_irreg_ireg_nxt = mtap_irreg_ireg;
   end

   //Assertions and coverage
//kbbhagwa   `include "mtap_irreg_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
  `include "mtap_irreg_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif


endmodule
