// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_LVSblackBox.rs.rca 1.34 Mon Jan 19 16:03:53 2015 kperrey Experimental $
//
// $Log: p1273dx_LVSblackBox.rs.rca $
// 
//  Revision: 1.34 Mon Jan 19 16:03:53 2015 kperrey
//  as per tao ; add D87SINDMTM1M9L1P1N D87SINDMTM1M9L1P6N D87SMFCNVM7D D87SESDSCREVM1_PRIM_DNW D87SESDSCRUVM1_PRIM_DNW
// 
//  Revision: 1.33 Wed Jan 14 10:53:41 2015 kperrey
//  hsd 2847 ; add d8xsesdclampdnwcaptgehv to bb and tuc template lists
// 
//  Revision: 1.32 Mon Dec  1 13:40:22 2014 kperrey
//  hsd 2902; add d86smfcevm7alp to template and LVSblackBox
// 
//  Revision: 1.31 Fri Nov 28 18:54:54 2014 kperrey
//  hsd 2880 ; add D8XMTGVARGBNS16F336ZEVM2 D8XMTGVARGBNS56F336ZEVM2
// 
//  Revision: 1.30 Mon Nov 17 11:16:03 2014 kperrey
//  hsd 2847; add d8xsesdclampdnwres
// 
//  Revision: 1.29 Tue Sep 16 10:03:57 2014 kperrey
//  fixed typo ; should have been d80mvargbns128f336zevm2 instead of d80svargbns128f336zevm2
// 
//  Revision: 1.28 Fri Sep  5 13:09:30 2014 kperrey
//  hsd 2697 / 2678 ; added hipind cell and resynch the UC/lc lists there were discrepencies
// 
//  Revision: 1.27 Tue Aug 12 09:50:20 2014 kperrey
//  fixed typo ; an extra comma
// 
//  Revision: 1.26 Mon Aug 11 13:34:14 2014 kperrey
//  added missing cells found by Jean; d8xsmfcevm3d d8xsmfcnvm3d d8xsmfcnvm5d d8xsmfctguvm3d d8xxmfcnvm3d d8xxmfcnvm5d
// 
//  Revision: 1.25 Mon Jul 21 14:25:08 2014 kperrey
//  hsd 2569; add d87sesdscrevm1_prim d87sesdscruvm1_prim
// 
//  Revision: 1.24 Fri Jul 18 09:42:23 2014 kperrey
//  hsd 2569; add d8xsesdscrevm1_prim d8xsesdscruvm1_prim
// 
//  Revision: 1.23 Thu Jul 17 15:28:09 2014 dgthakur
//  Ankita added dot0,7,8 cells based on Tao Chen's request (code reviewed by Dipto).
//
//  Revision: 1.22 Wed Jun 18 12:53:38 2014 kperrey
//  hsd 2495 ; add d8xsdcpiptgevm4v2 d8xsdcpiptgevm2v2
// 
//  Revision: 1.21 Thu Jun  5 20:58:04 2014 kperrey
//  hsd 2457 ; support for HIP specific (nonlib) black boxes
// 
//  Revision: 1.20 Wed May 21 20:01:40 2014 kperrey
//  hsd 2390 ; add d8xmtgvargbnd24f336zevm2 d8xmvargbns32f336zevm2 d8xmvargbns128f336zevm2 d8xsvargbnd64f252z2evm2 cells
// 
//  Revision: 1.19 Tue Apr 22 13:06:14 2014 kperrey
//  hsd 2282 ; add D8XSDCPINTGEVM2_S2S D8XSDCPINTGEVM4_S2S
// 
//  Revision: 1.18 Fri Apr 18 10:51:56 2014 kperrey
//  hsd 2297 ; remove the deprecated templates d8xsdcpiptgevm2 d8xsdcpiptgevm4
// 
//  Revision: 1.17 Thu Apr 17 12:30:42 2014 kperrey
//  hsd 2290 ; add d86smfcnvm7alp d86smfcevm7aulc ; change name to d86sindtm1m11l1p1n d86sindtm1m11l2p2n (added s); removed duplicate d8xsrtcnuvm2vtun_base d8xsrcprtguvm2a_base d8xsrcprtguvm2b_base d8xsrcprtguvm2c_base (own defs with swap pins)
// 
//  Revision: 1.16 Fri Mar 21 09:03:01 2014 kperrey
//  hsd 2219 ; add 3 diode related cells; forgot to add the UC versions of them
// 
//  Revision: 1.15 Fri Mar 21 08:19:05 2014 kperrey
//  hsd 2219 ; add 3 diode related cells
// 
//  Revision: 1.14 Wed Feb 12 12:10:45 2014 kperrey
//  hsd 2075 ; add d8xsrtcnuvm2p5vtun_base to p1273dx_LVSblackBox.rs and d8xsrtcnuvm2p5vtun to p1273dx_TemplateCells.rs
// 
//  Revision: 1.13 Thu Jan  9 19:32:29 2014 kperrey
//  hsd 2037 ; add d86smfcevm4aulc d86smfcnvm4aulc d86smfcevm7[abc] d86smfcnvm7[abc]
// 
//  Revision: 1.12 Fri Jan  3 12:06:34 2014 kperrey
//  hsd 2023 ; added d81sindmtm1m9l1p1n
// 
//  Revision: 1.11 Wed Dec 18 19:10:15 2013 kperrey
//  removed d8xsdcpiptgulvm4 d8xsdcpintgulvm4 as per email from suhas
// 
//  Revision: 1.10 Tue Dec 10 14:13:58 2013 kperrey
//  hsd 1998; add d8xsdcpiphvm2 d8xsdcpiphvm4 d86sdcpiphvm6 to lists
// 
//  Revision: 1.9 Wed Oct 30 12:02:44 2013 kperrey
//  hsd 1927; for D8XSRCPRTGUVM2[ABC]_BASE S1_UHV and S2_UHV are swappable pins and D8XSRTCNUVM2VTUN_BASE  has N1_UHV and N2_UHV as swappable pins
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
//  Revision: 1.5 Thu Aug 22 10:19:31 2013 kperrey
//  hsd 1861 ; add scr cells d8xsesdscrevm1 d8xsesdscruvm1
// 
//  Revision: 1.4 Tue Aug 20 07:23:29 2013 kperrey
//  hsd 1860 ; add d81shipindmtm1m9l1p1n
// 
//  Revision: 1.3 Thu Aug  8 18:30:43 2013 kperrey
//  hsd 1846 ; add support for d81sindmtm1m9l1p6n
// 
//  Revision: 1.2 Tue Jul 30 20:58:18 2013 kperrey
//  derived from the /nfs/pdx/disks/drwork.disks.12/work_areas/kperrey/work73/runset_libs/x12dev_drwork_rst/PXL/p12723_LVSblackBox ;  removed the 1272 specific cells c8* or x72* or x10*; hsd 1824 added d8xsrtcnevm2dac*
// 
//  Revision: 1.1 Tue Jul 30 09:49:13 2013 kperrey
//  used p12723_LVSblackBox as start ; then removed all the c8 (1272) specific cells
// 
//  Revision: 1.51 Fri May 24 09:28:04 2013 kperrey
//  had Layout_cell instead of layout_cell
// 
//  Revision: 1.50 Thu May 23 17:14:53 2013 kperrey
//  hsd 1702 added cells as specified
// 
//  Revision: 1.49 Thu Mar 21 08:16:37 2013 kperrey
//  hsd 1599 ; add C84MINDM11L0P8N/C84MINDM11L0P6N templates
// 
//  Revision: 1.48 Mon Mar 18 13:26:34 2013 kperrey
//  add the lc version of d8xmvargbnd64f252z2evm2
// 
//  Revision: 1.47 Mon Mar 18 11:13:22 2013 kperrey
//  change X73LCPLLVCOVARMFC4P8G -> D8XMVARGBND64F252Z2EVM2 misunderstanding to what the actual varactor template cell was
// 
//  Revision: 1.46 Sat Mar 16 16:22:06 2013 kperrey
//  add x73lcpllvcovarmfc4p8g new varactor
// 
//  Revision: 1.45 Mon Feb 18 17:32:24 2013 kperrey
//  add c8xmvargbnd64f252z2evm2 as per oz and Andrey
// 
//  Revision: 1.44 Wed Feb 13 21:32:55 2013 kperrey
//  as per kalyan add d8xltsv_ccsymb as the tsv catchcup
// 
//  Revision: 1.43 Thu Nov 29 20:30:46 2012 kperrey
//  hsd 1431 ; add inductor d86indtm1m11l1p1n d86indtm1m11l2p2n ; add decap d8xxdcpiphvm2 d8xxdcpipnvm4p5 d8xxdcpipnvm2p5
// 
//  Revision: 1.42 Thu Nov 15 09:44:17 2012 kperrey
//  hsd 1434 ; added d84sindmtm1m9l0p7n10g
// 
//  Revision: 1.41 Tue Oct 30 09:40:24 2012 kperrey
//  as per Zhanping add the follow antifuse as bb x73p00fcary1ne_1c_[0-6]
// 
//  Revision: 1.40 Wed Oct 24 13:11:40 2012 kperrey
//  add the tsv cc to the blackbox list x73btsvccsymb
// 
//  Revision: 1.39 Wed Aug 22 13:39:19 2012 kperrey
//  resynch the UPPERCASE and lowercase lists
// 
//  Revision: 1.38 Wed Aug 22 11:34:38 2012 kperrey
//  as per krishna ; added back d8xsesdclampres d8xsesdclamprestg to black box list
// 
//  Revision: 1.37 Mon Aug 20 10:20:49 2012 kperrey
//  hsd 1332; add d84shipindmtm1m9l0p6n d84shipindmtm1m9l1p1n to template/cell lists
// 
//  Revision: 1.36 Thu Aug  2 15:36:01 2012 kperrey
//  hsd 1317; remove d84sindmtm1m9l7p6n and d84sindmtm1m9l0p6n
// 
//  Revision: 1.35 Mon Jul 30 23:23:47 2012 kperrey
//  hsd 1309 ; remove D8XSESDCLAMPRES D8XSESDCLAMPRESTG from black box
// 
//  Revision: 1.34 Thu Jul 12 12:24:07 2012 kperrey
//  added some missing lc names that were in the UC list
// 
//  Revision: 1.33 Thu Jun 28 16:04:08 2012 kperrey
//  hsd 621917 ; made similar edits to d8xxrtcnevm2vtunddrdyn d8xxrtcnevm2vtunddrcmd d8xxrtcnevm2vtunddrstat d8xxrtcnevm2vtunpci
// 
//  Revision: 1.32 Thu Jun 28 15:12:13 2012 kperrey
//  additional hsd 621917 forgot to the the lc versions ; also added the missing lc d8xx cells
// 
//  Revision: 1.31 Thu Jun 28 10:57:25 2012 kperrey
//  hsd 621917 ; change bb level and tuc for tcn vtun macros as per tripti
// 
//  Revision: 1.30 Wed May 16 11:17:32 2012 kperrey
//  hsd 1200; add c8xmfbcmbd0nrevm1  c8xmfbcmbd1nrevm1 c8xmfbcutd0nrevm1 c8xmfbcutd1nrevm1
// 
//  Revision: 1.29 Wed May 16 11:02:24 2012 kperrey
//  hsd 1228 ; added cells to bb and template lists
// 
//  Revision: 1.28 Wed Apr 18 08:33:33 2012 kperrey
//  added d84sindmtm1m9l0p4n missed earlier from HSD 621650
// 
//  Revision: 1.27 Wed Apr 11 14:22:13 2012 kperrey
//  added d8xsesdclampcaptg1 and d8xsesdclampcaptg2 to TUC list and LVS black box list hsd 621650
// 
//  Revision: 1.26 Fri Mar 30 13:41:55 2012 kperrey
//  hsd 1189 ; add m9 to ind names (4) and change 7n to 6n
// 
//  Revision: 1.25 Tue Feb 14 20:29:33 2012 kperrey
//  hsd 621351; added remove cells as specified
// 
//  Revision: 1.24 Wed Jan 25 12:34:33 2012 kperrey
//  hsd 1117; updated d8xsrcprtguvm2a/d8xsrcprtguvm2b to d8xsrcprtguvm2a_base/d8xsrcprtguvm2b_base
// 
//  Revision: 1.23 Sat Jan 14 15:51:38 2012 kperrey
//  hsd 621170 ; suhas d8 lib updates; also added section for inclusion of userOpenAccessLVSblackbox for openAcess LVS directives till we figure out what we are doing
// 
//  Revision: 1.22 Tue Nov 29 09:38:04 2011 kperrey
//  updated d8 gbn and d8 dcp mfc as per ChrisW email
// 
//  Revision: 1.21 Mon Nov 28 14:52:38 2011 kperrey
//  added d8 lib cells as per ChrisW
// 
//  Revision: 1.20 Fri Nov 11 13:58:01 2011 kperrey
//  as per mail from Scot Zickel; add fib cells to bb list
// 
//  Revision: 1.19 Tue Nov  8 14:41:02 2011 kperrey
//  bb macros from tripti C8XMRTCNEVM2VTUNPCI C8XMRTCNEVM2VTUNDDRSTAT C8XMRTCNEVM2VTUNDDRCMD C8XMRTCNEVM2VTUNDDRDYN ; but they are not TUC templates
// 
//  Revision: 1.18 Mon Oct 24 09:47:28 2011 kperrey
//  hsd 1008 ; c8xmesdclampcaphv added to only blackBox
// 
//  Revision: 1.17 Thu Sep  8 14:47:39 2011 kperrey
//  Umesh add c82mindm11l0p6n
// 
//  Revision: 1.16 Wed Aug 31 17:10:05 2011 kperrey
//  add if (_drCaseSensitive == _drNO) to control if whether to be casesensitive or not - default is insensitive
// 
//  Revision: 1.15 Thu Aug 11 14:38:02 2011 kperrey
//  change C8XMRTCNEVM2DAC to C8XMRTCNEVM2DAC_BASE as per tripti ; hsd 620520
// 
//  Revision: 1.14 Tue Aug  2 10:20:17 2011 kperrey
//  hsd da_help 620520; added C8XMRTCNEVM2DACTURN C8XMRTCNEVM2DACTURNCON_BASE; as per tripti
// 
//  Revision: 1.13 Mon Jul 25 11:22:28 2011 kperrey
//  added the following cells C8XMRTCNEVM2Vc8xmrtcnevm2vtuncontop_base c8xmrtcnevm2vtunconbot_base c8xmrtcnevm2vtunturntop c8xmrtcnevm2vtunturnbot c8xmrtcnevm2vtunbodtop c8xmrtcnevm2vtunbodbot c8xmrtcnevm2vtunmid c8xmrtcnevm2vtunmidfh c8xmrtcnevm2daccontop_base c8xmrtcnevm2dacconbot_base c8xmrtcnevm2dac as per Tripti
// 
//  Revision: 1.12 Tue Jun 21 14:05:28 2011 oakin
//  updated the bb list per Scot.
// 
//  Revision: 1.11 Fri May 13 13:56:55 2011 oakin
//  added tcn resistors.
// 
//  Revision: 1.10 Fri May 13 09:52:47 2011 oakin
//  updated some template names..
// 
//  Revision: 1.9 Fri Feb 25 13:47:34 2011 kperrey
//  should all be UC ; D8XMRGCNTG3LEGSINCOnuvm2_base
// 
//  Revision: 1.8 Tue Jan 25 10:30:29 2011 kperrey
//  change c8xindm11l0p8n -> c8xlindm11l0p8n as per yonping
// 
//  Revision: 1.7 Thu Jan 13 14:03:37 2011 kperrey
//  added C8XINDM11L0P8N inductor to blackbox
// 
//  Revision: 1.6 Fri Dec 17 10:15:38 2010 kperrey
//  change C8XLRGCN4LEGDAC to C8XLRGCN4LEGDAC_BASE
// 
//  Revision: 1.5 Thu Nov 18 07:41:48 2010 kperrey
//  Updates to bb/template list as per C Wawro 11/17 mail
// 
//  Revision: 1.4 Fri Oct 15 15:05:49 2010 kperrey
//  updated b8/c8 names to latest spec from S Zickel
// 
//  Revision: 1.3 Wed Aug 11 14:09:30 2010 kperrey
//  removed the a8 references and change the b8 to c8 which is the new lib prefix
// 
//  Revision: 1.2 Thu Jul 22 14:08:00 2010 kperrey
//  handle p1272 to p12723 name reference
// 
//  Revision: 1.1 Thu Jul 22 13:11:01 2010 kperrey
//  mvfile on Thu Jul 22 13:11:01 2010 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p1272_LVSblackBox.rs;1.2
// 
//  Revision: 1.2 Thu Jun 24 23:09:00 2010 kperrey
//  add b8x 1271 bb cells
// 
//  Revision: 1.1 Tue May 25 15:04:40 2010 kperrey
//  from p1270
// 
// 
//  converted p1270_LVSblackBox.rs
//

