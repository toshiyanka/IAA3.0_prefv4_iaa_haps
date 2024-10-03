// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DT.rs.rca 1.8 Wed Oct  1 11:48:32 2014 oakin Experimental $
//
// $Log: p1273dx_DT.rs.rca $
// 
//  Revision: 1.8 Wed Oct  1 11:48:32 2014 oakin
//  fixed the comments for DA_er and DT_er.
// 
//  Revision: 1.7 Sun Dec 15 12:22:41 2013 oakin
//  added D*_22/25/26/27.
// 
//  Revision: 1.6 Thu Oct 10 11:35:31 2013 oakin
//  Updated the DT_06 check, it was not checking the holes in donut shape correctly.
// 
//  Revision: 1.5 Thu Nov 29 10:00:12 2012 oakin
//  flatten the inpuit going into the polygon_features.
// 
//  Revision: 1.4 Mon Oct 29 13:48:02 2012 cpark3
//  replaced double quotes around rule labels with xc()
//  done to enable upgrades for TSDR
//  full list DT_03/70/71/72/73/173/174/175/176
// 
//  Revision: 1.3 Thu Jul 26 15:09:01 2012 oakin
//  TG and TGULV can abut.
// 
//  Revision: 1.2 Wed Feb 22 14:11:45 2012 oakin
//  fixed 90-270 edges for fixed poly lines.
// 
//  Revision: 1.1 Thu Nov  3 15:31:53 2011 dgthakur
//  Moved 1273 transistion region checks to 1273 folder.
// 
//  Revision: 1.7 Thu Aug 11 14:12:49 2011 oakin
//  moved DT_06 funciton in tr_func.added dt_25. some function names changed.
//  dx52 moved to a function.
// 
//  Revision: 1.6 Fri Jul 29 16:18:14 2011 oakin
//  in fcnt dr_tr_tcn_rules_ last var is a constraint now.
// 
//  Revision: 1.5 Thu Jul 28 10:23:23 2011 oakin
//  fixed an input in dr_tr_tcn_rules_. The first tcn out of tr does not need to align (talked to Moonsoo (july/28/11)).
// 
//  Revision: 1.4 Tue Jul 26 08:33:38 2011 oakin
//  updated the whole module, using functions now.
// 
//  Revision: 1.3 Wed Jul 13 11:15:41 2011 oakin
//  changed the fixed poly for rectelinear.
//  added DT_44/45/52.
// 
//  Revision: 1.2 Fri Jun 24 14:18:37 2011 oakin
//  added DT_05 and TGOXID checks.
//  added to dt_06 still not done.
// 
//  Revision: 1.1 Fri Jun 17 11:48:59 2011 oakin
//  first check-in (still not complete).
// 

#ifndef _P1273DX_DT_RS_
#define _P1273DX_DT_RS_

//REMOVE THESE *START (till the functions in tr_functions are cleaned up)
polyod_like = copy(POLYOD);
trdtos_like = copy(TRDTOS);
cor_trdtos_like = copy(cor_trdtos);
ogd_trdtos_like = copy(ogd_trdtos); 
pgd_trdtos_like = copy(pgd_trdtos);
//id_edges:Return4Edges;
id_edges = drGetEdge(V3PITCHID);
//REMOVE THESE *END

ogd_tr_width = DT_11;
#include <p12723_tr_functions.rs>


