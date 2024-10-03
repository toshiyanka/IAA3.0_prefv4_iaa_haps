// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DFM_BE.rs.rca 1.7 Wed Oct 30 13:37:07 2013 gmonroy Experimental $
//
// $Log: p1273dx_DFM_BE.rs.rca $
// 
//  Revision: 1.7 Wed Oct 30 13:37:07 2013 gmonroy
//  Refactored DFM code to allow future features
// 
//  Revision: 1.6 Fri Aug  9 19:15:56 2013 gmonroy
//  Added p1273.6 support
// 
//  Revision: 1.5 Wed Jul  3 13:57:49 2013 gmonroy
//  Support 1273.1
// 
//  Revision: 1.4 Wed Jul  3 11:50:21 2013 gmonroy
//  Fixed neighbor distance for DFM_M7_148
// 
//  Revision: 1.3 Wed Jul  3 11:23:54 2013 gmonroy
//  Improve legibility by moving addition of +1nm and +10nm to inside function
// 
//  Revision: 1.2 Mon Mar 18 15:52:02 2013 gmonroy
//  Put actual 1273 code on the placeholder, which still had 1272 code
// 
//  Revision: 1.1 Wed Feb 13 01:14:21 2013 dgthakur
//  Placeholder for 1273.4 BE DFM rules (for now copied over from 1272 area).
//


//Dipto Thakurta 2Feb13
//Will contain BE METAL DFM

#ifndef _P1273DX_DFM_BE_RS_
#define _P1273DX_DFM_BE_RS_

//Currently just need the narrow line ends
m0line_end_narrow  = adjacent_edge(metal0bc,  length <= 0.048, angle1=90, angle2=90);	
m1line_end_narrow  = adjacent_edge(metal1,    length <= 0.042, angle1=90, angle2=90);	
m2line_end_narrow  = adjacent_edge(metal2bc,  length <= 0.046, angle1=90, angle2=90);	
m3line_end_narrow  = adjacent_edge(metal3bc,  length <= 0.046, angle1=90, angle2=90);	
m4line_end_narrow  = adjacent_edge(metal4bc,  length <= 0.046, angle1=90, angle2=90);	
#if (_drPROCESS == 6)
  //m5 widths split in narrow1 and narrow2
  m5line_end_narrow1 = adjacent_edge(metal5bc,  length <= 0.044, angle1=90, angle2=90);	
  m5line_end_narrow2 = adjacent_edge(metal5bc,  length=(0.044,0.060], angle1=90, angle2=90);	
#else
  m5line_end_narrow  = adjacent_edge(metal5bc,	length <= 0.046, angle1=90, angle2=90);	
#endif
//m6 widths split in narrow1 and narrow2
m6line_end_narrow1  = adjacent_edge(metal6,   length <= 0.044, angle1=90, angle2=90);	
m6line_end_narrow2  = adjacent_edge(metal6,   length=(0.044,0.060], angle1=90, angle2=90);	
m7line_end_narrow   = adjacent_edge(metal7,   length <= 0.084, angle1=90, angle2=90);	
#if (_drPROCESS == 1)
  m8line_end_narrow  = adjacent_edge(metal8,	length <= 0.126, angle1=90, angle2=90);	
#elif (_drPROCESS == 6)
  m8line_end_narrow  = adjacent_edge(metal8,  length <= 0.120, angle1=90, angle2=90);	
  m9line_end_narrow  = adjacent_edge(metal9,  length <= 0.124, angle1=90, angle2=90);	
  m10line_end_narrow = adjacent_edge(metal10, length <= 0.140, angle1=90, angle2=90);	
  m11line_end_narrow = adjacent_edge(metal11, length <= 0.140, angle1=90, angle2=90);	
#else
  m8line_end_narrow  = adjacent_edge(metal8,  length <= 0.140, angle1=90, angle2=90);	
#endif



///////////////////////////////VIA COVERAGE AT LINE END////////////////////////////////////////////////////

DFM_VC_61p5	= drLineEndViaMarker_( VIACON, m0line_end_narrow,   <(VC_61+0.005) );
dfm_register(DFM_VC_61p5); // $

DFM_V0_62p5	= drLineEndViaMarker_( VIA0,   m1line_end_narrow,   <(V0_62+0.005) );
dfm_register(DFM_V0_62p5); // $$$

DFM_V1_61p5	= drLineEndViaMarker_( VIA1,   m2line_end_narrow,   <(V1_61+0.005) );
dfm_register(DFM_V1_61p5); // $$$

