//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
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
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_pin_if.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Pin Interface for the ENV
//    DESCRIPTION : This is the pin interface for the environment.
//----------------------------------------------------------------------
`include "tb_param.inc"

interface stap_pin_if(
                      input tck,
                      input trst_b
                     );

    localparam HIGH = 1'b1;
    localparam LOW  = 1'b0;

    //For UPF
    bit stap_isol_en;
    reg stap_isol_en_b;
    reg ftap_pwrdomain_rst_b;


    //Primary JTAG ports
    reg        ftap_tck;
    reg        ftap_tms;
    reg        ftap_trst_b;
    reg        ftap_tdi;
    reg [31:0] ftap_slvidcode;
    reg        atap_tdo;
    reg        fdfx_powergood;

    //Parallel ports of optional data registers
    reg [((TOTAL_DATA_REGISTER_WIDTH - RO_REGISTER_WIDTH) - 35) :0] parallel_data_out;
    reg [((TOTAL_DATA_REGISTER_WIDTH - RO_REGISTER_WIDTH) - 35) :0] parallel_data_in;

    //DFx Secure signals
    reg [(DFX_SECURE_WIDTH - 1):0]              fdfx_secure_policy;
    reg                                         fdfx_policy_update;
    reg                                         fdfx_earlyboot_exit;
    reg [(NUM_OF_DFX_FEATURES_TO_SECURE + 1):0] sb_policy_ovr_value;
    reg [(DFX_SECURE_WIDTH - 1) : 0]            oem_secure_policy;

    //Control signals to Slave TAPNetwork
    reg [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0] atap_secsel;
    reg [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0] atap_enabletdo;
    reg [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0] atap_enabletap;

    //Primary JTAG ports to Slave TAPNetwork
    reg sntapnw_ftap_tck;
    reg sntapnw_ftap_tms;
    reg sntapnw_ftap_trst_b;
    reg sntapnw_ftap_tdi;
    reg sntapnw_atap_tdo;

    //Secondary JTAG ports
    reg atapsecs_tck2;
    reg atapsecs_tms2;
    reg trst2_b;
    reg atapsecs_tdi2;
    reg ftapsecs_tdo2;
    reg ftapsecs_tdo2_en;

    //Secondary JTAG ports to Slave TAPNetwork
    reg                                          sntapnw_ftap_tck2;
    reg                                          sntapnw_ftap_tms2;
    reg                                          sntapnw_ftap_trst2_b;
    reg                                          sntapnw_ftap_tdi2;
    reg                                          sntapnw_atap_tdo2;
    reg [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0] sntapnw_atap_tdo2_en;

    //Control Signals  common to WTAP/WTAP Network
    reg sn_fwtap_wrck;
    reg sn_fwtap_wrst_b;
    reg atap_capturewr;
    reg atap_shiftwr;
    reg atap_updatewr;
    reg atap_rti;

    //Control Signals only to WTAP Network
    reg                                            atap_wtapnw_selectwir;
    reg [(STAP_NO_OF_WTAPS_IN_WTAP_NETWORK - 1):0] sn_awtap_wso;
    reg [(STAP_NO_OF_WTAPS_IN_WTAP_NETWORK - 1):0] atap_wtapnw_wsi;

    //Boundary Scan Signals

    //Control Signals from fsm
    reg stap_fbscan_tck;
    reg stap_abscan_tdo;
    reg stap_fbscan_capturedr;
    reg stap_fbscan_shiftdr;
    reg stap_fbscan_updatedr;
    reg stap_fbscan_updatedr_clk;

    //Instructions
    reg stap_fbscan_runbist_en;
    reg stap_fbscan_highz;
    reg stap_fbscan_extogen;
    reg stap_fbscan_intest_mode;
    reg stap_fbscan_chainen;
    reg stap_fbscan_mode;
    reg stap_fbscan_extogsig_b;

    // 1149.6 AC mode
    reg stap_fbscan_d6init;
    reg stap_fbscan_d6actestsig_b;
    reg stap_fbscan_d6select;

    // Remote Test Data Register pins
    reg [(TB_NO_OF_REMOTE_TDR_NZ - 1):0] rtdr_tap_tdo;
    reg [(TB_RTDR_IS_BUSSED_NZ - 1):0]   tap_rtdr_tdi;
    reg [(TB_RTDR_IS_BUSSED_NZ - 1):0]   tap_rtdr_capture;
    reg [(TB_RTDR_IS_BUSSED_NZ - 1):0]   tap_rtdr_shift;
    reg [(TB_RTDR_IS_BUSSED_NZ - 1):0]   tap_rtdr_update;
    reg                                  tap_rtdr_selectir;
    reg                                  tap_rtdr_powergood;

    reg [(TB_NO_OF_REMOTE_TDR_NZ - 1):0] tap_rtdr_irdec;
    reg                                  tap_rtdr_tck;
    reg                                  tap_rtdr_rti;
    reg [(TB_NO_OF_REMOTE_TDR_NZ - 1):0] tap_rtdr_prog_rst_b;

    assign ftap_tck      = tck;
    assign atapsecs_tck2 = tck;
    assign ftap_trst_b   = trst_b;

    initial begin
        stap_isol_en_b    = 1'b1;
        ftap_pwrdomain_rst_b = 1'b1;
        ftap_slvidcode    = $random();
        parallel_data_in  = $random();
        if (TB_DISABLE_MISC_DRIVE==LOW)
        begin
            atapsecs_tms2        = $random();
            trst2_b              = $random();
            atapsecs_tdi2        = $random();
            sntapnw_atap_tdo2_en = $random();
        end
    end
    initial begin
        #1200ns;
        repeat (200) begin
            repeat (1) @(negedge ftap_tck);
            ftap_slvidcode   = $random();
            parallel_data_in = $random();
            if (TB_DISABLE_MISC_DRIVE==LOW)
            begin
                atapsecs_tms2        = $random();
                trst2_b              = $random();
                atapsecs_tdi2        = $random();
                sntapnw_atap_tdo2_en = $random();
            end
        end
    end

endinterface
