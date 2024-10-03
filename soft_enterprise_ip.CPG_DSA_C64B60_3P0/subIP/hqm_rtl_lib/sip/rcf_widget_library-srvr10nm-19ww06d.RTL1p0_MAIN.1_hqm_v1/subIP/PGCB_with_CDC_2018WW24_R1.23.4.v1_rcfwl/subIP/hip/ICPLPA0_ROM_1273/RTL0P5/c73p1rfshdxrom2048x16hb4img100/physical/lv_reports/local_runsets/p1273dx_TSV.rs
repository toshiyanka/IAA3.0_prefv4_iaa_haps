// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TSV.rs.rca 1.22 Wed Oct  8 10:52:02 2014 nhkhan1 Experimental $
// $Log: p1273dx_TSV.rs.rca $
// 
//  Revision: 1.22 Wed Oct  8 10:52:02 2014 nhkhan1
//  commented LMI_02/04/05/12 and changed LMI_13 for x73b
//  added prs rdl cells for x73b
// 
//  Revision: 1.21 Thu Sep 11 15:59:05 2014 nhkhan1
//  added multiple waivers for d81 PRS cells that use TSV CC cells
// 
//  Revision: 1.20 Tue Jun 24 11:21:31 2014 nhkhan1
//  modified RDL Ring and Assembly Mark construction checks (as per latest RDL construction guide book)
// 
//  Revision: 1.19 Wed Jun  4 12:44:26 2014 nhkhan1
//  commented LMI_07/08/09/10 (removed from DR file now)
// 
//  Revision: 1.18 Fri Apr 25 11:17:44 2014 nhkhan1
//  added LMI_40 and LMI_41 checks
// 
//  Revision: 1.17 Tue Apr  1 12:04:25 2014 nhkhan1
//  fixed issue with TSV_07/08 checks
// 
//  Revision: 1.16 Thu Mar 20 23:32:28 2014 nhkhan1
//  Added CC_03: TSV_CANTILIVER is not allowed
//  Changed TSV_07/08 to check gate distance from TSV_CC cell instead TSV layer
//  Fixed RDL_16
//  Commented LMI_14
// 
//  Revision: 1.15 Fri Feb  7 23:02:00 2014 nhkhan1
//  added TSV_08 (New Rule)
// 
//  Revision: 1.14 Fri Dec 20 15:27:06 2013 nhkhan1
//  fixed issue with SDC layer checks (dotOne was checking M10 and above)
// 
//  Revision: 1.13 Mon Aug 12 09:41:26 2013 nhkhan1
//  added RDL_15 and RDL_16
// 
//  Revision: 1.12 Thu Jun  6 14:03:50 2013 nhkhan1
//  added/removed SDC layers for different dot products
//  improved TSV_TSDR* checks
// 
//  Revision: 1.11 Wed Jun  5 00:45:53 2013 nhkhan1
//  modified TSV_CC_SDC checks to output each SDC* layer individually
//  waived TSDR RDL/LMI/TSV widths for regular width checks
// 
//  Revision: 1.10 Tue May 28 17:44:08 2013 nhkhan1
//  added some new TSDR specific checks for 1273 TSV
// 
//  Revision: 1.9 Mon May 20 17:28:25 2013 nhkhan1
//  added construction checks for the RDL rings
// 
//  Revision: 1.8 Wed Apr 17 10:11:33 2013 nhkhan1
//  removed the via trench ID check for *SDC layer as per discussion with Moonsoo and Taka
// 
//  Revision: 1.7 Tue Apr 16 11:08:04 2013 nhkhan1
//  added check to ensure ETCHRINGTRENCHID is not drawn inside the *SDC layers
// 
//  Revision: 1.6 Mon Apr 15 17:21:42 2013 nhkhan1
//  added check SDC layers over TSV CC GR
// 
//  Revision: 1.5 Mon Mar 18 13:07:17 2013 nhkhan1
//  added x73b waivers
// 
//  Revision: 1.4 Wed Mar 13 14:10:53 2013 nhkhan1
//  fixed issue with LMI_04/05
// 
//  Revision: 1.3 Fri Feb 15 11:55:28 2013 nhkhan1
//  changed TSV_06, Test Chip is also using the same catch-cup cells.
// 
//  Revision: 1.2 Fri Jan 11 15:38:05 2013 sstalukd
//  Latest runset based on Rev99 Redbook
//  TSV_02 replaced by TSV_21/22/23
//  TSV_03 check modified from min dist to fixed dist
//  New rule TSV_10 for FULL_DIE use only
//  For X73B, LMI_02/04/05/12/13 uses Gen1 Jdec spec hence different from Rev99 dr values - hard-coded in runset
//  LMI_04/05 def changed from center-center space to side-side space
//  New rule LMI_13/14
// 
//  Revision: 1.1 Thu Nov  8 17:11:24 2012 sstalukd
//  Initial checkin for TSV/RDL/LMI checks
//  Remaining checks - TSV_08/LMI_13/14
// 

#ifndef _P1273_TSV_RS_
#define _P1273_TSV_RS_

#include <1273/p1273dx_TSVhdr.rs>

// x73b has non-standard LMI drawn over DFT pads and standard rules don't apply to them
lmi_waiver = g_empty_layer;
rdl_waiver = g_empty_layer;

#if (_drPROJECT == _drx73b && _drTSV_WAIVER == _drYES)
   lmi_waiver = rectangles(LMIPAD, {80.586, 80.586});
   rdl_waiver = drGrow(lmi_waiver, 0.707, 0.707, 0.707, 0.707) or rectangles(RDL, {57.983, 57.983});
#endif

drPassthruStack.push_back({ lmi_waiver,        {900,900} });
drPassthruStack.push_back({ rdl_waiver,        {900,901} });

//RDL in the PRS cells don't need to be considered for rhese checks
prs_rdl = copy_by_cells(RDL, cells = { "d81mtoprs_i_small", "d81mtoprs_i_small_cc", "d81mtoprs_y_small", "d81mtoprs_y_small_cc", "x73btsv_prs_i_small", "x73btsv_prs_y_small" } );
prs_cell_bound = copy_by_cells( CELLBOUNDARY, cells = { "d81mtoprs_i_small", "d81mtoprs_i_small_cc", "d81mtoprs_y_small", "d81mtoprs_y_small_cc", "x73btsv_prs_i_small", "x73btsv_prs_y_small" } );


/***********************************************************************
Start --- These are the RDL ring spec as per Kalyan's email 5/17/2013
Updated 06/24/2014
***********************************************************************/
rdl_ring_width: double = 6.0;
rdl_ring_space: double = 4.0;

//Synthesize the 2 rings
eoa_os_rdl = size(EOA, rdl_ring_width);
rdl_ring1 = eoa_os_rdl not EOA;
		
eoa_os_spc = size(eoa_os_rdl, rdl_ring_space);
eoa_os_rdl = size(eoa_os_spc, rdl_ring_width);
rdl_ring2 = eoa_os_rdl not eoa_os_spc;
	
rdl_ring_synth = rdl_ring1 or rdl_ring2;
rdl_assmb_mark_bound = copy_by_cells(CELLBOUNDARY, cells = rdl_fudicial_cells);
//This layer is used fow waivers for RDL_01/02/05/16/err2
rdl_ring_assmb_mark_waiver = rdl_ring_synth or rdl_assmb_mark_bound;

if (!layer_empty(EOA)) { // Do these checks only when EOA is drawn
rdl_ring_spec @= {
	
    @ "RDL_RING_00: RDL ring inner line should be aligned to edge of active";
    not_coincident_edge(EOA,  RDL);
	
    @ "RDL_RING_01: RDL should be 2-rings, each of with 6um and space 4um in between";
    (RDL not EOA) xor rdl_ring_synth;
	
    @ "RDL_RING_02: The RDL Assembly mark cells should be placed line on line with EOA and RDL Assembly Mark Cells should be at the diognal corners";
    EOA interacting (EOA not_interacting_edge rdl_assmb_mark_bound);

} drErrorStack.push_back({rdl_ring_spec, {217,1200}});
}

drPassthruStack.push_back({ rdl_ring1, {217,900} });
drPassthruStack.push_back({ rdl_ring2, {217,901} });
drPassthruStack.push_back({ rdl_assmb_mark_bound, {217,902} });


/***********************************************************************
End --- These are the RDL ring spec as per Kalyan's email 5/17/2013
***********************************************************************/


/***********************************************************************
Start --- Test chip TSV/RDL/LMI sizes and construction checks
***********************************************************************/
tsdr_lmi_widths = g_empty_layer;
tsdr_tsv_widths = g_empty_layer;
tsdr_rdl_widths = g_empty_layer;

