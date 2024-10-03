// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DX.rs.rca 1.15 Fri Mar 21 09:23:14 2014 oakin Experimental $
//
// $Log: p1273dx_DX.rs.rca $
// 
//  Revision: 1.15 Fri Mar 21 09:23:14 2014 oakin
//  changed DX_06 to allow exact 17 pitch region.
// 
//  Revision: 1.14 Mon Dec 23 09:55:31 2013 oakin
//  fixed the wrong checkin done in v1.13.
// 
//  Revision: 1.12 Thu Oct 10 14:48:15 2013 oakin
//  added =17pitch case for ULP (paranoia).
// 
//  Revision: 1.11 Thu Feb  7 11:59:28 2013 oakin
//  fixed some directional type misses.
// 
//  Revision: 1.10 Mon Oct 29 14:06:28 2012 cpark3
//  replaced double quotes around rule labels with xc()
//  done to enable upgrades for TSDR
//  full list DX_70/71/72/73/173/174/175/176
// 
//  Revision: 1.9 Thu Oct 18 09:03:26 2012 oakin
//  fixed DX_06.
// 
//  Revision: 1.8 Tue Oct 16 09:28:21 2012 oakin
//  fixed the 270 270 case (the ogd stub were not generated).
// 
//  Revision: 1.7 Mon Oct 15 11:40:20 2012 oakin
//  removed DX_er3 and changed DX_06 (should not make much difference).
//  the off_grid_xy command works fine so any shaped should be checked correctly.
// 
//  Revision: 1.6 Tue Jul 31 17:20:48 2012 oakin
//  fixed DX_175.
//  DX_44/45 do not exist in DX (removed).
// 
//  Revision: 1.5 Thu Jul 26 15:09:59 2012 oakin
//  added a empty input to a funciton change.
//  Changed DX_er as the polyid can be drawn as a hole.
// 
//  Revision: 1.4 Fri Apr 13 10:50:55 2012 oakin
//  changed DX_06 (still needs some work, now limitied to L shaped regions.).
//  Fixed DX_53/54/55/56
//  fixed some typos.
// 
//  Revision: 1.3 Thu Feb 23 14:51:40 2012 oakin
//  added XGOXID check (DX_er2).
// 
//  Revision: 1.2 Wed Feb 22 14:11:44 2012 oakin
//  fixed 90-270 edges for fixed poly lines.
// 
//  Revision: 1.1 Thu Aug 11 14:13:28 2011 oakin
//  first check-in.
// 

#ifndef _P1273DX_DX_RS_
#define _P1273DX_DX_RS_


//REMOVE THESE *START (till the functions in tr_functions are cleaned up)
polyod_like = copy(POLYOD);
trdtos_like = copy(TRDTOS);
cor_trdtos_like = copy(cor_trdtos);
ogd_trdtos_like = copy(ogd_trdtos); 
pgd_trdtos_like = copy(pgd_trdtos);
//id_edges:Return4Edges;
id_edges = drGetEdge(V1PITCHID);
//REMOVE THESE *END


ogd_tr_width = DX_11;
#include <p12723_tr_functions.rs>

id_edges_dx = drGetEdge(ULPPITCHID);

