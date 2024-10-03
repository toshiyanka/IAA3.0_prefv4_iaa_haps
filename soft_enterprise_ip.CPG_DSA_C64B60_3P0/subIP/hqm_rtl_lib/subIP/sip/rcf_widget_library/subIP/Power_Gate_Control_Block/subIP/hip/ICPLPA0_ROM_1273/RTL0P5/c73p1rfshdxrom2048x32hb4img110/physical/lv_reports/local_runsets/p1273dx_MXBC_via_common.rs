// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_MXBC_via_common.rs.rca 1.13 Tue Dec 30 13:29:21 2014 qfan4 Experimental $
//
// $Log: p1273dx_MXBC_via_common.rs.rca $
// 
//  Revision: 1.13 Tue Dec 30 13:29:21 2014 qfan4
//  update for Sttm waiver
//  all waiver now wrap with _drSTRAM_WAIVER
// 
//  Revision: 1.12 Tue Dec 16 10:57:23 2014 qfan4
//  Add StmX waiver
// 
//  Revision: 1.11 Wed Jun  4 15:42:30 2014 dgthakur
//  Added the new bridge via checks.
// 
//  Revision: 1.10 Wed May 14 17:10:48 2014 qfan4
//  add waiver for MemX V2
// 
//  Revision: 1.9 Mon Feb 11 15:46:41 2013 nhkhan1
//  added production cell names for TSV CC waivers
// 
//  Revision: 1.8 Tue Jan 29 11:22:21 2013 nhkhan1
//  added TSV CC waiver for V2_41
// 
//  Revision: 1.7 Mon Dec 17 12:02:02 2012 dgthakur
//  Added VN(241) exception - currently only for V2GY and V2GZ.
// 
//  Revision: 1.6 Fri Nov  2 14:32:49 2012 sstalukd
//  Replaced V3_97 check by SV3_97 under STTRAMID1
// 
//  Revision: 1.5 Fri Jan 13 14:53:19 2012 dgthakur
//  Added new rules VN(228), VN(250/251/252) tight corner rules, and updated VN(97) rule.
// 
//  Revision: 1.4 Sat Nov 26 15:27:17 2011 dgthakur
//  Via cannot form bridge on landing metal - adding to V0_ER0 check for safety (bridge vias excluded from this check).
// 
//  Revision: 1.3 Wed Aug 17 22:36:26 2011 dgthakur
//  Updated connectivity to include Mn+1,Mn,Mn-1 for Vn to Vn-1 space checks.
// 
//  Revision: 1.2 Wed Jul 27 16:26:50 2011 dgthakur
//  Added new rules VN(45), VN(46) and VN(54).
// 
//  Revision: 1.1 Wed Jul 20 17:00:41 2011 dgthakur
//  First check in for 1273 files
//



//**DO NOT WRAP WITH IFDEF SINCE THIS CODE WILL BE REUSED**
//COMMON MODULE FOR CHECKING B/C VIA RULES (VIAS BETWEEN METAL B?C LAYERS)
//CURRENTLY USED FOR 1273 V2/3/4.



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
drViaLandingBridgeCheck_( xc(VN(ER0)), (vian not vn(setT)), metaln);
drViaCoverageGrossCheck_( xc(VN(ER1)), vian, metalnp);



//VIA PLACEMENT RELATIVE TO LOWER METAL
///////////////////////////////////////////////////////////////////////////////////////

//VN(33) - no connect needed as metaln is unidirectional
drMinSpace2ST_(xc(VN(33)), vian, metaln, VN(33));

//VN(40)
vn(perp_edge) = angle_edge_dir(vian, mnp(para_dir));
drMaxOverHang_(xc(VN(40)), vn(perp_edge), metaln, <=VN(40), mnp(para_dir));

//VN(240) - also ensures VN(241)
vn(_240_check) = (vian not vn(set1)) not vn(setT);
vn(_240_ERR) = vn(_240_check) not_inside metaln;  //ERROR bin
drCopyToError_(xc(VN(240)), vn(_240_ERR)); 