#if (_drTSDR == _drYES)

//binning the TSV sizes
tsdr_tsv_por = rectangles(TSV, {9.5, 9.5});
tsdr_tsv_sk1 = rectangles(TSV, {10.45, 10.45});
tsdr_tsv_sk2 = rectangles(TSV, {11.4, 11.4});
tsdr_tsv_sk3 = rectangles(TSV, {8.444, 8.444});
tsdr_tsv_sk4 = rectangles(TSV, {7.6, 7.6});
tsdr_tsv_widths = tsdr_tsv_por or tsdr_tsv_sk1 or tsdr_tsv_sk2 or tsdr_tsv_sk3 or tsdr_tsv_sk4;

//binning of RDL widths
rdl_os_tsdr = drUnderOver(RDL,RDL_02/2);
rdl_tsv_por = rectangles(rdl_os_tsdr, {10, 10});
rdl_tsv_sk1 = rectangles(rdl_os_tsdr, {10.95, 10.95});
rdl_tsv_sk2 = rectangles(rdl_os_tsdr, {11.9, 11.9});
rdl_tsv = rdl_tsv_por or rdl_tsv_sk1 or rdl_tsv_sk2;
rdl_etest_pad = rectangles(rdl_os_tsdr, {42.336, 39.2});
rdl_rf_pad = rectangles(rdl_os_tsdr, {66.528, 52});
rdl_em_pad = rectangles(rdl_os_tsdr, {82, 82});
rdl_dram_bump = rectangles(rdl_os_tsdr, {15.556, 15.556});
tsdr_rdl_widths = rdl_tsv or rdl_etest_pad or rdl_rf_pad or rdl_em_pad or rdl_dram_bump;

//binning the LMI widths
lmi_etest_pad = rectangles(LMIPAD, {40.922, 37.786});
lmi_rf_pad = rectangles(LMIPAD, {65.114, 50.586});
lmi_em_pad = rectangles(LMIPAD, {80.586, 80.586});
lmi_dram_bump1 = rectangles(LMIPAD, {14.142, 14.142});
lmi_dram_bump2 = rectangles(LMIPAD, {12.728, 12.728});
lmi_dram_bump3 = rectangles(LMIPAD, {11.314, 11.314});
lmi_dram_bump4 = rectangles(LMIPAD, {14.85, 14.85});
lmi_dram_bump5 = rectangles(LMIPAD, {15.556, 15.556});
tsdr_lmi_widths = lmi_etest_pad or lmi_rf_pad or lmi_em_pad or 
                lmi_dram_bump1 or lmi_dram_bump2 or lmi_dram_bump3 or lmi_dram_bump4 or lmi_dram_bump5;

drPassthruStack.push_back({ tsdr_tsv_widths,    {207,9000} });
drPassthruStack.push_back({ tsdr_rdl_widths,    {207,9001} });
drPassthruStack.push_back({ tsdr_lmi_widths,    {207,9002} });

// Binning of rdl_os_tsdr based on C4* layers
rdl_bin_tsv = (rdl_tsv not_interacting (C4B or C4T or C4E)) interacting TSV;
rdl_bin_etest_pad = rdl_etest_pad interacting ((C4B and C4T) not C4E);
rdl_bin_rf_pad = rdl_rf_pad not_interacting (C4T or C4E or TSV);
rdl_bin_em_pad = (rdl_em_pad interacting (C4B and C4T and C4E)) not_interacting TSV;
rdl_bin_dram_bump = rdl_dram_bump not_interacting (C4B or C4T or C4E or TSV);

drPassthruStack.push_back({ rdl_bin_tsv,    {207,9003} });
drPassthruStack.push_back({ rdl_bin_etest_pad,    {207,9004} });
drPassthruStack.push_back({ rdl_bin_rf_pad,    {207,9005} });
drPassthruStack.push_back({ rdl_bin_em_pad,    {207,9006} });
drPassthruStack.push_back({ rdl_bin_dram_bump,    {207,9007} });

drPassthruStack.push_back({ C4B,    {92,0} });
drPassthruStack.push_back({ C4T,    {172,0} });
drPassthruStack.push_back({ C4E,    {173,0} });


tsdr_tsv_checks @= {

	@ "TSV_TSDR_01: Illegal TSV Size";
	TSV not tsdr_tsv_widths;
	
	@ "TSV_TSDR_02: Illegal RDL Size";
	rdl_os_tsdr not tsdr_rdl_widths;
	
	@ "TSV_TSDR_03: Illegal LMI Size";
	LMIPAD not tsdr_lmi_widths;	
	
	@ "TSV_TSDR_04: TSV should interact with RDL.mg and RDL.cap (except Inline Etest Pad)";
	not_interacting(TSV not rdl_bin_etest_pad, rdl_os_tsdr and RDLCAP, include_touch=NONE);
	
	@ "TSV_TSDR_05: TSV cannot interact with RDL.pad, LMI, C4B, C4T, or C4E (except Inline Etest Pad)";
	interacting(TSV not rdl_bin_etest_pad, RDLPAD or LMIPAD or C4B or C4T or C4E, include_touch=ALL);
	
	// Equivalent to rdl_os_tsdr_07
	@ "TSV_TSDR_06: Wrong-sized RDL/RDLCAP drawn over the TSV OR RDL.mg is not line-on-line with RDL.cap";
	tsv_cand06 = TSV not_interacting rdl_bin_etest_pad;
	drEncloseAllDir(tsv_cand06, (rdl_os_tsdr and RDLCAP), RDL_07);
	(rdl_os_tsdr interacting RDLCAP) xor (rdl_os_tsdr and RDLCAP);
	
	// Equivalent to LMI_06
	@ "TSV_TSDR_07: Wrong-sized RDLPAD drawn over the LMI OR RDL.mg is not line-on-line with RDL.pad";
	lmipad_cand07 = LMIPAD not_interacting (rdl_bin_em_pad or lmi_dram_bump5);
	not_enclose_edge(lmipad_cand07, (rdl_os_tsdr and RDLPAD), distance = LMI_06, extension = NONE,intersecting = { TOUCH }, relational={POINT_TOUCH});
	not_enclose_edge(LMIPAD interacting rdl_bin_em_pad, rdl_os_tsdr, distance = LMI_06, extension = NONE,intersecting = { TOUCH }, relational={POINT_TOUCH});
	not_enclose_edge(LMIPAD interacting lmi_dram_bump5, (rdl_os_tsdr and RDLPAD), distance = 0, extension = NONE,intersecting = { TOUCH }, relational={POINT_TOUCH});
	(rdl_os_tsdr interacting RDLPAD) xor (rdl_os_tsdr and RDLPAD);

	@ "TSV_TSDR_08: Wrong combinition of TSV, RDL, LMI, C4* layers";
	rdl_os_tsdr not (rdl_bin_tsv or rdl_bin_etest_pad or rdl_bin_rf_pad or rdl_bin_em_pad or rdl_bin_dram_bump);
	
	//Etest pad construction checks
	@ "TSV_TSDR_09: Wrong construction of Etest pad";
	reg_etest_pad = (rdl_bin_etest_pad interacting lmi_etest_pad) not_interacting TSV;
	inline_etest_pad = (rdl_bin_etest_pad interacting TSV) not_interacting LMIPAD;
	rdl_bin_etest_pad not (reg_etest_pad or inline_etest_pad);
	
	//RF Pad construction checks
	@ "TSV_TSDR_10: Wrong construction of RF pad";
	rf_pad = (rdl_bin_rf_pad interacting lmi_rf_pad) interacting RDLPAD;
	rdl_bin_rf_pad not rf_pad;
	
	//EM Pad construction checks
	@ "TSV_TSDR_11: Wrong construction of EM pad";
	em_pad = (rdl_bin_em_pad interacting lmi_em_pad) not_interacting (RDLPAD or RDLCAP);
	rdl_bin_em_pad not em_pad;
	
	//rdl_os_tsdr DRAM Bump construction checks
	@ "TSV_TSDR_12: Wrong construction of RDL DRAM Bump";
	dram_bump = rdl_bin_dram_bump interacting (lmi_dram_bump1 or lmi_dram_bump2 or lmi_dram_bump3 or lmi_dram_bump4);
	dram_bump = (dram_bump interacting RDLPAD) not_interacting RDLCAP;
	rdl_bin_dram_bump not dram_bump;
	
} drErrorStack.push_back({tsdr_tsv_checks, {217,1201}});

#endif
/***********************************************************************
End --- Test chip TSV/RDL/LMI sizes and construction checks
***********************************************************************/


