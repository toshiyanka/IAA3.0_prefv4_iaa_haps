// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TSV_EDM.rs.rca 1.4 Tue May 13 10:16:28 2014 nhkhan1 Experimental $
// $Log: p1273dx_TSV_EDM.rs.rca $
// 
//  Revision: 1.4 Tue May 13 10:16:28 2014 nhkhan1
//  added if (!layer_empty(TSV))  for TEDM_01 check. (HSD # 2369)
// 
//  Revision: 1.3 Fri Sep 13 14:57:12 2013 nhkhan1
//  changed TEDM_06 and TEDM_15 as per Kalyan's clarification and x73b as the test case
// 
//  Revision: 1.2 Tue Aug 13 15:52:54 2013 nhkhan1
//  changed top_boundary to top_boundary_tsv_edm (conflict with definition in DIC)
// 
//  Revision: 1.1 Fri Aug  9 11:38:37 2013 nhkhan1
//  first time check-in


#ifndef _P1273_TSV_EDM_RS_
#define _P1273_TSV_EDM_RS_

//use the top cell BOUNDARY layer as top_boundary, otherwise use cell_extent
top_boundary_tsv_edm: polygon_layer = copy(TOPCELLBOUNDARY);
if (layer_empty(top_boundary_tsv_edm)) {
	top_boundary_tsv_edm = cell_extent(cell_list={"*"});
}

bound_tsv_edm_pgd: polygon_layer = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_edm_pstair_cells, depth=CELL_LEVEL);
bound_tsv_edm_ogd: polygon_layer = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_edm_ostair_cells, depth=CELL_LEVEL);
bound_tsv_edm_crn: polygon_layer = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_edm_crn_cells, depth=CELL_LEVEL);
bound_tsv_edm_oio: polygon_layer = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_edm_oio_cells, depth=CELL_LEVEL);
bound_tsv_edm_ofill: polygon_layer = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_edm_ofill_cells, depth=CELL_LEVEL);
bound_tsv_edm_pdiode: polygon_layer = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_edm_pstairdiode_cells, depth=CELL_LEVEL);
bound_tsv_edm_odiode: polygon_layer = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_edm_ostairdiode_cells, depth=CELL_LEVEL);

bound_tsv_edm: polygon_layer = bound_tsv_edm_pgd or bound_tsv_edm_ogd or bound_tsv_edm_crn or bound_tsv_edm_oio or bound_tsv_edm_ofill or bound_tsv_edm_pdiode or bound_tsv_edm_odiode;

drPassthru(bound_tsv_edm_pgd, 2000, 1500);
drPassthru(bound_tsv_edm_ogd, 2000, 1501);
drPassthru(bound_tsv_edm_crn, 2000, 1502);
drPassthru(bound_tsv_edm_oio, 2000, 1503);
drPassthru(bound_tsv_edm_ofill, 2000, 1504); 
drPassthru(bound_tsv_edm_pdiode, 2000, 1505);
drPassthru(bound_tsv_edm_odiode, 2000, 1506);
drPassthru(bound_tsv_edm, 2000, 1507);

cc_gr_bound = copy_by_cells(CELLBOUNDARY, cells = catch_cup_guard_cells);
cc_gr_bound_filled = cc_gr_bound or donut_holes(cc_gr_bound);

// get the ogd/pgd/corner part of the EDM ring
cc_gr_os_pgd = drGrowDir(cc_gr_bound_filled, TEDW_04, gate_dir);
cc_gr_os_ogd = drGrowDir(cc_gr_bound_filled, TEDW_11, non_gate_dir);
cc_gr_os = drGrowDir(cc_gr_os_pgd, TEDW_11, non_gate_dir);

tedm_ogd = drShrinkDir(cc_gr_os_pgd not cc_gr_bound_filled, TEDW_01-TEDW_11, non_gate_dir);
tedm_pgd = drShrinkDir(cc_gr_os_ogd not cc_gr_bound_filled, TEDW_02-TEDW_04, gate_dir);
tedm_crn = cc_gr_os not (tedm_ogd or tedm_pgd or cc_gr_bound_filled);

drPassthru(cc_gr_bound, 2000, 1510);
drPassthru(cc_gr_bound_filled, 2000, 1511);
drPassthru(cc_gr_os_pgd, 2000, 1512);
drPassthru(cc_gr_os_ogd, 2000, 1513);
drPassthru(cc_gr_os, 2000, 1514);
drPassthru(tedm_ogd, 2000, 1515);
drPassthru(tedm_pgd, 2000, 1516);
drPassthru(tedm_crn, 2000, 1517);


/*******************************************************************************
TEDM_01: "Sanity check: Catch-cup guard ring must be present at top level Cell"
*******************************************************************************/


