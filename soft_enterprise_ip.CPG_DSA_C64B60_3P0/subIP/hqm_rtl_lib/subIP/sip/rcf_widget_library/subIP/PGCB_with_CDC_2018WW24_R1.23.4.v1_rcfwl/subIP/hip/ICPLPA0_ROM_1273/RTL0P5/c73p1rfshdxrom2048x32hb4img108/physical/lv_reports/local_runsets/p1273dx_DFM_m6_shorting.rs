// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DFM_m6_shorting.rs.rca 1.3 Wed Oct 30 13:37:07 2013 gmonroy Experimental $
//
// $Log: p1273dx_DFM_m6_shorting.rs.rca $
// 
//  Revision: 1.3 Wed Oct 30 13:37:07 2013 gmonroy
//  Refactored DFM code to allow future features
// 
//  Revision: 1.2 Fri Aug  9 19:21:06 2013 gmonroy
//  Added parameter in order to support 1273.6.  Added 1273.6 support
// 
//  Revision: 1.1 Mon Mar 18 16:06:30 2013 gmonroy
//  1273-specific Metal 6 shorting DFM rule
//

#ifndef _P1272DX_DFM_M6_SHORTING_RS_
#define _P1272DX_DFM_M6_SHORTING_RS_

#include <p12723_dfm_m4_shorting_function.rs>

////////////////////
// M6 shorting

// using 1272's M4 function because M4 corresponds to 1273's M6

#if (_drPROCESS == 6)
  DFM_M5_Tshort = drM4Shorting( METAL5BC, metal_dir=gate_dir,
				wide_cd_r=[.056,.068],
				search_box_x=.5, 
				search_box_y_ext=M5_26+M5_02+M5_21+drgrid,
				narrow_cd_r=[.040,.048], sp_nxt2_narrow_r=0.04,
				sp_narrow_wide<=M5_26,
				top_via=VIA5, bot_via=VIA4,
				ignore_float_m4=true);
  dfm_register(DFM_M5_Tshort); // $
#endif
DFM_M6_Tshort = drM4Shorting( METAL6BC, metal_dir=non_gate_dir,
			      wide_cd_r=[.056,.068],
			      search_box_x=.5, 
			      search_box_y_ext=M6_26+M6_02+M6_21+drgrid,
			      narrow_cd_r=[.040,.048], sp_nxt2_narrow_r=0.04,
			      sp_narrow_wide<=M6_26,
			      top_via=VIA6, bot_via=VIA5,
			      ignore_float_m4=true);
dfm_register(DFM_M6_Tshort); // $


#endif //#ifndef _P1272DX_DFM_M6_SHORTING_RS_
