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

// ====================================================================
// Check if shiftdr, capturedr, updatedr change on negedge of TCK
// ====================================================================

module stap_bscan_assertions #( parameter BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION          = 8,
                             parameter BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION        = 0,
                             parameter BSCAN_STAP_ADDRESS_OF_CLAMP                  = 0,
                             parameter BSCAN_STAP_NUMBER_OF_PRELOAD_REGISTERS       = 0,
                             parameter BSCAN_STAP_NUMBER_OF_CLAMP_REGISTERS         = 0,
                             parameter BSCAN_STAP_NUMBER_OF_INTEST_REGISTERS        = 0,
                             parameter BSCAN_STAP_NUMBER_OF_RUNBIST_REGISTERS       = 0,
                             parameter BSCAN_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = 0,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD = 8'h01,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_PRELOAD        = 8'h03,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_INTEST         = 8'h06,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_RUNBIST        = 8'h07,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_HIGHZ          = 8'h08,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST         = 8'h09,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_RESIRA         = 8'h0A,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_RESIRB         = 8'h0B,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE  = 8'h0D,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE   = 8'h0E,
                             parameter [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION-1):0] BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN   = 8'h0F

                           )
(
   input logic ftap_tck,
   input logic stap_fbscan_capturedr,
   input logic powergood_rst_trst_b,
   input logic stap_fbscan_shiftdr,
   input logic stap_fbscan_updatedr,
   input logic stap_fbscan_updatedr_clk,
   input logic stap_fsm_tlrs,
   input logic stap_fbscan_mode,
   input logic stap_fbscan_highz,
   input logic stap_fbscan_chainen,
   input logic stap_fbscan_extogen,
   input logic stap_fbscan_extogsig_b,
   input logic stap_fbscan_d6select,
   input logic stap_fbscan_d6init,
   input logic stap_fbscan_d6actestsig_b,
   input logic [(BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION - 1):0] stap_irreg_ireg,
   input logic inst_extest,
   input logic inst_sampre,
   input logic stap_fsm_capture_dr,
   input logic stap_fsm_rti,
   input logic inst_extest_train,
   input logic e1dr_or_e2dr,
   input logic inst_extest_pulse,
   input logic inst_clamp,
   input logic inst_highz,
   input logic inst_preload,
   input logic inst_intest,
   input logic train_or_pulse
);

localparam LOW =1'b0;
localparam HIGH =1'b1;
// Obtain pulse for TCK
wire      ftap_tck_delayed_by_1ps;
wire      ftap_clk_raising_edge_pulse;
wire      ftap_clk_falling_edge_pulse;
assign #1ps ftap_tck_delayed_by_1ps      =  ftap_tck;
assign    ftap_clk_raising_edge_pulse  = ~ftap_tck_delayed_by_1ps &  ftap_tck;
assign    ftap_clk_falling_edge_pulse  =  ftap_tck_delayed_by_1ps & ~ftap_tck;
//------------------------------------------------------------------------------------------------------------

// Obtain pulse for CaptureDR
wire      fbscan_capturedr_delayed_by_1ps;
wire      fbscan_capturedr_raising_edge_pulse;
wire      fbscan_capturedr_falling_edge_pulse;
assign #1ps fbscan_capturedr_delayed_by_1ps      =   stap_fbscan_capturedr;
assign    fbscan_capturedr_raising_edge_pulse  =  ~fbscan_capturedr_delayed_by_1ps &  stap_fbscan_capturedr;
assign    fbscan_capturedr_falling_edge_pulse  =   fbscan_capturedr_delayed_by_1ps & ~stap_fbscan_capturedr;

// Valid   -- CaptureDR changing on negedge of TCK
wire      capturedr_raising_valid;
wire      capturedr_falling_valid;
assign    capturedr_raising_valid = fbscan_capturedr_raising_edge_pulse & ftap_clk_raising_edge_pulse;
assign    capturedr_falling_valid = fbscan_capturedr_falling_edge_pulse & ftap_clk_raising_edge_pulse;

//------------------------------------------------------------------------------------------------------------

