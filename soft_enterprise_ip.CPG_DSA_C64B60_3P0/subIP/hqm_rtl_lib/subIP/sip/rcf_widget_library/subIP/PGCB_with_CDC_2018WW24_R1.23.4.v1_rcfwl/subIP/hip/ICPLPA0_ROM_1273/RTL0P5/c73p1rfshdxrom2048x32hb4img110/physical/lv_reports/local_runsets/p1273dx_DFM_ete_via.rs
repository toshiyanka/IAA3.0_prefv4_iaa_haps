// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DFM_ete_via.rs.rca 1.6 Wed Oct 30 13:37:07 2013 gmonroy Experimental $
//
// $Log: p1273dx_DFM_ete_via.rs.rca $
// 
//  Revision: 1.6 Wed Oct 30 13:37:07 2013 gmonroy
//  Refactored DFM code to allow future features
// 
//  Revision: 1.5 Fri Aug  9 19:15:56 2013 gmonroy
//  Added p1273.6 support
// 
//  Revision: 1.4 Tue Aug  6 12:36:25 2013 gmonroy
//  Fix M8_41 ETE distance for p1273.1
// 
//  Revision: 1.3 Tue Aug  6 12:04:10 2013 gmonroy
//  Fix M4_41 incorrect flagging due to copy and paste error and
//  fix M5_41 underflag due to redbook errata
// 
//  Revision: 1.2 Wed Jul  3 13:57:49 2013 gmonroy
//  Support 1273.1
// 
//  Revision: 1.1 Mon Mar 18 16:05:26 2013 gmonroy
//  1273-specific end-to-end DFM rules.
//

#ifndef P1273DX_DFM_ETE_VIA_RS_
#define P1273DX_DFM_ETE_VIA_RS_

#include <p12723_dfm_ete_via_function.rs>


////////////////////
//M0 ETE and Vias
markerSet_m0 = dr2VETE(METAL0BC, non_gate_dir, VIA0, VIACON,
		       metal_wid_r<=.048, dfm_2vete_enc=.024, dfm_2vete_cov=.032, ete_r<=.054,
		       iso_consider=true, trck_sp_r<=M0_21);
DFM_M0_41_2Viso = markerSet_m0.iso;
dfm_register(DFM_M0_41_2Viso); // $$$

DFM_M0_41_2V     = markerSet_m0.non_iso;
dfm_register(DFM_M0_41_2V); // $$



////////////////////
//M1 ETE and Vias
markerSet_m1 = dr2VETE(METAL1BC, gate_dir, VIA1, VIA0,
		       metal_wid_r<=.042, dfm_2vete_enc=.017, dfm_2vete_cov=.024, ete_r<=.042,
		       iso_consider=true, trck_sp_r<=M1_21);
DFM_M1_41_2Viso = markerSet_m1.iso;
dfm_register(DFM_M1_41_2Viso); // $$$

DFM_M1_41_2V     = markerSet_m1.non_iso;
dfm_register(DFM_M1_41_2V); // $$



////////////////////
//M2 ETE and Vias
markerSet_m2 = dr2VETE(METAL2BC, non_gate_dir, VIA2, VIA1,
		       metal_wid_r<=.046, dfm_2vete_enc=.019, dfm_2vete_cov=.034, ete_r<=.056,
		       iso_consider=true, trck_sp_r<=M2_21);
DFM_M2_41_2Viso = markerSet_m2.iso;
dfm_register(DFM_M2_41_2Viso); // $$$

DFM_M2_41_2V     = markerSet_m2.non_iso;
dfm_register(DFM_M2_41_2V); // $$



////////////////////
//M3 ETE and Vias
markerSet_m3 = dr2VETE(METAL3BC, gate_dir, VIA3, VIA2,
		       metal_wid_r<=.046, dfm_2vete_enc=.019, dfm_2vete_cov=.034, ete_r<=.056,
		       iso_consider=true, trck_sp_r<=M3_21);
DFM_M3_41_2Viso = markerSet_m3.iso;
dfm_register(DFM_M3_41_2Viso); // $$$

DFM_M3_41_2V     = markerSet_m3.non_iso;
dfm_register(DFM_M3_41_2V); // $$



////////////////////
//M4 ETE and Vias
#if (_drPROCESS == 6)
  markerSet_m4 = dr2VETE(METAL4BC, non_gate_dir, VIA4, VIA3,
			 metal_wid_r<=.046, dfm_2vete_enc=.022, dfm_2vete_cov=.034, ete_r<=.056,
			 iso_consider=true, trck_sp_r<=M4_21);
#else
  markerSet_m4 = dr2VETE(METAL4BC, non_gate_dir, VIA4, VIA3,
			 metal_wid_r<=.046, dfm_2vete_enc=.019, dfm_2vete_cov=.034, ete_r<=.056,
			 iso_consider=true, trck_sp_r<=M4_21);
#endif
DFM_M4_41_2Viso = markerSet_m4.iso;
dfm_register(DFM_M4_41_2Viso); // $$$