//first four dig poly lines
 tr_pgd_e = angle_edge(TRDTOULP or ULPPITCHID, gate_angle); 
 dig1 = edge_size(tr_pgd_e, inside = DX_361);
 dig2 = edge_size(tr_pgd_e, inside = 2*DX_361+DX_371) not edge_size(tr_pgd_e, inside = DX_361+DX_371);
 dig3 = edge_size(tr_pgd_e, inside = 3*DX_361+2*DX_371) not edge_size(tr_pgd_e, inside = 2*DX_361+2*DX_371);
 dig4_a = edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375+DX_374+DX_373+DX_372+4*DX_361) not 
          edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375+DX_374+DX_373+DX_372+3*DX_361);
 dig4_b = edge_size(tr_pgd_e, inside = 3*DX_361+3*DX_371+DX_362) not edge_size(tr_pgd_e, inside = 2*DX_361+3*DX_371);
	
 dig5_a = edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375+DX_374+DX_373+3*DX_362) not 
          edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375+DX_374+DX_373+2*DX_362);
 dig5_b = edge_size(tr_pgd_e, inside = 3*DX_361+3*DX_371+2*DX_362+DX_372) not edge_size(tr_pgd_e, inside = 2*DX_361+3*DX_371+DX_362+DX_372);
 
 dig6_a = edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375+DX_374+2*DX_362) not 
          edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375+DX_374+DX_362);
 dig6_b = edge_size(tr_pgd_e, inside = 3*DX_361+3*DX_371+3*DX_362+DX_372+DX_373) not edge_size(tr_pgd_e, inside = 2*DX_361+3*DX_371+2*DX_362+DX_372+DX_373);
 
 dig7_a = edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375+DX_362) not 
          edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363+DX_375);
 dig7_b = edge_size(tr_pgd_e, inside = 3*DX_361+3*DX_371+4*DX_362+DX_372+DX_373+DX_374) not edge_size(tr_pgd_e, inside = 2*DX_361+3*DX_371+3*DX_362+DX_372+DX_373+DX_374);

 dig8_a = edge_size(id_edges_dx.edge4, outside = DX_376-DX_38+DX_363) not 
          edge_size(id_edges_dx.edge4, outside = DX_376-DX_38);
 dig8_b = edge_size(tr_pgd_e, inside = 3*DX_361+3*DX_371+4*DX_362+DX_372+DX_373+DX_374+DX_375+DX_363) not edge_size(tr_pgd_e, inside = 2*DX_361+3*DX_371+4*DX_362+DX_372+DX_373+DX_374+DX_375);

 dig_tr_pl = dig1 or dig2 or dig3 or (dig4_a and dig4_b) or (dig5_a and dig5_b) or (dig6_a and dig6_b) or (dig7_a and dig7_b) or (dig8_a and dig8_b);

 //get the 84pitch poly in tr
 dx364_poly_1 = drCreatePoly_in(id_edges_dx.edge4, DX_38 + DX_364, DX_38 );
 dx364_poly_2 = drCreatePoly_in(id_edges_dx.edge4, DX_38 + 2*DX_364 + DX_376,   DX_38 + DX_364 + DX_376 );
 dx364_poly_3 = drCreatePoly_in(id_edges_dx.edge4, DX_38 + 3*DX_364 + 2*DX_376, DX_38 + 2*DX_364 + 2*DX_376 );
 dx364_poly_4 = drCreatePoly_in(id_edges_dx.edge4, DX_38 + 4*DX_364 + 3*DX_376, DX_38 + 3*DX_364 + 3*DX_376 );
 
 all_dx364_poly = drGrow(dx364_poly_1 or dx364_poly_2 or dx364_poly_3 or dx364_poly_4, N = DX_32, S = DX_32) and ULPPITCHID;
   
 //min poly length touching the tr region
 tr_ogd_e = angle_edge(TRDTOULP or ULPPITCHID, non_gate_angle);  
 id_all_edges = drGetEdge(TRDTOULP or ULPPITCHID); 
 tr_ogd_e = tr_ogd_e not_coincident_edge (id_all_edges.edge3 or_edge id_all_edges.edge2);
 os_270_270_e = extend_edge(id_all_edges.edge3, start = PL_01, end = PL_01);
 allid_corner_270 = vertex((ULPPITCHID or TRDTOULP), angles = {270}, shape_size = 2*0.042);
 os_270_90_e = id_all_edges.edge2 not_edge allid_corner_270;
 dig_dx32 = drCreatePitchMarkers(flatten_by_cells(edge_size(tr_ogd_e or_edge os_270_270_e or_edge os_270_90_e, outside = DX_32, inside = 0.078 + 0.093), cells={"*"}), PL_01, PL_02,0,gate_dir);
 cut_mask = edge_size(tr_ogd_e or_edge os_270_270_e or_edge os_270_90_e, inside = 0.078 );
 dig_dx32 = dig_dx32 not cut_mask;

 ogd_dx38 = extend_edge(id_edges_dx.edge1, start = -1*DX_38, end = -1*DX_38);
 th_dx32  = drCreatePitchMarkers(flatten_by_cells(edge_size(ogd_dx38, inside = DX_32, outside = 0.078 + 0.093), cells={"*"}), XPL_01, XPL_02,0,gate_dir); 
 cut_mask = edge_size(ogd_dx38,  outside = 0.078);
 th_dx32 = th_dx32 not cut_mask;
 
 // get the ogd poly pieces 
 tr_270_270_edge = angle_edge(adjacent_edge(TRDTOULP or ULPPITCHID, length > 0, angle1 = 270, angle2 = 270), non_gate_angle);
 us_tr_270_270_edge = extend_edge(tr_270_270_edge, start = -(PL_02-PL_01), end = -(PL_02-PL_01)); 
 us_tr_ogd_e = extend_edge(tr_ogd_e or_edge os_270_90_e or_edge us_tr_270_270_edge, start = -3*PL_02 - PL_01, end = -3*PL_02 - PL_01);
 ogd_poly = drCreatePitchMarkers(flatten_by_cells(edge_size(us_tr_ogd_e, outside = DX_32, inside = 0.078 + 0.093 ), cells={"*"}), PL_02 - PL_01, 2*PL_02,0,gate_dir);
 cut_mask = edge_size(us_tr_ogd_e, outside = DX_32, inside = 0.078 + 0.093 - 0.028); 
 ogd_poly = ogd_poly not cut_mask;
 
 //get the structure around 270 corner
 pgd_ulp_270_corner_1 = drGetPGDedge_270cor(ULPPITCHID, 0.093 + 0.078 + 0.12, 0.093); 
 finger_dig_270_1 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363, DX_376-DX_38 );
 finger_dig_270_2 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_362, (DX_376-DX_38)+DX_363+DX_375 );
 finger_dig_270_3 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+2*DX_362, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_362);
 finger_dig_270_4 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+3*DX_362, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+2*DX_362);
 finger_dig_270_5 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+4*DX_362, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+3*DX_362);
 finger_dig_270_6 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+DX_371+4*DX_362+DX_361, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+DX_371+4*DX_362);
 finger_dig_270_7 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+2*DX_371+4*DX_362+2*DX_361, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+2*DX_371+4*DX_362+DX_361);
 finger_dig_270_8 = drCreatePoly_out(pgd_ulp_270_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+3*DX_371+4*DX_362+3*DX_361, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+3*DX_371+4*DX_362+2*DX_361);
 
 pgd_ulp_270_corner_2 = drGetPGDedge_270cor(ULPPITCHID, 0.093 + 0.078 + 0.12, 0.028); 
 palm_out1_270 = drCreatePoly_out(pgd_ulp_270_corner_2, (DX_376-DX_38)+DX_363+DX_375+2*DX_362+DX_374, (DX_376-DX_38)+DX_363+DX_375);
 palm_out2_270 = drCreatePoly_out(pgd_ulp_270_corner_2, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372, (DX_376-DX_38)+DX_363+DX_375+2*DX_362+DX_374+DX_373);
 palm_out3_270 = drCreatePoly_out(pgd_ulp_270_corner_2, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372+2*DX_371+2*DX_361, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372+DX_371);
 palm_out4_270 = drCreatePoly_out(pgd_ulp_270_corner_2, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372+4*DX_371+4*DX_361, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372+3*DX_371+2*DX_361);
 palm_out5_270 = drCreatePoly_out(pgd_ulp_270_corner_2, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372+6*DX_371+6*DX_361, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372+5*DX_371+4*DX_361);
 
 all_fixed_poly_around270 = finger_dig_270_1 or finger_dig_270_2 or finger_dig_270_3 or finger_dig_270_4 or
                             finger_dig_270_5 or finger_dig_270_6 or finger_dig_270_7 or finger_dig_270_8 or
			     palm_out1_270 or palm_out2_270 or palm_out3_270 or palm_out4_270 or palm_out5_270;
             
 
 //get the structure around 90 corner
 pgd_ulp_90_corner_1 = drGetPGDedge_90cor(ULPPITCHID, 0.093 + 0.078, 0.093); 
 finger_dig_90_1 = drCreatePoly_out(pgd_ulp_90_corner_1, (DX_376-DX_38)+DX_363, DX_376-DX_38 );
 finger_dig_90_2 = drCreatePoly_out(pgd_ulp_90_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_362, (DX_376-DX_38)+DX_363+DX_375 );
 finger_dig_90_3 = drCreatePoly_out(pgd_ulp_90_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+2*DX_362, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_362);
 finger_dig_90_4 = drCreatePoly_out(pgd_ulp_90_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+3*DX_362, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+2*DX_362);
 finger_dig_90_5 = drCreatePoly_out(pgd_ulp_90_corner_1, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+4*DX_362, (DX_376-DX_38)+DX_363+DX_375+DX_374+DX_373+DX_372+3*DX_362);
 
 pgd_ulp_90_corner_2 = drGetPGDedge_90cor(ULPPITCHID, 0.093 + 0.078, 0.028); 
 palm_out1_90 = drCreatePoly_out(pgd_ulp_90_corner_2, (DX_376-DX_38)+DX_363+DX_375+2*DX_362+DX_374, (DX_376-DX_38)+DX_363+DX_375);
 palm_out2_90 = drCreatePoly_out(pgd_ulp_90_corner_2, (DX_376-DX_38)+DX_363+DX_375+4*DX_362+DX_374+DX_373+DX_372, (DX_376-DX_38)+DX_363+DX_375+2*DX_362+DX_374+DX_373);

 all_fixed_poly_around90 = finger_dig_90_1 or finger_dig_90_2 or finger_dig_90_3 or finger_dig_90_4 or finger_dig_90_5 or
                            palm_out1_90 or palm_out2_90;

 //dx_44_edge = drGetPGDedge_270cor(ULPPITCHID, 0, 0.462); 
 //os_dx_44_edge = extend_edge(dx_44_edge, start = DX_44, end = DX_44);
 //dx44_poly = drCreatePoly_in(os_dx_44_edge, 0.399, 0.399 - XPL_01);
 dx44_poly = g_empty_layer;
 
 all_fixed_poly = dig_tr_pl or all_dx364_poly or dig_dx32 or th_dx32 or ogd_poly or all_fixed_poly_around90 or all_fixed_poly_around270 or dx44_poly;
 
 