`ifdef DFX_COVERAGE_ON
      // ======================================================================
      // This covers the raising edge of stap_fbscan_capturedr on falling edge of TCK
      // ======================================================================
      property stap_bscan_raising_capturedr_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               capturedr_raising_valid === HIGH;
      endproperty: stap_bscan_raising_capturedr_during_negedge_clk
      cov_stap_bscan_raising_capturedr_during_negedge_clk: cover property (stap_bscan_raising_capturedr_during_negedge_clk);
      // ======================================================================
      // This covers the falling edge of stap_fbscan_capturedr on falling edge of TCK
      // ======================================================================
      property stap_bscan_falling_capturedr_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               capturedr_falling_valid === HIGH;
      endproperty: stap_bscan_falling_capturedr_during_negedge_clk
      cov_stap_bscan_falling_capturedr_during_negedge_clk: cover property (stap_bscan_falling_capturedr_during_negedge_clk);
`endif
//-------------------------------------------------------------------------------------------------------------

      // Obtain pulse for shiftDR
      wire      fbscan_shiftdr_delayed_by_1ps;
      wire      fbscan_shiftdr_raising_edge_pulse;
      wire      fbscan_shiftdr_falling_edge_pulse;
      assign #1ps fbscan_shiftdr_delayed_by_1ps      =   stap_fbscan_shiftdr;
      assign    fbscan_shiftdr_raising_edge_pulse  =  ~fbscan_shiftdr_delayed_by_1ps &  stap_fbscan_shiftdr;
      assign    fbscan_shiftdr_falling_edge_pulse  =   fbscan_shiftdr_delayed_by_1ps & ~stap_fbscan_shiftdr;

      // Valid   -- shiftDR changing on negedge of TCK
      wire      shiftdr_raising_valid;
      wire      shiftdr_falling_valid;
      assign    shiftdr_raising_valid = fbscan_shiftdr_raising_edge_pulse & ftap_clk_raising_edge_pulse;
      assign    shiftdr_falling_valid = fbscan_shiftdr_falling_edge_pulse & ftap_clk_raising_edge_pulse;

      //------------------------------------------------------------------------------------------------------------

`ifdef DFX_COVERAGE_ON
      // ======================================================================
      // This covers the raising edge of stap_fbscan_shiftdr on falling edge of TCK
      // ======================================================================
      property stap_bscan_raising_shiftdr_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               shiftdr_raising_valid === HIGH;
      endproperty: stap_bscan_raising_shiftdr_during_negedge_clk
      cov_stap_bscan_raising_shiftdr_during_negedge_clk: cover property (stap_bscan_raising_shiftdr_during_negedge_clk);
      // ======================================================================
      // This covers the falling edge of stap_fbscan_shiftdr on falling edge of TCK
      // ======================================================================
      property stap_bscan_falling_shiftdr_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               shiftdr_falling_valid === HIGH;
      endproperty: stap_bscan_falling_shiftdr_during_negedge_clk
      cov_stap_bscan_falling_shiftdr_during_negedge_clk: cover property (stap_bscan_falling_shiftdr_during_negedge_clk);
`endif
//-------------------------------------------------------------------------------------------------------------

      // Obtain pulse for updateDR
      wire      fbscan_updatedr_delayed_by_1ps;
      wire      fbscan_updatedr_raising_edge_pulse;
      wire      fbscan_updatedr_falling_edge_pulse;
      assign #1ps fbscan_updatedr_delayed_by_1ps      =   stap_fbscan_updatedr;
      assign    fbscan_updatedr_raising_edge_pulse  =  ~fbscan_updatedr_delayed_by_1ps &  stap_fbscan_updatedr;
      assign    fbscan_updatedr_falling_edge_pulse  =   fbscan_updatedr_delayed_by_1ps & ~stap_fbscan_updatedr;

      // Valid   -- updateDR changing on negedge of TCK
      wire      updatedr_raising_valid;
      wire      updatedr_falling_valid;
      assign    updatedr_raising_valid = fbscan_updatedr_raising_edge_pulse & ftap_clk_raising_edge_pulse;
      assign    updatedr_falling_valid = fbscan_updatedr_falling_edge_pulse & ftap_clk_raising_edge_pulse;

      //------------------------------------------------------------------------------------------------------------

