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
//    FILENAME    : mtap_tdomux.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//    
//    
//    PURPOSE     : MTAP TDO Mux Logic
//    DESCRIPTION :
//       This module converts multi bit wide data signals to serial data out
//       depending on the decoder output. Inturn decoder output is generated
//       depending on instruction register.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    ONE_BIT_UNKNOWN_VALUE
//       This is 1 bit X value to and is declared just to avoid lint warnings
//----------------------------------------------------------------------
module mtap_tdomux #(parameter TDOMUX_MTAP_NUMBER_OF_TOTAL_REGISTERS = 0)
                   (
                    input  logic [TDOMUX_MTAP_NUMBER_OF_TOTAL_REGISTERS-1:0] mtap_drreg_drout,
                    input  logic                                             mtap_fsm_shift_dr,
                    input  logic                                             mtap_fsm_shift_ir,
                    input  logic [TDOMUX_MTAP_NUMBER_OF_TOTAL_REGISTERS-1:0] mtap_irdecoder_drselect,
                    input  logic                                             mtap_irreg_serial_out,
                    input  logic                                             mtap_fsm_tlrs,
                    input  logic                                             atappris_tck,
                    input  logic                                             powergoodrst_trst_b,
                    output logic                                             mtap_mux_tdo,
                    output logic                                             mtap_tdomux_tdoen
                   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH                  = 1'b1;
   localparam LOW                   = 1'b0;
   localparam ONE_BIT_UNKNOWN_VALUE = 1'bX;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic                                             tdo_dr;
   logic                                             mtap_mux_tdo_preflop;
   logic [TDOMUX_MTAP_NUMBER_OF_TOTAL_REGISTERS-1:0] internal_mux_out;

   // *********************************************************************
   // Implementation of tdo mux. All the mtap_drreg_drout are anded bitwise
   // with mtap_irdecoder_drselect. This generates tdo data only on the line
   // selected by mtap_irdecoder_drselect.
   // *********************************************************************
   assign internal_mux_out = (mtap_irdecoder_drselect & mtap_drreg_drout);

   // *********************************************************************
   // ORing of all the internal_mux_out signals generates single tdo out.
   // Basically this is implementation of mux with basic AND-OR structure
   // *********************************************************************
   assign tdo_dr = |internal_mux_out;

   // *********************************************************************
   // TDO MUX between IR shift and DR shift
   // *********************************************************************
   always_comb
   begin
      case (mtap_fsm_shift_ir)
         HIGH:
         begin
            mtap_mux_tdo_preflop = mtap_irreg_serial_out;
         end
         LOW:
         begin
            mtap_mux_tdo_preflop = tdo_dr;
         end
         default:
         begin
            mtap_mux_tdo_preflop = ONE_BIT_UNKNOWN_VALUE;
         end
      endcase
   end

   // *********************************************************************
   // TDO flop
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         mtap_mux_tdo <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         mtap_mux_tdo <= LOW;
      end
      else if (mtap_fsm_shift_ir | mtap_fsm_shift_dr)
      begin
         mtap_mux_tdo <= mtap_mux_tdo_preflop;
      end
   end

   // *********************************************************************
   // TDOen flop
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         mtap_tdomux_tdoen <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         mtap_tdomux_tdoen <= LOW;
      end
      else
      begin
         mtap_tdomux_tdoen <= (mtap_fsm_shift_ir | mtap_fsm_shift_dr);
      end
   end

endmodule