dx_enc_of_id_by_tr = 0.525; 
 
//DX_01
dr_Dx01_check_(xc(DX_01), ULPPITCHID, TRDTOULP, cor_ulptr, ogd_ulptr, pgd_ulptr, DX_12, PL_01, XPL_01, DX_38, DX_12+0.007, DX_173, DX_73, 0.273);

//DX_02
drDx02_(xc(DX_02), TRDTOULP, dr_all_polyid, dr_all_trid, dr_trid_list, DX_11, DX_12, DX_12, ULPPITCHID, 2*dx_enc_of_id_by_tr + DX_03);

//DX_03
drDx03_(xc(DX_03), TRDTOULP, dr_trid_list, DX_03);

//DX_04
drMinSpaceDir_(xc(DX_04), ULPPITCHID, <DX_04, gate_dir); 

//DX_05
drDx05_(xc(DX_05), ULPPITCHID, TRDTOULP, DX_05);

// DX_06
multofdx:function(void) returning void {
    cur_pgon = pf_get_current_polygon();
    ext_cur_pgon = pf_polygon_extent(cur_pgon);
    #if GATEDIR_VERT
     i=0;
     max_c = pf_polygon_coordinate_x(ext_cur_pgon, i);
     min_c = pf_polygon_coordinate_x(ext_cur_pgon, i);
     i=1;
     while(i<=3) {
      if (max_c < pf_polygon_coordinate_x(ext_cur_pgon, i)) { max_c = pf_polygon_coordinate_x(ext_cur_pgon, i); }
      if (min_c > pf_polygon_coordinate_x(ext_cur_pgon, i)) { min_c = pf_polygon_coordinate_x(ext_cur_pgon, i); }
      i = i+1;
     }        
    #else
     i=0;
     max_c = pf_polygon_coordinate_y(ext_cur_pgon, i);
     min_c = pf_polygon_coordinate_y(ext_cur_pgon, i);
     i=1;
     while(i<=3) {
      if (max_c < pf_polygon_coordinate_y(ext_cur_pgon, i)) { max_c = pf_polygon_coordinate_y(ext_cur_pgon, i); }
      if (min_c > pf_polygon_coordinate_y(ext_cur_pgon, i)) { min_c = pf_polygon_coordinate_y(ext_cur_pgon, i); }
      i = i+1;
     }            
    #endif
  
   note("\n max_c  = " +max_c);
   note("\n min_c  = " +min_c);
  r_max_c:integer = dtoi(max_c*1000);
  r_min_c:integer = dtoi(min_c*1000);
  
  if ( dblne(((((r_max_c - r_min_c)-0.042*1000)/(0.084*1000))-9)%10,0)){ pf_save_polygon(cur_pgon); }
 aa = (((r_max_c - r_min_c)-0.042*1000)/(0.084*1000))-9;
  note("\n numof_poly_lines  = " +aa);
  
  }
  
