// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_IL.rs.rca 1.128 Tue Jan 20 00:03:39 2015 dgthakur Experimental $

//
// $Log: p1273dx_IL.rs.rca $
// 
//  Revision: 1.128 Tue Jan 20 00:03:39 2015 dgthakur
//  Added dot7 changes from Tao Chen (email 1/19/15).
// 
//  Revision: 1.127 Fri Jan 16 10:50:11 2015 dgthakur
//  HSD 2847; Added a dnw tg clamp cells for IL waivers.
// 
//  Revision: 1.126 Thu Jan 15 14:55:43 2015 dgthakur
//  1/4 size tg ehv clamp (aka BXT clamp) IL update (Krishna email 15Jan15).
// 
//  Revision: 1.125 Wed Jan 14 10:57:43 2015 dgthakur
//  pdiff_denID waiver for NTG decap cells Suhas email 14Jan2015.
// 
//  Revision: 1.124 Sat Jan 10 16:20:15 2015 dgthakur
//  HSD 2926; IL waiver for "d04tap02ydz03", "df4tap02ldz03","df4tap02ndz03","df4tap02wdz03", "df4tap02xdz03", "df4tap02ydz03" cells.
// 
//  Revision: 1.123 Thu Jan  8 12:09:39 2015 dgthakur
//  HSD 2847; Support for ESD clamps in DNW (for ICF dot6).
// 
//  Revision: 1.122 Mon Jan  5 17:08:50 2015 dgthakur
//  HSD 2815; diffcon_densityID IL waiver for d8xmtgvargbnd24f336zevm2 cell (ICF ticket).
// 
//  Revision: 1.121 Mon Jan  5 11:32:38 2015 dgthakur
//  HSD 2880; ID_varactorID and PTP_toSynDrawing waivers for new ICF varactor templates.
// 
//  Revision: 1.120 Thu Dec 18 10:27:29 2014 dgthakur
//  HSD 2966; poly_densityID IL waiver for 1/4 size TG EHV clamp (d8xsesdpclamptgp25evm2ns).
// 
//  Revision: 1.119 Tue Dec 16 10:57:23 2014 qfan4
//  Add StmX waiver
// 
//  Revision: 1.118 Wed Dec  3 00:34:58 2014 dgthakur
//  Added waivers for new fuse cells Zhanping email 11/25/14
// 
//  Revision: 1.117 Wed Nov 12 17:26:44 2014 dgthakur
//  Waive metal2_noOPCDFM and metal3_noOPCDFM for fuse cells for DR_PROJECT x73a or x73b (Zhanping email 11/12/14).
// 
//  Revision: 1.116 Sat Nov  8 17:31:46 2014 dgthakur
//  Make TV1SIZEID illegal (except when EMIB is enabled).
// 
//  Revision: 1.115 Thu Nov  6 20:21:06 2014 dgthakur
//  HSD 2867; Added back d8xmtgvargbnd24f336zevm2" and "d8xsvargbnd64f252z2evm2" to ID_VaractorID IL waiver.  was dropped accidentally (would create false flag).
// 
//  Revision: 1.114 Thu Oct 30 11:46:48 2014 dgthakur
//  Added m3fuse_id waivers (Zhanping email 10/29/14 and RDL_prs waiver from Kalyan 10/29/14).
// 
//  Revision: 1.113 Sat Oct  4 19:02:11 2014 dgthakur
//  Fixed bug showing DNW as illegal; added tv1sizeid legal for EMIB.
// 
//  Revision: 1.112 Thu Sep 25 22:09:12 2014 dgthakur
//  HSD 2674; IL waivers for HIP cell c73p1_d8xsrtcnuvm2vtun.
// 
//  Revision: 1.111 Sun Sep  7 22:51:37 2014 dgthakur
//  HSD 2672; Make esd d0 and d7 ID layers legal for 1273.
// 
//  Revision: 1.110 Sun Sep  7 10:21:57 2014 dgthakur
//  hsd 2675; added missing comma.
//  Added IL waivers for 1273.1 PRS (confirmed by Berni email 9/3/14).
// 
//  Revision: 1.109 Thu Aug 14 15:33:59 2014 dgthakur
//  Added some dot7 cells for IL waivers (Tao email 13Oct14).
// 
//  Revision: 1.108 Thu Jul 31 11:28:22 2014 dgthakur
//  Making NU1 and PU1 legal for 1273.3 only.
// 
//  Revision: 1.107 Mon Jul 21 17:34:18 2014 dgthakur
//  hsd 2569; 1273 SCR template IL waivers (based on updated ticket).
// 
//  Revision: 1.106 Sat Jul 19 22:48:50 2014 dgthakur
//  hsd 2569; 1273 SCR template IL waivers.
// 
//  Revision: 1.105 Thu Jul 17 15:28:08 2014 dgthakur
//  Ankita added dot0,7,8 cells based on Tao Chen's request (code reviewed by Dipto).
//
//  Revision: 1.104 Thu Jun 19 10:41:38 2014 dgthakur
//  hsd 2495; IL waivers for the TG hybrid decap cells.
// 
//  Revision: 1.103 Tue Jun 17 18:01:28 2014 dgthakur
//  IL waiver for m3fuse_id for some new m3 fuse cells (see Zhanping email chain 6/17/14).
// 
//  Revision: 1.102 Tue Jun 10 18:04:16 2014 dgthakur
//  hsd 2390; IL flag waivers for new varactor templates (for ICF).
// 
//  Revision: 1.101 Tue Jun 10 11:13:48 2014 qfan4
//  change on arrayId_drawing to merge to single line for Calibre converting script
// 
//  Revision: 1.100 Tue Apr 22 15:34:06 2014 dgthakur
//  hsd 2282; poly_density_ID waiver for d8xsdcpintgevm4_s2s
//  and d8xsdcpintgevm2_s2s
//  hybrid decap device templates.
// 
//  Revision: 1.99 Wed Apr 16 14:49:41 2014 dgthakur
//  hsd 2282; IL ndr.mg and pdr.tg waiver for new hybrid NTG decap templates.
//  hsd 2236; IL ndr.tg and pdr.mg waiver for custom MFC.
// 
//  Revision: 1.98 Sun Mar 23 01:38:50 2014 dgthakur
//  hsd 2189; IL waiver for dot4 ultra low cap ESD; made rdl_calntilevel IL.
// 
//  Revision: 1.97 Mon Mar 17 22:42:55 2014 dgthakur
//  hsd 2027; IL waivers for HDC WL strap cells.
// 
//  Revision: 1.96 Fri Mar 14 10:15:53 2014 kperrey
//  changed how the RFREQ_devType is handled in dot7
// 
//  Revision: 1.95 Thu Mar 13 09:27:04 2014 kperrey
//  add support for dot7 isDOTXLegal and add RFREQ_devType
// 
//  Revision: 1.94 Wed Feb 12 14:29:35 2014 dgthakur
//  Preliminary support for 1273.0 and 1273.8 making xll,uv1,mim illegal as needed by dot.
// 
//  Revision: 1.93 Wed Feb  5 00:54:35 2014 dgthakur
//  hsd 2027; ogd/pgd centerline id and arrayid waiver for 1273 WL strap cells (APD compiler team request).
// 
//  Revision: 1.92 Mon Jan 27 12:08:14 2014 dgthakur
//  hsd 2025; dr_NSD_toSynDrawing_IL wiaver for d8xmvargbnd64f252z2evm2.
// 
//  Revision: 1.91 Thu Jan 23 09:40:12 2014 dgthakur
//  hsd 2048; il_polycon_densityid waiver for cell d8xsesdpclamptgp5uvm2core.
// 
//  Revision: 1.90 Wed Jan 22 00:56:20 2014 dgthakur
//  hsd 2048; il_polycon_densityid waiver for cell d8xsesdpclamptgp5evm2core.
// 
//  Revision: 1.89 Fri Dec 13 15:34:31 2013 dgthakur
//  diffcon_resDrawing_ILWaiver waiver for d8xsrtcnevm2abod_base and d8xsrtcnevm2acon_base via9_densityID waiver for d81sindmtm1m9l1p6n.
// 
//  Revision: 1.88 Thu Dec 12 13:31:14 2013 dgthakur
//  removed extra #endif.
// 
//  Revision: 1.87 Thu Dec 12 11:44:47 2013 dgthakur
//  updated v9 den id waiver for x73b prs cell (dot1).
// 
//  Revision: 1.86 Wed Dec 11 11:48:06 2013 dgthakur
//  Added IL waivers for d8xsrtcnevm2abod_base and d81sindmtm1m9l1p1n.
// 
//  Revision: 1.85 Thu Dec  5 17:43:15 2013 dgthakur
//  IL waivers for 1273.1 _cc prs cells related to CC.
// 
//  Revision: 1.84 Thu Dec  5 13:55:26 2013 dgthakur
//  Adding the 1273.1 x73b _cc version of the prs cell IL waivers.
// 
//  Revision: 1.83 Mon Dec  2 14:27:59 2013 dgthakur
//  IL waiver for nsd/psd tosyn for CPR resistors (Suhas email 27Nov2013).
// 
//  Revision: 1.82 Mon Dec  2 10:04:06 2013 dgthakur
//  TG ULV hybrid decaps are not supported anymore (d8xsdcpiptgulvm4 and d8xsdcpintgulvm4)  Email from Suhas 8Nov2013.
// 
//  Revision: 1.81 Wed Nov 20 11:21:18 2013 kperrey
//  added dr_tm1_inductorID_ILWaiver for ind2t_scl_* the ICF scaleable inductor
// 
//  Revision: 1.80 Mon Nov 11 17:08:16 2013 dgthakur
//  hsd 1956; ) d86sesddnuvtermulc_blank d86sesddpuvtermulc_blank IL waiver.
// 
//  Revision: 1.79 Fri Oct 18 13:55:11 2013 dgthakur
//  IL waivers for m3fuseID (email from Zhanping 18Oct13) and other template cell IL waivers (email from Suhas 17Oct13).
// 
//  Revision: 1.78 Thu Oct 17 01:24:12 2013 dgthakur
//  HSD 1860;  dr_global_inductorid1_ILWaiver for d81shipindmtm1m9l1p1n 1273.1 inductor.
// 
//  Revision: 1.77 Thu Oct 17 01:06:34 2013 dgthakur
//  HSD 1878; ndr/pdr IL waiver for TG ULV decap cells (d8lib6)
// 
//  Revision: 1.76 Wed Oct 16 01:09:48 2013 dgthakur
//  hsd 1896; Added global_inductorid1_ILWaiver for 1273.1 HIP inductors "d81shipindmtm1l0p5n", "d81shipindmtm1m9l0p9n".
// 
//  Revision: 1.75 Tue Oct 15 00:12:26 2013 dgthakur
//  Added IL waiver for x73lvcbitvccgaplp for OGD/PGD CL.
//  email from Eric Karl 9Oct2013
// 
//  Revision: 1.74 Mon Oct 14 23:25:59 2013 dgthakur
//  Make EMIB bumps illegal for 1273 dots (except for dot2).  Make CE1/2 and NV1/PV1 illegal for RVN project.
// 
//  Revision: 1.73 Fri Sep 13 14:56:54 2013 dgthakur
//  hsd 1879; Added waiver for m3fuseID for fuse cells for x73b project
// 
//  Revision: 1.72 Wed Sep 11 23:25:12 2013 dgthakur
//  hsd 1882; enabling FTI_id and FTI.mg when DR_ENABLE_FTI is set to YES (Note. FTI is experimental and not POR).
// 
//  Revision: 1.71 Thu Sep  5 14:18:52 2013 kperrey
//  hsd 1866 ; support ICF scaleable inductor ind2t_scl_*; metal12_inductorID
// 
//  Revision: 1.70 Wed Aug 28 16:06:18 2013 dgthakur
//  IL waivers for ndiff/pdiff den ID for x73 fuse cell (needed for s73a).
// 
//  Revision: 1.69 Mon Aug 26 17:12:57 2013 dgthakur
//  Added ID_prs waiver for all dot prs cells.  Added support for dot1 prs cells.
// 
//  Revision: 1.68 Sat Jul 20 07:29:03 2013 dgthakur
//  IL waiver for metal12_resdrawing for 1273.6 EDM (confirmed with Berni email 19Jul13).
// 
//  Revision: 1.67 Fri Jul 19 16:51:46 2013 dgthakur
//  hsd 1703; IL waivers for 1273.6 prs cells.  iffusion_reservedPurpose10_IL waiver "d04tap02xdz03 tap cell (Sudeesh email 19Jul13).
// 
//  Revision: 1.66 Thu Jul 18 00:24:30 2013 dgthakur
//  hsd 1801; added d84shipindmtm1m9l1p1n in the dr_global_inductorid1_ILWaiver.
// 
//  Revision: 1.65 Tue Jun 18 16:42:34 2013 dgthakur
//  1273 IL waivers for fuse cell (Zhanping email 18Jun2013).
// 
//  Revision: 1.64 Mon Jun 10 00:10:46 2013 dgthakur
//  hsd 1586; add tap cell waivers for diffusion_reservedPurpose10.
// 
//  Revision: 1.63 Fri Jun  7 15:16:49 2013 dgthakur
//  Added IL waivers for NDR/PDRTG and NDRTG/PDR based on cell list from email from Alex 6Jun2013.
// 
//  Revision: 1.62 Fri May 24 00:39:50 2013 dgthakur
//  added dot 1 branching (same as dot4).
// 
//  Revision: 1.61 Fri Apr 19 16:08:41 2013 kperrey
//  make deepnwell_maskDrawing for dot6
// 
//  Revision: 1.60 Tue Apr 16 11:19:14 2013 nhkhan1
//  *** empty comment string ***
// 
//  Revision: 1.59 Mon Apr 15 17:22:49 2013 nhkhan1
//  added waivers for SDC layers in the catch cup GR area
// 
//  Revision: 1.58 Thu Mar 28 14:12:52 2013 dgthakur
//  Making m12 and v12 legal for 1273.6.
// 
//  Revision: 1.57 Mon Mar 18 16:52:07 2013 dgthakur
//  hsd 1531; IL layer waiver for vtun macro template cells.
// 
//  Revision: 1.56 Fri Mar 15 17:38:29 2013 dgthakur
//  Waiver for d8xmvargbnd64f252z2evm2 varactor cell for VarID, NES.to, PTP.to and WellresID.  Waiver for d84sindmtm1m9l0p4n for v9 denID.
//  Sugan email 15Mar2013
// 
//  Revision: 1.55 Thu Mar 14 11:19:19 2013 dgthakur
//  added waiver for FTI.mg for x73b specific cells.
// 
//  Revision: 1.54 Wed Mar 13 15:04:26 2013 nhkhan1
//  added LMIPAD_maskDrawing in the legal layer for TSV
// 
//  Revision: 1.53 Mon Mar 11 16:22:57 2013 oakin
//  extended the polydensity waiver for x73tgary (to x73b).
// 
//  Revision: 1.52 Thu Mar  7 15:21:36 2013 oakin
//  added inductor waiver for x73b.
// 
//  Revision: 1.51 Fri Feb 15 13:24:26 2013 dgthakur
//  Adding DMG/NES/TNT.tosyn IL waivers for the cpr template cells (email from Suhas 15Feb13).
// 
//  Revision: 1.50 Thu Feb 14 11:42:52 2013 oakin
//  added waivers for bgdiode.
// 
//  Revision: 1.49 Wed Feb 13 14:29:30 2013 dgthakur
//  Waiving DMG, PV3, PVL, XVP for antifuse cells (email from Zhanping 13Feb13).
// 
//  Revision: 1.48 Mon Feb 11 16:33:02 2013 nhkhan1
//  added production cell names for TSV waivers
//  added TSV-related legal layers i.e. TSV_maskDrawing, RDL_maskDrawing, RDL_CAPID, RDL_padBUMPID, and RDL_CantiLever.
// 
//  Revision: 1.47 Fri Feb  1 14:57:29 2013 oakin
//  added waivers for new x73b bitcells.
// 
//  Revision: 1.46 Tue Jan 29 14:18:13 2013 nhkhan1
//  added x73 TSV Catch-cup and etch-ring waivers
// 
//  Revision: 1.45 Mon Jan 21 11:24:08 2013 dgthakur
//  Updated IL waivers for fuse cells (for x73b project only).
// 
//  Revision: 1.44 Fri Jan 18 12:51:14 2013 sstalukd
//  Added TSV related IL waivers: via0/via1/viacon_densityID,tsvcc_drawing1, metal0/1/2_plug - based on request from Kalyan (1/18/2013)
// 
//  Revision: 1.43 Tue Dec 18 16:29:36 2012 tmurata
//  update to finalize the ccgr dummy gate treatment.
// 
//  Revision: 1.42 Thu Dec 13 21:27:18 2012 dgthakur
//  hsd 1455; M10/M11/V10/V11 made legal for dot6.  ULP made illgal for for dot6.  Added dot5 legal layers such as NV3/PV3.
// 
//  Revision: 1.41 Thu Dec 13 17:40:46 2012 tmurata
//  added the certain ccgr cells in the dr_chkBoundary_reservedPurpose4_ILWaiver.
// 
//  Revision: 1.40 Thu Dec 13 16:56:21 2012 sstalukd
//  STTRAM density related waivers - STTRAMID1/2, MTJID, MTJDRAWN, MJ0DRAWN are legal layers
//  Cell based waivers for Metal2/Via1 densityID
// 
//  Revision: 1.39 Thu Dec  6 14:15:48 2012 oakin
//  removed the previous cell additions (it is 1272 not 1273).
// 
//  Revision: 1.38 Thu Dec  6 14:11:58 2012 oakin
//  added cells to the BM_WAIVER list.
// 
//  Revision: 1.37 Mon Dec  3 11:55:18 2012 dgthakur
//  Removing tab/space from cell name.
// 
//  Revision: 1.36 Thu Nov 29 23:33:46 2012 dgthakur
//  hsd 1431; add ICF decap and inductor cells.
//  Added anti-fuse and m3jog fuse cells.
// 
//  Revision: 1.35 Fri Oct 19 09:00:57 2012 kperrey
//  make NAL/PAL illegal for all 1273
// 
//  Revision: 1.34 Mon Oct 15 09:13:55 2012 oakin
//  added back the HVID to illegal layer.
// 
//  Revision: 1.33 Mon Oct  1 15:45:08 2012 oakin
//  added waiver for x73b bitcells.
// 
//  Revision: 1.32 Wed Sep 19 11:28:38 2012 dgthakur
//  hsd 622218; Making HVID ID_reservedPurpose5 legal for 1273.
// 
//  Revision: 1.31 Fri Aug 24 11:18:24 2012 dgthakur
//  hsd 1337, ER_LOCK_ID usage in the following TCN resistor template cells.
// 
//  Revision: 1.30 Thu Aug  9 10:47:56 2012 oakin
//  clamp cell is now a project owned list. And no check is needed for diode id's (Steeven Poon).
// 
//  Revision: 1.29 Fri May 18 10:47:41 2012 dgthakur
//  Added IL waiver for il_diffcon_resdrawing for cell d8xsrtcnuvm2vtun_base (C. Wawro email 5/18/12).
// 
//  Revision: 1.28 Fri May 18 01:13:15 2012 dgthakur
//  hsd 1228; IL waivers for cpr template (C. Wawro).
// 
//  Revision: 1.27 Tue May 15 10:39:35 2012 dgthakur
//  hsd 1227; IL_asym_keepGenAway waiver for prs cells, hsd 1226 il_id_reservedpurpose1 and il_chkboundary_reservedpurpose10 waivers for d8xxesdpclampxllgatedevm2 & d8xxesdpclampxllp5gatedevm2.
// 
//  Revision: 1.26 Tue May  8 11:04:25 2012 oakin
//  added metal1_BCregionID and metalc1_complement waivers for the fuse.
// 
//  Revision: 1.25 Tue May  8 08:49:47 2012 oakin
//  added waivers for x73a.
// 
//  Revision: 1.24 Thu May  3 15:24:52 2012 oakin
//  added via9 density waiver for d84sindmtm1m9l0p4n for x73a only.
// 
//  Revision: 1.23 Thu Apr 26 15:48:06 2012 oakin
//  added prs cell density waiver (per Berni L.).
// 
//  Revision: 1.22 Wed Apr 25 09:26:52 2012 oakin
//  added waiver for diffusion_reservedPurpose10 (BM_WAIVER).
// 
//  Revision: 1.21 Mon Apr 23 10:13:24 2012 oakin
//  added waivers for bitcells.
// 
//  Revision: 1.20 Fri Apr 20 17:29:35 2012 dgthakur
//  arrayId_highDensity is illegal for 1273.
// 
//  Revision: 1.19 Tue Apr 17 11:56:11 2012 kperrey
//  stuff for dipto for some unique cases 1273 IL
// 
//  Revision: 1.18 Tue Apr 17 09:39:22 2012 dgthakur
//  Added M2-5CID allowed for 1273 (Wee-Soon email 15Apr12).
// 
//  Revision: 1.17 Tue Apr 17 09:09:26 2012 oakin
//  moved to dr_cell_list as this is list is also needed for AN_72 check.
// 
//  Revision: 1.16 Fri Apr 13 11:53:16 2012 dgthakur
//  hsd 1204; x73a/d8 template IL waivers.
// 
//  Revision: 1.15 Wed Apr 11 11:38:14 2012 dgthakur
//  hsd 621650; 1273 d8lib template cell IL waivers (see HSD for details).
// 
//  Revision: 1.14 Wed Apr  4 13:54:58 2012 dgthakur
//  Corrected typo in IL waivers for ESD D1/2/3/4 diode ids.  These are legal in design.
// 
//  Revision: 1.13 Tue Apr  3 20:22:52 2012 oakin
//  removed HD_SRAM_ID (82,63) fromwaivers, it is an illegal layer for 1273.
// 
//  Revision: 1.12 Wed Mar 28 11:13:02 2012 dgthakur
//  hsd 1178; il_nwellesd_gbnwid   waived for cells  d8xsesdclampres & d8xsesdclamprestg
//  il_diodeid_esddiodeid and il_nwell_esddiodeid waivers for cells d8xsesddpuvterm and d8xsesddnuvterm
// 
//  Revision: 1.11 Tue Feb 28 10:44:50 2012 dgthakur
//  hsd 621351; drc_IL waiver request for the TCN resistors to suppress the error IL_diffcon_resDrawing.
// 
//  Revision: 1.10 Wed Feb 22 13:26:38 2012 kperrey
//  if _drTSDR include the p1273dx_TSDRIL.rs
// 
//  Revision: 1.9 Thu Feb 16 11:22:59 2012 dgthakur
//  hsd 621351; support for IL waivers for esd clamps, bg and thermal diodes.
// 
//  Revision: 1.8 Fri Feb  3 13:19:51 2012 dgthakur
//  hsd 1117; Added IL waivers for d8xsrcprtguvm2a_base and d8xsrcprtguvm2b_base cells.
// 
//  Revision: 1.7 Thu Jan 19 14:09:51 2012 dgthakur
//  Added d8xsesdpclamptgp5evm2core for IL waiver for ndiff_denID and poly_denID.
// 
//  Revision: 1.6 Mon Jan 16 13:23:34 2012 kperrey
//  hsd 621170 ; add metal0_backBone metalc0_complement metalc4_maskDrawing metalc5_maskDrawing chkboundary_reservedpurpose4 chkboundary_reservedpurpose3 chkboundary_reservedpurpose2 chkboundary_reservedpurpose1/ M0BID M0CID METALC4DRAWN METALC5DRAWN ESD_D4_ID4 ESD_D3_ID3 ESD_D2_ID2 ESD_D1_ID1
// 
//  Revision: 1.5 Fri Jan 13 15:49:23 2012 dgthakur
//  Fixed syntax error for #if.
// 
//  Revision: 1.4 Tue Jan  3 13:05:27 2012 kperrey
//  moved TSDR specific to p1273dx_TSDRIL.rs
// 
//  Revision: 1.3 Fri Dec  9 11:06:04 2011 kperrey
//  add sample and comment for handling isLegal
// 
//  Revision: 1.2 Thu Dec  8 23:56:12 2011 dgthakur
//  added 1273 template cells.
// 
//  Revision: 1.1 Thu Dec  8 22:52:26 2011 kperrey
//  1273 specific IL waivers and list definitions
// 
//  Revision: 1.44 Thu Dec  1 14:49:08 2011 dgthakur
//  update to previous checkin.
// 
//  Revision: 1.43 Thu Dec  1 10:48:37 2011 dgthakur
//  Added waivers for 1273 CPR templates.
// 
//  Revision: 1.42 Tue Nov 29 11:25:28 2011 kperrey
//  hsd 1040; added cells to dr_chkBoundary_reservedPurpose10_ILWaiver (ESD_CLAMP_ID10) for IL checks
// 
//  Revision: 1.41 Wed Nov 16 08:33:39 2011 kperrey
//  added cells as per nings email for waivers
// 
//  Revision: 1.40 Tue Nov 15 16:21:52 2011 oakin
//  bandgapdiode waivers.
// 
//  Revision: 1.39 Mon Oct 24 15:44:30 2011 kperrey
//  use TSDRFlagTG.contains_key(key) to control whether TSDR run generates TG or TC violation
// 
//  Revision: 1.38 Fri Oct  7 17:10:04 2011 kperrey
//  added the tsdr inclusion of tsdr_IL_defines ; for ning
// 
//  Revision: 1.37 Wed Oct  5 14:54:22 2011 oakin
//  added density via11/tm1 waive for c82mindm11l0p8n and c82mindm11l0p6n.
// 
//  Revision: 1.36 Wed Sep  7 15:41:58 2011 kperrey
//  hsd 620688 ;modified dr_diffcon_resDrawing_ILWaiver list of cells as per tripti
// 
//  Revision: 1.35 Wed Aug 24 11:44:21 2011 oakin
//  added waivers for bitcell (hdc) and etchring.
// 
//  Revision: 1.34 Fri Jul  8 15:33:11 2011 kperrey
//  hsd 903 ; added d8xsesddnuvm1, d8xsesddpuvm1, d8xsesddnuvm1_topbot, d8xsesddpuvm1_topbot to dr_diodeid_esddiodeid_ILWaiver
// 
//  Revision: 1.33 Fri Jun 24 16:00:53 2011 oakin
//  changed the layer names for V1 and V2pitchid's.
// 
//  Revision: 1.32 Fri Jun 24 13:51:16 2011 oakin
//  added waiver for c8xmvargbnd15f252zevm2_unit  (Umesh/Jamie).
// 
//  Revision: 1.31 Tue May 10 16:42:52 2011 oakin
//  polytd/tg/ulp pitchid is allowed in 1273 and 12723 dot zero but not in dot two and four.
// 
//  Revision: 1.30 Tue Mar 15 16:11:36 2011 oakin
//  added ptp_tosyndrawing waiver for c8xlvargbnd15f360zevm2_unit_1 and c8xlvargbnd15f360zevm2_unit (Mohammed/Nidhi).
// 
//  Revision: 1.29 Thu Mar  3 16:43:55 2011 oakin
//  added c8xlvargbnd60f360zevm2 and c8xlindm11l0p8n to IL lists and tnd one tp empcells list.
// 
//  Revision: 1.28 Tue Mar  1 17:50:39 2011 oakin
//  added varactor cell waivers for wellresID.
// 
//  Revision: 1.27 Mon Feb 28 09:42:47 2011 kperrey
//  remove tp0Fill_list/dr_denID_Waiver since not used; add ILWaivers for fillerID;densityID;keepGenAway; added hook so TSDR can limit c4b_maskDrawing placement
// 
//  Revision: 1.26 Fri Feb 18 15:52:36 2011 kperrey
//  add hooks so some defined layers can be excluded during TSDR checks ; to exclude layers add them to tsdr_IL_waive
// 
//  Revision: 1.25 Thu Feb 17 14:05:40 2011 oakin
//  added cell names to dr_diodeid_esddiodeid_ILWaiver list (ticket 768).
// 
//  Revision: 1.24 Fri Feb 11 17:14:54 2011 oakin
//  added waivers for densityid;s (got the list from Scot).
// 
//  Revision: 1.23 Fri Feb  4 16:06:47 2011 kperrey
//  change waiver list mechanism - all the same now
// 
//  Revision: 1.22 Fri Feb  4 13:50:34 2011 kperrey
//  handle waivers for polycon_resDrawing usage
// 
//  Revision: 1.21 Wed Feb  2 17:36:10 2011 oakin
//  added waivers for c8xlbgdiodehvm1 (per Moonsoo).
// 
//  Revision: 1.20 Thu Jan 27 19:13:50 2011 kperrey
//  handle file name change p12723_lhash to p12723_lhashIL
// 
//  Revision: 1.19 Thu Jan 27 13:48:55 2011 kperrey
//  added support for template that use wellResId_resDrawing
// 
//  Revision: 1.18 Wed Jan 12 11:25:43 2011 kperrey
//  create/use AssignTextHashWaiver[key] which is the waiver list of cells
// 
//  Revision: 1.17 Wed Jan 12 09:58:37 2011 kperrey
//  recoded to use foreach for the catchall case - will revalidate layer usage
// 
//  Revision: 1.16 Wed Dec 29 20:36:40 2010 kperrey
//  change 2;40 and 81;138 names LLGID/LLGTR ; add CTP/STD,TARG1-3
// 
//  Revision: 1.15 Tue Dec 21 15:50:59 2010 kperrey
//  picked up added layers since gmf 507 ; g?pitchID ; phantom ; UTpitchID ; TRTTOUT; NV1/NV2/PV1/PV2 ; metalc11 ; CTP
// 
//  Revision: 1.14 Mon Dec 20 07:52:14 2010 kperrey
//  fix caps on mte/mbe layername
// 
//  Revision: 1.13 Sun Dec 19 14:24:53 2010 kperrey
//  cleaned up comments - added denID checks
// 
//  Revision: 1.12 Fri Dec 17 19:03:54 2010 kperrey
//  moved and changed comments to reflect 226-230 -> moved to 111-115
// 
//  Revision: 1.11 Thu Dec 16 16:08:28 2010 oakin
//  removed metalc3, via9/10, metal9/10 from illegal layer list.
// 
//  Revision: 1.10 Thu Dec  9 09:29:18 2010 oakin
//  added analog poly id to the IL list.
// 
//  Revision: 1.9 Fri Oct 15 15:05:49 2010 kperrey
//  updated b8/c8 names to latest spec from S Zickel
// 
//  Revision: 1.8 Fri Oct  8 20:53:36 2010 kperrey
//  fix drCopyExcludeCell call for DVN_maskDrawing
// 
//  Revision: 1.7 Fri Oct  8 19:41:50 2010 kperrey
//  add as illegal the new layers in the gmf file ; datatype cd[12] option[1-3] tsdrRegion tsdr2sdr g[1-5]pitchID dic;framOnly
// 
//  Revision: 1.6 Mon Sep 20 16:11:27 2010 kperrey
//  v0/mh/vh namechange vc/m0/v0
// 
//  Revision: 1.5 Tue Aug  3 16:39:17 2010 kperrey
//  change generice hv_waive to devhv_waive, or metalhv_waive and made a cell_level selection
// 
//  Revision: 1.4 Fri Jul 30 15:13:03 2010 kperrey
//  fix some cut/paste errors fillerID should be chrome in a couple of places
// 
//  Revision: 1.3 Fri Jul 23 13:19:07 2010 kperrey
//  change error format *IL_layer: from *IL: ; add viah/cob/via4e layers
// 
//  Revision: 1.2 Thu Jul 22 14:08:00 2010 kperrey
//  handle p1272 to p12723 name reference
// 
//  Revision: 1.1 Thu Jul 22 13:10:55 2010 kperrey
//  mvfile on Thu Jul 22 13:10:55 2010 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p1272_IL.rs;1.2
// 
//  Revision: 1.2 Wed Jun  2 13:27:39 2010 kperrey
//  moved metalx_complement to metalcx_complement - added metalc layers - added metalx_backBone as needed - removed keepout/zone - add METH/FTR123/POLYBB/TCNBB/CD123/FIN/HSI layers
// 
//  Revision: 1.1 Tue May 25 15:04:07 2010 kperrey
//  from p1271
// 
// 
//  converted the 1271 IL layer checks
// 


