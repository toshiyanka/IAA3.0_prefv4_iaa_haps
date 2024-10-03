// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d1_V7.rs.rca 1.8 Tue Dec 10 17:53:19 2013 nhkhan1 Experimental $
//
// $Log: p1273d1_V7.rs.rca $
// 
//  Revision: 1.8 Tue Dec 10 17:53:19 2013 nhkhan1
//  added V7_401/402
// 
//  Revision: 1.7 Wed Nov  6 17:57:51 2013 nhkhan1
//  fixed vn(typeCSP), it should be aligned to PGD M8
// 
//  Revision: 1.6 Mon Nov  4 13:12:13 2013 nhkhan1
//  added new via size (Via7CSP) and related checks (only for x73b project)
// 
//  Revision: 1.5 Fri Oct 11 16:44:35 2013 nhkhan1
//  increased the SA merge range max for V7_128 to 0.205 ( as per Dipto's email 10Oct2013)
// 
//  Revision: 1.4 Wed Sep 11 12:02:14 2013 nhkhan1
//  changed the upper bound for merged-bridges for V7_28/128 checks
// 
//  Revision: 1.3 Thu Jun 20 16:18:50 2013 nhkhan1
//  added the missing via size (Via7HS)
// 
//  Revision: 1.2 Thu May 23 11:58:03 2013 nhkhan1
//  first time check-in for 1273.1
//  Copied from 1273.6 (Revision 1.2)


#ifndef _P1273D1_V7_RS_
#define _P1273D1_V7_RS_
#include <p12723_metal_via_common.rs>


//Set via id and via dl (for error output)
#define vid 7
#define vidp 8
#define vndl 37

#define metalnp  metal8
#define vian     via7
#define metaln   metal7
#define vianm    via6
#define metalnm  metal6


//SOME CUSTOM ERROR DEFINITIONS
///////////////////////////////////////////////////////////////////////////////////////

drErrGDSHash[xc(VN(ER0))] = {vndl,1200} ;
drHash[xc(VN(ER0))] = xc(vian must land on metaln);
drValHash[xc(VN(ER0))] = 0;

drErrGDSHash[xc(VN(ER1))] = {vndl,1201} ;
drHash[xc(VN(ER1))] = xc(vian must be completely inside metalnp);
drValHash[xc(VN(ER1))] = 0;

drErrGDSHash[xc(VN(ER2))] = {vndl,1202} ;
drHash[xc(VN(ER2))] = xc(vian size/shape or orientation or self-alignment is incorrect);
drValHash[xc(VN(ER2))] = 0;

drErrGDSHash[xc(VN(ER4))] = {vndl,1204} ;
drHash[xc(VN(ER4))] = xc(vian global min space);
drValHash[xc(VN(ER4))] = VN(23);


/************************************************
Via7CSP-related rules (only alloqwed for x73b project
*************************************************/

drErrGDSHash[xc(VN(220))] = {vndl,1220} ;
drHash[xc(VN(220))] = xc(Via7CSP length PGD fixed value);
drValHash[xc(VN(220))] = 0.074;
VN(220) : double = 0.074;

drErrGDSHash[xc(VN(221))] = {vndl,1221} ;
drHash[xc(VN(221))] = xc(Via7CSP length OGD fixed value);
drValHash[xc(VN(221))] = 0.120;
VN(221) : double = 0.120;

drErrGDSHash[xc(VN(224))] = {vndl,1224} ;
drHash[xc(VN(224))] = xc(Via7CSP corner to corner space self or any other via);
drValHash[xc(VN(224))] = 0.176;
VN(224) : double = 0.176;

drErrGDSHash[xc(VN(254))] = {vndl,1254} ;
drHash[xc(VN(254))] = xc(Metal8 concave corner space to Via7CSP);
drValHash[xc(VN(254))] = 0.160;
VN(254) : double = 0.160;


//GROSS LANDING AND COVERAGE CHECKS
///////////////////////////////////////////////////////////////////////////////////////

drViaLandingGrossCheck_(  xc(VN(ER0)), vian, metaln);
drViaLandingBridgeCheck_( xc(VN(ER0)), vian, metaln);
drViaCoverageGrossCheck_( xc(VN(ER1)), vian, metalnp);


//VIA SIZE CHECKS
///////////////////////////////////////////////////////////////////////////////////////

//Separate out SA and NSA
// No perp aligned 
vn(inside) = vian inside metalnp;                               //via inside upper metal
vn(SA2para) = touching( vn(inside), mnp(para_edge), count=2);   //2 side SA with mnp para edges 
vn(SA1para) = touching( vn(inside), mnp(para_edge), count=1);   //1 side SA with mnp para edges 
vn(SA2perp) = touching( vn(inside), mnp(perp_edge), count=2);   //2 side SA with mnp perp edges
vn(NSA) = inside(vian, metalnp, include_touch = POINT);

