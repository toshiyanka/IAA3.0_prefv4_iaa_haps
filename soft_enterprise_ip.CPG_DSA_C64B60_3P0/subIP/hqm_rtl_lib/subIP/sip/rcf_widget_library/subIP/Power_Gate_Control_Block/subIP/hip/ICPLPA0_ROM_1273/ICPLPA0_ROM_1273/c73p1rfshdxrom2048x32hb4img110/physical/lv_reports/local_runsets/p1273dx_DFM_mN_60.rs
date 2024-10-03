// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DFM_mN_60.rs.rca 1.7 Wed Oct 30 13:37:07 2013 gmonroy Experimental $
//
// $Log: p1273dx_DFM_mN_60.rs.rca $
// 
//  Revision: 1.7 Wed Oct 30 13:37:07 2013 gmonroy
//  Refactored DFM code to allow future features
// 
//  Revision: 1.6 Fri Aug  9 19:15:56 2013 gmonroy
//  Added p1273.6 support
// 
//  Revision: 1.5 Tue Aug  6 12:07:46 2013 gmonroy
//  Fix M5_60 underflag due to redbook errata
// 
//  Revision: 1.4 Wed Jul  3 13:57:49 2013 gmonroy
//  Support 1273.1
// 
//  Revision: 1.3 Wed Jun 19 12:20:25 2013 gmonroy
//  Split M2_60 4$ violations between 4$ lteq32 and 3$ gt32
// 
//  Revision: 1.2 Mon May  6 10:22:40 2013 gmonroy
//  Fix incorrect pXX (plus values) in M4/5/6/8 labels
// 
//  Revision: 1.1 Mon Mar 18 16:08:04 2013 gmonroy
//  1273-specific short-wire DFM rules.
//

#ifndef P1273DX_DFM_MN_60_RS_
#define P1273DX_DFM_MN_60_RS_

#include <p12723_dfm_mN_60_function.rs>

////////////////////
//M0 short wire markers
markerSet_m0_60 = drShortNarrowMetalMarker(METAL0BC, non_gate_dir, VIA0, VIACON, 
					   min_len_range=[.086, .156), wid_r<=.048, 
					   top_via_dist=.151, bot_via_dist=.159);
DFM_M0_60_2V_p70 = markerSet_m0_60.twoV;
dfm_register(DFM_M0_60_2V_p70); // $$

DFM_M0_60_1V_p70 = markerSet_m0_60.oneV;
dfm_register(DFM_M0_60_1V_p70); // $

DFM_M0_60_0V_p70 = markerSet_m0_60.noV;
dfm_register(DFM_M0_60_0V_p70); // $

DFM_M0_60_F_p70  = markerSet_m0_60.F;
dfm_register(DFM_M0_60_F_p70); // $


////////////////////
//M1 short wire markers
markerSet_m1_60 = drShortNarrowMetalMarker(METAL1BC, gate_dir, VIA1, VIA0,
					   min_len_range=[.07, .085), wid_r<=.042, 
					   top_via_dist=.104, bot_via_dist=.111);
DFM_M1_60_2V_p15 = markerSet_m1_60.twoV;
dfm_register(DFM_M1_60_2V_p15); // $$$$

DFM_M1_60_1V_p15 = markerSet_m1_60.oneV;
dfm_register(DFM_M1_60_1V_p15); // $$$

DFM_M1_60_0V_p15 = markerSet_m1_60.noV;
dfm_register(DFM_M1_60_0V_p15); // $$

DFM_M1_60_F_p15  = markerSet_m1_60.F;
dfm_register(DFM_M1_60_F_p15); // $$


markerSet_m1_60a= drShortNarrowMetalMarker(METAL1BC, gate_dir, VIA1, VIA0,
					   min_len_range=[.085, .100), wid_r<=.042,
					   top_via_dist=.104, bot_via_dist=.111);
DFM_M1_60_2V_p15_30 = markerSet_m1_60a.twoV;
dfm_register(DFM_M1_60_2V_p15_30); // $$$