#ifndef _P1273DX_LVSBLACKBOX_RS_
#define _P1273DX_LVSBLACKBOX_RS_

// think these always need to be UC - since that is the final compare case
lvs_black_box_options(
   equiv_cells = {     
   #if (_drCaseSensitive == _drNO) // UPPERCASE
     // tcn resistors
     {schematic_cell = "D8XXRTCNEVM2ACON_BASE", layout_cell = "D8XXRTCNEVM2ACON_BASE"},
     {schematic_cell = "D8XXRTCNEVM2ABOD_01", layout_cell = "D8XXRTCNEVM2ABOD_01"},
     {schematic_cell = "D8XXRTCNEVM2ABOD_02", layout_cell = "D8XXRTCNEVM2ABOD_02"},
     {schematic_cell = "D8XXRTCNEVM2ABOD_03", layout_cell = "D8XXRTCNEVM2ABOD_03"},

     {schematic_cell = "D87XRTCNEVM2ACON_BASE", layout_cell ="D87XRTCNEVM2ACON_BASE"},
     {schematic_cell = "D87XRTCNEVM2ABOD_01", layout_cell = "D87XRTCNEVM2ABOD_01"},
     {schematic_cell = "D87XRTCNEVM2ABOD_02", layout_cell = "D87XRTCNEVM2ABOD_02"},
     {schematic_cell = "D87XRTCNEVM2ABOD_03", layout_cell = "D87XRTCNEVM2ABOD_03"},

     {schematic_cell = "D88XRTCNEVM2ACON_BASE", layout_cell = "D88XRTCNEVM2ACON_BASE"},
     {schematic_cell = "D88XRTCNEVM2ABOD_01", layout_cell = "D88XRTCNEVM2ABOD_01"},
     {schematic_cell = "D88XRTCNEVM2ABOD_02", layout_cell = "D88XRTCNEVM2ABOD_02"},
     {schematic_cell = "D88XRTCNEVM2ABOD_03", layout_cell = "D88XRTCNEVM2ABOD_03"},	 

     {schematic_cell = "D80XRTCNEVM2ACON_BASE", layout_cell = "D80XRTCNEVM2ACON_BASE"},
     {schematic_cell = "D80XRTCNEVM2ABOD_01", layout_cell = "D80XRTCNEVM2ABOD_01"},
     {schematic_cell = "D80XRTCNEVM2ABOD_02", layout_cell = "D80XRTCNEVM2ABOD_02"},
     {schematic_cell = "D80XRTCNEVM2ABOD_03", layout_cell = "D80XRTCNEVM2ABOD_03"},

	 
     // *** tcn vertical tune resistor
     {schematic_cell = "D8XXRTCNEVM2VTUNCONTOP_BASE", layout_cell = "D8XXRTCNEVM2VTUNCONTOP_BASE"},
     {schematic_cell = "D8XXRTCNEVM2VTUNCONBOT_BASE", layout_cell = "D8XXRTCNEVM2VTUNCONBOT_BASE"},
     {schematic_cell = "D8XXRTCNEVM2VTUNTURNTOP", layout_cell = "D8XXRTCNEVM2VTUNTURNTOP"},
     {schematic_cell = "D8XXRTCNEVM2VTUNTURNBOT", layout_cell = "D8XXRTCNEVM2VTUNTURNBOT"},
     {schematic_cell = "D8XXRTCNEVM2VTUNBODTOP", layout_cell = "D8XXRTCNEVM2VTUNBODTOP"},
     {schematic_cell = "D8XXRTCNEVM2VTUNBODBOT", layout_cell = "D8XXRTCNEVM2VTUNBODBOT"},
     {schematic_cell = "D8XXRTCNEVM2VTUNMID", layout_cell = "D8XXRTCNEVM2VTUNMID"},
     {schematic_cell = "D8XXRTCNEVM2VTUNMIDFH", layout_cell = "D8XXRTCNEVM2VTUNMIDFH"},

     {schematic_cell = "D87XRTCNEVM2VTUNCONTOP_BASE", layout_cell = "D87XRTCNEVM2VTUNCONTOP_BASE"},
     {schematic_cell = "D87XRTCNEVM2VTUNCONBOT_BASE", layout_cell = "D87XRTCNEVM2VTUNCONBOT_BASE"},
     {schematic_cell = "D87XRTCNEVM2VTUNTURNTOP", layout_cell = "D87XRTCNEVM2VTUNTURNTOP"},
     {schematic_cell = "D87XRTCNEVM2VTUNTURNBOT", layout_cell = "D87XRTCNEVM2VTUNTURNBOT"},
     {schematic_cell = "D87XRTCNEVM2VTUNBODTOP", layout_cell = "D87XRTCNEVM2VTUNBODTOP"},
     {schematic_cell = "D87XRTCNEVM2VTUNBODBOT", layout_cell = "D87XRTCNEVM2VTUNBODBOT"},
     {schematic_cell = "D87XRTCNEVM2VTUNMID", layout_cell = "D87XRTCNEVM2VTUNMID"},
     {schematic_cell = "D87XRTCNEVM2VTUNMIDFH", layout_cell = "D87XRTCNEVM2VTUNMIDFH"},

     {schematic_cell = "D88XRTCNEVM2VTUNCONTOP_BASE", layout_cell = "D88XRTCNEVM2VTUNCONTOP_BASE"},
     {schematic_cell = "D88XRTCNEVM2VTUNCONBOT_BASE", layout_cell = "D88XRTCNEVM2VTUNCONBOT_BASE"},
     {schematic_cell = "D88XRTCNEVM2VTUNTURNTOP", layout_cell = "D88XRTCNEVM2VTUNTURNTOP"},
     {schematic_cell = "D88XRTCNEVM2VTUNTURNBOT", layout_cell = "D88XRTCNEVM2VTUNTURNBOT"},
     {schematic_cell = "D88XRTCNEVM2VTUNBODTOP", layout_cell = "D88XRTCNEVM2VTUNBODTOP"},
     {schematic_cell = "D88XRTCNEVM2VTUNBODBOT", layout_cell = "D88XRTCNEVM2VTUNBODBOT"},
     {schematic_cell = "D88XRTCNEVM2VTUNMID", layout_cell = "D88XRTCNEVM2VTUNMID"},
     {schematic_cell = "D88XRTCNEVM2VTUNMIDFH", layout_cell = "D88XRTCNEVM2VTUNMIDFH"},

     {schematic_cell = "D80XRTCNEVM2VTUNCONTOP_BASE", layout_cell = "D80XRTCNEVM2VTUNCONTOP_BASE"},
     {schematic_cell = "D80XRTCNEVM2VTUNCONBOT_BASE", layout_cell = "D80XRTCNEVM2VTUNCONBOT_BASE"},
     {schematic_cell = "D80XRTCNEVM2VTUNTURNTOP", layout_cell = "D80XRTCNEVM2VTUNTURNTOP"},
     {schematic_cell = "D80XRTCNEVM2VTUNTURNBOT", layout_cell = "D80XRTCNEVM2VTUNTURNBOT"},
     {schematic_cell = "D80XRTCNEVM2VTUNBODTOP", layout_cell = "D80XRTCNEVM2VTUNBODTOP"},
     {schematic_cell = "D80XRTCNEVM2VTUNBODBOT", layout_cell = "D80XRTCNEVM2VTUNBODBOT"},
     {schematic_cell = "D80XRTCNEVM2VTUNMID", layout_cell = "D80XRTCNEVM2VTUNMID"},
     {schematic_cell = "D80XRTCNEVM2VTUNMIDFH", layout_cell = "D80XRTCNEVM2VTUNMIDFH"},	 
	 
     // hsd 1702
     {schematic_cell = "D86SMFCNVM6A", layout_cell = "D86SMFCNVM6A"},
     {schematic_cell = "D86SMFCNVM6ALP", layout_cell = "D86SMFCNVM6ALP"},
     {schematic_cell = "D86SMFCNVM6B", layout_cell = "D86SMFCNVM6B"},
     {schematic_cell = "D86SMFCNVM6C", layout_cell = "D86SMFCNVM6C"},
     {schematic_cell = "D86SMFCEVM6A", layout_cell = "D86SMFCEVM6A"},
     {schematic_cell = "D86SMFCEVM6B", layout_cell = "D86SMFCEVM6B"},
     {schematic_cell = "D86SMFCEVM6C", layout_cell = "D86SMFCEVM6C"},
     {schematic_cell = "D86SMFCNVM7APLL", layout_cell = "D86SMFCNVM7APLL"},
     {schematic_cell = "D86XMFCNVM6A", layout_cell = "D86XMFCNVM6A"},
     {schematic_cell = "D86XMFCNVM6B", layout_cell = "D86XMFCNVM6B"},
     {schematic_cell = "D86XMFCNVM6C", layout_cell = "D86XMFCNVM6C"},
      	 
	 // hsd 2037
     {schematic_cell = "D86SMFCEVM4AULC", layout_cell = "D86SMFCEVM4AULC"},
     {schematic_cell = "D86SMFCEVM7A", layout_cell = "D86SMFCEVM7A"},
     {schematic_cell = "D86SMFCEVM7B", layout_cell = "D86SMFCEVM7B"},
     {schematic_cell = "D86SMFCEVM7C", layout_cell = "D86SMFCEVM7C"},
     {schematic_cell = "D86SMFCNVM4AULC", layout_cell = "D86SMFCNVM4AULC"},
     {schematic_cell = "D86SMFCNVM7A", layout_cell = "D86SMFCNVM7A"},
     {schematic_cell = "D86SMFCNVM7B", layout_cell = "D86SMFCNVM7B"},
     {schematic_cell = "D86SMFCNVM7C", layout_cell = "D86SMFCNVM7C"},
	 // hsd 2290
     {schematic_cell = "D86SMFCNVM7ALP", layout_cell = "D86SMFCNVM7ALP"},
     {schematic_cell = "D86SMFCEVM7AULC", layout_cell = "D86SMFCEVM7AULC"},
     // hsd 2902
     {schematic_cell = "D86SMFCEVM7ALP", layout_cell = "D86SMFCEVM7ALP"},

     
     // *** tcn dac resistor
     {schematic_cell = "D8XXRTCNEVM2DACCONTOP_BASE", layout_cell = "D8XXRTCNEVM2DACCONTOP_BASE"},
     {schematic_cell = "D8XXRTCNEVM2DACCONBOT_BASE", layout_cell = "D8XXRTCNEVM2DACCONBOT_BASE"},
     {schematic_cell = "D8XXRTCNEVM2DAC_BASE", layout_cell = "D8XXRTCNEVM2DAC_BASE"},

     {schematic_cell = "D87XRTCNEVM2DACCONTOP_BASE", layout_cell = "D87XRTCNEVM2DACCONTOP_BASE"},
     {schematic_cell = "D87XRTCNEVM2DACCONBOT_BASE", layout_cell = "D87XRTCNEVM2DACCONBOT_BASE"},
     {schematic_cell = "D87XRTCNEVM2DAC_BASE", layout_cell = "D87XRTCNEVM2DAC_BASE"},

     {schematic_cell = "D88XRTCNEVM2DACCONTOP_BASE", layout_cell = "D88XRTCNEVM2DACCONTOP_BASE"},
     {schematic_cell = "D88XRTCNEVM2DACCONBOT_BASE", layout_cell = "D88XRTCNEVM2DACCONBOT_BASE"},
     {schematic_cell = "D88XRTCNEVM2DAC_BASE", layout_cell = "D88XRTCNEVM2DAC_BASE"},

     {schematic_cell = "D80XRTCNEVM2DACCONTOP_BASE", layout_cell = "D80XRTCNEVM2DACCONTOP_BASE"},
     {schematic_cell = "D80XRTCNEVM2DACCONBOT_BASE", layout_cell = "D80XRTCNEVM2DACCONBOT_BASE"},
     {schematic_cell = "D80XRTCNEVM2DAC_BASE", layout_cell = "D80XRTCNEVM2DAC_BASE"},	 

      // as per tripti hsd da_help 620520
     {schematic_cell = "D8XXRTCNEVM2DACTURN", layout_cell = "D8XXRTCNEVM2DACTURN"},
     {schematic_cell = "D8XXRTCNEVM2DACTURNCON_BASE", layout_cell = "D8XXRTCNEVM2DACTURNCON_BASE"},

     {schematic_cell = "D87XRTCNEVM2DACTURN", layout_cell = "D87XRTCNEVM2DACTURN"},
     {schematic_cell = "D87XRTCNEVM2DACTURNCON_BASE", layout_cell = "D87XRTCNEVM2DACTURNCON_BASE"},

     {schematic_cell = "D88XRTCNEVM2DACTURN", layout_cell = "D88XRTCNEVM2DACTURN"},
     {schematic_cell = "D88XRTCNEVM2DACTURNCON_BASE", layout_cell = "D88XRTCNEVM2DACTURNCON_BASE"},

     {schematic_cell = "D80XRTCNEVM2DACTURN", layout_cell = "D80XRTCNEVM2DACTURN"},
     {schematic_cell = "D80XRTCNEVM2DACTURNCON_BASE", layout_cell = "D80XRTCNEVM2DACTURNCON_BASE"},


	 
     // hsd 1824
     {schematic_cell = "D8XSRTCNEVM2DAC_BASE", layout_cell = "D8XSRTCNEVM2DAC_BASE"}, 
     {schematic_cell = "D8XSRTCNEVM2DACCONTOP_BASE", layout_cell = "D8XSRTCNEVM2DACCONTOP_BASE"}, 
     {schematic_cell = "D8XSRTCNEVM2DACCONBOT_BASE", layout_cell = "D8XSRTCNEVM2DACCONBOT_BASE"}, 
     {schematic_cell = "D8XSRTCNEVM2DACTURNCON_BASE", layout_cell = "D8XSRTCNEVM2DACTURNCON_BASE"}, 
     {schematic_cell = "D8XSRTCNEVM2DACTURN", layout_cell = "D8XSRTCNEVM2DACTURN"},

     {schematic_cell = "D87SRTCNEVM2DAC_BASE", layout_cell = "D87SRTCNEVM2DAC_BASE"}, 
     {schematic_cell = "D87SRTCNEVM2DACCONTOP_BASE", layout_cell = "D87SRTCNEVM2DACCONTOP_BASE"}, 
     {schematic_cell = "D87SRTCNEVM2DACCONBOT_BASE", layout_cell = "D87SRTCNEVM2DACCONBOT_BASE"}, 
     {schematic_cell = "D87SRTCNEVM2DACTURNCON_BASE", layout_cell = "D87SRTCNEVM2DACTURNCON_BASE"}, 
     {schematic_cell = "D87SRTCNEVM2DACTURN", layout_cell = "D87SRTCNEVM2DACTURN"},

     {schematic_cell = "D88SRTCNEVM2DAC_BASE", layout_cell = "D88SRTCNEVM2DAC_BASE"}, 
     {schematic_cell = "D88SRTCNEVM2DACCONTOP_BASE", layout_cell = "D88SRTCNEVM2DACCONTOP_BASE"}, 
     {schematic_cell = "D88SRTCNEVM2DACCONBOT_BASE", layout_cell = "D88SRTCNEVM2DACCONBOT_BASE"}, 
     {schematic_cell = "D88SRTCNEVM2DACTURNCON_BASE", layout_cell = "D88SRTCNEVM2DACTURNCON_BASE"}, 
     {schematic_cell = "D88SRTCNEVM2DACTURN", layout_cell = "D88SRTCNEVM2DACTURN"},

     {schematic_cell = "D80SRTCNEVM2DAC_BASE", layout_cell = "D80SRTCNEVM2DAC_BASE"}, 
     {schematic_cell = "D80SRTCNEVM2DACCONTOP_BASE", layout_cell = "D80SRTCNEVM2DACCONTOP_BASE"}, 
     {schematic_cell = "D80SRTCNEVM2DACCONBOT_BASE", layout_cell = "D80SRTCNEVM2DACCONBOT_BASE"}, 
     {schematic_cell = "D80SRTCNEVM2DACTURNCON_BASE", layout_cell = "D80SRTCNEVM2DACTURNCON_BASE"}, 
     {schematic_cell = "D80SRTCNEVM2DACTURN", layout_cell = "D80SRTCNEVM2DACTURN"},	 
	 
     // hsd 2075
     {schematic_cell = "D8XSRTCNUVM2P5VTUN_BASE", layout_cell = "D8XSRTCNUVM2P5VTUN_BASE"},
     {schematic_cell = "D87SRTCNUVM2P5VTUN_BASE", layout_cell = "D87SRTCNUVM2P5VTUN_BASE"},
     {schematic_cell = "D88SRTCNUVM2P5VTUN_BASE", layout_cell = "D88SRTCNUVM2P5VTUN_BASE"},
     {schematic_cell = "D80SRTCNUVM2P5VTUN_BASE", layout_cell = "D80SRTCNUVM2P5VTUN_BASE"},
     // d8lib
 
     // inductor
     // d8lib
     {schematic_cell = "D84SINDMTM1M9L1P1N", layout_cell = "D84SINDMTM1M9L1P1N"},
     {schematic_cell = "D84SINDMTM1M9L2P2N", layout_cell = "D84SINDMTM1M9L2P2N"},

     {schematic_cell = "D84SINDMTM1M9L0P4N", layout_cell = "D84SINDMTM1M9L0P4N"},
     // hsd 1332
     {schematic_cell = "D84SHIPINDMTM1M9L0P6N", layout_cell = "D84SHIPINDMTM1M9L0P6N"},
     {schematic_cell = "D84SHIPINDMTM1M9L1P1N", layout_cell = "D84SHIPINDMTM1M9L1P1N"},
	 // hsd 1434
     {schematic_cell = "D84SINDMTM1M9L0P7N10G", layout_cell = "D84SINDMTM1M9L0P7N10G"},
	 // hsd 1431 
     {schematic_cell = "D86SINDTM1M11L1P1N", layout_cell = "D86SINDTM1M11L1P1N"},
     {schematic_cell = "D86SINDTM1M11L2P2N", layout_cell = "D86SINDTM1M11L2P2N"},
     // hsd 1702
     {schematic_cell = "D86SINDM12L0P15N", layout_cell = "D86SINDM12L0P15N"},
     {schematic_cell = "D86SINDM12L0P2N", layout_cell = "D86SINDM12L0P2N"},
     {schematic_cell = "D86SINDM12CTL0P2N", layout_cell = "D86SINDM12CTL0P2N"},
     {schematic_cell = "D86SINDM12L0P265N", layout_cell = "D86SINDM12L0P265N"},
     // hsd 1846
     {schematic_cell = "D81SINDMTM1M9L1P6N", layout_cell = "D81SINDMTM1M9L1P6N"},
     // hsd 1860
     {schematic_cell = "D81SHIPINDMTM1M9L1P1N", layout_cell = "D81SHIPINDMTM1M9L1P1N"},
     // hsd 1880
     {schematic_cell = "D86SINDSPIRALM12L0P8N", layout_cell = "D86SINDSPIRALM12L0P8N"},
     {schematic_cell = "D86SINDTM1M12L0P72N", layout_cell = "D86SINDTM1M12L0P72N"},
     // hsd 1896//////////////////////////////////////////////////////////////////////////////////////
	 {schematic_cell = "D81SHIPINDMTM1L0P5N",  layout_cell = "D81SHIPINDMTM1L0P5N"},
	 {schematic_cell = "D81SHIPINDMTM1M9L0P9N", layout_cell = "D81SHIPINDMTM1M9L0P9N"},

     // hsd 2697
	 {schematic_cell = "D81SHIPINDMTM1M9L1P6N", layout_cell = "D81SHIPINDMTM1M9L1P6N"},

   // as per tao
	 {schematic_cell = "D87SINDMTM1M9L1P1N", layout_cell = "D87SINDMTM1M9L1P1N"},
	 {schematic_cell = "D87SINDMTM1M9L1P6N", layout_cell = "D87SINDMTM1M9L1P6N"},

     // varactor

     // d8lib
     {schematic_cell = "D8XMVARGBND60F252ZEVM2", layout_cell = "D8XMVARGBND60F252ZEVM2"},
     {schematic_cell = "D8XMVARGBND64F252Z2EVM2", layout_cell = "D8XMVARGBND64F252Z2EVM2"}, // x73

     {schematic_cell = "D87MVARGBND60F252ZEVM2", layout_cell = "D87MVARGBND60F252ZEVM2"},
     {schematic_cell = "D87MVARGBND64F252Z2EVM2", layout_cell = "D87MVARGBND64F252Z2EVM2"}, // x73

     {schematic_cell = "D88MVARGBND60F252ZEVM2", layout_cell = "D88MVARGBND60F252ZEVM2"},
     {schematic_cell = "D88MVARGBND64F252Z2EVM2", layout_cell = "D88MVARGBND64F252Z2EVM2"}, // x73

     {schematic_cell = "D80MVARGBND60F252ZEVM2", layout_cell = "D80MVARGBND60F252ZEVM2"},
     {schematic_cell = "D80MVARGBND64F252Z2EVM2", layout_cell = "D80MVARGBND64F252Z2EVM2"}, // x73

     // hsd 2390
     {schematic_cell = "D8XMTGVARGBND24F336ZEVM2", layout_cell = "D8XMTGVARGBND24F336ZEVM2"},
     {schematic_cell = "D8XMVARGBNS32F336ZEVM2", layout_cell = "D8XMVARGBNS32F336ZEVM2"},
     {schematic_cell = "D8XMVARGBNS128F336ZEVM2", layout_cell = "D8XMVARGBNS128F336ZEVM2"},
     {schematic_cell = "D8XSVARGBND64F252Z2EVM2", layout_cell = "D8XSVARGBND64F252Z2EVM2"},


     {schematic_cell = "D87MTGVARGBND24F336ZEVM2", layout_cell = "D87MTGVARGBND24F336ZEVM2"},
     {schematic_cell = "D87MVARGBNS32F336ZEVM2", layout_cell = "D87MVARGBNS32F336ZEVM2"},
     {schematic_cell = "D87MVARGBNS128F336ZEVM2", layout_cell = "D87MVARGBNS128F336ZEVM2"},
     {schematic_cell = "D87SVARGBND64F252Z2EVM2", layout_cell = "D87SVARGBND64F252Z2EVM2"},

     {schematic_cell = "D88MTGVARGBND24F336ZEVM2", layout_cell = "D88MTGVARGBND24F336ZEVM2"},
     {schematic_cell = "D88MVARGBNS32F336ZEVM2", layout_cell = "D88MVARGBNS32F336ZEVM2"},
     {schematic_cell = "D88MVARGBNS128F336ZEVM2", layout_cell = "D88MVARGBNS128F336ZEVM2"},
     {schematic_cell = "D88SVARGBND64F252Z2EVM2", layout_cell = "D88SVARGBND64F252Z2EVM2"},

     {schematic_cell = "D80MTGVARGBND24F336ZEVM2", layout_cell = "D80MTGVARGBND24F336ZEVM2"},
     {schematic_cell = "D80MVARGBNS32F336ZEVM2", layout_cell = "D80MVARGBNS32F336ZEVM2"},
     {schematic_cell = "D80MVARGBNS128F336ZEVM2", layout_cell = "D80MVARGBNS128F336ZEVM2"},
     {schematic_cell = "D80SVARGBND64F252Z2EVM2", layout_cell = "D80SVARGBND64F252Z2EVM2"},	 	 

     {schematic_cell = "D8XMTGVARGBNS16F336ZEVM2", layout_cell = "D8XMTGVARGBNS16F336ZEVM2"}, // hsd 2880
     {schematic_cell = "D8XMTGVARGBNS56F336ZEVM2", layout_cell = "D8XMTGVARGBNS56F336ZEVM2"}, // hsd 2880

     // gbn       
     // gbn placeholders until full GBNWELL extraction is supported       
     {schematic_cell = "D8XSESDCLAMPCAPTG1", layout_cell = "D8XSESDCLAMPCAPTG1"},
     {schematic_cell = "D8XSESDCLAMPCAPTG2", layout_cell = "D8XSESDCLAMPCAPTG2"},

     {schematic_cell = "D8XSESDCLAMPRES", layout_cell = "D8XSESDCLAMPRES"},
     {schematic_cell = "D8XSESDCLAMPRESTG", layout_cell = "D8XSESDCLAMPRESTG"},

     {schematic_cell = "D87SESDCLAMPCAPTG1", layout_cell = "D87SESDCLAMPCAPTG1"},
     {schematic_cell = "D87SESDCLAMPCAPTG2", layout_cell = "D87SESDCLAMPCAPTG2"},

     {schematic_cell = "D87SESDCLAMPRES", layout_cell = "D87SESDCLAMPRES"},
     {schematic_cell = "D87SESDCLAMPRESTG", layout_cell = "D87SESDCLAMPRESTG"},

     {schematic_cell = "D88SESDCLAMPCAPTG1", layout_cell = "D88SESDCLAMPCAPTG1"},
     {schematic_cell = "D88SESDCLAMPCAPTG2", layout_cell = "D88SESDCLAMPCAPTG2"},

     {schematic_cell = "D88SESDCLAMPRES", layout_cell = "D88SESDCLAMPRES"},
     {schematic_cell = "D88SESDCLAMPRESTG", layout_cell = "D88SESDCLAMPRESTG"},


     {schematic_cell = "D80SESDCLAMPCAPTG1", layout_cell = "D80SESDCLAMPCAPTG1"},
     {schematic_cell = "D80SESDCLAMPCAPTG2", layout_cell = "D80SESDCLAMPCAPTG2"},

     {schematic_cell = "D80SESDCLAMPRES", layout_cell = "D80SESDCLAMPRES"},
     {schematic_cell = "D80SESDCLAMPRESTG", layout_cell = "D80SESDCLAMPRESTG"},
	 
     {schematic_cell = "D8XSESDCLAMPDNWRES", layout_cell = "D8XSESDCLAMPDNWRES"},  // hsd 2847
     {schematic_cell = "D8XSESDCLAMPDNWCAPTGEHV", layout_cell = "D8XSESDCLAMPDNWCAPTGEHV"}, // hsd 2847

     // metal finger caps
     // d8lib
     {schematic_cell = "D8XSMFCEVM4A", layout_cell = "D8XSMFCEVM4A"},
     {schematic_cell = "D8XSMFCEVM4B", layout_cell = "D8XSMFCEVM4B"},
     {schematic_cell = "D8XSMFCEVM4C", layout_cell = "D8XSMFCEVM4C"},
     {schematic_cell = "D8XSMFCNVM4A", layout_cell = "D8XSMFCNVM4A"},
     {schematic_cell = "D8XSMFCNVM4B", layout_cell = "D8XSMFCNVM4B"},
     {schematic_cell = "D8XSMFCNVM4C", layout_cell = "D8XSMFCNVM4C"},
     {schematic_cell = "D8XSMFCNVM6A", layout_cell = "D8XSMFCNVM6A"},
     {schematic_cell = "D8XSMFCNVM6B", layout_cell = "D8XSMFCNVM6B"},
     {schematic_cell = "D8XSMFCNVM6C", layout_cell = "D8XSMFCNVM6C"},
     {schematic_cell = "D8XSMFCNVM6ALP", layout_cell = "D8XSMFCNVM6ALP"},
     {schematic_cell = "D8XSMFCTGUVM4A", layout_cell = "D8XSMFCTGUVM4A"},
     {schematic_cell = "D8XSMFCTGUVM4B", layout_cell = "D8XSMFCTGUVM4B"},
     {schematic_cell = "D8XSMFCTGUVM4C", layout_cell = "D8XSMFCTGUVM4C"},
     {schematic_cell = "D8XSMFCNVM7APLL", layout_cell = "D8XSMFCNVM7APLL"},
     {schematic_cell = "D8XSESDCLAMPCAP", layout_cell = "D8XSESDCLAMPCAP"},
     {schematic_cell = "D8XSESDCLAMPCAPTGEHV", layout_cell = "D8XSESDCLAMPCAPTGEHV"},
     {schematic_cell = "D8XSMFCTGUVM4ACFIO", layout_cell = "D8XSMFCTGUVM4ACFIO"},
     {schematic_cell = "D8XSMFCNVM4AP25PLL", layout_cell = "D8XSMFCNVM4AP25PLL"},
     {schematic_cell = "D8XSESDCLAMPCAPTGUHV", layout_cell = "D8XSESDCLAMPCAPTGUHV"},
     {schematic_cell = "D8XXMFCNVM4A", layout_cell = "D8XXMFCNVM4A"},
     {schematic_cell = "D8XXMFCNVM4B", layout_cell = "D8XXMFCNVM4B"},
     {schematic_cell = "D8XXMFCNVM4C", layout_cell = "D8XXMFCNVM4C"},
     {schematic_cell = "D8XXMFCNVM6A", layout_cell = "D8XXMFCNVM6A"},
     {schematic_cell = "D8XXMFCNVM6B", layout_cell = "D8XXMFCNVM6B"},
     {schematic_cell = "D8XXMFCNVM6C", layout_cell = "D8XXMFCNVM6C"},
     {schematic_cell = "D8XSMFCEVM3D", layout_cell = "D8XSMFCEVM3D"},
     {schematic_cell = "D8XSMFCNVM3D", layout_cell = "D8XSMFCNVM3D"},	 
     {schematic_cell = "D8XSMFCNVM5D", layout_cell = "D8XSMFCNVM5D"},
     {schematic_cell = "D8XSMFCTGUVM3D",layout_cell = "D8XSMFCTGUVM3D"},
     {schematic_cell = "D8XXMFCNVM3D", layout_cell = "D8XXMFCNVM3D"},	 
     {schematic_cell = "D8XXMFCNVM5D", layout_cell = "D8XXMFCNVM5D"},	 	 
	 

     {schematic_cell = "D87SMFCEVM4A", layout_cell = "D87SMFCEVM4A"},
     {schematic_cell = "D87SMFCEVM4B", layout_cell = "D87SMFCEVM4B"},
     {schematic_cell = "D87SMFCEVM4C", layout_cell = "D87SMFCEVM4C"},
     {schematic_cell = "D87SMFCNVM4A", layout_cell = "D87SMFCNVM4A"},
     {schematic_cell = "D87SMFCNVM4B", layout_cell = "D87SMFCNVM4B"},
     {schematic_cell = "D87SMFCNVM4C", layout_cell = "D87SMFCNVM4C"},
     {schematic_cell = "D87SMFCNVM6A", layout_cell = "D87SMFCNVM6A"},
     {schematic_cell = "D87SMFCNVM6B", layout_cell = "D87SMFCNVM6B"},
     {schematic_cell = "D87SMFCNVM6C", layout_cell = "D87SMFCNVM6C"},
     {schematic_cell = "D87SMFCNVM6ALP", layout_cell = "D87SMFCNVM6ALP"},
     {schematic_cell = "D87SMFCTGUVM4A", layout_cell = "D87SMFCTGUVM4A"},
     {schematic_cell = "D87SMFCTGUVM4B", layout_cell = "D87SMFCTGUVM4B"},
     {schematic_cell = "D87SMFCTGUVM4C", layout_cell = "D87SMFCTGUVM4C"},
     {schematic_cell = "D87SMFCNVM7APLL", layout_cell = "D87SMFCNVM7APLL"},
     {schematic_cell = "D87SESDCLAMPCAP", layout_cell = "D87SESDCLAMPCAP"},
     {schematic_cell = "D87SESDCLAMPCAPTGEHV", layout_cell = "D87SESDCLAMPCAPTGEHV"},
     {schematic_cell = "D87SMFCTGUVM4ACFIO", layout_cell = "D87SMFCTGUVM4ACFIO"},
     {schematic_cell = "D87SMFCNVM4AP25PLL", layout_cell = "D87SMFCNVM4AP25PLL"},
     {schematic_cell = "D87SESDCLAMPCAPTGUHV", layout_cell = "D87SESDCLAMPCAPTGUHV"},
     {schematic_cell = "D87XMFCNVM4A", layout_cell = "D87XMFCNVM4A"},
     {schematic_cell = "D87XMFCNVM4B", layout_cell = "D87XMFCNVM4B"},
     {schematic_cell = "D87XMFCNVM4C", layout_cell = "D87XMFCNVM4C"},
     {schematic_cell = "D87XMFCNVM6A", layout_cell = "D87XMFCNVM6A"},
     {schematic_cell = "D87XMFCNVM6B", layout_cell = "D87XMFCNVM6B"},
     {schematic_cell = "D87XMFCNVM6C", layout_cell = "D87XMFCNVM6C"},
     {schematic_cell = "D87SMFCEVM3D", layout_cell = "D87SMFCEVM3D"},
     {schematic_cell = "D87SMFCNVM3D", layout_cell = "D87SMFCNVM3D"},	 
     {schematic_cell = "D87SMFCNVM5D", layout_cell = "D87SMFCNVM5D"},
     {schematic_cell = "D87SMFCTGUVM3D",layout_cell = "D87SMFCTGUVM3D"},
     {schematic_cell = "D87XMFCNVM3D", layout_cell = "D87XMFCNVM3D"},	 
     {schematic_cell = "D87XMFCNVM5D", layout_cell = "D87XMFCNVM5D"},	 	 
     {schematic_cell = "D87SMFCNVM7D", layout_cell = "D87SMFCNVM7D"},	 	  // from tao


     {schematic_cell = "D88SMFCEVM4A", layout_cell = "D88SMFCEVM4A"},
     {schematic_cell = "D88SMFCEVM4B", layout_cell = "D88SMFCEVM4B"},
     {schematic_cell = "D88SMFCEVM4C", layout_cell = "D88SMFCEVM4C"},
     {schematic_cell = "D88SMFCNVM4A", layout_cell = "D88SMFCNVM4A"},
     {schematic_cell = "D88SMFCNVM4B", layout_cell = "D88SMFCNVM4B"},
     {schematic_cell = "D88SMFCNVM4C", layout_cell = "D88SMFCNVM4C"},
     {schematic_cell = "D88SMFCNVM6A", layout_cell = "D88SMFCNVM6A"},
     {schematic_cell = "D88SMFCNVM6B", layout_cell = "D88SMFCNVM6B"},
     {schematic_cell = "D88SMFCNVM6C", layout_cell = "D88SMFCNVM6C"},
     {schematic_cell = "D88SMFCNVM6ALP", layout_cell = "D88SMFCNVM6ALP"},
     {schematic_cell = "D88SMFCTGUVM4A", layout_cell = "D88SMFCTGUVM4A"},
     {schematic_cell = "D88SMFCTGUVM4B", layout_cell = "D88SMFCTGUVM4B"},
     {schematic_cell = "D88SMFCTGUVM4C", layout_cell = "D88SMFCTGUVM4C"},
     {schematic_cell = "D88SMFCNVM7APLL", layout_cell = "D88SMFCNVM7APLL"},
     {schematic_cell = "D88SESDCLAMPCAP", layout_cell = "D88SESDCLAMPCAP"},
     {schematic_cell = "D88SESDCLAMPCAPTGEHV", layout_cell = "D88SESDCLAMPCAPTGEHV"},
     {schematic_cell = "D88SMFCTGUVM4ACFIO", layout_cell = "D88SMFCTGUVM4ACFIO"},
     {schematic_cell = "D88SMFCNVM4AP25PLL", layout_cell = "D88SMFCNVM4AP25PLL"},
     {schematic_cell = "D88SESDCLAMPCAPTGUHV", layout_cell = "D88SESDCLAMPCAPTGUHV"},
     {schematic_cell = "D88XMFCNVM4A", layout_cell = "D88XMFCNVM4A"},
     {schematic_cell = "D88XMFCNVM4B", layout_cell = "D88XMFCNVM4B"},
     {schematic_cell = "D88XMFCNVM4C", layout_cell = "D88XMFCNVM4C"},
     {schematic_cell = "D88XMFCNVM6A", layout_cell = "D88XMFCNVM6A"},
     {schematic_cell = "D88XMFCNVM6B", layout_cell = "D88XMFCNVM6B"},
     {schematic_cell = "D88XMFCNVM6C", layout_cell = "D88XMFCNVM6C"},
     {schematic_cell = "D88SMFCEVM3D", layout_cell = "D88SMFCEVM3D"},
     {schematic_cell = "D88SMFCNVM3D", layout_cell = "D88SMFCNVM3D"},	 
     {schematic_cell = "D88SMFCNVM5D", layout_cell = "D88SMFCNVM5D"},
     {schematic_cell = "D88SMFCTGUVM3D",layout_cell = "D88SMFCTGUVM3D"},
     {schematic_cell = "D88XMFCNVM3D", layout_cell = "D88XMFCNVM3D"},	 
     {schematic_cell = "D88XMFCNVM5D", layout_cell = "D88XMFCNVM5D"},

     {schematic_cell = "D80SMFCEVM4A", layout_cell = "D80SMFCEVM4A"},
     {schematic_cell = "D80SMFCEVM4B", layout_cell = "D80SMFCEVM4B"},
     {schematic_cell = "D80SMFCEVM4C", layout_cell = "D80SMFCEVM4C"},
     {schematic_cell = "D80SMFCNVM4A", layout_cell = "D80SMFCNVM4A"},
     {schematic_cell = "D80SMFCNVM4B", layout_cell = "D80SMFCNVM4B"},
     {schematic_cell = "D80SMFCNVM4C", layout_cell = "D80SMFCNVM4C"},
     {schematic_cell = "D80SMFCNVM6A", layout_cell = "D80SMFCNVM6A"},
     {schematic_cell = "D80SMFCNVM6B", layout_cell = "D80SMFCNVM6B"},
     {schematic_cell = "D80SMFCNVM6C", layout_cell = "D80SMFCNVM6C"},
     {schematic_cell = "D80SMFCNVM6ALP", layout_cell = "D80SMFCNVM6ALP"},
     {schematic_cell = "D80SMFCTGUVM4A", layout_cell = "D80SMFCTGUVM4A"},
     {schematic_cell = "D80SMFCTGUVM4B", layout_cell = "D80SMFCTGUVM4B"},
     {schematic_cell = "D80SMFCTGUVM4C", layout_cell = "D80SMFCTGUVM4C"},
     {schematic_cell = "D80SMFCNVM7APLL", layout_cell = "D80SMFCNVM7APLL"},
     {schematic_cell = "D80SESDCLAMPCAP", layout_cell = "D80SESDCLAMPCAP"},
     {schematic_cell = "D80SESDCLAMPCAPTGEHV", layout_cell = "D80SESDCLAMPCAPTGEHV"},
     {schematic_cell = "D80SMFCTGUVM4ACFIO", layout_cell = "D80SMFCTGUVM4ACFIO"},
     {schematic_cell = "D80SMFCNVM4AP25PLL", layout_cell = "D80SMFCNVM4AP25PLL"},
     {schematic_cell = "D80SESDCLAMPCAPTGUHV", layout_cell = "D80SESDCLAMPCAPTGUHV"},
     {schematic_cell = "D80XMFCNVM4A", layout_cell = "D80XMFCNVM4A"},
     {schematic_cell = "D80XMFCNVM4B", layout_cell = "D80XMFCNVM4B"},
     {schematic_cell = "D80XMFCNVM4C", layout_cell = "D80XMFCNVM4C"},
     {schematic_cell = "D80XMFCNVM6A", layout_cell = "D80XMFCNVM6A"},
     {schematic_cell = "D80XMFCNVM6B", layout_cell = "D80XMFCNVM6B"},
     {schematic_cell = "D80XMFCNVM6C", layout_cell = "D80XMFCNVM6C"},
     {schematic_cell = "D80SMFCEVM3D", layout_cell = "D80SMFCEVM3D"},
     {schematic_cell = "D80SMFCNVM3D", layout_cell = "D80SMFCNVM3D"},	 
     {schematic_cell = "D80SMFCNVM5D", layout_cell = "D80SMFCNVM5D"},
     {schematic_cell = "D80SMFCTGUVM3D",layout_cell = "D80SMFCTGUVM3D"},
     {schematic_cell = "D80XMFCNVM3D", layout_cell = "D80XMFCNVM3D"},	 
     {schematic_cell = "D80XMFCNVM5D", layout_cell = "D80XMFCNVM5D"},	 
	 	 	 	 	 	 
	 
     // hsd 1228
     {schematic_cell = "D8XSMFCNVM6ADIFF", layout_cell = "D8XSMFCNVM6ADIFF"},

    {schematic_cell = "D87SMFCNVM6ADIFF", layout_cell = "D87SMFCNVM6ADIFF"},

    {schematic_cell = "D88SMFCNVM6ADIFF", layout_cell = "D88SMFCNVM6ADIFF"},

     {schematic_cell = "D80SMFCNVM6ADIFF", layout_cell = "D80SMFCNVM6ADIFF"},
     

 
     // hybrid decaps 
     // assume the cap part is in the *_METAL cell and active devices in the base cell 
     // that is why sub cell is the bb element
     // d8lib 
     {schematic_cell = "D8XSDCPIPNVM2", layout_cell = "D8XSDCPIPNVM2"},
     {schematic_cell = "D8XSDCPIPNVM4", layout_cell = "D8XSDCPIPNVM4"},
     {schematic_cell = "D8XSDCPIPNVM4E", layout_cell = "D8XSDCPIPNVM4E"},
     {schematic_cell = "D8XSDCPIPNVM6S", layout_cell = "D8XSDCPIPNVM6S"},
     {schematic_cell = "D8XSDCPINTGEVM2", layout_cell = "D8XSDCPINTGEVM2"},
     {schematic_cell = "D8XSDCPINTGEVM4", layout_cell = "D8XSDCPINTGEVM4"},

     {schematic_cell = "D87SDCPIPNVM2", layout_cell = "D87SDCPIPNVM2"},
     {schematic_cell = "D87SDCPIPNVM4", layout_cell = "D87SDCPIPNVM4"},
     {schematic_cell = "D87SDCPIPNVM4E", layout_cell = "D87SDCPIPNVM4E"},
     {schematic_cell = "D87SDCPIPNVM6S", layout_cell = "D87SDCPIPNVM6S"},
     {schematic_cell = "D87SDCPINTGEVM2", layout_cell = "D87SDCPINTGEVM2"},
     {schematic_cell = "D87SDCPINTGEVM4", layout_cell = "D87SDCPINTGEVM4"},

     {schematic_cell = "D88SDCPIPNVM2", layout_cell = "D88SDCPIPNVM2"},
     {schematic_cell = "D88SDCPIPNVM4", layout_cell = "D88SDCPIPNVM4"},
     {schematic_cell = "D88SDCPIPNVM4E", layout_cell = "D88SDCPIPNVM4E"},
     {schematic_cell = "D88SDCPIPNVM6S", layout_cell = "D88SDCPIPNVM6S"},
     {schematic_cell = "D88SDCPINTGEVM2", layout_cell = "D88SDCPINTGEVM2"},
     {schematic_cell = "D88SDCPINTGEVM4", layout_cell = "D88SDCPINTGEVM4"},

     {schematic_cell = "D80SDCPIPNVM2", layout_cell = "D80SDCPIPNVM2"},
     {schematic_cell = "D80SDCPIPNVM4", layout_cell = "D80SDCPIPNVM4"},
     {schematic_cell = "D80SDCPIPNVM4E", layout_cell = "D80SDCPIPNVM4E"},
     {schematic_cell = "D80SDCPIPNVM6S", layout_cell = "D80SDCPIPNVM6S"},
     {schematic_cell = "D80SDCPINTGEVM2", layout_cell = "D80SDCPINTGEVM2"},
     {schematic_cell = "D80SDCPINTGEVM4", layout_cell = "D80SDCPINTGEVM4"},
	 
// hsd 2297    {schematic_cell = "D8XSDCPIPTGEVM2", layout_cell = "D8XSDCPIPTGEVM2"},
// hsd 2297    {schematic_cell = "D8XSDCPIPTGEVM4", layout_cell = "D8XSDCPIPTGEVM4"},
     // hsd 2282
     {schematic_cell = "D8XSDCPINTGEVM2_S2S", layout_cell = "D8XSDCPINTGEVM2_S2S"},
     {schematic_cell = "D8XSDCPINTGEVM4_S2S", layout_cell = "D8XSDCPINTGEVM4_S2S"},

     {schematic_cell = "D8XXDCPIPNVM2", layout_cell = "D8XXDCPIPNVM2"},
     {schematic_cell = "D8XXDCPIPNVM4", layout_cell = "D8XXDCPIPNVM4"},

     {schematic_cell = "D87SDCPINTGEVM2_S2S", layout_cell = "D87SDCPINTGEVM2_S2S"},
     {schematic_cell = "D87SDCPINTGEVM4_S2S", layout_cell = "D87SDCPINTGEVM4_S2S"},

     {schematic_cell = "D87XDCPIPNVM2", layout_cell = "D87XDCPIPNVM2"},
     {schematic_cell = "D87XDCPIPNVM4", layout_cell = "D87XDCPIPNVM4"},


     {schematic_cell = "D88SDCPINTGEVM2_S2S", layout_cell = "D88SDCPINTGEVM2_S2S"},
     {schematic_cell = "D88SDCPINTGEVM4_S2S", layout_cell = "D88SDCPINTGEVM4_S2S"},

     {schematic_cell = "D88XDCPIPNVM2", layout_cell = "D88XDCPIPNVM2"},
     {schematic_cell = "D88XDCPIPNVM4", layout_cell = "D88XDCPIPNVM4"},	
	 
     {schematic_cell = "D80SDCPINTGEVM2_S2S", layout_cell = "D80SDCPINTGEVM2_S2S"},
     {schematic_cell = "D80SDCPINTGEVM4_S2S", layout_cell = "D80SDCPINTGEVM4_S2S"},

     {schematic_cell = "D80XDCPIPNVM2", layout_cell = "D80XDCPIPNVM2"},
     {schematic_cell = "D80XDCPIPNVM4", layout_cell = "D80XDCPIPNVM4"},	


     // hsd 1431 
     {schematic_cell = "D8XXDCPIPHVM2", layout_cell = "D8XXDCPIPHVM2"},
     {schematic_cell = "D8XXDCPIPNVM4P5", layout_cell = "D8XXDCPIPNVM4P5"},
     {schematic_cell = "D8XXDCPIPNVM2P5", layout_cell = "D8XXDCPIPNVM2P5"},

     {schematic_cell = "D87XDCPIPHVM2", layout_cell = "D87XDCPIPHVM2"},
     {schematic_cell = "D87XDCPIPNVM4P5", layout_cell = "D87XDCPIPNVM4P5"},
     {schematic_cell = "D87XDCPIPNVM2P5", layout_cell = "D87XDCPIPNVM2P5"},

     {schematic_cell = "D88XDCPIPHVM2", layout_cell = "D88XDCPIPHVM2"},
     {schematic_cell = "D88XDCPIPNVM4P5", layout_cell = "D88XDCPIPNVM4P5"},
     {schematic_cell = "D88XDCPIPNVM2P5", layout_cell = "D88XDCPIPNVM2P5"},

     {schematic_cell = "D80XDCPIPHVM2", layout_cell = "D80XDCPIPHVM2"},
     {schematic_cell = "D80XDCPIPNVM4P5", layout_cell = "D80XDCPIPNVM4P5"},
     {schematic_cell = "D80XDCPIPNVM2P5", layout_cell = "D80XDCPIPNVM2P5"},	 
		 
	
     // hsd 1702
     {schematic_cell = "D86SDCPIPNVM6S", layout_cell = "D86SDCPIPNVM6S"},
     // hsd 1878
     // {schematic_cell = "D8XSDCPIPTGULVM4", layout_cell = "D8XSDCPIPTGULVM4"}, // as per email from suhas
     // {schematic_cell = "D8XSDCPINTGULVM4", layout_cell = "D8XSDCPINTGULVM4"}, // as per email from suhas
     // hsd 1998
     {schematic_cell = "D8XSDCPIPHVM2", layout_cell = "D8XSDCPIPHVM2"},
     {schematic_cell = "D8XSDCPIPHVM4", layout_cell = "D8XSDCPIPHVM4"},
     {schematic_cell = "D86SDCPIPHVM6", layout_cell = "D86SDCPIPHVM6"},

     {schematic_cell = "D87SDCPIPHVM2", layout_cell = "D87SDCPIPHVM2"},
     {schematic_cell = "D87SDCPIPHVM4", layout_cell = "D87SDCPIPHVM4"},

     {schematic_cell = "D88SDCPIPHVM2", layout_cell = "D88SDCPIPHVM2"},
     {schematic_cell = "D88SDCPIPHVM4", layout_cell = "D88SDCPIPHVM4"},

     {schematic_cell = "D80SDCPIPHVM2", layout_cell = "D80SDCPIPHVM2"},
     {schematic_cell = "D80SDCPIPHVM4", layout_cell = "D80SDCPIPHVM4"},

      // hsd 2495
     {schematic_cell = "D8XSDCPIPTGEVM4V2", layout_cell = "D8XSDCPIPTGEVM4V2"},
     {schematic_cell = "D8XSDCPIPTGEVM2V2", layout_cell = "D8XSDCPIPTGEVM2V2"},

     {schematic_cell = "D87SDCPIPTGEVM4V2", layout_cell = "D87SDCPIPTGEVM4V2"},
     {schematic_cell = "D87SDCPIPTGEVM2V2", layout_cell = "D87SDCPIPTGEVM2V2"},

     {schematic_cell = "D88SDCPIPTGEVM4V2", layout_cell = "D88SDCPIPTGEVM4V2"},
     {schematic_cell = "D88SDCPIPTGEVM2V2", layout_cell = "D88SDCPIPTGEVM2V2"},

     {schematic_cell = "D80SDCPIPTGEVM4V2", layout_cell = "D80SDCPIPTGEVM4V2"},
     {schematic_cell = "D80SDCPIPTGEVM2V2", layout_cell = "D80SDCPIPTGEVM2V2"},	 
     // hsd 2023	 
     {schematic_cell = "D81SINDMTM1M9L1P1N", layout_cell = "D81SINDMTM1M9L1P1N"},



     // black box macros from tripti but not templates for tuc
	 // next 4 hsd 621917 ; now wants parents also in tuc flow tripti
     {schematic_cell = "D8XXRTCNEVM2VTUNPCI_BASE", layout_cell = "D8XXRTCNEVM2VTUNPCI_BASE"},
     {schematic_cell = "D8XXRTCNEVM2VTUNDDRSTAT_BASE", layout_cell = "D8XXRTCNEVM2VTUNDDRSTAT_BASE"},
     {schematic_cell = "D8XXRTCNEVM2VTUNDDRCMD_BASE", layout_cell = "D8XXRTCNEVM2VTUNDDRCMD_BASE"},
     {schematic_cell = "D8XXRTCNEVM2VTUNDDRDYN_BASE", layout_cell = "D8XXRTCNEVM2VTUNDDRDYN_BASE"},

     {schematic_cell = "D87XRTCNEVM2VTUNPCI_BASE", layout_cell = "D87XRTCNEVM2VTUNPCI_BASE"},
     {schematic_cell = "D87XRTCNEVM2VTUNDDRSTAT_BASE", layout_cell = "D87XRTCNEVM2VTUNDDRSTAT_BASE"},
     {schematic_cell = "D87XRTCNEVM2VTUNDDRCMD_BASE", layout_cell = "D87XRTCNEVM2VTUNDDRCMD_BASE"},
     {schematic_cell = "D87XRTCNEVM2VTUNDDRDYN_BASE", layout_cell = "D87XRTCNEVM2VTUNDDRDYN_BASE"},

     {schematic_cell = "D88XRTCNEVM2VTUNPCI_BASE", layout_cell = "D88XRTCNEVM2VTUNPCI_BASE"},
     {schematic_cell = "D88XRTCNEVM2VTUNDDRSTAT_BASE", layout_cell = "D88XRTCNEVM2VTUNDDRSTAT_BASE"},
     {schematic_cell = "D88XRTCNEVM2VTUNDDRCMD_BASE", layout_cell = "D88XRTCNEVM2VTUNDDRCMD_BASE"},
     {schematic_cell = "D88XRTCNEVM2VTUNDDRDYN_BASE", layout_cell = "D88XRTCNEVM2VTUNDDRDYN_BASE"},

     {schematic_cell = "D80XRTCNEVM2VTUNPCI_BASE", layout_cell = "D80XRTCNEVM2VTUNPCI_BASE"},
     {schematic_cell = "D80XRTCNEVM2VTUNDDRSTAT_BASE", layout_cell = "D80XRTCNEVM2VTUNDDRSTAT_BASE"},
     {schematic_cell = "D80XRTCNEVM2VTUNDDRCMD_BASE", layout_cell = "D80XRTCNEVM2VTUNDDRCMD_BASE"},
     {schematic_cell = "D80XRTCNEVM2VTUNDDRDYN_BASE", layout_cell = "D80XRTCNEVM2VTUNDDRDYN_BASE"},
	 
	{schematic_cell = "X73BTSVCCSYMB", layout_cell = "X73BTSVCCSYMB"},
	// tsv catch-cup as per kalyan
	{schematic_cell = "D8XLTSV_CCSYMB", layout_cell = "D8XLTSV_CCSYMB"},
	{schematic_cell = "D87LTSV_CCSYMB", layout_cell = "D87LTSV_CCSYMB"},
	{schematic_cell = "D88LTSV_CCSYMB", layout_cell = "D88LTSV_CCSYMB"},
	{schematic_cell = "D80LTSV_CCSYMB", layout_cell = "D80LTSV_CCSYMB"}, 

	// scr cells hsd 1861
	{schematic_cell = "D8XSESDSCREVM1", layout_cell = "D8XSESDSCREVM1"},
	{schematic_cell = "D8XSESDSCRUVM1", layout_cell = "D8XSESDSCRUVM1"},
	{schematic_cell = "D8XSESDSCREVM1_PRIM", layout_cell = "D8XSESDSCREVM1_PRIM"},
	{schematic_cell = "D8XSESDSCRUVM1_PRIM", layout_cell = "D8XSESDSCRUVM1_PRIM"},

	{schematic_cell = "D87SESDSCREVM1", layout_cell = "D87SESDSCREVM1"},
	{schematic_cell = "D87SESDSCRUVM1", layout_cell = "D87SESDSCRUVM1"},
	{schematic_cell = "D87SESDSCREVM1_PRIM", layout_cell = "D87SESDSCREVM1_PRIM"},
	{schematic_cell = "D87SESDSCRUVM1_PRIM", layout_cell = "D87SESDSCRUVM1_PRIM"},
	{schematic_cell = "D87SESDSCREVM1_DNW", layout_cell = "D87SESDSCREVM1_DNW"},
	{schematic_cell = "D87SESDSCRUVM1_DNW", layout_cell = "D87SESDSCRUVM1_DNW"},
  // from tao
	{schematic_cell = "D87SESDSCREVM1_PRIM_DNW", layout_cell = "D87SESDSCREVM1_PRIM_DNW"},
	{schematic_cell = "D87SESDSCRUVM1_PRIM_DNW", layout_cell = "D87SESDSCRUVM1_PRIM_DNW"},

	{schematic_cell = "D88SESDSCREVM1", layout_cell = "D88SESDSCREVM1"},
	{schematic_cell = "D88SESDSCRUVM1", layout_cell = "D88SESDSCRUVM1"},
    
	{schematic_cell = "D80SESDSCREVM1", layout_cell = "D80SESDSCREVM1"},
	{schematic_cell = "D80SESDSCRUVM1", layout_cell = "D80SESDSCRUVM1"},

	    // hsd 2219 diode templates
     {schematic_cell = "D8XMBGDIODEHVM1", layout_cell = "D8XMBGDIODEHVM1"},
     {schematic_cell = "D8XSESDDNUVTERM", layout_cell = "D8XSESDDNUVTERM"},
     {schematic_cell = "D8XSESDDPUVTERM", layout_cell = "D8XSESDDPUVTERM"},

     {schematic_cell = "D87MBGDIODEHVM1", layout_cell = "D87MBGDIODEHVM1"},
     {schematic_cell = "D87SESDDNUVTERM", layout_cell = "D87SESDDNUVTERM"},
     {schematic_cell = "D87SESDDPUVTERM", layout_cell = "D87SESDDPUVTERM"},

     {schematic_cell = "D88MBGDIODEHVM1", layout_cell = "D88MBGDIODEHVM1"},
     {schematic_cell = "D88SESDDNUVTERM", layout_cell = "D88SESDDNUVTERM"},
     {schematic_cell = "D88SESDDPUVTERM", layout_cell = "D88SESDDPUVTERM"},


     {schematic_cell = "D80MBGDIODEHVM1", layout_cell = "D80MBGDIODEHVM1"},
     {schematic_cell = "D80SESDDNUVTERM", layout_cell = "D80SESDDNUVTERM"},
     {schematic_cell = "D80SESDDPUVTERM", layout_cell = "D80SESDDPUVTERM"},
	 
	 
	// antifuse cells
	{schematic_cell = "X73P00FCARY1NE_1C_0", layout_cell = "X73P00FCARY1NE_1C_0"},
	{schematic_cell = "X73P00FCARY1NE_1C_1", layout_cell = "X73P00FCARY1NE_1C_1"},
	{schematic_cell = "X73P00FCARY1NE_1C_2", layout_cell = "X73P00FCARY1NE_1C_2"},
	{schematic_cell = "X73P00FCARY1NE_1C_3", layout_cell = "X73P00FCARY1NE_1C_3"},
	{schematic_cell = "X73P00FCARY1NE_1C_4", layout_cell = "X73P00FCARY1NE_1C_4"},
	{schematic_cell = "X73P00FCARY1NE_1C_5", layout_cell = "X73P00FCARY1NE_1C_5"},
	{schematic_cell = "X73P00FCARY1NE_1C_6", layout_cell = "X73P00FCARY1NE_1C_6"}
	

 #else  // else lowercase
     // tcn resistors
     {schematic_cell = "d8xxrtcnevm2acon_base", layout_cell = "d8xxrtcnevm2acon_base"},
     {schematic_cell = "d8xxrtcnevm2abod_01", layout_cell = "d8xxrtcnevm2abod_01"},
     {schematic_cell = "d8xxrtcnevm2abod_02", layout_cell = "d8xxrtcnevm2abod_02"},
     {schematic_cell = "d8xxrtcnevm2abod_03", layout_cell = "d8xxrtcnevm2abod_03"},

     {schematic_cell = "d87xrtcnevm2acon_base", layout_cell = "d87xrtcnevm2acon_base"},
     {schematic_cell = "d87xrtcnevm2abod_01", layout_cell = "d87xrtcnevm2abod_01"},
     {schematic_cell = "d87xrtcnevm2abod_02", layout_cell = "d87xrtcnevm2abod_02"},
     {schematic_cell = "d87xrtcnevm2abod_03", layout_cell = "d87xrtcnevm2abod_03"},

     {schematic_cell = "d88xrtcnevm2acon_base", layout_cell = "d88xrtcnevm2acon_base"},
     {schematic_cell = "d88xrtcnevm2abod_01", layout_cell = "d88xrtcnevm2abod_01"},
     {schematic_cell = "d88xrtcnevm2abod_02", layout_cell = "d88xrtcnevm2abod_02"},
     {schematic_cell = "d88xrtcnevm2abod_03", layout_cell = "d88xrtcnevm2abod_03"},

     {schematic_cell = "d80xrtcnevm2acon_base", layout_cell = "d80xrtcnevm2acon_base"},
     {schematic_cell = "d80xrtcnevm2abod_01", layout_cell = "d80xrtcnevm2abod_01"},
     {schematic_cell = "d80xrtcnevm2abod_02", layout_cell = "d80xrtcnevm2abod_02"},
     {schematic_cell = "d80xrtcnevm2abod_03", layout_cell = "d80xrtcnevm2abod_03"},


     // *** tcn vertical tune resistor
     {schematic_cell = "d8xxrtcnevm2vtuncontop_base", layout_cell = "d8xxrtcnevm2vtuncontop_base"},
     {schematic_cell = "d8xxrtcnevm2vtunconbot_base", layout_cell = "d8xxrtcnevm2vtunconbot_base"},
     {schematic_cell = "d8xxrtcnevm2vtunturntop", layout_cell = "d8xxrtcnevm2vtunturntop"},
     {schematic_cell = "d8xxrtcnevm2vtunturnbot", layout_cell = "d8xxrtcnevm2vtunturnbot"},
     {schematic_cell = "d8xxrtcnevm2vtunbodtop", layout_cell = "d8xxrtcnevm2vtunbodtop"},
     {schematic_cell = "d8xxrtcnevm2vtunbodbot", layout_cell = "d8xxrtcnevm2vtunbodbot"},
     {schematic_cell = "d8xxrtcnevm2vtunmid", layout_cell = "d8xxrtcnevm2vtunmid"},
     {schematic_cell = "d8xxrtcnevm2vtunmidfh", layout_cell = "d8xxrtcnevm2vtunmidfh"},


     {schematic_cell = "d87xrtcnevm2vtuncontop_base", layout_cell = "d87xrtcnevm2vtuncontop_base"},
     {schematic_cell = "d87xrtcnevm2vtunconbot_base", layout_cell = "d87xrtcnevm2vtunconbot_base"},
     {schematic_cell = "d87xrtcnevm2vtunturntop", layout_cell = "d87xrtcnevm2vtunturntop"},
     {schematic_cell = "d87xrtcnevm2vtunturnbot", layout_cell = "d87xrtcnevm2vtunturnbot"},
     {schematic_cell = "d87xrtcnevm2vtunbodtop", layout_cell = "d87xrtcnevm2vtunbodtop"},
     {schematic_cell = "d87xrtcnevm2vtunbodbot", layout_cell = "d87xrtcnevm2vtunbodbot"},
     {schematic_cell = "d87xrtcnevm2vtunmid", layout_cell = "d87xrtcnevm2vtunmid"},
     {schematic_cell = "d87xrtcnevm2vtunmidfh", layout_cell = "d87xrtcnevm2vtunmidfh"},


     {schematic_cell = "d88xrtcnevm2vtuncontop_base", layout_cell = "d88xrtcnevm2vtuncontop_base"},
     {schematic_cell = "d88xrtcnevm2vtunconbot_base", layout_cell = "d88xrtcnevm2vtunconbot_base"},
     {schematic_cell = "d88xrtcnevm2vtunturntop", layout_cell = "d88xrtcnevm2vtunturntop"},
     {schematic_cell = "d88xrtcnevm2vtunturnbot", layout_cell = "d88xrtcnevm2vtunturnbot"},
     {schematic_cell = "d88xrtcnevm2vtunbodtop", layout_cell = "d88xrtcnevm2vtunbodtop"},
     {schematic_cell = "d88xrtcnevm2vtunbodbot", layout_cell = "d88xrtcnevm2vtunbodbot"},
     {schematic_cell = "d88xrtcnevm2vtunmid", layout_cell = "d88xrtcnevm2vtunmid"},
     {schematic_cell = "d88xrtcnevm2vtunmidfh", layout_cell = "d88xrtcnevm2vtunmidfh"},

     {schematic_cell = "d80xrtcnevm2vtuncontop_base", layout_cell = "d80xrtcnevm2vtuncontop_base"},
     {schematic_cell = "d80xrtcnevm2vtunconbot_base", layout_cell = "d80xrtcnevm2vtunconbot_base"},
     {schematic_cell = "d80xrtcnevm2vtunturntop", layout_cell = "d80xrtcnevm2vtunturntop"},
     {schematic_cell = "d80xrtcnevm2vtunturnbot", layout_cell = "d80xrtcnevm2vtunturnbot"},
     {schematic_cell = "d80xrtcnevm2vtunbodtop", layout_cell = "d80xrtcnevm2vtunbodtop"},
     {schematic_cell = "d80xrtcnevm2vtunbodbot", layout_cell = "d80xrtcnevm2vtunbodbot"},
     {schematic_cell = "d80xrtcnevm2vtunmid", layout_cell = "d80xrtcnevm2vtunmid"},
     {schematic_cell = "d80xrtcnevm2vtunmidfh", layout_cell = "d80xrtcnevm2vtunmidfh"}, 
     // *** tcn dac resistor
     {schematic_cell = "d8xxrtcnevm2daccontop_base", layout_cell = "d8xxrtcnevm2daccontop_base"},
     {schematic_cell = "d8xxrtcnevm2dacconbot_base", layout_cell = "d8xxrtcnevm2dacconbot_base"},
     {schematic_cell = "d8xxrtcnevm2dac_base", layout_cell = "d8xxrtcnevm2dac_base"},

     {schematic_cell = "d87xrtcnevm2daccontop_base", layout_cell = "d87xrtcnevm2daccontop_base"},
     {schematic_cell = "d87xrtcnevm2dacconbot_base", layout_cell = "d87xrtcnevm2dacconbot_base"},
     {schematic_cell = "d87xrtcnevm2dac_base", layout_cell = "d87xrtcnevm2dac_base"},

     {schematic_cell = "d88xrtcnevm2daccontop_base", layout_cell = "d88xrtcnevm2daccontop_base"},
     {schematic_cell = "d88xrtcnevm2dacconbot_base", layout_cell = "d88xrtcnevm2dacconbot_base"},
     {schematic_cell = "d88xrtcnevm2dac_base", layout_cell = "d88xrtcnevm2dac_base"},

     {schematic_cell = "d80xrtcnevm2daccontop_base", layout_cell = "d80xrtcnevm2daccontop_base"},
     {schematic_cell = "d80xrtcnevm2dacconbot_base", layout_cell = "d80xrtcnevm2dacconbot_base"},
     {schematic_cell = "d80xrtcnevm2dac_base", layout_cell = "d80xrtcnevm2dac_base"},	 

      // as per tripti hsd da_help 620520
     {schematic_cell = "d8xxrtcnevm2dacturn", layout_cell = "d8xxrtcnevm2dacturn"},
     {schematic_cell = "d8xxrtcnevm2dacturncon_base", layout_cell = "d8xxrtcnevm2dacturncon_base"},

     {schematic_cell = "d87xrtcnevm2dacturn", layout_cell = "d87xrtcnevm2dacturn"},
     {schematic_cell = "d87xrtcnevm2dacturncon_base", layout_cell = "d87xrtcnevm2dacturncon_base"},

    {schematic_cell = "d88xrtcnevm2dacturn", layout_cell = "d88xrtcnevm2dacturn"},
     {schematic_cell = "d88xrtcnevm2dacturncon_base", layout_cell = "d88xrtcnevm2dacturncon_base"},

     {schematic_cell = "d80xrtcnevm2dacturn", layout_cell = "d80xrtcnevm2dacturn"},
     {schematic_cell = "d80xrtcnevm2dacturncon_base", layout_cell = "d80xrtcnevm2dacturncon_base"},	
     // hsd 1824
     {schematic_cell = "d8xsrtcnevm2dac_base", layout_cell = "d8xsrtcnevm2dac_base"}, 
     {schematic_cell = "d8xsrtcnevm2daccontop_base", layout_cell = "d8xsrtcnevm2daccontop_base"}, 
     {schematic_cell = "d8xsrtcnevm2dacconbot_base", layout_cell = "d8xsrtcnevm2dacconbot_base"}, 
     {schematic_cell = "d8xsrtcnevm2dacturncon_base", layout_cell = "d8xsrtcnevm2dacturncon_base"}, 
     {schematic_cell = "d8xsrtcnevm2dacturn", layout_cell = "d8xsrtcnevm2dacturn"},


     {schematic_cell = "d87srtcnevm2dac_base", layout_cell = "d87srtcnevm2dac_base"}, 
     {schematic_cell = "d87srtcnevm2daccontop_base", layout_cell = "d87srtcnevm2daccontop_base"}, 
     {schematic_cell = "d87srtcnevm2dacconbot_base", layout_cell = "d87srtcnevm2dacconbot_base"}, 
     {schematic_cell = "d87srtcnevm2dacturncon_base", layout_cell = "d87srtcnevm2dacturncon_base"}, 
     {schematic_cell = "d87srtcnevm2dacturn", layout_cell = "d87srtcnevm2dacturn"},


     {schematic_cell = "d88srtcnevm2dac_base", layout_cell = "d88srtcnevm2dac_base"}, 
     {schematic_cell = "d88srtcnevm2daccontop_base", layout_cell = "d88srtcnevm2daccontop_base"}, 
     {schematic_cell = "d88srtcnevm2dacconbot_base", layout_cell = "d88srtcnevm2dacconbot_base"}, 
     {schematic_cell = "d88srtcnevm2dacturncon_base", layout_cell = "d88srtcnevm2dacturncon_base"}, 
     {schematic_cell = "d88srtcnevm2dacturn", layout_cell = "d88srtcnevm2dacturn"},

     {schematic_cell = "d80srtcnevm2dac_base", layout_cell = "d80srtcnevm2dac_base"}, 
     {schematic_cell = "d80srtcnevm2daccontop_base", layout_cell = "d80srtcnevm2daccontop_base"}, 
     {schematic_cell = "d80srtcnevm2dacconbot_base", layout_cell = "d80srtcnevm2dacconbot_base"}, 
     {schematic_cell = "d80srtcnevm2dacturncon_base", layout_cell = "d80srtcnevm2dacturncon_base"}, 
     {schematic_cell = "d80srtcnevm2dacturn", layout_cell = "d80srtcnevm2dacturn"},
	 
	 
     // hsd 2075
     {schematic_cell = "d8xsrtcnuvm2p5vtun_base", layout_cell = "d8xsrtcnuvm2p5vtun_base"},
     {schematic_cell = "d87srtcnuvm2p5vtun_base", layout_cell = "d87srtcnuvm2p5vtun_base"},
     {schematic_cell = "d88srtcnuvm2p5vtun_base", layout_cell = "d88srtcnuvm2p5vtun_base"},
     {schematic_cell = "d80srtcnuvm2p5vtun_base", layout_cell = "d80srtcnuvm2p5vtun_base"},
     // d8lib
     // CPR resistors
 
     // inductor
     // d8lib
     {schematic_cell = "d84sindmtm1m9l1p1n", layout_cell = "d84sindmtm1m9l1p1n"},
     {schematic_cell = "d84sindmtm1m9l2p2n", layout_cell = "d84sindmtm1m9l2p2n"},

     {schematic_cell = "d84sindmtm1m9l0p4n", layout_cell = "d84sindmtm1m9l0p4n"},
     // hsd 1332
     {schematic_cell = "d84shipindmtm1m9l0p6n", layout_cell = "d84shipindmtm1m9l0p6n"},
     {schematic_cell = "d84shipindmtm1m9l1p1n", layout_cell = "d84shipindmtm1m9l1p1n"},
	 // hsd 1434
     {schematic_cell = "d84sindmtm1m9l0p7n10g", layout_cell = "d84sindmtm1m9l0p7n10g"}, 
	 // hsd 1431 
     {schematic_cell = "d86sindtm1m11l1p1n", layout_cell = "d86sindtm1m11l1p1n"},
     {schematic_cell = "d86sindtm1m11l2p2n", layout_cell = "d86sindtm1m11l2p2n"},
     // hsd 1702
     {schematic_cell = "d86sindm12l0p15n", layout_cell = "d86sindm12l0p15n"},
     {schematic_cell = "d86sindm12l0p2n", layout_cell = "d86sindm12l0p2n"},
     {schematic_cell = "d86sindm12ctl0p2n", layout_cell = "d86sindm12ctl0p2n"},
     {schematic_cell = "d86sindm12l0p265n", layout_cell = "d86sindm12l0p265n"},
     // hsd 1878
     // {schematic_cell = "d8xsdcpiptgulvm4", layout_cell = "d8xsdcpiptgulvm4"}, // as per email from suhas
     // {schematic_cell = "d8xsdcpintgulvm4", layout_cell = "d8xsdcpintgulvm4"}, // as per email from suhas
     // hsd 1846
     {schematic_cell = "d81sindmtm1m9l1p6n", layout_cell = "d81sindmtm1m9l1p6n"},
     // hsd 1860
     {schematic_cell = "d81shipindmtm1m9l1p1n", layout_cell = "d81shipindmtm1m9l1p1n"},
     // hsd 1880
     {schematic_cell = "d86sindspiralm12l0p8n", layout_cell = "d86sindspiralm12l0p8n"},
     {schematic_cell = "d86sindtm1m12l0p72n", layout_cell = "d86sindtm1m12l0p72n"},
     // hsd 1896
	 {schematic_cell = "d81shipindmtm1l0p5n",  layout_cell = "d81shipindmtm1l0p5n"},
	 {schematic_cell = "d81shipindmtm1m9l0p9n", layout_cell = "d81shipindmtm1m9l0p9n"},
     // hsd 2697
	 {schematic_cell = "d81shipindmtm1m9l1p6n", layout_cell = "d81shipindmtm1m9l1p6n"},
   // from tao
     {schematic_cell = "d87sindmtm1m9l1p1n", layout_cell = "d87sindmtm1m9l1p1n"},
     {schematic_cell = "d87sindmtm1m9l1p6n", layout_cell = "d87sindmtm1m9l1p6n"},

     // hsd 1998
     {schematic_cell = "d8xsdcpiphvm2", layout_cell = "d8xsdcpiphvm2"},
     {schematic_cell = "d8xsdcpiphvm4", layout_cell = "d8xsdcpiphvm4"},
     {schematic_cell = "d86sdcpiphvm6", layout_cell = "d86sdcpiphvm6"},

     {schematic_cell = "d87sdcpiphvm2", layout_cell = "d87sdcpiphvm2"},
     {schematic_cell = "d87sdcpiphvm4", layout_cell = "d87sdcpiphvm4"},

	 {schematic_cell = "d87sdcpiptgevm4v2", layout_cell = "d87sdcpiptgevm4v2"},
     {schematic_cell = "d87sdcpiptgevm2v2", layout_cell = "d87sdcpiptgevm2v2"},


//hsd 2495
     {schematic_cell = "d8xsdcpiptgevm4v2", layout_cell = "d8xsdcpiptgevm4v2"},
     {schematic_cell = "d8xsdcpiptgevm2v2", layout_cell = "d8xsdcpiptgevm2v2"},


     {schematic_cell = "d88sdcpiphvm2", layout_cell = "d88sdcpiphvm2"},
     {schematic_cell = "d88sdcpiphvm4", layout_cell = "d88sdcpiphvm4"},
     
     {schematic_cell = "d80sdcpiphvm2", layout_cell = "d80sdcpiphvm2"},
     {schematic_cell = "d80sdcpiphvm4", layout_cell = "d80sdcpiphvm4"},
     	 
     {schematic_cell = "d80sdcpiptgevm4v2", layout_cell = "d80sdcpiptgevm4v2"},
     {schematic_cell = "d80sdcpiptgevm2v2", layout_cell = "d80sdcpiptgevm2v2"},	 
     // hsd 2023
     {schematic_cell = "d81sindmtm1m9l1p1n", layout_cell = "d81sindmtm1m9l1p1n"},

     // varactor
     // d8lib
     {schematic_cell = "d8xmvargbnd60f252zevm2", layout_cell = "d8xmvargbnd60f252zevm2"},
     {schematic_cell = "d8xmvargbnd64f252z2evm2", layout_cell = "d8xmvargbnd64f252z2evm2"}, // x73

     {schematic_cell = "d87mvargbnd60f252zevm2", layout_cell = "d87mvargbnd60f252zevm2"},
     {schematic_cell = "d87mvargbnd64f252z2evm2", layout_cell = "d87mvargbnd64f252z2evm2"}, // x73

     {schematic_cell = "d88mvargbnd60f252zevm2", layout_cell = "d88mvargbnd60f252zevm2"},
     {schematic_cell = "d88mvargbnd64f252z2evm2", layout_cell = "d88mvargbnd64f252z2evm2"}, // x73

     {schematic_cell = "d80mvargbnd60f252zevm2", layout_cell = "d80mvargbnd60f252zevm2"},
     {schematic_cell = "d80mvargbnd64f252z2evm2", layout_cell = "d80mvargbnd64f252z2evm2"}, // x73




     // hsd 2390
     {schematic_cell = "d8xmtgvargbnd24f336zevm2", layout_cell = "d8xmtgvargbnd24f336zevm2"},
     {schematic_cell = "d8xmvargbns32f336zevm2", layout_cell = "d8xmvargbns32f336zevm2"},
     {schematic_cell = "d8xmvargbns128f336zevm2", layout_cell = "d8xmvargbns128f336zevm2"},
     {schematic_cell = "d8xsvargbnd64f252z2evm2", layout_cell = "d8xsvargbnd64f252z2evm2"},

     {schematic_cell = "d87mtgvargbnd24f336zevm2", layout_cell = "d87mtgvargbnd24f336zevm2"},
     {schematic_cell = "d87mvargbns32f336zevm2", layout_cell = "d87mvargbns32f336zevm2"},
     {schematic_cell = "d87mvargbns128f336zevm2", layout_cell = "d87mvargbns128f336zevm2"},
     {schematic_cell = "d87svargbnd64f252z2evm2", layout_cell = "d87svargbnd64f252z2evm2"},

     {schematic_cell = "d88mtgvargbnd24f336zevm2", layout_cell = "d88mtgvargbnd24f336zevm2"},
     {schematic_cell = "d88mvargbns32f336zevm2", layout_cell = "d88mvargbns32f336zevm2"},
     {schematic_cell = "d88mvargbns128f336zevm2", layout_cell = "d88mvargbns128f336zevm2"},
     {schematic_cell = "d88svargbnd64f252z2evm2", layout_cell = "d88svargbnd64f252z2evm2"},

     {schematic_cell = "d80mtgvargbnd24f336zevm2", layout_cell = "d80mtgvargbnd24f336zevm2"},
     {schematic_cell = "d80mvargbns32f336zevm2", layout_cell = "d80mvargbns32f336zevm2"},
     {schematic_cell = "d80mvargbns128f336zevm2", layout_cell = "d80mvargbns128f336zevm2"},
     {schematic_cell = "d80svargbnd64f252z2evm2", layout_cell = "d80svargbnd64f252z2evm2"},
	 
     {schematic_cell = "d8xmtgvargbns16f336zevm2", layout_cell = "d8xmtgvargbns16f336zevm2"}, // hsd 2880
     {schematic_cell = "d8xmtgvargbns56f336zevm2", layout_cell = "d8xmtgvargbns56f336zevm2"}, // hsd 2880

     // gbn       
     // gbn placeholders until full GBNWELL extraction is supported       
     {schematic_cell = "d8xsesdclampcaptg1", layout_cell = "d8xsesdclampcaptg1"},
     {schematic_cell = "d8xsesdclampcaptg2", layout_cell = "d8xsesdclampcaptg2"},
 
     {schematic_cell = "d8xsesdclampres", layout_cell = "d8xsesdclampres"},
     {schematic_cell = "d8xsesdclamprestg", layout_cell = "d8xsesdclamprestg"},



     {schematic_cell = "d87sesdclampcaptg1", layout_cell = "d87sesdclampcaptg1"},
     {schematic_cell = "d87sesdclampcaptg2", layout_cell = "d87sesdclampcaptg2"},
 
     {schematic_cell = "d87sesdclampres", layout_cell = "d87sesdclampres"},
     {schematic_cell = "d87sesdclamprestg", layout_cell = "d87sesdclamprestg"},


     {schematic_cell = "d88sesdclampcaptg1", layout_cell = "d88sesdclampcaptg1"},
     {schematic_cell = "d88sesdclampcaptg2", layout_cell = "d88sesdclampcaptg2"},
 
     {schematic_cell = "d88sesdclampres", layout_cell = "d88sesdclampres"},
     {schematic_cell = "d88sesdclamprestg", layout_cell = "d88sesdclamprestg"},



     {schematic_cell = "d80sesdclampcaptg1", layout_cell = "d80sesdclampcaptg1"},
     {schematic_cell = "d80sesdclampcaptg2", layout_cell = "d80sesdclampcaptg2"},
 
     {schematic_cell = "d80sesdclampres", layout_cell = "d80sesdclampres"},
     {schematic_cell = "d80sesdclamprestg", layout_cell = "d80sesdclamprestg"},	 
     
     {schematic_cell = "d8xsesdclampdnwres", layout_cell = "d8xsesdclampdnwres"},  // hsd 2847
     {schematic_cell = "d8xsesdclampdnwcaptgehv", layout_cell = "d8xsesdclampdnwcaptgehv"}, // hsd 2847

     // metal finger caps
     // d8lib
     {schematic_cell = "d8xsmfcevm4a", layout_cell = "d8xsmfcevm4a"},
     {schematic_cell = "d8xsmfcevm4b", layout_cell = "d8xsmfcevm4b"},
     {schematic_cell = "d8xsmfcevm4c", layout_cell = "d8xsmfcevm4c"},
     {schematic_cell = "d8xsmfcnvm4a", layout_cell = "d8xsmfcnvm4a"},
     {schematic_cell = "d8xsmfcnvm4b", layout_cell = "d8xsmfcnvm4b"},
     {schematic_cell = "d8xsmfcnvm4c", layout_cell = "d8xsmfcnvm4c"},
     {schematic_cell = "d8xsmfcnvm6a", layout_cell = "d8xsmfcnvm6a"},
     {schematic_cell = "d8xsmfcnvm6b", layout_cell = "d8xsmfcnvm6b"},
     {schematic_cell = "d8xsmfcnvm6c", layout_cell = "d8xsmfcnvm6c"},
     {schematic_cell = "d8xsmfcnvm6alp", layout_cell = "d8xsmfcnvm6alp"},
     {schematic_cell = "d8xsmfctguvm4a", layout_cell = "d8xsmfctguvm4a"},
     {schematic_cell = "d8xsmfctguvm4b", layout_cell = "d8xsmfctguvm4b"},
     {schematic_cell = "d8xsmfctguvm4c", layout_cell = "d8xsmfctguvm4c"},
     {schematic_cell = "d8xsmfcnvm7apll", layout_cell = "d8xsmfcnvm7apll"},
     {schematic_cell = "d8xsesdclampcap", layout_cell = "d8xsesdclampcap"},
     {schematic_cell = "d8xsesdclampcaptgehv", layout_cell = "d8xsesdclampcaptgehv"},
     {schematic_cell = "d8xsmfctguvm4acfio", layout_cell = "d8xsmfctguvm4acfio"},
     {schematic_cell = "d8xsmfcnvm4ap25pll", layout_cell = "d8xsmfcnvm4ap25pll"},
     {schematic_cell = "d8xsesdclampcaptguhv", layout_cell = "d8xsesdclampcaptguhv"},

     {schematic_cell = "d8xxmfcnvm4a", layout_cell = "d8xxmfcnvm4a"},
     {schematic_cell = "d8xxmfcnvm4b", layout_cell = "d8xxmfcnvm4b"},
     {schematic_cell = "d8xxmfcnvm4c", layout_cell = "d8xxmfcnvm4c"},
     {schematic_cell = "d8xxmfcnvm6a", layout_cell = "d8xxmfcnvm6a"},
     {schematic_cell = "d8xxmfcnvm6b", layout_cell = "d8xxmfcnvm6b"},
     {schematic_cell = "d8xxmfcnvm6c", layout_cell = "d8xxmfcnvm6c"},
     {schematic_cell = "d8xsmfcevm3d", layout_cell = "d8xsmfcevm3d"},
     {schematic_cell = "d8xsmfcnvm3d", layout_cell = "d8xsmfcnvm3d"},	 
     {schematic_cell = "d8xsmfcnvm5d", layout_cell = "d8xsmfcnvm5d"},
     {schematic_cell = "d8xsmfctguvm3d",layout_cell = "d8xsmfctguvm3d"},
     {schematic_cell = "d8xxmfcnvm3d", layout_cell = "d8xxmfcnvm3d"},	 
     {schematic_cell = "d8xxmfcnvm5d", layout_cell = "d8xxmfcnvm5d"},	 	 


     {schematic_cell = "d87smfcevm4a", layout_cell = "d87smfcevm4a"},
     {schematic_cell = "d87smfcevm4b", layout_cell = "d87smfcevm4b"},
     {schematic_cell = "d87smfcevm4c", layout_cell = "d87smfcevm4c"},
     {schematic_cell = "d87smfcnvm4a", layout_cell = "d87smfcnvm4a"},
     {schematic_cell = "d87smfcnvm4b", layout_cell = "d87smfcnvm4b"},
     {schematic_cell = "d87smfcnvm4c", layout_cell = "d87smfcnvm4c"},
     {schematic_cell = "d87smfcnvm6a", layout_cell = "d87smfcnvm6a"},
     {schematic_cell = "d87smfcnvm6b", layout_cell = "d87smfcnvm6b"},
     {schematic_cell = "d87smfcnvm6c", layout_cell = "d87smfcnvm6c"},
     {schematic_cell = "d87smfcnvm6alp", layout_cell = "d87smfcnvm6alp"},
     {schematic_cell = "d87smfctguvm4a", layout_cell = "d87smfctguvm4a"},
     {schematic_cell = "d87smfctguvm4b", layout_cell = "d87smfctguvm4b"},
     {schematic_cell = "d87smfctguvm4c", layout_cell = "d87smfctguvm4c"},
     {schematic_cell = "d87smfcnvm7apll", layout_cell = "d87smfcnvm7apll"},
     {schematic_cell = "d87sesdclampcap", layout_cell = "d87sesdclampcap"},
     {schematic_cell = "d87sesdclampcaptgehv", layout_cell = "d87sesdclampcaptgehv"},
     {schematic_cell = "d87smfctguvm4acfio", layout_cell = "d87smfctguvm4acfio"},
     {schematic_cell = "d87smfcnvm4ap25pll", layout_cell = "d87smfcnvm4ap25pll"},
     {schematic_cell = "d87sesdclampcaptguhv", layout_cell = "d87sesdclampcaptguhv"},

     {schematic_cell = "d87xmfcnvm4a", layout_cell = "d87xmfcnvm4a"},
     {schematic_cell = "d87xmfcnvm4b", layout_cell = "d87xmfcnvm4b"},
     {schematic_cell = "d87xmfcnvm4c", layout_cell = "d87xmfcnvm4c"},
     {schematic_cell = "d87xmfcnvm6a", layout_cell = "d87xmfcnvm6a"},
     {schematic_cell = "d87xmfcnvm6b", layout_cell = "d87xmfcnvm6b"},
     {schematic_cell = "d87xmfcnvm6c", layout_cell = "d87xmfcnvm6c"},
     {schematic_cell = "d87xmfcnvm5d", layout_cell = "d87xmfcnvm5d"},	 	 
     {schematic_cell = "d87xmfcnvm3d", layout_cell = "d87xmfcnvm3d"},	 
     {schematic_cell = "d87smfctguvm3d",layout_cell = "d87smfctguvm3d"},
     {schematic_cell = "d87smfcnvm5d", layout_cell = "d87smfcnvm5d"},
     {schematic_cell = "d87smfcnvm3d", layout_cell = "d87smfcnvm3d"},	 
     {schematic_cell = "d87smfcevm3d", layout_cell = "d87smfcevm3d"},
     {schematic_cell = "d87smfcnvm7d", layout_cell = "d87smfcnvm7d"}, // from tao


     {schematic_cell = "d88smfcevm4a", layout_cell = "d88smfcevm4a"},
     {schematic_cell = "d88smfcevm4b", layout_cell = "d88smfcevm4b"},
     {schematic_cell = "d88smfcevm4c", layout_cell = "d88smfcevm4c"},
     {schematic_cell = "d88smfcnvm4a", layout_cell = "d88smfcnvm4a"},
     {schematic_cell = "d88smfcnvm4b", layout_cell = "d88smfcnvm4b"},
     {schematic_cell = "d88smfcnvm4c", layout_cell = "d88smfcnvm4c"},
     {schematic_cell = "d88smfcnvm6a", layout_cell = "d88smfcnvm6a"},
     {schematic_cell = "d88smfcnvm6b", layout_cell = "d88smfcnvm6b"},
     {schematic_cell = "d88smfcnvm6c", layout_cell = "d88smfcnvm6c"},
     {schematic_cell = "d88smfcnvm6alp", layout_cell = "d88smfcnvm6alp"},
     {schematic_cell = "d88smfctguvm4a", layout_cell = "d88smfctguvm4a"},
     {schematic_cell = "d88smfctguvm4b", layout_cell = "d88smfctguvm4b"},
     {schematic_cell = "d88smfctguvm4c", layout_cell = "d88smfctguvm4c"},
     {schematic_cell = "d88smfcnvm7apll", layout_cell = "d88smfcnvm7apll"},
     {schematic_cell = "d88sesdclampcap", layout_cell = "d88sesdclampcap"},
     {schematic_cell = "d88sesdclampcaptgehv", layout_cell = "d88sesdclampcaptgehv"},
     {schematic_cell = "d88smfctguvm4acfio", layout_cell = "d88smfctguvm4acfio"},
     {schematic_cell = "d88smfcnvm4ap25pll", layout_cell = "d88smfcnvm4ap25pll"},
     {schematic_cell = "d88sesdclampcaptguhv", layout_cell = "d88sesdclampcaptguhv"},

     {schematic_cell = "d88xmfcnvm4a", layout_cell = "d88xmfcnvm4a"},
     {schematic_cell = "d88xmfcnvm4b", layout_cell = "d88xmfcnvm4b"},
     {schematic_cell = "d88xmfcnvm4c", layout_cell = "d88xmfcnvm4c"},
     {schematic_cell = "d88xmfcnvm6a", layout_cell = "d88xmfcnvm6a"},
     {schematic_cell = "d88xmfcnvm6b", layout_cell = "d88xmfcnvm6b"},
     {schematic_cell = "d88xmfcnvm6c", layout_cell = "d88xmfcnvm6c"},
     {schematic_cell = "d88xmfcnvm5d", layout_cell = "d88xmfcnvm5d"},
     {schematic_cell = "d88xmfcnvm3d", layout_cell = "d88xmfcnvm3d"},	 
     {schematic_cell = "d88smfctguvm3d",layout_cell = "d88smfctguvm3d"},
     {schematic_cell = "d88smfcnvm5d", layout_cell = "d88smfcnvm5d"},
     {schematic_cell = "d88smfcnvm3d", layout_cell = "d88smfcnvm3d"},	 
     {schematic_cell = "d88smfcevm3d", layout_cell = "d88smfcevm3d"},
     {schematic_cell = "d88sdcpiptgevm4v2", layout_cell = "d88sdcpiptgevm4v2"},
     {schematic_cell = "d88sdcpiptgevm2v2", layout_cell = "d88sdcpiptgevm2v2"},

 {schematic_cell = "d80smfcevm4a", layout_cell = "d80smfcevm4a"},
     {schematic_cell = "d80smfcevm4b", layout_cell = "d80smfcevm4b"},
     {schematic_cell = "d80smfcevm4c", layout_cell = "d80smfcevm4c"},
     {schematic_cell = "d80smfcnvm4a", layout_cell = "d80smfcnvm4a"},
     {schematic_cell = "d80smfcnvm4b", layout_cell = "d80smfcnvm4b"},
     {schematic_cell = "d80smfcnvm4c", layout_cell = "d80smfcnvm4c"},
     {schematic_cell = "d80smfcnvm6a", layout_cell = "d80smfcnvm6a"},
     {schematic_cell = "d80smfcnvm6b", layout_cell = "d80smfcnvm6b"},
     {schematic_cell = "d80smfcnvm6c", layout_cell = "d80smfcnvm6c"},
     {schematic_cell = "d80smfcnvm6alp", layout_cell = "d80smfcnvm6alp"},
     {schematic_cell = "d80smfctguvm4a", layout_cell = "d80smfctguvm4a"},
     {schematic_cell = "d80smfctguvm4b", layout_cell = "d80smfctguvm4b"},
     {schematic_cell = "d80smfctguvm4c", layout_cell = "d80smfctguvm4c"},
     {schematic_cell = "d80smfcnvm7apll", layout_cell = "d80smfcnvm7apll"},
     {schematic_cell = "d80sesdclampcap", layout_cell = "d80sesdclampcap"},
     {schematic_cell = "d80sesdclampcaptgehv", layout_cell = "d80sesdclampcaptgehv"},
     {schematic_cell = "d80smfctguvm4acfio", layout_cell = "d80smfctguvm4acfio"},
     {schematic_cell = "d80smfcnvm4ap25pll", layout_cell = "d80smfcnvm4ap25pll"},
     {schematic_cell = "d80sesdclampcaptguhv", layout_cell = "d80sesdclampcaptguhv"},

     {schematic_cell = "d80xmfcnvm4a", layout_cell = "d80xmfcnvm4a"},
     {schematic_cell = "d80xmfcnvm4b", layout_cell = "d80xmfcnvm4b"},
     {schematic_cell = "d80xmfcnvm4c", layout_cell = "d80xmfcnvm4c"},
     {schematic_cell = "d80xmfcnvm6a", layout_cell = "d80xmfcnvm6a"},
     {schematic_cell = "d80xmfcnvm6b", layout_cell = "d80xmfcnvm6b"},
     {schematic_cell = "d80xmfcnvm6c", layout_cell = "d80xmfcnvm6c"},	 
	 {schematic_cell = "d80xmfcnvm5d", layout_cell = "d80xmfcnvm5d"},	 
     {schematic_cell = "d80xmfcnvm3d", layout_cell = "d80xmfcnvm3d"},	 
     {schematic_cell = "d80smfctguvm3d",layout_cell = "d80smfctguvm3d"},
     {schematic_cell = "d80smfcnvm5d", layout_cell = "d80smfcnvm5d"},
     {schematic_cell = "d80smfcnvm3d", layout_cell = "d80smfcnvm3d"},	 
     {schematic_cell = "d80smfcevm3d", layout_cell = "d80smfcevm3d"},
	 
	 // hsd 1228
     {schematic_cell = "d8xsmfcnvm6adiff", layout_cell = "d8xsmfcnvm6adiff"},

     {schematic_cell = "d87smfcnvm6adiff", layout_cell = "d87smfcnvm6adiff"},
     {schematic_cell = "d88smfcnvm6adiff", layout_cell = "d88smfcnvm6adiff"},
     {schematic_cell = "d80smfcnvm6adiff", layout_cell = "d80smfcnvm6adiff"},
     // hsd 1702
     {schematic_cell = "d86smfcnvm6a", layout_cell = "d86smfcnvm6a"},
     {schematic_cell = "d86smfcnvm6alp", layout_cell = "d86smfcnvm6alp"},
     {schematic_cell = "d86smfcnvm6b", layout_cell = "d86smfcnvm6b"},
     {schematic_cell = "d86smfcnvm6c", layout_cell = "d86smfcnvm6c"},
     {schematic_cell = "d86smfcevm6a", layout_cell = "d86smfcevm6a"},
     {schematic_cell = "d86smfcevm6b", layout_cell = "d86smfcevm6b"},
     {schematic_cell = "d86smfcevm6c", layout_cell = "d86smfcevm6c"},
     {schematic_cell = "d86smfcnvm7apll", layout_cell = "d86smfcnvm7apll"},
     {schematic_cell = "d86xmfcnvm6a", layout_cell = "d86xmfcnvm6a"},
     {schematic_cell = "d86xmfcnvm6b", layout_cell = "d86xmfcnvm6b"},
     {schematic_cell = "d86xmfcnvm6c", layout_cell = "d86xmfcnvm6c"},


     
	 // hsd 2037
     {schematic_cell = "d86smfcevm4aulc", layout_cell = "d86smfcevm4aulc"},
     {schematic_cell = "d86smfcevm7a", layout_cell = "d86smfcevm7a"},
     {schematic_cell = "d86smfcevm7b", layout_cell = "d86smfcevm7b"},
     {schematic_cell = "d86smfcevm7c", layout_cell = "d86smfcevm7c"},
     {schematic_cell = "d86smfcnvm4aulc", layout_cell = "d86smfcnvm4aulc"},
     {schematic_cell = "d86smfcnvm7a", layout_cell = "d86smfcnvm7a"},
     {schematic_cell = "d86smfcnvm7b", layout_cell = "d86smfcnvm7b"},
     {schematic_cell = "d86smfcnvm7c", layout_cell = "d86smfcnvm7c"},
   
	 
	 // hsd 2290
     {schematic_cell = "d86smfcnvm7alp", layout_cell = "d86smfcnvm7alp"},
     {schematic_cell = "d86smfcevm7aulc", layout_cell = "d86smfcevm7aulc"},
     // hsd 2902
     {schematic_cell = "d86smfcevm7alp", layout_cell = "d86smfcevm7alp"},
	  
     // hybrid decaps 
     // assume the cap part is in the *_METAL cell and active devices in the base cell 
     // that is why sub cell is the bb element
     // d8lib 
     {schematic_cell = "d8xsdcpipnvm2", layout_cell = "d8xsdcpipnvm2"},
     {schematic_cell = "d8xsdcpipnvm4", layout_cell = "d8xsdcpipnvm4"},
     {schematic_cell = "d8xsdcpipnvm4e", layout_cell = "d8xsdcpipnvm4e"},
     {schematic_cell = "d8xsdcpipnvm6s", layout_cell = "d8xsdcpipnvm6s"},
     {schematic_cell = "d8xsdcpintgevm2", layout_cell = "d8xsdcpintgevm2"},
     {schematic_cell = "d8xsdcpintgevm4", layout_cell = "d8xsdcpintgevm4"},


     {schematic_cell = "d87sdcpipnvm2", layout_cell = "d87sdcpipnvm2"},
     {schematic_cell = "d87sdcpipnvm4", layout_cell = "d87sdcpipnvm4"},
     {schematic_cell = "d87sdcpipnvm4e", layout_cell = "d87sdcpipnvm4e"},
     {schematic_cell = "d87sdcpipnvm6s", layout_cell = "d87sdcpipnvm6s"},
     {schematic_cell = "d87sdcpintgevm2", layout_cell = "d87sdcpintgevm2"},
     {schematic_cell = "d87sdcpintgevm4", layout_cell = "d87sdcpintgevm4"},


     {schematic_cell = "d88sdcpipnvm2", layout_cell = "d88sdcpipnvm2"},
     {schematic_cell = "d88sdcpipnvm4", layout_cell = "d88sdcpipnvm4"},
     {schematic_cell = "d88sdcpipnvm4e", layout_cell = "d88sdcpipnvm4e"},
     {schematic_cell = "d88sdcpipnvm6s", layout_cell = "d88sdcpipnvm6s"},
     {schematic_cell = "d88sdcpintgevm2", layout_cell = "d88sdcpintgevm2"},
     {schematic_cell = "d88sdcpintgevm4", layout_cell = "d88sdcpintgevm4"},


     {schematic_cell = "d80sdcpipnvm2", layout_cell = "d80sdcpipnvm2"},
     {schematic_cell = "d80sdcpipnvm4", layout_cell = "d80sdcpipnvm4"},
     {schematic_cell = "d80sdcpipnvm4e", layout_cell = "d80sdcpipnvm4e"},
     {schematic_cell = "d80sdcpipnvm6s", layout_cell = "d80sdcpipnvm6s"},
     {schematic_cell = "d80sdcpintgevm2", layout_cell = "d80sdcpintgevm2"},
     {schematic_cell = "d80sdcpintgevm4", layout_cell = "d80sdcpintgevm4"},	 
// hsd 2297     {schematic_cell = "d8xsdcpiptgevm2", layout_cell = "d8xsdcpiptgevm2"},
// hsd 2297     {schematic_cell = "d8xsdcpiptgevm4", layout_cell = "d8xsdcpiptgevm4"},
     // hsd 2282
     {schematic_cell = "d8xsdcpintgevm2_s2s", layout_cell = "d8xsdcpintgevm2_s2s"},
     {schematic_cell = "d8xsdcpintgevm4_s2s", layout_cell = "d8xsdcpintgevm4_s2s"},

     {schematic_cell = "d8xxdcpipnvm2", layout_cell = "d8xxdcpipnvm2"},
     {schematic_cell = "d8xxdcpipnvm4", layout_cell = "d8xxdcpipnvm4"},
	 
     {schematic_cell = "d87sdcpintgevm2_s2s", layout_cell = "d87sdcpintgevm2_s2s"},
     {schematic_cell = "d87sdcpintgevm4_s2s", layout_cell = "d87sdcpintgevm4_s2s"},

     {schematic_cell = "d87xdcpipnvm2", layout_cell = "d87xdcpipnvm2"},
     {schematic_cell = "d87xdcpipnvm4", layout_cell = "d87xdcpipnvm4"},

     {schematic_cell = "d88sdcpintgevm2_s2s", layout_cell = "d88sdcpintgevm2_s2s"},
     {schematic_cell = "d88sdcpintgevm4_s2s", layout_cell = "d88sdcpintgevm4_s2s"},

     {schematic_cell = "d88xdcpipnvm2", layout_cell = "d88xdcpipnvm2"},
     {schematic_cell = "d88xdcpipnvm4", layout_cell = "d88xdcpipnvm4"},


     {schematic_cell = "d80sdcpintgevm2_s2s", layout_cell = "d80sdcpintgevm2_s2s"},
     {schematic_cell = "d80sdcpintgevm4_s2s", layout_cell = "d80sdcpintgevm4_s2s"},	

     {schematic_cell = "d80xdcpipnvm2", layout_cell = "d80xdcpipnvm2"},
     {schematic_cell = "d80xdcpipnvm4", layout_cell = "d80xdcpipnvm4"},
	 // hsd 1431 
     {schematic_cell = "d8xxdcpiphvm2", layout_cell = "d8xxdcpiphvm2"},
     {schematic_cell = "d8xxdcpipnvm4p5", layout_cell = "d8xxdcpipnvm4p5"},
     {schematic_cell = "d8xxdcpipnvm2p5", layout_cell = "d8xxdcpipnvm2p5"},

     {schematic_cell = "d87xdcpiphvm2", layout_cell = "d87xdcpiphvm2"},
     {schematic_cell = "d87xdcpipnvm4p5", layout_cell = "d87xdcpipnvm4p5"},
     {schematic_cell = "d87xdcpipnvm2p5", layout_cell = "d87xdcpipnvm2p5"},

     {schematic_cell = "d88xdcpiphvm2", layout_cell = "d88xdcpiphvm2"},
     {schematic_cell = "d88xdcpipnvm4p5", layout_cell = "d88xdcpipnvm4p5"},
     {schematic_cell = "d88xdcpipnvm2p5", layout_cell = "d88xdcpipnvm2p5"},

     {schematic_cell = "d80xdcpiphvm2", layout_cell = "d80xdcpiphvm2"},
     {schematic_cell = "d80xdcpipnvm4p5", layout_cell = "d80xdcpipnvm4p5"},
     {schematic_cell = "d80xdcpipnvm2p5", layout_cell = "d80xdcpipnvm2p5"},


	 
     // hsd 1702
     {schematic_cell = "d86sdcpipnvm6s", layout_cell = "d86sdcpipnvm6s"},

     // black box macros from tripti but not templates for tuc
	 // next 4 hsd 621917 ; now wants parents also in tuc flow tripti
     {schematic_cell = "d8xxrtcnevm2vtunpci_base", layout_cell = "d8xxrtcnevm2vtunpci_base"},
     {schematic_cell = "d8xxrtcnevm2vtunddrstat_base", layout_cell = "d8xxrtcnevm2vtunddrstat_base"},
     {schematic_cell = "d8xxrtcnevm2vtunddrcmd_base", layout_cell = "d8xxrtcnevm2vtunddrcmd_base"},
     {schematic_cell = "d8xxrtcnevm2vtunddrdyn_base", layout_cell = "d8xxrtcnevm2vtunddrdyn_base"},


     {schematic_cell = "d87xrtcnevm2vtunpci_base", layout_cell = "d87xrtcnevm2vtunpci_base"},
     {schematic_cell = "d87xrtcnevm2vtunddrstat_base", layout_cell = "d87xrtcnevm2vtunddrstat_base"},
     {schematic_cell = "d87xrtcnevm2vtunddrcmd_base", layout_cell = "d87xrtcnevm2vtunddrcmd_base"},
     {schematic_cell = "d87xrtcnevm2vtunddrdyn_base", layout_cell = "d87xrtcnevm2vtunddrdyn_base"},


     {schematic_cell = "d88xrtcnevm2vtunpci_base", layout_cell = "d88xrtcnevm2vtunpci_base"},
     {schematic_cell = "d88xrtcnevm2vtunddrstat_base", layout_cell = "d88xrtcnevm2vtunddrstat_base"},
     {schematic_cell = "d88xrtcnevm2vtunddrcmd_base", layout_cell = "d88xrtcnevm2vtunddrcmd_base"},
     {schematic_cell = "d88xrtcnevm2vtunddrdyn_base", layout_cell = "d88xrtcnevm2vtunddrdyn_base"},

     {schematic_cell = "d80xrtcnevm2vtunpci_base", layout_cell = "d80xrtcnevm2vtunpci_base"},
     {schematic_cell = "d80xrtcnevm2vtunddrstat_base", layout_cell = "d80xrtcnevm2vtunddrstat_base"},
     {schematic_cell = "d80xrtcnevm2vtunddrcmd_base", layout_cell = "d80xrtcnevm2vtunddrcmd_base"},
     {schematic_cell = "d80xrtcnevm2vtunddrdyn_base", layout_cell = "d80xrtcnevm2vtunddrdyn_base"}, 

     {schematic_cell = "x73btsvccsymb", layout_cell = "x73btsvccsymb"},
     // tsv catch-cup as per kalyan
   {schematic_cell = "d8xltsv_ccsymb", layout_cell = "d8xltsv_ccsymb"},
   {schematic_cell = "d87ltsv_ccsymb", layout_cell = "d87ltsv_ccsymb"},
   {schematic_cell = "d88ltsv_ccsymb", layout_cell = "d88ltsv_ccsymb"},
   {schematic_cell = "d80ltsv_ccsymb", layout_cell = "d80ltsv_ccsymb"},
     
     // scr cells hsd 1861
     {schematic_cell = "d8xsesdscrevm1", layout_cell = "d8xsesdscrevm1"},
     {schematic_cell = "d8xsesdscruvm1", layout_cell = "d8xsesdscruvm1"},
     {schematic_cell = "d8xsesdscrevm1_prim", layout_cell = "d8xsesdscrevm1_prim"},
     {schematic_cell = "d8xsesdscruvm1_prim", layout_cell = "d8xsesdscruvm1_prim"},

     {schematic_cell = "d87sesdscrevm1", layout_cell = "d87sesdscrevm1"},
     {schematic_cell = "d87sesdscruvm1", layout_cell = "d87sesdscruvm1"},
     {schematic_cell = "d87sesdscrevm1_prim", layout_cell = "d87sesdscrevm1_prim"},
     {schematic_cell = "d87sesdscruvm1_prim", layout_cell = "d87sesdscruvm1_prim"},
     {schematic_cell = "d87sesdscrevm1_dnw", layout_cell = "d87sesdscrevm1_dnw"},  //only for dot7
     {schematic_cell =  "d87sesdscruvm1_dnw", layout_cell = "d87sesdscruvm1_dnw"}, //only for dot7	 
     // from tao
     {schematic_cell = "d87sesdscrevm1_prim_dnw", layout_cell = "d87sesdscrevm1_prim_dnw"},  //only for dot7
     {schematic_cell = "d87sesdscruvm1_prim_dnw", layout_cell = "d87sesdscruvm1_prim_dnw"}, //only for dot7	 


     {schematic_cell = "d88sesdscrevm1", layout_cell = "d88sesdscrevm1"},
     {schematic_cell = "d88sesdscruvm1", layout_cell = "d88sesdscruvm1"},


     {schematic_cell = "d80sesdscrevm1", layout_cell = "d80sesdscrevm1"},
     {schematic_cell = "d80sesdscruvm1", layout_cell = "d80sesdscruvm1"},	 
	 	 
	 
     // hsd 2219 diode templates
     {schematic_cell = "d8xmbgdiodehvm1", layout_cell = "d8xmbgdiodehvm1"},
     {schematic_cell = "d8xsesddnuvterm", layout_cell = "d8xsesddnuvterm"},
     {schematic_cell = "d8xsesddpuvterm", layout_cell = "d8xsesddpuvterm"},


     {schematic_cell = "d87mbgdiodehvm1", layout_cell = "d87mbgdiodehvm1"},
     {schematic_cell = "d87sesddnuvterm", layout_cell = "d87sesddnuvterm"},
     {schematic_cell = "d87sesddpuvterm", layout_cell = "d87sesddpuvterm"},

     {schematic_cell = "d88mbgdiodehvm1", layout_cell = "d88mbgdiodehvm1"},
     {schematic_cell = "d88sesddnuvterm", layout_cell = "d88sesddnuvterm"},
     {schematic_cell = "d88sesddpuvterm", layout_cell = "d88sesddpuvterm"},

      {schematic_cell = "d80mbgdiodehvm1", layout_cell = "d80mbgdiodehvm1"},
     {schematic_cell = "d80sesddnuvterm", layout_cell = "d80sesddnuvterm"},
     {schematic_cell = "d80sesddpuvterm", layout_cell = "d80sesddpuvterm"}, 
	 

     // antifuse cells
     {schematic_cell = "x73p00fcary1ne_1c_0", layout_cell = "x73p00fcary1ne_1c_0"},
     {schematic_cell = "x73p00fcary1ne_1c_1", layout_cell = "x73p00fcary1ne_1c_1"},
     {schematic_cell = "x73p00fcary1ne_1c_2", layout_cell = "x73p00fcary1ne_1c_2"},
     {schematic_cell = "x73p00fcary1ne_1c_3", layout_cell = "x73p00fcary1ne_1c_3"},
     {schematic_cell = "x73p00fcary1ne_1c_4", layout_cell = "x73p00fcary1ne_1c_4"},
     {schematic_cell = "x73p00fcary1ne_1c_5", layout_cell = "x73p00fcary1ne_1c_5"},
     {schematic_cell = "x73p00fcary1ne_1c_6", layout_cell = "x73p00fcary1ne_1c_6"}

   #endif  // end of case sensitive

   // allow open access users to easily include the lvs black box mods
   #if VERSION_GE(2010,12,1,0)
      #ifdef _drOALayerMappingFile 
         #include <userOpenAccessLVSblackbox>
      #endif
   #endif

   },
   equate_ports = { }  // by being blank - should work like hercules 
);

