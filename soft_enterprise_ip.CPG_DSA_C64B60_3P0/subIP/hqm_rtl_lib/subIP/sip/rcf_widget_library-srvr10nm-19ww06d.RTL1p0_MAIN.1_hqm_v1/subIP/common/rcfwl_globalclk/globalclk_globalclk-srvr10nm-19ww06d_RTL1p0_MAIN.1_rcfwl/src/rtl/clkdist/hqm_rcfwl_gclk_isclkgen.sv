
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///

module hqm_rcfwl_gclk_isclkgen (
    
    input logic  ick_ssc_lock,
    input logic  ick_nssc_lock,
    input logic  int_pwell_pok_early_sus,

    input logic  rosc_60_clk,
    input logic  rosc_120_clk,
    input logic  rosc_medium_clk,
    input logic  rosc_slow_clk,

    input logic  ck_nssc_dco_div2,
    input logic  ck_ssc_dco_div2,
    input logic  ck_ssc_dco_div3,
    input logic  clk100_ref, 
    input logic  krm_xosc_clk,

    input logic  [3:0] punit_ck_div,
    input logic  [3:0] northpeak_ck_div,
    input logic  [3:0] ncpm_ck_div,
    input logic  [3:0] rclk_ck_div,
    input logic  [3:0] sa_ck_div,
    input logic        sa_ck_use_div3, 
    input logic        sa_ck_use_div6, 
    input logic        sa_ck_use_nssc, 
    input logic  [2:0] svid_ck_div,
    input logic  [1:0] sel_flex_base, 
    input logic  [3:0] flex_ck_div0,
    input logic  [3:0] flex_ck_div1,
    input logic        sel_ext_100,
    input logic  [2:0] sel_wm_ssc,
    input logic  [3:0] csme_ck_div,
    input logic  [3:0] ie_ck_div,

    output logic       ck_psf400,
    output logic       ck_psf300,
    output logic       ck_psf200,
    output logic       ck_psf133,
    output logic       ck_psf266,
    output logic       ck_mdng,
    output logic       ck_smbu,
    output logic       ck_csme2x,
    output logic       ck_csme1x,
    output logic       ck_ie2x,
    output logic       ck_ie1x,
    output logic       ck_punit,
    output logic       ck_northpeak,
    output logic       ck_ncpm,
    output logic       ck_sa,
    output logic       ck_sahalf,
    output logic       ck_ref_corepll,
    output logic       ck_2x,
    output logic       ck_1x,
    output logic       ck_ref_ddr,
    output logic       ck_svid,
    output logic       ck_flex_div0,
    output logic       ck_flex_div1,
    output logic       ck_ref_usb2,
    output logic       ck_ref_wm8x_pci,
    output logic       ck_ref_wm8x_sata,
    output logic       ck_ext_ref,
    output logic       ck_ext_ref_nssc,
    output logic       ck_ext_ref_ssc,
    output logic       ck_sus_25m,
    output logic       ck_ssc_100,
    output logic       ck_nssc_24,
    output logic       ck_emmc,
    output logic       ck_nssc_120,
    output logic       ck_nssc_480,
    output logic       ck_nssc_25,

    input  logic       tap_sel_test_clock, 
    input  logic       tap_test_clock,
    input  logic       tap_clock_halt, 
    input  logic       tap_clock_reset_b, 
    input  logic       tap_local_tdr_enable, 
    input  logic       ie_clk_mux_sel,
    input  logic       csme_clk_mux_sel,
    output logic       ie_switch_complete,
    output logic       csme_switch_complete,
    output logic       syncronize_nssc_clk_div_post_mux_b,
    output logic       syncronize_ssc_clk_div_post_mux_b,
    output logic       syncronize_ssc_ref_clk_div_post_mux_b,
    output logic       ick_nssc_lock_dly_out,
    output logic       ick_ssc_lock_dly_out
);