DFM_M1_60_1V_p15_30 = markerSet_m1_60a.oneV;
dfm_register(DFM_M1_60_1V_p15_30); // $$

DFM_M1_60_0V_p15_30 = markerSet_m1_60a.noV;
dfm_register(DFM_M1_60_0V_p15_30); // $

DFM_M1_60_F_p15_30 = markerSet_m1_60a.F;
dfm_register(DFM_M1_60_F_p15_30); // $


////////////////////
//M2 short wire markers

// We are further splitting the M2 $$$$ violations by wire width
markerSet_m2_60_lteq32 = drShortNarrowMetalMarker(METAL2BC, non_gate_dir, VIA2, VIA1,
					   min_len_range=[.084, .092), wid_r<=.032,
					   top_via_dist=.12, bot_via_dist=.135);
DFM_M2_60_2V_p8_lteq32 = markerSet_m2_60_lteq32.twoV;
dfm_register(DFM_M2_60_2V_p8_lteq32); // $$$$


markerSet_m2_60_gt32 = drShortNarrowMetalMarker(METAL2BC, non_gate_dir, VIA2, VIA1,
					   min_len_range=[.084, .092), wid_r=(.032, .046],
					   top_via_dist=.12, bot_via_dist=.135);
DFM_M2_60_2V_p8_gt32 = markerSet_m2_60_gt32.twoV;
dfm_register(DFM_M2_60_2V_p8_gt32); // $$$


markerSet_m2_60 = drShortNarrowMetalMarker(METAL2BC, non_gate_dir, VIA2, VIA1,
					   min_len_range=[.084, .092), wid_r<=.046,
					   top_via_dist=.12, bot_via_dist=.135);
//DFM_M2_60_2V_p8 = markerSet_m2_60.twoV;
//dfm_register(DFM_M2_60_2V_p8); // $$$$

DFM_M2_60_1V_p8 = markerSet_m2_60.oneV;
dfm_register(DFM_M2_60_1V_p8); // $$$

DFM_M2_60_0V_p8 = markerSet_m2_60.noV;
dfm_register(DFM_M2_60_0V_p8); // $$

DFM_M2_60_F_p8 = markerSet_m2_60.F;
dfm_register(DFM_M2_60_F_p8); // $$


markerSet_m2_60a = drShortNarrowMetalMarker(METAL2BC, non_gate_dir, VIA2, VIA1,
					    min_len_range=[.092, .100), wid_r<=.046,
					    top_via_dist=.12, bot_via_dist=.135);
DFM_M2_60_2V_p8_16 = markerSet_m2_60a.twoV;
dfm_register(DFM_M2_60_2V_p8_16); // $$$

DFM_M2_60_1V_p8_16 = markerSet_m2_60a.oneV;
dfm_register(DFM_M2_60_1V_p8_16); // $$

DFM_M2_60_0V_p8_16 = markerSet_m2_60a.noV;
dfm_register(DFM_M2_60_0V_p8_16); // $

DFM_M2_60_F_p8_16 = markerSet_m2_60a.F;
dfm_register(DFM_M2_60_F_p8_16); // $


////////////////////
//M3 short wire markers
markerSet_m3_60 = drShortNarrowMetalMarker(METAL3BC, gate_dir, VIA3, VIA2,
					   min_len_range=[.084, .092), wid_r<=.046,
					   top_via_dist=.12, bot_via_dist=.135);
DFM_M3_60_2V_p8 = markerSet_m3_60.twoV;
dfm_register(DFM_M3_60_2V_p8); // $$$$

DFM_M3_60_1V_p8 = markerSet_m3_60.oneV;
dfm_register(DFM_M3_60_1V_p8); // $$$

DFM_M3_60_0V_p8 = markerSet_m3_60.noV;
dfm_register(DFM_M3_60_0V_p8); // $$

DFM_M3_60_F_p8 = markerSet_m3_60.F;
dfm_register(DFM_M3_60_F_p8); // $$