//Bin the via types
vn(typeAS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(02), mnp(perp_dir), mnp(perp_dir));
vn(typeCS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(03), mnp(perp_dir), mnp(perp_dir));
vn(typeDS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(04), mnp(perp_dir), mnp(perp_dir));
vn(typeES) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(05), mnp(perp_dir), mnp(perp_dir));
vn(typeGS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(06), mnp(perp_dir), mnp(perp_dir));
vn(typeM)  = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(07), mnp(perp_dir), mnp(perp_dir));
vn(typeN)  = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(08), mnp(perp_dir), mnp(perp_dir));
vn(typeP)  = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(09), mnp(perp_dir), mnp(perp_dir));
vn(typeHS)  = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(10), mnp(perp_dir), mnp(perp_dir));

vn(typeQ)  = drViaSA2( vn(SA2para), metalnp, VN(101), mnp(para_dir), VN(102), mnp(perp_dir), mnp(perp_dir));
vn(typeR)  = drViaSA2( vn(SA2para), metalnp, VN(103), mnp(para_dir), VN(104), mnp(perp_dir), mnp(perp_dir));
vn(typeS)  = drViaSA2( vn(SA2para), metalnp, VN(105), mnp(para_dir), VN(106), mnp(perp_dir), mnp(perp_dir));
vn(typeT)  = drViaSA2( vn(SA2para), metalnp, VN(107), mnp(para_dir), VN(108), mnp(perp_dir), mnp(perp_dir));
vn(typeU)  = drViaSA2( vn(SA2para), metalnp, VN(109), mnp(para_dir), VN(110), mnp(perp_dir), mnp(perp_dir));
vn(typeZS) = drViaSA2( vn(SA2para), metalnp, VN(111), mnp(para_dir), VN(112), mnp(perp_dir), mnp(perp_dir));

#if (_drPROJECT == _drx73b)
vn(typeCSP) = drViaSA2( vn(SA2perp), metalnp, VN(221), mnp(para_dir), VN(220), mnp(perp_dir), mnp(para_dir));
#else
vn(typeCSP) = g_empty_layer;
#endif

//SA1 Via
vn(typeZT) = drViaNSA( vn(SA1para), metalnp, VN(121), mnp(para_dir), VN(122), mnp(perp_dir));

//NSA Via
vn(typeHA) = drViaNSA( vn(NSA), metalnp, VN(131), mnp(para_dir), VN(132), mnp(perp_dir));

//Flag invalid vias
vn(valid) = drOrLayers({ vn(typeAS), vn(typeCS), vn(typeDS), vn(typeES), vn(typeGS), vn(typeM), vn(typeN),
                            vn(typeP), vn(typeHS), vn(typeQ),  vn(typeR),  vn(typeS),  vn(typeT),  vn(typeU), vn(typeZS),
							vn(typeZT), vn(typeHA), vn(typeCSP) });

drCopyToError_(xc(VN(ER2)), vian not vn(valid) );


//LANDING
///////////////////////////////////////////////////////////////////////////////////////

//VN(33)
vn(_mn_cdb) = connect (connect_items = {{ layers = {vian}, by_layer = metaln}});
drMinSpace2STConnect_(xc(VN(33)), vian, metaln, VN(33), vn(_mn_cdb), DIFFERENT_NET); 


//VN(40)
drMaxViaOverHang_(xc(VN(40)), vian, metaln, (VN(40), vn(max_width)], mnp(para_dir));
drMaxViaOverHang_(xc(VN(40)), vian, metaln, (VN(40), vn(max_width)], mnp(perp_dir));

//VN(401)
drCopyToError_( xc(VN(401)), size( vn(typeZT), VN(401)) not metaln);

//VN(402)
drCopyToError_( xc(VN(402)), size( vn(typeHA), VN(402)) not metaln);

drPassthru( vn(typeZT), 308, 142);
drPassthru( vn(typeHA), 308, 143);

//VN(41) Via must be on centerline
// get the centerlines of metal bins
// para direction
mn(para01_clp) = drShrinkDir(mn(para01), MN(01)/2 - drgrid, mn(perp_dir));
mn(para02_clp) = drShrinkDir(mn(para02), MN(02)/2 - drgrid, mn(perp_dir));  
mn(para03_clp) = drShrinkDir(mn(para03), MN(03)/2 - drgrid, mn(perp_dir));  
mn(para04_clp) = drShrinkDir(mn(para04), MN(04)/2 - drgrid, mn(perp_dir));
mn(para05_clp) = drShrinkDir(mn(para05), MN(05)/2 - drgrid, mn(perp_dir));
mn(para06_clp) = drShrinkDir(mn(para06), MN(06)/2 - drgrid, mn(perp_dir));
mn(para07_clp) = drShrinkDir(mn(para07), MN(07)/2 - drgrid, mn(perp_dir));

mn(clp_para) = drOrLayers({ mn(para01_clp), mn(para02_clp), mn(para03_clp), mn(para04_clp),
                            mn(para05_clp), mn(para06_clp), mn(para07_clp) });

