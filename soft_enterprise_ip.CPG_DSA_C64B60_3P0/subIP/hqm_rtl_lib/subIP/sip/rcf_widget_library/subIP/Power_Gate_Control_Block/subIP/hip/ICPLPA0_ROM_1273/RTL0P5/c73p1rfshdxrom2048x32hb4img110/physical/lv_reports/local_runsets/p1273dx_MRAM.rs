// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_MRAM.rs.rca 1.9 Sat Nov 15 15:48:19 2014 qfan4 Experimental qfan4 $
//
// $Log: p1273dx_MRAM.rs.rca $
// 
//  Revision: 1.9 Sat Nov 15 15:48:19 2014 qfan4
//  fix MTJ_05/07 because of new rule MTJ_09 rule change
//  fix MJ0_05/06 because of new rule and rule change MJ0_01/11
// 
//  Revision: 1.8 Fri Nov 14 15:48:03 2014 qfan4
//  update MJ0_06 to 0.17 based on Eric.
// 
//  Revision: 1.7 Fri Nov 14 14:28:01 2014 qfan4
//  update on multiple rules based on new design rule and rule values
//  excel sheet from Eric
// 
//  Revision: 1.6 Fri Nov  7 17:47:38 2014 qfan4
//  add new checks including new value for MTJ_09
// 
//  Revision: 1.5 Wed Jan  9 16:56:17 2013 sstalukd
//  Added new check MTJ_16
//  Modified SDC_11/111 check so that it allows both combinations for top/bottom: SDC_11/SDC_111 and SDC_111/SDC_11
// 
//  Revision: 1.4 Fri Nov  2 14:32:02 2012 sstalukd
//  Added new check for SM0_60, SM0_82/821
// 
//  Revision: 1.3 Fri Oct 19 12:12:24 2012 sstalukd
//  Added new rules MTJ_11/12/13/15, SDC_11/111/03
// 
//  Revision: 1.2 Fri Oct 12 14:42:22 2012 sstalukd
//  Rev2 release - major change in transition pattern of MJ0/M2/MTJID (previously we were synthesizing the transition zone)
//  All lables from MJ0_01-MJ0_07 are new/modified
//  Introduced new ID's for bitcell - smallbit (STTRAMID1), largebitcell(STTRAMID2)
//  Added new check MTJ_10
// 
//  Revision: 1.1 Sat Sep  8 10:48:41 2012 sstalukd
//  Initial checkin for ST-MRAM rules
//

#ifndef _P1273_MRAM_RS_
#define _P1273_MRAM_RS_

//New Module for STT-MRAM 
////////////////////////////////////////////
// hard coded rule value change 
// need to be removed after new DR
// 
   MJ0_06 = 0.170;
   MTJ_09 = 0.058;
//
////////////////////////////////////////////
///////////////////////////////////////////////
//
// new checks - some old check are commented out
// as MJ0_01/MJ0_07/MTJ_09
// 
///////////////////////////////////////////////

MJ0_11 = 0.22;
drValHash["MJ0_11"] = MJ0_11;
drHash["MJ0_11"] = "MJ0_11: MJ0 enclosed by MTJID in OGD(max)";
Error_MJ0_11 = empty_violation();
drErrHash[xc(MJ0_11)] = Error_MJ0_11;
drErrGDSHash[xc(MJ0_11)] = { 187 , 1011 };

MJ0_12 = 0.075;
drValHash["MJ0_12"] = MJ0_12;
drHash["MJ0_12"] = "MJ0_12: Minimum MJ0 to active M1 outside of MJ0 space(PGD)";
Error_MJ0_12 = empty_violation();
drErrHash[xc(MJ0_12)] = Error_MJ0_12;
drErrGDSHash[xc(MJ0_12)] = { 187 , 1012 };

