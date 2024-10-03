// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DA.rs.rca 1.9 Wed Oct  1 11:48:32 2014 oakin Experimental $
//
// $Log: p1273dx_DA.rs.rca $
// 
//  Revision: 1.9 Wed Oct  1 11:48:32 2014 oakin
//  fixed the comments for DA_er and DT_er.
// 
//  Revision: 1.8 Sun Dec 15 12:22:41 2013 oakin
//  added D*_22/25/26/27.
// 
//  Revision: 1.7 Mon Oct 29 13:58:42 2012 cpark3
//  replaced double quotes around rule labels with xc()
//  done to enable upgrades for TSDR
//  full list DA_03/70/71/72/73/173/174/175/176
// 
//  Revision: 1.6 Thu Aug 23 13:05:39 2012 oakin
//  changed the label for DA_46.
// 
//  Revision: 1.5 Mon Aug 20 07:33:44 2012 oakin
//  made changes for the new fixed poly tr.
// 
//  Revision: 1.4 Thu Jul 26 15:09:01 2012 oakin
//  TG and TGULV can abut.
// 
//  Revision: 1.3 Mon May 28 13:03:28 2012 oakin
//  fixed the 270 corner fixed poly .
// 
//  Revision: 1.2 Tue Mar 27 16:57:02 2012 oakin
//  fixed a typo in DA_30 (was checking V3 id instead of V1).
// 
//  Revision: 1.1 Thu Nov  3 15:31:53 2011 dgthakur
//  Moved 1273 transistion region checks to 1273 folder.
// 
//  Revision: 1.9 Fri Sep  2 11:39:46 2011 oakin
//  work around for icv bug (was generating wrong ogd_poly causing false DA_31 errors).
// 
//  Revision: 1.8 Thu Aug 11 14:14:29 2011 oakin
//  da_52 moved to function. some function name changes.
// 
//  Revision: 1.7 Fri Jul 29 16:19:14 2011 oakin
//  in fcnt dr_tr_tcn_rules_ last var is a constraint now.
// 
//  Revision: 1.6 Thu Jul 28 10:24:36 2011 oakin
//  fixed an input in dr_tr_tcn_rules_. The first tcn out of tr does not need to align (talked to Moonsoo (july/28/11)).
//  fixed some typo to labels (DT ==> DA).
// 
//  Revision: 1.5 Tue Jul 26 08:46:36 2011 oakin
//  changed the module, now using functions.
// 
//  Revision: 1.4 Wed Jul 13 11:11:21 2011 oakin
//  addded DA_52.
// 
//  Revision: 1.3 Fri Jun 24 14:17:41 2011 oakin
//  added DA_05 and TGOXID checks.
// 
//  Revision: 1.2 Tue Jun 21 09:31:32 2011 oakin
//  changed variable name to prevent redefinition.
// 
//  Revision: 1.1 Fri Jun 17 11:48:59 2011 oakin
//  first check-in (still not complete).
// 

#ifndef _P1273DX_DA_RS_
#define _P1273DX_DA_RS_

//REMOVE THESE *START (till the functions in tr_functions are cleaned up)
polyod_like = copy(POLYOD);
trdtos_like = copy(TRDTOS);
cor_trdtos_like = copy(cor_trdtos);
ogd_trdtos_like = copy(ogd_trdtos); 
pgd_trdtos_like = copy(pgd_trdtos);
//id_edges:Return4Edges;
id_edges = drGetEdge(V1PITCHID);
//REMOVE THESE *END

ogd_tr_width = DA_11;
#include <p12723_tr_functions.rs>