//perp direction
mn(clp_perp) = internal1(metaln, distance = MN(03),  extension=NONE, direction = mn(para_dir),
  orientation = {PARALLEL}, intersecting = {}, output_type= CENTERLINE, width=2*drgrid);

mn(clp) = mn(clp_para) or mn(clp_perp);

// via centers
vn(center) = polygon_centers(vian, 2*drgrid);
drCopyToError_(xc(VN(41)), interacting(vian, vn(center) not_inside mn(clp)) ); 

//VN(49) 
vn(_on_clp_para) = vian interacting (vn(center) inside mn(clp_para));   
vn(_on_clp_perp) = vian interacting (vn(center) inside mn(clp_perp));   
//
drLineEndEnclosure_( xc(VN(49)), vian, mn(_line_end), VN(49), drunit);  //all vias must meet 90-90 line end enc
drLineEndEnclosure_( xc(VN(49)), vn(_on_clp_para), mn(para_ends), VN(49), drunit); //At L/T/jog shapes
drLineEndEnclosure_( xc(VN(49)), vn(_on_clp_perp), mn(perp_ends), VN(49), drunit); //At L/T/jog shapes 


//SPACING CHECKS
///////////////////////////////////////////////////////////////////////////////////////

//Global vn() min space check
drMinSpace_(xc(VN(ER4)), vian, VN(23));   


//VN(22) (waive VN(23))
vn(wv22) = drGetViaDoubletGap1( vn(typeAS), vian, [VN(23), MNP(22)], mnp(perp_dir), VN(01), mnp(para_dir));
drViaCenterConnected_(xc(VN(22)), vn(typeAS), vn(wv22), VN(22)); 


//Form the SA bridges
vn(SA_edge) = vian coincident_inside_edge metalnp;
vn(bridge_perp_temp) = drGetViaGap( vn(SA_edge), [VN(23), 0.205], mnp(perp_dir));
vn(bridge_para_temp) = drGetViaGap( vn(SA_edge), [MNP(35), VN(28)), mnp(para_dir));
vn(bridge_perp) = vn(bridge_perp_temp) not_interacting vn(bridge_para_temp);
vn(bridge_para) = vn(bridge_para_temp) not_interacting vn(bridge_perp_temp);


drPassthru( vn(bridge_perp), 308, 1240);
drPassthru( vn(bridge_para), 308, 1241);


//VN(28) - global causes error
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(para_dir), vn(bridge_para));
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(perp_dir), vn(bridge_perp));


//VN(128) - SA-SA and SA-others
drMinSpaceDir2STCB_(xc(VN(128)), vn(SA_edge), vian, <VN(128), mnp(para_dir), waiver = vn(bridge_para));
drMinSpaceDir2STCB_(xc(VN(128)), vn(SA_edge), vian, <VN(128), mnp(perp_dir), waiver = vn(bridge_perp));


//VN(24)
drViaCorner_( xc(VN(24)), vian, VN(24));

/************************************************
Via7CSP-related rules (only alloqwed for x73b project
*************************************************/
//VN(224)
drViaCorner_( xc(VN(224)), vn(typeCSP), VN(224));
drViaViaCorner_( xc(VN(224)), vn(typeCSP), vian not vn(typeCSP), VN(224));
//VN(224)
drMetalConcaveCornerViaSpace_(xc(VN(254)), vn(typeCSP), metalnp, VN(254));


//VN(32)
vn(cdb_space) = connect (connect_items = {
	{ layers = {metalnp, metaln}, by_layer = vian},
	{ layers = {metaln, metalnm}, by_layer = vianm}
});
drMinSpace2STConnect_(xc(VN(32)), vian, vianm, VN(32), vn(cdb_space), DIFFERENT_NET);


//VN(29/30)
drCornerPGDOffset2_( xc(VN(30)), vian, vian, VN(30), VN(29));
drCornerOGDOffset2_( xc(VN(30)), vian, vian, VN(30), VN(29));


//COVERAGE
///////////////////////////////////////////////////////////////////////////////////////

//VN(51) implicit - not coded
drMetalConcaveCornerViaSpace_(xc(VN(54)), vian, metalnp, VN(54)); 
drLineEndEnclosure_( xc(VN(61)), vian, mnp(_line_end), VN(61), drunit);

//VN(60)
vn(typeHA_os) = drGrowDir(vn(typeHA), VN(60), mnp(perp_dir));
drCopyToError_(xc(VN(60)), vn(typeHA_os) not metalnp);

//VN(63)
vn(cand_60_1) = drWidth(metalnp, ==MNP(10), mnp(perp_dir));
vn(cand_60_2) = drWidth(metalnp, ==MNP(11), mnp(perp_dir));
drCopyToError_(xc(VN(63)), not_interacting (vn(typeZT) , vn(cand_60_1) or vn(cand_60_2)));


//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 38, 0)
drPassthru( vian,    37, 0)
drPassthru( metaln,  34, 0)
drPassthru( vianm,   33, 0)



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


#endif //_P1273D1_V7_RS_