//Make sure TSV rules are only applied for Dot4 technology
//if (_drPROCESS != 4) {
//    err @= {
//        @ "TSV is allowed in P1273.4 technology only";
//        copy(TSV);
//    }
//    drErrorStack.push_back({ err, {1200,0}, "" });
//}

//Catchcup checks are not yet defined
//TSV catch cup construction checks - moved from p1273_common.rs
err @= {
    @ "CC_01: All catchcup clusters must be simple rectangle (without any holes).";
    not_rectangles(tsv_cc_bound);
}
drErrorStack.push_back({ err, {1200,1}, "" });

err @= {
    @ "CC_02: All edges of a catchcup cluster must be surrounded by guarding. Edges of catchcup clusters and guardring must abut.";
    not_rectangles(tsv_cc_bound or tsv_gr_bound);
    tsv_cc_bound and tsv_gr_bound;
}
drErrorStack.push_back({ err, {1200,2}, "" });

//RDL_CANTILEVER is not allowed now
err @= {
    @ "CC_03: Cantiliver LMI Pads are not allowed.";
    copy(RDL_CANTILEVER);
}
drErrorStack.push_back({ err, {1200,3}, "" });

//Error counter to keep track of debug layers
ct: integer = 100;

// ************************************ TSV_01 ***********************
drFixedSquareVia_(xc(TSV_01),TSV not tsdr_tsv_widths,TSV_01);



// ************************************ TSV_21/22/23 ***********************
//Combine TSV_21/22/23 into a single check

drHash[xc(TSV_21/22/23)] = "TSV-to-TSV separation within spine (in the direction of the spine), allowed value 1: "+TSV_21+",allowed value 2: "+TSV_22+",allowed value 3: "+TSV_23; 
drValHash[xc(TSV_21/22/23)] = 0;
drErrGDSHash[xc(TSV_21/22/23)] = drErrGDSHash[xc(TSV_21)];
   
err @= {
  @ GetRuleString(xc(TSV_21/22/23),"um"); note(CheckingString(xc(TSV_21)));
  //Since there are 3 fixed distances allowed in OGD, lets create three separate ogd zones
  tsv_ogd_cep = drCenterline(TSV, TSV_01, gate_dir);
  tsv_ogd_ce  = angle_edge(tsv_ogd_cep,angles=gate_angle);   
   //Find good edges based on three allowed distances(subtract drunit since centerline creates a polygon w/ width drunit)
  good_edge1 = external1_edge(tsv_ogd_ce,distance = TSV_21-drunit,
   extension = NONE, orientation = PARALLEL, direction = non_gate_dir);
  good_edge2 = external1_edge(tsv_ogd_ce,distance = TSV_22-drunit,
   extension = NONE, orientation = PARALLEL, direction = non_gate_dir);
  good_edge3 = external1_edge(tsv_ogd_ce,distance = TSV_23-drunit,
   extension = NONE, orientation = PARALLEL, direction = non_gate_dir);

  //Err if tsv polygon does not have above good edges 
  all_good_e = good_edge1 or_edge good_edge2 or_edge good_edge3;
  all_good_esize = edge_size(all_good_e, inside = drgrid, outside = drgrid);
  (TSV outside all_good_esize) not prs_cell_bound;

  drPassthruStack.push_back({ tsv_ogd_ce,        {ct,0} });//100
  drPassthruStack.push_back({ good_edge1,        {ct+1,0} });//101
  drPassthruStack.push_back({ good_edge2,        {ct+2,0} });//102
  drPassthruStack.push_back({ good_edge3,        {ct+3,0} });//103
  drPassthruStack.push_back({ all_good_esize,    {ct+4,0} });//104
  ct = ct+5;
}
drPushErrorStack(err, xc(TSV_21/22/23));


// ************************************ TSV_03 ***********************
Error_TSV_03 @= { 
 @ GetRuleString(xc(TSV_03),"um"); note(CheckingString(xc(TSV_03)));
 //TSV row-to-row separation within spine, only allowed value/////////
 
 TSV_centerline = drCenterline(TSV, TSV_01, non_gate_dir);
 tsv_pgd_ce     = angle_edge(TSV_centerline,angles=non_gate_angle);   
 good_pedge = external1_edge(tsv_pgd_ce,distance = TSV_03-drunit,
   extension = NONE, orientation = PARALLEL, direction = gate_dir);

 //Err if tsv polygon does not have above good edges 
 all_good_epsize = edge_size(good_pedge, inside = drgrid, outside = drgrid);
 (TSV outside all_good_epsize) not prs_cell_bound;
 drPassthruStack.push_back({ all_good_epsize,    {ct,0} });//105
 drPassthruStack.push_back({ tsv_pgd_ce,    	 {ct+1,0} });//106
 drPassthruStack.push_back({ good_pedge,    	 {ct+2,0} });//107
 ct = ct+3;
}
drPushErrorStack(Error_TSV_03, xc(TSV_03));

//Define TSV spine
//Based on conversation w/ Balaji, spine will always be surrounded by guard-ring, defined
//w/ cell names catch_cup_guard_cells
//Define spine as the cut-out hole, based on the guard-ring cells
tsv_spine = donut_holes(tsv_gr_bound);

drPassthruStack.push_back({ tsv_spine,     {ct,0} });//108
drPassthruStack.push_back({ tsv_gr_bound,  {ct+1,0} }); //109
ct = ct+2; 


// ************************************ TSV_04/05 ***********************
Error_TSV_0405 @= {
  TSV_0405_err: string = "TSV rows/columns in a single spine only allowed value: " + TSV_04 +"/"+ TSV_05;

  @"TSV_04/05: " + TSV_0405_err;  		
  note(CheckingString(TSV_0405_err));

  //Error if tsv_spine does not interact w/ fixed count of TSV polygons
  tsv_count = dtoi(TSV_04*TSV_05);
  note("\n Number of TSV polygons in a spline = " +tsv_count);
  not_interacting(tsv_spine,TSV,count = tsv_count);

  //Also to ensure that there are only 5 rows, use the edge_length of the tsv_spine 
  //and make sure that the length < 5*catchcup cell height
  //Find pgd edge
  tsv_spine_pgde = angle_edge(tsv_spine,angles=gate_angle);
  length_edge(tsv_spine_pgde, distance> TSV_05*TSV_62);

  drPassthruStack.push_back({ tsv_spine_pgde,	     {ct,0} });  //110
  ct = ct+1;
}
drPushErrorStack(Error_TSV_0405, xc(TSV_04));

tsv_cc_id = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_cc_cells_subset, depth=CELL_LEVEL);

// ************************************ TSV_06 ***********************
Error_TSV_06 @= {
  @ GetRuleString(xc(TSV_06),"um"); note(CheckingString(xc(TSV_06)));
  //TSV must be centered on the catch cup ////////////////////////////

  //Calculate fixed distance between catchcup and TSV
  tsv_ns: double = (TSV_62-TSV_01)/2;
  tsv_ew: double = (TSV_61-TSV_01)/2;
  tsv_extend = drGrow(TSV, N=tsv_ns, S=tsv_ns, E=tsv_ew, W=tsv_ew);

  //Only x11atsvcc is catch-cup, so create new id layer based on that
  //Adding TSDR specific cells for X11B - approved by Chris/Hemant/Balaji  
/*  #if (_drTSDR == _drYES)
      tsv_cc_id = copy_by_cells(layer1=CELLBOUNDARY, cells={"x11btsvcc_m3r"});
  #else*/
  //Nauman Khan: Feb 15, 2012
  // TSDR is also using the same catch cup cells - Bill Harris
  //    tsv_cc_id = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_cc_cells_subset); // mover it outside
/*  #endif*/

  //This will ensure that all TSV has catch-cup landing
  xor(tsv_extend,tsv_cc_id) not prs_cell_bound;

  drPassthruStack.push_back({ tsv_extend,	  {ct,0} });  //111
  drPassthruStack.push_back({ tsv_cc_id, 	  {ct+1,0} }); //112
  ct = ct+2; 
}
drPushErrorStack(Error_TSV_06, xc(TSV_06));


// ************************************ TSV_07 ***********************
Error_TSV_07 @= {
  @ GetRuleString(xc(TSV_07),"um"); note(CheckingString(xc(TSV_07)));
  //Transistor keepout from M1 catch cup grid (all sides) ////////////////////////////

  //Change from cc boundary to TSV boundary i.e. extend TSV boundary by TSV_07
  tsv_keepout      = size(tsv_cc_id not prs_cell_bound,TSV_07);
  //tsv_keepout = not(TSV, tsv_os);


  //No transistor (i.e. active gate from p1273_common.rs) in this zone
  interacting(gate,tsv_keepout, include_touch=NONE);    

  drPassthruStack.push_back({ tsv_keepout,  	  {ct,0} }); //113
  drPassthruStack.push_back({ gate, 	  	  {ct+1,0} }); //114
//  drPassthruStack.push_back({ tsv_os,   	  {ct,101} }); //113
  ct = ct+2;
}
drPushErrorStack(Error_TSV_07, xc(TSV_07));


