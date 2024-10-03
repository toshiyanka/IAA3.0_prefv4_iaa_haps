// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TemplateCells.rs.rca 1.54 Mon Jan 19 16:08:58 2015 kperrey Experimental $

// $Log: p1273dx_TemplateCells.rs.rca $
// 
//  Revision: 1.54 Mon Jan 19 16:08:58 2015 kperrey
//  as per tao add d87smfcevm3d d87smfcnvm3d d87smfctguvm3d d87xmfcnvm3d d87smfcnvm5d d87xmfcnvm5d d87smfcnvm7d d87sindmtm1m9l1p1n d87sindmtm1m9l1p6n d87sesdscrevm1_prim_dnw d87sesdscruvm1_prim_dnw ; as per suhas/icf d8xsesdpclampdnwnvm2 d8xsesdpclampdnwtgp5evm2core d8xsesdpclampdnwtgp5evm2
// 
//  Revision: 1.53 Wed Jan 14 10:53:41 2015 kperrey
//  hsd 2847 ; add d8xsesdclampdnwcaptgehv to bb and tuc template lists
// 
//  Revision: 1.52 Sun Jan 11 08:51:18 2015 kperrey
//  had space in cellname
// 
//  Revision: 1.51 Tue Jan  6 12:10:13 2015 kperrey
//  as per suhas email remove d8xsesdpclampdnwnvm2 d8xsesdpclampdnwtgp5evm2 d8xsesdd3d4uvm4 d8xsesdpclampdnwtgp5evm2core   d8xsesdd1uvm3 d8xsesdd1uvm3_lu d8xsesdd2uvm3 d8xsesdd2uvm3_lu d8xsesdd3uvm3 d8xsesdd3uvm3_lu d8xsesdd4uvm3 d8xsesdd4uvm3_lu d8xsesdrestcnp5uvm3 d8xsesdrestcnuvm3 d8xsrtcnuvm2p5vtun from template lists ; resync the DNW disallows to hsd 2986
// 
//  Revision: 1.50 Tue Jan  6 08:39:32 2015 kperrey
//  updated hsd 2969 ; removed d86sesdd1d2uvm4 d86sesdd1d2uvm4_lu d86sesdd1d2uvm7perf d86sesdd3d4uvm4_lu d86sesdd7p5uvm7    d8xsesdd3d4uvm4 d86sesdd1uvm7perf d86sesdd1uvm7ulc d86sesdd2uvm7perf d86sesdd2uvm7ulc        d8xsesdd1uvm3 d8xsesdd1uvm3_lu d8xsesdd2uvm3 d8xsesdd2uvm3_lu d8xsesdd3uvm3 d8xsesdd3uvm3_lu d8xsesdd4uvm3 d8xsesdd4uvm3_lu d8xsesdrestcnp5uvm3 d8xsesdrestcnuvm3 as per vhanuman
// 
//  Revision: 1.49 Mon Jan  5 22:09:40 2015 kperrey
//  hsd 2986 ; create templateCellsNoDNW list of cells that cant be placed in DEEPNWELL
// 
//  Revision: 1.48 Thu Dec 18 13:09:16 2014 kperrey
//  hsd 2969 ; added cells to nestedTemplate list
// 
//  Revision: 1.47 Tue Dec  9 14:02:07 2014 kperrey
//  fixed typo ; had space after d86sesdd2uvm7ulc line 930
// 
//  Revision: 1.46 Mon Dec  1 14:00:33 2014 kperrey
//  hsd 2908
// 
//  Revision: 1.45 Mon Dec  1 13:40:22 2014 kperrey
//  hsd 2902; add d86smfcevm7alp to template and LVSblackBox
// 
//  Revision: 1.44 Fri Nov 28 18:57:23 2014 kperrey
//  hsd 2880 ; add d8xmtgvargbns16f336zevm2 d8xmtgvargbns56f336zevm2
// 
//  Revision: 1.43 Tue Nov 18 20:31:16 2014 kperrey
//  hsd 2886 ; added 18 cells to templateCellsTUC and nestedTemplateCellsTUC list ; include project_TemplateCells.rs
// 
//  Revision: 1.42 Mon Nov 17 11:30:31 2014 kperrey
//  hsd 2847; add d8xsesdpclampdnwnvm2 d8xsesdpclampdnwtgp5evm2  to template and nested template lists
// 
//  Revision: 1.41 Sat Nov  1 11:10:02 2014 kperrey
//  add d86ltoedm1273pgdx0_diode, d86ltoedm1273ogdx0_diode, d81ltoedm1273pgdx0_diode,          d81ltoedm1273ogdx0_diode, d8xltoedm1273ogdx0_diode, d8xltoedm1273pgdx0_diode back to nested list
// 
//  Revision: 1.40 Thu Oct 30 08:36:45 2014 kperrey
//  removed all d*toedm1273* cells ; added back cells specified by bernie in email
// 
//  Revision: 1.39 Sat Oct 18 22:10:52 2014 kperrey
//  add missing commas after d87srtcnuvm2p5vtun and d80srtcnuvm2p5vtun
// 
//  Revision: 1.38 Wed Oct  8 08:41:51 2014 kperrey
//  fixed Syntax, when hsd2331 was implemented; need commas after cell names
// 
//  Revision: 1.37 Thu Aug 21 09:58:06 2014 kperrey
//  needed , after d8xsrtcnuvm2p5vtun
// 
//  Revision: 1.36 Mon Aug 11 13:34:14 2014 kperrey
//  added missing cells found by Jean; d8xsmfcevm3d d8xsmfcnvm3d d8xsmfcnvm5d d8xsmfctguvm3d d8xxmfcnvm3d d8xxmfcnvm5d
// 
//  Revision: 1.35 Thu Jul 31 11:34:55 2014 dgthakur
//  Fixed some typos (missing commas etc.).
// 
//  Revision: 1.34 Mon Jul 21 14:25:08 2014 kperrey
//  hsd 2569; add d87sesdscrevm1_prim d87sesdscruvm1_prim
// 
//  Revision: 1.33 Sun Jul 20 19:57:10 2014 kperrey
//  hsd 2569; add d8xsesdscrevm1_prim d8xsesdscruvm1_prim
// 
//  Revision: 1.32 Sun Jul 20 11:08:46 2014 dgthakur
//  Ankita added dot0,7,8 cells based on Tao Chen's request (code reviewed by Dipto).
// 
//  Revision: 1.31 Wed Jun 18 12:53:38 2014 kperrey
//  hsd 2495 ; add d8xsdcpiptgevm4v2 d8xsdcpiptgevm2v2
// 
//  Revision: 1.30 Wed May 21 20:01:40 2014 kperrey
//  hsd 2390 ; add d8xmtgvargbnd24f336zevm2 d8xmvargbns32f336zevm2 d8xmvargbns128f336zevm2 d8xsvargbnd64f252z2evm2 cells
// 
//  Revision: 1.29 Wed Apr 30 10:39:50 2014 kperrey
//  hsd 2331 ; add d8xxesdrestcnevm3 as a nested template
// 
//  Revision: 1.28 Tue Apr 22 13:07:10 2014 kperrey
//  hsd 2282 ; add D8XSDCPINTGEVM2_S2S D8XSDCPINTGEVM4_S2S
// 
//  Revision: 1.27 Fri Apr 18 10:51:56 2014 kperrey
//  hsd 2297 ; remove the deprecated templates d8xsdcpiptgevm2 d8xsdcpiptgevm4
// 
//  Revision: 1.26 Thu Apr 17 12:27:45 2014 kperrey
//  hsd 2290 ; add d86smfcnvm7alp d86smfcevm7aulc d86smfcevm6a ; change name to d86sindtm1m11l1p1n d86sindtm1m11l2p2n (added s)
// 
//  Revision: 1.25 Wed Apr  2 11:43:28 2014 kperrey
//  add d8xsesdpclamptgp25evm2nscore to template list and make valid parent list for d8xsesdclamprestg
// 
//  Revision: 1.24 Wed Apr  2 11:30:45 2014 kperrey
//  include ICF hack p1273dx_ICFTemplateCells.r
// 
//  Revision: 1.23 Fri Mar 21 08:20:24 2014 kperrey
//  hsd 2219 ; add 3 diode related cells since they are now bb cells
// 
//  Revision: 1.22 Thu Feb 27 19:17:23 2014 kperrey
//  hsd 2159; add d8xx*rtcn* cells
// 
//  Revision: 1.21 Mon Feb 24 07:28:27 2014 kperrey
//  as per kalyan add d8xltsv_ccspcralt1
// 
//  Revision: 1.20 Wed Feb 12 12:10:45 2014 kperrey
//  hsd 2075 ; add d8xsrtcnuvm2p5vtun_base to p1273dx_LVSblackBox.rs and d8xsrtcnuvm2p5vtun to p1273dx_TemplateCells.rs
// 
//  Revision: 1.19 Thu Feb  6 19:52:26 2014 kperrey
//  hsd 2103 ; init and populate primPlacementHash:typeHashString2ListOfString keys are the prim to check and the list of string are the allowed parents
// 
//  Revision: 1.18 Wed Feb  5 12:31:33 2014 kperrey
//  hsd 2027 ; add x73hdcsramtrbittodig x73hdcsramtrbittodecx4 to sram template list
// 
//  Revision: 1.17 Thu Jan  9 19:32:29 2014 kperrey
//  hsd 2037 ; add d86smfcevm4aulc d86smfcnvm4aulc d86smfcevm7[abc] d86smfcnvm7[abc]
// 
//  Revision: 1.16 Fri Jan  3 12:07:06 2014 kperrey
//  hsd 2023 ; added d81sindmtm1m9l1p1n
// 
//  Revision: 1.15 Tue Dec 24 09:58:05 2013 dgthakur
//  Added d81ltosramedm1273ogdfillx0 (email Amrinder 24Dec13).
// 
//  Revision: 1.14 Wed Dec 18 19:10:54 2013 kperrey
//  removed d8xsdcpiptgulvm4 d8xsdcpintgulvm4 as per email from suhas
// 
//  Revision: 1.13 Tue Dec 10 14:13:58 2013 kperrey
//  hsd 1998; add d8xsdcpiphvm2 d8xsdcpiphvm4 d86sdcpiphvm6 to lists
// 
//  Revision: 1.12 Thu Dec  5 14:35:24 2013 kperrey
//  add d81mtoprs_i_small_cc d81mtoprs_y_small_cc to template list and nested list ; added the non _cc extension cells also to the nested list
// 
//  Revision: 1.11 Wed Dec  4 15:59:02 2013 kperrey
//  hsd 1985 ; add d86smfcnvm6b d86smfcnvm6c others were already listed
// 
//  Revision: 1.10 Wed Dec  4 07:54:55 2013 kperrey
//  hsd 1980/ add x73rficfb __TUCAddBitCells__ since not explicityly called out as bitcell in dr_cells_list
// 
//  Revision: 1.9 Mon Oct 28 11:08:22 2013 kperrey
//  added the d81 isodic and i/yprs
// 
//  Revision: 1.8 Sun Sep 29 17:13:03 2013 kperrey
//  hsd 1896; added induc d81shipindmtm1l0p5n d81shipindmtm1m9l0p9n
// 
//  Revision: 1.7 Thu Sep 12 17:35:12 2013 kperrey
//  hsd 1878; added D8XSDCPIPTGULVM4/D8XSDCPINTGULVM4
// 
//  Revision: 1.6 Thu Sep 12 17:14:39 2013 kperrey
//  hsd 1880; add d86sindtm1m12l0p72n/d86sindspiralm12l0p8n
// 
//  Revision: 1.5 Thu Sep  5 14:19:26 2013 kperrey
//  hsd 1866 ; support ICF scaleable inductor ind2t_scl_*
// 
//  Revision: 1.4 Thu Aug 22 10:19:31 2013 kperrey
//  hsd 1861 ; add scr cells d8xsesdscrevm1 d8xsesdscruvm1
// 
//  Revision: 1.3 Tue Aug 20 07:23:29 2013 kperrey
//  hsd 1860 ; add d81shipindmtm1m9l1p1n
// 
//  Revision: 1.2 Thu Aug  8 18:30:43 2013 kperrey
//  hsd 1846 ; add support for d81sindmtm1m9l1p6n
// 
//  Revision: 1.1 Tue Jul 30 20:59:37 2013 kperrey
//  derived from the /nfs/pdx/disks/drwork.disks.12/work_areas/kperrey/work73/runset_libs/x12dev_drwork_rst/PXL/drTemplateCells ; removed the 1272 specific cells c8* or x10* or x72*; hsd 1824 added d8xsrtcnevm2dac*
// 
//  Revision: 1.60 Thu Jul 18 08:46:50 2013 kperrey
//  add d86ltoedm1273ogdx0_diode d86ltoedm1273pgdx0_diode as per ramesh
// 
//  Revision: 1.59 Mon Jul 15 18:37:04 2013 kperrey
//  add d8xxesdpclampxllgatedevm2 d8xxesdpclampxllp5gatedevm2 as per Krishna email
// 
//  Revision: 1.58 Mon Jul 15 15:19:13 2013 kperrey
//  add d8xmesdpclampgatedevm2 to templates for TUC
// 
//  Revision: 1.57 Mon Jul 15 14:14:28 2013 kperrey
//  add d81toemd* cells as per Berni/Dipto email
// 
//  Revision: 1.56 Mon Jul  8 15:25:06 2013 jhannouc
//  Added dot1 Etchring collaterals.
// 
//  Revision: 1.55 Wed Jun 19 13:15:39 2013 kperrey
//  part of 1702 forgot to add d86smfcnvm6a d86smfcnvm6alp d86sindm12l0p15n d86sindm12l0p2n d86sindm12ctl0p2n                  d86sindm12l0p265n
// 
//  Revision: 1.54 Thu Jun 13 13:12:04 2013 oakin
//  added ulc bitcells to the TUC checks.
// 
//  Revision: 1.53 Fri May 24 08:37:01 2013 kperrey
//  as per dipto add d86mtodic_nestdic
// 
//  Revision: 1.52 Thu May 23 17:17:08 2013 kperrey
//  hsd 1702 / 1703 added cells as specified
// 
//  Revision: 1.51 Mon Apr 22 12:01:51 2013 tmurata
//  added the production CCGR/EDM cells to the respective lists.
// 
//  Revision: 1.50 Fri Apr 12 15:36:22 2013 jhannouc
//  Added the dot6 Etchring Cells.
// 
//  Revision: 1.49 Fri Mar 22 17:05:33 2013 oakin
//  added 3 missing ER cells.
// 
//  Revision: 1.48 Thu Mar 21 08:17:12 2013 kperrey
//  hsd 1599 ; add C84MINDM11L0P8N/C84MINDM11L0P6N templates
// 
//  Revision: 1.47 Mon Mar 18 11:13:22 2013 kperrey
//  change X73LCPLLVCOVARMFC4P8G -> D8XMVARGBND64F252Z2EVM2 misunderstanding to what the actual varactor template cell was
// 
//  Revision: 1.46 Sat Mar 16 16:22:06 2013 kperrey
//  add x73lcpllvcovarmfc4p8g new varactor
// 
//  Revision: 1.45 Thu Mar  7 15:22:23 2013 oakin
//  added an inductor template cell.
// 
//  Revision: 1.44 Fri Mar  1 10:55:15 2013 oakin
//  added c8xltoedm1272pgdx0_diode to the nested list.
// 
//  Revision: 1.43 Tue Feb 26 17:59:01 2013 oakin
//  added  new (1272.4) prs and edm cells.
// 
//  Revision: 1.42 Mon Feb 25 20:22:44 2013 kperrey
//  add d8xltoedm1273ogdx0_diode d8xltoedm1273pgdx0_diode to nested list
// 
//  Revision: 1.41 Mon Feb 18 17:34:26 2013 kperrey
//  add c8xmvargbnd64f252z2evm2 as per oz and Andrey
// 
//  Revision: 1.40 Wed Feb 13 21:32:55 2013 kperrey
//  as per kalyan add d8xltsv_ccsymb as the tsv catchcup
// 
//  Revision: 1.39 Thu Jan 24 05:34:31 2013 tmurata
//  added additional Etchring cells for X73B (and production) as well as the catch-cup guardring cells.
// 
//  Revision: 1.38 Tue Jan 22 12:32:03 2013 kperrey
//  added bitcells for TUC based upon x73bhpc1ary64x16lp x73hpdpsramtrbittobias_dum x73lvdpary256x128lp_opc test cases
// 
//  Revision: 1.37 Thu Jan 10 18:52:11 2013 kperrey
//  hsd 1478 ; add c8xmrtdnvm7 to template and nested tempate lists
// 
//  Revision: 1.36 Thu Dec  6 10:01:44 2012 oakin
//  added two new etchring cell names (from Berni).
// 
//  Revision: 1.35 Thu Nov 29 20:30:46 2012 kperrey
//  hsd 1431 ; add inductor d86indtm1m11l1p1n d86indtm1m11l2p2n ; add decap d8xxdcpiphvm2 d8xxdcpipnvm4p5 d8xxdcpipnvm2p5
// 
//  Revision: 1.34 Tue Nov 20 14:01:13 2012 kperrey
//  added bitcell list generation for TUC
// 
//  Revision: 1.33 Thu Nov 15 09:43:06 2012 kperrey
//  hsd 1434 ; added d84sindmtm1m9l0p7n10g
// 
//  Revision: 1.32 Thu Nov 15 09:32:47 2012 oakin
//  added the emd cells for 1272.
// 
//  Revision: 1.31 Sat Sep 15 11:01:24 2012 kperrey
//  hsd 1371; updated nested templates
// 
//  Revision: 1.30 Mon Aug 27 07:51:06 2012 oakin
//  fixed a missing comma.
// 
//  Revision: 1.29 Mon Aug 20 10:20:49 2012 kperrey
//  hsd 1332; add d84shipindmtm1m9l0p6n d84shipindmtm1m9l1p1n to template/cell lists
// 
//  Revision: 1.28 Thu Aug  2 15:36:01 2012 kperrey
//  hsd 1317; remove d84sindmtm1m9l7p6n and d84sindmtm1m9l0p6n
// 
//  Revision: 1.27 Thu Jul 19 22:45:52 2012 kperrey
//  hsd 1277; added c8xmrtcnevm2vtunddrcmd c8xmrtcnevm2vtunddrdyn c8xmrtcnevm2vtunddrstat and the d8xx equivs to nested list
// 
//  Revision: 1.26 Tue Jul 17 20:47:08 2012 kperrey
//  hsd 1277 ; add c8xmrtcnevm2vtunpci d8xxrtcnevm2vtunpci to nested template list
// 
//  Revision: 1.25 Thu Jul  5 20:54:18 2012 kperrey
//  hsd 1277; added c82mesdd1d2x3thermalm6 to nested list of templates
// 
//  Revision: 1.24 Thu Jun 28 16:04:08 2012 kperrey
//  hsd 621917 ; made similar edits to d8xxrtcnevm2vtunddrdyn d8xxrtcnevm2vtunddrcmd d8xxrtcnevm2vtunddrstat d8xxrtcnevm2vtunpci
// 
//  Revision: 1.23 Thu Jun 28 10:57:25 2012 kperrey
//  hsd 621917 ; change bb level and tuc for tcn vtun macros as per tripti
// 
//  Revision: 1.22 Wed May 16 11:17:32 2012 kperrey
//  hsd 1200; add c8xmfbcmbd0nrevm1  c8xmfbcmbd1nrevm1 c8xmfbcutd0nrevm1 c8xmfbcutd1nrevm1
// 
//  Revision: 1.21 Wed May 16 11:02:24 2012 kperrey
//  hsd 1228 ; added cells to bb and template lists
// 
//  Revision: 1.20 Wed May  9 13:16:50 2012 oakin
//  added d8xltochn1273pgdgapm9x0.
// 
//  Revision: 1.19 Wed May  2 17:00:46 2012 oakin
//  updated edm/chn cells for x73a
// 
//  Revision: 1.18 Fri Apr 20 14:23:19 2012 tmurata
//  added the X73A MIM CHN cells.
// 
//  Revision: 1.17 Tue Apr 17 10:44:10 2012 dgthakur
//  Adding X73A dic and prs cells for TUC check.
// 
//  Revision: 1.16 Mon Apr 16 13:52:04 2012 tmurata
//  added p1272 MIM Cap cells per Berni Landau.
// 
//  Revision: 1.15 Thu Apr 12 17:49:09 2012 tmurata
//  added the X73 Etchring/EMGR cells.
// 
//  Revision: 1.14 Wed Apr 11 14:22:13 2012 kperrey
//  added d8xsesdclampcaptg1 and d8xsesdclampcaptg2 to TUC list and LVS black box list hsd 621650
// 
//  Revision: 1.13 Fri Apr  6 09:15:43 2012 oakin
//  added dic cell name for coag.
// 
//  Revision: 1.12 Fri Mar 30 13:41:55 2012 kperrey
//  hsd 1189 ; add m9 to ind names (4) and change 7n to 6n
// 
//  Revision: 1.11 Tue Mar 27 09:18:16 2012 kperrey
//  hsd 1162 ; added d8xmtmdiodenod1cm6 to nested list
// 
//  Revision: 1.10 Thu Mar 15 14:51:25 2012 kperrey
//  hsd 1162; added d8xmtmdiodenvm6 to nested template list
// 
//  Revision: 1.9 Tue Feb 14 20:29:33 2012 kperrey
//  hsd 621351; added remove cells as specified
// 
//  Revision: 1.8 Mon Jan 16 18:47:34 2012 oakin
//  added prscells for x72b.
// 
//  Revision: 1.7 Sat Jan 14 12:57:54 2012 kperrey
//  hsd 621170 ; suhas d8 lib updates
// 
//  Revision: 1.6 Mon Jan  9 20:11:41 2012 oakin
//  added the new etchringcell.
// 
//  Revision: 1.5 Wed Dec 28 21:30:55 2011 tmurata
//  added the p1272 etchring cell names to make the TUC effective over them.
// 
//  Revision: 1.4 Thu Dec  8 17:31:10 2011 kperrey
//  add d8xsesdpclamptgp5?vm2* to template lsit and nested list
// 
//  Revision: 1.3 Mon Nov 28 14:53:07 2011 kperrey
//  added d8 lib cells as per ChrisW
// 
//  Revision: 1.2 Tue Nov 15 15:58:18 2011 oakin
//  added c82mesdrestcnevm3 to nested list (req from Scot Z.).
// 
//  Revision: 1.1 Thu Nov  3 14:59:38 2011 kperrey
//  mvfile on Thu Nov  3 14:59:38 2011 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1272/p1272_TemplateCells;1.2
// 
//  Revision: 1.2 Tue Nov  1 17:01:40 2011 kperrey
//  hsd 1013 ; added c8xmtodic_isodic c8xmtodic_nestdic
// 
//  Revision: 1.1 Wed Oct  5 14:48:27 2011 kperrey
//  mvfile on Wed Oct  5 14:48:27 2011 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p1272_TemplateCells;1.24
// 
//  Revision: 1.24 Fri Sep 23 10:58:56 2011 kperrey
//  add the fill for the c8xmrtcnevm2vtun family ; remove the cap cell case
// 
//  Revision: 1.23 Wed Sep 21 08:20:03 2011 kperrey
//  add c8xmgnchvm1 to nestedTemplateCellsTUC list
// 
//  Revision: 1.22 Fri Sep  9 19:47:46 2011 kperrey
//  hsd 954 ; add c8xmfbfidg1evm2 as nested parent
// 
//  Revision: 1.21 Thu Sep  8 14:47:39 2011 kperrey
//  Umesh add c82mindm11l0p6n
// 
//  Revision: 1.20 Sat Aug 20 11:43:33 2011 oakin
//  added the new diode cells.
// 
//  Revision: 1.19 Tue Aug 16 10:53:16 2011 kperrey
//  hsd 930 ; totally removed the base cells; addition to last checkin
// 
//  Revision: 1.18 Tue Aug 16 10:51:25 2011 kperrey
//  removed the base cells and ensure parent (none _base part) is the true template
// 
//  Revision: 1.17 Thu Aug 11 14:38:02 2011 kperrey
//  change C8XMRTCNEVM2DAC to C8XMRTCNEVM2DAC_BASE as per tripti ; hsd 620520
// 
//  Revision: 1.16 Tue Aug  2 10:20:17 2011 kperrey
//  hsd da_help 620520; added C8XMRTCNEVM2DACTURN C8XMRTCNEVM2DACTURNCON_BASE; as per tripti
// 
//  Revision: 1.15 Mon Jul 25 11:22:29 2011 kperrey
//  added the following cells C8XMRTCNEVM2Vc8xmrtcnevm2vtuncontop_base c8xmrtcnevm2vtunconbot_base c8xmrtcnevm2vtunturntop c8xmrtcnevm2vtunturnbot c8xmrtcnevm2vtunbodtop c8xmrtcnevm2vtunbodbot c8xmrtcnevm2vtunmid c8xmrtcnevm2vtunmidfh c8xmrtcnevm2daccontop_base c8xmrtcnevm2dacconbot_base c8xmrtcnevm2dac as per Tripti
// 
//  Revision: 1.14 Fri Jul  8 15:31:48 2011 kperrey
//  hsd 903; added d8xsesddnuvm1 d8xsesddpuvm1 to template list
// 
//  Revision: 1.13 Tue Jun 21 14:02:28 2011 oakin
//  updated the template cells.
// 
//  Revision: 1.12 Thu Mar 17 10:05:24 2011 kperrey
//  added y/i bars to nested list
// 
//  Revision: 1.11 Fri Mar 11 16:26:18 2011 oakin
//  added the dic cells without the "l".
// 
//  Revision: 1.10 Thu Mar  3 16:43:55 2011 oakin
//  added c8xlvargbnd60f360zevm2 and c8xlindm11l0p8n to IL lists and tnd one tp empcells list.
// 
//  Revision: 1.9 Thu Jan 27 19:10:46 2011 kperrey
//  add c8xlesdpclampevm2 c8xlesdpclampnvm2 to nested list
// 
//  Revision: 1.8 Sun Jan 16 14:58:47 2011 kperrey
//  add c8xlgnchvm1 to nested template list
// 
//  Revision: 1.7 Thu Nov 18 07:41:48 2010 kperrey
//  Updates to bb/template list as per C Wawro 11/17 mail
// 
//  Revision: 1.6 Fri Oct 15 15:23:44 2010 kperrey
//  updated b8/c8 names to latest spec from S Zickel
// 
//  Revision: 1.5 Wed Aug 11 14:58:00 2010 kperrey
//  change nestedTemplateCellsTUCKO to nestedTemplateCellsTUC
// 
//  Revision: 1.4 Wed Aug 11 14:39:22 2010 kperrey
//  removed the a8 references and change the b8 to c8 which is the new lib prefix
// 
//  Revision: 1.3 Wed Aug 11 10:35:06 2010 kperrey
//  Update b8x/bsx prefix with c8x/csx
// 
//  Revision: 1.2 Fri Aug  6 15:25:37 2010 kperrey
//  create list of master of nested templates
// 
//  Revision: 1.1 Tue Aug  3 15:52:46 2010 kperrey
//  cell list base upon latest 1271
// 
//  Revision: 1.7 baseline from 1271
// 