#ifndef _P1273DX_IL_RS_
#define _P1273DX_IL_RS_
   
   //EDRAM waiver to be applied for EDRAM related layers (from Eric Wang)
   dr_edram_waiver: list of string =  strcat(dr_default_ILWaiver, edram_bitcells);   

   //etcring waiver
   dr_er_waiver: list of string =  strcat(dr_default_ILWaiver, etchring_cells);  

   // list of template cells with wellResId_resDrawing - needed for IL checks
   dr_wellresID_ILWaiver : list of string = {
      "c8xmesdclampres", "c8xlvargbnd15f360zevm2_unit_1", "c8xlvargbnd15f360zevm2_unit", 
      "c8xlvargbnd60f360zevm2", "c8xmvargbnd15f252zevm2_unit",
      "d8xsesdclampres", "d8xsesdclamprestg","d8xmvargbnd60f252zevm2","d8xmvargbnd16f252z2evm2_unit","d8xsvargbnd64f252z2evm2",
      "d8xsesdclampdnwres" //HSD 2847
   };
 dr_wellresID7 : list of string = {
      "d87sesdclampres", "d87sesdclamprestg","d87mvargbnd60f252zevm2","d87mvargbnd16f252z2evm2_unit",
 "d87svargbnd64f252z2evm2"  };

 dr_wellresID8 : list of string = {
      "d88sesdclampres", "d88sesdclamprestg","d88mvargbnd60f252zevm2","d88mvargbnd16f252z2evm2_unit",
  "d88svargbnd64f252z2evm2" };
dr_wellresID0 : list of string = {
      "d80sesdclampres", "d80sesdclamprestg","d80mvargbnd60f252zevm2","d80mvargbnd16f252z2evm2_unit",
 "d80svargbnd64f252z2evm2"  };

dr_wellresID_ILWaiver=strcat ( dr_wellresID_ILWaiver,dr_wellresID7);
dr_wellresID_ILWaiver=strcat ( dr_wellresID_ILWaiver,dr_wellresID8);
dr_wellresID_ILWaiver=strcat ( dr_wellresID_ILWaiver,dr_wellresID0);
   dr_pcresID_ILWaiver : list of string = {
      "c8xlrgcn4legparcon_base", 
      "c8xlrgcn4legserconright_base", 
      "c8xlrgcn4legserconleft_base", 
      "c8xlrgcn4legsinconleft_base", 
      "c8xlrgcn4leg", 
      "c8xlrgcn4legdac_base"
   };



   dr_metal12_resDrawing_ILWaiver: list of string = {
     "d86ltoedm1273m9rd", "d86ltoedm1273pgdm9rd"  //These are cells in 1273.6 EDM  Berni email 19Jul13
   };


   dr_diffcon_resDrawing_ILWaiver: list of string = {
       "c8xmrtcnevm2abod_01", "c8xmrtcnevm2abod_02",  "c8xmrtcnevm2abod_03",
       "c8xmrtcnevm2dacturncon_base", "c8xmrtcnevm2dac_base", "c8xmrtcnevm2daccontop_base", 
       "c8xmrtcnevm2dacturn", "c8xmrtcnevm2dacconbot_base", "c8xmrtcnevm2acon_base",  
       "c8xmrtcnevm2vtunbodtop", "c8xmrtcnevm2vtunmidfh", "c8xmrtcnevm2vtunconbot_base", 
       "c8xmrtcnevm2vtunbodbot", "c8xmrtcnevm2vtunmid", "c8xmrtcnevm2vtunturntop", 
       "c8xmrtcnevm2vtuncontop_base", "c8xmrtcnevm2vtunturnbot",
       "d8xxrtcnevm2abod_base",
       "d8xxrtcnevm2acon_base",
       "d8xxrtcnevm2dac_base",
       "d8xxrtcnevm2dacconbot_base",
       "d8xxrtcnevm2daccontop_base",
       "d8xxrtcnevm2dacturn",
       "d8xxrtcnevm2dacturncon_base",
       "d8xxrtcnevm2vtunbodbot",
       "d8xxrtcnevm2vtunbodtop",
       "d8xxrtcnevm2vtunconbot_base",
       "d8xxrtcnevm2vtuncontop_base",
       "d8xxrtcnevm2vtunmid",
       "d8xxrtcnevm2vtunmidfh",
       "d8xxrtcnevm2vtunturnbot",
       "d8xxrtcnevm2vtunturntop",
	   "d8xsrtcnuvm2vtun_base",
	   "c73p1_d8xsrtcnuvm2vtun_base",  //HSD 2674
	   "d8xxrtcnevm2vtuncross",
	   "d8xsrtcnevm2dacturncon_base",
	   "d8xsrtcnevm2dac_base",
	   "d8xsrtcnevm2dacconbot_base",
	   "d8xsrtcnevm2dacturn",
	   "d8xsrtcnevm2daccontop_base",
	   "c73pxecfio_tcnres_200",
       "c73pxecfio_tcnres_302",
       "c73pxecfio_tcnres_5000",
	   "d8xsrtcnevm2abod_base",     //Suhas email 11Dec2013
       "d8xsrtcnevm2acon_base",      //Suhas email 13Dec2013
       "d8xsrtcnuvm2p5vtun_base"     //Suhas HSD 2075
   };

dr_diffcon_resDrawing7: list of string = {
       "d87xrtcnevm2abod_base",
       "d87xrtcnevm2acon_base",
       "d87xrtcnevm2dac_base",
       "d87xrtcnevm2dacconbot_base",
       "d87xrtcnevm2daccontop_base",
       "d87xrtcnevm2dacturn",
       "d87xrtcnevm2dacturncon_base",
       "d87xrtcnevm2vtunbodbot",
       "d87xrtcnevm2vtunbodtop",
       "d87xrtcnevm2vtunconbot_base",
       "d87xrtcnevm2vtuncontop_base",
       "d87xrtcnevm2vtunmid",
       "d87xrtcnevm2vtunmidfh",
       "d87xrtcnevm2vtunturnbot",
       "d87xrtcnevm2vtunturntop",
       "d87srtcnuvm2vtun_base",
       "d87xrtcnevm2vtuncross",
       "d87xsrtcnevm2dacturncon_base",
       "d87srtcnevm2dac_base",
       "d87srtcnevm2dacconbot_base",
       "d87srtcnevm2dacturn",
       "d87srtcnevm2daccontop_base",
       "d87srtcnevm2abod_base",
       "d87srtcnevm2acon_base",
       "d87srtcnuvm2p5vtun_base"
   };
dr_diffcon_resDrawing8: list of string = {
   };

dr_diffcon_resDrawing0: list of string = {
       "d80xrtcnevm2abod_base",
       "d80xrtcnevm2acon_base",
       "d80xrtcnevm2dac_base",
       "d80xrtcnevm2dacconbot_base",
       "d80xrtcnevm2daccontop_base",
       "d80xrtcnevm2dacturn",
       "d80xrtcnevm2dacturncon_base",
       "d80xrtcnevm2vtunbodbot",
       "d80xrtcnevm2vtunbodtop",
       "d80xrtcnevm2vtunconbot_base",
       "d80xrtcnevm2vtuncontop_base",
       "d80xrtcnevm2vtunmid",
       "d80xrtcnevm2vtunmidfh",
       "d80xrtcnevm2vtunturnbot",
       "d80xrtcnevm2vtunturntop",
       "d80srtcnuvm2vtun_base",
       "d80xrtcnevm2vtuncross",
       "d80xsrtcnevm2dacturncon_base",
       "d80srtcnevm2dac_base",
       "d80srtcnevm2dacconbot_base",
       "d80srtcnevm2dacturn",
       "d80srtcnevm2daccontop_base",
       "d80srtcnevm2abod_base",
       "d80srtcnevm2acon_base",
       "d80srtcnuvm2p5vtun_base"	
   };
dr_diffcon_resDrawing_ILWaiver=strcat(dr_diffcon_resDrawing_ILWaiver,dr_diffcon_resDrawing7);
dr_diffcon_resDrawing_ILWaiver=strcat(dr_diffcon_resDrawing_ILWaiver,dr_diffcon_resDrawing8);
dr_diffcon_resDrawing_ILWaiver=strcat(dr_diffcon_resDrawing_ILWaiver,dr_diffcon_resDrawing0);


dr_esd_d8_id_ILWaiver: list of string =  { 
  "d8xsesdscruvm6stktgn", "d87sesdscruvm6stktgn", "d87sesdscruvm6stktgn_dnw",
  "d8xsesdscrsecuvm6stktgn", "d87sesdscrsecuvm6stktgn", "d87sesdscrsecuvm6stktgn_dnw",
  "d8xsesdscrevm6djp3", "d87sesdscrevm6djp3", "d87sesdscrevm6djp3_dnw"
};

dr_esd_d9_id_ILWaiver: list of string =  { 
  "d8xsesdscrsecevm6djp3", "d87sesdscrsecevm6djp3", "d87sesdscrsecevm6djp3_dnw",
  "d8xsesdscrsecuvm6stktgn", "d87sesdscrsecuvm6stktgn", "d87sesdscrsecuvm6stktgn_dnw"
};

dr_DMG_toSynDrawing_ILWaiver: list of string =  { "d8xsrcprtguvm2a_base","d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base"};

dr_DMG7: list of string =  { "d87srcprtguvm2a_base","d87srcprtguvm2b_base","d87srcprtguvm2c_base"};
dr_DMG8 :list of string=   { "d88srcprtguvm2a_base","d88srcprtguvm2b_base","d88srcprtguvm2c_base"};
dr_DMG0 :list of string=   { "d80srcprtguvm2a_base","d80srcprtguvm2b_base","d80srcprtguvm2c_base"};


dr_DMG_toSynDrawing_ILWaiver = strcat(dr_DMG_toSynDrawing_ILWaiver, dr_DMG7);
dr_DMG_toSynDrawing_ILWaiver = strcat(dr_DMG_toSynDrawing_ILWaiver, dr_DMG8);
dr_DMG_toSynDrawing_ILWaiver = strcat(dr_DMG_toSynDrawing_ILWaiver, dr_DMG0);

 dr_NSD_toSynDrawing_ILWaiver: list of string =   { "d8xsrcprtguvm2a_base","d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base","d8xmvargbnd64f252z2evm2","d8xmtgvargbnd24f336zevm2","d8xsvargbnd64f252z2evm2"};
  dr_NSD7: list of string =   { "d87srcprtguvm2a_base","d87srcprtguvm2b_base","d87srcprtguvm2c_base",
     "d87mvargbnd64f252z2evm2","d87mtgvargbnd24f336zevm2","d87svargbnd64f252z2evm2"};
 dr_NSD8: list of string =   { "d88srcprtguvm2a_base","d88srcprtguvm2b_base","d88srcprtguvm2c_base",
     "d88mvargbnd64f252z2evm2","d88mtgvargbnd24f336zevm2","d88svargbnd64f252z2evm2"};
dr_NSD0: list of string =   { "d80srcprtguvm2a_base","d80srcprtguvm2b_base","d80srcprtguvm2c_base",
     "d80mvargbnd64f252z2evm2","d80mtgvargbnd24f336zevm2","d80svargbnd64f252z2evm2"};

dr_NSD_toSynDrawing_ILWaiver=strcat(dr_NSD_toSynDrawing_ILWaiver, dr_NSD7);
dr_NSD_toSynDrawing_ILWaiver=strcat(dr_NSD_toSynDrawing_ILWaiver, dr_NSD8);
dr_NSD_toSynDrawing_ILWaiver=strcat(dr_NSD_toSynDrawing_ILWaiver, dr_NSD0);

 dr_PSD_toSynDrawing_ILWaiver: list of string =   { "d8xsrcprtguvm2a_base","d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base"};
dr_PSD7: list of string =   { "d87srcprtguvm2a_base","d87srcprtguvm2b_base","d87srcprtguvm2c_base"};
dr_PSD8: list of string =   { "d88srcprtguvm2a_base","d88srcprtguvm2b_base","d88srcprtguvm2c_base"};
dr_PSD0: list of string =   { "d80srcprtguvm2a_base","d80srcprtguvm2b_base","d80srcprtguvm2c_base"};


dr_PSD_toSynDrawing_ILWaiver=strcat(dr_PSD_toSynDrawing_ILWaiver, dr_PSD7);
dr_PSD_toSynDrawing_ILWaiver=strcat(dr_PSD_toSynDrawing_ILWaiver, dr_PSD8);
dr_PSD_toSynDrawing_ILWaiver=strcat(dr_PSD_toSynDrawing_ILWaiver, dr_PSD0);

  dr_NES_toSynDrawing_ILWaiver: list of string =   { "d8xsrcprtguvm2a_base","d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base",
     "d8xmvargbnd16f252z2evm2_unit","d8xmtgvargbnd24f336zevm2","d8xsvargbnd64f252z2evm2"
   };
dr_NES7: list of string =   { "d87srcprtguvm2a_base","d87srcprtguvm2b_base","d87srcprtguvm2c_base",
			      "d87mvargbnd16f252z2evm2_unit","d87mtgvargbnd24f336zevm2","d87svargbnd64f252z2evm2"
   };
dr_NES8: list of string =   { "d88srcprtguvm2a_base","d88srcprtguvm2b_base","d88srcprtguvm2c_base",
			      "d88mvargbnd16f252z2evm2_unit","d88mtgvargbnd24f336zevm2","d88svargbnd64f252z2evm2"
   };
dr_NES0: list of string =   { "d80srcprtguvm2a_base","d88srcprtguvm2b_base","d80srcprtguvm2c_base",
			      "d80mvargbnd16f252z2evm2_unit","d80mtgvargbnd24f336zevm2","d80svargbnd64f252z2evm2"
   };

dr_NES_toSynDrawing_ILWaiver=strcat(dr_NES_toSynDrawing_ILWaiver, dr_NES7);
dr_NES_toSynDrawing_ILWaiver=strcat(dr_NES_toSynDrawing_ILWaiver, dr_NES8);
dr_NES_toSynDrawing_ILWaiver=strcat(dr_NES_toSynDrawing_ILWaiver, dr_NES0);

dr_TNT_toSynDrawing_ILWaiver: list of string =   { "d8xsrcprtguvm2a_base","d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base"};
dr_TNT7: list of string =   { "d87srcprtguvm2a_base","d87srcprtguvm2b_base","d87srcprtguvm2c_base"};
dr_TNT8: list of string =   { "d88srcprtguvm2a_base","d88srcprtguvm2b_base","d88srcprtguvm2c_base"};
dr_TNT0: list of string =   { "d80srcprtguvm2a_base","d80srcprtguvm2b_base","d80srcprtguvm2c_base"};

dr_TNT_toSynDrawing_ILWaiver=strcat(dr_TNT_toSynDrawing_ILWaiver, dr_TNT7);
dr_TNT_toSynDrawing_ILWaiver=strcat(dr_TNT_toSynDrawing_ILWaiver, dr_TNT8);
dr_TNT_toSynDrawing_ILWaiver=strcat(dr_TNT_toSynDrawing_ILWaiver, dr_TNT0);

dr_bgd_maskdrawing_ILWaiver: list of string =    { "c8xlbgdiodehvm1", "c8xmbgdiodehvm1"};

dr_dvn_maskdrawing_ILWaiver: list of string =    { "c8xlbgdiodehvm1", "c8xmbgdiodehvm1"};
  

dr_dvp_tosyndrawing_ILWaiver: list of string =   { "c8xlbgdiodehvm1", "c8xmbgdiodehvm1"};



dr_ntp_maskdrawing_ILWaiver: list of string =    { "c8xlbgdiodehvm1", "c8xmbgdiodehvm1","d8xmbgdiodehvm1"};
dr_ntp7: list of string =    { "d87mbgdiodehvm1"};
dr_ntp8: list of string =    { "d88mbgdiodehvm1"};
dr_ntp0: list of string =    { "d80mbgdiodehvm1"};

dr_ntp_maskdrawing_ILWaiver=strcat(dr_ntp_maskdrawing_ILWaiver,dr_ntp7);
dr_ntp_maskdrawing_ILWaiver=strcat(dr_ntp_maskdrawing_ILWaiver,dr_ntp8);
dr_ntp_maskdrawing_ILWaiver=strcat(dr_ntp_maskdrawing_ILWaiver,dr_ntp0);

   dr_ptp_tosyndrawing_ILWaiver: list of string =   { 
      "c8xlbgdiodehvm1", "c8xmbgdiodehvm1", "c8xlvargbnd15f360zevm2_unit_1",
      "c8xlvargbnd15f360zevm2_unit", "c8xmvargbnd15f252zevm2_unit",
	  "d8xmbgdiodehvm1","d8xmvargbnd60f252zevm2","d8xmesdpclampgatedevm2",
	  "d8xsesdclampres","d8xmvargbnd16f252z2evm2_unit","d8xmtgvargbnd24f336zevm2",
	  "d8xmvargbns128f336zevm2", "d8xmvargbns32f336zevm2","d8xsvargbnd64f252z2evm2",
      "d8xmtgvargbns16f336zevm2", "d8xmtgvargbns56f336zevm2",  //HSD 2880
	  "d8xsesdclampdnwres"  //HSD 2847
   };

 dr_ptp7: list of string =   {
	  "d87mbgdiodehvm1","d87mvargbnd60f252zevm2","d87mesdpclampgatedevm2",
	  "d87sesdclampres","d87mvargbnd16f252z2evm2_unit","d87mtgvargbnd24f336zevm2",
	  "d87mvargbns128f336zevm2", "d87mvargbns32f336zevm2","d87svargbnd64f252z2evm2"
   };
