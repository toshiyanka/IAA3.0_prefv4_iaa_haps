// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_MX80pitch52via.rs.rca 1.4 Fri Jul 25 13:22:13 2014 ngeorge3 Experimental $
//
// $Log: p1273dx_MX80pitch52via.rs.rca $
// 
//  Revision: 1.4 Fri Jul 25 13:22:13 2014 ngeorge3
//  Unroll to v1.2.
// 
//  Revision: 1.3 Thu Jul 24 19:12:50 2014 ngeorge3
//  Bug fix for M4_42. Fixes HSD 2526.
// 
//  Revision: 1.2 Thu Jul 24 00:48:25 2014 dgthakur
//  Bug fix in V5_42 (1273.4) and V4_42 in 1273.6.  Will see new flags on this via landing rule.
// 
//  Revision: 1.1 Wed Aug 22 10:53:12 2012 dgthakur
//  Code for via dropping from 80 pitch metal to 52 pitch (B/C) type metal.  Code is direction independent.
//


//DIRECTION INDEPENDENT CODE FOR VIA DROPPING FROM 
//80 PITCH METAL AND LANDING ON 52 PITCH B/C TYPE METAL.

//Copy from original 1273 V5.
//*** p1273 V5 runset - Dipto Thakurta Started 15Jul11 *** 



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
vn(inside) = vian inside metalnp;                           //via inside upper metal
vn(NSA) = inside( vian, metalnp, POINT);                    //No sides SA
//vn(SA1) = touching( vn(inside), mnp(para_edge), count=1); //1 side SA
vn(SA2) = touching( vn(inside), mnp(para_edge), count=2);   //2 side SA 

//Bin the via types
vn(typeA) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(02), mnp(perp_dir), mnp(perp_dir));
vn(typeB) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(03), mnp(perp_dir), mnp(perp_dir));
vn(typeD) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(06), mnp(perp_dir), mnp(perp_dir));
vn(typeFA)= drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(09), mnp(perp_dir), mnp(perp_dir));
vn(typeN) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(10), mnp(perp_dir), mnp(perp_dir));
vn(typeO) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(11), mnp(perp_dir), mnp(perp_dir));
vn(typeQ) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(12), mnp(perp_dir), mnp(perp_dir));
vn(typeR) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(13), mnp(perp_dir), mnp(perp_dir));
vn(typeM) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(14), mnp(perp_dir), mnp(perp_dir));
vn(typeT) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(15), mnp(perp_dir), mnp(perp_dir));
vn(typeC) = drViaSA2( vn(SA2), metalnp, VN(01), mnp(para_dir), VN(16), mnp(perp_dir), mnp(perp_dir));
vn(set1)  = drOrLayers({ vn(typeA), vn(typeB), vn(typeD), vn(typeFA), vn(typeN), vn(typeO), 
  vn(typeQ), vn(typeR), vn(typeM), vn(typeT), vn(typeC) });

vn(typeBP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(162), mnp(perp_dir), mnp(perp_dir));
vn(typeNP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(163), mnp(perp_dir), mnp(perp_dir));
vn(typeOP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(164), mnp(perp_dir), mnp(perp_dir));
vn(typeDP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(165), mnp(perp_dir), mnp(perp_dir));
vn(typeEP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(166), mnp(perp_dir), mnp(perp_dir));
vn(typeTP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(167), mnp(perp_dir), mnp(perp_dir));
vn(typeQP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(168), mnp(perp_dir), mnp(perp_dir));
vn(typeCP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(169), mnp(perp_dir), mnp(perp_dir));
vn(typeRP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(170), mnp(perp_dir), mnp(perp_dir));
vn(typeMP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(171), mnp(perp_dir), mnp(perp_dir));
vn(typeGP)= drViaSA2( vn(SA2), metalnp, VN(161), mnp(para_dir), VN(172), mnp(perp_dir), mnp(perp_dir));
vn(set2)  = drOrLayers({ vn(typeBP), vn(typeNP), vn(typeOP), vn(typeDP), vn(typeEP), vn(typeTP), 
  vn(typeQP), vn(typeCP), vn(typeRP), vn(typeMP), vn(typeGP) });

