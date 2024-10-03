// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TPL_90.rs.rca 1.1 Thu Jan  8 15:19:11 2015 dgthakur Experimental $
//
// $Log: p1273dx_TPL_90.rs.rca $
// 
//  Revision: 1.1 Thu Jan  8 15:19:11 2015 dgthakur
//  Checks the TPL_90 rule.  Previously DFM, now becoming DRC.
//

#ifndef _P1273DX_TPL_90_RS_
#define _P1273DX_TPL_90_RS_


poly_tg_temp1 = POLY interacting (V3PITCHID or V1PITCHID);

//DFM_TPL_90_err= drSpace(poly_tg_temp1, <0.099, gate_dir) not_inside (TRDTOV1 or TRDTOV3);

tpl_90_con1 = connect({
  {{ DIFFCON }, POLYCON },
  {{ POLY }, POLYCON },
  {{ DIFFCON }, POLY }, // can happen in TG resistor
  {{ POLYCON, METAL0BC }, VIACON },
  {{ DIFFCON, METAL0BC }, VIACON },
  {{ METAL0BC, METAL1 }, VIA0 }
});

poly_tg_temp2 = stamp(poly_tg_temp1, POLY, tpl_90_con1, tpl_90_con1);

//No shorting risk for same net and must be inside TPT mask to flag
tpl_90_temp1 = external1(poly_tg_temp2, < 0.099, NONE, connectivity=DIFFERENT_NET,
  connect_sequence=tpl_90_con1, direction=gate_dir) inside mtpt; 

//Find gcn/poly float on which there is no shorting risk
float_gcn_poly = net_select(tpl_90_con1, not_connected_to_any = { VIACON, DIFFCON },
  output_from_layers = { POLY});

float_gcn_poly_one_risk = float_gcn_poly interacting [count=1] tpl_90_temp1;
tpl_90_waive = tpl_90_temp1 interacting [include_touch=ALL] float_gcn_poly_one_risk;

// Filtering errors that exist between 2 floating poly lines.
tpl_90_waive2 = tpl_90_temp1 interacting [count=2] float_gcn_poly;


/*   
  drDFMPassthru(float_gcn_poly, 2,41)   
  drDFMPassthru(float_gcn_poly_one_risk, 2,44)   
  drDFMPassthru(tpl_90_waive, 2,45)   
  drDFMPassthru(mtpt,129,13)   
  drDFMPassthru(poly_tg_temp2,129,14)   
  drDFMPassthru(tpl_90_temp1,129,15)   
*/

//mtpt definition is in BM flow
DFM_TPL_90_err = tpl_90_temp1 not (tpl_90_waive or tpl_90_waive2);
DFM_TPL_90 = polygon_centers(DFM_TPL_90_err, 0.01);


#endif
