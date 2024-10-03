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

                        //Teritiary JTAG PORT
                        tck3,
                        tms3,
                        trst_b3,
                        tdi3,
                        tdo3,
                        tdo3_en,

                        vercode,
                        slvidcode_mtap,
                        slvidcode_stap0,
                        slvidcode_stap1,
                        slvidcode_stap2,
                        slvidcode_stap3,

                        //TAPNW controls from MTAP need to be brought out for UVM env
                        atap_secsel,
                        atap_enabletdo,
                        atap_enabletap,

                        //From SoC
                        powergoodrst_b
                       );

`include "mtap0_params_include.inc"

`include "tapnw0_params_include.inc"
`include "tapnw1_params_include.inc"

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

    //Teritiary JTAG PORT
    input  tck3;
    input  tms3;
    input  trst_b3;
    input  tdi3;
    output tdo3;
    output tdo3_en;

    input [3:0]  vercode;
    input [31:0] slvidcode_mtap;
    input [31:0] slvidcode_stap0;
    input [31:0] slvidcode_stap1;
    input [31:0] slvidcode_stap2;
    input [31:0] slvidcode_stap3;



    //TAPNW controls from MTAP need to be brought out for UVM env
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

    //----------------------------------------------------------------------
    //From TAPNW to TAP's
    //----------------------------------------------------------------------

    //VERCODE
    //wire [((4 * (TAPNW0_NUMBER_OF_STAPS + TAPNW0_NUMBER_OF_WTAPS)) - 1):0] tapnw_tap_vercode;
    wire [3:0] tapnw_tap_vercode;

    //----------------------------------------------------------------------
    //From sTAP1 to Level-2 TAPNW
    //----------------------------------------------------------------------

    wire stap1_tapnw1_pri_clk;
    wire stap1_tapnw1_pri_tms;
    wire stap1_tapnw1_pri_trst_b;
    wire stap1_tapnw1_pri_tdi;
    wire tapnw1_stap1_pri_tdo;
    wire tapnw1_stap1_pri_tdoen;

    wire stap1_tapnw1_sec_clk;
    wire stap1_tapnw1_sec_tms;
    wire stap1_tapnw1_sec_trst_b;
    wire stap1_tapnw1_sec_tdi;
    wire tapnw1_stap1_sec_tdo;
    wire tapnw1_stap1_sec_tdoen;

    //VERCODE
    wire [3:0] stap1_tapnw1_vercode;
    wire [3:0] tapnw1_tap_vercode;

    //----------------------------------------------------------------------
    //From sTAP1 to Level-2 TAPNW
    //----------------------------------------------------------------------

    wire [(TAPNW0_NUMBER_OF_STAPS  - 1):0] stap1_secsel;
    wire [(TAPNW0_NUMBER_OF_STAPS  - 1):0] stap1_enabletdo;
    wire [(TAPNW0_NUMBER_OF_STAPS  - 1):0] stap1_enabletap;

    //----------------------------------------------------------------------
    //From Level-2 TAPNW to sTAP's
    //----------------------------------------------------------------------

    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw1_stap_tck;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw1_stap_tms;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw1_stap_trst_b;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw1_stap_tdi;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] stap_tapnw1_tdo;
    wire [(TAPNW0_NUMBER_OF_STAPS - 1):0] stap_tapnw1_tdo_en;

    //----------------------------------------------------------------------
    //From Tapnw0 to Tapnw1
    //----------------------------------------------------------------------
    wire tapnw0_tapnw1_tck;
    wire tapnw0_tapnw1_tms;
    wire tapnw0_tapnw1_trst_b;
    wire tapnw0_tapnw1_pri_tdo;
    wire tapnw0_tapnw1_tck2;
    wire tapnw0_tapnw1_tms2;
    wire tapnw0_tapnw1_trst_b2;

    //----------------------------------------------------------------------
    //From Tapnw1 to sTAP1 Teritiary Port
    //----------------------------------------------------------------------
    wire tapnw1_stap1_tdo3;
    wire tapnw1_stap1_tdo3en; //FIXME

    //----------------------------------------------------------------------
    //From sTAP1 Teritiary Port to tapnw1
    //----------------------------------------------------------------------
    wire stap1_tapnw1_tdi3;

    //----------------------------------------------------------------------
    //From tapnw1 to mTAP
    //----------------------------------------------------------------------
    wire tapnw1_mtap_sec_tdo;
    wire tapnw1_mtap_sec_tdoen;
    wire tapnw1_mtap_pri_tdo;
    wire tapnw1_mtap_pri_tdoen;

    //----------------------------------------------------------------------
    //From tapnw1 to mTAP
    //----------------------------------------------------------------------
    wire tapnw0_tapnw1_sec_tdi;

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
    //Subtap Active
    //----------------------------------------------------------------------
    wire stap0_tapnw0_subtapactv;
    wire stap1_tapnw0_subtapactv;
    wire stap2_tapnw1_subtapactv;
    wire stap3_tapnw1_subtapactv;

    wire tapnw0_mtap_subtapactv;
    wire tapnw1_stap1_subtapactv;

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
         
    cltapc  #(`include "mtap0_params_overide.inc")
    i_mtap0 (
             // Primary Jtag Ports
             .atappris_tck                  (ftap_tck),
             .atappris_tms                  (ftap_tms),
             .atappris_trst_b               (ftap_trst_b),
             .powergoodrst_b                (powergoodrst_b),
             .atappris_tdi                  (ftap_tdi),
             .ftap_vercode                  (vercode),
             .ftap_idcode                   (32'h1234_5678),
             .ftappris_tdo                  (atap_tdo),
             .ftappris_tdoen                (),

             .atap_vercode                  (mtap_tapnw_vercode),
             
             // Control signals to Slave TAPNetwork
             .cftapnw_ftap_secsel           (atap_secsel),
             .cftapnw_ftap_enabletdo        (atap_enabletdo),
             .cftapnw_ftap_enabletap        (atap_enabletap),

             // Primary JTAG ports to Slave TAPNetwork
             .cntapnw_ftap_tck              (mtap_tapnw_pri_clk),
             .cntapnw_ftap_tms              (mtap_tapnw_pri_tms),
             .cntapnw_ftap_trst_b           (mtap_tapnw_pri_trst_b),
             .cntapnw_ftap_tdi              (mtap_tapnw_pri_tdi),
             //For linear_network this comes from tapnw1
             .cntapnw_atap_tdo              (tapnw1_mtap_pri_tdo),
             .cntapnw_atap_tdo_en           ({1'b0,tapnw1_mtap_pri_tdoen}),

             // Secondary JTAG ports
             .atapsecs_tck                  (tck2),
             .atapsecs_tms                  (tms2),
             .atapsecs_trst_b               (trst_b2),
             .atapsecs_tdi                  (tdi2),
             .ftapsecs_tdo                  (tdo2),
             .ftapsecs_tdoen                (tdo2_en),

             //.ctapnw_atap_subtapactvi     ({tapnw1_stap1_subtapactv,tapnw0_mtap_subtapactv}),
             .ctapnw_atap_subtapactvi       (tapnw0_mtap_subtapactv),

             //mTAP Secondary JTAG ports to Slave TAPNetwork, tdi goes to tapnw0, tdo comes from tapnw1
             .cntapnw_ftap_tck2             (mtap_tapnw_sec_clk),
             .cntapnw_ftap_tms2             (mtap_tapnw_sec_tms),
             .cntapnw_ftap_trst2_b          (mtap_tapnw_sec_trst_b),
             .cntapnw_ftap_tdi2             (mtap_tapnw_sec_tdi),
             //For linear_network this comes from tapnw1
             .cntapnw_atap_tdo2             (tapnw1_mtap_sec_tdo),
             .cntapnw_atap_tdo2_en          ({1'b0,tapnw1_mtap_sec_tdoen})
            );

    //---------------------------------------------------------------------------------------------//
    //--------------------------------------TAPNW0 DUT --------------------------------------------//
    //--------------------------------------LEVEL-1 (MTAP'S NW)------------------------------------//
    //--------------------------------------LINEAR NW----------------------------------------------//

    tapnw #(
            .TAPNW_NUMBER_OF_STAPS            (TAPNW0_NUMBER_OF_STAPS),
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
              //For linear_network this goes to the next tapnw and not back to mtap
              //.ntapnw_atap_tdo                  (tapnw_prim_port_tdo),
              //.ntapnw_atap_tdo_en               (tapnw_prim_port_tdoen),
              .ntapnw_atap_tdo                  (tapnw0_tapnw1_pri_tdo),
              .ntapnw_atap_tdo_en               (), //FIXME

              .ftapnw_ftap_secsel               (atap_secsel),
              .ftapnw_ftap_enabletdo            (atap_enabletdo),
              .ftapnw_ftap_enabletap            (atap_enabletap),

              .powergoodrst_b                   (powergoodrst_b),

              //SLAVE TAP INTERFACE
              .ftapnw_ftap_tck                  (tapnw_stap_tck),
              .ftapnw_ftap_tms                  (tapnw_stap_tms),
              .ftapnw_ftap_trst_b               (tapnw_stap_trst_b),
              .ftapnw_ftap_tdi                  (tapnw_stap_tdi),
              .atapnw_atap_tdo                  (stap_tapnw_tdo),
              .atapnw_atap_tdo_en               (stap_tapnw_tdo_en),

              //SECONDARY JTAG PORT
              .ptapnw_ftap_tck2                 (mtap_tapnw_sec_clk),
              .ptapnw_ftap_tms2                 (mtap_tapnw_sec_tms),
              .ptapnw_ftap_trst2_b              (mtap_tapnw_sec_trst_b),
              .ptapnw_ftap_tdi2                 (mtap_tapnw_sec_tdi),
              .ntapnw_atap_tdo2_en              (tapnw_sec_port_tdoen),
              .ntapnw_atap_tdo2                 (tapnw0_tapnw1_sec_tdi),

              //LINEAR TAP NETWORK INTERFACE
              //PRIMARY PORT -- passthrough signals for tck, tms and trst_b
              .ntapnw_ftap_tck                  (tapnw0_tapnw1_tck),
              .ntapnw_ftap_tms                  (tapnw0_tapnw1_tms),
              .ntapnw_ftap_trst_b               (tapnw0_tapnw1_trst_b),
              
              //SECONDARY JTAG PORT -- passthrough signals for tck2, tms2 and trst_b2
              .ntapnw_ftap_tck2                 (tapnw0_tapnw1_tck2),
              .ntapnw_ftap_tms2                 (tapnw0_tapnw1_tms2),
              .ntapnw_ftap_trst2_b              (tapnw0_tapnw1_trst_b2),
              
              //Sub Tap Control logic
              .atapnw_atap_subtapactvi          ({stap1_tapnw0_subtapactv,stap0_tapnw0_subtapactv}),
              .atapnw_atap_subtapactvo          (tapnw0_mtap_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei             (mtap_tapnw_vercode),
              .ftapnw_ftap_vercodeo             (tapnw_tap_vercode)
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP0--------------------------------------//
    //-------------------------------------------------------------------------//
    stap   #(`include "stap0_params_overide.inc")
    i_stap0 (
            //Primary JTAG ports
            .ftap_tck                (tapnw_stap_tck[0]),
            .ftap_tms                (tapnw_stap_tms[0]),
            .ftap_trst_b             (tapnw_stap_trst_b[0]),
            .powergoodrst_b          (powergoodrst_b),
            .ftap_tdi                (tapnw_stap_tdi[0]),
            .ftap_vercode            (tapnw_tap_vercode),
            .ftap_slvidcode          (32'h1111_1111),
            .atap_tdo                (stap_tapnw_tdo[0]),
            .atap_tdoen              (stap_tapnw_tdo_en[0]),
            .atap_vercode            (),

             //Router for TAP network
            .atap_subtapactv         (stap0_tapnw0_subtapactv),
            .stapnw_atap_subtapactvi (1'b0)
            );
    

    //---------------------------------------------------------------------------------------------//
    //----------------------------------------STAP1------------------------------------------------//
    //---------------------------------------------------------------------------------------------//
    stap   #(`include "stap1_params_overide.inc")
    i_stap1 (
            //Primary JTAG ports
            .ftap_tck                     (tapnw_stap_tck[1]),
            .ftap_tms                     (tapnw_stap_tms[1]),
            .ftap_trst_b                  (tapnw_stap_trst_b[1]),
            .powergoodrst_b               (powergoodrst_b),
            .ftap_tdi                     (tapnw_stap_tdi[1]),
            .ftap_vercode                 (tapnw_tap_vercode),
            .ftap_slvidcode               (32'h2222_2222),
            .atap_tdo                     (stap_tapnw_tdo[1]),
            .atap_tdoen                   (stap_tapnw_tdo_en[1]),
            .atap_vercode                 (stap1_tapnw1_vercode),

            //Control signals to Slave TAPNetwork
            .sftapnw_ftap_secsel          (stap1_secsel),
            .sftapnw_ftap_enabletdo       (stap1_enabletdo),
            .sftapnw_ftap_enabletap       (stap1_enabletap),

            //Primary JTAG ports to Slave TAPNetwork
            .sntapnw_ftap_tck             (),
            .sntapnw_ftap_tms             (),
            .sntapnw_ftap_trst_b          (),
            .sntapnw_ftap_tdi             (),
            .sntapnw_atap_tdo             (),
            .sntapnw_atap_tdo_en          (),

            //STAP1 Secondary JTAG (TERITIARY) Ports
            .ftapsslv_tck                 (),
            .ftapsslv_tms                 (),
            .ftapsslv_trst_b              (),
            .ftapsslv_tdi                 (),
            .atapsslv_tdo                 (),
            .atapsslv_tdoen               (),

            .sntapnw_ftap_tck2            (),
            .sntapnw_ftap_tms2            (),
            .sntapnw_ftap_trst2_b         (),
            .sntapnw_ftap_tdi2            (),
            .sntapnw_atap_tdo2            (),
            .sntapnw_atap_tdo2_en         (),

              //Router for TAP network
            .stapnw_atap_subtapactvi      (tapnw1_stap1_subtapactv),
            .atap_subtapactv              (stap1_tapnw0_subtapactv)
            );

    //---------------------------------------------------------------------------------------------//
    //--------------------------------------TAPNW1 DUT --------------------------------------------//
    //--------------------------------------LEVEL-2 (sTAP'S NW)------------------------------------//
    //--------------------------------------LINEAR NW----------------------------------------------//
    //--------------------------------------NO TERITIARY PORT--------------------------------------//

    tapnw #(
            .TAPNW_NUMBER_OF_STAPS            (TAPNW1_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT                (TAPNW1_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID                (TAPNW1_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW   (TAPNW1_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw1 (
             //STAP1 PRIMARY INTERFACE 
              .ptapnw_ftap_tck                  (tapnw0_tapnw1_tck),
              .ptapnw_ftap_tms                  (tapnw0_tapnw1_tms),
              .ptapnw_ftap_trst_b               (tapnw0_tapnw1_trst_b),
              .ptapnw_ftap_tdi                  (tapnw0_tapnw1_pri_tdo),
              .ntapnw_atap_tdo                  (tapnw1_mtap_pri_tdo),
              .ntapnw_atap_tdo_en               (tapnw1_mtap_pri_tdoen),

              .ftapnw_ftap_secsel               (stap1_secsel),
              .ftapnw_ftap_enabletdo            (stap1_enabletdo),
              .ftapnw_ftap_enabletap            (stap1_enabletap),

              .powergoodrst_b                   (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck                  (tapnw1_stap_tck),
              .ftapnw_ftap_tms                  (tapnw1_stap_tms),
              .ftapnw_ftap_trst_b               (tapnw1_stap_trst_b),
              .ftapnw_ftap_tdi                  (tapnw1_stap_tdi),
              .atapnw_atap_tdo                  (stap_tapnw1_tdo),
              .atapnw_atap_tdo_en               (stap_tapnw1_tdo_en),

              //STAP1 SECONDARY INTERFACE, tdo2 will goto mTAP.
              .ptapnw_ftap_tck2                 (tapnw0_tapnw1_tck2),
              .ptapnw_ftap_tms2                 (tapnw0_tapnw1_tms2),
              .ptapnw_ftap_trst2_b              (tapnw0_tapnw1_trst_b2),
              .ptapnw_ftap_tdi2                 (tapnw0_tapnw1_sec_tdi),
              .ntapnw_atap_tdo2_en              (tapnw1_mtap_sec_tdoen),
              .ntapnw_atap_tdo2                 (tapnw1_mtap_sec_tdo),

              //LINEAR TAP NETWORK INTERFACE
              //PRIMARY PORT -- passthrough signals for tck, tms and trst_b
              .ntapnw_ftap_tck                  (),
              .ntapnw_ftap_tms                  (),
              .ntapnw_ftap_trst_b               (),
              //SECONDARY JTAG PORT -- passthrough signals for tck2, tms2 and trst_b2
              .ntapnw_ftap_tck2                 (),
              .ntapnw_ftap_tms2                 (),
              .ntapnw_ftap_trst2_b              (),
              
              //Sub Tap Control logic
              .atapnw_atap_subtapactvi          ({stap3_tapnw1_subtapactv,stap2_tapnw1_subtapactv}),
              .atapnw_atap_subtapactvo          (tapnw1_stap1_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei             (stap1_tapnw1_vercode),
              .ftapnw_ftap_vercodeo             (tapnw1_tap_vercode)
             );
                 //-------------------------------------------------------------------------//
                  //------------------------------STAP2--------------------------------------//
                  //-------------------------------------------------------------------------//
                  stap   #(`include "stap2_params_overide.inc")
                  i_stap2 (
                          //Primary JTAG ports
                          .ftap_tck                (tapnw1_stap_tck[0]),
                          .ftap_tms                (tapnw1_stap_tms[0]),
                          .ftap_trst_b             (tapnw1_stap_trst_b[0]),
                          .powergoodrst_b          (powergoodrst_b),
                          .ftap_tdi                (tapnw1_stap_tdi[0]),
                          .ftap_vercode            (tapnw1_tap_vercode),
                          .ftap_slvidcode          (32'h3333_3333),
                          .atap_tdo                (stap_tapnw1_tdo[0]),
                          .atap_tdoen              (stap_tapnw1_tdo_en[0]),
                          .atap_vercode            (),

                          //Router for TAP network
                          .atap_subtapactv         (stap2_tapnw1_subtapactv),
                          .stapnw_atap_subtapactvi (1'b0)
                          );

                  //-------------------------------------------------------------------------//
                  //------------------------------STAP3--------------------------------------//
                  //-------------------------------------------------------------------------//
                  stap   #(`include "stap3_params_overide.inc")
                  i_stap3 (
                          //Primary JTAG ports
                          .ftap_tck                (tapnw1_stap_tck[1]),
                          .ftap_tms                (tapnw1_stap_tms[1]),
                          .ftap_trst_b             (tapnw1_stap_trst_b[1]),
                          .powergoodrst_b          (powergoodrst_b),
                          .ftap_tdi                (tapnw1_stap_tdi[1]),
                          .ftap_vercode            (tapnw1_tap_vercode),
                          .ftap_slvidcode          (32'h4444_4444),
                          .atap_tdo                (stap_tapnw1_tdo[1]),
                          .atap_tdoen              (stap_tapnw1_tdo_en[1]),
                          .atap_vercode            (),

                          //Router for TAP network
                          .atap_subtapactv         (stap3_tapnw1_subtapactv),
                          .stapnw_atap_subtapactvi (1'b0)
                          );

endmodule
