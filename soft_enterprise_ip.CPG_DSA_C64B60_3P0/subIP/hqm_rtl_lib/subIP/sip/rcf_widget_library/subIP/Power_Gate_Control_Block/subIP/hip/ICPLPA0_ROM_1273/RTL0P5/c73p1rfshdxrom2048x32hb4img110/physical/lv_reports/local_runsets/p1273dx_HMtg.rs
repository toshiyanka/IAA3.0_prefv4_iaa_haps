// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_HMtg.rs.rca 1.5 Thu Sep 20 14:32:58 2012 dgthakur Experimental $

// $Log: p1273dx_HMtg.rs.rca $
// 
//  Revision: 1.5 Thu Sep 20 14:32:58 2012 dgthakur
//  hsd 1280; Allow relaxation to HMtg2 rule (now allow spacing between TGOXID to be upto 738 nm if there are no active devices in that thin gate channel).
// 
//  Revision: 1.4 Fri Aug 24 07:51:06 2012 dgthakur
//  Added waivers for HMtg2 check in case of abutting TG and waiver for HIP.  Cleaned up some code.
// 
//  Revision: 1.3 Tue Jun 19 17:32:48 2012 sstalukd
//  Replaced all direction (extension=RADIAL) w/ non_gate_dir specific check for HMtg_2 since we explicitly want to check for gate/non_gate_dir only
// 
//  Revision: 1.2 Wed May 30 09:22:20 2012 sstalukd
//  Modified labels of HMtg_2 to correctly reflect large tg regions of 30um2 instead of 200um2
// 
//  Revision: 1.1 Tue Feb 28 09:11:01 2012 sstalukd
//  Initial checkin for 1273 module
// 

// 12723 HMtg rules (copied from 1271)
#ifndef _P1273DX_HM_RS_
#define _P1273DX_HM_RS_

//Moved def to common file since it's used both by this module and halfdrc
#include <1273/p1273_HMtg_common.rs>

//Since there is no drfile for this yet
drErrGDSHash[xc(HMtg)] = {254,100} ;
drHash[xc(HMtg)] = xc(Width of the intersection of thin gate channel and STI channel regions cannot be > 0.54um);
drValHash[xc(HMtg)] = 0.54;

drErrGDSHash[xc(HMtg_flat)] = {254,101} ;
drHash[xc(HMtg_flat)] = xc(Width of the intersection of thin gate channel and STI channel regions cannot be > 0.54um);
drValHash[xc(HMtg_flat)] = 0.54;

drErrGDSHash[xc(HMtg_2a)] = {254,102};
drHash[xc(HMtg_2a)] = xc(Min space between large Poly_v3pitch (Dimensions >=6umX6um or Area >=30um2) is 5um);
drValHash[xc(HMtg_2a)] = 0;

drErrGDSHash[xc(HMtg_2b)] = {254,103};
drHash[xc(HMtg_2b)] = xc(Min space between large Poly_v1pitch (Dimensions >=6umX6um or Area >=30um2) is 5um);
drValHash[xc(HMtg_2b)] = 0;

drErrGDSHash[xc(HMtg_2c)] = {254,104};
drHash[xc(HMtg_2c)] = xc(Min space between large Poly_v1pitch and Poly_v3pitch (Dimensions >=6umX6um or Area >=30um2) is 5um);
drValHash[xc(HMtg_2c)] = 0;



tgoxid_v1pitch = large_polyfd_v1pitch_regions interacting V1PITCHID;
tgoxid_v3pitch = large_polyfd_v3pitch_regions interacting V3PITCHID;


//Compute waiver regions for this rule. Can waive TGOXID space if it does
//not have any active device (HMtg3 rule). The min of the range (x,5)
//below is computed from abutting TG regions.