MJ0_13 = 0.07;
drValHash["MJ0_13"] = MJ0_13;
drHash["MJ0_13"] = "MJ0_13: Minimum MJ0 to active M1 outside of MJ0 space(OGD)";
Error_MJ0_13 = empty_violation();
drErrHash[xc(MJ0_13)] = Error_MJ0_13;
drErrGDSHash[xc(MJ0_13)] = { 187 , 1013 };

MJ0_14 = 0.15;
drValHash["MJ0_14"] = MJ0_14;
drHash["MJ0_14"] = "MJ0_14: Max space from dummy M2 to MJ0(OGD)";
Error_MJ0_14 = empty_violation();
drErrHash[xc(MJ0_14)] = Error_MJ0_14;
drErrGDSHash[xc(MJ0_14)] = { 187 , 1014 };

MTJ_091 = 0.07;
drValHash["MTJ_091"] = MTJ_091;
drHash["MTJ_091"] = "MTJ_091: MTJ enclosure by MJ0 in OGD(min)";
Error_MTJ_091 = empty_violation();
drErrHash[xc(MTJ_091)] = Error_MTJ_091;
drErrGDSHash[xc(MTJ_091)] = { 187 , 1091 };

MJ0_12_13_grow = drGrow(MJ0, E=MJ0_13, W=MJ0_13, N=MJ0_12, S=MJ0_12);
metal_v0 = interacting(metal1, VIA0);
metal_v1 = interacting(metal1, VIA1);
metal1_active = metal_v0 or metal_v1;


//In PGD identify the first two metal2 lines inside MTJID which have to be uncut
//Identify 1st line - Metal2 that is outside touching w/ MTJID
met2ogde         = angle_edge (METAL2BC, angles=non_gate_angle); 
met2_firstline_e = met2ogde coincident_inside_edge MTJID;
met2_firstline   = METAL2BC interacting [count =1] met2_firstline_e;

//Now grow firstline by 24nm (fixed spacer) to get gap
met2_spacer = drGrow(met2_firstline, N=M2_21,S=M2_21) not met2_firstline;
met2_spacer_mtj = met2_spacer and MTJID;

//Second line - met2bc outside touching spacer and SPACER interacting w/ 1 metal2BC
//Remove first line from METAL2BC def before going for secondline def
met2bc_nofirstline  = METAL2BC not met2_firstline;
met2_spacer_single  = met2_spacer_mtj interacting [count=1] met2bc_nofirstline;
met2_secondline	    = met2bc_nofirstline outside_touching met2_spacer_single;

//Check min space for all METAL2BC outside mtj_syn_ogd to mtj_syn_ogd
//Remaining metal2 (that is not 1st/2nd uncut lines)
met2_mtjid_rem   = (METAL2BC interacting [include_touch=ALL] MTJID) not (met2_firstline or met2_secondline); 

//Only two lines are allowed on top/bottom of MJ0 - use min/max space to identify this zone
//and make sure there is no other Metal2 line
dummym2_goodspace_pgd = drSpace2(met2_secondline,MJ0,[MJ0_05,MJ0_06],gate_dir);

//MJ0 extended in OGD
mj0_syn_ogd = drGrow(MJ0, E=MJ0_01, W=MJ0_01);

// //*********MJ0_01: MJ0 space to MTJID in OGD (fixed)
// err @= {
//    @ GetRuleString(xc(MJ0_01),"um"); // note(CheckingString(xc(MJ0_01))); 
// 
//    //Make sure pgd edge of extended MJ0 is coincident w/ MTJID
//    mtj_syn_pgde = angle_edge(mj0_syn_ogd,angles=gate_angle);
//    mtj_syn_pgde not_coincident_edge MTJID;   
// }
// drErrorStack.push_back({err , drErrGDSHash[xc(MJ0_01)], "" });