dr_ptp8: list of string =   { 
	  "d88mbgdiodehvm1","d88mvargbnd60f252zevm2","d88mesdpclampgatedevm2",
	  "d88sesdclampres","d88mvargbnd16f252z2evm2_unit","d88mtgvargbnd24f336zevm2",
	  "d88mvargbns128f336zevm2", "d88mvargbns32f336zevm2","d88svargbnd64f252z2evm2"
   };

dr_ptp0: list of string =   { 
	  "d80mbgdiodehvm1","d80mvargbnd60f252zevm2","d80mesdpclampgatedevm2",
	  "d80sesdclampres","d80mvargbnd16f252z2evm2_unit","d80mtgvargbnd24f336zevm2",
	  "d80mvargbns128f336zevm2", "d80mvargbns32f336zevm2","d80svargbnd64f252z2evm2"
   };
dr_ptp_tosyndrawing_ILWaiver=strcat(dr_ptp_tosyndrawing_ILWaiver,dr_ptp7);
dr_ptp_tosyndrawing_ILWaiver=strcat(dr_ptp_tosyndrawing_ILWaiver,dr_ptp8);
dr_ptp_tosyndrawing_ILWaiver=strcat(dr_ptp_tosyndrawing_ILWaiver,dr_ptp0);

//   dr_svn_maskdrawing_ILWaiver: list of string =    { "c8xlbgdiodehvm1",
//    "c8xmbgdiodehvm1","d8xmbgdiodehvm1"};
//moved to dr_cell_list as this is list is also needed for AN_72 check
//    dr_diodeid_esddiodeid_ILWaiver: list of string = {
//        "c8xmbgdiodehvm1", "c8xmesddpevm1", 
//        "c8xmesddnevm1", "c8xmesddpevm1_topbot", "c8xmesddpevm1_topbot1", 
//        "c8xmesddpevm1_topbot2", "c8xmesddpevm1_corner", "c8xmesddpevm1_corner1",
//        "c8xmesddpevm1_corner2", "c8xmesddpevm1_side", "c8xmesddpevm1_dum", 
//        "c8xmesddnevm1_dum", "c8xmesddnevm1_corner", "c8xmesddnevm1_side", 
//        "c8xmesddnevm1_topbot", "d8xsesddnuvm1", "d8xsesddpuvm1", 
//        "d8xsesddnuvm1_topbot", "d8xsesddpuvm1_topbot","d8xmbgdiodehvm1",
// 	   "d8xsesddpuvterm", "d8xsesddnuvterm","x73ddr_d8xsesddpuvm1_bot", 
//        "x73ddr_d8xsesddpuvm1_top","x73pciesdd2_leaf_topbot","x73pciesdd2_leaf_bot", 
//        "x73pciesdd2subcell","x73pciesdd1_leaf_bot","x73pciesdd1_leaf_topbot",
//        "x73ddrmesdd4","x73ddrmesdd2","x73pciesdd4_prog","x73pciesdd2subcell",
// 	   "x73ddrmesdd2d0p5","x73ddrmesdd2d0p75","x73ddrmesdd2d0p25","x73ddrmesdd2d0p0"
//     };

   dr_global_inductorid1_ILWaiver: list of string = {"c82mindm11l0p8n",
	  "d84sindmtm1m9l7p6n","d84sindmtm1m9l2p2n","d84sindmtm1m9l1p1n","d84sindmtm1m9l0p6n",
	  "d84sindmtm1m9l0p4n",
      "d8xxdcpiphvm2",
      "d8xxdcpipnvm4p5",
      "d8xxdcpipnvm2p5",
      "d86indtm1m11l1p1n",
      "d86indtm1m11l2p2n",
      "d84shipindmtm1m9l1p1n",
      "d81shipindmtm1l0p5n", "d81shipindmtm1m9l0p9n", //HSD 1896
      "d81shipindmtm1m9l1p1n", //HSD 1860
      "d81sindmtm1m9l1p6n", 	  
      #if (_drPROJECT == _drx73b)
       "d84sindmtm1m9l0p7n10g",
      #endif
      "d81sindmtm1m9l1p1n"	  //Suhas email 11Dec2013
   };

 dr_global7: list of string = {
      "d87xdcpiphvm2",
      "d87xdcpipnvm4p5",
      "d87xdcpipnvm2p5",
      "d87shipindmtm1l0p5n", "d87shipindmtm1m9l0p9n", //HSD 1896
      "d87shipindmtm1m9l1p1n", //HSD 1860
      "d87sindmtm1m9l1p6n", 	  
      #if (_drPROJECT == _drx73b)
       "d84sindmtm1m9l0p7n10g",
      #endif
      "d87sindmtm1m9l1p1n"	  //Suhas email 11Dec2013
   };

 dr_global8: list of string = {
      "d88xdcpiphvm2",
      "d88xdcpipnvm4p5",
      "d88xdcpipnvm2p5",
      "d88shipindmtm1l0p5n", "d87shipindmtm1m9l0p9n", //HSD 1896
      "d88shipindmtm1m9l1p1n", //HSD 1860
      "d88sindmtm1m9l1p6n", 	  
      #if (_drPROJECT == _drx73b)
       "d84sindmtm1m9l0p7n10g",
      #endif
      "d88sindmtm1m9l1p1n"	  //Suhas email 11Dec2013
   };

 dr_global0: list of string = {
      "d80xdcpiphvm2",
      "d80xdcpipnvm4p5",
      "d80xdcpipnvm2p5",
      "d80shipindmtm1l0p5n", "d87shipindmtm1m9l0p9n", //HSD 1896
      "d80shipindmtm1m9l1p1n", //HSD 1860
      "d80sindmtm1m9l1p6n", 	  
      #if (_drPROJECT == _drx73b)
       "d84sindmtm1m9l0p7n10g",
      #endif
      "d80sindmtm1m9l1p1n"	  //Suhas email 11Dec2013
   };
dr_global_inductorid1_ILWaiver=strcat(dr_global_inductorid1_ILWaiver,dr_global7);
dr_global_inductorid1_ILWaiver=strcat(dr_global_inductorid1_ILWaiver,dr_global8);
dr_global_inductorid1_ILWaiver=strcat(dr_global_inductorid1_ILWaiver,dr_global0);

dr_metal12_inductorID_ILWaiver: list of string = {
     #if (defined(_drICFDEVICES) && (_drPROCESS == 6))
	     "ind2t_scl_*"
     #endif
  }; 

  dr_tm1_inductorID_ILWaiver: list of string = {
     #if (defined(_drICFDEVICES) && (_drPROCESS == 6))
	     "ind2t_scl_*"
     #endif
  }; 

//    dr_chkBoundary_reservedPurpose10_ILWaiver: list of string = {
//      "c8xmesdpclampnvm2", "c8xmesdpclampevm2",
//      "c8xmesdpclamp0p5nvm2", "c8xmesdpclamp0p5evm2",
//      "c8xmesdpclampgatednvm2", "c8xmesdpclampgated0p5nvm2",
//      "c8xmesdpclampgatedevm2", "c8xmesdpclampgated0p5evm2",
//      "d8xsesdpclampnvm2", "d8xsesdpclampnvm2horz", "d8xsesdpclamptgp5uvm2core",
//      "d8xsesdpclamptgp5evm2core","d8xxesdpclampnvm2horz","d8xmesdpclampnvm2horz",
// 	 "d8xsesdpclampxllgatedevm2","d8xsesdpclampxllp5gatedevm2","d8xmesdpclampgatedevm2",
//      "d8xxesdpclampxllp5gatedevm2","d8xxesdpclampxllgatedevm2"
//    };
//    
   dr_diffcon_densityID_ILWaiver: list of string = {"c8xlbgdiodehvm1",
     "d8xmtgvargbnd24f336zevm2"}; //HSD 2815

   dr_polycon_densityID_ILWaiver: list of string = {
    "c8xlbgdiodehvm1","d8xsrcprtguvm2a_base", "d8xsrcprtguvm2b_base",
     "d8xsrcprtguvm2c_base", "d8xsesdpclamptgp5evm2core", "d8xsesdpclamptgp5uvm2core"
   };
dr_polycon_densityID7: list of string = {"d87srcprtguvm2a_base", "d87srcprtguvm2b_base",
     "d87srcprtguvm2c_base", "d87sesdpclamptgp5evm2core", "d87sesdpclamptgp5uvm2core"};
dr_polycon_densityID8: list of string = {"d88srcprtguvm2a_base", "d88srcprtguvm2b_base",
     "d88srcprtguvm2c_base", "d88sesdpclamptgp5evm2core", "d88sesdpclamptgp5uvm2core"};
dr_polycon_densityID0: list of string = {"d80srcprtguvm2a_base", "d80srcprtguvm2b_base",
     "d80srcprtguvm2c_base", "d80sesdpclamptgp5evm2core", "d80sesdpclamptgp5uvm2core"};

dr_polycon_densityID_ILWaiver=strcat( dr_polycon_densityID_ILWaiver, dr_polycon_densityID7);
dr_polycon_densityID_ILWaiver=strcat( dr_polycon_densityID_ILWaiver, dr_polycon_densityID8);
dr_polycon_densityID_ILWaiver=strcat( dr_polycon_densityID_ILWaiver, dr_polycon_densityID0);

   dr_pdiff_densityID_ILWaiver: list of string = {"c8xlbgdiodehvm1", "c8xmbgdiodehvm1",
     "d8xsrcprtguvm2a_base", "d8xsrcprtguvm2b_base","d8xmbgdiodehvm1","d8xsrcprtguvm2c_base",
    
      //NTG decap cell waiver Suhas email 14Jan2015
     "d8xsdcpintgevm4_s2s","d8xsdcpintgevm2_s2s",

     //1273 fuse cells Zhanping 18Jun2013, 27Aug2013    	 
     "x73p00fcary1ne_m4f2_nw",
     "x73p00fcary1ne_ref_m4f2_nw",
     "x73p00fcary1col_64row_edger",
     "x73p00fcary1col_64row_edgel_uv2locn",
     "x73p00fcary_colpgen_uv2n",
     "x73p00fcary1col_pgen",
     "x73p00fcary1ne_mux_ref_m4f1_nw",
     "x73p00fcary1ne_ref_m4f2",
     "x73p00fcary1col_pgmctl_uv2n",
     "x73p00fcary1col_8row_edge_via",
     "x73p00fcary_sa_core",
     "x73p00fcary1ne_mux_m4f1_nw",
     "x73p00fcary1col_64row_edgeinl",
     "x73p00fcary1ne_m4f2",
     "x73p00fcary_colprgctl_uv2n",
     "x73p00fcary1ne_mux_m4f1",
     "x73p00fcary1ne_mux_ref_m4f1",
     "x73p00fcary1ne_m4f2_dot6_replica", 
	 "x73p00fcary1ne_m4f2_dot6_replica_nw", 
	 "x73p00fcary1ne_m4f2_dot6_skew2", 
	 "x73p00fcary1ne_m4f2_dot6_skew2_nw", 
	 "x73p00fcary1ne_m4f2_dot6_skew3", 
	 "x73p00fcary1ne_m4f2_dot6_skew3_nw", 	 

	 //1273 new fuse cell Zhanping WW48 2014
     "x73p00fcary1ne_m4f2_nw_r",   
     "x73p00fcary1ne_m4f2_r"   
     };

dr_pdiff_densityID7: list of string = {"d87srcprtguvm2a_base", "d87srcprtguvm2b_base","d87mbgdiodehvm1","d87srcprtguvm2c_base"};
dr_pdiff_densityID8: list of string = {"d88srcprtguvm2a_base", "d88srcprtguvm2b_base","d88mbgdiodehvm1","d88srcprtguvm2c_base"};
dr_pdiff_densityID0: list of string = {"d80srcprtguvm2a_base", "d80srcprtguvm2b_base","d80mbgdiodehvm1","d80srcprtguvm2c_base"};

dr_pdiff_densityID_ILWaiver=strcat(dr_pdiff_densityID_ILWaiver,dr_pdiff_densityID7);
dr_pdiff_densityID_ILWaiver=strcat(dr_pdiff_densityID_ILWaiver,dr_pdiff_densityID8);
dr_pdiff_densityID_ILWaiver=strcat(dr_pdiff_densityID_ILWaiver,dr_pdiff_densityID0);

   dr_ndiff_densityID_ILWaiver: list of string = {"c8xlbgdiodehvm1", "c8xmbgdiodehvm1",
     "d8xsesdpclamptgp5evm2core", "d8xsesdpclamptgp5uvm2core","d8xsrcprtguvm2a_base",
     "d8xsrcprtguvm2b_base","d8xmbgdiodehvm1","d8xsrcprtguvm2c_base",
     "d8xsesdpclampdnwtgp5evm2core", //HSD 2847

     //1273 fuse cells Zhanping 18Jun2013, 27Aug2013     	 
     "x73p00fcary1ne_m4f2_nw",
     "x73p00fcary1ne_ref_m4f2_nw",
     "x73p00fcary1col_64row_edger",
     "x73p00fcary1col_64row_edgel_uv2locn",
     "x73p00fcary_colpgen_uv2n",
     "x73p00fcary1col_pgen",
     "x73p00fcary1ne_mux_ref_m4f1_nw",
     "x73p00fcary1ne_ref_m4f2",
     "x73p00fcary1col_pgmctl_uv2n",
     "x73p00fcary1col_8row_edge_via",
     "x73p00fcary_sa_core",
     "x73p00fcary1ne_mux_m4f1_nw",
     "x73p00fcary1col_64row_edgeinl",
     "x73p00fcary1ne_m4f2",
     "x73p00fcary_colprgctl_uv2n",
     "x73p00fcary1ne_mux_m4f1",
     "x73p00fcary1ne_mux_ref_m4f1",
     "x73p00fcary1ne_m4f2_dot6_replica", 
	 "x73p00fcary1ne_m4f2_dot6_replica_nw", 
	 "x73p00fcary1ne_m4f2_dot6_skew2", 
	 "x73p00fcary1ne_m4f2_dot6_skew2_nw", 
	 "x73p00fcary1ne_m4f2_dot6_skew3", 
	 "x73p00fcary1ne_m4f2_dot6_skew3_nw", 
	 
	 //1273 new fuse cell Zhanping WW48 2014
     "x73p00fcary1ne_m4f2_nw_r",   
     "x73p00fcary1ne_m4f2_r"   
	 };
 
	 
dr_ndiff7: list of string = {"d87sesdpclamptgp5evm2core", "d87sesdpclamptgp5uvm2core","d87srcprtguvm2a_base","d87srcprtguvm2b_base","d87mbgdiodehvm1","d87srcprtguvm2c_base"};
 	 
       	 
dr_ndiff8: list of string = {
     "d88sesdpclamptgp5evm2core", "d88sesdpclamptgp5uvm2core","d88srcprtguvm2a_base",
			     "d88srcprtguvm2b_base","d88mbgdiodehvm1","d88srcprtguvm2c_base"};

dr_ndiff0: list of string = {
     "d80sesdpclamptgp5evm2core", "d80sesdpclamptgp5uvm2core","d80srcprtguvm2a_base",
			     "d80srcprtguvm2b_base","d80mbgdiodehvm1","d80srcprtguvm2c_base"}; 

dr_ndiff_densityID_ILWaiver=strcat(dr_ndiff_densityID_ILWaiver,dr_ndiff7);
dr_ndiff_densityID_ILWaiver=strcat(dr_ndiff_densityID_ILWaiver,dr_ndiff8);
dr_ndiff_densityID_ILWaiver=strcat(dr_ndiff_densityID_ILWaiver,dr_ndiff0);

   #if (_drPROJECT == _drx73a)
      dr_poly_densityID_ILWaiver: list of string = {"c8xlrgcn4leg", "c8xlrgcn4legdac_base","d8xsesdpclamptgp5evm2core",
         "d8xsesdpclamptgp5uvm2core","d8xsrcprtguvm2a_base", "d8xsrcprtguvm2b_base", "x73tgary"};
   #else  
     dr_poly_densityID_ILWaiver: list of string = {"c8xlrgcn4leg", "c8xlrgcn4legdac_base","d8xsesdpclamptgp5evm2core",
       "d8xsesdpclamptgp5uvm2core","d8xsrcprtguvm2a_base", "d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base",
	   "d8xsdcpintgevm4_s2s", "d8xsdcpintgevm2_s2s", 	//hsd 2282
	   "d8xsdcpiptgevm4v2", 					 		//hsd 2495
       "d8xsdcpiptgevm2v2",								//hsd 2495
       "d8xsesdscruvm6stktgn",  		                //hsd 2569
       "d8xsesdscrsecuvm6stktgn",        //hsd 2569
       "d8xsesdpclamptgp25evm2nspath",   //hsd 2966+  KBK email 15Jan15
       "d8xsesdpclampdnwtgp5evm2core"    //HSD 2847
					   
	  #if (_drPROJECT == _drx73b)
	  , "x73tgary"
	  #endif
	   };
   #endif


   dr_poly7: list of string = {
       "d87sesdpclamptgp5evm2core",
       "d87sesdpclamptgp5uvm2core",
       "d87srcprtguvm2a_base",
       "d87srcprtguvm2b_base",
       "d87srcprtguvm2c_base",
       "d87sdcpintgevm4_s2s",
       "d87sdcpintgevm2_s2s",
       "d87sdcpiptgevm4v2",
       "d87sdcpiptgevm2v2",
       "d87sesdscruvm6stktgn",
       "d87sesdscruvm6stktgn_dnw", 	     //hsd 2569
       "d87sesdscrsecuvm6stktgn",
       "d87sesdscrsecuvm6stktgn_dnw",  	 //hsd 2569
       "d87sesdpclamptgp25evm2nspath",   //hsd 2966+  KBK email 15Jan15
       "d87sesdpclampdnwtgp5evm2core"    //HSD 2847
	   };

 
   dr_poly8: list of string = {};

   dr_poly0: list of string = {
	   "d80sesdpclamptgp5evm2core",
	   "d80sesdpclamptgp5uvm2core",
	   "d80srcprtguvm2a_base", 
	   "d80srcprtguvm2b_base",
	   "d80srcprtguvm2c_base",
	   "d80sdcpintgevm4_s2s",
	   "d80sdcpintgevm2_s2s",
	   "d80sdcpiptgevm4v2",
	   "d80sdcpiptgevm2v2",
	   "d80sesdpclamptgp25evm2nscore"	//hsd 2966
       };

dr_poly_densityID_ILWaiver=strcat(dr_poly_densityID_ILWaiver,dr_poly7);
dr_poly_densityID_ILWaiver=strcat(dr_poly_densityID_ILWaiver,dr_poly8);
dr_poly_densityID_ILWaiver=strcat(dr_poly_densityID_ILWaiver,dr_poly0);


   dr_via11_densityID_ILWaiver: list of string = { "c82mindm11l0p8n", "c82mindm11l0p6n" };
   
   dr_tm1_densityID_ILWaiver: list of string = {"c82mindm11l0p8n", "c82mindm11l0p6n", 
     "d8xmtoprs_y_small", "d8xmtoprs_i_small",
     "d86mtoprs_y_small", "d86mtoprs_i_small",
	 "d81mtoprs_y_small", "d81mtoprs_i_small",
	 "d81mtoprs_y_small_cc", "d81mtoprs_i_small_cc"
   };  
dr_tm1_densityID7: list of string = { 
    "d87mtoprs_y_small", "d87mtoprs_i_small",
	 "d87mtoprs_y_small", "d87mtoprs_i_small",
	 "d87mtoprs_y_small_cc", "d87mtoprs_i_small_cc"
   };

dr_tm1_densityID8: list of string = {
     "d88mtoprs_y_small", "d88mtoprs_i_small",
	 "d88mtoprs_y_small", "d88mtoprs_i_small",
	 "d88mtoprs_y_small_cc", "d88mtoprs_i_small_cc"
   };

dr_tm1_densityID0: list of string = {
     "d80mtoprs_y_small", "d80mtoprs_i_small",
	 "d80mtoprs_y_small", "d80mtoprs_i_small",
	 "d80mtoprs_y_small_cc", "d80mtoprs_i_small_cc"
   };
dr_tm1_densityID_ILWaiver=strcat(dr_tm1_densityID_ILWaiver,dr_tm1_densityID7);
dr_tm1_densityID_ILWaiver=strcat(dr_tm1_densityID_ILWaiver,dr_tm1_densityID8);
dr_tm1_densityID_ILWaiver=strcat(dr_tm1_densityID_ILWaiver,dr_tm1_densityID0);

     dr_via9_densityID_ILWaiver: list of string = {
       #if ((_drPROJECT == _drx73a) || (_drPROJECT == _drx73b))
         "d84sindmtm1m9l0p4n",
       #endif	 

     "d81sindmtm1m9l1p6n",  //Suhas email 13Dec13 
	 "d8xmtoprs_y_small", "d8xmtoprs_i_small",
     "d86mtoprs_y_small", "d86mtoprs_i_small", "d81mtoprs_y_small", "d81mtoprs_i_small","d81sindmtm1m9l1p6n",
	 "d81mtoprs_y_small_cc", "d81mtoprs_i_small_cc"
   };
 

     dr_via9_7: list of string = {
     "d87sindmtm1m9l1p6n",  //Suhas email 13Dec13 
	 "d87sindmtm1m9l1p1n"
   };

     dr_via9_8: list of string = {
   };

  dr_via9_0: list of string = {
     "d80sindmtm1m9l1p6n",  //Suhas email 13Dec13 
     "d80sindmtm1m9l1p1n"
   };
dr_via9_densityID_ILWaiver=strcat(dr_via9_densityID_ILWaiver,dr_via9_7);
dr_via9_densityID_ILWaiver=strcat(dr_via9_densityID_ILWaiver,dr_via9_8);
dr_via9_densityID_ILWaiver=strcat(dr_via9_densityID_ILWaiver,dr_via9_0);

   dr_metal9_densityID_ILWaiver: list of string = {"d8xmtoprs_y_small", "d8xmtoprs_i_small",
     "d86mtoprs_y_small", "d86mtoprs_i_small", "d81mtoprs_y_small", "d81mtoprs_i_small",
	 "d81mtoprs_y_small_cc", "d81mtoprs_i_small_cc"
   };

 dr_metal9_7: list of string = {};

 dr_metal9_8: list of string = {};

 dr_metal9_0: list of string = {};

dr_metal9_densityID_ILWaiver=strcat(dr_metal9_densityID_ILWaiver, dr_metal9_7);
dr_metal9_densityID_ILWaiver=strcat(dr_metal9_densityID_ILWaiver, dr_metal9_8);
dr_metal9_densityID_ILWaiver=strcat(dr_metal9_densityID_ILWaiver, dr_metal9_0);

   dr_CE1_densityID_ILWaiver: list of string = {"d8xmtoprs_y_small", "d8xmtoprs_i_small",
     "d86mtoprs_y_small", "d86mtoprs_i_small", "d81mtoprs_y_small", "d81mtoprs_i_small",
	 "d81mtoprs_y_small_cc", "d81mtoprs_i_small_cc"
   };

dr_CE1_7: list of string = {};
dr_CE1_8: list of string = {};
dr_CE1_0: list of string = {};

dr_CE1_densityID_ILWaiver=strcat(dr_CE1_densityID_ILWaiver,dr_CE1_7);
dr_CE1_densityID_ILWaiver=strcat(dr_CE1_densityID_ILWaiver,dr_CE1_8);
dr_CE1_densityID_ILWaiver=strcat(dr_CE1_densityID_ILWaiver,dr_CE1_0);

   dr_CE2_densityID_ILWaiver: list of string = {"d8xmtoprs_y_small", "d8xmtoprs_i_small",
     "d86mtoprs_y_small", "d86mtoprs_i_small", "d81mtoprs_y_small", "d81mtoprs_i_small",
	 "d81mtoprs_y_small_cc", "d81mtoprs_i_small_cc"
   };
dr_CE2_7: list of string = {};
dr_CE2_8: list of string = {};
dr_CE2_0: list of string = {};

