// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_V7.rs.rca 1.8 Thu Jun 19 10:16:52 2014 dgthakur Experimental $
//
// $Log: p1273dx_V7.rs.rca $
// 
//  Revision: 1.8 Thu Jun 19 10:16:52 2014 dgthakur
//  hsd 2448; V7 merging in m8 perp direction relaxed (from 140->164). Obtained Ok from litho Sadanand email 6/18/14.
// 
//  Revision: 1.7 Thu Dec 13 16:04:13 2012 dgthakur
//  Removing v7typeFperp (only typeFpara is allowed now, i.e. type F cannot rotate anymore).
// 
//  Revision: 1.6 Thu May  3 15:22:48 2012 ngeorge3
//  Changes to ensure SA edges of via types C, D, E, if exist, are not selected before doing space checks.
// 
//  Revision: 1.5 Thu May  3 09:56:49 2012 ngeorge3
//  Changes made to allow 2SA for via type C, D and E.
// 
//  Revision: 1.4 Sat Nov 26 15:27:17 2011 dgthakur
//  Via cannot form bridge on landing metal - adding to V0_ER0 check for safety (bridge vias excluded from this check).
// 
//  Revision: 1.3 Thu Oct 13 17:38:41 2011 dgthakur
//  Temporary hack to remove V7_39 redundant via check.  Will have to clean up code later to remove all related redundant via code parts.
// 
//  Revision: 1.2 Wed Aug 17 22:36:26 2011 dgthakur
//  Updated connectivity to include Mn+1,Mn,Mn-1 for Vn to Vn-1 space checks.
// 
//  Revision: 1.1 Thu Aug 11 17:18:30 2011 dgthakur
//  First check in for 1273.
//



//*** p1273 V7 runset - Dipto Thakurta Started 25Jul11 *** 
#ifndef _P1273DX_V7_RS_
#define _P1273DX_V7_RS_
#include <p12723_metal_via_common.rs>

//temporary for redundant via - take red via out of code later
V7_39=0.160;


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



//GROSS LANDING AND COVERAGE CHECKS
///////////////////////////////////////////////////////////////////////////////////////

drViaLandingGrossCheck_(  xc(VN(ER0)), vian, metaln);
drViaLandingBridgeCheck_( xc(VN(ER0)), vian, metaln);
drViaCoverageGrossCheck_( xc(VN(ER1)), vian, metalnp);



//VIA SIZE CHECKS
///////////////////////////////////////////////////////////////////////////////////////

//Separate out SA and NSA
vn(inside) = vian inside metalnp;                               //via inside upper metal
vn(SA2para) = touching( vn(inside), mnp(para_edge), count=2);   //2 side SA with mnp para edges 
vn(SA2perp) = touching( vn(inside), mnp(perp_edge), count=2);   //2 side SA with mnp perp edges 
//
vn(NSA) = inside( vian, metalnp, POINT);                        //No sides SA
vn(SA1para) = touching( vn(inside), mnp(para_edge), count=1);   //1 side SA
vn(SA1perp) = touching( vn(inside), mnp(perp_edge), count=1);   //1 side SA
vn(SA12_NSA) = drOrLayers({ vn(NSA), vn(SA1para), vn(SA1perp), vn(SA2para) });//SA1 or NSA or SA2para

//Bin the via types
vn(typeA) = drViaSA2( vn(SA2para), metalnp, VN(02), mnp(para_dir), VN(01), mnp(perp_dir), mnp(perp_dir));
vn(typeB) = drViaSA2( vn(SA2para), metalnp, VN(04), mnp(para_dir), VN(03), mnp(perp_dir), mnp(perp_dir));
vn(typeF) = drViaSA2( vn(SA2para), metalnp, VN(06), mnp(para_dir), VN(05), mnp(perp_dir), mnp(perp_dir));
vn(setABF) = drOrLayers({ vn(typeA), vn(typeB), vn(typeF) });

vn(typeC) = rectangles(vn(SA12_NSA), {VN(11), VN(12)});
vn(typeD) = rectangles(vn(SA12_NSA), {VN(13), VN(14)});
vn(typeE) = rectangles(vn(SA12_NSA), {VN(16), VN(17)});
vn(setCDE) = drOrLayers({ vn(typeC), vn(typeD), vn(typeE) });

//Flag invalid vias
vn(valid) = drOrLayers({ vn(setABF), vn(setCDE) });
drCopyToError_(xc(VN(ER2)), vian not vn(valid) );



//LANDING
///////////////////////////////////////////////////////////////////////////////////////

//VN(33)
vn(_mn_cdb) = connect (connect_items = {{ layers = {vian}, by_layer = metaln}});
drMinSpace2STConnect_(xc(VN(33)), vian, metaln, VN(33), vn(_mn_cdb), DIFFERENT_NET); 

//VN(40)
drMaxViaOverHang_(xc(VN(40)), vian, metaln, (VN(40), vn(max_width)], mnp(para_dir));
drMaxViaOverHang_(xc(VN(40)), vian, metaln, (VN(40), vn(max_width)], mnp(perp_dir));