logic [3:0] tap_clock_halt_ssc_meta;
logic [3:0] tap_clock_halt_nssc_meta;
logic ck_nssc_dco_div2_gated;
logic ck_nssc_dco_div2_ref;
logic ck_nssc_dco_div2_mux;
logic ck_nssc_dco_div4_ref;
logic ck_nssc_dco_div4;
logic ck_ssc_dco_div4;
logic ck_ssc_dco_div4_ref;
logic ck_nssc_96;
logic ck_nssc_800;
logic ck_nssc_200;
logic ck_nssc_100;
logic ck_ssc_dco_mux_ungated;
logic ck_ssc_dco_mux_ref_ungated;
logic ck_ssc_dco_mux_premux;
logic ck_ssc_dco_mux_ref;
logic ck_ssc_dco_mux;
logic ck_ssc_dco_div2_mux;
logic ck_ssc_dco_div2_ungated;
logic ck_ssc_400;
logic ck_flex0_in;
logic ck_flex1_in;
logic ick_ssc_lock_mux;
logic [9:0] ick_nssc_lock_dly;
logic [9:0] ick_ssc_lock_dly;
logic syncronize_nssc_clk_div_b;
logic syncronize_nssc_ref_clk_div_b;
logic syncronize_ssc_clk_div_b;
logic syncronize_ssc_ref_clk_div_b;
logic ck_psf300_pre_glitch;
logic ck_psf200_pre_glitch;
logic ck_emmc_pre_glitch;
logic ck_psf133_pre_glitch;
logic ck_psf266_pre_glitch;
logic ck_nssc_100_pre_glitch;
logic ck_nssc_25_pre_glitch;
logic ck_mdng_pre_glitch;
logic ck_csme2x_pre_glitch;
logic ck_csme1x_pre_glitch;
logic ck_ie2x_pre_glitch;
logic ck_ie1x_pre_glitch;
logic ck_punit_pre_glitch;
logic ck_northpeak_pre_glitch;
logic ck_ncpm_pre_glitch;
logic ck_sa_pre_glitch;
logic ck_psf400_pre_glitch;
logic ck_ssc_400_pre_glitch;
logic ck_ref_usb2_pre_glitch;
logic ick_ssc_lock_ringosc1;
logic ick_ssc_lock_ringosc2;
logic ick_ssc_lock_ext_ref;
logic [3:0] ick_ssc_lock_dco;
logic [3:0] ick_ssc_lock_dco_early;
logic [3:0] ick_nssc_lock_dco;
logic [3:0] ick_nssc_lock_dco_early;
logic ck_nssc_240;
logic ck_nssc_480_ref;
logic ie2x_switch_complete;
logic ie1x_switch_complete;
logic csme2x_switch_complete;
logic csme1x_switch_complete;

// Gate partition tap logic with a local TDR bit to reduce risk of clock cratering
logic tap_sel_test_clock_gated;
logic tap_clock_halt_gated; 
logic tap_clock_reset_b_gated; 
assign tap_sel_test_clock_gated = tap_sel_test_clock&tap_local_tdr_enable;
assign tap_clock_halt_gated = tap_clock_halt&tap_local_tdr_enable; 
assign tap_clock_reset_b_gated = tap_clock_reset_b|~tap_local_tdr_enable; 

// Hold reset during pre power-good state and Create a pulse as the pll locks
// Also create a reset pulse as the PLL unlocks
assign syncronize_nssc_clk_div_b = int_pwell_pok_early_sus & tap_clock_reset_b_gated & ~((ick_nssc_lock & ick_nssc_lock_dco_early[3] & ~ick_nssc_lock_dly[3]) | (~ick_nssc_lock_dly[6] & ick_nssc_lock_dly[8]));
assign syncronize_nssc_clk_div_post_mux_b = int_pwell_pok_early_sus & tap_clock_reset_b_gated & ~(ick_nssc_lock & ick_nssc_lock_dco_early[3] & ~ick_nssc_lock_dly[3]);
assign syncronize_nssc_ref_clk_div_b = int_pwell_pok_early_sus & ~((ick_nssc_lock & ick_nssc_lock_dco_early[3] & ~ick_nssc_lock_dly[3]) | (~ick_nssc_lock_dly[6] & ick_nssc_lock_dly[8]));