// 
// resistor templates with swappable ports
#if (_drCaseSensitive == _drNO) // UPPERCASE
    lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D8XSRCPRTGUVM2A_BASE", layout_cell = "D8XSRCPRTGUVM2A_BASE"}
   
      },
  

      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D87SRCPRTGUVM2A_BASE", layout_cell = "D87SRCPRTGUVM2A_BASE"}
   
      },
  

      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D88SRCPRTGUVM2A_BASE", layout_cell = "D88SRCPRTGUVM2A_BASE"}
   
      },
  

      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D80SRCPRTGUVM2A_BASE", layout_cell = "D80SRCPRTGUVM2A_BASE"}
   
      },
  

      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
  lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D8XSRCPRTGUVM2B_BASE", layout_cell = "D8XSRCPRTGUVM2B_BASE"}
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
   lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D87SRCPRTGUVM2B_BASE", layout_cell = "D87SRCPRTGUVM2B_BASE"}
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
   lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D88SRCPRTGUVM2B_BASE", layout_cell = "D88SRCPRTGUVM2B_BASE"}
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
   lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D80SRCPRTGUVM2B_BASE", layout_cell = "D80SRCPRTGUVM2B_BASE"}
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );
          
   lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D8XSRCPRTGUVM2C_BASE", layout_cell = "D8XSRCPRTGUVM2C_BASE"} 
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );

lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D87SRCPRTGUVM2C_BASE", layout_cell = "D87SRCPRTGUVM2C_BASE"} 
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );

 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D88SRCPRTGUVM2C_BASE", layout_cell = "D88SRCPRTGUVM2C_BASE"} 
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   );

 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "D80SRCPRTGUVM2C_BASE", layout_cell = "D80SRCPRTGUVM2C_BASE"} 
      },
      schematic_swappable_ports = { {"S1_UHV", "S2_UHV"} }
   ); 
    lvs_black_box_options(
         equiv_cells = {     
        {schematic_cell = "D8XSRTCNUVM2VTUN_BASE", layout_cell = "D8XSRTCNUVM2VTUN_BASE"}
      },
      schematic_swappable_ports = { {"N1_UHV", "N2_UHV"} }
   );
  lvs_black_box_options(
         equiv_cells = {     
        {schematic_cell = "D87SRTCNUVM2VTUN_BASE", layout_cell = "D87SRTCNUVM2VTUN_BASE"}
      },
      schematic_swappable_ports = { {"N1_UHV", "N2_UHV"} }
   );
lvs_black_box_options(
         equiv_cells = {     
        {schematic_cell = "D88SRTCNUVM2VTUN_BASE", layout_cell = "D88SRTCNUVM2VTUN_BASE"}
      },
      schematic_swappable_ports = { {"N1_UHV", "N2_UHV"} }
   );