//VN(41) Via must be on centerline
// get the centerlines of metal bins
mn(para01_clp) = drShrinkDir(mn(para01), MN(01)/2 - drgrid, mn(perp_dir));
mn(para02_clp) = drShrinkDir(mn(para02), MN(02)/2 - drgrid, mn(perp_dir));  
mn(para03_clp) = drShrinkDir(mn(para03), MN(03)/2 - drgrid, mn(perp_dir));  
mn(para04_clp) = drShrinkDir(mn(para04), MN(04)/2 - drgrid, mn(perp_dir));
mn(para05_clp) = drShrinkDir(mn(para05), MN(05)/2 - drgrid, mn(perp_dir));
mn(para06_clp) = drShrinkDir(mn(para06), MN(06)/2 - drgrid, mn(perp_dir));
mn(para07_clp) = drShrinkDir(mn(para07), MN(07)/2 - drgrid, mn(perp_dir));
mn(clp_para) = drOrLayers({ mn(para01_clp), mn(para02_clp), mn(para03_clp),
  mn(para04_clp), mn(para05_clp), mn(para06_clp), mn(para07_clp) });
//
mn(clp_perp) = internal1(metaln, distance = MN(03),  extension=NONE, direction = mn(para_dir),
  orientation = {PARALLEL}, intersecting = {}, output_type= CENTERLINE, width=2*drgrid);
//
mn(clp) = mn(clp_para) or mn(clp_perp);
//
vn(center) = polygon_centers(vian, 2*drgrid);
drCopyToError_(xc(VN(41)), interacting(vian, vn(center) not_inside mn(clp)));

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
vn(wv22) = drGetViaDoubletGap1( vn(typeA), vian, [VN(23), VN(23)], mnp(perp_dir), VN(02), mnp(para_dir));
drViaCenterConnected_(xc(VN(22)), vn(typeA), vn(wv22), VN(22)); 

//Form the SA bridges
vn(SA_edge) = (vian not vn(setCDE)) coincident_inside_edge metalnp;
vn(bridge_perp_temp) = drGetViaGap( vn(SA_edge), [VN(23), 0.164], mnp(perp_dir)); //relaxed from M8_24->164
vn(bridge_para_temp) = drGetViaGap( vn(SA_edge), [MNP(35), MNP(35)], mnp(para_dir));
vn(bridge_perp) = vn(bridge_perp_temp) not_interacting vn(bridge_para_temp);
vn(bridge_para) = vn(bridge_para_temp) not_interacting vn(bridge_perp_temp);

//Form the redundant via bridges at distance VN(39)
vn(bridge_CC_perp) = drRedundantViaBridge1(metaln, metalnp, vn(typeC), vian, VN(39), mnp(perp_dir), VN(11), mnp(para_dir));
vn(bridge_DD_perp) = drRedundantViaBridge1(metaln, metalnp, vn(typeD), vian, VN(39), mnp(perp_dir), VN(14), mnp(para_dir));
vn(bridge_EE_perp) = drRedundantViaBridge1(metaln, metalnp, vn(typeE), vian, VN(39), mnp(perp_dir), VN(16), mnp(para_dir));
vn(bridge_red_perp) = drOrLayers( {vn(bridge_CC_perp), vn(bridge_DD_perp), vn(bridge_EE_perp) });

//VN(28) - global
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(para_dir), vn(bridge_para));
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(perp_dir), vn(bridge_perp));

//VN(128) - SA-SA and SA-others
drMinSpaceDir2STCB_(xc(VN(128)), vn(SA_edge), vian, <VN(128), mnp(para_dir), waiver = vn(bridge_para));
drMinSpaceDir2STCB_(xc(VN(128)), vn(SA_edge), vian, <VN(128), mnp(perp_dir), waiver = vn(bridge_perp));

//VN(24)
drViaCorner_( xc(VN(24)), vian, VN(24));

//VN(32)
vn(cdb_space) = connect (connect_items = {
{ layers = {metalnp, metaln}, by_layer = vian},
{ layers = {metaln, metalnm}, by_layer = vianm}
});
drMinSpace2STConnect_(xc(VN(32)), vian, vianm, VN(32), vn(cdb_space), DIFFERENT_NET);

//VN(29/30) TBD
//drCornerPGDOffset2_( xc(VN(30)), vian, vian, VN(30), VN(29));
//drCornerOGDOffset2_( xc(VN(30)), vian, vian, VN(30), VN(29));

//VN(39)/VN(42) upto triplet allowed
//drCopyToError_(xc(VN(39)), (vian or vn(bridge_red_perp)) interacting [count >3] vian); 



//COVERAGE
///////////////////////////////////////////////////////////////////////////////////////

//VN(51) implicit - not coded
drMetalConcaveCornerViaSpace_(xc(VN(54)), vn(setABF), metalnp, VN(54)); 
drLineEndEnclosure_( xc(VN(61)), vn(setABF), mnp(_line_end), VN(61), drunit);
drViaCoverage_(xc(VN(53)), vn(setCDE), metalnp, VN(52), VN(53));



//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 38, 0)
drPassthru( vian,    37, 0)
drPassthru( metaln,  34, 0)
drPassthru( vianm,   33, 0)
/*
drPassthru(vn(bridge_CC_perp),    371, 1)
drPassthru(vn(bridge_DD_perp),    371, 2)
drPassthru(vn(bridge_EE_perp),    371, 3)
*/



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


#endif //_P1273DX_V7_RS_


