// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V5.rs.rca 1.4 Sat Oct 19 19:24:03 2013 dgthakur Experimental $
//
// $Log: p1273d6_V5.rs.rca $
// 
//  Revision: 1.4 Sat Oct 19 19:24:03 2013 dgthakur
//  Removing hard coded comment for V5_124.
// 
//  Revision: 1.3 Thu Oct 17 15:23:59 2013 nhkhan1
//  Added a new check (V5_124)
// 
//  Revision: 1.2 Thu Oct 18 16:41:55 2012 nhkhan1
//  fixed V5_22
// 
//  Revision: 1.1 Fri Aug 24 11:58:17 2012 nhkhan1
//  initial check in.
// 


#ifndef _P1273D6_V5_RS_
#define _P1273D6_V5_RS_
#include <p12723_metal_via_common.rs>


//Set via id and via dl (for error output)
#define vid 5
#define vidp 6
#define vndl 29

#define metalnp  metal6
#define vian     via5
#define metaln   metal5
#define vianm    via4
#define metalnm  metal4bc


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
vn(typeA) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(02), mnp(perp_dir), mnp(perp_dir));
vn(typeB) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(03), mnp(perp_dir), mnp(perp_dir));
vn(typeC) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(04), mnp(perp_dir), mnp(perp_dir));
vn(typeD) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(05), mnp(perp_dir), mnp(perp_dir));
vn(typeE) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(06), mnp(perp_dir), mnp(perp_dir));
vn(typeF) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(07), mnp(perp_dir), mnp(perp_dir));
vn(typeG) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(08), mnp(perp_dir), mnp(perp_dir));
vn(typeH) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(09), mnp(perp_dir), mnp(perp_dir));
vn(typeI) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(10), mnp(perp_dir), mnp(perp_dir));
vn(typeJ) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(11), mnp(perp_dir), mnp(perp_dir));
vn(typeL) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(12), mnp(perp_dir), mnp(perp_dir));
vn(typeM) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(13), mnp(perp_dir), mnp(perp_dir));
vn(typeN) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(14), mnp(perp_dir), mnp(perp_dir));
vn(typeO) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(15), mnp(perp_dir), mnp(perp_dir));

vn(typeKpara) = drViaSA2( vn(SA2para), metalnp, VN(101), mnp(para_dir), VN(102), mnp(perp_dir), mnp(perp_dir));
vn(typeKperp) = drViaSA2( vn(SA2perp), metalnp, VN(101), mnp(perp_dir), VN(102), mnp(para_dir), mnp(para_dir));

vn(typeCX) = drViaSA2( vn(SA2para), metalnp, VN(103), mnp(para_dir), VN(104), mnp(perp_dir), mnp(perp_dir));
vn(typeP)  = drViaSA2( vn(SA2para), metalnp, VN(105), mnp(para_dir), VN(106), mnp(perp_dir), mnp(perp_dir));

//Flag invalid vias
vn(setLMNOP) = drOrLayers({ vn(typeL), vn(typeM), vn(typeN), vn(typeO), vn(typeP)});

vn(set_not_LMNOP) = drOrLayers({ vn(typeA), vn(typeB), vn(typeC), vn(typeD), vn(typeE), vn(typeF), vn(typeG), vn(typeH), 
						 vn(typeI), vn(typeJ), vn(typeKpara), vn(typeKperp), vn(typeCX) });