// ************************************ TSV_08 ***********************
Error_TSV_08 @= {
  @ GetRuleString(xc(TSV_08),"um"); note(CheckingString(xc(TSV_08)));
  // Min transistor keepout zone from M1 catch cup grid (15% performance degradation)

  //Change from cc boundary to TSV boundary i.e. extend TSV boundary by TSV_08
  tsv_keepout     = size(tsv_cc_id not prs_cell_bound,TSV_08);
//  tsv_keepout = not(TOPCELLBOUNDARY,tsv_os);  

  //No transistor (i.e. active gate from p1273_common.rs) in this zone
  interacting(gate,tsv_keepout, include_touch=NONE);    

}
drPushErrorStack(Error_TSV_08, xc(TSV_08));


// ************************************ TSV_10 ***********************
Error_TSV_10 @= {
  @ GetRuleString(xc(TSV_10),"um"); note(CheckingString(xc(TSV_10)));
  //Number of allowed TSV spines

  //Use toplevel cell boundary and only for fullchip since we want to guarantee
  //that exactly 2 tsv_spine is used at fullchip
  #if ( _drFULL_DIE == _drYES )
    TOPCELLBOUNDARY not_interacting [count=dtoi(TSV_10)] tsv_spine;
  #endif
}
drPushErrorStack(Error_TSV_10, xc(TSV_10));


//RDL Rules ********************************************************
//New for 1273:
//RDL wire (217;0) is everywhere
//TSV CAP --> RDLCAP(217;10) and RDL(217;0)
//LMI PAD --> RDLPAD(217;40)/RDL_CANTILEVER(217;47) and RDL(217;0)

err @= {
    @ "RDL_err: RDLCAP(210;10)/RDLPAD(217;40/217;47) cannot be drawn outside RDL(217;0)";
    (RDLCAP not RDL) not prs_cell_bound;
    RDLPAD not RDL;
    RDL_CANTILEVER not RDL;

    //ANother sanity check -- if pure RDLwires are removed, then remaining RDL must be
    //line-line with RDLCAP, RDLPAD, RDL_CANTILEVER
    RDL_os = drUnderOver(RDL,RDL_02/2);

    @ "RDL_err2: RDL(217;0) under RDLCAP(210;10)/RDLPAD(217;40/217;47) must be line-line with those ID's";
    (RDL_os xor (RDLCAP or RDLPAD or RDL_CANTILEVER)) not (rdl_waiver or rdl_ring_assmb_mark_waiver or prs_cell_bound);

    drPassthruStack.push_back({ RDL_os,  {ct,0} }); //115
    ct = ct+1;
}
drErrorStack.push_back({ err, {217,2000}, "" });

//New global defs used everywhere
//RDLPAD (217;40)
//RDL_CANTILEVER (217;47)
//RDLCAP (217;10)
rdlpad_new   = RDLPAD and RDL;
rdlcanti_new = RDL_CANTILEVER and RDL;
rdlcap_new   = RDLCAP and RDL;
rdlwire	     = RDL not (RDLPAD or RDL_CANTILEVER or RDLCAP or prs_rdl);

drPassthruStack.push_back({ rdlwire,        {900,902} });

// ************************************ RDL_01 ***********************
//Global min width for RDL including RDLwire, RDL under RDLCAP ID, RDLPAD ID
drMinWidth_(xc(RDL_01), RDL not rdl_ring_assmb_mark_waiver, RDL_01);

// ************************************ RDL_02 ***********************
//Looks only for RDLwire max width
drMaxWidth_(xc(RDL_02), rdlwire not (rdl_waiver or rdl_ring_assmb_mark_waiver), RDL_02);


// ************************************ RDL_03 ***********************
//RDLPAD fixed width, in all direction ////////////////////////////
drFixedSquareVia_(xc(RDL_03),rdlpad_new not tsdr_rdl_widths,RDL_03);
drFixedSquareVia_(xc(RDL_03),rdlcanti_new,RDL_03);


// ************************************ RDL_04 ***********************
//RDLCAP fixed width, in all direction ////////////////////////////
drFixedSquareVia_(xc(RDL_04),rdlcap_new not tsdr_rdl_widths,RDL_04);


// ************************************ RDL_05 ***********************
//Global all around space check for RDL including RDLwire, RDL under RDLCAP ID, RDLPAD ID
drMinSpace_(xc(RDL_05), RDL not rdl_ring_assmb_mark_waiver, RDL_05);

//Some common defs to be used in RDL_08/09/06/14 checks
//First find the outside_touching of RDLWIRE w/ rdlcap_new and then extend that using
// p1270grid(1 nm) polygon which will preserve the orthogonal shape
rdlwire_pad_e  = outside_touching_edge(rdlwire,rdlpad_new);
rdlwire_pad_p  = edge_size(rdlwire_pad_e, outside = drgrid);

rdlwire_cap_e  = outside_touching_edge(rdlwire,rdlcap_new);
rdlwire_cap_p  = edge_size(rdlwire_cap_e, outside = drgrid);

drPassthruStack.push_back({ rdlwire_pad_e,  {ct,0} }); //116
drPassthruStack.push_back({ rdlwire_pad_p,  {ct+1,0} }); //117
drPassthruStack.push_back({ rdlwire_cap_e,  {ct+2,0} }); //118
drPassthruStack.push_back({ rdlwire_cap_p,  {ct+3,0} }); //119
ct = ct+4;


// ************************************ RDL_14 ***********************
Error_RDL_14 @= {
  @ GetRuleString(xc(RDL_14),"um"); note(CheckingString(xc(RDL_14)));
  // RDL space to RDLCAP, minimum


//  1271 code
// //Before we do min space check, need to remove those RDLwires that touch rdlcap_new at 90degree
// //since that is allowed by design.
// //From the rdlwire_cap_e, find those that make 0 degree w/ x-axis ==> this will give
// //those 90degree lines that RDLwire makes w/ rdlcap_new
// //Need to consider both pgd/ogd connections, hence use angles=0,90
// rdlwire_cap_angle = angle_edge(rdlwire_cap_e,angles={0,90});
//
//
// //Now extend the rdlcap_new edge (that touches the RDLWIRE) outward to 1.67
// //this is the distance where RDLwire to rdlcap_new distancewill be waived
// //Use the already selected 90 degree lines that RDLwire makes w/ rdlcap_new
// rdlcap_extend  = edge_size(rdlwire_cap_angle, inside = RDL_14 );
//
// //Find the RDL_modified, after removing this waived zone from RDL 
// RDLwire_capmod = not(rdlwire, rdlcap_extend);
//	
// //Now do simple minspace check - in all direction - replace rdlcap_new w/ RDL_modify
// tmp_err = external2(rdlcap_new,RDLwire_capmod,distance<RDL_14,extension=RADIAL,
//	    intersecting={ACUTE,TOUCH},relational={POINT_TOUCH,OVERLAP});
//
// #ifdef _drDEBUG
//   drPassthruStack.push_back({ rdlwire_cap_angle,  	{ct,0} });   //113
//   drPassthruStack.push_back({ rdlcap_extend,      	{ct+1,0} }); //114
//   drPassthruStack.push_back({ RDLwire_capmod,        	{ct+2,0} }); //115
//   drPassthruStack.push_back({ tmp_err,        	{ct+3,0} }); //116
//
// #endif
//
//
//
   ct = ct+4;
  //Do a simple min space between RDLCAP and RDLWIRE --> any line-line touch (wrapped around the corner) 
  //case will be captured by RDL_08
  external2(rdlcap_new,rdlwire,distance<RDL_14,extension=RADIAL,
	    intersecting={ACUTE},relational={POINT_TOUCH,OVERLAP});

}
drPushErrorStack(Error_RDL_14, xc(RDL_14));


// ************************************ RDL_15 ***********************
Error_RDL_15 @= {
  @ GetRuleString(xc(RDL_15),"um"); note(CheckingString(xc(RDL_15)));
  external2(rdlpad_new or rdlcanti_new,rdlwire,distance<RDL_15,extension=RADIAL, intersecting={ACUTE},relational={POINT_TOUCH,OVERLAP});
}
drPushErrorStack(Error_RDL_15, xc(RDL_15));


