// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_V2.rs.rca 1.10 Wed Dec  3 00:39:02 2014 dgthakur Experimental $
//
// $Log: p1273dx_V2.rs.rca $
// 
//  Revision: 1.10 Wed Dec  3 00:39:02 2014 dgthakur
//  Allow special V2 size for fuse cell (Zhanping email 11/25/14).
// 
//  Revision: 1.9 Tue Oct 21 22:34:08 2014 dgthakur
//  Added special via sizes for x73fuse (Zhanping email 20Oct2014).
// 
//  Revision: 1.8 Fri Mar 29 01:05:17 2013 dgthakur
//  Certain vias for p1273.6 are not supported (email Moonsoo 28Mar13).
// 
//  Revision: 1.7 Mon Dec 17 12:02:02 2012 dgthakur
//  Added VN(241) exception - currently only for V2GY and V2GZ.
// 
//  Revision: 1.6 Thu Dec 13 15:44:37 2012 dgthakur
//  Added two new via types via2GY and via2GZ.
// 
//  Revision: 1.5 Mon Mar 12 12:00:43 2012 dgthakur
//  Added new V2typePW.
// 
//  Revision: 1.4 Wed Feb 29 11:54:23 2012 dgthakur
//  Inter-changing v2/3 typeNX <-> typeVX (to sync with via tables).  Should not impact design.
// 
//  Revision: 1.3 Fri Jan 13 14:51:19 2012 dgthakur
//  Added type C via2/3/4 and removed type CX via2/3/4.
// 
//  Revision: 1.2 Thu Jul 21 15:35:02 2011 dgthakur
//  Added #undef for metalnp (just to be safe).
// 
//  Revision: 1.1 Wed Jul 20 16:59:43 2011 dgthakur
//  First checkin for 1273 via layers.
//



//*** p1273 V2 runset - Dipto Thakurta Started 06Jul11 *** 
#ifndef _P1273DX_V2_RS_
#define _P1273DX_V2_RS_
#include <p12723_metal_via_common.rs>



//Set via id and via dl (for error output)
#define vid 2
#define vidp 3
#define vndl 17

#define metalnp  metal3bc
#define vian     via2
#define metaln   metal2bc
#define vianm    via1
#define metalnm  metal1



//VIA SIZE CHECKS
///////////////////////////////////////////////////////////////////////////////////////

//Separate out SA and NSA
vn(inside) = vian inside metalnp;                           //via inside upper metal
vn(NSA) = inside( vian, metalnp, POINT);                    //No sides SA
vn(SA1) = touching( vn(inside), mnp(para_edge), count=1);   //1 side SA
vn(SA2) = touching( vn(inside), mnp(para_edge), count=2);   //2 side SA 

//Bin the via types
vn(typeA) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(02), mnp(perp_dir), mnp(perp_dir));
vn(typeB) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(03), mnp(perp_dir), mnp(perp_dir));
vn(typeC) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(19), mnp(perp_dir), mnp(perp_dir));
vn(typeD) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(04), mnp(perp_dir), mnp(perp_dir));
vn(typeF) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(05), mnp(perp_dir), mnp(perp_dir));
vn(typeG) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(06), mnp(perp_dir), mnp(perp_dir));
vn(typeJ) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(08), mnp(perp_dir), mnp(perp_dir));
vn(typeR) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(09), mnp(perp_dir), mnp(perp_dir));
vn(typeV) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(10), mnp(perp_dir), mnp(perp_dir));
vn(typeL) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(11), mnp(perp_dir), mnp(perp_dir));
vn(typeN) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(12), mnp(perp_dir), mnp(perp_dir));
vn(typeS) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(13), mnp(perp_dir), mnp(perp_dir));
vn(typeO) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(14), mnp(perp_dir), mnp(perp_dir));
vn(set1) = drOrLayers({ vn(typeA), vn(typeB), vn(typeC), vn(typeD), vn(typeF), vn(typeG), vn(typeJ), 
  vn(typeR), vn(typeV), vn(typeL), vn(typeN), vn(typeS), vn(typeO) });