lvs_black_box_options(
         equiv_cells = {     
        {schematic_cell = "D80SRTCNUVM2VTUN_BASE", layout_cell = "D80SRTCNUVM2VTUN_BASE"}
      },
      schematic_swappable_ports = { {"N1_UHV", "N2_UHV"} }
   );

#else  // lowercase
  lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d8xsrcprtguvm2a_base", layout_cell = "d8xsrcprtguvm2a_base"}
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d87srcprtguvm2a_base", layout_cell = "d87srcprtguvm2a_base"}
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d88srcprtguvm2a_base", layout_cell = "d88srcprtguvm2a_base"}
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );

lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d80srcprtguvm2a_base", layout_cell = "d80srcprtguvm2a_base"}
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
   lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d8xsrcprtguvm2b_base", layout_cell = "d8xsrcprtguvm2b_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d87srcprtguvm2b_base", layout_cell = "d87srcprtguvm2b_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d88srcprtguvm2b_base", layout_cell = "d88srcprtguvm2b_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d80srcprtguvm2b_base", layout_cell = "d80srcprtguvm2b_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
    lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d8xsrcprtguvm2c_base", layout_cell = "d8xsrcprtguvm2c_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );

 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d87srcprtguvm2c_base", layout_cell = "d87srcprtguvm2c_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );
 lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d88srcprtguvm2c_base", layout_cell = "d88srcprtguvm2c_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );

  lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d80srcprtguvm2c_base", layout_cell = "d80srcprtguvm2c_base"} 
      },
      schematic_swappable_ports = { {"s1_uhv", "s2_uhv"} }
   );  
   lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d8xsrtcnuvm2vtun_base", layout_cell = "d8xsrtcnuvm2vtun_base"}
      },
      schematic_swappable_ports = { {"n1_uhv", "n2_uhv"} }
   );
  lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d87srtcnuvm2vtun_base", layout_cell = "d87srtcnuvm2vtun_base"}
      },
      schematic_swappable_ports = { {"n1_uhv", "n2_uhv"} }
   );
  lvs_black_box_options(
      equiv_cells = {     
        {schematic_cell = "d88srtcnuvm2vtun_base", layout_cell = "d88srtcnuvm2vtun_base"}
      },
      schematic_swappable_ports = { {"n1_uhv", "n2_uhv"} }
   );
  lvs_black_box_options(
      equiv_cells = {     
	  {schematic_cell = "d80srtcnuvm2vtun_base", layout_cell = "d80srtcnuvm2vtun_base"}
      },
      schematic_swappable_ports = { {"n1_uhv", "n2_uhv"} }
   );
#endif   // case

// include the HIP(hard ip) blackbox file  
#include <HIPBlackBox>

// include the user/project blackbox file - always created by pds may be empty
#include <userProject_blackbox>

#endif  // end ifdef 
