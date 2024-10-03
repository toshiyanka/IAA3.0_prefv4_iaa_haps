/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in topographical mode
// Version   : P-2019.03-SP3
// Date      : Mon Jan 20 18:41:25 2020
/////////////////////////////////////////////////////////////


module stap_ctech_lib_and_0 ( a, b, o );
  input a, b;
  output o;


  AN2D1BWP240H8P57PDSVT ctech_lib_and_dcszo ( .A1(a), .A2(b), .Z(o) );
endmodule


module stap_stap_ctech_lib_and_0 ( a, b, o );
  input a, b;
  output o;
  wire   n2;

  stap_ctech_lib_and_0 i_ctech_lib_and ( .a(a), .b(b), .o(n2) );
  BUFFD1BWP240H8P57PDSVT SYN_1 ( .I(n2), .Z(o) );
endmodule


module stap_ctech_lib_clk_buf_3 ( clk, clkout );
  input clk;
  output clkout;


  BUFFD1BWP240H8P57PDSVT ctech_lib_clk_buf_dcszo ( .I(clk), .Z(clkout) );
endmodule


module stap_stap_ctech_lib_clk_buf_1 ( clk, clkout );
  input clk;
  output clkout;


  stap_ctech_lib_clk_buf_3 i_ctech_lib_clk_buf ( .clk(clk), .clkout(clkout) );
endmodule