DFM_M4_41_2V     = markerSet_m4.non_iso;
dfm_register(DFM_M4_41_2V); // $$



////////////////////
//M5 ETE and Vias
#if (_drPROCESS == 6)

  markerSet_m5 = dr2VETE(METAL5BC, gate_dir, VIA5, VIA4,
			 metal_wid_r<=.044, dfm_2vete_enc=.040, dfm_2vete_cov=.040, ete_r<=.080);
  DFM_M5_41_2V = markerSet_m5.dont_care_iso;

  markerSet_m5a = dr2VETE(METAL5BC, gate_dir, VIA5, VIA4,
			 metal_wid_r=(.044,.06], dfm_2vete_enc=.032, dfm_2vete_cov=.032, ete_r<=.080);
  DFM_M5_41_2V = DFM_M5_41_2V or markerSet_m5a.dont_care_iso;
  dfm_register(DFM_M5_41_2V); // $$

#else

  markerSet_m5 = dr2VETE(METAL5BC, gate_dir, VIA5, VIA4,
			 metal_wid_r<=.046, dfm_2vete_enc=.022, dfm_2vete_cov=.034, ete_r<=.056,
			 iso_consider=true, trck_sp_r<=M5_21);
  DFM_M5_41_2Viso = markerSet_m5.iso;
  dfm_register(DFM_M5_41_2Viso); // $$$

  DFM_M5_41_2V     = markerSet_m5.non_iso;
  dfm_register(DFM_M5_41_2V); // $$

#endif


////////////////////
//M6 ETE and Vias
markerSet_m6 = dr2VETE(METAL6BC, non_gate_dir, VIA6, VIA5,
		       metal_wid_r<=.044, dfm_2vete_enc=.040, dfm_2vete_cov=.040, ete_r<=.080);
DFM_M6_41_2V = markerSet_m6.dont_care_iso;

markerSet_m6a = dr2VETE(METAL6BC, non_gate_dir, VIA6, VIA5,
		       metal_wid_r=(.044,.06], dfm_2vete_enc=.032, dfm_2vete_cov=.032, ete_r<=.080);
DFM_M6_41_2V = DFM_M6_41_2V or markerSet_m6a.dont_care_iso;
dfm_register(DFM_M6_41_2V); // $$


////////////////////
//M7 ETE and Vias
markerSet_m7 = dr2VETE(METAL7BC, gate_dir, VIA7, VIA6,
		       metal_wid_r<=.084, dfm_2vete_enc=.038, dfm_2vete_cov=.042, ete_r<=.090);
DFM_M7_41_2V = markerSet_m7.dont_care_iso;
dfm_register(DFM_M7_41_2V); // $$


////////////////////
//M8 ETE and Vias
#if (_drPROCESS == 1)
  markerSet_m8 = dr2VETE(METAL8BC, non_gate_dir, VIA8, VIA7,
			 metal_wid_r<=.126, dfm_2vete_enc=.080, dfm_2vete_cov=.043, ete_r<=.198);
#elif (_drPROCESS == 6)
  markerSet_m8 = dr2VETE(METAL8BC, non_gate_dir, VIA8, VIA7,
			 metal_wid_r<=.120, dfm_2vete_enc=.055, dfm_2vete_cov=.043, ete_r<=.120);
#else
  markerSet_m8 = dr2VETE(METAL8BC, non_gate_dir, VIA8, VIA7,
			 metal_wid_r<=.140, dfm_2vete_enc=.080, dfm_2vete_cov=.043, ete_r<=.198);
#endif
DFM_M8_41_2V = markerSet_m8.dont_care_iso;
dfm_register(DFM_M8_41_2V); // $



#if (_drPROCESS == 6)
  ////////////////////
  //M9 ETE and Vias
  markerSet_m9 = dr2VETE(METAL9BC, gate_dir, VIA9, VIA8,
			 metal_wid_r<=.124, dfm_2vete_enc=.055, dfm_2vete_cov=.059, ete_r<=.120);
  DFM_M9_41_2V = markerSet_m9.dont_care_iso;
  dfm_register(DFM_M9_41_2V); // $


  ////////////////////
  //M10 ETE and Vias
  markerSet_m10 = dr2VETE(METAL10BC, non_gate_dir, VIA10, VIA9,
			 metal_wid_r<=.140, dfm_2vete_enc=.055, dfm_2vete_cov=.055, ete_r<=.198);
  DFM_M10_41_2V = markerSet_m10.dont_care_iso;
  dfm_register(DFM_M10_41_2V); // $


  ////////////////////
  //M11 ETE and Vias
  markerSet_m11 = dr2VETE(METAL11BC, gate_dir, VIA11, VIA10,
			 metal_wid_r<=.140, dfm_2vete_enc=.095, dfm_2vete_cov=.055, ete_r<=.198);
  DFM_M11_41_2V = markerSet_m11.dont_care_iso;
  dfm_register(DFM_M11_41_2V); // $

#endif

#endif //#ifndef P1273DX_DFM_ETE_VIA_RS_
