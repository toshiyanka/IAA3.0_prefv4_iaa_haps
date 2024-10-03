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
//    FILENAME    : STapTop.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Top file of the ENV
//    DESCRIPTION : Instantiates and connects the Program block and the
//                  DUT and the Clock Gen module
//----------------------------------------------------------------------

`include "STAP_DfxSecurePlugin_TbDefines.svh"

module top #(`STAP_DSP_TB_PARAMS_DECL)();

   import DfxSecurePlugin_Pkg::*;
   import ovm_pkg::*;

    reg soc_fdfx_powergood;
    reg soc_clock;

    wire [31:0] op34, op6B;

    //JtagBfmIntf #(.CLOCK_PERIOD (10000), .PWRGOOD_SRC (0), .CLK_SRC (0)) Primary_if(soc_fdfx_powergood, soc_clock);
    JtagBfmIntf #(`SOC_PRI_JTAG_IF_PARAMS_INST) Primary_if(soc_fdfx_powergood, soc_clock);
    DfxSecurePlugin_pin_if #(`STAP_DSP_TB_PARAMS_INST) dfxsecure_pins(Primary_if.jtagbfm_clk);
    stap_pin_if pif(Primary_if.jtagbfm_clk, Primary_if.trst_b);

    //------------------
    // Instatiate the Test Island
    //------------------
    STap_ti #(`STAP_DSP_TB_PARAMS_INST) i_TapTestIsland (
                                                         //Inputs
                                                         .pif        (pif),
                                                         .Primary_if (Primary_if),
                                                         .pins       (dfxsecure_pins)
                                                        );
    // Fix for HSD4256873
    defparam i_TapTestIsland.STAPVIF    = "ovm_test_top.Env";
    defparam i_TapTestIsland.JTAGBFMVIF = "ovm_test_top.Env.stap_JtagMasterAgent.*";
    defparam i_TapTestIsland.DSPVIF     = "ovm_test_top.Env.stap_DfxSecurePlugin_Agent.*";

    //------------------
    //DUT
    //------------------
    stap stap_top_inst(
                       //Primary JTAG ports
                       .ftap_tck                  (Primary_if.tck),
                       .ftap_tms                  (Primary_if.tms),
                       .ftap_trst_b               (Primary_if.trst_b),
                       .ftap_pwrdomain_rst_b      (1'b1),
                       .ftap_tdi                  (Primary_if.tdi),
                       .ftap_slvidcode            (pif.ftap_slvidcode),
                       .atap_tdo                  (Primary_if.tdo),
                       .atap_tdoen                (),
                       .fdfx_powergood            (Primary_if.bfm_powergood_rst_b),

                       //Parallel ports of optional data registers
                       //.tdr_data_out              (pif.parallel_data_out),
                       //.tdr_data_in               (pif.parallel_data_in),

                       .tdr_data_out              ({op6B,op34}),
                       .tdr_data_in               ({op6B,op34[31:16],pif.parallel_data_in[15:0]}),

                       //Lock signals
                       .fdfx_secure_policy        (dfxsecure_pins.fdfx_secure_policy),
                       .fdfx_earlyboot_exit       (dfxsecure_pins.fdfx_earlyboot_exit),
                       .fdfx_policy_update        (dfxsecure_pins.fdfx_policy_update),

                       //Control signals to Slave TAPNetwork
                       .sftapnw_ftap_secsel       (pif.atap_secsel),
                       .sftapnw_ftap_enabletdo    (pif.atap_enabletdo),
                       .sftapnw_ftap_enabletap    (pif.atap_enabletap),

                       //Primary JTAG ports to Slave TAPNetwork
                       .sntapnw_ftap_tck          (pif.sntapnw_ftap_tck),
                       .sntapnw_ftap_tms          (pif.sntapnw_ftap_tms),
                       .sntapnw_ftap_trst_b       (pif.sntapnw_ftap_trst_b),
                       .sntapnw_ftap_tdi          (pif.sntapnw_ftap_tdi),
                       .sntapnw_atap_tdo          (pif.sntapnw_atap_tdo),
                       .sntapnw_atap_tdo_en       (pif.ftap_slvidcode[3:0]), // Driving TAP TDO EN to a Random Value

                       //Secondary JTAG Ports
                       .ftapsslv_tck              (pif.atapsecs_tck2),
                       .ftapsslv_tms              (pif.atapsecs_tms2),
                       .ftapsslv_trst_b           (pif.trst2_b),
                       .ftapsslv_tdi              (pif.atapsecs_tdi2),
                       .atapsslv_tdo              (pif.ftapsecs_tdo2),
                       .atapsslv_tdoen            (pif.ftapsecs_tdo2_en),

                       //Secondary JTAG ports to Slave TAPNetwork
                       .sntapnw_ftap_tck2         (pif.sntapnw_ftap_tck2),
                       .sntapnw_ftap_tms2         (pif.sntapnw_ftap_tms2),
                       .sntapnw_ftap_trst2_b      (pif.sntapnw_ftap_trst2_b),
                       .sntapnw_ftap_tdi2         (pif.sntapnw_ftap_tdi2),
                       .sntapnw_atap_tdo2         (pif.sntapnw_atap_tdo2),
                       .sntapnw_atap_tdo2_en      (pif.sntapnw_atap_tdo2_en),

                       //Control Signals  common to WTAP/WTAP Network
                       .sn_fwtap_wrck             (pif.sn_fwtap_wrck),
                       .sn_fwtap_wrst_b           (pif.sn_fwtap_wrst_b),
                       .sn_fwtap_capturewr        (pif.atap_capturewr),
                       .sn_fwtap_shiftwr          (pif.atap_shiftwr),
                       .sn_fwtap_updatewr         (pif.atap_updatewr),
                       .sn_fwtap_rti              (pif.atap_rti),

                       //Control Signals only to WTAP Network
                       .sn_fwtap_selectwir        (pif.atap_wtapnw_selectwir),
                       .sn_awtap_wso              (pif.sn_awtap_wso),
                       .sn_fwtap_wsi              (pif.atap_wtapnw_wsi),

                       //Boundary Scan Signals

                       //Control Signals from fsm
                       .stap_fbscan_tck           (pif.stap_fbscan_tck),
                       .stap_abscan_tdo           (pif.stap_abscan_tdo),
                       .stap_fbscan_capturedr     (pif.stap_fbscan_capturedr),
                       .stap_fbscan_shiftdr       (pif.stap_fbscan_shiftdr),
                       .stap_fbscan_updatedr      (pif.stap_fbscan_updatedr),
                       .stap_fbscan_updatedr_clk  (pif.stap_fbscan_updatedr_clk),

                       //Instructions
                       .stap_fbscan_runbist_en    (pif.stap_fbscan_runbist_en),
                       .stap_fbscan_highz         (pif.stap_fbscan_highz),
                       .stap_fbscan_extogen       (pif.stap_fbscan_extogen),
                       .stap_fbscan_intest_mode   (pif.stap_fbscan_intest_mode),
                       .stap_fbscan_chainen       (pif.stap_fbscan_chainen),
                       .stap_fbscan_mode          (pif.stap_fbscan_mode),
                       .stap_fbscan_extogsig_b    (pif.stap_fbscan_extogsig_b),

                       //1149.6 AC mode
                       .stap_fbscan_d6init        (pif.stap_fbscan_d6init),
                       .stap_fbscan_d6actestsig_b (pif.stap_fbscan_d6actestsig_b),
                       .stap_fbscan_d6select      (pif.stap_fbscan_d6select),

                       //Remote Test Data Register pins
                       .rtdr_tap_tdo              (pif.rtdr_tap_tdo),
                       .tap_rtdr_tdi              (pif.tap_rtdr_tdi),
                       .tap_rtdr_capture          (pif.tap_rtdr_capture),
                       .tap_rtdr_shift            (pif.tap_rtdr_shift),
                       .tap_rtdr_update           (pif.tap_rtdr_update),
                       .tap_rtdr_selectir         (pif.tap_rtdr_selectir),
                       .tap_rtdr_powergood        (pif.tap_rtdr_powergood),
                       .tap_rtdr_irdec            (pif.tap_rtdr_irdec),
                       .tap_rtdr_tck              (pif.tap_rtdr_tck),
                       .tap_rtdr_rti              (pif.tap_rtdr_rti),
					   .stap_isol_en_b            (1'b1),
                       .tap_rtdr_prog_rst_b       (pif.tap_rtdr_prog_rst_b)
                      );

    assign pif.fdfx_powergood                  = Primary_if.bfm_powergood_rst_b;
    assign dfxsecure_pins.fdfx_powergood       = Primary_if.bfm_powergood_rst_b;
    assign dfxsecure_pins.dfxsecure_feature_en = stap_top_inst.i_stap_dfxsecure_plugin.dfxsecure_feature_en;
    assign dfxsecure_pins.visa_all_dis         = stap_top_inst.i_stap_dfxsecure_plugin.visa_all_dis;
    assign dfxsecure_pins.visa_customer_dis    = stap_top_inst.i_stap_dfxsecure_plugin.visa_customer_dis;

    assign pif.parallel_data_out = {op6B,op34};

    //-----------------------------------------
    //Emulate TDO model. SoC will not use this
    //-----------------------------------------
    emulate_stap_tdo tdo_glue (
                               .ftap_tck               (Primary_if.tck),
                               .fdfx_powergood         (Primary_if.bfm_powergood_rst_b),
                               .ftap_trst_b            (Primary_if.trst_b),
                               .atap_secsel            (pif.atap_secsel),
                               .atap_enabletdo         (pif.atap_enabletdo),
                               .atap_enabletap         (pif.atap_enabletap),
                               .atap_wtapnw_selectwir  (pif.atap_wtapnw_selectwir),
                               .stap_fbscan_runbist_en (pif.stap_fbscan_runbist_en),
                               .stap_fbscan_shiftdr    (pif.stap_fbscan_shiftdr),
                               .ftap_tdi               (Primary_if.tdi),
                               .stap_abscan_tdo        (pif.stap_abscan_tdo),
                               .sntapnw_ftap_tdi       (pif.sntapnw_ftap_tdi),
                               .sntapnw_atap_tdo       (pif.sntapnw_atap_tdo),
                               .sntapnw_ftap_tdi2      (pif.sntapnw_ftap_tdi2),
                               .sntapnw_atap_tdo2      (pif.sntapnw_atap_tdo2),
                               .atap_wtapnw_wsi        (pif.atap_wtapnw_wsi),
                               .sn_awtap_wso           (pif.sn_awtap_wso),
                               .rtdr_tap_tdo           (pif.rtdr_tap_tdo),
                               .tap_rtdr_tdi           (pif.tap_rtdr_tdi),
                               .tap_rtdr_capture       (pif.tap_rtdr_capture),
                               .tap_rtdr_shift         (pif.tap_rtdr_shift),
                               .tap_rtdr_update        (pif.tap_rtdr_update),
                               .tap_rtdr_selectir      (pif.tap_rtdr_selectir),
                               .tap_rtdr_powergood     (pif.tap_rtdr_powergood),
                               .tap_rtdr_prog_rst_b    (pif.tap_rtdr_prog_rst_b),
                               .tap_rtdr_irdec         (pif.tap_rtdr_irdec),
                               .tap_rtdr_tck           (pif.tap_rtdr_tck),
                               .tap_rtdr_rti           (pif.tap_rtdr_rti)
                              );

    //Test
    STapTest i_STapTest();

    //--------------------------------------------
    // ACE needs this for dumping FSDB
    //--------------------------------------------
    initial begin : VCD_BLOCK
       if (($test$plusargs("DUMP_VCD")) || ($test$plusargs("VCD"))) begin
          $display("Dump in VCD format ENABLED");
          $vcdplusfile("Dump.vcd");
             $vcdpluson(0,top);
       end
    end : VCD_BLOCK

    initial begin : VPD_BLOCK
       if (($test$plusargs("DUMP_VPD")) || ($test$plusargs("VPD"))) begin
          $display("Dump in VPD format ENABLED");
          $vcdplusfile("Dump.vpd");
             $vcdpluson(0,top);
       end
    end : VPD_BLOCK

    initial begin : FSDB_BLOCK
       if (($test$plusargs("DUMP")) || ($test$plusargs("FSDB"))) begin
          $display("Dump ENABLED");
          $fsdbDumpfile("Dump.fsdb");
          $fsdbDumpSVAon; 
          `ifdef POWERVCD
          $fsdbDumpvars(stap,"+all");
          `else
          $fsdbDumpvars("+all");
          `endif
        $fsdbDumpSVAoff;
       end
    end : FSDB_BLOCK

endmodule
