// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V7.rs.rca 1.2 Thu Oct 18 16:59:22 2012 nhkhan1 Experimental $
//
// $Log: p1273d6_V7.rs.rca $
// 
//  Revision: 1.2 Thu Oct 18 16:59:22 2012 nhkhan1
//  fixed V7_22
// 
//  Revision: 1.1 Fri Aug 24 11:58:36 2012 nhkhan1
//  initial check in
// 


#ifndef _P1273D6_V7_RS_
#define _P1273D6_V7_RS_
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

//Bin the via types
vn(typeAS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(02), mnp(perp_dir), mnp(perp_dir));
vn(typeCS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(03), mnp(perp_dir), mnp(perp_dir));
vn(typeDS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(04), mnp(perp_dir), mnp(perp_dir));
vn(typeES) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(05), mnp(perp_dir), mnp(perp_dir));
vn(typeGS) = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(06), mnp(perp_dir), mnp(perp_dir));
vn(typeM)  = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(07), mnp(perp_dir), mnp(perp_dir));
vn(typeN)  = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(08), mnp(perp_dir), mnp(perp_dir));
vn(typeP)  = drViaSA2( vn(SA2para), metalnp, VN(01), mnp(para_dir), VN(09), mnp(perp_dir), mnp(perp_dir));

vn(typeQ)  = drViaSA2( vn(SA2para), metalnp, VN(101), mnp(para_dir), VN(102), mnp(perp_dir), mnp(perp_dir));
vn(typeR)  = drViaSA2( vn(SA2para), metalnp, VN(103), mnp(para_dir), VN(104), mnp(perp_dir), mnp(perp_dir));
vn(typeS)  = drViaSA2( vn(SA2para), metalnp, VN(105), mnp(para_dir), VN(106), mnp(perp_dir), mnp(perp_dir));
vn(typeT)  = drViaSA2( vn(SA2para), metalnp, VN(107), mnp(para_dir), VN(108), mnp(perp_dir), mnp(perp_dir));
vn(typeU)  = drViaSA2( vn(SA2para), metalnp, VN(109), mnp(para_dir), VN(110), mnp(perp_dir), mnp(perp_dir));
vn(typeZS) = drViaSA2( vn(SA2para), metalnp, VN(111), mnp(para_dir), VN(112), mnp(perp_dir), mnp(perp_dir));

//Flag invalid vias
vn(valid) = drOrLayers({ vn(typeAS), vn(typeCS), vn(typeDS), vn(typeES), vn(typeGS), vn(typeM), vn(typeN),
                            vn(typeP),  vn(typeQ),  vn(typeR),  vn(typeS),  vn(typeT),  vn(typeU), vn(typeZS) });

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
vn(bridge_perp_temp) = drGetViaGap( vn(SA_edge), [VN(23), MNP(27)], mnp(perp_dir));
vn(bridge_para_temp) = drGetViaGap( vn(SA_edge), [MNP(35), MNP(35)], mnp(para_dir));
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


#endif //_P1273D6_V7_RS_