//*********MJ0_02: First two Metal2 lines inside MTJID are uncut
err @= {
   @ GetRuleString(xc(MJ0_02),"um"); // note(CheckingString(xc(MJ0_02))); 
   
   //Inside MTJID there are 2 met2_firstline/met2_secondline
   //pgd-edge of those uncut metal2 lines are coincident w/ MTJID

   MTJID not_interacting [count=2] met2_firstline;
   MTJID not_interacting [count=2] met2_secondline ;

   met2_firstline_pedge  = angle_edge(met2_firstline,  angles=gate_angle);
   met2_secondline_pedge = angle_edge(met2_secondline, angles=gate_angle);

   met2_firstline_pedge  not_coincident_edge MTJID;
   met2_secondline_pedge not_coincident_edge MTJID;
}
drErrorStack.push_back({err , drErrGDSHash[xc(MJ0_02)], "" });


//*********MJ0_03: No GCN, V1, M2 allowed inside MJ0
err @= {
   //These layers are not allowed inside MJ0

  @ "MJ0_03: No GCN allowed inside MJ0";
   POLYCON and MJ0;

  @ "MJ0_03: No VIA1 allowed inside MJ0";
   VIA1 and MJ0;

  @ "MJ0_03: No METAL2 allowed inside MJ0";
   METAL2BC and MJ0;
}
drErrorStack.push_back({err , drErrGDSHash[xc(MJ0_03)], "" });


//*********MJ0_04: MTJID must be rectangular in shape 
err @= {
   @ GetRuleString(xc(MJ0_04),"um"); // note(CheckingString(xc(MJ0_04))); 

   //Easier to find jog using this instead of rectangles
   //using 5 as arbitrary value to make it easirt to see the errors
   vertex(MTJID, angles={270},  shape_size = 5*drunit); 
}
drErrorStack.push_back({err , drErrGDSHash[xc(MJ0_04)], "" });

//*********Min space from dummy M2 to MJ0 (PGD)
drMinSpaceDir2_(xc(MJ0_05),met2_secondline,mj0_syn_ogd,<MJ0_05,gate_dir);

mj0_syn_ogd_max = drGrow(MJ0, E=MJ0_11, W=MJ0_11);

drErrGDSHash[xc(MJ0_05/06)] = {187,1006} ;
//*********MJ0_06: Max space from dummy M2 to MJ0 (PGD) 
//Combining MJ0_05/06 into one check
err @= {
    @ "MJ0_05/06: Dummy M2 distance to MJ0 in PGD is outside allowed range: ("+MJ0_05+","+MJ0_06+")";

   //This check will also ensure that there can be no third line in this allowed range
   METAL2BC and dummym2_goodspace_pgd;

   //Find ogde of met2_secondline and MJ0 and check for max space
   met2_secondline_ogde = angle_edge(met2_secondline,angles=non_gate_angle);

   //Need met2 that is not touching the spacer
   met2_ogde_nonspacer = met2_secondline_ogde not_coincident_edge met2_spacer_single;

   mj0_syn_ogde		= angle_edge(mj0_syn_ogd_max,angles=non_gate_angle);
 
   //Error if distance is not in the range [MJ0_05,MJ0_06]
   not_external2_edge(met2_ogde_nonspacer, mj0_syn_ogde, distance = [MJ0_05,MJ0_06], extension = NONE, direction = gate_dir);
}
drErrorStack.push_back({err , drErrGDSHash[xc(MJ0_05/06)], "" });


// //*********MJ0_07: Fixed space from dummy M2 to MJ0 (OGD)
// err @= {
//    @ GetRuleString(xc(MJ0_07),"um"); // note(CheckingString(xc(MJ0_07))); 
// 
//    //Also make sure that the met2 edges are alinged w/ both MTJID and MJ0_extended by 24nm
//    met2_dummy_pgde      = angle_edge(met2_mtjid_rem,angles=gate_angle);
//    mj0_extended_pgde    = angle_edge(drGrow(MJ0,E=MJ0_07,W=MJ0_07),angles=gate_angle);
//    mtjid_pgde		= angle_edge(MTJID,angles=gate_angle);
// 
//    //Error
//    temp_err = met2_dummy_pgde not_coincident_edge (mj0_extended_pgde or_edge mtjid_pgde);
// 
//    //Okay to waive if there is a sliver since the metal2 pgde can extend beyond the mj0_extended_pgde (they don't line up)
//    //As long as temp_err is interacting the mj_extended_pgde okay to waive
//    temp_err not_interacting_edge mj0_extended_pgde;
//    
//   drPassthruStack.push_back({ met2_dummy_pgde,   {187,4000} });
//   drPassthruStack.push_back({ mj0_extended_pgde, {187,4001} });
//   drPassthruStack.push_back({ temp_err, 	 {187,4002} });
// }
// drErrorStack.push_back({err , drErrGDSHash[xc(MJ0_07)], "" });