// ************************************ RDL_06 ***********************
Error_RDL_06 @= {
  @ GetRuleString(xc(RDL_06),"um"); note(CheckingString(xc(RDL_06)));
  // RDL space to rdlpad_new center, minimum (OR RDL space to synthesized circular rdlpad_new of 1.67um

  rdl_total = or(rdlpad_new,rdlcanti_new);  

  //Need to define rdlwire_pad_e based on rdl_total
  rdlwire_tot_e  = outside_touching_edge(rdlwire,rdl_total);

  //For now, lets test using polygon to wire distance check
  //First shrink rdl_total to drunit
  sh :double = (RDL_03/2-drgrid); //Create a square of size drgrid (0.001um)
  rdlpad_us = size(rdl_total,-sh);

  //Before we do min space check, need to remove those RDLwires that touch rdl_total at 90degree
  //since that is allowed by design.
  //From the rdlwire_pad_e, find those that make 0 degree w/ x-axis ==> this will give
  //those 90degree lines that RDLwire makes w/ rdl_total
  //Need to consider both pgd/ogd connections, hence use angles=0,90
  rdlwire_pad_angle = angle_edge(rdlwire_tot_e,angles={0,90});


  //Now extend the rdl_total edge (that touches the RDLWIRE) outward to 4.892
  //12.67-(15.556/2) = 4.892 --> this is the distance where the RDLWIRE (w/ 90degree)
  //will be waived
  //Use the already selected 90 degree lines that RDLwire makes w/ rdl_total
  rdlpad_extend  = edge_size(rdlwire_pad_angle, inside = (RDL_06-RDL_03/2) );

  //Find the RDL_modified, after removing this waived zone from RDL
  RDLwire_padmod = not(rdlwire, rdlpad_extend);
	
  //Now do simple minspace check - in all direction - replace RDL w/ RDL_modify
  //Since bounding box is 2um (0.002), distance RDL_06 should be reduced by 0.001
  external2(rdlpad_us,RDLwire_padmod,distance<(RDL_06-0.001),extension=RADIAL,
	    intersecting={ACUTE,TOUCH},relational={POINT_TOUCH,OVERLAP});

  #ifdef _drDEBUG
    drPassthruStack.push_back({ rdlwire_tot_e,		{ct,0} });   //120
    drPassthruStack.push_back({ rdlpad_us,		{ct+1,0} }); //121
    drPassthruStack.push_back({ rdlwire_pad_angle,  	{ct+2,0} }); //122
    drPassthruStack.push_back({ rdlpad_extend,      	{ct+3,0} }); //123
    drPassthruStack.push_back({ RDLwire_padmod,        	{ct+4,0} }); //124
    ct = ct+5;
  #endif
}
drPushErrorStack(Error_RDL_06, xc(RDL_06));

// ************************************ RDL_07 ***********************
drEncloseAllDir_(xc(RDL_07), TSV, rdlcap_new, RDL_07);


// ************************************ RDL_08 ***********************
Error_RDL_08 @= {
  @ GetRuleString(xc(RDL_08),"um"); note(CheckingString(xc(RDL_08)));
  //RDL wire offset from rdlpad_new center axis, maximum ///////////////////

  //Lets use centerline_edge command to find centerlines for rdlpad_new (both OGD, PGD)
  rdlpad_cline_pgd = drCenterline(rdlpad_new, RDL_03, gate_dir);
  rdlpad_cline_ogd = drCenterline(rdlpad_new, RDL_03, non_gate_dir);

   
  //Since RDLWIRE is non-orthologal, cannot use centerline_edge
  //First need to find out if rdlwire_pad_p is ogd or pgd
  rdlwire_unit_pgd = drWidth(rdlwire_pad_p,drgrid,gate_dir);
  rdlwire_unit_ogd = drWidth(rdlwire_pad_p,drgrid,non_gate_dir);

  //Now find centerlines for ogd/pgd accordingly
  //Make this wire length arbitrarily long, otherwise we will miss if RDL wire length > RDL_02
  RDL_wiremax_length = 20.0;
  rdlwire_cline_pgd = drCenterline(rdlwire_unit_pgd, RDL_wiremax_length, gate_dir);
  rdlwire_cline_ogd = drCenterline(rdlwire_unit_ogd, RDL_wiremax_length, non_gate_dir);

  //Error if rdlwire center is outisde rdlpad center
  not(rdlwire_cline_pgd,rdlpad_cline_pgd);
  not(rdlwire_cline_ogd,rdlpad_cline_ogd);


//  //Alternate approach to simplify code -- won't work w/ the cases that are outside touching wrapped around on the side
//  rdlwire_cline_pgd_temp = drCenterline(rdlwire, RDL_02, gate_dir);
//  rdlwire_cline_ogd_temp = drCenterline(rdlwire, RDL_02, non_gate_dir);
//
//  //Only consider those rdlwire_cline_pgd/ogd that are touching rdlpad_new
//  rdlwirepad_pgd =  rdlwire_cline_pgd_temp outside_touching rdlpad_new;
//  rdlwirepad_ogd =  rdlwire_cline_ogd_temp outside_touching rdlpad_new;
//
//  check_err_pgd = rdlwirepad_pgd not_interacting [include_touch = ALL] rdlpad_cline_pgd;
//  check_err_ogd = rdlwirepad_ogd not_interacting [include_touch = ALL] rdlpad_cline_ogd;
//
  #ifdef _drDEBUG
    drPassthruStack.push_back({ rdlpad_cline_pgd,        {ct,0} });    //125
    drPassthruStack.push_back({ rdlwire_unit_pgd,        {ct+1,0} });  //126
    drPassthruStack.push_back({ rdlwire_cline_pgd,       {ct+2,0} });  //127
    drPassthruStack.push_back({ rdlpad_cline_ogd,        {ct+3,0} });  //128
    drPassthruStack.push_back({ rdlwire_unit_ogd,        {ct+4,0} });  //129   
    drPassthruStack.push_back({ rdlwire_cline_ogd,       {ct+5,0} });  //130
//    drPassthruStack.push_back({ rdlwire_cline_pgd_temp,       {ct+6,0} });  //128
//    drPassthruStack.push_back({ rdlwire_cline_ogd_temp,       {ct+7,0} });  //129
//    drPassthruStack.push_back({ check_err_pgd,       	      {ct+8,0} });  //130
//    drPassthruStack.push_back({ check_err_ogd,       	      {ct+9,0} });  //131
    ct = ct+6;
  #endif
}
drPushErrorStack(Error_RDL_08, xc(RDL_08));


// ************************************ RDL_09 ***********************
//First need to find out if rdlwire_cap_p is ogd or pgd
rdlwire_capunit_pgd = drWidth(rdlwire_cap_p,drgrid,gate_dir);
rdlwire_capunit_ogd = drWidth(rdlwire_cap_p,drgrid,non_gate_dir);

drEncloseDir_(xc(RDL_09),rdlwire_capunit_pgd, rdlcap_new , RDL_09, non_gate_dir);
drEncloseDir_(xc(RDL_09),rdlwire_capunit_ogd, rdlcap_new , RDL_09, gate_dir);

#ifdef _drDEBUG
  drPassthruStack.push_back({ rdlwire_capunit_pgd,  {ct,0} }); //131
  drPassthruStack.push_back({ rdlwire_capunit_ogd,  {ct+1,0} }); //132
  ct = ct+2; //Next counter starts at 132   
#endif

//Common defs for RDL_10/11 checks

//Find the interior vertex at 135
rdl_vertex = vertex(RDL, angles={135, 225}, shape= SQUARE_CENTERED, shape_size = drgrid);

drPassthruStack.push_back({ rdl_vertex,       {ct,0} }); //133
ct = ct+1;


// ************************************ RDL_10 ***********************
Error_RDL_10 @= {
  @ GetRuleString(xc(RDL_10),"um"); note(CheckingString(xc(RDL_10)));
  // RDL wire vertex space to RDLPAD, minimum
  

  //Now do a simple external check between 2 layers
  external2(rdl_vertex, rdlpad_new, distance < (RDL_10-drgrid/2), intersecting = {TOUCH,ACUTE},
      extension = NONE_INCLUSIVE, relational={POINT_TOUCH, OVERLAP},
      direction = gate_dir);

  //Now check error in non_gate_dir    
  external2(rdl_vertex, rdlpad_new, distance < (RDL_10-drgrid/2), intersecting = {TOUCH,ACUTE},
      extension = NONE_INCLUSIVE, relational={POINT_TOUCH, OVERLAP},
      direction = non_gate_dir);
}
drPushErrorStack(Error_RDL_10, xc(RDL_10));