tr_id = copy(TRDTOV3);
poly_id = copy(V3PITCHID);
 
 //first four dig poly lines
 tr_pgd_e = angle_edge(tr_id or poly_id, gate_angle);
 dig1 = edge_size(tr_pgd_e, inside = DT_361);
 dig2 = edge_size(tr_pgd_e, inside = 2*DT_361+DT_371) not edge_size(tr_pgd_e, inside = DT_361+DT_371);
 dig3 = edge_size(tr_pgd_e, inside = 3*DT_361+DT_371+DT_372) not edge_size(tr_pgd_e, inside = 2*DT_361+DT_371+DT_372);
 dig4 = edge_size(id_edges.edge4, outside = DT_375-DT_38+DT_363+DT_374+DT_362) not edge_size(id_edges.edge4, outside = DT_375-DT_38+DT_363+DT_374);
 dig5 = drCreatePoly_in(tr_pgd_e, 3*DT_361+DT_371+DT_372+DT_373+DT_362, 3*DT_361+DT_371+DT_372+DT_373);
 dig1234 = dig1 or dig2 or dig3 or (dig4 and dig5);

 dt363_poly = edge_size(id_edges.edge4, outside = DT_375-DT_38+DT_363) not edge_size(id_edges.edge4, outside = DT_375-DT_38);
 dt363_poly_tr = drCreatePoly_in(tr_pgd_e, 3*DT_361+DT_371+DT_372+DT_373+DT_362+DT_374+DT_363,3*DT_361+DT_371+DT_372+DT_373+DT_362+DT_374);
 dt364_poly = edge_size(id_edges.edge4, inside = DT_38 + DT_364) not edge_size(id_edges.edge4, inside = DT_38 );
 dt364_poly_tr = drCreatePoly_in(tr_pgd_e, 3*DT_361+DT_371+DT_372+DT_373+DT_362+DT_374+DT_363+DT_375+DT_364, 3*DT_361+DT_371+DT_372+DT_373+DT_362+DT_374+DT_363+DT_375);
 all_tr_poly = dig1234 or (dt363_poly and dt363_poly_tr) or (dt364_poly and dt364_poly_tr);

 //min poly length touching the tr region
 tr_ogd_e = angle_edge(tr_id or poly_id, non_gate_angle);
 id_all_edges = drGetEdge(poly_id or tr_id); 
 tr_ogd_e = tr_ogd_e not_coincident_edge (id_all_edges.edge3 or_edge id_all_edges.edge2);
 os_270_270_e = extend_edge(id_all_edges.edge3, start = PL_01, end = PL_01);
 allid_corner_270 = vertex((poly_id or tr_id), angles = {270}, shape_size = 2*0.042);
 os_270_90_e = id_all_edges.edge2 not_edge allid_corner_270;
 dig_dt32 = drCreatePitchMarkers(edge_size(tr_ogd_e or_edge os_270_270_e or_edge os_270_90_e, outside = DT_32), PL_01, PL_02,0,gate_dir);

 only_tr_ogd_e = angle_edge(adjacent_edge(tr_id, length > 0, angle1 = 90, angle2 = 90), non_gate_angle);
 tr_and_pitch_e = touching_edge(tr_id, poly_id);
 
 tr_ogd_e_dt32 = angle_edge(extend_edge(tr_and_pitch_e not_coincident_edge only_tr_ogd_e, start = DT_364, end = DT_364) , non_gate_angle) or_edge (only_tr_ogd_e coincident_edge tr_and_pitch_e);
 th_dt32 = drCreatePitchMarkers(edge_size(tr_ogd_e_dt32 and_edge tr_id, outside = DT_32), TPL_01, TPL_02,0,gate_dir);

//  drPassthruStack.push_back({tr_ogd_e_dt32 , {200,10} });
//  drPassthruStack.push_back({only_tr_ogd_e , {200,9} });
//  drPassthruStack.push_back({tr_and_pitch_e , {200,8} });
//  drPassthruStack.push_back({dig_dt32 , {200,7} });
//  drPassthruStack.push_back({allid_corner_270 , {200,6} });
//  drPassthruStack.push_back({id_all_edges.edge2 , {200,5} });
 
 all_reg_poly =  all_tr_poly or dig_dt32 or th_dt32;