// Error_DX_06 @= {
//   @ GetRuleString(xc(DX_06),"um"); note(CheckingString(xc(DX_06)));    
//   
//   polygon_features(donut_holes(TRDTOULP), polygon_function = multofdx);  
//   
//   os_edges = edge_size( angle_edge(not_adjacent_edge(donut_holes(TRDTOULP), length > 0, angle1 = 270), non_gate_angle), inside = drgrid, outside = drgrid);
//   polygon_features(os_edges, polygon_function = multofdx);
//   
//   os_edges = edge_size( extend_edge(angle_edge(adjacent_edge(donut_holes(TRDTOULP), length > 0, angle1 = 270, angle2 = 270), non_gate_angle),start=0.042, end =0.042), inside = drgrid, outside = drgrid);
//   polygon_features(os_edges, polygon_function = multofdx);
//   
//   os_edges = edge_size( extend_edge(angle_edge(adjacent_edge(donut_holes(TRDTOULP), length > 0, angle1 = 90, angle2 = 270), non_gate_angle),start=0.021, end =0.021), inside = drgrid, outside = drgrid);
//   polygon_features(os_edges, polygon_function = multofdx);
// }
// drErrorStack.push_back({ Error_DX_06, drErrGDSHash[xc(DX_06)], "" });
//  
 
 Error_DX_06 @= {
  @ GetRuleString(xc(DX_06),"um"); note(CheckingString(xc(DX_06)));    
   
//    polygon_features(donut_holes(TRDTOULP), polygon_function = multofdx);
//    os_edges = edge_size( extend_edge(angle_edge(adjacent_edge(donut_holes(TRDTOULP), length > 0, angle1 = 270, angle2 = 270), non_gate_angle),start=0.042, end =0.042), inside = drgrid, outside = drgrid);
//    polygon_features(os_edges, polygon_function = multofdx);
  
   
   
   internal1(ULPPITCHID, distance <  17*XPL_02, extension = NONE_INCLUSIVE, direction = non_gate_dir);
   
  // us_ulppitchid_1 = drGrow(ULPPITCHID, E = 3/2*XPL_02, W = 3/2*XPL_02);
   us_ulppitchid = drShrink(ULPPITCHID, E = 7/2*XPL_02, W = 7/2*XPL_02);
   pgd_us_ulppitchid_e = angle_edge(us_ulppitchid, angles = gate_angle);
   #ifdef GATEDIR_VERT   
     off_grid_xy(pgd_us_ulppitchid_e, x_resolution = 10*XPL_02, y_resolution = 0.001, reference_layer = us_ulppitchid);
   #else
     off_grid_xy(pgd_us_ulppitchid_e, y_resolution = 10*XPL_02, x_resolution = 0.001, reference_layer = us_ulppitchid);
   #endif
   // drPassthruStack.push_back({us_ulppitchid, {200,66} }); 
   // drPassthruStack.push_back({pgd_us_ulppitchid_e, {200,67} }); 
   // drPassthruStack.push_back({us_ulppitchid_1, {200,68} }); 
  
  
}
drErrorStack.push_back({ Error_DX_06, drErrGDSHash[xc(DX_06)], "" });
 
 
 
 //DX_11/12 also DX_02