markerSet_m3_60a = drShortNarrowMetalMarker(METAL3BC, gate_dir, VIA3, VIA2,
					    min_len_range=[.092, .100), wid_r<=.046,
					    top_via_dist=.12, bot_via_dist=.135);
DFM_M3_60_2V_p8_16 = markerSet_m3_60a.twoV;
dfm_register(DFM_M3_60_2V_p8_16); // $$$

DFM_M3_60_1V_p8_16 = markerSet_m3_60a.oneV;
dfm_register(DFM_M3_60_1V_p8_16); // $$

DFM_M3_60_0V_p8_16 = markerSet_m3_60a.noV;
dfm_register(DFM_M3_60_0V_p8_16); // $

DFM_M3_60_F_p8_16 = markerSet_m3_60a.F;
dfm_register(DFM_M3_60_F_p8_16); // $


////////////////////
//M4 short wire markers
#if (_drPROCESS == 6)
  markerSet_m4_60 = drShortNarrowMetalMarker(METAL4BC, non_gate_dir, VIA4, VIA3,
					     min_len_range=[.084, .092), wid_r<=.046,
					     top_via_dist=.123, bot_via_dist=.135);
#else
  markerSet_m4_60 = drShortNarrowMetalMarker(METAL4BC, non_gate_dir, VIA4, VIA3,
					     min_len_range=[.084, .092), wid_r<=.046,
					     top_via_dist=.120, bot_via_dist=.135);
#endif
DFM_M4_60_2V_p8 = markerSet_m4_60.twoV;
dfm_register(DFM_M4_60_2V_p8); // $$$$

DFM_M4_60_1V_p8 = markerSet_m4_60.oneV;
dfm_register(DFM_M4_60_1V_p8); // $$$

DFM_M4_60_0V_p8 = markerSet_m4_60.noV;
dfm_register(DFM_M4_60_0V_p8); // $$

DFM_M4_60_F_p8 = markerSet_m4_60.F;
dfm_register(DFM_M4_60_F_p8); // $$


#if (_drPROCESS == 6)
  markerSet_m4_60a = drShortNarrowMetalMarker(METAL4BC, non_gate_dir, VIA4, VIA3,
					      min_len_range=[.092, .100), wid_r<=.046,
					      top_via_dist=.123, bot_via_dist=.135);
#else
  markerSet_m4_60a = drShortNarrowMetalMarker(METAL4BC, non_gate_dir, VIA4, VIA3,
					      min_len_range=[.092, .100), wid_r<=.046,
					      top_via_dist=.120, bot_via_dist=.135);
#endif
DFM_M4_60_2V_p8_16 = markerSet_m4_60a.twoV;
dfm_register(DFM_M4_60_2V_p8_16); // $$$

DFM_M4_60_1V_p8_16 = markerSet_m4_60a.oneV;
dfm_register(DFM_M4_60_1V_p8_16); // $$

DFM_M4_60_0V_p8_16 = markerSet_m4_60a.noV;
dfm_register(DFM_M4_60_0V_p8_16); // $

DFM_M4_60_F_p8_16 = markerSet_m4_60a.F;
dfm_register(DFM_M4_60_F_p8_16); // $



