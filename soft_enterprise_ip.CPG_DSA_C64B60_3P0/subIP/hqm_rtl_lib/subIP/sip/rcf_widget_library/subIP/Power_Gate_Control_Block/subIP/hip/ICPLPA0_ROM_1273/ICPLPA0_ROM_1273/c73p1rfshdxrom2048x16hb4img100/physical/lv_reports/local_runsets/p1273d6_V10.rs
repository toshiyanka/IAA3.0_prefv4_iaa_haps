// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V10.rs.rca 1.4 Mon May  6 17:51:01 2013 nhkhan1 Experimental $
//
// $Log: p1273d6_V10.rs.rca $
// 
//  Revision: 1.4 Mon May  6 17:51:01 2013 nhkhan1
//  fixed issue with V10_11/12 and V10_61/62
// 
//  Revision: 1.3 Mon Apr 15 14:30:31 2013 jhannouc
//  Updated defined metals and vias to exclude etchring parts.
// 
//  Revision: 1.2 Thu Mar 28 15:15:17 2013 nhkhan1
//  updated for p1273_6 WW 13 release
// 
//  Revision: 1.1 Tue Aug 21 01:23:53 2012 dgthakur
//  1273.6 via code wrappers.
//



#ifndef _P1273D6_V10_RS_
#define _P1273D6_V10_RS_


#include <p12723_metal_via_common.rs>


#define vid   10
#define vidp  11

#define vndl  53
#define mnpdl 58
#define mndl  54

#define metalnp  metal11
#define vian     via10
#define metaln   metal10
#define vianm    via9
#define metalnm  metal9


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
drValHash[xc(VN(ER4))] = VN(39);

drErrGDSHash[xc(VN(R_REDUNDANT))] = {vndl,1205};
drHash[xc(VN(R_REDUNDANT))] = "vian rectangular redundant can only be single pairs no more than";
drValHash[xc(VN(R_REDUNDANT))] = 3;

drErrGDSHash[xc(VN(11/12))] = {vndl,1011};
drHash[xc(VN(11/12))] = "metaln enclosure of square vian (one edge at corner) " + VN(11) + " orthogonal edge enclosure " + VN(12);
drValHash[xc(VN(11/12))] = 0;

drErrGDSHash[xc(VN(61/62))] = {vndl,1061};
drHash[xc(VN(61/62))] = "metalnp enclosure of square vian (one edge at corner) " + VN(61) + " orthogonal edge enclosure " + VN(62);
drValHash[xc(VN(61/62))] = 0;

drErrGDSHash[xc(VN(51/52))] = {vndl,1051};
drHash[xc(VN(51/52))] = "metaln enclosure of rectangular vian (one edge at corner) " + VN(51) + " orthogonal edge enclosure " + VN(52);
drValHash[xc(VN(51/52))] = 0;


// classify as square or rectangle
vn(sq) = aspect_ratio(vian, ==1, ORTHOGONAL);
vn(rect) = vian not vn(sq);

drPassthru( vn(sq), vndl, 200);
drPassthru( vn(rect), vndl, 201);

// Get the correct sizes
vn(typeSS) = rectangles(vian, {VN(01), VN(01)}); 
vn(typeRS) = rectangles(vian, {VN(31), VN(32)}); 

// Error out bad via sizes
drCopyToError_(xc(VN(ER3)), (vian not (vn(typeSS) or vn(typeRS) )));

//Identify long and short edges of rect vian
vn(_rhor) = aspect_ratio(vian, >1, ORTHOGONAL, X_BY_Y);  // horizontal via longx
vn(_rver) = aspect_ratio(vian, <1, ORTHOGONAL, X_BY_Y);  // horizontal via longy
vn(h_le) = angle_edge(vn(_rhor), {0});
vn(h_se) = angle_edge(vn(_rhor), {90});
vn(v_se) = angle_edge(vn(_rver), {0});
vn(v_le) = angle_edge(vn(_rver), {90});

vn(le) = vn(v_le) or_edge vn(h_le);
vn(se) = vn(v_se) or_edge vn(h_se);