id_edges_da:Return4Edges;
id_edges_da = drGetEdge(V1PITCHID);


 // first two dig polies
 tr_pgd_e = angle_edge(TRDTOV1 or V1PITCHID, gate_angle);
 dig1 = edge_size(tr_pgd_e, inside = DA_361);
 //dig2 = edge_size(tr_pgd_e, inside = 2*DA_361+DA_371) not edge_size(tr_pgd_e, inside = DA_361+DA_371);
 dig2_poly_1 = edge_size(id_edges_da.edge4, outside = DA_372-DA_38+DA_361 ) not edge_size(id_edges_da.edge4, outside = DA_372-DA_38 );
 dig2_poly_1_tr = drCreatePoly_in(tr_pgd_e, 2*DA_361+DA_371, DA_361+DA_371);
 dig2 = dig2_poly_1 and dig2_poly_1_tr;
 

 //get the tr v1 poly
 da362_poly_1 = edge_size(id_edges_da.edge4, inside = DA_38 + DA_362) not edge_size(id_edges_da.edge4, inside = DA_38 );
 da362_poly_1_tr = drCreatePoly_in(tr_pgd_e, 2*DA_361+DA_371+DA_372+DA_362, 2*DA_361+DA_371+DA_372);
 da362_poly_2 = edge_size(id_edges_da.edge4, inside = DA_38 + 2*DA_362 + DA_373) not edge_size(id_edges_da.edge4, inside = DA_38 + DA_362 + DA_373);
 da362_poly_2_tr = drCreatePoly_in(tr_pgd_e, 2*DA_361+DA_371+DA_372+2*DA_362+DA_373, 2*DA_361+DA_371+DA_372+DA_373);
 cont_poly = dig1 or dig2 or (da362_poly_1 and da362_poly_1_tr) or (da362_poly_2 and da362_poly_2_tr); 

 //min poly length touching the tr region
 tr_ogd_e = angle_edge(level(TRDTOV1) or V1PITCHID, non_gate_angle);
 id_all_edges = drGetEdge(V1PITCHID or TRDTOV1);
 tr_ogd_e = tr_ogd_e not_coincident_edge (id_all_edges.edge3 or_edge id_all_edges.edge2);
 os_270_270_e = extend_edge(id_all_edges.edge3, start = PL_01, end = PL_01);
 allid_corner_270 = vertex((V1PITCHID or TRDTOV1), angles = {270}, shape_size = 2*0.042);
 os_270_90_e = id_all_edges.edge2 not_edge allid_corner_270;
 dig_da32 = drCreatePitchMarkers(edge_size(tr_ogd_e or_edge os_270_270_e or_edge os_270_90_e, outside = DA_32, inside = 0.078 + 0.093), PL_01, PL_02,0,gate_dir);
 cut_mask = edge_size(tr_ogd_e or_edge os_270_270_e or_edge os_270_90_e, inside = 0.078 );
 dig_da32 = dig_da32 not cut_mask;

 // all_edge = tr_ogd_e or_edge os_270_270_e or_edge os_270_90_e;
//  grow_dig_palm = edge_size(all_edge, inside = 0.171) not edge_size(all_edge, inside = 0.143);
//  dig_palm = drCreatePitchMarkers(grow_dig_palm, PL_02-PL_01, 2*PL_02,PL_01+PL_02,gate_dir);
  

 ogd_da38 = extend_edge(id_edges_da.edge1, start = -1*DA_38, end = -1*DA_38);
 th_da32  = drCreatePitchMarkers(edge_size(ogd_da38, inside = DA_32, outside = 0.078 + 0.093), APL_01, APL_02,0,gate_dir);
 cut_mask = edge_size(ogd_da38,  outside = 0.078);
 th_da32 = th_da32 not cut_mask;
 

 polyid_ogd_e = angle_edge( V1PITCHID, non_gate_angle);
 os_polyid_ogd_e = extend_edge(polyid_ogd_e, start = DA_372-DA_38+0.004, end = DA_372-DA_38+0.004);
 v1_palm = edge_size(os_polyid_ogd_e, outside = 0.171) not edge_size(os_polyid_ogd_e, outside = 0.143);

 os_polyid_ogd_e = extend_edge(polyid_ogd_e, start = DA_372-DA_38, end = DA_372-DA_38);
 dig_palm_area = edge_size(os_polyid_ogd_e, outside = 0.319) not edge_size(os_polyid_ogd_e, outside = 0.319-0.028);
 dig_palm = drCreatePitchMarkers(dig_palm_area, PL_02-PL_01, 2*PL_02,0,gate_dir);
 
 os_polyid_ogd_e = extend_edge(polyid_ogd_e, start = DA_361 + DA_372 - DA_38, end = DA_361 + DA_372 - DA_38);
 dig_finger_area = edge_size(os_polyid_ogd_e, outside = 0.384) not edge_size(os_polyid_ogd_e, outside = 0.384-0.093);
 dig_finger = drCreatePitchMarkers(dig_finger_area, PL_01, PL_02,0,gate_dir);
 
 // get the ogd poly pieces