// THIS IS THE NEW WAY **** START

 id_edges = drGetEdge(poly_id);

 ext_id_9090e_tg = extend_edge(id_edges.edge1, start =  DT_375 - DT_38, end = DT_375 - DT_38 );
 inside_tg = drCreatePitchMarkers(edge_size(ext_id_9090e_tg, outside = 0.093+0.078) not edge_size(ext_id_9090e_tg, outside = 0.078), TPL_01, TPL_02, DT_375, gate_dir);

 inside_28 = edge_size(ext_id_9090e_tg, outside = 0.093 + 0.078) not edge_size(ext_id_9090e_tg, outside = 0.093 + 0.078 - 0.028);
 
 //get the edge close to the 90 corner
  edge_90 =  extend_edge(id_edges.edge1, start = 0.249, end =  0.249) not_edge poly_id;
  inside_28_c90 = edge_size(edge_90, outside = 0.093 + 0.078) not edge_size(edge_90, outside = 0.093 + 0.078 - 0.028);
  
  pgd_v3_90_corner = drGetPGDedge_90cor(poly_id, 0.093 + 0.078, 0.093); 
  outside_90_1 = drCreatePoly_out(pgd_v3_90_corner, 0.169, 0.031);
  outside_90_2 = drCreatePoly_out(pgd_v3_90_corner, 0.249, 0.221);
   
  pgd_v3_270_corner =   drGetPGDedge_270cor(poly_id, 0.078, 0.093);
  outside_270_1 = edge_size(pgd_v3_270_corner, inside = 0.185) not edge_size(pgd_v3_270_corner, inside = 0.025);

 
  us_ogd_e = extend_edge(id_edges.edge1, start = -0.259, end = -0.259) ;
 //93 and 28 lines
  outside_dig_fingers_1 = drCreatePitchMarkers(edge_size(us_ogd_e, outside = 0.078+2*0.093+0.12) not edge_size(us_ogd_e, outside = 0.078+0.093+0.12), PL_01, PL_02,PL_02 - PL_01,gate_dir); 
  outside_dig_fingers_2 = drCreatePitchMarkers(edge_size(us_ogd_e, outside = 0.078+0.093+0.12+0.028) not edge_size(us_ogd_e, outside = 0.078+0.093+0.12), PL_02-PL_01, 2*PL_02,PL_02,gate_dir); 
 
  //these are the last four ones around the 90 corner
  pgd_v3_90_corner_1 = drGetPGDedge_90cor(poly_id, 0.093 + 0.078 + 0.12 + 0.093, 0.093); 
  os_pgd_v3_90_corner_1 = edge_size(pgd_v3_90_corner_1, inside = 0.259, outside = 0.259);
  outside_dig_fingers_90_1 = drCreatePitchMarkers(os_pgd_v3_90_corner_1, PL_01, PL_02, 0, gate_dir); 
    
  pgd_v3_90_corner_2 = drGetPGDedge_90cor(poly_id, 0.093 + 0.078 + 0.12 + 0.028, 0.028); 
  os_pgd_v3_90_corner_2 = edge_size(pgd_v3_90_corner_2, inside = 0.259, outside = 0.259);
  outside_dig_fingers_90_2 = drCreatePitchMarkers(os_pgd_v3_90_corner_2, PL_02 - PL_01, 2*PL_02, PL_01, gate_dir); 
  
  //get the structure around 270 corner
  pgd_v3_270_corner_1 = drGetPGDedge_270cor(poly_id, 0.093 + 0.078 + 0.12, 0.093);  
  finger_dig_270 = drCreatePoly_out(pgd_v3_270_corner_1, 0.249, 0.249 - PL_01);
  finger_out_270 = drCreatePoly_out(pgd_v3_270_corner_1, 0.169, 0.031);
  finger_in_270  = drCreatePoly_in(pgd_v3_270_corner_1, 0.185, 0.025);
   
  pgd_v3_270_corner_2 = drGetPGDedge_270cor(poly_id, 0.093 + 0.078 + 0.12, 0.028);
  palm_out1_270 = drCreatePoly_out(pgd_v3_270_corner_2, 0.221, 0.169);
  palm_out2_270 = drCreatePoly_out(pgd_v3_270_corner_2, 0.031, 0);
  palm_in_270   = drCreatePoly_in(pgd_v3_270_corner_2, 0.025, 0);
  
  //poly between inner and outer
  pgd_v3_270_corner_3 = drGetPGDedge_270cor(poly_id, 0.093 + 0.078, 0.120);
  finger_in_270_inout = drCreatePoly_in(pgd_v3_270_corner_3, 0.185, 0.185 - PL_01);
     
 
 outer_irr_poly = palm_in_270 or palm_out2_270 or palm_out1_270 or
                  finger_dig_270 or finger_out_270 or finger_in_270 or
		  outside_dig_fingers_90_1 or outside_dig_fingers_90_2 or
		  outside_dig_fingers_1 or outside_dig_fingers_2;
 
 inner_irr_poly = inside_tg or inside_28 or outside_270_1 or outside_90_1 or outside_90_2 or inside_28_c90;
 
 all_irr_poly = outer_irr_poly or inner_irr_poly or finger_in_270_inout;
 
 
 dt_44_edge = drGetPGDedge_270cor(poly_id, 0, 0.462); 
 os_dt_44_edge = extend_edge(dt_44_edge, start = DT_44, end = DT_44);
 dt44_poly = drCreatePoly_in(os_dt_44_edge, 0.395, 0.395 - TPL_01);
 
 all_fixed_poly = all_irr_poly or all_reg_poly or dt44_poly;
 