if (!layer_empty(TSV)) {
	err @= {
		@ GetRuleString(xc(TEDM_01));  note(CheckingString(xc(TEDM_01)));
		if (layer_empty(cc_gr_bound)) {
			copy(top_boundary_tsv_edm);
		}
	}
	drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_01)], "" });
}


/*******************************************************************************
TEDM_02: Area that is 1.512um outside from the OGD edge of Catch-cup guard ring 
and 1.68um outside from the PGD edge of Catch-cup guard ring is occupied by TSV EDM ring
*******************************************************************************/

err @= {
	@ GetRuleString(xc(TEDM_02));  note(CheckingString(xc(TEDM_02)));
	
	// EDM ring should be complete and donut
	not_donuts(bound_tsv_edm);
	
	//EDM should be outside interacting the TSV GR	
	bound_tsv_edm xor (cc_gr_os not cc_gr_bound_filled);
	
}
drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_02)], "" });


/*******************************************************************************
TEDM_04: Maximum number of Fill cells per OGD die edge
*******************************************************************************/

//    - This methid counts #of polygon/net using total area/unit area
tedm_ok_multiple: double = 0.0;   //needs to be set properly by the caller of the net_select.
tedm_unit_area: double = 0.0;     //ditto.
tedm_area_do_per_net : function (void) returning void {
	region_area: double = ns_net_area("target_region");
	if (dblgt(region_area, tedm_ok_multiple*tedm_unit_area)) {
		ns_save_net({"region_area/unit_area", "region_area"}, {region_area/tedm_unit_area, region_area});
	}
}

err @= {
	@ GetRuleString(xc(TEDM_04));  note(CheckingString(xc(TEDM_04)));
	by_layer_04: const polygon_layer = cc_gr_os_pgd not bound_tsv_edm_oio;
	tedm_ok_multiple = TEDM_04;
	tedm_unit_area = TEDW_03 * TEDW_04;

	tedm_04_cdb: connect_database = connect({{layers={bound_tsv_edm_ofill}, by_layer=by_layer_04}});
	net_select(connect_sequence = tedm_04_cdb, net_function = tedm_area_do_per_net, 
	          layer_groups = {"target_region" => {bound_tsv_edm_ofill}}, output_from_layers = {bound_tsv_edm_ofill});
}
drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_04)], "" });


/*******************************************************************************
TEDM_06: Maximum number of OGD fill cell that can be placed consecutively
TEDM_07: Maximum number of PGD diode staircase cell that can be placed consecutively
TEDM_08: Maximum number of OGD diode staircase cell that can be placed consecutively
*******************************************************************************/

drTEDMfillcell_Count_: function (label : string, layer : polygon_layer, lx : double, ly: double, count: double, waive: polygon_layer = g_empty_layer) returning void {
	err @= {
		@ GetRuleString(label, "sq um");  note(CheckingString(label));
		//Create a loop over count and find area for each of them
		bound_fill_good = g_empty_layer; //Initialize to empty layer
		for (i=1 to dtoi(count)) { //Converts double to integer
			bound_fill_good = bound_fill_good or area(layer, value == lx*ly*i);
		}
		//Error if there lies any polygon that is not good
		layer not (bound_fill_good or waive);		
	}
	drPushErrorStack(err,label);
}

/*********************************************************************************
As per Kalyan's clarification the consecutive OGD fill cells can be as long as the 
width of a stair case cell.
*********************************************************************************/
TEDM_06 = TEDW_07/TEDW_03;

drTEDMfillcell_Count_(xc(TEDM_06), bound_tsv_edm_ofill, TEDW_03, TEDW_04, TEDM_06);
drTEDMfillcell_Count_(xc(TEDM_07), bound_tsv_edm_pdiode, TEDW_11, TEDW_12, TEDM_07);
drTEDMfillcell_Count_(xc(TEDM_08), bound_tsv_edm_odiode, TEDW_13, TEDW_14, TEDM_08);


/*******************************************************************************
TEDM_11: Number of I/O cell placement allowed (OGD die TSV EDM ring only)
*******************************************************************************/

//Counts polygon count/net remote function used to flag the target region based on the polygon count.
dr_tedm_polygon_count: double = 0; //Double since dr file has everything defined in double
tedm_do_per_net: function (void) returning void {
	pgn_cnt: integer = ns_net_data_count("target_region");
	if (dblne(pgn_cnt,dtoi(dr_tedm_polygon_count))) {
		ns_save_net({"polygon_count"}, {pgn_cnt});
	}
}