//  tr_ogd_e = angle_edge(level(TRDTOV1) or V1PITCHID, non_gate_angle);
//  us_tr_ogd_e = extend_edge(tr_ogd_e, start = -2*PL_02, end = -2*PL_02);
//  drPassthruStack.push_back({us_tr_ogd_e , {299,1} });
//  us_tr_ogd_e = us_tr_ogd_e or_edge os_270_90_e or_edge extend_edge(os_270_270_e, start = -1*PL_02, end = -1*PL_02);
//  drPassthruStack.push_back({us_tr_ogd_e , {299,2} });
//  drPassthruStack.push_back({os_270_90_e , {299,3} });
//  drPassthruStack.push_back({os_270_270_e , {299,4} });
//  ogd_poly = drCreatePitchMarkers(edge_size(us_tr_ogd_e, outside = DA_32, inside = 0.078 + 0.093 ), PL_02 - PL_01, 2*PL_02,PL_01,gate_dir);
//  cut_mask = edge_size(us_tr_ogd_e, outside = DA_32, inside = 0.078 + 0.093 - 0.028); 
//  ogd_poly = (ogd_poly not cut_mask) and drShrink(TRDTOV1 or V1PITCHID, E = PL_02, W = PL_02);
 
 
 
 
 //get the structure around 270 corner
 pgd_v1_270_corner_1 = drGetPGDedge_270cor(V1PITCHID, 0.093 + 0.078 + 0.12, 0.093); 
 finger_v1_270_1 = drCreatePoly_in(pgd_v1_270_corner_1, DA_38 + DA_362, DA_38);
 finger_v1_270_2 = drCreatePoly_in(pgd_v1_270_corner_1, DA_38 + DA_362  +DA_373 + DA_362, DA_38 +DA_373 + DA_362);
  
 pgd_v1_270_corner_2 = drGetPGDedge_270cor(V1PITCHID, 0.093 + 0.078 + 0.12, 0.028);
 palm_v1_270_1 = drCreatePoly_in(pgd_v1_270_corner_2, DA_38 + DA_362 + DA_373, DA_38 + DA_373);
  
 pgd_v1_270_corner_3 = drGetPGDedge_270cor(V1PITCHID, 0.093 + 0.078 + 0.12 + 0.028, 0.093 - 0.028); 
 cut_sliver = drCreatePoly_in(pgd_v1_270_corner_3, 0.025, 0.021);
 
 pgd_v1_270_corner_4 = drGetPGDedge_270cor(V1PITCHID, 0.078, 0.093); 
 finger_v1_270_3 = drCreatePoly_in(pgd_v1_270_corner_4, DA_38 + DA_362, DA_38);
 finger_v1_270_4 = drCreatePoly_in(pgd_v1_270_corner_4, DA_38 + DA_362  +DA_373 + DA_362, DA_38 +DA_373 + DA_362);

 pgd_v1_270_corner_5 = drGetPGDedge_270cor(V1PITCHID, 0.093 + 0.078 - 0.028, 0.028);
 palm_v1_270_2 = drCreatePoly_in(pgd_v1_270_corner_5, DA_38 + DA_362 + DA_373, DA_38 + DA_373);

 pgd_v1_270_corner_6 = drGetPGDedge_270cor(V1PITCHID, 0.078, 0.306); 
 finger_irr_270_1 = drCreatePoly_in(pgd_v1_270_corner_6, DA_38 + 2*DA_362 + DA_373,DA_38 + 2*DA_362 + DA_373-PL_01 );

 pgd_v1_270_corner_7 = drGetPGDedge_270cor(V1PITCHID, 0.291, 0.093); 
 finger_dig_270_1 = drCreatePoly_out(pgd_v1_270_corner_7, 0.119, 0.091);
  
 pgd_v1_270_corner_8 = drGetPGDedge_270cor(V1PITCHID, 0.291, 0.093); 
 finger_dig_270_3 = drCreatePoly_out(pgd_v1_270_corner_8, 0.049, 0.021);
 
 pgd_v1_270_corner_9 = drGetPGDedge_270cor(V1PITCHID, 0.291, 0.028); 
 palm_dig_270_1 = drCreatePoly_out(pgd_v1_270_corner_9, 0.161, 0.119);
 palm_dig_270_2 = drCreatePoly_out(pgd_v1_270_corner_9, 0.021, 0);
 palm_dig_270_3 = drCreatePoly_in(pgd_v1_270_corner_9, 0.025, 0);
  
 pgd_dig_90_corner_1 = drGetPGDedge_90cor(V1PITCHID, 0.171, 0.093);
 finger_dig_270_2 = drCreatePoly_out(pgd_dig_90_corner_1, 0.049, 0.021);
 
 
 
 
 
 
 
 
 da_44_edge = drGetPGDedge_270cor(V1PITCHID, 0, DA_11); 
 os_da_44_edge = extend_edge(da_44_edge, start = DA_44, end = DA_44);
 da44_poly = drCreatePoly_in(os_da_44_edge, 0.255+APL_02, 0.255+APL_02 - APL_01);
 
 da32_ext_at_270_1 = drCreatePoly_in(os_da_44_edge, 0.255, 0.255 - APL_01) not TRDTOV1;
 da32_ext_at_270_2 = drCreatePoly_in(os_da_44_edge, 0.255-APL_02, 0.255-APL_02 - APL_01) not TRDTOV1;
 
 
 top_bot_tr = angle_edge(TRDTOV1 not ogd_v1tr, gate_angle);
 dig3 = drCreatePoly_out(top_bot_tr, PL_02, PL_02-PL_01);
 dig3 = drGrow(dig3, N = DA_46, S = DA_46) not_interacting da44_poly;

 
 
 // all_fixed_poly_around270 = finger_dig_270_1 or finger_dig_270_2 or palm_out1_270 or palm_out2_270 or