////////////////////
//M5 short wire markers
#if (_drPROCESS == 6)
  markerSet_m5_60 = drShortNarrowMetalMarker(METAL5BC, gate_dir, VIA5, VIA4,
					     min_len_range=[.160, .180), wid_r<=.044,	// up to 44
					     top_via_dist=.22, bot_via_dist=.22);
  DFM_M5_60_2V_p20 = markerSet_m5_60.twoV;
  DFM_M5_60_1V_p20 = markerSet_m5_60.oneV;
  DFM_M5_60_0V_p20 = markerSet_m5_60.noV;
  DFM_M5_60_F_p20  = markerSet_m5_60.F;

  markerSet_m5_60_2 = drShortNarrowMetalMarker(METAL5BC, gate_dir, VIA5, VIA4,
					     min_len_range=[.160, .180), wid_r=(.044,.06],	// 44 to 60
					     top_via_dist=.212, bot_via_dist=.212);
  DFM_M5_60_2V_p20 = DFM_M5_60_2V_p20 or markerSet_m5_60_2.twoV;
  dfm_register(DFM_M5_60_2V_p20); // $$$$

  DFM_M5_60_1V_p20 = DFM_M5_60_1V_p20 or markerSet_m5_60_2.oneV;
  dfm_register(DFM_M5_60_1V_p20); // $$$

  DFM_M5_60_0V_p20 = DFM_M5_60_0V_p20 or markerSet_m5_60_2.noV;
  dfm_register(DFM_M5_60_0V_p20); // $$

  DFM_M5_60_F_p20  = DFM_M5_60_F_p20  or markerSet_m5_60_2.F;
  dfm_register(DFM_M5_60_F_p20); // $$


  markerSet_m5_60a = drShortNarrowMetalMarker(METAL5BC, gate_dir, VIA5, VIA4,
					      min_len_range=[.180, .200), wid_r<=.044,	// up to 44
					      top_via_dist=.22, bot_via_dist=.22);
  DFM_M5_60_2V_p20_40 = markerSet_m5_60a.twoV;
  DFM_M5_60_1V_p20_40 = markerSet_m5_60a.oneV;
  DFM_M5_60_0V_p20_40 = markerSet_m5_60a.noV;
  DFM_M5_60_F_p20_40  = markerSet_m5_60a.F;

  markerSet_m5_60a_2 = drShortNarrowMetalMarker(METAL5BC, gate_dir, VIA5, VIA4,
					      min_len_range=[.180, .200), wid_r=(.044,.06],	// 44 to 60
					      top_via_dist=.212, bot_via_dist=.212);
  DFM_M5_60_2V_p20_40 = DFM_M5_60_2V_p20_40 or markerSet_m5_60a_2.twoV;
  dfm_register(DFM_M5_60_2V_p20_40); // $$$

  DFM_M5_60_1V_p20_40 = DFM_M5_60_1V_p20_40 or markerSet_m5_60a_2.oneV;
  dfm_register(DFM_M5_60_1V_p20_40); // $$

  DFM_M5_60_0V_p20_40 = DFM_M5_60_0V_p20_40 or markerSet_m5_60a_2.noV;
  dfm_register(DFM_M5_60_0V_p20_40); // $

  DFM_M5_60_F_p20_40  = DFM_M5_60_F_p20_40  or markerSet_m5_60a_2.F;
  dfm_register(DFM_M5_60_F_p20_40); // $

#else
  markerSet_m5_60 = drShortNarrowMetalMarker(METAL5BC, gate_dir, VIA5, VIA4,
					     min_len_range=[.084, .092), wid_r<=.046,
					     top_via_dist=.123, bot_via_dist=.135);
  DFM_M5_60_2V_p8 = markerSet_m5_60.twoV;
  dfm_register(DFM_M5_60_2V_p8); // $$$$

  DFM_M5_60_1V_p8 = markerSet_m5_60.oneV;
  dfm_register(DFM_M5_60_1V_p8); // $$$

  DFM_M5_60_0V_p8 = markerSet_m5_60.noV;
  dfm_register(DFM_M5_60_0V_p8); // $$

  DFM_M5_60_F_p8 = markerSet_m5_60.F;
  dfm_register(DFM_M5_60_F_p8); // $$


  markerSet_m5_60a = drShortNarrowMetalMarker(METAL5BC, gate_dir, VIA5, VIA4,
					      min_len_range=[.092, .100), wid_r<=.046,
					      top_via_dist=.123, bot_via_dist=.135);
  DFM_M5_60_2V_p8_16 = markerSet_m5_60a.twoV;
  dfm_register(DFM_M5_60_2V_p8_16); // $$$

  DFM_M5_60_1V_p8_16 = markerSet_m5_60a.oneV;
  dfm_register(DFM_M5_60_1V_p8_16); // $$

  DFM_M5_60_0V_p8_16 = markerSet_m5_60a.noV;
  dfm_register(DFM_M5_60_0V_p8_16); // $

  DFM_M5_60_F_p8_16  = markerSet_m5_60a.F;
  dfm_register(DFM_M5_60_F_p8_16); // $