drMinSpace_(xc(MJ0_08),MJ0,MJ0_08);
drMinWidth_(xc(MJ0_09),MJ0,MJ0_09);


//**********************************MTJ Rules start here 

//*********MTJ_01: M2 keepGenAway layer (TC only) needs to be line-on-line with MTJID
//*********MTJ_02: M2 keepout layer (STT_MRAM circuit array) needs to be line-on-line with MTJID
#if (_drTSDR == _drYES)
  err @= { 
    @ GetRuleString(xc(MTJ_01),"um"); note(CheckingString(xc(MTJ_01)));
   //find m2 Keepgenaway interacting w/ MTJID and make sure it is xor clean
   (METAL2KGA interacting [include_touch = ALL] MTJID) xor (MTJID interacting [include_touch = ALL] METAL2KGA);
  }
  drPushErrorStack(err, xc(MTJ_01));
#else //for SDR use METAL3KOR
  err @= { 
    @ GetRuleString(xc(MTJ_02),"um"); note(CheckingString(xc(MTJ_02)));
    //Only if METAL2KOR interacts w/ MTJID then check for xor
   (METAL2KOR interacting [include_touch = ALL] MTJID) xor (MTJID interacting [include_touch = ALL] METAL2KOR);
  }
  drPushErrorStack(err, xc(MTJ_02));
#endif

//*********MTJ_03: MTJ fixed width (OGD)
err @= { 
  @ GetRuleString(xc(MTJ_03),"um"); note(CheckingString(xc(MTJ_03)));
  good_mtj = drWidth(MTJ, MTJ_03, non_gate_dir);
  MTJ not good_mtj;

  drPassthruStack.push_back({ good_mtj,   {187,4003} });
} 
drPushErrorStack(err, xc(MTJ_03));

//*********MTJ_04: MTJ fixed length (PGD)
err @= { 
  @ GetRuleString(xc(MTJ_04),"um"); note(CheckingString(xc(MTJ_04)));
  good_mtj = drWidth(MTJ, MTJ_04, gate_dir);
  MTJ not good_mtj;
} 
drPushErrorStack(err, xc(MTJ_04));


//*********MTJ_05: MTJ fixed pitch (OGD) in large bitcell (ID??)
//*********MTJ_07: MTJ fixed pitch (PGD)
//*********MTJ pitch (OGD) in small bitcell (ID??)
//large_bitcell - STTRAMID2
//small_bitcell - STTRAMID1

MTJ_in_STTRAMID2 = MTJ and STTRAMID2;

// over size in case there is a hole
MTJ_in_STTRAMID2_merge = drGrowShrink(MTJ_in_STTRAMID2, E=MTJ_05, W=MTJ_05, N=MTJ_07, S=MTJ_07);


//drFixedPitch_(xc(MTJ_05), MTJ and STTRAMID2, MJ0, MTJ_03, MTJ_05, MTJ_09, MTJ_03);
drFixedPitch_(xc(MTJ_05), MTJ_in_STTRAMID2, MTJ_in_STTRAMID2_merge, MTJ_03, MTJ_05, 0, MTJ_03);

//For small bitcell first merge the 70pitch MTJ
mtj_small_merged = drOverUnder(MTJ and STTRAMID1, (MTJ_06-MTJ_03)/2);