dr_Dx11_12_check_(xc(DX_11), TRDTOULP, DX_11, DX_12);

 //DX_24
drMinWidthDir_( xc(DX_24), ULPPITCHID, DX_24, non_gate_dir);

 //DX_30
drMinSpaceSamePoly_( xc(DX_30), ULPPITCHID, DX_30);

 
 //DX_7x TCN in tr rules
dr_tr_tcn_rules_(xc(DX_70), xc(DX_71), xc(DX_72), xc(DX_73), xc(DX_173), xc(DX_174), xc(DX_175), xc(DX_176),
                  DX_70, DX_71, DX_72, DX_73, DX_173, DX_174, DX_175, DX_176,
		  ULPPITCHID, TRDTOULP, pgd_ulptr, ogd_ulptr, cor_ulptr,
		  DX_11, DX_73, PL_02/2, 0.525, PL_02, XPL_02, >=1);

//  
Error_DX_177 @= {
  @ GetRuleString(xc(DX_177),"um"); note(CheckingString(xc(DX_177)));  
 dx177_notcn_region = drGrow(ULPPITCHID, E = 0.322, W = 0.322) not  drGrow(ULPPITCHID, E = 0.014, W = 0.014);
 DIFFCON and dx177_notcn_region;

}  
drErrorStack.push_back({ Error_DX_177, drErrGDSHash[xc(DX_177)], "" });