//VN(41) applies to all vias except typeT
err @= {
  @ GetRuleString(xc(VN(41))); note(CheckingString(xc(VN(41))));
  vn(temp) = (vian not vn(setT)) not vn(241); //VN(241) exception
  mn(temp) = metaln interacting vn(temp);
  mn(cline) = drCenterline( mn(temp), mn(max_width), mnp(perp_dir), drgrid);
  vn(cline) = drCenterline( vn(temp), mnp(max_width), mnp(perp_dir), drgrid);
  // TSV CC waivers for V2_42. CC has thick M2 as well as PGD-M2 is is also drawn in specific cells
  #if ( vid ==2 && _drTSV_WAIVER == _drYES )
     pgdM2_TSV_CC = copy_by_cells(layer1=metaln, cells={"x73btsvccalt1sub3", "x73btsvccalt1sub3cnr", "d8xltsv_ccalt1sub3", "d8xltsv_ccalt1sub3cnr"});
     pgdM2_TSV_CC_cline = drCenterline( metaln not pgdM2_TSV_CC, 0.232, mnp(perp_dir), drgrid);
     mn(cline) = mn(cline) or pgdM2_TSV_CC_cline;
  #endif
//  vn(cline) not mn(cline);

       #if (_drMemX)
                not(vn(cline) not mn(cline), ((VIA2 and METAL1) and MTJID));
       #else
		#if (_drSTRAM_WAIVER == _drYES && _drPROCESSNAME == 1273)
			not(vn(cline) not mn(cline), VIA2 and MJ0);
       		#else
                	vn(cline) not mn(cline);
       		#endif
	#endif
}
drPushErrorStack(err, xc(VN(41)));

//VN(42) (similar as V0_42)
err @= {
  @ GetRuleString(xc(VN(42))); note(CheckingString(xc(VN(42))));
  internal2( vn(typeTA) or vn(typeTB), metaln, distance <VN(42), intersecting = {TOUCH, ACUTE},
    extension = NONE_INCLUSIVE, relational = {POINT_TOUCH}, direction = mnp(para_dir),
    look_thru = OUTSIDE); 
}
drPushErrorStack(err, xc(VN(42)));

//VN(142) (similar to VN(42) above)
err @= {
  @ GetRuleString(xc(VN(142))); note(CheckingString(xc(VN(142))));
  internal2( vn(typeTC), metaln, distance <VN(142), intersecting = {TOUCH, ACUTE},
    extension = NONE_INCLUSIVE, relational = {POINT_TOUCH}, direction = mnp(para_dir),
    look_thru = OUTSIDE); 
}
drPushErrorStack(err, xc(VN(142)));

//VN(43)
vn(T_UnlandedERR) = vn(setT) not_interacting [include_touch =NONE, count =2] metaln;
drCopyToError_(xc(VN(43)), vn(T_UnlandedERR)); 

//VN(45)
mn(L01_lt) = drWidth( metaln, <MNL(01), mn(perp_dir) );
drCopyToError_(xc(VN(45)), vn(typeJX) interacting mn(L01_lt) );

//VN(46)
mn(M02_lt) = drWidth( metaln, <MNM(02), mn(perp_dir) );
drCopyToError_(xc(VN(46)), vn(typeRX) interacting mn(M02_lt) );


//VN(98)
//No easy way to check- should check in trace/IPC

//VN(49)
drLineEndEnclosure_( xc(VN(49)), vian, mn(perp_edge), VN(49), drunit);



//VIA SPACING
///////////////////////////////////////////////////////////////////////////////////////

//Global min space check
drMinSpace_(xc(VN(ER4)), vian, VN(23));   

//VN(22) (waive VN(23))
vn(wv22) = drGetViaDoubletGap1( vn(typeA), vian, VN(23), mnp(perp_dir), VN(01), mnp(para_dir));
drViaCenterConnected_(xc(VN(22)), vn(typeA), vn(wv22), VN(22)); 

//Get the space check waiver regions (VN(97) -do not from bridge for TypeT)
vn(temp) = vian not vn(setT); 
vn(SA_edge) = vn(temp) coincident_inside_edge metalnp;
vn(bridge_perp) = drGetViaGap( vn(SA_edge), [VN(23), VN(23)], mnp(perp_dir));

//VN(28) (use as global)
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(para_dir));
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(perp_dir), vn(bridge_perp));

//VN(128)
drMinSpaceDir_(xc(VN(128)), vian, <VN(128), mnp(perp_dir), vn(bridge_perp));
#if (vid ==3 && _drSTRAM_WAIVER == _drYES) 
  err @= { 
    @ GetRuleString(xc(SV3_97)); note(CheckingString(xc(SV3_97)));
    tmp_space_v3 = drMinSpaceDir(vn(setT), <VN(97), mnp(perp_dir));
    good_v3stram_space = drWidth(tmp_space_v3 and STTRAMID1,SV3_97,mnp(perp_dir));  
    tmp_space_v3 not good_v3stram_space;
  }
  drPushErrorStack(err, xc(SV3_97));
#else
  drMinSpaceDir_(xc(VN(97)), vn(setT), <VN(97), mnp(perp_dir)); //Just to be safe