//vn(typeCX) = drViaSA2( vn(SA2), metalnp, VN(121), mnp(para_dir), VN(122), mnp(perp_dir), mnp(perp_dir));
vn(typeGX) = drViaSA2( vn(SA2), metalnp, VN(123), mnp(para_dir), VN(124), mnp(perp_dir), mnp(perp_dir));
vn(typeGY) = drViaSA2( vn(SA2), metalnp, VN(116), mnp(para_dir), VN(117), mnp(perp_dir), mnp(perp_dir));
vn(typeGZ) = drViaSA2( vn(SA2), metalnp, VN(118), mnp(para_dir), VN(119), mnp(perp_dir), mnp(perp_dir));
vn(typeJX) = drViaSA2( vn(SA2), metalnp, VN(127), mnp(para_dir), VN(120), mnp(perp_dir), mnp(perp_dir));
vn(typeVX) = drViaSA2( vn(SA2), metalnp, VN(129), mnp(para_dir), VN(130), mnp(perp_dir), mnp(perp_dir));
vn(typeRX) = drViaSA2( vn(SA2), metalnp, VN(131), mnp(para_dir), VN(132), mnp(perp_dir), mnp(perp_dir));
vn(typeRY) = drViaSA2( vn(SA2), metalnp, VN(133), mnp(para_dir), VN(134), mnp(perp_dir), mnp(perp_dir));
vn(typeNX) = drViaSA2( vn(SA2), metalnp, VN(135), mnp(para_dir), VN(136), mnp(perp_dir), mnp(perp_dir));
vn(typePW) = drViaSA2( vn(SA2), metalnp, VN(137), mnp(para_dir), VN(138), mnp(perp_dir), mnp(perp_dir));
vn(set2) = drOrLayers({ /*vn(typeCX),*/ vn(typeGX), vn(typeGY), vn(typeGZ), vn(typeJX), vn(typeNX), 
  vn(typeRX), vn(typeRY), vn(typeVX), vn(typePW) });


//ADD IN SPECIAL SIZED V2 FOR X73FUSE 
#if ( vid ==2 )
vn(fuse_cells) = copy_by_cells(VIA2, cells = {
"x73p00fcary1ne_security_m3_lv",
"x73p00fcary1ne_ref_m4f2_36nm",
"x73p00fcary1ne_ref_m4f2_nw_36nm",
"x73p00fcary1ne_ref_m4f2_36nm_dot6_replica",
"x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_replica",
"x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew2",
"x73p00fcary1ne_ref_m4f2_36nm_dot6_skew2",
"x73p00fcary1ne_ref_m4f2_36nm_dot6_skew3",
"x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew3",
"x73p00fcary1ne_ref_fuse2",
"x73p00fcary1ne_ref_fuse2_nw",
"x73p00fcary1ne_m4f2_r_36nm",
"x73p00fcary1ne_m4f2_36nm",
"x73p00fcary1ne_m4f2_nw_r_36nm",
"x73p00fcary1ne_m4f2_nw_36nm",
"x73p00fcary1ne_m4f2_r_36nm_dot6_replica",
"x73p00fcary1ne_m4f2_36nm_dot6_replica",
"x73p00fcary1ne_m4f2_nw_r_36nm_dot6_replica",
"x73p00fcary1ne_m4f2_nw_36nm_dot6_replica",
"x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew2",
"x73p00fcary1ne_m4f2_nw_36nm_dot6_skew2",
"x73p00fcary1ne_m4f2_r_36nm_dot6_skew2",
"x73p00fcary1ne_m4f2_36nm_dot6_skew2",
"x73p00fcary1ne_m4f2_r_36nm_dot6_skew3",
"x73p00fcary1ne_m4f2_36nm_dot6_skew3",
"x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew3",
"x73p00fcary1ne_m4f2_nw_36nm_dot6_skew3",
"x73p00fcary1ne_fuse2_r",
"x73p00fcary1ne_fuse2",
"x73p00fcary1ne_fuse2_nw_r",
"x73p00fcary1ne_fuse2_nw",

//Adding more cells Zhanping email WW48 2014 
"x73p00fcary1ne_ref_m4f2_nw",
"x73p00fcary1ne_m4f2_nw_r",
"x73p00fcary1ne_m4f2_nw",
"x73p00fcary1col_8row_m4f2_uv2n_fix1_nw",
"x73p00fcary1ne_ref_m4f2",
"x73p00fcary1ne_m4f2_fix1_nw",
"x73p00fcary1ne_m4f2",
"x73p00fcary1ne_m4f2_r",
"x73p00fcary1ne_m4f2_fix1"

}, depth = CELL_LEVEL);

vn(SA2_f) = vn(SA2) interacting vn(fuse_cells);