// ************************************ RDL_11 ***********************
Error_RDL_11 @= {
  @ GetRuleString(xc(RDL_11),"um"); note(CheckingString(xc(RDL_11)));
  // RDL wire vertex space to RDLCAP, minimum
  

  //Now do a simple external check between 2 layers
  external2(rdl_vertex, rdlcap_new, distance < (RDL_11-drgrid/2), intersecting = {TOUCH,ACUTE},
      extension = NONE_INCLUSIVE, relational={POINT_TOUCH, OVERLAP},
      direction = gate_dir);

  //Now check error in non_gate_dir    
  external2(rdl_vertex, rdlcap_new, distance < (RDL_11-drgrid/2), intersecting = {TOUCH,ACUTE},
      extension = NONE_INCLUSIVE, relational={POINT_TOUCH, OVERLAP},
      direction = non_gate_dir);
}
drPushErrorStack(Error_RDL_11, xc(RDL_11));


// ************************************ RDL_12 ***********************
Error_RDL_12 @= {
  @ GetRuleString(xc(RDL_12),"um"); note(CheckingString(xc(RDL_12)));
  // Only one RDL wire connection allowed per semicircle for an RDLPAD or RDLCAP

  //First find rdlpad_new/rdlcap_new making 2 connections w/ RDLwires
  rdlwire_2i_pad = interacting(rdlpad_new,rdlwire,count >=2);
  rdlwire_2i_cap = interacting(rdlcap_new,rdlwire,count >=2);

  //Find the rdlwire edge touching rdlpad_new/rdlcap_new
  rdlpad_e = outside_touching_edge(rdlwire_2i_pad,rdlwire);
  rdlcap_e = outside_touching_edge(rdlwire_2i_cap,rdlwire);  

  //Error if length_edge > rdlpad_new/rdlcap_new size
  length_edge(rdlpad_e, distance>RDL_03, corners=CONNECT);  
  length_edge(rdlcap_e, distance>RDL_04, corners=CONNECT);  

  drPassthruStack.push_back({ rdlwire_2i_pad,       {ct,0} });   //134
  drPassthruStack.push_back({ rdlwire_2i_cap,       {ct+1,0} }); //135
  drPassthruStack.push_back({ rdlpad_e,             {ct+2,0} }); //136
  drPassthruStack.push_back({ rdlcap_e,             {ct+3,0} }); //137
  ct = ct+4;
}
drPushErrorStack(Error_RDL_12, xc(RDL_12));


// ************************************ RDL_13 ***********************
//This does not need a drc check


// ************************************ RDL_16 ***********************
Error_RDL_16 @= {
  @ GetRuleString(xc(RDL_16),"um"); note(CheckingString(xc(RDL_16)));
  rdl_valid_length = 2*(RDL_16+RDL_01);
  not_length_edge(rdlwire not rdl_ring_assmb_mark_waiver, <=RDL_16); 
}
drPushErrorStack(Error_RDL_16, xc(RDL_16));


//LMI Rules ********************************************************


//Approved by Kalyan (1/11/2013): LMI rules for X73B will be using older Gen1 specs
#if (_drPROJECT == _drx73b) 
   //Certain dr values specific for X73B, hence hard-coding since POR dr file is for Rev0 Redbook and for product design
//   LMI_02 = 50;
//   LMI_04 = 120;
//   LMI_05 = 350;
//   LMI_12 = 50;
   LMI_13 = 428; // value change is the final layout.
#endif

// ************************************ LMI_01 ***********************
drFixedSquareVia_(xc(LMI_01),LMIPAD not (lmi_waiver or tsdr_lmi_widths), LMI_01);

// ************************************ Common def ***********************
//For LMI_02/03/04/05, need to first merge the array and then carry out the checks
//TO find the separation distance, grow/shrink
lmidist_pgd: double = (LMI_03-LMI_01)/2;
lmidist_ogd: double = (LMI_02-LMI_01)/2;
lmi_array_pgd = drShrink(drGrow(LMIPAD not lmi_waiver,N=lmidist_pgd,S=lmidist_pgd),N=lmidist_pgd,S=lmidist_pgd);
lmi_array     = drShrink(drGrow(lmi_array_pgd,E=lmidist_ogd,W=lmidist_ogd),E=lmidist_ogd,W=lmidist_ogd);


//Find the separation between the lmi_array (merged earlier)
//(1/10/2013):Since LMI_04/05 def has changed, it was previously center-center and now side-side,
//hence just add LMI_01 value to LMI_04/LMI_05 and keep rest of code the same

//NHK: LMI_04 & LMI_05 are still center-to-center
//LMI_04 = LMI_04 + LMI_01;
//LMI_05 = LMI_05 + LMI_01;
lmild_pgd : double = (LMI_04 - LMI_01)/2;
lmild_ogd : double = (LMI_05 - LMI_01)/2;

temp_grow = drGrow(lmi_array,N=lmild_pgd,S=lmild_pgd);

//Again for this, synthesize a large lmi_subarray combininb the individual
lmi_square_pgd = drShrink(drGrow(lmi_array,N=lmild_pgd,S=lmild_pgd),
		                      N=lmild_pgd,S=lmild_pgd);
lmi_square     = drShrink(drGrow(lmi_square_pgd,E=lmild_ogd,W=lmild_ogd),
		                      E=lmild_ogd,W=lmild_ogd);

//Need this def for a couple of checks: remove any lmi_square that interacts w/ rdlcanti_new pads
lmi_square_mod = not_interacting(lmi_square,rdlcanti_new);

//PGD: (i.e. 5*40  +14.142 = 214.142), mark as error
//OGD:(i.e. 49*50 +14.142 = 2464.142), mark as error
//LMI_array_row = 6; --> replaced by LMI_11
//LMI_array_column = 50; -->  replaced by LMI_12

array_pgd_dist = (LMI_11-1)*LMI_03 + LMI_01;
array_ogd_dist = (LMI_12-1)*LMI_02 + LMI_01;

//Dist = (i.e. 2*(49*50 +14.142 = 2464.142)+(320-14.142)=5234.142
square_pgd_dist = 2*array_pgd_dist  + (LMI_04-LMI_01);
square_ogd_dist = 2*array_ogd_dist  + (LMI_05-LMI_01);

//In order to make square, required distance in N/S
square_pgd_extension = (square_ogd_dist - square_pgd_dist)/2; //6788.284um in 1273(product)
//First take the merged lmi array and size up by calculated value = 2350um per side
lmi_region = drGrow(lmi_square_mod,N=square_pgd_extension,S=square_pgd_extension);

drPassthruStack.push_back({ lmi_array_pgd,	  {ct,0} });   //142
drPassthruStack.push_back({ lmi_array,	  	  {ct+1,0} }); //143
drPassthruStack.push_back({ lmi_square_pgd, 	  {ct+2,0} }); //144
drPassthruStack.push_back({ lmi_square,     	  {ct+3,0} }); //145
drPassthruStack.push_back({ lmi_square_mod, 	  {ct+4,0} }); //146
drPassthruStack.push_back({ lmi_region,	  	  {ct+5,0} }); //147
ct = ct+6;



// ************************************ LMI_02/03 ***********************
// Combine LMI_02, LMI_03 into one check since we merge LMI into an array
Error_LMI_02_03 @= {
  LMI_0203_err: string = "LMI-to-LMI separation orthogonal/parallel to TSV spine direction (center-to-center), only allowed value in std array in OGD/PGD = 50um/40um respectively";

  @"LMI_02/03: " + LMI_0203_err;  		
  note(CheckingString(LMI_0203_err));

  //Merged  lmi_array should not have a hole. If there is a hole i.e. space > LMI_02 will flag
  //donuts(lmi_array);
  //Need to use not_rectangles to capture non-hole error
  not_rectangles(lmi_array);

  //Standard LMI array is defined by 50 columns/rows(PGD) and 6 rows/columns(OGD)
  //Need to count both rows and columns in the above defined array
  //One way to do that is to calculate the exact OGD/PGD edge length of the lmi_array

  //For this check, remove any lmi_array that interacts w/ rdlcanti_new pads
  lmi_array_mod = not_interacting(lmi_array,rdlcanti_new);

  //Find PGD, OGD edge
  lmi_array_pgde = angle_edge(lmi_array_mod,angles=gate_angle);
  lmi_array_ogde = angle_edge(lmi_array_mod,angles=non_gate_angle);

  //Error if the pgd edge != 6 columns (i.e. 5*40  +14.142 = 214.142), mark as error
  //Error if the ogd edge != 50 columns(i.e. 49*50 +14.142 = 2464.142), mark as error
  not_length_edge(lmi_array_pgde, distance= array_pgd_dist);
  not_length_edge(lmi_array_ogde, distance= array_ogd_dist);

  drPassthruStack.push_back({ lmi_array_mod,    {ct,0} });   //148
  drPassthruStack.push_back({ lmi_array_pgde,	{ct+1,0} }); //149     
  drPassthruStack.push_back({ lmi_array_ogde,   {ct+2,0} }); //150
  ct = ct+3;
}
drPushErrorStack(Error_LMI_02_03, xc(LMI_02));


