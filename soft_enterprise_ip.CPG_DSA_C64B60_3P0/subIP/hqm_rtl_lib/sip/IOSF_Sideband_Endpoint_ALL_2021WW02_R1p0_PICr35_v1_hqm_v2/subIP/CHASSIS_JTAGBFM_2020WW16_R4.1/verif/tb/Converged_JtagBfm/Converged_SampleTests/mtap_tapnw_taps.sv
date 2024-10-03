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
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
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

`include "tb_param.inc"

`include "mtap0_params_include.inc"

`include "STAP0_sTAP_soc_param_values.inc"
`include "STAP1_sTAP_soc_param_values.inc"
`include "STAP2_sTAP_soc_param_values.inc"
`include "STAP3_sTAP_soc_param_values.inc"
`include "STAP4_sTAP_soc_param_values.inc"
`include "STAP5_sTAP_soc_param_values.inc"
`include "STAP6_sTAP_soc_param_values.inc"
`include "STAP7_sTAP_soc_param_values.inc"
`include "STAP8_sTAP_soc_param_values.inc"
`include "STAP9_sTAP_soc_param_values.inc"
`include "STAP10_sTAP_soc_param_values.inc"
`include "STAP11_sTAP_soc_param_values.inc"
`include "STAP12_sTAP_soc_param_values.inc"
`include "STAP13_sTAP_soc_param_values.inc"
`include "STAP14_sTAP_soc_param_values.inc"
`include "STAP15_sTAP_soc_param_values.inc"
`include "STAP16_sTAP_soc_param_values.inc"
`include "STAP17_sTAP_soc_param_values.inc"
`include "STAP18_sTAP_soc_param_values.inc"
`include "STAP19_sTAP_soc_param_values.inc"
`include "STAP20_sTAP_soc_param_values.inc"
`include "STAP21_sTAP_soc_param_values.inc"
`include "STAP22_sTAP_soc_param_values.inc"
`include "STAP23_sTAP_soc_param_values.inc"
`include "STAP24_sTAP_soc_param_values.inc"
`include "STAP25_sTAP_soc_param_values.inc"
`include "STAP26_sTAP_soc_param_values.inc"
`include "STAP27_sTAP_soc_param_values.inc"
`include "STAP28_sTAP_soc_param_values.inc"
`include "STAP29_sTAP_soc_param_values.inc"

