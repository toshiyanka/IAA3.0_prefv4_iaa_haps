// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V9.rs.rca 1.4 Mon Apr 15 14:31:25 2013 jhannouc Experimental $
//
// $Log: p1273d6_V9.rs.rca $
// 
//  Revision: 1.4 Mon Apr 15 14:31:25 2013 jhannouc
//  Updated defined metals and vias to exclude etchring parts.
// 
//  Revision: 1.3 Thu Mar 28 15:22:29 2013 nhkhan1
//  fixed a couple of the via dependedent variable definitions.
// 
//  Revision: 1.2 Thu Mar 28 11:37:00 2013 nhkhan1
//  updated for 1273.6 WW 13 release
// 
//  Revision: 1.1 Tue Aug 21 01:23:53 2012 dgthakur
//  1273.6 via code wrappers.
//

#ifndef _P1273D6_V9_RS_
#define _P1273D6_V9_RS_

#include <p12723_metal_via_common.rs>

//Set via id and via dl (for error output)
#define vid 9
#define vidp 10
#define vndl 45

#define metalnp  metal10
#define vian     via9
#define metaln   metal9
#define vianm    via8
#define metalnm  metal8

// SOME CUSTOM ERROR DEFINITIONS
drErrGDSHash[xc(VN(ER1))] = {vndl,1201} ;
drHash[xc(VN(ER1))] = xc(vian outside metaln);
drValHash[xc(VN(ER1))] = 0;

drErrGDSHash[xc(VN(ER2))] = {vndl,1202} ;
drHash[xc(VN(ER2))] = xc(vian outside metalnp);
drValHash[xc(VN(ER2))] = 0;

drErrGDSHash[xc(VN(ER3))] = {vndl,1203} ;
drHash[xc(VN(ER3))] = xc(vian size/shape is incorrect);
drValHash[xc(VN(ER3))] = 0;

drErrGDSHash[xc(VN(ER4))] = {vndl,1204} ;
drHash[xc(VN(ER4))] = xc(vian global min spacing );
VN(ER4) : double = VN(02)-VN(101)*sqrt(2.0);  //corner to corner space at 45 deg
drValHash[xc(VN(ER4))] = VN(ER4);

drErrGDSHash[xc(VN(R_REDUNDANT))] = {vndl,1205};
drHash[xc(VN(R_REDUNDANT))] = "vian rectangular redundant can only be single pairs no more than";
drValHash[xc(VN(R_REDUNDANT))] = 2;

drErrGDSHash[xc(VN(11/12))] = {vndl,1011};
drHash[xc(VN(11/12))] = "metaln enclosure of square vian (one edge at corner) " + VN(11) + " orthogonal edge enclosure " + VN(12);
drValHash[xc(VN(11/12))] = 0;

drErrGDSHash[xc(VN(61/62))] = {vndl,1061};
drHash[xc(VN(61/62))] = "metalnp enclosure of square vian (one edge at corner) " + VN(61) + " orthogonal edge enclosure " + VN(62);
drValHash[xc(VN(61/62))] = 0;

drErrGDSHash[xc(VN(51/52))] = {vndl,1051};
drHash[xc(VN(51/52))] = "metaln enclosure of rectangular vian (one edge at corner) " + VN(51) + " orthogonal edge enclosure " + VN(52);
drValHash[xc(VN(51/52))] = 0;

drErrGDSHash[xc(VN(71/72))] = {vndl,1071};
drHash[xc(VN(71/72))] = "metalnp enclosure of rectangular vian (one edge at corner) " + VN(71) + " orthogonal edge enclosure " + VN(72);
drValHash[xc(VN(71/72))] = 0;


// classify as square or rectangle
vn(sq) = aspect_ratio(vian, ==1, ORTHOGONAL);
vn(rect) = vian not vn(sq);

// Get the correct sizes
vn(typeSS) = rectangles(vian, {VN(01), VN(01)}); 
vn(typeSA) = rectangles(vian, {VN(101), VN(101)});
vn(typeRS) = rectangles(vian, {VN(31), VN(32)}); 
vn(typeRA) = rectangles(vian, {VN(131), VN(132)});

// Error out bad via sizes
drCopyToError_(xc(VN(ER3)), (vian not (vn(typeSS) or vn(typeSA) or vn(typeRS) or vn(typeRA) )));