#ifdef _drDEBUG 
 drPassthruStack.push_back({th_dt32 , {200,11} });
 drPassthruStack.push_back({all_reg_poly , {200,12} });
 drPassthruStack.push_back({edge_90 , {200,13} });
 drPassthruStack.push_back({inside_28_c90 , {200,14} });
 drPassthruStack.push_back({pgd_v3_90_corner , {200,15} });
 drPassthruStack.push_back({outside_90_1 , {200,16} });
 drPassthruStack.push_back({outside_90_2 , {200,17} });
 drPassthruStack.push_back({pgd_v3_270_corner , {200,18} });
 drPassthruStack.push_back({outside_270_1 , {200,19} });
 drPassthruStack.push_back({ext_id_9090e_tg , {200,20} });
 
 drPassthruStack.push_back({us_ogd_e , {200,21} });
 drPassthruStack.push_back({outside_dig_fingers_1 , {200,22} });
 drPassthruStack.push_back({outside_dig_fingers_2 , {200,23} });
 drPassthruStack.push_back({pgd_v3_90_corner_1, {200,24} });
 drPassthruStack.push_back({os_pgd_v3_90_corner_1 , {200,25} });
 drPassthruStack.push_back({outside_dig_fingers_90_1 , {200,26} });
 drPassthruStack.push_back({outside_dig_fingers_90_2 , {200,27} });
 drPassthruStack.push_back({finger_dig_270 , {200,28} });
 drPassthruStack.push_back({finger_out_270 , {200,29} });
 drPassthruStack.push_back({finger_in_270 , {200,30} });
 drPassthruStack.push_back({palm_in_270 , {200,31} });
 drPassthruStack.push_back({palm_out1_270 , {200,32} });
 drPassthruStack.push_back({palm_out2_270 , {200,33} });
 drPassthruStack.push_back({outer_irr_poly , {200,34} });
 drPassthruStack.push_back({inner_irr_poly , {200,35} });
 drPassthruStack.push_back({all_irr_poly , {200,36} });
 drPassthruStack.push_back({finger_in_270_inout , {200,37} });
 
 
 drPassthruStack.push_back({ os_dt_44_edge, {200,40} });
 drPassthruStack.push_back({ dt44_poly, {200,41} });
 drPassthruStack.push_back({ dt_44_edge, {200,42} });
#endif

// THIS IS THE NEW WAY **** END

dt_enc_of_id_by_tr = DT_12 - (DT_38 + DT_364);