`include "tapnw0_params_include.inc"
`include "tapnw1_params_include.inc"
`include "tapnw2_params_include.inc"
`include "tapnw3_params_include.inc"
`include "tapnw4_params_include.inc"
`include "tapnw5_params_include.inc"
`include "tapnw6_params_include.inc"
`include "tapnw7_params_include.inc"
`include "tapnw8_params_include.inc"
`include "tapnw9_params_include.inc"
`include "tapnw10_params_include.inc"

`include "stap0_params_include.inc"
`include "stap1_params_include.inc"
`include "stap2_params_include.inc"
`include "stap3_params_include.inc"

`include "stap9_params_include.inc"
`include "stap10_params_include.inc"

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

                        //Teritiary1 JTAG PORT
                        tck3,
                        tms3,
                        trst_b3,
                        tdi3,
                        tdo3,
                        tdo3_en,

                        //Teritiary2 JTAG PORT
                        tck4,
                        tms4,
                        trst_b4,
                        tdi4,
                        tdo4,
                        tdo4_en,

                        //From SoC
                        powergoodrst_b
                       );

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

    //Teritiary JTAG PORT
    input  tck4;
    input  tms4;
    input  trst_b4;
    input  tdi4;
    output tdo4;
    output tdo4_en;

    //From SoC
    input powergoodrst_b;

    //----------------------------------------------------------------------
    // logics & Regs
    //----------------------------------------------------------------------
    logic                                  ftap_tck;
    logic                                  ftap_tms;
    logic                                  ftap_trst_b;
    logic                                  ftap_tdi;
    logic                                  atap_tdo;
    logic                                  atap_tdoen;
    logic [2:0]                            atap_tapulock;

    //----------------------------------------------------------------------
    //Based on Number of Staps in the Network, port width is hardocoded.
    //----------------------------------------------------------------------
    logic [(MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK  - 1):0] atap_secsel;
    logic [(MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK  - 1):0] atap_enabletdo;
    logic [(MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK  - 1):0] atap_enabletap;

    //----------------------------------------------------------------------
    //From TAPNW to TAP's
    //----------------------------------------------------------------------
    //VERCODE
    logic [3:0] tapnw_tap_vercode;

    //----------------------------------------------------------------------
    //Primary port connection singals - From STAP1 to TAPNW1
    //----------------------------------------------------------------------
    logic stap1_tapnw1_pri_clk;
    logic stap1_tapnw1_pri_tms;
    logic stap1_tapnw1_pri_trst_b;
    logic stap1_tapnw1_pri_tdi;
    logic tapnw1_stap1_pri_tdo;
    logic tapnw1_stap1_pri_tdoen;

    //----------------------------------------------------------------------
    //Primary port connection singals - From STAP2 to TAPNW2
    //----------------------------------------------------------------------
    logic stap2_tapnw2_pri_clk;
    logic stap2_tapnw2_pri_tms;
    logic stap2_tapnw2_pri_trst_b;
    logic stap2_tapnw2_pri_tdi;
    logic tapnw2_stap2_pri_tdo;
    logic tapnw2_stap2_pri_tdoen;

    //----------------------------------------------------------------------
    //Primary port connection singals - From STAP4 to TAPNW3
    //----------------------------------------------------------------------
    logic stap4_tapnw3_pri_clk;
    logic stap4_tapnw3_pri_tms;
    logic stap4_tapnw3_pri_trst_b;
    logic stap4_tapnw3_pri_tdi;
    logic tapnw3_stap4_pri_tdo;
    logic tapnw3_stap4_pri_tdoen;

    //----------------------------------------------------------------------
    //Primary port connection singals - From STAP8 to TAPNW4
    //----------------------------------------------------------------------
    logic stap8_tapnw4_pri_clk;
    logic stap8_tapnw4_pri_tms;
    logic stap8_tapnw4_pri_trst_b;
    logic stap8_tapnw4_pri_tdi;
    logic tapnw4_stap8_pri_tdo;
    logic tapnw4_stap8_pri_tdoen;

    //----------------------------------------------------------------------
    //Primary port connection singals - From STAP13 to TAPNW5
    //----------------------------------------------------------------------
    logic stap13_tapnw5_pri_clk;
    logic stap13_tapnw5_pri_tms;
    logic stap13_tapnw5_pri_trst_b;
    logic stap13_tapnw5_pri_tdi;
    logic tapnw5_stap13_pri_tdo;
    logic tapnw5_stap13_pri_tdoen;

    //----------------------------------------------------------------------
    //Primary port connection singals - From STAP14 to TAPNW6
    //----------------------------------------------------------------------
    logic stap14_tapnw6_pri_clk;
    logic stap14_tapnw6_pri_tms;
    logic stap14_tapnw6_pri_trst_b;
    logic stap14_tapnw6_pri_tdi;
    logic tapnw6_stap14_pri_tdo;
    logic tapnw6_stap14_pri_tdoen;

    //----------------------------------------------------------------------
    //Primary port connection singals - From STAP20 to TAPNW8
    //----------------------------------------------------------------------
    logic stap20_tapnw8_pri_clk;
    logic stap20_tapnw8_pri_tms;
    logic stap20_tapnw8_pri_trst_b;
    logic stap20_tapnw8_pri_tdi;
    logic tapnw8_stap20_pri_tdo;
    logic tapnw8_stap20_pri_tdoen;

    //----------------------------------------------------------------------
    //Secondary port connection singals - From STAP14 to TAPNW6
    //----------------------------------------------------------------------
    logic stap1_tapnw1_sec_clk;
    logic stap1_tapnw1_sec_tms;
    logic stap1_tapnw1_sec_trst_b;
    logic stap1_tapnw1_sec_tdi;
    logic tapnw1_stap1_sec_tdo;
    logic tapnw1_stap1_sec_tdoen;

    //----------------------------------------------------------------------
    //Secondary port connection singals - From STAP13 to TAPNW5
    //----------------------------------------------------------------------
    logic stap13_tapnw5_sec_clk;
    logic stap13_tapnw5_sec_tms;
    logic stap13_tapnw5_sec_trst_b;
    logic stap13_tapnw5_sec_tdi;
    logic tapnw5_stap13_sec_tdoen;
    logic tapnw5_stap13_sec_tdo;

    //VERCODE
    logic [3:0] stap1_tapnw1_vercode;
    logic [3:0] tapnw1_tap_vercode;

    //----------------------------------------------------------------------
    //STAP1 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW1_NUMBER_OF_STAPS  - 1):0] stap1_secsel;
    logic [(TAPNW1_NUMBER_OF_STAPS  - 1):0] stap1_enabletdo;
    logic [(TAPNW1_NUMBER_OF_STAPS  - 1):0] stap1_enabletap;

    //----------------------------------------------------------------------
    //STAP2 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW2_NUMBER_OF_STAPS  - 1):0] stap2_secsel;
    logic [(TAPNW2_NUMBER_OF_STAPS  - 1):0] stap2_enabletdo;
    logic [(TAPNW2_NUMBER_OF_STAPS  - 1):0] stap2_enabletap;

    //----------------------------------------------------------------------
    //STAP2 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW3_NUMBER_OF_STAPS  - 1):0] stap4_secsel;
    logic [(TAPNW3_NUMBER_OF_STAPS  - 1):0] stap4_enabletdo;
    logic [(TAPNW3_NUMBER_OF_STAPS  - 1):0] stap4_enabletap;

    //----------------------------------------------------------------------
    //STAP2 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW4_NUMBER_OF_STAPS  - 1):0] stap8_secsel;
    logic [(TAPNW4_NUMBER_OF_STAPS  - 1):0] stap8_enabletdo;
    logic [(TAPNW4_NUMBER_OF_STAPS  - 1):0] stap8_enabletap;

    //----------------------------------------------------------------------
    //STAP2 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW5_NUMBER_OF_STAPS  - 1):0] stap13_secsel;
    logic [(TAPNW5_NUMBER_OF_STAPS  - 1):0] stap13_enabletdo;
    logic [(TAPNW5_NUMBER_OF_STAPS  - 1):0] stap13_enabletap;

    //----------------------------------------------------------------------
    //STAP2 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW6_NUMBER_OF_STAPS  - 1):0] stap14_secsel;
    logic [(TAPNW6_NUMBER_OF_STAPS  - 1):0] stap14_enabletdo;
    logic [(TAPNW6_NUMBER_OF_STAPS  - 1):0] stap14_enabletap;

    //----------------------------------------------------------------------
    //STAP2 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW8_NUMBER_OF_STAPS  - 1):0] stap20_secsel;
    logic [(TAPNW8_NUMBER_OF_STAPS  - 1):0] stap20_enabletdo;
    logic [(TAPNW8_NUMBER_OF_STAPS  - 1):0] stap20_enabletap;

    //----------------------------------------------------------------------
    //STAP2 - Secondary select and TAP enable signals for Nodes
    //----------------------------------------------------------------------
    logic [(TAPNW9_NUMBER_OF_STAPS  - 1):0] stap24_secsel;
    logic [(TAPNW9_NUMBER_OF_STAPS  - 1):0] stap24_enabletdo;
    logic [(TAPNW9_NUMBER_OF_STAPS  - 1):0] stap24_enabletap;

    //----------------------------------------------------------------------
    //TAPNW0 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw0_stap_tck;
    logic [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw0_stap_tms;
    logic [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw0_stap_trst_b;
    logic [(TAPNW0_NUMBER_OF_STAPS - 1):0] tapnw0_stap_tdi;
    logic [(TAPNW0_NUMBER_OF_STAPS - 1):0] stap_tapnw0_tdo;
    logic [(TAPNW0_NUMBER_OF_STAPS - 1):0] stap_tapnw0_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW1 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW1_NUMBER_OF_STAPS - 1):0] tapnw1_stap_tck;
    logic [(TAPNW1_NUMBER_OF_STAPS - 1):0] tapnw1_stap_tms;
    logic [(TAPNW1_NUMBER_OF_STAPS - 1):0] tapnw1_stap_trst_b;
    logic [(TAPNW1_NUMBER_OF_STAPS - 1):0] tapnw1_stap_tdi;
    logic [(TAPNW1_NUMBER_OF_STAPS - 1):0] stap_tapnw1_tdo;
    logic [(TAPNW1_NUMBER_OF_STAPS - 1):0] stap_tapnw1_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW2 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW2_NUMBER_OF_STAPS - 1):0] tapnw2_stap_tck;
    logic [(TAPNW2_NUMBER_OF_STAPS - 1):0] tapnw2_stap_tms;
    logic [(TAPNW2_NUMBER_OF_STAPS - 1):0] tapnw2_stap_trst_b;
    logic [(TAPNW2_NUMBER_OF_STAPS - 1):0] tapnw2_stap_tdi;
    logic [(TAPNW2_NUMBER_OF_STAPS - 1):0] stap_tapnw2_tdo;
    logic [(TAPNW2_NUMBER_OF_STAPS - 1):0] stap_tapnw2_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW3 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW3_NUMBER_OF_STAPS - 1):0] tapnw3_stap_tck;
    logic [(TAPNW3_NUMBER_OF_STAPS - 1):0] tapnw3_stap_tms;
    logic [(TAPNW3_NUMBER_OF_STAPS - 1):0] tapnw3_stap_trst_b;
    logic [(TAPNW3_NUMBER_OF_STAPS - 1):0] tapnw3_stap_tdi;
    logic [(TAPNW3_NUMBER_OF_STAPS - 1):0] stap_tapnw3_tdo;
    logic [(TAPNW3_NUMBER_OF_STAPS - 1):0] stap_tapnw3_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW4 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW4_NUMBER_OF_STAPS - 1):0] tapnw4_stap_tck;
    logic [(TAPNW4_NUMBER_OF_STAPS - 1):0] tapnw4_stap_tms;
    logic [(TAPNW4_NUMBER_OF_STAPS - 1):0] tapnw4_stap_trst_b;
    logic [(TAPNW4_NUMBER_OF_STAPS - 1):0] tapnw4_stap_tdi;
    logic [(TAPNW4_NUMBER_OF_STAPS - 1):0] stap_tapnw4_tdo;
    logic [(TAPNW4_NUMBER_OF_STAPS - 1):0] stap_tapnw4_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW5 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW5_NUMBER_OF_STAPS - 1):0] tapnw5_stap_tck;
    logic [(TAPNW5_NUMBER_OF_STAPS - 1):0] tapnw5_stap_tms;
    logic [(TAPNW5_NUMBER_OF_STAPS - 1):0] tapnw5_stap_trst_b;
    logic [(TAPNW5_NUMBER_OF_STAPS - 1):0] tapnw5_stap_tdi;
    logic [(TAPNW5_NUMBER_OF_STAPS - 1):0] stap_tapnw5_tdo;
    logic [(TAPNW5_NUMBER_OF_STAPS - 1):0] stap_tapnw5_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW6 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW6_NUMBER_OF_STAPS - 1):0] tapnw6_stap_tck;
    logic [(TAPNW6_NUMBER_OF_STAPS - 1):0] tapnw6_stap_tms;
    logic [(TAPNW6_NUMBER_OF_STAPS - 1):0] tapnw6_stap_trst_b;
    logic [(TAPNW6_NUMBER_OF_STAPS - 1):0] tapnw6_stap_tdi;
    logic [(TAPNW6_NUMBER_OF_STAPS - 1):0] stap_tapnw6_tdo;
    logic [(TAPNW6_NUMBER_OF_STAPS - 1):0] stap_tapnw6_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW7 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW7_NUMBER_OF_STAPS - 1):0] tapnw7_stap_tck;
    logic [(TAPNW7_NUMBER_OF_STAPS - 1):0] tapnw7_stap_tms;
    logic [(TAPNW7_NUMBER_OF_STAPS - 1):0] tapnw7_stap_trst_b;
    logic [(TAPNW7_NUMBER_OF_STAPS - 1):0] tapnw7_stap_tdi;
    logic [(TAPNW7_NUMBER_OF_STAPS - 1):0] stap_tapnw7_tdo;
    logic [(TAPNW7_NUMBER_OF_STAPS - 1):0] stap_tapnw7_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW8 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW8_NUMBER_OF_STAPS - 1):0] tapnw8_stap_tck;
    logic [(TAPNW8_NUMBER_OF_STAPS - 1):0] tapnw8_stap_tms;
    logic [(TAPNW8_NUMBER_OF_STAPS - 1):0] tapnw8_stap_trst_b;
    logic [(TAPNW8_NUMBER_OF_STAPS - 1):0] tapnw8_stap_tdi;
    logic [(TAPNW8_NUMBER_OF_STAPS - 1):0] stap_tapnw8_tdo;
    logic [(TAPNW8_NUMBER_OF_STAPS - 1):0] stap_tapnw8_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW9 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW9_NUMBER_OF_STAPS - 1):0] tapnw9_stap_tck;
    logic [(TAPNW9_NUMBER_OF_STAPS - 1):0] tapnw9_stap_tms;
    logic [(TAPNW9_NUMBER_OF_STAPS - 1):0] tapnw9_stap_trst_b;
    logic [(TAPNW9_NUMBER_OF_STAPS - 1):0] tapnw9_stap_tdi;
    logic [(TAPNW9_NUMBER_OF_STAPS - 1):0] stap_tapnw9_tdo;
    logic [(TAPNW9_NUMBER_OF_STAPS - 1):0] stap_tapnw9_tdo_en;

    //----------------------------------------------------------------------
    //TAPNW10 Signals
    //----------------------------------------------------------------------
    logic [(TAPNW10_NUMBER_OF_STAPS - 1):0] tapnw10_stap_tck;
    logic [(TAPNW10_NUMBER_OF_STAPS - 1):0] tapnw10_stap_tms;
    logic [(TAPNW10_NUMBER_OF_STAPS - 1):0] tapnw10_stap_trst_b;
    logic [(TAPNW10_NUMBER_OF_STAPS - 1):0] tapnw10_stap_tdi;
    logic [(TAPNW10_NUMBER_OF_STAPS - 1):0] stap_tapnw10_tdo;
    logic [(TAPNW10_NUMBER_OF_STAPS - 1):0] stap_tapnw10_tdo_en;
    logic tapnw7_tapnw10_tdo;

    //----------------------------------------------------------------------
    //From MTAP to TAPNW
    //----------------------------------------------------------------------
    logic mtap_tapnw0_pri_clk;
    logic mtap_tapnw0_pri_tms;
    logic mtap_tapnw0_pri_trst_b;
    logic mtap_tapnw0_pri_tdi;
    logic tapnw0_prim_port_tdo;
    logic tapnw0_prim_port_tdoen;

    logic tapnw7_prim_port_tdoen;

    logic tapnw10_prim_port_tdo;
    logic tapnw10_prim_port_tdoen;

    logic mtap_tapnw_sec_clk;
    logic mtap_tapnw_sec_tms;
    logic mtap_tapnw_sec_trst_b;
    logic mtap_tapnw_sec_tdi;
    logic tapnw_sec_port_tdo;
    logic tapnw_sec_port_tdoen;

    //VERCODE
    logic [3:0] mtap_tapnw_vercode;

    //-----------------------------
    //Subtapactive logic connection
    //-----------------------------
    logic stap0_tapnw0_subtapactv;
    logic stap1_tapnw0_subtapactv;

    logic stap2_tapnw1_subtapactv;
    logic stap8_tapnw1_subtapactv;

    logic stap3_tapnw2_subtapactv;
    logic stap4_tapnw2_subtapactv;
    logic stap7_tapnw2_subtapactv;

    logic stap5_tapnw3_subtapactv;
    logic stap6_tapnw3_subtapactv;

    logic stap9_tapnw4_subtapactv;
    logic stap10_tapnw4_subtapactv;
    logic stap11_tapnw4_subtapactv;
    logic stap12_tapnw4_subtapactv;
    logic stap13_tapnw4_subtapactv;

    logic stap14_tapnw5_subtapactv;
    logic stap19_tapnw5_subtapactv;

    logic stap15_tapnw6_subtapactv;
    logic stap16_tapnw6_subtapactv;
    logic stap17_tapnw6_subtapactv;
    logic stap18_tapnw6_subtapactv;

    logic tapnw0_mtap0_subtapactv;
    logic tapnw1_stap1_subtapactv;
    logic tapnw2_stap3_subtapactv;
    logic tapnw4_stap2_subtapactv;

    logic tapnw0_cltap_subtapactv;

    //------------------------------------------------------
    // Connetcions between STAP19 and WTAP0
    //------------------------------------------------------
    logic wtap_sn_fwtap_wrck;
    logic wtap_sn_fwtap_wrst_b;
    logic wtap_atap_rti;
    logic wtap_atap_wtapnw_selectwir;
    logic wtap_atap_capturewr;
    logic wtap_atap_shiftwr;
    logic wtap_atap_updatewr;
    logic [1:0] wtap_fwtapnw_wsi;
    logic [1:0] wtap_awtapnw_wso;


    //------------------------------------------------------
    //Connetcions to Primary Port.
    //------------------------------------------------------
    assign ftap_tck    = tck;
    assign ftap_tms    = tms;
    assign ftap_trst_b = trst_b;
    assign ftap_tdi    = tdi;
    assign tdo         = atap_tdo;

    //------------------------------------------------------
    //Connetcions to TDR Loopback in CLTAP
    //------------------------------------------------------
    logic [63:0] cltap_tdr_lb;

    //---------------------------------------------------------------------//
    //---------------------------MTAP0-------------------------------------//
    //---------------------------------------------------------------------//
    cltapc #(`include "mtap0_params_overide.inc")
    i_mtap0 (
             // Primary Jtag Ports
             .atappris_tck    (ftap_tck),
             .atappris_tms    (ftap_tms),
             .atappris_trst_b (ftap_trst_b),
             .powergoodrst_b  (powergoodrst_b),
             .atappris_tdi    (ftap_tdi),
             .ftap_vercode    (vercode),
             .ftap_idcode     (32'hC0DE_FF01),
             .ftappris_tdo    (atap_tdo),
             .ftappris_tdoen  (),

             // TDR Loopback in CLTAP
             .tdr_data_out    (cltap_tdr_lb),
             .tdr_data_in     (cltap_tdr_lb),

             // Control signals to Slave TAPNetwork
             .cftapnw_ftap_secsel    (atap_secsel),
             .cftapnw_ftap_enabletdo (atap_enabletdo),
             .cftapnw_ftap_enabletap (atap_enabletap),

             // Primary JTAG ports to Slave TAPNetwork
             .cntapnw_ftap_tck    (mtap_tapnw0_pri_clk),
             .cntapnw_ftap_tms    (mtap_tapnw0_pri_tms),
             .cntapnw_ftap_trst_b (mtap_tapnw0_pri_trst_b),
             .cntapnw_ftap_tdi    (mtap_tapnw0_pri_tdi),
//             .cntapnw_atap_tdo    (tapnw0_prim_port_tdo),
//             .cntapnw_atap_tdo_en ({1'b0,tapnw0_prim_port_tdoen}),
             .cntapnw_atap_tdo    (tapnw10_prim_port_tdo),
             .cntapnw_atap_tdo_en ({3'b0,tapnw10_prim_port_tdoen,tapnw7_prim_port_tdoen,tapnw0_prim_port_tdoen}),

             // Secondary JTAG ports
             .atapsecs_tck    (tck2),
             .atapsecs_tms    (tms2),
             .atapsecs_trst_b (trst_b2),
             .atapsecs_tdi    (tdi2),
             .ftapsecs_tdo    (tdo2),
             .ftapsecs_tdoen  (tdo2_en),

             // Linear Network - Indicates if a Subnetwork is active or not. Tie it HIGH.
             .ctapnw_atap_subtapactvi ({1'b0,tapnw0_cltap_subtapactv}),

             //Secondary JTAG ports to Slave TAPNetwork
             .cntapnw_ftap_tck2    (mtap_tapnw0_sec_clk),
             .cntapnw_ftap_tms2    (mtap_tapnw0_sec_tms),
             .cntapnw_ftap_trst2_b (mtap_tapnw0_sec_trst_b),
             .cntapnw_ftap_tdi2    (mtap_tapnw0_sec_tdi),
             .cntapnw_atap_tdo2    (tapnw10_mtap_sec_tdo),
             .cntapnw_atap_tdo2_en ({1'b0,tapnw_sec_port_tdoen})
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW0-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW0_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW0_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW0_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW0_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw0 (
              //MTAP INTERFACE
              .ptapnw_ftap_tck    (mtap_tapnw0_pri_clk),
              .ptapnw_ftap_tms    (mtap_tapnw0_pri_tms),
              .ptapnw_ftap_trst_b (mtap_tapnw0_pri_trst_b),
              .ptapnw_ftap_tdi    (mtap_tapnw0_pri_tdi),
//              .ntapnw_atap_tdo    (tapnw0_prim_port_tdo),
              .ntapnw_atap_tdo    (tapnw0_tapnw7_tdo),
              .ntapnw_atap_tdo_en (tapnw0_prim_port_tdoen),

              .ftapnw_ftap_secsel    (atap_secsel[1:0]),
              .ftapnw_ftap_enabletdo (atap_enabletdo[1:0]),
              .ftapnw_ftap_enabletap (atap_enabletap[1:0]),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAP INTERFACE
              .ftapnw_ftap_tck    (tapnw0_stap_tck),
              .ftapnw_ftap_tms    (tapnw0_stap_tms),
              .ftapnw_ftap_trst_b (tapnw0_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw0_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw0_tdo),
              .atapnw_atap_tdo_en (stap_tapnw0_tdo_en),

              //MTAP SECONDARY INTERFACE
              .ptapnw_ftap_tck2    (mtap_tapnw0_sec_clk),
              .ptapnw_ftap_tms2    (mtap_tapnw0_sec_tms),
              .ptapnw_ftap_trst2_b (mtap_tapnw0_sec_trst_b),
              .ptapnw_ftap_tdi2    (mtap_tapnw0_sec_tdi),
              .ntapnw_atap_tdo2_en (),
              .ntapnw_atap_tdo2    (tapnw0_tapnw7_sec_tdo),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvo (tapnw0_cltap_subtapactv),
              .atapnw_atap_subtapactvi ({stap1_tapnw0_subtapactv,
                                         stap0_tapnw0_subtapactv}),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP0--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP0_sTAP_soc_param_overide.inc")
    i_stap0 (
             //Primary JTAG ports
             .ftap_tck                (tapnw0_stap_tck[0]),
             .ftap_tms                (tapnw0_stap_tms[0]),
             .ftap_trst_b             (tapnw0_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw0_stap_tdi[0]),
             .ftap_vercode            (tapnw0_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_0001),
             .atap_tdo                (stap_tapnw0_tdo[0]),
             .atap_tdoen              (stap_tapnw0_tdo_en[0]),
             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap0_tapnw0_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP1--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP1_sTAP_soc_param_overide.inc")
    i_stap1 (
             //Primary JTAG ports
             .ftap_tck       (tapnw0_stap_tck[1]),
             .ftap_tms       (tapnw0_stap_tms[1]),
             .ftap_trst_b    (tapnw0_stap_trst_b[1]),
             .powergoodrst_b (powergoodrst_b),
             .ftap_tdi       (tapnw0_stap_tdi[1]),
             .ftap_vercode   (tapnw_tap_vercode),
             .ftap_slvidcode (32'hC0DE_0101),
             .atap_tdo       (stap_tapnw0_tdo[1]),
             .atap_tdoen     (stap_tapnw0_tdo_en[1]),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel    (stap1_secsel),
             .sftapnw_ftap_enabletdo (stap1_enabletdo),
             .sftapnw_ftap_enabletap (stap1_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap1_tapnw1_pri_clk),
             .sntapnw_ftap_tms    (stap1_tapnw1_pri_tms),
             .sntapnw_ftap_trst_b (stap1_tapnw1_pri_trst_b),
             .sntapnw_ftap_tdi    (stap1_tapnw1_pri_tdi),
             .sntapnw_atap_tdo    (tapnw1_stap1_pri_tdo),
             .sntapnw_atap_tdo_en ({1'b0,tapnw1_stap1_pri_tdoen}),

             //Tertiary1 ports of SoC
             .ftapsslv_tck        (tck3),
             .ftapsslv_tms        (tms3),
             .ftapsslv_trst_b     (trst_b3),
             .ftapsslv_tdi        (tdi3), 
             .atapsslv_tdo        (tdo3),
             .atapsslv_tdoen      (tdo3_en),

             //STAP1 SECONDARY (TERITIARY) INTERFACE OF CONTROLLING TAP
             .sntapnw_ftap_tck2        (stap1_tapnw1_sec_clk),
             .sntapnw_ftap_tms2        (stap1_tapnw1_sec_tms),
             .sntapnw_ftap_trst2_b     (stap1_tapnw1_sec_trst_b),
             .sntapnw_ftap_tdi2        (stap1_tapnw1_sec_tdi),
             .sntapnw_atap_tdo2        (tapnw1_stap1_sec_tdo),
             .sntapnw_atap_tdo2_en     (tapnw1_stap1_sec_tdoen),

             //Router for TAP network
             .stapnw_atap_subtapactvi ({1'b0,tapnw1_stap1_subtapactv}),
             .atap_subtapactv         (stap1_tapnw0_subtapactv)
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW1-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW1_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW1_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW1_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW1_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw1 (
              //STAP1 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap1_tapnw1_pri_clk),
              .ptapnw_ftap_tms    (stap1_tapnw1_pri_tms),
              .ptapnw_ftap_trst_b (stap1_tapnw1_pri_trst_b),
              .ptapnw_ftap_tdi    (stap1_tapnw1_pri_tdi),
              .ntapnw_atap_tdo    (tapnw1_stap1_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw1_stap1_pri_tdoen),

              .ftapnw_ftap_secsel    (stap1_secsel),
              .ftapnw_ftap_enabletdo (stap1_enabletdo),
              .ftapnw_ftap_enabletap (stap1_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw1_stap_tck),
              .ftapnw_ftap_tms    (tapnw1_stap_tms),
              .ftapnw_ftap_trst_b (tapnw1_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw1_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw1_tdo),
              .atapnw_atap_tdo_en (stap_tapnw1_tdo_en),

              //STAP1 SECONDARY (TERITIARY) INTERFACE OF CONTROLLING TAP
              .ptapnw_ftap_tck2    (stap1_tapnw1_sec_clk),
              .ptapnw_ftap_tms2    (stap1_tapnw1_sec_tms),
              .ptapnw_ftap_trst2_b (stap1_tapnw1_sec_trst_b),
              .ptapnw_ftap_tdi2    (stap1_tapnw1_sec_tdi),
              .ntapnw_atap_tdo2_en (tapnw1_stap1_sec_tdoen),
              .ntapnw_atap_tdo2    (tapnw1_stap1_sec_tdo),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap8_tapnw1_subtapactv,
                                         stap2_tapnw1_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw1_stap1_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP2--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP2_sTAP_soc_param_overide.inc")
    i_stap2 (
             //Primary JTAG ports
             .ftap_tck       (tapnw1_stap_tck[0]),
             .ftap_tms       (tapnw1_stap_tms[0]),
             .ftap_trst_b    (tapnw1_stap_trst_b[0]),
             .powergoodrst_b (powergoodrst_b),
             .ftap_tdi       (tapnw1_stap_tdi[0]),
             .ftap_vercode   (tapnw1_tap_vercode),
             .ftap_slvidcode (32'hC0DE_0201),
             .atap_tdo       (stap_tapnw1_tdo[0]),
             .atap_tdoen     (stap_tapnw1_tdo_en[0]),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel    (stap2_secsel),
             .sftapnw_ftap_enabletdo (stap2_enabletdo),
             .sftapnw_ftap_enabletap (stap2_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap2_tapnw2_pri_clk),
             .sntapnw_ftap_tms    (stap2_tapnw2_pri_tms),
             .sntapnw_ftap_trst_b (stap2_tapnw2_pri_trst_b),
             .sntapnw_ftap_tdi    (stap2_tapnw2_pri_tdi),
             .sntapnw_atap_tdo    (tapnw2_stap2_pri_tdo),
             .sntapnw_atap_tdo_en ({1'b0,tapnw2_stap2_pri_tdoen}),

             //Router for TAP network
             .stapnw_atap_subtapactvi ({1'b0,tapnw2_stap2_subtapactv}),
             .atap_subtapactv         (stap2_tapnw1_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP3--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP3_sTAP_soc_param_overide.inc")
    i_stap3 (
             //Primary JTAG ports
             .ftap_tck                (tapnw2_stap_tck[0]),
             .ftap_tms                (tapnw2_stap_tms[0]),
             .ftap_trst_b             (tapnw2_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw2_stap_tdi[0]),
             .ftap_vercode            (tapnw2_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_0301),
             .atap_tdo                (stap_tapnw2_tdo[0]),
             .atap_tdoen              (stap_tapnw2_tdo_en[0]),
             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap3_tapnw2_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP4--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP4_sTAP_soc_param_overide.inc")
    i_stap4 (
             //Primary JTAG ports
             .ftap_tck       (tapnw2_stap_tck[1]),
             .ftap_tms       (tapnw2_stap_tms[1]),
             .ftap_trst_b    (tapnw2_stap_trst_b[1]),
             .powergoodrst_b (powergoodrst_b),
             .ftap_tdi       (tapnw2_stap_tdi[1]),
             .ftap_vercode   (tapnw2_tap_vercode),
             .ftap_slvidcode (32'hC0DE_0401),
             .atap_tdo       (stap_tapnw2_tdo[1]),
             .atap_tdoen     (stap_tapnw2_tdo_en[1]),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel    (stap4_secsel),
             .sftapnw_ftap_enabletdo (stap4_enabletdo),
             .sftapnw_ftap_enabletap (stap4_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap4_tapnw3_pri_clk),
             .sntapnw_ftap_tms    (stap4_tapnw3_pri_tms),
             .sntapnw_ftap_trst_b (stap4_tapnw3_pri_trst_b),
             .sntapnw_ftap_tdi    (stap4_tapnw3_pri_tdi),
             .sntapnw_atap_tdo    (tapnw3_stap4_pri_tdo),
             .sntapnw_atap_tdo_en ({1'b0,tapnw3_stap4_pri_tdoen}),

             //Router for TAP network
             .stapnw_atap_subtapactvi ({1'b0,tapnw3_stap4_subtapactv}),
             .atap_subtapactv         (stap4_tapnw2_subtapactv)
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW2-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW2_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW2_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW2_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW2_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw2 (
              //STAP1 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap2_tapnw2_pri_clk),
              .ptapnw_ftap_tms    (stap2_tapnw2_pri_tms),
              .ptapnw_ftap_trst_b (stap2_tapnw2_pri_trst_b),
              .ptapnw_ftap_tdi    (stap2_tapnw2_pri_tdi),
              .ntapnw_atap_tdo    (tapnw2_stap2_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw2_stap2_pri_tdoen),

              .ftapnw_ftap_secsel    (stap2_secsel),
              .ftapnw_ftap_enabletdo (stap2_enabletdo),
              .ftapnw_ftap_enabletap (stap2_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw2_stap_tck),
              .ftapnw_ftap_tms    (tapnw2_stap_tms),
              .ftapnw_ftap_trst_b (tapnw2_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw2_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw2_tdo),
              .atapnw_atap_tdo_en (stap_tapnw2_tdo_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap7_tapnw2_subtapactv,
                                         stap4_tapnw2_subtapactv,
                                         stap3_tapnw2_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw2_stap2_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP5--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP5_sTAP_soc_param_overide.inc")
    i_stap5 (
             //Primary JTAG ports
             .ftap_tck                (tapnw3_stap_tck[0]),
             .ftap_tms                (tapnw3_stap_tms[0]),
             .ftap_trst_b             (tapnw3_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw3_stap_tdi[0]),
             .ftap_vercode            (tapnw3_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_0501),
             .atap_tdo                (stap_tapnw3_tdo[0]),
             .atap_tdoen              (stap_tapnw3_tdo_en[0]),
             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap5_tapnw3_subtapactv)
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW3-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW3_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW3_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW3_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW3_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw3 (
              //STAP1 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap4_tapnw3_pri_clk),
              .ptapnw_ftap_tms    (stap4_tapnw3_pri_tms),
              .ptapnw_ftap_trst_b (stap4_tapnw3_pri_trst_b),
              .ptapnw_ftap_tdi    (stap4_tapnw3_pri_tdi),
              .ntapnw_atap_tdo    (tapnw3_stap4_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw3_stap4_pri_tdoen),

              .ftapnw_ftap_secsel    (stap4_secsel),
              .ftapnw_ftap_enabletdo (stap4_enabletdo),
              .ftapnw_ftap_enabletap (stap4_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw3_stap_tck),
              .ftapnw_ftap_tms    (tapnw3_stap_tms),
              .ftapnw_ftap_trst_b (tapnw3_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw3_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw3_tdo),
              .atapnw_atap_tdo_en (stap_tapnw3_tdo_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap6_tapnw3_subtapactv,
                                         stap5_tapnw3_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw3_stap4_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP6--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP6_sTAP_soc_param_overide.inc")
    i_stap6 (
             //Primary JTAG ports
             .ftap_tck                (tapnw3_stap_tck[1]),
             .ftap_tms                (tapnw3_stap_tms[1]),
             .ftap_trst_b             (tapnw3_stap_trst_b[1]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw3_stap_tdi[1]),
             .ftap_vercode            (tapnw3_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_0601),
             .atap_tdo                (stap_tapnw3_tdo[1]),
             .atap_tdoen              (stap_tapnw3_tdo_en[1]),
             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap6_tapnw3_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP7--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP7_sTAP_soc_param_overide.inc")
    i_stap7 (
             //Primary JTAG ports
             .ftap_tck                (tapnw2_stap_tck[2]),
             .ftap_tms                (tapnw2_stap_tms[2]),
             .ftap_trst_b             (tapnw2_stap_trst_b[2]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw2_stap_tdi[2]),
             .ftap_vercode            (tapnw2_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_0701),
             .atap_tdo                (stap_tapnw2_tdo[2]),
             .atap_tdoen              (stap_tapnw2_tdo_en[2]),
             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap7_tapnw2_subtapactv)
            );


    //--------------------------------------------------------------------//
    //-------------TAPNW4-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW4_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW4_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW4_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW4_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw4 (
              //STAP1 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap8_tapnw4_pri_clk),
              .ptapnw_ftap_tms    (stap8_tapnw4_pri_tms),
              .ptapnw_ftap_trst_b (stap8_tapnw4_pri_trst_b),
              .ptapnw_ftap_tdi    (stap8_tapnw4_pri_tdi),
              .ntapnw_atap_tdo    (tapnw4_stap8_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw4_stap8_pri_tdoen),

              .ftapnw_ftap_secsel    (stap8_secsel),
              .ftapnw_ftap_enabletdo (stap8_enabletdo),
              .ftapnw_ftap_enabletap (stap8_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw4_stap_tck),
              .ftapnw_ftap_tms    (tapnw4_stap_tms),
              .ftapnw_ftap_trst_b (tapnw4_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw4_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw4_tdo),
              .atapnw_atap_tdo_en (stap_tapnw4_tdo_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap13_tapnw4_subtapactv,
                                         stap12_tapnw4_subtapactv,
                                         stap11_tapnw4_subtapactv,
                                         stap10_tapnw4_subtapactv,
                                         stap9_tapnw4_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw4_stap8_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP8--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP8_sTAP_soc_param_overide.inc")
    i_stap8 (
             //Primary JTAG ports
             .ftap_tck       (tapnw1_stap_tck[1]),
             .ftap_tms       (tapnw1_stap_tms[1]),
             .ftap_trst_b    (tapnw1_stap_trst_b[1]),
             .powergoodrst_b (powergoodrst_b),
             .ftap_tdi       (tapnw1_stap_tdi[1]),
             .ftap_vercode   (tapnw1_tap_vercode),
             .ftap_slvidcode (32'hC0DE_0801),
             .atap_tdo       (stap_tapnw1_tdo[1]),
             .atap_tdoen     (stap_tapnw1_tdo_en[1]),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel    (stap8_secsel),
             .sftapnw_ftap_enabletdo (stap8_enabletdo),
             .sftapnw_ftap_enabletap (stap8_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap8_tapnw4_pri_clk),
             .sntapnw_ftap_tms    (stap8_tapnw4_pri_tms),
             .sntapnw_ftap_trst_b (stap8_tapnw4_pri_trst_b),
             .sntapnw_ftap_tdi    (stap8_tapnw4_pri_tdi),
             .sntapnw_atap_tdo    (tapnw4_stap8_pri_tdo),
             .sntapnw_atap_tdo_en ({1'b0,tapnw4_stap8_pri_tdoen}),

             //Router for TAP network
             .stapnw_atap_subtapactvi ({4'b0,tapnw4_stap8_subtapactv}),
             .atap_subtapactv         (stap8_tapnw1_subtapactv)
            );


    //-------------------------------------------------------------------------//
    //------------------------------STAP9--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP9_sTAP_soc_param_overide.inc")
    i_stap9 (
             //Primary JTAG ports
             .ftap_tck                (tapnw4_stap_tck[0]),
             .ftap_tms                (tapnw4_stap_tms[0]),
             .ftap_trst_b             (tapnw4_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw4_stap_tdi[0]),
             .ftap_vercode            (tapnw4_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_0901),
             .atap_tdo                (stap_tapnw4_tdo[0]),
             .atap_tdoen              (stap_tapnw4_tdo_en[0]),
             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap9_tapnw4_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP10-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP10_sTAP_soc_param_overide.inc")
    i_stap10 (
             //Primary JTAG ports
             .ftap_tck                (tapnw4_stap_tck[1]),
             .ftap_tms                (tapnw4_stap_tms[1]),
             .ftap_trst_b             (tapnw4_stap_trst_b[1]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw4_stap_tdi[1]),
             .ftap_vercode            (tapnw4_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1001),
             .atap_tdo                (stap_tapnw4_tdo[1]),
             .atap_tdoen              (stap_tapnw4_tdo_en[1]),
             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap10_tapnw4_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP11-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP11_sTAP_soc_param_overide.inc")
    i_stap11 (
             //Primary JTAG ports
             .ftap_tck                (tapnw4_stap_tck[2]),
             .ftap_tms                (tapnw4_stap_tms[2]),
             .ftap_trst_b             (tapnw4_stap_trst_b[2]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw4_stap_tdi[2]),
             .ftap_vercode            (tapnw4_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1101),
             .atap_tdo                (stap_tapnw4_tdo[2]),
             .atap_tdoen              (stap_tapnw4_tdo_en[2]),

             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap11_tapnw4_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP12-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP12_sTAP_soc_param_overide.inc")
    i_stap12 (
             //Primary JTAG ports
             .ftap_tck                (tapnw4_stap_tck[3]),
             .ftap_tms                (tapnw4_stap_tms[3]),
             .ftap_trst_b             (tapnw4_stap_trst_b[3]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw4_stap_tdi[3]),
             .ftap_vercode            (tapnw4_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1201),
             .atap_tdo                (stap_tapnw4_tdo[3]),
             .atap_tdoen              (stap_tapnw4_tdo_en[3]),

             //Router for TAP network
             .stapnw_atap_subtapactvi (1'b0),
             .sntapnw_atap_tdo_en     (0),
             .atap_subtapactv         (stap12_tapnw4_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP13-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP13_sTAP_soc_param_overide.inc")
    i_stap13 (
             //Primary JTAG ports
             .ftap_tck                (tapnw4_stap_tck[4]),
             .ftap_tms                (tapnw4_stap_tms[4]),
             .ftap_trst_b             (tapnw4_stap_trst_b[4]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw4_stap_tdi[4]),
             .ftap_vercode            (tapnw4_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1301),
             .atap_tdo                (stap_tapnw4_tdo[4]),
             .atap_tdoen              (stap_tapnw4_tdo_en[4]),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel     (stap13_secsel),
             .sftapnw_ftap_enabletdo  (stap13_enabletdo),
             .sftapnw_ftap_enabletap  (stap13_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap13_tapnw5_pri_clk),
             .sntapnw_ftap_tms    (stap13_tapnw5_pri_tms),
             .sntapnw_ftap_trst_b (stap13_tapnw5_pri_trst_b),
             .sntapnw_ftap_tdi    (stap13_tapnw5_pri_tdi),
             .sntapnw_atap_tdo    (tapnw5_stap13_pri_tdo),
             .sntapnw_atap_tdo_en ({1'b0,tapnw5_stap13_pri_tdoen}),

             //Tertiary2 ports of SoC
             .ftapsslv_tck        (tck4),
             .ftapsslv_tms        (tms4),
             .ftapsslv_trst_b     (trst_b4),
             .ftapsslv_tdi        (tdi4), 
             .atapsslv_tdo        (tdo4),
             .atapsslv_tdoen      (tdo4_en),

             //STAP1 SECONDARY (TERITIARY) INTERFACE OF CONTROLLING TAP
             .sntapnw_ftap_tck2        (stap13_tapnw5_sec_clk),
             .sntapnw_ftap_tms2        (stap13_tapnw5_sec_tms),
             .sntapnw_ftap_trst2_b     (stap13_tapnw5_sec_trst_b),
             .sntapnw_ftap_tdi2        (stap13_tapnw5_sec_tdi),
             .sntapnw_atap_tdo2        (tapnw5_stap13_sec_tdo),
             .sntapnw_atap_tdo2_en     (tapnw5_stap13_sec_tdoen),

             //Router for TAP network
             .stapnw_atap_subtapactvi ({1'b0,tapnw5_stap13_subtapactv}),
             .atap_subtapactv         (stap13_tapnw4_subtapactv)
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW5-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW5_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW5_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW5_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW5_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw5 (
              //STAP1 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap13_tapnw5_pri_clk),
              .ptapnw_ftap_tms    (stap13_tapnw5_pri_tms),
              .ptapnw_ftap_trst_b (stap13_tapnw5_pri_trst_b),
              .ptapnw_ftap_tdi    (stap13_tapnw5_pri_tdi),
              .ntapnw_atap_tdo    (tapnw5_stap13_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw5_stap13_pri_tdoen),

              .ftapnw_ftap_secsel    (stap13_secsel),
              .ftapnw_ftap_enabletdo (stap13_enabletdo),
              .ftapnw_ftap_enabletap (stap13_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //STAP1 SECONDARY (TERITIARY) INTERFACE OF CONTROLLING TAP
              .ptapnw_ftap_tck2    (stap13_tapnw5_sec_clk),
              .ptapnw_ftap_tms2    (stap13_tapnw5_sec_tms),
              .ptapnw_ftap_trst2_b (stap13_tapnw5_sec_trst_b),
              .ptapnw_ftap_tdi2    (stap13_tapnw5_sec_tdi),
              .ntapnw_atap_tdo2_en (tapnw5_stap13_sec_tdoen),
              .ntapnw_atap_tdo2    (tapnw5_stap13_sec_tdo),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw5_stap_tck),
              .ftapnw_ftap_tms    (tapnw5_stap_tms),
              .ftapnw_ftap_trst_b (tapnw5_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw5_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw5_tdo),
              .atapnw_atap_tdo_en (stap_tapnw5_tdo_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap19_tapnw5_subtapactv,
                                         stap14_tapnw5_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw5_stap13_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP14-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP14_sTAP_soc_param_overide.inc")
    i_stap14 (
             //Primary JTAG ports
             .ftap_tck                (tapnw5_stap_tck[0]),
             .ftap_tms                (tapnw5_stap_tms[0]),
             .ftap_trst_b             (tapnw5_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw5_stap_tdi[0]),
             .ftap_vercode            (tapnw5_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1401),
             .atap_tdo                (stap_tapnw5_tdo[0]),
             .atap_tdoen              (stap_tapnw5_tdo_en[0]),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel     (stap14_secsel),
             .sftapnw_ftap_enabletdo  (stap14_enabletdo),
             .sftapnw_ftap_enabletap  (stap14_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap14_tapnw6_pri_clk),
             .sntapnw_ftap_tms    (stap14_tapnw6_pri_tms),
             .sntapnw_ftap_trst_b (stap14_tapnw6_pri_trst_b),
             .sntapnw_ftap_tdi    (stap14_tapnw6_pri_tdi),
             .sntapnw_atap_tdo    (tapnw6_stap14_pri_tdo),
             .sntapnw_atap_tdo_en ({1'b0,tapnw6_stap14_pri_tdoen}),

             //Router for TAP network
             .stapnw_atap_subtapactvi ({3'b0,tapnw6_stap14_subtapactv}),
             .atap_subtapactv         (stap14_tapnw5_subtapactv)
            ); 

    //--------------------------------------------------------------------//
    //-------------TAPNW6-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW6_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW6_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW6_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW6_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw6 (
              //STAP1 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap14_tapnw6_pri_clk),
              .ptapnw_ftap_tms    (stap14_tapnw6_pri_tms),
              .ptapnw_ftap_trst_b (stap14_tapnw6_pri_trst_b),
              .ptapnw_ftap_tdi    (stap14_tapnw6_pri_tdi),
              .ntapnw_atap_tdo    (tapnw6_stap14_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw6_stap14_pri_tdoen),

              .ftapnw_ftap_secsel    (stap14_secsel),
              .ftapnw_ftap_enabletdo (stap14_enabletdo),
              .ftapnw_ftap_enabletap (stap14_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw6_stap_tck),
              .ftapnw_ftap_tms    (tapnw6_stap_tms),
              .ftapnw_ftap_trst_b (tapnw6_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw6_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw6_tdo),
              .atapnw_atap_tdo_en (stap_tapnw6_tdo_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap18_tapnw6_subtapactv,
                                         stap17_tapnw6_subtapactv,
                                         stap16_tapnw6_subtapactv,
                                         stap15_tapnw6_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw6_stap14_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP15-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP15_sTAP_soc_param_overide.inc")
    i_stap15 (
             //Primary JTAG ports
             .ftap_tck                (tapnw6_stap_tck[0]),
             .ftap_tms                (tapnw6_stap_tms[0]),
             .ftap_trst_b             (tapnw6_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw6_stap_tdi[0]),
             .ftap_vercode            (tapnw6_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1501),
             .atap_tdo                (stap_tapnw6_tdo[0]),
             .atap_tdoen              (stap_tapnw6_tdo_en[0]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap15_tapnw6_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP16-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP16_sTAP_soc_param_overide.inc")
    i_stap16 (
             //Primary JTAG ports
             .ftap_tck                (tapnw6_stap_tck[1]),
             .ftap_tms                (tapnw6_stap_tms[1]),
             .ftap_trst_b             (tapnw6_stap_trst_b[1]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw6_stap_tdi[1]),
             .ftap_vercode            (tapnw6_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1601),
             .atap_tdo                (stap_tapnw6_tdo[1]),
             .atap_tdoen              (stap_tapnw6_tdo_en[1]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap16_tapnw6_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP17-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP17_sTAP_soc_param_overide.inc")
    i_stap17 (
             //Primary JTAG ports
             .ftap_tck                (tapnw6_stap_tck[2]),
             .ftap_tms                (tapnw6_stap_tms[2]),
             .ftap_trst_b             (tapnw6_stap_trst_b[2]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw6_stap_tdi[2]),
             .ftap_vercode            (tapnw6_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1701),
             .atap_tdo                (stap_tapnw6_tdo[2]),
             .atap_tdoen              (stap_tapnw6_tdo_en[2]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap17_tapnw6_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP18-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP18_sTAP_soc_param_overide.inc")
    i_stap18 (
             //Primary JTAG ports
             .ftap_tck                (tapnw6_stap_tck[3]),
             .ftap_tms                (tapnw6_stap_tms[3]),
             .ftap_trst_b             (tapnw6_stap_trst_b[3]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw6_stap_tdi[3]),
             .ftap_vercode            (tapnw6_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1801),
             .atap_tdo                (stap_tapnw6_tdo[3]),
             .atap_tdoen              (stap_tapnw6_tdo_en[3]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap18_tapnw6_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP19-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP19_sTAP_soc_param_overide.inc")
    i_stap19 (
             //Primary JTAG ports
             .ftap_tck                (tapnw5_stap_tck[1]),
             .ftap_tms                (tapnw5_stap_tms[1]),
             .ftap_trst_b             (tapnw5_stap_trst_b[1]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw5_stap_tdi[1]),
             .ftap_vercode            (tapnw5_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_1901),
             .atap_tdo                (stap_tapnw5_tdo[1]),
             .atap_tdoen              (stap_tapnw5_tdo_en[1]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap19_tapnw5_subtapactv),

             // WTAP Control Signals  common to WTAP/WTAP Network
             .sn_fwtap_wrck         (wtap_sn_fwtap_wrck),
             .sn_fwtap_wrst_b       (wtap_sn_fwtap_wrst_b),
             .sn_fwtap_capturewr    (wtap_atap_capturewr),
             .sn_fwtap_shiftwr      (wtap_atap_shiftwr),
             .sn_fwtap_updatewr     (wtap_atap_updatewr),
             .sn_fwtap_rti          (wtap_atap_rti),

             //Control Signals only to WTAP Network
             .sn_fwtap_selectwir    (wtap_atap_wtapnw_selectwir),
             .sn_awtap_wso          (wtap_awtapnw_wso[1:0]),
             .sn_fwtap_wsi          (wtap_fwtapnw_wsi[1:0])
            );

     //       wtap i_wtap0 (
     //                   // Inputs
     //                   .fwtap_wrck             (wtap_sn_fwtap_wrck),
     //                   .fwtap_wrst_b           (wtap_sn_fwtap_wrst_b),
     //                   .powergoodrst_b         (powergoodrst_b),

     //                   .fwtap_rti              (wtap_atap_rti),
     //                   .fwtap_selectwir        (wtap_atap_wtapnw_selectwir),
     //                   .fwtap_capturewr        (wtap_atap_capturewr),
     //                   .fwtap_shiftwr          (wtap_atap_shiftwr),
     //                   .fwtap_updatewr         (wtap_atap_updatewr),
     //                   .fwtap_wsi              (wtap_fwtapnw_wsi[0]),

     //                   // Outputs
     //                   .awtap_wso              (wtap_awtapnw_wso[0])
     //                  );

     //       wtap i_wtap1 (
     //                   // Inputs
     //                   .fwtap_wrck             (wtap_sn_fwtap_wrck),
     //                   .fwtap_wrst_b           (wtap_sn_fwtap_wrst_b),
     //                   .powergoodrst_b         (powergoodrst_b),

     //                   .fwtap_rti              (wtap_atap_rti),
     //                   .fwtap_selectwir        (wtap_atap_wtapnw_selectwir),
     //                   .fwtap_capturewr        (wtap_atap_capturewr),
     //                   .fwtap_shiftwr          (wtap_atap_shiftwr),
     //                   .fwtap_updatewr         (wtap_atap_updatewr),
     //                   .fwtap_wsi              (wtap_fwtapnw_wsi[1]),

     //                   // Outputs
     //                   .awtap_wso              (wtap_awtapnw_wso[1])
     //                  );

    //--------------------------------------------------------------------//
    //-------------TAPNW7-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW7_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW7_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW7_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW7_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw7 (
              //MTAP INTERFACE
              .ptapnw_ftap_tck    (mtap_tapnw0_pri_clk),
              .ptapnw_ftap_tms    (mtap_tapnw0_pri_tms),
              .ptapnw_ftap_trst_b (mtap_tapnw0_pri_trst_b),
              .ptapnw_ftap_tdi    (tapnw0_tapnw7_tdo),
              .ntapnw_atap_tdo    (tapnw7_tapnw10_tdo),
              .ntapnw_atap_tdo_en (tapnw7_prim_port_tdoen),

              .ftapnw_ftap_secsel    (atap_secsel[2]),
              .ftapnw_ftap_enabletdo (atap_enabletdo[2]),
              .ftapnw_ftap_enabletap (atap_enabletap[2]),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAP INTERFACE
              .ftapnw_ftap_tck    (tapnw7_stap_tck),
              .ftapnw_ftap_tms    (tapnw7_stap_tms),
              .ftapnw_ftap_trst_b (tapnw7_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw7_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw7_tdo),
              .atapnw_atap_tdo_en (stap_tapnw7_tdo_en),

              //MTAP SECONDARY INTERFACE
              .ptapnw_ftap_tck2    (mtap_tapnw0_sec_clk),
              .ptapnw_ftap_tms2    (mtap_tapnw0_sec_tms),
              .ptapnw_ftap_trst2_b (mtap_tapnw0_sec_trst_b),
              .ptapnw_ftap_tdi2    (tapnw0_tapnw7_sec_tdo),
              .ntapnw_atap_tdo2_en (),
              .ntapnw_atap_tdo2    (tapnw7_tapnw10_sec_tdo),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvo (tapnw7_cltap_subtapactv),
              .atapnw_atap_subtapactvi (stap20_tapnw7_subtapactv),
//  HYBRID
              .ntapnw_sslv_tdo2    (stap20_tapnw7_sec_tdo),
              .ntapnw_sslv_tdo2_en (stap20_tapnw7_sec_tdoen),

//              .ntapnw_sslv_secsel (stap20_secsel), //FIXME check with shiva on ntapnw_sslv_secsel undefined port
              .ntapnw_ftap_secsel (stap20_secsel),
              .ntapnw_ftap_tck2 (tapnw7_stap20_tck2),
              .ntapnw_ftap_tms2 (tapnw7_stap20_tms2),
              .ntapnw_ftap_trst2_b (tapnw7_stap20_trst2_b),


              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP20--------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP20_sTAP_soc_param_overide.inc")
    i_stap20 (
             //Primary JTAG ports
             .ftap_tck       (tapnw7_stap_tck[0]),
             .ftap_tms       (tapnw7_stap_tms[0]),
             .ftap_trst_b    (tapnw7_stap_trst_b[0]),
             .powergoodrst_b (powergoodrst_b),
             .ftap_tdi       (tapnw7_stap_tdi[0]),
             .ftap_vercode   (tapnw_tap_vercode),
             .ftap_slvidcode (32'hC0DE_2001),
             .atap_tdo       (stap_tapnw7_tdo[0]),
             .atap_tdoen     (stap_tapnw7_tdo_en[0]),

             //Secondary JTAG ports (From TAPNW7)
             .ftapsslv_tck    (tapnw7_stap20_tck2),
             .ftapsslv_tms    (tapnw7_stap20_tms2),
             .ftapsslv_trst_b (tapnw7_stap20_trst2_b),
             .ftapsslv_tdi    (tapnw0_tapnw7_sec_tdo), 
             .atapsslv_tdo    (stap20_tapnw7_sec_tdo),
             .atapsslv_tdoen  (stap20_tapnw7_sec_tdoen),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel    (stap20_secsel),
             .sftapnw_ftap_enabletdo (stap20_enabletdo),
             .sftapnw_ftap_enabletap (stap20_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap20_tapnw8_pri_clk),
             .sntapnw_ftap_tms    (stap20_tapnw8_pri_tms),
             .sntapnw_ftap_trst_b (stap20_tapnw8_pri_trst_b),
             .sntapnw_ftap_tdi    (stap20_tapnw8_pri_tdi),
             .sntapnw_atap_tdo    (tapnw8_stap20_pri_tdo),
             .sntapnw_atap_tdo_en (tapnw8_stap20_pri_tdoen),

//  HYBRID

             .sntapnw_ftap_tck2    (stap20_tapnw8_tck2),
             .sntapnw_ftap_tms2    (stap20_tapnw8_tms2),
             .sntapnw_ftap_trst2_b (stap20_tapnw8_trst2_b),
             .sntapnw_ftap_tdi2    (stap20_tapnw8_tdi2),
             .sntapnw_atap_tdo2    (tapnw8_stap20_sec_tdo),
             .sntapnw_atap_tdo2_en (tapnw8_stap20_sec_tdo_en),


             //Router for TAP network
             .stapnw_atap_subtapactvi ({1'b0,tapnw1_stap1_subtapactv}),
             .atap_subtapactv         (stap20_tapnw7_subtapactv)
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW8-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW8_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW8_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW8_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW8_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw8 (
              //STAP20 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap20_tapnw8_pri_clk),
              .ptapnw_ftap_tms    (stap20_tapnw8_pri_tms),
              .ptapnw_ftap_trst_b (stap20_tapnw8_pri_trst_b),
              .ptapnw_ftap_tdi    (stap20_tapnw8_pri_tdi),
              .ntapnw_atap_tdo    (tapnw8_stap20_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw8_stap20_pri_tdoen),

              //STAP20 SECONDARY INTERFACE
              .ptapnw_ftap_tck2    (stap20_tapnw8_tck2),
              .ptapnw_ftap_tms2    (stap20_tapnw8_tms2),
              .ptapnw_ftap_trst2_b (stap20_tapnw8_trst2_b),
              .ptapnw_ftap_tdi2    (stap20_tapnw8_tdi2),
              .ntapnw_atap_tdo2_en (tapnw8_stap20_sec_tdo_en),
              .ntapnw_atap_tdo2    (tapnw8_stap20_sec_tdo),

              .ftapnw_ftap_secsel    (stap20_secsel),
              .ftapnw_ftap_enabletdo (stap20_enabletdo),
              .ftapnw_ftap_enabletap (stap20_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw8_stap_tck),
              .ftapnw_ftap_tms    (tapnw8_stap_tms),
              .ftapnw_ftap_trst_b (tapnw8_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw8_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw8_tdo),
              .atapnw_atap_tdo_en (stap_tapnw8_tdo_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap24_tapnw8_subtapactv,
                                         stap23_tapnw8_subtapactv,
                                         stap22_tapnw8_subtapactv,
                                         stap21_tapnw8_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw8_stap20_subtapactv),


              //`.ptapnw_ftap_tck2    (stap20_tapnw8_tck2),
              //`.ptapnw_ftap_tms2    (stap20_tapnw8_tms2), 
              //`.ptapnw_ftap_trst2_b (stap20_tapnw8_trst2_b),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP21-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP21_sTAP_soc_param_overide.inc")
    i_stap21 (
             //Primary JTAG ports
             .ftap_tck                (tapnw8_stap_tck[0]),
             .ftap_tms                (tapnw8_stap_tms[0]),
             .ftap_trst_b             (tapnw8_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw8_stap_tdi[0]),
             .ftap_vercode            (tapnw8_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2101),
             .atap_tdo                (stap_tapnw8_tdo[0]),
             .atap_tdoen              (stap_tapnw8_tdo_en[0]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap21_tapnw8_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP22-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP22_sTAP_soc_param_overide.inc")
    i_stap22 (
             //Primary JTAG ports
             .ftap_tck                (tapnw8_stap_tck[1]),
             .ftap_tms                (tapnw8_stap_tms[1]),
             .ftap_trst_b             (tapnw8_stap_trst_b[1]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw8_stap_tdi[1]),
             .ftap_vercode            (tapnw8_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2201),
             .atap_tdo                (stap_tapnw8_tdo[1]),
             .atap_tdoen              (stap_tapnw8_tdo_en[1]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap22_tapnw8_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP23-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP23_sTAP_soc_param_overide.inc")
    i_stap23 (
             //Primary JTAG ports
             .ftap_tck                (tapnw8_stap_tck[2]),
             .ftap_tms                (tapnw8_stap_tms[2]),
             .ftap_trst_b             (tapnw8_stap_trst_b[2]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw8_stap_tdi[2]),
             .ftap_vercode            (tapnw8_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2301),
             .atap_tdo                (stap_tapnw8_tdo[2]),
             .atap_tdoen              (stap_tapnw8_tdo_en[2]),

             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap23_tapnw8_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP24-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP24_sTAP_soc_param_overide.inc")
    i_stap24 (
             //Primary JTAG ports
             .ftap_tck                (tapnw8_stap_tck[3]),
             .ftap_tms                (tapnw8_stap_tms[3]),
             .ftap_trst_b             (tapnw8_stap_trst_b[3]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw8_stap_tdi[3]),
             .ftap_vercode            (tapnw8_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2401),
             .atap_tdo                (stap_tapnw8_tdo[3]),
             .atap_tdoen              (stap_tapnw8_tdo_en[3]),

             //Control signals to Slave TAPNetwork
             .sftapnw_ftap_secsel     (stap24_secsel),
             .sftapnw_ftap_enabletdo  (stap24_enabletdo),
             .sftapnw_ftap_enabletap  (stap24_enabletap),

             //Primary JTAG ports to Slave TAPNetwork
             .sntapnw_ftap_tck    (stap24_tapnw9_pri_clk),
             .sntapnw_ftap_tms    (stap24_tapnw9_pri_tms),
             .sntapnw_ftap_trst_b (stap24_tapnw9_pri_trst_b),
             .sntapnw_ftap_tdi    (stap24_tapnw9_pri_tdi),
             .sntapnw_atap_tdo    (tapnw9_stap24_pri_tdo),
             .sntapnw_atap_tdo_en ({1'b0,tapnw9_stap24_pri_tdoen}),

             //Router for TAP network
             .stapnw_atap_subtapactvi ({3'b0,tapnw9_stap24_subtapactv}),
             .atap_subtapactv         (stap24_tapnw8_subtapactv)
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW9-------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW9_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW9_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW9_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW9_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw9 (
              //STAP1 PRIMARY INTERFACE
              .ptapnw_ftap_tck    (stap24_tapnw9_pri_clk),
              .ptapnw_ftap_tms    (stap24_tapnw9_pri_tms),
              .ptapnw_ftap_trst_b (stap24_tapnw9_pri_trst_b),
              .ptapnw_ftap_tdi    (stap24_tapnw9_pri_tdi),
              .ntapnw_atap_tdo    (tapnw9_stap24_pri_tdo),
              .ntapnw_atap_tdo_en (tapnw9_stap24_pri_tdoen),

              .ftapnw_ftap_secsel    (stap24_secsel),
              .ftapnw_ftap_enabletdo (stap24_enabletdo),
              .ftapnw_ftap_enabletap (stap24_enabletap),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAPS INTERFACE
              .ftapnw_ftap_tck    (tapnw9_stap_tck),
              .ftapnw_ftap_tms    (tapnw9_stap_tms),
              .ftapnw_ftap_trst_b (tapnw9_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw9_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw9_tdo),
              .atapnw_atap_tdo_en (stap_tapnw9_tdo_en),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvi ({stap26_tapnw9_subtapactv,
                                         stap25_tapnw9_subtapactv}),
              .atapnw_atap_subtapactvo (tapnw9_stap24_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP25-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP25_sTAP_soc_param_overide.inc")
    i_stap25 (
             //Primary JTAG ports
             .ftap_tck                (tapnw9_stap_tck[0]),
             .ftap_tms                (tapnw9_stap_tms[0]),
             .ftap_trst_b             (tapnw9_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw9_stap_tdi[0]),
             .ftap_vercode            (tapnw9_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2501),
             .atap_tdo                (stap_tapnw9_tdo[0]),
             .atap_tdoen              (stap_tapnw9_tdo_en[0]),
             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap25_tapnw9_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP26-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP26_sTAP_soc_param_overide.inc")
    i_stap26 (
             //Primary JTAG ports
             .ftap_tck                (tapnw9_stap_tck[1]),
             .ftap_tms                (tapnw9_stap_tms[1]),
             .ftap_trst_b             (tapnw9_stap_trst_b[1]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw9_stap_tdi[1]),
             .ftap_vercode            (tapnw9_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2601),
             .atap_tdo                (stap_tapnw9_tdo[1]),
             .atap_tdoen              (stap_tapnw9_tdo_en[1]),
             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap26_tapnw9_subtapactv)
            );

    //--------------------------------------------------------------------//
    //-------------TAPNW10------------------------------------------------//
    //--------------------------------------------------------------------//
    tapnw #(
            .TAPNW_NUMBER_OF_STAPS          (TAPNW10_NUMBER_OF_STAPS),
            .TAPNW_PARK_TCK_AT              (TAPNW10_PARK_TCK_AT),
            .TAPNW_HIER_HYBRID              (TAPNW10_HIER_HYBRID),
            .TAPNW_NUMBER_OF_STAPS_IN_SUBNW (TAPNW10_NUMBER_OF_STAPS_IN_SUBNW)
           )
    i_tapnw10 (
              //MTAP INTERFACE
              .ptapnw_ftap_tck    (mtap_tapnw0_pri_clk),
              .ptapnw_ftap_tms    (mtap_tapnw0_pri_tms),
              .ptapnw_ftap_trst_b (mtap_tapnw0_pri_trst_b),
              .ptapnw_ftap_tdi    (tapnw7_tapnw10_tdo),
              .ntapnw_atap_tdo    (tapnw10_prim_port_tdo),
              .ntapnw_atap_tdo_en (tapnw10_prim_port_tdoen),

              .ftapnw_ftap_secsel    (atap_secsel[5:3]),
              .ftapnw_ftap_enabletdo (atap_enabletdo[5:3]),
              .ftapnw_ftap_enabletap (atap_enabletap[5:3]),

              .powergoodrst_b (powergoodrst_b),

              //SLAVE TAP INTERFACE
              .ftapnw_ftap_tck    (tapnw10_stap_tck),
              .ftapnw_ftap_tms    (tapnw10_stap_tms),
              .ftapnw_ftap_trst_b (tapnw10_stap_trst_b),
              .ftapnw_ftap_tdi    (tapnw10_stap_tdi),
              .atapnw_atap_tdo    (stap_tapnw10_tdo),
              .atapnw_atap_tdo_en (stap_tapnw10_tdo_en),

              //MTAP SECONDARY INTERFACE
              .ptapnw_ftap_tck2    (mtap_tapnw0_sec_clk),
              .ptapnw_ftap_tms2    (mtap_tapnw0_sec_tms),
              .ptapnw_ftap_trst2_b (mtap_tapnw0_sec_trst_b),
              .ptapnw_ftap_tdi2    (tapnw7_tapnw10_sec_tdo),
              .ntapnw_atap_tdo2_en (),
              .ntapnw_atap_tdo2    (tapnw10_mtap_sec_tdo),

              //Sub Tap Control logic
              .atapnw_atap_subtapactvo (tapnw10_cltap_subtapactv),
              .atapnw_atap_subtapactvi (stap20_tapnw10_subtapactv),

              //VERCODE
              .ftapnw_ftap_vercodei (),
              .ftapnw_ftap_vercodeo ()
             );

    //-------------------------------------------------------------------------//
    //------------------------------STAP27-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP27_sTAP_soc_param_overide.inc")
    i_stap27 (
             //Primary JTAG ports
             .ftap_tck                (tapnw10_stap_tck[0]),
             .ftap_tms                (tapnw10_stap_tms[0]),
             .ftap_trst_b             (tapnw10_stap_trst_b[0]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw10_stap_tdi[0]),
             .ftap_vercode            (tapnw10_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2701),
             .atap_tdo                (stap_tapnw10_tdo[0]),
             .atap_tdoen              (stap_tapnw10_tdo_en[0]),
             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap27_tapnw10_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP28-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP28_sTAP_soc_param_overide.inc")
    i_stap28 (
             //Primary JTAG ports
             .ftap_tck                (tapnw10_stap_tck[1]),
             .ftap_tms                (tapnw10_stap_tms[1]),
             .ftap_trst_b             (tapnw10_stap_trst_b[1]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw10_stap_tdi[1]),
             .ftap_vercode            (tapnw10_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2801),
             .atap_tdo                (stap_tapnw10_tdo[1]),
             .atap_tdoen              (stap_tapnw10_tdo_en[1]),
             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap28_tapnw9_subtapactv)
            );

    //-------------------------------------------------------------------------//
    //------------------------------STAP29-------------------------------------//
    //-------------------------------------------------------------------------//
    stap #(`include "STAP29_sTAP_soc_param_overide.inc")
    i_stap29 (
             //Primary JTAG ports
             .ftap_tck                (tapnw10_stap_tck[2]),
             .ftap_tms                (tapnw10_stap_tms[2]),
             .ftap_trst_b             (tapnw10_stap_trst_b[2]),
             .powergoodrst_b          (powergoodrst_b),
             .ftap_tdi                (tapnw10_stap_tdi[2]),
             .ftap_vercode            (tapnw10_tap_vercode),
             .ftap_slvidcode          (32'hC0DE_2901),
             .atap_tdo                (stap_tapnw10_tdo[2]),
             .atap_tdoen              (stap_tapnw10_tdo_en[2]),
             //Router for TAP network
             .sntapnw_atap_tdo_en     (0),
             .stapnw_atap_subtapactvi (1'b0),
             .atap_subtapactv         (stap29_tapnw10_subtapactv)
            );

endmodule