dr_CE2_densityID_ILWaiver= strcat( dr_CE2_densityID_ILWaiver,dr_CE2_7);
dr_CE2_densityID_ILWaiver= strcat( dr_CE2_densityID_ILWaiver,dr_CE2_8);
dr_CE2_densityID_ILWaiver= strcat( dr_CE2_densityID_ILWaiver,dr_CE2_0);

   dr_asym_keepGenAway_ILWaiver: list of string = {"d8xmtoprs_y_small", "d8xmtoprs_i_small",
     "d86mtoprs_y_small", "d86mtoprs_i_small", "d81mtoprs_y_small", "d81mtoprs_i_small",
	 "d81mtoprs_y_small_cc", "d81mtoprs_i_small_cc"
   };
 dr_asym_keepGenAway7: list of string = {};
 dr_asym_keepGenAway8: list of string = {};
 dr_asym_keepGenAway0: list of string = {};

dr_asym_keepGenAway_ILWaiver=strcat(dr_asym_keepGenAway_ILWaiver,dr_asym_keepGenAway7);
dr_asym_keepGenAway_ILWaiver=strcat(dr_asym_keepGenAway_ILWaiver,dr_asym_keepGenAway8);
dr_asym_keepGenAway_ILWaiver=strcat(dr_asym_keepGenAway_ILWaiver,dr_asym_keepGenAway0);

dr_metal12_densityID_ILWaiver: list of string = {
     "d86mtoprs_y_small", "d86mtoprs_i_small"
   };


   dr_ID_prs_ILWaiver: list of string = {
     "d8xmtoprs_y_small", "d8xmtoprs_i_small",
     "d81mtoprs_y_small", "d81mtoprs_i_small",
     "d86mtoprs_y_small", "d86mtoprs_i_small",
     "d81mtoprs_y_small_cc", "d81mtoprs_i_small_cc"
   };
dr_ID_prs_7: list of string = {
     "d87mtoprs_y_small", "d87mtoprs_i_small",
     "d87mtoprs_y_small", "d87mtoprs_i_small",
     "d87mtoprs_y_small_cc", "d87mtoprs_i_small_cc"
   };
dr_ID_prs_8: list of string = {
     "d88mtoprs_y_small", "d88mtoprs_i_small",
     "d88mtoprs_y_small", "d88mtoprs_i_small",
     "d88mtoprs_y_small_cc", "d88mtoprs_i_small_cc"
   };

dr_ID_prs_0: list of string = {
     "d80mtoprs_y_small", "d80mtoprs_i_small",
     "d80mtoprs_y_small", "d80mtoprs_i_small",
     "d80mtoprs_y_small_cc", "d80mtoprs_i_small_cc"
   };
dr_ID_prs_ILWaiver=strcat(dr_ID_prs_ILWaiver,dr_ID_prs_7);
dr_ID_prs_ILWaiver=strcat(dr_ID_prs_ILWaiver, dr_ID_prs_8);
dr_ID_prs_ILWaiver=strcat(dr_ID_prs_ILWaiver, dr_ID_prs_0);

   //Suddha: STTRAM related DENID waivers for M2/V1
   #if (_drSTRAM_WAIVER == _drYES)
     dr_metal2_densityID_ILWaiver: list of string = {"x73sttramcell_large", "x73sttramcell1b_small",
     				                     "x73sttramcell2c_small","x73sttramcell1c_small",
						     "x73sttramcell2b_small","x73sttramcell_large_nomtj",
						     "x73sttsubary_tr_tdl", "x73sttramcell_large"};

     dr_via1_densityID_ILWaiver: list of string   = {"x73sttramcell_large", "x73sttramcell1b_small",
     				                     "x73sttramcell2c_small","x73sttramcell1c_small",
						     "x73sttramcell2b_small","x73sttramcell_large_nomtj",
                                                     "x73sttsubary_tr_tdl", "x73sttramcell_large"};
   #else

     dr_metal2_densityID_ILWaiver: list of string = {"x73btsvccalt1", "x73btsvccspcralt1", "x73tsv_tc0emgrdx73aogd",
	  "x73tsv_tc0emgrdx73aogd_gap", "x73tsv_tc0emgrdx73aogd_gap_2p52", "x73tsv_tc0emgrdx73aogd_gap_2p24", 
	  "x73tsv_tc0emgrdx73aogd_gap_1p96", "x73tsv_tc0emgrdx73apgd", "x73tsv_tc0emgrdx73apgd_gap", "x73tsv_tc0emgrdx73acrn", 
	  "d8xltsv_ccsymb", "d8xltsv_ccspcralt1", "d8xltsv_emgrd1273ogd",  "d8xltsv_emgrd1273ogd_gap_2p52",
	  "d8xltsv_emgrd1273ogd_gap_1p96","d8xltsv_emgrd1273ogd_gap","d8xltsv_emgrd1273ogd_gap_2p24",
	  "d8xltsv_emgrd1273pgd","d8xltsv_emgrd1273pgd_gap", "d8xltsv_emgrd1273crn", "d81tsvccalt1_cc","d8xltsv_ccsymb_prs"
	};
												 
												 
     dr_via1_densityID_ILWaiver: list of string = {"x73btsvccalt1", "d8xltsv_ccsymb","d81tsvccalt1_cc","d8xltsv_ccsymb_prs"};						     
   #endif

//   dr_arrayId_highDensity_ILWaiver: list of string = { "x72hdcbit", "x72hdcarygap", "x72hdcbitedge"};


//Dipto 01Dec11
//1273 related waivers for IL flow - may be need to separate out the IL flow for 1273

 dr_esd_tosyndrawing_ILWaiver: list of string = {"d8xsrcprtguvm2a_base","d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base"};
dr_esd7: list of string = {"d87srcprtguvm2a_base","d87srcprtguvm2b_base","d7xsrcprtguvm2c_base"};
dr_esd8: list of string = {"d88srcprtguvm2a_base","d88srcprtguvm2b_base","d88srcprtguvm2c_base"};
dr_esd0: list of string = {"d80srcprtguvm2a_base","d80srcprtguvm2b_base","d80srcprtguvm2c_base"};
dr_esd_tosyndrawing_ILWaiver=strcat(dr_esd_tosyndrawing_ILWaiver,dr_esd7);
dr_esd_tosyndrawing_ILWaiver=strcat(dr_esd_tosyndrawing_ILWaiver,dr_esd8);
dr_esd_tosyndrawing_ILWaiver=strcat(dr_esd_tosyndrawing_ILWaiver,dr_esd0);

dr_rmp_maskdrawing_ILWaiver: list of string = {"d8xsrcprtguvm2a_base","d8xsrcprtguvm2b_base","d8xsrcprtguvm2c_base"};
dr_rmp_maskdrawing7: list of string = {"d87srcprtguvm2a_base","d87srcprtguvm2b_base","d87srcprtguvm2c_base"};
dr_rmp_maskdrawing8: list of string = {"d88srcprtguvm2a_base","d88srcprtguvm2b_base","d88srcprtguvm2c_base"};
dr_rmp_maskdrawing0: list of string = {"d80srcprtguvm2a_base","d80srcprtguvm2b_base","d80srcprtguvm2c_base"};

dr_rmp_maskdrawing_ILWaiver=strcat(dr_rmp_maskdrawing_ILWaiver,dr_rmp_maskdrawing7);
dr_rmp_maskdrawing_ILWaiver=strcat(dr_rmp_maskdrawing_ILWaiver,dr_rmp_maskdrawing8);
dr_rmp_maskdrawing_ILWaiver=strcat(dr_rmp_maskdrawing_ILWaiver,dr_rmp_maskdrawing0);

dr_tpt_tosyndrawing_ILWaiver: list of string = {"d8xsrcprtguvm2a_base", "d8xsrcprtguvm2b_base","d8xsesdclamprestg",
     "d8xsrcprtguvm2c_base"};
dr_tpt_tosyndrawing7: list of string = {"d87srcprtguvm2a_base", "d87srcprtguvm2b_base","d87sesdclamprestg",
     "d87srcprtguvm2c_base"};
dr_tpt_tosyndrawing8: list of string = {"d88srcprtguvm2a_base", "d88srcprtguvm2b_base","d88sesdclamprestg",
     "d88srcprtguvm2c_base"};
dr_tpt_tosyndrawing0: list of string = {"d80srcprtguvm2a_base", "d80srcprtguvm2b_base","d80sesdclamprestg",
     "d80srcprtguvm2c_base"};

dr_tpt_tosyndrawing_ILWaiver=strcat(dr_tpt_tosyndrawing_ILWaiver,dr_tpt_tosyndrawing7);
dr_tpt_tosyndrawing_ILWaiver=strcat(dr_tpt_tosyndrawing_ILWaiver,dr_tpt_tosyndrawing8);
dr_tpt_tosyndrawing_ILWaiver=strcat(dr_tpt_tosyndrawing_ILWaiver,dr_tpt_tosyndrawing0);

dr_chkBoundary_reservedPurpose1_ILWaiver: list of string = {"d8xsesdd1uvm3","d8xsesdd1thermalm4"};
dr_chkBoundary_reservedPurpose1_7: list of string = {"d87sesdd1uvm3","d87sesdd1thermalm4"};
dr_chkBoundary_reservedPurpose1_8: list of string = {"d88sesdd1uvm3","d88sesdd1thermalm4"};
dr_chkBoundary_reservedPurpose1_0: list of string = {"d80sesdd1uvm3","d80sesdd1thermalm4"};

dr_chkBoundary_reservedPurpose1_ILWaiver=strcat(dr_chkBoundary_reservedPurpose1_ILWaiver ,dr_chkBoundary_reservedPurpose1_7);
dr_chkBoundary_reservedPurpose1_ILWaiver=strcat(dr_chkBoundary_reservedPurpose1_ILWaiver ,dr_chkBoundary_reservedPurpose1_8);
dr_chkBoundary_reservedPurpose1_ILWaiver=strcat(dr_chkBoundary_reservedPurpose1_ILWaiver ,dr_chkBoundary_reservedPurpose1_0);

dr_chkBoundary_reservedPurpose2_ILWaiver: list of string = {"d8xsesdd2uvm3","d8xsesdd2x3thermalm4"};
dr_chkBoundary_reservedPurpose2_7: list of string = {"d87sesdd2uvm3","d87sesdd2x3thermalm4"};
dr_chkBoundary_reservedPurpose2_8: list of string = {"d88sesdd2uvm3","d88sesdd2x3thermalm4"};
dr_chkBoundary_reservedPurpose2_0: list of string = {"d80sesdd2uvm3","d80sesdd2x3thermalm4"};

dr_chkBoundary_reservedPurpose2_ILWaiver=strcat(dr_chkBoundary_reservedPurpose2_ILWaiver,dr_chkBoundary_reservedPurpose2_7);
dr_chkBoundary_reservedPurpose2_ILWaiver=strcat(dr_chkBoundary_reservedPurpose2_ILWaiver,dr_chkBoundary_reservedPurpose2_8);
dr_chkBoundary_reservedPurpose2_ILWaiver=strcat(dr_chkBoundary_reservedPurpose2_ILWaiver,dr_chkBoundary_reservedPurpose2_0);
						 
dr_chkBoundary_reservedPurpose3_ILWaiver: list of string = {"d8xsesdd3uvm3"};
dr_chkBoundary_reservedPurpose3_7: list of string = {"d87sesdd3uvm3"};
dr_chkBoundary_reservedPurpose3_8: list of string = {"d88sesdd3uvm3"};
dr_chkBoundary_reservedPurpose3_0: list of string = {"d80sesdd3uvm3"};

dr_chkBoundary_reservedPurpose3_ILWaiver= strcat(dr_chkBoundary_reservedPurpose3_ILWaiver, dr_chkBoundary_reservedPurpose3_7);
dr_chkBoundary_reservedPurpose3_ILWaiver= strcat(dr_chkBoundary_reservedPurpose3_ILWaiver, dr_chkBoundary_reservedPurpose3_8);
dr_chkBoundary_reservedPurpose3_ILWaiver= strcat(dr_chkBoundary_reservedPurpose3_ILWaiver, dr_chkBoundary_reservedPurpose3_0);


dr_chkBoundary_reservedPurpose4_ILWaiver: list of string = {"d8xsesdd4uvm3"};
dr_chkBoundary_reservedPurpose4_7: list of string = {"d87sesdd4uvm3"};
dr_chkBoundary_reservedPurpose4_8: list of string = {"d88sesdd4uvm3"};
dr_chkBoundary_reservedPurpose4_0: list of string = {"d80sesdd4uvm3"};
dr_chkBoundary_reservedPurpose4_ILWaiver= strcat(  dr_chkBoundary_reservedPurpose4_ILWaiver,dr_chkBoundary_reservedPurpose4_7);
dr_chkBoundary_reservedPurpose4_ILWaiver= strcat(  dr_chkBoundary_reservedPurpose4_ILWaiver,dr_chkBoundary_reservedPurpose4_8);
dr_chkBoundary_reservedPurpose4_ILWaiver= strcat(  dr_chkBoundary_reservedPurpose4_ILWaiver,dr_chkBoundary_reservedPurpose4_0);

dr_nwellesd_gbnwID_ILWaiver: list of string = {"d8xsesdclampres", "d8xsesdclamprestg", 
   "d8xsesdclampdnwres"  //HSD 2847
};

dr_nwellesd_gbnwID_7: list of string = {"d87sesdclampres", "d87sesdclamprestg"};
dr_nwellesd_gbnwID_8: list of string = {"d88sesdclampres", "d88sesdclamprestg"};
dr_nwellesd_gbnwID_0: list of string = {"d80sesdclampres", "d80sesdclamprestg"};

dr_nwellesd_gbnwID_ILWaiver= strcat( dr_nwellesd_gbnwID_ILWaiver, dr_nwellesd_gbnwID_7);
dr_nwellesd_gbnwID_ILWaiver= strcat( dr_nwellesd_gbnwID_ILWaiver, dr_nwellesd_gbnwID_8);
dr_nwellesd_gbnwID_ILWaiver= strcat( dr_nwellesd_gbnwID_ILWaiver, dr_nwellesd_gbnwID_0);

   dr_nwell_ESDDiodeID_ILWaiver: list of string = {"d8xsesddpuvterm", "d8xsesddnuvterm",
     "d86sesddnuvtermulc_blank", "d86sesddpuvtermulc_blank", //HSD 1956
	 "d84sesddnuvtermulc_blank", "d84sesddpuvtermulc_blank" //HSD 2189
   };

 dr_nwell_ESDDiodeID_7: list of string = {"d87sesddpuvterm", "d87sesddnuvterm" };

 dr_nwell_ESDDiodeID_8: list of string = {"d88sesddpuvterm", "d88sesddnuvterm" };

 dr_nwell_ESDDiodeID_0: list of string = {"d80sesddpuvterm", "d80sesddnuvterm" };

dr_nwell_ESDDiodeID_ILWaiver= strcat( dr_nwell_ESDDiodeID_ILWaiver, dr_nwell_ESDDiodeID_7);
dr_nwell_ESDDiodeID_ILWaiver= strcat( dr_nwell_ESDDiodeID_ILWaiver, dr_nwell_ESDDiodeID_8);
dr_nwell_ESDDiodeID_ILWaiver= strcat( dr_nwell_ESDDiodeID_ILWaiver, dr_nwell_ESDDiodeID_0);


dr_ID_bgdiodeID_ILWaiver: list of string = {"d8xmbgdiodehvm1"};
dr_ID_bgdiodeID_7: list of string = {"d87mbgdiodehvm1"};
dr_ID_bgdiodeID_8: list of string = {"d88mbgdiodehvm1"};
dr_ID_bgdiodeID_0: list of string = {"d80mbgdiodehvm1"};

dr_ID_bgdiodeID_ILWaiver=strcat( dr_ID_bgdiodeID_ILWaiver, dr_ID_bgdiodeID_7);
dr_ID_bgdiodeID_ILWaiver=strcat( dr_ID_bgdiodeID_ILWaiver, dr_ID_bgdiodeID_8);
dr_ID_bgdiodeID_ILWaiver=strcat( dr_ID_bgdiodeID_ILWaiver, dr_ID_bgdiodeID_0);


 dr_ID_VaractorID_ILWaiver: list of string = {"d8xmvargbnd60f252zevm2","d8xmvargbnd64f252z2evm2",
     "d8xmtgvargbnd24f336zevm2", "d8xsvargbnd64f252z2evm2", 
	 "d8xmtgvargbns16f336zevm2", "d8xmtgvargbns56f336zevm2"};  //HSD 2880

 dr_ID_VaractorID_7: list of string = {"d87mvargbnd60f252zevm2","d87mvargbnd64f252z2evm2"};
 dr_ID_VaractorID_8: list of string = {"d88mvargbnd60f252zevm2","d88mvargbnd64f252z2evm2"};
 dr_ID_VaractorID_0: list of string = {"d80mvargbnd60f252zevm2","d80mvargbnd64f252z2evm2"};

dr_ID_VaractorID_ILWaiver=strcat( dr_ID_VaractorID_ILWaiver,  dr_ID_VaractorID_7);
dr_ID_VaractorID_ILWaiver=strcat( dr_ID_VaractorID_ILWaiver,  dr_ID_VaractorID_8);
dr_ID_VaractorID_ILWaiver=strcat( dr_ID_VaractorID_ILWaiver,  dr_ID_VaractorID_0);

   dr_OGD_centerLine_ILWaiver: list of string = {"x73ulcbit", "x73ulcbitdummy", "x73hdcbitlp", "x73hpcbitlp", "x73lvcbitlp",
                                                 "x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen",
						 "x73hddpbitlp", "x73sdpbitlp", "x73hpdpbitlp", "x73hpdpbitlp2", "x73lvdpbitlp2", "x73lvdpbitlp", "x73hpc1bitlp", "x73lvcbitvccgaplp", "x73lvcbitwlstraplp", "x73hdcbitwlstraplp"};

 
   dr_PGD_centerLine_ILWaiver: list of string = {"x73ulcbit", "x73ulcbitdummy", "x73hdcbitlp", "x73hpcbitlp", "x73lvcbitlp",
                                                 "x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen",
						 "x73hddpbitlp", "x73sdpbitlp", "x73hpdpbitlp", "x73hpdpbitlp2", "x73lvdpbitlp2", "x73lvdpbitlp", "x73hpc1bitlp", "x73lvcbitvccgaplp", "x73lvcbitwlstraplp","x73hdcbitwlstraplp"};
   dr_bitcell3_reservedPurpose9_ILWaiver: list of string = {"x73ulcbit", "x73ulcbitdummy" };
   dr_bitcell3_reservedPurpose10_ILWaiver: list of string = {"x73hdcbitlp"};
   dr_SRAM_XLV_maskDrawing_ILWaiver: list of string = {"x73hpcbitlp"};
   dr_SRAM_ULV_maskDrawing_ILWaiver: list of string = {"x73lvcbitlp", "x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen"};
   dr_bitcell4_reservedPurpose4_ILWaiver: list of string = {"x73hpc1bitlp"};
   dr_bitcell4_reservedPurpose5_ILWaiver: list of string = {"x73lvdpbitlp2", "x73lvdpbitlp"};
   dr_diffusion_reservedPurpose10_ILWaiver: list of string = {"x73c04_tap1", 
     "c04tap02ldz03", "c04tap02ndz03", "c04tap02wdz03",
     "d04tap02ldz03","d04tap02ndz03","d04tap02wdz03", "d04tap02xdz03",
     "d04tap02ydz03", "df4tap02ldz03","df4tap02ndz03","df4tap02wdz03", "df4tap02xdz03", "df4tap02ydz03" }; //HSD 2926  
   
   dr_SRAM_IDV_maskDrawing_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_diffcon_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_metal0_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_metal1_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_metal2_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_poly_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_polycon_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_via0_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_via1_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };
   dr_viacon_TccIDBitCell_ILWaiver: list of string = {"x73idvlvcpu_bit",  "x73idvlvcpd_bit", "x73idvlvcpd_1bit_open", "x73idvlvcpg_bit", "x73idvlvcpg_1bit_open", "x73idvlvc_1bit_rowopen" };


#if ((_drPROJECT == _drx73a) || (_drPROJECT == _drx73b))

  dr_FTI_maskDrawing_ILWaiver: list of string = {
    "d04fky00nd0e0_postfti", 
    "d04inn00nn0a5_postfti_1", 
    "d04inn00nn0a5_postfti_2",
    "d04inn00nn0a5_postfti_3",
 };

// Udalak was fine with the topcell name for x73a
  dr_metal1_backBone_ILWaiver: list of string = {
    "x73p00fs_security_fuses",
    "x73p00fcary1ne_ref_lv_f2",
    "x73p00fcary1ne_ref_lv_f3",
    "x73p00fs_cont_lv_xm1",    	 
    "x73p00fcary1ne_lv_f2_40nm",    
    "x73p00fcary1ne_lv_f3_40nm",    
    "x73p00fcary1ne_ref_lv_f2_40nm",
    "x73p00fcary1ne_lv_f2",         
    "x73p00fcary1ne_lv_f3",         
    "x73p00fcary1ne_ref_lv_f3_40nm",
  };

  dr_metal1_BCregionID_ILWaiver: list of string = {
    "x73p00fs_ultred_cont_xm1", 
	"x73p00fs_cont_lv_xm1", 
  };

  dr_metalc1_complement_ILWaiver: list of string = {
    "x73p00fs_ultred_cont_xm1",
    "x73p00fs_cont_lv_xm1",	
  };

//Adding waivers for anti-fuse and m3 fuse jog
  dr_metal3_fuseJog_ILWaiver: list of string = {
    "x73p00fcary1ne_fuse5a_btm",
    "x73p00fcary1ne_ref_fuse5a_btm",
    "x73p00fcary1ne_fuse5a",
    "x73p00fcary1ne_ref_fuse5a",
    "x73p00fcary1ne_security_m3",
    "x73p00fcary1ne_security_m3_fix1",
    "x73p00fcary1ne_ref_security_m3",
    "x73p00fcary1ne_security_m3_f1",
    "x73p00fcary1ne_security_m3_fix1_f1",
    "x73p00fcary1ne_ref_security_m3_f1",
    "x73p00fcary1ne_security_m3_f2",
    "x73p00fcary1ne_security_m3_fix1_f2",
    "x73p00fcary1ne_ref_security_m3_f2",
    "x73p00fcary1ne_security_m3_f3",
    "x73p00fcary1ne_security_m3_fix1_f3",
    "x73p00fcary1ne_ref_security_m3_f3",
    "x73p00fcary1ne_security_m3_f4",
    "x73p00fcary1ne_security_m3_fix1_f4",
    "x73p00fcary1ne_ref_security_m3_f4",
    "x73p00fcary1ne_security_m3_lv",
    "x73p00fcary1ne_ref_security_m3_lv",
    "x73p00fcary1ne_security_m3l",
    "x73p00fcary1ne_fuse5a_btm1",    
    "x73p00fcary1ne_ref_fuse5a_btm1",
  };

  dr_antiFuse_id_ILWaiver: list of string = {"x73p00fcary1ne_1c_*"};
  dr_DMG_maskDrawing_ILWaiver: list of string = {"x73p00fcary1ne_1c_*", "x73p00fcary1col_1t1c*"};
  dr_PV3_maskDrawing_ILWaiver: list of string = {"x73p00fcary1ne_1c_*"};
  dr_PVL_maskDrawing_ILWaiver: list of string = {"x73p00fcary1col_1t1c*"};
  dr_XVP_maskDrawing_ILWaiver: list of string = {"x73p00fcary1col_1t1c*"};


#else
  dr_FTI_maskDrawing_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_metal1_backBone_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_metal1_BCregionID_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_metalc1_complement_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_metal3_fuseJog_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_antiFuse_id_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_DMG_maskDrawing_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_PV3_maskDrawing_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_PVL_maskDrawing_ILWaiver: list of string = {"my_dummy_cell_oz" };
  dr_XVP_maskDrawing_ILWaiver: list of string = {"my_dummy_cell_oz" };
  
#endif