//Allow HMtg3 exception
tgoxid_space_ngd = drSpace(TGOXID, <=0.738, non_gate_dir); //738 required by HIP
tgoxid_space_gd = drSpace(TGOXID, <=0.738, gate_dir);
tgoxid_space_cand = tgoxid_space_ngd or tgoxid_space_gd;
tgoxid_space_poly_dnw = (POLY interacting tgoxid_space_cand) interacting gate;
tgoxid_space_dnw = tgoxid_space_cand interacting tgoxid_space_poly_dnw;
tgoxid_space_w = tgoxid_space_cand not_interacting tgoxid_space_dnw;
drPassthru( tgoxid_space_w,   1950, 5)

//TG-TG
drMinSpaceDir_(xc(HMtg_2a), tgoxid_v3pitch, (0.430,5), non_gate_dir, tgoxid_space_w);
drMinSpaceDir_(xc(HMtg_2a), tgoxid_v3pitch, (0.462,5), gate_dir, tgoxid_space_w);

//TGULV-TGULV
drMinSpaceDir_(xc(HMtg_2b), tgoxid_v1pitch, (0.284,5), non_gate_dir, tgoxid_space_w);
drMinSpaceDir_(xc(HMtg_2b), tgoxid_v1pitch, (0.462,5), gate_dir, tgoxid_space_w);

//TGULV-TG
drMinSpaceDir2_(xc(HMtg_2c), tgoxid_v1pitch, tgoxid_v3pitch, (0.357,5), non_gate_dir, tgoxid_space_w);
drMinSpaceDir2_(xc(HMtg_2c), tgoxid_v1pitch, tgoxid_v3pitch, (0.462,5), gate_dir, tgoxid_space_w);




//Define channel region (this is thin-gate channel between 
//large tg polyid regions)
thingate_channel = external1(large_polyfd_regions, distance = [5,30], 
	  orientation = PARALLEL, extension=NONE);

/* Merge small diffusions first */
size1: double = 0.070;
size2: double = 0.035;
size3: double = 1.75;
diff1         = drOverUnder(DIFF,size1);
diff_large    = drUnderOver(diff1,size2);
diff_merged   = drOverUnder(diff_large,size3);
 
//Now identify the channels (sti and thin-gate) which will be used 
//to check the intersection error
thingate_channel_intersection = thingate_channel not diff_merged;

//Get rid of small polyfd regions
//These are the small isolated diffusion structures
channel_sti_final = thingate_channel_intersection not small_polyfd_regions;

//Now find the HM error by sizing
hmtg_size: double = 0.54;
HMtg_error = drUnderOver(channel_sti_final,hmtg_size/2);

Error_HMtg @= {
  @ GetRuleString(xc(HMtg),"um"); note(CheckingString(xc(HMtg)));
  copy(HMtg_error);
}
drErrorStack.push_back({ Error_HMtg, drErrGDSHash[xc(HMtg)], "" });

//Also output a flattened error 
Error_HMtg_flat @= {
  @ GetRuleString(xc(HMtg_flat),"um"); note(CheckingString(xc(HMtg_flat)));
  flatten_by_cells(HMtg_error);  
}
drErrorStack.push_back({ Error_HMtg_flat, drErrGDSHash[xc(HMtg_flat)], "" });


//Output debug layers
drPassthruStack.push_front({ poly,  	  {2,0} });
drPassthruStack.push_front({ V1PITCHID,   {2,151} });
drPassthruStack.push_front({ V3PITCHID,   {2,153} });
drPassthruStack.push_front({ ndiff, 	  {1,0} });
drPassthruStack.push_front({ pdiff, 	  {8,0} });
drPassthruStack.push_front({ TRDTOV1,	  {81,165} });
drPassthruStack.push_front({ TRDTOV3,	  {81,167} });
drPassthruStack.push_front({ TGOXID,	  {23,0} });

drPassthruStack.push_front({ large_polyfd_regions,    {100,0} });
drPassthruStack.push_front({ small_polyfd_regions,    {101,0} });
drPassthruStack.push_front({ thingate_channel,    {102,0} });
drPassthruStack.push_front({ diff_merged,	  {105,0} });
drPassthruStack.push_front({ channel_sti_final,   {107,0} });

#endif //#ifndef _P12723DX_HM_RS_