DFM_V2_61p5	= drLineEndViaMarker_( VIA2,   m3line_end_narrow,   <(V2_61+0.005) );
dfm_register(DFM_V2_61p5); // $$$

DFM_V3_61p5	= drLineEndViaMarker_( VIA3,   m4line_end_narrow,   <(V3_61+0.005) );
dfm_register(DFM_V3_61p5); // $$$

#if (_drPROCESS == 6)
  DFM_V4_61Np9	  = drLineEndViaMarker_( VIA4,   m5line_end_narrow1,  <(V4_61+0.009) );
  dfm_register(DFM_V4_61Np9); // $$$

  DFM_V4_61Np9_18 = drLineEndViaMarker_( VIA4,   m5line_end_narrow1,  [V4_61+0.009, V4_61+0.018) );
  dfm_register(DFM_V4_61Np9_18); // $$


  DFM_V4_61p5	  = drLineEndViaMarker_( VIA4,   m5line_end_narrow2,  <(V4_61+0.005) );
  dfm_register(DFM_V4_61p5); // $$$

  DFM_V4_61p5_10  = drLineEndViaMarker_( VIA4,   m5line_end_narrow2,  [V4_61+0.005, V4_61+0.010) );
  dfm_register(DFM_V4_61p5_10); // $$

#else
  DFM_V4_61p5	  = drLineEndViaMarker_( VIA4,   m5line_end_narrow,   <(V4_61+0.005) );
  dfm_register(DFM_V4_61p5); // $$$

#endif

DFM_V5_61Np9	= drLineEndViaMarker_( VIA5,   m6line_end_narrow1,  <(V5_61+0.009) );
dfm_register(DFM_V5_61Np9); // $$$

DFM_V5_61Np9_18	= drLineEndViaMarker_( VIA5,   m6line_end_narrow1,  [V5_61+0.009, V5_61+0.018) );
dfm_register(DFM_V5_61Np9_18); // $$


DFM_V5_61p5	= drLineEndViaMarker_( VIA5,   m6line_end_narrow2,  <(V5_61+0.005) );
dfm_register(DFM_V5_61p5); // $$$

DFM_V5_61p5_10	= drLineEndViaMarker_( VIA5,   m6line_end_narrow2,  [V5_61+0.005, V5_61+0.010) );
dfm_register(DFM_V5_61p5_10); // $$


DFM_V6_61p5	= drLineEndViaMarker_( VIA6,   m7line_end_narrow,   <(V6_61+0.005) );
dfm_register(DFM_V6_61p5); // $$$

DFM_V6_61p5_10	= drLineEndViaMarker_( VIA6,   m7line_end_narrow,   [V6_61+0.005, V6_61+0.010) );
dfm_register(DFM_V6_61p5_10); // $$


DFM_V7_61p8	= drLineEndViaMarker_( VIA7,   m8line_end_narrow,   <(V7_61+0.008) );
dfm_register(DFM_V7_61p8); // $$

DFM_V7_61p8_15	= drLineEndViaMarker_( VIA7,   m8line_end_narrow,   [V7_61+0.008, V7_61+0.015) );
dfm_register(DFM_V7_61p8_15); // $


#if (_drPROCESS == 6)
  DFM_V8_61p8	  = drLineEndViaMarker_( VIA8,   m9line_end_narrow,   <(V8_61+0.008) );
  dfm_register(DFM_V8_61p8); // $$

  DFM_V8_61p8_15  = drLineEndViaMarker_( VIA8,   m9line_end_narrow,   [V8_61+0.008, V8_61+0.015) );
  dfm_register(DFM_V8_61p8_15); // $


  DFM_V9_62p8	  = drLineEndViaMarker_( VIA9,   m10line_end_narrow,  <(V9_62+0.008) );
  dfm_register(DFM_V9_62p8); // $$

  DFM_V9_62p8_15  = drLineEndViaMarker_( VIA9,   m10line_end_narrow,  [V9_62+0.008, V9_62+0.015) );
  dfm_register(DFM_V9_62p8_15); // $


  DFM_V10_62p8	  = drLineEndViaMarker_( VIA10,  m11line_end_narrow,  <(V10_62+0.008) );
  dfm_register(DFM_V10_62p8); // $$

  DFM_V10_62p8_15 = drLineEndViaMarker_( VIA10,  m11line_end_narrow,  [V10_62+0.008, V10_62+0.015) );
  dfm_register(DFM_V10_62p8_15); // $

#endif