//                             finger_in_270_1  or finger_in_270_2 or da44_poly or da32_ext_at_270_1 or da32_ext_at_270_2;
 
 all_fixed_poly_around270 = da44_poly or da32_ext_at_270_1 or da32_ext_at_270_2 or
                            finger_v1_270_1 or finger_v1_270_2 or palm_v1_270_1 or finger_v1_270_3 or finger_v1_270_4 or palm_v1_270_2 or finger_irr_270_1 or
			    finger_dig_270_1 or finger_dig_270_2 or finger_dig_270_3 or palm_dig_270_1 or palm_dig_270_2 or palm_dig_270_3;
                            

 all_fixed_poly = (dig_da32 or th_da32  or cont_poly or all_fixed_poly_around270 or v1_palm or dig_palm or dig_finger)  not  cut_sliver;



da_enc_of_id_by_tr = 2*DA_361+DA_371+(DA_372-DA_38);

//DA_01
dr_Dx01_check_(xc(DA_01), V1PITCHID, TRDTOV1, cor_v1tr, ogd_v1tr, pgd_v1tr, DA_12, PL_01, APL_01, DA_38, DA_12+0.007, DA_173, DA_73, DA_362+DA_373+DA_38-0.011);

//DA_02
drDx02_(xc(DA_02), TRDTOV1, dr_all_polyid, dr_all_trid, dr_trid_list, DA_11, DA_12, DA_12, V1PITCHID, 2*da_enc_of_id_by_tr + DA_03);