#endif // #if (_drPROCESS == 6)



////////////////////
//M6 short wire markers
markerSet_m6_60 = drShortNarrowMetalMarker(METAL6BC, non_gate_dir, VIA6, VIA5,
					   min_len_range=[.160, .180), wid_r<=.044,	// up to 44
					   top_via_dist=.22, bot_via_dist=.22);
DFM_M6_60_2V_p20 = markerSet_m6_60.twoV;
DFM_M6_60_1V_p20 = markerSet_m6_60.oneV;
DFM_M6_60_0V_p20 = markerSet_m6_60.noV;
DFM_M6_60_F_p20  = markerSet_m6_60.F;

markerSet_m6_60_2 = drShortNarrowMetalMarker(METAL6BC, non_gate_dir, VIA6, VIA5,
					   min_len_range=[.160, .180), wid_r=(.044,.06],	// 44 to 60
					   top_via_dist=.212, bot_via_dist=.212);
DFM_M6_60_2V_p20 = DFM_M6_60_2V_p20 or markerSet_m6_60_2.twoV;
dfm_register(DFM_M6_60_2V_p20); // $$$$

DFM_M6_60_1V_p20 = DFM_M6_60_1V_p20 or markerSet_m6_60_2.oneV;
dfm_register(DFM_M6_60_1V_p20); // $$$

DFM_M6_60_0V_p20 = DFM_M6_60_0V_p20 or markerSet_m6_60_2.noV;
dfm_register(DFM_M6_60_0V_p20); // $$

DFM_M6_60_F_p20  = DFM_M6_60_F_p20  or markerSet_m6_60_2.F;
dfm_register(DFM_M6_60_F_p20); // $$


markerSet_m6_60a = drShortNarrowMetalMarker(METAL6BC, non_gate_dir, VIA6, VIA5,
					    min_len_range=[.180, .200), wid_r<=.044,	// up to 44
					    top_via_dist=.22, bot_via_dist=.22);
DFM_M6_60_2V_p20_40 = markerSet_m6_60a.twoV;
DFM_M6_60_1V_p20_40 = markerSet_m6_60a.oneV;
DFM_M6_60_0V_p20_40 = markerSet_m6_60a.noV;
DFM_M6_60_F_p20_40 = markerSet_m6_60a.F;


markerSet_m6_60a_2 = drShortNarrowMetalMarker(METAL6BC, non_gate_dir, VIA6, VIA5,
					    min_len_range=[.180, .200), wid_r=(.044,.06],	// 44 to 60
					    top_via_dist=.212, bot_via_dist=.212);
DFM_M6_60_2V_p20_40 = DFM_M6_60_2V_p20_40 or markerSet_m6_60a_2.twoV;
dfm_register(DFM_M6_60_2V_p20_40); // $$$

DFM_M6_60_1V_p20_40 = DFM_M6_60_1V_p20_40 or markerSet_m6_60a_2.oneV;
dfm_register(DFM_M6_60_1V_p20_40); // $$

DFM_M6_60_0V_p20_40 = DFM_M6_60_0V_p20_40 or markerSet_m6_60a_2.noV;
dfm_register(DFM_M6_60_0V_p20_40); // $

DFM_M6_60_F_p20_40 =  DFM_M6_60_F_p20_40 or markerSet_m6_60a_2.F;
dfm_register(DFM_M6_60_F_p20_40); // $



////////////////////
//M7 short wire markers
markerSet_m7_60 = drShortNarrowMetalMarker(METAL7BC, gate_dir, VIA7, VIA6,
					   min_len_range=[.204, .249), wid_r<=.084,
					   top_via_dist=.275, bot_via_dist=.279);
