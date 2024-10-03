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
//    FILENAME    : stap_swcomp_rtdr.sv
//    DESIGNER    : B.S.Adithya 
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP SWCOMP Implementation
//    DESCRIPTION :
//       This module is ontains two modules. SWCOMP and SWCOMP Register Block.
//
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module stap_swcomp_rtdr
   #(
   parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS  = 10
   )
   (
   input  logic                                             stap_fsm_tlrs,
   input  logic                                             ftap_tck,
   input  logic                                             ftap_tdi,
   input  logic                                             fdfx_powergood,
   input  logic                                             powergood_rst_trst_b,
   input  logic                                             stap_fsm_capture_dr,
   input  logic                                             stap_fsm_shift_dr,
   input  logic                                             stap_fsm_update_dr,
   input  logic                                             stap_fsm_e2dr,
   input  logic                                             stap_swcomp_pre_tdo,
   input  logic                                             tap_swcomp_active,

   output logic                                             swcomp_stap_post_tdo,  
   output logic                                             swcompctrl_tdo,
   output logic                                             swcompstat_tdo

   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal SWCOMP Signals
   // *********************************************************************

   logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]             cmplim_hi;
   logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]             cmplim_lo;
   logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]             cmplim_mask;
   logic                                                   cmp_mirror_sel;
   logic                                                   cmp_tdo_sel;
   logic                                                   cmp_tdo_forcelo;
   logic                                                   cmpen_main;
   logic                                                   cmpsel_signed;
   logic                                                   cmpsel_sgnmag;
   logic                                                   cmpen_le_limhi;
   logic                                                   cmpen_ge_limlo;
   logic                                                   cmpen_blk_multi_fail;
   logic [7:0]                                             cmp_firstfail_cnt;
   logic                                                   cmp_sticky_fail_hi;
   logic                                                   cmp_sticky_fail_lo;
   
///**** SWCOMP Module Implementation *****////

    stap_tapswcomp #(.STAP_SWCOMP_NUM_OF_COMPARE_BITS(10)) 
    i_stap_tapswcomp
     (
      // Inputs
      .jtclk                            (ftap_tck),
      .jtrst_b                          (powergood_rst_trst_b), //badithya fix. Giving AND of fdfx_powergood and ftap_trst_b to avoid X propogation. 
      .tdi                              (stap_swcomp_pre_tdo),
      .test_logic_reset                 (stap_fsm_tlrs),
      .capture_dr                       (stap_fsm_capture_dr),
      .shift_dr                         (stap_fsm_shift_dr),
      .exit2_dr                         (stap_fsm_e2dr),
      .tap_swcomp_active                (tap_swcomp_active),
      .cmplim_hi                        (cmplim_hi),
      .cmplim_lo                        (cmplim_lo),
      .cmplim_mask                      (cmplim_mask),
      .cmp_mirror_sel                   (cmp_mirror_sel),
      .cmp_tdo_sel                      (cmp_tdo_sel),
      .cmp_tdo_forcelo                  (cmp_tdo_forcelo),
      .cmpen_main                       (cmpen_main),
      .cmpsel_signed                    (cmpsel_signed),
      .cmpsel_sgnmag                    (cmpsel_sgnmag),
      .cmpen_le_limhi                   (cmpen_le_limhi),
      .cmpen_ge_limlo                   (cmpen_ge_limlo),
      .cmpen_blk_multi_fail             (cmpen_blk_multi_fail),
      // Outputs
      .cmp_firstfail_cnt                (cmp_firstfail_cnt),
      .cmp_sticky_fail_hi               (cmp_sticky_fail_hi),
      .cmp_sticky_fail_lo               (cmp_sticky_fail_lo),
      .tdo                              (swcomp_stap_post_tdo)
   );
   


   stap_tapswcompreg #(.STAP_SWCOMP_NUM_OF_COMPARE_BITS(10)) 
   i_stap_tapswcompreg 
     (
      // Inputs
      .jtclk                            (ftap_tck),
      .jpwrgood_rst_b                   (fdfx_powergood),
      .tdi                              (ftap_tdi),
      .capture                          (stap_fsm_capture_dr),
      .shift                            (stap_fsm_shift_dr),
      .update                           (stap_fsm_update_dr),
      .enable                           (tap_swcomp_active),

      .cmp_firstfail_cnt                (cmp_firstfail_cnt),
      .cmp_sticky_fail_hi               (cmp_sticky_fail_hi),
      .cmp_sticky_fail_lo               (cmp_sticky_fail_lo),

      // Outputs
      .cmplim_hi                        (cmplim_hi),
      .cmplim_lo                        (cmplim_lo),
      .cmplim_mask                      (cmplim_mask),
      .cmp_mirror_sel                   (cmp_mirror_sel),
      .cmp_tdo_sel                      (cmp_tdo_sel),
      .cmp_tdo_forcelo                  (cmp_tdo_forcelo),
      .cmpen_main                       (cmpen_main),
      .cmpsel_signed                    (cmpsel_signed),
      .cmpsel_sgnmag                    (cmpsel_sgnmag),
      .cmpen_le_limhi                   (cmpen_le_limhi),
      .cmpen_ge_limlo                   (cmpen_ge_limlo),
      .cmpen_blk_multi_fail             (cmpen_blk_multi_fail),
      .tdoctrl                          (swcompctrl_tdo),
      .tdostat                          (swcompstat_tdo)
      );


 
endmodule
