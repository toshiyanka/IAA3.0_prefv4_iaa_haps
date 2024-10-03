// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_M3F.rs.rca 1.3 Wed Dec  3 00:36:55 2014 dgthakur Experimental $
//
// $Log: p1273dx_M3F.rs.rca $
// 
//  Revision: 1.3 Wed Dec  3 00:36:55 2014 dgthakur
//  Added check to ensure 18.41 ID layer is not dropped for fuse cells (Zhanping email 11/25/14).
// 
//  Revision: 1.2 Tue Sep 17 02:56:24 2013 dgthakur
//  hsd 1879; Added m3fuseid checks M3F_50 and M3F_51 (for x73b/s73 fuse only).
// 
//  Revision: 1.1 Thu Nov 29 23:37:04 2012 dgthakur
//  X73b metal3 fuse rules.
//


//Runset for M3 fuse (experimental for X73B project only)
#ifndef _P1273DX_M3F_RS_
#define _P1273DX_M3F_RS_


drErrGDSHash[xc(M3F_01)] = {234,2001};
drHash[xc(M3F_01)] = xc(M3 fuse jog can only be on M3B wires at ID layer METAL3FUSEJOG );
drValHash[xc(M3F_01)] = 0;

M3F_02=0.100;
drErrGDSHash[xc(M3F_02)] = {234,2002};
drHash[xc(M3F_02)] = xc(L-shaped METAL3FUSEJOG layer of height 100nm covering the jog symmetrically line-on-line with metal);
drValHash[xc(M3F_02)] = M3F_02;

M3F_03=0.018;
drErrGDSHash[xc(M3F_03)] = {234,2003};
drHash[xc(M3F_03)] = xc(Max M3 fuse jog edge);
drValHash[xc(M3F_03)] = M3F_03;


drErrGDSHash[xc(M3F_04)] = {234,2004};
drHash[xc(M3F_04)] = xc(No V2 or V3 can interact with METAL3FUSEJOG);
drValHash[xc(M3F_04)] = 0.0;


drErrGDSHash[xc(M3F_50)] = {234,2050};
drHash[xc(M3F_50)] = xc(M3C wires not allowed under M3FUSEID);
drValHash[xc(M3F_50)] = 0.0;

M3F_51=0.300;
drErrGDSHash[xc(M3F_51)] = {234,2051};
drHash[xc(M3F_51)] = xc(Max M3FUSEID width in PGD);
drValHash[xc(M3F_51)] = M3F_51;


drErrGDSHash[xc(M3F_61)] = {234,2061};
drHash[xc(M3F_61)] = xc(x73p00fcary1 cells must have the M3FUSEID 18.41 layer);
drValHash[xc(M3F_61)] = 0.0;



drCopyToError_(xc(M3F_01), METAL3FUSEJOG and m3c); 


//M3F_02 Check L-shape drawing
m3f_jog_edge = adjacent_edge(m3b, length<=M3F_03, angle1=270, angle2=90, 
  adjacent_length1>M3F_02, adjacent_length2>M3F_02);
//
m3f_jog_edge_os = edge_size( m3f_jog_edge, inside=M3F_02, outside=M3F_02); 
m3f_jog_add = enclose(m3f_jog_edge_os, m3b, <=M3L_06, extension = NONE, 
  orientation = PARALLEL, direction = non_gate_dir, look_thru=COINCIDENT); 
m3f_jog_L = (m3f_jog_edge_os or m3f_jog_add) and m3b;
//
drCopyToError_(xc(M3F_02), METAL3FUSEJOG xor m3f_jog_L); 
//
drPassthru(m3f_jog_edge_os, 18, 1301)
drPassthru(m3f_jog_add, 18, 1302)
drPassthru(m3f_jog_L, 18, 1303)


drCopyEdgeToError_(xc(M3F_03), adjacent_edge(m3b, length>M3F_03, angle1=270, angle2=90, 
  adjacent_length1>M3F_02, adjacent_length2>M3F_02)); 


drCopyToError_(xc(M3F_04), VIA2 and METAL3FUSEJOG); 
drCopyToError_(xc(M3F_04), VIA3 and METAL3FUSEJOG); 

//M3 fuse id checks
drCopyToError_(xc(M3F_50), M3FUSEID and m3c); 

m3fuseID_good = drWidth(rectangles(M3FUSEID), <=M3F_51, gate_dir);
drCopyToError_(xc(M3F_51), M3FUSEID not m3fuseID_good); 


//Following cells must have a M3FUSEID 18.41 layer
cells_to_check_for_18_41:list of string =  {
"x73p00fcary1ne_m4f2_nw",
"x73p00fcary1ne_m4f2_nw_r",
"x73p00fcary1ne_m4f2",
"x73p00fcary1ne_m4f2_r",
"x73p00fcary1ne_ref_m4f2",
"x73p00fcary1ne_ref_m4f2_nw",
"x73p00fcary1ne_m4f2_fix1_nw",
"x73p00fcary1ne_m4f2_fix1",
"x73p00fcary1col_64row_edgel_uv2locn",
"x73p00fcary1col_64row_edgeinl",
"x73p00fcary1col_64row_edger"
};

foreach (cl in cells_to_check_for_18_41) {
  L18_41=copy_by_cells(M3FUSEID, cells = cl, depth = CELL_LEVEL);
  cl_ext=cell_extent(cl);
  if (layer_empty(L18_41)) {
    drCopyToError_(xc(M3F_61), cl_ext);
  }
}

//debug
drPassthru(METAL3FUSEJOG, 18, 100)
drPassthru(M3FUSEID, 18, 41)


#endif
