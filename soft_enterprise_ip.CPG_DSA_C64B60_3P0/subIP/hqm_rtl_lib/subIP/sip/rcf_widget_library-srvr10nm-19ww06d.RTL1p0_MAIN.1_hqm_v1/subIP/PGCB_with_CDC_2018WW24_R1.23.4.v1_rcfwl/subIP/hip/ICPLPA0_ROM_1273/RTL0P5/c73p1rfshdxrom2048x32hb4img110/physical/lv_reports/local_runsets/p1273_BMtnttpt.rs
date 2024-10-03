// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273_BMtnttpt.rs.rca 1.2 Fri Feb  7 10:51:08 2014 oakin Experimental $
//
// $Log: p1273_BMtnttpt.rs.rca $
// 
//  Revision: 1.2 Fri Feb  7 10:51:08 2014 oakin
//  Updated TNT per Divya.
// 
//  Revision: 1.1 Fri Mar 16 10:28:06 2012 oakin
//  from Nidhi.
// 

// TPT
MIN_TGBM_SPW : const double = 0.126;
MIN_TGBM_AREAHOLE : const double = 0.0264;
MIN_TGBM_PITCH : const double = 0.273;
cleanspace_tg: double = MIN_TGBM_SPW/2 - HALFGRID;

tg_nwl = TGOXID and ALLNWELL;
tg_pwl = TGOXID not ALLNWELL;

tg_ptap = PDIFF and tg_pwl;
tg_ntap = NDIFF and tg_nwl;

tg_nactive = NDIFF and tg_pwl;
tg_pactive = PDIFF and tg_nwl;

sized_tg_ntap_tg1 = SD_tap_sizing (tg_ntap , tgpitch1id, TAPPGDSZ_sd, 0.5*tgpitch1_sd);
sized_tg_ntap_tg3 = SD_tap_sizing (tg_ntap , tgpitch3id, TAPPGDSZ_sd, 0.5*tgpitch3_sd);

sized_tg_ntap = sized_tg_ntap_tg1 or sized_tg_ntap_tg3;

//sized_tg_ntap = drGrow( tg_ntap, E = TAPOGDSZ_sd, W= TAPOGDSZ_sd, N = TAPPGDSZ_sd, S = TAPPGDSZ_sd);

tg_pactive_prot = drGrow(tg_pactive, E =  ACTIVEPROTOGD_sd, W=  ACTIVEPROTOGD_sd, N = ACTIVEPROTPGD_sd , S = ACTIVEPROTPGD_sd);
// Block ptap, block ntap (this is by default)
basic_tpt =  tg_nwl not ( sized_tg_ntap not tg_pactive_prot);

//tpt_area_occupant  is tg_pactive

tpt_hole_occupant = NDIFF or (PDIFF not tg_pactive);          // nactive, ptap and ntap

// Clean up

tpt_after_cleanup = SD_StdCleanUp_tsdr(basic_tpt, tg_pactive, tpt_hole_occupant, cleanspace_tg, cleanspace_tg);
tpt_after_pitch = SD_Horz_Pitch_Cleanup_tsdr(tpt_after_cleanup,MIN_TGBM_PITCH, tg_pactive, tg_pactive, tpt_hole_occupant, tg_nactive, ACTIVEPROTC2C_sd);

tpt_synth = (tpt_after_pitch or TPT) not TPTTOSYN;


V1_TGOXID_OGD_SZ: const double = 0.068;
V3_TGOXID_OGD_SZ: const double = 0.175;

sized_V1_tgoxid = drShrink((TGOXID not_outside V1PITCHID), E = V1_TGOXID_OGD_SZ, W = V1_TGOXID_OGD_SZ, N = 0, S = 0);
sized_V3_tgoxid = drShrink((TGOXID not_outside V3PITCHID), E = V3_TGOXID_OGD_SZ, W = V3_TGOXID_OGD_SZ, N = 0, S = 0);

sized_tgoxid = sized_V1_tgoxid or sized_V3_tgoxid;

tg_nwl_for_tnt = sized_tgoxid and ALLNWELL;
tg_pwl_for_tnt = sized_tgoxid not ALLNWELL;

tg_ptap_for_tnt = PDIFF and tg_pwl_for_tnt;
tg_ntap_for_tnt = NDIFF and tg_nwl_for_tnt;

tg_nactive_for_tnt = NDIFF and tg_pwl_for_tnt;
tg_pactive_for_tnt = PDIFF and tg_nwl_for_tnt;


//TNT

sized_tg_ptap_tg1 = SD_tap_sizing (tg_ptap_for_tnt , tgpitch1id, TAPPGDSZ_sd, 0.5*tgpitch1_sd);
sized_tg_ptap_tg3 = SD_tap_sizing (tg_ptap_for_tnt , tgpitch3id, TAPPGDSZ_sd, 0.5*tgpitch3_sd);

sized_tg_ptap = sized_tg_ptap_tg1 or sized_tg_ptap_tg3;

tg_nactive_prot = drGrow(tg_nactive_for_tnt, E =  ACTIVEPROTOGD_sd, W=  ACTIVEPROTOGD_sd, N = ACTIVEPROTPGD_sd , S = ACTIVEPROTPGD_sd);

// Block ptap, block ntap (this is by default)
basic_tnt =  tg_pwl_for_tnt not ( sized_tg_ptap not tg_nactive_prot);

//tnt_area_occupant is tg_nactive
tnt_hole_occupant = PDIFF or (NDIFF not tg_nactive_for_tnt);          // pactive, ptap and ntap

// Clean up
tnt_after_cleanup = SD_StdCleanUp_tsdr(basic_tnt, tg_nactive_for_tnt, tnt_hole_occupant, cleanspace_tg, cleanspace_tg);
tnt_after_pitch = SD_Horz_Pitch_Cleanup_tsdr(tnt_after_cleanup,MIN_TGBM_PITCH, tg_nactive_for_tnt, tg_nactive_for_tnt, tnt_hole_occupant, tg_pactive_for_tnt, ACTIVEPROTC2C_sd);
tnt_synth = (tnt_after_pitch or TNT) not TNTTOSYN;