`ifdef DFX_COVERAGE_ON
      // ======================================================================
      // This covers the raising edge of stap_fbscan_updatedr on falling edge of TCK
      // ======================================================================
      property stap_bscan_raising_updatedr_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               updatedr_raising_valid === HIGH;
      endproperty: stap_bscan_raising_updatedr_during_negedge_clk
      cov_stap_bscan_raising_updatedr_during_negedge_clk: cover property (stap_bscan_raising_updatedr_during_negedge_clk);
      // ======================================================================
      // This covers the falling edge of stap_fbscan_updatedr on falling edge of TCK
      // ======================================================================
      property stap_bscan_falling_updatedr_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               updatedr_falling_valid === HIGH;
      endproperty: stap_bscan_falling_updatedr_during_negedge_clk
      cov_stap_bscan_falling_updatedr_during_negedge_clk: cover property (stap_bscan_falling_updatedr_during_negedge_clk);
`endif
//------------------------------------------------------------------------------------------------------------

      // Obtain pulse for updateDR_clk
      wire      fbscan_updatedr_clk_delayed_by_1ps;
      wire      fbscan_updatedr_clk_raising_edge_pulse;
      wire      fbscan_updatedr_clk_falling_edge_pulse;
      assign #1ps fbscan_updatedr_clk_delayed_by_1ps      =   stap_fbscan_updatedr_clk;
      assign    fbscan_updatedr_clk_raising_edge_pulse  =  ~fbscan_updatedr_clk_delayed_by_1ps &  stap_fbscan_updatedr_clk;
      assign    fbscan_updatedr_clk_falling_edge_pulse  =   fbscan_updatedr_clk_delayed_by_1ps & ~stap_fbscan_updatedr_clk;

      // Valid   -- updateDR changing on negedge of TCK
      wire      updatedr_clk_raising_valid;
      assign    updatedr_clk_raising_valid = fbscan_updatedr_clk_raising_edge_pulse & ftap_clk_raising_edge_pulse;

      //------------------------------------------------------------------------------------------------------------