//First merge MTJ into a zone and check for distance between zone and MJ0
//Once you have the smallbitcell merged, it will have same OGD/PGD gap as large bitcell
mtj_combine = (MTJ and STTRAMID2) or mtj_small_merged;

mtj_merge_ew = drGrowShrink(mtj_combine, E=(MTJ_05-MTJ_03)/2, W=(MTJ_05-MTJ_03)/2);
mtj_zone     = drGrowShrink(mtj_merge_ew, N=(MTJ_07-MTJ_04)/2, S=(MTJ_07-MTJ_04)/2); 

drFixedPitch_(xc(MTJ_06),mtj_small_merged, MJ0,MTJ_06+MTJ_03, MTJ_05+MTJ_06, MTJ_09, MTJ_06+MTJ_03);

//Same for both small and large bitcells
MTJ_merged = drGrowShrink(MTJ, E=MTJ_05, W=MTJ_05, N=MTJ_07, S=MTJ_07);
 
//drFixedPitch_(xc(MTJ_07), MTJ, MJ0, MTJ_04, MTJ_07, MTJ_09, MTJ_04, gate_dir);
drFixedPitch_(xc(MTJ_07), MTJ, MTJ_merged, MTJ_04, MTJ_07, 0, MTJ_04, gate_dir);

//*********MTJ_08: Inside MJ0 either large bitcell or small bitcells are allowed - not BOTH
err @= { 
  @ GetRuleString(xc(MTJ_08),"um"); note(CheckingString(xc(MTJ_08)));
  mj0_largeid = MJ0 interacting [include_touch = ALL] STTRAMID2;
  mj0_smallid = MJ0 interacting [include_touch = ALL] STTRAMID1;
  //Error if the above two combinations interact
  mj0_largeid interacting [include_touch = ALL] mj0_smallid;

  //Also make sure that MTJ array (zone) is always covered by MJ0
  mtj_zone not MJ0;

} 
drPushErrorStack(err, xc(MTJ_08));

// rule changed on 11/07/2014 -FQ
// //*********MTJ_09: MTJ enclosure by MJ0 (only allowed value)
// err @= { 
//   @ GetRuleString(xc(MTJ_09),"um"); note(CheckingString(xc(MTJ_09)));
// 
//   //Sanity check to ensure mtj_zone is rectangular
//   not_rectangles(mtj_zone);
// 
//   not_enclose_edge(mtj_zone, MJ0, distance = MTJ_09, extension= NONE, orientation= PARALLEL,
//              relational = {INSIDE}, intersecting = {});
// } 
// drPushErrorStack(err, xc(MTJ_09));


//*********MTJ_10: STTRAMID1, STTRAMID2 are line-line with MTJID
err @= { 
  @ GetRuleString(xc(MTJ_10),"um"); note(CheckingString(xc(MTJ_10)));

  STTRAMID1 not_coincident_edge MTJID;
  STTRAMID2 not_coincident_edge MTJID;
} 
drPushErrorStack(err, xc(MTJ_10));

//For MTJ_11-14 rules
via2_mtj = VIA2 and MJ0;
m1_mtj = METAL1 and MJ0;
//*********MTJ_11:V2 needs to center on MTJ
err @={
  @ GetRuleString(xc(MTJ_11),""); note(CheckingString(xc(MTJ_11)));

  v2_center  = polygon_centers(via2_mtj, drgrid);
  mtj_center = polygon_centers(MTJ, drgrid);
  
  //Error if the v2_center is outside mtj_center
  v2_center not mtj_center;
}
drPushErrorStack(err, xc(MTJ_11));      

drErrGDSHash[xc(MTJ_12/13)] = {186,1012};
//*********MTJ_12/13:Fixed V2 length in OGD/Fixed V2 width in PGD
err @={
  @ "MTJ_12/13: Via2 (inside MJ0) fixed dimension: Length(OGD) = "+MTJ_12+" ,Width(PGD) = "+MTJ_13;
  via2mtj_temp = drBinPGDOGDVias(via2_mtj,MTJ_13,MTJ_12); //(short_side, long_side)
  v2mtj_type_v = via2mtj_temp.layer1;  //ERROR bin
  v2mtj_type_h = via2mtj_temp.layer2;  //good via
  
  via2_mtj not v2mtj_type_h; //Wrong size and orientation
}
drPushErrorStack(err, xc(MTJ_12/13));      

