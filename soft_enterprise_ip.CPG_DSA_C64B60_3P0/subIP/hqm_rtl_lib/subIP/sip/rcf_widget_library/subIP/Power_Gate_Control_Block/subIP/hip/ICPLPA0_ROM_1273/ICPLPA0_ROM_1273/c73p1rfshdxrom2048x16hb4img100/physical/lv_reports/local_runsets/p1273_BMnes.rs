// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273_BMnes.rs.rca 1.3 Thu May 16 11:41:41 2013 dgthakur Experimental $
//
// $Log: p1273_BMnes.rs.rca $
// 
//  Revision: 1.3 Thu May 16 11:41:41 2013 dgthakur
//  Removed redefinition of a variable causing compile to fail.
// 
//  Revision: 1.2 Tue May 14 12:58:47 2013 oakin
//  nes synthesis chnage (from Nidhi).
// 
//  Revision: 1.1 Wed Mar 14 09:24:37 2012 oakin
//  new files for esd/nes mask generation (Copy from Nidhi).
// 

//NES

// NEW TG tr region change

DIFFCHECK_GRID_PITCH : double = 0.084;
LOGIC_POLY_PITCH = 0.070;
tg_tr_pgd_sz :double = 0.035;
tg_tr_ogd_sz :double = 0.115;



tg_pitchid_all = V1PITCHID or V3PITCHID;   // pitch IDs
tg_trans_reg_orig = TRDTOV1 or TRDTOV3;    // transition region IDs 

// Sizing OGD edges of TR region 
tg_trans_reg_orig_ogd_e = angle_edge(tg_trans_reg_orig, non_gate_angle);


// Identifying OGDedge of TR region that faces logic region ( it does not have an coincident edge with TG pitch ID) 
tg_trans_reg_orig_ogd_e_out = not_interacting_edge(tg_trans_reg_orig_ogd_e, tg_pitchid_all);
tg_trans_reg_orig_ogd_e_out_sz = edge_size(tg_trans_reg_orig_ogd_e_out, inside = 1.25*DIFFCHECK_GRID_PITCH);

// Identifying OGD edge of TR region that faces TG region 
tg_trans_reg_orig_ogd_e_in = interacting_edge(tg_trans_reg_orig_ogd_e, tg_pitchid_all);
tg_trans_reg_orig_ogd_e_in_sz = edge_size(tg_trans_reg_orig_ogd_e_in, inside = tg_tr_pgd_sz);

// TG TR region post OGD edge sizing 
tg_trans_reg_mod = tg_trans_reg_orig not (tg_trans_reg_orig_ogd_e_in_sz or tg_trans_reg_orig_ogd_e_out_sz);


// Picking PGD edges of modified TG TR region 
tg_trans_reg_mod_pgd_e =  angle_edge(tg_trans_reg_mod, gate_angle);
tg_trans_reg_pgd_e     =  angle_edge(tg_trans_reg_orig, gate_angle);

// Also need to pick interior edges that have a concave corner (for rectilinear TR region) as it should not be sized (integration requirement) 
tg_trans_reg_orig_inside_concave = interacting_edge(angle_edge(adjacent_edge(tg_trans_reg_orig, length >0 ,angle1 = 90), gate_angle), tg_pitchid_all);

// Identifying PGD edge that faces logic region( does not interact with TG pitch ID) 
tg_trans_reg_mod_pgd_e_out = interacting_edge(not_interacting_edge(tg_trans_reg_mod_pgd_e, tg_pitchid_all), tg_trans_reg_pgd_e);

// The PGD edge facing logic region gets sized down by different numbers for 210 pitch vs 140 pitch 
tg_trans_reg_mod_pgd_e_out_210p = interacting_edge(tg_trans_reg_mod_pgd_e_out, TRDTOV3);
tg_trans_reg_mod_pgd_e_out_140p = interacting_edge(tg_trans_reg_mod_pgd_e_out, TRDTOV1);

os_tg_trans_reg_mod_pgd_e_out_210p = edge_size(tg_trans_reg_mod_pgd_e_out_210p, inside = 2.5*LOGIC_POLY_PITCH);
os_tg_trans_reg_mod_pgd_e_out_140p = edge_size(tg_trans_reg_mod_pgd_e_out_140p, inside = 1.5*LOGIC_POLY_PITCH);
tg_trans_reg_mod_pgd_e_out_sz = os_tg_trans_reg_mod_pgd_e_out_210p or os_tg_trans_reg_mod_pgd_e_out_140p;

// Identify the PGD edge facing TG region 