#ifndef _P1272_TEMPLATECELLS_
#define _P1272_TEMPLATECELLS_

// P1271 drc_TUC Template Cells List

// 1. base KOR layers are synthesized over entire template cell EXCEPT for diffcon 
//     KOR regardless of mg layer content unless physical KOR layer exists in template
// 2. synthesized diffcon KOR will be undersized by 15nm inside each vertical (PGD) 
//     cell boundary
// 3. via and metal KOR layers are synthesized over entire template cell IF mg layer exists 
//     in template unless physical KOR layer exists in template

templateCellsTUC:list of string = {

      // MFC
      // d8 lib
         "d8xsmfcnvm4a",
         "d8xsmfcnvm4b",
         "d8xsmfcnvm4c",
         "d8xsmfcnvm6a",
         "d8xsmfcnvm6b",
         "d8xsmfcnvm6c",
         "d8xsmfcevm4a",
         "d8xsmfcevm4b",
         "d8xsmfcevm4c",
         "d8xsmfctguvm4a",
         "d8xsmfctguvm4b",
         "d8xsmfctguvm4c",
         "d8xsmfctguvm4acfio",
         "d8xsmfcnvm7apll",
         "d8xsmfcnvm4ap25pll",
         "d8xsmfcnvm6alp",
         "d8xxmfcnvm4a",
         "d8xxmfcnvm4b",
         "d8xxmfcnvm4c",
         "d8xxmfcnvm6a",
         "d8xxmfcnvm6b",
         "d8xxmfcnvm6c",
		 // missing from bb list
         "d8xsmfcevm3d",
         "d8xsmfcnvm3d",
         "d8xsmfcnvm5d",
         "d8xsmfctguvm3d",
         "d8xxmfcnvm3d",
         "d8xxmfcnvm5d",


         // hsd 1702
         "d86smfcevm6b",
         "d86smfcevm6c",
         "d86smfcnvm7apll",
         "d86xmfcnvm6a",
         "d86xmfcnvm6b",
         "d86xmfcnvm6c",
         // hsd 1702 rest of them
		 "d86smfcnvm6a",
		 "d86smfcnvm6alp",
		 "d86sindm12l0p15n",
		 "d86sindm12l0p2n",
		 "d86sindm12ctl0p2n",
		 "d86sindm12l0p265n",
         // hsd 1846 
		 "d81sindmtm1m9l1p6n",
         // hsd 1985
         "d86smfcnvm6b",
		 "d86smfcnvm6c",

         "d8xsesdclampcaptg1",
         "d8xsesdclampcaptg2",
         // hsd 1228
         "d8xsmfcnvm6adiff",
         // hsd 2023
         "d81sindmtm1m9l1p1n",

       // hsd 2230
       "d8xsesdpclamptgp25evm2nscore",

      //hsd 2037
      "d86smfcevm4aulc",
      "d86smfcevm7a",
      "d86smfcevm7b",
      "d86smfcevm7c",
      "d86smfcnvm4aulc",
      "d86smfcnvm7a",
      "d86smfcnvm7b",
      "d86smfcnvm7c",
      // hsd 2290
	  "d86smfcnvm7alp",
	  "d86smfcevm7aulc",
	  "d86smfcevm6a",
 // MFC
      // d8 lib
         "d87smfcnvm4a",
         "d87smfcnvm4b",
         "d87smfcnvm4c",
         "d87smfcnvm6a",
         "d87smfcnvm6b",
         "d87smfcnvm6c",
         "d87smfcevm4a",
         "d87smfcevm4b",
         "d87smfcevm4c",
         "d87smfctguvm4a",
         "d87smfctguvm4b",
         "d87smfctguvm4c",
         "d87smfctguvm4acfio",
         "d87smfcnvm7apll",
         "d87smfcnvm4ap25pll",
         "d87smfcnvm6alp",
         "d87xmfcnvm4a",
         "d87xmfcnvm4b",
         "d87xmfcnvm4c",
         "d87xmfcnvm6a",
         "d87xmfcnvm6b",
         "d87xmfcnvm6c",
         "d87smfcevm3d",
	       "d87smfcnvm3d", // from tao
	       "d87smfctguvm3d", // from tao
	       "d87xmfcnvm3d", // from tao
	       "d87smfcnvm5d", // from tao
	       "d87xmfcnvm5d", // from tao
         "d87smfcnvm7d", // from tao
 
         
         // hsd 1985
        
         "d87sesdclampcaptg1",
         "d87sesdclampcaptg2",
         // hsd 1228
         "d87smfcnvm6adiff",
        
       // hsd 2230
       "d87sesdpclamptgp25evm2nscore",
// MFC
      // d8 lib
         "d80smfcnvm4a",
         "d80smfcnvm4b",
         "d80smfcnvm4c",
         "d80smfcnvm6a",
         "d80smfcnvm6b",
         "d80smfcnvm6c",
         "d80smfcevm4a",
         "d80smfcevm4b",
         "d80smfcevm4c",
         "d80smfctguvm4a",
         "d80smfctguvm4b",
         "d80smfctguvm4c",
         "d80smfctguvm4acfio",
         "d80smfcnvm7apll",
         "d80smfcnvm4ap25pll",
         "d80smfcnvm6alp",
         "d80xmfcnvm4a",
         "d80xmfcnvm4b",
         "d80xmfcnvm4c",
         "d80xmfcnvm6a",
         "d80xmfcnvm6b",
         "d80xmfcnvm6c",
 
         
         // hsd 1985
        
         "d80sesdclampcaptg1",
         "d80sesdclampcaptg2",
         // hsd 1228
         "d80smfcnvm6adiff",
         // hsd 2902
         "d86smfcevm7alp",

       // hsd 2230
       "d80sesdpclamptgp25evm2nscore",

	 
	 
      // GBNWELL

      // CPR Resistors
         "d8xsrcprtguvm2a",
         "d8xsrcprtguvm2b",
		 // hsd 1228
         "d8xsrcprtguvm2c",


      // TCN Resistors
         // *** tcn vertical tune resistor
         // fill cells for resistor // as per tripti 9/23/11           

         // *** tcn dac resistor
         // as per tripti 8/1/2011

		 // hsd 1228
         "d8xsrtcnuvm2vtun",
         // hsd 1824
         "d8xsrtcnevm2dac",
         "d8xsrtcnevm2dacturn",
         "d8xsrtcnevm2dacturncon",
         "d8xsrtcnevm2daccontop",
         "d8xsrtcnevm2dacconbot",
		 // hsd 2075

 // CPR Resistors
         "d87srcprtguvm2a",
         "d87srcprtguvm2b",
		 // hsd 1228
         "d87srcprtguvm2c",


      // TCN Resistors
         // *** tcn vertical tune resistor
         // fill cells for resistor // as per tripti 9/23/11           

         // *** tcn dac resistor
         // as per tripti 8/1/2011

		 // hsd 1228
         "d87srtcnuvm2vtun",
         // hsd 1824
         "d87srtcnevm2dac",
         "d87srtcnevm2dacturn",
         "d87srtcnevm2dacturncon",
         "d87srtcnevm2daccontop",
         "d87srtcnevm2dacconbot",
		 // hsd 2075
         "d87srtcnuvm2p5vtun",

// CPR Resistors
         "d80srcprtguvm2a",
         "d80srcprtguvm2b",
		 // hsd 1228
         "d80srcprtguvm2c",


      // TCN Resistors
         // *** tcn vertical tune resistor
         // fill cells for resistor // as per tripti 9/23/11           

         // *** tcn dac resistor
         // as per tripti 8/1/2011

		 // hsd 1228
         "d80srtcnuvm2vtun",
         // hsd 1824
         "d80srtcnevm2dac",
         "d80srtcnevm2dacturn",
         "d80srtcnevm2dacturncon",
         "d80srtcnevm2daccontop",
         "d80srtcnevm2dacconbot",
		 // hsd 2075
         "d80srtcnuvm2p5vtun",

	 
	 
      // d8 lib
      
   
      // Hybrid Decaps
      // d8lib
         "d8xsdcpipnvm2",
         "d8xsdcpipnvm4",
         "d8xsdcpipnvm4e",
         "d8xsdcpipnvm6s",
         "d8xsdcpintgevm2",
         "d8xsdcpintgevm4",
// hsd 2297         "d8xsdcpiptgevm2",
// hsd 2297         "d8xsdcpiptgevm4",
         "d8xxdcpipnvm2",
         "d8xxdcpipnvm4",
		 // hsd 1431
         "d8xxdcpiphvm2",
         "d8xxdcpipnvm4p5",
         "d8xxdcpipnvm2p5",
         // hsd 1702
         "d86sdcpipnvm6s",
         // hsd 1878
		 // "d8xsdcpiptgulvm4",   // as per email from suhas
		 // "d8xsdcpintgulvm4",   // as per email from suhas
	     // hsd 1998
		 "d8xsdcpiphvm2",
		 "d8xsdcpiphvm4",
		 "d86sdcpiphvm6",
         // hsd 2282
         "d8xsdcpintgevm2_s2s",
         "d8xsdcpintgevm4_s2s",
         // hsd 2495
         "d8xsdcpiptgevm4v2",
         "d8xsdcpiptgevm2v2",
	 
// Hybrid Decaps
      // d8lib
         "d87sdcpipnvm2",
         "d87sdcpipnvm4",
         "d87sdcpipnvm4e",
         "d87sdcpipnvm6s",
         "d87sdcpintgevm2",
         "d87sdcpintgevm4",
// hsd 2297         "d8xsdcpiptgevm2",
// hsd 2297         "d8xsdcpiptgevm4",
         "d87xdcpipnvm2",
         "d87xdcpipnvm4",
		 // hsd 1431
         "d87xdcpiphvm2",
         "d87xdcpipnvm4p5",
         "d87xdcpipnvm2p5",
        
	     // hsd 1998
		 "d87sdcpiphvm2",
		 "d87sdcpiphvm4",
		
         // hsd 2282
         "d87sdcpintgevm2_s2s",
         "d87sdcpintgevm4_s2s",
         // hsd 2495
         "d87sdcpiptgevm4v2",
         "d87sdcpiptgevm2v2",

// Hybrid Decaps
      // d8lib
         "d80sdcpipnvm2",
         "d80sdcpipnvm4",
         "d80sdcpipnvm4e",
         "d80sdcpipnvm6s",
         "d80sdcpintgevm2",
         "d80sdcpintgevm4",
// hsd 2297         "d8xsdcpiptgevm2",
// hsd 2297         "d8xsdcpiptgevm4",
         "d80xdcpipnvm2",
         "d80xdcpipnvm4",
		 // hsd 1431
         "d80xdcpiphvm2",
         "d80xdcpipnvm4p5",
         "d80xdcpipnvm2p5",
        
	     // hsd 1998
		 "d80sdcpiphvm2",
		 "d80sdcpiphvm4",
		
         // hsd 2282
         "d80sdcpintgevm2_s2s",
         "d80sdcpintgevm4_s2s",
         // hsd 2495
         "d80sdcpiptgevm4v2",
         "d80sdcpiptgevm2v2",
	 
 // Inductors
      // d8 lib
         "d84sindmtm1m9l1p1n",
         "d84sindmtm1m9l2p2n",
         // hsd 1332
         "d84shipindmtm1m9l0p6n",
         "d84shipindmtm1m9l1p1n",
		 // hsd 1434
         "d84sindmtm1m9l0p7n10g",
		 // hsd 1431
         "d86sindtm1m11l1p1n",
         "d86sindtm1m11l2p2n",
	 "d84sindmtm1m9l0p7n10g",
         // hsd 1860
         "d81shipindmtm1m9l1p1n",
         // hsd 1880
		 "d86sindspiralm12l0p8n", 
		 "d86sindtm1m12l0p72n",
         // hsd 1896
		 "d81shipindmtm1l0p5n",  
		 "d81shipindmtm1m9l0p9n",
	 
		 // hsd 1866 ICF scaleable inductors
		 "ind2t_scl_*",	 

	   "d87sindmtm1m9l1p1n", // from tao
	   "d87sindmtm1m9l1p6n", // from tao
		 	
 

 
      // Varactors
      // d8 lib 
         "d8xmvargbnd60f252zevm2",
         "d8xmvargbnd64f252z2evm2",
        // hsd 2390
        "d8xmtgvargbnd24f336zevm2",
        "d8xmvargbns32f336zevm2",
        "d8xmvargbns128f336zevm2",
        "d8xsvargbnd64f252z2evm2",
		         
		 
      //  scr templates hsd 1861
      "d8xsesdscrevm1",
      "d8xsesdscruvm1", 
      "d8xsesdscrevm1_prim",
      "d8xsesdscruvm1_prim", 
      "d87sesdscrevm1_prim",
      "d87sesdscruvm1_prim",
      "d87sesdscrevm1_prim_dnw", // per tao
      "d87sesdscruvm1_prim_dnw",  // per tao

   // Varactors
      // d8 lib 
         "d87mvargbnd60f252zevm2",
         "d87mvargbnd64f252z2evm2",
        // hsd 2390
        "d87mtgvargbnd24f336zevm2",
        "d87mvargbns32f336zevm2",
        "d87mvargbns128f336zevm2",
        "d8svargbnd64f252z2evm2",
		         
		 
      //  scr templates hsd 1861
	 "d87sesdscrevm1",
      "d87sesdscruvm1",	 


// Varactors
      // d8 lib 
         "d80mvargbnd60f252zevm2",
         "d80mvargbnd64f252z2evm2",
        // hsd 2390
        "d80mtgvargbnd24f336zevm2",
        "d80mvargbns32f336zevm2",
        "d80mvargbns128f336zevm2",
        "d80svargbnd64f252z2evm2",
		         
		 
      //  scr templates hsd 1861
      "d80sesdscrevm1",   
      "d80sesdscruvm1",      


 


	 

      // HV Gnacs

      // band gap diodes
   
      // ESD Power Supply Clamps,,,
     
       // esd resistor (?)

       //diode cells
       "d8xsesddnuvterm",
       "d8xsesddpuvterm",
 
       //thermal diode
       "d8xmtmdiodenvm6",
       "d8xmtmdiodenod1cm6",
       // hsd 1702
       "d86mtmdiodenod1cm6",
       "d86mtmdiodenvm6",

      
      // d8 lib
         "d8xsesdpclampnvm2",
         "d8xsesdpclampnvm2horz",
         "d8xsesdpclamptgp5evm2",
         "d8xsesdpclamptgp5evm2core",
         "d8xsesdpclamptgp5uvm2",
         "d8xsesdpclamptgp5uvm2core",
         "d8xxesdpclampnvm2horz",
         "d8xsesdpclampxllgatedevm2core",
         "d8xsesdpclampxllgatedevm2",
         "d8xsesdpclampxllp5gatedevm2core",
         "d8xsesdpclampxllp5gatedevm2",
         "d8xmesdpclampxllgatedevm2core",  //candidate for removal
         "d8xmesdpclampxllgatedevm2",  //candidate for removal
         "d8xmesdpclampgatedevm2", // as per Krishna Bharath email
         "d8xxesdpclampxllgatedevm2",
         "d8xxesdpclampxllp5gatedevm2",

    // as per suhas and ICF  hsd 2847 
    "d8xsesdpclampdnwnvm2",
    "d8xsesdpclampdnwtgp5evm2core",
    "d8xsesdpclampdnwtgp5evm2",

	  //diode cells
       "d87sesddnuvterm",
       "d87sesddpuvterm",
 
       //thermal diode
       "d87mtmdiodenvm6",
       "d87mtmdiodenod1cm6",
      
      
      // d8 lib
         "d87sesdpclampnvm2",
         "d87sesdpclampnvm2horz",
         "d87sesdpclamptgp5evm2",
         "d87sesdpclamptgp5evm2core",
         "d87sesdpclamptgp5uvm2",
         "d87sesdpclamptgp5uvm2core",
         "d87xesdpclampnvm2horz",
         "d87sesdpclampxllgatedevm2core",
         "d87sesdpclampxllgatedevm2",
         "d87sesdpclampxllp5gatedevm2core",
         "d87sesdpclampxllp5gatedevm2",
         "d87mesdpclampxllgatedevm2core",  //candidate for removal
         "d87mesdpclampxllgatedevm2",  //candidate for removal
         "d87mesdpclampgatedevm2", // as per Krishna Bharath email
         "d87xesdpclampxllgatedevm2",
         "d87xesdpclampxllp5gatedevm2", 

 //diode cells
       "d80sesddnuvterm",
       "d80sesddpuvterm",
 
       //thermal diode
       "d80mtmdiodenvm6",
       "d80mtmdiodenod1cm6",
      
      
      // d8 lib
         "d80sesdpclampnvm2",
         "d80sesdpclampnvm2horz",
         "d80sesdpclamptgp5evm2",
         "d80sesdpclamptgp5evm2core",
         "d80sesdpclamptgp5uvm2",
         "d80sesdpclamptgp5uvm2core",
         "d80xesdpclampnvm2horz",
         "d80sesdpclampxllgatedevm2core",
         "d80sesdpclampxllgatedevm2",
         "d80sesdpclampxllp5gatedevm2core",
         "d80sesdpclampxllp5gatedevm2",
         "d80mesdpclampxllgatedevm2core",  //candidate for removal
         "d80mesdpclampxllgatedevm2",  //candidate for removal
         "d80mesdpclampgatedevm2", // as per Krishna Bharath email
         "d80xesdpclampxllgatedevm2",
         "d80xesdpclampxllp5gatedevm2", 
      // 	 hsd 2908

      // Fib Cut 

      // Fib Connect 
	 
      // DIC
	 "e8xmtodic_isodic",
   "e8xmtodic_nestdic",
	 "d8xmtodic_isodic",
   "d8xmtodic_nestdic", //X73A dic cells 
     // hsd 1703
	 "d86mtodic_isodic",
   "d86mtodic_nestdic",
	 "d81mtodic_isodic",  // from email dipto from Julie

       // IY FIDUCIALS
         "d8xltoprs_y_small",
         "d8xltoprs_i_small",
	     "d8xmtoprs_y_small",
       "d8xmtoprs_i_small",  //x73A prs cells
	   // hsd 1703
       "d86mtoprs_i_small",
       "d86mtoprs_y_small",
       "d81mtoprs_i_small",
       "d81mtoprs_y_small",  // email from dipto from berni
       "d81mtoprs_i_small_cc",
       "d81mtoprs_y_small_cc",  // email from dipto from berni


 // Fib Cut 

      // Fib Connect 
	 
      // DIC
	 "e8xmtodic_isodic",
   "e8xmtodic_nestdic",
	 "d87mtodic_isodic",
   "d87mtodic_nestdic", //X73A dic cells 
    
       // IY FIDUCIALS
         "d87ltoprs_y_small",
         "d87ltoprs_i_small",
	     "d87mtoprs_y_small",
       "d87mtoprs_i_small",  //x73A prs cells


// Fib Cut 

      // Fib Connect 
	 
      // DIC
	 "e8xmtodic_isodic",
   "e8xmtodic_nestdic",
	 "d80mtodic_isodic",
   "d80mtodic_nestdic", //X73A dic cells 
    
       // IY FIDUCIALS
         "d80ltoprs_y_small",
         "d80ltoprs_i_small",
	     "d80mtoprs_y_small",
       "d80mtoprs_i_small",  //x73A prs cells	 
	 
      // Etchring
	 
	 //these are the X73A EMGR cells.
	 "tc0emgrdx73acrn",  //"TC0EMGRDX73ACRN", 
	 "tc0emgrdx73aogd",  //"TC0EMGRDX73AOGD", 
	 "tc0emgrdx73apgd",  //"TC0EMGRDX73APGD",

	 //these are the TC ETR cells.
	 "tc0er1273crnx0",   //"TC0ER1273CRNX0", 
	 "tc0er1273pgdx0",   //"TC0ER1273PGDX0", 
	 "tc0er1273ogdx0",   //"TC0ER1273OGDX0", 

	 //and these are the SRAM (and product) ETR cells (except the one with "SRAM" in its name)
	 "d8xltoer1273crnx0", //"D8XLTOER1273CRNX0",
	 "d8xltoer1273pgdx0", //"D8XLTOER1273PGDX0",
	 "d8xltoer1273ogdx0", //"D8XLTOER1273OGDX0",
	 "d8xltosramer1273ogdx0", //"D8XLTOSRAMER1273OGDX0"
	 "d8xltoer1273pgdx01512",
	 "d8xltoer1273ogdx0168",
	 "d8xltoer1273ogdx084",
	 "d8xltoer1273pgdx0_m9g",
	 "d8xltoer1273ogdx0_m9g",
	 // Adding the dot version of the above
	 "d86ltoer1273crnx0", 
   	 "d86ltoer1273pgdx0", 
   	 "d86ltoer1273pgdx0_m12g",
   	 "d86ltoer1273pgdx01512",
   	 "d86ltoer1273ogdx0",
   	 "d86ltoer1273ogdx0_m12g",
   	 "d86ltoer1273ogdx0168",
   	 "d86ltoer1273ogdx084",
   	 "d86ltosramer1273ogdx0",
	 // Adding dot1 version of the above
	 "d81ltoer1273crnx0", 
   	 "d81ltoer1273pgdx0", 
   	 "d81ltoer1273pgdx0_m9g",
   	 "d81ltoer1273pgdx01512",
   	 "d81ltoer1273ogdx0",
   	 "d81ltoer1273ogdx0_m9g",
   	 "d81ltoer1273ogdx0168",
   	 "d81ltoer1273ogdx084",
   	 "d81ltosramer1273ogdx0",

 //also CCGR cells need to be here
	 "x73tsv_tc0emgrdx73acrn",     //"X73TSV_TC0EMGRDX73ACRN",
	 "x73tsv_tc0emgrdx73aogd",     //"X73TSV_TC0EMGRDX73AOGD", 
	 "x73tsv_tc0emgrdx73aogd_gap", //"X73TSV_TC0EMGRDX73AOGD_GAP", 
	 "x73tsv_tc0emgrdx73aogd_gap_1p96", //"X73TSV_TC0EMGRDX73AOGD_GAP_1P96",
	 "x73tsv_tc0emgrdx73aogd_gap_2p24", //"X73TSV_TC0EMGRDX73AOGD_GAP_2P24",
	 "x73tsv_tc0emgrdx73aogd_gap_2p52", //"X73TSV_TC0EMGRDX73AOGD_GAP_2P52",
	 "x73tsv_tc0emgrdx73apgd",     //"X73TSV_TC0EMGRDX73APGD", 
	 "x73tsv_tc0emgrdx73apgd_gap", //"X73TSV_TC0EMGRDX73APGD_GAP"

	 "d8xltsv_emgrd1273ogd",
	 "d8xltsv_emgrd1273ogd_gap",
	 "d8xltsv_emgrd1273ogd_gap_1p96",
	 "d8xltsv_emgrd1273ogd_gap_2p24",
	 "d8xltsv_emgrd1273ogd_gap_2p52",
	 "d8xltsv_emgrd1273pgd",
	 "d8xltsv_emgrd1273pgd_gap",
	 "d8xltsv_emgrd1273crn",

      // tsv catch-cup as per kalyan
	  "d8xltsv_ccsymb",
	  "d8xltsv_ccspcralt1",
	   
      //EDM MIM Cap Cells	   	 
    
	 "d8xltochn1273crnx0",
	 "d8xltochn1273ogd_ce12res",
	 "d8xltochn1273pgd_m9v9lkg",
	 "d8xltochn1273ogdgapx0",
	 "d8xltochn1273ogdiox0",
	 "d8xltochn1273pgdiox0",
	 "d8xltochn1273pgdgapx0",
	 "d8xltochn1273ogdgapm9x0",
	 "d8xltosramchn1273ogdgapx0",
   "d8xltochn1273pgdgapm9x0",
	 

		  // hsd 1703
   "d86ltosramer1273crnx0",
   "d86ltosramer1273ogdx0",
   "d86ltosramer1273ogdx0",
   "d86ltosramer1273pgdx0",
	  

	 "d8xltsv_edm1273crnx0",
	 "d8xltsv_edm1273ogdiox0",
	 "d8xltsv_edm1273ogdx0", 
	 "d8xltsv_edm1273ogdx0_diode",
	 "d8xltsv_edm1273ogdx0_gap", 
	 "d8xltsv_edm1273pgdx0",
	 "d8xltsv_edm1273pgdx0_diode",

     //  as per email Berni / Dipto
	 
	   // hsd 621917 ; tripti
     "d8xxrtcnevm2vtunpci", 
	   "d8xxrtcnevm2vtunddrstat", 
	   "d8xxrtcnevm2vtunddrcmd", 
	   "d8xxrtcnevm2vtunddrdyn",

       // hsd 2219 diode templates
       "d8xmbgdiodehvm1",

       // hsd 2159 ; suhas
       "d8xxrtcnevm2abod_01",
       "d8xxrtcnevm2abod_02",
       "d8xxrtcnevm2abod_03",
       "d8xxrtcnevm2aconl",
       "d8xxrtcnevm2aconr",
       "d8xxrtcnevm2daccontop",
       "d8xxrtcnevm2dacconbot",
       "d8xxrtcnevm2vtunbodtop",
       "d8xxrtcnevm2vtunbodmid",
       "d8xxrtcnevm2vtunbodbot",
       "d8xxrtcnevm2vtunturntop",
       "d8xxrtcnevm2vtunturnbot",
       "d8xxrtcnevm2vtuncontop",
       "d8xxrtcnevm2vtunconbot",
       "d8xxrtcnevm2vtunturntop",
       "d8xxrtcnevm2vtunturnbot",
       "d8xxrtcnevm2vtunbodtop",
       "d8xxrtcnevm2vtunbodbot",
       "d8xxrtcnevm2vtunmid",
       "d8xxrtcnevm2vtunmidfh",
       "d8xxrtcnevm2vtunfil100m0a0",
       "d8xxrtcnevm2vtunfil1npm0a0",
       "d8xxrtcnevm2vtunfil200m0a0",
       "d8xxrtcnevm2vtunfil2npm0a0",
       "d8xxrtcnevm2vtunfil2npm1a1",
       "d8xxrtcnevm2vtunfil3npm1a1",
       "d8xxrtcnevm2vtunfil4npm1a1",
       "d8xxrtcnevm2vtunfill30nn0m0a0",
       "d8xxrtcnevm2vtunfill30pp0m0a0",
       "d8xxrtcnevm2vtunfill5npp0m0c0",
       "d8xxrtcnevm2vtunfill6npp0m1c1",
       "d8xxrtcnevm2dac",
       "d8xxrtcnevm2dacturn",
       "d8xxrtcnevm2dacturncon",
       // hsd 2331 
       "d8xxesdrestcnevm3",


// Etchring
	 	 
	 //and these are the SRAM (and product) ETR cells (except the one with "SRAM" in its name)
	 "d87ltoer1273crnx0", //"D8XLTOER1273CRNX0",
	 "d87ltoer1273pgdx0", //"D8XLTOER1273PGDX0",
	 "d87ltoer1273ogdx0", //"D8XLTOER1273OGDX0",
	 "d87ltosramer1273ogdx0", //"D8XLTOSRAMER1273OGDX0"
	 "d87ltoer1273pgdx01512",
	 "d87ltoer1273ogdx0168",
	 "d87ltoer1273ogdx084",
	 "d87ltoer1273pgdx0_m9g",
	 "d87ltoer1273ogdx0_m9g",
	
 //also CCGR cells need to be here
       
         "d87ltsv_emgrd1273ogd",
	 "d87ltsv_emgrd1273ogd_gap",
	 "d87ltsv_emgrd1273ogd_gap_1p96",
	 "d87ltsv_emgrd1273ogd_gap_2p24",
	 "d87ltsv_emgrd1273ogd_gap_2p52",
	 "d87ltsv_emgrd1273pgd",
	 "d87ltsv_emgrd1273pgd_gap",
	 "d87ltsv_emgrd1273crn",

      // tsv catch-cup as per kalyan
	  "d87ltsv_ccsymb",
	  "d87ltsv_ccspcralt1",
	   
      //EDM MIM Cap Cells	   	 
    
	 "d87ltochn1273crnx0",
	 "d87ltochn1273ogd_ce12res",
	 "d87ltochn1273pgd_m9v9lkg",
	 "d87ltochn1273ogdgapx0",
	 "d87ltochn1273ogdiox0",
	 "d87ltochn1273pgdiox0",
	 "d87ltochn1273pgdgapx0",
	 "d87ltochn1273ogdgapm9x0",
	 "d87ltosramchn1273ogdgapx0",
   "d8xltochn1273pgdgapm9x0",
	 

		  // hsd 1703
		 
	

	 "d87ltsv_edm1273crnx0",
	 "d87ltsv_edm1273ogdiox0",
	 "d87ltsv_edm1273ogdx0", 
	 "d87ltsv_edm1273ogdx0_diode",
	 "d87ltsv_edm1273ogdx0_gap", 
	 "d87ltsv_edm1273pgdx0",
	 "d87ltsv_edm1273pgdx0_diode",

     	 
	   // hsd 621917 ; tripti
       "d87xrtcnevm2vtunpci", 
	   "d87xrtcnevm2vtunddrstat", 
	   "d87xrtcnevm2vtunddrcmd", 
	   "d87xrtcnevm2vtunddrdyn",

       // hsd 2219 diode templates
       "d87mbgdiodehvm1",
       "d87sesddnuvterm",
       "d87sesddpuvterm",

       // hsd 2159 ; suhas
       "d87xrtcnevm2abod_01",
       "d87xrtcnevm2abod_02",
       "d87xrtcnevm2abod_03",
       "d87xrtcnevm2aconl",
       "d87xrtcnevm2aconr",
       "d87xrtcnevm2daccontop",
       "d87xrtcnevm2dacconbot",
       "d87xrtcnevm2vtunbodtop",
       "d87xrtcnevm2vtunbodmid",
       "d87xrtcnevm2vtunbodbot",
       "d87xrtcnevm2vtunturntop",
       "d87xrtcnevm2vtunturnbot",
       "d87xrtcnevm2vtuncontop",
       "d87xrtcnevm2vtunconbot",
       "d87xrtcnevm2vtunturntop",
       "d87xrtcnevm2vtunturnbot",
       "d87xrtcnevm2vtunbodtop",
       "d87xrtcnevm2vtunbodbot",
       "d87xrtcnevm2vtunmid",
       "d87xrtcnevm2vtunmidfh",
       "d87xrtcnevm2vtunfil100m0a0",
       "d87xrtcnevm2vtunfil1npm0a0",
       "d87xrtcnevm2vtunfil200m0a0",
       "d87xrtcnevm2vtunfil2npm0a0",
       "d87xrtcnevm2vtunfil2npm1a1",
       "d87xrtcnevm2vtunfil3npm1a1",
       "d87xrtcnevm2vtunfil4npm1a1",
       "d87xrtcnevm2vtunfill30nn0m0a0",
       "d87xrtcnevm2vtunfill30pp0m0a0",
       "d87xrtcnevm2vtunfill5npp0m0c0",
       "d87xrtcnevm2vtunfill6npp0m1c1",
       "d87xrtcnevm2dac",
       "d87xrtcnevm2dacturn",
       "d87xrtcnevm2dacturncon",
       // hsd 2331 
       "d87xesdrestcnevm3",


// Etchring
	 	 
	 //and these are the SRAM (and product) ETR cells (except the one with "SRAM" in its name)
	 "d80ltoer1273crnx0", //"D8XLTOER1273CRNX0",
	 "d80ltoer1273pgdx0", //"D8XLTOER1273PGDX0",
	 "d80ltoer1273ogdx0", //"D8XLTOER1273OGDX0",
	 "d80ltosramer1273ogdx0", //"D8XLTOSRAMER1273OGDX0"
	 "d80ltoer1273pgdx01512",
	 "d80ltoer1273ogdx0168",
	 "d80ltoer1273ogdx084",
	 "d80ltoer1273pgdx0_m9g",
	 "d80ltoer1273ogdx0_m9g",
	
 //also CCGR cells need to be here
       
         "d80ltsv_emgrd1273ogd",
	 "d80ltsv_emgrd1273ogd_gap",
	 "d80ltsv_emgrd1273ogd_gap_1p96",
	 "d80ltsv_emgrd1273ogd_gap_2p24",
	 "d80ltsv_emgrd1273ogd_gap_2p52",
	 "d80ltsv_emgrd1273pgd",
	 "d80ltsv_emgrd1273pgd_gap",
	 "d80ltsv_emgrd1273crn",

      // tsv catch-cup as per kalyan
	  "d80ltsv_ccsymb",
	  "d80ltsv_ccspcralt1",
	   
      //EDM MIM Cap Cells	   	 
    
	 "d80ltochn1273crnx0",
	 "d80ltochn1273ogd_ce12res",
	 "d80ltochn1273pgd_m9v9lkg",
	 "d80ltochn1273ogdgapx0",
	 "d80ltochn1273ogdiox0",
	 "d80ltochn1273pgdiox0",
	 "d80ltochn1273pgdgapx0",
	 "d80ltochn1273ogdgapm9x0",
	 "d80ltosramchn1273ogdgapx0",
   "d8xltochn1273pgdgapm9x0",
	 

		  // hsd 1703
		 
	

	 "d80ltsv_edm1273crnx0",
	 "d80ltsv_edm1273ogdiox0",
	 "d80ltsv_edm1273ogdx0", 
	 "d80ltsv_edm1273ogdx0_diode",
	 "d80ltsv_edm1273ogdx0_gap", 
	 "d80ltsv_edm1273pgdx0",
	 "d80ltsv_edm1273pgdx0_diode",

     	 
	   // hsd 621917 ; tripti
       "d80xrtcnevm2vtunpci", 
	  "d80xrtcnevm2vtunddrstat", 
	   "d80xrtcnevm2vtunddrcmd", 
	   "d80xrtcnevm2vtunddrdyn",

       // hsd 2219 diode templates
       "d80mbgdiodehvm1",
       "d80sesddnuvterm",
       "d80sesddpuvterm",

       // hsd 2159 ; suhas
       "d80xrtcnevm2abod_01",
       "d80xrtcnevm2abod_02",
       "d80xrtcnevm2abod_03",
       "d80xrtcnevm2aconl",
       "d80xrtcnevm2aconr",
       "d80xrtcnevm2daccontop",
       "d80xrtcnevm2dacconbot",
       "d80xrtcnevm2vtunbodtop",
       "d80xrtcnevm2vtunbodmid",
       "d80xrtcnevm2vtunbodbot",
       "d80xrtcnevm2vtunturntop",
       "d80xrtcnevm2vtunturnbot",
       "d80xrtcnevm2vtuncontop",
       "d80xrtcnevm2vtunconbot",
       "d80xrtcnevm2vtunturntop",
       "d80xrtcnevm2vtunturnbot",
       "d80xrtcnevm2vtunbodtop",
       "d80xrtcnevm2vtunbodbot",
       "d80xrtcnevm2vtunmid",
       "d80xrtcnevm2vtunmidfh",
       "d80xrtcnevm2vtunfil100m0a0",
       "d80xrtcnevm2vtunfil1npm0a0",
       "d80xrtcnevm2vtunfil200m0a0",
       "d80xrtcnevm2vtunfil2npm0a0",
       "d80xrtcnevm2vtunfil2npm1a1",
       "d80xrtcnevm2vtunfil3npm1a1",
       "d80xrtcnevm2vtunfil4npm1a1",
       "d80xrtcnevm2vtunfill30nn0m0a0",
       "d80xrtcnevm2vtunfill30pp0m0a0",
       "d80xrtcnevm2vtunfill5npp0m0c0",
       "d80xrtcnevm2vtunfill6npp0m1c1",
       "d80xrtcnevm2dac",
       "d80xrtcnevm2dacturn",
       "d80xrtcnevm2dacturncon",
       // hsd 2331 
       "d80xesdrestcnevm3",

      // edm cells only top cells as per bernie email 10/28/2014
      // since these are all top cells there should be no need for nested def
      // P1273.4 EDM cell names:
      "d8xltoedm1273crnx0",
      "d8xltoedm1273ogdfillx0",
      "d8xltoedm1273ogdiox0",
      "d8xltoedm1273ogdx0",
      "d8xltoedm1273ogdx0_diode",
      "d8xltoedm1273pgdfillx0",
      "d8xltoedm1273pgdx0",
      "d8xltoedm1273pgdx0_diode",
      "d8xltoedm1273pgdiox0",

      // P1273.1 EDM cell names:
      "d81ltoedm1273crnx0",
      "d8xltoedm1273ogdfillx0",
      "d81ltoedm1273ogdiox0",
      "d81ltoedm1273ogdx0",
      "d81ltoedm1273ogdx0_diode",
      "d8xltoedm1273pgdfillx0",
      "d81ltoedm1273pgdx0",
      "d81ltoedm1273pgdx0_diode",
      "d81ltoedm1273pgdiox0",

      //P1273.6 EDM cell names:
      "d86ltoedm1273crnx0",
      "d86ltoedm1273ogdfillx0",
      "d86ltoedm1273ogdiox0",
      "d86ltoedm1273ogdx0",
      "d86ltoedm1273ogdx0_diode",
      "d86ltoedm1273pgdfillx0",
      "d86ltoedm1273pgdx0",
      "d86ltoedm1273pgdx0_diode",
      "d86ltoedm1273pgdiox0",
     

      "d8xxrtcnevm2aconl_3tp", //hsd 2886
      "d8xxrtcnevm2dacconbot_3tp", //hsd 2886
      "d8xxrtcnevm2dacturncon_3tp", //hsd 2886
      "d8xsrtcnuvm2vtun_3tp", //hsd 2886
      "d8xsrtcnuvm2p5vtun_3tp", //hsd 2886
      "d8xxrtcnevm2vtun_ddrcmd_3tp", //hsd 2886
      "d8xxrtcnevm2vtun_ddrdyn_3tp", //hsd 2886
      "d8xxrtcnevm2vtun_ddrstat_3tp", //hsd 2886
      "d8xxrtcnevm2vtunpci_3tp", //hsd 2886
      "d8xxrtcnevm2aconl_3tn", //hsd 2886
      "d8xxrtcnevm2dacconbot_3tn", //hsd 2886
      "d8xxrtcnevm2dacturncon_3tn", //hsd 2886
      "d8xsrtcnuvm2vtun_3tn", //hsd 2886
      "d8xsrtcnuvm2p5vtun_3tn", //hsd 2886
      "d8xxrtcnevm2vtun_ddrcmd_3tn", //hsd 2886
      "d8xxrtcnevm2vtun_ddrdyn_3tn", //hsd 2886
      "d8xxrtcnevm2vtun_ddrstat_3tn", //hsd 2886
      "d8xxrtcnevm2vtunpci_3tn", //hsd 2886

      "d8xmtgvargbns16f336zevm2", // hsd 2880
      "d8xmtgvargbns56f336zevm2", // hsd 2880

      "d8xsesdclampdnwcaptgehv", // hsd 2847 

     // placeholder
     "kArLpLaCeHoLdEr"
} ;