`ifdef DFX_COVERAGE_ON
      // ======================================================================
      // This covers the raising edge of fbscan_updatedr_clk on posedge of TCK
      // ======================================================================
      property stap_bscan_raising_updatedr_clk_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               updatedr_clk_raising_valid === HIGH;
      endproperty: stap_bscan_raising_updatedr_clk_during_negedge_clk
      cov_stap_bscan_raising_updatedr_clk_during_posedge_clk: cover property (stap_bscan_raising_updatedr_clk_during_negedge_clk);
      // ======================================================================
      // This covers the falling edge of fbscan_updatedr_clk on falling edge of TCK
      // ======================================================================
      property stap_bscan_falling_updatedr_clk_during_negedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               updatedr_falling_valid === HIGH;
      endproperty: stap_bscan_falling_updatedr_clk_during_negedge_clk
      cov_stap_bscan_falling_updatedr_clk_during_negedge_clk: cover property (stap_bscan_falling_updatedr_clk_during_negedge_clk);

`endif
//************************************************************************************************************
`ifndef INTEL_SVA_OFF
`ifndef STAP_SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Check for the Reset Values of the Signal
      // ====================================================================
      always @(negedge ftap_tck)
      begin
		  if (stap_fsm_tlrs === HIGH && powergood_rst_trst_b === HIGH )
         begin
            #1ps;
            chk_if_bscan_ex1_at_reset_then_mode_equals_zero: assert (stap_fbscan_mode === LOW)
            else $error("Mode is not Low at Reset");

            chk_if_bscan_ex2_at_reset_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
            else $error("HighZ is not Low at Reset");

            chk_if_bscan_ex3_at_reset_then_chainen_equals_zero: assert (stap_fbscan_chainen === LOW)
            else $error("Chain enable is not Low at Reset");

            chk_if_bscan_ex4_at_reset_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
            else $error("Extog enable is not Low at Reset");

            chk_if_bscan_ex5_at_reset_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
            else $error("Extogsig is not HIGH at Reset");

            chk_if_bscan_ex6_at_reset_then_d6sel_b_equals_zero: assert (stap_fbscan_d6select === LOW)
            else $error("D6Select is not LOW at Reset");

            chk_if_bscan_ex7_at_reset_then_d6init_equals_zero: assert (stap_fbscan_d6init === LOW)
            else $error("D6int is not LOW at Reset");

            chk_if_bscan_ex8_at_reset_then_d6actestsig_b_equals_one: assert (stap_fbscan_d6actestsig_b === HIGH)
            else $error("D6actsig_b is not HIGH at Reset");

         end
      end
      // ====================================================================
      // Check for BSCAN sigals during SAMPLE/PRELOAD instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_sampre,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD))
            begin

               chk_if_bscan_ex1_sample_preload_then_mode_equals_zero: assert (stap_fbscan_mode === LOW)
               else $error("Mode is not Low for a Bscan instruction: SAMPLE_PRELOAD");

               chk_if_bscan_ex2_sample_preload_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HighZ is not Low for a Bscan instruction: SAMPLE_PRELOAD");

               chk_if_bscan_ex3_sample_preload_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not High for a Bscan instruction: SAMPLE_PRELOAD");

               chk_if_bscan_ex4_sample_preload_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not Low for a Bscan instruction: SAMPLE_PRELOAD");

               chk_if_bscan_ex5_sample_preload_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not HIGH for a Bscan instruction: SAMPLE_PRELOAD");

               chk_if_bscan_ex6_sample_preload_then_d6sel_b_equals_zero: assert (stap_fbscan_d6select === LOW)
               else $error("D6Select is not LOW for a Bscan instruction: SAMPLE_PRELOAD");

               chk_if_bscan_ex7_sample_preload_then_d6init_equals_zero: assert (stap_fbscan_d6init === LOW)
               else $error("D6int is not LOW for a Bscan instruction: SAMPLE_PRELOAD");

               chk_if_bscan_ex8_sample_preload_then_d6actestsig_b_equals_one: assert (stap_fbscan_d6actestsig_b === HIGH)
               else $error("D6actsig_b is not HIGH for a Bscan instruction: SAMPLE_PRELOAD");

            end
         end
      end
      // ====================================================================
      // Check for BSCAN sigals during EXTEST instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_extest,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_EXTEST))
            begin

               chk_if_bscan_ex1_extest_then_mode_equals_one: assert (stap_fbscan_mode === HIGH)
               else $error("Mode is not High for a Bscan instruction: EXTEST");

               chk_if_bscan_ex2_extest_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HIGHZ is not Low for a Bscan instruction: EXTEST");

               chk_if_bscan_ex3_extest_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not high for a Bscan instruction: EXTEST");

               chk_if_bscan_ex4_extest_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not Low for a Bscan instruction: EXTEST");

               chk_if_bscan_ex5_extest_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not high for a Bscan instruction: EXTEST");

               chk_if_bscan_ex6_extest_then_d6select_equals_zero: assert (stap_fbscan_d6select === LOW)
               else $error("D6Select is not LOW  for a Bscan instruction: EXTEST");

              // chk_if_bscan_ex7_extest_preload_then_d6init_equals_pulse: assert property (stap_fsm_capture_dr |=> stap_fbscan_d6init ##1 !stap_fbscan_d6init)
              // else $error("D6int is not Pulse for a Bscan instruction: EXTEST");

               chk_if_bscan_ex8_extest_preload_then_d6actestsig_b_equals_one: assert (stap_fbscan_d6actestsig_b === HIGH)
               else $error("D6actsig_b is not HIGH for a Bscan instruction: EXTEST");

            end
         end
      end
     property my_chk;
       @(negedge ftap_tck)

       ((stap_fsm_tlrs === LOW) && (($past(inst_extest,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_EXTEST))) && stap_fsm_capture_dr |=> stap_fbscan_d6init ##1 !stap_fbscan_d6init;

      endproperty


chk_if_bscan_ex9_extest_preload_then_d6init_equals_pulse: assert property (my_chk); // ====================================================================
      // Check for BSCAN sigals during EXTEST TOGGLE instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(stap_fbscan_extogen,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE) && (stap_fsm_rti === HIGH))
            begin

               chk_if_bscan_ex1_extest_tgl_then_mode_equals_one: assert (stap_fbscan_mode === HIGH)
               else $error("Mode is not High for a Bscan instruction: EXTEST TOGGLE");

               chk_if_bscan_ex2_extest_tgl_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HIGHZ is not Low for a Bscan instruction: EXTEST TOGGLE");

               chk_if_bscan_ex3_extest_tgl_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not high for a Bscan instruction: EXTEST TOGGLE");

               chk_if_bscan_ex4_extest_tgl_then_extogen_equals_one: assert (stap_fbscan_extogen === HIGH)
               else $error("Extog enable is not high for a Bscan instruction: EXTEST TOGGLE");

               if($past(stap_fsm_rti,1) === 1'b0) begin
                  chk_if_bscan_ex5a_extest_tgl_then_extogsig_b_one_when_not_active: assert (stap_fbscan_extogsig_b === HIGH)
                  else $error("Extogsig is not high for a Bscan instruction when not in RUTI state: EXTEST TOGGLE");

                  chk_if_bscan_ex8a_extest_tgl_then_D6actsig_b_one_when_not_active: assert (stap_fbscan_d6actestsig_b === HIGH)
                  else $error("D6actsig_b is not high for a Bscan instruction when not in RUTI state: EXTEST TOGGLE");

               end else begin
                  chk_if_bscan_ex5b_extest_tgl_then_extogsig_b_toggles: assert (stap_fbscan_extogsig_b !== $past(stap_fbscan_extogsig_b,1))
                  else $error("Extogsig is not high for a Bscan instruction when not in RUTI state: EXTEST TOGGLE");

                  chk_if_bscan_ex8b_extest_tgl_then_D6actsig_b_toggles: assert (stap_fbscan_d6actestsig_b !== $past(stap_fbscan_d6actestsig_b,1))
                  else $error("D6actsig_b is not high for a Bscan instruction when not in RUTI state: EXTEST TOGGLE");
               end

               chk_if_bscan_ex6_extest_tgl_then_d6select_equals_zero: assert (stap_fbscan_d6select === LOW)
               else $error("D6Select is not LOW  for a Bscan instruction: EXTEST TOGGLE");

               chk_if_bscan_ex7_extest_tgl_preload_then_d6init_equals_zero: assert (stap_fbscan_d6init === LOW)
               else $error("D6int is not LOW for a Bscan instruction: EXTEST TOGGLE");

            end
         end
      end

      // ====================================================================
      // Check for BSCAN sigals during EXTEST TRAIN instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_extest_train,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN))
            begin

               chk_if_bscan_ex1_extest_train_then_mode_equals_one: assert (stap_fbscan_mode === HIGH)
               else $error("Mode is not High for a Bscan instruction: EXTEST TRAIN");

               chk_if_bscan_ex2_extest_train_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HIGHZ is not Low for a Bscan instruction: EXTEST TRAIN");

               chk_if_bscan_ex3_extest_train_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not high for a Bscan instruction: EXTEST TRAIN");

               chk_if_bscan_ex4_extest_train_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not low for a Bscan instruction: EXTEST TRAIN");

               chk_if_bscan_ex5_extest_train_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not high for a Bscan instruction: EXTEST TRAIN");

               chk_if_bscan_ex6_extest_train_then_d6select_equals_one: assert (stap_fbscan_d6select === HIGH)
               else $error("D6Select is not HIGH  for a Bscan instruction: EXTEST TRAIN");

               chk_if_bscan_ex7_extest_train_preload_then_d6init_equals_pulse: assert property (e1dr_or_e2dr |=> stap_fbscan_d6init ##1 !stap_fbscan_d6init)
               else $error("D6int is not a pulse for a Bscan instruction: EXTEST TRAIN");

               if($past(stap_fsm_rti,1) === 1'b0) begin
                  chk_if_bscan_ex8_extest_train_preload_then_d6actestsig_b_equals_one_at_reset: assert (stap_fbscan_d6actestsig_b === HIGH)
                  else $error("D6actsig_b is not HIGH for a Bscan instruction: EXTEST TRAIN");
               end else begin
                  chk_if_bscan_ex8_extest_train_preload_then_d6actestsig_b_toggles: assert (stap_fbscan_d6actestsig_b !== $past(stap_fbscan_d6actestsig_b,1))
                  else $error("D6actsig_b is not HIGH for a Bscan instruction: EXTEST TRAIN");
               end

            end
         end
      end

      // ====================================================================
      // Check for BSCAN sigals during EXTEST PULSE instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_extest_pulse,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE))
            begin
               chk_if_bscan_ex1_extest_pulse_then_mode_equals_one: assert (stap_fbscan_mode === HIGH)
               else $error("Mode is not HIGH for a Bscan instruction: EXTEST PULSE");

               chk_if_bscan_ex2_extest_pulse_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HIGHZ is not Low for a Bscan instruction: EXTEST PULSE");

               chk_if_bscan_ex3_extest_pulse_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not high for a Bscan instruction: EXTEST PULSE");

               chk_if_bscan_ex4_extest_pulse_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not low for a Bscan instruction: EXTEST PULSE");

               chk_if_bscan_ex5_extest_pulse_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not high for a Bscan instruction: EXTEST PULSE");

               chk_if_bscan_ex6_extest_pulse_then_d6select_equals_one: assert (stap_fbscan_d6select === HIGH)
               else $error("D6Select is not HIGH  for a Bscan instruction: EXTEST PULSE");

               chk_if_bscan_ex7_extest_pulse_preload_then_d6init_equals_pulse: assert property (e1dr_or_e2dr |=> stap_fbscan_d6init ##1 !stap_fbscan_d6init)
               else $error("D6int is not LOW for a Bscan instruction: EXTEST PULSE");

               chk_if_bscan_ex8_extest_pulse_preload_then_d6actestsig_b_equals_one: assert property ($past(stap_fsm_rti) |-> !stap_fbscan_d6actestsig_b)
               else $error("D6actsig_b is not HIGH for a Bscan instruction: EXTEST PULSE");

            end
         end
      end
      // ====================================================================
      // Check for BSCAN sigals during CLAMP instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_clamp,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_CLAMP))
            begin

               chk_if_bscan_ex1_clamp_then_mode_equals_one: assert (stap_fbscan_mode === HIGH)
               else $error("Mode is not High for a Bscan instruction: CLAMP");

               chk_if_bscan_ex2_clamp_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HIGHZ is not Low for a Bscan instruction: CLAMP");

               chk_if_bscan_ex3_clamp_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not high for a Bscan instruction: CLAMP");

               chk_if_bscan_ex4_clamp_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not Low for a Bscan instruction: CLAMP");

               chk_if_bscan_ex5_clamp_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not high for a Bscan instruction: CLAMP");

               chk_if_bscan_ex6_clamp_then_d6sel_b_equals_zero: assert (stap_fbscan_d6select === LOW)
               else $error("D6Select is not LOW  for a Bscan instruction: CLAMP");

               chk_if_bscan_ex7_clamp_preload_then_d6init_equals_zero: assert (stap_fbscan_d6init === LOW)
               else $error("D6int is not LOW for a Bscan instruction: CLAMP");

               chk_if_bscan_ex8_clamp_preload_then_d6actestsig_b_equals_one: assert (stap_fbscan_d6actestsig_b === HIGH)
               else $error("D6actsig_b is not HIGH for a Bscan instruction: CLAMP");

            end
         end
      end

      // ====================================================================
      // Check for BSCAN sigals during HIGHZ instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_highz,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_HIGHZ))
            begin

               chk_if_bscan_ex1_highz_then_mode_equals_one: assert (stap_fbscan_mode === HIGH)
               else $error("Mode is not High for a Bscan instruction: HIGHZ");

               chk_if_bscan_ex2_highz_then_highz_equals_one: assert (stap_fbscan_highz === HIGH)
               else $error("HIGHZ is not HIGH for a Bscan instruction: HIGHZ");

               chk_if_bscan_ex3_highz_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not high for a Bscan instruction: HIGHZ");

               chk_if_bscan_ex4_highz_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not Low for a Bscan instruction: HIGHZ");

               chk_if_bscan_ex5_highz_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not high for a Bscan instruction: HIGHZ");

               chk_if_bscan_ex6_highz_then_d6sel_b_equals_zero: assert (stap_fbscan_d6select === LOW)
               else $error("D6Select is not LOW  for a Bscan instruction: HIGHZ");

               chk_if_bscan_ex7_highz_preload_then_d6init_equals_zero: assert (stap_fbscan_d6init === LOW)
               else $error("D6int is not LOW for a Bscan instruction: HIGHZ");

               chk_if_bscan_ex8_highz_preload_then_d6actestsig_b_equals_one: assert (stap_fbscan_d6actestsig_b === HIGH)
               else $error("D6actsig_b is not HIGH for a Bscan instruction: HIGHZ");

            end
         end
      end
      // ====================================================================
      // Check for BSCAN sigals during PRELOAD instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_preload,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_PRELOAD))
            begin
               chk_if_bscan_ex1_preload_then_mode_equals_zero: assert (stap_fbscan_mode === LOW)
               else $error("Mode is not Low for a Bscan instruction: PRELOAD");

               chk_if_bscan_ex2_preload_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HIGHZ is not Low for a Bscan instruction: PRELOAD");

               chk_if_bscan_ex3_preload_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not HIGH for a Bscan instruction: PRELOAD");

               chk_if_bscan_ex4_preload_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not Low for a Bscan instruction: PRELOAD");

               chk_if_bscan_ex5_preload_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not high for a Bscan instruction: PRELOAD");

               chk_if_bscan_ex6_preload_then_d6sel_b_equals_zero: assert (stap_fbscan_d6select === LOW)
               else $error("D6Select is not LOW  for a Bscan instruction: PRELOAD");

               chk_if_bscan_ex7_preload_preload_then_d6init_equals_zero: assert (stap_fbscan_d6init === LOW)
               else $error("D6int is not LOW for a Bscan instruction: PRELOAD");

               chk_if_bscan_ex8_preload_preload_then_d6actestsig_b_equals_one: assert (stap_fbscan_d6actestsig_b === HIGH)
               else $error("D6actsig_b is not HIGH for a Bscan instruction: PRELOAD");

            end
         end
      end
      // ====================================================================
      // Check for BSCAN sigals during INTEST instruction
      // ====================================================================
      always @(negedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && powergood_rst_trst_b === HIGH)
         begin
            if (($past(inst_intest,1) === HIGH) && (stap_irreg_ireg === BSCAN_STAP_ADDRESS_OF_INTEST))
            begin

               chk_if_bscan_ex1_intest_then_mode_equals_zero: assert (stap_fbscan_mode === LOW)
               else $error("Mode is not LOW for a Bscan instruction: INTEST");

               chk_if_bscan_ex2_intest_then_highz_equals_zero: assert (stap_fbscan_highz === LOW)
               else $error("HIGHZ is not Low for a Bscan instruction: INTEST");

               chk_if_bscan_ex3_intest_then_chainen_equals_one: assert (stap_fbscan_chainen === HIGH)
               else $error("Chain enable is not High for a Bscan instruction: INTEST");

               chk_if_bscan_ex4_intest_then_extogen_equals_zero: assert (stap_fbscan_extogen === LOW)
               else $error("Extog enable is not Low for a Bscan instruction: INTEST");

               chk_if_bscan_ex5_intest_then_extogsig_b_equals_one: assert (stap_fbscan_extogsig_b === HIGH)
               else $error("Extogsig is not high for a Bscan instruction: INTEST");

               chk_if_bscan_ex6_intest_then_d6sel_b_equals_zero: assert (stap_fbscan_d6select === LOW)
               else $error("D6Select is not LOW  for a Bscan instruction: INTEST");

               chk_if_bscan_ex7_intest_preload_then_d6init_equals_zero: assert (stap_fbscan_d6init === LOW)
               else $error("D6int is not LOW for a Bscan instruction: INTEST");

               chk_if_bscan_ex8_intest_preload_then_d6actestsig_b_equals_one: assert (stap_fbscan_d6actestsig_b === HIGH)
               else $error("D6actsig_b is not HIGH for a Bscan instruction: INTEST");

            end
         end
      end

      // =============================================================================================
      // Check if extest_train or pulse is choosed. Then Check if reset you are not in TLRS.
      // Then in the same clk cycle as when TLRS is low, check if d6select is equal to train_or_pluse.
      // =============================================================================================
      always @(negedge ftap_tck)
      begin
         chk_if_bscan_trainorpulse_then_d6select_equals_1:
         //assume property ((train_or_pulse) ##1 (stap_fsm_tlrs === LOW) |-> stap_fbscan_d6select);
         assert property ((train_or_pulse) |-> stap_fbscan_d6select);
         //else $error("d6select is not following train_or_pulse after one clock cycle");
      end
      // ============================================================================
      // This checks if rising edge of stap_fbscan_capturedr happens on rising edge of TCK
      // ============================================================================
      // InValid -- CaptureDR changing on posedge of TCK
      property stap_bscan_raising_capturedr_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               stap_fbscan_capturedr |-> ((fbscan_capturedr_raising_edge_pulse === HIGH) && (ftap_clk_falling_edge_pulse)) === LOW;
      endproperty: stap_bscan_raising_capturedr_during_posedge_clk
      chk_stap_bscan_raising_capturedr_during_posedge_clk:
      assert property (stap_bscan_raising_capturedr_during_posedge_clk)
      else $error("raising stap_fbscan_capturedr should not change on posedge of tck");

      // ============================================================================
      // This checks if falling edge of stap_fbscan_capturedr happens on rising edge of TCK
      // ============================================================================
      // InValid -- CaptureDR changing on posedge of TCK
      property stap_bscan_falling_capturedr_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               stap_fbscan_capturedr |-> ((fbscan_capturedr_falling_edge_pulse === HIGH) && (ftap_clk_falling_edge_pulse)) === LOW;
      endproperty: stap_bscan_falling_capturedr_during_posedge_clk
      chk_stap_bscan_falling_capturedr_during_posedge_clk: assert property (stap_bscan_falling_capturedr_during_posedge_clk)
      else $error("falling stap_fbscan_capturedr should not change on posedge of tck");
      // ====================================================================

      // ============================================================================
      // This checks if rising edge of stap_fbscan_shiftdr happens on rising edge of TCK
      // ============================================================================
      // InValid -- shiftDR changing on posedge of TCK
      property stap_bscan_raising_shiftdr_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               stap_fbscan_shiftdr |-> ((fbscan_shiftdr_raising_edge_pulse === HIGH) && (ftap_clk_falling_edge_pulse)) === LOW;
      endproperty: stap_bscan_raising_shiftdr_during_posedge_clk
      chk_stap_bscan_raising_shiftdr_during_posedge_clk: assert property (stap_bscan_raising_shiftdr_during_posedge_clk)
      else $error("raising stap_fbscan_shiftdr should not change on posedge of tck");
      // ============================================================================
      // This checks if falling edge of stap_fbscan_shiftdr happens on rising edge of TCK
      // ============================================================================
      // InValid -- shiftDR changing on posedge of TCK
      property stap_bscan_falling_shiftdr_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
               stap_fbscan_shiftdr |-> ((fbscan_shiftdr_falling_edge_pulse === HIGH) && (ftap_clk_falling_edge_pulse)) === LOW;
      endproperty: stap_bscan_falling_shiftdr_during_posedge_clk
      chk_stap_bscan_falling_shiftdr_during_posedge_clk: assert property (stap_bscan_falling_shiftdr_during_posedge_clk)
      else $error("falling stap_fbscan_shiftdr should not change on posedge of tck");
      // ====================================================================

      // ============================================================================
      // This checks if rising edge of stap_fbscan_updatedr happens on rising edge of TCK
      // ============================================================================
      // InValid -- updateDR changing on posedge of TCK
      property stap_bscan_raising_updatedr_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
            stap_fbscan_updatedr |->   ((fbscan_updatedr_raising_edge_pulse === HIGH) && (ftap_clk_falling_edge_pulse)) === LOW;
      endproperty: stap_bscan_raising_updatedr_during_posedge_clk
      chk_stap_bscan_raising_updatedr_during_posedge_clk: assert property (stap_bscan_raising_updatedr_during_posedge_clk)
      else $error("raising stap_fbscan_updatedr should not change on posedge of tck");
      // ============================================================================
      // This checks if falling edge of stap_fbscan_updatedr happens on rising edge of TCK
      // ============================================================================
      // InValid -- updateDR changing on posedge of TCK
      property stap_bscan_falling_updatedr_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
            stap_fbscan_updatedr |->  ((fbscan_updatedr_falling_edge_pulse === HIGH) && (ftap_clk_falling_edge_pulse)) === LOW;
      endproperty: stap_bscan_falling_updatedr_during_posedge_clk
      chk_stap_bscan_falling_updatedr_during_posedge_clk: assert property (stap_bscan_falling_updatedr_during_posedge_clk)
      else $error("falling stap_fbscan_updatedr should not change on posedge of tck");
      // ====================================================================

      // ============================================================================
      // This checks if rising edge of fbscan_updatedr_clk happens on falling edge of TCK
      // ============================================================================
      // InValid -- updateDR changing on posedge of TCK
      property stap_bscan_raising_updatedr_clk_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
            stap_fbscan_updatedr_clk |->   ((fbscan_updatedr_clk_falling_edge_pulse === HIGH) && (ftap_clk_raising_edge_pulse)) === LOW;
      endproperty: stap_bscan_raising_updatedr_clk_during_posedge_clk
      chk_stap_bscan_raising_updatedr_clk_during_negedge_clk: assert property (stap_bscan_raising_updatedr_clk_during_posedge_clk)
      else $error("raising fbscan_updatedr_clk should not change on posedge of tck");
      // ============================================================================
      // This checks if falling edge of fbscan_updatedr happens on falling edge of TCK
      // ============================================================================
      // InValid -- updateDR changing on posedge of TCK
      property stap_bscan_falling_updatedr_clk_during_posedge_clk;
         @(ftap_tck_delayed_by_1ps)
            disable iff ((powergood_rst_trst_b !== HIGH) || (powergood_rst_trst_b === 1'hX))
            stap_fbscan_updatedr_clk |->  ((fbscan_updatedr_clk_raising_edge_pulse === HIGH) && (ftap_clk_raising_edge_pulse)) === LOW;
      endproperty: stap_bscan_falling_updatedr_clk_during_posedge_clk
      chk_stap_bscan_falling_updatedr_clk_during_posedge_clk: assert property (stap_bscan_falling_updatedr_clk_during_posedge_clk)
      else $error("falling fbscan_updatedr_clk should not change on negedge of tck");
      // ====================================================================
//************************************************************************************************************
    `endif
`endif
`endif

endmodule