//DT_01
dr_Dx01_check_(xc(DT_01), V3PITCHID, TRDTOV3, cor_v3tr, ogd_v3tr, pgd_v3tr, DT_12, PL_01, TPL_01, DT_38, DT_12+0.007, DT_173, DT_73, 0.011);

//DT_02
drDx02_(xc(DT_02), TRDTOV3, dr_all_polyid, dr_all_trid, dr_trid_list, DT_11, DT_12, DT_12, V3PITCHID, 2*dt_enc_of_id_by_tr + DT_03);

//DT_03
drDx03_(xc(DT_03), TRDTOV3, dr_trid_list_4dt03, DT_03); 
err @= {
    @ GetRuleString(xc(DT_03),"um"); note(CheckingString(xc(DT_03)));
    external2(TRDTOV3, TRDTOV1, distance < DT_03, direction = non_gate_dir,  extension = NONE_INCLUSIVE );
    
 }
drErrorStack.push_back({ err, drErrGDSHash[xc(DT_03)], "" });    


//DT_04
drMinSpaceDir_(xc(DT_04), V3PITCHID, <DT_04, gate_dir); 

//DT_05
drDx05_(xc(DT_05), V3PITCHID, TRDTOV3, DT_05);

// DT_06

_dx06_pitch = 0.21;
_dx06_offset = 0.05;
Error_DT_06 @= {
  @ GetRuleString(xc(DT_06),"um"); note(CheckingString(xc(DT_06)));    
  
  
  
  flat_trdtov3 = flatten_by_cells(TRDTOV3, "*");
  polygon_features(donut_holes(flat_trdtov3), polygon_function = multof4);  
  
  ogd_trdto3_ogd_e = outside_touching_edge(flat_trdtov3, V3PITCHID);
  
  os_edges = edge_size( angle_edge(not_adjacent_edge(donut_holes(flat_trdtov3), length > 0, angle1 = 270), non_gate_angle), inside = drgrid, outside = drgrid);
  polygon_features(os_edges, polygon_function = multof4);    
  os_edges_1 = edge_size( angle_edge(outside_touching_edge(not_adjacent_edge(flat_trdtov3, length > 0, angle1 = 90), V3PITCHID), non_gate_angle), inside = drgrid, outside = drgrid);
  polygon_features(os_edges_1, polygon_function = multof4);
//  drPassthruStack.push_back({os_edges , {1112,1} }); 
  
    
  os_edges = edge_size( extend_edge(angle_edge(adjacent_edge(donut_holes(flat_trdtov3), length > 0, angle1 = 270, angle2 = 270), non_gate_angle),start=0.05, end =0.05), inside = drgrid, outside = drgrid);
  polygon_features(os_edges, polygon_function = multof4);     
  os_edges_2 = edge_size( extend_edge(angle_edge(outside_touching_edge(adjacent_edge(flat_trdtov3, length > 0, angle1 = 90, angle2 = 90), V3PITCHID), non_gate_angle),start=0.05, end =0.05), inside = drgrid, outside = drgrid);
  polygon_features(os_edges_2, polygon_function = multof4);  
//  drPassthruStack.push_back({os_edges , {1112,2} }); 
     
  os_edges = edge_size( extend_edge(angle_edge(adjacent_edge(donut_holes(flat_trdtov3), length > 0, angle1 = 90, angle2 = 270), non_gate_angle),start=0.025, end =0.025), inside = drgrid, outside = drgrid);
  polygon_features(os_edges, polygon_function = multof4);       
  os_edges_3 = edge_size( extend_edge(angle_edge(outside_touching_edge(adjacent_edge(flat_trdtov3, length > 0, angle1 = 90, angle2 = 270), V3PITCHID), non_gate_angle),start=0.025, end =0.025), inside = drgrid, outside = drgrid);
  polygon_features(os_edges_3, polygon_function = multof4);
//  drPassthruStack.push_back({os_edges , {1112,3} }); 
      
   
//  drPassthruStack.push_back({os_edges_1 , {1111,1} }); 
//  drPassthruStack.push_back({os_edges_2 , {1111,2} });     
//  drPassthruStack.push_back({os_edges_3 , {1111,3} }); 
//  drPassthruStack.push_back({ogd_trdto3_ogd_e , {1111,4} });    
}
drErrorStack.push_back({ Error_DT_06, drErrGDSHash[xc(DT_06)], "" });

