// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273_BMesd.rs.rca 1.1 Wed Mar 14 09:24:37 2012 oakin Experimental $
//
// $Log: p1273_BMesd.rs.rca $
// 
//  Revision: 1.1 Wed Mar 14 09:24:37 2012 oakin
//  new files for esd/nes mask generation (Copy from Nidhi).
// 

//ESD
frame_esd = (FLEXPOLARITY or ESDFOH)or ESDFO;
pdiff_like_esd = PDIFF not frame_esd;
ndiff_like_esd = NDIFF not frame_esd;
nactive_esd = ndiff_like_esd not ALLNWELL;
pactive_esd = pdiff_like_esd and ALLNWELL;

allnwell_has_pdiff_esd = ALLNWELL not_outside pdiff_like_esd;
ntap_esd =    ndiff_like_esd  and ALLNWELL;
ptap_esd =    pdiff_like_esd not ALLNWELL;

sized_ntap_all_esd = drGrow(ntap_esd, E = TAPOGDSZ_sd, W= TAPOGDSZ_sd, N= TAPPGDSZ_sd, S= TAPPGDSZ_sd);
sized_ptap_all_esd = drGrow(ptap_esd, E= TAPOGDSZ_sd, W= TAPOGDSZ_sd, N= TAPPGDSZ_sd, S= TAPPGDSZ_sd);

sized_ntap_tg1_esd = SD_tap_sizing (ntap_esd , tgpitch1id, TAPPGDSZ_sd, 0.5*tgpitch1_sd);
sized_ptap_tg1_esd = SD_tap_sizing (ptap_esd , tgpitch1id, TAPPGDSZ_sd, 0.5*tgpitch1_sd);

sized_ntap_tg2_esd = SD_tap_sizing (ntap_esd , tgpitch3id, TAPPGDSZ_sd, 0.5*tgpitch3_sd);
sized_ptap_tg2_esd = SD_tap_sizing (ptap_esd , tgpitch3id, TAPPGDSZ_sd, 0.5*tgpitch3_sd);

sized_ntap_esd = sized_ntap_all_nes or (sized_ntap_tg1_nes or sized_ntap_tg2_nes);
sized_ptap_esd = sized_ptap_all_nes or (sized_ptap_tg1_nes or sized_ptap_tg2_nes);

nactive_esd_prot = drGrow(nactive_esd, E= ACTIVEPROTOGD_sd, W=  ACTIVEPROTOGD_sd, N= ACTIVEPROTPGD_sd , S= ACTIVEPROTPGD_sd);
pactive_esd_prot = drGrow(pactive_esd, E=  ACTIVEPROTOGD_sd, W=  ACTIVEPROTOGD_sd, N= ACTIVEPROTPGD_sd , S= ACTIVEPROTPGD_sd);

basic_esd = ( allnwell_has_pdiff_esd not (sized_ntap_esd not pactive_esd_prot)  ) or ( sized_ptap_esd not nactive_esd_prot);

esd_after_cleanup = SD_StdCleanUp_tsdr(basic_esd, pdiff_like_esd, ndiff_like_esd, cleanspace_sd, cleanspace_sd);

esd_synth_1=SD_Horz_Pitch_Cleanup_tsdr(esd_after_cleanup,MIN_BM_PITCH_sd,  pdiff_like_esd, pactive_esd, ndiff_like_esd, nactive_esd, ACTIVEPROTC2C_sd);

esd_synth =  (esd_synth_1 or ESDMG) not ESDTG;