//DA_03
drDx03_(xc(DA_03), TRDTOV1, dr_trid_list_4da03, DA_03);
err @= {
    @ GetRuleString(xc(DA_03),"um"); note(CheckingString(xc(DA_03)));
    external2(TRDTOV1, TRDTOV3, distance < DA_03, direction = non_gate_dir,  extension = NONE_INCLUSIVE );
    
 }
drErrorStack.push_back({ err, drErrGDSHash[xc(DA_03)], "" });    

//DA_04
drMinSpaceDir_(xc(DA_04), V1PITCHID, <DA_04, gate_dir); 

//DA_05
drDx05_(xc(DA_05), V1PITCHID, TRDTOV1, DA_05);

//DA_11/12 also DA_02
dr_Dx11_12_check_(xc(DA_11), TRDTOV1, DA_11, DA_12);

//DA_24
drMinWidthDir_( xc(DA_24), V1PITCHID, DA_24, non_gate_dir);

//DA_30
drMinSpaceSamePoly_( xc(DA_30), V1PITCHID, DA_30);


//DA_7x TCN in tr rules
dr_tr_tcn_rules_(xc(DA_70), xc(DA_71), xc(DA_72), xc(DA_73), xc(DA_173), xc(DA_174), xc(DA_175), xc(DA_176),
                  DA_70, DA_71, DA_72, DA_73, DA_173, DA_174, DA_175, DA_176,
		  V1PITCHID, TRDTOV1, pgd_v1tr, ogd_v1tr, cor_v1tr,
		  DA_11, DA_73, PL_02/2, 0.119, PL_02, APL_02, ==3);


//DA_31/32/41 covers DA_33
drawn_da44_poly = POLY and edge_size(os_da_44_edge, inside = 0.255+APL_02);
dr_Dx31_32_41_check_(xc(DA_31), TRDTOV1, all_fixed_poly, DA_32, drawn_da44_poly,TRDTOV3 );

Error_DA_46 @= {
  @ GetRuleString(xc(DA_46),"um"); note(CheckingString(xc(DA_46)));
   dig3 not TRDTOV1 not POLY;
}   
drErrorStack.push_back({ Error_DA_46, drErrGDSHash[xc(DA_46)], "" });

//DA_45
 Error_DA_45 @= {
  @ GetRuleString(xc(DA_45),"um"); note(CheckingString(xc(DA_45)));
    gate interacting  da44_poly;
}
drErrorStack.push_back({ Error_DA_45, drErrGDSHash[xc(DA_45)], "" }); 
  	

drDx52_(xc(DA_52), V1PITCHID, TRDTOV1, APL_01, cor_v1tr);


dr_yoffset = 0.0;
dr_xoffset = DA_38 + 2*DA_362 + DA_373;
drDx53_(xc(DA_53), V1PITCHID, TRDTOV1, ALLNWELL, dr_yoffset, DA_53, DA_362); //this needs to change
drDx54_(xc(DA_54), V1PITCHID, TRDTOV1, ALLNWELL, dr_xoffset, DA_54); 
drDx55_(xc(DA_55), V1PITCHID, ALLNWELL, DA_55);
drDx56_(xc(DA_56), V1PITCHID, ALLNWELL);
//drDx57_(xc(DA_57), V1PITCHID, ALLNWELL, DA_57);

drErrGDSHash["DA_er2"] = {102,2012} ;
drValHash["DA_er2"] = 0;


drErrGDSHash["DA_er"] = {102,2001} ;
drValHash["DA_er"] = 0;

Error_DA_er @= {
 @ "DA_er: ID layer and transionid are worngly placed wrt each other"; 
 //TRDTOV1 is placed wrong // this really does not work as there can be a digital whole inside the TGULV which will cause this to flag as the whole of the tr will be digital not tgulv
 //tr_hole = donut_holes(TRDTOV1);
 //xor(V1PITCHID,   drGrow(tr_hole, E = DA_38+2*DA_362+DA_373,  W = DA_38+2*DA_362+DA_373));
 
 //this is also like DA_11/12 check 
 os_v1pitchid = drGrow(V1PITCHID, N = DA_11, S = DA_11, W = (DA_372 - DA_38) + 2*DA_361+DA_371, E = (DA_372 - DA_38) + 2*DA_361+DA_371);
 tr_hole = drShrink(V1PITCHID, W = DA_38+2*DA_362+DA_373,  E = DA_38+2*DA_362+DA_373);
 TRDTOV1 xor (os_v1pitchid not tr_hole);
     
}