///////////////////////////////VIA LANDING AT LINE END////////////////////////////////////////////////////

DFM_V0_49p5	  = drLineEndViaMarker_( VIA0, m0line_end_narrow,   <(V0_49+0.005) );
dfm_register(DFM_V0_49p5); // $

DFM_V1_49p5       = drLineEndViaMarker_( VIA1, m1line_end_narrow,   <(V1_49+0.005) );
dfm_register(DFM_V1_49p5); // $$$

DFM_V2_49p5       = drLineEndViaMarker_( VIA2, m2line_end_narrow,   <(V2_49+0.005) );
dfm_register(DFM_V2_49p5); // $$$

DFM_V3_49p5       = drLineEndViaMarker_( VIA3, m3line_end_narrow,   <(V3_49+0.005) );
dfm_register(DFM_V3_49p5); // $$$

DFM_V4_49p5       = drLineEndViaMarker_( VIA4, m4line_end_narrow,   <(V4_49+0.005) );
dfm_register(DFM_V4_49p5); // $$$


#if (_drPROCESS == 6)
  DFM_V5_49Np14	    = drLineEndViaMarker_( VIA5, m5line_end_narrow1,  <(V5_49+0.014) );
  dfm_register(DFM_V5_49Np14); // $$$

  DFM_V5_49Np14_28  = drLineEndViaMarker_( VIA5, m5line_end_narrow1,  [V5_49+0.014, V5_49+0.028) );
  dfm_register(DFM_V5_49Np14_28); // $$


  DFM_V5_49p10      = drLineEndViaMarker_( VIA5, m5line_end_narrow2,  <(V5_49+0.010) );
  dfm_register(DFM_V5_49p10); // $$$

  DFM_V5_49p10_20   = drLineEndViaMarker_( VIA5, m5line_end_narrow2,  [V5_49+0.010, V5_49+0.020) );
  dfm_register(DFM_V5_49p10_20); // $$

#else
  DFM_V5_49p5     = drLineEndViaMarker_( VIA5, m5line_end_narrow,     <(V5_49+0.005) );
  dfm_register(DFM_V5_49p5); // $$$

#endif

DFM_V6_49Np12	  = drLineEndViaMarker_( VIA6, m6line_end_narrow1,  <(V6_49+0.012) );
dfm_register(DFM_V6_49Np12); // $$$

DFM_V6_49Np12_24  = drLineEndViaMarker_( VIA6, m6line_end_narrow1,  [V6_49+0.012, V6_49+0.024) );
dfm_register(DFM_V6_49Np12_24); // $$


DFM_V6_49p8       = drLineEndViaMarker_( VIA6, m6line_end_narrow2,  <(V6_49+0.008) );
dfm_register(DFM_V6_49p8); // $$$

DFM_V6_49p8_16    = drLineEndViaMarker_( VIA6, m6line_end_narrow2,  [V6_49+0.008, V6_49+0.016) );
dfm_register(DFM_V6_49p8_16); // $$


DFM_V7_49p5       = drLineEndViaMarker_( VIA7, m7line_end_narrow,   <(V7_49+0.005) );
dfm_register(DFM_V7_49p5); // $$$

DFM_V7_49p5_10    = drLineEndViaMarker_( VIA7, m7line_end_narrow,   [V7_49+0.005, V7_49+0.010) );
dfm_register(DFM_V7_49p5_10); // $$


#if (_drPROCESS == 6)
  DFM_V8_49p8	    = drLineEndViaMarker_( VIA8, m8line_end_narrow,   <(V8_49+0.008) );
  dfm_register(DFM_V8_49p8); // $$

  DFM_V8_49p8_15    = drLineEndViaMarker_( VIA8, m8line_end_narrow,   [V8_49+0.008, V8_49+0.015) );
  dfm_register(DFM_V8_49p8_15); // $


  DFM_V9_52p8       = drLineEndViaMarker_( VIA9, m9line_end_narrow,   <(V9_52+0.008) );
  dfm_register(DFM_V9_52p8); // $$

  DFM_V9_52p8_15    = drLineEndViaMarker_( VIA9, m9line_end_narrow,   [V9_52+0.008, V9_52+0.015) );
  dfm_register(DFM_V9_52p8_15); // $


  DFM_V10_52p8	    = drLineEndViaMarker_( VIA10, m10line_end_narrow, <(V10_52+0.008) );
  dfm_register(DFM_V10_52p8); // $$

  DFM_V10_52p8_15   = drLineEndViaMarker_( VIA10, m10line_end_narrow, [V10_52+0.008, V10_52+0.015) );
  dfm_register(DFM_V10_52p8_15); // $


  DFM_V11_52p8      = drLineEndViaMarker_( VIA11, m11line_end_narrow, <(V11_52+0.008) );
  dfm_register(DFM_V11_52p8); // $$

  DFM_V11_52p8_15   = drLineEndViaMarker_( VIA11, m11line_end_narrow, [V11_52+0.008, V11_52+0.015) );
  dfm_register(DFM_V11_52p8_15); // $