// spacing checks
// global min spacing check
drMinSpaceAllround_(xc(VN(ER4)), vian, VN(39));

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
vn(DoubletWaiver) = rectangles(vn(DoubletWaiverPosbl), {VN(39), VN(32)});

// only doublets allowed only as single pair (ie. > 2 rect_vian is violation)
drCopyToError_(xc(VN(R_REDUNDANT)),
   ((vn(DoubletWaiver) or vn(rect)) interacting [count > 3, include_touch = NONE] vn(rect)));

// vn(rect) to vian spacing
// vn(rect_le) to sq/vn(rect)
drViaViaEdge_(xc(VN(33)), (vn(le) not_coincident_outside_edge vn(DoubletWaiver)), vian, VN(33), false );

// vn(rect_se) to sq/vn(rect)
drViaViaEdge_(xc(VN(34)), vn(se), vian, VN(34), false );

// vn(rect) to sq/vn(rect) corner 2 corner
drViaViaCorner_( xc(VN(35)), vn(rect), vian, VN(35), false );

// coverage checks
drCopyToError_(xc(VN(ER1)), vian outside metaln); 
drCopyToError_(xc(VN(ER2)), vian outside metalnp); 

//Via cannot form bridge on landing metal (lumping this on ER1)
drViaLandingBridgeCheck_( xc(VN(ER1)), vian, metaln);

// vn(sq) coverage 
drViaCoverage_(xc(VN(11/12)), vn(sq) and metaln, metaln, 0.0, VN(12));
drViaCoverage_(xc(VN(61/62)), vn(sq) and metalnp, metalnp, 0.0, VN(62));

// the the metaln edges wrt square vian
vn(sq_edge) = metaln and_edge vn(sq);
// bad extension vn(sq_edge) that is eclosed >min and via max width
vn(sq_bad_extension) = enclose(vn(sq_edge), vn(sq), (VN(11), VN(01)), extension = NONE, orientation = PARALLEL, from_layer = LAYER2);
drCopyToError_(xc(VN(11)), vn(sq) interacting vn(sq_bad_extension) );

// the the metalnp edges wrt square vian
vn(sq_edge1) = metalnp and_edge vn(sq);
// bad extension vn(sq_edge1) that is eclosed >min and via max width
vn(sq_bad_extension1) = enclose(vn(sq_edge1), vn(sq), (VN(61), VN(01)), extension = NONE, orientation = PARALLEL, from_layer = LAYER2);
drCopyToError_(xc(VN(61)), vn(sq) interacting vn(sq_bad_extension1) );

// metaln coverage of rectangular via
drViaCoverage_(xc(VN(51/52)), vn(rect), metaln, VN(51), VN(52));

// the the metalnp edges wrt rectangular vian
vn(rv_edge) = metalnp and_edge vn(rect);
// bad extension vn(rv_edge) that is eclosed >min and via max width
vn(bad_le_extension) = enclose(vn(rv_edge), vn(le), (VN(71), VN(31)), extension = NONE, orientation = PARALLEL, intersecting = {ACUTE, PERPENDICULAR}, from_layer = LAYER2);
drCopyToError_(xc(VN(71)), vn(rect) interacting vn(bad_le_extension) );

// get se to check
// get coincident se with clipped rect via by long edge sized by legal overlap 
vn(se_wrt_mnp) = vn(se) coincident_edge (vn(rect) not (edge_size(vn(le), inside = VN(71)))); 
// bad vn(se) enclosure by metalnp 
drViaEncloseEdge_(xc(VN(72)), vn(se_wrt_mnp), metalnp, VN(72));
drCopyEdgeToError_(xc(VN(72)), vn(se_wrt_mnp) not_edge metalnp);  // totally outside metalnp


// Push pass through layers for debug 
drPassthru( metalnp, 58, 0);
drPassthru( vian,    53, 0);
drPassthru( metaln,  54, 0);
drPassthru( vianm,   45, 0);
drPassthru( metalnm,  46, 0);


#undef vid 
#undef vidp

#undef vndl
#undef mnpdl
#undef mndl 

#undef metalnp 
#undef vian    
#undef vianm    
#undef metaln  
#undef metalnm  


#endif //_P1273D6_V10_RS_