DFM_M7_60_2V_p45 = markerSet_m7_60.twoV;
dfm_register(DFM_M7_60_2V_p45); // $$$$

DFM_M7_60_1V_p45 = markerSet_m7_60.oneV;
dfm_register(DFM_M7_60_1V_p45); // $$$

DFM_M7_60_0V_p45 = markerSet_m7_60.noV;
dfm_register(DFM_M7_60_0V_p45); // $$

DFM_M7_60_F_p45  = markerSet_m7_60.F;
dfm_register(DFM_M7_60_F_p45); // $$


markerSet_m7_60a = drShortNarrowMetalMarker(METAL7BC, gate_dir, VIA7, VIA6,
					    min_len_range=[.249, .294), wid_r<=.084,
					   top_via_dist=.275, bot_via_dist=.279);
DFM_M7_60_2V_p45_90 = markerSet_m7_60a.twoV;
dfm_register(DFM_M7_60_2V_p45_90); // $$$

DFM_M7_60_1V_p45_90 = markerSet_m7_60a.oneV;
dfm_register(DFM_M7_60_1V_p45_90); // $$

DFM_M7_60_0V_p45_90 = markerSet_m7_60a.noV;
dfm_register(DFM_M7_60_0V_p45_90); // $

DFM_M7_60_F_p45_90  = markerSet_m7_60a.F;
dfm_register(DFM_M7_60_F_p45_90); // $




////////////////////
//M8 short wire markers
#if (_drPROCESS == 1)
  markerSet_m8_60 = drShortNarrowMetalMarker(METAL8BC, non_gate_dir, VIA8, VIA7,
					     min_len_range=[.210, .255), wid_r<=.126,
					     top_via_dist=.350, bot_via_dist=.313);
  DFM_M8_60_2V_p45 = markerSet_m8_60.twoV;
  dfm_register(DFM_M8_60_2V_p45); // $$$

  DFM_M8_60_1V_p45 = markerSet_m8_60.oneV;
  dfm_register(DFM_M8_60_1V_p45); // $$

  DFM_M8_60_0V_p45 = markerSet_m8_60.noV;
  dfm_register(DFM_M8_60_0V_p45); // $$

  DFM_M8_60_F_p45  = markerSet_m8_60.F;
  dfm_register(DFM_M8_60_F_p45); // $$


  markerSet_m8_60a = drShortNarrowMetalMarker(METAL8BC, non_gate_dir, VIA8, VIA7,
					      min_len_range=[.255, .300), wid_r<=.126,
					      top_via_dist=.350, bot_via_dist=.313);
  DFM_M8_60_2V_p45_90 = markerSet_m8_60a.twoV;
  dfm_register(DFM_M8_60_2V_p45_90); // $$

  DFM_M8_60_1V_p45_90 = markerSet_m8_60a.oneV;
  dfm_register(DFM_M8_60_1V_p45_90); // $

  DFM_M8_60_0V_p45_90 = markerSet_m8_60a.noV;
  dfm_register(DFM_M8_60_0V_p45_90); // $

  DFM_M8_60_F_p45_90  = markerSet_m8_60a.F;
  dfm_register(DFM_M8_60_F_p45_90); // $

#elif (_drPROCESS == 6)
  markerSet_m8_60 = drShortNarrowMetalMarker(METAL8BC, non_gate_dir, VIA8, VIA7,
					     min_len_range=[.210, .255), wid_r<=.120,
					     top_via_dist=.325, bot_via_dist=.313);
  DFM_M8_60_2V_p45 = markerSet_m8_60.twoV;
  dfm_register(DFM_M8_60_2V_p45); // $$$

  DFM_M8_60_1V_p45 = markerSet_m8_60.oneV;
  dfm_register(DFM_M8_60_1V_p45); // $$

  DFM_M8_60_0V_p45 = markerSet_m8_60.noV;
  dfm_register(DFM_M8_60_0V_p45); // $$

  DFM_M8_60_F_p45  = markerSet_m8_60.F;
  dfm_register(DFM_M8_60_F_p45); // $$


  markerSet_m8_60a = drShortNarrowMetalMarker(METAL8BC, non_gate_dir, VIA8, VIA7,
					      min_len_range=[.255, .300), wid_r<=.120,
					      top_via_dist=.325, bot_via_dist=.313);
  DFM_M8_60_2V_p45_90 = markerSet_m8_60a.twoV;
  dfm_register(DFM_M8_60_2V_p45_90); // $$

  DFM_M8_60_1V_p45_90 = markerSet_m8_60a.oneV;
  dfm_register(DFM_M8_60_1V_p45_90); // $

  DFM_M8_60_0V_p45_90 = markerSet_m8_60a.noV;
  dfm_register(DFM_M8_60_0V_p45_90); // $

  DFM_M8_60_F_p45_90  = markerSet_m8_60a.F;
  dfm_register(DFM_M8_60_F_p45_90); // $