nestedTemplateCellsTUC:list of string = {

      // ESD Power Supply Clamps,,,
	  // hsd 1702
	  "d86mtmdiodenod1cm6",    // nested
	  "d86mtmdiodenvm6",       // nested

       // IY FIDUCIALS
       "d8xltoprs_y_small",  // nested
       "d8xltoprs_i_small",  // nested
       "d8xmtoprs_y_small",  // nested
       "d8xmtoprs_i_small",  // nested

       "d87ltoprs_y_small",  // nested
       "d87ltoprs_i_small",  // nested
       "d87mtoprs_y_small",  // nested
       "d87mtoprs_i_small",  // nested

       "d80ltoprs_y_small",  // nested
       "d80ltoprs_i_small",  // nested
       "d80mtoprs_y_small",  // nested
       "d80mtoprs_i_small",    // nested
	   // hsd 1703
       "d86mtoprs_i_small",  // nested
	   "d86mtoprs_y_small",  // nested
       "d81mtoprs_i_small",   // nested
	   "d81mtoprs_y_small",    // nested
       "d81mtoprs_i_small_cc",   // nested
	   "d81mtoprs_y_small_cc",    // nested
	  
       // d8 esd clamps 
       "d8xsesdpclamptgp5evm2",  // nested
       "d8xsesdpclamptgp5uvm2",  // nested
       "d8xsesdpclampxllgatedevm2",  // nested
       "d8xsesdpclampxllp5gatedevm2",  // nested
       "d8xmesdpclampxllgatedevm2",  // nested

       "d87sesdpclamptgp5evm2",  // nested
       "d87sesdpclamptgp5uvm2",  // nested
       "d87sesdpclampxllgatedevm2",  // nested
       "d87sesdpclampxllp5gatedevm2",  // nested
       "d87mesdpclampxllgatedevm2",  // nested

       "d80sesdpclamptgp5evm2",  // nested
       "d80sesdpclamptgp5uvm2",  // nested
       "d80sesdpclampxllgatedevm2",  // nested
       "d80sesdpclampxllp5gatedevm2",  // nested
       "d80mesdpclampxllgatedevm2",    // nested
    "d8xsesdpclampdnwtgp5evm2",

       //diode
       "d8xmtmdiodenvm6",  // nested
       "d8xmtmdiodenod1cm6",  // nested

       "d87mtmdiodenvm6",  // nested
       "d87mtmdiodenod1cm6",  // nested

       "d80mtmdiodenvm6",  // nested
       "d80mtmdiodenod1cm6",  // nested

       //thermal diode

        // tcn
		"d8xxrtcnevm2vtunpci",   // nested
		"d8xxrtcnevm2vtunddrcmd",  // nested
		"d8xxrtcnevm2vtunddrdyn",  // nested
		"d8xxrtcnevm2vtunddrstat",  // nested

	  	"d87xrtcnevm2vtunpci",   // nested
		"d87xrtcnevm2vtunddrcmd",  // nested
		"d87xrtcnevm2vtunddrdyn",  // nested
		"d87xrtcnevm2vtunddrstat",  // nested

	  	"d80xrtcnevm2vtunpci",   // nested
		"d80xrtcnevm2vtunddrcmd",  // nested
		"d80xrtcnevm2vtunddrdyn",  // nested
		"d80xrtcnevm2vtunddrstat",  // nested


       // Fib Connect 

       // edm diodes
      "d8xltsv_edm1273ogdx0_diode",  // nested
      "d8xltsv_edm1273pgdx0_diode",  // nested

      "d87ltsv_edm1273ogdx0_diode",  // nested
      "d87ltsv_edm1273pgdx0_diode",  // nested

      "d80ltsv_edm1273ogdx0_diode",  // nested
      "d80ltsv_edm1273pgdx0_diode",	    // nested

      "d86ltoedm1273pgdx0_diode",  // nested
      "d86ltoedm1273ogdx0_diode",  // nested
      "d81ltoedm1273pgdx0_diode",  // nested
      "d81ltoedm1273ogdx0_diode",  // nested
      "d8xltoedm1273ogdx0_diode",  // nested
      "d8xltoedm1273pgdx0_diode",  // nested

       	//resistor template
       // hsd 2331 
       "d8xxesdrestcnevm3",  // nested
       "d87xesdrestcnevm3",  // nested
       "d80xesdrestcnevm3",  // nested

      "d8xxrtcnevm2aconl_3tp", //hsd 2886  // nested
      "d8xxrtcnevm2dacconbot_3tp", //hsd 2886  // nested
      "d8xxrtcnevm2dacturncon_3tp", //hsd 2886  // nested
      "d8xsrtcnuvm2vtun_3tp", //hsd 2886  // nested
      "d8xsrtcnuvm2p5vtun_3tp", //hsd 2886  // nested
      "d8xxrtcnevm2vtun_ddrcmd_3tp", //hsd 2886  // nested
      "d8xxrtcnevm2vtun_ddrdyn_3tp", //hsd 2886  // nested
      "d8xxrtcnevm2vtun_ddrstat_3tp", //hsd 2886  // nested
      "d8xxrtcnevm2vtunpci_3tp", //hsd 2886  // nested
      "d8xxrtcnevm2aconl_3tn", //hsd 2886  // nested
      "d8xxrtcnevm2dacconbot_3tn", //hsd 2886  // nested
      "d8xxrtcnevm2dacturncon_3tn", //hsd 2886  // nested
      "d8xsrtcnuvm2vtun_3tn", //hsd 2886  // nested
      "d8xsrtcnuvm2p5vtun_3tn", //hsd 2886  // nested
      "d8xxrtcnevm2vtun_ddrcmd_3tn", //hsd 2886  // nested
      "d8xxrtcnevm2vtun_ddrdyn_3tn", //hsd 2886  // nested
      "d8xxrtcnevm2vtun_ddrstat_3tn", //hsd 2886  // nested
      "d8xxrtcnevm2vtunpci_3tn" //hsd 2886  // nested
};