vn(typeS) = drViaSA2( vn(SA2), metalnp, VN(101), mnp(para_dir), VN(102), mnp(perp_dir), mnp(perp_dir));
vn(typeU) = drViaSA2( vn(SA2), metalnp, VN(103), mnp(para_dir), VN(104), mnp(perp_dir), mnp(perp_dir));
vn(typeV) = drViaSA2( vn(SA2), metalnp, VN(105), mnp(para_dir), VN(106), mnp(perp_dir), mnp(perp_dir));
vn(typeW) = drViaSA2( vn(SA2), metalnp, VN(107), mnp(para_dir), VN(108), mnp(perp_dir), mnp(perp_dir));
vn(typeX) = drViaSA2( vn(SA2), metalnp, VN(109), mnp(para_dir), VN(110), mnp(perp_dir), mnp(perp_dir));
vn(typeY) = drViaSA2( vn(SA2), metalnp, VN(111), mnp(para_dir), VN(112), mnp(perp_dir), mnp(perp_dir));
vn(typeZ) = drViaSA2( vn(SA2), metalnp, VN(113), mnp(para_dir), VN(114), mnp(perp_dir), mnp(perp_dir));
vn(typeFP)= drViaSA2( vn(SA2), metalnp, VN(115), mnp(para_dir), VN(116), mnp(perp_dir), mnp(perp_dir));
vn(typeHP)= drViaSA2( vn(SA2), metalnp, VN(117), mnp(para_dir), VN(118), mnp(perp_dir), mnp(perp_dir));
vn(typeYZ) = drViaNSA( vn(NSA), metalnp, VN(181), mnp(para_dir), VN(182), mnp(perp_dir));
vn(set3)  = drOrLayers({ vn(typeS), vn(typeU), vn(typeV), vn(typeW), vn(typeX), vn(typeY), 
  vn(typeZ), vn(typeFP), vn(typeHP), vn(typeYZ) });

//Flag invalid vias
vn(valid) = drOrLayers({ vn(set1), vn(set2), vn(set3) }); 
drCopyToError_(xc(VN(ER2)), vian not vn(valid) );



//LANDING
///////////////////////////////////////////////////////////////////////////////////////

//VN(33) - no connect needed as metaln is unidirectional
drMinSpace2ST_(xc(VN(33)), vian, metaln, VN(33));

//VN(40)
vn(perp_edge) = angle_edge_dir(vian, mnp(para_dir));
drMaxOverHang_(xc(VN(40)), vn(perp_edge), metaln, <=VN(40), mnp(para_dir));

//VN(240)
vn(_240_check) = (vian not vn(set1))  not (vn(set2) not vn(typeMP));
vn(_240_ERR) = vn(_240_check) not_inside metaln;  //ERROR bin
drCopyToError_(xc(VN(240)), vn(_240_ERR)); 

//VN(41) - centered on lower metal
err @= {
  @ GetRuleString(xc(VN(41))); note(CheckingString(xc(VN(41))));
  vn(temp) = copy(vian);
  mn(temp) = metaln interacting vn(temp);
  mn(cline) = drCenterline( mn(temp), mn(max_width), mnp(perp_dir), drgrid);
  vn(cline) = drCenterline( vn(temp), mnp(max_width), mnp(perp_dir), drgrid);
  vn(cline) not mn(cline);
}
drPushErrorStack(err, xc(VN(41)));


//VN(42) V5typeYZ cannot land on mn width <76 nm  (was coded to <74; should have been <76)

mn(L07_lt) = drWidth( metaln, <0.076, mn(perp_dir) );
drCopyToError_(xc(VN(42)), vn(typeYZ) interacting mn(L07_lt) );


//OLD CODE
//VN(42) V5typeYZ cannot land on mn width <74nm
//mn(L07_lt) = drWidth( metaln, <MNL(07), mn(perp_dir) );
//drCopyToError_(xc(VN(42)), vn(typeYZ) interacting mn(L07_lt) );



//VN(52)
err @= {
  @ GetRuleString(xc(VN(52))); note(CheckingString(xc(VN(52))));
  vn(temp) = copy(vn(typeYZ));
  mnp(temp) = drWidth( metalnp, [MNP(13),MNP(15)], mnp(perp_dir) );
  mnp(cline) = drCenterline( mnp(temp), mnp(max_width), mnp(para_dir), drgrid);
  vn(cline) = drCenterline( vn(temp), mnp(max_width), mnp(para_dir), drgrid);
  vn(cline) not mnp(cline);
}
drPushErrorStack(err, xc(VN(52)));


//VN(49) (perp_edge is line_end for this case)
drLineEndEnclosure_( xc(VN(49)), vian, mn(perp_edge), VN(49), drunit);



//SPACING CHECKS
///////////////////////////////////////////////////////////////////////////////////////

//Global vn() min space check
drMinSpace_(xc(VN(ER4)), vian, VN(23));   

//VN(22) (waive VN(23))
vn(wv22) = drGetViaDoubletGap1( vn(typeA), vian, [VN(23), MNP(22)], mnp(perp_dir), VN(01), mnp(para_dir));
drViaCenterConnected_(xc(VN(22)), vn(typeA), vn(wv22), VN(22)); 

//VN(28)
vn(SA_edge) = vian coincident_inside_edge metalnp;
vn(bridge_perp) = drGetViaGap( vn(SA_edge), [VN(23), VN(128)), mnp(perp_dir));

