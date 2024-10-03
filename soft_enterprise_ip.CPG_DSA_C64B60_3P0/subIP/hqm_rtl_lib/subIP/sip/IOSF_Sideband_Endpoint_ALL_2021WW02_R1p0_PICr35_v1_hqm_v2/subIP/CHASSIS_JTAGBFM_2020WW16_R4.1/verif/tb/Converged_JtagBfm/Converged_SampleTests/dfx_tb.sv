// =====================================================================================================
// FileName          : dfx_tb.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon Dec  8 10:11:02 CST 2014
// Modification Date : Thu Jan 29 21:59:26 CST 2015
// Modification Date : Thu Apr 30 16:06:55 CDT 2015
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx top level module
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TB_SV
`define DFX_TB_SV

// The number of TAP/JTAG ports is 4.

module dfx_tb;

  parameter NUM_JTAG_PORTS = 4;

  import ovm_pkg::*;

  logic [NUM_JTAG_PORTS - 1 : 0] tck_pi; // TCK signals for JTAG ports 0, 1, ..., NUM_JTAG_PORTS - 1

  tck_generator tck_gen_0(0, tck_pi[0]); // or use your own TCK generator
  dfx_jtag_if jtag_if_0(tck_pi[0]);
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P0] = jtag_if_0.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P0] = jtag_if_0.EXIT1_DR_Event;
  end
  int p0 = 0;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_0(p0, jtag_if_0);

  tck_generator tck_gen_1(1, tck_pi[1]); // or use your own TCK generator
  dfx_jtag_if jtag_if_1(tck_pi[1]);
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P1] = jtag_if_1.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P1] = jtag_if_1.EXIT1_DR_Event;
  end
  int p1 = 1;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_1(p1, jtag_if_1);

  tck_generator tck_gen_2(2, tck_pi[2]); // or use your own TCK generator
  dfx_jtag_if jtag_if_2(tck_pi[2]);
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P2] = jtag_if_2.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P2] = jtag_if_2.EXIT1_DR_Event;
  end
  int p2 = 2;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_2(p2, jtag_if_2);

  tck_generator tck_gen_3(3, tck_pi[3]); // or use your own TCK generator
  dfx_jtag_if jtag_if_3(tck_pi[3]);
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P3] = jtag_if_3.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P3] = jtag_if_3.EXIT1_DR_Event;
  end
  int p3 = 3;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_3(p3, jtag_if_3);

  reg pgr_b;

  // Start of section needed for instantiation of mtap_tapnw_taps.
  //
  wire tck, tms, trst_b, tdi, tdo,
       tck2, tms2, trst_b2, tdi2, tdo2, tdo2_en,
       tck3, tms3, trst_b3, tdi3, tdo3, tdo3_en,
       tck1, tms4, trst_b4, tdi4, tdo4, tdo4_en;
  wire powergoodrst_b = pgr_b;
`include "tb_param.inc"
  reg [NO_OF_TAP -2:0]  sec_select;
  reg [NO_OF_TAP -2:0]  enable_tdo;
  reg [NO_OF_TAP -2:0]  enable_tap;
  reg [3:0]             vercode;
  reg [(NO_OF_TAP)-1:0] [31:0]slvidcode;
  initial begin
    vercode  = $random;
    for (int i=0; i<NO_OF_TAP; i++)
      slvidcode[i] = $random;
  end
  // mtap_tapnw_taps tap_rtl(.*);
    //-----------------------------
    //Top Module Instantiation
    //-----------------------------
    mtap_tapnw_taps mtap_tapnw_taps_inst (
                        //PRIMARY JTAG PORT
                       .tck(tck),
                       .tms(tms),
                       .trst_b(trst_b),
                       .tdi(tdi),
                       .tdo(tdo),

                        //Secondary JTAG PORT
                       .tck2(tck2),
                       .tms2(tms2),
                       .trst_b2(trst_b2),
                       .tdi2(tdi2),
                       .tdo2(tdo2),
                       .tdo2_en(),

                        //Teritiary0 JTAG PORT
                       .tck3(tck3),
                       .tms3(tms3),
                       .trst_b3(trst_b3),
                       .tdi3(tdi3),
                       .tdo3(tdo3),
                       .tdo3_en(),

                        //Teritiary1 JTAG PORT
                       .tck4(tck4),
                       .tms4(tms4),
                       .trst_b4(trst_b4),
                       .tdi4(tdi4),
                       .tdo4(tdo4),
                       .tdo4_en(),

                        //From SoC

                       .powergoodrst_b  (powergood_rst_b)
                       );



 // mtap_tapnw_taps mtap_tapnw_taps_inst(
 //   //PRIMARY JTAG PORT
 //   .tck(tck),
 //   .tms(tms),
 //   .trst_b(trst_b),
 //   .tdi(tdi),
 //   .tdo(tdo),
 //    //Secondary JTAG PORT
 //   .tck2(tck2),
 //   .tms2(tms2),
 //   .trst_b2(trst_b2),
 //   .tdi2(tdi2),
 //   .tdo2(tdo2),
 //   .tdo2_en(),
 //   .vercode(vercode),
 //   .slvidcode_mtap(slvidcode[0]),
 //   .slvidcode_stap0(slvidcode[1]),
 //   .slvidcode_stap1(slvidcode[2]),
 //   .slvidcode_stap2(slvidcode[3]),
 //   .slvidcode_stap3(slvidcode[4]),
 //   .slvidcode_stap4(slvidcode[5]),
 //   .slvidcode_stap5(slvidcode[6]),
 //   .slvidcode_stap6(slvidcode[7]),
 //   .slvidcode_stap7(slvidcode[8]),
 //    //TAPNW controls from MTAP need to be brought out for OVM env
 //   .atap_secsel(sec_select),
 //   .atap_enabletdo(enable_tdo),
 //   .atap_enabletap(enable_tap),
 //    //From SoC
 //   .powergoodrst_b(powergood_rst_b));
  //
  // End of section needed for instantiation of mtap_tapnw_taps.

  // Assign from/to design.
  assign tck = jtag_if_0.tck;
  assign tms = jtag_if_0.tms;
  assign tdi = jtag_if_0.tdi;
  assign trst_b = jtag_if_0.trst;
  assign powergood_rst_b = jtag_if_0.powergood_rst_b;
  assign jtag_if_0.tdo  = tdo;

  assign tck2 = jtag_if_1.tck;
  assign tms2 = jtag_if_1.tms;
  assign tdi2 = jtag_if_1.tdi;
  assign trst_b2 = jtag_if_1.trst;
  assign jtag_if_1.tdo = tdo2;
  //tdo2_en

  assign tck3 = jtag_if_2.tck;
  assign tms3 = jtag_if_2.tms;
  assign tdi3 = jtag_if_2.tdi;
  assign trst_b3 = jtag_if_2.trst;
  assign jtag_if_2.tdo = tdo3;
  //tdo3_en

  assign tck4 = jtag_if_3.tck;
  assign tms4 = jtag_if_3.tms;
  assign tdi4 = jtag_if_3.tdi;
  assign trst_b4 = jtag_if_3.trst;
  assign jtag_if_3.tdo = tdo4;
  //tdo2_en

  initial begin
    pgr_b = 1'b1;
    #1ns pgr_b = 1'b0;
    #1ns pgr_b = 1'b1;
  end

  initial begin
    set_config_int("*.tap_driver_*", "dfx_tap_initial_delay_TAP_PORT_P0", 1); // set delay if desired; 1 is the default if not set
    set_config_int("*.tap_driver_*", "dfx_tap_initial_delay_TAP_PORT_P2", 1); // set delay if desired; 1 is the default if not set
    jtag_if_0.trst = 1; // force TAPs out of test reset (for now)
    jtag_if_1.trst = 1; // force TAPs out of test reset (for now)
    jtag_if_2.trst = 1; // force TAPs out of test reset (for now)
    jtag_if_3.trst = 1; // force TAPs out of test reset (for now)
  end

endmodule // dfx_tb

`endif // `ifndef DFX_TB_SV