// Bitcell checks
// add cells not in bitcells or tringcells
__TUCAddBitCells_: list of string = {
   "x73sramtrbitcorner", 
   "x73hpcsramtrbittobiasmid",
   //  based upon Eric's test cases (x73bhpc1ary64x16lp x73hpdpsramtrbittobias_dum x73lvdpary256x128lp_opc)
   "x73hpc1bitedgelp",
   "x73hpc1bitlp",
   "x73hpc1arygaplp",
   "x73lvdpbitlp",
   "x73lvdpbitlp2",
   "x73lvdpsramtrbittobias",
   "x73lvdpbitedgelp",
   "x73lvdpbitedgelp2",
   "x73lvdparygaplp",
   "x73lvdparygaplp2",
   // hsd 1980
   "x73rficfb",
   // hsd 2027
   "x73hdcsramtrbittodig",
   "x73hdcsramtrbittodecx4"
};

_TUCBitCells:list of string = strcat(strcat(strcat(strcat(bitcells, tringcells), ulpbitcells), ulctr2digcells),__TUCAddBitCells_);

// list of extra bitcells hierarchy just for TUC checks
// This is to handle the m2/v1 programming that occurs
TUCbitCells_M2V1: list of string = {
      //  based upon Eric's test cases (x73bhpc1ary64x16lp x73hpdpsramtrbittobias_dum x73lvdpary256x128lp_opc)
      "x73lvdpary128x4lp",
      };
      _drall_bcm2v1:list of string = strcat(_TUCBitCells, TUCbitCells_M2V1);

