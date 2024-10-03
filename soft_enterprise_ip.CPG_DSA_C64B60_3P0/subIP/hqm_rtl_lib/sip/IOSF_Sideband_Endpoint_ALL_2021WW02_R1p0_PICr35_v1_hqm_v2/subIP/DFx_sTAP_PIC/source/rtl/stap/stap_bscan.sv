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
//    FILENAME    : stap_bscan.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP Boundary Scan Logic
//    DESCRIPTION :
//       This module generates boundary scan logic required to drive outputs.
//    BUGS/ISSUES/ECN FIXES:
//       SEG Slave Tap SIP: Default value of Bscan extogsig_b and d6actestsig_b should be high.
//       Updated logic for signals, stap_fbscan_d6init, stap_fbscan_extogsig_b,
//       stap_fbscan_extogen and stap_fbscan_d6actestsig_b.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD
//       This is address of optional SAMPLE_PRELOAD register.
//
//    BSCAN_STAP_ADDRESS_OF_PRELOAD
//       This is address of optional PRELOAD register.
//
//    BSCAN_STAP_ADDRESS_OF_INTEST
//       This is address of optional INTEST register.
//
//    BSCAN_STAP_ADDRESS_OF_RUNBIST
//       This is address of optional RUNBIST register.
//
//    BSCAN_STAP_ADDRESS_OF_HIGHZ
//       This is address of optional HIGHZ register.
//
//    BSCAN_STAP_ADDRESS_OF_EXTEST
//       This is address of optional EXTEST register.
//
//    BSCAN_STAP_ADDRESS_OF_RESIRA
//       This is address of optional RESIRA register.
//
//    BSCAN_STAP_ADDRESS_OF_RESIRB
//       This is address of optional RESIRB register.
//
//    BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE
//       This is address of optional EXTEST_TOGGLE register.
//
//    BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE
//       This is address of optional EXTEST_PULSE register.
//
//    BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN
//       This is address of optional EXTEST_TRAIN register.
//----------------------------------------------------------------------
module stap_bscan #( parameter BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION          = 8,
                     parameter BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION        = 0,
                     parameter BSCAN_STAP_ADDRESS_OF_CLAMP                  = 0,
                     parameter BSCAN_STAP_NUMBER_OF_PRELOAD_REGISTERS       = 0,
                     parameter BSCAN_STAP_NUMBER_OF_CLAMP_REGISTERS         = 0,
                     parameter BSCAN_STAP_NUMBER_OF_INTEST_REGISTERS        = 0,
                     parameter BSCAN_STAP_NUMBER_OF_RUNBIST_REGISTERS       = 0,
                     parameter BSCAN_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = 0
                   )
                  (
                   // *********************************************************************
                   // Primary JTAG ports
                   // *********************************************************************
                   input  logic ftap_tck,
                   input  logic powergood_rst_trst_b,
                   input  logic stap_fsm_tlrs,
                   input  logic stap_fsm_rti,
                   input  logic stap_fsm_e1dr,
                   input  logic stap_fsm_e2dr,
                   output logic atap_tdo,
                   input  logic pre_tdo,

                   // *********************************************************************
                   // Boundary Scan Signals
                   // *********************************************************************
                   // Control Signals from fsm
                   // ---------------------------------------------------------------------
                   output logic stap_fbscan_tck,
                   input  logic stap_abscan_tdo,
                   output logic stap_fbscan_capturedr,
                   output logic stap_fbscan_shiftdr,
                   output logic stap_fbscan_updatedr,
                   output logic stap_fbscan_updatedr_clk,
                   // ---------------------------------------------------------------------
                   // Instructions
                   // ---------------------------------------------------------------------
                   output logic stap_fbscan_runbist_en,
                   output logic stap_fbscan_highz,
                   output logic stap_fbscan_extogen,
                   output logic stap_fbscan_intest_mode,
                   output logic stap_fbscan_chainen,
                   output logic stap_fbscan_mode,
                   output logic stap_fbscan_extogsig_b,
                   // ---------------------------------------------------------------------
                   // 1149.6 AC mode
                   // ---------------------------------------------------------------------
                   output logic stap_fbscan_d6init,
                   output logic stap_fbscan_d6actestsig_b,
                   output logic stap_fbscan_d6select,

                   // *********************************************************************
                   // FSM siganls
                   // *********************************************************************
                   input logic                                               stap_fsm_capture_dr,
                   input logic                                               stap_fsm_shift_dr,
                   input logic                                               stap_fsm_update_dr,
                   input logic [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - 1):0] stap_irreg_ireg,
                   input logic                                               stap_fsm_update_ir,
                   input logic [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - 1):0] stap_irreg_shift_reg,
                   input logic                                               stap_fsm_shift_ir_neg //kbbhagwa posedge negedge signal merge
                 );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH                                 = 1'b1;
   localparam LOW                                  = 1'b0;
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h01 :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h1};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_PRELOAD        = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h03 :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h3};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_INTEST         = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h06 :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h6};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_RUNBIST        = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h07 :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h7};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_HIGHZ          = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h08 :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h8};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST         = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h09 :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h9};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_RESIRA         = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0A :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hA};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_RESIRB         = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0B :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hB};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE  = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0D :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hD};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE   = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0E :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hE};
   localparam [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN   = (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h0F :
      {{(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'hF};

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic by_two_clock;
   logic select_bscan_internal;
   logic inst_preload;
   logic inst_preload_early;
   logic inst_intest;
   logic inst_intest_early;
   logic fbscan_intest_early_dly;
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
   logic stap_fbscan_chainen_int;
   logic stap_fbscan_mode_int;
   logic stap_fbscan_d6select_int;

   // *********************************************************************
   // inst_extest_pulse_early logic generation
   // *********************************************************************
   assign decode_pulse_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE) ? HIGH : LOW;
   assign upir_and_pulse_shiftreg =  decode_pulse_shiftreg & stap_fsm_update_ir;
   assign inst_extest_pulse       = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE) ? HIGH : LOW;
   assign inst_extest_pulse_early =  upir_and_pulse_shiftreg | inst_extest_pulse;

   // *********************************************************************
   // inst_extest_train_early logic generation
   // *********************************************************************
   assign decode_train_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN) ? HIGH : LOW;
   assign upir_and_train_shiftreg =  decode_train_shiftreg & stap_fsm_update_ir;
   assign inst_extest_train       = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN) ? HIGH : LOW;
   assign inst_extest_train_early = upir_and_train_shiftreg | inst_extest_train;

   // *********************************************************************
   // inst_sampre_early logic generation
   // *********************************************************************
   assign decode_sampre_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD) ? HIGH : LOW;
   assign upir_and_sampre_shiftreg =  decode_sampre_shiftreg & stap_fsm_update_ir;
   assign inst_sampre              = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD) ? HIGH : LOW;
   assign inst_sampre_early        =  upir_and_sampre_shiftreg | inst_sampre;

   // *********************************************************************
   // inst_extest_early logic generation
   // *********************************************************************
   assign decode_extest_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_EXTEST) ? HIGH : LOW;
   assign upir_and_extest_shiftreg =  decode_extest_shiftreg & stap_fsm_update_ir;
   assign inst_extest              = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_EXTEST) ? HIGH : LOW;
   assign inst_extest_early        =  upir_and_extest_shiftreg | inst_extest;

   // *********************************************************************
   // inst_highz_early logic generation
   // *********************************************************************
   assign decode_highz_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_HIGHZ) ? HIGH : LOW;
   assign upir_and_highz_shiftreg =  decode_highz_shiftreg & stap_fsm_update_ir;
   assign inst_highz              = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_HIGHZ) ? HIGH : LOW;
   assign inst_highz_early        =  upir_and_highz_shiftreg | inst_highz;

   // *********************************************************************
   // These are optional BSCAN instructions
   // *********************************************************************
   generate
      if (BSCAN_STAP_NUMBER_OF_PRELOAD_REGISTERS > 0)
      begin:generate_preload_reg
         // *********************************************************************
         // inst_preload_early logic generation
         // *********************************************************************
         logic decode_preload_shiftreg;
         logic upir_and_preload_shiftreg;

         assign decode_preload_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_PRELOAD) ? HIGH : LOW;
         assign upir_and_preload_shiftreg =  decode_preload_shiftreg & stap_fsm_update_ir;
         assign inst_preload              = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_PRELOAD) ? HIGH : LOW;
         assign inst_preload_early        =  upir_and_preload_shiftreg | inst_preload;
      end
      else
      begin:generate_preload_reg
         assign inst_preload_early = LOW;
         assign inst_preload       = LOW;
      end

      if (BSCAN_STAP_NUMBER_OF_CLAMP_REGISTERS > 0)
      begin:generate_clamp_reg
         // *********************************************************************
         // inst_clamp_early logic generation
         // *********************************************************************
         logic decode_clamp_shiftreg;
         logic upir_and_clamp_shiftreg;

         assign decode_clamp_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_CLAMP) ? HIGH : LOW;
         assign upir_and_clamp_shiftreg =  decode_clamp_shiftreg & stap_fsm_update_ir;
         assign inst_clamp              = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_CLAMP) ? HIGH : LOW;
         assign inst_clamp_early        =  upir_and_clamp_shiftreg | inst_clamp;
      end
      else
      begin:generate_clamp_reg
         assign inst_clamp_early = LOW;
         assign inst_clamp       = LOW;
      end

      if (BSCAN_STAP_NUMBER_OF_INTEST_REGISTERS > 0)
      begin:generate_intest_reg
         // *********************************************************************
         // inst_intest_early logic generation
         // *********************************************************************
         logic decode_intest_shiftreg;
         logic upir_and_intest_shiftreg;

         assign decode_intest_shiftreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_INTEST) ? HIGH : LOW;
         assign upir_and_intest_shiftreg =  decode_intest_shiftreg & stap_fsm_update_ir;
         assign inst_intest              = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_INTEST) ? HIGH : LOW;
         assign inst_intest_early        =  upir_and_intest_shiftreg | inst_intest;
      end
      else
      begin:generate_intest_reg
         assign inst_intest_early = LOW;
         assign inst_intest       = LOW;
      end

      if (BSCAN_STAP_NUMBER_OF_RUNBIST_REGISTERS > 0)
      begin:generate_runbist_reg
         // *********************************************************************
         // runbist_en_early logic generation
         // *********************************************************************
         logic decode_runbist_en_shreg;
         logic upir_and_runbist_en_shreg;

         assign decode_runbist_en_shreg   = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_RUNBIST) ? HIGH : LOW;
         assign upir_and_runbist_en_shreg =  decode_runbist_en_shreg & stap_fsm_update_ir;
         assign stap_fbscan_runbist_en    = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_RUNBIST) ? HIGH : LOW;
         assign runbist_en_early          =  upir_and_runbist_en_shreg | stap_fbscan_runbist_en;
      end
      else
      begin:generate_runbist_reg
         assign runbist_en_early       = LOW;
         assign stap_fbscan_runbist_en = LOW;
      end

      if (BSCAN_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS > 0)
      begin:generate_extest_toggle_reg
         // *********************************************************************
         // inst_extesttoggle_early logic generation
         // *********************************************************************
         logic decode_extesttoggle_shreg;
         logic upir_and_extog_shiftreg;

         assign decode_extesttoggle_shreg = (stap_irreg_shift_reg == BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE) ? HIGH : LOW;
         assign upir_and_extog_shiftreg   =  decode_extesttoggle_shreg & stap_fsm_update_ir;
         assign inst_extesttoggle         = (stap_irreg_ireg      == BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE) ? HIGH : LOW;
         assign inst_extesttoggle_early   =  upir_and_extog_shiftreg | decode_extesttoggle_shreg;
      end
      else
      begin:generate_extest_toggle_reg
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
   // stap_fbscan_mode and stap_fbscan_chainen generation logic
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

   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         fbscan_chainen_early_dly <= LOW;
         fbscan_mode_early_dly    <= LOW;
         fbscan_highz_early_dly   <= LOW;
         inst_extog_early_dly     <= LOW;
         fbscan_intest_early_dly  <= LOW;
      end
      else
      begin
         fbscan_chainen_early_dly <= fbscan_chainen_early;
         fbscan_mode_early_dly    <= fbscan_mode_early;
         fbscan_highz_early_dly   <= inst_highz_early;
         inst_extog_early_dly     <= inst_extesttoggle_early;
         fbscan_intest_early_dly  <= inst_intest_early;
      end
   end

   // *********************************************************************
   // stap_fbscan_chainen generation
   // *********************************************************************
   assign stap_fbscan_chainen_int = (inst_extest       |
                                     inst_intest       |
                                     inst_extesttoggle |
                                     inst_extest_train |
                                     inst_extest_pulse |
                                     inst_clamp        |
                                     inst_highz        |
                                     inst_sampre       |
                                     inst_preload);

   stap_ctech_lib_and i_stap_ctech_lib_and_chainen (.a(stap_fbscan_chainen_int), .b(fbscan_chainen_early_dly), .o(stap_fbscan_chainen));

   // *********************************************************************
   // stap_fbscan_mode generation
   // *********************************************************************
   assign stap_fbscan_mode_int = (inst_extest       |
                                  inst_extesttoggle |
                                  inst_extest_train |
                                  inst_extest_pulse |
                                  inst_clamp        |
                                  inst_highz);

   stap_ctech_lib_and i_stap_ctech_lib_and_mode (.a(stap_fbscan_mode_int), .b(fbscan_mode_early_dly), .o(stap_fbscan_mode));

   // *********************************************************************
   // stap_fbscan_highz generation
   // *********************************************************************
   stap_ctech_lib_and i_stap_ctech_lib_and_highz (.a(inst_highz), .b(fbscan_highz_early_dly), .o(stap_fbscan_highz));

   // *********************************************************************
   // stap_fbscan_extogen generation
   // *********************************************************************
   stap_ctech_lib_and i_stap_ctech_lib_and_extogen (.a(inst_extesttoggle), .b(inst_extog_early_dly), .o(stap_fbscan_extogen));

   // *********************************************************************
   // stap_fbscan_intest_mode generation
   // *********************************************************************
   stap_ctech_lib_and i_stap_ctech_lib_and_intest (.a(inst_intest), .b(fbscan_intest_early_dly), .o(stap_fbscan_intest_mode));

   // *********************************************************************
   // stap_fbscan_tck is pass through of primary clock ftap_tck
   // *********************************************************************
   stap_ctech_lib_clk_buf i_stap_ctech_lib_clk_buf_bscan (.clkout(stap_fbscan_tck), .clk(ftap_tck));

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

   assign stap_fbscan_capturedr = stap_fsm_capture_dr & tap_bscanshclk_en;
   assign stap_fbscan_shiftdr   = stap_fsm_shift_dr   & tap_bscanshclk_en;
   assign stap_fbscan_updatedr  = stap_fsm_update_dr  & tap_bscanshclk_en;

   // *********************************************************************
   // Updatedr maybe needed at negative edge for some variations of BSCAN cells
   // *********************************************************************
   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         stap_fbscan_updatedr_clk <= LOW;
      end
      else
      begin
         stap_fbscan_updatedr_clk <= stap_fbscan_updatedr;
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
   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         pulse_train_early_delay <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         pulse_train_early_delay <= LOW;
      end
      else
      begin
         pulse_train_early_delay <= inst_extest_pulse_early | inst_extest_train_early;
      end
   end

   assign stap_fbscan_d6select_int = (inst_extest_train | inst_extest_pulse);
   stap_ctech_lib_and i_stap_ctech_lib_and_d6select (.a(stap_fbscan_d6select_int), .b(pulse_train_early_delay), .o(stap_fbscan_d6select));

   // *********************************************************************
   // d6actestsig_b generation
   // The d6actestsigb signal is the AC test waveform, driven to those
   // pins supporting 1149.6 based on extest_train.
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         tap_d6sel_mxsel <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         tap_d6sel_mxsel <= LOW;
      end
      else
      begin
         tap_d6sel_mxsel <= train_or_pulse;
      end
   end

   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         dot6_actestsig <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         dot6_actestsig <= LOW;
      end
      else
      begin
         dot6_actestsig <= ((~(dot6_actestsig & inst_extest_train)) & stap_fsm_rti);
      end
   end

   assign dot6_actestsigb      = ~dot6_actestsig;

 //  stap_ctech_lib_clk_mux_2to1 i_stap_ctech_lib_clk_mux_2to1_d6actest ( .clk1(dot6_actestsigb), .clk2(stap_fbscan_extogsig_b), .s(tap_d6sel_mxsel), .clkout(stap_fbscan_d6actestsig_b));
 stap_ctech_lib_mux_2to1 i_stap_ctech_lib_mux_2to1_d6actest ( .d1(dot6_actestsigb ), .d2(stap_fbscan_extogsig_b ), .s(tap_d6sel_mxsel ), .o(stap_fbscan_d6actestsig_b ) );
   // *********************************************************************
   // stap_fbscan_d6init
   // The d6init signal will initialize the 1149.6 test receiver. During AC
   // test instructions (EXTEST_TRAIN, EXTEST_PULSE), the signal will go high during
   // the Exit1-DR or Exit2-DR states.? These states occur between the Shift-DR and
   // Update-DR states, so that the test receiver initialization occurs according to
   // the 1149.6-2003 Rule 6.2.3.1 . Whenever a test receiver is operating in the
   // edge-detection mode on an AC input signal, the test receiver output shall be
   // cleared of prior history at a time between exiting the Shift-DR TAP Controller
   // state and before entering the Update-DR TAP Controller state.
   // *********************************************************************
   assign e1dr_or_e2dr         = stap_fsm_e1dr       | stap_fsm_e2dr;
   assign train_or_pulse       = inst_extest_pulse   | inst_extest_train;
   assign edr_and_trainorpulse = train_or_pulse      & e1dr_or_e2dr;
   assign cadr_and_extest      = stap_fsm_capture_dr & inst_extest;

   stap_ctech_lib_clk_gate_te  i_stap_ctech_lib_clk_gate_te_trainpulse (.en(edr_and_trainorpulse), .te(LOW), .clk(ftap_tck), .clkout(enable_clk));

   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         cadr_and_extest_dly <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         cadr_and_extest_dly <= LOW;
      end
      else
      begin
         cadr_and_extest_dly <= cadr_and_extest;
      end
   end

   stap_ctech_lib_clk_mux_2to1 i_stap_ctech_lib_clk_mux_2to1_d6init ( .clk1(cadr_and_extest_dly), .clk2(enable_clk), .s(inst_extest), .clkout(stap_fbscan_d6init));

   // *********************************************************************
   // Generation of divide by two clock for stap_fbscan_extogsig_b
   // This is based on Extest Toggle instruction
   // *********************************************************************
   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         by_two_clock <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         by_two_clock <= LOW;
      end
      else
      begin
         by_two_clock <= ~by_two_clock & inst_extesttoggle & stap_fsm_rti;
      end
   end

   assign stap_fbscan_extogsig_b = ~by_two_clock;

   // *********************************************************************
   // Final TDO generation which selects between final tdo (pre_tdo) from
   // stap and bscan output (stap_abscan_tdo)
   // *********************************************************************
   always_ff @(negedge ftap_tck or negedge powergood_rst_trst_b)
   begin
      if (!powergood_rst_trst_b)
      begin
         fbscan_tdo_delay <= LOW;
      end
      else if (stap_fsm_tlrs)
      begin
         fbscan_tdo_delay <= LOW;
      end
	  else if (stap_fsm_capture_dr) //Fix for HSD 1609797562
      begin
         fbscan_tdo_delay <= LOW;
      end
	  else if(stap_fsm_shift_dr)  //Fix for HSD 1609797573
      begin
         fbscan_tdo_delay <= stap_abscan_tdo;
      end
   end

   assign atap_tdo = ((select_bscan_internal & (~stap_fsm_shift_ir_neg)) == HIGH) ? fbscan_tdo_delay :
                     ((stap_fbscan_runbist_en  & (~stap_fsm_shift_ir_neg)) == HIGH) ? fbscan_tdo_delay : pre_tdo;

   // Assertions and coverage
`ifndef INTEL_SVA_OFF
`ifndef STAP_SVA_OFF
`ifdef INTEL_SIMONLY
      `include "stap_bscan_include.sv"
 `endif 
 `endif 
 `endif 
endmodule