//Identify long and short edges of rect vian
vn(_rhor) = aspect_ratio(vian, >1, ORTHOGONAL, X_BY_Y);  // horizontal via longx
vn(_rver) = aspect_ratio(vian, <1, ORTHOGONAL, X_BY_Y);  // horizontal via longy
vn(h_le) = angle_edge(vn(_rhor), {0});
vn(h_se) = angle_edge(vn(_rhor), {90});
vn(v_se) = angle_edge(vn(_rver), {0});
vn(v_le) = angle_edge(vn(_rver), {90});

vn(rect_le) = vn(v_le) or_edge vn(h_le);
vn(rect_se) = vn(v_se) or_edge vn(h_se);

// spacing checks
// global min spacing check
drMinSpaceAllround_(xc(VN(ER4)), vian, VN(ER4));
drMinSpaceDir_(xc(VN(ER4)), vian, <VN(39), mnp(para_dir));
drMinSpaceDir_(xc(VN(ER4)), vian, <VN(39), mnp(perp_dir));

// sq vian to sq vian spacing 
drViaCenter_(xc(VN(02)), vn(sq), VN(02));

// build vnm thru vnp connectivity
vn(dr_cdb) = connect ({
  { layers={metalnp, metaln, vn(sq), vn(rect)}, by_layer=vian },
  { layers={metaln, metalnm}, by_layer=vianm },
});


// vian to vianm spacings
// sq_vian to vianm on different metaln
drViaViaSpaceCDBAllround_(xc(VN(21)), vn(sq), vianm, vn(dr_cdb), VN(21));

// rect vian to vianm on different metaln
drViaViaSpaceCDBAllround_(xc(VN(41)), vn(rect), vianm, vn(dr_cdb), VN(41));

// build metaln thru metalnp connectivity for via doublet
// must be same single mn/mnp piece
vn(mn_mnp_ovrlp) = metalnp and metaln;
vn(dr_cdb_rect) = connect ({
  { layers={vn(mn_mnp_ovrlp), vn(rect)}, by_layer=vian }
});

// find valid vian doublet spacings ; when getting doubletWaiver this effectively checks VN(39)/VN(40)
vn(DoubletWaiverPosbl) = drGetDoubletWaiver(vn(rect), vn(dr_cdb_rect), VN(39));
// clean up DoubletWaiver only good ones are (vn_32 || vn_132) x VN(39) 
vn(DoubletWaiver) = rectangles(vn(DoubletWaiverPosbl), {VN(39), VN(32)}) or rectangles(vn(DoubletWaiverPosbl), {VN(39), VN(132)});

// only doublets allowed only as single pair (ie. > 2 rect_v9 is violation)
drCopyToError_(xc(VN(R_REDUNDANT)),
   ((vn(DoubletWaiver) or vn(rect)) interacting [count > 2, include_touch = NONE] vn(rect)));

// vn(rect) to vian spacing
// vn(rect_le) to sq/vn(rect)
drViaViaEdge_(xc(VN(33)), (vn(rect_le) not_coincident_outside_edge vn(DoubletWaiver)), vian, VN(33), false );

// vn(rect_se) to sq/vn(rect)
drViaViaEdge_(xc(VN(34)), vn(rect_se), vian, VN(34), false );

// vn(rect) to sq/vn(rect) corner 2 corner
drViaViaCorner_( xc(VN(35)), vn(rect), vian, VN(35), false );

// coverage checks
drCopyToError_(xc(VN(ER1)), vian outside metaln); 
drCopyToError_(xc(VN(ER2)), vian outside metalnp); 

//Via cannot form bridge on landing metal (lumping this on ER1)
drViaLandingBridgeCheck_( xc(VN(ER1)), vian, metaln);

// vn(sq) coverage 
drViaCoverage_(xc(VN(11/12)), vn(sq), metaln, VN(11), VN(12));
drViaCoverage_(xc(VN(61/62)), vn(sq), metalnp, VN(61), VN(62));

// vn(rect) coverage 
// do VN(53)/max overlap first
vn(se_clip) = edge_size(vn(rect_se), inside = VN(53));
drCopyToError_(xc(VN(53)), vn(rect) not (metaln or vn(se_clip)));

// find centerline for ogd wires
#if (_drPROCESSNAME == 1273)
#if (_drPROCESS == 6)

