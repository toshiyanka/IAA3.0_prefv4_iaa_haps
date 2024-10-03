// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TSDRIL.rs.rca 1.1 Tue Jan  3 13:05:52 2012 kperrey Experimental $

//
// $Log: p1273dx_TSDRIL.rs.rca $
// 
//  Revision: 1.1 Tue Jan  3 12:47:03 2012 kperrey
//  pulled the tc/tsdr stuff out of p1272dx_IL.rs
// 
//  from revision 1.3 of p1272dx_IL.rs.rca Thu Dec 15 13:10:08 2011 oakin


#ifndef _P1273DX_TSDRIL_RS_
#define _P1273DX_TSDRIL_RS_
  
   // establish cell lists for layer waivers 
   tsdr_diffusion_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_diffusion_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_DIFFCHECK_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_DIFFCHECK_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_ndiff_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_ndiff_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_ndiff_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_poly_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_poly_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_poly_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_polybb_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_polybb_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_diffcon_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_diffcon_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_diffcon_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_polycon_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_polycon_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_polycon_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_pdiff_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_pdiff_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_pdiff_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_nwell_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_nwell_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_nwell_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_viacon_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_viacon_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_viacon_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal0_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal0_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal0_keepGenAway_ILWaiver: list of string = { "1272_l_*", "tp1dropincell_x72b", "tp1pad*" };
   tsdr_metal0_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via0_densityid_ILWaiver: list of string = {"1272_l_*", "tp1padstdfe_rf_s"};
   tsdr_via0_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via0_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_via0_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal1_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal1_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal1_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal1_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via1_densityid_ILWaiver: list of string = {"1272_l_*", "tp1padstdfe_rf_s"};
   tsdr_via1_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via1_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_via1_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal2_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal2_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal2_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal2_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via2_densityid_ILWaiver: list of string = {"1272_l_*", "tp1padstdfe_rf_s"};
   tsdr_via2_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via2_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_via2_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal3_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal3_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal3_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal3_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via3_densityid_ILWaiver: list of string = {"1272_l_*", "tp1padstdfe_rf_s"};
   tsdr_via3_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via3_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_via3_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal4_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal4_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal4_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal4_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via4_densityID_ILWaiver: list of string = {"tp1padstdfe_rf_s"};
   tsdr_via4_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via4_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_via4_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal5_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal5_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal5_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal5_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via5_densityID_ILWaiver: list of string = {"tp1padstdfe_rf_s"};
   tsdr_via5_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via5_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_via5_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal6_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal6_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal6_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal6_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via6_densityID_ILWaiver: list of string = {"tp1padstdfe_rf_s"};
   tsdr_via6_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via6_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_via6_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal7_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal7_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal7_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal7_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via7_densityID_ILWaiver: list of string = {"tp1padstdfe_rf_s"};
   tsdr_via7_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via7_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_via7_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal8_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal8_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal8_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal8_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via8_densityID_ILWaiver: list of string = {"tp1padstdfe_rf_s"};
   tsdr_via8_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via8_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_via8_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal9_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal9_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal9_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal9_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via9_densityID_ILWaiver: list of string = {"tp1padstdfe_rf_s"};
   tsdr_via9_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via9_keepGenAway_ILWaiver: list of string = {"tp1dropincell_x72b"};
   tsdr_via9_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal10_densityid_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal10_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal10_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal10_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via10_densityID_ILWaiver: list of string = {"1272_l_*", "tp1padstdfe_rf_s"};
   tsdr_via10_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via10_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_via10_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_metal11_densityID_ILWaiver: list of string = {"1272_l_*"};
   tsdr_metal11_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_metal11_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b", "tp1pad*"};
   tsdr_metal11_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b", "tp1pad*"};

   tsdr_via11_densityID_ILWaiver: list of string = strcat({"1272_l_*"}, dr_via11_densityID_ILWaiver);
   tsdr_via11_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_via11_keepGenAway_ILWaiver: list of string = {"1272_l_*", "tp1dropincell_x72b"};
   tsdr_via11_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_CE1_keepGenAway_ILWaiver: list of string = {"1272_l_*"};

   tsdr_CE2_keepGenAway_ILWaiver: list of string = {"1272_l_*"};

   tsdr_CE3_keepGenAway_ILWaiver: list of string = {"1272_l_*"};

   tsdr_tm1_densityID_ILWaiver: list of string = strcat({"1272_l_*"}, dr_tm1_densityID_ILWaiver);
   tsdr_tm1_keepGenAway_ILWaiver: list of string = {"1272_l_*"};
   tsdr_tm1_fillerID_ILWaiver: list of string = {"tp0filler*", "tp0rffiller"};
   tsdr_tm1_fillerIgnore_ILWaiver: list of string = {"tp1dropincell_x72b"};

   tsdr_c4b_keepGenAway_ILWaiver: list of string = {"1272_l_*"};
   tsdr_c4b_maskdrawing_ILWaiver: list of string = { "tp1pad*"};

   tsdr_c4e_maskdrawing_ILWaiver: list of string = { "tp1pad*"};

   tsdr_c4t_maskdrawing_ILWaiver: list of string = { "tp1pad*"};

   // previously from tsdr_IL_defines
   tsdr_fepad_boundary_ILWaiver: list of string = {"tp1padstdfe"};

   tsdr_bepad_boundary_ILWaiver: list of string = {"tp1padstdbe", "tp1padstdnofe"};

   tsdr_empad_boundary_ILWaiver: list of string = {"tp1padem", "tp1padem2", "tp1pademsm"};

   tsdr_rfpad_boundary_ILWaiver: list of string = {"tp1padstdfe_rf_g", "tp1padstdfe_rf_s"};

   tsdr_slpad_boundary_ILWaiver: list of string = {
      "tp1pad_novia_tcsl", "tp1padtcsl", "tp1padtcsl_sl1", "tp1padtcsl_sl1_left", 
       "tp1padtcsl_sl2", "tp1padtcsl_sl2_left", "tp1padtcsl_sl13", "tp1padtcsl_sl3_left", 
       "tp1padtcsl_sl4", "tp1padtcsl_sl4_left", "tp1padtcsl_sl4_novia", "tp1padsl0", 
       "tp1padsl0_no_via", "tp1padsl0_sl1", "tp1padsl0_sl2", "tp1padsl0_sl3", 
       "tp1padsl0_sl4", "tp1padslem"
   };
   