//VN(28) (use as global)
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(para_dir));
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(perp_dir), vn(bridge_perp));

//VN(128)
drMinSpaceDir_(xc(VN(128)), vian, <VN(128), mnp(perp_dir), vn(bridge_perp));

//VN(24)
drViaCorner_( xc(VN(24)), vian, VN(24));

//VN(25/28) (tight pair must be isolated)
err @= {
  @ GetRuleString(xc(VN(25))); note(CheckingString(xc(VN(25))));

  //Find tight c2c (44 - 72 nm)
  c2c_edge_tight = external_corner1_edge(vian, distance = [VN(24), VN(28)), 
    type = {CONVEX_TO_CONVEX}, output_type = POINT_TO_POINT);

  //Find loose c2c (76 nm)
  c2c_edge_loose = external_corner1_edge(vian, distance = VN(28), 
    type = {CONVEX_TO_CONVEX}, output_type = POINT_TO_POINT);

  c2c_tight_os = edge_size(c2c_edge_tight, inside=driunit, outside=driunit);
  c2c_loose_os = edge_size(c2c_edge_loose, inside=driunit, outside=driunit);
  vn(_tight) = vian interacting [include_touch=ALL] c2c_tight_os;

  //Errors
  vian interacting [include_touch=ALL, count>1] c2c_tight_os;
  vn(_tight) interacting [include_touch=ALL] c2c_loose_os;

  external2(vn(_tight), vian, <VN(28), extension = NONE, orientation = PARALLEL, direction = mnp(perp_dir), look_thru= COINCIDENT);
  external2(vn(_tight), vian, <VN(28), extension = NONE, orientation = PARALLEL, direction = mnp(para_dir), look_thru= COINCIDENT);

  //Debug
  drPassthruStack.push_front({ c2c_tight_os, {110,0} });
  drPassthruStack.push_front({ c2c_loose_os, {111,0} });
  drPassthruStack.push_front({ vn(_tight),     {112,0} });
}
drPushErrorStack(err, xc(VN(25)));


//VN(26) special c2c check
drViaViaCorner_( xc(VN(26)), vn(set2) or vn(set3), vian, VN(26), false);
vn(FAQRTC) = vn(typeFA) or vn(typeQ) or vn(typeR) or vn(typeT) or vn(typeC);
drViaCorner_( xc(VN(26)), vn(FAQRTC), VN(26));


//VN(32/152) -Adding lower metal/via in connection as lower metal is unidirectional
vn(cdb_space) = connect (connect_items = {
{ layers = {metalnp, metaln}, by_layer = vian},
{ layers = {metaln, metalnm}, by_layer = vianm}
});
drViaViaCornerConnected_(xc(VN(32)), vian, vianm, vn(cdb_space), VN(32));
drViaViaEdgeConnected_(xc(VN(152)), vian, vianm, vn(cdb_space), VN(152));



//COVERAGE
///////////////////////////////////////////////////////////////////////////////////////

//VN(51) implicit - not coded

//VN(54) 
drMetalConcaveCornerViaSpace_(xc(VN(54)), vian, metalnp, VN(54)); 

//VN(61)
drLineEndEnclosure_( xc(VN(61)), vian, mnp(_line_end), VN(61), drunit);
drLineEndEnclosure_( xc(VN(62)), vn(typeYZ), mnp(_line_end), VN(62), drunit);


//VN(154) First get the exposed edges of MNP w01/02
//Code is direction dependent
mnp(_exposed_edges) = not_external2_edge( mnp(para01side) or_edge mnp(para02side), mnp(para_sides), distance <=MNP(26), 
  extension = NONE_INCLUSIVE, orientation = PARALLEL, direction = mnp(perp_dir), look_thru=COINCIDENT);  
mnp(_exposed_region) = internal2(mnp(_exposed_edges), mnp(_exposed_edges), distance <= MNP(02), 
  extension = NONE, orientation = PARALLEL, direction = mnp(perp_dir), look_thru=COINCIDENT);
mnp(_exposed_region_lt) = drWidth( mnp(_exposed_region), <= VN(154), mnp(para_dir));
mnp(_exposed_region_check) = mnp(_exposed_region) not mnp(_exposed_region_lt);
vn(_exposed) = vian interacting mnp(_exposed_region_check);

//VN(153)
vn(_not_exposed) = vian not vn(_exposed);
vn(cdb_space153) = connect (connect_items = {
{ layers = {metalnp, metaln}, by_layer = vn(_exposed)},
{ layers = {metalnp, metaln}, by_layer = vn(_not_exposed)},
{ layers = {metaln, metalnm}, by_layer = vianm}
});
drMinSpace2STConnect_(xc(VN(153)), vn(_exposed), vianm, VN(153), vn(cdb_space153), DIFFERENT_NET); 



///////////////////////////////////////////////////////////////////////////////////////