dr_metal2_noOPCDFM_ILWaiver: list of string = {
  "x73p00fcary1ne_m4f2_nw",
  "x73p00fcary1ne_ref_m4f2_nw",
  "x73p00fcary1col_64row_edger",
  "x73p00fcary1col_64row_edgel_uv2locn",
  "x73p00fcary1ne_ref_m4f2",
  "x73p00fcary1ne_m4f2_fix1_nw",
  "x73p00fcary1ne_m4f2_nw_r",
  "x73p00fcary1col_64row_edgeinl",
  "x73p00fcary1ne_m4f2",
  "x73p00fcary1ne_m4f2_r",
  "x73p00fcary1ne_m4f2_fix1",

#if ( _drPROJECT == _drx73b )
  "x73p00fcary1ne_m4f2_nw",
  "x73p00fcary1ne_m4f2_dot6_nw",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew3",
  "x73p00fcary1ne_lv_f1_40nm",
  "x73p00fcary1ne_ref_m4f2_dot6_skew2_nw",
  "x73p00fcary1col_64row_edgel_uv2locn_m1",
  "x73p00fcary1ne_ref_m4f2_dot6_replica_nw",
  "x73p00fcary1ne_ref_fuse5_nw",
  "x73p00fcary1ne_ref_lv_f1",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary1ne_fuse5b_nw",
  "x73p00fcary1ne_ref_fuse1",
  "x73p00fcary1ne_lv1",
  "x73p00fcary1col_64row_edgel_fuse5a_btm",
  "x73p00fcary1ne_ref_lv_f2",
  "x73p00fcary1ne_m4f2_nw_36nm",
  "x73p00fcary1ne_ref_fuse2",
  "x73p00fcary1ne_ref_lv_f3",
  "x73p00fcary1ne_m4f2_dot6_skew3_nw",
  "x73p00fcary1ne_ref_fuse4_btm",
  "x73p00fcary1ne_ref_fuse3",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_nw",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_36nm",
  "x73p00fcary1ne_ref_lv_f4",
  "x73p00fcary1ne_ref_fuse4",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_skew3",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew3",
  "x73p00fcary1ne_fuse4_nw",
  "x73p00fcary1ne_ref_fuse5",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_replica",
  "x73p00fcary1col_64row_edger",
  "x73p00fcary1ne_lv_f2_40nm",
  "x73p00fcary1ne_ref_lv",
  "x73p00fcary1col_64row_edgel_uv2locn",
  "x73p00fcary1ne_ref_fuse4_nw",
  "x73p00fcary1ne_fuse2_r",
  "x73p00fcary1ne_fuse1a",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_skew2",
  "x73p00fcary1ne_security_m3_lv",
  "x73p00fcary1ne_fuse4_btm",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_skew3",
  "x73p00fcary1ne_m4f2_36nm",
  "x73p00fcary1col_64row_edger_fuse1a",
  "x73p00fcary1col_64row_edger_m1",
  "x73p00fcary1ne_m4f2_dot6_skew2_nw",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_replica",
  "x73p00fcary1col_64row_edgel_uv2locn_36nm",
  "x73p00fcary1ne_fuse2_nw_r",
  "x73p00fcary1ne_fuse3_nw",
  "x73p00fcary1ne_ref_fuse5a_btm",
  "x73p00fcary1ne_m4f2_m1_nw",
  "x73p00fcary1ne_m4f2_dot6_replica_nw",
  "x73p00fcary1col_64row_edger_fuse2",
  "x73p00fcary1ne_ref_fuse1a",
  "x73p00fcary1col_64row_edger_fuse3",
  "x73p00fcary1ne_ref_fuse3_nw",
  "x73p00fcary1ne_ref_m4f2",
  "x73p00fcary1ne_lv_f3_40nm",
  "x73p00fcary1col_64row_edgeinl_fuse1a",
  "x73p00fcary1ne_ref_fuse1a_nw",
  "x73p00fcary1col_64row_edgel_fuse2",
  "x73p00fcary1ne_ref_m4f2_dot6_nw",
  "x73p00fcary_lv_cell_m3",
  "x73p00fcary1ne_m4f2_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_dot6_skew2",
  "x73p00fcary1ne_ref_lv_f1_40nm",
  "x73p00fcary1col_64row_edgel_fuse3",
  "x73p00fcary1ne_m4f2_36nm_dot6_skew3",
  "x73p00fcary1ne_ref_m4f2_dot6_skew3",
  "x73p00fcary1col_64row_edgel_fuse1a",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_nw_r_36nm",
  "x73p00fcary1ne_fuse2_nw",
  "x73p00fcary1ne_ref_m4f2_dot6",
  "x73p00fcary1ne_ref_m4f2_nw_36nm",
  "x73p00fcary1col_64row_edgeinl_fuse5a_btm",
  "x73p00fcary1ne_fuse5a",
  "x73p00fcary1ne_m4f2_fix1_nw",
  "x73p00fcary1ne_lv_40nm",
  "x73p00fcary1ne_ref_fuse2_nw",
  "x73p00fcary1ne_fuse5b",
  "x73p00fcary1ne_fuse1a_nw",
  "x73p00fcary1col_64row_edger_fuse5a",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_lv_f2_40nm",
  "x73p00fcary1ne_m4f2_dot6",
  "x73p00fcary1col_64row_edgeinl_36nm",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_skew3",
  "x73p00fcary1ne_ref_lv_40nm",
  "x73p00fcary1ne_lv",
  "x73p00fcary1ne_fuse1_nw",
  "x73p00fcary1ne_ref_fuse5a",
  "x73p00fcary1ne_lv_f1",
  "x73p00fcary1ne_fuse5a_btm1",
  "x73p00fcary1ne_m4f2_r_36nm",
  "x73p00fcary1ne_fuse1",
  "x73p00fcary1ne_ref_fuse5b",
  "x73p00fcary1ne_lv_f2",
  "x73p00fcary1ne_fuse2",
  "x73p00fcary1ne_ref_m4f2_dot6_skew3_nw",
  "x73p00fcary1col_64row_edger_fuse5a_btm",
  "x73p00fcary1col_64row_edgeinl_fuse5a",
  "x73p00fcary1ne_m4f2_m1",
  "x73p00fcary1ne_ref_fuse1_nw",
  "x73p00fcary1ne_lv_f3",
  "x73p00fcary1col_64row_edgeinl_m1",
  "x73p00fcary1ne_fuse3",
  "x73p00fcary1ne_m4f2_36nm_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_dot6_replica",
  "x73p00fcary1col_64row_edgeinl",
  "x73p00fcary1ne_lv_f4",
  "x73p00fcary1ne_fuse4",
  "x73p00fcary1ne_fuse5a_btm",
  "x73p00fcary1ne_ref_m4f2_m1_nw",
  "x73p00fcary1col_64row_edgeinl_fuse2",
  "x73p00fcary1ne_m4f2",
  "x73p00fcary1ne_ref_fuse5b_nw",
  "x73p00fcary1ne_ref_security_m3_lv",
  "x73p00fcary1col_64row_edgel_fuse5a",
  "x73p00fcary1ne_fuse5",
  "x73p00fcary1col_64row_edger_36nm",
  "x73p00fcary1col_64row_edgeinl_fuse3",
  "x73p00fcary1ne_ref_fuse5a_btm1",
  "x73p00fcary1ne_ref_lv_f3_40nm",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary1ne_m4f2_fix1",
  "x73p00fcary1ne_m4f2_dot6_skew2",
  "x73p00fcary1ne_m4f2_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_m1",
  "x73p00fcary1ne_fuse5_nw",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew2",
  "x73p00fcary1ne_m4f2_dot6_skew3"
#endif
};

dr_metal3_noOPCDFM_ILWaiver: list of string = {
  "x73p00fcary1ne_m4f2_nw",
  "x73p00fcary1ne_ref_m4f2_nw",
  "x73p00fcary1col_64row_edger",
  "x73p00fcary1col_64row_edgel_uv2locn",
  "x73p00fcary1ne_ref_m4f2",
  "x73p00fcary1ne_m4f2_fix1_nw",
  "x73p00fcary1ne_m4f2_nw_r",
  "x73p00fcary1col_64row_edgeinl",
  "x73p00fcary1ne_m4f2",
  "x73p00fcary1ne_m4f2_r",
  "x73p00fcary1ne_m4f2_fix1",

#if ( _drPROJECT == _drx73b )
  "x73p00fcary1ne_m4f2_nw",
  "x73p00fcary1ne_m4f2_dot6_nw",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew3",
  "x73p00fcary1ne_lv_f1_40nm",
  "x73p00fcary1ne_ref_m4f2_dot6_skew2_nw",
  "x73p00fcary1col_64row_edgel_uv2locn_m1",
  "x73p00fcary1ne_ref_m4f2_dot6_replica_nw",
  "x73p00fcary1ne_ref_fuse5_nw",
  "x73p00fcary1ne_ref_lv_f1",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary40col_security_fuses",
  "x73p00fcary1ne_fuse5b_nw",
  "x73p00fcary1ne_ref_fuse1",
  "x73p00fcary1ne_lv1",
  "x73p00fcary1col_64row_edgel_fuse5a_btm",
  "x73p00fcary1ne_ref_lv_f2",
  "x73p00fcary1ne_m4f2_nw_36nm",
  "x73p00fcary1ne_ref_fuse2",
  "x73p00fcary1ne_ref_lv_f3",
  "x73p00fcary1ne_m4f2_dot6_skew3_nw",
  "x73p00fcary1ne_ref_fuse4_btm",
  "x73p00fcary1ne_ref_fuse3",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_nw",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_36nm",
  "x73p00fcary1ne_ref_lv_f4",
  "x73p00fcary1ne_ref_fuse4",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_skew3",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew3",
  "x73p00fcary1ne_fuse4_nw",
  "x73p00fcary1ne_ref_fuse5",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_replica",
  "x73p00fcary1col_64row_edger",
  "x73p00fcary1ne_lv_f2_40nm",
  "x73p00fcary1ne_ref_lv",
  "x73p00fcary1col_64row_edgel_uv2locn",
  "x73p00fcary1ne_ref_fuse4_nw",
  "x73p00fcary1ne_fuse2_r",
  "x73p00fcary1ne_fuse1a",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_skew2",
  "x73p00fcary1ne_security_m3_lv",
  "x73p00fcary1ne_fuse4_btm",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_skew3",
  "x73p00fcary1ne_m4f2_36nm",
  "x73p00fcary1col_64row_edger_fuse1a",
  "x73p00fcary1col_64row_edger_m1",
  "x73p00fcary1ne_m4f2_dot6_skew2_nw",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_replica",
  "x73p00fcary1col_64row_edgel_uv2locn_36nm",
  "x73p00fcary1ne_fuse2_nw_r",
  "x73p00fcary1ne_fuse3_nw",
  "x73p00fcary1ne_ref_fuse5a_btm",
  "x73p00fcary1ne_m4f2_m1_nw",
  "x73p00fcary1ne_m4f2_dot6_replica_nw",
  "x73p00fcary1col_64row_edger_fuse2",
  "x73p00fcary1ne_ref_fuse1a",
  "x73p00fcary1col_64row_edger_fuse3",
  "x73p00fcary1ne_ref_fuse3_nw",
  "x73p00fcary1ne_ref_m4f2",
  "x73p00fcary1ne_lv_f3_40nm",
  "x73p00fcary1col_64row_edgeinl_fuse1a",
  "x73p00fcary1ne_ref_fuse1a_nw",
  "x73p00fcary1col_64row_edgel_fuse2",
  "x73p00fcary1ne_ref_m4f2_dot6_nw",
  "x73p00fcary_lv_cell_m3",
  "x73p00fcary1ne_m4f2_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_dot6_skew2",
  "x73p00fcary1ne_ref_lv_f1_40nm",
  "x73p00fcary1col_64row_edgel_fuse3",
  "x73p00fcary1ne_m4f2_36nm_dot6_skew3",
  "x73p00fcary1ne_ref_m4f2_dot6_skew3",
  "x73p00fcary1col_64row_edgel_fuse1a",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_nw_r_36nm",
  "x73p00fcary1ne_fuse2_nw",
  "x73p00fcary1ne_ref_m4f2_dot6",
  "x73p00fcary1ne_ref_m4f2_nw_36nm",
  "x73p00fcary1col_64row_edgeinl_fuse5a_btm",
  "x73p00fcary1ne_fuse5a",
  "x73p00fcary1ne_m4f2_fix1_nw",
  "x73p00fcary1ne_lv_40nm",
  "x73p00fcary1ne_ref_fuse2_nw",
  "x73p00fcary1ne_fuse5b",
  "x73p00fcary1ne_fuse1a_nw",
  "x73p00fcary1col_64row_edger_fuse5a",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_lv_f2_40nm",
  "x73p00fcary1ne_m4f2_dot6",
  "x73p00fcary1col_64row_edgeinl_36nm",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_skew3",
  "x73p00fcary1ne_ref_lv_40nm",
  "x73p00fcary1ne_lv",
  "x73p00fcary1ne_fuse1_nw",
  "x73p00fcary1ne_ref_fuse5a",
  "x73p00fcary1ne_lv_f1",
  "x73p00fcary1ne_fuse5a_btm1",
  "x73p00fcary1ne_m4f2_r_36nm",
  "x73p00fcary1ne_fuse1",
  "x73p00fcary1ne_ref_fuse5b",
  "x73p00fcary1ne_lv_f2",
  "x73p00fcary1ne_fuse2",
  "x73p00fcary1ne_ref_m4f2_dot6_skew3_nw",
  "x73p00fcary1col_64row_edger_fuse5a_btm",
  "x73p00fcary1col_64row_edgeinl_fuse5a",
  "x73p00fcary1ne_m4f2_m1",
  "x73p00fcary1ne_ref_fuse1_nw",
  "x73p00fcary1ne_lv_f3",
  "x73p00fcary1col_64row_edgeinl_m1",
  "x73p00fcary1ne_fuse3",
  "x73p00fcary1ne_m4f2_36nm_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_dot6_replica",
  "x73p00fcary1col_64row_edgeinl",
  "x73p00fcary1ne_lv_f4",
  "x73p00fcary1ne_fuse4",
  "x73p00fcary1ne_fuse5a_btm",
  "x73p00fcary1ne_ref_m4f2_m1_nw",
  "x73p00fcary1col_64row_edgeinl_fuse2",
  "x73p00fcary1ne_m4f2",
  "x73p00fcary1ne_ref_fuse5b_nw",
  "x73p00fcary1ne_ref_security_m3_lv",
  "x73p00fcary1col_64row_edgel_fuse5a",
  "x73p00fcary1ne_fuse5",
  "x73p00fcary1col_64row_edger_36nm",
  "x73p00fcary1col_64row_edgeinl_fuse3",
  "x73p00fcary1ne_ref_fuse5a_btm1",
  "x73p00fcary1ne_ref_lv_f3_40nm",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary20col_security_m3",
  "x73p00fcary1ne_m4f2_fix1",
  "x73p00fcary1ne_m4f2_dot6_skew2",
  "x73p00fcary1ne_m4f2_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_m1",
  "x73p00fcary1ne_fuse5_nw",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew2",
  "x73p00fcary1ne_m4f2_dot6_skew3"  			
#endif
};


dr_m3fuse_id_ILWaiver: list of string = {
  "x73p00fcary1ne_fuse1",
  "x73p00fcary1ne_fuse1_nw",
  "x73p00fcary1ne_fuse1a",
  "x73p00fcary1ne_fuse1a_nw",
  "x73p00fcary1ne_m4f2",
  "x73p00fcary1ne_m4f2_dot6",
  "x73p00fcary1ne_m4f2_dot6_nw",
  "x73p00fcary1ne_m4f2_dot6_replica",
  "x73p00fcary1ne_m4f2_dot6_replica_nw",
  "x73p00fcary1ne_m4f2_dot6_skew2",
  "x73p00fcary1ne_m4f2_dot6_skew2_nw",
  "x73p00fcary1ne_m4f2_dot6_skew3",
  "x73p00fcary1ne_m4f2_dot6_skew3_nw",
  "x73p00fcary1ne_m4f2_nw",
  "x73p00fcary1ne_ref_fuse1",
  "x73p00fcary1ne_ref_fuse1_nw",
  "x73p00fcary1ne_ref_fuse1a",
  "x73p00fcary1ne_ref_fuse1a_nw",
  "x73p00fcary1ne_ref_m4f2",
  "x73p00fcary1ne_ref_m4f2_dot6",
  "x73p00fcary1ne_ref_m4f2_dot6_nw",
  "x73p00fcary1ne_ref_m4f2_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_dot6_replica_nw",
  "x73p00fcary1ne_ref_m4f2_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_dot6_skew2_nw",
  "x73p00fcary1ne_ref_m4f2_dot6_skew3",
  "x73p00fcary1ne_ref_m4f2_dot6_skew3_nw",
  "x73p00fcary1ne_ref_m4f2_nw",
  "x73p00fcary1ne_m4f2_nw_r",
  "x73p00fcary1ne_m4f2_r",   

#if ( _drPROJECT == _drx73b )
  //New additions based on Zhanping email chain 10/29/14
  "x73p00fcary1col_64row_edgel_uv2locn_36nm",
  "x73p00fcary1col_64row_edgeinl_36nm",
  "x73p00fcary1col_64row_edger_36nm",
  "x73p00fcary1ne_security_m3_lv",
  "x73p00fcary1ne_ref_m4f2_36nm",
  "x73p00fcary1ne_ref_m4f2_nw_36nm",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_replica",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_skew2",
  "x73p00fcary1ne_ref_m4f2_36nm_dot6_skew3",
  "x73p00fcary1ne_ref_m4f2_nw_36nm_dot6_skew3",
  "x73p00fcary1ne_m4f2_r_36nm",
  "x73p00fcary1ne_m4f2_36nm",
  "x73p00fcary1ne_m4f2_nw_r_36nm",
  "x73p00fcary1ne_m4f2_nw_36nm",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_replica",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew2",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_skew2",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_skew2",
  "x73p00fcary1ne_m4f2_36nm_dot6_skew2",
  "x73p00fcary1ne_m4f2_r_36nm_dot6_skew3",
  "x73p00fcary1ne_m4f2_36nm_dot6_skew3",
  "x73p00fcary1ne_m4f2_nw_r_36nm_dot6_skew3",
  "x73p00fcary1ne_m4f2_nw_36nm_dot6_skew3",
#endif


  //New additions based on Zhanping email chain 6/16/14
  "x73p00fcary1col_64row_edger",
  "x73p00fcary1col_64row_edgeinl",
  "x73p00fcary1col_64row_edgel_uv2locn",
  "x73p00fcary1ne_m4f2_fix1_nw",
  "x73p00fcary1ne_m4f2_fix1"
};


  // some tempaltes use the ER_LOCK_ID (ID_reservedPurpose10) for palcement checks   
  dr_erlockid_waive: list of string = {
"d8xxrtcnevm2vtuncontop_base",
"d8xxrtcnevm2vtunconbot_base",
"d8xxrtcnevm2vtunfil200m0a0",
"d8xxrtcnevm2vtunfil4npm1a1",
"d8xxrtcnevm2vtunfil2npm1a1",
"d8xxrtcnevm2vtunfil3npm1a1",
"d8xxrtcnevm2vtunfill6npp0m1c1",
"d8xxrtcnevm2vtunfil2npm0a0",
"d8xxrtcnevm2vtunswakside",
"d8xxrtcnevm2vtunfil1npm0a0",
"d8xxrtcnevm2vtunfill30pp0m0a0",
"d8xxrtcnevm2vtunfill30nn0m0a0",
"d8xxrtcnevm2vtunfill5npp0m0c0",
"d8xxrtcnevm2vtunfil100m0a0",
"d8xxrtcnevm2vtunbodm0half",
"d8xxrtcnevm2vtunfil2npm1a2",
};


dr_erlockid_7: list of string = {
"d87xrtcnevm2vtuncontop_base",
"d87xrtcnevm2vtunconbot_base",
"d87xrtcnevm2vtunfil200m0a0",
"d87xrtcnevm2vtunfil4npm1a1",
"d87xrtcnevm2vtunfil2npm1a1",
"d87xrtcnevm2vtunfil3npm1a1",
"d87xrtcnevm2vtunfill6npp0m1c1",
"d87xrtcnevm2vtunfil2npm0a0",
"d87xrtcnevm2vtunswakside",
"d87xrtcnevm2vtunfil1npm0a0",
"d87xrtcnevm2vtunfill30pp0m0a0",
"d87xrtcnevm2vtunfill30nn0m0a0",
"d87xrtcnevm2vtunfill5npp0m0c0",
"d87xrtcnevm2vtunfil100m0a0",
"d87xrtcnevm2vtunbodm0half",
"d87xrtcnevm2vtunfil2npm1a2",
};


dr_erlockid_8: list of string = {
"d88xrtcnevm2vtuncontop_base",
"d88xrtcnevm2vtunconbot_base",
"d88xrtcnevm2vtunfil200m0a0",
"d88xrtcnevm2vtunfil4npm1a1",
"d88xrtcnevm2vtunfil2npm1a1",
"d88xrtcnevm2vtunfil3npm1a1",
"d88xrtcnevm2vtunfill6npp0m1c1",
"d88xrtcnevm2vtunfil2npm0a0",
"d88xrtcnevm2vtunswakside",
"d88xrtcnevm2vtunfil1npm0a0",
"d88xrtcnevm2vtunfill30pp0m0a0",
"d88xrtcnevm2vtunfill30nn0m0a0",
"d88xrtcnevm2vtunfill5npp0m0c0",
"d88xrtcnevm2vtunfil100m0a0",
"d88xrtcnevm2vtunbodm0half",
"d88xrtcnevm2vtunfil2npm1a2",
};


dr_erlockid_0: list of string = {
"d80xrtcnevm2vtuncontop_base",
"d80xrtcnevm2vtunconbot_base",
"d80xrtcnevm2vtunfil200m0a0",
"d80xrtcnevm2vtunfil4npm1a1",
"d80xrtcnevm2vtunfil2npm1a1",
"d80xrtcnevm2vtunfil3npm1a1",
"d80xrtcnevm2vtunfill6npp0m1c1",
"d80xrtcnevm2vtunfil2npm0a0",
"d80xrtcnevm2vtunswakside",
"d80xrtcnevm2vtunfil1npm0a0",
"d80xrtcnevm2vtunfill30pp0m0a0",
"d80xrtcnevm2vtunfill30nn0m0a0",
"d80xrtcnevm2vtunfill5npp0m0c0",
"d80xrtcnevm2vtunfil100m0a0",
"d80xrtcnevm2vtunbodm0half",
"d80xrtcnevm2vtunfil2npm1a2",
};

dr_erlockid_waive=strcat ( dr_erlockid_waive,dr_erlockid_7);
dr_erlockid_waive=strcat ( dr_erlockid_waive,dr_erlockid_8);
dr_erlockid_waive=strcat ( dr_erlockid_waive,dr_erlockid_0);

   // N/PDRTOSYN layer for the new BGDIODE
   //Other cells is list from Alex 6Jun2013
   dr_PDR_maskDrawing_ILWaiver: list of string  = {
     "d8xmbgdiodehvm1",
     "d8xsmfcnvm4a",
     "d8xsmfcnvm4b",
     "d8xsmfcevm4a",
     "d8xsmfcevm4b",
     "d8xsmfcnvm6a",
     "d8xsmfcnvm6b",
     "d8xsmfctguvm4a",
     "d8xsmfctguvm4b",
     "d8xsmfcnvm4ap25pll",
     "d8xsmfcnvm7apll",
     "d8xsmfcnvm6alp",
     "d8xsmfctguvm4acfio",
     "d8xxmfcnvm4a",
     "d8xxmfcnvm4b",
     "d8xxmfcnvm6a",
     "d8xxmfcnvm6b",
     "d8xsdcpipnvm2",
     "d8xsdcpipnvm4",
     "d8xsdcpipnvm4e",
     "d8xsdcpipnvm6s",
     "d8xsdcpiptgevm2",
     "d8xsdcpiptgevm4",
     "d8xxdcpipnvm2",
     "d8xxdcpipnvm2p5",
     "d8xxdcpipnvm4",
     "d8xxdcpipnvm4p5",
     //"d8xsdcpiptgulvm4", 
     //"d8xsdcpintgulvm4",
     "c73p1krmrxclt_ffe_d8xsmfcnvm6a_dummy",  //hsd 2236
     "d8xsdcpiptgevm4v2", 		      //hsd 2495
     "d8xsdcpiptgevm2v2"		      //hsd 2495
   };

  dr_PDR_maskDrawing_7: list of string  = {
     "d87mbgdiodehvm1",
     "d87smfcnvm3d", "d87smfcnvm3d2",
     "d87smfcnvm4a", "d87smfcnvm4a2",
     "d87smfcnvm4b", "d87smfcnvm4b2",
     "d87smfcevm3d", "d87smfcevm3d2",
     "d87smfcevm4a", "d87smfcevm4a2",
     "d87smfcevm4b", "d87smfcevm4b2",
     "d87smfcnvm5d", "d87smfcnvm5d2",
     "d87smfcnvm6a", "d87smfcnvm6a2",
     "d87smfcnvm6b", "d87smfcnvm6b2",
     "d87smfctguvm3d", "d87smfctguvm3d2",
     "d87smfctguvm4a", "d87smfctguvm4a2",
     "d87smfctguvm4b", "d87smfctguvm4b2",
     "d87smfcnvm4ap25pll",
     "d87smfcnvm7d", "d87smfcnvm7d2",
     "d87smfcnvm7apll",
     "d87smfcnvm6alp",
     "d87smfctguvm4acfio",
     "d87xmfcnvm3d", "d87xmfcnvm3d2",
     "d87xmfcnvm4a", "d87xmfcnvm4a2",
     "d87xmfcnvm4b", "d87xmfcnvm4b2",
     "d87xmfcnvm5d", "d87xmfcnvm5d2",
     "d87xmfcnvm6a", "d87xmfcnvm6a2",
     "d87xmfcnvm6b", "d87xmfcnvm6b2",
     "d87sdcpipnvm2",
     "d87sdcpipnvm4",
     "d87sdcpipnvm4e",
     "d87sdcpipnvm6s",
     "d87sdcpiptgevm2",
     "d87sdcpiptgevm4",
     "d87xdcpipnvm2",
     "d87xdcpipnvm2p5",
     "d87xdcpipnvm4",
     "d87xdcpipnvm4p5",
     "d87sdcpiptgevm4v2", 		      
     "d87sdcpiptgevm2v2"
   };