#endif

//VN(228) (does not get bridge waivers)
vn(typeHA_SA_edge) = vn(typeHA) coincident_inside_edge metalnp;
drMinSpaceDir2STCB_(xc(VN(228)), vn(typeHA_SA_edge), vn(SA_edge), <VN(228), mnp(perp_dir));

//VN(24)
drViaCorner_( xc(VN(24)), vian, VN(24));

//Adding metalnm/vianm connection as metaln is unidirectional
vn(cdb_space) = connect (connect_items = {
{ layers = {metalnp, metaln}, by_layer = vian},
{ layers = {metaln, metalnm}, by_layer = vianm}
});
drViaViaCornerConnected_(xc(VN(32)), vian, vianm, vn(cdb_space), VN(32));
drMinSpace2DirSTConnect_(xc(VN(152)), vian, vianm, VN(152), mnp(para_dir), vn(cdb_space), DIFFERENT_NET);
drMinSpace2DirSTConnect_(xc(VN(152)), vian, vianm, VN(152), mnp(perp_dir), vn(cdb_space), DIFFERENT_NET);



//VIA PLACEMENT RELATIVE TO UPPER METAL
///////////////////////////////////////////////////////////////////////////////////////

//VN(62)
drLineEndEnclosure_( xc(VN(62)), vn(setNSA), mnp(para_edge), VN(62), drunit);

//VN(51)
//Already checked for SA vias

//VN(54)
mnp(L05) = drWidth( metalnp, MNPL(05), mnp(perp_dir) );
drCopyToError_(xc(VN(54)), vn(typeHJ) not_interacting mnp(L05) );

//VN(61)  - for rectangular metal perp_edge is same as line_end
drLineEndEnclosure_( xc(VN(61)), vian, mnp(perp_edge), VN(61), drunit);



//VIA TIGHT CORNER RULES (NEW) VN_250/251/252 
///////////////////////////////////////////////////////////////////////////////////////

//Define small and big via for tight c2c checks
vn(small) = vn(set1) or vn(set3) or vn(setNSA);
vn(big) = vian not vn(small);

err @= {
  @ GetRuleString(xc(VN(251))); note(CheckingString(xc(VN(251))));

  //Find tight c2c (48 - 71 nm)
  c2c_edge_tight = external_corner2_edge(vn(small), vian, distance = [VN(24), VN(250)), 
    type = {CONVEX_TO_CONVEX}, output_type = POINT_TO_POINT, look_thru= ALL);
  c2c_tight_os = edge_size(c2c_edge_tight, inside=driunit, outside=driunit);
  vn(small_tight) = vn(small) interacting [include_touch=ALL] c2c_tight_os;
  vn(small_tight) interacting [include_touch=ALL, count>1] c2c_tight_os;

  //Debug
  drPassthruStack.push_front({ c2c_tight_os, {110,0} });
  drPassthruStack.push_front({ vn(small_tight), {111,0} });
}
drPushErrorStack(err, xc(VN(251)));

err @= {
  @ GetRuleString(xc(VN(252))); note(CheckingString(xc(VN(252))));

  //Find tight c2c (48 - 71 nm)
  c2c_edge_tight = external_corner2_edge(vn(big), vn(small), distance = [VN(24), VN(250)), 
    type = {CONVEX_TO_CONVEX}, output_type = POINT_TO_POINT, look_thru= ALL);
  c2c_tight_os = edge_size(c2c_edge_tight, inside=driunit, outside=driunit);
  vn(big_tight) = vn(big) interacting [include_touch=ALL] c2c_tight_os;
  vn(big_tight) interacting [include_touch=ALL, count>2] c2c_tight_os;

  //Debug
  drPassthruStack.push_front({ c2c_tight_os, {210,0} });
  drPassthruStack.push_front({ vn(big_tight), {211,0} });

  //Tight big via cannot interact with another big via
  c2c_edge_tight_BB = external_corner2_edge(vn(big_tight), vn(big), distance = [VN(24), VN(250)), 
    type = {CONVEX_TO_CONVEX}, output_type = POINT_TO_POINT, look_thru= ALL);
  c2c_tight_os = edge_size(c2c_edge_tight_BB, inside=driunit, outside=driunit);
  vn(big_tight) interacting [include_touch=ALL] c2c_tight_os;

  //Debug
  drPassthruStack.push_front({ c2c_edge_tight_BB, {212,0} });
}
drPushErrorStack(err, xc(VN(252)));



//Include the new bridge via checks
#include <p12723_VX_bridge_function.rs>