// Do not size the PGD edge with concave corner 
tg_trans_reg_mod_pgd_e_in = not_interacting_edge(not_interacting_edge(tg_trans_reg_mod_pgd_e, tg_trans_reg_mod_pgd_e_out), tg_trans_reg_orig_inside_concave);
tg_trans_reg_mod_pgd_e_in_sz = edge_size(tg_trans_reg_mod_pgd_e_in, inside = tg_tr_ogd_sz);

// Final TG TR region to be blocked at nes 
tg_trans_reg  = tg_trans_reg_mod not (tg_trans_reg_mod_pgd_e_out_sz or tg_trans_reg_mod_pgd_e_in_sz);



frame_nes = (FLEXPOLARITY or NESFOH)or NESFO;

pdiff_like_nes = PDIFF not frame_nes;
ndiff_like_nes = NDIFF not frame_nes;
nactive_nes = ndiff_like_nes not ALLNWELL;
pactive_nes = pdiff_like_nes and ALLNWELL;

allnwell_has_pdiff_nes = ALLNWELL not_outside pdiff_like_nes;
ntap_nes =    ndiff_like_nes  and ALLNWELL;
ptap_nes =    pdiff_like_nes not ALLNWELL;

sized_ntap_all_nes = drGrow(ntap_nes, E = TAPOGDSZ_sd, W= TAPOGDSZ_sd, N= TAPPGDSZ_sd, S= TAPPGDSZ_sd);
sized_ptap_all_nes = drGrow(ptap_nes, E= TAPOGDSZ_sd, W= TAPOGDSZ_sd, N= TAPPGDSZ_sd, S= TAPPGDSZ_sd);

sized_ntap_tg1_nes = SD_tap_sizing (ntap_nes , tgpitch1id, TAPPGDSZ_sd , 0.5*tgpitch1_sd);
sized_ptap_tg1_nes = SD_tap_sizing (ptap_nes , tgpitch1id, TAPPGDSZ_sd, 0.5*tgpitch1_sd);

sized_ntap_tg2_nes = SD_tap_sizing (ntap_nes , tgpitch3id, TAPPGDSZ_sd, 0.5*tgpitch3_sd);
sized_ptap_tg2_nes = SD_tap_sizing (ptap_nes , tgpitch3id, TAPPGDSZ_sd, 0.5*tgpitch3_sd);

sized_ntap_nes = sized_ntap_all_nes or (sized_ntap_tg1_nes or sized_ntap_tg2_nes);
sized_ptap_nes = sized_ptap_all_nes or (sized_ptap_tg1_nes or sized_ptap_tg2_nes);

nactive_nes_prot = drGrow(nactive_nes, E=  ACTIVEPROTOGD_sd, W=  ACTIVEPROTOGD_sd, N= ACTIVEPROTPGD_sd , S= ACTIVEPROTPGD_sd);
pactive_nes_prot = drGrow(pactive_nes, E=  ACTIVEPROTOGD_sd, W=  ACTIVEPROTOGD_sd, N= ACTIVEPROTPGD_sd , S= ACTIVEPROTPGD_sd);

basic_nes = ( allnwell_has_pdiff_nes not (sized_ntap_nes not pactive_nes_prot)  ) or (( sized_ptap_nes not nactive_nes_prot) or tg_trans_reg);

nes_area_occupant = pdiff_like_nes or tg_trans_reg;

nes_after_cleanup = SD_StdCleanUp_tsdr(basic_nes, nes_area_occupant, ndiff_like_nes, cleanspace_sd, cleanspace_sd);
nes_synth1=SD_Horz_Pitch_Cleanup_tsdr(nes_after_cleanup,MIN_BM_PITCH_sd,  nes_area_occupant, pactive_nes, ndiff_like_nes, nactive_nes,  ACTIVEPROTC2C_sd);
nes_synth = (nes_synth1 not NESMG) or NESTG;

#if _drDEBUG
 drPassthruStack.push_back({tg_trans_reg , {1900,301} });
 drPassthruStack.push_back({TRDTOV3 , {81,167} });
 drPassthruStack.push_back({tg_trans_reg_orig_inside_concave , {1900,302} });
 drPassthruStack.push_back({tg_trans_reg_mod_pgd_e_out , {1900,303} });
 drPassthruStack.push_back({tg_trans_reg_mod_pgd_e_in , {1900,304} });
 drPassthruStack.push_back({tg_trans_reg_mod_pgd_e_in , {1900,304} });
 drPassthruStack.push_back({ nes_synth, {1900,305} });
#endif