vn(valid) = vn(setLMNOP) or vn(set_not_LMNOP);

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
// para direction
mn(para01_clp) = drShrinkDir(mn(para01), MN(01)/2 - drgrid, mn(perp_dir));
mn(para02_clp) = drShrinkDir(mn(para02), MN(02)/2 - drgrid, mn(perp_dir));  
mn(para03_clp) = drShrinkDir(mn(para03), MN(03)/2 - drgrid, mn(perp_dir));  
mn(para04_clp) = drShrinkDir(mn(para04), MN(04)/2 - drgrid, mn(perp_dir));
mn(para05_clp) = drShrinkDir(mn(para05), MN(05)/2 - drgrid, mn(perp_dir));
mn(para06_clp) = drShrinkDir(mn(para06), MN(06)/2 - drgrid, mn(perp_dir));
mn(para07_clp) = drShrinkDir(mn(para07), MN(07)/2 - drgrid, mn(perp_dir));
mn(para08_clp) = drShrinkDir(mn(para08), MN(08)/2 - drgrid, mn(perp_dir));
mn(para09_clp) = drShrinkDir(mn(para09), MN(09)/2 - drgrid, mn(perp_dir));
mn(para10_clp) = drShrinkDir(mn(para10), MN(10)/2 - drgrid, mn(perp_dir));
mn(para11_clp) = drShrinkDir(mn(para11), MN(11)/2 - drgrid, mn(perp_dir));
mn(para12_clp) = drShrinkDir(mn(para12), MN(12)/2 - drgrid, mn(perp_dir));
mn(para13_clp) = drShrinkDir(mn(para13), MN(13)/2 - drgrid, mn(perp_dir));
mn(para14_clp) = drShrinkDir(mn(para14), MN(14)/2 - drgrid, mn(perp_dir));
mn(para15_clp) = drShrinkDir(mn(para15), MN(15)/2 - drgrid, mn(perp_dir));

mn(clp_para) = drOrLayers({ mn(para01_clp), mn(para02_clp), mn(para03_clp), mn(para04_clp),
                            mn(para05_clp), mn(para06_clp), mn(para07_clp), mn(para08_clp), 
							mn(para09_clp), mn(para10_clp), mn(para11_clp), mn(para12_clp), 
							mn(para13_clp), mn(para14_clp), mn(para15_clp) });

//perp direction
mn(clp_perp) = internal1(metaln, distance = MN(10),  extension=NONE, direction = mn(para_dir),
  orientation = {PARALLEL}, intersecting = {}, output_type= CENTERLINE, width=2*drgrid);

mn(clp) = mn(clp_para) or mn(clp_perp);

// via centers
vn(center) = polygon_centers(vian, 2*drgrid);
drCopyToError_(xc(VN(41)), interacting(vian, vn(center) not_inside mn(clp)) not vn(typeP) ); //typeP exception


//VN(240)
drCopyToError_(xc(VN(240)), vn(typeP) not_inside metaln ); 


//VN(241)
//Only Via5L/M/N/O/P can land on M5_13/14/15
mn(err241) = mn(para13) or mn(para14) or mn(para15);
drCopyToError_(xc(VN(241)), interacting( vn(set_not_LMNOP), mn(err241) ));


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
vn(wv22) = drGetViaDoubletGap1( vn(typeA), vian, [VN(23), MNP(22)], mnp(perp_dir), VN(01), mnp(para_dir));
drViaCenterConnected_(xc(VN(22)), vn(typeA), vn(wv22), VN(22)); 


//Form the SA bridges
vn(SA_edge) = vian coincident_inside_edge metalnp;
vn(bridge_perp_temp) = drGetViaGap( vn(SA_edge), [VN(23), MNP(33)], mnp(perp_dir));
vn(bridge_para_temp) = drGetViaGap( vn(SA_edge), [MNP(40), MNP(40)], mnp(para_dir));
vn(bridge_perp) = vn(bridge_perp_temp) not_interacting vn(bridge_para_temp);
vn(bridge_para) = vn(bridge_para_temp) not_interacting vn(bridge_perp_temp);


//VN(28) - global causes error
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(para_dir), vn(bridge_para));
drMinSpaceDir_(xc(VN(28)), vian, <VN(28), mnp(perp_dir), vn(bridge_perp));


//VN(128) - SA-SA and SA-others
drMinSpaceDir2STCB_(xc(VN(128)), vn(SA_edge), vian, <VN(128), mnp(para_dir), waiver = vn(bridge_para));
drMinSpaceDir2STCB_(xc(VN(128)), vn(SA_edge), vian, <VN(128), mnp(perp_dir), waiver = vn(bridge_perp));


//VN(24)
drViaCorner_( xc(VN(24)), vian, VN(24));

//VN(124)
drViaViaCorner_ (xc(VN(124)), vn(typeKperp), vian not vn(typeKperp), VN(124)); 

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


//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 30, 0);
drPassthru( vian,    29, 0);
drPassthru( metaln,  26, 0);
drPassthru( vianm,   25, 0);



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


#endif //_P1273D6_V5_RS_