// populate placementHash for legal parent child combos (child cant exist outside of parent)
// hash to use for checking child / legal parent relation

primPlacementHash:typeHashString2ListOfString = {
    "d8xsesdclamprestg" => {
         "d8xsesdpclamptgp5evm2core",
         "d8xsesdpclamptgp5uvm2core",
         "d8xsesdpclamptgp5evm2",
         "d8xsesdpclamptgp5uvm2",
         //hsd 2230
         "d8xsesdpclamptgp25evm2nscore"
    },
    "d8xsesdclampres" => {
         "d8xsesdpclampnvm2",
         "d8xsesdpclampnvm2horz",
         "d8xxesdpclampnvm2horz",
         "d8xsesdpclampxllgatedevm2",
         "d8xsesdpclampxllp5gatedevm2",
         "d8xxesdpclampxllgatedevm2",
         "d8xxesdpclampxllp5gatedevm2",
         "d8xmesdpclampgatedevm2"
    },

    "d87sesdclamprestg" => {
         "d87sesdpclamptgp5evm2core",
         "d87sesdpclamptgp5uvm2core",
         "d87sesdpclamptgp5evm2",
         "d87sesdpclamptgp5uvm2",
         //hsd 2230
         "d87sesdpclamptgp25evm2nscore"
    },
    "d87sesdclampres" => {
         "d87sesdpclampnvm2",
         "d87sesdpclampnvm2horz",
         "d87xesdpclampnvm2horz",
         "d87sesdpclampxllgatedevm2",
         "d87sesdpclampxllp5gatedevm2",
         "d87xesdpclampxllgatedevm2",
         "d87xesdpclampxllp5gatedevm2",
         "d87mesdpclampgatedevm2"
    },

    "d80sesdclamprestg" => {
         "d80sesdpclamptgp5evm2core",
         "d80sesdpclamptgp5uvm2core",
         "d80sesdpclamptgp5evm2",
         "d80sesdpclamptgp5uvm2",
         //hsd 2230
         "d80sesdpclamptgp25evm2nscore"
    },
    "d80sesdclampres" => {
         "d80sesdpclampnvm2",
         "d80sesdpclampnvm2horz",
         "d80xesdpclampnvm2horz",
         "d80sesdpclampxllgatedevm2",
         "d80sesdpclampxllp5gatedevm2",
         "d80xesdpclampxllgatedevm2",
         "d80xesdpclampxllp5gatedevm2",
         "d80mesdpclampgatedevm2"
    }
};