Error_DX_175 @= {
  @ GetRuleString(xc(DX_175),"um"); note(CheckingString(xc(DX_175)));  
 
  line_up_tcn_1 = DIFFCON interacting (ULPPITCHID and TRDTOULP);
  ou_line_up_tcn_1 = drShrink(drGrow(line_up_tcn_1, E = PL_02/2, W = PL_02/2), E = PL_02/2, W = PL_02/2);
  not_interacting(ou_line_up_tcn_1, DIFFCON, count = 4); 
 
  line_up_tcn_2 = DIFFCON interacting (drGrow(ULPPITCHID, E = 0.525-drunit, W = 0.525-drunit) not drGrow(ULPPITCHID, E = 0.315, W = 0.315));
  ou_line_up_tcn_2 = drShrink(drGrow(line_up_tcn_2, E = PL_02/2, W = PL_02/2), E = PL_02/2, W = PL_02/2);
  not_interacting(ou_line_up_tcn_2, DIFFCON, count = 3); 
 
 
}  
drErrorStack.push_back({ Error_DX_175, drErrGDSHash[xc(DX_175)], "" });
 
 
//DX_31/32/41 covers DX_33
//drawn_dx44_poly = POLY and edge_size(os_dx_44_edge, inside = 0.399);
drawn_dx44_poly = g_empty_layer;
dr_Dx31_32_41_check_(xc(DX_31), TRDTOULP, all_fixed_poly, DX_32, drawn_dx44_poly, g_empty_layer);

// //DX_45
//  Error_DX_45 @= {
//   @ GetRuleString(xc(DX_45),"um"); note(CheckingString(xc(DX_45)));
//     gate interacting  dx44_poly;
// }
// drErrorStack.push_back({ Error_DX_45, drErrGDSHash[xc(DX_45)], "" }); 

