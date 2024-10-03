// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_MXBC_template.rs.rca 1.2 Tue Jul 22 11:39:13 2014 dgthakur Experimental $
//
// $Log: p1273dx_MXBC_template.rs.rca $
// 
//  Revision: 1.2 Tue Jul 22 11:39:13 2014 dgthakur
//  Fix for M5_128/138 false flag.  These rules have waivers for certain fixed metal allowed templates.  The waiver was not working since the template was not getting correctly identified in a specific corner case.  Test case is par_psf1_1.oas (email from Billy Loo 7/20/14).
// 
//  Revision: 1.1 Wed Jul 20 17:00:41 2011 dgthakur
//  First check in for 1273 files
//


//*** p1273 M3/M4/M5 template - Dipto Thakurta Started 28Jun11 *** 
//
//COMMON MODULE FOR METAL 3/4/5 B/C TEMPLATE GENERATION
//**DO NOT WRAP WITH IFDEF SINCE THIS CODE WILL BE REUSED**



//Define the template related widths
mx(b28) = drWidth( mx(b_all), 0.028, mx(perp_dir));
mx(b32) = drWidth( mx(b_all), 0.032, mx(perp_dir));
mx(b66) = drWidth( mx(b_all), 0.066, mx(perp_dir));
mx(b74) = drWidth( mx(b_all), 0.074, mx(perp_dir));
mx(b76) = drWidth( mx(b_all), 0.076, mx(perp_dir));
mx(b84) = drWidth( mx(b_all), 0.084, mx(perp_dir));

mx(c28) = drWidth( mx(c_all), 0.028, mx(perp_dir));
mx(c32) = drWidth( mx(c_all), 0.032, mx(perp_dir));


#define ext_opt_perpd  extension = NONE_INCLUSIVE, orientation = PARALLEL, direction = mx(perp_dir) 


//Template A 66/74/76/84 with four 28 lines on each side
mx(tempA) = mx(b66) or mx(b74) or mx(b76) or mx(b84);
mx(ky) = metalxbc not (mx(tempA) or mx(b28) or mx(c28));
mx(tempA_edge1) = not_external1_edge(mx(tempA), distance < 5*MX(21)+ 4*0.028, ext_opt_perpd);
mx(tempA_edge2) = not_external2_edge(mx(tempA_edge1), mx(ky), distance < 5*MX(21) + 4*0.028, ext_opt_perpd); 
mx(tempA_a) = internal1(mx(tempA_edge2), distance=0.076, ext_opt_perpd);  //76 anchor candidate
mx(tempA_b) = internal1(mx(tempA_edge2), distance=0.084, ext_opt_perpd);  //84 anchor candidate
mx(tempA_c) = internal1(mx(tempA_edge2), distance=0.074, ext_opt_perpd);  //74 anchor candidate
mx(tempA_d) = internal1(mx(tempA_edge2), distance=0.066, ext_opt_perpd);  //66 anchor candidate
mx(tempA_cand) =  mx(tempA_a) or mx(tempA_b) or mx(tempA_c) or mx(tempA_d);
//bug fix for small segments (test case showing false flag par_psf1_1.oas) - Dipto 7/22/14
//Remove small segment candidates
mx(tempA_cand_small) = drWidth(mx(tempA_cand), <=MX(41), mx(para_dir));
mx(tempA_cand) = mx(tempA_cand) not mx(tempA_cand_small);
//
mx(wvA_temp) = drBCtemplate(mx(b_all), mx(c_all), mx(tempA_cand), xc(B), MX(21), {28,28,28,28}, {28,28,28,28}, mx(perp_dir));
mx(wvA) = drGrowDir( drShrinkDir(mx(wvA_temp), MX(60)/2-drunit, mx(para_dir)), MX(60)/2-drunit, mx(para_dir));



//Template B 66/74/76/84 with four 32 lines on each side
mx(tempB) = mx(b66) or mx(b74) or mx(b76) or mx(b84);
mx(ky) = metalxbc not (mx(tempB) or mx(b32) or mx(c32));
mx(tempB_edge1) = not_external1_edge(mx(tempB), distance < 5*MX(21)+ 4*0.032, ext_opt_perpd);
mx(tempB_edge2) = not_external2_edge(mx(tempB_edge1), mx(ky), distance < 5*MX(21) + 4*0.032, ext_opt_perpd); 
mx(tempB_a) = internal1(mx(tempB_edge2), distance=0.076, ext_opt_perpd);  //76 anchor candidate
mx(tempB_b) = internal1(mx(tempB_edge2), distance=0.084, ext_opt_perpd);  //84 anchor candidate
mx(tempB_c) = internal1(mx(tempB_edge2), distance=0.074, ext_opt_perpd);  //74 anchor candidate
mx(tempB_d) = internal1(mx(tempB_edge2), distance=0.066, ext_opt_perpd);  //66 anchor candidate
mx(tempB_cand) =  mx(tempB_a) or mx(tempB_b) or mx(tempB_c) or mx(tempB_d);
//
//Remove small segment matches
mx(tempB_cand_small) = drWidth(mx(tempB_cand), <=MX(41), mx(para_dir));
mx(tempB_cand) = mx(tempB_cand) not mx(tempB_cand_small);
//
mx(wvB_temp) = drBCtemplate(mx(b_all), mx(c_all), mx(tempB_cand), xc(B), MX(21), {32,32,32,32}, {32,32,32,32}, mx(perp_dir));
mx(wvB) = drGrowDir( drShrinkDir(mx(wvB_temp), MX(60)/2-drunit, mx(para_dir)), MX(60)/2-drunit, mx(para_dir));


//DEBUG LAYERS
drPassthruStack.push_front({ mx(tempA_cand), {599,0} });
drPassthruStack.push_front({ mx(wvA), {599,1} });
drPassthruStack.push_front({ mx(wvB), {599,2} });