mn(para00_clp) = drShrinkDir(mn(para00), MN(00)/2-drgrid, mn(perp_dir));
mn(para02_clp) = drShrinkDir(mn(para02), MN(02)/2-drgrid, mn(perp_dir));
mn(para03_clp) = drShrinkDir(mn(para03), MN(03)/2-drgrid, mn(perp_dir));
mn(para04_clp) = drShrinkDir(mn(para04), MN(04)/2-drgrid, mn(perp_dir));
mn(para05_clp) = drShrinkDir(mn(para05), MN(05)/2-drgrid, mn(perp_dir));
mn(para06_clp) = drShrinkDir(mn(para06), MN(06)/2-drgrid, mn(perp_dir));
mn(para07_clp) = drShrinkDir(mn(para07), MN(07)/2-drgrid, mn(perp_dir));
mn(para08_clp) = drShrinkDir(mn(para08), MN(08)/2-drgrid, mn(perp_dir));
mn(para09_clp) = drShrinkDir(mn(para09), MN(09)/2-drgrid, mn(perp_dir));
mn(para_clp) = mn(para00_clp) or mn(para02_clp) or mn(para03_clp) or mn(para04_clp) or mn(para05_clp) or 
   mn(para06_clp) or mn(para07_clp) or mn(para08_clp) or mn(para09_clp); 

#endif

//Else 1272
#else
  
mn(para00_clp) = drShrinkDir(mn(para00), MN(00)/2-drgrid, mn(perp_dir));
mn(para02_clp) = drShrinkDir(mn(para02), MN(02)/2-drgrid, mn(perp_dir));
mn(para03_clp) = drShrinkDir(mn(para03), MN(03)/2-drgrid, mn(perp_dir));
mn(para04_clp) = drShrinkDir(mn(para04), MN(04)/2-drgrid, mn(perp_dir));
mn(para05_clp) = drShrinkDir(mn(para05), MN(05)/2-drgrid, mn(perp_dir));
mn(para06_clp) = drShrinkDir(mn(para06), MN(06)/2-drgrid, mn(perp_dir));
mn(para07_clp) = drShrinkDir(mn(para07), MN(07)/2-drgrid, mn(perp_dir));
mn(para08_clp) = drShrinkDir(mn(para08), MN(08)/2-drgrid, mn(perp_dir));
mn(para09_clp) = drShrinkDir(mn(para09), MN(09)/2-drgrid, mn(perp_dir));
mn(para_clp) = mn(para00_clp) or mn(para02_clp) or mn(para03_clp) or mn(para04_clp) or mn(para05_clp) or 
   mn(para06_clp) or mn(para07_clp) or mn(para08_clp) or mn(para09_clp); 

#endif

// get straddling rectangular vian
// vian straddling pgd will by default be error since they will not be on an ogd cl
vn(rect_straddle) = vn(rect) cutting metaln;

// get centers for the straddling rectangular vian
vn(center) = polygon_centers(vn(rect_straddle), 2*drgrid);  

// straddling rectangular vian must be centered on ogd metaln
drCopyToError_(xc(VN(153)), vn(rect) interacting (vn(center) not_inside mn(para_clp)) ); 

// metaln coverage of rectangular via
drViaCoverage_(xc(VN(51/52)), (vn(rect) and metaln), metaln, VN(51), VN(52));

// get the doublets
// VN(73)
vn(rect_dblt) = vn(rect) interacting vn(DoubletWaiver);
vn(rect_std) = vn(rect) not_interacting vn(DoubletWaiver);

// since one of the encl is 0 can qual vian dblt by and'ing w/ mnp
drViaCoverage_(xc(VN(71/72)), vn(rect_std), metalnp, VN(71), VN(72));
drViaCoverage_(xc(VN(71/72)), (vn(rect_dblt) and metalnp), metalnp, VN(71), VN(72));

// get vian dblt long edges
vn(rect_le_dblt_edges) = vn(rect_le) coincident_edge vn(rect_dblt);

// get the mnp edges wrt vian dblt
vn(mnp_dblt_edge) = metalnp and_edge vn(rect_dblt);

// bad extension mnp dblt_edge that is eclosed >min and via max width
vn(dblt_bad_le_extension) = enclose(vn(mnp_dblt_edge), vn(rect_le_dblt_edges), (VN(73), VN(131)), extension = NONE, orientation = PARALLEL, from_layer = LAYER2);
drCopyToError_(xc(VN(73)), vn(rect) interacting vn(dblt_bad_le_extension) );


drPassthru( metalnp, 54, 0)
drPassthru( vian,    45, 0)
drPassthru( metaln,  46, 0)
drPassthru( vianm,   41, 0)


#undef vid 
#undef vidp
#undef vndl

#undef metalnp 
#undef vian    
#undef metaln  
#undef vianm   
#undef metalnm



#endif //_P1273D6_V9_RS_