module stap_stap_glue_0_0_1_1_8_0_0_0 ( ftap_tck, ftap_tms, ftap_trst_b, 
        fdfx_powergood, ftap_tdi, stap_tdomux_tdoen, sntapnw_atap_tdo_en, 
        pre_tdo, powergood_rst_trst_b, atap_tdoen, sntapnw_ftap_tck, 
        sntapnw_ftap_tms, sntapnw_ftap_trst_b, sntapnw_ftap_tdi, 
        sntapnw_atap_tdo, ftapsslv_tck, ftapsslv_tms, ftapsslv_trst_b, 
        ftapsslv_tdi, atapsslv_tdo, atapsslv_tdoen, sntapnw_ftap_tck2, 
        sntapnw_ftap_tms2, sntapnw_ftap_trst2_b, sntapnw_ftap_tdi2, 
        sntapnw_atap_tdo2, sntapnw_atap_tdo2_en, sn_fwtap_wrck, stap_mux_tdo, 
        tapc_select, tapc_wtap_sel, tapc_remove, stap_wtapnw_tdo );
  input [0:0] sntapnw_atap_tdo_en;
  input [0:0] sntapnw_atap_tdo2_en;
  input [1:0] tapc_select;
  input [0:0] tapc_wtap_sel;
  input ftap_tck, ftap_tms, ftap_trst_b, fdfx_powergood, ftap_tdi,
         stap_tdomux_tdoen, sntapnw_atap_tdo, ftapsslv_tck, ftapsslv_tms,
         ftapsslv_trst_b, ftapsslv_tdi, sntapnw_atap_tdo2, stap_mux_tdo,
         tapc_remove, stap_wtapnw_tdo;
  output pre_tdo, powergood_rst_trst_b, atap_tdoen, sntapnw_ftap_tck,
         sntapnw_ftap_tms, sntapnw_ftap_trst_b, sntapnw_ftap_tdi, atapsslv_tdo,
         atapsslv_tdoen, sntapnw_ftap_tck2, sntapnw_ftap_tms2,
         sntapnw_ftap_trst2_b, sntapnw_ftap_tdi2, sn_fwtap_wrck;
  wire   n1;

  stap_stap_ctech_lib_clk_buf_1 i_stap_ctech_lib_clk_buf_tck2 ( .clk(
        ftapsslv_tck), .clkout(sntapnw_ftap_tck2) );
  stap_stap_ctech_lib_and_0 i_stap_ctech_lib_and ( .a(ftap_trst_b), .b(
        fdfx_powergood), .o(powergood_rst_trst_b) );
  BUFFD1BWP240H8P57PDSVT SYN_3 ( .I(sntapnw_atap_tdo2_en[0]), .Z(
        atapsslv_tdoen) );
  BUFFD1BWP240H8P57PDSVT SYN_4 ( .I(sntapnw_atap_tdo2), .Z(atapsslv_tdo) );
  BUFFD1BWP240H8P57PDSVT SYN_5 ( .I(ftapsslv_tdi), .Z(sntapnw_ftap_tdi2) );
  BUFFD1BWP240H8P57PDSVT SYN_6 ( .I(ftapsslv_trst_b), .Z(sntapnw_ftap_trst2_b)
         );
  BUFFD1BWP240H8P57PDSVT SYN_7 ( .I(ftapsslv_tms), .Z(sntapnw_ftap_tms2) );
  BUFFD1BWP240H8P57PDSVT SYN_8 ( .I(stap_mux_tdo), .Z(pre_tdo) );
  INVPADD1BWP240H8P57PDSVT SYN_11 ( .I(tapc_remove), .ZN(n1) );
  AO22D1BWP240H8P57PDSVT SYN_12 ( .A1(tapc_remove), .A2(sntapnw_atap_tdo_en[0]), .B1(n1), .B2(stap_tdomux_tdoen), .Z(atap_tdoen) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_3 ( .I(1'b1), .ZN(sntapnw_ftap_tck) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_5 ( .I(1'b0), .ZN(sntapnw_ftap_tms) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_7 ( .I(1'b0), .ZN(sntapnw_ftap_trst_b) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_9 ( .I(1'b1), .ZN(sntapnw_ftap_tdi) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_11 ( .I(1'b1), .ZN(sn_fwtap_wrck) );
endmodule


module stap_stap_dfxsecure_plugin_3_4_0_3_1_2_0_07_3ad6b5ae6b9cd733cce7_0 ( 
        fdfx_powergood, fdfx_secure_policy, fdfx_earlyboot_exit, 
        fdfx_policy_update, dfxsecure_feature_en, visa_all_dis, 
        visa_customer_dis, sb_policy_ovr_value, oem_secure_policy );
  input [3:0] fdfx_secure_policy;
  output [2:0] dfxsecure_feature_en;
  input [4:0] sb_policy_ovr_value;
  input [3:0] oem_secure_policy;
  input fdfx_powergood, fdfx_earlyboot_exit, fdfx_policy_update;
  output visa_all_dis, visa_customer_dis;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9;
  wire   [3:0] dfxsecure_feature_lch;

  INVPADD1BWP240H8P57PDSVT SYN_3 ( .I(dfxsecure_feature_lch[3]), .ZN(n5) );
  INVPADD1BWP240H8P57PDSVT SYN_4 ( .I(dfxsecure_feature_lch[1]), .ZN(n1) );
  ND3D1BWP240H8P57PDSVT SYN_5 ( .A1(dfxsecure_feature_lch[0]), .A2(
        fdfx_earlyboot_exit), .A3(n1), .ZN(n6) );
  INVPADD1BWP240H8P57PDSVT SYN_6 ( .I(dfxsecure_feature_lch[0]), .ZN(n3) );
  INVPADD1BWP240H8P57PDSVT SYN_7 ( .I(dfxsecure_feature_lch[2]), .ZN(n7) );
  OAI21D1BWP240H8P57PDSVT SYN_8 ( .A1(dfxsecure_feature_lch[0]), .A2(n1), .B(
        n7), .ZN(n9) );
  OAI211D1BWP240H8P57PDSVT SYN_9 ( .A1(dfxsecure_feature_lch[1]), .A2(n3), .B(
        fdfx_earlyboot_exit), .C(n9), .ZN(n2) );
  OAI32D1BWP240H8P57PDSVT SYN_10 ( .A1(n5), .A2(dfxsecure_feature_lch[2]), 
        .A3(n6), .B1(dfxsecure_feature_lch[3]), .B2(n2), .ZN(
        dfxsecure_feature_en[2]) );
  AOAI211D1BWP240H8P57PDSVT SYN_11 ( .A1(dfxsecure_feature_lch[1]), .A2(n7), 
        .B(n3), .C(fdfx_earlyboot_exit), .ZN(n4) );
  OAI22D1BWP240H8P57PDSVT SYN_12 ( .A1(n7), .A2(n6), .B1(n5), .B2(n4), .ZN(
        dfxsecure_feature_en[1]) );
  ND4D1BWP240H8P57PDSVT SYN_13 ( .A1(dfxsecure_feature_lch[2]), .A2(
        dfxsecure_feature_lch[0]), .A3(dfxsecure_feature_lch[1]), .A4(
        dfxsecure_feature_lch[3]), .ZN(n8) );
  OAI211D1BWP240H8P57PDSVT SYN_14 ( .A1(dfxsecure_feature_lch[3]), .A2(n9), 
        .B(fdfx_earlyboot_exit), .C(n8), .ZN(dfxsecure_feature_en[0]) );
  LHCNQD1BWP240H11P57PDSVT dfxsecure_feature_lch_reg_2 ( .E(fdfx_policy_update), .D(fdfx_secure_policy[2]), .CDN(fdfx_powergood), .Q(dfxsecure_feature_lch[2]) );
  LHCNQD1BWP240H11P57PDSVT dfxsecure_feature_lch_reg_3 ( .E(fdfx_policy_update), .D(fdfx_secure_policy[3]), .CDN(fdfx_powergood), .Q(dfxsecure_feature_lch[3]) );
  LHCNQD1BWP240H11P57PDSVT dfxsecure_feature_lch_reg_0 ( .E(fdfx_policy_update), .D(fdfx_secure_policy[0]), .CDN(fdfx_powergood), .Q(dfxsecure_feature_lch[0]) );
  LHCNQD1BWP240H11P57PDSVT dfxsecure_feature_lch_reg_1 ( .E(fdfx_policy_update), .D(fdfx_secure_policy[1]), .CDN(fdfx_powergood), .Q(dfxsecure_feature_lch[1]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_3 ( .I(1'b0), .ZN(visa_all_dis) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_5 ( .I(1'b0), .ZN(visa_customer_dis) );
endmodule


module stap_SNPS_CLOCK_GATE_HIGH_stap_tapswcomp_10_0 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  CKLNQD10BWP240H8P57PDSVT latch ( .CP(CLK), .E(EN), .TE(TE), .Q(ENCLK) );
endmodule


module stap_SNPS_CLOCK_GATE_HIGH_stap_tapswcomp_10_1 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  CKLNQD10BWP240H8P57PDSVT latch ( .CP(CLK), .E(EN), .TE(TE), .Q(ENCLK) );
endmodule


module stap_stap_tapswcomp_10_0 ( jtclk, jtrst_b, tdi, test_logic_reset, 
        capture_dr, shift_dr, exit2_dr, tap_swcomp_active, cmplim_hi, 
        cmplim_lo, cmplim_mask, cmp_mirror_sel, cmp_tdo_sel, cmp_tdo_forcelo, 
        cmpen_main, cmpsel_signed, cmpsel_sgnmag, cmpen_le_limhi, 
        cmpen_ge_limlo, cmpen_blk_multi_fail, cmp_firstfail_cnt, 
        cmp_sticky_fail_hi, cmp_sticky_fail_lo, tdo );
  input [9:0] cmplim_hi;
  input [9:0] cmplim_lo;
  input [9:0] cmplim_mask;
  output [7:0] cmp_firstfail_cnt;
  input jtclk, jtrst_b, tdi, test_logic_reset, capture_dr, shift_dr, exit2_dr,
         tap_swcomp_active, cmp_mirror_sel, cmp_tdo_sel, cmp_tdo_forcelo,
         cmpen_main, cmpsel_signed, cmpsel_sgnmag, cmpen_le_limhi,
         cmpen_ge_limlo, cmpen_blk_multi_fail;
  output cmp_sticky_fail_hi, cmp_sticky_fail_lo, tdo;
  wire   cmp_enable, N155, N156, N178, net705, net732, net733, net734, net735,
         net736, net737, net738, net739, net740, net742, n1, n2, n3, n4, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104,
         n105, n106, n107, n108, n109, n110, n111, n112, n113, n114, n115,
         n116, n117, n118, n119, n120, n121, n122, n123, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
         n150, n151, n152, n153, n154, n1550, n1560, n157, n158, n159, n160,
         n161, n162, n163, n164, n165, n166, n167, n168, n169, n170, n171,
         n172, n173, n174, n175, n176, n177, n1780, n179, n180, n181, n182,
         n183;
  wire   [9:0] serial_windowreg;
  wire   [9:0] serialdata_next;

  stap_SNPS_CLOCK_GATE_HIGH_stap_tapswcomp_10_0 clk_gate_serial_windowreg_reg_9 ( 
        .CLK(jtclk), .EN(N178), .ENCLK(net732), .TE(1'b0) );
  stap_SNPS_CLOCK_GATE_HIGH_stap_tapswcomp_10_1 clk_gate_cmp_firstfail_cnt_reg_7 ( 
        .CLK(jtclk), .EN(net705), .ENCLK(net742), .TE(1'b0) );
  AOI21D1BWP240H8P57PDSVT SYN_3 ( .A1(exit2_dr), .A2(tap_swcomp_active), .B(
        test_logic_reset), .ZN(n158) );
  AOI22D1BWP240H8P57PDSVT SYN_5 ( .A1(cmp_mirror_sel), .A2(serial_windowreg[0]), .B1(serial_windowreg[9]), .B2(n181), .ZN(n19) );
  AOI22D1BWP240H8P57PDSVT SYN_6 ( .A1(cmp_mirror_sel), .A2(serial_windowreg[4]), .B1(serial_windowreg[5]), .B2(n181), .ZN(n51) );
  AOI22D1BWP240H8P57PDSVT SYN_7 ( .A1(cmp_mirror_sel), .A2(serial_windowreg[5]), .B1(serial_windowreg[4]), .B2(n181), .ZN(n61) );
  AOI22D1BWP240H8P57PDSVT SYN_9 ( .A1(cmplim_mask[0]), .A2(n51), .B1(n61), 
        .B2(n183), .ZN(n2) );
  AOI22D1BWP240H8P57PDSVT SYN_10 ( .A1(cmp_mirror_sel), .A2(
        serial_windowreg[3]), .B1(serial_windowreg[6]), .B2(n181), .ZN(n21) );
  AOI22D1BWP240H8P57PDSVT SYN_11 ( .A1(cmp_mirror_sel), .A2(
        serial_windowreg[2]), .B1(serial_windowreg[7]), .B2(n181), .ZN(n22) );
  OAI221D1BWP240H8P57PDSVT SYN_12 ( .A1(cmplim_mask[0]), .A2(n21), .B1(n183), 
        .B2(n22), .C(cmplim_mask[1]), .ZN(n1) );
  OAI211D1BWP240H8P57PDSVT SYN_13 ( .A1(cmplim_mask[1]), .A2(n2), .B(
        cmplim_mask[2]), .C(n1), .ZN(n10) );
  NR2D1BWP240H8P57PDSVT SYN_14 ( .A1(cmplim_mask[1]), .A2(cmplim_mask[2]), 
        .ZN(n18) );
  AOI22D1BWP240H8P57PDSVT SYN_15 ( .A1(cmp_mirror_sel), .A2(
        serial_windowreg[1]), .B1(serial_windowreg[8]), .B2(n181), .ZN(n26) );
  AOI22D1BWP240H8P57PDSVT SYN_16 ( .A1(cmplim_mask[0]), .A2(n19), .B1(n26), 
        .B2(n183), .ZN(n4) );
  AOI22D1BWP240H8P57PDSVT SYN_17 ( .A1(cmp_mirror_sel), .A2(
        serial_windowreg[8]), .B1(serial_windowreg[1]), .B2(n181), .ZN(n96) );
  AOI22D1BWP240H8P57PDSVT SYN_18 ( .A1(cmp_mirror_sel), .A2(
        serial_windowreg[9]), .B1(serial_windowreg[0]), .B2(n181), .ZN(n88) );
  NR2D1BWP240H8P57PDSVT SYN_19 ( .A1(cmplim_mask[3]), .A2(cmplim_mask[2]), 
        .ZN(n67) );
  INVPADD1BWP240H8P57PDSVT SYN_20 ( .I(n67), .ZN(n11) );
  NR2D1BWP240H8P57PDSVT SYN_21 ( .A1(n11), .A2(cmplim_mask[1]), .ZN(n93) );
  INVPADD1BWP240H8P57PDSVT SYN_22 ( .I(n93), .ZN(n12) );
  AOI221D1BWP240H8P57PDSVT SYN_23 ( .A1(cmplim_mask[0]), .A2(n96), .B1(n183), 
        .B2(n88), .C(n12), .ZN(n3) );
  AOI31D1BWP240H8P57PDSVT SYN_24 ( .A1(cmplim_mask[3]), .A2(n18), .A3(n4), .B(
        n3), .ZN(n9) );
  AOI22D1BWP240H8P57PDSVT SYN_25 ( .A1(cmp_mirror_sel), .A2(
        serial_windowreg[6]), .B1(serial_windowreg[3]), .B2(n181), .ZN(n70) );
  AOI22D1BWP240H8P57PDSVT SYN_26 ( .A1(cmp_mirror_sel), .A2(
        serial_windowreg[7]), .B1(serial_windowreg[2]), .B2(n181), .ZN(n84) );
  AOI22D1BWP240H8P57PDSVT SYN_27 ( .A1(cmplim_mask[0]), .A2(n70), .B1(n84), 
        .B2(n183), .ZN(n7) );
  ND3D1BWP240H8P57PDSVT SYN_28 ( .A1(cmplim_mask[1]), .A2(n67), .A3(n7), .ZN(
        n8) );
  OAI211D1BWP240H8P57PDSVT SYN_29 ( .A1(cmplim_mask[3]), .A2(n10), .B(n9), .C(
        n8), .ZN(n91) );
  IOA21D1BWP240H8P57PDSVT SYN_30 ( .A1(cmpsel_sgnmag), .A2(n91), .B(
        cmpsel_signed), .ZN(n36) );
  IND2D1BWP240H8P57PDSVT SYN_31 ( .A1(n36), .B1(cmplim_mask[3]), .ZN(n30) );
  NR2D1BWP240H8P57PDSVT SYN_33 ( .A1(cmpsel_sgnmag), .A2(n182), .ZN(n103) );
  ND2D1BWP240H8P57PDSVT SYN_34 ( .A1(n103), .A2(n91), .ZN(n82) );
  INVPADD1BWP240H8P57PDSVT SYN_35 ( .I(n82), .ZN(n92) );
  ND2D1BWP240H8P57PDSVT SYN_36 ( .A1(cmpsel_signed), .A2(cmpsel_sgnmag), .ZN(
        n80) );
  OAI31D1BWP240H8P57PDSVT SYN_37 ( .A1(cmplim_mask[3]), .A2(cmplim_mask[1]), 
        .A3(cmplim_mask[0]), .B(n11), .ZN(n64) );
  NR2D1BWP240H8P57PDSVT SYN_38 ( .A1(n61), .A2(n64), .ZN(n59) );
  AOI21D1BWP240H8P57PDSVT SYN_39 ( .A1(cmplim_mask[1]), .A2(cmplim_mask[0]), 
        .B(n11), .ZN(n74) );
  NR2D1BWP240H8P57PDSVT SYN_40 ( .A1(n84), .A2(n74), .ZN(n87) );
  NR2D1BWP240H8P57PDSVT SYN_41 ( .A1(cmplim_mask[0]), .A2(n12), .ZN(n13) );
  AOI31D1BWP240H8P57PDSVT SYN_42 ( .A1(cmplim_mask[2]), .A2(cmplim_mask[1]), 
        .A3(cmplim_mask[0]), .B(cmplim_mask[3]), .ZN(n44) );
  OAI22D1BWP240H8P57PDSVT SYN_43 ( .A1(n88), .A2(n13), .B1(n21), .B2(n44), 
        .ZN(n15) );
  INVPADD1BWP240H8P57PDSVT SYN_44 ( .I(n22), .ZN(n34) );
  NR2D1BWP240H8P57PDSVT SYN_45 ( .A1(n67), .A2(n70), .ZN(n68) );
  OAI31D1BWP240H8P57PDSVT SYN_46 ( .A1(cmplim_mask[2]), .A2(cmplim_mask[1]), 
        .A3(cmplim_mask[0]), .B(cmplim_mask[3]), .ZN(n29) );
  NR2D1BWP240H8P57PDSVT SYN_47 ( .A1(n26), .A2(n29), .ZN(n24) );
  AO211D1BWP240H8P57PDSVT SYN_48 ( .A1(n34), .A2(cmplim_mask[3]), .B(n68), .C(
        n24), .Z(n14) );
  NR4D1BWP240H8P57PDSVT SYN_49 ( .A1(n59), .A2(n87), .A3(n15), .A4(n14), .ZN(
        n17) );
  NR2D1BWP240H8P57PDSVT SYN_50 ( .A1(n93), .A2(n96), .ZN(n94) );
  INVPADD1BWP240H8P57PDSVT SYN_51 ( .I(n94), .ZN(n90) );
  INVPADD1BWP240H8P57PDSVT SYN_52 ( .I(n51), .ZN(n16) );
  AOAI211D1BWP240H8P57PDSVT SYN_53 ( .A1(cmplim_mask[1]), .A2(cmplim_mask[2]), 
        .B(cmplim_mask[3]), .C(n16), .ZN(n46) );
  INVPADD1BWP240H8P57PDSVT SYN_54 ( .I(n91), .ZN(n79) );
  AOI31D1BWP240H8P57PDSVT SYN_55 ( .A1(n17), .A2(n90), .A3(n46), .B(n79), .ZN(
        n78) );
  INVPADD1BWP240H8P57PDSVT SYN_56 ( .I(n78), .ZN(n89) );
  NR2D1BWP240H8P57PDSVT SYN_57 ( .A1(n80), .A2(n89), .ZN(n38) );
  NR2D1BWP240H8P57PDSVT SYN_58 ( .A1(n92), .A2(n38), .ZN(n45) );
  OAI31D1BWP240H8P57PDSVT SYN_59 ( .A1(n30), .A2(n19), .A3(n18), .B(n45), .ZN(
        n121) );
  INVPADD1BWP240H8P57PDSVT SYN_60 ( .I(n121), .ZN(n153) );
  OAI31D1BWP240H8P57PDSVT SYN_61 ( .A1(cmpsel_signed), .A2(n19), .A3(
        cmplim_mask[9]), .B(n153), .ZN(n20) );
  INVPADD1BWP240H8P57PDSVT SYN_62 ( .I(n20), .ZN(n151) );
  INVPADD1BWP240H8P57PDSVT SYN_63 ( .I(n21), .ZN(n42) );
  INVPADD1BWP240H8P57PDSVT SYN_64 ( .I(n84), .ZN(n76) );
  ND2D1BWP240H8P57PDSVT SYN_65 ( .A1(n88), .A2(n96), .ZN(n98) );
  NR2D1BWP240H8P57PDSVT SYN_66 ( .A1(n76), .A2(n98), .ZN(n75) );
  ND2D1BWP240H8P57PDSVT SYN_67 ( .A1(n70), .A2(n75), .ZN(n72) );
  NR3D1BWP240H8P57PDSVT SYN_68 ( .A1(serial_windowreg[4]), .A2(
        serial_windowreg[5]), .A3(n72), .ZN(n41) );
  INVPADD1BWP240H8P57PDSVT SYN_69 ( .I(n41), .ZN(n53) );
  NR2D1BWP240H8P57PDSVT SYN_70 ( .A1(n42), .A2(n53), .ZN(n33) );
  IOA21D1BWP240H8P57PDSVT SYN_71 ( .A1(n22), .A2(n33), .B(n24), .ZN(n23) );
  AOI22D1BWP240H8P57PDSVT SYN_72 ( .A1(n79), .A2(n24), .B1(n78), .B2(n23), 
        .ZN(n25) );
  IOA22D1BWP240H8P57PDSVT SYN_73 ( .B1(n25), .B2(n80), .A1(n103), .A2(n24), 
        .ZN(n28) );
  NR3D1BWP240H8P57PDSVT SYN_74 ( .A1(cmpsel_signed), .A2(n26), .A3(
        cmplim_mask[8]), .ZN(n27) );
  AOI211D1BWP240H8P57PDSVT SYN_75 ( .A1(n92), .A2(n29), .B(n28), .C(n27), .ZN(
        n148) );
  INVPADD1BWP240H8P57PDSVT SYN_76 ( .I(n38), .ZN(n40) );
  OAI21D1BWP240H8P57PDSVT SYN_77 ( .A1(cmpsel_signed), .A2(cmplim_mask[7]), 
        .B(n30), .ZN(n31) );
  AOAI211D1BWP240H8P57PDSVT SYN_78 ( .A1(n33), .A2(n38), .B(n31), .C(n34), 
        .ZN(n32) );
  OAI31D1BWP240H8P57PDSVT SYN_79 ( .A1(n34), .A2(n33), .A3(n40), .B(n32), .ZN(
        n35) );
  IAO21D1BWP240H8P57PDSVT SYN_80 ( .A1(cmplim_mask[3]), .A2(n45), .B(n35), 
        .ZN(n146) );
  OAI22D1BWP240H8P57PDSVT SYN_81 ( .A1(n36), .A2(n44), .B1(cmpsel_signed), 
        .B2(cmplim_mask[6]), .ZN(n37) );
  AOAI211D1BWP240H8P57PDSVT SYN_82 ( .A1(n41), .A2(n38), .B(n37), .C(n42), 
        .ZN(n39) );
  OAI31D1BWP240H8P57PDSVT SYN_83 ( .A1(n42), .A2(n41), .A3(n40), .B(n39), .ZN(
        n43) );
  IAOI21D1BWP240H8P57PDSVT SYN_84 ( .A2(n45), .A1(n44), .B(n43), .ZN(n142) );
  NR2D1BWP240H8P57PDSVT SYN_85 ( .A1(n146), .A2(cmplim_hi[7]), .ZN(n116) );
  ND2D1BWP240H8P57PDSVT SYN_86 ( .A1(cmplim_hi[6]), .A2(n142), .ZN(n115) );
  AOI21D1BWP240H8P57PDSVT SYN_87 ( .A1(n91), .A2(n89), .B(n80), .ZN(n102) );
  INVPADD1BWP240H8P57PDSVT SYN_88 ( .I(n61), .ZN(n57) );
  NR2D1BWP240H8P57PDSVT SYN_89 ( .A1(n57), .A2(n72), .ZN(n56) );
  INVPADD1BWP240H8P57PDSVT SYN_90 ( .I(n46), .ZN(n49) );
  OAI32D1BWP240H8P57PDSVT SYN_91 ( .A1(n79), .A2(n46), .A3(n56), .B1(n49), 
        .B2(n78), .ZN(n47) );
  INVPADD1BWP240H8P57PDSVT SYN_92 ( .I(n47), .ZN(n54) );
  AOI21D1BWP240H8P57PDSVT SYN_93 ( .A1(cmplim_mask[1]), .A2(cmplim_mask[2]), 
        .B(cmplim_mask[3]), .ZN(n48) );
  AOI22D1BWP240H8P57PDSVT SYN_94 ( .A1(n103), .A2(n49), .B1(n92), .B2(n48), 
        .ZN(n50) );
  OAI31D1BWP240H8P57PDSVT SYN_95 ( .A1(cmpsel_signed), .A2(n51), .A3(
        cmplim_mask[5]), .B(n50), .ZN(n52) );
  AOI31D1BWP240H8P57PDSVT SYN_96 ( .A1(n102), .A2(n54), .A3(n53), .B(n52), 
        .ZN(n134) );
  INVPADD1BWP240H8P57PDSVT SYN_97 ( .I(n64), .ZN(n55) );
  AOAI211D1BWP240H8P57PDSVT SYN_98 ( .A1(n57), .A2(n72), .B(n56), .C(n55), 
        .ZN(n58) );
  AOI22D1BWP240H8P57PDSVT SYN_99 ( .A1(n79), .A2(n59), .B1(n78), .B2(n58), 
        .ZN(n60) );
  IOA22D1BWP240H8P57PDSVT SYN_100 ( .B1(n60), .B2(n80), .A1(n103), .A2(n59), 
        .ZN(n63) );
  NR3D1BWP240H8P57PDSVT SYN_101 ( .A1(cmpsel_signed), .A2(n61), .A3(
        cmplim_mask[4]), .ZN(n62) );
  AOI211D1BWP240H8P57PDSVT SYN_102 ( .A1(n92), .A2(n64), .B(n63), .C(n62), 
        .ZN(n139) );
  ND2D1BWP240H8P57PDSVT SYN_103 ( .A1(n134), .A2(cmplim_hi[5]), .ZN(n107) );
  INVPADD1BWP240H8P57PDSVT SYN_104 ( .I(n107), .ZN(n110) );
  INVPADD1BWP240H8P57PDSVT SYN_105 ( .I(n68), .ZN(n65) );
  OAI32D1BWP240H8P57PDSVT SYN_106 ( .A1(n79), .A2(n65), .A3(n75), .B1(n68), 
        .B2(n78), .ZN(n66) );
  INVPADD1BWP240H8P57PDSVT SYN_107 ( .I(n66), .ZN(n73) );
  AOI22D1BWP240H8P57PDSVT SYN_108 ( .A1(n103), .A2(n68), .B1(n67), .B2(n92), 
        .ZN(n69) );
  OAI31D1BWP240H8P57PDSVT SYN_109 ( .A1(cmpsel_signed), .A2(cmplim_mask[3]), 
        .A3(n70), .B(n69), .ZN(n71) );
  AOI31D1BWP240H8P57PDSVT SYN_110 ( .A1(n102), .A2(n73), .A3(n72), .B(n71), 
        .ZN(n132) );
  INVPADD1BWP240H8P57PDSVT SYN_111 ( .I(n74), .ZN(n83) );
  AOAI211D1BWP240H8P57PDSVT SYN_112 ( .A1(n76), .A2(n98), .B(n75), .C(n83), 
        .ZN(n77) );
  AOI22D1BWP240H8P57PDSVT SYN_113 ( .A1(n79), .A2(n87), .B1(n78), .B2(n77), 
        .ZN(n81) );
  OAI22D1BWP240H8P57PDSVT SYN_114 ( .A1(n83), .A2(n82), .B1(n81), .B2(n80), 
        .ZN(n86) );
  NR3D1BWP240H8P57PDSVT SYN_115 ( .A1(cmpsel_signed), .A2(cmplim_mask[2]), 
        .A3(n84), .ZN(n85) );
  AOI211D1BWP240H8P57PDSVT SYN_116 ( .A1(n103), .A2(n87), .B(n86), .C(n85), 
        .ZN(n131) );
  INVPADD1BWP240H8P57PDSVT SYN_117 ( .I(n88), .ZN(n100) );
  AOI32D1BWP240H8P57PDSVT SYN_118 ( .A1(n100), .A2(n94), .A3(n91), .B1(n90), 
        .B2(n89), .ZN(n99) );
  AOI22D1BWP240H8P57PDSVT SYN_119 ( .A1(n103), .A2(n94), .B1(n93), .B2(n92), 
        .ZN(n95) );
  OAI31D1BWP240H8P57PDSVT SYN_120 ( .A1(cmpsel_signed), .A2(cmplim_mask[1]), 
        .A3(n96), .B(n95), .ZN(n97) );
  AOI31D1BWP240H8P57PDSVT SYN_121 ( .A1(n102), .A2(n99), .A3(n98), .B(n97), 
        .ZN(n129) );
  NR2D1BWP240H8P57PDSVT SYN_122 ( .A1(cmpsel_signed), .A2(cmplim_mask[0]), 
        .ZN(n101) );
  OAI31D1BWP240H8P57PDSVT SYN_123 ( .A1(n103), .A2(n102), .A3(n101), .B(n100), 
        .ZN(n127) );
  OAI22D1BWP240H8P57PDSVT SYN_124 ( .A1(n129), .A2(cmplim_hi[1]), .B1(n127), 
        .B2(cmplim_hi[0]), .ZN(n104) );
  IOA21D1BWP240H8P57PDSVT SYN_125 ( .A1(cmplim_hi[1]), .A2(n129), .B(n104), 
        .ZN(n105) );
  FCICOD1BWP240H8P57PDSVT SYN_126 ( .A(cmplim_hi[2]), .B(n131), .CI(n105), 
        .CO(n106) );
  MAOI222D1BWP240H8P57PDSVT SYN_127 ( .A(cmplim_hi[3]), .B(n132), .C(n106), 
        .ZN(n108) );
  ND2D1BWP240H8P57PDSVT SYN_128 ( .A1(n108), .A2(n107), .ZN(n109) );
  OAI31D1BWP240H8P57PDSVT SYN_129 ( .A1(cmplim_hi[4]), .A2(n139), .A3(n110), 
        .B(n109), .ZN(n111) );
  IOA21D1BWP240H8P57PDSVT SYN_130 ( .A1(n139), .A2(cmplim_hi[4]), .B(n111), 
        .ZN(n113) );
  INVPADD1BWP240H8P57PDSVT SYN_131 ( .I(n116), .ZN(n112) );
  OAI211D1BWP240H8P57PDSVT SYN_132 ( .A1(n134), .A2(cmplim_hi[5]), .B(n113), 
        .C(n112), .ZN(n114) );
  OAI21D1BWP240H8P57PDSVT SYN_133 ( .A1(n116), .A2(n115), .B(n114), .ZN(n117)
         );
  OAI21D1BWP240H8P57PDSVT SYN_134 ( .A1(cmplim_hi[6]), .A2(n142), .B(n117), 
        .ZN(n118) );
  IOA21D1BWP240H8P57PDSVT SYN_135 ( .A1(n146), .A2(cmplim_hi[7]), .B(n118), 
        .ZN(n119) );
  MAOI222D1BWP240H8P57PDSVT SYN_136 ( .A(cmplim_hi[8]), .B(n148), .C(n119), 
        .ZN(n120) );
  IAO21D1BWP240H8P57PDSVT SYN_137 ( .A1(n151), .A2(cmplim_hi[9]), .B(n120), 
        .ZN(n123) );
  ND2D1BWP240H8P57PDSVT SYN_138 ( .A1(cmpsel_signed), .A2(cmplim_hi[9]), .ZN(
        n122) );
  MAOI222D1BWP240H8P57PDSVT SYN_139 ( .A(n123), .B(n122), .C(n121), .ZN(n126)
         );
  ND3D1BWP240H8P57PDSVT SYN_140 ( .A1(n151), .A2(cmplim_hi[9]), .A3(n182), 
        .ZN(n125) );
  AOI31D1BWP240H8P57PDSVT SYN_141 ( .A1(cmpen_le_limhi), .A2(n126), .A3(n125), 
        .B(cmp_sticky_fail_hi), .ZN(n159) );
  AOI22D1BWP240H8P57PDSVT SYN_142 ( .A1(n142), .A2(cmplim_lo[6]), .B1(n134), 
        .B2(cmplim_lo[5]), .ZN(n141) );
  OAI211D1BWP240H8P57PDSVT SYN_143 ( .A1(n129), .A2(cmplim_lo[1]), .B(n127), 
        .C(cmplim_lo[0]), .ZN(n128) );
  IOA21D1BWP240H8P57PDSVT SYN_144 ( .A1(cmplim_lo[1]), .A2(n129), .B(n128), 
        .ZN(n130) );
  FCICOD1BWP240H8P57PDSVT SYN_145 ( .A(cmplim_lo[2]), .B(n131), .CI(n130), 
        .CO(n133) );
  MAOI222D1BWP240H8P57PDSVT SYN_146 ( .A(n133), .B(cmplim_lo[3]), .C(n132), 
        .ZN(n135) );
  NR2D1BWP240H8P57PDSVT SYN_147 ( .A1(n134), .A2(cmplim_lo[5]), .ZN(n136) );
  NR2D1BWP240H8P57PDSVT SYN_148 ( .A1(n135), .A2(n136), .ZN(n138) );
  IINR3D1BWP240H8P57PDSVT SYN_149 ( .A1(n139), .A2(cmplim_lo[4]), .B1(n136), 
        .ZN(n137) );
  OAI22D1BWP240H8P57PDSVT SYN_150 ( .A1(n139), .A2(cmplim_lo[4]), .B1(n138), 
        .B2(n137), .ZN(n140) );
  ND2D1BWP240H8P57PDSVT SYN_151 ( .A1(n141), .A2(n140), .ZN(n144) );
  OR2D1BWP240H8P57PDSVT SYN_152 ( .A1(n142), .A2(cmplim_lo[6]), .Z(n143) );
  OAI211D1BWP240H8P57PDSVT SYN_153 ( .A1(n146), .A2(cmplim_lo[7]), .B(n144), 
        .C(n143), .ZN(n145) );
  IOA21D1BWP240H8P57PDSVT SYN_154 ( .A1(cmplim_lo[7]), .A2(n146), .B(n145), 
        .ZN(n147) );
  MAOI222D1BWP240H8P57PDSVT SYN_155 ( .A(n148), .B(cmplim_lo[8]), .C(n147), 
        .ZN(n149) );
  IOA21D1BWP240H8P57PDSVT SYN_156 ( .A1(n151), .A2(cmplim_lo[9]), .B(n149), 
        .ZN(n150) );
  OAI21D1BWP240H8P57PDSVT SYN_157 ( .A1(cmplim_lo[9]), .A2(n151), .B(n150), 
        .ZN(n152) );
  OAI21D1BWP240H8P57PDSVT SYN_158 ( .A1(cmplim_lo[9]), .A2(n153), .B(n152), 
        .ZN(n1550) );
  ND3D1BWP240H8P57PDSVT SYN_159 ( .A1(cmpsel_signed), .A2(n153), .A3(
        cmplim_lo[9]), .ZN(n154) );
  AOI31D1BWP240H8P57PDSVT SYN_160 ( .A1(cmpen_ge_limlo), .A2(n1550), .A3(n154), 
        .B(cmp_sticky_fail_lo), .ZN(n160) );
  ND4D1BWP240H8P57PDSVT SYN_161 ( .A1(n159), .A2(cmpen_main), .A3(exit2_dr), 
        .A4(n160), .ZN(n162) );
  ND2D1BWP240H8P57PDSVT SYN_162 ( .A1(n158), .A2(n162), .ZN(net705) );
  OR2D1BWP240H8P57PDSVT SYN_163 ( .A1(cmp_sticky_fail_hi), .A2(
        cmp_sticky_fail_lo), .Z(n157) );
  ND2D1BWP240H8P57PDSVT SYN_164 ( .A1(cmpen_main), .A2(exit2_dr), .ZN(n1560)
         );
  AOAI211D1BWP240H8P57PDSVT SYN_165 ( .A1(cmpen_blk_multi_fail), .A2(n157), 
        .B(n1560), .C(n158), .ZN(cmp_enable) );
  OAI21D1BWP240H8P57PDSVT SYN_166 ( .A1(cmpen_main), .A2(cmp_tdo_sel), .B(
        capture_dr), .ZN(n179) );
  IND2D1BWP240H8P57PDSVT SYN_167 ( .A1(serial_windowreg[9]), .B1(n179), .ZN(
        serialdata_next[8]) );
  IND2D1BWP240H8P57PDSVT SYN_168 ( .A1(serial_windowreg[8]), .B1(n179), .ZN(
        serialdata_next[7]) );
  IND2D1BWP240H8P57PDSVT SYN_169 ( .A1(serial_windowreg[7]), .B1(n179), .ZN(
        serialdata_next[6]) );
  IND2D1BWP240H8P57PDSVT SYN_170 ( .A1(serial_windowreg[5]), .B1(n179), .ZN(
        serialdata_next[4]) );
  IND2D1BWP240H8P57PDSVT SYN_171 ( .A1(serial_windowreg[4]), .B1(n179), .ZN(
        serialdata_next[3]) );
  IND2D1BWP240H8P57PDSVT SYN_172 ( .A1(serial_windowreg[2]), .B1(n179), .ZN(
        serialdata_next[1]) );
  INVPADD1BWP240H8P57PDSVT SYN_173 ( .I(n158), .ZN(n161) );
  NR2D1BWP240H8P57PDSVT SYN_174 ( .A1(n159), .A2(n161), .ZN(N155) );
  NR2D1BWP240H8P57PDSVT SYN_175 ( .A1(n160), .A2(n161), .ZN(N156) );
  INVPADD1BWP240H8P57PDSVT SYN_176 ( .I(cmp_firstfail_cnt[6]), .ZN(n165) );
  INVPADD1BWP240H8P57PDSVT SYN_177 ( .I(cmp_firstfail_cnt[4]), .ZN(n166) );
  ND4D1BWP240H8P57PDSVT SYN_178 ( .A1(cmp_firstfail_cnt[0]), .A2(
        cmp_firstfail_cnt[1]), .A3(cmp_firstfail_cnt[2]), .A4(
        cmp_firstfail_cnt[3]), .ZN(n175) );
  NR2D1BWP240H8P57PDSVT SYN_179 ( .A1(n166), .A2(n175), .ZN(n174) );
  ND2D1BWP240H8P57PDSVT SYN_180 ( .A1(n174), .A2(cmp_firstfail_cnt[5]), .ZN(
        n173) );
  NR2D1BWP240H8P57PDSVT SYN_181 ( .A1(n165), .A2(n173), .ZN(n164) );
  NR2D1BWP240H8P57PDSVT SYN_182 ( .A1(n162), .A2(n161), .ZN(n1780) );
  OAI21D1BWP240H8P57PDSVT SYN_183 ( .A1(n164), .A2(cmp_firstfail_cnt[7]), .B(
        n1780), .ZN(n163) );
  AOI21D1BWP240H8P57PDSVT SYN_184 ( .A1(n164), .A2(cmp_firstfail_cnt[7]), .B(
        n163), .ZN(net733) );
  INVPADD1BWP240H8P57PDSVT SYN_185 ( .I(n1780), .ZN(n168) );
  AOI211D1BWP240H8P57PDSVT SYN_186 ( .A1(n173), .A2(n165), .B(n168), .C(n164), 
        .ZN(net734) );
  AOI211D1BWP240H8P57PDSVT SYN_187 ( .A1(n175), .A2(n166), .B(n168), .C(n174), 
        .ZN(net736) );
  ND2D1BWP240H8P57PDSVT SYN_188 ( .A1(cmp_firstfail_cnt[0]), .A2(
        cmp_firstfail_cnt[1]), .ZN(n177) );
  INVPADD1BWP240H8P57PDSVT SYN_189 ( .I(cmp_firstfail_cnt[2]), .ZN(n167) );
  NR2D1BWP240H8P57PDSVT SYN_190 ( .A1(n167), .A2(n177), .ZN(n176) );
  AOI211D1BWP240H8P57PDSVT SYN_191 ( .A1(n177), .A2(n167), .B(n168), .C(n176), 
        .ZN(net738) );
  NR2D1BWP240H8P57PDSVT SYN_192 ( .A1(cmp_firstfail_cnt[0]), .A2(n168), .ZN(
        net740) );
  INVPADD1BWP240H8P57PDSVT SYN_194 ( .I(tap_swcomp_active), .ZN(n172) );
  ND2D1BWP240H8P57PDSVT SYN_195 ( .A1(cmp_tdo_sel), .A2(n172), .ZN(n169) );
  INVPADD1BWP240H8P57PDSVT SYN_196 ( .I(n169), .ZN(n170) );
  AOI22D1BWP240H8P57PDSVT SYN_197 ( .A1(n170), .A2(serial_windowreg[0]), .B1(
        tdi), .B2(n169), .ZN(n171) );
  AOI21D1BWP240H8P57PDSVT SYN_198 ( .A1(cmp_tdo_forcelo), .A2(n172), .B(n171), 
        .ZN(tdo) );
  OA22D1BWP240H8P57PDSVT SYN_199 ( .A1(cmpen_main), .A2(cmp_tdo_sel), .B1(
        capture_dr), .B2(shift_dr), .Z(N178) );
  OA211D1BWP240H8P57PDSVT SYN_200 ( .A1(n174), .A2(cmp_firstfail_cnt[5]), .B(
        n1780), .C(n173), .Z(net735) );
  OA211D1BWP240H8P57PDSVT SYN_201 ( .A1(n176), .A2(cmp_firstfail_cnt[3]), .B(
        n1780), .C(n175), .Z(net737) );
  OA211D1BWP240H8P57PDSVT SYN_202 ( .A1(cmp_firstfail_cnt[0]), .A2(
        cmp_firstfail_cnt[1]), .B(n1780), .C(n177), .Z(net739) );
  AN2D1BWP240H8P57PDSVT SYN_203 ( .A1(serial_windowreg[1]), .A2(n179), .Z(
        serialdata_next[0]) );
  AN2D1BWP240H8P57PDSVT SYN_204 ( .A1(serial_windowreg[3]), .A2(n179), .Z(
        serialdata_next[2]) );
  AN2D1BWP240H8P57PDSVT SYN_205 ( .A1(serial_windowreg[6]), .A2(n179), .Z(
        serialdata_next[5]) );
  AN2D1BWP240H8P57PDSVT SYN_206 ( .A1(tdi), .A2(n179), .Z(serialdata_next[9])
         );
  INVPADD1BWP240H8P57PDSVT SYN_4 ( .I(jtrst_b), .ZN(n180) );
  INVPADD1BWP240H8P57PDSVT SYN_8 ( .I(cmp_mirror_sel), .ZN(n181) );
  INVPADD1BWP240H8P57PDSVT SYN_32 ( .I(cmpsel_signed), .ZN(n182) );
  INVPADD1BWP240H8P57PDSVT SYN_193 ( .I(cmplim_mask[0]), .ZN(n183) );
  SEDFRPQD1BWP240H11P57PDSVT cmp_sticky_fail_lo_reg ( .D(N156), .SI(1'b0), .E(
        cmp_enable), .SE(1'b0), .CP(jtclk), .CD(n180), .Q(cmp_sticky_fail_lo)
         );
  SEDFRPQD1BWP240H11P57PDSVT cmp_sticky_fail_hi_reg ( .D(N155), .SI(1'b0), .E(
        cmp_enable), .SE(1'b0), .CP(jtclk), .CD(n180), .Q(cmp_sticky_fail_hi)
         );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serial_windowreg_reg_0_2ndsig_serial_windowreg_reg_1_2ndsig_serial_windowreg_reg_2_2ndsig_serial_windowreg_reg_3 ( 
        .D1(serialdata_next[0]), .CP(net732), .CD(n180), .SE(1'b0), .SI(1'b0), 
        .Q1(serial_windowreg[0]), .D2(serialdata_next[1]), .Q2(
        serial_windowreg[1]), .D3(serialdata_next[2]), .Q3(serial_windowreg[2]), .D4(serialdata_next[3]), .Q4(serial_windowreg[3]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serial_windowreg_reg_4_2ndsig_serial_windowreg_reg_5_2ndsig_serial_windowreg_reg_6_2ndsig_serial_windowreg_reg_7 ( 
        .D1(serialdata_next[4]), .CP(net732), .CD(n180), .SE(1'b0), .SI(1'b0), 
        .Q1(serial_windowreg[4]), .D2(serialdata_next[5]), .Q2(
        serial_windowreg[5]), .D3(serialdata_next[6]), .Q3(serial_windowreg[6]), .D4(serialdata_next[7]), .Q4(serial_windowreg[7]) );
  MB2SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serial_windowreg_reg_8_2ndsig_serial_windowreg_reg_9 ( 
        .D1(serialdata_next[8]), .CP(net732), .CD(n180), .SE(1'b0), .SI(1'b0), 
        .Q1(serial_windowreg[8]), .D2(serialdata_next[9]), .Q2(
        serial_windowreg[9]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_cmp_firstfail_cnt_reg_0_2ndsig_cmp_firstfail_cnt_reg_1_2ndsig_cmp_firstfail_cnt_reg_2_2ndsig_cmp_firstfail_cnt_reg_3 ( 
        .D1(net740), .CP(net742), .CD(n180), .SE(1'b0), .SI(1'b0), .Q1(
        cmp_firstfail_cnt[0]), .D2(net739), .Q2(cmp_firstfail_cnt[1]), .D3(
        net738), .Q3(cmp_firstfail_cnt[2]), .D4(net737), .Q4(
        cmp_firstfail_cnt[3]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_cmp_firstfail_cnt_reg_4_2ndsig_cmp_firstfail_cnt_reg_5_2ndsig_cmp_firstfail_cnt_reg_6_2ndsig_cmp_firstfail_cnt_reg_7 ( 
        .D1(net736), .CP(net742), .CD(n180), .SE(1'b0), .SI(1'b0), .Q1(
        cmp_firstfail_cnt[4]), .D2(net735), .Q2(cmp_firstfail_cnt[5]), .D3(
        net734), .Q3(cmp_firstfail_cnt[6]), .D4(net733), .Q4(
        cmp_firstfail_cnt[7]) );
endmodule


module stap_SNPS_CLOCK_GATE_HIGH_stap_tapswcompreg_10_0 ( CLK, EN, ENCLK, TE
 );
  input CLK, EN, TE;
  output ENCLK;


  CKLNQD10BWP240H8P57PDSVT latch ( .CP(CLK), .E(EN), .TE(TE), .Q(ENCLK) );
endmodule


module stap_SNPS_CLOCK_GATE_LOW_stap_tapswcompreg_10_0 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;
  wire   net673, net675, net676;

  OR2D1BWP240H8P57PDSVT test_or ( .A1(EN), .A2(TE), .Z(net673) );
  INVPADD1BWP240H8P57PDSVT SYN_1 ( .I(net675), .ZN(net676) );
  LHQD1BWP240H11P57PDSVT latch ( .E(CLK), .D(net673), .Q(net675) );
  OR2D1BWP240H8P57PDSVT main_gate ( .A1(net676), .A2(CLK), .Z(ENCLK) );
endmodule


module stap_SNPS_CLOCK_GATE_LOW_stap_tapswcompreg_10_2 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;
  wire   net673, net675, net676;

  OR2D1BWP240H8P57PDSVT test_or ( .A1(EN), .A2(TE), .Z(net673) );
  INVPADD1BWP240H8P57PDSVT SYN_1 ( .I(net675), .ZN(net676) );
  OR2D1BWP240H8P57PDSVT main_gate ( .A1(net676), .A2(CLK), .Z(ENCLK) );
  LHQD1BWP240H11P57PDSVT latch ( .E(CLK), .D(net673), .Q(net675) );
endmodule


module stap_SNPS_CLOCK_GATE_LOW_stap_tapswcompreg_10_1 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;
  wire   net673, net675, net676;

  OR2D1BWP240H8P57PDSVT test_or ( .A1(EN), .A2(TE), .Z(net673) );
  INVPADD1BWP240H8P57PDSVT SYN_1 ( .I(net675), .ZN(net676) );
  OR2D1BWP240H8P57PDSVT main_gate ( .A1(net676), .A2(CLK), .Z(ENCLK) );
  LHQD1BWP240H11P57PDSVT latch ( .E(CLK), .D(net673), .Q(net675) );
endmodule


module stap_stap_tapswcompreg_10_0 ( jtclk, jpwrgood_rst_b, tdi, capture, 
        shift, update, enable, cmp_firstfail_cnt, cmp_sticky_fail_hi, 
        cmp_sticky_fail_lo, cmplim_hi, cmplim_lo, cmplim_mask, cmp_mirror_sel, 
        cmp_tdo_sel, cmp_tdo_forcelo, cmpen_main, cmpsel_signed, cmpsel_sgnmag, 
        cmpen_le_limhi, cmpen_ge_limlo, cmpen_blk_multi_fail, tdoctrl, tdostat
 );
  input [7:0] cmp_firstfail_cnt;
  output [9:0] cmplim_hi;
  output [9:0] cmplim_lo;
  output [9:0] cmplim_mask;
  input jtclk, jpwrgood_rst_b, tdi, capture, shift, update, enable,
         cmp_sticky_fail_hi, cmp_sticky_fail_lo;
  output cmp_mirror_sel, cmp_tdo_sel, cmp_tdo_forcelo, cmpen_main,
         cmpsel_signed, cmpsel_sgnmag, cmpen_le_limhi, cmpen_ge_limlo,
         cmpen_blk_multi_fail, tdoctrl, tdostat;
  wire   update_en, pdata_regval_1, pdata_regval_0, N9, net700, net703, net695,
         net698, n8, n11, n15, n36, n37, n38, n39, n44, n45, n46, n47, n48,
         n49, n50, n52;
  wire   [42:0] serialdata_next;
  wire   [42:1] serialdata;
  wire   [41:0] statusdata_next;
  wire   [42:1] statusdata;
  wire   [12:11] pdata_regval;

  stap_SNPS_CLOCK_GATE_HIGH_stap_tapswcompreg_10_0 clk_gate_serialdata_reg_42 ( 
        .CLK(jtclk), .EN(N9), .ENCLK(net698), .TE(1'b0) );
  stap_SNPS_CLOCK_GATE_LOW_stap_tapswcompreg_10_0 clk_gate_pdata_regval_reg_42 ( 
        .CLK(net695), .EN(serialdata[1]), .ENCLK(net700), .TE(1'b0) );
  stap_SNPS_CLOCK_GATE_LOW_stap_tapswcompreg_10_2 clk_gate_pdata_regval_reg_11 ( 
        .CLK(net695), .EN(serialdata[12]), .ENCLK(net703), .TE(1'b0) );
  stap_SNPS_CLOCK_GATE_LOW_stap_tapswcompreg_10_1 clk_gate_ml ( .CLK(jtclk), 
        .EN(update_en), .ENCLK(net695), .TE(1'b0) );
  AO22D1BWP240H8P57PDSVT SYN_7 ( .A1(n46), .A2(cmplim_hi[9]), .B1(n45), .B2(
        tdi), .Z(serialdata_next[42]) );
  AN2D1BWP240H8P57PDSVT SYN_8 ( .A1(enable), .A2(update), .Z(update_en) );
  IOA21D1BWP240H8P57PDSVT SYN_30 ( .A1(enable), .A2(shift), .B(n47), .ZN(N9)
         );
  ND2D1BWP240H8P57PDSVT SYN_34 ( .A1(n48), .A2(pdata_regval_0), .ZN(n15) );
  IOA21D1BWP240H8P57PDSVT SYN_35 ( .A1(statusdata[1]), .A2(n47), .B(n15), .ZN(
        statusdata_next[0]) );
  INR2D1BWP240H8P57PDSVT SYN_36 ( .A1(update_en), .B1(n47), .ZN(n11) );
  AO22D1BWP240H8P57PDSVT SYN_37 ( .A1(n11), .A2(serialdata[12]), .B1(
        statusdata[2]), .B2(n47), .Z(statusdata_next[1]) );
  AO22D1BWP240H8P57PDSVT SYN_38 ( .A1(n48), .A2(cmp_sticky_fail_lo), .B1(n47), 
        .B2(statusdata[3]), .Z(statusdata_next[2]) );
  AO22D1BWP240H8P57PDSVT SYN_39 ( .A1(n48), .A2(cmp_sticky_fail_hi), .B1(n47), 
        .B2(statusdata[4]), .Z(statusdata_next[3]) );
  AO22D1BWP240H8P57PDSVT SYN_40 ( .A1(n48), .A2(cmp_firstfail_cnt[0]), .B1(n47), .B2(statusdata[5]), .Z(statusdata_next[4]) );
  AO22D1BWP240H8P57PDSVT SYN_43 ( .A1(n48), .A2(cmp_firstfail_cnt[1]), .B1(n47), .B2(statusdata[6]), .Z(statusdata_next[5]) );
  AO22D1BWP240H8P57PDSVT SYN_44 ( .A1(n48), .A2(cmp_firstfail_cnt[2]), .B1(n47), .B2(statusdata[7]), .Z(statusdata_next[6]) );
  AO22D1BWP240H8P57PDSVT SYN_45 ( .A1(n48), .A2(cmp_firstfail_cnt[3]), .B1(n47), .B2(statusdata[8]), .Z(statusdata_next[7]) );
  AO22D1BWP240H8P57PDSVT SYN_46 ( .A1(n48), .A2(cmp_firstfail_cnt[4]), .B1(n47), .B2(statusdata[9]), .Z(statusdata_next[8]) );
  AO22D1BWP240H8P57PDSVT SYN_47 ( .A1(n48), .A2(cmp_firstfail_cnt[5]), .B1(n47), .B2(statusdata[10]), .Z(statusdata_next[9]) );
  AO22D1BWP240H8P57PDSVT SYN_48 ( .A1(n48), .A2(cmp_firstfail_cnt[6]), .B1(n47), .B2(statusdata[11]), .Z(statusdata_next[10]) );
  AO22D1BWP240H8P57PDSVT SYN_49 ( .A1(n48), .A2(cmp_firstfail_cnt[7]), .B1(n47), .B2(statusdata[12]), .Z(statusdata_next[11]) );
  AO22D1BWP240H8P57PDSVT SYN_50 ( .A1(serialdata[1]), .A2(n11), .B1(
        statusdata[13]), .B2(n47), .Z(statusdata_next[12]) );
  AO22D1BWP240H8P57PDSVT SYN_51 ( .A1(n50), .A2(cmplim_mask[0]), .B1(n49), 
        .B2(statusdata[14]), .Z(statusdata_next[13]) );
  AO22D1BWP240H8P57PDSVT SYN_52 ( .A1(n50), .A2(cmplim_mask[1]), .B1(n49), 
        .B2(statusdata[15]), .Z(statusdata_next[14]) );
  AO22D1BWP240H8P57PDSVT SYN_53 ( .A1(n50), .A2(cmplim_mask[2]), .B1(n49), 
        .B2(statusdata[16]), .Z(statusdata_next[15]) );
  AO22D1BWP240H8P57PDSVT SYN_54 ( .A1(n50), .A2(cmplim_mask[3]), .B1(n49), 
        .B2(statusdata[17]), .Z(statusdata_next[16]) );
  AO22D1BWP240H8P57PDSVT SYN_56 ( .A1(n52), .A2(cmplim_mask[4]), .B1(n8), .B2(
        statusdata[18]), .Z(statusdata_next[17]) );
  AO22D1BWP240H8P57PDSVT SYN_57 ( .A1(n52), .A2(cmplim_mask[5]), .B1(n8), .B2(
        statusdata[19]), .Z(statusdata_next[18]) );
  AO22D1BWP240H8P57PDSVT SYN_58 ( .A1(n52), .A2(cmplim_mask[6]), .B1(n8), .B2(
        statusdata[20]), .Z(statusdata_next[19]) );
  AO22D1BWP240H8P57PDSVT SYN_59 ( .A1(n52), .A2(cmplim_mask[7]), .B1(n8), .B2(
        statusdata[21]), .Z(statusdata_next[20]) );
  AO22D1BWP240H8P57PDSVT SYN_60 ( .A1(n52), .A2(cmplim_mask[8]), .B1(n8), .B2(
        statusdata[22]), .Z(statusdata_next[21]) );
  AO22D1BWP240H8P57PDSVT SYN_61 ( .A1(n52), .A2(cmplim_mask[9]), .B1(n8), .B2(
        statusdata[23]), .Z(statusdata_next[22]) );
  AO22D1BWP240H8P57PDSVT SYN_62 ( .A1(n52), .A2(cmplim_lo[0]), .B1(n8), .B2(
        statusdata[24]), .Z(statusdata_next[23]) );
  AO22D1BWP240H8P57PDSVT SYN_63 ( .A1(n44), .A2(cmplim_lo[1]), .B1(n8), .B2(
        statusdata[25]), .Z(statusdata_next[24]) );
  AO22D1BWP240H8P57PDSVT SYN_64 ( .A1(n44), .A2(cmplim_lo[2]), .B1(n8), .B2(
        statusdata[26]), .Z(statusdata_next[25]) );
  AO22D1BWP240H8P57PDSVT SYN_65 ( .A1(n44), .A2(cmplim_lo[3]), .B1(n8), .B2(
        statusdata[27]), .Z(statusdata_next[26]) );
  AO22D1BWP240H8P57PDSVT SYN_66 ( .A1(n44), .A2(cmplim_lo[4]), .B1(n8), .B2(
        statusdata[28]), .Z(statusdata_next[27]) );
  AO22D1BWP240H8P57PDSVT SYN_67 ( .A1(n44), .A2(cmplim_lo[5]), .B1(n8), .B2(
        statusdata[29]), .Z(statusdata_next[28]) );
  AO22D1BWP240H8P57PDSVT SYN_68 ( .A1(n44), .A2(cmplim_lo[6]), .B1(n8), .B2(
        statusdata[30]), .Z(statusdata_next[29]) );
  AO22D1BWP240H8P57PDSVT SYN_69 ( .A1(n44), .A2(cmplim_lo[7]), .B1(n8), .B2(
        statusdata[31]), .Z(statusdata_next[30]) );
  AO22D1BWP240H8P57PDSVT SYN_70 ( .A1(n44), .A2(cmplim_lo[8]), .B1(n8), .B2(
        statusdata[32]), .Z(statusdata_next[31]) );
  AO22D1BWP240H8P57PDSVT SYN_71 ( .A1(n44), .A2(cmplim_lo[9]), .B1(n8), .B2(
        statusdata[33]), .Z(statusdata_next[32]) );
  AO22D1BWP240H8P57PDSVT SYN_72 ( .A1(n46), .A2(cmplim_hi[0]), .B1(n45), .B2(
        statusdata[34]), .Z(statusdata_next[33]) );
  AO22D1BWP240H8P57PDSVT SYN_73 ( .A1(n44), .A2(cmplim_hi[1]), .B1(n8), .B2(
        statusdata[35]), .Z(statusdata_next[34]) );
  AO22D1BWP240H8P57PDSVT SYN_74 ( .A1(n44), .A2(cmplim_hi[2]), .B1(n8), .B2(
        statusdata[36]), .Z(statusdata_next[35]) );
  AO22D1BWP240H8P57PDSVT SYN_75 ( .A1(n46), .A2(cmplim_hi[3]), .B1(n45), .B2(
        statusdata[37]), .Z(statusdata_next[36]) );
  AO22D1BWP240H8P57PDSVT SYN_76 ( .A1(n46), .A2(cmplim_hi[4]), .B1(n45), .B2(
        statusdata[38]), .Z(statusdata_next[37]) );
  AO22D1BWP240H8P57PDSVT SYN_77 ( .A1(n46), .A2(cmplim_hi[5]), .B1(n45), .B2(
        statusdata[39]), .Z(statusdata_next[38]) );
  AO22D1BWP240H8P57PDSVT SYN_78 ( .A1(n46), .A2(cmplim_hi[6]), .B1(n45), .B2(
        statusdata[40]), .Z(statusdata_next[39]) );
  AO22D1BWP240H8P57PDSVT SYN_79 ( .A1(n46), .A2(cmplim_hi[7]), .B1(n45), .B2(
        statusdata[41]), .Z(statusdata_next[40]) );
  AO22D1BWP240H8P57PDSVT SYN_80 ( .A1(n46), .A2(cmplim_hi[8]), .B1(n45), .B2(
        statusdata[42]), .Z(statusdata_next[41]) );
  IOA21D1BWP240H8P57PDSVT SYN_81 ( .A1(serialdata[1]), .A2(n45), .B(n15), .ZN(
        serialdata_next[0]) );
  AO22D1BWP240H8P57PDSVT SYN_82 ( .A1(n46), .A2(pdata_regval_1), .B1(n45), 
        .B2(serialdata[2]), .Z(serialdata_next[1]) );
  AO22D1BWP240H8P57PDSVT SYN_83 ( .A1(n48), .A2(cmpen_ge_limlo), .B1(n47), 
        .B2(serialdata[3]), .Z(serialdata_next[2]) );
  AO22D1BWP240H8P57PDSVT SYN_84 ( .A1(n48), .A2(cmpen_le_limhi), .B1(n47), 
        .B2(serialdata[4]), .Z(serialdata_next[3]) );
  AO22D1BWP240H8P57PDSVT SYN_85 ( .A1(n48), .A2(cmpen_main), .B1(n47), .B2(
        serialdata[5]), .Z(serialdata_next[4]) );
  AO22D1BWP240H8P57PDSVT SYN_88 ( .A1(n50), .A2(cmp_tdo_forcelo), .B1(n49), 
        .B2(serialdata[6]), .Z(serialdata_next[5]) );
  AO22D1BWP240H8P57PDSVT SYN_89 ( .A1(n50), .A2(cmp_tdo_sel), .B1(n49), .B2(
        serialdata[7]), .Z(serialdata_next[6]) );
  AO22D1BWP240H8P57PDSVT SYN_90 ( .A1(n50), .A2(cmp_mirror_sel), .B1(n49), 
        .B2(serialdata[8]), .Z(serialdata_next[7]) );
  AO22D1BWP240H8P57PDSVT SYN_91 ( .A1(n50), .A2(cmpen_blk_multi_fail), .B1(n49), .B2(serialdata[9]), .Z(serialdata_next[8]) );
  AO22D1BWP240H8P57PDSVT SYN_92 ( .A1(n50), .A2(cmpsel_sgnmag), .B1(n49), .B2(
        serialdata[10]), .Z(serialdata_next[9]) );
  AO22D1BWP240H8P57PDSVT SYN_93 ( .A1(n50), .A2(cmpsel_signed), .B1(n49), .B2(
        serialdata[11]), .Z(serialdata_next[10]) );
  AO22D1BWP240H8P57PDSVT SYN_94 ( .A1(n50), .A2(pdata_regval[11]), .B1(n49), 
        .B2(serialdata[12]), .Z(serialdata_next[11]) );
  AO22D1BWP240H8P57PDSVT SYN_95 ( .A1(n50), .A2(pdata_regval[12]), .B1(n49), 
        .B2(serialdata[13]), .Z(serialdata_next[12]) );
  AO22D1BWP240H8P57PDSVT SYN_96 ( .A1(n50), .A2(cmplim_mask[0]), .B1(n49), 
        .B2(serialdata[14]), .Z(serialdata_next[13]) );
  AO22D1BWP240H8P57PDSVT SYN_97 ( .A1(n50), .A2(cmplim_mask[1]), .B1(n49), 
        .B2(serialdata[15]), .Z(serialdata_next[14]) );
  AO22D1BWP240H8P57PDSVT SYN_98 ( .A1(n50), .A2(cmplim_mask[2]), .B1(n49), 
        .B2(serialdata[16]), .Z(serialdata_next[15]) );
  AO22D1BWP240H8P57PDSVT SYN_99 ( .A1(n50), .A2(cmplim_mask[3]), .B1(n49), 
        .B2(serialdata[17]), .Z(serialdata_next[16]) );
  AO22D1BWP240H8P57PDSVT SYN_100 ( .A1(n50), .A2(cmplim_mask[4]), .B1(n49), 
        .B2(serialdata[18]), .Z(serialdata_next[17]) );
  AO22D1BWP240H8P57PDSVT SYN_101 ( .A1(n52), .A2(cmplim_mask[5]), .B1(n8), 
        .B2(serialdata[19]), .Z(serialdata_next[18]) );
  AO22D1BWP240H8P57PDSVT SYN_102 ( .A1(n52), .A2(cmplim_mask[6]), .B1(n8), 
        .B2(serialdata[20]), .Z(serialdata_next[19]) );
  AO22D1BWP240H8P57PDSVT SYN_103 ( .A1(n52), .A2(cmplim_mask[7]), .B1(n8), 
        .B2(serialdata[21]), .Z(serialdata_next[20]) );
  AO22D1BWP240H8P57PDSVT SYN_104 ( .A1(n52), .A2(cmplim_mask[8]), .B1(n8), 
        .B2(serialdata[22]), .Z(serialdata_next[21]) );
  AO22D1BWP240H8P57PDSVT SYN_105 ( .A1(n52), .A2(cmplim_mask[9]), .B1(n8), 
        .B2(serialdata[23]), .Z(serialdata_next[22]) );
  AO22D1BWP240H8P57PDSVT SYN_106 ( .A1(n52), .A2(cmplim_lo[0]), .B1(n8), .B2(
        serialdata[24]), .Z(serialdata_next[23]) );
  AO22D1BWP240H8P57PDSVT SYN_107 ( .A1(n52), .A2(cmplim_lo[1]), .B1(n8), .B2(
        serialdata[25]), .Z(serialdata_next[24]) );
  AO22D1BWP240H8P57PDSVT SYN_108 ( .A1(n44), .A2(cmplim_lo[2]), .B1(n8), .B2(
        serialdata[26]), .Z(serialdata_next[25]) );
  AO22D1BWP240H8P57PDSVT SYN_109 ( .A1(n44), .A2(cmplim_lo[3]), .B1(n8), .B2(
        serialdata[27]), .Z(serialdata_next[26]) );
  AO22D1BWP240H8P57PDSVT SYN_110 ( .A1(n44), .A2(cmplim_lo[4]), .B1(n8), .B2(
        serialdata[28]), .Z(serialdata_next[27]) );
  AO22D1BWP240H8P57PDSVT SYN_111 ( .A1(n44), .A2(cmplim_lo[5]), .B1(n8), .B2(
        serialdata[29]), .Z(serialdata_next[28]) );
  AO22D1BWP240H8P57PDSVT SYN_112 ( .A1(n44), .A2(cmplim_lo[6]), .B1(n8), .B2(
        serialdata[30]), .Z(serialdata_next[29]) );
  AO22D1BWP240H8P57PDSVT SYN_113 ( .A1(n44), .A2(cmplim_lo[7]), .B1(n8), .B2(
        serialdata[31]), .Z(serialdata_next[30]) );
  AO22D1BWP240H8P57PDSVT SYN_114 ( .A1(n52), .A2(cmplim_lo[8]), .B1(n8), .B2(
        serialdata[32]), .Z(serialdata_next[31]) );
  AO22D1BWP240H8P57PDSVT SYN_115 ( .A1(n44), .A2(cmplim_lo[9]), .B1(n8), .B2(
        serialdata[33]), .Z(serialdata_next[32]) );
  AO22D1BWP240H8P57PDSVT SYN_116 ( .A1(n46), .A2(cmplim_hi[0]), .B1(n45), .B2(
        serialdata[34]), .Z(serialdata_next[33]) );
  AO22D1BWP240H8P57PDSVT SYN_117 ( .A1(n46), .A2(cmplim_hi[1]), .B1(n45), .B2(
        serialdata[35]), .Z(serialdata_next[34]) );
  AO22D1BWP240H8P57PDSVT SYN_118 ( .A1(n44), .A2(cmplim_hi[2]), .B1(n8), .B2(
        serialdata[36]), .Z(serialdata_next[35]) );
  AO22D1BWP240H8P57PDSVT SYN_119 ( .A1(n44), .A2(cmplim_hi[3]), .B1(n8), .B2(
        serialdata[37]), .Z(serialdata_next[36]) );
  AO22D1BWP240H8P57PDSVT SYN_120 ( .A1(n46), .A2(cmplim_hi[4]), .B1(n45), .B2(
        serialdata[38]), .Z(serialdata_next[37]) );
  AO22D1BWP240H8P57PDSVT SYN_121 ( .A1(n46), .A2(cmplim_hi[5]), .B1(n45), .B2(
        serialdata[39]), .Z(serialdata_next[38]) );
  AO22D1BWP240H8P57PDSVT SYN_122 ( .A1(n46), .A2(cmplim_hi[6]), .B1(n45), .B2(
        serialdata[40]), .Z(serialdata_next[39]) );
  AO22D1BWP240H8P57PDSVT SYN_123 ( .A1(n46), .A2(cmplim_hi[7]), .B1(n45), .B2(
        serialdata[41]), .Z(serialdata_next[40]) );
  AO22D1BWP240H8P57PDSVT SYN_124 ( .A1(n46), .A2(cmplim_hi[8]), .B1(n45), .B2(
        serialdata[42]), .Z(serialdata_next[41]) );
  INVPADD1BWP240H8P57PDSVT SYN_3 ( .I(jpwrgood_rst_b), .ZN(n36) );
  INVPADD1BWP240H8P57PDSVT SYN_6 ( .I(jpwrgood_rst_b), .ZN(n39) );
  INVPADD1BWP240H8P57PDSVT SYN_13 ( .I(n8), .ZN(n44) );
  BUFFD1BWP240H8P57PDSVT SYN_14 ( .I(n8), .Z(n45) );
  INVPADD1BWP240H8P57PDSVT SYN_15 ( .I(n45), .ZN(n46) );
  BUFFD1BWP240H8P57PDSVT SYN_16 ( .I(n8), .Z(n47) );
  INVPADD1BWP240H8P57PDSVT SYN_17 ( .I(n47), .ZN(n48) );
  BUFFD1BWP240H8P57PDSVT SYN_18 ( .I(n8), .Z(n49) );
  INVPADD1BWP240H8P57PDSVT SYN_19 ( .I(n49), .ZN(n50) );
  INVPADD1BWP240H8P57PDSVT SYN_21 ( .I(n8), .ZN(n52) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_0 ( .D(tdoctrl), .SI(1'b0), .SE(
        1'b0), .CPN(net695), .CD(n37), .Q(pdata_regval_0) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_1 ( .D(serialdata[1]), .SI(1'b0), 
        .SE(1'b0), .CPN(net695), .CD(n37), .Q(pdata_regval_1) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_11 ( .D(serialdata[11]), .SI(
        1'b0), .SE(1'b0), .CPN(net703), .CD(n37), .Q(pdata_regval[11]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_12 ( .D(serialdata[12]), .SI(
        1'b0), .SE(1'b0), .CPN(net695), .CD(n37), .Q(pdata_regval[12]) );
  SDFRPQD1BWP240H11P57PDSVT statusdata_reg_42 ( .D(serialdata_next[42]), .SI(
        1'b0), .SE(1'b0), .CP(net698), .CD(n39), .Q(statusdata[42]) );
  SDFRPQD1BWP240H11P57PDSVT statusdata_reg_24 ( .D(statusdata_next[24]), .SI(
        1'b0), .SE(1'b0), .CP(net698), .CD(n36), .Q(statusdata[24]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_2 ( .D(serialdata[2]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmpen_ge_limlo) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_5 ( .D(serialdata[5]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmp_tdo_forcelo) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_3 ( .D(serialdata[3]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmpen_le_limhi) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_10 ( .D(serialdata[10]), .SI(
        1'b0), .SE(1'b0), .CPN(net703), .CD(n38), .Q(cmpsel_signed) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_8 ( .D(serialdata[8]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmpen_blk_multi_fail) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_13 ( .D(serialdata[13]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[0]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_23 ( .D(serialdata[23]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n36), .Q(cmplim_lo[0]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_22 ( .D(serialdata[22]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[9]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_9 ( .D(serialdata[9]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmpsel_sgnmag) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_33 ( .D(serialdata[33]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n39), .Q(cmplim_hi[0]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_21 ( .D(serialdata[21]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[8]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_6 ( .D(serialdata[6]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmp_tdo_sel) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_17 ( .D(serialdata[17]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[4]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_19 ( .D(serialdata[19]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[6]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_18 ( .D(serialdata[18]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[5]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_35 ( .D(serialdata[35]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_hi[2]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_24 ( .D(serialdata[24]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n36), .Q(cmplim_lo[1]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_25 ( .D(serialdata[25]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n36), .Q(cmplim_lo[2]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_36 ( .D(serialdata[36]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_hi[3]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_20 ( .D(serialdata[20]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[7]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_26 ( .D(serialdata[26]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_lo[3]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_34 ( .D(serialdata[34]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n39), .Q(cmplim_hi[1]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_31 ( .D(serialdata[31]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_lo[8]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_4 ( .D(serialdata[4]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmpen_main) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_30 ( .D(serialdata[30]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_lo[7]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_28 ( .D(serialdata[28]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_lo[5]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_29 ( .D(serialdata[29]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_lo[6]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_41 ( .D(serialdata[41]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n39), .Q(cmplim_hi[8]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_27 ( .D(serialdata[27]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_lo[4]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_37 ( .D(serialdata[37]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_hi[4]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_39 ( .D(serialdata[39]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n37), .Q(cmplim_hi[6]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_42 ( .D(serialdata[42]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n39), .Q(cmplim_hi[9]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_40 ( .D(serialdata[40]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n39), .Q(cmplim_hi[7]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_38 ( .D(serialdata[38]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_hi[5]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_32 ( .D(serialdata[32]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_lo[9]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_15 ( .D(serialdata[15]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[2]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_7 ( .D(serialdata[7]), .SI(1'b0), 
        .SE(1'b0), .CPN(net703), .CD(n37), .Q(cmp_mirror_sel) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_14 ( .D(serialdata[14]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n38), .Q(cmplim_mask[1]) );
  SDFNRPQD1BWP240H11P57PDSVT pdata_regval_reg_16 ( .D(serialdata[16]), .SI(
        1'b0), .SE(1'b0), .CPN(net700), .CD(n37), .Q(cmplim_mask[3]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_1_2ndsig_serialdata_reg_20_2ndsig_serialdata_reg_21_2ndsig_serialdata_reg_22 ( 
        .D1(serialdata_next[1]), .CP(net698), .CD(n39), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[1]), .D2(serialdata_next[20]), .Q2(serialdata[20]), 
        .D3(serialdata_next[21]), .Q3(serialdata[21]), .D4(serialdata_next[22]), .Q4(serialdata[22]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_23_2ndsig_serialdata_reg_24_2ndsig_serialdata_reg_25_2ndsig_serialdata_reg_26 ( 
        .D1(serialdata_next[23]), .CP(net698), .CD(n38), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[23]), .D2(serialdata_next[24]), .Q2(serialdata[24]), 
        .D3(serialdata_next[25]), .Q3(serialdata[25]), .D4(serialdata_next[26]), .Q4(serialdata[26]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_27_2ndsig_serialdata_reg_28_2ndsig_serialdata_reg_29_2ndsig_serialdata_reg_30 ( 
        .D1(serialdata_next[27]), .CP(net698), .CD(n36), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[27]), .D2(serialdata_next[28]), .Q2(serialdata[28]), 
        .D3(serialdata_next[29]), .Q3(serialdata[29]), .D4(serialdata_next[30]), .Q4(serialdata[30]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_31_2ndsig_statusdata_reg_17_2ndsig_statusdata_reg_18_2ndsig_statusdata_reg_19 ( 
        .D1(serialdata_next[31]), .CP(net698), .CD(n36), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[31]), .D2(statusdata_next[17]), .Q2(statusdata[17]), 
        .D3(statusdata_next[18]), .Q3(statusdata[18]), .D4(statusdata_next[19]), .Q4(statusdata[19]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_20_2ndsig_statusdata_reg_21_2ndsig_statusdata_reg_22_2ndsig_statusdata_reg_23 ( 
        .D1(statusdata_next[20]), .CP(net698), .CD(n36), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[20]), .D2(statusdata_next[21]), .Q2(statusdata[21]), 
        .D3(statusdata_next[22]), .Q3(statusdata[22]), .D4(statusdata_next[23]), .Q4(statusdata[23]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_8_2ndsig_serialdata_reg_9_2ndsig_serialdata_reg_10_2ndsig_serialdata_reg_11 ( 
        .D1(serialdata_next[8]), .CP(net698), .CD(n37), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[8]), .D2(serialdata_next[9]), .Q2(serialdata[9]), .D3(
        serialdata_next[10]), .Q3(serialdata[10]), .D4(serialdata_next[11]), 
        .Q4(serialdata[11]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_13_2ndsig_serialdata_reg_14_2ndsig_serialdata_reg_15_2ndsig_serialdata_reg_16 ( 
        .D1(serialdata_next[13]), .CP(net698), .CD(n38), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[13]), .D2(serialdata_next[14]), .Q2(serialdata[14]), 
        .D3(serialdata_next[15]), .Q3(serialdata[15]), .D4(serialdata_next[16]), .Q4(serialdata[16]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_17_2ndsig_serialdata_reg_18_2ndsig_serialdata_reg_19_2ndsig_statusdata_reg_14 ( 
        .D1(serialdata_next[17]), .CP(net698), .CD(n38), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[17]), .D2(serialdata_next[18]), .Q2(serialdata[18]), 
        .D3(serialdata_next[19]), .Q3(serialdata[19]), .D4(statusdata_next[14]), .Q4(statusdata[14]) );
  MB2SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_15_2ndsig_statusdata_reg_16 ( 
        .D1(statusdata_next[15]), .CP(net698), .CD(n38), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[15]), .D2(statusdata_next[16]), .Q2(statusdata[16]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_0_2ndsig_serialdata_reg_2_2ndsig_serialdata_reg_3_2ndsig_serialdata_reg_4 ( 
        .D1(serialdata_next[0]), .CP(net698), .CD(n39), .SE(1'b0), .SI(1'b0), 
        .Q1(tdoctrl), .D2(serialdata_next[2]), .Q2(serialdata[2]), .D3(
        serialdata_next[3]), .Q3(serialdata[3]), .D4(serialdata_next[4]), .Q4(
        serialdata[4]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_5_2ndsig_serialdata_reg_6_2ndsig_serialdata_reg_7_2ndsig_serialdata_reg_12 ( 
        .D1(serialdata_next[5]), .CP(net698), .CD(n37), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[5]), .D2(serialdata_next[6]), .Q2(serialdata[6]), .D3(
        serialdata_next[7]), .Q3(serialdata[7]), .D4(serialdata_next[12]), 
        .Q4(serialdata[12]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_0_2ndsig_statusdata_reg_1_2ndsig_statusdata_reg_2_2ndsig_statusdata_reg_3 ( 
        .D1(statusdata_next[0]), .CP(net698), .CD(n37), .SE(1'b0), .SI(1'b0), 
        .Q1(tdostat), .D2(statusdata_next[1]), .Q2(statusdata[1]), .D3(
        statusdata_next[2]), .Q3(statusdata[2]), .D4(statusdata_next[3]), .Q4(
        statusdata[3]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_4_2ndsig_statusdata_reg_5_2ndsig_statusdata_reg_6_2ndsig_statusdata_reg_7 ( 
        .D1(statusdata_next[4]), .CP(net698), .CD(n37), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[4]), .D2(statusdata_next[5]), .Q2(statusdata[5]), .D3(
        statusdata_next[6]), .Q3(statusdata[6]), .D4(statusdata_next[7]), .Q4(
        statusdata[7]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_8_2ndsig_statusdata_reg_9_2ndsig_statusdata_reg_10_2ndsig_statusdata_reg_11 ( 
        .D1(statusdata_next[8]), .CP(net698), .CD(n37), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[8]), .D2(statusdata_next[9]), .Q2(statusdata[9]), .D3(
        statusdata_next[10]), .Q3(statusdata[10]), .D4(statusdata_next[11]), 
        .Q4(statusdata[11]) );
  MB2SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_12_2ndsig_statusdata_reg_13 ( 
        .D1(statusdata_next[12]), .CP(net698), .CD(n37), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[12]), .D2(statusdata_next[13]), .Q2(statusdata[13]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_32_2ndsig_serialdata_reg_33_2ndsig_serialdata_reg_34_2ndsig_serialdata_reg_35 ( 
        .D1(serialdata_next[32]), .CP(net698), .CD(n39), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[32]), .D2(serialdata_next[33]), .Q2(serialdata[33]), 
        .D3(serialdata_next[34]), .Q3(serialdata[34]), .D4(serialdata_next[35]), .Q4(serialdata[35]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_36_2ndsig_serialdata_reg_37_2ndsig_serialdata_reg_38_2ndsig_serialdata_reg_39 ( 
        .D1(serialdata_next[36]), .CP(net698), .CD(n39), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[36]), .D2(serialdata_next[37]), .Q2(serialdata[37]), 
        .D3(serialdata_next[38]), .Q3(serialdata[38]), .D4(serialdata_next[39]), .Q4(serialdata[39]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_serialdata_reg_40_2ndsig_serialdata_reg_41_2ndsig_serialdata_reg_42_2ndsig_statusdata_reg_25 ( 
        .D1(serialdata_next[40]), .CP(net698), .CD(n39), .SE(1'b0), .SI(1'b0), 
        .Q1(serialdata[40]), .D2(serialdata_next[41]), .Q2(serialdata[41]), 
        .D3(serialdata_next[42]), .Q3(serialdata[42]), .D4(statusdata_next[25]), .Q4(statusdata[25]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_26_2ndsig_statusdata_reg_27_2ndsig_statusdata_reg_28_2ndsig_statusdata_reg_29 ( 
        .D1(statusdata_next[26]), .CP(net698), .CD(n36), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[26]), .D2(statusdata_next[27]), .Q2(statusdata[27]), 
        .D3(statusdata_next[28]), .Q3(statusdata[28]), .D4(statusdata_next[29]), .Q4(statusdata[29]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_30_2ndsig_statusdata_reg_31_2ndsig_statusdata_reg_32_2ndsig_statusdata_reg_33 ( 
        .D1(statusdata_next[30]), .CP(net698), .CD(n36), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[30]), .D2(statusdata_next[31]), .Q2(statusdata[31]), 
        .D3(statusdata_next[32]), .Q3(statusdata[32]), .D4(statusdata_next[33]), .Q4(statusdata[33]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_34_2ndsig_statusdata_reg_35_2ndsig_statusdata_reg_36_2ndsig_statusdata_reg_37 ( 
        .D1(statusdata_next[34]), .CP(net698), .CD(n39), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[34]), .D2(statusdata_next[35]), .Q2(statusdata[35]), 
        .D3(statusdata_next[36]), .Q3(statusdata[36]), .D4(statusdata_next[37]), .Q4(statusdata[37]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_statusdata_reg_38_2ndsig_statusdata_reg_39_2ndsig_statusdata_reg_40_2ndsig_statusdata_reg_41 ( 
        .D1(statusdata_next[38]), .CP(net698), .CD(n39), .SE(1'b0), .SI(1'b0), 
        .Q1(statusdata[38]), .D2(statusdata_next[39]), .Q2(statusdata[39]), 
        .D3(statusdata_next[40]), .Q3(statusdata[40]), .D4(statusdata_next[41]), .Q4(statusdata[41]) );
  ND2D1BWP240H8P57PDSVT SYN_2 ( .A1(enable), .A2(capture), .ZN(n8) );
  INVSKRD2BWP240H8P57PDSVT SYN_4 ( .I(jpwrgood_rst_b), .ZN(n37) );
  INVSKRD2BWP240H8P57PDSVT SYN_5 ( .I(jpwrgood_rst_b), .ZN(n38) );
endmodule


module stap_stap_swcomp_rtdr_10_0 ( stap_fsm_tlrs, ftap_tck, ftap_tdi, 
        fdfx_powergood, powergood_rst_trst_b, stap_fsm_capture_dr, 
        stap_fsm_shift_dr, stap_fsm_update_dr, stap_fsm_e2dr, 
        stap_swcomp_pre_tdo, tap_swcomp_active, swcomp_stap_post_tdo, 
        swcompctrl_tdo, swcompstat_tdo );
  input stap_fsm_tlrs, ftap_tck, ftap_tdi, fdfx_powergood,
         powergood_rst_trst_b, stap_fsm_capture_dr, stap_fsm_shift_dr,
         stap_fsm_update_dr, stap_fsm_e2dr, stap_swcomp_pre_tdo,
         tap_swcomp_active;
  output swcomp_stap_post_tdo, swcompctrl_tdo, swcompstat_tdo;
  wire   cmp_mirror_sel, cmp_tdo_sel, cmp_tdo_forcelo, cmpen_main,
         cmpsel_signed, cmpsel_sgnmag, cmpen_le_limhi, cmpen_ge_limlo,
         cmpen_blk_multi_fail, cmp_sticky_fail_hi, cmp_sticky_fail_lo, n3, n4;
  wire   [9:0] cmplim_hi;
  wire   [9:0] cmplim_lo;
  wire   [9:0] cmplim_mask;
  wire   [7:0] cmp_firstfail_cnt;

  stap_stap_tapswcomp_10_0 i_stap_tapswcomp ( .jtclk(ftap_tck), .jtrst_b(
        powergood_rst_trst_b), .tdi(stap_swcomp_pre_tdo), .test_logic_reset(
        stap_fsm_tlrs), .capture_dr(stap_fsm_capture_dr), .shift_dr(
        stap_fsm_shift_dr), .exit2_dr(stap_fsm_e2dr), .tap_swcomp_active(
        tap_swcomp_active), .cmplim_hi(cmplim_hi), .cmplim_lo(cmplim_lo), 
        .cmplim_mask({cmplim_mask[9:1], n4}), .cmp_mirror_sel(cmp_mirror_sel), 
        .cmp_tdo_sel(cmp_tdo_sel), .cmp_tdo_forcelo(cmp_tdo_forcelo), 
        .cmpen_main(cmpen_main), .cmpsel_signed(n3), .cmpsel_sgnmag(
        cmpsel_sgnmag), .cmpen_le_limhi(cmpen_le_limhi), .cmpen_ge_limlo(
        cmpen_ge_limlo), .cmpen_blk_multi_fail(cmpen_blk_multi_fail), 
        .cmp_firstfail_cnt(cmp_firstfail_cnt), .cmp_sticky_fail_hi(
        cmp_sticky_fail_hi), .cmp_sticky_fail_lo(cmp_sticky_fail_lo), .tdo(
        swcomp_stap_post_tdo) );
  stap_stap_tapswcompreg_10_0 i_stap_tapswcompreg ( .jtclk(ftap_tck), 
        .jpwrgood_rst_b(fdfx_powergood), .tdi(ftap_tdi), .capture(
        stap_fsm_capture_dr), .shift(stap_fsm_shift_dr), .update(
        stap_fsm_update_dr), .enable(tap_swcomp_active), .cmp_firstfail_cnt(
        cmp_firstfail_cnt), .cmp_sticky_fail_hi(cmp_sticky_fail_hi), 
        .cmp_sticky_fail_lo(cmp_sticky_fail_lo), .cmplim_hi(cmplim_hi), 
        .cmplim_lo(cmplim_lo), .cmplim_mask(cmplim_mask), .cmp_mirror_sel(
        cmp_mirror_sel), .cmp_tdo_sel(cmp_tdo_sel), .cmp_tdo_forcelo(
        cmp_tdo_forcelo), .cmpen_main(cmpen_main), .cmpsel_signed(
        cmpsel_signed), .cmpsel_sgnmag(cmpsel_sgnmag), .cmpen_le_limhi(
        cmpen_le_limhi), .cmpen_ge_limlo(cmpen_ge_limlo), 
        .cmpen_blk_multi_fail(cmpen_blk_multi_fail), .tdoctrl(swcompctrl_tdo), 
        .tdostat(swcompstat_tdo) );
  BUFFD1BWP240H8P57PDSVT SYN_1 ( .I(cmpsel_signed), .Z(n3) );
  BUFFD1BWP240H8P57PDSVT SYN_2 ( .I(cmplim_mask[0]), .Z(n4) );
endmodule


module stap_stap_fsm_0_0_0_0_8_0_0 ( ftap_tms, ftap_tck, powergood_rst_trst_b, 
        suppress_update_capture_reg, stap_irreg_ireg, tapc_remove, 
        stap_fsm_tlrs, stap_fsm_rti, stap_fsm_e1dr, stap_fsm_e2dr, 
        stap_selectwir, stap_selectwir_neg, sn_fwtap_capturewr, 
        sn_fwtap_shiftwr, sn_fwtap_updatewr, sn_fwtap_rti, sn_fwtap_wrst_b, 
        stap_fsm_capture_ir, stap_fsm_shift_ir, stap_fsm_shift_ir_neg, 
        stap_fsm_update_ir, stap_fsm_capture_dr, stap_fsm_shift_dr, 
        stap_fsm_update_dr );
  input [1:0] suppress_update_capture_reg;
  input [7:0] stap_irreg_ireg;
  input ftap_tms, ftap_tck, powergood_rst_trst_b, tapc_remove;
  output stap_fsm_tlrs, stap_fsm_rti, stap_fsm_e1dr, stap_fsm_e2dr,
         stap_selectwir, stap_selectwir_neg, sn_fwtap_capturewr,
         sn_fwtap_shiftwr, sn_fwtap_updatewr, sn_fwtap_rti, sn_fwtap_wrst_b,
         stap_fsm_capture_ir, stap_fsm_shift_ir, stap_fsm_shift_ir_neg,
         stap_fsm_update_ir, stap_fsm_capture_dr, stap_fsm_shift_dr,
         stap_fsm_update_dr;
  wire   N468, N469, N470, N471, N473, N474, N475, N476, N477, N478, N479,
         N480, N481, N482, N483, N484, N485, N486, N487, N488, n1, n2, n3, n4,
         n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65;
  wire   [15:0] state_ps;
  wire   [3:0] tms_bit;
  assign stap_fsm_update_ir = state_ps[15];
  assign stap_fsm_shift_ir = state_ps[11];
  assign stap_fsm_capture_ir = state_ps[10];
  assign stap_fsm_update_dr = state_ps[8];
  assign stap_fsm_e2dr = state_ps[7];
  assign stap_fsm_e1dr = state_ps[5];
  assign stap_fsm_shift_dr = state_ps[4];
  assign stap_fsm_capture_dr = state_ps[3];
  assign stap_fsm_rti = state_ps[1];
  assign stap_fsm_tlrs = state_ps[0];

  INVPADD1BWP240H8P57PDSVT SYN_3 ( .I(state_ps[6]), .ZN(n4) );
  NR4D1BWP240H8P57PDSVT SYN_4 ( .A1(state_ps[13]), .A2(state_ps[11]), .A3(
        state_ps[12]), .A4(state_ps[14]), .ZN(n29) );
  INR2D1BWP240H8P57PDSVT SYN_5 ( .A1(n29), .B1(state_ps[0]), .ZN(n9) );
  INR4D1BWP240H8P57PDSVT SYN_6 ( .A1(n9), .B1(state_ps[15]), .B2(state_ps[10]), 
        .B3(state_ps[9]), .ZN(n20) );
  IND2D1BWP240H8P57PDSVT SYN_7 ( .A1(state_ps[8]), .B1(n20), .ZN(n31) );
  NR2D1BWP240H8P57PDSVT SYN_8 ( .A1(state_ps[7]), .A2(n31), .ZN(n1) );
  INVPADD1BWP240H8P57PDSVT SYN_9 ( .I(state_ps[5]), .ZN(n56) );
  ND2D1BWP240H8P57PDSVT SYN_10 ( .A1(n1), .A2(n56), .ZN(n3) );
  NR3D1BWP240H8P57PDSVT SYN_11 ( .A1(state_ps[3]), .A2(state_ps[2]), .A3(n3), 
        .ZN(n5) );
  INVPADD1BWP240H8P57PDSVT SYN_12 ( .I(state_ps[4]), .ZN(n2) );
  ND2D1BWP240H8P57PDSVT SYN_13 ( .A1(n5), .A2(n2), .ZN(n25) );
  NR3D1BWP240H8P57PDSVT SYN_14 ( .A1(state_ps[1]), .A2(n4), .A3(n25), .ZN(n64)
         );
  INVPADD1BWP240H8P57PDSVT SYN_15 ( .I(state_ps[3]), .ZN(n23) );
  INVPADD1BWP240H8P57PDSVT SYN_16 ( .I(state_ps[1]), .ZN(n26) );
  ND3D1BWP240H8P57PDSVT SYN_17 ( .A1(n26), .A2(n4), .A3(n2), .ZN(n8) );
  NR2D1BWP240H8P57PDSVT SYN_18 ( .A1(n3), .A2(n8), .ZN(n24) );
  INVPADD1BWP240H8P57PDSVT SYN_19 ( .I(n24), .ZN(n7) );
  ND4D1BWP240H8P57PDSVT SYN_20 ( .A1(state_ps[4]), .A2(n5), .A3(n26), .A4(n4), 
        .ZN(n6) );
  OAI31D1BWP240H8P57PDSVT SYN_21 ( .A1(state_ps[2]), .A2(n23), .A3(n7), .B(n6), 
        .ZN(n55) );
  INVPADD1BWP240H8P57PDSVT SYN_22 ( .I(state_ps[9]), .ZN(n13) );
  OR3D1BWP240H8P57PDSVT SYN_23 ( .A1(state_ps[3]), .A2(state_ps[2]), .A3(n8), 
        .Z(n30) );
  NR3D1BWP240H8P57PDSVT SYN_24 ( .A1(n30), .A2(state_ps[5]), .A3(state_ps[7]), 
        .ZN(n19) );
  INR2D1BWP240H8P57PDSVT SYN_25 ( .A1(n19), .B1(state_ps[8]), .ZN(n10) );
  ND2D1BWP240H8P57PDSVT SYN_26 ( .A1(n9), .A2(n10), .ZN(n16) );
  NR2D1BWP240H8P57PDSVT SYN_27 ( .A1(state_ps[15]), .A2(n16), .ZN(n22) );
  NR3D1BWP240H8P57PDSVT SYN_28 ( .A1(state_ps[15]), .A2(state_ps[10]), .A3(
        state_ps[9]), .ZN(n11) );
  ND2D1BWP240H8P57PDSVT SYN_29 ( .A1(n11), .A2(n10), .ZN(n14) );
  NR4D1BWP240H8P57PDSVT SYN_30 ( .A1(state_ps[0]), .A2(state_ps[12]), .A3(
        state_ps[14]), .A4(n14), .ZN(n21) );
  INVPADD1BWP240H8P57PDSVT SYN_31 ( .I(state_ps[13]), .ZN(n12) );
  AOI33D1BWP240H8P57PDSVT SYN_32 ( .A1(n13), .A2(state_ps[10]), .A3(n22), .B1(
        state_ps[11]), .B2(n21), .B3(n12), .ZN(n62) );
  NR2D1BWP240H8P57PDSVT SYN_33 ( .A1(state_ps[13]), .A2(state_ps[11]), .ZN(n15) );
  INVPADD1BWP240H8P57PDSVT SYN_34 ( .I(n14), .ZN(n28) );
  ND2D1BWP240H8P57PDSVT SYN_35 ( .A1(n15), .A2(n28), .ZN(n39) );
  NR2D1BWP240H8P57PDSVT SYN_36 ( .A1(state_ps[0]), .A2(n39), .ZN(n45) );
  INVPADD1BWP240H8P57PDSVT SYN_37 ( .I(state_ps[14]), .ZN(n44) );
  INVPADD1BWP240H8P57PDSVT SYN_38 ( .I(state_ps[12]), .ZN(n40) );
  AOI22D1BWP240H8P57PDSVT SYN_39 ( .A1(state_ps[12]), .A2(state_ps[14]), .B1(
        n44), .B2(n40), .ZN(n36) );
  NR2D1BWP240H8P57PDSVT SYN_40 ( .A1(state_ps[10]), .A2(state_ps[9]), .ZN(n18)
         );
  INVPADD1BWP240H8P57PDSVT SYN_41 ( .I(n16), .ZN(n17) );
  AOI33D1BWP240H8P57PDSVT SYN_42 ( .A1(state_ps[8]), .A2(n20), .A3(n19), .B1(
        state_ps[15]), .B2(n18), .B3(n17), .ZN(n49) );
  IND3D1BWP240H8P57PDSVT SYN_43 ( .A1(state_ps[11]), .B1(state_ps[13]), .B2(
        n21), .ZN(n47) );
  IND3D1BWP240H8P57PDSVT SYN_44 ( .A1(state_ps[10]), .B1(n22), .B2(state_ps[9]), .ZN(n60) );
  ND3D1BWP240H8P57PDSVT SYN_45 ( .A1(state_ps[2]), .A2(n24), .A3(n23), .ZN(n59) );
  ND4D1BWP240H8P57PDSVT SYN_46 ( .A1(n49), .A2(n47), .A3(n60), .A4(n59), .ZN(
        n27) );
  NR3D1BWP240H8P57PDSVT SYN_47 ( .A1(state_ps[6]), .A2(n26), .A3(n25), .ZN(n48) );
  AOI211D1BWP240H8P57PDSVT SYN_48 ( .A1(n45), .A2(n36), .B(n27), .C(n48), .ZN(
        n32) );
  ND3D1BWP240H8P57PDSVT SYN_49 ( .A1(state_ps[0]), .A2(n29), .A3(n28), .ZN(n51) );
  NR2D1BWP240H8P57PDSVT SYN_50 ( .A1(state_ps[7]), .A2(n56), .ZN(n53) );
  NR2D1BWP240H8P57PDSVT SYN_51 ( .A1(n31), .A2(n30), .ZN(n57) );
  AOAI211D1BWP240H8P57PDSVT SYN_52 ( .A1(state_ps[7]), .A2(n56), .B(n53), .C(
        n57), .ZN(n50) );
  ND4D1BWP240H8P57PDSVT SYN_53 ( .A1(n62), .A2(n32), .A3(n51), .A4(n50), .ZN(
        n35) );
  ND4D1BWP240H8P57PDSVT SYN_54 ( .A1(tms_bit[2]), .A2(tms_bit[1]), .A3(
        tms_bit[0]), .A4(tms_bit[3]), .ZN(n43) );
  NR2D1BWP240H8P57PDSVT SYN_55 ( .A1(tapc_remove), .A2(ftap_tms), .ZN(n41) );
  AOI31D1BWP240H8P57PDSVT SYN_56 ( .A1(n51), .A2(n43), .A3(n60), .B(n41), .ZN(
        n33) );
  INVPADD1BWP240H8P57PDSVT SYN_57 ( .I(n33), .ZN(n34) );
  OAI31D1BWP240H8P57PDSVT SYN_58 ( .A1(n64), .A2(n55), .A3(n35), .B(n34), .ZN(
        N473) );
  INR2D1BWP240H8P57PDSVT SYN_59 ( .A1(tms_bit[0]), .B1(state_ps[0]), .ZN(N469)
         );
  INR2D1BWP240H8P57PDSVT SYN_60 ( .A1(tms_bit[1]), .B1(state_ps[0]), .ZN(N470)
         );
  INR2D1BWP240H8P57PDSVT SYN_61 ( .A1(tms_bit[2]), .B1(state_ps[0]), .ZN(N471)
         );
  NR2D1BWP240H8P57PDSVT SYN_62 ( .A1(n41), .A2(state_ps[0]), .ZN(N468) );
  INVPADD1BWP240H8P57PDSVT SYN_63 ( .I(n43), .ZN(n38) );
  ND2D1BWP240H8P57PDSVT SYN_64 ( .A1(N468), .A2(n36), .ZN(n37) );
  NR3D1BWP240H8P57PDSVT SYN_65 ( .A1(n39), .A2(n38), .A3(n37), .ZN(N488) );
  ND3D1BWP240H8P57PDSVT SYN_66 ( .A1(state_ps[14]), .A2(n45), .A3(n40), .ZN(
        n42) );
  INVPADD1BWP240H8P57PDSVT SYN_67 ( .I(n41), .ZN(n61) );
  AOI21D1BWP240H8P57PDSVT SYN_68 ( .A1(n62), .A2(n42), .B(n61), .ZN(N484) );
  ND2D1BWP240H8P57PDSVT SYN_69 ( .A1(n43), .A2(n61), .ZN(n63) );
  NR2D1BWP240H8P57PDSVT SYN_70 ( .A1(n47), .A2(n63), .ZN(N487) );
  ND3D1BWP240H8P57PDSVT SYN_71 ( .A1(state_ps[12]), .A2(n45), .A3(n44), .ZN(
        n46) );
  AOI21D1BWP240H8P57PDSVT SYN_72 ( .A1(n47), .A2(n46), .B(n61), .ZN(N486) );
  NR2D1BWP240H8P57PDSVT SYN_73 ( .A1(n61), .A2(n59), .ZN(N476) );
  INR2D1BWP240H8P57PDSVT SYN_74 ( .A1(n49), .B1(n48), .ZN(n52) );
  NR2D1BWP240H8P57PDSVT SYN_75 ( .A1(n52), .A2(n63), .ZN(N475) );
  NR2D1BWP240H8P57PDSVT SYN_76 ( .A1(n50), .A2(n63), .ZN(N481) );
  AOI21D1BWP240H8P57PDSVT SYN_77 ( .A1(n52), .A2(n51), .B(n61), .ZN(N474) );
  INR2D1BWP240H8P57PDSVT SYN_78 ( .A1(n55), .B1(n63), .ZN(N478) );
  AOI21D1BWP240H8P57PDSVT SYN_79 ( .A1(n57), .A2(n53), .B(n64), .ZN(n54) );
  NR2D1BWP240H8P57PDSVT SYN_80 ( .A1(n54), .A2(n61), .ZN(N479) );
  AOI31D1BWP240H8P57PDSVT SYN_81 ( .A1(state_ps[7]), .A2(n57), .A3(n56), .B(
        n55), .ZN(n58) );
  NR2D1BWP240H8P57PDSVT SYN_82 ( .A1(n58), .A2(n61), .ZN(N477) );
  NR2D1BWP240H8P57PDSVT SYN_83 ( .A1(n59), .A2(n63), .ZN(N482) );
  NR2D1BWP240H8P57PDSVT SYN_84 ( .A1(n61), .A2(n60), .ZN(N483) );
  NR2D1BWP240H8P57PDSVT SYN_85 ( .A1(n62), .A2(n63), .ZN(N485) );
  INR2D1BWP240H8P57PDSVT SYN_87 ( .A1(n64), .B1(n63), .ZN(N480) );
  SDFNRPQD1BWP240H11P57PDSVT stap_fsm_shift_ir_neg_reg ( .D(state_ps[11]), 
        .SI(1'b0), .SE(1'b0), .CPN(ftap_tck), .CD(n65), .Q(
        stap_fsm_shift_ir_neg) );
  SDFRPQD1BWP240H11P57PDSVT tms_bit_reg_3 ( .D(N471), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(tms_bit[3]) );
  SDFRPQD1BWP240H11P57PDSVT tms_bit_reg_2 ( .D(N470), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(tms_bit[2]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_5 ( .D(N478), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[5]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_1 ( .D(N474), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[1]) );
  SDFRPQD1BWP240H11P57PDSVT tms_bit_reg_0 ( .D(N468), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(tms_bit[0]) );
  SDFRPQD1BWP240H11P57PDSVT tms_bit_reg_1 ( .D(N469), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(tms_bit[1]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_6 ( .D(N479), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[6]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_13 ( .D(N486), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[13]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_2 ( .D(N475), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[2]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_8 ( .D(N481), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[8]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_14 ( .D(N487), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[14]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_12 ( .D(N485), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[12]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_9 ( .D(N482), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[9]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_10 ( .D(N483), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[10]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_7 ( .D(N480), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[7]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_4 ( .D(N477), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[4]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_11 ( .D(N484), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[11]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_3 ( .D(N476), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[3]) );
  SDFRPQD1BWP240H11P57PDSVT state_ps_reg_15 ( .D(N488), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n65), .Q(state_ps[15]) );
  SDFSNQD1BWP240H11P57PDSVT state_ps_reg_0 ( .D(N473), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .SDN(powergood_rst_trst_b), .Q(state_ps[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_3 ( .I(1'b1), .ZN(stap_selectwir) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_5 ( .I(1'b1), .ZN(stap_selectwir_neg) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_7 ( .I(1'b1), .ZN(sn_fwtap_capturewr) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_9 ( .I(1'b1), .ZN(sn_fwtap_shiftwr) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_11 ( .I(1'b1), .ZN(sn_fwtap_updatewr) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_13 ( .I(1'b1), .ZN(sn_fwtap_rti) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_15 ( .I(1'b0), .ZN(sn_fwtap_wrst_b) );
  INVPADD1BWP240H8P57PDSVT SYN_86 ( .I(powergood_rst_trst_b), .ZN(n65) );
endmodule


module stap_SNPS_CLOCK_GATE_HIGH_stap_irreg_8_8_0 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  CKLNQD10BWP240H8P57PDSVT latch ( .CP(CLK), .E(EN), .TE(TE), .Q(ENCLK) );
endmodule


module stap_SNPS_CLOCK_GATE_LOW_stap_irreg_8_8_0 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;
  wire   net788, net790, net791;

  OR2D1BWP240H8P57PDSVT test_or ( .A1(EN), .A2(TE), .Z(net788) );
  INVPADD1BWP240H8P57PDSVT SYN_1 ( .I(net790), .ZN(net791) );
  OR2D1BWP240H8P57PDSVT main_gate ( .A1(net791), .A2(CLK), .Z(ENCLK) );
  LHQD1BWP240H11P57PDSVT latch ( .E(CLK), .D(net788), .Q(net790) );
endmodule


module stap_stap_irreg_8_8_0 ( stap_fsm_tlrs, stap_fsm_capture_ir, 
        stap_fsm_shift_ir, stap_fsm_update_ir, ftap_tdi, ftap_tck, 
        powergood_rst_trst_b, stap_irreg_ireg, stap_irreg_ireg_nxt, 
        stap_irreg_serial_out, stap_irreg_shift_reg );
  output [7:0] stap_irreg_ireg;
  output [7:0] stap_irreg_ireg_nxt;
  output [7:0] stap_irreg_shift_reg;
  input stap_fsm_tlrs, stap_fsm_capture_ir, stap_fsm_shift_ir,
         stap_fsm_update_ir, ftap_tdi, ftap_tck, powergood_rst_trst_b;
  output stap_irreg_serial_out;
  wire   N7, N8, N9, N10, N11, N12, N13, N14, N15, N23, N24, N25, N26, N27,
         N28, N29, N30, N31, net803, net801, n1, n2, n3, n4, n5, n6, n90, n110,
         n120, n130;

  stap_SNPS_CLOCK_GATE_HIGH_stap_irreg_8_8_0 clk_gate_shift_reg_reg_7 ( .CLK(
        ftap_tck), .EN(N7), .ENCLK(net801), .TE(1'b0) );
  stap_SNPS_CLOCK_GATE_LOW_stap_irreg_8_8_0 clk_gate_stap_irreg_ireg_reg_7 ( 
        .CLK(ftap_tck), .EN(N23), .ENCLK(net803), .TE(1'b0) );
  BUFFD1BWP240H8P57PDSVT SYN_3 ( .I(stap_irreg_serial_out), .Z(
        stap_irreg_shift_reg[0]) );
  ND2D1BWP240H8P57PDSVT SYN_6 ( .A1(n130), .A2(n120), .ZN(N23) );
  NR2D1BWP240H8P57PDSVT SYN_7 ( .A1(stap_fsm_tlrs), .A2(stap_fsm_capture_ir), 
        .ZN(n90) );
  ND2D1BWP240H8P57PDSVT SYN_8 ( .A1(stap_fsm_shift_ir), .A2(n90), .ZN(n1) );
  INR2D1BWP240H8P57PDSVT SYN_9 ( .A1(ftap_tdi), .B1(n1), .ZN(N15) );
  INVPADD1BWP240H8P57PDSVT SYN_10 ( .I(stap_irreg_shift_reg[7]), .ZN(n2) );
  NR2D1BWP240H8P57PDSVT SYN_11 ( .A1(n1), .A2(n2), .ZN(N14) );
  INVPADD1BWP240H8P57PDSVT SYN_12 ( .I(stap_irreg_shift_reg[6]), .ZN(n3) );
  NR2D1BWP240H8P57PDSVT SYN_13 ( .A1(n1), .A2(n3), .ZN(N13) );
  INVPADD1BWP240H8P57PDSVT SYN_14 ( .I(stap_irreg_shift_reg[5]), .ZN(n4) );
  NR2D1BWP240H8P57PDSVT SYN_15 ( .A1(n1), .A2(n4), .ZN(N12) );
  INVPADD1BWP240H8P57PDSVT SYN_16 ( .I(stap_irreg_shift_reg[4]), .ZN(n5) );
  NR2D1BWP240H8P57PDSVT SYN_17 ( .A1(n1), .A2(n5), .ZN(N11) );
  INR2D1BWP240H8P57PDSVT SYN_18 ( .A1(stap_irreg_shift_reg[3]), .B1(n1), .ZN(
        N10) );
  INR2D1BWP240H8P57PDSVT SYN_19 ( .A1(stap_irreg_shift_reg[2]), .B1(n1), .ZN(
        N9) );
  ND2D1BWP240H8P57PDSVT SYN_20 ( .A1(n130), .A2(stap_fsm_update_ir), .ZN(n6)
         );
  NR2D1BWP240H8P57PDSVT SYN_21 ( .A1(n2), .A2(n6), .ZN(N31) );
  NR2D1BWP240H8P57PDSVT SYN_22 ( .A1(n3), .A2(n6), .ZN(N30) );
  NR2D1BWP240H8P57PDSVT SYN_23 ( .A1(n4), .A2(n6), .ZN(N29) );
  NR2D1BWP240H8P57PDSVT SYN_24 ( .A1(n5), .A2(n6), .ZN(N28) );
  INR2D1BWP240H8P57PDSVT SYN_25 ( .A1(stap_irreg_shift_reg[1]), .B1(n6), .ZN(
        N25) );
  INR2D1BWP240H8P57PDSVT SYN_26 ( .A1(stap_irreg_serial_out), .B1(n6), .ZN(N24) );
  AO22D1BWP240H8P57PDSVT SYN_27 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_shift_reg[1]), .B1(n120), .B2(stap_irreg_ireg[1]), .Z(
        stap_irreg_ireg_nxt[1]) );
  AO22D1BWP240H8P57PDSVT SYN_28 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_shift_reg[2]), .B1(n120), .B2(stap_irreg_ireg[2]), .Z(
        stap_irreg_ireg_nxt[2]) );
  AO22D1BWP240H8P57PDSVT SYN_29 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_serial_out), .B1(n120), .B2(stap_irreg_ireg[0]), .Z(
        stap_irreg_ireg_nxt[0]) );
  AO22D1BWP240H8P57PDSVT SYN_30 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_shift_reg[7]), .B1(n120), .B2(stap_irreg_ireg[7]), .Z(
        stap_irreg_ireg_nxt[7]) );
  AO22D1BWP240H8P57PDSVT SYN_31 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_shift_reg[6]), .B1(n120), .B2(stap_irreg_ireg[6]), .Z(
        stap_irreg_ireg_nxt[6]) );
  AO22D1BWP240H8P57PDSVT SYN_32 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_shift_reg[5]), .B1(n120), .B2(stap_irreg_ireg[5]), .Z(
        stap_irreg_ireg_nxt[5]) );
  AO22D1BWP240H8P57PDSVT SYN_33 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_shift_reg[3]), .B1(n120), .B2(stap_irreg_ireg[3]), .Z(
        stap_irreg_ireg_nxt[3]) );
  AO22D1BWP240H8P57PDSVT SYN_34 ( .A1(stap_fsm_update_ir), .A2(
        stap_irreg_shift_reg[4]), .B1(n120), .B2(stap_irreg_ireg[4]), .Z(
        stap_irreg_ireg_nxt[4]) );
  IOA21D1BWP240H8P57PDSVT SYN_36 ( .A1(stap_irreg_shift_reg[2]), .A2(
        stap_fsm_update_ir), .B(n130), .ZN(N26) );
  IOA21D1BWP240H8P57PDSVT SYN_37 ( .A1(stap_irreg_shift_reg[3]), .A2(
        stap_fsm_update_ir), .B(n130), .ZN(N27) );
  IOA21D1BWP240H8P57PDSVT SYN_38 ( .A1(stap_fsm_shift_ir), .A2(
        stap_irreg_shift_reg[1]), .B(n90), .ZN(N8) );
  IND2D1BWP240H8P57PDSVT SYN_40 ( .A1(stap_fsm_shift_ir), .B1(n90), .ZN(N7) );
  INVPADD1BWP240H8P57PDSVT SYN_4 ( .I(powergood_rst_trst_b), .ZN(n110) );
  INVPADD1BWP240H8P57PDSVT SYN_5 ( .I(stap_fsm_update_ir), .ZN(n120) );
  INVPADD1BWP240H8P57PDSVT SYN_35 ( .I(stap_fsm_tlrs), .ZN(n130) );
  SDFRPQD1BWP240H11P57PDSVT shift_reg_reg_7 ( .D(N15), .SI(1'b0), .SE(1'b0), 
        .CP(net801), .CD(n110), .Q(stap_irreg_shift_reg[7]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_0 ( .D(N24), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .CD(n110), .Q(stap_irreg_ireg[0]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_6 ( .D(N30), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .CD(n110), .Q(stap_irreg_ireg[6]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_4 ( .D(N28), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .CD(n110), .Q(stap_irreg_ireg[4]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_7 ( .D(N31), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .CD(n110), .Q(stap_irreg_ireg[7]) );
  SDFNSNQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_3 ( .D(N27), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .SDN(powergood_rst_trst_b), .Q(stap_irreg_ireg[3]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_1 ( .D(N25), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .CD(n110), .Q(stap_irreg_ireg[1]) );
  SDFNSNQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_2 ( .D(N26), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .SDN(powergood_rst_trst_b), .Q(stap_irreg_ireg[2]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irreg_ireg_reg_5 ( .D(N29), .SI(1'b0), .SE(
        1'b0), .CPN(net803), .CD(n110), .Q(stap_irreg_ireg[5]) );
  SDFSNQD1BWP240H11P57PDSVT shift_reg_reg_0 ( .D(N8), .SI(1'b0), .SE(1'b0), 
        .CP(net801), .SDN(powergood_rst_trst_b), .Q(stap_irreg_serial_out) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_shift_reg_reg_1_2ndsig_shift_reg_reg_2_2ndsig_shift_reg_reg_3_2ndsig_shift_reg_reg_4 ( 
        .D1(N9), .CP(net801), .CD(n110), .SE(1'b0), .SI(1'b0), .Q1(
        stap_irreg_shift_reg[1]), .D2(N10), .Q2(stap_irreg_shift_reg[2]), .D3(
        N11), .Q3(stap_irreg_shift_reg[3]), .D4(N12), .Q4(
        stap_irreg_shift_reg[4]) );
  MB2SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_shift_reg_reg_5_2ndsig_shift_reg_reg_6 ( 
        .D1(N13), .CP(net801), .CD(n110), .SE(1'b0), .SI(1'b0), .Q1(
        stap_irreg_shift_reg[5]), .D2(N14), .Q2(stap_irreg_shift_reg[6]) );
endmodule


module stap_stap_decoder_ff_8_0_0_1_2_0 ( stap_irreg_ireg, decoder_drselect, 
        feature_green_en, feature_orange_en, feature_red_en );
  input [7:0] stap_irreg_ireg;
  input feature_green_en, feature_orange_en, feature_red_en;
  output decoder_drselect;
  wire   n1, n2, n3;

  NR3D1BWP240H8P57PDSVT SYN_2 ( .A1(feature_green_en), .A2(feature_orange_en), 
        .A3(feature_red_en), .ZN(n3) );
  ND4D1BWP240H8P57PDSVT SYN_3 ( .A1(stap_irreg_ireg[4]), .A2(
        stap_irreg_ireg[3]), .A3(stap_irreg_ireg[5]), .A4(stap_irreg_ireg[6]), 
        .ZN(n2) );
  ND4D1BWP240H8P57PDSVT SYN_4 ( .A1(stap_irreg_ireg[7]), .A2(
        stap_irreg_ireg[0]), .A3(stap_irreg_ireg[2]), .A4(stap_irreg_ireg[1]), 
        .ZN(n1) );
  NR3D1BWP240H8P57PDSVT SYN_5 ( .A1(n3), .A2(n2), .A3(n1), .ZN(
        decoder_drselect) );
endmodule


module stap_stap_decoder_0c_8_0_0_1_2_0 ( stap_irreg_ireg, decoder_drselect, 
        feature_green_en, feature_orange_en, feature_red_en );
  input [7:0] stap_irreg_ireg;
  input feature_green_en, feature_orange_en, feature_red_en;
  output decoder_drselect;
  wire   n1, n2, n3;

  NR3D1BWP240H8P57PDSVT SYN_2 ( .A1(feature_green_en), .A2(feature_orange_en), 
        .A3(feature_red_en), .ZN(n3) );
  NR4D1BWP240H8P57PDSVT SYN_3 ( .A1(stap_irreg_ireg[7]), .A2(
        stap_irreg_ireg[4]), .A3(stap_irreg_ireg[6]), .A4(stap_irreg_ireg[5]), 
        .ZN(n1) );
  ND3D1BWP240H8P57PDSVT SYN_4 ( .A1(stap_irreg_ireg[3]), .A2(
        stap_irreg_ireg[2]), .A3(n1), .ZN(n2) );
  NR4D1BWP240H8P57PDSVT SYN_5 ( .A1(n3), .A2(stap_irreg_ireg[0]), .A3(
        stap_irreg_ireg[1]), .A4(n2), .ZN(decoder_drselect) );
endmodule


module stap_stap_decoder_20_8_0_0_1_2_0 ( stap_irreg_ireg, decoder_drselect, 
        feature_green_en, feature_orange_en, feature_red_en );
  input [7:0] stap_irreg_ireg;
  input feature_green_en, feature_orange_en, feature_red_en;
  output decoder_drselect;
  wire   n1, n2, n3;

  NR3D1BWP240H8P57PDSVT SYN_2 ( .A1(feature_green_en), .A2(feature_orange_en), 
        .A3(feature_red_en), .ZN(n3) );
  NR4D1BWP240H8P57PDSVT SYN_3 ( .A1(stap_irreg_ireg[7]), .A2(
        stap_irreg_ireg[3]), .A3(stap_irreg_ireg[6]), .A4(stap_irreg_ireg[4]), 
        .ZN(n1) );
  IND3D1BWP240H8P57PDSVT SYN_4 ( .A1(stap_irreg_ireg[2]), .B1(
        stap_irreg_ireg[5]), .B2(n1), .ZN(n2) );
  NR4D1BWP240H8P57PDSVT SYN_5 ( .A1(n3), .A2(stap_irreg_ireg[0]), .A3(
        stap_irreg_ireg[1]), .A4(n2), .ZN(decoder_drselect) );
endmodule


module stap_stap_decoder_21_8_0_0_1_2_0 ( stap_irreg_ireg, decoder_drselect, 
        feature_green_en, feature_orange_en, feature_red_en );
  input [7:0] stap_irreg_ireg;
  input feature_green_en, feature_orange_en, feature_red_en;
  output decoder_drselect;
  wire   n1, n2, n3;

  NR3D1BWP240H8P57PDSVT SYN_2 ( .A1(feature_green_en), .A2(feature_orange_en), 
        .A3(feature_red_en), .ZN(n3) );
  NR4D1BWP240H8P57PDSVT SYN_3 ( .A1(stap_irreg_ireg[7]), .A2(
        stap_irreg_ireg[3]), .A3(stap_irreg_ireg[6]), .A4(stap_irreg_ireg[4]), 
        .ZN(n1) );
  ND3D1BWP240H8P57PDSVT SYN_4 ( .A1(stap_irreg_ireg[5]), .A2(
        stap_irreg_ireg[0]), .A3(n1), .ZN(n2) );
  NR4D1BWP240H8P57PDSVT SYN_5 ( .A1(n3), .A2(stap_irreg_ireg[1]), .A3(
        stap_irreg_ireg[2]), .A4(n2), .ZN(decoder_drselect) );
endmodule


module stap_stap_irdecoder_1_8_4_210800c3fc_04_8_0_0_1_2_0 ( 
        powergood_rst_trst_b, stap_irreg_ireg, stap_irreg_ireg_nxt, ftap_tck, 
        feature_green_en, feature_orange_en, feature_red_en, stap_isol_en_b, 
        stap_irdecoder_drselect, tap_swcomp_active, stap_and_all_bits_irreg );
  input [7:0] stap_irreg_ireg;
  input [7:0] stap_irreg_ireg_nxt;
  output [3:0] stap_irdecoder_drselect;
  input powergood_rst_trst_b, ftap_tck, feature_green_en, feature_orange_en,
         feature_red_en, stap_isol_en_b;
  output tap_swcomp_active, stap_and_all_bits_irreg;
  wire   n1, n2, n3, n5, n6, n7, n8, n9, n10, n11;
  wire   [3:0] decoder_drselect;
  wire   [3:0] irdecoder_drselect_nxt;

  stap_stap_decoder_ff_8_0_0_1_2_0 \generate_decoder_0.i_stap_decoder  ( 
        .stap_irreg_ireg(stap_irreg_ireg_nxt), .decoder_drselect(
        decoder_drselect[0]), .feature_green_en(feature_green_en), 
        .feature_orange_en(feature_orange_en), .feature_red_en(feature_red_en)
         );
  stap_stap_decoder_0c_8_0_0_1_2_0 \generate_decoder_1.i_stap_decoder  ( 
        .stap_irreg_ireg(stap_irreg_ireg_nxt), .decoder_drselect(
        decoder_drselect[1]), .feature_green_en(feature_green_en), 
        .feature_orange_en(feature_orange_en), .feature_red_en(feature_red_en)
         );
  stap_stap_decoder_20_8_0_0_1_2_0 \generate_decoder_2.i_stap_decoder  ( 
        .stap_irreg_ireg(stap_irreg_ireg_nxt), .decoder_drselect(
        decoder_drselect[2]), .feature_green_en(feature_green_en), 
        .feature_orange_en(feature_orange_en), .feature_red_en(feature_red_en)
         );
  stap_stap_decoder_21_8_0_0_1_2_0 \generate_decoder_3.i_stap_decoder  ( 
        .stap_irreg_ireg(stap_irreg_ireg_nxt), .decoder_drselect(
        decoder_drselect[3]), .feature_green_en(feature_green_en), 
        .feature_orange_en(feature_orange_en), .feature_red_en(feature_red_en)
         );
  NR2D1BWP240H8P57PDSVT SYN_3 ( .A1(stap_irreg_ireg[7]), .A2(
        stap_irreg_ireg[6]), .ZN(n2) );
  NR4D1BWP240H8P57PDSVT SYN_4 ( .A1(stap_irreg_ireg[1]), .A2(
        stap_irreg_ireg[2]), .A3(stap_irreg_ireg[3]), .A4(stap_irreg_ireg[4]), 
        .ZN(n1) );
  ND3D1BWP240H8P57PDSVT SYN_5 ( .A1(n2), .A2(stap_irreg_ireg[5]), .A3(n1), 
        .ZN(n9) );
  ND4D1BWP240H8P57PDSVT SYN_6 ( .A1(stap_irreg_ireg_nxt[3]), .A2(
        stap_irreg_ireg_nxt[2]), .A3(stap_irreg_ireg_nxt[1]), .A4(
        stap_irreg_ireg_nxt[0]), .ZN(n5) );
  ND4D1BWP240H8P57PDSVT SYN_7 ( .A1(stap_irreg_ireg_nxt[7]), .A2(
        stap_irreg_ireg_nxt[6]), .A3(stap_irreg_ireg_nxt[5]), .A4(
        stap_irreg_ireg_nxt[4]), .ZN(n3) );
  OAI22D1BWP240H8P57PDSVT SYN_8 ( .A1(stap_isol_en_b), .A2(n9), .B1(n5), .B2(
        n3), .ZN(n6) );
  INR2D1BWP240H8P57PDSVT SYN_9 ( .A1(decoder_drselect[3]), .B1(n6), .ZN(
        irdecoder_drselect_nxt[3]) );
  INR2D1BWP240H8P57PDSVT SYN_10 ( .A1(decoder_drselect[2]), .B1(n6), .ZN(
        irdecoder_drselect_nxt[2]) );
  INR2D1BWP240H8P57PDSVT SYN_11 ( .A1(decoder_drselect[1]), .B1(n6), .ZN(
        irdecoder_drselect_nxt[1]) );
  ND4D1BWP240H8P57PDSVT SYN_13 ( .A1(stap_irreg_ireg[7]), .A2(
        stap_irreg_ireg[5]), .A3(stap_irreg_ireg[6]), .A4(stap_irreg_ireg[0]), 
        .ZN(n8) );
  ND4D1BWP240H8P57PDSVT SYN_14 ( .A1(stap_irreg_ireg[1]), .A2(
        stap_irreg_ireg[2]), .A3(stap_irreg_ireg[3]), .A4(stap_irreg_ireg[4]), 
        .ZN(n7) );
  NR2D1BWP240H8P57PDSVT SYN_15 ( .A1(n8), .A2(n7), .ZN(stap_and_all_bits_irreg) );
  ND2D1BWP240H8P57PDSVT SYN_16 ( .A1(stap_isol_en_b), .A2(n9), .ZN(
        tap_swcomp_active) );
  NR3D1BWP240H8P57PDSVT SYN_17 ( .A1(irdecoder_drselect_nxt[3]), .A2(
        irdecoder_drselect_nxt[2]), .A3(irdecoder_drselect_nxt[1]), .ZN(n10)
         );
  OR2D1BWP240H8P57PDSVT SYN_18 ( .A1(decoder_drselect[0]), .A2(n10), .Z(
        irdecoder_drselect_nxt[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_12 ( .I(powergood_rst_trst_b), .ZN(n11) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irdecoder_drselect_reg_2 ( .D(
        irdecoder_drselect_nxt[2]), .SI(1'b0), .SE(1'b0), .CPN(ftap_tck), .CD(
        n11), .Q(stap_irdecoder_drselect[2]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irdecoder_drselect_reg_3 ( .D(
        irdecoder_drselect_nxt[3]), .SI(1'b0), .SE(1'b0), .CPN(ftap_tck), .CD(
        n11), .Q(stap_irdecoder_drselect[3]) );
  SDFNRPQD1BWP240H11P57PDSVT stap_irdecoder_drselect_reg_0 ( .D(
        irdecoder_drselect_nxt[0]), .SI(1'b0), .SE(1'b0), .CPN(ftap_tck), .CD(
        n11), .Q(stap_irdecoder_drselect[0]) );
  SDFNSNQD1BWP240H11P57PDSVT stap_irdecoder_drselect_reg_1 ( .D(
        irdecoder_drselect_nxt[1]), .SI(1'b0), .SE(1'b0), .CPN(ftap_tck), 
        .SDN(powergood_rst_trst_b), .Q(stap_irdecoder_drselect[1]) );
endmodule



    module stap_SNPS_CLOCK_GATE_HIGH_stap_drreg_1_0_0_0_0_0_32_4_2_16_1_0000_0000_0000_0_0_1_1_1_0_0_0_0_0_0_0_0_0_0_2_0_0_0_0_1_1_0_0_0_0_1_2_0 ( 
        CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;


  CKLNQD10BWP240H8P57PDSVT latch ( .CP(CLK), .E(EN), .TE(TE), .Q(ENCLK) );
endmodule



    module stap_stap_drreg_1_0_0_0_0_0_32_4_2_16_1_0000_0000_0000_0_0_1_1_1_0_0_0_0_0_0_0_0_0_0_2_0_0_0_0_1_1_0_0_0_0_1_2_0 ( 
        stap_fsm_tlrs, ftap_tdi, ftap_tck, ftap_trst_b, fdfx_powergood, 
        powergood_rst_trst_b, stap_fsm_capture_dr, stap_fsm_shift_dr, 
        stap_fsm_update_dr, stap_selectwir, ftap_slvidcode, 
        stap_irdecoder_drselect, tdr_data_in, tdr_data_out, 
        sftapnw_ftap_secsel, tapc_select, feature_green_en, feature_orange_en, 
        feature_red_en, tapc_wtap_sel, tapc_remove, stap_drreg_tdo, 
        swcompctrl_tdo, swcompstat_tdo, stap_and_all_bits_irreg, rtdr_tap_tdo, 
        tap_rtdr_tdi, tap_rtdr_capture, tap_rtdr_shift, tap_rtdr_update, 
        tap_rtdr_irdec, tap_rtdr_selectir, tap_rtdr_powergood, tap_rtdr_rti, 
        tap_rtdr_prog_rst_b, suppress_update_capture_reg, stap_fsm_rti );
  input [31:0] ftap_slvidcode;
  input [3:0] stap_irdecoder_drselect;
  input [0:0] tdr_data_in;
  output [0:0] tdr_data_out;
  output [0:0] sftapnw_ftap_secsel;
  output [1:0] tapc_select;
  output [0:0] tapc_wtap_sel;
  output [3:0] stap_drreg_tdo;
  input [0:0] rtdr_tap_tdo;
  output [0:0] tap_rtdr_tdi;
  output [0:0] tap_rtdr_capture;
  output [0:0] tap_rtdr_shift;
  output [0:0] tap_rtdr_update;
  output [0:0] tap_rtdr_irdec;
  output [0:0] tap_rtdr_prog_rst_b;
  output [1:0] suppress_update_capture_reg;
  input stap_fsm_tlrs, ftap_tdi, ftap_tck, ftap_trst_b, fdfx_powergood,
         powergood_rst_trst_b, stap_fsm_capture_dr, stap_fsm_shift_dr,
         stap_fsm_update_dr, stap_selectwir, feature_green_en,
         feature_orange_en, feature_red_en, swcompctrl_tdo, swcompstat_tdo,
         stap_and_all_bits_irreg, stap_fsm_rti;
  output tapc_remove, tap_rtdr_selectir, tap_rtdr_powergood, tap_rtdr_rti;
  wire   bypass_reg, N9, N10, reset_pulse0, reset_pulse1, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, net763, n2, n3, n4, n5, n90, n25, n260;
  wire   [31:1] slvidcode_reg;

  stap_SNPS_CLOCK_GATE_HIGH_stap_drreg_1_0_0_0_0_0_32_4_2_16_1_0000_0000_0000_0_0_1_1_1_0_0_0_0_0_0_0_0_0_0_2_0_0_0_0_1_1_0_0_0_0_1_2_0 clk_gate_slvidcode_reg_reg_31 ( 
        .CLK(ftap_tck), .EN(N26), .ENCLK(net763), .TE(1'b0) );
  BUFFD1BWP240H8P57PDSVT SYN_3 ( .I(swcompctrl_tdo), .Z(stap_drreg_tdo[2]) );
  BUFFD1BWP240H8P57PDSVT SYN_4 ( .I(swcompstat_tdo), .Z(stap_drreg_tdo[3]) );
  INR2D1BWP240H8P57PDSVT SYN_5 ( .A1(reset_pulse0), .B1(reset_pulse1), .ZN(n2)
         );
  IIND3D1BWP240H8P57PDSVT SYN_6 ( .A1(stap_fsm_tlrs), .A2(stap_fsm_capture_dr), 
        .B1(stap_fsm_shift_dr), .ZN(n5) );
  AOI211D1BWP240H8P57PDSVT SYN_10 ( .A1(stap_irdecoder_drselect[1]), .A2(
        stap_fsm_capture_dr), .B(stap_fsm_tlrs), .C(n2), .ZN(n90) );
  IND2D1BWP240H8P57PDSVT SYN_11 ( .A1(n4), .B1(n90), .ZN(N26) );
  OAOI211D1BWP240H8P57PDSVT SYN_12 ( .A1(stap_fsm_capture_dr), .A2(
        stap_fsm_shift_dr), .B(stap_irdecoder_drselect[0]), .C(stap_fsm_tlrs), 
        .ZN(n3) );
  INVPADD1BWP240H8P57PDSVT SYN_13 ( .I(n3), .ZN(N9) );
  IOA21D1BWP240H8P57PDSVT SYN_16 ( .A1(n4), .A2(slvidcode_reg[1]), .B(n90), 
        .ZN(N27) );
  IINR3D1BWP240H8P57PDSVT SYN_17 ( .A1(ftap_tdi), .A2(
        stap_irdecoder_drselect[0]), .B1(n5), .ZN(N10) );
  AO22D1BWP240H8P57PDSVT SYN_27 ( .A1(slvidcode_reg[2]), .A2(n4), .B1(
        ftap_slvidcode[1]), .B2(n260), .Z(N28) );
  AO22D1BWP240H8P57PDSVT SYN_28 ( .A1(slvidcode_reg[3]), .A2(n4), .B1(
        ftap_slvidcode[2]), .B2(n260), .Z(N29) );
  AO22D1BWP240H8P57PDSVT SYN_29 ( .A1(slvidcode_reg[4]), .A2(n4), .B1(
        ftap_slvidcode[3]), .B2(n260), .Z(N30) );
  AO22D1BWP240H8P57PDSVT SYN_30 ( .A1(slvidcode_reg[5]), .A2(n4), .B1(
        ftap_slvidcode[4]), .B2(n260), .Z(N31) );
  AO22D1BWP240H8P57PDSVT SYN_31 ( .A1(slvidcode_reg[6]), .A2(n4), .B1(
        ftap_slvidcode[5]), .B2(n260), .Z(N32) );
  AO22D1BWP240H8P57PDSVT SYN_32 ( .A1(slvidcode_reg[7]), .A2(n4), .B1(
        ftap_slvidcode[6]), .B2(n260), .Z(N33) );
  AO22D1BWP240H8P57PDSVT SYN_34 ( .A1(slvidcode_reg[8]), .A2(n4), .B1(
        ftap_slvidcode[7]), .B2(n260), .Z(N34) );
  AO22D1BWP240H8P57PDSVT SYN_36 ( .A1(slvidcode_reg[9]), .A2(n4), .B1(
        ftap_slvidcode[8]), .B2(n260), .Z(N35) );
  AO22D1BWP240H8P57PDSVT SYN_37 ( .A1(slvidcode_reg[10]), .A2(n4), .B1(
        ftap_slvidcode[9]), .B2(n260), .Z(N36) );
  AO22D1BWP240H8P57PDSVT SYN_38 ( .A1(slvidcode_reg[11]), .A2(n4), .B1(
        ftap_slvidcode[10]), .B2(n260), .Z(N37) );
  AO22D1BWP240H8P57PDSVT SYN_39 ( .A1(slvidcode_reg[12]), .A2(n4), .B1(
        ftap_slvidcode[11]), .B2(n260), .Z(N38) );
  AO22D1BWP240H8P57PDSVT SYN_40 ( .A1(slvidcode_reg[13]), .A2(n4), .B1(
        ftap_slvidcode[12]), .B2(n260), .Z(N39) );
  AO22D1BWP240H8P57PDSVT SYN_41 ( .A1(slvidcode_reg[14]), .A2(n4), .B1(
        ftap_slvidcode[13]), .B2(n260), .Z(N40) );
  AO22D1BWP240H8P57PDSVT SYN_42 ( .A1(slvidcode_reg[15]), .A2(n4), .B1(
        ftap_slvidcode[14]), .B2(n260), .Z(N41) );
  AO22D1BWP240H8P57PDSVT SYN_43 ( .A1(slvidcode_reg[16]), .A2(n4), .B1(
        ftap_slvidcode[15]), .B2(n260), .Z(N42) );
  AO22D1BWP240H8P57PDSVT SYN_44 ( .A1(slvidcode_reg[17]), .A2(n4), .B1(
        ftap_slvidcode[16]), .B2(n260), .Z(N43) );
  AO22D1BWP240H8P57PDSVT SYN_45 ( .A1(slvidcode_reg[18]), .A2(n4), .B1(
        ftap_slvidcode[17]), .B2(n260), .Z(N44) );
  AO22D1BWP240H8P57PDSVT SYN_46 ( .A1(slvidcode_reg[19]), .A2(n4), .B1(
        ftap_slvidcode[18]), .B2(n260), .Z(N45) );
  AO22D1BWP240H8P57PDSVT SYN_47 ( .A1(slvidcode_reg[20]), .A2(n4), .B1(
        ftap_slvidcode[19]), .B2(n260), .Z(N46) );
  AO22D1BWP240H8P57PDSVT SYN_50 ( .A1(slvidcode_reg[21]), .A2(n4), .B1(
        ftap_slvidcode[20]), .B2(n260), .Z(N47) );
  AO22D1BWP240H8P57PDSVT SYN_51 ( .A1(slvidcode_reg[22]), .A2(n4), .B1(
        ftap_slvidcode[21]), .B2(n260), .Z(N48) );
  AO22D1BWP240H8P57PDSVT SYN_52 ( .A1(slvidcode_reg[23]), .A2(n4), .B1(
        ftap_slvidcode[22]), .B2(n260), .Z(N49) );
  AO22D1BWP240H8P57PDSVT SYN_53 ( .A1(slvidcode_reg[24]), .A2(n4), .B1(
        ftap_slvidcode[23]), .B2(n260), .Z(N50) );
  AO22D1BWP240H8P57PDSVT SYN_54 ( .A1(slvidcode_reg[25]), .A2(n4), .B1(
        ftap_slvidcode[24]), .B2(n260), .Z(N51) );
  AO22D1BWP240H8P57PDSVT SYN_55 ( .A1(slvidcode_reg[26]), .A2(n4), .B1(
        ftap_slvidcode[25]), .B2(n260), .Z(N52) );
  AO22D1BWP240H8P57PDSVT SYN_56 ( .A1(slvidcode_reg[27]), .A2(n4), .B1(
        ftap_slvidcode[26]), .B2(n260), .Z(N53) );
  AO22D1BWP240H8P57PDSVT SYN_57 ( .A1(slvidcode_reg[28]), .A2(n4), .B1(
        ftap_slvidcode[27]), .B2(n260), .Z(N54) );
  AO22D1BWP240H8P57PDSVT SYN_58 ( .A1(slvidcode_reg[29]), .A2(n4), .B1(
        ftap_slvidcode[28]), .B2(n260), .Z(N55) );
  AO22D1BWP240H8P57PDSVT SYN_59 ( .A1(slvidcode_reg[30]), .A2(n4), .B1(
        ftap_slvidcode[29]), .B2(n260), .Z(N56) );
  AO22D1BWP240H8P57PDSVT SYN_60 ( .A1(slvidcode_reg[31]), .A2(n4), .B1(
        ftap_slvidcode[30]), .B2(n260), .Z(N57) );
  AO22D1BWP240H8P57PDSVT SYN_61 ( .A1(ftap_tdi), .A2(n4), .B1(
        ftap_slvidcode[31]), .B2(n260), .Z(N58) );
  OA21D1BWP240H8P57PDSVT SYN_64 ( .A1(stap_irdecoder_drselect[0]), .A2(
        stap_and_all_bits_irreg), .B(bypass_reg), .Z(stap_drreg_tdo[0]) );
  SDFRPQD1BWP240H11P57PDSVT reset_pulse1_reg ( .D(reset_pulse0), .SI(1'b0), 
        .SE(1'b0), .CP(ftap_tck), .CD(n25), .Q(reset_pulse1) );
  SDFSNQD1BWP240H11P57PDSVT slvidcode_reg_reg_0 ( .D(N27), .SI(1'b0), .SE(1'b0), .CP(net763), .SDN(powergood_rst_trst_b), .Q(stap_drreg_tdo[1]) );
  SDFRPQD1BWP240H11P57PDSVT slvidcode_reg_reg_31 ( .D(N58), .SI(1'b0), .SE(
        1'b0), .CP(net763), .CD(n25), .Q(slvidcode_reg[31]) );
  SDFRPQD1BWP240H11P57PDSVT reset_pulse0_reg ( .D(1'b1), .SI(1'b0), .SE(1'b0), 
        .CP(ftap_tck), .CD(n25), .Q(reset_pulse0) );
  SEDFRPQD1BWP240H11P57PDSVT bypass_reg_reg ( .D(N10), .SI(1'b0), .E(N9), .SE(
        1'b0), .CP(ftap_tck), .CD(n25), .Q(bypass_reg) );
  INVPADD1BWP240H8P57PDSVT SYN_8 ( .I(powergood_rst_trst_b), .ZN(n25) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_1_2ndsig_slvidcode_reg_reg_2_2ndsig_slvidcode_reg_reg_3_2ndsig_slvidcode_reg_reg_4 ( 
        .D1(N28), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[1]), .D2(N29), .Q2(slvidcode_reg[2]), .D3(N30), .Q3(
        slvidcode_reg[3]), .D4(N31), .Q4(slvidcode_reg[4]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_5_2ndsig_slvidcode_reg_reg_6_2ndsig_slvidcode_reg_reg_7_2ndsig_slvidcode_reg_reg_8 ( 
        .D1(N32), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[5]), .D2(N33), .Q2(slvidcode_reg[6]), .D3(N34), .Q3(
        slvidcode_reg[7]), .D4(N35), .Q4(slvidcode_reg[8]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_9_2ndsig_slvidcode_reg_reg_10_2ndsig_slvidcode_reg_reg_11_2ndsig_slvidcode_reg_reg_12 ( 
        .D1(N36), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[9]), .D2(N37), .Q2(slvidcode_reg[10]), .D3(N38), .Q3(
        slvidcode_reg[11]), .D4(N39), .Q4(slvidcode_reg[12]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_13_2ndsig_slvidcode_reg_reg_14_2ndsig_slvidcode_reg_reg_15_2ndsig_slvidcode_reg_reg_16 ( 
        .D1(N40), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[13]), .D2(N41), .Q2(slvidcode_reg[14]), .D3(N42), .Q3(
        slvidcode_reg[15]), .D4(N43), .Q4(slvidcode_reg[16]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_17_2ndsig_slvidcode_reg_reg_18_2ndsig_slvidcode_reg_reg_19_2ndsig_slvidcode_reg_reg_20 ( 
        .D1(N44), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[17]), .D2(N45), .Q2(slvidcode_reg[18]), .D3(N46), .Q3(
        slvidcode_reg[19]), .D4(N47), .Q4(slvidcode_reg[20]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_21_2ndsig_slvidcode_reg_reg_22_2ndsig_slvidcode_reg_reg_23_2ndsig_slvidcode_reg_reg_24 ( 
        .D1(N48), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[21]), .D2(N49), .Q2(slvidcode_reg[22]), .D3(N50), .Q3(
        slvidcode_reg[23]), .D4(N51), .Q4(slvidcode_reg[24]) );
  MB4SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_25_2ndsig_slvidcode_reg_reg_26_2ndsig_slvidcode_reg_reg_27_2ndsig_slvidcode_reg_reg_28 ( 
        .D1(N52), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[25]), .D2(N53), .Q2(slvidcode_reg[26]), .D3(N54), .Q3(
        slvidcode_reg[27]), .D4(N55), .Q4(slvidcode_reg[28]) );
  MB2SRLSDFRPQD1BWP240H8P57PDSVT auto_vector_slvidcode_reg_reg_29_2ndsig_slvidcode_reg_reg_30 ( 
        .D1(N56), .CP(net763), .CD(n25), .SE(1'b0), .SI(1'b0), .Q1(
        slvidcode_reg[29]), .D2(N57), .Q2(slvidcode_reg[30]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_3 ( .I(1'b1), .ZN(tdr_data_out[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_5 ( .I(1'b1), .ZN(sftapnw_ftap_secsel[0])
         );
  INVPADD1BWP240H8P57PDSVT SYN_INC_7 ( .I(1'b1), .ZN(tapc_select[1]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_9 ( .I(1'b1), .ZN(tapc_select[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_11 ( .I(1'b1), .ZN(tapc_wtap_sel[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_13 ( .I(1'b1), .ZN(tapc_remove) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_15 ( .I(1'b0), .ZN(tap_rtdr_tdi[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_17 ( .I(1'b1), .ZN(tap_rtdr_capture[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_19 ( .I(1'b1), .ZN(tap_rtdr_shift[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_21 ( .I(1'b1), .ZN(tap_rtdr_update[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_23 ( .I(1'b1), .ZN(tap_rtdr_irdec[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_25 ( .I(1'b1), .ZN(tap_rtdr_selectir) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_27 ( .I(1'b0), .ZN(tap_rtdr_powergood) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_29 ( .I(1'b1), .ZN(tap_rtdr_rti) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_31 ( .I(1'b0), .ZN(tap_rtdr_prog_rst_b[0])
         );
  INVPADD1BWP240H8P57PDSVT SYN_INC_33 ( .I(1'b1), .ZN(
        suppress_update_capture_reg[1]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_35 ( .I(1'b1), .ZN(
        suppress_update_capture_reg[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_9 ( .I(n90), .ZN(n260) );
  INR3D2BWP240H8P57PDSVT SYN_7 ( .A1(stap_irdecoder_drselect[1]), .B1(n2), 
        .B2(n5), .ZN(n4) );
endmodule


module stap_ctech_lib_mux_2to1_0 ( d1, d2, s, o );
  input d1, d2, s;
  output o;


  MUX2D1BWP240H8P57PDSVT ctech_lib_mux_2to1_dcszo ( .I0(d2), .I1(d1), .S(s), 
        .Z(o) );
endmodule


module stap_stap_ctech_lib_mux_2to1_0 ( d1, d2, s, o );
  input d1, d2, s;
  output o;


  stap_ctech_lib_mux_2to1_0 i_ctech_lib_mux_2to1 ( .d1(d1), .d2(d2), .s(s), 
        .o(o) );
endmodule


module stap_stap_tdomux_4_0_0 ( stap_drreg_tdo, stap_fsm_shift_dr, 
        stap_fsm_shift_ir, stap_irdecoder_drselect, stap_irreg_serial_out, 
        stap_fsm_tlrs, ftap_tck, powergood_rst_trst_b, swcomp_stap_post_tdo, 
        tap_swcomp_active, stap_mux_tdo, tdo_dr, stap_tdomux_tdoen );
  input [3:0] stap_drreg_tdo;
  input [3:0] stap_irdecoder_drselect;
  input stap_fsm_shift_dr, stap_fsm_shift_ir, stap_irreg_serial_out,
         stap_fsm_tlrs, ftap_tck, powergood_rst_trst_b, swcomp_stap_post_tdo,
         tap_swcomp_active;
  output stap_mux_tdo, tdo_dr, stap_tdomux_tdoen;
  wire   stap_mux_tdo_int, stap_mux_tdo_preflop_int, N22, n4, n1, n2, n3, n5,
         n6, n7, n8;

  stap_stap_ctech_lib_mux_2to1_0 i_stap_ctech_lib_mux_2to1_tdo_posedge ( .d1(
        stap_mux_tdo_preflop_int), .d2(stap_mux_tdo_int), .s(1'b0), .o(
        stap_mux_tdo) );
  IAO21D1BWP240H8P57PDSVT SYN_3 ( .A1(stap_fsm_shift_dr), .A2(
        stap_fsm_shift_ir), .B(stap_fsm_tlrs), .ZN(N22) );
  AOI22D1BWP240H8P57PDSVT SYN_5 ( .A1(stap_drreg_tdo[2]), .A2(
        stap_irdecoder_drselect[2]), .B1(stap_drreg_tdo[3]), .B2(
        stap_irdecoder_drselect[3]), .ZN(n2) );
  AOI22D1BWP240H8P57PDSVT SYN_6 ( .A1(stap_drreg_tdo[0]), .A2(
        stap_irdecoder_drselect[0]), .B1(stap_drreg_tdo[1]), .B2(
        stap_irdecoder_drselect[1]), .ZN(n1) );
  ND2D1BWP240H8P57PDSVT SYN_7 ( .A1(n2), .A2(n1), .ZN(tdo_dr) );
  INVPADD1BWP240H8P57PDSVT SYN_8 ( .I(tap_swcomp_active), .ZN(n3) );
  AOI221D1BWP240H8P57PDSVT SYN_9 ( .A1(swcomp_stap_post_tdo), .A2(n3), .B1(
        tdo_dr), .B2(tap_swcomp_active), .C(stap_fsm_shift_ir), .ZN(n5) );
  IAOI21D1BWP240H8P57PDSVT SYN_10 ( .A2(stap_irreg_serial_out), .A1(
        stap_fsm_shift_ir), .B(n5), .ZN(n6) );
  INR3D1BWP240H8P57PDSVT SYN_11 ( .A1(n6), .B1(stap_fsm_tlrs), .B2(n8), .ZN(
        stap_mux_tdo_preflop_int) );
  NR3D1BWP240H8P57PDSVT SYN_13 ( .A1(stap_fsm_shift_dr), .A2(stap_fsm_shift_ir), .A3(stap_fsm_tlrs), .ZN(n7) );
  AO22D1BWP240H8P57PDSVT SYN_14 ( .A1(stap_mux_tdo_int), .A2(n7), .B1(n6), 
        .B2(N22), .Z(n4) );
  INVPADD1BWP240H8P57PDSVT SYN_4 ( .I(powergood_rst_trst_b), .ZN(n8) );
  SDFNRPQD1BWP240H11P57PDSVT stap_mux_tdo_int_reg ( .D(n4), .SI(1'b0), .SE(
        1'b0), .CPN(ftap_tck), .CD(n8), .Q(stap_mux_tdo_int) );
  SDFNRPQD1BWP240H11P57PDSVT stap_tdomux_tdoen_reg ( .D(N22), .SI(1'b0), .SE(
        1'b0), .CPN(ftap_tck), .CD(n8), .Q(stap_tdomux_tdoen) );
endmodule


module stap_ctech_lib_clk_buf_2 ( clk, clkout );
  input clk;
  output clkout;


  BUFFD1BWP240H8P57PDSVT ctech_lib_clk_buf_dcszo ( .I(clk), .Z(clkout) );
endmodule


module stap_stap_ctech_lib_clk_buf_0 ( clk, clkout );
  input clk;
  output clkout;


  stap_ctech_lib_clk_buf_2 i_ctech_lib_clk_buf ( .clk(clk), .clkout(clkout) );
endmodule


module stap ( ftap_tck, ftap_tms, ftap_trst_b, ftap_tdi, ftap_slvidcode, 
        atap_tdo, atap_tdoen, fdfx_powergood, tdr_data_out, tdr_data_in, 
        fdfx_secure_policy, fdfx_earlyboot_exit, fdfx_policy_update, 
        sftapnw_ftap_secsel, sftapnw_ftap_enabletdo, sftapnw_ftap_enabletap, 
        sntapnw_ftap_tck, sntapnw_ftap_tms, sntapnw_ftap_trst_b, 
        sntapnw_ftap_tdi, sntapnw_atap_tdo, sntapnw_atap_tdo_en, ftapsslv_tck, 
        ftapsslv_tms, ftapsslv_trst_b, ftapsslv_tdi, atapsslv_tdo, 
        atapsslv_tdoen, sntapnw_ftap_tck2, sntapnw_ftap_tms2, 
        sntapnw_ftap_trst2_b, sntapnw_ftap_tdi2, sntapnw_atap_tdo2, 
        sntapnw_atap_tdo2_en, sn_fwtap_wrck, sn_fwtap_wrst_b, 
        sn_fwtap_capturewr, sn_fwtap_shiftwr, sn_fwtap_updatewr, sn_fwtap_rti, 
        sn_fwtap_selectwir, sn_awtap_wso, sn_fwtap_wsi, stap_fbscan_tck, 
        stap_abscan_tdo, stap_fbscan_capturedr, stap_fbscan_shiftdr, 
        stap_fbscan_updatedr, stap_fbscan_updatedr_clk, stap_fbscan_runbist_en, 
        stap_fbscan_highz, stap_fbscan_extogen, stap_fbscan_intest_mode, 
        stap_fbscan_chainen, stap_fbscan_mode, stap_fbscan_extogsig_b, 
        stap_fsm_tlrs, ftap_pwrdomain_rst_b, stap_fbscan_d6init, 
        stap_fbscan_d6actestsig_b, stap_fbscan_d6select, rtdr_tap_tdo, 
        tap_rtdr_irdec, tap_rtdr_prog_rst_b, tap_rtdr_tdi, tap_rtdr_capture, 
        tap_rtdr_shift, tap_rtdr_update, tap_rtdr_tck, tap_rtdr_powergood, 
        tap_rtdr_selectir, tap_rtdr_rti, stap_isol_en_b );
  input [31:0] ftap_slvidcode;
  output [0:0] tdr_data_out;
  input [0:0] tdr_data_in;
  input [3:0] fdfx_secure_policy;
  output [0:0] sftapnw_ftap_secsel;
  output [0:0] sftapnw_ftap_enabletdo;
  output [0:0] sftapnw_ftap_enabletap;
  input [0:0] sntapnw_atap_tdo_en;
  input [0:0] sntapnw_atap_tdo2_en;
  input [0:0] sn_awtap_wso;
  output [0:0] sn_fwtap_wsi;
  input [0:0] rtdr_tap_tdo;
  output [0:0] tap_rtdr_irdec;
  output [0:0] tap_rtdr_prog_rst_b;
  output [0:0] tap_rtdr_tdi;
  output [0:0] tap_rtdr_capture;
  output [0:0] tap_rtdr_shift;
  output [0:0] tap_rtdr_update;
  input ftap_tck, ftap_tms, ftap_trst_b, ftap_tdi, fdfx_powergood,
         fdfx_earlyboot_exit, fdfx_policy_update, sntapnw_atap_tdo,
         ftapsslv_tck, ftapsslv_tms, ftapsslv_trst_b, ftapsslv_tdi,
         sntapnw_atap_tdo2, stap_abscan_tdo, ftap_pwrdomain_rst_b,
         stap_isol_en_b;
  output atap_tdo, atap_tdoen, sntapnw_ftap_tck, sntapnw_ftap_tms,
         sntapnw_ftap_trst_b, sntapnw_ftap_tdi, atapsslv_tdo, atapsslv_tdoen,
         sntapnw_ftap_tck2, sntapnw_ftap_tms2, sntapnw_ftap_trst2_b,
         sntapnw_ftap_tdi2, sn_fwtap_wrck, sn_fwtap_wrst_b, sn_fwtap_capturewr,
         sn_fwtap_shiftwr, sn_fwtap_updatewr, sn_fwtap_rti, sn_fwtap_selectwir,
         stap_fbscan_tck, stap_fbscan_capturedr, stap_fbscan_shiftdr,
         stap_fbscan_updatedr, stap_fbscan_updatedr_clk,
         stap_fbscan_runbist_en, stap_fbscan_highz, stap_fbscan_extogen,
         stap_fbscan_intest_mode, stap_fbscan_chainen, stap_fbscan_mode,
         stap_fbscan_extogsig_b, stap_fsm_tlrs, stap_fbscan_d6init,
         stap_fbscan_d6actestsig_b, stap_fbscan_d6select, tap_rtdr_tck,
         tap_rtdr_powergood, tap_rtdr_selectir, tap_rtdr_rti;
  wire   powergood_rst_trst_b, tapc_remove, stap_fsm_rti, stap_fsm_e2dr,
         stap_selectwir, stap_fsm_capture_ir, stap_fsm_shift_ir,
         stap_fsm_update_ir, stap_fsm_capture_dr, stap_fsm_shift_dr,
         stap_fsm_update_dr, stap_irreg_serial_out, stap_and_all_bits_irreg,
         tap_swcomp_active, \tapc_wtap_sel[0] , swcompctrl_tdo, swcompstat_tdo,
         swcomp_stap_post_tdo, stap_mux_tdo, tdo_dr, stap_tdomux_tdoen,
         n_2_net_0, n_3_net_0, n5, n6, SYNOPSYS_UNCONNECTED_1,
         SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3,
         SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5,
         SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7,
         SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9,
         SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11,
         SYNOPSYS_UNCONNECTED_12, SYNOPSYS_UNCONNECTED_13;
  wire   [1:0] suppress_update_capture_reg;
  wire   [7:0] stap_irreg_ireg;
  wire   [7:0] stap_irreg_ireg_nxt;
  wire   [3:0] stap_irdecoder_drselect;
  wire   [2:0] dfxsecure_feature_en;
  wire   [1:0] tapc_select;
  wire   [3:0] stap_drreg_tdo;

  stap_stap_ctech_lib_clk_buf_0 i_stap_ctech_lib_clk_buf_rtdr ( .clk(n5), 
        .clkout(tap_rtdr_tck) );
  stap_stap_fsm_0_0_0_0_8_0_0 i_stap_fsm ( .ftap_tms(ftap_tms), .ftap_tck(n6), 
        .powergood_rst_trst_b(powergood_rst_trst_b), 
        .suppress_update_capture_reg(suppress_update_capture_reg), 
        .stap_irreg_ireg(stap_irreg_ireg), .tapc_remove(tapc_remove), 
        .stap_fsm_tlrs(stap_fsm_tlrs), .stap_fsm_rti(stap_fsm_rti), 
        .stap_fsm_e1dr(SYNOPSYS_UNCONNECTED_1), .stap_fsm_e2dr(stap_fsm_e2dr), 
        .stap_selectwir(stap_selectwir), .stap_selectwir_neg(
        SYNOPSYS_UNCONNECTED_2), .sn_fwtap_capturewr(sn_fwtap_capturewr), 
        .sn_fwtap_shiftwr(sn_fwtap_shiftwr), .sn_fwtap_updatewr(
        sn_fwtap_updatewr), .sn_fwtap_rti(sn_fwtap_rti), .sn_fwtap_wrst_b(
        sn_fwtap_wrst_b), .stap_fsm_capture_ir(stap_fsm_capture_ir), 
        .stap_fsm_shift_ir(stap_fsm_shift_ir), .stap_fsm_shift_ir_neg(
        SYNOPSYS_UNCONNECTED_3), .stap_fsm_update_ir(stap_fsm_update_ir), 
        .stap_fsm_capture_dr(stap_fsm_capture_dr), .stap_fsm_shift_dr(
        stap_fsm_shift_dr), .stap_fsm_update_dr(stap_fsm_update_dr) );
  stap_stap_irreg_8_8_0 i_stap_irreg ( .stap_fsm_tlrs(stap_fsm_tlrs), 
        .stap_fsm_capture_ir(stap_fsm_capture_ir), .stap_fsm_shift_ir(
        stap_fsm_shift_ir), .stap_fsm_update_ir(stap_fsm_update_ir), 
        .ftap_tdi(ftap_tdi), .ftap_tck(n5), .powergood_rst_trst_b(
        powergood_rst_trst_b), .stap_irreg_ireg(stap_irreg_ireg), 
        .stap_irreg_ireg_nxt(stap_irreg_ireg_nxt), .stap_irreg_serial_out(
        stap_irreg_serial_out), .stap_irreg_shift_reg({SYNOPSYS_UNCONNECTED_4, 
        SYNOPSYS_UNCONNECTED_5, SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7, 
        SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9, 
        SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11}) );
  stap_stap_irdecoder_1_8_4_210800c3fc_04_8_0_0_1_2_0 i_stap_irdecoder ( 
        .powergood_rst_trst_b(powergood_rst_trst_b), .stap_irreg_ireg(
        stap_irreg_ireg), .stap_irreg_ireg_nxt(stap_irreg_ireg_nxt), 
        .ftap_tck(n5), .feature_green_en(dfxsecure_feature_en[0]), 
        .feature_orange_en(dfxsecure_feature_en[1]), .feature_red_en(
        dfxsecure_feature_en[2]), .stap_isol_en_b(stap_isol_en_b), 
        .stap_irdecoder_drselect(stap_irdecoder_drselect), .tap_swcomp_active(
        tap_swcomp_active), .stap_and_all_bits_irreg(stap_and_all_bits_irreg)
         );
  stap_stap_drreg_1_0_0_0_0_0_32_4_2_16_1_0000_0000_0000_0_0_1_1_1_0_0_0_0_0_0_0_0_0_0_2_0_0_0_0_1_1_0_0_0_0_1_2_0 i_stap_drreg ( 
        .stap_fsm_tlrs(stap_fsm_tlrs), .ftap_tdi(ftap_tdi), .ftap_tck(n5), 
        .ftap_trst_b(ftap_trst_b), .fdfx_powergood(fdfx_powergood), 
        .powergood_rst_trst_b(powergood_rst_trst_b), .stap_fsm_capture_dr(
        stap_fsm_capture_dr), .stap_fsm_shift_dr(stap_fsm_shift_dr), 
        .stap_fsm_update_dr(stap_fsm_update_dr), .stap_selectwir(
        stap_selectwir), .ftap_slvidcode(ftap_slvidcode), 
        .stap_irdecoder_drselect(stap_irdecoder_drselect), .tdr_data_in(
        tdr_data_in[0]), .tdr_data_out(tdr_data_out[0]), .sftapnw_ftap_secsel(
        sftapnw_ftap_secsel[0]), .tapc_select(tapc_select), .feature_green_en(
        dfxsecure_feature_en[0]), .feature_orange_en(dfxsecure_feature_en[1]), 
        .feature_red_en(dfxsecure_feature_en[2]), .tapc_wtap_sel(
        \tapc_wtap_sel[0] ), .tapc_remove(tapc_remove), .stap_drreg_tdo(
        stap_drreg_tdo), .swcompctrl_tdo(swcompctrl_tdo), .swcompstat_tdo(
        swcompstat_tdo), .stap_and_all_bits_irreg(stap_and_all_bits_irreg), 
        .rtdr_tap_tdo(rtdr_tap_tdo[0]), .tap_rtdr_tdi(tap_rtdr_tdi[0]), 
        .tap_rtdr_capture(tap_rtdr_capture[0]), .tap_rtdr_shift(
        tap_rtdr_shift[0]), .tap_rtdr_update(tap_rtdr_update[0]), 
        .tap_rtdr_irdec(tap_rtdr_irdec[0]), .tap_rtdr_selectir(
        tap_rtdr_selectir), .tap_rtdr_powergood(tap_rtdr_powergood), 
        .tap_rtdr_rti(tap_rtdr_rti), .tap_rtdr_prog_rst_b(
        tap_rtdr_prog_rst_b[0]), .suppress_update_capture_reg(
        suppress_update_capture_reg), .stap_fsm_rti(stap_fsm_rti) );
  stap_stap_tdomux_4_0_0 i_stap_tdomux ( .stap_drreg_tdo(stap_drreg_tdo), 
        .stap_fsm_shift_dr(stap_fsm_shift_dr), .stap_fsm_shift_ir(
        stap_fsm_shift_ir), .stap_irdecoder_drselect(stap_irdecoder_drselect), 
        .stap_irreg_serial_out(stap_irreg_serial_out), .stap_fsm_tlrs(
        stap_fsm_tlrs), .ftap_tck(n5), .powergood_rst_trst_b(
        powergood_rst_trst_b), .swcomp_stap_post_tdo(swcomp_stap_post_tdo), 
        .tap_swcomp_active(tap_swcomp_active), .stap_mux_tdo(stap_mux_tdo), 
        .tdo_dr(tdo_dr), .stap_tdomux_tdoen(stap_tdomux_tdoen) );
  stap_stap_glue_0_0_1_1_8_0_0_0 i_stap_glue ( .ftap_tck(ftap_tck), .ftap_tms(
        ftap_tms), .ftap_trst_b(ftap_trst_b), .fdfx_powergood(fdfx_powergood), 
        .ftap_tdi(ftap_tdi), .stap_tdomux_tdoen(stap_tdomux_tdoen), 
        .sntapnw_atap_tdo_en(sntapnw_atap_tdo_en[0]), .pre_tdo(atap_tdo), 
        .powergood_rst_trst_b(powergood_rst_trst_b), .atap_tdoen(atap_tdoen), 
        .sntapnw_ftap_tck(sntapnw_ftap_tck), .sntapnw_ftap_tms(
        sntapnw_ftap_tms), .sntapnw_ftap_trst_b(sntapnw_ftap_trst_b), 
        .sntapnw_ftap_tdi(sntapnw_ftap_tdi), .sntapnw_atap_tdo(
        sntapnw_atap_tdo), .ftapsslv_tck(ftapsslv_tck), .ftapsslv_tms(
        ftapsslv_tms), .ftapsslv_trst_b(ftapsslv_trst_b), .ftapsslv_tdi(
        ftapsslv_tdi), .atapsslv_tdo(atapsslv_tdo), .atapsslv_tdoen(
        atapsslv_tdoen), .sntapnw_ftap_tck2(sntapnw_ftap_tck2), 
        .sntapnw_ftap_tms2(sntapnw_ftap_tms2), .sntapnw_ftap_trst2_b(
        sntapnw_ftap_trst2_b), .sntapnw_ftap_tdi2(sntapnw_ftap_tdi2), 
        .sntapnw_atap_tdo2(sntapnw_atap_tdo2), .sntapnw_atap_tdo2_en(
        sntapnw_atap_tdo2_en[0]), .sn_fwtap_wrck(sn_fwtap_wrck), 
        .stap_mux_tdo(stap_mux_tdo), .tapc_select(tapc_select), 
        .tapc_wtap_sel(\tapc_wtap_sel[0] ), .tapc_remove(tapc_remove), 
        .stap_wtapnw_tdo(1'b1) );
  stap_stap_dfxsecure_plugin_3_4_0_3_1_2_0_07_3ad6b5ae6b9cd733cce7_0 i_stap_dfxsecure_plugin ( 
        .fdfx_powergood(fdfx_powergood), .fdfx_secure_policy(
        fdfx_secure_policy), .fdfx_earlyboot_exit(fdfx_earlyboot_exit), 
        .fdfx_policy_update(fdfx_policy_update), .dfxsecure_feature_en(
        dfxsecure_feature_en), .visa_all_dis(SYNOPSYS_UNCONNECTED_12), 
        .visa_customer_dis(SYNOPSYS_UNCONNECTED_13), .sb_policy_ovr_value({
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .oem_secure_policy({1'b0, 1'b0, 1'b0, 
        1'b0}) );
  stap_stap_swcomp_rtdr_10_0 \generate_stap_swcomp_rtdr.i_stap_swcomp_rtdr  ( 
        .stap_fsm_tlrs(stap_fsm_tlrs), .ftap_tck(n6), .ftap_tdi(ftap_tdi), 
        .fdfx_powergood(n_2_net_0), .powergood_rst_trst_b(n_3_net_0), 
        .stap_fsm_capture_dr(stap_fsm_capture_dr), .stap_fsm_shift_dr(
        stap_fsm_shift_dr), .stap_fsm_update_dr(stap_fsm_update_dr), 
        .stap_fsm_e2dr(stap_fsm_e2dr), .stap_swcomp_pre_tdo(tdo_dr), 
        .tap_swcomp_active(tap_swcomp_active), .swcomp_stap_post_tdo(
        swcomp_stap_post_tdo), .swcompctrl_tdo(swcompctrl_tdo), 
        .swcompstat_tdo(swcompstat_tdo) );
  AN2D1BWP240H8P57PDSVT SYN_9 ( .A1(ftap_pwrdomain_rst_b), .A2(fdfx_powergood), 
        .Z(n_2_net_0) );
  AN2D1BWP240H8P57PDSVT SYN_12 ( .A1(ftap_pwrdomain_rst_b), .A2(
        powergood_rst_trst_b), .Z(n_3_net_0) );
  BUFFD1BWP240H8P57PDSVT SYN_13 ( .I(ftap_tck), .Z(n5) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_7 ( .I(1'b1), .ZN(stap_fbscan_d6select) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_9 ( .I(1'b0), .ZN(stap_fbscan_d6actestsig_b) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_11 ( .I(1'b1), .ZN(stap_fbscan_d6init) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_13 ( .I(1'b0), .ZN(stap_fbscan_extogsig_b)
         );
  INVPADD1BWP240H8P57PDSVT SYN_INC_15 ( .I(1'b1), .ZN(stap_fbscan_mode) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_17 ( .I(1'b1), .ZN(stap_fbscan_chainen) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_19 ( .I(1'b1), .ZN(stap_fbscan_intest_mode)
         );
  INVPADD1BWP240H8P57PDSVT SYN_INC_21 ( .I(1'b1), .ZN(stap_fbscan_extogen) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_23 ( .I(1'b1), .ZN(stap_fbscan_highz) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_25 ( .I(1'b1), .ZN(stap_fbscan_runbist_en)
         );
  INVPADD1BWP240H8P57PDSVT SYN_INC_27 ( .I(1'b1), .ZN(stap_fbscan_updatedr_clk) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_29 ( .I(1'b1), .ZN(stap_fbscan_updatedr) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_31 ( .I(1'b1), .ZN(stap_fbscan_shiftdr) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_33 ( .I(1'b1), .ZN(stap_fbscan_capturedr)
         );
  INVPADD1BWP240H8P57PDSVT SYN_INC_35 ( .I(1'b1), .ZN(stap_fbscan_tck) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_37 ( .I(1'b0), .ZN(sn_fwtap_wsi[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_39 ( .I(1'b1), .ZN(sn_fwtap_selectwir) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_41 ( .I(1'b1), .ZN(
        sftapnw_ftap_enabletap[0]) );
  INVPADD1BWP240H8P57PDSVT SYN_INC_43 ( .I(1'b1), .ZN(
        sftapnw_ftap_enabletdo[0]) );
  BUFFD1BWP240H8P57PDSVT SYN_14 ( .I(ftap_tck), .Z(n6) );
endmodule

