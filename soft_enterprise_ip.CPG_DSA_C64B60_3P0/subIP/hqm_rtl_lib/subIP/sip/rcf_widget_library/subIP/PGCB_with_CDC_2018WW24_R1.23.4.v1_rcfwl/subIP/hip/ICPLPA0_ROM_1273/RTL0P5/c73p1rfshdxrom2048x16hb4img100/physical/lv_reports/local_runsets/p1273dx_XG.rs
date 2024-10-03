// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_XG.rs.rca 1.4 Mon Apr  9 15:35:57 2012 oakin Experimental $
//
// $Log: p1273dx_XG.rs.rca $
// 
//  Revision: 1.4 Mon Apr  9 15:35:57 2012 oakin
//  bitcell wwaivers.
// 
//  Revision: 1.3 Wed Mar 28 16:40:35 2012 sstalukd
//  For TSDR made value changes for XG_09
// 
//  Revision: 1.2 Tue Feb 28 11:16:12 2012 sstalukd
//  Moved drPL24_/drPL24waive_ functions from p1273_XGTGfunctions.rs to p12723_functions.rs and including p12723_PLhdr.rs in the modules directly
// 
//  Revision: 1.1 Tue Feb 28 09:11:01 2012 sstalukd
//  Initial checkin for 1273 module
// 


// 12723 XGOXID rules (LP G-ox rules)
#ifndef _P12723DX_XG_RS_
#define _P12723DX_XG_RS_

//Override dr values for TSDR ONLY (email from Moonsoo: 3/27/2011)
#if (_drTSDR == _drYES)
    XG_09 = 0.231;
#endif

Error_XG_01 @= {
  @ GetRuleString(xc(XG_01)); note(CheckingString(xc(XG_01)));
  allowed_ids = ULPPITCHID or POLYOD;
  not_allowed_ids = dr_all_polyid not allowed_ids;  //dr_all_polyid defined in common.rs
  XGOXID interacting [include_touch=ALL] not_allowed_ids;
}    
drErrorStack.push_back({ Error_XG_01, drErrGDSHash[xc(XG_01)], "" }); 

drMinSpace2_(xc(XG_13), XGOXID, TGOXID, XG_13);

Error_XG_21 @= {
  @ GetRuleString(xc(XG_21)); note(CheckingString(xc(XG_21)));
  ULPPITCHID not XGOXID;
}
drErrorStack.push_back({ Error_XG_21, drErrGDSHash[xc(XG_21)], "" }); 

drMinWidth_("XG_02", XGOXID, XG_02);
drMinSpace_("XG_03", XGOXID, XG_03);



//Similar to XG_05 rule being invoked in PL module
//THis check applies to ULPPITCHID and Digital Poly
#include <p12723_PLhdr.rs>
drPL24_(xc(XG_05), poly, polyDig, XGOXID, PL_06, PL_02,  PL_01); 
drPL24_(xc(XG_05), poly, polyXL,  XGOXID, PL_06, XPL_02, XPL_01); 

//Get poly outside XGOXID region 
poly_inside_xg = POLY and XGOXID;
poly_outside_xg = POLY not poly_inside_xg;

drEncloseDir_(xc(XG_06),   poly_inside_xg not_interacting TRDTOS,  XGOXID, XG_06, gate_dir);
drExternal2Dir_(xc(XG_07), poly_outside_xg not_interacting TRDTOS, XGOXID, XG_07, gate_dir);


//Get nwell outside XGOXID region 
nwell_inside_xg = (nwell and XGOXID) not drGrow(POLYOD, E = 0.140, W = 0.140) not drGrow(SRAMID2, E = 0.252, W = 0.252);
nwell_outside_xg = nwell not nwell_inside_xg;

drPassthruStack.push_back({nwell_inside_xg , {3015,8} });
drPassthruStack.push_back({nwell_outside_xg , {3015,9} });


Error_XG_08 @= {
  @ GetRuleString(xc(XG_08)); note(CheckingString(xc(XG_08)));
  nwell_inside_xg interacting [include_touch=ALL] nwell_outside_xg;
}
drErrorStack.push_back({ Error_XG_08, drErrGDSHash[xc(XG_08)], "" }); 
 
Error_XG_09 @= {
  @ GetRuleString(xc(XG_09)); note(CheckingString(xc(XG_09)));

  enclose(nwell_inside_xg, XGOXID, distance < XG_09, intersecting = {},
    extension = RADIAL); //touch is Ok!
}
drErrorStack.push_back({ Error_XG_09, drErrGDSHash[xc(XG_09)], "" }); 

Error_XG_10 @= {
  @ GetRuleString(xc(XG_10)); note(CheckingString(xc(XG_10)));
  external2(nwell_outside_xg, XGOXID, distance < XG_10, intersecting = {},
      extension = RADIAL);
}
drErrorStack.push_back({ Error_XG_10, drErrGDSHash[xc(XG_10)], "" }); 


// XG_11 and XG_12 gate/xgoxid space/enc
gate_xg = dr_active_gate and XGOXID;
gate_not_xg = dr_active_gate not gate_xg;


drEncloseAllDir_(xc(XG_11),gate_xg not POLYOD, XGOXID, XG_11);
drEncloseAllDir_(xc(BXG_11),gate_xg, XGOXID, BXG_11);
drMinSpace2_(xc(XG_12), XGOXID, gate_not_xg, XG_12);



// Print debug layers
drPassthruStack.push_back({ POLY, {2,0} });
drPassthruStack.push_back({ XGOXID, {81,146} });
drPassthruStack.push_back({ NWELL, {11,0} });
drPassthruStack.push_back({ ULPPITCHID, {2,43} });
drPassthruStack.push_back({ POLYOD, {2,22} });

drPassthruStack.push_back({ nwell_inside_xg,  {99,200} });
drPassthruStack.push_back({ nwell_outside_xg, {99,201} });
drPassthruStack.push_back({ gate_xg, 	      {99,203} });
drPassthruStack.push_back({ gate_not_xg,      {99,204} });

#endif //#ifndef _P12723_XG_RS_