err @= {
	@ GetRuleString(xc(TEDM_11));  note(CheckingString(xc(TEDM_11)));
	tedm_oio_cdb: connect_database = connect({{layers={bound_tsv_edm_oio}, by_layer=cc_gr_os}});
	dr_tedm_polygon_count = TEDM_11; 
	net_select(connect_sequence = tedm_oio_cdb, net_function = tedm_do_per_net, layer_groups = {"target_region" => {bound_tsv_edm_oio}},
    	      connected_to_all = {cc_gr_os}, output_from_layers = {bound_tsv_edm_oio}, error_net_output = ALL);
}
drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_11)], "" });


/*******************************************************************************
TEDM_12: Corner cells can only reside in die corners
*******************************************************************************/

err @= {
	@ GetRuleString(xc(TEDM_12));  note(CheckingString(xc(TEDM_12)));
	xor(bound_tsv_edm_crn, tedm_crn);
}
drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_12)], "" });


/*******************************************************************************
TEDM_13: EDM cells cannot overlap each other
*******************************************************************************/

err @= {
	@ GetRuleString(xc(TEDM_13));  note(CheckingString(xc(TEDM_13)));

	//foreach (elm in bound_edm_polygon) {
	bound_tedm_mod = copy(bound_tsv_edm);
	bound_tedm2: polygon_layer = bound_tedm_mod;
	and_overlap(bound_tedm_mod, bound_tedm2);
}
drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_13)], "" });


/*******************************************************************************
TEDM_14: EDM cells dimension not drawn according to spec
*******************************************************************************/

err @= {
    @ GetRuleString(xc(EDM_14));  note(CheckingString(xc(EDM_14)));

    tedm_crn_dim:Return2Layers    = drBinRectVias(bound_tsv_edm_crn, TEDW_01, TEDW_02);
    tedm_ofill_dim:Return2Layers  = drBinRectVias(bound_tsv_edm_ofill, TEDW_03, TEDW_04);
    tedm_oio_dim:Return2Layers 	 = drBinRectVias(bound_tsv_edm_oio, TEDW_07, TEDW_08);
    tedm_pdiode_dim:Return2Layers = drBinRectVias(bound_tsv_edm_pdiode, TEDW_11, TEDW_12);
    tedm_odiode_dim:Return2Layers = drBinRectVias(bound_tsv_edm_odiode, TEDW_13, TEDW_14);
    tedm_pstair_dim:Return2Layers = drBinRectVias(bound_tsv_edm_pgd, TEDW_15, TEDW_16);
    tedm_ostair_dim:Return2Layers = drBinRectVias(bound_tsv_edm_ogd, TEDW_17, TEDW_18);

    //TEDM_12 checks this explicitly since corner dimension is not a rectangle
    //drCopyToError_(xc(EDM_14), tedm_crn_dim.layer2);    //Error

    //TEDM_06 checks for this since there can be 2 filler and they will be merged
    //drCopyToError_(xc(EDM_14), edm_ofill_dim.layer2);  //Error

    drCopyToError_(xc(TEDM_14), tedm_oio_dim.layer2);    //Error
    drCopyToError_(xc(TEDM_14), tedm_pdiode_dim.layer2); //Error
    drCopyToError_(xc(TEDM_14), tedm_odiode_dim.layer2); //Error

    //Cannot check for staircase dimension since they are all merged - checked by TEDM_15 & TEDM_16
    //drCopyToError_(xc(EDM_14), edm_pstair_dim.layer2); //Error
    //drCopyToError_(xc(EDM_14), edm_ostair_dim.layer2); //Error
}


/*******************************************************************************
TEDM_15: Every 25th OGD staircase cell must be a diode staircase cell
As per Kalyan's email 9/12/2013 30 continuous OGD stair cells are OK (31st should be the diode)
*******************************************************************************/
TEDM_15 = 30;

err @= {
	@ GetRuleString(xc(TEDM_15));  note(CheckingString(xc(TEDM_15)));

	//merged the ogd-stair cell and ogd fill cell	 
	ogd_stair_merged_fill = bound_tsv_edm_ogd or bound_tsv_edm_ofill;
	valid_width_val:double = TEDM_15*TEDW_07;
	valid_width = internal1(ogd_stair_merged_fill, <=valid_width_val, extension=NONE, direction=non_gate_dir);
	ogd_stair_merged_fill not valid_width;	
}
drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_15)], "" });


/*******************************************************************************
TEDM_16: There should be at least one PGD staircase cells in each PGD part of EDM ring
*******************************************************************************/

err @= {
	@ GetRuleString(xc(TEDM_16));  note(CheckingString(xc(TEDM_16)));

	tedm_pgd not_interacting bound_tsv_edm_pdiode;
}
drErrorStack.push_back({ err, drErrGDSHash[xc(TEDM_16)], "" });


#endif //_P1273_TSV_EDM_RS_
