// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d7_TM1_inductor.rs.rca 1.1 Mon Sep 29 18:07:29 2014 gmonroy Experimental $
//
// $Log: p1273d7_TM1_inductor.rs.rca $
// 
//  Revision: 1.1 Mon Sep 29 18:07:29 2014 gmonroy
//  Add TM1 inductor with 45-degree edges for p1273d7 as of the ww38 spec
//

// This is the TM1 inductor with 45-degree edges for p1273d7

#ifndef _P1273D7_TM1_INDUCTOR_RS_
#define _P1273D7_TM1_INDUCTOR_RS_

#define new_dr(lbl, val, text) \
Error_TM1_##lbl	= empty_violation(); \
TM1_##lbl		: double       = val; \
drValHash	[xc(TM1_##lbl)]  = TM1_##lbl; \
drHash		[xc(TM1_##lbl)]  = text; \
drErrHash	[xc(TM1_##lbl)]  = Error_TM1_##lbl; \
drErrGDSHash	[xc(TM1_##lbl)]  = { 42 , 1##lbl };

new_dr(451, 0,	  "TM1 InductorID (42.30) must be drawn covering the inductor");
new_dr(452, 0,	  "45 deg wires are allowed only inside the TM1 Inductor ID");
new_dr(453, 0,	  "TM1 Inductor ID cannot interact with C4B bump");
new_dr(454, 265,  "Max extent of TM1 Inductor ID");
new_dr(401, 8,	  "Min TM1 width for wires connected to 45 deg");
new_dr(421, 22,	  "Max TM1 width for wires connected to 45 deg");
new_dr(422, 0,	  "No TM1 width change at 45 deg corners");
new_dr(423, 0,	  "No holes allowed in TM1 inside TM1 Inductor ID");
new_dr(402, 6.5,  "Min TM1 space inside TM1 Inductor ID");
new_dr(403, 130,  "Max TM1 space inside TM1 Inductor ID");
new_dr(455, 0,	  "No Via9 allowed on 45 deg TM1");
new_dr(456, 8,	  "Min TM1 edge length adjacent to 135 and 225 interior corners");

tm1_inductor_bnd = copy_by_cells(CELLBOUNDARY, tm1_inductor_cells);


// Inductor ID placement

// *** TM1_451: TM1 InductorID (42.30) must be drawn covering the inductor
drCopyToError_("TM1_451", tm1_inductor_bnd xor TM1IND);


// Changed gridcheck (GC) so TM1 is non-manhattan (45 deg allowed) for p1273d7
// with 45 and 315 forbidden, so only 90, 270, 135 and 225 are allowed.

// The 45 degree edges can only occur inside Inductor ID
tm1_45_deg_e = not_angle_edge(TM1, { 0.0, 90.0 });
tm1_45_deg_p = edge_size(tm1_45_deg_e, inside = drunit, outside = drunit);

// *** TM1_452: 45 deg wires are allowed only inside the TM1 Inductor ID
drCopyToError_("TM1_452", tm1_45_deg_p not_inside TM1IND);


// *** TM1_453: TM1 Inductor ID cannot interact with C4B bump
drFlagInteractingAll_("TM1_453", TM1IND, C4B);


// *** TM1_454: Max extent of TM1 Inductor ID
drCopyToError_("TM1_454", not_extent(TM1IND, { <= TM1_454, <= TM1_454 } ));



// TM1 width rules inside TM1 Inductor ID

tm1_with_ind_id = TM1 interacting TM1IND;
tm1_conn_45_deg = tm1_with_ind_id interacting tm1_45_deg_e;
// could not use drMinWidth_ because need to filter output
tm1_401_a = internal1(tm1_conn_45_deg, distance < TM1_401, extension = NONE,
    relational = { POINT_TOUCH });
tm1_401_b = internal_corner1(tm1_conn_45_deg, distance < TM1_401);
// *** TM1_401: Min TM1 width for wires connected to 45 deg
drCopyToError_("TM1_401", (tm1_401_a or tm1_401_b) interacting TM1IND);


// *** TM1_421: Max TM1 width for wires connected to 45 deg
// could not use drMaxWidthWaive_ because need to filter output
tm1_421 = size(size(tm1_conn_45_deg, -TM1_421/2), TM1_421/2);
drCopyToError_("TM1_421", tm1_421 interacting TM1IND);


// *** TM1_423: No holes allowed in TM1 inside TM1 Inductor ID
drCopyToError_("TM1_423", donut_holes(tm1_with_ind_id) interacting TM1IND);


// based off drMinSpaceAllround, can't use it because it doesn't return polygon_layer
tm1_402_sp = external1(TM1, distance < TM1_402, corner_configuration = ALL,
      relational = {POINT_TOUCH}, extension = RADIAL );
// *** TM1_402: Min TM1 space inside TM1 Inductor ID
drCopyToError_("TM1_402", tm1_402_sp interacting TM1IND);


tm1_403_all_e = not_external1_edge(TM1, distance <= TM1_403, extension = NONE);
// don't use corners=IGNORE here, because it would miss violations
tm1_403_excep_e = length_edge(tm1_403_all_e, distance <= TM1_04);
tm1_403_e = tm1_403_all_e not_coincident_edge tm1_403_excep_e;
// *** TM1_403: Max TM1 space inside TM1 Inductor ID
drCopyEdgeToError_("TM1_403", tm1_403_e interacting_edge TM1IND);

max_45_deg_width = max(TM1_421 * sqrt(2) + drgrid, TM1_21);
tm1_45_deg	= internal1(tm1_45_deg_e, distance < max_45_deg_width, 
    extension = RADIAL, orientation = PARALLEL);
// *** TM1_455: No Via9 allowed on 45 deg TM1
drFlagInteractingAll_("TM1_455", VIA9, tm1_45_deg);


tm1_width_rad = internal1(tm1_with_ind_id, distance < max_45_deg_width,
    extension = RADIAL, orientation = PARALLEL);
tm1_width_rect = internal1(tm1_with_ind_id, distance < max_45_deg_width,
    extension = NONE, orientation = PARALLEL);
tm1_elbow = tm1_width_rad not tm1_width_rect;
elbow_45_deg = tm1_45_deg not tm1_width_rect;
// note: space is not checked exactly because vertex_edge is not 
// very accurate with angles (need to investigate as ICV bug)
// currently there is a <1% tolerance in the width
elbow_fail_e = vertex_edge(elbow_45_deg, { 
    (0,	    22.5), 
    (22.5,  67.5),
    (67.5,  90) 
});
// *** TM1_422: No TM1 width change at 45 deg corners
drCopyToError_("TM1_422", tm1_elbow interacting elbow_fail_e);


tm1_456 =   adjacent_edge(tm1_with_ind_id, length < TM1_456, angle1 = 135) or_edge
	    adjacent_edge(tm1_with_ind_id, length < TM1_456, angle1 = 225);
// *** TM1_456: Min TM1 edge length adjacent to 135 and 225 interior corners
drCopyEdgeToError_("TM1_456", tm1_456);


#ifdef _drDEBUG
drPassthruStack.push_back({ TM1IND,	    {42, 30} });
drPassthruStack.push_back({ tm1_45_deg,     {42, 900} });
drPassthruStack.push_back({ elbow_45_deg,   {42, 901} });
#endif

#endif // _P1273D7_TM1_INDUCTOR_RS_
