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
//    FILENAME    : stap_drreg.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
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
//    DRREG_STAP_POSITION_OF_TAPC_REMOVE
//       This defines the decoder select line value for IR equals to TAPC_REMOVE
//
//    DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER
//       This defines the decoder select line value for IR equals to TEST_DATA_REGISTER
//
//----------------------------------------------------------------------
module stap_drreg
   #(
   parameter DRREG_STAP_SWCOMP_ACTIVE                             = 1,
   parameter DRREG_STAP_SUPPRESS_UPDATE_CAPTURE                    = 0,
   parameter DRREG_STAP_DFX_SECURE_POLICY_SELECTREG               = 0,
   parameter DRREG_STAP_WTAPCTRL_RESET_VALUE                      = 0, //HSD:1405881491
   parameter DRREG_STAP_ENABLE_TEST_DATA_REGISTERS                = 1,
   parameter DRREG_STAP_ENABLE_TAPC_REMOVE                        = 0,
   parameter DRREG_STAP_WIDTH_OF_SLVIDCODE                        = 32,
   parameter DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS                 = 0,
   parameter DRREG_STAP_NUMBER_OF_MANDATORY_REGISTERS             = 0,
   parameter DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE                  = 0,
   parameter DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS        = 0,
   parameter DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           = 0,
   parameter DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS         = 0,
   parameter DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS         = 0,
   parameter DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       = 0,
   parameter DRREG_STAP_NUMBER_OF_TAP_NETWORK_REGISTERS           = 2,
   parameter DRREG_STAP_NUMBER_OF_TAPS                            = 1,
   parameter DRREG_STAP_NUMBER_OF_WTAPS                           = 1,
   parameter DRREG_STAP_WIDTH_OF_TAPC_REMOVE                      = 1,
   parameter DRREG_STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS          = 1,
   parameter DRREG_STAP_ENABLE_TAPC_SEC_SEL                       = 0,
   parameter DRREG_STAP_ENABLE_WTAP_NETWORK                       = 0,
   parameter DRREG_STAP_ENABLE_TAP_NETWORK                        = 0,
   parameter DRREG_STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS           = 0,
   parameter DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS               = 0,
   parameter DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS                 = 0,
   parameter DRREG_STAP_NUMBER_OF_INTEST_REGISTERS                = 0,
   parameter DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS               = 0,
   parameter DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS         = 0,
   parameter DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2              = 1,
   parameter DRREG_STAP_ENABLE_BSCAN                              = 1,
   parameter DRREG_STAP_NUMBER_OF_TAP_SELECT_REGISTERS            = 1,
   parameter DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS             = 0,
   parameter DRREG_STAP_ENABLE_ITDR_PROG_RST                      = 0,
   parameter DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ   = 0,
   parameter DRREG_STAP_RTDR_IS_BUSSED_NZ                         = 0,
   parameter DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS      = 0,
   parameter DRREG_STAP_ENABLE_RTDR_PROG_RST                      = 0,
   parameter DRREG_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS         = 0,
   parameter DRREG_STAP_SECURE_GREEN                              = 2'b00,
   parameter DRREG_STAP_SECURE_ORANGE                             = 2'b01,
   parameter DRREG_STAP_SECURE_RED                                = 2'b10
   )
   (
   input  logic                                                              stap_fsm_tlrs,
   input  logic                                                              ftap_tdi,
   input  logic                                                              ftap_tck,
   input  logic                                                              ftap_trst_b,
   input  logic                                                              fdfx_powergood,
   input  logic                                                              powergood_rst_trst_b,
   input  logic                                                              stap_fsm_capture_dr,
   input  logic                                                              stap_fsm_shift_dr,
   input  logic                                                              stap_fsm_update_dr,
   input  logic                                                              stap_selectwir,
   input  logic [(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):0]                      ftap_slvidcode,
   input  logic [(DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]               stap_irdecoder_drselect,
   input  logic [(DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0]      tdr_data_in,
   output logic [(DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0]      tdr_data_out,
   output logic [(DRREG_STAP_NUMBER_OF_TAPS - 1):0]                          sftapnw_ftap_secsel,
   output logic [(DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0]            tapc_select,
   input  logic                                                              feature_green_en,
   input  logic                                                              feature_orange_en,
   input  logic                                                              feature_red_en,
   output logic [(DRREG_STAP_NUMBER_OF_WTAPS - 1):0]                         tapc_wtap_sel,
   output logic                                                              tapc_remove,
   output logic [(DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]               stap_drreg_tdo,
   input  logic                                                              swcompctrl_tdo,
   input  logic                                                              swcompstat_tdo,
   input  logic                                                              stap_and_all_bits_irreg,
   input  logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] rtdr_tap_tdo,
   output logic [(DRREG_STAP_RTDR_IS_BUSSED_NZ - 1):0]                       tap_rtdr_tdi,
   output logic [(DRREG_STAP_RTDR_IS_BUSSED_NZ - 1):0]                       tap_rtdr_capture,
   output logic [(DRREG_STAP_RTDR_IS_BUSSED_NZ - 1):0]                       tap_rtdr_shift,
   output logic [(DRREG_STAP_RTDR_IS_BUSSED_NZ - 1):0]                       tap_rtdr_update,
   output logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_irdec,
   output logic                                                              tap_rtdr_selectir,
   output logic                                                              tap_rtdr_powergood,
   output logic                                                              tap_rtdr_rti,
   output logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_prog_rst_b,
   output logic [1:0]                                                        suppress_update_capture_reg,
   input  logic                                                              stap_fsm_rti
   );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH                                        = 1'b1;
   localparam LOW                                         = 1'b0;
   localparam TWO_BIT_ZERO                                = 2'b00;
   localparam TWO                                         = 2;
   localparam DRREG_SIZE_OF_TDRRSTEN_REGISTER             = TWO;
   localparam DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ = (DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 :
                                                             DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS;
   // ---------------------------------------------------------------------
   // Register positions
   // ---------------------------------------------------------------------
   localparam DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES             = 0;
   localparam DRREG_STAP_POSITION_OF_SAMPLE_PRELOAD              = 1;
   localparam DRREG_STAP_POSITION_OF_HIGHZ                       = 2;
   localparam DRREG_STAP_POSITION_OF_EXTEST                      = 3;
   localparam DRREG_STAP_POSITION_OF_SLVIDCODE                   = (DRREG_STAP_ENABLE_BSCAN == 1) ? 4 : 1;
   localparam DRREG_STAP_POSITION_OF_EXTEST_PULSE                = 5;
   localparam DRREG_STAP_POSITION_OF_EXTEST_TRAIN                = 6;
   localparam DRREG_STAP_POSITION_OF_TAPC_SELECT                 = (DRREG_STAP_ENABLE_BSCAN == 1) ? 7 :
                                                                   DRREG_STAP_NUMBER_OF_MANDATORY_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_PRELOAD                     = DRREG_STAP_POSITION_OF_TAPC_SELECT +
                                                                   DRREG_STAP_NUMBER_OF_TAP_SELECT_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_CLAMP                       = DRREG_STAP_POSITION_OF_PRELOAD +
                                                                   DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_INTEST                      = DRREG_STAP_POSITION_OF_CLAMP +
                                                                   DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_RUNBIST                     = DRREG_STAP_POSITION_OF_INTEST +
                                                                   DRREG_STAP_NUMBER_OF_INTEST_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_EXTEST_TOGGLE               = DRREG_STAP_POSITION_OF_RUNBIST +
                                                                   DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_SEC_SEL                     = DRREG_STAP_POSITION_OF_EXTEST_TOGGLE +
                                                                   DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR            = DRREG_STAP_POSITION_OF_SEC_SEL +
                                                                   DRREG_STAP_NUMBER_OF_TAP_NETWORK_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_TAPC_REMOVE                 = DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR +
                                                                   DRREG_STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_TAPC_TDRRSTEN               = DRREG_STAP_POSITION_OF_TAPC_REMOVE +
                                                                   DRREG_STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS;
   localparam DRREG_STAP_POSITION_OF_TAPC_ITDRRSTSEL             = DRREG_STAP_POSITION_OF_TAPC_TDRRSTEN +
                                                                   ((DRREG_STAP_ENABLE_ITDR_PROG_RST == 1) ? 1 : (DRREG_STAP_ENABLE_RTDR_PROG_RST == 1) ? 1 : 0);
   localparam DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL             = DRREG_STAP_POSITION_OF_TAPC_ITDRRSTSEL +
                                                                   ((DRREG_STAP_ENABLE_ITDR_PROG_RST == 0) ? 0 : DRREG_STAP_ENABLE_ITDR_PROG_RST);
																    
   //PCR 1604263740 for SWCOMP Integration

   localparam DRREG_STAP_POSITION_OF_SWCOMP_CTRL                 =  (DRREG_STAP_SWCOMP_ACTIVE == 1)             ?  
                                                                    ((DRREG_STAP_ENABLE_BSCAN         == 0      &&    DRREG_STAP_ENABLE_TAPC_REMOVE          == 0     && 
																	  DRREG_STAP_ENABLE_WTAP_NETWORK  == 0      &&    DRREG_STAP_ENABLE_TAP_NETWORK          == 0     && 
																      DRREG_STAP_ENABLE_TAPC_SEC_SEL  == 0      &&    DRREG_STAP_ENABLE_RTDR_PROG_RST        == 0     &&   
																      DRREG_STAP_ENABLE_ITDR_PROG_RST == 0)     ?     2                                               :
                                                                     (DRREG_STAP_ENABLE_RTDR_PROG_RST == 1)     ?     DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL  + 1     :
                                                                     (DRREG_STAP_ENABLE_ITDR_PROG_RST == 1)     ?     DRREG_STAP_POSITION_OF_TAPC_ITDRRSTSEL  + 1     :
                                                                     (DRREG_STAP_ENABLE_TAPC_REMOVE   == 1)     ?     DRREG_STAP_POSITION_OF_TAPC_REMOVE      + 1     :
                                                                     (DRREG_STAP_ENABLE_WTAP_NETWORK  == 1)     ?     DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR + 1     :
                                                                     (DRREG_STAP_ENABLE_TAPC_SEC_SEL  == 1)     ?     DRREG_STAP_POSITION_OF_SEC_SEL          + 1     :  
															     	 (DRREG_STAP_ENABLE_BSCAN         == 1)     ?     DRREG_STAP_POSITION_OF_EXTEST_TOGGLE    + 1     : DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL) :   
																	  DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL  ;     
					
																   
   localparam DRREG_STAP_POSITION_OF_SWCOMP_STAT                 =  DRREG_STAP_POSITION_OF_SWCOMP_CTRL  +
                                                                   ( (DRREG_STAP_SWCOMP_ACTIVE == 1) ? 1 : 0) ;
   
  localparam DRREG_STAP_POSITION_OF_SUPPRESS_UPDATE_CAPTURE       = DRREG_STAP_SUPPRESS_UPDATE_CAPTURE == 1 ? DRREG_STAP_POSITION_OF_SWCOMP_STAT + 1 : DRREG_STAP_POSITION_OF_SWCOMP_STAT;	

  localparam DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER   = (DRREG_STAP_SWCOMP_ACTIVE == 0 && DRREG_STAP_SUPPRESS_UPDATE_CAPTURE == 0) ? 
                                                                  ((DRREG_STAP_ENABLE_RTDR_PROG_RST == 0) ? DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL + 0 : DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL + DRREG_STAP_ENABLE_RTDR_PROG_RST) : 
                                                                  (DRREG_STAP_SWCOMP_ACTIVE == 1 && DRREG_STAP_SUPPRESS_UPDATE_CAPTURE == 0) ? DRREG_STAP_POSITION_OF_SWCOMP_STAT + 1 : 
																  (DRREG_STAP_SWCOMP_ACTIVE == 0 && DRREG_STAP_SUPPRESS_UPDATE_CAPTURE == 1) ? DRREG_STAP_POSITION_OF_SUPPRESS_UPDATE_CAPTURE + 1 : DRREG_STAP_POSITION_OF_SUPPRESS_UPDATE_CAPTURE+1 ; 
   localparam DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER = DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER +
                                                                   DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):0]                      slvidcode_reset_value;
   logic                                                              reset_pulse;
   logic                                                              bypass_reg;
   logic [(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):0]                      slvidcode_reg;
   logic                                                              reset_pulse0;
   logic                                                              reset_pulse1;
   logic                                                              irdecoder_drselect;
   logic                                                              stap_fsm_rti_NC;
   logic [(DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]               stap_irdecoder_drsel_NC;
   logic                                                              ftap_slvidcode0_NC;
   logic                                                              stap_selectwir_NC;
   logic                                                              rtdr_tap_tdo_NC;
   logic                                                              green_en;
   logic                                                              orange_en;
   logic [(DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0]            tapc_select_int;
   logic [(DRREG_SIZE_OF_TDRRSTEN_REGISTER - 1):0]                    tapc_tdrrsten_reg;
   logic [(DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ - 1):0]        tapc_itdrrstsel_reg;
   logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tapc_rtdrrstsel_reg;
   logic                                                              prgm_soft_rst_mux;
   logic                                                              prgm_hard_rst_mux;
   logic [(DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ - 1):0]        itdr_async_reset;
   logic [(DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] rtdr_sync_reset;

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
       stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES];

   // *********************************************************************
   // BYPASS register implementation
   // If part: The bypass register is cleared in Capture_DR state if the
   // IR decoder is selecting the bypass reg
   // Else part: The data will be shifted from the tdi pin in the
   // shift_DR state
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
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
   // stap_drreg_tdo implementation for bits all ones
   // *********************************************************************
   assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES] =
      (stap_and_all_bits_irreg == HIGH) ? bypass_reg :
      (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_BYPASS_ALL_ONES] == HIGH) ? bypass_reg : LOW;

   // *********************************************************************
   // Dummy assignments to avoid lintra warnings
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_BSCAN == 1)
      begin:generate_bscan_regs
         assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_SAMPLE_PRELOAD] = LOW;
         assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_HIGHZ]          = LOW;
         assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_EXTEST]         = LOW;
         assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_EXTEST_PULSE]   = LOW;
         assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_EXTEST_TRAIN]   = LOW;

         if (DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS > 0)
         begin:generate_bscan_regs_1
            assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_PRELOAD] = LOW;
         end

         if (DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS > 0)
         begin:generate_bscan_regs_2
            assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_CLAMP] = LOW;
         end

         if (DRREG_STAP_NUMBER_OF_INTEST_REGISTERS > 0)
         begin:generate_bscan_regs_3
            assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_INTEST] = LOW;
         end

         if (DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS > 0)
         begin:generate_bscan_regs_4
            assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_RUNBIST] = LOW;
         end

         if (DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS > 0)
         begin:generate_bscan_regs_5
            assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_EXTEST_TOGGLE] = LOW;
         end
      end
   endgenerate

   // *********************************************************************
   // Reset pulse generation logic. To avoid lintra error which complains about
   // loading pin values during reset
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
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
   // Generation of ftap_slvidcode reset value.
   // *********************************************************************
   assign slvidcode_reset_value = {ftap_slvidcode[(DRREG_STAP_WIDTH_OF_SLVIDCODE - 1):1], HIGH};
   assign ftap_slvidcode0_NC    = ftap_slvidcode[0];

   // *********************************************************************
   // IDCODE register implementation
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
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
   // stap_drreg_tdo[DRREG_STAP_POSITION_OF_SLVIDCODE] is going to the TDOmux FUB.
   // ---------------------------------------------------------------------
   assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_SLVIDCODE] = slvidcode_reg[0];

   // *********************************************************************
   // sftapnw_ftap_secsel register implementation.
   // Module stap_data_reg is instantiated to create register sftapnw_ftap_secsel.
   // This register is generated only if tap nework is enabled and
   // secondary register is enabled.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAP_NETWORK == 1)
      begin:generate_tapnw_sec_sel_tdr
         if (DRREG_STAP_ENABLE_TAPC_SEC_SEL == 1)
         begin:generate_tapnw_sec_sel_tdr_1
            stap_data_reg #(
                            .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_NUMBER_OF_TAPS),
                            .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_NUMBER_OF_TAPS{LOW}})
                           )
            i_stap_data_reg_tapc_sec_sel (
                                          .sync_reset              (LOW),
                                          .ftap_tck                (ftap_tck),
                                          .ftap_tdi                (ftap_tdi),
                                          .reset_b                 (fdfx_powergood),
                                          .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_SEC_SEL]),
                                          .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                          .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                          .stap_fsm_update_dr      (stap_fsm_update_dr),
                                          .tdr_data_in             (sftapnw_ftap_secsel),
                                          .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_SEC_SEL]),
                                          .tdr_data_out            (sftapnw_ftap_secsel)
                                         );
         end
         else
         begin:generate_tapnw_sec_sel_tdr_1
            assign sftapnw_ftap_secsel[(DRREG_STAP_NUMBER_OF_TAPS - 1):0] = {DRREG_STAP_NUMBER_OF_TAPS{LOW}};
         end
      end
      else
      begin:generate_tapnw_sec_sel_tdr
         assign sftapnw_ftap_secsel[(DRREG_STAP_NUMBER_OF_TAPS - 1):0] = {DRREG_STAP_NUMBER_OF_TAPS{LOW}};
      end
   endgenerate

   // *********************************************************************
   // tapc_select register implementation.
   // Module stap_data_reg is instantiated to create register tapc_select.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAP_NETWORK == 1)
      begin:generate_tapc_sel_tdr
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2{LOW}})
                        )
         i_stap_data_reg_tapc_select (
                                      .sync_reset              (LOW),
                                      .ftap_tck                (ftap_tck),
                                      .ftap_tdi                (ftap_tdi),
                                      .reset_b                 (fdfx_powergood),
                                      .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_SELECT]),
                                      .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                      .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                      .stap_fsm_update_dr      (stap_fsm_update_dr),
                                      .tdr_data_in             (tapc_select_int),
                                      .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_TAPC_SELECT]),
                                      .tdr_data_out            (tapc_select_int)
                                     );
      end
      else
      begin:generate_tapc_sel_tdr
         assign tapc_select_int[(DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0] = TWO_BIT_ZERO;
      end
   endgenerate


   // *********************************************************************
   // supress_update_capture register implementation.
   // Module stap_data_reg is instantiated to create register suppress_update_capture_reg .
   // *********************************************************************
   generate
   if (DRREG_STAP_SUPPRESS_UPDATE_CAPTURE == 1)
      begin:generate_suppress_update_capture_tdr
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (2),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({2{LOW}})
                        )
         i_stap_data_reg_supress_upadte_capture_dr (
                                      .sync_reset              (LOW),
                                      .ftap_tck                (ftap_tck),
                                      .ftap_tdi                (ftap_tdi),
                                      .reset_b                 (fdfx_powergood),
                                      .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_SUPPRESS_UPDATE_CAPTURE]),
                                      .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                      .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                      .stap_fsm_update_dr      (stap_fsm_update_dr),
                                      .tdr_data_in             (suppress_update_capture_reg),
                                      .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_SUPPRESS_UPDATE_CAPTURE]),
                                      .tdr_data_out            (suppress_update_capture_reg)
                                     );
      end
      else
      begin:generate_suppress_update_capture_tdr
         assign suppress_update_capture_reg = TWO_BIT_ZERO;
	 end
   endgenerate


   // *********************************************************************
   assign green_en   = (feature_green_en  | feature_orange_en | feature_red_en);
   assign orange_en  = (feature_orange_en | feature_red_en);

   generate
      for (genvar m = 0; m < DRREG_STAP_NUMBER_OF_TAPS; m = m + 1)
      begin:generate_taps_security
         always_comb
         begin
            case (DRREG_STAP_DFX_SECURE_POLICY_SELECTREG[((m * TWO) + 1):(m * TWO)])
               DRREG_STAP_SECURE_RED:
               begin
                  if (feature_red_en)
                  begin
                     tapc_select[((TWO * m) + 1):(TWO * m)] = tapc_select_int[((TWO * m) + 1):(TWO * m)];
                  end
                  else
                  begin
                     tapc_select[((TWO * m) + 1):(TWO * m)] = TWO_BIT_ZERO;
                  end
               end
               DRREG_STAP_SECURE_ORANGE:
               begin
                  if (orange_en)
                  begin
                     tapc_select[((TWO * m) + 1):(TWO * m)] = tapc_select_int[((TWO * m) + 1):(TWO * m)];
                  end
                  else
                  begin
                     tapc_select[((TWO * m) + 1):(TWO * m)] = TWO_BIT_ZERO;
                  end
               end
               DRREG_STAP_SECURE_GREEN:
               begin
                  if (green_en)
                  begin
                     tapc_select[((TWO * m) + 1):(TWO * m)] = tapc_select_int[((TWO * m) + 1):(TWO * m)];
                  end
                  else
                  begin
                     tapc_select[((TWO * m) + 1):(TWO * m)] = TWO_BIT_ZERO;
                  end
               end
               default:
               begin
                  tapc_select[((TWO * m) + 1):(TWO * m)] = TWO_BIT_ZERO;
               end
            endcase
         end
      end
   endgenerate

   // *********************************************************************

   // *********************************************************************
   // tapc_wtap_sel register implementation.
   // Module stap_data_reg is instantiated to create register tapc_wtap_sel.
   // This register is generated only if wtap nework is enabled.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_WTAP_NETWORK == 1)
      begin:generate_wtap_nw_tdr
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_NUMBER_OF_WTAPS),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_NUMBER_OF_WTAPS{DRREG_STAP_WTAPCTRL_RESET_VALUE}})
                        )
         i_stap_data_reg_tapc_wtap_sel (
                                        .sync_reset              (LOW),
                                        .ftap_tck                (ftap_tck),
                                        .ftap_tdi                (ftap_tdi),
                                        .reset_b                 (fdfx_powergood),
                                        .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR]),
                                        .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                        .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                        .stap_fsm_update_dr      (stap_fsm_update_dr),
                                        .tdr_data_in             (tapc_wtap_sel),
                                        .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_WTAPNW_SELECTWIR]),
                                        .tdr_data_out            (tapc_wtap_sel)
                                       );
      end
      else
      begin:generate_wtap_nw_tdr
         assign tapc_wtap_sel[0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // tapc_remove register implementation.
   // Module stap_data_reg is instantiated to create register tapc_remove.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TAPC_REMOVE == 1)
      begin:generate_tapc_remove_tdr
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (DRREG_STAP_WIDTH_OF_TAPC_REMOVE),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({DRREG_STAP_WIDTH_OF_TAPC_REMOVE{LOW}})
                        )
         i_stap_data_reg_tapc_remove (
                                      .sync_reset              (LOW),
                                      .ftap_tck                (ftap_tck),
                                      .ftap_tdi                (ftap_tdi),
                                      .reset_b                 (fdfx_powergood),
                                      .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_REMOVE]),
                                      .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                      .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                      .stap_fsm_update_dr      (stap_fsm_update_dr),
                                      .tdr_data_in             (tapc_remove),
                                      .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_TAPC_REMOVE]),
                                      .tdr_data_out            (tapc_remove)
                                     );
      end
      else
      begin:generate_tapc_remove_tdr
         assign tapc_remove = {DRREG_STAP_WIDTH_OF_TAPC_REMOVE{LOW}};
      end
   endgenerate
