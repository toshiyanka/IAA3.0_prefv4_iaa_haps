// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_V6.rs.rca 1.6 Fri Mar 29 01:05:17 2013 dgthakur Experimental $
//
// $Log: p1273dx_V6.rs.rca $
// 
//  Revision: 1.6 Fri Mar 29 01:05:17 2013 dgthakur
//  Certain vias for p1273.6 are not supported (email Moonsoo 28Mar13).
// 
//  Revision: 1.5 Thu Oct 18 15:37:13 2012 dgthakur
//  Added new via types v6typeCY, v6typeDX, v6typeEX.
// 
//  Revision: 1.4 Mon Mar  5 10:16:05 2012 dgthakur
//  Updated V6_41 for the new M6 wide lines.
// 
//  Revision: 1.3 Sat Nov 26 15:27:18 2011 dgthakur
//  Via cannot form bridge on landing metal - adding to V0_ER0 check for safety (bridge vias excluded from this check).
// 
//  Revision: 1.2 Wed Aug 17 22:36:26 2011 dgthakur
//  Updated connectivity to include Mn+1,Mn,Mn-1 for Vn to Vn-1 space checks.
// 
//  Revision: 1.1 Thu Aug 11 17:18:30 2011 dgthakur
//  First check in for 1273.
//



//*** p1273 V6 runset - Dipto Thakurta Started 16Jul11 *** 
#ifndef _P1273DX_V6_RS_
#define _P1273DX_V6_RS_
#include <p12723_metal_via_common.rs>



//Set via id and via dl (for error output)
#define vid 6
#define vidp 7
#define vndl 33

#define metalnp  metal7
#define vian     via6
#define metaln   metal6
#define vianm    via5
#define metalnm  metal5bc


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

//Bin the via types
vn(typeA) = drViaSA2( vn(SA2para), metalnp, VN(02), mnp(para_dir), VN(01), mnp(perp_dir), mnp(perp_dir));
vn(typeB) = drViaSA2( vn(SA2para), metalnp, VN(04), mnp(para_dir), VN(03), mnp(perp_dir), mnp(perp_dir));
vn(typeD) = drViaSA2( vn(SA2para), metalnp, VN(07), mnp(para_dir), VN(08), mnp(perp_dir), mnp(perp_dir));
vn(typeDX)= drViaSA2( vn(SA2para), metalnp, VN(107),mnp(para_dir), VN(108),mnp(perp_dir), mnp(perp_dir));
vn(typeE) = drViaSA2( vn(SA2para), metalnp, VN(09), mnp(para_dir), VN(10), mnp(perp_dir), mnp(perp_dir));
vn(typeEX)= drViaSA2( vn(SA2para), metalnp, VN(109),mnp(para_dir), VN(110), mnp(perp_dir), mnp(perp_dir));
vn(typeF) = drViaSA2( vn(SA2para), metalnp, VN(11), mnp(para_dir), VN(12), mnp(perp_dir), mnp(perp_dir));
vn(typeG) = drViaSA2( vn(SA2para), metalnp, VN(13), mnp(para_dir), VN(14), mnp(perp_dir), mnp(perp_dir));
vn(typeH) = drViaSA2( vn(SA2para), metalnp, VN(15), mnp(para_dir), VN(16), mnp(perp_dir), mnp(perp_dir));

//Type C, CX and CY can rotate
vn(typeCpara) = drViaSA2( vn(SA2para), metalnp, VN(05), mnp(para_dir), VN(06), mnp(perp_dir), mnp(perp_dir));
vn(typeCXpara)= drViaSA2( vn(SA2para), metalnp, VN(17), mnp(para_dir), VN(18), mnp(perp_dir), mnp(perp_dir));
vn(typeCYpara)= drViaSA2( vn(SA2para), metalnp, VN(117),mnp(para_dir),VN(118), mnp(perp_dir), mnp(perp_dir));

vn(typeCperp) = drViaSA2( vn(SA2perp), metalnp, VN(05), mnp(perp_dir), VN(06), mnp(para_dir), mnp(para_dir));
vn(typeCXperp)= drViaSA2( vn(SA2perp), metalnp, VN(17), mnp(perp_dir), VN(18), mnp(para_dir), mnp(para_dir));
vn(typeCYperp)= drViaSA2( vn(SA2perp), metalnp, VN(117),mnp(perp_dir), VN(118), mnp(para_dir), mnp(para_dir));