#else
  markerSet_m8_60 = drShortNarrowMetalMarker(METAL8BC, non_gate_dir, VIA8, VIA7,
					     min_len_range=[.274, .297), wid_r<=.140,
					     top_via_dist=.380, bot_via_dist=.343);
  DFM_M8_60_2V_p23 = markerSet_m8_60.twoV;
  dfm_register(DFM_M8_60_2V_p23); // $$$

  DFM_M8_60_1V_p23 = markerSet_m8_60.oneV;
  dfm_register(DFM_M8_60_1V_p23); // $$

  DFM_M8_60_0V_p23 = markerSet_m8_60.noV;
  dfm_register(DFM_M8_60_0V_p23); // $$

  DFM_M8_60_F_p23  = markerSet_m8_60.F;
  dfm_register(DFM_M8_60_F_p23); // $$


  markerSet_m8_60a = drShortNarrowMetalMarker(METAL8BC, non_gate_dir, VIA8, VIA7,
					      min_len_range=[.297, .320), wid_r<=.140,
					      top_via_dist=.380, bot_via_dist=.343);
  DFM_M8_60_2V_p23_46 = markerSet_m8_60a.twoV;
  dfm_register(DFM_M8_60_2V_p23_46); // $$

  DFM_M8_60_1V_p23_46 = markerSet_m8_60a.oneV;
  dfm_register(DFM_M8_60_1V_p23_46); // $

  DFM_M8_60_0V_p23_46 = markerSet_m8_60a.noV;
  dfm_register(DFM_M8_60_0V_p23_46); // $

  DFM_M8_60_F_p23_46  = markerSet_m8_60a.F;
  dfm_register(DFM_M8_60_F_p23_46); // $

#endif // #if (_drPROCESS == 1)


