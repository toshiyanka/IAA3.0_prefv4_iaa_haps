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
//    FILENAME    : stap_drreg.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP DR Register Implementation
//    DESCRIPTION :
//       This module contains all the control and data registers
//       defined by user.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES
//       This defines the decoder select line value for IR all ones
//
//    DRREG_STAP_POSITION_OF_BYPASS_ALL_ZEROS
//       This defines the decoder select line value for IR all zeros
//
//    DRREG_STAP_POSITION_OF_SAMPLE_PRELOAD
//       This defines the decoder select line value for IR equals to SAMPLE_PRELOAD
//
//    DRREG_STAP_POSITION_OF_IDCODE
//       This defines the decoder select line value for IR equals to IDCODE
//
//    DRREG_STAP_POSITION_OF_HIGHZ
//       This defines the decoder select line value for IR equals to HIGHZ
//
//    DRREG_STAP_POSITION_OF_EXTEST
//       This defines the decoder select line value for IR equals to EXTEST
//
//    DRREG_STAP_POSITION_OF_RESIRA
//       This defines the decoder select line value for IR equals to RESIRA
//
//    DRREG_STAP_POSITION_OF_RESIRB
//       This defines the decoder select line value for IR equals to RESIRB
//
//    DRREG_STAP_POSITION_OF_SLVIDCODE
//       This defines the decoder select line value for IR equals to SLVIDCODE
//
//    DRREG_STAP_POSITION_OF_EXTEST_PULSE
//       This defines the decoder select line value for IR equals to EXTEST_PULSE
//
//    DRREG_STAP_POSITION_OF_EXTEST_TRAIN
//       This defines the decoder select line value for IR equals to EXTEST_TRAIN
//
//    DRREG_STAP_POSITION_OF_TAPC_SELECT
//       This defines the decoder select line value for IR equals to TAPC_SELECT
//
//    DRREG_STAP_POSITION_OF_PRELOAD
//       This defines the decoder select line value for IR equals to PRELOAD
//
//    DRREG_STAP_POSITION_OF_CLAMP
//       This defines the decoder select line value for IR equals to CLAMP
//
//    DRREG_STAP_POSITION_OF_USERCODE
//       This defines the decoder select line value for IR equals to USERCODE
//
//    DRREG_STAP_POSITION_OF_INTEST
//       This defines the decoder select line value for IR equals to INTEST
//
//    DRREG_STAP_POSITION_OF_RUNBIST
//       This defines the decoder select line value for IR equals to RUNBIST
//
//    DRREG_STAP_POSITION_OF_EXTEST_TOGGLE
//       This defines the decoder select line value for IR equals to TOGGLE
//
//    DRREG_STAP_POSITION_OF_SEC_SEL
//       This defines the decoder select line value for IR equals to SEC_SEL
//
//    DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR
//       This defines the decoder select line value for IR equals to WTAPNW_SELECTWIR
//
//    DRREG_STAP_POSITION_OF_TAPC_VISAOVR
//       This defines the decoder select line value for IR equals to TAPC_VISAOVR
//
//    DRREG_STAP_POSITION_OF_TAPC_REMOVE
//       This defines the decoder select line value for IR equals to TAPC_REMOVE
//
//    DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER
//       This defines the decoder select line value for IR equals to TEST_DATA_REGISTER
//
//----------------------------------------------------------------------
module stap_drreg
   #(
   parameter DRREG_STAP_ENABLE_VERCODE                            = 1,
   parameter DRREG_STAP_ENABLE_TEST_DATA_REGISTERS                = 1,
   parameter DRREG_STAP_ENABLE_TAPC_VISAOVR                       = 0,
   parameter DRREG_STAP_ENABLE_TAPC_REMOVE                        = 0,
   parameter DRREG_STAP_WIDTH_OF_SLVIDCODE                        = 32,
   parameter DRREG_STAP_WIDTH_OF_VERCODE                          = 4,
   parameter DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS                 = 0,
   parameter DRREG_STAP_NUMBER_OF_MANDATORY_REGISTERS             = 0,
   parameter DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE                  = 0,
   parameter DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS        = 0,
   parameter DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           = 0,
   parameter DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS         = 0,
   parameter DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS         = 0,
   parameter DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       = 0,
   parameter DRREG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = 0,
   parameter DRREG_STAP_NUMBER_OF_TAP_NETWORK_REGISTERS           = 2,
   parameter DRREG_STAP_NUMBER_OF_TAPS                            = 1,
   parameter DRREG_STAP_NUMBER_OF_WTAPS                           = 1,
   parameter DRREG_STAP_WIDTH_OF_TAPC_VISAOVR                     = 42,
   parameter DRREG_STAP_WIDTH_OF_TAPC_REMOVE                      = 1,
   parameter DRREG_STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS          = 1,
   parameter DRREG_STAP_ENABLE_TAPC_SEC_SEL                       = 0,
   parameter DRREG_STAP_ENABLE_WTAP_NETWORK                       = 0,
   parameter DRREG_STAP_ENABLE_TAP_NETWORK                        = 0,
   parameter DRREG_STAP_COUNT_OF_TAPC_VISAOVR_REGISTERS           = 0,
   parameter DRREG_STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS           = 0,
   parameter DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS               = 0,
   parameter DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS                 = 0,
   //parameter DRREG_STAP_NUMBER_OF_USERCODE_REGISTERS              = 0,
   parameter DRREG_STAP_NUMBER_OF_INTEST_REGISTERS                = 0,
   parameter DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS               = 0,
   parameter DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS         = 0,
   parameter DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2              = 1,
   parameter DRREG_STAP_ENABLE_BSCAN                              = 1,
   parameter DRREG_STAP_NUMBER_OF_TAP_SELECT_REGISTERS            = 1,
   parameter DRREG_STAP_WIDTH_OF_TAPC_VISAOVR_ADDRESS             = 0,
   parameter DRREG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA                = 0,
   parameter DRREG_STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS          = 0,
   parameter DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS             = 0,
   parameter DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ   = 0,
   parameter DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS      = 0,
   parameter DRREG_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS         = 0,
   parameter DRREG_STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR        = 2'b00
   )
   (
   input  logic                                                               stap_fsm_tlrs,
   input  logic                                                               ftap_tdi,
   input  logic                                                               ftap_tck,
   input  logic                                                               powergoodrst_b,
   input  logic                                                               powergoodrst_trst_b,
   input  logic                                                               stap_fsm_capture_dr,
   input  logic                                                               stap_fsm_capture_dr_nxt, //kbbhagwa cdc fix
   input  logic                                                               stap_fsm_shift_dr,
   //input  logic stap_fsm_shift_dr_neg, //kbbhagwa hsd2904953 posneg rtdr
   input  logic                                                               stap_fsm_update_dr,
   input  logic                                                               stap_fsm_update_dr_nxt, //kbbhagwa cdc fix
   input  logic                                                               stap_selectwir,
   input  logic [(DRREG_STAP_WIDTH_OF_VERCODE - 1):0]                         ftap_vercode,
   input  logic [(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):0]                       ftap_slvidcode,
   input  logic [(DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                stap_irdecoder_drselect,
   input  logic [(DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0]       tdr_data_in,
   output logic [(DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0]       tdr_data_out,
   output logic [(DRREG_STAP_NUMBER_OF_TAPS - 1):0]                           sftapnw_ftap_secsel,
   output logic [(DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0]             tapc_select,
   output logic [(DRREG_STAP_NUMBER_OF_WTAPS - 1):0]                          tapc_wtap_sel,
   output logic [(DRREG_STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS - 1):0]
                [(DRREG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA - 1):0]               tapc_visaovr,
   output logic                                                               tapc_remove,
   output logic [(DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                stap_drreg_drout,
   input  logic                                                               stap_and_all_bits_irreg,
   input  logic                                                               stap_or_all_bits_irreg,
   input  logic                                                               stap_fsm_rti,
   input  logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  rtdr_tap_ip_clk_i,
   input  logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  rtdr_tap_tdo,
   output logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_tdi,
   output logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_capture,
   output logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_shift,
   output logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_update,
   output logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_irdec,
   output logic                                                               tap_rtdr_selectir,
   output logic                                                               tap_rtdr_powergoodrst_b,
   output logic                                                               tap_rtdr_rti
   );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH         = 1'b1;
   localparam LOW          = 1'b0;
   localparam TWO_ZERO     = 2'b00;
   localparam THIRY_ONE    = 31;
   localparam TWENTY_EIGHT = 28;
   localparam SIXTEEN_ONE  = 16'd1;
   // ---------------------------------------------------------------------
   // Register positions
   // ---------------------------------------------------------------------
   localparam DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES           = 0;
   localparam DRREG_STAP_POSITION_OF_BYPASS_ALL_ZEROS          = 1;
   localparam DRREG_STAP_POSITION_OF_SAMPLE_PRELOAD            = 2;
   //localparam DRREG_STAP_POSITION_OF_IDCODE                    = 3;
   localparam DRREG_STAP_POSITION_OF_HIGHZ                     = 3;
   localparam DRREG_STAP_POSITION_OF_EXTEST                    = 4;
   //localparam DRREG_STAP_POSITION_OF_RESIRA                    = 6;
   //localparam DRREG_STAP_POSITION_OF_RESIRB                    = 7;
   localparam DRREG_STAP_POSITION_OF_SLVIDCODE                 =
      (DRREG_STAP_ENABLE_BSCAN == 1) ? 5 : 2;
   localparam DRREG_STAP_POSITION_OF_EXTEST_PULSE              = 6;
   localparam DRREG_STAP_POSITION_OF_EXTEST_TRAIN              = 7;
   localparam DRREG_STAP_POSITION_OF_TAPC_SELECT               =
      (DRREG_STAP_ENABLE_TAP_NETWORK == 1)      ? DRREG_STAP_NUMBER_OF_MANDATORY_REGISTERS :
      (DRREG_STAP_NUMBER_OF_MANDATORY_REGISTERS - DRREG_STAP_NUMBER_OF_TAP_SELECT_REGISTERS);
   localparam DRREG_STAP_POSITION_OF_PRELOAD                   =
      DRREG_STAP_POSITION_OF_TAPC_SELECT        + DRREG_STAP_NUMBER_OF_TAP_SELECT_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_CLAMP                     =
      DRREG_STAP_POSITION_OF_PRELOAD                           +
      DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS;
   //localparam DRREG_STAP_POSITION_OF_USERCODE                  =
   //   DRREG_STAP_POSITION_OF_CLAMP                             +
   //   DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS;
   //localparam DRREG_STAP_POSITION_OF_INTEST                    =
   //   DRREG_STAP_POSITION_OF_USERCODE                          +
   //   DRREG_STAP_NUMBER_OF_USERCODE_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_INTEST                    =
      DRREG_STAP_POSITION_OF_CLAMP                          +
      DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_RUNBIST                   =
      DRREG_STAP_POSITION_OF_INTEST                            +
      DRREG_STAP_NUMBER_OF_INTEST_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_EXTEST_TOGGLE             =
      DRREG_STAP_POSITION_OF_RUNBIST                           +
      DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_SEC_SEL                   =
      DRREG_STAP_POSITION_OF_EXTEST_TOGGLE                     +
      DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR          =
      DRREG_STAP_POSITION_OF_SEC_SEL                           +
      DRREG_STAP_NUMBER_OF_TAP_NETWORK_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_TAPC_VISAOVR              =
      DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR                  +
      DRREG_STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_TAPC_REMOVE               =
      DRREG_STAP_POSITION_OF_TAPC_VISAOVR                      +
      DRREG_STAP_COUNT_OF_TAPC_VISAOVR_REGISTERS;
   localparam DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER =
      DRREG_STAP_POSITION_OF_TAPC_REMOVE                       +
      DRREG_STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS;
   localparam DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER  =
      DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER           +
      DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS;
      //DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS;
   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):0]        slvidcode_reset_value;
   logic                                                reset_pulse;
   logic                                                bypass_reg;
   logic [(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):0]        slvidcode_reg;
   logic                                                reset_pulse0;
   logic                                                reset_pulse1;
   logic                                                irdecoder_drselect;
   logic                                                tapc_select_tlrs;
   logic                                                stap_fsm_rti_NC;
   logic [(DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0] stap_irdecoder_drsel_NC;
   logic                                                ftap_slvidcode0_NC;
   logic                                                stap_selectwir_NC;
   logic                                                rtdr_tap_ip_clk_i_NC;
   logic                                                rtdr_tap_tdo_NC;
   logic                                                stap_fsm_update_dr_nxt_NC;
   logic                                                stap_fsm_cap_dr_nxt_NC;

   // *********************************************************************
   // dummification 
   // *********************************************************************
   assign stap_irdecoder_drsel_NC = stap_irdecoder_drselect;
   // *********************************************************************
   // This logic selects IR decoder signal depending on IRREG values are all
   // HIGH or LOW
   // *********************************************************************
   assign irdecoder_drselect =
      (stap_and_all_bits_irreg == HIGH) ? stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES]  :
      (stap_or_all_bits_irreg  == LOW)  ? stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_BYPASS_ALL_ZEROS] :
       stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES];

   // *********************************************************************
   // BYPASS register implementation
   // If part: The bypass register is cleared in Capture_DR state if the
   // IR decoder is selecting the bypass reg
   // Else part: The data will be shifted from the tdi pin in the
   // shift_DR state
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         bypass_reg <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         bypass_reg <= LOW;
      end
      else if (stap_fsm_capture_dr & irdecoder_drselect)
      begin
         bypass_reg <= LOW;
      end
      else if (stap_fsm_shift_dr & irdecoder_drselect)
      begin
         bypass_reg <= ftap_tdi;
      end
   end
   
   // *********************************************************************
   // stap_drreg_drout implementation for bits all ones and all zeros
   // *********************************************************************
   assign stap_drreg_drout[DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES]  =
      (stap_and_all_bits_irreg                                         == HIGH) ? bypass_reg :
      (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES] == HIGH) ? bypass_reg : LOW;
   assign stap_drreg_drout[DRREG_STAP_POSITION_OF_BYPASS_ALL_ZEROS] =
      (stap_or_all_bits_irreg                                          == LOW)  ? bypass_reg : LOW;

   // *********************************************************************
   // Dummy assignments to avoid lintra warnings
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_BSCAN == 1)
      begin
         assign stap_drreg_drout[DRREG_STAP_POSITION_OF_SAMPLE_PRELOAD] = LOW;
         //assign stap_drreg_drout[DRREG_STAP_POSITION_OF_IDCODE]         = LOW;
         assign stap_drreg_drout[DRREG_STAP_POSITION_OF_HIGHZ]          = LOW;
         assign stap_drreg_drout[DRREG_STAP_POSITION_OF_EXTEST]         = LOW;
         //assign stap_drreg_drout[DRREG_STAP_POSITION_OF_RESIRA]         = LOW;
         //assign stap_drreg_drout[DRREG_STAP_POSITION_OF_RESIRB]         = LOW;
         assign stap_drreg_drout[DRREG_STAP_POSITION_OF_EXTEST_PULSE]   = LOW;
         assign stap_drreg_drout[DRREG_STAP_POSITION_OF_EXTEST_TRAIN]   = LOW;

         if (DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS > 0)
         begin
            assign stap_drreg_drout[DRREG_STAP_POSITION_OF_PRELOAD] = LOW;
         end
         if (DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS > 0)
         begin
            assign stap_drreg_drout[DRREG_STAP_POSITION_OF_CLAMP] = LOW;
         end
         //if (DRREG_STAP_NUMBER_OF_USERCODE_REGISTERS > 0)
         //begin
         //   assign stap_drreg_drout[DRREG_STAP_POSITION_OF_USERCODE] = LOW;
         //end
         if (DRREG_STAP_NUMBER_OF_INTEST_REGISTERS > 0)
         begin
            assign stap_drreg_drout[DRREG_STAP_POSITION_OF_INTEST] = LOW;
         end
         if (DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS > 0)
         begin
            assign stap_drreg_drout[DRREG_STAP_POSITION_OF_RUNBIST] = LOW;
         end
         if (DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS > 0)
         begin
            assign stap_drreg_drout[DRREG_STAP_POSITION_OF_EXTEST_TOGGLE] = LOW;
         end
      end
   endgenerate

   // *********************************************************************
   // Reset pulse generation logic. To avoid lintra error which complains about
   // loading pin values during reset
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         reset_pulse0 <= LOW;
         reset_pulse1 <= LOW;
      end
      else
      begin
         reset_pulse0 <= HIGH;
         reset_pulse1 <= reset_pulse0;
      end
   end

   assign reset_pulse = reset_pulse0 & (~reset_pulse1);

   // *********************************************************************
   // Generation of ftap_slvidcode reset value. If ftap_vercode enabled 4 msb bits of
   // SLVIDCODE registers are occupied by ftap_vercode pins
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_VERCODE == 1)
      begin
         assign slvidcode_reset_value = {ftap_vercode, 
                                         ftap_slvidcode[(DRREG_STAP_WIDTH_OF_SLVIDCODE -
                                            DRREG_STAP_WIDTH_OF_VERCODE - 1):1], HIGH};
         logic [3:0] ftap_slvidcode_NC;
         assign ftap_slvidcode_NC     = ftap_slvidcode[THIRY_ONE:TWENTY_EIGHT];
      end
      else
      begin
         assign slvidcode_reset_value = { ftap_slvidcode[(DRREG_STAP_WIDTH_OF_SLVIDCODE  -1):1], HIGH};
      end
   endgenerate

   assign ftap_slvidcode0_NC      = ftap_slvidcode[0];
   //generate
   //   if (DRREG_STAP_ENABLE_VERCODE == 1)
   //   begin
   //      assign slvidcode_reset_value = {ftap_vercode, LOW,
   //                                      ftap_slvidcode[(DRREG_STAP_WIDTH_OF_SLVIDCODE -
   //                                         DRREG_STAP_WIDTH_OF_VERCODE - 1 - 1):1], HIGH};
   //      logic [3:0] ftap_slvidcode_NC;
   //      assign ftap_slvidcode_NC     = ftap_slvidcode[THIRY_ONE:TWENTY_EIGHT];
   //   end
   //   else
   //   begin
   //      assign slvidcode_reset_value = {ftap_slvidcode[(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):
   //                                                     (DRREG_STAP_POSITION_OF_SLVIDCODE_BIT_LOW)], LOW,
   //                                      ftap_slvidcode[(DRREG_STAP_POSITION_OF_SLVIDCODE_BIT_LOW - 1 -1):1], HIGH};
   //   end
   //endgenerate

   //assign ftap_slvidcode27_NC     = ftap_slvidcode[TWENTY_SEVEN];
   //assign ftap_slvidcode0_NC      = ftap_slvidcode[0];
   // *********************************************************************
   // IDCODE register implementation
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         slvidcode_reg <= {{(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1){LOW}}, HIGH};
      end
      else if (reset_pulse)
      begin
         slvidcode_reg <= slvidcode_reset_value;
      end
      else if (stap_fsm_tlrs)
      begin
         slvidcode_reg <= slvidcode_reset_value;
      end
      else if (stap_fsm_capture_dr & stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_SLVIDCODE])
      begin
         slvidcode_reg <= slvidcode_reset_value;
      end
      else if (stap_fsm_shift_dr & stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_SLVIDCODE])
      begin
         slvidcode_reg <= {ftap_tdi, slvidcode_reg[(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):1]};
      end
   end
   // ---------------------------------------------------------------------
   // stap_drreg_drout[DRREG_STAP_POSITION_OF_SLVIDCODE] is going to the TDOmux FUB.
   // ---------------------------------------------------------------------
   assign stap_drreg_drout[DRREG_STAP_POSITION_OF_SLVIDCODE] = slvidcode_reg[0];


   // *********************************************************************
   // sftapnw_ftap_secsel register implementation.
   // Module stap_data_reg is instantiated to create register sftapnw_ftap_secsel.
   // This register is generated only if tap nework is enabled and
   // secondary register is enabled.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAP_NETWORK == 1)
      begin
         if (DRREG_STAP_ENABLE_TAPC_SEC_SEL == 1)
         begin
            stap_data_reg #(
                            .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_NUMBER_OF_TAPS),
                            .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_NUMBER_OF_TAPS{LOW}}),
                            .DATA_REG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_STAP_NUMBER_OF_TAPS{LOW}})
                           )
            i_stap_data_reg_tapc_sec_sel (
                                          .stap_fsm_tlrs           (LOW),
                                          .ftap_tck                (ftap_tck),
                                          .ftap_tdi                (ftap_tdi),
                                          .reset_b                 (powergoodrst_b),
                                          .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_SEC_SEL]),
                                          .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                          .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                          .stap_fsm_update_dr      (stap_fsm_update_dr),
                                          .tdr_data_in             ({DRREG_STAP_NUMBER_OF_TAPS{LOW}}),
                                          .stap_drreg_drout        (stap_drreg_drout[DRREG_STAP_POSITION_OF_SEC_SEL]),
                                          .tdr_data_out            (sftapnw_ftap_secsel)
                                         );
         end
         else
         begin
            assign sftapnw_ftap_secsel[(DRREG_STAP_NUMBER_OF_TAPS - 1):0] = {DRREG_STAP_NUMBER_OF_TAPS{LOW}};
         end
      end
      else
      begin
         assign sftapnw_ftap_secsel[(DRREG_STAP_NUMBER_OF_TAPS - 1):0] = {DRREG_STAP_NUMBER_OF_TAPS{LOW}};
      end
   endgenerate

   // *********************************************************************
   // tapc_select_tlrs signal generation
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAPC_REMOVE == 1)
      begin
         assign tapc_select_tlrs = stap_fsm_tlrs & (~tapc_remove);
      end
      else
      begin
         assign tapc_select_tlrs = stap_fsm_tlrs;
      end
   endgenerate

   // *********************************************************************
   // tapc_select register implementation.
   // Module stap_data_reg is instantiated to create register tapc_select.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAP_NETWORK == 1)
      begin
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}}),
                         .DATA_REG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}})
                        )
         i_stap_data_reg_tapc_select (
                                      .stap_fsm_tlrs           (LOW),
                                      .ftap_tck                (ftap_tck),
                                      .ftap_tdi                (ftap_tdi),
                                      .reset_b                 (powergoodrst_b),
                                      .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_SELECT]),
                                      .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                      .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                      .stap_fsm_update_dr      (stap_fsm_update_dr),
                                      .tdr_data_in             ({DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}}),
                                      .stap_drreg_drout        (stap_drreg_drout[DRREG_STAP_POSITION_OF_TAPC_SELECT]),
                                      .tdr_data_out            (tapc_select)
                                     );
      end
      else
      begin
         assign tapc_select[(DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0] = TWO_ZERO;
      end
   endgenerate

   // *********************************************************************
   // tapc_wtap_sel register implementation.
   // Module stap_data_reg is instantiated to create register tapc_wtap_sel.
   // This register is generated only if wtap nework is enabled.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_WTAP_NETWORK == 1)
      begin
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_NUMBER_OF_WTAPS),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_NUMBER_OF_WTAPS{LOW}}),
                         .DATA_REG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_STAP_NUMBER_OF_WTAPS{LOW}})
                        )
         i_stap_data_reg_tapc_wtap_sel (
                                        .stap_fsm_tlrs           (LOW),
                                        .ftap_tck                (ftap_tck),
                                        .ftap_tdi                (ftap_tdi),
                                        .reset_b                 (powergoodrst_b),
                                        .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR]),
                                        .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                        .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                        .stap_fsm_update_dr      (stap_fsm_update_dr),
                                        .tdr_data_in             ({DRREG_STAP_NUMBER_OF_WTAPS{LOW}}),
                                        .stap_drreg_drout        (stap_drreg_drout[DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR]),
                                        .tdr_data_out            (tapc_wtap_sel)
                                       );
      end
      else
      begin
         assign tapc_wtap_sel[0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // tapc_visaovr register implementation.
   // Module stap_data_reg is instantiated to create register tapc_visaovr.
   // This register is generated only if Visa select override is enabled.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAPC_VISAOVR == 1)
      begin
         stap_visa #(
                     .VISA_STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS (DRREG_STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS),
                     .VISA_STAP_WIDTH_OF_TAPC_VISAOVR_ADDRESS    (DRREG_STAP_WIDTH_OF_TAPC_VISAOVR_ADDRESS),
                     .VISA_STAP_WIDTH_OF_TAPC_VISAOVR_DATA       (DRREG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA)
                    )
         i_stap_visa (
                      .ftap_tck                (ftap_tck),
                      .ftap_tdi                (ftap_tdi),
                      .powergoodrst_b          (powergoodrst_b),
                      .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_VISAOVR]),
                      .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                      .stap_fsm_update_dr      (stap_fsm_update_dr),
                      .stap_drreg_drout        (stap_drreg_drout[DRREG_STAP_POSITION_OF_TAPC_VISAOVR]),
                      .tdr_data_out            (tapc_visaovr)
                     );
      end
      else
      begin
         assign tapc_visaovr[0][0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // tapc_remove register implementation.
   // Module stap_data_reg is instantiated to create register tapc_remove.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAPC_REMOVE == 1)
      begin
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_WIDTH_OF_TAPC_REMOVE),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_WIDTH_OF_TAPC_REMOVE{LOW}}),
                         .DATA_REG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_STAP_WIDTH_OF_TAPC_REMOVE{LOW}})
                        )
         i_stap_data_reg_tapc_remove (
                                      .stap_fsm_tlrs           (LOW),
                                      .ftap_tck                (ftap_tck),
                                      .ftap_tdi                (ftap_tdi),
                                      .reset_b                 (powergoodrst_b),
                                      .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_REMOVE]),
                                      .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                      .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                      .stap_fsm_update_dr      (stap_fsm_update_dr),
                                      .tdr_data_in             ({DRREG_STAP_WIDTH_OF_TAPC_REMOVE{LOW}}),
                                      .stap_drreg_drout        (stap_drreg_drout[DRREG_STAP_POSITION_OF_TAPC_REMOVE]),
                                      .tdr_data_out            (tapc_remove)
                                     );
      end
      else
      begin
         assign tapc_remove = {DRREG_STAP_WIDTH_OF_TAPC_REMOVE{LOW}};
      end
   endgenerate

   // *********************************************************************
   // Generate construct is used to generate number of registers required.
   // No of registers equal to DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS are generated.
   // Width of each register depends on value of DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER, which is
   // defined as parameter (user defined).
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TEST_DATA_REGISTERS == 1)
      begin
         for (genvar i = DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER; i < (DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS); i = i + 1)
         begin
               stap_data_reg #(
                               .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER
                                  (DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER[
                                     ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                     ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]),
                               .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS
                                  (DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS[
                                     (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                        ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                        ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                     (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                        ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                        ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])]),
                               .DATA_REG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT
                                  (DRREG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT[
                                     (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                        ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                        ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                     (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                        ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                        ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])])
                               )
               i_stap_data_reg (
                                .stap_fsm_tlrs           (LOW),
                                .ftap_tck                (ftap_tck),
                                .ftap_tdi                (ftap_tdi),
                                .reset_b                 (powergoodrst_b),
                                .stap_irdecoder_drselect (stap_irdecoder_drselect[i]),
                                .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                .stap_fsm_update_dr      (stap_fsm_update_dr),
                                .tdr_data_in             (tdr_data_in[
                                                            (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                               ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                               ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                                            (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                               ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                               ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])]),
                                .stap_drreg_drout        (stap_drreg_drout[i]),
                                .tdr_data_out            (tdr_data_out[
                                                            (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                               ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                               ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                                            (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                               ((((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                               ((i - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                                  DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])])
                               );
         end
      end
      else
      begin
         assign tdr_data_out[0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // Generate construct is used to generate Control signals for Remote test data register
   // no of times each conntrol signal is generated is  = DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 1)
      begin
         for (genvar i = DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER; i < (DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS); i = i + 1)
         begin

         stap_remote_data_reg #(
               .DATA_STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR_BIT 
                    (DRREG_STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER])
               )
         i_stap_remote_data_reg (
                      .ftap_tdi                 (ftap_tdi),
                      .ftap_tck                 (ftap_tck), //kbbhagwa cdc fix
                      .powergoodrst_b           (powergoodrst_b),
                      .stap_irdecoder_drselect  (stap_irdecoder_drselect[i]),
                      .stap_fsm_shift_dr        (stap_fsm_shift_dr),
                      //.stap_fsm_shift_dr_neg    (stap_fsm_shift_dr_neg), //kbbhagwa hsd2904953 posneg rtdr
                      .stap_fsm_capture_dr      (stap_fsm_capture_dr),
                      .stap_fsm_capture_dr_nxt  (stap_fsm_capture_dr_nxt), //kbbhagwa cdc fix
                      .stap_fsm_update_dr_nxt   (stap_fsm_update_dr_nxt), //kbbhagwa cdc fix
                      .stap_fsm_update_dr       (stap_fsm_update_dr),
                      .stap_drreg_drout         (stap_drreg_drout[i]),
                      //.tap_rtdr_tdi            (tap_rtdr_tdi[i-23]),
                      .rtdr_tap_ip_clk_i        (rtdr_tap_ip_clk_i[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .rtdr_tap_tdo             (rtdr_tap_tdo[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_tdi             (tap_rtdr_tdi[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_capture         (tap_rtdr_capture[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_shift           (tap_rtdr_shift[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_update          (tap_rtdr_update[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_irdec           (tap_rtdr_irdec[i-DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER])
                     );
          end
          // *********************************************************************
          // Feed through powergoodrst_b to the remote test data register
          // *********************************************************************
          assign tap_rtdr_powergoodrst_b = powergoodrst_b;
          assign tap_rtdr_selectir       = stap_selectwir;
          assign tap_rtdr_rti            = stap_fsm_rti;
      end
      else
      begin
         assign tap_rtdr_tdi               = HIGH; 
         assign tap_rtdr_capture           = LOW;  
         assign tap_rtdr_shift             = LOW;  
         assign tap_rtdr_update            = LOW;  
         assign tap_rtdr_irdec             = LOW;  
         assign tap_rtdr_powergoodrst_b    = HIGH;  
         assign tap_rtdr_rti               = LOW;  
         assign tap_rtdr_selectir          = LOW;  
         assign stap_fsm_rti_NC            = stap_fsm_rti;  
         assign stap_selectwir_NC          = stap_selectwir;  
         assign rtdr_tap_ip_clk_i_NC       = rtdr_tap_ip_clk_i[0];  
         assign rtdr_tap_tdo_NC            = rtdr_tap_tdo[0];  
         assign stap_fsm_cap_dr_nxt_NC     = stap_fsm_capture_dr_nxt  ;  
         assign stap_fsm_update_dr_nxt_NC  = stap_fsm_update_dr_nxt;  
      end
   endgenerate


   // Assertions and coverage
//   `include "stap_drreg_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
   `include "stap_drreg_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif



endmodule
