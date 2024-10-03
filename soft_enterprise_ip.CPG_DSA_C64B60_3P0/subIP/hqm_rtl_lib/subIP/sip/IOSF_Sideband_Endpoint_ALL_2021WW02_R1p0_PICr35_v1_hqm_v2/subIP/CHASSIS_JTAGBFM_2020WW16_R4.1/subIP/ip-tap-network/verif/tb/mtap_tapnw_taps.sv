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
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
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

//`include "tb_param.inc"


module mtap_tapnw_taps (
                        //PRIMARY JTAG PORT
                        tck,
                        tms,
                        trst_b,
                        tdi,
                        tdo,

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
                        slvidcode_stap4,
                        slvidcode_stap5,
                        slvidcode_stap6,
                        slvidcode_stap7,

                        //TAPNW controls from MTAP need to be brought out for OVM env
                        atap_secsel,
                        atap_enabletdo,
                        atap_enabletap,

                        //From SoC
                        powergoodrst_b
                       );

`include "mtap0_params_include.inc"

`include "tapnw0_params_include.inc"

`include "stap0_params_include.inc"
`include "stap1_params_include.inc"
`include "stap2_params_include.inc"
`include "stap3_params_include.inc"
    //----------------------------------------------------------------------
    // Port Signal Declarations
    //----------------------------------------------------------------------

    //PRIMARY JTAG PORT
    input  tck;
    input  tms;
    input  trst_b;
    input  tdi;
    output tdo;

    //Secondary JTAG PORT
    input  tck2;
    input  tms2;
    input  trst_b2;
    input  tdi2;
    output tdo2;
    output tdo2_en;

    input [3:0]  vercode;
    input [31:0] slvidcode_mtap;
    input [31:0] slvidcode_stap0;
    input [31:0] slvidcode_stap1;
    input [31:0] slvidcode_stap2;
    input [31:0] slvidcode_stap3;
    input [31:0] slvidcode_stap4;
    input [31:0] slvidcode_stap5;
    input [31:0] slvidcode_stap6;
    input [31:0] slvidcode_stap7;

    //TAPNW controls from MTAP need to be brought out for OVM env
    output [(TAPNW0_NUMBER_OF_STAPS  - 1):0] atap_secsel;
    output [(TAPNW0_NUMBER_OF_STAPS  - 1):0] atap_enabletdo;
    output [(TAPNW0_NUMBER_OF_STAPS  - 1):0] atap_enabletap;

    //From SoC
    input powergoodrst_b;

    //----------------------------------------------------------------------
    // Wires & Regs
    //----------------------------------------------------------------------

    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] stap_tapnw_tdo;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] stap_tapnw_tdo_en;
    wire                                  ftap_tck;
    wire                                  ftap_tms;
    wire                                  ftap_trst_b;
    wire                                  ftap_tdi;

    wire                                  atap_tdo;
    wire                                  atap_tdoen;
    wire [2:0]                            atap_tapulock;


    //----------------------------------------------------------------------
    //Based on Number of Staps in the Network, port width is hardocoded.
    //----------------------------------------------------------------------

    wire [(TAPNW0_NUMBER_OF_STAPS  - 1):0] atap_secsel;
    wire [(TAPNW0_NUMBER_OF_STAPS  - 1):0] atap_enabletdo;
    wire [(TAPNW0_NUMBER_OF_STAPS  - 1):0] atap_enabletap;

    //----------------------------------------------------------------------
    //From TAPNW to sTAP's
    //----------------------------------------------------------------------

    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw_stap_tck;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw_stap_tms;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw_stap_trst_b;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw_stap_tdi;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw_stap_tdo;

    logic [99:0]                          tapnw_prim_tdoen_temp = 100'h00000; 
    //----------------------------------------------------------------------
    //From TAPNW to TAP's
    //----------------------------------------------------------------------

    //VERCODE
    //wire [((4 * (TAPNW0_NUMBER_OF_STAPS + TAPNW0_NUMBER_OF_WTAPS)) - 1):0] tapnw_tap_vercode;
    wire [3:0] tapnw_tap_vercode;

    //----------------------------------------------------------------------
    //From MTAP to TAPNW
    //----------------------------------------------------------------------

    wire mtap_tapnw_pri_clk;
    wire mtap_tapnw_pri_tms;
    wire mtap_tapnw_pri_trst_b;
    wire mtap_tapnw_pri_tdi;
    wire tapnw_prim_port_tdo;
    wire tapnw_prim_port_tdoen;

    wire mtap_tapnw_sec_clk;
    wire mtap_tapnw_sec_tms;
    wire mtap_tapnw_sec_trst_b;
    wire mtap_tapnw_sec_tdi;
    wire tapnw_sec_port_tdo;
    wire tapnw_sec_port_tdoen;

    //VERCODE
    wire [3:0] mtap_tapnw_vercode;

    //----------------------------------------------------------------------
    //Connetcions to Primary Port.
    //----------------------------------------------------------------------
    assign ftap_tck    = tck;
    assign ftap_tms    = tms;
    assign ftap_trst_b = trst_b;
    assign ftap_tdi    = tdi;
    assign tdo         = atap_tdo;

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------MTAP0------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    cltapc #(
           .MTAP_NUMBER_OF_MANDATORY_REGISTERS                          (MTAP0_NUMBER_OF_MANDATORY_REGISTERS),
           .MTAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (MTAP0_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .MTAP_DFX_SECURE_WIDTH                                       (MTAP0_DFX_SECURE_WIDTH),
           .MTAP_NUMBER_OF_BITS_FOR_SLICE                               (MTAP0_NUMBER_OF_BITS_FOR_SLICE),
           .MTAP_SIZE_OF_EACH_INSTRUCTION                               (MTAP0_SIZE_OF_EACH_INSTRUCTION),
           .MTAP_ENABLE_VERCODE                                         (MTAP0_ENABLE_VERCODE ),
           .MTAP_ENABLE_PRELOAD                                         (MTAP0_ENABLE_PRELOAD ),
           .MTAP_NUMBER_OF_PRELOAD_REGISTERS                            (MTAP0_NUMBER_OF_PRELOAD_REGISTERS),
           .MTAP_ENABLE_CLAMP                                           (MTAP0_ENABLE_CLAMP   ),
           .MTAP_NUMBER_OF_CLAMP_REGISTERS                              (MTAP0_NUMBER_OF_CLAMP_REGISTERS),
           .MTAP_ENABLE_USERCODE                                        (MTAP0_ENABLE_USERCODE),
           .MTAP_NUMBER_OF_USERCODE_REGISTERS                           (MTAP0_NUMBER_OF_USERCODE_REGISTERS),
           .MTAP_ENABLE_INTEST                                          (MTAP0_ENABLE_INTEST  ),
           .MTAP_NUMBER_OF_INTEST_REGISTERS                             (MTAP0_NUMBER_OF_INTEST_REGISTERS),
           .MTAP_ENABLE_RUNBIST                                         (MTAP0_ENABLE_RUNBIST ),
           .MTAP_NUMBER_OF_RUNBIST_REGISTERS                            (MTAP0_NUMBER_OF_RUNBIST_REGISTERS),
           .MTAP_ENABLE_EXTEST_TOGGLE                                   (MTAP0_ENABLE_EXTEST_TOGGLE),
           .MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (MTAP0_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .MTAP_ENABLE_TAP_NETWORK                                     (MTAP0_ENABLE_TAP_NETWORK),
           .MTAP_ENABLE_CLTAPC_SEC_SEL                                  (MTAP0_ENABLE_CLTAPC_SEC_SEL),
           .MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (MTAP0_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .MTAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.MTAP_CONNECT_WTAP_DIRECTLY                                  (MTAP0_CONNECT_WTAP_DIRECTLY),
           .MTAP_ENABLE_WTAP_NETWORK                                    (MTAP0_ENABLE_WTAP_NETWORK),
           .MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (MTAP0_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .MTAP_NUMBER_OF_WTAPS_IN_NETWORK                             (MTAP0_NUMBER_OF_WTAPS_IN_NETWORK),
           .MTAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (MTAP0_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .MTAP_ENABLE_CLTAPC_VISAOVR                                  (MTAP0_ENABLE_CLTAPC_VISAOVR),
           .MTAP_DEPTH_OF_CLTAPC_VISAOVR_REGISTERS                      (MTAP0_DEPTH_OF_CLTAPC_VISAOVR_REGISTERS),
           .MTAP_SIZE_OF_CLTAPC_VISAOVR                                 (MTAP0_SIZE_OF_CLTAPC_VISAOVR),
           .MTAP_ENABLE_CLTAPC_REMOVE                                   (MTAP0_ENABLE_CLTAPC_REMOVE),
           .MTAP_NUMBER_OF_CLTAPC_REMOVE_REGISTERS                      (MTAP0_NUMBER_OF_CLTAPC_REMOVE_REGISTERS),
           .MTAP_SIZE_OF_CLTAPC_REMOVE                                  (MTAP0_SIZE_OF_CLTAPC_REMOVE),
           .MTAP_ENABLE_TEST_DATA_REGISTERS                             (MTAP0_ENABLE_TEST_DATA_REGISTERS),
           .MTAP_NUMBER_OF_TEST_DATA_REGISTERS                          (MTAP0_NUMBER_OF_TEST_DATA_REGISTERS),
           .MTAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (MTAP0_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (MTAP0_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .MTAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (MTAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .MTAP_NUMBER_OF_TOTAL_REGISTERS                              (MTAP0_NUMBER_OF_TOTAL_REGISTERS),
           .MTAP_INSTRUCTION_FOR_DATA_REGISTERS                         (MTAP0_INSTRUCTION_FOR_DATA_REGISTERS),
           .MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (MTAP0_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (MTAP0_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (MTAP0_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (MTAP0_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (MTAP0_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT)
          )
    i_mtap0 (
             // Primary Jtag Ports
             .atappris_tck           (ftap_tck),
             .atappris_tms           (ftap_tms),
             .atappris_trst_b        (ftap_trst_b),
             .powergoodrst_b         (powergoodrst_b),
             .atappris_tdi           (ftap_tdi),
             .ftap_vercode                (vercode),
             .ftap_idcode                 (slvidcode_mtap),
             .ftappris_tdo           (atap_tdo),
             .ftappris_tdoen         (),

             // Parallel ports of optional data registers
             .tdr_data_in            (),
             .tdr_data_out           (),
             .atap_vercode     (mtap_tapnw_vercode),

             // Secure signals
             .dfxsecurestrap_feature (),
             .ftap_dfxsecure         (),
             .atap_dfxsecure         (),
             .dfxsecure_all_en       (),
             .dfxsecure_all_dis      (),
             .dfxsecure_feature_en   (),
             
             // Control signals to Slave TAPNetwork
             .cftapnw_ftap_secsel         (atap_secsel),
             .cftapnw_ftap_enabletdo       (atap_enabletdo),
             .cftapnw_ftap_enabletap       (atap_enabletap),

             // Primary JTAG ports to Slave TAPNetwork
             .cntapnw_ftap_tck              (mtap_tapnw_pri_clk),
             .cntapnw_ftap_tms              (mtap_tapnw_pri_tms),
             .cntapnw_ftap_trst_b            (mtap_tapnw_pri_trst_b),
             .cntapnw_ftap_tdi              (mtap_tapnw_pri_tdi),
             .cntapnw_atap_tdo              (tapnw_prim_port_tdo),
             .cntapnw_atap_tdo_en            ({tapnw_prim_tdoen_temp,tapnw_prim_port_tdoen}),

             // Secondary JTAG ports
             .atapsecs_tck          (tck2),
             .atapsecs_tms          (tms2),
             .atapsecs_trst_b                (trst_b2),
             .atapsecs_tdi          (tdi2),
             .ftapsecs_tdo          (tdo2),
             .ftapsecs_tdoen         (tdo2_en),

             // Linear Network - Indicates if a Subnetwork is active or not. Tie it HIGH.
             // Hierarchical   - Tie it LOW.   
             .ctapnw_atap_subtapactvi   (8'b0),

             //Secondary JTAG ports to Slave TAPNetwork
             .cntapnw_ftap_tck2             (mtap_tapnw_sec_clk),
             .cntapnw_ftap_tms2             (mtap_tapnw_sec_tms),
             .cntapnw_ftap_trst2_b           (mtap_tapnw_sec_trst_b),
             .cntapnw_ftap_tdi2             (mtap_tapnw_sec_tdi),
             .cntapnw_atap_tdo2             (tapnw_sec_port_tdo),
             .cntapnw_atap_tdo2_en            ({tapnw_prim_tdoen_temp,tapnw_sec_port_tdoen}),

             // Control Signals only to WTAP
             //.mtap_selectwir         (),
             //.mtap_wso               (),
             //.mtap_wsi               (),

             // Control Signals common to WTAP/WTAP Network
             .cn_fwtap_wrck              (),
             .cn_fwtap_wrst_b            (),
             .cn_fwtap_capturewr         (),
             .cn_fwtap_shiftwr           (),
             .cn_fwtap_updatewr          (),
             .cn_fwtap_rti               (),

             // Control Signals only to WTAP Network
             .cn_fwtap_selectwir  (),
             .cn_awtap_wso        (),
             .cn_fwtap_wsi        (),

             // Boundary Scan Signals
             .fbscan_tck             (),
             .fbscan_tdo             (),
             .fbscan_capturedr       (),
             .fbscan_shiftdr         (),
             .fbscan_updatedr        (),
             .fbscan_runbist_en             (),
             .fbscan_highz           (),
             .fbscan_extogen         (),
             .fbscan_chainen         (),
             .fbscan_mode            (),
             .fbscan_extogsig_b      (),
             .fbscan_d6init          (),
             .fbscan_d6actestsig_b   (),
             .fbscan_d6select        ()
            );


    //---------------------------------------------------------------------------------------------//
    //--------------------------------------TAPNW0 DUT---------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    tapnw #(
            .TAPNW_NUMBER_OF_STAPS            (TAPNW0_NUMBER_OF_STAPS),
            //.TAPNW_IOSOLATETAP_GATETCK     (TAPNW0_IOSOLATETAP_GATETCK)
            //.TAPNW_ENABLE_LINEAR_NETWORK   (TAPNW0_ENABLE_LINEAR_NETWORK)
            .TAPNW_PARK_TCK_AT                (TAPNW0_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID                (TAPNW0_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW   (TAPNW0_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw0 (
              //MTAP INTERFACE
              .ptapnw_ftap_tck                  (mtap_tapnw_pri_clk),
              .ptapnw_ftap_tms                  (mtap_tapnw_pri_tms),
              .ptapnw_ftap_trst_b               (mtap_tapnw_pri_trst_b),
              .ptapnw_ftap_tdi                  (mtap_tapnw_pri_tdi),
              .ntapnw_atap_tdo                  (tapnw_prim_port_tdo),
              .ntapnw_atap_tdo_en               (tapnw_prim_port_tdoen),

              .ftapnw_ftap_secsel          (atap_secsel),
              .ftapnw_ftap_enabletdo       (atap_enabletdo),
              .ftapnw_ftap_enabletap       (atap_enabletap),

              .powergoodrst_b       (powergoodrst_b),

              //SLAVE TAP INTERFACE
              .ftapnw_ftap_tck       (tapnw_stap_tck),
              .ftapnw_ftap_tms       (tapnw_stap_tms),
              .ftapnw_ftap_trst_b    (tapnw_stap_trst_b),
              .ftapnw_ftap_tdi       (tapnw_stap_tdi),
              .atapnw_atap_tdo       (stap_tapnw_tdo),
              .atapnw_atap_tdo_en    (stap_tapnw_tdo_en),

              //SECONDARY JTAG PORT
              .ptapnw_ftap_tck2                 (mtap_tapnw_sec_clk),
              .ptapnw_ftap_tms2                 (mtap_tapnw_sec_tms),
              .ptapnw_ftap_trst2_b              (mtap_tapnw_sec_trst_b),
              .ptapnw_ftap_tdi2                 (mtap_tapnw_sec_tdi),
              .ntapnw_atap_tdo2_en              (tapnw_sec_port_tdoen),
              .ntapnw_atap_tdo2                 (tapnw_sec_port_tdo),

              //LINEAR TAP NETWORK INTERFACE
                 //PRIMARY PORT -- passthrough signals for tck, tms and trst_b
                 .ntapnw_ftap_tck                 (),
                 .ntapnw_ftap_tms                 (),
                 .ntapnw_ftap_trst_b              (),
                 
                 //SECONDARY JTAG PORT -- passthrough signals for tck2, tms2 and trst_b2
                 .ntapnw_ftap_tck2                (),
                 .ntapnw_ftap_tms2                (),
                 .ntapnw_ftap_trst2_b             (),
                 
                 //TERTIARY PORT 
                 //.stap_tapnw_tdi3       (),
                 //.tapnw_stap_tdo3       (),
                 //.tapnw_stap_tdo3_en    (),
                 //.stap_tapnw_tck3       (),
                 //.stap_tapnw_tms3       (),
                 //.stap_tapnw_trst_b3    (),
                 
                 //Sub Tap Control logic
                 .atapnw_atap_subtapactvi (8'b0),
                 .atapnw_atap_subtapactvo (),

              //VERCODE
              .ftapnw_ftap_vercodei    (mtap_tapnw_vercode),
              .ftapnw_ftap_vercodeo    (tapnw_tap_vercode)
             );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP0------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(
           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP0_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP0_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP0_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP0_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP0_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP0_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP0_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP0_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP0_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP0_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP0_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP0_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP0_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP0_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP0_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP0_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP0_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP0_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP0_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP0_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP0_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP0_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP0_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP0_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP0_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP0_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP0_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP0_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP0_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP0_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP0_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP0_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP0_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP0_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP0_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP0_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP0_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP0_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP0_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP0_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP0_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP0_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP0_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP0_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP0_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP0_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP0_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP0_ENABLE_LINEAR_NETWORK)
          )
    i_stap0 (
            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[0]),
            .ftap_tms               (tapnw_stap_tms[0]),
            .ftap_trst_b            (tapnw_stap_trst_b[0]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[0]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap0),
            .atap_tdo               (stap_tapnw_tdo[0]),
            .atap_tdoen             (stap_tapnw_tdo_en[0]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo            (),
            .tap_rtdr_tdi            (),
            .rtdr_tap_ip_clk_i       (),
            .tap_rtdr_capture     (),
            .tap_rtdr_shift       (),
            .tap_rtdr_update      (),
            .tap_rtdr_irdec          (),
            .tap_rtdr_powergoodrst_b (),
            .tap_rtdr_rti            ()
            );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP1------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(

           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP1_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP1_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP1_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP1_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP1_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP1_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP1_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP1_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP1_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP1_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP1_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP1_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP1_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP1_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP1_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP1_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP1_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP1_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP1_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP1_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP1_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP1_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP1_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP1_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP1_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP1_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP1_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP1_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP1_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP1_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP1_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP1_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP1_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP1_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP1_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP1_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP1_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP1_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP1_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP1_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP1_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP1_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP1_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP1_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP1_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP1_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP1_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP1_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP1_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP1_ENABLE_LINEAR_NETWORK)
          )
    i_stap1 (

            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[1]),
            .ftap_tms               (tapnw_stap_tms[1]),
            .ftap_trst_b            (tapnw_stap_trst_b[1]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[1]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap1),
            .atap_tdo               (stap_tapnw_tdo[1]),
            .atap_tdoen             (stap_tapnw_tdo_en[1]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo            (),
            .tap_rtdr_tdi            (),
            .rtdr_tap_ip_clk_i       (),
            .tap_rtdr_capture     (),
            .tap_rtdr_shift       (),
            .tap_rtdr_update      (),
            .tap_rtdr_irdec          (),
            .tap_rtdr_powergoodrst_b (), 
            .tap_rtdr_rti            ()
            );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP2------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(

           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP2_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP2_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP2_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP2_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP2_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP2_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP2_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP2_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP2_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP2_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP2_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP2_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP2_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP2_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP2_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP2_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP2_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP2_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP2_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP2_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP2_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP2_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP2_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP2_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP2_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP2_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP2_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP2_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP2_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP2_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP2_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP2_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP2_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP2_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP2_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP2_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP2_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP2_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP2_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP2_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP2_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP2_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP2_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP2_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP2_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP2_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP2_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP2_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP2_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP2_ENABLE_LINEAR_NETWORK)
          )
    i_stap2 (
            
            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[2]),
            .ftap_tms               (tapnw_stap_tms[2]),
            .ftap_trst_b            (tapnw_stap_trst_b[2]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[2]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap2),
            .atap_tdo               (stap_tapnw_tdo[2]),
            .atap_tdoen             (stap_tapnw_tdo_en[2]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo            (),
            .tap_rtdr_tdi            (),
            .rtdr_tap_ip_clk_i       (),
            .tap_rtdr_capture     (),
            .tap_rtdr_shift       (),
            .tap_rtdr_update      (),
            .tap_rtdr_irdec          (),
            .tap_rtdr_powergoodrst_b (),
            .tap_rtdr_rti            ()
            );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP3------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(
           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP3_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP3_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP3_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP3_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP3_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP3_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP3_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP3_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP3_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP3_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP3_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP3_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP3_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP3_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP3_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP3_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP3_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP3_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP3_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP3_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP3_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP3_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP3_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP3_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP3_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP3_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP3_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP3_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP3_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP3_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP3_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP3_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP3_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP3_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP3_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP3_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP3_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP3_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP3_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP3_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP3_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP3_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP3_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP3_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP3_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP3_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP3_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP3_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP3_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP3_ENABLE_LINEAR_NETWORK)
          )
    i_stap3 (
           
            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[3]),
            .ftap_tms               (tapnw_stap_tms[3]),
            .ftap_trst_b            (tapnw_stap_trst_b[3]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[3]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap3),
            .atap_tdo               (stap_tapnw_tdo[3]),
            .atap_tdoen             (stap_tapnw_tdo_en[3]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo            (),
            .tap_rtdr_tdi            (),
            .rtdr_tap_ip_clk_i       (),
            .tap_rtdr_capture     (),
            .tap_rtdr_shift       (),
            .tap_rtdr_update      (),
            .tap_rtdr_irdec          (),
            .tap_rtdr_powergoodrst_b (),
            .tap_rtdr_rti            ()
            );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP4------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(
           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP0_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP0_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP0_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP0_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP0_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP0_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP0_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP0_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP0_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP0_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP0_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP0_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP0_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP0_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP0_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP0_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP0_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP0_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP0_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP0_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP0_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP0_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP0_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP0_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP0_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP0_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP0_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP0_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP0_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP0_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP0_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP0_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP0_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP0_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP0_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP0_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP0_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP0_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP0_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP0_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP0_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP0_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP0_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP0_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP0_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP0_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP0_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP0_ENABLE_LINEAR_NETWORK)
          )
    i_stap4 (
            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[4]),
            .ftap_tms               (tapnw_stap_tms[4]),
            .ftap_trst_b            (tapnw_stap_trst_b[4]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[4]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap4),
            .atap_tdo               (stap_tapnw_tdo[4]),
            .atap_tdoen             (stap_tapnw_tdo_en[4]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo            (),
            .tap_rtdr_tdi            (),
            .rtdr_tap_ip_clk_i       (),
            .tap_rtdr_capture     (),
            .tap_rtdr_shift       (),
            .tap_rtdr_update      (),
            .tap_rtdr_irdec          (),
            .tap_rtdr_powergoodrst_b (),
            .tap_rtdr_rti            ()
            );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP5------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(

           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP1_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP1_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP1_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP1_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP1_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP1_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP1_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP1_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP1_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP1_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP1_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP1_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP1_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP1_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP1_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP1_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP1_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP1_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP1_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP1_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP1_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP1_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP1_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP1_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP1_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP1_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP1_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP1_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP1_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP1_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP1_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP1_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP1_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP1_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP1_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP1_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP1_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP1_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP1_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP1_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP1_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP1_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP1_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP1_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP1_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP1_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP1_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP1_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP1_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP1_ENABLE_LINEAR_NETWORK)
          )
    i_stap5 (

            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[5]),
            .ftap_tms               (tapnw_stap_tms[5]),
            .ftap_trst_b            (tapnw_stap_trst_b[5]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[5]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap5),
            .atap_tdo               (stap_tapnw_tdo[5]),
            .atap_tdoen             (stap_tapnw_tdo_en[5]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo          (),
            .tap_rtdr_tdi          (),
            .rtdr_tap_ip_clk_i     (),
            .tap_rtdr_capture   (),
            .tap_rtdr_shift     (),
            .tap_rtdr_update    (),
            .tap_rtdr_powergoodrst_b() 

            );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP6------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(

           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP2_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP2_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP2_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP2_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP2_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP2_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP2_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP2_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP2_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP2_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP2_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP2_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP2_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP2_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP2_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP2_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP2_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP2_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP2_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP2_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP2_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP2_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP2_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP2_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP2_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP2_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP2_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP2_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP2_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP2_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP2_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP2_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP2_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP2_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP2_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP2_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP2_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP2_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP2_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP2_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP2_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP2_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP2_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP2_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP2_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP2_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP2_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP2_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP2_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP2_ENABLE_LINEAR_NETWORK)
          )
    i_stap6 (
            
            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[6]),
            .ftap_tms               (tapnw_stap_tms[6]),
            .ftap_trst_b            (tapnw_stap_trst_b[6]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[6]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap6),
            .atap_tdo               (stap_tapnw_tdo[6]),
            .atap_tdoen             (stap_tapnw_tdo_en[6]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo          (),
            .tap_rtdr_tdi          (),
            .rtdr_tap_ip_clk_i     (),
            .tap_rtdr_capture   (),
            .tap_rtdr_shift     (),
            .tap_rtdr_update    (),
            .tap_rtdr_powergoodrst_b() 

            );

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP7------------------------------------------------//
    //---------------------------------------------------------------------------------------------//

    stap #(
           .STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE                       (STAP3_NUMBER_OF_DFX_FEATURES_TO_SECURE),
           .STAP_DFX_SECURE_WIDTH                                       (STAP3_DFX_SECURE_WIDTH),
           .STAP_ENABLE_BSCAN                                           (STAP3_ENABLE_BSCAN   ),
           .STAP_NUMBER_OF_MANDATORY_REGISTERS                          (STAP3_NUMBER_OF_MANDATORY_REGISTERS),
           .STAP_NUMBER_OF_BITS_FOR_SLICE                               (STAP3_NUMBER_OF_BITS_FOR_SLICE),
           .STAP_SIZE_OF_EACH_INSTRUCTION                               (STAP3_SIZE_OF_EACH_INSTRUCTION),
           .STAP_ENABLE_VERCODE                                         (STAP3_ENABLE_VERCODE ),
           .STAP_ENABLE_PRELOAD                                         (STAP3_ENABLE_PRELOAD ),
           .STAP_NUMBER_OF_PRELOAD_REGISTERS                            (STAP3_NUMBER_OF_PRELOAD_REGISTERS),
           .STAP_ENABLE_CLAMP                                           (STAP3_ENABLE_CLAMP   ),
           .STAP_NUMBER_OF_CLAMP_REGISTERS                              (STAP3_NUMBER_OF_CLAMP_REGISTERS),
           //.STAP_ENABLE_USERCODE                                        (STAP3_ENABLE_USERCODE),
           //.STAP_NUMBER_OF_USERCODE_REGISTERS                           (STAP3_NUMBER_OF_USERCODE_REGISTERS),
           .STAP_ENABLE_INTEST                                          (STAP3_ENABLE_INTEST  ),
           .STAP_NUMBER_OF_INTEST_REGISTERS                             (STAP3_NUMBER_OF_INTEST_REGISTERS),
           .STAP_ENABLE_RUNBIST                                         (STAP3_ENABLE_RUNBIST ),
           .STAP_NUMBER_OF_RUNBIST_REGISTERS                            (STAP3_NUMBER_OF_RUNBIST_REGISTERS),
           .STAP_ENABLE_EXTEST_TOGGLE                                   (STAP3_ENABLE_EXTEST_TOGGLE),
           .STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS                      (STAP3_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
           .STAP_ENABLE_TAP_NETWORK                                     (STAP3_ENABLE_TAP_NETWORK),
           .STAP_NUMBER_OF_TAP_SELECT_REGISTERS                         (STAP3_NUMBER_OF_TAP_SELECT_REGISTERS),
           .STAP_ENABLE_TAPC_SEC_SEL                                    (STAP3_ENABLE_TAPC_SEC_SEL),
           .STAP_NUMBER_OF_TAP_NETWORK_REGISTERS                        (STAP3_NUMBER_OF_TAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                          (STAP3_NUMBER_OF_TAPS_IN_TAP_NETWORK),
           //.STAP_CONNECT_WTAP_DIRECTLY                                  (STAP3_CONNECT_WTAP_DIRECTLY),
           .STAP_ENABLE_WTAP_NETWORK                                    (STAP3_ENABLE_WTAP_NETWORK),
           .STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS                       (STAP3_NUMBER_OF_WTAP_NETWORK_REGISTERS),
           .STAP_NUMBER_OF_WTAPS_IN_NETWORK                             (STAP3_NUMBER_OF_WTAPS_IN_NETWORK),
           .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL          (STAP3_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
           .STAP_ENABLE_TAPC_VISAOVR                                    (STAP3_ENABLE_TAPC_VISAOVR),
           .STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS                        (STAP3_DEPTH_OF_TAPC_VISAOVR_REGISTERS),
           .STAP_SIZE_OF_TAPC_VISAOVR                                   (STAP3_SIZE_OF_TAPC_VISAOVR),
           .STAP_ENABLE_TAPC_REMOVE                                     (STAP3_ENABLE_TAPC_REMOVE),
           .STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS                        (STAP3_NUMBER_OF_TAPC_REMOVE_REGISTERS),
           .STAP_SIZE_OF_TAPC_REMOVE                                    (STAP3_SIZE_OF_TAPC_REMOVE),
           .STAP_ENABLE_TEST_DATA_REGISTERS                             (STAP3_ENABLE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TEST_DATA_REGISTERS                          (STAP3_NUMBER_OF_TEST_DATA_REGISTERS),
           .STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS                      (STAP3_SIZE_OF_TOTAL_TEST_DATA_REGISTERS),
           .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS                     (STAP3_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS                 (STAP3_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_TOTAL_REGISTERS                              (STAP3_NUMBER_OF_TOTAL_REGISTERS),
           .STAP_INSTRUCTION_FOR_DATA_REGISTERS                         (STAP3_INSTRUCTION_FOR_DATA_REGISTERS),
           .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                        (STAP3_SIZE_OF_EACH_TEST_DATA_REGISTER),
           .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP3_MSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS                      (STAP3_LSB_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS                    (STAP3_RESET_VALUES_OF_TEST_DATA_REGISTERS),
           .STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT              (STAP3_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),

           .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                      (STAP3_ENABLE_REMOTE_TEST_DATA_REGISTERS),
           .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS                   (STAP3_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
           .STAP_ENABLE_LINEAR_NETWORK                                  (STAP3_ENABLE_LINEAR_NETWORK)
          )
    i_stap7 (
           
            //Primary JTAG ports
            .ftap_tck               (tapnw_stap_tck[7]),
            .ftap_tms               (tapnw_stap_tms[7]),
            .ftap_trst_b            (tapnw_stap_trst_b[7]),
            .powergoodrst_b         (powergoodrst_b),
            .ftap_tdi               (tapnw_stap_tdi[7]),
            .ftap_vercode           (tapnw_tap_vercode),
            .ftap_slvidcode         (slvidcode_stap7),
            .atap_tdo               (stap_tapnw_tdo[7]),
            .atap_tdoen             (stap_tapnw_tdo_en[7]),
            .atap_vercode     (),

            //Parallel ports of optional data registers
            .tdr_data_out           (),
            .tdr_data_in            (),
            // Visa  Register Data out
            .tapc_visaovr           (),

            //Lock signals
				.dfxsecurestrap_feature  (),
            .ftap_dfxsecure          (),
            .atap_dfxsecure          (),
            .dfxsecure_all_en        (),
            .dfxsecure_all_dis       (),
            .dfxsecure_feature_en    (),
            .vodfv_all_dis           (),
            .vodfv_customer_dis      (),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (),
            .sftapnw_ftap_enabletdo        (),
            .sftapnw_ftap_enabletap        (),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b           (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en           (),

            //Secondary JTAG Ports
            .ftapsslv_tck          (),
            .ftapsslv_tms          (),
            .ftapsslv_trst_b       (),
            .ftapsslv_tdi          (),
            .atapsslv_tdo          (),
            .atapsslv_tdoen        (),

            //Secondary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b          (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

            //Control Signals  common to WTAP/WTAP Network
            .sn_fwtap_wrck             (),
            .sn_fwtap_wrst_b           (),
            .sn_fwtap_capturewr        (),
            .sn_fwtap_shiftwr          (),
            .sn_fwtap_updatewr         (),
            .sn_fwtap_rti              (),

            //Control Signals only to WTAP Network
            .sn_fwtap_selectwir (),
            .sn_awtap_wso       (),
            .sn_fwtap_wsi       (),

            //Boundary Scan Signals

            //Control Signals from fsm
            .stap_fbscan_tck            (),
            .stap_fbscan_tdo            (),
            .stap_fbscan_capturedr      (),
            .stap_fbscan_shiftdr        (),
            .stap_fbscan_updatedr       (),

            //Instructions
            .stap_fbscan_runbist_en            (),
            .stap_fbscan_highz          (),
            .stap_fbscan_extogen        (),
            .stap_fbscan_chainen        (),
            .stap_fbscan_mode           (),
            .stap_fbscan_extogsig_b     (),

            //1149.6 AC mode
            .stap_fbscan_d6init         (),
            .stap_fbscan_d6actestsig_b  (),
            .stap_fbscan_d6select       (),

            //Router for TAP network
            .stapnw_atap_subtapactvi (1'b0),
            .atap_subtapactv    (),

            //Remote Test Data Register pins
            .rtdr_tap_tdo          (),
            .tap_rtdr_tdi          (),
            .rtdr_tap_ip_clk_i     (),
            .tap_rtdr_capture   (),
            .tap_rtdr_shift     (),
            .tap_rtdr_update    (),
            .tap_rtdr_powergoodrst_b() 

            );
endmodule
