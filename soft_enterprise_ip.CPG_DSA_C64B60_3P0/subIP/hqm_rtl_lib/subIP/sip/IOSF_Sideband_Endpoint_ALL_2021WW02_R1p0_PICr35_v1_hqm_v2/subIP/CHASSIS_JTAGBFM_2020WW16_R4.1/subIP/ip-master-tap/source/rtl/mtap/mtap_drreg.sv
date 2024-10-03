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
//    FILENAME    : mtap_drreg.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//    
//    
//    PURPOSE     : MTAP DR Register Implementation
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
//    TWO
//       This is number 2 to and is declared just to avoid lint warnings
//
//    FOUR
//       This is number 4 to and is declared just to avoid lint warnings
//
//    FIVE
//       This is number 5 to and is declared just to avoid lint warnings
//
//    SIX
//       This is number 6 to and is declared just to avoid lint warnings
//
//    SEVEN
//       This is number 7 to and is declared just to avoid lint warnings
//
//    EIGHT
//       This is number 8 to and is declared just to avoid lint warnings
//
//    NINE
//       This is number 9 to and is declared just to avoid lint warnings
//
//    TEN
//       This is number 10 to and is declared just to avoid lint warnings
//
//    DRREG_MTAP_POSITION_OF_BYPASS_ALL_ONES
//       This defines the decoder select line value for IR all ones
//
//    DRREG_MTAP_POSITION_OF_BYPASS_ALL_ZEROS
//       This defines the decoder select line value for IR all zeros
//
//    DRREG_MTAP_POSITION_OF_SAMPLE_PRELOAD
//       This defines the decoder select line value for IR equals to SAMPLE_PRELOAD
//
//    DRREG_MTAP_POSITION_OF_IDCODE
//       This defines the decoder select line value for IR equals to IDCODE
//
//    DRREG_MTAP_POSITION_OF_HIGHZ
//       This defines the decoder select line value for IR equals to HIGHZ
//
//    DRREG_MTAP_POSITION_OF_EXTEST
//       This defines the decoder select line value for IR equals to EXTEST
//
//    DRREG_MTAP_POSITION_OF_RESIRA
//       This defines the decoder select line value for IR equals to RESIRA
//
//    DRREG_MTAP_POSITION_OF_RESIRB
//       This defines the decoder select line value for IR equals to RESIRB
//
//    DRREG_MTAP_POSITION_OF_SLVIDCODE
//       This defines the decoder select line value for IR equals to SLVIDCODE
//
//    DRREG_MTAP_POSITION_OF_EXTEST_PULSE
//       This defines the decoder select line value for IR equals to EXTEST_PULSE
//
//    DRREG_MTAP_POSITION_OF_EXTEST_TRAIN
//       This defines the decoder select line value for IR equals to EXTEST_TRAIN
//
//    DRREG_MTAP_POSITION_OF_CLTAPC_SELECT
//       This defines the decoder select line value for IR equals to CLTAPC_SELECT
//
//    DRREG_MTAP_POSITION_OF_CLTAPC_SELECT_OVR
//       This defines the decoder select line value for IR equals to CLTAPC_SELECT_OVR
//
//    DRREG_MTAP_POSITION_OF_PRELOAD
//       This defines the decoder select line value for IR equals to PRELOAD
//
//    DRREG_MTAP_POSITION_OF_CLAMP
//       This defines the decoder select line value for IR equals to CLAMP
//
//    DRREG_MTAP_POSITION_OF_USERCODE
//       This defines the decoder select line value for IR equals to USERCODE
//
//    DRREG_MTAP_POSITION_OF_INTEST
//       This defines the decoder select line value for IR equals to INTEST
//
//    DRREG_MTAP_POSITION_OF_RUNBIST
//       This defines the decoder select line value for IR equals to RUNBIST
//
//    DRREG_MTAP_POSITION_OF_EXTEST_TOGGLE
//       This defines the decoder select line value for IR equals to TOGGLE
//
//    DRREG_MTAP_POSITION_OF_SEC_SEL
//       This defines the decoder select line value for IR equals to SEC_SEL
//
//    DRREG_MTAP_POSITION_OF_WTAPNW_SELECTWIR
//       This defines the decoder select line value for IR equals to WTAPNW_SELECTWIR
//
//    DRREG_MTAP_POSITION_OF_CLTAPC_VISAOVR
//       This defines the decoder select line value for IR equals to CLTAPC_VISAOVR
//
//    DRREG_MTAP_POSITION_OF_CLTAPC_REMOVE
//       This defines the decoder select line value for IR equals to CLTAPC_REMOVE
//
//    DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER
//       This defines the decoder select line value for IR equals to TEST_DATA_REGISTER
//
//----------------------------------------------------------------------
module mtap_drreg #( parameter DRREG_MTAP_ENABLE_VERCODE                            = 1,
                     parameter DRREG_MTAP_ENABLE_TEST_DATA_REGISTERS                = 1,
                     parameter DRREG_MTAP_ENABLE_CLTAPC_VISAOVR                     = 0,
                     parameter DRREG_MTAP_ENABLE_CLTAPC_REMOVE                      = 0,
                     parameter DRREG_MTAP_WIDTH_OF_IDCODE                           = 32,
                     parameter DRREG_MTAP_WIDTH_OF_VERCODE                          = 4,
                     parameter DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS                 = 0,
                     parameter DRREG_MTAP_NUMBER_OF_MANDATORY_REGISTERS             = 0,
                     parameter DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE                  = 0,
                     parameter DRREG_MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS        = 0,
                     parameter DRREG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           = 0,
                     parameter DRREG_MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS         = 0,
                     parameter DRREG_MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS         = 0,
                     parameter DRREG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       = 0,
                     parameter DRREG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = 0,
                     parameter DRREG_MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS           = 2,
                     parameter DRREG_MTAP_NUMBER_OF_TAPS                            = 1,
                     parameter DRREG_MTAP_NUMBER_OF_WTAPS                           = 1,
                     parameter DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR                   = 42,
                     parameter DRREG_MTAP_WIDTH_OF_CLTAPC_REMOVE                    = 1,
                     parameter DRREG_MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS          = 1,
                     parameter DRREG_MTAP_ENABLE_CLTAPC_SEC_SEL                     = 0,
                     parameter DRREG_MTAP_ENABLE_WTAP_NETWORK                       = 0,
                     parameter DRREG_MTAP_ENABLE_TAP_NETWORK                        = 0,
                     parameter DRREG_MTAP_COUNT_OF_CLTAPC_VISAOVR_REGISTERS         = 0,
                     parameter DRREG_MTAP_NUMBER_OF_CLTAPC_REMOVE_REGISTERS         = 0,
                     parameter DRREG_MTAP_NUMBER_OF_PRELOAD_REGISTERS               = 0,
                     parameter DRREG_MTAP_NUMBER_OF_CLAMP_REGISTERS                 = 0,
                     parameter DRREG_MTAP_NUMBER_OF_USERCODE_REGISTERS              = 0,
                     parameter DRREG_MTAP_NUMBER_OF_INTEST_REGISTERS                = 0,
                     parameter DRREG_MTAP_NUMBER_OF_RUNBIST_REGISTERS               = 0,
                     parameter DRREG_MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS         = 0,
                     parameter DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2              = 1,
                     parameter DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS           = 0,
                     parameter DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA              = 0,
                     parameter DRREG_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS        = 0,
                     parameter DRREG_MTAP_NUMBER_OF_TEST_DATA_REGISTERS             = 0,
                     parameter DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ   = 0,
                     parameter DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS      = 0,
                     parameter DRREG_MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS         = 0,
                     parameter DRREG_MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR        = 2'b00
                   )
                  (
                   input  logic                                                               mtap_fsm_tlrs,
                   input  logic                                                               atappris_tdi,
                   input  logic                                                               atappris_tck,
                   input  logic                                                               powergoodrst_b,
                   input  logic                                                               powergoodrst_trst_b,
                   input  logic                                                               mtap_fsm_capture_dr,
                   input  logic                                                               mtap_fsm_capture_dr_nxt, //kbbhagwa cdc fix
                   input  logic                                                               mtap_fsm_shift_dr,
                   //input  logic                                                               mtap_fsm_shift_dr_neg, //kbbhagwa hsd2904953
                   input  logic                                                               mtap_fsm_update_dr, 
                   input  logic                                                               mtap_fsm_update_dr_nxt, //kbbhagwa cdc fix
                   input  logic                                                               mtap_selectwir,
                   input  logic [(DRREG_MTAP_WIDTH_OF_VERCODE - 1):0] ftap_vercode,
                   input  logic [(DRREG_MTAP_WIDTH_OF_IDCODE - 1):0]                          ftap_idcode,
                   input  logic [(DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                mtap_irdecoder_drselect,
                   input  logic [(DRREG_MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0]       tdr_data_in,
                   input  logic                                                               mtap_and_all_bits_irreg,
                   input  logic                                                               mtap_or_all_bits_irreg,
                   output logic [(DRREG_MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0]       tdr_data_out,
                   output logic [(DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                mtap_drreg_drout,
                   output logic [(DRREG_MTAP_NUMBER_OF_TAPS - 1):0]                           cftapnw_ftap_secsel,
                   output logic [(DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0]             cltapc_select,
                   output logic [(DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0]             cltapc_select_ovr,
                   output logic [(DRREG_MTAP_NUMBER_OF_WTAPS - 1):0]                          cltapc_wtap_sel,
                   output logic [(DRREG_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS - 1):0]
                                [(DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA - 1):0]             cltapc_visaovr,
                   output logic                                                               cltapc_remove,
                   input  logic                                                               mtap_fsm_rti,
                   input  logic [(DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  rtdr_tap_ip_clk_i,
                   input  logic [(DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  rtdr_tap_tdo,
                   output logic [(DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_tdi,
                   output logic [(DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_capture,
                   output logic [(DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_shift,
                   output logic [(DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_update,
                   output logic [(DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  tap_rtdr_irdec,
                   output logic                                                               tap_rtdr_selectir,
                   output logic                                                               tap_rtdr_powergoodrst_b,
                   output logic                                                               tap_rtdr_rti
                  );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH         = 1'b1;
   localparam LOW          = 1'b0;
   localparam TWO          = 2;
   localparam FOUR         = 4;
   localparam FIVE         = 5;
   localparam SIX          = 6;
   localparam SEVEN        = 7;
   localparam EIGHT        = 8;
   localparam NINE         = 9;
   localparam TEN          = 10;
   localparam TWENTY_EIGHT = 28;
   localparam THIRY_ONE    = 31;
   // ---------------------------------------------------------------------
   // Mandatory register positions
   // ---------------------------------------------------------------------
   localparam DRREG_MTAP_POSITION_OF_BYPASS_ALL_ONES              = 0;
   localparam DRREG_MTAP_POSITION_OF_BYPASS_ALL_ZEROS             = 1;
   localparam DRREG_MTAP_POSITION_OF_SAMPLE_PRELOAD               = 2;
   localparam DRREG_MTAP_POSITION_OF_IDCODE                       = 3;
   localparam DRREG_MTAP_POSITION_OF_HIGHZ                        = 4;
   localparam DRREG_MTAP_POSITION_OF_EXTEST                       = 5;
   //localparam DRREG_MTAP_POSITION_OF_RESIRA                 = 6;
   //localparam DRREG_MTAP_POSITION_OF_RESIRB                 = 7;
   //localparam DRREG_MTAP_POSITION_OF_SLVIDCODE              = 8;
   //localparam DRREG_MTAP_POSITION_OF_EXTEST_PULSE           = 9;
   //localparam DRREG_MTAP_POSITION_OF_EXTEST_TRAIN           = 10;
   //localparam DRREG_MTAP_POSITION_OF_CLTAPC_SELECT          = 11;
   //localparam DRREG_MTAP_POSITION_OF_CLTAPC_SELECT_OVR      = 12;
   localparam DRREG_MTAP_POSITION_OF_EXTEST_PULSE                 = 6;
   localparam DRREG_MTAP_POSITION_OF_EXTEST_TRAIN                 = 7;
   localparam DRREG_MTAP_POSITION_OF_CLTAPC_SELECT                = 8;
   localparam DRREG_MTAP_POSITION_OF_CLTAPC_SELECT_OVR            = 9;
   localparam DRREG_MTAP_POSITION_OF_PRELOAD                      =
      DRREG_MTAP_NUMBER_OF_MANDATORY_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_CLAMP                        =
      DRREG_MTAP_POSITION_OF_PRELOAD                              +
      DRREG_MTAP_NUMBER_OF_PRELOAD_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_USERCODE                     =
      DRREG_MTAP_POSITION_OF_CLAMP                                +
      DRREG_MTAP_NUMBER_OF_CLAMP_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_INTEST                       =
      DRREG_MTAP_POSITION_OF_USERCODE                             +
      DRREG_MTAP_NUMBER_OF_USERCODE_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_RUNBIST                      =
      DRREG_MTAP_POSITION_OF_INTEST                               +
      DRREG_MTAP_NUMBER_OF_INTEST_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_EXTEST_TOGGLE                =
      DRREG_MTAP_POSITION_OF_RUNBIST                              +
      DRREG_MTAP_NUMBER_OF_RUNBIST_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_SEC_SEL                      =
      DRREG_MTAP_POSITION_OF_EXTEST_TOGGLE                        +
      DRREG_MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_WTAPNW_SELECTWIR             =
      DRREG_MTAP_POSITION_OF_SEC_SEL                              +
      DRREG_MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_CLTAPC_VISAOVR               =
      DRREG_MTAP_POSITION_OF_WTAPNW_SELECTWIR                     +
      DRREG_MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS;
   localparam DRREG_MTAP_POSITION_OF_CLTAPC_REMOVE                =
      DRREG_MTAP_POSITION_OF_CLTAPC_VISAOVR                       +
      DRREG_MTAP_COUNT_OF_CLTAPC_VISAOVR_REGISTERS;
   localparam DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER    =
      DRREG_MTAP_POSITION_OF_CLTAPC_REMOVE                        +
      DRREG_MTAP_NUMBER_OF_CLTAPC_REMOVE_REGISTERS;
   localparam DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER  =
      DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER            +
      DRREG_MTAP_NUMBER_OF_TEST_DATA_REGISTERS;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [(DRREG_MTAP_WIDTH_OF_IDCODE - 1):0]           idcode_reset_value;
   logic                                                reset_pulse;
   logic                                                bypass_reg;
   logic [(DRREG_MTAP_WIDTH_OF_IDCODE - 1):0]           idcode_reg;
   logic                                                reset_pulse0;
   logic                                                reset_pulse1;
   logic                                                irdecoder_drselect;
   logic                                                cltapc_select_tlrs;
   logic                                                mtap_fsm_rti_NC;
   logic [(DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS - 1):0] mtap_irdecoder_drsel_NC;
   logic                                                ftap_idcode0_NC;
   logic                                                ftap_idcode27_NC;
   logic                                                mtap_selectwir_NC;
   logic                                                rtdr_tap_ip_clk_i_NC;
   logic                                                rtdr_tap_tdo_NC;
   logic                                                mtap_fsm_cap_dr_nxt_NC;
   logic                                                mtap_fsm_update_dr_nxt_NC;

   // *********************************************************************
   // dummification 
   // *********************************************************************
   assign mtap_irdecoder_drsel_NC = mtap_irdecoder_drselect;
 
   // *********************************************************************
   // This logic selects IR decoder signal depending on IRREG values are all
   // HIGH or LOW
   // *********************************************************************
   assign irdecoder_drselect =
      (mtap_and_all_bits_irreg == HIGH) ? mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_BYPASS_ALL_ONES]  :
      (mtap_or_all_bits_irreg  == LOW)  ? mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_BYPASS_ALL_ZEROS] :
       mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_BYPASS_ALL_ONES];

   // *********************************************************************
   // BYPASS register implementation
   // If part: The bypass register is cleared in Capture_DR state if the
   // IR decoder is selecting the bypass reg
   // Else part: The data will be shifted from the tdi pin in the
   // shift_DR state
   // *********************************************************************
   always_ff @(posedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         bypass_reg <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         bypass_reg <= LOW;
      end
      else if (mtap_fsm_capture_dr & irdecoder_drselect)
      begin
         bypass_reg <= LOW;
      end
      else if (mtap_fsm_shift_dr & irdecoder_drselect)
      begin
         bypass_reg <= atappris_tdi;
      end
   end

   // *********************************************************************
   // mtap_drreg_drout implementation for bits all ones and all zeros
   // *********************************************************************
   assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_BYPASS_ALL_ONES]  =
      (mtap_and_all_bits_irreg                                         == HIGH) ? bypass_reg :
      (mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_BYPASS_ALL_ONES] == HIGH) ? bypass_reg : LOW;
   assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_BYPASS_ALL_ZEROS] =
      (mtap_or_all_bits_irreg                                          == LOW)  ? bypass_reg : LOW;

   // *********************************************************************
   // Dummy assignments to avoid lintra warnings
   // *********************************************************************
   assign mtap_drreg_drout[TWO]   = LOW;
   assign mtap_drreg_drout[FOUR]  = LOW;
   assign mtap_drreg_drout[FIVE]  = LOW;
   assign mtap_drreg_drout[SIX]   = LOW;
   assign mtap_drreg_drout[SEVEN] = LOW;
   //assign mtap_drreg_drout[EIGHT] = LOW;
   //assign mtap_drreg_drout[NINE]  = LOW;
   //assign mtap_drreg_drout[TEN]   = LOW;

   generate
      if (DRREG_MTAP_NUMBER_OF_PRELOAD_REGISTERS > 0)
      begin
         assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_PRELOAD] = LOW;
      end
      if (DRREG_MTAP_NUMBER_OF_CLAMP_REGISTERS > 0)
      begin
         assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_CLAMP] = LOW;
      end
      if (DRREG_MTAP_NUMBER_OF_USERCODE_REGISTERS > 0)
      begin
         assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_USERCODE] = LOW;
      end
      if (DRREG_MTAP_NUMBER_OF_INTEST_REGISTERS > 0)
      begin
         assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_INTEST] = LOW;
      end
      if (DRREG_MTAP_NUMBER_OF_RUNBIST_REGISTERS > 0)
      begin
         assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_RUNBIST] = LOW;
      end
      if (DRREG_MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS > 0)
      begin
         assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_EXTEST_TOGGLE] = LOW;
      end
   endgenerate

   // *********************************************************************
   // Reset pulse generation logic. To avoid lintra error which complains about
   // loading pin values during reset
   // *********************************************************************
   always_ff @(posedge atappris_tck or negedge powergoodrst_trst_b)
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
   // Generation of ftap_idcode reset value. If ftap_vercode enabled 4 msb bits of
   // IDCODE registers are occupied by ftap_vercode pins
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_VERCODE == 1)
      begin
         assign idcode_reset_value = {ftap_vercode,
                                         ftap_idcode[(DRREG_MTAP_WIDTH_OF_IDCODE -
                                            DRREG_MTAP_WIDTH_OF_VERCODE - 1):1], HIGH};
         logic [3:0] ftap_idcode_NC;
         assign ftap_idcode_NC  = ftap_idcode[THIRY_ONE:TWENTY_EIGHT];
      end
      else
      begin
         assign idcode_reset_value =  {ftap_idcode[(DRREG_MTAP_WIDTH_OF_IDCODE - 1):1], HIGH};
      end
   endgenerate
   assign ftap_idcode0_NC      = ftap_idcode[0];

   // *********************************************************************
   // IDCODE register implementation
   // *********************************************************************
   always_ff @(posedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         idcode_reg <= {{(DRREG_MTAP_WIDTH_OF_IDCODE - 1){LOW}}, HIGH};
      end
      else if (reset_pulse)
      begin
         idcode_reg <= idcode_reset_value;
      end
      else if (mtap_fsm_tlrs)
      begin
         idcode_reg <= idcode_reset_value;
      end
      else if (mtap_fsm_capture_dr & mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_IDCODE])
      begin
         idcode_reg <= {idcode_reset_value[(DRREG_MTAP_WIDTH_OF_IDCODE - 1):1], HIGH};
      end
      else if (mtap_fsm_shift_dr & mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_IDCODE])
      begin
         idcode_reg <= {atappris_tdi, idcode_reg[(DRREG_MTAP_WIDTH_OF_IDCODE - 1):1]};
      end
   end
   // ---------------------------------------------------------------------
   // mtap_drreg_drout[DRREG_MTAP_POSITION_OF_IDCODE] is going to the TDOmux FUB.
   // ---------------------------------------------------------------------
   assign mtap_drreg_drout[DRREG_MTAP_POSITION_OF_IDCODE] = idcode_reg[0];

   // *********************************************************************
   // cftapnw_ftap_secsel register implementation.
   // Module mtap_data_reg is instantiated to create register cftapnw_ftap_secsel.
   // This register is generated only if tap nework is enabled and
   // secondary register is enabled.
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_TAP_NETWORK == 1)
      begin
         if (DRREG_MTAP_ENABLE_CLTAPC_SEC_SEL == 1)
         begin
            mtap_data_reg #(
                            .DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_MTAP_NUMBER_OF_TAPS),
                            .DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_MTAP_NUMBER_OF_TAPS{LOW}}),
                            .DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_MTAP_NUMBER_OF_TAPS{LOW}})
                           )
            i_mtap_data_reg_tapc_sec_sel (
                                          .mtap_fsm_tlrs           (LOW),
                                          .atappris_tck            (atappris_tck),
                                          .atappris_tdi            (atappris_tdi),
                                          .reset_b                 (powergoodrst_b),
                                          .mtap_irdecoder_drselect (mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_SEC_SEL]),
                                          .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
                                          .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                                          .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                                          .tdr_data_in             ({DRREG_MTAP_NUMBER_OF_TAPS{LOW}}),
                                          .mtap_drreg_drout        (mtap_drreg_drout[DRREG_MTAP_POSITION_OF_SEC_SEL]),
                                          .tdr_data_out            (cftapnw_ftap_secsel)
                                         );
         end
         else
         begin
            assign cftapnw_ftap_secsel[(DRREG_MTAP_NUMBER_OF_TAPS - 1): 0] = {DRREG_MTAP_NUMBER_OF_TAPS{LOW}};
         end
      end
      else
      begin
         assign cftapnw_ftap_secsel[(DRREG_MTAP_NUMBER_OF_TAPS - 1): 0] = {DRREG_MTAP_NUMBER_OF_TAPS{LOW}};
      end
   endgenerate

   // *********************************************************************
   // tap_select_tlrs signal generation
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_CLTAPC_REMOVE == 1)
      begin
         assign cltapc_select_tlrs = mtap_fsm_tlrs & (~cltapc_remove);
      end
      else
      begin
         assign cltapc_select_tlrs = mtap_fsm_tlrs;
      end
   endgenerate

   // *********************************************************************
   // cltapc_select register implementation.
   // Module mtap_data_reg is instantiated to create register cltapc_select.
   // *********************************************************************
   mtap_data_reg #(
                   .DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2),
                   .DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}}),
                   .DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}})
                  )
   i_mtap_data_reg_cltapc_select (
                                  .mtap_fsm_tlrs           (cltapc_select_tlrs),
                                  .atappris_tck            (atappris_tck),
                                  .atappris_tdi            (atappris_tdi),
                                  .reset_b                 (powergoodrst_trst_b),
                                  .mtap_irdecoder_drselect (mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_CLTAPC_SELECT]),
                                  .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
                                  .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                                  .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                                  .tdr_data_in             ({DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}}),
                                  .mtap_drreg_drout        (mtap_drreg_drout[DRREG_MTAP_POSITION_OF_CLTAPC_SELECT]),
                                  .tdr_data_out            (cltapc_select)
                                 );

   // *********************************************************************
   // cltapc_select_ovr register implementation.
   // Module mtap_data_reg is instantiated to create register cltapc_select_ovr.
   // *********************************************************************
   mtap_data_reg #(
                   .DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2),
                   .DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}}),
                   .DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}})
                  )
   i_mtap_data_reg_cltapc_select_ovr (
                                      .mtap_fsm_tlrs           (LOW),
                                      .atappris_tck            (atappris_tck),
                                      .atappris_tdi            (atappris_tdi),
                                      .reset_b                 (powergoodrst_b),
                                      .mtap_irdecoder_drselect (mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_CLTAPC_SELECT_OVR]),
                                      .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
                                      .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                                      .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                                      .tdr_data_in             ({DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}}),
                                      .mtap_drreg_drout        (mtap_drreg_drout[DRREG_MTAP_POSITION_OF_CLTAPC_SELECT_OVR]),
                                      .tdr_data_out            (cltapc_select_ovr)
                                     );

   // *********************************************************************
   // cltapc_wtap_sel register implementation.
   // Module mtap_data_reg is instantiated to create register cltapc_wtap_sel.
   // This register is generated only if wtap nework is enabled.
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_WTAP_NETWORK == 1)
      begin
         mtap_data_reg #(
                         .DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_MTAP_NUMBER_OF_WTAPS),
                         .DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_MTAP_NUMBER_OF_WTAPS{LOW}}),
                         .DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_MTAP_NUMBER_OF_WTAPS{LOW}})
                        )
         i_mtap_data_reg_mtap_wtap_sel (
                                        .mtap_fsm_tlrs           (LOW),
                                        .atappris_tck            (atappris_tck),
                                        .atappris_tdi            (atappris_tdi),
                                        .reset_b                 (powergoodrst_b),
                                        .mtap_irdecoder_drselect (mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_WTAPNW_SELECTWIR]),
                                        .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
                                        .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                                        .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                                        .tdr_data_in             ({DRREG_MTAP_NUMBER_OF_WTAPS{LOW}}),
                                        .mtap_drreg_drout        (mtap_drreg_drout[DRREG_MTAP_POSITION_OF_WTAPNW_SELECTWIR]),
                                        .tdr_data_out            (cltapc_wtap_sel)
                                       );
      end
      else
      begin
         assign cltapc_wtap_sel[0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // cltapc_visaovr register implementation.
   // Module mtap_data_reg is instantiated to create register cltapc_visaovr.
   // This register is generated only if Visa select override is enabled.
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_CLTAPC_VISAOVR == 1)
      begin
         mtap_visa #(
                     .VISA_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS (DRREG_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS),
                     .VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS    (DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS),
                     .VISA_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA       (DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA)
                    )
         i_mtap_visa_cltapc_visaovr (
                                     .atappris_tck            (atappris_tck),
                                     .atappris_tdi            (atappris_tdi),
                                     .powergoodrst_b          (powergoodrst_b),
                                     .mtap_irdecoder_drselect (mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_CLTAPC_VISAOVR]),
                                     .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                                     .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                                     .mtap_drreg_drout        (mtap_drreg_drout[DRREG_MTAP_POSITION_OF_CLTAPC_VISAOVR]),
                                     .tdr_data_out            (cltapc_visaovr)
                                    );
      end
      else
      begin
         assign cltapc_visaovr[0][0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // cltapc_remove register implementation.
   // Module mtap_data_reg is instantiated to create register cltapc_remove.
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_CLTAPC_REMOVE == 1)
      begin
         mtap_data_reg #(
                         .DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_MTAP_WIDTH_OF_CLTAPC_REMOVE),
                         .DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_MTAP_WIDTH_OF_CLTAPC_REMOVE{LOW}}),
                         .DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT ({DRREG_MTAP_WIDTH_OF_CLTAPC_REMOVE{LOW}})
                        )
         i_mtap_data_reg_cltapc_remove (
                                        .mtap_fsm_tlrs           (LOW),
                                        .atappris_tck            (atappris_tck),
                                        .atappris_tdi            (atappris_tdi),
                                        .reset_b                 (powergoodrst_b),
                                        .mtap_irdecoder_drselect (mtap_irdecoder_drselect[DRREG_MTAP_POSITION_OF_CLTAPC_REMOVE]),
                                        .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
                                        .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                                        .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                                        .tdr_data_in             ({DRREG_MTAP_WIDTH_OF_CLTAPC_REMOVE{LOW}}),
                                        .mtap_drreg_drout        (mtap_drreg_drout[DRREG_MTAP_POSITION_OF_CLTAPC_REMOVE]),
                                        .tdr_data_out            (cltapc_remove)
                                       );
      end
      else
      begin
         assign cltapc_remove = {DRREG_MTAP_WIDTH_OF_CLTAPC_REMOVE{LOW}};
      end
   endgenerate

   // *********************************************************************
   // Generate construct is used to generate number of registers required.
   // No of registers equal to DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS are generated.
   // Width of each register depends on value of DRREG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER, which is
   // defined as parameter (user defined).
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_TEST_DATA_REGISTERS == 1)
      begin
         for (genvar i = DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER; i < (DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS - DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS); i = i + 1)
         begin
            mtap_data_reg #(
                            .DATA_REG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER
                               (DRREG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER[
                                  ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                     DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                     DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                  ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                     DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)]),
                            .DATA_REG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS
                               (DRREG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS[
                                  (DRREG_MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                     ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                     ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                  (DRREG_MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                     ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                     ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)])]),
                            .DATA_REG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT
                               (DRREG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT[
                                  (DRREG_MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                     ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                     ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                  (DRREG_MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                     ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                     ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)])])
                            )
            i_mtap_data_reg (
                             .mtap_fsm_tlrs           (LOW),
                             .atappris_tck            (atappris_tck),
                             .atappris_tdi            (atappris_tdi),
                             .reset_b                 (powergoodrst_b),
                             .mtap_irdecoder_drselect (mtap_irdecoder_drselect[i]),
                             .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
                             .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                             .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                             .tdr_data_in             (tdr_data_in[
                                                         (DRREG_MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                                         (DRREG_MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)])]),
                             .mtap_drreg_drout        (mtap_drreg_drout[i]),
                             .tdr_data_out            (tdr_data_out[
                                                         (DRREG_MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                                         (DRREG_MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((i - DRREG_MTAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE)])])
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
   // no of times each conntrol signal is generated is  = DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
   // *********************************************************************
   generate
      if (DRREG_MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 1)
      begin
         for (genvar i = DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER; i < (DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS); i = i + 1)
         begin

         mtap_remote_data_reg  #(
               .DATA_MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR_BIT 
                    (DRREG_MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER])
               )
         i_mtap_remote_data_reg (
                      .atappris_tdi             (atappris_tdi),
                      .atappris_tck             (atappris_tck), //kbbhagwa cdc fix
                      .powergoodrst_b           (powergoodrst_b),
                      .mtap_irdecoder_drselect  (mtap_irdecoder_drselect[i]),
                      //.mtap_fsm_shift_dr_neg    (mtap_fsm_shift_dr_neg),//kbhagwa hsd2904953
                      .mtap_fsm_shift_dr        (mtap_fsm_shift_dr),
                      .mtap_fsm_capture_dr_nxt  (mtap_fsm_capture_dr_nxt), //kbbhagwa cdc fix
                      .mtap_fsm_capture_dr      (mtap_fsm_capture_dr),
                      .mtap_fsm_update_dr       (mtap_fsm_update_dr),
                      .mtap_fsm_update_dr_nxt   (mtap_fsm_update_dr_nxt), //kbbhagwa cdc fix
                      .mtap_drreg_drout         (mtap_drreg_drout[i]),
                      .rtdr_tap_ip_clk_i        (rtdr_tap_ip_clk_i[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .rtdr_tap_tdo             (rtdr_tap_tdo[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_tdi             (tap_rtdr_tdi[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_capture         (tap_rtdr_capture[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_shift           (tap_rtdr_shift[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_update          (tap_rtdr_update[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER]),
                      .tap_rtdr_irdec           (tap_rtdr_irdec[i-DRREG_MTAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER])
                     );
          end
          // *********************************************************************
          // Feed through powergoodrst_b to the remote test data register
          // *********************************************************************
          assign tap_rtdr_powergoodrst_b = powergoodrst_b;
          assign tap_rtdr_rti            = mtap_fsm_rti;
          assign tap_rtdr_selectir       = mtap_selectwir;
      end
      else
      begin
         assign tap_rtdr_tdi                = HIGH; 
         assign tap_rtdr_capture            = LOW;  
         assign tap_rtdr_shift              = LOW;  
         assign tap_rtdr_update             = LOW;  
         assign tap_rtdr_irdec              = LOW;  
         assign tap_rtdr_powergoodrst_b     = HIGH;  
         assign tap_rtdr_rti                = LOW;  
         assign tap_rtdr_selectir           = LOW;  
         assign mtap_fsm_rti_NC             = mtap_fsm_rti;  
         assign mtap_selectwir_NC           = mtap_selectwir;  
         assign rtdr_tap_ip_clk_i_NC        = rtdr_tap_ip_clk_i[0];  
         assign rtdr_tap_tdo_NC             = rtdr_tap_tdo[0];  
         assign mtap_fsm_cap_dr_nxt_NC      = mtap_fsm_capture_dr_nxt;  
         assign mtap_fsm_update_dr_nxt_NC   = mtap_fsm_update_dr_nxt;  
      end
   endgenerate

   // Assertions and coverage
//   `include "mtap_drreg_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/def ault.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
  `include "mtap_drreg_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif




endmodule