assign syncronize_ssc_clk_div_b = int_pwell_pok_early_sus & tap_clock_reset_b_gated & ~((ick_ssc_lock & ick_ssc_lock_dco_early[3] & ~ick_ssc_lock_dly[3]) |  (~ick_ssc_lock_dly[6] & ick_ssc_lock_dly[8]));
assign syncronize_ssc_clk_div_post_mux_b = int_pwell_pok_early_sus & tap_clock_reset_b_gated & ~(ick_ssc_lock & ick_ssc_lock_dco_early[3] & ~ick_ssc_lock_dly[3]);
assign syncronize_ssc_ref_clk_div_b = int_pwell_pok_early_sus & ~((ick_ssc_lock & ick_ssc_lock_dco_early[3] & ~ick_ssc_lock_dly[3]) |  (~ick_ssc_lock_dly[6] & ick_ssc_lock_dly[8]));
assign syncronize_ssc_ref_clk_div_post_mux_b = int_pwell_pok_early_sus & ~(ick_ssc_lock & ick_ssc_lock_dco_early[3] & ~ick_ssc_lock_dly[3]);
assign ick_ssc_lock_mux         =  (ick_ssc_lock&~sa_ck_use_nssc) | (ick_nssc_lock&sa_ck_use_nssc);

hqm_rcfwl_gclk_iclk_clkdiv ck_nssc_dco_div4_ref_div (
    .clk    (ck_nssc_dco_div2_ref),
    .rst_b  (syncronize_nssc_ref_clk_div_b),
    .div    (4'h2),
    .clkdiv (ck_nssc_dco_div4_ref)
);

hqm_rcfwl_gclk_iclk_clkdiv ck_nssc_dco_div4_div (
    .clk    (ck_nssc_dco_div2_mux),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'h2),
    .clkdiv (ck_nssc_dco_div4)
);

c73plllchpc73p1plllc_ctech_clock_gate nssc_clkgate_div2 ( 
   .clk(ck_nssc_dco_div2), 
   .en(ick_nssc_lock_dly[5] & ~tap_clock_halt_nssc_meta[3]),  // lintra s-60008
   .te(1'b0), 
   .enclk(ck_nssc_dco_div2_gated)
);
c73plllchpc73p1plllc_ctech_clock_mux tap_test_clk_nssc_mux_div2 (
    .s(tap_sel_test_clock_gated), 
    .d1(tap_test_clock),
    .d2(ck_nssc_dco_div2_gated), 
    .o(ck_nssc_dco_div2_mux)
);
// Do not want tap control on the ref clock gates
c73plllchpc73p1plllc_ctech_clock_gate nssc_clkgate_ref ( 
   .clk(ck_nssc_dco_div2), 
   .en(ick_nssc_lock_dly[5]),  // lintra s-60008
   .te(1'b0), 
   .enclk(ck_nssc_dco_div2_ref) 
);

c73plllchpc73p1plllc_ctech_clock_mux saclk_nssc_mux (
    .s(sa_ck_use_nssc), 
    .d1(ck_nssc_dco_div2), 
    .d2(ck_ssc_dco_div2),
    .o(ck_ssc_dco_div2_mux)
);
// This MUX is extra and is only required because I need to use ssc_div2 in the lock reset circuits below. 
// If I don't do that I never actually get the div4 in sync between the nssc and ssc PLLs.
c73plllchpc73p1plllc_ctech_clock_mux saclk_extra_div3_mux (
    .s(sa_ck_use_div3), 
    .d1(ck_ssc_dco_div3), 
    .d2(ck_ssc_dco_div2_mux),
    .o(ck_ssc_dco_div2_ungated)
);

// Divides by 2 or 3 
hqm_rcfwl_gclk_iclk_clkdiv ck_ssc_dco_div4_div (
    .clk    (ck_ssc_dco_mux),
    .rst_b  (int_pwell_pok_early_sus),
    .div    ({1'b0,1'b0,1'b1,sa_ck_use_div6}),
    .clkdiv (ck_ssc_dco_div4)
);
hqm_rcfwl_gclk_iclk_clkdiv ck_ssc_dco_div4_ref_div (
    .clk    (ck_ssc_dco_mux_ref),
    .rst_b  (int_pwell_pok_early_sus),
    .div    ({1'b0,1'b0,1'b1,sa_ck_use_div6}),
    .clkdiv (ck_ssc_dco_div4_ref)
);

c73plllchpc73p1plllc_ctech_clock_mux saclk_mux (
    .s(sa_ck_use_div3), 
    .d1(ck_ssc_dco_mux),  // This is the div3 path
    .d2(ck_ssc_dco_div4),
    .o(ck_ssc_dco_mux_ungated)
);

c73plllchpc73p1plllc_ctech_clock_mux saclk_ref_mux (
    .s(sa_ck_use_div3), 
    .d1(ck_ssc_dco_mux), // This is the div3 path
    .d2(ck_ssc_dco_div4_ref),
    .o(ck_ssc_dco_mux_ref_ungated)
);

// When we lock the ssc PLL we need to 
//    1) wait until the ring oscillator has been disabled - this comes from metafloping to RO slow and then back
//        -- non deterministic (but aligned)
//        -- if we wanted deterniminism we would have to delay 64 clocks at full frequency to ensure that the Glitchfree MUXs have switched.
//    2) shut off the ssc clock 
//    3) reset the dividers
//    4) reenable the ssc clock
iclk_sync_2ff ssclock_metaflop_rosc1 (
    .ck (rosc_medium_clk),
    .rb (int_pwell_pok_early_sus),
    .d  (ick_ssc_lock_mux),
    .o  (ick_ssc_lock_ringosc1)
);
always @ (negedge rosc_medium_clk or negedge int_pwell_pok_early_sus) begin
   if (~int_pwell_pok_early_sus) begin
      ick_ssc_lock_ringosc2 <= 0;
   end   
   else begin
      ick_ssc_lock_ringosc2 <= ick_ssc_lock_ringosc1;
   end
end
iclk_sync_2ff ssclock_metaflop_ext_ref (
    .ck (ck_ext_ref),
    .rb (int_pwell_pok_early_sus),
    .d  (ick_ssc_lock_ringosc2),
    .o  (ick_ssc_lock_ext_ref)
);
iclk_sync_2ff ssclock_metaflop_dco_early [3:0] (
    .ck (ck_ssc_dco_div2_ungated),
    .rb (int_pwell_pok_early_sus),
    .d  ({ick_ssc_lock_dco_early[2:0], ick_ssc_lock_ringosc2}),
    .o  (ick_ssc_lock_dco_early[3:0])
);
iclk_sync_2ff ssclock_metaflop_dco [3:0] (
    .ck (ck_ssc_dco_div2_ungated),
    .rb (int_pwell_pok_early_sus),
    .d  ({ick_ssc_lock_dco[2:0], ick_ssc_lock_ext_ref}),
    .o  (ick_ssc_lock_dco[3:0])
);
always @ (posedge ck_ssc_dco_div2_ungated or negedge int_pwell_pok_early_sus) begin
   if (~int_pwell_pok_early_sus) begin
      ick_ssc_lock_dly[9:0]  <= 0;
   end   
   else begin
      ick_ssc_lock_dly[9:0]  <= {ick_ssc_lock_dly[8:0], ick_ssc_lock_dco[3]};
   end   
end
always_comb ick_ssc_lock_dly_out = ick_ssc_lock_dly[9];
iclk_sync_2ff tap_halt_ssc_metaflop [3:0] (
    .ck (ck_ssc_dco_div2_ungated),
    .rb (int_pwell_pok_early_sus),
    .d  ({tap_clock_halt_ssc_meta[2:0], tap_clock_halt_gated}),
    .o  (tap_clock_halt_ssc_meta[3:0])
);
c73plllchpc73p1plllc_ctech_clock_gate ssc_clkgate ( 
   .clk(ck_ssc_dco_div2_ungated), 
   .en(ick_ssc_lock_dly[5] & ~tap_clock_halt_ssc_meta[3]),  // lintra s-60008
   .te(1'b0), 
   .enclk(ck_ssc_dco_mux_premux) 
);
c73plllchpc73p1plllc_ctech_clock_mux tap_test_clk_ssc_mux (
    .s(tap_sel_test_clock_gated), 
    .d1(tap_test_clock),
    .d2(ck_ssc_dco_mux_premux), 
    .o(ck_ssc_dco_mux)
);
// Do not want tap control on the ref clock gates
c73plllchpc73p1plllc_ctech_clock_gate ssc_clkgate_ref ( 
   .clk(ck_ssc_dco_div2_ungated), 
   .en(ick_ssc_lock_dly[5]),  // lintra s-60008
   .te(1'b0), 
   .enclk(ck_ssc_dco_mux_ref) 
);

// When we lock the nssc PLL we need to 
//    1) wait until the ring oscillator has been disabled - this comes from metafloping to RO slow and then back
//        -- non deterministic (but aligned)
//        -- if we wanted deterniminism we would have to delay 64 clocks at full frequency to ensure that the Glitchfree MUXs have switched.
//    2) shut off the ssc clock 
//    3) reset the dividers
//    4) reenable the ssc clock
logic ick_nssc_lock_ringosc1;
logic ick_nssc_lock_ringosc2;
logic ick_nssc_lock_ext_ref;
iclk_sync_2ff nssclock_metaflop_rosc1 (
    .ck (rosc_medium_clk),
    .rb (int_pwell_pok_early_sus),
    .d  (ick_nssc_lock),
    .o  (ick_nssc_lock_ringosc1)
);
always @ (negedge rosc_medium_clk or negedge int_pwell_pok_early_sus) begin
   if (~int_pwell_pok_early_sus) begin
      ick_nssc_lock_ringosc2 <= 0;
   end   
   else begin
      ick_nssc_lock_ringosc2 <= ick_nssc_lock_ringosc1;
   end
end
iclk_sync_2ff nssclock_metaflop_ext_ref (
    .ck (ck_ext_ref),
    .rb (int_pwell_pok_early_sus),
    .d  (ick_nssc_lock_ringosc2),
    .o  (ick_nssc_lock_ext_ref)
);
iclk_sync_2ff nssclock_metaflop_dco_early [3:0] (
    .ck (ck_nssc_dco_div2),
    .rb (int_pwell_pok_early_sus),
    .d  ({ick_nssc_lock_dco_early[2:0], ick_nssc_lock_ringosc2}),
    .o  (ick_nssc_lock_dco_early[3:0])
);
iclk_sync_2ff nssclock_metaflop_dco [3:0] (
    .ck (ck_nssc_dco_div2),
    .rb (int_pwell_pok_early_sus),
    .d  ({ick_nssc_lock_dco[2:0], ick_nssc_lock_ext_ref}),
    .o  (ick_nssc_lock_dco[3:0])
);
always @ (posedge ck_nssc_dco_div2 or negedge int_pwell_pok_early_sus) begin
   if (~int_pwell_pok_early_sus) begin
      ick_nssc_lock_dly[9:0] <= 0;
   end
   else begin
      ick_nssc_lock_dly[9:0]  <= {ick_nssc_lock_dly[8:0], ick_nssc_lock_dco[3]};
   end   
end
always_comb ick_nssc_lock_dly_out = ick_nssc_lock_dly[9];
iclk_sync_2ff tap_halt_nssc_metaflop [3:0] (
    .ck (ck_nssc_dco_div2),
    .rb (int_pwell_pok_early_sus),
    .d  ({tap_clock_halt_nssc_meta[2:0], tap_clock_halt_gated}),
    .o  (tap_clock_halt_nssc_meta[3:0])
);

hqm_rcfwl_gclk_iclk_clkdiv nssc_480_ref_clkdiv (
    .clk    (ck_nssc_dco_div4_ref),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'h5),
    .clkdiv (ck_nssc_480_ref)
);

hqm_rcfwl_gclk_iclk_clkdiv nssc_96_clkdiv (
    .clk    (ck_nssc_480_ref),
    .rst_b  (syncronize_nssc_ref_clk_div_b),
    .div    (4'd5),
    .clkdiv (ck_nssc_96)
);

hqm_rcfwl_gclk_iclk_clkdiv nssc_480_clkdiv (
    // Changing this to dco_div4 from dco_div4_ref so HVM halt will work.
    .clk    (ck_nssc_dco_div4),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'h5),
    .clkdiv (ck_nssc_480)
);

hqm_rcfwl_gclk_iclk_clkdiv nssc_800_clkdiv (
    .clk    (ck_nssc_dco_div4),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'h3),
    .clkdiv (ck_nssc_800)
);

hqm_rcfwl_gclk_iclk_clkdiv nssc_300_clkdiv (
    .clk    (ck_nssc_dco_div4),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'h8),
    .clkdiv (ck_psf300_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv ck_240_clkdiv (
    .clk    (ck_nssc_480),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd2),
    .clkdiv (ck_nssc_240)
);

hqm_rcfwl_gclk_iclk_clkdiv ck_24_clkdiv (
    .clk    (ck_nssc_240),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd10),
    .clkdiv (ck_nssc_24)
);

hqm_rcfwl_gclk_iclk_clkdiv ck_nssc_120_clkdiv (
    .clk    (ck_nssc_480),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd4),
    .clkdiv (ck_nssc_120)
);

hqm_rcfwl_gclk_iclk_clkdiv ck_emmc_clkdiv (
    .clk    (ck_nssc_800),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd2),
    .clkdiv (ck_emmc_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv psf_200_clkdiv (
    .clk    (ck_nssc_800),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd4),
    .clkdiv (ck_nssc_200)
);

assign ck_psf200_pre_glitch = ck_nssc_200;

hqm_rcfwl_gclk_iclk_clkdiv psf_133_clkdiv (
    .clk    (ck_nssc_800),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd6),
    .clkdiv (ck_psf133_pre_glitch)
);

// Only used by SATA
hqm_rcfwl_gclk_iclk_clkdiv psf_266_clkdiv (
    .clk    (ck_nssc_800),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd3),
    .clkdiv (ck_psf266_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv nssc_100_clkdiv (
    .clk    (ck_nssc_800),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd8),
    .clkdiv (ck_nssc_100_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv nssc_25_clkdiv (
    .clk    (ck_nssc_100_pre_glitch),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd4),
    .clkdiv (ck_nssc_25_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv mdng_clkdiv (
    .clk    (ck_nssc_800),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd10),
    .clkdiv (ck_mdng_pre_glitch)
);

assign  ck_smbu = ck_nssc_100;

// These 4 configurable dividers need to run 4800
hqm_rcfwl_gclk_iclk_clkdiv punit_clkdiv (
    .clk    (ck_nssc_dco_div2_mux),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (punit_ck_div),
    .clkdiv (ck_punit_pre_glitch)
);
hqm_rcfwl_gclk_iclk_clkdiv npk_clkdiv (
    .clk    (ck_nssc_dco_div2_mux),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (northpeak_ck_div),
    .clkdiv (ck_northpeak_pre_glitch)
);
hqm_rcfwl_gclk_iclk_clkdiv ncpm_clkdiv (
    .clk    (ck_nssc_dco_div2_mux),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (ncpm_ck_div),
    .clkdiv (ck_ncpm_pre_glitch)
);
hqm_rcfwl_gclk_iclk_clkdiv csme2_clkdiv (
    .clk    (ck_nssc_dco_div2_mux),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (csme_ck_div),
    .clkdiv (ck_csme2x_pre_glitch)
);
hqm_rcfwl_gclk_iclk_clkdiv csme1_clkdiv (
    .clk    (ck_csme2x_pre_glitch),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd2),
    .clkdiv (ck_csme1x_pre_glitch)
);
hqm_rcfwl_gclk_iclk_clkdiv ie2_clkdiv (
    .clk    (ck_nssc_dco_div2_mux),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (ie_ck_div),
    .clkdiv (ck_ie2x_pre_glitch)
);
hqm_rcfwl_gclk_iclk_clkdiv ie1_clkdiv (
    .clk    (ck_ie2x_pre_glitch),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (4'd2),
    .clkdiv (ck_ie1x_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv rclk_clkdiv (
    // For dco/div4 case
    // This div 5 clock is used for 8 G to get 400
    // This div 6 clock is used for 9.6G to get 400
    // For dco/div3 case
    // This div 7 clock is used for 8.4G to get 400
    // This div 8 clock is used for 9.6G to get 400
    .clk    (ck_ssc_dco_mux_ref_ungated),
    .rst_b  (syncronize_ssc_ref_clk_div_b),
    .div    (rclk_ck_div),
    .clkdiv (ck_ssc_400_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv psf400_clkdiv (
    // For dco/div4 case
    // This div 5 clock is used for 8 G to get 400
    // This div 6 clock is used for 9.6G to get 400
    // For dco/div3 case
    // This div 7 clock is used for 8.4G to get 400
    // This div 8 clock is used for 9.6G to get 400
    .clk    (ck_ssc_dco_mux_ungated),
    .rst_b  (syncronize_ssc_clk_div_b),
    .div    (rclk_ck_div),
    .clkdiv (ck_psf400_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv sa_clkdiv (
    .clk    (ck_ssc_dco_mux_ungated),
    .rst_b  (syncronize_ssc_clk_div_b),
    .div    (sa_ck_div),
    .clkdiv (ck_sa_pre_glitch)
);

hqm_rcfwl_gclk_iclk_clkdiv sahalf_clkdiv (
    .clk    (ck_sa),
    .rst_b  (syncronize_ssc_clk_div_post_mux_b), // MLM - after MUX
    .div    (4'd2),
    .clkdiv (ck_sahalf)
);

assign ck_ref_corepll = ck_ssc_400;

hqm_rcfwl_gclk_iclk_clkdiv ck2x_clkdiv (
    .clk    (ck_psf400),
    .rst_b  (syncronize_ssc_clk_div_post_mux_b), // MLM - after MUX
    .div    (4'd2),
    .clkdiv (ck_2x)
);

hqm_rcfwl_gclk_iclk_clkdiv ck1x_clkdiv (
    .clk    (ck_psf400),
    .rst_b  (syncronize_ssc_clk_div_post_mux_b),  // MLM - after MUX
    .div    (4'd4),
    .clkdiv (ck_1x)
);
hqm_rcfwl_gclk_iclk_clkdiv ck_ssc_100_clkdiv (
    .clk    (ck_ssc_400),
    .rst_b  (syncronize_ssc_clk_div_post_mux_b), // MLM - after MUX
    .div    (4'd4),
    .clkdiv (ck_ssc_100)
);

hqm_rcfwl_gclk_iclk_clkdiv ref_ddr_clkdiv (
    .clk    (ck_ssc_400),
    .rst_b  (syncronize_ssc_ref_clk_div_post_mux_b), // MLM - after MUX
    .div    (4'd3),
    .clkdiv (ck_ref_ddr)
);

hqm_rcfwl_gclk_iclk_clkdiv svid_clkdiv (
    .clk    (ck_1x),
    .rst_b  (syncronize_ssc_clk_div_post_mux_b), // MLM - after MUX
    .div    ({1'b0,svid_ck_div}),
    .clkdiv (ck_svid)
);


// Flex 0 MUX 
// Select divider input clock or 96 or 200
// then select div ration up to 8
// optionally select leagacy 14.318 clock instead.
c73plllchpc73p1plllc_ctech_clock_mux flex_mux00 (
    .s(sel_flex_base[0]), 
    .d1(ck_nssc_96), 
    .d2(ck_nssc_200),
    .o(ck_flex0_in)
);
hqm_rcfwl_gclk_iclk_clkdiv nssc_flex_clkdiv0 (
    .clk    (ck_flex0_in),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (flex_ck_div0),
    .clkdiv (ck_flex_div0)
);
// Flex 1 MUX 
c73plllchpc73p1plllc_ctech_clock_mux flex_mux10 (
    .s(sel_flex_base[1]), 
    .d1(ck_nssc_96), 
    .d2(ck_nssc_200),
    .o(ck_flex1_in)
);
hqm_rcfwl_gclk_iclk_clkdiv nssc_flex_clkdiv1 (
    .clk    (ck_flex1_in),
    .rst_b  (syncronize_nssc_clk_div_b),
    .div    (flex_ck_div1),
    .clkdiv (ck_flex_div1)
);

assign ck_ref_usb2_pre_glitch = ck_nssc_96;

c73plllchpc73p1plllc_ctech_clock_mux wm_ext_ref_mux0 (
    .s(sel_ext_100), 
    .d1(clk100_ref), 
    .d2(krm_xosc_clk),
    .o(ck_ext_ref)
);

assign ck_ext_ref_nssc = ck_ext_ref;
assign ck_ext_ref_ssc  = ck_ext_ref;

c73plllchpc73p1plllc_ctech_clock_mux wm8x_pci_mux (
    .s(sel_wm_ssc[0]), 
    .d1(ck_ssc_100), 
    .d2(ck_ext_ref),
    .o(ck_ref_wm8x_pci)
);

c73plllchpc73p1plllc_ctech_clock_mux wm8x_sata_mux (
    .s(sel_wm_ssc[1]), 
    .d1(ck_ssc_100), 
    .d2(ck_ext_ref),
    .o(ck_ref_wm8x_sata)
);


// Special glitch free mux which can only switch to high speed clock when it is off
iclk_glitchfree_mux sa_glitch (
   .clk_in({ck_sa_pre_glitch, rosc_120_clk}),
   .en(ick_ssc_lock_mux | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_sa)
);
iclk_glitchfree_mux ssc_400_glitch (
   .clk_in({ck_ssc_400_pre_glitch, rosc_120_clk}),
   .en(ick_ssc_lock_mux | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_ssc_400)
);
iclk_glitchfree_mux psf400_glitch (
   .clk_in({ck_psf400_pre_glitch, rosc_120_clk}),
   .en(ick_ssc_lock_mux | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_psf400)
);
iclk_glitchfree_mux punit_glitch (
   .clk_in({ck_punit_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_punit)
);
iclk_glitchfree_mux nssc_25_glitch (
   .clk_in({ck_nssc_25_pre_glitch, rosc_medium_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_nssc_25)
);

iclk_glitchfree_mux psf300_glitch (
   .clk_in({ck_psf300_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_psf300)
);
iclk_glitchfree_mux psf200_glitch (
   .clk_in({ck_psf200_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_psf200)
);
iclk_glitchfree_mux emmc_glitch (
   .clk_in({ck_emmc_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_emmc)
);
iclk_glitchfree_mux psf133_glitch (
   .clk_in({ck_psf133_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_psf133)
);
iclk_glitchfree_mux psf266_glitch (
   .clk_in({ck_psf266_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_psf266)
);
iclk_glitchfree_mux ncpm_glitch (
   .clk_in({ck_ncpm_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_ncpm)
);
iclk_glitchfree_mux northpeak_glitch (
   .clk_in({ck_northpeak_pre_glitch, rosc_120_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_northpeak)
);
iclk_glitchfree_mux nssc_100_glitch (
   .clk_in({ck_nssc_100_pre_glitch, rosc_medium_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_nssc_100)
);
iclk_glitchfree_mux ref_usb2_glitch (
   .clk_in({ck_ref_usb2_pre_glitch, rosc_medium_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_ref_usb2)
);
iclk_glitchfree_mux mdng_glitch (
   .clk_in({ck_mdng_pre_glitch, rosc_medium_clk}),
   .en(ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_mdng)
);
iclk_glitchfree_mux_full_sync csme2x_glitch (
   .clk_in({ck_csme2x_pre_glitch, rosc_120_clk}),
   .en(csme_clk_mux_sel&ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_csme2x),
   .complete(csme2x_switch_complete)
);
iclk_glitchfree_mux_full_sync csme1x_glitch (
   .clk_in({ck_csme1x_pre_glitch, rosc_60_clk}),
   .en(csme_clk_mux_sel&ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_csme1x),
   .complete(csme1x_switch_complete)
);
iclk_glitchfree_mux_full_sync ie2x_glitch (
   .clk_in({ck_ie2x_pre_glitch, rosc_120_clk}),
   .en(ie_clk_mux_sel&ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_ie2x),
   .complete(ie2x_switch_complete)
);
iclk_glitchfree_mux_full_sync ie1x_glitch (
   .clk_in({ck_ie1x_pre_glitch, rosc_60_clk}),
   .en(ie_clk_mux_sel&ick_nssc_lock | tap_sel_test_clock_gated),
   .rb(int_pwell_pok_early_sus),

   .clk_out(ck_ie1x),
   .complete(ie1x_switch_complete)
);

assign ie_switch_complete   = ie2x_switch_complete   & ie1x_switch_complete;
assign csme_switch_complete = csme2x_switch_complete & csme1x_switch_complete;

assign ck_sus_25m = krm_xosc_clk;
//assign ck_sus_25m = ck_nssc_25;

endmodule : hqm_rcfwl_gclk_isclkgen