dr_PDR_maskDrawing_8: list of string  = {
   };

dr_PDR_maskDrawing_0: list of string  = {
     "d80mbgdiodehvm1",
     "d80smfcnvm4a",
     "d80smfcnvm4b",
     "d80smfcevm4a",
     "d80smfcevm4b",
     "d80smfcnvm6a",
     "d80smfcnvm6b",
     "d80smfctguvm4a",
     "d80smfctguvm4b",
     "d80smfcnvm4ap25pll",
     "d80smfcnvm7apll",
     "d80smfcnvm6alp",
     "d80smfctguvm4acfio",
     "d80xmfcnvm4a",
     "d80xmfcnvm4b",
     "d80xmfcnvm6a",
     "d80xmfcnvm6b",
     "d80xsdcpipnvm2",
     "d80sdcpipnvm4",
     "d80sdcpipnvm4e",
     "d80sdcpipnvm6s",
     "d80sdcpiptgevm2",
     "d80sdcpiptgevm4",
     "d80xdcpipnvm2",
     "d80xdcpipnvm2p5",
     "d80xdcpipnvm4",
     "d80xdcpipnvm4p5",
     "d80sdcpiptgevm4v2", 		      
     "d80sdcpiptgevm2v2"
   };

dr_PDR_maskDrawing_ILWaiver= strcat(  dr_PDR_maskDrawing_ILWaiver, dr_PDR_maskDrawing_7);
dr_PDR_maskDrawing_ILWaiver= strcat(  dr_PDR_maskDrawing_ILWaiver, dr_PDR_maskDrawing_8);
dr_PDR_maskDrawing_ILWaiver= strcat(  dr_PDR_maskDrawing_ILWaiver, dr_PDR_maskDrawing_0);

dr_NDR_toSynDrawing_ILWaiver: list of string = {
     "d8xmbgdiodehvm1",
     "d8xsmfcnvm4a",
     "d8xsmfcnvm4b",
     "d8xsmfcevm4a",
     "d8xsmfcevm4b",
     "d8xsmfcnvm6a", 
     "d8xsmfcnvm6b", 
     "d8xsmfctguvm4a",
     "d8xsmfctguvm4b",
     "d8xsmfcnvm4ap25pll",
     "d8xsmfcnvm7apll",
     "d8xsmfcnvm6alp",
     "d8xsmfctguvm4acfio",
     "d8xxmfcnvm4a",
     "d8xxmfcnvm4b",
     "d8xxmfcnvm6a",
     "d8xxmfcnvm6b",
     "d8xsdcpipnvm2",
     "d8xsdcpipnvm4",
     "d8xsdcpipnvm4e",
     "d8xsdcpipnvm6s",
     "d8xsdcpiptgevm2",
     "d8xsdcpiptgevm4",
     "d8xxdcpipnvm2",
     "d8xxdcpipnvm2p5",
     "d8xxdcpipnvm4",
     "d8xxdcpipnvm4p5",
     //"d8xsdcpiptgulvm4", 
     //"d8xsdcpintgulvm4", 
     "c73p1krmrxclt_ffe_d8xsmfcnvm6a_dummy",  	//hsd 2236
     "d8xsdcpiptgevm4v2", 		       	//hsd 2495
     "d8xsdcpiptgevm2v2"		        //hsd 2495
   };

   dr_NDR_toSynDrawing_7: list of string = {
     "d87mbgdiodehvm1",
     "d87smfcnvm3d", "d87smfcnvm3d2",
     "d87smfcnvm4a", "d87smfcnvm4a2",
     "d87smfcnvm4b", "d87smfcnvm4b2",
     "d87smfcevm3d", "d87smfcevm3d2",
     "d87smfcevm4a", "d87smfcevm4a2",
     "d87smfcevm4b", "d87smfcevm4b2",
     "d87smfcnvm5d", "d87smfcnvm5d2",
     "d87smfcnvm6a", "d87smfcnvm6a2",
     "d87smfcnvm6b", "d87smfcnvm6b2",
     "d87smfctguvm3d", "d87smfctguvm3d2",
     "d87smfctguvm4a", "d87smfctguvm4a2",
     "d87smfctguvm4b", "d87smfctguvm4b2",
     "d87smfcnvm4ap25pll",
     "d87smfcnvm7d", "d87smfcnvm7d2",
     "d87smfcnvm7apll",
     "d87smfcnvm6alp",
     "d87smfctguvm4acfio",
     "d87xmfcnvm3d", "d87xmfcnvm3d2",
     "d87xmfcnvm4a", "d87xmfcnvm4a2",
     "d87xmfcnvm4b", "d87xmfcnvm4b2",
     "d87xmfcnvm5d", "d87xmfcnvm5d2",
     "d87xmfcnvm6a", "d87xmfcnvm6a2",
     "d87xmfcnvm6b", "d87xmfcnvm6b2",
     "d87sdcpipnvm2",
     "d87sdcpipnvm4",
     "d87sdcpipnvm4e",
     "d87sdcpipnvm6s",
     "d87sdcpiptgevm2",
     "d87sdcpiptgevm4",
     "d87xdcpipnvm2",
     "d87xdcpipnvm2p5",
     "d87xdcpipnvm4",
     "d87xdcpipnvm4p5",
     "d87sdcpiptgevm4v2",
     "d87sdcpiptgevm2v2"
   };


  dr_NDR_toSynDrawing_8: list of string = {
   };

  dr_NDR_toSynDrawing_0: list of string = {
     "d80mbgdiodehvm1",
     "d80smfcnvm4a",
     "d80smfcnvm4b",
     "d80smfcevm4a",
     "d80smfcevm4b",
     "d80smfcnvm6a", 
     "d80smfcnvm6b", 
     "d80smfctguvm4a",
     "d80smfctguvm4b",
     "d80smfcnvm4ap25pll",
     "d80smfcnvm7apll",
     "d80smfcnvm6alp",
     "d80smfctguvm4acfio",
     "d80xmfcnvm4a",
     "d80xmfcnvm4b",
     "d80xmfcnvm6a",
     "d80xmfcnvm6b",
     "d80sdcpipnvm2",
     "d80sdcpipnvm4",
     "d80sdcpipnvm4e",
     "d80sdcpipnvm6s",
     "d80sdcpiptgevm2",
     "d80sdcpiptgevm4",
     "d80xdcpipnvm2",
     "d80xdcpipnvm2p5",
     "d80xdcpipnvm4",
     "d80xdcpipnvm4p5",
     "d80sdcpiptgevm4v2",
     "d80sdcpiptgevm2v2"
   };

dr_NDR_toSynDrawing_ILWaiver= strcat (dr_NDR_toSynDrawing_ILWaiver,dr_NDR_toSynDrawing_7);
dr_NDR_toSynDrawing_ILWaiver= strcat (dr_NDR_toSynDrawing_ILWaiver,dr_NDR_toSynDrawing_8);
dr_NDR_toSynDrawing_ILWaiver= strcat (dr_NDR_toSynDrawing_ILWaiver,dr_NDR_toSynDrawing_0);

   dr_PDR_toSynDrawing_ILWaiver: list of string  = {
	 "d8xsmfcnvm4c",
	 "d8xsmfcevm4c",
	 "d8xsmfcnvm6c",
	 "d8xxmfcnvm4c",
	 "d8xxmfcnvm6c",
	 "d8xsdcpintgevm2",
	 "d8xsdcpintgevm4",
     "d8xsdcpintgevm2_s2s",  //hsd 2282
     "d8xsdcpintgevm4_s2s"   //hsd 2282
  };

 dr_PDR_toSynDrawing_7: list of string  = {
	 "d87smfcnvm4c",
	 "d87smfcevm4c",
	 "d87smfcnvm6c",
	 "d87xmfcnvm4c",
	 "d87xmfcnvm6c",
	 "d87sdcpintgevm2",
	 "d87sdcpintgevm4",
     "d87sdcpintgevm2_s2s",  //hsd 2282
     "d87sdcpintgevm4_s2s"   //hsd 2282
  };

 dr_PDR_toSynDrawing_8: list of string  = {
	 "d88smfcnvm4c",
	 "d88smfcevm4c",
	 "d88smfcnvm6c",
	 "d88xmfcnvm4c",
	 "d88xmfcnvm6c",
	 "d88sdcpintgevm2",
	 "d88sdcpintgevm4",
     "d88sdcpintgevm2_s2s",  //hsd 2282
     "d88sdcpintgevm4_s2s"   //hsd 2282
  };

 dr_PDR_toSynDrawing_0: list of string  = {
	 "d80smfcnvm4c",
	 "d80smfcevm4c",
	 "d80smfcnvm6c",
	 "d80xmfcnvm4c",
	 "d80xmfcnvm6c",
	 "d80sdcpintgevm2",
	 "d80sdcpintgevm4",
     "d80sdcpintgevm2_s2s",  //hsd 2282
     "d80sdcpintgevm4_s2s"   //hsd 2282
  };

dr_PDR_toSynDrawing_ILWaiver= strcat(dr_PDR_toSynDrawing_ILWaiver ,dr_PDR_toSynDrawing_7);
dr_PDR_toSynDrawing_ILWaiver= strcat(dr_PDR_toSynDrawing_ILWaiver ,dr_PDR_toSynDrawing_8);
dr_PDR_toSynDrawing_ILWaiver= strcat(dr_PDR_toSynDrawing_ILWaiver ,dr_PDR_toSynDrawing_0);

   dr_NDR_maskDrawing_ILWaiver: list of string = {
	 "d8xsmfcnvm4c",
	 "d8xsmfcevm4c",
	 "d8xsmfcnvm6c",
	 "d8xxmfcnvm4c",
	 "d8xxmfcnvm6c",
	 "d8xsdcpintgevm2",
	 "d8xsdcpintgevm4",
     "d8xsdcpintgevm2_s2s",  //hsd 2282
     "d8xsdcpintgevm4_s2s"   //hsd 2282
  };
  
dr_NDR_maskDrawing_7: list of string = {
	 "d87smfcnvm4c",
	 "d87smfcevm4c",
	 "d87smfcnvm6c",
	 "d87xmfcnvm4c",
	 "d87xmfcnvm6c",
	 "d87sdcpintgevm2",
	 "d87sdcpintgevm4",
     "d87sdcpintgevm2_s2s",  //hsd 2282
     "d87sdcpintgevm4_s2s"   //hsd 2282
  };
   
dr_NDR_maskDrawing_8: list of string = {
	 "d88smfcnvm4c",
	 "d88smfcevm4c",
	 "d88smfcnvm6c",
	 "d88xmfcnvm4c",
	 "d88xmfcnvm6c",
	 "d88sdcpintgevm2",
	 "d88sdcpintgevm4",
     "d88sdcpintgevm2_s2s",  //hsd 2282
     "d88sdcpintgevm4_s2s"   //hsd 2282
  };

dr_NDR_maskDrawing_0: list of string = {
	 "d80smfcnvm4c",
	 "d80smfcevm4c",
	 "d80smfcnvm6c",
	 "d80xmfcnvm4c",
	 "d80xmfcnvm6c",
	 "d80sdcpintgevm2",
	 "d80sdcpintgevm4",
     "d80sdcpintgevm2_s2s",  //hsd 2282
     "d80sdcpintgevm4_s2s"   //hsd 2282
  };

dr_NDR_maskDrawing_ILWaiver=strcat(dr_NDR_maskDrawing_ILWaiver,dr_NDR_maskDrawing_7);
dr_NDR_maskDrawing_ILWaiver=strcat(dr_NDR_maskDrawing_ILWaiver,dr_NDR_maskDrawing_8);
dr_NDR_maskDrawing_ILWaiver=strcat(dr_NDR_maskDrawing_ILWaiver,dr_NDR_maskDrawing_0);

 dr_XVN_maskDrawing_ILWaiver: list of string = {"d8xmbgdiodehvm1"};
dr_XVN_maskDrawing_7: list of string = {"d87mbgdiodehvm1"};
dr_XVN_maskDrawing_8: list of string = {"d88mbgdiodehvm1"};
dr_XVN_maskDrawing_0: list of string = {"d80mbgdiodehvm1"};

dr_XVN_maskDrawing_ILWaiver=strcat( dr_XVN_maskDrawing_ILWaiver,dr_XVN_maskDrawing_7);
dr_XVN_maskDrawing_ILWaiver=strcat( dr_XVN_maskDrawing_ILWaiver,dr_XVN_maskDrawing_8);
dr_XVN_maskDrawing_ILWaiver=strcat( dr_XVN_maskDrawing_ILWaiver,dr_XVN_maskDrawing_0);

  // for x73b
  dr_bitcell3_reservedPurpose7_ILWaiver: list of string = {"x73hddpbitlp"};
  dr_bitcell3_reservedPurpose6_ILWaiver: list of string = {"x73sdpbitlp"};
  dr_bitcell3_reservedPurpose5_ILWaiver: list of string = {"x73hpdpbitlp2", "x73hpdpbitlp"};

  //IL waiver for Catchcup (S.Talukdar)
  dr_metal0_plug_ILWaiver: list of string = {"x73btsvccalt1", "d8xltsv_ccsymb","x73btsvccalt1sub1","d8xltsv_ccalt1sub1"};
dr_metal0_plug_7: list of string = {"x73btsvccalt1", "d87ltsv_ccsymb","x73btsvccalt1sub1"};
dr_metal0_plug_8: list of string = {"x73btsvccalt1", "d88ltsv_ccsymb","x73btsvccalt1sub1"};
dr_metal0_plug_ILWaiver=strcat(dr_metal0_plug_ILWaiver,dr_metal0_plug_7);
dr_metal0_plug_ILWaiver=strcat(dr_metal0_plug_ILWaiver,dr_metal0_plug_8);

  dr_metal1_plug_ILWaiver: list of string = {"x73btsvccalt1", "d8xltsv_ccsymb","x73btsvccalt1sub1","d8xltsv_ccalt1sub1"};
 dr_metal1_plug_7: list of string = { "d87ltsv_ccsymb"};
dr_metal1_plug_8: list of string = { "d88ltsv_ccsymb"};
dr_metal1_plug_0: list of string ={"d80ltsv_ccsymb"};
dr_metal1_plug_ILWaiver=strcat( dr_metal1_plug_ILWaiver, dr_metal1_plug_7);
dr_metal1_plug_ILWaiver=strcat( dr_metal1_plug_ILWaiver, dr_metal1_plug_8);
dr_metal1_plug_ILWaiver=strcat( dr_metal1_plug_ILWaiver, dr_metal1_plug_0);

  dr_metal2_plug_ILWaiver: list of string = {"x73btsvccalt1", "d8xltsv_ccsymb","x73btsvccalt1sub1","d8xltsv_ccalt1sub1"};
dr_metal2_plug_7: list of string = {"d87ltsv_ccsymb"};
dr_metal2_plug_8: list of string = { "d88ltsv_ccsymb"};
dr_metal2_plug_0: list of string = { "d80ltsv_ccsymb"};
dr_metal2_plug_ILWaiver=strcat( dr_metal2_plug_ILWaiver, dr_metal2_plug_7);
dr_metal2_plug_ILWaiver=strcat( dr_metal2_plug_ILWaiver, dr_metal2_plug_8);
dr_metal2_plug_ILWaiver=strcat( dr_metal2_plug_ILWaiver, dr_metal2_plug_0);


 dr_tsvcc_drawing1_ILWaiver: list of string = {"x73btsvccalt1", "d8xltsv_ccsymb", "d81tsvccalt1_cc","d8xltsv_ccsymb_prs"};
dr_tsvcc_drawing1_7: list of string = { "d87ltsv_ccsymb", "d88tsvccalt1_cc"};
dr_tsvcc_drawing1_8: list of string = { "d88ltsv_ccsymb", "d88tsvccalt1_cc"};
dr_tsvcc_drawing1_0: list of string = {"d80ltsv_ccsymb","d80tsvccalt1_cc"};
dr_tsvcc_drawing1_ILWaiver= strcat(dr_tsvcc_drawing1_ILWaiver,dr_tsvcc_drawing1_7);
dr_tsvcc_drawing1_ILWaiver= strcat(dr_tsvcc_drawing1_ILWaiver,dr_tsvcc_drawing1_8);
dr_tsvcc_drawing1_ILWaiver= strcat(dr_tsvcc_drawing1_ILWaiver,dr_tsvcc_drawing1_0);


dr_via0_densityID_ILWaiver: list of string = {"x73btsvccalt1", "d8xltsv_ccsymb", "x73btsvccspcralt1",
  "d8xltsv_ccspcralt1","d8xltsv_ccsymb_prs"};

dr_via0_densityID_7: list of string = {"d87ltsv_ccsymb","d87ltsv_ccspcralt1","d87tsvccalt1_cc"};
dr_via0_densityID_8: list of string = {"d88ltsv_ccsymb","d88ltsv_ccspcralt1","d88ltsvccalt1_cc"};
dr_via0_densityID_0: list of string = { "d80ltsv_ccsymb","d80ltsv_ccspcralt1","d80ltsvccalt1_cc"};

dr_via0_densityID_ILWaiver=strcat( dr_via0_densityID_ILWaiver,dr_via0_densityID_7);
dr_via0_densityID_ILWaiver=strcat( dr_via0_densityID_ILWaiver,dr_via0_densityID_8);
dr_via0_densityID_ILWaiver=strcat( dr_via0_densityID_ILWaiver,dr_via0_densityID_0);

  dr_viacon_densityID_ILWaiver: list of string = {"x73btsvccalt1", "d8xltsv_ccsymb", "x73btsvccspcralt1", "d8xltsv_ccspcralt1",
    "d81tsvccalt1_cc","d8xltsv_ccsymb_prs"};