//DT_11/12 also DT_02
dr_Dx11_12_check_(xc(DT_11), TRDTOV3, DT_11, DT_12);


//DT_24
drMinWidthDir_( xc(DT_24), V3PITCHID, DT_24, non_gate_dir);

//DT_25
drDx25_(xc(DT_25), V3PITCHID, DT_25);

//DT_30
drMinSpaceSamePoly_( xc(DT_30), V3PITCHID, DT_30);

//DT_7x TCN in tr rules
dr_tr_tcn_rules_(xc(DT_70), xc(DT_71), xc(DT_72), xc(DT_73), xc(DT_173), xc(DT_174), xc(DT_175), xc(DT_176),
                  DT_70, DT_71, DT_72, DT_73, DT_173, DT_174, DT_175, DT_176,
		  V3PITCHID, TRDTOV3, pgd_v3tr, ogd_v3tr, cor_v3tr,
		  DT_11, DT_73, PL_02/2, DT_12 - (DT_375+DT_364), PL_02, TPL_02, ==5);

//DT_31/32/41 covers DT_33
//DT_35, DT_361/2/3, DT_371/2/3/4/5, DT_38, DT_44
drawn_dt44_poly = POLY and edge_size(os_dt_44_edge, inside = 0.395);
dr_Dx31_32_41_check_(xc(DT_31), TRDTOV3, all_fixed_poly, DT_32, drawn_dt44_poly, TRDTOV1);


//DT_45
 Error_DT_45 @= {
  @ GetRuleString(xc(DT_45),"um"); note(CheckingString(xc(DT_45)));
    gate interacting  dt44_poly;
}
drErrorStack.push_back({ Error_DT_45, drErrGDSHash[xc(DT_45)], "" }); 
  	

//DT_52 looks like a repeat of DT_01

// //DT_52
// Error_DT_52 @= {
//   @ GetRuleString(xc(DT_52),"um"); note(CheckingString(xc(DT_52)));    
//   //first half dig can be used
//   tr_and_id = V3PITCHID or TRDTOV3;
//   us_tr_and_id = drShrink(tr_and_id, E = PL_01/2, W = PL_01/2);  
//   //the first TG in id region
//   ogd_tr = internal1(TRDTOV3, distance = DT_12, direction = non_gate_dir, extension = NONE);
//   fr_tg_poly = drShrink(V3PITCHID, E = DT_38 + TPL_01/2, W = DT_38 + TPL_01/2);
//   diff_allowed = fr_tg_poly and ogd_tr;
//   
//   no_diff_region = us_tr_and_id and TRDTOV3 not diff_allowed;
//   no_diff_region and DIFF;
//   #ifdef _drDEBUG
//    drPassthruStack.push_back({no_diff_region, {101,99} });
//   #endif 
// }

drDx52_(xc(DT_52), V3PITCHID, TRDTOV3, TPL_01, cor_v3tr);

dr_yoffset = 0.0;
dr_xoffset = DT_38 + DT_364;
drDx53_(xc(DT_53), V3PITCHID, TRDTOV3, ALLNWELL, dr_yoffset, DT_53, DT_364);
drDx54_(xc(DT_54), V3PITCHID, TRDTOV3, ALLNWELL, dr_xoffset, DT_54); 
drDx55_(xc(DT_55), V3PITCHID, ALLNWELL, DT_55);
drDx56_(xc(DT_56), V3PITCHID, ALLNWELL);
//drDx57_(xc(DT_57), V3PITCHID, ALLNWELL, DT_57);