// 
// //*********MTJ_15:Fixed M1 enclosure of MTJ (OGD or PGD)
// err @={
//   @ GetRuleString(xc(MTJ_15),""); note(CheckingString(xc(MTJ_15)));
//   not_enclose_edge(MTJ, METAL1, distance = MTJ_15, 
//       extension = NONE_INCLUSIVE, orientation = {PARALLEL}, intersecting = {TOUCH}, 
//       relational ={INSIDE});
// 
// }
// drPushErrorStack(err, xc(MTJ_15)); 

//*********MTJ_16:MTJ outside STTRAMID1/2 is err
//hard-coding since dr file is not there
drValHash[xc(MTJ_16)] = 0;
drHash[xc(MTJ_16)] = "MTJ not allowed STTRAMID1/2";
drErrGDSHash[xc(MTJ_16)] = { 186, 1016 };
err @={
  @ GetRuleString(xc(MTJ_16),""); note(CheckingString(xc(MTJ_16)));
  MTJ not (STTRAMID1 or STTRAMID2);  
}
drPushErrorStack(err, xc(MTJ_16)); 


//****Next up are SDR rules that were hard-coded, thus given blanket waiver under MTJID

diffcon_mj0 = DIFFCON interacting [include_touch = ALL] MJ0;

drErrGDSHash[xc(SDC_11/111)] = {605,1011} ;
//*********SDC_11/111:Fixed TCN extension beyond drawn N-diffusion top/bottom
err @={
  @ "SDC_11/111: Fixed TCN extension beyond drawn N-diffusion: top="+SDC_11+" ,bottom = "+SDC_111;
  
  //Find ndiff inside MJ0 interacting w/ Diffcon and then extend edge in N/S
  ndiff_mj0   = NDIFF   interacting [include_touch = ALL] MJ0;

  //Based on new request from Lin, check both combinations for SDC_11/SDC_111 and vise versa
  ndiff_mj0_os1 = drGrow(ndiff_mj0, N=SDC_111, S=SDC_11);
  ndiff_mj0_os2 = drGrow(ndiff_mj0, N=SDC_11, S=SDC_111);

  //Only diffcon w/ Diffusion is considered for this check
  diffcon_diff     = diffcon_mj0 interacting [include_touch=ALL] NDIFF;
  diffcon_mj0_ogde = angle_edge(diffcon_diff,angles=non_gate_angle);

  //First find temp err for both cases
  temp_err1 = diffcon_mj0_ogde not_coincident_edge ndiff_mj0_os1;
  temp_err2 = diffcon_mj0_ogde not_coincident_edge ndiff_mj0_os2;
  
  //Find the corresponding diffcon polygons associated w/ the edges
  temp_err1_os = edge_size(temp_err1,drunit);
  temp_err2_os = edge_size(temp_err2,drunit);
  temp_err1_polygon = diffcon_diff interacting [include_touch=ALL] temp_err1_os;
  temp_err2_polygon = diffcon_diff interacting [include_touch=ALL] temp_err2_os;

  //Real error if both temp_err1_polygon and temp_err2_polygon are same
  //Only if same polygon gives error for both combination, call it real err
  temp_err1_polygon and temp_err2_polygon;

  drPassthruStack.push_back({ ndiff_mj0_os1,     {187,4004} });
  drPassthruStack.push_back({ ndiff_mj0_os2,     {187,4005} });
  drPassthruStack.push_back({ temp_err1_polygon,     {187,4007} });
  drPassthruStack.push_back({ temp_err2_polygon,     {187,4008} });
}
drPushErrorStack(err, xc(SDC_11/111)); 