drDx52_(xc(DX_52), ULPPITCHID, TRDTOULP, XPL_01, cor_ulptr);

dr_yoffset = 0.0;
dr_xoffset = DX_38 + 4*DX_364+3*DX_376;
#if (_drPROCESSNAME == 1273)
   nw_ext_waiver4sramid2 = drGrow(SRAMID2 interacting ULPPITCHID, E = 0.252, W = 0.252) and TRDTOULP;
#else
   nw_ext_waiver4sramid2 = g_empty_layer;
#endif

drDx53_(xc(DX_53), ULPPITCHID, TRDTOULP, ALLNWELL, dr_yoffset, DX_53, DX_364);
drDx54_(xc(DX_54), ULPPITCHID, TRDTOULP, ALLNWELL, dr_xoffset, DX_54); 
drDx55_(xc(DX_55), ULPPITCHID, ALLNWELL, DX_55);
drDx56_(xc(DX_56), ULPPITCHID, ALLNWELL, nw_ext_waiver4sramid2);
//drDx57_(xc(DX_57), ULPPITCHID, ALLNWELL, DX_57);





drErrGDSHash["DX_er"] = {163,2001} ;
drValHash["DX_er"] = 0;

Error_DX_er @= {
 @ "DX_er: ID layer and transionid are worngly placed wrt each other"; 
 //TRDTOULP is placed wrong
 //tr_hole = donut_holes(TRDTOULP);
 //xor(ULPPITCHID,   drGrow(tr_hole, E = DX_12-dx_enc_of_id_by_tr,  W = DX_12-dx_enc_of_id_by_tr));
 
 //this is also like DX_11/12 check 
 os_ulppitchid = drGrow(ULPPITCHID, N = DX_11, S = DX_11, W = dx_enc_of_id_by_tr, E =  dx_enc_of_id_by_tr);
 tr_hole = drShrink(ULPPITCHID, W = DX_12-dx_enc_of_id_by_tr,  E = DX_12-dx_enc_of_id_by_tr);
 TRDTOULP xor (os_ulppitchid not tr_hole);
     
}

drErrGDSHash["DX_er2"] = {163,2012} ;
drValHash["DX_er2"] = 0;

//DX_er2 
Error_DX_er2 @= {
 @ "DX_er2: Wrongly palce xgoxid wrt to polyid";
  ULPPITCHID not_interacting XGOXID;
 
 xgox_w_ulp = XGOXID interacting  ULPPITCHID;
 xgox_w_ulp xor drGrow(ULPPITCHID, N = DX_11/2, S = DX_11/2); 
                                   
}


// drErrGDSHash["DX_er3"] = {163,2013} ;
// drValHash["DX_er3"] = 0;
// 
// //DX_er3 
// Error_DX_er3 @= {
//  @ "DX_er3: Runsets only support L-shpaped or rectangular polyid's";
//  
//   os_pgd_ulp_e = edge_size(angle_edge(ULPPITCHID, gate_angle), inside = drunit, outside = drunit);
//   interacting(ULPPITCHID, os_pgd_ulp_e, count > 3, include_touch = ALL);                                      
// }


// Push errors to the error stack 
drErrorStack.push_back({ Error_DX_er, drErrGDSHash[xc(DX_er)], "" });
drErrorStack.push_back({ Error_DX_er2, drErrGDSHash[xc(DX_er2)], "" });
//drErrorStack.push_back({ Error_DX_er3, drErrGDSHash[xc(DX_er3)], "" });


// DX_22/25/26/27

drDT22_(xc(DX_22), ULPPITCHID, DX_22);
drMinLengthEdge_(xc(DX_25),ULPPITCHID,DX_25);
drDT26_(xc(DX_26),ULPPITCHID,DX_26);
drMinHole_(xc(DX_27), ULPPITCHID, DX_27);