drErrGDSHash["DT_er"] = {165,2001} ;
drValHash["DT_er"] = 0;

Error_DT_er @= {
 @ "DT_er: ID layer and transionid are wrongly placed wrt each other"; 
 //TRDTOV3 is placed wrong
 //tr_hole = donut_holes(TRDTOV3);
 //xor(V3PITCHID,   drGrow(tr_hole, E = DT_38+DT_364,  W = DT_38+DT_364)) not (donut_holes(V3PITCHID, INNER) interacting TRDTOV3) ;
 
 //this is also like DT_11/12 check 
 os_v3pitchid = drGrow(V3PITCHID, N = DT_11, S = DT_11, W = DT_12 - (DT_38+DT_364), E =  DT_12 - (DT_38+DT_364));
 tr_hole = drShrink(V3PITCHID, W = DT_38+DT_364,  E = DT_38+DT_364);
 TRDTOV3 xor (os_v3pitchid not tr_hole);
     
}


drErrGDSHash["DT_er2"] = {165,2012} ;
drValHash["DT_er2"] = 0;

//DT_er2 
Error_DT_er2 @= {
 @ "DT_er2: Wrongly palce tgoxid wrt to polyid";
  TGOXID not_interacting (V1PITCHID or V3PITCHID);
 
 tgox_w_v3 = TGOXID interacting  V3PITCHID;
 tgox_w_v3 xor drGrow(V3PITCHID, N = 0.078 + 0.093+ 0.12/2, S = 0.078 + 0.093+ 0.12/2, 
                                 E = DT_375 - DT_38 +DT_363+DT_374+DT_362+DT_373/2, W = DT_375 - DT_38 +DT_363+DT_374+DT_362+DT_373/2);  
}



// Push errors to the error stack 
drErrorStack.push_back({ Error_DT_er, drErrGDSHash[xc(DT_er)], "" });
drErrorStack.push_back({ Error_DT_er2, drErrGDSHash[xc(DT_er2)], "" });
drErrorStack.push_back({ Error_DT_52, drErrGDSHash[xc(DT_52)], "" });


drDT22_(xc(DT_22), V3PITCHID, DT_22);
drMinLengthEdge_(xc(DT_25),V3PITCHID,DT_25);
drDT26_(xc(DT_26),V3PITCHID,DT_26);
drMinHole_(xc(DT_27), V3PITCHID, DT_27);


#ifdef _drDEBUG
  drPassthruStack.push_back({ V3PITCHID, {2,153} });
  drPassthruStack.push_back({ TRDTOV3, {81,167} });
  drPassthruStack.push_back({ TRDTOV1, {81,165} });
  drPassthruStack.push_back({ POLY, {2,0} });
  drPassthruStack.push_back({ NDIFF, {1,0} });
  drPassthruStack.push_back({ PDIFF, {8,0} });
  drPassthruStack.push_back({ DIFFCON, {5,0} });
  drPassthruStack.push_back({ TGOXID, {23,0} });
  
  drPassthruStack.push_back({ id_edges.edge1, {100,1} });
  drPassthruStack.push_back({ id_edges.edge2, {100,2} });
  drPassthruStack.push_back({ id_edges.edge3, {100,3} });
  
  drPassthruStack.push_back({ inside_tg, {100,4} });
  drPassthruStack.push_back({ inside_28, {100,5} });
 // drPassthruStack.push_back({ inside_last_dig, {100,6} });
  drPassthruStack.push_back({ dig1234, {100,7} });
  
 // drPassthruStack.push_back({ outside_fingers, {100,8} });
 // drPassthruStack.push_back({ inside_fingers, {100,9} });
  drPassthruStack.push_back({ all_tr_poly, {100,10} });
  drPassthruStack.push_back({ all_fixed_poly, {100,11} });
  
 drPassthruStack.push_back({ dt364_poly, {100,12} });
#endif

#endif