//*********SDC_03:Diffcon end-to-end (ETE) space (min)
drMinSpaceDir_(xc(SDC_03),diffcon_mj0,<SDC_03,gate_dir);

#include <p12723_M0hdr.rs>
//*********SM0_60:Fixed length of M0 line (any type, any width) 
err @={
  @ GetRuleString(xc(SM0_60),""); note(CheckingString(xc(SM0_60)));

  //If metal0 crosses over STRAMID, then don't check for length
  metal0_stram = METAL0 inside STTRAMID1;

  //First get the good length
  M0_goodlength = drWidth(metal0_stram, SM0_60, non_gate_dir); 

  //Err if it doesn't meet fixed length
  metal0_stram not M0_goodlength;
}
drPushErrorStack(err, xc(SM0_60));  

drErrGDSHash[xc(SM0_82/821)] = {819,1082} ;
//*********SM0_82/821:Metal0 line-end overlap of poly,(one edge touching Poly, other edge 7nm away from Poly)
err @={

  //Find Metal0 pgde inside STTRAMID1 (small bitcell)
  metal0_pgde_stram = angle_edge(METAL0, angles=gate_angle) and_edge STTRAMID1;
  
  //If above metal0 edge is interacting w/ poly then it must be line-line else 7nm away from next poly
  metal0_pgde_poly = metal0_pgde_stram interacting_edge POLY;
  metal0_pgde_nopoly = metal0_pgde_stram not_interacting_edge POLY;

  //Error is metal0_pgde_poly is not conincident w/ poly
  @ "SM0_82/821: Fixed Metal0 line-end overlap of poly: edge touching Poly= "+SM0_82;
  metal0_pgde_poly not_coincident_edge POLY;

  @ "SM0_82/821: Fixed Metal0 line-end overlap of poly: edge fixed distance from Poly= "+SM0_821;
  not_external2_edge(metal0_pgde_nopoly, POLY, distance = SM0_821, extension = NONE, direction = non_gate_dir);

  drPassthruStack.push_back({ metal0_pgde_poly,   {187,4009} });
  drPassthruStack.push_back({ metal0_pgde_nopoly, {187,4010} });
}
drPushErrorStack(err, xc(SM0_82/821));  

// MJ0_01: MJ0 enclosed by MTJID in OGD (min)
err @= {
   @ GetRuleString(xc(MJ0_01),"um");  
   enclose(MJ0, MTJID, distance < MJ0_01, extension= NONE, orientation= PARALLEL, 
             direction=non_gate_dir, relational = {INSIDE}, intersecting = {});
}
drErrorStack.push_back({err , drErrGDSHash[xc(MJ0_01)], "" });

// MJ0_11: MJ0 enclosed by MTJID in OGD (max)
MTJID_mj0_good_region = enclose(MJ0, MTJID, distance = [MJ0_01, MJ0_11], extension= NONE, orientation= PARALLEL, 
             direction=non_gate_dir, relational = {INSIDE}, intersecting = {});
			 
drPassthruStack.push_back({MTJID_mj0_good_region,   {187,2014} });

MJ0_side = angle_edge (MJ0, angles=gate_angle); 

err @= {
   @ GetRuleString(xc(MJ0_11),"um");  
	MJ0_side not_coincident_outside_edge MTJID_mj0_good_region;
}
drPushErrorStack(err, xc(MJ0_11));

// MJ0_07: Min space from dummy M2 to MJ0 (OGD)
drMinSpaceDir2_(xc(MJ0_07),met2_mtjid_rem, MJ0, <MJ0_07,non_gate_dir);

// MTJ_14 
mj0_ogd_grow_14 = drGrow(MJ0, E=MJ0_14, W=MJ0_14, N=MJ0_06, S=MJ0_06);
drPassthruStack.push_back({mj0_ogd_grow_14,   {187,2013} });
err @= {
   @ GetRuleString(xc(MJ0_14),"um");  
	met2_mtjid_rem not_interacting mj0_ogd_grow_14;
}
drPushErrorStack(err, xc(MJ0_14));


