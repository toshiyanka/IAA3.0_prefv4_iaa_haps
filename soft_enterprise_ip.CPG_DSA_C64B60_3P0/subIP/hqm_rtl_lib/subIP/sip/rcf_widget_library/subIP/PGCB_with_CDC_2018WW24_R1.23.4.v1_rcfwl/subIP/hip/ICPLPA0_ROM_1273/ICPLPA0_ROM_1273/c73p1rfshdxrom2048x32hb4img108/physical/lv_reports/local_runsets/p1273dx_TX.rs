// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TX.rs.rca 1.5 Mon Oct  1 14:01:06 2012 dgthakur Experimental $
//
// $Log: p1273dx_TX.rs.rca $
// 
//  Revision: 1.5 Mon Oct  1 14:01:06 2012 dgthakur
//  hsd 1280; Fixes TX_03 and TX_05 false flags (updated to reflect v0.4 redbook rules).
// 
//  Revision: 1.4 Fri Aug 24 08:22:56 2012 dgthakur
//  Waiver for TX_03 when TG regions abut.  Added global min space for TGOXID at 284 nm.
// 
//  Revision: 1.3 Wed Mar 28 16:40:21 2012 sstalukd
//  For TSDR made value changes for TX_09/TX_12
//  For TX_21 undersize V1PITCHID by 2nm to match layout - based on Moonsoo's email (3/27)
// 
//  Revision: 1.2 Tue Feb 28 11:16:12 2012 sstalukd
//  Moved drPL24_/drPL24waive_ functions from p1273_XGTGfunctions.rs to p12723_functions.rs and including p12723_PLhdr.rs in the modules directly
// 
//  Revision: 1.1 Tue Feb 28 09:11:01 2012 sstalukd
//  Initial checkin for 1273 module
// 


// 1273 TGOXID rules (TG-ox rules)
#ifndef _P1273DX_TG_RS_
#define _P1273DX_TG_RS_

//Override dr values for TSDR ONLY (email from Moonsoo: 3/27/2011)
#if (_drTSDR == _drYES)
    TX_09 = 0.231;
    TX_12 = 0.163;
#endif

Error_TX_01 @= {
  @ GetRuleString(xc(TX_01)); note(CheckingString(xc(TX_01)));
  tgox_good = TGOXID interacting (V1PITCHID or V3PITCHID); 
  TGOXID not tgox_good;
}    
drErrorStack.push_back({ Error_TX_01, drErrGDSHash[xc(TX_01)], "" }); 

drMinSpace2_(xc(TX_13), TGOXID, XGOXID, TX_13);

Error_TX_21 @= {
  @ GetRuleString(xc(TX_21)); note(CheckingString(xc(TX_21)));

  //Based on email from Moonsoo (3/27/2012), shrink V1PITCHID by 2nm 
  v1pitchid_us = drShrink(V1PITCHID, E=0.002, W=0.002);
  (v1pitchid_us or V3PITCHID) not TGOXID;
}
drErrorStack.push_back({ Error_TX_21, drErrGDSHash[xc(TX_21)], "" }); 


drMinWidth_("TX_02", TGOXID, TX_02);


//Waivers for TX_03 when TG regions abut
tgoxid_tg = TGOXID interacting V3PITCHID;
tgoxid_tgulv = TGOXID interacting V1PITCHID;
tgoxid_tgall = tgoxid_tg or tgoxid_tgulv;

//tgoxid_wv1 = drSpace(tgoxid_tg, 0.430, non_gate_dir); 
tgoxid_wv2 = drSpace(tgoxid_tgulv, [0.284,TX_03), non_gate_dir); 
//tgoxid_wv3 = drSpace2(tgoxid_tg, tgoxid_tgulv, 0.357, non_gate_dir); 
tgoxid_wv4 = drSpace(tgoxid_tgall, [0.462,TX_03), gate_dir); 
//tgoxid_wv = tgoxid_wv1 or tgoxid_wv2 or tgoxid_wv3 or tgoxid_wv4;
tgoxid_wv = tgoxid_wv2 or tgoxid_wv4; //Only waive 2 and 4 are needed now
drPassthru( tgoxid_wv,   1950, 4)


//Global min TGOXID space value - Hafez email 21Aug12
drMinSpace_("TX_03", TGOXID, 0.284);
drMinSpace_("TX_03", TGOXID, TX_03, tgoxid_wv);



//Similar to XG_05 rule being invoked in PL module
//THis check applies to V1PITCHID/V3PITCHID
//Waive TGOXID edges that are in transition regions - checked in DA, DT module respectively
#include <p12723_PLhdr.rs>
waive_e_v1 = interacting_edge(angle_edge(TGOXID, angles = gate_angle), TRDTOV1); 
waive_e_v3 = interacting_edge(angle_edge(TGOXID, angles = gate_angle), TRDTOV3); 
waive_tx_05 = waive_e_v1 or_edge waive_e_v3;

drPL24waive_(xc(TX_05), poly, polyA180, TGOXID, PL_06, APL_02,  APL_01, waive_tx_05); 
drPL24waive_(xc(TX_05), poly, polyTG,   TGOXID, PL_06, TPL_02,  TPL_01, waive_tx_05); 

//Get poly outside TGOXID region 
poly_inside_tg = POLY and TGOXID;
poly_outside_tg = POLY not poly_inside_tg;
drEncloseDir_(xc(TX_06),   poly_inside_tg,  TGOXID, TX_06, gate_dir);
drExternal2Dir_(xc(TX_07), poly_outside_tg, TGOXID, TX_07, gate_dir);


//Get nwell outside TGOXID region 
nwell_inside_tg = nwell and TGOXID;
nwell_outside_tg = nwell not nwell_inside_tg;

Error_TX_08 @= {
  @ GetRuleString(xc(TX_08)); note(CheckingString(xc(TX_08)));
  nwell_inside_tg interacting [include_touch=ALL] nwell_outside_tg;
}
drErrorStack.push_back({ Error_TX_08, drErrGDSHash[xc(TX_08)], "" }); 

Error_TX_09 @= {
  @ GetRuleString(xc(TX_09)); note(CheckingString(xc(TX_09)));
  enclose(nwell_inside_tg, TGOXID, distance < TX_09, intersecting = {},
    extension = RADIAL); //touch is Ok!
}
drErrorStack.push_back({ Error_TX_09, drErrGDSHash[xc(TX_09)], "" }); 

Error_TX_10 @= {
  @ GetRuleString(xc(TX_10)); note(CheckingString(xc(TX_10)));
  external2(nwell_outside_tg, TGOXID, distance < TX_10, 
   intersecting = {},extension = RADIAL);
}
drErrorStack.push_back({ Error_TX_10, drErrGDSHash[xc(TX_10)], "" }); 

// TX 11 and 12 gate/tgoxid space/enc
gate_tg = dr_active_gate and TGOXID;
gate_not_tg = dr_active_gate not gate_tg;

drEncloseAllDir_(xc(TX_11),gate_tg, TGOXID, TX_11);
drMinSpace2_(xc(TX_12), TGOXID, gate_not_tg, TX_12); 


// Print debug layers
drPassthruStack.push_back({ POLY, {2,0} });
drPassthruStack.push_back({ TGOXID, {23,0} });
drPassthruStack.push_back({ NWELL, {11,0} });
drPassthruStack.push_back({ V1PITCHID, {2,151} });
drPassthruStack.push_back({ V3PITCHID, {2,153} });
drPassthruStack.push_back({ dr_active_gate, {400,0} });

#endif //#ifndef _P1273DX_TG_RS_


