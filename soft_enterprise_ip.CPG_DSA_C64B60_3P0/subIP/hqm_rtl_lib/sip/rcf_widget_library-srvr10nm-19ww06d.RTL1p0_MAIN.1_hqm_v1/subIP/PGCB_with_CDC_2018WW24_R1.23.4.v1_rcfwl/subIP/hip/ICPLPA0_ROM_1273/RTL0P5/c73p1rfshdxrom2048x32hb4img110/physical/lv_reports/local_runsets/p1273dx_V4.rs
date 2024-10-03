// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_V4.rs.rca 1.5 Mon Dec 17 12:02:02 2012 dgthakur Experimental $
//
// $Log: p1273dx_V4.rs.rca $
// 
//  Revision: 1.5 Mon Dec 17 12:02:02 2012 dgthakur
//  Added VN(241) exception - currently only for V2GY and V2GZ.
// 
//  Revision: 1.4 Thu Oct 18 14:12:43 2012 dgthakur
//  Adding new via type v4typeSX.
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



//*** p1273 V4 runset - Dipto Thakurta Started 06Jul11 *** 
#ifndef _P1273DX_V4_RS_
#define _P1273DX_V4_RS_
#include <p12723_metal_via_common.rs>



//Set via id and via dl (for error output)
#define vid 4
#define vidp 5
#define vndl 25

#define metalnp  metal5bc
#define vian     via4
#define metaln   metal4bc
#define vianm    via3
#define metalnm  metal3bc



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
vn(typeJX) = drViaSA2( vn(SA2), metalnp, VN(127), mnp(para_dir), VN(120), mnp(perp_dir), mnp(perp_dir));
vn(typeNX) = drViaSA2( vn(SA2), metalnp, VN(129), mnp(para_dir), VN(130), mnp(perp_dir), mnp(perp_dir));
vn(typeRX) = drViaSA2( vn(SA2), metalnp, VN(131), mnp(para_dir), VN(132), mnp(perp_dir), mnp(perp_dir));
vn(typeRY) = drViaSA2( vn(SA2), metalnp, VN(133), mnp(para_dir), VN(134), mnp(perp_dir), mnp(perp_dir));
vn(typeVX) = drViaSA2( vn(SA2), metalnp, VN(135), mnp(para_dir), VN(136), mnp(perp_dir), mnp(perp_dir));
vn(typeSX) = drViaSA2( vn(SA2), metalnp, VN(137), mnp(para_dir), VN(138), mnp(perp_dir), mnp(perp_dir));
vn(set2) = drOrLayers({ /*vn(typeCX),*/ vn(typeGX), vn(typeJX), vn(typeNX), vn(typeRX), 
  vn(typeRY), vn(typeSX), vn(typeVX) });

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
vn(241) = empty_layer();


//INCLUDE VIA CHECKS FOR B/C VIAS
#include <1273/p1273dx_MXBC_via_common.rs>


//Flag invalid vias
vn(valid) = drOrLayers({ vn(set1), vn(set2), vn(set3), vn(setNSA), vn(setT) }); 
drCopyToError_(xc(VN(ER2)), vian not vn(valid) );



//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 26, 0)
drPassthru( vian,    25, 0)
drPassthru( metaln,  22, 0)
drPassthru( vianm,   21, 0)



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


#endif //_P1273DX_V4_RS_