#if (_drPROCESS == 6)
  ////////////////////
  //M9 short wire markers
  markerSet_m9_60 = drShortNarrowMetalMarker(METAL9BC, gate_dir, VIA9, VIA8,
					     min_len_range=[.210, .255), wid_r<=.124,
					     top_via_dist=.325, bot_via_dist=.329);
  DFM_M9_60_2V_p45 = markerSet_m9_60.twoV;
  dfm_register(DFM_M9_60_2V_p45); // $$$

  DFM_M9_60_1V_p45 = markerSet_m9_60.oneV;
  dfm_register(DFM_M9_60_1V_p45); // $$

  DFM_M9_60_0V_p45 = markerSet_m9_60.noV;
  dfm_register(DFM_M9_60_0V_p45); // $$

  DFM_M9_60_F_p45  = markerSet_m9_60.F;
  dfm_register(DFM_M9_60_F_p45); // $$


  markerSet_m9_60a = drShortNarrowMetalMarker(METAL9BC, gate_dir, VIA9, VIA8,
					      min_len_range=[.255, .300), wid_r<=.124,
					      top_via_dist=.325, bot_via_dist=.329);
  DFM_M9_60_2V_p45_90 = markerSet_m9_60a.twoV;
  dfm_register(DFM_M9_60_2V_p45_90); // $$

  DFM_M9_60_1V_p45_90 = markerSet_m9_60a.oneV;
  dfm_register(DFM_M9_60_1V_p45_90); // $

  DFM_M9_60_0V_p45_90 = markerSet_m9_60a.noV;
  dfm_register(DFM_M9_60_0V_p45_90); // $

  DFM_M9_60_F_p45_90  = markerSet_m9_60a.F;
  dfm_register(DFM_M9_60_F_p45_90); // $




  ////////////////////
  //M10 short wire markers
  markerSet_m10_60 = drShortNarrowMetalMarker(METAL10BC, non_gate_dir, VIA10, VIA9,
					     min_len_range=[.274, .297), wid_r<=.140,
					     top_via_dist=.413, bot_via_dist=.413);
  DFM_M10_60_2V_p45 = markerSet_m10_60.twoV;
  dfm_register(DFM_M10_60_2V_p45); // $$$

  DFM_M10_60_1V_p45 = markerSet_m10_60.oneV;
  dfm_register(DFM_M10_60_1V_p45); // $$

  DFM_M10_60_0V_p45 = markerSet_m10_60.noV;
  dfm_register(DFM_M10_60_0V_p45); // $$

  DFM_M10_60_F_p45  = markerSet_m10_60.F;
  dfm_register(DFM_M10_60_F_p45); // $$


  markerSet_m10_60a = drShortNarrowMetalMarker(METAL10BC, non_gate_dir, VIA10, VIA9,
					      min_len_range=[.297, .320), wid_r<=.140,
					      top_via_dist=.413, bot_via_dist=.413);
  DFM_M10_60_2V_p45_90 = markerSet_m10_60a.twoV;
  dfm_register(DFM_M10_60_2V_p45_90); // $$

  DFM_M10_60_1V_p45_90 = markerSet_m10_60a.oneV;
  dfm_register(DFM_M10_60_1V_p45_90); // $

  DFM_M10_60_0V_p45_90 = markerSet_m10_60a.noV;
  dfm_register(DFM_M10_60_0V_p45_90); // $

  DFM_M10_60_F_p45_90  = markerSet_m10_60a.F;
  dfm_register(DFM_M10_60_F_p45_90); // $




  ////////////////////
  //M11 short wire markers
  markerSet_m11_60 = drShortNarrowMetalMarker(METAL11BC, gate_dir, VIA11, VIA10,
					     min_len_range=[.274, .297), wid_r<=.140,
					     top_via_dist=.453, bot_via_dist=.413);
  DFM_M11_60_2V_p45 = markerSet_m11_60.twoV;
  dfm_register(DFM_M11_60_2V_p45); // $$$

  DFM_M11_60_1V_p45 = markerSet_m11_60.oneV;
  dfm_register(DFM_M11_60_1V_p45); // $$

  DFM_M11_60_0V_p45 = markerSet_m11_60.noV;
  dfm_register(DFM_M11_60_0V_p45); // $$

  DFM_M11_60_F_p45  = markerSet_m11_60.F;
  dfm_register(DFM_M11_60_F_p45); // $$


  markerSet_m11_60a = drShortNarrowMetalMarker(METAL11BC, gate_dir, VIA11, VIA10,
					      min_len_range=[.297, .320), wid_r<=.140,
					      top_via_dist=.453, bot_via_dist=.413);
  DFM_M11_60_2V_p45_90 = markerSet_m11_60a.twoV;
  dfm_register(DFM_M11_60_2V_p45_90); // $$

  DFM_M11_60_1V_p45_90 = markerSet_m11_60a.oneV;
  dfm_register(DFM_M11_60_1V_p45_90); // $

  DFM_M11_60_0V_p45_90 = markerSet_m11_60a.noV;
  dfm_register(DFM_M11_60_0V_p45_90); // $

  DFM_M11_60_F_p45_90  = markerSet_m11_60a.F;
  dfm_register(DFM_M11_60_F_p45_90); // $

#endif // #if (_drPROCESS == 6)

#endif //#ifndef P1273DX_DFM_MN_60_RS_