// ************************************ LMI_04/05 ***********************
// Combine LMI_04, LMI_05 into one check since we merge LMI into an array
Error_LMI_04_05 @= {
  LMI_0405_err: string = "LMI-to-LMI separation of different arrays orthogonal/parallel to TSV spine direction (center-to-center), only allowed value in PGD/OGD respectively";

  @"LMI_04/05: " + LMI_0405_err;  		
  note(CheckingString(LMI_0405_err));

  //These are no longer necessary and makes it harder to find the error
  //Merged  lmi_array should not have a hole. If there is a hole i.e. space > LMI_04 will flag
  //donuts(lmi_square);
  //Need to use not_rectangles to capture non-hole error
  not_rectangles(lmi_square);


  //Now use the same def of LMI array to find fixed array-array space
  //Use lmi_square_mod to remove the LMI pads that are not part of array def
  //Find PGD, OGD edge
  lmi_square_pgde = angle_edge(lmi_square_mod,angles=gate_angle);
  lmi_square_ogde = angle_edge(lmi_square_mod,angles=non_gate_angle);

  //Error if the pgd edge != (i.e. 2*(5*40+14.142=214.142)+(120-14.142)=534.142, mark as error
  //Error if the ogd edge != (i.e. 2*(49*50 +14.142 = 2464.142)+(320-14.142)=5234.142, mark as error
  //1273 values based on Rev0: ogd=6788.284, pgd=523.284
  not_length_edge(lmi_square_pgde, distance= square_pgd_dist);
  not_length_edge(lmi_square_ogde, distance= square_ogd_dist);

  #ifdef _drDEBUG
    drPassthruStack.push_back({ lmi_square_pgde, {ct,0} });   //151       
    drPassthruStack.push_back({ lmi_square_ogde, {ct+1,0} }); //152
    ct = ct+2;
  #endif
}
drPushErrorStack(Error_LMI_04_05, xc(LMI_04));


// ************************************ LMI_06 ***********************
Error_LMI_06 @= {
  @ GetRuleString(xc(LMI_06),"um"); note(CheckingString(xc(LMI_06)));
  // RDLPAD enclosure of LMI (all sides), fixed
  // RDL_CANTILEVER enclosure of LMI (all sides), fixed

  //(5/11/2011): After discussion w/ Chris, it makes sense to "or" the two layers and then check for LMI_06
  //OK, it should be checking that the LMI feature (218;0) is enclosed by either an RDL_pad feature (217;40) or RDL_cantilever feature (217;47) by 0.707um on all sides

  rdl_total = or(rdlpad_new,rdlcanti_new);  

  not_enclose_edge(LMIPAD not lmi_waiver, rdl_total, distance = LMI_06, extension = NONE,intersecting = { TOUCH }, relational={POINT_TOUCH}); 
}
drPushErrorStack(Error_LMI_06, xc(LMI_06));


// ************************************ LMI_07 ***********************
//Error_LMI_07 @= {
//  @ GetRuleString(xc(LMI_07),"um"); note(CheckingString(xc(LMI_07)));
  // Outrigger LMI pads will not extend beyond the square that encloses the standard LMI array
  
  //Any Cantilever LMI pads outside this lmi_region is an error
//  not(rdlcanti_new,lmi_region);
//}
//drPushErrorStack(Error_LMI_07, xc(LMI_07));


// ************************************ LMI_08 ***********************
//Error_LMI_08 @= {
//  @ GetRuleString(xc(LMI_08),"um"); note(CheckingString(xc(LMI_08)));
  // Outrigger LMI pads must be centered with the standard LMI array along the central axis

//  RDL_CANTILEVER_MAX_CD: const double = RDL_03;
//  LMI_REGION_MAX_CD:     const double = square_ogd_dist; //5234.142;

  //Lets use centerline_edge command to find centerlines for rdlcanti_new (in PGD)
//  rdlcanti_cline_pgd = drCenterline(rdlcanti_new, RDL_CANTILEVER_MAX_CD, gate_dir);
  
  //Use the lmi_region from above check to 
//  lmi_region_cline_pgd = drCenterline(lmi_region, LMI_REGION_MAX_CD, gate_dir);

  //Error if both centerlines are not co-incident
//  not(rdlcanti_cline_pgd,lmi_region_cline_pgd);

//  #ifdef _drDEBUG
//    drPassthruStack.push_back({rdlcanti_cline_pgd,	  {ct,0} });   //153
//    drPassthruStack.push_back({lmi_region_cline_pgd,	  {ct+1,0} }); //154
    ct = ct+2;
//  #endif  
//}
//drPushErrorStack(Error_LMI_08, xc(LMI_08));

// ************************************ LMI_09/10 ***********************
//Error_LMI_0910 @= {
//  LMI_0910_err: string = "RDL Cantilever PAD rows/columns in Cantilever array only allowed value: " + LMI_09 +"/"+ LMI_10;

//  @"LMI_09/10: " + LMI_0910_err;  		
//  note(CheckingString(LMI_0910_err));

  //Find the lmi_array_pgd (defined above) that interacts w/ rdlcanti_new
//  lmi_cantiarray = interacting(lmi_array_pgd,rdlcanti_new);

  //Also to ensure that this is fixed configuration of 1x10, 
  //use the edge_length of the lmi_cantiarray
  //and make sure that pgd edge meet the correct dimension
  //Only to ensure pgd edge since in OGD, there is only 1 column which means
  //the width is already checked by LMI_01 value
//  canti_dist_pgd = (LMI_10-1)*LMI_03 + LMI_01;
//  lmi_carray_pgde = angle_edge(lmi_cantiarray,angles=gate_angle);

  //Error if the above edges are not exact values
//  not_length_edge(lmi_carray_pgde, distance= canti_dist_pgd);

//  #ifdef _drDEBUG
//    drPassthruStack.push_back({ lmi_cantiarray,	     {ct,0} });    //155
//    drPassthruStack.push_back({ lmi_carray_pgde,     {ct+1,0} });  //156
    ct = ct+2;
//  #endif
//}
//drPushErrorStack(Error_LMI_0910, xc(LMI_09));

// ************************************ LMI_13/14 ***********************
//Intent of this check is to check for EOA to LMI extent
lmi_extent = layer_extent(LMIPAD not lmi_waiver);
drEncloseDir_(xc(LMI_13),lmi_extent,EOA,LMI_13,non_gate_dir);
//drEncloseDir_(xc(LMI_14),lmi_extent,EOA,LMI_14,gate_dir);

drPassthruStack.push_back({ lmi_extent,     {ct,0} });  //157
ct =ct+1;

// ************************************ LMI_40 ***********************
Error_LMI_40 @= {
  @ GetRuleString(xc(LMI_40),"um"); note(CheckingString(xc(LMI_40)));

  die_cep = drCenterline(EOA, 15000, non_gate_dir); 
  #if ( _drFULL_DIE == _drYES ) //if die size is bigger than 15,000 micron
     if (layer_empty(die_cep)) {
	    copy(TOPCELLBOUNDARY);   
	 }
  #endif
  
  die_cep_os = drGrow(die_cep, N = LMI_40, S = LMI_40);
  lmi_cep = drCenterline(LMIPAD, LMI_01, non_gate_dir); 
  LMIPAD interacting (lmi_cep not die_cep_os);

drPassthruStack.push_back({ die_cep,     {ct,0} });  //158
drPassthruStack.push_back({ lmi_cep,     {ct+1,0} });  //159
drPassthruStack.push_back({ die_cep_os,     {ct+2,0} });  //160

ct =ct+3;


}
drPushErrorStack(Error_LMI_40, xc(LMI_40));

// ************************************ LMI_41 ***********************
Error_LMI_41 @= {
  @ GetRuleString(xc(LMI_41),"um"); note(CheckingString(xc(LMI_41)));
  
  eoa_vertex = vertex(EOA, angles={90}, shape= SQUARE_CENTERED, shape_size = drgrid);
  eoa_vertex_os = size(eoa_vertex, LMI_41) and EOA;
  LMIPAD interacting eoa_vertex_os;

drPassthruStack.push_back({ eoa_vertex,     {ct,0} });  //161
drPassthruStack.push_back({ eoa_vertex_os,     {ct+1,0} });  //162
ct =ct+2;

}
drPushErrorStack(Error_LMI_41, xc(LMI_41));


