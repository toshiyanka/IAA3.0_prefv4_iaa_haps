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
//  Module <TAPNW> :  < put your functional description here in plain text >
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tapnw.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : TAPNW Top Level
//    DESCRIPTION :
//       This is top module and integrates all the required modules.
//    PARAMETERS  :
//       Please refer to the tapnw_params_include.inc file and the
//       individual modules for the details.
//----------------------------------------------------------------------
// *********************************************************************
// Defines
// *********************************************************************
`include "tapnw_defines_include.inc"

module tapnw 
     #(
         // *********************************************************************
         // Parameters
         // *********************************************************************
         `include "tapnw_params_include.inc"

         // *********************************************************************
         // Local Parameters
         // *********************************************************************
         parameter  TAPNW_NUMBER_OF_WTAPS      = 0,
         parameter  TAPNW_NO_OF_STAPS          = (TAPNW_NUMBER_OF_STAPS == 0) ? 1 : TAPNW_NUMBER_OF_STAPS,
         parameter  TAPNW_NO_OF_WTAPS          = (TAPNW_NUMBER_OF_WTAPS == 0) ? 1 : TAPNW_NUMBER_OF_WTAPS,
         parameter  TAPNW_POSITION_OF_TAPS     = {TAPNW_NO_OF_STAPS{1'b0}},
         parameter  TAPNW_IOSOLATETAP_GATETCK  = 1,
         parameter  TAPNW_NO_OF_STAPS_IN_SUBNW = (TAPNW_NUMBER_OF_STAPS_IN_SUBNW == 0) ? 1 : TAPNW_NUMBER_OF_STAPS_IN_SUBNW
      )
      (

         // *********************************************************************
         // PRIMARY INTERFACE
         // *********************************************************************
         //----------------------------------
         // Primary Port 
         //----------------------------------
         input   logic  ptapnw_ftap_tck,               // Primary Clock from CLTAPC or sTAP 
         input   logic  ptapnw_ftap_tms,               // Primary Test Mode Select from CLTAPC or sTAP 
         input   logic  ptapnw_ftap_trst_b,            // Primary Jtag Reset from CLTAPC or sTAP    
         input   logic  ptapnw_ftap_tdi,               // Primary Datain from CLTAPC or sTAP 
         output  logic  ntapnw_atap_tdo,               // Primary Dataout to CLTAPC or sTAP 
         output  logic  ntapnw_atap_tdo_en,            // Primary Dataout enable to CLTAPC or sTAP    
         input   logic  powergoodrst_b,    // SoC level powergoodrst_b            

         //----------------------------------
         // Primary Port -- passthrough signals for ptapnw_ftap_tck, ptapnw_ftap_tms and ptapnw_ftap_trst_b
         //----------------------------------
         output  logic  ntapnw_ftap_tck,
         output  logic  ntapnw_ftap_tms,
         output  logic  ntapnw_ftap_trst_b,

         //----------------------------------
         // Control signals to Network from Father TAP
         //----------------------------------
         input   logic  [(TAPNW_NUMBER_OF_STAPS + TAPNW_NUMBER_OF_WTAPS - 1):0] ftapnw_ftap_secsel,    // Seconadary port select
         input   logic  [(TAPNW_NUMBER_OF_STAPS + TAPNW_NUMBER_OF_WTAPS - 1):0] ftapnw_ftap_enabletdo, // Enable output for slave taps
         input   logic  [(TAPNW_NUMBER_OF_STAPS + TAPNW_NUMBER_OF_WTAPS - 1):0] ftapnw_ftap_enabletap, // Enable for slave taps

         //----------------------------------
         // Child sTAP Ports
         //----------------------------------
         output  logic  [(TAPNW_NO_OF_STAPS - 1):0] ftapnw_ftap_tck,     // Clock from tapnw to  child sTAP
         output  logic  [(TAPNW_NO_OF_STAPS - 1):0] ftapnw_ftap_tms,     // TMS from tapnw to sTAP
         output  logic  [(TAPNW_NO_OF_STAPS - 1):0] ftapnw_ftap_trst_b,  // Reset from tapnw to  child sTAP. Pass thru of ptapnw_ftap_trst_b   
         output  logic  [(TAPNW_NO_OF_STAPS - 1):0] ftapnw_ftap_tdi,     // Datain from tapnw to child sTAP
         input   logic  [(TAPNW_NO_OF_STAPS - 1):0] atapnw_atap_tdo,     // Dataout to tapnw from child sTAP
         input   logic  [(TAPNW_NO_OF_STAPS - 1):0] atapnw_atap_tdo_en,  // Dataout enable to tapnw from child sTAP 
     
         // *********************************************************************
         // SECONDARY INTERFACE
         // *********************************************************************
         //----------------------------------
         // Secondary Ports 
         //----------------------------------
         input   logic  ptapnw_ftap_tck2,       // Secondary Clock from CLTAPC or sTAP
         input   logic  ptapnw_ftap_tms2,       // Secondary Test Mode Select from CLTAPC or sTAP
         input   logic  ptapnw_ftap_trst2_b,    // Secondary Jtag Reset from CLTAPC or sTAP   
         input   logic  ptapnw_ftap_tdi2,       // Secondary Datain from CLTAPC or sTAP 
         output  logic  ntapnw_atap_tdo2,       // Secondary Dataout to CLTAPC or sTAP 
         output  logic  ntapnw_atap_tdo2_en,    // Bitwise OR (atapnw_atap_tdo_en &  ftapnw_ftap_secsel)    

         //----------------------------------
         // Secondary Port -- passthrough signals for ptapnw_ftap_tck2, ptapnw_ftap_tms2 and ptapnw_ftap_trst2_b
         //----------------------------------
         output  logic  ntapnw_ftap_tck2,
         output  logic  ntapnw_ftap_tms2,
         output  logic  ntapnw_ftap_trst2_b,

         // *********************************************************************
         // HYBRID NETWORK SECONDARY INTERFACE
         // *********************************************************************
         //----------------------------------
         // Secondary Ports 
         //----------------------------------
         input logic [(TAPNW_NO_OF_STAPS_IN_SUBNW - 1):0] ntapnw_ftap_secsel,       //NS"	Seconadary port select. Width dependent on no of sTAPs in next network.
         input logic ntapnw_sslv_tdo2,         //Data coming from the sTAP's child who wants to be on CLTAP's secondary.
         input logic ntapnw_sslv_tdo2_en,      //Dataen coming from the sTAP's child who wants to be on CLTAP's secondary.


         // *********************************************************************
         // SubTAP and VERCODE INTERFACE
         // *********************************************************************
         //----------------------------------
         // SubTap Control Ports
         //----------------------------------
         input   logic  [(TAPNW_NO_OF_STAPS - 1):0] atapnw_atap_subtapactvi,  // Sub Tap active signals from  child sTAP to tapnw
         output  logic                              atapnw_atap_subtapactvo,  // Sub Tap active signal from tapnw to father sTAP/CLTAPC

         //----------------------------------
         // Vercode passthru Ports
         //----------------------------------
         input   logic  [3:0] ftapnw_ftap_vercodei,     // Vercode input from a strap in CLTAPC or sTAP
         output  logic  [3:0] ftapnw_ftap_vercodeo      // Verocde is passed to all the tap's connected to the network

      );
   //----------------------------------------------------------------------
   // Wires & Regs
   //----------------------------------------------------------------------
   logic [(TAPNW_NUMBER_OF_STAPS + TAPNW_NUMBER_OF_WTAPS - 1):0] tapc_enabletdo_reg;
   logic [(TAPNW_NUMBER_OF_STAPS + TAPNW_NUMBER_OF_WTAPS - 1):0] tapc_secsel_reg;
   logic [(TAPNW_NUMBER_OF_STAPS + TAPNW_NUMBER_OF_WTAPS - 1):0] tapc_enabletap_reg;

//FIXME Next 1.0 release will have actual connection
   logic [(TAPNW_NO_OF_STAPS_IN_SUBNW - 1):0] ntapnw_ftap_secsel_NC; 
   logic ntapnw_sslv_tdo2_NC;     
   logic ntapnw_sslv_tdo2_en_NC; 

   assign ntapnw_ftap_secsel_NC   = ntapnw_ftap_secsel;
   assign ntapnw_sslv_tdo2_NC     = ntapnw_sslv_tdo2;
   assign ntapnw_sslv_tdo2_en_NC  = ntapnw_sslv_tdo2_en;
   //----------------------------------------------------------------------
   // Instantiation of Control Path of the TAP Network
   //----------------------------------------------------------------------
   tapnw_mtcp #(
                .MTCP_TAPNW_NUMBER_OF_STAPS            (TAPNW_NUMBER_OF_STAPS),
                .MTCP_TAPNW_NUMBER_OF_WTAPS            (TAPNW_NUMBER_OF_WTAPS),
                .MTCP_TAPNW_IOSOLATETAP_GATETCK        (TAPNW_IOSOLATETAP_GATETCK),
                .MTCP_TAPNW_PARK_TCK_AT                (TAPNW_PARK_TCK_AT),
                .MTCP_TAPNW_HIER_HYBRID                (TAPNW_HIER_HYBRID),
                .MTCP_TAPNW_NO_OF_STAPS_IN_SUBNW       (TAPNW_NO_OF_STAPS_IN_SUBNW)
               )
   i_tapnw_mtcp(
                //CLTAPC INTERFACE
                .itck                   (ptapnw_ftap_tck),
                .itms                   (ptapnw_ftap_tms),
                .itrst_b                (ptapnw_ftap_trst_b),
                .isec_sel               (ftapnw_ftap_secsel),
                .ienabletap             (ftapnw_ftap_enabletap),
                .ienbtdo                (ftapnw_ftap_enabletdo),
                .powergoodrst_b         (powergoodrst_b),

                //SECONDARY PORT
                .itck2                  (ptapnw_ftap_tck2),
                .itms2                  (ptapnw_ftap_tms2),
                .itrst_b2               (ptapnw_ftap_trst2_b),

                //sTAP INTERFACE
                .ostap_tck              (ftapnw_ftap_tck),
                .ostap_tms              (ftapnw_ftap_tms),
                .ostap_trst_b           (ftapnw_ftap_trst_b),

                //MTDP INTERFACE
                .osec_sel_reg           (tapc_secsel_reg),
                .oenabletdo             (tapc_enabletdo_reg),
                .oenabletap             (tapc_enabletap_reg),

                //VERCODE
                .ftapnw_ftap_vercodei      (ftapnw_ftap_vercodei),
                .ftapnw_ftap_vercodeo      (ftapnw_ftap_vercodeo),

                // Passthrough Ports
                .otck                   (ntapnw_ftap_tck),
                .otms                   (ntapnw_ftap_tms),
                .otrst_b                (ntapnw_ftap_trst_b),
                .otck2                  (ntapnw_ftap_tck2),
                .otms2                  (ntapnw_ftap_tms2),
                .otrst_b2               (ntapnw_ftap_trst2_b),

                // Subtap active Ports
                .atapnw_atap_subtapactvi  (atapnw_atap_subtapactvi),
                .atapnw_atap_subtapactvo  (atapnw_atap_subtapactvo)

               );

   //----------------------------------------------------------------------
   // Instantiation of Data Path of the TAP Network
   //----------------------------------------------------------------------
   tapnw_mtdp #(
                .MTDP_TAPNW_NUMBER_OF_STAPS            (TAPNW_NUMBER_OF_STAPS),
                .MTDP_TAPNW_NUMBER_OF_WTAPS            (TAPNW_NUMBER_OF_WTAPS),
                .MTDP_TAPNW_IOSOLATETAP_GATETCK        (TAPNW_IOSOLATETAP_GATETCK),
                .MTDP_TAPNW_PARK_TCK_AT                (TAPNW_PARK_TCK_AT),
                .MTDP_TAPNW_HIER_HYBRID                (TAPNW_HIER_HYBRID),
                .MTDP_TAPNW_NO_OF_STAPS_IN_SUBNW       (TAPNW_NO_OF_STAPS_IN_SUBNW)
               )
   i_tapnw_mtdp (
                 //CLTAPC INTERFACE
                 .itdi         (ptapnw_ftap_tdi),
                 .otdo         (ntapnw_atap_tdo),
                 .otdo_en      (ntapnw_atap_tdo_en),

                 //SECONDARY PORT FOR sTAP
                 .itdi2        (ptapnw_ftap_tdi2),
                 .otdo2        (ntapnw_atap_tdo2),
                 .otdo2_en     (ntapnw_atap_tdo2_en),

                 //sTAP INTERFACE
                 .ostap_tdi    (ftapnw_ftap_tdi),
                 .istap_tdo    (atapnw_atap_tdo),
                 .istap_tdo_en (atapnw_atap_tdo_en),

                 //MTCP INTERFACE
                 .ienabletap   (tapc_enabletap_reg),
                 .isec_sel_reg (tapc_secsel_reg),
                 .ienabletdo   (tapc_enabletdo_reg),

                 .ntapnw_ftap_secsel   (ntapnw_ftap_secsel),
                 .ntapnw_sslv_tdo2     (ntapnw_sslv_tdo2),
                 .ntapnw_sslv_tdo2_en  (ntapnw_sslv_tdo2_en)

                );

//kbbhagwa   `include "tapnw_assertions_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
 `include "tapnw_assertions_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif



endmodule