//Flag invalid vias
vn(valid) = drOrLayers({ vn(typeA), vn(typeB), vn(typeD), vn(typeDX), vn(typeE), vn(typeEX), vn(typeF), vn(typeG), vn(typeH),
  vn(typeCpara), vn(typeCXpara), vn(typeCYpara), vn(typeCperp), vn(typeCXperp), vn(typeCYperp)}); 
drCopyToError_(xc(VN(ER2)), vian not vn(valid) );


//For 1273.6 following vias are not supported
#if (_drPROCESS == 6)
drCopyToError_(xc(VN(ER2)),vn(typeCYpara) );
drCopyToError_(xc(VN(ER2)),vn(typeCYperp) );
drCopyToError_(xc(VN(ER2)),vn(typeDX) );
drCopyToError_(xc(VN(ER2)),vn(typeEX) );
#endif


//LANDING
///////////////////////////////////////////////////////////////////////////////////////

//VN(33)
vn(_mn_cdb) = connect (connect_items = {{ layers = {vian}, by_layer = metaln}});
drMinSpace2STConnect_(xc(VN(33)), vian, metaln, VN(33), vn(_mn_cdb), DIFFERENT_NET); 

//VN(40)
drMaxViaOverHang_(xc(VN(40)), vian, metaln, (VN(40), vn(max_width)], mnp(para_dir));
drMaxViaOverHang_(xc(VN(40)), vian, metaln, (VN(40), vn(max_width)], mnp(perp_dir));

//VN(240)/VN(48)
drCopyToError_(xc(VN(240)), vn(typeH) not_inside metaln); 

//VN(41) Via must be on centerline
// get the centerlines of metal bins
mn(para01_clp) = drShrinkDir(mn(para01), MN(01)/2 - drgrid, mn(perp_dir));
mn(para02_clp) = drShrinkDir(mn(para02), MN(02)/2 - drgrid, mn(perp_dir));  
mn(para03_clp) = drShrinkDir(mn(para03), MN(03)/2 - drgrid, mn(perp_dir));  
mn(para12_clp) = drShrinkDir(mn(para12), MN(12)/2 - drgrid, mn(perp_dir));  
mn(para04_clp) = drShrinkDir(mn(para04), MN(04)/2 - drgrid, mn(perp_dir));
mn(para05_clp) = drShrinkDir(mn(para05), MN(05)/2 - drgrid, mn(perp_dir));
mn(para06_clp) = drShrinkDir(mn(para06), MN(06)/2 - drgrid, mn(perp_dir));
mn(para07_clp) = drShrinkDir(mn(para07), MN(07)/2 - drgrid, mn(perp_dir));
mn(para08_clp) = drShrinkDir(mn(para08), MN(08)/2 - drgrid, mn(perp_dir));
mn(para09_clp) = drShrinkDir(mn(para09), MN(09)/2 - drgrid, mn(perp_dir));
mn(para10_clp) = drShrinkDir(mn(para10), MN(10)/2 - drgrid, mn(perp_dir));
mn(para11_clp) = drShrinkDir(mn(para11), MN(11)/2 - drgrid, mn(perp_dir));
//Add in the new wide lines
mn(para13_clp) = drShrinkDir(mn(para13), MN(13)/2 - drgrid, mn(perp_dir));
mn(para14_clp) = drShrinkDir(mn(para14), MN(14)/2 - drgrid, mn(perp_dir));
mn(para15_clp) = drShrinkDir(mn(para15), MN(15)/2 - drgrid, mn(perp_dir));
//
mn(clp_para) = drOrLayers({ 
  mn(para01_clp), mn(para02_clp), mn(para03_clp), mn(para12_clp),
  mn(para04_clp), mn(para05_clp), mn(para06_clp), mn(para07_clp),  
  mn(para08_clp), mn(para09_clp), mn(para10_clp), mn(para11_clp),
  mn(para13_clp), mn(para14_clp), mn(para15_clp)
  });
//
mn(clp_perp) = internal1(metaln, distance = MN(10), extension=NONE, direction = mn(para_dir),
  orientation = {PARALLEL}, intersecting = {}, output_type= CENTERLINE, width=2*drgrid);
//
mn(clp) = mn(clp_para) or mn(clp_perp);
//
vn(center) = polygon_centers(vian, 2*drgrid);
drCopyToError_(xc(VN(41)), interacting(vian, vn(center) not_inside mn(clp)) not vn(typeH) ); //typeH exception

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
vn(wv22) = drGetViaDoubletGap1( vn(typeA), vian, [VN(23), MNP(22)], mnp(perp_dir), VN(02), mnp(para_dir));
drViaCenterConnected_(xc(VN(22)), vn(typeA), vn(wv22), VN(22)); 

