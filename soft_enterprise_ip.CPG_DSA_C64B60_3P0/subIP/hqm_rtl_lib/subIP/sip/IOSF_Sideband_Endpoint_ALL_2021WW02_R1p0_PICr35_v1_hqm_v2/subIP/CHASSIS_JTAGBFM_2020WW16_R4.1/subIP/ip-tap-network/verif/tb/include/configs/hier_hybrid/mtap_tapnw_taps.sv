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
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : mtap_tapnw_taps.sv
//    DESIGNER    : Bulusu, Shivaprashant
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : TAP Network Implementation
//    DESCRIPTION : This module connects a MasterTap to a Tapnetwork
//                  logic, which in turn gets connected to four Slave
//                  TAP's and four Wrapper TAP's
//    PARAMETERS  : From inlude files shown below
//----------------------------------------------------------------------
`timescale 1ps/1ps



module mtap_tapnw_taps (
                        //PRIMARY JTAG PORT
                        tck,
                        tms,
                        trst_b,
                        tdi,
                        tdo,
                        tdo_en,

                        //Secondary JTAG PORT
                        tck2,
                        tms2,
                        trst_b2,
                        tdi2,
                        tdo2,
                        tdo2_en,

                        vercode,
                        slvidcode_mtap,
                        slvidcode_stap0,
                        slvidcode_stap1,
                        slvidcode_stap2,
                        slvidcode_stap3,

                        //TAPNW controls from MTAP need to be brought out for OVM env
                        mtap_secsel,
                        mtap_enabletdo,
                        mtap_enabletap,

                        //From SoC
                        powergoodrst_b
                       );

`include "tb_param.inc"
`include "mtap0_params_include.inc"

`include "tapnw0_params_include.inc"
`include "tapnw1_params_include.inc"
`include "tapnw2_params_include.inc"
`include "tapnw3_params_include.inc"

`include "stap0_params_include.inc"
`include "stap2_params_include.inc"
    //----------------------------------------------------------------------
    // Port Signal Declarations
    //----------------------------------------------------------------------

    //PRIMARY JTAG PORT
    input  logic tck;
    input  logic tms;
    input  logic trst_b;
    input  logic tdi;
    output logic tdo;
    output logic tdo_en;

    //Secondary JTAG PORT
    input  logic tck2;
    input  logic tms2;
    input  logic trst_b2;
    input  logic tdi2;
    output logic tdo2;
    output logic tdo2_en;

    input logic [3:0]  vercode;
    input logic [31:0] slvidcode_mtap;
    input logic [31:0] slvidcode_stap0;
    input logic [31:0] slvidcode_stap1;
    input logic [31:0] slvidcode_stap2;
    input logic [31:0] slvidcode_stap3;

    //TAPNW controls from MTAP need to be brought out for OVM env
    output logic [(MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK- 1):0] mtap_secsel;
    output logic [(MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK- 1):0] mtap_enabletdo;
    output logic [(MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK- 1):0] mtap_enabletap;

    //From SoC
    input logic powergoodrst_b;

    //----------------------------------------------------------------------
    // Wires & Regs
    //----------------------------------------------------------------------

    //--------------------------------------------------------
    //From MTAP to TAPNW0, TAPNW1, TAPNW2 #### STAP2 to TAPNW3
    //--------------------------------------------------------
    wire mtap_tapnw_tck,         mtap_tapnw_tck2,        stap2_tapnw_tck,         stap2_tapnw_tck2;     
    wire mtap_tapnw_tms,         mtap_tapnw_tms2,        stap2_tapnw_tms,         stap2_tapnw_tms2;
    wire mtap_tapnw_trst_b,      mtap_tapnw_trst2_b,     stap2_tapnw_trst_b,      stap2_tapnw_trst2_b;
    wire mtap_tapnw_tdi,         mtap_tapnw_tdi2,        stap2_tapnw_tdi,         stap2_tapnw_tdi2;
    //----------------------------------------
    //From TAPNW2 to MTAP #### TAPNW3 to STAP2 
    //----------------------------------------
    wire tapnw_mtap_tdo,         tapnw_mtap_tdo2,        tapnw_stap2_tdo,         tapnw_stap2_tdo2;
    wire tapnw_mtap_tdoen,       tapnw_mtap_tdo2en,      tapnw_stap2_tdoen,       tapnw_stap2_tdo2en;
    //-------------------------------
    //From TAPNW0 to TAPNW1 to TAPNW2 
    //-------------------------------
    wire tapnw0_tapnw1_tdo,      tapnw0_tapnw1_tdo2,     tapnw1_tapnw2_tdo,       tapnw1_tapnw2_tdo2;
    wire tapnw0_tapnw1_tdoen,    tapnw0_tapnw1_tdo2en,   tapnw1_tapnw2_tdoen,     tapnw1_tapnw2_tdo2en;

    //--------------------
    //From STAP2 to TAPNW3 
    //--------------------
    wire [(STAP2_NUMBER_OF_TAPS_IN_TAP_NETWORK- 1):0] stap2_secsel;
    wire [(STAP2_NUMBER_OF_TAPS_IN_TAP_NETWORK- 1):0] stap2_enabletdo;
    wire [(STAP2_NUMBER_OF_TAPS_IN_TAP_NETWORK- 1):0] stap2_enabletap;

    //----------------------
    //From TAPNW* <--> STAP*
    //----------------------
    wire [(TAPNW0_NUMBER_OF_STAPS-1):0] tapnw0_stap_tck;      wire [(TAPNW1_NUMBER_OF_STAPS-1):0] tapnw1_stap_tck;     wire [(TAPNW2_NUMBER_OF_STAPS-1):0] tapnw2_stap_tck;     wire [(TAPNW3_NUMBER_OF_STAPS-1):0] tapnw3_stap_tck;     
    wire [(TAPNW0_NUMBER_OF_STAPS-1):0] tapnw0_stap_tms;      wire [(TAPNW1_NUMBER_OF_STAPS-1):0] tapnw1_stap_tms;     wire [(TAPNW2_NUMBER_OF_STAPS-1):0] tapnw2_stap_tms;     wire [(TAPNW3_NUMBER_OF_STAPS-1):0] tapnw3_stap_tms;
    wire [(TAPNW0_NUMBER_OF_STAPS-1):0] tapnw0_stap_trst_b;   wire [(TAPNW1_NUMBER_OF_STAPS-1):0] tapnw1_stap_trst_b;  wire [(TAPNW2_NUMBER_OF_STAPS-1):0] tapnw2_stap_trst_b;  wire [(TAPNW3_NUMBER_OF_STAPS-1):0] tapnw3_stap_trst_b;
    wire [(TAPNW0_NUMBER_OF_STAPS-1):0] tapnw0_stap_tdi;      wire [(TAPNW1_NUMBER_OF_STAPS-1):0] tapnw1_stap_tdi;     wire [(TAPNW2_NUMBER_OF_STAPS-1):0] tapnw2_stap_tdi;     wire [(TAPNW3_NUMBER_OF_STAPS-1):0] tapnw3_stap_tdi;
    wire [(TAPNW0_NUMBER_OF_STAPS-1):0] stap_tapnw0_tdo;      wire [(TAPNW1_NUMBER_OF_STAPS-1):0] stap_tapnw1_tdo;     wire [(TAPNW2_NUMBER_OF_STAPS-1):0] stap_tapnw2_tdo;     wire [(TAPNW3_NUMBER_OF_STAPS-1):0] stap_tapnw3_tdo;
    wire [(TAPNW0_NUMBER_OF_STAPS-1):0] stap_tapnw0_tdo_en;   wire [(TAPNW1_NUMBER_OF_STAPS-1):0] stap_tapnw1_tdo_en;  wire [(TAPNW2_NUMBER_OF_STAPS-1):0] stap_tapnw2_tdo_en;  wire [(TAPNW3_NUMBER_OF_STAPS-1):0] stap_tapnw3_tdo_en;

    //-------
    //Vercode
    //-------
    wire [3:0] mtap_tapnw_vercode; 
    wire [3:0]     tapnw0_tap_vercode; 
    wire [3:0]     tapnw1_tap_vercode; 
    wire [3:0]         stap2_tapnw3_vercode;
    wire [3:0]             tapnw3_tap_vercode; 
    wire [3:0]     tapnw2_tap_vercode; 

    //-----------------------------
    //Hybrid - From sTAP2 to TAPNW1
    //-----------------------------
    wire hybrid_cltap_tdo2,        tapnw1_sec_passthru_tck2;     
    wire hybrid_cltap_tdo2_en,     tapnw1_sec_passthru_tms2;
    wire                           tapnw1_sec_passthru_trst2_b;

    //-----------------------------
    //Subtapactive logic connection
    //-----------------------------
    wire stap6_tapnw3_subtapactv;
    wire stap7_tapnw3_subtapactv;
    wire stap8_tapnw3_subtapactv;
    wire stap9_tapnw3_subtapactv;

    wire stap3_tapnw2_subtapactv;
    wire stap4_tapnw2_subtapactv;
    wire stap5_tapnw2_subtapactv;

    wire stap0_tapnw0_subtapactv;
    wire stap1_tapnw0_subtapactv;

    wire stap2_tapnw2_subtapactv;

    wire tapnw0_mtap0_subtapactv;
    wire tapnw1_mtap0_subtapactv;
    wire tapnw2_mtap0_subtapactv;
    wire tapnw3_stap2_subtapactv;
    //---------------------------------------------------------------------------------------------//
    //----------------------------------------MTAP0------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    cltapc #(`include "mtap0_params_overide.inc")
    i_mtap0 (
             //  CLTAP Primary Jtag Ports
             .atappris_tck                  (tck),
             .atappris_tms                  (tms),
             .atappris_trst_b               (trst_b),
             .atappris_tdi                  (tdi),
             .ftappris_tdo                  (tdo),
             .ftappris_tdoen                (tdo_en),

             .powergoodrst_b                (powergoodrst_b),
             .ftap_vercode                  (vercode),
             .ftap_idcode                   (32'h1234_5678),

             //  CLTAP Parallel ports of optional data registers
             .atap_vercode                  (mtap_tapnw_vercode),
             
             //  CLTAP Control signals to Slave TAPNetwork
             .cftapnw_ftap_secsel           (mtap_secsel),
             .cftapnw_ftap_enabletdo        (mtap_enabletdo),
             .cftapnw_ftap_enabletap        (mtap_enabletap),

             //  CLTAP Primary JTAG ports to Slave TAPNetwork
             .cntapnw_ftap_tck              (mtap_tapnw_tck),
             .cntapnw_ftap_tms              (mtap_tapnw_tms),
             .cntapnw_ftap_trst_b           (mtap_tapnw_trst_b),
             .cntapnw_ftap_tdi              (mtap_tapnw_tdi),
             .cntapnw_atap_tdo              (tapnw_mtap_tdo),
             .cntapnw_atap_tdo_en           ({tapnw_mtap_tdoen,tapnw1_tapnw2_tdoen,tapnw0_tapnw1_tdoen}),

             //  CLTAP Secondary JTAG ports
             .atapsecs_tck                  (tck2),
             .atapsecs_tms                  (tms2),
             .atapsecs_trst_b               (trst_b2),
             .atapsecs_tdi                  (tdi2),
             .ftapsecs_tdo                  (tdo2),
             .ftapsecs_tdoen                (tdo2_en),

             //  CLTAP Linear Network - Indicates if a Subnetwork is active or not. Tie it HIGH.
             // Hierarchical   - Tie it LOW.   
             .ctapnw_atap_subtapactvi       ({tapnw0_mtap0_subtapactv, tapnw1_mtap0_subtapactv, tapnw2_mtap0_subtapactv,1'b0,1'b0,1'b0}),
    
             //  CLTAP Secondary JTAG ports to Slave TAPNetwork
             .cntapnw_ftap_tck2             (mtap_tapnw_tck2),
             .cntapnw_ftap_tms2             (mtap_tapnw_tms2),
             .cntapnw_ftap_trst2_b          (mtap_tapnw_trst2_b),
             .cntapnw_ftap_tdi2             (mtap_tapnw_tdi2),
             .cntapnw_atap_tdo2             (tapnw_mtap_tdo2),
             .cntapnw_atap_tdo2_en          ({tapnw_mtap_tdo2en,tapnw1_tapnw2_tdoen,tapnw0_tapnw1_tdoen})
            );


    //---------------------------------------------------------------------------------------------//
    //--------------------------------------TAPNW0 DUT --------------------------------------------//
    //--------------------------------------LEVEL-1 (MTAP'S NW)------------------------------------//

    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW0_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW0_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW0_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW0_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw0 (
              // TAPNW0 MTAP INTERFACE
              .ptapnw_ftap_tck              (mtap_tapnw_tck),
              .ptapnw_ftap_tms              (mtap_tapnw_tms),
              .ptapnw_ftap_trst_b           (mtap_tapnw_trst_b),
              .ptapnw_ftap_tdi              (mtap_tapnw_tdi),
              .ntapnw_atap_tdo              (tapnw0_tapnw1_tdo),
              .ntapnw_atap_tdo_en           (tapnw0_tapnw1_tdoen),

              .ftapnw_ftap_secsel           (mtap_secsel[1:0]),
              .ftapnw_ftap_enabletdo        (mtap_enabletdo[1:0]),
              .ftapnw_ftap_enabletap        (mtap_enabletap[1:0]),

              .powergoodrst_b               (powergoodrst_b),

              // TAPNW0 SLAVE TAP INTERFACE
              .ftapnw_ftap_tck              (tapnw0_stap_tck),
              .ftapnw_ftap_tms              (tapnw0_stap_tms),
              .ftapnw_ftap_trst_b           (tapnw0_stap_trst_b),
              .ftapnw_ftap_tdi              (tapnw0_stap_tdi),
              .atapnw_atap_tdo              (stap_tapnw0_tdo),
              .atapnw_atap_tdo_en           (stap_tapnw0_tdo_en),

              // TAPNW0 MTAP SECONDARY JTAG PORT
              .ptapnw_ftap_tck2             (mtap_tapnw_tck2),
              .ptapnw_ftap_tms2             (mtap_tapnw_tms2),
              .ptapnw_ftap_trst2_b          (mtap_tapnw_trst2_b),
              .ptapnw_ftap_tdi2             (mtap_tapnw_tdi2),
              .ntapnw_atap_tdo2_en          (tapnw0_tapnw1_tdo2en),
              .ntapnw_atap_tdo2             (tapnw0_tapnw1_tdo2),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap0_tapnw0_subtapactv,stap0_tapnw1_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw0_mtap0_subtapactv),

              // TAPNW0 VERCODE
              .ftapnw_ftap_vercodei         (mtap_tapnw_vercode),
              .ftapnw_ftap_vercodeo         (tapnw0_tap_vercode)
             );

                    //-------------------------------------------------------------------------//
                    //------------------------------STAP0--------------------------------------//
                    //-------------------------------------------------------------------------//

                    stap   #(`include "stap0_params_overide.inc")
                    i_stap0 (
                            //Primary JTAG ports
                            .ftap_tck               (tapnw0_stap_tck[0]),
                            .ftap_tms               (tapnw0_stap_tms[0]),
                            .ftap_trst_b            (tapnw0_stap_trst_b[0]),
                            .ftap_tdi               (tapnw0_stap_tdi[0]),
                            .atap_tdo               (stap_tapnw0_tdo[0]),
                            .atap_tdoen             (stap_tapnw0_tdo_en[0]),

                            //Router for TAP network
                            .stapnw_atap_subtapactvi (1'b0),
                            .atap_subtapactv         (stap0_tapnw0_subtapactv),

                            .powergoodrst_b         (powergoodrst_b),
                            .ftap_vercode           (tapnw0_tap_vercode),
                            .ftap_slvidcode         (32'hABCD_0000),
                            .atap_vercode           ()
                            ); 

                    //-------------------------------------------------------------------------//
                    //------------------------------STAP1--------------------------------------//
                    //-------------------------------------------------------------------------//

                    stap   #(`include "stap0_params_overide.inc")
                    i_stap1 (
                            //Primary JTAG ports
                            .ftap_tck               (tapnw0_stap_tck[1]),
                            .ftap_tms               (tapnw0_stap_tms[1]),
                            .ftap_trst_b            (tapnw0_stap_trst_b[1]),
                            .ftap_tdi               (tapnw0_stap_tdi[1]),
                            .atap_tdo               (stap_tapnw0_tdo[1]),
                            .atap_tdoen             (stap_tapnw0_tdo_en[1]),

                            //Router for TAP network
                            .stapnw_atap_subtapactvi (1'b0),
                            .atap_subtapactv         (stap1_tapnw0_subtapactv),

                            .powergoodrst_b         (powergoodrst_b),
                            .ftap_vercode           (tapnw0_tap_vercode),
                            .ftap_slvidcode         (32'hABCD_1111),
                            .atap_vercode           ()
                            ); 
                            
    //---------------------------------------------------------------------------------------------//
    //--------------------------------------TAPNW1 DUT --------------------------------------------//
    //--------------------------------------LEVEL-1 (MTAP'S NW)------------------------------------//

    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW1_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW1_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW1_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW1_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw1 (
              // TAPNW1 MTAP INTERFACE
              .ptapnw_ftap_tck              (mtap_tapnw_tck),
              .ptapnw_ftap_tms              (mtap_tapnw_tms),
              .ptapnw_ftap_trst_b           (mtap_tapnw_trst_b),
              .ptapnw_ftap_tdi              (tapnw0_tapnw1_tdo),
              .ntapnw_atap_tdo              (tapnw1_tapnw2_tdo),
              .ntapnw_atap_tdo_en           (tapnw1_tapnw2_tdoen),

              .ftapnw_ftap_secsel           (mtap_secsel[2]),
              .ftapnw_ftap_enabletdo        (mtap_enabletdo[2]),
              .ftapnw_ftap_enabletap        (mtap_enabletap[2]),

              .powergoodrst_b               (powergoodrst_b),

              // TAPNW1 SLAVE TAP INTERFACE
              .ftapnw_ftap_tck              (tapnw1_stap_tck),
              .ftapnw_ftap_tms              (tapnw1_stap_tms),
              .ftapnw_ftap_trst_b           (tapnw1_stap_trst_b),
              .ftapnw_ftap_tdi              (tapnw1_stap_tdi),
              .atapnw_atap_tdo              (stap_tapnw1_tdo),
              .atapnw_atap_tdo_en           (stap_tapnw1_tdo_en),

              // TAPNW1 SECONDARY JTAG PORT
              .ptapnw_ftap_tck2             (mtap_tapnw_tck2),
              .ptapnw_ftap_tms2             (mtap_tapnw_tms2),
              .ptapnw_ftap_trst2_b          (mtap_tapnw_trst2_b),
              .ptapnw_ftap_tdi2             (tapnw0_tapnw1_tdo2),
              .ntapnw_atap_tdo2_en          (tapnw1_tapnw2_tdo2en),
              .ntapnw_atap_tdo2             (tapnw1_tapnw2_tdo2),

              // TAPNW1 VERCODE
              .ftapnw_ftap_vercodei         (mtap_tapnw_vercode),
              .ftapnw_ftap_vercodeo         (tapnw1_tap_vercode),

              // TAPNW1 HIER-HYBRID INTERFACE (Below three ports are inputs from sTAP2)
              .ntapnw_ftap_secsel           (stap2_secsel),
              .ntapnw_sslv_tdo2             (hybrid_cltap_tdo2),
              .ntapnw_sslv_tdo2_en          (hybrid_cltap_tdo2_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi      ({stap2_tapnw1_subtapactv}),
              .atapnw_atap_subtapactvo      (tapnw1_mtap0_subtapactv),


              // TAPNW1 SECONDARY PASS-THRU SIGNALS
              .ntapnw_ftap_tck2             (tapnw1_sec_passthru_tck2),
              .ntapnw_ftap_tms2             (tapnw1_sec_passthru_tms2),
              .ntapnw_ftap_trst2_b          (tapnw1_sec_passthru_trst2_b)
             );

             //-------------------------------------------------------------------------//
             //------------------------------STAP2--------------------------------------//
             //-------------------------------------------------------------------------//

             stap   #(`include "stap2_params_overide.inc")
             i_stap2 (
                      // STAP2 Primary JTAG ports
                      .ftap_tck               (tapnw1_stap_tck[0]),
                      .ftap_tms               (tapnw1_stap_tms[0]),
                      .ftap_trst_b            (tapnw1_stap_trst_b[0]),
                      .ftap_tdi               (tapnw1_stap_tdi[0]),
                      .atap_tdo               (stap_tapnw1_tdo[0]),
                      .atap_tdoen             (stap_tapnw1_tdo_en[0]),

                      .powergoodrst_b         (powergoodrst_b),
                      .ftap_vercode           (tapnw1_tap_vercode),
                      .ftap_slvidcode         (32'hABCD_2222),
                      .atap_vercode           (stap2_tapnw3_vercode),

                      // STAP2 Control signals to Slave TAPNetwork
                      .sftapnw_ftap_secsel    (stap2_secsel),
                      .sftapnw_ftap_enabletdo (stap2_enabletdo),
                      .sftapnw_ftap_enabletap (stap2_enabletap),

                      // STAP2 Primary JTAG ports to Slave TAPNetwork
                      .sntapnw_ftap_tck       (stap2_tapnw_tck),
                      .sntapnw_ftap_tms       (stap2_tapnw_tms),
                      .sntapnw_ftap_trst_b    (stap2_tapnw_trst_b),
                      .sntapnw_ftap_tdi       (stap2_tapnw_tdi),
                      .sntapnw_atap_tdo       (tapnw_stap2_tdo),
                      .sntapnw_atap_tdo_en    ({1'b0, 1'b0, 1'b0, tapnw_stap2_tdoen}),

                      // STAP2 Secondary JTAG (TERITIARY) Ports
                      .ftapsslv_tck           (tapnw1_sec_passthru_tck2),
                      .ftapsslv_tms           (tapnw1_sec_passthru_tms2),
                      .ftapsslv_trst_b        (tapnw1_sec_passthru_trst2_b),
                      .ftapsslv_tdi           (tapnw0_tapnw1_tdo2),
                      .atapsslv_tdo           (hybrid_cltap_tdo2),
                      .atapsslv_tdoen         (hybrid_cltap_tdo2_en),

                      // STAP2 Secondary JTAG ports to Slave TAPNetwork
                      .sntapnw_ftap_tck2      (stap2_tapnw_tck2),
                      .sntapnw_ftap_tms2      (stap2_tapnw_tms2),
                      .sntapnw_ftap_trst2_b   (stap2_tapnw_trst2_b),
                      .sntapnw_ftap_tdi2      (stap2_tapnw_tdi2),
                      .sntapnw_atap_tdo2      (tapnw_stap2_tdo2),
                      .sntapnw_atap_tdo2_en   ({1'b0, 1'b0, 1'b0, tapnw_stap2_tdo2en}),

                       //Router for TAP network
                       .stapnw_atap_subtapactvi ({tapnw3_stap2_subtapactv,1'b0,1'b0,1'b0}),
                       .atap_subtapactv         (stap2_tapnw1_subtapactv)

                     );

                     //-------------------------------------------------------------------------//
                     //----------------------------TAPNW3 DUT ----------------------------------//
                     //----------------------------LEVEL-2 (sTAP2'S NW)--------------------------//

                     tapnw #(
                             .TAPNW_NUMBER_OF_STAPS          (TAPNW3_NUMBER_OF_STAPS),
                             .TAPNW_PARK_TCK_AT              (TAPNW3_PARK_TCK_AT),
                             .TAPNW_HIER_HYBRID              (TAPNW3_HIER_HYBRID),
                             .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW3_NUMBER_OF_STAPS_IN_SUBNW)
                            )
                     i_tapnw3 (
                               // TAPNW3 sTAP2 INTERFACE
                               .ptapnw_ftap_tck              (stap2_tapnw_tck),
                               .ptapnw_ftap_tms              (stap2_tapnw_tms),
                               .ptapnw_ftap_trst_b           (stap2_tapnw_trst_b),
                               .ptapnw_ftap_tdi              (stap2_tapnw_tdi),
                               .ntapnw_atap_tdo              (tapnw_stap2_tdo),
                               .ntapnw_atap_tdo_en           (tapnw_stap2_tdoen),

                               .ftapnw_ftap_secsel           (stap2_secsel),
                               .ftapnw_ftap_enabletdo        (stap2_enabletdo),
                               .ftapnw_ftap_enabletap        (stap2_enabletap),

                               .powergoodrst_b               (powergoodrst_b),

                               // TAPNW3 SLAVE TAP INTERFACE
                               .ftapnw_ftap_tck              (tapnw3_stap_tck),
                               .ftapnw_ftap_tms              (tapnw3_stap_tms),
                               .ftapnw_ftap_trst_b           (tapnw3_stap_trst_b),
                               .ftapnw_ftap_tdi              (tapnw3_stap_tdi),
                               .atapnw_atap_tdo              (stap_tapnw3_tdo),
                               .atapnw_atap_tdo_en           (stap_tapnw3_tdo_en),

                               // TAPNW3 SECONDARY JTAG PORT
                               .ptapnw_ftap_tck2             (stap2_tapnw_tck2),
                               .ptapnw_ftap_tms2             (stap2_tapnw_tms2),
                               .ptapnw_ftap_trst2_b          (stap2_tapnw_trst2_b),
                               .ptapnw_ftap_tdi2             (stap2_tapnw_tdi2),
                               .ntapnw_atap_tdo2_en          (tapnw_stap2_tdo2en),
                               .ntapnw_atap_tdo2             (tapnw_stap2_tdo2),

                               //Sub Tap Control logic
                               .atapnw_atap_subtapactvi ({stap6_tapnw3_subtapactv,stap7_tapnw3_subtapactv,stap8_tapnw3_subtapactv,stap9_tapnw3_subtapactv }),
                               .atapnw_atap_subtapactvo (tapnw3_stap2_subtapactv),

                               // TAPNW3 VERCODE
                               .ftapnw_ftap_vercodei         (stap2_tapnw3_vercode),
                               .ftapnw_ftap_vercodeo         (tapnw3_tap_vercode)
                              );

                              //---------------------------------------------------------------//
                              //-------------------------STAP6---------------------------------//
                              //---------------------------------------------------------------//

                              stap   #(`include "stap0_params_overide.inc")
                              i_stap6 (
                                      //Primary JTAG ports
                                      .ftap_tck               (tapnw3_stap_tck[0]),
                                      .ftap_tms               (tapnw3_stap_tms[0]),
                                      .ftap_trst_b            (tapnw3_stap_trst_b[0]),
                                      .ftap_tdi               (tapnw3_stap_tdi[0]),
                                      .atap_tdo               (stap_tapnw3_tdo[0]),
                                      .atap_tdoen             (stap_tapnw3_tdo_en[0]),

                                      //Router for TAP network
                                      .stapnw_atap_subtapactvi (1'b0),
                                      .atap_subtapactv         (stap6_tapnw3_subtapactv),

                                      .powergoodrst_b         (powergoodrst_b),
                                      .ftap_vercode           (tapnw3_tap_vercode),
                                      .ftap_slvidcode         (32'hABCD_6666),
                                      .atap_vercode           ()
                                      ); 

                              //---------------------------------------------------------------//
                              //--------------------------STAP7--------------------------------//
                              //---------------------------------------------------------------//

                              stap   #(`include "stap0_params_overide.inc")
                              i_stap7 (
                                      //Primary JTAG ports
                                      .ftap_tck               (tapnw3_stap_tck[1]),
                                      .ftap_tms               (tapnw3_stap_tms[1]),
                                      .ftap_trst_b            (tapnw3_stap_trst_b[1]),
                                      .ftap_tdi               (tapnw3_stap_tdi[1]),
                                      .atap_tdo               (stap_tapnw3_tdo[1]),
                                      .atap_tdoen             (stap_tapnw3_tdo_en[1]),

                                      //Router for TAP network
                                      .stapnw_atap_subtapactvi (1'b0),
                                      .atap_subtapactv         (stap7_tapnw3_subtapactv),

                                      .powergoodrst_b         (powergoodrst_b),
                                      .ftap_vercode           (tapnw3_tap_vercode),
                                      .ftap_slvidcode         (32'hABCD_7777),
                                      .atap_vercode           ()
                                      ); 
                                      
                              //---------------------------------------------------------------//
                              //-------------------------STAP8---------------------------------//
                              //---------------------------------------------------------------//

                              stap   #(`include "stap0_params_overide.inc")
                              i_stap8 (
                                      //Primary JTAG ports
                                      .ftap_tck               (tapnw3_stap_tck[2]),
                                      .ftap_tms               (tapnw3_stap_tms[2]),
                                      .ftap_trst_b            (tapnw3_stap_trst_b[2]),
                                      .ftap_tdi               (tapnw3_stap_tdi[2]),
                                      .atap_tdo               (stap_tapnw3_tdo[2]),
                                      .atap_tdoen             (stap_tapnw3_tdo_en[2]),

                                      //Router for TAP network
                                      .stapnw_atap_subtapactvi (1'b0),
                                      .atap_subtapactv         (stap8_tapnw3_subtapactv),

                                      .powergoodrst_b         (powergoodrst_b),
                                      .ftap_vercode           (tapnw3_tap_vercode),
                                      .ftap_slvidcode         (32'hABCD_8888),
                                      .atap_vercode           ()
                                      ); 

                              //---------------------------------------------------------------//
                              //-------------------------STAP9---------------------------------//
                              //---------------------------------------------------------------//

                              stap   #(`include "stap0_params_overide.inc")
                              i_stap9 (
                                      //Primary JTAG ports
                                      .ftap_tck               (tapnw3_stap_tck[3]),
                                      .ftap_tms               (tapnw3_stap_tms[3]),
                                      .ftap_trst_b            (tapnw3_stap_trst_b[3]),
                                      .ftap_tdi               (tapnw3_stap_tdi[3]),
                                      .atap_tdo               (stap_tapnw3_tdo[3]),
                                      .atap_tdoen             (stap_tapnw3_tdo_en[3]),

                                      //Router for TAP network
                                      .stapnw_atap_subtapactvi (1'b0),
                                      .atap_subtapactv         (stap9_tapnw3_subtapactv),

                                      .powergoodrst_b         (powergoodrst_b),
                                      .ftap_vercode           (tapnw3_tap_vercode),
                                      .ftap_slvidcode         (32'hABCD_9999),
                                      .atap_vercode           ()
                                      ); 
                            
    //---------------------------------------------------------------------------------------------//
    //--------------------------------------TAPNW2 DUT --------------------------------------------//
    //--------------------------------------LEVEL-1 (MTAP'S NW)------------------------------------//

    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW2_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW2_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW2_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW2_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw2 (
              // TAPNW2 MTAP INTERFACE
              .ptapnw_ftap_tck              (mtap_tapnw_tck),
              .ptapnw_ftap_tms              (mtap_tapnw_tms),
              .ptapnw_ftap_trst_b           (mtap_tapnw_trst_b),
              .ptapnw_ftap_tdi              (tapnw1_tapnw2_tdo),
              .ntapnw_atap_tdo              (tapnw_mtap_tdo),
              .ntapnw_atap_tdo_en           (tapnw_mtap_tdoen),

              .ftapnw_ftap_secsel           (mtap_secsel[5:3]),
              .ftapnw_ftap_enabletdo        (mtap_enabletdo[5:3]),
              .ftapnw_ftap_enabletap        (mtap_enabletap[5:3]),

              .powergoodrst_b               (powergoodrst_b),

              // TAPNW2 SLAVE TAP INTERFACE
              .ftapnw_ftap_tck              (tapnw2_stap_tck),
              .ftapnw_ftap_tms              (tapnw2_stap_tms),
              .ftapnw_ftap_trst_b           (tapnw2_stap_trst_b),
              .ftapnw_ftap_tdi              (tapnw2_stap_tdi),
              .atapnw_atap_tdo              (stap_tapnw2_tdo),
              .atapnw_atap_tdo_en           (stap_tapnw2_tdo_en),

              // TAPNW2 SECONDARY JTAG PORT
              .ptapnw_ftap_tck2             (mtap_tapnw_tck2),
              .ptapnw_ftap_tms2             (mtap_tapnw_tms2),
              .ptapnw_ftap_trst2_b          (mtap_tapnw_trst2_b),
              .ptapnw_ftap_tdi2             (tapnw1_tapnw2_tdo2),
              .ntapnw_atap_tdo2_en          (tapnw_mtap_tdo2en),
              .ntapnw_atap_tdo2             (tapnw_mtap_tdo2),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap3_tapnw2_subtapactv,stap4_tapnw2_subtapactv,stap5_tapnw2_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw2_mtap0_subtapactv),


              // TAPNW2 VERCODE
              .ftapnw_ftap_vercodei         (mtap_tapnw_vercode),
              .ftapnw_ftap_vercodeo         (tapnw2_tap_vercode)
             );
             //---------------------------------------------------------------//
             //-------------------------STAP3---------------------------------//
             //---------------------------------------------------------------//

             stap   #(`include "stap0_params_overide.inc")
             i_stap3 (
                     //Primary JTAG ports
                     .ftap_tck               (tapnw2_stap_tck[0]),
                     .ftap_tms               (tapnw2_stap_tms[0]),
                     .ftap_trst_b            (tapnw2_stap_trst_b[0]),
                     .ftap_tdi               (tapnw2_stap_tdi[0]),
                     .atap_tdo               (stap_tapnw2_tdo[0]),
                     .atap_tdoen             (stap_tapnw2_tdo_en[0]),

                     //Router for TAP network
                     .stapnw_atap_subtapactvi (1'b0),
                     .atap_subtapactv         (stap3_tapnw2_subtapactv),

                     .powergoodrst_b         (powergoodrst_b),
                     .ftap_vercode           (tapnw2_tap_vercode),
                     .ftap_slvidcode         (32'hABCD_3333),
                     .atap_vercode           ()
                     ); 

             //---------------------------------------------------------------//
             //--------------------------STAP4--------------------------------//
             //---------------------------------------------------------------//

             stap   #(`include "stap0_params_overide.inc")
             i_stap4 (
                     //Primary JTAG ports
                     .ftap_tck               (tapnw2_stap_tck[1]),
                     .ftap_tms               (tapnw2_stap_tms[1]),
                     .ftap_trst_b            (tapnw2_stap_trst_b[1]),
                     .ftap_tdi               (tapnw2_stap_tdi[1]),
                     .atap_tdo               (stap_tapnw2_tdo[1]),
                     .atap_tdoen             (stap_tapnw2_tdo_en[1]),

                     //Router for TAP network
                     .stapnw_atap_subtapactvi (1'b0),
                     .atap_subtapactv         (stap4_tapnw2_subtapactv),

                     .powergoodrst_b         (powergoodrst_b),
                     .ftap_vercode           (tapnw2_tap_vercode),
                     .ftap_slvidcode         (32'hABCD_4444),
                     .atap_vercode           ()
                     ); 
                                      
             //---------------------------------------------------------------//
             //-------------------------STAP5---------------------------------//
             //---------------------------------------------------------------//

             stap   #(`include "stap0_params_overide.inc")
             i_stap5 (
                     //Primary JTAG ports
                     .ftap_tck               (tapnw2_stap_tck[2]),
                     .ftap_tms               (tapnw2_stap_tms[2]),
                     .ftap_trst_b            (tapnw2_stap_trst_b[2]),
                     .ftap_tdi               (tapnw2_stap_tdi[2]),
                     .atap_tdo               (stap_tapnw2_tdo[2]),
                     .atap_tdoen             (stap_tapnw2_tdo_en[2]),

                     //Router for TAP network
                     .stapnw_atap_subtapactvi (1'b0),
                     .atap_subtapactv         (stap5_tapnw2_subtapactv),


                     .powergoodrst_b         (powergoodrst_b),
                     .ftap_vercode           (tapnw2_tap_vercode),
                     .ftap_slvidcode         (32'hABCD_5555),
                     .atap_vercode           ()
                     ); 


endmodule