//*************************************************************************
// Programmable Reset Implementation for iTDRs and RTDRs.
//*************************************************************************
   // *********************************************************************
   // TAPC_TDRRSTEN 'h15 register implementation.
   // Module stap_data_reg is instantiated to create register TAPC_TDRRSTEN.
   // *********************************************************************
   generate
      if ((DRREG_STAP_ENABLE_ITDR_PROG_RST == 1) || (DRREG_STAP_ENABLE_RTDR_PROG_RST == 1))
      begin:generate_tapc_tdrrsten_tdr
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER     (DRREG_SIZE_OF_TDRRSTEN_REGISTER),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS ({DRREG_SIZE_OF_TDRRSTEN_REGISTER{LOW}})
                        )
         i_stap_data_reg_tapc_tdrrsten (
                                        .sync_reset              (LOW),
                                        .ftap_tck                (ftap_tck),
                                        .ftap_tdi                (ftap_tdi),
                                        .reset_b                 (fdfx_powergood),
                                        .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_TDRRSTEN]),
                                        .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                        .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                        .stap_fsm_update_dr      (stap_fsm_update_dr),
                                        .tdr_data_in             (tapc_tdrrsten_reg),
                                        .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_TAPC_TDRRSTEN]),
                                        .tdr_data_out            (tapc_tdrrsten_reg)
                                       );
      end
      else
      begin:generate_tapc_tdrrsten_tdr
         assign tapc_tdrrsten_reg[(DRREG_SIZE_OF_TDRRSTEN_REGISTER - 1):0] = TWO_BIT_ZERO;
      end
   endgenerate

   // *********************************************************************
   // TAPC_ITDRRSTSEL 'h16 register implementation.
   // Module stap_data_reg is instantiated to create register TAPC_ITDRRSTSEL.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_ITDR_PROG_RST == 1)
      begin:generate_tapc_itdrrstsel_tdr
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER     (DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS ({DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ{LOW}})
                        )
         i_stap_data_reg_tapc_itdrrstsel (
                                          .sync_reset              (LOW),
                                          .ftap_tck                (ftap_tck),
                                          .ftap_tdi                (ftap_tdi),
                                          .reset_b                 (fdfx_powergood),
                                          .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_ITDRRSTSEL]),
                                          .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                          .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                          .stap_fsm_update_dr      (stap_fsm_update_dr),
                                          .tdr_data_in             (tapc_itdrrstsel_reg),
                                          .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_TAPC_ITDRRSTSEL]),
                                          .tdr_data_out            (tapc_itdrrstsel_reg)
                                         );
      end
      else
      begin:generate_tapc_itdrrstsel_tdr
         assign tapc_itdrrstsel_reg = {DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ{LOW}};
      end
   endgenerate

   // *********************************************************************
   // TAPC_RTDRRSTSEL 'h17 register implementation.
   // Module stap_data_reg is instantiated to create register TAPC_RTDRRSTSEL.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_RTDR_PROG_RST == 1)
      begin:generate_tapc_rtdrrstsel_tdr
         stap_data_reg #(
                         .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER     (DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ),
                         .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS ({DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ{LOW}})
                        )
         i_stap_data_reg_tapc_rtdrrstsel (
                                          .sync_reset              (LOW),
                                          .ftap_tck                (ftap_tck),
                                          .ftap_tdi                (ftap_tdi),
                                          .reset_b                 (fdfx_powergood),
                                          .stap_irdecoder_drselect (stap_irdecoder_drselect[DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL]),
                                          .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                                          .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                                          .stap_fsm_update_dr      (stap_fsm_update_dr),
                                          .tdr_data_in             (tapc_rtdrrstsel_reg),
                                          .data_reg_tdo            (stap_drreg_tdo[DRREG_STAP_POSITION_OF_TAPC_RTDRRSTSEL]),
                                          .tdr_data_out            (tapc_rtdrrstsel_reg)
                                         );
      end
      else
      begin:generate_tapc_rtdrrstsel_tdr
         assign tapc_rtdrrstsel_reg = {DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ{LOW}};
      end
   endgenerate

   // *********************************************************************
   // Logic for selecting soft programmable reset option for ITDRs/RTDRs 
   // based on the regiseter TAPC_TDRRSTEN.
   // *********************************************************************
   generate
      always_comb
      begin
         if ((DRREG_STAP_ENABLE_ITDR_PROG_RST == 1) || (DRREG_STAP_ENABLE_RTDR_PROG_RST == 1))
         begin:generate_soft_rst_mux
            case (tapc_tdrrsten_reg[1])
            LOW:
            begin
              prgm_soft_rst_mux = fdfx_powergood;
            end
            HIGH:
            begin
              prgm_soft_rst_mux = (!tapc_tdrrsten_reg[1]);
            end
            default:
            begin
              prgm_soft_rst_mux = fdfx_powergood;
            end
            endcase
         end
         else
         begin
            prgm_soft_rst_mux = fdfx_powergood;
         end
      end
   endgenerate

   // *********************************************************************
   // Logic for selecting ftap_trst_b programmable reset option for ITDRs/RTDRs 
   // based on the regiseter TAPC_TDRRSTEN.
   // *********************************************************************
   generate
      if ((DRREG_STAP_ENABLE_ITDR_PROG_RST == 1) || (DRREG_STAP_ENABLE_RTDR_PROG_RST == 1))
      begin:generate_hard_rst_mux
         always_comb
         begin
            case (tapc_tdrrsten_reg[0])
            LOW:
            begin
              prgm_hard_rst_mux = prgm_soft_rst_mux;
            end
            HIGH:
            begin
              // Fix HSD 4903467
              //prgm_hard_rst_mux = (ftap_trst_b); 
              prgm_hard_rst_mux = ((ftap_trst_b) & (!stap_fsm_tlrs));
            end
            default:
            begin
              prgm_hard_rst_mux = prgm_soft_rst_mux;
            end
            endcase
         end
      end
      else
      begin:generate_hard_rst_mux
         assign prgm_hard_rst_mux = prgm_soft_rst_mux;
      end
   endgenerate

   // *********************************************************************
   // Logic to check which ITDR bit in reg TAPC_ITDRRSTSEL is set to one 
   // for programmable reset option and pass the reset to respective ITDR
   // whose bit in TAPC_ITDRRSTSEL is set to one.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_ITDR_PROG_RST == 1)
      begin:generate_prog_rst_itdr
         for (genvar y = 0; y < DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ; y = y + 1)
         begin:generate_async_rst_itdr_1
            always_comb
            begin
               if (tapc_itdrrstsel_reg[y] == 1)
                  itdr_async_reset[y] = prgm_hard_rst_mux;
               else
                  itdr_async_reset[y] = fdfx_powergood;
            end
         end
      end
      else
      begin:generate_prog_rst_itdr
         assign itdr_async_reset = {DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ{fdfx_powergood}};
      end
   endgenerate

   // *********************************************************************
   // Logic to check which RTDR bit in reg TAPC_RTDRRSTSEL is set to one 
   // for programmable reset option and pass the reset to respective RTDR
   // whose bit in TAPC_RTDRRSTSEL is set to one.
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_RTDR_PROG_RST == 1)
      begin:generate_prog_rst_rtdr
         for (genvar z = 0; z < DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ; z = z + 1)
         begin:generate_sync_rst_rtdr_1
            always_comb
            begin
               if (tapc_rtdrrstsel_reg[z] == 1)
                  rtdr_sync_reset[z] = prgm_hard_rst_mux;
               else
                  rtdr_sync_reset[z] = fdfx_powergood;
            end
         end
      end
      else
      begin:generate_prog_rst_rtdr
         assign rtdr_sync_reset = {DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ{fdfx_powergood}};
      end
   endgenerate