// hsd 2986
templateCellsNoDNW:list of string = {
   "d8xmbgdiodehvm1",
   "d86mtmdiodenvm6",
   "d86mtmdiodenod1cm6",
   "d8xmtmdiodenvm6",
   "d8xmtmdiodenod1cm6",
   "d86sindm12l0p2n",
   "d86sindtm1m12l0p72n",
   "d86sindspiralm12l0p8n",
   "ind2t_scl_*",
   "d8xmtgvargbnd24f336zevm2",
   "d8xmvargbnd64f252z2evm2",
   "d8xmvargbns128f336zevm2",
   "d8xmvargbns32f336zevm2",
   "d8xsvargbnd64f252z2evm2",
   "d8xmtgvargbns16f336z2evm2",
   "d8xmtgvargbns56f336z2evm2",
   "d8xxesdpclampnvm2horz",
   "d8xxesdrestcnevm3",
   "d8xmesdpclampgatedevm2",
   "d8xxesdpclampxllgatedevm2",
   "d8xxesdpclampxllp5gatedevm2",
   "d8xsesdclampcaptgehv",
   "d8xsesdclampcaptguhv",
   "d8xsesdpclampnvm2",
   "d8xsesdpclampnvm2horz",
   "d8xsesdpclamptgp5evm2",
   "d8xsesdpclamptgp5evm2core",
   "d8xsesdpclamptgp5uvm2",
   "d8xsesdpclamptgp5uvm2core",
   "d8xsesddpuvm1",
   "d8xsesddpuvterm",
   "d84sesdd7p5uvm7",
   "d86sesdd1d2uvm4",
   "d86sesdd1d2uvm4_lu",
   "d86sesdd1d2uvm7perf",
   "d86sesdd1d2uvm7ulc",
   "d86sesdd2uvm7perf",
   "d86sesdd2uvm7ulc",
   "d86sesdd3d4uvm4_lu",
   "d86sesdd7p5uvm7",
   "d86sesddpuvm1ulc",
   "d8xsesdd1d2uvm4",
   "d8xsesdd1d2uvm4_lu",
   "d8xsesdd1d2uvm7perf",
   "d8xsesdd2uvm3",
   "d8xsesdd2uvm3_lu",
   "d8xsesdd2uvm7perf",
   "d8xsesdd3d4uvm4",
   "d8xsesdd3d4uvm4_lu",
   "d8xsesdd3uvm3",
   "d8xsesdd3uvm3_lu",
   "d8xsesdd4uvm3",
   "d8xsesdd4uvm3_lu"
};

#if (defined(_drICFBCIDEXCEPTION))
   #include <1273/p1273dx_ICFTemplateCells.rs>
#endif

#include <project_TemplateCells.rs>

#endif

