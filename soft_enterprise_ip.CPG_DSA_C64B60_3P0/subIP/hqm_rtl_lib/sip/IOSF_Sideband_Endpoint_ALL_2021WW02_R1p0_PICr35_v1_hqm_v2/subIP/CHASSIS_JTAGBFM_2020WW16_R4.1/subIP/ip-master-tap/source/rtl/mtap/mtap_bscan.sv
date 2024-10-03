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
//    FILENAME    : mtap_bscan.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//
//
//    PURPOSE     : MTAP Boundary scan logic
//    DESCRIPTION :
//       This is module generate boundary scan logic required to drive outputs.
//    BUGS/ISSUES/ECN FIXES:
//       ECN198 - 05APR2010
//       Update the boundary scan description
//       HSD2901874 - 25MAY2010
//       SEG Master Tap SIP: Default value of Bscan extogsig_b and d6actestsig_b should be high.
//       Updated logic for signals, fbscan_d6init, fbscan_extogsig_b,
//       fbscan_extogen and fbscan_d6actestsig_b.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    BSCAN_MTAP_ADDRESS_OF_SAMPLE_PRELOAD
//       This is address of optional SAMPLE_PRELOAD register.
//
//    BSCAN_MTAP_ADDRESS_OF_PRELOAD
//       This is address of optional PRELOAD register.
//
//    BSCAN_MTAP_ADDRESS_OF_INTEST
//       This is address of optional INTEST register.
//
//    BSCAN_MTAP_ADDRESS_OF_RUNBIST
//       This is address of optional RUNBIST register.
//
//    BSCAN_MTAP_ADDRESS_OF_HIGHZ
//       This is address of optional HIGHZ register.
//
//    BSCAN_MTAP_ADDRESS_OF_EXTEST
//       This is address of optional EXTEST register.
//
//    BSCAN_MTAP_ADDRESS_OF_RESIRA
//       This is address of optional RESIRA register.
//
//    BSCAN_MTAP_ADDRESS_OF_RESIRB
//       This is address of optional RESIRB register.
//
//    BSCAN_MTAP_ADDRESS_OF_EXTEST_TOGGLE
//       This is address of optional EXTEST_TOGGLE register.
//
//    BSCAN_MTAP_ADDRESS_OF_EXTEST_PULSE
//       This is address of optional EXTEST_PULSE register.
//
//    BSCAN_MTAP_ADDRESS_OF_EXTEST_TRAIN
//       This is address of optional EXTEST_TRAIN register.
//----------------------------------------------------------------------
module mtap_bscan #( parameter BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION          = 8,
                     parameter BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION        = 0,
                     parameter BSCAN_MTAP_ADDRESS_OF_CLAMP                  = 0,
                     parameter BSCAN_MTAP_NUMBER_OF_PRELOAD_REGISTERS       = 0,
                     parameter BSCAN_MTAP_NUMBER_OF_CLAMP_REGISTERS         = 0,
                     parameter BSCAN_MTAP_NUMBER_OF_USERCODE_REGISTERS      = 0,
                     parameter BSCAN_MTAP_NUMBER_OF_INTEST_REGISTERS        = 0,
                     parameter BSCAN_MTAP_NUMBER_OF_RUNBIST_REGISTERS       = 0,
                     parameter BSCAN_MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = 0
                   )
                  (
                   // *********************************************************************
                   // Primary JTAG ports
                   // *********************************************************************
                   input  logic atappris_tck,
                   input  logic powergoodrst_trst_b,
                   input  logic mtap_fsm_tlrs,
                   input  logic mtap_fsm_rti,
                   input  logic mtap_fsm_e1dr,
                   input  logic mtap_fsm_e2dr,
                   output logic ftappris_tdo,
                   input  logic pre_tdo,

                   // *********************************************************************
                   // Boundary Scan Signals
                   // *********************************************************************
                   // Control Signals from fsm
                   // ---------------------------------------------------------------------
                   output logic fbscan_tck,
                   input  logic fbscan_tdo,
                   output logic fbscan_capturedr,
                   output logic fbscan_shiftdr,
                   output logic fbscan_updatedr,
                   output logic fbscan_updatedr_clk,
                   // ---------------------------------------------------------------------
                   // Instructions
                   // ---------------------------------------------------------------------
                   output logic fbscan_runbist_en,
                   output logic fbscan_highz,
                   output logic fbscan_extogen,
                   output logic fbscan_chainen,
                   output logic fbscan_mode,
                   output logic fbscan_extogsig_b,
                   // ---------------------------------------------------------------------
                   // 1149.6 AC mode
                   // ---------------------------------------------------------------------
                   output logic fbscan_d6init,
                   output logic fbscan_d6actestsig_b,
                   output logic fbscan_d6select,

                   // *********************************************************************
                   // FSM siganls
                   // *********************************************************************
                   input logic                                               mtap_fsm_capture_dr,
                   input logic                                               mtap_fsm_shift_dr,
                   input logic                                               mtap_fsm_update_dr,
                   input logic [(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0] mtap_irreg_ireg,
                   input logic                                               mtap_fsm_update_ir,
                   input logic [(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0] mtap_irreg_shift_reg,
                   input logic                                               mtap_fsm_shift_ir_neg//kbbhagwa posedge negedge signal merge
                   //input logic                                               mtap_fsm_shift_ir
                 );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH                                 = 1'b1;
   localparam LOW                                  = 1'b0;
   localparam BSCAN_MTAP_ADDRESS_OF_SAMPLE_PRELOAD = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h01 :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h1};
   localparam BSCAN_MTAP_ADDRESS_OF_PRELOAD        = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h03 :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h3};
   localparam BSCAN_MTAP_ADDRESS_OF_INTEST         = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h06 :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h6};
   localparam BSCAN_MTAP_ADDRESS_OF_RUNBIST        = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h07 :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h7};
   localparam BSCAN_MTAP_ADDRESS_OF_HIGHZ          = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h08 :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h8};
   localparam BSCAN_MTAP_ADDRESS_OF_EXTEST         = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h09 :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h9};
   localparam BSCAN_MTAP_ADDRESS_OF_RESIRA         = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0A :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hA};
   localparam BSCAN_MTAP_ADDRESS_OF_RESIRB         = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0B :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hB};
   localparam BSCAN_MTAP_ADDRESS_OF_EXTEST_TOGGLE  = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0D :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hD};
   localparam BSCAN_MTAP_ADDRESS_OF_EXTEST_PULSE   = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0E :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hE};
   localparam BSCAN_MTAP_ADDRESS_OF_EXTEST_TRAIN   = (BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0F :
      {{(BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hF};

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic by_two_clock;
   logic select_bscan_internal;
   logic inst_preload;
   logic inst_preload_early;
   logic inst_intest;
   logic inst_intest_early;
   logic e1dr_or_e2dr;
   logic train_or_pulse;
   logic edr_and_trainorpulse;
   logic cadr_and_extest;
   logic cadr_and_extest_dly;
   logic enable_clk;
   logic tap_d6sel_mxsel;
   logic dot6_actestsig;
   logic dot6_actestsigb;
   logic fbscan_tdo_delay;
   logic decode_pulse_shiftreg;
   logic decode_train_shiftreg;
   logic inst_extest_pulse_early;
   logic inst_extest_train_early;
   logic pulse_train_early_delay;
   logic inst_sampre_early;
   logic inst_sampre;
   logic decode_sampre_shiftreg;
   logic upir_and_sampre_shiftreg;
   logic inst_extesttoggle;
   logic inst_extesttoggle_early;
   logic inst_clamp_early;
   logic inst_clamp;
   logic inst_extest_pulse;
   logic inst_extest_train;
   logic decode_extest_shiftreg;
   logic upir_and_extest_shiftreg;
   logic inst_extest;
   logic inst_extest_early;
   logic decode_highz_shiftreg;
   logic upir_and_highz_shiftreg;
   logic inst_highz;
   logic inst_highz_early;
   logic fbscan_mode_early;
   logic fbscan_mode_early_dly;
   logic fbscan_chainen_early;
   logic fbscan_chainen_early_dly;
   logic fbscan_highz_early_dly;
   logic inst_extog_early_dly;
   logic tap_bscanshclk_en;
   logic upir_and_pulse_shiftreg;
   logic upir_and_train_shiftreg;
   logic runbist_en_early;
   logic fbscan_chainen_int;
   logic fbscan_mode_int;
   logic fbscan_d6select_int;
   //logic fbscan_updatedr_clk;

   // *********************************************************************
   // inst_extest_pulse_early logic generation
   // *********************************************************************
   assign decode_pulse_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_EXTEST_PULSE) ? HIGH : LOW;
   assign upir_and_pulse_shiftreg =  decode_pulse_shiftreg & mtap_fsm_update_ir;
   assign inst_extest_pulse       = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_EXTEST_PULSE) ? HIGH : LOW;
   assign inst_extest_pulse_early =  upir_and_pulse_shiftreg | inst_extest_pulse;

   // *********************************************************************
   // inst_extest_train_early logic generation
   // *********************************************************************
   assign decode_train_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_EXTEST_TRAIN) ? HIGH : LOW;
   assign upir_and_train_shiftreg =  decode_train_shiftreg & mtap_fsm_update_ir;
   assign inst_extest_train       = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_EXTEST_TRAIN) ? HIGH : LOW;
   assign inst_extest_train_early = upir_and_train_shiftreg | inst_extest_train;

   // *********************************************************************
   // inst_sampre_early logic generation
   // *********************************************************************
   assign decode_sampre_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_SAMPLE_PRELOAD) ? HIGH : LOW;
   assign upir_and_sampre_shiftreg =  decode_sampre_shiftreg & mtap_fsm_update_ir;
   assign inst_sampre              = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_SAMPLE_PRELOAD) ? HIGH : LOW;
   assign inst_sampre_early        =  upir_and_sampre_shiftreg | inst_sampre;

   // *********************************************************************
   // inst_extest_early logic generation
   // *********************************************************************
   assign decode_extest_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_EXTEST) ? HIGH : LOW;
   assign upir_and_extest_shiftreg =  decode_extest_shiftreg & mtap_fsm_update_ir;
   assign inst_extest              = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_EXTEST) ? HIGH : LOW;
   assign inst_extest_early        =  upir_and_extest_shiftreg | inst_extest;

   // *********************************************************************
   // inst_highz_early logic generation
   // *********************************************************************
   assign decode_highz_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_HIGHZ) ? HIGH : LOW;
   assign upir_and_highz_shiftreg =  decode_highz_shiftreg & mtap_fsm_update_ir;
   assign inst_highz              = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_HIGHZ) ? HIGH : LOW;
   assign inst_highz_early        =  upir_and_highz_shiftreg | inst_highz;

   // *********************************************************************
   // These are optional BSCAN instructions
   // *********************************************************************
   generate
      if (BSCAN_MTAP_NUMBER_OF_PRELOAD_REGISTERS > 0)
      begin
         // *********************************************************************
         // inst_preload_early logic generation
         // *********************************************************************
         logic decode_preload_shiftreg;
         logic upir_and_preload_shiftreg;

         assign decode_preload_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_PRELOAD) ? HIGH : LOW;
         assign upir_and_preload_shiftreg =  decode_preload_shiftreg & mtap_fsm_update_ir;
         assign inst_preload              = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_PRELOAD) ? HIGH : LOW;
         assign inst_preload_early        =  upir_and_preload_shiftreg | inst_preload;
      end
      else
      begin
         assign inst_preload_early = LOW;
         assign inst_preload       = LOW;
      end
      if (BSCAN_MTAP_NUMBER_OF_CLAMP_REGISTERS > 0)
      begin
         // *********************************************************************
         // inst_clamp_early logic generation
         // *********************************************************************
         logic decode_clamp_shiftreg;
         logic upir_and_clamp_shiftreg;

         assign decode_clamp_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_CLAMP) ? HIGH : LOW;
         assign upir_and_clamp_shiftreg =  decode_clamp_shiftreg & mtap_fsm_update_ir;
         assign inst_clamp              = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_CLAMP) ? HIGH : LOW;
         assign inst_clamp_early        =  upir_and_clamp_shiftreg | inst_clamp;
      end
      else
      begin
         assign inst_clamp_early = LOW;
         assign inst_clamp       = LOW;
      end
      if (BSCAN_MTAP_NUMBER_OF_INTEST_REGISTERS > 0)
      begin
         // *********************************************************************
         // inst_intest_early logic generation
         // *********************************************************************
         logic decode_intest_shiftreg;
         logic upir_and_intest_shiftreg;

         assign decode_intest_shiftreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_INTEST) ? HIGH : LOW;
         assign upir_and_intest_shiftreg =  decode_intest_shiftreg & mtap_fsm_update_ir;
         assign inst_intest              = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_INTEST) ? HIGH : LOW;
         assign inst_intest_early        =  upir_and_intest_shiftreg | inst_intest;
      end
      else
      begin
         assign inst_intest_early = LOW;
         assign inst_intest       = LOW;
      end
      if (BSCAN_MTAP_NUMBER_OF_RUNBIST_REGISTERS > 0)
      begin
         // *********************************************************************
         // runbist_en_early logic generation
         // *********************************************************************
         logic decode_runbist_en_shreg;
         logic upir_and_runbist_en_shreg;

         assign decode_runbist_en_shreg   = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_RUNBIST) ? HIGH : LOW;
         assign upir_and_runbist_en_shreg =  decode_runbist_en_shreg & mtap_fsm_update_ir;
         assign fbscan_runbist_en                = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_RUNBIST) ? HIGH : LOW;
         assign runbist_en_early          =  upir_and_runbist_en_shreg | fbscan_runbist_en;
      end
      else
      begin
         assign runbist_en_early = LOW;
         assign fbscan_runbist_en       = LOW;
      end
      if (BSCAN_MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS > 0)
      begin
         // *********************************************************************
         // inst_extesttoggle_early logic generation
         // *********************************************************************
         logic decode_extesttoggle_shreg;
         logic upir_and_extog_shiftreg;

         assign decode_extesttoggle_shreg = (mtap_irreg_shift_reg == BSCAN_MTAP_ADDRESS_OF_EXTEST_TOGGLE) ? HIGH : LOW;
         assign upir_and_extog_shiftreg   =  decode_extesttoggle_shreg & mtap_fsm_update_ir;
         assign inst_extesttoggle         = (mtap_irreg_ireg      == BSCAN_MTAP_ADDRESS_OF_EXTEST_TOGGLE) ? HIGH : LOW;
         assign inst_extesttoggle_early   =  upir_and_extog_shiftreg | decode_extesttoggle_shreg;
      end
      else
      begin
         assign inst_extesttoggle_early = LOW;
         assign inst_extesttoggle       = LOW;
      end
   endgenerate

   // *********************************************************************
   // Boundary Scan logic
   // *********************************************************************
   // select_bscan_internal: All bscan instructions are ORed
   // ---------------------------------------------------------------------
   assign select_bscan_internal = inst_sampre       |
                                  inst_preload      |
                                  inst_intest       |
                                  inst_extest       |
                                  inst_extesttoggle |
                                  inst_extest_pulse |
                                  inst_extest_train;

   // *********************************************************************
   // fbscan_mode and fbscan_chainen generation logic
   // The bscan_mode signal is asserted during those JTAG instructions that
   // actually require the boundary-scan register to take control of the pins as
   // output; i.e. this is the traditional mode control signal to the boundary-scan
   // register muxes that select between functional and boundary-scan operation.
   // It specifically includes CLAMP and HIGHZ and excludes SAMPLE/PRELOAD.
   // *********************************************************************
   assign fbscan_mode_early = inst_extesttoggle_early |
                              inst_extest_pulse_early |
                              inst_extest_train_early |
                              inst_extest_early       |
                              inst_highz_early        |
                              inst_clamp_early;

   assign fbscan_chainen_early = inst_sampre_early       |
                                 inst_preload_early      |
                                 inst_extesttoggle_early |
                                 inst_extest_pulse_early |
                                 inst_extest_train_early |
                                 inst_extest_early       |
                                 inst_highz_early        |
                                 inst_clamp_early        |
                                 inst_intest_early;

   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         fbscan_chainen_early_dly <= LOW;
         fbscan_mode_early_dly    <= LOW;
         fbscan_highz_early_dly   <= LOW;
         inst_extog_early_dly     <= LOW;
      end
      else
      begin
         fbscan_chainen_early_dly <= fbscan_chainen_early;
         fbscan_mode_early_dly    <= fbscan_mode_early;
         fbscan_highz_early_dly   <= inst_highz_early;
         inst_extog_early_dly     <= inst_extesttoggle_early;
      end
   end

   // *********************************************************************
   // fbscan_chainen generation
   // *********************************************************************
   //assign fbscan_chainen = (inst_extest       |
   //                         inst_intest       |
   //                         inst_extesttoggle |
   //                         inst_extest_train |
   //                         inst_extest_pulse |
   //                         inst_clamp        |
   //                         inst_highz        |
   //                         inst_sampre       |
   //                         inst_preload)     & fbscan_chainen_early_dly;//CTECH
   assign fbscan_chainen_int = (inst_extest       |
                                inst_intest       |
                                inst_extesttoggle |
                                inst_extest_train |
                                inst_extest_pulse |
                                inst_clamp        |
                                inst_highz        |
                                inst_sampre       |
                                inst_preload);

   sipcltapc_ctech_and2_gen i_sipcltapc_ctech_and2_gen_chainen (.a(fbscan_chainen_int), .b(fbscan_chainen_early_dly), .o(fbscan_chainen));


   // *********************************************************************
   // fbscan_mode generation
   // *********************************************************************
   //assign fbscan_mode = (inst_extest       |
   //                      inst_extesttoggle |
   //                      inst_extest_train |
   //                      inst_extest_pulse |
   //                      inst_clamp        |
   //                      inst_highz)       & fbscan_mode_early_dly;//CTECH
   assign fbscan_mode_int = (inst_extest       |
                             inst_extesttoggle |
                             inst_extest_train |
                             inst_extest_pulse |
                             inst_clamp        |
                             inst_highz);
   sipcltapc_ctech_and2_gen i_sipcltapc_ctech_and2_gen_mode (.a(fbscan_mode_int), .b(fbscan_mode_early_dly), .o(fbscan_mode));


   // *********************************************************************
   // fbscan_highz generation
   // *********************************************************************
   //assign fbscan_highz = inst_highz & fbscan_highz_early_dly;//CTECH
   sipcltapc_ctech_and2_gen i_sipcltapc_ctech_and2_gen_highz (.a(inst_highz), .b(fbscan_highz_early_dly), .o(fbscan_highz));

   // *********************************************************************
   // fbscan_extogen generation
   // *********************************************************************
   //assign fbscan_extogen = inst_extesttoggle & inst_extog_early_dly;//CTECH
   sipcltapc_ctech_and2_gen i_sipcltapc_ctech_and2_gen_extogen (.a(inst_extesttoggle), .b(inst_extog_early_dly), .o(fbscan_extogen));

   // *********************************************************************
   // fbscan_tck is pass through of primary clock atappris_tck
   // *********************************************************************
   //assign fbscan_tck = atappris_tck;
   sipcltapc_ctech_clkbf i_sipcltapc_ctech_clkbf_bscan (.o_clk(fbscan_tck), .in_clk(atappris_tck));

   // *********************************************************************
   // Capturdr, shiftdr and updatedr clocks the parallel stages of the boundary-scan
   // register flops. These signals to the bscan register is generated off a neg-edge
   // flop so that the parallel outputs of the boundary-scan register change on the
   // falling edge of the TCLK during the Update-DR state (as required by IEEE 1149.1).
   // *********************************************************************
   assign tap_bscanshclk_en = inst_sampre       |
                              inst_preload      |
                              inst_intest       |
                              inst_extesttoggle |
                              inst_extest_train |
                              inst_extest_pulse |
                              inst_extest;

   assign fbscan_capturedr = mtap_fsm_capture_dr & tap_bscanshclk_en;
   assign fbscan_shiftdr   = mtap_fsm_shift_dr   & tap_bscanshclk_en;
   assign fbscan_updatedr  = mtap_fsm_update_dr  & tap_bscanshclk_en;

   // *********************************************************************
   // Updatedr maybe needed at negative edge for some variations of BSCAN cells
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         fbscan_updatedr_clk <= LOW;
      end
      else
      begin
         fbscan_updatedr_clk <= fbscan_updatedr;
      end
   end

   // *********************************************************************
   // d6select generation
   // The tap_d6sel signal is asserted during the EXTEST_TRAIN or EXTEST_PULSE
   // instruction. It is used to place boundary-scan cells into the 1149.6 AC mode
   // which allows them to be toggled under control of the AC test signal (tap_actestsigb)
   // which takes on 1149.6 functionality during the Dot6 instructions.  This signal
   // is deglitched by running it through a flop, to prevent glitching any control
   // signals (to the custom circuits) that are switched based on being in one of
   // the 1149.6 instructions.
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         pulse_train_early_delay <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         pulse_train_early_delay <= LOW;
      end
      else
      begin
         pulse_train_early_delay <= inst_extest_pulse_early | inst_extest_train_early;
      end
   end

   //assign fbscan_d6select = (inst_extest_train | inst_extest_pulse) & pulse_train_early_delay; //CTECH
   assign fbscan_d6select_int = (inst_extest_train | inst_extest_pulse);
   sipcltapc_ctech_and2_gen i_sipcltapc_ctech_and2_gen_d6select (.a(fbscan_d6select_int), .b(pulse_train_early_delay), .o(fbscan_d6select));

   // *********************************************************************
   // d6actestsig_b generation
   // The d6actestsigb signal is the AC test waveform, driven to those
   // pins supporting 1149.6 based on extest_train.
   // *********************************************************************
   always_ff @(posedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         tap_d6sel_mxsel <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         tap_d6sel_mxsel <= LOW;
      end
      else
      begin
         tap_d6sel_mxsel <= train_or_pulse;
      end
   end

   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         dot6_actestsig <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         dot6_actestsig <= LOW;
      end
      else
      begin
         dot6_actestsig <= ((~(dot6_actestsig & inst_extest_train)) & mtap_fsm_rti);
      end
   end

   assign dot6_actestsigb      = ~dot6_actestsig;
   //assign fbscan_d6actestsig_b = (tap_d6sel_mxsel == HIGH) ? dot6_actestsigb : fbscan_extogsig_b; //CTECH MUX mx22_clk
   //sipcltapc_ctech_mx22_clk i_sipcltapc_ctech_mx22_clk_d6actest (.d1(dot6_actestsigb), .d2(fbscan_extogsig_b), .s(tap_d6sel_mxsel), .o(fbscan_d6actestsig_b));

   sipcltapc_ctech_clockmux i_sipcltapc_ctech_clockmux_d6actest ( .in1(dot6_actestsigb), .in2(fbscan_extogsig_b), .sel(tap_d6sel_mxsel), .outclk(fbscan_d6actestsig_b));
   // *********************************************************************
   // fbscan_d6init
   // The d6init signal will initialize the 1149.6 test receiver. During AC
   // test instructions (EXTEST_TRAIN, EXTEST_PULSE), the signal will go high during
   // the Exit1-DR or Exit2-DR states.? These states occur between the Shift-DR and
   // Update-DR states, so that the test receiver initialization occurs according to
   // the 1149.6-2003 Rule 6.2.3.1 . Whenever a test receiver is operating in the
   // edge-detection mode on an AC input signal, the test receiver output shall be
   // cleared of prior history at a time between exiting the Shift-DR TAP Controller
   // state and before entering the Update-DR TAP Controller state.
   // *********************************************************************
   assign e1dr_or_e2dr         = mtap_fsm_e1dr       | mtap_fsm_e2dr;
   assign train_or_pulse       = inst_extest_pulse   | inst_extest_train;
   assign edr_and_trainorpulse = train_or_pulse      & e1dr_or_e2dr;
   assign cadr_and_extest      = mtap_fsm_capture_dr & inst_extest;
   //assign enable_clk           = (edr_and_trainorpulse == HIGH) ? atappris_tck : LOW;//CTECH Clock gate enable
   //sipcltapc_ctech_clk_gate  i_sipcltapc_ctech_clk_gate_trainpulse (.en(edr_and_trainorpulse), .te(LOW), .clk(atappris_tck), .enclk(enable_clk));
   //kbbhagwa
   sipcltapc_ctech_clock_gate  i_sipcltapc_ctech_clock_gate_trainpulse (.en(edr_and_trainorpulse), .te(LOW), .clk(atappris_tck), .enclk(enable_clk));

   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         cadr_and_extest_dly <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         cadr_and_extest_dly <= LOW;
      end
      else
      begin
         cadr_and_extest_dly <= cadr_and_extest;
      end
   end

   //assign fbscan_d6init = (inst_extest == HIGH) ? cadr_and_extest_dly : enable_clk; //CTECH mx22
   //sipcltapc_ctech_mx22_clk i_sipcltapc_ctech_mx22_clk_d6init (.d1(cadr_and_extest_dly), .d2(enable_clk), .s(inst_extest), .o(fbscan_d6init));

   sipcltapc_ctech_clockmux i_sipcltapc_ctech_clockmux_d6init ( .in1(cadr_and_extest_dly), .in2(enable_clk), .sel(inst_extest), .outclk(fbscan_d6init));
   // *********************************************************************
   // Generation of divide by two clock for fbscan_extogsig_b
   // This is based on Extest Toggle instruction
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         by_two_clock <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         by_two_clock <= LOW;
      end
      else
      begin
         by_two_clock <= ~by_two_clock & inst_extesttoggle & mtap_fsm_rti;
      end
   end

   assign fbscan_extogsig_b = ~by_two_clock;

   // *********************************************************************
   // Final TDO generation which selects between final tdo (pre_tdo) from
   // mtap and bscan output (fbscan_tdo)
   // *********************************************************************
   always_ff @(negedge atappris_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         fbscan_tdo_delay <= LOW;
      end
      else if (mtap_fsm_tlrs)
      begin
         fbscan_tdo_delay <= LOW;
      end
      else
      begin
         fbscan_tdo_delay <= fbscan_tdo;
      end
   end
/*
kbbhagwa posedge negedge signal merge
https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904720 

   assign ftappris_tdo = ((select_bscan_internal & (~mtap_fsm_shift_ir)) == HIGH) ? fbscan_tdo_delay :
                         ((fbscan_runbist_en            & (~mtap_fsm_shift_ir)) == HIGH) ? fbscan_tdo_delay : pre_tdo;
*/

   assign ftappris_tdo = ((select_bscan_internal & (~mtap_fsm_shift_ir_neg)) == HIGH) ? 
                           fbscan_tdo_delay : 
                         ((fbscan_runbist_en  & (~mtap_fsm_shift_ir_neg)) == HIGH) ? 
                           fbscan_tdo_delay : pre_tdo;

   // Assertions and coverage
//kbbhagwa   `include "mtap_bscan_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053

`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
`include "mtap_bscan_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif





endmodule