//**************************************************************************************************************************
//**************************************************************************************************************************

   // *********************************************************************
   // Generate construct is used to generate number of registers required.
   // No of registers equal to DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS are generated.
   // Width of each register depends on value of DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER, which is
   // defined as parameter (user defined).
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_TEST_DATA_REGISTERS == 1)
      begin:generate_itdr
         for (genvar g = DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER; g < (DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS - DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS); g = g + 1)
         begin:generate_itdr_1
            stap_data_reg #(
                            .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER
                               (DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER[
                                  ((((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                     DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                     DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                  ((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                     DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]),
                            .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS
                               (DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS[
                                  (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                     ((((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                     ((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                  (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                     ((((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                     ((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                        DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])])
                            )
            i_stap_data_reg (
                             .sync_reset              (LOW),
                             .ftap_tck                (ftap_tck),
                             .ftap_tdi                (ftap_tdi),
                             .reset_b                 (itdr_async_reset[g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER]),
                             .stap_irdecoder_drselect (stap_irdecoder_drselect[g]),
                             .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                             .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                             .stap_fsm_update_dr      (stap_fsm_update_dr),
                             .tdr_data_in             (tdr_data_in[
                                                         (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                                         (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])]),
                             .data_reg_tdo            (stap_drreg_tdo[g]),
                             .tdr_data_out            (tdr_data_out[
                                                         (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                                         (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                                            ((((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                                            ((g - DRREG_STAP_DECODE_POSITION_OF_TEST_DATA_REGISTER) *
                                                               DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])])
                            );
         end
      end
      else
      begin:generate_itdr
         assign tdr_data_out[0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // Generate construct is used to generate Control signals for Remote test data register
   // no of times each conntrol signal is generated is  = DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
   // *********************************************************************
   generate
      if (DRREG_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 1)
      begin:generate_rtdr
         for (genvar h = DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER; h < DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS; h = h + 1)
         begin:generate_rtdr_1
            stap_remote_data_reg i_stap_remote_data_reg (
               .stap_irdecoder_drselect (stap_irdecoder_drselect[h]),
               .rtdr_tap_tdo            (rtdr_tap_tdo[(h - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)]),
               .stap_fsm_shift_dr       (stap_fsm_shift_dr),
               .rtdr_tap_tdo_gated      (stap_drreg_tdo[h]),
               .tap_rtdr_irdec          (tap_rtdr_irdec[(h - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)])
            );
         end
         if (DRREG_STAP_RTDR_IS_BUSSED_NZ == 1)
         begin:generate_rtdr_2
            assign tap_rtdr_tdi[0]     = ftap_tdi & (|tap_rtdr_irdec);
            assign tap_rtdr_capture[0] = stap_fsm_capture_dr & (|tap_rtdr_irdec);
            assign tap_rtdr_shift[0]   = stap_fsm_shift_dr & (|tap_rtdr_irdec);
            assign tap_rtdr_update[0]  = stap_fsm_update_dr & (|tap_rtdr_irdec);
         end
         else
         begin:generate_rtdr_2
            for (genvar i = DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER; i < DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS; i = i + 1)
            begin:generate_rtdr_3
               assign tap_rtdr_tdi[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)]     = ftap_tdi & tap_rtdr_irdec[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)];
               assign tap_rtdr_capture[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)] = stap_fsm_capture_dr & tap_rtdr_irdec[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)];
               assign tap_rtdr_shift[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)]   = stap_fsm_shift_dr & tap_rtdr_irdec[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)];
               assign tap_rtdr_update[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)]  = stap_fsm_update_dr & tap_rtdr_irdec[(i - DRREG_STAP_DECODE_POSITION_OF_REMOTE_DATA_REGISTER)];
            end
         end
         // *********************************************************************
         // Feed through fdfx_powergood to the remote test data register
         // *********************************************************************
         assign tap_rtdr_powergood  = fdfx_powergood;
         assign tap_rtdr_selectir   = stap_selectwir;
         assign tap_rtdr_rti        = stap_fsm_rti;
         assign tap_rtdr_prog_rst_b = rtdr_sync_reset;
      end
      else
      begin:generate_rtdr
         assign tap_rtdr_tdi        = HIGH;
         assign tap_rtdr_capture    = LOW;
         assign tap_rtdr_shift      = LOW;
         assign tap_rtdr_update     = LOW;
         assign tap_rtdr_powergood  = HIGH;
         assign tap_rtdr_selectir   = LOW;
         assign tap_rtdr_rti        = LOW;
         assign tap_rtdr_prog_rst_b = HIGH;
         assign tap_rtdr_irdec      = LOW;
         assign stap_fsm_rti_NC     = stap_fsm_rti;
         assign stap_selectwir_NC   = stap_selectwir;
         assign rtdr_tap_tdo_NC     = rtdr_tap_tdo[0];
      end
   endgenerate

   generate
       if(DRREG_STAP_SWCOMP_ACTIVE == 1) //badithya:  Assigning the TDOs from STATUS and CONTROL registers to stap_drreg_tdo 
       begin:generate_tdo
           assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_SWCOMP_CTRL]  =   swcompctrl_tdo;
           assign stap_drreg_tdo[DRREG_STAP_POSITION_OF_SWCOMP_STAT]  =   swcompstat_tdo;
       end
   endgenerate

//int rtl_path;
//string file_name;
//
//initial begin
//    //#60000
//	forever begin
//      @(negedge ftap_tck);
//	  if (stap.ftap_slvidcode !== 32'hxxxx_xxxx) begin
//	    file_name = $psprintf("IRR_STAP_INTERNAL_TDR_RTLPATHS_FOR_SLVIDCODE_%0h.out", stap.ftap_slvidcode);
//        rtl_path = $fopen(file_name, "a");
//        $fdisplay (rtl_path, "RTL_PATH for DR Shift Register that gets updated during a CADR, map it to TapPriSignal UDP          :- %m.bypass_reg");
//        $fdisplay (rtl_path, "RTL_PATH for DR Receiver Register that gets updated by core logic, map it to TapRcvrSignal UDP      :- %m.bypass_reg");
//        $fdisplay (rtl_path, "RTL_PATH for DR Shift Register that gets updated during a CADR, map it to TapPriSignal UDP          :- %m.slvidcode_reg");
//        $fdisplay (rtl_path, "RTL_PATH for DR Receiver Register that gets updated by core logic, map it to TapRcvrSignal UDP      :- %m.slvidcode_reg");
//        #1
//        $fclose(rtl_path);
//	    break;
//      end
//    end
//end
//
//// Assertions and coverage
`ifndef INTEL_SVA_OFF
`ifndef STAP_SVA_OFF
`ifdef INTEL_SIMONLY   
     `include "stap_drreg_include.sv"
   `endif 
   `endif 
   `endif 

endmodule