//Form the SA bridges
vn(SA_edge) = vian coincident_inside_edge metalnp;
vn(bridge_perp_temp) = drGetViaGap( vn(SA_edge), [VN(23), MNP(27)], mnp(perp_dir));
vn(bridge_para_temp) = drGetViaGap( vn(SA_edge), [MNP(35), MNP(35)], mnp(para_dir));
vn(bridge_perp) = vn(bridge_perp_temp) not_interacting vn(bridge_para_temp);
vn(bridge_para) = vn(bridge_para_temp) not_interacting vn(bridge_perp_temp);

//VN(28) SA edge - SA edge
drMinSpaceDir_(xc(VN(28)), vn(SA_edge), <VN(28), mnp(para_dir), vn(bridge_para));
drMinSpaceDir_(xc(VN(28)), vn(SA_edge), <VN(28), mnp(perp_dir), vn(bridge_perp));

//VN(24)
drViaCorner_( xc(VN(24)), vian, VN(24));

//VN(25) - global
drMinSpaceDir_(xc(VN(25)), vian, <VN(25), mnp(para_dir), vn(bridge_para));
drMinSpaceDir_(xc(VN(25)), vian, <VN(25), mnp(perp_dir), vn(bridge_perp));

//VN(27)
vn(C_se1) = length_edge( vn(typeCpara), VN(05));
vn(C_se2) = length_edge( vn(typeCperp), VN(05));
vn(CX_se1) = length_edge( vn(typeCXpara), VN(17));
vn(CX_se2) = length_edge( vn(typeCXperp), VN(17));
vn(CY_se1) = length_edge( vn(typeCYpara), VN(118));
vn(CY_se2) = length_edge( vn(typeCYperp), VN(118));
//
vn(D_se) = length_edge( vn(typeD), VN(07));
vn(DX_se)= length_edge( vn(typeDX), VN(107));
vn(E_se) = length_edge( vn(typeE), VN(09));
vn(EX_se)= length_edge( vn(typeEX), VN(109));
vn(F_se) = length_edge( vn(typeF), VN(11));
vn(G_se) = length_edge( vn(typeG), VN(13));
vn(H_se) = length_edge( vn(typeH), VN(15));
//
vn(_se) = drOrEdges({ vn(C_se1), vn(C_se2), vn(CX_se1), vn(CX_se2), vn(CY_se1), vn(CY_se2),
  vn(D_se), vn(DX_se), vn(E_se), vn(EX_se), vn(F_se), vn(G_se), vn(H_se) });
//
drMinSpaceDir_(xc(VN(27)), vn(_se), <VN(27), mnp(para_dir), vn(bridge_para));
drMinSpaceDir_(xc(VN(27)), vn(_se), <VN(27), mnp(perp_dir), vn(bridge_perp));

//VN(29/30)
drCornerPGDOffset2_( xc(VN(30)), vian, vian, VN(30), VN(29));
drCornerOGDOffset2_( xc(VN(30)), vian, vian, VN(30), VN(29));

//VN(31/32)
vn(cdb_space) = connect (connect_items = {
{ layers = {metalnp, metaln}, by_layer = vian},
{ layers = {metaln, metalnm}, by_layer = vianm}
});
drViaViaEdgeConnected_(xc(VN(31)), vian, vianm, vn(cdb_space), VN(31));
drViaViaCornerConnected_(xc(VN(32)), vian, vianm, vn(cdb_space), VN(32));



//COVERAGE
///////////////////////////////////////////////////////////////////////////////////////

//VN(51) implicit - not coded

//VN(54) 
drMetalConcaveCornerViaSpace_(xc(VN(54)), vian, metalnp, VN(54)); 

//VN(55) not needed as all vias are SA

//VN(61)
drLineEndEnclosure_( xc(VN(61)), vian, mnp(_line_end), VN(61), drunit);



//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 34, 0)
drPassthru( vian,    33, 0)
drPassthru( metaln,  30, 0)
drPassthru( vianm,   29, 0)

/*
drPassthru( vn(wv22),   	 33, 9022)
drPassthru( vn(bridge_perp), 33, 9023)
drPassthru( vn(bridge_para), 33, 3024)
drPassthru( mn(clp_para), 3000, 3027)
drPassthru( mn(clp_perp), 3000, 3028)
drPassthru( mn(Bad), 3000, 3029)
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


#endif //_P1273DX_V6_RS_