vn(typeF1) = drViaSA2( vn(SA2_f), metalnp, 0.068, mnp(para_dir), 0.028, mnp(perp_dir), mnp(perp_dir));
vn(typeF2) = drViaSA2( vn(SA2_f), metalnp, 0.068, mnp(para_dir), 0.032, mnp(perp_dir), mnp(perp_dir));
vn(typeF3) = drViaSA2( vn(SA2_f), metalnp, 0.068, mnp(para_dir), 0.036, mnp(perp_dir), mnp(perp_dir));
vn(typeF4) = drViaSA2( vn(SA2_f), metalnp, 0.068, mnp(para_dir), 0.040, mnp(perp_dir), mnp(perp_dir));
vn(typeF5) = drViaSA2( vn(SA2_f), metalnp, 0.056, mnp(para_dir), 0.036, mnp(perp_dir), mnp(perp_dir));
vn(typeF6) = drViaSA2( vn(SA2_f), metalnp, 0.056, mnp(para_dir), 0.028, mnp(perp_dir), mnp(perp_dir));

vn(fuse) = drOrLayers({ vn(typeF1), vn(typeF2), vn(typeF3), vn(typeF4), vn(typeF5), vn(typeF6)});
vn(set2) = vn(set2) or vn(fuse);
#endif


vn(typeHA) = drViaNSA( vn(SA1), metalnp, VNH(01), mnp(para_dir), VNH(02), mnp(perp_dir));
vn(typeHG) = drViaNSA( vn(SA1), metalnp, VNH(03), mnp(para_dir), VNH(04), mnp(perp_dir));
vn(typeHK) = drViaNSA( vn(SA1), metalnp, VNH(05), mnp(para_dir), VNH(06), mnp(perp_dir));
vn(typeHM) = drViaNSA( vn(SA1), metalnp, VNH(07), mnp(para_dir), VNH(08), mnp(perp_dir));
vn(set3) = drOrLayers({ vn(typeHA), vn(typeHG), vn(typeHK), vn(typeHM) });

vn(typeHD) = drViaNSA( vn(NSA), metalnp, VNH(11), mnp(para_dir), VNH(12), mnp(perp_dir));
vn(typeHJ) = drViaNSA( vn(NSA), metalnp, VNH(13), mnp(para_dir), VNH(14), mnp(perp_dir));
vn(typeHL) = drViaNSA( vn(NSA), metalnp, VNH(15), mnp(para_dir), VNH(16), mnp(perp_dir));
vn(setNSA) = drOrLayers({ vn(typeHD), vn(typeHJ), vn(typeHL) });

vn(typeTA) = drViaSA2( vn(SA2), metalnp, VNT(01), mnp(para_dir), VNT(02), mnp(perp_dir), mnp(perp_dir));
vn(typeTB) = drViaSA2( vn(SA2), metalnp, VNT(03), mnp(para_dir), VNT(04), mnp(perp_dir), mnp(perp_dir));
vn(typeTC) = drViaSA2( vn(SA2), metalnp, VNT(05), mnp(para_dir), VNT(06), mnp(perp_dir), mnp(perp_dir));
vn(setT) = drOrLayers({ vn(typeTA), vn(typeTB), vn(typeTC) });


//Vias subject to VN(241) centerline landing exception
vn(241) = drOrLayers({ vn(typeGY), vn(typeGZ) });


//INCLUDE VIA CHECKS FOR B/C VIAS
#include <1273/p1273dx_MXBC_via_common.rs>


//Flag invalid vias
vn(valid) = drOrLayers({ vn(set1), vn(set2), vn(set3), vn(setNSA), vn(setT) }); 
drCopyToError_(xc(VN(ER2)), vian not vn(valid) );


//For 1273.6 following vias are not supported
#if (_drPROCESS == 6)
drCopyToError_(xc(VN(ER2)),vn(typeGY) );
drCopyToError_(xc(VN(ER2)),vn(typeGZ) );
#endif


//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 18, 0)
drPassthru( vian,    17, 0)
drPassthru( metaln,  14, 0)
drPassthru( vianm,   13, 0)



//UNDEFINE LOCAL DEFINES TO BE SAFE
///////////////////////////////////////////////////////////////////////////////////////

#undef vid 
#undef vidp
#undef vndl

#undef metalnp 
#undef vian    
#undef metaln  
#undef vianm   
#undef metalnm


#endif //_P1273DX_V2_RS_