#if 0
//(2/23): ST New Via Density rule
err @= {
    @ "CC_VIAdenErr: All area within the catch cup footprint needs to be covered by a V2 service area";
     
    //First find all V2 types inside CC cells
    V2_cc = VIA2 inside tsv_cc_bound;     
    V2_A  = drRectangularVia( V2_cc, V2_01,  V2_02 );
    V2_AP = drRectangularVia( V2_cc, V2P_01, V2P_02);
    V2_B  = drRectangularVia( V2_cc, V2_03,  V2_04 );
    V2_BP = drRectangularVia( V2_cc, V2_93,  V2_94 );
    V2_C  = drRectangularVia( V2_cc, V2_05,  V2_06 );
    V2_CP = drRectangularVia( V2_cc, V2P_05, V2P_06);
    V2_D  = drRectangularVia( V2_cc, V2_07,  V2_08 );
    V2_E  = drRectangularVia( V2_cc, V2_09,  V2_10 );
    V2_F  = drRectangularVia( V2_cc, V2_11,  V2_12 );
    V2_G  = drRectangularVia( V2_cc, V2_13,  V2_14 );

    //Sanity check to make sure that there are no other via's inside cc other than 
    //the ones specified
    V2_cc not (V2_A or V2_AP or V2_B or V2_BP or V2_C or V2_CP or V2_D or V2_E or
    	       V2_F or V2_G);

    //Now size each via type by specified amount in OGD and PGD
    //N,S = PGD E,W = OGD 
    V2_A_os  = drGrow(V2_A,  N=0.06,  S=0.06,  E=0.8135, W=0.8135);
    V2_AP_os = drGrow(V2_AP, N=0.06,  S=0.06,  E=0.8945, W=0.8945);
    V2_B_os  = drGrow(V2_B,  N=0.06,  S=0.06,  E=1.22,   W=1.22);
    V2_BP_os = drGrow(V2_BP, N=0.136, S=0.136, E=0.8865, W=0.8865);
    V2_C_os  = drGrow(V2_C,  N=0.140, S=0.140, E=0.5355, W=0.5355);
    V2_CP_os = drGrow(V2_CP, N=0.140, S=0.140, E=0.589,  W=0.589);
    V2_D_os  = drGrow(V2_D,  N=0.150, S=0.150, E=0.7935, W=0.7935);
    V2_E_os  = drGrow(V2_E,  N=0.150, S=0.150, E=0.9915, W=0.9915);
    V2_F_os  = drGrow(V2_F,  N=0.136, S=0.136, E=1.478,  W=1.478);
    V2_G_os  = drGrow(V2_G,  N=0.12,  S=0.12,  E=0.8945, W=0.8945);

    via2_sizeall = V2_A_os or V2_AP_os or V2_B_os or V2_BP_os or
                   V2_C_os or V2_CP_os or V2_D_os or V2_E_os or
		   V2_F_os or V2_G_os;
   
    //For this check only use the tsvcc cells, not the one defined in dr_cell_lists
    //as per conversation w/ Chris Pelto (2/24)
    tsv_cc_bound_new = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_cc_cells_subset);

    //260nm value agreed upon by Chris, Balaji, Gerry (2/24)
    tsv_cc_shrink   = drShrink(tsv_cc_bound_new, N= 0.260, S=0.260);
    		   
    //Anything inside cc that is not covered by this oversized via is err
    //Email from Chris Pelto - shrink the cc boundary by 260nm 
    tsv_cc_shrink not via2_sizeall;

    drPassthruStack.push_back({ tsv_cc_bound,	     {ct,0} });    //153
    drPassthruStack.push_back({ via2_sizeall,        {ct+1,0} });  //154
    drPassthruStack.push_back({ V2_cc,        	     {ct+2,0} });  //155
    drPassthruStack.push_back({ tsv_cc_shrink,	     {ct+3,0} });  //156
    drPassthruStack.push_back({ tsv_cc_bound_new,    {ct+4,0} });  //157
    ct = ct+5; //Next counter starts at 158
}
drErrorStack.push_back({ err, {1200,3}, "" });
#endif //#if 0 


/*Standard-design-compliance of layers above Via2 drawn over the TSV GR */
drErrGDSHash[xc(TSV_CC_SDC)] = {217, 1205};
drHash[xc(TSV_CC_SDC)] = "TSV_CC_SDC: SDC* layers should completely overlap the Catch-cup guard-ring cells"; 
drValHash[xc(TSV_CC_SDC)] = 0;

cc_gr_bound = copy_by_cells(CELLBOUNDARY, cells = catch_cup_guard_cells);
cc_gr_bound_and_grID = cc_gr_bound and GUARDRING_ID;

drPassthruStack.push_back({ cc_gr_bound,    {ct,0} });  //158
drPassthruStack.push_back({ cc_gr_bound_and_grID,    {ct+1,0} });  //159
drPassthruStack.push_back({ ETCHRINGTRENCHID,    {ct+2,0} });  //160

Error_TSV_SDC @= {
	@ "TSV_CC_SDC: VIA2SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA2SDC;
	@ "TSV_CC_SDC: METAL3SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor METAL3SDC;
	@ "TSV_CC_SDC: VIA3SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA3SDC;
	@ "TSV_CC_SDC: METAL4SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor METAL4SDC;
	@ "TSV_CC_SDC: VIA4SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA4SDC;
	@ "TSV_CC_SDC: METAL5SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor METAL5SDC;
	@ "TSV_CC_SDC: VIA5SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA5SDC;
	@ "TSV_CC_SDC: METAL6SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor METAL6SDC;
	@ "TSV_CC_SDC: VIA6SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA6SDC;
	@ "TSV_CC_SDC: METAL7SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor METAL7SDC;
	@ "TSV_CC_SDC: VIA7SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA7SDC;
	@ "TSV_CC_SDC: METAL8SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor METAL8SDC;
	@ "TSV_CC_SDC: VIA8SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA8SDC;
	@ "TSV_CC_SDC: METAL9SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor METAL9SDC;
	@ "TSV_CC_SDC: VIA9SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor VIA9SDC;
	@ "TSV_CC_SDC: TM1SDC layers should completely overlap the Catch-cup guard-ring cells";
	cc_gr_bound_and_grID xor TM1SDC;
	
	#if (_drPROCESS == 6 )
		@ "TSV_CC_SDC: METAL10SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor METAL10SDC;
		@ "TSV_CC_SDC: VIA10SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor VIA10SDC;
		@ "TSV_CC_SDC: METAL11SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor METAL11SDC;
		@ "TSV_CC_SDC: VIA11SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor VIA11SDC;
		@ "TSV_CC_SDC: METAL12SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor METAL12SDC;
		@ "TSV_CC_SDC: VIA12SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor VIA12SDC;
	#elif (_drPROCESS == 5)
		@ "TSV_CC_SDC: METAL10SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor METAL10SDC;
		@ "TSV_CC_SDC: VIA10SDC layers should completely overlap the Catch-cup guard-ring cells";
		cc_gr_bound_and_grID xor VIA10SDC;
	#endif
}
drPushErrorStack(Error_TSV_SDC, xc(TSV_CC_SDC));


//Output the debung layers

drPassthruStack.push_back({ CELLBOUNDARY, {50,0} });
drPassthruStack.push_back({ TOPCELLBOUNDARY, {50,99} });
drPassthruStack.push_back({ TSV, 	  {216,0} });
drPassthruStack.push_back({ RDL, 	  {217,0} });
drPassthruStack.push_back({ RDLCAP, 	  {217,10} });
drPassthruStack.push_back({ RDLPAD, 	  {217,40} });
drPassthruStack.push_back({ RDL_CANTILEVER,{217,47} });


drPassthruStack.push_back({ LMIPAD, 	  {218,0} });
drPassthruStack.push_back({ POLY, 	  {2,0} });
drPassthruStack.push_back({ NDIFF, 	  {1,0} });
drPassthruStack.push_back({ PDIFF, 	  {8,0} });
drPassthruStack.push_back({ NWELL, 	  {11,0} });
drPassthruStack.push_back({ EOA, 	  {81,29} });

drPassthruStack.push_back({ rdlpad_new,  {217,100} });
drPassthruStack.push_back({ rdlcanti_new,{217,200} });
drPassthruStack.push_back({ rdlcap_new,  {217,300} });
drPassthruStack.push_back({ rdlwire,	 {217,400} });


#endif //_P1273_TSV_RS_