dr_viacon_densityID_7: list of string = { "d87ltsv_ccsymb", "d87ltsv_ccspcralt1","d87tsvccalt1_cc"};
dr_viacon_densityID_8: list of string = { "d88ltsv_ccsymb","d88ltsv_ccspcralt1","d88tsvccalt1_cc"};
dr_viacon_densityID_0: list of string = {"d80ltsv_ccsymb","d80ltsv_ccspcralt1","d80tsvccalt1_cc"};

  //Nauman Khan:
  dr_diffcon_fillerIgnore_ILWaiver: list of string =    { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

 dr_diffcon_fillerIgnore_7: list of string =    { "d87ltsv_emgr_bottom", "d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap", "d87ltsv_emgr_right", "d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner", "d87ltsv_emgr_toprightcorner" };
 dr_diffcon_fillerIgnore_8: list of string =    { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d88ltsv_emgr_top_gap", "d88ltsv_emgr_left", "d88ltsv_emgr_left_gap",  "d88ltsv_emgr_right",  "d88ltsv_emgr_right_gap", "d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner", "d88ltsv_emgr_topleftcorner", "d88ltsv_emgr_toprightcorner" };

dr_diffcon_fillerIgnore_0: list of string =    {  "d80ltsv_emgr_bottom", "d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap", "d80ltsv_emgr_left", "d80ltsv_emgr_left_gap", "d80ltsv_emgr_right", "d80ltsv_emgr_right_gap",  "d80ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner",  "d80ltsv_emgr_toprightcorner" };

dr_diffcon_fillerIgnore_ILWaiver=strcat( dr_diffcon_fillerIgnore_ILWaiver,dr_diffcon_fillerIgnore_7);
dr_diffcon_fillerIgnore_ILWaiver=strcat( dr_diffcon_fillerIgnore_ILWaiver,dr_diffcon_fillerIgnore_8);
dr_diffcon_fillerIgnore_ILWaiver=strcat( dr_diffcon_fillerIgnore_ILWaiver,dr_diffcon_fillerIgnore_0);


  dr_diffcon_keepGenAway_ILWaiver: list of string =  { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

 dr_diffcon_keepGenAway_7: list of string =  {"d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap", "d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap", "d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };

dr_diffcon_keepGenAway_8: list of string =  { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap", "d88ltsv_emgr_top", "d88ltsv_emgr_top_gap", "d88ltsv_emgr_left", "d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };

dr_diffcon_keepGenAway_0: list of string =  { "d80ltsv_emgr_bottom", "d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left", "d80ltsv_emgr_left_gap", "d80ltsv_emgr_right", "d80ltsv_emgr_right_gap", "d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner", "d80ltsv_emgr_topleftcorner", "d80ltsv_emgr_toprightcorner" };

dr_diffcon_keepGenAway_ILWaiver= strcat( dr_diffcon_keepGenAway_ILWaiver,dr_diffcon_keepGenAway_7);
dr_diffcon_keepGenAway_ILWaiver= strcat( dr_diffcon_keepGenAway_ILWaiver,dr_diffcon_keepGenAway_8);
dr_diffcon_keepGenAway_ILWaiver= strcat( dr_diffcon_keepGenAway_ILWaiver,dr_diffcon_keepGenAway_0);

 dr_metal0_densityID_ILWaiver: list of string =     { "x73tsv_tc0emgrdx73aogd", "d8xltsv_emgrd1273ogd", "x73tsv_tc0emgrdx73aogd_gap", "x73tsv_tc0emgrdx73aogd_gap_2p52", "d8xltsv_emgrd1273ogd_gap_2p52", "x73tsv_tc0emgrdx73aogd_gap_2p24", "d8xltsv_emgrd1273ogd_gap_2p24", "x73tsv_tc0emgrdx73aogd_gap_1p96", "d8xltsv_emgrd1273ogd_gap_1p96", "d8xltsv_emgrd1273ogd_gap", "x73tsv_tc0emgrdx73apgd", "d8xltsv_emgrd1273pgd", "x73tsv_tc0emgrdx73apgd_gap", "d8xltsv_emgrd1273pgd_gap", "x73tsv_tc0emgrdx73acrn", "d8xltsv_emgrd1273crn"};

dr_metal0_densityID_7: list of string =     { "d87ltsv_emgrd1273ogd","d87ltsv_emgrd1273ogd_gap_2p52","d87ltsv_emgrd1273ogd_gap_2p24","d87ltsv_emgrd1273ogd_gap_1p96", "d87ltsv_emgrd1273ogd_gap","d87ltsv_emgrd1273pgd","d87ltsv_emgrd1273pgd_gap","d87ltsv_emgrd1273crn"};

dr_metal0_densityID_8: list of string =     {"d88ltsv_emgrd1273ogd", "x73tsv_tc0emgrdx73aogd_gap","d88ltsv_emgrd1273ogd_gap_2p52", "d88ltsv_emgrd1273ogd_gap_2p24","d88ltsv_emgrd1273ogd_gap_1p96", "d88ltsv_emgrd1273ogd_gap", "d88ltsv_emgrd1273pgd","d88ltsv_emgrd1273pgd_gap","d88ltsv_emgrd1273crn"};

dr_metal0_densityID_0: list of string =     { "d80ltsv_emgrd1273ogd","d80ltsv_emgrd1273ogd_gap_2p52", "d80ltsv_emgrd1273ogd_gap_2p24","d80ltsv_emgrd1273ogd_gap_1p96", "d80ltsv_emgrd1273ogd_gap","d80ltsv_emgrd1273pgd", "d80ltsv_emgrd1273pgd_gap","d80ltsv_emgrd1273crn"};
dr_metal0_densityID_ILWaiver=strcat(dr_metal0_densityID_ILWaiver,dr_metal0_densityID_7);
dr_metal0_densityID_ILWaiver=strcat(dr_metal0_densityID_ILWaiver,dr_metal0_densityID_8);
dr_metal0_densityID_ILWaiver=strcat(dr_metal0_densityID_ILWaiver,dr_metal0_densityID_0);

  dr_metal0_fillerIgnore_ILWaiver: list of string =  { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner",  "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner"};

dr_metal0_fillerIgnore_7: list of string =  {"d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner", "d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner", "d87ltsv_emgr_toprightcorner"};

dr_metal0_fillerIgnore_8: list of string =  {"d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top", "d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap",  "d88ltsv_emgr_right", "d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner"};

dr_metal0_fillerIgnore_0: list of string =  { "d80ltsv_emgr_bottom", "d80ltsv_emgr_bottom_gap", "d80ltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d88ltsv_emgr_top_gap", "d80ltsv_emgr_left","d80ltsv_emgr_left_gap", "d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner"};

dr_metal0_fillerIgnore_ILWaiver= strcat( dr_metal0_fillerIgnore_ILWaiver,dr_metal0_fillerIgnore_7);
dr_metal0_fillerIgnore_ILWaiver= strcat( dr_metal0_fillerIgnore_ILWaiver,dr_metal0_fillerIgnore_8);
dr_metal0_fillerIgnore_ILWaiver= strcat( dr_metal0_fillerIgnore_ILWaiver,dr_metal0_fillerIgnore_0);

dr_metal0_keepGenAway_ILWaiver: list of string =   { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner",  "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner"};

dr_metal0_keepGenAway_7: list of string =   { "d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap", "d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner"};

dr_metal0_keepGenAway_8: list of string =   {"d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner", "d80ltsv_emgr_toprightcorner"};

dr_metal0_keepGenAway_0: list of string =   {  "d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner"};

dr_metal0_keepGenAway_ILWaiver=strcat(dr_metal0_keepGenAway_ILWaiver,dr_metal0_keepGenAway_7);
dr_metal0_keepGenAway_ILWaiver=strcat(dr_metal0_keepGenAway_ILWaiver,dr_metal0_keepGenAway_8);
dr_metal0_keepGenAway_ILWaiver=strcat(dr_metal0_keepGenAway_ILWaiver,dr_metal0_keepGenAway_0);

  dr_metal1_densityID_ILWaiver: list of string =     { "x73tsv_tc0emgrdx73aogd", "d8xltsv_emgrd1273ogd", "x73tsv_tc0emgrdx73aogd_gap", "x73tsv_tc0emgrdx73aogd_gap_2p52", "d8xltsv_emgrd1273ogd_gap_2p52", "x73tsv_tc0emgrdx73aogd_gap_2p24", "d8xltsv_emgrd1273ogd_gap_2p24", "x73tsv_tc0emgrdx73aogd_gap_1p96", "d8xltsv_emgrd1273ogd_gap_1p96", "d8xltsv_emgrd1273ogd_gap", "x73tsv_tc0emgrdx73apgd", "d8xltsv_emgrd1273pgd", "x73tsv_tc0emgrdx73apgd_gap", "d8xltsv_emgrd1273pgd_gap", "x73tsv_tc0emgrdx73acrn", "d8xltsv_emgrd1273crn" };


 dr_metal1_densityID_7: list of string =     { "d87ltsv_emgrd1273ogd","d87ltsv_emgrd1273ogd_gap_2p52", "x73tsv_tc0emgrdx73aogd_gap_2p24", "d87ltsv_emgrd1273ogd_gap_2p24","d87ltsv_emgrd1273ogd_gap_1p96", "d87ltsv_emgrd1273ogd_gap","d87ltsv_emgrd1273pgd_gap","d87ltsv_emgrd1273crn" };

 dr_metal1_densityID_8: list of string =     {"d88ltsv_emgrd1273ogd", "x73tsv_tc0emgrdx73aogd_gap_2p52","d88ltsv_emgrd1273ogd_gap_2p24","d88ltsv_emgrd1273ogd_gap_1p96", "d88ltsv_emgrd1273ogd_gap","d88ltsv_emgrd1273pgd","d88ltsv_emgrd1273pgd_gap","d88ltsv_emgrd1273crn" };

dr_metal1_densityID_0: list of string =     {"d80ltsv_emgrd1273ogd","d80ltsv_emgrd1273ogd_gap_2p52","d80ltsv_emgrd1273ogd_gap_2p24","d80ltsv_emgrd1273ogd_gap_1p96", "d80ltsv_emgrd1273ogd_gap","d88ltsv_emgrd1273pgd","d88ltsv_emgrd1273pgd_gap","d88ltsv_emgrd1273crn" };

 
dr_metal1_densityID_ILWaiver=strcat(  dr_metal1_densityID_ILWaiver, dr_metal1_densityID_7);
dr_metal1_densityID_ILWaiver=strcat(  dr_metal1_densityID_ILWaiver, dr_metal1_densityID_8);
dr_metal1_densityID_ILWaiver=strcat(  dr_metal1_densityID_ILWaiver, dr_metal1_densityID_0);

  dr_metal1_fillerIgnore_ILWaiver: list of string =  { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

dr_metal1_fillerIgnore7: list of string =  { "x73tsv_tc2emgr_bottom", "d87ltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d87ltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d87ltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d87ltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d87ltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d87ltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d87ltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d87ltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d87ltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d87ltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d87ltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d87ltsv_emgr_toprightcorner" };

dr_metal1_fillerIgnore8: list of string =  { "x73tsv_tc2emgr_bottom", "d88ltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d88ltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d88ltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d88ltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d88ltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d88ltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d88ltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d88ltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d88ltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d88ltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d88ltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d88ltsv_emgr_toprightcorner" };


dr_metal1_fillerIgnore0: list of string =  {  "d80ltsv_emgr_bottom", "d80ltsv_emgr_bottom_gap", "d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap", "d88ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };


dr_metal1_fillerIgnore_ILWaiver=strcat( dr_metal1_fillerIgnore_ILWaiver ,dr_metal1_fillerIgnore7);
dr_metal1_fillerIgnore_ILWaiver=strcat( dr_metal1_fillerIgnore_ILWaiver ,dr_metal1_fillerIgnore8);
dr_metal1_fillerIgnore_ILWaiver=strcat( dr_metal1_fillerIgnore_ILWaiver ,dr_metal1_fillerIgnore0);

  dr_metal1_keepGenAway_ILWaiver: list of string =   { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };
  dr_metal1_keepGenAway7: list of string =   { "x73tsv_tc2emgr_bottom", "d87ltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d87ltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d87ltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d87ltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d87ltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d87ltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d87ltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d87ltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d87ltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d87ltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d87ltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d87ltsv_emgr_toprightcorner" };

 dr_metal1_keepGenAway8: list of string =   { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap", "d88ltsv_emgr_bottomleftcorner","d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };

dr_metal1_keepGenAway0: list of string =   {"d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap", "d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };

dr_metal1_keepGenAway_ILWaiver= strcat(  dr_metal1_keepGenAway_ILWaiver, dr_metal1_keepGenAway7);
dr_metal1_keepGenAway_ILWaiver= strcat(  dr_metal1_keepGenAway_ILWaiver, dr_metal1_keepGenAway8);
dr_metal1_keepGenAway_ILWaiver= strcat(  dr_metal1_keepGenAway_ILWaiver, dr_metal1_keepGenAway0);

  dr_metal2_fillerIgnore_ILWaiver: list of string =  { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

 dr_metal2_fillerIgnore7: list of string =  { "d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap", "d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };

dr_metal2_fillerIgnore8: list of string =  { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner", "d88ltsv_emgr_toprightcorner" };

 dr_metal2_fillerIgnore0: list of string =  {"d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d88ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner", "d80ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };

dr_metal2_fillerIgnore_ILWaiver=strcat(dr_metal2_fillerIgnore_ILWaiver,dr_metal2_fillerIgnore7);
dr_metal2_fillerIgnore_ILWaiver=strcat(dr_metal2_fillerIgnore_ILWaiver,dr_metal2_fillerIgnore8);
dr_metal2_fillerIgnore_ILWaiver=strcat(dr_metal2_fillerIgnore_ILWaiver,dr_metal2_fillerIgnore0);

  dr_metal2_keepGenAway_ILWaiver: list of string =   { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

 dr_metal2_keepGenAway7: list of string =   { "d87ltsv_emgr_bottom", "d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap", "d87ltsv_emgr_right", "d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner", "d87ltsv_emgr_toprightcorner" };

 dr_metal2_keepGenAway8: list of string =   { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top", "d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right", "d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner", "d88ltsv_emgr_toprightcorner" };

dr_metal2_keepGenAway0: list of string =   { "d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top", "d88ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };

dr_metal2_keepGenAway_ILWaiver= strcat(  dr_metal2_keepGenAway_ILWaiver,dr_metal2_keepGenAway7);
dr_metal2_keepGenAway_ILWaiver= strcat(  dr_metal2_keepGenAway_ILWaiver,dr_metal2_keepGenAway8);
dr_metal2_keepGenAway_ILWaiver= strcat(  dr_metal2_keepGenAway_ILWaiver,dr_metal2_keepGenAway0);

  dr_ndiff_fillerIgnore_ILWaiver: list of string =   { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

  dr_ndiff_fillerIgnore7: list of string =   {"d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top",  "d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap", "d87ltsv_emgr_right", "d87ltsv_emgr_right_gap", "d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };

  dr_ndiff_fillerIgnore8: list of string =   {"d88ltsv_emgr_bottom", "d88ltsv_emgr_bottom_gap", "d88ltsv_emgr_top","d88ltsv_emgr_top_gap", "d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner", "d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };

dr_ndiff_fillerIgnore0: list of string =   {"d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner", "d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };

dr_ndiff_fillerIgnore_ILWaiver=strcat(dr_ndiff_fillerIgnore_ILWaiver, dr_ndiff_fillerIgnore7);
dr_ndiff_fillerIgnore_ILWaiver=strcat(dr_ndiff_fillerIgnore_ILWaiver, dr_ndiff_fillerIgnore8);
dr_ndiff_fillerIgnore_ILWaiver=strcat(dr_ndiff_fillerIgnore_ILWaiver, dr_ndiff_fillerIgnore0);


  dr_ndiff_keepGenAway_ILWaiver: list of string =    { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

 dr_ndiff_keepGenAway7: list of string =    {"d87ltsv_emgr_bottom", "d87ltsv_emgr_bottom_gap", "d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left", "d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner", "d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner", "d87ltsv_emgr_toprightcorner" };

dr_ndiff_keepGenAway8: list of string =    { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d88ltsv_emgr_bottomrightcorner", "d88ltsv_emgr_topleftcorner", "d88ltsv_emgr_toprightcorner" };

dr_ndiff_keepGenAway0: list of string =    { "d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner", "d80ltsv_emgr_topleftcorner", "d80ltsv_emgr_toprightcorner" };

dr_ndiff_keepGenAway_ILWaiver=strcat( dr_ndiff_keepGenAway_ILWaiver,  dr_ndiff_keepGenAway7);
dr_ndiff_keepGenAway_ILWaiver=strcat( dr_ndiff_keepGenAway_ILWaiver,  dr_ndiff_keepGenAway8);
dr_ndiff_keepGenAway_ILWaiver=strcat( dr_ndiff_keepGenAway_ILWaiver,  dr_ndiff_keepGenAway0);

  dr_nwell_fillerIgnore_ILWaiver: list of string =   { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

  dr_nwell_fillerIgnore7: list of string =   {"d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap", "d87ltsv_emgr_left","d87ltsv_emgr_left_gap", "d87ltsv_emgr_right", "d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner", "d87ltsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };

dr_nwell_fillerIgnore8: list of string =   { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap", "d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner", "d88ltsv_emgr_topleftcorner", "d88ltsv_emgr_toprightcorner" };
dr_nwell_fillerIgnore0: list of string =   { "d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap", "d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner", "d80ltsv_emgr_topleftcorner", "d80ltsv_emgr_toprightcorner" };

dr_nwell_fillerIgnore_ILWaiver= strcat( dr_nwell_fillerIgnore_ILWaiver, dr_nwell_fillerIgnore7);
dr_nwell_fillerIgnore_ILWaiver= strcat( dr_nwell_fillerIgnore_ILWaiver, dr_nwell_fillerIgnore8);
dr_nwell_fillerIgnore_ILWaiver= strcat( dr_nwell_fillerIgnore_ILWaiver, dr_nwell_fillerIgnore0);


dr_nwell_keepGenAway_ILWaiver: list of string =    { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

dr_nwell_keepGenAway_7: list of string =    { "d87ltsv_emgr_bottom", "d87ltsv_emgr_bottom_gap", "d87ltsv_emgr_top","d87ltsv_emgr_top_gap", "d87ltsv_emgr_left","d87ltsv_emgr_left_gap", "d87ltsv_emgr_right", "d87ltsv_emgr_right_gap", "d87ltsv_emgr_bottomleftcorner", "d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };


dr_nwell_keepGenAway_8: list of string =    { "d88ltsv_emgr_bottom", "d88ltsv_emgr_bottom_gap", "d88ltsv_emgr_top","d88ltsv_emgr_top_gap", "d88ltsv_emgr_left","d88ltsv_emgr_left_gap", "d88ltsv_emgr_right", "d88ltsv_emgr_right_gap", "d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner", "d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };

dr_nwell_keepGenAway_0: list of string = {"d80ltsv_emgr_bottom", "d80ltsv_emgr_bottom_gap", "d80ltsv_emgr_top","d80ltsv_emgr_top_gap", "d80ltsv_emgr_left","d80ltsv_emgr_left_gap", "d80ltsv_emgr_right", "d80ltsv_emgr_right_gap", "d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner", "d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };
dr_nwell_keepGenAway_ILWaiver= strcat( dr_nwell_keepGenAway_ILWaiver, dr_nwell_keepGenAway_7);
dr_nwell_keepGenAway_ILWaiver= strcat( dr_nwell_keepGenAway_ILWaiver, dr_nwell_keepGenAway_8);
dr_nwell_keepGenAway_ILWaiver= strcat( dr_nwell_keepGenAway_ILWaiver, dr_nwell_keepGenAway_0);

  dr_pdiff_fillerIgnore_ILWaiver: list of string =   { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

dr_pdiff_fillerIgnore7: list of string =   {"d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };

 dr_pdiff_fillerIgnore8: list of string =   {"d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d88ltsv_edr_nwell_keepGenAway_ILWaivermgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap", "d88ltsv_emgr_right", "d88ltsv_emgr_right_gap", "d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner", "d88ltsv_emgr_toprightcorner" };
 dr_pdiff_fillerIgnore0: list of string =   {"d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_edr_nwell_keepGenAway_ILWaivermgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap", "d80ltsv_emgr_right", "d80ltsv_emgr_right_gap", "d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner", "d80ltsv_emgr_toprightcorner" };

dr_pdiff_fillerIgnore_ILWaiver= strcat( dr_pdiff_fillerIgnore_ILWaiver,dr_pdiff_fillerIgnore7);
dr_pdiff_fillerIgnore_ILWaiver= strcat( dr_pdiff_fillerIgnore_ILWaiver,dr_pdiff_fillerIgnore8);
dr_pdiff_fillerIgnore_ILWaiver= strcat( dr_pdiff_fillerIgnore_ILWaiver,dr_pdiff_fillerIgnore0);

  dr_pdiff_keepGenAway_ILWaiver: list of string =    { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

 dr_pdiff_keepGenAway7: list of string =    { "d87ltsv_emgr_bottom", "d87ltsv_emgr_bottom_gap", "d87ltsv_emgr_top","d87ltsv_emgr_top_gap", "d87ltsv_emgr_left", "d87ltsv_emgr_left_gap", "d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner", "d87ltsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };

 dr_pdiff_keepGenAway8: list of string =    {"d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };
dr_pdiff_keepGenAway0: list of string =    {"d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };

dr_pdiff_keepGenAway_ILWaiver=strcat(dr_pdiff_keepGenAway_ILWaiver,dr_pdiff_keepGenAway7);
dr_pdiff_keepGenAway_ILWaiver=strcat(dr_pdiff_keepGenAway_ILWaiver,dr_pdiff_keepGenAway8);
dr_pdiff_keepGenAway_ILWaiver=strcat(dr_pdiff_keepGenAway_ILWaiver,dr_pdiff_keepGenAway0);

  dr_poly_fillerIgnore_ILWaiver: list of string =    { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };

 dr_poly_fillerIgnore7: list of string =    {"d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap", "d87ltsv_emgr_top", "d87ltsv_emgr_top_gap", "d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner", "d87ltsv_emgr_bottomrightcorner", "d87ltsv_emgr_topleftcorner", "d87ltsv_emgr_toprightcorner" };

dr_poly_fillerIgnore8: list of string =    {"d88ltsv_emgr_bottom", "d88ltsv_emgr_bottom_gap", "d88ltsv_emgr_top", "d88ltsv_emgr_top_gap", "d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner", "d88ltsv_emgr_topleftcorner",  "d88ltsv_emgr_toprightcorner" };

dr_poly_fillerIgnore0: list of string =    {  "d80ltsv_emgr_bottom", "d80ltsv_emgr_bottom_gap", "d80ltsv_emgr_top", "d80ltsv_emgr_top_gap", "d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner",  "d80ltsv_emgr_toprightcorner" };

dr_poly_fillerIgnore_ILWaiver=strcat( dr_poly_fillerIgnore_ILWaiver, dr_poly_fillerIgnore7);
dr_poly_fillerIgnore_ILWaiver=strcat( dr_poly_fillerIgnore_ILWaiver, dr_poly_fillerIgnore8);
dr_poly_fillerIgnore_ILWaiver=strcat( dr_poly_fillerIgnore_ILWaiver, dr_poly_fillerIgnore0);

 dr_poly_keepGenAway_ILWaiver: list of string =     { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };
dr_poly_keepGenAway_7: list of string =     { "d87ltsv_emgr_bottom", "d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner","d87tsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };
dr_poly_keepGenAway_8: list of string =     { "d88ltsv_emgr_bottom", "d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d87ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d88tsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };
dr_poly_keepGenAway_0: list of string =     { "d80ltsv_emgr_bottom", "d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner","d80tsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };
dr_poly_keepGenAway_ILWaiver= strcat(dr_poly_keepGenAway_ILWaiver, dr_poly_keepGenAway_7);
dr_poly_keepGenAway_ILWaiver= strcat(dr_poly_keepGenAway_ILWaiver, dr_poly_keepGenAway_8);
dr_poly_keepGenAway_ILWaiver= strcat(dr_poly_keepGenAway_ILWaiver, dr_poly_keepGenAway_0);

 dr_polycon_fillerIgnore_ILWaiver: list of string = { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };
  dr_polycon_fillerIgnore_7: list of string = { "d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top",  "d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner", "d87ltsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };
  dr_polycon_fillerIgnore_8: list of string = { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top",  "d88ltsv_emgr_top_gap","d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner", "d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };
dr_polycon_fillerIgnore_0: list of string = { "d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top",  "d80ltsv_emgr_top_gap","d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner", "d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };
dr_polycon_fillerIgnore_ILWaiver=strcat(dr_polycon_fillerIgnore_ILWaiver,dr_polycon_fillerIgnore_7);
dr_polycon_fillerIgnore_ILWaiver=strcat(dr_polycon_fillerIgnore_ILWaiver,dr_polycon_fillerIgnore_8);
dr_polycon_fillerIgnore_ILWaiver=strcat(dr_polycon_fillerIgnore_ILWaiver,dr_polycon_fillerIgnore_0);

 dr_polycon_keepGenAway_ILWaiver: list of string =  { "x73tsv_tc2emgr_bottom", "d8xltsv_emgr_bottom", "x73tsv_tc2emgr_bottom_gap", "d8xltsv_emgr_bottom_gap", "x73tsv_tc2emgr_top", "d8xltsv_emgr_top", "x73tsv_tc2emgr_top_gap", "d8xltsv_emgr_top_gap", "x73tsv_tc2emgr_left", "d8xltsv_emgr_left", "x73tsv_tc2emgr_left_gap", "d8xltsv_emgr_left_gap", "x73tsv_tc2emgr_right", "d8xltsv_emgr_right", "x73tsv_tc2emgr_right_gap", "d8xltsv_emgr_right_gap", "x73tsv_tc2emgr_bottomleftcorner", "d8xltsv_emgr_bottomleftcorner", "x73tsv_tc2emgr_bottomrightcorner", "d8xltsv_emgr_bottomrightcorner", "x73tsv_tc2emgr_topleftcorner", "d8xltsv_emgr_topleftcorner", "x73tsv_tc2emgr_toprightcorner", "d8xltsv_emgr_toprightcorner" };
  
 dr_polycon_keepGenAway7: list of string =  {"d87ltsv_emgr_bottom","d87ltsv_emgr_bottom_gap","d87ltsv_emgr_top","d87ltsv_emgr_top_gap","d87ltsv_emgr_left","d87ltsv_emgr_left_gap","d87ltsv_emgr_right","d87ltsv_emgr_right_gap","d87ltsv_emgr_bottomleftcorner","d87ltsv_emgr_bottomrightcorner","d87ltsv_emgr_topleftcorner","d87ltsv_emgr_toprightcorner" };

dr_polycon_keepGenAway8: list of string =  { "d88ltsv_emgr_bottom","d88ltsv_emgr_bottom_gap","d88ltsv_emgr_top","d88ltsv_emgr_top_gap", "d88ltsv_emgr_left","d88ltsv_emgr_left_gap","d88ltsv_emgr_right","d88ltsv_emgr_right_gap","d88ltsv_emgr_bottomleftcorner","d88ltsv_emgr_bottomrightcorner","d88ltsv_emgr_topleftcorner","d88ltsv_emgr_toprightcorner" };


dr_polycon_keepGenAway0: list of string =  { "d80ltsv_emgr_bottom","d80ltsv_emgr_bottom_gap","d80ltsv_emgr_top","d80ltsv_emgr_top_gap", "d80ltsv_emgr_left","d80ltsv_emgr_left_gap","d80ltsv_emgr_right","d80ltsv_emgr_right_gap","d80ltsv_emgr_bottomleftcorner","d80ltsv_emgr_bottomrightcorner","d80ltsv_emgr_topleftcorner","d80ltsv_emgr_toprightcorner" };

dr_polycon_keepGenAway_ILWaiver=strcat(dr_polycon_keepGenAway_ILWaiver, dr_polycon_keepGenAway7);
dr_polycon_keepGenAway_ILWaiver=strcat(dr_polycon_keepGenAway_ILWaiver, dr_polycon_keepGenAway8);
dr_polycon_keepGenAway_ILWaiver=strcat(dr_polycon_keepGenAway_ILWaiver, dr_polycon_keepGenAway0);

dr_RDL_keepGenAway_ILWaiver: list of string =  { "d81mtoprs_y_small", "d81mtoprs_i_small" };
dr_RDL_prs_ILWaiver: list of string =  { "x73btsv_rdlassymark_top", "x73btsv_rdlassymark_bottom" };

// now set the AssignTextHashWaiver for a given layer to its needed value 
   AssignTextHashWaiver["RDL_keepGenAway"] = strcat(dr_default_ILWaiver, dr_RDL_keepGenAway_ILWaiver);
   AssignTextHashWaiver["RDL_prs"] = strcat(dr_default_ILWaiver, dr_RDL_prs_ILWaiver);
   AssignTextHashWaiver["nwellesd_gbnwID"] = strcat(dr_default_ILWaiver, dr_nwellesd_gbnwID_ILWaiver);
   AssignTextHashWaiver["nwell_ESDDiodeID"] = strcat(dr_default_ILWaiver, dr_nwell_ESDDiodeID_ILWaiver);
   AssignTextHashWaiver["BGD_maskDrawing"] = strcat(dr_default_ILWaiver, dr_bgd_maskdrawing_ILWaiver);
   AssignTextHashWaiver["DIFFCHECK_Frame1nonstdpolyflowsID"] = dr_er_waiver;
   AssignTextHashWaiver["DIFFCHECK_Frame2nonstdpolyflowsID"] = dr_er_waiver;

   AssignTextHashWaiver["esd_d8_id"] = strcat(dr_default_ILWaiver, dr_esd_d8_id_ILWaiver);
   AssignTextHashWaiver["esd_d9_id"] = strcat(dr_default_ILWaiver, dr_esd_d9_id_ILWaiver);
   AssignTextHashWaiver["DMG_toSynDrawing"] = strcat(dr_default_ILWaiver, dr_DMG_toSynDrawing_ILWaiver);
   AssignTextHashWaiver["NSD_toSynDrawing"] = strcat(dr_default_ILWaiver, dr_NSD_toSynDrawing_ILWaiver);
   AssignTextHashWaiver["PSD_toSynDrawing"] = strcat(dr_default_ILWaiver, dr_PSD_toSynDrawing_ILWaiver);
   AssignTextHashWaiver["NES_toSynDrawing"] = strcat(dr_default_ILWaiver, dr_NES_toSynDrawing_ILWaiver);
   AssignTextHashWaiver["TNT_toSynDrawing"] = strcat(dr_default_ILWaiver, dr_TNT_toSynDrawing_ILWaiver);
   AssignTextHashWaiver["DVN_maskDrawing"] = strcat(dr_default_ILWaiver, dr_dvn_maskdrawing_ILWaiver);
   AssignTextHashWaiver["DVP_toSynDrawing"] = strcat(dr_default_ILWaiver, dr_dvp_tosyndrawing_ILWaiver);
   AssignTextHashWaiver["ESD_toSynDrawing"] = dr_esd_tosyndrawing_ILWaiver;
   AssignTextHashWaiver["EdgeofActive_toSynDrawing"] = dr_er_waiver;
   AssignTextHashWaiver["ID_LLGTR"] = strcat(dr_default_ILWaiver, bitcells);
   AssignTextHashWaiver["ID_TRDTOS"] = strcat(dr_default_ILWaiver, tringcells);
   AssignTextHashWaiver["ID_reservedPurpose0"] = strcat(dr_default_ILWaiver, devhv_waive);
   AssignTextHashWaiver["ID_reservedPurpose1"] = strcat(dr_default_ILWaiver, metalhv_waive);
   AssignTextHashWaiver["ID_reservedPurpose10"] = strcat(dr_er_waiver, dr_erlockid_waive);
   AssignTextHashWaiver["ID_reservedPurpose3"] = strcat(dr_default_ILWaiver, nwellhv_waive);
   AssignTextHashWaiver["ID_reservedPurpose5"] = strcat(dr_default_ILWaiver, hvid_waive);
   AssignTextHashWaiver["NTP_maskDrawing"] = strcat(dr_default_ILWaiver, dr_ntp_maskdrawing_ILWaiver);
   AssignTextHashWaiver["PTP_toSynDrawing"] = strcat(dr_default_ILWaiver, dr_ptp_tosyndrawing_ILWaiver);
   AssignTextHashWaiver["RMP_maskDrawing"] = dr_rmp_maskdrawing_ILWaiver;
   AssignTextHashWaiver["SVN_maskDrawing"] = dr_default_ILWaiver;
   AssignTextHashWaiver["TPT_toSynDrawing"] = dr_tpt_tosyndrawing_ILWaiver;
   AssignTextHashWaiver["arrayId_diffEdge"] = strcat(strcat(strcat(dr_default_ILWaiver, bitcells), ulpbitcells), "x73idvsramringsl");

  AssignTextHashWaiver["arrayId_drawing7"] = strcat(strcat(strcat(
     dr_default_ILWaiver, gapcells),"x73lvcarygapwlstraplp"),"x73hdcarywlstrapgaplp"
	 );


//   AssignTextHashWaiver["arrayId_highDensity"] = dr_arrayId_highDensity_ILWaiver;
   AssignTextHashWaiver["arrayId_implantID"] = strcat(dr_default_ILWaiver, bitcells);
//   AssignTextHashWaiver["chkBoundary_reservedPurpose10"] = strcat(dr_default_ILWaiver, dr_chkBoundary_reservedPurpose10_ILWaiver);
   AssignTextHashWaiver["chkBoundary_reservedPurpose10"] = strcat(dr_default_ILWaiver, clamp_cells);
   AssignTextHashWaiver["diffcon_densityID"] = strcat(dr_default_ILWaiver, dr_diffcon_densityID_ILWaiver);
   AssignTextHashWaiver["diffcon_resDrawing"] = strcat(dr_default_ILWaiver, dr_diffcon_resDrawing_ILWaiver);
   AssignTextHashWaiver["metal12_resDrawing"] = strcat(dr_default_ILWaiver, dr_metal12_resDrawing_ILWaiver);
   AssignTextHashWaiver["diodeID_ESDDiodeID"] = strcat(dr_default_ILWaiver, dr_diodeid_esddiodeid_ILWaiver);
   AssignTextHashWaiver["global_inductorID1"] = strcat(dr_default_ILWaiver, dr_global_inductorid1_ILWaiver);
   AssignTextHashWaiver["metal12_inductorID"] = strcat(dr_default_ILWaiver, dr_metal12_inductorID_ILWaiver);
   AssignTextHashWaiver["tm1_inductorID"] = strcat(dr_default_ILWaiver, dr_tm1_inductorID_ILWaiver);
   AssignTextHashWaiver["metalc1_maskDrawing"] = dr_er_waiver;
   AssignTextHashWaiver["ndiff_densityID"] = strcat(dr_default_ILWaiver, dr_ndiff_densityID_ILWaiver);
   AssignTextHashWaiver["pdiff_densityID"] = strcat(dr_default_ILWaiver, dr_pdiff_densityID_ILWaiver);
   AssignTextHashWaiver["poly_LLGID"] = strcat(strcat(dr_default_ILWaiver, bitcells), ulpbitcells);
   AssignTextHashWaiver["poly_SrampolyID"] = strcat(dr_default_ILWaiver, bitcells);
   AssignTextHashWaiver["poly_densityID"] = strcat(dr_default_ILWaiver, dr_poly_densityID_ILWaiver);
   AssignTextHashWaiver["poly_hermeticSeal"] = dr_er_waiver;
   AssignTextHashWaiver["polybb_maskDrawing"] = diciso_cells; //only allowed in iso dic
   AssignTextHashWaiver["polycon_densityID"] = strcat(dr_default_ILWaiver, dr_polycon_densityID_ILWaiver);
   AssignTextHashWaiver["polycon_resDrawing"] = strcat(dr_default_ILWaiver, dr_pcresID_ILWaiver);
   AssignTextHashWaiver["tm1_densityID"] = strcat(dr_default_ILWaiver, dr_tm1_densityID_ILWaiver);
   AssignTextHashWaiver["via9_densityID"] = strcat(dr_default_ILWaiver, dr_via9_densityID_ILWaiver);
   AssignTextHashWaiver["metal9_densityID"] = strcat(dr_default_ILWaiver, dr_metal9_densityID_ILWaiver);
   AssignTextHashWaiver["CE1_densityID"] = strcat(dr_default_ILWaiver, dr_CE1_densityID_ILWaiver);
   AssignTextHashWaiver["CE2_densityID"] = strcat(dr_default_ILWaiver, dr_CE2_densityID_ILWaiver);    
   AssignTextHashWaiver["via11_densityID"] = strcat(dr_default_ILWaiver, dr_via11_densityID_ILWaiver);
   AssignTextHashWaiver["viacon_colorDrawing"] = dr_er_waiver;
   AssignTextHashWaiver["wellResId_resDrawing"] = strcat(dr_default_ILWaiver, dr_wellresID_ILWaiver);
   AssignTextHashWaiver["chkBoundary_reservedPurpose1"] = dr_chkBoundary_reservedPurpose1_ILWaiver;
   AssignTextHashWaiver["chkBoundary_reservedPurpose2"] = dr_chkBoundary_reservedPurpose2_ILWaiver;
   AssignTextHashWaiver["chkBoundary_reservedPurpose3"] = dr_chkBoundary_reservedPurpose3_ILWaiver;
   AssignTextHashWaiver["chkBoundary_reservedPurpose4"] = dr_chkBoundary_reservedPurpose4_ILWaiver;
   AssignTextHashWaiver["ID_bgdiodeID"] = strcat(dr_default_ILWaiver, dr_ID_bgdiodeID_ILWaiver);
   AssignTextHashWaiver["ID_VaractorID"] = strcat(dr_default_ILWaiver, dr_ID_VaractorID_ILWaiver);
   AssignTextHashWaiver["OGD_centerLine"] = strcat(dr_default_ILWaiver, dr_OGD_centerLine_ILWaiver);
   AssignTextHashWaiver["PGD_centerLine"] = strcat(dr_default_ILWaiver, dr_PGD_centerLine_ILWaiver);
   AssignTextHashWaiver["poly_sramID2"] = ulpbitcells;  
   AssignTextHashWaiver["bitcell3_reservedPurpose9"] = dr_bitcell3_reservedPurpose9_ILWaiver;
   AssignTextHashWaiver["bitcell3_reservedPurpose10"] = dr_bitcell3_reservedPurpose10_ILWaiver;
   AssignTextHashWaiver["SRAM_XLV_maskDrawing"] = dr_SRAM_XLV_maskDrawing_ILWaiver;
   AssignTextHashWaiver["SRAM_ULV_maskDrawing"] = dr_SRAM_ULV_maskDrawing_ILWaiver;
   AssignTextHashWaiver["bitcell4_reservedPurpose4"] = dr_bitcell4_reservedPurpose4_ILWaiver;
   AssignTextHashWaiver["bitcell4_reservedPurpose5"] = dr_bitcell4_reservedPurpose5_ILWaiver;
   AssignTextHashWaiver["diffusion_reservedPurpose10"] = dr_diffusion_reservedPurpose10_ILWaiver;
   AssignTextHashWaiver["SRAM_IDV_maskDrawing"] = dr_SRAM_IDV_maskDrawing_ILWaiver;
   AssignTextHashWaiver["diffcon_TccIDBitCell"] = dr_diffcon_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["metal0_TccIDBitCell"] = dr_metal0_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["metal1_TccIDBitCell"] = dr_metal1_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["metal2_TccIDBitCell"] = dr_metal2_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["poly_TccIDBitCell"] = dr_poly_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["polycon_TccIDBitCell"] = dr_polycon_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["via0_TccIDBitCell"] = dr_via0_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["via1_TccIDBitCell"] = dr_via1_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["viacon_TccIDBitCell"] = dr_viacon_TccIDBitCell_ILWaiver;
   AssignTextHashWaiver["metal1_backBone"] = dr_metal1_backBone_ILWaiver;
   AssignTextHashWaiver["FTI_maskDrawing"] = dr_FTI_maskDrawing_ILWaiver;
   AssignTextHashWaiver["metal2_noOPCDFM"] = dr_metal2_noOPCDFM_ILWaiver;
   AssignTextHashWaiver["metal3_noOPCDFM"] = dr_metal3_noOPCDFM_ILWaiver;
   AssignTextHashWaiver["metal1_BCregionID"] = dr_metal1_BCregionID_ILWaiver;
   AssignTextHashWaiver["metalc1_complement"] = dr_metalc1_complement_ILWaiver;
   AssignTextHashWaiver["asym_keepGenAway"] = dr_asym_keepGenAway_ILWaiver;   
   AssignTextHashWaiver["bitcell3_reservedPurpose5"] = dr_bitcell3_reservedPurpose5_ILWaiver;
   AssignTextHashWaiver["bitcell3_reservedPurpose6"] = dr_bitcell3_reservedPurpose6_ILWaiver;
   AssignTextHashWaiver["bitcell3_reservedPurpose7"] = dr_bitcell3_reservedPurpose7_ILWaiver;
   AssignTextHashWaiver["metal3_fuseJog"] = dr_metal3_fuseJog_ILWaiver;
   AssignTextHashWaiver["antiFuse_id"] = dr_antiFuse_id_ILWaiver;
   AssignTextHashWaiver["DMG_maskDrawing"] = dr_DMG_maskDrawing_ILWaiver;
   AssignTextHashWaiver["via1_densityID"] = strcat(dr_default_ILWaiver, dr_via1_densityID_ILWaiver);
   AssignTextHashWaiver["metal2_densityID"] = strcat(dr_default_ILWaiver, dr_metal2_densityID_ILWaiver);
   AssignTextHashWaiver["metal12_densityID"] = strcat(dr_default_ILWaiver, dr_metal12_densityID_ILWaiver);
   AssignTextHashWaiver["metal0_plug"] = strcat(dr_default_ILWaiver, dr_metal0_plug_ILWaiver);
   AssignTextHashWaiver["metal1_plug"] = strcat(dr_default_ILWaiver, dr_metal1_plug_ILWaiver);
   AssignTextHashWaiver["metal2_plug"] = strcat(dr_default_ILWaiver, dr_metal2_plug_ILWaiver);
   AssignTextHashWaiver["TSVCC_drawing1"] = strcat(dr_default_ILWaiver, dr_tsvcc_drawing1_ILWaiver);
   AssignTextHashWaiver["via0_densityID"] = strcat(dr_default_ILWaiver, dr_via0_densityID_ILWaiver);
   AssignTextHashWaiver["viacon_densityID"] = strcat(dr_default_ILWaiver, dr_viacon_densityID_ILWaiver);
   AssignTextHashWaiver["diffcon_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_diffcon_fillerIgnore_ILWaiver);   
   AssignTextHashWaiver["diffcon_keepGenAway"] = strcat(dr_default_ILWaiver, dr_diffcon_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["metal0_densityID"] = strcat(dr_default_ILWaiver, dr_metal0_densityID_ILWaiver);
   AssignTextHashWaiver["metal0_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_metal0_fillerIgnore_ILWaiver);
   AssignTextHashWaiver["metal0_keepGenAway"] = strcat(dr_default_ILWaiver, dr_metal0_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["metal1_densityID"] = strcat(dr_default_ILWaiver, dr_metal1_densityID_ILWaiver);
   AssignTextHashWaiver["metal1_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_metal1_fillerIgnore_ILWaiver);
   AssignTextHashWaiver["metal1_keepGenAway"] = strcat(dr_default_ILWaiver, dr_metal1_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["metal2_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_metal2_fillerIgnore_ILWaiver);  
   AssignTextHashWaiver["metal2_keepGenAway"] = strcat(dr_default_ILWaiver, dr_metal2_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["ndiff_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_ndiff_fillerIgnore_ILWaiver);  
   AssignTextHashWaiver["ndiff_keepGenAway"] = strcat(dr_default_ILWaiver, dr_ndiff_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["nwell_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_nwell_fillerIgnore_ILWaiver);  
   AssignTextHashWaiver["nwell_keepGenAway"] = strcat(dr_default_ILWaiver, dr_nwell_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["pdiff_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_pdiff_fillerIgnore_ILWaiver);  
   AssignTextHashWaiver["pdiff_keepGenAway"] = strcat(dr_default_ILWaiver, dr_pdiff_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["poly_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_poly_fillerIgnore_ILWaiver);  
   AssignTextHashWaiver["poly_keepGenAway"] = strcat(dr_default_ILWaiver, dr_poly_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["polycon_fillerIgnore"] = strcat(dr_default_ILWaiver, dr_polycon_fillerIgnore_ILWaiver);  
   AssignTextHashWaiver["polycon_keepGenAway"] = strcat(dr_default_ILWaiver, dr_polycon_keepGenAway_ILWaiver);   
   AssignTextHashWaiver["ID_prs"] = strcat(dr_default_ILWaiver, dr_ID_prs_ILWaiver);   


   AssignTextHashWaiver["PV3_maskDrawing"] = dr_PV3_maskDrawing_ILWaiver;
   AssignTextHashWaiver["PVL_maskDrawing"] = dr_PVL_maskDrawing_ILWaiver;
   AssignTextHashWaiver["XVP_maskDrawing"] = dr_XVP_maskDrawing_ILWaiver;
   AssignTextHashWaiver["m3fuse_id"] = dr_m3fuse_id_ILWaiver;
   AssignTextHashWaiver["PDR_maskDrawing"] = dr_PDR_maskDrawing_ILWaiver;
   AssignTextHashWaiver["NDR_toSynDrawing"] = dr_NDR_toSynDrawing_ILWaiver;  
   AssignTextHashWaiver["XVN_maskDrawing"] = dr_XVN_maskDrawing_ILWaiver;
   AssignTextHashWaiver["PDR_toSynDrawing"] = dr_PDR_toSynDrawing_ILWaiver;
   AssignTextHashWaiver["NDR_maskDrawing"] = dr_NDR_maskDrawing_ILWaiver;  


   //Nauman Khan These SDC layers are legal for TSV CC GR cells 
   AssignTextHashWaiver["via2_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["metal3_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["via3_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["metal4_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["via4_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["metal5_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["via5_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["metal6_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["via6_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["metal7_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["via7_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["metal8_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["via8_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["metal9_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["via9_SDC"] = catch_cup_guard_cells;
   AssignTextHashWaiver["TM1_SDC"] = catch_cup_guard_cells;

	

#if _drTSDR == _drYES
   #include <1273/p1273dx_TSDRIL.rs>
#endif


// Set isLegal for differences between dots 
// where some layer is legal in one but not another
isDOTXLegal: list of string = { };

#if (_drPROCESS == 5) 
  isDOTXLegal = { 
    "metal10_maskDrawing",
    "via10_maskDrawing", 
    "poly_XGOXID", 
    "PV3_maskDrawing",
    "NV3_maskDrawing",
  };


#elif (_drPROCESS == 6) 
  isDOTXLegal = { 
    "metal10_maskDrawing",
    "via10_maskDrawing", 
    "metal11_maskDrawing",
    "via11_maskDrawing",
    "metal12_maskDrawing",
    "via12_maskDrawing",
    "poly_XGOXID"
  };

#elif (_drPROCESS == 4 || _drPROCESS == 1) 
  isDOTXLegal = { 
    "poly_XGOXID", 
    "TRDTOULP_maskDrawing", // TRDTOULP
  
    //TSV  - for now this is under .4, if that changes will move to appropriate dotprocess
    #if (_drTSV_WAIVER == _drYES)
      "TSV_maskDrawing",  //TSVDRAWN
	  "RDL_maskDrawing",  // RDLDRAWN
	  "RDL_CAPID",       // RDLCAP
	  "RDL_padBUMPID",   // RDLPAD       
	  //"RDL_CantiLever",  // RDL_CANTILEVER
	  "LMIPAD_maskDrawing",  // LMI PAD
    #endif

    //STTRAM Legal layers - for now this is under .4, if that changes will move to appropriate dotprocess
    #if (_drSTRAM_WAIVER == _drYES)
      "STTRAM1_maskDrawing", //STTRAMID1
      "STTRAM2_maskDrawing", //STTRAMID2
      "mtj_drawing", //MTJID
      "mtj_maskDrawing", //MTJDRAWN    
      "mj0_maskDrawing" //MJ0DRAWN 
    #endif
  };

#endif

//ADD HERE IF IT IS LEGAL FOR ALL ALL 1273 DOTS
is1273Legal: list of string = {
"chkBoundary_reservedPurpose7", // ESD_D7_ID7
"chkBoundary_reservedPurpose5", // ESD_D5_ID5
"chkBoundary_reservedPurpose6", // ESD_D6_ID6
"chkBoundary_reservedPurpose4", // ESD_D4_ID4
"chkBoundary_reservedPurpose3", // ESD_D3_ID3
"chkBoundary_reservedPurpose2", // ESD_D2_ID2
"chkBoundary_reservedPurpose1", // ESD_D1_ID1
"chkBoundary_reservedPurpose0" // ESD_D0_ID0
//"ID_reservedPurpose5" //HVID
};  


//Feature specic legal layers ////////////////////////////////////////////////////////////
#if (_drENABLE_FTI == _drYES)
isDOTXLegal=strcat(isDOTXLegal,{"FTI_id","FTI_maskDrawing"});
#endif

#if (_drENABLE_EMIB == _drYES)
isDOTXLegal=strcat(isDOTXLegal,{"emibbump_zoneDrawing","c4emib_drawing","tv1_sizeID"});
#endif

#if (_drALLOW_ULV == _drYES)
isDOTXLegal=strcat(isDOTXLegal,{"NU1_maskDrawing","PU1_maskDrawing"});
#endif

#if (_drALLOW_DNW == _drYES) 
isDOTXLegal=strcat(isDOTXLegal,{"deepnwell_maskDrawing"});
#endif

#if (_drALLOW_RFREQ == _drYES)
isDOTXLegal=strcat(isDOTXLegal,{"RFREQ_devType"});
#endif

///////////////////////////////////////////////////////////////////////////////////////////


//Make the full legal list
isLegal = strcat(isDOTXLegal, is1273Legal);



// Add here if you want to make ILLEGAL in general for all 1273 dots
// The isLegal list above however will override.
// Handle specific 1273 cases that are ILLEGAL but are normally legal by methodology
AssignTextHash["metal10_maskDrawing"] = metal10_maskDrawing;
AssignTextHash["via10_maskDrawing"] = via10_maskDrawing;
AssignTextHash["metal11_maskDrawing"] = metal11_maskDrawing;
AssignTextHash["via11_maskDrawing"] = via11_maskDrawing;
AssignTextHash["CE3_maskDrawing"] = CE3_maskDrawing;
AssignTextHash["arrayId_highDensity"] = arrayId_highDensity;
AssignTextHash["NAL_maskDrawing"] = NAL_maskDrawing;
AssignTextHash["PAL_maskDrawing"] = PAL_maskDrawing;

AssignTextHashWaiver["metal10_maskDrawing"] = dr_default_ILWaiver;
AssignTextHashWaiver["via10_maskDrawing"] = dr_default_ILWaiver;
AssignTextHashWaiver["metal11_maskDrawing"] = dr_default_ILWaiver;
AssignTextHashWaiver["via11_maskDrawing"] = dr_default_ILWaiver;
AssignTextHashWaiver["CE3_maskDrawing"] = dr_default_ILWaiver;
AssignTextHashWaiver["arrayId_highDensity"]= dr_default_ILWaiver;
AssignTextHashWaiver["NAL_maskDrawing"]= dr_default_ILWaiver;
AssignTextHashWaiver["PAL_maskDrawing"]= dr_default_ILWaiver;

//Make layer illegal for certain dot process
#if (_drPROCESS == 6) 
AssignTextHash["poly_ULPpitchID"] = poly_ULPpitchID;
AssignTextHashWaiver["poly_ULPpitchID"]= dr_default_ILWaiver;
#endif

//Make certain layers illegal (essentially to enable 1273.0 and 1273.8)
#if (_drALLOW_DNW == _drNO) 
AssignTextHash["deepnwell_maskDrawing"] = deepnwell_maskDrawing;
AssignTextHashWaiver["deepnwell_maskDrawing"]= dr_default_ILWaiver;
#endif

#if (_drALLOW_ULV == _drNO) 
AssignTextHash["NU1_maskDrawing"] = NU1_maskDrawing;
AssignTextHashWaiver["NU1_maskDrawing"]= dr_default_ILWaiver;

AssignTextHash["PU1_maskDrawing"] = PU1_maskDrawing;
AssignTextHashWaiver["PU1_maskDrawing"]= dr_default_ILWaiver;
#endif

#if (_drALLOW_XLLP == _drNO) 
AssignTextHash["poly_ULPpitchID"] = poly_ULPpitchID;
AssignTextHashWaiver["poly_ULPpitchID"]= dr_default_ILWaiver;
#endif

#if (_drALLOW_UV1 == _drNO) 
AssignTextHash["NV1_maskDrawing"] = NV1_maskDrawing;
AssignTextHashWaiver["NV1_maskDrawing"]= dr_default_ILWaiver;

AssignTextHash["PV1_maskDrawing"] = PV1_maskDrawing;
AssignTextHashWaiver["PV1_maskDrawing"]= dr_default_ILWaiver;
#endif

#if (_drALLOW_MIM == _drNO) 
AssignTextHash["CE1_maskDrawing"] = CE1_maskDrawing;
AssignTextHashWaiver["CE1_maskDrawing"]= dr_default_ILWaiver;

AssignTextHash["CE2_maskDrawing"] = CE2_maskDrawing;
AssignTextHashWaiver["CE2_maskDrawing"]= dr_default_ILWaiver;
#endif

#if (_drENABLE_EMIB == _drNO)
AssignTextHash["c4emib_drawing"] = c4emib_drawing;
AssignTextHashWaiver["c4emib_drawing"]= dr_default_ILWaiver;

AssignTextHash["emibbump_zoneDrawing"] = emibbump_zoneDrawing;
AssignTextHashWaiver["emibbump_zoneDrawing"]= dr_default_ILWaiver;

AssignTextHash["tv1_sizeID"] = tv1_sizeID;
AssignTextHashWaiver["tv1_sizeID"]= dr_default_ILWaiver;
#endif


//Make legal
//#if (_drALLOW_RFREQ == _drYES)
//AssignTextHash.remove("RFREQ_devType");
//#endif


#endif
   
