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
  dfx_mbist_if mbist_if_0();
  dfx_debug_if dfx_debug_if_0();
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P0] = jtag_if_0.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P0] = jtag_if_0.EXIT1_DR_Event;
  end
  int p0 = 0;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_0(p0, jtag_if_0);
  dfx_mbist_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_mbist_test_island_instance_0(p0, mbist_if_0);
  dfx_debug_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_debug_test_island_instance_0(p0, dfx_debug_if_0);

  tck_generator tck_gen_1(1, tck_pi[1]); // or use your own TCK generator
  dfx_jtag_if jtag_if_1(tck_pi[1]);
  dfx_mbist_if mbist_if_1();
  dfx_debug_if dfx_debug_if_1();
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P1] = jtag_if_1.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P1] = jtag_if_1.EXIT1_DR_Event;
  end
  int p1 = 1;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_1(p1, jtag_if_1);
  dfx_mbist_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_mbist_test_island_instance_1(p1, mbist_if_1);
  dfx_debug_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_debug_test_island_instance_1(p1, dfx_debug_if_1);

  tck_generator tck_gen_2(2, tck_pi[2]); // or use your own TCK generator
  dfx_jtag_if jtag_if_2(tck_pi[2]);
  dfx_mbist_if mbist_if_2();
  dfx_debug_if dfx_debug_if_2();
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P2] = jtag_if_2.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P2] = jtag_if_2.EXIT1_DR_Event;
  end
  int p2 = 2;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_2(p2, jtag_if_2);
  dfx_mbist_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_mbist_test_island_instance_2(p2, mbist_if_2);
  dfx_debug_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_debug_test_island_instance_2(p2, dfx_debug_if_2);

  tck_generator tck_gen_3(3, tck_pi[3]); // or use your own TCK generator
  dfx_jtag_if jtag_if_3(tck_pi[3]);
  dfx_mbist_if mbist_if_3();
  dfx_debug_if dfx_debug_if_3();
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P3] = jtag_if_3.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P3] = jtag_if_3.EXIT1_DR_Event;
  end
  int p3 = 3;
  dfx_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_test_island_instance_3(p3, jtag_if_3);
  dfx_mbist_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_mbist_test_island_instance_3(p3, mbist_if_3);
  dfx_debug_test_island #(.TAP_NUM_PORTS(NUM_JTAG_PORTS)) dfx_debug_test_island_instance_3(p3, dfx_debug_if_3);

  reg pgr_b;

  wire tck, tms, trst_b, tdi, tdo,
       tck2, tms2, trst_b2, tdi2, tdo2, tdo2_en,
       tck3, tms3, trst_b3, tdi3, tdo3, tdo3_en,
       tck4, tms4, trst_b4, tdi4, tdo4, tdo4_en;
  wire powergoodrst_b = pgr_b;

  mtap_tapnw_taps tap_rtl(.*);

  // Assign from/to design.
  assign tck0 = dfx_debug_if_0.jtag_select === 2'b11 ? mbist_if_0.tck : jtag_if_0.tck;
  assign tms0 = dfx_debug_if_0.jtag_select === 2'b11 ? mbist_if_0.tms : jtag_if_0.tms;
  assign tdi0 = dfx_debug_if_0.jtag_select === 2'b11 ? mbist_if_0.tdi : jtag_if_0.tdi;
  assign trst0 = dfx_debug_if_0.jtag_select === 2'b11 ? mbist_if_0.trst : jtag_if_0.trst;
  assign powergood_rst_b = jtag_if_0.powergood_rst_b;

  assign jtag_if_0.tdo  = dfx_debug_if_0.jtag_select === 2'b11 ? 1'bz : tdo0;
  assign mbist_if_0.tdo = dfx_debug_if_0.jtag_select === 2'b11 ? tdo0 : 1'bz;

  assign tck1 = dfx_debug_if_1.jtag_sec_select === 2'b11 ? mbist_if_1.tck : jtag_if_1.tck;
  assign tms1 = dfx_debug_if_1.jtag_sec_select === 2'b11 ? mbist_if_1.tms : jtag_if_1.tms;
  assign tdi1 = dfx_debug_if_1.jtag_sec_select === 2'b11 ? mbist_if_1.tdi : jtag_if_1.tdi;
  assign trst1 = dfx_debug_if_1.jtag_select === 2'b11 ? mbist_if_1.trst : jtag_if_1.trst;

  assign jtag_if_1.tdo = dfx_debug_if_1.jtag_sec_select === 2'b11 ? 1'bz : tdo1;
  assign mbist_if_1.tdo = dfx_debug_if_1.jtag_sec_select === 2'b11 ? tdo1 : 1'bz;

  assign tck2 = dfx_debug_if_2.jtag_sec_select === 2'b11 ? mbist_if_2.tck : jtag_if_2.tck;
  assign tms2 = dfx_debug_if_2.jtag_sec_select === 2'b11 ? mbist_if_2.tms : jtag_if_2.tms;
  assign tdi2 = dfx_debug_if_2.jtag_sec_select === 2'b11 ? mbist_if_2.tdi : jtag_if_2.tdi;
  assign trst2 = dfx_debug_if_2.jtag_select === 2'b11 ? mbist_if_2.trst : jtag_if_2.trst;

  assign jtag_if_2.tdo = dfx_debug_if_2.jtag_sec_select === 2'b11 ? 1'bz : tdo2;
  assign mbist_if_2.tdo = dfx_debug_if_2.jtag_sec_select === 2'b11 ? tdo2 : 1'bz;

  assign tck3 = dfx_debug_if_3.jtag_sec_select === 2'b11 ? mbist_if_3.tck : jtag_if_3.tck;
  assign tms3 = dfx_debug_if_3.jtag_sec_select === 2'b11 ? mbist_if_3.tms : jtag_if_3.tms;
  assign tdi3 = dfx_debug_if_3.jtag_sec_select === 2'b11 ? mbist_if_3.tdi : jtag_if_3.tdi;
  assign trst3 = dfx_debug_if_3.jtag_select === 2'b11 ? mbist_if_3.trst : jtag_if_3.trst;

  assign jtag_if_3.tdo = dfx_debug_if_3.jtag_sec_select === 2'b11 ? 1'bz : tdo3;
  assign mbist_if_3.tdo = dfx_debug_if_3.jtag_sec_select === 2'b11 ? tdo3 : 1'bz;

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