#endif


///////////////////////////////SHORT EXPOSED LINE END////////////////////////////////////////////////////

#if (_drPROCESS == 6)
  m5short_148 =	  rectangles( metal5,	{<0.200,<=0.060});
#endif
m6short_148 = rectangles( metal6,   {<0.200,<=0.060});
m7short_148 = rectangles( metal7,   {<0.300,<=0.060});
#if ( (_drPROCESS == 1) || (_drPROCESS == 6) )
  m8short_148 =	  rectangles( metal8,	{<0.300,<=0.080});
#else
  m8short_148 =	  rectangles( metal8,	{<0.320,<=0.126});
#endif
#if (_drPROCESS == 6)
  m9short_148 =	  rectangles( metal9,	{<0.300,<=0.080});
  m10short_148 =  rectangles( metal10,	{<0.320,<=0.126});
  m11short_148 =  rectangles( metal11, 	{<0.320,<=0.126});
#endif


#if (_drPROCESS == 6)
  m5line_end_narrow_148  =    adjacent_edge(m5short_148,  length <= 0.060, angle1=90, angle2=90);	
#endif
m6line_end_narrow_148  =    adjacent_edge(m6short_148,	length <= 0.060, angle1=90, angle2=90);	
m7line_end_narrow_148  =    adjacent_edge(m7short_148, 	length <= 0.060, angle1=90, angle2=90);	
#if ( (_drPROCESS == 1) || (_drPROCESS == 6) )
  m8line_end_narrow_148  =    adjacent_edge(m8short_148,  length <= 0.080, angle1=90, angle2=90);	
#else
  m8line_end_narrow_148  =    adjacent_edge(m8short_148,  length <= 0.126, angle1=90, angle2=90);	
#endif
#if (_drPROCESS == 6)
  m9line_end_narrow_148  =  adjacent_edge(m9short_148,	length <= 0.080, angle1=90, angle2=90);	
  m10line_end_narrow_148  = adjacent_edge(m10short_148, length <= 0.126, angle1=90, angle2=90);	
  m11line_end_narrow_148  = adjacent_edge(m11short_148, length <= 0.126, angle1=90, angle2=90);	
#endif


// TODO: remove hard wiring of neighbor distance below
#if (_drPROCESS == 6)
  drExposedLEMarker2_(metal5, m5line_end_narrow_148,	0.030, 0.056, non_gate_dir, 0.060, DFM_M5_148);
  dfm_register(DFM_M5_148); // $$$

#endif
drExposedLEMarker2_(metal6, m6line_end_narrow_148,    0.030, 0.056, gate_dir,	  0.060, DFM_M6_148);
dfm_register(DFM_M6_148); // $$$

drExposedLEMarker2_(metal7, m7line_end_narrow_148,    0.030, 0.080, non_gate_dir, 0.060, DFM_M7_148);
dfm_register(DFM_M7_148); // $$$

#if ( (_drPROCESS == 1) || (_drPROCESS == 6) )
  drExposedLEMarker2_(metal8, m8line_end_narrow_148,	0.030, 0.110, gate_dir,	    0.080, DFM_M8_148);
  dfm_register(DFM_M8_148); // $$$

#else
  drExposedLEMarker2_(metal8, m8line_end_narrow_148,	0.030, 0.126, gate_dir,	    0.126, DFM_M8_148);
  dfm_register(DFM_M8_148); // $$$

#endif
#if (_drPROCESS == 6)
  drExposedLEMarker2_(metal9, m9line_end_narrow_148,	0.030, 0.110, non_gate_dir, 0.060, DFM_M9_148);
  dfm_register(DFM_M9_148); // $$$

  drExposedLEMarker2_(metal10, m10line_end_narrow_148,  0.030, 0.126, gate_dir,	    0.060, DFM_M10_148);
  dfm_register(DFM_M10_148); // $$$

  drExposedLEMarker2_(metal11, m11line_end_narrow_148,  0.030, 0.126, non_gate_dir, 0.060, DFM_M11_148);
  dfm_register(DFM_M11_148); // $$$