// now set the AssignTextHashWaiver for a given layer to its needed value 
   AssignTextHashWaiver["diffusion_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_diffusion_keepGenAway_ILWaiver);
   AssignTextHashWaiver["diffusion_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_diffusion_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["DIFFCHECK_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_DIFFCHECK_keepGenAway_ILWaiver);
   AssignTextHashWaiver["DIFFCHECK_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_DIFFCHECK_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["ndiff_fillerID"] = strcat(dr_default_ILWaiver, tsdr_ndiff_fillerID_ILWaiver);
   AssignTextHashWaiver["ndiff_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_ndiff_keepGenAway_ILWaiver);
   AssignTextHashWaiver["ndiff_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_ndiff_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["poly_fillerID"] = strcat(dr_default_ILWaiver, tsdr_poly_fillerID_ILWaiver);
   AssignTextHashWaiver["poly_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_poly_keepGenAway_ILWaiver);
   AssignTextHashWaiver["poly_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_poly_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["polybb_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_polybb_keepGenAway_ILWaiver);
   AssignTextHashWaiver["polybb_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_polybb_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["diffcon_fillerID"] = strcat(dr_default_ILWaiver, tsdr_diffcon_fillerID_ILWaiver);
   AssignTextHashWaiver["diffcon_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_diffcon_keepGenAway_ILWaiver);
   AssignTextHashWaiver["diffcon_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_diffcon_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["polycon_fillerID"] = strcat(dr_default_ILWaiver, tsdr_polycon_fillerID_ILWaiver);
   AssignTextHashWaiver["polycon_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_polycon_keepGenAway_ILWaiver);
   AssignTextHashWaiver["polycon_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_polycon_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["pdiff_fillerID"] = strcat(dr_default_ILWaiver, tsdr_pdiff_fillerID_ILWaiver);
   AssignTextHashWaiver["pdiff_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_pdiff_keepGenAway_ILWaiver);
   AssignTextHashWaiver["pdiff_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_pdiff_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["nwell_fillerID"] = strcat(dr_default_ILWaiver, tsdr_nwell_fillerID_ILWaiver);
   AssignTextHashWaiver["nwell_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_nwell_keepGenAway_ILWaiver);
   AssignTextHashWaiver["nwell_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_nwell_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["viacon_fillerID"] = strcat(dr_default_ILWaiver, tsdr_viacon_fillerID_ILWaiver);
   AssignTextHashWaiver["viacon_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_viacon_keepGenAway_ILWaiver);
   AssignTextHashWaiver["viacon_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_viacon_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal0_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal0_densityid_ILWaiver);
   AssignTextHashWaiver["metal0_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal0_fillerID_ILWaiver);
   AssignTextHashWaiver["metal0_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal0_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal0_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal0_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via0_densityID"] = strcat(dr_default_ILWaiver, tsdr_via0_densityid_ILWaiver);
   AssignTextHashWaiver["via0_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via0_fillerID_ILWaiver);
   AssignTextHashWaiver["via0_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via0_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via0_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via0_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal1_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal1_densityid_ILWaiver);
   AssignTextHashWaiver["metal1_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal1_fillerID_ILWaiver);
   AssignTextHashWaiver["metal1_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal1_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal1_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal1_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via1_densityID"] = strcat(dr_default_ILWaiver, tsdr_via1_densityid_ILWaiver);
   AssignTextHashWaiver["via1_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via1_fillerID_ILWaiver);
   AssignTextHashWaiver["via1_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via1_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via1_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via1_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal2_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal2_densityid_ILWaiver);
   AssignTextHashWaiver["metal2_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal2_fillerID_ILWaiver);
   AssignTextHashWaiver["metal2_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal2_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal2_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal2_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via2_densityID"] = strcat(dr_default_ILWaiver, tsdr_via2_densityid_ILWaiver);
   AssignTextHashWaiver["via2_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via2_fillerID_ILWaiver);
   AssignTextHashWaiver["via2_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via2_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via2_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via2_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal3_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal3_densityid_ILWaiver);
   AssignTextHashWaiver["metal3_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal3_fillerID_ILWaiver);
   AssignTextHashWaiver["metal3_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal3_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal3_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal3_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via3_densityID"] = strcat(dr_default_ILWaiver, tsdr_via3_densityid_ILWaiver);
   AssignTextHashWaiver["via3_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via3_fillerID_ILWaiver);
   AssignTextHashWaiver["via3_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via3_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via3_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via3_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal4_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal4_densityid_ILWaiver);
   AssignTextHashWaiver["metal4_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal4_fillerID_ILWaiver);
   AssignTextHashWaiver["metal4_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal4_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal4_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal4_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via4_densityID"] = strcat(dr_default_ILWaiver, tsdr_via4_densityID_ILWaiver);
   AssignTextHashWaiver["via4_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via4_fillerID_ILWaiver);
   AssignTextHashWaiver["via4_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via4_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via4_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via4_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal5_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal5_densityid_ILWaiver);
   AssignTextHashWaiver["metal5_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal5_fillerID_ILWaiver);
   AssignTextHashWaiver["metal5_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal5_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal5_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal5_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via5_densityID"] = strcat(dr_default_ILWaiver, tsdr_via5_densityID_ILWaiver);
   AssignTextHashWaiver["via5_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via5_fillerID_ILWaiver);
   AssignTextHashWaiver["via5_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via5_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via5_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via5_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal6_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal6_densityid_ILWaiver);
   AssignTextHashWaiver["metal6_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal6_fillerID_ILWaiver);
   AssignTextHashWaiver["metal6_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal6_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal6_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal6_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via6_densityID"] = strcat(dr_default_ILWaiver, tsdr_via6_densityID_ILWaiver);
   AssignTextHashWaiver["via6_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via6_fillerID_ILWaiver);
   AssignTextHashWaiver["via6_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via6_keepGenAway_ILWaiver );
   AssignTextHashWaiver["via6_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via6_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal7_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal7_densityid_ILWaiver);
   AssignTextHashWaiver["metal7_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal7_fillerID_ILWaiver);
   AssignTextHashWaiver["metal7_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal7_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal7_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal7_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via7_densityID"] = strcat(dr_default_ILWaiver, tsdr_via7_densityID_ILWaiver);
   AssignTextHashWaiver["via7_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via7_fillerID_ILWaiver);
   AssignTextHashWaiver["via7_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via7_keepGenAway_ILWaiver );
   AssignTextHashWaiver["via7_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via7_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal8_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal8_densityid_ILWaiver);
   AssignTextHashWaiver["metal8_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal8_fillerID_ILWaiver);
   AssignTextHashWaiver["metal8_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal8_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal8_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal8_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via8_densityID"] = strcat(dr_default_ILWaiver, tsdr_via8_densityID_ILWaiver);
   AssignTextHashWaiver["via8_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via8_fillerID_ILWaiver);
   AssignTextHashWaiver["via8_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via8_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via8_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via8_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal9_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal9_densityid_ILWaiver);
   AssignTextHashWaiver["metal9_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal9_fillerID_ILWaiver);
   AssignTextHashWaiver["metal9_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal9_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal9_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal9_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via9_densityID"] = strcat(dr_default_ILWaiver, tsdr_via9_densityID_ILWaiver);
   AssignTextHashWaiver["via9_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via9_fillerID_ILWaiver);
   AssignTextHashWaiver["via9_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via9_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via9_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via9_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal10_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal10_densityid_ILWaiver);
   AssignTextHashWaiver["metal10_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal10_fillerID_ILWaiver);
   AssignTextHashWaiver["metal10_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal10_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal10_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal10_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via10_densityID"] = strcat(dr_default_ILWaiver, tsdr_via10_densityID_ILWaiver);
   AssignTextHashWaiver["via10_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via10_fillerID_ILWaiver);
   AssignTextHashWaiver["via10_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via10_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via10_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via10_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["metal11_densityID"] = strcat(dr_default_ILWaiver, tsdr_metal11_densityID_ILWaiver);
   AssignTextHashWaiver["metal11_fillerID"] = strcat(dr_default_ILWaiver, tsdr_metal11_fillerID_ILWaiver);
   AssignTextHashWaiver["metal11_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_metal11_keepGenAway_ILWaiver);
   AssignTextHashWaiver["metal11_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_metal11_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["via11_densityID"] = strcat(dr_default_ILWaiver, tsdr_via11_densityID_ILWaiver);
   AssignTextHashWaiver["via11_fillerID"] = strcat(dr_default_ILWaiver, tsdr_via11_fillerID_ILWaiver);
   AssignTextHashWaiver["via11_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_via11_keepGenAway_ILWaiver);
   AssignTextHashWaiver["via11_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_via11_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["CE1_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_CE1_keepGenAway_ILWaiver);

   AssignTextHashWaiver["CE2_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_CE2_keepGenAway_ILWaiver);

   AssignTextHashWaiver["CE3_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_CE3_keepGenAway_ILWaiver);

   AssignTextHashWaiver["tm1_densityID"] = strcat(dr_default_ILWaiver, tsdr_tm1_densityID_ILWaiver);
   AssignTextHashWaiver["tm1_fillerID"] = strcat(dr_default_ILWaiver, tsdr_tm1_fillerID_ILWaiver);
   AssignTextHashWaiver["tm1_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_tm1_keepGenAway_ILWaiver);
   AssignTextHashWaiver["tm1_fillerIgnore"] = strcat(dr_default_ILWaiver, tsdr_tm1_fillerIgnore_ILWaiver);

   AssignTextHashWaiver["c4b_maskDrawing"] = strcat(dr_default_ILWaiver, tsdr_c4b_maskdrawing_ILWaiver);
   AssignTextHashWaiver["c4b_keepGenAway"] = strcat(dr_default_ILWaiver, tsdr_c4b_keepGenAway_ILWaiver);

   AssignTextHashWaiver["c4e_maskDrawing"] = strcat(dr_default_ILWaiver, tsdr_c4e_maskdrawing_ILWaiver);

   AssignTextHashWaiver["c4t_maskDrawing"] = strcat(dr_default_ILWaiver, tsdr_c4t_maskdrawing_ILWaiver);

   AssignTextHashWaiver["fepad_boundary"] = strcat(dr_default_ILWaiver, tsdr_fepad_boundary_ILWaiver);

   AssignTextHashWaiver["bepad_boundary"] = strcat(dr_default_ILWaiver, tsdr_bepad_boundary_ILWaiver);

   AssignTextHashWaiver["empad_boundary"] = strcat(dr_default_ILWaiver, tsdr_empad_boundary_ILWaiver);

   AssignTextHashWaiver["rfpad_boundary"] = strcat(dr_default_ILWaiver, tsdr_rfpad_boundary_ILWaiver);

   AssignTextHashWaiver["slpad_boundary"] = strcat(dr_default_ILWaiver, tsdr_slpad_boundary_ILWaiver);

#endif
   