// MJ0_12
MJ0_12_13_M1 = metal1_active and MJ0_12_13_grow;
MJ0_12_13_error = not_interacting(MJ0_12_13_M1, MTJ);

err @={
  @ GetRuleString(xc(MJ0_12),""); note(CheckingString(xc(MJ0_12)));
	copy(MJ0_12_13_error);
}
drPushErrorStack(err, xc(MJ0_12));  

// MJ0_13
err @={
  @ GetRuleString(xc(MJ0_13),""); note(CheckingString(xc(MJ0_13)));
	copy(MJ0_12_13_error);
}
drPushErrorStack(err, xc(MJ0_13));  

// MTJ_15:Min M1 enclosure of MTJ (OGD or PGD)
err @={
  @ GetRuleString(xc(MTJ_15),""); note(CheckingString(xc(MTJ_15)));
 enclose(MTJ, METAL1, distance < MTJ_15, 
      extension = NONE_INCLUSIVE, orientation = {PARALLEL}, intersecting = {TOUCH}, 
      relational ={INSIDE});
}
drPushErrorStack(err, xc(MTJ_15));


// MTJ_09

err @= { 
  @ GetRuleString(xc(MTJ_09),"um"); note(CheckingString(xc(MTJ_09)));

  //Sanity check to ensure mtj_zone is rectangular
  not_rectangles(mtj_zone);

  enclose(mtj_zone, MJ0, distance < MTJ_09, extension= NONE, orientation= PARALLEL, 
             direction=gate_dir, relational = {INSIDE}, intersecting = {});
} 
drPushErrorStack(err, xc(MTJ_09));

// MTJ_091
err @= { 
  @ GetRuleString(xc(MTJ_091),"um"); note(CheckingString(xc(MTJ_091)));

  enclose(mtj_zone, MJ0, distance < MTJ_091, extension= NONE, orientation= PARALLEL, 
             direction=non_gate_dir, relational = {INSIDE}, intersecting = {});
} 
drPushErrorStack(err, xc(MTJ_091));



//Debug layers
drPassthruStack.push_back({ NDIFF,   {1,0} });
drPassthruStack.push_back({ DIFFCON, {5,0} });
drPassthruStack.push_back({ POLY,    {2,0} });

drPassthruStack.push_back({ MTJ, {186,0} });
drPassthruStack.push_back({ MJ0, {187,0} });
drPassthruStack.push_back({ MTJID, {186,120} });
drPassthruStack.push_back({ STTRAMID1, {82,52} });
drPassthruStack.push_back({ STTRAMID2, {82,53} });

drPassthruStack.push_back({ METAL1, {4,0} });
drPassthruStack.push_back({ METAL2, {14,0} });
drPassthruStack.push_back({ METAL2KOR, {14,1} });
drPassthruStack.push_back({ METALC2DRAWN, {112,0} });



drPassthruStack.push_back({ met2_firstline_e,   {187,2000} });
drPassthruStack.push_back({ met2_firstline,     {187,2001} });
drPassthruStack.push_back({ met2_spacer_mtj,    {187,2002} });
drPassthruStack.push_back({ met2_spacer_single, {187,2003} });
drPassthruStack.push_back({ met2_secondline,  	{187,2004} });
drPassthruStack.push_back({ mj0_syn_ogd,      	{187,2005} });
drPassthruStack.push_back({ met2_mtjid_rem,    	{187,2006} });
drPassthruStack.push_back({ mtj_small_merged, 	{187,2007} });
drPassthruStack.push_back({ mtj_combine,      	{187,2008} });
drPassthruStack.push_back({ mtj_zone,         	{187,2009} });
drPassthruStack.push_back({ dummym2_goodspace_pgd,{187,2010} });
drPassthruStack.push_back({ via2_mtj,         	{187,2011} });
drPassthruStack.push_back({ m1_mtj,         	{187,2012} });

#endif //#ifndef _P1273_MRAM_RS_