#endif


///////////////////////////////EXPOSED LINE END////////////////////////////////////////////////////

#if (_drPROCESS == 6)
  m5line_end_narrow_exp	  = adjacent_edge(metal5,   length <= 0.060, angle1=90, angle2=90);	
#endif
m6line_end_narrow_exp  = adjacent_edge(metal6,   length <= 0.060, angle1=90, angle2=90);	
m7line_end_narrow_exp  = adjacent_edge(metal7,   length <= 0.060, angle1=90, angle2=90);	
#if ( (_drPROCESS == 1) || (_drPROCESS == 6) )
  m8line_end_narrow_exp	  = adjacent_edge(metal8,   length <= 0.080, angle1=90, angle2=90);	
#else
  m8line_end_narrow_exp	  = adjacent_edge(metal8,   length <= 0.126, angle1=90, angle2=90);	
#endif
#if (_drPROCESS == 6)
  m9line_end_narrow_exp	  = adjacent_edge(metal9,   length <= 0.080, angle1=90, angle2=90);	
  m10line_end_narrow_exp  = adjacent_edge(metal10,  length <= 0.126, angle1=90, angle2=90);	
  m11line_end_narrow_exp  = adjacent_edge(metal11,  length <= 0.126, angle1=90, angle2=90);	
#endif



#if (_drPROCESS == 6)
  drExposedLEMarker1_(metal5, m5line_end_narrow_exp,	0.030, 0.056, 0.080, 
		      non_gate_dir, gate_dir, DFM_M5_149_1, DFM_M5_149_2);
  dfm_register(DFM_M5_149_1); // $
  dfm_register(DFM_M5_149_2); // $$

#endif
drExposedLEMarker1_(metal6, m6line_end_narrow_exp,  0.030, 0.056, 0.080,
		    gate_dir, non_gate_dir, DFM_M6_149_1, DFM_M6_149_2);
dfm_register(DFM_M6_149_1); // $
dfm_register(DFM_M6_149_2); // $$

drExposedLEMarker1_(metal7, m7line_end_narrow_exp,  0.030, 0.080, 0.090,
		    non_gate_dir, gate_dir, DFM_M7_149_1, DFM_M7_149_2);
dfm_register(DFM_M7_149_1); // $
dfm_register(DFM_M7_149_2); // $$

#if ( (_drPROCESS == 1) || (_drPROCESS == 6) )
  drExposedLEMarker1_(metal8, m8line_end_narrow_exp,	0.030, 0.110, 0.120,
		      gate_dir, non_gate_dir, DFM_M8_149_1, DFM_M8_149_2);
  dfm_register(DFM_M8_149_1); // $
  dfm_register(DFM_M8_149_2); // $$

#else
  drExposedLEMarker1_(metal8, m8line_end_narrow_exp,	0.030, 0.126, 0.140,
		      gate_dir, non_gate_dir, DFM_M8_149_1, DFM_M8_149_2);
  dfm_register(DFM_M8_149_1); // $
  dfm_register(DFM_M8_149_2); // $$

#endif
#if (_drPROCESS == 6)
  drExposedLEMarker1_(metal9, m9line_end_narrow_exp,	0.030, 0.110, 0.120, 
		      non_gate_dir, gate_dir, DFM_M9_149_1, DFM_M9_149_2);
  dfm_register(DFM_M9_149_1); // $
  dfm_register(DFM_M9_149_2); // $$

  drExposedLEMarker1_(metal10, m10line_end_narrow_exp,  0.030, 0.126, 0.140, 
		      gate_dir, non_gate_dir, DFM_M10_149_1, DFM_M10_149_2);
  dfm_register(DFM_M10_149_1); // $
  dfm_register(DFM_M10_149_2); // $$

  drExposedLEMarker1_(metal11, m11line_end_narrow_exp,  0.030, 0.126, 0.140, 
		      non_gate_dir, gate_dir, DFM_M11_149_1, DFM_M11_149_2);
  dfm_register(DFM_M11_149_1); // $
  dfm_register(DFM_M11_149_2); // $$

#endif


#include <1273/p1273dx_DFM_mN_60.rs>     //for the short narrow lines
#include <1273/p1273dx_DFM_ete_via.rs>   //for the 2vias around metal ETE
#include <1273/p1273dx_DFM_m6_shorting.rs>  //for the M4 shorting


#endif
