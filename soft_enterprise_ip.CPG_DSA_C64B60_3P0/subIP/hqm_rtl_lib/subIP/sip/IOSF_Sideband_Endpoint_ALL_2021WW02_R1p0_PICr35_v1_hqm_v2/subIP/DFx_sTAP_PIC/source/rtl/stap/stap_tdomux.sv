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
//    FILENAME    : stap_tdomux.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP TDO Mux Logic
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
//       SBR NOTE: this X values Gives errors with PICr34_S14, even when using
//                 the local param ONE_BIT_UNKNOWN_VALUE
//----------------------------------------------------------------------
module stap_tdomux
   #(
   parameter TDOMUX_STAP_NUMBER_OF_TOTAL_REGISTERS = 0,
   parameter STAP_ENABLE_TDO_POS_EDGE = 0
   )
   (
   input  logic [TDOMUX_STAP_NUMBER_OF_TOTAL_REGISTERS-1:0] stap_drreg_tdo,
   input  logic                                             stap_fsm_shift_dr,
   input  logic                                             stap_fsm_shift_ir,
   input  logic [TDOMUX_STAP_NUMBER_OF_TOTAL_REGISTERS-1:0] stap_irdecoder_drselect,
   input  logic                                             stap_irreg_serial_out,
   input  logic                                             stap_fsm_tlrs,
   input  logic                                             ftap_tck,
   input  logic                                             powergood_rst_trst_b,
   input  logic                                             swcomp_stap_post_tdo,
   input  logic                                             tap_swcomp_active,
   output logic                                             stap_mux_tdo,
   output logic                                             tdo_dr,
   output logic                                             stap_tdomux_tdoen
   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH                  = 1'b1;
   localparam LOW                   = 1'b0;
   // localparam ONE_BIT_UNKNOWN_VALUE = 1'bX; Gives errors with PICr34_S14
   localparam ONE_BIT_UNKNOWN_VALUE = 1'b0;
  

   // *********************************************************************
   // Internal signals
   // *********************************************************************
  // logic                                             tdo_dr;
   logic                                             stap_mux_tdo_preflop;
   logic                                             stap_mux_tdo_preflop_int;
   logic                                             stap_en_tdo_posedge;
   logic [TDOMUX_STAP_NUMBER_OF_TOTAL_REGISTERS-1:0] internal_mux_out;
   logic                                             stap_mux_tdo_int;

   // *********************************************************************
   // Implementation of tdo mux. All the stap_drreg_tdo are anded bitwise
   // with stap_irdecoder_drselect. This generates tdo data only on the line
   // selected by stap_irdecoder_drselect.
   // *********************************************************************
   assign internal_mux_out = (stap_irdecoder_drselect & stap_drreg_tdo);

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
      case (stap_fsm_shift_ir)
         HIGH:
         begin
            stap_mux_tdo_preflop = stap_irreg_serial_out;
         end
         LOW:
         begin
            if(tap_swcomp_active == 1'b0)
            begin
                stap_mux_tdo_preflop = swcomp_stap_post_tdo ;  //Only when tap_swcomp_active is 0, stitch the comparator window between TDI and TDO. Else bypass it. //PCR 1604263740 for SWCOMP Integration
            end
            else
            begin 
                stap_mux_tdo_preflop = tdo_dr ;
            end
         end
         default:
         begin
            stap_mux_tdo_preflop = ONE_BIT_UNKNOWN_VALUE;
         end
      endcase
   end

   // *********************************************************************
   // TDO flop
   // ----------------------------
   // https://vthsd.intel.com/hsd/seg_softip/pcr/default.aspx?pcr_id=57136
   // To implement this PCR, the register stap_mux_tdo_int should be HIGH in
   // all non shift states.
   // *********************************************************************
   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         stap_mux_tdo_int <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         stap_mux_tdo_int <= LOW;
      end
      else if (stap_fsm_shift_ir | stap_fsm_shift_dr)
      begin
         stap_mux_tdo_int <= stap_mux_tdo_preflop;
      end
   end

   // *********************************************************************
   // To qualify the preflop signal with powergood and fsm_tlrs, which is 
   // to be sent on posedge when the retime parameter is enabled
   // *********************************************************************
   always_comb
   begin
      if (!powergood_rst_trst_b)
      begin
         stap_mux_tdo_preflop_int = LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         stap_mux_tdo_preflop_int = LOW;
      end
      //else if (stap_fsm_shift_ir | stap_fsm_shift_dr)
      //begin
      //   stap_mux_tdo_preflop_int = stap_mux_tdo_preflop;
      //end
      else 
      begin
         stap_mux_tdo_preflop_int = stap_mux_tdo_preflop;
      end
   end

   // *********************************************************************
   // TDO to be sent on posedge when the retime parameter is enabled
   // *********************************************************************
   always_comb
      if (STAP_ENABLE_TDO_POS_EDGE == 1)
      begin
         stap_en_tdo_posedge = HIGH;
      end
      else
      begin
         stap_en_tdo_posedge = LOW;
      end

//   stap_ctech_lib_clk_mux_2to1 i_stap_ctech_lib_clk_mux_2to1_tdo_posedge (.clk1(stap_mux_tdo_preflop_int),
//                                                                .clk2(stap_mux_tdo_int),
//                                                                .s(stap_en_tdo_posedge),
//                                                                .clkout(stap_mux_tdo)
//                                                               );
  stap_ctech_lib_mux_2to1 i_stap_ctech_lib_mux_2to1_tdo_posedge (
   .d1(stap_mux_tdo_preflop_int ), .d2(stap_mux_tdo_int ), .s(stap_en_tdo_posedge ), .o(stap_mux_tdo ));

   // *********************************************************************
   // TDOen flop
   // *********************************************************************
   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         stap_tdomux_tdoen <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         stap_tdomux_tdoen <= LOW;
      end
      else
      begin
         stap_tdomux_tdoen <= (stap_fsm_shift_ir | stap_fsm_shift_dr);
      end
   end

endmodule