#ifdef _drDEBUG

 drPassthruStack.push_back({dig_tr_pl, {200,10} });
 drPassthruStack.push_back({dig_dx32, {200,4} });
 drPassthruStack.push_back({th_dx32, {200,5} });
 drPassthruStack.push_back({ogd_poly, {200,6} });
 drPassthruStack.push_back({finger_dig_270_1, {200,11} });
 drPassthruStack.push_back({finger_dig_270_2, {200,12} });
 drPassthruStack.push_back({finger_dig_270_3, {200,13} });
 drPassthruStack.push_back({finger_dig_270_4, {200,14} });
 drPassthruStack.push_back({finger_dig_270_5, {200,15} });
 drPassthruStack.push_back({finger_dig_270_6, {200,16} });
 drPassthruStack.push_back({finger_dig_270_7, {200,17} });
 drPassthruStack.push_back({finger_dig_270_8, {200,18} });
 drPassthruStack.push_back({palm_out1_270, {200,21} });
 drPassthruStack.push_back({palm_out2_270, {200,22} });
 drPassthruStack.push_back({palm_out3_270, {200,23} });
 drPassthruStack.push_back({palm_out4_270, {200,24} });
 drPassthruStack.push_back({palm_out5_270, {200,25} });
 
// drPassthruStack.push_back({pgd_ulp_90_corner_1, {200,26} });
 drPassthruStack.push_back({finger_dig_90_1, {200,31} });
 drPassthruStack.push_back({finger_dig_90_2, {200,32} });
 drPassthruStack.push_back({finger_dig_90_3, {200,33} });
 drPassthruStack.push_back({finger_dig_90_4, {200,34} });
 drPassthruStack.push_back({finger_dig_90_5, {200,35} });
 
 drPassthruStack.push_back({palm_out1_90, {200,41} });
 drPassthruStack.push_back({palm_out2_90, {200,42} });

 drPassthruStack.push_back({all_fixed_poly, {200,50} });
 drPassthruStack.push_back({all_dx364_poly, {200,51} });
 
  drPassthruStack.push_back({dx364_poly_1, {200,61} }); 
  drPassthruStack.push_back({dx364_poly_2, {200,62} }); 
  drPassthruStack.push_back({dx364_poly_3, {200,63} }); 
  drPassthruStack.push_back({dx364_poly_4, {200,64} }); 

  drPassthruStack.push_back({all_dx364_poly, {200,70} });
  drPassthruStack.push_back({th_dx32, {200,71} });
  drPassthruStack.push_back({all_fixed_poly_around90, {200,72} });
  drPassthruStack.push_back({all_fixed_poly_around270, {200,73} });
  drPassthruStack.push_back({dx44_poly, {200,74} });
  
  
  drPassthruStack.push_back({nw_ext_waiver4sramid2, {200,65} }); 
  

  drPassthruStack.push_back({ ULPPITCHID, {2,43} });
  drPassthruStack.push_back({ TRDTOULP, {81,143} });
  drPassthruStack.push_back({ POLY, {2,0} });
  drPassthruStack.push_back({ NDIFF, {1,0} });
  drPassthruStack.push_back({ PDIFF, {8,0} });
  drPassthruStack.push_back({ DIFFCON, {5,0} });
  drPassthruStack.push_back({ POLYCON, {6,0} });
  drPassthruStack.push_back({ NWELL, {11,0} });
  drPassthruStack.push_back({ TGOXID, {23,0} });
  drPassthruStack.push_back({ V1PITCHID, {2,151} });
  drPassthruStack.push_back({ V2PITCHID, {2,152} });
  drPassthruStack.push_back({ V3PITCHID, {2,153} });
  drPassthruStack.push_back({ TRDTOV1, {81,165} });
  drPassthruStack.push_back({ TRDTOV2, {81,166} });
  drPassthruStack.push_back({ TRDTOV3, {81,167} });
  drPassthruStack.push_back({ POLYCHECK, {84,0} });
  drPassthruStack.push_back({ SRAMID2, {2,39} });
#endif

#endif