//DA_er2 
Error_DA_er2 @= {
 @ "DA_er2: Wrongly palce tgoxid wrt to polyid";
  TGOXID not_interacting (V1PITCHID or V3PITCHID);
 
 tgox_w_v1 = TGOXID interacting  V1PITCHID;
 tgox_w_v1 xor drShrink(drGrow(V1PITCHID, N = 0.078 + 0.093+ 0.12/2, S = 0.078 + 0.093+ 0.12/2), E = 0.002, W = 0.002);  
}


// Push errors to the error stack 
drErrorStack.push_back({ Error_DA_er, drErrGDSHash[xc(DA_er)], "" });
drErrorStack.push_back({ Error_DA_er2, drErrGDSHash[xc(DA_er2)], "" });
drErrorStack.push_back({ Error_DA_52, drErrGDSHash[xc(DA_52)], "" });


drDT22_(xc(DA_22), V1PITCHID, DA_22);
drMinLengthEdge_(xc(DA_25),V1PITCHID,DA_25);
drDT26_(xc(DA_26),V1PITCHID,DA_26);
drMinHole_(xc(DA_27), V1PITCHID, DA_27);

#ifdef _drDEBUG
  drPassthruStack.push_back({ V1PITCHID, {2,151} });
  drPassthruStack.push_back({ TRDTOV1, {81,165} });
  drPassthruStack.push_back({ TRDTOV3, {81,167} });
  drPassthruStack.push_back({ POLY, {2,0} });
  drPassthruStack.push_back({ TGOXID, {23,0} });
  drPassthruStack.push_back({ NDIFF, {1,0} });
  drPassthruStack.push_back({ PDIFF, {8,0} });
  drPassthruStack.push_back({ DIFFCON, {5,0} });
  drPassthruStack.push_back({ POLYCHECK, {84,0} });
  
  drPassthruStack.push_back({th_da32 , {99,1} });
  drPassthruStack.push_back({dig_da32 , {99,2} });
  drPassthruStack.push_back({dig3 , {99,3} });
  drPassthruStack.push_back({cont_poly , {99,4} });
  
  drPassthruStack.push_back({all_fixed_poly , {99,5} });
  
  drPassthruStack.push_back({finger_dig_270_1 , {99,8} });
 drPassthruStack.push_back({ finger_v1_270_1, {99,9} });
 drPassthruStack.push_back({ finger_v1_270_2, {99,10} });
 //drPassthruStack.push_back({ palm_out1_270, {99,11} });
 //drPassthruStack.push_back({ palm_out2_270, {99,12} });
 drPassthruStack.push_back({ pgd_v1_270_corner_3, {99,13} });
 //drPassthruStack.push_back({ finger_in_270_1, {99,14} });
 //drPassthruStack.push_back({ finger_in_270_2, {99,15} });
 drPassthruStack.push_back({ da44_poly, {99,16} });
 drPassthruStack.push_back({ os_da_44_edge, {99,17} });
 drPassthruStack.push_back({da32_ext_at_270_1 , {99,18} });
 drPassthruStack.push_back({da32_ext_at_270_2 , {99,19} });
 drPassthruStack.push_back({ all_fixed_poly_around270, {99,20} });
// drPassthruStack.push_back({ all_edge, {99,21} });
 drPassthruStack.push_back({ v1_palm, {99,22} });
 drPassthruStack.push_back({dig2_poly_1 , {99,23} });
 drPassthruStack.push_back({dig2_poly_1_tr , {99,24} });
 drPassthruStack.push_back({dig_palm , {99,25} });
 drPassthruStack.push_back({dig_finger , {99,26} });
 
#endif






#endif
